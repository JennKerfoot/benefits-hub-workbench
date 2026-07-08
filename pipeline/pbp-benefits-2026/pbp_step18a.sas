*pbp_step18a.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step18a;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_18a_yn        $1
	pbp_d_opt_use_mand_18a1_yn       $1
	pbp_d_opt_use_mand_18a2_yn       $1
	pbp_b18a_bendesc_yn              $1
	pbp_b18a_bendesc_ehc             $2
	pbp_b18a_bendesc_amo_rht         $1
	pbp_b18a_bendesc_lim_rht         $1
	pbp_b18a_bendesc_per_rht         $1
	pbp_b18a_bendesc_per_rht_d       $4000
	pbp_b18a_bendesc_amo_fha         $1
	pbp_b18a_bendesc_lim_fha         $1
	pbp_b18a_bendesc_per_fha         $1
	pbp_b18a_bendesc_per_fha_d       $4000
	pbp_b18a_maxplan_yn              $1
	pbp_b18a_maxplan_in_oon          $1
	pbp_b18a_maxplan_per             $1
	pbp_b18a_maxplan_per_d           $4000
	pbp_b18a_ded_nmc_yn              $1
	pbp_b18a_coins_yn                $1
	pbp_b18a_coins_ehc               $3
	pbp_b18a_copay_yn                $1
	pbp_b18a_copay_ehc               $3
	pbp_b18a_auth_yn                 $1
	pbp_b18a_refer_yn                $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step18a.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_18a_yn
	pbp_d_opt_use_mand_18a1_yn
	pbp_d_opt_use_mand_18a2_yn
	pbp_b18a_bendesc_yn
	pbp_b18a_bendesc_ehc
	pbp_b18a_bendesc_amo_rht
	pbp_b18a_bendesc_lim_rht
	pbp_b18a_bendesc_numv_cl
	pbp_b18a_bendesc_per_rht
	pbp_b18a_bendesc_per_rht_d
	pbp_b18a_bendesc_amo_fha
	pbp_b18a_bendesc_lim_fha
	pbp_b18a_bendesc_numv_fha
	pbp_b18a_bendesc_per_fha
	pbp_b18a_bendesc_per_fha_d
	pbp_b18a_maxplan_yn
	pbp_b18a_maxplan_in_oon
	pbp_b18a_maxplan_amt
	pbp_b18a_maxplan_per
	pbp_b18a_maxplan_per_d
	pbp_b18a_ded_nmc_yn
	pbp_b18a_ded_nmc_amt
	pbp_b18a_coins_yn
	pbp_b18a_coins_ehc
	pbp_b18a_coins_pct_rht
	pbp_b18a_coins_pct_max_rht
	pbp_b18a_coins_pct_fha
	pbp_b18a_coins_pct_max_fha
	pbp_b18a_copay_yn
	pbp_b18a_copay_ehc
	pbp_b18a_copay_amt_rht
	pbp_b18a_copay_amt_max_rht
	pbp_b18a_copay_amt_fha
	pbp_b18a_copay_amt_max_fha
	pbp_b18a_auth_yn
	pbp_b18a_refer_yn
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
	pbp_d_opt_use_mand_18a_yn        = 'OppSupp Cost Same INN 18A YN'
	pbp_d_opt_use_mand_18a1_yn       = 'OppSupp Cost Same INN 18A1 YN'
	pbp_d_opt_use_mand_18a2_yn       = 'OppSupp Cost Same INN 18A2 YN'
	pbp_b18a_bendesc_yn              = 'Hearing Exams Ben YN'
	pbp_b18a_bendesc_ehc             = 'Hearing Exams (18a) Ben'
	pbp_b18a_bendesc_amo_rht         = 'Hearing Exams RHT Ben Desc AMO'
	pbp_b18a_bendesc_lim_rht         = 'Hearing Exams RHT Ben Desc Lim'
	pbp_b18a_bendesc_numv_cl         = 'Hearing Exams RHT Ben Desc Num'
	pbp_b18a_bendesc_per_rht         = 'Hearing Exams RHT Ben Desc Per'
	pbp_b18a_bendesc_per_rht_d       = 'Hearing Exams RHT Per Desc'
	pbp_b18a_bendesc_amo_fha         = 'Hearing Exams FHA Ben Desc AMO'
	pbp_b18a_bendesc_lim_fha         = 'Hearing Exams FHA Ben Desc Lim'
	pbp_b18a_bendesc_numv_fha        = 'Hearing Exams FHA Ben Desc Num'
	pbp_b18a_bendesc_per_fha         = 'Hearing Exams FHA Ben Desc Per'
	pbp_b18a_bendesc_per_fha_d       = 'Hearing Exams FHA Per Desc'
	pbp_b18a_maxplan_yn              = 'Hearing Exams Max Plan YN'
	pbp_b18a_maxplan_in_oon          = 'Hearing Exams INN or OON'
	pbp_b18a_maxplan_amt             = 'Hearing Exams Max Plan Amt'
	pbp_b18a_maxplan_per             = 'Hearing Exams Max Plan Per'
	pbp_b18a_maxplan_per_d           = 'Hearing Exams Max Per Desc'
	pbp_b18a_ded_nmc_yn              = 'Hearing Exams Deduct NMC YN'
	pbp_b18a_ded_nmc_amt             = 'Hearing Exams Deduct NMC Amt'
	pbp_b18a_coins_yn                = 'Hearing Exams Coinsurance YN'
	pbp_b18a_coins_ehc               = 'Hearing Exam Benefits Coins'
	pbp_b18a_coins_pct_rht           = 'Hearing Exms RHT Min Coins Pct'
	pbp_b18a_coins_pct_max_rht       = 'Hearing Exms RHT Max Coins Pct'
	pbp_b18a_coins_pct_fha           = 'Hearing Exms FHA Min Coins Pct'
	pbp_b18a_coins_pct_max_fha       = 'Hearing Exms FHA Max Coins Pct'
	pbp_b18a_copay_yn                = 'Hearing Exams Copayment YN'
	pbp_b18a_copay_ehc               = 'Hearing Exam Benefits Copay'
	pbp_b18a_copay_amt_rht           = 'Hearing Exms RHT Min Copay Amt'
	pbp_b18a_copay_amt_max_rht       = 'Hearing Exms RHT Max Copay Amt'
	pbp_b18a_copay_amt_fha           = 'Hearing Exms FHA Min Copay Amt'
	pbp_b18a_copay_amt_max_fha       = 'Hearing Exms FHA Max Copay Amt'
	pbp_b18a_auth_yn                 = 'Hearing Exams Auth YN'
	pbp_b18a_refer_yn                = 'Hearing Exams Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step18a out=out.pbp_step18a;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step18a(obs = 10);
  title 'pbp_step18a file ';
run;

proc means data = out.pbp_step18a;
  title 'pbp_step18a file ';
run;

proc freq data = out.pbp_step18a;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_18a_yn
	pbp_d_opt_use_mand_18a1_yn
	pbp_d_opt_use_mand_18a2_yn
	pbp_b18a_bendesc_yn
	pbp_b18a_bendesc_ehc
	pbp_b18a_bendesc_amo_rht
	pbp_b18a_bendesc_lim_rht
	pbp_b18a_bendesc_per_rht
	pbp_b18a_bendesc_amo_fha
	pbp_b18a_bendesc_lim_fha
	pbp_b18a_bendesc_per_fha
	pbp_b18a_maxplan_yn
	pbp_b18a_maxplan_in_oon
	pbp_b18a_maxplan_per
	pbp_b18a_ded_nmc_yn
	pbp_b18a_coins_yn
	pbp_b18a_coins_ehc
	pbp_b18a_copay_yn
	pbp_b18a_copay_ehc
	pbp_b18a_auth_yn
	pbp_b18a_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step18a;
  title 'pbp_step18a data';
run;