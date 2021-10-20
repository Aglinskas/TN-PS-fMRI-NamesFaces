%%plot inline

function statement= pretty_t_test_paired(vec1,vec2)
[H,P,CI,STATS] = ttest(vec1,vec2);

if P >= .001
statement = sprintf('t(%d) = %.2f, p = %.3f',STATS.df,STATS.tstat,P);
else
statement = sprintf('t(%d) = %.2f, p < .001',STATS.df,STATS.tstat);
end

end