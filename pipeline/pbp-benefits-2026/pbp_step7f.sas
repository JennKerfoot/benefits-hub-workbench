*pbp_step7f.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step7f;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_7f_yn         $1
	pbp_b7f_bendesc_yn               $1
	pbp_b7f_bendesc_rf               $1
	pbp_b7f_bendesc_amo_rf           $1
	pbp_b7f_bendesc_lim_rf           $1
	pbp_b7f_bendesc_per_rf           $1
	pbp_b7f_bendesc_per_rf_d         $4000
	pbp_b7f_maxplan_yn               $1
	pbp_b7f_maxplan_per              $1
	pbp_b7f_maxplan_per_d            $4000
	pbp_b7f_coins_yn                 $1
	pbp_b7f_coins_ehc                $2
	pbp_b7f_copay_yn                 $1
	pbp_b7f_copay_ehc                $2
	pbp_b7f_auth_yn                  $1
	pbp_b7f_refer_yn                 $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step7f.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_7f_yn
	pbp_b7f_bendesc_yn
	pbp_b7f_bendesc_rf
	pbp_b7f_bendesc_amo_rf
	pbp_b7f_bendesc_lim_rf
	pbp_b7f_bendesc_amt_rf
	pbp_b7f_bendesc_per_rf
	pbp_b7f_bendesc_per_rf_d
	pbp_b7f_maxplan_yn
	pbp_b7f_maxplan_amt
	pbp_b7f_maxplan_per
	pbp_b7f_maxplan_per_d
	pbp_b7f_coins_yn
	pbp_b7f_coins_ehc
	pbp_b7f_coins_pct_rf_min
	pbp_b7f_coins_pct_rf_max
	pbp_b7f_copay_yn
	pbp_b7f_copay_ehc
	pbp_b7f_copay_rf_amt_min
	pbp_b7f_copay_rf_amt_max
	pbp_b7f_auth_yn
	pbp_b7f_refer_yn
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
	pbp_d_opt_use_mand_7f_yn         = 'OppSupp Cost Same INN 7F YN'
	pbp_b7f_bendesc_yn               = 'Podiatrist Ben Desc YN'
	pbp_b7f_bendesc_rf               = 'Podiatrist RF Ben Desc Enhance'
	pbp_b7f_bendesc_amo_rf           = 'Podiatrist RF Ben Desc AMO'
	pbp_b7f_bendesc_lim_rf           = 'Podiatrist RF Ben Desc Lim YN'
	pbp_b7f_bendesc_amt_rf           = 'Podiatrist RF Ben Desc Amt'
	pbp_b7f_bendesc_per_rf           = 'Podiatrist RF Ben Desc Per'
	pbp_b7f_bendesc_per_rf_d         = 'Podiatrist RF Per Desc'
	pbp_b7f_maxplan_yn               = 'Podiatrist Max Plan YN'
	pbp_b7f_maxplan_amt              = 'Podiatrist Max Plan Amt'
	pbp_b7f_maxplan_per              = 'Podiatrist Max Plan Per'
	pbp_b7f_maxplan_per_d            = 'Podiatrist Max Plan Per Desc'
	pbp_b7f_coins_yn                 = 'Podiatrist Coinsurance YN'
	pbp_b7f_coins_ehc                = 'Podiatry Services Coinsurance'
	pbp_b7f_coins_pct_rf_min         = 'Podiatry RF Min Coins Pct'
	pbp_b7f_coins_pct_rf_max         = 'Podiatry RF Max Coins Pct'
	pbp_b7f_copay_yn                 = 'Podiatrist Copayment YN'
	pbp_b7f_copay_ehc                = 'Podiatry Services have a Copay'
	pbp_b7f_copay_rf_amt_min         = 'Podiatrist RF Min Copay Amt'
	pbp_b7f_copay_rf_amt_max         = 'Podiatrist RF Max Copay Amt'
	pbp_b7f_auth_yn                  = 'Podiatrist Auth YN'
	pbp_b7f_refer_yn                 = 'Podiatrist Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step7f out=out.pbp_step7f;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step7f(obs = 10);
  title 'pbp_step7f file ';
run;

proc means data = out.pbp_step7f;
  title 'pbp_step7f file ';
run;

proc freq data = out.pbp_step7f;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_7f_yn
	pbp_b7f_bendesc_yn
	pbp_b7f_bendesc_rf
	pbp_b7f_bendesc_amo_rf
	pbp_b7f_bendesc_lim_rf
	pbp_b7f_bendesc_per_rf
	pbp_b7f_maxplan_yn
	pbp_b7f_maxplan_per
	pbp_b7f_coins_yn
	pbp_b7f_coins_ehc
	pbp_b7f_copay_yn
	pbp_b7f_copay_ehc
	pbp_b7f_auth_yn
	pbp_b7f_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step7f;
  title 'pbp_step7f data';
run;