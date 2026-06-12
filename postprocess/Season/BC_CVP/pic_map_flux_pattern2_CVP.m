clear;clc;close all
%% Total Conversion and flux 
Loc2014 ='../BC_MSS/mode_function_MSS/'
Loc2015='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/mode_function_MSS/';
Loc2016='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/mode_function_MSS/';

Loc2014_CVP ='./mode_function_CVP/'
Loc2015_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_CVP/mode_function_CVP/';
Loc2016_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_CVP/mode_function_CVP/';

month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
year_str = {'2014','2015','2016'};
addpath ../../Grid/

load("/Users/josephhuang/Desktop/workingplace/斜压模拟/内潮方程/M2_Cg_CVTM.mat",'lonp_grid','latp_grid');
lonp_grid_CVTM = lonp_grid;
latp_grid_CVTM = latp_grid;
clear latp_grid lonp_grid
%% 
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

 load('../BC_MSS/Pressure/NorthDakar_index.mat')
 lon_mcs  = lonp_grid(select_indicex,select_indicey);
 lat_mcs  = latp_grid(select_indicex,select_indicey);
   
 clear select_indicex select_indicey
    
 load('../BC_MSS/Pressure/SouthDakar_index.mat')
 lon_scs  = lonp_grid(select_indicex,select_indicey);
 lat_scs = latp_grid(select_indicex,select_indicey);


load('CapeVerdeplateau_index.mat')
depto_grid_CVP   = depto_grid(select_indicex,select_indicey);
weto_p_CVP       = weto_p(select_indicex,select_indicey,:);
lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
latp_grid_CVP = latp_grid(select_indicex,select_indicey);
dlxp_CVP = dlxp(select_indicex,select_indicey);
dlyp_CVP = dlyp(select_indicex,select_indicey);

load('CoastalDakar_index.mat')
depto_grid_MSS   = depto_grid(select_indicex,select_indicey);
weto_p_MSS       = weto_p(select_indicex,select_indicey,:);
lonp_grid_MSS = lonp_grid(select_indicex,select_indicey);
latp_grid_MSS = latp_grid(select_indicex,select_indicey);
dlxp_MSS = dlxp(select_indicex,select_indicey);
dlyp_MSS = dlyp(select_indicex,select_indicey);

depto_grid = [depto_grid_CVP;depto_grid_MSS];
weto_p = [weto_p_CVP;weto_p_MSS];
lonp_grid = [lonp_grid_CVP;lonp_grid_MSS];
latp_grid = [latp_grid_CVP;latp_grid_MSS];
dlxp_grid = [dlxp_CVP;dlxp_MSS];
dlyp_grid = [dlyp_CVP;dlyp_MSS];

load('CapeVerdeplateau_index.mat','select_indicex');
select_indicex_CVP = select_indicex;
load('CoastalDakar_index.mat','select_indicex');
select_indicex_MSS = select_indicex;
select_indicex = [select_indicex_CVP;select_indicex_MSS];


ie = size(depto_grid,1);
je = size(depto_grid,2);

clear ddpo_grid_CVP ddpo_grid_MSS zzout_CVP zzout_MSS depto_grid_CVP depto_grid_MSS
clear weto_p_CVP weto_p_MSS lonp_grid_CVP lonp_grid_MSS
clear latp_grid_CVP latp_grid_MSS
%% CVP plateau
select_indicex = find(lonp_grid(:,1)>=-24 & lonp_grid(:,1)<=-18.5);
select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.0);
lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
latp_grid_CVP = latp_grid(select_indicex,select_indicey);
depto_grid_CVP= depto_grid(select_indicex,select_indicey);

%% month
Flux_x_upwelling = zeros(ie,je,12,3);
Flux_y_upwelling  = zeros(ie,je,12,3);
C_upwelling =  zeros(ie,je,12,3);
R_upwelling =  zeros(ie,je,12,3);
Div_F_upwelling = zeros(ie,je,12,3);
pic_mode=1;
%% 2014
for m_select = 1:12
    load([Loc2014,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2014,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x_MSS=sum(Flux_x(:,:,pic_mode),3);Flux_y_MSS=sum(Flux_y(:,:,pic_mode),3);
    Div_F_MSS=sum(Div_F(:,:,pic_mode),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,pic_mode),3);
    clear Flux_x Flux_y C R Div_F

    load([Loc2014_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2014_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x = sum(Flux_x(:,:,pic_mode),3);
    Flux_y = sum(Flux_y(:,:,pic_mode),3);
    Div_F = sum(Div_F(:,:,pic_mode),3); Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,pic_mode),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;

    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,1) = Flux_x*1e-3.*depto_grid;%.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,1) = Flux_y*1e-3.*depto_grid;%.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,1) =  C;
    R_upwelling(:,:,m_select,1) = C - Div_F;
    Div_F_upwelling(:,:,m_select,1) = Div_F;

end
%% 2015
for m_select = 1:12
    load([Loc2015,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2015,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x_MSS=sum(Flux_x(:,:,pic_mode),3);Flux_y_MSS=sum(Flux_y(:,:,pic_mode),3);
    Div_F_MSS=sum(Div_F(:,:,pic_mode),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,pic_mode),3);
    clear Flux_x Flux_y C R Div_F

    load([Loc2015_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2015_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x = sum(Flux_x(:,:,pic_mode),3);
    Flux_y = sum(Flux_y(:,:,pic_mode),3);
    Div_F = sum(Div_F(:,:,pic_mode),3);Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,pic_mode),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;

    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,2) = Flux_x*1e-3.*depto_grid;%.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,2) = Flux_y*1e-3.*depto_grid;%.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,2) =  C;
    R_upwelling(:,:,m_select,2) = C - Div_F;
    Div_F_upwelling(:,:,m_select,2) = Div_F;
end
%% 2016
for m_select = 1:12
    load([Loc2016,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2016,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x_MSS=sum(Flux_x(:,:,pic_mode),3);Flux_y_MSS=sum(Flux_y(:,:,pic_mode),3);
    Div_F_MSS=sum(Div_F(:,:,pic_mode),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,pic_mode),3);
    clear Flux_x Flux_y C R Div_F

    load([Loc2016_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2016_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');

    Flux_x = sum(Flux_x(:,:,pic_mode),3);
    Flux_y = sum(Flux_y(:,:,pic_mode),3);
    Div_F = sum(Div_F(:,:,pic_mode),3);Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,pic_mode),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;

    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP C_MSS Div_F_MSS Div_F_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,3) = Flux_x*1e-3.*depto_grid;%.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,3) = Flux_y*1e-3.*depto_grid;%.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,3) =  C;
    R_upwelling(:,:,m_select,3) = C - Div_F;
    Div_F_upwelling(:,:,m_select,3) = Div_F;
end
%% season mean
Flux_x_upwelling_mean = mean(Flux_x_upwelling,4,'omitmissing');
Flux_y_upwelling_mean = mean(Flux_y_upwelling,4,'omitmissing');
Flux_x_upwelling_season = zeros(ie,je,3);
Flux_y_upwelling_season = zeros(ie,je,3);
Flux_x_upwelling_season(:,:,1) = mean(Flux_x_upwelling_mean(:,:,1:4),3);
Flux_y_upwelling_season(:,:,1)  = mean(Flux_y_upwelling_mean(:,:,1:4),3);
Flux_x_upwelling_season(:,:,2) = mean(Flux_x_upwelling_mean(:,:,5:8),3);
Flux_y_upwelling_season(:,:,2)  = mean(Flux_y_upwelling_mean(:,:,5:8),3);
Flux_x_upwelling_season(:,:,3) = mean(Flux_x_upwelling_mean(:,:,9:12),3);
Flux_y_upwelling_season(:,:,3)  = mean(Flux_y_upwelling_mean(:,:,9:12),3);


Flux_abs = sqrt(Flux_x_upwelling.^2 + Flux_y_upwelling.^2);
Var_Fu =  var(mean(Flux_x_upwelling,4,'omitmissing') ,0,3,"omitnan");
Var_Fv =  var(mean(Flux_y_upwelling,4,'omitmissing'),0,3,"omitnan");
Var_Fa =  var(mean(Flux_abs,4,'omitmissing'),0,3,"omitnan");
%% CVP in the CVTM
LocCVTM ='/Users/josephhuang/Desktop/workingplace/斜压模拟/内潮斜压流';
load([LocCVTM,'/M2_Flux.mat'],'Flux_x','Flux_y');
load([LocCVTM,'/M2_Flux_Divergence.mat'],'Div_F');


select_indicex_CVTM = find(lonp_grid_CVTM(:,1)>=-24 & lonp_grid_CVTM(:,1)<=-18.0);
select_indicey_CVTM = find(latp_grid_CVTM(1,:)>=14.5 & latp_grid_CVTM(1,:)<=18.3);

% 
lonp_grid_CVTM  = lonp_grid_CVTM(select_indicex_CVTM,select_indicey_CVTM);
latp_grid_CVTM  = latp_grid_CVTM(select_indicex_CVTM,select_indicey_CVTM);
Flux_x_CVTM(:,:) = Flux_x(select_indicex_CVTM,select_indicey_CVTM);
Flux_y_CVTM(:,:) = Flux_y(select_indicex_CVTM,select_indicey_CVTM);
Div_F_CVTM(:,:) = Div_F(select_indicex_CVTM,select_indicey_CVTM);
clear Flux_x Flux_y Div_F select_indicex_CVTM select_indicey_CVTM
%% 
mkdir ./EnergyBudget_CVP/Season_flux
LONLIMS = [-24 -17.5];
LATLIMS = [14.5 18.3];
%% CVTM
% arrow bar
% labelx = [-16.6,-16.50];labelz = [14.60,14.65];
% labelu = [0.1,0];labelv=[0,0];
% 
% fig_name = ['CVTM']
% for pp=1:1:1
%  figure(pp);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
%     m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
%     m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
% 
%     Flux_abs(:,:) = sqrt(Flux_x_CVTM(:,:).^2 + Flux_y_CVTM(:,:).^2);
%     % R_month(:,:) = R_upwelling(:,:,m_select,y_select);
%     % C_month(:,:) = C_upwelling(:,:,m_select,y_select);
%     % DF_month(:,:) = Div_F_upwelling(:,:,m_select,y_select);
%     Flux_month = Flux_abs; %topo_correct(Flux_abs,'MSS');
% 
%     % m_pcolor(lonp_grid,latp_grid,Flux_month);shading interp;hold on;
%     m_pcolor(lonp_grid_CVTM,latp_grid_CVTM,Flux_month);shading interp;hold on;
%     [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
%             'linewidth',1,'color',[.4 .4 .4]);hold on;
%     clabel(c,h,'LabelSpacing',1200,'color','k',...
%             'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
%     clim([0 0.5]);
%     % load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
%     % load('WhiteBlueGreenYellowRed.mat');colormap(WhiteBlueGreenYellowRed);hold on;
%     % clim([0 0.01])
% 
%     % load('wh_bl_gr_ye_re.mat');colormap(wh_bl_gr_ye_re)
%     run Flux_map.m
%     colormap(Flux_cmap);
%     bar = colorbar;set(bar,'fontsize',20,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
%     set(get(bar,'Title'),'string','kW m^-^1','fontname','Arial','fontweight','bold','Position',[-4.75 284.573912131685 0]);
%     set(bar,'Ticks',[0:0.5:1.5]);
%     % bar.Ruler.Exponent = -2;
% 
%     title(fig_name,...
%         'fontsize',30,'Interpreter','latex');
% 
%     XX_pic = lonp_grid_CVTM(2:10:end,2:10:end);
%     ZZ_pic = latp_grid_CVTM(2:10:end,2:10:end);
%     UU_pic = Flux_x_CVTM(2:10:end,2:10:end);
%     VV_pic = Flux_y_CVTM(2:10:end,2:10:end);
% 
%     scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
%     scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
%     scale_factor = scale_auto/scale_label;
% 
% 
%     % 
%     q_label= m_quiver(labelx,labelz,labelu,labelv,...
%                 2.0,'MaxHeadSize',1.5,'color','b','linewidth',1.8);
%     q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
%                 2.0/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.5);
%     set(q_minus,'MaxHeadSize',1.2);
% 
%      m_gshhs_h('patch',[.2 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
% end

%%
% arrow bar

labelx_CVP = [-21.9,-21.80];labelz_CVP = [14.6,14.65];
labelu_CVP = [4,0];labelv=[0,0];


XX_pic_CVP = lonp_grid(2:10:350,2:10:end);
ZZ_pic_CVP = latp_grid(2:10:350,2:10:end);

XX_pic_MSS = lonp_grid(352:10:end,2:10:end);
ZZ_pic_MSS = latp_grid(352:10:end,2:10:end);


SaveLocation = './EnergyBudget_CVP/Season_flux/';
fig_name = ['Variances'];

m_select = 1;
    figure(m_select);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
    m_proj('miller','lon',LONLIMS,'lat',LATLIMS);
    m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    

    
    Var_Fa(depto_grid<=250)=nan;

    Var_Fa((lonp_grid>=-22.2 & lonp_grid<=-21) & (latp_grid>=14 & latp_grid<=14.95))=nan;
    Var_Fa((lonp_grid>=-18.6 & lonp_grid<=-17.5) & (latp_grid>=14 & latp_grid<=14.95))=nan;
    depto_grid((lonp_grid>=-18.6 & lonp_grid<=-17.5) & (latp_grid>=14 & latp_grid<=14.95))=nan;
    m_pcolor(lonp_grid,latp_grid,Var_Fa);shading interp;hold on;clim([0 0.06]);
    [c,h]=m_contour(lonp_grid,latp_grid,depto_grid,[500:500:3500],...
            'linewidth',0.8,'color',[.4 .4 .4]);hold on;
    clabel(c,h,'LabelSpacing',1200,'color','k',...
            'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
    clim([0 0.06]);
    % load('NCV_blue_red.mat');colormap(NCV_blue_red);hold on;
    % load('WhiteBlueGreenYellowRed.mat');colormap(WhiteBlueGreenYellowRed);hold on;
    % clim([0 0.01])
    
    load('wh_bl_gr_ye_re.mat');colormap(wh_bl_gr_ye_re)
    bar = colorbar;set(bar,'fontsize',20,'fontname','Arial','Location','eastoutside','fontweight','bold','LineWidth',1.5);hold on;
    set(get(bar,'Title'),'String','kW^2 m^-^2','fontname','Arial','fontweight','bold','Position',[-23.5,293.8274194590086,0]);
    set(bar,'Ticks',[0:0.01:0.06]);
    bar.Ruler.Exponent = -2;

    annotation(figure(1),'textbox',...
    [0.427140467171716 0.866690433749258 0.109970643939393 0.0644553217601748],...
    'String','$ \sigma_{\textbf{\textit{|F|}}_{n=1}}$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',40,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');

%% CVP
UU_pic_CVP = mean(mean(Flux_x_upwelling(2:10:350,2:10:end,:,:),4,'omitmissing'),3,'omitmissing');
VV_pic_CVP = mean(mean(Flux_y_upwelling(2:10:350,2:10:end,:,:),4,'omitmissing'),3,'omitmissing');

scale_auto = Get_Autoscale(XX_pic_CVP,ZZ_pic_CVP,UU_pic_CVP,VV_pic_CVP); 
scale_label = Get_Autoscale(labelx_CVP,labelz_CVP,labelu_CVP,labelv);
scale_factor = scale_auto/scale_label;
    
% m_gshhs_h('patch',[.2 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);
% 


q_label= m_quiver(labelx_CVP,labelz_CVP,labelu_CVP,labelv,...
            6.5,'MaxHeadSize',1.5,'color','b','linewidth',1.8);

% (XX_pic_CVP>=-22 & XX_pic_CVP<=-21) & (ZZ_pic_CVP>=12 & ZZ_pic_CVP<=13.0);

UU_pic_CVP((XX_pic_CVP>=-22.2 & XX_pic_CVP<=-21) & (ZZ_pic_CVP>=14 & ZZ_pic_CVP<=14.95))=nan;
VV_pic_CVP((XX_pic_CVP>=-22.2 & XX_pic_CVP<=-21) & (ZZ_pic_CVP>=14 & ZZ_pic_CVP<=14.95))=nan;

q_minus = m_quiver(XX_pic_CVP,ZZ_pic_CVP,UU_pic_CVP,VV_pic_CVP,...
            6.5/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.5);
set(q_minus,'MaxHeadSize',1.2);

annotation(figure(1),'textbox',...
    [0.331020202020203 0.229482151835093 0.109090909090909 0.0492307692307688],...
    'String','4 kW m^-^1',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure(1),'rectangle',...
    [0.320353535353535,0.216923076923077,0.137424242424242,0.073403720462543],...
    'LineWidth',1.5);

%% MSS
labelx = [-18.4,-18.3];labelz = [14.6,14.65];
labelu = [2,0];labelv=[0,0];


UU_pic_MSS = mean(mean(Flux_x_upwelling(352:10:end,2:10:end,:,:),4,'omitmissing'),3,'omitmissing');
VV_pic_MSS = mean(mean(Flux_y_upwelling(352:10:end,2:10:end,:,:),4,'omitmissing'),3,'omitmissing');


scale_auto = Get_Autoscale(XX_pic_MSS,ZZ_pic_MSS,UU_pic_MSS,VV_pic_MSS); 
scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
scale_factor = scale_auto/scale_label;
    
UU_pic_MSS((XX_pic_MSS>=-18.5 & XX_pic_MSS<=-17.4) & (ZZ_pic_MSS>=14 & ZZ_pic_MSS<=14.95))=nan;
VV_pic_MSS((XX_pic_MSS>=-18.5 & XX_pic_MSS<=-17.4) & (ZZ_pic_MSS>=14 & ZZ_pic_MSS<=14.95))=nan;


q_minus = m_quiver(XX_pic_MSS,ZZ_pic_MSS,UU_pic_MSS,VV_pic_MSS,...
            8.0/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.5);
set(q_minus,'MaxHeadSize',1.2);


m_gshhs_h('patch',[.2 1 1],'edgecolor',[.4 .4 .4],'linewidth',0.5);

q_label= m_quiver(labelx,labelz,labelu,labelv,...
            8.0,'MaxHeadSize',1.5,'color','b','linewidth',1.8);
annotation(figure(1),'textbox',...
    [0.735020202020203,0.228868778280542,0.122424242424242,0.049230769230769],...
    'String','2 kW m^-^1',...
    'LineStyle','none',...
    'FontWeight','bold',...
    'FontSize',14,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');


annotation(figure(1),'rectangle',...
    [0.724137931034483,0.218461538461538,0.120133481646274,0.07032679738562],...
    'LineWidth',1.5);


    % select_indicex = find(lonp_grid(:,1)>=-22 & lonp_grid(:,1)<=-18);
    % select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.0);
    % lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
    % latp_grid_CVP = latp_grid(select_indicex,select_indicey);
    % m_plot(lonp_grid_CVP(1,:),latp_grid_CVP(1,:),'k-','linewidth',2.0);hold on;
    % m_plot(lonp_grid_CVP(end,:),latp_grid_CVP(end,:),'k-','linewidth',2.0);hold on;
    % m_plot(lonp_grid_CVP(:,1),latp_grid_CVP(:,1),'k-','linewidth',2.0);hold on;
    % m_plot(lonp_grid_CVP(:,end),latp_grid_CVP(:,end),'k-','linewidth',2.0);hold on;

    select_indicex = find(lonp_grid(:,1)>=-22 & lonp_grid(:,1)<=-18.5);
    select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.0);
    lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
    latp_grid_CVP = latp_grid(select_indicex,select_indicey);
    m_plot(lonp_grid_CVP(1,:),latp_grid_CVP(1,:),'k-','linewidth',4.0);hold on;
    m_plot(lonp_grid_CVP(end,:),latp_grid_CVP(end,:),'k-','linewidth',4.0);hold on;
    m_plot(lonp_grid_CVP(:,1),latp_grid_CVP(:,1),'k-','linewidth',4.0);hold on;
    m_plot(lonp_grid_CVP(:,end),latp_grid_CVP(:,end),'k-','linewidth',4.0);hold on;


    % m_plot(lonp_grid_CVP(121,:),latp_grid_CVP(121,:),'k-.','linewidth',4.0);hold on;
    m_plot(lonp_grid_CVP(61,:),latp_grid_CVP(61,:),'color','k','linewidth',4.0,'linestyle',':');hold on;

    % m_plot(lonp_grid_CVP(:,end),latp_grid_CVP(:,end),'k-.','linewidth',4.0);hold on;



    exportgraphics(gcf,[SaveLocation,'Flux1_pattern_',fig_name,'.tiff'], 'Resolution',300);


