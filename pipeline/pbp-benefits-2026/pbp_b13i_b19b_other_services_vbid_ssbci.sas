*pbp_b13i_b19b_other_services_vbid_ssbci.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b13iO_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b13i_bendesc_oth             $5
	pbp_b13i_o1_bendesc_service      $250
	pbp_b13i_o1_bendesc_amo          $1
	pbp_b13i_o1_maxplan_yn           $1
	pbp_b13i_o1_maxplan_per          $1
	pbp_b13i_o1_maxplan_per_d        $4000
	pbp_b13i_o1_maxenr_yn            $1
	pbp_b13i_o1_maxenr_per           $1
	pbp_b13i_o1_maxenr_per_d         $4000
	pbp_b13i_o1_coins_yn             $1
	pbp_b13i_o1_ded_yn               $1
	pbp_b13i_o1_copay_yn             $1
	pbp_b13i_o1_auth_yn              $1
	pbp_b13i_o1_refer_yn             $1
	pbp_b13i_o2_bendesc_service      $250
	pbp_b13i_o2_bendesc_amo          $1
	pbp_b13i_o2_maxplan_yn           $1
	pbp_b13i_o2_maxplan_per          $1
	pbp_b13i_o2_maxplan_per_d        $4000
	pbp_b13i_o2_maxenr_yn            $1
	pbp_b13i_o2_maxenr_per           $1
	pbp_b13i_o2_maxenr_per_d         $4000
	pbp_b13i_o2_coins_yn             $1
	pbp_b13i_o2_ded_yn               $1
	pbp_b13i_o2_copay_yn             $1
	pbp_b13i_o2_auth_yn              $1
	pbp_b13i_o2_refer_yn             $1
	pbp_b13i_o3_bendesc_service      $250
	pbp_b13i_o3_bendesc_amo          $1
	pbp_b13i_o3_maxplan_yn           $1
	pbp_b13i_o3_maxplan_per          $1
	pbp_b13i_o3_maxplan_per_d        $4000
	pbp_b13i_o3_maxenr_yn            $1
	pbp_b13i_o3_maxenr_per           $1
	pbp_b13i_o3_maxenr_per_d         $4000
	pbp_b13i_o3_coins_yn             $1
	pbp_b13i_o3_ded_yn               $1
	pbp_b13i_o3_copay_yn             $1
	pbp_b13i_o3_auth_yn              $1
	pbp_b13i_o3_refer_yn             $1
	pbp_b13i_o4_bendesc_service      $250
	pbp_b13i_o4_bendesc_amo          $1
	pbp_b13i_o4_maxplan_yn           $1
	pbp_b13i_o4_maxplan_per          $1
	pbp_b13i_o4_maxplan_per_d        $4000
	pbp_b13i_o4_maxenr_yn            $1
	pbp_b13i_o4_maxenr_per           $1
	pbp_b13i_o4_maxenr_per_d         $4000
	pbp_b13i_o4_coins_yn             $1
	pbp_b13i_o4_ded_yn               $1
	pbp_b13i_o4_copay_yn             $1
	pbp_b13i_o4_auth_yn              $1
	pbp_b13i_o4_refer_yn             $1
	pbp_b13i_o5_bendesc_service      $250
	pbp_b13i_o5_bendesc_amo          $1
	pbp_b13i_o5_maxplan_yn           $1
	pbp_b13i_o5_maxplan_per          $1
	pbp_b13i_o5_maxplan_per_d        $4000
	pbp_b13i_o5_maxenr_yn            $1
	pbp_b13i_o5_maxenr_per           $1
	pbp_b13i_o5_maxenr_per_d         $4000
	pbp_b13i_o5_coins_yn             $1
	pbp_b13i_o5_ded_yn               $1
	pbp_b13i_o5_copay_yn             $1
	pbp_b13i_o5_auth_yn              $1
	pbp_b13i_o5_refer_yn             $1
;

infile '.\pbp\pbp_b13i_b19b_other_services_vbid_ssbci.txt' delimiter = '09'x
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
	pbp_vbid_group_id
	pbp_b13i_bendesc_oth
	pbp_b13i_o1_bendesc_service
	pbp_b13i_o1_bendesc_amo
	pbp_b13i_o1_maxplan_yn
	pbp_b13i_o1_maxplan_amt
	pbp_b13i_o1_maxplan_per
	pbp_b13i_o1_maxplan_per_d
	pbp_b13i_o1_maxenr_yn
	pbp_b13i_o1_maxenr_amt
	pbp_b13i_o1_maxenr_per
	pbp_b13i_o1_maxenr_per_d
	pbp_b13i_o1_coins_yn
	pbp_b13i_o1_coins_pct_min
	pbp_b13i_o1_coins_pct_max
	pbp_b13i_o1_ded_yn
	pbp_b13i_o1_ded_amt
	pbp_b13i_o1_copay_yn
	pbp_b13i_o1_copay_amt_min
	pbp_b13i_o1_copay_amt_max
	pbp_b13i_o1_auth_yn
	pbp_b13i_o1_refer_yn
	pbp_b13i_o2_bendesc_service
	pbp_b13i_o2_bendesc_amo
	pbp_b13i_o2_maxplan_yn
	pbp_b13i_o2_maxplan_amt
	pbp_b13i_o2_maxplan_per
	pbp_b13i_o2_maxplan_per_d
	pbp_b13i_o2_maxenr_yn
	pbp_b13i_o2_maxenr_amt
	pbp_b13i_o2_maxenr_per
	pbp_b13i_o2_maxenr_per_d
	pbp_b13i_o2_coins_yn
	pbp_b13i_o2_coins_pct_min
	pbp_b13i_o2_coins_pct_max
	pbp_b13i_o2_ded_yn
	pbp_b13i_o2_ded_amt
	pbp_b13i_o2_copay_yn
	pbp_b13i_o2_copay_amt_min
	pbp_b13i_o2_copay_amt_max
	pbp_b13i_o2_auth_yn
	pbp_b13i_o2_refer_yn
	pbp_b13i_o3_bendesc_service
	pbp_b13i_o3_bendesc_amo
	pbp_b13i_o3_maxplan_yn
	pbp_b13i_o3_maxplan_amt
	pbp_b13i_o3_maxplan_per
	pbp_b13i_o3_maxplan_per_d
	pbp_b13i_o3_maxenr_yn
	pbp_b13i_o3_maxenr_amt
	pbp_b13i_o3_maxenr_per
	pbp_b13i_o3_maxenr_per_d
	pbp_b13i_o3_coins_yn
	pbp_b13i_o3_coins_pct_min
	pbp_b13i_o3_coins_pct_max
	pbp_b13i_o3_ded_yn
	pbp_b13i_o3_ded_amt
	pbp_b13i_o3_copay_yn
	pbp_b13i_o3_copay_amt_min
	pbp_b13i_o3_copay_amt_max
	pbp_b13i_o3_auth_yn
	pbp_b13i_o3_refer_yn
	pbp_b13i_o4_bendesc_service
	pbp_b13i_o4_bendesc_amo
	pbp_b13i_o4_maxplan_yn
	pbp_b13i_o4_maxplan_amt
	pbp_b13i_o4_maxplan_per
	pbp_b13i_o4_maxplan_per_d
	pbp_b13i_o4_maxenr_yn
	pbp_b13i_o4_maxenr_amt
	pbp_b13i_o4_maxenr_per
	pbp_b13i_o4_maxenr_per_d
	pbp_b13i_o4_coins_yn
	pbp_b13i_o4_coins_pct_min
	pbp_b13i_o4_coins_pct_max
	pbp_b13i_o4_ded_yn
	pbp_b13i_o4_ded_amt
	pbp_b13i_o4_copay_yn
	pbp_b13i_o4_copay_amt_min
	pbp_b13i_o4_copay_amt_max
	pbp_b13i_o4_auth_yn
	pbp_b13i_o4_refer_yn
	pbp_b13i_o5_bendesc_service
	pbp_b13i_o5_bendesc_amo
	pbp_b13i_o5_maxplan_yn
	pbp_b13i_o5_maxplan_amt
	pbp_b13i_o5_maxplan_per
	pbp_b13i_o5_maxplan_per_d
	pbp_b13i_o5_maxenr_yn
	pbp_b13i_o5_maxenr_amt
	pbp_b13i_o5_maxenr_per
	pbp_b13i_o5_maxenr_per_d
	pbp_b13i_o5_coins_yn
	pbp_b13i_o5_coins_pct_min
	pbp_b13i_o5_coins_pct_max
	pbp_b13i_o5_ded_yn
	pbp_b13i_o5_ded_amt
	pbp_b13i_o5_copay_yn
	pbp_b13i_o5_copay_amt_min
	pbp_b13i_o5_copay_amt_max
	pbp_b13i_o5_auth_yn
	pbp_b13i_o5_refer_yn
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
	pbp_vbid_group_id                = 'B19 VBID Group (Package) ID'
	pbp_b13i_bendesc_oth             = '13I Othr Non-Health type'
	pbp_b13i_o1_bendesc_service      = 'Other 1 Name of Service'
	pbp_b13i_o1_bendesc_amo          = 'Other 1 Ben Desc MO'
	pbp_b13i_o1_maxplan_yn           = 'Other 1 Max Plan YN'
	pbp_b13i_o1_maxplan_amt          = 'Other 1 Max Plan Amt'
	pbp_b13i_o1_maxplan_per          = 'Other 1 Max Plan Per'
	pbp_b13i_o1_maxplan_per_d        = 'Other 1 Max Plan Per Desc'
	pbp_b13i_o1_maxenr_yn            = 'Other 1 Max Enr YN'
	pbp_b13i_o1_maxenr_amt           = 'Other 1 Max Enr Amt'
	pbp_b13i_o1_maxenr_per           = 'Other 1 Max Enr Per'
	pbp_b13i_o1_maxenr_per_d         = 'Other 1 Max Enr Per Desc'
	pbp_b13i_o1_coins_yn             = 'Other 1 Coinsurance YN'
	pbp_b13i_o1_coins_pct_min        = 'Other 1 Min Coins Pct'
	pbp_b13i_o1_coins_pct_max        = 'Other 1 Max Coins Pct'
	pbp_b13i_o1_ded_yn               = 'Other 1 Deductible YN'
	pbp_b13i_o1_ded_amt              = 'Other 1 Deductible Amt'
	pbp_b13i_o1_copay_yn             = 'Other 1 Copayment YN'
	pbp_b13i_o1_copay_amt_min        = 'Other 1 Min Copay Amt'
	pbp_b13i_o1_copay_amt_max        = 'Other 1 Max Copay Amt'
	pbp_b13i_o1_auth_yn              = 'Other 1 Enrollee Auth'
	pbp_b13i_o1_refer_yn             = 'Other 1 Referral YN'
	pbp_b13i_o2_bendesc_service      = 'Other 2 Name of Service'
	pbp_b13i_o2_bendesc_amo          = 'Other 2 Ben Desc MO'
	pbp_b13i_o2_maxplan_yn           = 'Other 2 Max Plan YN'
	pbp_b13i_o2_maxplan_amt          = 'Other 2 Max Plan Amt'
	pbp_b13i_o2_maxplan_per          = 'Other 2 Max Plan Per'
	pbp_b13i_o2_maxplan_per_d        = 'Other 2 Max Plan Per Desc'
	pbp_b13i_o2_maxenr_yn            = 'Other 2 Max Enr YN'
	pbp_b13i_o2_maxenr_amt           = 'Other 2 Max Enr Amt'
	pbp_b13i_o2_maxenr_per           = 'Other 2 Max Enr Per'
	pbp_b13i_o2_maxenr_per_d         = 'Other 2 Max Enr Per Desc'
	pbp_b13i_o2_coins_yn             = 'Other 2 Coinsurance YN'
	pbp_b13i_o2_coins_pct_min        = 'Other 2 Min Coins Pct'
	pbp_b13i_o2_coins_pct_max        = 'Other 2 Max Coins Pct'
	pbp_b13i_o2_ded_yn               = 'Other 2 Deductible YN'
	pbp_b13i_o2_ded_amt              = 'Other 2 Deductible Amt'
	pbp_b13i_o2_copay_yn             = 'Other 2 Copayment YN'
	pbp_b13i_o2_copay_amt_min        = 'Other 2 Min Copay Amt'
	pbp_b13i_o2_copay_amt_max        = 'Other 2 Max Copay Amt'
	pbp_b13i_o2_auth_yn              = 'Other 2 Enrollee Auth'
	pbp_b13i_o2_refer_yn             = 'Other 2 Referral YN'
	pbp_b13i_o3_bendesc_service      = 'Other 3 Name of Service'
	pbp_b13i_o3_bendesc_amo          = 'Other 3 Ben Desc MO'
	pbp_b13i_o3_maxplan_yn           = 'Other 3 Max Plan YN'
	pbp_b13i_o3_maxplan_amt          = 'Other 3 Max Plan Amt'
	pbp_b13i_o3_maxplan_per          = 'Other 3 Max Plan Per'
	pbp_b13i_o3_maxplan_per_d        = 'Other 3 Max Plan Per Desc'
	pbp_b13i_o3_maxenr_yn            = 'Other 3 Max Enr YN'
	pbp_b13i_o3_maxenr_amt           = 'Other 3 Max Enr Amt'
	pbp_b13i_o3_maxenr_per           = 'Other 3 Max Enr Per'
	pbp_b13i_o3_maxenr_per_d         = 'Other 3 Max Enr Per Desc'
	pbp_b13i_o3_coins_yn             = 'Other 3 Coinsurance YN'
	pbp_b13i_o3_coins_pct_min        = 'Other 3 Min Coins Pct'
	pbp_b13i_o3_coins_pct_max        = 'Other 3 Max Coins Pct'
	pbp_b13i_o3_ded_yn               = 'Other 3 Deductible YN'
	pbp_b13i_o3_ded_amt              = 'Other 3 Deductible Amt'
	pbp_b13i_o3_copay_yn             = 'Other 3 Copayment YN'
	pbp_b13i_o3_copay_amt_min        = 'Other 3 Min Copay Amt'
	pbp_b13i_o3_copay_amt_max        = 'Other 3 Max Copay Amt'
	pbp_b13i_o3_auth_yn              = 'Other 3 Enrollee Auth'
	pbp_b13i_o3_refer_yn             = 'Other 3 Referral YN'
	pbp_b13i_o4_bendesc_service      = 'Other 4 Name of Service'
	pbp_b13i_o4_bendesc_amo          = 'Other 4 Ben Desc MO'
	pbp_b13i_o4_maxplan_yn           = 'Other 4 Max Plan YN'
	pbp_b13i_o4_maxplan_amt          = 'Other 4 Max Plan Amt'
	pbp_b13i_o4_maxplan_per          = 'Other 4 Max Plan Per'
	pbp_b13i_o4_maxplan_per_d        = 'Other 4 Max Plan Per Desc'
	pbp_b13i_o4_maxenr_yn            = 'Other 4 Max Enr YN'
	pbp_b13i_o4_maxenr_amt           = 'Other 4 Max Enr Amt'
	pbp_b13i_o4_maxenr_per           = 'Other 4 Max Enr Per'
	pbp_b13i_o4_maxenr_per_d         = 'Other 4 Max Enr Per Desc'
	pbp_b13i_o4_coins_yn             = 'Other 4 Coinsurance YN'
	pbp_b13i_o4_coins_pct_min        = 'Other 4 Min Coins Pct'
	pbp_b13i_o4_coins_pct_max        = 'Other 4 Max Coins Pct'
	pbp_b13i_o4_ded_yn               = 'Other 4 Deductible YN'
	pbp_b13i_o4_ded_amt              = 'Other 4 Deductible Amt'
	pbp_b13i_o4_copay_yn             = 'Other 4 Copayment YN'
	pbp_b13i_o4_copay_amt_min        = 'Other 4 Min Copay Amt'
	pbp_b13i_o4_copay_amt_max        = 'Other 4 Max Copay Amt'
	pbp_b13i_o4_auth_yn              = 'Other 4 Enrollee Auth'
	pbp_b13i_o4_refer_yn             = 'Other 4 Referral YN'
	pbp_b13i_o5_bendesc_service      = 'Other 5 Name of Service'
	pbp_b13i_o5_bendesc_amo          = 'Other 5 Ben Desc MO'
	pbp_b13i_o5_maxplan_yn           = 'Other 5 Max Plan YN'
	pbp_b13i_o5_maxplan_amt          = 'Other 5 Max Plan Amt'
	pbp_b13i_o5_maxplan_per          = 'Other 5 Max Plan Per'
	pbp_b13i_o5_maxplan_per_d        = 'Other 5 Max Plan Per Desc'
	pbp_b13i_o5_maxenr_yn            = 'Other 5 Max Enr YN'
	pbp_b13i_o5_maxenr_amt           = 'Other 5 Max Enr Amt'
	pbp_b13i_o5_maxenr_per           = 'Other 5 Max Enr Per'
	pbp_b13i_o5_maxenr_per_d         = 'Other 5 Max Enr Per Desc'
	pbp_b13i_o5_coins_yn             = 'Other 5 Coinsurance YN'
	pbp_b13i_o5_coins_pct_min        = 'Other 5 Min Coins Pct'
	pbp_b13i_o5_coins_pct_max        = 'Other 5 Max Coins Pct'
	pbp_b13i_o5_ded_yn               = 'Other 5 Deductible YN'
	pbp_b13i_o5_ded_amt              = 'Other 5 Deductible Amt'
	pbp_b13i_o5_copay_yn             = 'Other 5 Copayment YN'
	pbp_b13i_o5_copay_amt_min        = 'Other 5 Min Copay Amt'
	pbp_b13i_o5_copay_amt_max        = 'Other 5 Max Copay Amt'
	pbp_b13i_o5_auth_yn              = 'Other 5 Enrollee Auth'
	pbp_b13i_o5_refer_yn             = 'Other 5 Referral YN'
;

run;

proc sort data = pbp_b13iO_vbid out=out.pbp_b13iO_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b13iO_vbid(obs = 10);
  title 'pbp_b13i_b19b_other_services_vbid_ssbci file ';
run;

proc means data = out.pbp_b13iO_vbid;
  title 'pbp_b13i_b19b_other_services_vbid_ssbci file ';
run;

proc freq data = out.pbp_b13iO_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b13i_bendesc_oth
	pbp_b13i_o1_bendesc_amo
	pbp_b13i_o1_maxplan_yn
	pbp_b13i_o1_maxplan_per
	pbp_b13i_o1_maxenr_yn
	pbp_b13i_o1_maxenr_per
	pbp_b13i_o1_coins_yn
	pbp_b13i_o1_ded_yn
	pbp_b13i_o1_copay_yn
	pbp_b13i_o1_auth_yn
	pbp_b13i_o1_refer_yn
	pbp_b13i_o2_bendesc_amo
	pbp_b13i_o2_maxplan_yn
	pbp_b13i_o2_maxplan_per
	pbp_b13i_o2_maxenr_yn
	pbp_b13i_o2_maxenr_per
	pbp_b13i_o2_coins_yn
	pbp_b13i_o2_ded_yn
	pbp_b13i_o2_copay_yn
	pbp_b13i_o2_auth_yn
	pbp_b13i_o2_refer_yn
	pbp_b13i_o3_bendesc_amo
	pbp_b13i_o3_maxplan_yn
	pbp_b13i_o3_maxplan_per
	pbp_b13i_o3_maxenr_yn
	pbp_b13i_o3_maxenr_per
	pbp_b13i_o3_coins_yn
	pbp_b13i_o3_ded_yn
	pbp_b13i_o3_copay_yn
	pbp_b13i_o3_auth_yn
	pbp_b13i_o3_refer_yn
	pbp_b13i_o4_bendesc_amo
	pbp_b13i_o4_maxplan_yn
	pbp_b13i_o4_maxplan_per
	pbp_b13i_o4_maxenr_yn
	pbp_b13i_o4_maxenr_per
	pbp_b13i_o4_coins_yn
	pbp_b13i_o4_ded_yn
	pbp_b13i_o4_copay_yn
	pbp_b13i_o4_auth_yn
	pbp_b13i_o4_refer_yn
	pbp_b13i_o5_bendesc_amo
	pbp_b13i_o5_maxplan_yn
	pbp_b13i_o5_maxplan_per
	pbp_b13i_o5_maxenr_yn
	pbp_b13i_o5_maxenr_per
	pbp_b13i_o5_coins_yn
	pbp_b13i_o5_ded_yn
	pbp_b13i_o5_copay_yn
	pbp_b13i_o5_auth_yn
	pbp_b13i_o5_refer_yn
/ missing;
run;

proc contents data = out.pbp_b13iO_vbid;
  title 'pbp_b13iO_vbid data';
run;