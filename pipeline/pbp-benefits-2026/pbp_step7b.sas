*pbp_step7b.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step7b;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_7b_yn         $1
	pbp_d_opt_use_mand_7b1_yn        $1
	pbp_d_opt_use_mand_7b2_yn        $1
	pbp_b7b_bendesc_yn               $1
	pbp_b7b_bendesc_ehc              $2
	pbp_b7b_bendesc_amo_rc           $1
	pbp_b7b_bendesc_lim_rc           $1
	pbp_b7b_bendesc_per_rc           $1
	pbp_b7b_bendesc_per_rc_d         $4000
	pbp_b7b_addl_service_other       $250
	pbp_b7b_bendesc_amo_other        $1
	pbp_b7b_bendesc_lim_other        $1
	pbp_b7b_bendesc_per_other        $1
	pbp_b7b_bendesc_per_other_d      $4000
	pbp_b7b_maxplan_yn               $1
	pbp_b7b_maxplan_per              $1
	pbp_b7b_maxplan_per_d            $4000
	pbp_b7b_coins_yn                 $1
	pbp_b7b_coins_ehc                $3
	pbp_b7b_copay_yn                 $1
	pbp_b7b_copay_ehc                $3
	pbp_b7b_auth_yn                  $1
	pbp_b7b_refer_yn                 $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step7b.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_7b_yn
	pbp_d_opt_use_mand_7b1_yn
	pbp_d_opt_use_mand_7b2_yn
	pbp_b7b_bendesc_yn
	pbp_b7b_bendesc_ehc
	pbp_b7b_bendesc_amo_rc
	pbp_b7b_bendesc_lim_rc
	pbp_b7b_bendesc_num_rc
	pbp_b7b_bendesc_per_rc
	pbp_b7b_bendesc_per_rc_d
	pbp_b7b_addl_service_other
	pbp_b7b_bendesc_amo_other
	pbp_b7b_bendesc_lim_other
	pbp_b7b_bendesc_num_other
	pbp_b7b_bendesc_per_other
	pbp_b7b_bendesc_per_other_d
	pbp_b7b_maxplan_yn
	pbp_b7b_maxplan_amt
	pbp_b7b_maxplan_per
	pbp_b7b_maxplan_per_d
	pbp_b7b_coins_yn
	pbp_b7b_coins_ehc
	pbp_b7b_coins_pct_rc_min
	pbp_b7b_coins_pct_rc_max
	pbp_b7b_coins_pct_other_min
	pbp_b7b_coins_pct_other_max
	pbp_b7b_copay_yn
	pbp_b7b_copay_ehc
	pbp_b7b_copay_rc_amt_min
	pbp_b7b_copay_rc_amt_max
	pbp_b7b_copay_other_amt_min
	pbp_b7b_copay_other_amt_max
	pbp_b7b_auth_yn
	pbp_b7b_refer_yn
	pbp_d_opt_identifier
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
	pbp_d_opt_use_mand_7b_yn         = 'OppSupp Cost Same INN 7B YN'
	pbp_d_opt_use_mand_7b1_yn        = 'OppSupp Cost Same INN 7B1 YN'
	pbp_d_opt_use_mand_7b2_yn        = 'OppSupp Cost Same INN 7B2 YN'
	pbp_b7b_bendesc_yn               = 'Chiropractic Ben Desc YN'
	pbp_b7b_bendesc_ehc              = 'Chiropractic Supp Ben Desc'
	pbp_b7b_bendesc_amo_rc           = 'Routine care Ben AMO'
	pbp_b7b_bendesc_lim_rc           = 'Routine care Limit'
	pbp_b7b_bendesc_num_rc           = 'Routine care  Limit Num'
	pbp_b7b_bendesc_per_rc           = 'Routine care Per'
	pbp_b7b_bendesc_per_rc_d         = 'Routine care Per Desc'
	pbp_b7b_addl_service_other       = 'Other service name'
	pbp_b7b_bendesc_amo_other        = 'Other service Ben AMO'
	pbp_b7b_bendesc_lim_other        = 'Other service Limit'
	pbp_b7b_bendesc_num_other        = 'Other service Limit Num'
	pbp_b7b_bendesc_per_other        = 'Other service Per'
	pbp_b7b_bendesc_per_other_d      = 'Other service Per Desc'
	pbp_b7b_maxplan_yn               = 'Chiropractic Max Plan YN'
	pbp_b7b_maxplan_amt              = 'Chiropractic Max Plan Amt'
	pbp_b7b_maxplan_per              = 'Chiropractic Max Plan Per'
	pbp_b7b_maxplan_per_d            = 'Chiro Max Plan Per Desc'
	pbp_b7b_coins_yn                 = 'Chiropractic Coinsurance YN'
	pbp_b7b_coins_ehc                = 'Chiro Coins Enhance Benefits'
	pbp_b7b_coins_pct_rc_min         = 'Routine care Min Coins Pct'
	pbp_b7b_coins_pct_rc_max         = 'Routine care Max Coins Pct'
	pbp_b7b_coins_pct_other_min      = 'Other service Min Coins Pct'
	pbp_b7b_coins_pct_other_max      = 'Other service Max Coins Pct'
	pbp_b7b_copay_yn                 = 'Chiropractic Copayment YN'
	pbp_b7b_copay_ehc                = 'Chiro Copay Enhanc Benefits'
	pbp_b7b_copay_rc_amt_min         = 'Routine care Min Copay Amt'
	pbp_b7b_copay_rc_amt_max         = 'Routine care Max Copay Amt'
	pbp_b7b_copay_other_amt_min      = 'Other service Min Copay Amt'
	pbp_b7b_copay_other_amt_max      = 'Other service Max Copay Amt'
	pbp_b7b_auth_yn                  = 'Chiropractic Auth YN'
	pbp_b7b_refer_yn                 = 'Chiropractic Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step7b out=out.pbp_step7b;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step7b(obs = 10);
  title 'pbp_step7b file ';
run;

proc means data = out.pbp_step7b;
  title 'pbp_step7b file ';
run;

proc freq data = out.pbp_step7b;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_7b_yn
	pbp_d_opt_use_mand_7b1_yn
	pbp_d_opt_use_mand_7b2_yn
	pbp_b7b_bendesc_yn
	pbp_b7b_bendesc_ehc
	pbp_b7b_bendesc_amo_rc
	pbp_b7b_bendesc_lim_rc
	pbp_b7b_bendesc_per_rc
	pbp_b7b_bendesc_amo_other
	pbp_b7b_bendesc_lim_other
	pbp_b7b_bendesc_per_other
	pbp_b7b_maxplan_yn
	pbp_b7b_maxplan_per
	pbp_b7b_coins_yn
	pbp_b7b_coins_ehc
	pbp_b7b_copay_yn
	pbp_b7b_copay_ehc
	pbp_b7b_auth_yn
	pbp_b7b_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step7b;
  title 'pbp_step7b data';
run;