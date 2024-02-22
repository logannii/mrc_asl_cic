import numpy as np
import nibabel as nib
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.widgets import Slider
import pingouin as pg

def visualise_byprotocol(subno, protocol, space='native', histon=True, refon=False, pwion=False, csfcalibon=False):

    imsize = 3
    cmap = 'hot'
    colors = ['tab:blue','tab:orange','tab:red','tab:green']
    if isinstance(subno,int): subno = [subno]
    
    for sub in subno:

        filename_prefix = '/Users/xinzhang/Downloads/mrc_asl_cic/data/sub{:02d}'.format(sub)

        if protocol=='GE-3D':
            # Figure 1: Reference image (Scanner generated CBF, or structural image, or standard image), if refon=True
            if refon: figure_ref = plt.figure(figsize=[4*imsize,imsize],dpi=100)
            # Figure 2: oxford_asl processed image
            figure_img = plt.figure(figsize=[4*imsize,imsize],dpi=100) 
            # Figure 3: Histogram of CBF, if histon=True
            figure_hist = plt.figure(figsize=[2*imsize,imsize],dpi=100)
            if histon: ax_hist = figure_hist.add_subplot()
            j=0
            for session in ['s1','s2']:
                for state in ['REST','TASK']:
                    j+=1
                    cbf = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/REPEAT_ALL_CBF_mcflirt_mean_BETed.nii.gz').get_fdata()
                    mask = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/REPEAT_ALL_CBF_mcflirt_mean_BETed_mask.nii.gz').get_fdata()
                    ax_img = figure_img.add_subplot(1,4,j)
                    ax_img.imshow(np.flipud(cbf[:,:,round(cbf.shape[2]/2)].T),cmap=cmap)
                    ax_img.xaxis.set_visible(False); ax_img.yaxis.set_visible(False)
                    ax_img.set_title('sub{:02d}'.format(sub)+' '+protocol+'\n'+session+' '+state+' '+space+' space')
                    if histon: 
                        ydata,xdata = np.histogram(cbf.flatten()[mask.flatten()>0],bins=100)
                        ax_hist.plot(xdata[1:],ydata,label=session+' '+state,color=colors[j-1])
                        # ax_hist.hist(cbf.flatten()[mask.flatten()>0],bins=100,histtype='step',label=session+' '+state,color=colors[j-1])
                    if refon:
                        cbf_ref = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/AVG_CBF.nii.gz').get_fdata()
                        ax_ref = figure_ref.add_subplot(1,4,j)
                        ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap=cmap)
                        ax_ref.xaxis.set_visible(False); ax_ref.yaxis.set_visible(False)
                        ax_ref.set_title('sub{:02d}'.format(sub)+' '+protocol+'\n'+session+' '+state+' ref-image')
            if histon: 
                ax_hist.legend()
                ax_hist.grid(alpha=0.5)
                ax_hist.set_xlabel('CBF (ml/100g/min)')
                ax_hist.set_ylabel('Number of voxels')
                ax_hist.set_title('Histogram of sub{:02d}'.format(sub)+' '+protocol+' '+space+' space')

        else:
            struct_img = '/analysis/T1.anat/T1_biascorr_brain.nii.gz'
            std_img = '/analysis/T1.anat/T1_to_MNI_nonlin.nii.gz'
            filename_ref = {'GE-eASLRESTnative':'/nifti/NOT_DIAGNOSTIC_(CBF)_eASL_7_delays_real.nii.gz', 'GE-eASLTASKnative':'/nifti/NOT_DIAGNOSTIC_(CBF)_eASL_7_delays_ACT_real.nii.gz', 
                            'GE-eASLRESTstruct':struct_img, 'GE-eASLTASKstruct':struct_img, 'GE-eASLRESTstd':std_img, 'GE-eASLTASKstd':std_img, 
                            'Ing-2DRESTnative':'/nifti/2dREST_PROD_pCASL-nonorm_real.nii.gz','Ing-2DTASKnative':'/nifti/2DACT_PROD_pCASL-nonorm_real.nii.gz', 
                            'Ing-2DRESTstruct':struct_img, 'Ing-2DTASKstruct':struct_img, 'Ing-2DRESTstd':std_img, 'Ing-2DTASKstd':std_img, 
                            'Ing-3DRESTnative':'/nifti/REST_PROD_3D_pCASL_6mm_noNorm_real.nii.gz', 'Ing-3DTASKnative':'/nifti/ACT_PROD_3D_pCASL_6mm_noNorm_real.nii.gz', 
                            'Ing-3DRESTstruct':struct_img, 'Ing-3DTASKstruct':struct_img, 'Ing-3DRESTstd':std_img, 'Ing-3DTASKstd':std_img}
            if protocol=='GE-eASL': scanner='ge'; type='eASL'
            elif protocol=='Ing-2D': scanner='ing'; type='2D'
            elif protocol=='Ing-3D': scanner='ing'; type='3D'
            else: ValueError('Protocol name does not exist.')
            struct_mask = nib.load(filename_prefix+'/'+scanner+'/s1/analysis/T1.anat/T1_biascorr_brain_mask.nii.gz').get_fdata()
            std_mask = nib.load(filename_prefix+'/'+scanner+'/s1/analysis/T1.anat/MNI152_T1_2mm_brain_mask_dil1.nii.gz').get_fdata()
            # Figure 1: Reference image (Scanner generated CBF, or structural image, or standard image), if refon=True
            if refon: figure_ref = plt.figure(figsize=[4*imsize,imsize],dpi=100)
            # Figure 2: Perfusion weighted image, if pwion=True
            if pwion: figure_pwi = plt.figure(figsize=[4*imsize,imsize],dpi=100)
            # Figure 3: oxford_asl processed image (voxelwise-calibrated CBF)
            figure_img = plt.figure(figsize=[4*imsize,2*imsize],dpi=100) 
            # Figure 4: CSF-calibrated CBF, if csfcalibon=True
            if csfcalibon: figure_csfcalib = plt.figure(figsize=[4*imsize,2*imsize],dpi=100)
            # Figure 5: Histogram of CBF, if histon=True
            if histon: figure_hist = plt.figure(figsize=[4*imsize,imsize],dpi=100)
            j=0
            for pvc in ['nopvc','pvc']:
                if histon: ax_hist = figure_hist.add_subplot(1,2,j//4+1)
                for session in ['s1','s2']:
                    for state in ['REST','TASK']:
                        j+=1
                        if pwion: cbf_pwi = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/perfusion.nii.gz').get_fdata()
                        if pvc=='nopvc': cbf = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/perfusion_calib.nii.gz').get_fdata()
                        elif pvc=='pvc': cbf = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/pvcorr/perfusion_calib.nii.gz').get_fdata()
                        if space=='native': mask = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/mask.nii.gz').get_fdata()
                        elif space=='struct': mask = struct_mask
                        elif space=='std': mask = std_mask
                        ax_img = figure_img.add_subplot(2,4,j)
                        ax_img.imshow(np.flipud(cbf[:,:,round(cbf.shape[2]/2)].T),cmap=cmap)
                        ax_img.xaxis.set_visible(False); ax_img.yaxis.set_visible(False)
                        ax_img.set_title('sub{:02d}'.format(sub)+' '+protocol+' '+pvc+'\n'+session+' '+state+' '+space+' space')
                        if csfcalibon:
                            if pvc=='nopvc': cbf_csfcalib = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/perfusion_calib_csf.nii.gz').get_fdata()
                            elif pvc=='pvc': cbf_csfcalib = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/pvcorr/perfusion_calib_csf.nii.gz').get_fdata()
                            ax_csfcalib = figure_csfcalib.add_subplot(2,4,j)
                            ax_csfcalib.imshow(np.flipud(cbf_csfcalib[:,:,round(cbf_csfcalib.shape[2]/2)].T),cmap=cmap)
                            ax_csfcalib.xaxis.set_visible(False); ax_csfcalib.yaxis.set_visible(False)
                            ax_csfcalib.set_title('sub{:02d}'.format(sub)+' '+protocol+' '+pvc+'\n'+session+' '+state+' '+space+' space CSF-calib')
                        if histon: 
                            ydata,xdata = np.histogram(cbf.flatten()[mask.flatten()>0],bins=100,range=(1,200))
                            ax_hist.plot(xdata[1:],ydata,label=session+'_'+state,color=colors[(j-1)%4])
                            # ax_hist.hist(cbf.flatten()[mask.flatten()>0],bins=100,range=(1,200),histtype='step',label=session+'_'+state,color=colors[(j-1)%4])
                            if csfcalibon:
                                ydata,xdata = np.histogram(cbf_csfcalib.flatten()[mask.flatten()>0],bins=100,range=(1,200))
                                ax_hist.plot(xdata[1:],ydata,linestyle='--',label=session+'_'+state+'_CSF-calib',color=colors[(j-1)%4])
                                # ax_hist.hist(cbf_csfcalib.flatten()[mask.flatten()>0],bins=100,range=(1,200),histtype='step',label=session+'_'+state+'_CSF-calib',color=colors[(j-1)%4])
                        if refon:
                            if pvc=='pvc': continue
                            cbf_ref = nib.load(filename_prefix+'/'+scanner+'/'+session+filename_ref[protocol+state+space]).get_fdata()
                            if space=='native':
                                ax_ref = figure_ref.add_subplot(1,4,j)
                                ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap='hot')
                            else:
                                if j>1: continue
                                figure_ref.set_size_inches((imsize,imsize))
                                ax_ref = figure_ref.add_subplot()
                                ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap='hot')
                            ax_ref.xaxis.set_visible(False); ax_ref.yaxis.set_visible(False)
                            ax_ref.set_title('sub{:02d}'.format(sub)+' '+protocol+'\n'+session+' '+state+' ref-image')
                        if pwion:
                            if pvc=='pvc': continue
                            cbf_pwi = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space+'_space/perfusion.nii.gz').get_fdata()
                            if space=='native':
                                ax_pwi = figure_pwi.add_subplot(1,4,j)
                                ax_pwi.imshow(np.flipud(cbf_pwi[:,:,round(cbf_pwi.shape[2]/2)].T),cmap='hot')
                            ax_pwi.xaxis.set_visible(False); ax_pwi.yaxis.set_visible(False)
                            ax_pwi.set_title('sub{:02d}'.format(sub)+' '+protocol+'\n'+session+' '+state+' pw-image')
                if histon: 
                    ax_hist.legend()
                    ax_hist.grid(alpha=0.5)
                    ax_hist.set_xlim([0,200])
                    ax_hist.set_xlabel('CBF (ml/100g/min)')
                    ax_hist.set_ylabel('Number of voxels')
                    ax_hist.set_title('Histogram of sub{:02d}'.format(sub)+' '+protocol+' '+pvc+' '+space+' space')
                
    return None


def visualise_bysubject(subno,protocol='all',space='all',hist=True,refon=False):

    imsize = 3

    colors = ['tab:blue','tab:orange','tab:red','tab:green']
    if protocol=='all': protocol = ['GE-3D','GE-eASL','Ing-2D','Ing-3D']
    if space=='all': space=['native','struct','std']
    for protocol_counter in protocol:
        
        filename_prefix = '/Users/xinzhang/Downloads/mrc_asl_cic/data/sub{:02d}'.format(subno)

        if protocol_counter=='GE-3D':
            if refon: figure_ref = plt.figure(figsize=[4*imsize,imsize],dpi=100)
            figure_img = plt.figure(figsize=[4*imsize,imsize],dpi=100) 
            figure_hist = plt.figure(figsize=[2*imsize,imsize],dpi=100)
            j=0
            if hist: ax_hist = figure_hist.add_subplot()
            for session in ['s1','s2']:
                for state in ['REST','TASK']:
                    j+=1
                    ax_img = figure_img.add_subplot(1,4,j)
                    cbf = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/REPEAT_ALL_CBF_mcflirt_mean_BETed.nii.gz').get_fdata()
                    mask = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/REPEAT_ALL_CBF_mcflirt_mean_BETed_mask.nii.gz').get_fdata()
                    ax_img.imshow(np.flipud(cbf[:,:,round(cbf.shape[2]/2)].T),cmap='Greys_r')
                    ax_img.xaxis.set_visible(False)
                    ax_img.yaxis.set_visible(False)
                    ax_img.set_title('sub{:02d}'.format(subno)+' '+protocol_counter+'\n'+session+' '+state+' native space')
                    if hist: ax_hist.hist(cbf.flatten()[mask.flatten()>0],bins=100,histtype='step',label=session+' '+state,color=colors[j-1])
                    if refon:
                        cbf_ref = nib.load(filename_prefix+'/ge/'+session+'/analysis/3D_'+state+'/AVG_CBF.nii.gz').get_fdata()
                        ax_ref = figure_ref.add_subplot(1,4,j)
                        ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap='Greys_r')
                        ax_ref.xaxis.set_visible(False)
                        ax_ref.yaxis.set_visible(False)
                        ax_ref.set_title('sub{:02d}'.format(subno)+' '+protocol_counter+'\n'+session+' '+state+' ref-image')
            if hist: 
                ax_hist.legend()
                ax_hist.grid(alpha=0.5)
                ax_hist.set_xlabel('CBF (ml/100g/min)')
                ax_hist.set_ylabel('Number of voxels')
                ax_hist.set_title('Histogram of sub{:02d}'.format(subno)+' '+protocol_counter+' native space')

        else:
            struct_img = '/analysis/T1.anat/T1_biascorr_brain.nii.gz'
            std_img = '/analysis/T1.anat/T1_to_MNI_nonlin.nii.gz'
            filename_ref = {'GE-eASLRESTnative':'/nifti/NOT_DIAGNOSTIC_(CBF)_eASL_7_delays_real.nii.gz', 'GE-eASLTASKnative':'/nifti/NOT_DIAGNOSTIC_(CBF)_eASL_7_delays_ACT_real.nii.gz', 
                            'GE-eASLRESTstruct':struct_img, 'GE-eASLTASKstruct':struct_img, 'GE-eASLRESTstd':std_img, 'GE-eASLTASKstd':std_img, 
                            'Ing-2DRESTnative':'/nifti/2dREST_PROD_pCASL-nonorm_real.nii.gz','Ing-2DTASKnative':'/nifti/2DACT_PROD_pCASL-nonorm_real.nii.gz', 
                            'Ing-2DRESTstruct':struct_img, 'Ing-2DTASKstruct':struct_img, 'Ing-2DRESTstd':std_img, 'Ing-2DTASKstd':std_img, 
                            'Ing-3DRESTnative':'/nifti/REST_PROD_3D_pCASL_6mm_noNorm_real.nii.gz', 'Ing-3DTASKnative':'/nifti/ACT_PROD_3D_pCASL_6mm_noNorm_real.nii.gz', 
                            'Ing-3DRESTstruct':struct_img, 'Ing-3DTASKstruct':struct_img, 'Ing-3DRESTstd':std_img, 'Ing-3DTASKstd':std_img}
            if protocol_counter=='GE-eASL': scanner='ge'; type='eASL'
            elif protocol_counter=='Ing-2D': scanner='ing'; type='2D'
            elif protocol_counter=='Ing-3D': scanner='ing'; type='3D'
            else: ValueError('Protocol name does not exist.')
            struct_mask = nib.load(filename_prefix+'/'+scanner+'/s1/analysis/T1.anat/T1_biascorr_brain_mask.nii.gz').get_fdata()
            std_mask = nib.load(filename_prefix+'/'+scanner+'/s1/analysis/T1.anat/MNI152_T1_2mm_brain_mask_dil1.nii.gz').get_fdata()
            for space_counter in space:
                if refon: figure_ref = plt.figure(figsize=[4*imsize,imsize],dpi=100)
                figure_img = plt.figure(figsize=[4*imsize,2*imsize],dpi=100) 
                figure_hist = plt.figure(figsize=[4*imsize,imsize],dpi=100)
                j=0
                for pvc in ['nopvc','pvc']:
                    if hist: ax_hist = figure_hist.add_subplot(1,2,j//4+1)
                    for session in ['s1','s2']:
                        for state in ['REST','TASK']:
                            j+=1
                            if refon: cbf_ref = nib.load(filename_prefix+'/'+scanner+'/'+session+filename_ref[protocol_counter+state+space_counter]).get_fdata()
                            if pvc=='nopvc': cbf = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space_counter+'_space/perfusion_calib.nii.gz').get_fdata()
                            if pvc=='pvc': cbf = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space_counter+'_space/pvcorr/perfusion_calib.nii.gz').get_fdata()
                            if space_counter=='native': mask = nib.load(filename_prefix+'/'+scanner+'/'+session+'/analysis/'+type+'_'+state+'/'+space_counter+'_space/mask.nii.gz').get_fdata()
                            elif space_counter=='struct': mask = struct_mask
                            elif space_counter=='std': mask = std_mask
                            ax_img = figure_img.add_subplot(2,4,j)
                            ax_img.imshow(np.flipud(cbf[:,:,round(cbf.shape[2]/2)].T),cmap='Greys_r')
                            ax_img.xaxis.set_visible(False)
                            ax_img.yaxis.set_visible(False)
                            ax_img.set_title('sub{:02d}'.format(subno)+' '+protocol_counter+' '+pvc+'\n'+session+' '+state+' '+space_counter+' space')
                            if hist: ax_hist.hist(cbf.flatten()[mask.flatten()>0],bins=100,range=(1,200),histtype='step',label=session+' '+state,color=colors[(j-1)%4])
                            if refon:
                                if pvc=='pvc': continue
                                cbf_ref = nib.load(filename_prefix+'/'+scanner+'/'+session+filename_ref[protocol_counter+state+space_counter]).get_fdata()
                                if space_counter=='native':
                                    ax_ref = figure_ref.add_subplot(1,4,j)
                                    ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap='Greys_r')
                                else:
                                    if j>1: continue
                                    figure_ref.set_size_inches((imsize,imsize))
                                    ax_ref = figure_ref.add_subplot()
                                    ax_ref.imshow(np.flipud(cbf_ref[:,:,round(cbf_ref.shape[2]/2)].T),cmap='Greys_r')
                                ax_ref.xaxis.set_visible(False)
                                ax_ref.yaxis.set_visible(False)
                                ax_ref.set_title('sub{:02d}'.format(subno)+' '+protocol_counter+'\n'+session+' '+state+' ref-image')
                            
                    if hist: 
                        ax_hist.legend()
                        ax_hist.grid(alpha=0.5)
                        ax_hist.set_xlim([0,200])
                        ax_hist.set_xlabel('CBF (ml/100g/min)')
                        ax_hist.set_ylabel('Number of voxels')
                        ax_hist.set_title('Histogram of sub{:02d}'.format(subno)+' '+protocol_counter+' '+pvc+' '+space_counter+' space')
                
    return None

def get_roi_cbf(protocol):
    cbf_data = {}
    protocols_dict = {'GE-3D':'ge_3D', 'GE-eASL':'ge_eASL', 'Ing-2D':'ing_2D', 'Ing-3D':'ing_3D'}
    protocol = protocols_dict[protocol]
    cbf_data['Subject'] = []; cbf_data['Session'] = []
    for sub in np.arange(1,11):
        for session in [1,2]:
            cbf_data['Subject'].append(sub)
            cbf_data['Session'].append(session)
    for pvc in ['nopvc','pvc']:
        if protocol=='ge_3D' and pvc=='pvc': continue
        for state in ['REST','TASK']:
            for region in ['gm','wm','fl','ol','pl','tl']:
                cbf_data[state+'_'+region+'_'+pvc] = []
                if region=='gm': thr=0.9
                elif region=='wm': thr=0.7
                else: thr=0.5
                for sub in np.arange(1,11):
                    for session in ['s1','s2']:
                        filename_prefix = '/Users/xinzhang/Downloads/mrc_asl_cic/data/repeatability/results/sub{:02d}'.format(sub)
                        cbf = nib.load(filename_prefix+'/'+protocol+'_'+session+'_'+state+'/cbf_'+region+'_'+pvc+'.nii.gz').get_fdata()
                        mask = nib.load(filename_prefix+'/'+protocol+'_'+session+'_'+state+'/prob_'+region+'.nii.gz').get_fdata()
                        cbf_mean = cbf.flatten()[mask.flatten()>thr].mean()
                        cbf_data[state+'_'+region+'_'+pvc].append(cbf_mean)
    return cbf_data

