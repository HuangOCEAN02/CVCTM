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
select_indicexu = [select_indicex;select_indicex(end)+1];
select_indiceyv = [select_indicey,select_indicey(end)+1];

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
% Modeloc=['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function'];
Buoyaloc = ['./Buoyancy'];

if ~exist('Mode_TCE','dir'); mkdir Mode_TCE; end
%addpath /Users/josephhuang/Desktop/workingplace/斜压模拟/内潮基本要素/IT_functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
imodes = 10;
issign = 1;
for m_select = 1:12
    disp([num2str(m_select),'  Month']);
    wzmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wzmodes'); 
    zwmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'zwmodes'); 
    load([Buoyaloc,'/M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'Eigen_level')
    if issign
        sgn = ncread([Modeloc,'/M2_Modal_Sign_',month_file{m_select},'_CVP.nc'],'sign');
        sign4 = reshape(sgn, size(sgn,1), size(sgn,2), 1, size(sgn,3));
        for k = 1:size(wzmodes,3)
            wzmodes(:,:,k,:) = wzmodes(:,:,k,:).*sign4(:,:,:,:);
        end
    end
    %%
    wz_mid_modes    = zeros(ie,je,ke,imodes);
    wzdHx_mid_modes = zeros(ie,je,ke,imodes);
    wzdHy_mid_modes = zeros(ie,je,ke,imodes);
    for ii = 1: imodes
        % Horizontal gradient
         disp([num2str(ii),' mode']);
         wzdHy_modes = zeros(ie,je,ke);
         wzdHx_modes = zeros(ie,je,ke);
         for k = 1: size(wzmodes,3)
             % NOTE:
            % array row = physical -y
            % array col = physical +x
             % [wzdHy,wzdHx] = gradient(wzmodes(:,:,k,ii));
             % wzdHx_modes(:,:,k) = wzdHx./dlxu;
             % wzdHy_modes(:,:,k) = -wzdHy./dlyv;
             wetmask = Eigen_level(:,:)>=k;
             [wzdHx_modes(:,:,k), wzdHy_modes(:,:,k)] = grad2_ocean_noland_orctm(wzmodes(:,:,k,ii), wetmask, dlxu, dlyv);
         end
 

        % Vertical interpolation to mid point for vertical integration
        for i = 1:ie
            for j =1:je
                if weto_p(i,j,1)~=0
                    ke_level = sum(weto_p(i,j,:));
                    nz = Eigen_level(i,j);
                    zz = squeeze(zwmodes(i,j,1:nz))';
                    zu = squeeze(zzout(i,j,1:ke_level))';
                    wz_mid_modes(i,j,1:ke_level,ii) =  Back2Depth(squeeze(wzmodes(i,j,1:nz,ii)),zz,zu);
                    wzdHx_mid_modes(i,j,1:ke_level,ii)  = Back2Depth(squeeze(wzdHx_modes(i,j,1:nz)),zz,zu);
                    wzdHy_mid_modes(i,j,1:ke_level,ii)  = Back2Depth(squeeze(wzdHy_modes(i,j,1:nz)),zz,zu);
                end
            end  
        end
    end

    T_x = zeros(ie,je,imodes,imodes);
    T_y = zeros(ie,je,imodes,imodes);


            for i = 1:ie
                for j =1:je
                    if weto_p(i,j,1)~=0
                        ke_level = sum(weto_p(i,j,:));
                        for m = 1:imodes-1
                            for n=m+1:imodes
                                T_x(i,j,m,n)= sum((wz_mid_modes(i,j,1:ke_level,n).*wzdHx_mid_modes(i,j,1:ke_level,m)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                                T_y(i,j,m,n)= sum((wz_mid_modes(i,j,1:ke_level,n).*wzdHy_mid_modes(i,j,1:ke_level,m)).*ddpo_grid(i,j,1:ke_level),3)./depto_grid(i,j);
                                T_x(i,j,n,m) = - T_x(i,j,m,n);
                                T_y(i,j,n,m)= - T_y(i,j,m,n);
                            end
                        end
                         % 对角线为0
                end
            end
        end


save(['./Mode_TCE/M2_TGC_', month_file{m_select}, '.mat'], ...
     'T_x','T_y','-v7.3');
end
