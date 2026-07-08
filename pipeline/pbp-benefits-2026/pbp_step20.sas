*pbp_step20.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_step20;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_d_opt_use_mand_20_yn         $1
	pbp_b20_bendesc_yn               $1
	pbp_b20_bendesc_amo              $1
	pbp_b20_bendesc_grp_num          $1
	pbp_b20_maxplan_yn               $1
	pbp_b20_maxplan_types            $3
	pbp_b20_maxplan_net_copay_yn     $1
	pbp_b20_maxplan_per              $5
	pbp_b20_maxplan_per_d            $4000
	pbp_b20_maxplan_unused_yn        $1
	pbp_b20_maxplan_cdt              $5
	pbp_b20_maxplan_per_cdt          $5
	pbp_b20_maxplan_per_cdt_d        $4000
	pbp_b20_maxplan_grp_unlm_yn      $1
	pbp_b20_maxplan_grp_waived       $5
	pbp_b20_addl_cost                $1
	pbp_b20_maxenr_yn                $1
	pbp_b20_maxenr_cdt               $6
	pbp_b20_maxenr_per               $1
	pbp_b20_ded_yn                   $1
	pbp_b20_ded_cdt                  $6
	pbp_b20_auth_yn                  $1
	pbp_b20_grp1_name                $4000
	pbp_b20_grp1_label               $2
	pbp_b20_grp1_drug_types          $3
	pbp_b20_grp1_maxplan_yn          $1
	pbp_b20_grp1_maxplan_per         $6
	pbp_b20_grp1_maxplan_per_d       $4000
	pbp_b20_grp1_place               $4
	pbp_b20_grp1_place_d             $4000
	pbp_b20_grp1_coins_yn            $1
	pbp_b20_grp1_copay_yn            $1
	pbp_b20_grp2_name                $4000
	pbp_b20_grp2_label               $2
	pbp_b20_grp2_drug_types          $3
	pbp_b20_grp2_maxplan_yn          $1
	pbp_b20_grp2_maxplan_per         $6
	pbp_b20_grp2_maxplan_per_d       $4000
	pbp_b20_grp2_place               $4
	pbp_b20_grp2_place_d             $4000
	pbp_b20_grp2_coins_yn            $1
	pbp_b20_grp2_copay_yn            $1
	pbp_b20_grp3_name                $4000
	pbp_b20_grp3_label               $2
	pbp_b20_grp3_drug_types          $3
	pbp_b20_grp3_maxplan_yn          $1
	pbp_b20_grp3_maxplan_per         $6
	pbp_b20_grp3_maxplan_per_d       $4000
	pbp_b20_grp3_place               $4
	pbp_b20_grp3_place_d             $4000
	pbp_b20_grp3_coins_yn            $1
	pbp_b20_grp3_copay_yn            $1
	pbp_b20_grp4_name                $4000
	pbp_b20_grp4_label               $2
	pbp_b20_grp4_drug_types          $3
	pbp_b20_grp4_maxplan_yn          $1
	pbp_b20_grp4_maxplan_per         $6
	pbp_b20_grp4_maxplan_per_d       $4000
	pbp_b20_grp4_place               $4
	pbp_b20_grp4_place_d             $4000
	pbp_b20_grp4_coins_yn            $1
	pbp_b20_grp4_copay_yn            $1
	pbp_b20_grp5_name                $4000
	pbp_b20_grp5_label               $2
	pbp_b20_grp5_drug_types          $3
	pbp_b20_grp5_maxplan_yn          $1
	pbp_b20_grp5_maxplan_per         $6
	pbp_b20_grp5_maxplan_per_d       $4000
	pbp_b20_grp5_place               $4
	pbp_b20_grp5_place_d             $4000
	pbp_b20_grp5_coins_yn            $1
	pbp_b20_grp5_copay_yn            $1
	pbp_b20_hi_yn                    $1
	pbp_d_opt_identifier             $3
;

infile '.\pbp\pbp_step20.txt' delimiter = '09'x
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
	pbp_d_opt_use_mand_20_yn
	pbp_b20_bendesc_yn
	pbp_b20_bendesc_amo
	pbp_b20_bendesc_grp_num
	pbp_b20_maxplan_yn
	pbp_b20_maxplan_types
	pbp_b20_maxplan_net_copay_yn
	pbp_b20_maxplan_per
	pbp_b20_maxplan_per_d
	pbp_b20_maxplan_amt_1yr
	pbp_b20_maxplan_amt_6mth
	pbp_b20_maxplan_amt_3mth
	pbp_b20_maxplan_amt_1mth
	pbp_b20_maxplan_amt_oth
	pbp_b20_maxplan_unused_yn
	pbp_b20_maxplan_cdt
	pbp_b20_maxplan_per_cdt
	pbp_b20_maxplan_per_cdt_d
	pbp_b20_maxplan_amt_cdt_1yr
	pbp_b20_maxplan_amt_cdt_6mth
	pbp_b20_maxplan_amt_cdt_3mth
	pbp_b20_maxplan_amt_cdt_1mth
	pbp_b20_maxplan_amt_cdt_oth
	pbp_b20_maxplan_grp_unlm_yn
	pbp_b20_maxplan_grp_waived
	pbp_b20_addl_cost
	pbp_b20_maxenr_yn
	pbp_b20_maxenr_cdt
	pbp_b20_maxenr_amt
	pbp_b20_maxenr_per
	pbp_b20_ded_yn
	pbp_b20_ded_cdt
	pbp_b20_ded_amt
	pbp_b20_auth_yn
	pbp_b20_grp1_name
	pbp_b20_grp1_label
	pbp_b20_grp1_drug_types
	pbp_b20_grp1_maxplan_yn
	pbp_b20_grp1_maxplan_per
	pbp_b20_grp1_maxplan_per_d
	pbp_b20_grp1_maxplan_amt_1yr
	pbp_b20_grp1_maxplan_amt_6mth
	pbp_b20_grp1_maxplan_amt_3mth
	pbp_b20_grp1_maxplan_amt_1mth
	pbp_b20_grp1_maxplan_amt_pres
	pbp_b20_grp1_maxplan_amt_oth
	pbp_b20_grp1_place
	pbp_b20_grp1_place_d
	pbp_b20_grp1_coins_yn
	pbp_b20_grp1_coins_pct_drp
	pbp_b20_grp1_coins_pct_hmo
	pbp_b20_grp1_coins_pct_mo
	pbp_b20_grp1_coins_pct_oth
	pbp_b20_grp1_copay_yn
	pbp_b20_grp1_copay_drp_amt
	pbp_b20_grp1_copay_hmo_amt
	pbp_b20_grp1_copay_mo_amt
	pbp_b20_grp1_copay_oth_amt
	pbp_b20_grp1_drp_days
	pbp_b20_grp1_hmo_days
	pbp_b20_grp1_mo_days
	pbp_b20_grp1_oth_days
	pbp_b20_grp2_name
	pbp_b20_grp2_label
	pbp_b20_grp2_drug_types
	pbp_b20_grp2_maxplan_yn
	pbp_b20_grp2_maxplan_per
	pbp_b20_grp2_maxplan_per_d
	pbp_b20_grp2_maxplan_amt_1yr
	pbp_b20_grp2_maxplan_amt_6mth
	pbp_b20_grp2_maxplan_amt_3mth
	pbp_b20_grp2_maxplan_amt_1mth
	pbp_b20_grp2_maxplan_amt_pres
	pbp_b20_grp2_maxplan_amt_oth
	pbp_b20_grp2_place
	pbp_b20_grp2_place_d
	pbp_b20_grp2_coins_yn
	pbp_b20_grp2_coins_pct_drp
	pbp_b20_grp2_coins_pct_hmo
	pbp_b20_grp2_coins_pct_mo
	pbp_b20_grp2_coins_pct_oth
	pbp_b20_grp2_copay_yn
	pbp_b20_grp2_copay_drp_amt
	pbp_b20_grp2_copay_hmo_amt
	pbp_b20_grp2_copay_mo_amt
	pbp_b20_grp2_copay_oth_amt
	pbp_b20_grp2_drp_days
	pbp_b20_grp2_hmo_days
	pbp_b20_grp2_mo_days
	pbp_b20_grp2_oth_days
	pbp_b20_grp3_name
	pbp_b20_grp3_label
	pbp_b20_grp3_drug_types
	pbp_b20_grp3_maxplan_yn
	pbp_b20_grp3_maxplan_per
	pbp_b20_grp3_maxplan_per_d
	pbp_b20_grp3_maxplan_amt_1yr
	pbp_b20_grp3_maxplan_amt_6mth
	pbp_b20_grp3_maxplan_amt_3mth
	pbp_b20_grp3_maxplan_amt_1mth
	pbp_b20_grp3_maxplan_amt_pres
	pbp_b20_grp3_maxplan_amt_oth
	pbp_b20_grp3_place
	pbp_b20_grp3_place_d
	pbp_b20_grp3_coins_yn
	pbp_b20_grp3_coins_pct_drp
	pbp_b20_grp3_coins_pct_hmo
	pbp_b20_grp3_coins_pct_mo
	pbp_b20_grp3_coins_pct_oth
	pbp_b20_grp3_copay_yn
	pbp_b20_grp3_copay_drp_amt
	pbp_b20_grp3_copay_hmo_amt
	pbp_b20_grp3_copay_mo_amt
	pbp_b20_grp3_copay_oth_amt
	pbp_b20_grp3_drp_days
	pbp_b20_grp3_hmo_days
	pbp_b20_grp3_mo_days
	pbp_b20_grp3_oth_days
	pbp_b20_grp4_name
	pbp_b20_grp4_label
	pbp_b20_grp4_drug_types
	pbp_b20_grp4_maxplan_yn
	pbp_b20_grp4_maxplan_per
	pbp_b20_grp4_maxplan_per_d
	pbp_b20_grp4_maxplan_amt_1yr
	pbp_b20_grp4_maxplan_amt_6mth
	pbp_b20_grp4_maxplan_amt_3mth
	pbp_b20_grp4_maxplan_amt_1mth
	pbp_b20_grp4_maxplan_amt_pres
	pbp_b20_grp4_maxplan_amt_oth
	pbp_b20_grp4_place
	pbp_b20_grp4_place_d
	pbp_b20_grp4_coins_yn
	pbp_b20_grp4_coins_pct_drp
	pbp_b20_grp4_coins_pct_hmo
	pbp_b20_grp4_coins_pct_mo
	pbp_b20_grp4_coins_pct_oth
	pbp_b20_grp4_copay_yn
	pbp_b20_grp4_copay_drp_amt
	pbp_b20_grp4_copay_hmo_amt
	pbp_b20_grp4_copay_mo_amt
	pbp_b20_grp4_copay_oth_amt
	pbp_b20_grp4_drp_days
	pbp_b20_grp4_hmo_days
	pbp_b20_grp4_mo_days
	pbp_b20_grp4_oth_days
	pbp_b20_grp5_name
	pbp_b20_grp5_label
	pbp_b20_grp5_drug_types
	pbp_b20_grp5_maxplan_yn
	pbp_b20_grp5_maxplan_per
	pbp_b20_grp5_maxplan_per_d
	pbp_b20_grp5_maxplan_amt_1yr
	pbp_b20_grp5_maxplan_amt_6mth
	pbp_b20_grp5_maxplan_amt_3mth
	pbp_b20_grp5_maxplan_amt_1mth
	pbp_b20_grp5_maxplan_amt_pres
	pbp_b20_grp5_maxplan_amt_oth
	pbp_b20_grp5_place
	pbp_b20_grp5_place_d
	pbp_b20_grp5_coins_yn
	pbp_b20_grp5_coins_pct_drp
	pbp_b20_grp5_coins_pct_hmo
	pbp_b20_grp5_coins_pct_mo
	pbp_b20_grp5_coins_pct_oth
	pbp_b20_grp5_copay_yn
	pbp_b20_grp5_copay_drp_amt
	pbp_b20_grp5_copay_hmo_amt
	pbp_b20_grp5_copay_mo_amt
	pbp_b20_grp5_copay_oth_amt
	pbp_b20_grp5_drp_days
	pbp_b20_grp5_hmo_days
	pbp_b20_grp5_mo_days
	pbp_b20_grp5_oth_days
	pbp_b20_hi_yn
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
	pbp_d_opt_use_mand_20_yn         = 'OppSupp Cost Same INN 20 YN'
	pbp_b20_bendesc_yn               = 'Outpt Drg Ben Desc YN'
	pbp_b20_bendesc_amo              = 'Outpt Drg Ben Desc AMO'
	pbp_b20_bendesc_grp_num          = 'Outpt Drg Groupings Offered'
	pbp_b20_maxplan_yn               = 'Outpt Drg Max Plan 1 YN'
	pbp_b20_maxplan_types            = 'Outpt Drg Max Plan Types'
	pbp_b20_maxplan_net_copay_yn     = 'Outpt Drg Max Cov Net of Copay'
	pbp_b20_maxplan_per              = 'Outpt Drg CDT Max Plan Per'
	pbp_b20_maxplan_per_d            = 'Outpt Drg CDT Max Pln Desc'
	pbp_b20_maxplan_amt_1yr          = 'Outpt Drg Max Plan Net A Amt'
	pbp_b20_maxplan_amt_6mth         = 'Outpt Drg Max Plan Net S Amt'
	pbp_b20_maxplan_amt_3mth         = 'Outpt Drg Max Plan Net Q Amt'
	pbp_b20_maxplan_amt_1mth         = 'Outpt Drg Max Plan Net M Amt'
	pbp_b20_maxplan_amt_oth          = 'Outpt Drg Max Plan Net O Amt'
	pbp_b20_maxplan_unused_yn        = 'Outpt Drg Max Plan Unused YN'
	pbp_b20_maxplan_cdt              = 'Outpt Drg CDT Max Plan'
	pbp_b20_maxplan_per_cdt          = 'Outpt Drg CDT Max Plan Per'
	pbp_b20_maxplan_per_cdt_d        = 'Outpt Drg CDT Max Pln Desc'
	pbp_b20_maxplan_amt_cdt_1yr      = 'Outpt Drg Max Plan Unu A Amt'
	pbp_b20_maxplan_amt_cdt_6mth     = 'Outpt Drg Max Plan Unu S Amt'
	pbp_b20_maxplan_amt_cdt_3mth     = 'Outpt Drg Max Plan Unu Q Amt'
	pbp_b20_maxplan_amt_cdt_1mth     = 'Outpt Drg Max Plan Unu M Amt'
	pbp_b20_maxplan_amt_cdt_oth      = 'Outpt Drg Max Plan Unu O Amt'
	pbp_b20_maxplan_grp_unlm_yn      = 'Outpt Drg Max Plan Gen Lim YN'
	pbp_b20_maxplan_grp_waived       = 'Outpt Drg Grp Maxpln CovWaived'
	pbp_b20_addl_cost                = 'Outpt Drg Addl Cst higher Cst'
	pbp_b20_maxenr_yn                = 'Outpt Drg Max Enr YN'
	pbp_b20_maxenr_cdt               = 'Outpt Drg Max Enr CDT'
	pbp_b20_maxenr_amt               = 'Outpt Drg Max Enr Amt'
	pbp_b20_maxenr_per               = 'Outpt Drg Max Enr Cost Period'
	pbp_b20_ded_yn                   = 'Outpt Drg Deductible YN'
	pbp_b20_ded_cdt                  = 'Outpt Drg Deductible CDT'
	pbp_b20_ded_amt                  = 'Outpt Drg Deductible Amt'
	pbp_b20_auth_yn                  = 'Outpt Drg Enrollee Auth'
	pbp_b20_grp1_name                = 'Outpt Drg G1 Name'
	pbp_b20_grp1_label               = 'Outpt Drg G1 Label'
	pbp_b20_grp1_drug_types          = 'Outpt Drg G1 Drug Type Covered'
	pbp_b20_grp1_maxplan_yn          = 'Outpt Drg G1 Max Plan YN'
	pbp_b20_grp1_maxplan_per         = 'Outpt Drg G1 Max Plan Per'
	pbp_b20_grp1_maxplan_per_d       = 'Outpt Drg G1 Max Pln Desc'
	pbp_b20_grp1_maxplan_amt_1yr     = 'Outpt Drg G1 A Max Plan Amt'
	pbp_b20_grp1_maxplan_amt_6mth    = 'Outpt Drg G1 S Max Plan Amt'
	pbp_b20_grp1_maxplan_amt_3mth    = 'Outpt Drg G1 Q Max Plan Amt'
	pbp_b20_grp1_maxplan_amt_1mth    = 'Outpt Drg G1 M Max Plan Amt'
	pbp_b20_grp1_maxplan_amt_pres    = 'Outpt Drg G1 Max Plan Amount'
	pbp_b20_grp1_maxplan_amt_oth     = 'Outpt Drg G1 Othr Max Plan Amt'
	pbp_b20_grp1_place               = 'Outpt Drg G1 Place'
	pbp_b20_grp1_place_d             = 'Outpt Drg G1 Place Desc'
	pbp_b20_grp1_coins_yn            = 'Outpt Drg G1 Coinsurance YN'
	pbp_b20_grp1_coins_pct_drp       = 'Outpt Drg G1 DRP Coins Pct'
	pbp_b20_grp1_coins_pct_hmo       = 'Outpt Drg G1 HMO Coins Pct'
	pbp_b20_grp1_coins_pct_mo        = 'Outpt Drg G1 MO Coins Pct'
	pbp_b20_grp1_coins_pct_oth       = 'Outpt Drg G1 Other Coins Pct'
	pbp_b20_grp1_copay_yn            = 'Outpt Drg G1 Copayment YN'
	pbp_b20_grp1_copay_drp_amt       = 'Outpt Drg G1 DRP Copay Amt'
	pbp_b20_grp1_copay_hmo_amt       = 'Outpt Drg G1 HMOCopay Amt'
	pbp_b20_grp1_copay_mo_amt        = 'Outpt Drg G1 MO Copay Amt'
	pbp_b20_grp1_copay_oth_amt       = 'Outpt Drg G1 Other Copay Amt'
	pbp_b20_grp1_drp_days            = 'Outpt Drg G1 DRP # Days'
	pbp_b20_grp1_hmo_days            = 'Outpt Drg G1 HMO # Days'
	pbp_b20_grp1_mo_days             = 'Outpt Drg G1 MO # Days'
	pbp_b20_grp1_oth_days            = 'Outpt Drg G1 Other # Days'
	pbp_b20_grp2_name                = 'Outpt Drg G2 Name'
	pbp_b20_grp2_label               = 'Outpt Drg G2 Label'
	pbp_b20_grp2_drug_types          = 'Outpt Drg G2 Drug Type Covered'
	pbp_b20_grp2_maxplan_yn          = 'Outpt Drg G2 Max Plan YN'
	pbp_b20_grp2_maxplan_per         = 'Outpt Drg G2 Max Plan Per'
	pbp_b20_grp2_maxplan_per_d       = 'Outpt Drg G2 Max Pln Desc'
	pbp_b20_grp2_maxplan_amt_1yr     = 'Outpt Drg G2 A Max Plan Amt'
	pbp_b20_grp2_maxplan_amt_6mth    = 'Outpt Drg G2 S Max Plan Amt'
	pbp_b20_grp2_maxplan_amt_3mth    = 'Outpt Drg G2 Q Max Plan Amt'
	pbp_b20_grp2_maxplan_amt_1mth    = 'Outpt Drg G2 M Max Plan Amt'
	pbp_b20_grp2_maxplan_amt_pres    = 'Outpt Drg G2 Max Plan Amount'
	pbp_b20_grp2_maxplan_amt_oth     = 'Outpt Drg G2 Othr Max Plan Amt'
	pbp_b20_grp2_place               = 'Outpt Drg G2 Place'
	pbp_b20_grp2_place_d             = 'Outpt Drg G2 Place Desc'
	pbp_b20_grp2_coins_yn            = 'Outpt Drg G2 Coinsurance YN'
	pbp_b20_grp2_coins_pct_drp       = 'Outpt Drg G2 DRP Coins Pct'
	pbp_b20_grp2_coins_pct_hmo       = 'Outpt Drg G2 HMO Coins Pct'
	pbp_b20_grp2_coins_pct_mo        = 'Outpt Drg G2 MO Coins Pct'
	pbp_b20_grp2_coins_pct_oth       = 'Outpt Drg G2 Other Coins Pct'
	pbp_b20_grp2_copay_yn            = 'Outpt Drg G2 Copayment YN'
	pbp_b20_grp2_copay_drp_amt       = 'Outpt Drg G2 DRP Copay Amt'
	pbp_b20_grp2_copay_hmo_amt       = 'Outpt Drg G2 HMO Copay Amt'
	pbp_b20_grp2_copay_mo_amt        = 'Outpt Drg G2 MO Copay Amt'
	pbp_b20_grp2_copay_oth_amt       = 'Outpt Drg G2 Other Copay Amt'
	pbp_b20_grp2_drp_days            = 'Outpt Drg G2 DRP # Days'
	pbp_b20_grp2_hmo_days            = 'Outpt Drg G2 HMO # Days'
	pbp_b20_grp2_mo_days             = 'Outpt Drg G2 MO # Days'
	pbp_b20_grp2_oth_days            = 'Outpt Drg G2 Other # Days'
	pbp_b20_grp3_name                = 'Outpt Drg G3 Name'
	pbp_b20_grp3_label               = 'Outpt Drg G3 Label'
	pbp_b20_grp3_drug_types          = 'Outpt Drg G3 Drug Type Covered'
	pbp_b20_grp3_maxplan_yn          = 'Outpt Drg G3 Max Plan YN'
	pbp_b20_grp3_maxplan_per         = 'Outpt Drg G3 Max Plan Per'
	pbp_b20_grp3_maxplan_per_d       = 'Outpt Drg G3 Max Pln Desc'
	pbp_b20_grp3_maxplan_amt_1yr     = 'Outpt Drg G3 A Max Plan Amt'
	pbp_b20_grp3_maxplan_amt_6mth    = 'Outpt Drg G3 S Max Plan Amt'
	pbp_b20_grp3_maxplan_amt_3mth    = 'Outpt Drg G3 Q Max Plan Amt'
	pbp_b20_grp3_maxplan_amt_1mth    = 'Outpt Drg G3 M Max Plan Amt'
	pbp_b20_grp3_maxplan_amt_pres    = 'Outpt Drg G3 Max Plan Amount'
	pbp_b20_grp3_maxplan_amt_oth     = 'Outpt Drg G3 Othr Max Plan Amt'
	pbp_b20_grp3_place               = 'Outpt Drg G3 Place'
	pbp_b20_grp3_place_d             = 'Outpt Drg G3 Place Desc'
	pbp_b20_grp3_coins_yn            = 'Outpt Drg G3 Coinsurance YN'
	pbp_b20_grp3_coins_pct_drp       = 'Outpt Drg G3 DRP Coins Pct'
	pbp_b20_grp3_coins_pct_hmo       = 'Outpt Drg G3 HMO Coins Pct'
	pbp_b20_grp3_coins_pct_mo        = 'Outpt Drg G3 MO Coins Pct'
	pbp_b20_grp3_coins_pct_oth       = 'Outpt Drg G3 Other Coins Pct'
	pbp_b20_grp3_copay_yn            = 'Outpt Drg G3 Copayment YN'
	pbp_b20_grp3_copay_drp_amt       = 'Outpt Drg G3 DRP Copay Amt'
	pbp_b20_grp3_copay_hmo_amt       = 'Outpt Drg G3 HMO Copay Amt'
	pbp_b20_grp3_copay_mo_amt        = 'Outpt Drg G3 MO Copay Amt'
	pbp_b20_grp3_copay_oth_amt       = 'Outpt Drg G3 Other Copay Amt'
	pbp_b20_grp3_drp_days            = 'Outpt Drg G3 DRP # Days'
	pbp_b20_grp3_hmo_days            = 'Outpt Drg G3 HMO # Days'
	pbp_b20_grp3_mo_days             = 'Outpt Drg G3 MO # Days'
	pbp_b20_grp3_oth_days            = 'Outpt Drg G3 Other # Days'
	pbp_b20_grp4_name                = 'Outpt Drg G4 Name'
	pbp_b20_grp4_label               = 'Outpt Drg G4 Label'
	pbp_b20_grp4_drug_types          = 'Outpt Drg G4 Drug Type Covered'
	pbp_b20_grp4_maxplan_yn          = 'Outpt Drg G4 Max Plan YN'
	pbp_b20_grp4_maxplan_per         = 'Outpt Drg G4 Max Plan Per'
	pbp_b20_grp4_maxplan_per_d       = 'Outpt Drg G4 Max Pln Desc'
	pbp_b20_grp4_maxplan_amt_1yr     = 'Outpt Drg G4 A Max Plan Amt'
	pbp_b20_grp4_maxplan_amt_6mth    = 'Outpt Drg G4 S Max Plan Amt'
	pbp_b20_grp4_maxplan_amt_3mth    = 'Outpt Drg G4 Q Max Plan Amt'
	pbp_b20_grp4_maxplan_amt_1mth    = 'Outpt Drg G4 M Max Plan Amt'
	pbp_b20_grp4_maxplan_amt_pres    = 'Outpt Drg G4 Max Plan Amount'
	pbp_b20_grp4_maxplan_amt_oth     = 'Outpt Drg G4 Othr Max Plan Amt'
	pbp_b20_grp4_place               = 'Outpt Drg G4 Place'
	pbp_b20_grp4_place_d             = 'Outpt Drg G4 Place Desc'
	pbp_b20_grp4_coins_yn            = 'Outpt Drg G4 Coins YN'
	pbp_b20_grp4_coins_pct_drp       = 'Outpt Drg G4 DRP Coins Pct'
	pbp_b20_grp4_coins_pct_hmo       = 'Outpt Drg G4 HMO Coins Pct'
	pbp_b20_grp4_coins_pct_mo        = 'Outpt Drg G4 MO Coins Pct'
	pbp_b20_grp4_coins_pct_oth       = 'Outpt Drg G4 Other Coins Pct'
	pbp_b20_grp4_copay_yn            = 'Outpt Drg G4 Copayment YN'
	pbp_b20_grp4_copay_drp_amt       = 'Outpt Drg G4 DRP Copay Amt'
	pbp_b20_grp4_copay_hmo_amt       = 'Outpt Drg G4 HMO Copay Amt'
	pbp_b20_grp4_copay_mo_amt        = 'Outpt Drg G4 MO Copay Amt'
	pbp_b20_grp4_copay_oth_amt       = 'Outpt Drg G4 Other Copay Amt'
	pbp_b20_grp4_drp_days            = 'Outpt Drg G4 DRP # Days'
	pbp_b20_grp4_hmo_days            = 'Outpt Drg G4 HMO # Days'
	pbp_b20_grp4_mo_days             = 'Outpt Drg G4 MO # Days'
	pbp_b20_grp4_oth_days            = 'Outpt Drg G4 Other # Days'
	pbp_b20_grp5_name                = 'Outpt Drg G5 Name'
	pbp_b20_grp5_label               = 'Outpt Drg G5 Label'
	pbp_b20_grp5_drug_types          = 'Outpt Drg G5 Drug Type Covered'
	pbp_b20_grp5_maxplan_yn          = 'Outpt Drg G5 Max Plan YN'
	pbp_b20_grp5_maxplan_per         = 'Outpt Drg G5 Max Plan Per'
	pbp_b20_grp5_maxplan_per_d       = 'Outpt Drg G5 Max Pln Desc'
	pbp_b20_grp5_maxplan_amt_1yr     = 'Outpt Drg G5 A Max Plan Amt'
	pbp_b20_grp5_maxplan_amt_6mth    = 'Outpt Drg G5 S Max Plan Amt'
	pbp_b20_grp5_maxplan_amt_3mth    = 'Outpt Drg G5 Q Max Plan Amt'
	pbp_b20_grp5_maxplan_amt_1mth    = 'Outpt Drg G5 M Max Plan Amt'
	pbp_b20_grp5_maxplan_amt_pres    = 'Outpt Drg G5 Max Plan Amount'
	pbp_b20_grp5_maxplan_amt_oth     = 'Outpt Drg G5 Othr Max Plan Amt'
	pbp_b20_grp5_place               = 'Outpt Drg G5 Place'
	pbp_b20_grp5_place_d             = 'Outpt Drg G5 Place Desc'
	pbp_b20_grp5_coins_yn            = 'Outpt Drg G5 Coins YN'
	pbp_b20_grp5_coins_pct_drp       = 'Outpt Drg G5 DRP Coins Pct'
	pbp_b20_grp5_coins_pct_hmo       = 'Outpt Drg G5 HMO Coins Pct'
	pbp_b20_grp5_coins_pct_mo        = 'Outpt Drg G5 MO Coins Pct'
	pbp_b20_grp5_coins_pct_oth       = 'Outpt Drg G5 Other Coins Pct'
	pbp_b20_grp5_copay_yn            = 'Outpt Drg G5 Copayment YN'
	pbp_b20_grp5_copay_drp_amt       = 'Outpt Drg G5 DRP Copay Amt'
	pbp_b20_grp5_copay_hmo_amt       = 'Outpt Drg G5 HMO Copay Amt'
	pbp_b20_grp5_copay_mo_amt        = 'Outpt Drg G5 MO Copay Amt'
	pbp_b20_grp5_copay_oth_amt       = 'Outpt Drg G5 Other Copay Amt'
	pbp_b20_grp5_drp_days            = 'Outpt Drg G5 DRP # Days'
	pbp_b20_grp5_hmo_days            = 'Outpt Drg G5 HMO # Days'
	pbp_b20_grp5_mo_days             = 'Outpt Drg G5 MO # Days'
	pbp_b20_grp5_oth_days            = 'Outpt Drg G5 Other # Days'
	pbp_b20_hi_yn                    = 'Outpt Drg Home Infusion'
	pbp_d_opt_identifier             = 'Opt Sup Benefits Identifier'
;

run;

proc sort data = pbp_step20 out=out.pbp_step20;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_step20(obs = 10);
  title 'pbp_step20 file ';
run;

proc means data = out.pbp_step20;
  title 'pbp_step20 file ';
run;

proc freq data = out.pbp_step20;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_d_opt_use_mand_20_yn
	pbp_b20_bendesc_yn
	pbp_b20_bendesc_amo
	pbp_b20_bendesc_grp_num
	pbp_b20_maxplan_yn
	pbp_b20_maxplan_types
	pbp_b20_maxplan_net_copay_yn
	pbp_b20_maxplan_per
	pbp_b20_maxplan_unused_yn
	pbp_b20_maxplan_cdt
	pbp_b20_maxplan_per_cdt
	pbp_b20_maxplan_grp_unlm_yn
	pbp_b20_maxplan_grp_waived
	pbp_b20_addl_cost
	pbp_b20_maxenr_yn
	pbp_b20_maxenr_per
	pbp_b20_ded_yn
	pbp_b20_auth_yn
	pbp_b20_grp1_label
	pbp_b20_grp1_drug_types
	pbp_b20_grp1_maxplan_yn
	pbp_b20_grp1_place
	pbp_b20_grp1_coins_yn
	pbp_b20_grp1_copay_yn
	pbp_b20_grp2_label
	pbp_b20_grp2_drug_types
	pbp_b20_grp2_maxplan_yn
	pbp_b20_grp2_place
	pbp_b20_grp2_coins_yn
	pbp_b20_grp2_copay_yn
	pbp_b20_grp3_label
	pbp_b20_grp3_drug_types
	pbp_b20_grp3_maxplan_yn
	pbp_b20_grp3_place
	pbp_b20_grp3_coins_yn
	pbp_b20_grp3_copay_yn
	pbp_b20_grp4_label
	pbp_b20_grp4_drug_types
	pbp_b20_grp4_maxplan_yn
	pbp_b20_grp4_place
	pbp_b20_grp4_coins_yn
	pbp_b20_grp4_copay_yn
	pbp_b20_grp5_label
	pbp_b20_grp5_drug_types
	pbp_b20_grp5_maxplan_yn
	pbp_b20_grp5_place
	pbp_b20_grp5_coins_yn
	pbp_b20_grp5_copay_yn
	pbp_b20_hi_yn
	pbp_d_opt_identifier
/ missing;
run;

proc contents data = out.pbp_step20;
  title 'pbp_step20 data';
run;