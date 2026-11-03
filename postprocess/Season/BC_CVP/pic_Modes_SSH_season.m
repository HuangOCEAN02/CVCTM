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
depto_grid_CVP   = depto_grid(select_indicex,select_indicey);
weto_p_CVP       = weto_p(select_indicex,select_indicey,:);
lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
latp_grid_CVP = latp_grid(select_indicex,select_indicey);

load('CoastalDakar_index.mat')
depto_grid_MSS   = depto_grid(select_indicex,select_indicey);
weto_p_MSS       = weto_p(select_indicex,select_indicey,:);
lonp_grid_MSS = lonp_grid(select_indicex,select_indicey);
latp_grid_MSS = latp_grid(select_indicex,select_indicey);

depto_grid = [depto_grid_CVP;depto_grid_MSS];
weto_p = [weto_p_CVP;weto_p_MSS];
lonp_grid = [lonp_grid_CVP;lonp_grid_MSS];
latp_grid = [latp_grid_CVP;latp_grid_MSS];

load('CapeVerdeplateau_index.mat','select_indicex');
select_indicex_CVP = select_indicex;
load('CoastalDakar_index.mat','select_indicex');
select_indicex_MSS = select_indicex;
select_indicex = [select_indicex_CVP;select_indicex_MSS];


ie = size(depto_grid,1);
je = size(depto_grid,2);
r0 = 1025;
%%
pic_mode =2;
SSHALocation_CVP = './Mode_SSH/';
SSHALocation_MSS = '../../BC_CVP/mode_function_CVP/Mode_SSH/';
SSHA_upwelling = zeros(ie,je,12,3);
count = 0;
for m_select = 1:12
    % 2014
    load(['./mode_function_CVP/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_CVP =  ssha_mode(:,:,pic_mode);
    load(['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_MSS =  ssha_mode(:,:,pic_mode);
    SSHA_upwelling(:,:,m_select,1) = [SSHA_upwelling_CVP;SSHA_upwelling_MSS];

    % 2015
    load(['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_CVP/mode_function_CVP/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_CVP = ssha_mode(:,:,pic_mode);
    load(['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_MSS = ssha_mode(:,:,pic_mode);
    SSHA_upwelling(:,:,m_select,2) = [SSHA_upwelling_CVP;SSHA_upwelling_MSS];


    % 2016
    load(['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_CVP/mode_function_CVP/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_CVP = ssha_mode(:,:,pic_mode);
    load(['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_SSH/M2_SSH_Mode_', month_file{m_select}, '.mat'], ...
     'ssha_mode');
    SSHA_upwelling_MSS = ssha_mode(:,:,pic_mode);
    SSHA_upwelling(:,:,m_select,3) = [SSHA_upwelling_CVP;SSHA_upwelling_MSS];


end

SSHA_upwelling_mean = mean(mean(SSHA_upwelling,4),3);

SSHA_upwelling_mean = SSHA_upwelling_mean *1e+2;

SSHA_upwelling_mean = topo_correct(SSHA_upwelling_mean,'CVA');
    
LONLIMS = [-26.5 -20.5];
LONLIMS = [-26.5 -20];
LATLIMS = [14 18];

    figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;
    m_pcolor(lonp_grid,latp_grid,SSHA_upwelling_mean);shading interp;hold on;
    
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
    % 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
    set(get(bar,'Title'),'string','SSH(cm)','fontname','Arial','fontweight','bold');
    % m_gshhs_h('patch',[1 1 1],'edgecolor','k','linewidth',1.0);
    if pic_mode==2
    set(bar,"Ticks",[0:0.25:1.5]);clim([0 1.5])
     sss=m_colmap('jet',18);
    colormap(sss);
    end
    if pic_mode==1
        set(bar,"Ticks",[0:0.5:4]);clim([0 4])
    sss=m_colmap('jet',20);
    colormap(sss);

    end
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    m_grid('linestyle','none','linewidth',1.5,'fontsize',28,'fontname','Arial');hold on;  
    set(gca,'Layer','top','fontweight','bold');
    SSHALocation = ['./Model_SSH']
   exportgraphics(gca,[SSHALocation,'/MEAN_SSH_Mode_',num2str(pic_mode),'.tiff'], 'Resolution',300);

