clear;clc;close all
%% This is for paper!!!!
% Energy generation & dissipation & Mode-1 flux into area
%%
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
%%
imode = 1;
for m=1:36
    if m <=12
        % 2014
        SaveLocation = ['./',month_file{m}];
        % load([SaveLocation,'/NDA_Modal_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        load([SaveLocation,'/NDA_budget_', month_file{m}, '.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        % load([SaveLocation,'/SDA_Modal_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        load([SaveLocation,'/SDA_budget_', month_file{m}, '.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;

        Gen_month_NDA(m,1) = NDA_budget(1);
        Gen_month_SDA(m,1) = SDA_budget(1);
    
        Dis_month_NDA(m,1) = NDA_budget(6);
        Dis_month_SDA(m,1) = SDA_budget(6);
    

        load([SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside 
        % w:2
        % e:3 land
        % n:4
        % s:5
        Input_month_NDA(m,1) = NDA_budget(2);
        Input_month_SDA(m,1) = SDA_budget(2); 
        north_month_NDA(m,1) = NDA_budget(4);  
        north_month_SDA(m,1) = SDA_budget(4);  
        south_month_NDA(m,1) = NDA_budget(5);  
        south_month_SDA(m,1) = SDA_budget(5);  
    elseif m <=24
        % 2015
        SaveLocation = [month_file{m-12}];
        loadLocation = '../../../../../../2015/Withtide/post_process/Season/BC_MSS/Pressure/';
        % load([loadLocation,SaveLocation,'/NDA_Modal_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        load([loadLocation,SaveLocation,'/NDA_budget_', month_file{m-12}, '.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        % load([loadLocation,SaveLocation,'/SDA_Modal_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        load([loadLocation,SaveLocation,'/SDA_budget_', month_file{m-12}, '.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % NDA 1
        % SDS 2
        Gen_month_NDA(m-12,2) = NDA_budget(1);
        Gen_month_SDA(m-12,2) = SDA_budget(1);
    
        Dis_month_NDA(m-12,2) = NDA_budget(6);
        Dis_month_SDA(m-12,2) = SDA_budget(6);
    

        load([loadLocation,SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([loadLocation,SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside
        Input_month_NDA(m-12,2) = NDA_budget(2);
        Input_month_SDA(m-12,2) = SDA_budget(2);
        north_month_NDA(m-12,2) = NDA_budget(4);  
        north_month_SDA(m-12,2) = SDA_budget(4);  
        south_month_NDA(m-12,2) = NDA_budget(5);  
        south_month_SDA(m-12,2) = SDA_budget(5); 
        elseif m <=36
        % 2016
        SaveLocation = [month_file{m-24}];
        loadLocation = '../../../../../../2016/Withtide/post_process/Season/BC_MSS/Pressure/';
        % load([loadLocation,SaveLocation,'/NDA_Modal_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        load([loadLocation,SaveLocation,'/NDA_budget_', month_file{m-24}, '.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        % load([loadLocation,SaveLocation,'/SDA_Modal_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        load([loadLocation,SaveLocation,'/SDA_budget_', month_file{m-24}, '.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % NDA 1
        % SDS 2
        Gen_month_NDA(m-24,3) = NDA_budget(1);
        Gen_month_SDA(m-24,3) = SDA_budget(1);
    
        Dis_month_NDA(m-24,3) = NDA_budget(6);
        Dis_month_SDA(m-24,3) = SDA_budget(6);
    

        load([loadLocation,SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([loadLocation,SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside
        Input_month_NDA(m-24,3) = NDA_budget(2);
        Input_month_SDA(m-24,3) = SDA_budget(2);
        north_month_NDA(m-24,3) = NDA_budget(4);  
        north_month_SDA(m-24,3) = SDA_budget(4);  
        south_month_NDA(m-24,3) = NDA_budget(5);  
        south_month_SDA(m-24,3) = SDA_budget(5); 

    end
end
% Average 
Gen_month_NDA = Gen_month_NDA*1e-6;
Dis_month_NDA = Dis_month_NDA*1e-6;
Gen_month_SDA = Gen_month_SDA*1e-6;
Dis_month_SDA = Dis_month_SDA*1e-6;

Gen_month_NDA = Gen_month_NDA';
Dis_month_NDA = Dis_month_NDA';
Gen_month_SDA = Gen_month_SDA';
Dis_month_SDA = Dis_month_SDA';

Input_month_NDA = Input_month_NDA*1e-6;
Input_month_SDA = Input_month_SDA*1e-6;
Input_month_NDA = Input_month_NDA';
Input_month_SDA = Input_month_SDA';

% std
Gen_NDA_error = std(Gen_month_NDA,0,1);
Gen_SDA_error = std(Gen_month_SDA,0,1);

Dis_NDA_error = std(Dis_month_NDA,0,1);
Dis_SDA_error = std(Dis_month_SDA,0,1);

Input_NDA_error = std(Input_month_NDA,0,1);
Input_SDA_error = std(Input_month_SDA,0,1);


north_month_NDA = north_month_NDA*1e-6;north_month_NDA = north_month_NDA';
north_month_SDA = north_month_SDA*1e-6;north_month_SDA = north_month_SDA';
south_month_NDA = south_month_NDA*1e-6;south_month_NDA = south_month_NDA';
south_month_SDA = south_month_SDA*1e-6;south_month_SDA = south_month_SDA';

%%
imode = 2;
for m=1:36
    if m <=12
        % 2014
        SaveLocation = ['./',month_file{m}];
        % load([SaveLocation,'/NDA_Modal_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        % NDA_budget = Region_energy_M2;
        % load([SaveLocation,'/SDA_Modal_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        % SDA_budget = Region_energy_M2;
        % 
        % Gen_month_NDA2(m,1) = NDA_budget(1);
        % Gen_month_SDA2(m,1) = SDA_budget(1);
        % 
        % Dis_month_NDA2(m,1) = NDA_budget(6);
        % Dis_month_SDA2(m,1) = SDA_budget(6);
        % 

        load([SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside 
        % w:2
        % e:3 land
        % n:4
        % s:5
        Input_month_NDA2(m,1) = NDA_budget(2);
        Input_month_SDA2(m,1) = SDA_budget(2); 
        north_month_NDA2(m,1) = NDA_budget(4);  
        north_month_SDA2(m,1) = SDA_budget(4);  
        south_month_NDA2(m,1) = NDA_budget(5);  
        south_month_SDA2(m,1) = SDA_budget(5);  
    elseif m <=24
        % 2015
        SaveLocation = [month_file{m-12}];
        loadLocation = '../../../../../../2015/Withtide/post_process/Season/BC_MSS/Pressure/';
        % load([loadLocation,SaveLocation,'/NDA_Modal_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        % NDA_budget = Region_energy_M2;
        % load([loadLocation,SaveLocation,'/SDA_Modal_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        % SDA_budget = Region_energy_M2;
        % % NDA 1
        % % SDS 2
        % Gen_month_NDA2(m-12,2) = NDA_budget(1);
        % Gen_month_SDA2(m-12,2) = SDA_budget(1);
        % 
        % Dis_month_NDA2(m-12,2) = NDA_budget(6);
        % Dis_month_SDA2(m-12,2) = SDA_budget(6);
    

        load([loadLocation,SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([loadLocation,SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m-12}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside
        Input_month_NDA2(m-12,2) = NDA_budget(2);
        Input_month_SDA2(m-12,2) = SDA_budget(2);
        north_month_NDA2(m-12,2) = NDA_budget(4);  
        north_month_SDA2(m-12,2) = SDA_budget(4);  
        south_month_NDA2(m-12,2) = NDA_budget(5);  
        south_month_SDA2(m-12,2) = SDA_budget(5); 
        elseif m <=36
        % 2016
        SaveLocation = [month_file{m-24}];
        loadLocation = '../../../../../../2016/Withtide/post_process/Season/BC_MSS/Pressure/';
        % load([loadLocation,SaveLocation,'/NDA_Modal_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        % NDA_budget = Region_energy_M2;
        % load([loadLocation,SaveLocation,'/SDA_Modal_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        % SDA_budget = Region_energy_M2;
        % % NDA 1
        % % SDS 2
        % Gen_month_NDA2(m-24,3) = NDA_budget(1);
        % Gen_month_SDA2(m-24,3) = SDA_budget(1);
        % 
        % Dis_month_NDA2(m-24,3) = NDA_budget(6);
        % Dis_month_SDA2(m-24,3) = SDA_budget(6);
    

        load([loadLocation,SaveLocation,'/NDA_Modal_',num2str(imode),'_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        NDA_budget = Region_energy_M2;
        load([loadLocation,SaveLocation,'/SDA_Modal_',num2str(imode),'_budget_', month_file{m-24}, '_new.mat'],'Region_energy_M2');
        SDA_budget = Region_energy_M2;
        % From outside
        Input_month_NDA2(m-24,3) = NDA_budget(2);
        Input_month_SDA2(m-24,3) = SDA_budget(2);
        north_month_NDA2(m-24,3) = NDA_budget(4);  
        north_month_SDA2(m-24,3) = SDA_budget(4);  
        south_month_NDA2(m-24,3) = NDA_budget(5);  
        south_month_SDA2(m-24,3) = SDA_budget(5); 

    end
end
% Average 
% Gen_month_NDA2 = Gen_month_NDA2*1e-6;
% Dis_month_NDA2 = Dis_month_NDA2*1e-6;
% Gen_month_SDA2 = Gen_month_SDA2*1e-6;
% Dis_month_SDA2 = Dis_month_SDA2*1e-6;
% 
% Gen_month_NDA2 = Gen_month_NDA2';
% Dis_month_NDA2 = Dis_month_NDA2';
% Gen_month_SDA2 = Gen_month_SDA2';
% Dis_month_SDA2 = Dis_month_SDA2';

Input_month_NDA2 = Input_month_NDA2*1e-6;
Input_month_SDA2 = Input_month_SDA2*1e-6;
Input_month_NDA2 = Input_month_NDA2';
Input_month_SDA2 = Input_month_SDA2';

% std
% Gen_NDA_error2 = std(Gen_month_NDA2,0,1);
% Gen_SDA_error2 = std(Gen_month_SDA2,0,1);
% 
% Dis_NDA_error2 = std(Dis_month_NDA2,0,1);
% Dis_SDA_error2 = std(Dis_month_SDA2,0,1);

Input_NDA_error2 = std(Input_month_NDA2,0,1);
Input_SDA_error2 = std(Input_month_SDA2,0,1);


north_month_NDA2 = north_month_NDA2*1e-6;north_month_NDA2 = north_month_NDA2';
north_month_SDA2 = north_month_SDA2*1e-6;north_month_SDA2 = north_month_SDA2';
south_month_NDA2 = south_month_NDA2*1e-6;south_month_NDA2 = south_month_NDA2';
south_month_SDA2 = south_month_SDA2*1e-6;south_month_SDA2 = south_month_SDA2';

[nyear, nmonth] = size(Input_month_NDA2);




%%

m = 12;
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 800 950])
set(gcf,'position',[-1050 50 800 1150])
h1 = axes('position',[0.15 0.8 0.80 0.18]);
x=[1:m];
scatter(x,Gen_month_NDA(1,:),90,'blue','filled','DisplayName','2014','Marker','o');hold on;
scatter(x,Gen_month_NDA(2,:),90,'cyan','filled','DisplayName','2015','Marker','^');hold on;
scatter(x,Gen_month_NDA(3,:),90,'red','filled','DisplayName','2016','Marker','s');grid on;

Gen_CVTM_NDA = 75.4;
Gen_clim = mean(Gen_month_NDA, 1);  
Gen_std = std(Gen_month_NDA,0,1);

plot([1:m], Gen_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
% plot([1:m], Gen_clim./Gen_clim + Gen_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
h = legend('AutoUpdate','off');
set(h,'Location','northeast','LineWidth',2,...
    'Position',[0.162325846354167 0.942685637492558 0.520833333333333 0.0261569416498993],...
    'Orientation','horizontal',...
    'LineWidth',2,...
    'FontSize',15,...
    'AutoUpdate','off');


x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Gen_clim + Gen_std, fliplr(Gen_clim - Gen_std)];
fill(x2, inBetween, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);

set(gca,'xtick',[1:m],'XTickLabel',{' '},'Ytick',[40:20:120]);
xlim([0.5 12.5]);box on;
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  

% errorbar(x,Gen_NDA_mean*1e-6,Gen_NDA_error*1e-6,"-s","MarkerSize",10,...
%      "MarkerEdgeColor",'k',"MarkerFaceColor",[0.65 0.85 0.90],...
%      'Marker','square',...
%      'LineWidth',2,...
%      'CapSize',5,...
%      'Color','b','DisplayName','NDA');hold on;

% 'MarkerFaceColor','r','MarkerEdgeColor','r','Marker','o','MarkerSize',10,
xlim([0.5 12.5]);
ylim([40 120]);
% $\langle \overline{\textbf{\textit{C}}} \rangle$'
grid on;

% ylabel('$\langle \overline{\textbf{\textit{C}}} \rangle \; (MW)$','FontSize',25,'Interpreter','latex')
% ylabel('$[MW]$','FontSize',25,'Interpreter','latex')

% winter
x_winter = 0.5;y_low = 20;
x_winter1 = 4.5;y_high = 120;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
ylim([y_low y_high])

fill(x_fill, y_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Winter');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Summer');hold on;
ylim([40 120]);
plot([1:m], Gen_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
% %plot([1:m], Gen_clim./Gen_clim + Gen_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
% annotation(figure(1),'textbox',...
%     [0.687946022727273 0.726741070666732 0.265803977272727 0.0676730190955187],...
%     'String','CVTM: 75.4 MW',...
%     'LineStyle','none',...
%     'FontWeight','bold',...
%     'FontSize',19,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
%% Dis
% subplot(312);
% h2 = axes('position',[0.15 0.4 0.80 0.24]);
h2 = axes('position',[0.15 0.56 0.80 0.18]);
xlim([0.5 12.5]);
% winter
x_winter = 0.5;y_low = 20;
x_winter1 = 4.5;y_high = 200;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
ylim([y_low y_high])

fill(x_fill, y_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Upwelling');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Downwelling');hold on;
% h = legend('AutoUpdate','off');
% set(h,'Location','northoutside','LineWidth',2,...
%     'FontSize',20,'fontname','Arial','Orientation','Vertical');

scatter(x,Dis_month_NDA(1,:),90,'blue','filled','DisplayName','2014','Marker','o');hold on;
scatter(x,Dis_month_NDA(2,:),90,'cyan','filled','DisplayName','2015','Marker','^');hold on;
scatter(x,Dis_month_NDA(3,:),90,'red','filled','DisplayName','2016','Marker','s');grid on;

Dis_CVTM_NDA = 84.5;
Dis_clim = mean(Dis_month_NDA, 1);  
Dis_std = std(Dis_month_NDA,0,1);

plot([1:m], Dis_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
plot([1:m], Dis_clim./Dis_clim + Dis_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
ylim([80 200])
% h = legend('AutoUpdate','off');
% set(h,'Location','southeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial','Orientation','horizontal');
x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Dis_clim + Dis_std, fliplr(Dis_clim - Dis_std)];
fill(x2, inBetween, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);

set(gca,'xtick',[1:m],'XTickLabel',{' '});
xlim([0.5 12.5]);
ylim([110 200])
% '$\langle \overline{\textbf{\textit{D}}} \rangle$'
grid on;box off;
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
% h = legend;
% set(h,'NumColumns',1,'Location','northeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial');
% ylabel('$\langle \overline{\textbf{\textit{D}}} \rangle \; (MW)$','FontSize',25,'Interpreter','latex')
% ylabel('$[MW]$','FontSize',25,'Interpreter','latex')
set(gca,'ytick',[40:20:200]);
ylim([120 200]);box on;
plot([1:m], Dis_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
% CVCM: 84.5 MW 
% annotation(figure(1),'textbox',...
%     [0.156696022727273 0.605180975784569 0.265803977272727 0.0676730190955186],...
%     'String','CVTM: 84.5 MW',...
%     'LineStyle','none',...
%     'FontWeight','bold',...
%     'FontSize',19,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor','none');
% plot([1:m], Dis_clim./Dis_clim + Dis_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
%% Input from West
% subplot(313);
% h3 = axes('position',[0.15 0.08 0.80 0.24]);
h3 = axes('position',[0.15 0.32 0.80 0.18]);
x=[1:m];
scatter(x,Input_month_NDA(1,:),90,'blue','filled','DisplayName','2014','Marker','o');hold on;
scatter(x,Input_month_NDA(2,:),90,'cyan','filled','DisplayName','2015','Marker','^');hold on;
scatter(x,Input_month_NDA(3,:),90,'red','filled','DisplayName','2016','Marker','s');grid on;

Input_CVTM_NDA = 22.3;
Input_clim = mean(Input_month_NDA, 1);  
mean(Input_clim(1:4))
mean(Input_clim(5:8))
mean(Input_clim(9:12))

input_std = std(Input_month_NDA,0,1);

plot([1:m], Input_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
% plot([1:m], Input_clim./Input_clim + Input_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
% h = legend('AutoUpdate','off');
% set(h,'Location','southeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial','Orientation','horizontal');
x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Input_clim + input_std, fliplr(Input_clim - input_std)];
fill(x2, inBetween, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);

month_str = {'J','F','M','A','M','J','J','A','S','O','N','D'};
% set(gca,'xtick',[1:m],'XTickLabel',month_str);
set(gca,'xtick',[1:m],'XTickLabel',{' '});
xlim([0.5 12.5]);

% $\langle | \overline{\textbf{\textit{F}}} | \rangle \; (kW \; m^{-1})$'
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   
% h = legend;
% set(h,'NumColumns',1,'Location','northeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial');
% ylabel('$\langle \overline{\textbf{\textit{F}}}_{west} \rangle \; (MW)$','FontSize',25,'Interpreter','latex')
% ylabel('$[MW]$','FontSize',25,'Interpreter','latex')
% winter
x_winter = 0.5;y_low = -50;
x_winter1 = 4.5;y_high = 90;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边


fill(x_fill, y_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Upwelling');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Downwelling');hold on;

ylim([30 90])
set(gca,'ytick',[20:20:100]);
plot([1:m], Input_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
box on;
title('$\langle \overline{\textbf{\textit{{F}}}_{n=1}}^{NDA}_{west} \rangle $','FontSize',20,'Interpreter','latex')
% title(['Energy across the northern boundary of NDA'],'FontSize',20)
box on;
%%
h4 = axes('position',[0.15 0.08 0.80 0.18]);
x=[1:m];
scatter(x,Input_month_NDA2(1,:),90,'blue','filled','DisplayName','2014','Marker','o');hold on;
scatter(x,Input_month_NDA2(2,:),90,'cyan','filled','DisplayName','2015','Marker','^');hold on;
scatter(x,Input_month_NDA2(3,:),90,'red','filled','DisplayName','2016','Marker','s');grid on;

Input_CVTM_NDA = 22.3;
Input_clim = mean(Input_month_NDA2, 1);  
mean(Input_clim(1:4))
mean(Input_clim(5:8))
mean(Input_clim(9:12))

input_std = std(Input_month_NDA2,0,1);

plot([1:m], Input_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
% plot([1:m], Input_clim./Input_clim + Input_CVTM_NDA, '-.','color','k', 'LineWidth', 2,'DisplayName','CVTM'); hold on;
% h = legend('AutoUpdate','off');
% set(h,'Location','southeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial','Orientation','horizontal');
x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Input_clim + input_std, fliplr(Input_clim - input_std)];
fill(x2, inBetween, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);

month_str = {'J','F','M','A','M','J','J','A','S','O','N','D'};
set(gca,'xtick',[1:m],'XTickLabel',month_str);
xlim([0.5 12.5]);
ylim([0 20])
% $\langle | \overline{\textbf{\textit{F}}} | \rangle \; (kW \; m^{-1})$'
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   
% h = legend;
% set(h,'NumColumns',1,'Location','northeast','LineWidth',2,...
%     'FontSize',18,'fontname','Arial');
% ylabel('$\langle \overline{\textbf{\textit{F}}}_{west} \rangle \; (MW)$','FontSize',25,'Interpreter','latex')
% ylabel('$[MW]$','FontSize',25,'Interpreter','latex')
% winter
x_winter = 0.5;y_low = -50;
x_winter1 = 4.5;y_high = 90;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边


fill(x_fill, y_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Upwelling');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Downwelling');hold on;

set(gca,'ytick',[0:5:20]);
plot([1:m], Input_clim, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','Average'); hold on;
box on;
title('$\langle \overline{\textbf{\textit{{F}}}_{n=2}}^{NDA}_{west} \rangle $','FontSize',20,'Interpreter','latex')
% title(['Energy across the northern boundary of NDA'],'FontSize',20)
box on;
exportgraphics(gcf,['Statistics_Modal12_Energy_NDA_new.tiff'], 'Resolution',300);


a1(:,1)  = Input_month_NDA(1,:)./Dis_month_NDA(1,:);
a1(:,2) = Input_month_NDA(2,:)./Dis_month_NDA(2,:);
a1(:,3)  =Input_month_NDA(3,:)./Dis_month_NDA(3,:);

a1 = a1*100;

a1_year = mean(a1,2);

a1_upwelling = mean(a1_year(1:4))
a1_relaxation = mean(a1_year(5:8))
a1_downwelling = mean(a1_year(9:12))



%%