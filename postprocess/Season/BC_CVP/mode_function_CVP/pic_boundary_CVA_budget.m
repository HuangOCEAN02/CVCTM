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

month_str_short = {'J','F','M','A','M','J','J','A','S','O','N','D'};

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
%% CVA 
select_indicex = find(lonp_grid(:,1)>=-20 & lonp_grid(:,1)<=-18.5);
select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.0);


select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-21.8);
select_indicey = find(latp_grid(1,:)>=14.4 & latp_grid(1,:)<=18.0);


select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-21.8);
select_indicey = find(latp_grid(1,:)>=14.4 & latp_grid(1,:)<=17.5);


% lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
% latp_grid_CVP = latp_grid(select_indicex,select_indicey);
% depto_grid_CVP= depto_grid(select_indicex,select_indicey);

dlxp_grid(isnan(depto_grid))=0;
dlyp_grid(isnan(depto_grid))=0;
%% month
Flux_x_upwelling = zeros(ie,je,12,3);
Flux_y_upwelling  = zeros(ie,je,12,3);
C_upwelling =  zeros(ie,je,12,3);
R_upwelling =  zeros(ie,je,12,3);
Div_F_upwelling = zeros(ie,je,12,3);
%% 2014
for m_select = 1:12
    load([Loc2014,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2014,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2014,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode;
    Pbmn_MSS = PBmn_mode;
    PSmn_h_MSS = PSmn_h_mode; 
    PSmn_v_MSS = PSmn_v_mode;
    % Mode 2
    load([Loc2014,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;
    % Mode 3 ~ 10
    load([Loc2014,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;

    Flux_x_MSS=sum(Flux_x(:,:,1),3);Flux_y_MSS=sum(Flux_y(:,:,1),3);
    Div_F_MSS=sum(Div_F(:,:,:),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,:),3);
    clear Flux_x Flux_y C R Div_F

    load([Loc2014_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2014_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2014_CVP,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode;
    Pbmn_CVP = PBmn_mode;
    PSmn_h_CVP = PSmn_h_mode; 
    PSmn_v_CVP = PSmn_v_mode;
    % Mode 2
    load([Loc2014_CVP,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;
    % Mode 3 ~ 10
    load([Loc2014_CVP,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2014_CVP,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;

    Flux_x = sum(Flux_x(:,:,1),3);
    Flux_y = sum(Flux_y(:,:,1),3);
    Div_F = sum(Div_F(:,:,:),3); Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,:),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;

    Amn_CVP(end,:) = (Amn_CVP(end-1,:) + Amn_MSS(1,:))/2.0;
    Pbmn_CVP(end,:) = (Pbmn_CVP(end-1,:) + Pbmn_MSS(1,:))/2.0;
    PSmn_h_CVP(end,:) = (PSmn_h_CVP(end-1,:) + PSmn_h_MSS(1,:))/2.0;
    PSmn_v_CVP(end,:) = (PSmn_v_CVP(end-1,:) + PSmn_v_MSS(1,:))/2.0;

    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    Amn = [Amn_CVP;Amn_MSS];
    Pbmn = [Pbmn_CVP;Pbmn_MSS];
    Pshmn = [PSmn_h_CVP;PSmn_h_MSS];
    Psvmn = [PSmn_v_CVP;PSmn_v_MSS];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    clear Amn_CVP Amn_MSS Pbmn_CVP Pbmn_MSS PSmn_h_CVP PSmn_h_MSS PSmn_v_CVP PSmn_v_MSS
    Flux_x_upwelling(:,:,m_select,1) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,1) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,1) =  C.*dlxp_grid.*dlyp_grid;
    R_upwelling(:,:,m_select,1) = (C - Div_F).*dlxp_grid.*dlyp_grid;
    Div_F_upwelling(:,:,m_select,1) = Div_F.*dlxp_grid.*dlyp_grid;
    
    Amn_upwelling(:,:,m_select,1)  = Amn.*dlxp_grid.*dlyp_grid;
    Pbmn_upwelling(:,:,m_select,1) = Pbmn.*dlxp_grid.*dlyp_grid;
    Pshmn_upwelling(:,:,m_select,1) = Pshmn.*dlxp_grid.*dlyp_grid;
    Psvmn_upwelling(:,:,m_select,1) = Psvmn.*dlxp_grid.*dlyp_grid;

end
%% 2015
for m_select = 1:12
    load([Loc2015,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2015,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2015,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode;
    Pbmn_MSS = PBmn_mode;
    PSmn_h_MSS = PSmn_h_mode; 
    PSmn_v_MSS = PSmn_v_mode;
    % Mode 2
    load([Loc2015,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;
    % Mode 3 ~ 10
    load([Loc2015,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;

    Flux_x_MSS=sum(Flux_x(:,:,1),3);Flux_y_MSS=sum(Flux_y(:,:,1),3);
    Div_F_MSS=sum(Div_F(:,:,:),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,:),3);
    clear Flux_x Flux_y C R Div_F

    load([Loc2015_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2015_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2015_CVP,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode;
    Pbmn_CVP = PBmn_mode;
    PSmn_h_CVP = PSmn_h_mode; 
    PSmn_v_CVP = PSmn_v_mode;
    % Mode 2
    load([Loc2015_CVP,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;
    % Mode 3 ~ 10
    load([Loc2015_CVP,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2015_CVP,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;

    Flux_x = sum(Flux_x(:,:,1),3);
    Flux_y = sum(Flux_y(:,:,1),3);
    Div_F = sum(Div_F(:,:,:),3);Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,:),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;
    Amn_CVP(end,:) = (Amn_CVP(end-1,:) + Amn_MSS(1,:))/2.0;
    Pbmn_CVP(end,:) = (Pbmn_CVP(end-1,:) + Pbmn_MSS(1,:))/2.0;
    PSmn_h_CVP(end,:) = (PSmn_h_CVP(end-1,:) + PSmn_h_MSS(1,:))/2.0;
    PSmn_v_CVP(end,:) = (PSmn_v_CVP(end-1,:) + PSmn_v_MSS(1,:))/2.0;


    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    Amn = [Amn_CVP;Amn_MSS];
    Pbmn = [Pbmn_CVP;Pbmn_MSS];
    Pshmn = [PSmn_h_CVP;PSmn_h_MSS];
    Psvmn = [PSmn_v_CVP;PSmn_v_MSS];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    clear Amn_CVP Amn_MSS Pbmn_CVP Pbmn_MSS PSmn_h_CVP PSmn_h_MSS PSmn_v_CVP PSmn_v_MSS
    Flux_x_upwelling(:,:,m_select,2) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,2) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,2) =  C.*dlxp_grid.*dlyp_grid;
    R_upwelling(:,:,m_select,2) = (C - Div_F).*dlxp_grid.*dlyp_grid;
    Div_F_upwelling(:,:,m_select,2) = Div_F.*dlxp_grid.*dlyp_grid;
    Amn_upwelling(:,:,m_select,2)  = Amn.*dlxp_grid.*dlyp_grid;
    Pbmn_upwelling(:,:,m_select,2) = Pbmn.*dlxp_grid.*dlyp_grid;
    Pshmn_upwelling(:,:,m_select,2) = Pshmn.*dlxp_grid.*dlyp_grid;
    Psvmn_upwelling(:,:,m_select,2) = Psvmn.*dlxp_grid.*dlyp_grid;
end
%% 2016
for m_select = 1:12
    load([Loc2016,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2016,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2016,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode;
    Pbmn_MSS = PBmn_mode;
    PSmn_h_MSS = PSmn_h_mode; 
    PSmn_v_MSS = PSmn_v_mode;
    % Mode 2
    load([Loc2016,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;
    % Mode 3 ~ 10
    load([Loc2016,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_MSS = Amn_mode + Amn_MSS;
    Pbmn_MSS = PBmn_mode + Pbmn_MSS;
    PSmn_h_MSS = PSmn_h_mode + PSmn_h_MSS;
    PSmn_v_MSS = PSmn_v_mode + PSmn_v_MSS;

    Flux_x_MSS=sum(Flux_x(:,:,1),3);Flux_y_MSS=sum(Flux_y(:,:,1),3);
    Div_F_MSS=sum(Div_F(:,:,:),3);Div_F_MSS(1,:) = Div_F_MSS(2,:);
    C_MSS =sum(C(:,:,:),3);
    clear Flux_x Flux_y C R Div_F Amn_mode PBmn_mode PSmn_h_mode PSmn_v_mode

    load([Loc2016_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y','Div_F');
    load([Loc2016_CVP,'Mode_Gene/M2_Model_Conversion_', month_file{m_select}, '.mat'],'C');
    % Mode 1
    load([Loc2016_CVP,'Mode_1_balance/Advection_term/M2_Mode1_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode1_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Shear_term/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode;
    Pbmn_CVP = PBmn_mode;
    PSmn_h_CVP = PSmn_h_mode; 
    PSmn_v_CVP = PSmn_v_mode;
    % Mode 2
    load([Loc2016_CVP,'Mode_1_balance/Advection_term/M2_Mode2_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode2_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Shear_term/M2_Mode2_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;
    % Mode 3 ~ 10
    load([Loc2016_CVP,'Mode_1_balance/Advection_term/M2_Mode3_advection_', month_file{m_select}, '.mat'],'Amn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Buoyancy_term/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'],'PBmn_mode');
    load([Loc2016_CVP,'Mode_1_balance/Shear_term/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'],'PSmn_h_mode','PSmn_v_mode');
    Amn_CVP = Amn_mode + Amn_CVP;
    Pbmn_CVP = PBmn_mode + Pbmn_CVP;
    PSmn_h_CVP = PSmn_h_mode + PSmn_h_CVP;
    PSmn_v_CVP = PSmn_v_mode + PSmn_v_CVP;
    Flux_x = sum(Flux_x(:,:,1),3);
    Flux_y = sum(Flux_y(:,:,1),3);
    Div_F = sum(Div_F(:,:,:),3);Div_F(end,:) = Div_F(end-1,:);
    C =sum(C(:,:,:),3);

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Div_F(end,:) = (Div_F(end-1,:) + Div_F_MSS(1,:))/2.0;
    C(end,:) = (C(end-1,:) + C_MSS(1,:))/2.0;
    Amn_CVP(end,:) = (Amn_CVP(end-1,:) + Amn_MSS(1,:))/2.0;
    Pbmn_CVP(end,:) = (Pbmn_CVP(end-1,:) + Pbmn_MSS(1,:))/2.0;
    PSmn_h_CVP(end,:) = (PSmn_h_CVP(end-1,:) + PSmn_h_MSS(1,:))/2.0;
    PSmn_v_CVP(end,:) = (PSmn_v_CVP(end-1,:) + PSmn_v_MSS(1,:))/2.0;

    Flux_x_CVP(:,:) = Flux_x(:,:);Flux_y_CVP(:,:) = Flux_y(:,:);
    Div_F_CVP(:,:) = Div_F(:,:);C_CVP(:,:) = C(:,:);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    Div_F = [Div_F_CVP;Div_F_MSS];
    C = [C_CVP;C_MSS];
    Amn = [Amn_CVP;Amn_MSS];
    Pbmn = [Pbmn_CVP;Pbmn_MSS];
    Pshmn = [PSmn_h_CVP;PSmn_h_MSS];
    Psvmn = [PSmn_v_CVP;PSmn_v_MSS];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_CVP C_MSS Div_F_MSS Div_F_CVP
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    clear Amn_CVP Amn_MSS Pbmn_CVP Pbmn_MSS PSmn_h_CVP PSmn_h_MSS PSmn_v_CVP PSmn_v_MSS
    Flux_x_upwelling(:,:,m_select,3) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,3) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,3) =  C.*dlxp_grid.*dlyp_grid;
    R_upwelling(:,:,m_select,3) = (C - Div_F).*dlxp_grid.*dlyp_grid;
    Div_F_upwelling(:,:,m_select,3) = Div_F.*dlxp_grid.*dlyp_grid;
    Amn_upwelling(:,:,m_select,3)  = Amn.*dlxp_grid.*dlyp_grid;
    Pbmn_upwelling(:,:,m_select,3) = Pbmn.*dlxp_grid.*dlyp_grid;
    Pshmn_upwelling(:,:,m_select,3) = Pshmn.*dlxp_grid.*dlyp_grid;
    Psvmn_upwelling(:,:,m_select,3) = Psvmn.*dlxp_grid.*dlyp_grid;
end
%% CVP in the CVCTM
Flux_x_upwelling = Flux_x_upwelling(select_indicex,select_indicey,:,:);  % MW
Flux_y_upwelling = Flux_y_upwelling(select_indicex,select_indicey,:,:);  % MW
R_upwelling = R_upwelling(select_indicex,select_indicey,:,:);
C_upwelling = C_upwelling(select_indicex,select_indicey,:,:);

Amn_upwelling = Amn_upwelling(select_indicex,select_indicey,:,:);
Pbmn_upwelling = Pbmn_upwelling(select_indicex,select_indicey,:,:);
Pshmn_upwelling = Pshmn_upwelling(select_indicex,select_indicey,:,:);
Psvmn_upwelling = Psvmn_upwelling(select_indicex,select_indicey,:,:);
%% UNITS: W
% First column: Energy generation
% Second column: West boundary energy flux 
% Third column: East boundary energy flux 
% Fourth column: North boundary energy flux 
% Fifth column: South boundary energy flux 
% Sixed column: Energy dissipation
% seventh column: Energy radiation

Region_energy_M2 =  zeros(8,12,3);
% conversion
Region_energy_M2(1,:,:) = sum(sum(C_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2(1,:,:) = Region_energy_M2(1,:,:)*1e-6; % MW
% W and E
Region_energy_M2(2,:,:) = sum(Flux_x_upwelling(1,:,:,:),2,'omitmissing');
Region_energy_M2(3,:,:) = sum(Flux_x_upwelling(end,:,:,:),2,'omitmissing');
% N and S
Region_energy_M2(4,:,:) = sum(Flux_y_upwelling(:,1,:,:),1,'omitmissing');
Region_energy_M2(5,:,:) = sum(Flux_y_upwelling(:,end,:,:),1,'omitmissing');
% dissipation
Region_energy_M2(6,:,:) = sum(sum(R_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2(6,:,:) = Region_energy_M2(6,:,:)*1e-6; % MW
% Divergence
Region_energy_M2(7,:,:) = sum(sum(Div_F_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2(7,:,:) = Region_energy_M2(7,:,:)*1e-6; % MW

% Amn
Region_energy_M2_terms(1,:,:) = sum(sum(Amn_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2_terms(1,:,:) = Region_energy_M2_terms(1,:,:)*1e-6; % MW

% Pbmn
Region_energy_M2_terms(2,:,:) = sum(sum(Pbmn_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2_terms(2,:,:) = Region_energy_M2_terms(2,:,:)*1e-6; % MW

% Pshmn
Region_energy_M2_terms(3,:,:) = sum(sum(Pshmn_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2_terms(3,:,:) = Region_energy_M2_terms(3,:,:)*1e-6; % MW

% Psvmn
Region_energy_M2_terms(4,:,:) = sum(sum(Psvmn_upwelling(:,:,:,:),1,'omitmissing'),2,"omitmissing");
Region_energy_M2_terms(4,:,:) = Region_energy_M2_terms(4,:,:)*1e-6; % MW

%% 逐月平均
Region_energy_M2_climate = mean(Region_energy_M2,3,'omitmissing');
Region_energy_M2_terms_climate = mean(Region_energy_M2_terms,3,'omitmissing');
Region_energy_M2_std = std(Region_energy_M2,0,3);
%% 计算比率


FN = [squeeze(Region_energy_M2(4,:,1)),squeeze(Region_energy_M2(4,:,2)),squeeze(Region_energy_M2(4,:,3))];
FE = [squeeze(Region_energy_M2(3,:,1)),squeeze(Region_energy_M2(3,:,2)),squeeze(Region_energy_M2(3,:,3))];
FE_alpha = FE./(FN+FE);
FN_alpha = 1-FE_alpha;

%%
m = 12;
x=[1:m];
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 950 950])
h1 = axes('position',[0.1 0.7 0.81 0.24]);

yyaxis left
% plot(x,squeeze(Region_energy_M2_climate(1,:)),'Color','r','LineWidth',2,'DisplayName','$\langle \overline{\textbf{\textit{C}}} \rangle$');hold on;
plot([1:36],[squeeze(Region_energy_M2(1,:,1)),squeeze(Region_energy_M2(1,:,2)),squeeze(Region_energy_M2(1,:,3))],'Color','r','LineWidth',2,'DisplayName','$\langle \overline{\textbf{\textit{C}}} \rangle$');hold on;
set(gca,'YColor','r','YLim',[1800 2200]);
set(gca,'YColor','r','YLim',[1800 2200],'YTick',[1800:100:2200]);
ax= gca;
ax.YAxis(1).Exponent = 3;
yyaxis right
plot([1:36],[squeeze(Region_energy_M2(6,:,1)),squeeze(Region_energy_M2(6,:,2)),squeeze(Region_energy_M2(6,:,3))],'Color','b','LineWidth',2,'DisplayName','$\langle \overline{\textbf{\textit{D}}} \rangle$');hold on;

% plot([1:12],squeeze(Region_energy_M2_climate(6,:)),'Color','b','LineWidth',2,'DisplayName','$\langle \overline{\textbf{\textit{D}}} \rangle$');hold on;

h=legend;
set(h,...
    'Orientation','horizontal',...
    'Location','northwest',...
    'Interpreter','latex',...
    'NumColumns',2,...
    'LineWidth',2,...
    'FontSize',15,...
    'AutoUpdate','off');
set(gca,'YColor','b','YLim',[950 1250]);
set(gca,'YColor','b','YLim',[950 1250],'YTick',[950:75:1250]);
ax.YAxis(2).Exponent = 3;
% yyaxis left
% x2 = [x, fliplr(x)];                                % x + 翻转后的 x
% inBetween = [Region_energy_M2_climate(1,:) + Region_energy_M2_std(1,:), fliplr(Region_energy_M2_climate(1,:) - Region_energy_M2_std(1,:))];
% fill(x2, inBetween, [0.87 0.71 0.71], ...              % 灰色阴影
%      'EdgeColor', 'none', 'FaceAlpha', 0.4);
% yyaxis right
% inBetween = [Region_energy_M2_climate(6,:) + Region_energy_M2_std(6,:), fliplr(Region_energy_M2_climate(6,:) - Region_energy_M2_std(6,:))];
% fill(x2, inBetween, [0.63 0.93 1], ...              % 灰色阴影
%      'EdgeColor', 'none', 'FaceAlpha', 0.2);



% winter
x_winter = 0.5;y_low = 500;
x_winter1 = 12.5;y_high = 1500;
x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边


fill(x_fill, y_fill,[0.4,0.4,1.00], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Winter');hold on;

% relaxation
x_relaxation = 12.5;
x_relaxation1 = 24.5;
x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.4,0.4,0.01], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Relaxation');hold on;
% Summer
x_summer = 24.5;
x_summer1 = 36.5;
x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边

fill(x_fill, y_fill,[0.4,0.4,0.5], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none', ...      % 去掉边框
    'DisplayName', 'Summer');hold on;

plot([12.5,12.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;
plot([24.5,24.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;
set(gca,'xtick',[1:36],'XTickLabel',{' '});
xlim([0.5 36.5]);
grid on;box on;set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',20,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   
% set(gca,'xtick',[1:36],'XTickLabel',month_str_short);
% plot([1:36],[squeeze(Region_energy_M2(3,:,1))+squeeze(Region_energy_M2(4,:,1)), ...
%     squeeze(Region_energy_M2(3,:,2))+squeeze(Region_energy_M2(4,:,2)), ...
%     squeeze(Region_energy_M2(3,:,3))+squeeze(Region_energy_M2(4,:,3))],'Color',[0.4940 0.1840 0.5560],'LineWidth',2,'DisplayName','$\langle  \overline{\textbf{\textit{{F}}}_{n=1}}^{CVA}_{east} \rangle$');hold on;
% 

h2 = axes('position',[0.1 0.4 0.81 0.24]);
yyaxis left
plot([1:36],[squeeze(Region_energy_M2(3,:,1)),squeeze(Region_energy_M2(3,:,2)),squeeze(Region_energy_M2(3,:,3))],'Color',[0.4940 0.1840 0.5560],'LineWidth',2,'DisplayName','$\langle  \overline{\textbf{\textit{{F}}}_{n=1}}^{CVA}_{east} \rangle$');hold on;
FE = [squeeze(Region_energy_M2(3,:,1)),squeeze(Region_energy_M2(3,:,2)),squeeze(Region_energy_M2(3,:,3))];
FN = [squeeze(Region_energy_M2(4,:,1)),squeeze(Region_energy_M2(4,:,2)),squeeze(Region_energy_M2(4,:,3))];

% plot([1:12],squeeze(Region_energy_M2_climate(3,:)),'LineStyle','-','Color',[0.4940 0.1840 0.5560],'LineWidth',2,'DisplayName','$\langle  \overline{\textbf{\textit{{F}}}_{n=1}}^{CVA}_{east} \rangle$');hold on;
set(gca,'YColor',[0.4940 0.1840 0.5560],'YLim',[50 110],'YTick',[50:12:110]);

yyaxis right
plot([1:36],[squeeze(Region_energy_M2(4,:,1)),squeeze(Region_energy_M2(4,:,2)),squeeze(Region_energy_M2(4,:,3))],'Color',[0.39 0.83 0.07],'LineWidth',2,'DisplayName','$\langle  \overline{\textbf{\textit{{F}}}_{n=1}}^{CVA}_{north} \rangle$');hold on;

%plot([1:12],squeeze(Region_energy_M2_climate(4,:)),'LineStyle','-','Color',[0.39 0.83 0.07],'LineWidth',2,'DisplayName','$\langle \overline{\textbf{\textit{{F}}}_{n=1}}^{CVA}_{north} \rangle$');hold on;
set(gca,'YColor',[0.39 0.83 0.07],'YLim',[130 230],'YTick',[130:20:230]);
h=legend;
set(h,...
    'Position',[0.369153813585052,0.579335883762879,0.274633514747191,0.049431570931245],...
    'Orientation','horizontal',...
    'NumColumns',2,...
    'LineWidth',2,...
    'Interpreter','latex',...
    'FontSize',14,...
    'AutoUpdate','off');
x_season = zeros(4,3);
x_season(:,1)=[0.5 4.5,8.5,12.5];
x_season(:,2)=[0.5 4.5,8.5,12.5] +12;
x_season(:,3)=[0.5 4.5,8.5,12.5] +24;
for m_year = 1:3
    % winter
    x_winter = x_season(1,m_year);y_low = 130;
    x_winter1 = x_season(2,m_year);y_high = 500;
    x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
    y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
    
    
    fill(x_fill, y_fill,[0.07,0.62,1.00], ...
        'FaceAlpha', 0.1, ...         % 透明度
        'EdgeColor', 'none', ...      % 去掉边框
        'DisplayName', 'Winter');hold on;
    
    % relaxation
    x_relaxation = x_season(2,m_year);
    x_relaxation1 = x_season(3,m_year);
    x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
    y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
    
    fill(x_fill, y_fill,[0.92,0.68,0.01], ...
        'FaceAlpha', 0.1, ...         % 透明度
        'EdgeColor', 'none', ...      % 去掉边框
        'DisplayName', 'Relaxation');hold on;
    % Summer
    x_summer = x_season(3,m_year);
    x_summer1 = x_season(4,m_year);
    x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
    y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
    
    fill(x_fill, y_fill,[0.85,0.33,0.15], ...
        'FaceAlpha', 0.1, ...         % 透明度
        'EdgeColor', 'none', ...      % 去掉边框
        'DisplayName', 'Summer');hold on;
end


% set(gca,'xtick',[1:36],'XTickLabel',{' '});
set(gca,'xtick',[1:36],'XTickLabel',month_str_short);
xlim([0.5 36.5]);
grid on;box on;set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',20,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  
plot([12.5,12.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;
plot([24.5,24.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;
% 
% h3 = axes('position',[0.1 0.1 0.81 0.24]);
% yyaxis left
% plot([1:36],FE_alpha*100,'LineWidth',2,'DisplayName','$R_{east}$');hold on;
% set(gca,'YLim',[20 40],'YTick',[20:10:40]);
% 
% yyaxis right
% plot([1:36],FN_alpha*100,'LineWidth',2,'DisplayName','$R_{north}$');hold on;
% set(gca,'YLim',[60 80],'YTick',[60:5:80]);
% h=legend;
% set(h,...
%     'Position',[0.43538642488199,0.11467911700918,0.191378818469101,0.037593831592689],...
%     'Orientation','horizontal',...
%     'NumColumns',2,...
%     'LineWidth',2,...
%     'Interpreter','latex',...
%     'FontSize',14,...
%     'AutoUpdate','off');
% set(gca,'xtick',[1:36],'XTickLabel',month_str_short);
% for m_year = 1:3
%     % winter
%     x_winter = x_season(1,m_year);y_low = 0;
%     x_winter1 = x_season(2,m_year);y_high = 500;
%     x_fill = [x_winter'; x_winter'; x_winter1';x_winter1'];     % 左右拼接
%     y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
% 
% 
%     fill(x_fill, y_fill,[0.07,0.62,1.00], ...
%         'FaceAlpha', 0.1, ...         % 透明度
%         'EdgeColor', 'none', ...      % 去掉边框
%         'DisplayName', 'Winter');hold on;
% 
%     % relaxation
%     x_relaxation = x_season(2,m_year);
%     x_relaxation1 = x_season(3,m_year);
%     x_fill = [x_relaxation'; x_relaxation'; x_relaxation1';x_relaxation1'];     % 左右拼接
%     y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
% 
%     fill(x_fill, y_fill,[0.92,0.68,0.01], ...
%         'FaceAlpha', 0.1, ...         % 透明度
%         'EdgeColor', 'none', ...      % 去掉边框
%         'DisplayName', 'Relaxation');hold on;
%     % Summer
%     x_summer = x_season(3,m_year);
%     x_summer1 = x_season(4,m_year);
%     x_fill = [x_summer'; x_summer'; x_summer1';x_summer1'];     % 左右拼接
%     y_fill = [y_low; y_high;y_high; y_low]; % 上下两条边
% 
%     fill(x_fill, y_fill,[0.85,0.33,0.15], ...
%         'FaceAlpha', 0.1, ...         % 透明度
%         'EdgeColor', 'none', ...      % 去掉边框
%         'DisplayName', 'Summer');hold on;
% end
% 
% set(gca,'xtick',[1:36],'XTickLabel',month_str_short);
% xlim([0.5 36.5]);
% grid on;box on;set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
% set(gca,'fontsize',20,'LineWidth',2,'fontname','Arial',...
% 'Xaxislocation','bottom','fontweight','bold');  
% plot([12.5,12.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;
% plot([24.5,24.5],[y_low,y_high],'linestyle','--','color','k','LineWidth',0.8);hold on;

exportgraphics(gcf,['./EnergyBudget_CVA/CVA_boundary_budget.tiff'], 'Resolution',300);


%%
