*pbp_Section_D_opt.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_Section_D_opt;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_identifier             $3
	pbp_d_opt_name                   $4000
	pbp_d_opt_description            $4000
	pbp_d_opt_maxplan_ben_cov_yn     $1
	pbp_d_opt_maxplan_per            $1
	pbp_d_opt_maxplan_per_d          $4000
	pbp_d_opt_apply_moop_yn          $1
	pbp_d_opt_deduct_yn              $1
	pbp_d_opt_deduct_cats            $4000
	pbp_d_opt_other_benefits         $4000
;

infile '.\pbp\pbp_Section_D_opt.txt' delimiter = '09'x
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
	pbp_d_opt_identifier
	pbp_d_opt_name
	pbp_d_opt_description
	pbp_d_amt_opt_premium
	pbp_d_opt_maxplan_ben_cov_yn
	pbp_d_opt_maxplan_ben_cov_amt
	pbp_d_opt_maxplan_per
	pbp_d_opt_maxplan_per_d
	pbp_d_opt_apply_moop_yn
	pbp_d_opt_deduct_yn
	pbp_d_opt_deduct_amt
	pbp_d_opt_deduct_cats
	pbp_d_opt_other_benefits
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
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
	pbp_d_opt_name                   = 'Opt Sup Name'
	pbp_d_opt_description            = 'Opt Sup Description'
	pbp_d_amt_opt_premium            = 'Opt Sup Premium Amt (D)'
	pbp_d_opt_maxplan_ben_cov_yn     = 'Opt Sup Max Plan YN'
	pbp_d_opt_maxplan_ben_cov_amt    = 'Opt Sup Max Plan Amt'
	pbp_d_opt_maxplan_per            = 'Opt Sup Max Plan POS Per'
	pbp_d_opt_maxplan_per_d          = 'Opt Sup Max Pln POS Desc'
	pbp_d_opt_apply_moop_yn          = 'Opt Sup Moop YN'
	pbp_d_opt_deduct_yn              = 'Opt Sup Deduct Y/N'
	pbp_d_opt_deduct_amt             = 'Opt Sup Deduct Amt'
	pbp_d_opt_deduct_cats            = 'Opt Sup Deduct Cats'
	pbp_d_opt_other_benefits         = 'Opt Sup Benefit Cats'
;

run;

proc sort data = pbp_Section_D_opt out=out.pbp_Section_D_opt;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_Section_D_opt(obs = 10);
  title 'pbp_Section_D_opt file ';
run;

proc means data = out.pbp_Section_D_opt;
  title 'pbp_Section_D_opt file ';
run;

proc freq data = out.pbp_Section_D_opt;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_identifier
	pbp_d_opt_maxplan_ben_cov_yn
	pbp_d_opt_maxplan_per
	pbp_d_opt_apply_moop_yn
	pbp_d_opt_deduct_yn
/ missing;
run;

proc contents data = out.pbp_Section_D_opt;
  title 'pbp_Section_D_opt data';
run;