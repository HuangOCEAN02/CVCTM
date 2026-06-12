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

load('CoastalDakar_index.mat')
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
energytermsloc = ['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Equation_term/'];

SaveLocation = ['./Shear_term/']
imodes = 10;
pic_mode = 1;  % mode1
rou0 = 1025;
load('../Modal_mask_MSS.mat')
for m_select = 1 : 12
    PSmn_h_mode = zeros(ie,je);
    PSmn_v_mode = zeros(ie,je);
    %% Amn_bt  : A0n
    load([energytermsloc,'ShearProduct_BT_',month_file{m_select},'.mat'],'PSmn_v_bt','PSmn_h_bt');
    PSmn_h_mode(:,:) = PSmn_h_bt(:,:,1,2)*rou0; % m=0;n=1
    PSmn_v_mode(:,:) = PSmn_v_bt(:,:,1,2)*rou0; % m=0;n=1    
    %% Amn : Amn
    load([energytermsloc,'ShearProduct_',month_file{m_select},'.mat'],'PSmn_v','PSmn_h');
    % mode 1 n=1
    for m = 1:imodes
          PSmn_h_mode(:,:) = PSmn_h_mode(:,:) + PSmn_h(:,:,m,pic_mode)*rou0;
          PSmn_v_mode(:,:) = PSmn_v_mode(:,:) + PSmn_v(:,:,m,pic_mode)*rou0;
    end
    % PSmn_h_mode = PSmn_h_mode.*Eigen_mask;
    % PSmn_v_mode = PSmn_v_mode.*Eigen_mask;
    save([SaveLocation,'/M2_Mode1_ShearProduct_', month_file{m_select}, '.mat'], ...
         'PSmn_h_mode','PSmn_v_mode','-v7.3');

end