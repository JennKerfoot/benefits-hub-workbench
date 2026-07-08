*pbp_b5_partial_hosp.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b5;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_b5_maxenr_yn                 $1
	pbp_b5_maxenr_per                $1
	pbp_b5_maxenr_per_d              $4000
	pbp_b5_coins_yn                  $1
	pbp_b5_ded_yn                    $1
	pbp_b5_copay_yn                  $1
	pbp_b5_auth_yn                   $1
	pbp_b5_refer_yn                  $1
	pbp_b5b_maxenr_yn                $1
	pbp_b5b_maxenr_per               $1
	pbp_b5b_maxenr_per_d             $4000
	pbp_b5b_coins_yn                 $1
	pbp_b5b_ded_yn                   $1
	pbp_b5b_copay_yn                 $1
	pbp_b5b_auth_yn                  $1
	pbp_b5b_refer_yn                 $1
;

infile '.\pbp\pbp_b5_partial_hosp.txt' delimiter = '09'x
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
	pbp_b5_maxenr_yn
	pbp_b5_maxenr_amt
	pbp_b5_maxenr_per
	pbp_b5_maxenr_per_d
	pbp_b5_coins_yn
	pbp_b5a_coins_pct
	pbp_b5_coins_pct_min
	pbp_b5_coins_pct_max
	pbp_b5_ded_yn
	pbp_b5_ded_amt
	pbp_b5_copay_yn
	pbp_b5a_copay_amt
	pbp_b5_copay_mcia_amt_min
	pbp_b5_copay_mcia_amt_max
	pbp_b5_auth_yn
	pbp_b5_refer_yn
	pbp_b5b_maxenr_yn
	pbp_b5b_maxenr_amt
	pbp_b5b_maxenr_per
	pbp_b5b_maxenr_per_d
	pbp_b5b_coins_yn
	pbp_b5b_coins_pct
	pbp_b5b_coins_pct_min
	pbp_b5b_coins_pct_max
	pbp_b5b_ded_yn
	pbp_b5b_ded_amt
	pbp_b5b_copay_yn
	pbp_b5b_copay_amt
	pbp_b5b_copay_amt_min
	pbp_b5b_copay_amt_max
	pbp_b5b_auth_yn
	pbp_b5b_refer_yn
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
	pbp_b5_maxenr_yn                 = 'Partial Hosp Max Enr YN'
	pbp_b5_maxenr_amt                = 'Partial Hosp Max Enr Amt'
	pbp_b5_maxenr_per                = 'Partial Hosp Max Enr Per'
	pbp_b5_maxenr_per_d              = 'Partl Hosp Max Enr Per Desc'
	pbp_b5_coins_yn                  = 'Partial Hosp Coinsurance YN'
	pbp_b5a_coins_pct                = 'Partial Hosp MC Coins Pct'
	pbp_b5_coins_pct_min             = 'Partial Hosp MC Coins Min Pct'
	pbp_b5_coins_pct_max             = 'Partial Hosp MC Coins Max Pct'
	pbp_b5_ded_yn                    = 'Partial Hosp Deductible YN'
	pbp_b5_ded_amt                   = 'Partial Hosp Deductible Amt'
	pbp_b5_copay_yn                  = 'Partial Hosp Copayment YN'
	pbp_b5a_copay_amt                = 'Partial Hosp Copay Amt'
	pbp_b5_copay_mcia_amt_min        = 'Partial Hosp Copay Min Amt'
	pbp_b5_copay_mcia_amt_max        = 'Partial Hosp Copay Max Amt'
	pbp_b5_auth_yn                   = 'Partial Hosp Enrollee Auth'
	pbp_b5_refer_yn                  = 'Partial Hosp Referral YN'
	pbp_b5b_maxenr_yn                = 'Int Out Svc Max Enr YN'
	pbp_b5b_maxenr_amt               = 'Int Out Svc Max Enr Amt'
	pbp_b5b_maxenr_per               = 'Int Out Svc Max Enr Per'
	pbp_b5b_maxenr_per_d             = 'Int Out Svc Max Enr Per Desc'
	pbp_b5b_coins_yn                 = 'Int Out Svc Coinsurance YN'
	pbp_b5b_coins_pct                = 'Int Out Svc MC Coins Pct'
	pbp_b5b_coins_pct_min            = 'Int Out Svc MC Coins Min Pct'
	pbp_b5b_coins_pct_max            = 'Int Out Svc MC Coins Max Pct'
	pbp_b5b_ded_yn                   = 'Int Out Svc Deductible YN'
	pbp_b5b_ded_amt                  = 'Int Out Svc Deductible Amt'
	pbp_b5b_copay_yn                 = 'Int Out Svc Copayment YN'
	pbp_b5b_copay_amt                = 'Int Out Svc Copay Amt'
	pbp_b5b_copay_amt_min            = 'Int Out Svc Copay Min Amt'
	pbp_b5b_copay_amt_max            = 'Int Out Svc Copay Max Amt'
	pbp_b5b_auth_yn                  = 'Int Out Svc Enrollee Auth'
	pbp_b5b_refer_yn                 = 'Int Out Svc Referral YN'
;

run;

proc sort data = pbp_b5 out=out.pbp_b5;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b5(obs = 10);
  title 'pbp_b5_partial_hosp file ';
run;

proc means data = out.pbp_b5;
  title 'pbp_b5_partial_hosp file ';
run;

proc freq data = out.pbp_b5;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_b5_maxenr_yn
	pbp_b5_maxenr_per
	pbp_b5_coins_yn
	pbp_b5_ded_yn
	pbp_b5_copay_yn
	pbp_b5_auth_yn
	pbp_b5_refer_yn
	pbp_b5b_maxenr_yn
	pbp_b5b_maxenr_per
	pbp_b5b_coins_yn
	pbp_b5b_ded_yn
	pbp_b5b_copay_yn
	pbp_b5b_auth_yn
	pbp_b5b_refer_yn
/ missing;
run;

proc contents data = out.pbp_b5;
  title 'pbp_b5 data';
run;