load('aBeta2.mat')
aBeta

clf
aBeta.rlbls = aBeta.r_lbls;
aBeta.tlbls10 = aBeta.t_lbls10;

rois = {'ATFP-L' 'ATFP-R' 'ATL-L' 'ATL-R' 'AMY-L' 'AMY-R' 'AG-L' 'AG-R' 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'PREC' 'dmPFC' 'vmPFC'};
r_idx = ismember(aBeta.rlbls,rois);
clf
m = mean(mean(aBeta.wmat(7:21,:,:),3),2);
se = mean(std(aBeta.wmat(7:21,:,:),[],3),2) ./ sqrt(24);

%'OFA-L' 'OFA-R' 'FFA-L' 'FFA-R' 'pSTS-L' 'pSTS-R' 'IFG-L' 'IFG-R' 'OFC-L' 'OFC-R' 'ATFP-L' 'ATFP-R' 'AMY-L' 'AMY-R' 'ATL-L' 'ATL-R' 'AG-L' 'AG-R' 'PREC' 'dmPFC' 'vmPFC'
rlbls = aBeta.r_lbls(7:21)
nrois = length(aBeta.r_lbls)
group{1} = {'IFG-L' 'OFC-L' 'ATFP-L' 'AMY-L' 'ATL-L' 'AG-L'}
group{2} = {'IFG-R' 'OFC-R' 'ATFP-R' 'AMY-R' 'ATL-R' 'AG-R'}
group{3} = {'PREC' 'dmPFC' 'vmPFC'}

%xs = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15]
xs = [1 2   4 5  7 8  10 11  13 14  16 17  19 20.5 22]
%xs(2:2:15) = xs(2:2:15)+1
xt = [1.5 4.5 7.5 10.5 13.5 16.5 19 20.5 22] 
xl = {'IFG' 'OFC' 'ATFP' 'AMY' 'ATL' 'AG' 'PREC' 'dmPFC' 'vmPFC'}
idx = []
idx(:,1) = ismember(rlbls,group{1})
idx(:,2) = ismember(rlbls,group{2})
idx(:,3) = ismember(rlbls,group{3})

f = figure(1)
hold on

h = {}
for g = 1:3
x = xs(1:15)
plot_m = m
plot_se = se

plot_m(~idx(:,g)) = 0
plot_se(~idx(:,g)) = 0

h{g} = bar(x,plot_m);hold on;
h{g}.LineWidth = 2
h{g}.FaceAlpha = .8
he = errorbar(x,plot_m,plot_se,'LineStyle','none', 'Color', 'r')
he.LineWidth=2
end

xticks(xt)
xticklabels(xl)
xtickangle(45)

f.Color = [1 1 1]
f.CurrentAxes.LineWidth = 2
f.CurrentAxes.FontSize = 14
f.CurrentAxes.FontWeight = 'bold'
ylabel('response magnitude (?)')
l = legend({'Left' '' 'Right' '' 'Medial'})
legend([h{1} h{2} h{3}],'location','bestoutside')
title(l,'Hemisphere')

valrng = min(xlim):max(xlim)
plot(valrng,zeros(length(valrng),1),'k','LineWidth',2)
xlim([min(valrng),max(valrng)])
%l.String(end) = []

%star1 = [1 3 4 7 9 11 12 13 14 15]
star1 = [1 3 4 9 11 12 13 14 15]
arrayfun(@(i) text(xs(i)-h{g}.BarWidth/2,0+.025,'*','fontsize',35,'fontname','American Typewriter'),star1)

star2 = [1 3 4 9 11 12 13 14 15]
%arrayfun(@(i) text(xs(i),.2+.025,'*','fontsize',35,'fontname','American Typewriter'),star2)
arrayfun(@(i) text(xs(i)-h{g}.BarWidth/2,.2+.025,'*','fontsize',35,'fontname','American Typewriter'),star2)

saveas(f,'/Users/aidasaglinskas/Desktop/fig.png')
%%





%l.String(2) = []
%l.String(2) = []
%bar(m);hold on;
%errorbar(m,se,'r.')
%xticklabels(aBeta.rlbls(7:21))
%xtickangle(65)
%box off



tbl = [3	-52	29
39	17	23
-36	20	26
-60	-7	-19
57	-7	-19
-21	-10	-13
21	-7	-16
6	59	23
3	50	-19
33	35	-13
-33	35	-13
33	-10	-40
-36	-10	-34
-48	-67	35
42	-64	35]
%%

rnames = {'	Precuneus	Medial	'
'	IFG	Right	'
'	IFG	Left	'
'	ATL	Right	'
'	Amygdala	Left	'
'	Amygdala	Left	'
'	Amygdala	Right	'
'	dmPFC	Medial	'
'	vmPFC	Medial	'
'	OFC	Right	'
'	OFC	Left	'
'	ATFP	Right	'
'	ATFP	Left	'
'	Angular Gyrus	Left	'
'	Angular Gyrus	Right	'}

%%

%spm_mip_ui('GetCoords')
r = r+1
spm_mip_ui('SetCoords',tbl(r,:))
clc;disp(rnames{r})
disp(tbl(r,:))

