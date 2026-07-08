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
    "key": "podiatry",
    "pbpSources": [
     "podiatry"
    ],
    "pbpCategories": [
     "7f"
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
     "occupational_therapy",
     "cardiac_rehab"
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
  "comment": "Full CMS contract->carrier-slug crosswalk, derived from each plan's org_marketing_name (consumer brand) across the whole corpus. A slug with no carriers/<slug>/ pack still compiles on base/ wording only. Currently only 'scan' and 'humana' ship packs. Regenerate with 07-compiler/build-registry.py, then run workbench/sync-copies.sh.",
  "contracts": {
   "E3014": "pennsylvania-public-school-employees-retirement-sy",
   "H0016": "life-coordinated-commonwealth-pace-inc",
   "H0028": "humana",
   "H0029": "wellcare",
   "H0034": "hamaspik-inc",
   "H0062": "wellcare-by-superior-healthplan",
   "H0074": "wellcare",
   "H0104": "blue-cross-and-blue-shield-of-alabama",
   "H0105": "orangeburg-senior-helping-center-a-pace-healthcare-program",
   "H0107": "blue-cross-and-blue-shield-of-montana",
   "H0111": "wellcare",
   "H0112": "palm-beach-pace",
   "H0154": "viva-medicare",
   "H0169": "unitedhealthcare",
   "H0174": "wellcare",
   "H0216": "immanuel-pathways-iowa",
   "H0235": "pace-of-northeast-indiana-llc",
   "H0251": "unitedhealthcare",
   "H0270": "wellcare",
   "H0292": "humana",
   "H0294": "unitedhealthcare",
   "H0302": "blue-cross-blue-shield-of-arizona-az-blue",
   "H0321": "unitedhealthcare",
   "H0332": "kelseycare-advantage",
   "H0342": "carepartners-of-connecticut",
   "H0351": "wellcare",
   "H0354": "cigna-healthcare",
   "H0363": "longevity-health-plan",
   "H0390": "pace-of-southwest-michigan",
   "H0413": "devoted-health",
   "H0421": "unitedhealthcare",
   "H0423": "metroplus-health-plan",
   "H0424": "innovage-florida-pace-orlando",
   "H0432": "unitedhealthcare",
   "H0439": "cigna-healthcare",
   "H0440": "empath-life",
   "H0473": "humana",
   "H0477": "serenity-care-pace",
   "H0504": "blue-shield-of-california",
   "H0523": "aetna-medicare",
   "H0524": "kaiser-permanente",
   "H0542": "altamed-health-services-corporation",
   "H0543": "unitedhealthcare",
   "H0544": "anthem-blue-cross",
   "H0562": "wellcare-by-health-net",
   "H0571": "cchp-chinese-community-health-plan",
   "H0609": "unitedhealthcare",
   "H0613": "innovage-colorado-pace",
   "H0624": "unitedhealthcare",
   "H0628": "aetna-medicare",
   "H0629": "anthem-blue-cross-and-blue-shield",
   "H0630": "kaiser-permanente",
   "H0672": "cigna-healthcare",
   "H0710": "unitedhealthcare",
   "H0712": "wellcare",
   "H0724": "wellcare-by-allwell",
   "H0738": "amerihealth-caritas-vip-care-hmo-d-snp",
   "H0755": "unitedhealthcare",
   "H0764": "unitedhealthcare",
   "H0777": "mass-general-brigham-health-plan",
   "H0783": "humana",
   "H0809": "mercy-life",
   "H0816": "myadvocate-medicare-advantage",
   "H0819": "senior-life-york",
   "H0839": "senior-community-care-of-north-carolina",
   "H0870": "blue-ridge-independence-at-home",
   "H0885": "braven-health",
   "H0907": "wellpoint",
   "H0908": "wellcare",
   "H0913": "wellcare",
   "H0934": "welbehealth",
   "H0963": "humana",
   "H0976": "scan",
   "H0978": "scan",
   "H0982": "solis-health-plans",
   "H1019": "careplus-health-plans-inc",
   "H1032": "wellcare",
   "H1035": "florida-blue-hmo",
   "H1036": "humana",
   "H1043": "florida-pace-centers-inc",
   "H1045": "unitedhealthcare",
   "H1099": "health-first-health-plans-inc",
   "H1109": "aetna-medicare",
   "H1112": "wellcare",
   "H1119": "valor-health-plan",
   "H1170": "kaiser-permanente",
   "H1181": "network-health-medicare-advantage-plans",
   "H1188": "buckeye-pace",
   "H1189": "christus-health-advantage",
   "H1206": "aetna-medicare",
   "H1212": "wellpoint",
   "H1215": "wellcare",
   "H1219": "welbehealth",
   "H1224": "l-a-care-health-plan",
   "H1225": "johns-hopkins-advantage-md",
   "H1228": "central-valley-pace",
   "H1230": "kaiser-permanente",
   "H1234": "capital-health-life",
   "H1239": "innovage-virginia-pace-roanoke-valley",
   "H1248": "blue-cross-and-blue-shield-of-louisiana",
   "H1278": "unitedhealthcare",
   "H1280": "eternalhealth",
   "H1285": "unitedhealthcare-community-plan",
   "H1290": "devoted-health",
   "H1302": "blue-cross-of-idaho",
   "H1304": "regence-blueshield-of-idaho",
   "H1310": "senior-care-partners-p-a-c-e",
   "H1312": "trinity-health-pace-of-alexandria",
   "H1339": "johns-hopkins-advantage-md",
   "H1347": "patrius-health",
   "H1350": "blue-cross-of-idaho",
   "H1357": "carolina-seniorcare",
   "H1360": "unitedhealthcare",
   "H1365": "martin-s-point-generations-advantage",
   "H1372": "ageright-advantage",
   "H1395": "wellcare",
   "H1396": "humana",
   "H1416": "wellcare",
   "H1423": "wellpoint",
   "H1468": "humana",
   "H1486": "commonwealth-care-alliance-inc",
   "H1500": "life-st-joseph-of-the-pines",
   "H1518": "catholic-health-life",
   "H1526": "gold-kidney-health-plan",
   "H1533": "staywell-senior-care",
   "H1537": "unitedhealthcare",
   "H1544": "welbehealth",
   "H1587": "tribute-health-plans",
   "H1607": "anthem-blue-cross-and-blue-shield",
   "H1608": "aetna-medicare",
   "H1609": "aetna-medicare",
   "H1610": "aetna-better-health-of-virginia",
   "H1611": "mass-general-brigham-health-plan",
   "H1619": "jefferson-health-plans",
   "H1622": "north-east-medical-services-program-of-all-inclusive-care-for-the-elderly-pace",
   "H1644": "longevity-health-plan",
   "H1651": "medical-associates-health-plan-inc",
   "H1659": "unitedhealthcare",
   "H1664": "wellcare",
   "H1666": "blue-cross-and-blue-shield-of-nm-tx",
   "H1671": "community-health-plan-of-imperial-valley",
   "H1692": "aetna-medicare",
   "H1693": "family-health-center-for-older-adults",
   "H1714": "ascension-living-hope",
   "H1722": "healthfirst-medicare-plan",
   "H1742": "ascension-living-st-vincent-pace",
   "H1787": "great-plains-medicare-advantage",
   "H1799": "passport-advantage",
   "H1822": "scan",
   "H1846": "medigold",
   "H1862": "wellcare",
   "H1889": "unitedhealthcare",
   "H1894": "wellpoint",
   "H1904": "pace-greater-new-orleans",
   "H1914": "wellcare",
   "H1917": "welbehealth",
   "H1947": "healthy-blue",
   "H1951": "humana",
   "H1961": "peoples-health",
   "H1969": "regence-blueshield-of-idaho",
   "H1980": "bluegrass-pace-care",
   "H1993": "astiva-health",
   "H1994": "select-health",
   "H1997": "regence-blueshield",
   "H2001": "unitedhealthcare",
   "H2029": "humana",
   "H2032": "baylor-scott-white-health-plan",
   "H2034": "community-care",
   "H2035": "alameda-alliance-for-health",
   "H2041": "devoted-health",
   "H2056": "aetna-medicare",
   "H2064": "life-geisinger",
   "H2085": "providence-pace",
   "H2108": "cigna-healthcare",
   "H2109": "hopkins-elderplus",
   "H2117": "wellcare",
   "H2126": "neighborhood-health-plan-of-rhode-island",
   "H2162": "wellcare",
   "H2168": "villagecaremax",
   "H2172": "kaiser-permanente",
   "H2174": "wellcare",
   "H2185": "lifeworks-advantage",
   "H2218": "elder-service-plan-of-harbor-health-services-inc",
   "H2219": "fallon-health",
   "H2220": "upham-s-pace",
   "H2221": "cha-pace",
   "H2222": "element-care-inc",
   "H2223": "neighborhood-pace",
   "H2224": "molina-healthcare",
   "H2225": "commonwealth-care-alliance-massachusetts",
   "H2226": "unitedhealthcare",
   "H2230": "blue-cross-blue-shield-of-massachusetts",
   "H2235": "baycare-health-plans",
   "H2237": "icare",
   "H2247": "unitedhealthcare",
   "H2256": "tufts-health-plan",
   "H2261": "blue-cross-blue-shield-of-massachusetts",
   "H2272": "unitedhealthcare",
   "H2292": "unitedhealthcare",
   "H2293": "aetna-medicare",
   "H2318": "pace-southeast-michigan",
   "H2320": "priority-health-medicare",
   "H2322": "hap-senior-plus-ppo",
   "H2354": "hap-senior-plus",
   "H2368": "innovage-california-pace-sacramento",
   "H2384": "welbehealth",
   "H2385": "unitedhealthcare",
   "H2386": "appalachian-agency-for-senior-citizens-inc",
   "H2392": "kansas-health-advantage",
   "H2397": "pace-at-hudson-headwaters-inc",
   "H2400": "signature-advantage-hmo-snp",
   "H2406": "unitedhealthcare",
   "H2416": "primewest-health",
   "H2417": "itasca-medical-care-imcare-classic",
   "H2419": "south-country-health-alliance",
   "H2422": "healthpartners",
   "H2425": "blue-plus",
   "H2441": "anthem-blue-cross-and-blue-shield",
   "H2445": "unitedhealthcare",
   "H2450": "medica",
   "H2456": "ucare-s-msho",
   "H2458": "medica",
   "H2461": "blue-cross-and-blue-shield-of-minnesota",
   "H2462": "healthpartners",
   "H2463": "humana",
   "H2478": "molina-healthcare-of-nevada",
   "H2486": "humana",
   "H2491": "wellcare",
   "H2509": "unitedhealthcare",
   "H2526": "devoted-health",
   "H2541": "agewell-pace",
   "H2563": "sentara-medicare",
   "H2564": "amerihealth-caritas-vip-care-hmo-snp",
   "H2593": "wellpoint",
   "H2610": "essence-healthcare",
   "H2624": "healthteam-advantage",
   "H2628": "anthem-blue-cross-and-blue-shield",
   "H2630": "verda-health-plan-of-arizona",
   "H2663": "aetna-medicare",
   "H2686": "devoted-health",
   "H2687": "wellpoint",
   "H2694": "eternalhealth",
   "H2697": "devoted-health",
   "H2704": "kaiser-permanente",
   "H2715": "molina-healthcare-of-illinois",
   "H2737": "health-new-england-medicare-advantage-plans",
   "H2752": "cigna-healthcare",
   "H2775": "wellcare",
   "H2802": "unitedhealthcare",
   "H2815": "senior-community-care-of-colorado",
   "H2816": "wellcare",
   "H2819": "blue-shield-of-california",
   "H2835": "thome-pace",
   "H2836": "anthem-blue-cross-and-blue-shield",
   "H2845": "devoted-health",
   "H2853": "ascension-complete",
   "H2875": "humana",
   "H2882": "pace-central-michigan",
   "H2915": "wellcare",
   "H2918": "jordan-valley-senior-care",
   "H2923": "devoted-health",
   "H2926": "primewest-health",
   "H2936": "lifecircles",
   "H2937": "senior-life-greensburg",
   "H2941": "sentara-pace",
   "H2942": "cox-healthplans",
   "H2960": "senior-care-plus",
   "H2962": "ultimate-health-plans",
   "H2992": "senior-life-washington-uniontown-greene",
   "H3038": "molina-healthcare-of-california",
   "H3041": "devoted-health",
   "H3048": "secur-health-plan",
   "H3060": "life-butler-county",
   "H3071": "clear-spring-health",
   "H3080": "devoted-health",
   "H3084": "international-community-health-services",
   "H3093": "molina-healthcare-of-illinois",
   "H3113": "unitedhealthcare",
   "H3124": "jefferson-health-plans",
   "H3127": "upper-peninsula-health-plan-uphp-mi-coordinated-health",
   "H3138": "kaiser-permanente",
   "H3146": "aetna-medicare",
   "H3152": "aetna-medicare",
   "H3170": "blue-cross-and-blue-shield-of-nebraska",
   "H3186": "align-powered-by-sanford-health-plan",
   "H3192": "aetna-medicare",
   "H3204": "presbyterian-health-plan",
   "H3219": "allina-health-aetna-medicare",
   "H3239": "aetna-medicare",
   "H3240": "wellpoint",
   "H3251": "blue-cross-and-blue-shield-of-new-mexico",
   "H3256": "unitedhealthcare",
   "H3259": "bluecare-plus-tennessee",
   "H3274": "align-senior-care",
   "H3276": "connecticare",
   "H3284": "pacific-northwest-pace-partners",
   "H3288": "aetna-medicare",
   "H3291": "pruitthealth-premier",
   "H3305": "mvp-health-care",
   "H3312": "aetna-medicare",
   "H3321": "independent-living-srvcs-of-central-ny",
   "H3322": "eddy-seniorcare",
   "H3329": "centerlight-healthcare-pace",
   "H3330": "emblemhealth",
   "H3331": "elderone-an-affiliate-of-rochester-regional-health",
   "H3335": "excellus-health-plan-inc",
   "H3344": "independent-health",
   "H3347": "elderplan",
   "H3351": "excellus-health-plan-inc",
   "H3359": "healthfirst-medicare-plan",
   "H3362": "independent-health",
   "H3379": "unitedhealthcare",
   "H3384": "highmark-blue-cross-blue-shield-or-highmark-blue-shield",
   "H3387": "unitedhealthcare",
   "H3388": "cdphp-medicare-advantage",
   "H3404": "blue-cross-and-blue-shield-of-north-carolina",
   "H3407": "el-paso-health-medicare-advantage",
   "H3418": "unitedhealthcare",
   "H3419": "perennial-advantage",
   "H3430": "suncoast-pace-inc",
   "H3443": "alignment-health-plan",
   "H3447": "anthem-healthkeepers",
   "H3449": "blue-cross-and-blue-shield-of-north-carolina",
   "H3467": "procare-advantage",
   "H3473": "innovage-virginia-pace-blue-ridge",
   "H3493": "trinity-health-life-new-jersey",
   "H3499": "wellcare",
   "H3517": "redwood-coast-pace",
   "H3522": "reid-health-pace-center",
   "H3528": "connecticare",
   "H3533": "humana",
   "H3536": "anthem-blue-cross-and-blue-shield",
   "H3551": "eternalhealth",
   "H3557": "blue-cross-blue-shield-of-rhode-island",
   "H3561": "wellcare-by-health-net",
   "H3563": "gary-and-mary-west-pace",
   "H3597": "aetna-medicare",
   "H3613": "mcgregor-pace",
   "H3653": "paramount-elite-medicare-plans",
   "H3655": "anthem-blue-cross-and-blue-shield",
   "H3660": "summacare-medicare-advantage-plans",
   "H3664": "primetime-health-plan",
   "H3668": "medigold",
   "H3672": "the-health-plan",
   "H3706": "globalhealth",
   "H3708": "american-health-advantage-of-oklahoma",
   "H3727": "communicare-advantage",
   "H3740": "pace-of-west-baltimore",
   "H3748": "aetna-medicare",
   "H3755": "communitycare-senior-health-plan-hmo",
   "H3777": "experience-health",
   "H3794": "unitedhealthcare",
   "H3800": "provider-partners-health-plans",
   "H3805": "unitedhealthcare",
   "H3809": "providence-elderplace-portland",
   "H3810": "allcare-advantage",
   "H3811": "samaritan-advantage-health-plans",
   "H3814": "atrio-health-plans",
   "H3815": "alignment-health-plan",
   "H3817": "regence-bluecross-blueshield-of-oregon",
   "H3822": "blue-cross-and-blue-shield-of-il-nm",
   "H3828": "saint-alphonsus-health-plan",
   "H3832": "hmsa-akamai-advantage",
   "H3864": "pacificsource-medicare",
   "H3868": "unitedhealthcare",
   "H3890": "johns-hopkins-advantage-md",
   "H3907": "upmc-for-life",
   "H3908": "mercy-life-west-philadelphia",
   "H3909": "independence-blue-cross",
   "H3916": "highmark-blue-cross-blue-shield-or-highmark-blue-shield",
   "H3917": "community-life",
   "H3918": "life-pittsburgh",
   "H3919": "mercy-life",
   "H3923": "capital-blue-cross",
   "H3924": "geisinger-gold",
   "H3925": "senior-life-johnstown",
   "H3928": "aetna-medicare",
   "H3931": "aetna-medicare",
   "H3933": "osf-healthcare-pace",
   "H3942": "elderhaus-pace",
   "H3949": "cigna-healthcare",
   "H3952": "independence-blue-cross",
   "H3954": "geisinger-gold",
   "H3957": "highmark-blue-cross-blue-shield-or-highmark-blue-shield",
   "H3959": "aetna-medicare",
   "H3962": "capital-blue-cross",
   "H3975": "wellcare",
   "H3979": "blue-cross-and-blue-shield-of-oklahoma",
   "H3991": "cherry-blossom-pace",
   "H4003": "medicare-y-mucho-mas-mmm",
   "H4004": "medicare-y-mucho-mas-mmm",
   "H4005": "triple-s-advantage",
   "H4026": "scan",
   "H4032": "unitedhealthcare",
   "H4036": "anthem-blue-cross-and-blue-shield",
   "H4045": "santa-clara-family-health-plan",
   "H4053": "prisma-health-seniorcare-pace-upstate",
   "H4054": "provider-partners-health-plans",
   "H4057": "kern-family-health-care-medicare-d-snp",
   "H4073": "wellcare",
   "H4074": "mercy-life-of-alabama",
   "H4091": "simpra-advantage",
   "H4093": "provider-partners-health-plans",
   "H4105": "pace-organization-of-rhode-island",
   "H4118": "huron-valley-pace",
   "H4140": "doctors-healthcare-plans-inc",
   "H4141": "humana",
   "H4142": "cherokee-elder-care",
   "H4152": "blue-cross-blue-shield-of-rhode-island",
   "H4158": "wellcare",
   "H4161": "anthem-blue-cross-partnership-plan",
   "H4172": "nhc-advantage",
   "H4185": "neighborhood-healthcare-pace",
   "H4193": "hap-caresource-mi-coordinated-health",
   "H4203": "prisma-health-seniorcare-pace-midlands",
   "H4213": "arkansas-blue-medicare",
   "H4227": "vista-health-plan-inc",
   "H4232": "american-health-advantage-of-utah",
   "H4235": "senior-total-life-care",
   "H4256": "pace-north",
   "H4279": "upmc-for-life-complete-care",
   "H4286": "leon-health-inc",
   "H4305": "total-life-healthcare",
   "H4326": "senior-tlc",
   "H4329": "humana",
   "H4346": "anthem-blue-cross-and-blue-shield",
   "H4348": "devoted-health",
   "H4371": "molina-healthcare",
   "H4393": "archcare-senior-life",
   "H4402": "ascension-living-alexian-pace",
   "H4407": "cigna-healthcare",
   "H4439": "provider-partners-health-plans",
   "H4444": "provider-partners-health-plans",
   "H4461": "humana",
   "H4471": "anthem-blue-cross",
   "H4473": "devoted-health",
   "H4490": "american-health-advantage-of-missouri",
   "H4497": "medical-mutual-of-ohio",
   "H4499": "sentara-medicare",
   "H4506": "wellcare",
   "H4513": "cigna-healthcare",
   "H4514": "unitedhealthcare",
   "H4517": "the-basics-at-jan-werner",
   "H4518": "bienvivir-senior-health-services",
   "H4523": "aetna-medicare",
   "H4527": "unitedhealthcare",
   "H4537": "wellcare",
   "H4538": "seen-health-san-gabriel-valley-llc",
   "H4544": "peoples-health",
   "H4545": "k-day-pace",
   "H4604": "unitedhealthcare",
   "H4605": "regence-bluecross-blueshield-of-utah",
   "H4610": "unitedhealthcare",
   "H4623": "humana",
   "H4624": "zing-health",
   "H4626": "myplace-pace",
   "H4647": "ucla-health-medicare-advantage-plan",
   "H4661": "wellcare",
   "H4676": "troy-medicare",
   "H4694": "anthem-healthkeepers",
   "H4704": "anthem-blue-cross-life-and-health-insurance-company",
   "H4711": "aetna-medicare",
   "H4714": "pace-of-the-southern-piedmont",
   "H4733": "community-health-group",
   "H4739": "first-choice-vip-care-hmo-d-snp",
   "H4754": "pacificsource-medicare",
   "H4808": "devoted-health",
   "H4835": "aetna-medicare",
   "H4847": "wellcare",
   "H4868": "wellcare",
   "H4869": "gold-kidney-health-plan",
   "H4875": "priority-health-medicare",
   "H4882": "healthpartners",
   "H4909": "anthem-blue-cross-and-blue-shield",
   "H4919": "innovage-florida-pace-tampa",
   "H4931": "banner-medicare-advantage",
   "H4937": "blue-shield-of-california",
   "H4939": "humana",
   "H4961": "alignment-health-plan",
   "H4982": "aetna-medicare",
   "H4999": "life-northwestern-pennsylvania",
   "H5007": "providence-elderplace",
   "H5008": "unitedhealthcare",
   "H5009": "regence-blueshield",
   "H5015": "texas-independence-health-plan",
   "H5037": "mountain-empire-pace",
   "H5042": "cdphp-medicare-advantage",
   "H5050": "kaiser-permanente",
   "H5080": "boldage-pace",
   "H5085": "community-pace-at-home-inc",
   "H5087": "wellcare",
   "H5106": "highmark-blue-cross-blue-shield",
   "H5117": "wellcare-by-allwell",
   "H5119": "contra-costa-health-care-plus-hmo-d-snp",
   "H5124": "franciscan-senior-health-wellness",
   "H5141": "clover-health",
   "H5163": "verda-health-plan-of-texas",
   "H5167": "rocky-mountain-pace",
   "H5178": "humana",
   "H5190": "wellcare-by-allwell",
   "H5209": "my-choice-wisconsin",
   "H5211": "security-health-plan-of-wisconsin-inc",
   "H5212": "community-care",
   "H5213": "innovage-new-mexico-pace",
   "H5215": "network-health-medicare-advantage-plans",
   "H5216": "humana",
   "H5232": "paramount-elite-medicare-plans",
   "H5244": "scan",
   "H5253": "unitedhealthcare",
   "H5256": "medical-associates-clinic-health-plan-of-wisconsin",
   "H5262": "quartz-medicare-advantage-hmo",
   "H5264": "dean-health-plan-inc",
   "H5272": "wellcare-by-absolute-total-care",
   "H5273": "carepartners-of-connecticut",
   "H5294": "wellcare-by-allwell",
   "H5296": "alignment-health-plan",
   "H5299": "devoted-health",
   "H5302": "aetna-medicare",
   "H5314": "tufts-health-plan",
   "H5322": "unitedhealthcare",
   "H5325": "aetna-medicare",
   "H5361": "amerihealth",
   "H5374": "longevity-health-plan",
   "H5377": "humana",
   "H5386": "sharp-health-plan",
   "H5397": "devoted-health",
   "H5403": "on-lok-pace",
   "H5405": "center-for-elders-independence",
   "H5406": "sutter-seniorcare-pace",
   "H5410": "cigna-healthcare",
   "H5420": "unitedhealthcare",
   "H5422": "anthem-blue-cross-and-blue-shield",
   "H5425": "scan",
   "H5427": "freedom-health-inc",
   "H5431": "healthsun-health-plans-inc",
   "H5433": "caloptima-health-onecare",
   "H5434": "florida-blue",
   "H5435": "unitedhealthcare",
   "H5439": "wellcare",
   "H5447": "community-first",
   "H5453": "devoted-health",
   "H5454": "clear-spring-health",
   "H5471": "simply-healthcare-plans-inc",
   "H5472": "alignment-health-plan",
   "H5475": "wellcare",
   "H5493": "saint-francis-life",
   "H5496": "imperial-health-plan-of-california-inc",
   "H5521": "aetna-medicare",
   "H5522": "aetna-medicare",
   "H5525": "humana",
   "H5526": "highmark-blue-cross-blue-shield-or-highmark-blue-shield",
   "H5528": "emblemhealth",
   "H5533": "upmc-for-life",
   "H5538": "trinity-health-pace-of-pensacola",
   "H5549": "vns-health-medicare",
   "H5577": "mcs-classicare",
   "H5580": "mercy-care-advantage",
   "H5587": "blue-cross-blue-shield-of-arizona-health-choice",
   "H5590": "wellcare",
   "H5591": "martin-s-point-generations-advantage",
   "H5593": "aetna-medicare",
   "H5594": "optimum-healthcare-inc",
   "H5599": "wellcare-by-fidelis-care",
   "H5608": "elevate-medicare-advantage",
   "H5610": "care-resources",
   "H5619": "humana",
   "H5622": "care-guide-partners",
   "H5628": "molina-healthcare-of-utah-idaho",
   "H5629": "st-paul-s-pace",
   "H5644": "network-health-medicare-advantage-plans",
   "H5649": "central-health-medicare-plan",
   "H5652": "unitedhealthcare",
   "H5692": "central-california-alliance-for-health",
   "H5703": "south-country-health-alliance",
   "H5718": "devoted-health",
   "H5734": "health-plan-of-san-joaquin-advantage-hmo-d-snp-mountain-valley-health-plan-advantage-hmo-d-snp",
   "H5774": "triple-s-advantage",
   "H5779": "wellcare",
   "H5793": "aetna-medicare",
   "H5810": "molina-healthcare-of-california",
   "H5822": "midland-care-pace",
   "H5823": "molina-healthcare-of-washington-inc",
   "H5826": "community-health-plan-of-wa-medicare-advantage",
   "H5828": "wellpoint",
   "H5843": "banner-medicare-advantage",
   "H5852": "ahf",
   "H5854": "anthem-blue-cross-and-blue-shield",
   "H5859": "careoregon-advantage",
   "H5883": "blue-care-network",
   "H5900": "wellmark-advantage-health-plan",
   "H5902": "senior-life-altoona-ebensburg-indiana",
   "H5926": "molina-healthcare-of-michigan",
   "H5928": "blue-shield-of-california",
   "H5932": "highmark-wholecare-medicare-assured",
   "H5934": "hope-pace",
   "H5937": "ucare",
   "H5938": "capital-health-plan",
   "H5943": "villagehealth",
   "H5945": "prominence-health-plan",
   "H5959": "blue-cross-and-blue-shield-of-minnesota",
   "H5965": "wellcare",
   "H5969": "alohacare",
   "H5970": "humana",
   "H5978": "senior-life-lehigh-valley-reading",
   "H5989": "healthfirst-medicare-plan",
   "H5991": "emblemhealth",
   "H5992": "senior-whole-health-of-new-york",
   "H5993": "lawndale-christian-health-center",
   "H5995": "atrio-health-plans",
   "H6018": "devoted-health",
   "H6019": "health-plan-of-san-mateo",
   "H6059": "pace-of-the-triad",
   "H6078": "blue-medicare-advantage",
   "H6079": "innovage-california-pace",
   "H6081": "high-desert-pace",
   "H6130": "fenyx-health",
   "H6147": "loma-linda-university-health-pace",
   "H6154": "medica",
   "H6158": "arkansas-blue-medicare",
   "H6170": "champion-heath-plan",
   "H6188": "life-armstrong",
   "H6200": "essence-healthcare",
   "H6202": "nextblue-of-north-dakota",
   "H6224": "highmark-blue-cross-blue-shield",
   "H6231": "pace-baton-rouge",
   "H6237": "regence-bluecross-blueshield-of-oregon",
   "H6248": "community-health-group",
   "H6251": "trinity-health-pace-of-montgomery-county",
   "H6309": "healthpartners",
   "H6316": "healthy-blue",
   "H6317": "welbehealth",
   "H6322": "mclaren-medicare",
   "H6341": "amerihealth-caritas-vip-care",
   "H6342": "baptist-health-pace",
   "H6345": "pruitthealth-premier",
   "H6348": "wellcare",
   "H6351": "liberty-medicare-advantage",
   "H6368": "elite-health-plan-inc",
   "H6371": "lutheran-senior-life",
   "H6378": "amerihealth-caritas-vip-care-hmo-d-snp",
   "H6379": "clear-spring-health",
   "H6396": "caresource-mycare-ohio-hmo-d-snp",
   "H6399": "aetna-better-health-of-new-jersey",
   "H6425": "pace-of-the-ozarks",
   "H6453": "blue-cross-and-blue-shield-of-louisiana",
   "H6474": "champion-health-plan",
   "H6515": "molina-healthcare-of-texas-inc",
   "H6517": "family-healthcare-network-pace",
   "H6529": "mytruadvantage",
   "H6537": "habitat-health-sacramento",
   "H6541": "horizon-pace",
   "H6545": "devoted-health",
   "H6550": "wellcare",
   "H6551": "life-st-mary",
   "H6566": "lagniappe-advantage",
   "H6586": "devoted-health",
   "H6595": "unitedhealthcare",
   "H6596": "fallon-health-weinberg",
   "H6622": "humana",
   "H6652": "american-health-advantage-of-florida",
   "H6672": "clear-spring-health",
   "H6706": "unitedhealthcare",
   "H6723": "medical-mutual-of-ohio",
   "H6743": "atrio-health-plans",
   "H6759": "senior-community-care-of-kentucky",
   "H6765": "iowa-health-advantage",
   "H6776": "riverspring-health-plans",
   "H6787": "senior-community-care-of-michigan",
   "H6813": "devoted-health",
   "H6815": "wellcare",
   "H6824": "unitedhealthcare",
   "H6832": "align-senior-care",
   "H6846": "carepartners-pace",
   "H6847": "mass-general-brigham-health-plan",
   "H6851": "wellsense-health-plan",
   "H6852": "devoted-health",
   "H6868": "boldage-pace",
   "H6874": "aspirus-health-plan",
   "H6876": "zing-health",
   "H6887": "inspira-health-network-life",
   "H6891": "american-health-advantage-of-texas",
   "H6898": "vermont-blue-advantage",
   "H6910": "saint-alphonsus-health-plan",
   "H6941": "life-pace-inc",
   "H6959": "keycare-advantage",
   "H6971": "wellcare-by-meridian",
   "H6988": "centers-plan-for-healthy-living",
   "H6994": "devoted-health",
   "H7003": "immanuel-pathways-omaha",
   "H7006": "atrio-health-plans",
   "H7020": "cigna-healthcare",
   "H7027": "panorama-pace",
   "H7028": "devoted-health",
   "H7059": "stratum-life",
   "H7063": "blue-cross-and-blue-shield-of-kansas",
   "H7074": "alignment-health-plan",
   "H7093": "anthem-blue-cross-and-blue-shield",
   "H7114": "valir-pace",
   "H7115": "memorial-hermann-health-plan",
   "H7123": "upmc-for-life-complete-care",
   "H7147": "devoted-health",
   "H7149": "aetna-medicare",
   "H7151": "devoted-health",
   "H7195": "northland-pace-senior-care-services",
   "H7199": "devoted-health",
   "H7220": "anthem-healthkeepers",
   "H7233": "senior-community-care-of-maryland",
   "H7239": "prominence-health-plan",
   "H7262": "tru-pace",
   "H7275": "provider-partners-health-plans",
   "H7284": "humana",
   "H7296": "colorado-pace",
   "H7301": "aetna-medicare",
   "H7323": "wellcare",
   "H7326": "wellcare",
   "H7355": "devoted-health",
   "H7366": "innovage-california-pace-crenshaw",
   "H7379": "carefirst-bluecross-blueshield-medicare-advantage",
   "H7389": "cigna-healthcare",
   "H7397": "devoted-health",
   "H7435": "wellcare-by-meridian",
   "H7464": "unitedhealthcare",
   "H7469": "pace-partners-of-northeast-florida",
   "H7471": "devoted-health",
   "H7501": "caloptima-pace",
   "H7511": "great-plains-medicare-advantage",
   "H7512": "ascension-complete",
   "H7518": "wellcare",
   "H7522": "medicare-y-mucho-mas-mmm",
   "H7524": "excellus-health-plan-community-care-llc",
   "H7557": "longevity-health-plan",
   "H7598": "group-health-cooperative-of-eau-claire",
   "H7605": "devoted-health",
   "H7607": "clever-care-health-plan",
   "H7617": "humana",
   "H7619": "atlanticare-life-connection",
   "H7620": "cencal-careconnect",
   "H7635": "neighborhood-health-plan-of-rhode-island",
   "H7656": "boldage-pace",
   "H7660": "life-beaver-and-lawrence-counties",
   "H7670": "mass-advantage",
   "H7678": "molina-healthcare-of-texas-inc",
   "H7680": "prominence-health-plan",
   "H7710": "highmark-blue-cross-blue-shield",
   "H7725": "senior-community-care-of-jefferson-county",
   "H7766": "devoted-health",
   "H7777": "pace-of-cincinnati",
   "H7779": "american-health-advantage-of-tennessee",
   "H7787": "cigna-healthcare",
   "H7813": "icircle-services-of-the-finger-lakes-inc",
   "H7831": "evertrue-pace",
   "H7849": "cigna-healthcare",
   "H7855": "brandman-centers-for-senior-care",
   "H7917": "bluecross-blueshield-of-tennessee",
   "H7980": "wellsense-health-plan",
   "H7993": "devoted-health",
   "H8003": "blue-cross-blue-shield-of-south-carolina",
   "H8010": "clover-health",
   "H8048": "kinship-pace-of-indiana-llc",
   "H8051": "san-francisco-health-plan",
   "H8067": "provider-partners-health-plans",
   "H8082": "welbehealth",
   "H8093": "georgia-health-advantage",
   "H8095": "wellmark-advantage-health-plan",
   "H8096": "centra-pace",
   "H8099": "senior-community-care-of-northern-kentucky",
   "H8121": "ascension-complete",
   "H8133": "blue-cross-and-blue-shield-of-texas",
   "H8142": "baylor-scott-white-health-plan",
   "H8145": "humana",
   "H8166": "highmark-blue-cross-blue-shield",
   "H8173": "devoted-health",
   "H8176": "molina-healthcare-of-south-carolina",
   "H8181": "blue-cross-and-blue-shield-of-nebraska",
   "H8189": "wellcare",
   "H8211": "unitedhealthcare",
   "H8212": "amerihealth-caritas-vip-care",
   "H8298": "horizon-blue-cross-blue-shield-of-new-jersey",
   "H8320": "devoted-health",
   "H8330": "tufts-health-plan",
   "H8332": "aetna-medicare",
   "H8379": "priority-health-medicare",
   "H8385": "align-powered-by-sanford-health-plan",
   "H8390": "caresource",
   "H8421": "boldage-pace",
   "H8424": "unitypoint-health-pace-senior-care",
   "H8432": "anthem-blue-cross-and-blue-shield-hp",
   "H8457": "longevity-health-plan",
   "H8481": "hmsa-akamai-advantage-dual-care",
   "H8492": "american-health-advantage-of-louisiana",
   "H8547": "blue-cross-and-blue-shield-of-illinois",
   "H8552": "anthem-blue-cross-life-and-health-insurance-company",
   "H8554": "blue-cross-and-blue-shield-of-ok-tx",
   "H8578": "health-new-england-medicare-advantage-plans",
   "H8597": "aetna-medicare",
   "H8604": "the-health-plan",
   "H8614": "pace-your-life",
   "H8634": "blue-cross-and-blue-shield-of-il-nm-ok-tx",
   "H8649": "aetna-medicare",
   "H8655": "innovage-virginia-pace-richmond-and-peninsula",
   "H8711": "wellcare",
   "H8764": "aspire-health",
   "H8768": "unitedhealthcare",
   "H8769": "ascension-living-pace-michigan",
   "H8777": "complete-senior-care",
   "H8794": "kaiser-permanente",
   "H8797": "perennial-advantage",
   "H8800": "total-senior-care-inc",
   "H8811": "myplace-pace",
   "H8832": "alignment-health-plan",
   "H8845": "molina-healthcare-of-arizona",
   "H8849": "wellpoint",
   "H8854": "carefirst-bluecross-blueshield-medicare-advantage-dual-prime",
   "H8879": "healthy-mississippi-inc",
   "H8889": "medica",
   "H8894": "iehp-dualchoice",
   "H8902": "scan",
   "H8908": "humana",
   "H8917": "devoted-health",
   "H8928": "fallon-health",
   "H8947": "peak-health",
   "H8967": "great-plains-medicare-advantage",
   "H8982": "broward-pace-program-llc",
   "H8992": "pace-kc",
   "H9001": "fallon-health",
   "H9003": "kaiser-permanente",
   "H9042": "mytruadvantage",
   "H9047": "providence-medicare-advantage-plans",
   "H9052": "sunrise-pace",
   "H9065": "amh-health",
   "H9066": "nascentia-health-plus",
   "H9068": "albright-care-services",
   "H9096": "dean-advantage",
   "H9147": "blue-cross-and-blue-shield-of-north-carolina",
   "H9153": "west-virginia-senior-advantage",
   "H9179": "trinity-health-plan-of-michigan",
   "H9185": "great-lakes-pace",
   "H9191": "provider-partners-health-plans",
   "H9207": "jefferson-health-plans",
   "H9219": "amh-health",
   "H9231": "devoted-health",
   "H9252": "mount-sinai-eldercare",
   "H9266": "piedmont-health-seniorcare",
   "H9306": "alterwood-advantage",
   "H9314": "aetna-medicare-hide",
   "H9317": "boldage-pace",
   "H9323": "boldage-pace",
   "H9326": "wyoblue-advantage",
   "H9360": "www-cscpace-org",
   "H9364": "wellcare",
   "H9387": "wellcare",
   "H9411": "heritage-pace",
   "H9412": "geisinger-gold",
   "H9431": "aetna-medicare",
   "H9438": "bluestem-pace",
   "H9460": "cigna-healthcare",
   "H9468": "mountain-view-pace",
   "H9485": "mass-general-brigham-health-plan",
   "H9489": "vermont-blue-advantage",
   "H9525": "anthem-blue-cross-and-blue-shield",
   "H9564": "pace4dc-llc",
   "H9572": "blue-cross-blue-shield-of-michigan",
   "H9589": "clear-spring-health",
   "H9590": "longevity-health",
   "H9592": "innovative-integrated-health-inc",
   "H9615": "mvp-health-care",
   "H9616": "san-diego-pace",
   "H9623": "gold-coast-health-plan",
   "H9630": "wellcare-by-allwell",
   "H9649": "hopewest-pace",
   "H9678": "healthfirst-medicare-plan",
   "H9686": "alignment-health-plan",
   "H9690": "american-health-advantage-of-indiana",
   "H9699": "arkansas-blue-medicare",
   "H9700": "devoted-health",
   "H9706": "blue-cross-and-blue-shield-of-texas",
   "H9725": "cigna-healthcare",
   "H9730": "wellcare",
   "H9771": "aetna-medicare-fide",
   "H9802": "devoted-health",
   "H9808": "healthteam-advantage",
   "H9811": "wellcare-by-allwell",
   "H9826": "community-health-choice",
   "H9827": "trinity-health-plan-new-york",
   "H9830": "innovage-pennsylvania-life",
   "H9834": "quartz-medicare-advantage-hmo",
   "H9842": "saint-joseph-pace",
   "H9884": "devoted-health",
   "H9888": "devoted-health",
   "H9904": "mass-advantage",
   "H9907": "tufts-health-plan",
   "H9909": "american-health-advantage-of-ms",
   "H9916": "wellcare",
   "H9917": "align-senior-care",
   "H9942": "longevity-health-plan",
   "H9955": "molina-healthcare-of-ohio",
   "H9968": "american-health-advantage-of-pennsylvania",
   "H9977": "devoted-health",
   "H9986": "florida-complete-care",
   "H9998": "silver-star",
   "R0110": "humana",
   "R0759": "unitedhealthcare",
   "R1532": "humana",
   "R2604": "unitedhealthcare",
   "R3175": "unitedhealthcare",
   "R3444": "unitedhealthcare",
   "R4182": "humana",
   "R5342": "unitedhealthcare",
   "R5361": "humana",
   "R5826": "humana",
   "R5941": "anthem-blue-cross-and-blue-shield",
   "R6694": "aetna-medicare",
   "R6801": "unitedhealthcare",
   "R7220": "humana",
   "R7444": "unitedhealthcare",
   "S0262": "kaiser-permanente",
   "S0375": "carefirst-bluecross-blueshield-group-prescription-drug-plan",
   "S0586": "mvp-health-care",
   "S1030": "bluerx-pdp",
   "S1140": "highmark-blue-cross-blue-shield-or-highmark-blue-shield",
   "S1822": "healthpartners",
   "S2135": "blue-cross-blue-shield-association",
   "S2468": "blue-shield-of-california",
   "S2893": "blue-medicarerx",
   "S3285": "mg-insurance-company",
   "S3389": "upmc-health-plan",
   "S3521": "excellus-health-plan-inc",
   "S3875": "granite-alliance",
   "S3994": "hmsas-medicare-rx-plan",
   "S4501": "pharmacy-benefit-dimensions-pdp",
   "S4802": "wellcare",
   "S4983": "kaiser-permanente",
   "S5450": "bluescripts",
   "S5540": "blue-cross-and-blue-shield-of-north-carolina",
   "S5584": "blue-cross-blue-shield-of-michigan",
   "S5593": "highmark-blue-shield",
   "S5596": "anthem-insurance-companies-inc",
   "S5601": "aetna-medicare",
   "S5609": "asuris-northwest-health",
   "S5617": "cigna-healthcare",
   "S5660": "express-scripts-medicare",
   "S5715": "blue-cross-and-blue-shield-of-il-nm-ok-tx",
   "S5726": "blue-cross-and-blue-shield-of-kansas",
   "S5743": "medicareblue-rx",
   "S5795": "arkansas-blue-medicare",
   "S5805": "unitedhealthcare",
   "S5820": "unitedhealthcare",
   "S5857": "priority-health-medicare",
   "S5877": "emi-health",
   "S5884": "humana",
   "S5904": "florida-blue",
   "S5916": "regence-blueshield-of-idaho-and-regence-bc-bs-utah",
   "S5921": "unitedhealthcare",
   "S5953": "blue-cross-blue-shield-of-south-carolina",
   "S5960": "wellpoint",
   "S5966": "emblemhealth",
   "S5975": "moda-health-plan-inc",
   "S5993": "horizon-blue-cross-blue-shield-of-new-jersey",
   "S6875": "independence-blue-cross",
   "S6939": "mass-general-brigham-health-plan",
   "S8067": "avalon-insurance-company",
   "S8841": "optum-insurance-of-ohio-inc",
   "S9701": "navitus-medicarerx"
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
  "comment": "Crosswalk from admin-tool benefit names (one row per covered benefit per PBP) to Hub taxonomy card keys. The card's PBP gate still decides whether anything renders. SSBCI is split into one row per sub-benefit (ssbci_<item>) routing to that item's section on the socialSupports card — never lumped onto OTC.",
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
   "wigs_for_hair_loss": {
    "card": "wigs"
   },
   "dental": {
    "card": "dental"
   },
   "fitness": {
    "card": "fitness"
   },
   "otc": {
    "card": "otc",
    "note": "Plain OTC (13b) only. SSBCI sub-benefits are separate rows below."
   },
   "ssbci_food_produce": {
    "card": "socialSupports",
    "ssbciItem": "food_produce",
    "note": "Routes the how-to/vendor blob to the food_produce section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_meals": {
    "card": "socialSupports",
    "ssbciItem": "meals",
    "note": "Routes the how-to/vendor blob to the meals section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_transportation": {
    "card": "socialSupports",
    "ssbciItem": "transportation",
    "note": "Routes the how-to/vendor blob to the transportation section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_pest_control": {
    "card": "socialSupports",
    "ssbciItem": "pest_control",
    "note": "Routes the how-to/vendor blob to the pest_control section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_indoor_air_quality": {
    "card": "socialSupports",
    "ssbciItem": "indoor_air_quality",
    "note": "Routes the how-to/vendor blob to the indoor_air_quality section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_social_needs": {
    "card": "socialSupports",
    "ssbciItem": "social_needs",
    "note": "Routes the how-to/vendor blob to the social_needs section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_home_modifications": {
    "card": "socialSupports",
    "ssbciItem": "home_modifications",
    "note": "Routes the how-to/vendor blob to the home_modifications section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_self_directed": {
    "card": "socialSupports",
    "ssbciItem": "self_directed",
    "note": "Routes the how-to/vendor blob to the self_directed section of the SSBCI card (eligibility-gated)."
   },
   "ssbci_complementary_therapies": {
    "card": "socialSupports",
    "ssbciItem": "complementary_therapies",
    "note": "Routes the how-to/vendor blob to the complementary_therapies section of the SSBCI card (eligibility-gated)."
   }
  }
 },
 "eocCommon": {
  "$schema": "duos-eoc-common/v1",
  "description": "Benefit card keys whose key member facts routinely live only in the EOC/SB (not the PBP filing). Drives the soft 'check for EOC facts' nudge on the authoring board. Extend as patterns emerge.",
  "benefits": [
   "meals",
   "transportation",
   "socialSupports",
   "pers"
  ]
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
       "highlight": true,
       "plusSlot": "acupuncture_supplemental.coinsurance"
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
       "highlight": true,
       "plusSlot": "chiropractic.coinsurance"
      },
      {
       "label": "Visits included",
       "slot": "chiropractic.visit_limit",
       "suffix": " {chiropractic.visit_limit_period}"
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
       "plusSlot": "dental_medicare.coinsurance"
      },
      {
       "forEach": "dental_preventive.sub_types",
       "label": "{item.label}",
       "slot": "item.copay",
       "plusSlot": "item.coinsurance"
      },
      {
       "forEach": "dental_preventive.sub_types",
       "label": "{item.label} included",
       "slot": "item.visit_limit",
       "suffix": " {item.visit_limit_period}"
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
       "plusSlot": "item.coinsurance"
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
       "highlight": true,
       "plusSlot": "dme.coinsurance"
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
       "plusSlot": "prosthetics.coinsurance"
      },
      {
       "label": "Medical supplies",
       "slot": "medical_supplies.copay",
       "plusSlot": "medical_supplies.coinsurance"
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
       "plusSlot": "primary_care.coinsurance",
       "highlight": true
      },
      {
       "label": "Specialist visit",
       "slot": "specialist.copay",
       "plusSlot": "specialist.coinsurance"
      },
      {
       "label": "Specialist referral required",
       "slot": "specialist.referral_required"
      },
      {
       "label": "Telehealth visit",
       "slot": "telehealth.copay",
       "plusSlot": "telehealth.coinsurance"
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
       "plusSlot": "emergency_care.coinsurance"
      },
      {
       "label": "Urgent care",
       "slot": "urgent_care.copay",
       "plusSlot": "urgent_care.coinsurance"
      },
      {
       "label": "Emergency care while traveling abroad",
       "slot": "worldwide_emergency.copay_emergency",
       "plusSlot": "worldwide_emergency.coinsurance_emergency"
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
       "plusSlot": "fitness.coinsurance",
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
   "mixedWalletNote": "{ssbciBenefitName} is available to members with a qualifying health condition.",
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
   "tileSubtitle": "{hearing_exams.copay} exam · hearing aids covered",
   "sections": [
    {
     "icon": "hearing",
     "label": "Hearing Coverage",
     "facts": [
      {
       "label": "Routine hearing exam",
       "slot": "hearing_exams.copay",
       "plusSlot": "hearing_exams.coinsurance"
      },
      {
       "label": "Hearing aid fittings included",
       "slot": "hearing_exams.fitting_visit_limit",
       "suffix": " {hearing_exams.fitting_visit_limit_period}"
      },
      {
       "label": "Hearing aids",
       "slot": "hearing_aids.copay",
       "plusSlot": "hearing_aids.coinsurance",
       "suffix": "copay per aid (varies by model)"
      },
      {
       "label": "Plan pays up to",
       "slot": "hearing_aids.max_plan_benefit",
       "suffix": " {hearing_aids.max_plan_benefit_scope}",
       "highlight": true
      },
      {
       "label": "Hearing aids included",
       "slot": "hearing_aids.visit_limit",
       "suffix": " {hearing_aids.visit_limit_period}"
      },
      {
       "label": "Over-the-counter hearing aids",
       "slot": "otc_hearing_aids.max_plan_benefit",
       "prefix": "Up to "
      },
      {
       "label": "OTC hearing aids included",
       "slot": "otc_hearing_aids.visit_limit",
       "suffix": " {otc_hearing_aids.visit_limit_period}"
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
       "highlight": true,
       "plusSlot": "home_health.coinsurance"
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
       "plusSlot": "meals.coinsurance"
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
       "highlight": true,
       "plusSlot": "mental_health_outpatient.coinsurance_individual"
      },
      {
       "label": "Therapy visit (group)",
       "slot": "mental_health_outpatient.copay_group",
       "plusSlot": "mental_health_outpatient.coinsurance_group"
      },
      {
       "label": "Psychiatrist visit",
       "slot": "mental_health_specialist.copay_individual",
       "plusSlot": "mental_health_specialist.coinsurance_individual"
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
   "tagline": "Your over-the-counter allowance for health products",
   "tileSubtitle": "Over-the-counter allowance",
   "combinedConditionalNote": "If you qualify for {ssbciBenefitName}, your OTC allowance combines with it — up to {combinedAmount} {combinedPeriod}.",
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
      },
      {
       "label": "How to use it",
       "slot": "otc_items.otc_delivery_mode"
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
       "highlight": true,
       "plusSlot": "physical_speech_therapy.coinsurance"
      },
      {
       "label": "Occupational therapy visit",
       "slot": "occupational_therapy.copay",
       "plusSlot": "occupational_therapy.coinsurance"
      },
      {
       "label": "Outpatient rehabilitation services",
       "slot": "outpatient_rehabilitation.copay",
       "plusSlot": "outpatient_rehabilitation.coinsurance"
      },
      {
       "label": "Prior authorization",
       "slot": "physical_speech_therapy.prior_auth_required"
      }
     ]
    },
    {
     "icon": "ecg_heart",
     "label": "Cardiac Rehabilitation",
     "facts": [
      {
       "label": "Your cost per visit",
       "slot": "cardiac_rehab.copay",
       "highlight": true,
       "plusSlot": "cardiac_rehab.coinsurance"
      },
      {
       "label": "Referral required",
       "slot": "cardiac_rehab.referral_required"
      },
      {
       "label": "Prior authorization",
       "slot": "cardiac_rehab.prior_auth_required"
      },
      {
       "forEach": "cardiac_rehab.sub_type_limits",
       "label": "{item.label}",
       "slot": "item.visit_limit",
       "suffix": " {item.visit_limit_period}"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Therapy after surgery, a fall, or a stroke is one of the strongest predictors of getting back to normal life — don't skip sessions."
    },
    {
     "icon": "ecg_heart",
     "text": "Cardiac rehab combines supervised exercise, education, and support to help your heart recover and lower the risk of another cardiac event."
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
  "podiatry": {
   "$schema": "duos-benefit-content/v1",
   "key": "podiatry",
   "title": "Podiatry (Foot Care)",
   "icon": "foot_bones",
   "iconBg": "#EFF6FF",
   "iconColor": "#1D4ED8",
   "barColor": "#1D4ED8",
   "tagline": "Foot and ankle care covered by your plan",
   "tileSubtitle": "Foot care covered",
   "sections": [
    {
     "icon": "foot_bones",
     "label": "Podiatry Care",
     "facts": [
      {
       "label": "Your cost per visit",
       "slot": "podiatry.copay",
       "highlight": true,
       "plusSlot": "podiatry.coinsurance"
      },
      {
       "label": "Routine visits included",
       "slot": "podiatry.visit_limit",
       "suffix": " {podiatry.visit_limit_period}"
      },
      {
       "label": "Referral required",
       "slot": "podiatry.referral_required"
      },
      {
       "label": "Prior authorization",
       "slot": "podiatry.prior_auth_required"
      }
     ]
    }
   ],
   "connections": [
    {
     "icon": "lightbulb",
     "text": "Healthy feet matter for staying mobile and independent — regular foot checks are especially important if you live with diabetes or circulation problems, since small issues can go unnoticed."
    }
   ]
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
      },
      {
       "forEach": "additional_preventive.sub_types",
       "label": "{item.label} included",
       "slot": "item.visit_limit",
       "suffix": " {item.visit_limit_period}"
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
     "forEach": "social_supports.items",
     "label": "{item.label}",
     "facts": [
      {
       "label": "Your cost",
       "slot": "item.copay",
       "highlight": true,
       "plusSlot": "item.coinsurance"
      },
      {
       "label": "Plan pays up to",
       "slot": "item.max_plan_benefit",
       "suffix": " {item.max_plan_benefit_period}",
       "pooledNote": "Included in your combined allowance"
      },
      {
       "label": "Ways to travel",
       "slot": "item.transport_modes"
      },
      {
       "label": "Trip type",
       "slot": "item.trip_type"
      },
      {
       "label": "Prior authorization",
       "slot": "item.prior_auth_required"
      }
     ]
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
       "plusSlot": "transportation.coinsurance",
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
   "tagline": "Routine eye exams and an eyewear allowance",
   "tileSubtitle": "{eye_exams.copay} exam · {eyewear.max_plan_benefit} eyewear",
   "sections": [
    {
     "icon": "visibility",
     "label": "Vision Coverage",
     "facts": [
      {
       "label": "Routine eye exam",
       "slot": "eye_exams.copay",
       "plusSlot": "eye_exams.coinsurance"
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
       "label": "Glasses included",
       "slot": "eyewear.glasses_quantity_limit",
       "suffix": " {eyewear.glasses_quantity_limit_period}"
      },
      {
       "label": "Contacts copay",
       "slot": "eyewear.contacts_copay"
      },
      {
       "label": "Contacts included",
       "slot": "eyewear.contacts_quantity_limit",
       "suffix": " {eyewear.contacts_quantity_limit_period}"
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
    "note": "Hearing aids are TruHearing-branded Advanced models through TruHearing providers — there is no out-of-network coverage for hearing aids.",
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
