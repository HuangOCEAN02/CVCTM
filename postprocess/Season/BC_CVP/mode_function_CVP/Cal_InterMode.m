clear;clc;close all
%% Mode-1
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
%% Model global grid
addpath ../../../Grid/
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
select_indicexu = [select_indicex;select_indicex(end)+1];
select_indiceyv = [select_indicey,select_indicey(end)+1];

weto_p       = weto_p(select_indicex,select_indicey,:);
depto_grid   = depto_grid(select_indicex,select_indicey);
bottom_index  = bottom_index(select_indicex,select_indicey);

dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);

[dHy,dHx] = gradient(-depto_grid);
dHx = dHx./dlxu;
dHy = -dHy./dlyv;
clear dlxu dlyv
%%
Modeloc=['./Mode_function'];
Pressloc = ['./Pressure'];
Buoyaloc = ['./Buoyancy'];
Velocityloc = ['./Velocity']
TCEloc = ['./Mode_TCE']
if ~exist('InterMode_Gene','dir'); mkdir InterMode_Gene; end
imodes = 10;
SaveLocation = ['./InterMode_Gene'];
issign = 1;
for m_select = 1: 12
    disp(['Month =', num2str(m_select)])    
    %% load modal eigenfunctions & the topographic couplig coefficients
    wzmodes = ncread([Modeloc,'/M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wzmodes'); 
    if issign
        sign = ncread([Modeloc,'/M2_Modal_Sign_',month_file{m_select},'_CVP.nc'],'sign');
        sign4 = reshape(sign, size(sign,1), size(sign,2), 1, size(sign,3));
        for k = 1:size(wzmodes,3)
            wzmodes(:,:,k,:) = wzmodes(:,:,k,:).*sign4(:,:,:,:);
        end
    end
    pm = real(wzmodes(:,:,:,1:imodes));
    load([Pressloc,'/M2_Modal_Pressure_',month_file{m_select},'.mat'],'Amp_p','Pha_p');
    load([Velocityloc,'/M2_Modal_Horizontal_Meridional_', month_file{m_select},'.mat'],'Amp_v','Pha_v');
    load([Velocityloc,'/M2_Modal_Horizontal_Zonal_', month_file{m_select},'.mat'],'Amp_u','Pha_u');
    Cmn = zeros(ie,je,imodes,imodes);
    %% Topographic couplig coefficients 
    load([TCEloc,'/M2_TGC_', month_file{m_select}, '.mat'],'T_x','T_y');
    for m=1:imodes-1
        for n=m+1:imodes
            Cmn(:,:,m,n) = depto_grid(:,:).* ...
                           (T_x(:,:,n,m).*Amp_p(:,:,n).*Amp_u(:,:,m).*cosd(Pha_p(:,:,n)-Pha_u(:,:,m)) + T_y(:,:,n,m).*Amp_p(:,:,n).*Amp_v(:,:,m).*cosd(Pha_p(:,:,n)-Pha_v(:,:,m)) - ...
                            T_x(:,:,m,n).*Amp_p(:,:,m).*Amp_u(:,:,n).*cosd(Pha_p(:,:,m)-Pha_u(:,:,n)) + T_y(:,:,m,n).*Amp_p(:,:,m).*Amp_v(:,:,n).*cosd(Pha_p(:,:,m)-Pha_v(:,:,n)));
            Cmn(:,:,n,m) = -Cmn(:,:,m,n);
        end
    end
    save(['./InterMode_Gene/M2_Cmn_', month_file{m_select}, '.mat'], ...
     'Cmn','-v7.3');
end
