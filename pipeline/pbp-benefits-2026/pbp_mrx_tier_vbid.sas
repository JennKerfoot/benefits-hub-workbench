*pbp_mrx_tier_vbid.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_mrx_tier_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	part_d_model_demo                $1
	part_d_enhncd_cvrg_demo          $1
	mrx_tier_group_id                $2
	mrx_tier_id                      $1
	mrx_tier_type_id                 $1
	mrx_group_tiers_icl              $7
	mrx_tier_cstshr_struct_type_vb   $1
	mrx_tier_cost_share_vb           $1
	mrx_tier_locat_rstd_vb           $3
	mrx_tier_locat_rsplt_vb          $3
	mrx_tier_locat_oon_vb            $2
	mrx_tier_locat_mostd_vb          $3
	mrx_tier_locat_mosplt_vb         $3
	mrx_tier_locat_ltc_vb            $1
;

infile '.\pbp\pbp_mrx_tier_vbid.txt' delimiter = '09'x
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
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_tier_group_id
	mrx_tier_id
	mrx_tier_type_id
	mrx_group_tiers_icl
	mrx_tier_cstshr_struct_type_vb
	mrx_tier_cost_share_vb
	mrx_tier_locat_rstd_vb
	mrx_tier_locat_rsplt_vb
	mrx_tier_locat_oon_vb
	mrx_tier_locat_mostd_vb
	mrx_tier_locat_mosplt_vb
	mrx_tier_locat_ltc_vb
	mrx_tier_rstd_copay_1m_min
	mrx_tier_rstd_copay_1m_max
	mrx_tier_rstd_copay_2m_min
	mrx_tier_rstd_copay_2m_max
	mrx_tier_rstd_copay_3m_min
	mrx_tier_rstd_copay_3m_max
	mrx_tier_rsstd_copay_1m_min
	mrx_tier_rsstd_copay_1m_max
	mrx_tier_rsstd_copay_2m_min
	mrx_tier_rsstd_copay_2m_max
	mrx_tier_rsstd_copay_3m_min
	mrx_tier_rsstd_copay_3m_max
	mrx_tier_rspfd_copay_1m_min
	mrx_tier_rspfd_copay_1m_max
	mrx_tier_rspfd_copay_2m_min
	mrx_tier_rspfd_copay_2m_max
	mrx_tier_rspfd_copay_3m_min
	mrx_tier_rspfd_copay_3m_max
	mrx_tier_rstd_coins_1m_min
	mrx_tier_rstd_coins_1m_max
	mrx_tier_rstd_coins_2m_min
	mrx_tier_rstd_coins_2m_max
	mrx_tier_rstd_coins_3m_min
	mrx_tier_rstd_coins_3m_max
	mrx_tier_rsstd_coins_1m_min
	mrx_tier_rsstd_coins_1m_max
	mrx_tier_rsstd_coins_2m_min
	mrx_tier_rsstd_coins_2m_max
	mrx_tier_rsstd_coins_3m_min
	mrx_tier_rsstd_coins_3m_max
	mrx_tier_rspfd_coins_1m_min
	mrx_tier_rspfd_coins_1m_max
	mrx_tier_rspfd_coins_2m_min
	mrx_tier_rspfd_coins_2m_max
	mrx_tier_rspfd_coins_3m_min
	mrx_tier_rspfd_coins_3m_max
	mrx_tier_mostd_copay_1m_min
	mrx_tier_mostd_copay_1m_max
	mrx_tier_mostd_copay_2m_min
	mrx_tier_mostd_copay_2m_max
	mrx_tier_mostd_copay_3m_min
	mrx_tier_mostd_copay_3m_max
	mrx_tier_mosstd_copay_1m_min
	mrx_tier_mosstd_copay_1m_max
	mrx_tier_mosstd_copay_2m_min
	mrx_tier_mosstd_copay_2m_max
	mrx_tier_mosstd_copay_3m_min
	mrx_tier_mosstd_copay_3m_max
	mrx_tier_mospfd_copay_1m_min
	mrx_tier_mospfd_copay_1m_max
	mrx_tier_mospfd_copay_2m_min
	mrx_tier_mospfd_copay_2m_max
	mrx_tier_mospfd_copay_3m_min
	mrx_tier_mospfd_copay_3m_max
	mrx_tier_mostd_coins_1m_min
	mrx_tier_mostd_coins_1m_max
	mrx_tier_mostd_coins_2m_min
	mrx_tier_mostd_coins_2m_max
	mrx_tier_mostd_coins_3m_min
	mrx_tier_mostd_coins_3m_max
	mrx_tier_mosstd_coins_1m_min
	mrx_tier_mosstd_coins_1m_max
	mrx_tier_mosstd_coins_2m_min
	mrx_tier_mosstd_coins_2m_max
	mrx_tier_mosstd_coins_3m_min
	mrx_tier_mosstd_coins_3m_max
	mrx_tier_mospfd_coins_1m_min
	mrx_tier_mospfd_coins_1m_max
	mrx_tier_mospfd_coins_2m_min
	mrx_tier_mospfd_coins_2m_max
	mrx_tier_mospfd_coins_3m_min
	mrx_tier_mospfd_coins_3m_max
	mrx_tier_oonp_copay_1m_min
	mrx_tier_oonp_copay_1m_max
	mrx_tier_oonp_copay_oth_min
	mrx_tier_oonp_copay_oth_max
	mrx_tier_oonp_coins_1m_min
	mrx_tier_oonp_coins_1m_max
	mrx_tier_oonp_coins_oth_min
	mrx_tier_oonp_coins_oth_max
	mrx_tier_ltcp_copay_1m_min
	mrx_tier_ltcp_copay_1m_max
	mrx_tier_ltcp_coins_1m_min
	mrx_tier_ltcp_coins_1m_max
	mrx_tier_rstd_1m_num_vb
	mrx_tier_rstd_copay_daily_vb
	mrx_tier_mostd_1m_num_vb
	mrx_tier_mostd_copay_daily_vb
	mrx_tier_rsplt_1m_num_vb
	mrx_tier_rsstd_copay_daily_vb
	mrx_tier_mosplt_1m_num_vb
	mrx_tier_mosstd_copay_daily_vb
	mrx_tier_rspfd_copay_daily_vb
	mrx_tier_mospfd_copay_daily_vb
	mrx_tier_ltcp_1m_vb
	mrx_tier_ltcp_copay_daily_vb
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
	part_d_model_demo                = 'Part D Model Demo'
	part_d_enhncd_cvrg_demo          = 'Part D Senior Savings Model'
	mrx_tier_group_id                = 'MRX VBID Group (Package) ID'
	mrx_tier_id                      = 'MRx Tier ID'
	mrx_tier_type_id                 = 'MRx Tier Type ID'
	mrx_group_tiers_icl              = 'Rx VBID ICP tiers'
	mrx_tier_cstshr_struct_type_vb   = 'Rx VBID Cost Share Tier Struc'
	mrx_tier_cost_share_vb           = 'Rx VBID Cost Share'
	mrx_tier_locat_rstd_vb           = 'Rx VBID Std Retail Cost Loc'
	mrx_tier_locat_rsplt_vb          = 'Rx VBID Std/Pref Cost Loc'
	mrx_tier_locat_oon_vb            = 'Rx VBID Out-of-Network Loc'
	mrx_tier_locat_mostd_vb          = 'Rx VBID MO Std Locat'
	mrx_tier_locat_mosplt_vb         = 'Rx VBID MO Std/Pref Locat'
	mrx_tier_locat_ltc_vb            = 'Rx VBID LTC Locations'
	mrx_tier_rstd_copay_1m_min       = 'Rx VBID rstd min Copay 1M'
	mrx_tier_rstd_copay_1m_max       = 'Rx VBID rstd max Copay 1M'
	mrx_tier_rstd_copay_2m_min       = 'Rx VBID rstd min Copay 2M'
	mrx_tier_rstd_copay_2m_max       = 'Rx VBID rstd max Copay 2M'
	mrx_tier_rstd_copay_3m_min       = 'Rx VBID rstd min Copay 3M'
	mrx_tier_rstd_copay_3m_max       = 'Rx VBID rstd max Copay 3M'
	mrx_tier_rsstd_copay_1m_min      = 'Rx VBID RSSTD min Copay 1M'
	mrx_tier_rsstd_copay_1m_max      = 'Rx VBID RSSTD max Copay 1M'
	mrx_tier_rsstd_copay_2m_min      = 'Rx VBID RSSTD min Copay 2M'
	mrx_tier_rsstd_copay_2m_max      = 'Rx VBID RSSTD max Copay 2M'
	mrx_tier_rsstd_copay_3m_min      = 'Rx VBID RSSTD min Copay 3M'
	mrx_tier_rsstd_copay_3m_max      = 'Rx VBID RSSTD max Copay 3M'
	mrx_tier_rspfd_copay_1m_min      = 'Rx VBID RSPFD min Copay 1M'
	mrx_tier_rspfd_copay_1m_max      = 'Rx VBID RSPFD max Copay 1M'
	mrx_tier_rspfd_copay_2m_min      = 'Rx VBID RSPFD min Copay 2M'
	mrx_tier_rspfd_copay_2m_max      = 'Rx VBID RSPFD max Copay 2M'
	mrx_tier_rspfd_copay_3m_min      = 'Rx VBID RSPFD min Copay 3M'
	mrx_tier_rspfd_copay_3m_max      = 'Rx VBID RSPFD max Copay 3M'
	mrx_tier_rstd_coins_1m_min       = 'Rx VBID rstd min coins 1M'
	mrx_tier_rstd_coins_1m_max       = 'Rx VBID rstd max coins 1M'
	mrx_tier_rstd_coins_2m_min       = 'Rx VBID rstd min coins 2M'
	mrx_tier_rstd_coins_2m_max       = 'Rx VBID rstd max coins 2M'
	mrx_tier_rstd_coins_3m_min       = 'Rx VBID rstd min coins 3M'
	mrx_tier_rstd_coins_3m_max       = 'Rx VBID rstd max coins 3M'
	mrx_tier_rsstd_coins_1m_min      = 'Rx VBID RSSTD min coins 1M'
	mrx_tier_rsstd_coins_1m_max      = 'Rx VBID RSSTD max coins 1M'
	mrx_tier_rsstd_coins_2m_min      = 'Rx VBID RSSTD min coins 2M'
	mrx_tier_rsstd_coins_2m_max      = 'Rx VBID RSSTD max coins 2M'
	mrx_tier_rsstd_coins_3m_min      = 'Rx VBID RSSTD min coins 3M'
	mrx_tier_rsstd_coins_3m_max      = 'Rx VBID RSSTD max coins 3M'
	mrx_tier_rspfd_coins_1m_min      = 'Rx VBID RSPFD min coins 1M'
	mrx_tier_rspfd_coins_1m_max      = 'Rx VBID RSPFD max coins 1M'
	mrx_tier_rspfd_coins_2m_min      = 'Rx VBID RSPFD min coins 2M'
	mrx_tier_rspfd_coins_2m_max      = 'Rx VBID RSPFD max coins 2M'
	mrx_tier_rspfd_coins_3m_min      = 'Rx VBID RSPFD min coins 3M'
	mrx_tier_rspfd_coins_3m_max      = 'Rx VBID RSPFD max coins 3M'
	mrx_tier_mostd_copay_1m_min      = 'Rx VBID MOSTD min Copay 1M'
	mrx_tier_mostd_copay_1m_max      = 'Rx VBID MOSTD max Copay 1M'
	mrx_tier_mostd_copay_2m_min      = 'Rx VBID MOSTD min Copay 2M'
	mrx_tier_mostd_copay_2m_max      = 'Rx VBID MOSTD max Copay 2M'
	mrx_tier_mostd_copay_3m_min      = 'Rx VBID MOSTD min Copay 3M'
	mrx_tier_mostd_copay_3m_max      = 'Rx vbid MOSTD max Copay 3M'
	mrx_tier_mosstd_copay_1m_min     = 'Rx VBID MOSPLT min Copay 1M'
	mrx_tier_mosstd_copay_1m_max     = 'Rx VBID MOSPLT max Copay 1M'
	mrx_tier_mosstd_copay_2m_min     = 'Rx VBID MOSPLT min Copay 2M'
	mrx_tier_mosstd_copay_2m_max     = 'Rx VBID MOSPLT max Copay 2M'
	mrx_tier_mosstd_copay_3m_min     = 'Rx VBID MOSPLT min Copay 3M'
	mrx_tier_mosstd_copay_3m_max     = 'Rx VBID MOSPLT max Copay 3M'
	mrx_tier_mospfd_copay_1m_min     = 'Rx VBID MOSPFD min Copay 1M'
	mrx_tier_mospfd_copay_1m_max     = 'Rx VBID MOSPFD max Copay 1M'
	mrx_tier_mospfd_copay_2m_min     = 'Rx VBID MOSPFD min Copay 2M'
	mrx_tier_mospfd_copay_2m_max     = 'Rx VBID MOSPFD max Copay 2M'
	mrx_tier_mospfd_copay_3m_min     = 'Rx VBID MOSPFD min Copay 3M'
	mrx_tier_mospfd_copay_3m_max     = 'Rx VBID MOSPFD max Copay 3M'
	mrx_tier_mostd_coins_1m_min      = 'Rx VBID MOSTD min coins 1M'
	mrx_tier_mostd_coins_1m_max      = 'Rx VBID MOSTD max coins 1M'
	mrx_tier_mostd_coins_2m_min      = 'Rx VBID MOSTD min coins 2M'
	mrx_tier_mostd_coins_2m_max      = 'Rx VBID MOSTD max coins 2M'
	mrx_tier_mostd_coins_3m_min      = 'Rx VBID MOSTD min coins 3M'
	mrx_tier_mostd_coins_3m_max      = 'Rx VBID MOSTD max coins 3M'
	mrx_tier_mosstd_coins_1m_min     = 'Rx VBID MOSPLT min coins 1M'
	mrx_tier_mosstd_coins_1m_max     = 'Rx VBID MOSPLT max coins 1M'
	mrx_tier_mosstd_coins_2m_min     = 'Rx VBID MOSPLT min coins 2M'
	mrx_tier_mosstd_coins_2m_max     = 'Rx VBID MOSPLT max coins 2M'
	mrx_tier_mosstd_coins_3m_min     = 'Rx VBID MOSPLT min coins 3M'
	mrx_tier_mosstd_coins_3m_max     = 'Rx VBID MOSPLT max coins 3M'
	mrx_tier_mospfd_coins_1m_min     = 'Rx VBID MOSPFD min coins 1M'
	mrx_tier_mospfd_coins_1m_max     = 'Rx VBID MOSPFD max coins 1M'
	mrx_tier_mospfd_coins_2m_min     = 'Rx VBID MOSPFD min coins 2M'
	mrx_tier_mospfd_coins_2m_max     = 'Rx VBID MOSPFD max coins 2M'
	mrx_tier_mospfd_coins_3m_min     = 'Rx VBID MOSPFD min coins 3M'
	mrx_tier_mospfd_coins_3m_max     = 'Rx VBID MOSPFD max coins 3M'
	mrx_tier_oonp_copay_1m_min       = 'Rx VBID OONP min Copay 1M'
	mrx_tier_oonp_copay_1m_max       = 'Rx VBID OONP max Copay 1M'
	mrx_tier_oonp_copay_oth_min      = 'Rx VBID OONP min Copay oth'
	mrx_tier_oonp_copay_oth_max      = 'Rx VBID OONP max Copay oth'
	mrx_tier_oonp_coins_1m_min       = 'Rx VBID OONP min coins 1M'
	mrx_tier_oonp_coins_1m_max       = 'Rx VBID OONP max coins 1M'
	mrx_tier_oonp_coins_oth_min      = 'Rx VBID OONP min coins oth'
	mrx_tier_oonp_coins_oth_max      = 'Rx VBID OONP max coins oth'
	mrx_tier_ltcp_copay_1m_min       = 'Rx VBID LTCP min Copay 1M'
	mrx_tier_ltcp_copay_1m_max       = 'Rx VBID LTCP max Copay 1M'
	mrx_tier_ltcp_coins_1m_min       = 'Rx VBID LTCP min coins 1M'
	mrx_tier_ltcp_coins_1m_max       = 'Rx VBID LTCP max coins 1M'
	mrx_tier_rstd_1m_num_vb          = 'Rx VBID Tier INP 1M Days'
	mrx_tier_rstd_copay_daily_vb     = 'Rx VBID INP Daily Copay'
	mrx_tier_mostd_1m_num_vb         = 'Rx VBID Tier MO 1M Days'
	mrx_tier_mostd_copay_daily_vb    = 'Rx VBID MO Daily Copay'
	mrx_tier_rsplt_1m_num_vb         = 'Rx VBID Tier INPP 1M Days'
	mrx_tier_rsstd_copay_daily_vb    = 'Rx VBID INNPP Daily Copay'
	mrx_tier_mosplt_1m_num_vb        = 'Rx VBID Tier MOPP 1M Days'
	mrx_tier_mosstd_copay_daily_vb   = 'Rx VBID MONPP Daily Copay'
	mrx_tier_rspfd_copay_daily_vb    = 'Rx VBID INPP Daily Copay'
	mrx_tier_mospfd_copay_daily_vb   = 'Rx VBID MOPP Daily Copay'
	mrx_tier_ltcp_1m_vb              = 'Rx VBID LTC Tier 1M Num Days'
	mrx_tier_ltcp_copay_daily_vb     = 'Rx VBID LTCP Daily Copay'
;

run;

proc sort data = pbp_mrx_tier_vbid out=out.pbp_mrx_tier_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_mrx_tier_vbid(obs = 10);
  title 'pbp_mrx_tier_vbid file ';
run;

proc means data = out.pbp_mrx_tier_vbid;
  title 'pbp_mrx_tier_vbid file ';
run;

proc freq data = out.pbp_mrx_tier_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_tier_group_id
	mrx_tier_id
	mrx_tier_type_id
	mrx_tier_cstshr_struct_type_vb
	mrx_tier_cost_share_vb
	mrx_tier_locat_rstd_vb
	mrx_tier_locat_rsplt_vb
	mrx_tier_locat_oon_vb
	mrx_tier_locat_mostd_vb
	mrx_tier_locat_mosplt_vb
	mrx_tier_locat_ltc_vb
/ missing;
run;

proc contents data = out.pbp_mrx_tier_vbid;
  title 'pbp_mrx_tier_vbid data';
run;