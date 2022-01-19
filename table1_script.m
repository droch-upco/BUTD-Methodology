clear
clc

load('indicadores_sinteticos_v4.mat')

anexo1_ideal = indicador_sintetico_anexo_1;

load('indicador_sintetico_anexo_1_estimado.mat')

anexo1_real = indicador_sintetico_anexo_1_estimado(:,1:3);

clearvars -except anexo1_ideal anexo1_real

load('DP_80_20.mat')
load('gini.mat')

[Codigo,Municipios] = xlsread('Codigo_Municipios.xlsx','Codigo_Municipios');

ANIOS = [{'2015'} {'2016'} {'2017'}];

years = size(ANIOS,2);

N = size(Codigo,1);

NOMBRES = Municipios;
NManc = size(NOMBRES,1);

load('datos_Almudena_v4.mat')

X = datos_indicadores_corregidos;

X = X(:,9:11,:);

%% Mujeres a porcentaje (per cápita)

I = 3;

X(I,:,:) = X(I,:,:)./X(1,:,:)*100;

%% Attach GINI and 80/20

X = [X; NaN(2,3,178)];
X(58,:,:) = DP_80_20';
X(59,:,:) = gini';

lista_indicadores_FILTRADA = [lista_indicadores_FILTRADA; [ {[]} {'DP_80_20'}];
    [ {[]} {'GINI'}]];


%% Summary Statistics Table


[~,rank_benchmark] = sort(anexo1_ideal,'descend','MissingPlacement','last');

amount_nan = sum(isnan(anexo1_ideal));
amount_nan = amount_nan(1,1);

Indicators = [{'GINI'};{'DP_80_20'};{'  Per cápita (euros)'};{'Población empadronada'}];

Deciles = [{rank_benchmark(1:17)'}; {rank_benchmark(18:34)'};...
    {rank_benchmark(35:51)'};{rank_benchmark(52:68)'};...
    {rank_benchmark(69:85)'};{rank_benchmark(86:102)'};...
    {rank_benchmark(103:119)'};{rank_benchmark(120:136)'};...
    {rank_benchmark(137:152)'};{rank_benchmark(153:168)'};];

Indicator_names = [{'Income inequality (benchmark)'};{'Income inequality (synthetic)'};
    {'GINI'};{'80/20 ratio'};{'GDP per capita'};{'Population size'}];

Summary_Means = zeros(11,size(Indicator_names,1),3);

for i =1:size(Indicators,1)
    index = find(strcmp(lista_indicadores_FILTRADA(:,2), Indicators{i}));
    index = index(1,1);
    X_temp = squeeze(X(index,:,:))';  
    for j = 1:10
        Summary_Means(j,i+2,:) = nanmean(X_temp(Deciles{j,1},:));
    end
end

for i =1:size(Indicators,1)
    index = find(strcmp(lista_indicadores_FILTRADA(:,2), Indicators{i}));
    index = index(1,1);
    X_temp = squeeze(X(index,:,:))';  
    Summary_Means(end,i+2,:) = nanmean(X_temp);
end



for j = 1:10
    Summary_Means(j,1,:) = nanmean(anexo1_ideal(Deciles{j,1},:));   
    Summary_Means(j,2,:) = nanmean(anexo1_real(Deciles{j,1},:));
end

Summary_Means(end,1,:) = nanmean(anexo1_ideal);
Summary_Means(end,2,:) = nanmean(anexo1_real);

summary_2015_means = array2table(Summary_Means(:,:,1));
summary_2015_means.Properties.VariableNames = Indicator_names;
summary_2015_means.Properties.RowNames = [{'Decile 10'} {'Decile 9'} ...
    {'Decile 8'} {'Decile 7'} {'Decile 6'} {'Decile 5'} {'Decile 4'} ...
    {'Decile 3'} {'Decile 2'} {'Decile 1'} {'Total'}];

summary_2016_means = array2table(Summary_Means(:,:,2));
summary_2016_means.Properties.VariableNames = Indicator_names;
summary_2016_means.Properties.RowNames = [{'Decile 10'} {'Decile 9'} ...
    {'Decile 8'} {'Decile 7'} {'Decile 6'} {'Decile 5'} {'Decile 4'} ...
    {'Decile 3'} {'Decile 2'} {'Decile 1'} {'Total'}];

summary_2017_means = array2table(Summary_Means(:,:,3));
summary_2017_means.Properties.VariableNames = Indicator_names;
summary_2017_means.Properties.RowNames = [{'Decile 10'} {'Decile 9'} ...
    {'Decile 8'} {'Decile 7'} {'Decile 6'} {'Decile 5'} {'Decile 4'} ...
    {'Decile 3'} {'Decile 2'} {'Decile 1'} {'Total'}];