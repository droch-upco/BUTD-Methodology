clear
clc

load('indicadores_sinteticos_v4.mat')

anexo1_ideal = indicador_sintetico_anexo_1;

load('indicador_sintetico_anexo_1_estimado.mat')

anexo1_real = indicador_sintetico_anexo_1_estimado(:,1:3);

clearvars -except anexo1_ideal anexo1_real

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


%% Summary Statistics Table

[~,rank_benchmark] = sort(anexo1_real,'descend');

Indicators = [{'Población empadronada'};{'  Per cápita (euros)'};{'   Mujeres'};...
    {'Densidad de población'}];

Deciles = [{rank_benchmark(1:18)'}; {rank_benchmark(19:36)'};...
    {rank_benchmark(37:54)'};{rank_benchmark(55:72)'};...
    {rank_benchmark(73:90)'};{rank_benchmark(91:108)'};...
    {rank_benchmark(109:126)'};{rank_benchmark(127:144)'};...
    {rank_benchmark(145:161)'};{rank_benchmark(162:178)'};];

Indicator_names = [{'Income inequality (synthetic)'};{'Income inequality (benchmark)'};
    {'Population Size'};{'GDP per capita'};{'Female Population'};{'Population Density'}];

Summary_Means = zeros(11,size(Indicator_names,1),3);
Summary_Std = zeros(11,size(Indicator_names,1),3);

for i =1:size(Indicators,1)
    index = find(strcmp(lista_indicadores_FILTRADA(:,2), Indicators{i}));
    index = index(1,1);
    X_temp = squeeze(X(index,:,:))';  
    for j = 1:10
        Summary_Means(j,i+2,:) = mean(X_temp(Deciles{j,1},:));
        Summary_Std(j,i+2,:) = std(X_temp(Deciles{j,1},:));
    end
end

for i =1:size(Indicators,1)
    index = find(strcmp(lista_indicadores_FILTRADA(:,2), Indicators{i}));
    index = index(1,1);
    X_temp = squeeze(X(index,:,:))';  
    Summary_Means(end,i+2,:) = mean(X_temp);
    Summary_Std(end,i+2,:) = std(X_temp);
end



for j = 1:10
    Summary_Means(j,1,:) = nanmean(anexo1_ideal(Deciles{j,1},:));
    Summary_Std(j,1,:) = nanstd(anexo1_ideal(Deciles{j,1},:));
    
    Summary_Means(j,2,:) = nanmean(anexo1_real(Deciles{j,1},:));
    Summary_Std(j,2,:) = nanstd(anexo1_real(Deciles{j,1},:));
end

Summary_Means(end,1,:) = nanmean(anexo1_ideal);
Summary_Std(end,1,:) = nanstd(anexo1_ideal);

Summary_Means(end,2,:) = nanmean(anexo1_real);
Summary_Std(end,2,:) = nanstd(anexo1_real);

summary_2015_means = array2table(Summary_Means(:,:,1));
summary_2015_means.Properties.VariableNames = Indicator_names;
summary_2015_means.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];

summary_2015_std = array2table(Summary_Std(:,:,1));
summary_2015_std.Properties.VariableNames = Indicator_names;
summary_2015_std.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];



summary_2016_means = array2table(Summary_Means(:,:,2));
summary_2016_means.Properties.VariableNames = Indicator_names;
summary_2016_means.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];

summary_2016_std = array2table(Summary_Std(:,:,2));
summary_2016_std.Properties.VariableNames = Indicator_names;
summary_2016_std.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];

summary_2017_means = array2table(Summary_Means(:,:,3));
summary_2017_means.Properties.VariableNames = Indicator_names;
summary_2017_means.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];

summary_2017_std = array2table(Summary_Std(:,:,3));
summary_2017_std.Properties.VariableNames = Indicator_names;
summary_2017_std.Properties.RowNames = [{'Decile 1'} {'Decile 2'} ...
    {'Decile 3'} {'Decile 4'} {'Decile 5'} {'Decile 6'} {'Decile 7'} ...
    {'Decile 8'} {'Decile 9'} {'Decile 10'} {'Total'}];


