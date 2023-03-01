#!/usr/bin/zsh

datadir="/Users/xinzhang/Downloads/mrc_asl_cic/data"
outputdir="/Users/xinzhang/Downloads/mrc_asl_cic/output"

cd ${datadir}
mkdir detectability
cd ${datadir}/detectability

mkdir subALL

fslmerge -t subALL/ge_3D_s1_cbf_wb_nopvc $(ls ${datadir}/repeatability/results/*/ge_3D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_3D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ge_3D_s2_cbf_wb_nopvc $(ls ${datadir}/repeatability/results/*/ge_3D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_3D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ge_3D_sALL_cbf_wb_nopvc $(ls ${datadir}/repeatability/results/*/ge_3D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_3D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_3D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_3D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 

fslmerge -t subALL/ge_eASL_s1_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ge_eASL_s2_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ge_eASL_sALL_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_TASK/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ge_eASL_s1_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ge_eASL_s2_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ge_eASL_sALL_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s1_TASK/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ge_eASL_s2_TASK/cbf_wb_pvc_mni.nii.gz) 

fslmerge -t subALL/ing_2D_s1_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_2D_s2_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_2D_sALL_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_2D_s1_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s1_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ing_2D_s2_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ing_2D_sALL_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_2D_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s1_TASK/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_2D_s2_TASK/cbf_wb_pvc_mni.nii.gz) 

fslmerge -t subALL/ing_3D_s1_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_3D_s2_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_3D_sALL_cbf_wb_nopvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s1_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_REST/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s1_TASK/cbf_wb_nopvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_TASK/cbf_wb_nopvc_mni.nii.gz) 
fslmerge -t subALL/ing_3D_s1_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s1_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ing_3D_s2_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_TASK/cbf_wb_pvc_mni.nii.gz) 
fslmerge -t subALL/ing_3D_sALL_cbf_wb_pvc.nii.gz $(ls ${datadir}/repeatability/results/*/ing_3D_s1_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_REST/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s1_TASK/cbf_wb_pvc_mni.nii.gz) $(ls ${datadir}/repeatability/results/*/ing_3D_s2_TASK/cbf_wb_pvc_mni.nii.gz) 

mkdir design
for state in "REST" "TASK"
do 
    contrast=""
    if [ "$state" = "REST" ]; then
        contrast="${contrast}-1 "
    elif [ "$state" = "TASK" ]; then
        contrast="${contrast}1 "
    fi
    for subno in 1 2 3 4 5 6 7 ; do contrast="${contrast}0 " ; done
    echo $contrast >> design/contrast.txt
    for session in "s1" "s2"
    do 
        i=0
        for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07"
        do  
            i=$(( i+1 ))
            design=""
            design_all=""
            if [ "$state" = "REST" ]; then
                if [ "$session" = "s1" ]; then
                    echo $i >> design/group.txt
                    echo $i >> design/group_all.txt
                    design="${design}-1 "
                    design_all="${design_all}-1 -1 "
                elif [ "$session" = "s2" ]; then
                    echo $i >> design/group_all.txt
                    design_all="${design_all}-1 1 "
                fi
            elif [ "$state" = "TASK" ]; then
                if [ "$session" = "s1" ]; then
                    echo $i >> design/group.txt
                    echo $i >> design/group_all.txt
                    design="${design}1 "
                    design_all="${design_all}1 -1 "
                elif [ "$session" = "s2" ]; then
                    echo $i >> design/group_all.txt
                    design_all="${design_all}1 1 "
                fi
            fi
            for subno in 1 2 3 4 5 6 7
            do
                if [ "$subno" = "$i" ]; then
                    design="${design}1 "
                    design_all="${design_all}1 "
                elif [ "$subno" != "$i" ]; then
                    design="${design}0 "
                    design_all="${design_all}0 "
                fi
            done # for subno in 1 2 3 4 5 6 7
            if [ "$session" = "s1" ]; then echo $design >> design/design.txt ; fi
            echo $design_all >> design/design_all.txt
        done # for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07"
    done # for state in "REST" "TASK"
done # for session in "s1" "s2"
Text2Vest design/design.txt design/design.mat 
Text2Vest design/design_all.txt design/design_all.mat 
Text2Vest design/group.txt design/design.grp
Text2Vest design/group_all.txt design/design_all.grp
Text2Vest design/contrast.txt design/design.con
Text2Vest design/contrast.txt design/design_all.con

mkdir flameout 
mkdir randomiseout 

# GE 3D Protocol
flameo --cope=subALL/ge_3D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_3D_s1_nopvc 
mkdir randomiseout/ge_3D_s1_nopvc 
randomise -i subALL/ge_3D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_3D_s1_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_3D_s1_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_3D_s1_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_3D_s1_nopvc 

flameo --cope=subALL/ge_3D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_3D_s2_nopvc 
mkdir randomiseout/ge_3D_s2_nopvc 
randomise -i subALL/ge_3D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_3D_s2_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_3D_s2_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_3D_s2_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_3D_s2_nopvc 

flameo --cope=subALL/ge_3D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ge_3D_sALL_nopvc 
mkdir randomiseout/ge_3D_sALL_nopvc 
randomise -i subALL/ge_3D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_3D_sALL_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_3D_sALL_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_3D_sALL_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_3D_sALL_nopvc 

# GE eASL Protocol 
flameo --cope=subALL/ge_eASL_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_eASL_s1_nopvc 
mkdir randomiseout/ge_eASL_s1_nopvc 
randomise -i subALL/ge_eASL_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_s1_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_s1_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_s1_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_s1_nopvc 

flameo --cope=subALL/ge_eASL_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_eASL_s1_pvc 
mkdir randomiseout/ge_eASL_s1_pvc 
randomise -i subALL/ge_eASL_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_s1_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_s1_pvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_s1_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_s1_pvc 

flameo --cope=subALL/ge_eASL_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_eASL_s2_nopvc 
mkdir randomiseout/ge_eASL_s2_nopvc 
randomise -i subALL/ge_eASL_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_s2_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_s2_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_s2_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_s2_nopvc 

flameo --cope=subALL/ge_eASL_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ge_eASL_s2_pvc 
mkdir randomiseout/ge_eASL_s2_pvc 
randomise -i subALL/ge_eASL_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_s2_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_s2_pvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_s2_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_s2_pvc 

flameo --cope=subALL/ge_eASL_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ge_eASL_sALL_nopvc 
mkdir randomiseout/ge_eASL_sALL_nopvc 
randomise -i subALL/ge_eASL_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_sALL_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_sALL_nopvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_sALL_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_sALL_nopvc 

flameo --cope=subALL/ge_eASL_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ge_eASL_sALL_pvc 
mkdir randomiseout/ge_eASL_sALL_pvc 
randomise -i subALL/ge_eASL_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ge_eASL_sALL_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ge_eASL_sALL_pvc 
mv r_tstat2.nii.gz randomiseout/ge_eASL_sALL_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ge_eASL_sALL_pvc 

# Ing 2D Protocol 
flameo --cope=subALL/ing_2D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_2D_s1_nopvc 
mkdir randomiseout/ing_2D_s1_nopvc 
randomise -i subALL/ing_2D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_s1_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_s1_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_s1_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_s1_nopvc 

flameo --cope=subALL/ing_2D_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_2D_s1_pvc 
mkdir randomiseout/ing_2D_s1_pvc 
randomise -i subALL/ing_2D_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_s1_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_s1_pvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_s1_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_s1_pvc 

flameo --cope=subALL/ing_2D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_2D_s2_nopvc 
mkdir randomiseout/ing_2D_s2_nopvc 
randomise -i subALL/ing_2D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_s2_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_s2_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_s2_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_s2_nopvc 

flameo --cope=subALL/ing_2D_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_2D_s2_pvc 
mkdir randomiseout/ing_2D_s2_pvc 
randomise -i subALL/ing_2D_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_s2_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_s2_pvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_s2_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_s2_pvc 

flameo --cope=subALL/ing_2D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ing_2D_sALL_nopvc 
mkdir randomiseout/ing_2D_sALL_nopvc 
randomise -i subALL/ing_2D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_sALL_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_sALL_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_sALL_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_sALL_nopvc 

flameo --cope=subALL/ing_2D_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ing_2D_sALL_pvc 
mkdir randomiseout/ing_2D_sALL_pvc 
randomise -i subALL/ing_2D_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_2D_sALL_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_2D_sALL_pvc 
mv r_tstat2.nii.gz randomiseout/ing_2D_sALL_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_2D_sALL_pvc 

# Ing 3D Protocol
flameo --cope=subALL/ing_3D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_3D_s1_nopvc 
mkdir randomiseout/ing_3D_s1_nopvc 
randomise -i subALL/ing_3D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_s1_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_s1_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_s1_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_s1_nopvc 

flameo --cope=subALL/ing_3D_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_3D_s1_pvc 
mkdir randomiseout/ing_3D_s1_pvc 
randomise -i subALL/ing_3D_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_s1_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_s1_pvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_s1_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_s1_pvc 

flameo --cope=subALL/ing_3D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_3D_s2_nopvc 
mkdir randomiseout/ing_3D_s2_nopvc 
randomise -i subALL/ing_3D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_s2_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_s2_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_s2_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_s2_nopvc 

flameo --cope=subALL/ing_3D_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design.grp --runmode=ols --ld=flameout/ing_3D_s2_pvc 
mkdir randomiseout/ing_3D_s2_pvc 
randomise -i subALL/ing_3D_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design.mat -t design/design.con -e design/design.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_s2_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_s2_pvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_s2_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_s2_pvc 

flameo --cope=subALL/ing_3D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ing_3D_sALL_nopvc 
mkdir randomiseout/ing_3D_sALL_nopvc 
randomise -i subALL/ing_3D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_sALL_nopvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_sALL_nopvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_sALL_nopvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_sALL_nopvc 

flameo --cope=subALL/ing_3D_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_all.grp --runmode=ols --ld=flameout/ing_3D_sALL_pvc 
mkdir randomiseout/ing_3D_sALL_pvc 
randomise -i subALL/ing_3D_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d design/design_all.mat -t design/design_all.con -e design/design_all.grp -T 
mv r_tstat1.nii.gz randomiseout/ing_3D_sALL_pvc 
mv r_tfce_corrp_tstat1.nii.gz randomiseout/ing_3D_sALL_pvc 
mv r_tstat2.nii.gz randomiseout/ing_3D_sALL_pvc 
mv r_tfce_corrp_tstat2.nii.gz randomiseout/ing_3D_sALL_pvc 
