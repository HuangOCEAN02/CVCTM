clear;clc;close all
%% comparions after pre_HRET_SSH.m
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
SSHALocation = './Model_SSH'
%% HRET
load('HRET_SSH.mat');
 
LONLIMS = [-26.5 -20];
LATLIMS = [14 18.01];

    figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;
    % m_pcolor(lonp_grid,latp_grid,SSHA_upwelling);shading interp;hold on;
    m_pcolor(LON_CVA,LAT_CVA,Amp1_CVA);shading interp;hold on;
    clim([0 4])
     % load('BlueDarkRed18.mat');colormap(BlueDarkRed18);
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
        'linewidth',0.5,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    % % load('NCV_jet.mat');colormap(NCV_jet);hold on;
    % load('GMT_seis_r.mat');colormap(GMT_seis_r)
    % load('rh_19lev.mat');colormap(rh_19lev);hold on;
    % load('MPL_RdYlBu_r.mat');colormap(MPL_RdYlBu_r)
    % load('GMT_panoply.mat');colormap(GMT_panoply);
    sss=m_colmap('jet',20);
    colormap(sss);
    
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
    set(get(bar,'Title'),'string','SSH(cm)','fontname','Arial','fontweight','bold');
    set(bar,"Ticks",[0:0.5:4]);clim([0 4])
    % m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
 
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',1);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;  
    set(gca,'Layer','top','fontweight','bold');
    exportgraphics(gca,[SSHALocation,'/HRET_SSH_Mode_1.tiff'], 'Resolution',300);



    figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;
    % m_pcolor(lonp_grid,latp_grid,SSHA_upwelling);shading interp;hold on;
    m_pcolor(LON_CVA,LAT_CVA,Amp2_CVA);shading interp;hold on;
    clim([0 1.5])
     load('BlueDarkRed18.mat');colormap(BlueDarkRed18);
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
        'linewidth',0.5,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    % % load('NCV_jet.mat');colormap(NCV_jet);hold on;
    % load('GMT_seis_r.mat');colormap(GMT_seis_r)
    % load('rh_19lev.mat');colormap(rh_19lev);hold on;
    % load('MPL_RdYlBu_r.mat');colormap(MPL_RdYlBu_r)
    % load('GMT_panoply.mat');colormap(GMT_panoply);
    
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
    set(get(bar,'Title'),'string','SSH(cm)','fontname','Arial','fontweight','bold');
    % m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
     set(bar,"Ticks",[0:0.25:1.5]);
     sss=m_colmap('jet',18);
    colormap(sss);
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',1);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;  
    set(gca,'Layer','top','fontweight','bold');
      exportgraphics(gca,[SSHALocation,'/HRET_SSH_Mode_2.tiff'], 'Resolution',300);
  
