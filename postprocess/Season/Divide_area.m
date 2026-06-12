clear;clc;close all
cd ../Grid/
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
select_indicex = find(lonp_grid(:,1)>=-26.5 & lonp_grid(:,1)<=-20.5);
select_indicey = find(latp_grid(1,:)>=14 & latp_grid(1,:)<=18);

ie_CVA = length(select_indicex);
je_CVA = length(select_indicey);
save CapeVerde_index.mat select_indicex select_indicey ie_CVA je_CVA

%% MSS
select_indicex = find(lonp_grid(:,1)>=-21 & lonp_grid(:,1)<=-16);
select_indicey = find(latp_grid(1,:)>=12 & latp_grid(1,:)<=18.4);

ie_MSS = length(select_indicex);
je_MSS = length(select_indicey);

save CoastalDakar_index.mat select_indicex select_indicey ie_MSS je_MSS

%% Western CVP

select_indicex = find(lonp_grid(:,1)>=-27 & lonp_grid(:,1)<-21);
select_indicey = find(latp_grid(1,:)>=12 & latp_grid(1,:)<=18.4);

ie_CVP = length(select_indicex);
je_CVP = length(select_indicey);

save CapeVerdeplateau_index.mat select_indicex select_indicey ie_CVP je_CVP