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
saveloc = ['./Monthly_pics/']
C_mode1 = zeros(ie,je,12,3);
C_mode2 = zeros(ie,je,12,3);
C_mode3 = zeros(ie,je,12,3);
Div_mode1 = zeros(ie,je,12,3);
Div_mode2 = zeros(ie,je,12,3);
Div_mode3 = zeros(ie,je,12,3);
for iy= 1:3
        loadlocmode1 = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_1'];
        loadlocmode2 = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_2'];
        loadlocmode3 = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_3'];
        loadlocflux = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Flux'];
       
        if iy==2
            loadlocmode1  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_1'];
            loadlocmode2  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_2'];
            loadlocmode3  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_3'];
            loadlocflux = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Flux'];
       
        end
        if iy==3
            loadlocmode1  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_1'];
            loadlocmode2  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_2'];
            loadlocmode3  = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Gene_3'];
            loadlocflux = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_Flux'];
       
        end
        for m_select = 1:1:12
            load([loadlocmode1,'/M2_Mode1_Conversion_',month_file{m_select}, '.mat'],'C_mode');
            C_mode1(:,:,m_select,iy) = C_mode(:,:);
            load([loadlocmode2,'/M2_Mode2_Conversion_',month_file{m_select}, '.mat'],'C_mode');
            C_mode2(:,:,m_select,iy) = C_mode(:,:);
            load([loadlocmode3,'/M2_Mode3_Conversion_',month_file{m_select}, '.mat'],'C_mode');
            C_mode3(:,:,m_select,iy) = C_mode(:,:);

            load([loadlocflux,'/M2_Flux_Mode_',month_file{m_select}, '.mat'],'Div_F');
            Div_mode1(:,:,m_select,iy) = Div_F(:,:,1);
            Div_mode2(:,:,m_select,iy) = Div_F(:,:,2);
            Div_mode3(:,:,m_select,iy) = Div_F(:,:,3);
        end
end

Res_mode1 = C_mode1 - Div_mode1;
Res_mode2 = C_mode2 - Div_mode2;
Res_mode3 = C_mode3 - Div_mode3;

R_mn = Res_mode3+Res_mode2+Res_mode1;
R_mn_year = mean(R_mn,4,'omitmissing');
R_mn_upwelling = mean(R_mn_year(:,:,3),3,'omitmissing');
R_mn_relaxation = mean(R_mn_year(:,:,7),3,'omitmissing');
R_mn_downwelling = mean(R_mn_year(:,:,11),3,'omitmissing');
%%
R_mn_upwelling = topo_correct(R_mn_upwelling,'MSS');
R_mn_upwelling = R_mn_upwelling*1e+3; % mW
R_mn_relaxation = topo_correct(R_mn_relaxation,'MSS');
R_mn_relaxation = R_mn_relaxation*1e+3; % mW
R_mn_downwelling = topo_correct(R_mn_downwelling,'MSS');
R_mn_downwelling = R_mn_downwelling*1e+3; % mW
%%

saveloc = ['./Monthly_pics/']
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,R_mn_upwelling);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    % load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    % load('ncl_default.mat');colormap(ncl_default);hold on;
    load('MPL_RdYlGn_r.mat');colormap(MPL_RdYlGn_r);hold on;
    load('MPL_PuOr_r.mat');colormap(MPL_PuOr_r);hold on
       clim([-16 16])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-16:4:16]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold','Position',[46.99999999999999,376.7499999999999,0]);
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
        m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    title(['  $\sum_{n=1}^{3}\langle \overline{\textit{C}_n}  \rangle - \nabla_{h}\cdot \langle \overline{\textbf{\textit{F}}_{n}} \rangle$'],...
        'fontsize',30,'Interpreter','latex');
     annotation(figure(1),'textbox',...
            [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        'String','Mar',...
        'LineStyle','none',...
        'FontWeight','bold',...
        'FontSize',25,...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    exportgraphics(gcf,[saveloc,'March_R1_to_3.tiff'], 'Resolution',300);

figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,R_mn_relaxation);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
    %     'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('MPL_RdYlGn_r.mat');colormap(MPL_RdYlGn_r);hold on;
        load('MPL_PuOr_r.mat');colormap(MPL_PuOr_r);hold on
      clim([-16 16])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-16:4:16]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold','Position',[46.99999999999999,376.7499999999999,0]);
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    title(['  $\sum_{n=1}^{3}\langle \overline{\textit{C}_n}  \rangle - \nabla_{h}\cdot \langle \overline{\textbf{\textit{F}}_{n}} \rangle$'],...
        'fontsize',30,'Interpreter','latex');
        annotation(figure(2),'textbox',...
            [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        'String','Jul',...
        'LineStyle','none',...
        'FontWeight','bold',...
        'FontSize',25,...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    exportgraphics(gcf,[saveloc,'July_R1_to_3.tiff'], 'Resolution',300);

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    m_pcolor(lonp_grid,latp_grid,R_mn_downwelling);shading interp;hold on;
    
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[250:250:3500],...
        'linewidth',0.4,'color',[.4 .4 .4]);hold on;
    % clabel(c,h,'LabelSpacing',1200,'color','k',...
        % 'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    load('MPL_RdYlGn_r.mat');colormap(MPL_RdYlGn_r);hold on;
        load('MPL_PuOr_r.mat');colormap(MPL_PuOr_r);hold on
       clim([-16 16])
    %% 
    bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold','Ticks', ...
        [-16:4:16]);hold on;
    set(get(bar,'Title'),'string','mW m^-^2','fontname','Arial','fontweight','bold','Position',[46.99999999999999,376.7499999999999,0]);
    
    m_gshhs_h('patch',[1 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
    set(gca,'Layer','top','fontweight','bold');
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    title(['  $\sum_{n=1}^{3}\langle \overline{\textit{C}_n}  \rangle - \nabla_{h}\cdot \langle \overline{\textbf{\textit{F}}_{n}} \rangle$'],...
        'fontsize',30,'Interpreter','latex');
        annotation(figure(3),'textbox',...
            [0.588716531274929,0.819999999999998,0.080172357613959,0.049230769230769],...
        'String','Nov',...
        'LineStyle','none',...
        'FontWeight','bold',...
        'FontSize',25,...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'EdgeColor','none');
    exportgraphics(gcf,[saveloc,'Nov_R1_to_3.tiff'], 'Resolution',300);