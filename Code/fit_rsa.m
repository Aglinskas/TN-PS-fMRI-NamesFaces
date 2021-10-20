function model_fit = fit_rsa(data,model)

n = size(model,1);
e = 1:n;
model(logical(eye(size(model)))) = 0;
e = sum(model)~=0;
model = model(e,e);

idx = find(triu(ones(size(model)),1));
nsubs = size(data,3);
model_fit = nan(1,nsubs);


for s = 1:nsubs
subdata = data(e,e,s);
model_fit(s) = corr(subdata(idx),model(idx));
%model_fit(s) = corr(get_triu(subdata)',get_triu(model)');
end


end