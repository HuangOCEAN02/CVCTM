clear;clc;close all
%% after running M2_modal_SSH
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../../Grid/
%
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);

load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
r0 = 1025;
%%
LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
% LONLIMS = [-26.5 -20.5];
% LATLIMS = [14 18];
%%
datalocation='/Users/josephhuang/Desktop/workingplace/风场试验/HRET_data';
ncdisp([datalocation,'/HRET_v8.1_modes.nc']);
dataname =[datalocation,'/HRET_v8.1_modes.nc'];
latitude = ncread(dataname,'latitude');
longitude = ncread(dataname,'longitude');
%%
M2re_p1 = ncread(dataname,'M2re_p1'); %real part
M2im_p1 = ncread(dataname,'M2im_p1'); %imag part
amp_m2_mode1 = abs(complex(M2re_p1,M2im_p1));
amp_m2_mode1=amp_m2_mode1*1E+2; %amp_m2_mode1(amp_m2_mode1==0)=nan;
clear M2re_p1 M2im_p1
M2re_p2 = ncread(dataname,'M2re_p2'); %real part
M2im_p2 = ncread(dataname,'M2im_p2'); %imag part
amp_m2_mode2 = abs(complex(M2re_p2,M2im_p2));
amp_m2_mode2=amp_m2_mode2*1E+2; %amp_m2_mode2(amp_m2_mode2==0)=nan;
clear M2re_p2 M2im_p2

LONLIMS = [-28 -15];
LATLIMS = [12 20];
[LAT,LON] = meshgrid(latitude,longitude);
index = (LON>=LONLIMS(1)+360) & (LON<=LONLIMS(2)+360) & (LAT>=LATLIMS(1)) & (LAT<=LATLIMS(2)); 
[row_idx, col_idx] = find(index);
row_min = min(row_idx);
row_max = max(row_idx);
col_min = min(col_idx);
col_max = max(col_idx);
LON_CVA = LON(row_min:row_max, col_min:col_max)-360;
LAT_CVA = LAT(row_min:row_max, col_min:col_max);
Amp1_CVA = amp_m2_mode1(row_min:row_max, col_min:col_max);
Amp2_CVA = amp_m2_mode2(row_min:row_max, col_min:col_max);
save HRET_SSH.mat LON_CVA LAT_CVA Amp1_CVA Amp2_CVA

LONLIMS = [-26.5 -20.5];
LATLIMS = [14 18.01];

LONLIMS = [-28 -15];
LATLIMS = [12 20];
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;
m_pcolor(LON_CVA,LAT_CVA,Amp1_CVA);shading interp;hold on;
clim([0 2])
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','SSH(cm)','fontname','Arial','fontweight','bold');
    % m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;
m_pcolor(LON_CVA,LAT_CVA,Amp2_CVA);shading interp;hold on;
clim([0 1])
bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
set(get(bar,'Title'),'string','SSH(cm)','fontname','Arial','fontweight','bold');
    % m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);

    
m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;  
set(gca,'Layer','top','fontweight','bold');
    
% pcolor(amp_m2);shading interp;
% gph_m2 = atan2(-uIm,uRe)./pi*180;
% gph_m2((gph_m2>=-180 & gph_m2<0))=gph_m2((gph_m2>=-180 & gph_m2<0))+360;
% gph_m2(amp_m2==0)=nan;

lon_hret(:,:) = LON(index);lon_hret = lon_hret-360;
lat_hret(:,:)  = LAT(index);
SSH_m2_mode1_hret = amp_m2_mode1(index);
SSH_m2_mode2_hret = amp_m2_mode2(index);
clear longitude latitude amp_m2_mode1 amp_m2_mode2
% Pu_m2_MSM113 = gph_m2(index);
SSH_Mode1= griddata(lon_hret,lat_hret,SSH_m2_mode1_hret,lonp_grid,latp_grid);
SSH_Mode1(isnan(depto_grid))=nan;
SSH_Mode2= griddata(lon_hret,lat_hret,SSH_m2_mode2_hret,lonp_grid,latp_grid);
% SSH_Mode2(isnan(depto_grid))=nan;
figure(2);clf
pcolor(lonp_grid,latp_grid,SSH_Mode1);shading interp;clim([0 1])
figure(3);clf
pcolor(lonp_grid,latp_grid,SSH_Mode2);shading interp;clim([0 5])




