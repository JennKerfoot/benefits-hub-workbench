from preprocess import (
    extract_model_test,
    extract_combined_benefits,
    extract_transport_details,
)


# ---------------------------------------------------------------------------
# V3 port — model_test (SSBCI / Uniform Flexibility participation flags, B19)
# ---------------------------------------------------------------------------
# Raw file is pbp_b19_model_test.txt (section key "b19"), but its column
# headers carry the "b19a" field prefix (pbp_b19a_ssbci_yn / pbp_b19a_uf_yn).
# The V3 ledger note: key "b19" was verified correct, not "b19a" for section
# lookup — the field-name prefix and the section key are not the same thing.

def test_model_test_ssbci_yes():
    row = {"pbp_b19a_ssbci_yn": "1", "pbp_b19a_uf_yn": "2"}
    out = extract_model_test(row)
    assert out == {"ssbci": True, "uniform_flexibility": False}


def test_model_test_ssbci_no_uf_yes():
    row = {"pbp_b19a_ssbci_yn": "2", "pbp_b19a_uf_yn": "1"}
    out = extract_model_test(row)
    assert out == {"ssbci": False, "uniform_flexibility": True}


def test_model_test_both_absent_returns_none():
    row = {}
    assert extract_model_test(row) is None


def test_model_test_absent_field_treated_as_false_when_other_present():
    # Only ssbci filed; uf missing entirely -> still returns a dict (not None),
    # with uniform_flexibility coerced to False.
    row = {"pbp_b19a_ssbci_yn": "1"}
    out = extract_model_test(row)
    assert out == {"ssbci": True, "uniform_flexibility": False}


# ---------------------------------------------------------------------------
# V3 port — combined_benefits group delivery_mode + disbursement_note
# ---------------------------------------------------------------------------

def test_combined_benefits_delivery_mode_debit_card():
    row = {
        "pbp_d_combo_supp_ben_yn": "1",
        "pbp_d_combo_grp_name_1": "Combined Supplemental Benefits 1",
        "pbp_d_combo_max_plan_ben_yn_1": "1",
        "pbp_d_combo_max_plan_ben_amt_1": "250",
        "pbp_d_combo_max_plan_period_1": "3",
        "pbp_d_combo_mode_1": "00010",
    }
    groups = extract_combined_benefits(row)
    assert groups[0]["delivery_mode"] == "Debit Card"


def test_combined_benefits_delivery_mode_multi_select():
    row = {
        "pbp_d_combo_supp_ben_yn": "1",
        "pbp_d_combo_grp_name_1": "Combined Supplemental Benefits 1",
        "pbp_d_combo_max_plan_ben_yn_1": "1",
        "pbp_d_combo_max_plan_ben_amt_1": "250",
        "pbp_d_combo_max_plan_period_1": "3",
        "pbp_d_combo_mode_1": "01010",
    }
    groups = extract_combined_benefits(row)
    assert groups[0]["delivery_mode"] == "Catalogue Purchase, Debit Card"


def test_combined_benefits_disbursement_note_captured():
    row = {
        "pbp_d_combo_supp_ben_yn": "1",
        "pbp_d_combo_grp_name_1": "Combined Supplemental Benefits 1",
        "pbp_d_combo_max_plan_ben_yn_1": "1",
        "pbp_d_combo_max_plan_ben_amt_1": "250",
        "pbp_d_combo_max_plan_period_1": "3",
        "pbp_d_combo_max_plan_prd_d_1": "Loaded quarterly onto member debit card",
    }
    groups = extract_combined_benefits(row)
    assert groups[0]["disbursement_note"] == "Loaded quarterly onto member debit card"


def test_combined_benefits_no_mode_no_key():
    row = {
        "pbp_d_combo_supp_ben_yn": "1",
        "pbp_d_combo_grp_name_1": "Combined Supplemental Benefits 1",
        "pbp_d_combo_max_plan_ben_yn_1": "1",
        "pbp_d_combo_max_plan_ben_amt_1": "250",
        "pbp_d_combo_max_plan_period_1": "3",
    }
    groups = extract_combined_benefits(row)
    assert "delivery_mode" not in groups[0]
    assert "disbursement_note" not in groups[0]


# ---------------------------------------------------------------------------
# V3 port — transportation trip_description (free-text, any trip type)
# ---------------------------------------------------------------------------

def test_trip_description_captured_for_other_type():
    row = {
        "pbp_b13i_t_bendesc_trn": "1",
        "pbp_b13i_t_bendesc_lim_pal": "1",
        "pbp_b13i_t_bendesc_tt_pal": "5",
        "pbp_b13i_t_bendesc_tt_pal_d": "Rides to community events",
    }
    out = extract_transport_details(row, "pbp_b13i_t")
    assert out["trip_description"] == "Rides to community events"
    assert out["trip_type"] == "Other (Rides to community events)"


def test_trip_description_captured_for_non_other_type():
    # V3 fix: description is captured regardless of trip type code (not just tt==5)
    row = {
        "pbp_b13i_t_bendesc_trn": "2",
        "pbp_b13i_t_bendesc_lim_al": "1",
        "pbp_b13i_t_bendesc_tt_al": "1",
        "pbp_b13i_t_bendesc_tt_al_d": "Includes non-emergency medical transport",
    }
    out = extract_transport_details(row, "pbp_b13i_t")
    assert out["trip_description"] == "Includes non-emergency medical transport"


def test_trip_description_absent_when_no_free_text():
    row = {
        "pbp_b13i_t_bendesc_trn": "1",
        "pbp_b13i_t_bendesc_lim_pal": "1",
        "pbp_b13i_t_bendesc_tt_pal": "1",
    }
    out = extract_transport_details(row, "pbp_b13i_t")
    assert "trip_description" not in out
