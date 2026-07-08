*pbp_b12_renal_dialysis.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b12;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_b12_maxenr_yn                $1
	pbp_b12_maxenr_per               $1
	pbp_b12_maxenr_per_d             $4000
	pbp_b12_coins_yn                 $1
	pbp_b12_ded_yn                   $1
	pbp_b12_copay_yn                 $1
	pbp_b12_auth_yn                  $1
	pbp_b12_refer_yn                 $1
;

infile '.\pbp\pbp_b12_renal_dialysis.txt' delimiter = '09'x
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
	pbp_b12_maxenr_yn
	pbp_b12_maxenr_amt
	pbp_b12_maxenr_per
	pbp_b12_maxenr_per_d
	pbp_b12_coins_yn
	pbp_b12_coins_pct_mc
	pbp_b12_coins_max_pct_mc
	pbp_b12_ded_yn
	pbp_b12_ded_amt
	pbp_b12_copay_yn
	pbp_b12_copay_mc_amt
	pbp_b12_copay_mc_max_amt
	pbp_b12_auth_yn
	pbp_b12_refer_yn
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
	pbp_b12_maxenr_yn                = 'Renal Disease Max Enr YN'
	pbp_b12_maxenr_amt               = 'Renal Disease Max Enr Amt'
	pbp_b12_maxenr_per               = 'Renal Disease Max Enr Per'
	pbp_b12_maxenr_per_d             = 'Renal Dis Max Enr Per Desc'
	pbp_b12_coins_yn                 = 'Renal Disease Coinsurance YN'
	pbp_b12_coins_pct_mc             = 'Renal Disease Min Coins Pct'
	pbp_b12_coins_max_pct_mc         = 'Renal Disease Max Coins Pct'
	pbp_b12_ded_yn                   = 'Renal Disease Deductible YN'
	pbp_b12_ded_amt                  = 'Renal Disease Deductible Amt'
	pbp_b12_copay_yn                 = 'Renal Disease Copayment YN'
	pbp_b12_copay_mc_amt             = 'Renal Disease Min Copay Amt'
	pbp_b12_copay_mc_max_amt         = 'Renal Disease Max Copay Amt'
	pbp_b12_auth_yn                  = 'Renal Disease Auth YN'
	pbp_b12_refer_yn                 = 'Renal Disease Referral YN'
;

run;

proc sort data = pbp_b12 out=out.pbp_b12;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b12(obs = 10);
  title 'pbp_b12_renal_dialysis file ';
run;

proc means data = out.pbp_b12;
  title 'pbp_b12_renal_dialysis file ';
run;

proc freq data = out.pbp_b12;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_b12_maxenr_yn
	pbp_b12_maxenr_per
	pbp_b12_coins_yn
	pbp_b12_ded_yn
	pbp_b12_copay_yn
	pbp_b12_auth_yn
	pbp_b12_refer_yn
/ missing;
run;

proc contents data = out.pbp_b12;
  title 'pbp_b12 data';
run;