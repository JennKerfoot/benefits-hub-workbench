# CMS PBP → Dashboard Mapping Audit (2026 data)

## ROUND 2 — QA fixes, FIXED & VERIFIED (2026-07-02)
Source: plan-level QA of H7617_076_0 (Humana PPO D-SNP) and H5425_123_0 (SCAN) against their
2026 SB/EOC (`benefits-hub-handoff/06-audit/QA_H7617-076_VS_SB_EOC.md`). All 8,081 plans
regenerated, 0 errors; verified against both QA'd plans and by corpus population counts.

### Bugs fixed

| # | Benefit (JSON key) | Symptom | Root cause → Fix | Verified |
|---|---|---|---|---|
| R2-1 | Therapeutic radiology (`therapeutic_radiology`) + new `basic_radiology`, `diagnostic_imaging` | $50 X-ray copay attached to therapeutic radiology (H7617-076 showed `$50 + 20%`; SB says 20% only); 8b3 X-rays had no benefit row; 8b1 CT/MRI cost share dropped entirely | b8b is three suffix-coded sub-services (`_drs`=8b1 diagnostic radiological CT/MRI, `_tmc`=8b2 therapeutic, `_mc`/`_cmc`=8b3 X-rays; ehc bitmask order [X-ray, diagnostic, therapeutic]); the generic fallback chain hit `copay_mc_amt` (8b3) for the copay and `coins_pct_tmc` (8b2) for coinsurance. New dedicated `extract_b8b_radiology()`; keys added to benefit-formatter.js + comparison.js | therapeutic copay 1,538 (true `_tmc` filings; was inflated by 4,198 mis-attached X-ray copays); basic_radiology copay 4,198 / coins 2,478; diagnostic_imaging cost share 6,809; therapeutic coins 5,824 unchanged (no regression) |
| R2-2 | Eye + hearing exam limits (`eye_exams`, `hearing_exams`) | `unlimited: true` on plans whose SB says 1 visit/year (both carriers) | `pbp_b17a_bendesc_lim_rex` / `pbp_b18a_bendesc_lim_rht` ask "Is this benefit unlimited?" (1=Yes, 2=No, indicate number) — the code had it INVERTED (unlike the generic `_bendesc_lim_yn` family). Also added `exam_limit_period` for hearing (`per_rht`) | eye: 5,386 plans now show exam_limit (were all falsely unlimited), 124 truly unlimited; hearing: 5,298 / 74. Both QA plans now `1 / Every year` |
| R2-3 | VBID aggregate allowance (`vbid_packages`) | `aggregate_allowance: "$0 (Every year)"` on Humana Healthy Options (real wallet is $225/mo funded outside b19b) | `agg_yn=1` with `agg_amt=0.00` is an unpopulated placeholder — 823 of 1,604 b19b packages file $0. Zero now treated as absent (field omitted) | 781 packages still emit a real allowance; 823 $0 placeholders omitted |
| R2-4 | b8a mislabeled as radiology (`diagnostic_radiology` → `diagnostic_procedures` + `lab_services`) | The `diagnostic_radiology` benefit was built from **b8a**, which per the dictionary is section 8a Outpatient Diagnostic Procedures/Tests/**Lab** Services (8a1 `_dmc_`, 8a2 `_lab_`) — not radiology; lab cost sharing was also silently dropped | New `extract_b8a_diagnostic()` splits b8a into `diagnostic_procedures` (8a1) and `lab_services` (8a2); the `diagnostic_radiology` key is now sourced from the true radiology columns (8b1 `_drs_`, replacing the interim `diagnostic_imaging` key from R2-1). **Key semantics changed for downstream consumers**: `diagnostic_radiology` was 8a data, now 8b1 | diagnostic_procedures copay 4,164 / coins 2,704 (exactly the old b8a baselines — no data loss); lab_services copay 4,199 / coins 2,229 (new); diagnostic_radiology (8b1) copay 4,361 / coins 2,584; no `diagnostic_imaging` keys remain. H7617-076: labs $0, procedures $0-20%, diagnostic radiology 20%, X-rays $50, therapeutic 20% — all match SB |

### Classified source-vs-EOC (NOT a pipeline bug — no code change)

- **Eyewear standard tier (`eyewear.max_plan_benefit`)**: SB/EOC show $350 standard / $450 PLUS-provider
  for H7617-076, but the PBP filing contains ONLY the $450 combined amount
  (`pbp_b17b_comb_maxplan_amt`); a full-file sweep of every 2026 PBP table found no $350 for this
  plan, and the `indv_maxplan_*` per-type columns are empty. There is no standard-vs-PLUS tier
  column in the PBP schema — the network-tier split is carrier/EOC content and belongs in the
  Humana carrier pack (`eoc_facts`, already scaffolded: "PLUS providers = higher eyewear tier"),
  per the dashboard-faithful-to-CMS rule.

### Coverage gaps added

- **Combined in+OON MOOP** (`costs.max_out_of_pocket_combined`): `pbp_d_comb_max_enr_amt` emitted
  alongside the in-network amount when both filed — 2,745 plans (H7617-076: $9,250 / $13,900).
- **Medicare-defined deductible types** (`costs.annual_deductible_type`): `pbp_d_ann_deduct_amt`
  is only filed for type 4 ("Other", 407 plans); types 1–3 are Medicare-defined with NO amount
  column (type 2 = Part B, 182 plans → display "$257", the 2026 CMS standard; types 1/3 emit the
  type text only). H7617-076 annual_deductible was null, now "$257". Total with deductible: 589.
- **Inpatient/SNF OON cost sharing** (`network.oon_cost_sharing` groups `1a`/`1b`/`2`): these are
  filed as `pbp_c_oon_copay_iha/iph/snf_*` families on the main Section C row, not in the
  per-category OON file (which starts at category 3). Per-stay amounts and day intervals are
  flattened to display strings — 2,535 plans (H7617-076: $2,230/stay acute, $2,080/stay psych,
  SNF $0 days 1-20 / $218 days 21-100).

### Round-2 root-cause patterns (add to list below)
7. **Inverted question polarity** — `lim_rex`/`lim_rht` ask "unlimited?" while `_bendesc_lim_yn` asks "limited?"; check each field's JSON QUESTION in the dictionary before mapping yes/no.
8. **$0-as-placeholder** — CMS files literal 0.00 where the real value lives elsewhere (b19b wallet allowances; cf. the existing b13/OTC combined-allowance note).
9. **Sub-service bitmask (`_ehc`)** — b8b-style sections gate suffix-coded sub-services with a positional bitmask whose order does NOT match the 8b1/8b2/8b3 numbering.

---

## ROUND 1 — STATUS: FIXED & VERIFIED (2026-06-03)
All CRITICAL + HIGH + MED bugs below were fixed in preprocess.py and the data regenerated.
Output-population verified (each was 0 before): cardiac_rehab.copay 3937, skilled_nursing.copay_intervals 4892,
inpatient_acute.copay_intervals 4317, diagnostic_radiology.copay 4164/coins 2704, therapeutic_radiology.coins 5824,
outpatient_hospital.copay 4430/coins 2607/auth 6976, ambulance.copay 4540/coins 2348, medical_supplies.copay 2548/coins 4259,
part_b_drugs.copay 355/coins 6857, dental_medicare.copay 3471/coins 2992, dental_comprehensive.sub_types 3535,
hearing_exams.copay 4732, annual_physical.copay 3283, kidney_disease_education.coins 2543,
additional_preventive.sub_types 5417, other_medicare_preventive.sub_types 5145, eye_exams.max_plan_benefit 932/deductible 7002.
No regressions (specialist, primary_care, dialysis, drug tiers, premium/MOOP all still populate).

Coverage gaps now ALSO extracted (2026-06-03):
- Drug tiers: added OON cost-share (oon 4,521 plans) + IRA insulin cap per tier (insulin 5,222 plans; $35 cap visible).
- VBID / Uniform-Flexibility packages (b19a reductions + b19b supplemental): vbid_packages on 2,564 plans
  (package name, type, aggregate allowance, benefit categories, eligibility).
- VBID rewards/incentives (pbp_vbid/ds_vbid mrx_rai_*/mrx_vbd_*): genuinely EMPTY in 2026 source (0 plans filed),
  and part_d_model_demo / part_d_enhncd_cvrg_demo are all "N" — nothing meaningful to extract.



Method: instrumented every `safe_get` column access during a full build of all 8,081 plans,
flagged columns the code requests that don't exist in their source file (silent data loss),
then 8 parallel section audits cross-checked the extraction code against real CMS column names
and verified each finding against the generated `data/plans/*.json` (population counts).

## Root-cause patterns
1. **Wrong prefix** — code reads `pbp_b3a_*`/`pbp_b15_*`; files use `pbp_b3_*`/`mrx_b_*`.
2. **Generic vs service-specific suffix** — code reads `_copay_amt_mc_min`; 2026 uses `_dmc_`, `_lab_`,
   `_ohs_`, `_obs_`, `_gas_`, `_aas_`, `_rpe_`, `_rht_`, `_fha_`, `_crs_`, etc.
3. **Word-order variants** — `copay_amt_mc_min` vs `copay_mc_amt_min` vs `copay_mc_min_amt` vs `copay_amt_min`.
4. **Interval family** — inpatient/SNF read the `_ad_` (additional-days) family (blank) instead of `_mcs_` (Medicare-covered-stay).
5. **Numbered vs suffix-coded sub-types** — b14c1..22 / b16b1..6 / b16c1..10 don't exist; real cols are suffix-coded (`_oe`, `_pc`, `_rs`, `_hec`…).
6. **Nonexistent gate/summary columns** — SSBCI `suppt_food/meals/pest/trans_yn`, b18c `bendesc_yn`.

---

## CRITICAL — whole benefit or all cost-sharing dropped for all plans

| # | Benefit (JSON key) | Symptom | Wrong → Correct | Fix location |
|---|---|---|---|---|
| 1 | Cardiac rehab (`cardiac_rehab`) | copay/coins 0/7420 | prefix `pbp_b3a`→`pbp_b3`; amounts are `_copay_amt_mc_min_crs/_icrs/_prs/_setpad` | preprocess.py ~1748 (needs dedicated extractor) |
| 2 | SNF (`skilled_nursing`) | copay intervals 0/7420 | interval family `_ad_`→`_mcs_` (`pbp_b2_copay_mcs_amt_int1_t1`) | extract_inpatient ~421-423; call ~1743 |
| 3 | Inpatient acute/psych (`inpatient_acute`/`_psychiatric`) | intervals 1875/73 vs ~4046/4034 | `_ad_`→`_mcs_` family | extract_inpatient ~404-406,421-423; also step1 detour ~1729-1737 |
| 4 | Diagnostic radiology (`diagnostic_radiology`) | copay+coins 0/7420 | `_mc_`→`_dmc_`/`_lab_` (`copay_min_dmc_amt`, `coins_pct_dmc`) | b8a call ~1806 (dedicated branch) |
| 5 | Therapeutic radiology (`therapeutic_radiology`) | coins 0/7420 (copay ok) | coins `_mc_`→`_tmc_` (`coins_pct_tmc`) | b8b call ~1807 |
| 6 | Outpatient hospital (`outpatient_hospital`) | copay/coins/auth/refer 0/7420 | `_ohs_`/`_obs_`; `auth_ohs_yn`/`refer_ohs_yn` | b9a call ~1812 (dedicated branch) |
| 7 | Ambulance (`ambulance`) | copay/coins 0/7420 | `_mc_`→`_gas_`/`_aas_` (`copay_gas_amt_min`, `coins_gas_pct_min`) | b10a call ~1826 |
| 8 | Medical supplies (`medical_supplies`) | copay+coins 0 | `_mc_`→`_mcmin_amt`/`_coins_pct_mcmin` | extract_simple_benefit chains 330-337 |
| 9 | Acupuncture suppl. (`acupuncture_supplemental`) | copay+coins 0 | add `_copay_amt_min`/`_coins_pct_min` | extract_supplemental_benefit 603-610 |
| 10 | SSBCI copay (all 9 subs) | copay 0/2115 (values are $0) | `_copay_amt_mc_min`→`_copay_amt_min` | extract_supplemental_benefit 603-604 |
| 11 | SSBCI summary flags (food/meals/pest/trans `_benefit`) | 0/2115 | `suppt_*_yn` don't exist; derive from each sub `_bendesc_yn` | extract_b13i_ssbci 1096-1099 |
| 12 | Part B drugs (`part_b_drugs`) | whole benefit 0/7420 | prefix `pbp_b15_*`→`mrx_b_*` (different suffixes too) | call ~1879 (dedicated extractor) |
| 13 | Additional preventive sub-types (`additional_preventive.sub_types`) | 0/5450 | b14c1..22 don't exist; suffix-coded `pbp_b14c_copay_<suf>_min_amt` | loop ~1164-1204 (rewrite) |
| 14 | Annual physical (`annual_physical`) | copay/coins 0/5109 | `_mc_`→`_rpe_` (`copay_amt_rpe_min`) | extract_supplemental_benefit chains |
| 15 | Kidney disease ed (`kidney_disease_education`) | copay-min + coins dropped; max-only shown | `_copay_mc_min_amt`, `_coins_mc_min_pct/_max_pct` | extract_simple_benefit 330,336-337 |
| 16 | Other Medicare preventive (`other_medicare_preventive`) | copay/coins/ded/auth 0/7002 | per-service `_glauc/_diab/_dre/_ekg` suffixes | b14e call ~1213 (dedicated extractor) |
| 17 | Medicare-covered dental (`dental_medicare`) | copay/coins 0 | `copay_amt_mc`→`copay_mc_amt`; `coins_pct_mc`→`coins_mc_pct` | extract_dental_detail 658-663 |
| 18 | Preventive dental (`dental_preventive`) | sub_types + copay 0 | b16b1..6 don't exist; suffix `_oe/_pc/_ft/_dx/...`; remove misplaced copay | extract_dental_detail 676-698 |
| 19 | Comprehensive dental (`dental_comprehensive`) | copay/coins/sub_types 0 | b16c1..10 don't exist; suffix `_rs/_end/_peri/...` | extract_dental_detail 708-732 |
| 20 | Hearing exams (`hearing_exams`) | copay/coins/fitting 0 | `_mc_`/`_rht_min`→`copay_amt_rht`+`copay_amt_max_rht`; `_fe_`→`_fha` | extract_hearing_detail 830-835,857-862 |

## HIGH

| # | Benefit | Symptom | Fix |
|---|---|---|---|
| 21 | OTC hearing aids (`hearing_otc`) | whole block omitted (gate `b18c_bendesc_yn` doesn't exist) | gate on data presence; copay `_copay_amt_min` | extract_hearing 908,913-918 |
| 22 | Eye exam (`eye_exams`) | max_plan/deductible/exam-limit dropped | `maxplan_re_*`→`maxplan_*`; `ded_re_yn`→`ded_yn`; `bendesc_lim_yn/numv/per`→`_lim_rex/_num_rex/_per_rex` | extract_vision 760-783 |
| 23 | Hearing aids per-ear max (`hearing_aids.max_plan_benefit_per_ear`) | 0 (2081 have data) | `maxplan_ear_amt`→`maxplan_perear` | extract_hearing 873 |
| 24 | Prosthetics (`prosthetics`) | copay dropped; coins max dropped | add `_copay_mcmin_amt`/`_mcmax_amt`/`_coins_pct_mcmax` | extract_simple_benefit 330-337 |

## MED / LOW (mostly latent — wrong names but 2026 data is $0/blank, or tiny plan counts)

- DME (`dme`) copay-max + coins-max truncated to min — `_copay_mcmax_amt`/`_coins_pct_mcmax` (b11a).
- Other services 1/2/3 (`other_services_1/2/3`) copay — `_copay_min_amt`→`_copay_amt_min` (b13d/e/f).
- Meals (`meals`) copay name — latent, $0 now (b13c).
- Eyewear upgrades (`eyewear.upgrades_copay`) — `_up_`→`_upg_` (b17b).
- Hearing aids coinsurance + aid_types — `coins_at_min_pct`→`coins_pct_at_min`; aid_types from per-type subblocks (b18b).
- SSBCI coinsurance names + transportation benefit_type — latent (0 data in 2026).
- b20 enhanced drug (15 plans): `cstshr_attest`→`cost_share_attest`; `coins_pct`→`coins_mc_pct`; group `coins_drp_pct`→`coins_pct_drp`; group maxplan period-keyed.

## Coverage gaps (loaded but never extracted — not mapping bugs)
- VBID (`pbp_vbid.txt`, `pbp_ds_vbid.txt`, `mrx_vbid`, all `*_vbid_*`) — read into memory, never consumed.
- Drug tier OON cost-share (`mrx_tier_oonp_*`) and IRA insulin tier copays (`mrx_tier_ira_*`) — populated in source, not extracted.

## VERIFIED CORRECT (no changes needed)
- Home health (b6), all health professionals (b7a-k incl. primary care, specialist, podiatry, chiropractic, OT, PT/ST, telehealth, mental health) — fallback chains hit the right columns.
- Renal dialysis (b12), ambulatory surgery (b9b), outpatient rehab (b9d).
- Part D drug tiers + catastrophic phase + mrx top-level (deductible $375, 5 tiers) — incl. the earlier `rspfd_coins` fix.
- Premium / MOOP / deductible (Section D), plan identity (Section A).
- Partial hospitalization / IOP (b5a/b5b) — single-value (max side blank in source).
