from preprocess import extract_benefit_limit, PERIODICITY_MAP

def test_limit_reads_numv_and_per():
    row = {"pbp_b18b_bendesc_lim_at": "2", "pbp_b18b_bendesc_numv_at": "2", "pbp_b18b_bendesc_per_at": "1"}
    out = extract_benefit_limit(row, "pbp_b18b", "_at")
    assert out["visit_limit"] == "2"
    assert out["visit_limit_period"] == "Every 3 years"

def test_unlimited_returns_empty():
    assert extract_benefit_limit({"pbp_b7f_bendesc_lim_rf": "1"}, "pbp_b7f", "_rf") == {}

def test_absent_returns_empty():
    assert extract_benefit_limit({}, "pbp_b18b", "_at") == {}
