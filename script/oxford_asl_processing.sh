#!/usr/bin/zsh

# rootdir=/Users/xinzhang/Downloads/mrc_asl_cic
datadir=$rootdir/data
outputdir=$rootdir/output

for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
do
# GE session 1
    cd ${datadir}/${sub}/ge/s1

    mkdir analysis

    echo Doing: ${sub} GE Session 1 - fsl_anat
    # Do fsl_anat on structural image
    fsl_anat -i nifti/3D_SAG_T1_MP-RAGE_TI800.nii.gz -o analysis/T1 >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} GE Session 1 - fsl_anat

    mkdir analysis/3D_REST
    if (($(fslnvols nifti/3D_Ax_ASL_5_starts.nii.gz)==2)); then 
        REST_3D_2vol=nifti/3D_Ax_ASL_5_starts.nii.gz
        REST_3D_8vol=nifti/3D_Ax_ASL_5_startsa.nii.gz
    else
        REST_3D_2vol=nifti/3D_Ax_ASL_5_startsa.nii.gz
        REST_3D_8vol=nifti/3D_Ax_ASL_5_starts.nii.gz
    fi
    # in the image with 2 volumes, M0 precedes CBF; in the image with 8 volumes, CBF precedes M0
    fslroi $REST_3D_2vol analysis/3D_REST/REPEAT1_M0.nii.gz 0 1
    fslroi $REST_3D_2vol analysis/3D_REST/REPEAT1_CBF.nii.gz 1 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT2_CBF.nii.gz 0 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT2_M0.nii.gz 1 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT3_CBF.nii.gz 2 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT3_M0.nii.gz 3 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT4_CBF.nii.gz 4 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT4_M0.nii.gz 5 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT5_CBF.nii.gz 6 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT5_M0.nii.gz 7 1

    mkdir analysis/3D_TASK
    if (($(fslnvols nifti/3D_Ax_ASL_ACT_5_starts.nii.gz)==2)); then 
        TASK_3D_2vol=nifti/3D_Ax_ASL_ACT_5_starts.nii.gz
        TASK_3D_8vol=nifti/3D_Ax_ASL_ACT_5_startsa.nii.gz
    else
        TASK_3D_2vol=nifti/3D_Ax_ASL_ACT_5_startsa.nii.gz
        TASK_3D_8vol=nifti/3D_Ax_ASL_ACT_5_starts.nii.gz
    fi
    # in the image with 2 volumes, M0 precedes CBF; in the image with 8 volumes, CBF precedes M0
    fslroi $TASK_3D_2vol analysis/3D_TASK/REPEAT1_M0.nii.gz 0 1
    fslroi $TASK_3D_2vol analysis/3D_TASK/REPEAT1_CBF.nii.gz 1 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT2_CBF.nii.gz 0 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT2_M0.nii.gz 1 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT3_CBF.nii.gz 2 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT3_M0.nii.gz 3 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT4_CBF.nii.gz 4 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT4_M0.nii.gz 5 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT5_CBF.nii.gz 6 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT5_M0.nii.gz 7 1

    mkdir analysis/eASL_REST
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/diff.nii.gz 0 7 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/CBF.nii.gz 7 1 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/M0.nii.gz 8 1 

    mkdir analysis/eASL_TASK 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/diff.nii.gz 0 7 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/CBF.nii.gz 7 1 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/M0.nii.gz 8 1 

    cd ./analysis 
    echo Doing: ${sub} GE Session 1 - 3D REST CBF Averaging
    fslmaths 3D_REST/REPEAT1_CBF.nii.gz -add 3D_REST/REPEAT2_CBF.nii.gz -add 3D_REST/REPEAT3_CBF.nii.gz -add 3D_REST/REPEAT4_CBF.nii.gz -add 3D_REST/REPEAT5_CBF.nii.gz -div 5 3D_REST/AVG_CBF.nii.gz 
    echo Finished: ${sub} GE Session 1 - 3D REST CBF Averaging
    
    echo Doing: ${sub} GE Session 1 - 3D TASK CBF Averaging
    fslmaths 3D_TASK/REPEAT1_CBF.nii.gz -add 3D_TASK/REPEAT2_CBF.nii.gz -add 3D_TASK/REPEAT3_CBF.nii.gz -add 3D_TASK/REPEAT4_CBF.nii.gz -add 3D_TASK/REPEAT5_CBF.nii.gz -div 5 3D_TASK/AVG_CBF.nii.gz 
    echo Finished: ${sub} GE Session 1 - 3D TASK CBF Averaging

    eASL_bolus=1.183,0.682,0.481,0.372,0.303,0.256,0.222
    eASL_tis=4.199,3.016,2.334,1.853,1.481,1.178,0.922
    eASL_TRM0=$(jq .RepetitionTime ../nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.json)

    echo Doing: ${sub} GE Session 1 - eASL REST oxford_asl Processing
    oxford_asl -i eASL_REST/diff.nii.gz -o ./eASL_REST/ --iaf=diff --ibf=rpt --casl --bolus=$eASL_bolus --tis=$eASL_tis --rpts=1 -c eASL_REST/M0.nii.gz --tr=$eASL_TRM0 --cmethod=voxel --cgain=32 --alpha=0.6 --fslanat=T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} GE Session 1 - eASL REST oxford_asl Processing

    echo Doing: ${sub} GE Session 1 - eASL TASK oxford_asl Processing
    oxford_asl -i eASL_TASK/diff.nii.gz -o ./eASL_TASK/ --iaf=diff --ibf=rpt --casl --bolus=$eASL_bolus --tis=$eASL_tis --rpts=1 -c eASL_TASK/M0.nii.gz --tr=$eASL_TRM0 --cmethod=voxel --cgain=32 --alpha=0.6 --fslanat=T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} GE Session 1 - eASL TASK oxford_asl Processing

    mkdir calib_csf
    for state in "eASL_REST" "eASL_TASK"
    do 
        echo Doing: ${sub} GE Session 1 - ${state} CSF calibration
        mkdir calib_csf/${state}
        cp ./${state}/native_space/perfusion.nii.gz ./calib_cbf/${state}/perfusion.nii.gz 
        cp ./${state}/M0.nii.gz ./calib_cbf/${state}/M0.nii.gz 
        asl_calib -i calib_csf/${state}/perfusion.nii.gz -o calib_csf/${state} -c calib_csf/${state}/M0.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t ${state}/native_space/asl2struct.mat --tr $eASL_TRM0 --cgain 32 --alpha 0.6
        for space in "native_space" "struct_space" "std_space"
        do 
            fslmaths ${state}/${space}/perfusion.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/perfusion_calib_csf.nii.gz 
            fslmaths ${state}/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/pvcorr/perfusion_calib_csf.nii.gz 
            fslmaths ${state}/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
        done
        echo Finished: ${sub} GE Session 1 - ${state} CSF calibration
    done

# GE session 2
    cd ${datadir}/${sub}/ge/s2

    mkdir analysis

    echo Doing: ${sub} GE Session 2 - fsl_anat
    cp -r ${datadir}/${sub}/ge/s1/analysis/T1.anat ${datadir}/${sub}/ge/s2/analysis
    echo Finished: ${sub} GE Session 2 - fsl_anat

    mkdir analysis/3D_REST
    if (($(fslnvols nifti/3D_Ax_ASL_5_starts.nii.gz)==2)); then 
        REST_3D_2vol=nifti/3D_Ax_ASL_5_starts.nii.gz
        REST_3D_8vol=nifti/3D_Ax_ASL_5_startsa.nii.gz
    else
        REST_3D_2vol=nifti/3D_Ax_ASL_5_startsa.nii.gz
        REST_3D_8vol=nifti/3D_Ax_ASL_5_starts.nii.gz
    fi
    # in the image with 2 volumes, M0 precedes CBF; in the image with 8 volumes, CBF precedes M0
    fslroi $REST_3D_2vol analysis/3D_REST/REPEAT1_M0.nii.gz 0 1
    fslroi $REST_3D_2vol analysis/3D_REST/REPEAT1_CBF.nii.gz 1 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT2_CBF.nii.gz 0 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT2_M0.nii.gz 1 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT3_CBF.nii.gz 2 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT3_M0.nii.gz 3 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT4_CBF.nii.gz 4 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT4_M0.nii.gz 5 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT5_CBF.nii.gz 6 1
    fslroi $REST_3D_8vol analysis/3D_REST/REPEAT5_M0.nii.gz 7 1

    mkdir analysis/3D_TASK
    if (($(fslnvols nifti/3D_Ax_ASL_ACT_5_starts.nii.gz)==2)); then 
        TASK_3D_2vol=nifti/3D_Ax_ASL_ACT_5_starts.nii.gz
        TASK_3D_8vol=nifti/3D_Ax_ASL_ACT_5_startsa.nii.gz
    else
        TASK_3D_2vol=nifti/3D_Ax_ASL_ACT_5_startsa.nii.gz
        TASK_3D_8vol=nifti/3D_Ax_ASL_ACT_5_starts.nii.gz
    fi
    # in the image with 2 volumes, M0 precedes CBF; in the image with 8 volumes, CBF precedes M0
    fslroi $TASK_3D_2vol analysis/3D_TASK/REPEAT1_M0.nii.gz 0 1
    fslroi $TASK_3D_2vol analysis/3D_TASK/REPEAT1_CBF.nii.gz 1 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT2_CBF.nii.gz 0 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT2_M0.nii.gz 1 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT3_CBF.nii.gz 2 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT3_M0.nii.gz 3 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT4_CBF.nii.gz 4 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT4_M0.nii.gz 5 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT5_CBF.nii.gz 6 1
    fslroi $TASK_3D_8vol analysis/3D_TASK/REPEAT5_M0.nii.gz 7 1

    mkdir analysis/eASL_REST
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/diff.nii.gz 0 7 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/CBF.nii.gz 7 1 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz analysis/eASL_REST/M0.nii.gz 8 1 

    mkdir analysis/eASL_TASK 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/diff.nii.gz 0 7 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/CBF.nii.gz 7 1 
    fslroi nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz analysis/eASL_TASK/M0.nii.gz 8 1 

    cd ./analysis 
    echo Doing: ${sub} GE Session 2 - 3D REST CBF Averaging
    fslmaths 3D_REST/REPEAT1_CBF.nii.gz -add 3D_REST/REPEAT2_CBF.nii.gz -add 3D_REST/REPEAT3_CBF.nii.gz -add 3D_REST/REPEAT4_CBF.nii.gz -add 3D_REST/REPEAT5_CBF.nii.gz -div 5 3D_REST/AVG_CBF.nii.gz 
    echo Finished: ${sub} GE Session 2 - 3D REST CBF Averaging

    echo Doing: ${sub} GE Session 2 - 3D TASK CBF Averaging
    fslmaths 3D_TASK/REPEAT1_CBF.nii.gz -add 3D_TASK/REPEAT2_CBF.nii.gz -add 3D_TASK/REPEAT3_CBF.nii.gz -add 3D_TASK/REPEAT4_CBF.nii.gz -add 3D_TASK/REPEAT5_CBF.nii.gz -div 5 3D_TASK/AVG_CBF.nii.gz 
    echo Finished: ${sub} GE Session 2 - 3D TASK CBF Averaging

    eASL_bolus=1.183,0.682,0.481,0.372,0.303,0.256,0.222
    eASL_tis=4.199,3.016,2.334,1.853,1.481,1.178,0.922
    eASL_TRM0=$(jq .RepetitionTime ../nifti/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.json)

    echo Doing: ${sub} GE Session 2 - eASL REST oxford_asl Processing
    oxford_asl -i eASL_REST/diff.nii.gz -o ./eASL_REST/ --iaf=diff --ibf=rpt --casl --bolus=$eASL_bolus --tis=$eASL_tis --rpts=1 -c eASL_REST/M0.nii.gz --tr=$eASL_TRM0 --cmethod=voxel --cgain=32 --alpha=0.6 --fslanat=T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} GE Session 2 - eASL REST oxford_asl Processing

    echo Doing: ${sub} GE Session 2 - eASL TASK oxford_asl Processing
    oxford_asl -i eASL_TASK/diff.nii.gz -o ./eASL_TASK/ --iaf=diff --ibf=rpt --casl --bolus=$eASL_bolus --tis=$eASL_tis --rpts=1 -c eASL_TASK/M0.nii.gz --tr=$eASL_TRM0 --cmethod=voxel --cgain=32 --alpha=0.6 --fslanat=T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} GE Session 2 - eASL TASK oxford_asl Processing

    mkdir calib_csf
    for state in "eASL_REST" "eASL_TASK"
    do 
        echo Doing: ${sub} GE Session 2 - ${state} CSF calibration
        mkdir calib_csf/${state}
        cp ./${state}/native_space/perfusion.nii.gz ./calib_cbf/${state}/perfusion.nii.gz 
        cp ./${state}/M0.nii.gz ./calib_cbf/${state}/M0.nii.gz 
        asl_calib -i calib_csf/${state}/perfusion.nii.gz -o calib_csf/${state} -c calib_csf/${state}/M0.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t ${state}/native_space/asl2struct.mat --tr $eASL_TRM0 --cgain 32 --alpha 0.6
        for space in "native_space" "struct_space" "std_space"
        do 
            fslmaths ${state}/${space}/perfusion.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/perfusion_calib_csf.nii.gz 
            fslmaths ${state}/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/pvcorr/perfusion_calib_csf.nii.gz 
            fslmaths ${state}/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/${state}/M0.txt) -mul 6000 ${state}/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
        done
        echo Finished: ${sub} GE Session 2 - ${state} CSF calibration
    done

# Ing session 1
    cd ${datadir}/${sub}/ing/s1

    mkdir analysis
    
    echo Doing: ${sub} Ing Session 1 - fsl_anat
    fsl_anat -i nifti/MPRAGE.nii.gz -o analysis/T1 >> ${outputdir}/log_oxford_asl_processing.txt >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 1 - fsl_anat

    echo Doing: ${sub} Ing Session 1 - 2D REST oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 1 - 2D REST oxford_asl Processing

    echo Doing: ${sub} Ing Session 1 - 2D TASK oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_2dACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 1 - 2D TASK oxford_asl Processing

    echo Doing: ${sub} Ing Session 1 - 3D REST oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_REST_PROD_3D_pCASL_6mm_noNorm.nii.gz -o analysis/3D_REST --iaf=ct --ibf=tis --tis=3.8 --casl --bolus=1.8 --rpts=8 -c nifti/WIP_SOURCE_-_Mo3d.nii.gz --tr=4.752 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 1 - 3D REST oxford_asl Processing

    echo Doing: ${sub} Ing Session 1 - 3D TASK oxford_asl Processing
    oxford_asl -i nifti/SOURCE_-_ACT_PROD_3D_pCASL_6mm_noNorm.nii.gz -o analysis/3D_TASK --iaf=ct --ibf=tis --tis=3.8 --casl --bolus=1.8 --rpts=8 -c nifti/WIP_SOURCE_-_Mo3d.nii.gz --tr=4.752 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 1 - 3D TASK oxford_asl Processing

    mkdir calib_csf
    echo Doing: ${sub} Ing Session 1 - 2D_REST CSF calibration
    mkdir calib_csf/2D_REST
    cp ./2D_REST/native_space/perfusion.nii.gz ./calib_cbf/2D_REST/perfusion.nii.gz 
    asl_calib -i calib_csf/2D_REST/perfusion.nii.gz -o calib_csf/2D_REST -c ../nifti/2dM0_PROD_pCASL.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 2D_REST/native_space/asl2struct.mat --tr=8
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 2D_REST/${space}/perfusion.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 2D_REST/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 2D_REST/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 1 - 2D_REST CSF calibration

    echo Doing: ${sub} Ing Session 1 - 2D_TASK CSF calibration
    mkdir calib_csf/2D_TASK
    cp ./2D_TASK/native_space/perfusion.nii.gz ./calib_cbf/2D_TASK/perfusion.nii.gz 
    asl_calib -i calib_csf/2D_TASK/perfusion.nii.gz -o calib_csf/2D_TASK -c ../nifti/2dM0_PROD_pCASLa.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 2D_TASK/native_space/asl2struct.mat --tr=8
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 2D_TASK/${space}/perfusion.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 2D_TASK/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 2D_TASK/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 1 - 2D_TASK CSF calibration

    echo Doing: ${sub} Ing Session 1 - 3D_REST CSF calibration
    mkdir calib_csf/3D_REST
    cp ./3D_REST/native_space/perfusion.nii.gz ./calib_cbf/3D_REST/perfusion.nii.gz 
    asl_calib -i calib_csf/3D_REST/perfusion.nii.gz -o calib_csf/3D_REST -c ../nifti/WIP_SOURCE_-_Mo3d.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 3D_REST/native_space/asl2struct.mat --tr=4.752
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 3D_REST/${space}/perfusion.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 3D_REST/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 3D_REST/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 1 - 3D_REST CSF calibration

    echo Doing: ${sub} Ing Session 1 - 3D_TASK CSF calibration
    mkdir calib_csf/3D_TASK
    cp ./3D_TASK/native_space/perfusion.nii.gz ./calib_cbf/3D_TASK/perfusion.nii.gz 
    asl_calib -i calib_csf/3D_TASK/perfusion.nii.gz -o calib_csf/3D_TASK -c ../nifti/WIP_SOURCE_-_Mo3d.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 3D_TASK/native_space/asl2struct.mat --tr=4.752
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 3D_TASK/${space}/perfusion.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 3D_TASK/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 3D_TASK/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 1 - 3D_TASK CSF calibration

# Ing session 2
    cd ${datadir}/${sub}/ing/s2

    mkdir analysis

    echo Doing: ${sub} Ing Session 2 - fsl_anat
    cp -r ${datadir}/${sub}/ing/s1/analysis/T1.anat ${datadir}/${sub}/ing/s2/analysis
    echo Finished: ${sub} Ing Session 2 - fsl_anat

    echo Doing: ${sub} Ing Session 2 - 2D REST oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 2 - 2D REST oxford_asl Processing

    echo Doing: ${sub} Ing Session 2 - 2D TASK oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_2dACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 2 - 2D TASK oxford_asl Processing

    echo Doing: ${sub} Ing Session 2 - 3D REST oxford_asl Processing
    oxford_asl -i nifti/WIP_SOURCE_-_REST_PROD_3D_pCASL_6mm_noNorm.nii.gz -o analysis/3D_REST --iaf=ct --ibf=tis --tis=3.8 --casl --bolus=1.8 --rpts=8 -c nifti/WIP_SOURCE_-_Mo3d.nii.gz --tr=4.752 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 2 - 3D REST oxford_asl Processing

    echo Doing: ${sub} Ing Session 2 - 3D TASK oxford_asl Processing
    oxford_asl -i nifti/SOURCE_-_ACT_PROD_3D_pCASL_6mm_noNorm.nii.gz -o analysis/3D_TASK --iaf=ct --ibf=tis --tis=3.8 --casl --bolus=1.8 --rpts=8 -c nifti/WIP_SOURCE_-_Mo3d.nii.gz --tr=4.752 --cmethod=voxel --fslanat=analysis/T1.anat --mc --pvcorr >> ${outputdir}/log_oxford_asl_processing_${sub}.txt
    echo Finished: ${sub} Ing Session 2 - 3D TASK oxford_asl Processing

    mkdir calib_csf
    echo Doing: ${sub} Ing Session 2 - 2D_REST CSF calibration
    mkdir calib_csf/2D_REST
    cp ./2D_REST/native_space/perfusion.nii.gz ./calib_cbf/2D_REST/perfusion.nii.gz 
    asl_calib -i calib_csf/2D_REST/perfusion.nii.gz -o calib_csf/2D_REST -c ../nifti/2dM0_PROD_pCASL.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 2D_REST/native_space/asl2struct.mat --tr=8
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 2D_REST/${space}/perfusion.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 2D_REST/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 2D_REST/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/2D_REST/M0.txt) -mul 6000 2D_REST/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 2 - 2D_REST CSF calibration

    echo Doing: ${sub} Ing Session 2 - 2D_TASK CSF calibration
    mkdir calib_csf/2D_TASK
    cp ./2D_TASK/native_space/perfusion.nii.gz ./calib_cbf/2D_TASK/perfusion.nii.gz 
    asl_calib -i calib_csf/2D_TASK/perfusion.nii.gz -o calib_csf/2D_TASK -c ../nifti/2dM0_PROD_pCASLa.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 2D_TASK/native_space/asl2struct.mat --tr=8
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 2D_TASK/${space}/perfusion.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 2D_TASK/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 2D_TASK/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/2D_TASK/M0.txt) -mul 6000 2D_TASK/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 2 - 2D_TASK CSF calibration

    echo Doing: ${sub} Ing Session 2 - 3D_REST CSF calibration
    mkdir calib_csf/3D_REST
    cp ./3D_REST/native_space/perfusion.nii.gz ./calib_cbf/3D_REST/perfusion.nii.gz 
    asl_calib -i calib_csf/3D_REST/perfusion.nii.gz -o calib_csf/3D_REST -c ../nifti/WIP_SOURCE_-_Mo3d.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 3D_REST/native_space/asl2struct.mat --tr=4.752
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 3D_REST/${space}/perfusion.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 3D_REST/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 3D_REST/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/3D_REST/M0.txt) -mul 6000 3D_REST/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 2 - 3D_REST CSF calibration

    echo Doing: ${sub} Ing Session 2 - 3D_TASK CSF calibration
    mkdir calib_csf/3D_TASK
    cp ./3D_TASK/native_space/perfusion.nii.gz ./calib_cbf/3D_TASK/perfusion.nii.gz 
    asl_calib -i calib_csf/3D_TASK/perfusion.nii.gz -o calib_csf/3D_TASK -c ../nifti/WIP_SOURCE_-_Mo3d.nii.gz -s T1.anat/T1_biascorr_brain.nii.gz -t 3D_TASK/native_space/asl2struct.mat --tr=4.752
    for space in "native_space" "struct_space" "std_space"
    do 
        fslmaths 3D_TASK/${space}/perfusion.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/perfusion_calib_csf.nii.gz 
        fslmaths 3D_TASK/${space}/pvcorr/perfusion.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/pvcorr/perfusion_calib_csf.nii.gz 
        fslmaths 3D_TASK/${space}/pvcorr/perfusion_wm.nii.gz -div $(<./calib_csf/3D_TASK/M0.txt) -mul 6000 3D_TASK/${space}/pvcorr/perfusion_wm_calib_csf.nii.gz 
    done
    echo Finished: ${sub} Ing Session 2 - 3D_TASK CSF calibration

    echo Finshied: ${sub} - ALL PROCESSING

done

echo Finished: ALL SUBJECTS PROCESSING