*pbp_b3_cardiac_rehab.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b3;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_b3_bendesc_yn                $1
	pbp_b3_bendesc_ehc               $4
	pbp_b3_bendesc_amo_crs           $1
	pbp_b3_bendesc_lim_crs           $1
	pbp_b3_bendesc_per_crs           $1
	pbp_b3_bendesc_per_crs_d         $4000
	pbp_b3_bendesc_amo_icrs          $1
	pbp_b3_bendesc_lim_icrs          $1
	pbp_b3_bendesc_per_icrs          $1
	pbp_b3_bendesc_per_icrs_d        $4000
	pbp_b3_bendesc_amo_prs           $1
	pbp_b3_bendesc_lim_prs           $1
	pbp_b3_bendesc_per_prs           $1
	pbp_b3_bendesc_per_prs_d         $4000
	pbp_b3_bendesc_amo_setpad        $1
	pbp_b3_bendesc_lim_setpad        $1
	pbp_b3_bendesc_per_setpad        $1
	pbp_b3_bendesc_per_setpad_d      $4000
	pbp_b3_maxenr_yn                 $1
	pbp_b3_maxenr_per                $1
	pbp_b3_maxenr_per_d              $4000
	pbp_b3_coins_yn                  $1
	pbp_b3_coins_ehc                 $8
	pbp_b3_ded_yn                    $1
	pbp_b3_copay_yn                  $1
	pbp_b3_copay_ehc                 $8
	pbp_b3_auth_yn                   $1
	pbp_b3_refer_yn                  $1
;

infile '.\pbp\pbp_b3_cardiac_rehab.txt' delimiter = '09'x
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
	pbp_b3_bendesc_yn
	pbp_b3_bendesc_ehc
	pbp_b3_bendesc_amo_crs
	pbp_b3_bendesc_lim_crs
	pbp_b3_bendesc_numv_crs
	pbp_b3_bendesc_per_crs
	pbp_b3_bendesc_per_crs_d
	pbp_b3_bendesc_amo_icrs
	pbp_b3_bendesc_lim_icrs
	pbp_b3_bendesc_numv_icrs
	pbp_b3_bendesc_per_icrs
	pbp_b3_bendesc_per_icrs_d
	pbp_b3_bendesc_amo_prs
	pbp_b3_bendesc_lim_prs
	pbp_b3_bendesc_numv_prs
	pbp_b3_bendesc_per_prs
	pbp_b3_bendesc_per_prs_d
	pbp_b3_bendesc_amo_setpad
	pbp_b3_bendesc_lim_setpad
	pbp_b3_bendesc_numv_setpad
	pbp_b3_bendesc_per_setpad
	pbp_b3_bendesc_per_setpad_d
	pbp_b3_maxenr_yn
	pbp_b3_maxenr_amt
	pbp_b3_maxenr_per
	pbp_b3_maxenr_per_d
	pbp_b3_coins_yn
	pbp_b3_coins_ehc
	pbp_b3_coins_pct_mc_min_crs
	pbp_b3_coins_pct_mc_max_crs
	pbp_b3_coins_pct_mc_min_icrs
	pbp_b3_coins_pct_mc_max_icrs
	pbp_b3_coins_pct_mc_min_prs
	pbp_b3_coins_pct_mc_max_prs
	pbp_b3_coins_pct_mc_min_setpad
	pbp_b3_coins_pct_mc_max_setpad
	pbp_b3_coins_pct_min_crs
	pbp_b3_coins_pct_max_crs
	pbp_b3_coins_pct_min_icrs
	pbp_b3_coins_pct_max_icrs
	pbp_b3_coins_pct_min_prs
	pbp_b3_coins_pct_max_prs
	pbp_b3_coins_pct_min_setpad
	pbp_b3_coins_pct_max_setpad
	pbp_b3_ded_yn
	pbp_b3_ded_amt
	pbp_b3_copay_yn
	pbp_b3_copay_ehc
	pbp_b3_copay_amt_mc_min_crs
	pbp_b3_copay_amt_mc_max_crs
	pbp_b3_copay_amt_mc_min_icrs
	pbp_b3_copay_amt_mc_max_icrs
	pbp_b3_copay_amt_mc_min_prs
	pbp_b3_copay_amt_mc_max_prs
	pbp_b3_copay_amt_mc_min_setpad
	pbp_b3_copay_amt_mc_max_setpad
	pbp_b3_copay_amt_min_crs
	pbp_b3_copay_amt_max_crs
	pbp_b3_copay_amt_min_icrs
	pbp_b3_copay_amt_max_icrs
	pbp_b3_copay_amt_min_prs
	pbp_b3_copay_amt_max_prs
	pbp_b3_copay_amt_min_setpad
	pbp_b3_copay_amt_max_setpad
	pbp_b3_auth_yn
	pbp_b3_refer_yn
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
	pbp_b3_bendesc_yn                = 'Cardiac Pulm Rehab Ben Desc YN'
	pbp_b3_bendesc_ehc               = 'Enhanced (3) Supp benefits'
	pbp_b3_bendesc_amo_crs           = 'Cardiac Rehab Srvcs AMO'
	pbp_b3_bendesc_lim_crs           = 'Benefit Unlimited CRS?'
	pbp_b3_bendesc_numv_crs          = 'Num of Visits for CRS'
	pbp_b3_bendesc_per_crs           = 'CRS Num Visits Periodicity'
	pbp_b3_bendesc_per_crs_d         = 'CRS Num Visits Period Desc'
	pbp_b3_bendesc_amo_icrs          = 'ICRS AMO'
	pbp_b3_bendesc_lim_icrs          = 'Benefit Unlimited ICRS?'
	pbp_b3_bendesc_numv_icrs         = 'Num of Visits ICRS'
	pbp_b3_bendesc_per_icrs          = 'ICRS periodicity'
	pbp_b3_bendesc_per_icrs_d        = 'ICRS Num Visits Period Desc'
	pbp_b3_bendesc_amo_prs           = 'Benefit for AMO PRS'
	pbp_b3_bendesc_lim_prs           = 'Benefit unlimited PRS?'
	pbp_b3_bendesc_numv_prs          = 'Num of Visits PRS'
	pbp_b3_bendesc_per_prs           = 'PRS periodicity'
	pbp_b3_bendesc_per_prs_d         = 'PRS Num Visits Period Desc'
	pbp_b3_bendesc_amo_setpad        = 'SETPAD Srvcs AMO'
	pbp_b3_bendesc_lim_setpad        = 'Benefit Unlimited SETPAD?'
	pbp_b3_bendesc_numv_setpad       = 'Num of Visits for SETPAD'
	pbp_b3_bendesc_per_setpad        = 'SETPAD Num Visits Periodicity'
	pbp_b3_bendesc_per_setpad_d      = 'SETPAD Num Visits Period Desc'
	pbp_b3_maxenr_yn                 = 'Cardiac Rehab Max Enr YN'
	pbp_b3_maxenr_amt                = 'Cardiac Rehab Max Enr Amt'
	pbp_b3_maxenr_per                = 'Cardiac Rehab Max Enr Per'
	pbp_b3_maxenr_per_d              = 'Cardi Rehab Max Enr Per Desc'
	pbp_b3_coins_yn                  = 'Cardiac Rehab Coinsurance YN'
	pbp_b3_coins_ehc                 = 'Cardiac Srvcs Coin Enha'
	pbp_b3_coins_pct_mc_min_crs      = 'Cardiac Rehab MC Min Coins Pct'
	pbp_b3_coins_pct_mc_max_crs      = 'Cardiac Rehab MC Max Coins Pct'
	pbp_b3_coins_pct_mc_min_icrs     = 'Min Coins PCT MC ICRS'
	pbp_b3_coins_pct_mc_max_icrs     = 'Max Coins pct  MC ICRS'
	pbp_b3_coins_pct_mc_min_prs      = 'Min Coins Pct MC PRS'
	pbp_b3_coins_pct_mc_max_prs      = 'Max Coins PCT MC PRS'
	pbp_b3_coins_pct_mc_min_setpad   = 'Min Coins Pct MC SETP'
	pbp_b3_coins_pct_mc_max_setpad   = 'Max Coins PCT MC SETP'
	pbp_b3_coins_pct_min_crs         = 'Min Coins Pct Add CRS'
	pbp_b3_coins_pct_max_crs         = 'Max Coins PCT Add ICR'
	pbp_b3_coins_pct_min_icrs        = 'Min Coins PCT ICRS'
	pbp_b3_coins_pct_max_icrs        = 'Max Coins Pct ICRS'
	pbp_b3_coins_pct_min_prs         = 'Min Coins PCT Add PRS'
	pbp_b3_coins_pct_max_prs         = 'Max Coins PCT Add PRS'
	pbp_b3_coins_pct_min_setpad      = 'Min Coins PCT SETPAD'
	pbp_b3_coins_pct_max_setpad      = 'Max Coins PCT Add SET'
	pbp_b3_ded_yn                    = 'Cardiac Rehab Deductible YN'
	pbp_b3_ded_amt                   = 'Cardiac Rehab Deductible Amt'
	pbp_b3_copay_yn                  = 'Cardiac Rehab Copayment YN'
	pbp_b3_copay_ehc                 = 'Cardiac Srvcs Copay Enhan'
	pbp_b3_copay_amt_mc_min_crs      = 'Cardiac Rehab MC Min Copay Amt'
	pbp_b3_copay_amt_mc_max_crs      = 'Cardiac Rehab MC Max Copay Amt'
	pbp_b3_copay_amt_mc_min_icrs     = 'Min Copay Amt MC ICRS'
	pbp_b3_copay_amt_mc_max_icrs     = 'Max Copay Amt MC ICRS'
	pbp_b3_copay_amt_mc_min_prs      = 'Min Copay Amount MC PRS'
	pbp_b3_copay_amt_mc_max_prs      = 'Max Copay Amt MC PRS'
	pbp_b3_copay_amt_mc_min_setpad   = 'Min Copay Amount MC SETPAD'
	pbp_b3_copay_amt_mc_max_setpad   = 'Max Copay Amt MC SETPAD'
	pbp_b3_copay_amt_min_crs         = 'Min Copay Amt Add CRS'
	pbp_b3_copay_amt_max_crs         = 'Max Copay Amt Add CRS'
	pbp_b3_copay_amt_min_icrs        = 'Min Copay Amt Add ICRS'
	pbp_b3_copay_amt_max_icrs        = 'Max Copay Amt Add ICRS'
	pbp_b3_copay_amt_min_prs         = 'Min Copay Amt Add PRS'
	pbp_b3_copay_amt_max_prs         = 'Max Copay Amt Add PRS'
	pbp_b3_copay_amt_min_setpad      = 'Min Copay Amt Add SETPAD'
	pbp_b3_copay_amt_max_setpad      = 'Max Copay Amt Add SETPAD'
	pbp_b3_auth_yn                   = 'Cardiac Rehab Auth YN'
	pbp_b3_refer_yn                  = 'Cardiac Rehab Refer YN'
;

run;

proc sort data = pbp_b3 out=out.pbp_b3;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b3(obs = 10);
  title 'pbp_b3_cardiac_rehab file ';
run;

proc means data = out.pbp_b3;
  title 'pbp_b3_cardiac_rehab file ';
run;

proc freq data = out.pbp_b3;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_b3_bendesc_yn
	pbp_b3_bendesc_ehc
	pbp_b3_bendesc_amo_crs
	pbp_b3_bendesc_lim_crs
	pbp_b3_bendesc_per_crs
	pbp_b3_bendesc_amo_icrs
	pbp_b3_bendesc_lim_icrs
	pbp_b3_bendesc_per_icrs
	pbp_b3_bendesc_amo_prs
	pbp_b3_bendesc_lim_prs
	pbp_b3_bendesc_per_prs
	pbp_b3_bendesc_amo_setpad
	pbp_b3_bendesc_lim_setpad
	pbp_b3_bendesc_per_setpad
	pbp_b3_maxenr_yn
	pbp_b3_maxenr_per
	pbp_b3_coins_yn
	pbp_b3_ded_yn
	pbp_b3_copay_yn
	pbp_b3_auth_yn
	pbp_b3_refer_yn
/ missing;
run;

proc contents data = out.pbp_b3;
  title 'pbp_b3 data';
run;