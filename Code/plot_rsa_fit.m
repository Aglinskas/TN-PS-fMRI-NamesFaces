function plot_models(arr,arr_lbls)

%f = gcf;clf;
%arr = {fit_epBio fit_nomBio}
%arr_lbls = {'ep + bio' 'nom + bio'}
n = length(arr{1});
for x = 1:length(arr);
m = mean(arr{x});
se = std(arr{x}) ./ sqrt(n);
bar(x,m,'facecolor',[0 114 189]/255,'LineWidth',2,'facealpha',.5);hold on;
errorbar(x,m,se,'r ','linewidth',2);
end

xticks(1:length(arr));
xticklabels(arr_lbls);
xtickangle(45);
f.CurrentAxes.FontSize = 14;
f.CurrentAxes.FontWeight = 'bold';
f.Color = [1 1 1];
box off;
