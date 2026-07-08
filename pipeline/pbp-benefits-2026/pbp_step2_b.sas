*pbp_step2_b.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step2_b;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_2_b_yn        $1
	pbp_b2_bendesc_yn_bonly          $1
	pbp_b2_bendesc_amo_bonly         $1
	pbp_b2_bendesc_snf_unlm_bonly    $1
	pbp_b2_bendesc_snf_per_bonly     $1
	pbp_b2_bendesc_snf_per_bonly_d   $4000
	pbp_b2_bendesc_hostay_bonly_yn   $1
	pbp_b2_bende_nmday_prior_bonly   $1
	pbp_b2_maxplan_yn_bonly          $1
	pbp_b2_maxplan_per_bonly         $1
	pbp_b2_maxplan_per_bonly_d       $4000
	pbp_b2_maxenr_yn_bonly           $1
	pbp_b2_maxenr_per_bonly          $1
	pbp_b2_maxenr_per_bonly_d        $4000
	pbp_b2_coins_yn_bonly            $1
	pbp_b2_coins_ps_num_bonly        $1
	pbp_b2_ded_yn_bonly              $1
	pbp_b2_copay_yn_bonly            $1
	pbp_b2_copay_ps_num_bonly        $1
	pbp_b2_auth_yn_bonly             $1
	pbp_b2_refer_yn_bonly            $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step2_b.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_2_b_yn
	pbp_b2_bendesc_yn_bonly
	pbp_b2_bendesc_amo_bonly
	pbp_b2_bendesc_snf_unlm_bonly
	pbp_b2_bende_al_ad_prior_bonly
	pbp_b2_bendesc_snf_per_bonly
	pbp_b2_bendesc_snf_per_bonly_d
	pbp_b2_bendesc_hostay_bonly_yn
	pbp_b2_bende_nmday_prior_bonly
	pbp_b2_maxplan_yn_bonly
	pbp_b2_maxplan_amt_bonly
	pbp_b2_maxplan_per_bonly
	pbp_b2_maxplan_per_bonly_d
	pbp_b2_maxenr_yn_bonly
	pbp_b2_maxenr_amt_bonly
	pbp_b2_maxenr_per_bonly
	pbp_b2_maxenr_per_bonly_d
	pbp_b2_coins_yn_bonly
	pbp_b2_coins_pct_bonly
	pbp_b2_coins_ps_num_bonly
	pbp_b2_coins_ps_pct1_bonly
	pbp_b2_coins_ps_bgnd1_bonly
	pbp_b2_coins_ps_endd1_bonly
	pbp_b2_coins_ps_pct2_bonly
	pbp_b2_coins_ps_bgnd2_bonly
	pbp_b2_coins_ps_endd2_bonly
	pbp_b2_coins_ps_pct3_bonly
	pbp_b2_coins_ps_bgnd3_bonly
	pbp_b2_coins_ps_endd3_bonly
	pbp_b2_ded_yn_bonly
	pbp_b2_ded_amt_bonly
	pbp_b2_copay_yn_bonly
	pbp_b2_copay_ps_amt_bonly
	pbp_b2_copay_ps_num_bonly
	pbp_b2_copay_ps_amt1_bonly
	pbp_b2_copay_ps_bgnd1_bonly
	pbp_b2_copay_ps_endd1_bonly
	pbp_b2_copay_ps_amt2_bonly
	pbp_b2_copay_ps_bgnd2_bonly
	pbp_b2_copay_ps_endd2_bonly
	pbp_b2_copay_ps_amt3_bonly
	pbp_b2_copay_ps_bgnd3_bonly
	pbp_b2_copay_ps_endd3_bonly
	pbp_b2_auth_yn_bonly
	pbp_b2_refer_yn_bonly
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
	pbp_d_opt_use_mand_2_b_yn        = 'OppSupp Cost Same INN 2-B YN'
	pbp_b2_bendesc_yn_bonly          = 'SNF(B) Ben Desc YN'
	pbp_b2_bendesc_amo_bonly         = 'SNF(B) Ben Desc AMO'
	pbp_b2_bendesc_snf_unlm_bonly    = 'SNF(B) Ben Desc Unlimited Days'
	pbp_b2_bende_al_ad_prior_bonly   = 'SNF(B) Ben Desc Num of Days'
	pbp_b2_bendesc_snf_per_bonly     = 'SNF(B) Ben Desc Per'
	pbp_b2_bendesc_snf_per_bonly_d   = 'SNF(B) Ben Desc Per Desc'
	pbp_b2_bendesc_hostay_bonly_yn   = 'SNF(B) Ben Desc Hospital Stay'
	pbp_b2_bende_nmday_prior_bonly   = 'SNF(B) BenDesc Num of Days 0-2'
	pbp_b2_maxplan_yn_bonly          = 'SNF(B) Max Plan YN'
	pbp_b2_maxplan_amt_bonly         = 'SNF(B) Max Plan Amt'
	pbp_b2_maxplan_per_bonly         = 'SNF(B) Max Plan Per'
	pbp_b2_maxplan_per_bonly_d       = 'SNF(B) Max Plan Per Desc'
	pbp_b2_maxenr_yn_bonly           = 'SNF(B) Max Enr YN'
	pbp_b2_maxenr_amt_bonly          = 'SNF(B) Max Enr Amt'
	pbp_b2_maxenr_per_bonly          = 'SNF(B) Max Enr Per'
	pbp_b2_maxenr_per_bonly_d        = 'SNF(B) Max Enr Per Desc'
	pbp_b2_coins_yn_bonly            = 'SNF(B) Coinsurance YN'
	pbp_b2_coins_pct_bonly           = 'SNF(B) Coins Pct'
	pbp_b2_coins_ps_num_bonly        = 'SNF(B) PS Coins Interval Num'
	pbp_b2_coins_ps_pct1_bonly       = 'SNF(B) PS Coins Pct Intrvl 1'
	pbp_b2_coins_ps_bgnd1_bonly      = 'SNF(B) PS Coin Bgn Day Intrv 1'
	pbp_b2_coins_ps_endd1_bonly      = 'SNF(B) PS Coin End Day Intrv 1'
	pbp_b2_coins_ps_pct2_bonly       = 'SNF(B) PS Coins Pct Intrvl 2'
	pbp_b2_coins_ps_bgnd2_bonly      = 'SNF(B) PS Coin Bgn Day Intrv 2'
	pbp_b2_coins_ps_endd2_bonly      = 'SNF(B) PS Coin End Day Intrv 2'
	pbp_b2_coins_ps_pct3_bonly       = 'SNF(B) PS Coins Pct Intrvl 3'
	pbp_b2_coins_ps_bgnd3_bonly      = 'SNF(B) PS Coin Bgn Day Intrv 3'
	pbp_b2_coins_ps_endd3_bonly      = 'SNF(B) PS Coin End Day Intrv 3'
	pbp_b2_ded_yn_bonly              = 'SNF(B) Deductible YN'
	pbp_b2_ded_amt_bonly             = 'SNF(B) Deductible Amt'
	pbp_b2_copay_yn_bonly            = 'SNF(B) Copayment YN'
	pbp_b2_copay_ps_amt_bonly        = 'SNF(B) PS Copay Amt'
	pbp_b2_copay_ps_num_bonly        = 'SNF(B) PS Copay Interval Num'
	pbp_b2_copay_ps_amt1_bonly       = 'SNF(B) PS Copay Amt Interval 1'
	pbp_b2_copay_ps_bgnd1_bonly      = 'SNF(B) PS Cpay Bgn Day Intrv 1'
	pbp_b2_copay_ps_endd1_bonly      = 'SNF(B) PS Cpay End Day Intrv 1'
	pbp_b2_copay_ps_amt2_bonly       = 'SNF(B) PS Copay Amt Interval 2'
	pbp_b2_copay_ps_bgnd2_bonly      = 'SNF(B) PS Cpay Bgn Day Intrv 2'
	pbp_b2_copay_ps_endd2_bonly      = 'SNF(B) PS Cpay End Day Intrv 2'
	pbp_b2_copay_ps_amt3_bonly       = 'SNF(B) PS Copay Amt Interval 3'
	pbp_b2_copay_ps_bgnd3_bonly      = 'SNF(B) PS Cpay Bgn Day Intrv 3'
	pbp_b2_copay_ps_endd3_bonly      = 'SNF(B) PS Cpay End Day Intrv 3'
	pbp_b2_auth_yn_bonly             = 'SNF(B) Enrollee Auth'
	pbp_b2_refer_yn_bonly            = 'SNF(B) Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step2_b out=out.pbp_step2_b;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step2_b(obs = 10);
  title 'pbp_step2_b file ';
run;

proc means data = out.pbp_step2_b;
  title 'pbp_step2_b file ';
run;

proc freq data = out.pbp_step2_b;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_2_b_yn
	pbp_b2_bendesc_yn_bonly
	pbp_b2_bendesc_amo_bonly
	pbp_b2_bendesc_snf_unlm_bonly
	pbp_b2_bendesc_snf_per_bonly
	pbp_b2_bendesc_hostay_bonly_yn
	pbp_b2_bende_nmday_prior_bonly
	pbp_b2_maxplan_yn_bonly
	pbp_b2_maxplan_per_bonly
	pbp_b2_maxenr_yn_bonly
	pbp_b2_maxenr_per_bonly
	pbp_b2_coins_yn_bonly
	pbp_b2_coins_ps_num_bonly
	pbp_b2_ded_yn_bonly
	pbp_b2_copay_yn_bonly
	pbp_b2_copay_ps_num_bonly
	pbp_b2_auth_yn_bonly
	pbp_b2_refer_yn_bonly
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step2_b;
  title 'pbp_step2_b data';
run;