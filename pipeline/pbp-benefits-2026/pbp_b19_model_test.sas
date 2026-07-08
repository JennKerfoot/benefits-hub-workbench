*pbp_b19_model_test.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b19;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_b19a_uf_yn                   $1
	pbp_b19a_ssbci_yn                $1
	pbp_b19a_ssbci_bendesc           $2
	pbp_b19a_vbd_yn                  $1
	pbp_b19a_attestation             $1
	pbp_b19a_reduct_cost_yn          $1
	pbp_b19b_add_cost_yn             $1
;

infile '.\pbp\pbp_b19_model_test.txt' delimiter = '09'x
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
	pbp_b19a_uf_yn
	pbp_b19a_ssbci_yn
	pbp_b19a_ssbci_bendesc
	pbp_b19a_vbd_yn
	pbp_b19a_attestation
	pbp_b19a_reduct_cost_yn
	pbp_b19a_reduct_package_num
	pbp_b19b_add_cost_yn
	pbp_b19b_add_package_num
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
	pbp_b19a_uf_yn                   = 'B19 Uniform flex YN'
	pbp_b19a_ssbci_yn                = 'B19 SSBCI yn'
	pbp_b19a_ssbci_bendesc           = 'B19 SSBCI type'
	pbp_b19a_vbd_yn                  = 'B19 VBID Reduced or Add Ben YN'
	pbp_b19a_attestation             = 'B19 VBID  Attestation'
	pbp_b19a_reduct_cost_yn          = 'B19 Reduced Cost Sharing YN'
	pbp_b19a_reduct_package_num      = 'B19 Reduction Benefit Packages'
	pbp_b19b_add_cost_yn             = '19B Add Benefits YN'
	pbp_b19b_add_package_num         = '19B Add Benefit Packages'
;

run;

proc sort data = pbp_b19 out=out.pbp_b19;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b19(obs = 10);
  title 'pbp_b19_model_test file ';
run;

proc means data = out.pbp_b19;
  title 'pbp_b19_model_test file ';
run;

proc freq data = out.pbp_b19;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_b19a_uf_yn
	pbp_b19a_ssbci_yn
	pbp_b19a_ssbci_bendesc
	pbp_b19a_vbd_yn
	pbp_b19a_attestation
	pbp_b19a_reduct_cost_yn
	pbp_b19b_add_cost_yn
/ missing;
run;

proc contents data = out.pbp_b19;
  title 'pbp_b19 data';
run;