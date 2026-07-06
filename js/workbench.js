/* Benefits Hub — Carrier Onboarding Workbench (browser-only reference implementation
   of 01-architecture/COMPILER_SPEC.md). Coverage input: generated plan JSONs in data/;
   content input: window.WB_CONTENT (generated snapshot of 03-content) + in-app edits.
   PDFs attach as citation sources only — never parsed (spec non-goal). */
(function () {
  "use strict";
  const C = window.WB_CONTENT;
  const DOLLAR = /\$\s?\d/;
  const COINS_PCT = /^\d+(\.\d+)?%(\s*-\s*\d+(\.\d+)?%)?$/; // a bare coinsurance percentage
  // Provenance / QA / citation language that must NEVER reach a member-facing field
  // (rule 5). It belongs only in the internal "verification" field (never rendered,
  // never scanned here). Generalizes the SCAN-fitness one-off so no author can leak it.
  const PROVENANCE = /verified (against|per|via|in|by)|confirmed (in|via|against|per) (the )?(SB|EOC|summary of benefits|evidence of coverage)|per the (SB|EOC|summary of benefits|evidence of coverage)|\bsource:\s*(SB|EOC)\b|\bEOC (p\.|pg\.|page|chapter|ch\.|section)|\bSB (page|section|p\.)|internal provenance|do not (promote|render|ship)|pending (product )?approval|\d{2}C-[A-Z]{0,3}\d|SF20\d{6}/i;
  const ELIG_DEFAULT = "Available to members with a qualifying health condition. Your plan confirms your eligibility.";
  // Add thousands separators to 4+ digit dollar amounts and normalize allowance
  // period phrasing ("Every year" -> "per year") so member values read cleanly.
  function polishValue(s) {
    if (s == null) return s;
    return String(s)
      .replace(/\$(\d{4,})(?!\d)/g, (m, d) => "$" + Number(d).toLocaleString("en-US"))
      .replace(/\bEvery (year|month|quarter|week|day)\b/gi, "per $1")
      .replace(/\bEvery (\d+ [A-Za-z]+)\b/g, "every $1");
  }
  // HTML-escape any value interpolated into the phone-preview innerHTML: member/plan/
  // content text is untrusted (pasted admin blobs + CMS filing text can carry < & ").
  const esc = s => String(s == null ? "" : s).replace(/[&<>"']/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]));
  const state = {
    mode: null, summary: null, fileMap: null,
    plan: null, planId: null, carrier: null,
    docs: { sb: null, eoc: null },
    userPack: {},           // cardKey -> content override (acts as the carrier layer being authored)
    adminRows: [],          // §4b admin-tool vendor rows pasted into the workbench
    activeTab: "preview",
  };

  /* ---------- data access ---------- */
  async function init() {
    try {
      const r = await fetch("data/plans_summary.json");
      if (!r.ok) throw new Error(r.status);
      state.summary = await r.json();
      state.mode = "fetch";
      setSource(`✓ Serving mode — ${Object.keys(state.summary).length.toLocaleString()} plans loaded from data/plans_summary.json`);
    } catch (e) {
      state.mode = "files";
      setSource(`Opened from file:// — pick the dashboard <b>data</b> folder to load the plans: <input type="file" id="dirpick" webkitdirectory multiple style="margin-top:6px;">`);
      setTimeout(() => {
        const dp = document.getElementById("dirpick");
        if (dp) dp.addEventListener("change", onDirPick);
      }, 0);
    }
  }
  async function onDirPick(ev) {
    state.fileMap = {};
    for (const f of ev.target.files) {
      const rel = f.webkitRelativePath.split("/").slice(1).join("/"); // strip picked-dir name
      state.fileMap[rel] = f;
    }
    const sf = state.fileMap["plans_summary.json"];
    if (!sf) { setSource('<span class="err">plans_summary.json not found in that folder — pick the dashboard <b>data</b> directory.</span>'); return; }
    state.summary = JSON.parse(await sf.text());
    setSource(`✓ Folder mode — ${Object.keys(state.summary).length.toLocaleString()} plans loaded`);
  }
  async function loadPlanJSON(id) {
    if (state.mode === "fetch") {
      const r = await fetch(`data/plans/${id}.json`);
      if (!r.ok) throw new Error("plan file not found: " + id);
      return r.json();
    }
    const f = state.fileMap && state.fileMap[`plans/${id}.json`];
    if (!f) throw new Error("plan file not in picked folder: " + id);
    return JSON.parse(await f.text());
  }

  /* ---------- content stack ---------- */
  function carrierFor(hnum) { return (C.registry.contracts || {})[hnum] || null; }
  function mergeContent(base, over) {
    if (!over) return base ? JSON.parse(JSON.stringify(base)) : null;
    if (!base) return JSON.parse(JSON.stringify(over));
    const out = JSON.parse(JSON.stringify(base));
    for (const [k, v] of Object.entries(over)) {
      if (k === "sections" && Array.isArray(v) && Array.isArray(out.sections)) {
        v.forEach(sec => {
          const match = out.sections.find(s => s.label === sec.label);
          if (!match) { out.sections.push(sec); return; }
          (sec.facts || []).forEach(f => {
            const fm = (match.facts || []).find(x => x.label === f.label);
            if (fm) Object.assign(fm, f); else (match.facts = match.facts || []).push(f);
          });
          Object.entries(sec).forEach(([sk, sv]) => { if (sk !== "facts") match[sk] = sv; });
        });
      } else if (k === "eoc_facts" && Array.isArray(v)) {
        out.eoc_facts = (out.eoc_facts || []).concat(v);
      } else if (k === "itemContent" && v && typeof v === "object") {
        // per-SSBCI-item content deep-merges per sub-key per field (author the
        // vendor once at carrier tier, override only the delta at plan/admin)
        out.itemContent = out.itemContent || {};
        for (const [ik, iv] of Object.entries(v)) out.itemContent[ik] = Object.assign(out.itemContent[ik] || {}, iv);
      } else out[k] = JSON.parse(JSON.stringify(v));
    }
    return out;
  }
  function effectiveTemplate(key) {
    // resolution stack (most specific wins): base ← carrier ← contract ← plan ← workbench edits
    const base = C.base[key];
    const cpack = state.carrier && C.carriers[state.carrier] ? C.carriers[state.carrier][key] : null;
    const hnum = state.planId ? state.planId.split("_")[0] : null;
    const contract = hnum && C.contracts && C.contracts[hnum] ? C.contracts[hnum][key] : null;
    const planPack = state.planId && C.plans
      ? ((C.plans[state.planId] || {})[key] || (C.plans[state.planId.replace(/_\d+$/, "")] || {})[key])
      : null;
    return mergeContent(mergeContent(mergeContent(mergeContent(base, cpack), contract), planPack), state.userPack[key]);
  }

  /* ---------- slot resolution ---------- */
  const CTX_PREFIXES = ["item.", "group.", "package.", "subType."];
  function dig(obj, path) { return path.split(".").reduce((o, k) => (o == null ? undefined : o[k]), obj); }
  function resolvePath(path, ctx) {
    path = path.trim();
    for (const p of CTX_PREFIXES) if (path.startsWith(p)) return ctx ? dig(ctx, path.slice(p.length)) : undefined;
    if (path.startsWith("yearConstants.")) return dig(C.yearConstants, path.slice(14));
    const plan = state.plan, first = path.split(".")[0];
    if (plan.benefits && Object.prototype.hasOwnProperty.call(plan.benefits, first)) return dig(plan.benefits, path);
    return dig(plan, path);
  }
  // interpolate {path} / {path|default} inside a string. An unresolved slot drops
  // ONLY itself plus one adjacent separator; surrounding prose is preserved. (The old
  // version split the whole string on spaces and rejoined tokens with bullets, mangling
  // prose like "{copay} eye exam" into a dotted list when a slot was missing.)
  function interp(str, ctx) {
    if (str == null) return null;
    var anyUnresolved = false;
    var out = String(str).replace(/\{([^}|{]+)(?:\|([^}]*))?\}/g, function (m, p, dflt) {
      var v = resolvePath(p, ctx);
      if (v == null || v === "") v = dflt !== undefined ? dflt : null;
      if (v == null) { anyUnresolved = true; return "\u0001"; }
      return Array.isArray(v) ? v.join(", ") : String(v);
    });
    if (!anyUnresolved) return out.trim();
    out = out
      .replace(/\s*[\u00B7\u2014-]?\s*\u0001\s*[\u00B7\u2014-]?\s*/g, " ")
      .replace(/\s+([,;])/g, "$1")
      .replace(/\s{2,}/g, " ")
      .replace(/^[\s\u00B7\u2014,;-]+|[\s\u00B7\u2014,;-]+$/g, "")
      .trim();
    return out || null;
  }

  /* ---------- §4a wallet & package planning ---------- */
  function parseCode(label) { const m = /\(([^()]+)\)\s*$/.exec(label || ""); return m ? m[1].replace(/\s/g, "") : null; }
  function catIndex() {
    const idx = [];
    C.taxonomy.cards.forEach(c => (c.pbpCategories || []).forEach(p => idx.push({ p, key: c.key })));
    return idx;
  }
  function codeToCard(code, idx) {
    let best = null;
    idx.forEach(({ p, key }) => { if (code && code.startsWith(p) && (!best || p.length > best.p.length)) best = { p, key }; });
    return best ? best.key : null;
  }
  // Filing labels that must never be member-facing ("SSBCI Pkg", "SSBCI OTC DVH",
  // "Package 1", "Cmb Sup Ben 2", …). SSBCI/pkg/DVH are filing jargon wherever they appear.
  function genericName(n) {
    n = (n || "").trim();
    // A sub-4-char filing label ("OTC", "DH", "UF", a bare digit) carries no
    // descriptive value on its own, so route it to deriveWalletName — which turns an
    // OTC-pooling wallet into "OTC Allowance" (clearer than a bare "OTC"). Verified
    // against the corpus: "OTC" (15 plans) is the ONLY sub-4-char group name filed,
    // and it correctly renders as "OTC Allowance", so this is intentional, not a leak.
    if (n.length < 4) return true;
    return /\bssbci\b|\bpkg\b|\bdvh\b|\bvbid\b|\buf\b/i.test(n)
      || /\bpackage \d|\bbenefit \d|\ballowance \d/i.test(n)
      || /^(package|group|combined supplemental|combined benefit|combined allowance|cmb\b|special supplemental)/i.test(n);
  }
  // Descriptive member name derived from what the wallet actually covers — used when
  // the carrier filed a generic PBP name (e.g. "Combined Benefit 2"). Self-driving:
  // no carrier authoring needed. Dental-only → "Dental Allowance"; OTC+fitness →
  // "OTC & Fitness Allowance"; 3+ categories → the base "Flex Allowance".
  const WALLET_NOUN = { otc: "OTC", dental: "Dental", hearing: "Hearing", vision: "Vision",
    fitness: "Fitness", socialSupports: "Healthy Food", meals: "Meals",
    transportation: "Transportation", dme: "Medical Supplies" };
  function deriveWalletName(w) {
    const nouns = [...new Set([...(w.memberCards || [])].map(c => WALLET_NOUN[c]).filter(Boolean))];
    if (nouns.length === 1) return nouns[0] + " Allowance";
    if (nouns.length === 2) return nouns.join(" & ") + " Allowance";
    return (C.base.flexAllowance || {}).title || "Flex Allowance";
  }
  function planWallets(gatedKeys) {
    const idx = catIndex();
    const groups = dig(state.plan, "benefits.combined_benefits.groups") || [];
    const wallets = [], singleCard = [], linkOnly = [];
    groups.forEach(g => {
      const codes = (g.categories || []).map(parseCode).filter(Boolean);
      const nonPass = codes.filter(c => !c.startsWith("19b"));
      const cards = [...new Set(nonPass.map(c => codeToCard(c, idx)).filter(Boolean))];
      if (!g.max_plan_benefit) {
        // dollarless group (e.g. a Transportation linkage group): no wallet card —
        // it only marks which benefits ride in the special package
        linkOnly.push({ group: g, cards });
        cards.forEach(c => eligStamps.add(c));
      } else if (nonPass.length && cards.length === 1 && nonPass.every(c => codeToCard(c, idx)) && !(g.includes || []).length)
        // single-card ONLY when the categories map to one card AND no SSBCI items
        // are linked in — a group with includes[] is multi-benefit by definition
        singleCard.push({ group: g, card: cards[0] });
      else
        wallets.push({ group: g, codes, memberCards: new Set(cards), pkgNames: [], eligibility: false, absorbed: [], crossRef: [] });
    });
    // SSBCI per-item claims: the pipeline's period-matched includes[] say which wallet
    // (or link-only group) funds each SSBCI item — authoritative, item-level
    const claimed = new Map(); // item label -> wallet (ONLY real wallet cards claim items)
    // Only a wallet card (pooled dollar) claims an SSBCI item — the item's dollar
    // renders on that wallet and is suppressed on the SSBCI card. A LINK-ONLY group
    // (includes[] but no pooled dollar) has no wallet card, so it must NOT claim the
    // item — otherwise the item is suppressed here yet has nowhere to render and
    // vanishes from all member output (68 plans, e.g. H1822_005_0 transportation).
    // Link-only groups still stamp eligibility above; the item renders its own facts.
    wallets.forEach(w => (w.group.includes || []).forEach(i => claimed.set(typeof i === "string" ? i : (i.label || i.name), w)));

    // VBID packages
    const pkgs = dig(state.plan, "benefits.vbid_packages.packages") || [];
    const merged = [], partial = [];
    pkgs.forEach(pkg => {
      const codes = (pkg.benefit_categories || []).map(parseCode).filter(Boolean);
      if (pkg.reduced_benefits || /Cost-Sharing/i.test(pkg.category || "")) { partial.push({ pkg, remainder: null, csr: true }); return; }
      // a supplemental package with its OWN aggregate allowance is its own wallet —
      // never merged into (or allowed to rename) a combined group
      if (pkg.aggregate_allowance) {
        partial.push({ pkg, remainder: null, standalone: true });
        codes.forEach(code => { const card = codeToCard(code, idx); if (card) eligStamps.add(card); });
        return;
      }
      const notCovered = codes.filter(code => {
        const card = codeToCard(code, idx);
        const inWallet = wallets.concat(linkOnly.map(l => ({ codes: (l.group.categories || []).map(parseCode) }))).some(w => (w.codes || []).some(wc => code.startsWith(wc) || wc.startsWith(code)));
        return !(inWallet || (card && gatedKeys.has(card)));
      });
      if (codes.length && notCovered.length === 0) {
        merged.push(pkg.name);
        // eligibility flows to every wallet/card the package touches; the package's
        // NAME goes to at most ONE wallet, and only if that wallet's name is generic
        const passWallets = wallets.filter(w =>
          w.codes.some(wc => wc.startsWith("19b")) ||
          codes.some(code => w.codes.some(wc => code.startsWith(wc) || wc.startsWith(code))));
        passWallets.forEach(w => { w.eligibility = true; });
        const nameTarget = passWallets.find(w => genericName(w.group.name));
        if (nameTarget && !genericName(pkg.name)) nameTarget.pkgNames.push(pkg.name);
        codes.forEach(code => { const card = codeToCard(code, idx); if (card) eligStamps.add(card); });
      } else {
        partial.push({ pkg, remainder: notCovered, csr: false });
      }
    });
    return { wallets, singleCard, linkOnly, merged, partial, idx, claimed };
  }
  let eligStamps = new Set();

  /* ---------- hard rules ---------- */
  function stripSlotTokens(s) { return String(s).replace(/\{[^}]*\}/g, ""); }
  function scanHardRules(gatedKeys) {
    const errors = [];
    gatedKeys.forEach(key => {
      const t = effectiveTemplate(key);
      if (!t) return;
      const fields = [["title", t.title], ["tagline", t.tagline], ["tileSubtitle", t.tileSubtitle], ["note", t.note], ["cta.label", t.cta && t.cta.label], ["eligibilityBanner", t.eligibilityBanner]];
      // per-SSBCI-item member-facing content (itemContent renders as section how-to/CTA)
      Object.entries(t.itemContent || {}).forEach(([ik, ic]) => {
        fields.push([`itemContent.${ik}.howToUse`, ic.howToUse], [`itemContent.${ik}.note`, ic.note], [`itemContent.${ik}.cta.label`, ic.cta && ic.cta.label]);
      });
      (t.sections || []).forEach((s, si) => {
        fields.push([`sections[${si}].label`, s.label], [`sections[${si}].note`, s.note]);
        (s.facts || []).forEach((f, fi) => {
          fields.push([`sections[${si}].facts[${fi}].label`, f.label], [`…prefix`, f.prefix], [`…suffix`, f.suffix], [`…pooledNote`, f.pooledNote], [`…default`, f.default]);
          if (f.value !== undefined && f.source !== "computed" && DOLLAR.test(stripSlotTokens(f.value)))
            errors.push(`${key}: literal dollar in fact value without source:"computed" (rule 1)`);
        });
      });
      (t.connections || []).forEach((c, ci) => fields.push([`connections[${ci}].text`, c.text]));
      fields.forEach(([where, val]) => {
        if (val && DOLLAR.test(stripSlotTokens(val))) errors.push(`${key} · ${where}: literal dollar amount in content (rule 1) — numbers come from PBP slots only`);
        if (val && PROVENANCE.test(String(val))) errors.push(`${key} · ${where}: provenance/citation language in a member-facing field (rule 5) — move it to the internal "verification" field`);
      });
      (t.eoc_facts || []).forEach(ef => {
        if (ef.approved !== true) errors.push(`${key} · eoc_facts "${ef.label || ef.value}": approved:true missing (rule 2)`);
        else if (!ef.citation || String(ef.citation).length < 5) errors.push(`${key} · eoc_facts "${ef.label || ef.value}": citation missing (rule 2)`);
      });
    });
    return errors;
  }

  /* ---------- card compilation ---------- */
  const SUBTYPE_MATCH = { inHomeSafety: /in.?home safety/i, pers: /personal emergency|PERS/i, wigs: /wig/i };
  function subTypeEntry(key) {
    const subs = dig(state.plan, "benefits.additional_preventive.sub_types") || [];
    return subs.find(s => SUBTYPE_MATCH[key].test(s.label || "")) || null;
  }
  function deriveSSItems() {
    const ss = state.plan.benefits && state.plan.benefits.social_supports;
    if (ss && !Array.isArray(ss.items))
      // stamp each item's dict key so per-item admin/content routing is exact (NLP-free)
      ss.items = Object.entries(ss).filter(([k, v]) => k !== "items" && v && typeof v === "object" && !Array.isArray(v)).map(([k, v]) => Object.assign({ key: k }, v));
  }
  function isAllowanceSlot(slot) { return /max_plan_benefit(?!_period)/.test(slot || ""); }

  function compileFactRows(f, ctx, opts, drops, cardKey) {
    if (f.forEach) {
      let arr = resolvePath(f.forEach, ctx);
      if (!Array.isArray(arr)) return [];
      if (cardKey === "preventiveCare" && f.forEach.includes("sub_types"))
        arr = arr.filter(e => !Object.values(SUBTYPE_MATCH).some(rx => rx.test(e.label || "")));
      const sub = Object.assign({}, f); delete sub.forEach;
      return arr.flatMap(item => compileFactRows(sub, item, opts, drops, cardKey));
    }
    const label = interp(f.label, ctx) || "";
    let value = null, suppressed = false;
    if (f.value !== undefined && f.source === "computed") value = interp(f.value, ctx);
    else if (f.plusSlot) {
      // Cost = copay (slot) AND/OR coinsurance (plusSlot). Show BOTH when the plan
      // files both ("$50 plus 20% of the cost"); show whichever one it filed
      // otherwise. ~29% of plans file both on some benefit.
      const a = f.slot ? resolvePath(f.slot, ctx) : null;
      const b = resolvePath(f.plusSlot, ctx);
      let av = (a != null && a !== "") ? String(a) : null;
      let bv = (b != null && b !== "") ? String(b) : null;
      if (bv && COINS_PCT.test(bv.trim())) bv = bv.trim() + " of the cost";
      // A $0 copay adds nothing to a coinsurance — "$0 plus 20% of the cost" reads
      // oddly, so when both are filed and the copay is $0, show just the coinsurance.
      if (av && bv && /^\$0(\.00?)?$/.test(av.trim())) av = null;
      value = (av && bv) ? (av + " plus " + bv) : (av || bv || null);
    } else {
      if (f.slot) { const v = resolvePath(f.slot, ctx); if (v != null && v !== "") value = v; }
      if (value == null && f.altSlot) { const v = resolvePath(f.altSlot, ctx); if (v != null && v !== "") value = v; }
    }
    // SSBCI items claimed by a wallet's includes[] (the pipeline's period-matched
    // linkage) render on THAT wallet card, not here — item-level absorption
    if (cardKey === "socialSupports" && ctx && ctx.label && opts.claimed && opts.claimed.has(ctx.label)) return [];
    // pooled / wallet suppression (§4a step 3 + spec §4b SSBCI note) — a member card is
    // suppressed against its OWNING wallet, whichever of the plan's wallets that is
    const owning = (opts.wallets || []).find(w => w.memberCards.has(cardKey));
    const pooledByNote = ctx && typeof ctx === "object" && ctx.max_plan_benefit_note;
    const pooledByWallet = owning && isAllowanceSlot(f.slot) && value != null && DOLLAR.test(String(value));
    if (pooledByNote || pooledByWallet) {
      { const _wn = (owning && owning.name) || "combined"; value = f.pooledNote || ("Included in your " + _wn + (/allowances?$/i.test(_wn) ? "" : " allowance")); }
      suppressed = true;
    }
    // wallet-funded member with no filed dollar at all (e.g. SSBCI items funded
    // through the wallet): the pooledNote stands in, and absorption handles the rest
    if (value == null && f.pooledNote && owning && isAllowanceSlot(f.slot)) {
      value = f.pooledNote; suppressed = true;
    }
    if (value == null && f.default) value = f.default;
    if (value == null) { drops.push({ label: label || f.slot, reason: `slot unresolved: ${f.slot || f.altSlot || "(none)"}` }); return []; }
    if (value === true) value = "Yes"; else if (value === false) value = "No";
    if (Array.isArray(value)) value = value.map(v => typeof v === "string" ? v.replace(/\s*\([^()]*\)\s*$/, "") : v).join(f.join || ", ");
    let text = String(value);
    // A bare percentage is coinsurance — the member's SHARE of the cost — but "20%"
    // alone reads as meaningless (or worse, mistakable for a discount). Frame every
    // standalone coinsurance value the same way, for every card.
    if (!suppressed && COINS_PCT.test(text.trim())) text = text.trim() + " of the cost";
    const pfx = f.prefix ? interp(f.prefix, ctx) : null, sfx = f.suffix ? interp(f.suffix, ctx) : null;
    if (pfx) text = pfx + " " + text;
    if (sfx && !suppressed) text = text + " " + sfx;
    const row = { label, value: polishValue(text.trim()), highlight: !!f.highlight, suppressed };
    row.source = f.source === "computed" ? "computed" : "pbp";
    if (row.source === "pbp" && (f.slot || f.altSlot)) row.pbpPath = f.slot || f.altSlot;
    return [row];
  }

  function compileCard(key, opts, report) {
    const t = effectiveTemplate(key);
    if (!t) return null;
    const drops = [];
    const walletName = opts.walletName;
    const sections = [];
    (t.sections || []).forEach(sec => {
      let contexts = [null];
      if (sec.forEach) {
        let arr = resolvePath(sec.forEach, null) || [];
        if (key === "flexAllowance") arr = [];               // §4a: wallet cards are built by the consolidator
        if (key === "vbidPackages") arr = opts.vbidRemainder || [];
        contexts = arr;
        if (!contexts.length) return;
      }
      contexts.forEach(ctx => {
        // chipsFrom: render a plan-varying list (e.g. SSBCI supports) as a chip
        // set instead of a fact table of repeated "Included" rows.
        let chips = (sec.chips || []).slice();
        if (sec.chipsFrom) {
          (resolvePath(sec.chipsFrom, ctx) || []).forEach(it => {
            if (key === "socialSupports" && it && it.label && opts.claimed && opts.claimed.has(it.label)) return; // wallet-absorbed items don't repeat
            const l = interp(sec.chipLabel || "{item.label}", it);
            if (l && !chips.includes(l)) chips.push(l);
          });
        }
        const rows = (sec.facts || []).flatMap(f => compileFactRows(f, ctx, opts, drops, key));
        if (!rows.length && !chips.length) return;
        const section = { label: interp(sec.label, ctx) || t.title, icon: sec.icon || t.icon, rows, chips, note: interp(sec.note, ctx) };
        // Per-item (SSBCI) sections: stamp the item key for admin routing, and merge
        // carrier/plan itemContent (vendor = internal-only; how-to + CTA render).
        if (ctx && ctx.key) {
          section._itemKey = ctx.key;
          const ic = (t.itemContent || {})[ctx.key];
          if (ic) {
            const how = ic.howToUse || ic.note;
            if (how) section.howToUse = interp(how, ctx);
            if (ic.cta) section.cta = ic.cta;
          }
        }
        sections.push(section);
      });
    });
    // eoc_facts (approved + cited only; gate on `requires`; PBP wins on conflicts)
    const eocRows = [];
    (t.eoc_facts || []).forEach(ef => {
      if (ef.approved !== true || !ef.citation) return;
      if (ef.requires && resolvePath(ef.requires, null) == null) { report.eocDropped.push({ card: key, label: ef.label, reason: `requires ${ef.requires} absent` }); return; }
      const pbpRow = sections.flatMap(s => s.rows).find(r => r.label === ef.label && DOLLAR.test(r.value));
      if (pbpRow && DOLLAR.test(String(ef.value)) && pbpRow.value !== String(ef.value)) {
        report.discrepancies.push({ card: key, label: ef.label, pbp: pbpRow.value, eoc: ef.value, resolution: "PBP wins — EOC row suppressed" });
        return;
      }
      eocRows.push({ label: ef.label, value: ef.value, highlight: false, source: "eoc", citation: ef.citation });
      report.eocIncluded.push({ card: key, label: ef.label, citation: ef.citation });
    });
    if (eocRows.length) sections.push({ label: "Good to know", icon: t.icon, rows: eocRows, chips: [] });
    if (!sections.length) { report.cardsDropped.push({ card: key, reason: "no sections survived slot resolution" }); return null; }
    drops.forEach(d => report.factsDropped.push({ card: key, label: d.label, reason: d.reason }));
    const ctxNull = null;
    return {
      key, title: t.title || key,
      tagline: polishValue(interp(t.tagline, ctxNull) || t.title),
      tileSubtitle: polishValue(interp(t.tileSubtitle, ctxNull) || ""),
      barColor: t.barColor || "#4F196F", iconBg: t.iconBg || "#EFEEF0", iconColor: t.iconColor || "#4F196F", icon: t.icon,
      vendor: t.vendor || null, note: polishValue(interp(t.note, ctxNull)), cta: t.cta || null,
      requiresEligibility: t.requiresEligibility || (eligStamps.has(key) ? "ssbci" : undefined),
      eligibilityBanner: t.eligibilityBanner || ((t.requiresEligibility || eligStamps.has(key)) ? ELIG_DEFAULT : null), launchScope: t.launchScope || "live",
      connections: t.connections || [], sections,
    };
  }

  /* ---------- main compile ---------- */
  function compile() {
    const out = { errors: [], cards: [], report: null, internalErrors: [] };
    if (!state.plan) return out;
    state.plan.benefits = state.plan.benefits || {};
    state.plan.plan_info = state.plan.plan_info || {};
    deriveSSItems();
    eligStamps = new Set();
    const report = { factsDropped: [], cardsDropped: [], eocIncluded: [], eocDropped: [], fallbacks: {}, wallet: [], discrepancies: [], admin: { applied: [], skipped: [], flags: [] } };

    // 1. gate
    const gated = new Set(), gatedOff = [];
    C.taxonomy.cards.forEach(c => {
      let on;
      if (c.key === "prescriptions") on = !!(state.plan.drug_coverage && state.plan.drug_coverage.has_drug_benefit);
      else if (SUBTYPE_MATCH[c.key]) on = !!subTypeEntry(c.key);
      else on = (c.pbpSources || []).some(k => (k === "drug_coverage" ? state.plan.drug_coverage : dig(state.plan, "benefits." + k)) != null);
      if (on) gated.add(c.key); else gatedOff.push(c.key);
    });

    // 2. hard rules on gated content
    out.errors = scanHardRules(gated);

    // 3. wallet & package planning
    const wp = planWallets(gated);

    // 4. compile cards in taxonomy order
    const walletCards = [];
    wp.wallets.forEach(w => {
      const tW = effectiveTemplate("flexAllowance") || {};
      // naming ladder: content title (plan/contract/carrier/edits) → non-generic group
      // name → donated package name (already vetted non-generic, at most one wallet)
      // → base template title. Generic filing labels never reach the member.
      const contentTitle = tW.title !== (C.base.flexAllowance || {}).title ? tW.title : null;
      w.name = contentTitle || (!genericName(w.group.name) ? w.group.name : null) || w.pkgNames[0] || deriveWalletName(w);
      walletCards.push(w);
    });
    // disambiguate same-named wallets (two generic groups both falling back to
    // "Flex Allowance"): suffix the period, else a counter — never two identical titles
    const names = walletCards.map(w => w.name);
    walletCards.forEach((w, i) => {
      if (names.filter(n => n === names[i]).length < 2) return;
      const per = (w.group.max_plan_benefit_period || "").replace(/^Every /i, "");
      const samePeriod = walletCards.filter((x, j) => names[j] === names[i] && (x.group.max_plan_benefit_period || "") === (w.group.max_plan_benefit_period || ""));
      w.name = per && samePeriod.length === 1 ? `${names[i]} (${per})` : `${names[i]} ${names.slice(0, i + 1).filter(n => n === names[i]).length}`;
    });
    const opts = {
      wallets: walletCards,
      claimed: wp.claimed,
      // generic package labels render as a neutral member-facing name
      vbidRemainder: wp.partial.map(p => genericName(p.pkg.name) ? Object.assign({}, p.pkg, { name: "Special benefit package" }) : p.pkg),
    };

    const compiled = {};
    gated.forEach(key => {
      if (key === "flexAllowance" || key === "vbidPackages") return; // handled below
      try {
        const card = compileCard(key, opts, report);
        if (card) compiled[key] = card;
      } catch (e) {
        out.internalErrors.push(`${key}: ${e.message}`);
        report.cardsDropped.push({ card: key, reason: "internal compiler error: " + e.message });
      }
    });

    // absorption test (§4a step 3): member card with no substance → rows on wallet card
    walletCards.forEach(w => {
      w.memberCards.forEach(mk => {
        const card = compiled[mk];
        if (!card) return;
        const substance = card.sections.some(s => s.rows.some(r => !r.suppressed && (/\d/.test(r.value) || (r.value.length > 2 && !/^(Included|Covered)/i.test(r.value)))));
        if (!substance) {
          const labels = card.sections.flatMap(s => s.rows.map(r => r.label)).filter(Boolean);
          w.absorbed.push({ key: mk, title: card.title, labels: labels.length > 1 ? labels : [card.title] });
          delete compiled[mk];
        } else {
          w.crossRef.push(mk);
          if (w.eligibility) { card.requiresEligibility = "ssbci"; if (!card.eligibilityBanner) card.eligibilityBanner = ELIG_DEFAULT; }
        }
      });
    });

    // build wallet cards
    walletCards.forEach((w, wIdx) => {
      const tW = effectiveTemplate("flexAllowance") || {};
      const rows = [{ label: "Allowance", value: polishValue(`${w.group.max_plan_benefit || ""} ${w.group.max_plan_benefit_period || ""}`.trim()), highlight: true, source: "pbp", pbpPath: "combined_benefits.groups" }];
      // approved wallet eoc_facts (e.g. the monthly deposit the wallet card is loaded with)
      // — applied to the primary wallet only, so multi-wallet plans don't duplicate them
      if (wIdx === 0) (tW.eoc_facts || []).forEach(ef => {
        if (ef.approved !== true || !ef.citation) return;
        if (ef.requires && resolvePath(ef.requires, null) == null) { report.eocDropped.push({ card: "flexAllowance", label: ef.label, reason: `requires ${ef.requires} absent` }); return; }
        rows.push({ label: ef.label, value: ef.value, highlight: true, source: "eoc", citation: ef.citation });
        report.eocIncluded.push({ card: "flexAllowance", label: ef.label, citation: ef.citation });
      });
      const covered = [];
      w.absorbed.forEach(a => a.labels.forEach(l => covered.push(l)));
      (w.group.includes || []).forEach(i => { const n = typeof i === "string" ? i : (i.label || i.name); if (n && !covered.includes(n)) covered.push(n); });
      covered.forEach(l => rows.push({ label: l, value: "Included" }));
      w.crossRef.forEach(mk => rows.push({ label: (compiled[mk] || { title: mk }).title, value: "See its card — allowance shared" }));
      compiled.__wallet_ = compiled.__wallet_ || [];
      compiled.__wallet_.push({
        key: "flexAllowance", title: w.name,
        tagline: interp(tW.tagline, null) || "One shared allowance",
        barColor: tW.barColor || "#7C3AED", iconBg: tW.iconBg || "#F3E8FF", iconColor: tW.iconColor || "#7C3AED", icon: tW.icon,
        note: interp(tW.note, null), cta: tW.cta || null,
        requiresEligibility: w.eligibility ? "ssbci" : undefined,
        eligibilityBanner: w.eligibility ? (tW.eligibilityBanner || ELIG_DEFAULT) : null,
        connections: tW.connections || [], sections: [{ label: w.name, rows, chips: [] }],
      });
      report.wallet.push({
        wallet: w.name, combined_group: w.group.name,
        cards_absorbed: w.absorbed.map(a => a.key), cards_cross_referenced: w.crossRef,
        vbid_packages_merged: w.pkgNames,
      });
    });
    wp.singleCard.forEach(sc => report.wallet.push({ wallet: `(single-card allowance) ${sc.group.name}`, combined_group: sc.group.name, renders_on: sc.card, cards_absorbed: [], cards_cross_referenced: [], vbid_packages_merged: [] }));
    wp.linkOnly.forEach(l => report.wallet.push({ wallet: `(link-only, no pooled dollar) ${l.group.name}`, combined_group: l.group.name, eligibility_stamped_on: l.cards, cards_absorbed: [], cards_cross_referenced: [], vbid_packages_merged: [] }));
    wp.partial.filter(p => p.standalone).forEach(p => report.wallet.push({ wallet: `(standalone package allowance) ${p.pkg.name}`, aggregate_allowance: p.pkg.aggregate_allowance, renders_on: "vbidPackages", cards_absorbed: [], cards_cross_referenced: [], vbid_packages_merged: [] }));

    // vbidPackages card only if remainder survives
    if (gated.has("vbidPackages") && wp.partial.length) {
      const card = compileCard("vbidPackages", opts, report);
      if (card) compiled.vbidPackages = card;
    } else if (gated.has("vbidPackages")) {
      report.cardsDropped.push({ card: "vbidPackages", reason: `all ${wp.merged.length} packages merged into wallet/covered cards (§4a)` });
    }

    // §4b — admin-tool vendor rows: blob → "How to use" on the mapped card; phones/URLs → CTA;
    // free-text dollars & misplaced SSBCI language flagged; unmapped benefit name = build error
    (state.adminRows || []).forEach(row => {
      const pid = adminToPipeline(row.plan_id);
      if (pid !== state.planId) { report.admin.skipped.push({ benefit: row.benefit_name, reason: `row is for ${pid}, not ${state.planId}` }); return; }
      const map = (C.adminMapping && C.adminMapping.benefits || {})[row.benefit_name];
      if (!map) { out.errors.push(`§4b — admin benefit name "${row.benefit_name}" not in admin-benefit-mapping.json (build error, never silently dropped)`); return; }
      const text = String(row.description_markdown || "").replace(/\*\*?/g, "").replace(/\[([^\]]*)\]\(([^)]*)\)/g, "$1 ($2)").replace(/^#+\s*/gm, "").trim();
      if (!text) { report.admin.skipped.push({ benefit: row.benefit_name, reason: "empty blob" }); return; }
      // rule 5 also applies to admin-injected how-to (renders to members); admin runs
      // after scanHardRules, so it needs its own provenance guard.
      if (PROVENANCE.test(text)) { out.errors.push(`§4b admin row "${row.benefit_name}": provenance/citation language in the how-to blob (rule 5) — must be clean member content`); return; }
      const tel = /(\(?\d{3}\)?[ .-]?\d{3}[ .-]?\d{4})/.exec(text);
      const url = /(https?:\/\/[^\s)]+|[a-z0-9.-]+\.(?:com|org|net)\b[^\s)]*)/i.exec(text);
      const mkCta = () => tel ? { label: "Call " + tel[1], action: "tel", href: "tel:" + tel[1].replace(/\D/g, "") }
        : url ? { label: "Learn more", action: "web", href: /^https?:/i.test(url[1]) ? url[1] : "https://" + url[1] } : null;
      // Per-SSBCI-item routing: the row targets one item's section, not the whole card.
      if (map.ssbciItem) {
        const card = compiled.socialSupports;
        const sec = card && (card.sections || []).find(s => s._itemKey === map.ssbciItem);
        if (!sec) { report.admin.skipped.push({ benefit: row.benefit_name, reason: `SSBCI item "${map.ssbciItem}" not offered on this plan` }); return; }
        sec.howToUse = text;
        if (!sec.cta) { const c = mkCta(); if (c) sec.cta = c; }
        if (DOLLAR.test(text)) report.admin.flags.push({ benefit: row.benefit_name, flag: "free-text dollar in admin blob — review vs PBP" });
        report.admin.applied.push({ benefit: row.benefit_name, card: "socialSupports/" + map.ssbciItem, cta_extracted: !!(tel || url) });
        return;
      }
      let targetKey = map.card, target = compiled[targetKey], via = null;
      if (!target && targetKey === "otc" && (compiled.__wallet_ || []).length) { target = compiled.__wallet_[0]; via = "wallet (otc absorbed)"; }
      if (!target) { report.admin.skipped.push({ benefit: row.benefit_name, reason: `card "${targetKey}" not rendered (gated off or absorbed)` }); return; }
      target.howToUse = text;
      if (!target.cta) { const c = mkCta(); if (c) target.cta = c; }
      if (DOLLAR.test(text)) report.admin.flags.push({ benefit: row.benefit_name, flag: "free-text dollar amount in admin blob — review vs PBP" });
      report.admin.applied.push({ benefit: row.benefit_name, card: via || targetKey, cta_extracted: !!(tel || url) });
    });

    // 5. assemble in taxonomy order, wallet card first after "just for you" semantics → put wallets at front
    const ordered = [];
    (compiled.__wallet_ || []).forEach(wcard => ordered.push(wcard));
    C.taxonomy.cards.forEach(c => { if (compiled[c.key]) ordered.push(compiled[c.key]); });

    // 6. single-surface check — structural, not substring: each pooled group amount may
    // appear in allowance-like rows ONLY on its designated surface (the wallet card, or
    // the single card a dental-max-style group collapsed onto). Same-amount groups are
    // checked collectively so two $500 groups on their own surfaces don't cross-flag.
    const surface = [];
    const ALLOWANCE_ROW = /allowance|plan pays|maximum|max\b|deposit/i;
    const byAmt = {};
    walletCards.forEach(w => { if (w.group.max_plan_benefit) (byAmt[w.group.max_plan_benefit] = byAmt[w.group.max_plan_benefit] || []).push({ type: "wallet", title: w.name }); });
    wp.singleCard.forEach(sc => { if (sc.group.max_plan_benefit) (byAmt[sc.group.max_plan_benefit] = byAmt[sc.group.max_plan_benefit] || []).push({ type: "card", key: sc.card }); });
    const allWalletMembers = new Set();
    walletCards.forEach(w => w.memberCards.forEach(m => allWalletMembers.add(m)));
    Object.entries(byAmt).forEach(([amt, surfaces]) => {
      const amtRe = new RegExp(amt.replace(/[.*+?^${}()|[\]\\]/g, "\\$&") + "(?![\\d,.])");
      const holders = [], leaks = [], sameAmount = [];
      ordered.forEach(card => {
        const designated = surfaces.some(sf => (sf.type === "card" && sf.key === card.key) || (sf.type === "wallet" && card.key === "flexAllowance" && card.title === sf.title));
        const hit = card.sections.some(s => s.rows.some(r => !r.suppressed && ALLOWANCE_ROW.test(r.label) && amtRe.test(r.value)));
        if (!hit) return;
        holders.push(card.key + ":" + card.title);
        if (designated) return;
        // a wallet MEMBER still showing the pooled amount = real leak (suppression failed);
        // a non-member card with a separately-filed pool of the same value = review note only
        (allWalletMembers.has(card.key) ? leaks : sameAmount).push(card.key);
      });
      surface.push({ amount: amt, holders, member_leaks: leaks, same_amount_review: sameAmount, ok: leaks.length === 0 });
    });

    // content fallbacks (most specific layer that contributed)
    const hnum = state.planId ? state.planId.split("_")[0] : null;
    Array.from(gated).forEach(key => {
      const hasPlan = C.plans && ((C.plans[state.planId] || {})[key] || (C.plans[(state.planId || "").replace(/_\d+$/, "")] || {})[key]);
      const hasContract = hnum && C.contracts && C.contracts[hnum] && C.contracts[hnum][key];
      const hasCarrier = state.carrier && C.carriers[state.carrier] && C.carriers[state.carrier][key];
      report.fallbacks[key] = state.userPack[key] ? "workbench-edit" : hasPlan ? "plan:" + state.planId : hasContract ? "contract:" + hnum : hasCarrier ? "carrier:" + state.carrier : "base";
    });

    out.cards = ordered;
    out.report = {
      plan_id: state.planId,
      build: out.errors.length ? "FAILED" : "PASSED",
      dsnp_zero_dollar: !!(state.plan.plan_info && state.plan.plan_info.dsnp_zero_dollar),
      cards_rendered: ordered.map(c => c.key === "flexAllowance" ? "flexAllowance (" + c.title + ")" : c.key),
      cards_gated_off: gatedOff,
      cards_dropped: report.cardsDropped,
      launch_scope_deferred: ordered.filter(c => c.launchScope === "deferred").map(c => c.key),
      facts_dropped: report.factsDropped.slice(0, 40),
      eoc_facts_included: report.eocIncluded,
      eoc_facts_dropped: report.eocDropped,
      eoc_pbp_discrepancies: report.discrepancies,
      admin_rows: report.admin,
      content_fallbacks: report.fallbacks,
      vbid_packages_merged: wp.merged,
      wallet_consolidations: report.wallet,
      single_surface: surface,
      internal_errors: out.internalErrors,
      source_documents: { sb: state.docs.sb ? state.docs.sb.name : null, eoc: state.docs.eoc ? state.docs.eoc.name : null },
    };
    return out;
  }

  /* ---------- §4b admin-tool helpers ---------- */
  function adminToPipeline(id) {
    const m = /^([HRES]\d{4})(\d{3})(\d{3})$/.exec(String(id || "").trim());
    if (!m) return String(id || "").trim();
    return `${m[1]}_${m[2]}_${parseInt(m[3], 10)}`;
  }

  /* ---------- corpus audit ---------- */
  let auditAbort = false;
  function stopAudit() { auditAbort = true; }
  async function runAudit() {
    if (!state.summary) { $("auditout").innerHTML = '<p class="err">Load the plan data first (serving mode or folder pick).</p>'; return; }
    auditAbort = false;
    const ids = Object.keys(state.summary);
    const agg = { total: ids.length, done: 0, passed: 0, failed: 0, internal: 0, surfaceViol: 0, zeroCards: 0,
      cardsMin: Infinity, cardsMax: 0, cardsSum: 0, wallets: 0, singleCardAllowances: 0, absorbed: 0, merged: 0, dsnp: 0,
      failures: [], internals: [], surface: [] };
    const saved = { plan: state.plan, planId: state.planId, carrier: state.carrier };
    const t0 = performance.now();
    const CHUNK = 40;
    for (let i = 0; i < ids.length && !auditAbort; i += CHUNK) {
      const batch = ids.slice(i, i + CHUNK);
      const plans = await Promise.all(batch.map(id => loadPlanJSON(id).catch(e => ({ __loaderr: e.message }))));
      for (let j = 0; j < batch.length; j++) {
        const id = batch[j];
        try {
          if (plans[j].__loaderr) throw new Error(plans[j].__loaderr);
          state.plan = plans[j]; state.planId = id;
          state.carrier = carrierFor((state.summary[id] || {}).h_number || id.split("_")[0]);
          const res = compile();
          if (res.internalErrors.length) { agg.internal++; if (agg.internals.length < 25) agg.internals.push(id + " — " + res.internalErrors[0]); }
          if (res.errors.length) { agg.failed++; if (agg.failures.length < 25) agg.failures.push(id + " — " + res.errors[0]); } else agg.passed++;
          const n = res.cards.length;
          agg.cardsMin = Math.min(agg.cardsMin, n); agg.cardsMax = Math.max(agg.cardsMax, n); agg.cardsSum += n;
          if (!n) agg.zeroCards++;
          if (res.report.dsnp_zero_dollar) agg.dsnp++;
          if ((res.report.single_surface || []).some(s => !s.ok)) { agg.surfaceViol++; if (agg.surface.length < 25) agg.surface.push(id); }
          (res.report.wallet_consolidations || []).forEach(w => {
            if (w.renders_on) agg.singleCardAllowances++; else if (!/link-only/.test(w.wallet)) agg.wallets++;
            agg.absorbed += (w.cards_absorbed || []).length;
          });
          agg.merged += (res.report.vbid_packages_merged || []).length;
        } catch (e) { agg.internal++; if (agg.internals.length < 25) agg.internals.push(id + " — " + e.message); }
        agg.done++;
      }
      $("auditbar").value = 100 * agg.done / ids.length;
      renderAudit(agg, performance.now() - t0, false);
      await new Promise(r => setTimeout(r, 0));
    }
    state.plan = saved.plan; state.planId = saved.planId; state.carrier = saved.carrier;
    renderAudit(agg, performance.now() - t0, true);
    if (saved.plan) recompile();
  }
  function renderAudit(a, ms, done) {
    const row = (k, v, cls) => `<tr><td>${k}</td><td class="num ${cls || ""}">${v}</td></tr>`;
    $("auditout").innerHTML = `
      <p style="margin:10px 0 0;font-weight:600;">${done ? (auditAbort ? "Stopped" : "Complete") : "Running…"} — ${a.done.toLocaleString()} / ${a.total.toLocaleString()} plans in ${(ms / 1000).toFixed(1)}s</p>
      <table>
        ${row("Builds passed", a.passed.toLocaleString(), a.passed === a.done ? "ok" : "")}
        ${row("Builds failed (hard rules)", a.failed.toLocaleString(), a.failed ? "err" : "ok")}
        ${row("Internal compiler errors", a.internal.toLocaleString(), a.internal ? "err" : "ok")}
        ${row("Single-surface violations", a.surfaceViol.toLocaleString(), a.surfaceViol ? "err" : "ok")}
        ${row("Plans with zero cards", a.zeroCards.toLocaleString(), "")}
        ${row("Cards per plan (min / avg / max)", a.done ? `${a.cardsMin === Infinity ? 0 : a.cardsMin} / ${(a.cardsSum / Math.max(1, a.done)).toFixed(1)} / ${a.cardsMax}` : "—", "")}
        ${row("Wallet cards rendered (§4a)", a.wallets.toLocaleString(), "")}
        ${row("Single-card allowances collapsed", a.singleCardAllowances.toLocaleString(), "")}
        ${row("Cards absorbed into wallets", a.absorbed.toLocaleString(), "")}
        ${row("VBID packages merged", a.merged.toLocaleString(), "")}
        ${row("D-SNP zero-dollar plans", a.dsnp.toLocaleString(), "")}
      </table>
      ${a.failures.length ? `<p class="err" style="margin:10px 0 2px;">Build failures (first ${a.failures.length}):</p><ul>${a.failures.map(f => `<li>${f}</li>`).join("")}</ul>` : ""}
      ${a.internals.length ? `<p class="err" style="margin:10px 0 2px;">Internal errors (first ${a.internals.length}):</p><ul>${a.internals.map(f => `<li>${f}</li>`).join("")}</ul>` : ""}
      ${a.surface.length ? `<p class="err" style="margin:10px 0 2px;">Single-surface violations:</p><ul>${a.surface.map(f => `<li>${f}</li>`).join("")}</ul>` : ""}`;
  }

  /* ---------- UI ---------- */
  const $ = id => document.getElementById(id);
  function setSource(html) { $("datasource").innerHTML = html; }
  const ICON = { fitness_center: "ti-barbell", shopping_bag: "ti-shopping-bag", account_balance_wallet: "ti-wallet", volunteer_activism: "ti-heart-handshake", redeem: "ti-gift", gpp_good: "ti-shield-check", stethoscope: "ti-stethoscope", medication: "ti-pill", dentistry: "ti-dental", visibility: "ti-eye", hearing: "ti-ear", restaurant: "ti-tools-kitchen-2", directions_car: "ti-car", local_hospital: "ti-building-hospital", spa: "ti-leaf", psychology: "ti-brain", home_health: "ti-home-2", wheelchair_pickup: "ti-wheelchair", directions_walk: "ti-walk", monitor_heart: "ti-heartbeat", emergency: "ti-urgent", lightbulb: "ti-bulb" };
  const ico = name => ICON[name] || "ti-circle";

  // Escape every member/plan/content text field on a shallow card copy before it is
  // interpolated into innerHTML. Structural fields (icon, colors, cta.action) are
  // compiler-controlled and left as-is.
  function escCard(c) {
    const o = Object.assign({}, c);
    o.title = esc(c.title); o.tagline = esc(c.tagline); o.tileSubtitle = esc(c.tileSubtitle);
    if (c.note) o.note = esc(c.note);
    if (c.howToUse) o.howToUse = esc(c.howToUse);
    if (c.eligibilityBanner) o.eligibilityBanner = esc(c.eligibilityBanner);
    if (c.cta) o.cta = Object.assign({}, c.cta, { label: esc(c.cta.label) });
    o.connections = (c.connections || []).map(cn => Object.assign({}, cn, { text: esc(cn.text) }));
    o.sections = (c.sections || []).map(s => Object.assign({}, s, {
      label: esc(s.label),
      note: s.note ? esc(s.note) : s.note,
      howToUse: s.howToUse ? esc(s.howToUse) : s.howToUse,
      chips: (s.chips || []).map(esc),
      cta: s.cta ? Object.assign({}, s.cta, { label: esc(s.cta.label) }) : s.cta,
      rows: (s.rows || []).map(r => Object.assign({}, r, { label: esc(r.label), value: esc(r.value) })),
    }));
    return o;
  }

  function renderSearch() {
    const q = $("plansearch").value.trim().toLowerCase();
    const box = $("planresults");
    if (!state.summary || q.length < 2) { box.innerHTML = ""; return; }
    const hits = Object.values(state.summary).filter(p =>
      (p.plan_id || "").toLowerCase().includes(q) || (p.plan_name || "").toLowerCase().includes(q) ||
      (p.org_marketing_name || "").toLowerCase().includes(q) || (p.org_name || "").toLowerCase().includes(q)
    ).slice(0, 25);
    box.innerHTML = hits.map(p =>
      `<button class="result" data-id="${esc(p.plan_id)}"><b>${esc(p.plan_id)}</b> · ${esc(p.plan_name || "")}<br><span>${esc(p.org_marketing_name || p.org_name || "")} · ${esc(p.plan_type || "")}${p.is_snp ? " · SNP" : ""}</span></button>`
    ).join("") || '<p class="hint">No matches.</p>';
    box.querySelectorAll(".result").forEach(b => b.addEventListener("click", () => selectPlan(b.dataset.id)));
  }

  async function selectPlan(id) {
    try {
      state.plan = await loadPlanJSON(id);
      state.planId = id;
      state.userPack = {};
      const h = (state.summary[id] || {}).h_number || id.split("_")[0];
      state.carrier = carrierFor(h);
      const s = state.summary[id] || {};
      $("planinfo").innerHTML = `<b>${esc(s.plan_name || id)}</b><br>${esc(s.org_marketing_name || "")} · ${esc(s.plan_type || "")} · premium ${s.premium != null ? "$" + s.premium : "—"}${(state.plan.plan_info || {}).dsnp_zero_dollar ? " · <b>D-SNP zero-dollar</b>" : ""}<br>Benefit keys: ${Object.keys(state.plan.benefits || {}).length} · Carrier pack: <b>${esc(state.carrier ? state.carrier : "none (base wording only)")}</b>`;
      $("planresults").innerHTML = "";
      $("plansearch").value = id;
      recompile();
      renderBoard();
    } catch (e) { $("planinfo").innerHTML = `<span class="err">${e.message}</span>`; }
  }

  function renderBoard() {
    const el = $("authorboard");
    if (!el) return;
    if (!state.carrier) { el.innerHTML = '<p class="hint">Pick a plan to see its carrier.</p>'; return; }
    const rows = window.WBAuthor.boardStatus(C, state.carrier);
    el.innerHTML = rows.map(r => `
      <button class="result" data-key="${r.key}" style="text-align:center;${r.hasCarrierPack ? 'background:var(--green-l);border-color:var(--green);' : ''}">
        <b>${r.key}</b><br><span>${r.hasCarrierPack ? 'pack ✓' : 'base only'}${r.overrides ? ' · ' + r.overrides + ' override' + (r.overrides > 1 ? 's' : '') : ''}</span>
      </button>`).join("");
    el.querySelectorAll(".result").forEach(b => b.addEventListener("click", () => WB.openCardForm(b.dataset.key)));
  }
  function currentPackFor(key) {
    // the pack already authored at the current scope's own level (for editing), else {}
    const sc = state.authScope;
    if (sc.level === "carrier") return (C.carriers[sc.carrier] || {})[key] || state.userPack[key] || {};
    if (sc.level === "contract") return ((C.contracts || {})[sc.contract] || {})[key] || {};
    return ((C.plans || {})[sc.planId] || {})[key] || {};
  }
  function openCardForm(key) {
    state.authKey = key;
    state.authScope = state.authScope || { level: "carrier", carrier: state.carrier };
    renderForm();
  }
  function renderForm() {
    const key = state.authKey, A = window.WBAuthor;
    const inherited = A.effectiveForm(C, state.authScope, key);
    const form = A.packToForm(currentPackFor(key));
    const field = f => {
      const val = form[f.key] || "", ph = inherited[f.key] ? `inherited: ${inherited[f.key]}` : "";
      const hint = f.hint ? `<span class="hint" style="font-size:0.72rem">${f.hint}</span>` : "";
      if (f.type === "textarea") return `<label class="doc"><b>${f.label}</b> ${hint}<textarea data-f="${f.key}" style="min-height:60px;font-family:inherit;font-size:0.84rem" placeholder="${ph}">${val}</textarea></label>`;
      if (f.type === "select") return `<label class="doc"><b>${f.label}</b><br><select data-f="${f.key}"><option value=""></option>${f.options.map(o => `<option${o === val ? " selected" : ""}>${o}</option>`).join("")}</select></label>`;
      return `<label class="doc"><b>${f.label}</b> ${hint}<br><input type="text" data-f="${f.key}" value="${val.replace(/"/g, "&quot;")}" placeholder="${ph}"></label>`;
    };
    $("authorform").innerHTML = `
      <div class="card" style="margin-top:10px;">
        <h2><i class="ti ti-edit"></i> ${key}</h2>
        ` +
        `<div class="btnrow" style="margin-bottom:8px;">` +
        ["carrier", "contract", "plan"].map(l =>
          `<button class="btn ${state.authScope.level === l ? "" : "secondary"}" style="padding:5px 12px" onclick="WB.setScope('${l}')">${l === "carrier" ? "All " + state.carrier : l === "contract" ? "Contract " + (state.planId || "").split("_")[0] : "This plan " + (state.planId || "")}</button>`
        ).join("") + `</div>` +
        `${window.WBAuthor.FORM_FIELDS.map(field).join("")}
        <div class="btnrow"><button class="btn secondary" onclick="WB.closeForm()">Done</button><button class="btn" onclick="WB.savePack()"><i class="ti ti-download"></i> Save file</button><span id="saveerr" style="font-size:0.78rem"></span></div>
      </div>`;
    $("authorform").querySelectorAll("[data-f]").forEach(i => i.addEventListener("input", applyForm));
  }
  function readForm() {
    const form = window.WBAuthor.packToForm({});
    $("authorform").querySelectorAll("[data-f]").forEach(i => { form[i.dataset.f] = i.value; });
    return form;
  }
  function applyForm() {
    const key = state.authKey;
    state.userPack[key] = window.WBAuthor.formToPack(readForm(), key); // live preview via existing pipeline
    recompile();
  }
  function closeForm() { $("authorform").innerHTML = ""; state.authKey = null; }
  function savePack() {
    const key = state.authKey, A = window.WBAuthor, sc = state.authScope;
    const pack = A.buildSavePack(sc, currentPackFor(key), readForm(), A.effectiveForm(C, sc, key), key);
    if (Object.keys(pack).length <= 2) { $("saveerr").innerHTML = '<span class="err">nothing to save at this scope (matches inherited)</span>'; return; }
    const path = A.exportPath(sc, key);
    const a = document.createElement("a");
    a.href = URL.createObjectURL(new Blob([JSON.stringify(pack, null, 2)], { type: "application/json" }));
    a.download = path.replace(/\//g, "__");
    a.click();
    $("saveerr").innerHTML = `<span class="ok">✓ ${path}</span>`;
  }
  function setScope(level) {
    const h = (state.planId || "").split("_")[0];
    state.authScope = { level, carrier: state.carrier, contract: h, planId: state.planId };
    renderForm();
  }

  function attachDoc(kind, input) {
    const f = input.files[0];
    if (!f) return;
    state.docs[kind] = { name: f.name, url: URL.createObjectURL(f) };
    $(kind + "label").innerHTML = `<i class="ti ti-file-check ok"></i> <b>${esc(f.name)}</b> (${(f.size / 1048576).toFixed(1)} MB) · <a href="${state.docs[kind].url}" target="_blank" rel="noopener">view</a> — attached as citation source (never parsed)`;
    recompile();
  }

  function recompile() {
    if (!state.plan) return;
    const res = compile();
    // banner
    $("buildbanner").innerHTML = res.errors.length
      ? `<div class="banner fail"><i class="ti ti-alert-triangle"></i> BUILD FAILED — ${res.errors.length} hard-rule violation(s):<ul>${res.errors.map(e => `<li>${e}</li>`).join("")}</ul></div>`
      : `<div class="banner pass"><i class="ti ti-circle-check"></i> BUILD PASSED — ${res.cards.length} cards compiled for ${state.planId} · single-surface ${res.report.single_surface.every(s => s.ok) ? "OK" : '<span class="err">VIOLATION</span>'}${res.report.dsnp_zero_dollar ? " · D-SNP zero-dollar overlay stamped" : ""}</div>`;
    // phone
    const dsnp = res.report.dsnp_zero_dollar;
    const s = state.summary[state.planId] || {};
    $("phone").innerHTML = `
      <div class="phead"><div class="k">DUOS · Benefits Hub</div><div class="n">${esc(s.plan_name || state.planId)}</div>
      <div class="k">${state.planId} · 2026${dsnp ? " · you pay $0 in network with Medicaid" : ""}</div></div>
      ${dsnp ? '<p class="dsnp"><i class="ti ti-shield-check"></i> Medicare + Medicaid: you pay $0 for covered in-network care. Any copay or percentage shown below is what Medicare bills; your Medicaid coverage pays it for you.</p>' : ""}
      ${res.errors.length ? '<p class="dsnp" style="background:var(--orange-l);color:var(--orange);">Preview withheld — build failed.</p>' : !res.cards.length ? '<p class="dsnp" style="background:var(--bg);color:var(--muted);">No benefit details are on file for this plan (e.g. an MSA or employer PDP that files no benefit detail).</p>' : res.cards.map(escCard).map(card => `
        <div class="ptile"><div class="bar" style="background:${card.barColor}"></div><div class="body">
          <div class="t"><span><i class="ti ${ico(card.icon)}" style="color:${card.iconColor}"></i> ${card.title}</span><span>${card.requiresEligibility ? '<span class="chip">You qualify</span>' : ""}</span></div>
          <div class="s">${card.tileSubtitle || card.tagline || ""}</div>
          ${card.requiresEligibility && card.eligibilityBanner ? `<div class="elig"><i class="ti ti-circle-check"></i> ${card.eligibilityBanner}</div>` : ""}
          ${card.sections.map(sec => `
            ${card.sections.length > 1 ? `<div class="seclabel">${sec.label}</div>` : ""}
            ${sec.rows.map(r => `<div class="fr"><span>${r.label}</span><b style="${r.highlight ? "color:" + card.iconColor : ""}">${r.value}</b></div>`).join("")}
            ${sec.note ? `<div class="s">${sec.note}</div>` : ""}
            ${sec.chips.length ? `<div class="s" style="margin-top:4px;">${sec.chips.map(c => `<span class="pill">${c}</span>`).join("")}</div>` : ""}
            ${sec.howToUse ? `<div class="howto"><b><i class="ti ti-info-circle"></i> How to use this</b><br>${sec.howToUse}</div>` : ""}
            ${sec.cta ? `<div class="s" style="margin-top:4px;color:var(--purple);font-weight:600;"><i class="ti ${sec.cta.action === "tel" ? "ti-phone" : "ti-external-link"}"></i> ${sec.cta.label || ""}</div>` : ""}`).join("")}
          ${card.howToUse ? `<div class="howto"><b><i class="ti ti-info-circle"></i> How to use this benefit</b><br>${card.howToUse}</div>` : ""}
          ${card.note ? `<div class="s" style="margin-top:6px;">${card.note}</div>` : ""}
          ${(card.connections || []).map(cn => `<div class="know"><b><i class="ti ti-bulb"></i> Did you know?</b> ${cn.text}</div>`).join("")}
          ${card.cta ? `<div class="s" style="margin-top:4px;color:var(--purple);font-weight:600;"><i class="ti ${card.cta.action === "tel" ? "ti-phone" : "ti-external-link"}"></i> ${card.cta.label || ""} ${card.cta.href ? "· " + esc(card.cta.href.replace(/^(tel:|https:\/\/www\.|https:\/\/)/, "")) : ""}</div>` : ""}
        </div></div>`).join("")}
      <div style="height:8px;"></div>`;
    // report + json
    $("reportjson").textContent = JSON.stringify(res.report, null, 2);
    $("compiledjson").textContent = JSON.stringify({ planId: state.planId, dsnpZeroDollar: dsnp, cards: res.cards }, null, 2);
    if (res.cards.length || res.errors.length) $("outempty").style.display = "none";
  }

  function tab(which) {
    state.activeTab = which;
    ["preview", "reportt", "jsont", "auditt"].forEach(t => $(t).classList.toggle("active", t === which));
    $("phonewrap").style.display = which === "preview" ? "" : "none";
    $("reportwrap").style.display = which === "reportt" ? "" : "none";
    $("jsonwrap").style.display = which === "jsont" ? "" : "none";
    $("auditwrap").style.display = which === "auditt" ? "" : "none";
  }

  // test API: compile an arbitrary plan object headlessly (used by deep-audit harnesses)
  function compileFor(planObj, planId, adminRows) {
    const saved = { plan: state.plan, planId: state.planId, carrier: state.carrier, adminRows: state.adminRows };
    try {
      state.plan = planObj; state.planId = planId; state.adminRows = adminRows || [];
      state.carrier = carrierFor((state.summary && state.summary[planId] || {}).h_number || String(planId).split("_")[0]);
      return compile();
    } finally {
      state.plan = saved.plan; state.planId = saved.planId; state.carrier = saved.carrier; state.adminRows = saved.adminRows;
    }
  }
  function summaryIds() { return state.summary ? Object.keys(state.summary) : []; }

  window.WB = { renderSearch, attachDoc, tab, recompile, runAudit, stopAudit, compileFor, summaryIds, renderBoard, openCardForm, renderForm, closeForm, savePack, setScope };
  init();
})();
