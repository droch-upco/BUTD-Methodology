clc,clear,close all;
load('datos_Almudena_v4.mat');
load('DatosSimulaciones_v5.mat');
load('indicadores_sinteticos_v4.mat');
numero_municipios=178;
n_anios_sintetico_disponible=3;
n_anios=6;
indicador_sintetico_anexo_1_estimado=NaN(numero_municipios,n_anios);
X_quitada_nan=X;
X_quitada_nan(isnan(X_quitada_nan))=0;
valores_deciles=prctile([1:numero_municipios],[0:10:90])%como luego el orden es descendente,el decil 0 es el 10 y el 9 es el 1

for anio=1:n_anios
    indicador_sintetico_anexo_1_estimado(:,anio)=sum(X_quitada_nan(:,:,anio).*coeficientes_AyudasSociales',2);
end
%% Ajuste intercept OPT 1
indicador_sintetico_anexo_1_estimado=indicador_sintetico_anexo_1_estimado+intercept(1);
%% Los ordenamos
[indicador_sintetico_anexo_1_estimado_ordenado,orden]=sort(indicador_sintetico_anexo_1_estimado(:,1:3),1,'descend');
orden_bien_para_indexar=orden;
orden_bien_para_indexar(:,2)=size(orden,1)+orden(:,2);
orden_bien_para_indexar(:,3)=size(orden,1)*2+orden(:,3);
indicador_sintetico_anexo_1_ordenado=indicador_sintetico_anexo_1(orden_bien_para_indexar);
%%
%%Comparación sintetico vs estimado
for anio=1:n_anios_sintetico_disponible
    figure(2);
    subplot(n_anios_sintetico_disponible,1,anio)
    plot(indicador_sintetico_anexo_1_ordenado(:,anio),'o');
    hold on;
    plot(indicador_sintetico_anexo_1_estimado_ordenado(:,anio),'Linewidth',2);
    ylabel ({'Value of the', 'composite indicator'})
    grid on;
    if anio==1
        legend('Benchmark','Synthetic');
        title (sprintf('Year %d',2014+anio));
    else
        title (sprintf('Year %d',2014+anio));
    end
    xticks([valores_deciles]);
    ax = gca;
    xticklabels({'Decile 10','Decile 9','Decile 8','Decile 7','Decile 6','Decile 5','Decile 4','Decile 3','Decile 2','Decile 1'})
end