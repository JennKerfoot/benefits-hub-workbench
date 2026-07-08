from preprocess import (
    extract_benefit_limit,
    extract_b13_other_services,
    extract_b14_preventive,
)


# ---------------------------------------------------------------------------
# Task 11 (Part 1) — OTC delivery mode (b13b_mode bitmask -> otc_delivery_mode)
# ---------------------------------------------------------------------------

def test_otc_delivery_mode_decoded():
    """b13b_mode is a 5-position bitmask: 1=Other, 2=Catalogue Purchase,
    3=Claims Processing, 4=Debit Card, 5=Reimbursement (dictionary 'X in N'
    code map). Position 4 set -> Debit Card."""
    row = {
        "pbp_b13b_bendesc_otc": "1",
        "pbp_b13b_mode": "00010",
    }
    out = extract_b13_other_services(row)
    assert out["otc_items"]["otc_delivery_mode"] == "Debit Card"


def test_otc_delivery_mode_other_uses_free_text():
    row = {
        "pbp_b13b_bendesc_otc": "1",
        "pbp_b13b_mode": "10000",
        "pbp_b13b_mode_desc": "Delivered via mail order pharmacy",
    }
    out = extract_b13_other_services(row)
    assert out["otc_items"]["otc_delivery_mode"] == "Other (Delivered via mail order pharmacy)"


def test_otc_delivery_mode_multi_select_joins_labels():
    row = {
        "pbp_b13b_bendesc_otc": "1",
        "pbp_b13b_mode": "01010",
    }
    out = extract_b13_other_services(row)
    assert out["otc_items"]["otc_delivery_mode"] == "Catalogue Purchase, Debit Card"


def test_otc_delivery_mode_absent_key_omitted():
    row = {"pbp_b13b_bendesc_otc": "1"}
    out = extract_b13_other_services(row)
    assert "otc_delivery_mode" not in out["otc_items"]


# ---------------------------------------------------------------------------
# Task 11 (Part 2) — 14c non-Fitness allowances + periodicity
# ---------------------------------------------------------------------------

def test_14c_wig_allowance_and_period_read():
    # value slots come straight from the row; assert the extractor emits them (once wired)
    row = {"pbp_b14c_bendesc_lim_at": "2", "pbp_b14c_bendesc_numv_at": "1", "pbp_b14c_bendesc_per_at": "3"}
    assert extract_benefit_limit(row, "pbp_b14c", "_at") == {"visit_limit": "1", "visit_limit_period": "Every year"}


def test_14c_wig_maxplan_and_period_on_sub_benefit():
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_wig": "3",
        "pbp_b14c_maxplan_amt_wig": "500",
        "pbp_b14c_maxplan_per_wig": "3",
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    wig = subs["Wigs"]
    assert wig["max_plan_benefit"] == "$500"
    assert wig["max_plan_benefit_period"] == "Every year"


def test_14c_bsd_allowance_and_period():
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_bsd": "3",
        "pbp_b14c_maxplan_amt_bsd": "250",
        "pbp_b14c_maxplan_per_bsd": "7",
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    bsd = subs["Bathroom Safety Devices"]
    assert bsd["max_plan_benefit"] == "$250"
    assert bsd["max_plan_benefit_period"] == "Every month"


def test_14c_at_limit_via_helper_real_field_name():
    """Alternative Therapies' visit count is filed under pbp_b14c_at_visits
    (not the standard bendesc_numv_at shape) with no periodicity field."""
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_at": "3",
        "pbp_b14c_bendesc_lim_at": "2",
        "pbp_b14c_at_visits": "6",
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    at = subs["Assistive Technology"]
    assert at["visit_limit"] == "6"


def test_14c_ntb_limit_via_helper():
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_ntb": "3",
        "pbp_b14c_bendesc_lim_ntb": "2",
        "pbp_b14c_bendesc_num_ntb": "4",
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    ntb = subs["Nutritional/Tobacco Counseling"]
    assert ntb["visit_limit"] == "4"


def test_14c_cs_limit_via_helper():
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_cs": "3",
        "pbp_b14c_bendesc_lim_cs": "2",
        "pbp_b14c_bendesc_num_cs": "3",
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    cs = subs["Counseling Services"]
    assert cs["visit_limit"] == "3"


def test_14c_at_unlimited_no_visit_limit():
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_at": "3",
        "pbp_b14c_bendesc_lim_at": "1",  # unlimited
        "pbp_b14c_at_visits": "6",  # should be ignored since unlimited
    }
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out["additional_preventive"]["sub_types"]}
    at = subs["Assistive Technology"]
    assert "visit_limit" not in at


def test_14c_absent_fields_omitted():
    """A sub-benefit with none of amo/copay/coins/maxplan/limit populated
    doesn't appear in sub_types at all."""
    row = {"pbp_b14c_bendesc_yn": "1"}
    out = extract_b14_preventive(row)
    subs = {s["label"]: s for s in out.get("additional_preventive", {}).get("sub_types", [])}
    assert "Wigs" not in subs
    assert "Assistive Technology" not in subs


def test_14c_fitness_mhc_not_duplicated_in_sub_types():
    """Fitness (mhc) must stay out of additional_preventive.sub_types —
    it already has its own top-level 'fitness' key."""
    row = {
        "pbp_b14c_bendesc_yn": "1",
        "pbp_b14c_bendesc_amo_mhc": "3",
        "pbp_b14c_maxplan_amt_mhc": "200",
        "pbp_b14c_maxplan_per_mhc": "3",
    }
    out = extract_b14_preventive(row)
    assert "fitness" in out
    assert out["fitness"]["max_plan_benefit"] == "$200"
    sub_labels = {s["label"] for s in out.get("additional_preventive", {}).get("sub_types", [])}
    assert "Fitness Benefit" not in sub_labels
