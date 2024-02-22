#!/usr/bin/zsh

# rootdir=/Users/xinzhang/Downloads/mrc_asl_cic
datadir=$rootdir/data
outputdir=$rootdir/output

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
    contrast_all=""
    if [ "$state" = "REST" ]; then
        contrast="${contrast}-1 "
        contrast_all="${contrast_all}-1 0 "
    elif [ "$state" = "TASK" ]; then
        contrast="${contrast}1 "
        contrast_all="${contrast_all}1 0 "
    fi
    for subno in 1 2 3 4 5 6 7 8 9 10 ; do contrast="${contrast}0 " ; contrast_all="${contrast_all}0 " ; done
    echo $contrast >> design/contrast.txt
    echo $contrast_all >> design/contrast_all.txt
    for session in "s1" "s2"
    do 
        i=0
        for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10"
        do  
            i=$(( i+1 ))
            design=""
            design_all=""
            if [ "$state" = "REST" ]; then
                if [ "$session" = "s1" ]; then
                    echo 1 >> design/group_flame.txt
                    echo 1 >> design/group_flame_all.txt
                    echo $i >> design/group.txt
                    echo $i >> design/group_all.txt
                    design="${design}-1 "
                    design_all="${design_all}-1 -1 "
                elif [ "$session" = "s2" ]; then
                    echo 1 >> design/group_flame_all.txt
                    echo $i >> design/group_all.txt
                    design_all="${design_all}-1 1 "
                fi
            elif [ "$state" = "TASK" ]; then
                if [ "$session" = "s1" ]; then
                    echo 1 >> design/group_flame.txt
                    echo 1 >> design/group_flame_all.txt
                    echo $i >> design/group.txt
                    echo $i >> design/group_all.txt
                    design="${design}1 "
                    design_all="${design_all}1 -1 "
                elif [ "$session" = "s2" ]; then
                    echo 1 >> design/group_flame_all.txt
                    echo $i >> design/group_all.txt
                    design_all="${design_all}1 1 "
                fi
            fi
            for subno in 1 2 3 4 5 6 7 8 9 10
            do
                if [ "$subno" = "$i" ]; then
                    design="${design}1 "
                    design_all="${design_all}1 "
                elif [ "$subno" != "$i" ]; then
                    design="${design}0 "
                    design_all="${design_all}0 "
                fi
            done # for subno in 1 2 3 4 5 6 7 8 9 10
            if [ "$session" = "s1" ]; then echo $design >> design/design.txt ; fi
            echo $design_all >> design/design_all.txt
        done # for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07" "sub08" "sub09" "sub10"
    done # for state in "REST" "TASK"
done # for session in "s1" "s2"
Text2Vest design/design.txt design/design.mat 
Text2Vest design/design_all.txt design/design_all.mat 
Text2Vest design/group_flame.txt design/design_flame.grp
Text2Vest design/group_flame_all.txt design/design_flame_all.grp
Text2Vest design/group.txt design/design.grp
Text2Vest design/group_all.txt design/design_all.grp
Text2Vest design/contrast.txt design/design.con
Text2Vest design/contrast_all.txt design/design_all.con

mkdir flameout 
mkdir randomiseout 

# GE 3D Protocol
flameo --cope=subALL/ge_3D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_3D_s1_nopvc 
mkdir randomiseout/ge_3D_s1_nopvc 
cd randomiseout/ge_3D_s1_nopvc 
randomise -i ../../subALL/ge_3D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_3D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_3D_s2_nopvc 
mkdir randomiseout/ge_3D_s2_nopvc 
cd randomiseout/ge_3D_s2_nopvc 
randomise -i ../../subALL/ge_3D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_3D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ge_3D_sALL_nopvc 
mkdir randomiseout/ge_3D_sALL_nopvc 
cd randomiseout/ge_3D_sALL_nopvc 
randomise -i ../../subALL/ge_3D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

# GE eASL Protocol 
flameo --cope=subALL/ge_eASL_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_eASL_s1_nopvc 
mkdir randomiseout/ge_eASL_s1_nopvc 
cd randomiseout/ge_eASL_s1_nopvc 
randomise -i ../../subALL/ge_eASL_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_eASL_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_eASL_s1_pvc 
mkdir randomiseout/ge_eASL_s1_pvc 
cd randomiseout/ge_eASL_s1_pvc 
randomise -i ../../subALL/ge_eASL_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_eASL_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_eASL_s2_nopvc 
mkdir randomiseout/ge_eASL_s2_nopvc 
cd randomiseout/ge_eASL_s2_nopvc 
randomise -i ../../subALL/ge_eASL_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_eASL_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ge_eASL_s2_pvc 
mkdir randomiseout/ge_eASL_s2_pvc 
cd randomiseout/ge_eASL_s2_pvc 
randomise -i ../../subALL/ge_eASL_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_eASL_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ge_eASL_sALL_nopvc 
mkdir randomiseout/ge_eASL_sALL_nopvc 
cd randomiseout/ge_eASL_sALL_nopvc 
randomise -i ../../subALL/ge_eASL_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ge_eASL_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ge_eASL_sALL_pvc 
mkdir randomiseout/ge_eASL_sALL_pvc 
cd randomiseout/ge_eASL_sALL_pvc 
randomise -i ../../subALL/ge_eASL_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

# Ing 2D Protocol 
flameo --cope=subALL/ing_2D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_2D_s1_nopvc 
mkdir randomiseout/ing_2D_s1_nopvc 
cd randomiseout/ing_2D_s1_nopvc 
randomise -i ../../subALL/ing_2D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_2D_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_2D_s1_pvc 
mkdir randomiseout/ing_2D_s1_pvc 
cd randomiseout/ing_2D_s1_pvc 
randomise -i ../../subALL/ing_2D_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_2D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_2D_s2_nopvc 
mkdir randomiseout/ing_2D_s2_nopvc 
cd randomiseout/ing_2D_s2_nopvc 
randomise -i ../../subALL/ing_2D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_2D_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_2D_s2_pvc 
mkdir randomiseout/ing_2D_s2_pvc 
cd randomiseout/ing_2D_s2_pvc 
randomise -i ../../subALL/ing_2D_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_2D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ing_2D_sALL_nopvc 
mkdir randomiseout/ing_2D_sALL_nopvc 
cd randomiseout/ing_2D_sALL_nopvc 
randomise -i ../../subALL/ing_2D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_2D_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ing_2D_sALL_pvc 
mkdir randomiseout/ing_2D_sALL_pvc 
cd randomiseout/ing_2D_sALL_pvc 
randomise -i ../../subALL/ing_2D_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

# Ing 3D Protocol
flameo --cope=subALL/ing_3D_s1_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_3D_s1_nopvc 
mkdir randomiseout/ing_3D_s1_nopvc 
cd randomiseout/ing_3D_s1_nopvc 
randomise -i ../../subALL/ing_3D_s1_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_3D_s1_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_3D_s1_pvc 
mkdir randomiseout/ing_3D_s1_pvc 
cd randomiseout/ing_3D_s1_pvc 
randomise -i ../../subALL/ing_3D_s1_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_3D_s2_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_3D_s2_nopvc 
mkdir randomiseout/ing_3D_s2_nopvc 
cd randomiseout/ing_3D_s2_nopvc 
randomise -i ../../subALL/ing_3D_s2_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_3D_s2_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design.mat --tc=design/design.con --cs=design/design_flame.grp --runmode=ols --ld=flameout/ing_3D_s2_pvc 
mkdir randomiseout/ing_3D_s2_pvc 
cd randomiseout/ing_3D_s2_pvc 
randomise -i ../../subALL/ing_3D_s2_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design.mat -t ../../design/design.con -e ../../design/design.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_3D_sALL_cbf_wb_nopvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ing_3D_sALL_nopvc 
mkdir randomiseout/ing_3D_sALL_nopvc 
cd randomiseout/ing_3D_sALL_nopvc 
randomise -i ../../subALL/ing_3D_sALL_cbf_wb_nopvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../

flameo --cope=subALL/ing_3D_sALL_cbf_wb_pvc.nii.gz --mask=${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz --dm=design/design_all.mat --tc=design/design_all.con --cs=design/design_flame_all.grp --runmode=ols --ld=flameout/ing_3D_sALL_pvc 
mkdir randomiseout/ing_3D_sALL_pvc 
cd randomiseout/ing_3D_sALL_pvc 
randomise -i ../../subALL/ing_3D_sALL_cbf_wb_pvc.nii.gz -o r -m ${FSLDIR}/data/standard/MNI152_T1_2mm_brain_mask.nii.gz -d ../../design/design_all.mat -t ../../design/design_all.con -e ../../design/design_all.grp -T -R --uncorrp
cd ../../
