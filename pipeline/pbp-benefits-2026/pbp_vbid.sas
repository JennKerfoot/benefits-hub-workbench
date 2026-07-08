*pbp_vbid.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	part_d_model_demo                $1
	part_d_enhncd_cvrg_demo          $1
	mrx_vbd_yn                       $1
	mrx_rai_off_rew_incent_yn        $1
	mrx_rai_num_partd_offrd          $1
	mrx_reduct_cost_yn               $1
	mrx_v_bid_attestation            $1
	mrx_rai_grp_name_rew_1rx         $4000
	mrx_rai_type_partd_rew_1rx       $3
	max_rai_frq_rew_incent_1rx       $1
	mrx_rai_frq_ri_desc_1rx          $4000
	mrx_rai_elig_crit_1rx            $3
	mrx_rai_meet_adh_goal_yn_1rx     $1
	mrx_rai_grp_name_rew_2rx         $4000
	mrx_rai_type_partd_rew_2rx       $3
	max_rai_frq_rew_incent_2rx       $1
	mrx_rai_frq_ri_desc_2rx          $4000
	mrx_rai_elig_crit_2rx            $3
	mrx_rai_meet_adh_goal_yn_2rx     $1
	mrx_rai_grp_name_rew_3rx         $4000
	mrx_rai_type_partd_rew_3rx       $3
	max_rai_frq_rew_incent_3rx       $1
	mrx_rai_frq_ri_desc_3rx          $4000
	mrx_rai_elig_crit_3rx            $3
	mrx_rai_meet_adh_goal_yn_3rx     $1
;

infile '.\pbp\pbp_vbid.txt' delimiter = '09'x
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
	mrx_vbd_yn
	mrx_rai_off_rew_incent_yn
	mrx_rai_num_partd_offrd
	mrx_reduct_cost_yn
	mrx_tier_group_num
	mrx_v_bid_attestation
	mrx_rai_grp_name_rew_1rx
	mrx_rai_type_partd_rew_1rx
	max_rai_partd_rew_inc_amt_1rx
	max_rai_frq_rew_incent_1rx
	mrx_rai_frq_ri_desc_1rx
	mrx_rai_elig_crit_1rx
	mrx_rai_meet_adh_goal_yn_1rx
	max_rai_ann_partd_rew_amt_1rx
	mrx_rai_grp_name_rew_2rx
	mrx_rai_type_partd_rew_2rx
	max_rai_partd_rew_inc_amt_2rx
	max_rai_frq_rew_incent_2rx
	mrx_rai_frq_ri_desc_2rx
	mrx_rai_elig_crit_2rx
	mrx_rai_meet_adh_goal_yn_2rx
	max_rai_ann_partd_rew_amt_2rx
	mrx_rai_grp_name_rew_3rx
	mrx_rai_type_partd_rew_3rx
	max_rai_partd_rew_inc_amt_3rx
	max_rai_frq_rew_incent_3rx
	mrx_rai_frq_ri_desc_3rx
	mrx_rai_elig_crit_3rx
	mrx_rai_meet_adh_goal_yn_3rx
	max_rai_ann_partd_rew_amt_3rx
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
	mrx_vbd_yn                       = 'Rx VBID D YN'
	mrx_rai_off_rew_incent_yn        = 'Rx VIBD Rew and Inc YN'
	mrx_rai_num_partd_offrd          = 'Rx VBID RAI Package #'
	mrx_reduct_cost_yn               = 'Rx VBID YN'
	mrx_tier_group_num               = 'Rx VBID Num Grps'
	mrx_v_bid_attestation            = 'Rx VBID  Attestation'
	mrx_rai_grp_name_rew_1rx         = 'Rx VBID RAI 1 Name'
	mrx_rai_type_partd_rew_1rx       = 'Rx VBID RAI 1 Type'
	max_rai_partd_rew_inc_amt_1rx    = 'Rx VBID RAI 1 Amount'
	max_rai_frq_rew_incent_1rx       = 'Rx VBID RAI 1 Frequency'
	mrx_rai_frq_ri_desc_1rx          = 'Rx VBID RAI D Freq Desc 1'
	mrx_rai_elig_crit_1rx            = 'Rx VBID RAI 1 Elg Crit'
	mrx_rai_meet_adh_goal_yn_1rx     = 'Rx VBID RAI 1 Meets Goal'
	max_rai_ann_partd_rew_amt_1rx    = 'Rx VBID RAI 1 Max Amount'
	mrx_rai_grp_name_rew_2rx         = 'Rx VBID RAI 2 Name'
	mrx_rai_type_partd_rew_2rx       = 'Rx VBID RAI 2 Type'
	max_rai_partd_rew_inc_amt_2rx    = 'Rx VBID RAI 2 Amount'
	max_rai_frq_rew_incent_2rx       = 'Rx VBID RAI 2 Frequency'
	mrx_rai_frq_ri_desc_2rx          = 'Rx VBID RAI D Freq Desc 2'
	mrx_rai_elig_crit_2rx            = 'Rx VBID RAI 2 Elg Crit'
	mrx_rai_meet_adh_goal_yn_2rx     = 'Rx VBID RAI 2 Meets Goal'
	max_rai_ann_partd_rew_amt_2rx    = 'Rx VBID RAI 2 Max Amount'
	mrx_rai_grp_name_rew_3rx         = 'Rx VBID RAI 3 Name'
	mrx_rai_type_partd_rew_3rx       = 'Rx VBID RAI 3 Type'
	max_rai_partd_rew_inc_amt_3rx    = 'Rx VBID RAI 3 Amount'
	max_rai_frq_rew_incent_3rx       = 'Rx VBID RAI 3 Frequency'
	mrx_rai_frq_ri_desc_3rx          = 'Rx VBID RAI D Freq Desc 3'
	mrx_rai_elig_crit_3rx            = 'Rx VBID RAI 3 Elg Crit'
	mrx_rai_meet_adh_goal_yn_3rx     = 'Rx VBID RAI 3 Meets Goal'
	max_rai_ann_partd_rew_amt_3rx    = 'Rx VBID RAI 3 Max Amount'
;

run;

proc sort data = pbp_vbid out=out.pbp_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_vbid(obs = 10);
  title 'pbp_vbid file ';
run;

proc means data = out.pbp_vbid;
  title 'pbp_vbid file ';
run;

proc freq data = out.pbp_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_vbd_yn
	mrx_rai_off_rew_incent_yn
	mrx_rai_num_partd_offrd
	mrx_reduct_cost_yn
	mrx_v_bid_attestation
	mrx_rai_type_partd_rew_1rx
	max_rai_frq_rew_incent_1rx
	mrx_rai_elig_crit_1rx
	mrx_rai_meet_adh_goal_yn_1rx
	mrx_rai_type_partd_rew_2rx
	max_rai_frq_rew_incent_2rx
	mrx_rai_elig_crit_2rx
	mrx_rai_meet_adh_goal_yn_2rx
	mrx_rai_type_partd_rew_3rx
	max_rai_frq_rew_incent_3rx
	mrx_rai_elig_crit_3rx
	mrx_rai_meet_adh_goal_yn_3rx
/ missing;
run;

proc contents data = out.pbp_vbid;
  title 'pbp_vbid data';
run;