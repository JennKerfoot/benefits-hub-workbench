*pbp_mrx_vbid.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_mrx_vbid;

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
	mrx_tier_grp_name                $4000
	mrx_tier_tm                      $3
	mrx_tier_grp_ehc                 $10
	mrx_tier_grp_ehc_d               $4000
	mrx_tier_phase                   $1
	mrx_tier_incent_yn               $1
	mrx_tier_mod_ded_yn              $1
	mrx_tier_cs_lis_elig_yn          $1
	mrx_tier_cs_lis_chk              $5
	mrx_tier_cs_lis_waive_yn         $1
	mrx_group_tiers_icl              $7
;

infile '.\pbp\pbp_mrx_vbid.txt' delimiter = '09'x
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
	mrx_tier_grp_name
	mrx_tier_tm
	mrx_tier_grp_ehc
	mrx_tier_grp_ehc_d
	mrx_tier_phase
	mrx_tier_incent_yn
	mrx_tier_mod_ded_yn
	mrx_tier_mod_ded_amt
	mrx_tier_cs_lis_elig_yn
	mrx_tier_cs_lis_chk
	mrx_tier_cs_lis_waive_yn
	mrx_tier_enr_tar_vbid
	mrx_tier_enr_eng_vbid
	mrx_group_tiers_icl
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
	mrx_tier_grp_name                = 'Rx VBID Group Name'
	mrx_tier_tm                      = 'Rx VBID Target Method'
	mrx_tier_grp_ehc                 = 'Rx VBID Disease States'
	mrx_tier_grp_ehc_d               = 'Rx VBID Disease State Desc'
	mrx_tier_phase                   = 'Rx VBID Phase'
	mrx_tier_incent_yn               = 'Rx VBID Incentive Yn'
	mrx_tier_mod_ded_yn              = 'Rx VBID deductible mod yn'
	mrx_tier_mod_ded_amt             = 'Rx VBID mod deduct amount'
	mrx_tier_cs_lis_elig_yn          = 'Rx VBID CS Reduct Elig'
	mrx_tier_cs_lis_chk              = 'Rx VBID LIS Levels Chk'
	mrx_tier_cs_lis_waive_yn         = 'Rx VBID LIS Waived'
	mrx_tier_enr_tar_vbid            = 'Rx VBID Enroll Target'
	mrx_tier_enr_eng_vbid            = 'Rx VBID Enroll Engaged'
	mrx_group_tiers_icl              = 'Rx VBID ICP tiers'
;

run;

proc sort data = pbp_mrx_vbid out=out.pbp_mrx_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_mrx_vbid(obs = 10);
  title 'pbp_mrx_vbid file ';
run;

proc means data = out.pbp_mrx_vbid;
  title 'pbp_mrx_vbid file ';
run;

proc freq data = out.pbp_mrx_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_tier_group_id
	mrx_tier_tm
	mrx_tier_phase
	mrx_tier_incent_yn
	mrx_tier_mod_ded_yn
	mrx_tier_cs_lis_elig_yn
	mrx_tier_cs_lis_chk
	mrx_tier_cs_lis_waive_yn
/ missing;
run;

proc contents data = out.pbp_mrx_vbid;
  title 'pbp_mrx_vbid data';
run;