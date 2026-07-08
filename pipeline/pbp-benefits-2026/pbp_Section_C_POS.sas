*pbp_Section_C_POS.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_Section_C_POS;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_c_pos_outpt_group_num_id     $2
	pbp_c_pos_group_lbl              $250
	pbp_c_pos_oupt_bencat_bens       $2
	pbp_c_pos_outpt_mc_bencats       $4000
	pbp_c_pos_outpt_nmc_bencats      $4000
	pbp_c_pos_outpt_coins_yn         $1
	pbp_c_pos_outpt_copay_yn         $1
	pbp_c_pos_outpt_maxplan_yn       $1
	pbp_c_pos_outpt_maxplan_per      $1
	pbp_c_pos_outpt_maxplan_per_d    $4000
	pbp_c_pos_outpt_deduct_yn        $1
;

infile '.\pbp\pbp_Section_C_POS.txt' delimiter = '09'x
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
	pbp_c_pos_outpt_group_num_id
	pbp_c_pos_group_lbl
	pbp_c_pos_oupt_bencat_bens
	pbp_c_pos_outpt_mc_bencats
	pbp_c_pos_outpt_nmc_bencats
	pbp_c_pos_outpt_coins_yn
	pbp_c_pos_outpt_coins_min_pct
	pbp_c_pos_outpt_coins_max_pct
	pbp_c_pos_outpt_copay_yn
	pbp_c_pos_outpt_copay_min_amt
	pbp_c_pos_outpt_copay_max_amt
	pbp_c_pos_outpt_maxplan_yn
	pbp_c_pos_outpt_maxplan_amt
	pbp_c_pos_outpt_maxplan_per
	pbp_c_pos_outpt_maxplan_per_d
	pbp_c_pos_outpt_deduct_yn
	pbp_c_pos_outpt_deduct_amt
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
	pbp_c_pos_outpt_group_num_id     = 'POS Group ID'
	pbp_c_pos_group_lbl              = 'POS Group Label'
	pbp_c_pos_oupt_bencat_bens       = 'POS Group Benefit Types'
	pbp_c_pos_outpt_mc_bencats       = 'POS Group MC Ben Cats'
	pbp_c_pos_outpt_nmc_bencats      = 'POS Group Non-MC Bene Cats'
	pbp_c_pos_outpt_coins_yn         = 'POS Group Coinsurance YN'
	pbp_c_pos_outpt_coins_min_pct    = 'POS Group Min Coins Pct'
	pbp_c_pos_outpt_coins_max_pct    = 'POS Group Max Coins Pct'
	pbp_c_pos_outpt_copay_yn         = 'POS Group Copay YN'
	pbp_c_pos_outpt_copay_min_amt    = 'POS Group Copay Min Amt'
	pbp_c_pos_outpt_copay_max_amt    = 'POS Group Copay Max Amt'
	pbp_c_pos_outpt_maxplan_yn       = 'POS Group Max Plan YN'
	pbp_c_pos_outpt_maxplan_amt      = 'POS Group Max Plan Amt'
	pbp_c_pos_outpt_maxplan_per      = 'POS Group Max Plan Per'
	pbp_c_pos_outpt_maxplan_per_d    = 'POS Group Max Plan Per Desc'
	pbp_c_pos_outpt_deduct_yn        = 'POS Group Deductible YN'
	pbp_c_pos_outpt_deduct_amt       = 'POS Group Deductible Amt'
;

run;

proc sort data = pbp_Section_C_POS out=out.pbp_Section_C_POS;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_Section_C_POS(obs = 10);
  title 'pbp_Section_C_POS file ';
run;

proc means data = out.pbp_Section_C_POS;
  title 'pbp_Section_C_POS file ';
run;

proc freq data = out.pbp_Section_C_POS;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_c_pos_outpt_group_num_id
	pbp_c_pos_oupt_bencat_bens
	pbp_c_pos_outpt_coins_yn
	pbp_c_pos_outpt_copay_yn
	pbp_c_pos_outpt_maxplan_yn
	pbp_c_pos_outpt_maxplan_per
	pbp_c_pos_outpt_deduct_yn
/ missing;
run;

proc contents data = out.pbp_Section_C_POS;
  title 'pbp_Section_C_POS data';
run;