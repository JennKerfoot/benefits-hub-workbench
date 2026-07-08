from preprocess import (
    extract_benefit_limit,
    extract_hearing_detail,
    extract_dental_detail,
    extract_vision_detail,
    extract_simple_benefit,
)


# ---------------------------------------------------------------------------
# Task 9 helper — brief's own acceptance cases (standard suffix shape)
# ---------------------------------------------------------------------------

def test_hearing_aid_limit_wired():
    row = {
        "pbp_b18b_bendesc_lim_at": "2",
        "pbp_b18b_bendesc_numv_at": "2",
        "pbp_b18b_bendesc_per_at": "1",
    }
    out = extract_benefit_limit(row, "pbp_b18b", "_at")
    assert out == {"visit_limit": "2", "visit_limit_period": "Every 3 years"}


def test_dental_cleaning_freq_wired():
    # Dental preventive is infixed: pbp_b16b_bendesc_pc_lim/_num/_per (service
    # code BEFORE the field-type token), and the number field is "_num" not
    # "_numv". This is the real dictionary shape (entries [91]-[95]).
    row = {
        "pbp_b16b_bendesc_pc_lim": "2",
        "pbp_b16b_bendesc_pc_num": "2",
        "pbp_b16b_bendesc_pc_per": "3",
    }
    out = extract_benefit_limit(
        row, "pbp_b16b", "_pc",
        lim_field="pbp_b16b_bendesc_pc_lim",
        num_field="pbp_b16b_bendesc_pc_num",
        per_field="pbp_b16b_bendesc_pc_per",
    )
    assert out.get("visit_limit") == "2"
    assert out.get("visit_limit_period") == "Every year"


# ---------------------------------------------------------------------------
# Public-extractor tests — hearing (18b aids, 18a fitting)
# ---------------------------------------------------------------------------

def test_hearing_aids_visit_limit_through_extractor():
    """extract_hearing_detail() must surface visit_limit/visit_limit_period
    on the hearing_aids dict itself (not just the bare helper)."""
    row = {
        "pbp_b18b_bendesc_yn": "1",
        "pbp_b18b_bendesc_lim_at": "2",
        "pbp_b18b_bendesc_numv_at": "2",
        "pbp_b18b_bendesc_per_at": "1",
    }
    out = extract_hearing_detail(row)
    aids = out["hearing_aids"]
    assert aids["visit_limit"] == "2"
    assert aids["visit_limit_period"] == "Every 3 years"


def test_hearing_aids_unlimited_no_visit_limit():
    row = {
        "pbp_b18b_bendesc_yn": "1",
        "pbp_b18b_bendesc_lim_at": "1",  # unlimited
    }
    out = extract_hearing_detail(row)
    aids = out["hearing_aids"]
    assert "visit_limit" not in aids
    assert "visit_limit_period" not in aids


def test_hearing_fitting_limit_through_extractor():
    """Hearing-aid fitting (18a _fha triple) attaches onto hearing_exams."""
    row = {
        "pbp_b18a_bendesc_lim_fha": "2",
        "pbp_b18a_bendesc_numv_fha": "1",
        "pbp_b18a_bendesc_per_fha": "3",
    }
    out = extract_hearing_detail(row)
    exam = out["hearing_exams"]
    assert exam["fitting_visit_limit"] == "1"
    assert exam["fitting_visit_limit_period"] == "Every year"


def test_otc_hearing_aids_limit_through_extractor():
    """OTC hearing aids (18c) uses NO suffix at all: pbp_b18c_bendesc_lim/num/per."""
    row = {
        "pbp_b18c_maxplan_yn": "1",
        "pbp_b18c_maxplan_amt": "500",
        "pbp_b18c_bendesc_lim": "2",
        "pbp_b18c_bendesc_num": "1",
        "pbp_b18c_bendesc_per": "3",
    }
    out = extract_hearing_detail(row)
    otc = out["otc_hearing_aids"]
    assert otc["visit_limit"] == "1"
    assert otc["visit_limit_period"] == "Every year"
    assert otc["max_plan_benefit"] == "$500"


# ---------------------------------------------------------------------------
# Dental preventive (16b) — infixed shape, per-service sub_types
# ---------------------------------------------------------------------------

def test_dental_preventive_service_limit_through_extractor():
    row = {
        "pbp_b16b_bendesc_pc_lim": "2",
        "pbp_b16b_bendesc_pc_num": "2",
        "pbp_b16b_bendesc_pc_per": "3",
        "pbp_b16b_copay_pc_amt_min": "0",
        "pbp_b16b_copay_pc_amt_max": "0",
    }
    out = extract_dental_detail(row)
    subs = {s["label"]: s for s in out["dental_preventive"]["sub_types"]}
    pc = subs["Prophylaxis/Cleanings"]
    assert pc["visit_limit"] == "2"
    assert pc["visit_limit_period"] == "Every year"


def test_dental_preventive_multiple_services_independent_limits():
    """Oral exams (oe) and x-rays (dx) each carry their own limit — verifies
    the per-service loop doesn't cross-contaminate suffixes."""
    row = {
        "pbp_b16b_bendesc_oe_lim": "2",
        "pbp_b16b_bendesc_oe_num": "1",
        "pbp_b16b_bendesc_oe_per": "3",
        "pbp_b16b_copay_oe_amt_min": "0",
        "pbp_b16b_bendesc_dx_lim": "2",
        "pbp_b16b_bendesc_dx_num": "1",
        "pbp_b16b_bendesc_dx_per": "3",
        "pbp_b16b_copay_dx_amt_min": "0",
    }
    out = extract_dental_detail(row)
    subs = {s["label"]: s for s in out["dental_preventive"]["sub_types"]}
    assert subs["Oral Exams"]["visit_limit"] == "1"
    assert subs["Dental X-Rays"]["visit_limit"] == "1"


def test_dental_preventive_unlimited_service_no_visit_limit():
    row = {
        "pbp_b16b_bendesc_ft_lim": "1",  # unlimited
        "pbp_b16b_copay_ft_amt_min": "0",
    }
    out = extract_dental_detail(row)
    subs = {s["label"]: s for s in out["dental_preventive"]["sub_types"]}
    ft = subs["Fluoride Treatment"]
    assert "visit_limit" not in ft


# ---------------------------------------------------------------------------
# Podiatry (7f) — override case: number field is "_amt_rf", not "_num_rf"/"_numv_rf"
# ---------------------------------------------------------------------------

def test_podiatry_routine_foot_care_limit_through_extractor():
    row = {
        "pbp_b7f_bendesc_lim_rf": "2",
        "pbp_b7f_bendesc_amt_rf": "6",
        "pbp_b7f_bendesc_per_rf": "3",
    }
    podiatry = extract_simple_benefit(row, "pbp_b7f", "Podiatry")
    from preprocess import extract_benefit_limit as ebl
    podiatry.update(ebl(row, "pbp_b7f", "_rf", num_field="pbp_b7f_bendesc_amt_rf"))
    assert podiatry["visit_limit"] == "6"
    assert podiatry["visit_limit_period"] == "Every year"


def test_podiatry_unlimited_returns_no_visit_limit():
    row = {"pbp_b7f_bendesc_lim_rf": "1"}
    out = extract_benefit_limit(row, "pbp_b7f", "_rf", num_field="pbp_b7f_bendesc_amt_rf")
    assert out == {}


# ---------------------------------------------------------------------------
# Chiropractic (7b) — standard suffix shape, additive onto extract_simple_benefit
# ---------------------------------------------------------------------------

def test_chiropractic_routine_care_limit_through_extractor():
    row = {
        "pbp_b7b_bendesc_lim_rc": "2",
        "pbp_b7b_bendesc_num_rc": "12",
        "pbp_b7b_bendesc_per_rc": "3",
    }
    chiro = extract_simple_benefit(row, "pbp_b7b", "Chiropractic")
    chiro.update(extract_benefit_limit(row, "pbp_b7b", "_rc"))
    assert chiro["visit_limit"] == "12"
    assert chiro["visit_limit_period"] == "Every year"


# ---------------------------------------------------------------------------
# Eyewear (17b) — glasses (_egs) and contacts (_cl), attached per item type
# ---------------------------------------------------------------------------

def test_eyewear_glasses_and_contacts_limits_through_extractor():
    row = {
        "pbp_b17b_bendesc_lim_egs": "2",
        "pbp_b17b_bendesc_numv_egs": "1",
        "pbp_b17b_bendesc_per_egs": "3",
        "pbp_b17b_bendesc_lim_cl": "2",
        "pbp_b17b_bendesc_numv_cl": "4",
        "pbp_b17b_bendesc_per_cl": "3",
    }
    out = extract_vision_detail(row)
    eyewear = out["eyewear"]
    assert eyewear["glasses_quantity_limit"] == "1"
    assert eyewear["glasses_quantity_limit_period"] == "Every year"
    assert eyewear["contacts_quantity_limit"] == "4"
    assert eyewear["contacts_quantity_limit_period"] == "Every year"


def test_eyewear_unlimited_glasses_no_quantity_limit():
    row = {"pbp_b17b_bendesc_lim_egs": "1"}
    out = extract_vision_detail(row)
    eyewear = out["eyewear"]
    assert "glasses_quantity_limit" not in eyewear


# ---------------------------------------------------------------------------
# Cardiac/intensive/pulmonary/SET rehab (b3) — tiny population, completeness
# ---------------------------------------------------------------------------

def test_cardiac_rehab_subtype_limits():
    row = {
        "pbp_b3_bendesc_lim_crs": "2",
        "pbp_b3_bendesc_numv_crs": "36",
        "pbp_b3_bendesc_per_crs": "8",
        "pbp_b3_bendesc_lim_setpad": "2",
        "pbp_b3_bendesc_numv_setpad": "12",
        "pbp_b3_bendesc_per_setpad": "3",
    }
    b3 = extract_simple_benefit(row, "pbp_b3", "Cardiac Rehabilitation")
    subtypes = [
        ("crs", "Additional Cardiac Rehabilitation Services"),
        ("icrs", "Additional Intensive Cardiac Rehabilitation Services"),
        ("prs", "Additional Pulmonary Rehabilitation Services"),
        ("setpad", "Additional Supervised Exercise Therapy (SET) for PAD"),
    ]
    sub_limits = []
    for sfx, lbl in subtypes:
        limit = extract_benefit_limit(row, "pbp_b3", f"_{sfx}")
        if limit:
            sub_limits.append({"label": lbl, **limit})
    b3["sub_type_limits"] = sub_limits
    by_label = {s["label"]: s for s in b3["sub_type_limits"]}
    crs = by_label["Additional Cardiac Rehabilitation Services"]
    assert crs["visit_limit"] == "36"
    assert crs["visit_limit_period"] == "Every benefit period"
    setpad = by_label["Additional Supervised Exercise Therapy (SET) for PAD"]
    assert setpad["visit_limit"] == "12"
    assert setpad["visit_limit_period"] == "Every year"
    # icrs/prs weren't filed on this row → no entry emitted for them.
    assert "Additional Intensive Cardiac Rehabilitation Services" not in by_label
