%%plot inline
function statement = pretty_t_test_one_sample(vec1)

[H,P,CI,STATS] = ttest(vec1);

if P >= .001
statement = sprintf('t(%d) = %.2f, p = %.3f',STATS.df,STATS.tstat,P);
%disp(statement);
else
statement = sprintf('t(%d) = %.2f, p < .001',STATS.df,STATS.tstat);
%disp(statement);
end

end