*pbp_b13_b19b_other_services_vbid_uf.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b13_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b13a_bendesc_yn              $1
	pbp_b13a_bendesc_ehc             $1
	pbp_b13a_bendesc_amo             $1
	pbp_b13a_bendesc_lim             $1
	pbp_b13a_bendesc_per             $1
	pbp_b13a_bendesc_per_d           $4000
	pbp_b13a_maxplan_yn              $1
	pbp_b13a_maxplan_per             $1
	pbp_b13a_maxplan_per_d           $4000
	pbp_b13a_maxenr_yn               $1
	pbp_b13a_maxenr_per              $1
	pbp_b13a_maxenr_per_d            $4000
	pbp_b13a_coins_yn                $1
	pbp_b13a_ded_yn                  $1
	pbp_b13a_copay_yn                $1
	pbp_b13a_auth_yn                 $1
	pbp_b13a_refer_yn                $1
	pbp_b13b_bendesc_otc             $1
	pbp_b13b_bendesc_amo             $1
	pbp_b13b_maxplan_yn              $1
	pbp_b13b_otc_maxplan_per         $1
	pbp_b13b_maxplan_prd_yn          $1
	pbp_b13b_maxenr_yn               $1
	pbp_b13b_maxenr_per              $1
	pbp_b13b_maxenr_per_d            $4000
	pbp_b13b_nrt_yn                  $1
	pbp_b13b_nrt_attestation         $1
	pbp_b13b_naloxone_yn             $1
	pbp_b13b_coins_yn                $1
	pbp_b13b_ded_yn                  $1
	pbp_b13b_copay_yn                $1
	pbp_b13b_cms_otc_list_yn         $1
	pbp_b13b_mode                    $5
	pbp_b13b_mode_desc               $4000
	pbp_b13b_auth_yn                 $1
	pbp_b13c_bendesc_service         $1
	pbp_b13c_bendesc_amo             $1
	pbp_b13c_meal_type_chk           $3
	pbp_b13c_maxplan_yn              $1
	pbp_b13c_maxplan_per             $1
	pbp_b13c_maxplan_per_d           $4000
	pbp_b13c_maxenr_yn               $1
	pbp_b13c_maxenr_per              $1
	pbp_b13c_maxenr_per_d            $4000
	pbp_b13c_coins_yn                $1
	pbp_b13c_ded_yn                  $1
	pbp_b13c_copay_yn                $1
	pbp_b13c_auth_yn                 $1
	pbp_b13c_refer_yn                $1
	pbp_b13d_bendesc_service         $250
	pbp_b13d_bendesc_amo             $1
	pbp_b13d_maxplan_yn              $1
	pbp_b13d_maxplan_per             $1
	pbp_b13d_maxplan_per_d           $4000
	pbp_b13d_maxenr_yn               $1
	pbp_b13d_maxenr_per              $1
	pbp_b13d_maxenr_per_d            $4000
	pbp_b13d_coins_yn                $1
	pbp_b13d_ded_yn                  $1
	pbp_b13d_copay_yn                $1
	pbp_b13d_auth_yn                 $1
	pbp_b13d_refer_yn                $1
	pbp_b13e_bendesc_service         $250
	pbp_b13e_bendesc_amo             $1
	pbp_b13e_maxplan_yn              $1
	pbp_b13e_maxplan_per             $1
	pbp_b13e_maxplan_per_d           $4000
	pbp_b13e_maxenr_yn               $1
	pbp_b13e_maxenr_per              $1
	pbp_b13e_maxenr_per_d            $4000
	pbp_b13e_coins_yn                $1
	pbp_b13e_ded_yn                  $1
	pbp_b13e_copay_yn                $1
	pbp_b13e_auth_yn                 $1
	pbp_b13e_refer_yn                $1
	pbp_b13f_bendesc_service         $250
	pbp_b13f_bendesc_amo             $1
	pbp_b13f_maxplan_yn              $1
	pbp_b13f_maxplan_per             $1
	pbp_b13f_maxplan_per_d           $4000
	pbp_b13f_maxenr_yn               $1
	pbp_b13f_maxenr_per              $1
	pbp_b13f_maxenr_per_d            $4000
	pbp_b13f_coins_yn                $1
	pbp_b13f_ded_yn                  $1
	pbp_b13f_copay_yn                $1
	pbp_b13f_auth_yn                 $1
	pbp_b13f_refer_yn                $1
;

infile '.\pbp\pbp_b13_b19b_other_services_vbid_uf.txt' delimiter = '09'x
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
	pbp_b13a_bendesc_yn
	pbp_b13a_bendesc_ehc
	pbp_b13a_bendesc_amo
	pbp_b13a_bendesc_lim
	pbp_b13a_bendesc_numv
	pbp_b13a_bendesc_per
	pbp_b13a_bendesc_per_d
	pbp_b13a_maxplan_yn
	pbp_b13a_maxplan_amt
	pbp_b13a_maxplan_per
	pbp_b13a_maxplan_per_d
	pbp_b13a_maxenr_yn
	pbp_b13a_maxenr_amt
	pbp_b13a_maxenr_per
	pbp_b13a_maxenr_per_d
	pbp_b13a_coins_yn
	pbp_b13a_coins_pct_min
	pbp_b13a_coins_pct_max
	pbp_b13a_ded_yn
	pbp_b13a_ded_amt
	pbp_b13a_copay_yn
	pbp_b13a_copay_amt_min
	pbp_b13a_copay_amt_max
	pbp_b13a_auth_yn
	pbp_b13a_refer_yn
	pbp_b13b_bendesc_otc
	pbp_b13b_bendesc_amo
	pbp_b13b_maxplan_yn
	pbp_b13b_maxplan_amt
	pbp_b13b_otc_maxplan_per
	pbp_b13b_maxplan_prd_yn
	pbp_b13b_maxenr_yn
	pbp_b13b_maxenr_amt
	pbp_b13b_maxenr_per
	pbp_b13b_maxenr_per_d
	pbp_b13b_nrt_yn
	pbp_b13b_nrt_attestation
	pbp_b13b_naloxone_yn
	pbp_b13b_coins_yn
	pbp_b13b_coins_pct_min
	pbp_b13b_coins_pct_max
	pbp_b13b_ded_yn
	pbp_b13b_ded_amt
	pbp_b13b_copay_yn
	pbp_b13b_copay_amt_min
	pbp_b13b_copay_amt_max
	pbp_b13b_cms_otc_list_yn
	pbp_b13b_mode
	pbp_b13b_mode_desc
	pbp_b13b_auth_yn
	pbp_b13c_bendesc_service
	pbp_b13c_bendesc_amo
	pbp_b13c_meal_type_chk
	pbp_b13c_maxplan_yn
	pbp_b13c_maxplan_amt
	pbp_b13c_maxplan_per
	pbp_b13c_maxplan_per_d
	pbp_b13c_maxenr_yn
	pbp_b13c_maxenr_amt
	pbp_b13c_maxenr_per
	pbp_b13c_maxenr_per_d
	pbp_b13c_coins_yn
	pbp_b13c_coins_pct_min
	pbp_b13c_coins_pct_max
	pbp_b13c_ded_yn
	pbp_b13c_ded_amt
	pbp_b13c_copay_yn
	pbp_b13c_copay_amt_min
	pbp_b13c_copay_amt_max
	pbp_b13c_auth_yn
	pbp_b13c_refer_yn
	pbp_b13d_bendesc_service
	pbp_b13d_bendesc_amo
	pbp_b13d_maxplan_yn
	pbp_b13d_maxplan_amt
	pbp_b13d_maxplan_per
	pbp_b13d_maxplan_per_d
	pbp_b13d_maxenr_yn
	pbp_b13d_maxenr_amt
	pbp_b13d_maxenr_per
	pbp_b13d_maxenr_per_d
	pbp_b13d_coins_yn
	pbp_b13d_coins_pct_min
	pbp_b13d_coins_pct_max
	pbp_b13d_ded_yn
	pbp_b13d_ded_amt
	pbp_b13d_copay_yn
	pbp_b13d_copay_amt_min
	pbp_b13d_copay_amt_max
	pbp_b13d_auth_yn
	pbp_b13d_refer_yn
	pbp_b13e_bendesc_service
	pbp_b13e_bendesc_amo
	pbp_b13e_maxplan_yn
	pbp_b13e_maxplan_amt
	pbp_b13e_maxplan_per
	pbp_b13e_maxplan_per_d
	pbp_b13e_maxenr_yn
	pbp_b13e_maxenr_amt
	pbp_b13e_maxenr_per
	pbp_b13e_maxenr_per_d
	pbp_b13e_coins_yn
	pbp_b13e_coins_pct_min
	pbp_b13e_coins_pct_max
	pbp_b13e_ded_yn
	pbp_b13e_ded_amt
	pbp_b13e_copay_yn
	pbp_b13e_copay_amt_min
	pbp_b13e_copay_amt_max
	pbp_b13e_auth_yn
	pbp_b13e_refer_yn
	pbp_b13f_bendesc_service
	pbp_b13f_bendesc_amo
	pbp_b13f_maxplan_yn
	pbp_b13f_maxplan_amt
	pbp_b13f_maxplan_per
	pbp_b13f_maxplan_per_d
	pbp_b13f_maxenr_yn
	pbp_b13f_maxenr_amt
	pbp_b13f_maxenr_per
	pbp_b13f_maxenr_per_d
	pbp_b13f_coins_yn
	pbp_b13f_coins_pct_min
	pbp_b13f_coins_pct_max
	pbp_b13f_ded_yn
	pbp_b13f_ded_amt
	pbp_b13f_copay_yn
	pbp_b13f_copay_amt_min
	pbp_b13f_copay_amt_max
	pbp_b13f_auth_yn
	pbp_b13f_refer_yn
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
	pbp_b13a_bendesc_yn              = 'Acupuncture Ben Desc YN'
	pbp_b13a_bendesc_ehc             = 'Acupuncture (13a) Ben Desc'
	pbp_b13a_bendesc_amo             = 'Acupuncture Ben AMO'
	pbp_b13a_bendesc_lim             = 'Acupuncture Ben Desc Lim YN'
	pbp_b13a_bendesc_numv            = 'Acupuncture Ben Desc Num'
	pbp_b13a_bendesc_per             = 'Acupuncture Ben Desc Per'
	pbp_b13a_bendesc_per_d           = 'Acupuncture Ben Per Desc'
	pbp_b13a_maxplan_yn              = 'Acupuncture Max Plan YN'
	pbp_b13a_maxplan_amt             = 'Acupuncture Max Plan Amt'
	pbp_b13a_maxplan_per             = 'Acupuncture Max Plan Per'
	pbp_b13a_maxplan_per_d           = 'Acupuncture Max Plan Per Desc'
	pbp_b13a_maxenr_yn               = 'Acupuncture Max Enr YN'
	pbp_b13a_maxenr_amt              = 'Acupuncture Max Enr Amt'
	pbp_b13a_maxenr_per              = 'Acupuncture Max Enr Per'
	pbp_b13a_maxenr_per_d            = 'Acupuncture Max Enr Per Desc'
	pbp_b13a_coins_yn                = 'Acupuncture Coinsurance YN'
	pbp_b13a_coins_pct_min           = 'Acupuncture Min Coins Pct'
	pbp_b13a_coins_pct_max           = 'Acupuncture Max Coins Pct'
	pbp_b13a_ded_yn                  = 'Acupuncture Deductible YN'
	pbp_b13a_ded_amt                 = 'Acupuncture Deductible Amt'
	pbp_b13a_copay_yn                = 'Acupuncture Copayment YN'
	pbp_b13a_copay_amt_min           = 'Acupuncture Min Copay Amt'
	pbp_b13a_copay_amt_max           = 'Acupuncture Max Copay Amt'
	pbp_b13a_auth_yn                 = 'Acupuncture Auth YN'
	pbp_b13a_refer_yn                = 'Acupuncture Referral YN'
	pbp_b13b_bendesc_otc             = 'OTC Drugs'
	pbp_b13b_bendesc_amo             = 'OTC Ben Desc MO'
	pbp_b13b_maxplan_yn              = 'OTC Max Plan YN'
	pbp_b13b_maxplan_amt             = 'OTC Max Plan Amt'
	pbp_b13b_otc_maxplan_per         = 'OTC Max Period'
	pbp_b13b_maxplan_prd_yn          = 'OTC Maxplan period YN'
	pbp_b13b_maxenr_yn               = 'OTC Max Enr YN'
	pbp_b13b_maxenr_amt              = 'OTC Max Enr Amt'
	pbp_b13b_maxenr_per              = 'OTC Max Enr Per'
	pbp_b13b_maxenr_per_d            = 'OTC Max Enr Per Desc'
	pbp_b13b_nrt_yn                  = 'OTC NRT yn'
	pbp_b13b_nrt_attestation         = 'OTC NRT attestation'
	pbp_b13b_naloxone_yn             = 'OTC Naloxone YN'
	pbp_b13b_coins_yn                = 'OTC Coinsurance YN'
	pbp_b13b_coins_pct_min           = 'OTC Min Coins Pct'
	pbp_b13b_coins_pct_max           = 'OTC Max Coins Pct'
	pbp_b13b_ded_yn                  = 'OTC Deductible YN'
	pbp_b13b_ded_amt                 = 'OTC Deductible Amt'
	pbp_b13b_copay_yn                = 'OTC Copayment YN'
	pbp_b13b_copay_amt_min           = 'OTC Min Copay Amt'
	pbp_b13b_copay_amt_max           = 'OTC Max Copay Amt'
	pbp_b13b_cms_otc_list_yn         = 'CMS OTC List'
	pbp_b13b_mode                    = 'OTC deliver mode'
	pbp_b13b_mode_desc               = 'OTC other deliver mode'
	pbp_b13b_auth_yn                 = 'OTC Benefit Auth YN'
	pbp_b13c_bendesc_service         = 'Meal Benefit'
	pbp_b13c_bendesc_amo             = 'Meal Benefit Ben Desc MO'
	pbp_b13c_meal_type_chk           = 'Meal Benefit Type Offered'
	pbp_b13c_maxplan_yn              = 'Meal Benefit Max Plan YN'
	pbp_b13c_maxplan_amt             = 'Meal Benefit Max Plan Amt'
	pbp_b13c_maxplan_per             = 'Meal Benefit Max Plan Per'
	pbp_b13c_maxplan_per_d           = 'Meal Max Plan Per Desc'
	pbp_b13c_maxenr_yn               = 'Meal Benefit Max Enr YN'
	pbp_b13c_maxenr_amt              = 'Meal Benefit Max Enr Amt'
	pbp_b13c_maxenr_per              = 'Meal Benefit Max Enr Per'
	pbp_b13c_maxenr_per_d            = 'Meal Max Enr Per Desc'
	pbp_b13c_coins_yn                = 'Meal Benefit YN'
	pbp_b13c_coins_pct_min           = 'Meal Benefit Min Coins Pct'
	pbp_b13c_coins_pct_max           = 'Meal Benefit Max Coins Pct'
	pbp_b13c_ded_yn                  = 'Meal Benefit Deductible YN'
	pbp_b13c_ded_amt                 = 'Meal Benefit Deductible Amt'
	pbp_b13c_copay_yn                = 'Meal Benefit Copayment YN'
	pbp_b13c_copay_amt_min           = 'Meal Benefit Min Copay Amt'
	pbp_b13c_copay_amt_max           = 'Meal Benefit Max Copay Amt'
	pbp_b13c_auth_yn                 = 'Meal Benefit Auth YN'
	pbp_b13c_refer_yn                = 'Meal Benefit Referral YN'
	pbp_b13d_bendesc_service         = 'Other 1 Name of Service'
	pbp_b13d_bendesc_amo             = 'Other 1 Ben Desc MO'
	pbp_b13d_maxplan_yn              = 'Other 1 Max Plan YN'
	pbp_b13d_maxplan_amt             = 'Other 1 Max Plan Amt'
	pbp_b13d_maxplan_per             = 'Other 1 Max Plan Per'
	pbp_b13d_maxplan_per_d           = 'Other 1 Max Plan Per Desc'
	pbp_b13d_maxenr_yn               = 'Other 1 Max Enr YN'
	pbp_b13d_maxenr_amt              = 'Other 1 Max Enr Amt'
	pbp_b13d_maxenr_per              = 'Other 1 Max Enr Per'
	pbp_b13d_maxenr_per_d            = 'Other 1 Max Enr Per Desc'
	pbp_b13d_coins_yn                = 'Other 1 Coinsurance YN'
	pbp_b13d_coins_pct_min           = 'Other 1 Min Coins Pct'
	pbp_b13d_coins_pct_max           = 'Other 1 Max Coins Pct'
	pbp_b13d_ded_yn                  = 'Other 1 Deductible YN'
	pbp_b13d_ded_amt                 = 'Other 1 Deductible Amt'
	pbp_b13d_copay_yn                = 'Other 1 Copayment YN'
	pbp_b13d_copay_amt_min           = 'Other 1 Min Copay Amt'
	pbp_b13d_copay_amt_max           = 'Other 1 Max Copay Amt'
	pbp_b13d_auth_yn                 = 'Other 1 Auth YN'
	pbp_b13d_refer_yn                = 'Other 1 Referral YN'
	pbp_b13e_bendesc_service         = 'Other 2 Name of Service'
	pbp_b13e_bendesc_amo             = 'Other 2 Ben Desc MO'
	pbp_b13e_maxplan_yn              = 'Other 2 Max Plan YN'
	pbp_b13e_maxplan_amt             = 'Other 2 Max Plan Amt'
	pbp_b13e_maxplan_per             = 'Other 2 Max Plan Per'
	pbp_b13e_maxplan_per_d           = 'Other 2 Max Plan Per Desc'
	pbp_b13e_maxenr_yn               = 'Other 2 Max Enr YN'
	pbp_b13e_maxenr_amt              = 'Other 2 Max Enr Amt'
	pbp_b13e_maxenr_per              = 'Other 2 Max Enr Per'
	pbp_b13e_maxenr_per_d            = 'Other 2 Max Enr Per Desc'
	pbp_b13e_coins_yn                = 'Other 2 Coinsurance YN'
	pbp_b13e_coins_pct_min           = 'Other 2 Min Coins Pct'
	pbp_b13e_coins_pct_max           = 'Other 2 Max Coins Pct'
	pbp_b13e_ded_yn                  = 'Other 2 Deductible YN'
	pbp_b13e_ded_amt                 = 'Other 2 Deductible Amt'
	pbp_b13e_copay_yn                = 'Other 2 Copayment YN'
	pbp_b13e_copay_amt_min           = 'Other 2 Min Copay Amt'
	pbp_b13e_copay_amt_max           = 'Other 2 Max Copay Amt'
	pbp_b13e_auth_yn                 = 'Other 2 Auth YN'
	pbp_b13e_refer_yn                = 'Other 2 Referral YN'
	pbp_b13f_bendesc_service         = 'Other 3 Name of Service'
	pbp_b13f_bendesc_amo             = 'Other 3 Ben Desc MO'
	pbp_b13f_maxplan_yn              = 'Other 3 Max Plan YN'
	pbp_b13f_maxplan_amt             = 'Other 3 Max Plan Amt'
	pbp_b13f_maxplan_per             = 'Other 3 Max Plan Per'
	pbp_b13f_maxplan_per_d           = 'Other 3 Max Plan Per Desc'
	pbp_b13f_maxenr_yn               = 'Other 3 Max Enr YN'
	pbp_b13f_maxenr_amt              = 'Other 3 Max Enr Amt'
	pbp_b13f_maxenr_per              = 'Other 3 Max Enr Per'
	pbp_b13f_maxenr_per_d            = 'Other 3 Max Enr Per Desc'
	pbp_b13f_coins_yn                = 'Other 3 Coinsurance YN'
	pbp_b13f_coins_pct_min           = 'Other 3 Min Coins Pct'
	pbp_b13f_coins_pct_max           = 'Other 3 Max Coins Pct'
	pbp_b13f_ded_yn                  = 'Other 3 Deductible YN'
	pbp_b13f_ded_amt                 = 'Other 3 Deductible Amt'
	pbp_b13f_copay_yn                = 'Other 3 Copayment YN'
	pbp_b13f_copay_amt_min           = 'Other 3 Min Copay Amt'
	pbp_b13f_copay_amt_max           = 'Other 3 Max Copay Amt'
	pbp_b13f_auth_yn                 = 'Other 3 Auth YN'
	pbp_b13f_refer_yn                = 'Other 3 Referral YN'
;

run;

proc sort data = pbp_b13_vbid out=out.pbp_b13_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b13_vbid(obs = 10);
  title 'pbp_b13_b19b_other_services_vbid_uf file ';
run;

proc means data = out.pbp_b13_vbid;
  title 'pbp_b13_b19b_other_services_vbid_uf file ';
run;

proc freq data = out.pbp_b13_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b13a_bendesc_yn
	pbp_b13a_bendesc_ehc
	pbp_b13a_bendesc_amo
	pbp_b13a_bendesc_lim
	pbp_b13a_bendesc_per
	pbp_b13a_maxplan_yn
	pbp_b13a_maxplan_per
	pbp_b13a_maxenr_yn
	pbp_b13a_maxenr_per
	pbp_b13a_coins_yn
	pbp_b13a_ded_yn
	pbp_b13a_copay_yn
	pbp_b13a_auth_yn
	pbp_b13a_refer_yn
	pbp_b13b_bendesc_otc
	pbp_b13b_bendesc_amo
	pbp_b13b_maxplan_yn
	pbp_b13b_otc_maxplan_per
	pbp_b13b_maxplan_prd_yn
	pbp_b13b_maxenr_yn
	pbp_b13b_maxenr_per
	pbp_b13b_nrt_yn
	pbp_b13b_nrt_attestation
	pbp_b13b_naloxone_yn
	pbp_b13b_coins_yn
	pbp_b13b_ded_yn
	pbp_b13b_copay_yn
	pbp_b13b_cms_otc_list_yn
	pbp_b13b_mode
	pbp_b13b_auth_yn
	pbp_b13c_bendesc_service
	pbp_b13c_bendesc_amo
	pbp_b13c_meal_type_chk
	pbp_b13c_maxplan_yn
	pbp_b13c_maxplan_per
	pbp_b13c_maxenr_yn
	pbp_b13c_maxenr_per
	pbp_b13c_coins_yn
	pbp_b13c_ded_yn
	pbp_b13c_copay_yn
	pbp_b13c_auth_yn
	pbp_b13c_refer_yn
	pbp_b13d_bendesc_amo
	pbp_b13d_maxplan_yn
	pbp_b13d_maxplan_per
	pbp_b13d_maxenr_yn
	pbp_b13d_maxenr_per
	pbp_b13d_coins_yn
	pbp_b13d_ded_yn
	pbp_b13d_copay_yn
	pbp_b13d_auth_yn
	pbp_b13d_refer_yn
	pbp_b13e_bendesc_amo
	pbp_b13e_maxplan_yn
	pbp_b13e_maxplan_per
	pbp_b13e_maxenr_yn
	pbp_b13e_maxenr_per
	pbp_b13e_coins_yn
	pbp_b13e_ded_yn
	pbp_b13e_copay_yn
	pbp_b13e_auth_yn
	pbp_b13e_refer_yn
	pbp_b13f_bendesc_amo
	pbp_b13f_maxplan_yn
	pbp_b13f_maxplan_per
	pbp_b13f_maxenr_yn
	pbp_b13f_maxenr_per
	pbp_b13f_coins_yn
	pbp_b13f_ded_yn
	pbp_b13f_copay_yn
	pbp_b13f_auth_yn
	pbp_b13f_refer_yn
/ missing;
run;

proc contents data = out.pbp_b13_vbid;
  title 'pbp_b13_vbid data';
run;