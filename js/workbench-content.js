// GENERATED from content/ by tools/generate-content-bundle.py — do not edit by hand.
window.WB_CONTENT = {
 "taxonomy": {
  "$schema": "duos-benefit-content/v1",
  "comment": "Card taxonomy: which PBP benefit keys produce which member-facing cards. A card renders if ANY of its pbpSources keys is present in the plan's benefits object — EXCEPT drug_coverage, which is a top-level key gated on has_drug_benefit=true. This file — not the carrier packs — is what makes the Hub scale to plans with different benefit mixes. Order = display order. pbpCategories = PBP service-category code prefixes the card represents (longest-prefix match, e.g. '14c4' beats '14'); used by the compiler's shared-wallet/VBID consolidation (COMPILER_SPEC.md 4a) to detect when a wallet group or VBID package's categories are already represented by rendered cards.",
  "cards": [
   {
    "key": "doctorVisits",
    "pbpSources": [
     "primary_care",
     "specialist",
     "telehealth"
    ],
    "pbpCategories": [
     "7a",
     "7c",
     "7j"
    ]
   },
   {
    "key": "prescriptions",
    "pbpSources": [
     "drug_coverage"
    ],
    "note": "top-level drug_coverage object, gated on has_drug_benefit=true"
   },
   {
    "key": "dental",
    "pbpSources": [
     "dental_preventive",
     "dental_comprehensive",
     "dental_medicare"
    ],
    "pbpCategories": [
     "16"
    ]
   },
   {
    "key": "vision",
    "pbpSources": [
     "eye_exams",
     "eyewear"
    ],
    "pbpCategories": [
     "17"
    ]
   },
   {
    "key": "hearing",
    "pbpSources": [
     "hearing_exams",
     "hearing_aids",
     "otc_hearing_aids"
    ],
    "pbpCategories": [
     "18"
    ]
   },
   {
    "key": "fitness",
    "pbpSources": [
     "fitness"
    ],
    "pbpCategories": [
     "14c4"
    ]
   },
   {
    "key": "otc",
    "pbpSources": [
     "otc_items"
    ],
    "pbpCategories": [
     "13b"
    ]
   },
   {
    "key": "flexAllowance",
    "pbpSources": [
     "combined_benefits"
    ],
    "note": "one section per combined_benefits.groups[] entry; suppress standalone dollar display of any benefit listed in a group's includes[]"
   },
   {
    "key": "meals",
    "pbpSources": [
     "meals"
    ],
    "pbpCategories": [
     "13c"
    ]
   },
   {
    "key": "transportation",
    "pbpSources": [
     "transportation"
    ],
    "pbpCategories": [
     "10b"
    ]
   },
   {
    "key": "acupuncture",
    "pbpSources": [
     "acupuncture_supplemental"
    ],
    "pbpCategories": [
     "13a"
    ]
   },
   {
    "key": "chiropractor",
    "pbpSources": [
     "chiropractic"
    ],
    "pbpCategories": [
     "7b"
    ]
   },
   {
    "key": "mentalHealth",
    "pbpSources": [
     "mental_health_outpatient",
     "mental_health_specialist",
     "outpatient_psychiatric"
    ],
    "pbpCategories": [
     "7e",
     "7h",
     "9c"
    ]
   },
   {
    "key": "homeHealth",
    "pbpSources": [
     "home_health"
    ],
    "pbpCategories": [
     "6"
    ]
   },
   {
    "key": "dme",
    "pbpSources": [
     "dme",
     "prosthetics",
     "medical_supplies"
    ],
    "pbpCategories": [
     "11"
    ]
   },
   {
    "key": "outpatientRehab",
    "pbpSources": [
     "outpatient_rehabilitation",
     "physical_speech_therapy",
     "occupational_therapy"
    ],
    "pbpCategories": [
     "7d",
     "7i",
     "9d"
    ]
   },
   {
    "key": "inHomeSafety",
    "pbpSources": [
     "additional_preventive"
    ],
    "subTypeFilter": "In-Home Safety Assessment"
   },
   {
    "key": "pers",
    "pbpSources": [
     "additional_preventive"
    ],
    "subTypeFilter": "Personal Emergency Response System"
   },
   {
    "key": "wigs",
    "pbpSources": [
     "additional_preventive"
    ],
    "subTypeFilter": "Wigs"
   },
   {
    "key": "preventiveCare",
    "pbpSources": [
     "annual_physical",
     "additional_preventive",
     "preventive_attestation"
    ],
    "note": "renders the additional_preventive sub_types NOT claimed by a subTypeFilter card above",
    "pbpCategories": [
     "14"
    ]
   },
   {
    "key": "emergencyCare",
    "pbpSources": [
     "emergency_care",
     "urgent_care",
     "worldwide_emergency"
    ],
    "pbpCategories": [
     "4"
    ]
   },
   {
    "key": "socialSupports",
    "pbpSources": [
     "social_supports"
    ],
    "requiresEligibility": "ssbci",
    "note": "SSBCI is chronic-condition gated. Compiler emits the card with requiresEligibility; the app shows/hides it at render time using the existing member-eligibility-file flag. Live at launch for eligible members.",
    "pbpCategories": [
     "13i"
    ]
   },
   {
    "key": "vbidPackages",
    "pbpSources": [
     "vbid_packages"
    ],
    "requiresEligibility": "ssbci",
    "note": "VBID/UF special supplemental packages use the SAME member-eligibility flag as SSBCI (product confirmed). Compiled per plan, displayed per member."
   }
  ]
 },
 "registry": {
  "$schema": "duos-benefit-content/v1",
  "comment": "Maps CMS contract numbers to carrier packs in carriers/. A contract not listed here still compiles — it just uses base/ wording only.",
  "contracts": {
   "H5425": "scan",
   "H7617": "humana"
  }
 },
 "yearConstants": {
  "$schema": "duos-benefit-content/v1",
  "planYear": 2026,
  "partDOopCap": "$2,100",
  "insulinMonthlyCap": "$35",
  "comment": "Statutory Part D values. Compliance confirms annually; facts referencing these are marked source: computed."
 },
 "adminMapping": {
  "$schema": "duos-benefit-content/v1",
  "comment": "Crosswalk from admin-tool benefit names (one row per covered benefit per PBP) to Hub taxonomy card keys. The card's PBP gate still decides whether anything renders — an admin row can never un-gate a card.",
  "planIdFormat": {
   "adminPattern": "H5425123001 = contract(5) + pbp(3) + segment(3), no separators",
   "parse": {
    "contract": "chars 1-5",
    "pbp": "chars 6-8",
    "segment": "chars 9-11"
   },
   "pipelineFormat": "H{contract}_{pbp}_{segment} e.g. H5425_123_0",
   "segmentRule": "CONFIRMED by product 2026-07-01: no defined segment = '000'; defined segment = its value zero-padded to 3 digits. Crosswalk: admin segment = pipeline segment zero-padded to 3 (pipeline '0' ↔ admin '000')."
  },
  "benefits": {
   "acupuncture": {
    "card": "acupuncture"
   },
   "chiropractor": {
    "card": "chiropractor"
   },
   "home_health_agency_care": {
    "card": "homeHealth"
   },
   "in_home_safety_assessment": {
    "card": "inHomeSafety"
   },
   "mental_health_provider": {
    "card": "mentalHealth"
   },
   "durable_medical_equipment": {
    "card": "dme"
   },
   "home_delivered_meals_health": {
    "card": "meals"
   },
   "outpatient_rehabilitation_services": {
    "card": "outpatientRehab"
   },
   "pcp_and_specialist": {
    "card": "doctorVisits"
   },
   "hearing_exam_and_hearing_aids": {
    "card": "hearing"
   },
   "pers": {
    "card": "pers"
   },
   "transportation_health": {
    "card": "transportation"
   },
   "vision": {
    "card": "vision"
   },
   "over_the_counter_otc_and_ssbci_benefit": {
    "card": "otc",
    "note": "DECISION (default unless product objects): blob renders on the otc card only; the flexAllowance card carries a cross-reference line to it when OTC is wallet-pooled; compiler flags blobs containing SSBCI-specific language for product review (SSBCI text on the universal OTC card would reach non-eligible members). Durable fix requested of product: split this admin row into separate 'otc' and 'ssbci' benefits so SSBCI instructions live behind the eligibility gate."
   },
   "wigs_for_hair_loss": {
    "card": "wigs"
   },
   "dental": {
    "card": "dental"
   },
   "fitness": {
    "card": "fitness"
   }
  }
 },
 "base": {
  "acupuncture": {
   "$schema": "duos-benefit-content/v1",
   "key": "acupuncture",
   "title": "Acupuncture",
   "icon": "spa",
   "iconBg": "#ECFDF5",
   "iconColor": "#059669",
   "barColor": "#059669",
   "tagline": "Acupuncture visits covered by your plan",
   "tileSubtitle": "Acupuncture covered",
   "sections": [
    {
     "icon": "spa",
     "label": "Acupuncture",
     "facts": [
      {
       "label": "Your cost per visit",
       "slot": "acupuncture_supplemental.copay",
       "altSlot": "acupuncture_supplemental.coinsurance",
       "highlight": true
      },
      {
       "label": "Visits included",
       "slot": "acupuncture_supplemental.visit_limit",
       "suffix": " {acupuncture_supplemental.visit_limit_period}"
      },
      {
       "label": "Prior authorization",
       "slot": "acupuncture_supplemental.prior_auth_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Acupuncture can help manage chronic pain without adding medications — many members use it alongside physical therapy."
    }
   ]
  },
  "chiropractor": {
   "$schema": "duos-benefit-content/v1",
   "key": "chiropractor",
   "title": "Chiropractic Care",
   "icon": "healing",
   "iconBg": "#FFF7ED",
   "iconColor": "#C2410C",
   "barColor": "#C2410C",
   "tagline": "Chiropractic visits covered by your plan",
   "tileSubtitle": "Chiropractic covered",
   "sections": [
    {
     "icon": "healing",
     "label": "Chiropractic Care",
     "facts": [
      {
       "label": "Your cost per visit",
       "slot": "chiropractic.copay",
       "altSlot": "chiropractic.coinsurance",
       "highlight": true
      },
      {
       "label": "Referral required",
       "slot": "chiropractic.referral_required"
      },
      {
       "label": "Prior authorization",
       "slot": "chiropractic.prior_auth_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Medicare covers chiropractic care for spinal manipulation — a drug-free option for back and neck pain."
    }
   ]
  },
  "dental": {
   "$schema": "duos-benefit-content/v1",
   "key": "dental",
   "title": "Dental",
   "icon": "dentistry",
   "iconBg": "#EAF3FA",
   "iconColor": "#2278B4",
   "barColor": "#2278B4",
   "tagline": "Preventive and comprehensive dental coverage",
   "tileSubtitle": "Dental coverage included",
   "sections": [
    {
     "icon": "dentistry",
     "label": "Preventive Dental",
     "facts": [
      {
       "label": "Medicare-covered dental services",
       "slot": "dental_medicare.copay",
       "altSlot": "dental_medicare.coinsurance"
      },
      {
       "forEach": "dental_preventive.sub_types",
       "label": "{item.label}",
       "slot": "item.copay",
       "altSlot": "item.coinsurance"
      },
      {
       "label": "Preventive dental maximum",
       "slot": "dental_preventive.max_plan_benefit",
       "highlight": true
      }
     ]
    },
    {
     "icon": "dentistry",
     "label": "Comprehensive Dental",
     "facts": [
      {
       "forEach": "dental_comprehensive.sub_types",
       "label": "{item.label}",
       "slot": "item.copay",
       "altSlot": "item.coinsurance"
      },
      {
       "label": "Comprehensive dental maximum",
       "slot": "dental_comprehensive.max_plan_benefit",
       "highlight": true
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Routine cleanings do more than clean teeth — they help prevent costly procedures like root canals and extractions down the road."
    }
   ]
  },
  "dme": {
   "$schema": "duos-benefit-content/v1",
   "key": "dme",
   "title": "Medical Equipment & Supplies",
   "icon": "accessible",
   "iconBg": "#F1F5F9",
   "iconColor": "#334155",
   "barColor": "#334155",
   "tagline": "Durable medical equipment, prosthetics & supplies",
   "tileSubtitle": "Equipment & supplies",
   "sections": [
    {
     "icon": "accessible",
     "label": "Durable Medical Equipment",
     "facts": [
      {
       "label": "Your cost",
       "slot": "dme.copay",
       "altSlot": "dme.coinsurance",
       "highlight": true
      },
      {
       "label": "Prior authorization",
       "slot": "dme.prior_auth_required"
      }
     ]
    },
    {
     "icon": "medical_services",
     "label": "Prosthetics & Medical Supplies",
     "facts": [
      {
       "label": "Prosthetic devices",
       "slot": "prosthetics.copay",
       "altSlot": "prosthetics.coinsurance"
      },
      {
       "label": "Medical supplies",
       "slot": "medical_supplies.copay",
       "altSlot": "medical_supplies.coinsurance"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Walkers, wheelchairs, hospital beds, CGMs, and oxygen equipment usually fall under DME — get them through contracted suppliers to make sure they're covered."
    }
   ]
  },
  "doctorVisits": {
   "$schema": "duos-benefit-content/v1",
   "key": "doctorVisits",
   "title": "Doctor Visits",
   "icon": "stethoscope",
   "iconBg": "#E0F5FB",
   "iconColor": "#155E75",
   "barColor": "#155E75",
   "tagline": "{primary_care.copay} primary care · {specialist.copay} specialist visits",
   "tileSubtitle": "{primary_care.copay} PCP · {specialist.copay} specialist",
   "sections": [
    {
     "icon": "stethoscope",
     "label": "Office Visits",
     "facts": [
      {
       "label": "Primary care visit (PCP)",
       "slot": "primary_care.copay",
       "highlight": true
      },
      {
       "label": "Specialist visit",
       "slot": "specialist.copay"
      },
      {
       "label": "Specialist referral required",
       "slot": "specialist.referral_required"
      },
      {
       "label": "Telehealth visit",
       "slot": "telehealth.copay"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Seeing your primary care doctor regularly helps catch small problems before they become big ones — and most plans cover the visit at low or no cost."
    }
   ]
  },
  "emergencyCare": {
   "$schema": "duos-benefit-content/v1",
   "key": "emergencyCare",
   "title": "Emergency & Urgent Care",
   "icon": "emergency",
   "iconBg": "#FEE2E2",
   "iconColor": "#DC2626",
   "barColor": "#DC2626",
   "tagline": "Emergency room, urgent care, and worldwide coverage",
   "tileSubtitle": "ER & urgent care",
   "sections": [
    {
     "icon": "emergency",
     "label": "When You Need Care Fast",
     "facts": [
      {
       "label": "Emergency room",
       "slot": "emergency_care.copay",
       "highlight": true,
       "altSlot": "emergency_care.coinsurance"
      },
      {
       "label": "Urgent care",
       "slot": "urgent_care.copay",
       "altSlot": "urgent_care.coinsurance"
      },
      {
       "label": "Emergency care while traveling abroad",
       "slot": "worldwide_emergency.copay_emergency",
       "altSlot": "worldwide_emergency.coinsurance_emergency"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "For non-life-threatening issues, urgent care is usually faster and cheaper than the ER. For emergencies, always call 911 — coverage follows you."
    }
   ]
  },
  "fitness": {
   "$schema": "duos-benefit-content/v1",
   "key": "fitness",
   "title": "Fitness",
   "icon": "fitness_center",
   "iconBg": "#E6F8DE",
   "iconColor": "#386F19",
   "barColor": "#386F19",
   "tagline": "{fitness.copay|$0} fitness benefit included in your plan",
   "tileSubtitle": "{fitness.copay|$0} fitness benefit",
   "sections": [
    {
     "icon": "fitness_center",
     "label": "Fitness Benefit",
     "facts": [
      {
       "label": "Included programs",
       "slot": "fitness.fitness_types"
      },
      {
       "label": "Your cost",
       "slot": "fitness.copay",
       "highlight": true
      },
      {
       "label": "Plan pays up to",
       "slot": "fitness.max_plan_benefit",
       "suffix": " {fitness.max_plan_benefit_period}"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Regular physical activity is one of the most effective ways to reduce fall risk and support heart health."
    }
   ]
  },
  "flexAllowance": {
   "$schema": "duos-benefit-content/v1",
   "key": "flexAllowance",
   "title": "Flex Allowance",
   "icon": "account_balance_wallet",
   "iconBg": "#F3E8FF",
   "iconColor": "#7C3AED",
   "barColor": "#7C3AED",
   "tagline": "A shared allowance you can spend across benefit categories",
   "tileSubtitle": "Shared benefit allowance",
   "sections": [
    {
     "icon": "account_balance_wallet",
     "label": "{group.name}",
     "forEach": "combined_benefits.groups",
     "facts": [
      {
       "label": "Allowance",
       "slot": "group.max_plan_benefit",
       "suffix": " {group.max_plan_benefit_period}",
       "highlight": true
      },
      {
       "label": "Can be used for",
       "slot": "group.includes",
       "join": " · "
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "This is one pooled amount shared across the listed categories — spending in one category reduces what's left for the others in the same period."
    }
   ]
  },
  "hearing": {
   "$schema": "duos-benefit-content/v1",
   "key": "hearing",
   "title": "Hearing",
   "icon": "hearing",
   "iconBg": "#EEECFD",
   "iconColor": "#6366F1",
   "barColor": "#6366F1",
   "tagline": "{hearing_exams.copay} hearing exam · hearing aid coverage",
   "tileSubtitle": "{hearing_exams.copay} exam · aids covered",
   "sections": [
    {
     "icon": "hearing",
     "label": "Hearing Coverage",
     "facts": [
      {
       "label": "Routine hearing exam",
       "slot": "hearing_exams.copay"
      },
      {
       "label": "Hearing aids",
       "slot": "hearing_aids.copay"
      },
      {
       "label": "Plan pays up to",
       "slot": "hearing_aids.max_plan_benefit",
       "suffix": " {hearing_aids.max_plan_benefit_scope}",
       "highlight": true
      },
      {
       "label": "Over-the-counter hearing aids",
       "slot": "otc_hearing_aids.max_plan_benefit",
       "prefix": "Up to "
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Research links untreated hearing loss to higher risk of cognitive decline and social isolation. Addressing hearing early protects long-term brain health."
    }
   ]
  },
  "homeHealth": {
   "$schema": "duos-benefit-content/v1",
   "key": "homeHealth",
   "title": "Home Health Care",
   "icon": "home_health",
   "iconBg": "#E0E7FF",
   "iconColor": "#4338CA",
   "barColor": "#4338CA",
   "tagline": "Skilled care at home covered by your plan",
   "tileSubtitle": "Home health covered",
   "sections": [
    {
     "icon": "home_health",
     "label": "Home Health Agency Care",
     "facts": [
      {
       "label": "Your cost",
       "slot": "home_health.copay",
       "altSlot": "home_health.coinsurance",
       "highlight": true
      },
      {
       "label": "Prior authorization",
       "slot": "home_health.prior_auth_required"
      },
      {
       "label": "Referral required",
       "slot": "home_health.referral_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Home health brings skilled nursing and therapy to you after an illness or hospital stay — ask your doctor if you qualify."
    }
   ]
  },
  "inHomeSafety": {
   "$schema": "duos-benefit-content/v1",
   "key": "inHomeSafety",
   "title": "In-Home Safety Assessment",
   "icon": "gpp_good",
   "iconBg": "#ECFEFF",
   "iconColor": "#0E7490",
   "barColor": "#0E7490",
   "tagline": "A professional home safety check covered by your plan",
   "tileSubtitle": "Home safety check",
   "sections": [
    {
     "icon": "gpp_good",
     "label": "In-Home Safety Assessment",
     "facts": [
      {
       "label": "Your cost",
       "slot": "subType.copay",
       "highlight": true
      },
      {
       "label": "Plan pays up to",
       "slot": "subType.max_plan_benefit"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Most falls happen at home — a safety assessment spots risks like loose rugs, poor lighting, and missing grab bars before they cause an injury."
    }
   ],
   "note": "Call us and we'll explain how to use this benefit."
  },
  "meals": {
   "$schema": "duos-benefit-content/v1",
   "key": "meals",
   "title": "Meals",
   "icon": "restaurant",
   "iconBg": "#FFE4E6",
   "iconColor": "#BE123C",
   "barColor": "#BE123C",
   "tagline": "Healthy meals delivered during a covered health situation",
   "tileSubtitle": "Meals for a covered health situation",
   "sections": [
    {
     "icon": "restaurant",
     "label": "Meal Benefit",
     "facts": [
      {
       "label": "When you can use it",
       "slot": "meals.meal_types",
       "highlight": true
      },
      {
       "label": "Your cost",
       "slot": "meals.copay",
       "altSlot": "meals.coinsurance"
      },
      {
       "label": "Plan pays up to",
       "slot": "meals.max_plan_benefit",
       "suffix": " {meals.max_plan_benefit_period}"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Meal benefits give you healthy, ready-made meals during a covered health situation — ask your care team or call us to set them up."
    }
   ]
  },
  "mentalHealth": {
   "$schema": "duos-benefit-content/v1",
   "key": "mentalHealth",
   "title": "Mental Health",
   "icon": "psychology",
   "iconBg": "#FAF5FF",
   "iconColor": "#7E22CE",
   "barColor": "#7E22CE",
   "tagline": "Mental health visits covered by your plan",
   "tileSubtitle": "Counseling & psychiatry",
   "sections": [
    {
     "icon": "psychology",
     "label": "Mental Health Care",
     "facts": [
      {
       "label": "Therapy visit (individual)",
       "slot": "mental_health_outpatient.copay_individual",
       "altSlot": "mental_health_outpatient.coinsurance_individual",
       "highlight": true
      },
      {
       "label": "Therapy visit (group)",
       "slot": "mental_health_outpatient.copay_group",
       "altSlot": "mental_health_outpatient.coinsurance_group"
      },
      {
       "label": "Psychiatrist visit",
       "slot": "mental_health_specialist.copay_individual",
       "altSlot": "mental_health_specialist.coinsurance_individual"
      },
      {
       "label": "Referral",
       "slot": "mental_health_outpatient.referral_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Mental health is health — talking to a professional about mood, sleep, grief, or worry is as routine as seeing your doctor for blood pressure."
    }
   ]
  },
  "otc": {
   "$schema": "duos-benefit-content/v1",
   "key": "otc",
   "title": "OTC Allowance",
   "icon": "shopping_bag",
   "iconBg": "#FEF3C7",
   "iconColor": "#D97706",
   "barColor": "#D97706",
   "tagline": "{otc_items.max_plan_benefit} {otc_items.max_plan_benefit_period} for health products",
   "tileSubtitle": "{otc_items.max_plan_benefit} {otc_items.max_plan_benefit_period}",
   "sections": [
    {
     "icon": "shopping_bag",
     "label": "Over-the-Counter (OTC) Allowance",
     "facts": [
      {
       "label": "Allowance",
       "slot": "otc_items.max_plan_benefit",
       "suffix": " {otc_items.max_plan_benefit_period}",
       "highlight": true
      }
     ],
     "chips": [
      "Vitamins & Supplements",
      "Pain Relief",
      "First Aid",
      "Cold & Flu",
      "Allergy",
      "Digestive Health",
      "Eye Care",
      "Oral Care"
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Check your plan's OTC catalog for eligible items — allowances typically expire, so use them each period."
    }
   ]
  },
  "outpatientRehab": {
   "$schema": "duos-benefit-content/v1",
   "key": "outpatientRehab",
   "title": "Rehabilitation Therapy",
   "icon": "directions_walk",
   "iconBg": "#FEFCE8",
   "iconColor": "#A16207",
   "barColor": "#A16207",
   "tagline": "Physical, occupational & speech therapy",
   "tileSubtitle": "PT · OT · speech therapy",
   "sections": [
    {
     "icon": "directions_walk",
     "label": "Outpatient Rehabilitation",
     "facts": [
      {
       "label": "Physical / speech therapy visit",
       "slot": "physical_speech_therapy.copay",
       "altSlot": "physical_speech_therapy.coinsurance",
       "highlight": true
      },
      {
       "label": "Occupational therapy visit",
       "slot": "occupational_therapy.copay",
       "altSlot": "occupational_therapy.coinsurance"
      },
      {
       "label": "Outpatient rehabilitation services",
       "slot": "outpatient_rehabilitation.copay",
       "altSlot": "outpatient_rehabilitation.coinsurance"
      },
      {
       "label": "Prior authorization",
       "slot": "physical_speech_therapy.prior_auth_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Therapy after surgery, a fall, or a stroke is one of the strongest predictors of getting back to normal life — don't skip sessions."
    }
   ]
  },
  "pers": {
   "$schema": "duos-benefit-content/v1",
   "key": "pers",
   "title": "Emergency Response Device (PERS)",
   "icon": "emergency_share",
   "iconBg": "#FEF2F2",
   "iconColor": "#B91C1C",
   "barColor": "#B91C1C",
   "tagline": "A wearable button that calls for help 24/7",
   "tileSubtitle": "24/7 help button",
   "sections": [
    {
     "icon": "emergency_share",
     "label": "Personal Emergency Response System",
     "facts": [
      {
       "label": "Your cost",
       "slot": "subType.copay",
       "highlight": true
      },
      {
       "label": "Plan pays up to",
       "slot": "subType.max_plan_benefit"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "A PERS device means help is one button-press away, anywhere in your home — many members say it's as much peace of mind for family as for themselves."
    }
   ],
   "note": "Call us and we'll explain how to use this benefit."
  },
  "prescriptions": {
   "$schema": "duos-benefit-content/v1",
   "key": "prescriptions",
   "title": "Prescription Drugs",
   "icon": "medication",
   "iconBg": "#F9F0F9",
   "iconColor": "#AC3EA4",
   "barColor": "#AC3EA4",
   "tagline": "Part D prescription drug coverage included",
   "tileSubtitle": "Drug coverage included",
   "sections": [
    {
     "icon": "medication",
     "label": "Drug Cost-Sharing",
     "facts": [
      {
       "label": "Annual drug deductible",
       "slot": "drug_coverage.deductible",
       "highlight": true
      },
      {
       "forEach": "drug_coverage.tiers",
       "label": "{item.tier_label} — 30-day supply",
       "slot": "item.preferred_retail_copay_30day",
       "altSlot": "item.retail_copay_30day"
      },
      {
       "forEach": "drug_coverage.tiers",
       "label": "{item.tier_label} — 30-day supply",
       "slot": "item.preferred_retail_coinsurance_30day",
       "altSlot": "item.retail_coinsurance_30day"
      },
      {
       "forEach": "drug_coverage.tiers",
       "label": "{item.tier_label} — 90-day supply",
       "slot": "item.mail_copay_90day",
       "altSlot": "item.preferred_retail_copay_90day"
      }
     ]
    },
    {
     "icon": "vaccines",
     "label": "Insulin & Vaccines",
     "facts": [
      {
       "label": "Insulin cap",
       "value": "No more than {yearConstants.insulinMonthlyCap}/month, any tier",
       "source": "computed"
      },
      {
       "label": "Yearly out-of-pocket maximum",
       "value": "{yearConstants.partDOopCap} — then $0 for the rest of the year",
       "source": "computed"
      },
      {
       "label": "Adult vaccines (Part D)",
       "value": "$0 copay",
       "source": "computed"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "savings",
     "text": "If you qualify for Extra Help (LIS), your drug costs could drop significantly — ask us about applying."
    }
   ]
  },
  "preventiveCare": {
   "$schema": "duos-benefit-content/v1",
   "key": "preventiveCare",
   "title": "Preventive Care",
   "icon": "ecg_heart",
   "iconBg": "#DEF5F7",
   "iconColor": "#0D4F54",
   "barColor": "#0D4F54",
   "tagline": "Medicare preventive services at no cost to you",
   "tileSubtitle": "No-cost screenings & wellness",
   "sections": [
    {
     "icon": "ecg_heart",
     "label": "Preventive Services",
     "facts": [
      {
       "label": "Medicare preventive services",
       "value": "$0 copay",
       "source": "computed",
       "note": "Gated on preventive_attestation.zero_cost_attestation"
      },
      {
       "label": "Annual physical exam",
       "slot": "annual_physical.copay",
       "highlight": true
      }
     ]
    },
    {
     "icon": "add_circle",
     "label": "Additional Preventive Benefits",
     "facts": [
      {
       "forEach": "additional_preventive.sub_types",
       "label": "{item.label}",
       "slot": "item.copay",
       "default": "Covered"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "health_and_safety",
     "text": "When a service is billed as preventive (screening, no symptoms) it is usually covered at no cost; if it becomes diagnostic, normal cost-sharing may apply. Ask your provider how a service will be billed."
    }
   ]
  },
  "socialSupports": {
   "$schema": "duos-benefit-content/v1",
   "key": "socialSupports",
   "title": "Everyday Living Support",
   "icon": "volunteer_activism",
   "iconBg": "#ECFDF5",
   "iconColor": "#047857",
   "barColor": "#047857",
   "eligibilityBanner": "You're eligible for these extra everyday-living supports because of a qualifying health condition.",
   "tagline": "Extra help with food, home, and getting to appointments",
   "tileSubtitle": "Food, home & daily support",
   "sections": [
    {
     "icon": "volunteer_activism",
     "label": "What's included for you",
     "chipsFrom": "social_supports.items",
     "chipLabel": "{item.label}",
     "facts": []
    }
   ],
   "note": "Call us and we'll help you start using these supports.",
   "connections": [
    {
     "icon": "lightbulb",
     "text": "These supports cover practical needs that affect your health — like healthy food, a safe home, and rides to appointments."
    }
   ],
   "requiresEligibility": "ssbci"
  },
  "transportation": {
   "$schema": "duos-benefit-content/v1",
   "key": "transportation",
   "title": "Transportation",
   "icon": "directions_car",
   "iconBg": "#DBEAFE",
   "iconColor": "#1D4ED8",
   "barColor": "#1D4ED8",
   "tagline": "Rides to health-related locations covered by your plan",
   "tileSubtitle": "Covered rides",
   "sections": [
    {
     "icon": "directions_car",
     "label": "Transportation Benefit",
     "facts": [
      {
       "label": "Your cost per trip",
       "slot": "transportation.copay",
       "highlight": true
      },
      {
       "label": "Trips included",
       "slot": "transportation.trip_limit",
       "suffix": " {transportation.trip_limit_period}"
      },
      {
       "label": "Trip type",
       "slot": "transportation.trip_type"
      },
      {
       "label": "Ways to ride",
       "slot": "transportation.transport_modes"
      },
      {
       "label": "Prior authorization",
       "slot": "transportation.prior_auth_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Missed appointments are one of the biggest barriers to staying healthy — covered rides remove that barrier."
    }
   ]
  },
  "vbidPackages": {
   "$schema": "duos-benefit-content/v1",
   "key": "vbidPackages",
   "title": "Special Benefit Packages",
   "icon": "redeem",
   "iconBg": "#FFF1F2",
   "iconColor": "#9F1239",
   "barColor": "#9F1239",
   "requiresEligibility": "ssbci",
   "eligibilityBanner": "Available to members with qualifying conditions — your plan has confirmed you qualify.",
   "tagline": "Extra benefits you qualify for based on your health conditions",
   "tileSubtitle": "Extra benefits you qualify for",
   "sections": [
    {
     "icon": "redeem",
     "label": "{package.name}",
     "forEach": "vbid_packages.packages",
     "facts": [
      {
       "label": "Allowance",
       "slot": "package.aggregate_allowance",
       "highlight": true
      },
      {
       "label": "Can be used for",
       "slot": "package.benefit_categories",
       "join": " · "
      },
      {
       "label": "Cost-sharing reduced on",
       "slot": "package.reduced_benefits"
      },
      {
       "label": "Qualifying conditions",
       "slot": "package.eligibility"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "These packages exist because of your specific health conditions — they're designed to help with the everyday costs that come with managing them."
    }
   ]
  },
  "vision": {
   "$schema": "duos-benefit-content/v1",
   "key": "vision",
   "title": "Vision",
   "icon": "visibility",
   "iconBg": "#E0F5FB",
   "iconColor": "#0891B2",
   "barColor": "#0891B2",
   "tagline": "{eye_exams.copay} eye exam · up to {eyewear.max_plan_benefit} for eyewear",
   "tileSubtitle": "{eye_exams.copay} exam · {eyewear.max_plan_benefit} eyewear",
   "sections": [
    {
     "icon": "visibility",
     "label": "Vision Coverage",
     "facts": [
      {
       "label": "Routine eye exam",
       "slot": "eye_exams.copay"
      },
      {
       "label": "Eyewear allowance (glasses or contacts)",
       "slot": "eyewear.max_plan_benefit",
       "prefix": "Up to ",
       "highlight": true
      },
      {
       "label": "Glasses copay",
       "slot": "eyewear.glasses_copay"
      },
      {
       "label": "Contacts copay",
       "slot": "eyewear.contacts_copay"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "A routine eye exam is more than an eyesight check — it can reveal early signs of conditions like diabetes, high blood pressure, and glaucoma."
    }
   ]
  },
  "wigs": {
   "$schema": "duos-benefit-content/v1",
   "key": "wigs",
   "title": "Wigs for Hair Loss",
   "icon": "face",
   "iconBg": "#FDF2F8",
   "iconColor": "#BE185D",
   "barColor": "#BE185D",
   "tagline": "Wigs covered for medical hair loss",
   "tileSubtitle": "Wigs covered",
   "sections": [
    {
     "icon": "face",
     "label": "Wigs",
     "facts": [
      {
       "label": "Your cost",
       "slot": "subType.copay",
       "highlight": true
      },
      {
       "label": "Plan pays up to",
       "slot": "subType.max_plan_benefit"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Wigs are typically covered for hair loss from chemotherapy or other medical treatment — a prescription from your doctor is usually all you need."
    }
   ],
   "note": "Call us and we'll explain how to use this benefit."
  }
 },
 "carriers": {
  "humana": {
   "dental": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "dental",
    "note": "Use dentists in the Humana Dental Medicare Network.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   },
   "fitness": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "fitness",
    "vendor": "SilverSneakers",
    "tagline": "SilverSneakers — {fitness.copay|$0} gym access & classes",
    "tileSubtitle": "SilverSneakers — {fitness.copay|$0} gym",
    "cta": {
     "label": "Find a SilverSneakers gym",
     "icon": "open_in_new",
     "action": "web",
     "href": "https://www.silversneakers.com"
    },
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   },
   "flexAllowance": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "flexAllowance",
    "note": "Allowances are loaded to your Humana Spending Account Card — check your balance at MyHumana.com.",
    "cta": {
     "label": "Check my balance at MyHumana",
     "icon": "open_in_new",
     "action": "web",
     "href": "https://www.myhumana.com"
    },
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   },
   "hearing": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "hearing",
    "vendor": "TruHearing",
    "cta": {
     "label": "Call TruHearing to schedule",
     "icon": "call",
     "action": "tel",
     "href": "tel:8442557144"
    },
    "note": "Hearing aids are TruHearing-branded Advanced models through TruHearing providers — there is no out-of-network coverage for aids.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   },
   "meals": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "meals",
    "vendor": "Humana Well Dine",
    "note": "Meals delivered after a hospital stay through Humana Well Dine.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity. Quantities/frequency are EOC facts pending product approval."
   },
   "otc": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "otc",
    "vendor": "Humana Spending Account Card",
    "note": "Your allowance is loaded to the Humana Spending Account Card — check your balance at MyHumana.com.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity. Monthly accrual/rollover mechanics are EOC facts pending product approval."
   },
   "prescriptions": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "prescriptions",
    "vendor": "CenterWell Pharmacy (preferred mail order)",
    "note": "CenterWell Pharmacy is the preferred mail-order option.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   },
   "vision": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "humana"
    },
    "key": "vision",
    "note": "Network: Humana Medicare Insight Network; a higher eyewear allowance applies at PLUS providers.",
    "verification": "Verified against 2026 HumanaChoice SNP-DE H7617-076 SB (Humana-H7617076000SB26) / EOC (Humana-H7617076000EOC26). Re-verify per plan before extending claims beyond vendor identity."
   }
  },
  "scan": {
   "fitness": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "carrier": "scan"
    },
    "key": "fitness",
    "vendor": "One Pass",
    "tagline": "One Pass — {fitness.copay|$0} gym memberships, on-demand workouts & community classes",
    "tileSubtitle": "One Pass — {fitness.copay|$0} gym & classes",
    "note": "Your fitness benefit is provided through One Pass. Enroll at youronepass.com or call One Pass to get started at any participating gym.",
    "cta": {
     "label": "Explore One Pass",
     "icon": "open_in_new",
     "action": "web",
     "href": "https://www.youronepass.com"
    },
    "eoc_facts": [
     {
      "label": "Includes",
      "value": "Gym memberships · on-demand workouts · community classes",
      "source": "eoc",
      "approved": true,
      "citation": "2026 SCAN Allied Summary of Benefits (26C-SBH5425123), Fitness section"
     }
    ],
    "verification": "Vendor (One Pass) and included services verified against the 2026 SCAN Summary of Benefits (26C-SBH5425123), Fitness section. Internal provenance — never rendered to members (COMPILER_SPEC §2b)."
   }
  }
 },
 "contracts": {},
 "plans": {
  "H7617_076_0": {
   "flexAllowance": {
    "$schema": "duos-benefit-content/v1",
    "appliesTo": {
     "plan": "H7617_076_0"
    },
    "key": "flexAllowance",
    "title": "Healthy Options card",
    "eoc_facts": [
     {
      "label": "Monthly deposit",
      "value": "$225 a month",
      "source": "eoc",
      "approved": true,
      "citation": "EOC Chapter 4, Healthy Options Allowance (Humana-H7617076000EOC26); SB wallet section (Humana-H7617076000SB26)",
      "requires": "vbid_packages"
     }
    ],
    "verification": "Plan-scoped: the Healthy Options name and $225/month deposit are verified for H7617-076 only — do NOT promote to the carrier pack."
   }
  }
 }
};
