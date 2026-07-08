*pbp_step18b.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step18b;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_18b_yn        $1
	pbp_d_opt_use_mand_18b1_yn       $1
	pbp_d_opt_use_mand_18b2_yn       $1
	pbp_d_opt_use_mand_18b3_yn       $1
	pbp_d_opt_use_mand_18b4_yn       $1
	pbp_b18b_bendesc_yn              $1
	pbp_b18b_bendesc_ehc             $4
	pbp_b18b_bendesc_amo_at          $1
	pbp_b18b_bendesc_lim_at          $1
	pbp_b18b_bendesc_per_at          $1
	pbp_b18b_bendesc_per_at_d        $4000
	pbp_b18b_bendesc_amo_ie          $1
	pbp_b18b_bendesc_lim_ie          $1
	pbp_b18b_bendesc_per_ie          $1
	pbp_b18b_bendesc_per_ie_d        $4000
	pbp_b18b_bendesc_amo_oe          $1
	pbp_b18b_bendesc_lim_oe          $1
	pbp_b18b_bendesc_per_oe          $1
	pbp_b18b_bendesc_per_oe_d        $4000
	pbp_b18b_bendesc_amo_ote         $1
	pbp_b18b_bendesc_lim_ote         $1
	pbp_b18b_bendesc_per_ote         $1
	pbp_b18b_bendesc_per_ote_d       $4000
	pbp_b18b_maxplan_yn              $1
	pbp_b18b_maxplan_perear          $1
	pbp_b18b_maxplan_type            $1
	pbp_b18b_maxplan_in_oon          $1
	pbp_b18b_maxplan_per             $1
	pbp_b18b_maxplan_per_d           $4000
	pbp_b18b_maxenr_yn               $1
	pbp_b18b_maxenr_type             $1
	pbp_b18b_maxenr_per              $1
	pbp_b18b_maxenr_per_d            $4000
	pbp_b18b_coins_yn                $1
	pbp_b18b_coins_ehc               $3
	pbp_b18b_copay_yn                $1
	pbp_b18b_copay_ehc               $3
	pbp_b18b_ded_yn                  $1
	pbp_b18b_auth_yn                 $1
	pbp_b18b_refer_yn                $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step18b.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_18b_yn
	pbp_d_opt_use_mand_18b1_yn
	pbp_d_opt_use_mand_18b2_yn
	pbp_d_opt_use_mand_18b3_yn
	pbp_d_opt_use_mand_18b4_yn
	pbp_b18b_bendesc_yn
	pbp_b18b_bendesc_ehc
	pbp_b18b_bendesc_amo_at
	pbp_b18b_bendesc_lim_at
	pbp_b18b_bendesc_numv_at
	pbp_b18b_bendesc_per_at
	pbp_b18b_bendesc_per_at_d
	pbp_b18b_bendesc_amo_ie
	pbp_b18b_bendesc_lim_ie
	pbp_b18b_bendesc_numv_ie
	pbp_b18b_bendesc_per_ie
	pbp_b18b_bendesc_per_ie_d
	pbp_b18b_bendesc_amo_oe
	pbp_b18b_bendesc_lim_oe
	pbp_b18b_bendesc_numv_oe
	pbp_b18b_bendesc_per_oe
	pbp_b18b_bendesc_per_oe_d
	pbp_b18b_bendesc_amo_ote
	pbp_b18b_bendesc_lim_ote
	pbp_b18b_bendesc_numv_ote
	pbp_b18b_bendesc_per_ote
	pbp_b18b_bendesc_per_ote_d
	pbp_b18b_maxplan_yn
	pbp_b18b_maxplan_perear
	pbp_b18b_maxplan_type
	pbp_b18b_maxplan_in_oon
	pbp_b18b_maxplan_amt
	pbp_b18b_maxplan_per
	pbp_b18b_maxplan_per_d
	pbp_b18b_maxenr_yn
	pbp_b18b_maxenr_type
	pbp_b18b_maxenr_amt
	pbp_b18b_maxenr_per
	pbp_b18b_maxenr_per_d
	pbp_b18b_coins_yn
	pbp_b18b_coins_ehc
	pbp_b18b_coins_pct_at_min
	pbp_b18b_coins_pct_at_max
	pbp_b18b_coins_pct_ie_min
	pbp_b18b_coins_pct_ie_max
	pbp_b18b_coins_pct_oe_min
	pbp_b18b_coins_pct_oe_max
	pbp_b18b_coins_pct_ote_min
	pbp_b18b_coins_pct_ote_max
	pbp_b18b_copay_yn
	pbp_b18b_copay_ehc
	pbp_b18b_copay_at_min_amt
	pbp_b18b_copay_at_max_amt
	pbp_b18b_copay_amt_per_ie_min
	pbp_b18b_copay_amt_per_ie_max
	pbp_b18b_copay_amt_p2_ie_min
	pbp_b18b_copay_amt_p2_ie_max
	pbp_b18b_copay_amt_per_oe_min
	pbp_b18b_copay_amt_per_oe_max
	pbp_b18b_copay_amt_p2_oe_min
	pbp_b18b_copay_amt_p2_oe_max
	pbp_b18b_copay_amt_per_ote_min
	pbp_b18b_copay_amt_per_ote_max
	pbp_b18b_copay_amt_p2_ote_min
	pbp_b18b_copay_amt_p2_ote_max
	pbp_b18b_ded_yn
	pbp_b18b_ded_amt
	pbp_b18b_auth_yn
	pbp_b18b_refer_yn
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
	pbp_d_opt_use_mand_18b_yn        = 'OppSupp Cost Same INN 18B YN'
	pbp_d_opt_use_mand_18b1_yn       = 'OppSupp Cost Same INN 18B1 YN'
	pbp_d_opt_use_mand_18b2_yn       = 'OppSupp Cost Same INN 18B2 YN'
	pbp_d_opt_use_mand_18b3_yn       = 'OppSupp Cost Same INN 18B3 YN'
	pbp_d_opt_use_mand_18b4_yn       = 'OppSupp Cost Same INN 18B4 YN'
	pbp_b18b_bendesc_yn              = 'Hearing Aids Ben YN'
	pbp_b18b_bendesc_ehc             = 'Hearing Aids (18b) Ben'
	pbp_b18b_bendesc_amo_at          = 'Hearing Aids AT Ben AMO'
	pbp_b18b_bendesc_lim_at          = 'Hearing Aids AT Ben Lim'
	pbp_b18b_bendesc_numv_at         = 'Hearing Aids AT Ben Num'
	pbp_b18b_bendesc_per_at          = 'Hearing Aids AT Ben Per'
	pbp_b18b_bendesc_per_at_d        = 'Hearing Aids AT Per Desc'
	pbp_b18b_bendesc_amo_ie          = 'Hearing Aids IE Ben AMO'
	pbp_b18b_bendesc_lim_ie          = 'Hearing Aids IE Ben Lim'
	pbp_b18b_bendesc_numv_ie         = 'Hearing Aids IE Ben Num'
	pbp_b18b_bendesc_per_ie          = 'Hearing Aids IE Ben Per'
	pbp_b18b_bendesc_per_ie_d        = 'Hear Aids IE Per Desc'
	pbp_b18b_bendesc_amo_oe          = 'Hearing Aids OE Ben AMO'
	pbp_b18b_bendesc_lim_oe          = 'Hearing Aids OE Ben Lim'
	pbp_b18b_bendesc_numv_oe         = 'Hearing Aids OE Ben Num'
	pbp_b18b_bendesc_per_oe          = 'Hearing Aids OE Ben Per'
	pbp_b18b_bendesc_per_oe_d        = 'Hear Aids OE Per Desc'
	pbp_b18b_bendesc_amo_ote         = 'Hearing Aids OTE Ben AMO'
	pbp_b18b_bendesc_lim_ote         = 'Hearing Aids OTE Ben Lim'
	pbp_b18b_bendesc_numv_ote        = 'Hearing Aids OTE Ben Num'
	pbp_b18b_bendesc_per_ote         = 'Hearing Aids OTE Ben Per'
	pbp_b18b_bendesc_per_ote_d       = 'Hear Aids OTE Per Desc'
	pbp_b18b_maxplan_yn              = 'Hearing Aids Max Plan YN'
	pbp_b18b_maxplan_perear          = 'Hearing Aids Maxplan Per Ear'
	pbp_b18b_maxplan_type            = 'Hearing Aids Max Plan Type'
	pbp_b18b_maxplan_in_oon          = 'Hearing Aids INN or OON'
	pbp_b18b_maxplan_amt             = 'Hearing Aids Max Plan Amt'
	pbp_b18b_maxplan_per             = 'Hearing Aids Max Plan Per'
	pbp_b18b_maxplan_per_d           = 'Hearing Aids Maxplan Ear Desc'
	pbp_b18b_maxenr_yn               = 'Hearing Aids Max Enr YN'
	pbp_b18b_maxenr_type             = 'Hearing Aids Max Enr Type'
	pbp_b18b_maxenr_amt              = 'Hearing Aids Max Enr Amt'
	pbp_b18b_maxenr_per              = 'Hearing Aids Max Enr Per'
	pbp_b18b_maxenr_per_d            = 'Hearing Aids Max Enr Per Desc'
	pbp_b18b_coins_yn                = 'Hearing Aids Coinsurance YN'
	pbp_b18b_coins_ehc               = 'Hearing Aids Benefits Coins'
	pbp_b18b_coins_pct_at_min        = 'Hearing Aids AT Min Coins Pct'
	pbp_b18b_coins_pct_at_max        = 'Hearing Aids AT Max Coins Pct'
	pbp_b18b_coins_pct_ie_min        = 'Hearing Aids IE Min Coins Pct'
	pbp_b18b_coins_pct_ie_max        = 'Hearing Aids IE Max Coins Pct'
	pbp_b18b_coins_pct_oe_min        = 'Hearing Aids OE Min Coins Pct'
	pbp_b18b_coins_pct_oe_max        = 'Hearing Aids OE Max Coins Pct'
	pbp_b18b_coins_pct_ote_min       = 'Hearing Aids OTE Min Coins Pct'
	pbp_b18b_coins_pct_ote_max       = 'Hearing Aids OTE Max Coins Pct'
	pbp_b18b_copay_yn                = 'Hearing Aids Copayment YN'
	pbp_b18b_copay_ehc               = 'Hearing Aids Benefits Copay'
	pbp_b18b_copay_at_min_amt        = 'Hearing Aids AT Min Copay Amt'
	pbp_b18b_copay_at_max_amt        = 'Hearing Aids AT Max Copay Amt'
	pbp_b18b_copay_amt_per_ie_min    = 'Hearing Aids IE Min Copay Amt'
	pbp_b18b_copay_amt_per_ie_max    = 'Hearing Aids IE Max Copay Amt'
	pbp_b18b_copay_amt_p2_ie_min     = 'Hearing Aids 2 IE Min Copay'
	pbp_b18b_copay_amt_p2_ie_max     = 'Hearing Aids 2 IE Max Copay'
	pbp_b18b_copay_amt_per_oe_min    = 'Hearing Aids OE Min Copay Amt'
	pbp_b18b_copay_amt_per_oe_max    = 'Hearing Aids OE Max Copay Amt'
	pbp_b18b_copay_amt_p2_oe_min     = 'Hearing Aids 2 OE Min Copay'
	pbp_b18b_copay_amt_p2_oe_max     = 'Hearing Aids 2 OE Max Copay'
	pbp_b18b_copay_amt_per_ote_min   = 'Hearing Aids OTE Min Copay Amt'
	pbp_b18b_copay_amt_per_ote_max   = 'Hearing Aids OTE Max Copay Amt'
	pbp_b18b_copay_amt_p2_ote_min    = 'Hearing Aids 2 OTE Min Copay'
	pbp_b18b_copay_amt_p2_ote_max    = 'Hearing Aids 2 OTE Max Copay'
	pbp_b18b_ded_yn                  = 'Hearing Aids Deductible YN'
	pbp_b18b_ded_amt                 = 'Hearing Aids Deductible Amt'
	pbp_b18b_auth_yn                 = 'Hearing Aids Auth YN'
	pbp_b18b_refer_yn                = 'Hearing Aids Referral YN'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step18b out=out.pbp_step18b;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step18b(obs = 10);
  title 'pbp_step18b file ';
run;

proc means data = out.pbp_step18b;
  title 'pbp_step18b file ';
run;

proc freq data = out.pbp_step18b;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_18b_yn
	pbp_d_opt_use_mand_18b1_yn
	pbp_d_opt_use_mand_18b2_yn
	pbp_d_opt_use_mand_18b3_yn
	pbp_d_opt_use_mand_18b4_yn
	pbp_b18b_bendesc_yn
	pbp_b18b_bendesc_ehc
	pbp_b18b_bendesc_amo_at
	pbp_b18b_bendesc_lim_at
	pbp_b18b_bendesc_per_at
	pbp_b18b_bendesc_amo_ie
	pbp_b18b_bendesc_lim_ie
	pbp_b18b_bendesc_per_ie
	pbp_b18b_bendesc_amo_oe
	pbp_b18b_bendesc_lim_oe
	pbp_b18b_bendesc_per_oe
	pbp_b18b_bendesc_amo_ote
	pbp_b18b_bendesc_lim_ote
	pbp_b18b_bendesc_per_ote
	pbp_b18b_maxplan_yn
	pbp_b18b_maxplan_perear
	pbp_b18b_maxplan_type
	pbp_b18b_maxplan_in_oon
	pbp_b18b_maxplan_per
	pbp_b18b_maxenr_yn
	pbp_b18b_maxenr_type
	pbp_b18b_maxenr_per
	pbp_b18b_coins_yn
	pbp_b18b_coins_ehc
	pbp_b18b_copay_yn
	pbp_b18b_copay_ehc
	pbp_b18b_ded_yn
	pbp_b18b_auth_yn
	pbp_b18b_refer_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step18b;
  title 'pbp_step18b data';
run;