#!/usr/bin/zsh

datadir=//Users/xinzhang/Downloads/mrc_asl_cic/data

for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
do

    cd ${datadir}/${sub}/ing/s1

    cp nifti/B0_e1a.nii.gz analysis/B0_magnitude.nii.gz
    cp nifti/B0_e2_fieldmaphza.nii.gz analysis/B0_fieldmap_hz.nii.gz

    # get fieldmap into rad/s
    fslmaths analysis/B0_fieldmap_hz -mul 6.28 analysis/B0_fieldmap_rads

    # regularisation of the fieldmap using median filtering
    fugue --loadfmap=analysis/B0_fieldmap_rads -m --savefmap=analysis/B0_fieldmap_rads_reg

    # extract brain from magnitude image
    bet analysis/B0_magnitude analysis/B0_magnitude_brain
    fslmaths analysis/B0_magnitude_brain -ero analysis/B0_magnitude_brain_ero

    # remove unwanted files
    rm analysis/B0_fieldmap_hz.nii.gz
    rm analysis/B0_fieldmap_rads.nii.gz 
    rm analysis/B0_magnitude_brain.nii.gz

    # rename magnitude_brain_ero to magnitude_brain
    mv analysis/B0_magnitude_brain_ero.nii.gz analysis/B0_magnitude_brain.nii.gz 

    eff_echo_spacing=$(jq .EstimatedEffectiveEchoSpacing nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.json)
    echo Doing: ${sub} Ing Session 1 - 2D REST oxford_asl Distortion Correction PEdir: y
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST_dc_pediry --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=y 
    echo Finished: ${sub} Ing Session 1 - 2D REST oxford_asl Distortion Correction PEdir: y

    echo Doing: ${sub} Ing Session 1 - 2D REST oxford_asl Distortion Correction PEdir: \-y
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST_dc_pedir-y --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=-y 
    echo Finished: ${sub} Ing Session 1 - 2D REST oxford_asl Distortion Correction PEdir: \-y

    eff_echo_spacing=$(jq .EstimatedEffectiveEchoSpacing nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.json)
    echo Doing: ${sub} Ing Session 1 - 2D TASK oxford_asl Distortion Correction PEdir: y
    oxford_asl -i nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK_dc_pediry --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=y 
    echo Finished: ${sub} Ing Session 1 - 2D TASK oxford_asl Distortion Correction PEdir: y

    echo Doing: ${sub} Ing Session 1 - 2D TASK oxford_asl Distortion Correction PEdir: \-y
    oxford_asl -i nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK_dc_pedir-y --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=-y 
    echo Finished: ${sub} Ing Session 1 - 2D TASK oxford_asl Distortion Correction PEdir: \-y

    cd ${datadir}/${sub}/ing/s2

    cp nifti/B0_e1a.nii.gz analysis/B0_magnitude.nii.gz
    cp nifti/B0_e2_fieldmaphza.nii.gz analysis/B0_fieldmap_hz.nii.gz

    # get fieldmap into rad/s
    fslmaths analysis/B0_fieldmap_hz -mul 6.28 analysis/B0_fieldmap_rads

    # regularisation of the fieldmap using median filtering
    fugue --loadfmap=analysis/B0_fieldmap_rads -m --savefmap=analysis/B0_fieldmap_rads_reg

    # extract brain from magnitude image
    bet analysis/B0_magnitude analysis/B0_magnitude_brain
    fslmaths analysis/B0_magnitude_brain -ero analysis/B0_magnitude_brain_ero

    # remove unwanted files
    rm analysis/B0_fieldmap_hz.nii.gz
    rm analysis/B0_fieldmap_rads.nii.gz 
    rm analysis/B0_magnitude_brain.nii.gz

    # rename magnitude_brain_ero to magnitude_brain
    mv analysis/B0_magnitude_brain_ero.nii.gz analysis/B0_magnitude_brain.nii.gz 

    eff_echo_spacing=$(jq .EstimatedEffectiveEchoSpacing nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.json)
    echo Doing: ${sub} Ing Session 2 - 2D REST oxford_asl Distortion Correction PEdir: y
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST_dc_pediry --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=y 
    echo Finished: ${sub} Ing Session 2 - 2D REST oxford_asl Distortion Correction PEdir: y

    echo Doing: ${sub} Ing Session 2 - 2D REST oxford_asl Distortion Correction PEdir: \-y
    oxford_asl -i nifti/WIP_SOURCE_-_2dREST_PROD_pCASL-nonorm.nii.gz -o analysis/2D_REST_dc_pedir-y --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASL.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=-y 
    echo Finished: ${sub} Ing Session 2 - 2D REST oxford_asl Distortion Correction PEdir: \-y

    eff_echo_spacing=$(jq .EstimatedEffectiveEchoSpacing nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.json)
    echo Doing: ${sub} Ing Session 2 - 2D TASK oxford_asl Distortion Correction PEdir: y
    oxford_asl -i nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK_dc_pediry --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=y 
    echo Finished: ${sub} Ing Session 2 - 2D TASK oxford_asl Distortion Correction PEdir: y

    echo Doing: ${sub} Ing Session 2 - 2D TASK oxford_asl Distortion Correction PEdir: \-y
    oxford_asl -i nifti/WIP_SOURCE_-_2DACT_PROD_pCASL-nonorm.nii.gz -o analysis/2D_TASK_dc_pedir-y --iaf=ct --ibf=tis --tis=3.6 --casl --bolus=1.8 --rpts=30 --slicedt=0.0415 -c nifti/2dM0_PROD_pCASLa.nii.gz --tr=8 --cmethod=voxel --fslanat=analysis/T1.anat --fmap=analysis/B0_fieldmap_rads_reg.nii.gz --fmapmag=analysis/B0_magnitude.nii.gz --fmapmagbrain=B0_magnitude_brain.nii.gz --echospacing=$eff_echo_spacing --pedir=-y 
    echo Finished: ${sub} Ing Session 2 - 2D TASK oxford_asl Distortion Correction PEdir: \-y

done