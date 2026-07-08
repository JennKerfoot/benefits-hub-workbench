*pbp_Section_C.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_Section_C;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_c_oon_yn                     $1
	pbp_c_oon_bendesc_bens           $2
	pbp_c_oon_mc_bendesc_cats        $4000
	pbp_c_oon_nmc_bendesc_cats       $4000
	pbp_c_oon_coins_ihs_yn           $1
	pbp_c_oon_coins_ihs_ben_type     $2
	pbp_c_oon_coins_iha_mc_cost_yn   $1
	pbp_c_oon_coins_iha_intrvl_num   $1
	pbp_c_oon_coins_iph_mc_cost_yn   $1
	pbp_c_oon_coins_iph_intrvl_num   $1
	pbp_c_oon_copay_ihs_yn           $1
	pbp_c_oon_copay_ihs_ben_type     $2
	pbp_c_oon_copay_iha_mc_cost_yn   $1
	pbp_c_oon_copay_iha_intrvl_num   $1
	pbp_c_oon_copay_iph_mc_cost_yn   $1
	pbp_c_oon_copay_iph_intrvl_num   $1
	pbp_c_oon_ihs_ded_yn             $1
	pbp_c_oon_ihs_ded_cost_type      $3
	pbp_c_oon_coins_snf_yn           $1
	pbp_c_oon_coins_snf_mc_cost_yn   $1
	pbp_c_oon_coins_snf_intrvl_num   $1
	pbp_c_oon_copay_snf_yn           $1
	pbp_c_oon_copay_snf_mc_cost_yn   $1
	pbp_c_oon_copay_snf_intrvl_num   $1
	pbp_c_oon_snf_ded_yn             $1
	pbp_c_pos_yn                     $1
	pbp_c_pos_bendesc_amo            $1
	pbp_c_pos_bendesc_bens           $2
	pbp_c_pos_mc_bendesc_subcats     $4000
	pbp_c_pos_nmc_bendesc_subcats    $4000
	pbp_c_pos_maxplan_yn             $1
	pbp_c_pos_maxplan_bens           $2
	pbp_c_pos_maxplan_mc_subcats     $4000
	pbp_c_pos_maxplan_nmc_subcats    $4000
	pbp_c_pos_maxplan_per            $1
	pbp_c_pos_maxplan_per_d          $4000
	pbp_c_pos_maxenr_oopc_yn         $1
	pbp_c_pos_maxenr_oopc_per        $1
	pbp_c_pos_maxenr_oopc_per_d      $4000
	pbp_c_pos_ded_yn                 $1
	pbp_c_pos_auth_yn                $1
	pbp_c_pos_auth_bens              $2
	pbp_c_pos_auth_mc_subcats        $4000
	pbp_c_pos_auth_nmc_subcats       $4000
	pbp_c_pos_referral_yn            $1
	pbp_c_pos_refer_benefit_bens     $2
	pbp_c_pos_refer_mc_subcats       $4000
	pbp_c_pos_refer_nmc_subcats      $4000
	pbp_c_pos_territories_yn         $1
	pbp_c_pos_state_limit_yn         $1
	pbp_c_pos_ihs_maxplan_yn         $1
	pbp_c_pos_ihs_maxplan_type       $3
	pbp_c_pos_ihs_maxplan_per        $1
	pbp_c_pos_ihs_maxplan_per_d      $4000
	pbp_c_pos_iha_maxplan_per        $1
	pbp_c_pos_iha_maxplan_per_d      $4000
	pbp_c_pos_ihp_maxplan_per        $1
	pbp_c_pos_ihp_maxplan_per_d      $4000
	pbp_c_pos_coins_ihs_yn           $1
	pbp_c_pos_coins_ihs_ben_type     $2
	pbp_c_pos_coins_iha_mc_cost_yn   $1
	pbp_c_pos_coins_iha_intrvl_num   $1
	pbp_c_pos_coins_iph_mc_cost_yn   $1
	pbp_c_pos_coins_iph_intrvl_num   $1
	pbp_c_pos_copay_ihs_yn           $1
	pbp_c_pos_copay_ihs_ben_type     $2
	pbp_c_pos_copay_iha_mc_cost_yn   $1
	pbp_c_pos_copay_iha_intrvl_num   $1
	pbp_c_pos_copay_iph_mc_cost_yn   $1
	pbp_c_pos_copay_iph_intrvl_num   $1
	pbp_c_pos_ihs_ded_yn             $1
	pbp_c_pos_ihs_ded_type           $3
	pbp_c_pos_coins_snf_yn           $1
	pbp_c_pos_coins_snf_mc_cost_yn   $1
	pbp_c_pos_coins_snf_intrvl_num   $1
	pbp_c_pos_copay_snf_yn           $1
	pbp_c_pos_copay_snf_mc_cost_yn   $1
	pbp_c_pos_copay_snf_intrvl_num   $1
	pbp_c_pos_snf_ded_yn             $1
	pbp_c_vt_us_yn                   $1
	pbp_c_vt_us_mo                   $1
	pbp_c_vt_geographic_area         $1
;

infile '.\pbp\pbp_Section_C.txt' delimiter = '09'x
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
	pbp_c_oon_yn
	pbp_c_oon_bendesc_bens
	pbp_c_oon_mc_bendesc_cats
	pbp_c_oon_nmc_bendesc_cats
	pbp_c_oon_coins_ihs_yn
	pbp_c_oon_coins_ihs_ben_type
	pbp_c_oon_coins_iha_mc_cost_yn
	pbp_c_oon_coins_iha_pct
	pbp_c_oon_coins_iha_intrvl_num
	pbp_c_oon_coins_iha_pct_i1
	pbp_c_oon_coins_iha_bgnd_i1
	pbp_c_oon_coins_iha_endd_i1
	pbp_c_oon_coins_iha_pct_i2
	pbp_c_oon_coins_iha_bgnd_i2
	pbp_c_oon_coins_iha_endd_i2
	pbp_c_oon_coins_iha_pct_i3
	pbp_c_oon_coins_iha_bgnd_i3
	pbp_c_oon_coins_iha_endd_i3
	pbp_c_oon_coins_iph_mc_cost_yn
	pbp_c_oon_coins_iph_pct
	pbp_c_oon_coins_iph_intrvl_num
	pbp_c_oon_coins_iph_pct_i1
	pbp_c_oon_coins_iph_bgnd_i1
	pbp_c_oon_coins_iph_endd_i1
	pbp_c_oon_coins_iph_pct_i2
	pbp_c_oon_coins_iph_bgnd_i2
	pbp_c_oon_coins_iph_endd_i2
	pbp_c_oon_coins_iph_pct_i3
	pbp_c_oon_coins_iph_bgnd_i3
	pbp_c_oon_coins_iph_endd_i3
	pbp_c_oon_copay_ihs_yn
	pbp_c_oon_copay_ihs_ben_type
	pbp_c_oon_copay_iha_mc_cost_yn
	pbp_c_oon_copay_iha_ps_amt
	pbp_c_oon_copay_iha_intrvl_num
	pbp_c_oon_copay_iha_amt_i1
	pbp_c_oon_copay_iha_bgnd_i1
	pbp_c_oon_copay_iha_endd_i1
	pbp_c_oon_copay_iha_amt_i2
	pbp_c_oon_copay_iha_bgnd_i2
	pbp_c_oon_copay_iha_endd_i2
	pbp_c_oon_copay_iha_amt_i3
	pbp_c_oon_copay_iha_bgnd_i3
	pbp_c_oon_copay_iha_endd_i3
	pbp_c_oon_copay_iph_mc_cost_yn
	pbp_c_oon_copay_iph_ps_amt
	pbp_c_oon_copay_iph_intrvl_num
	pbp_c_oon_copay_iph_amt_i1
	pbp_c_oon_copay_iph_bgnd_i1
	pbp_c_oon_copay_iph_endd_i1
	pbp_c_oon_copay_iph_amt_i2
	pbp_c_oon_copay_iph_bgnd_i2
	pbp_c_oon_copay_iph_endd_i2
	pbp_c_oon_copay_iph_amt_i3
	pbp_c_oon_copay_iph_bgnd_i3
	pbp_c_oon_copay_iph_endd_i3
	pbp_c_oon_ihs_ded_yn
	pbp_c_oon_ihs_ded_cost_type
	pbp_c_oon_ihs_ded_acu_amt
	pbp_c_oon_ihs_ded_psyc_amt
	pbp_c_oon_ihs_ded_comb_amt
	pbp_c_oon_coins_snf_yn
	pbp_c_oon_coins_snf_mc_cost_yn
	pbp_c_oon_coins_snf_pct
	pbp_c_oon_coins_snf_intrvl_num
	pbp_c_oon_coins_snf_pct_i1
	pbp_c_oon_coins_snf_bgnd_i1
	pbp_c_oon_coins_snf_endd_i1
	pbp_c_oon_coins_snf_pct_i2
	pbp_c_oon_coins_snf_bgnd_i2
	pbp_c_oon_coins_snf_endd_i2
	pbp_c_oon_coins_snf_pct_i3
	pbp_c_oon_coins_snf_bgnd_i3
	pbp_c_oon_coins_snf_endd_i3
	pbp_c_oon_copay_snf_yn
	pbp_c_oon_copay_snf_mc_cost_yn
	pbp_c_oon_copay_snf_amt
	pbp_c_oon_copay_snf_intrvl_num
	pbp_c_oon_copay_snf_amt_i1
	pbp_c_oon_copay_snf_bgnd_i1
	pbp_c_oon_copay_snf_endd_i1
	pbp_c_oon_copay_snf_amt_i2
	pbp_c_oon_copay_snf_bgnd_i2
	pbp_c_oon_copay_snf_endd_i2
	pbp_c_oon_copay_snf_amt_i3
	pbp_c_oon_copay_snf_bgnd_i3
	pbp_c_oon_copay_snf_endd_i3
	pbp_c_oon_snf_ded_yn
	pbp_c_oon_snf_ded_amt
	pbp_c_oon_outpt_group_num
	pbp_c_pos_yn
	pbp_c_pos_bendesc_amo
	pbp_c_pos_bendesc_bens
	pbp_c_pos_mc_bendesc_subcats
	pbp_c_pos_nmc_bendesc_subcats
	pbp_c_pos_maxplan_yn
	pbp_c_pos_maxplan_bens
	pbp_c_pos_maxplan_mc_subcats
	pbp_c_pos_maxplan_nmc_subcats
	pbp_c_pos_maxplan_amt
	pbp_c_pos_maxplan_per
	pbp_c_pos_maxplan_per_d
	pbp_c_pos_maxenr_oopc_yn
	pbp_c_pos_maxenr_oopc_amt
	pbp_c_pos_maxenr_oopc_per
	pbp_c_pos_maxenr_oopc_per_d
	pbp_c_pos_ded_yn
	pbp_c_pos_ded_amt
	pbp_c_pos_auth_yn
	pbp_c_pos_auth_bens
	pbp_c_pos_auth_mc_subcats
	pbp_c_pos_auth_nmc_subcats
	pbp_c_pos_referral_yn
	pbp_c_pos_refer_benefit_bens
	pbp_c_pos_refer_mc_subcats
	pbp_c_pos_refer_nmc_subcats
	pbp_c_pos_territories_yn
	pbp_c_pos_state_limit_yn
	pbp_c_pos_ihs_maxplan_yn
	pbp_c_pos_ihs_maxplan_type
	pbp_c_pos_ihs_maxplan_acu_amt
	pbp_c_pos_ihs_maxplan_psyc_amt
	pbp_c_pos_ihs_maxplan_comb_amt
	pbp_c_pos_ihs_maxplan_per
	pbp_c_pos_ihs_maxplan_per_d
	pbp_c_pos_iha_maxplan_per
	pbp_c_pos_iha_maxplan_per_d
	pbp_c_pos_ihp_maxplan_per
	pbp_c_pos_ihp_maxplan_per_d
	pbp_c_pos_coins_ihs_yn
	pbp_c_pos_coins_ihs_ben_type
	pbp_c_pos_coins_iha_mc_cost_yn
	pbp_c_pos_coins_iha_pct
	pbp_c_pos_coins_iha_intrvl_num
	pbp_c_pos_coins_iha_pct_i1
	pbp_c_pos_coins_iha_bgnd_i1
	pbp_c_pos_coins_iha_endd_i1
	pbp_c_pos_coins_iha_pct_i2
	pbp_c_pos_coins_iha_bgnd_i2
	pbp_c_pos_coins_iha_endd_i2
	pbp_c_pos_coins_iha_pct_i3
	pbp_c_pos_coins_iha_bgnd_i3
	pbp_c_pos_coins_iha_endd_i3
	pbp_c_pos_coins_iph_mc_cost_yn
	pbp_c_pos_coins_iph_pct
	pbp_c_pos_coins_iph_intrvl_num
	pbp_c_pos_coins_iph_pct_i1
	pbp_c_pos_coins_iph_bgnd_i1
	pbp_c_pos_coins_iph_endd_i1
	pbp_c_pos_coins_iph_pct_i2
	pbp_c_pos_coins_iph_bgnd_i2
	pbp_c_pos_coins_iph_endd_i2
	pbp_c_pos_coins_iph_pct_i3
	pbp_c_pos_coins_iph_bgnd_i3
	pbp_c_pos_coins_iph_endd_i3
	pbp_c_pos_copay_ihs_yn
	pbp_c_pos_copay_ihs_ben_type
	pbp_c_pos_copay_iha_mc_cost_yn
	pbp_c_pos_copay_iha_ps_amt
	pbp_c_pos_copay_iha_intrvl_num
	pbp_c_pos_copay_iha_amt_i1
	pbp_c_pos_copay_iha_bgnd_i1
	pbp_c_pos_copay_iha_endd_i1
	pbp_c_pos_copay_iha_amt_i2
	pbp_c_pos_copay_iha_bgnd_i2
	pbp_c_pos_copay_iha_endd_i2
	pbp_c_pos_copay_iha_amt_i3
	pbp_c_pos_copay_iha_bgnd_i3
	pbp_c_pos_copay_iha_endd_i3
	pbp_c_pos_copay_iph_mc_cost_yn
	pbp_c_pos_copay_iph_ps_amt
	pbp_c_pos_copay_iph_intrvl_num
	pbp_c_pos_copay_iph_amt_i1
	pbp_c_pos_copay_iph_bgnd_i1
	pbp_c_pos_copay_iph_endd_i1
	pbp_c_pos_copay_iph_amt_i2
	pbp_c_pos_copay_iph_bgnd_i2
	pbp_c_pos_copay_iph_endd_i2
	pbp_c_pos_copay_iph_amt_i3
	pbp_c_pos_copay_iph_bgnd_i3
	pbp_c_pos_copay_iph_endd_i3
	pbp_c_pos_ihs_ded_yn
	pbp_c_pos_ihs_ded_type
	pbp_c_pos_iha_ded_amt
	pbp_c_pos_iph_ded_amt
	pbp_c_pos_comb_ded_amt
	pbp_c_pos_coins_snf_yn
	pbp_c_pos_coins_snf_mc_cost_yn
	pbp_c_pos_coins_snf_pct
	pbp_c_pos_coins_snf_intrvl_num
	pbp_c_pos_coins_snf_pct_i1
	pbp_c_pos_coins_snf_bgnd_i1
	pbp_c_pos_coins_snf_endd_i1
	pbp_c_pos_coins_snf_pct_i2
	pbp_c_pos_coins_snf_bgnd_i2
	pbp_c_pos_coins_snf_endd_i2
	pbp_c_pos_coins_snf_pct_i3
	pbp_c_pos_coins_snf_bgnd_i3
	pbp_c_pos_coins_snf_endd_i3
	pbp_c_pos_copay_snf_yn
	pbp_c_pos_copay_snf_mc_cost_yn
	pbp_c_pos_copay_snf_amt
	pbp_c_pos_copay_snf_intrvl_num
	pbp_c_pos_copay_snf_amt_i1
	pbp_c_pos_copay_snf_bgnd_i1
	pbp_c_pos_copay_snf_endd_i1
	pbp_c_pos_copay_snf_amt_i2
	pbp_c_pos_copay_snf_bgnd_i2
	pbp_c_pos_copay_snf_endd_i2
	pbp_c_pos_copay_snf_amt_i3
	pbp_c_pos_copay_snf_bgnd_i3
	pbp_c_pos_copay_snf_endd_i3
	pbp_c_pos_snf_ded_yn
	pbp_c_pos_snf_ded_amt
	pbp_c_pos_outpt_group_num
	pbp_c_vt_us_yn
	pbp_c_vt_us_mo
	pbp_c_vt_geographic_area
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
	pbp_c_oon_yn                     = 'OON Benefit YN'
	pbp_c_oon_bendesc_bens           = 'OON Benefit Category Types'
	pbp_c_oon_mc_bendesc_cats        = 'OON MC Benefit Categories'
	pbp_c_oon_nmc_bendesc_cats       = 'OON Non-MC Benefit Categories'
	pbp_c_oon_coins_ihs_yn           = 'OON IHS Benefit Coinsurance YN'
	pbp_c_oon_coins_ihs_ben_type     = 'OON IHS Benefit Coins Type'
	pbp_c_oon_coins_iha_mc_cost_yn   = 'OON IHA Med Def Coins Cstsh YN'
	pbp_c_oon_coins_iha_pct          = 'OON IHA Benefit Coins Pct'
	pbp_c_oon_coins_iha_intrvl_num   = 'OON IHA Coins Interval Num'
	pbp_c_oon_coins_iha_pct_i1       = 'OON IHA Coins Pct Intrvl 1'
	pbp_c_oon_coins_iha_bgnd_i1      = 'OON IHA Coins BgnD Intrvl 1'
	pbp_c_oon_coins_iha_endd_i1      = 'OON IHA Coins EndD Intrvl 1'
	pbp_c_oon_coins_iha_pct_i2       = 'OON IHA Coins Pct Intrvl 2'
	pbp_c_oon_coins_iha_bgnd_i2      = 'OON IHA Coins BgnD Intrvl 2'
	pbp_c_oon_coins_iha_endd_i2      = 'OON IHA Coins EndD Intrvl 2'
	pbp_c_oon_coins_iha_pct_i3       = 'OON IHA Coins Pct Intrvl 3'
	pbp_c_oon_coins_iha_bgnd_i3      = 'OON IHA Coins BgnD Intrvl 3'
	pbp_c_oon_coins_iha_endd_i3      = 'OON IHA Coins EndD Intrvl 3'
	pbp_c_oon_coins_iph_mc_cost_yn   = 'OON IPH Med Def Coins Cstsh YN'
	pbp_c_oon_coins_iph_pct          = 'OON IPH Benefit Coins Pct'
	pbp_c_oon_coins_iph_intrvl_num   = 'OON IPH Coins Interval Num'
	pbp_c_oon_coins_iph_pct_i1       = 'OON IPH Coins Pct Intrvl 1'
	pbp_c_oon_coins_iph_bgnd_i1      = 'OON IPH Coins BgnD Intrvl 1'
	pbp_c_oon_coins_iph_endd_i1      = 'OON IPH Coins EndD Intrvl 1'
	pbp_c_oon_coins_iph_pct_i2       = 'OON IPH Coins Pct Intrvl 2'
	pbp_c_oon_coins_iph_bgnd_i2      = 'OON IPH Coins BgnD Intrvl 2'
	pbp_c_oon_coins_iph_endd_i2      = 'OON IPH Coins EndD Intrvl 2'
	pbp_c_oon_coins_iph_pct_i3       = 'OON IPH Coins Pct Intrvl 3'
	pbp_c_oon_coins_iph_bgnd_i3      = 'OON IPH Coins BgnD Intrvl 3'
	pbp_c_oon_coins_iph_endd_i3      = 'OON IPH Coins EndD Intrvl 3'
	pbp_c_oon_copay_ihs_yn           = 'OON IHS Copayment YN'
	pbp_c_oon_copay_ihs_ben_type     = 'OON IHS Copay Type'
	pbp_c_oon_copay_iha_mc_cost_yn   = 'OON IHA Med Def Coins Cstsh YN'
	pbp_c_oon_copay_iha_ps_amt       = 'OON IHA Benefit Copay PS Amt'
	pbp_c_oon_copay_iha_intrvl_num   = 'OON IHA Copay Interval Num'
	pbp_c_oon_copay_iha_amt_i1       = 'OON IHA Copay Amt Intrvl 1'
	pbp_c_oon_copay_iha_bgnd_i1      = 'OON IHA Copay BgnD Intrvl 1'
	pbp_c_oon_copay_iha_endd_i1      = 'OON IHA Copay EndD Intrvl 1'
	pbp_c_oon_copay_iha_amt_i2       = 'OON IHA Copay Amt Intrvl 2'
	pbp_c_oon_copay_iha_bgnd_i2      = 'OON IHA Copay BgnD Intrvl 2'
	pbp_c_oon_copay_iha_endd_i2      = 'OON IHA Copay EndD Intrvl 2'
	pbp_c_oon_copay_iha_amt_i3       = 'OON IHA Copay Amt Intrvl 3'
	pbp_c_oon_copay_iha_bgnd_i3      = 'OON IHA Copay BgnD Intrvl 3'
	pbp_c_oon_copay_iha_endd_i3      = 'OON IHA Copay EndD Intrvl 3'
	pbp_c_oon_copay_iph_mc_cost_yn   = 'OON IPH Med Def Coins Cstsh YN'
	pbp_c_oon_copay_iph_ps_amt       = 'OON IPH Benefit Copay PS Amt'
	pbp_c_oon_copay_iph_intrvl_num   = 'OON IPH Copay Interval Num'
	pbp_c_oon_copay_iph_amt_i1       = 'OON IPH Copay Amt Intrvl 1'
	pbp_c_oon_copay_iph_bgnd_i1      = 'OON IPH Copay BgnD Intrvl 1'
	pbp_c_oon_copay_iph_endd_i1      = 'OON IPH Copay EndD Intrvl 1'
	pbp_c_oon_copay_iph_amt_i2       = 'OON IPH Copay Amt Intrvl 2'
	pbp_c_oon_copay_iph_bgnd_i2      = 'OON IPH Copay BgnD Intrvl 2'
	pbp_c_oon_copay_iph_endd_i2      = 'OON IPH Copay EndD Intrvl 2'
	pbp_c_oon_copay_iph_amt_i3       = 'OON IPH Copay Amt Intrvl 3'
	pbp_c_oon_copay_iph_bgnd_i3      = 'OON IPH Copay BgnD Intrvl 3'
	pbp_c_oon_copay_iph_endd_i3      = 'OON IPH Copay EndD Intrvl 3'
	pbp_c_oon_ihs_ded_yn             = 'OON IHS Deductible YN'
	pbp_c_oon_ihs_ded_cost_type      = 'OON IHS Deductible Cost Type'
	pbp_c_oon_ihs_ded_acu_amt        = 'OON IHA Deductible Acute Amt'
	pbp_c_oon_ihs_ded_psyc_amt       = 'OON IPH Deductible Psyc Amt'
	pbp_c_oon_ihs_ded_comb_amt       = 'OON IHA IHP Deduct Combo Amt'
	pbp_c_oon_coins_snf_yn           = 'OON SNF Benefit Coinsurance YN'
	pbp_c_oon_coins_snf_mc_cost_yn   = 'OON SNF Med Def Coins Cstsh YN'
	pbp_c_oon_coins_snf_pct          = 'OON SNF Benefit Coins Pct'
	pbp_c_oon_coins_snf_intrvl_num   = 'OON SNF Coins Interval Num'
	pbp_c_oon_coins_snf_pct_i1       = 'OON SNF Coins Pct Intrvl 1'
	pbp_c_oon_coins_snf_bgnd_i1      = 'OON SNF Coins BgnD Intrvl 1'
	pbp_c_oon_coins_snf_endd_i1      = 'OON SNF Coins EndD Intrvl 1'
	pbp_c_oon_coins_snf_pct_i2       = 'OON SNF Coins Pct Intrvl 2'
	pbp_c_oon_coins_snf_bgnd_i2      = 'OON SNF Coins BgnD Intrvl 2'
	pbp_c_oon_coins_snf_endd_i2      = 'OON SNF Coins EndD Intrvl 2'
	pbp_c_oon_coins_snf_pct_i3       = 'OON SNF Coins Pct Intrvl 3'
	pbp_c_oon_coins_snf_bgnd_i3      = 'OON SNF Coins BgnD Intrvl 3'
	pbp_c_oon_coins_snf_endd_i3      = 'OON SNF Coins EndD Intrvl 3'
	pbp_c_oon_copay_snf_yn           = 'OON SNF Benefit Copayment YN'
	pbp_c_oon_copay_snf_mc_cost_yn   = 'OON SNF Medicare Cost Shares'
	pbp_c_oon_copay_snf_amt          = 'OON SNF Benefit Copay PS Amt'
	pbp_c_oon_copay_snf_intrvl_num   = 'OON SNF Copay Interval Num'
	pbp_c_oon_copay_snf_amt_i1       = 'OON SNF Copay Amt Intrvl 1'
	pbp_c_oon_copay_snf_bgnd_i1      = 'OON SNF Copay BgnD Intrvl 1'
	pbp_c_oon_copay_snf_endd_i1      = 'OON SNF Copay EndD Intrvl 1'
	pbp_c_oon_copay_snf_amt_i2       = 'OON SNF Copay Amt Intrvl 2'
	pbp_c_oon_copay_snf_bgnd_i2      = 'OON SNF Copay BgnD Intrvl 2'
	pbp_c_oon_copay_snf_endd_i2      = 'OON SNF Copay EndD Intrvl 2'
	pbp_c_oon_copay_snf_amt_i3       = 'OON SNF Copay Amt Intrvl 3'
	pbp_c_oon_copay_snf_bgnd_i3      = 'OON SNF Copay BgnD Intrvl 3'
	pbp_c_oon_copay_snf_endd_i3      = 'OON SNF Copay EndD Intrvl 3'
	pbp_c_oon_snf_ded_yn             = 'OON SNF Deductible YN'
	pbp_c_oon_snf_ded_amt            = 'OON SNF Deductible Acute Amt'
	pbp_c_oon_outpt_group_num        = 'OON Out Pt Group Num'
	pbp_c_pos_yn                     = 'POS YN'
	pbp_c_pos_bendesc_amo            = 'POS Benefit AMO'
	pbp_c_pos_bendesc_bens           = 'POS Benefit Types'
	pbp_c_pos_mc_bendesc_subcats     = 'POS Medicare-covered Category'
	pbp_c_pos_nmc_bendesc_subcats    = 'POS Non-MC Benefit Categories'
	pbp_c_pos_maxplan_yn             = 'POS Benefit Max Plan YN'
	pbp_c_pos_maxplan_bens           = 'POS Max Plan Benefit Cat Types'
	pbp_c_pos_maxplan_mc_subcats     = 'POS MC Maxplan Bene Categories'
	pbp_c_pos_maxplan_nmc_subcats    = 'POS Non-MC Ben Categories'
	pbp_c_pos_maxplan_amt            = 'POS Benefit Max Plan Amt'
	pbp_c_pos_maxplan_per            = 'POS Max Plan Combo Per'
	pbp_c_pos_maxplan_per_d          = 'POS Ben Max Plan Per Desc'
	pbp_c_pos_maxenr_oopc_yn         = 'POS Enr OOP Max YN'
	pbp_c_pos_maxenr_oopc_amt        = 'POS Enr OOP Max Amt'
	pbp_c_pos_maxenr_oopc_per        = 'POS Benefit Max Enr OOPC Per'
	pbp_c_pos_maxenr_oopc_per_d      = 'POS Ben Max Enr OOPC Per Desc'
	pbp_c_pos_ded_yn                 = 'POS Out Pt Deductible YN'
	pbp_c_pos_ded_amt                = 'POS Out Pt Deductible Amt'
	pbp_c_pos_auth_yn                = 'POS Benefit Auth Required YN'
	pbp_c_pos_auth_bens              = 'POS Auth Category Types'
	pbp_c_pos_auth_mc_subcats        = 'POS MC Covered Benefits'
	pbp_c_pos_auth_nmc_subcats       = 'POS Non-MC Benefits Categories'
	pbp_c_pos_referral_yn            = 'POS Referral Required YN'
	pbp_c_pos_refer_benefit_bens     = 'POS Referral Category Types'
	pbp_c_pos_refer_mc_subcats       = 'POS Referral MC Categories'
	pbp_c_pos_refer_nmc_subcats      = 'POS Referral Non-MC Categories'
	pbp_c_pos_territories_yn         = 'POS Territories'
	pbp_c_pos_state_limit_yn         = 'POS State-lic/cert limit'
	pbp_c_pos_ihs_maxplan_yn         = 'POS IHS MPBC YN'
	pbp_c_pos_ihs_maxplan_type       = 'POS IHS MPBC Cost Type'
	pbp_c_pos_ihs_maxplan_acu_amt    = 'POS IHA Deduct Acute Amt'
	pbp_c_pos_ihs_maxplan_psyc_amt   = 'POS IPH MPBC Psyc Amt'
	pbp_c_pos_ihs_maxplan_comb_amt   = 'POS IHA IHP Combo Amt'
	pbp_c_pos_ihs_maxplan_per        = 'POS IHS Max Plan Per'
	pbp_c_pos_ihs_maxplan_per_d      = 'POS IHS Max Plan Per Desc'
	pbp_c_pos_iha_maxplan_per        = 'POS Max Plan 1a Per'
	pbp_c_pos_iha_maxplan_per_d      = 'POS Ben Max Plan Per 1a Desc'
	pbp_c_pos_ihp_maxplan_per        = 'POS IPH Max Plan 1b Per'
	pbp_c_pos_ihp_maxplan_per_d      = 'POS IPH Ben Max Plan Per Desc'
	pbp_c_pos_coins_ihs_yn           = 'POS IHS Coinsurance YN'
	pbp_c_pos_coins_ihs_ben_type     = 'POS IHS Coins Type'
	pbp_c_pos_coins_iha_mc_cost_yn   = 'POS IHA Med Def Coins Cstsh YN'
	pbp_c_pos_coins_iha_pct          = 'POS IHA Benefit Coins Pct'
	pbp_c_pos_coins_iha_intrvl_num   = 'POS IHA Coins Interval Num'
	pbp_c_pos_coins_iha_pct_i1       = 'POS IHA Coins Pct Intrvl 1'
	pbp_c_pos_coins_iha_bgnd_i1      = 'POS IHA Coins BgnD Intrvl 1'
	pbp_c_pos_coins_iha_endd_i1      = 'POS IHA Coins EndD Intrvl 1'
	pbp_c_pos_coins_iha_pct_i2       = 'POS IHA Coins Pct Intrvl 2'
	pbp_c_pos_coins_iha_bgnd_i2      = 'POS IHA Coins BgnD Intrvl 2'
	pbp_c_pos_coins_iha_endd_i2      = 'POS IHA Coins EndD Intrvl 2'
	pbp_c_pos_coins_iha_pct_i3       = 'POS IHA Coins Pct Intrvl 3'
	pbp_c_pos_coins_iha_bgnd_i3      = 'POS IHA Coins BgnD Intrvl 3'
	pbp_c_pos_coins_iha_endd_i3      = 'POS IHA Coins EndD Intrvl 3'
	pbp_c_pos_coins_iph_mc_cost_yn   = 'POS IPH Med Def Coins Cstsh YN'
	pbp_c_pos_coins_iph_pct          = 'POS IPH Coins Pct'
	pbp_c_pos_coins_iph_intrvl_num   = 'POS IPH Coins Interval Num'
	pbp_c_pos_coins_iph_pct_i1       = 'POS IPH Coins Pct Intrvl 1'
	pbp_c_pos_coins_iph_bgnd_i1      = 'POS IPH Coins BgnD Intrvl 1'
	pbp_c_pos_coins_iph_endd_i1      = 'POS IPH Coins EndD Intrvl 1'
	pbp_c_pos_coins_iph_pct_i2       = 'POS IPH Coins Pct Intrvl 2'
	pbp_c_pos_coins_iph_bgnd_i2      = 'POS IPH Coins BgnD Intrvl 2'
	pbp_c_pos_coins_iph_endd_i2      = 'POS IPH Coins EndD Intrvl 2'
	pbp_c_pos_coins_iph_pct_i3       = 'POS IPH Coins Pct Intrvl 3'
	pbp_c_pos_coins_iph_bgnd_i3      = 'POS IPH Coins BgnD Intrvl 3'
	pbp_c_pos_coins_iph_endd_i3      = 'POS IPH Coins EndD Intrvl 3'
	pbp_c_pos_copay_ihs_yn           = 'POS IHA Copayment YN'
	pbp_c_pos_copay_ihs_ben_type     = 'POS IHS Copay Type'
	pbp_c_pos_copay_iha_mc_cost_yn   = 'POS IHA Med Def Coins Cstsh YN'
	pbp_c_pos_copay_iha_ps_amt       = 'POS IHA Copay PS Amt'
	pbp_c_pos_copay_iha_intrvl_num   = 'POS IHA Copay Interval Num'
	pbp_c_pos_copay_iha_amt_i1       = 'POS IHA Copay Amt Intrvl 1'
	pbp_c_pos_copay_iha_bgnd_i1      = 'POS IHA Copay BgnD Intrvl 1'
	pbp_c_pos_copay_iha_endd_i1      = 'POS IHA Copay EndD Intrvl 1'
	pbp_c_pos_copay_iha_amt_i2       = 'POS IHA Copay Amt Intrvl 2'
	pbp_c_pos_copay_iha_bgnd_i2      = 'POS IHA Copay BgnD Intrvl 2'
	pbp_c_pos_copay_iha_endd_i2      = 'POS IHA Copay EndD Intrvl 2'
	pbp_c_pos_copay_iha_amt_i3       = 'POS IHA Copay Amt Intrvl 3'
	pbp_c_pos_copay_iha_bgnd_i3      = 'POS IHA Copay BgnD Intrvl 3'
	pbp_c_pos_copay_iha_endd_i3      = 'POS IHA Copay EndD Intrvl 3'
	pbp_c_pos_copay_iph_mc_cost_yn   = 'POS IPH Med Def Coins Cstsh YN'
	pbp_c_pos_copay_iph_ps_amt       = 'POS IPH Copay PS Amt'
	pbp_c_pos_copay_iph_intrvl_num   = 'POS IPH Copay Interval Num'
	pbp_c_pos_copay_iph_amt_i1       = 'POS IPH Copay Amt Intrvl 1'
	pbp_c_pos_copay_iph_bgnd_i1      = 'POS IPH Copay BgnD Intrvl 1'
	pbp_c_pos_copay_iph_endd_i1      = 'POS IPH Copay EndD Intrvl 1'
	pbp_c_pos_copay_iph_amt_i2       = 'POS IPH Copay Amt Intrvl 2'
	pbp_c_pos_copay_iph_bgnd_i2      = 'POS IPH Copay BgnD Intrvl 2'
	pbp_c_pos_copay_iph_endd_i2      = 'POS IPH Copay EndD Intrvl 2'
	pbp_c_pos_copay_iph_amt_i3       = 'POS IPH Copay Amt Intrvl 3'
	pbp_c_pos_copay_iph_bgnd_i3      = 'POS IPH Copay BgnD Intrvl 3'
	pbp_c_pos_copay_iph_endd_i3      = 'POS IPH Copay EndD Intrvl 3'
	pbp_c_pos_ihs_ded_yn             = 'POS IHS Deductible YN'
	pbp_c_pos_ihs_ded_type           = 'POS IHS Deductible Cost Type'
	pbp_c_pos_iha_ded_amt            = 'POS IHA Deductible Acute Amt'
	pbp_c_pos_iph_ded_amt            = 'POS IPH Deductible Psyc Amt'
	pbp_c_pos_comb_ded_amt           = 'POS IHA IHP Deduct Combo Amt'
	pbp_c_pos_coins_snf_yn           = 'POS SNF Coinsurance YN'
	pbp_c_pos_coins_snf_mc_cost_yn   = 'POS SNF Med Def Coins Cstsh YN'
	pbp_c_pos_coins_snf_pct          = 'POS SNF Coins Pct'
	pbp_c_pos_coins_snf_intrvl_num   = 'POS SNF Coins Interval Num'
	pbp_c_pos_coins_snf_pct_i1       = 'POS SNF Coins Pct Intrvl 1'
	pbp_c_pos_coins_snf_bgnd_i1      = 'POS SNF Coins BgnD Intrvl 1'
	pbp_c_pos_coins_snf_endd_i1      = 'POS SNF Coins EndD Intrvl 1'
	pbp_c_pos_coins_snf_pct_i2       = 'POS SNF Coins Pct Intrvl 2'
	pbp_c_pos_coins_snf_bgnd_i2      = 'POS SNF Coins BgnD Intrvl 2'
	pbp_c_pos_coins_snf_endd_i2      = 'POS SNF Coins EndD Intrvl 2'
	pbp_c_pos_coins_snf_pct_i3       = 'POS SNF Coins Pct Intrvl 3'
	pbp_c_pos_coins_snf_bgnd_i3      = 'POS SNF Coins BgnD Intrvl 3'
	pbp_c_pos_coins_snf_endd_i3      = 'POS SNF Coins EndD Intrvl 3'
	pbp_c_pos_copay_snf_yn           = 'POS SNF Copayment YN'
	pbp_c_pos_copay_snf_mc_cost_yn   = 'POS SNF Medicare Cost Shares'
	pbp_c_pos_copay_snf_amt          = 'POS SNF Copay PS Amt'
	pbp_c_pos_copay_snf_intrvl_num   = 'POS SNF Copay Interval Num'
	pbp_c_pos_copay_snf_amt_i1       = 'POS SNF Copay Amt Intrvl 1'
	pbp_c_pos_copay_snf_bgnd_i1      = 'POS SNF Copay BgnD Intrvl 1'
	pbp_c_pos_copay_snf_endd_i1      = 'POS SNF Copay EndD Intrvl 1'
	pbp_c_pos_copay_snf_amt_i2       = 'POS SNF Copay Amt Intrvl 2'
	pbp_c_pos_copay_snf_bgnd_i2      = 'POS SNF Copay BgnD Intrvl 2'
	pbp_c_pos_copay_snf_endd_i2      = 'POS SNF Copay EndD Intrvl 2'
	pbp_c_pos_copay_snf_amt_i3       = 'POS SNF Copay Amt Intrvl 3'
	pbp_c_pos_copay_snf_bgnd_i3      = 'POS SNF Copay BgnD Intrvl 3'
	pbp_c_pos_copay_snf_endd_i3      = 'POS SNF Copay EndD Intrvl 3'
	pbp_c_pos_snf_ded_yn             = 'POS SNF Deductible YN'
	pbp_c_pos_snf_ded_amt            = 'POS SNF Deductible Acute Amt'
	pbp_c_pos_outpt_group_num        = 'POS Out Pt Group Num'
	pbp_c_vt_us_yn                   = 'V/T US YN'
	pbp_c_vt_us_mo                   = 'V/T US Benefit MO'
	pbp_c_vt_geographic_area         = 'V/T Geograph Area'
;

run;

proc sort data = pbp_Section_C out=out.pbp_Section_C;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_Section_C(obs = 10);
  title 'pbp_Section_C file ';
run;

proc means data = out.pbp_Section_C;
  title 'pbp_Section_C file ';
run;

proc freq data = out.pbp_Section_C;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_c_oon_yn
	pbp_c_oon_bendesc_bens
	pbp_c_oon_coins_ihs_yn
	pbp_c_oon_coins_ihs_ben_type
	pbp_c_oon_coins_iha_mc_cost_yn
	pbp_c_oon_coins_iha_intrvl_num
	pbp_c_oon_coins_iph_mc_cost_yn
	pbp_c_oon_coins_iph_intrvl_num
	pbp_c_oon_copay_ihs_yn
	pbp_c_oon_copay_ihs_ben_type
	pbp_c_oon_copay_iha_mc_cost_yn
	pbp_c_oon_copay_iha_intrvl_num
	pbp_c_oon_copay_iph_mc_cost_yn
	pbp_c_oon_copay_iph_intrvl_num
	pbp_c_oon_ihs_ded_yn
	pbp_c_oon_ihs_ded_cost_type
	pbp_c_oon_coins_snf_yn
	pbp_c_oon_coins_snf_mc_cost_yn
	pbp_c_oon_coins_snf_intrvl_num
	pbp_c_oon_copay_snf_yn
	pbp_c_oon_copay_snf_mc_cost_yn
	pbp_c_oon_copay_snf_intrvl_num
	pbp_c_oon_snf_ded_yn
	pbp_c_pos_yn
	pbp_c_pos_bendesc_amo
	pbp_c_pos_bendesc_bens
	pbp_c_pos_maxplan_yn
	pbp_c_pos_maxplan_bens
	pbp_c_pos_maxplan_per
	pbp_c_pos_maxenr_oopc_yn
	pbp_c_pos_maxenr_oopc_per
	pbp_c_pos_ded_yn
	pbp_c_pos_auth_yn
	pbp_c_pos_auth_bens
	pbp_c_pos_referral_yn
	pbp_c_pos_refer_benefit_bens
	pbp_c_pos_territories_yn
	pbp_c_pos_state_limit_yn
	pbp_c_pos_ihs_maxplan_yn
	pbp_c_pos_ihs_maxplan_type
	pbp_c_pos_ihs_maxplan_per
	pbp_c_pos_iha_maxplan_per
	pbp_c_pos_ihp_maxplan_per
	pbp_c_pos_coins_ihs_yn
	pbp_c_pos_coins_ihs_ben_type
	pbp_c_pos_coins_iha_mc_cost_yn
	pbp_c_pos_coins_iha_intrvl_num
	pbp_c_pos_coins_iph_mc_cost_yn
	pbp_c_pos_coins_iph_intrvl_num
	pbp_c_pos_copay_ihs_yn
	pbp_c_pos_copay_ihs_ben_type
	pbp_c_pos_copay_iha_mc_cost_yn
	pbp_c_pos_copay_iha_intrvl_num
	pbp_c_pos_copay_iph_mc_cost_yn
	pbp_c_pos_copay_iph_intrvl_num
	pbp_c_pos_ihs_ded_yn
	pbp_c_pos_ihs_ded_type
	pbp_c_pos_coins_snf_yn
	pbp_c_pos_coins_snf_mc_cost_yn
	pbp_c_pos_coins_snf_intrvl_num
	pbp_c_pos_copay_snf_yn
	pbp_c_pos_copay_snf_mc_cost_yn
	pbp_c_pos_copay_snf_intrvl_num
	pbp_c_pos_snf_ded_yn
	pbp_c_vt_us_yn
	pbp_c_vt_us_mo
	pbp_c_vt_geographic_area
/ missing;
run;

proc contents data = out.pbp_Section_C;
  title 'pbp_Section_C data';
run;