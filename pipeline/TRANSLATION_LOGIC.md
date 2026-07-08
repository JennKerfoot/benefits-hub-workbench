# PBP → Dashboard Translation Logic

How the raw CMS Plan Benefit Package (PBP) landscape files are translated into the
per-plan benefit JSON the dashboard renders. This is the authoritative reference for
engineers maintaining `preprocess.py`.

---

## 1. Pipeline overview

```
pbp-benefits-2026/*.txt   (raw CMS PBP, tab-delimited)
        │
        ▼
preprocess.py
   ├─ process_plans_summary()      → plans_summary.json, states.json, geo_index.json
   ├─ load_all_benefit_data()      → in-memory dict: {section_key: DataFrame}
   └─ build_plan_detail(plan_id)   → data/plans/<plan_id>.json   (one file per plan)
        │
        ▼
dashboard (index.html + js/ + css/)
   └─ data-loader.js fetches data/plans/<id>.json → benefit-formatter.js renders HTML
```

- **Input:** one tab-delimited `.txt` per PBP section (Section A/C/D, b1–b20, mrx, mrx_tier,
  mrx_p, vbid, b19a/b19b, etc.). Each `.txt` has a sibling `.sas` file that documents every
  column name + width (the CMS record layout).
- **Output:** `data/plans/H#####_###_#.json` — one JSON per plan with `plan_info`, `costs`,
  `network`, `benefits` (≈40 benefit objects), and `drug_coverage`.
- **Plan ID:** `H{contract}_{plan}_{segment}` e.g. `H0976_001_0`.

Run:
```
cd dashboard
python3 preprocess.py            # regenerates data/  (needs pandas; ~8,081 plans, a few min)
python3 -m http.server 8765      # then open http://localhost:8765/
```

---

## 2. Core primitives (preprocess.py)

| Helper | Purpose |
|---|---|
| `read_txt(filename)` | Loads a CMS `.txt` as a pandas DataFrame, `dtype=str`, `encoding="latin-1"`, `fillna("")`. Adds a `_plan_id` column. |
| `safe_get(row, col)` | `row.get(col, "")` then strip / NaN→"". **Returns "" if the column does not exist in that file** — this is the silent-data-loss trap that the audit fixed. |
| `yn(v)` | CMS Y/N codes: `"1"→True`, `"2"→False`, else `None`. |
| `to_dollar(v)` | numeric → `"$N"` / `"$N.NN"`. |
| `to_pct(v)` | numeric → `"N%"`. |
| `dollar_range(min,max)` / `pct_range(min,max)` | collapse a min/max pair into `"$A - $B"` / single value. |
| `clean_dict(d)` | drops keys whose value is `None`/`""`. |
| `get_plan_row(data,key,id)` / `get_plan_rows(...)` | single / multi-row lookup by `_plan_id`. |

### Code → label maps
- `SNP_TYPE_MAP` — `pbp_a_special_need_plan_type`: **1/2 = I-SNP, 3 = D-SNP, 4 = C-SNP**
  (verified empirically; the value `3` is Dual, NOT Institutional).
- `AUTH_MAP` — auth/referral fields are **binary: 1 = Yes, 2 = No** (verified: value `3` never
  occurs in 506k values across 112 fields; "Yes, for some" was a mis-decode).
- `PERIODICITY_MAP` — `1→Every 3 years … 3→Every year … 7→Every month`.
- `SERVICE_CATEGORY_MAP` + `label_category()` — PBP service-category codes (e.g. `13b`,
  `10b1`, `13i3`, `16c10`) → human names; emitted as `"Name (code)"`. Falls back to the base
  letter-category (`13i3`→`13i`) when a sub-code isn't separately named by CMS.
- `BENEFIT_TYPE_MAP`, `TRIP_TYPE_MAP`, `TRANSPORT_MODE_LABELS`, `DSNP_TYPE_MAP`.

---

## 3. The naming-convention gotchas (most important section)

CMS does **not** use one uniform column-naming scheme. The same logical field (e.g. a copay
min) is spelled differently per section. `extract_simple_benefit` / `extract_supplemental_benefit`
therefore try an **ordered fallback chain** of column-name variants and use the first that exists
& has data. Known families:

**Copay min variants tried:**
`_copay_amt_mc_min` · `_copay_mc_amt_min` · `_copay_mc_amt` · `_copay_mcmin_amt` ·
`_copay_mc_min_amt` · `_copay_min_dmc_amt` (b8a diagnostic procedures/tests) · `_copay_ohs_amt_min`
(b9a outpatient hospital) · `_copay_gas_amt_min` (b10a ambulance) · `_copay_amt_mc_min_crs`
(b3 cardiac) · `_copay_min_amt` · `_copay_amt_min` · `_copay_amt_rpe_min` (b14b annual physical)

**Coinsurance min variants:** analogous, incl. `_coins_pct_dmc` (b8a), `_coins_pct_tmc`
(b8b therapeutic radiology), `_coins_ohs_pct_min` (b9a), `_coins_gas_pct_min` (b10a),
`_coins_pct_mc_min_crs` (b3).

**Service-specific suffixes seen in 2026:**
`dmc`=diagnostic procedures/tests (8a1), `lab`=lab services (8a2), `drs`=diagnostic radiology
CT/MRI (8b1), `tmc`=therapeutic radiology (8b2), `mc`/`cmc`=X-rays (8b3), `ohs`=outpatient-hospital,
`obs`=observation, `gas`=ground ambulance, `aas`=air ambulance, `rpe`/`rht`=routine exam,
`fha`=fitting, `crs/icrs/prs/setpad`=cardiac sub-services, `rex`=routine eye exam.

**Question-polarity gotcha:** `pbp_b17a_bendesc_lim_rex` / `pbp_b18a_bendesc_lim_rht` ask
"Is this benefit **unlimited**?" (1=Yes, 2=No, indicate number) — the OPPOSITE polarity of the
generic `_bendesc_lim_yn` family. Check each field's JSON QUESTION in the dictionary before
mapping yes/no codes.

**Inpatient/SNF interval families** (`extract_inpatient`): per-day cost-sharing is stored in
interval "families" tried in order — `mcs` (Medicare-covered stay, the populated one),
`ad` (additional days), `lrd` (lifetime reserve). Reading the wrong family yields blanks.

**Wrong-prefix cases fixed:** cardiac rehab is `pbp_b3_*` (not `b3a`); Part B drugs is
`mrx_b_*` (not `pbp_b15_*`, handled by the dedicated `extract_partb_drugs`).

**Suffix-coded sub-types (not numbered):**
- Preventive dental (b16b): `oe, pc, ft, dx, ods, ops, ov`.
- Comprehensive dental (b16c): `rs, end, peri, prm, prf, impl, orth, omsg, ags, mxpr`.
- Additional preventive (b14c): `hec, ntb, sc, mhc, edm, tm, rat, bsd, cs, isa, prs, mnt,
  imr, rp, wig, wm, at, thmg/thms, adcs, hbpc, ihss, sce`.
- Other Medicare preventive (b14e): per-service `glauc, diab, dre, ekg`.

> If a future CMS year renames columns, update the fallback chains / suffix lists — `safe_get`
> will silently return "" otherwise. Use the runtime column audit (section 7) to detect this.

---

## 4. Section-by-section mapping

| Output key | Source file / prefix | Extractor |
|---|---|---|
| `plan_info` (name, SNP type, dsnp_zero_dollar, contacts) | Section A | `process_plans_summary` |
| `costs` (premium, MOOP + combined in+OON MOOP, deductible + Medicare-defined deductible type, Part B reduction) | Section D | `process_plans_summary` |
| `inpatient_acute` / `inpatient_psychiatric` | b1a / b1b (`_mcs_` intervals) | `extract_inpatient` |
| `skilled_nursing` | b2 (`_mcs_` intervals) | `extract_inpatient` |
| `cardiac_rehab` | b3 (`_crs` suffix) | `extract_simple_benefit` |
| `emergency_care` / `urgent_care` / `worldwide_emergency` | b4a/b4c | `extract_emergency` |
| `partial_hospitalization` / `intensive_outpatient` | b5a / b5b | `extract_simple_benefit` |
| `home_health` | b6 | `extract_simple_benefit` |
| primary_care, chiropractic, specialist, OT, podiatry, telehealth, etc. | b7a–b7k | `extract_simple_benefit` / `extract_mental_health` |
| `diagnostic_procedures` (`_dmc_`) / `lab_services` (`_lab_`) | b8a | `extract_b8a_diagnostic` |
| `diagnostic_radiology` (`_drs_`) / `therapeutic_radiology` (`_tmc_`) / `basic_radiology` X-rays (`_mc_`/`_cmc_`) | b8b | `extract_b8b_radiology` |
| `outpatient_hospital` (`_ohs_`/`_obs_`, `auth_ohs_yn`) / `ambulatory_surgery` / `outpatient_rehabilitation` | b9a/b9b/b9d | `extract_simple_benefit` |
| `ambulance` (`_gas_`/`_aas_`) / `transportation` (NEMT, `_pal`/`_al`) | b10a / b10b | `extract_simple_benefit` + `extract_transport_details` |
| `dme` / `prosthetics` / `medical_supplies` (`_mcmin_amt`) | b11a/b11b/b11c | `extract_simple_benefit` |
| `renal_dialysis` | b12 | `extract_simple_benefit` |
| acupuncture, OTC items, meals, other_services_1/2/3 | b13a–b13f | `extract_b13_other_services` |
| `social_supports` (SSBCI: food, meals, pest, transport, air, etc.) | b13i | `extract_b13i_ssbci` + `extract_supplemental_benefit` |
| preventive (annual_physical `_rpe_`, kidney_disease_education, additional_preventive sub-types, other_medicare_preventive per-service) | b14a–b14e | `extract_b14_preventive` |
| `part_b_drugs` | b15 (**`mrx_b_*`**) | `extract_partb_drugs` |
| `dental_medicare` (`copay_mc_amt`) / `dental_preventive` / `dental_comprehensive` (suffix sub-types) | b16a/b16b/b16c | `extract_dental_detail` |
| `eye_exams` (`_rex` limits) / `eyewear` (`_upg_`) | b17a / b17b | `extract_vision_detail` |
| `hearing_exams` (`_rht`/`_fha`) / `hearing_aids` (`maxplan_perear`) / `otc_hearing_aids` | b18a/b18b/b18c | `extract_hearing_detail` |
| `enhanced_drug` (Cost-plan non-Part-D) | b20 (`mc` family, period-keyed maxplan) | `extract_b20_enhanced_drug` |
| `combined_benefits` (Shared Wallet groups) | Section D `pbp_d_combo_*` | `extract_combined_benefits` |
| `vbid_packages` (UF cost-reductions + SSBCI packages; $0 aggregate allowances treated as unpopulated) | b19a / b19b | `extract_vbid` |
| `network.oon_cost_sharing` groups `1a`/`1b`/`2` (inpatient acute/psych per-stay, SNF day intervals — filed on the main Section C row, not the OON file) | Section C (`pbp_c_oon_*_iha/iph/snf`) | `extract_oon_inpatient_group` |
| `drug_coverage` (tiers: retail/preferred/mail/LTC/**OON**/**IRA-insulin**, catastrophic) | mrx / mrx_tier / mrx_p | `extract_drug_coverage` |

---

## 5. Special constructs

### Combined "Shared Wallet" (Section D combo)
`pbp_d_combo_*` defines up to 5 benefit groups that share one allowance (e.g. a Flex card).
Each group → `{name, max_plan_benefit, max_plan_benefit_period, categories[], no_dollar_cap}`.
`max_plan_ben_yn = 2` (no dollar cap) means no **dollar** ceiling — distinct from a trip/visit
count limit, which lives on the individual benefit.

### SSBCI ↔ wallet group linkage (inferred by period)
CMS does not state which SSBCI line-item belongs to which combo group (all roll up under code
`19b3`). `build_plan_detail` links them by **matching periodicity**: a *monthly* SSBCI item
(e.g. Food/Produce) → the monthly wallet group ($115/mo); *yearly* items (Pest Control, Indoor
Air Quality) → the yearly group ($1,300/yr). Surfaced as the group's `includes[]` with the
period shown. This is a derived grouping (period match), not an explicit CMS field.

### Zero-dollar D-SNP member liability (display only)
For `dsnp_zero_dollar = true` plans, Medi-Cal / Extra Help (LIS) covers the member's Medicare
cost-sharing, so member liability ≈ $0 (what the EOC shows). The pipeline keeps the underlying
CMS cost-sharing **unchanged**; `benefit-formatter.js` adds the banner + "You pay: $0" annotation
at render time (search `_zeroDollarWrap`). Data stays faithful to CMS; the $0 is a display layer.

### IRA insulin & OON (drug tiers)
`extract_drug_coverage` adds per-tier `oon_*` (`mrx_tier_oonp_*`) and `insulin_*`
(`mrx_tier_ira_*`) — the capped insulin pricing ($35 cap visible on brand tiers).

---

## 6. Source-vs-EOC discrepancies (by design)

The dashboard is **faithful to the CMS PBP feed**, which sometimes disagrees with a plan's EOC.
These are NOT bugs and are intentionally left as the CMS source states:
- Eye-exam referral: PBP `refer_yn=1` (required) vs EOC "no referral for routine".
- Podiatry prior-auth: PBP `auth_yn=2` (none) vs EOC "PA may apply".
- 75-mile transportation distance: stated in EOC, not filed in the PBP source.
- Eyewear network tiers (e.g. Humana $350 standard / $450 PLUS-provider): the PBP schema has
  no tier column — only the single combined maximum is filed. The tier split is carrier/EOC
  content (carrier pack `eoc_facts`).
- Core medical cost-sharing (e.g. 20% coinsurance) vs EOC $0 — reconciled via the zero-dollar
  display layer, not by altering the data.

Do not hand-edit the data to match the EOC. Classify each discrepancy as **extraction bug**
(fix the pipeline) vs **source-vs-EOC** (leave faithful, document).

---

## 7. Verification tooling

The mapping was audited by instrumenting `safe_get` to record every column access across all
8,081 plans, flagging any column requested that does not exist in its file (silent data loss),
then verifying output population per benefit (each fixed benefit went 0 → thousands of plans).
See `AUDIT_2026.md` for the full findings, severities, and fixes. To re-audit after a CMS data
refresh, re-run that instrumented build and confirm key fields still populate.

---

## 8. File map of this package

```
preprocess.py            # the translation engine (all extractors + maps)
index.html               # dashboard entry (cache-busted asset versions)
js/
  data-loader.js         # fetch + cache plan JSON (no-store)
  benefit-formatter.js   # renders plan JSON → HTML (zero-dollar layer, tables, sections)
  comparison.js          # plan comparison view
  app.js                 # routing / filters / search
css/styles.css
data/                    # GENERATED output (plans_summary.json, geo_index.json, plans/*.json)
AUDIT_2026.md            # column-mapping audit (bugs found + fixed, with evidence)
TRANSLATION_LOGIC.md     # this document
../pbp-benefits-2026/    # raw CMS PBP source (.txt data + .sas record layouts)
```
