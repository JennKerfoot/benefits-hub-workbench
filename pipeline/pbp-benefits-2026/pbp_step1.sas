*pbp_step1.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step1;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_1a1_yn        $1
	pbp_d_opt_use_mand_1a2_yn        $1
	pbp_d_opt_use_mand_1a3_yn        $1
	pbp_d_opt_use_mand_1b1_yn        $1
	pbp_d_opt_use_mand_1b2_yn        $1
	pbp_b1a_bendesc_yn               $1
	pbp_b1a_bendesc_ad_up_nmcs       $3
	pbp_b1a_bendesc_amo_ad           $1
	pbp_b1a_bendesc_lim_ad           $1
	pbp_b1a_bendesc_amo_nmcs         $1
	pbp_b1a_bendesc_amo_up           $1
	pbp_b1a_coins_yn                 $1
	pbp_b1a_ad_cost_vary_tiers_yn    $1
	pbp_b1a_ad_cost_vary_tier_num    $1
	pbp_b1a_ad_cost_vary_low_tier    $1
	pbp_b1a_coins_ad_intrvl_num_t1   $1
	pbp_b1a_coins_ad_intrvl_num_t2   $1
	pbp_b1a_coins_ad_intrvl_num_t3   $1
	pbp_b1a_coins_nmcs_struc_yn      $1
	pbp_b1a_coins_nmcs_intrvl_num    $1
	pbp_b1a_coins_up_cstshr_yn       $1
	pbp_b1a_copay_yn                 $1
	pbp_b1a_copay_ad_intrvl_num_t1   $1
	pbp_b1a_copay_ad_intrvl_num_t2   $1
	pbp_b1a_copay_ad_intrvl_num_t3   $1
	pbp_b1a_copay_nmcs_struc_yn      $1
	pbp_b1a_copay_nmcs_intrvl_num    $1
	pbp_b1a_copay_up_cstshr_yn       $1
	pbp_b1a_auth_yn                  $1
	pbp_b1a_refer_yn                 $1
	pbp_b1b_bendesc_yn               $1
	pbp_b1b_bendesc_ad_nmcs          $2
	pbp_b1b_bendesc_amo_ad           $1
	pbp_b1b_bendesc_lim_ad           $1
	pbp_b1b_bendesc_amo_nmcs         $1
	pbp_b1b_coins_yn                 $1
	pbp_b1b_ad_cost_vary_tiers_yn    $1
	pbp_b1b_ad_cost_vary_tier_num    $1
	pbp_b1b_ad_cost_vary_low_tier    $1
	pbp_b1b_coins_ad_intrvl_num_t1   $1
	pbp_b1b_coins_ad_intrvl_num_t2   $1
	pbp_b1b_coins_ad_intrvl_num_t3   $1
	pbp_b1b_coins_nmcs_struc_yn      $1
	pbp_b1b_coins_nmcs_intrvl_num    $1
	pbp_b1b_copay_yn                 $1
	pbp_b1b_copay_ad_intrvl_num_t1   $1
	pbp_b1b_copay_ad_intrvl_num_t2   $1
	pbp_b1b_copay_ad_intrvl_num_t3   $1
	pbp_b1b_copay_nmcs_struc_yn      $1
	pbp_b1b_copay_nmcs_intrvl_num    $1
	pbp_b1b_auth_yn                  $1
	pbp_b1b_refer_yn                 $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step1.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_1a1_yn
	pbp_d_opt_use_mand_1a2_yn
	pbp_d_opt_use_mand_1a3_yn
	pbp_d_opt_use_mand_1b1_yn
	pbp_d_opt_use_mand_1b2_yn
	pbp_b1a_bendesc_yn
	pbp_b1a_bendesc_ad_up_nmcs
	pbp_b1a_bendesc_amo_ad
	pbp_b1a_bendesc_lim_ad
	pbp_b1a_bendesc_amt_ad
	pbp_b1a_bendesc_amo_nmcs
	pbp_b1a_bendesc_amo_up
	pbp_b1a_coins_yn
	pbp_b1a_ad_cost_vary_tiers_yn
	pbp_b1a_ad_cost_vary_tier_num
	pbp_b1a_ad_cost_vary_low_tier
	pbp_b1a_coins_ad_intrvl_num_t1
	pbp_b1a_coins_ad_pct_int1_t1
	pbp_b1a_coins_ad_bgnd_int1_t1
	pbp_b1a_coins_ad_endd_int1_t1
	pbp_b1a_coins_ad_pct_int2_t1
	pbp_b1a_coins_ad_bgnd_int2_t1
	pbp_b1a_coins_ad_endd_int2_t1
	pbp_b1a_coins_ad_pct_int3_t1
	pbp_b1a_coins_ad_bgnd_int3_t1
	pbp_b1a_coins_ad_endd_int3_t1
	pbp_b1a_coins_ad_intrvl_num_t2
	pbp_b1a_coins_ad_pct_int1_t2
	pbp_b1a_coins_ad_bgnd_int1_t2
	pbp_b1a_coins_ad_endd_int1_t2
	pbp_b1a_coins_ad_pct_int2_t2
	pbp_b1a_coins_ad_bgnd_int2_t2
	pbp_b1a_coins_ad_endd_int2_t2
	pbp_b1a_coins_ad_pct_int3_t2
	pbp_b1a_coins_ad_bgnd_int3_t2
	pbp_b1a_coins_ad_endd_int3_t2
	pbp_b1a_coins_ad_intrvl_num_t3
	pbp_b1a_coins_ad_pct_int1_t3
	pbp_b1a_coins_ad_bgnd_int1_t3
	pbp_b1a_coins_ad_endd_int1_t3
	pbp_b1a_coins_ad_pct_int2_t3
	pbp_b1a_coins_ad_bgnd_int2_t3
	pbp_b1a_coins_ad_endd_int2_t3
	pbp_b1a_coins_ad_pct_int3_t3
	pbp_b1a_coins_ad_bgnd_int3_t3
	pbp_b1a_coins_ad_endd_int3_t3
	pbp_b1a_coins_nmcs_struc_yn
	pbp_b1a_coins_nmcs_pct
	pbp_b1a_coins_nmcs_intrvl_num
	pbp_b1a_coins_nmcs_pct_intrvl1
	pbp_b1a_coins_nmcs_bgnd_ntrvl1
	pbp_b1a_coins_nmcs_endd_ntrvl1
	pbp_b1a_coins_nmcs_pct_intrvl2
	pbp_b1a_coins_nmcs_bgnd_ntrvl2
	pbp_b1a_coins_nmcs_endd_ntrvl2
	pbp_b1a_coins_nmcs_pct_intrvl3
	pbp_b1a_coins_nmcs_bgnd_ntrvl3
	pbp_b1a_coins_nmcs_endd_ntrvl3
	pbp_b1a_coins_up_cstshr_yn
	pbp_b1a_coins_pct_up
	pbp_b1a_copay_yn
	pbp_b1a_copay_ad_intrvl_num_t1
	pbp_b1a_copay_ad_amt_int1_t1
	pbp_b1a_copay_ad_bgnd_int1_t1
	pbp_b1a_copay_ad_endd_int1_t1
	pbp_b1a_copay_ad_amt_int2_t1
	pbp_b1a_copay_ad_bgnd_int2_t1
	pbp_b1a_copay_ad_endd_int2_t1
	pbp_b1a_copay_ad_amt_int3_t1
	pbp_b1a_copay_ad_bgnd_int3_t1
	pbp_b1a_copay_ad_endd_int3_t1
	pbp_b1a_copay_ad_intrvl_num_t2
	pbp_b1a_copay_ad_amt_int1_t2
	pbp_b1a_copay_ad_bgnd_int1_t2
	pbp_b1a_copay_ad_endd_int1_t2
	pbp_b1a_copay_ad_amt_int2_t2
	pbp_b1a_copay_ad_bgnd_int2_t2
	pbp_b1a_copay_ad_endd_int2_t2
	pbp_b1a_copay_ad_amt_int3_t2
	pbp_b1a_copay_ad_bgnd_int3_t2
	pbp_b1a_copay_ad_endd_int3_t2
	pbp_b1a_copay_ad_intrvl_num_t3
	pbp_b1a_copay_ad_amt_int1_t3
	pbp_b1a_copay_ad_bgnd_int1_t3
	pbp_b1a_copay_ad_endd_int1_t3
	pbp_b1a_copay_ad_amt_int2_t3
	pbp_b1a_copay_ad_bgnd_int2_t3
	pbp_b1a_copay_ad_endd_int2_t3
	pbp_b1a_copay_ad_amt_int3_t3
	pbp_b1a_copay_ad_bgnd_int3_t3
	pbp_b1a_copay_ad_endd_int3_t3
	pbp_b1a_copay_nmcs_struc_yn
	pbp_b1a_copay_nmcs_amt
	pbp_b1a_copay_nmcs_intrvl_num
	pbp_b1a_copay_nmcs_amt_intrvl1
	pbp_b1a_copay_nmcs_bgnd_ntrvl1
	pbp_b1a_copay_nmcs_endd_ntrvl1
	pbp_b1a_copay_nmcs_amt_intrvl2
	pbp_b1a_copay_nmcs_bgnd_ntrvl2
	pbp_b1a_copay_nmcs_endd_ntrvl2
	pbp_b1a_copay_nmcs_amt_intrvl3
	pbp_b1a_copay_nmcs_bgnd_ntrvl3
	pbp_b1a_copay_nmcs_endd_ntrvl3
	pbp_b1a_copay_up_cstshr_yn
	pbp_b1a_copay_up_amt_stay
	pbp_b1a_copay_up_amt_day
	pbp_b1a_auth_yn
	pbp_b1a_refer_yn
	pbp_b1b_bendesc_yn
	pbp_b1b_bendesc_ad_nmcs
	pbp_b1b_bendesc_amo_ad
	pbp_b1b_bendesc_lim_ad
	pbp_b1b_bendesc_amt_ad
	pbp_b1b_bendesc_amo_nmcs
	pbp_b1b_coins_yn
	pbp_b1b_ad_cost_vary_tiers_yn
	pbp_b1b_ad_cost_vary_tier_num
	pbp_b1b_ad_cost_vary_low_tier
	pbp_b1b_coins_ad_intrvl_num_t1
	pbp_b1b_coins_ad_pct_int1_t1
	pbp_b1b_coins_ad_bgnd_int1_t1
	pbp_b1b_coins_ad_endd_int1_t1
	pbp_b1b_coins_ad_pct_int2_t1
	pbp_b1b_coins_ad_bgnd_int2_t1
	pbp_b1b_coins_ad_endd_int2_t1
	pbp_b1b_coins_ad_pct_int3_t1
	pbp_b1b_coins_ad_bgnd_int3_t1
	pbp_b1b_coins_ad_endd_int3_t1
	pbp_b1b_coins_ad_intrvl_num_t2
	pbp_b1b_coins_ad_pct_int1_t2
	pbp_b1b_coins_ad_bgnd_int1_t2
	pbp_b1b_coins_ad_endd_int1_t2
	pbp_b1b_coins_ad_pct_int2_t2
	pbp_b1b_coins_ad_bgnd_int2_t2
	pbp_b1b_coins_ad_endd_int2_t2
	pbp_b1b_coins_ad_pct_int3_t2
	pbp_b1b_coins_ad_bgnd_int3_t2
	pbp_b1b_coins_ad_endd_int3_t2
	pbp_b1b_coins_ad_intrvl_num_t3
	pbp_b1b_coins_ad_pct_int1_t3
	pbp_b1b_coins_ad_bgnd_int1_t3
	pbp_b1b_coins_ad_endd_int1_t3
	pbp_b1b_coins_ad_pct_int2_t3
	pbp_b1b_coins_ad_bgnd_int2_t3
	pbp_b1b_coins_ad_endd_int2_t3
	pbp_b1b_coins_ad_pct_int3_t3
	pbp_b1b_coins_ad_bgnd_int3_t3
	pbp_b1b_coins_ad_endd_int3_t3
	pbp_b1b_coins_nmcs_struc_yn
	pbp_b1b_coins_pct_nmcs
	pbp_b1b_coins_nmcs_intrvl_num
	pbp_b1b_coins_nmcs_pct_intrvl1
	pbp_b1b_coins_nmcs_bgnd_ntrvl1
	pbp_b1b_coins_nmcs_endd_ntrvl1
	pbp_b1b_coins_nmcs_pct_intrvl2
	pbp_b1b_coins_nmcs_bgnd_ntrvl2
	pbp_b1b_coins_nmcs_endd_ntrvl2
	pbp_b1b_coins_nmcs_pct_intrvl3
	pbp_b1b_coins_nmcs_bgnd_ntrvl3
	pbp_b1b_coins_nmcs_endd_ntrvl3
	pbp_b1b_copay_yn
	pbp_b1b_copay_ad_intrvl_num_t1
	pbp_b1b_copay_ad_amt_int1_t1
	pbp_b1b_copay_ad_bgnd_int1_t1
	pbp_b1b_copay_ad_endd_int1_t1
	pbp_b1b_copay_ad_amt_int2_t1
	pbp_b1b_copay_ad_bgnd_int2_t1
	pbp_b1b_copay_ad_endd_int2_t1
	pbp_b1b_copay_ad_amt_int3_t1
	pbp_b1b_copay_ad_bgnd_int3_t1
	pbp_b1b_copay_ad_endd_int3_t1
	pbp_b1b_copay_ad_intrvl_num_t2
	pbp_b1b_copay_ad_amt_int1_t2
	pbp_b1b_copay_ad_bgnd_int1_t2
	pbp_b1b_copay_ad_endd_int1_t2
	pbp_b1b_copay_ad_amt_int2_t2
	pbp_b1b_copay_ad_bgnd_int2_t2
	pbp_b1b_copay_ad_endd_int2_t2
	pbp_b1b_copay_ad_amt_int3_t2
	pbp_b1b_copay_ad_bgnd_int3_t2
	pbp_b1b_copay_ad_endd_int3_t2
	pbp_b1b_copay_ad_intrvl_num_t3
	pbp_b1b_copay_ad_amt_int1_t3
	pbp_b1b_copay_ad_bgnd_int1_t3
	pbp_b1b_copay_ad_endd_int1_t3
	pbp_b1b_copay_ad_amt_int2_t3
	pbp_b1b_copay_ad_bgnd_int2_t3
	pbp_b1b_copay_ad_endd_int2_t3
	pbp_b1b_copay_ad_amt_int3_t3
	pbp_b1b_copay_ad_bgnd_int3_t3
	pbp_b1b_copay_ad_endd_int3_t3
	pbp_b1b_copay_nmcs_struc_yn
	pbp_b1b_copay_nmcs_amt
	pbp_b1b_copay_nmcs_intrvl_num
	pbp_b1b_copay_nmcs_amt_intrvl1
	pbp_b1b_copay_nmcs_bgnd_ntrvl1
	pbp_b1b_copay_nmcs_endd_ntrvl1
	pbp_b1b_copay_nmcs_amt_intrvl2
	pbp_b1b_copay_nmcs_bgnd_ntrvl2
	pbp_b1b_copay_nmcs_endd_ntrvl2
	pbp_b1b_copay_nmcs_amt_intrvl3
	pbp_b1b_copay_nmcs_bgnd_ntrvl3
	pbp_b1b_copay_nmcs_endd_ntrvl3
	pbp_b1b_auth_yn
	pbp_b1b_refer_yn
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
	pbp_d_opt_use_mand_1a1_yn        = 'OppSupp Cost Same INN 1A1 YN'
	pbp_d_opt_use_mand_1a2_yn        = 'OppSupp Cost Same INN 1A2 YN'
	pbp_d_opt_use_mand_1a3_yn        = 'OppSupp Cost Same INN 1A3 YN'
	pbp_d_opt_use_mand_1b1_yn        = 'OppSupp Cost Same INN 1B1 YN'
	pbp_d_opt_use_mand_1b2_yn        = 'OppSupp Cost Same INN 1B2 YN'
	pbp_b1a_bendesc_yn               = 'IHA Supp Benefits YN'
	pbp_b1a_bendesc_ad_up_nmcs       = 'IHA (1a) Supp Benefits'
	pbp_b1a_bendesc_amo_ad           = 'IHA Ben Desc AD AMO'
	pbp_b1a_bendesc_lim_ad           = 'IHA Ben Desc AD Lim YN'
	pbp_b1a_bendesc_amt_ad           = 'IHA Ben Desc AD Amt'
	pbp_b1a_bendesc_amo_nmcs         = 'IHA Ben Desc NMCS AMO'
	pbp_b1a_bendesc_amo_up           = 'IHA Ben Desc UP AMO'
	pbp_b1a_coins_yn                 = 'IHA Coinsurance YN'
	pbp_b1a_ad_cost_vary_tiers_yn    = 'IHA AD Cost ByTiers Vary YN'
	pbp_b1a_ad_cost_vary_tier_num    = 'IHA AD Cost Sharing Tiers'
	pbp_b1a_ad_cost_vary_low_tier    = 'IHA AD Lowest Cost Tier'
	pbp_b1a_coins_ad_intrvl_num_t1   = 'IHA AD Coins Interval Num'
	pbp_b1a_coins_ad_pct_int1_t1     = 'IHA AD Coins Pct Intrvl 1'
	pbp_b1a_coins_ad_bgnd_int1_t1    = 'IHA AD Coins Bgn Day Intrvl 1'
	pbp_b1a_coins_ad_endd_int1_t1    = 'IHA AD Coins End Day Intrvl 1'
	pbp_b1a_coins_ad_pct_int2_t1     = 'IHA AD Coins Pct Intrvl 2'
	pbp_b1a_coins_ad_bgnd_int2_t1    = 'IHA AD Coins Bgn Day Intrvl 2'
	pbp_b1a_coins_ad_endd_int2_t1    = 'IHA AD Coins End Day Intrvl 2'
	pbp_b1a_coins_ad_pct_int3_t1     = 'IHA AD Coins Pct Intrvl 3'
	pbp_b1a_coins_ad_bgnd_int3_t1    = 'IHA AD Coins Bgn Day Intrvl 3'
	pbp_b1a_coins_ad_endd_int3_t1    = 'IHA AD Coins End Day Intrvl 3'
	pbp_b1a_coins_ad_intrvl_num_t2   = 'IHA AD Coins Interval Num'
	pbp_b1a_coins_ad_pct_int1_t2     = 'IHA AD Coins Pct Intrvl 1'
	pbp_b1a_coins_ad_bgnd_int1_t2    = 'IHA AD Coins Bgn Day Intrvl 1'
	pbp_b1a_coins_ad_endd_int1_t2    = 'IHA AD Coins End Day Intrvl 1'
	pbp_b1a_coins_ad_pct_int2_t2     = 'IHA AD Coins Pct Intrvl 2'
	pbp_b1a_coins_ad_bgnd_int2_t2    = 'IHA AD Coins Bgn Day Intrvl 2'
	pbp_b1a_coins_ad_endd_int2_t2    = 'IHA AD Coins End Day Intrvl 2'
	pbp_b1a_coins_ad_pct_int3_t2     = 'IHA AD Coins Pct Intrvl 3'
	pbp_b1a_coins_ad_bgnd_int3_t2    = 'IHA AD Coins Bgn Day Intrvl 3'
	pbp_b1a_coins_ad_endd_int3_t2    = 'IHA AD Coins End Day Intrvl 3'
	pbp_b1a_coins_ad_intrvl_num_t3   = 'IHA AD Coins Interval Num'
	pbp_b1a_coins_ad_pct_int1_t3     = 'IHA AD Coins Pct Intrvl 1'
	pbp_b1a_coins_ad_bgnd_int1_t3    = 'IHA AD Coins Bgn Day Intrvl 1'
	pbp_b1a_coins_ad_endd_int1_t3    = 'IHA AD Coins End Day Intrvl 1'
	pbp_b1a_coins_ad_pct_int2_t3     = 'IHA AD Coins Pct Intrvl 2'
	pbp_b1a_coins_ad_bgnd_int2_t3    = 'IHA AD Coins Bgn Day Intrvl 2'
	pbp_b1a_coins_ad_endd_int2_t3    = 'IHA AD Coins End Day Intrvl 2'
	pbp_b1a_coins_ad_pct_int3_t3     = 'IHA AD Coins Pct Intrvl 3'
	pbp_b1a_coins_ad_bgnd_int3_t3    = 'IHA AD Coins Bgn Day Intrvl 3'
	pbp_b1a_coins_ad_endd_int3_t3    = 'IHA AD Coins End Day Intrvl 3'
	pbp_b1a_coins_nmcs_struc_yn      = 'IHA NMCS Coins Structure YN'
	pbp_b1a_coins_nmcs_pct           = 'IHA NMCS Coins Pct'
	pbp_b1a_coins_nmcs_intrvl_num    = 'IHA NMCS Coins Interval Num'
	pbp_b1a_coins_nmcs_pct_intrvl1   = 'IHA NMCS Coins Pct Intrvl 1'
	pbp_b1a_coins_nmcs_bgnd_ntrvl1   = 'IHA NMCS Coins BgnDay Intrvl 1'
	pbp_b1a_coins_nmcs_endd_ntrvl1   = 'IHA NMCS Coins EndDay Intrvl 1'
	pbp_b1a_coins_nmcs_pct_intrvl2   = 'IHA NMCS Coins Pct Intrvl 2'
	pbp_b1a_coins_nmcs_bgnd_ntrvl2   = 'IHA NMCS Coins BgnDay Intrvl 2'
	pbp_b1a_coins_nmcs_endd_ntrvl2   = 'IHA NMCS Coins EndDay Intrvl 2'
	pbp_b1a_coins_nmcs_pct_intrvl3   = 'IHA NMCS Coins Pct Intrvl 3'
	pbp_b1a_coins_nmcs_bgnd_ntrvl3   = 'IHA NMCS Coins BgnDay Intrvl 3'
	pbp_b1a_coins_nmcs_endd_ntrvl3   = 'IHA NMCS Coins EndDay Intrvl 3'
	pbp_b1a_coins_up_cstshr_yn       = 'IHA UP Cost Same MC YN'
	pbp_b1a_coins_pct_up             = 'IHA UP Coin Pct'
	pbp_b1a_copay_yn                 = 'IHA Copayment YN'
	pbp_b1a_copay_ad_intrvl_num_t1   = 'IHA AD Copay Interval Num'
	pbp_b1a_copay_ad_amt_int1_t1     = 'IHA AD Copay Amt Interval 1'
	pbp_b1a_copay_ad_bgnd_int1_t1    = 'IHA AD Copay Bgn Day Intrvl 1'
	pbp_b1a_copay_ad_endd_int1_t1    = 'IHA AD Copay End Day Intrvl 1'
	pbp_b1a_copay_ad_amt_int2_t1     = 'IHA AD Copay Amt Interval 2'
	pbp_b1a_copay_ad_bgnd_int2_t1    = 'IHA AD Copay Bgn Day Intrvl 2'
	pbp_b1a_copay_ad_endd_int2_t1    = 'IHA AD Copay End Day Intrvl 2'
	pbp_b1a_copay_ad_amt_int3_t1     = 'IHA AD Copay Amt Interval 3'
	pbp_b1a_copay_ad_bgnd_int3_t1    = 'IHA AD Copay Bgn Day Intrvl 3'
	pbp_b1a_copay_ad_endd_int3_t1    = 'IHA AD Copay End Day Intrvl 3'
	pbp_b1a_copay_ad_intrvl_num_t2   = 'IHA AD Copay Interval Num'
	pbp_b1a_copay_ad_amt_int1_t2     = 'IHA AD Copay Amt Interval 1'
	pbp_b1a_copay_ad_bgnd_int1_t2    = 'IHA AD Copay Bgn Day Intrvl 1'
	pbp_b1a_copay_ad_endd_int1_t2    = 'IHA AD Copay End Day Intrvl 1'
	pbp_b1a_copay_ad_amt_int2_t2     = 'IHA AD Copay Amt Interval 2'
	pbp_b1a_copay_ad_bgnd_int2_t2    = 'IHA AD Copay Bgn Day Intrvl 2'
	pbp_b1a_copay_ad_endd_int2_t2    = 'IHA AD Copay End Day Intrvl 2'
	pbp_b1a_copay_ad_amt_int3_t2     = 'IHA AD Copay Amt Interval 3'
	pbp_b1a_copay_ad_bgnd_int3_t2    = 'IHA AD Copay Bgn Day Intrvl 3'
	pbp_b1a_copay_ad_endd_int3_t2    = 'IHA AD Copay End Day Intrvl 3'
	pbp_b1a_copay_ad_intrvl_num_t3   = 'IHA AD Copay Interval Num'
	pbp_b1a_copay_ad_amt_int1_t3     = 'IHA AD Copay Amt Interval 1'
	pbp_b1a_copay_ad_bgnd_int1_t3    = 'IHA AD Copay Bgn Day Intrvl 1'
	pbp_b1a_copay_ad_endd_int1_t3    = 'IHA AD Copay End Day Intrvl 1'
	pbp_b1a_copay_ad_amt_int2_t3     = 'IHA AD Copay Amt Interval 2'
	pbp_b1a_copay_ad_bgnd_int2_t3    = 'IHA AD Copay Bgn Day Intrvl 2'
	pbp_b1a_copay_ad_endd_int2_t3    = 'IHA AD Copay End Day Intrvl 2'
	pbp_b1a_copay_ad_amt_int3_t3     = 'IHA AD Copay Amt Interval 3'
	pbp_b1a_copay_ad_bgnd_int3_t3    = 'IHA AD Copay Bgn Day Intrvl 3'
	pbp_b1a_copay_ad_endd_int3_t3    = 'IHA AD Copay End Day Intrvl 3'
	pbp_b1a_copay_nmcs_struc_yn      = 'IHA NMCS Copay Structure YN'
	pbp_b1a_copay_nmcs_amt           = 'IHA NMCS Copay Amt'
	pbp_b1a_copay_nmcs_intrvl_num    = 'IHA NMCS Copay Interval Num'
	pbp_b1a_copay_nmcs_amt_intrvl1   = 'IHA NMCS Copay Amt Interval 1'
	pbp_b1a_copay_nmcs_bgnd_ntrvl1   = 'IHA NMCS Copay BgnDay Intrvl 1'
	pbp_b1a_copay_nmcs_endd_ntrvl1   = 'IHA NMCS Copay EndDay Intrvl 1'
	pbp_b1a_copay_nmcs_amt_intrvl2   = 'IHA NMCS Copay Amt Interval 2'
	pbp_b1a_copay_nmcs_bgnd_ntrvl2   = 'IHA NMCS Copay BgnDay Intrvl 2'
	pbp_b1a_copay_nmcs_endd_ntrvl2   = 'IHA NMCS Copay EndDay Intrvl 2'
	pbp_b1a_copay_nmcs_amt_intrvl3   = 'IHA NMCS Copay Amt Interval 3'
	pbp_b1a_copay_nmcs_bgnd_ntrvl3   = 'IHA NMCS Copay BgnDay Intrvl 3'
	pbp_b1a_copay_nmcs_endd_ntrvl3   = 'IHA NMCS Copay EndDay Intrvl 3'
	pbp_b1a_copay_up_cstshr_yn       = 'IHA UP Copay Same MCS YN'
	pbp_b1a_copay_up_amt_stay        = 'IHA UP Copay Stay Amt'
	pbp_b1a_copay_up_amt_day         = 'IHA UP Copay Day Amt'
	pbp_b1a_auth_yn                  = 'IHA Enrollee Auth'
	pbp_b1a_refer_yn                 = 'IHA Referral YN'
	pbp_b1b_bendesc_yn               = 'IPH Ben Desc YN'
	pbp_b1b_bendesc_ad_nmcs          = 'IHP (1b) Supp Bens AD/NMCS'
	pbp_b1b_bendesc_amo_ad           = 'IHP AD Ben Desc AMO'
	pbp_b1b_bendesc_lim_ad           = 'IHP AD Ben Desc Lim YN'
	pbp_b1b_bendesc_amt_ad           = 'IHP AD Ben Desc Amt'
	pbp_b1b_bendesc_amo_nmcs         = 'IHP NMCS Ben Desc AMO'
	pbp_b1b_coins_yn                 = 'IHP Coinsurance YN'
	pbp_b1b_ad_cost_vary_tiers_yn    = 'IHP AD Cost Tiers Vary YN'
	pbp_b1b_ad_cost_vary_tier_num    = 'IHP AD Cost Sharing Tiers'
	pbp_b1b_ad_cost_vary_low_tier    = 'IHP AD Lowest Cost Tier'
	pbp_b1b_coins_ad_intrvl_num_t1   = 'IPH AD Coins Interval Num'
	pbp_b1b_coins_ad_pct_int1_t1     = 'IPH AD Coins Pct Intrvl 1'
	pbp_b1b_coins_ad_bgnd_int1_t1    = 'IPH AD Coins Bgn Day Intrvl 1'
	pbp_b1b_coins_ad_endd_int1_t1    = 'IPH AD Coins End Day Intrvl 1'
	pbp_b1b_coins_ad_pct_int2_t1     = 'IPH AD Coins Pct Intrvl 2'
	pbp_b1b_coins_ad_bgnd_int2_t1    = 'IPH AD Coins Bgn Day Intrvl 2'
	pbp_b1b_coins_ad_endd_int2_t1    = 'IPH AD Coins End Day Intrvl 2'
	pbp_b1b_coins_ad_pct_int3_t1     = 'IPH AD Coins Pct Intrvl 3'
	pbp_b1b_coins_ad_bgnd_int3_t1    = 'IPH AD Coins Bgn Day Intrvl 3'
	pbp_b1b_coins_ad_endd_int3_t1    = 'IPH AD Coins End Day Intrvl 3'
	pbp_b1b_coins_ad_intrvl_num_t2   = 'IPH AD Coins Interval Num'
	pbp_b1b_coins_ad_pct_int1_t2     = 'IPH AD Coins Pct Intrvl 1'
	pbp_b1b_coins_ad_bgnd_int1_t2    = 'IPH AD Coins Bgn Day Intrvl 1'
	pbp_b1b_coins_ad_endd_int1_t2    = 'IPH AD Coins End Day Intrvl 1'
	pbp_b1b_coins_ad_pct_int2_t2     = 'IPH AD Coins Pct Intrvl 2'
	pbp_b1b_coins_ad_bgnd_int2_t2    = 'IPH AD Coins Bgn Day Intrvl 2'
	pbp_b1b_coins_ad_endd_int2_t2    = 'IPH AD Coins End Day Intrvl 2'
	pbp_b1b_coins_ad_pct_int3_t2     = 'IPH AD Coins Pct Intrvl 3'
	pbp_b1b_coins_ad_bgnd_int3_t2    = 'IPH AD Coins Bgn Day Intrvl 3'
	pbp_b1b_coins_ad_endd_int3_t2    = 'IPH AD Coins End Day Intrvl 3'
	pbp_b1b_coins_ad_intrvl_num_t3   = 'IPH AD Coins Interval Num'
	pbp_b1b_coins_ad_pct_int1_t3     = 'IPH AD Coins Pct Intrvl 1'
	pbp_b1b_coins_ad_bgnd_int1_t3    = 'IPH AD Coins Bgn Day Intrvl 1'
	pbp_b1b_coins_ad_endd_int1_t3    = 'IPH AD Coins End Day Intrvl 1'
	pbp_b1b_coins_ad_pct_int2_t3     = 'IPH AD Coins Pct Intrvl 2'
	pbp_b1b_coins_ad_bgnd_int2_t3    = 'IPH AD Coins Bgn Day Intrvl 2'
	pbp_b1b_coins_ad_endd_int2_t3    = 'IPH AD Coins End Day Intrvl 2'
	pbp_b1b_coins_ad_pct_int3_t3     = 'IPH AD Coins Pct Intrvl 3'
	pbp_b1b_coins_ad_bgnd_int3_t3    = 'IPH AD Coins Bgn Day Intrvl 3'
	pbp_b1b_coins_ad_endd_int3_t3    = 'IPH AD Coins End Day Intrvl 3'
	pbp_b1b_coins_nmcs_struc_yn      = 'IPH NMCS Coins Structure YN'
	pbp_b1b_coins_pct_nmcs           = 'IPH NMCS Coins Pct'
	pbp_b1b_coins_nmcs_intrvl_num    = 'IPH NMCS Coins Interval Num'
	pbp_b1b_coins_nmcs_pct_intrvl1   = 'IPH NMCS Coins Pct Intrvl 1'
	pbp_b1b_coins_nmcs_bgnd_ntrvl1   = 'IPH NMCS Coins BgnDay Intrvl 1'
	pbp_b1b_coins_nmcs_endd_ntrvl1   = 'IPH NMCS Coins EndDay Intrvl 1'
	pbp_b1b_coins_nmcs_pct_intrvl2   = 'IPH NMCS Coins Pct Intrvl 2'
	pbp_b1b_coins_nmcs_bgnd_ntrvl2   = 'IPH NMCS Coins BgnDay Intrvl 2'
	pbp_b1b_coins_nmcs_endd_ntrvl2   = 'IPH NMCS Coins EndDay Intrvl 2'
	pbp_b1b_coins_nmcs_pct_intrvl3   = 'IPH NMCS Coins Pct Intrvl 3'
	pbp_b1b_coins_nmcs_bgnd_ntrvl3   = 'IPH NMCS Coins BgnDay Intrvl 3'
	pbp_b1b_coins_nmcs_endd_ntrvl3   = 'IPH NMCS Coins EndDay Intrvl 3'
	pbp_b1b_copay_yn                 = 'IPH Copayment YN'
	pbp_b1b_copay_ad_intrvl_num_t1   = 'IPH AD Copay Interval Num'
	pbp_b1b_copay_ad_amt_int1_t1     = 'IPH AD Copay Amt Interval 1'
	pbp_b1b_copay_ad_bgnd_int1_t1    = 'IPH AD Copay Bgn Day Intrvl 1'
	pbp_b1b_copay_ad_endd_int1_t1    = 'IPH AD Copay End Day Intrvl 1'
	pbp_b1b_copay_ad_amt_int2_t1     = 'IPH AD Copay Amt Interval 2'
	pbp_b1b_copay_ad_bgnd_int2_t1    = 'IPH AD Copay Bgn Day Intrvl 2'
	pbp_b1b_copay_ad_endd_int2_t1    = 'IPH AD Copay End Day Intrvl 2'
	pbp_b1b_copay_ad_amt_int3_t1     = 'IPH AD Copay Amt Interval 3'
	pbp_b1b_copay_ad_bgnd_int3_t1    = 'IPH AD Copay Bgn Day Intrvl 3'
	pbp_b1b_copay_ad_endd_int3_t1    = 'IPH AD Copay End Day Intrvl 3'
	pbp_b1b_copay_ad_intrvl_num_t2   = 'IPH AD Copay Interval Num'
	pbp_b1b_copay_ad_amt_int1_t2     = 'IPH AD Copay Amt Interval 1'
	pbp_b1b_copay_ad_bgnd_int1_t2    = 'IPH AD Copay Bgn Day Intrvl 1'
	pbp_b1b_copay_ad_endd_int1_t2    = 'IPH AD Copay End Day Intrvl 1'
	pbp_b1b_copay_ad_amt_int2_t2     = 'IPH AD Copay Amt Interval 2'
	pbp_b1b_copay_ad_bgnd_int2_t2    = 'IPH AD Copay Bgn Day Intrvl 2'
	pbp_b1b_copay_ad_endd_int2_t2    = 'IPH AD Copay End Day Intrvl 2'
	pbp_b1b_copay_ad_amt_int3_t2     = 'IPH AD Copay Amt Interval 3'
	pbp_b1b_copay_ad_bgnd_int3_t2    = 'IPH AD Copay Bgn Day Intrvl 3'
	pbp_b1b_copay_ad_endd_int3_t2    = 'IPH AD Copay End Day Intrvl 3'
	pbp_b1b_copay_ad_intrvl_num_t3   = 'IPH AD Copay Interval Num'
	pbp_b1b_copay_ad_amt_int1_t3     = 'IPH AD Copay Amt Interval 1'
	pbp_b1b_copay_ad_bgnd_int1_t3    = 'IPH AD Copay Bgn Day Intrvl 1'
	pbp_b1b_copay_ad_endd_int1_t3    = 'IPH AD Copay End Day Intrvl 1'
	pbp_b1b_copay_ad_amt_int2_t3     = 'IPH AD Copay Amt Interval 2'
	pbp_b1b_copay_ad_bgnd_int2_t3    = 'IPH AD Copay Bgn Day Intrvl 2'
	pbp_b1b_copay_ad_endd_int2_t3    = 'IPH AD Copay End Day Intrvl 2'
	pbp_b1b_copay_ad_amt_int3_t3     = 'IPH AD Copay Amt Interval 3'
	pbp_b1b_copay_ad_bgnd_int3_t3    = 'IPH AD Copay Bgn Day Intrvl 3'
	pbp_b1b_copay_ad_endd_int3_t3    = 'IPH AD Copay End Day Intrvl 3'
	pbp_b1b_copay_nmcs_struc_yn      = 'IPH NMCS Copay Structure YN'
	pbp_b1b_copay_nmcs_amt           = 'IPH NMCS Copay Amt'
	pbp_b1b_copay_nmcs_intrvl_num    = 'IPH NMCS Copay Interval Num'
	pbp_b1b_copay_nmcs_amt_intrvl1   = 'IPH NMCS Copay Amt Interval 1'
	pbp_b1b_copay_nmcs_bgnd_ntrvl1   = 'IPH NMCS Copay BgnDay Intrvl 1'
	pbp_b1b_copay_nmcs_endd_ntrvl1   = 'IPH NMCS Copay EndDay Intrvl 1'
	pbp_b1b_copay_nmcs_amt_intrvl2   = 'IPH NMCS Copay Amt Interval 2'
	pbp_b1b_copay_nmcs_bgnd_ntrvl2   = 'IPH NMCS Copay BgnDay Intrvl 2'
	pbp_b1b_copay_nmcs_endd_ntrvl2   = 'IPH NMCS Copay EndDay Intrvl 2'
	pbp_b1b_copay_nmcs_amt_intrvl3   = 'IPH NMCS Copay Amt Interval 3'
	pbp_b1b_copay_nmcs_bgnd_ntrvl3   = 'IPH NMCS Copay BgnDay Intrvl 3'
	pbp_b1b_copay_nmcs_endd_ntrvl3   = 'IPH NMCS Copay EndDay Intrvl 3'
	pbp_b1b_auth_yn                  = 'IPH Enrollee Auth'
	pbp_b1b_refer_yn                 = 'IPH Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step1 out=out.pbp_step1;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step1(obs = 10);
  title 'pbp_step1 file ';
run;

proc means data = out.pbp_step1;
  title 'pbp_step1 file ';
run;

proc freq data = out.pbp_step1;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_1a1_yn
	pbp_d_opt_use_mand_1a2_yn
	pbp_d_opt_use_mand_1a3_yn
	pbp_d_opt_use_mand_1b1_yn
	pbp_d_opt_use_mand_1b2_yn
	pbp_b1a_bendesc_yn
	pbp_b1a_bendesc_ad_up_nmcs
	pbp_b1a_bendesc_amo_ad
	pbp_b1a_bendesc_lim_ad
	pbp_b1a_bendesc_amo_nmcs
	pbp_b1a_bendesc_amo_up
	pbp_b1a_coins_yn
	pbp_b1a_ad_cost_vary_tiers_yn
	pbp_b1a_ad_cost_vary_tier_num
	pbp_b1a_ad_cost_vary_low_tier
	pbp_b1a_coins_ad_intrvl_num_t1
	pbp_b1a_coins_ad_intrvl_num_t2
	pbp_b1a_coins_ad_intrvl_num_t3
	pbp_b1a_coins_nmcs_struc_yn
	pbp_b1a_coins_nmcs_intrvl_num
	pbp_b1a_coins_up_cstshr_yn
	pbp_b1a_copay_yn
	pbp_b1a_copay_ad_intrvl_num_t1
	pbp_b1a_copay_ad_intrvl_num_t2
	pbp_b1a_copay_ad_intrvl_num_t3
	pbp_b1a_copay_nmcs_struc_yn
	pbp_b1a_copay_nmcs_intrvl_num
	pbp_b1a_copay_up_cstshr_yn
	pbp_b1a_auth_yn
	pbp_b1a_refer_yn
	pbp_b1b_bendesc_yn
	pbp_b1b_bendesc_ad_nmcs
	pbp_b1b_bendesc_amo_ad
	pbp_b1b_bendesc_lim_ad
	pbp_b1b_bendesc_amo_nmcs
	pbp_b1b_coins_yn
	pbp_b1b_ad_cost_vary_tiers_yn
	pbp_b1b_ad_cost_vary_tier_num
	pbp_b1b_ad_cost_vary_low_tier
	pbp_b1b_coins_ad_intrvl_num_t1
	pbp_b1b_coins_ad_intrvl_num_t2
	pbp_b1b_coins_ad_intrvl_num_t3
	pbp_b1b_coins_nmcs_struc_yn
	pbp_b1b_coins_nmcs_intrvl_num
	pbp_b1b_copay_yn
	pbp_b1b_copay_ad_intrvl_num_t1
	pbp_b1b_copay_ad_intrvl_num_t2
	pbp_b1b_copay_ad_intrvl_num_t3
	pbp_b1b_copay_nmcs_struc_yn
	pbp_b1b_copay_nmcs_intrvl_num
	pbp_b1b_auth_yn
	pbp_b1b_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step1;
  title 'pbp_step1 data';
run;