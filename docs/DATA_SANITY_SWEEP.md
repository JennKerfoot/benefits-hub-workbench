# Data Sanity Sweep — Regenerated CMS Plan Corpus (PY2026)

**Date:** 2026-07-05
**Corpus:** `CMS Benefit Data/CMS-PBP-Translation-Package-2026/dashboard/data/plans/` — 8,081 JSON files, 8,081 parsed, 0 parse errors.
**Raw source for verification:** `CMS-PBP-Translation-Package-2026/pbp-benefits-2026/` (tab-delimited PBP extracts + data dictionary).
**Method:** Full recursive walk of every string leaf in every plan file (python glob), pattern checks on dollar/percent strings, structural checks on benefits/drug tiers/costs, with close calls verified against the raw PBP `.txt` files.

## Summary Table

| # | Check | Plans affected | Occurrences | Verdict |
|---|-------|---------------:|------------:|---------|
| 1a | `hearing_aids.max_plan_benefit_per_ear` = "$1"/"$2"/"$3" | **2,081** | 2,081 | **PIPELINE BUG** — enum code rendered as dollars |
| 1b | Copays of $1–$5 | 2,835 | 9,877 | FILED-AS-IS — real drug-tier & low medical copays |
| 1c | Dollar values > $50,000 | 1,124 | 1,124 | FILED-AS-IS — worldwide emergency caps ($60k–$250k), verified in raw |
| 2 | Reversed ranges (min > max) | 0 | 0 | CLEAN |
| 3 | Identical min/max rendered as range ("$20 - $20") | 0 | 0 | CLEAN |
| 4a | Coinsurance > 100% | 0 | 0 | CLEAN |
| 4b | Coinsurance exactly "0%" | 1,646 | 4,529 | FILED-AS-IS — raw files 0%; display-polish item |
| 5 | Label-only benefit objects | ~5,300 (varies by key) | 37 keys | **PIPELINE BUG** — stubs emitted for benefits the raw data says are NOT offered |
| 6a | `unlimited: true` + numeric `max_plan_benefit` | 39 | 58 | FILED-AS-IS — "unlimited" is visit count, cap is dollars; schema conflation |
| 6b | `deductible_applies: false` + deductible amount | 0 | 0 | CLEAN |
| 7 | Combined-benefit groups with $0/missing cap and no `no_dollar_cap` | 0 | 0 | CLEAN |
| 8 | Drug tier cheaper than Tier 1 (same channel) | 697 | 2,288 | FILED-AS-IS — 99.4% are Tier 6 "Select Care Drugs"/"Vaccines" special tiers |
| 9a | `monthly_premium` missing | 2,486 | 2,486 | Mixed: EGHP/PACE expected; **367 PDPs = SOURCE GAP** (PBP has no Part D premium) |
| 9b | `max_out_of_pocket` missing (incl. combined) | 1,097 | 1,097 | FILED-AS-IS — all plan types with no MOOP concept (PDP/PACE/MSA/Cost/PFFS) |
| 9c | MOOP < $1,000 | 142 | 148 | FILED-AS-IS — verified $299 and $0 in raw Section D |
| 9d | MOOP > $15,000 | 0 | 0 | CLEAN |
| 10 | "nan" / "NaN" / "None" / "$$" in strings | 0 | 0 | CLEAN |

**Bottom line: 2 pipeline-bug classes (1a, 5), 1 source-gap class (9a PDP premiums), 7 filed-as-is classes, 7 clean classes.**

---

## Pipeline Bugs (fix before member-facing launch)

### 1a. Hearing aids "max plan benefit per ear" is an enum leaked as a dollar amount — 2,081 plans

Every value of `benefits.hearing_aids.max_plan_benefit_per_ear` in the corpus is $1, $2, or $3:

| Value | Plans |
|-------|------:|
| "$1" | 1,155 |
| "$3" | 925 |
| "$2" | 1 |

The source field is `pbp_b18b_maxplan_perear`, which per the PBP data dictionary is a code, not a dollar amount:

> "Does the Maximum Plan Benefit Coverage Amount apply per ear or for both ears combined?"
> 1 = Per ear, 2 = One single ear, 3 = Both ears combined

**Raw verification (H0028_007):** `pbp_b18b_maxplan_perear = '1'`, `pbp_b18b_maxplan_amt = '2000.00'`. The JSON's `max_plan_benefit: "$2000"` is correct; `max_plan_benefit_per_ear: "$1"` should read "applies per ear."

Examples: `H0028_007_0` ("$1"), `H0028_015_0` ("$1"), plans with "$3" (e.g. the 925 plans where the cap applies to both ears combined).

**Member impact:** A screen would show "Hearing aid benefit: $1 per ear." **Fix:** map 1/2/3 → "Per ear" / "One single ear" / "Both ears combined" (or a `benefit_applies_per` string field).

### 5. Label-only stubs emitted for benefits the plan does not offer

37 benefit keys appear in some plans as `{"label": "..."}` with no other data. Two distinct populations:

1. **PACE cohort (expected):** 396 PACE plans (e.g. `H0016_001_0`, `H0105_001_0`) have **all 37 benefit keys** label-only — PACE plans don't file PBP cost-sharing detail. This drives the uniform 418/543 counts across medical keys.
2. **Non-offered benefits (bug):** for regular MA plans, a label-only stub is emitted even when the raw data says the benefit is **not offered**. Verified: `H0028_014_0` has `transportation: {"label": "Non-Emergency Transportation"}` while raw `pbp_b10b_bendesc_yn = '2'` (No — benefit not offered).

Label-only counts by key (top): transportation 5,268; meals 3,665; otc_items 2,758; dental_preventive 2,621; dental_comprehensive 2,574; hearing_aids 2,118; telehealth 1,919; additional_preventive 1,177; dental_medicare 957; urgent_care 711.

**Member impact:** a benefits screen keyed off object presence would list "Non-Emergency Transportation" / "Meal Benefit" as covered on thousands of plans that don't offer them. **Fix:** omit the key when `bendesc_yn = 2`, or add `offered: false`; treat PACE plans as a special display case.

---

## Source Gap

### 9a. PDP monthly premiums missing — 367 of 367 non-EGHP PDPs (100%)

All individual-market PDPs (e.g. `S5884_167_0`, `S4802_074_0`, `S5617_354_0`) have `monthly_premium: null`. This is not an extraction error: PBP Section D carries only the Part C premium (`pbp_d_mplusc_premium`) and contains zero S-contract rows — Part D premiums simply are not in the PBP dataset. The remaining missing premiums are expected: 1,719 EGHP 800/900-series plans (employer-negotiated, never filed) and 396 PACE plans, plus 4 stragglers (2× 1876 Cost, 1 MSA, 1 HMO).

**Member impact:** every standalone drug plan shows no premium. **Fix:** join the CMS Landscape/CPSC premium file before PDP data is member-facing.

---

## Filed-As-Is (raw CMS data really says this)

### 1b. $1–$5 copays — 2,835 plans, 9,877 occurrences
Dominated by drug-tier copays where whole-dollar $1–$5 amounts are routine: `ltc_copay` (2,037), `oon_copay_30day` (1,526), `insulin_retail_copay_30day` (933), `retail_copay_30day` (882), `preferred_retail_copay_30day` (709). Medical-side hits are plausible low copays: `diagnostic_procedures.copay` $5 (139, e.g. `H0609_026_0`), `primary_care.copay` $5 (110, e.g. `H0104_012_0`), `mental_health_specialist.copay_group` $2 (99, e.g. `H0524_041_0`). No action needed. (Note the known-bad "$1" example the sweep was seeded with lives in class 1a, not here.)

### 1c. Dollar values over $50,000 — 1,124 plans
All 1,124 hits are `benefits.worldwide_emergency.max_plan_benefit` ($60,000–$250,000). Verified raw: `H0302_001` `pbp_b4c_wwc_maxplan_amt = 60000.00`; `H0523_022` `= 250000.00`. Real lifetime/annual caps on worldwide emergency coverage.

### 4b. "0%" coinsurance strings — 1,646 plans, 4,529 occurrences
Top paths: `network.oon_cost_sharing[].coinsurance` (1,393), `lab_services.coinsurance` (1,293), `home_health.coinsurance` (1,289). Verified raw: `H0028_801` files `pbp_b8a_coins_pct_lab = 0`. Legitimate filing meaning "you pay 0%." **Display suggestion:** render as "$0 (covered in full)" — "0% coinsurance" reads oddly to members.

### 6a. `unlimited: true` alongside a dollar `max_plan_benefit` — 39 plans, 58 occurrences
E.g. `H0562_012_0` `hearing_exams`: `unlimited: true` + `max_plan_benefit: "$25"`. Verified raw: `pbp_b18a_bendesc_lim_rht = '1'` ("Is this benefit unlimited [in number of exams]? Yes") and `pbp_b18a_maxplan_amt = 25.00`. Not a contradiction in the source — "unlimited" counts visits, the cap counts dollars — but the flattened JSON puts both on one object. Other examples: `H1994_031_0` (eye/hearing exams, $1,200 cap), `H3347_003_0` (transportation, $1,000 per 3 months). **Display suggestion:** label the flag "unlimited visits" so it can't be read as "no dollar cap."

### 8. Drug tiers cheaper than Tier 1 — 697 plans, 2,288 occurrences
2,274 of 2,277 copay inversions are **Tier 6**, labeled "Select Care Drugs" (2,107) or "Vaccines" (167) — special low/zero-cost tiers that are cheaper than Tier 1 by design (e.g. `H0028_039_0` tier 6 insulin mail $0 vs tier 1 $10; `H0029_007_0` tier 6 preferred retail $0 vs $18). The remaining 3 are "Select Care Drugs" filed as tier 5, plus 11 trivial coinsurance inversions. **Caveat for UI:** don't assume monotonic tier pricing when sorting/labeling tiers.

### 9b. Missing MOOP — 1,097 plans
By type: PDP 659 + Employer PDP 2, PACE 396, MSA 19, 1876 Cost 19, PFFS 2. All are plan types where an in-network MOOP either doesn't exist (PDP, PACE) or is structured differently (MSA). Expected; suppress the MOOP row for these types rather than showing a blank.

### 9c. MOOP under $1,000 — 142 plans (148 values)
Value distribution: $500×40, $800×25, $499×14, $799×9, $199×8, $900×7, $599×6, $999×6, $0×6, $299×4, others. Verified raw Section D: `H0523_085` files `pbp_d_out_pocket_amt = 299.00`; the five $0-MOOP plans (`H2422_002_0`, `H5549_003_0`, `H9485_003_0`, `H3954_806_0`, `H8764_801_0`) all file `0.00` literally (H9485 also files combined `0.00`). Genuinely filed; $0 MOOP is typical of zero-cost-share D-SNP/EGHP designs. Optional UX: render $0 MOOP as "You pay nothing out of pocket."

---

## Clean Classes (zero hits across 8,081 plans)

- Reversed dollar or percent ranges (min > max)
- Identical min/max rendered as a range ("$20 - $20")
- Coinsurance over 100%
- `deductible_applies: false` with a deductible amount present
- Combined-benefit groups with $0/missing cap while `no_dollar_cap` is false/absent
- MOOP over $15,000
- Junk strings: "nan", "NaN", "None", "$$"

The regeneration is structurally sound: no malformed ranges, no serialization junk, no impossible percentages.

## Recommended Actions (priority order)

1. **Fix 1a** — map `pbp_b18b_maxplan_perear` enum to text; regenerate `hearing_aids` for 2,081 plans.
2. **Fix 5** — stop emitting label-only stubs when `*_bendesc_yn = 2`; add an explicit PACE handling rule.
3. **Close 9a** — join PDP premiums from the CMS Landscape/CPSC file (367 plans).
4. Display polish (no data change): "0%" → "$0 (covered in full)"; "unlimited" → "unlimited visits"; suppress MOOP row for PDP/PACE/MSA/Cost; don't assume tier price monotonicity (Tier 6 special tiers).
