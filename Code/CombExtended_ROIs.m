
roi_dir = './Files/ROIs_PersonKnowledge/';
files = dir([roi_dir 'ROI_*.nii']);
files = {files.name}';
core_rois = {'ROI_pSTS-Left.nii'
    'ROI_pSTS-Right.nii'
    'ROI_OFALeft.nii'
    'ROI_OFARight.nii'
    'ROI_FFALeft.nii'
    'ROI_FFARight.nii'};

files(ismember(files,core_rois)) = []

all_scans = cosmo_fmri_dataset(fullfile(roi_dir,files{1}))
for i = 2:length(files)
    this_roi = cosmo_fmri_dataset(fullfile(roi_dir,files{i}));
    all_scans.samples = sum([this_roi.samples;all_scans.samples]);
end

cosmo_map2fmri(all_scans,fullfile(roi_dir,'Extedned_rois.nii'))