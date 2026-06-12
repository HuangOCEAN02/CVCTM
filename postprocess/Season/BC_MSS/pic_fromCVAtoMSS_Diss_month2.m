clear;clc;close all
load('Energy_rate_alongcoast.mat');
%% NDA
CC_nda_50_80 = mean(C_alongdis_nda(29:46,:),1,'omitmissing');
CC_nda_110_130 = mean(C_alongdis_nda(63:74,:),1,'omitmissing');

CC_nda_50_80 = reshape(CC_nda_50_80,[12,3]);CC_nda_50_80=CC_nda_50_80';
CC_nda_110_130 = reshape(CC_nda_110_130,[12,3]);CC_nda_110_130=CC_nda_110_130';

RR_nda_50_80 = mean(R_alongdis_nda(29:46,:),1,'omitmissing');
RR_nda_110_130 = mean(R_alongdis_nda(63:74,:),1,'omitmissing');

RR_nda_50_80 = reshape(RR_nda_50_80,[12,3]);RR_nda_50_80 = RR_nda_50_80';
RR_nda_110_130 = reshape(RR_nda_110_130,[12,3]);RR_nda_110_130 = RR_nda_110_130';

% SDA
CC_sda_70_90 = mean(C_alongdis_sda(41:51,:),1,'omitmissing');
CC_sda_70_90 = reshape(CC_sda_70_90,[12,3]);CC_sda_70_90=CC_sda_70_90';

RR_sda_70_90 = mean(R_alongdis_sda(41:51,:),1,'omitmissing');
RR_sda_70_90 = reshape(RR_sda_70_90,[12,3]);RR_sda_70_90=RR_sda_70_90';

%%
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[0,0,400,976]);
F1 =  axes('position',[0.14 0.55 0.8 0.35]); 
x=[1:12];
% scatter(CC_nda_50_80(1,:),TT_1(1,1:12),90,'blue','filled','DisplayName','2014','Marker','o');hold on;
% scatter(CC_nda_50_80(2,:),TT_1(1,1:12),90,'cyan','filled','DisplayName','2015','Marker','^');hold on;
% scatter(CC_nda_50_80(3,:),TT_1(1,1:12),90,'red','filled','DisplayName','2016','Marker','s');grid on;
box on;
Gen_clim = mean(CC_nda_50_80, 1);  
Gen_std = std(CC_nda_50_80,0,1);
plot(Gen_clim,x, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','$\langle \overline{\textbf{\textit{C}}} \rangle$'); hold on;

Dis_clim = mean(RR_nda_50_80, 1);  
Dis_std = std(RR_nda_50_80,0,1);
plot(Dis_clim,x, '-','color',[0.39,0.23,0.07], 'LineWidth', 2,'DisplayName','$\langle \overline{\textbf{\textit{D}}} \rangle$'); hold on;

h = legend('AutoUpdate','off');
set(h,'Location','northoutside','LineWidth',2,'Numcolumns',1,...
    'FontSize',18,'fontname','Arial','Orientation','horizontal','Interpreter','latex', ...
     'Position',[0.157003982124404,0.795125971702879,0.208211602671118,0.089909811336789]);

x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Gen_clim + Gen_std, fliplr(Gen_clim - Gen_std)];
fill(inBetween,x2, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);



x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Dis_clim + Dis_std, fliplr(Dis_clim - Dis_std)];
fill(inBetween,x2, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);
grid on;
set(gca,'GridLineWidth',1,'GridLineStyle','--')
set(F1,'fontsize',20,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','top','fontweight','bold');hold on;
hold on;
ylim([0.5 12.5])
xlim([0 7e-3]);
set(F1,'XTick',[0:1e-3:8e-3]);
datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F1,'YTick',x,'YTickLabel',datestr(TT_1(1,1:12),'m'));
% F1.YAxis.MinorTick="on"
% F1.YAxis.MinorTickValues = xt(1:1:end);
% F1.YAxis.TickLength = [0.03 0.02]


% winter
x_winter = 0.5;y_low = 0;
x_winter1 = 4.5;y_high = 0.1;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill,x_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Upwelling');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill,x_fill ,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill, x_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Downwelling');hold on;
xlabel(['$(W \; m^{-2})$'],'Interpreter','latex','fontsize',20)
%% SDA
F2 =  axes('position',[0.14 0.10 0.8 0.35]); 
box on;
Gen_clim = mean(CC_sda_70_90, 1);  
Gen_std = std(CC_sda_70_90,0,1);
plot(Gen_clim,x, '-','color',[0.39,0.83,0.07], 'LineWidth', 2,'DisplayName','$\langle \overline{\textbf{\textit{C}}} \rangle$'); hold on;

x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Gen_clim + Gen_std, fliplr(Gen_clim - Gen_std)];
fill(inBetween,x2, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);

Dis_clim = mean(RR_sda_70_90, 1);  
Dis_std = std(RR_sda_70_90,0,1);
plot(Dis_clim,x, '-','color',[0.39,0.23,0.07], 'LineWidth', 2,'DisplayName','$\langle \overline{\textbf{\textit{D}}} \rangle$'); hold on;



x2 = [x, fliplr(x)];                                % x + 翻转后的 x
inBetween = [Dis_clim + Dis_std, fliplr(Dis_clim - Dis_std)];
fill(inBetween,x2, [0.8 0.8 0.8], ...              % 灰色阴影
     'EdgeColor', 'none', 'FaceAlpha', 0.4);
grid on;
set(gca,'GridLineWidth',1,'GridLineStyle','--')
set(F2,'fontsize',20,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','top','fontweight','bold');hold on;
Xtick.Ruler.Exponent = -3;
hold on;
ylim([0.5 12.5])
xlim([2e-3 15e-3]);
set(F2,'XTick',[0:2e-3:15e-3]);

datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F2,'YTick',x,'YTickLabel',datestr(TT_1(1,1:12),'m'));

% winter
x_winter = 0.5;y_low = 0;
x_winter1 = 4.5;y_high = 0.1;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill,x_fill,[0.07,0.62,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Upwelling');hold on;
% relaxation
x_relaxation = 4.5;
x_relaxation1 = 8.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill,x_fill ,[0.92,0.68,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 8.5;
x_summer1 = 12.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(y_fill, x_fill,[0.85,0.33,0.15], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Downwelling');hold on;

exportgraphics(gcf,['Monthly_average_results/GenDis_coast_monthly2.tiff'], 'Resolution',300);