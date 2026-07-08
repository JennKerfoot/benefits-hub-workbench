*pbp_ds_vbid.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_ds_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	part_d_model_demo                $1
	part_d_enhncd_cvrg_demo          $1
	mrx_vbd_ds_tier_tm               $3
	mrx_vbd_ds_tier_grp_ehc          $10
	mrx_vbd_ds_tier_grp_ehc_d        $4000
	mrx_vbd_ds_tier_phase            $1
	mrx_vbd_ds_tier_incent_yn        $1
	mrx_vbd_ds_tier_mod_ded_yn       $1
	mrx_vbd_ds_tier_cs_lis_elig_yn   $1
	mrx_vbd_ds_tier_cs_lis_chk       $5
	mrx_vbd_ds_lis_waiver_yn         $1
;

infile '.\pbp\pbp_ds_vbid.txt' delimiter = '09'x
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
	mrx_vbd_ds_tier_tm
	mrx_vbd_ds_tier_grp_ehc
	mrx_vbd_ds_tier_grp_ehc_d
	mrx_vbd_ds_tier_phase
	mrx_vbd_ds_tier_incent_yn
	mrx_vbd_ds_tier_mod_ded_yn
	mrx_vbd_ds_tier_mod_ded_amt
	mrx_vbd_ds_tier_cs_lis_elig_yn
	mrx_vbd_ds_tier_cs_lis_chk
	mrx_vbd_ds_tier_enr_tar
	mrx_vbd_ds_tier_enr_eng
	mrx_vbd_ds_lis_waiver_yn
	mrx_vbd_ds_srcs_copay_1m_num
	mrx_vbd_ds_srcs_copay_2m_num
	mrx_vbd_ds_srcs_copay_3m_num
	mrx_vbd_ds_oonp_copay_1m_num
	mrx_vbd_ds_smocs_copay_1m_num
	mrx_vbd_ds_smocs_copay_2m_num
	mrx_vbd_ds_smocs_copay_3m_num
	mrx_vbd_ds_ltcp_copay_1m_num
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
	mrx_vbd_ds_tier_tm               = 'Rx VBID DS Target Method'
	mrx_vbd_ds_tier_grp_ehc          = 'Rx VBID DS Disease States'
	mrx_vbd_ds_tier_grp_ehc_d        = 'Rx VBID DS Disease Desc'
	mrx_vbd_ds_tier_phase            = 'Rx VBID DS Phase'
	mrx_vbd_ds_tier_incent_yn        = 'Rx VBID DS Incentive YN'
	mrx_vbd_ds_tier_mod_ded_yn       = 'Rx VBID DS deductible YN'
	mrx_vbd_ds_tier_mod_ded_amt      = 'Rx VBID DS mod deduct amt'
	mrx_vbd_ds_tier_cs_lis_elig_yn   = 'Rx VBID DS Vbid CS Reduct Elig'
	mrx_vbd_ds_tier_cs_lis_chk       = 'Rx VBID DS LIS Levels Chk'
	mrx_vbd_ds_tier_enr_tar          = 'Rx VBID DS Enroll Target'
	mrx_vbd_ds_tier_enr_eng          = 'Rx VBID DS Enroll Engaged'
	mrx_vbd_ds_lis_waiver_yn         = 'Rx VBID DS Waive LIS Cost'
	mrx_vbd_ds_srcs_copay_1m_num     = 'Rx VBID DS SR 1m ICP cpay'
	mrx_vbd_ds_srcs_copay_2m_num     = 'Rx VBID DS SR 2m ICP cpay'
	mrx_vbd_ds_srcs_copay_3m_num     = 'Rx VBID DS SR 3m ICP cpay'
	mrx_vbd_ds_oonp_copay_1m_num     = 'Rx VBID DS OON 1m ICP cpay'
	mrx_vbd_ds_smocs_copay_1m_num    = 'Rx VBID DS SMO 1m ICP cpay'
	mrx_vbd_ds_smocs_copay_2m_num    = 'Rx VBID DS SMO 2m ICP cpay'
	mrx_vbd_ds_smocs_copay_3m_num    = 'Rx VBID DS SMO 3m ICP cpay'
	mrx_vbd_ds_ltcp_copay_1m_num     = 'Rx VBID DS LTC 1m ICP cpay'
;

run;

proc sort data = pbp_ds_vbid out=out.pbp_ds_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_ds_vbid(obs = 10);
  title 'pbp_ds_vbid file ';
run;

proc means data = out.pbp_ds_vbid;
  title 'pbp_ds_vbid file ';
run;

proc freq data = out.pbp_ds_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_vbd_ds_tier_tm
	mrx_vbd_ds_tier_phase
	mrx_vbd_ds_tier_incent_yn
	mrx_vbd_ds_tier_mod_ded_yn
	mrx_vbd_ds_tier_cs_lis_elig_yn
	mrx_vbd_ds_tier_cs_lis_chk
	mrx_vbd_ds_lis_waiver_yn
/ missing;
run;

proc contents data = out.pbp_ds_vbid;
  title 'pbp_ds_vbid data';
run;