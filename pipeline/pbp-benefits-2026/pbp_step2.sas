*pbp_step2.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step2;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_2_1_yn        $1
	pbp_b2_bendesc_yn                $1
	pbp_b2_bendesc_ad_nmcs           $2
	pbp_b2_bendesc_amo_ad            $1
	pbp_b2_benedesc_lim_ad           $1
	pbp_b2_coins_yn                  $1
	pbp_b2_ad_cost_vary_tiers_yn     $1
	pbp_b2_ad_cost_vary_tier_num     $1
	pbp_b2_ad_cost_vary_low_tier     $1
	pbp_b2_coins_ad_intrvl_num_t1    $1
	pbp_b2_coins_ad_intrvl_num_t2    $1
	pbp_b2_coins_ad_intrvl_num_t3    $1
	pbp_b2_copay_yn                  $1
	pbp_b2_copay_ad_intrvl_num_t1    $1
	pbp_b2_copay_ad_intrvl_num_t2    $1
	pbp_b2_copay_ad_intrvl_num_t3    $1
	pbp_b2_auth_yn                   $1
	pbp_b2_refer_yn                  $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step2.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_2_1_yn
	pbp_b2_bendesc_yn
	pbp_b2_bendesc_ad_nmcs
	pbp_b2_bendesc_amo_ad
	pbp_b2_benedesc_lim_ad
	pbp_b2_bendesc_ad
	pbp_b2_coins_yn
	pbp_b2_ad_cost_vary_tiers_yn
	pbp_b2_ad_cost_vary_tier_num
	pbp_b2_ad_cost_vary_low_tier
	pbp_b2_coins_ad_intrvl_num_t1
	pbp_b2_coins_ad_pct_int1_t1
	pbp_b2_coins_ad_bgnd_int1_t1
	pbp_b2_coins_ad_endd_int1_t1
	pbp_b2_coins_ad_pct_int2_t1
	pbp_b2_coins_ad_bgnd_int2_t1
	pbp_b2_coins_ad_endd_int2_t1
	pbp_b2_coins_ad_pct_int3_t1
	pbp_b2_coins_ad_bgnd_int3_t1
	pbp_b2_coins_ad_endd_int3_t1
	pbp_b2_coins_ad_intrvl_num_t2
	pbp_b2_coins_ad_pct_int1_t2
	pbp_b2_coins_ad_bgnd_int1_t2
	pbp_b2_coins_ad_endd_int1_t2
	pbp_b2_coins_ad_pct_int2_t2
	pbp_b2_coins_ad_bgnd_int2_t2
	pbp_b2_coins_ad_endd_int2_t2
	pbp_b2_coins_ad_pct_int3_t2
	pbp_b2_coins_ad_bgnd_int3_t2
	pbp_b2_coins_ad_endd_int3_t2
	pbp_b2_coins_ad_intrvl_num_t3
	pbp_b2_coins_ad_pct_int1_t3
	pbp_b2_coins_ad_bgnd_int1_t3
	pbp_b2_coins_ad_endd_int1_t3
	pbp_b2_coins_ad_pct_int2_t3
	pbp_b2_coins_ad_bgnd_int2_t3
	pbp_b2_coins_ad_endd_int2_t3
	pbp_b2_coins_ad_pct_int3_t3
	pbp_b2_coins_ad_bgnd_int3_t3
	pbp_b2_coins_ad_endd_int3_t3
	pbp_b2_copay_yn
	pbp_b2_copay_ad_intrvl_num_t1
	pbp_b2_copay_ad_amt_int1_t1
	pbp_b2_copay_ad_bgnd_int1_t1
	pbp_b2_copay_ad_endd_int1_t1
	pbp_b2_copay_ad_amt_int2_t1
	pbp_b2_copay_ad_bgnd_int2_t1
	pbp_b2_copay_ad_endd_int2_t1
	pbp_b2_copay_ad_amt_int3_t1
	pbp_b2_copay_ad_bgnd_int3_t1
	pbp_b2_copay_ad_endd_int3_t1
	pbp_b2_copay_ad_intrvl_num_t2
	pbp_b2_copay_ad_amt_int1_t2
	pbp_b2_copay_ad_bgnd_int1_t2
	pbp_b2_copay_ad_endd_int1_t2
	pbp_b2_copay_ad_amt_int2_t2
	pbp_b2_copay_ad_bgnd_int2_t2
	pbp_b2_copay_ad_endd_int2_t2
	pbp_b2_copay_ad_amt_int3_t2
	pbp_b2_copay_ad_bgnd_int3_t2
	pbp_b2_copay_ad_endd_int3_t2
	pbp_b2_copay_ad_intrvl_num_t3
	pbp_b2_copay_ad_amt_int1_t3
	pbp_b2_copay_ad_bgnd_int1_t3
	pbp_b2_copay_ad_endd_int1_t3
	pbp_b2_copay_ad_amt_int2_t3
	pbp_b2_copay_ad_bgnd_int2_t3
	pbp_b2_copay_ad_endd_int2_t3
	pbp_b2_copay_ad_amt_int3_t3
	pbp_b2_copay_ad_bgnd_int3_t3
	pbp_b2_copay_ad_endd_int3_t3
	pbp_b2_auth_yn
	pbp_b2_refer_yn
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
	pbp_d_opt_use_mand_2_1_yn        = 'OppSupp Cost Same INN 2-1 YN'
	pbp_b2_bendesc_yn                = 'SNF Ben Desc MO YN'
	pbp_b2_bendesc_ad_nmcs           = 'SNF (2) Supp Benefits'
	pbp_b2_bendesc_amo_ad            = 'SNF Ben Desc MO AD'
	pbp_b2_benedesc_lim_ad           = 'SNF Ben Desc AD LIM YN'
	pbp_b2_bendesc_ad                = 'SNF Ben Desc AD Num'
	pbp_b2_coins_yn                  = 'SNF Coinsurance YN'
	pbp_b2_ad_cost_vary_tiers_yn     = 'SNF AD Cost Shr Tiers Vary YN'
	pbp_b2_ad_cost_vary_tier_num     = 'SNF AD Cost Sharing Tiers'
	pbp_b2_ad_cost_vary_low_tier     = 'SNF AD Lowest Cost Tier'
	pbp_b2_coins_ad_intrvl_num_t1    = 'SNF AD Coins Interval Num'
	pbp_b2_coins_ad_pct_int1_t1      = 'SNF AD Coins Pct Interval 1'
	pbp_b2_coins_ad_bgnd_int1_t1     = 'SNF AD Coins Bgn Day Intrvl 1'
	pbp_b2_coins_ad_endd_int1_t1     = 'SNF AD Coins End Day Intrvl 1'
	pbp_b2_coins_ad_pct_int2_t1      = 'SNF AD Coins Pct Interval 2'
	pbp_b2_coins_ad_bgnd_int2_t1     = 'SNF AD Coins Bgn Day Intrvl 2'
	pbp_b2_coins_ad_endd_int2_t1     = 'SNF AD Coins End Day Intrvl 2'
	pbp_b2_coins_ad_pct_int3_t1      = 'SNF AD Coins Pct Interval 3'
	pbp_b2_coins_ad_bgnd_int3_t1     = 'SNF AD Coins Bgn Day Intrvl 3'
	pbp_b2_coins_ad_endd_int3_t1     = 'SNF AD Coins End Day Intrvl 3'
	pbp_b2_coins_ad_intrvl_num_t2    = 'SNF AD Coins Interval Num'
	pbp_b2_coins_ad_pct_int1_t2      = 'SNF AD Coins Pct Interval 1'
	pbp_b2_coins_ad_bgnd_int1_t2     = 'SNF AD Coins Bgn Day Intrvl 1'
	pbp_b2_coins_ad_endd_int1_t2     = 'SNF AD Coins End Day Intrvl 1'
	pbp_b2_coins_ad_pct_int2_t2      = 'SNF AD Coins Pct Interval 2'
	pbp_b2_coins_ad_bgnd_int2_t2     = 'SNF AD Coins Bgn Day Intrvl 2'
	pbp_b2_coins_ad_endd_int2_t2     = 'SNF AD Coins End Day Intrvl 2'
	pbp_b2_coins_ad_pct_int3_t2      = 'SNF AD Coins Pct Interval 3'
	pbp_b2_coins_ad_bgnd_int3_t2     = 'SNF AD Coins Bgn Day Intrvl 3'
	pbp_b2_coins_ad_endd_int3_t2     = 'SNF AD Coins End Day Intrvl 3'
	pbp_b2_coins_ad_intrvl_num_t3    = 'SNF AD Coins Interval Num'
	pbp_b2_coins_ad_pct_int1_t3      = 'SNF AD Coins Pct Interval 1'
	pbp_b2_coins_ad_bgnd_int1_t3     = 'SNF AD Coins Bgn Day Intrvl 1'
	pbp_b2_coins_ad_endd_int1_t3     = 'SNF AD Coins End Day Intrvl 1'
	pbp_b2_coins_ad_pct_int2_t3      = 'SNF AD Coins Pct Interval 2'
	pbp_b2_coins_ad_bgnd_int2_t3     = 'SNF AD Coins Bgn Day Intrvl 2'
	pbp_b2_coins_ad_endd_int2_t3     = 'SNF AD Coins End Day Intrvl 2'
	pbp_b2_coins_ad_pct_int3_t3      = 'SNF AD Coins Pct Interval 3'
	pbp_b2_coins_ad_bgnd_int3_t3     = 'SNF AD Coins Bgn Day Intrvl 3'
	pbp_b2_coins_ad_endd_int3_t3     = 'SNF AD Coins End Day Intrvl 3'
	pbp_b2_copay_yn                  = 'SNF Copayment YN'
	pbp_b2_copay_ad_intrvl_num_t1    = 'SNF AD Copay Interval Num'
	pbp_b2_copay_ad_amt_int1_t1      = 'SNF AD Copay Amt Interval 1'
	pbp_b2_copay_ad_bgnd_int1_t1     = 'SNF AD Copay Bgn Day Intrvl 1'
	pbp_b2_copay_ad_endd_int1_t1     = 'SNF AD Copay End Day Intrvl 1'
	pbp_b2_copay_ad_amt_int2_t1      = 'SNF AD Copay Amt Interval 2'
	pbp_b2_copay_ad_bgnd_int2_t1     = 'SNF AD Copay Bgn Day Intrvl 2'
	pbp_b2_copay_ad_endd_int2_t1     = 'SNF AD Copay End Day Intrvl 2'
	pbp_b2_copay_ad_amt_int3_t1      = 'SNF AD Copay Amt Interval 3'
	pbp_b2_copay_ad_bgnd_int3_t1     = 'SNF AD Copay Bgn Day Intrvl 3'
	pbp_b2_copay_ad_endd_int3_t1     = 'SNF AD Copay End Day Intrvl 3'
	pbp_b2_copay_ad_intrvl_num_t2    = 'SNF AD Copay Interval Num'
	pbp_b2_copay_ad_amt_int1_t2      = 'SNF AD Copay Amt Interval 1'
	pbp_b2_copay_ad_bgnd_int1_t2     = 'SNF AD Copay Bgn Day Intrvl 1'
	pbp_b2_copay_ad_endd_int1_t2     = 'SNF AD Copay End Day Intrvl 1'
	pbp_b2_copay_ad_amt_int2_t2      = 'SNF AD Copay Amt Interval 2'
	pbp_b2_copay_ad_bgnd_int2_t2     = 'SNF AD Copay Bgn Day Intrvl 2'
	pbp_b2_copay_ad_endd_int2_t2     = 'SNF AD Copay End Day Intrvl 2'
	pbp_b2_copay_ad_amt_int3_t2      = 'SNF AD Copay Amt Interval 3'
	pbp_b2_copay_ad_bgnd_int3_t2     = 'SNF AD Copay Bgn Day Intrvl 3'
	pbp_b2_copay_ad_endd_int3_t2     = 'SNF AD Copay End Day Intrvl 3'
	pbp_b2_copay_ad_intrvl_num_t3    = 'SNF AD Copay Interval Num'
	pbp_b2_copay_ad_amt_int1_t3      = 'SNF AD Copay Amt Interval 1'
	pbp_b2_copay_ad_bgnd_int1_t3     = 'SNF AD Copay Bgn Day Intrvl 1'
	pbp_b2_copay_ad_endd_int1_t3     = 'SNF AD Copay End Day Intrvl 1'
	pbp_b2_copay_ad_amt_int2_t3      = 'SNF AD Copay Amt Interval 2'
	pbp_b2_copay_ad_bgnd_int2_t3     = 'SNF AD Copay Bgn Day Intrvl 2'
	pbp_b2_copay_ad_endd_int2_t3     = 'SNF AD Copay End Day Intrvl 2'
	pbp_b2_copay_ad_amt_int3_t3      = 'SNF AD Copay Amt Interval 3'
	pbp_b2_copay_ad_bgnd_int3_t3     = 'SNF AD Copay Bgn Day Intrvl 3'
	pbp_b2_copay_ad_endd_int3_t3     = 'SNF AD Copay End Day Intrvl 3'
	pbp_b2_auth_yn                   = 'SNF Auth YN'
	pbp_b2_refer_yn                  = 'SNF Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step2 out=out.pbp_step2;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step2(obs = 10);
  title 'pbp_step2 file ';
run;

proc means data = out.pbp_step2;
  title 'pbp_step2 file ';
run;

proc freq data = out.pbp_step2;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_2_1_yn
	pbp_b2_bendesc_yn
	pbp_b2_bendesc_ad_nmcs
	pbp_b2_bendesc_amo_ad
	pbp_b2_benedesc_lim_ad
	pbp_b2_coins_yn
	pbp_b2_ad_cost_vary_tiers_yn
	pbp_b2_ad_cost_vary_tier_num
	pbp_b2_ad_cost_vary_low_tier
	pbp_b2_coins_ad_intrvl_num_t1
	pbp_b2_coins_ad_intrvl_num_t2
	pbp_b2_coins_ad_intrvl_num_t3
	pbp_b2_copay_yn
	pbp_b2_copay_ad_intrvl_num_t1
	pbp_b2_copay_ad_intrvl_num_t2
	pbp_b2_copay_ad_intrvl_num_t3
	pbp_b2_auth_yn
	pbp_b2_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step2;
  title 'pbp_step2 data';
run;