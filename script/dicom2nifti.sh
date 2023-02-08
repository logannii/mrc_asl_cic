#!/usr/bin/env bash

datadir="/Users/xinzhang/Downloads/mrc_asl_cic/data"
outputdir="/Users/xinzhang/Downloads/mrc_asl_cic/output"

for sub in "sub01" "sub02" "sub03" "sub04" "sub05" "sub06" "sub07"
do
    for scanner in "ge" "ing"
    do 
        for session in "s1" "s2"
        do 
            cd $datadir"/"$sub"/"$scanner"/"$session
            mkdir nifti
            dcm2niix -o nifti -f %d -g i -z y dicom >> $outputdir"/log_dicom2nifti.txt"
            rm -r dicom
        done
    done
done