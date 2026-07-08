*pbp_b14b_b19b_preventive_vbid_uf.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b14_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b14b_bendesc_yn              $1
	pbp_b14b_bendesc_rpe_amo         $1
	pbp_b14b_maxplan_yn              $1
	pbp_b14b_maxenr_yn               $1
	pbp_b14b_coins_yn                $1
	pbp_b14b_ded_yn                  $1
	pbp_b14b_copay_yn                $1
	pbp_b14b_auth_yn                 $1
	pbp_b14b_refer_yn                $1
;

infile '.\pbp\pbp_b14b_b19b_preventive_vbid_uf.txt' delimiter = '09'x
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
	pbp_vbid_group_id
	pbp_b14b_bendesc_yn
	pbp_b14b_bendesc_rpe_amo
	pbp_b14b_maxplan_yn
	pbp_b14b_maxplan_amt
	pbp_b14b_maxenr_yn
	pbp_b14b_maxenr_amt
	pbp_b14b_coins_yn
	pbp_b14b_coins_pct_rpe_min
	pbp_b14b_coins_pct_rpe_max
	pbp_b14b_ded_yn
	pbp_b14b_ded_amt
	pbp_b14b_copay_yn
	pbp_b14b_copay_amt_rpe_min
	pbp_b14b_copay_amt_rpe_max
	pbp_b14b_auth_yn
	pbp_b14b_refer_yn
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
	pbp_vbid_group_id                = 'B19 VBID Group (Package) ID'
	pbp_b14b_bendesc_yn              = 'AnnPhysExam Ben Desc YN'
	pbp_b14b_bendesc_rpe_amo         = 'AnnPhysExam Ben Desc AMO'
	pbp_b14b_maxplan_yn              = 'AnnPhysExam Max Plan YN'
	pbp_b14b_maxplan_amt             = 'AnnPhysExam Max Plan Amt'
	pbp_b14b_maxenr_yn               = 'AnnPhysExam Max Enr YN'
	pbp_b14b_maxenr_amt              = 'AnnPhysExam Max Enr Amt'
	pbp_b14b_coins_yn                = 'AnnPhysExam Coinsurance YN'
	pbp_b14b_coins_pct_rpe_min       = 'AnnPhysExam Min Coins Pct'
	pbp_b14b_coins_pct_rpe_max       = 'AnnPhysExam Max Coins Pct'
	pbp_b14b_ded_yn                  = 'AnnPhysExam Deductible YN'
	pbp_b14b_ded_amt                 = 'AnnPhysExam Deductible Amt'
	pbp_b14b_copay_yn                = 'AnnPhysExam Copayment YN'
	pbp_b14b_copay_amt_rpe_min       = 'AnnPhysExam Min Copay Amt'
	pbp_b14b_copay_amt_rpe_max       = 'AnnPhysExam Max Copay Amt'
	pbp_b14b_auth_yn                 = 'AnnPhysExam Enrollee Auth YN'
	pbp_b14b_refer_yn                = 'AnnPhysExam Referral YN'
;

run;

proc sort data = pbp_b14_vbid out=out.pbp_b14_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b14_vbid(obs = 10);
  title 'pbp_b14b_b19b_preventive_vbid_uf file ';
run;

proc means data = out.pbp_b14_vbid;
  title 'pbp_b14b_b19b_preventive_vbid_uf file ';
run;

proc freq data = out.pbp_b14_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b14b_bendesc_yn
	pbp_b14b_bendesc_rpe_amo
	pbp_b14b_maxplan_yn
	pbp_b14b_maxenr_yn
	pbp_b14b_coins_yn
	pbp_b14b_ded_yn
	pbp_b14b_copay_yn
	pbp_b14b_auth_yn
	pbp_b14b_refer_yn
/ missing;
run;

proc contents data = out.pbp_b14_vbid;
  title 'pbp_b14_vbid data';
run;