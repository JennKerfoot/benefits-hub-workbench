# Benefits Hub — EOC + CMS/PBP Reconciliation Plan

**Audience:** DUOS product + engineering
**Goal:** Make the Benefits Hub (the experience currently prototyped in `artifacts/duos-pwa/src/screens/BenefitsHub.tsx`) work for **any plan**, not just the hand-built Humana example — and make it safe to launch.
**Date:** 2026-07-01

---

## 1. The problem we're solving

Two facts we've all agreed on, from the launch-readiness discussion:

- **EOC = better wording.** The member-facing language we want (rollover explanations, vendor names like SilverSneakers/TruHearing, "how to use it") lives in the EOC, not in CMS data.
- **CMS/PBP = better truth.** The transportation incident happened because an EOC-derived benefit displayed when the plan didn't actually cover it. PBP data is the coverage source of truth.

The blocker was that the current screen is a **content wall**: every copay, dollar amount, and conditional is hand-typed into one `BENEFIT_CARDS` array. That can't scale past one plan and can't be validated.

**The reconciliation principle:**

> **PBP decides *whether* and *how much*. EOC decides *how we say it*. A build-time compiler merges the two and refuses to ship anything PBP can't confirm.**

This is not a new idea for us — the CMS dashboard pipeline already does exactly this for D-SNP zero-dollar plans: the data stays faithful to the CMS feed, and a *display layer* (`benefit-formatter.js`) applies the member-facing adjustment at render time. We're extending that same pattern to the whole hub.

---

## 2. What we already have (and don't need to rebuild)

The `CMS-PBP-Translation-Package-2026` pipeline (`dashboard/preprocess.py`) already produces, for **all 8,081 plans**, a per-plan JSON at `dashboard/data/plans/H{contract}_{plan}_{segment}.json`:

```
{
  "plan_id": "H0028_007_0",
  "plan_info":   { plan_name, org_marketing_name, plan_type, is_snp, snp_type, dsnp_zero_dollar, member_phone, org_website, ... },
  "costs":       { monthly_premium, annual_deductible, max_out_of_pocket, part_b_reduction },
  "network":     { has_oon_coverage, visitor_traveler_benefit, oon_cost_sharing[], pos_cost_sharing[] },
  "benefits":    { up to 55 keys — present only if the plan covers the benefit },
  "drug_coverage": { has_drug_benefit, deductible, tiers[], catastrophic_tiers[], insulin caps }
}
```

Key conventions the Hub must respect (all documented in `TRANSLATION_LOGIC.md` / `AUDIT_2026.md`):

1. **Coverage = key presence.** A benefit absent from `benefits` is *not covered*. This is the structural fix for the transportation incident: a tile literally cannot render without a PBP object behind it.
2. **`null` ≠ `$0`.** A null copay means "not specified in the filing," never "free." Only the literal string `"$0"` may render as $0.
3. **Combined wallets come pre-grouped.** `combined_benefits.groups[]` carries the pooled allowance, period, categories, and inferred `includes[]` — the submission-order and grouping logic Jenn flagged is already handled *inside* the pipeline. The app must render groups as given and never sum or re-derive allowances.
4. **D-SNP zero-dollar** (`plan_info.dsnp_zero_dollar`) is a display overlay, applied at the last step — data stays faithful to CMS.
5. **VBID packages are eligibility-gated** (`vbid_packages.packages[].eligibility`) — never show as universal benefits.
6. **1/0 vs named values** are normalized by the pipeline's code maps (`AUTH_MAP`, `PERIODICITY_MAP`, etc.) — the app never touches raw CMS conventions.

---

## 3. The architecture: three layers, one compiler

```
┌─────────────────────┐   ┌──────────────────────────┐
│ COVERAGE LAYER      │   │ CONTENT LAYER            │
│ (source of truth)   │   │ (member-facing language) │
│ plans/<id>.json     │   │ EOC-derived templates,   │
│ generated, per-plan │   │ human-authored, per      │
│ from preprocess.py  │   │ benefit key + carrier    │
└──────────┬──────────┘   └────────────┬─────────────┘
           │                           │
           ▼                           ▼
      ┌──────────────────────────────────────┐
      │ CARD COMPILER (build-time script)    │
      │ • gate: no PBP object → no tile/row  │
      │ • numbers: PBP only, never EOC       │
      │ • wording: EOC templates w/ slots    │
      │ • discrepancy + completeness report  │
      └──────────────────┬───────────────────┘
                         ▼
        benefit-cards/<plan_id>.json  (matches BenefitCard[])
                         ▼
        BenefitsHub.tsx — unchanged dumb renderer
```

### Layer 1 — Coverage (PBP, generated)
The existing per-plan JSON. Nobody edits it. It answers two questions per benefit: *is it covered?* and *what are the numbers?* (copay, coinsurance, allowance, period, limits, auth/referral, max plan benefit).

### Layer 2 — Content (EOC-derived, human-authored)
A small library of **templates keyed by benefit key**, with optional carrier- or plan-level overrides:

```
content/
  base/dental.json          ← generic wording, works for any plan
  carriers/humana/dental.json  ← Humana-specific vendors, networks, phone CTAs
  plans/H0028_007_0/otc.json   ← rare plan-specific overrides (e.g., rollover language)
```

Templates contain **labels, taglines, "Did you know" connections, chips, CTAs, vendor names — and slots, never numbers**:

```json
{
  "key": "vision",
  "tagline": "{eye_exams.copay} eye exam · up to {eyewear.max_plan_benefit} for glasses or contacts",
  "facts": [
    { "label": "Routine eye exam", "slot": "eye_exams.copay", "suffix": "· {eye_exams.exam_limit}/{eye_exams.exam_limit_period}" },
    { "label": "Glasses or contacts", "slot": "eyewear.max_plan_benefit", "prefix": "Up to" }
  ],
  "connections": [ { "icon": "lightbulb", "text": "A routine eye exam is more than an eyesight check…" } ]
}
```

### Layer 3 — Card compiler (build-time, deterministic)
A script (Python next to `preprocess.py`, or TS in the app repo) that, per plan, merges Layer 1 + Layer 2 into the exact `BenefitCard[]` shape the UI already renders. Its rules **are** the launch-safety policy:

| Rule | What it does | Which past problem it solves |
|---|---|---|
| **Gate on presence** | Tile renders only if its PBP benefit object exists; fact row renders only if its slot resolves | Transportation incident — uncovered benefits can never appear |
| **Numbers from PBP only** | Every `$`, `%`, count, and period is interpolated from the plan JSON; EOC text with hardcoded numbers is rejected by the compiler | EOC-drift misstating amounts |
| **`null` → omit or "See plan documents"** | Unresolved slots drop the row (or swap in a fallback line), never render as $0 | Silent-loss / null-means-free confusion |
| **EOC-only facts are labeled and reviewed** | Facts with no PBP backing (rollover language, 60-day trial, battery counts, vendor names) carry `source: "eoc"` and require explicit approval in the content file (`"approved": true`) plus a covered parent benefit | Keeps the useful EOC detail without letting it gate anything |
| **Discrepancy report** | Where an EOC-extracted number disagrees with PBP, compiler flags it; PBP wins by default | "Source-of-truth risk" from the meeting |
| **Completeness report** | Per plan: which cards compiled, which facts dropped, which templates fell back to `base/` | Tells you exactly what's launch-ready per plan, instead of a gut feeling |
| **ONE wallet = ONE card (single-surface)** | CMS files the same shared allowance in up to three places (OTC 13b, SSBCI 13i items, VBID b19b package + Section D combined group); the compiler consolidates them into one wallet card, absorbs substance-free member cards, cross-references the rest, and errors if a dollar surfaces on two cards (COMPILER_SPEC.md §4a) | Humana H7617-076 QA — three overlapping cards ("Special benefit packages", "Everyday living support", OTC) all restating the one $225/month Healthy Options allowance |

The compiler also applies the known special layers, in order: shared-wallet & VBID package consolidation (§4a), D-SNP zero-dollar overlay, VBID/SSBCI eligibility gating (stamped at compile time, applied per member at render time).

---

## 4. Concrete contract change in the app

`BenefitsHub.tsx` barely changes. The `BenefitCard`/`FactRow` interfaces stay, with provenance added so QA and support can trace any rendered value:

```ts
interface FactRow {
  label: string;
  value: string;
  highlight?: boolean;
  source: 'pbp' | 'eoc' | 'computed';  // computed = year constants like the $2,100 Part D cap
  pbpPath?: string;                     // e.g. "benefits.eyewear.max_plan_benefit"
}
```

Then two swaps:

1. `export const BENEFIT_CARDS: BenefitCard[]` → loaded from `benefit-cards/<plan_id>.json`, selected by the member's contract/plan/segment (`memberData` gains `planId`).
2. `BENEFIT_CTAS` phone/URLs move into the carrier content layer (they're EOC/vendor facts).

Everything else — `ExploreMyBenefits`, `BenefitDetail`, the accordion — renders whatever cards it's given. That's already true today.

---

## 5. Mapping: today's Humana cards → PBP fields

This is the proof the model works. Every fact on the current screen, classified:

| Current fact | PBP source (`benefits.…`) | Class |
|---|---|---|
| Dental cleanings/exams/X-rays $0 | `dental_preventive.sub_types[]` | PBP |
| Crowns, root canals, dentures cost-share | `dental_comprehensive.sub_types[]` | PBP |
| Dental $3,000/year max | `dental_comprehensive.max_plan_benefit` or `combined_benefits` "Dental Maximum" group | PBP |
| Eye exam $0, 1/year | `eye_exams.copay`, `.exam_limit`, `.exam_limit_period` | PBP |
| Eyewear up to $150/$250 | `eyewear.max_plan_benefit` (PLUS-provider tier is EOC) | PBP + EOC |
| Hearing exam $0 | `hearing_exams.copay` | PBP |
| Hearing aid $699/$999 per ear | `hearing_aids.copay`, `.max_plan_benefit_per_ear` | PBP |
| 60-day trial, 3-yr warranty, 80 batteries | not in PBP | **EOC-only** (approved row, gated by `hearing_aids` presence) |
| TruHearing / SilverSneakers / CenterWell vendors | not in PBP (as Jenn noted) | **EOC-only** (carrier content layer) |
| Fitness benefit exists | `fitness` (`benefit_type`, `fitness_types`, copay, `max_plan_benefit`) — added 2026-07-01, 5,115 plans | PBP |
| OTC $50/quarter | `otc_items` + `combined_benefits` OTC group (`max_plan_benefit`, `max_plan_benefit_period`) | PBP |
| OTC rollover language | not in PBP | **EOC-only** |
| Drug tier copays, deductible, mail-order | `drug_coverage.tiers[]`, `.deductible` | PBP |
| Insulin $35/month cap | `drug_coverage.insulin_cost_sharing` + statute | PBP + computed |
| $2,100 out-of-pocket limit | 2026 Part D statutory cap | computed (year constant) |
| "Up to $8,400/yr in savings" | marketing estimate | **computed/marketing — must be labeled, never presented as a coverage fact** |
| PCP $0 / specialist $25 / telehealth | `primary_care`, `specialist`, `telehealth` | PBP |
| $0 preventive screenings | Medicare-standard preventive | computed (static, safe for all MA plans) |

Takeaway: **~80% of the current screen is directly PBP-backed.** The rest is legitimately EOC or year-constant content — which is exactly what the content layer + approval flag is for.

---

## 6. Known gaps (honest list — decide before launch)

1. **~~Fitness isn't in the extractor output.~~ RESOLVED (2026-07-01).** Fitness (PBP B14c, service category 14c4) was being extracted under CMS's legacy column suffix `mhc` and mislabeled "Mental Health Counseling" inside `additional_preventive.sub_types`. `preprocess.py` now emits a top-level `benefits["fitness"]` object (`benefit_type`, `fitness_types` — Activity Tracker / Physical Fitness / Memory Fitness — copay, coinsurance, `max_plan_benefit` + period) and the mislabel is removed. Regenerated across all 8,081 plans; 5,115 plans have a fitness benefit, matching raw-data counts. The Hub's Fitness card is now PBP-gated like everything else.
2. **Rollover and vendor facts can't be PBP-gated,** only PBP-*parented* (shown only when the parent benefit is covered). They need the human-approval flag in content files. That's a policy, not a bug — write it down and enforce it in the compiler.
3. **VBID/SSBCI display policy.** These are condition- and eligibility-gated. Recommend launch scope: show only universal benefits; add SSBCI/VBID once member-eligibility data exists in the app.
4. **Column-drift on CMS refresh.** A renamed CMS column silently yields blanks (`safe_get` → `""`). The audit process in `AUDIT_2026.md` §7 must run after every annual data refresh — put it in the release checklist. The compiler's completeness report gives you a second alarm: a fact count that drops year-over-year is a red flag.

---

## 7. Phased path to launch

**Phase 1 — Contract + compiler skeleton (eng, ~days)**
Freeze `BenefitCard` with provenance fields. Write the compiler for the 7 existing card types against `plans/<id>.json`. PBP-slot facts only; no content layer yet — output is plain but *correct* for all 8,081 plans.

**Phase 2 — Content layer for launch carriers (product + eng)**
Author `base/` templates (generic wording per benefit key) and carrier overrides for launch plans (vendors, CTAs, networks, approved EOC-only rows). This is where the current Humana card copy gets recycled — it becomes the Humana carrier template, minus the hardcoded numbers.

**Phase 3 — QA loop (before any plan goes live)**
Run the compiler across launch plans. Review the discrepancy + completeness reports. Spot-check compiled cards against the actual EOC/SBC PDFs for each launch plan (the two Humana SBC PDFs in `attached_assets/` are the first test case). A plan ships only when its report is clean.

**Phase 4 — App integration**
`memberData.planId` → fetch `benefit-cards/<plan_id>.json` → existing renderer. D-SNP overlay + "See plan documents" fallbacks in the renderer.

**Launch acceptance criteria (the one-slide version):**
- No tile or fact renders without a PBP object behind it.
- No dollar amount on screen originates from EOC text.
- Every EOC-only row is explicitly approved in a content file and parented to a covered PBP benefit.
- Per-plan compiler report is clean for every plan we turn on.

---

## 8. Why this is launch-ready where the old approach wasn't

- The failure mode that burned us (EOC says yes, PBP says no) is **structurally impossible**, not process-prevented.
- The "content wall" problem Rita described is gone: structured details are extracted **once, in the pipeline** (already done — 8,081 plans), and wording is authored **once per benefit type**, not once per plan.
- Interpretation traps Jenn raised (submission-order wallets, 1/0 conventions, broad-JSON-pull mistakes) are confined to the pipeline, which already handles them and has an audit trail (`TRANSLATION_LOGIC.md`, `AUDIT_2026.md`). The app never reads raw CMS data.
- Coverage scales to any plan on day one; *polish* (carrier content) scales carrier-by-carrier — a plan without custom content still renders correct, plainly-worded cards instead of nothing (or worse, wrong things).

---

## 9. Addendum (2026-07-01)

### 9.1 Do we still need the EOC and the Summary of Benefits?

Yes — but only in two narrow roles, neither of which is a parsing pipeline:

- **Authoring input.** The EOC/SB is what a human reads while writing the carrier content templates (vendor names, networks, rollover language, "how to use it"). It is never machine-extracted for numbers.
- **QA cross-check.** In Phase 3, each launch plan's compiled cards are spot-checked against its **Summary of Benefits** (shorter, structured, per-plan — the better QA artifact). The full EOC is the legal fallback when the SB is ambiguous. The two SCAN PDFs in `attached_assets/` (`26C-SBH5425123` = Summary of Benefits, `26C-BHLH5425123` = Benefit Highlights, plan H5425-123) are the first test pair.

What we do **not** need: EOC text extraction at scale. That was the old approach's trap — the compiler makes it unnecessary because every number already comes from PBP.

### 9.2 SSBCI + combined benefits — the SCAN example (H5425_123_0)

SCAN plan H5425-123 in the generated data shows exactly how the three constructs interlock, and how the Hub must render them:

- `social_supports.food_produce` — SSBCI Food & Produce, `max_plan_benefit_note: "Included in combined supplemental allowance"` (no standalone dollar amount).
- `combined_benefits.groups[0]` — "Grocery-OTC" shared wallet: **$65/month pooled across OTC Items + the SSBCI food benefit** (`includes: ["Food & Produce"]`).
- `vbid_packages.packages[0]` — "Food" package, category SSBCI/UF → **chronic-condition-eligible members only**.

Hub rendering rules that fall out of this:
1. **One "Flex Allowance" card per `combined_benefits.group`**, showing the pooled amount + period and the member-friendly list from `includes[]`/`categories[]`. Never render the SSBCI line-item with its own dollar figure when its note says it's pooled — that's the double-counting mistake the submission-order warning was about, and the pipeline has already resolved it.
2. **SSBCI items carry an eligibility banner** ("for members with qualifying chronic conditions") and stay hidden until the app knows member eligibility — or are omitted at launch (recommended launch scope).
3. Standalone OTC (like the Humana $50/quarter example) and wallet-pooled OTC (like SCAN's) are the **same card type with two layouts**; the compiler picks based on whether `otc_items` appears in a combined group.

### 9.3 Fitness — resolved

See §6.1. `benefits["fitness"]` now exists for 5,115 plans (SCAN H5425-123: `{"benefit_type": "Mandatory", "fitness_types": "Physical Fitness"}`); the vendor name (SilverSneakers etc.) remains carrier content, as designed.

### 9.4 Human-authored content: the complete inventory

Everything a human must write or approve, in priority order:

| # | Artifact | Count at launch | Owner | Notes |
|---|---|---|---|---|
| 1 | **Base benefit templates** — title, fact-row labels, tagline pattern with slots, fallback lines | ~10–12 (dental, vision, hearing, fitness, OTC, drugs, doctor visits/preventive, flex allowance, transportation, meals, SSBCI, worldwide/urgent) | Product/content | Written once, reused for all 8,081 plans |
| 2 | **"Did you know?" connections** | 1–2 per template | Product/content + clinical review | Generic health education, not plan-specific |
| 3 | **Carrier packs** — vendor names, network names, phone/URL CTAs, catalogs | 1 per launch carrier | Product, sourced from EOC/SB | ~half a day per carrier with the SB in hand |
| 4 | **Approved EOC-only facts** — rollover language, trial periods, battery counts, PLUS-provider tiers | Small list per carrier/plan, each with `approved: true` + EOC page citation | Product writes, compliance approves | The only place EOC content enters the data path |
| 5 | **Year constants** — Part D out-of-pocket cap ($2,100 for 2026), insulin cap ($35) | One small file per plan year | Eng maintains, compliance confirms annually | Marked `source: "computed"` |
| 6 | **Design tokens** — icon, colors per card type | Already exist in `BENEFIT_CARDS` | Design | Move into base templates |
| 7 | **Marketing claims** (e.g. "Up to $8,400/yr in savings") | Optional | Marketing + compliance | Must be labeled as estimates, never mixed into coverage facts |

Approval workflow: items 1–2 reviewed once per year; items 3–4 reviewed per carrier onboarding and re-verified against the new SB each plan year; the compiler's discrepancy report is the enforcement backstop.

### 9.5 Carrier pack format & resolution hierarchy

Content files are small per-benefit JSON documents, resolvable at four levels of specificity that mirror CMS plan identity (organization → contract → PBP/plan → segment). Most specific wins:

```
content/
  base/<benefit>.json                  1. generic wording — every plan
  carriers/<carrier>/<benefit>.json    2. carrier defaults (vendors, networks, CTAs)
  contracts/<H#>/<benefit>.json        3. contract-level override (e.g. state/product-line differences)
  plans/<H#_plan>/<benefit>.json       4. PBP-level override (plan-specific riders, catalogs)
  registry.json                        maps contract → carrier (e.g. "H5425": "scan")
```

Example — `carriers/scan/fitness.json`:

```json
{
  "$schema": "duos-benefit-content/v1",
  "appliesTo": { "carrier": "scan" },
  "vendor": "One Pass",
  "cta": { "label": "Explore One Pass", "action": "web", "href": "https://www.youronepass.com" },
  "tagline": "One Pass — {fitness.copay|$0} gym memberships, on-demand workouts & community classes",
  "note": "Vendor verified against the 2026 SCAN Summary of Benefits (26C-SBH5425123).",
  "eoc_facts": [
    { "label": "Includes", "value": "Gym memberships · on-demand workouts · community classes",
      "source": "eoc", "approved": true, "citation": "2026 SCAN Allied Summary of Benefits (26C-SBH5425123), Fitness section" }
  ]
}
```

**Merge rules:**

1. Scalars (vendor, tagline, CTA, note) — more specific level **replaces** less specific.
2. Fact rows — merged by label, so an override can change one row without redeclaring the card.
3. `eoc_facts` — append-only; each entry requires `approved: true` **and** an EOC/SB citation or the compiler rejects the build.
4. **No literal dollar amounts** outside approved `eoc_facts` — at any level. Numbers enter only through `{slot}` references resolved against the plan's PBP JSON. A plan-level override cannot reintroduce hardcoded numbers.
5. A plan with no content files at all still compiles — base wording + PBP numbers. Specificity is opt-in polish, never a launch dependency.

**Level guidance:** carrier is the workhorse; contract-level when one carrier varies vendors by contract (state or HMO/PPO product line); plan-level for one-off riders; segment-level is supported by the ID scheme (`H5425_123_0`) but deliberately unused until a real employer-group case requires it.

### 9.6 Integration with the existing vendor-upload process

Product already uploads vendor info (name / phone / website / how-to-use / next
steps) **per benefit, per PBP**, before plan documents are seeded and benefits
generated, with configured vendors taking priority over anything parsed from the
EOC. This maps directly onto the architecture — no workflow change required:

1. **The vendor upload IS the plan-level content tier.** The compiler ingests it
   as an input source (via export or API) and treats it as the most specific
   layer: **uploaded PBP vendor config > contract file > carrier file > base
   template.** Nobody re-enters existing vendor data as files.
2. **The precedence rule is unchanged.** "Configured vendor beats EOC parse" is
   the compiler's existing rule (human-configured > EOC-derived).
3. **New rule the current process lacks: vendor config decorates, never gates.**
   A configured vendor on a benefit the PBP says is not covered does NOT make
   the card render. The compiler report flags such orphaned vendor configs —
   which doubles as QA for stale vendor entries when a plan drops a benefit at
   renewal (the inverse of the transportation incident).
4. **Optional efficiency win:** carrier/contract tiers let product enter a
   vendor once for all of a carrier's plans and override per-PBP only where a
   plan genuinely differs. Existing per-PBP entries remain authoritative.

Compiler input mapping for the upload: `vendor` → card `vendor`; phone/website →
`cta` (tel/web); how-to-use / next steps → section `note` (and CTA label where
actionable). Fields absent from the upload fall through to the next tier.

**Source system: the admin tool (markdown blob per plan + benefit).** The
vendor/how-to-use config is authored in product's admin tool as a **markdown
blob**, not structured fields. That dictates the ingestion design:

- **Render, don't parse.** The blob becomes its own card section ("How to use
  this benefit") — sanitized markdown, shown verbatim. Free text cannot be
  reliably decomposed into vendor/phone/website fields, so the compiler doesn't
  try. The blob sits at the same precedence tier as before: most-specific human
  content, beats carrier/base wording.
- **Deterministic CTA extraction only.** Phone numbers and URLs are the two
  things safely extractable by pattern — they become the tap-to-call /
  visit-website buttons. Everything else stays as rendered text.
- **Dollar amounts in blobs are flagged, not blocked.** Free-text numbers can't
  be validated against PBP, so the compiler lists them in the plan's report for
  review rather than failing the build (existing content keeps working; over
  time those migrate to slots or `eoc_facts`).
- **Gating unchanged.** A blob renders only if PBP covers the benefit; orphaned
  blobs are reported.

The compiler consumes a read-only export or API — the admin tool stores **one
row per covered benefit per PBP** with a markdown description field, so the
export is exactly: `plan_id + benefit_name + description_markdown
(+ last_modified)`. Because "a row exists" is the admin tool's implicit notion
of covered and "key present" is PBP's, the compiler report reconciles both
directions: a row whose benefit PBP doesn't cover never renders and is flagged
(catches lingering rows after a plan drops a benefit at renewal); a PBP-covered
benefit with no row renders fine on base wording and is listed — which doubles
as product's per-plan to-do list of missing vendor content. Two mappings to
settle with product before wiring it up:

1. **Plan identity crosswalk** — confirm the admin tool keys entries by CMS
   identity (`H5425_123_0` = contract_plan_segment). If it uses internal plan
   IDs, the compiler needs the crosswalk table.
2. **Benefit-name mapping** — a one-time ~15-row table mapping the admin tool's
   benefit names to taxonomy card keys (`fitness`, `otc`, `dental`, …).
   Unmapped admin-tool benefits appear in the compiler report so they can't be
   silently dropped.

The compiler treats the export as read-only input, same as the plan JSONs —
the admin tool remains the single place product edits vendor data.
