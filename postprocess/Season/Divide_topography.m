clear;clc;close all
addpath ../Grid/
SaveLocation = ['../Grid'];
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% CVA
load('CapeVerde_index.mat')
depto_CV = depto_grid(select_indicex,select_indicey);
depto_CV = reshape(depto_CV,[ie_CVA*je_CVA,1]);
[depto_CV_x,inx] = sort(depto_CV,'ascend');
save([SaveLocation,'/CapeVerde_index.mat'], ...
     'depto_CV_x','inx','-append');
%% NDS
load('NorthDakar_index.mat')
depto_NDS = depto_grid(select_indicex,select_indicey);
depto_NDS = reshape(depto_NDS,[ie_NDS*je_NDS,1]);
[depto_NDS_x,inx] = sort(depto_NDS,'ascend');
save([SaveLocation,'/NorthDakar_index.mat'], ...
     'depto_NDS_x','inx','-append');
%% SDS
load('SouthDakar_index.mat')
depto_SDS = depto_grid(select_indicex,select_indicey);
depto_SDS = reshape(depto_SDS,[ie_SDS*je_SDS,1]);
[depto_SDS_x,inx] = sort(depto_SDS,'ascend');
save([SaveLocation,'/SouthDakar_index.mat'], ...
     'depto_SDS_x','inx','-append');
%% MSS
load('CoastalDakar_index.mat')
depto_MSS = depto_grid(select_indicex,select_indicey);
depto_MSS = reshape(depto_MSS,[ie_MSS*je_MSS,1]);
[depto_MSS_x,inx] = sort(depto_MSS,'ascend');
save([SaveLocation,'/CoastalDakar_index.mat'], ...
     'depto_MSS_x','inx','-append');

