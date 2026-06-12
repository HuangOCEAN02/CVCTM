clear;clc;close all
%% load modal eigenfunctions & Define the topographic coupleing coefficients
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
%% Model global grid
addpath ../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','bottom_index','zzout','ddpo_grid');
load('Grid_resolution.mat', 'dlyv','dlxu');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);
dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);
zzout= Exclude_sponge(iw,ie,jn,js,zzout);
ddpo_grid= Exclude_sponge(iw,ie,jn,js,ddpo_grid);
ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

load('CapeVerdeplateau_index.mat')
weto_p       = weto_p(select_indicex,select_indicey,:);
ddpo_grid = ddpo_grid(select_indicex,select_indicey,:);
depto_grid   = depto_grid(select_indicex,select_indicey);
bottom_index  = bottom_index(select_indicex,select_indicey);
zzout = zzout(select_indicex,select_indicey,:);
dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
Modeloc=['./Mode_function'];
Buoyaloc = './Buoyancy';
MeanCurrentloc = ['../../Average/BackgroundCurrent'];
Meanbuoyancyloc = ['../../Average/Stratification'];
% Modeloc=['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function'];
if ~exist('Mean_effective_term','dir'); mkdir Mean_effective_term; end
%addpath /Users/josephhuang/Desktop/workingplace/斜压模拟/内潮基本要素/IT_functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
imodes = 10;
g=9.81;
issign = 1;
for m_select = 1:12
    disp([num2str(m_select),'  Month']);
    wmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wmodes'); 
    wzmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wzmodes'); 
    zwmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'zwmodes'); 
    Cmodes = ncread([Modeloc,'/M2_Modal_eigenspeed_',month_file{m_select},'_CVP.nc'],'ce'); 
    load([Buoyaloc,'/M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'Eigen_level')
    load([MeanCurrentloc,'/ave_uoo_', month_file{m_select}, '_CVCTM.mat'],'UOO_month');
    load([MeanCurrentloc,'/ave_voe_', month_file{m_select}, '_CVCTM.mat'],'VOE_month');
    load([Meanbuoyancyloc,'/ave_roo_', month_file{m_select}, '_CVCTM.mat'],'roo_month');
     load(['./Stratification/ave_Nsquare_',month_file{m_select},'_from_ts_CVP.mat'],'Nsquare_month');
    UOO_region = UOO_month(select_indicex,select_indicey,:);
    VOE_region = VOE_month(select_indicex,select_indicey,:);
    BOO_region = -g.* (roo_month(select_indicex,select_indicey,:) - 1025)./1025;

    if issign
        sgn = ncread([Modeloc,'/M2_Modal_Sign_',month_file{m_select},'_CVP.nc'],'sign');
        sign4 = reshape(sgn, size(sgn,1), size(sgn,2), 1, size(sgn,3));
        for k = 1:size(wmodes,3)
            wmodes(:,:,k,:) = (wmodes(:,:,k,:)).*sign4(:,:,:,:);
        end
        for k = 1:size(wzmodes,3)
            wzmodes(:,:,k,:) = wzmodes(:,:,k,:).*sign4(:,:,:,:);
        end
    end
    %% Bmn
    Box = zeros(size(BOO_region));
    Boy = zeros(size(BOO_region));    
    for k = 1: size(BOO_region,3)
             % NOTE:
            % array row = physical -y
            % array col = physical +x
             % [BOdHy,BOdHx] = gradient(BOO_region(:,:,k));
             % Box(:,:,k) = BOdHx./dlxu;
             % Boy(:,:,k) = -BOdHy./dlyv;
             mask2d = weto_p(:,:,k)~=0;  
             [Box(:,:,k), Boy(:,:,k)]= grad2_ocean_noland_orctm(BOO_region(:,:,k),mask2d, dlxu, dlyv);
    end

    w_mid_modes = zeros(ie,je,ke,imodes);
    wz_mid_modes = zeros(ie,je,ke,imodes);

        % Vertical interpolation to mid point for vertical integration
        for i = 1:ie
            for j =1:je
                if weto_p(i,j,1)~=0
                    ke_level = sum(weto_p(i,j,:));
                    nz = Eigen_level(i,j);
                    zz = squeeze(zwmodes(i,j,1:nz))';
                    zu = squeeze(zzout(i,j,1:ke_level))';
                    for ii = 1: imodes
                        wz_mid_modes(i,j,1:ke_level,ii) =  Back2Depth(squeeze(wzmodes(i,j,1:nz,ii)),zz,zu);
                        w_mid_modes(i,j,1:ke_level,ii)  = Back2Depth(squeeze(wmodes(i,j,1:nz,ii)),zz,zu);
                    end
                end
            end  
        end
%% Bmn
    Bmn_x = zeros(ie,je,imodes,imodes);
    Bmn_y = zeros(ie,je,imodes,imodes);

    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
                ke_level = sum(weto_p(i,j,:));
                % 上三角
                for m = 1:imodes-1
                    for n=m+1:imodes
                        Bmn_x(i,j,m,n)= ...
                            sum((Box(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Bmn_y(i,j,m,n)= ...
                            sum((Boy(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    end
                end
                 % 对角线
                for m = 1: imodes
                    n=m;
                    Bmn_x(i,j,m,n)= ...
                        sum((Box(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    Bmn_y(i,j,m,n)= ...
                        sum((Boy(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                end
                 % 下三角
                for n = 1:imodes-1
                    for m=n+1:imodes
                        Bmn_x(i,j,m,n)= ...
                            sum((Box(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Bmn_y(i,j,m,n)= ...
                            sum((Boy(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    end
                end    
            end
        end
    end

    save(['./Mean_effective_term/Mean_buoyancy_Bmn_', month_file{m_select}, '.mat'], ...
         'Bmn_x','Bmn_y','-v7.3');

%% Umn
    Umn_x = zeros(ie,je,imodes,imodes);
    Umn_y = zeros(ie,je,imodes,imodes);

    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
                ke_level = sum(weto_p(i,j,:));
                % 上三角
                for m = 1:imodes-1
                    for n=m+1:imodes
                        Umn_x(i,j,m,n)= ...
                            sum((UOO_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Umn_y(i,j,m,n)= ...
                            sum((VOE_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Umn_x(i,j,n,m) = Umn_x(i,j,m,n);
                        Umn_y(i,j,n,m) = Umn_y(i,j,m,n);
                    end
                end
                 % 对角线
                for m = 1: imodes
                    n=m;
                    Umn_x(i,j,m,n)= ...
                        sum((UOO_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    Umn_y(i,j,m,n)= ...
                        sum((VOE_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                end
 
            end
        end
    end

    save(['./Mean_effective_term/Mean_velocity_Umn_', month_file{m_select}, '.mat'], ...
         'Umn_x','Umn_y','-v7.3');
%% Upmn    
    Upmn_x = zeros(ie,je,imodes,imodes);
    Upmn_y = zeros(ie,je,imodes,imodes);

    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
                ke_level = sum(weto_p(i,j,:));
                % 上三角
                for m = 1:imodes-1
                    for n=m+1:imodes
                        Upmn_x(i,j,m,n)= ...
                            sum((UOO_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,m)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Upmn_y(i,j,m,n)= ...
                            sum((VOE_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,m)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Upmn_x(i,j,n,m) = Upmn_x(i,j,m,n);
                        Upmn_y(i,j,n,m) = Upmn_y(i,j,m,n);
                    end
                end
                 % 对角线
                for m = 1: imodes
                    n=m;
                    Upmn_x(i,j,m,n)= ...
                        sum((UOO_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,m)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    Upmn_y(i,j,m,n)= ...
                        sum((VOE_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,m)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                end
 
            end
        end
    end

    save(['./Mean_effective_term/Mean_velocity_Upmn_', month_file{m_select}, '.mat'], ...
         'Upmn_x','Upmn_y','-v7.3');
%% Uzmn  
    Uzmn_x = zeros(ie,je,imodes,imodes);
    Uzmn_y = zeros(ie,je,imodes,imodes);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
                ke_level = sum(weto_p(i,j,:));
                % 上三角
                for m = 1:imodes
                    for n=1:imodes
                        Uzmn_x(i,j,m,n)= ...
                            sum((UOO_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,n)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j) - ...
                            sum((UOO_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                        Uzmn_y(i,j,m,n)= ...
                            sum((VOE_region(i,j,1:ke_level).*(Nsquare_month(i,j,1:ke_level)./(Cmodes(i,j,n)^2)).*w_mid_modes(i,j,1:ke_level,m).*w_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j) - ...
                            sum((VOE_region(i,j,1:ke_level).*wz_mid_modes(i,j,1:ke_level,m).*wz_mid_modes(i,j,1:ke_level,n)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                    end
                end
            end
        end
    end
    save(['./Mean_effective_term/Mean_velocity_Uzmn_', month_file{m_select}, '.mat'], ...
         'Uzmn_x','Uzmn_y','-v7.3');    
end
