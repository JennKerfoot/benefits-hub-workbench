*pbp_b13i_b19b_services_vbid_ssbci.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b13i_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b13i_bendesc                 $10
	pbp_b13i_fd_bendesc_yn           $1
	pbp_b13i_fd_bendesc_amo          $1
	pbp_b13i_fd_maxplan_yn           $1
	pbp_b13i_fd_maxplan_per          $1
	pbp_b13i_fd_maxplan_per_d        $4000
	pbp_b13i_fd_maxenr_yn            $1
	pbp_b13i_fd_maxenr_per           $1
	pbp_b13i_fd_maxenr_per_d         $4000
	pbp_b13i_fd_coins_yn             $1
	pbp_b13i_fd_ded_yn               $1
	pbp_b13i_fd_copay_yn             $1
	pbp_b13i_fd_auth_yn              $1
	pbp_b13i_fd_refer_yn             $1
	pbp_b13i_ml_bendesc_service      $1
	pbp_b13i_ml_bendesc_amo          $1
	pbp_b13i_ml_unlimited_yn         $1
	pbp_b13i_ml_maxplan_yn           $1
	pbp_b13i_ml_maxplan_per          $1
	pbp_b13i_ml_maxplan_per_d        $4000
	pbp_b13i_ml_maxenr_yn            $1
	pbp_b13i_ml_maxenr_per           $1
	pbp_b13i_ml_maxenr_per_d         $4000
	pbp_b13i_ml_coins_yn             $1
	pbp_b13i_ml_ded_yn               $1
	pbp_b13i_ml_copay_yn             $1
	pbp_b13i_ml_auth_yn              $1
	pbp_b13i_ml_refer_yn             $1
	pbp_b13i_ps_bendesc_yn           $1
	pbp_b13i_ps_bendesc_amo          $1
	pbp_b13i_ps_maxplan_yn           $1
	pbp_b13i_ps_maxplan_per          $1
	pbp_b13i_ps_maxplan_per_d        $4000
	pbp_b13i_ps_maxenr_yn            $1
	pbp_b13i_ps_maxenr_per           $1
	pbp_b13i_ps_maxenr_per_d         $4000
	pbp_b13i_ps_coins_yn             $1
	pbp_b13i_ps_ded_yn               $1
	pbp_b13i_ps_copay_yn             $1
	pbp_b13i_ps_auth_yn              $1
	pbp_b13i_ps_refer_yn             $1
	pbp_b13i_t_bendesc_yn            $1
	pbp_b13i_t_bendesc_trn           $1
	pbp_b13i_t_bendesc_amo_pal       $1
	pbp_b13i_t_bendesc_lim_pal       $1
	pbp_b13i_t_bendesc_per_pal       $1
	pbp_b13i_t_bendesc_per_pal_d     $4000
	pbp_b13i_t_bendesc_tt_pal        $1
	pbp_b13i_t_bendesc_tt_pal_d      $4000
	pbp_b13i_t_bendesc_mt_pal        $6
	pbp_b13i_t_bendesc_mt_pal_d      $4000
	pbp_b13i_t_bendesc_amo_al        $1
	pbp_b13i_t_bendesc_lim_al        $1
	pbp_b13i_t_bendesc_per_al        $1
	pbp_b13i_t_bendesc_per_al_d      $4000
	pbp_b13i_t_bendesc_tt_al         $1
	pbp_b13i_t_bendesc_tt_al_d       $4000
	pbp_b13i_t_bendesc_mt_al         $6
	pbp_b13i_t_bendesc_mt_al_d       $4000
	pbp_b13i_t_maxplan_yn            $1
	pbp_b13i_t_maxplan_per           $1
	pbp_b13i_t_maxplan_per_d         $4000
	pbp_b13i_t_maxenr_yn             $1
	pbp_b13i_t_maxenr_per            $1
	pbp_b13i_t_maxenr_per_d          $4000
	pbp_b13i_t_coins_yn              $1
	pbp_b13i_t_ded_yn                $1
	pbp_b13i_t_copay_yn              $1
	pbp_b13i_t_auth_yn               $1
	pbp_b13i_t_refer_yn              $1
	pbp_b13i_air_bendesc_yn          $1
	pbp_b13i_air_bendesc_amo         $1
	pbp_b13i_air_maxplan_yn          $1
	pbp_b13i_air_maxplan_per         $1
	pbp_b13i_air_maxplan_per_d       $4000
	pbp_b13i_air_maxenr_yn           $1
	pbp_b13i_air_maxenr_per          $1
	pbp_b13i_air_maxenr_per_d        $4000
	pbp_b13i_air_coins_yn            $1
	pbp_b13i_air_ded_yn              $1
	pbp_b13i_air_copay_yn            $1
	pbp_b13i_air_auth_yn             $1
	pbp_b13i_air_refer_yn            $1
	pbp_b13i_socn_bendesc_yn         $1
	pbp_b13i_socn_bendesc_amo        $1
	pbp_b13i_socn_maxplan_yn         $1
	pbp_b13i_socn_maxplan_per        $1
	pbp_b13i_socn_maxplan_per_d      $4000
	pbp_b13i_socn_maxenr_yn          $1
	pbp_b13i_socn_maxenr_per         $1
	pbp_b13i_socn_maxenr_per_d       $4000
	pbp_b13i_socn_coins_yn           $1
	pbp_b13i_socn_ded_yn             $1
	pbp_b13i_socn_copay_yn           $1
	pbp_b13i_socn_auth_yn            $1
	pbp_b13i_socn_refer_yn           $1
	pbp_b13i_cmptx_bendesc_yn        $1
	pbp_b13i_cmptx_bendesc_amo       $1
	pbp_b13i_cmptx_maxplan_yn        $1
	pbp_b13i_cmptx_maxplan_per       $1
	pbp_b13i_cmptx_maxplan_per_d     $4000
	pbp_b13i_cmptx_maxenr_yn         $1
	pbp_b13i_cmptx_maxenr_per        $1
	pbp_b13i_cmptx_maxenr_per_d      $4000
	pbp_b13i_cmptx_coins_yn          $1
	pbp_b13i_cmptx_ded_yn            $1
	pbp_b13i_cmptx_copay_yn          $1
	pbp_b13i_cmptx_auth_yn           $1
	pbp_b13i_cmptx_refer_yn          $1
	pbp_b13i_selfd_bendesc_yn        $1
	pbp_b13i_selfd_bendesc_amo       $1
	pbp_b13i_selfd_maxplan_yn        $1
	pbp_b13i_selfd_maxplan_per       $1
	pbp_b13i_selfd_maxplan_per_d     $4000
	pbp_b13i_selfd_maxenr_yn         $1
	pbp_b13i_selfd_maxenr_per        $1
	pbp_b13i_selfd_maxenr_per_d      $4000
	pbp_b13i_selfd_coins_yn          $1
	pbp_b13i_selfd_ded_yn            $1
	pbp_b13i_selfd_copay_yn          $1
	pbp_b13i_selfd_auth_yn           $1
	pbp_b13i_selfd_refer_yn          $1
	pbp_b13i_home_bendesc_yn         $1
	pbp_b13i_home_bendesc_amo        $1
	pbp_b13i_home_maxplan_yn         $1
	pbp_b13i_home_maxplan_per        $1
	pbp_b13i_home_maxplan_per_d      $4000
	pbp_b13i_home_maxenr_yn          $1
	pbp_b13i_home_maxenr_per         $1
	pbp_b13i_home_maxenr_per_d       $4000
	pbp_b13i_home_coins_yn           $1
	pbp_b13i_home_ded_yn             $1
	pbp_b13i_home_copay_yn           $1
	pbp_b13i_home_auth_yn            $1
	pbp_b13i_home_refer_yn           $1
	pbp_b13i_suppt_bendesc_yn        $1
	pbp_b13i_suppt_bendesc_amo       $1
	pbp_b13i_suppt_maxplan_yn        $1
	pbp_b13i_suppt_maxplan_per       $1
	pbp_b13i_suppt_maxplan_per_d     $4000
	pbp_b13i_suppt_maxenr_yn         $1
	pbp_b13i_suppt_maxenr_per        $1
	pbp_b13i_suppt_maxenr_per_d      $4000
	pbp_b13i_suppt_coins_yn          $1
	pbp_b13i_suppt_ded_yn            $1
	pbp_b13i_suppt_copay_yn          $1
	pbp_b13i_suppt_housing_yn        $1
	pbp_b13i_suppt_utility_yn        $1
	pbp_b13i_suppt_auth_yn           $1
	pbp_b13i_suppt_refer_yn          $1
;

infile '.\pbp\pbp_b13i_b19b_services_vbid_ssbci.txt' delimiter = '09'x
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
	pbp_b13i_bendesc
	pbp_b13i_fd_bendesc_yn
	pbp_b13i_fd_bendesc_amo
	pbp_b13i_fd_maxplan_yn
	pbp_b13i_fd_maxplan_amt
	pbp_b13i_fd_maxplan_per
	pbp_b13i_fd_maxplan_per_d
	pbp_b13i_fd_maxenr_yn
	pbp_b13i_fd_maxenr_amt
	pbp_b13i_fd_maxenr_per
	pbp_b13i_fd_maxenr_per_d
	pbp_b13i_fd_coins_yn
	pbp_b13i_fd_coins_pct_min
	pbp_b13i_fd_coins_pct_max
	pbp_b13i_fd_ded_yn
	pbp_b13i_fd_ded_amt
	pbp_b13i_fd_copay_yn
	pbp_b13i_fd_copay_amt_min
	pbp_b13i_fd_copay_amt_max
	pbp_b13i_fd_auth_yn
	pbp_b13i_fd_refer_yn
	pbp_b13i_ml_bendesc_service
	pbp_b13i_ml_bendesc_amo
	pbp_b13i_ml_unlimited_yn
	pbp_b13i_ml_maxplan_yn
	pbp_b13i_ml_maxplan_amt
	pbp_b13i_ml_maxplan_per
	pbp_b13i_ml_maxplan_per_d
	pbp_b13i_ml_maxenr_yn
	pbp_b13i_ml_maxenr_amt
	pbp_b13i_ml_maxenr_per
	pbp_b13i_ml_maxenr_per_d
	pbp_b13i_ml_coins_yn
	pbp_b13i_ml_coins_pct_min
	pbp_b13i_ml_coins_pct_max
	pbp_b13i_ml_ded_yn
	pbp_b13i_ml_ded_amt
	pbp_b13i_ml_copay_yn
	pbp_b13i_ml_copay_amt_min
	pbp_b13i_ml_copay_amt_max
	pbp_b13i_ml_auth_yn
	pbp_b13i_ml_refer_yn
	pbp_b13i_ps_bendesc_yn
	pbp_b13i_ps_bendesc_amo
	pbp_b13i_ps_maxplan_yn
	pbp_b13i_ps_maxplan_amt
	pbp_b13i_ps_maxplan_per
	pbp_b13i_ps_maxplan_per_d
	pbp_b13i_ps_maxenr_yn
	pbp_b13i_ps_maxenr_amt
	pbp_b13i_ps_maxenr_per
	pbp_b13i_ps_maxenr_per_d
	pbp_b13i_ps_coins_yn
	pbp_b13i_ps_coins_pct_min
	pbp_b13i_ps_coins_pct_max
	pbp_b13i_ps_ded_yn
	pbp_b13i_ps_ded_amt
	pbp_b13i_ps_copay_yn
	pbp_b13i_ps_copay_amt_min
	pbp_b13i_ps_copay_amt_max
	pbp_b13i_ps_auth_yn
	pbp_b13i_ps_refer_yn
	pbp_b13i_t_bendesc_yn
	pbp_b13i_t_bendesc_trn
	pbp_b13i_t_bendesc_amo_pal
	pbp_b13i_t_bendesc_lim_pal
	pbp_b13i_t_bendesc_amt_pal
	pbp_b13i_t_bendesc_per_pal
	pbp_b13i_t_bendesc_per_pal_d
	pbp_b13i_t_bendesc_tt_pal
	pbp_b13i_t_bendesc_tt_pal_d
	pbp_b13i_t_bendesc_amt_pal_day
	pbp_b13i_t_bendesc_mt_pal
	pbp_b13i_t_bendesc_mt_pal_d
	pbp_b13i_t_bendesc_amo_al
	pbp_b13i_t_bendesc_lim_al
	pbp_b13i_t_bendesc_amt_al
	pbp_b13i_t_bendesc_per_al
	pbp_b13i_t_bendesc_per_al_d
	pbp_b13i_t_bendesc_tt_al
	pbp_b13i_t_bendesc_tt_al_d
	pbp_b13i_t_bendesc_amt_al_days
	pbp_b13i_t_bendesc_mt_al
	pbp_b13i_t_bendesc_mt_al_d
	pbp_b13i_t_maxplan_yn
	pbp_b13i_t_maxplan_amt
	pbp_b13i_t_maxplan_per
	pbp_b13i_t_maxplan_per_d
	pbp_b13i_t_maxenr_yn
	pbp_b13i_t_maxenr_amt
	pbp_b13i_t_maxenr_per
	pbp_b13i_t_maxenr_per_d
	pbp_b13i_t_coins_yn
	pbp_b13i_t_coins_pct_min
	pbp_b13i_t_coins_pct_max
	pbp_b13i_t_ded_yn
	pbp_b13i_t_ded_amt
	pbp_b13i_t_copay_yn
	pbp_b13i_t_copay_amt_min
	pbp_b13i_t_copay_amt_max
	pbp_b13i_t_auth_yn
	pbp_b13i_t_refer_yn
	pbp_b13i_air_bendesc_yn
	pbp_b13i_air_bendesc_amo
	pbp_b13i_air_maxplan_yn
	pbp_b13i_air_maxplan_amt
	pbp_b13i_air_maxplan_per
	pbp_b13i_air_maxplan_per_d
	pbp_b13i_air_maxenr_yn
	pbp_b13i_air_maxenr_amt
	pbp_b13i_air_maxenr_per
	pbp_b13i_air_maxenr_per_d
	pbp_b13i_air_coins_yn
	pbp_b13i_air_coins_pct_min
	pbp_b13i_air_coins_pct_max
	pbp_b13i_air_ded_yn
	pbp_b13i_air_ded_amt
	pbp_b13i_air_copay_yn
	pbp_b13i_air_copay_amt_min
	pbp_b13i_air_copay_amt_max
	pbp_b13i_air_auth_yn
	pbp_b13i_air_refer_yn
	pbp_b13i_socn_bendesc_yn
	pbp_b13i_socn_bendesc_amo
	pbp_b13i_socn_maxplan_yn
	pbp_b13i_socn_maxplan_amt
	pbp_b13i_socn_maxplan_per
	pbp_b13i_socn_maxplan_per_d
	pbp_b13i_socn_maxenr_yn
	pbp_b13i_socn_maxenr_amt
	pbp_b13i_socn_maxenr_per
	pbp_b13i_socn_maxenr_per_d
	pbp_b13i_socn_coins_yn
	pbp_b13i_socn_coins_pct_min
	pbp_b13i_socn_coins_pct_max
	pbp_b13i_socn_ded_yn
	pbp_b13i_socn_ded_amt
	pbp_b13i_socn_copay_yn
	pbp_b13i_socn_copay_amt_min
	pbp_b13i_socn_copay_amt_max
	pbp_b13i_socn_auth_yn
	pbp_b13i_socn_refer_yn
	pbp_b13i_cmptx_bendesc_yn
	pbp_b13i_cmptx_bendesc_amo
	pbp_b13i_cmptx_maxplan_yn
	pbp_b13i_cmptx_maxplan_amt
	pbp_b13i_cmptx_maxplan_per
	pbp_b13i_cmptx_maxplan_per_d
	pbp_b13i_cmptx_maxenr_yn
	pbp_b13i_cmptx_maxenr_amt
	pbp_b13i_cmptx_maxenr_per
	pbp_b13i_cmptx_maxenr_per_d
	pbp_b13i_cmptx_coins_yn
	pbp_b13i_cmptx_coins_pct_min
	pbp_b13i_cmptx_coins_pct_max
	pbp_b13i_cmptx_ded_yn
	pbp_b13i_cmptx_ded_amt
	pbp_b13i_cmptx_copay_yn
	pbp_b13i_cmptx_copay_amt_min
	pbp_b13i_cmptx_copay_amt_max
	pbp_b13i_cmptx_auth_yn
	pbp_b13i_cmptx_refer_yn
	pbp_b13i_selfd_bendesc_yn
	pbp_b13i_selfd_bendesc_amo
	pbp_b13i_selfd_maxplan_yn
	pbp_b13i_selfd_maxplan_amt
	pbp_b13i_selfd_maxplan_per
	pbp_b13i_selfd_maxplan_per_d
	pbp_b13i_selfd_maxenr_yn
	pbp_b13i_selfd_maxenr_amt
	pbp_b13i_selfd_maxenr_per
	pbp_b13i_selfd_maxenr_per_d
	pbp_b13i_selfd_coins_yn
	pbp_b13i_selfd_coins_pct_min
	pbp_b13i_selfd_coins_pct_max
	pbp_b13i_selfd_ded_yn
	pbp_b13i_selfd_ded_amt
	pbp_b13i_selfd_copay_yn
	pbp_b13i_selfd_copay_amt_min
	pbp_b13i_selfd_copay_amt_max
	pbp_b13i_selfd_auth_yn
	pbp_b13i_selfd_refer_yn
	pbp_b13i_home_bendesc_yn
	pbp_b13i_home_bendesc_amo
	pbp_b13i_home_maxplan_yn
	pbp_b13i_home_maxplan_amt
	pbp_b13i_home_maxplan_per
	pbp_b13i_home_maxplan_per_d
	pbp_b13i_home_maxenr_yn
	pbp_b13i_home_maxenr_amt
	pbp_b13i_home_maxenr_per
	pbp_b13i_home_maxenr_per_d
	pbp_b13i_home_coins_yn
	pbp_b13i_home_coins_pct_min
	pbp_b13i_home_coins_pct_max
	pbp_b13i_home_ded_yn
	pbp_b13i_home_ded_amt
	pbp_b13i_home_copay_yn
	pbp_b13i_home_copay_amt_min
	pbp_b13i_home_copay_amt_max
	pbp_b13i_home_auth_yn
	pbp_b13i_home_refer_yn
	pbp_b13i_suppt_bendesc_yn
	pbp_b13i_suppt_bendesc_amo
	pbp_b13i_suppt_maxplan_yn
	pbp_b13i_suppt_maxplan_amt
	pbp_b13i_suppt_maxplan_per
	pbp_b13i_suppt_maxplan_per_d
	pbp_b13i_suppt_maxenr_yn
	pbp_b13i_suppt_maxenr_amt
	pbp_b13i_suppt_maxenr_per
	pbp_b13i_suppt_maxenr_per_d
	pbp_b13i_suppt_coins_yn
	pbp_b13i_suppt_coins_pct_min
	pbp_b13i_suppt_coins_pct_max
	pbp_b13i_suppt_ded_yn
	pbp_b13i_suppt_ded_amt
	pbp_b13i_suppt_copay_yn
	pbp_b13i_suppt_copay_amt_min
	pbp_b13i_suppt_copay_amt_max
	pbp_b13i_suppt_housing_yn
	pbp_b13i_suppt_utility_yn
	pbp_b13i_suppt_auth_yn
	pbp_b13i_suppt_refer_yn
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
	pbp_b13i_bendesc                 = '13I Non-Health type'
	pbp_b13i_fd_bendesc_yn           = 'Food and Produce'
	pbp_b13i_fd_bendesc_amo          = 'Food Ben Desc MO'
	pbp_b13i_fd_maxplan_yn           = 'Food Max Plan YN'
	pbp_b13i_fd_maxplan_amt          = 'Food Max Plan Amt'
	pbp_b13i_fd_maxplan_per          = 'Food Max Plan Per'
	pbp_b13i_fd_maxplan_per_d        = 'Food Max Plan Per Desc'
	pbp_b13i_fd_maxenr_yn            = 'Food Max Enr YN'
	pbp_b13i_fd_maxenr_amt           = 'Food Max Enr Amt'
	pbp_b13i_fd_maxenr_per           = 'Food Max Enr Per'
	pbp_b13i_fd_maxenr_per_d         = 'Food Max Enr Per Desc'
	pbp_b13i_fd_coins_yn             = 'Food Coinsurance YN'
	pbp_b13i_fd_coins_pct_min        = 'Food Min Coins Pct'
	pbp_b13i_fd_coins_pct_max        = 'Food Max Coins Pct'
	pbp_b13i_fd_ded_yn               = 'Food Deductible YN'
	pbp_b13i_fd_ded_amt              = 'Food Deductible Amt'
	pbp_b13i_fd_copay_yn             = 'Food Copayment YN'
	pbp_b13i_fd_copay_amt_min        = 'Food Min Copay Amt'
	pbp_b13i_fd_copay_amt_max        = 'Food Max Copay Amt'
	pbp_b13i_fd_auth_yn              = 'Food Enrollee Auth'
	pbp_b13i_fd_refer_yn             = 'Food Referral YN'
	pbp_b13i_ml_bendesc_service      = 'Home-Delivered Meals'
	pbp_b13i_ml_bendesc_amo          = 'Meals Ben Desc MO'
	pbp_b13i_ml_unlimited_yn         = 'Meals Unlimited'
	pbp_b13i_ml_maxplan_yn           = 'Meals Max Plan YN'
	pbp_b13i_ml_maxplan_amt          = 'Meals Max Plan Amt'
	pbp_b13i_ml_maxplan_per          = 'Meals Max Plan Per'
	pbp_b13i_ml_maxplan_per_d        = 'Meals Max Plan Per Desc'
	pbp_b13i_ml_maxenr_yn            = 'Meals Max Enr YN'
	pbp_b13i_ml_maxenr_amt           = 'Meals Max Enr Amt'
	pbp_b13i_ml_maxenr_per           = 'Meals Max Enr Per'
	pbp_b13i_ml_maxenr_per_d         = 'Meals Max Enr Per Desc'
	pbp_b13i_ml_coins_yn             = 'Meals Coinsurance YN'
	pbp_b13i_ml_coins_pct_min        = 'Meals Min Coins Pct'
	pbp_b13i_ml_coins_pct_max        = 'Meals Max Coins Pct'
	pbp_b13i_ml_ded_yn               = 'Meals Deductible YN'
	pbp_b13i_ml_ded_amt              = 'Meals Deductible Amt'
	pbp_b13i_ml_copay_yn             = 'Meals Copayment YN'
	pbp_b13i_ml_copay_amt_min        = 'Meals Min Copay Amt'
	pbp_b13i_ml_copay_amt_max        = 'Meals Max Copay Amt'
	pbp_b13i_ml_auth_yn              = 'Meals Enrollee Auth'
	pbp_b13i_ml_refer_yn             = 'Meals Referral YN'
	pbp_b13i_ps_bendesc_yn           = 'Pest Control YN'
	pbp_b13i_ps_bendesc_amo          = 'Pest Control Ben Desc MO'
	pbp_b13i_ps_maxplan_yn           = 'Pest Control Max Plan YN'
	pbp_b13i_ps_maxplan_amt          = 'Pest Control Max Plan Amt'
	pbp_b13i_ps_maxplan_per          = 'Pest Control Max Plan Per'
	pbp_b13i_ps_maxplan_per_d        = 'Pest Max Plan Per Desc'
	pbp_b13i_ps_maxenr_yn            = 'Pest Control Max Enr YN'
	pbp_b13i_ps_maxenr_amt           = 'Pest Control Max Enr Amt'
	pbp_b13i_ps_maxenr_per           = 'Pest Control Max Enr Per'
	pbp_b13i_ps_maxenr_per_d         = 'Pest Max Enr Per Desc'
	pbp_b13i_ps_coins_yn             = 'Pest Control Coinsurance YN'
	pbp_b13i_ps_coins_pct_min        = 'Pest Control Min Coins Pct'
	pbp_b13i_ps_coins_pct_max        = 'Pest Control Max Coins Pct'
	pbp_b13i_ps_ded_yn               = 'Pest Control Deductible YN'
	pbp_b13i_ps_ded_amt              = 'Pest Control Deductible Amt'
	pbp_b13i_ps_copay_yn             = 'Pest Control Copayment YN'
	pbp_b13i_ps_copay_amt_min        = 'Pest Control Min Copay Amt'
	pbp_b13i_ps_copay_amt_max        = 'Pest Control Max Copay Amt'
	pbp_b13i_ps_auth_yn              = 'Pest Control Enrollee Auth'
	pbp_b13i_ps_refer_yn             = 'Pest Control Referral YN'
	pbp_b13i_t_bendesc_yn            = 'Transport NM Desc Ben YN'
	pbp_b13i_t_bendesc_trn           = 'Transport NM Ben Desc Enhance'
	pbp_b13i_t_bendesc_amo_pal       = 'Transport NM PAL Desc MO'
	pbp_b13i_t_bendesc_lim_pal       = 'Transport NM PAL Desc Lim'
	pbp_b13i_t_bendesc_amt_pal       = 'Transport NM PAL Desc Num'
	pbp_b13i_t_bendesc_per_pal       = 'Transport NM PAL Desc Per'
	pbp_b13i_t_bendesc_per_pal_d     = 'Transport NM PAL Per Desc'
	pbp_b13i_t_bendesc_tt_pal        = 'Transport NM PAL Desc Type'
	pbp_b13i_t_bendesc_tt_pal_d      = 'Transport NM PAL Type Desc'
	pbp_b13i_t_bendesc_amt_pal_day   = 'Transport NM PAL Num Days'
	pbp_b13i_t_bendesc_mt_pal        = 'Transport NM PAL Desc Mode'
	pbp_b13i_t_bendesc_mt_pal_d      = 'Transport NM PAL Desc Desc'
	pbp_b13i_t_bendesc_amo_al        = 'Transport NM AL Desc MO'
	pbp_b13i_t_bendesc_lim_al        = 'Transport NM AL Desc Lim YN'
	pbp_b13i_t_bendesc_amt_al        = 'Transport NM AL Desc Num'
	pbp_b13i_t_bendesc_per_al        = 'Transport NM AL Desc Per'
	pbp_b13i_t_bendesc_per_al_d      = 'Transport NM AL Per Desc'
	pbp_b13i_t_bendesc_tt_al         = 'Transport NM AL Desc Type'
	pbp_b13i_t_bendesc_tt_al_d       = 'Transport NM AL Type Desc'
	pbp_b13i_t_bendesc_amt_al_days   = 'Transport NM AL Num Days'
	pbp_b13i_t_bendesc_mt_al         = 'Transport NM AL Desc Mode'
	pbp_b13i_t_bendesc_mt_al_d       = 'Transport NM AL Desc'
	pbp_b13i_t_maxplan_yn            = 'Transport NM Max Plan YN'
	pbp_b13i_t_maxplan_amt           = 'Transport NM Max Plan Amt'
	pbp_b13i_t_maxplan_per           = 'Transport NM Max Plan Per'
	pbp_b13i_t_maxplan_per_d         = 'Transport NM Max Plan Desc'
	pbp_b13i_t_maxenr_yn             = 'Transport NM Max Enr YN'
	pbp_b13i_t_maxenr_amt            = 'Transport NM Max Enr Amt'
	pbp_b13i_t_maxenr_per            = 'Transport NM Max Enr Per'
	pbp_b13i_t_maxenr_per_d          = 'Transport NM Max Enr Desc'
	pbp_b13i_t_coins_yn              = 'Transport NM Coinsurance YN'
	pbp_b13i_t_coins_pct_min         = 'Transport NM Coins Min Pct'
	pbp_b13i_t_coins_pct_max         = 'Transport NM Coins Max Pct'
	pbp_b13i_t_ded_yn                = 'Transport NM Deductible YN'
	pbp_b13i_t_ded_amt               = 'Transport NM Deductible Amt'
	pbp_b13i_t_copay_yn              = 'Transport NM Copayment YN'
	pbp_b13i_t_copay_amt_min         = 'Transport NM Copay Min Amt'
	pbp_b13i_t_copay_amt_max         = 'Transport NM Copay Max Amt'
	pbp_b13i_t_auth_yn               = 'Transport NM Enrollee Auth'
	pbp_b13i_t_refer_yn              = 'Transport NM Referral YN'
	pbp_b13i_air_bendesc_yn          = 'Indoor Air Quality'
	pbp_b13i_air_bendesc_amo         = 'Indoor Air Desc MO'
	pbp_b13i_air_maxplan_yn          = 'Indoor Air Max Plan YN'
	pbp_b13i_air_maxplan_amt         = 'Indoor Air Max Plan Amt'
	pbp_b13i_air_maxplan_per         = 'Indoor Air Max Plan Per'
	pbp_b13i_air_maxplan_per_d       = 'Indoor Air Max Plan Per Desc'
	pbp_b13i_air_maxenr_yn           = 'Indoor Air Max Enr YN'
	pbp_b13i_air_maxenr_amt          = 'Indoor Air Max Enr Amt'
	pbp_b13i_air_maxenr_per          = 'Indoor Air Max Enr Per'
	pbp_b13i_air_maxenr_per_d        = 'Indoor Air Max Enr Per Desc'
	pbp_b13i_air_coins_yn            = 'Indoor Air Coinsurance YN'
	pbp_b13i_air_coins_pct_min       = 'Indoor Air Min Coins Pct'
	pbp_b13i_air_coins_pct_max       = 'Indoor Air Max Coins Pct'
	pbp_b13i_air_ded_yn              = 'Indoor Air Deductible YN'
	pbp_b13i_air_ded_amt             = 'Indoor Air Deductible Amt'
	pbp_b13i_air_copay_yn            = 'Indoor Air Copayment YN'
	pbp_b13i_air_copay_amt_min       = 'Indoor Air Min Copay Amt'
	pbp_b13i_air_copay_amt_max       = 'Indoor Air Max Copay Amt'
	pbp_b13i_air_auth_yn             = 'Indoor Air Enrollee Auth'
	pbp_b13i_air_refer_yn            = 'Indoor Air Referral YN'
	pbp_b13i_socn_bendesc_yn         = 'Social Needs Quality'
	pbp_b13i_socn_bendesc_amo        = 'Social Needs Desc MO'
	pbp_b13i_socn_maxplan_yn         = 'Social Needs Max Plan YN'
	pbp_b13i_socn_maxplan_amt        = 'Social Needs Max Plan Amt'
	pbp_b13i_socn_maxplan_per        = 'Social Needs Max Plan Per'
	pbp_b13i_socn_maxplan_per_d      = 'Social Max Plan Per Desc'
	pbp_b13i_socn_maxenr_yn          = 'Social Needs Max Enr YN'
	pbp_b13i_socn_maxenr_amt         = 'Social Needs Max Enr Amt'
	pbp_b13i_socn_maxenr_per         = 'Social Needs Max Enr Per'
	pbp_b13i_socn_maxenr_per_d       = 'Social Max Enr Per Desc'
	pbp_b13i_socn_coins_yn           = 'Social Needs Coinsurance YN'
	pbp_b13i_socn_coins_pct_min      = 'Social Needs Min Coins Pct'
	pbp_b13i_socn_coins_pct_max      = 'Social Needs Max Coins Pct'
	pbp_b13i_socn_ded_yn             = 'Social Needs Deductible YN'
	pbp_b13i_socn_ded_amt            = 'Social Needs Deductible Amt'
	pbp_b13i_socn_copay_yn           = 'Social Needs Copayment YN'
	pbp_b13i_socn_copay_amt_min      = 'Social Needs Min Copay Amt'
	pbp_b13i_socn_copay_amt_max      = 'Social Needs Max Copay Amt'
	pbp_b13i_socn_auth_yn            = 'Social Needs Enrollee Auth'
	pbp_b13i_socn_refer_yn           = 'Social Needs Referral YN'
	pbp_b13i_cmptx_bendesc_yn        = 'Compl Tx Quality'
	pbp_b13i_cmptx_bendesc_amo       = 'Compl Tx Desc MO'
	pbp_b13i_cmptx_maxplan_yn        = 'Compl Tx Max Plan YN'
	pbp_b13i_cmptx_maxplan_amt       = 'Compl Tx Max Plan Amt'
	pbp_b13i_cmptx_maxplan_per       = 'Compl Tx Max Plan Per'
	pbp_b13i_cmptx_maxplan_per_d     = 'Compl Tx Max Plan Per Desc'
	pbp_b13i_cmptx_maxenr_yn         = 'Compl Tx Max Enr YN'
	pbp_b13i_cmptx_maxenr_amt        = 'Compl Tx Max Enr Amt'
	pbp_b13i_cmptx_maxenr_per        = 'Compl Tx Max Enr Per'
	pbp_b13i_cmptx_maxenr_per_d      = 'Compl Tx Max Enr Per Desc'
	pbp_b13i_cmptx_coins_yn          = 'Compl Tx Coinsurance YN'
	pbp_b13i_cmptx_coins_pct_min     = 'Compl Tx Min Coins Pct'
	pbp_b13i_cmptx_coins_pct_max     = 'Compl Tx Max Coins Pct'
	pbp_b13i_cmptx_ded_yn            = 'Compl Tx Deductible YN'
	pbp_b13i_cmptx_ded_amt           = 'Compl Tx Deductible Amt'
	pbp_b13i_cmptx_copay_yn          = 'Compl Tx Copayment YN'
	pbp_b13i_cmptx_copay_amt_min     = 'Compl Tx Min Copay Amt'
	pbp_b13i_cmptx_copay_amt_max     = 'Compl Tx Max Copay Amt'
	pbp_b13i_cmptx_auth_yn           = 'Compl Tx Enrollee Auth'
	pbp_b13i_cmptx_refer_yn          = 'Compl Tx Referral YN'
	pbp_b13i_selfd_bendesc_yn        = 'Svc Self Quality'
	pbp_b13i_selfd_bendesc_amo       = 'Svc Self Desc MO'
	pbp_b13i_selfd_maxplan_yn        = 'Svc Self Max Plan YN'
	pbp_b13i_selfd_maxplan_amt       = 'Svc Self Max Plan Amt'
	pbp_b13i_selfd_maxplan_per       = 'Svc Self Max Plan Per'
	pbp_b13i_selfd_maxplan_per_d     = 'Svc Self Max Plan Per Desc'
	pbp_b13i_selfd_maxenr_yn         = 'Svc Self Max Enr YN'
	pbp_b13i_selfd_maxenr_amt        = 'Svc Self Max Enr Amt'
	pbp_b13i_selfd_maxenr_per        = 'Svc Self Max Enr Per'
	pbp_b13i_selfd_maxenr_per_d      = 'Svc Self Max Enr Per Desc'
	pbp_b13i_selfd_coins_yn          = 'Svc Self Coinsurance YN'
	pbp_b13i_selfd_coins_pct_min     = 'Svc Self Min Coins Pct'
	pbp_b13i_selfd_coins_pct_max     = 'Svc Self Max Coins Pct'
	pbp_b13i_selfd_ded_yn            = 'Svc Self Deductible YN'
	pbp_b13i_selfd_ded_amt           = 'Svc Self Deductible Amt'
	pbp_b13i_selfd_copay_yn          = 'Svc Self Copayment YN'
	pbp_b13i_selfd_copay_amt_min     = 'Svc Self Min Copay Amt'
	pbp_b13i_selfd_copay_amt_max     = 'Svc Self Max Copay Amt'
	pbp_b13i_selfd_auth_yn           = 'Svc Self Enrollee Auth'
	pbp_b13i_selfd_refer_yn          = 'Svc Self Referral YN'
	pbp_b13i_home_bendesc_yn         = 'Home Mod Quality'
	pbp_b13i_home_bendesc_amo        = 'Home Mod Desc MO'
	pbp_b13i_home_maxplan_yn         = 'Home Mod Max Plan YN'
	pbp_b13i_home_maxplan_amt        = 'Home Mod Max Plan Amt'
	pbp_b13i_home_maxplan_per        = 'Home Mod Max Plan Per'
	pbp_b13i_home_maxplan_per_d      = 'Home Mod Max Plan Per Desc'
	pbp_b13i_home_maxenr_yn          = 'Home Mod Max Enr YN'
	pbp_b13i_home_maxenr_amt         = 'Home Mod Max Enr Amt'
	pbp_b13i_home_maxenr_per         = 'Home Mod Max Enr Per'
	pbp_b13i_home_maxenr_per_d       = 'Home Mod Max Enr Per Desc'
	pbp_b13i_home_coins_yn           = 'Home Mod Coinsurance YN'
	pbp_b13i_home_coins_pct_min      = 'Home Mod Min Coins Pct'
	pbp_b13i_home_coins_pct_max      = 'Home Mod Max Coins Pct'
	pbp_b13i_home_ded_yn             = 'Home Mod Deductible YN'
	pbp_b13i_home_ded_amt            = 'Home Mod Deductible Amt'
	pbp_b13i_home_copay_yn           = 'Home Mod Copayment YN'
	pbp_b13i_home_copay_amt_min      = 'Home Mod Min Copay Amt'
	pbp_b13i_home_copay_amt_max      = 'Home Mod Max Copay Amt'
	pbp_b13i_home_auth_yn            = 'Home Mod Enrollee Auth'
	pbp_b13i_home_refer_yn           = 'Home Mod Referral YN'
	pbp_b13i_suppt_bendesc_yn        = 'Temp Sppt Quality'
	pbp_b13i_suppt_bendesc_amo       = 'Temp Sppt Desc MO'
	pbp_b13i_suppt_maxplan_yn        = 'Temp Sppt Max Plan YN'
	pbp_b13i_suppt_maxplan_amt       = 'Temp Sppt Max Plan Amt'
	pbp_b13i_suppt_maxplan_per       = 'Temp Sppt Max Plan Per'
	pbp_b13i_suppt_maxplan_per_d     = 'Temp Sppt Max Plan Per Desc'
	pbp_b13i_suppt_maxenr_yn         = 'Temp Sppt Max Enr YN'
	pbp_b13i_suppt_maxenr_amt        = 'Temp Sppt Max Enr Amt'
	pbp_b13i_suppt_maxenr_per        = 'Temp Sppt Max Enr Per'
	pbp_b13i_suppt_maxenr_per_d      = 'Temp Sppt Max Enr Per Desc'
	pbp_b13i_suppt_coins_yn          = 'Temp Sppt Coinsurance YN'
	pbp_b13i_suppt_coins_pct_min     = 'Temp Sppt Min Coins Pct'
	pbp_b13i_suppt_coins_pct_max     = 'Temp Sppt Max Coins Pct'
	pbp_b13i_suppt_ded_yn            = 'Temp Sppt Deductible YN'
	pbp_b13i_suppt_ded_amt           = 'Temp Sppt Deductible Amt'
	pbp_b13i_suppt_copay_yn          = 'Temp Sppt Copayment YN'
	pbp_b13i_suppt_copay_amt_min     = 'Temp Sppt Min Copay Amt'
	pbp_b13i_suppt_copay_amt_max     = 'Temp Sppt Max Copay Amt'
	pbp_b13i_suppt_housing_yn        = 'Temp Sppt Housing YN'
	pbp_b13i_suppt_utility_yn        = 'Temp Sppt Utility YN'
	pbp_b13i_suppt_auth_yn           = 'Temp Sppt Enrollee Auth'
	pbp_b13i_suppt_refer_yn          = 'Temp Sppt Referral YN'
;

run;

proc sort data = pbp_b13i_vbid out=out.pbp_b13i_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b13i_vbid(obs = 10);
  title 'pbp_b13i_b19b_services_vbid_ssbci file ';
run;

proc means data = out.pbp_b13i_vbid;
  title 'pbp_b13i_b19b_services_vbid_ssbci file ';
run;

proc freq data = out.pbp_b13i_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b13i_fd_bendesc_yn
	pbp_b13i_fd_bendesc_amo
	pbp_b13i_fd_maxplan_yn
	pbp_b13i_fd_maxplan_per
	pbp_b13i_fd_maxenr_yn
	pbp_b13i_fd_maxenr_per
	pbp_b13i_fd_coins_yn
	pbp_b13i_fd_ded_yn
	pbp_b13i_fd_copay_yn
	pbp_b13i_fd_auth_yn
	pbp_b13i_fd_refer_yn
	pbp_b13i_ml_bendesc_service
	pbp_b13i_ml_bendesc_amo
	pbp_b13i_ml_unlimited_yn
	pbp_b13i_ml_maxplan_yn
	pbp_b13i_ml_maxplan_per
	pbp_b13i_ml_maxenr_yn
	pbp_b13i_ml_maxenr_per
	pbp_b13i_ml_coins_yn
	pbp_b13i_ml_ded_yn
	pbp_b13i_ml_copay_yn
	pbp_b13i_ml_auth_yn
	pbp_b13i_ml_refer_yn
	pbp_b13i_ps_bendesc_yn
	pbp_b13i_ps_bendesc_amo
	pbp_b13i_ps_maxplan_yn
	pbp_b13i_ps_maxplan_per
	pbp_b13i_ps_maxenr_yn
	pbp_b13i_ps_maxenr_per
	pbp_b13i_ps_coins_yn
	pbp_b13i_ps_ded_yn
	pbp_b13i_ps_copay_yn
	pbp_b13i_ps_auth_yn
	pbp_b13i_ps_refer_yn
	pbp_b13i_t_bendesc_yn
	pbp_b13i_t_bendesc_trn
	pbp_b13i_t_bendesc_amo_pal
	pbp_b13i_t_bendesc_lim_pal
	pbp_b13i_t_bendesc_per_pal
	pbp_b13i_t_bendesc_tt_pal
	pbp_b13i_t_bendesc_amo_al
	pbp_b13i_t_bendesc_lim_al
	pbp_b13i_t_bendesc_per_al
	pbp_b13i_t_bendesc_tt_al
	pbp_b13i_t_maxplan_yn
	pbp_b13i_t_maxplan_per
	pbp_b13i_t_maxenr_yn
	pbp_b13i_t_maxenr_per
	pbp_b13i_t_coins_yn
	pbp_b13i_t_ded_yn
	pbp_b13i_t_copay_yn
	pbp_b13i_t_auth_yn
	pbp_b13i_t_refer_yn
	pbp_b13i_air_bendesc_yn
	pbp_b13i_air_bendesc_amo
	pbp_b13i_air_maxplan_yn
	pbp_b13i_air_maxplan_per
	pbp_b13i_air_maxenr_yn
	pbp_b13i_air_maxenr_per
	pbp_b13i_air_coins_yn
	pbp_b13i_air_ded_yn
	pbp_b13i_air_copay_yn
	pbp_b13i_air_auth_yn
	pbp_b13i_air_refer_yn
	pbp_b13i_socn_bendesc_yn
	pbp_b13i_socn_bendesc_amo
	pbp_b13i_socn_maxplan_yn
	pbp_b13i_socn_maxplan_per
	pbp_b13i_socn_maxenr_yn
	pbp_b13i_socn_maxenr_per
	pbp_b13i_socn_coins_yn
	pbp_b13i_socn_ded_yn
	pbp_b13i_socn_copay_yn
	pbp_b13i_socn_auth_yn
	pbp_b13i_socn_refer_yn
	pbp_b13i_cmptx_bendesc_yn
	pbp_b13i_cmptx_bendesc_amo
	pbp_b13i_cmptx_maxplan_yn
	pbp_b13i_cmptx_maxplan_per
	pbp_b13i_cmptx_maxenr_yn
	pbp_b13i_cmptx_maxenr_per
	pbp_b13i_cmptx_coins_yn
	pbp_b13i_cmptx_ded_yn
	pbp_b13i_cmptx_copay_yn
	pbp_b13i_cmptx_auth_yn
	pbp_b13i_cmptx_refer_yn
	pbp_b13i_selfd_bendesc_yn
	pbp_b13i_selfd_bendesc_amo
	pbp_b13i_selfd_maxplan_yn
	pbp_b13i_selfd_maxplan_per
	pbp_b13i_selfd_maxenr_yn
	pbp_b13i_selfd_maxenr_per
	pbp_b13i_selfd_coins_yn
	pbp_b13i_selfd_ded_yn
	pbp_b13i_selfd_copay_yn
	pbp_b13i_selfd_auth_yn
	pbp_b13i_selfd_refer_yn
	pbp_b13i_home_bendesc_yn
	pbp_b13i_home_bendesc_amo
	pbp_b13i_home_maxplan_yn
	pbp_b13i_home_maxplan_per
	pbp_b13i_home_maxenr_yn
	pbp_b13i_home_maxenr_per
	pbp_b13i_home_coins_yn
	pbp_b13i_home_ded_yn
	pbp_b13i_home_copay_yn
	pbp_b13i_home_auth_yn
	pbp_b13i_home_refer_yn
	pbp_b13i_suppt_bendesc_yn
	pbp_b13i_suppt_bendesc_amo
	pbp_b13i_suppt_maxplan_yn
	pbp_b13i_suppt_maxplan_per
	pbp_b13i_suppt_maxenr_yn
	pbp_b13i_suppt_maxenr_per
	pbp_b13i_suppt_coins_yn
	pbp_b13i_suppt_ded_yn
	pbp_b13i_suppt_copay_yn
	pbp_b13i_suppt_housing_yn
	pbp_b13i_suppt_utility_yn
	pbp_b13i_suppt_auth_yn
	pbp_b13i_suppt_refer_yn
/ missing;
run;

proc contents data = out.pbp_b13i_vbid;
  title 'pbp_b13i_vbid data';
run;