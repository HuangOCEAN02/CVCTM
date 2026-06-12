clear;clc;close all
LONLIMS = [-19 -15];
LATLIMS = [12.6 18.4];
load('/Users/josephhuang/Desktop/workingplace/CoastalTide_alongTrack/WAFRICA/BRAVE60_topo.mat') % model topography
load('cmp_haxby_r.mat');
load('cmp_haxby.mat');
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');
%% critical slope
load('../Average/CriticalSlope_MSS/MSS_GD_average_3year.mat','slope');
addpath ../../Grid/
load('Grid_info.mat','ke','lonp_grid','latp_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

lonp_grid = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);

load('CoastalDakar_index.mat')
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
%%
slope_shading = slope;
slope_shading(slope<0.8)=0;
slope_shading(slope>=0.8 & slope<=1.5)=1;
slope_shading(slope>=1.5)=2;
slope_shading(isnan(slope))=0;

n = 256;
gray_len = round(n * 0.33);
blue_len = round(n * 0.33);
red_len = n - gray_len - blue_len;

gray = repmat([192 192 192]/255, gray_len, 1);
blue = repmat([0 0 255]/255, blue_len, 1);
red = repmat([255 0 0]/255, red_len, 1);

my_cmap = [gray; blue; red];

m_pcolor(lonp_grid,latp_grid,slope_shading);shading interp;hold on;
% load('nrl_sirkes.mat');colormap(nrl_sirkes);
% load('MPL_RdGy_r.mat');colormap(MPL_RdGy_r);
colormap(my_cmap);
% load('precip3_16lev.mat');colormap(precip3_16lev(1:end,:));
clim([0 2])
[c,h] = m_contour(LON_level1_P,LAT_level1_P,DEPTH_P*1e-3,[0:0.25:5],'linestyle','-',...
    'linewidth',0.5,'color',[.4 .4 .4]);
% m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',15,'fontname','Arial');
% m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1);
% m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',15,'fontname','Arial');
% 
% colormap(cmp_haxby_r);clim([-0.100 6]);
% [c,h] = m_contour(LON_level1_P,LAT_level1_P,DEPTH_P*1e-3,[0.5,0.5],'linestyle','-',...
%    'linewidth',0.8,'color',[.4 .4 .4]);
% 
% h2=colorbar('location','eastOutside','fontsize',28,'FontWeight','bold');
% set(get(h2,'Title'),'string','km','fontname','Arial','fontsize',28);
% 

% set(bar,'Ticks',[-0.02,0.5:0.5:2],'TickLabels',{'0','0.5','1','1.5','2'});
% m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);


%% Tide gauge & MSS coast & 
% m_plot([-18,-16],[18,18],'b-','linewidth',2,'DisplayName','18°N transect');hold on
% m_gshhs_h('patch',[0.30,0.75,0.93],'edgecolor','k','linewidth',1);
m_gshhs_h('patch',[1 1 1],'edgecolor','w','linewidth',0.5);
load('MSS_coast_index.mat');
lon_coast(lat_coast>18)=nan;
lon_sea(lat_coast<13)=nan;
lat_coast(lat_sea>18)=nan;
lat_coast(lat_sea<13)=nan;
lat_sea(lat_sea>18)=nan;
lat_sea(lat_sea<13)=nan;
m_plot(lon_coast,lat_coast,'Color','k','linewidth',4,'linestyle','-');hold on;
m_plot(lon_sea,lat_sea,'Color','k','linewidth',4,'linestyle','-');hold on;

m_plot([lon_sea(26),lon_coast(26)],[18,18],'Color','k','linewidth',4,'linestyle','-');hold on;
m_plot([lon_sea(337),lon_coast(337)],[13,13],'Color','k','linewidth',4,'linestyle','-');hold on;
lat_s  = [17.9900 14.6767 ];
lon_s  = [-16.0367 -17.4200 ];

m_plot(lon_s,lat_s,'ok','linewidth',1.5,'Markersize',15,'MarkerFaceColor','c',...
        'DisplayName','Tide gauge'); hold on;

m_grid('linestyle','none','linewidth',2,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');



bar = colorbar;
set(bar,'fontsize',28,'fontname','Arial','fontweight','bold','linewidth',2);hold on;
set(get(bar,'Title'),'string','\boldmath$\alpha$','Interpreter','latex','fontname','Arial','fontweight','bold','linewidth',2,'fontsize',28);
set(bar,'Ticks',[0,1,2],'TickLabels',{' '});


set(gca,'Layer','top')
exportgraphics(gcf,['CVCTM-MSS.tiff'], 'Resolution',300);
