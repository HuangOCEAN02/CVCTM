clear;clc;close all;
%% average critical slope
%%
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../Grid/
load('Grid_info.mat','ke','lonp_grid','latp_grid','depto_grid');
iw = 10;ie = 1;
jn = 10;js = 10;
lonp_grid= Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid= Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid = Exclude_sponge(iw,ie,jn,js,depto_grid);

load('CoastalDakar_index.mat')
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
depto_grid = depto_grid(select_indicex,select_indicey);
SaveLocation='./CriticalSlope_MSS';

for m_select=1:12
    load([SaveLocation,'/MSS_GD', month_file{m_select}, '.mat'], ...
             'slope');
    slope_month(:,:,m_select) = slope;
end
%%
slope_mean = nanmean(slope_month,3);
LATLIMS = [12.1 18.35];
LONLIMS = [-21 -15];

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
set(gcf,'color','w');
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
% slope = slope/10;
% slope(slope>1) = slope(slope>1)./100;
% slope = abs(slope);
% slope(slope<1)=nan;

slope_mean(isnan(slope_mean)==1)=0;
% slope(slope<1)=1;
m_pcolor(lonp_grid,latp_grid,slope_mean);shading interp;hold on;
% load('nrl_sirkes.mat');colormap(nrl_sirkes);
% load('MPL_RdGy_r.mat');colormap(MPL_RdGy_r);
% load('MPL_bwr.mat');
% for j=65:-1:1
%     MPL_bwr(j,:)=MPL_bwr(65,:);
% end
% for j=66:128
%     MPL_bwr(j,:)=MPL_bwr(110,:);
% end
% colormap(MPL_bwr);

load('precip3_16lev.mat');
% for j=8:-1:1 % j=2:-1:1
%     precip3_16lev(j,:)=precip3_16lev(1,:);
% end
colormap(precip3_16lev(1:end,:));
% clim([0 3])

clim([0 2])

% load('precip3_16lev.mat');
% for j=2:-1:1
%     precip3_16lev(j,:)=precip3_16lev(1,:);
% end
% colormap(precip3_16lev(1:end,:));
% clim([0 3])

clim([0 2])

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:6500],...
    'linewidth',0.8,'color','k');hold on;

clim([0 2])

% [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:500:3500],...
%     'linewidth',0.8,'color','k');hold on;

bar = colorbar;set(bar,'fontsize',28,'fontname','Arial','Location','eastoutside','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','\boldmath$\alpha$','Interpreter','latex','fontname','Arial','fontweight','bold','linewidth',2,'fontsize',28);
set(bar,'Ticks',[0:0.5:2]);
% set(bar,'Ticks',[-0.02,0.5:0.5:2],'TickLabels',{'0','0.5','1','1.5','2'});


% m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);

m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  


set(gca,'Layer','top');

[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:6500],...
    'linewidth',0.8,'color','k');hold on;
% clabel(c,h,'LabelSpacing',700,'color','w',...
%     'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[2000,2000],...
    'linewidth',2,'color','k');hold on;
clabel(c,h,'LabelSpacing',700,'color','k',...
    'fontsize',15,'fontname','Arial','FontSmoothing','on','fontweight','bold')


%%

load('../BC_MSS/Pressure/NorthDakar_index.mat')
lon_nda  = lonp_grid(select_indicex,select_indicey);
lat_nda  = latp_grid(select_indicex,select_indicey);

m_plot(lon_nda(1,:),lat_nda(1,:),'LineWidth',2,'Color','k','linestyle','-.');hold on;
% m_plot(lon_nda(end,:),lat_nda(end,:),'LineWidth',2,'Color','k','linestyle','-.');hold on;
m_plot(lon_nda(:,1),lat_nda(:,1),'LineWidth',2,'Color','k','linestyle','-.');hold on;
% m_plot(lon_ebi(:,end),lat_ebi(:,end),'LineWidth',2,'Color','k','linestyle','-.');hold on;


load('../BC_MSS/Pressure/SouthDakar_index.mat')
lon_sda  = lonp_grid(select_indicex,select_indicey);
lat_sda  = latp_grid(select_indicex,select_indicey);

m_plot(lon_sda(1,:),lat_sda(1,:),'LineWidth',2,'Color','k','linestyle','-.');hold on;
% m_plot(lon_sda(end,:),lat_sda(end,:),'LineWidth',2,'Color','k','linestyle','-.');hold on;
m_plot(lon_sda(:,1),lat_sda(:,1),'LineWidth',2,'Color','k','linestyle','-.');hold on;
m_plot(lon_sda(:,end),lat_sda(:,end),'LineWidth',2,'Color','k','linestyle','-.');hold on;


m_gshhs_h('patch',[0.30,0.75,0.93],'edgecolor','k','linewidth',1);

lat_s  = [17.9900 14.6767 ];
lon_s  = [-16.0367 -17.4200 ];

m_plot(lon_s,lat_s,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','c',...
    'DisplayName','Tide gauge'); hold on;
%%

annotation(figure(3),'textbox',...
    [0.619888888888889 0.509230769230769 0.0812222222222221 0.0615384615384614],...
    'String','NDA',...
    'LineStyle','none',...
    'FontSize',30,...
    'FontName','Arial',...
    'FontAngle','italic',...
    'FitBoxToText','off');

annotation(figure(3),'textbox',...
    [0.619888888888889 0.363076923076923 0.0812222222222224 0.0615384615384614],...
    'String','SDA',...
    'LineStyle','none',...
    'FontSize',30,...
    'FontName','Arial',...
    'FontAngle','italic',...
    'FitBoxToText','off');

% Dakar
annotation(figure(3),'textbox',...
    [0.543222222222223 0.423076923076923 0.0812222222222221 0.0615384615384614],...
    'String','Dakar',...
    'LineStyle','none',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');
% Nouakchott
annotation(figure(3),'textbox',...
    [0.645444444444445 0.804615384615385 0.0812222222222221 0.0615384615384615],...
    'String','Nouakchott',...
    'LineStyle','none',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');



exportgraphics(gca,[SaveLocation,'/GD_CriticalSlope_mean.tiff'], 'Resolution',300);
