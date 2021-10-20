function model = make_model(lbls,model_spec)

n = length(lbls);
g = length(model_spec);

model = zeros(n);
for g  = 1:g
model(ismember(lbls,model_spec{g}),ismember(lbls,model_spec{g}))=1;
end

end