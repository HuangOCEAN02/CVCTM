clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
for m_select = 1: 12
% m_select = 4;
SaveLocation = ['./',month_file{m_select}];
load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
load([SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
%%
addpath ../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
%%
R = C - Div_F;
R(isnan(depto_grid)==1)=nan;  % w/m
save([SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'], ...
     'R','-v7.3');
end
%%