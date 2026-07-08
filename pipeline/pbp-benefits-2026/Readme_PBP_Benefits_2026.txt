Readme_PBP_Benefits_2026.txt

******

CHANGE LOG:

Changes released on 9/1/2025

******

Column Length Changes

 - Increased from 23 -> 33: PBP_A_SNP_COND
 - Decreased from 5 -> 4: PBP_B14E_COINS_EHC, PBP_B14E_COPAY_EHC, PBP_B14E_DED_EHC, PBP_B14E_MAXENR_EHC, PBP_B14E_REFER_EHC
 - Increased from 2 -> 3: MRX_ALT_RED_COST_SHARING_ITEMS, PBP_C_OON_OUTPT_GROUP_NUM_ID, PBP_C_OON_OUTPT_GROUP_NUM
 - Decreased from 7 -> 3: PBP_B20_INSULIN_COINS_MIN_PCT, PBP_B20_INSULIN_COINS_MAX_PCT
 - Increased from 3 -> 4: PBP_B3_BENDESC_NUMV_SETPAD, PBP_B3_BENDESC_NUMV_CRS, PBP_B3_BENDESC_NUMV_ICRS, PBP_B14C_MNT_NMCD_NUM, PBP_B14C_MNT_MCD_NUM, PBP_B3_BENDESC_NUMV_PRS (repeated multiple times in original log)
 - Increased from 20 -> 27: PBP_B19B_STATES_EHC_SSBCI, PBP_B19A_STATES_EHC_SSBCI
 - Increased from 250 -> 4000: PBP_B1A_HOSP_BEN_PERIOD_OTH, PBP_B1B_HOSP_BEN_PERIOD_OTH, PBP_B2_HOSP_BEN_PERIOD_OTH, PBP_B14C_RP_BENDESC_OTHER

******

Variables Removed

 - From pbp_mrx_p.txt: MRX_TIER_POST_CST_SHR_TYPE
 - From pbp_b14_preventive.txt: PBP_B14E_AUTH_YN_BAR, PBP_B14E_COINS_PCT_MAX_BAR, PBP_B14E_COPAY_AMT_MAX_BAR, PBP_B14E_DED_AMT_BAR, PBP_B14E_MAXENR_AMT_BAR
 - From pbp_step14.txt: PBP_B14E_REFER_YN plus the same six variables removed from pbp_b14_preventive.txt
 - Entire files removed: pbp_step9.txt, pbp_b9_b19b_outpat_hosp_vbid_uf.txt

******

Variables Added

 - To pbp_b5_partial_hosp.txt: PBP_B5A_COINS_PCT, PBP_B5A_COPAY_AMT, PBP_B5B_AUTH_YN, PBP_B5B_COINS_PCT, PBP_B5B_COINS_PCT_MAX, PBP_B5B_COINS_PCT_MIN, PBP_B5B_COINS_YN, PBP_B5B_COPAY_AMT, PBP_B5B_COPAY_AMT_MAX, PBP_B5B_COPAY_AMT_MIN, PBP_B5B_COPAY_YN, PBP_B5B_DED_AMT, PBP_B5B_DED_YN, PBP_B5B_MAXENR_AMT, PBP_B5B_MAXENR_PER, PBP_B5B_MAXENR_PER_D, PBP_B5B_MAXENR_YN, PBP_B5B_REFER_YN
 - To pbp_Section_C.txt: PBP_C_POS_IHP_MAXPLAN_PER_D, PBP_C_POS_IHP_MAXPLAN_PER, PBP_C_POS_IHA_MAXPLAN_PER, PBP_C_POS_IHA_MAXPLAN_PER_D
 - To pbp_Section_D.txt: PBP_D_MAXENR_OOPC_YN, PBP_D_DIFF_DEDUCT_5B_AMT
 - To pbp_Section_D_opt.txt: PBP_D_OPT_NAME
 - To pbp_b13_b19b_other_services_vbid_uf.txt: PBP_B13B_MODE_DESC, PBP_B13B_AUTH_YN, PBP_B13B_MODE
 - To pbp_b13_other_services.txt: PBP_B13B_MODE, PBP_B13B_MODE_DESC
 - To pbp_b13i_b19b_services_vbid_ssbci.txt: PBP_B13I_SUPPT_UTILITY_YN, PBP_B13I_SUPPT_HOUSING_YN
 - To pbp_b19a_model_test_vbid_uf.txt: PBP_B19A_STATES_UF_CMB_D, PBP_B19A_COINS_5B_MAX, PBP_B19A_PACKAGE_NAME, PBP_B19A_SPECIAL_COPAY_YN, PBP_B19A_SPECIAL_DEDUCT_YN, PBP_B19A_SPECIAL_COINS_YN, PBP_B19A_COPAY_5B_MAX, PBP_B19A_COPAY_5B_MIN, PBP_B19A_DEDUCT_5B_AMT, PBP_B19A_COINS_5B_MIN, PBP_B19A_CMB_DIS_D, PBP_B19B_STATES_UF_CMB_D, PBP_B19B_PACKAGE_NAME, PBP_B19B_CMB_DIS_D
 - To pbp_b20.txt: PBP_B20_GRP1_NAME, PBP_B20_GRP2_NAME, PBP_B20_GRP3_NAME, PBP_B20_GRP4_NAME, PBP_B20_GRP5_NAME
 - To pbp_b9_outpat_hosp.txt: PBP_B9D_DED_WAIVE_3PT_YN
 - To pbp_mrx.txt: MRX_GEN_IRA_LTCP_COINS_1M, MRX_GEN_IRA_OONP_COINS_OTHNUM, MRX_GEN_IRA_OONP_COINS_1M, MRX_GEN_IRA_MOSTD_COINS_3M, MRX_GEN_IRA_MOSTD_COINS_1M, MRX_GEN_IRA_RSTD_COINS_3M, MRX_GEN_IRA_RSTD_COINS_2M, MRX_GEN_IRA_RSTD_COINS_1M, MRX_INSULIN_ATTEST, MRX_GEN_IRA_MOSTD_COINS_2M
 - To pbp_mrx_tier.txt: MRX_TIER_IRA_MOSTD_COINS_3M, MRX_TIER_IRA_MOPFD_COINS_1M, MRX_TIER_IRA_MOPFD_COINS_2M, MRX_TIER_IRA_MOSTD_COINS_2M, MRX_TIER_IRA_MOSTD_COINS_1M, MRX_TIER_IRA_RSPFD_COINS_3M, MRX_TIER_IRA_RSPFD_COINS_2M, MRX_TIER_IRA_RSPFD_COINS_1M, MRX_TIER_IRA_RSTD_COINS_3M, MRX_TIER_IRA_RSTD_COINS_2M, MRX_TIER_IRA_RSTD_COINS_1M, MRX_TIER_IRA_LTCP_COINS_1M, MRX_TIER_IRA_MOPFD_COINS_3M, MRX_TIER_IRA_OONP_COINS_OTHNUM, MRX_TIER_IRA_OONP_COINS_1M
 - To pbp_step13.txt: PBP_B13B_AUTH_YN, PBP_B13B_MODE_DESC, PBP_B13B_MODE
 - To pbp_step20.txt: PBP_B20_GRP1_NAME, PBP_B20_GRP2_NAME, PBP_B20_GRP3_NAME, PBP_B20_GRP4_NAME, PBP_B20_GRP5_NAME

Note – VBID has been discontinued effective CY 2026. VBID related data fields will be blank in the data file.

******

This zip file contains Plan Benefit Package (PBP) tab delimited text files from the HPMS 
data repository, SAS programs, and files with supporting documentation. The SAS programs 
are compatible with SAS Version 7 or above and the input and library file path names need 
to be changed to your working subdirectory.


The CY 2026 PBP Benefits file provides the universe of PBP data for all active contracts 
and contains all the approved benefit and financial data submitted as part of the CY 2026 
Bid Submission by Medicare Advantage and Part D organizations, including those involved in 
certain demonstration projects and cost plans. The PBP Benfits file is updated quarterly.



CY 2026 PBP Benefits Extract Contents:

Text File:                                     SAS Input Statement to Use:
pbp_b1a_inpat_hosp.txt                         pbp_b1a_inpat_hosp.sas
pbp_b1a_b19a_inpat_hosp_vbid_uf.txt            pbp_b1a_b19a_inpat_hosp_vbid_uf.sas
pbp_b1a_b19b_inpat_hosp_vbid_uf.txt            pbp_b1a_b19b_inpat_hosp_vbid_uf.sas
pbp_b1b_inpat_hosp.txt                         pbp_b1b_inpat_hosp.sas
pbp_b1b_b19a_inpat_hosp_vbid_uf.txt            pbp_b1b_b19a_inpat_hosp_vbid_uf.sas
pbp_b1b_b19b_inpat_hosp_vbid_uf.txt            pbp_b1b_b19b_inpat_hosp_vbid_uf.sas
pbp_b2_snf.txt                                 pbp_b2_snf.sas
pbp_b2_b19a_snf_vbid_uf.txt                    pbp_b2_b19a_snf_vbid_uf.sas
pbp_b2_b19b_snf_vbid_uf.txt                    pbp_b2_b19b_snf_vbid_uf.sas
pbp_b3_cardiac_rehab.txt                       pbp_b3_cardiac_rehab.sas
pbp_b3_b19b_cardiac_rehab_vbid_uf.txt          pbp_b3_b19b_cardiac_rehab_vbid_uf.sas
pbp_b4_emerg_urgent.txt                        pbp_b4_emerg_urgent.sas
pbp_b4_b19b_emerg_urgent_vbid_uf.txt           pbp_b4_b19b_emerg_urgent_vbid_uf.sas
pbp_b5_partial_hosp.txt                        pbp_b5_partial_hosp.sas
pbp_b6_home_health.txt                         pbp_b6_home_health.sas
pbp_b7_health_prof.txt                         pbp_b7_health_prof.sas
pbp_b7_b19b_health_prof_vbid_uf.txt            pbp_b7_b19b_health_prof_vbid_uf.sas
pbp_b8_clin_diag_ther.txt                      pbp_b8_clin_diag_ther.sas
pbp_b9_outpat_hosp.txt                         pbp_b9_outpat_hosp.sas
pbp_b10_amb_trans.txt                          pbp_b10_amb_trans.sas
pbp_b10_b19b_amb_trans_vbid_uf.txt             pbp_b10_b19b_amb_trans_vbid_uf.sas
pbp_b11_dme_prosth_orth_sup.txt                pbp_b11_dme_prosth_orth_sup.sas
pbp_b12_renal_dialysis.txt                     pbp_b12_renal_dialysis.sas
pbp_b13_other_services.txt                     pbp_b13_other_services.sas
pbp_b13_b19b_other_services_vbid_uf.txt        pbp_b13_b19b_other_services_vbid_uf.sas
pbp_b13i_b19b_services_vbid_ssbci.txt          pbp_b13i_b19b_services_vbid_ssbci.sas
pbp_b13i_b19b_other_services_vbid_ssbci.txt    pbp_b13i_b19b_other_services_vbid_ssbci.sas
pbp_b14_preventive.txt                         pbp_b14_preventive.sas
pbp_b14b_b19b_preventive_vbid_uf.txt           pbp_b14b_b19b_preventive_vbid_uf.sas
pbp_b14c_b19b_preventive_vbid_uf.txt           pbp_b14c_b19b_preventive_vbid_uf.sas
pbp_b15_partb_rx_drugs.txt                     pbp_b15_partb_rx_drugs.sas
pbp_b16_dental.txt                             pbp_b16_dental.sas
pbp_b16_b19b_dental_vbid_uf.txt                pbp_b16_b19b_dental_vbid_uf.sas
pbp_b17_eye_exams_wear.txt                     pbp_b17_eye_exams_wear.sas
pbp_b17_b19b_eye_exams_wear_vbid_uf.txt        pbp_b17_b19b_eye_exams_wear_vbid_uf.sas
pbp_b18_hearing_exams_aids.txt                 pbp_b18_hearing_exams_aids.sas
pbp_b18_b19b_hearing_exams_aids_vbid_uf.txt    pbp_b18_b19b_hearing_exams_aids_vbid_uf.sas
pbp_b19_model_test.txt                         pbp_b19_model_test.sas
pbp_b19a_model_test_vbid_uf.txt                pbp_b19a_model_test_vbid_uf.sas
pbp_b19b_model_test_vbid_uf.txt                pbp_b19b_model_test_vbid_uf.sas
pbp_b20.txt                                    pbp_b20.sas
pbp_ds_vbid.txt                                pbp_ds_vbid.sas
pbp_mrx.txt             *                      pbp_mrx.sas
pbp_mrx_vbid.txt        *                      pbp_mrx_vbid.sas
pbp_mrx_p.txt           *                      pbp_mrx_p.sas
pbp_mrx_tier.txt        *                      pbp_mrx_tier.sas
pbp_mrx_tier_vbid.txt   *                      pbp_mrx_tier_vbid.sas
pbp_section_a.txt                              pbp_Section_A.sas
pbp_section_c.txt     **                       pbp_Section_C.sas
pbp_section_c_oon.txt **                       pbp_Section_C_oon.sas
pbp_section_c_pos.txt **                       pbp_Section_C_pos.sas
pbp_section_d.txt                              pbp_Section_D.sas
pbp_section_d_oon.txt                          pbp_Section_D_oon.sas
pbp_section_d_opt.txt                          pbp_Section_D_opt.sas
pbp_step1.txt                                  pbp_step1.sas  
pbp_step1_b.txt                                pbp_step1_b.sas
pbp_step2.txt                                  pbp_step2.sas  
pbp_step2_b.txt                                pbp_step2_b.sas
pbp_step3.txt                                  pbp_step3.sas
pbp_step4.txt                                  pbp_step4.sas  
pbp_step7B.txt                                 pbp_step7b.sas
pbp_step7F.txt                                 pbp_step7f.sas
pbp_step10B.txt                                pbp_step10b.sas
pbp_step13.txt                                 pbp_step13.sas                              
pbp_step14.txt                                 pbp_step14.sas   
pbp_step16.txt                                 pbp_step16.sas
pbp_step17A.txt                                pbp_step17a.sas
pbp_step17B.txt                                pbp_step17b.sas
pbp_step18A.txt                                pbp_step18a.sas
pbp_step18B.txt                                pbp_step18b.sas
pbp_step18C.txt                                pbp_step18c.sas
pbp_step20.txt                                 pbp_step20.sas
pbp_vbid.txt                                   pbp_vbid.sas
PlanArea.txt       ***                         planArea.sas
PlanRegionArea.txt ***                         planRegionArea.sas

*The pbp_mrx files for 2026 have been split into five files:
pbp_mrx.txt
pbp_mrx_vbid.txt
pbp_mrx_p.txt
pbp_mrx_tier.txt
pbp_mrx_tier_vbid.txt

*The PlanArea.txt file is available for Local MA and EDPDP-FB plans; the PlanRegionArea.txt file is available for Regional MA plans and PDPs.

pbp_SectionA.txt    - Contains general plan information.

pbp_b1a_inpat_hosp.txt, pbp_b1b_inpat_hosp.txt   - Inpatient Hospital Acute/Psychiatric data.

pbp_b1a_b19a_inpat_hosp_vbid_uf.txt, pbp_b1a_b19b_inpat_hosp_vbid_uf.txt, pbp_b1b_b19a_inpat_hosp_vbid_uf.txt, pbp_b1b_b19b_inpat_hosp_vbid_uf.txt - Inpatient Hospital Acute/Psychiatric VBID and UF reduced cost data.

pbp_b2_snf.txt   - Skilled Nursing Facility data.

pbp_b2_b19a_snf_vbid_uf.txt, pbp_b2_b19b_snf_vbid_uf.txt - Skilled Nursing Facility VBID and UF data.

pbp_b3_cardiac_rehab.txt   - Cardiac and Pulmonary Rehabilitation data.

pbp_b3_b19b_cardiac_rehab_vbid_uf.txt   - Cardiac and Pulmonary Rehabilitation VBID and UF data.

pbp_b4_emerg_urgent.txt   - Emergency/Urgent Care data.

pbp_b4_b19b_emerg_urgent_vbid_uf.txt   - Emergency/Urgent Care VBID and UF data.

pbp_b5_partial_hosp.txt   - Partial Hospitalization data.

pbp_b6_home_health.txt   - Home Health data.

pbp_b7_health_prof.txt   - Contains Health Care Professional data for Primary Care Physician, Chiropractic, Occupational Therapy, Physician Specialist and Mental Health Specialist services.
                         
pbp_b7_b19b_health_prof_vbid_uf.txt   - Contains Health Care Professional VBID and UF data for Primary Care Physician, Chiropractic, Occupational Therapy, Physician Specialist and Mental Health Specialist services.

pbp_b8_clin_diag_ther.txt   - Outpatient Clinical, Diagnostic, and Therapeutic Radiology services data.

pbp_b9_outpt_hosp.txt   - Outpatient Hospital, ASC, Outpatient Substance Abuse, and Cardiac Rehabilitation data. 

pbp_b10_amb_trans.txt   - Ambulance/Transportation data.

pbp_b10_b19b_amb_trans_vbid_uf.txt   - Ambulance/Transportation VBID and UF data.

pbp_b11_dme_prosth_orth_sup.txt   - Durable Medical Equipment, Prosthetics/Orthotics and Medical Supplies data.
                                  
pbp_b12_renal_dialysis.txt - Renal Dialysis data.

pbp_b13_other_services.txt - Outpatient Blood, Acupuncture and "Other" services data. The "Other" data describes benefits not included in standard PBP service categories.
                             
pbp_b13_b19b_other_services_vbid_uf.txt - Acupuncture, OTC, Meal Benefit and "Other" services VBID and UF data. The "Other" data describes benefits not included in standard PBP service categories.

pbp_b13i_b19b_services_vbid_ssbci.txt - Non-Primarily Health Related Benefits for the Chronically III, Food and Produce, Meals, Pest Control, Transportation fr Non-Medical Needs, Indoor Air Quality Equipment and Services and Other data.

pbp_b13i_b19b_other_services_vbid_ssbci.txt - "Other" Non-Primarily Health Related Benefits for the Chronically III data. 

pbp_b14_preventive.txt - Contains Preventive Services data for Health Education/Wellness, Immunizations, Routine Physicals, and Pap/Pelvic Exams.
                         
pbp_b14b_b19b_preventive_vbid_uf.txt - Contains Preventive Services VBID and UF data for Immunizations, Routine Physicals, and Pap/Pelvic Exams.

pbp_b14c_b19b_preventive_vbid_uf.txt - Contains Supplemental Benefits Preventive Services VBID and UF data for Health Education/Wellness, Fitness Benefit,Counseling Services.

pbp_b15_partb_rx_drugs.txt -  Medicare Part B prescription drugs.

pbp_b16_dental.txt - Preventive and Comprehensive Dental data.

pbp_b16_b19b_dental_vbid_uf.txt - Preventive and Comprehensive Dental VBID and UF data.

pbp_b17_eye_exams_wear.txt - Eye Exams and Eye Wear data.

pbp_b17_b19b_eye_exams_wear_vbid_uf.txt - Eye Exams and Eye Wear VBID and UF data.

pbp_b18_hearing_exams_aids.txt - Hearing Exams and Hearing Aids data.

pbp_b18_b19b_hearing_exams_aids_vbid_uf.txt - Hearing Exams and Hearing Aids VBID and UF data.

pbp_b19_model_test.txt - Model Test VBID and UF

pbp_b19a_model_test_vbid_uf.txt - Model Test VBID and UF

pbp_b19b_model_test_vbid_uf.txt - Model Test VBID and UF

pbp_b20.txt - Contains enhanced Prescription Drug data for Cost Plans if they do NOT offer Part D drug benefits.

pbp_Section_C.txt - Contains Out-of-Network data for PPO plans.

pbp_section_c_oon.txt - Out-of-Network

pbp_section_c_pos.txt - Point of Service

pbp_Section_D.txt - Contains plan-level financial data such as plan premiums, global max plan benefit and out-of-pocket limits, and global deductibles.

pbp_section_D_oon.txt - Contains plan-level out-of-network deductibles and out-of-pocket limits.

pbp_Section_D_opt.txt - Contains plan-level benefit data descriptions of optional supplemental offerings including the optional benefit premium amounts.

pbp_mrx.txt - Contains Medicare Part D prescription drug benefits data.

pbp_mrx_vbid.txt - Contains Medicare Part D prescription drug benefits VBID data.

pbp_mrx_p.txt - Contains Medicare Part D prescription drug benefits (post OOP threshold) data.
               
pbp_mrx_tier.txt - Contains Medicare Part D prescription drug benefits (tiering) data.

pbp_mrx_tier_vbid.txt - Contains Medicare Part D prescription drug benefits (tiering) data.

pbp_step1.txt      - Contains Step-up details for service category B1.                       

pbp_step1_b.txt       - Contains Step-up details for service category  B1_B.                         

pbp_step2.txt       - Contains Step-up details for service category  B2.                        

pbp_step2_b.txt       - Contains Step-up details for service category B2_B.                          

pbp_step3.txt       - Contains Step-up details for service category B3.                         

pbp_step4.txt       - Contains Step-up details for service category  B4.                         

pbp_step10b.txt - Contains step-up transportation benefit data.
                           
pbp_step13.txt       - Contains Step-up details for service category B13.                                                       

pbp_step14.txt       - Contains Step-up details for service category B14. 

pbp_step16.txt -   Contains step-up preventive and comprehensive dental data.

pbp_step17a.txt - Contains step-up eye exams data.

pbp_step17b.txt - Contains step-up eye wear data.

pbp_step18a.txt - Contains step-up hearing exams data.

pbp_step18b.txt - Contains step-up hearing aids data.

pbp_step18c.txt - Contains step-up OTC hearing aids data.
                           
pbp_step20.txt    - Contains Step-up details for service category B20. 

pbp_step7b.txt - Contains step-up chiropractic benefit data.

pbp_step7f.txt - Contains step-up podiatry benefit data.

pbp_ds_vbid.txt - Contains DS VBID benefit data.

pbp_vbid.txt - Contains VBID general data.

planarea.txt and planRegionArea.txt - Contains Service Area data by plan (includes EGHP service areas).

******
                                            
If you are importing the data into Excel, you must define certain columns as text or you will lose any leading zero information (example, a plan id of '001' will 
appear as '1' if defined as "general" or "numeric.").  The variable names for the columns that should be delineated as text (or character in SAS terminology) are 
provided within the SAS input statements as well as the PBP_Benefits_2026_dictionary.xlsx.