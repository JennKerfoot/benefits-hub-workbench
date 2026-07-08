*pbp_b19b_model_test_vbid_uf.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b19b_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b19b_package_type            $2
	pbp_b19b_package_name            $4000
	pbp_b19b_tm_vbid                 $3
	pbp_b19b_states_ehc_vbd          $10
	pbp_b19b_states_ehc_vbd_d        $4000
	pbp_b19b_all_dis_yn              $1
	pbp_b19b_cmb_dis_yn              $1
	pbp_b19b_cmb_dis_d               $4000
	pbp_b19b_lis_vbid                $5
	pbp_b19b_states_ehc_ssbci        $27
	pbp_b19b_states_ssbci_other1     $250
	pbp_b19b_states_ssbci_other2     $250
	pbp_b19b_states_ssbci_other3     $250
	pbp_b19b_states_ssbci_other4     $250
	pbp_b19b_states_ssbci_other5     $250
	pbp_b19b_states_ehc_uf           $14
	pbp_b19b_states_uf_other1        $250
	pbp_b19b_states_uf_other2        $250
	pbp_b19b_states_uf_other3        $250
	pbp_b19b_states_uf_other4        $250
	pbp_b19b_states_uf_other5        $250
	pbp_b19b_states_uf_all_yn        $1
	pbp_b19b_states_uf_cmb_yn        $1
	pbp_b19b_states_uf_cmb_d         $4000
	pbp_b19b_add_prereq_yn           $1
	pbp_b19b_add_prereq              $3
	pbp_b19b_add_prereq_d            $4000
	pbp_b19b_add_nmc_bendesc_cats    $4000
	pbp_b19b_add_apply_yn            $1
	pbp_b19b_add_exempt_yn           $1
	pbp_b19b_add_exempt_nmc_cats     $4000
	pbp_b19b_agg_yn                  $1
	pbp_b19b_agg_period              $1
	pbp_b19b_agg_period_d            $4000
	pbp_b19b_agg_mode                $5
	pbp_b19b_agg_mode_desc           $4000
	pbp_b19b_agg_nmc_bendesc_cats    $4000
;

infile '.\pbp\pbp_b19b_model_test_vbid_uf.txt' delimiter = '09'x
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
	pbp_b19b_package_type
	pbp_b19b_package_name
	pbp_b19b_tm_vbid
	pbp_b19b_states_ehc_vbd
	pbp_b19b_states_ehc_vbd_d
	pbp_b19b_all_dis_yn
	pbp_b19b_cmb_dis_yn
	pbp_b19b_cmb_dis_d
	pbp_b19b_lis_vbid
	pbp_b19b_enr_tar_vbid
	pbp_b19b_enr_eng_vbid
	pbp_b19b_states_ehc_ssbci
	pbp_b19b_states_ssbci_other1
	pbp_b19b_states_ssbci_other2
	pbp_b19b_states_ssbci_other3
	pbp_b19b_states_ssbci_other4
	pbp_b19b_states_ssbci_other5
	pbp_b19b_states_ehc_uf
	pbp_b19b_states_uf_other1
	pbp_b19b_states_uf_other2
	pbp_b19b_states_uf_other3
	pbp_b19b_states_uf_other4
	pbp_b19b_states_uf_other5
	pbp_b19b_states_uf_all_yn
	pbp_b19b_states_uf_cmb_yn
	pbp_b19b_states_uf_cmb_d
	pbp_b19b_add_prereq_yn
	pbp_b19b_add_prereq
	pbp_b19b_add_prereq_d
	pbp_b19b_add_nmc_bendesc_cats
	pbp_b19b_add_apply_yn
	pbp_b19b_add_exempt_yn
	pbp_b19b_add_exempt_nmc_cats
	pbp_b19b_agg_yn
	pbp_b19b_agg_amt
	pbp_b19b_agg_period
	pbp_b19b_agg_period_d
	pbp_b19b_agg_mode
	pbp_b19b_agg_mode_desc
	pbp_b19b_agg_nmc_bendesc_cats
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
	pbp_b19b_package_type            = '19B package type'
	pbp_b19b_package_name            = '19B package name'
	pbp_b19b_tm_vbid                 = '19B VBID Pop Target Method'
	pbp_b19b_states_ehc_vbd          = '19B VBID Pop Diseases'
	pbp_b19b_states_ehc_vbd_d        = '19B Other Disease desc'
	pbp_b19b_all_dis_yn              = '19B VBID Pop All Disease YN'
	pbp_b19b_cmb_dis_yn              = '19B VBID Pop Combined Disease'
	pbp_b19b_cmb_dis_d               = '19B VBID Pop Combined Desc'
	pbp_b19b_lis_vbid                = '19B VBID Pop LIS Reduction'
	pbp_b19b_enr_tar_vbid            = '19B VBID Pop # Enroll Target'
	pbp_b19b_enr_eng_vbid            = '19B VBID Pop # Enroll Engaged'
	pbp_b19b_states_ehc_ssbci        = '19B SSBCI chronic condition'
	pbp_b19b_states_ssbci_other1     = '19B SSBCI disease other 1'
	pbp_b19b_states_ssbci_other2     = '19B SSBCI disease other 2'
	pbp_b19b_states_ssbci_other3     = '19B SSBCI disease other 3'
	pbp_b19b_states_ssbci_other4     = '19B SSBCI disease other 4'
	pbp_b19b_states_ssbci_other5     = '19B SSBCI disease other 5'
	pbp_b19b_states_ehc_uf           = '19B uf Disease states'
	pbp_b19b_states_uf_other1        = '19B UF disease other 1'
	pbp_b19b_states_uf_other2        = '19B UF disease other 2'
	pbp_b19b_states_uf_other3        = '19B UF disease other 3'
	pbp_b19b_states_uf_other4        = '19B UF disease other 4'
	pbp_b19b_states_uf_other5        = '19B UF disease other 5'
	pbp_b19b_states_uf_all_yn        = '19B Need All Diseases YN'
	pbp_b19b_states_uf_cmb_yn        = '19B Need Cmb Diseases YN'
	pbp_b19b_states_uf_cmb_d         = '19B Need Cmb Diseases Desc'
	pbp_b19b_add_prereq_yn           = '19B Add prerequisite YN'
	pbp_b19b_add_prereq              = '19B Add prerequisite'
	pbp_b19b_add_prereq_d            = '19B Add prerequisite Desc'
	pbp_b19b_add_nmc_bendesc_cats    = '19B NMC Rdc Coin Benft Svcs'
	pbp_b19b_add_apply_yn            = '19B Apply OON/POS YN'
	pbp_b19b_add_exempt_yn           = '19B Exempt deduct YN'
	pbp_b19b_add_exempt_nmc_cats     = '19B NMC Rdc Coin Benft Svcs'
	pbp_b19b_agg_yn                  = '19B max benefit amount yn'
	pbp_b19b_agg_amt                 = '19B max benefit amount'
	pbp_b19b_agg_period              = '19B max benefit period'
	pbp_b19b_agg_period_d            = '19B max ben period Desc'
	pbp_b19b_agg_mode                = '19B aggregate deliver mode'
	pbp_b19b_agg_mode_desc           = '19B agg othr deliver mode'
	pbp_b19b_agg_nmc_bendesc_cats    = '19B max benefit nmc cats'
;

run;

proc sort data = pbp_b19b_vbid out=out.pbp_b19b_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b19b_vbid(obs = 10);
  title 'pbp_b19b_model_test_vbid_uf file ';
run;

proc means data = out.pbp_b19b_vbid;
  title 'pbp_b19b_model_test_vbid_uf file ';
run;

proc freq data = out.pbp_b19b_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b19b_package_type
	pbp_b19b_tm_vbid
	pbp_b19b_all_dis_yn
	pbp_b19b_cmb_dis_yn
	pbp_b19b_lis_vbid
	pbp_b19b_states_uf_all_yn
	pbp_b19b_states_uf_cmb_yn
	pbp_b19b_add_prereq_yn
	pbp_b19b_add_prereq
	pbp_b19b_add_apply_yn
	pbp_b19b_add_exempt_yn
	pbp_b19b_agg_yn
	pbp_b19b_agg_period
	pbp_b19b_agg_mode
/ missing;
run;

proc contents data = out.pbp_b19b_vbid;
  title 'pbp_b19b_vbid data';
run;