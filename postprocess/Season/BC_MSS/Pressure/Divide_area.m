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
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
LONLIMS = [min(min(lonp_grid)) max(max(lonp_grid))];
LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
%% NDA
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=14.7 & latp_grid(1,:)<=18.4);
% select_indicey = find(latp_grid(1,:)>=15 & latp_grid(1,:)<=18.2);
save NorthDakar_index.mat select_indicex select_indicey
%% SDA
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-18.5 & lonp_grid(:,1)<=-16);
% select_indicey = find(latp_grid(1,:)>=13 & latp_grid(1,:)<=14.7);
select_indicey = find(latp_grid(1,:)>=13 & latp_grid(1,:)<=14.7);
save SouthDakar_index.mat select_indicex select_indicey

%% Western deep area (WDA) for NDA
clear select_indicey select_indicex
select_indicex = find(lonp_grid(:,1)>=-19.5 & lonp_grid(:,1)<=-18.5);
% select_indicey = find(latp_grid(1,:)>=13 & latp_grid(1,:)<=14.7);
select_indicey = find(latp_grid(1,:)>=17 & latp_grid(1,:)<=18.0);

save WestDeepSea_index.mat select_indicex select_indicey