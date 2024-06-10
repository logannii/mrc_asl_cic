import json
import logging
import os
import os.path as op
import subprocess
import shutil
import itertools
from glob import glob
import argparse
import bids
import re
import multiprocessing as mp

import numpy as np
import pandas as pd
import nibabel as nib
import regtricks as rt
import qasl_ppr

N = None  # Number of subjects to process
CORES = 1

DO_ANAT = False  # Do fsl_anat step
DO_ASL = True  # Do qasl step, including ROI reporting
DO_PPR = False  # Do predictive modelling step
DO_ROIS = False  # Do ROI reporting
# CONCAT_ROIS = False  # Concatenate ROI stats into a single file

DEBUG = False  # Print stdout to console
OVERWRITE = True  # Overwrite existing output

ROOT = "/share/CBFPredict/SPMIC/DATA"
OUTROOT = op.join(ROOT, "../DERIVATIVES")

GE_RESIZE_FACTOR = [2, 2, 1]

# Predictive models to run
ppr_modelpath = "/share/CBFPredict/TILDA/GLM/conform_cdf_linear_demog/model.h5"


def NiftiJSON(nifti_path):
    json_path = nifti_path.replace(".nii.gz", ".json")
    json_dict = json.load(open(json_path))
    json_dict["nifti_path"] = nifti_path
    json_dict["nifti_fname"] = op.split(nifti_path)[1]
    return json_dict


def call_func(func_arg_tuple):
    assert len(func_arg_tuple) == 2, "func_arg_tuple must be a tuple of length 2"
    func = func_arg_tuple[0]
    func(*func_arg_tuple[1])


def sp_run(cmd):
    try:
        if DEBUG:
            logging.info(f"Running {cmd}")
        subprocess.run(
            cmd,
            shell=True,
            check=True,
            stdout=subprocess.DEVNULL if not DEBUG else None,
        )
    except subprocess.CalledProcessError:
        logging.error(f"CalledProcessError: \n{cmd}\n\n")


def run_anat(sub, ses):

    layout = bids.BIDSLayout(ROOT, validate=False)
    for t1 in layout.get(
        subject=sub, session=ses, datatype="anat", suffix="T1w", extension="nii.gz"
    ):

        out = op.join(OUTROOT, t1.relpath).replace(t1.entities["extension"], "")
        if not op.exists(op.join(out + ".anat", "first_results")) or OVERWRITE:
            logging.info(f"Running fsl_anat on {t1.path}")
            os.makedirs(op.dirname(out), exist_ok=True)
            sp_run(f"fsl_anat -i {t1.path} -o {out} --clobber")
        else:
            logging.info(f"Skipping {out}.anat as it already exists")

        if (
            not op.exists(op.join(out + ".freesurfer", "scripts/recon-all.done"))
            or OVERWRITE
        ):
            logging.info(f"Running freesurfer on {t1.path}")
            shutil.rmtree(op.join(out + ".freesurfer"), ignore_errors=True)
            sp_run(
                f"recon-all -subjid {op.split(out)[1]}.freesurfer -i {t1.path} -all -sd {op.split(out)[0]}"
            )
        else:
            logging.info(f"Skipping {out}.freesurfer as it already exists")


def match_key(key, string):
    x = rf"{key}-[^_]*"
    y = re.search(x, string)
    if y is None:
        return None
    res = y.group(0)
    return res.replace(f"{key}-", "")


def join_keys(key_dict):
    return "_".join([f"{k}-{v}" for k, v in key_dict.items()])


def run_asl(sub, ses):
    """Run qasl on a given scanner, subject and session.

    fsl_anat is required; fieldmaps are optional.
    """

    layout = bids.BIDSLayout(ROOT, validate=False)
    asl_files = layout.get(
        subject=sub,
        session=ses,
        suffix="asl",
        datatype="perf",
        extension="nii.gz",
    )
    for asl in asl_files:
        entities = asl.get_entities()
        acq = entities["acquisition"]
        asl = asl.path

        # If GE3D, concatenate all runs into a single series
        if acq == "GE3D":
            run = match_key("run", op.split(asl)[1])
            task = entities["task"]
            asldir = op.dirname(asl)
            if run == "01":
                all_asl = sorted(
                    glob(op.join(asldir, f"*task-{task}_acq-{acq}_run-*_asl.nii.gz"))
                )
                all_m0 = sorted(
                    glob(op.join(asldir, f"*task-{task}_acq-{acq}_run-*_m0scan.nii.gz"))
                )

                asl_new = op.join(
                    OUTROOT,
                    f"sub-{sub}/ses-{ses}/perf/sub-{sub}_ses-{ses}_task-{task}_acq-{acq}_asl.nii.gz",
                )
                m0_new = op.join(
                    OUTROOT,
                    f"sub-{sub}/ses-{ses}/perf/sub-{sub}_ses-{ses}_task-{task}_acq-{acq}_m0scan.nii.gz",
                )
                logging.info(f"Concatenating ASL into a single series as {asl_new}")
                sp_run(
                    " ".join([
                            f"fslmerge -t {asl_new}",
                            " ".join(f"{asl_run}" for asl_run in all_asl),
                    ])
                )
                logging.info(f"Concatenating M0 into a single series as {m0_new}")
                sp_run(
                    " ".join([
                            f"fslmerge -t {m0_new}",
                            " ".join(f"{m0_run}" for m0_run in all_m0),
                    ])
                )
                # save the new asl, then continue with the pipeline
                asl = asl_new
            else:
                # unless it is NOT GE3D run-01, skip
                logging.info(f"Skipping {asl}")
                continue

        out = op.join(
            OUTROOT,
            f"sub-{sub}/ses-{ses}/perf",
            op.split(asl)[1].replace(".nii.gz", ".qasl"),
        )

        m0 = asl.replace("asl.nii.gz", "m0scan.nii.gz")
        assert op.exists(m0), "M0 scan not found"
        anat_acq = "GE" if acq.count("GE") else "philips"
        anat = op.join(
            OUTROOT,
            f"sub-{sub}/ses-{ses}/anat",
            f"sub-{sub}_ses-{ses}_acq-{anat_acq}_T1w.anat",
        )
        assert op.exists(anat), "fsl_anat not found"

        fsdir = op.join(
            OUTROOT,
            f"sub-{sub}/ses-{ses}/anat",
            f"sub-{sub}_ses-{ses}_acq-{anat_acq}_T1w.freesurfer",
        )
        assert op.exists(fsdir), "fsdir not found"

        # If GE (3D or eASL), resize the in-plane resolution to double the voxel size
        if acq.startswith("GE"):
            asl_orig = nib.load(asl)
            asl_orig_spc = rt.ImageSpace(asl)
            asl_resized_spc = asl_orig_spc.resize_voxels(GE_RESIZE_FACTOR)
            asl_resized = rt.Registration.identity().apply_to_image(asl_orig, asl_resized_spc, order=1)
            asl_resized.to_filename(out.replace(".qasl", ".nii.gz"))

            m0_orig = nib.load(asl.replace("asl.nii.gz", "m0scan.nii.gz"))
            m0_orig_spc = rt.ImageSpace(asl.replace("asl.nii.gz", "m0scan.nii.gz"))
            m0_resized_spc = m0_orig_spc.resize_voxels(GE_RESIZE_FACTOR)
            m0_resized = rt.Registration.identity().apply_to_image(m0_orig, m0_resized_spc, order=1)    
            m0_resized.to_filename(out.replace("asl.qasl", "m0scan.nii.gz"))

        else:
            continue

        # Fieldmap processing for philips2d only
        if acq == "philips2d":
            fmap_hz = layout.get(
                subject=sub,
                session=ses,
                datatype="fmap",
                suffix="fieldmap",
                extension="nii.gz",
            )[0]
            fmap_hz = fmap_hz.path
            fmap_mag = layout.get(
                subject=sub,
                session=ses,
                datatype="fmap",
                suffix="magnitude",
                extension="nii.gz",
            )[0]
            fmap_mag = fmap_mag.path

            fmap_rads = op.join(
                ROOT,
                f"sub-{sub}",
                f"ses-{ses}",
                "fmap",
                f"sub-{sub}_ses-{ses}_acq-{acq}_fieldmaprads.nii.gz",
            )
            fmap_magbrain = op.join(
                ROOT,
                f"sub-{sub}",
                f"ses-{ses}",
                "fmap",
                f"sub-{sub}_ses-{ses}_acq-{acq}_magnitudebrain.nii.gz",
            )
            pedir = "y"
            echospacing = json.load(open(asl.replace("asl.nii.gz", "asl.json")))[
                "EstimatedEffectiveEchoSpacing"
            ]
            logging.info(f"Running fieldmap processing on {fmap_hz}")
            sp_run(f"fslmaths {fmap_hz} -mul 6.28 {fmap_rads}")
            sp_run(f"fugue --loadfmap={fmap_rads} -m --savefmap={fmap_rads}")
            sp_run(f"bet {fmap_mag} {fmap_magbrain}")
            sp_run(f"fslmaths {fmap_magbrain} -ero {fmap_magbrain} ")

        # qasl parameters for each acquisition
        if acq == "philips2d":
            params = {
                "iaf": "ct",
                "ibf": "tis",
                "tis": 3.6,
                "bolus": 1.8,
                "rpts": 30,
                "slicedt": 0.0415,
                "tr": 8,
                "mc": "",
            }
        elif acq == "philips3d":
            params = {
                "iaf": "ct",
                "ibf": "tis",
                "tis": 3.8,
                "bolus": 1.8,
                "rpts": 8,
                "tr": 4.752,
                "deblur": " --deblur-kernel=direct --deblur-method=inference --save-kernel",
                "mc": "",
            }
        elif acq == "GE3D":
            params = {
                "iaf": "diff",
                "ibf": "tis",
                "tis": 3.475,
                "bolus": 1.45,
                "rpts": 5,
                "cgain": 32,
                "alpha": 0.6,
                "tr": 4.764,
                "deblur": " --deblur-kernel=lorentz --lorentz-gamma=5 --deblur-method=inference --save-kernel",
            }
        elif acq == "GEeASL":
            params = {
                "iaf": "diff",
                "ibf": "rpt",
                "tis": "0.922,1.178,1.481,1.853,2.334,3.016,4.199",
                "bolus": "0.222,0.256,0.303,0.372,0.481,0.682,1.183",
                "rpts": 1,
                "cgain": 32,
                "alpha": 0.6,
                "tr": json.load(open(asl.replace("asl.nii.gz", "asl.json")))[
                    "RepetitionTime"
                ],
                "deblur": " --deblur-kernel=lorentz --lorentz-gamma=5 --deblur-method=inference --save-kernel",
            }

        for method in ["_ssvb"]:
            if not op.exists(op.join(out+method, "report")) or OVERWRITE:
                os.makedirs(op.dirname(out+method), exist_ok=True)

                # Turn off deblur for basil, and for philips2d
                if (method == "_basil") and (acq != "philips2d"):
                    params.pop("deblur")

                qasl_cmd = " ".join(
                    [
                        f"qasl -i {asl} -c {m0} --cmethod voxel --casl",
                        f"--fslanat {anat} --debug --overwrite --output-mni --pvcorr",
                        " ".join([f"--{k} {v}" for k, v in params.items()]),
                    ]
                )
                # If ssvb, add inference-method options
                if method == "_ssvb":
                    qasl_cmd += (
                        f" --inference-method ssvb --cores 1 --fsdir {fsdir} --mask-restrict-cortex --harmonise"
                    )

                # If philips, add fieldmap options
                if acq == "philips2d":
                    qasl_cmd += (
                        f" --fmap {fmap_rads} --fmapmag {fmap_mag} --fmapmagbrain {fmap_magbrain}"
                        f" --pedir {pedir} --echospacing {echospacing:.10f}"
                    )

                qasl_cmd += f" -o {out+method}"

                # Run qasl
                logging.info(f"Running qasl{method} on {asl}")
                logging.debug(f"Command: {qasl_cmd}")
                sp_run(qasl_cmd)

            else:
                logging.info(f"Skipping qasl{method} on {asl} as it already exists")


def run_ppr(sub, ses):

    qaslssvb_dirs = sorted(
        glob(op.join(OUTROOT, f"sub-{sub}/ses-{ses}/perf/*.qasl_ssvb"))
    )

    SPMIC_AGE = [39, 27, 26, 22, 26, 30, 29, 23, 22, 21]
    SPMIC_SEX = ["F", "M", "M", "M", "F", "F", "M", "M", "M", "M"]

    model = qasl_ppr.load_model(ppr_modelpath)

    for qaslssvb_dir in qaslssvb_dirs:
        logging.info(f"Running predictive modelling on {qaslssvb_dir}")
        qasl_ppr.run_prediction(qdir=qaslssvb_dir, model=model, age=SPMIC_AGE[int(sub)-1], sex=SPMIC_SEX[int(sub)-1], debug=True)


def run_roi_stats(sub, ses):
    """Run qasl_region_analysis on qasl outputs"""

    qasl_dirs = sorted(
        glob(op.join(OUTROOT, f"sub-{sub}/ses-{ses}/perf/*.qasl*"))
    )

    innames = [
        "output/native/perfusion.nii.gz",
        "output/native/calib_voxelwise/perfusion.nii.gz",
        "output_pvcorr/native/perfusion.nii.gz",
        "output_pvcorr/native/calib_voxelwise/perfusion.nii.gz",
    ]

    outnames = [
        "perf",
        "perf_calib",
        "perf_pvec",
        "perf_calib_pvec",
    ]

    for qasl_dir in qasl_dirs:
        logging.info(f"Running ROI stats on {qasl_dir}")
        os.makedirs(op.join(qasl_dir, "roi_stats"), exist_ok=True)
        acq = match_key("acq", op.basename(qasl_dir))
        acq = "GE" if acq.startswith("GE") else "philips"
        fsdir = op.join(OUTROOT, f"sub-{sub}/ses-{ses}/anat/sub-{sub}_ses-{ses}_acq-{acq}_T1w.freesurfer")

        if op.exists(op.join(qasl_dir, "ppr")):
            innames += [
                "ppr/native/prediction.nii.gz",
                "ppr/native/perfusion-prediction.nii.gz",
                "ppr/native/harmonised/prediction.nii.gz",
                "ppr/native/harmonised/perfusion-prediction.nii.gz",
            ]
            outnames += [
                "ppr_pred",
                "ppr_diff", 
                "ppr_harm_pred",
                "ppr_harm_diff",
            ]
        
        if op.exists(op.join(qasl_dir, "ssvb")):
            innames += [
                "output/native/harmonised/perfusion.nii.gz",
                "output/native/calib_voxelwise/harmonised/perfusion.nii.gz",
                "output_pvcorr/native/harmonised/perfusion.nii.gz", 
                "output_pvcorr/native/calib_voxelwise/harmonised/perfusion.nii.gz",
            ]
            outnames += [
                "perf_harm",
                "perf_calib_harm",
                "perf_pvec_harm",
                "perf_calib_pvec_harm",
            ]
        
        # Run qasl_region_analysis
        for inname, outname in zip(innames, outnames):
            perf_path = op.join(qasl_dir, inname)
            out_path = op.join(qasl_dir, "roi_stats", outname)
            cmd = (
                " ".join([
                    f"qasl_region_analysis --qasl-dir {qasl_dir} --perfusion {perf_path} -o {out_path}",
                    "--region-analysis --save-asl-rois --save-struct-rois --save-std-rois",
                ])
            )
            logging.debug(f"Command for qasl_region_analysis: {cmd}")
            sp_run(cmd)

        # Run freesurfer reporting
        if op.exists(op.join(qasl_dir, "ssvb")):
            cmd = (
                f"qasl_fs_report --qdir {qasl_dir} --fsdir {fsdir}"
            )
            logging.debug(f"Command for qasl_fs_report: {cmd}")
            sp_run(cmd)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--cores", type=int, default=CORES, help="number of CPU cores to use"
    )
    args = parser.parse_args()

    logging.basicConfig(
        level=logging.INFO,
        format="%(asctime)s [%(levelname)s] %(message)s",
        handlers=[
            logging.FileHandler("spmic.log"),
            logging.StreamHandler(),
        ],
    )

    logging.info("Preprocessing SPMIC dataset")
    logging.info(f"Root directory: {ROOT}")
    logging.info(f"Output directory: {OUTROOT}")
    logging.info(f"Number of cores: {args.cores}")
    os.makedirs(OUTROOT, exist_ok=True)

    layout = bids.BIDSLayout(ROOT, validate=False)
    sub_ses = [
        (sub, ses)
        for sub in itertools.islice(layout.get_subjects(), N)
        for ses in layout.get_sessions(subject=sub)
    ]
    logging.info(f"Found {len(sub_ses)} subject-session pairs")

    for flag, func in zip(
        [DO_ANAT, DO_ASL, DO_PPR, DO_ROIS],
        [run_anat, run_asl, run_ppr, run_roi_stats],
    ):
        if not flag:
            continue
        jobs = []
        for sub, ses in sub_ses:
            if flag:
                jobs.append((func, (sub, ses)))

        if args.cores == 1:
            for job in jobs:
                call_func(job)
        else:
            with mp.Pool(args.cores) as pool:
                pool.map(call_func, jobs)


    logging.info("DONE")
