*pbp_Section_C_OON.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_Section_C_OON;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_c_oon_outpt_group_num_id     $3
	pbp_c_oon_outpt_grp_lbl          $250
	pbp_c_oon_outpt_bendesc_ben      $2
	pbp_c_oon_out_mc_bendesc_cats    $4000
	pbp_c_oon_out_nmc_bendesc_cats   $4000
	pbp_c_oon_outpt_maxplan_yn       $1
	pbp_c_oon_outpt_maxplan_per      $1
	pbp_c_oon_outpt_maxplan_per_d    $4000
	pbp_c_oon_outpt_coins_yn         $1
	pbp_c_oon_outpt_copay_yn         $1
	pbp_c_oon_outpt_ded_yn           $1
;

infile '.\pbp\pbp_Section_C_OON.txt' delimiter = '09'x
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
	pbp_c_oon_outpt_group_num_id
	pbp_c_oon_outpt_grp_lbl
	pbp_c_oon_outpt_bendesc_ben
	pbp_c_oon_out_mc_bendesc_cats
	pbp_c_oon_out_nmc_bendesc_cats
	pbp_c_oon_outpt_maxplan_yn
	pbp_c_oon_outpt_maxplan_amt
	pbp_c_oon_outpt_maxplan_per
	pbp_c_oon_outpt_maxplan_per_d
	pbp_c_oon_outpt_coins_yn
	pbp_c_oon_outpt_coins_min_pct
	pbp_c_oon_outpt_coins_max_pct
	pbp_c_oon_outpt_copay_yn
	pbp_c_oon_outpt_copay_min_amt
	pbp_c_oon_outpt_copay_max_amt
	pbp_c_oon_outpt_ded_yn
	pbp_c_oon_outpt_ded_amt
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
	pbp_c_oon_outpt_group_num_id     = 'OON ID'
	pbp_c_oon_outpt_grp_lbl          = 'OON Group Out Pt Label'
	pbp_c_oon_outpt_bendesc_ben      = 'OON Group Ben Cats Types'
	pbp_c_oon_out_mc_bendesc_cats    = 'OON Group Out Pt MC Ben Cats'
	pbp_c_oon_out_nmc_bendesc_cats   = 'OON Group Non-MC Ben Cats'
	pbp_c_oon_outpt_maxplan_yn       = 'OON Group Max Plan YN'
	pbp_c_oon_outpt_maxplan_amt      = 'OON Group Max Plan Amt'
	pbp_c_oon_outpt_maxplan_per      = 'OON Group Max Plan Period'
	pbp_c_oon_outpt_maxplan_per_d    = 'OON Group Max Plan Prd Desc'
	pbp_c_oon_outpt_coins_yn         = 'OON Group Coinsurance YN'
	pbp_c_oon_outpt_coins_min_pct    = 'OON Group Min Coins Pct'
	pbp_c_oon_outpt_coins_max_pct    = 'OON Group Max Coins Pct'
	pbp_c_oon_outpt_copay_yn         = 'OON Group Copay YN'
	pbp_c_oon_outpt_copay_min_amt    = 'OON Group Copay Min Amt'
	pbp_c_oon_outpt_copay_max_amt    = 'OON Group Copay Max Amt'
	pbp_c_oon_outpt_ded_yn           = 'OON Group Deductible YN'
	pbp_c_oon_outpt_ded_amt          = 'OON Group Deductible Amt'
;

run;

proc sort data = pbp_Section_C_OON out=out.pbp_Section_C_OON;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_Section_C_OON(obs = 10);
  title 'pbp_Section_C_OON file ';
run;

proc means data = out.pbp_Section_C_OON;
  title 'pbp_Section_C_OON file ';
run;

proc freq data = out.pbp_Section_C_OON;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_c_oon_outpt_group_num_id
	pbp_c_oon_outpt_bendesc_ben
	pbp_c_oon_outpt_maxplan_yn
	pbp_c_oon_outpt_maxplan_per
	pbp_c_oon_outpt_coins_yn
	pbp_c_oon_outpt_copay_yn
	pbp_c_oon_outpt_ded_yn
/ missing;
run;

proc contents data = out.pbp_Section_C_OON;
  title 'pbp_Section_C_OON data';
run;