clear,clear,close all;
load('Resultados_genetico.mat') 
addpath([pwd '/data']);
    
y = Y(:,1,:);
y = [y(:,:,1);y(:,:,2);y(:,:,3)];

x = X(:,selection(:,1) == 1,:);

x = [x(:,:,1);x(:,:,2);x(:,:,3)];
x = [ones(size(x,1),1) x];
[b,bint,r,rint,stats] = regress(y,x);
Coeficientes = b(2:end);
intercept = b(1,1);
R2= stats(1,1);


coeficientes_AyudasSociales = Coeficientes(:,1);
Ymatrix = Y(:,1,:);
Ymatrix = [Ymatrix(:,:,1);Ymatrix(:,:,2);Ymatrix(:,:,3)];
Xmatrix = x(:,2:end);
mdl = fitlm(Xmatrix,Ymatrix);
pvalue=mdl.Coefficients(2:end,4);
