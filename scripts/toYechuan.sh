#!/usr/bin/zsh

# datadir='/Users/xinzhang/Downloads/mrc_asl_cic/data'
# outputdir='/Users/xinzhang/Downloads/toYechuan_eASL/data'

# for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
# do 
#     mkdir ${outputdir}/${sub}
#     cp ${datadir}/${sub}/ge/s1/analysis/T1.anat/T1_fast_pve_1.nii.gz ${outputdir}/${sub}/T1_fast_pve_1.nii.gz
#     cp ${datadir}/${sub}/ge/s1/analysis/T1.anat/T1_fast_pve_2.nii.gz ${outputdir}/${sub}/T1_fast_pve_2.nii.gz
#     cp ${datadir}/${sub}/ge/s1/analysis/T1.anat/T1_to_MNI_nonlin_field.nii.gz ${outputdir}/${sub}/T1_to_MNI_nonlin_field.nii.gz

#     for session in "s1" "s2"
#     do 
#         for state in "REST" "TASK"
#         do 
#             mkdir ${outputdir}/${sub}/${session}_${state}
#             analysisdir=${datadir}/${sub}/ge/${session}/analysis
#             targetdir=${outputdir}/${sub}/${session}_${state}
#             cp ${analysisdir}/eASL_${state}/diff.nii.gz ${targetdir}/diff.nii.gz 
#             cp ${analysisdir}/eASL_${state}/M0.nii.gz ${targetdir}/M0.nii.gz 

#             mkdir ${outputdir}/${sub}/${session}_${state}/native_space_byLogan
#             targetdir=${outputdir}/${sub}/${session}_${state}/native_space_byLogan
#             cp ${analysisdir}/eASL_${state}/native_space/asl2struct.mat ${targetdir}/asl2struct.mat
#             cp ${analysisdir}/eASL_${state}/native_space/perfusion_calib.nii.gz ${targetdir}/perfusion_calib.nii.gz
#             cp ${analysisdir}/eASL_${state}/native_space/pvgm_inasl.nii.gz ${targetdir}/pvgm_inasl.nii.gz
#             cp ${analysisdir}/eASL_${state}/native_space/pvwm_inasl.nii.gz ${targetdir}/pvwm_inasl.nii.gz
#             cp ${analysisdir}/eASL_${state}/native_space/arrival.nii.gz ${targetdir}/arrival.nii.gz

#         done
#     done
# done

# datadir='/Users/xinzhang/Downloads/mrc_asl_cic/data'
# outputdir='/Users/xinzhang/Downloads/toYechuan_eASL/raw_nifti'

# for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
# do 
#     mkdir ${outputdir}/${sub}
#     cp ${datadir}/${sub}/ge/s1/nifti/3D_SAG_T1_MP-RAGE_TI800.json ${outputdir}/${sub}/3D_SAG_T1_MP-RAGE_TI800.json
#     cp ${datadir}/${sub}/ge/s1/nifti/3D_SAG_T1_MP-RAGE_TI800.nii.gz ${outputdir}/${sub}/3D_SAG_T1_MP-RAGE_TI800.nii.gz

#     for session in "s1" "s2"
#     do 
#         analysisdir=${datadir}/${sub}/ge/${session}/nifti
#         mkdir ${outputdir}/${sub}/${session}_REST
#         targetdir=${outputdir}/${sub}/${session}_REST
#         cp ${analysisdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.json ${targetdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.json 
#         cp ${analysisdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz ${targetdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_real.nii.gz 
#         mkdir ${outputdir}/${sub}/${session}_TASK
#         targetdir=${outputdir}/${sub}/${session}_TASK
#         cp ${analysisdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.json ${targetdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.json 
#         cp ${analysisdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz ${targetdir}/NOT_DIAGNOSTIC_\(Raw\)_eASL_7_delays_ACT_real.nii.gz 
#     done
# done

# datadir='/Users/xinzhang/Downloads/mrc_asl_cic/data/repeatability/results'
# outputdir='/Users/xinzhang/Downloads/toYechuan_eASL/prob_roi_byLogan'

# for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
# do 
#     mkdir ${outputdir}/${sub}
#     for session in "s1" "s2"
#     do 
#         for state in "REST" "TASK"
#         do 
#             analysisdir=${datadir}/${sub}/ge_eASL_${session}_${state}
#             mkdir ${outputdir}/${sub}/${session}_${state}
#             targetdir=${outputdir}/${sub}/${session}_${state}
#             cp ${analysisdir}/prob_fl.nii.gz ${targetdir}/prob_fl.nii.gz 
#             cp ${analysisdir}/prob_ol.nii.gz ${targetdir}/prob_ol.nii.gz 
#             cp ${analysisdir}/prob_tl.nii.gz ${targetdir}/prob_tl.nii.gz 
#             cp ${analysisdir}/prob_pl.nii.gz ${targetdir}/prob_pl.nii.gz 
#         done
#     done
# done

datadir='/Users/xinzhang/Downloads/mrc_asl_cic/data'
outputdir='/Users/xinzhang/Downloads/mrc_asl_cic/data/toYechuan_brainmask'

for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10" 
do 
    mkdir ${outputdir}/${sub}
    for session in "s1" "s2"
    do 
        for state in "REST" "TASK"
        do 
            analysisdir=${datadir}/${sub}/ge/${session}/analysis/eASL_${state}
            cp ${analysisdir}/native_space/mask.nii.gz ${outputdir}/${sub}/${session}_${state}_brain_mask.nii.gz
        done
    done
done