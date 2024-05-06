clear
clc
close all
addpath([pwd '/data']);
load Resultados_genetico.mat
load indicadores_estimados.mat

addpath("GIS_data")

year = [{'2015'} {'2016'} {'2017'}];


T = 3;

correlations = cell(T,1);


for t = 1:T

    correlations{t,1} = nan(T,1);

    for t2 = 1:T

        anexo1_ideal = indicador_sintetico_anexo_1(:,t2);
        
        anexo1_real = indicador_sintetico_anexo_1_estimado{t,1}(:,t2);
        
        temp = corrcoef(anexo1_real,anexo1_ideal,'Rows','pairwise');

        correlations{t,1}(t2,1) = temp(1,2);
        
        [Codigo,Municipios] = xlsread('Codigo_Municipios.xlsx','Codigo_Municipios');
        N = size(Codigo,1);
        
        NOMBRES = Municipios;
        NManc = size(NOMBRES,1);
        
        %% Simulación Ideal
        
        Asig_anexo1_ideal = NaN(NManc,1);
        
        for i = 1:NManc
            
            if isempty(find(strcmp(Municipios, NOMBRES{i,1})))
                Asig_anexo1_ideal(i,:) = nansum(anexo1_ideal(Manc(:,i-37)==1,:));
            else
                Asig_anexo1_ideal(i,:) = anexo1_ideal(find(strcmp...
                    (Municipios, NOMBRES{i,1})),:);
            end
            
        end
        
        TABLE_ideal_2017 = table(Asig_anexo1_ideal(:,1));
        TABLE_ideal_2017.Properties.VariableNames = {'Social'};
        TABLE_ideal_2017.Properties.RowNames = NOMBRES;
        
        %% Simulación indicadores
        
        Asig_anexo1_real = NaN(NManc,1);
        
        for i = 1:NManc
            
            if isempty(find(strcmp(Municipios, NOMBRES{i,1})))
                Asig_anexo1_real(i,:) = nansum(anexo1_real(Manc(:,i-37)==1,:));
            else
                Asig_anexo1_real(i,:) = anexo1_real(find(strcmp...
                    (Municipios, NOMBRES{i,1})),:);
            end
            
        end
        
        TABLE_real_2017 = table(Asig_anexo1_real(:,1));
        TABLE_real_2017.Properties.VariableNames = {'Social'};
        TABLE_real_2017.Properties.RowNames = NOMBRES;
        
        %% Estimar diferencia
        TABLE_dif_2017 =  table(Asig_anexo1_real(:,1)-Asig_anexo1_ideal(:,1));
        TABLE_dif_2017.Properties.VariableNames = {'Social'};
        TABLE_dif_2017.Properties.RowNames = NOMBRES;
        
        %% Mapas
        
        EELL = NOMBRES;
        
        temp = cell(size(EELL));
        temp2 = xlsread('Codigo_Municipios.xlsx','Mapas');
        
        i = 1;
        while i <= size(temp,1)
           temp{i} = temp2(i,:); 
           temp{i}= temp{i}(~isnan(temp{i}));
           i = i+1;
        end
        
        EELL = [EELL temp];
        S = shaperead('ESP_adm4.shp');
        S = S(strcmp({S.NAME_1}, 'Comunidad de Madrid'));
        
        %% 2017
        difANEXO1_ideal = Asig_anexo1_ideal(:,1)-nanmean(Asig_anexo1_ideal(:,1));
        
        difANEXO1_real = Asig_anexo1_real(:,1)-nanmean(Asig_anexo1_real(:,1));
        
        
        difANEXO1_ideal = round(difANEXO1_ideal,3);
        difANEXO1_real = round(difANEXO1_real,3);
        
        colorrange1 = [min(difANEXO1_real) max(difANEXO1_real)];
        colorrange2 = [min(difANEXO1_ideal) max(difANEXO1_ideal)];
        colorrange = [min(colorrange1(1,1),colorrange2(1,1))...
            max(colorrange1(1,2),colorrange2(1,2))];
        
        
        colorindex = round((colorrange(1,1):0.001:colorrange(1,2))',3);
        [~,ia] = ismember(difANEXO1_ideal,colorindex);
        
        
        % Anexo 1
        Fig = figure('WindowState','maximized');
        
        figure1 = tiledlayout(1,2,'TileSpacing','Compact');
        
        %title(figure1,'Income Inequality for the Province of Madrid in 2017') 
        
        %subplot(1,2,1)
        nexttile
        mapshow(S);
        
        data = colormap(hot(size(colorindex,1)));
        data = flipud(data);
        
        i = 1;
        while i <= NManc
            % FaceColor is now a color from the current colormap, determined by
            % it's data value
            temp = EELL{i,2};
            if ia(i) == 0
                mapshow(S(temp),'FaceColor',[0.5 0.5 0.5])      
            else
                mapshow(S(temp),'FaceColor',data(ia(i),:))      
            end
            i = i+1;
        end
        
        mapshow(S(89),'FaceColor',[0.5 0.5 0.5])
        axis off
        
        hold on
        h =  fill([NaN;NaN], [NaN;NaN],[0.5 0.5 0.5] , 'edgecolor', [0.5 0.5 0.5], 'edgealpha', 0.1);
        lg = legend(h, 'Unavailable data','Location','northwest');
        lg.FontSize = 14;
        title('Benchmark Indicator','Units', 'normalized', 'Position', [0.5, -0.1, 0],'FontSize',14);
        nexttile
        mapshow(S);
        
        
        [C,ia] = ismember(difANEXO1_real,colorindex);
        
        i = 1;
        while i <= NManc
            % FaceColor is now a color from the current colormap, determined by
            % it's data value
            temp = EELL{i,2};
            if ia(i) == 0
                mapshow(S(temp),'FaceColor',[0.5 0.5 0.5])      
            else
                mapshow(S(temp),'FaceColor',data(ia(i),:))      
            end
            i = i+1;
        end
        
        
        mapshow(S(89),'FaceColor',[0.5 0.5 0.5]);
        
        axis off
        
        title('Synthetic Indicator','Units', 'normalized', 'Position', [0.5, -0.1, 0],'FontSize',14);
        
        cb = colorbar('Ticks',[0,1],'TickLabels',{'Lower Relative Income','Higher Relative Income'},'Direction','reverse');
        cb.Layout.Tile = 'north';
        cb.FontSize = 14;
        

        filename = ['Figure_3_Coeff(' year{1,t} ')_Year_' year{1,t2} '.png'];
        saveas(Fig,filename)

    end

end
