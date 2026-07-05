#!/usr/bin/env node
/* Batch card compiler — runs the workbench reference implementation
   (js/workbench.js, COMPILER_SPEC.md) headlessly over every generated plan.

   INPUT   data/plans/<plan_id>.json     js/workbench-content.js (regenerate first:
                                         python3 tools/generate-content-bundle.py)
   OUTPUT  benefit-cards/<plan_id>.json  (CompiledPlanCards — benefit-card.types.ts)
           reports/<plan_id>.report.json
           reports/_aggregate.json       corpus totals + column-drift baseline

   Usage: node tools/compile_benefit_cards.mjs [--only H5425_123_0,...] [--admin-export rows.json]
*/
import { readFileSync, writeFileSync, readdirSync, mkdirSync } from "node:fs";
import { createHash as sha } from "node:crypto";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const DASH = join(dirname(fileURLToPath(import.meta.url)), "..");
const args = process.argv.slice(2);
const arg = (name) => { const i = args.indexOf(name); return i >= 0 ? args[i + 1] : null; };
const only = arg("--only") ? arg("--only").split(",") : null;

/* ---- browser shims: enough for workbench.js to load headlessly ---- */
const dummyEl = new Proxy({}, { get: (t, p) => (p === "style" ? {} : p === "addEventListener" ? () => {} : ""), set: () => true });
const win = {};
win.window = win;
win.document = { getElementById: () => dummyEl };
win.fetch = () => Promise.reject(new Error("headless"));
win.setTimeout = () => {};

const contentSrc = readFileSync(join(DASH, "js/workbench-content.js"), "utf-8");
const wbSrc = readFileSync(join(DASH, "js/workbench.js"), "utf-8");
new Function("window", "document", "fetch", "setTimeout", contentSrc)(win, win.document, win.fetch, win.setTimeout);
new Function("window", "document", "fetch", "setTimeout", wbSrc)(win, win.document, win.fetch, win.setTimeout);
const WB = win.WB;
if (!WB || !WB.compileFor) { console.error("workbench.js did not expose WB.compileFor"); process.exit(1); }

const contentRevision = sha("sha256").update(contentSrc).digest("hex").slice(0, 12);
const planYear = (win.WB_CONTENT.yearConstants || {}).planYear || new Date().getFullYear();
const generatedAt = new Date().toISOString();

/* ---- optional §4b admin-tool export (flat rows → grouped by pipeline plan id) ---- */
const adminRowsFlat = arg("--admin-export") ? JSON.parse(readFileSync(arg("--admin-export"), "utf-8")) : [];
const adminByPlan = {};
for (const r of adminRowsFlat) {
  const m = /^([HRES]\d{4})(\d{3})(\d{3})$/.exec(String(r.plan_id || "").trim());
  const pid = m ? `${m[1]}_${m[2]}_${parseInt(m[3], 10)}` : String(r.plan_id || "").trim();
  (adminByPlan[pid] = adminByPlan[pid] || []).push(r);
}

/* ---- transform workbench card -> BenefitCard (types.ts) ---- */
function toContractCard(c) {
  const card = {
    key: c.key, icon: c.icon || "", iconBg: c.iconBg, iconColor: c.iconColor, barColor: c.barColor,
    title: c.title, tagline: c.tagline || c.title, tileSubtitle: c.tileSubtitle || "",
    sections: (c.sections || []).map(s => ({
      icon: s.icon || c.icon || "",
      label: s.label,
      facts: (s.rows || []).map(r => {
        const f = { label: r.label, value: r.value, source: r.source || "pbp" };
        if (r.highlight) f.highlight = true;
        if (r.pbpPath) f.pbpPath = r.pbpPath.startsWith("drug_coverage") || r.pbpPath.startsWith("combined_benefits")
          ? r.pbpPath : "benefits." + r.pbpPath;
        if (r.citation) f.citation = r.citation;
        return f;
      }),
      ...(s.note ? { note: s.note } : {}),
      ...(s.chips && s.chips.length ? { chips: s.chips } : {}),
      ...(s.howToUse ? { howToUse: s.howToUse } : {}),
      ...(s.cta ? { cta: s.cta } : {}),
    })),
    connections: c.connections || [],
  };
  if (c.cta) card.cta = c.cta;
  if (c.vendor) card.vendor = c.vendor;
  if (c.requiresEligibility) card.requiresEligibility = c.requiresEligibility;
  if (c.eligibilityBanner) card.eligibilityBanner = c.eligibilityBanner;
  if (c.howToUse) card.howToUse = c.howToUse;
  if (c.note) card.note = c.note;
  return card;
}

/* ---- run ---- */
mkdirSync(join(DASH, "benefit-cards"), { recursive: true });
mkdirSync(join(DASH, "reports"), { recursive: true });
const planFiles = readdirSync(join(DASH, "data/plans")).filter(f => f.endsWith(".json"));
const ids = (only || planFiles.map(f => f.replace(/\.json$/, ""))).filter(id => !only || only.includes(id));

const agg = { plans: 0, build_failed: [], internal_errors: [], single_surface_leaks: [], cards_rendered_counts: {}, facts_dropped_reasons: {}, eligibility_gated_plans: 0 };
let t0 = Date.now();
for (const id of ids) {
  const plan = JSON.parse(readFileSync(join(DASH, "data/plans", id + ".json"), "utf-8"));
  const out = WB.compileFor(plan, id, adminByPlan[id] || []);
  const rep = out.report || {};

  if (out.errors && out.errors.length) agg.build_failed.push({ id, errors: out.errors });
  if (out.internalErrors && out.internalErrors.length) agg.internal_errors.push({ id, errors: out.internalErrors });
  (rep.single_surface || []).forEach(s => { if (!s.ok) agg.single_surface_leaks.push({ id, amount: s.amount, leaks: s.member_leaks }); });
  (rep.cards_rendered || []).forEach(k => { const key = k.startsWith("flexAllowance") ? "flexAllowance" : k; agg.cards_rendered_counts[key] = (agg.cards_rendered_counts[key] || 0) + 1; });
  (rep.facts_dropped || []).forEach(d => { agg.facts_dropped_reasons[d.reason] = (agg.facts_dropped_reasons[d.reason] || 0) + 1; });
  if ((out.cards || []).some(c => c.requiresEligibility)) agg.eligibility_gated_plans++;

  const compiled = {
    planId: id,
    planYear,
    planName: (plan.plan_info || {}).plan_name || "",
    orgMarketingName: (plan.plan_info || {}).org_marketing_name || "",
    dsnpZeroDollar: !!(plan.plan_info || {}).dsnp_zero_dollar,
    cards: (out.cards || []).map(toContractCard),
    build: { compilerVersion: "1.0.0", contentRevision, generatedAt },
  };
  writeFileSync(join(DASH, "benefit-cards", id + ".json"), JSON.stringify(compiled, null, 1));
  writeFileSync(join(DASH, "reports", id + ".report.json"), JSON.stringify(rep, null, 1));
  agg.plans++;
  if (agg.plans % 1000 === 0) console.log(`  ${agg.plans}/${ids.length}…`);
}
agg.elapsed_ms = Date.now() - t0;
agg.contentRevision = contentRevision;
agg.generatedAt = generatedAt;
writeFileSync(join(DASH, "reports/_aggregate.json"), JSON.stringify(agg, null, 1));
console.log(`compiled ${agg.plans} plans in ${(agg.elapsed_ms / 1000).toFixed(1)}s — build failures: ${agg.build_failed.length}, internal errors: ${agg.internal_errors.length}, single-surface leaks: ${agg.single_surface_leaks.length}`);
console.log("cards rendered:", JSON.stringify(agg.cards_rendered_counts));
