ERRATUM (2026-07-02 fidelity audit) — corrections vs generated 2026 data:
- eye_exams / hearing_exams: `exam_limit` and `exam_limit_period` NEVER occur in the
  generated files (0 of 8,081). The real field is `unlimited` (boolean).
- Mental health benefits do NOT use the generic `copay` field. Real fields:
  `copay_individual`, `copay_group`, `coinsurance_individual`, `coinsurance_group`.
- `visit_limit` / `visit_limit_period` never occur anywhere in the corpus.
- worldwide_emergency uses `copay_emergency` / `copay_urgent` (+ coinsurance variants), not `copay`.
- otc_items has no `copay`; meals has no `max_plan_benefit_period` / `prior_auth_required`.
- social_supports is a DICT keyed by benefit name (food_produce, transportation, ...)
  plus boolean summary flags — there is no `items` array in the data; the compiler
  derives one (see COMPILER_SPEC §4).
- Drug tiers: many plans (incl. SCAN H5425_123_0) file ONLY `preferred_retail_copay_*`
  (no `retail_copay_*`); templates must fall back accordingly.

================================================================================
CMS PBP TRANSLATION PACKAGE 2026 — JSON OUTPUT REFERENCE
Member-Facing Benefits UI Data Contract
================================================================================

Generated: 2026-06-03 | Source: preprocess.py build_plan_detail() function
Data path: /dashboard/data/plans/{plan_id}.json (one per plan)

================================================================================
1. OUTPUT FILES & LOCATIONS
================================================================================

Per-Plan Detail Files:
  Location: /dashboard/data/plans/{plan_id}.json
  Naming:   H{contract}_{plan_id}_{segment}.json
            e.g., H0028_007_0.json, E3014_801_0.json
  Quantity: ~8,081 files (one per Medicare Advantage plan in 2026)

Summary/Index Files:
  /dashboard/data/plans_summary.json   — Headline plan metadata (loaded on startup)
  /dashboard/data/states.json          — State/county hierarchy for filtering
  /dashboard/data/geo_index.json       — Geographic lookup: {state: {county: [plan_ids]}}

File Format: Compact JSON (minified, separators=(",", ":"))

================================================================================
2. TOP-LEVEL STRUCTURE (Per-Plan JSON)
================================================================================

Root object has 6 keys:
{
  "plan_id": "H0028_007_0",
  "plan_info": { ... },           — Identity, network, SNP type, contacts
  "costs": { ... },               — Premium, MOOP, deductible, Part B
  "network": { ... },             — Network rules, OON, POS, visitor benefits
  "benefits": { ... },            — 40-60 benefit objects (keyed by type)
  "drug_coverage": { ... }        — Part D tiers + catastrophic phase
}

================================================================================
3. PLAN METADATA (plan_info)
================================================================================

Keys present in all plans:
  plan_name (string)              — Full legal plan name
  org_name (string)               — Organization legal name
  org_marketing_name (string)     — Marketing name (may differ from org_name)
  plan_type (string)              — "HMO", "Local PPO", "PACE", etc.
  plan_type_code (string)         — CMS code: "01"/"02"/"04"/"05"/"20" etc.
  is_snp (boolean)                — true if Special Needs Plan
  snp_type (string or null)       — "I-SNP", "D-SNP", "C-SNP", or ""
  snp_chronic_conditions (string) — Comma-separated chronic condition list (C-SNP only)
  dsnp_zero_dollar (boolean)      — true if D-SNP with Medi-Cal/LIS coverage
  eghp (boolean)                  — Employer Group Health Plan flag
  org_website (string or null)    — URL to plan website
  pharmacy_website (string)       — URL to formulary/pharmacy network
  formulary_website (string)      — URL to drug formulary detail
  member_phone (string or null)   — Member services phone
  prospective_phone (string)      — Pre-enrollment prospective member phone

Note: Null fields are omitted from JSON (clean_dict removes None values).

================================================================================
4. COSTS SECTION
================================================================================

{
  "monthly_premium": "$0" | "$45.50",   — Member premium (formatted with $)
  "part_b_premium": "$20.00" | null,    — Part B reduction premium (if any)
  "annual_deductible": "$0" | "$500",   — Medical deductible
  "max_out_of_pocket": "$5000" | null,  — Annual MOOP
  "part_b_reduction": "$10" | null,     — Monthly Part B reduction (if any)
}

Special case: dsnp_zero_dollar = true plans have copays/coinsurance in the data
but render with a display-layer "$0 member liability" banner (done in benefit-formatter.js).

================================================================================
5. NETWORK SECTION (optional, present if plan has OON/POS)
================================================================================

{
  "has_oon_coverage": true|false,
  "oon_benefit_categories": "Emergency, Urgent Care, Dialysis",
  "visitor_traveler_benefit": true|false,
  "visitor_traveler_months": "3" | "6" | "12",
  "oon_cost_sharing": [
    {
      "label": "Specialist",
      "copay": "$0 - $50",
      "coinsurance": "10% - 20%",
      "max_plan_benefit": "$2500",
      "deductible_applies": true,
      "deductible_amount": "$100"
    }, ...
  ],
  "pos_cost_sharing": [
    {
      "label": "Primary Care (POS)",
      "copay": "$15",
      "coinsurance": null,
      "deductible_applies": false
    }, ...
  ]
}

================================================================================
6. BENEFITS SECTION — Complete Benefit Key List
================================================================================

The "benefits" object can have up to 55 keys. ALL are optional (present only if
that benefit is covered by the plan). Each benefit is a sub-object with cost-sharing
and coverage flags.

Core Medical Benefits:
  inpatient_acute, inpatient_psychiatric, skilled_nursing,
  cardiac_rehab, emergency_care, urgent_care, worldwide_emergency,
  partial_hospitalization, intensive_outpatient, home_health

Physician Services (b7a-k):
  primary_care, specialist, chiropractic, occupational_therapy, podiatry,
  other_health_care, other_practitioner

Mental Health:
  mental_health_outpatient, mental_health_specialist, outpatient_psychiatric

Diagnostic & Imaging:
  diagnostic_radiology, therapeutic_radiology

Outpatient Services:
  outpatient_hospital, ambulatory_surgery, outpatient_rehabilitation

Medications & Supplies:
  part_b_drugs, dme, prosthetics, medical_supplies,
  renal_dialysis

Ambulance & Transportation:
  ambulance, transportation

Preventive & Supplemental:
  telehealth, physical_speech_therapy, preventive_attestation,
  annual_physical, kidney_disease_education, additional_preventive

Dental (3-part structure):
  dental_medicare, dental_preventive, dental_comprehensive

Vision & Hearing:
  eye_exams, eyewear, hearing_exams, hearing_aids, otc_hearing_aids

OTC & Wellness:
  otc_items, acupuncture_supplemental, meals, outpatient_blood, other_services

SSBCI & Combined Wallets:
  social_supports, combined_benefits, vbid_packages

================================================================================
7. SIMPLE BENEFIT OBJECT — COMMON PATTERN
================================================================================

Most benefits follow this structure (copay/coinsurance/deductible/auth):

{
  "label": "Primary Care",
  "copay": "$20" | "$10 - $20" | null,
  "coinsurance": "10%" | "10% - 20%" | null,
  "deductible_applies": true|false,
  "deductible_amount": "$100" | null,
  "prior_auth_required": true|false,
  "referral_required": true|false,
  "max_enrollee_cost": "$500" | null,
  "max_plan_benefit": "$2000" | null
}

Field Semantics:

  copay (string or null)
    — Formatted as "$15" (single) or "$10 - $50" (range).
    — null if no copay. Safe to show as "Free" if explicitly "$0".
    — Ranges indicate plan varies by service subcategory.

  coinsurance (string or null)
    — Formatted as "20%" (single) or "10% - 30%" (range).
    — null if no coinsurance (not the same as $0).

  deductible_applies (boolean or null)
    — true: deductible applies to this benefit; use annual_deductible from costs.
    — false: deductible does NOT apply (deductible_amount should be absent).
    — null: not specified (rare; treat as unknown).

  deductible_amount (string or null)
    — Benefit-specific deductible (separate from annual medical deductible).
    — Only present if this benefit has its own deductible.

  prior_auth_required (true|false|"Yes"|"No")
    — true or "Yes": prior authorization required before service.
    — false or "No": no prior auth required.
    — If absent: unknown; do not assume "no".

  referral_required (true|false|"Yes"|"No")
    — Same semantics as prior_auth_required.

  max_enrollee_cost (string or null)
    — Member's out-of-pocket cap for this specific benefit.
    — Separate from plan-wide MOOP.

  max_plan_benefit (string or null)
    — Plan's maximum payment for this benefit.
    — Usually per year; check max_plan_benefit_period if present.

================================================================================
8. DENTAL — COMPREHENSIVE STRUCTURE
================================================================================

Dental is split into 3 tiers, each with cost-sharing and sub-types:

{
  "dental_medicare": {
    "label": "Medicare-Covered Dental",
    "copay": "$0 - $50",
    "coinsurance": "10%",
    "max_enrollee_cost": "$200"
  },

  "dental_preventive": {
    "label": "Preventive Dental",
    "max_plan_benefit": "$1000",
    "sub_types": [
      { "label": "Oral Exams", "copay": "$0", "coinsurance": null },
      { "label": "Prophylaxis/Cleanings", "copay": "$0", "coinsurance": null },
      { "label": "Dental X-Rays", "copay": "$0", "coinsurance": null },
      { "label": "Fluoride Treatment", "copay": "$0", "coinsurance": null },
      { "label": "Other Preventive Services", "copay": "$0", "coinsurance": null }
    ]
  },

  "dental_comprehensive": {
    "label": "Comprehensive Dental",
    "max_plan_benefit": "$2000",
    "deductible_applies": false,
    "deductible_amount": "$50",
    "sub_types": [
      { "label": "Restorative", "copay": "$50", "coinsurance": "50%" },
      { "label": "Endodontics", "copay": "$50", "coinsurance": "50%" },
      { "label": "Periodontics", "copay": "$50", "coinsurance": "50%" },
      { "label": "Prosthodontics (Removable)", "copay": null, "coinsurance": "50%" },
      { "label": "Prosthodontics (Fixed)", "copay": null, "coinsurance": "50%" },
      { "label": "Implants", "copay": "$75", "coinsurance": null },
      { "label": "Orthodontics", "copay": null, "coinsurance": "50%" },
      { "label": "Oral/Maxillofacial Surgery", "copay": "$75", "coinsurance": null },
      { "label": "Anesthesia/General Services", "copay": "$50", "coinsurance": null },
      { "label": "Other Comprehensive", "copay": null, "coinsurance": "50%" }
    ]
  }
}

The sub_types array contains all available procedures under each tier.
Each sub_type has "label" + optional "copay"/"coinsurance" fields.

================================================================================
9. VISION — COMPREHENSIVE STRUCTURE
================================================================================

{
  "eye_exams": {
    "label": "Routine Eye Exams",
    "copay": "$25",
    "coinsurance": null,
    "max_plan_benefit": "$100",
    "max_enrollee_cost": "$50",
    "deductible_applies": false,
    "prior_auth_required": false,
    "referral_required": false,
    "unlimited": false,
    "exam_limit": "1",
    "exam_limit_period": "Every year"
  },

  "eyewear": {
    "label": "Eyewear (Glasses/Contacts)",
    "max_plan_benefit": "$300",
    "contacts_copay": "$50",
    "contacts_coinsurance": null,
    "glasses_copay": "$0",
    "glasses_coinsurance": null,
    "upgrades_copay": "$25",
    "max_enrollee_cost": "$150",
    "deductible_applies": false
  }
}

Note: exam_limit_period uses PERIODICITY_MAP values: "Every year", "Every 2 years", etc.

================================================================================
10. HEARING — COMPREHENSIVE STRUCTURE
================================================================================

{
  "hearing_exams": {
    "label": "Hearing Exams",
    "copay": "$25",
    "coinsurance": null,
    "max_plan_benefit": "$100",
    "max_enrollee_cost": "$50",
    "deductible_applies": false,
    "prior_auth_required": false,
    "fitting_copay": "$50",
    "unlimited": false,
    "exam_limit": "2",
    "exam_limit_period": "Every year"
  },

  "hearing_aids": {
    "label": "Hearing Aids",
    "max_plan_benefit": "$2000",
    "max_plan_benefit_per_ear": "$1000",
    "copay": "$100",
    "coinsurance": null,
    "max_enrollee_cost": "$500",
    "deductible_applies": false,
    "prior_auth_required": false,
    "aid_types": "All Types, Behind-the-ear"
  },

  "otc_hearing_aids": {
    "label": "OTC Hearing Aids",
    "max_plan_benefit": "$500",
    "copay": "$0",
    "coinsurance": null,
    "max_enrollee_cost": "$250"
  }
}

aid_types lists covered options: "All Types", "In-the-ear", "Behind-the-ear", "Other".
max_plan_benefit_per_ear (hearing_aids only) = per-ear limit (not per-pair total).

================================================================================
11. SOCIAL SUPPORTS (SSBCI) — 9-ITEM STRUCTURE
================================================================================

{
  "social_supports": {
    "label": "Social Support Services (SSBCI)",
    
    /* Individual SSBCI line-items (each optional): */
    "food_produce": {
      "label": "Food & Produce",
      "benefit_type": "Mandatory",
      "max_plan_benefit": "$80",
      "max_plan_benefit_period": "Every month",
      "max_enrollee_cost": null,
      "copay": null,
      "coinsurance": null,
      "deductible_applies": false,
      "prior_auth_required": false,
      "referral_required": false,
      "visit_limit": null,
      "unlimited": null
    },
    
    "meals": {
      "label": "Meals",
      "benefit_type": "Mandatory",
      "max_plan_benefit": "$50",
      "max_plan_benefit_period": "Every month",
      ...
    },
    
    "pest_control": {
      "label": "Pest Control",
      "benefit_type": "Mandatory",
      "max_plan_benefit": "$500",
      "max_plan_benefit_period": "Every year",
      ...
    },
    
    "transportation": {
      "label": "Transportation",
      "max_plan_benefit": "$100",
      "max_plan_benefit_period": "Every month",
      "transport_location": "Any Location",
      "unlimited": true,
      "trip_type": "One-way",
      "transport_modes": "Taxi, Rideshare Services, Bus/Subway, Van, Medical Transport",
      ...
    },
    
    "indoor_air_quality": {
      "label": "Indoor Air Quality",
      "benefit_type": "Mandatory",
      "max_plan_benefit": "$200",
      "max_plan_benefit_period": "Every year",
      ...
    },
    
    "social_needs": {
      "label": "Social Needs",
      "benefit_type": "Optional",
      "max_plan_benefit": "$150",
      "max_plan_benefit_period": "Every month",
      ...
    },
    
    "complementary_therapies": {
      "label": "Complementary Therapies",
      "max_plan_benefit": "$300",
      ...
    },
    
    "self_directed": {
      "label": "Self-Directed Care",
      "max_plan_benefit": "$100",
      ...
    },
    
    "home_modifications": {
      "label": "Home Modifications",
      "max_plan_benefit": "$1000",
      ...
    },
    
    /* Summary flags (boolean): */
    "food_benefit": true,
    "meals_benefit": true,
    "pest_control_benefit": true,
    "transportation_benefit": true,
    "utility_assistance": true,
    "housing_support": false
  }
}

Each line-item uses the standard benefit object schema (copay/coinsurance/deductible/auth/period).
Summary flags (food_benefit, meals_benefit, etc.) are derived from individual benefit presence.
Period keys use PERIODICITY_MAP: "Every year", "Every month", "Every 3 months", etc.

================================================================================
12. COMBINED BENEFITS (SHARED WALLET) — GROUP STRUCTURE
================================================================================

{
  "combined_benefits": {
    "label": "Combined Benefit Allowances (Shared Wallet)",
    "groups": [
      {
        "name": "Dental Maximum Amount",
        "categories": [
          "Oral Exams (16b1)",
          "Dental X-Rays (16b2)",
          "Restorative Services (16c1)",
          ...
        ],
        "max_plan_benefit": "$4000",
        "max_plan_benefit_period": "Every year",
        "no_dollar_cap": false,
        "includes": [
          "Preventive Dental",
          "Comprehensive Dental"
        ]
      },
      {
        "name": "Healthy Options/OTC Allowance",
        "categories": [
          "Over-the-Counter (OTC) Items (13b)",
          "OTC Hearing Aids (18c)"
        ],
        "max_plan_benefit": "$1500",
        "max_plan_benefit_period": "Every month",
        "no_dollar_cap": false,
        "includes": [
          "OTC Items",
          "OTC Hearing Aids"
        ]
      }
    ]
  }
}

Semantics:

  name (string)
    — Flex card name or wallet group name (e.g., "Dental Maximum", "Healthy Options").

  categories (string[])
    — List of CMS service-category codes + human labels.
    — Format: "Category Name (code)" e.g., "Preventive Dental (16b2)".
    — Service codes map to individual benefits via label matching.

  max_plan_benefit (string)
    — Shared dollar allowance for this group (pooled across all items in the group).

  max_plan_benefit_period (string)
    — Periodicity: "Every month", "Every year", etc. (from PERIODICITY_MAP).

  no_dollar_cap (boolean)
    — true if group has unlimited dollars (rare); max_plan_benefit is absent.

  includes (string[])
    — Derived by matching SSBCI items' period to this group's period.
    — Shows which SSBCI line-items (e.g., "Food & Produce", "Transportation") 
      contribute to this wallet.
    — This is an inferred grouping (not explicit CMS data).

Multiple groups are independent; member can use all of them in the same benefit period.

================================================================================
13. VBID / UNIFORM-FLEXIBILITY PACKAGES
================================================================================

{
  "vbid_packages": {
    "label": "VBID / Special Supplemental Packages",
    "packages": [
      {
        "name": "Food, Utility, and Rent Card",
        "category": "Supplemental Benefit Package (SSBCI/UF)",
        "package_type": "3",
        "aggregate_allowance": "$263 (Every month)",
        "benefit_categories": [
          "Non-Primarily Health Related Benefits for the Chronically Ill (SSBCI) (13i1)",
          "Non-Primarily Health Related Benefits for the Chronically Ill (SSBCI) (13i10)"
        ],
        "eligibility": "Chronic Kidney Disease; Chronic Obstructive Pulmonary Disease"
      },
      {
        "name": "Cost-Sharing Reduction for Heart Failure",
        "category": "Cost-Sharing Reduction (Uniform Flexibility)",
        "reduced_benefits": "Emergency services, Urgent care, Inpatient hospital, Specialist",
        "reduced_to_zero": true,
        "eligibility": "Heart Failure"
      }
    ]
  }
}

Package types:
  Category: "Cost-Sharing Reduction (Uniform Flexibility)" — reduces member copay/coinsurance
  Category: "Supplemental Benefit Package (SSBCI/UF)" — adds SSBCI allowances
  
package_type (string) — CMS code (1-6 range, mostly unused in display).
aggregate_allowance (string) — Shared dollar allowance with period appended.
benefit_categories (string[]) — List of covered benefit categories under this package.
eligibility (string) — Enrollment prerequisites (condition name, income threshold, etc.).
reduced_to_zero (boolean) — If present & true, cost-sharing waived to $0 for the package.

================================================================================
14. DRUG COVERAGE — PART D STRUCTURE
================================================================================

{
  "drug_coverage": {
    "has_drug_benefit": true,
    "benefit_type": "Comprehensive",
    "num_tiers": "5",
    "deductible": "$615",
    
    "insulin_cost_sharing": true,
    "vaccine_coverage": true,
    
    "generic_retail_30day": "$0",
    "generic_retail_90day": "$0",
    "generic_mail_30day": "$10",
    "generic_mail_90day": "$30",
    
    "insulin_retail_30day": "$0",
    "insulin_retail_90day": "$0",
    "insulin_mail_30day": "$10",
    "insulin_mail_90day": "$30",
    
    "tiers": [
      {
        "tier_label": "Preferred Generic",
        "tier_id": "1",
        "retail_copay_30day": "$0",
        "retail_copay_90day": "$0",
        "retail_coinsurance_30day": null,
        "retail_coinsurance_90day": null,
        "preferred_retail_copay_30day": "$0",
        "preferred_retail_copay_90day": "$0",
        "preferred_retail_coinsurance_30day": null,
        "preferred_retail_coinsurance_90day": null,
        "mail_copay_30day": "$0",
        "mail_copay_90day": "$0",
        "mail_coinsurance_30day": null,
        "mail_coinsurance_90day": null,
        "ltc_copay": "$0",
        "ltc_coinsurance": null,
        "oon_copay_30day": "$0",
        "oon_coinsurance_30day": null,
        "insulin_retail_copay_30day": "$0",
        "insulin_retail_copay_90day": "$0",
        "insulin_preferred_retail_copay_30day": "$0",
        "insulin_mail_copay_30day": "$10",
        "insulin_mail_copay_90day": "$30",
        "description": "Preferred Generic, Generic, Preferred Brand, Non-Preferred Drug, Specialty Tier"
      },
      { /* Tier 2, 3, 4, 5 ... */ }
    ],
    
    "catastrophic_tiers": [
      {
        "label": "Specialty Drug",
        "tier_id": "specialty",
        "drug_type": "Brand/Specialty",
        "copay": "$100",
        "coinsurance": "33%",
        "cost_structure": "higher of copay/coinsurance"
      }
    ]
  }
}

Top-level fields:

  has_drug_benefit (boolean)
    — false if plan has no Part D coverage (still emitted for plans without PDP).

  benefit_type (string)
    — "Comprehensive", "Enhanced", "Standard", or plan-specific type.

  num_tiers (string)
    — Number of tiers CMS filed (usually "5", sometimes blank).

  deductible (string)
    — Annual Part D deductible (e.g., "$615", "$0").

  insulin_cost_sharing (boolean)
    — Attestation: IRA inflation-protection cap applied ($35/month for insulin).

  vaccine_coverage (boolean)
    — Attestation: OTC vaccines covered.

Tier fields (per tier object in tiers array):

  tier_label (string)
    — Human label from CMS: "Preferred Generic", "Tier 2", "Specialty Tier", etc.

  tier_id (string)
    — Numeric CMS tier ID ("1", "2", "3", "4", "5").

  retail_copay_30day, retail_copay_90day (string or null)
    — Copay for standard retail (30/90 day supply).

  retail_coinsurance_30day, retail_coinsurance_90day (string or null)
    — Coinsurance % for retail (if plan uses % instead of copay).

  preferred_retail_copay_30day, preferred_retail_copay_90day (string or null)
    — Copay for preferred retail network (often lower).

  mail_copay_30day, mail_copay_90day (string or null)
    — Copay for mail-order pharmacy (lower than retail).

  ltc_copay, ltc_coinsurance (string or null)
    — Cost-sharing for long-term care facility pharmacies.

  oon_copay_30day, oon_coinsurance_30day (string or null)
    — Out-of-network pharmacy cost-sharing.

  insulin_retail_copay_30day, insulin_retail_copay_90day (string or null)
    — Capped insulin copay at retail (IRA cap: $35/month).

  insulin_mail_copay_30day, insulin_mail_copay_90day (string or null)
    — Capped insulin copay at mail-order.

  description (string or null)
    — Plan's formulary description of tier contents.

catastrophic_tiers (array):
  — Applied after patient reaches out-of-pocket threshold.
  — Same field structure as regular tiers.
  — Tier ID often "catastrophic" or "post-catastrophic".

================================================================================
15. HOW "IS THIS BENEFIT COVERED" IS REPRESENTED
================================================================================

A benefit is **NOT covered** if the corresponding key is completely absent from
the benefits object. Example:

  Benefit NOT in plan:    benefits = { "primary_care": {...}, "specialist": {...} }
                          (no "eye_exams" key means vision is not covered)

  Benefit IS covered:     benefits["eye_exams"] = { "label": "...", ... }

**Safe data retrieval pattern:**

  if ("eye_exams" in benefits && benefits["eye_exams"]) {
    // Vision exams ARE covered; render details
    copay = benefits["eye_exams"]["copay"] || null;   // or "not specified"
    if (copay === "$0") {
      // No copay (free)
    } else if (copay) {
      // Copay applies
    } else {
      // Copay not specified; may be coinsurance-only
    }
  } else {
    // NOT covered; show "Not covered" or skip section
  }

**Coverage flags convention:**

  Benefits use **explicit field presence**, not boolean "covered" flags.
  
  - If a benefit object has only {"label": "X"}, it means "covered but no cost info filed".
  - If copay/coinsurance/deductible are all null, the benefit is covered (CMS just didn't file details).
  - If the entire key is absent, the benefit is NOT covered.

**Missing fields (safe_get returns ""):**

  When CMS column doesn't exist in the file, safe_get() returns "" (empty string).
  clean_dict() then removes it (converts "" to None, omits None values).
  
  This means **blank fields are intentional omissions**, not data loss.
  Always check for field presence before rendering; don't assume null = uncovered.

================================================================================
16. SPECIAL MAPPING NOTES & DATA INTEGRITY TRAPS
================================================================================

**CRITICAL TRAPS (from AUDIT_2026.md):**

1. Silent column-name loss
   — safe_get(row, col) returns "" if column doesn't exist in that file.
   — clean_dict() removes it from JSON as None.
   — Example: diagnostic_radiology used _mc_ suffix; should use _dmc_ or _lab_.
   — **Fix:** Check extraction logic against actual CMS column names (AUDIT verified).

2. Interval families for inpatient/SNF
   — Copay/coinsurance intervals read from _mcs_ (Medicare-covered stay).
   — Wrong family reads: _ad_ (additional days) or _lrd_ (lifetime reserve days).
   — **Fix:** extract_inpatient() uses ordered family fallback (mcs → ad → lrd).

3. Suffix-coded sub-types (not numbered)
   — Dental b16b has sub-types keyed by suffix (_oe, _pc, _ft, _dx, ...) NOT numbered (b16b1..6).
   — Same for b14c (preventive), b16c (comprehensive dental), b14e (preventive).
   — **Fix:** Loop over known suffix list; detect presence via column existence.

4. Auth/referral binary encoding
   — 1 = Yes, 2 = No (verified empirically; no "3" = "sometimes").
   — AUTH_MAP uses "Yes"/"No" strings; code accepts both boolean and string.
   — **Fix:** AUTH_MAP.get(auth, yn(auth)) handles both formats.

5. Zero-dollar D-SNP member liability
   — dsnp_zero_dollar = true plans have real copay/coinsurance in data.
   — UI adds display-layer "$0 member liability" (handled by benefit-formatter.js).
   — **Fix:** Data stays faithful to CMS; display layer applies reduction at render time.

6. Combined benefits ↔ SSBCI linkage
   — CMS doesn't state which SSBCI item belongs to which combined-benefit group.
   — **Inferred:** Linked by matching periodicity (monthly items → monthly group).
   — **Fix:** Linkage happens in build_plan_detail() lines ~2103-2121.

7. Copay min/max variants
   — CMS uses different column names per section (not one uniform scheme).
   — Example: _copay_amt_mc_min (standard) vs _copay_mc_amt_min vs _copay_amt_min (b14b).
   — **Fix:** extract_simple_benefit() / extract_supplemental_benefit() use ordered fallback chains.

**DATA INTEGRITY VERIFIED (2026):**
  — Cardiac rehab copay: 3937 plans (was 0 before audit fix).
  — Dental comprehensive sub_types: 3535 plans (was 0).
  — Hearing exams copay: 4732 plans (was 0).
  — Drug tier OON/IRA insulin: 4521/5222 plans (newly extracted).
  — VBID packages: 2564 plans (newly extracted).
  — No regressions on specialist, primary_care, premium, MOOP, drug tiers.

================================================================================
17. EXAMPLE REAL PLANS
================================================================================

**Example 1: H0028_007_0 (Comprehensive MA+PD Plan)**
  Plan Type: Local PPO
  SNP: No
  Premium: Varies by region
  Benefits: 55 keys present (broad coverage)
    - Dental: All 3 tiers (preventive, comprehensive)
    - Vision: Eye exams + eyewear
    - Hearing: Exams, aids, OTC aids
    - Social supports: Food, transportation, utilities
    - Combined benefits: Dental + OTC wallet ($4000 + $1500/month)
    - Drug coverage: 5 tiers, $615 deductible
    - VBID: Food/utility/rent card ($263/month)

**Example 2: H0016_001_0 (PACE Plan)**
  Plan Type: PACE (Program of All-Inclusive Care for the Elderly)
  SNP: No
  Premium: $0
  Benefits: 40+ keys, label-only (no cost-sharing filed)
    - No detailed copay/coinsurance (PACE uses different billing)
    - Emphasis on coordination and integrated care
    - All benefits marked as covered (label only)

================================================================================
18. FILE PATHS & NAMING CONVENTIONS
================================================================================

Per-plan JSON filename: H{contract}_{plan_id}_{segment}.json

  contract  = 4 digits (pbp_a_hnumber), e.g., 0028, 3014
  plan_id   = 3 digits (pbp_a_plan_identifier), e.g., 007, 801
  segment   = segment_id (typically "0" for all 2026 plans)

Examples:
  H0028_007_0.json     — Contract H0028, Plan 007, Segment 0
  H3014_801_0.json
  E3014_801_0.json     (E-prefix from older regional plans)

Total files: ~8,081 plans in 2026 data

================================================================================
19. SUMMARY: MEMBER UI DATA CONTRACT
================================================================================

For member-facing benefits UI, assume:

1. Use presence of key in "benefits" object to determine if covered.
2. Cost-sharing fields (copay/coinsurance/deductible_applies) may be null.
   — null does NOT mean $0; it means "not specified".
   — Show "Contact plan for details" if cost data missing.
3. Ranges (e.g., "$10 - $50") indicate variations (provider type, service level).
4. Dental/Vision/Hearing have 2-3 tiers; iterate sub_types for details.
5. Drug tiers have 5+ fields per tier; prioritize retail_copay + mail_copay.
6. Social supports and combined benefits may have "includes" cross-links.
7. VBID packages have eligibility criteria; filter by member's conditions.
8. D-SNP zero-dollar plans: show "$0 member liability" overlay (dsnp_zero_dollar flag).
9. Network info (OON, POS, visitor benefits) in "network" section, not per-benefit.

EOF
cat "/private/tmp/claude-501/-Users-jennkerfoot-Documents-Claude-Code-DUOS-DIGITAL-NAVIGATOR-v2/645dbd92-3a85-4872-8c38-69d2bee13a99/scratchpad/cms_pbp_json_reference.txt"
