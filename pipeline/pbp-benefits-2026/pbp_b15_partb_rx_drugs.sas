*pbp_b15_partb_rx_drugs.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b15;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	mrx_b_cost_share_attest          $1
	mrx_b_max_oop_yn                 $1
	mrx_b_max_oop_per                $1
	mrx_b_max_oop_per_d              $4000
	mrx_b_coins_yn                   $1
	mrx_b_coins_ehc                  $2
	mrx_b_copay_yn                   $1
	mrx_b_copay_ehc                  $2
	mrx_b_ira_coins_yn               $1
	mrx_b_ira_copay_yn               $1
	mrx_b_ira_deduct_yn              $1
	mrx_b_ded_yn                     $1
	mrx_b_auth_yn                    $1
	mrx_b_step_tpy_yn                $1
	mrx_b_stp_tpy_chk                $3
	mrx_b_hi_yn                      $1
;

infile '.\pbp\pbp_b15_partb_rx_drugs.txt' delimiter = '09'x
dsd lrecl = 30000 firstobs=2 missover;


input
	pbp_a_hnumber
	pbp_a_plan_identifier
	segment_id
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	bid_id
	version
	mrx_b_cost_share_attest
	mrx_b_max_oop_yn
	mrx_b_max_oop_amt
	mrx_b_max_oop_per
	mrx_b_max_oop_per_d
	mrx_b_coins_yn
	mrx_b_coins_ehc
	mrx_b_chemo_coins_min_pct
	mrx_b_chemo_coins_max_pct
	mrx_b_coins_min_pct
	mrx_b_coins_max_pct
	mrx_b_copay_yn
	mrx_b_copay_ehc
	mrx_b_chemo_copay_amt_min
	mrx_b_chemo_copay_amt_max
	mrx_b_copay_min_amt
	mrx_b_copay_max_amt
	mrx_b_ira_coins_yn
	mrx_b_ira_coins_min_pct
	mrx_b_ira_coins_max_pct
	mrx_b_ira_copay_month_amt
	mrx_b_ira_copay_yn
	mrx_b_ira_copay_amt_min
	mrx_b_ira_copay_amt_max
	mrx_b_ira_deduct_yn
	mrx_b_ded_yn
	mrx_b_ded_amt
	mrx_b_auth_yn
	mrx_b_step_tpy_yn
	mrx_b_stp_tpy_chk
	mrx_b_hi_yn
;


label
	pbp_a_hnumber                    = 'H Number'
	pbp_a_plan_identifier            = 'Plan ID'
	segment_id                       = 'Segment ID'
	pbp_a_ben_cov                    = 'Coverage Criteria'
	pbp_a_plan_type                  = 'Plan Type'
	orgtype                          = 'Organization Type'
	bid_id                           = 'Bid ID'
	version                          = 'Version Number'
	mrx_b_cost_share_attest          = '15 Part AB Cost Share Attest'
	mrx_b_max_oop_yn                 = '15 Part AB Max OOP YN'
	mrx_b_max_oop_amt                = '15 Part AB Max OOP Amt'
	mrx_b_max_oop_per                = '15 Part AB Max OOP Periodicity'
	mrx_b_max_oop_per_d              = '15 Part AB Max OOP Per Desc'
	mrx_b_coins_yn                   = '15 Part AB Coinsurance YN'
	mrx_b_coins_ehc                  = '15 Part AB Coins Services'
	mrx_b_chemo_coins_min_pct        = '15 Chemo Min Coinsurance Pct'
	mrx_b_chemo_coins_max_pct        = '15 Chemo Max Coinsurance Pct'
	mrx_b_coins_min_pct              = '15 Other Min Coinsurance Pct'
	mrx_b_coins_max_pct              = '15 Other Max Coinsurance Pct'
	mrx_b_copay_yn                   = '15 Part AB Copayment YN'
	mrx_b_copay_ehc                  = '15 Part AB Copay Services'
	mrx_b_chemo_copay_amt_min        = '15 Chemo Copay Min Amt'
	mrx_b_chemo_copay_amt_max        = '15 Chemo Copay Max Amt'
	mrx_b_copay_min_amt              = '15 Other Copay Min Amt'
	mrx_b_copay_max_amt              = '15 Other Copay Max Amt'
	mrx_b_ira_coins_yn               = '15 Part AB Insulin Coins YN'
	mrx_b_ira_coins_min_pct          = '15 Part AB Insulin Min Coins'
	mrx_b_ira_coins_max_pct          = '15 Part AB Insulin Max Coins'
	mrx_b_ira_copay_month_amt        = '15 Part AB Insulin Month Copay'
	mrx_b_ira_copay_yn               = '15 Part AB Insulin Copay YN'
	mrx_b_ira_copay_amt_min          = '15 Part AB Insulin Copay Min'
	mrx_b_ira_copay_amt_max          = '15 Part AB Copay Insulin Max'
	mrx_b_ira_deduct_yn              = '15 Part AB Deduct YN'
	mrx_b_ded_yn                     = '15 Part AB Deductible YN'
	mrx_b_ded_amt                    = '15 Part AB Deductible Amt'
	mrx_b_auth_yn                    = '15 Part AB Authorization YN'
	mrx_b_step_tpy_yn                = '15 Part AB Step Therapy YN'
	mrx_b_stp_tpy_chk                = '15 benefit step from choice'
	mrx_b_hi_yn                      = '15 Home Infusion'
;

run;

proc sort data = pbp_b15 out=out.pbp_b15;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b15(obs = 10);
  title 'pbp_b15_partb_rx_drugs file ';
run;

proc means data = out.pbp_b15;
  title 'pbp_b15_partb_rx_drugs file ';
run;

proc freq data = out.pbp_b15;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	mrx_b_cost_share_attest
	mrx_b_max_oop_yn
	mrx_b_max_oop_per
	mrx_b_coins_yn
	mrx_b_coins_ehc
	mrx_b_copay_yn
	mrx_b_copay_ehc
	mrx_b_ira_coins_yn
	mrx_b_ira_copay_yn
	mrx_b_ira_deduct_yn
	mrx_b_ded_yn
	mrx_b_auth_yn
	mrx_b_step_tpy_yn
	mrx_b_stp_tpy_chk
	mrx_b_hi_yn
/ missing;
run;

proc contents data = out.pbp_b15;
  title 'pbp_b15 data';
run;