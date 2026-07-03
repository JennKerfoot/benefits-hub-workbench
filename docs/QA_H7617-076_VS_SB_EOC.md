# Plan QA: Humana H7617-076 (PPO D-SNP) — pipeline JSON vs 2026 SB + EOC

## ✅ RE-RUN 2026-07-02 (post-fix): ALL CLEAR — 31/31 checks pass

Pipeline fixes applied in `preprocess.py` (AUDIT_2026.md Round 2), all 8,081 plans regenerated,
and this comparison re-run against the regenerated `H7617_076_0.json` (SB/EOC expected values
as captured below). Results:

- **All 4 pipeline bugs fixed and verified:** therapeutic radiology is coinsurance-only (20%, no
  copay); `basic_radiology` row now exists with the $50 X-ray copay; eye + hearing exams show
  `1 / Every year` (not unlimited) on BOTH H7617-076 and SCAN H5425-123; the Healthy Options
  package no longer emits the "$0 (Every year)" aggregate allowance.
- **Bug 3 reclassified (not a pipeline bug):** a full sweep of every 2026 PBP file confirmed the
  $350 standard eyewear tier is not filed anywhere — the PBP schema has no network-tier column
  and carries only the $450 combined maximum. Source-vs-EOC by design; the $350/$450 PLUS split
  renders from the Humana carrier pack (`carriers/humana/vision.json`).
- **All 3 JSON gaps closed:** combined in+OON MOOP $13,900; Part B deductible $257 (derived from
  the Medicare-defined deductible type — CMS files no dollar amount for types 1–3); OON inpatient
  copays $2,230/stay acute + $2,080/stay psych + SNF $0 days 1–20 / $218 days 21–100.
- **No regressions:** all 18 MATCH facts re-verified (premium $0, in-network MOOP $9,250, Part D
  deductible $615 Tiers 3–5, T1/T2 $0, T3–5 25%, insulin $35/30-day, catastrophic $0, vaccines,
  dental $2,500 combined with $0 sub-services, SNF intervals, transportation 36 one-way trips/yr,
  OTC $2,700/yr wallet, fitness $0, dsnp_zero_dollar, plan identity, ER $115 waived-if-admitted).

**Launch verdict: TRUSTWORTHY — cleared for member-facing use** (remaining frequency-type EOC
facts — hearing aid 1/ear/3 years, 14 meals × 4/yr, 75-mile trip cap, OTC monthly card
mechanics — stay pending product approval as carrier-pack `eoc_facts`, unchanged).

---

## Original QA (pre-fix) — retained below for the record

**Date:** 2026-07-02
**Sources:** `data/plans/H7617_076_0.json` (pipeline output) · `Humana-H7617076000SB26pdf-2026-SF20251001.pdf` (Summary of Benefits, 32 pp) · `Humana-H7617076000EOC26pdf-2026-SF20251003.pdf` (EOC, 204 pp)
**Plan facts:** HumanaChoice SNP-DE H7617-076, Local PPO, D-SNP (FBDE/QMB+/SLMB+), `dsnp_zero_dollar: true`, $0 premium, $9,250 in-network MOOP, 56 benefit keys.

**D-SNP note:** the SB/EOC show in-network `$0` and out-of-network `"$0 or <filed amount>"` for dual-eligibles. Filed JSON values matching the "or" amounts are EXPECTED, not mismatches — this is the display-overlay case the architecture already handles via `dsnp_zero_dollar`.

## Verdict tally

| Verdict | Count |
|---|---|
| MATCH (JSON = SB/EOC) | 18 |
| EXPECTED D-SNP difference (filed value; member pays $0 via overlay) | 5 |
| **CONFLICT — real pipeline bugs** | **4** |
| JSON gaps (in SB, absent from JSON) | several — see below |

## The 4 pipeline bugs (fix in `preprocess.py` before this plan is member-facing)

1. **Therapeutic radiology mis-mapped.** JSON shows `$50 copay + 20%` on therapeutic radiology; per SB and EOC the $50 belongs to **basic X-rays at a freestanding radiological facility** (PBP section 8b3), and radiation therapy is 20% only. The JSON also has no basic-radiology benefit row at all — the $50 landed on the wrong benefit.
2. **False `unlimited: true` on vision and hearing exams.** SB/EOC: both are **1 visit per year**. ⚠️ The SAME false-unlimited pattern appeared on SCAN H5425-123 (SB: 1 per 12 months) — two carriers, same error → this is an extractor bug (the `unlimited` flag is being read from the wrong column or defaulting wrong), not a filing quirk. Treat every `unlimited: true` in the corpus as suspect until fixed.
3. **Eyewear allowance one-sided.** JSON carries only `$450`; the SB/EOC say **$350 standard, $450 only at PLUS providers**. (Same two-tier pattern existed on the original hand-built Humana screen — $150/$250 — so the extractor is dropping the standard-tier column.)
4. **VBID `aggregate_allowance: "$0 (Every year)"`** on the Healthy Options package — real value is the $225/month ($2,700/yr) shared wallet. Zero-dollar allowance strings on VBID packages should be treated as unpopulated, not rendered.

## JSON gaps (SB has it, JSON doesn't — extractor enhancements)

- Combined in+out-of-network MOOP for PPOs ($13,900 here; only in-network $9,250 present).
- The "$0 or $257" Part B deductible (JSON `annual_deductible: null`).
- Inpatient OON copays ($2,230 acute / $2,080 psych) — OON cost-share array starts at category 3; categories 1a/1b/2 missing.
- Benefit frequencies: hearing aid 1/ear/3 years, dental service schedules, meals 14 meals × 4/yr, transportation 75-mile/trip cap. (Some may not exist in PBP at all → legitimately carrier-pack `eoc_facts`.)
- OTC monthly-deposit + rollover mechanics (JSON's "$2,700 Every year" annualizes correctly but hides the $225/month card mechanics).
- JSON extended-supply fields labeled `90day` while this plan's actual extended supply is 100-day (values match).

## Verified clean (highlights)

Premium $0, in-network MOOP $9,250, Part D deductible $615 (Tiers 3–5), all drug tiers (T1/T2 $0, T3–5 25%), insulin $35/30-day cap, catastrophic $0 after $2,100, vaccines $0, dental $2,500 combined max with $0 sub-services, SNF $0/1–20 + $218/21–100, transportation 36 one-way trips/yr, OTC $2,700 annual total, fitness $0, D-SNP zero-dollar flag correct, plan identity exact.

## Carrier-pack content harvested (now scaffolded in `carriers/humana/`)

TruHearing (Advanced aids, 844-255-7144, no OON) · SilverSneakers · CenterWell Pharmacy (preferred mail) · Humana Well Dine (meals) · Humana Healthy Options Allowance via Humana Spending Account Card (balance at MyHumana.com) · Go365 rewards · Humana Dental Medicare Network · Humana Medicare Insight Network (PLUS providers = higher eyewear tier) · Transportation booked via Customer Care, 72-hr advance. Registry updated: `H7617 → humana`. Frequency-type facts (1 aid/ear/3yr, 14 meals × 4/yr, 75-mi cap) are drafted as notes pending product approval as `eoc_facts` with citations.

## Launch verdict for this plan

**Trustworthy after 4 fixes.** Core financials fully reconcile; the D-SNP overlay behaves as designed. Blockers are the four extractor bugs above (especially the cross-plan `unlimited` bug and the eyewear standard-tier drop) plus adding combined MOOP + Part B deductible. Fix in `preprocess.py`, regenerate, re-run this comparison — the compiler's per-plan report automates exactly this check going forward.
