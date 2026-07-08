*pbp_b4_b19b_emerg_urgent_vbid_uf.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b4_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b4c_bendesc_yn               $1
	pbp_b4c_bendesc_ehc              $3
	pbp_b4c_bendesc_amo_wec          $1
	pbp_b4c_bendesc_amo_wuc          $1
	pbp_b4c_bendesc_amo_wet          $1
	pbp_b4c_wwc_maxplan_yn           $1
	pbp_b4c_wwc_maxplan_svcs_yn      $1
	pbp_b4c_maxenr_yn                $1
	pbp_b4c_maxenr_per               $1
	pbp_b4c_maxenr_per_d             $4000
	pbp_b4c_coins_yn                 $1
	pbp_b4c_coins_ehc                $3
	pbp_b4c_coins_wav_wec_yn         $1
	pbp_b4c_coins_wav_wuc_yn         $1
	pbp_b4c_coins_wav_wet_yn         $1
	pbp_b4c_copay_yn                 $1
	pbp_b4c_copay_ehc                $3
	pbp_b4c_copay_wav_wec_yn         $1
	pbp_b4c_copay_wav_wuc_yn         $1
	pbp_b4c_copay_wav_wet_yn         $1
	pbp_b4c_ded_yn                   $1
;

infile '.\pbp\pbp_b4_b19b_emerg_urgent_vbid_uf.txt' delimiter = '09'x
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
	pbp_b4c_bendesc_yn
	pbp_b4c_bendesc_ehc
	pbp_b4c_bendesc_amo_wec
	pbp_b4c_bendesc_amo_wuc
	pbp_b4c_bendesc_amo_wet
	pbp_b4c_wwc_maxplan_yn
	pbp_b4c_wwc_maxplan_svcs_yn
	pbp_b4c_wwc_maxplan_amt
	pbp_b4c_maxenr_yn
	pbp_b4c_maxenr_amt
	pbp_b4c_maxenr_per
	pbp_b4c_maxenr_per_d
	pbp_b4c_coins_yn
	pbp_b4c_coins_ehc
	pbp_b4c_coins_pct_wec_min
	pbp_b4c_coins_pct_wec_max
	pbp_b4c_coins_wav_wec_yn
	pbp_b4c_coins_pct_wuc_min
	pbp_b4c_coins_pct_wuc_max
	pbp_b4c_coins_wav_wuc_yn
	pbp_b4c_coins_pct_wet_min
	pbp_b4c_coins_pct_wet_max
	pbp_b4c_coins_wav_wet_yn
	pbp_b4c_copay_yn
	pbp_b4c_copay_ehc
	pbp_b4c_copay_amt_wec_min
	pbp_b4c_copay_amt_wec_max
	pbp_b4c_copay_wav_wec_yn
	pbp_b4c_copay_amt_wuc_min
	pbp_b4c_copay_amt_wuc_max
	pbp_b4c_copay_wav_wuc_yn
	pbp_b4c_copay_amt_wet_min
	pbp_b4c_copay_amt_wet_max
	pbp_b4c_copay_wav_wet_yn
	pbp_b4c_ded_yn
	pbp_b4c_ded_amt
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
	pbp_b4c_bendesc_yn               = 'Worldwide Cov Desc YN'
	pbp_b4c_bendesc_ehc              = 'Worldwide supp ben desc'
	pbp_b4c_bendesc_amo_wec          = 'Worldwide Emerg cov  AMO'
	pbp_b4c_bendesc_amo_wuc          = 'Worldwide Urgent cov  AMO'
	pbp_b4c_bendesc_amo_wet          = 'Worldwide Emerg transp AMO'
	pbp_b4c_wwc_maxplan_yn           = 'Worldwide Cov MaxPlan YN'
	pbp_b4c_wwc_maxplan_svcs_yn      = 'Worldwide Cov MaxPlan Limit'
	pbp_b4c_wwc_maxplan_amt          = 'Worldwide Cov MaxPlan Amt'
	pbp_b4c_maxenr_yn                = 'Worldwide Emerg Max Enr YN'
	pbp_b4c_maxenr_amt               = 'Worldwide Emerg Max Enr Amt'
	pbp_b4c_maxenr_per               = 'Worldwide Emerg Max Enr Per'
	pbp_b4c_maxenr_per_d             = 'Worldwide Emerg Max Enr Desc'
	pbp_b4c_coins_yn                 = 'Worldwide Emerg Care Coins YN'
	pbp_b4c_coins_ehc                = 'Worldwide coins ehc'
	pbp_b4c_coins_pct_wec_min        = 'Worldwide emerg Min Coins'
	pbp_b4c_coins_pct_wec_max        = 'Worldwide emerg Max Coins'
	pbp_b4c_coins_wav_wec_yn         = 'Worldwide emerg coins waiv'
	pbp_b4c_coins_pct_wuc_min        = 'Worldwide urgent cov Min Coins'
	pbp_b4c_coins_pct_wuc_max        = 'Worldwide urgent cov Max Coins'
	pbp_b4c_coins_wav_wuc_yn         = 'Worldwide urgent coins waiv'
	pbp_b4c_coins_pct_wet_min        = 'Worldwide emerg tran Min Coins'
	pbp_b4c_coins_pct_wet_max        = 'Worldwide emerg tran Max Coins'
	pbp_b4c_coins_wav_wet_yn         = 'Worldwide emerg coin waiv'
	pbp_b4c_copay_yn                 = 'Worldwide Emerg Care Copay YN'
	pbp_b4c_copay_ehc                = 'Worldwide copay ehc'
	pbp_b4c_copay_amt_wec_min        = 'Worldwide emerg cov Min Copay'
	pbp_b4c_copay_amt_wec_max        = 'Worldwide emerg cov Max Copay'
	pbp_b4c_copay_wav_wec_yn         = 'Worldwide emerg copay waiv'
	pbp_b4c_copay_amt_wuc_min        = 'Worldwide urgent Min Copay'
	pbp_b4c_copay_amt_wuc_max        = 'Worldwide urgent Max Copay'
	pbp_b4c_copay_wav_wuc_yn         = 'Worldwide urgent copay waiv'
	pbp_b4c_copay_amt_wet_min        = 'Worldwide emerg tran Min Copay'
	pbp_b4c_copay_amt_wet_max        = 'Worldwide emerg tran Max Copay'
	pbp_b4c_copay_wav_wet_yn         = 'Worldwide emerg trn copay waiv'
	pbp_b4c_ded_yn                   = 'Worldwide Emerg Deductible YN'
	pbp_b4c_ded_amt                  = 'Worldwide Emerg Deductible Amt'
;

run;

proc sort data = pbp_b4_vbid out=out.pbp_b4_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b4_vbid(obs = 10);
  title 'pbp_b4_b19b_emerg_urgent_vbid_uf file ';
run;

proc means data = out.pbp_b4_vbid;
  title 'pbp_b4_b19b_emerg_urgent_vbid_uf file ';
run;

proc freq data = out.pbp_b4_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b4c_bendesc_yn
	pbp_b4c_bendesc_ehc
	pbp_b4c_bendesc_amo_wec
	pbp_b4c_bendesc_amo_wuc
	pbp_b4c_bendesc_amo_wet
	pbp_b4c_wwc_maxplan_yn
	pbp_b4c_wwc_maxplan_svcs_yn
	pbp_b4c_maxenr_yn
	pbp_b4c_maxenr_per
	pbp_b4c_coins_yn
	pbp_b4c_coins_ehc
	pbp_b4c_coins_wav_wec_yn
	pbp_b4c_coins_wav_wuc_yn
	pbp_b4c_coins_wav_wet_yn
	pbp_b4c_copay_yn
	pbp_b4c_copay_ehc
	pbp_b4c_copay_wav_wec_yn
	pbp_b4c_copay_wav_wuc_yn
	pbp_b4c_copay_wav_wet_yn
	pbp_b4c_ded_yn
/ missing;
run;

proc contents data = out.pbp_b4_vbid;
  title 'pbp_b4_vbid data';
run;