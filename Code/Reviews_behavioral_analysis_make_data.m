clear all
words_fn_temp = '/Volumes/Samsung_T5/HDD/TN/PhD_Data/fMRI_Projects/Data_words/S%d/wS%d_Results.mat';
ofn = '/Users/aidasaglinskas/Desktop/lol/'

%svec_w = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
svec_w = [9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
%svec_f = [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31];

allRT = []

nsubs = length(svec_w)

mat_RT = zeros(nsubs,10,40);
mat_resp= zeros(nsubs,10,40);
for s = 1:nsubs

clear myTrials
load(sprintf(words_fn_temp,svec_w(s),svec_w(s)));

writetable(struct2table(myTrials),fullfile(ofn,sprintf('words_myTrials_%d.csv',svec_w(s))))


for i = 1:640
    if isempty(myTrials(i).RT);
        myTrials(i).RT = NaN;    
    end
    
    if isempty(myTrials(i).response);
        myTrials(i).response = NaN;    
    elseif ~isnumeric(myTrials(i).response)
        myTrials(i).response = str2num(myTrials(i).response(1));
    end

end


for b = 1:10
blockTrials = myTrials([myTrials.blockNum]==b);
[~,index] = sortrows({blockTrials.filepath}.'); blockTrials = blockTrials(index); clear index
mat_RT(s,b,:) = [blockTrials.RT];
mat_resp(s,b,:) = [blockTrials.response];


names = cell(1,40);
a = {blockTrials.filepath}';
for i = 1:length(a)
temp = strsplit(a{i},'/');
temp = temp{2};
names{i} = temp;
end

end

end % ends subjects

squeeze(mat_RT(s,:,:))
%% 



save(fullfile(ofn,'words_mat_RT.mat'),'mat_RT')
save(fullfile(ofn,'words_mat_resp.mat'),'mat_resp')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
words_fn_temp = '/Volumes/Samsung_T5/HDD/TN/Test/Data_faces/S%d/S%d_ScannerMyTrials_RBLT.mat';
ofn = '/Users/aidasaglinskas/Desktop/lol/'

%svec_w = [1 2 5 6 7 8 9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
%svec_w = [9 10 13 14 15 16 17 19 20 22 23 24 26 27 28 29 30 31];
svec_f = [7 8 9 10 11 14 15 17 18 19 20 21 22 24 25 27 28 29 30 31];
svec_w = svec_f;

allRT = []

nsubs = length(svec_w)

mat_RT = zeros(nsubs,10,40);
mat_resp= zeros(nsubs,10,40);
for s = 1:nsubs

clear myTrials
load(sprintf(words_fn_temp,svec_w(s),svec_w(s)));

writetable(struct2table(myTrials),fullfile(ofn,sprintf('faces_myTrials_%d.csv',svec_w(s))))


for i = 1:640
    if isempty(myTrials(i).RT);
        myTrials(i).RT = NaN;    
    end
    
    if isempty(myTrials(i).resp);
        myTrials(i).resp = NaN;    
    elseif ~isnumeric(myTrials(i).resp)
        myTrials(i).resp = str2num(myTrials(i).resp(1));
    end

end


for b = 1:10
blockTrials = myTrials([myTrials.blockNum]==b);
[~,index] = sortrows({blockTrials.filepath}.'); blockTrials = blockTrials(index); clear index
mat_RT(s,b,:) = [blockTrials.RT];
mat_resp(s,b,:) = [blockTrials.resp];
end

end % ends subjects

squeeze(mat_RT(s,:,:))
%% 



save(fullfile(ofn,'faces_mat_RT.mat'),'mat_RT')
save(fullfile(ofn,'faces_mat_resp.mat'),'mat_resp')




