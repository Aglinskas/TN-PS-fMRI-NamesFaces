%% 

for i = 1:10
f = figure(1)
imagesc(rand(1,10))
xticks([])
yticks([])
f.CurrentAxes.LineWidth = .1

ofn = sprintf('/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Paper Figures/%d.pdf',i)
exportgraphics(f, ofn);

end
%%

load('/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Code/aBeta_May2021.mat')



t_ord = [1 5 7 8 3 4 2 9 6 10];
r_ord = [15    16    19    20    21     7     8    17    18     9    10    11    12    13    14]
wmat = aBeta.wmat(:,t_ord,r_ord);

%temp = {'OFA-L' 'OFA-R' 'FFA-L' 'FFA-R' 'pSTS-L' 'pSTS-R' 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'ATFP-L' 'ATFP-R' 'AMY-L' 'AMY-R' 'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'}
%temp = {'ATL-L' 'ATL-R' 'PREC'  'dmPFC' 'vmPFC' 'IFG-L' 'IFG-R'  'AG-L' 'AG-R' 'OFC-L' 'OFC-R' 'ATFP-L' 'ATFP-R' 'AMY-L' 'AMY-R'}
%cellfun(@(x) find(strcmp(aBeta.r_lbls,x)),temp)

tcmat = zeros(21,10,10);
rcmat = zeros(21,15,15);
for s = 1:21
rcmat(s,:,:) = corr(squeeze(wmat(s,:,:)));
tcmat(s,:,:) = corr(squeeze(wmat(s,:,:))');
end


mrcmat = squeeze(mean(rcmat,1))
mtcmat = squeeze(mean(tcmat,1))

%%

f = figure(1)
imagesc(mrcmat,[-.2 .5])
xticks([])
yticks([])
f.CurrentAxes.LineWidth = 3
ofn = '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Paper Figures/rcmat.pdf'
exportgraphics(f, ofn);

f = figure(1)
imagesc(mtcmat,[.1 .6])
xticks([])
yticks([])
f.CurrentAxes.LineWidth = 3
ofn = '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Paper Figures/tcmat.pdf'
exportgraphics(f, ofn);
%imagesc(mtcmat,[.1 .6])
%%

f = figure(1)
Y = 1-get_triu(mrcmat)
Z = linkage(Y,'ward')
d = dendrogram(Z)

for i = 1:length(d)
d(i).LineWidth = 5
d(i).Color = [0 0 0]
end

f.Color = [1 1 1]
xticks([])
yticks([])
f.CurrentAxes.LineWidth = 5

ofn = '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Paper Figures/rdend.pdf'
exportgraphics(f, ofn);

%%
f = figure(1)
Y = 1-get_triu(mtcmat)
Z = linkage(Y,'ward')
d = dendrogram(Z)

for i = 1:length(d)
d(i).LineWidth = 5
d(i).Color = [0 0 0]
end

f.Color = [1 1 1]
xticks([])
yticks([])
f.CurrentAxes.LineWidth = 5

ofn = '/Users/aidasaglinskas/Desktop/TN-PS-fMRI-NamesFaces/Paper Figures/tdend.pdf'
exportgraphics(f, ofn);





