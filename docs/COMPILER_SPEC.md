# Card Compiler — Specification

The compiler is the only new engineering component. It is a deterministic,
build-time script (Python next to `preprocess.py`, or TypeScript in the app
repo — team's choice) that produces one `benefit-cards/<plan_id>.json` per plan.

```
INPUT   data/plans/<plan_id>.json          (generated PBP coverage data)
        03-content/  (taxonomy, registry, base/, carriers/, contracts/, plans/)
OUTPUT  benefit-cards/<plan_id>.json       (CompiledPlanCards — see benefit-card.types.ts;
                                            the wrapper carries planId, dsnpZeroDollar,
                                            build metadata, and cards: BenefitCard[])
        reports/<plan_id>.report.json      (completeness + discrepancy report)
```

## 1. Resolution

For each card in `taxonomy.json` (in order):

1. **Gate:** render the card only if ANY key in `pbpSources` is present in the
   plan's `benefits` object (for `prescriptions`: `drug_coverage.has_drug_benefit === true`).
2. **Resolve content stack:** `base/<key>.json` ← `carriers/<carrier>/<key>.json`
   ← `contracts/<H#>/<key>.json` ← `plans/<H#_plan>/<key>.json`, where carrier
   comes from `registry.json` by contract number. Missing files are skipped.
   Merge rules: scalars replace; fact rows merge by `label`; `eoc_facts` append.
3. **Fill slots** (below) against the plan JSON.
4. **Drop empty:** a fact row whose slot doesn't resolve is dropped. A section
   with zero facts is dropped. A card with zero sections is dropped (log it).

## 2. Slot syntax

- `{path.to.field}` — resolved against the plan JSON. `fitness.copay` reads
  `benefits.fitness.copay`; `drug_coverage.deductible` reads top-level.
- `{path|default}` — fallback literal if the field is missing, e.g.
  `{fitness.copay|$0}` (use ONLY where CMS semantics justify it — a fitness
  benefit with no filed copay is $0 by definition of the filing; when in doubt,
  no default → row drops).
- `forEach` facts iterate arrays:
  ```json
  { "forEach": "dental_preventive.sub_types", "label": "{item.label}", "slot": "item.copay" }
  ```
  Used for dental sub_types, drug tiers, combined-benefit groups, OON cost-sharing.
- **`null` is never $0.** A resolved value of null/absent means "not filed" —
  the row drops or the template's explicit fallback line ("See plan documents
  for cost details") is used. Only the literal string `"$0"` renders as $0.
- **Fact-level `default`:** a fact may declare `"default": "…"` — when both
  `slot` and `altSlot` are unresolved, the row renders with that text instead
  of dropping. Distinct from inline `{path|literal}` defaults, which substitute
  into a larger string.
- **Unresolved slots in `tagline` / `tileSubtitle` / `prefix` / `suffix`:** the
  unresolved fragment is omitted along with its adjacent separator ("·", "—");
  if the whole tagline ends up empty, fall back to the card `title`. Never
  render a raw `{...}` placeholder.
- **Derived arrays:** `social_supports` in the plan JSON is a dict keyed by
  benefit name plus boolean summary flags — there is no `items` array in the
  data. The compiler derives `social_supports.items[]` from the object-valued
  entries (in file order) so templates can `forEach` over it.

## 2b. Internal data never renders to members

Provenance and CMS filing metadata exist for QA, support tooling, and audits —
NOT for the member screen:

- `source`, `pbpPath`, and `citation` on fact rows stay in the compiled JSON
  but the renderer never displays them (no "from your plan team", no "verified
  vs Summary of Benefits", no source badges).
- CMS filing jargon never renders: `benefit_type` ("Mandatory"/"Optional"),
  service-category codes ("13b", "16c1"), attestation flags, and package_type
  codes are internal-only. Member-facing labels come from templates.
- If a fact's only content is filing metadata, the fact doesn't render.

## 3. Hard rules (build failures, not warnings)

1. A literal dollar amount (`/\$\d/`) in any content field → **build error**,
   with exactly three carve-outs: (a) `eoc_facts[].value`; (b) a fact `value`
   whose `source` is `"computed"` (year constants, statutory attestations);
   (c) the default half of inline slot syntax `{path|$0}`. Anywhere else —
   labels, taglines, notes, plain values — a typed dollar fails the build.
2. An `eoc_facts` entry without `approved: true` AND a non-empty `citation` →
   **build error**.
3. An `eoc_facts` entry whose parent card's gate is closed → entry silently
   dropped (EOC facts can never un-gate a card) + report line.
4. Unknown card key in a content file (not in taxonomy) → **build error**.

## 4. Special constructs

### 4a. Shared-wallet & package consolidation (ONE wallet = ONE card)

**The mental model.** Every plan with an allowance gets exactly one card per
allowance. The card type and name depend on what the plan filed:

| Plan shape | Card shown | Contents |
|---|---|---|
| Standalone OTC dollar, no wallet | OTC card | Allowance amount, how to use it, covered benefit (OTC) |
| Shared wallet spanning card types | One wallet card | Allowance amount + period, how to use it, everything the money covers (OTC, SSBCI items, healthy foods… whatever the plan filed) |
| Allowance scoped to ONE card type (e.g. a dental annual maximum) | No separate card | Renders as the max row on that benefit's own card |

The card always contains: the allowance amount, how to use the allowance, and
the benefits covered by that allowance. **Card naming ladder** (first match
wins): carrier-pack title ("Healthy Options card") → VBID package name from
the filing, only when descriptive/multi-word ("Healthy Options Allowance";
a single-word package name like "Food" defers) → combined-group name
("Grocery-OTC") → generic base template ("Flex allowance").

**Reference implementation:** `dashboard/workbench.html` (+ `js/workbench.js`)
in the CMS package — a browser-only workbench that runs these rules against any
of the 8,081 generated plans, with a carrier-pack editor, §4b admin-row intake,
and the per-plan report. Its Corpus-audit tab compiles every plan; baseline
2026-07-03: 8,081/8,081 pass, 0 single-surface violations. A copy ships in this
handoff under `workbench/` (point it at the dashboard `data/` folder or serve
it next to one). Implementation note proven by the corpus audit: member-card
dollar suppression must be evaluated against the member's OWNING wallet — plans
can file multiple combined groups, and suppressing against only the first
wallet leaks pooled amounts (91 plans exhibited this before the fix).

**Why this rule exists:** CMS files the same wallet in up to THREE places —
`otc_items` (13b), `social_supports` items (13i), and a `vbid_packages`
supplemental package (b19b) whose `benefit_categories` list them all — and
Section D `combined_benefits.groups[]` carries the pooled dollar. Rendered
naively this produces three overlapping member-facing cards describing one
allowance (observed on Humana H7617-076: "Special benefit packages" +
"Everyday living support" + an OTC card, all restating the same $225/month
card). The compiler MUST consolidate. Deterministic algorithm, applied per
plan after gating:

1. **Wallet cards.** Each `combined_benefits.groups[]` entry renders exactly one
   wallet section (`flexAllowance`) — group `name`, pooled `max_plan_benefit` +
   `max_plan_benefit_period`. Never sum allowances across groups. EXCEPTION: a
   group whose member categories all map to a single card (via `pbpCategories`,
   e.g. a dental-only maximum) does NOT render a wallet card — its pooled
   dollar renders as the "plan pays up to" row on that card instead (the
   single-surface rule decides where the dollar lives).
2. **Wallet membership.** A wallet's members are the service-category codes
   parsed from its `categories[]` (the `(code)` suffix) plus period-linked
   `includes[]`. Map codes to cards via `taxonomy.json` `pbpCategories`
   (longest-prefix match, e.g. `14c4` beats `14`).
3. **Member benefits never show standalone dollars** (unchanged rule) — and a
   member card whose remaining facts after dollar suppression carry no
   benefit-specific substance (no visit/trip limits, no vendor, no logistics —
   just "Included"/"Covered" rows) is ABSORBED: don't render it; its label
   becomes an "Included" row on the wallet card. A member card WITH substance
   (transportation ride counts, hearing-aid vendor) still renders, with the
   cross-reference "Included in your {wallet name} allowance" instead of a dollar.
4. **VBID package dedupe.** For each `vbid_packages` package, parse its
   `benefit_categories` codes and test coverage against (wallet member codes ∪
   rendered-card `pbpCategories`):
   - **Fully represented** → do NOT render it on the `vbidPackages` card.
     Instead stamp `requiresEligibility: "ssbci"` onto the wallet card and each
     covered card, and — when the package shares ≥1 category with a wallet
     group and is supplemental type — use the package's name as the wallet
     card's member-facing name (e.g. "Healthy Options Allowance" over the
     filing label "Healthy Options/OTC Allowance"), unless a carrier pack
     overrides the title.
   - **Partially represented** → render the package with ONLY the unrepresented
     categories; represented ones get the cross-reference treatment.
   - Unknown/unmapped category codes fail OPEN (count as unrepresented) so
     coverage is never silently lost.
   - `vbidPackages` renders as its own card only if at least one package (or
     package remainder) survives; cost-sharing-reduction packages always render
     their reduced-benefit list (they have no card overlap by construction).
5. **Single-surface rule (invariant):** a dollar amount appears on exactly ONE
   card; a benefit/category never renders as two cards. Cross-references are
   the only permitted duplication. The report must prove this (see §5).

### 4b. Other special constructs

- **D-SNP zero-dollar:** if `plan_info.dsnp_zero_dollar === true`, add the
  plan-level flag to the output; the renderer shows the "$0 member liability"
  banner. Do NOT rewrite the underlying values (same policy as the dashboard's
  `benefit-formatter.js`).
- **SSBCI (`socialSupports`) — compile-time vs render-time gating:** compiled
  cards are per-PLAN; SSBCI eligibility is per-MEMBER. The compiler applies the
  PBP gate as usual (plan covers SSBCI → card is compiled) and stamps the card
  `requiresEligibility: "ssbci"`. The app then shows/hides it at render time
  using the existing member-eligibility-file flag (product confirmed this flag
  already exists). Items with `max_plan_benefit_note: "Included in combined
  supplemental allowance"` never show a standalone dollar — and when ALL of a
  plan's SSBCI items are wallet-funded, the whole card is absorbed into the
  wallet card per §4a step 3.
- **VBID package `eligibility` strings** (condition names) render as an
  informational line, not as the gate — the member file is the gate.
- **Year constants:** `content/year-constants/<year>.json` (Part D
  out-of-pocket cap, insulin cap). Facts referencing them get `source: "computed"`.

## 4b. Admin-tool vendor rows

The admin tool stores one row per covered benefit per PBP:
`plan_id + benefit_name + description_markdown (+ last_modified)`.

- **Plan ID crosswalk (confirmed):** admin IDs are contract+pbp+segment with no
  separators, parsed by position (5+3+3). Segment rule: no defined segment =
  `000`; defined segment = its value zero-padded to 3 digits. So pipeline
  `H5425_123_0` ↔ admin `H5425123000`; pipeline segment `12` ↔ admin `012`.
- **Benefit-name mapping:** `03-content/admin-benefit-mapping.json` maps all 17
  admin benefit names to taxonomy card keys. An admin benefit name not in the
  mapping → **build error** (never silently dropped).
- **Blob handling:** render the markdown as a "How to use this benefit" section
  on the mapped card; extract only phone numbers/URLs for CTAs; flag free-text
  dollar amounts in the report; the PBP gate still decides whether the card
  renders at all.
- **subTypeFilter cards** (`inHomeSafety`, `pers`, `wigs`): gate on the matching
  entry in `additional_preventive.sub_types` (by label). Slots use the
  `subType.` prefix, resolved against that entry. The `preventiveCare` card
  renders only the sub_types NOT claimed by a subTypeFilter card — no
  double-display.

## 5. Reports (per plan)

`reports/<plan_id>.report.json`:

```json
{
  "plan_id": "H5425_123_0",
  "cards_rendered": ["doctorVisits", "prescriptions", "..."],
  "cards_gated_off": ["dental"],
  "facts_dropped": [ { "card": "vision", "label": "Eyewear allowance", "reason": "slot unresolved: eyewear.max_plan_benefit" } ],
  "eoc_facts_included": [ { "card": "fitness", "label": "Includes", "citation": "..." } ],
  "content_fallbacks": { "fitness": "carrier:scan", "meals": "base" },
  "vbid_packages_suppressed": 1,
  "wallet_consolidations": [
    {
      "wallet": "Healthy Options Allowance",
      "combined_group": "Healthy Options/OTC Allowance",
      "cards_absorbed": ["otc", "socialSupports"],
      "cards_cross_referenced": ["transportation"],
      "vbid_packages_merged": ["Healthy Options Allowance", "Non-Emergency Medical Transportation"]
    }
  ]
}
```

The `wallet_consolidations` section is the §4a single-surface proof: every
dollar-bearing category must appear exactly once across `cards_rendered` +
`cards_absorbed`. A category appearing on two rendered cards is a build error.

A plan is launch-eligible when its report is reviewed and clean. Aggregate
report (counts per card type across all plans) doubles as the annual
column-drift alarm: a card count that drops sharply year-over-year means a CMS
column was renamed upstream (see AUDIT_2026.md §7 in the CMS package).

## 6. Non-goals

- No runtime merging — everything happens at build time; the app renders static JSON.
- No EOC parsing/NLP — EOC content enters only through hand-approved `eoc_facts`.
- No editing of generated plan JSONs — pipeline output is read-only input.
