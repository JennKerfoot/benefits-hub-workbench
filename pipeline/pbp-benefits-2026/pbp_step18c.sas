*pbp_step18c.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step18c;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_18c_yn        $1
	pbp_b18c_bendesc_amo             $1
	pbp_b18c_maxplan_yn              $1
	pbp_b18c_maxplan_aid_type        $1
	pbp_b18c_maxplan_in_oon          $1
	pbp_b18c_maxplan_per             $1
	pbp_b18c_maxplan_per_desc        $4000
	pbp_b18c_maxenr_yn               $1
	pbp_b18c_maxenr_per              $1
	pbp_b18c_maxenr_per_desc         $4000
	pbp_b18c_ded_yn                  $1
	pbp_b18c_bendesc_lim             $1
	pbp_b18c_bendesc_per             $1
	pbp_b18c_bendesc_desc            $4000
	pbp_b18c_coins_yn                $1
	pbp_b18c_copay_yn                $1
	pbp_b18c_auth_yn                 $1
	pbp_b18c_refer_yn                $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step18c.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_18c_yn
	pbp_b18c_bendesc_amo
	pbp_b18c_maxplan_yn
	pbp_b18c_maxplan_aid_type
	pbp_b18c_maxplan_in_oon
	pbp_b18c_maxplan_amt
	pbp_b18c_maxplan_per
	pbp_b18c_maxplan_per_desc
	pbp_b18c_maxenr_yn
	pbp_b18c_maxenr_amt
	pbp_b18c_maxenr_per
	pbp_b18c_maxenr_per_desc
	pbp_b18c_ded_yn
	pbp_b18c_ded_amt
	pbp_b18c_bendesc_lim
	pbp_b18c_bendesc_num
	pbp_b18c_bendesc_per
	pbp_b18c_bendesc_desc
	pbp_b18c_coins_yn
	pbp_b18c_coins_pct
	pbp_b18c_coins_pct_min
	pbp_b18c_coins_pct_max
	pbp_b18c_copay_yn
	pbp_b18c_copay_amt
	pbp_b18c_copay_amt_min
	pbp_b18c_copay_amt_max
	pbp_b18c_auth_yn
	pbp_b18c_refer_yn
	pbp_d_opt_identifier
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
	pbp_d_opt_use_mand_18c_yn        = 'OppSupp Cost Same INN 18C YN'
	pbp_b18c_bendesc_amo             = 'OTC Hear Aids Ben AMO'
	pbp_b18c_maxplan_yn              = 'OTC Hear Aids Max Plan YN'
	pbp_b18c_maxplan_aid_type        = 'OTC Hear Aids Max Aid Type'
	pbp_b18c_maxplan_in_oon          = 'OTC Hear Aids INN or OON'
	pbp_b18c_maxplan_amt             = 'OTC Hear Aids Max Plan Amt'
	pbp_b18c_maxplan_per             = 'OTC Hear Aids Max Plan Per'
	pbp_b18c_maxplan_per_desc        = 'OTC Hear Aids Max Plan Desc'
	pbp_b18c_maxenr_yn               = 'OTC Hear Aids Max Enr YN'
	pbp_b18c_maxenr_amt              = 'OTC Hear Aids Max Enr Amt'
	pbp_b18c_maxenr_per              = 'OTC Hear Aids Max Enr Per'
	pbp_b18c_maxenr_per_desc         = 'OTC Hear Aids Max Enr Other'
	pbp_b18c_ded_yn                  = 'OTC Hear Aids Deductible YN'
	pbp_b18c_ded_amt                 = 'OTC Hear Aids Deductible Amt'
	pbp_b18c_bendesc_lim             = 'OTC Hear Aids Ben Desc Lim YN'
	pbp_b18c_bendesc_num             = 'OTC Hear Aids Ben Desc Num'
	pbp_b18c_bendesc_per             = 'OTC Hear Aids Ben Desc Per'
	pbp_b18c_bendesc_desc            = 'OTC Hear Aids Ben Per Desc'
	pbp_b18c_coins_yn                = 'OTC Hear Aids Coins YN'
	pbp_b18c_coins_pct               = 'OTC Hear Aids Coins Pct'
	pbp_b18c_coins_pct_min           = 'OTC Hear Aids Min Coins Pct'
	pbp_b18c_coins_pct_max           = 'OTC Hear Aids Max Coins Pct'
	pbp_b18c_copay_yn                = 'OTC Hear Aids Copayment YN'
	pbp_b18c_copay_amt               = 'OTC Hear Aids Copay Amt'
	pbp_b18c_copay_amt_min           = 'OTC Hear Aids Min Copay Amt'
	pbp_b18c_copay_amt_max           = 'OTC Hear Aids Max Copay Amt'
	pbp_b18c_auth_yn                 = 'OTC Hear Aids Auth YN'
	pbp_b18c_refer_yn                = 'OTC Hear Aids Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step18c out=out.pbp_step18c;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step18c(obs = 10);
  title 'pbp_step18c file ';
run;

proc means data = out.pbp_step18c;
  title 'pbp_step18c file ';
run;

proc freq data = out.pbp_step18c;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_18c_yn
	pbp_b18c_bendesc_amo
	pbp_b18c_maxplan_yn
	pbp_b18c_maxplan_aid_type
	pbp_b18c_maxplan_in_oon
	pbp_b18c_maxplan_per
	pbp_b18c_maxenr_yn
	pbp_b18c_maxenr_per
	pbp_b18c_ded_yn
	pbp_b18c_bendesc_lim
	pbp_b18c_bendesc_per
	pbp_b18c_coins_yn
	pbp_b18c_copay_yn
	pbp_b18c_auth_yn
	pbp_b18c_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step18c;
  title 'pbp_step18c data';
run;