% extract both experiment data

% ROI files
roi_dir = '/Users/aidasaglinskas/Google Drive/Aidas/Data_words/ROIs_PersonKnowledge/';
a = dir([roi_dir 'R*.nii']);
roi_fls = {a.name}';
roi_names = roi_fls;
    roi_names = strrep(roi_names,'ROI_','');
    roi_names = strrep(roi_names,'.nii','');
    roi_names = strrep(roi_names,'-Left','-L');
    roi_names = strrep(roi_names,'-Right','-R');
    roi_names = strrep(roi_names,'Left','-L');
    roi_names = strrep(roi_names,'Right','-R');
    roi_names = strrep(roi_names,'Amygdala','Amyg.');
    roi_names = strrep(roi_names,'Angular','AG');
%%
tic
exp_folders = {'Data_faces' 'Data_words'}
    svec_w = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
    svec_f = [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31];
svecs = {svec_f svec_w};

for exp_ind = 1:2;


folder_fn_temp = '/Users/aidasaglinskas/Google Drive/Aidas/%s/S%d/Analysis/beta_00%.2i.nii';
con_inds = 6:17;
roi_nans = zeros(1,length(roi_fls));
for r = 1:length(roi_fls);
    roi_fn = fullfile(roi_dir,roi_fls{r});
        if~exist(roi_fn);warning(roi_fn);error('ROI doesnt exist');end
for t = 1:12;
for s = 1:length(svecs{exp_ind});
txt = sprintf('E:%d/2,R:%d/%d,T:%d/%d',exp_ind,r,length(roi_fls),t,12);
clc;disp(txt);
    
subID = svecs{exp_ind}(s);


dt_fn = sprintf(folder_fn_temp,exp_folders{exp_ind},subID,con_inds(t));
    if ~exist(dt_fn);warning(dt_fn);error('beta not found');end

dt = cosmo_fmri_dataset(dt_fn,'mask',roi_fn);
    if sum(isnan(dt.samples)) > 0; warning([num2str(sum(isnan(dt.samples))) ' NaNs']);end
    roi_nans(r) = roi_nans(r) + sum(isnan(dt.samples));
mat(r,t,s) = nanmean(dt.samples);
    

end
end
end
expmats{exp_ind} = mat;
end
toc
tlbls = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common name' 'How many facts' 'Occupation' 'Distinctiveness' 'Full name' 'Same Face' 'Same monument'}
aBeta.fmat_raw = expmats{1};
aBeta.wmat_raw = expmats{2};
aBeta.rlbls = roi_names;
aBeta.tlbls = tlbls';

save('/Users/aidasaglinskas/Google Drive/Aidas/Data_words/ROIs_PersonKnowledge/aBeta.mat','aBeta')