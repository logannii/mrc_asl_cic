#!/usr/bin/zsh

datadir="/Users/xinzhang/Downloads/mrc_asl_cic/data"
outputdir="/Users/xinzhang/Downloads/mrc_asl_cic/output"

gm_thr=0.7
wm_thr=0.9
fl_thr=0.5
ol_thr=0.5
pl_thr=0.5
tl_thr=0.5

cd ${datadir}
mkdir repeatability
cd ${datadir}/repeatability
mkdir results

for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
do
    mkdir results/${sub}

    for session in "s1" "s2"
    do 

        for state in "REST" "TASK"
        do 
# GE 3D Protocol
            mkdir results/${sub}/ge_3D_${session}_${state}
            analysisdir=${datadir}/${sub}/ge/${session}/analysis
            targetdir=${datadir}/repeatability/results/${sub}/ge_3D_${session}_${state}
            # Prepare the images
            # Motion correction and BET on 5 CBF repeats
            fslmerge -t ${analysisdir}/3D_${state}/REPEAT_ALL_CBF.nii.gz ${analysisdir}/3D_${state}/REPEAT1_CBF.nii.gz ${analysisdir}/3D_${state}/REPEAT2_CBF.nii.gz ${analysisdir}/3D_${state}/REPEAT3_CBF.nii.gz ${analysisdir}/3D_${state}/REPEAT4_CBF.nii.gz ${analysisdir}/3D_${state}/REPEAT5_CBF.nii.gz
            mcflirt -in ${analysisdir}/3D_${state}/REPEAT_ALL_CBF.nii.gz -out ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt.nii.gz -report >> ${outputdir}/log_repeatability.txt
            fslmaths ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt.nii.gz -Tmean ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt_mean.nii.gz
            bet ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt_mean.nii.gz ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt_mean_BETed.nii.gz -m
            # Motion correction and BET on 5 M0 repeats
            fslmerge -t ${analysisdir}/3D_${state}/REPEAT_ALL_M0.nii.gz ${analysisdir}/3D_${state}/REPEAT1_M0.nii.gz ${analysisdir}/3D_${state}/REPEAT2_M0.nii.gz ${analysisdir}/3D_${state}/REPEAT3_M0.nii.gz ${analysisdir}/3D_${state}/REPEAT4_M0.nii.gz ${analysisdir}/3D_${state}/REPEAT5_M0.nii.gz
            mcflirt -in ${analysisdir}/3D_${state}/REPEAT_ALL_M0.nii.gz -out ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt.nii.gz -report >> ${outputdir}/log_repeatability.txt
            fslmaths ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt.nii.gz -Tmean ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt_mean.nii.gz
            bet ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt_mean.nii.gz ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt_mean_BETed.nii.gz -m
            # Copy the MCed and BETed images to the repeatability sub folder
            cp ${analysisdir}/3D_${state}/REPEAT_ALL_CBF_mcflirt_mean_BETed.nii.gz ${targetdir}/cbf_wb_nopvc.nii.gz
            cp ${analysisdir}/3D_${state}/REPEAT_ALL_M0_mcflirt_mean_BETed.nii.gz ${targetdir}/m0.nii.gz

            flirt -in ${targetdir}/m0.nii.gz -ref ${analysisdir}/T1.anat/T1_biascorr.nii.gz -omat ${targetdir}/asl2struct.mat -dof 6
            flirt -in ${analysisdir}/T1.anat/T1_fast_pve_1 -ref ${targetdir}/cbf_wb_nopvc -out ${targetdir}/prob_gm
            flirt -in ${analysisdir}/T1.anat/T1_fast_pve_2 -ref ${targetdir}/cbf_wb_nopvc -out ${targetdir}/prob_wm
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${targetdir}/cbf_wb_nopvc --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --premat=${targetdir}/asl2struct.mat --out=${targetdir}/cbf_wb_nopvc_mni 
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_1 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_gm_mni 
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_2 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_wm_mni 

            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_gm_nopvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_wm_nopvc
            cp ${FSLDIR}/data/atlases/MNI/MNI-prob-2mm.nii.gz ${targetdir}/std_MNI-prob.nii.gz
            convert_xfm -omat ${targetdir}/struct2asl.mat -inverse ${targetdir}/asl2struct.mat

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_fl-prob 2 1
            fslmaths ${targetdir}/std_fl-prob -div 100 ${targetdir}/std_fl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_fl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_fl
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_fl_nopvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_ol-prob 4 1
            fslmaths ${targetdir}/std_ol-prob -div 100 ${targetdir}/std_ol-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_ol-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_ol
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_ol_nopvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_pl-prob 5 1
            fslmaths ${targetdir}/std_pl-prob -div 100 ${targetdir}/std_pl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_pl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_pl
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_pl_nopvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_tl-prob 7 1
            fslmaths ${targetdir}/std_tl-prob -div 100 ${targetdir}/std_tl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_tl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_tl
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_tl_nopvc

# GE eASL Protocol
            mkdir results/${sub}/ge_eASL_${session}_${state}
            analysisdir=${datadir}/${sub}/ge/${session}/analysis
            targetdir=${datadir}/repeatability/results/${sub}/ge_eASL_${session}_${state}
            # Prepare the images
            cp ${analysisdir}/eASL_${state}/native_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc.nii.gz 
            cp ${analysisdir}/eASL_${state}/native_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc.nii.gz 
            cp ${analysisdir}/eASL_${state}/native_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc.nii.gz 
            cp ${analysisdir}/eASL_${state}/native_space/pvgm_inasl.nii.gz ${targetdir}/prob_gm.nii.gz 
            cp ${analysisdir}/eASL_${state}/native_space/pvwm_inasl.nii.gz ${targetdir}/prob_wm.nii.gz 
            cp ${analysisdir}/eASL_${state}/native_space/asl2struct.mat ${targetdir}/asl2struct.mat 
            cp ${analysisdir}/eASL_${state}/std_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc_mni.nii.gz 
            cp ${analysisdir}/eASL_${state}/std_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc_mni.nii.gz 
            cp ${analysisdir}/eASL_${state}/std_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc_mni.nii.gz 

            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_1 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_gm_mni 
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_2 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_wm_mni 
            fslmaths ${targetdir}/cbf_gm_pvc -mul ${targetdir}/prob_gm ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc -mul ${targetdir}/prob_wm -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc 
            rm ${targetdir}/temp.nii.gz 
            fslmaths ${targetdir}/cbf_gm_pvc_mni -mul ${targetdir}/prob_gm_mni ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc_mni -mul ${targetdir}/prob_wm_mni -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc_mni 
            rm ${targetdir}/temp.nii.gz 

            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_gm_nopvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_wm_nopvc
            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_gm_pvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_wm_pvc
            cp ${FSLDIR}/data/atlases/MNI/MNI-prob-2mm.nii.gz ${targetdir}/std_MNI-prob.nii.gz
            convert_xfm -omat ${targetdir}/struct2asl.mat -inverse ${targetdir}/asl2struct.mat

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_fl-prob 2 1
            fslmaths ${targetdir}/std_fl-prob -div 100 ${targetdir}/std_fl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_fl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_fl
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_fl_nopvc
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_fl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_ol-prob 4 1
            fslmaths ${targetdir}/std_ol-prob -div 100 ${targetdir}/std_ol-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_ol-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_ol
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_ol_nopvc
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_ol_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_pl-prob 5 1
            fslmaths ${targetdir}/std_pl-prob -div 100 ${targetdir}/std_pl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_pl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_pl
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_pl_nopvc
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_pl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_tl-prob 7 1
            fslmaths ${targetdir}/std_tl-prob -div 100 ${targetdir}/std_tl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_tl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_tl
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_tl_nopvc
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_tl_pvc

# Ingenia 2D Protocol 
            mkdir results/${sub}/ing_2D_${session}_${state}
            analysisdir=${datadir}/${sub}/ing/${session}/analysis
            targetdir=${datadir}/repeatability/results/${sub}/ing_2D_${session}_${state}
            # Prepare the images
            cp ${analysisdir}/2D_${state}/native_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc.nii.gz 
            cp ${analysisdir}/2D_${state}/native_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc.nii.gz 
            cp ${analysisdir}/2D_${state}/native_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc.nii.gz 
            cp ${analysisdir}/2D_${state}/native_space/pvgm_inasl.nii.gz ${targetdir}/prob_gm.nii.gz 
            cp ${analysisdir}/2D_${state}/native_space/pvwm_inasl.nii.gz ${targetdir}/prob_wm.nii.gz 
            cp ${analysisdir}/2D_${state}/native_space/asl2struct.mat ${targetdir}/asl2struct.mat 
            cp ${analysisdir}/2D_${state}/std_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc_mni.nii.gz 
            cp ${analysisdir}/2D_${state}/std_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc_mni.nii.gz 
            cp ${analysisdir}/2D_${state}/std_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc_mni.nii.gz 

            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_1 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_gm_mni 
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_2 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_wm_mni 
            fslmaths ${targetdir}/cbf_gm_pvc -mul ${targetdir}/prob_gm ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc -mul ${targetdir}/prob_wm -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc 
            rm ${targetdir}/temp.nii.gz 
            fslmaths ${targetdir}/cbf_gm_pvc_mni -mul ${targetdir}/prob_gm_mni ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc_mni -mul ${targetdir}/prob_wm_mni -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc_mni 
            rm ${targetdir}/temp.nii.gz 

            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_gm_nopvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_wm_nopvc
            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_gm_pvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_wm_pvc
            cp ${FSLDIR}/data/atlases/MNI/MNI-prob-2mm.nii.gz ${targetdir}/std_MNI-prob.nii.gz
            convert_xfm -omat ${targetdir}/struct2asl.mat -inverse ${targetdir}/asl2struct.mat

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_fl-prob 2 1
            fslmaths ${targetdir}/std_fl-prob -div 100 ${targetdir}/std_fl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_fl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_fl
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_fl_nopvc
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_fl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_ol-prob 4 1
            fslmaths ${targetdir}/std_ol-prob -div 100 ${targetdir}/std_ol-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_ol-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_ol
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_ol_nopvc
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_ol_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_pl-prob 5 1
            fslmaths ${targetdir}/std_pl-prob -div 100 ${targetdir}/std_pl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_pl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_pl
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_pl_nopvc
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_pl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_tl-prob 7 1
            fslmaths ${targetdir}/std_tl-prob -div 100 ${targetdir}/std_tl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_tl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_tl
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_tl_nopvc
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_tl_pvc

# Ingenia 3D Protocol 
            mkdir results/${sub}/ing_3D_${session}_${state}
            analysisdir=${datadir}/${sub}/ing/${session}/analysis
            targetdir=${datadir}/repeatability/results/${sub}/ing_3D_${session}_${state}
            # Prepare the images
            cp ${analysisdir}/3D_${state}/native_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc.nii.gz 
            cp ${analysisdir}/3D_${state}/native_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc.nii.gz 
            cp ${analysisdir}/3D_${state}/native_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc.nii.gz 
            cp ${analysisdir}/3D_${state}/native_space/pvgm_inasl.nii.gz ${targetdir}/prob_gm.nii.gz 
            cp ${analysisdir}/3D_${state}/native_space/pvwm_inasl.nii.gz ${targetdir}/prob_wm.nii.gz 
            cp ${analysisdir}/3D_${state}/native_space/asl2struct.mat ${targetdir}/asl2struct.mat 
            cp ${analysisdir}/3D_${state}/std_space/perfusion_calib.nii.gz ${targetdir}/cbf_wb_nopvc_mni.nii.gz 
            cp ${analysisdir}/3D_${state}/std_space/pvcorr/perfusion_calib.nii.gz ${targetdir}/cbf_gm_pvc_mni.nii.gz 
            cp ${analysisdir}/3D_${state}/std_space/pvcorr/perfusion_wm_calib.nii.gz ${targetdir}/cbf_wm_pvc_mni.nii.gz 

            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_1 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_gm_mni 
            applywarp --ref=${FSLDIR}/data/standard/MNI152_T1_2mm --in=${analysisdir}/T1.anat/T1_fast_pve_2 --warp=${analysisdir}/T1.anat/T1_to_MNI_nonlin_field --out=${targetdir}/prob_wm_mni 
            fslmaths ${targetdir}/cbf_gm_pvc -mul ${targetdir}/prob_gm ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc -mul ${targetdir}/prob_wm -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc 
            rm ${targetdir}/temp.nii.gz 
            fslmaths ${targetdir}/cbf_gm_pvc_mni -mul ${targetdir}/prob_gm_mni ${targetdir}/temp
            fslmaths ${targetdir}/cbf_wm_pvc_mni -mul ${targetdir}/prob_wm_mni -add ${targetdir}/temp ${targetdir}/cbf_wb_pvc_mni 
            rm ${targetdir}/temp.nii.gz 

            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_gm_nopvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_wm_nopvc
            fslmaths ${targetdir}/prob_gm -thr $[gm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_gm_pvc
            fslmaths ${targetdir}/prob_wm -thr $[wm_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_wm_pvc
            cp ${FSLDIR}/data/atlases/MNI/MNI-prob-2mm.nii.gz ${targetdir}/std_MNI-prob.nii.gz
            convert_xfm -omat ${targetdir}/struct2asl.mat -inverse ${targetdir}/asl2struct.mat

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_fl-prob 2 1
            fslmaths ${targetdir}/std_fl-prob -div 100 ${targetdir}/std_fl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_fl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_fl
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_fl_nopvc
            fslmaths ${targetdir}/prob_fl -thr $[fl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_fl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_ol-prob 4 1
            fslmaths ${targetdir}/std_ol-prob -div 100 ${targetdir}/std_ol-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_ol-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_ol
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_ol_nopvc
            fslmaths ${targetdir}/prob_ol -thr $[ol_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_ol_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_pl-prob 5 1
            fslmaths ${targetdir}/std_pl-prob -div 100 ${targetdir}/std_pl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_pl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_pl
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_pl_nopvc
            fslmaths ${targetdir}/prob_pl -thr $[pl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_pl_pvc

            fslroi ${targetdir}/std_MNI-prob.nii.gz ${targetdir}/std_tl-prob 7 1
            fslmaths ${targetdir}/std_tl-prob -div 100 ${targetdir}/std_tl-prob
            applywarp --ref=${targetdir}/cbf_wb_nopvc --in=${targetdir}/std_tl-prob --warp=${analysisdir}/T1.anat/MNI_to_T1_nonlin_field --postmat=${targetdir}/struct2asl.mat --out=${targetdir}/prob_tl
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_nopvc ${targetdir}/cbf_tl_nopvc
            fslmaths ${targetdir}/prob_tl -thr $[tl_thr] -bin -mul ${targetdir}/cbf_wb_pvc ${targetdir}/cbf_tl_pvc

        done # for state in "REST" "TASK"
        
    done # for session in "s1" "s2"

done # for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
