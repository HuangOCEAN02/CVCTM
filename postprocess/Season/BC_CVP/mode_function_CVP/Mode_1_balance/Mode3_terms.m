clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
%% Model global grid
addpath ../../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','bottom_index');
load('Grid_resolution.mat', 'dlyv','dlxu');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);
dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);

ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

load('CapeVerdeplateau_index.mat')
select_indicexu = [select_indicex(1)-1;select_indicex];
select_indiceyv = [select_indicey(1)-1,select_indicey];


weto_p       = weto_p(select_indicex,select_indicey,:);
depto_grid   = depto_grid(select_indicex,select_indicey);
bottom_index  = bottom_index(select_indicex,select_indicey);

dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
energytermsloc = ['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_CVP/mode_function_CVP/Equation_term/'];
SaveLocation = ['./Shear_term/']

imodes = 10;
pic_mode = 2;  % mode2
rou0 = 1025;
load('../Modal_mask_CVP.mat')
for m_select = 1 : 12
    PSmn_h_mode = zeros(ie,je);
    PSmn_v_mode = zeros(ie,je);
    %% Amn_bt  : A0n
    load([energytermsloc,'ShearProduct_BT_',month_file{m_select},'.mat'],'PSmn_v_bt','PSmn_h_bt');
    PSmn_h_mode(:,:) = sum(PSmn_h_bt(:,:,3:10,2),3).*rou0; % m=0;n=3:10
    PSmn_v_mode(:,:) = sum(PSmn_v_bt(:,:,3:10,2),3).*rou0; % m=0;n=3:10    
    %% Amn : Amn
    load([energytermsloc,'ShearProduct_',month_file{m_select},'.mat'],'PSmn_v','PSmn_h');
    for pic_mode = 3:10
    for m = 1:imodes
          PSmn_h_mode(:,:) = PSmn_h_mode(:,:) + PSmn_h(:,:,m,pic_mode)*rou0;
          PSmn_v_mode(:,:) = PSmn_v_mode(:,:) + PSmn_v(:,:,m,pic_mode)*rou0;
    end
    end
    PSmn_h_mode = PSmn_h_mode.*Eigen_mask;
    PSmn_v_mode = PSmn_v_mode.*Eigen_mask;
    save([SaveLocation,'/M2_Mode3_ShearProduct_', month_file{m_select}, '.mat'], ...
         'PSmn_h_mode','PSmn_v_mode','-v7.3');

end
%%
SaveLocation = ['./Buoyancy_term/']
for m_select = 1 : 12
    PBmn_mode = zeros(ie,je);
    PBmn_b_mode = zeros(ie,je);    
    %% Amn_bt  : A0n
    load([energytermsloc,'BuoyancyProduct_BT_',month_file{m_select},'.mat'],'PBmn_bt','PBmn_bt_b');
    PBmn_mode(:,:) =  sum(PBmn_bt(:,:,3:10,2),3).*rou0; % m=0;n=1
    PBmn_b_mode(:,:) = sum(PBmn_bt_b(:,:,3:10,2),3).*rou0;
    %% Amn : Amn
    load([energytermsloc,'BuoyancyProduct_',month_file{m_select},'.mat'],'PBmn','PBmn_b');
    for pic_mode = 3:10
    for m = 1:imodes
          PBmn_mode(:,:) = PBmn_mode(:,:) + PBmn(:,:,m,pic_mode)*rou0;
          PBmn_b_mode(:,:) = PBmn_b_mode(:,:) + PBmn_b(:,:,m,pic_mode)*rou0;
    end
    end
    PBmn_mode = PBmn_mode.*Eigen_mask;
    PBmn_b_mode = PBmn_b_mode.*Eigen_mask;
    save([SaveLocation,'/M2_Mode3_BuoyancyProduct_', month_file{m_select}, '.mat'], ...
         'PBmn_mode','PBmn_b_mode','-v7.3');

end
SaveLocation = ['./Advection_term/']
for m_select = 1 : 12
    Amn_mode = zeros(ie,je);
    %% Amn_bt  : A0n
    load([energytermsloc,'Advection_BT_',month_file{m_select},'.mat'],'Amn_bt');
    Amn_mode(:,:) =  sum(Amn_bt(:,:,3:10,2),3).*rou0; % m=0;n=2
    %% Amn : Amn
    load([energytermsloc,'Advection_',month_file{m_select},'.mat'],'Amn');
     for pic_mode = 3:10
        for m = 1:imodes
              Amn_mode(:,:) = Amn_mode(:,:) + Amn(:,:,m,pic_mode)*rou0;
        end
     end
    Amn_mode = Amn_mode.*Eigen_mask;
    save([SaveLocation,'/M2_Mode3_advection_', month_file{m_select}, '.mat'], ...
         'Amn_mode','-v7.3');

end