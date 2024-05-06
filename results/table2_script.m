clear
clc
close all
addpath([pwd '/data']);
load('Resultados_genetico.mat') 

T = 3;

table2_results = cell(T,1);
R2 = cell(T,1);
intercept = cell(T,1);
p_val_intercept = cell(T,1);

for t = 1:T

y = Y(:,1,1:t);
y = reshape(y,[size(y,1)*t,1]);

x = X(:,selection{t,1}==1,1:t);

temp = [];

for t1 = 1:t
    temp = [temp; squeeze(x(:,:,t1))];
end

x = temp;

x = [ones(size(x,1),1) x];
[b,bint,r,rint,stats] = regress(y,x);
Coeficientes = b(2:end);
intercept{t,1} = b(1,1);
R2{t,1} = stats(1,1);

coeficientes_AyudasSociales = Coeficientes(:,1);
Ymatrix = Y(:,1,1:t);
Ymatrix = reshape(Ymatrix,[size(Ymatrix,1)*t,1]);
Xmatrix = x(:,2:end);
mdl = fitlm(Xmatrix,Ymatrix);
pvalue=mdl.Coefficients(2:end,4);
p_val_intercept{t,1} = mdl.Coefficients(1,4);
pvalue=pvalue{:,:};
table2_results{t,1} = addvars(ANEXO1_Coef{t,1},pvalue);
table2_results{t,1}.Properties.VariableNames = {'weight' 'pvalue'};

end

clearvars -except table2_results R2 intercept p_val_intercept

save Regression_Results
