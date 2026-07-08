*pbp_Section_D_OON.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_Section_D_OON;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_oon_cat_id             $10
	pbp_d_opt_oon_identifier         $3
	pbp_d_opt_oon_type_id            $1
	pbp_d_opt_oon_yn                 $1
	pbp_d_opt_oon_cstshrs_yn         $1
	pbp_d_opt_oon_coins_yn           $1
	pbp_d_opt_oon_copay_yn           $1
;

infile '.\pbp\pbp_Section_D_OON.txt' delimiter = '09'x
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
	pbp_d_opt_oon_cat_id
	pbp_d_opt_oon_identifier
	pbp_d_opt_oon_type_id
	pbp_d_opt_oon_yn
	pbp_d_opt_oon_cstshrs_yn
	pbp_d_opt_oon_coins_yn
	pbp_d_opt_oon_coins_min_pct
	pbp_d_opt_oon_coins_max_pct
	pbp_d_opt_oon_copay_yn
	pbp_d_opt_oon_copay_min_amt
	pbp_d_opt_oon_copay_max_amt
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
	pbp_d_opt_oon_cat_id             = 'Opt Sup OON Cat ID'
	pbp_d_opt_oon_identifier         = 'Opt Sup OON Packg ID'
	pbp_d_opt_oon_type_id            = 'Opt Sup OON Type ID'
	pbp_d_opt_oon_yn                 = 'OON Opt Sup YN'
	pbp_d_opt_oon_cstshrs_yn         = 'OON Opt Sup Cstshr YN'
	pbp_d_opt_oon_coins_yn           = 'OON Opt Sup Out Pt Coinsure YN'
	pbp_d_opt_oon_coins_min_pct      = 'OON Opt Sup Out Pt Min Coin'
	pbp_d_opt_oon_coins_max_pct      = 'OON Opt Sup Out Pt Max Coin'
	pbp_d_opt_oon_copay_yn           = 'OON Opt Sup Out Pt Copay YN'
	pbp_d_opt_oon_copay_min_amt      = 'OON Op Sup Out Pt Cpay Min Amt'
	pbp_d_opt_oon_copay_max_amt      = 'OON Op Sup Out Pt Cpay Max Amt'
;

run;

proc sort data = pbp_Section_D_OON out=out.pbp_Section_D_OON;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_Section_D_OON(obs = 10);
  title 'pbp_Section_D_OON file ';
run;

proc means data = out.pbp_Section_D_OON;
  title 'pbp_Section_D_OON file ';
run;

proc freq data = out.pbp_Section_D_OON;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_oon_identifier
	pbp_d_opt_oon_type_id
	pbp_d_opt_oon_yn
	pbp_d_opt_oon_cstshrs_yn
	pbp_d_opt_oon_coins_yn
	pbp_d_opt_oon_copay_yn
/ missing;
run;

proc contents data = out.pbp_Section_D_OON;
  title 'pbp_Section_D_OON data';
run;