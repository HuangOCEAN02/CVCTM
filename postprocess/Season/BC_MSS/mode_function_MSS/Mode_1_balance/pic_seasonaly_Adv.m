clear;clc;close all
%% after running M2_modal_conversion
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../../../Grid/
%
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid','bottom_index');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);

load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
bottom_index = bottom_index(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% MODE 1 !!!
pic_mode =1;
% Tide gauge
lat_s  = [17.9900 14.6767 ];
lon_s  = [-16.0367 -17.4200 ];
% pic domain
LATLIMS = [12.7 max(max(latp_grid))];
LONLIMS = [-19 -15];
%%
A_mode1 = zeros(ie,je,12,3);
A_mode2 = zeros(ie,je,12,3);
A_mode3 = zeros(ie,je,12,3);
load('../Modal_mask_MSS.mat');

for iy= 1:3
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Advection_term'];
        FunLocation = ['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function/']
        if iy==2
            loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Advection_term'];
            FunLocation = ['/Volumes/BackupPlus/CVCTM/标准实验/2015/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function/']
        end
        if iy==3
            loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Advection_term'];
            FunLocation = ['/Volumes/BackupPlus/CVCTM/标准实验/2016/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function/']
        end
        for m_select = 1:1:12
            Modal = ncread([FunLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_MSS.nc'],'Modal');
            Modal_mask_correct = Modal > 3;
            im =1;
            load([loadloc,'/M2_Mode',num2str(im),'_advection_',month_file{m_select}, '.mat'],'Amn_mode');
           % Amn_mode(Eigen_mask==0)*1e-1; 
            A_mode1(:,:,m_select,iy) = Amn_mode(:,:).*Modal_mask_correct; 
            im =2;
            load([loadloc,'/M2_Mode',num2str(im),'_advection_',month_file{m_select}, '.mat'],'Amn_mode');
           % Amn_mode(Eigen_mask==0)*1e-1; 
            A_mode2(:,:,m_select,iy) = Amn_mode(:,:).*Modal_mask_correct; 
            im =3;
            % 3-10
            % load([loadloc,'/M2_Mode',num2str(im),'_advection_',month_file{m_select}, '.mat'],'Amn_mode');
            % 3
            load([loadloc,'/M2_Mode_Three_advection_',month_file{m_select}, '.mat'],'Amn_mode');
            % Amn_mode(Eigen_mask==0)*1e-1;
             A_mode3(:,:,m_select,iy) = Amn_mode(:,:).*Modal_mask_correct; 
        end
end
%%
A_mn = A_mode3+A_mode2+A_mode1;
A_mn_year = mean(A_mn,4,'omitmissing');
A_mn_upwelling = mean(A_mn_year(:,:,1:4),3,'omitmissing');
A_mn_relaxation = mean(A_mn_year(:,:,5:8),3,'omitmissing');
A_mn_downwelling = mean(A_mn_year(:,:,9:12),3,'omitmissing');
% A_mn_upwelling = mean(A_mn_year(:,:,3),3,'omitmissing');
% A_mn_relaxation = mean(A_mn_year(:,:,7),3,'omitmissing');
% A_mn_downwelling = mean(A_mn_year(:,:,11),3,'omitmissing');
%%
A_mn_upwelling = topo_correct(A_mn_upwelling,'MSS');
A_mn_upwelling = A_mn_upwelling*1e+3; % mW
A_mn_relaxation = topo_correct(A_mn_relaxation,'MSS');
A_mn_relaxation = A_mn_relaxation*1e+3; % mW
A_mn_downwelling = topo_correct(A_mn_downwelling,'MSS');
A_mn_downwelling = A_mn_downwelling*1e+3; % mW

A_mn_upwelling(Eigen_mask==0)=0;
A_mn_relaxation(Eigen_mask==0)=0;
A_mn_downwelling(Eigen_mask==0)=0;

saveloc = ['./Seasonaly_pics/']
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,A_mn_upwelling);shading interp;hold on;
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    % load('ncl_default.mat');colormap(ncl_default);hold on;
    % load('MPL_RdYlGn.mat');colormap(MPL_RdYlGn);hold on;
     % load('WhiteZero.txt');colormap(WhiteZero);hold on;
    clim([-1 1])
    clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
          [-5:0.5:5]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
        m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    title(['  $\sum_{n=1}^{3}\langle \overline{\textit{A}_n}  \rangle$'],...
        'fontsize',30,'Interpreter','latex');
        % annotation(figure(1),'textbox',...
        %     [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        % 'String','Mar',...
        % 'LineStyle','none',...
        % 'FontWeight','bold',...
        % 'FontSize',25,...
        % 'FontName','Arial',...
        % 'FitBoxToText','off',...
        % 'EdgeColor','none');
  exportgraphics(gcf,[saveloc,'Upwelling_A.tiff'], 'Resolution',300);

    figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,A_mn_relaxation);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    % load('ncl_default.mat');colormap(ncl_default);hold on;
    %  load('WhiteZero.txt');colormap(WhiteZero);hold on;
   clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
          [-5:0.5:5]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
   title(['  $\sum_{n=1}^{3}\langle \overline{\textit{A}_n}  \rangle$'],...
        'fontsize',30,'Interpreter','latex');
        % annotation(figure(2),'textbox',...
        %     [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        % 'String','Jul',...
        % 'LineStyle','none',...
        % 'FontWeight','bold',...
        % 'FontSize',25,...
        % 'FontName','Arial',...
        % 'FitBoxToText','off',...
        % 'EdgeColor','none');
   exportgraphics(gcf,[saveloc,'Relaxation_A.tiff'], 'Resolution',300);

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650]);
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,A_mn_downwelling);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
        % 'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    % load('ncl_default.mat');colormap(ncl_default);hold on;
    %  load('WhiteZero.txt');colormap(WhiteZero);hold on;
    clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-5:0.5:5]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
   title(['  $\sum_{n=1}^{3}\langle \overline{\textit{A}_n}  \rangle$'],...
        'fontsize',30,'Interpreter','latex');
        % annotation(figure(3),'textbox',...
        %     [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        % 'String','Nov',...
        % 'LineStyle','none',...
        % 'FontWeight','bold',...
        % 'FontSize',25,...
        % 'FontName','Arial',...
        % 'FitBoxToText','off',...
        % 'EdgeColor','none');
   exportgraphics(gcf,[saveloc,'Downwelling_A.tiff'], 'Resolution',300);
