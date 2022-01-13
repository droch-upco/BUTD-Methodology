clear
clc
load('Resultados_genetico.mat') 

    
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

%% Explained Variance

B = table2array(mdl.Coefficients(:,1));
B = B(2:end,:);
Var_Cov = cov(Xmatrix,'omitrows');

Ap_Var = zeros(size(Var_Cov));

for i = 1:size(Ap_Var,1)
   for j = 1:size(Ap_Var,2)
      Ap_Var(i,j) = B(i)*B(j)*Var_Cov(i,j); 
   end
    
end

Var_total = var(Ymatrix,'omitnan');
Pesos_Var = sum(Ap_Var/Var_total*100);
table_Pesos_Var = table(Pesos_Var','RowNames',ANEXO1_Coef.Properties.RowNames);


%save('DatosSimulaciones.mat','X','coeficientes_AyudasSociales',...
    %'coeficientes_Infantil','lista_indicadores','intercept','R2')