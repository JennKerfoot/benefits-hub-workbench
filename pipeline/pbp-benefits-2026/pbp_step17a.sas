*pbp_step17a.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step17a;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_17a_yn        $1
	pbp_d_opt_use_mand_17a1_yn       $1
	pbp_d_opt_use_mand_17a2_yn       $1
	pbp_b17a_bendesc_yn              $1
	pbp_b17a_bendesc_ehc             $2
	pbp_b17a_bendesc_amo_rex         $1
	pbp_b17a_bendesc_lim_rex         $1
	pbp_b17a_bendesc_per_rex         $1
	pbp_b17a_bendesc_per_rex_d       $4000
	pbp_b17a_addl_service_other      $250
	pbp_b17a_bendesc_amo_other       $1
	pbp_b17a_bendesc_lim_other       $1
	pbp_b17a_bendesc_per_other       $1
	pbp_b17a_bendesc_per_other_d     $4000
	pbp_b17a_maxplan_yn              $1
	pbp_b17a_maxplan_in_oon          $1
	pbp_b17a_maxplan_per             $1
	pbp_b17a_maxplan_per_d           $4000
	pbp_b17a_coins_yn                $1
	pbp_b17a_coins_ehc               $3
	pbp_b17a_copay_yn                $1
	pbp_b17a_copay_ehc               $3
	pbp_b17a_ded_nmc_yn              $1
	pbp_b17a_auth_yn                 $1
	pbp_b17a_refer_yn                $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step17a.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_17a_yn
	pbp_d_opt_use_mand_17a1_yn
	pbp_d_opt_use_mand_17a2_yn
	pbp_b17a_bendesc_yn
	pbp_b17a_bendesc_ehc
	pbp_b17a_bendesc_amo_rex
	pbp_b17a_bendesc_lim_rex
	pbp_b17a_bendesc_num_rex
	pbp_b17a_bendesc_per_rex
	pbp_b17a_bendesc_per_rex_d
	pbp_b17a_addl_service_other
	pbp_b17a_bendesc_amo_other
	pbp_b17a_bendesc_lim_other
	pbp_b17a_bendesc_num_other
	pbp_b17a_bendesc_per_other
	pbp_b17a_bendesc_per_other_d
	pbp_b17a_maxplan_yn
	pbp_b17a_maxplan_in_oon
	pbp_b17a_maxplan_amt
	pbp_b17a_maxplan_per
	pbp_b17a_maxplan_per_d
	pbp_b17a_coins_yn
	pbp_b17a_coins_ehc
	pbp_b17a_coins_pct_rex_min
	pbp_b17a_coins_pct_rex_max
	pbp_b17a_coins_pct_other_min
	pbp_b17a_coins_pct_other_max
	pbp_b17a_copay_yn
	pbp_b17a_copay_ehc
	pbp_b17a_copay_amt_rex_min
	pbp_b17a_copay_amt_rex_max
	pbp_b17a_copay_amt_other_min
	pbp_b17a_copay_amt_other_max
	pbp_b17a_ded_nmc_yn
	pbp_b17a_ded_nmc_amt
	pbp_b17a_auth_yn
	pbp_b17a_refer_yn
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
	pbp_d_opt_use_mand_17a_yn        = 'OppSupp Cost Same INN 17A YN'
	pbp_d_opt_use_mand_17a1_yn       = 'OppSupp Cost Same INN 17A1 YN'
	pbp_d_opt_use_mand_17a2_yn       = 'OppSupp Cost Same INN 17A2 YN'
	pbp_b17a_bendesc_yn              = 'Eye Exams Ben YN'
	pbp_b17a_bendesc_ehc             = 'Eye Exams (17a) Ben'
	pbp_b17a_bendesc_amo_rex         = 'Eye Exams REX AMO'
	pbp_b17a_bendesc_lim_rex         = 'Eye Exams REX Desc Lim YN'
	pbp_b17a_bendesc_num_rex         = 'Eye Exams REX Desc lim num'
	pbp_b17a_bendesc_per_rex         = 'Eye Exams REX Desc Per'
	pbp_b17a_bendesc_per_rex_d       = 'Eye Exams REX Per Desc'
	pbp_b17a_addl_service_other      = 'Eye Exams other service name'
	pbp_b17a_bendesc_amo_other       = 'Eye Exams other Desc AMO'
	pbp_b17a_bendesc_lim_other       = 'Eye Exams other Desc Lim YN'
	pbp_b17a_bendesc_num_other       = 'Eye Exams other Desc lim num'
	pbp_b17a_bendesc_per_other       = 'Eye Exams other Desc Per'
	pbp_b17a_bendesc_per_other_d     = 'Eye Exams other Per Desc'
	pbp_b17a_maxplan_yn              = 'Eye Exams Max Plan YN'
	pbp_b17a_maxplan_in_oon          = 'Eye Exams INN or OON'
	pbp_b17a_maxplan_amt             = 'Eye Exams Max Plan Amt'
	pbp_b17a_maxplan_per             = 'Eye Exams Max Plan Per'
	pbp_b17a_maxplan_per_d           = 'Eye Exam Max Plan Per Desc'
	pbp_b17a_coins_yn                = 'Eye Exams Coinsurance YN'
	pbp_b17a_coins_ehc               = 'Eye Exams Coinsurance Svcs'
	pbp_b17a_coins_pct_rex_min       = 'Eye Exams REX Min Coins Pct'
	pbp_b17a_coins_pct_rex_max       = 'Eye Exams REX Max Coins Pct'
	pbp_b17a_coins_pct_other_min     = 'Eye Exams other Min Coins Pct'
	pbp_b17a_coins_pct_other_max     = 'Eye Exams other Max Coins Pct'
	pbp_b17a_copay_yn                = 'Eye Exams Copayment YN'
	pbp_b17a_copay_ehc               = 'Eye Exams Copayment Svcs'
	pbp_b17a_copay_amt_rex_min       = 'Eye Exams REX Min Copay Amt'
	pbp_b17a_copay_amt_rex_max       = 'Eye Exams REX Max Copay Amt'
	pbp_b17a_copay_amt_other_min     = 'Eye Exams other Min Copay Amt'
	pbp_b17a_copay_amt_other_max     = 'Eye Exams other Max Copay Amt'
	pbp_b17a_ded_nmc_yn              = 'Eye Exams Deduct NMC YN'
	pbp_b17a_ded_nmc_amt             = 'Eye Exams Deduct NMC Amt'
	pbp_b17a_auth_yn                 = 'Eye Exams Auth YN'
	pbp_b17a_refer_yn                = 'Eye Exams Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step17a out=out.pbp_step17a;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step17a(obs = 10);
  title 'pbp_step17a file ';
run;

proc means data = out.pbp_step17a;
  title 'pbp_step17a file ';
run;

proc freq data = out.pbp_step17a;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_17a_yn
	pbp_d_opt_use_mand_17a1_yn
	pbp_d_opt_use_mand_17a2_yn
	pbp_b17a_bendesc_yn
	pbp_b17a_bendesc_ehc
	pbp_b17a_bendesc_amo_rex
	pbp_b17a_bendesc_lim_rex
	pbp_b17a_bendesc_per_rex
	pbp_b17a_bendesc_amo_other
	pbp_b17a_bendesc_lim_other
	pbp_b17a_bendesc_per_other
	pbp_b17a_maxplan_yn
	pbp_b17a_maxplan_in_oon
	pbp_b17a_maxplan_per
	pbp_b17a_coins_yn
	pbp_b17a_coins_ehc
	pbp_b17a_copay_yn
	pbp_b17a_copay_ehc
	pbp_b17a_ded_nmc_yn
	pbp_b17a_auth_yn
	pbp_b17a_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step17a;
  title 'pbp_step17a data';
run;