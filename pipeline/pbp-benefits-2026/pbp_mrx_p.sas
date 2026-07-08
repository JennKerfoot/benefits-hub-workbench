*pbp_mrx_p.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_mrx_p;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	part_d_model_demo                $1
	part_d_enhncd_cvrg_demo          $1
	mrx_tier_post_label_list         $250
	mrx_tier_post_benefit_type       $1
	mrx_tier_post_form_model_desc    $4000
	mrx_tier_post_id                 $1
	mrx_tier_post_type_id            $1
	mrx_tier_post_drug_type          $2
	mrx_tier_post_includes           $1
	mrx_tier_post_cost_struct        $1
;

infile '.\pbp\pbp_mrx_p.txt' delimiter = '09'x
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
	mrx_tier_post_label_list
	mrx_tier_post_benefit_type
	mrx_tier_post_form_model_desc
	mrx_tier_post_id
	mrx_tier_post_type_id
	mrx_tier_post_drug_type
	mrx_tier_post_includes
	mrx_tier_post_cost_struct
	mrx_tier_post_copay_amt
	mrx_tier_post_coins_pct
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
	mrx_tier_post_label_list         = 'MRx OOP Tier Label Description'
	mrx_tier_post_benefit_type       = 'MRx Post Tier Drg Ben Type OOP'
	mrx_tier_post_form_model_desc    = 'MRx Tier Label Description'
	mrx_tier_post_id                 = 'MRx Post Tier ID - OOP'
	mrx_tier_post_type_id            = 'MRx Post Tier Type ID'
	mrx_tier_post_drug_type          = 'MRx Post Tier Drug Type'
	mrx_tier_post_includes           = 'MRX Post Tier Includes'
	mrx_tier_post_cost_struct        = 'MRx Post Tier Cst Sh Grp Struc'
	mrx_tier_post_copay_amt          = 'MRx Post Tier Copay Amt'
	mrx_tier_post_coins_pct          = 'MRx Post Tier Coinsurance Pct'
;

run;

proc sort data = pbp_mrx_p out=out.pbp_mrx_p;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_mrx_p(obs = 10);
  title 'pbp_mrx_p file ';
run;

proc means data = out.pbp_mrx_p;
  title 'pbp_mrx_p file ';
run;

proc freq data = out.pbp_mrx_p;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	part_d_model_demo
	part_d_enhncd_cvrg_demo
	mrx_tier_post_benefit_type
	mrx_tier_post_id
	mrx_tier_post_type_id
	mrx_tier_post_drug_type
	mrx_tier_post_includes
	mrx_tier_post_cost_struct
/ missing;
run;

proc contents data = out.pbp_mrx_p;
  title 'pbp_mrx_p data';
run;