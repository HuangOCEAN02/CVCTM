clear;clc;close all
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
load('CapeVerde_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
%% cvs
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-21.75);
select_indicey = find(latp_grid(1,:)>=14.4 & latp_grid(1,:)<=17.5);
save CapeVerdeSea_index.mat select_indicex select_indicey
%% wwi
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-23.6);
select_indicey = find(latp_grid(1,:)>15.6 & latp_grid(1,:)<=17.5);
save WestBarlavento_index.mat select_indicex select_indicey
%% ewi
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>-23.6 & lonp_grid(:,1)<=-21.6);
select_indicey = find(latp_grid(1,:)>15.6 & latp_grid(1,:)<=17.5);
save EastBarlavento_index.mat select_indicex select_indicey

%% Li
clear select_indicex select_indicey
select_indicex = find(lonp_grid(:,1)>=-26 & lonp_grid(:,1)<=-21.6);
select_indicey = find(latp_grid(1,:)>=14.4 & latp_grid(1,:)<=15.6);
save Sotavento_index.mat select_indicex select_indicey

