clear;clc;close all
%% Based on pic_season.m
%% AVISO
Year = 2;
% 2014
load('2014_AVISO.mat',...
    'lat','lon');
je = length(lat);ie = length(lon);
Ugeo_relaxation_time = zeros(ie,je,Year);
Vgeo_relaxation_time = zeros(ie,je,Year);
ssh_relaxation_time= zeros(ie,je,Year);
Ugeo_upwelling_time = zeros(ie,je,Year);
Vgeo_upwelling_time = zeros(ie,je,Year);
ssh_upwelling_time= zeros(ie,je,Year);

y_select =1;
load('2014_AVISO.mat',...
    'Ugeo_relaxation','Vgeo_relaxation','ssh_relaxation',...
    'Ugeo_upwelling','Vgeo_upwelling','ssh_upwelling');
Ugeo_relaxation_time(:,:,y_select) = Ugeo_relaxation;
Vgeo_relaxation_time(:,:,y_select) = Vgeo_relaxation;
ssh_relaxation_time(:,:,y_select) = ssh_relaxation;
Ugeo_upwelling_time(:,:,y_select) = Ugeo_upwelling;
Vgeo_upwelling_time(:,:,y_select) = Vgeo_upwelling;
ssh_upwelling_time(:,:,y_select) = ssh_upwelling;
% 2015
y_select =y_select +1;
load('../../../../2015/Withtide/post_process/AVISO/2015_AVISO.mat', ...
    'Ugeo_relaxation','Vgeo_relaxation','ssh_relaxation',...
    'Ugeo_upwelling','Vgeo_upwelling','ssh_upwelling');
Ugeo_relaxation_time(:,:,y_select) = Ugeo_relaxation;
Vgeo_relaxation_time(:,:,y_select) = Vgeo_relaxation;
ssh_relaxation_time(:,:,y_select) = ssh_relaxation;

Ugeo_upwelling_time(:,:,y_select) = Ugeo_upwelling;
Vgeo_upwelling_time(:,:,y_select) = Vgeo_upwelling;
ssh_upwelling_time(:,:,y_select) = ssh_upwelling;
% 2016
y_select =y_select +1;
load('../../../../2016/Withtide/post_process/AVISO/2016_AVISO.mat', ...
    'Ugeo_relaxation','Vgeo_relaxation','ssh_relaxation',...
    'Ugeo_upwelling','Vgeo_upwelling','ssh_upwelling');
Ugeo_relaxation_time(:,:,y_select) = Ugeo_relaxation;
Vgeo_relaxation_time(:,:,y_select) = Vgeo_relaxation;
ssh_relaxation_time(:,:,y_select) = ssh_relaxation;

Ugeo_upwelling_time(:,:,y_select) = Ugeo_upwelling;
Vgeo_upwelling_time(:,:,y_select) = Vgeo_upwelling;
ssh_upwelling_time(:,:,y_select) = ssh_upwelling;
%% pic eke
[lat_grid,lon_grid] = meshgrid(lat,lon);
load('GMT_hot_r.mat')
ssh_upwelling_mean = mean(ssh_upwelling_time,3);
ssh_relaxation_mean = mean(ssh_relaxation_time,3);

Ugeo_upwelling_mean = mean(Ugeo_upwelling_time,3);
Vgeo_upwelling_mean = mean(Vgeo_upwelling_time,3);

Ugeo_relaxation_mean = mean(Ugeo_relaxation_time,3);
Vgeo_relaxation_mean = mean(Vgeo_relaxation_time,3);

%%
LATLIMS = [min(min(lat_grid)) max(max(lat_grid))];
LONLIMS = [min(min(lon_grid)) max(max(lon_grid))];

LATLIMS = [11 max(max(lat_grid))];
LONLIMS = [min(min(lon_grid)) -14];
% label arrow
labelx = [-15.7,-15.5];labely = [16.5,16.6];
labelu = [0.5,0];labelv=[0,0];
% colormap
load('MPL_RdYlBu_r.mat');

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[10 20 1350 450])
F1 = axes('position',[0.08 0.10 0.40 0.8]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',25,'fontname','Arial', ...
    'xtick',8,'tickdir','in');

XX_pic = lon_grid(2:2:end,2:2:end);
YY_pic = lat_grid(2:2:end,2:2:end);
UU_pic = Ugeo_upwelling_mean(2:2:end,2:2:end);
VV_pic = Vgeo_upwelling_mean(2:2:end,2:2:end);
scale_auto = Get_Autoscale(XX_pic,YY_pic,UU_pic,VV_pic); 
scale_label = Get_Autoscale(labelx,labely,labelu,labelv);
scale_factor = scale_auto/scale_label;

m_pcolor(lon_grid,lat_grid,ssh_upwelling_mean);shading interp;hold on;
% clim([0,300]);
clim([-0.1,0.1]);
colormap(F1,MPL_RdYlBu_r)
load('WhiteZero.txt');
colormap(F1,WhiteZero);
% q_label = m_quiver(labelx,labely,labelu,labelv,...
%             5,'MaxHeadSize',0.8,'color','k','linewidth',1.15);hold on
q = m_quiver(XX_pic,YY_pic,UU_pic,VV_pic,8/scale_factor,...
                        'MaxHeadSize',4,'color',[.9 .4 .3],'linewidth',1.15);

m_gshhs_h('patch',[1 1 1],'edgecolor','none','linewidth',1);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',25,'fontname','Arial', ...
    'xtick',8,'tickdir','in');

q_label = m_quiver(labelx,labely,labelu,labelv,...
            8,'MaxHeadSize',1,'color','b','linewidth',1.15);hold on
annotation(figure(1),'textbox',...
    [0.40441682044807 0.531111111111111 0.0852128091815593 0.0914638687687211],...
    'String','0.5 m s^-^1',...
    'LineStyle','none',...
    'FontSize',15,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');

annotation(figure(1),'rectangle',...
    [0.407692307692307 0.551111111111111 0.0693447293447295 0.111111111111111],...
    'LineWidth',2);
set(gca,'Layer','top')



F2 = axes('position',[0.52 0.10 0.40 0.8]);

UU_pic = Ugeo_relaxation_mean(2:2:end,2:2:end);
VV_pic = Vgeo_relaxation_mean(2:2:end,2:2:end);
scale_auto = Get_Autoscale(XX_pic,YY_pic,UU_pic,VV_pic); 
% scale_label = Get_Autoscale(labelx,labely,labelu,labelv);
scale_factor = scale_auto/scale_label;

m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',25,'fontname','Arial');

m_pcolor(lon_grid,lat_grid,ssh_relaxation_mean);shading interp;hold on;
% clim([0,300]);
clim([-0.1,0.1]);
colormap(F2,MPL_RdYlBu_r)
load('WhiteZero.txt');
colormap(F2,WhiteZero);
q = m_quiver(XX_pic,YY_pic,UU_pic,VV_pic,8/scale_factor,...
                        'MaxHeadSize',4,'color',[.9 .4 .3],'linewidth',1.15);

m_gshhs_h('patch',[1 1 1],'edgecolor','none','linewidth',1);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',25,'fontname','Arial', ...
    'xtick',8,'tickdir','in','Yticklabels',[]);

% h2=colorbar('location','eastOutside','fontsize',25,'fontweight','bold');
% set(h2,'Ticks',[0:100:300]);
% set(get(h2,'Title'),'string','$ {(cm^{2}\;s^{-2})} $','Interpreter','latex','fontsize',25,'fontweight','bold');
h2=colorbar('location','eastOutside','fontsize',22,'fontweight','bold','Position',...
    [0.931538461538462 0.149005678123027 0.0123076923076924 0.688655310420613],...
    'FontWeight','bold',...
    'FontSize',22);
set(get(h2,'Title'),'string','m','fontsize',25,'fontweight','bold');

set(gca,'Layer','top')

exportgraphics(gcf,['AVISO-Suvgo.tiff'], 'Resolution',300);

