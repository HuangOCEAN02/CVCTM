clear;clc;close all
%% after running M2_modal_conversion
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../../../Grid/
%
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);

load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);

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
S_mode1 = zeros(ie,je,12,3);
S_mode2 = zeros(ie,je,12,3);
S_mode3 = zeros(ie,je,12,3);

for iy= 1:3
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Shear_term'];
        if iy==2
            loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Shear_term'];
        end
        if iy==3
            loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance/Shear_term'];
        end
        for m_select = 1:1:12
            im =1;
            load([loadloc,'/M2_Mode',num2str(im),'_ShearProduct_',month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
            S_mode1(:,:,m_select,iy) = PSmn_h_mode(:,:)+PSmn_v_mode;
            im =2;
            load([loadloc,'/M2_Mode',num2str(im),'_ShearProduct_',month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
            S_mode2(:,:,m_select,iy) = PSmn_h_mode(:,:)+PSmn_v_mode;
            im =3;
            % load([loadloc,'/M2_Mode_Three_ShearProduct_',month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
            load([loadloc,'/M2_Mode',num2str(im),'_ShearProduct_',month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
            S_mode3(:,:,m_select,iy) = PSmn_h_mode(:,:)+PSmn_v_mode;
        end
end
%%
S_mn = S_mode3+S_mode2+S_mode1;
S_mn_year = mean(S_mn,4,'omitmissing');
S_mn_upwelling = mean(S_mn_year(:,:,1:4),3,'omitmissing');
S_mn_relaxation = mean(S_mn_year(:,:,5:8),3,'omitmissing');
S_mn_downwelling = mean(S_mn_year(:,:,9:12),3,'omitmissing');
%%
S_mn_upwelling = topo_correct(S_mn_upwelling,'MSS');
S_mn_upwelling = S_mn_upwelling*1e+3; % mW
S_mn_relaxation = topo_correct(S_mn_relaxation,'MSS');
S_mn_relaxation = S_mn_relaxation*1e+3; % mW
S_mn_downwelling = topo_correct(S_mn_downwelling,'MSS');
S_mn_downwelling = S_mn_downwelling*1e+3; % mW
%%

saveloc = ['./Seasonaly_pics/']
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,S_mn_upwelling);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    load('BlWhRe.mat');colormap(BlWhRe);hold on;
        clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-2:0.5:2]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
        m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    title(['  $\sum_{n=1}^{3}\langle \overline{\textit{P}^{S}_n}  \rangle$'],...
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
   exportgraphics(gcf,[saveloc,'Upwelling_Ps.tiff'], 'Resolution',300);

figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,S_mn_relaxation);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    load('BlWhRe.mat');colormap(BlWhRe);hold on;
        clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-2:0.5:2]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
   title(['  $\sum_{n=1}^{3}\langle \overline{\textit{P}^{S}_n}  \rangle$'],...
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
    exportgraphics(gcf,[saveloc,'Relaxation_Ps.tiff'], 'Resolution',300);

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,S_mn_downwelling);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    load('BlWhRe.mat');colormap(BlWhRe);hold on;
      clim([-1 1])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-2:0.5:2]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold');
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
   title(['  $\sum_{n=1}^{3}\langle \overline{\textit{P}^{S}_n}  \rangle$'],...
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
   exportgraphics(gcf,[saveloc,'Downwelling_Ps.tiff'], 'Resolution',300);