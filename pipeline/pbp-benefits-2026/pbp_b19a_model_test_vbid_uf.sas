*pbp_b19a_model_test_vbid_uf.sas;

libname out '.\sas_data_sets\PBP';
options pageno=1 linesize = 200 nocenter;

data pbp_b19a_vbid;

length
	pbp_a_hnumber                    $5
	pbp_a_plan_identifier            $3
	pbp_a_ben_cov                    $1
	pbp_a_plan_type                  $2
	orgtype                          $2
	bid_id                           $13
	pbp_vbid_group_id                $2
	pbp_b19a_package_type            $2
	pbp_b19a_package_name            $4000
	pbp_b19a_tm_vbid                 $3
	pbp_b19a_states_ehc_vbd          $10
	pbp_b19a_states_ehc_vbd_d        $4000
	pbp_b19a_all_dis_yn              $1
	pbp_b19a_cmb_dis_yn              $1
	pbp_b19a_cmb_dis_d               $4000
	pbp_b19a_lis_vbid                $5
	pbp_b19a_states_ehc_ssbci        $27
	pbp_b19a_states_ssbci_other1     $250
	pbp_b19a_states_ssbci_other2     $250
	pbp_b19a_states_ssbci_other3     $250
	pbp_b19a_states_ssbci_other4     $250
	pbp_b19a_states_ssbci_other5     $250
	pbp_b19a_states_ehc_uf           $14
	pbp_b19a_states_uf_other1        $250
	pbp_b19a_states_uf_other2        $250
	pbp_b19a_states_uf_other3        $250
	pbp_b19a_states_uf_other4        $250
	pbp_b19a_states_uf_other5        $250
	pbp_b19a_states_uf_all_yn        $1
	pbp_b19a_states_uf_cmb_yn        $1
	pbp_b19a_states_uf_cmb_d         $4000
	pbp_b19a_reduct_prereq_yn        $1
	pbp_b19a_reduct_prereq           $3
	pbp_b19a_reduct_prereq_d         $4000
	pbp_b19a_reduct_zero_yn          $1
	pbp_b19a_red_bens                $2
	pbp_b19a_red_mc_bendesc_cats     $4000
	pbp_b19a_bendesc_special         $1
	pbp_b19a_red_nmc_bendesc_cats    $4000
	pbp_b19a_reduct_apply_yn         $1
	pbp_b19a_reduct_exempt_yn        $1
	pbp_b19a_red_exempt_bens         $2
	pbp_b19a_red_exempt_mc_cats      $4000
	pbp_b19a_red_exempt_nmc_cats     $4000
	pbp_b19a_coins_yn                $1
	pbp_b19a_red_coins_bens          $2
	pbp_b19a_red_coins_mc_cats       $4000
	pbp_b19a_red_coins_nmc_cats      $4000
	pbp_b19a_reduct_deduct_yn        $1
	pbp_b19a_red_deduct_cats         $4000
	pbp_b19a_copay_yn                $1
	pbp_b19a_red_copay_bens          $2
	pbp_b19a_red_copay_mc_cats       $4000
	pbp_b19a_red_copay_nmc_cats      $4000
	pbp_b19a_special_coins_yn        $1
	pbp_b19a_special_coins_cats      $4000
	pbp_b19a_special_deduct_yn       $1
	pbp_b19a_special_deduct_cats     $4000
	pbp_b19a_special_copay_yn        $1
	pbp_b19a_special_copay_cats      $4000
	pbp_b19a_agg_yn                  $1
	pbp_b19a_agg_mode                $5
	pbp_b19a_agg_mode_desc           $4000
;

infile '.\pbp\pbp_b19a_model_test_vbid_uf.txt' delimiter = '09'x
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
	pbp_b19a_package_type
	pbp_b19a_package_name
	pbp_b19a_tm_vbid
	pbp_b19a_states_ehc_vbd
	pbp_b19a_states_ehc_vbd_d
	pbp_b19a_all_dis_yn
	pbp_b19a_cmb_dis_yn
	pbp_b19a_cmb_dis_d
	pbp_b19a_lis_vbid
	pbp_b19a_enr_tar_vbid
	pbp_b19a_enr_eng_vbid
	pbp_b19a_states_ehc_ssbci
	pbp_b19a_states_ssbci_other1
	pbp_b19a_states_ssbci_other2
	pbp_b19a_states_ssbci_other3
	pbp_b19a_states_ssbci_other4
	pbp_b19a_states_ssbci_other5
	pbp_b19a_states_ehc_uf
	pbp_b19a_states_uf_other1
	pbp_b19a_states_uf_other2
	pbp_b19a_states_uf_other3
	pbp_b19a_states_uf_other4
	pbp_b19a_states_uf_other5
	pbp_b19a_states_uf_all_yn
	pbp_b19a_states_uf_cmb_yn
	pbp_b19a_states_uf_cmb_d
	pbp_b19a_reduct_prereq_yn
	pbp_b19a_reduct_prereq
	pbp_b19a_reduct_prereq_d
	pbp_b19a_reduct_zero_yn
	pbp_b19a_red_bens
	pbp_b19a_red_mc_bendesc_cats
	pbp_b19a_bendesc_special
	pbp_b19a_red_nmc_bendesc_cats
	pbp_b19a_reduct_apply_yn
	pbp_b19a_reduct_exempt_yn
	pbp_b19a_red_exempt_bens
	pbp_b19a_red_exempt_mc_cats
	pbp_b19a_red_exempt_nmc_cats
	pbp_b19a_coins_yn
	pbp_b19a_red_coins_bens
	pbp_b19a_red_coins_mc_cats
	pbp_b19a_red_coins_nmc_cats
	pbp_b19a_coins_crs_min
	pbp_b19a_coins_crs_max
	pbp_b19a_coins_icrs_min
	pbp_b19a_coins_icrs_max
	pbp_b19a_coins_prs_min
	pbp_b19a_coins_prs_max
	pbp_b19a_coins_setpad_min
	pbp_b19a_coins_setpad_max
	pbp_b19a_coins_emerg_min
	pbp_b19a_coins_emerg_max
	pbp_b19a_coins_urgent_min
	pbp_b19a_coins_urgent_max
	pbp_b19a_coins_partial_min
	pbp_b19a_coins_partial_max
	pbp_b19a_coins_5b_min
	pbp_b19a_coins_5b_max
	pbp_b19a_coins_home_min
	pbp_b19a_coins_home_max
	pbp_b19a_coins_primary_min
	pbp_b19a_coins_primary_max
	pbp_b19a_coins_chiro_min
	pbp_b19a_coins_chiro_max
	pbp_b19a_coins_occup_min
	pbp_b19a_coins_occup_max
	pbp_b19a_coins_special_min
	pbp_b19a_coins_special_max
	pbp_b19a_coins_ismss_min
	pbp_b19a_coins_ismss_max
	pbp_b19a_coins_gsmss_min
	pbp_b19a_coins_gsmss_max
	pbp_b19a_coins_pod_min
	pbp_b19a_coins_pod_max
	pbp_b19a_coins_ohcp_min
	pbp_b19a_coins_ohcp_max
	pbp_b19a_coins_isps_min
	pbp_b19a_coins_isps_max
	pbp_b19a_coins_gsps_min
	pbp_b19a_coins_gsps_max
	pbp_b19a_coins_ptslps_min
	pbp_b19a_coins_ptslps_max
	pbp_b19a_coins_tele_min
	pbp_b19a_coins_tele_max
	pbp_b19a_coins_ots_min
	pbp_b19a_coins_ots_max
	pbp_b19a_coins_diag_min
	pbp_b19a_coins_diag_max
	pbp_b19a_coins_lab_min
	pbp_b19a_coins_lab_max
	pbp_b19a_coins_drs_min
	pbp_b19a_coins_drs_max
	pbp_b19a_coins_trs_min
	pbp_b19a_coins_trs_max
	pbp_b19a_coins_xray_min
	pbp_b19a_coins_xray_max
	pbp_b19a_coins_ohs_min
	pbp_b19a_coins_ohs_max
	pbp_b19a_coins_obsserv_min
	pbp_b19a_coins_obsserv_max
	pbp_b19a_coins_asc_min
	pbp_b19a_coins_asc_max
	pbp_b19a_coins_osa_min
	pbp_b19a_coins_osa_max
	pbp_b19a_coins_osa2_min
	pbp_b19a_coins_osa2_max
	pbp_b19a_coins_obs_min
	pbp_b19a_coins_obs_max
	pbp_b19a_coins_amb_min
	pbp_b19a_coins_amb_max
	pbp_b19a_coins_airamb_min
	pbp_b19a_coins_airamb_max
	pbp_b19a_coins_dme_min
	pbp_b19a_coins_dme_max
	pbp_b19a_coins_pros_min
	pbp_b19a_coins_pros_max
	pbp_b19a_coins_medical_min
	pbp_b19a_coins_medical_max
	pbp_b19a_coins_diabsup_min
	pbp_b19a_coins_diabsup_max
	pbp_b19a_coins_diabt_min
	pbp_b19a_coins_diabt_max
	pbp_b19a_coins_dial_min
	pbp_b19a_coins_dial_max
	pbp_b19a_coins_14a_min
	pbp_b19a_coins_14a_max
	pbp_b19a_coins_kdes_min
	pbp_b19a_coins_kdes_max
	pbp_b19a_coins_glauc_min
	pbp_b19a_coins_glauc_max
	pbp_b19a_coins_diabsmt_min
	pbp_b19a_coins_diabsmt_max
	pbp_b19a_coins_dre_min
	pbp_b19a_coins_dre_max
	pbp_b19a_coins_ekg_min
	pbp_b19a_coins_ekg_max
	pbp_b19a_coins_15_1_i_min
	pbp_b19a_coins_15_1_i_max
	pbp_b19a_coins_chemodrugs_min
	pbp_b19a_coins_chemodrugs_max
	pbp_b19a_coins_othbdrugs_min
	pbp_b19a_coins_othbdrugs_max
	pbp_b19a_coins_16a_min
	pbp_b19a_coins_16a_max
	pbp_b19a_coins_eyeexam_min
	pbp_b19a_coins_eyeexam_max
	pbp_b19a_coins_eyewear_min
	pbp_b19a_coins_eyewear_max
	pbp_b19a_coins_hear_min
	pbp_b19a_coins_hear_max
	pbp_b19a_coins_20_min
	pbp_b19a_coins_20_max
	pbp_b19a_coins_acrs_min
	pbp_b19a_coins_acrs_max
	pbp_b19a_coins_aicrs_min
	pbp_b19a_coins_aicrs_max
	pbp_b19a_coins_aprs_min
	pbp_b19a_coins_aprs_max
	pbp_b19a_coins_nmc_setpad_min
	pbp_b19a_coins_nmc_setpad_max
	pbp_b19a_coins_wec_min
	pbp_b19a_coins_wec_max
	pbp_b19a_coins_wuc_min
	pbp_b19a_coins_wuc_max
	pbp_b19a_coins_wet_min
	pbp_b19a_coins_wet_max
	pbp_b19a_coins_chiro_rc_min
	pbp_b19a_coins_chiro_rc_max
	pbp_b19a_coins_chiro_oth_min
	pbp_b19a_coins_chiro_oth_max
	pbp_b19a_coins_podrt_min
	pbp_b19a_coins_podrt_max
	pbp_b19a_coins_transpal_min
	pbp_b19a_coins_transpal_max
	pbp_b19a_coins_transal_min
	pbp_b19a_coins_transal_max
	pbp_b19a_coins_acupunc_min
	pbp_b19a_coins_acupunc_max
	pbp_b19a_coins_otc_min
	pbp_b19a_coins_otc_max
	pbp_b19a_coins_meal_min
	pbp_b19a_coins_meal_max
	pbp_b19a_coins_nmc_other1_min
	pbp_b19a_coins_nmc_other1_max
	pbp_b19a_coins_nmc_other2_min
	pbp_b19a_coins_nmc_other2_max
	pbp_b19a_coins_nmc_other3_min
	pbp_b19a_coins_nmc_other3_max
	pbp_b19a_coins_ape_min
	pbp_b19a_coins_ape_max
	pbp_b19a_coins_health_min
	pbp_b19a_coins_health_max
	pbp_b19a_coins_nutrition_min
	pbp_b19a_coins_nutrition_max
	pbp_b19a_coins_asstcc_min
	pbp_b19a_coins_asstcc_max
	pbp_b19a_coins_fitness_min
	pbp_b19a_coins_fitness_max
	pbp_b19a_coins_edm_min
	pbp_b19a_coins_edm_max
	pbp_b19a_coins_ts_min
	pbp_b19a_coins_ts_max
	pbp_b19a_coins_rat_min
	pbp_b19a_coins_rat_max
	pbp_b19a_coins_bsd_min
	pbp_b19a_coins_bsd_max
	pbp_b19a_coins_cs_min
	pbp_b19a_coins_cs_max
	pbp_b19a_coins_ihsa_min
	pbp_b19a_coins_ihsa_max
	pbp_b19a_coins_pers_min
	pbp_b19a_coins_pers_max
	pbp_b19a_coins_mnt_min
	pbp_b19a_coins_mnt_max
	pbp_b19a_coins_postdis_min
	pbp_b19a_coins_postdis_max
	pbp_b19a_coins_readmis_min
	pbp_b19a_coins_readmis_max
	pbp_b19a_coins_wigs_min
	pbp_b19a_coins_wigs_max
	pbp_b19a_coins_weight_min
	pbp_b19a_coins_weight_max
	pbp_b19a_coins_at_min
	pbp_b19a_coins_at_max
	pbp_b19a_coins_massg_min
	pbp_b19a_coins_massg_max
	pbp_b19a_coins_adult_min
	pbp_b19a_coins_adult_max
	pbp_b19a_coins_homep_min
	pbp_b19a_coins_homep_max
	pbp_b19a_coins_ihome_min
	pbp_b19a_coins_ihome_max
	pbp_b19a_coins_careg_min
	pbp_b19a_coins_careg_max
	pbp_b19a_coins_15_nmc_min
	pbp_b19a_coins_15_nmc_max
	pbp_b19a_coins_16b1_min
	pbp_b19a_coins_16b1_max
	pbp_b19a_coins_16b2_min
	pbp_b19a_coins_16b2_max
	pbp_b19a_coins_16b3_min
	pbp_b19a_coins_16b3_max
	pbp_b19a_coins_16b4_min
	pbp_b19a_coins_16b4_max
	pbp_b19a_coins_16b5_min
	pbp_b19a_coins_16b5_max
	pbp_b19a_coins_16b6_min
	pbp_b19a_coins_16b6_max
	pbp_b19a_coins_16c1_min
	pbp_b19a_coins_16c1_max
	pbp_b19a_coins_16c2_min
	pbp_b19a_coins_16c2_max
	pbp_b19a_coins_16c3_min
	pbp_b19a_coins_16c3_max
	pbp_b19a_coins_16c4_min
	pbp_b19a_coins_16c4_max
	pbp_b19a_coins_16c5_min
	pbp_b19a_coins_16c5_max
	pbp_b19a_coins_16c6_min
	pbp_b19a_coins_16c6_max
	pbp_b19a_coins_16c7_min
	pbp_b19a_coins_16c7_max
	pbp_b19a_coins_16c8_min
	pbp_b19a_coins_16c8_max
	pbp_b19a_coins_16c9_min
	pbp_b19a_coins_16c9_max
	pbp_b19a_coins_16c10_min
	pbp_b19a_coins_16c10_max
	pbp_b19a_coins_routineeye_min
	pbp_b19a_coins_routineeye_max
	pbp_b19a_coins_oth_eye_min
	pbp_b19a_coins_oth_eye_max
	pbp_b19a_coins_cl_min
	pbp_b19a_coins_cl_max
	pbp_b19a_coins_eglf_min
	pbp_b19a_coins_eglf_max
	pbp_b19a_coins_egl_min
	pbp_b19a_coins_egl_max
	pbp_b19a_coins_egf_min
	pbp_b19a_coins_egf_max
	pbp_b19a_coins_upgrades_min
	pbp_b19a_coins_upgrades_max
	pbp_b19a_coins_routinehear_min
	pbp_b19a_coins_routinehear_max
	pbp_b19a_coins_fiteval_min
	pbp_b19a_coins_fiteval_max
	pbp_b19a_coins_hearingat_min
	pbp_b19a_coins_hearingat_max
	pbp_b19a_coins_hearingie_min
	pbp_b19a_coins_hearingie_max
	pbp_b19a_coins_hearingoe_min
	pbp_b19a_coins_hearingoe_max
	pbp_b19a_coins_hearingote_min
	pbp_b19a_coins_hearingote_max
	pbp_b19a_coins_18c_min
	pbp_b19a_coins_18c_max
	pbp_b19a_reduct_deduct_yn
	pbp_b19a_red_deduct_cats
	pbp_b19a_deduct_iha_amt
	pbp_b19a_deduct_1a_nmc_amt
	pbp_b19a_deduct_1a1_amt
	pbp_b19a_deduct_1a2_amt
	pbp_b19a_deduct_1a3_amt
	pbp_b19a_deduct_ihp_amt
	pbp_b19a_deduct_1b_nmc_amt
	pbp_b19a_deduct_1b1_amt
	pbp_b19a_deduct_1b2_amt
	pbp_b19a_deduct_snf_amt
	pbp_b19a_deduct_2_nmc_amt
	pbp_b19a_deduct_2_1_amt
	pbp_b19a_deduct_3_1_amt
	pbp_b19a_deduct_3_2_amt
	pbp_b19a_deduct_3_3_amt
	pbp_b19a_deduct_3_4_amt
	pbp_b19a_deduct_3_1_nmc_amt
	pbp_b19a_deduct_3_2_nmc_amt
	pbp_b19a_deduct_3_3_nmc_amt
	pbp_b19a_deduct_3_4_nmc_amt
	pbp_b19a_deduct_4a_amt
	pbp_b19a_deduct_4b_amt
	pbp_b19a_deduct_4c1_amt
	pbp_b19a_deduct_4c2_amt
	pbp_b19a_deduct_4c3_amt
	pbp_b19a_deduct_ph_amt
	pbp_b19a_deduct_5b_amt
	pbp_b19a_deduct_hhs_amt
	pbp_b19a_deduct_pcps_amt
	pbp_b19a_deduct_chiro_amt
	pbp_b19a_deduct_7b1_amt
	pbp_b19a_deduct_7b2_amt
	pbp_b19a_deduct_occup_amt
	pbp_b19a_deduct_pss_amt
	pbp_b19a_deduct_7e1_amt
	pbp_b19a_deduct_7e2_amt
	pbp_b19a_deduct_pod_amt
	pbp_b19a_deduct_7f_nmc_amt
	pbp_b19a_deduct_ohcp_amt
	pbp_b19a_deduct_7h1_amt
	pbp_b19a_deduct_7h2_amt
	pbp_b19a_deduct_ptslps_amt
	pbp_b19a_deduct_tele_amt
	pbp_b19a_deduct_ots_amt
	pbp_b19a_deduct_8a1_amt
	pbp_b19a_deduct_8a2_amt
	pbp_b19a_deduct_8b1_amt
	pbp_b19a_deduct_8b2_amt
	pbp_b19a_deduct_8b3_amt
	pbp_b19a_deduct_ohs_amt
	pbp_b19a_deduct_obsserv_amt
	pbp_b19a_deduct_asc_amt
	pbp_b19a_deduct_9c1_amt
	pbp_b19a_deduct_9c2_amt
	pbp_b19a_deduct_obs_amt
	pbp_b19a_deduct_amb_amt
	pbp_b19a_deduct_airamb_amt
	pbp_b19a_deduct_10b1_amt
	pbp_b19a_deduct_10b2_amt
	pbp_b19a_deduct_dme_amt
	pbp_b19a_deduct_11b1_amt
	pbp_b19a_deduct_11b2_amt
	pbp_b19a_deduct_11c1_amt
	pbp_b19a_deduct_11c2_amt
	pbp_b19a_deduct_dialysis_amt
	pbp_b19a_deduct_acupunc_amt
	pbp_b19a_deduct_otc_amt
	pbp_b19a_deduct_meal_amt
	pbp_b19a_deduct_other1_amt
	pbp_b19a_deduct_other2_amt
	pbp_b19a_deduct_other3_amt
	pbp_b19a_deduct_14a_amt
	pbp_b19a_deduct_ape_amt
	pbp_b19a_deduct_health_amt
	pbp_b19a_deduct_nutrition_amt
	pbp_b19a_deduct_asstcc_amt
	pbp_b19a_deduct_fitness_amt
	pbp_b19a_deduct_edm_amt
	pbp_b19a_deduct_ts_amt
	pbp_b19a_deduct_rat_amt
	pbp_b19a_deduct_bsd_amt
	pbp_b19a_deduct_cs_amt
	pbp_b19a_deduct_ihsa_amt
	pbp_b19a_deduct_pers_amt
	pbp_b19a_deduct_mnt_amt
	pbp_b19a_deduct_pdimr_amt
	pbp_b19a_deduct_rap_amt
	pbp_b19a_deduct_wigs_amt
	pbp_b19a_deduct_wmp_amt
	pbp_b19a_deduct_at_amt
	pbp_b19a_deduct_massg_amt
	pbp_b19a_deduct_adult_amt
	pbp_b19a_deduct_homep_amt
	pbp_b19a_deduct_ihome_amt
	pbp_b19a_deduct_careg_amt
	pbp_b19a_deduct_kdes_amt
	pbp_b19a_deduct_glauc_amt
	pbp_b19a_deduct_dsmt_amt
	pbp_b19a_deduct_dre_amt
	pbp_b19a_deduct_ekg_amt
	pbp_b19a_deduct_15_1_i_amt
	pbp_b19a_deduct_15_2_amt
	pbp_b19a_deduct_15_3_amt
	pbp_b19a_deduct_15_nmc_amt
	pbp_b19a_deduct_16a_n_amt
	pbp_b19a_deduct_16b1_n_amt
	pbp_b19a_deduct_16b2_n_amt
	pbp_b19a_deduct_16b3_n_amt
	pbp_b19a_deduct_16b4_n_amt
	pbp_b19a_deduct_16b5_n_amt
	pbp_b19a_deduct_16b6_n_amt
	pbp_b19a_deduct_16c1_n_amt
	pbp_b19a_deduct_16c2_n_amt
	pbp_b19a_deduct_16c3_n_amt
	pbp_b19a_deduct_16c4_n_amt
	pbp_b19a_deduct_16c5_n_amt
	pbp_b19a_deduct_16c6_n_amt
	pbp_b19a_deduct_16c7_n_amt
	pbp_b19a_deduct_16c8_n_amt
	pbp_b19a_deduct_16c9_n_amt
	pbp_b19a_deduct_16c10_n_amt
	pbp_b19a_deduct_eyeexam_amt
	pbp_b19a_deduct_17a1_amt
	pbp_b19a_deduct_17a2_amt
	pbp_b19a_deduct_eyewear_amt
	pbp_b19a_deduct_17b1_amt
	pbp_b19a_deduct_17b2_amt
	pbp_b19a_deduct_17b3_amt
	pbp_b19a_deduct_17b4_amt
	pbp_b19a_deduct_17b5_amt
	pbp_b19a_deduct_hearexam_amt
	pbp_b19a_deduct_18a1_amt
	pbp_b19a_deduct_18a2_amt
	pbp_b19a_deduct_18b1_amt
	pbp_b19a_deduct_18b2_amt
	pbp_b19a_deduct_18b3_amt
	pbp_b19a_deduct_18b4_amt
	pbp_b19a_deduct_18c_amt
	pbp_b19a_deduct_20_amt
	pbp_b19a_copay_yn
	pbp_b19a_red_copay_bens
	pbp_b19a_red_copay_mc_cats
	pbp_b19a_red_copay_nmc_cats
	pbp_b19a_copay_crs_min
	pbp_b19a_copay_crs_max
	pbp_b19a_copay_icrs_min
	pbp_b19a_copay_icrs_max
	pbp_b19a_copay_prs_min
	pbp_b19a_copay_prs_max
	pbp_b19a_copay_setpad_min
	pbp_b19a_copay_setpad_max
	pbp_b19a_copay_emerg_min
	pbp_b19a_copay_emerg_max
	pbp_b19a_copay_urgent_min
	pbp_b19a_copay_urgent_max
	pbp_b19a_copay_partial_min
	pbp_b19a_copay_partial_max
	pbp_b19a_copay_5b_min
	pbp_b19a_copay_5b_max
	pbp_b19a_copay_home_min
	pbp_b19a_copay_home_max
	pbp_b19a_copay_primary_min
	pbp_b19a_copay_primary_max
	pbp_b19a_copay_chiro_min
	pbp_b19a_copay_chiro_max
	pbp_b19a_copay_occup_min
	pbp_b19a_copay_occup_max
	pbp_b19a_copay_special_min
	pbp_b19a_copay_special_max
	pbp_b19a_copay_ismss_min
	pbp_b19a_copay_ismss_max
	pbp_b19a_copay_gsmss_min
	pbp_b19a_copay_gsmss_max
	pbp_b19a_copay_pod_min
	pbp_b19a_copay_pod_max
	pbp_b19a_copay_ohcp_min
	pbp_b19a_copay_ohcp_max
	pbp_b19a_copay_isps_min
	pbp_b19a_copay_isps_max
	pbp_b19a_copay_gsps_min
	pbp_b19a_copay_gsps_max
	pbp_b19a_copay_ptslps_min
	pbp_b19a_copay_ptslps_max
	pbp_b19a_copay_tele_min
	pbp_b19a_copay_tele_max
	pbp_b19a_copay_ots_min
	pbp_b19a_copay_ots_max
	pbp_b19a_copay_diag_min
	pbp_b19a_copay_diag_max
	pbp_b19a_copay_lab_min
	pbp_b19a_copay_lab_max
	pbp_b19a_copay_drs_min
	pbp_b19a_copay_drs_max
	pbp_b19a_copay_trs_min
	pbp_b19a_copay_trs_max
	pbp_b19a_copay_xray_min
	pbp_b19a_copay_xray_max
	pbp_b19a_copay_ohs_min
	pbp_b19a_copay_ohs_max
	pbp_b19a_copay_obsserv_min
	pbp_b19a_copay_obsserv_max
	pbp_b19a_copay_asc_min
	pbp_b19a_copay_asc_max
	pbp_b19a_copay_osa_min
	pbp_b19a_copay_osa_max
	pbp_b19a_copay_osa2_min
	pbp_b19a_copay_osa2_max
	pbp_b19a_copay_obs_min
	pbp_b19a_copay_obs_max
	pbp_b19a_copay_amb_min
	pbp_b19a_copay_amb_max
	pbp_b19a_copay_airamb_min
	pbp_b19a_copay_airamb_max
	pbp_b19a_copay_dme_min
	pbp_b19a_copay_dme_max
	pbp_b19a_copay_pros_min
	pbp_b19a_copay_pros_max
	pbp_b19a_copay_medical_min
	pbp_b19a_copay_medical_max
	pbp_b19a_copay_diabsup_min
	pbp_b19a_copay_diabsup_max
	pbp_b19a_copay_diabt_min
	pbp_b19a_copay_diabt_max
	pbp_b19a_copay_dial_min
	pbp_b19a_copay_dial_max
	pbp_b19a_copay_14a_min
	pbp_b19a_copay_14a_max
	pbp_b19a_copay_kdes_min
	pbp_b19a_copay_kdes_max
	pbp_b19a_copay_glauc_min
	pbp_b19a_copay_glauc_max
	pbp_b19a_copay_diabsmt_min
	pbp_b19a_copay_diabsmt_max
	pbp_b19a_copay_dre_min
	pbp_b19a_copay_dre_max
	pbp_b19a_copay_ekg_min
	pbp_b19a_copay_ekg_max
	pbp_b19a_copay_15_1_i_min
	pbp_b19a_copay_15_1_i_max
	pbp_b19a_copay_chemodrugs_min
	pbp_b19a_copay_chemodrugs_max
	pbp_b19a_copay_othbdrugs_min
	pbp_b19a_copay_othbdrugs_max
	pbp_b19a_copay_16a_min
	pbp_b19a_copay_16a_max
	pbp_b19a_copay_eyeexam_min
	pbp_b19a_copay_eyeexam_max
	pbp_b19a_copay_eyewear_min
	pbp_b19a_copay_eyewear_max
	pbp_b19a_copay_hear_min
	pbp_b19a_copay_hear_max
	pbp_b19a_copay_20_min
	pbp_b19a_copay_20_max
	pbp_b19a_copay_acrs_min
	pbp_b19a_copay_acrs_max
	pbp_b19a_copay_aicrs_min
	pbp_b19a_copay_aicrs_max
	pbp_b19a_copay_aprs_min
	pbp_b19a_copay_aprs_max
	pbp_b19a_copay_nmc_setpad_min
	pbp_b19a_copay_nmc_setpad_max
	pbp_b19a_copay_wec_min
	pbp_b19a_copay_wec_max
	pbp_b19a_copay_wuc_min
	pbp_b19a_copay_wuc_max
	pbp_b19a_copay_wet_min
	pbp_b19a_copay_wet_max
	pbp_b19a_copay_chiro_rc_min
	pbp_b19a_copay_chiro_rc_max
	pbp_b19a_copay_chiro_oth_min
	pbp_b19a_copay_chiro_oth_max
	pbp_b19a_copay_podrt_min
	pbp_b19a_copay_podrt_max
	pbp_b19a_copay_transpal_min
	pbp_b19a_copay_transpal_max
	pbp_b19a_copay_transal_min
	pbp_b19a_copay_transal_max
	pbp_b19a_copay_acupunc_min
	pbp_b19a_copay_acupunc_max
	pbp_b19a_copay_otc_min
	pbp_b19a_copay_otc_max
	pbp_b19a_copay_meal_min
	pbp_b19a_copay_meal_max
	pbp_b19a_copay_nmc_other1_min
	pbp_b19a_copay_nmc_other1_max
	pbp_b19a_copay_nmc_other2_min
	pbp_b19a_copay_nmc_other2_max
	pbp_b19a_copay_nmc_other3_min
	pbp_b19a_copay_nmc_other3_max
	pbp_b19a_copay_ape_min
	pbp_b19a_copay_ape_max
	pbp_b19a_copay_health_min
	pbp_b19a_copay_health_max
	pbp_b19a_copay_nutrition_min
	pbp_b19a_copay_nutrition_max
	pbp_b19a_copay_asstcc_min
	pbp_b19a_copay_asstcc_max
	pbp_b19a_copay_fitness_min
	pbp_b19a_copay_fitness_max
	pbp_b19a_copay_edm_min
	pbp_b19a_copay_edm_max
	pbp_b19a_copay_ts_min
	pbp_b19a_copay_ts_max
	pbp_b19a_copay_rat_min
	pbp_b19a_copay_rat_max
	pbp_b19a_copay_bsd_min
	pbp_b19a_copay_bsd_max
	pbp_b19a_copay_cs_min
	pbp_b19a_copay_cs_max
	pbp_b19a_copay_ihsa_min
	pbp_b19a_copay_ihsa_max
	pbp_b19a_copay_pers_min
	pbp_b19a_copay_pers_max
	pbp_b19a_copay_mnt_min
	pbp_b19a_copay_mnt_max
	pbp_b19a_copay_postdis_min
	pbp_b19a_copay_postdis_max
	pbp_b19a_copay_readmis_min
	pbp_b19a_copay_readmis_max
	pbp_b19a_copay_wigs_min
	pbp_b19a_copay_wigs_max
	pbp_b19a_copay_weight_min
	pbp_b19a_copay_weight_max
	pbp_b19a_copay_at_min
	pbp_b19a_copay_at_max
	pbp_b19a_copay_massg_min
	pbp_b19a_copay_massg_max
	pbp_b19a_copay_adult_min
	pbp_b19a_copay_adult_max
	pbp_b19a_copay_homep_min
	pbp_b19a_copay_homep_max
	pbp_b19a_copay_ihome_min
	pbp_b19a_copay_ihome_max
	pbp_b19a_copay_careg_min
	pbp_b19a_copay_careg_max
	pbp_b19a_copay_15_nmc_min
	pbp_b19a_copay_15_nmc_max
	pbp_b19a_copay_16b1_min
	pbp_b19a_copay_16b1_max
	pbp_b19a_copay_16b2_min
	pbp_b19a_copay_16b2_max
	pbp_b19a_copay_16b3_min
	pbp_b19a_copay_16b3_max
	pbp_b19a_copay_16b4_min
	pbp_b19a_copay_16b4_max
	pbp_b19a_copay_16b5_min
	pbp_b19a_copay_16b5_max
	pbp_b19a_copay_16b6_min
	pbp_b19a_copay_16b6_max
	pbp_b19a_copay_16c1_min
	pbp_b19a_copay_16c1_max
	pbp_b19a_copay_16c2_min
	pbp_b19a_copay_16c2_max
	pbp_b19a_copay_16c3_min
	pbp_b19a_copay_16c3_max
	pbp_b19a_copay_16c4_min
	pbp_b19a_copay_16c4_max
	pbp_b19a_copay_16c5_min
	pbp_b19a_copay_16c5_max
	pbp_b19a_copay_16c6_min
	pbp_b19a_copay_16c6_max
	pbp_b19a_copay_16c7_min
	pbp_b19a_copay_16c7_max
	pbp_b19a_copay_16c8_min
	pbp_b19a_copay_16c8_max
	pbp_b19a_copay_16c9_min
	pbp_b19a_copay_16c9_max
	pbp_b19a_copay_16c10_min
	pbp_b19a_copay_16c10_max
	pbp_b19a_copay_routineeye_min
	pbp_b19a_copay_routineeye_max
	pbp_b19a_copay_oth_eye_min
	pbp_b19a_copay_oth_eye_max
	pbp_b19a_copay_cl_min
	pbp_b19a_copay_cl_max
	pbp_b19a_copay_eglf_min
	pbp_b19a_copay_eglf_max
	pbp_b19a_copay_egl_min
	pbp_b19a_copay_egl_max
	pbp_b19a_copay_egf_min
	pbp_b19a_copay_egf_max
	pbp_b19a_copay_upgrades_min
	pbp_b19a_copay_upgrades_max
	pbp_b19a_copay_routinehear_min
	pbp_b19a_copay_routinehear_max
	pbp_b19a_copay_fiteval_min
	pbp_b19a_copay_fiteval_max
	pbp_b19a_copay_hearingat_min
	pbp_b19a_copay_hearingat_max
	pbp_b19a_copay_hearingie_min
	pbp_b19a_copay_hearingie_max
	pbp_b19a_copay_hearingoe_min
	pbp_b19a_copay_hearingoe_max
	pbp_b19a_copay_hearingote_min
	pbp_b19a_copay_hearingote_max
	pbp_b19a_copay_18c_min
	pbp_b19a_copay_18c_max
	pbp_b19a_special_coins_yn
	pbp_b19a_special_coins_cats
	pbp_b19a_coins_pct_004_min
	pbp_b19a_coins_pct_004_max
	pbp_b19a_coins_pct_007_min
	pbp_b19a_coins_pct_007_max
	pbp_b19a_coins_pct_008_min
	pbp_b19a_coins_pct_008_max
	pbp_b19a_coins_pct_011_min
	pbp_b19a_coins_pct_011_max
	pbp_b19a_coins_pct_012_min
	pbp_b19a_coins_pct_012_max
	pbp_b19a_coins_pct_013_min
	pbp_b19a_coins_pct_013_max
	pbp_b19a_coins_pct_014_min
	pbp_b19a_coins_pct_014_max
	pbp_b19a_coins_pct_015_min
	pbp_b19a_coins_pct_015_max
	pbp_b19a_coins_pct_016_min
	pbp_b19a_coins_pct_016_max
	pbp_b19a_coins_pct_017_min
	pbp_b19a_coins_pct_017_max
	pbp_b19a_coins_pct_018_min
	pbp_b19a_coins_pct_018_max
	pbp_b19a_coins_pct_019_min
	pbp_b19a_coins_pct_019_max
	pbp_b19a_coins_pct_020_min
	pbp_b19a_coins_pct_020_max
	pbp_b19a_coins_pct_021_min
	pbp_b19a_coins_pct_021_max
	pbp_b19a_coins_pct_022_min
	pbp_b19a_coins_pct_022_max
	pbp_b19a_coins_pct_023_min
	pbp_b19a_coins_pct_023_max
	pbp_b19a_coins_pct_025_min
	pbp_b19a_coins_pct_025_max
	pbp_b19a_coins_pct_026_min
	pbp_b19a_coins_pct_026_max
	pbp_b19a_coins_pct_027_min
	pbp_b19a_coins_pct_027_max
	pbp_b19a_coins_pct_030_min
	pbp_b19a_coins_pct_030_max
	pbp_b19a_coins_pct_031_min
	pbp_b19a_coins_pct_031_max
	pbp_b19a_coins_pct_033_min
	pbp_b19a_coins_pct_033_max
	pbp_b19a_coins_pct_034_min
	pbp_b19a_coins_pct_034_max
	pbp_b19a_coins_pct_035_min
	pbp_b19a_coins_pct_035_max
	pbp_b19a_coins_pct_000_min
	pbp_b19a_coins_pct_000_max
	pbp_b19a_special_deduct_yn
	pbp_b19a_special_deduct_cats
	pbp_b19a_ded_amt_004
	pbp_b19a_ded_amt_007
	pbp_b19a_ded_amt_008
	pbp_b19a_ded_amt_011
	pbp_b19a_ded_amt_012
	pbp_b19a_ded_amt_013
	pbp_b19a_ded_amt_014
	pbp_b19a_ded_amt_015
	pbp_b19a_ded_amt_016
	pbp_b19a_ded_amt_017
	pbp_b19a_ded_amt_018
	pbp_b19a_ded_amt_019
	pbp_b19a_ded_amt_020
	pbp_b19a_ded_amt_021
	pbp_b19a_ded_amt_022
	pbp_b19a_ded_amt_023
	pbp_b19a_ded_amt_025
	pbp_b19a_ded_amt_026
	pbp_b19a_ded_amt_027
	pbp_b19a_ded_amt_030
	pbp_b19a_ded_amt_031
	pbp_b19a_ded_amt_033
	pbp_b19a_ded_amt_034
	pbp_b19a_ded_amt_035
	pbp_b19a_ded_amt_000
	pbp_b19a_special_copay_yn
	pbp_b19a_special_copay_cats
	pbp_b19a_copay_amt_004_min
	pbp_b19a_copay_amt_004_max
	pbp_b19a_copay_amt_007_min
	pbp_b19a_copay_amt_007_max
	pbp_b19a_copay_amt_008_min
	pbp_b19a_copay_amt_008_max
	pbp_b19a_copay_amt_011_min
	pbp_b19a_copay_amt_011_max
	pbp_b19a_copay_amt_012_min
	pbp_b19a_copay_amt_012_max
	pbp_b19a_copay_amt_013_min
	pbp_b19a_copay_amt_013_max
	pbp_b19a_copay_amt_014_min
	pbp_b19a_copay_amt_014_max
	pbp_b19a_copay_amt_015_min
	pbp_b19a_copay_amt_015_max
	pbp_b19a_copay_amt_016_min
	pbp_b19a_copay_amt_016_max
	pbp_b19a_copay_amt_017_min
	pbp_b19a_copay_amt_017_max
	pbp_b19a_copay_amt_018_min
	pbp_b19a_copay_amt_018_max
	pbp_b19a_copay_amt_019_min
	pbp_b19a_copay_amt_019_max
	pbp_b19a_copay_amt_020_min
	pbp_b19a_copay_amt_020_max
	pbp_b19a_copay_amt_021_min
	pbp_b19a_copay_amt_021_max
	pbp_b19a_copay_amt_022_min
	pbp_b19a_copay_amt_022_max
	pbp_b19a_copay_amt_023_min
	pbp_b19a_copay_amt_023_max
	pbp_b19a_copay_amt_025_min
	pbp_b19a_copay_amt_025_max
	pbp_b19a_copay_amt_026_min
	pbp_b19a_copay_amt_026_max
	pbp_b19a_copay_amt_027_min
	pbp_b19a_copay_amt_027_max
	pbp_b19a_copay_amt_030_min
	pbp_b19a_copay_amt_030_max
	pbp_b19a_copay_amt_031_min
	pbp_b19a_copay_amt_031_max
	pbp_b19a_copay_amt_033_min
	pbp_b19a_copay_amt_033_max
	pbp_b19a_copay_amt_034_min
	pbp_b19a_copay_amt_034_max
	pbp_b19a_copay_amt_035_min
	pbp_b19a_copay_amt_035_max
	pbp_b19a_copay_amt_000_min
	pbp_b19a_copay_amt_000_max
	pbp_b19a_agg_yn
	pbp_b19a_agg_amt
	pbp_b19a_agg_mode
	pbp_b19a_agg_mode_desc
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
	pbp_b19a_package_type            = '19A package type'
	pbp_b19a_package_name            = '19A package name'
	pbp_b19a_tm_vbid                 = '19A VBID Pop Target Method'
	pbp_b19a_states_ehc_vbd          = '19A VBID Pop Diseases'
	pbp_b19a_states_ehc_vbd_d        = '19A Other Disease states desc'
	pbp_b19a_all_dis_yn              = '19A VBID Pop All Disease YN'
	pbp_b19a_cmb_dis_yn              = '19A VBID Pop Combined Disease'
	pbp_b19a_cmb_dis_d               = '19A VBID Pop Combined Desc'
	pbp_b19a_lis_vbid                = '19A VBID Pop LIS Reduction'
	pbp_b19a_enr_tar_vbid            = '19A VBID Pop # Enroll Target'
	pbp_b19a_enr_eng_vbid            = '19A VBID Pop # Enroll Engaged'
	pbp_b19a_states_ehc_ssbci        = '19A SSBCI chronic condition'
	pbp_b19a_states_ssbci_other1     = '19A SSBCI disease other 1'
	pbp_b19a_states_ssbci_other2     = '19A SSBCI disease other 2'
	pbp_b19a_states_ssbci_other3     = '19A SSBCI disease other 3'
	pbp_b19a_states_ssbci_other4     = '19A SSBCI disease other 4'
	pbp_b19a_states_ssbci_other5     = '19A SSBCI disease other 5'
	pbp_b19a_states_ehc_uf           = '19A Reduction Disease states'
	pbp_b19a_states_uf_other1        = '19A UF disease other 1'
	pbp_b19a_states_uf_other2        = '19A UF disease other 2'
	pbp_b19a_states_uf_other3        = '19A UF disease other 3'
	pbp_b19a_states_uf_other4        = '19A UF disease other 4'
	pbp_b19a_states_uf_other5        = '19A UF disease other 5'
	pbp_b19a_states_uf_all_yn        = '19A Need All Diseases YN'
	pbp_b19a_states_uf_cmb_yn        = '19A Need Cmb Diseases YN'
	pbp_b19a_states_uf_cmb_d         = '19A Need Cmb Diseases Desc'
	pbp_b19a_reduct_prereq_yn        = '19A Reduction prerequisite YN'
	pbp_b19a_reduct_prereq           = '19A Reduction prerequisite'
	pbp_b19a_reduct_prereq_d         = '19A Reduction prereq Desc'
	pbp_b19a_reduct_zero_yn          = '19A Reduced Share All Zero'
	pbp_b19a_red_bens                = '19A Red Cost Benefit'
	pbp_b19a_red_mc_bendesc_cats     = '19A MC Red Coin Benefit Cats'
	pbp_b19a_bendesc_special         = '19A  red special yn'
	pbp_b19a_red_nmc_bendesc_cats    = '19A NMC Rdc Coin Benft Cats'
	pbp_b19a_reduct_apply_yn         = '19A Apply OON/POS YN'
	pbp_b19a_reduct_exempt_yn        = '19A Exempt deduct YN'
	pbp_b19a_red_exempt_bens         = '19A Red Cost Exempt Benefit'
	pbp_b19a_red_exempt_mc_cats      = '19A MC Exempt Benefit Cats'
	pbp_b19a_red_exempt_nmc_cats     = '19A Non-MC Expt Benefit Cats'
	pbp_b19a_coins_yn                = '19A VBID Coinsurance YN'
	pbp_b19a_red_coins_bens          = '19A Red Coinsurance Benefits'
	pbp_b19a_red_coins_mc_cats       = '19A MC RCS Categories'
	pbp_b19a_red_coins_nmc_cats      = '19A Non-MC RCS  Benefit Cats'
	pbp_b19a_coins_crs_min           = '19A Coins MC CRS Min'
	pbp_b19a_coins_crs_max           = '19A Coins MC CRS Max'
	pbp_b19a_coins_icrs_min          = '19A Coins MC ICRS Min'
	pbp_b19a_coins_icrs_max          = '19A Coins MC ICRS Max'
	pbp_b19a_coins_prs_min           = '19A Coins MC PRS Min'
	pbp_b19a_coins_prs_max           = '19A Coins MC PRS Max'
	pbp_b19a_coins_setpad_min        = '19A Min Coins Pct PAD'
	pbp_b19a_coins_setpad_max        = '19A Max Coins Pct PAD'
	pbp_b19a_coins_emerg_min         = '19A Emerg Coins Min'
	pbp_b19a_coins_emerg_max         = '19A Emerg Coins Max'
	pbp_b19a_coins_urgent_min        = '19A Coins MC UC Min'
	pbp_b19a_coins_urgent_max        = '19A Coins MC UC Max'
	pbp_b19a_coins_partial_min       = '19A Coins Part Hosp PH Min'
	pbp_b19a_coins_partial_max       = '19A Coins Part Hosp PH Max'
	pbp_b19a_coins_5b_min            = '19A Coins Int Outp PH Min'
	pbp_b19a_coins_5b_max            = '19A Coins Int Outp PH Max'
	pbp_b19a_coins_home_min          = '19A Coins MC HHS Min'
	pbp_b19a_coins_home_max          = '19A Coins MC HHS Max'
	pbp_b19a_coins_primary_min       = '19A Coins MC PCPS Min'
	pbp_b19a_coins_primary_max       = '19A Coins MC PCPS Max'
	pbp_b19a_coins_chiro_min         = '19A Coins MC Chiro Min'
	pbp_b19a_coins_chiro_max         = '19A Coins MC Chiro Max'
	pbp_b19a_coins_occup_min         = '19A Coins MC OTS Min'
	pbp_b19a_coins_occup_max         = '19A Coins MC OTS Max'
	pbp_b19a_coins_special_min       = '19A Coins MC PSS Min'
	pbp_b19a_coins_special_max       = '19A Coins MC PSS Max'
	pbp_b19a_coins_ismss_min         = '19A Coins MC ISMH Min'
	pbp_b19a_coins_ismss_max         = '19A Coins MC ISMH Max'
	pbp_b19a_coins_gsmss_min         = '19A Coins MC GSMH Min'
	pbp_b19a_coins_gsmss_max         = '19A Coins MC GSMH Max'
	pbp_b19a_coins_pod_min           = '19A Coins MC POD Min'
	pbp_b19a_coins_pod_max           = '19A Coins MC POD Max'
	pbp_b19a_coins_ohcp_min          = '19A Coins MC OHCP Min'
	pbp_b19a_coins_ohcp_max          = '19A Coins MC OHCP Max'
	pbp_b19a_coins_isps_min          = '19A Coins MC ISPS Min'
	pbp_b19a_coins_isps_max          = '19A Coins MC ISPS Max'
	pbp_b19a_coins_gsps_min          = '19A Coins MC GSPS Min'
	pbp_b19a_coins_gsps_max          = '19A Coins MC GSPS Max'
	pbp_b19a_coins_ptslps_min        = '19A Coins MC PTSLPS Min'
	pbp_b19a_coins_ptslps_max        = '19A Coins MC PTSLPS Max'
	pbp_b19a_coins_tele_min          = '19A Min Coins Pct Tele'
	pbp_b19a_coins_tele_max          = '19A Max Coins Pct Tele'
	pbp_b19a_coins_ots_min           = '19A Min Coins Pct OTS'
	pbp_b19a_coins_ots_max           = '19A Max Coins Pct OTS'
	pbp_b19a_coins_diag_min          = '19A Coins MC DIAG Min'
	pbp_b19a_coins_diag_max          = '19A Coins MC DIAG Max'
	pbp_b19a_coins_lab_min           = '19A Coins MC LAB Min'
	pbp_b19a_coins_lab_max           = '19A Coins MC LAB Max'
	pbp_b19a_coins_drs_min           = '19A Coins MC DRS Min'
	pbp_b19a_coins_drs_max           = '19A Coins MC DRS Max'
	pbp_b19a_coins_trs_min           = '19A Coins MC TRS Min'
	pbp_b19a_coins_trs_max           = '19A Coins MC TRS Max'
	pbp_b19a_coins_xray_min          = '19A Coins MC XRS Min'
	pbp_b19a_coins_xray_max          = '19A Coins MC XRS Max'
	pbp_b19a_coins_ohs_min           = '19A Coins MC OHS Min'
	pbp_b19a_coins_ohs_max           = '19A Coins MC OHS Max'
	pbp_b19a_coins_obsserv_min       = '19A Srvcs Min Coins ObsServ'
	pbp_b19a_coins_obsserv_max       = '19A Srvcs Max Coins ObsServ'
	pbp_b19a_coins_asc_min           = '19A Coins MC ASC Min'
	pbp_b19a_coins_asc_max           = '19A Coins MC ASC Max'
	pbp_b19a_coins_osa_min           = '19A Srvcs Min Coins OSA'
	pbp_b19a_coins_osa_max           = '19A Srvcs Max Coins OSA'
	pbp_b19a_coins_osa2_min          = '19A Srvcs Min Coins OSA2'
	pbp_b19a_coins_osa2_max          = '19A Srvcs Max Coins OSA2'
	pbp_b19a_coins_obs_min           = '19A Srvcs Min Coins OBS'
	pbp_b19a_coins_obs_max           = '19A Srvcs Max Coins OBS'
	pbp_b19a_coins_amb_min           = '19A AMB Coins Min'
	pbp_b19a_coins_amb_max           = '19A AMB Coins Max'
	pbp_b19a_coins_airamb_min        = '19A airAMB Coins Min'
	pbp_b19a_coins_airamb_max        = '19A airAMB Coins Max'
	pbp_b19a_coins_dme_min           = '19A Coins MC DME Min'
	pbp_b19a_coins_dme_max           = '19A Coins MC DME Max'
	pbp_b19a_coins_pros_min          = '19A Srvcs Min Coins Pros'
	pbp_b19a_coins_pros_max          = '19A Srvcs Max Coins Pros'
	pbp_b19a_coins_medical_min       = '19A Coins MC MS Min'
	pbp_b19a_coins_medical_max       = '19A Coins MC MS Max'
	pbp_b19a_coins_diabsup_min       = '19A Coins MC DS Min'
	pbp_b19a_coins_diabsup_max       = '19A Coins MC DS Max'
	pbp_b19a_coins_diabt_min         = '19A Coins MC DTSI Min'
	pbp_b19a_coins_diabt_max         = '19A Coins MC DTSI Max'
	pbp_b19a_coins_dial_min          = '19A Coins MC DIAL Min'
	pbp_b19a_coins_dial_max          = '19A Coins MC DIAL Max'
	pbp_b19a_coins_14a_min           = '19A Min Coins 14a'
	pbp_b19a_coins_14a_max           = '19A Max Coins 14a'
	pbp_b19a_coins_kdes_min          = '19A Coins MC KDES Min'
	pbp_b19a_coins_kdes_max          = '19A Coins MC KDES Max'
	pbp_b19a_coins_glauc_min         = '19A Coins MC GLAU Min'
	pbp_b19a_coins_glauc_max         = '19A Coins MC GLAU Max'
	pbp_b19a_coins_diabsmt_min       = '19A Coins MC DMT Min'
	pbp_b19a_coins_diabsmt_max       = '19A Coins MC DMT Max'
	pbp_b19a_coins_dre_min           = '19A dig rec exa Min Coins'
	pbp_b19a_coins_dre_max           = '19A dig rec exa Max Coins'
	pbp_b19a_coins_ekg_min           = '19A ekg Min Coins'
	pbp_b19a_coins_ekg_max           = '19A ekg Max Coins'
	pbp_b19a_coins_15_1_i_min        = '19A Min Coins 15_1_I'
	pbp_b19a_coins_15_1_i_max        = '19A Max Coins 15_1_I'
	pbp_b19a_coins_chemodrugs_min    = '19A Coins MC Chem Min'
	pbp_b19a_coins_chemodrugs_max    = '19A Coins MC Chem Max'
	pbp_b19a_coins_othbdrugs_min     = '19A Coins MC OBD Min'
	pbp_b19a_coins_othbdrugs_max     = '19A Coins MC OBD Max'
	pbp_b19a_coins_16a_min           = '19A Coins MC Dental Min'
	pbp_b19a_coins_16a_max           = '19A Coins MC Dental Max'
	pbp_b19a_coins_eyeexam_min       = '19A Coins MC EYEX Min'
	pbp_b19a_coins_eyeexam_max       = '19A Coins MC EYEX Max'
	pbp_b19a_coins_eyewear_min       = '19A Coins MC EYWE Min'
	pbp_b19a_coins_eyewear_max       = '19A Coins MC EYWE Max'
	pbp_b19a_coins_hear_min          = '19A Coins MC HREX Min'
	pbp_b19a_coins_hear_max          = '19A Coins MC HREX Max'
	pbp_b19a_coins_20_min            = '19A Min Coins 20'
	pbp_b19a_coins_20_max            = '19A Max Coins 20'
	pbp_b19a_coins_acrs_min          = '19A Coins ACRS Min'
	pbp_b19a_coins_acrs_max          = '19A Coins ACRS Max'
	pbp_b19a_coins_aicrs_min         = '19A Coins AICRS Min'
	pbp_b19a_coins_aicrs_max         = '19A Coins AICRS Max'
	pbp_b19a_coins_aprs_min          = '19A Coins APRS Min'
	pbp_b19a_coins_aprs_max          = '19A Coins APRS Max'
	pbp_b19a_coins_nmc_setpad_min    = '19A NMC Min Coins Pct PAD'
	pbp_b19a_coins_nmc_setpad_max    = '19A NMC Max Coins Pct PAD'
	pbp_b19a_coins_wec_min           = '19A WEC Coins Min'
	pbp_b19a_coins_wec_max           = '19A WEC Coins Max'
	pbp_b19a_coins_wuc_min           = '19A WUC Coins Min'
	pbp_b19a_coins_wuc_max           = '19A WUC Coins Max'
	pbp_b19a_coins_wet_min           = '19A WET Coins Min'
	pbp_b19a_coins_wet_max           = '19A WET Coins Max'
	pbp_b19a_coins_chiro_rc_min      = '19A chiro rc Coins Min'
	pbp_b19a_coins_chiro_rc_max      = '19A chiro rc Coins Max'
	pbp_b19a_coins_chiro_oth_min     = '19A chiro other Coins Min'
	pbp_b19a_coins_chiro_oth_max     = '19A chiro other Coins Max'
	pbp_b19a_coins_podrt_min         = '19A Min Coins Pct POD'
	pbp_b19a_coins_podrt_max         = '19A Max Coins Pct POD'
	pbp_b19a_coins_transpal_min      = '19A Min Coins Pct TRANSP'
	pbp_b19a_coins_transpal_max      = '19A Max Coins Pct TRANSP'
	pbp_b19a_coins_transal_min       = '19A Min Coins Pct TRANSA'
	pbp_b19a_coins_transal_max       = '19A Max Coins Pct TRANSA'
	pbp_b19a_coins_acupunc_min       = '19A Min Coins Pct OTHER7'
	pbp_b19a_coins_acupunc_max       = '19A Max Coins Pct OTHER7'
	pbp_b19a_coins_otc_min           = '19A Min Coins Pct OTC'
	pbp_b19a_coins_otc_max           = '19A Max Coins Pct OTC'
	pbp_b19a_coins_meal_min          = '19A Min Coins Pct MEAL'
	pbp_b19a_coins_meal_max          = '19A Max Coins Pct MEAL'
	pbp_b19a_coins_nmc_other1_min    = '19A Min Coins Pct OTHER1'
	pbp_b19a_coins_nmc_other1_max    = '19A Max Coins Pct OTHER1'
	pbp_b19a_coins_nmc_other2_min    = '19A Min Coins Pct OTHER2'
	pbp_b19a_coins_nmc_other2_max    = '19A Max Coins Pct OTHER2'
	pbp_b19a_coins_nmc_other3_min    = '19A Min Coins Pct OTHER3'
	pbp_b19a_coins_nmc_other3_max    = '19A Max Coins Pct OTHER3'
	pbp_b19a_coins_ape_min           = '19A Coins APE Max'
	pbp_b19a_coins_ape_max           = '19A Max Coins OTHER14'
	pbp_b19a_coins_health_min        = '19A Min Coins HEALTH'
	pbp_b19a_coins_health_max        = '19A Max Coins HEALTH'
	pbp_b19a_coins_nutrition_min     = '19A Min Coins Nutrition'
	pbp_b19a_coins_nutrition_max     = '19A Max Coins Nutrition'
	pbp_b19a_coins_asstcc_min        = '19A Coins SC Min'
	pbp_b19a_coins_asstcc_max        = '19A Coins SC Max'
	pbp_b19a_coins_fitness_min       = '19A Min Coins Fitness'
	pbp_b19a_coins_fitness_max       = '19A Max Coins fitness'
	pbp_b19a_coins_edm_min           = '19A Min Coins OTHER19'
	pbp_b19a_coins_edm_max           = '19A Max Coins EDM'
	pbp_b19a_coins_ts_min            = '19A Min Coins TS'
	pbp_b19a_coins_ts_max            = '19A Max Coins TS'
	pbp_b19a_coins_rat_min           = '19A Min Coins RAT'
	pbp_b19a_coins_rat_max           = '19A Max Coins RAT'
	pbp_b19a_coins_bsd_min           = '19A Coins BSD Min'
	pbp_b19a_coins_bsd_max           = '19A Coins BSD Max'
	pbp_b19a_coins_cs_min            = '19A Coins CS Min'
	pbp_b19a_coins_cs_max            = '19A Coins CS Max'
	pbp_b19a_coins_ihsa_min          = '19A Min Coins IHSA'
	pbp_b19a_coins_ihsa_max          = '19A Max Coins IHSA'
	pbp_b19a_coins_pers_min          = '19A Min Coins PERS'
	pbp_b19a_coins_pers_max          = '19A Max Coins PERS'
	pbp_b19a_coins_mnt_min           = '19A MNT min Coins:'
	pbp_b19a_coins_mnt_max           = '19A MNT max Coins:'
	pbp_b19a_coins_postdis_min       = '19A PostDis min Coins:'
	pbp_b19a_coins_postdis_max       = '19A PostDis max Coins:'
	pbp_b19a_coins_readmis_min       = '19A ReAd min Coins:'
	pbp_b19a_coins_readmis_max       = '19A ReAd max Coins:'
	pbp_b19a_coins_wigs_min          = '19A Wigs min Coins:'
	pbp_b19a_coins_wigs_max          = '19A Wigs max Coins:'
	pbp_b19a_coins_weight_min        = '19A Min Coins Pct Weight'
	pbp_b19a_coins_weight_max        = '19A Max Coins Pct Weight'
	pbp_b19a_coins_at_min            = '19A Min Coins Pct AT'
	pbp_b19a_coins_at_max            = '19A Max Coins Pct AT'
	pbp_b19a_coins_massg_min         = '19A Min Coins Pct Massage'
	pbp_b19a_coins_massg_max         = '19A Max Coins Pct Massage'
	pbp_b19a_coins_adult_min         = '19A Min Coins Pct Adult Svc'
	pbp_b19a_coins_adult_max         = '19A Max Coins Pct Adult Svc'
	pbp_b19a_coins_homep_min         = '19A Min Coins Pct Home Pallia'
	pbp_b19a_coins_homep_max         = '19A Max Coins Pct Home Pallia'
	pbp_b19a_coins_ihome_min         = '19A Min Coins Pct In-Home Svc'
	pbp_b19a_coins_ihome_max         = '19A Max Coins Pct In-Home Svc'
	pbp_b19a_coins_careg_min         = '19A Min Coins Pct Caregvr Svc'
	pbp_b19a_coins_careg_max         = '19A Max Coins Pct Caregvr Svc'
	pbp_b19a_coins_15_nmc_min        = '19A Min Coins 15 NMC'
	pbp_b19a_coins_15_nmc_max        = '19A Max Coins 15 NMC'
	pbp_b19a_coins_16b1_min          = '19A Min Coins Pct 16b1'
	pbp_b19a_coins_16b1_max          = '19A Max Coins Pct 16b1'
	pbp_b19a_coins_16b2_min          = '19A Min Coins Pct 16b2'
	pbp_b19a_coins_16b2_max          = '19A Max Coins Pct 16b2'
	pbp_b19a_coins_16b3_min          = '19A Min Coins Pct 16b3'
	pbp_b19a_coins_16b3_max          = '19A Max Coins Pct 16b3'
	pbp_b19a_coins_16b4_min          = '19A Min Coins Pct 16b4'
	pbp_b19a_coins_16b4_max          = '19A Max Coins Pct 16b4'
	pbp_b19a_coins_16b5_min          = '19A Min Coins Pct 16b5'
	pbp_b19a_coins_16b5_max          = '19A Max Coins Pct 16b5'
	pbp_b19a_coins_16b6_min          = '19A Min Coins Pct 16b6'
	pbp_b19a_coins_16b6_max          = '19A Max Coins Pct 16b6'
	pbp_b19a_coins_16c1_min          = '19A Min Coins Pct 16c1'
	pbp_b19a_coins_16c1_max          = '19A Max Coins Pct 16c1'
	pbp_b19a_coins_16c2_min          = '19A Min Coins Pct 16c2'
	pbp_b19a_coins_16c2_max          = '19A Max Coins Pct 16c2'
	pbp_b19a_coins_16c3_min          = '19A Min Coins Pct 16c3'
	pbp_b19a_coins_16c3_max          = '19A Max Coins Pct 16c3'
	pbp_b19a_coins_16c4_min          = '19A Min Coins Pct 16c4'
	pbp_b19a_coins_16c4_max          = '19A Max Coins Pct 16c4'
	pbp_b19a_coins_16c5_min          = '19A Min Coins Pct 16c5'
	pbp_b19a_coins_16c5_max          = '19A Max Coins Pct 16c5'
	pbp_b19a_coins_16c6_min          = '19A Min Coins Pct 16c6'
	pbp_b19a_coins_16c6_max          = '19A Max Coins Pct 16c6'
	pbp_b19a_coins_16c7_min          = '19A Min Coins Pct 16c7'
	pbp_b19a_coins_16c7_max          = '19A Max Coins Pct 16c7'
	pbp_b19a_coins_16c8_min          = '19A Min Coins Pct 16c8'
	pbp_b19a_coins_16c8_max          = '19A Max Coins Pct 16c8'
	pbp_b19a_coins_16c9_min          = '19A Min Coins Pct 16c9'
	pbp_b19a_coins_16c9_max          = '19A Max Coins Pct 16c9'
	pbp_b19a_coins_16c10_min         = '19A Min Coins Pct 16c10'
	pbp_b19a_coins_16c10_max         = '19A Max Coins Pct 16c10'
	pbp_b19a_coins_routineeye_min    = '19A Min Coins Routine Ey'
	pbp_b19a_coins_routineeye_max    = '19A Max Coins Routine Ey'
	pbp_b19a_coins_oth_eye_min       = '19A Min Coins Oth eye ex'
	pbp_b19a_coins_oth_eye_max       = '19A Max Coins Oth eye ex'
	pbp_b19a_coins_cl_min            = '19A Min Coins CL'
	pbp_b19a_coins_cl_max            = '19A Max Coins CL'
	pbp_b19a_coins_eglf_min          = '19A Min Coins EGLF'
	pbp_b19a_coins_eglf_max          = '19A Max Coins EGLF'
	pbp_b19a_coins_egl_min           = '19A Min Coins EGL'
	pbp_b19a_coins_egl_max           = '19A Max Coins EGL'
	pbp_b19a_coins_egf_min           = '19A Min Coins EGF'
	pbp_b19a_coins_egf_max           = '19A Max Coins EGF'
	pbp_b19a_coins_upgrades_min      = '19A Min Coins Upgrades'
	pbp_b19a_coins_upgrades_max      = '19A Max Coins Upgrades'
	pbp_b19a_coins_routinehear_min   = '19A Min Coins Routine He'
	pbp_b19a_coins_routinehear_max   = '19A Max Coins Routine He'
	pbp_b19a_coins_fiteval_min       = '19A Min Coins Fit'
	pbp_b19a_coins_fiteval_max       = '19A Max Coins Fit'
	pbp_b19a_coins_hearingat_min     = '19A Min Coins HearAT'
	pbp_b19a_coins_hearingat_max     = '19A Max Coins HearAt'
	pbp_b19a_coins_hearingie_min     = '19A Min Coins HearIE'
	pbp_b19a_coins_hearingie_max     = '19A Max Coins HearIE'
	pbp_b19a_coins_hearingoe_min     = '19A Min Coins HearOE'
	pbp_b19a_coins_hearingoe_max     = '19A Max Coins HearOE'
	pbp_b19a_coins_hearingote_min    = '19A Min Coins HearOTE'
	pbp_b19a_coins_hearingote_max    = '19A Max Coins HearOTE'
	pbp_b19a_coins_18c_min           = '19A Min Coins Pct 18c'
	pbp_b19a_coins_18c_max           = '19A Max Coins Pct 18c'
	pbp_b19a_reduct_deduct_yn        = '19A Reduced deduct YN'
	pbp_b19a_red_deduct_cats         = '19A MC RCS Deduct Categories'
	pbp_b19a_deduct_iha_amt          = '19A IHA Deduct'
	pbp_b19a_deduct_1a_nmc_amt       = '19A 1a NMC Deduct amt'
	pbp_b19a_deduct_1a1_amt          = '19A 1a1 Deduct amt'
	pbp_b19a_deduct_1a2_amt          = '19A 1a2 Deduct amt'
	pbp_b19a_deduct_1a3_amt          = '19A 1a3 Deduct amt'
	pbp_b19a_deduct_ihp_amt          = '19A IHP Deduct'
	pbp_b19a_deduct_1b_nmc_amt       = '19A 1b NMC Deduct amt'
	pbp_b19a_deduct_1b1_amt          = '19A 1b1 Deduct amt'
	pbp_b19a_deduct_1b2_amt          = '19A 1b2 Deduct amt'
	pbp_b19a_deduct_snf_amt          = '19A SNF Deduct'
	pbp_b19a_deduct_2_nmc_amt        = '19A 2 NMC Deduct amt'
	pbp_b19a_deduct_2_1_amt          = '19A 2-1 Deduct amt'
	pbp_b19a_deduct_3_1_amt          = '19A 3-1 MC Deduct amt'
	pbp_b19a_deduct_3_2_amt          = '19A 3-2 MC Deduct amt'
	pbp_b19a_deduct_3_3_amt          = '19A 3-3 MC Deduct amt'
	pbp_b19a_deduct_3_4_amt          = '19A 3-4 MC Deduct amt'
	pbp_b19a_deduct_3_1_nmc_amt      = '19A 3-1 NMC Deduct amt'
	pbp_b19a_deduct_3_2_nmc_amt      = '19A 3-2 NMC Deduct amt'
	pbp_b19a_deduct_3_3_nmc_amt      = '19A 3-3 NMC Deduct amt'
	pbp_b19a_deduct_3_4_nmc_amt      = '19A 3-4 NMC Deduct amt'
	pbp_b19a_deduct_4a_amt           = '19A 4a Deduct amt'
	pbp_b19a_deduct_4b_amt           = '19A 4b Deduct amt'
	pbp_b19a_deduct_4c1_amt          = '19A 4c1 Deduct amt'
	pbp_b19a_deduct_4c2_amt          = '19A 4c2 Deduct amt'
	pbp_b19a_deduct_4c3_amt          = '19A 4c3 Deduct amt'
	pbp_b19a_deduct_ph_amt           = '19A Part Hosp Deduct'
	pbp_b19a_deduct_5b_amt           = '19A Int Outp Deduct'
	pbp_b19a_deduct_hhs_amt          = '19A HHS Deduct'
	pbp_b19a_deduct_pcps_amt         = '19A PCPS Deduct'
	pbp_b19a_deduct_chiro_amt        = '19A CHIRO Deduct'
	pbp_b19a_deduct_7b1_amt          = '19A 7b1 Deduct amt'
	pbp_b19a_deduct_7b2_amt          = '19A 7b2 Deduct amt'
	pbp_b19a_deduct_occup_amt        = '19A OCCUP Deduct'
	pbp_b19a_deduct_pss_amt          = '19A PSS Deduct'
	pbp_b19a_deduct_7e1_amt          = '19A 7e1 Deduct amt'
	pbp_b19a_deduct_7e2_amt          = '19A 7e2 Deduct amt'
	pbp_b19a_deduct_pod_amt          = '19A POD Deduct'
	pbp_b19a_deduct_7f_nmc_amt       = '19A 7f NMC Deduct amt'
	pbp_b19a_deduct_ohcp_amt         = '19A OHCPDeduct'
	pbp_b19a_deduct_7h1_amt          = '19A 7h1 Deduct amt'
	pbp_b19a_deduct_7h2_amt          = '19A 7h2 Deduct amt'
	pbp_b19a_deduct_ptslps_amt       = '19A PTSLPS Deduct'
	pbp_b19a_deduct_tele_amt         = '19A Telehealth Deduct amt'
	pbp_b19a_deduct_ots_amt          = '19A OTS Deduct amt'
	pbp_b19a_deduct_8a1_amt          = '19A 8a1 Deduct amt'
	pbp_b19a_deduct_8a2_amt          = '19A 8a2 Deduct amt'
	pbp_b19a_deduct_8b1_amt          = '19A 8b1 Deduct amt'
	pbp_b19a_deduct_8b2_amt          = '19A 8b2 Deduct amt'
	pbp_b19a_deduct_8b3_amt          = '19A 8b3 Deduct amt'
	pbp_b19a_deduct_ohs_amt          = '19A OHS Deduct'
	pbp_b19a_deduct_obsserv_amt      = '19A obsserv Deduct'
	pbp_b19a_deduct_asc_amt          = '19A Ded ASC Amt'
	pbp_b19a_deduct_9c1_amt          = '19A 9c1 Deduct amt'
	pbp_b19a_deduct_9c2_amt          = '19A 9c2 Deduct amt'
	pbp_b19a_deduct_obs_amt          = '19A OBS Deduct'
	pbp_b19a_deduct_amb_amt          = '19A AMB Deduct'
	pbp_b19a_deduct_airamb_amt       = '19A AirAMB Deduct'
	pbp_b19a_deduct_10b1_amt         = '19A 10b1 Deduct amt'
	pbp_b19a_deduct_10b2_amt         = '19A 10b2 Deduct amt'
	pbp_b19a_deduct_dme_amt          = '19A DME Deduct'
	pbp_b19a_deduct_11b1_amt         = '19A 11b1 Deduct amt'
	pbp_b19a_deduct_11b2_amt         = '19A 11b2 Deduct amt'
	pbp_b19a_deduct_11c1_amt         = '19A 11c1 Deduct amt'
	pbp_b19a_deduct_11c2_amt         = '19A 11c2 Deduct amt'
	pbp_b19a_deduct_dialysis_amt     = '19A DIALYSIS Deduct'
	pbp_b19a_deduct_acupunc_amt      = '19A ACUPUNC Deduct amt'
	pbp_b19a_deduct_otc_amt          = '19A OTC Deduct amt'
	pbp_b19a_deduct_meal_amt         = '19A MEAL Deduct amt'
	pbp_b19a_deduct_other1_amt       = '19A OTHER1 Deduct amt'
	pbp_b19a_deduct_other2_amt       = '19A OTHER2 Deduct amt'
	pbp_b19a_deduct_other3_amt       = '19A OTHER3 Deduct amt'
	pbp_b19a_deduct_14a_amt          = '19A 14a Deduct amt'
	pbp_b19a_deduct_ape_amt          = '19A APE Deduct amt'
	pbp_b19a_deduct_health_amt       = '19A HEALTH Deduct amt'
	pbp_b19a_deduct_nutrition_amt    = '19A NUTRITION Deduct amt'
	pbp_b19a_deduct_asstcc_amt       = '19A ASSTCC Deduct amt'
	pbp_b19a_deduct_fitness_amt      = '19A FITNESS Deduct amt'
	pbp_b19a_deduct_edm_amt          = '19A EDM Deduct'
	pbp_b19a_deduct_ts_amt           = '19A TS Deduct amt'
	pbp_b19a_deduct_rat_amt          = '19A RAT Deduct amt'
	pbp_b19a_deduct_bsd_amt          = '19A BSD Deduct amt'
	pbp_b19a_deduct_cs_amt           = '19A CS Deduct amt'
	pbp_b19a_deduct_ihsa_amt         = '19A IHSA Deduct amt'
	pbp_b19a_deduct_pers_amt         = '19A PERS Deduct amt'
	pbp_b19a_deduct_mnt_amt          = '19A MNT Deduct amt'
	pbp_b19a_deduct_pdimr_amt        = '19A PDIMR Deduct amt'
	pbp_b19a_deduct_rap_amt          = '19A RAP Deduct amt'
	pbp_b19a_deduct_wigs_amt         = '19A WIG Deduct amt'
	pbp_b19a_deduct_wmp_amt          = '19A WMP Deduct amt'
	pbp_b19a_deduct_at_amt           = '19A AT Deduct amt'
	pbp_b19a_deduct_massg_amt        = '19A Tx Massage Deduct amt'
	pbp_b19a_deduct_adult_amt        = '19A Adult Svc Deduct amt'
	pbp_b19a_deduct_homep_amt        = '19A Home Pallia Deduct amt'
	pbp_b19a_deduct_ihome_amt        = '19A In-Home Svc Deduct amt'
	pbp_b19a_deduct_careg_amt        = '19A Caregiver Svc Deduct amt'
	pbp_b19a_deduct_kdes_amt         = '19A KDES Deduct amt'
	pbp_b19a_deduct_glauc_amt        = '19A 19A GLAUC Deduct'
	pbp_b19a_deduct_dsmt_amt         = '19A DSMT Deduct amt'
	pbp_b19a_deduct_dre_amt          = '19A dig rec ex Deduct amt'
	pbp_b19a_deduct_ekg_amt          = '19A ekg Deduct amt'
	pbp_b19a_deduct_15_1_i_amt       = '19A 15-1 Deduct amt'
	pbp_b19a_deduct_15_2_amt         = '19A 15-2 Deduct amt'
	pbp_b19a_deduct_15_3_amt         = '19A 15-3 Deduct amt'
	pbp_b19a_deduct_15_nmc_amt       = '19A 15 NMC Deduct amt'
	pbp_b19a_deduct_16a_n_amt        = '19A 16a Deduct amt'
	pbp_b19a_deduct_16b1_n_amt       = '19A 16b1 Deduct amt'
	pbp_b19a_deduct_16b2_n_amt       = '19A 16b2 Deduct amt'
	pbp_b19a_deduct_16b3_n_amt       = '19A 16b3 Deduct amt'
	pbp_b19a_deduct_16b4_n_amt       = '19A 16b4 Deduct amt'
	pbp_b19a_deduct_16b5_n_amt       = '19A 16b5 Deduct amt'
	pbp_b19a_deduct_16b6_n_amt       = '19A 16b6 Deduct amt'
	pbp_b19a_deduct_16c1_n_amt       = '19A 16c1 Deduct amt'
	pbp_b19a_deduct_16c2_n_amt       = '19A 16c2 Deduct amt'
	pbp_b19a_deduct_16c3_n_amt       = '19A 16c3 Deduct amt'
	pbp_b19a_deduct_16c4_n_amt       = '19A 16c4 Deduct amt'
	pbp_b19a_deduct_16c5_n_amt       = '19A 16c5 Deduct amt'
	pbp_b19a_deduct_16c6_n_amt       = '19A 16c6 Deduct amt'
	pbp_b19a_deduct_16c7_n_amt       = '19A 16c7 Deduct amt'
	pbp_b19a_deduct_16c8_n_amt       = '19A 16c8 Deduct amt'
	pbp_b19a_deduct_16c9_n_amt       = '19A 16c9 Deduct amt'
	pbp_b19a_deduct_16c10_n_amt      = '19A 16c10 Deduct amt'
	pbp_b19a_deduct_eyeexam_amt      = '19A EYEEXAM Deduct amt'
	pbp_b19a_deduct_17a1_amt         = '19A 17a1 Deduct amt'
	pbp_b19a_deduct_17a2_amt         = '19A 17a2 Deduct amt'
	pbp_b19a_deduct_eyewear_amt      = '19A EYEWEAR Deduct amt'
	pbp_b19a_deduct_17b1_amt         = '19A 17b1 Deduct amt'
	pbp_b19a_deduct_17b2_amt         = '19A 17b2 Deduct amt'
	pbp_b19a_deduct_17b3_amt         = '19A 17b3 Deduct amt'
	pbp_b19a_deduct_17b4_amt         = '19A 17b4 Deduct amt'
	pbp_b19a_deduct_17b5_amt         = '19A 17b5 Deduct amt'
	pbp_b19a_deduct_hearexam_amt     = '19A HEAREXAM Deduct amt'
	pbp_b19a_deduct_18a1_amt         = '19A 18a1 Deduct amt'
	pbp_b19a_deduct_18a2_amt         = '19A 18a2 Deduct amt'
	pbp_b19a_deduct_18b1_amt         = '19A 18b1 Deduct amt'
	pbp_b19a_deduct_18b2_amt         = '19A 18b2 Deduct amt'
	pbp_b19a_deduct_18b3_amt         = '19A 18b3 Deduct amt'
	pbp_b19a_deduct_18b4_amt         = '19A 18b4 Deduct amt'
	pbp_b19a_deduct_18c_amt          = '19A 18c Deduct amt'
	pbp_b19a_deduct_20_amt           = '19A 20 Deduct amt'
	pbp_b19a_copay_yn                = '19A VBID Copay YN'
	pbp_b19a_red_copay_bens          = '19A Red Coins Benefits'
	pbp_b19a_red_copay_mc_cats       = '19A MC Rdc Copay Bnft Svcs'
	pbp_b19a_red_copay_nmc_cats      = '19A NMC Rdc Copay Benft Svcs'
	pbp_b19a_copay_crs_min           = '19A Copay MC CRS Min'
	pbp_b19a_copay_crs_max           = '19A Copay MC CRS Max'
	pbp_b19a_copay_icrs_min          = '19A Copay MC ICRS Min'
	pbp_b19a_copay_icrs_max          = '19A Copay MC ICRS Max'
	pbp_b19a_copay_prs_min           = '19A Copay MC PRS Min'
	pbp_b19a_copay_prs_max           = '19A Copay MC PRS Max'
	pbp_b19a_copay_setpad_min        = '19A Min Copay Pct PAD'
	pbp_b19a_copay_setpad_max        = '19A Max Copay Pct PAD'
	pbp_b19a_copay_emerg_min         = '19A Emerg Copay Min'
	pbp_b19a_copay_emerg_max         = '19A Emerg Copay Max'
	pbp_b19a_copay_urgent_min        = '19A Copay MC UC Min'
	pbp_b19a_copay_urgent_max        = '19A Copay MC UC Max'
	pbp_b19a_copay_partial_min       = '19A Copay MC PH Min'
	pbp_b19a_copay_partial_max       = '19A Copay MC PH Max'
	pbp_b19a_copay_5b_min            = '19A Copay MC Int Out Min'
	pbp_b19a_copay_5b_max            = '19A Copay MC Int Out Max'
	pbp_b19a_copay_home_min          = '19A Copay MC HHS Min'
	pbp_b19a_copay_home_max          = '19A Copay MC HHS Max'
	pbp_b19a_copay_primary_min       = '19A Copay MC PCPS Min'
	pbp_b19a_copay_primary_max       = '19A Copay MC PCPS Max'
	pbp_b19a_copay_chiro_min         = '19A Copay MC Chiro Min'
	pbp_b19a_copay_chiro_max         = '19A Copay MC Chiro Max'
	pbp_b19a_copay_occup_min         = '19A Copay MC OTS Min'
	pbp_b19a_copay_occup_max         = '19A Copay MC OTS Max'
	pbp_b19a_copay_special_min       = '19A Copay MC PSS Min'
	pbp_b19a_copay_special_max       = '19A Copay MC PSS Max'
	pbp_b19a_copay_ismss_min         = '19A Copay MC ISMH Min'
	pbp_b19a_copay_ismss_max         = '19A Copay MC ISMH Max'
	pbp_b19a_copay_gsmss_min         = '19A Copay MC GSMH Min'
	pbp_b19a_copay_gsmss_max         = '19A Copay MC GSMH Max'
	pbp_b19a_copay_pod_min           = '19A Copay MC POD Min'
	pbp_b19a_copay_pod_max           = '19A Copay MC POD Max'
	pbp_b19a_copay_ohcp_min          = '19A Copay MC OHCP Min'
	pbp_b19a_copay_ohcp_max          = '19A Copay MC OHCP Max'
	pbp_b19a_copay_isps_min          = '19A Copay MC ISPS Min'
	pbp_b19a_copay_isps_max          = '19A Copay MC ISPS Max'
	pbp_b19a_copay_gsps_min          = '19A Copay MC GSPS Min'
	pbp_b19a_copay_gsps_max          = '19A Copay MC GSPS Max'
	pbp_b19a_copay_ptslps_min        = '19A Copay MC PTSLPS Min'
	pbp_b19a_copay_ptslps_max        = '19A Copay MC PTSLPS Max'
	pbp_b19a_copay_tele_min          = '19A Min Copay Pct Tele'
	pbp_b19a_copay_tele_max          = '19A Max Copay Pct Tele'
	pbp_b19a_copay_ots_min           = '19A Min Copay Pct OTS'
	pbp_b19a_copay_ots_max           = '19A Max Copay Pct OTS'
	pbp_b19a_copay_diag_min          = '19A Copay MC DIAG Min'
	pbp_b19a_copay_diag_max          = '19A Copay MC DIAG Max'
	pbp_b19a_copay_lab_min           = '19A Copay MC LAB Min'
	pbp_b19a_copay_lab_max           = '19A Copay MC LAB Max'
	pbp_b19a_copay_drs_min           = '19A Copay MC DRS Min'
	pbp_b19a_copay_drs_max           = '19A Copay MC DRS Max'
	pbp_b19a_copay_trs_min           = '19A Copay MC TRS Min'
	pbp_b19a_copay_trs_max           = '19A Copay MC TRS Max'
	pbp_b19a_copay_xray_min          = '19A Copay MC XRS Min'
	pbp_b19a_copay_xray_max          = '19A Copay MC XRS Max'
	pbp_b19a_copay_ohs_min           = '19A Srvcs Min Copay OHA'
	pbp_b19a_copay_ohs_max           = '19A Srvcs Max Copay OHA'
	pbp_b19a_copay_obsserv_min       = '19A Srvcs Min Copay obsserv'
	pbp_b19a_copay_obsserv_max       = '19A Srvcs Max Copay obsserv'
	pbp_b19a_copay_asc_min           = '19A Copay MC ASC Min'
	pbp_b19a_copay_asc_max           = '19A Copay MC ASC Max'
	pbp_b19a_copay_osa_min           = '19A Srvcs Min Copay OSA'
	pbp_b19a_copay_osa_max           = '19A Srvcs Max Copay OSA'
	pbp_b19a_copay_osa2_min          = '19A Srvcs Min Copay OSA2'
	pbp_b19a_copay_osa2_max          = '19A Srvcs Max Copay OSA2'
	pbp_b19a_copay_obs_min           = '19A Srvcs Min Copay OBS'
	pbp_b19a_copay_obs_max           = '19A Srvcs Max Copay OBS'
	pbp_b19a_copay_amb_min           = '19A AMB Copay Min'
	pbp_b19a_copay_amb_max           = '19A AMB Copay Max'
	pbp_b19a_copay_airamb_min        = '19A airAMB Copay Min'
	pbp_b19a_copay_airamb_max        = '19A airAMB Copay Max'
	pbp_b19a_copay_dme_min           = '19A Copay MC DME Min'
	pbp_b19a_copay_dme_max           = '19A Copay MC DME Max'
	pbp_b19a_copay_pros_min          = '19A Copay MC PD Min'
	pbp_b19a_copay_pros_max          = '19A Copay MC PD Max'
	pbp_b19a_copay_medical_min       = '19A Copay MC MS Min'
	pbp_b19a_copay_medical_max       = '19A Copay MC MS Max'
	pbp_b19a_copay_diabsup_min       = '19A Copay MC DS Min'
	pbp_b19a_copay_diabsup_max       = '19A Copay MC DS Max'
	pbp_b19a_copay_diabt_min         = '19A Copay MC DTSI Min'
	pbp_b19a_copay_diabt_max         = '19A Copay MC DTSI Max'
	pbp_b19a_copay_dial_min          = '19A Copay MC DIAL Min'
	pbp_b19a_copay_dial_max          = '19A Copay MC DIAL Max'
	pbp_b19a_copay_14a_min           = '19A Min Copay 14a'
	pbp_b19a_copay_14a_max           = '19A Max Copay 14a'
	pbp_b19a_copay_kdes_min          = '19A Copay MC KDES Min'
	pbp_b19a_copay_kdes_max          = '19A Copay MC KDES Max'
	pbp_b19a_copay_glauc_min         = '19A Copay MC GLAU Min'
	pbp_b19a_copay_glauc_max         = '19A Copay MC GLAU Max'
	pbp_b19a_copay_diabsmt_min       = '19A Copay MC DMT Min'
	pbp_b19a_copay_diabsmt_max       = '19A Copay MC DMT Max'
	pbp_b19a_copay_dre_min           = '19A dig rec ex min copay'
	pbp_b19a_copay_dre_max           = '19A dig rec ex min copay'
	pbp_b19a_copay_ekg_min           = '19A ekg min copay'
	pbp_b19a_copay_ekg_max           = '19A ekg min copay'
	pbp_b19a_copay_15_1_i_min        = '19A Min Copay 15-1'
	pbp_b19a_copay_15_1_i_max        = '19A Max Copay 15-1'
	pbp_b19a_copay_chemodrugs_min    = '19A Chemo Copay Min'
	pbp_b19a_copay_chemodrugs_max    = '19A Chemo Copay Max'
	pbp_b19a_copay_othbdrugs_min     = '19A Other B Copay Min'
	pbp_b19a_copay_othbdrugs_max     = '19A Other B Copay Max'
	pbp_b19a_copay_16a_min           = '19A Copay MC Dental Min'
	pbp_b19a_copay_16a_max           = '19A Copay MC Dental Max'
	pbp_b19a_copay_eyeexam_min       = '19A Copay MC EYEX Min'
	pbp_b19a_copay_eyeexam_max       = '19A Copay MC EYEX Max'
	pbp_b19a_copay_eyewear_min       = '19A Copay MC EYWE Min'
	pbp_b19a_copay_eyewear_max       = '19A Copay MC EYWE Max'
	pbp_b19a_copay_hear_min          = '19A Copay MC HREX Min'
	pbp_b19a_copay_hear_max          = '19A Copay MC HREX Max'
	pbp_b19a_copay_20_min            = '19A Min Copay 20'
	pbp_b19a_copay_20_max            = '19A Max Copay 20'
	pbp_b19a_copay_acrs_min          = '19A Copay ACRS Min'
	pbp_b19a_copay_acrs_max          = '19A Copay ACRS Max'
	pbp_b19a_copay_aicrs_min         = '19A Copay AICRS Min'
	pbp_b19a_copay_aicrs_max         = '19A Copay AICRS Max'
	pbp_b19a_copay_aprs_min          = '19A Copay APRS Min'
	pbp_b19a_copay_aprs_max          = '19A Copay APRS Max'
	pbp_b19a_copay_nmc_setpad_min    = '19A NMC Min Copay Pct PAD'
	pbp_b19a_copay_nmc_setpad_max    = '19A NMC Max Copay Pct PAD'
	pbp_b19a_copay_wec_min           = '19A WEC Copay Min'
	pbp_b19a_copay_wec_max           = '19A WEC Copay Max'
	pbp_b19a_copay_wuc_min           = '19A WUC Copay Min'
	pbp_b19a_copay_wuc_max           = '19A WUC Copay Max'
	pbp_b19a_copay_wet_min           = '19A WET Copay Min'
	pbp_b19a_copay_wet_max           = '19A WET Copay Max'
	pbp_b19a_copay_chiro_rc_min      = '19A chiro rc copay Min'
	pbp_b19a_copay_chiro_rc_max      = '19A chiro rc copay Max'
	pbp_b19a_copay_chiro_oth_min     = '19A chiro other copay Min'
	pbp_b19a_copay_chiro_oth_max     = '19A chiro other copay Max'
	pbp_b19a_copay_podrt_min         = '19A Min Copay Pct POD'
	pbp_b19a_copay_podrt_max         = '19A Max Copay Pct POD'
	pbp_b19a_copay_transpal_min      = '19A Min Copay Pct TRANSP'
	pbp_b19a_copay_transpal_max      = '19A Max Copay Pct TRANSP'
	pbp_b19a_copay_transal_min       = '19A Min Copay Pct TRANSA'
	pbp_b19a_copay_transal_max       = '19A Max Copay Pct TRANSA'
	pbp_b19a_copay_acupunc_min       = '19A Copay ACPUN Min'
	pbp_b19a_copay_acupunc_max       = '19A Copay ACPUN Max'
	pbp_b19a_copay_otc_min           = '19A Min Copay Pct OTC'
	pbp_b19a_copay_otc_max           = '19A Max Copay Pct OTC'
	pbp_b19a_copay_meal_min          = '19A Min Copay Pct MEAL'
	pbp_b19a_copay_meal_max          = '19A Max Copay Pct MEAL'
	pbp_b19a_copay_nmc_other1_min    = '19A Min Copay Pct OTHER1'
	pbp_b19a_copay_nmc_other1_max    = '19A Max Copay Pct OTHER1'
	pbp_b19a_copay_nmc_other2_min    = '19A Min Copay Pct OTHER2'
	pbp_b19a_copay_nmc_other2_max    = '19A Max Copay Pct OTHER2'
	pbp_b19a_copay_nmc_other3_min    = '19A Min Copay Pct OTHER3'
	pbp_b19a_copay_nmc_other3_max    = '19A Srvcs Max Copay Pct OTHER3'
	pbp_b19a_copay_ape_min           = '19A Copay APE Min'
	pbp_b19a_copay_ape_max           = '19A Copay APE Max'
	pbp_b19a_copay_health_min        = '19A Srvcs Min Copay HEALTH'
	pbp_b19a_copay_health_max        = '19A Srvcs Max Copay HEALTH'
	pbp_b19a_copay_nutrition_min     = '19A Srvcs Min Copay Nutrition'
	pbp_b19a_copay_nutrition_max     = '19A Srvcs Max Copay Nutrition'
	pbp_b19a_copay_asstcc_min        = '19A Copay SC Min'
	pbp_b19a_copay_asstcc_max        = '19A Copay SC Max'
	pbp_b19a_copay_fitness_min       = '19A Srvcs Min Copay Fitness'
	pbp_b19a_copay_fitness_max       = '19A Srvcs Max Copay fitness'
	pbp_b19a_copay_edm_min           = '19A Srvcs Min Copay OTHER19'
	pbp_b19a_copay_edm_max           = '19A Srvcs Max Copay EDM'
	pbp_b19a_copay_ts_min            = '19A Srvcs Min Copay TS'
	pbp_b19a_copay_ts_max            = '19A Srvcs Max Copay TS'
	pbp_b19a_copay_rat_min           = '19A Srvcs Min Copay RAT'
	pbp_b19a_copay_rat_max           = '19A Srvcs Max Copay RAT'
	pbp_b19a_copay_bsd_min           = '19A Copay BSD Min'
	pbp_b19a_copay_bsd_max           = '19A Copay BSD Max'
	pbp_b19a_copay_cs_min            = '19A Copay CS Min'
	pbp_b19a_copay_cs_max            = '19A Copay CS Max'
	pbp_b19a_copay_ihsa_min          = '19A Srvcs Min Copay IHSA'
	pbp_b19a_copay_ihsa_max          = '19A Srvcs Max Copay IHSA'
	pbp_b19a_copay_pers_min          = '19A Srvcs Min Copay PERS'
	pbp_b19a_copay_pers_max          = '19A Srvcs Max Copay PERS'
	pbp_b19a_copay_mnt_min           = '19A MNT min Copay:'
	pbp_b19a_copay_mnt_max           = '19A MNT max Copay:'
	pbp_b19a_copay_postdis_min       = '19A PostDis min Copay:'
	pbp_b19a_copay_postdis_max       = '19A PostDis max Copay:'
	pbp_b19a_copay_readmis_min       = '19A ReAd min Copay:'
	pbp_b19a_copay_readmis_max       = '19A ReAd max Copay:'
	pbp_b19a_copay_wigs_min          = '19A Wigs min Copay:'
	pbp_b19a_copay_wigs_max          = '19A Wigs max Copay:'
	pbp_b19a_copay_weight_min        = '19A Min Copay Amt Weight'
	pbp_b19a_copay_weight_max        = '19A Max Copay Amt Weight'
	pbp_b19a_copay_at_min            = '19A Min Copay Pct AT'
	pbp_b19a_copay_at_max            = '19A Max Copay Pct AT'
	pbp_b19a_copay_massg_min         = '19A Min Copay Pct Massage'
	pbp_b19a_copay_massg_max         = '19A Max Copay Pct Massage'
	pbp_b19a_copay_adult_min         = '19A Min Copay Pct Adult Svc'
	pbp_b19a_copay_adult_max         = '19A Max Copay Pct Adult Svc'
	pbp_b19a_copay_homep_min         = '19A Min Copay Pct Home Pallia'
	pbp_b19a_copay_homep_max         = '19A Max Copay Pct Home Pallia'
	pbp_b19a_copay_ihome_min         = '19A Min Copay Pct In-Home Svc'
	pbp_b19a_copay_ihome_max         = '19A Max Copay Pct In-Home Svc'
	pbp_b19a_copay_careg_min         = '19A Min Copay Pct Caregvr Svc'
	pbp_b19a_copay_careg_max         = '19A Max Copay Pct Caregvr Svc'
	pbp_b19a_copay_15_nmc_min        = '19A Min Copay 15 NMC'
	pbp_b19a_copay_15_nmc_max        = '19A Max Copay 15 NMC'
	pbp_b19a_copay_16b1_min          = '19A Min Copay Pct 16b1'
	pbp_b19a_copay_16b1_max          = '19A Max Copay Pct 16b1'
	pbp_b19a_copay_16b2_min          = '19A Min Copay Pct 16b2'
	pbp_b19a_copay_16b2_max          = '19A Max Copay Pct 16b2'
	pbp_b19a_copay_16b3_min          = '19A Min Copay Pct 16b3'
	pbp_b19a_copay_16b3_max          = '19A Max Copay Pct 16b3'
	pbp_b19a_copay_16b4_min          = '19A Min Copay Pct 16b4'
	pbp_b19a_copay_16b4_max          = '19A Max Copay Pct 16b4'
	pbp_b19a_copay_16b5_min          = '19A Min Copay Pct 16b5'
	pbp_b19a_copay_16b5_max          = '19A Max Copay Pct 16b5'
	pbp_b19a_copay_16b6_min          = '19A Min Copay Pct 16b6'
	pbp_b19a_copay_16b6_max          = '19A Max Copay Pct 16b6'
	pbp_b19a_copay_16c1_min          = '19A Min Copay Pct 16c1'
	pbp_b19a_copay_16c1_max          = '19A Max Copay Pct 16c1'
	pbp_b19a_copay_16c2_min          = '19A Min Copay Pct 16c2'
	pbp_b19a_copay_16c2_max          = '19A Max Copay Pct 16c2'
	pbp_b19a_copay_16c3_min          = '19A Min Copay Pct 16c3'
	pbp_b19a_copay_16c3_max          = '19A Max Copay Pct 16c3'
	pbp_b19a_copay_16c4_min          = '19A Min Copay Pct 16c4'
	pbp_b19a_copay_16c4_max          = '19A Max Copay Pct 16c4'
	pbp_b19a_copay_16c5_min          = '19A Min Copay Pct 16c5'
	pbp_b19a_copay_16c5_max          = '19A Max Copay Pct 16c5'
	pbp_b19a_copay_16c6_min          = '19A Min Copay Pct 16c6'
	pbp_b19a_copay_16c6_max          = '19A Max Copay Pct 16c6'
	pbp_b19a_copay_16c7_min          = '19A Min Copay Pct 16c7'
	pbp_b19a_copay_16c7_max          = '19A Max Copay Pct 16c7'
	pbp_b19a_copay_16c8_min          = '19A Min Copay Pct 16c8'
	pbp_b19a_copay_16c8_max          = '19A Max Copay Pct 16c8'
	pbp_b19a_copay_16c9_min          = '19A Min Copay Pct 16c9'
	pbp_b19a_copay_16c9_max          = '19A Max Copay Pct 16c9'
	pbp_b19a_copay_16c10_min         = '19A Min Copay Pct 16c10'
	pbp_b19a_copay_16c10_max         = '19A Max Copay Pct 16c10'
	pbp_b19a_copay_routineeye_min    = '19A Min Copay Routine Ey'
	pbp_b19a_copay_routineeye_max    = '19A Max Copay Routine Ey'
	pbp_b19a_copay_oth_eye_min       = '19A Min copay oth eye ex'
	pbp_b19a_copay_oth_eye_max       = '19A Max copay oth eye ex'
	pbp_b19a_copay_cl_min            = '19A Min Copay CL'
	pbp_b19a_copay_cl_max            = '19A Max Copay CL'
	pbp_b19a_copay_eglf_min          = '19A Min Copay EGLF'
	pbp_b19a_copay_eglf_max          = '19A Max Copay EGLF'
	pbp_b19a_copay_egl_min           = '19A Min Copay EGL'
	pbp_b19a_copay_egl_max           = '19A Max Copay EGL'
	pbp_b19a_copay_egf_min           = '19A Min Copay EGF'
	pbp_b19a_copay_egf_max           = '19A Max Copay EGF'
	pbp_b19a_copay_upgrades_min      = '19A Min Copay Upgrades'
	pbp_b19a_copay_upgrades_max      = '19A Max Copay Upgrades'
	pbp_b19a_copay_routinehear_min   = '19A Min Copay Routine He'
	pbp_b19a_copay_routinehear_max   = '19A Max Copay Routine He'
	pbp_b19a_copay_fiteval_min       = '19A Min Copay Fit'
	pbp_b19a_copay_fiteval_max       = '19A Max Copay Fit'
	pbp_b19a_copay_hearingat_min     = '19A Min Copay HearAT'
	pbp_b19a_copay_hearingat_max     = '19A Max Copay HearAt'
	pbp_b19a_copay_hearingie_min     = '19A Min Copay HearIE'
	pbp_b19a_copay_hearingie_max     = '19A Max Copay HearIE'
	pbp_b19a_copay_hearingoe_min     = '19A Min Copay HearOE'
	pbp_b19a_copay_hearingoe_max     = '19A Max Copay HearOE'
	pbp_b19a_copay_hearingote_min    = '19A Min Copay HearOTE'
	pbp_b19a_copay_hearingote_max    = '19A Max Copay HearOTE'
	pbp_b19a_copay_18c_min           = '19A Min Copay 18c'
	pbp_b19a_copay_18c_max           = '19A Max Copay 18c'
	pbp_b19a_special_coins_yn        = '19A red special coins YN'
	pbp_b19a_special_coins_cats      = '19A red special coins cats'
	pbp_b19a_coins_pct_004_min       = '19A coins min Geriatrics'
	pbp_b19a_coins_pct_004_max       = '19A coins max Geriatrics'
	pbp_b19a_coins_pct_007_min       = '19A coins min Allergy'
	pbp_b19a_coins_pct_007_max       = '19A coins max Allergy'
	pbp_b19a_coins_pct_008_min       = '19A coins min Cardiology'
	pbp_b19a_coins_pct_008_max       = '19A coins max Cardiology'
	pbp_b19a_coins_pct_011_min       = '19A coins min Dermatology'
	pbp_b19a_coins_pct_011_max       = '19A coins max Dermatology'
	pbp_b19a_coins_pct_012_min       = '19A coins min Endocrinology'
	pbp_b19a_coins_pct_012_max       = '19A coins max Endocrinology'
	pbp_b19a_coins_pct_013_min       = '19A coins min ENT/Otolaryngol'
	pbp_b19a_coins_pct_013_max       = '19A coins max ENT/Otolaryngol'
	pbp_b19a_coins_pct_014_min       = '19A coins min Gastroenterolog'
	pbp_b19a_coins_pct_014_max       = '19A coins max Gastroenterolog'
	pbp_b19a_coins_pct_015_min       = '19A coins min General Surgery'
	pbp_b19a_coins_pct_015_max       = '19A coins max General Surgery'
	pbp_b19a_coins_pct_016_min       = '19A coins min Gynecology'
	pbp_b19a_coins_pct_016_max       = '19A coins max Gynecology'
	pbp_b19a_coins_pct_017_min       = '19A coins min Infectious'
	pbp_b19a_coins_pct_017_max       = '19A coins max Infectious'
	pbp_b19a_coins_pct_018_min       = '19A coins min Nephrology'
	pbp_b19a_coins_pct_018_max       = '19A coins max Nephrology'
	pbp_b19a_coins_pct_019_min       = '19A coins min Neurology'
	pbp_b19a_coins_pct_019_max       = '19A coins max Neurology'
	pbp_b19a_coins_pct_020_min       = '19A coins min Neurosurgery'
	pbp_b19a_coins_pct_020_max       = '19A coins max Neurosurgery'
	pbp_b19a_coins_pct_021_min       = '19A coins min Oncology - Medi'
	pbp_b19a_coins_pct_021_max       = '19A coins max Oncology - Medi'
	pbp_b19a_coins_pct_022_min       = '19A coins min Oncology - Radi'
	pbp_b19a_coins_pct_022_max       = '19A coins max Oncology - Radi'
	pbp_b19a_coins_pct_023_min       = '19A coins min Ophthalmology'
	pbp_b19a_coins_pct_023_max       = '19A coins max Ophthalmology'
	pbp_b19a_coins_pct_025_min       = '19A coins min Orthopedic Surg'
	pbp_b19a_coins_pct_025_max       = '19A coins max Orthopedic Surg'
	pbp_b19a_coins_pct_026_min       = '19A coins min Physiatry, Reha'
	pbp_b19a_coins_pct_026_max       = '19A coins max Physiatry, Reha'
	pbp_b19a_coins_pct_027_min       = '19A coins min Plastic Surgery'
	pbp_b19a_coins_pct_027_max       = '19A coins max Plastic Surgery'
	pbp_b19a_coins_pct_030_min       = '19A coins min Pulmonology'
	pbp_b19a_coins_pct_030_max       = '19A coins max Pulmonology'
	pbp_b19a_coins_pct_031_min       = '19A coins min Rheumatology'
	pbp_b19a_coins_pct_031_max       = '19A coins max Rheumatology'
	pbp_b19a_coins_pct_033_min       = '19A coins min Urology'
	pbp_b19a_coins_pct_033_max       = '19A coins max Urology'
	pbp_b19a_coins_pct_034_min       = '19A coins min Vascular Surger'
	pbp_b19a_coins_pct_034_max       = '19A coins max Vascular Surger'
	pbp_b19a_coins_pct_035_min       = '19A coins min Cardiothoracic'
	pbp_b19a_coins_pct_035_max       = '19A coins max Cardiothoracic'
	pbp_b19a_coins_pct_000_min       = '19A coins min Other'
	pbp_b19a_coins_pct_000_max       = '19A coins max Other'
	pbp_b19a_special_deduct_yn       = '19A red special ded YN'
	pbp_b19a_special_deduct_cats     = '19A red special ded cats'
	pbp_b19a_ded_amt_004             = '19A deduc amt Geriatrics'
	pbp_b19a_ded_amt_007             = '19A deduc amt Allergy'
	pbp_b19a_ded_amt_008             = '19A deduc amt Cardiology'
	pbp_b19a_ded_amt_011             = '19A deduc amt Dermatology'
	pbp_b19a_ded_amt_012             = '19A deduc amt Endocrinology'
	pbp_b19a_ded_amt_013             = '19A deduc amt ENT/Otolaryngol'
	pbp_b19a_ded_amt_014             = '19A deduc amt Gastroenterolog'
	pbp_b19a_ded_amt_015             = '19A deduc amt General Surgery'
	pbp_b19a_ded_amt_016             = '19A deduc amt Gynecology'
	pbp_b19a_ded_amt_017             = '19A deduc amt Infectious'
	pbp_b19a_ded_amt_018             = '19A deduc amt Nephrology'
	pbp_b19a_ded_amt_019             = '19A deduc amt Neurology'
	pbp_b19a_ded_amt_020             = '19A deduc amt Neurosurgery'
	pbp_b19a_ded_amt_021             = '19A deduc amt Oncology - Medi'
	pbp_b19a_ded_amt_022             = '19A deduc amt Oncology - Radi'
	pbp_b19a_ded_amt_023             = '19A deduc amt Ophthalmology'
	pbp_b19a_ded_amt_025             = '19A deduc amt Orthopedic Surg'
	pbp_b19a_ded_amt_026             = '19A deduc amt Physiatry, Reha'
	pbp_b19a_ded_amt_027             = '19A deduc amt Plastic Surgery'
	pbp_b19a_ded_amt_030             = '19A deduc amt Pulmonology'
	pbp_b19a_ded_amt_031             = '19A deduc amt Rheumatology'
	pbp_b19a_ded_amt_033             = '19A deduc amt Urology'
	pbp_b19a_ded_amt_034             = '19A deduc amt Vascular Surger'
	pbp_b19a_ded_amt_035             = '19A deduc amt Cardiothoracic'
	pbp_b19a_ded_amt_000             = '19A deduc amt Other'
	pbp_b19a_special_copay_yn        = '19A red special copay YN'
	pbp_b19a_special_copay_cats      = '19A red special copay cats'
	pbp_b19a_copay_amt_004_min       = '19A copay min Geriatrics'
	pbp_b19a_copay_amt_004_max       = '19A copay max Geriatrics'
	pbp_b19a_copay_amt_007_min       = '19A copay min Allergy'
	pbp_b19a_copay_amt_007_max       = '19A copay max Allergy'
	pbp_b19a_copay_amt_008_min       = '19A copay min Cardiology'
	pbp_b19a_copay_amt_008_max       = '19A copay max Cardiology'
	pbp_b19a_copay_amt_011_min       = '19A copay min Dermatology'
	pbp_b19a_copay_amt_011_max       = '19A copay max Dermatology'
	pbp_b19a_copay_amt_012_min       = '19A copay min Endocrinology'
	pbp_b19a_copay_amt_012_max       = '19A copay max Endocrinology'
	pbp_b19a_copay_amt_013_min       = '19A copay min ENT/Otolaryngol'
	pbp_b19a_copay_amt_013_max       = '19A copay max ENT/Otolaryngol'
	pbp_b19a_copay_amt_014_min       = '19A copay min Gastroenterolog'
	pbp_b19a_copay_amt_014_max       = '19A copay max Gastroenterolog'
	pbp_b19a_copay_amt_015_min       = '19A copay min General Surgery'
	pbp_b19a_copay_amt_015_max       = '19A copay max General Surgery'
	pbp_b19a_copay_amt_016_min       = '19A copay min Gynecology'
	pbp_b19a_copay_amt_016_max       = '19A copay max Gynecology'
	pbp_b19a_copay_amt_017_min       = '19A copay min Infectious'
	pbp_b19a_copay_amt_017_max       = '19A copay max Infectious'
	pbp_b19a_copay_amt_018_min       = '19A copay min Nephrology'
	pbp_b19a_copay_amt_018_max       = '19A copay max Nephrology'
	pbp_b19a_copay_amt_019_min       = '19A copay min Neurology'
	pbp_b19a_copay_amt_019_max       = '19A copay max Neurology'
	pbp_b19a_copay_amt_020_min       = '19A copay min Neurosurgery'
	pbp_b19a_copay_amt_020_max       = '19A copay max Neurosurgery'
	pbp_b19a_copay_amt_021_min       = '19A copay min Oncology - Medi'
	pbp_b19a_copay_amt_021_max       = '19A copay max Oncology - Medi'
	pbp_b19a_copay_amt_022_min       = '19A copay min Oncology - Radi'
	pbp_b19a_copay_amt_022_max       = '19A copay max Oncology - Radi'
	pbp_b19a_copay_amt_023_min       = '19A copay min Ophthalmology'
	pbp_b19a_copay_amt_023_max       = '19A copay max Ophthalmology'
	pbp_b19a_copay_amt_025_min       = '19A copay min Orthopedic Surg'
	pbp_b19a_copay_amt_025_max       = '19A copay max Orthopedic Surg'
	pbp_b19a_copay_amt_026_min       = '19A copay min Physiatry, Reha'
	pbp_b19a_copay_amt_026_max       = '19A copay max Physiatry, Reha'
	pbp_b19a_copay_amt_027_min       = '19A copay min Plastic Surgery'
	pbp_b19a_copay_amt_027_max       = '19A copay max Plastic Surgery'
	pbp_b19a_copay_amt_030_min       = '19A copay min Pulmonology'
	pbp_b19a_copay_amt_030_max       = '19A copay max Pulmonology'
	pbp_b19a_copay_amt_031_min       = '19A copay min Rheumatology'
	pbp_b19a_copay_amt_031_max       = '19A copay max Rheumatology'
	pbp_b19a_copay_amt_033_min       = '19A copay min Urology'
	pbp_b19a_copay_amt_033_max       = '19A copay max Urology'
	pbp_b19a_copay_amt_034_min       = '19A copay min Vascular Surger'
	pbp_b19a_copay_amt_034_max       = '19A copay max Vascular Surger'
	pbp_b19a_copay_amt_035_min       = '19A copay min Cardiothoracic'
	pbp_b19a_copay_amt_035_max       = '19A copay max Cardiothoracic'
	pbp_b19a_copay_amt_000_min       = '19A copay min Other'
	pbp_b19a_copay_amt_000_max       = '19A copay max Other'
	pbp_b19a_agg_yn                  = '19A reduction aggregate yn'
	pbp_b19a_agg_amt                 = '19A aggregate amount'
	pbp_b19a_agg_mode                = '19A aggregate deliver mode'
	pbp_b19a_agg_mode_desc           = '19A agg othr deliver mode'
;

run;

proc sort data = pbp_b19a_vbid out=out.pbp_b19a_vbid;
  by Pbp_a_hnumber pbp_a_plan_identifier segment_id;
run;

proc print data = out.pbp_b19a_vbid(obs = 10);
  title 'pbp_b19a_model_test_vbid_uf file ';
run;

proc means data = out.pbp_b19a_vbid;
  title 'pbp_b19a_model_test_vbid_uf file ';
run;

proc freq data = out.pbp_b19a_vbid;
table
	pbp_a_ben_cov
	pbp_a_plan_type
	orgtype
	pbp_vbid_group_id
	pbp_b19a_package_type
	pbp_b19a_tm_vbid
	pbp_b19a_all_dis_yn
	pbp_b19a_cmb_dis_yn
	pbp_b19a_lis_vbid
	pbp_b19a_states_uf_all_yn
	pbp_b19a_states_uf_cmb_yn
	pbp_b19a_reduct_prereq_yn
	pbp_b19a_reduct_prereq
	pbp_b19a_reduct_zero_yn
	pbp_b19a_red_bens
	pbp_b19a_bendesc_special
	pbp_b19a_reduct_apply_yn
	pbp_b19a_reduct_exempt_yn
	pbp_b19a_red_exempt_bens
	pbp_b19a_coins_yn
	pbp_b19a_red_coins_bens
	pbp_b19a_reduct_deduct_yn
	pbp_b19a_copay_yn
	pbp_b19a_red_copay_bens
	pbp_b19a_special_coins_yn
	pbp_b19a_special_deduct_yn
	pbp_b19a_special_copay_yn
	pbp_b19a_agg_yn
	pbp_b19a_agg_mode
/ missing;
run;

proc contents data = out.pbp_b19a_vbid;
  title 'pbp_b19a_vbid data';
run;