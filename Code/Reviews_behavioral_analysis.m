ofn = '../Data/behav_data/'

load(fullfile(ofn,'faces_mat_RT.mat'))
behav.RT_faces = mat_RT
load(fullfile(ofn,'words_mat_RT.mat'))
behav.RT_words = mat_RT
load(fullfile(ofn,'faces_mat_resp.mat'))
behav.resp_faces = mat_resp
load(fullfile(ofn,'words_mat_resp.mat'))
behav.resp_words = mat_resp

%% Mean Reaction time

behav.RT_words(behav.RT_words < .5) = NaN; 
behav.resp_words(behav.RT_words < .5) = NaN; 

nanmean(behav.RT_faces(:))
nanmean(behav.RT_words(:))

disp( sprintf('RT names: M=%.4f sec,%.4f sec',nanmean(behav.RT_words(:)),nanstd(behav.RT_words(:))) )
disp( sprintf('RT faces: M=%.4f sec,%.4f sec',nanmean(behav.RT_faces(:)),nanstd(behav.RT_faces(:))) )
%% Reaction time by task


task_RT = squeeze(mean(nanmean(behav.RT_words,1),3))
%task_RT = squeeze(mean(nanstd(behav.RT_words,1),3))
task_std = squeeze(nanstd(nanmean(behav.RT_words,3),1))

[Y I] = sort(task_RT)
tasks = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common Name' 'How many facts' 'Occupation' 'Distinctiveness' 'Common Surname'}
for i = 1:10
disp(sprintf('%s RT = %.4f, SD = %.4f',tasks{I(i)},task_RT(I(i)),task_std(I(i))   ))
end

%% RT histograms
figure(1)
histogram(behav.RT_words(:))

figure(2)
histogram(behav.RT_faces(:))
%% Correct Responses

%imagesc(squeeze(nanmean(behav.resp_words,1)))

%correct_resp = [1 3 1 3 3 4 1 2 1 1 1 3 1 1 1 3 3 3 1 1 1 2 2 1 3 3 2 1 4 3 1 1 2 3 1 3 1 1 3 1];

%correct_resp = {1 3 1 3 3 4 1 2 1 1 1 3 1 1 1 3 3 3 1 1 1 2 2 1 3 3 2 1 4 3 1 1 2 3 1 3 1 1 3 1};

correct_resp = { 
[1]     % 'Angelina Jolie'
[3]     % 'Angelino Alfano'
[1 3]     % 'Arnold Schwarzenegger'
[3]     % 'Barack Obama'
[3]     % 'Bill Clinton'
[4]     % 'Bill Gates'
[1]     % 'Brad Pitt'
[1 2]     % 'Britney Spears'
[1]     % 'Cameron Diaz'
[1]     % 'Daniel Radcliffe'
[1 3 4]     % 'Donald Trump'
[3]     % 'Filippo Inzaghi'
[1]     % 'Fiorello'
[3]     % 'George Bush'
[1]     % 'George Clooney'
[3]     % 'Giorgia Meloni'
[3]     % 'Giorgio Napolitano'
[3]     % 'Hillary Clinton'
[1]     % 'Jim Carrey'
[1]     % 'Johnny Depp'
[1]     % 'Julia Roberts'
[2]     % 'Justin Bieber'
[2]     % 'Laura Pausini'
[1]     % 'Matt Damon'
[3]     % 'Matteo Renzi'
[3]     % 'Matteo Salvini'
[2]     % 'Michael Jackson'
[1]     % 'Michelle Hunziker'
[4]     % 'Michelle Obama'
[3]     % 'Mike Tyson'
[1]     % 'Paolo Bonolis'
[1 2 4]  % 'Paris Hilton'
[2]     % 'Rihanna'
[3]     % 'Roberto Maroni'
[1]     % 'Robin Williams'
[3]     % 'Romano Prodi'
[1]    % 'Sabrina Ferilli'
[1]    % 'Sandra Bullock'
[3]    % 'Silvio Berlusconi'
[1]    % 'Tom Cruise' 
}

names = {'Angelina Jolie'
'Angelino Alfano'
'Arnold Schwarzenegger'
'Barack Obama'
'Bill Clinton'
'Bill Gates'
'Brad Pitt'
'Britney Spears'
'Cameron Diaz'
'Daniel Radcliffe'
'Donald Trump'
'Filippo Inzaghi'
'Fiorello'
'George Bush'
'George Clooney'
'Giorgia Meloni'
'Giorgio Napolitano'
'Hillary Clinton'
'Jim Carrey'
'Johnny Depp'
'Julia Roberts'
'Justin Bieber'
'Laura Pausini'
'Matt Damon'
'Matteo Renzi'
'Matteo Salvini'
'Michael Jackson'
'Michelle Hunziker'
'Michelle Obama'
'Mike Tyson'
'Paolo Bonolis'
'Paris Hilton'
'Rihanna'
'Roberto Maroni'
'Robin Williams'
'Romano Prodi'
'Sabrina Ferilli'
'Sandra Bullock'
'Silvio Berlusconi'
'Tom Cruise'}

%correct_resp = arrayfun(@(x) {x},nanmedian(squeeze(behav.resp_faces(:,8,:))))


%inMat = behav.resp_words;
inMat = behav.resp_faces;
%inMat = cat(1,behav.resp_words,behav.resp_faces);
% clf;hold off
% for i = 1:40
%     subplot(8,5,i)
%     histogram(inMat(:,8,i))
%     title([num2str(i) ' : ' names{i}])
%     ylim([0 20])
% end

inMat = behav.resp_words
%inMat = behav.resp_faces

acc_vecs = [];
acc = [];
for s = 1:size(inMat,1)
resp_vec = squeeze(inMat(s,8,:))';
acc_vec = arrayfun(@(x) any(resp_vec(x)==correct_resp{x}),1:40);
acc_vecs = [acc_vecs;acc_vec];
acc = [acc mean(acc_vec)];
end
% 

%clc;disp(sprintf('M = %.2f%%,SD = %.2f',mean(acc)*100,std(acc)*100))


clc;disp(sprintf('M = %.2f%%,SD = %.2f,SEM = %.2f',mean(acc)*100,std(acc)*100,std(acc)*100/sqrt(size(inMat,1))    ))

%% Familiarity

inMat = behav.resp_words
%inMat = behav.resp_words
fammat = squeeze(inMat(:,5,:));
avgfam = nanmean(fammat);

disp(4-mean(avgfam))
%disp(max(abs(zscore(avgfam))))

histogram(zscore(avgfam),40)
morebins

%[Y I] = sort(avgfam)
%names(I)




line = sprintf(['M = %.0f%%, SD = %.0f%% indicated at least some familiarity'],mean(mean(fammat<4,2))*100,std(mean(fammat<4,2)*100  ))
disp(line)
%% Face - Name Response consistency

rdm_faces = pdist(squeeze(nanmean(behav.resp_faces,1)))
rdm_words = pdist(squeeze(nanmean(behav.resp_words,1)))

%corr(pdist(squeeze(nanmean(behav.resp_faces,1)))',pdist(squeeze(nanmean(behav.resp_words,1)))')
%corr(squeeze(mean(nanmean(behav.resp_faces,1),3))',squeeze(mean(nanmean(behav.resp_words,1),3))')


m1 = squeeze(nanmean(behav.resp_faces,1));
m2 = squeeze(nanmean(behav.resp_words,1));
t = [1,2,3,4,5,7,8,9]
m1 = m1(t,:)
m2 = m2(t,:)

corr(m1(:),m2(:),'type','Spearman')
%% Bar plot RT

ord = [2 9      3 4     1 5    7 8   6 10 ]
tasks = {'First memory' 'Attractiveness' 'Friendliness' 'Trustworthiness' 'Familiarity' 'Common Name' 'How many facts' 'Occupation' 'Distinctiveness' 'Common Surname'}
tasks = tasks(ord)
f = figure(1);clf

rtmat = squeeze(nanmean(nanmean(behav.RT_words,3),1))
rtmat = rtmat*1000
rtmat = rtmat(ord)

b = bar(rtmat)

ylabel('RT (msec)')
xticklabels(tasks)
f.Color = [1 1 1]
box off
f.CurrentAxes.LineWidth = 3
f.CurrentAxes.FontSize = 16
f.CurrentAxes.FontWeight = 'bold'
b.LineWidth = 3
title('Reaction Time by Task')



exportgraphics(f, '../Figures/RT_bargraph.png');
%%







