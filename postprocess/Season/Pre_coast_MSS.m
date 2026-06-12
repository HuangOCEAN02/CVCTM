clear;clc;close all
%% Find the index of coast to calculate the spave-average
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid','latp_grid','lonp_grid');
load('Grid_info_u.mat','weto_u','latu_grid');
load('Grid_info_v.mat','weto_v','latv_grid');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')


iw = 10;ie = 1;
jn = 10;js = 10;

latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid = Exclude_sponge(iw,ie,jn,js,lonp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);
latu_grid  = Exclude_sponge(iw,ie,jn,js,latu_grid);
latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

%%
load('CoastalDakar_index.mat')
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
depto_grid = depto_grid(select_indicex,select_indicey);
dlxp = dlxp(select_indicex,select_indicey);
dlyp = dlyp(select_indicex,select_indicey);
% latu_grid = latu_grid([select_indicex(1)-1;select_indicex],select_indicey);
% latv_grid = latv_grid(select_indicex,[select_indicey(1)-1,select_indicey]);
% weto_u = weto_u([select_indicex(1)-1;select_indicex],select_indicey,:);
% weto_v = weto_v(select_indicex,[select_indicey(1)-1,select_indicey],:);

ie = size(depto_grid,1);
je = size(depto_grid,2);
dlyp(isnan(depto_grid))=nan;
dlxp(isnan(depto_grid))=nan;
%% filling the Penisula and Esturary
depto_grid(216:229,230:235)=nan;
depto_grid(256:263,278:290)=nan;
depto_grid(262:283,298:320)=nan;
depto_grid(256:end,291:307)=nan;
depto_grid(256:end,308:321)=nan;
%% New coordinate for coastal area
[coast_groups, comp_labels, comp_count] = find_coastline_idx(depto_grid, 4);
coast_index=coast_groups{1,1};

[coast_row, coast_col] = ind2sub([ie, je], coast_index);
[C,IA,IC] = unique(coast_col);

figure(1);clf
plot(lonp_grid(coast_row(IA),coast_col(IA)),'bo');
% Estuary from 340-398 in coast_index
m_plot(lonp_grid(coast_index),latp_grid(coast_index),'r*');hold on;
m_plot(lonp_grid(coast_index-30),latp_grid(coast_index-30),'b*');hold on;

LATLIMS = [12.1 18.35];
LONLIMS = [-21 -15];
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1100 650])
m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;


[c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:4000],...
    'linewidth',1.0,'color',[.4 .4 .4]);hold on;
clabel(c,h,'LabelSpacing',1500,'color','k',...
    'fontsize',10,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

coast_row_unique = coast_row(IA);
coast_col_unique = coast_col(IA);
for p = 1: length(coast_row_unique)
    lon_coast(p) = lonp_grid(coast_row_unique(p),coast_col_unique(p));
    lat_coast(p) = latp_grid(coast_row_unique(p),coast_col_unique(p));

    if lat_coast(p)<=15
        lon_sea(p) = lonp_grid(coast_row_unique(p)-50,coast_col_unique(p));
        lat_sea(p) = latp_grid(coast_row_unique(p)-50,coast_col_unique(p)); 
    else
        lon_sea(p) = lonp_grid(coast_row_unique(p)-30,coast_col_unique(p));
        lat_sea(p) = latp_grid(coast_row_unique(p)-30,coast_col_unique(p));
    end
    % m_plot(lonp_grid(coast_row_unique(p),coast_col_unique(p)),latp_grid(coast_row_unique(p),coast_col_unique(p)),'r*');hold on;
    % m_plot(lonp_grid(coast_row_unique(p)-30,coast_col_unique(p)),latp_grid(coast_row_unique(p),coast_col_unique(p)),'b*');hold on;
end
m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
m_plot(lon_coast,lat_coast,'Color','r','linewidth',2,'linestyle','-');hold on;
m_plot(lon_sea,lat_sea,'Color','b','linewidth',2,'linestyle','-');hold on;

coast_x = coast_row_unique;
coast_y = coast_col_unique;
save ../Grid/MSS_coast_index.mat lon_coast lat_coast lon_sea lat_sea coast_x coast_y