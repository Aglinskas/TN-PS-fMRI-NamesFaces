%%
loadMR
svec_w = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
svec_f = [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31];
addpath('/Users/aidasaglinskas/Google Drive/Aidas/Data_words/');

r_ord = [13 14 9 10 19 20 11 12 15 16 1 2 5 6 3 4 18 17 21 7 8];

aBeta.fmat = aBeta.fmat(r_ord,:,:);
aBeta.wmat = aBeta.wmat(r_ord,:,:);
aBeta.r_lbls = aBeta.r_lbls(r_ord);

aBeta.r_lbls = strrep(aBeta.r_lbls,'.mat','');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-left','-L');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-right','-R');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Precuneus','Prec');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Angular','AG');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Agdala-L','amy.')

rlbls = aBeta.r_lbls;

%aBeta.fmat = aBeta.fmat_raw(:,1:10,:);
%aBeta.wmat = aBeta.wmat_raw(:,1:10,:);
%%
rinds = 1:21;
rinds = ~ismember(rlbls,{'OFA-L' 'OFA-R' 'FFA-L' 'FFA-R' 'pSTS-L' 'pSTS-R'});
tinds = 1:10;

    tlbls = aBeta.t_lbls(tinds);
    rlbls = strrep(aBeta.r_lbls,'.mat','');
    rlbls = rlbls(rinds);
face_cmats = func_make_cmat(aBeta.fmat(rinds,tinds,:));
word_cmats = func_make_cmat(aBeta.wmat(rinds,tinds,:));

figure(2);
func_plot_dendMat(mean(word_cmats{2},3),tlbls);title('word','fontsize',20)
figure(3);
func_plot_dendMat(mean(face_cmats{2},3),tlbls);title('face','fontsize',20)
%%
figure(2);
func_plot_dendMat(mean(word_cmats{1},3),rlbls);title('word','fontsize',20)
figure(3);
func_plot_dendMat(mean(face_cmats{1},3),rlbls);title('face','fontsize',20)
%% Altered Task similarity
crossTmat = [];
for i = 1:10
for j = 1:10
  [H,P,CI,STATS]= ttest2(squeeze(face_cmats{2}(i,j,:)),squeeze(word_cmats{2}(i,j,:)),'alpha',.1);
  crossTmat(i,j) = H;
end
end
clf;add_numbers_to_mat(crossTmat,tlbls);
%% Global connectivity difs
v1 = arrayfun(@(s) mean(1-squareform(1-face_cmats{1}(:,:,s))'),1:20)';
v2 = arrayfun(@(s) mean(1-squareform(1-word_cmats{1}(:,:,s))'),1:24)';
[H,P,CI,STATS] = ttest2(v1,v2);
t_statement(STATS,P);
%% Pair model 
%clc;disp(tlbls)
t1 = {{'First memory' 'Familiarity'} {'Attractiveness' 'Distinctiveness'} {'Common name' 'Full name'} {'How many facts' 'Occupation'} {'Friendliness' 'Trustworthiness'}};
model = func_made_RSA_model(tlbls,t1);

mats = {word_cmats{2} face_cmats{2}};
exp = 2;
model_ev = func_fit_RSA_model(mats{exp},model);
[H,P,CI,STATS] = ttest(model_ev,0,'alpha',.05);
t_statement(STATS,P);
%% Episodic semantic
%clc;disp(tlbls)
clc;
t1 = {{'How many facts' 'Occupation' 'First memory' 'Familiarity'} {'Common name' 'Full name'}};
t2 = {{'How many facts' 'Occupation' 'Common name' 'Full name' } {'First memory' 'Familiarity'}};
model1 = func_made_RSA_model(tlbls,t1);
model2 = func_made_RSA_model(tlbls,t2);

mats = {word_cmats{2} face_cmats{2}};
exp = 1;
model_ev1 = func_fit_RSA_model(mats{exp},model1);
model_ev2 = func_fit_RSA_model(mats{exp},model2);
[H,P,CI,STATS] = ttest(model_ev1,model_ev2,'alpha',.05);
t_statement(STATS,P);
%% Corr
mat = aBeta.fmat;
m = squeeze(mean(mat,2))';
rlbls = strrep(aBeta.r_lbls,'.mat','');
func_plot_tbar_plot(m,rlbls);
%%

% source_mat = aBeta.fmat;
% target_mat = aBeta.wmat;
clc;
source_mat = aBeta.fmat(rinds,:,:);
target_mat = aBeta.wmat(rinds,:,:);


src_cmats = func_make_cmat(source_mat);
targ_cmats = func_make_cmat(target_mat);

exp_ind = 2;
model = mean(src_cmats{exp_ind},3);

model_fit = func_fit_RSA_model(targ_cmats{exp_ind},model);
[H,P,CI,STATS] = ttest(model_fit);
t_statement(STATS,P);
disp(mean(model_fit));
%% CCs 

m1 = squeeze(mean(aBeta.fmat,2));
m2 = squeeze(mean(aBeta.wmat,2));

clc;
dt = [];
for r = 1:21
[H,P,CI,STATS] = ttest2(m1(r,:)',m2(r,:)');
dt(r) = H;
end
rlbls(logical(dt));
%%
rlbls = aBeta.r_lbls;
core = ismember(rlbls,{'FFA-left' 'FFA-right' 'OFA-left' 'OFA-right' 'pSTS-left' 'pSTS-right'});

face_cmats = func_make_cmat(aBeta.fmat);
word_cmats = func_make_cmat(aBeta.wmat);

model = eye(21);
model(core,:) = 1;
model(:,core) = 1;
%imagesc(model);

face_ev = func_fit_RSA_model(face_cmats{1},model);
word_ev = func_fit_RSA_model(word_cmats{1},model);

[H,P,CI,STATS] = ttest2(face_ev,word_ev);
t_statement(STATS,P);
%% Core Uni
mat = aBeta.fmat;
rlbls = aBeta.r_lbls;
rlbls = strrep(rlbls,'.mat','');
m = squeeze(mean(mat,2));clc;disp(size(m))

clf
func_plot_tbar_plot(m',rlbls,1)

f = gcf;
f.CurrentAxes.FontSize = 12;
f.CurrentAxes.FontWeight = 'bold';
%%
loadMR

%%
r_ind = ismember(rlbls,'Prec');
[H,P,CI,STATS] = ttest2(mat1(r_ind,:)',mat2(r_ind,:)');
t_statement(STATS,P);


model1 = func_made_RSA_model(tlbls,{{'Distinctiveness' 'Full name' 'Common name'} {'Attractiveness' 'Friendliness' 'Trustworthiness'}});
model2 = func_made_RSA_model(tlbls,{{'Full name' 'Common name'} {'Distinctiveness' 'Attractiveness' 'Friendliness' 'Trustworthiness'}});


model_ev = func_fit_RSA_model(word_cmats{2},{model1 model2});
%model_ev = func_fit_RSA_model(face_cmats{2},{model1 model2});
[H,P,CI,STATS] = ttest(model_ev(:,1),model_ev(:,2));
t_statement(STATS,P);
%%

model1 = func_made_RSA_model(rlbls,{{'IFG-L' 'IFG-R' 'ATL-L' 'ATL-R' 'dmPFC' 'Prec' 'vmPFC' 'AG-L' 'AG-R'} {'OFC-L' 'OFC-R' 'ATFP-L' 'ATFP-R' 'Amygdala-L' 'Amygdala-R'}});
model2 = func_made_RSA_model(rlbls,{{'ATL-L' 'ATL-R' 'dmPFC' 'Prec' 'vmPFC' 'AG-L' 'AG-R' 'IFG-L' 'IFG-R' } {'OFC-L' 'OFC-R' }});
%%
model1 = func_made_RSA_model(rlbls,{{'ATL-L' 'ATL-R' 'dmPFC' 'Prec' 'vmPFC' 'AG-L' 'AG-R' 'ATFP-L' 'ATFP-R' } {'Amygdala-L' 'Amygdala-R'}});
model2 = func_made_RSA_model(rlbls,{{'ATL-L' 'ATL-R' 'dmPFC' 'Prec' 'vmPFC' 'AG-L' 'AG-R'} {'ATFP-L' 'ATFP-R' 'Amygdala-L' 'Amygdala-R'}});
add_numbers_to_mat(model2,rlbls)
%%
model_ev = func_fit_RSA_model(word_cmats{1},{model2 model1});
[H,P,CI,STATS] = ttest(model_ev(:,1),model_ev(:,2));
t_statement(STATS,P);
%% Face > Name
rlbls = aBeta.r_lbls;
mat1 = squeeze(mean(aBeta.fmat,2));
mat2 = squeeze(mean(aBeta.wmat,2));

mat1 = mat1(7:end,:);
mat2 = mat2(7:end,:);
rlbls = rlbls(7:end);
%%
clc;
for r_ind = 1:size(mat1,1);
[H,P,CI,STATS] = ttest2(mat1(r_ind,:)',mat2(r_ind,:)','alpha',.05);
if H
disp(rlbls(r_ind));
t_statement(STATS,P);
end
end
%% Overall
[H,P,CI,STATS] = ttest2(mean(mat1,1)',mean(mat2,1)');
t_statement(STATS,P)
%%


m = squeeze(mean(aBeta.fmat,2));
figure(1);clf
func_plot_tbar_plot(m',aBeta.r_lbls)

%%
clc
r_ind = ismember(aBeta.r_lbls,'Prec');
v = squeeze(mean(aBeta.fmat(r_ind,:,:),2));
[H,P,CI,STATS] = ttest(v);
t_statement(STATS,P);

%% Review

loadMR
%svec_w = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
%svec_f = [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31];
addpath('/Users/aidasaglinskas/Google Drive/Aidas/Data_words/');
r_ord = [13 14 9 10 19 20 11 12 15 16 1 2 5 6 3 4 18 17 21 7 8];

aBeta.fmat = aBeta.fmat(r_ord,:,:);
aBeta.wmat = aBeta.wmat(r_ord,:,:);
aBeta.r_lbls = aBeta.r_lbls(r_ord);

aBeta.r_lbls = strrep(aBeta.r_lbls,'.mat','');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-left','-L');
aBeta.r_lbls = strrep(aBeta.r_lbls,'-right','-R');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Precuneus','Prec');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Angular','AG');
aBeta.r_lbls = strrep(aBeta.r_lbls,'Amydala-L','amy.')


aBeta.fcmats = func_make_cmat(aBeta.fmat);
aBeta.wcmats = func_make_cmat(aBeta.wmat);


ext_f = func_make_cmat(aBeta.fmat(7:end,:,:));
ext_w = func_make_cmat(aBeta.wmat(7:end,:,:));

core_f = func_make_cmat(aBeta.fmat(1:6,:,:));
core_w = func_make_cmat(aBeta.wmat(1:6,:,:));


model = mean(ext_f{2},3);
model_ev = func_fit_RSA_model(ext_w{2},model);
[H,P,CI,STATS] = ttest(model_ev,model_ev1);
t_statement(STATS,P);




model = mean(core_f{2},3);
model_ev = func_fit_RSA_model(core_w{2},model);
[H,P,CI,STATS] = ttest(model_ev);
t_statement(STATS,P);





for i = 1:24

    
    
end
















