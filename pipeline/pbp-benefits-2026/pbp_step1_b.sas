*pbp_step1_b.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step1_b;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_1a_b_yn       $1
	pbp_d_opt_use_mand_1b_b_yn       $1
	pbp_b1a_bendesc_yn_bonly         $1
	pbp_b1a_bendesc_amo_iact_bonly   $1
	pbp_b1a_bendesc_ulim_bonly       $1
	pbp_b1a_bendesc_per_bonly        $1
	pbp_b1a_bendesc_per_bonly_d      $4000
	pbp_b1a_maxplan_yn_bonly         $1
	pbp_b1a_maxplan_per_bonly        $1
	pbp_b1a_maxplan_per_bonly_d      $4000
	pbp_b1a_maxenr_yn_bonly          $1
	pbp_b1a_maxenr_per_bonly         $1
	pbp_b1a_maxenr_per_bonly_d       $4000
	pbp_b1a_coins_yn_bonly           $1
	pbp_b1a_coins_ps_num_bonly       $1
	pbp_b1a_ded_yn_bonly             $1
	pbp_b1a_copay_yn_bonly           $1
	pbp_b1a_copay_ps_num_bonly       $1
	pbp_b1a_discharge_yn_bonly       $1
	pbp_b1a_auth_yn_bonly            $1
	pbp_b1a_refer_yn_bonly           $1
	pbp_b1b_bendesc_yn_bonly         $1
	pbp_b1b_bendesc_amo_bonly        $1
	pbp_b1b_bendesc_lim_bonly        $1
	pbp_b1b_bendesc_per_bonly        $1
	pbp_b1b_bendesc_per_bonly_d      $4000
	pbp_b1b_maxplan_yn_bonly         $1
	pbp_b1b_maxplan_type_bonly       $1
	pbp_b1b_maxplan_per_bonly        $1
	pbp_b1b_maxplan_per_bonly_d      $4000
	pbp_b1b_maxenr_yn_bonly          $1
	pbp_b1b_maxenr_type_bonly        $1
	pbp_b1b_maxenr_per_bonly         $1
	pbp_b1b_maxenr_per_bonly_d       $4000
	pbp_b1b_coins_yn_bonly           $1
	pbp_b1b_coins_ps_num_bonly       $1
	pbp_b1b_ded_yn_bonly             $1
	pbp_b1b_copay_yn_bonly           $1
	pbp_b1b_copay_ps_num_bonly       $1
	pbp_b1b_discharge_yn_bonly       $1
	pbp_b1b_auth_yn_bonly            $1
	pbp_b1b_refer_yn_bonly           $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step1_b.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_1a_b_yn
	pbp_d_opt_use_mand_1b_b_yn
	pbp_b1a_bendesc_yn_bonly
	pbp_b1a_bendesc_amo_iact_bonly
	pbp_b1a_bendesc_ulim_bonly
	pbp_b1a_bendesc_amt_days_bonly
	pbp_b1a_bendesc_per_bonly
	pbp_b1a_bendesc_per_bonly_d
	pbp_b1a_maxplan_yn_bonly
	pbp_b1a_maxplan_amt_bonly
	pbp_b1a_maxplan_per_bonly
	pbp_b1a_maxplan_per_bonly_d
	pbp_b1a_maxenr_yn_bonly
	pbp_b1a_maxenr_amt_bonly
	pbp_b1a_maxenr_per_bonly
	pbp_b1a_maxenr_per_bonly_d
	pbp_b1a_coins_yn_bonly
	pbp_b1a_coins_pct_bonly
	pbp_b1a_coins_ps_num_bonly
	pbp_b1a_coins_ps_pct1_bonly
	pbp_b1a_coins_ps_bgnd1_bonly
	pbp_b1a_coins_ps_endd1_bonly
	pbp_b1a_coins_ps_pct2_bonly
	pbp_b1a_coins_ps_bgnd2_bonly
	pbp_b1a_coins_ps_endd2_bonly
	pbp_b1a_coins_ps_pct3_bonly
	pbp_b1a_coins_ps_bgnd3_bonly
	pbp_b1a_coins_ps_endd3_bonly
	pbp_b1a_ded_yn_bonly
	pbp_b1a_ded_amt_bonly
	pbp_b1a_copay_yn_bonly
	pbp_b1a_copay_amt_ps_bonly
	pbp_b1a_copay_ps_num_bonly
	pbp_b1a_copay_ps_amt1_bonly
	pbp_b1a_copay_ps_bgnd1_bonly
	pbp_b1a_copay_ps_endd1_bonly
	pbp_b1a_copay_ps_amt2_bonly
	pbp_b1a_copay_ps_bgnd2_bonly
	pbp_b1a_copay_ps_endd2_bonly
	pbp_b1a_copay_ps_amt3_bonly
	pbp_b1a_copay_ps_bgnd3_bonly
	pbp_b1a_copay_ps_endd3_bonly
	pbp_b1a_discharge_yn_bonly
	pbp_b1a_auth_yn_bonly
	pbp_b1a_refer_yn_bonly
	pbp_b1b_bendesc_yn_bonly
	pbp_b1b_bendesc_amo_bonly
	pbp_b1b_bendesc_lim_bonly
	pbp_b1b_bendesc_amt_bonly
	pbp_b1b_bendesc_per_bonly
	pbp_b1b_bendesc_per_bonly_d
	pbp_b1b_maxplan_yn_bonly
	pbp_b1b_maxplan_type_bonly
	pbp_b1b_maxplan_amt_bonly
	pbp_b1b_maxplan_per_bonly
	pbp_b1b_maxplan_per_bonly_d
	pbp_b1b_maxenr_yn_bonly
	pbp_b1b_maxenr_type_bonly
	pbp_b1b_maxenr_amt_bonly
	pbp_b1b_maxenr_per_bonly
	pbp_b1b_maxenr_per_bonly_d
	pbp_b1b_coins_yn_bonly
	pbp_b1b_coins_pct_bonly
	pbp_b1b_coins_ps_num_bonly
	pbp_b1b_coins_ps_pct1_bonly
	pbp_b1b_coins_ps_bgnd1_bonly
	pbp_b1b_coins_ps_endd1_bonly
	pbp_b1b_coins_ps_pct2_bonly
	pbp_b1b_coins_ps_bgnd2_bonly
	pbp_b1b_coins_ps_endd2_bonly
	pbp_b1b_coins_ps_pct3_bonly
	pbp_b1b_coins_ps_bgnd3_bonly
	pbp_b1b_coins_ps_endd3_bonly
	pbp_b1b_ded_yn_bonly
	pbp_b1b_ded_amt_bonly
	pbp_b1b_copay_yn_bonly
	pbp_b1b_copay_amt_ps_bonly
	pbp_b1b_copay_ps_num_bonly
	pbp_b1b_copay_ps_amt1_bonly
	pbp_b1b_copay_ps_bgnd1_bonly
	pbp_b1b_copay_ps_endd1_bonly
	pbp_b1b_copay_ps_amt2_bonly
	pbp_b1b_copay_ps_bgnd2_bonly
	pbp_b1b_copay_ps_endd2_bonly
	pbp_b1b_copay_ps_amt3_bonly
	pbp_b1b_copay_ps_bgnd3_bonly
	pbp_b1b_copay_ps_endd3_bonly
	pbp_b1b_discharge_yn_bonly
	pbp_b1b_auth_yn_bonly
	pbp_b1b_refer_yn_bonly
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
	pbp_d_opt_use_mand_1a_b_yn       = 'OppSupp Cost Same INN 1A-B YN'
	pbp_d_opt_use_mand_1b_b_yn       = 'OppSupp Cost Same INN 1B-B YN'
	pbp_b1a_bendesc_yn_bonly         = 'IHA(B) Ben Desc YN'
	pbp_b1a_bendesc_amo_iact_bonly   = 'IHA(B) Ben Desc AMO'
	pbp_b1a_bendesc_ulim_bonly       = 'IHA(B) Ben Desc Lim YN'
	pbp_b1a_bendesc_amt_days_bonly   = 'IHA(B) Ben Desc Num'
	pbp_b1a_bendesc_per_bonly        = 'IHA(B) Ben Desc Per'
	pbp_b1a_bendesc_per_bonly_d      = 'IHA(B) Ben Desc Per Desc'
	pbp_b1a_maxplan_yn_bonly         = 'IHA(B) Max Plan YN'
	pbp_b1a_maxplan_amt_bonly        = 'IHA(B) Max Plan Amt'
	pbp_b1a_maxplan_per_bonly        = 'IHA(B) Max Plan Per'
	pbp_b1a_maxplan_per_bonly_d      = 'IHA(B) Max Plan Per Desc'
	pbp_b1a_maxenr_yn_bonly          = 'IHA(B) Max Enr YN'
	pbp_b1a_maxenr_amt_bonly         = 'IHA(B) Max Enr Amt'
	pbp_b1a_maxenr_per_bonly         = 'IHA(B) Max Enr Per'
	pbp_b1a_maxenr_per_bonly_d       = 'IHA(B) Max Enr Per Desc'
	pbp_b1a_coins_yn_bonly           = 'IHA(B) Coinsurance YN'
	pbp_b1a_coins_pct_bonly          = 'IHA(B) Coins Pct'
	pbp_b1a_coins_ps_num_bonly       = 'IHA(B) PS Coins Interval Num'
	pbp_b1a_coins_ps_pct1_bonly      = 'IHA(B) PS Coins Pct Intrvl 1'
	pbp_b1a_coins_ps_bgnd1_bonly     = 'IHA(B) PS Coin Bgn Day Intrv 1'
	pbp_b1a_coins_ps_endd1_bonly     = 'IHA(B) PS Coin End Day Intrv 1'
	pbp_b1a_coins_ps_pct2_bonly      = 'IHA(B) PS Coins Pct Intrvl 2'
	pbp_b1a_coins_ps_bgnd2_bonly     = 'IHA(B) PS Coin Bgn Day Intrv 2'
	pbp_b1a_coins_ps_endd2_bonly     = 'IHA(B) PS Coin End Day Intrv 2'
	pbp_b1a_coins_ps_pct3_bonly      = 'IHA(B) PS Coins Pct Intrvl 3'
	pbp_b1a_coins_ps_bgnd3_bonly     = 'IHA(B) PS Coin Bgn Day Intrv 3'
	pbp_b1a_coins_ps_endd3_bonly     = 'IHA(B) PS Coin End Day Intrv 3'
	pbp_b1a_ded_yn_bonly             = 'IHA(B) Deductible YN'
	pbp_b1a_ded_amt_bonly            = 'IHA(B) Deductible Amt'
	pbp_b1a_copay_yn_bonly           = 'IHA(B) Copayment YN'
	pbp_b1a_copay_amt_ps_bonly       = 'IHA(B) PS Copay Amt'
	pbp_b1a_copay_ps_num_bonly       = 'IHA(B) PS Copay Interval Num'
	pbp_b1a_copay_ps_amt1_bonly      = 'IHA(B) PS Copay Amt Interval 1'
	pbp_b1a_copay_ps_bgnd1_bonly     = 'IHA(B) PS Cpay Beg Day Intrv 1'
	pbp_b1a_copay_ps_endd1_bonly     = 'IHA(B) PS Cpay End Day Intrv 1'
	pbp_b1a_copay_ps_amt2_bonly      = 'IHA(B) PS Copay Amt Interval 2'
	pbp_b1a_copay_ps_bgnd2_bonly     = 'IHA(B) PS Cpay Bgn Day Intrv 2'
	pbp_b1a_copay_ps_endd2_bonly     = 'IHA(B) PS Cpay End Day Intrv 2'
	pbp_b1a_copay_ps_amt3_bonly      = 'IHA(B) PS Copay Amt Interval 3'
	pbp_b1a_copay_ps_bgnd3_bonly     = 'IHA(B) PS Cpay Bgn Day Intrv 3'
	pbp_b1a_copay_ps_endd3_bonly     = 'IHA(B) PS Cpay End Day Intrv 3'
	pbp_b1a_discharge_yn_bonly       = 'IHA(B) Discharge Cost Charge'
	pbp_b1a_auth_yn_bonly            = 'IHA(B) Enrollee Auth'
	pbp_b1a_refer_yn_bonly           = 'IHA(B) Referral YN'
	pbp_b1b_bendesc_yn_bonly         = 'IPH(B) Ben Desc YN'
	pbp_b1b_bendesc_amo_bonly        = 'IPH(B) Ben Desc AMO'
	pbp_b1b_bendesc_lim_bonly        = 'IPH(B) Ben Desc Lim YN'
	pbp_b1b_bendesc_amt_bonly        = 'IPH(B) Ben Desc Amt'
	pbp_b1b_bendesc_per_bonly        = 'IPH(B) Ben Desc Per'
	pbp_b1b_bendesc_per_bonly_d      = 'IPH(B) Ben Desc Per Desc'
	pbp_b1b_maxplan_yn_bonly         = 'IPH(B) Max Plan YN'
	pbp_b1b_maxplan_type_bonly       = 'IPH(B) Max Plan Type'
	pbp_b1b_maxplan_amt_bonly        = 'IPH(B) Max Plan Amt'
	pbp_b1b_maxplan_per_bonly        = 'IPH(B) Max Plan Per'
	pbp_b1b_maxplan_per_bonly_d      = 'IPH(B) Max Plan Per Desc'
	pbp_b1b_maxenr_yn_bonly          = 'IPH(B) Max Enr YN'
	pbp_b1b_maxenr_type_bonly        = 'IPH(B) Max Enr Type'
	pbp_b1b_maxenr_amt_bonly         = 'IPH(B) Max Enr Amt'
	pbp_b1b_maxenr_per_bonly         = 'IPH(B) Max Enr Per'
	pbp_b1b_maxenr_per_bonly_d       = 'IPH(B) Max Enr Per Desc'
	pbp_b1b_coins_yn_bonly           = 'IPH(B) Coinsurance YN'
	pbp_b1b_coins_pct_bonly          = 'IPH(B) PS Coins Pct'
	pbp_b1b_coins_ps_num_bonly       = 'IPH(B) PS Coins Interval Num'
	pbp_b1b_coins_ps_pct1_bonly      = 'IPH(B) PS Coins Pct Intrvl 1'
	pbp_b1b_coins_ps_bgnd1_bonly     = 'IPH(B) PS Coin Bgn Day Intrv 1'
	pbp_b1b_coins_ps_endd1_bonly     = 'IPH(B) PS Coin End Day Intrv 1'
	pbp_b1b_coins_ps_pct2_bonly      = 'IPH(B) PS Coins Pct Intrvl 2'
	pbp_b1b_coins_ps_bgnd2_bonly     = 'IPH(B) PS Coin Bgn Day Intrv 2'
	pbp_b1b_coins_ps_endd2_bonly     = 'IPH(B) PS Coin End Day Intrv 2'
	pbp_b1b_coins_ps_pct3_bonly      = 'IPH(B) PS Coins Pct Intrvl 3'
	pbp_b1b_coins_ps_bgnd3_bonly     = 'IPH(B) PS Coin Bgn Day Intrv 3'
	pbp_b1b_coins_ps_endd3_bonly     = 'IPH(B) PS Coin End Day Intrv 3'
	pbp_b1b_ded_yn_bonly             = 'IPH(B) Deductible YN'
	pbp_b1b_ded_amt_bonly            = 'IPH(B) Deductible Amt'
	pbp_b1b_copay_yn_bonly           = 'IPH(B) Copayment YN'
	pbp_b1b_copay_amt_ps_bonly       = 'IPH(B) PS Copay Amt'
	pbp_b1b_copay_ps_num_bonly       = 'IPH(B) PS Copay Interval Num'
	pbp_b1b_copay_ps_amt1_bonly      = 'IPH(B) PS Copay Amt Interval 1'
	pbp_b1b_copay_ps_bgnd1_bonly     = 'IPH(B) PS Cpay Bgn Day Intrv 1'
	pbp_b1b_copay_ps_endd1_bonly     = 'IPH(B) PS Cpay End Day Intrv 1'
	pbp_b1b_copay_ps_amt2_bonly      = 'IPH(B) PS Copay Amt Interval 2'
	pbp_b1b_copay_ps_bgnd2_bonly     = 'IPH(B) PS Cpay Bgn Day Intrv 2'
	pbp_b1b_copay_ps_endd2_bonly     = 'IPH(B) PS Cpay End Day Intrv 2'
	pbp_b1b_copay_ps_amt3_bonly      = 'IPH(B) PS Copay Amt Interval 3'
	pbp_b1b_copay_ps_bgnd3_bonly     = 'IPH(B) PS Cpay Bgn Day Intrv 3'
	pbp_b1b_copay_ps_endd3_bonly     = 'IPH(B) PS Cpay End Day Intrv 3'
	pbp_b1b_discharge_yn_bonly       = 'IPH(B)Cost On Discharge YN'
	pbp_b1b_auth_yn_bonly            = 'IPH(B) Enrollee Auth'
	pbp_b1b_refer_yn_bonly           = 'IPH(B) Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step1_b out=out.pbp_step1_b;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step1_b(obs = 10);
  title 'pbp_step1_b file ';
run;

proc means data = out.pbp_step1_b;
  title 'pbp_step1_b file ';
run;

proc freq data = out.pbp_step1_b;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_1a_b_yn
	pbp_d_opt_use_mand_1b_b_yn
	pbp_b1a_bendesc_yn_bonly
	pbp_b1a_bendesc_amo_iact_bonly
	pbp_b1a_bendesc_ulim_bonly
	pbp_b1a_bendesc_per_bonly
	pbp_b1a_maxplan_yn_bonly
	pbp_b1a_maxplan_per_bonly
	pbp_b1a_maxenr_yn_bonly
	pbp_b1a_maxenr_per_bonly
	pbp_b1a_coins_yn_bonly
	pbp_b1a_coins_ps_num_bonly
	pbp_b1a_ded_yn_bonly
	pbp_b1a_copay_yn_bonly
	pbp_b1a_copay_ps_num_bonly
	pbp_b1a_discharge_yn_bonly
	pbp_b1a_auth_yn_bonly
	pbp_b1a_refer_yn_bonly
	pbp_b1b_bendesc_yn_bonly
	pbp_b1b_bendesc_amo_bonly
	pbp_b1b_bendesc_lim_bonly
	pbp_b1b_bendesc_per_bonly
	pbp_b1b_maxplan_yn_bonly
	pbp_b1b_maxplan_type_bonly
	pbp_b1b_maxplan_per_bonly
	pbp_b1b_maxenr_yn_bonly
	pbp_b1b_maxenr_type_bonly
	pbp_b1b_maxenr_per_bonly
	pbp_b1b_coins_yn_bonly
	pbp_b1b_coins_ps_num_bonly
	pbp_b1b_ded_yn_bonly
	pbp_b1b_copay_yn_bonly
	pbp_b1b_copay_ps_num_bonly
	pbp_b1b_discharge_yn_bonly
	pbp_b1b_auth_yn_bonly
	pbp_b1b_refer_yn_bonly
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step1_b;
  title 'pbp_step1_b data';
run;