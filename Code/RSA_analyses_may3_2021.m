load('/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Data/BothExpsAnalysis/SPM.mat')
SPM.xY.P

%%
dr= '/Users/aidasaglinskas/Desktop/untitled folder/'
cd(dr)
lol = dir('*.mat')
files = {lol.name}'
%%
i = i+1
clc
disp(fullfile(dr,files{i}))
load(fullfile(dr,files{i}))
aBeta

aBeta
%%
% clear all;clc;
% load('aBeta.mat')
% aBeta
% 
% aBeta.fmat = aBeta.fmat_raw-aBeta.fmat_raw(:,11,:)
% aBeta.wmat = aBeta.wmat_raw-aBeta.wmat_raw(:,11,:)
% aBeta.fmat = aBeta.fmat(:,1:10,:)
% aBeta.wmat = aBeta.wmat(:,1:10,:)
% 
% aBeta.tlbls10 = aBeta.tlbls(1:10)
%%

hist(aBeta.wmat(:))

%%
disp(aBeta.rlbls)
rois = {'ATFP-L' 'ATFP-R' 'ATL-L' 'ATL-R' 'AMY-L' 'AMY-R' 'AG-L' 'AG-R' 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'PREC' 'dmPFC' 'vmPFC'}
r_idx = ismember(aBeta.rlbls,rois)

nsubs = size(aBeta.fmat,3)
cmat_face = []
for s = 1:nsubs
    cmat_face(:,:,s) = corr(aBeta.fmat(r_idx ,:,s));
end

nsubs = size(aBeta.wmat,3)
cmat_words = []
for s = 1:nsubs
    cmat_words(:,:,s) = corr(aBeta.wmat(r_idx ,:,s));
end
%
lbls = aBeta.tlbls10
model_empirical = mean(cmat_face,3)
model_pairs = make_model(lbls,{ {'Attractiveness'    'Friendliness'}    {'Trustworthiness' 'Distinctiveness' } {'First memory' 'Familiarity'} {'Occupation'  'How many facts'} {'Common name' 'Full name'} })
model_epBio = make_model(lbls,{ {'Attractiveness'    'Friendliness'}    {'Trustworthiness' 'Distinctiveness' } {'First memory' 'Familiarity' 'Occupation'  'How many facts'} {'Common name' 'Full name'} })
model_nomBio = make_model(lbls,{ {'Attractiveness'    'Friendliness'}    {'Trustworthiness' 'Distinctiveness' } {'First memory' 'Familiarity'} {'Occupation'  'How many facts' 'Common name' 'Full name'} })
model_macrodomain = make_model(lbls,{ {'Attractiveness'    'Friendliness'    'Trustworthiness' 'Distinctiveness' } {'First memory' 'Familiarity' 'Occupation'  'How many facts'} {'Common name' 'Full name'} })

fit_empirical = fit_rsa(cmat_words,model_empirical)
fit_macrodomain = fit_rsa(cmat_words,model_macrodomain)

fit_pairs = fit_rsa(cmat_words,model_pairs)
fit_epBio = fit_rsa(cmat_words,model_epBio)
fit_nomBio = fit_rsa(cmat_words,model_nomBio)
%
figure(1);plot_rsa_fit({fit_nomBio,fit_epBio},{'fit_nomBio' 'fit_epBio'})
figure(2);plot_rsa_fit({fit_empirical,fit_macrodomain},{'empirical' 'macro domain'})

pretty_t_test_paired(fit_empirical,fit_macrodomain)
pretty_t_test_paired(fit_epBio,fit_nomBio)

pretty_t_test_paired(fit_macrodomain,fit_epBio)
%% ROI similarity

load('aBeta_feb6.mat');
disp(aBeta.rlbls);
rois = {'ATFP-L' 'ATFP-R' 'ATL-L' 'ATL-R' 'AMY-L' 'AMY-R' 'AG-L' 'AG-R' 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'PREC' 'dmPFC' 'vmPFC'};
r_idx = ismember(aBeta.rlbls,rois);

nsubs = size(aBeta.fmat,3);
cmat_face = [];
for s = 1:nsubs;
    cmat_face(:,:,s) = corr(aBeta.fmat(r_idx ,:,s)');
end

nsubs = size(aBeta.wmat,3);
cmat_words = [];
for s = 1:nsubs
    cmat_words(:,:,s) = corr(aBeta.wmat(r_idx ,:,s)');
end
%
rlbls = aBeta.rlbls(r_idx)
%pairs_model = make_model(rlbls, {{'ATFP-L' 'ATFP-R'} {'ATL-L' 'ATL-R'} {'AMY-L' 'AMY-R'} {'AG-L' 'AG-R'} {'IFG-L' 'IFG-R'} {'OFC-L' 'OFC-R'}})
pairs_model = make_model(rlbls(1:12), {{'ATFP-L' 'ATFP-R'} {'ATL-L' 'ATL-R'} {'AMY-L' 'AMY-R'} {'AG-L' 'AG-R'} {'IFG-L' 'IFG-R'} {'OFC-L' 'OFC-R'}})
pairs_fit = fit_rsa(cmat_words(1:12,1:12,:),pairs_model)

iec_model  = make_model(rlbls,{{'ATFP-L' 'ATFP-R' 'AMY-L' 'AMY-R'} {'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R'} {'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'}})
empirical_model = cmat_face

empirical_fit = fit_rsa(cmat_words,mean(cmat_face,3))

iec_fit = fit_rsa(cmat_words,iec_model)

plot_rsa_fit({pairs_fit iec_fit empirical_fit},{'pairs' 'iec' 'empirical'})

pretty_t_test_paired(iec_fit,pairs_fit)
pretty_t_test_paired(empirical_fit,iec_fit)
%%



