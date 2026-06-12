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
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

load('CoastalDakar_index.mat')
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
Pressloc = ['./Pressure'];
% Modeloc=['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function'];
if ~exist('Wavenumber','dir'); mkdir Wavenumber; end
%addpath /Users/josephhuang/Desktop/workingplace/斜压模拟/内潮基本要素/IT_functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
imodes = 10;
for m_select = 1:1:12
    disp([num2str(m_select),'  Month']);
    load([Pressloc,'/M2_Modal_Pressure_',month_file{m_select},'.mat'],'Amp_p','Pha_p');

    Pha_p = deg2rad(Pha_p);
    Pha_px = zeros(size(Pha_p));
    Pha_py = zeros(size(Pha_p));
    for m = 1:imodes
        % Phase gradient
        [Pha_px(:,:,m), Pha_py(:,:,m)] = phase_gradient_unitcomplex(Pha_p(:,:,m),dlxu,dlyv);
    end
    kh = sqrt(Pha_px.^2 + Pha_py.^2);

    save(['./Wavenumber/HorizontalWavenumber_', month_file{m_select}, '.mat'], ...
         'Pha_px','Pha_py','kh','-v7.3');
end
