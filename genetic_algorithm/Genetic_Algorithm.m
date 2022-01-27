clear
clc

global Y1 X i

%% Load data

tic

load('datos_Almudena_v4.mat')
load('datos_Almudena_tratados.mat')
load('indicadores_sinteticos.mat')

datos_indicadores = X;

YEARS_NAME = [1989
        1999
        2003
        2007
        2009
        2011
        2013
        2014
        2015
        2016
        2017
        2018
        2019
        2020];
    
[COD,Municipios] = xlsread('Codigo_Municipios.xlsx');

N = size(Municipios,1);                                                     % Número de Municipios

K = 57;                                                                     % Número de Indicadores
years = 3;                                                                  % Número de años

%% Input data

Y = zeros(N,1,years);                                                         % Indicadores objetivos

X = NaN(N,K,years);
X(:,:,1) = (squeeze(datos_indicadores(:,YEARS_NAME==2015,:)))';
X(:,:,2) = (squeeze(datos_indicadores(:,YEARS_NAME==2016,:)))';
X(:,:,3) = (squeeze(datos_indicadores(:,YEARS_NAME==2017,:)))';
X(:,:,4) = (squeeze(datos_indicadores(:,YEARS_NAME==2018,:)))';
X(:,:,5) = (squeeze(datos_indicadores(:,YEARS_NAME==2019,:)))';
X(:,:,6) = (squeeze(datos_indicadores(:,YEARS_NAME==2020,:)))';

X = X(:,[1 3 5:7 11:13 15 17:18 20:21 23:25 27 29 31 33:34 36:48 50 52:53 56:57],:);
lista_indicadores_FILTRADA2 = lista_indicadores_FILTRADA([1 3 5:7 11:13 15 17:18 ...
    20:21 23:25 27 29 31 33:34 36:48 50 52:53 56:57],:);

%% Indicadores objetivo y tratamiento
Y(:,1,:) = indicador_sintetico_anexo_1;

%% Algoritmo genético

nvars = size(X,2);                                                          % Tamaño de bit string
selection = zeros(size(X,2),1);                                             % Matrix for selected variables
Coeficientes = cell(1,1);                                                        % Weights for selected variables
Weights = cell(1,1);                                                        % Weights for selected variables

P0 = cell(1,1);                                                              % Cell to save initial populations to seed GA
P0{1,1} = ([ones(1,39); [0 zeros(1,21) 1 zeros(1,16)];...
    [0;1;0;1;1;1;1;0;0;1;1;0;0;0;0;0;0;1;1;1;0;0;1;1;0;0;0;0;0;1;0;0;1;0;0;1;0;1;1]']);


exitflag = cell(1,1);
output = cell(1,1);
population = cell(1,1);
scores = cell(1,1);

i = 1;
    
Y1 = Y(:,i,:);
options = optimoptions(@ga);
options.PopulationType = 'bitString';       
options.InitialPopulation = P0{i,1};
[x,fval,exitflag{i,1},output{i,1},population{i,1},scores{i,1}] = ...
    ga(@fobj,nvars,options);                                                % Estimate genetic algorithm
selection(:,i) = x';


 
%% Estimar resultados

x = X;
x = [x(:,:,1); x(:,:,2); x(:,:,3)];

i = 1;
y = Y(:,i,:);
y = [y(:,:,1); y(:,:,2); y(:,:,3)];

x1 = x(:,selection(:,i)==1);

mdl = fitlm(x1,y);
Coeficientes{i,1} = table2array(mdl.Coefficients(2:end,1));
Weights{i,1} = table2array(mdl.Coefficients(2:end,1))/...
    sum(table2array(mdl.Coefficients(2:end,1)));
    


lista_indicadores = [{'Poblacion'},{'Mujeres'},{'Juventud'}...
    ,{'Mayores'},{'Dependencia'},...
    {'Extranjeros'},{'Mujeres_Extranjeras'},{'Afiliados_SS'},{'Afiliadas_Mujeres_SS'},...
    {'Afiliados_Extranjeros'},{'Afiliados_Menores_30'},{'Afiliados_Mayores_50'},{'Paro'},...
    {'Paro_Mujeres'},{'Paro_Variacion'},{'Paro_Menores_25'},{'Paro_Menores_25_Mujeres'},{'Paro_Extranjeros'},{'Contratos_Mujeres'},...
    {'Contratos_Comunitarios'},{'Contratos_Extracomunitarios'},{'Contratos_Temporales'},...
    {'Inverso_PIB_PerCapita'},{'Declaraciones'},{'Base_Imponible_Total'},...
    {'Rendimiento_Trabajo'},{'Base_Imponible_Ahorro'},{'Base_Inverso_PIB_PerCapita'},...
    {'Base_Imponible_Urbana'},{'Energia_Electrica'},{'Porcentaje_Educacion'},...
    {'Por_Profesor'},{'Por_Unidad_Escolar'},{'Educacion_Publica'},{'Consultorios'},...
    {'Agua'},{'Turismos'},{'Densidad'},{'RMI'}];

lista_indicadores = lista_indicadores';
ANEXO1_Coef = table(Coeficientes{1,1},'rowNames',lista_indicadores(selection(:,1)==1,1));

ANEXO1_Pesos = table(Weights{1,1},'rowNames',lista_indicadores(selection(:,1)==1,1));

toc

save('Resultados_genetico','Y','X','ANEXO1_Coef','selection','lista_indicadores')
