clear;clc;close all
%% This is for model validation
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
ie_global = 112;
je_global = 83;
Location = './AVISO_data';
isdata=1;
%% upwelling:2-4
Ugeo_upwelling = zeros(ie_global,je_global);
Vgeo_upwelling = zeros(ie_global,je_global);
ssh_upwelling = zeros(ie_global,je_global);
load('Average_ssh.mat');
count =0;
for m_select = 2:4
    name = [Location,'/CMEMS_AVISO_2014_',month_str{m_select},'.nc'];
    lon  = double(ncread(name,'longitude')); lat  = double(ncread(name,'latitude'));
    adt  = double(ncread(name,'adt'));  ugos = double(ncread(name,'ugos'));
    sla = double(ncread(name,'sla'));   vgos = double(ncread(name,'vgos'));
    Ugeo_upwelling = Ugeo_upwelling + sum(ugos,3);
    Vgeo_upwelling = Vgeo_upwelling + sum(vgos,3);
    ssh_upwelling = ssh_upwelling + sum(adt,3);
    count = count+size(ugos,3);
end
Ugeo_upwelling =Ugeo_upwelling/count;
Vgeo_upwelling =Vgeo_upwelling/count;
EKE_upwelling = 1/2*(Ugeo_upwelling.^2 + Vgeo_upwelling.^2);
ssh_upwelling =ssh_upwelling/count - SSH_mean;
%     Ugeo_upwelling = Ugeo_upwelling + mean(ugos,3);
%     Vgeo_upwelling = Vgeo_upwelling + mean(vgos,3);
%     ssh_upwelling = ssh_upwelling + mean(adt,3)-SSH_mean;
%     count = count+1;
% end
% Ugeo_upwelling =Ugeo_upwelling/count;
% Vgeo_upwelling =Vgeo_upwelling/count;
% EKE_upwelling = 1/2*(Ugeo_upwelling.^2 + Vgeo_upwelling.^2);
% ssh_upwelling =ssh_upwelling/count;
%% relaxation: 6-8
Ugeo_relaxation = zeros(ie_global,je_global);
Vgeo_relaxation = zeros(ie_global,je_global);
ssh_relaxation = zeros(ie_global,je_global);
count =0;
for m_select = 6:8
    name = [Location,'/CMEMS_AVISO_2014_',month_str{m_select},'.nc'];
    lon  = double(ncread(name,'longitude')); lat  = double(ncread(name,'latitude'));
    adt  = double(ncread(name,'adt'));  ugos = double(ncread(name,'ugos'));
    sla = double(ncread(name,'sla'));   vgos = double(ncread(name,'vgos'));

    Ugeo_relaxation = Ugeo_relaxation + sum(ugos,3);
    Vgeo_relaxation = Vgeo_relaxation + sum(vgos,3);
    ssh_relaxation = ssh_relaxation + sum(adt,3);
    count = count+size(ugos,3);
end
Ugeo_relaxation = Ugeo_relaxation/count;
Vgeo_relaxation = Vgeo_relaxation/count;
EKE_relaxation  =  1/2*(Ugeo_relaxation.^2 + Vgeo_relaxation.^2);
ssh_relaxation = ssh_relaxation/count - SSH_mean;
if isdata
    save 2014_AVISO.mat lat lon EKE_relaxation ssh_relaxation EKE_upwelling ssh_upwelling Ugeo_relaxation Vgeo_relaxation Ugeo_upwelling Vgeo_upwelling
end
%% Pic
[lat_grid,lon_grid] = meshgrid(lat,lon);
%%
LATLIMS = [min(min(lat_grid)) max(max(lat_grid))];
LONLIMS = [min(min(lon_grid)) max(max(lon_grid))];
% label arrow
labelx = [-15.5,-15.3];labely = [17.7,17.8];
labelu = [0.5,0];labelv=[0,0];
% colormap
load('MPL_RdYlBu_r.mat');

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[10 20 1300 450])
F1 = axes('position',[0.05 0.10 0.48 0.8]);
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial', ...
    'xtick',8,'tickdir','in');

scale_auto = Get_Autoscale(lon_grid,lat_grid,Ugeo_upwelling,Vgeo_upwelling); 
scale_label = Get_Autoscale(labelx,labely,labelu,labelv);
scale_factor = scale_auto/scale_label;

m_pcolor(lon_grid,lat_grid,ssh_upwelling);shading interp;hold on;
clim([-0.2,0.2]);
colormap(F1,MPL_RdYlBu_r)
q_label = m_quiver(labelx,labely,labelu,labelv,...
            4,'MaxHeadSize',0.8,'color','k','linewidth',1.15);hold on
q = m_quiver(lon_grid,lat_grid,Ugeo_upwelling,Vgeo_upwelling,4/scale_factor,...
                        'MaxHeadSize',0.8,'color','k','linewidth',1.15);

m_gshhs_h('patch',[1 1 1],'edgecolor','none','linewidth',1);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial', ...
    'xtick',8,'tickdir','in');

q_label = m_quiver(labelx,labely,labelu,labelv,...
            4,'MaxHeadSize',1,'color','b','linewidth',1.15);hold on

set(gca,'Layer','top')




F2 = axes('position',[0.52 0.10 0.48 0.8]);

scale_auto = Get_Autoscale(lon_grid,lat_grid,Ugeo_relaxation,Vgeo_relaxation); 
scale_label = Get_Autoscale(labelx,labely,labelu,labelv);
scale_factor = scale_auto/scale_label;

m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial');

m_pcolor(lon_grid,lat_grid,ssh_relaxation);shading interp;hold on;
clim([-0.2,0.2]);
colormap(F2,MPL_RdYlBu_r)
q = m_quiver(lon_grid,lat_grid,Ugeo_relaxation,Vgeo_relaxation,4/scale_factor,...
                        'MaxHeadSize',0.8,'color','k','linewidth',1.15);

m_gshhs_h('patch',[1 1 1],'edgecolor','none','linewidth',1);
m_grid('linestyle','none','linewidth',1.5,'XAxisLocation','bottom','fontsize',28,'fontname','Arial', ...
    'xtick',8,'tickdir','in');

set(gca,'Layer','top')


