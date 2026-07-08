#!/usr/bin/env python3
"""
Medicare Advantage Benefits Dashboard - Data Preprocessor

Reads all 75 CMS PBP benefit data files (.txt, tab-delimited) from pbp-benefits-2026/
and generates optimized JSON for the web dashboard.

Usage:
    python pipeline/preprocess.py
    (override raw/out dirs via PBP_RAW_DIR / PBP_OUT_DIR env vars if needed)

Output:
    data/states.json          - State/county dropdown data
    data/geo_index.json       - Geographic lookup {state: {county: [plan_ids]}}
    data/plans_summary.json   - All plans headline info (loaded on startup)
    data/plans/{plan_id}.json - Per-plan detailed benefit data (loaded on demand)
"""

import json
import os
import re
import sys
from collections import defaultdict
from pathlib import Path

import pandas as pd

# ---------------------------------------------------------------------------
# Paths
#
# Both are overridable via env vars so the pipeline can run from any checkout:
#   PBP_RAW_DIR - where the raw CMS PBP .txt files live (259MB, never committed)
#   PBP_OUT_DIR - where generated data/ (plans/, plans_summary.json, etc.) goes
#
# Defaults:
#   raw = this repo's own pipeline/pbp-benefits-2026/ (committed in-repo;
#         PlanArea ships gzipped to stay under GitHub's 100MB file limit)
#   out = this repo's own data/ dir, resolved relative to this script so it
#         works regardless of the caller's current working directory
# ---------------------------------------------------------------------------
_DEFAULT_RAW_DIR = str(Path(__file__).resolve().parent / "pbp-benefits-2026")
BASE_DIR = Path(os.environ.get("PBP_RAW_DIR", _DEFAULT_RAW_DIR)).resolve()
OUT_DIR = Path(os.environ.get("PBP_OUT_DIR", str(Path(__file__).resolve().parent.parent / "data"))).resolve()
PLANS_DIR = OUT_DIR / "plans"

# ---------------------------------------------------------------------------
# Code translation maps
# ---------------------------------------------------------------------------
PLAN_TYPE_MAP = {
    "01": "HMO", "1": "HMO",
    "02": "HMO-POS", "2": "HMO-POS",
    "04": "Local PPO", "4": "Local PPO",
    "05": "PSO", "5": "PSO",
    "07": "MSA", "7": "MSA",
    "08": "RFB PFFS", "8": "RFB PFFS",
    "09": "PFFS", "9": "PFFS",
    "18": "1876 Cost",
    "19": "HCPP Cost",
    "20": "PACE",
    "29": "PDP",
    "30": "Employer PDP",
    "31": "Regional PPO",
    "32": "Fallback",
    "40": "Employer PFFS",
    "42": "RFB HMO",
    "43": "RFB HMO-POS",
    "44": "RFB Local PPO",
    "45": "RFB PSO",
    "47": "Employer PPO",
}

SNP_TYPE_MAP = {
    # CMS pbp_a_special_need_plan_type codes:
    # 1 = Institutional, 2 = Institutional-Equivalent (both I-SNP),
    # 3 = Dual Eligible (D-SNP), 4 = Chronic/Disabling Condition (C-SNP)
    "1": "I-SNP", "2": "I-SNP", "3": "D-SNP", "4": "C-SNP",
}

# PBP service-category codes -> human-readable names (from CMS Bid Reports
# "Service Category Report"). Used to label combined-benefit / VBID NMC category codes.
SERVICE_CATEGORY_MAP = {
    "1a": "Inpatient Hospital - Acute", "1b": "Inpatient Hospital - Psychiatric",
    "2": "Skilled Nursing Facility", "3": "Cardiac & Pulmonary Rehabilitation",
    "4a": "Emergency Services", "4b": "Urgently Needed Services",
    "4c": "Worldwide Emergency/Urgent Coverage", "5a": "Partial Hospitalization",
    "5b": "Intensive Outpatient Program", "6": "Home Health Services",
    "7a": "Primary Care Physician Services", "7b": "Chiropractic Services",
    "7c": "Occupational Therapy Services", "7d": "Physician Specialist Services",
    "7e": "Mental Health Specialty Services", "7f": "Podiatry Services",
    "7g": "Other Health Care Professional Services", "7h": "Psychiatric Services",
    "7i": "Physical Therapy & Speech-Language Pathology", "7j": "Additional Telehealth Benefits",
    "7k": "Opioid Treatment Program Services",
    "8a": "Outpatient Diagnostic Procedures, Tests & Lab Services",
    "8b": "Outpatient Diagnostic & Therapeutic Radiological Services",
    "9a": "Outpatient Hospital Services", "9b": "Ambulatory Surgical Center (ASC) Services",
    "9c": "Outpatient Substance Abuse Services", "9d": "Outpatient Blood Services",
    "10a": "Ambulance Services", "10b": "Transportation Services",
    "11a": "Durable Medical Equipment (DME)", "11b": "Prosthetics/Medical Supplies",
    "11c": "Diabetic Supplies & Services / Therapeutic Shoes", "12": "Dialysis Services",
    "13a": "Acupuncture Treatments", "13b": "Over-the-Counter (OTC) Items",
    "13c": "Meal Benefit", "13d": "Other Supplemental 1", "13e": "Other Supplemental 2",
    "13f": "Other Supplemental 3", "13g": "D-SNP Highly Integrated Services",
    "13h": "Additional Services",
    "13i": "Non-Primarily Health Related Benefits for the Chronically Ill (SSBCI)",
    "14a": "Medicare-Covered Zero Cost-Sharing Preventive Services",
    "14b": "Annual Physical Exam", "14c": "Other Defined Supplemental Benefits",
    "14d": "Kidney Disease Education Services", "14e": "Other Medicare-Covered Preventive Services",
    "15": "Medicare Part B Rx & Home Infusion Drugs", "16a": "Medicare Dental Services",
    "16b": "Diagnostic & Preventive Dental Services",
    "16b1": "Oral Exams", "16b2": "Dental X-Rays", "16b3": "Other Diagnostic Dental Services",
    "16b4": "Prophylaxis (Cleaning)", "16b5": "Fluoride Treatment", "16b6": "Other Preventive Dental Services",
    "16c": "Comprehensive Dental Services",
    "16c1": "Restorative Services", "16c2": "Endodontics", "16c3": "Periodontics",
    "16c4": "Prosthodontics, Removable", "16c5": "Maxillofacial Prosthetics",
    "16c6": "Implant Services", "16c7": "Prosthodontics, Fixed",
    "16c8": "Oral & Maxillofacial Surgery", "16c9": "Orthodontics",
    "16c10": "Adjunctive General Services",
    "17a": "Eye Exams", "17b": "Eyewear", "18a": "Hearing Exams",
    "18b": "Prescription Hearing Aids", "18c": "OTC Hearing Aids",
    "19a": "Reduced Cost Sharing (VBID/UF/SSBCI)", "19b": "Additional Benefits (VBID/UF/SSBCI)",
    "20": "Outpatient/Prescription Drugs (Cost Plans)",
}


def label_category(code):
    """Map a PBP service-category code to 'Name (code)'. Falls back to the base
    letter-category (e.g. 13i3 -> 13i) when an exact sub-code isn't listed."""
    code = (code or "").strip()
    if not code:
        return code
    name = SERVICE_CATEGORY_MAP.get(code)
    if not name:
        m = re.match(r"^(\d+[a-z])", code)  # base like 13i, 10b, 14c
        if m:
            name = SERVICE_CATEGORY_MAP.get(m.group(1))
    if not name:
        m = re.match(r"^(\d+)", code)  # pure-numeric base like 12, 2, 6
        if m:
            name = SERVICE_CATEGORY_MAP.get(m.group(1))
    return f"{name} ({code})" if name else code


DSNP_TYPE_MAP = {
    "1": "FIDE-SNP", "2": "HIDE-SNP", "3": "AIE-SNP",
    "4": "Coordination-only", "5": "AIP", "6": "Other",
}

AUTH_MAP = {
    # CMS PBP auth_yn / refer_yn fields are binary: across all 112 such fields in
    # the dataset, only "1" and "2" ever appear (no "3"). "1" = Yes, "2" = No.
    "1": "Yes", "2": "No",
}

BENEFIT_TYPE_MAP = {
    "2": "Mandatory", "3": "Optional", "4": "Both",
}

PERIODICITY_MAP = {
    "1": "Every 3 years", "2": "Every 2 years", "3": "Every year",
    "4": "Every 6 months", "5": "Every 3 months", "6": "Other",
    "7": "Every month", "8": "Every benefit period", "9": "Every stay",
}

DEDUCTIBLE_TYPE_MAP = {
    "1": "Medicare-defined Part A deductible",
    "2": "Medicare-defined Part B deductible",
    "3": "Medicare-defined Part A + Part B deductibles combined",
    "4": "Plan-specified amount",
}

# Section D files no dollar amount for deductible types 1-3, so Medicare-defined
# display values come from the CMS standard amounts for the plan year.
DEDUCTIBLE_TYPE_AMOUNTS = {"2": "$257"}  # 2026 Part B deductible

TRIP_TYPE_MAP = {
    "1": "One-way", "2": "Round Trip", "3": "Hours", "4": "Days", "5": "Other",
}

# pbp_b18b_maxplan_perear is an ENUM qualifying the hearing-aid maximum plan
# benefit coverage amount (dictionary "Select Coverage": 1/2/3), NOT a dollar
# value. Rendering it with to_dollar produced "$1"/"$2"/"$3" per-ear amounts.
HEARING_MAXPLAN_SCOPE_MAP = {
    "1": "per ear", "2": "one single ear", "3": "both ears combined",
}

# pbp_b13c_meal_type_chk (3-char flag) — the situations the meal benefit covers.
# Order matches the CMS positions: 1 = homebound, 2 = post-discharge, 3 = chronic.
MEAL_TYPE_LABELS = [
    "when a health condition keeps you at home",
    "after surgery or a hospital stay",
    "for a chronic illness",
]

# Label-only stub policy (data-sanity sweep check #5): a SUPPLEMENTAL benefit
# dict whose only content is its label (and/or auth/referral flags) means the
# plan filed nothing substantive for that section, so the benefit is not
# actually offered. Such keys are dropped in build_plan_detail — except for
# PACE plans, which legitimately file label-only benefits (PACE files no PBP
# cost-share detail). Mandatory MA benefits (urgent care, ER, ambulance …) are
# NOT in the drop list: they are covered even when filed with no cost detail.
LABEL_STUB_KEYS = {"label", "prior_auth_required", "referral_required"}
SUPPLEMENTAL_STUB_KEYS = {
    "transportation", "meals", "otc_items", "dental_preventive",
    "dental_comprehensive", "dental_medicare", "hearing_aids", "telehealth",
    "additional_preventive",
}

TRANSPORT_MODE_LABELS = [
    "Other", "Taxi", "Rideshare Services", "Bus/Subway", "Van", "Medical Transport",
]

# pbp_b13b_mode is a 5-position bitmask (dictionary "X in N" code map):
# 1=Other, 2=Catalogue Purchase, 3=Claims Processing, 4=Debit Card,
# 5=Reimbursement. Same decode shape as TRANSPORT_MODE_LABELS/decode_transport_modes.
OTC_MODE_LABELS = [
    "Other", "Catalogue Purchase", "Claims Processing", "Debit Card", "Reimbursement",
]

COST_SHARE_TYPE_MAP = {
    "1": "Coinsurance", "2": "Copayment", "3": "Coinsurance + Copayment",
}

SNP_CHRONIC_MAP = {
    "1": "Diabetes", "2": "CHF", "3": "CVD", "4": "Chronic Lung",
    "5": "Dementia", "6": "Severe Mental Health", "7": "HIV/AIDS",
    "8": "Chronic Kidney Disease", "9": "Autoimmune", "10": "Cancer",
    "11": "End-Stage Liver", "12": "End-Stage Renal", "13": "Stroke",
    "14": "Substance Use Disorder", "15": "Obesity",
    "16": "Severe Hematological", "17": "Heart Failure",
    "18": "Alcohol Use Disorder",
}

ORG_TYPE_MAP = {
    "01": "HMO", "1": "HMO",
    "08": "Employer Group", "8": "Employer Group",
    "13": "Other",
}

STATE_NAMES = {
    "AL": "Alabama", "AK": "Alaska", "AZ": "Arizona", "AR": "Arkansas",
    "CA": "California", "CO": "Colorado", "CT": "Connecticut", "DE": "Delaware",
    "DC": "District of Columbia", "FL": "Florida", "GA": "Georgia", "HI": "Hawaii",
    "ID": "Idaho", "IL": "Illinois", "IN": "Indiana", "IA": "Iowa",
    "KS": "Kansas", "KY": "Kentucky", "LA": "Louisiana", "ME": "Maine",
    "MD": "Maryland", "MA": "Massachusetts", "MI": "Michigan", "MN": "Minnesota",
    "MS": "Mississippi", "MO": "Missouri", "MT": "Montana", "NE": "Nebraska",
    "NV": "Nevada", "NH": "New Hampshire", "NJ": "New Jersey", "NM": "New Mexico",
    "NY": "New York", "NC": "North Carolina", "ND": "North Dakota", "OH": "Ohio",
    "OK": "Oklahoma", "OR": "Oregon", "PA": "Pennsylvania", "RI": "Rhode Island",
    "SC": "South Carolina", "SD": "South Dakota", "TN": "Tennessee", "TX": "Texas",
    "UT": "Utah", "VT": "Vermont", "VA": "Virginia", "WA": "Washington",
    "WV": "West Virginia", "WI": "Wisconsin", "WY": "Wyoming",
    "AS": "American Samoa", "GU": "Guam", "MP": "Northern Mariana Islands",
    "PR": "Puerto Rico", "VI": "US Virgin Islands",
}

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def yn(val):
    """Convert CMS yes/no codes: 1=Yes, 2=No, else None."""
    if val == "1":
        return True
    if val == "2":
        return False
    return None


def to_float(val):
    """Convert a string to float, returning None on failure."""
    if pd.isna(val) or val == "" or val is None:
        return None
    try:
        return float(val)
    except (ValueError, TypeError):
        return None


def to_dollar(val):
    """Format a numeric value as a dollar string."""
    f = to_float(val)
    if f is None:
        return None
    if f == int(f):
        return f"${int(f)}"
    return f"${f:,.2f}"


def to_pct(val):
    """Format a numeric value as a percentage string."""
    f = to_float(val)
    if f is None:
        return None
    if f == int(f):
        return f"{int(f)}%"
    return f"{f:.1f}%"


def dollar_range(min_val, max_val):
    """Format a min/max dollar range."""
    mn = to_dollar(min_val)
    mx = to_dollar(max_val)
    if mn is None and mx is None:
        return None
    if mn == mx or mx is None:
        return mn
    if mn is None:
        return mx
    return f"{mn} - {mx}"


def pct_range(min_val, max_val):
    """Format a min/max percentage range."""
    mn = to_pct(min_val)
    mx = to_pct(max_val)
    if mn is None and mx is None:
        return None
    if mn == mx or mx is None:
        return mn
    if mn is None:
        return mx
    return f"{mn} - {mx}"


def safe_get(row, col):
    """Safely get a value from a row, returning empty string for missing."""
    val = row.get(col, "")
    if pd.isna(val):
        return ""
    return str(val).strip()


def make_plan_id(row):
    """Create a plan_id from standard key columns."""
    h = safe_get(row, "pbp_a_hnumber")
    p = safe_get(row, "pbp_a_plan_identifier")
    s = safe_get(row, "segment_id")
    return f"{h}_{p}_{s}"


def read_txt(filename, usecols=None):
    """Read a tab-delimited CMS file, all columns as strings."""
    path = BASE_DIR / filename
    if not path.exists():
        print(f"  WARNING: {filename} not found, skipping.")
        return pd.DataFrame()
    try:
        df = pd.read_csv(path, sep="\t", dtype=str, na_values=[""], keep_default_na=True,
                         usecols=usecols, low_memory=False, encoding="latin-1")
        df = df.fillna("")
        return df
    except Exception as e:
        print(f"  ERROR reading {filename}: {e}")
        return pd.DataFrame()


def clean_dict(d):
    """Remove keys with None values from a dict for smaller JSON."""
    return {k: v for k, v in d.items() if v is not None}


# ---------------------------------------------------------------------------
# Transport-specific helpers
# ---------------------------------------------------------------------------

def decode_transport_modes(bitmask, desc_other=None):
    """Decode a 6-character transport mode bitmask to a comma-separated string.

    Each position is '1' if selected, '0' or '2' if not.
    Position 1=Other, 2=Taxi, 3=Rideshare, 4=Bus/Subway, 5=Van, 6=Medical Transport.
    """
    if not bitmask or len(bitmask) < 6:
        return None
    modes = []
    for i, label in enumerate(TRANSPORT_MODE_LABELS):
        if i < len(bitmask) and bitmask[i] == "1":
            if label == "Other" and desc_other:
                modes.append(f"Other ({desc_other})")
            else:
                modes.append(label)
    return ", ".join(modes) if modes else None


def decode_otc_mode(bitmask, desc_other=None):
    """Decode the 5-character pbp_b13b_mode OTC delivery-mode bitmask to a
    comma-separated member-readable string. Same shape as decode_transport_modes:
    each position is '1' if selected. Position 1=Other, 2=Catalogue Purchase,
    3=Claims Processing, 4=Debit Card, 5=Reimbursement.
    """
    if not bitmask or len(bitmask) < 5:
        return None
    modes = []
    for i, label in enumerate(OTC_MODE_LABELS):
        if i < len(bitmask) and bitmask[i] == "1":
            if label == "Other" and desc_other:
                modes.append(f"Other ({desc_other})")
            else:
                modes.append(label)
    return ", ".join(modes) if modes else None


def extract_transport_details(row, prefix):
    """Extract transport-specific fields using _pal / _al suffixes.

    CMS transport benefits use _pal (Plan Approved Location) or _al (Any Location)
    field suffixes rather than the standard _lim_yn / _numv pattern.
    These are mutually exclusive: trn=1 populates _pal, trn=2 populates _al.
    Output uses generic key names (trip_type, transport_modes, etc.).
    """
    result = {}

    trn = safe_get(row, f"{prefix}_bendesc_trn")
    if trn == "1":
        result["transport_location"] = "Plan Approved Location"
        suffix = "_pal"
    elif trn == "2":
        result["transport_location"] = "Any Location"
        suffix = "_al"
    else:
        return None

    # Trip limit: 1=Unlimited, 2=Limited
    lim = safe_get(row, f"{prefix}_bendesc_lim{suffix}")
    if lim == "1":
        result["unlimited"] = True
    elif lim == "2":
        amt = safe_get(row, f"{prefix}_bendesc_amt{suffix}")
        # A "limited" flag with a 0/blank count is a source quirk (no numeric cap
        # was actually filed). Don't render a misleading "0 trips".
        if amt and amt not in ("0", "0.00"):
            result["trip_limit"] = amt
            per = safe_get(row, f"{prefix}_bendesc_per{suffix}")
            if per:
                result["trip_limit_period"] = PERIODICITY_MAP.get(per, per)

    # Trip type
    tt = safe_get(row, f"{prefix}_bendesc_tt{suffix}")
    if tt:
        tt_text = TRIP_TYPE_MAP.get(tt, tt)
        tt_desc = safe_get(row, f"{prefix}_bendesc_tt{suffix}_d")
        if tt == "5":
            if tt_desc:
                tt_text = f"Other ({tt_desc})"
        result["trip_type"] = tt_text
        if tt == "4":
            days = safe_get(row, f"{prefix}_bendesc_amt{suffix}_days")
            if days:
                result["trip_days"] = days
        # Free-text trip description filed alongside the trip type (additive; only
        # present when CMS filers supply narrative detail, e.g. for "Other" trip types).
        if tt_desc and tt_desc.strip():
            result["trip_description"] = tt_desc.strip()

    # Transport modes (6-char bitmask)
    mt = safe_get(row, f"{prefix}_bendesc_mt{suffix}")
    if mt:
        mt_desc = safe_get(row, f"{prefix}_bendesc_mt{suffix}_d")
        modes = decode_transport_modes(mt, mt_desc)
        if modes:
            result["transport_modes"] = modes

    return result if len(result) > 1 else None


# ---------------------------------------------------------------------------
# Benefit extraction helpers
# ---------------------------------------------------------------------------

def extract_simple_benefit(row, prefix, label):
    """Extract a standard benefit sub-section with copay/coinsurance/deductible."""
    result = {"label": label}
    copay_yn = yn(safe_get(row, f"{prefix}_copay_yn"))
    if copay_yn:
        result["copay"] = dollar_range(
            safe_get(row, f"{prefix}_copay_amt_mc_min") or safe_get(row, f"{prefix}_copay_mc_amt_min") or safe_get(row, f"{prefix}_copay_mc_amt") or safe_get(row, f"{prefix}_copay_mcmin_amt") or safe_get(row, f"{prefix}_copay_mc_min_amt") or safe_get(row, f"{prefix}_copay_min_dmc_amt") or safe_get(row, f"{prefix}_copay_ohs_amt_min") or safe_get(row, f"{prefix}_copay_gas_amt_min") or safe_get(row, f"{prefix}_copay_amt_mc_min_crs"),
            safe_get(row, f"{prefix}_copay_amt_mc_max") or safe_get(row, f"{prefix}_copay_mc_amt_max") or safe_get(row, f"{prefix}_copay_mc_max_amt") or safe_get(row, f"{prefix}_copay_mcmax_amt") or safe_get(row, f"{prefix}_copay_max_dmc_amt") or safe_get(row, f"{prefix}_copay_ohs_amt_max") or safe_get(row, f"{prefix}_copay_gas_amt_max") or safe_get(row, f"{prefix}_copay_amt_mc_max_crs"),
        )
    coins_yn = yn(safe_get(row, f"{prefix}_coins_yn"))
    if coins_yn:
        result["coinsurance"] = pct_range(
            safe_get(row, f"{prefix}_coins_pct_mc_min") or safe_get(row, f"{prefix}_coins_pct_mc") or safe_get(row, f"{prefix}_coins_pct_mcmin") or safe_get(row, f"{prefix}_coins_mc_min_pct") or safe_get(row, f"{prefix}_coins_pct_dmc") or safe_get(row, f"{prefix}_coins_pct_tmc") or safe_get(row, f"{prefix}_coins_ohs_pct_min") or safe_get(row, f"{prefix}_coins_gas_pct_min") or safe_get(row, f"{prefix}_coins_pct_mc_min_crs"),
            safe_get(row, f"{prefix}_coins_pct_mc_max") or safe_get(row, f"{prefix}_coins_max_pct_mc") or safe_get(row, f"{prefix}_coins_pct_mcmax") or safe_get(row, f"{prefix}_coins_mc_max_pct") or safe_get(row, f"{prefix}_coins_pct_dmc_max") or safe_get(row, f"{prefix}_coins_pct_tmc_max") or safe_get(row, f"{prefix}_coins_ohs_pct_max") or safe_get(row, f"{prefix}_coins_gas_pct_max") or safe_get(row, f"{prefix}_coins_pct_mc_max_crs"),
        )
    # Both cost-share flags explicitly "No" = the plan filed no copay and no
    # coinsurance for this benefit → it's $0 to the member. Without this the
    # card renders no cost and looks empty (sparse-card fix).
    if copay_yn is False and coins_yn is False and not result.get("copay") and not result.get("coinsurance"):
        result["copay"] = "$0"
    ded = yn(safe_get(row, f"{prefix}_ded_yn"))
    if ded is not None:
        result["deductible_applies"] = ded
        ded_amt = to_dollar(safe_get(row, f"{prefix}_ded_amt"))
        if ded_amt:
            result["deductible_amount"] = ded_amt
    auth = yn(safe_get(row, f"{prefix}_auth_yn") or safe_get(row, f"{prefix}_auth_ohs_yn"))
    if auth is not None:
        result["prior_auth_required"] = auth
    refer = yn(safe_get(row, f"{prefix}_refer_yn") or safe_get(row, f"{prefix}_refer_ohs_yn"))
    if refer is not None:
        result["referral_required"] = refer
    maxenr = yn(safe_get(row, f"{prefix}_maxenr_yn"))
    if maxenr:
        result["max_enrollee_cost"] = to_dollar(safe_get(row, f"{prefix}_maxenr_amt"))
    maxplan = yn(safe_get(row, f"{prefix}_maxplan_yn"))
    if maxplan:
        result["max_plan_benefit"] = to_dollar(safe_get(row, f"{prefix}_maxplan_amt"))
    return clean_dict(result)


def extract_oon_inpatient_group(row, label, fam):
    """Extract OON inpatient/SNF cost-sharing from the main Section C row.

    Categories 1a (fam=iha), 1b (iph), and 2 (snf) are filed as pbp_c_oon_* column
    families on Section C itself, not in the per-category OON file (which starts
    at category 3). iha/iph copays are per stay (_ps_amt) or day intervals; snf
    uses _amt plus day intervals. Interval structures are flattened to display
    strings to match the flat copay/coinsurance keys of the other OON groups.
    """
    grp = {"label": label}

    # SNF has explicit yn gates; iha/iph presence is signalled by data.
    def fam_cost_share(kind, flat_col, val_fmt):
        if fam == "snf" and yn(safe_get(row, f"pbp_c_oon_{kind}_snf_yn")) is not True:
            return None
        if yn(safe_get(row, f"pbp_c_oon_{kind}_{fam}_mc_cost_yn")):
            return "Medicare-defined cost sharing"
        val_col = "amt" if kind == "copay" else "pct"
        intervals = []
        for i in range(1, 4):
            val = val_fmt(safe_get(row, f"pbp_c_oon_{kind}_{fam}_{val_col}_i{i}"))
            bgn = safe_get(row, f"pbp_c_oon_{kind}_{fam}_bgnd_i{i}")
            end = safe_get(row, f"pbp_c_oon_{kind}_{fam}_endd_i{i}")
            if val is not None and bgn:
                intervals.append(f"{val} (days {bgn}-{end or '+'})")
        if intervals:
            return ", ".join(intervals)
        flat = val_fmt(safe_get(row, flat_col))
        if flat is not None:
            return f"{flat} per stay" if kind == "copay" else flat
        return None

    copay_flat_col = f"pbp_c_oon_copay_{fam}_ps_amt" if fam != "snf" else "pbp_c_oon_copay_snf_amt"
    copay = fam_cost_share("copay", copay_flat_col, to_dollar)
    if copay:
        grp["copay"] = copay
    coins = fam_cost_share("coins", f"pbp_c_oon_coins_{fam}_pct", to_pct)
    if coins:
        grp["coinsurance"] = coins

    return grp if len(grp) > 1 else None


def extract_b8a_diagnostic(row):
    """Extract the two b8a sub-services as separate benefits.

    Section 8a is Outpatient Diagnostic Procedures/Tests/Lab Services, NOT
    radiology (radiology is 8b). Cost-share columns are suffix-coded:
    _dmc = 8a1 Diagnostic Procedures/Tests, _lab = 8a2 Lab Services.
    """
    copay_on = yn(safe_get(row, "pbp_b8a_copay_yn"))
    coins_on = yn(safe_get(row, "pbp_b8a_coins_yn"))

    # Section-level fields shared by both sub-services
    shared = {}
    ded = yn(safe_get(row, "pbp_b8a_ded_yn"))
    if ded is not None:
        shared["deductible_applies"] = ded
        ded_amt = to_dollar(safe_get(row, "pbp_b8a_ded_amt"))
        if ded_amt:
            shared["deductible_amount"] = ded_amt
    auth = yn(safe_get(row, "pbp_b8a_auth_yn"))
    if auth is not None:
        shared["prior_auth_required"] = auth
    refer = yn(safe_get(row, "pbp_b8a_refer_yn"))
    if refer is not None:
        shared["referral_required"] = refer
    maxenr = yn(safe_get(row, "pbp_b8a_maxenr_yn"))
    if maxenr:
        shared["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b8a_maxenr_amt"))

    subs = [
        ("diagnostic_procedures", "Diagnostic Procedures & Tests",
         ("pbp_b8a_copay_min_dmc_amt", "pbp_b8a_copay_max_dmc_amt"),
         ("pbp_b8a_coins_pct_dmc", "pbp_b8a_coins_pct_dmc_max")),
        ("lab_services", "Lab Services",
         ("pbp_b8a_lab_copay_amt", "pbp_b8a_lab_copay_amt_max"),
         ("pbp_b8a_coins_pct_lab", "pbp_b8a_coins_pct_lab_max")),
    ]
    out = {}
    for key, label, (cp_min, cp_max), (co_min, co_max) in subs:
        b = {"label": label}
        if copay_on:
            b["copay"] = dollar_range(safe_get(row, cp_min), safe_get(row, cp_max))
        if coins_on:
            b["coinsurance"] = pct_range(safe_get(row, co_min), safe_get(row, co_max))
        has_cost_share = b.get("copay") or b.get("coinsurance")
        b.update(shared)
        # diagnostic_procedures always emitted as the section's primary row
        # (carries the shared flags); lab_services only when cost sharing filed.
        if key == "diagnostic_procedures" or has_cost_share:
            out[key] = clean_dict(b)
    return out


def extract_b8b_radiology(row):
    """Extract the three b8b radiology sub-services as separate benefits.

    b8b cost-share columns are suffix-coded per sub-service (dictionary:
    _drs = 8b1 Diagnostic Radiological Services (CT, MRI, etc.),
    _tmc = 8b2 Therapeutic Radiological Services,
    _mc / _cmc = 8b3 Medicare-covered X-Ray Services).
    A generic fallback chain conflates them — e.g. it attached the 8b3 X-ray
    copay (copay_mc_amt) to therapeutic radiology.
    """
    copay_on = yn(safe_get(row, "pbp_b8b_copay_yn"))
    coins_on = yn(safe_get(row, "pbp_b8b_coins_yn"))

    # Section-level fields shared by all three sub-services
    shared = {}
    ded = yn(safe_get(row, "pbp_b8b_ded_yn"))
    if ded is not None:
        shared["deductible_applies"] = ded
        ded_amt = to_dollar(safe_get(row, "pbp_b8b_ded_amt"))
        if ded_amt:
            shared["deductible_amount"] = ded_amt
    auth = yn(safe_get(row, "pbp_b8b_auth_yn"))
    if auth is not None:
        shared["prior_auth_required"] = auth
    refer = yn(safe_get(row, "pbp_b8b_refer_yn"))
    if refer is not None:
        shared["referral_required"] = refer
    maxenr = yn(safe_get(row, "pbp_b8b_maxenr_yn"))
    if maxenr:
        shared["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b8b_maxenr_amt"))

    subs = [
        ("diagnostic_radiology", "Diagnostic Radiology (CT/MRI, etc.)",
         ("pbp_b8b_copay_amt_drs", "pbp_b8b_copay_amt_drs_max"),
         ("pbp_b8b_coins_pct_drs", "pbp_b8b_coins_pct_drs_max")),
        ("therapeutic_radiology", "Therapeutic Radiology",
         ("pbp_b8b_copay_amt_tmc", "pbp_b8b_copay_amt_tmc_max"),
         ("pbp_b8b_coins_pct_tmc", "pbp_b8b_coins_pct_tmc_max")),
        ("basic_radiology", "Basic Radiological Services (X-rays)",
         ("pbp_b8b_copay_mc_amt", "pbp_b8b_copay_mc_amt_max"),
         ("pbp_b8b_coins_pct_cmc", "pbp_b8b_coins_pct_cmc_max")),
    ]
    out = {}
    for key, label, (cp_min, cp_max), (co_min, co_max) in subs:
        b = {"label": label}
        if copay_on:
            b["copay"] = dollar_range(safe_get(row, cp_min), safe_get(row, cp_max))
        if coins_on:
            b["coinsurance"] = pct_range(safe_get(row, co_min), safe_get(row, co_max))
        has_cost_share = b.get("copay") or b.get("coinsurance")
        b.update(shared)
        # therapeutic_radiology always emitted (pre-existing key); the other two
        # only when the plan actually filed cost sharing for that sub-service.
        if key == "therapeutic_radiology" or has_cost_share:
            out[key] = clean_dict(b)
    return out


def extract_mental_health(row, prefix, label):
    """Extract mental health benefit (individual + group sessions)."""
    result = {"label": label}
    copay_yn = yn(safe_get(row, f"{prefix}_copay_yn"))
    if copay_yn:
        ind_min = safe_get(row, f"{prefix}_copay_mcis_minamt")
        ind_max = safe_get(row, f"{prefix}_copay_mcis_maxamt")
        grp_min = safe_get(row, f"{prefix}_copay_mcgs_minamt")
        grp_max = safe_get(row, f"{prefix}_copay_mcgs_maxamt")
        result["copay_individual"] = dollar_range(ind_min, ind_max)
        result["copay_group"] = dollar_range(grp_min, grp_max)
    coins_yn = yn(safe_get(row, f"{prefix}_coins_yn"))
    if coins_yn:
        result["coinsurance_individual"] = pct_range(
            safe_get(row, f"{prefix}_coins_mcis_minpct"),
            safe_get(row, f"{prefix}_coins_mcis_maxpct"),
        )
        result["coinsurance_group"] = pct_range(
            safe_get(row, f"{prefix}_coins_mcgs_minpct"),
            safe_get(row, f"{prefix}_coins_mcgs_maxpct"),
        )
    # Both cost-share flags explicitly "No" = $0 to the member (sparse-card fix).
    if copay_yn is False and coins_yn is False and not result.get("copay_individual") and not result.get("coinsurance_individual"):
        result["copay_individual"] = "$0"
        result["copay_group"] = "$0"
    ded = yn(safe_get(row, f"{prefix}_ded_yn"))
    if ded is not None:
        result["deductible_applies"] = ded
    auth = yn(safe_get(row, f"{prefix}_auth_yn"))
    if auth is not None:
        result["prior_auth_required"] = auth
    refer = yn(safe_get(row, f"{prefix}_refer_yn"))
    if refer is not None:
        result["referral_required"] = refer
    maxenr = yn(safe_get(row, f"{prefix}_maxenr_yn"))
    if maxenr:
        result["max_enrollee_cost"] = to_dollar(safe_get(row, f"{prefix}_maxenr_amt"))
    return clean_dict(result)


def extract_partb_drugs(row):
    """Extract Part B Rx drugs (b15). The file uses mrx_b_* columns, not pbp_b15_*."""
    result = {"label": "Part B Prescription Drugs"}
    if yn(safe_get(row, "mrx_b_copay_yn")):
        result["copay"] = dollar_range(
            safe_get(row, "mrx_b_copay_min_amt"),
            safe_get(row, "mrx_b_copay_max_amt"),
        )
    if yn(safe_get(row, "mrx_b_coins_yn")):
        result["coinsurance"] = pct_range(
            safe_get(row, "mrx_b_coins_min_pct"),
            safe_get(row, "mrx_b_coins_max_pct"),
        )
    ded = yn(safe_get(row, "mrx_b_ded_yn"))
    if ded is not None:
        result["deductible_applies"] = ded
        ded_amt = to_dollar(safe_get(row, "mrx_b_ded_amt"))
        if ded_amt:
            result["deductible_amount"] = ded_amt
    auth = yn(safe_get(row, "mrx_b_auth_yn"))
    if auth is not None:
        result["prior_auth_required"] = auth
    return clean_dict(result)


def extract_inpatient(row, prefix, label):
    """Extract inpatient hospital benefit with interval-based cost-sharing."""
    result = {"label": label}
    # CMS stores per-day cost-sharing under interval "families": mcs = Medicare-covered
    # stay (the standard one, most populated), ad = additional days beyond coverage,
    # lrd = lifetime reserve days. Use the first family that has intervals.
    INTERVAL_FAMILIES = ("mcs", "ad", "lrd")
    # Coinsurance intervals (tier 1)
    coins_yn = yn(safe_get(row, f"{prefix}_coins_yn"))
    if coins_yn:
        intervals = []
        for fam in INTERVAL_FAMILIES:
            fam_intervals = []
            for i in range(1, 4):
                pct = to_pct(safe_get(row, f"{prefix}_coins_{fam}_pct_int{i}_t1"))
                bgn = safe_get(row, f"{prefix}_coins_{fam}_bgnd_int{i}_t1")
                end = safe_get(row, f"{prefix}_coins_{fam}_endd_int{i}_t1")
                if pct and bgn:
                    fam_intervals.append({"pct": pct, "from_day": bgn, "to_day": end or "+"})
            if fam_intervals:
                intervals = fam_intervals
                break
        if intervals:
            result["coinsurance_intervals"] = intervals
        else:
            # Flat coinsurance for non-Medicare-covered stay
            flat = to_pct(safe_get(row, f"{prefix}_coins_nmcs_pct") or safe_get(row, f"{prefix}_coins_pct_nmcs"))
            if flat:
                result["coinsurance"] = flat
    # Copay intervals (tier 1)
    copay_yn = yn(safe_get(row, f"{prefix}_copay_yn"))
    if copay_yn:
        intervals = []
        for fam in INTERVAL_FAMILIES:
            fam_intervals = []
            for i in range(1, 4):
                amt = to_dollar(safe_get(row, f"{prefix}_copay_{fam}_amt_int{i}_t1"))
                bgn = safe_get(row, f"{prefix}_copay_{fam}_bgnd_int{i}_t1")
                end = safe_get(row, f"{prefix}_copay_{fam}_endd_int{i}_t1")
                if amt and bgn:
                    fam_intervals.append({"amount": amt, "from_day": bgn, "to_day": end or "+"})
            if fam_intervals:
                intervals = fam_intervals
                break
        if intervals:
            result["copay_intervals"] = intervals
        else:
            flat = to_dollar(safe_get(row, f"{prefix}_copay_nmcs_amt"))
            if flat:
                result["copay"] = flat
    auth = yn(safe_get(row, f"{prefix}_auth_yn"))
    if auth is not None:
        result["prior_auth_required"] = auth
    refer = yn(safe_get(row, f"{prefix}_refer_yn"))
    if refer is not None:
        result["referral_required"] = refer
    # Benefit description. An explicit "No" (bendesc_yn = 2) means the plan
    # filed the benefit as NOT offered — emit nothing (sweep check #5).
    bendesc = yn(safe_get(row, f"{prefix}_bendesc_yn"))
    if bendesc is False:
        return None
    if bendesc is not None:
        result["supplemental_benefit"] = bendesc
    return clean_dict(result)


def extract_emergency(row):
    """Extract emergency care (b4a), urgent care (b4b), worldwide (b4c)."""
    result = {}
    # Emergency
    er = {"label": "Emergency Care"}
    er["copay"] = dollar_range(safe_get(row, "pbp_b4a_copay_amt_mc_min"), safe_get(row, "pbp_b4a_copay_amt_mc_max"))
    er["coinsurance"] = pct_range(safe_get(row, "pbp_b4a_coins_pct_mc_min"), safe_get(row, "pbp_b4a_coins_pct_mc_max"))
    waived = yn(safe_get(row, "pbp_b4a_copay_wavdia_yn"))
    if waived is not None:
        er["copay_waived_if_admitted"] = waived
    er["deductible_applies"] = yn(safe_get(row, "pbp_b4a_deduct_yn"))
    result["emergency_care"] = clean_dict(er)
    # Urgent
    urg = {"label": "Urgently Needed Care"}
    urg["copay"] = dollar_range(safe_get(row, "pbp_b4b_copay_amt_mc_min"), safe_get(row, "pbp_b4b_copay_amt_mc_max"))
    urg["coinsurance"] = pct_range(safe_get(row, "pbp_b4b_coins_pct_mc_min"), safe_get(row, "pbp_b4b_coins_pct_mc_max"))
    urg["deductible_applies"] = yn(safe_get(row, "pbp_b4b_deduct_yn"))
    result["urgent_care"] = clean_dict(urg)
    # Worldwide
    ww_yn = yn(safe_get(row, "pbp_b4c_bendesc_yn"))
    if ww_yn:
        ww = {"label": "Worldwide Emergency/Urgent"}
        ww["copay_emergency"] = dollar_range(safe_get(row, "pbp_b4c_copay_amt_wec_min"), safe_get(row, "pbp_b4c_copay_amt_wec_max"))
        ww["copay_urgent"] = dollar_range(safe_get(row, "pbp_b4c_copay_amt_wuc_min"), safe_get(row, "pbp_b4c_copay_amt_wuc_max"))
        ww["coinsurance_emergency"] = pct_range(safe_get(row, "pbp_b4c_coins_pct_wec_min"), safe_get(row, "pbp_b4c_coins_pct_wec_max"))
        ww["coinsurance_urgent"] = pct_range(safe_get(row, "pbp_b4c_coins_pct_wuc_min"), safe_get(row, "pbp_b4c_coins_pct_wuc_max"))
        ww["deductible_applies"] = yn(safe_get(row, "pbp_b4c_ded_yn"))
        ww["deductible_amount"] = to_dollar(safe_get(row, "pbp_b4c_ded_amt"))
        maxplan = yn(safe_get(row, "pbp_b4c_wwc_maxplan_yn"))
        if maxplan:
            ww["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b4c_wwc_maxplan_amt"))
        result["worldwide_emergency"] = clean_dict(ww)
    return result


def extract_drug_coverage(mrx_row, tier_rows):
    """Extract Part D drug coverage from mrx and mrx_tier data."""
    result = {}
    has_drug = yn(safe_get(mrx_row, "mrx_drug_ben_yn"))
    result["has_drug_benefit"] = has_drug
    if not has_drug:
        return result

    result["benefit_type"] = safe_get(mrx_row, "mrx_benefit_type")
    result["num_tiers"] = safe_get(mrx_row, "mrx_formulary_tiers_num")
    result["deductible"] = to_dollar(safe_get(mrx_row, "mrx_alt_ded_amount"))

    # Insulin attestation
    insulin = yn(safe_get(mrx_row, "mrx_insulin_attest"))
    if insulin is not None:
        result["insulin_cost_sharing"] = insulin
    vaccine = yn(safe_get(mrx_row, "mrx_vaccine_attest"))
    if vaccine is not None:
        result["vaccine_coverage"] = vaccine

    # Generic supply days from mrx
    gen_1m = to_dollar(safe_get(mrx_row, "mrx_gen_rstd_1m"))
    gen_3m = to_dollar(safe_get(mrx_row, "mrx_gen_rstd_3m"))
    if gen_1m:
        result["generic_retail_30day"] = gen_1m
    if gen_3m:
        result["generic_retail_90day"] = gen_3m
    gen_mo_1m = to_dollar(safe_get(mrx_row, "mrx_gen_mostd_1m"))
    gen_mo_3m = to_dollar(safe_get(mrx_row, "mrx_gen_mostd_3m"))
    if gen_mo_1m:
        result["generic_mail_30day"] = gen_mo_1m
    if gen_mo_3m:
        result["generic_mail_90day"] = gen_mo_3m

    # IRA insulin copays
    ira_1m = to_dollar(safe_get(mrx_row, "mrx_gen_ira_rstd_copay_1m"))
    ira_3m = to_dollar(safe_get(mrx_row, "mrx_gen_ira_rstd_copay_3m"))
    if ira_1m:
        result["insulin_retail_30day"] = ira_1m
    if ira_3m:
        result["insulin_retail_90day"] = ira_3m

    # Tier details from mrx_tier
    tiers = []
    for _, trow in tier_rows.iterrows():
        tier = {}
        tier["tier_label"] = safe_get(trow, "mrx_tier_label_list") or safe_get(trow, "mrx_tier_id")
        tier["tier_id"] = safe_get(trow, "mrx_tier_id")
        # Retail standard copay
        tier["retail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_rstd_copay_1m"))
        tier["retail_copay_90day"] = to_dollar(safe_get(trow, "mrx_tier_rstd_copay_3m"))
        tier["retail_coinsurance_30day"] = to_pct(safe_get(trow, "mrx_tier_rstd_coins_1m"))
        tier["retail_coinsurance_90day"] = to_pct(safe_get(trow, "mrx_tier_rstd_coins_3m"))
        # Preferred retail
        tier["preferred_retail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_rspfd_copay_1m"))
        tier["preferred_retail_copay_90day"] = to_dollar(safe_get(trow, "mrx_tier_rspfd_copay_3m"))
        tier["preferred_retail_coinsurance_30day"] = to_pct(safe_get(trow, "mrx_tier_rspfd_coins_1m"))
        tier["preferred_retail_coinsurance_90day"] = to_pct(safe_get(trow, "mrx_tier_rspfd_coins_3m"))
        # Mail order
        tier["mail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_mostd_copay_1m"))
        tier["mail_copay_90day"] = to_dollar(safe_get(trow, "mrx_tier_mostd_copay_3m"))
        tier["mail_coinsurance_30day"] = to_pct(safe_get(trow, "mrx_tier_mostd_coins_1m"))
        tier["mail_coinsurance_90day"] = to_pct(safe_get(trow, "mrx_tier_mostd_coins_3m"))
        # LTC
        tier["ltc_copay"] = to_dollar(safe_get(trow, "mrx_tier_ltcp_copay_1m"))
        tier["ltc_coinsurance"] = to_pct(safe_get(trow, "mrx_tier_ltcp_coins_1m"))
        # Out-of-network pharmacy
        tier["oon_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_oonp_copay_1m"))
        tier["oon_coinsurance_30day"] = to_pct(safe_get(trow, "mrx_tier_oonp_coins_1m"))
        # IRA insulin cost-share (capped insulin pricing) per tier
        tier["insulin_retail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_ira_rstd_copay_1m"))
        tier["insulin_retail_copay_90day"] = to_dollar(safe_get(trow, "mrx_tier_ira_rstd_copay_3m"))
        tier["insulin_preferred_retail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_ira_rspfd_copay_1m"))
        tier["insulin_mail_copay_30day"] = to_dollar(safe_get(trow, "mrx_tier_ira_mostd_copay_1m"))
        tier["insulin_mail_copay_90day"] = to_dollar(safe_get(trow, "mrx_tier_ira_mostd_copay_3m"))
        # Description
        desc = safe_get(trow, "mrx_tier_form_model_desc")
        if desc:
            tier["description"] = desc
        tiers.append(clean_dict(tier))
    if tiers:
        result["tiers"] = tiers

    return clean_dict(result)


def auth_text(val):
    """Convert authorization code to text."""
    return AUTH_MAP.get(str(val).strip(), None) if val else None


def extract_benefit_limit(row, prefix, suffix="", lim_field=None, num_field=None, per_field=None):
    """Benefit Unlimited Component → visit_limit / visit_limit_period.
    lim==2 (limited) + a numv + a per → render the cap; lim==1 (unlimited) or absent → {}.

    The lim/num/per triple is named with inconsistent infixes across PBP
    sections (e.g. hearing aids: trailing `_at` suffix on all three fields;
    dental preventive / podiatry: the service code sits between `bendesc_`
    and the field-type token, and/or the number field is `_num`/`_amt`
    instead of `_numv`). Callers whose section doesn't fit the standard
    `{prefix}_bendesc_{lim,numv,per}{suffix}` shape pass explicit field
    names via lim_field=/num_field=/per_field= instead of relying on the
    suffix-derived defaults.
    """
    num_field_explicit = num_field is not None
    lim_field = lim_field or f"{prefix}_bendesc_lim{suffix}"
    num_field = num_field or f"{prefix}_bendesc_numv{suffix}"
    per_field = per_field or f"{prefix}_bendesc_per{suffix}"

    lim = safe_get(row, lim_field)
    if yn(lim) is not False and lim != "2":   # unlimited (1) or absent → no cap line
        return {}

    numv = safe_get(row, num_field)
    if not numv and not num_field_explicit:
        numv = safe_get(row, f"{prefix}_bendesc_num{suffix}")
    per = safe_get(row, per_field)
    out = {}
    if numv and str(numv).strip() not in ("", ".", "0"):
        out["visit_limit"] = str(numv).strip()
    if per and PERIODICITY_MAP.get(str(per).strip()):
        out["visit_limit_period"] = PERIODICITY_MAP[str(per).strip()]
    return out


def extract_supplemental_benefit(row, prefix, label):
    """Extract a supplemental (NMC) benefit with benefit description, limits, and cost sharing."""
    bendesc = yn(safe_get(row, f"{prefix}_bendesc_yn"))
    if bendesc is False:
        # Explicit "No" — the plan filed this benefit as NOT offered.
        return None
    if bendesc is None:
        # Alternate offered-flags. These are ALSO 1=Yes/2=No codes (e.g.
        # pbp_b13c_bendesc_service, pbp_b13b_bendesc_otc) — "2" means not
        # offered, not merely "column present" (sweep check #5).
        svc = safe_get(row, f"{prefix}_bendesc_service")
        otc = safe_get(row, f"{prefix}_bendesc_otc")
        if svc == "2" or otc == "2":
            return None
        if not svc and not otc:
            return None

    result = {"label": label}

    # Benefit type (mandatory/optional/both)
    amo = safe_get(row, f"{prefix}_bendesc_amo")
    if amo:
        result["benefit_type"] = BENEFIT_TYPE_MAP.get(amo, amo)

    # Max plan benefit
    maxplan = yn(safe_get(row, f"{prefix}_maxplan_yn"))
    if maxplan:
        maxplan_amt = to_float(safe_get(row, f"{prefix}_maxplan_amt"))
        if maxplan_amt is not None and maxplan_amt == 0:
            # CMS source encodes $0 here when the dollar allowance is pooled into a
            # combined supplemental/OTC allowance rather than a per-item cap. Emitting
            # a literal "$0" reads as "not covered", so annotate instead.
            result["max_plan_benefit_note"] = "Included in combined supplemental allowance"
        else:
            result["max_plan_benefit"] = to_dollar(safe_get(row, f"{prefix}_maxplan_amt"))
        per = safe_get(row, f"{prefix}_maxplan_per")
        if per:
            result["max_plan_benefit_period"] = PERIODICITY_MAP.get(per, per)

    # Visit/treatment limit (bendesc_lim: 1=unlimited, 2=limited → numv per period).
    # Sections without these columns return "" and are skipped harmlessly.
    lim = yn(safe_get(row, f"{prefix}_bendesc_lim"))
    if lim is True:
        result["unlimited"] = True
    elif lim is False:
        numv = safe_get(row, f"{prefix}_bendesc_numv")
        if numv:
            try:
                numv = str(int(float(numv)))
            except ValueError:
                pass
            result["visit_limit"] = numv
            lper = safe_get(row, f"{prefix}_bendesc_per")
            if lper:
                result["visit_limit_period"] = PERIODICITY_MAP.get(lper, lper)

    # Max enrollee cost
    maxenr = yn(safe_get(row, f"{prefix}_maxenr_yn"))
    if maxenr:
        result["max_enrollee_cost"] = to_dollar(safe_get(row, f"{prefix}_maxenr_amt"))

    # Cost sharing
    copay_yn = yn(safe_get(row, f"{prefix}_copay_yn"))
    if copay_yn:
        result["copay"] = dollar_range(
            safe_get(row, f"{prefix}_copay_amt_mc_min") or safe_get(row, f"{prefix}_copay_mc_amt_min") or safe_get(row, f"{prefix}_copay_min_amt") or safe_get(row, f"{prefix}_copay_amt_min") or safe_get(row, f"{prefix}_copay_amt_rpe_min"),
            safe_get(row, f"{prefix}_copay_amt_mc_max") or safe_get(row, f"{prefix}_copay_mc_amt_max") or safe_get(row, f"{prefix}_copay_max_amt") or safe_get(row, f"{prefix}_copay_amt_max") or safe_get(row, f"{prefix}_copay_amt_rpe_max"),
        )
    coins_yn = yn(safe_get(row, f"{prefix}_coins_yn"))
    if coins_yn:
        result["coinsurance"] = pct_range(
            safe_get(row, f"{prefix}_coins_pct_mc_min") or safe_get(row, f"{prefix}_coins_min_pct") or safe_get(row, f"{prefix}_coins_pct_mc") or safe_get(row, f"{prefix}_coins_pct_min") or safe_get(row, f"{prefix}_coins_pct_rpe_min"),
            safe_get(row, f"{prefix}_coins_pct_mc_max") or safe_get(row, f"{prefix}_coins_max_pct") or safe_get(row, f"{prefix}_coins_pct_max") or safe_get(row, f"{prefix}_coins_pct_rpe_max"),
        )
    # Both cost-share flags explicitly "No" = $0 to the member (sparse-card fix).
    if copay_yn is False and coins_yn is False and not result.get("copay") and not result.get("coinsurance"):
        result["copay"] = "$0"

    # Deductible
    ded = yn(safe_get(row, f"{prefix}_ded_yn"))
    if ded is not None:
        result["deductible_applies"] = ded
        ded_amt = to_dollar(safe_get(row, f"{prefix}_ded_amt"))
        if ded_amt:
            result["deductible_amount"] = ded_amt

    # Auth and referral
    auth = safe_get(row, f"{prefix}_auth_yn")
    if auth:
        result["prior_auth_required"] = AUTH_MAP.get(auth, yn(auth))
    refer = safe_get(row, f"{prefix}_refer_yn")
    if refer:
        result["referral_required"] = AUTH_MAP.get(refer, yn(refer))

    # Limit fields (for transportation, visits, etc.)
    lim_yn = yn(safe_get(row, f"{prefix}_bendesc_lim_yn"))
    if lim_yn is False:
        result["unlimited"] = True
    elif lim_yn is True:
        visits = safe_get(row, f"{prefix}_bendesc_numv") or safe_get(row, f"{prefix}_bendesc_numv_ow")
        if visits:
            result["visit_limit"] = visits
        per = safe_get(row, f"{prefix}_bendesc_per")
        if per:
            result["visit_limit_period"] = PERIODICITY_MAP.get(per, per)

    # Distance limit (transportation)
    dist_yn = yn(safe_get(row, f"{prefix}_bendesc_distlm_yn"))
    if dist_yn:
        miles = safe_get(row, f"{prefix}_bendesc_distlm_ml")
        if miles:
            result["distance_limit_miles"] = miles

    return clean_dict(result) if len(result) > 1 else None


def extract_dental_detail(row):
    """Extract comprehensive dental data with sub-types."""
    result = {}

    # Medicare-covered dental (b16a). Source uses copay_mc_amt_* / coins_mc_pct_*.
    mc_dental = {"label": "Medicare-Covered Dental"}
    mc_dental["copay"] = dollar_range(
        safe_get(row, "pbp_b16a_copay_mc_amt_min"),
        safe_get(row, "pbp_b16a_copay_mc_amt_max"),
    )
    mc_dental["coinsurance"] = pct_range(
        safe_get(row, "pbp_b16a_coins_mc_pct_min"),
        safe_get(row, "pbp_b16a_coins_mc_pct_max"),
    )
    maxenr = yn(safe_get(row, "pbp_b16a_maxenr_mc_yn"))
    if maxenr:
        mc_dental["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b16a_maxenr_mc_amt"))
    result["dental_medicare"] = clean_dict(mc_dental)

    # Preventive dental (b16b) - overall max plan benefit + suffix-coded sub-types.
    prev = {"label": "Preventive Dental"}
    maxplan_pv = yn(safe_get(row, "pbp_b16b_maxplan_pv_yn"))
    if maxplan_pv:
        prev["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b16b_maxplan_pv_amt"))
    prev_types = [
        ("oe", "Oral Exams"), ("pc", "Prophylaxis/Cleanings"),
        ("ft", "Fluoride Treatment"), ("dx", "Dental X-Rays"),
        ("ods", "Other Diagnostic Services"), ("ops", "Other Preventive Services"),
        ("ov", "Other"),
    ]
    subs = []
    for sfx, lbl in prev_types:
        copay = dollar_range(
            safe_get(row, f"pbp_b16b_copay_{sfx}_amt_min"),
            safe_get(row, f"pbp_b16b_copay_{sfx}_amt_max"),
        )
        coins = pct_range(
            safe_get(row, f"pbp_b16b_coins_{sfx}_pct_min"),
            safe_get(row, f"pbp_b16b_coins_{sfx}_pct_max"),
        )
        # Visit/frequency limit. Dental preventive's Benefit Unlimited
        # Component is infixed (service code BEFORE the field-type token:
        # pbp_b16b_bendesc_{svc}_lim/_num/_per), unlike the standard
        # trailing-suffix shape (`_lim{suffix}`), so pass explicit field
        # names rather than relying on the suffix-derived defaults. There
        # is no "_ov" (Other) triple in the dictionary, so that sub-type
        # simply gets {} back — harmless.
        limit = extract_benefit_limit(
            row, "pbp_b16b", f"_{sfx}",
            lim_field=f"pbp_b16b_bendesc_{sfx}_lim",
            num_field=f"pbp_b16b_bendesc_{sfx}_num",
            per_field=f"pbp_b16b_bendesc_{sfx}_per",
        )
        if copay or coins or limit:
            subs.append(clean_dict({"label": lbl, "copay": copay, "coinsurance": coins, **limit}))
    if subs:
        prev["sub_types"] = subs
    result["dental_preventive"] = clean_dict(prev)

    # Comprehensive dental (b16c). No overall copay/coins column exists - per sub-type only.
    comp = {"label": "Comprehensive Dental"}
    cmp_max = yn(safe_get(row, "pbp_b16c_maxplan_cmp_yn"))
    if cmp_max:
        comp["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b16c_maxplan_cmp_amt"))
    comp["deductible_applies"] = yn(safe_get(row, "pbp_b16c_ded_cmp_yn"))
    comp["deductible_amount"] = to_dollar(safe_get(row, "pbp_b16c_ded_cmp_amt"))
    comp_types = [
        ("rs", "Restorative"), ("end", "Endodontics"),
        ("peri", "Periodontics"), ("prm", "Prosthodontics (Removable)"),
        ("prf", "Prosthodontics (Fixed)"), ("impl", "Implants"),
        ("orth", "Orthodontics"), ("omsg", "Oral/Maxillofacial Surgery"),
        ("ags", "Anesthesia/General Services"), ("mxpr", "Other Comprehensive"),
    ]
    csubs = []
    for sfx, lbl in comp_types:
        copay = dollar_range(
            safe_get(row, f"pbp_b16c_copay_{sfx}_amt_min"),
            safe_get(row, f"pbp_b16c_copay_{sfx}_amt_max"),
        )
        coins = pct_range(
            safe_get(row, f"pbp_b16c_coins_{sfx}_pct_min"),
            safe_get(row, f"pbp_b16c_coins_{sfx}_pct_max"),
        )
        if copay or coins:
            csubs.append(clean_dict({"label": lbl, "copay": copay, "coinsurance": coins}))
    if csubs:
        comp["sub_types"] = csubs
    maxenr_cmp = yn(safe_get(row, "pbp_b16c_maxenr_cmp_yn"))
    if maxenr_cmp:
        comp["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b16c_maxenr_cmp_amt"))
    result["dental_comprehensive"] = clean_dict(comp)

    return result


def extract_vision_detail(row):
    """Extract complete vision data with exam limits and eyewear sub-types."""
    result = {}

    # Eye exams (b17a)
    exam = {"label": "Routine Eye Exams"}
    exam["copay"] = dollar_range(
        safe_get(row, "pbp_b17a_copay_amt_mc_min") or safe_get(row, "pbp_b17a_copay_re_min_amt"),
        safe_get(row, "pbp_b17a_copay_amt_mc_max") or safe_get(row, "pbp_b17a_copay_re_max_amt"),
    )
    exam["coinsurance"] = pct_range(
        safe_get(row, "pbp_b17a_coins_pct_mc_min") or safe_get(row, "pbp_b17a_coins_re_min_pct"),
        safe_get(row, "pbp_b17a_coins_pct_mc_max") or safe_get(row, "pbp_b17a_coins_re_max_pct"),
    )
    maxplan_re = yn(safe_get(row, "pbp_b17a_maxplan_yn"))
    if maxplan_re:
        exam["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b17a_maxplan_amt"))
    maxenr = yn(safe_get(row, "pbp_b17a_maxenr_yn"))
    if maxenr:
        exam["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b17a_maxenr_amt"))
    exam["deductible_applies"] = yn(safe_get(row, "pbp_b17a_ded_yn"))
    auth = safe_get(row, "pbp_b17a_auth_yn")
    if auth:
        exam["prior_auth_required"] = AUTH_MAP.get(auth, yn(auth))
    refer = safe_get(row, "pbp_b17a_refer_yn")
    if refer:
        exam["referral_required"] = AUTH_MAP.get(refer, yn(refer))
    # Exam limits (routine eye exam family = _rex). Unlike the generic
    # _bendesc_lim_yn fields, lim_rex asks "Is this benefit unlimited?":
    # 1 = Yes (unlimited), 2 = No, indicate number.
    lim_yn = yn(safe_get(row, "pbp_b17a_bendesc_lim_rex"))
    if lim_yn is True:
        exam["unlimited"] = True
    elif lim_yn is False:
        num = safe_get(row, "pbp_b17a_bendesc_num_rex")
        if num:
            exam["exam_limit"] = num
        per = safe_get(row, "pbp_b17a_bendesc_per_rex")
        if per:
            exam["exam_limit_period"] = PERIODICITY_MAP.get(per, per)
    result["eye_exams"] = clean_dict(exam)

    # Eyewear (b17b)
    eyewear = {"label": "Eyewear (Glasses/Contacts)"}
    eyewear["max_plan_benefit"] = to_dollar(
        safe_get(row, "pbp_b17b_comb_maxplan_amt") or safe_get(row, "pbp_b17b_maxplan_amt")
    )
    # Contacts
    eyewear["contacts_copay"] = dollar_range(
        safe_get(row, "pbp_b17b_copay_amt_cl_min"),
        safe_get(row, "pbp_b17b_copay_amt_cl_max"),
    )
    eyewear["contacts_coinsurance"] = pct_range(
        safe_get(row, "pbp_b17b_coins_pct_cl_min"),
        safe_get(row, "pbp_b17b_coins_pct_cl_max"),
    )
    # Glasses
    eyewear["glasses_copay"] = dollar_range(
        safe_get(row, "pbp_b17b_copay_amt_egs_min"),
        safe_get(row, "pbp_b17b_copay_amt_egs_max"),
    )
    eyewear["glasses_coinsurance"] = pct_range(
        safe_get(row, "pbp_b17b_coins_pct_egs_min"),
        safe_get(row, "pbp_b17b_coins_pct_egs_max"),
    )
    # Quantity/cadence limits per item type (17b: standard suffix shape —
    # pbp_b17b_bendesc_{lim,numv,per}_egs / _cl).
    egs_limit = extract_benefit_limit(row, "pbp_b17b", "_egs")
    if egs_limit.get("visit_limit"):
        eyewear["glasses_quantity_limit"] = egs_limit["visit_limit"]
    if egs_limit.get("visit_limit_period"):
        eyewear["glasses_quantity_limit_period"] = egs_limit["visit_limit_period"]
    cl_limit = extract_benefit_limit(row, "pbp_b17b", "_cl")
    if cl_limit.get("visit_limit"):
        eyewear["contacts_quantity_limit"] = cl_limit["visit_limit"]
    if cl_limit.get("visit_limit_period"):
        eyewear["contacts_quantity_limit_period"] = cl_limit["visit_limit_period"]
    # Upgrades
    eyewear["upgrades_copay"] = dollar_range(
        safe_get(row, "pbp_b17b_copay_amt_upg_min"),
        safe_get(row, "pbp_b17b_copay_amt_upg_max"),
    )
    maxenr_ew = yn(safe_get(row, "pbp_b17b_maxenr_yn"))
    if maxenr_ew:
        eyewear["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b17b_maxenr_amt"))
    eyewear["deductible_applies"] = yn(safe_get(row, "pbp_b17b_ded_yn"))
    result["eyewear"] = clean_dict(eyewear)

    return result


def extract_hearing_detail(row):
    """Extract complete hearing data with exam, fitting, aids, and OTC."""
    result = {}

    # Hearing exams (b18a). Routine hearing-test family = _rht; Medicare exam = copay_amt/med_*.
    exam = {"label": "Hearing Exams"}
    exam["copay"] = dollar_range(
        safe_get(row, "pbp_b18a_copay_amt_rht") or safe_get(row, "pbp_b18a_copay_amt"),
        safe_get(row, "pbp_b18a_copay_amt_max_rht") or safe_get(row, "pbp_b18a_med_copay_amt_max"),
    )
    exam["coinsurance"] = pct_range(
        safe_get(row, "pbp_b18a_med_coins_pct"),
        safe_get(row, "pbp_b18a_med_coins_pct_max"),
    )
    maxplan = yn(safe_get(row, "pbp_b18a_maxplan_yn"))
    if maxplan:
        exam["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b18a_maxplan_amt"))
    maxenr = yn(safe_get(row, "pbp_b18a_maxenr_yn"))
    if maxenr:
        exam["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b18a_maxenr_amt"))
    exam["deductible_applies"] = yn(safe_get(row, "pbp_b18a_ded_yn"))
    auth = safe_get(row, "pbp_b18a_auth_yn")
    if auth:
        exam["prior_auth_required"] = AUTH_MAP.get(auth, yn(auth))
    # Exam limits (routine hearing test family). lim_rht asks "Is this benefit
    # unlimited?": 1 = Yes (unlimited), 2 = No, indicate number.
    lim_yn = yn(safe_get(row, "pbp_b18a_bendesc_lim_rht"))
    if lim_yn is True:
        exam["unlimited"] = True
    elif lim_yn is False:
        num = safe_get(row, "pbp_b18a_bendesc_numv_cl")
        if num:
            exam["exam_limit"] = num
        per = safe_get(row, "pbp_b18a_bendesc_per_rht")
        if per:
            exam["exam_limit_period"] = PERIODICITY_MAP.get(per, per)
    # Fitting/evaluation (family = _fha)
    fit_copay = dollar_range(
        safe_get(row, "pbp_b18a_copay_amt_fha"),
        safe_get(row, "pbp_b18a_copay_amt_max_fha"),
    )
    if fit_copay:
        exam["fitting_copay"] = fit_copay
    # Fitting/evaluation visit limit (18a _fha triple: standard suffix shape).
    fit_limit = extract_benefit_limit(row, "pbp_b18a", "_fha")
    if fit_limit.get("visit_limit"):
        exam["fitting_visit_limit"] = fit_limit["visit_limit"]
    if fit_limit.get("visit_limit_period"):
        exam["fitting_visit_limit_period"] = fit_limit["visit_limit_period"]
    result["hearing_exams"] = clean_dict(exam)

    # Hearing aids (b18b)
    aids = {"label": "Hearing Aids"}
    aids["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b18b_maxplan_amt"))
    # pbp_b18b_maxplan_perear is an ENUM ("Select Coverage": 1=Per ear,
    # 2=One single ear, 3=Both ears combined) qualifying maxplan_amt — NOT a
    # dollar value (sweep check #1a: rendering it with to_dollar produced
    # "$1"/"$2"/"$3" per-ear amounts on 2,081 plans).
    scope = HEARING_MAXPLAN_SCOPE_MAP.get(safe_get(row, "pbp_b18b_maxplan_perear"))
    if scope and aids.get("max_plan_benefit"):
        aids["max_plan_benefit_scope"] = scope
    aids["copay"] = dollar_range(
        safe_get(row, "pbp_b18b_copay_at_min_amt"),
        safe_get(row, "pbp_b18b_copay_at_max_amt"),
    )
    aids["coinsurance"] = pct_range(
        safe_get(row, "pbp_b18b_coins_pct_at_min"),
        safe_get(row, "pbp_b18b_coins_pct_at_max"),
    )
    maxenr_aids = yn(safe_get(row, "pbp_b18b_maxenr_yn"))
    if maxenr_aids:
        aids["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b18b_maxenr_amt"))
    aids["deductible_applies"] = yn(safe_get(row, "pbp_b18b_ded_yn"))
    auth_aids = safe_get(row, "pbp_b18b_auth_yn")
    if auth_aids:
        aids["prior_auth_required"] = AUTH_MAP.get(auth_aids, yn(auth_aids))
    # Aid types: covered types signalled by per-type bendesc_amo columns
    AID_TYPE_LABELS = [("at", "All Types"), ("ie", "In-the-ear"), ("oe", "Behind-the-ear"), ("ote", "Other")]
    types = [lbl for sfx, lbl in AID_TYPE_LABELS if safe_get(row, f"pbp_b18b_bendesc_amo_{sfx}")]
    if types:
        aids["aid_types"] = ", ".join(types)
    # Number-of-aids / replacement-cadence limit (18b _at triple: standard
    # suffix shape — pbp_b18b_bendesc_{lim,numv,per}_at).
    aids.update(extract_benefit_limit(row, "pbp_b18b", "_at"))
    # Emit only when the plan didn't explicitly file hearing aids as not
    # offered (bendesc_yn = 2) — sweep check #5.
    if yn(safe_get(row, "pbp_b18b_bendesc_yn")) is not False:
        result["hearing_aids"] = clean_dict(aids)

    # OTC hearing aids (b18c) - no bendesc_yn gate; presence signalled by copay/maxplan yn.
    otc_yn = yn(safe_get(row, "pbp_b18c_copay_yn")) or yn(safe_get(row, "pbp_b18c_maxplan_yn"))
    if otc_yn:
        otc = {"label": "OTC Hearing Aids"}
        otc["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b18c_maxplan_amt"))
        otc["copay"] = dollar_range(
            safe_get(row, "pbp_b18c_copay_amt_min"),
            safe_get(row, "pbp_b18c_copay_amt_max"),
        )
        otc["coinsurance"] = pct_range(
            safe_get(row, "pbp_b18c_coins_pct_min"),
            safe_get(row, "pbp_b18c_coins_pct_max"),
        )
        maxenr_otc = yn(safe_get(row, "pbp_b18c_maxenr_yn"))
        if maxenr_otc:
            otc["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b18c_maxenr_amt"))
        # Quantity/periodicity limit (18c: no suffix — pbp_b18c_bendesc_{lim,num,per}).
        # num field here is "_num", not "_numv"; the helper's default fallback
        # to _num{suffix} covers it since suffix="".
        otc.update(extract_benefit_limit(row, "pbp_b18c"))
        result["otc_hearing_aids"] = clean_dict(otc)

    return result


def extract_b13_other_services(row):
    """Extract all B13 other services sub-sections."""
    result = {}

    # B13a - Acupuncture (supplemental)
    b13a = extract_supplemental_benefit(row, "pbp_b13a", "Acupuncture (Supplemental)")
    if b13a:
        result["acupuncture_supplemental"] = b13a

    # B13b - OTC Items
    otc = safe_get(row, "pbp_b13b_bendesc_otc")
    if otc:
        b13b = {"label": "Over-The-Counter (OTC) Items"}
        b13b_amo = safe_get(row, "pbp_b13b_bendesc_amo")
        if b13b_amo:
            b13b["benefit_type"] = BENEFIT_TYPE_MAP.get(b13b_amo, b13b_amo)
        maxplan = yn(safe_get(row, "pbp_b13b_maxplan_yn"))
        if maxplan:
            b13b["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13b_maxplan_amt"))
            per = safe_get(row, "pbp_b13b_otc_maxplan_per")
            if per:
                b13b["max_plan_benefit_period"] = PERIODICITY_MAP.get(per, per)
        # Delivery mode (5-char bitmask; "Other" pairs with free-text mode_desc).
        mode_bitmask = safe_get(row, "pbp_b13b_mode")
        if mode_bitmask:
            mode_desc = safe_get(row, "pbp_b13b_mode_desc")
            delivery_mode = decode_otc_mode(mode_bitmask, mode_desc)
            if delivery_mode:
                b13b["otc_delivery_mode"] = delivery_mode
        result["otc_items"] = clean_dict(b13b)

    # B13c - Meals. Section 13c is the "limited duration" meal benefit; the
    # meal_type_chk flag string says which situation(s) it covers (a plan can
    # check any combination) — surface it so the card isn't a generic "Meals".
    if yn(safe_get(row, "pbp_b13c_bendesc_service")):
        b13c = {"label": "Meal Benefit"}
        b13c_amo = safe_get(row, "pbp_b13c_bendesc_amo")
        if b13c_amo:
            b13c["benefit_type"] = BENEFIT_TYPE_MAP.get(b13c_amo, b13c_amo)
        # meal_type_chk: 3-char flag, position 1 = homebound medical condition,
        # 2 = after surgery/hospitalization (post-discharge), 3 = chronic illness.
        mt = safe_get(row, "pbp_b13c_meal_type_chk")
        types = [lbl for i, lbl in enumerate(MEAL_TYPE_LABELS) if i < len(mt) and mt[i] == "1"]
        if types:
            b13c["meal_types"] = " or ".join(types)
        maxplan = yn(safe_get(row, "pbp_b13c_maxplan_yn"))
        if maxplan:
            b13c["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13c_maxplan_amt"))
        copay = dollar_range(
            safe_get(row, "pbp_b13c_copay_amt_min"),
            safe_get(row, "pbp_b13c_copay_amt_max"),
        )
        if copay:
            b13c["copay"] = copay
        elif yn(safe_get(row, "pbp_b13c_copay_yn")) is False and yn(safe_get(row, "pbp_b13c_coins_yn")) is False:
            b13c["copay"] = "$0"  # both cost-share flags "No" = $0 to the member
        auth = auth_text(safe_get(row, "pbp_b13c_auth_yn"))
        if auth:
            b13c["prior_auth_required"] = auth
        result["meals"] = clean_dict(b13c)

    # B13d - Home-Based Palliative Care / Other 1
    d_svc = safe_get(row, "pbp_b13d_bendesc_service")
    if d_svc:
        b13d = {"label": d_svc if d_svc else "Other Services 1"}
        b13d_amo = safe_get(row, "pbp_b13d_bendesc_amo")
        if b13d_amo:
            b13d["benefit_type"] = BENEFIT_TYPE_MAP.get(b13d_amo, b13d_amo)
        maxplan = yn(safe_get(row, "pbp_b13d_maxplan_yn"))
        if maxplan:
            b13d["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13d_maxplan_amt"))
        copay = dollar_range(
            safe_get(row, "pbp_b13d_copay_amt_min"),
            safe_get(row, "pbp_b13d_copay_amt_max"),
        )
        if copay:
            b13d["copay"] = copay
        result["other_services_1"] = clean_dict(b13d)

    # B13e - Caregiver Support / Other 2
    e_svc = safe_get(row, "pbp_b13e_bendesc_service")
    if e_svc:
        b13e = {"label": e_svc if e_svc else "Other Services 2"}
        b13e_amo = safe_get(row, "pbp_b13e_bendesc_amo")
        if b13e_amo:
            b13e["benefit_type"] = BENEFIT_TYPE_MAP.get(b13e_amo, b13e_amo)
        maxplan = yn(safe_get(row, "pbp_b13e_maxplan_yn"))
        if maxplan:
            b13e["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13e_maxplan_amt"))
        copay = dollar_range(
            safe_get(row, "pbp_b13e_copay_amt_min"),
            safe_get(row, "pbp_b13e_copay_amt_max"),
        )
        if copay:
            b13e["copay"] = copay
        result["other_services_2"] = clean_dict(b13e)

    # B13f - In-Home Support / Other 3
    f_svc = safe_get(row, "pbp_b13f_bendesc_service")
    if f_svc:
        b13f = {"label": f_svc if f_svc else "Other Services 3"}
        b13f_amo = safe_get(row, "pbp_b13f_bendesc_amo")
        if b13f_amo:
            b13f["benefit_type"] = BENEFIT_TYPE_MAP.get(b13f_amo, b13f_amo)
        maxplan = yn(safe_get(row, "pbp_b13f_maxplan_yn"))
        if maxplan:
            b13f["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13f_maxplan_amt"))
        copay = dollar_range(
            safe_get(row, "pbp_b13f_copay_amt_min"),
            safe_get(row, "pbp_b13f_copay_amt_max"),
        )
        if copay:
            b13f["copay"] = copay
        result["other_services_3"] = clean_dict(b13f)

    # B13g - D-SNP Hospice/Highly Integrated Services
    attest = safe_get(row, "pbp_b13g_attestation")
    if attest:
        b13g = {"label": "D-SNP Highly Integrated Services"}
        svc_name = safe_get(row, "pbp_b13g_bendesc_service")
        if svc_name:
            b13g["service_name"] = svc_name
        b13g_amo = safe_get(row, "pbp_b13g_bendesc_amo")
        if b13g_amo:
            b13g["benefit_type"] = BENEFIT_TYPE_MAP.get(b13g_amo, b13g_amo)
        maxplan = yn(safe_get(row, "pbp_b13g_maxplan_yn"))
        if maxplan:
            b13g["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b13g_maxplan_amt"))
        result["dsnp_integrated_services"] = clean_dict(b13g)

    return result


def extract_b13i_ssbci(row):
    """Extract detailed SSBCI (Special Supplemental Benefits for the Chronically Ill)."""
    result = {"label": "Social Support Services (SSBCI)"}

    # Food/Produce
    food = extract_supplemental_benefit(row, "pbp_b13i_fd", "Food & Produce")
    if food:
        result["food_produce"] = food

    # Meals
    meals = extract_supplemental_benefit(row, "pbp_b13i_ml", "Meals")
    if meals:
        result["meals"] = meals

    # Pest Control
    pest = extract_supplemental_benefit(row, "pbp_b13i_ps", "Pest Control")
    if pest:
        result["pest_control"] = pest

    # Transportation
    trans = extract_supplemental_benefit(row, "pbp_b13i_t", "Transportation")
    if trans:
        # Merge transport-specific _pal/_al fields
        transport_details = extract_transport_details(row, "pbp_b13i_t")
        if transport_details:
            trans.update(transport_details)
        result["transportation"] = trans

    # Indoor Air Quality
    air = extract_supplemental_benefit(row, "pbp_b13i_air", "Indoor Air Quality")
    if air:
        result["indoor_air_quality"] = air

    # Social Needs
    socn = extract_supplemental_benefit(row, "pbp_b13i_socn", "Social Needs")
    if socn:
        result["social_needs"] = socn

    # Complementary Therapies
    cmptx = extract_supplemental_benefit(row, "pbp_b13i_cmptx", "Complementary Therapies")
    if cmptx:
        result["complementary_therapies"] = cmptx

    # Self-Directed
    selfd = extract_supplemental_benefit(row, "pbp_b13i_selfd", "Self-Directed Care")
    if selfd:
        result["self_directed"] = selfd

    # Home Modifications
    home = extract_supplemental_benefit(row, "pbp_b13i_home", "Home Modifications")
    if home:
        result["home_modifications"] = home

    # Boolean summary flags
    # No suppt_<x>_yn summary toggles exist; presence is signaled by each
    # sub-benefit's own gate (meals has no _bendesc_yn, uses _bendesc_service).
    result["food_benefit"] = yn(safe_get(row, "pbp_b13i_fd_bendesc_yn"))
    result["meals_benefit"] = True if safe_get(row, "pbp_b13i_ml_bendesc_service") else None
    result["pest_control_benefit"] = yn(safe_get(row, "pbp_b13i_ps_bendesc_yn"))
    result["transportation_benefit"] = yn(safe_get(row, "pbp_b13i_t_bendesc_yn"))
    result["utility_assistance"] = yn(safe_get(row, "pbp_b13i_suppt_utility_yn"))
    result["housing_support"] = yn(safe_get(row, "pbp_b13i_suppt_housing_yn"))

    return clean_dict(result)


def extract_combined_benefits(row):
    """Extract combined / shared-wallet benefit groups from Section D.

    CMS Section D pbp_d_combo_* fields describe a single allowance shared across
    multiple supplemental benefit categories (e.g., a Flex card that covers OTC +
    food + utilities under one monthly dollar cap). Without this, per-item caps
    show as $0 because the real dollars live in the combined group.
    """
    if yn(safe_get(row, "pbp_d_combo_supp_ben_yn")) is not True:
        return None

    groups = []
    for i in range(1, 6):
        name = safe_get(row, f"pbp_d_combo_grp_name_{i}")
        cats = safe_get(row, f"pbp_d_combo_nmc_cats_{i}")
        if not name and not cats:
            continue
        grp = {}
        if name:
            grp["name"] = name
        if cats:
            grp["categories"] = [label_category(c) for c in cats.replace(";", " ").split() if c]
        # Shared dollar allowance for the group
        if yn(safe_get(row, f"pbp_d_combo_max_plan_ben_yn_{i}")):
            amt = to_dollar(safe_get(row, f"pbp_d_combo_max_plan_ben_amt_{i}"))
            if amt:
                grp["max_plan_benefit"] = amt
            per = safe_get(row, f"pbp_d_combo_max_plan_period_{i}")
            if per:
                grp["max_plan_benefit_period"] = PERIODICITY_MAP.get(per, per)
        else:
            grp["no_dollar_cap"] = True
        mode = safe_get(row, f"pbp_d_combo_mode_{i}")
        if mode:
            labels = ["Other", "Catalogue Purchase", "Claims Processing", "Debit Card", "Reimbursement"]
            picked = [labels[j] for j, ch in enumerate(mode) if j < len(labels) and ch == "1"]
            if picked:
                grp["delivery_mode"] = ", ".join(picked)
        prd_d = safe_get(row, f"pbp_d_combo_max_plan_prd_d_{i}")
        if prd_d and prd_d.strip():
            grp["disbursement_note"] = prd_d.strip()
        groups.append(clean_dict(grp))

    return groups if groups else None


def extract_model_test(row):
    """Extract SSBCI / Uniform-Flexibility model-test participation flags (Section B19)."""
    ssbci = yn(safe_get(row, "pbp_b19a_ssbci_yn"))
    uf = yn(safe_get(row, "pbp_b19a_uf_yn"))
    if ssbci is None and uf is None:
        return None
    return {"ssbci": ssbci is True, "uniform_flexibility": uf is True}


def extract_vbid(data, plan_id):
    """Extract VBID / Uniform-Flexibility model-test packages.

    b19a = cost-sharing reduction packages, b19b = additional supplemental benefit
    packages (SSBCI/UF) with aggregate allowances. Targeted to chronically-ill or
    low-income enrollee cohorts; a plan can have several packages.
    """
    packages = []

    # b19a - cost-sharing reduction packages
    for _, row in get_plan_rows(data, "b19a", plan_id).iterrows():
        name = safe_get(row, "pbp_b19a_package_name")
        if not name:
            continue
        pkg = {"name": name, "category": "Cost-Sharing Reduction (Uniform Flexibility)"}
        ptype = safe_get(row, "pbp_b19a_package_type")
        if ptype:
            pkg["package_type"] = ptype
        red = safe_get(row, "pbp_b19a_red_bens")
        if red:
            pkg["reduced_benefits"] = red
        if yn(safe_get(row, "pbp_b19a_reduct_zero_yn")):
            pkg["reduced_to_zero"] = True
        elig = safe_get(row, "pbp_b19a_reduct_prereq_d") or safe_get(row, "pbp_b19a_reduct_prereq")
        if elig:
            pkg["eligibility"] = elig
        packages.append(clean_dict(pkg))

    # b19b - additional supplemental benefit packages
    for _, row in get_plan_rows(data, "b19b", plan_id).iterrows():
        name = safe_get(row, "pbp_b19b_package_name")
        if not name:
            continue
        pkg = {"name": name, "category": "Supplemental Benefit Package (SSBCI/UF)"}
        ptype = safe_get(row, "pbp_b19b_package_type")
        if ptype:
            pkg["package_type"] = ptype
        if yn(safe_get(row, "pbp_b19b_agg_yn")):
            # agg_yn=1 with a $0.00 amount is an unpopulated placeholder (the real
            # wallet value is funded outside b19b); rendering "$0" reads as no
            # allowance, so treat zero as absent.
            amt = to_dollar(safe_get(row, "pbp_b19b_agg_amt")) if to_float(safe_get(row, "pbp_b19b_agg_amt")) else None
            if amt:
                per = safe_get(row, "pbp_b19b_agg_period")
                if per:
                    amt += f" ({PERIODICITY_MAP.get(per, per)})"
                pkg["aggregate_allowance"] = amt
        cats = safe_get(row, "pbp_b19b_add_nmc_bendesc_cats")
        if cats:
            pkg["benefit_categories"] = [label_category(c) for c in cats.replace(";", " ").split() if c]
        elig = safe_get(row, "pbp_b19b_add_prereq_d") or safe_get(row, "pbp_b19b_add_prereq")
        if elig:
            pkg["eligibility"] = elig
        packages.append(clean_dict(pkg))

    if packages:
        return {"label": "VBID / Special Supplemental Packages", "packages": packages}
    return None


def extract_b14_preventive(row):
    """Extract all preventive service sub-sections."""
    result = {}

    # B14a - Medicare-covered preventive attestation
    attest = safe_get(row, "pbp_b14a_mc_prevent_attest")
    if attest:
        result["preventive_attestation"] = {"label": "Medicare Preventive", "zero_cost_attestation": yn(attest)}
    auth = safe_get(row, "pbp_b14a_auth_yn")
    if auth:
        result.setdefault("preventive_attestation", {})["prior_auth_required"] = AUTH_MAP.get(auth, yn(auth))

    # B14b - Annual Physical Exam
    b14b = extract_supplemental_benefit(row, "pbp_b14b", "Annual Physical Exam")
    if b14b:
        result["annual_physical"] = b14b

    # B14c - Additional Preventive Services
    bendesc = yn(safe_get(row, "pbp_b14c_bendesc_yn"))
    if bendesc:
        prev_supp = {"label": "Additional Preventive Services"}
        # CMS encodes the sub-types as suffixes on pbp_b14c_* (NOT numbered b14c1..22).
        # Presence is signalled by bendesc_amo_<sfx>; cost-sharing is suffix-coded.
        # NOTE: 'mhc' (14c4, legacy "membership health club" suffix) is the Fitness
        # Benefit per the 2026 dictionary — extracted top-level as benefits["fitness"]
        # below, NOT here. It was previously mislabeled "Mental Health Counseling".
        B14C_SUBTYPES = [
            ("hec", "Health Education"), ("ntb", "Nutritional/Tobacco Counseling"),
            ("sc", "Smoking & Tobacco Cessation"),
            ("edm", "Enhanced Disease Management"), ("tm", "Telemonitoring Services"),
            ("rat", "Remote Access Technologies"), ("bsd", "Bathroom Safety Devices"),
            ("cs", "Counseling Services"), ("isa", "In-Home Safety Assessment"),
            ("prs", "Personal Emergency Response System"), ("mnt", "Medical Nutrition Therapy"),
            ("imr", "Immunizations"), ("rp", "Restorative Programs"),
            ("wig", "Wigs"), ("wm", "Weight Management Programs"),
            ("at", "Assistive Technology"), ("thmg", "Therapeutic Massage"),
            ("adcs", "Adult Day Care Services"), ("hbpc", "Home-Based Palliative Care"),
            ("ihss", "In-Home Support Services"), ("sce", "Structured Exercise/Community"),
        ]
        # Limit-bearing sub-types (Tier 3 gap map): these three suffixes file a
        # "Benefit Unlimited Component" (lim + count), but the count field name
        # is irregular per suffix and NONE of them file a per-suffix periodicity
        # field (no bendesc_per_{at,ntb,cs} exists in the 2026 dictionary — only
        # the maxplan_per_* dollar-allowance period, handled generically below).
        B14C_LIMIT_FIELDS = {
            "at": dict(lim_field="pbp_b14c_bendesc_lim_at", num_field="pbp_b14c_at_visits", per_field="pbp_b14c_bendesc_per_at"),
            "ntb": dict(lim_field="pbp_b14c_bendesc_lim_ntb", num_field="pbp_b14c_bendesc_num_ntb", per_field="pbp_b14c_bendesc_per_ntb"),
            "cs": dict(lim_field="pbp_b14c_bendesc_lim_cs", num_field="pbp_b14c_bendesc_num_cs", per_field="pbp_b14c_bendesc_per_cs"),
        }
        subs = []
        for sfx, name in B14C_SUBTYPES:
            amo = safe_get(row, f"pbp_b14c_bendesc_amo_{sfx}")
            copay = dollar_range(
                safe_get(row, f"pbp_b14c_copay_{sfx}_min_amt"),
                safe_get(row, f"pbp_b14c_copay_{sfx}_max_amt"),
            )
            coins = pct_range(
                safe_get(row, f"pbp_b14c_coins_pct_min_{sfx}"),
                safe_get(row, f"pbp_b14c_coins_pct_max_{sfx}"),
            )
            # maxplan suffix is 'thms' for therapeutic massage, else same suffix
            mp_sfx = "thms" if sfx == "thmg" else sfx
            maxplan = to_dollar(safe_get(row, f"pbp_b14c_maxplan_amt_{mp_sfx}"))
            maxplan_period = None
            if maxplan:
                per = safe_get(row, f"pbp_b14c_maxplan_per_{mp_sfx}")
                if per:
                    maxplan_period = PERIODICITY_MAP.get(per, per)
            limit = {}
            if sfx in B14C_LIMIT_FIELDS:
                limit = extract_benefit_limit(row, "pbp_b14c", f"_{sfx}", **B14C_LIMIT_FIELDS[sfx])
            if not (amo or copay or coins or maxplan or limit):
                continue
            sub = {"label": name}
            if amo:
                sub["benefit_type"] = BENEFIT_TYPE_MAP.get(amo, amo)
            if maxplan:
                sub["max_plan_benefit"] = maxplan
                if maxplan_period:
                    sub["max_plan_benefit_period"] = maxplan_period
            if copay:
                sub["copay"] = copay
            if coins:
                sub["coinsurance"] = coins
            sub.update(limit)
            subs.append(clean_dict(sub))
        if subs:
            prev_supp["sub_types"] = subs
        result["additional_preventive"] = clean_dict(prev_supp)

    # B14c-4 - Fitness Benefit (column suffix 'mhc' — legacy CMS naming; per the 2026
    # dictionary this service category is "Fitness Benefit", not mental health).
    fit_amo = safe_get(row, "pbp_b14c_bendesc_amo_mhc")
    if fit_amo:
        fitness = {"label": "Fitness Benefit"}
        fitness["benefit_type"] = BENEFIT_TYPE_MAP.get(fit_amo, fit_amo)
        # bendesc_typ_mhc is a 3-char flag string: pos 1 = Activity Tracker,
        # pos 2 = Physical Fitness, pos 3 = Memory Fitness (e.g. "010").
        typ = safe_get(row, "pbp_b14c_bendesc_typ_mhc")
        FITNESS_TYPE_LABELS = ["Activity Tracker", "Physical Fitness", "Memory Fitness"]
        types = [name for flag, name in zip(typ, FITNESS_TYPE_LABELS) if flag == "1"]
        if types:
            fitness["fitness_types"] = ", ".join(types)
        copay = dollar_range(
            safe_get(row, "pbp_b14c_copay_mhc_min_amt"),
            safe_get(row, "pbp_b14c_copay_mhc_max_amt"),
        )
        if copay:
            fitness["copay"] = copay
        coins = pct_range(
            safe_get(row, "pbp_b14c_coins_pct_min_mhc"),
            safe_get(row, "pbp_b14c_coins_pct_max_mhc"),
        )
        if coins:
            fitness["coinsurance"] = coins
        maxplan = to_dollar(safe_get(row, "pbp_b14c_maxplan_amt_mhc"))
        if maxplan:
            fitness["max_plan_benefit"] = maxplan
            per = safe_get(row, "pbp_b14c_maxplan_per_mhc")
            if per:
                fitness["max_plan_benefit_period"] = PERIODICITY_MAP.get(per, per)
        maxenr = to_dollar(safe_get(row, "pbp_b14c_maxenr_amt_mhc"))
        if maxenr:
            fitness["max_enrollee_cost"] = maxenr
        result["fitness"] = clean_dict(fitness)

    # B14d - Kidney Disease Education
    b14d = extract_simple_benefit(row, "pbp_b14d", "Kidney Disease Education")
    if b14d and len(b14d) > 1:
        result["kidney_disease_education"] = b14d

    # B14e - Other Medicare-Covered Preventive (per-service: glaucoma, diabetes, prostate, EKG)
    b14e = {"label": "Other Medicare Preventive Services"}
    B14E_SERVICES = [
        ("glauc", "Glaucoma Screening"), ("diab", "Diabetes Screening"),
        ("dre", "Prostate/Digital Rectal Exam"), ("ekg", "EKG Screening"),
    ]
    e_subs = []
    for svc, lbl in B14E_SERVICES:
        copay = dollar_range(
            safe_get(row, f"pbp_b14e_copay_amt_min_{svc}"),
            safe_get(row, f"pbp_b14e_copay_amt_max_{svc}"),
        )
        coins = pct_range(
            safe_get(row, f"pbp_b14e_coins_pct_min_{svc}"),
            safe_get(row, f"pbp_b14e_coins_pct_max_{svc}"),
        )
        auth = yn(safe_get(row, f"pbp_b14e_auth_yn_{svc}"))
        if not (copay or coins or auth):
            continue
        sub = {"label": lbl}
        if copay:
            sub["copay"] = copay
        if coins:
            sub["coinsurance"] = coins
        if auth is not None:
            sub["prior_auth_required"] = auth
        e_subs.append(clean_dict(sub))
    if e_subs:
        b14e["sub_types"] = e_subs
        result["other_medicare_preventive"] = clean_dict(b14e)

    return result


def extract_b20_enhanced_drug(row):
    """Extract enhanced prescription drug (Non-Part D) with per-group details."""
    result = {"label": "Enhanced Prescription Drug (Non-Part D)"}

    # Overall cost sharing
    attest = safe_get(row, "pbp_b20_cost_share_attest")
    if attest:
        result["cost_share_attestation"] = yn(attest)

    # Max plan benefit
    maxplan = yn(safe_get(row, "pbp_b20_maxplan_yn"))
    if maxplan:
        result["max_plan_benefit"] = to_dollar(safe_get(row, "pbp_b20_maxplan_amt"))

    # Max enrollee cost
    maxenr = yn(safe_get(row, "pbp_b20_maxenr_yn"))
    if maxenr:
        result["max_enrollee_cost"] = to_dollar(safe_get(row, "pbp_b20_maxenr_amt"))

    # Deductible
    ded = yn(safe_get(row, "pbp_b20_ded_yn"))
    if ded is not None:
        result["deductible_applies"] = ded
        result["deductible_amount"] = to_dollar(safe_get(row, "pbp_b20_ded_amt"))

    # Overall coinsurance/copay (mc family)
    if yn(safe_get(row, "pbp_b20_coins_mc_yn")):
        result["coinsurance"] = to_pct(safe_get(row, "pbp_b20_coins_mc_pct"))
    if yn(safe_get(row, "pbp_b20_copay_mc_yn")):
        result["copay"] = dollar_range(
            safe_get(row, "pbp_b20_copay_min_mc_amt"),
            safe_get(row, "pbp_b20_copay_max_mc_amt"),
        )

    # Per-group details (up to 5 groups)
    groups = []
    for grp in range(1, 6):
        name = safe_get(row, f"pbp_b20_grp{grp}_name")
        if not name:
            continue
        g = {"name": name}
        label = safe_get(row, f"pbp_b20_grp{grp}_label")
        if label:
            g["label"] = label
        # Drug types
        drug_types = safe_get(row, f"pbp_b20_grp{grp}_drug_types")
        if drug_types:
            g["drug_types"] = drug_types
        # Max plan benefit for group (period-keyed amount)
        grp_max = to_dollar(
            safe_get(row, f"pbp_b20_grp{grp}_maxplan_amt_1yr")
            or safe_get(row, f"pbp_b20_grp{grp}_maxplan_amt_6mth")
            or safe_get(row, f"pbp_b20_grp{grp}_maxplan_amt_3mth")
            or safe_get(row, f"pbp_b20_grp{grp}_maxplan_amt_1mth")
            or safe_get(row, f"pbp_b20_grp{grp}_maxplan_amt_oth")
        )
        if grp_max:
            g["max_plan_benefit"] = grp_max
        # Coinsurance by pharmacy type
        coins_drp = to_pct(safe_get(row, f"pbp_b20_grp{grp}_coins_pct_drp"))
        if coins_drp:
            g["coinsurance_retail"] = coins_drp
        coins_mo = to_pct(safe_get(row, f"pbp_b20_grp{grp}_coins_pct_mo"))
        if coins_mo:
            g["coinsurance_mail"] = coins_mo
        # Copay by pharmacy type
        copay_drp = to_dollar(safe_get(row, f"pbp_b20_grp{grp}_copay_drp_amt"))
        if copay_drp:
            g["copay_retail"] = copay_drp
        copay_mo = to_dollar(safe_get(row, f"pbp_b20_grp{grp}_copay_mo_amt"))
        if copay_mo:
            g["copay_mail"] = copay_mo
        groups.append(clean_dict(g))
    if groups:
        result["drug_groups"] = groups

    return clean_dict(result) if len(result) > 1 else None


# ---------------------------------------------------------------------------
# Step 1: Process geographic data
# ---------------------------------------------------------------------------

def process_geography():
    """Process PlanArea.txt and PlanRegionArea.txt into geo_index.json and states.json."""
    print("Processing geographic data...")

    geo_index = defaultdict(lambda: defaultdict(set))
    states_counties = defaultdict(set)

    # Process PlanArea.txt in chunks (large file). The in-repo copy ships as
    # PlanArea.txt.gz (the raw 158MB file exceeds GitHub's 100MB limit);
    # pandas decompresses .gz transparently, so prefer .txt, fall back to .gz.
    path = BASE_DIR / "PlanArea.txt"
    if not path.exists() and (BASE_DIR / "PlanArea.txt.gz").exists():
        path = BASE_DIR / "PlanArea.txt.gz"
    if path.exists():
        chunk_count = 0
        for chunk in pd.read_csv(path, sep="\t", dtype=str, na_values=[""],
                                  keep_default_na=True, chunksize=50000, low_memory=False,
                                  encoding="latin-1"):
            chunk = chunk.fillna("")
            for _, row in chunk.iterrows():
                state = str(row.get("stcd", "")).strip()
                county = str(row.get("county", "")).strip()
                h = str(row.get("pbp_a_hnumber", "")).strip()
                p = str(row.get("pbp_a_plan_identifier", "")).strip()
                s = str(row.get("segment_id", "")).strip()
                if state and county and h:
                    plan_id = f"{h}_{p}_{s}"
                    geo_index[state][county].add(plan_id)
                    states_counties[state].add(county)
            chunk_count += 1
            if chunk_count % 10 == 0:
                print(f"  PlanArea: processed {chunk_count * 50000:,} rows...")
        print(f"  PlanArea: done ({chunk_count * 50000:,} rows)")
    else:
        print("  WARNING: PlanArea.txt not found")

    # Process PlanRegionArea.txt (small file)
    region_df = read_txt("PlanRegionArea.txt")
    if not region_df.empty:
        for _, row in region_df.iterrows():
            region = safe_get(row, "region")
            h = safe_get(row, "pbp_a_hnumber")
            p = safe_get(row, "pbp_a_plan_identifier")
            s = safe_get(row, "segment_id")
            if region and h:
                plan_id = f"{h}_{p}_{s}"
                # Store regional plans under a special key
                geo_index["_REGIONAL"][region].add(plan_id)
        print(f"  PlanRegionArea: {len(region_df)} rows")

    # Convert sets to sorted lists for JSON
    geo_out = {}
    for state, counties in sorted(geo_index.items()):
        geo_out[state] = {}
        for county, plans in sorted(counties.items()):
            geo_out[state][county] = sorted(plans)

    states_out = []
    for code in sorted(states_counties.keys()):
        states_out.append({
            "code": code,
            "name": STATE_NAMES.get(code, code),
            "counties": sorted(states_counties[code]),
        })

    # Write output
    with open(OUT_DIR / "geo_index.json", "w") as f:
        json.dump(geo_out, f, separators=(",", ":"))
    print(f"  Wrote geo_index.json ({len(geo_out)} states/territories)")

    with open(OUT_DIR / "states.json", "w") as f:
        json.dump(states_out, f, indent=1)
    print(f"  Wrote states.json ({len(states_out)} entries)")

    return geo_out


# ---------------------------------------------------------------------------
# Step 2: Process plan identity (Section A) and costs (Section D)
# ---------------------------------------------------------------------------

def process_plans_summary():
    """Process Section A and Section D into plans_summary.json. Returns plan_ids dict."""
    print("Processing plan summary (Section A + Section D)...")

    # Section A - identity
    a_df = read_txt("pbp_Section_A.txt")
    if a_df.empty:
        print("  ERROR: Section A is empty")
        return {}

    plans = {}
    for _, row in a_df.iterrows():
        pid = make_plan_id(row)
        plan_type_code = safe_get(row, "pbp_a_plan_type")
        snp_flag = yn(safe_get(row, "pbp_a_special_need_flag"))
        snp_type_code = safe_get(row, "pbp_a_special_need_plan_type")

        dsnp_type_code = safe_get(row, "pbp_a_dsnp_zerodollar") if snp_flag else ""
        snp_cond = safe_get(row, "pbp_a_snp_cond")

        plans[pid] = {
            "plan_id": pid,
            "h_number": safe_get(row, "pbp_a_hnumber"),
            "plan_identifier": safe_get(row, "pbp_a_plan_identifier"),
            "segment_id": safe_get(row, "segment_id"),
            "plan_name": safe_get(row, "pbp_a_plan_name"),
            "org_name": safe_get(row, "pbp_a_org_name"),
            "org_marketing_name": safe_get(row, "pbp_a_org_marketing_name"),
            "plan_type_code": plan_type_code,
            "plan_type": PLAN_TYPE_MAP.get(plan_type_code, plan_type_code),
            "is_snp": snp_flag or False,
            "snp_type": SNP_TYPE_MAP.get(snp_type_code, "") if snp_flag else "",
            "snp_chronic_conditions": snp_cond if snp_cond else None,
            "dsnp_zero_dollar": yn(dsnp_type_code) if dsnp_type_code else None,
            "eghp": yn(safe_get(row, "pbp_a_eghp_yn")) or False,
            "part_d": yn(safe_get(row, "pbp_a_contract_partd_flag")),
            "org_website": safe_get(row, "pbp_a_org_website") or None,
            "pharmacy_website": safe_get(row, "pbp_a_pharmacy_website") or None,
            "formulary_website": safe_get(row, "pbp_a_formulary_web_addr") or None,
            "member_phone": safe_get(row, "pbp_a_curmbr_phone") or None,
            "prospective_phone": safe_get(row, "pbp_a_prombr_phone") or None,
        }

    print(f"  Section A: {len(plans)} plans")

    # Section D - costs
    d_df = read_txt("pbp_Section_D.txt")
    if not d_df.empty:
        for _, row in d_df.iterrows():
            pid = make_plan_id(row)
            if pid in plans:
                plans[pid]["premium"] = to_float(safe_get(row, "pbp_d_mplusc_premium"))
                plans[pid]["premium_display"] = to_dollar(safe_get(row, "pbp_d_mplusc_premium"))
                plans[pid]["part_b_premium"] = to_dollar(safe_get(row, "pbp_d_mplusc_bonly_premium"))
                # A dollar amount is only filed for deductible type 4 ("Other");
                # types 1-3 are Medicare-defined amounts with no amount column.
                ded_disp = to_dollar(safe_get(row, "pbp_d_ann_deduct_amt"))
                ded_type = safe_get(row, "pbp_d_ann_deduct_amt_type")
                if not ded_disp and ded_type in DEDUCTIBLE_TYPE_AMOUNTS:
                    ded_disp = DEDUCTIBLE_TYPE_AMOUNTS[ded_type]
                plans[pid]["deductible"] = ded_disp
                if ded_type:
                    plans[pid]["deductible_type"] = DEDUCTIBLE_TYPE_MAP.get(ded_type, ded_type)
                plans[pid]["has_deductible"] = yn(safe_get(row, "pbp_d_ann_deduct_yn"))
                # MOOP - in-network amount, plus the combined in+OON amount when
                # both are filed (PPOs); combined-only plans fall back to combined.
                moop = safe_get(row, "pbp_d_out_pocket_amt")
                comb = safe_get(row, "pbp_d_comb_max_enr_amt")
                if not moop:
                    moop, comb = comb, ""
                plans[pid]["moop"] = to_float(moop)
                plans[pid]["moop_display"] = to_dollar(moop)
                if comb:
                    plans[pid]["moop_combined"] = to_float(comb)
                    plans[pid]["moop_combined_display"] = to_dollar(comb)
                # Part B reduction
                plans[pid]["part_b_reduction"] = to_dollar(safe_get(row, "pbp_d_mco_pay_reduct_amt"))
        print(f"  Section D: merged costs for {len(d_df)} rows")

    # Set defaults for plans missing Section D data
    for pid, p in plans.items():
        p.setdefault("premium", None)
        p.setdefault("premium_display", None)
        p.setdefault("deductible", None)
        p.setdefault("moop", None)
        p.setdefault("moop_display", None)

    # Write summary
    with open(OUT_DIR / "plans_summary.json", "w") as f:
        json.dump(plans, f, separators=(",", ":"))
    print(f"  Wrote plans_summary.json ({len(plans)} plans)")

    return plans


# ---------------------------------------------------------------------------
# Step 3: Process all benefit files into per-plan data
# ---------------------------------------------------------------------------

def load_all_benefit_data():
    """Load all benefit .txt files into DataFrames indexed by plan_id."""
    print("Loading all benefit files...")
    data = {}

    # Each entry: (variable_name, filename, description)
    files_to_load = [
        # Section C - Network
        ("section_c", "pbp_Section_C.txt"),
        ("section_c_oon", "pbp_Section_C_OON.txt"),
        ("section_c_pos", "pbp_Section_C_POS.txt"),
        # Section D extras
        ("section_d", "pbp_Section_D.txt"),
        ("section_d_opt", "pbp_Section_D_opt.txt"),
        ("section_d_oon", "pbp_Section_D_OON.txt"),
        # B1 - Inpatient
        ("b1a", "pbp_b1a_inpat_hosp.txt"),
        ("b1b", "pbp_b1b_inpat_hosp.txt"),
        # B2 - SNF
        ("b2", "pbp_b2_snf.txt"),
        # B3 - Cardiac rehab
        ("b3", "pbp_b3_cardiac_rehab.txt"),
        # B4 - Emergency/urgent
        ("b4", "pbp_b4_emerg_urgent.txt"),
        # B5 - Partial hospitalization
        ("b5", "pbp_b5_partial_hosp.txt"),
        # B6 - Home health
        ("b6", "pbp_b6_home_health.txt"),
        # B7 - Health professionals
        ("b7", "pbp_b7_health_prof.txt"),
        # B8 - Clinical/diagnostic
        ("b8", "pbp_b8_clin_diag_ther.txt"),
        # B9 - Outpatient hospital
        ("b9", "pbp_b9_outpat_hosp.txt"),
        # B10 - Ambulance/transportation
        ("b10", "pbp_b10_amb_trans.txt"),
        # B11 - DME
        ("b11", "pbp_b11_dme_prosth_orth_sup.txt"),
        # B12 - Renal dialysis
        ("b12", "pbp_b12_renal_dialysis.txt"),
        # B13 - Other services
        ("b13", "pbp_b13_other_services.txt"),
        # B13i - Social supports (SSBCI)
        ("b13i", "pbp_b13i_b19b_services_vbid_ssbci.txt"),
        ("b13i_other", "pbp_b13i_b19b_other_services_vbid_ssbci.txt"),
        # B14 - Preventive
        ("b14", "pbp_b14_preventive.txt"),
        # B15 - Part B drugs
        ("b15", "pbp_b15_partb_rx_drugs.txt"),
        # B16 - Dental
        ("b16", "pbp_b16_dental.txt"),
        # B17 - Eye/vision
        ("b17", "pbp_b17_eye_exams_wear.txt"),
        # B18 - Hearing
        ("b18", "pbp_b18_hearing_exams_aids.txt"),
        # B19 - Model test
        ("b19", "pbp_b19_model_test.txt"),
        ("b19a", "pbp_b19a_model_test_vbid_uf.txt"),
        ("b19b", "pbp_b19b_model_test_vbid_uf.txt"),
        # B20 - Enhanced drug
        ("b20", "pbp_b20.txt"),
        # MRx - Part D
        ("mrx", "pbp_mrx.txt"),
        ("mrx_tier", "pbp_mrx_tier.txt"),
        ("mrx_p", "pbp_mrx_p.txt"),
        # VBID
        ("vbid", "pbp_vbid.txt"),
        ("ds_vbid", "pbp_ds_vbid.txt"),
        # VBID/UF variants
        ("b1a_vbid_a", "pbp_b1a_b19a_inpat_hosp_vbid_uf.txt"),
        ("b1a_vbid_b", "pbp_b1a_b19b_inpat_hosp_vbid_uf.txt"),
        ("b1b_vbid_a", "pbp_b1b_b19a_inpat_hosp_vbid_uf.txt"),
        ("b1b_vbid_b", "pbp_b1b_b19b_inpat_hosp_vbid_uf.txt"),
        ("b2_vbid_a", "pbp_b2_b19a_snf_vbid_uf.txt"),
        ("b2_vbid_b", "pbp_b2_b19b_snf_vbid_uf.txt"),
        ("b3_vbid_b", "pbp_b3_b19b_cardiac_rehab_vbid_uf.txt"),
        ("b4_vbid_b", "pbp_b4_b19b_emerg_urgent_vbid_uf.txt"),
        ("b7_vbid_b", "pbp_b7_b19b_health_prof_vbid_uf.txt"),
        ("b10_vbid_b", "pbp_b10_b19b_amb_trans_vbid_uf.txt"),
        ("b13_vbid_b", "pbp_b13_b19b_other_services_vbid_uf.txt"),
        ("b14b_vbid", "pbp_b14b_b19b_preventive_vbid_uf.txt"),
        ("b14c_vbid", "pbp_b14c_b19b_preventive_vbid_uf.txt"),
        ("b16_vbid_b", "pbp_b16_b19b_dental_vbid_uf.txt"),
        ("b17_vbid_b", "pbp_b17_b19b_eye_exams_wear_vbid_uf.txt"),
        ("b18_vbid_b", "pbp_b18_b19b_hearing_exams_aids_vbid_uf.txt"),
        ("mrx_vbid", "pbp_mrx_vbid.txt"),
        ("mrx_tier_vbid", "pbp_mrx_tier_vbid.txt"),
        # Step-up files
        ("step1", "pbp_step1.txt"),
        ("step1_b", "pbp_step1_b.txt"),
        ("step2", "pbp_step2.txt"),
        ("step2_b", "pbp_step2_b.txt"),
        ("step3", "pbp_step3.txt"),
        ("step4", "pbp_step4.txt"),
        ("step7b", "pbp_step7b.txt"),
        ("step7f", "pbp_step7f.txt"),
        ("step10b", "pbp_step10b.txt"),
        ("step13", "pbp_step13.txt"),
        ("step14", "pbp_step14.txt"),
        ("step16", "pbp_step16.txt"),
        ("step17a", "pbp_step17a.txt"),
        ("step17b", "pbp_step17b.txt"),
        ("step18a", "pbp_step18a.txt"),
        ("step18b", "pbp_step18b.txt"),
        ("step18c", "pbp_step18c.txt"),
        ("step20", "pbp_step20.txt"),
    ]

    for key, filename in files_to_load:
        df = read_txt(filename)
        if not df.empty:
            # Add plan_id column for easy lookup
            df["_plan_id"] = df.apply(make_plan_id, axis=1)
            data[key] = df
            print(f"  {filename}: {len(df)} rows, {len(df.columns)} cols")
        else:
            data[key] = pd.DataFrame()

    return data


def get_plan_row(data, key, plan_id):
    """Get the row(s) for a plan from a benefit DataFrame."""
    df = data.get(key, pd.DataFrame())
    if df.empty or "_plan_id" not in df.columns:
        return None
    matches = df[df["_plan_id"] == plan_id]
    if matches.empty:
        return None
    return matches.iloc[0]


def get_plan_rows(data, key, plan_id):
    """Get all rows for a plan from a benefit DataFrame (for multi-row files like mrx_tier)."""
    df = data.get(key, pd.DataFrame())
    if df.empty or "_plan_id" not in df.columns:
        return pd.DataFrame()
    return df[df["_plan_id"] == plan_id]


def build_plan_detail(plan_id, plans_summary, data):
    """Build the complete benefit detail JSON for a single plan."""
    summary = plans_summary.get(plan_id, {})
    detail = {
        "plan_id": plan_id,
        "plan_info": {
            "plan_name": summary.get("plan_name", ""),
            "org_name": summary.get("org_name", ""),
            "org_marketing_name": summary.get("org_marketing_name", ""),
            "plan_type": summary.get("plan_type", ""),
            "plan_type_code": summary.get("plan_type_code", ""),
            "is_snp": summary.get("is_snp", False),
            "snp_type": summary.get("snp_type", ""),
            "snp_chronic_conditions": summary.get("snp_chronic_conditions"),
            "dsnp_zero_dollar": summary.get("dsnp_zero_dollar"),
            "eghp": summary.get("eghp", False),
            "org_website": summary.get("org_website"),
            "pharmacy_website": summary.get("pharmacy_website"),
            "formulary_website": summary.get("formulary_website"),
            "member_phone": summary.get("member_phone"),
            "prospective_phone": summary.get("prospective_phone"),
        },
        "costs": {
            "monthly_premium": summary.get("premium_display"),
            "part_b_premium": summary.get("part_b_premium"),
            "annual_deductible": summary.get("deductible"),
            "annual_deductible_type": summary.get("deductible_type"),
            "max_out_of_pocket": summary.get("moop_display"),
            "max_out_of_pocket_combined": summary.get("moop_combined_display"),
            "part_b_reduction": summary.get("part_b_reduction"),
        },
    }

    # Section D optional supplements
    d_opt_row = get_plan_row(data, "section_d_opt", plan_id)
    if d_opt_row is not None:
        opt_name = safe_get(d_opt_row, "pbp_d_opt_name")
        opt_desc = safe_get(d_opt_row, "pbp_d_opt_description")
        if opt_name:
            opt = {
                "name": opt_name,
                "description": opt_desc,
            }
            opt_prem = to_dollar(safe_get(d_opt_row, "pbp_d_amt_opt_premium"))
            if opt_prem:
                opt["premium"] = opt_prem
            opt_max = yn(safe_get(d_opt_row, "pbp_d_opt_maxplan_ben_cov_yn"))
            if opt_max:
                opt["max_plan_benefit"] = to_dollar(safe_get(d_opt_row, "pbp_d_opt_maxplan_ben_cov_amt"))
            opt_ded = yn(safe_get(d_opt_row, "pbp_d_opt_deduct_yn"))
            if opt_ded is not None:
                opt["deductible_applies"] = opt_ded
                opt["deductible_amount"] = to_dollar(safe_get(d_opt_row, "pbp_d_opt_deduct_amt"))
            opt_moop = yn(safe_get(d_opt_row, "pbp_d_opt_apply_moop_yn"))
            if opt_moop is not None:
                opt["applies_to_moop"] = opt_moop
            detail["costs"]["optional_supplement"] = clean_dict(opt)

    # Network info from Section C
    c_row = get_plan_row(data, "section_c", plan_id)
    if c_row is not None:
        network = {
            "has_oon_coverage": yn(safe_get(c_row, "pbp_c_oon_yn")),
        }
        # OON benefit categories
        oon_bens = safe_get(c_row, "pbp_c_oon_bendesc_bens")
        if oon_bens:
            network["oon_benefit_categories"] = oon_bens
        # Visitor/Traveler benefits
        vt_yn = yn(safe_get(c_row, "pbp_c_vt_us_yn"))
        if vt_yn is not None:
            network["visitor_traveler_benefit"] = vt_yn
            vt_months = safe_get(c_row, "pbp_c_vt_us_mo")
            if vt_months:
                network["visitor_traveler_months"] = vt_months
        detail["network"] = clean_dict(network)

    # OON cost sharing from Section C OON
    c_oon_rows = get_plan_rows(data, "section_c_oon", plan_id)
    oon_groups = []
    # Inpatient acute (1a), inpatient psychiatric (1b), and SNF (2) OON
    # cost-sharing live on the main Section C row, not in the OON file.
    if c_row is not None:
        for grp_label, fam in (("1a", "iha"), ("1b", "iph"), ("2", "snf")):
            inpt_grp = extract_oon_inpatient_group(c_row, grp_label, fam)
            if inpt_grp:
                oon_groups.append(inpt_grp)
    if not c_oon_rows.empty:
        for _, oon_row in c_oon_rows.iterrows():
            grp = {}
            grp["label"] = safe_get(oon_row, "pbp_c_oon_outpt_grp_lbl")
            grp["copay"] = dollar_range(
                safe_get(oon_row, "pbp_c_oon_outpt_copay_min_amt"),
                safe_get(oon_row, "pbp_c_oon_outpt_copay_max_amt"),
            )
            grp["coinsurance"] = pct_range(
                safe_get(oon_row, "pbp_c_oon_outpt_coins_min_pct"),
                safe_get(oon_row, "pbp_c_oon_outpt_coins_max_pct"),
            )
            maxplan = yn(safe_get(oon_row, "pbp_c_oon_outpt_maxplan_yn"))
            if maxplan:
                grp["max_plan_benefit"] = to_dollar(safe_get(oon_row, "pbp_c_oon_outpt_maxplan_amt"))
            ded = yn(safe_get(oon_row, "pbp_c_oon_outpt_ded_yn"))
            if ded is not None:
                grp["deductible_applies"] = ded
                grp["deductible_amount"] = to_dollar(safe_get(oon_row, "pbp_c_oon_outpt_ded_amt"))
            oon_groups.append(clean_dict(grp))
    if oon_groups:
        detail.setdefault("network", {})["oon_cost_sharing"] = oon_groups

    # POS cost sharing from Section C POS
    c_pos_rows = get_plan_rows(data, "section_c_pos", plan_id)
    if not c_pos_rows.empty:
        pos_groups = []
        for _, pos_row in c_pos_rows.iterrows():
            grp = {}
            grp["label"] = safe_get(pos_row, "pbp_c_pos_group_lbl")
            grp["copay"] = dollar_range(
                safe_get(pos_row, "pbp_c_pos_outpt_copay_min_amt"),
                safe_get(pos_row, "pbp_c_pos_outpt_copay_max_amt"),
            )
            grp["coinsurance"] = pct_range(
                safe_get(pos_row, "pbp_c_pos_outpt_coins_min_pct"),
                safe_get(pos_row, "pbp_c_pos_outpt_coins_max_pct"),
            )
            maxplan = yn(safe_get(pos_row, "pbp_c_pos_outpt_maxplan_yn"))
            if maxplan:
                grp["max_plan_benefit"] = to_dollar(safe_get(pos_row, "pbp_c_pos_outpt_maxplan_amt"))
            ded = yn(safe_get(pos_row, "pbp_c_pos_outpt_deduct_yn"))
            if ded is not None:
                grp["deductible_applies"] = ded
                grp["deductible_amount"] = to_dollar(safe_get(pos_row, "pbp_c_pos_outpt_deduct_amt"))
            pos_groups.append(clean_dict(grp))
        if pos_groups:
            detail.setdefault("network", {})["pos_cost_sharing"] = pos_groups

    # ----- Benefits -----
    benefits = {}

    # B1a - Inpatient Acute
    b1a_row = get_plan_row(data, "b1a", plan_id)
    if b1a_row is not None:
        # Use step1 for detailed interval data
        step1_row = get_plan_row(data, "step1", plan_id)
        source = step1_row if step1_row is not None else b1a_row
        benefits["inpatient_acute"] = extract_inpatient(source, "pbp_b1a", "Inpatient Hospital (Acute)")

    # B1b - Inpatient Psychiatric
    b1b_row = get_plan_row(data, "b1b", plan_id)
    if b1b_row is not None:
        step1b_row = get_plan_row(data, "step1_b", plan_id)
        source = step1b_row if step1b_row is not None else b1b_row
        benefits["inpatient_psychiatric"] = extract_inpatient(source, "pbp_b1b", "Inpatient Hospital (Psychiatric)")

    # B2 - SNF
    b2_row = get_plan_row(data, "b2", plan_id)
    if b2_row is not None:
        benefits["skilled_nursing"] = extract_inpatient(b2_row, "pbp_b2", "Skilled Nursing Facility")

    # B3 - Cardiac rehab. extract_simple_benefit only reads cost-sharing;
    # the enhanced sub-benefits (crs/icrs/prs/setpad) each carry their own
    # Benefit Unlimited Component (standard suffix shape) that it never
    # reads. Add the limit read here rather than re-routing the whole
    # benefit off extract_simple_benefit (tiny population — §A2 tier 4).
    b3_row = get_plan_row(data, "b3", plan_id)
    if b3_row is not None:
        b3 = extract_simple_benefit(b3_row, "pbp_b3", "Cardiac Rehabilitation")
        B3_SUBTYPES = [
            ("crs", "Additional Cardiac Rehabilitation Services"),
            ("icrs", "Additional Intensive Cardiac Rehabilitation Services"),
            ("prs", "Additional Pulmonary Rehabilitation Services"),
            ("setpad", "Additional Supervised Exercise Therapy (SET) for PAD"),
        ]
        b3_sub_limits = []
        for sfx, lbl in B3_SUBTYPES:
            limit = extract_benefit_limit(b3_row, "pbp_b3", f"_{sfx}")
            if limit:
                b3_sub_limits.append(clean_dict({"label": lbl, **limit}))
        if b3_sub_limits:
            b3["sub_type_limits"] = b3_sub_limits
        benefits["cardiac_rehab"] = b3

    # B4 - Emergency / Urgent
    b4_row = get_plan_row(data, "b4", plan_id)
    if b4_row is not None:
        benefits.update(extract_emergency(b4_row))

    # B5 - Partial hospitalization
    b5_row = get_plan_row(data, "b5", plan_id)
    if b5_row is not None:
        b5 = {"label": "Partial Hospitalization"}
        b5["copay"] = dollar_range(safe_get(b5_row, "pbp_b5a_copay_amt_mc_min") or safe_get(b5_row, "pbp_b5a_copay_amt"), safe_get(b5_row, "pbp_b5a_copay_amt_mc_max"))
        b5["coinsurance"] = pct_range(safe_get(b5_row, "pbp_b5a_coins_pct_mc_min") or safe_get(b5_row, "pbp_b5a_coins_pct"), safe_get(b5_row, "pbp_b5a_coins_pct_mc_max"))
        maxenr = yn(safe_get(b5_row, "pbp_b5_maxenr_yn"))
        if maxenr:
            b5["max_enrollee_cost"] = to_dollar(safe_get(b5_row, "pbp_b5_maxenr_amt"))
        b5["deductible_applies"] = yn(safe_get(b5_row, "pbp_b5_ded_yn"))
        auth = safe_get(b5_row, "pbp_b5_auth_yn")
        if auth:
            b5["prior_auth_required"] = AUTH_MAP.get(auth, yn(auth))
        refer = safe_get(b5_row, "pbp_b5_refer_yn")
        if refer:
            b5["referral_required"] = AUTH_MAP.get(refer, yn(refer))
        benefits["partial_hospitalization"] = clean_dict(b5)

        # B5b - Intensive Outpatient / Community Mental Health Center
        b5b = {"label": "Intensive Outpatient Services"}
        b5b_maxenr = yn(safe_get(b5_row, "pbp_b5b_maxenr_yn"))
        if b5b_maxenr:
            b5b["max_enrollee_cost"] = to_dollar(safe_get(b5_row, "pbp_b5b_maxenr_amt"))
        b5b["copay"] = dollar_range(safe_get(b5_row, "pbp_b5b_copay_amt_mc_min") or safe_get(b5_row, "pbp_b5b_copay_amt"), safe_get(b5_row, "pbp_b5b_copay_amt_mc_max"))
        b5b["coinsurance"] = pct_range(safe_get(b5_row, "pbp_b5b_coins_pct_mc_min") or safe_get(b5_row, "pbp_b5b_coins_pct"), safe_get(b5_row, "pbp_b5b_coins_pct_mc_max"))
        if len(clean_dict(b5b)) > 1:
            benefits["intensive_outpatient"] = clean_dict(b5b)

    # B6 - Home health
    b6_row = get_plan_row(data, "b6", plan_id)
    if b6_row is not None:
        benefits["home_health"] = extract_simple_benefit(b6_row, "pbp_b6", "Home Health Services")

    # B7 - Health professionals (sub-sections a-k)
    b7_row = get_plan_row(data, "b7", plan_id)
    if b7_row is not None:
        benefits["primary_care"] = extract_simple_benefit(b7_row, "pbp_b7a", "Primary Care")
        # Chiropractic routine care (7b, _rc, standard suffix shape) and
        # podiatry routine foot care (7f, _rf) each carry a Benefit Unlimited
        # Component that extract_simple_benefit (cost-sharing only) never
        # reads. Add the limit read here rather than re-routing either
        # benefit off extract_simple_benefit.
        chiro = extract_simple_benefit(b7_row, "pbp_b7b", "Chiropractic")
        chiro.update(extract_benefit_limit(b7_row, "pbp_b7b", "_rc"))
        benefits["chiropractic"] = chiro
        benefits["specialist"] = extract_simple_benefit(b7_row, "pbp_b7c", "Specialist")
        benefits["occupational_therapy"] = extract_simple_benefit(b7_row, "pbp_b7d", "Occupational Therapy")
        benefits["mental_health_outpatient"] = extract_mental_health(b7_row, "pbp_b7e", "Mental Health (Outpatient)")
        # Podiatry routine foot care (7f, _rf): the number field is named
        # pbp_b7f_bendesc_amt_rf (not _num_rf / _numv_rf like every other
        # section) — confirmed in dictionary_consolidated.txt entry [114].
        # Pass it as an explicit override; lim/per follow the standard shape.
        podiatry = extract_simple_benefit(b7_row, "pbp_b7f", "Podiatry")
        podiatry.update(extract_benefit_limit(
            b7_row, "pbp_b7f", "_rf",
            num_field="pbp_b7f_bendesc_amt_rf",
        ))
        benefits["podiatry"] = podiatry
        benefits["other_health_care"] = extract_simple_benefit(b7_row, "pbp_b7g", "Other Health Care Professional")
        benefits["mental_health_specialist"] = extract_mental_health(b7_row, "pbp_b7h", "Mental Health Specialist")
        benefits["physical_speech_therapy"] = extract_simple_benefit(b7_row, "pbp_b7i", "Physical/Speech Therapy")
        benefits["telehealth"] = extract_simple_benefit(b7_row, "pbp_b7j", "Additional Telehealth")
        benefits["other_practitioner"] = extract_simple_benefit(b7_row, "pbp_b7k", "Other Practitioner")

    # B8 - Clinical/diagnostic
    b8_row = get_plan_row(data, "b8", plan_id)
    if b8_row is not None:
        benefits.update(extract_b8a_diagnostic(b8_row))
        benefits.update(extract_b8b_radiology(b8_row))

    # B9 - Outpatient hospital
    b9_row = get_plan_row(data, "b9", plan_id)
    if b9_row is not None:
        benefits["outpatient_hospital"] = extract_simple_benefit(b9_row, "pbp_b9a", "Outpatient Hospital")
        benefits["ambulatory_surgery"] = extract_simple_benefit(b9_row, "pbp_b9b", "Ambulatory Surgical Center")
        # B9c - Outpatient Psychiatric (individual/group)
        b9c = extract_mental_health(b9_row, "pbp_b9c", "Outpatient Psychiatric")
        if b9c and len(b9c) > 1:
            benefits["outpatient_psychiatric"] = b9c
        # B9d - Outpatient Rehabilitation
        b9d = extract_simple_benefit(b9_row, "pbp_b9d", "Outpatient Rehabilitation")
        if b9d and len(b9d) > 1:
            benefits["outpatient_rehabilitation"] = b9d

    # B10 - Ambulance/transportation
    b10_row = get_plan_row(data, "b10", plan_id)
    if b10_row is not None:
        benefits["ambulance"] = extract_simple_benefit(b10_row, "pbp_b10a", "Ambulance Services")
        # B10b - Transportation with limits
        trans = extract_supplemental_benefit(b10_row, "pbp_b10b", "Non-Emergency Transportation")
        # Fall back to the simple extractor ONLY when the plan didn't explicitly
        # file transportation as not offered (bendesc_yn = 2) — the fallback was
        # the source of false-coverage stubs (sweep check #5, e.g. H0028_014_0).
        if trans is None and safe_get(b10_row, "pbp_b10b_bendesc_yn") != "2":
            trans = extract_simple_benefit(b10_row, "pbp_b10b", "Non-Emergency Transportation")
        # Merge transport-specific _pal/_al fields
        if trans is not None:
            transport_details = extract_transport_details(b10_row, "pbp_b10b")
            if transport_details:
                trans.update(transport_details)
            benefits["transportation"] = trans

    # B11 - DME
    b11_row = get_plan_row(data, "b11", plan_id)
    if b11_row is not None:
        benefits["dme"] = extract_simple_benefit(b11_row, "pbp_b11a", "Durable Medical Equipment")
        benefits["prosthetics"] = extract_simple_benefit(b11_row, "pbp_b11b", "Prosthetics/Orthotics")
        benefits["medical_supplies"] = extract_simple_benefit(b11_row, "pbp_b11c", "Medical Supplies")

    # B12 - Renal dialysis
    b12_row = get_plan_row(data, "b12", plan_id)
    if b12_row is not None:
        benefits["renal_dialysis"] = extract_simple_benefit(b12_row, "pbp_b12", "Renal Dialysis")

    # B13 - Other services (all 7 sub-sections)
    b13_row = get_plan_row(data, "b13", plan_id)
    if b13_row is not None:
        b13_all = extract_b13_other_services(b13_row)
        for key, val in b13_all.items():
            benefits[key] = val
        # Also keep backward-compatible keys from simple extraction
        blood = extract_simple_benefit(b13_row, "pbp_b13a", "Outpatient Blood Services")
        if blood and len(blood) > 1:
            benefits["outpatient_blood"] = blood
        other = extract_simple_benefit(b13_row, "pbp_b13b", "Other Medical Services")
        if other and len(other) > 1:
            benefits["other_services"] = other

    # B13i - Social supports (detailed SSBCI)
    b13i_row = get_plan_row(data, "b13i", plan_id)
    if b13i_row is not None:
        benefits["social_supports"] = extract_b13i_ssbci(b13i_row)

    # B14 - Preventive services (all sub-sections)
    b14_row = get_plan_row(data, "b14", plan_id)
    if b14_row is not None:
        b14_all = extract_b14_preventive(b14_row)
        for key, val in b14_all.items():
            benefits[key] = val

    # B15 - Part B drugs
    b15_row = get_plan_row(data, "b15", plan_id)
    if b15_row is not None:
        benefits["part_b_drugs"] = extract_partb_drugs(b15_row)

    # B16 - Dental (comprehensive with sub-types)
    b16_row = get_plan_row(data, "b16", plan_id)
    if b16_row is not None:
        dental_all = extract_dental_detail(b16_row)
        for key, val in dental_all.items():
            benefits[key] = val

    # B17 - Vision (comprehensive with exam limits and eyewear sub-types)
    b17_row = get_plan_row(data, "b17", plan_id)
    if b17_row is not None:
        vision_all = extract_vision_detail(b17_row)
        for key, val in vision_all.items():
            benefits[key] = val

    # B18 - Hearing (comprehensive with exam, fitting, aids, OTC)
    b18_row = get_plan_row(data, "b18", plan_id)
    if b18_row is not None:
        hearing_all = extract_hearing_detail(b18_row)
        for key, val in hearing_all.items():
            benefits[key] = val

    # B20 - Enhanced drug (with per-group cost sharing details)
    b20_row = get_plan_row(data, "b20", plan_id)
    if b20_row is not None:
        b20 = extract_b20_enhanced_drug(b20_row)
        if b20 and len(b20) > 1:
            benefits["enhanced_drug"] = b20

    # Combined / shared-wallet benefits (Section D)
    d_row = get_plan_row(data, "section_d", plan_id)
    if d_row is not None:
        combined = extract_combined_benefits(d_row)
        if combined:
            benefits["combined_benefits"] = {
                "label": "Combined Benefit Allowances (Shared Wallet)",
                "groups": combined,
            }

    # Model-test participation flags (SSBCI / Uniform Flexibility), Section B19
    b19_row = get_plan_row(data, "b19", plan_id)
    if b19_row is not None:
        mt = extract_model_test(b19_row)
        if mt:
            benefits["model_test"] = mt

    # Link SSBCI line-items to their combined-wallet group by matching periodicity
    # (each wallet group carries a period - e.g. monthly $115 vs yearly $1,300 - and
    # each SSBCI item carries the same period, so items fall under the same-period group).
    combined = benefits.get("combined_benefits")
    ss = benefits.get("social_supports")
    if combined and ss:
        ss_items = [(v.get("label"), v.get("max_plan_benefit_period"), k)
                    for k, v in ss.items() if isinstance(v, dict) and v.get("label")]
        for grp in combined.get("groups", []):
            gper = grp.get("max_plan_benefit_period")
            gname = (grp.get("name") or "").lower()
            incl = []
            for lbl, per, key in ss_items:
                if gper and per and per == gper:
                    incl.append(lbl)
                elif "transport" in gname and key == "transportation":
                    incl.append(lbl)
            if incl:
                grp["includes"] = incl

    # VBID / Uniform-Flexibility special supplemental packages (b19a/b19b)
    vbid = extract_vbid(data, plan_id)
    if vbid:
        benefits["vbid_packages"] = vbid

    # Sweep check #5: drop supplemental benefits that carry no substance —
    # the plan filed nothing for the section, so nothing is offered. PACE
    # plans are exempt (label-only is their normal filing shape).
    if detail["plan_info"].get("plan_type") != "PACE":
        for stub_key in SUPPLEMENTAL_STUB_KEYS:
            v = benefits.get(stub_key)
            if isinstance(v, dict) and set(v) <= LABEL_STUB_KEYS:
                del benefits[stub_key]
    benefits = {k: v for k, v in benefits.items() if v}

    detail["benefits"] = benefits

    # Drug coverage (MRx)
    mrx_row = get_plan_row(data, "mrx", plan_id)
    if mrx_row is not None:
        tier_rows = get_plan_rows(data, "mrx_tier", plan_id)
        detail["drug_coverage"] = extract_drug_coverage(mrx_row, tier_rows)

        # Catastrophic phase from mrx_p
        mrx_p_rows = get_plan_rows(data, "mrx_p", plan_id)
        if not mrx_p_rows.empty:
            cat_tiers = []
            for _, p_row in mrx_p_rows.iterrows():
                cat = {}
                cat["label"] = safe_get(p_row, "mrx_tier_post_label_list")
                cat["tier_id"] = safe_get(p_row, "mrx_tier_post_id")
                cat["drug_type"] = safe_get(p_row, "mrx_tier_post_drug_type")
                cat["copay"] = to_dollar(safe_get(p_row, "mrx_tier_post_copay_amt"))
                cat["coinsurance"] = to_pct(safe_get(p_row, "mrx_tier_post_coins_pct"))
                cat["cost_structure"] = safe_get(p_row, "mrx_tier_post_cost_struct")
                cat_tiers.append(clean_dict(cat))
            if cat_tiers:
                detail["drug_coverage"]["catastrophic_tiers"] = cat_tiers
    else:
        detail["drug_coverage"] = {"has_drug_benefit": False}

    return detail


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    print("=" * 60)
    print("Medicare Advantage Benefits Dashboard - Data Preprocessor")
    print("=" * 60)

    # Ensure output directories exist
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    PLANS_DIR.mkdir(parents=True, exist_ok=True)

    # Step 1: Geography
    process_geography()
    print()

    # Step 2: Plans summary
    plans_summary = process_plans_summary()
    if not plans_summary:
        print("FATAL: No plans found. Exiting.")
        sys.exit(1)
    print()

    # Step 3: Load all benefit data
    data = load_all_benefit_data()
    print()

    # Step 4: Build per-plan detail files
    print("Building per-plan detail files...")
    count = 0
    errors = 0
    for plan_id in plans_summary:
        try:
            detail = build_plan_detail(plan_id, plans_summary, data)
            out_path = PLANS_DIR / f"{plan_id}.json"
            with open(out_path, "w") as f:
                json.dump(detail, f, separators=(",", ":"))
            count += 1
        except Exception as e:
            errors += 1
            if errors <= 10:
                print(f"  ERROR on {plan_id}: {e}")
        if count % 1000 == 0 and count > 0:
            print(f"  Written {count:,} plans...")

    print(f"  Done: {count:,} plan files written, {errors} errors")
    print()

    # Summary stats
    print("=" * 60)
    print("SUMMARY")
    print("=" * 60)
    print(f"Total plans:            {len(plans_summary):,}")
    print(f"Plan detail files:      {count:,}")
    print(f"Errors:                 {errors}")

    types = defaultdict(int)
    snp_count = 0
    drug_count = 0
    for p in plans_summary.values():
        types[p.get("plan_type", "Unknown")] += 1
        if p.get("is_snp"):
            snp_count += 1
        if p.get("part_d"):
            drug_count += 1

    print(f"SNP plans:              {snp_count:,}")
    print(f"Part D plans:           {drug_count:,}")
    print("\nPlan types:")
    for t, c in sorted(types.items(), key=lambda x: -x[1]):
        print(f"  {t:20s} {c:,}")

    print(f"\nOutput directory: {OUT_DIR}")
    print("Done!")


if __name__ == "__main__":
    main()
