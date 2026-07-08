# PBP Field Gap Map — quantity / frequency / allowance fields we drop

**Date:** 2026-07-07
**Question:** Which member-facing benefit facts live in the raw CMS PBP data but are dropped by `preprocess.py`?
**Method:** raw-field inventory (population counts from the 7,420-row section files in `pbp-benefits-2026/`) + data dictionary (field semantics + code maps) + `preprocess.py` cross-reference (what is/isn't read) + CMS PBP User Guide CY2026 (the "Benefit Unlimited Component" model). Populations below are from the main section files; extract-status verified by grepping the canonical `dashboard/preprocess.py`.

---

## The one root cause

Almost every supplemental benefit in HPMS carries a **"Benefit Unlimited Component"**:

| Field | Meaning | Code map |
|---|---|---|
| `*_bendesc_lim*` | unlimited? | 1 = Unlimited, 2 = Limited (→ read the number) |
| `*_bendesc_numv*` / `*_num*` | number of visits / units | integer |
| `*_bendesc_per*` | periodicity | 1=every 3 yrs, 2=every 2 yrs, 3=every yr, 4=every 6 mo, 5=every 3 mo, 6=other, 7=every month, 8=every benefit period, 9=every stay |
| `*_bendesc_per_*_d` | periodicity free-text | 4000-char description |
| `*_maxplan_amt` / `_per` | dollar allowance + period | — |

`preprocess.py` reliably extracts **cost-sharing** (copay/coins/deductible) and often the **dollar allowance**, but **three extractors never read the number + periodicity** for many benefits:

1. **`extract_hearing_detail()`** — hearing aids (18b): reads copay/coins/ded/aid_types/`maxplan_amt`/`maxplan_perear`, **skips `bendesc_numv_at` / `per_at`**.
2. **`extract_supplemental_benefit()`** — handles the *plain* `_bendesc_numv` (acupuncture works ✅) but **not the suffixed per-service/per-item variants** (dental `_oe_num`, eyewear `_numv_egs`, OTC-aid `_num`).
3. **`extract_simple_benefit()`** — used for cardiac rehab (b3), chiropractic (b7b), podiatry (b7f): **cost-sharing only**, never reads `lim`/`num`/`per`.

Plus two one-off drops: **OTC delivery mode** (`b13b_mode`) and **14c per-benefit periodicity/allowances** (only Fitness reads them).

---

## Confirmed DROPPED — prioritized reclaim list

Populations = plans (of ~7,420) with the field populated. All rows below are `0 refs` in `preprocess.py` (verified) unless noted.

### Tier 1 — high volume, high member value

| # | Benefit | Fields dropped | Plans | Member fact we could show |
|---|---|---|---|---|
| 1 | **Hearing aids** (18b) | `b18b_bendesc_numv_at`, `per_at` | **4,792** | "Up to 2 hearing aids every 3 years" (allowance + per-ear already shown) |
| 2 | **Dental preventive** (16b) | `b16b_bendesc_{oe,dx,pc,ods,ft,ops}_num` + `_per` | **~4,475** | "1 exam/yr · 2 cleanings/yr · x-rays 1/yr" |
| 3 | **Podiatry routine foot care** (7f) | `b7f_bendesc_lim_rf`, `per_rf` | **2,571** | "Routine foot care: N visits/yr" |
| 4 | **Hearing-aid fitting** (18a) | `b18a_bendesc_numv_fha`, `per_fha` | **2,398** | "1 fitting/evaluation per year" (routine exam freq already shown) |
| 5 | **OTC delivery mode** (13b) | `b13b_mode`, `_mode_desc` | **~2,403** | "Loaded to your OTC card" / "mail order" (allowance already shown) |

### Tier 2 — meaningful volume

| # | Benefit | Fields dropped | Plans | Note |
|---|---|---|---|---|
| 6 | **Eyeglasses** (17b) | `b17b_bendesc_numv_egs`, `per_egs` | **1,810** | quantity/cadence (combined $ allowance already shown) |
| 7 | **Contact lenses** (17b) | `b17b_bendesc_numv_cl`, `per_cl` | **1,420** | quantity/cadence |
| 8 | **OTC hearing aids** (18c) | `b18c_bendesc_num`, `per`, `maxplan_amt` | **1,157 / 237** | count + freq + allowance all dropped |
| 9 | **Chiropractic routine care** (7b) | `b7b_bendesc_num_rc`, `per_rc` | **1,071** | "N routine visits/yr" |

### Tier 3 — 14c supplemental (21 of 22 benefits lumped into "additional_preventive")

Only **Fitness (14c4)** gets its own card + periodicity today. The rest drop number/periodicity and most allowances.

| Benefit | Field dropped | Plans |
|---|---|---|
| **Wig** allowance | `b14c_maxplan_amt_wig` | **749** |
| **Assistive tech / alt-therapy** limit | `b14c_bendesc_lim_at` | **908** |
| **Nutrition** limit | `b14c_bendesc_lim_ntb` | **865** |
| **Bathroom-safety devices** allowance | `b14c_maxplan_amt_bsd` | **217** |
| **Counseling** limit | `b14c_bendesc_lim_cs` | **112** |
| Weight-mgmt / structured-exercise / in-home-support allowances + **all non-Fitness `maxplan_per`** | `b14c_maxplan_amt_{wm,sce,prs,ihss}`, `maxplan_per_*` | 7–44 each |

### Tier 4 — real routing gaps, low volume (nice-to-have)

| Benefit | Field dropped | Plans | Note |
|---|---|---|---|
| **Cardiac/Pulmonary/SET rehab** (3) | `b3_bendesc_numv_{crs,icrs,prs,setpad}`, `per_*` | ~17–23 | routed through `extract_simple_benefit`; true gap but tiny population |
| **Inpatient additional days** (1a) | `b1a_bendesc_lim_ad` | 4,537 | medical coverage limit; low member-facing priority; confirm extract status |

---

## Already extracted — NOT gaps (don't redo)

- Routine **eye exam** frequency `b17a_bendesc_num_rex`/`per_rex` — 5,386 ✅
- Routine **hearing exam** frequency `b18a_bendesc_numv_cl`/`per_rht` — 5,298 ✅
- **Eyewear** combined allowance `b17b_comb_maxplan_amt`/`per` — 5,217 ✅
- **Eye exam** allowance `b17a_maxplan_amt` — 932 ✅
- **Hearing aid** allowance + per-ear `b18b_maxplan_amt`/`maxplan_perear` — 2,054 / 2,081 ✅
- **Transportation** trips/type/mode/periodicity (10b) — 1,655 ✅
- **Acupuncture** visit-limit + allowance (13a) — 1,554 ✅
- **OTC** allowance + period (13b) — 2,403 ✅ (delivery mode is the drop, see #5)
- **Meals** allowance + `meal_types` (in code; needs a regen) + **`prior_auth`** (added 2026-07-07)

---

## Confirmed NOT in the PBP (genuinely EOC-only)

- **Meals** "14 meals × 4/year" — no meal-count field exists anywhere (b13c $-max + period only; SSBCI home-delivered meals `b13i_ml` offered by 287 plans but 0 file counts).
- **Transportation** "75-mile per trip" + "72-hour advance booking" — no mileage or advance-notice column exists.
- **SNF additional days / Home Health / OT / PT-SLP / DME quantity** — no `bendesc_numv`; filed as day-interval cost-sharing (SNF), MOOP caps (home health, DME), or managed via prior-auth. Not reclaimable as a visit count.

---

## Recommended reclaim approach

Treat as a planned effort (spec → plan → subagent execution), one full corpus regen (8,081) + 3-copy sync + tests at the end — same shape as the shared-allowance work.

1. **Generalize the "Benefit Unlimited Component" read** into a shared helper (`lim`/`numv`/`per` + `per_d` → `visit_limit` / `visit_limit_period`, mapped via `PERIODICITY_MAP`) and wire it into `extract_hearing_detail` (18b), the dental (16b) / eyewear (17b) / OTC-aid (18c) paths, and re-route cardiac rehab (b3) / chiropractic (b7b) / podiatry (b7f) off `extract_simple_benefit`.
2. **One-offs:** OTC delivery mode (`b13b_mode`), the 14c non-Fitness allowances + periodicity, OTC-hearing-aid allowance.
3. **Content/render:** show visit-limit / frequency on each benefit card (the workbench compiler already renders `visit_limit` for acupuncture — reuse the pattern).
4. Tier 1 alone reclaims member-facing frequency for **~4,000–4,800 plans per benefit** across hearing aids, dental, podiatry.

**Prioritize Tier 1 + 2; Tier 3 (14c) is a follow-on; Tier 4 is optional.**
