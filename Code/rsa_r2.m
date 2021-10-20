function r = rsa_r2(data,model)

r = corr(get_triu(mean(data,3))',get_triu(mean(model,3))');
disp(sprintf('r = %.2f / r2 = %.2f',r,r^2))

end