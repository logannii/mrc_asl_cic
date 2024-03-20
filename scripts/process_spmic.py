import json
import logging
import os
import os.path as op
import subprocess
import shutil
import itertools
from glob import glob
from io import StringIO
import argparse
import bids
import re
import multiprocessing as mp

import numpy as np
import pandas as pd
import nibabel as nib
import regtricks as rt

N = None  # Number of subjects to process
CORES = 1

DO_ANAT = False  # Do fsl_anat step
DO_ASL = False  # Do oxasl step, including ROI reporting
DO_PREDICTION = False  # Do predictive modelling step
DO_ROIS = False  # Do ROI reporting
CONCAT_ROIS = True  # Concatenate ROI stats into a single file

DEBUG = False  # Print stdout to console
OVERWRITE = False  # Overwrite existing output

ROOT = "/share/CBFPredict/SPMIC/DATA"
OUTROOT = op.join(ROOT, "../DERIVATIVES")

# Predictive models to run
PPR_MODELS = ["uncalib_norm_pv", "uncalib_norm_nonpv"]


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


def calc_norm_factor(oxdir):
    # Load oxasl perfusion map and GM PVs
    # Load freesurfer ctx mask
    # Calculate mean perfusion in ctx mask
    sub = match_key("sub", op.basename(oxdir))
    ses = match_key("ses", op.basename(oxdir))
    acq = match_key("acq", op.basename(oxdir))[:2] # GE or ph
    fsdir = op.join(
        OUTROOT,
        f"sub-{sub}",
        f"ses-{ses}",
        f"anat/sub-{sub}_ses-{ses}_acq-{acq}*.freesurfer",
    )

    perf = op.join(oxdir, "output/struc/perfusion.nii.gz")
    pvgm = nib.load(op.join(oxdir, "structural/gm_pv.nii.gz")).get_fdata()
    ribbon_mgz = op.join(fsdir, "mri", "ribbon.mgz")
    ribbon_nii = rt.Registration.identity().apply_to_image(glob(ribbon_mgz)[0], perf, order=1)

    perf = nib.load(perf).get_fdata()
    mask = (pvgm > 0.5) & (ribbon_nii.get_fdata() > 0)
    return perf[mask].mean()


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
    """Run oxasl on a given scanner, subject and session.

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

        if acq == "GE3D":
            # TODO Logan when we work out what to do with GE3D
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
                # TODO Logan: undo the WP quantification, concat the ASL into a series, concat the M0
                # Save them as a derivative and run oxasl on that ]
                asl_new = op.join(
                    OUTROOT,
                    f"sub-{sub}",
                    f"ses-{ses}",
                    "perf",
                    f"sub-{sub}_ses-{ses}_task-{task}_acq-{acq}_asl.nii.gz",
                )
                m0_new = op.join(
                    OUTROOT,
                    f"sub-{sub}",
                    f"ses-{ses}",
                    "perf",
                    f"sub-{sub}_ses-{ses}_task-{task}_acq-{acq}_m0scan.nii.gz",
                )
                logging.info(f"Concatenating ASL into a single series as {asl_new}")
                sp_run(
                    " ".join(
                        [
                            f"fslmerge -t {asl_new}",
                            " ".join(f"{asl_run}" for asl_run in all_asl),
                        ]
                    )
                )
                logging.info(f"Concatenating M0 into a single series as {m0_new}")
                sp_run(
                    " ".join(
                        [
                            f"fslmerge -t {m0_new}",
                            " ".join(f"{m0_run}" for m0_run in all_m0),
                        ]
                    )
                )
                # save the new asl, then continue with the pipeline
                asl = asl_new
            else:
                # unless it is NOT GE3D run-01, skip
                logging.info(f"Skipping {asl}")
                continue

        out = op.join(
            OUTROOT,
            f"sub-{sub}",
            f"ses-{ses}",
            "perf",
            op.split(asl)[1].replace(".nii.gz", ".oxasl"),
        )

        m0 = asl.replace("asl.nii.gz", "m0scan.nii.gz")
        assert op.exists(m0), "M0 scan not found"
        anat_acq = "GE" if acq.count("GE") else "philips"
        anat = op.join(
            OUTROOT,
            f"sub-{sub}",
            f"ses-{ses}",
            "anat",
            f"sub-{sub}_ses-{ses}_acq-{anat_acq}_T1w.anat",
        )
        assert op.exists(anat), "fsl_anat not found"

        # with open(asl.replace("asl.nii.gz", "aslcontext.tsv"), "r") as f:
        #     ctx = f.readlines()
        #     order = "".join([c[0] for c in ctx])
        #     iaf = order[:2].replace("l", "t")
        #     if iaf == "dd":
        #         iaf = "diff"
        #     if acq == "GE3D":
        #         iaf = "diff"

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

        if acq == "philips2d":
            params = {
                "iaf": "ct",
                "ibf": "tis",
                "tis": 3.6,
                "bolus": 1.8,
                "rpts": 30,
                "slicedt": 0.0415,
                "tr": 8,
            }

        elif acq == "philips3d":
            params = {
                "iaf": "ct",
                "ibf": "tis",
                "tis": 3.8,
                "bolus": 1.8,
                "rpts": 8,
                "tr": 4.752,
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
            }

        elif acq == "GEeASL":
            params = {
                "iaf": "diff",
                "ibf": "rpt",
                "tis": "4.199,3.016,2.334,1.853,1.481,1.178,0.922",
                "bolus": "1.183,0.682,0.481,0.372,0.303,0.256,0.222",
                "rpts": 1,
                "cgain": 32,
                "alpha": 0.6,
                "tr": json.load(open(asl.replace("asl.nii.gz", "asl.json")))[
                    "RepetitionTime"
                ],
            }

        if not op.exists(op.join(out, "output/native/perfusion.nii.gz")) or OVERWRITE:
            os.makedirs(op.dirname(out), exist_ok=True)
            oxasl_cmd = " ".join(
                [
                    f"oxasl -i {asl} -c {m0} --cmethod voxel --casl --fixbolus",
                    # f"--iaf {iaf}",
                    f"--fslanat {anat} --debug --overwrite --mc",
                    f"--pvcorr",
                    " ".join([f"--{k} {v}" for k, v in params.items()]),
                ]
            )

            # If philips, add fieldmap options
            if acq == "philips2d":
                oxasl_cmd += (
                    f" --fmap {fmap_rads} --fmapmag {fmap_mag} --fmapmagbrain {fmap_magbrain} "
                    f" --pedir {pedir} --echospacing {echospacing:.10f}"
                )

            # Run normal oxasl
            logging.info(f"Running oxasl on {asl}")
            sp_run(oxasl_cmd + f" -o {out}")

            # Run oxasl with deblurring
            logging.info(f"Running oxasl with deblurring on {asl}")
            oxasl_cmd_deblur = oxasl_cmd + " --deblur --kernel=direct --method=fft"
            sp_run(oxasl_cmd_deblur + f" -o {out}_deblur")

        else:
            logging.info(f"Skipping oxasl on {asl} as it already exists")


def run_predictive_modelling(sub, ses):

    oxasl_dirs = sorted(
        glob(op.join(OUTROOT, f"sub-{sub}", f"ses-{ses}", "perf/*.oxasl*"))
    )

    SPMIC_AGE = [39, 27, 26, 22, 26, 30, 29, 23, 22, 21]
    SPMIC_GENDER = [2, 1, 1, 1, 2, 2, 1, 1, 1, 1]
    gender, age = SPMIC_AGE[int(sub)-1], SPMIC_GENDER[int(sub)-1]
    TILDA_AGE_MEAN = 67.64
    age_demeaned = age - TILDA_AGE_MEAN
    gender_adj = gender - 1

    for oxdir in oxasl_dirs:
        logging.info(f"Running predictive modelling in {oxdir}")

        norm_factor = calc_norm_factor(oxdir)
        pvgm = op.join(oxdir, "structural/gm_pv_asl.nii.gz")
        pvwm = op.join(oxdir, "structural/wm_pv_asl.nii.gz")

        native_spc = rt.ImageSpace(op.join(oxdir, "reg/aslref.nii.gz"))
        std_spc = op.join(oxdir, "reg/stdref.nii.gz")
        std2struct = rt.NonLinearRegistration.from_fnirt(
            op.join(oxdir, "reg/std2struc.nii.gz"),
            src=std_spc,
            ref=op.join(oxdir, "reg/strucref.nii.gz"),
            intensity_correct=False,
        )
        struct2asl = rt.Registration.from_flirt(
            op.join(oxdir, "reg/struc2asl.mat"),
            src=op.join(oxdir, "reg/strucref.nii.gz"),
            ref=native_spc,
        )
        std2asl = rt.chain(std2struct, struct2asl)

        for model in PPR_MODELS:
            outdir = op.join(oxdir, "ppr", model)
            os.makedirs(outdir, exist_ok=True)

            # beta_params = ["const", "age", "sex", "pvgm", "pvgma", "pvgms", "pvwm", "pvwma", "pvwms"]
            beta_std = nib.load(
                op.join(ROOT, "../PPR", model, "beta_params_avg.nii.gz")
            ).get_fdata()
            beta_asl = std2asl.apply_to_array(beta_std, std_spc, native_spc, cores=1)
            native_spc.save_image(beta_asl, op.join(outdir, "beta_params_asl.nii.gz"))

            prediction = (
                beta_asl[..., 0]
                + beta_asl[..., 1] * age_demeaned
                + beta_asl[..., 2] * gender_adj
                + (
                    beta_asl[..., 3]
                    + beta_asl[..., 4] * age_demeaned
                    + beta_asl[..., 5] * gender_adj
                )
                * nib.load(pvgm).get_fdata()
                + (
                    beta_asl[..., 6]
                    + beta_asl[..., 7] * age_demeaned
                    + beta_asl[..., 8] * gender_adj
                )
                * nib.load(pvwm).get_fdata()
            )
            native_spc.save_image(prediction, op.join(outdir, "prediction.nii.gz"))

            truth_asl = (
                nib.load(op.join(oxdir, "output/native/perfusion.nii.gz")).get_fdata()
                / norm_factor
            )
            native_spc.save_image(truth_asl, op.join(outdir, "truth.nii.gz"))

            residual = truth_asl - prediction
            native_spc.save_image(residual, op.join(outdir, "residuals.nii.gz"))


# From each oxasl, use the non-PVEc and PVEc GM perfusion maps (x2)
# For each oxasl, N models have been run, each of which produce a prediction and residuals map (N x 2)
# Run mri_segstats and oxasl_region_analysis on each of these inputs
ROI_IN_NAMES = [
    "output/native/perfusion.nii.gz",
    "output_pvcorr/native/perfusion.nii.gz",
    *[f"ppr/{m}/prediction.nii.gz" for m in PPR_MODELS],
    *[f"ppr/{m}/residuals.nii.gz" for m in PPR_MODELS],
]
ROI_OUT_NAMES = [
    "perfusion_roi_stats",
    "perfusion_gm_roi_stats",
    *[f"prediction_{m}_roi_stats" for m in PPR_MODELS],
    *[f"residuals_{m}_roi_stats" for m in PPR_MODELS],
]


def run_roi_analysis(sub, ses):
    """Run ROI stats on oxasl output"""

    oxasl_dirs = sorted(
        glob(op.join(OUTROOT, f"sub-{sub}", f"ses-{ses}", "perf/*.oxasl*"))
    )

    for oxdir in oxasl_dirs:
        logging.info(f"Running roi analysis in {oxdir}")

        acq = match_key("acq", op.basename(oxdir))
        if acq.startswith("GE"):
            acq = "GE"
        if acq.startswith("philips"):
            acq = "philips"
        fsdir = op.join(
            OUTROOT,
            f"sub-{sub}",
            f"ses-{ses}",
            f"anat/sub-{sub}_ses-{ses}_acq-{acq}_T1w.freesurfer",
        )

        oxout = op.join(oxdir, "ox_roi_stats")
        fsout = op.join(oxdir, "fs_roi_stats")
        os.makedirs(fsout, exist_ok=True)

        aparc = op.join(fsdir, "mri/aparc+aseg.mgz")
        asl2struct = rt.Registration.from_flirt(
            op.join(oxdir, "reg", "asl2struc.mat"),
            src=op.join(oxdir, "reg", "aslref.nii.gz"),
            ref=op.join(oxdir, "reg", "strucref.nii.gz"),
        )
        shutil.copy(aparc, op.join(fsout, "aparc+aseg.mgz"))

        for inname, outname in zip(ROI_IN_NAMES, ROI_OUT_NAMES):
            # oxasl ROI stats
            inpath = op.join(oxdir, inname)
            outpath = op.join(oxout, outname)
            cmd = (
                f"oxasl_region_analysis --oxasl-dir {oxdir} --perfusion {inpath} -o {outpath} "
                f"--region-analysis --save-asl-rois --save-struct-rois"
            )
            sp_run(cmd)

            # FS ROI stats
            # transform map into aparc space first
            x = asl2struct.apply_to_image(op.join(oxdir, inname), ref=aparc, order=1)
            inname_aparc = op.join(fsout, f"{outname}_input.nii.gz")
            x.to_filename(inname_aparc)
            cmd = (
                f"mri_segstats --seg {fsout}/aparc+aseg.mgz "
                f"--o {op.join(fsout, outname)}.txt --i {inname_aparc} --ctab-default "
            )
            sp_run(cmd)


def run_concat_roi_stats():
    """Concatenate ROI stats into a single file"""

    oxasl_rois = []
    fs_rois = []

    def add_index_and_input(df, idx, inpt):
        for k, v in idx.items():
            df[k] = v
        df["source_image"] = inpt
        return df

    def read_oxasl_csv(path):
        df = pd.read_csv(path)
        df = df.rename(columns={c: c.lower().replace(" ", "_") for c in df.columns})
        return df

    # Each oxasl directory has a corresponding fs_roi_stats directory,
    # and 2 model predictions
    for oxdir in sorted(glob(op.join(OUTROOT, "*/*/perf/*.oxasl"))):
        sub = match_key("sub", op.basename(oxdir))
        ses = match_key("ses", op.basename(oxdir))
        acq = match_key("acq", op.basename(oxdir))

        norm_factor = calc_norm_factor(oxdir)
        idx = {
            "subject": sub,
            "session": ses,
            "acquisition": acq,
            "norm_factor": norm_factor,
        }

        for roi_file in ROI_OUT_NAMES:
            oxroi = op.join(oxdir, "ox_roi_stats", roi_file)
            x = read_oxasl_csv(op.join(oxroi, "native/roi_stats.csv"))
            x = add_index_and_input(x, idx, roi_file.replace("_roi_stats", ""))
            oxasl_rois.append(x)

            x = read_fs_roi_txt(op.join(oxdir, "fs_roi_stats", f"{roi_file}.txt"))
            x = add_index_and_input(x, idx, roi_file.replace("_roi_stats", ""))
            fs_rois.append(x)

    oxasl_rois = pd.concat(
        [o.rename(columns={"name": "roi"}) for o in oxasl_rois], ignore_index=True
    )
    oxasl_rois.to_csv(op.join(OUTROOT, "oxasl_roi_stats.csv"), index=False)
    fs_rois = pd.concat(fs_rois, ignore_index=True)
    fs_rois.to_csv(op.join(OUTROOT, "fs_roi_stats.csv"), index=False)


def read_fs_roi_txt(path):
    with open(path, "r") as f:
        lines = iter(f.readlines())
        line = next(lines)
        while not line.startswith("# ColHeaders"):
            line = next(lines)

        header = [h.lower() for h in line.split(" ")[3:-2]]
        lines = list(l.strip(" \n") for l in lines)
        lines = "\n".join(list(" ".join(l.split()) for l in lines))
        csv = pd.read_csv(
            StringIO(lines),
            sep=" ",
            header=0,
            names=header,
            skiprows=0,
            index_col=False,
        )
        csv = csv.drop(columns=["index"]).rename(columns={"structname": "roi"})
    return csv


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
        [DO_ANAT, DO_ASL, DO_PREDICTION, DO_ROIS],
        [run_anat, run_asl, run_predictive_modelling, run_roi_analysis],
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

    if CONCAT_ROIS:
        logging.info("Concatenating ROI stats")
        run_concat_roi_stats()

    logging.info("DONE")
