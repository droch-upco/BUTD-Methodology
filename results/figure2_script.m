clc
clear
close all

load Resultados_genetico.mat
load Regression_Results.mat

N = size(Y,1);

T = 3;

indicador_sintetico_anexo_1 = Y;
indicador_sintetico_anexo_1_estimado = cell(T,1);

year = [{'2015'} {'2016'} {'2017'}];

for t = 1:T

    indicador_sintetico_anexo_1_estimado{t,1} = NaN(N,T);
    X_quitada_nan = X(:,selection{t,1}==1,1:T);
    X_quitada_nan(isnan(X_quitada_nan))=0;
    valores_deciles=prctile([1:N],[0:10:90]);%como luego el orden es descendente,el decil 0 es el 10 y el 9 es el 1
    
    coeficientes_AyudasSociales = table2array(ANEXO1_Coef{t,1});
    
    for anio=1:T
        indicador_sintetico_anexo_1_estimado{t,1}(:,anio)=sum(X_quitada_nan(:,:,anio).*coeficientes_AyudasSociales',2);
    end
    %% Ajuste intercept OPT 1
    indicador_sintetico_anexo_1_estimado{t,1}=indicador_sintetico_anexo_1_estimado{t,1}+intercept{t,1}(1);
    %% Los ordenamos
    [indicador_sintetico_anexo_1_estimado_ordenado,orden]=sort(indicador_sintetico_anexo_1_estimado{t,1}(:,1:3),1,'descend');
    orden_bien_para_indexar=orden;
    orden_bien_para_indexar(:,2)=size(orden,1)+orden(:,2);
    orden_bien_para_indexar(:,3)=size(orden,1)*2+orden(:,3);
    indicador_sintetico_anexo_1_ordenado=indicador_sintetico_anexo_1(orden_bien_para_indexar);
    %%
    %%Comparación sintetico vs estimado
    h = figure;
    h.WindowState = "maximized";
        for anio=1:T
            subplot(T,1,anio)
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
            set(gca,'FontSize',13)
        end
    filename = ['Figure 2_' year{1,t} '.png'];
    saveas(h,filename)

end

save indicadores_estimados indicador_sintetico_anexo_1_estimado indicador_sintetico_anexo_1
