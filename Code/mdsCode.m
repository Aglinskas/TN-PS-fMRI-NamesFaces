pwd

cd /Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Code
load('aBeta_May2021.mat')
aBeta
%%
core = { 'OFA-L' 'OFA-R' 'FFA-L' 'FFA-R' 'pSTS-L' 'pSTS-R'};
extended = aBeta.r_lbls(~ismember(aBeta.r_lbls,core))
extended = { 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'ATFP-L' 'ATFP-R' 'AMY-L' 'AMY-R' 'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'};
extended = { 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'AMY-L' 'AMY-R' 'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'}
%extended = { 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'}
rlbls = aBeta.r_lbls;

% core_model = mean(aBeta.fmat(ismember(rlbls,core),:,:),3);
% extended_model = mean(aBeta.fmat(ismember(rlbls,extended),:,:),3);
% 
% core_fit = arrayfun(@(s) corr(core_model',mean(aBeta.wmat(ismember(rlbls,core),:,s),1)'),1:size(aBeta.wmat,3))
% extended_fit = arrayfun(@(s) corr(extended_model',mean(aBeta.wmat(ismember(rlbls,extended),:,s),1)'),1:size(aBeta.wmat,3))
% 
% clc;
% pretty_t_test_one_sample(core_fit)
% pretty_t_test_one_sample(extended_fit)
%pretty_t_test_paired(extended_fit,core_fit)
%

size(aBeta.wmat)

core_fit=[]
for r = 1:length(core)
for s = 1:24
core_fit(r,s) = corr(core_model(r,:)',aBeta.wmat(ismember(rlbls,core{r}),:,s)');
end
end


extended_fit = []
for r = 1:length(extended)
for s = 1:24
extended_fit(r,s) = corr(extended_model(r,:)',aBeta.wmat(ismember(rlbls,extended{r}),:,s)');
end
end

clc;
pretty_t_test_one_sample(mean(core_fit,1))
pretty_t_test_one_sample(mean(extended_fit,1))
%%

ffx_r_extended = arrayfun(@(r) corr(extended_model(r,:)',mean(aBeta.wmat(ismember(rlbls,extended{r}),:,:),3)'),1:length(extended))
mean(ffx_r_extended)

ffx_r_core = arrayfun(@(r) corr(core_model(r,:)',mean(aBeta.wmat(ismember(rlbls,core{r}),:,:),3)'),1:length(core))
mean(ffx_r_core)


mean(mean(extended_fit,1))
mean(mean(core_fit,1))




%%

%%

size(ff)
ff =  [core_fit;extended_fit]
[Y I] = sort(mean(ff,2))

ff = ff(I,:);
irlbls = rlbls(I)
f = figure(4);clf;

m = mean(ff,2)
se = std(ff,[],2) ./ sqrt(24)
bar(m);hold on
errorbar(m,se,'r.')
xticks(1:21)
xticklabels(irlbls)
f.CurrentAxes.XTickLabelRotation = 45
%%
rcmat_face = [];
nf = size(aBeta.fmat,3);
r_idx = 7:21;
for s = 1:nf
    rcmat_face(:,:,s) = corr(aBeta.fmat(r_idx ,:,s)');
end

rcmat_words = [];
nw = size(aBeta.wmat,3);
r_idx = 7:21;
for s = 1:nw
    rcmat_words(:,:,s) = corr(aBeta.wmat(r_idx ,:,s)');
end
%%
cmat_cat = cat(3,rcmat_face,rcmat_words);

flatC = [];
for i = 1:44
   flatC(:,i) = get_triu(cmat_cat(:,:,i));
end


[COEFF, SCORE, LATENT] = pca(flatC')


%%
mds = []
for i = 1:44
mds(:,:,i) = mdscale(1-cmat_cat(:,:,i),2);
end


mds = mean(mds,3)
lbls = aBeta.r_lbls(r_idx);

%%

% 150 89 39 IFG
% 143 30 34 OFC 
% 100 20 93 ATFP
% 202 31 163 AMY
% 0 71 171 ATL
% 0 121 53 AG
% 0 136 147 PREC
% 140 141 41 dmPFC
% 7 68 90 vmPFc






%%

cc = [
150 89 39
150 89 39
143 30 34
143 30 34
100 20 93
100 20 93
202 31 163
202 31 163
0 71 171
0 71 171
0 121 53
0 121 53
0 136 147
140 141 41
7 68 90]/255

f = figure(1);clf;hold on
data = {rcmat_face rcmat_words}
ttls = {'RegionFace viewing' 'Name reading'}
for sp = 1:2
subplot(2,1,sp)
mds = mdscale(1-mean(data{sp},3),2);

sc = scatter(mds(:,1),mds(:,2),300,cc,'filled','MarkerFaceAlpha',1,'MarkerEdgeAlpha',1)

for i = 1:length(mds)
    
    
 t = text(mds(i,1),mds(i,2),['   ' lbls{i} '   '],'fontsize',18,'color',cc(i,:),'FontWeight','bold')

 if sp==2 & ismember(lbls{i},{'AMY-R','ATL-L','ATL-R'})
     t.HorizontalAlignment = 'right'
 end
 
 if sp==1 & ismember(lbls{i},{'ATL-R','PREC'})
     t.HorizontalAlignment = 'right'
 end
 
end


%alpha(.5)
xlim([-.6 .7])
ylim([-.6 .7])
title(ttls{sp},'fontsize',24)
f.CurrentAxes.LineWidth = 2
f.CurrentAxes.FontSize = 24
f.CurrentAxes.FontWeight = 'bold'
xlabel('Distance in MD dimension 1 (a.u.)')
ylabel('Distance in MD dimension 2 (a.u.)')
end

f.Color = [1 1 1]
f.Position = [2022        -237         813        1369]
hold off

%addpath('/Users/aidasaglinskas/Downloads/export_fig/')
%help export_fig
%saveas(f,'/Users/aidasaglinskas/Desktop/MDS_ROI.pdf','-bestfit')

%export_fig('/Users/aidasaglinskas/Desktop/MDS_ROI.png','-native')

%%

f = figure(1);clf
Z = linkage(1-get_triu(mean(rcmat_words,3)),'ward')
h = dendrogram(Z,0,'labels',lbls)
for i = 1:length(h)
   h(i).LineWidth  = 5;
   h(i).Color  = [0 0 0];
end

f.CurrentAxes.XTickLabelRotation = 45
f.CurrentAxes.FontSize = 18
f.CurrentAxes.FontWeight = 'bold'
f.CurrentAxes.LineWidth = 2
ylabel('Dissimilarity (a.u.)')







