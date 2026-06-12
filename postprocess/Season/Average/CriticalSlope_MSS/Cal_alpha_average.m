clear;clc;close all;
%%
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
addpath ../../../Grid/
load('Grid_info.mat','ke','lonp_grid','latp_grid','depto_grid','weto_p','zzout','bottom_index','ddpo_grid');
load('Grid_resolution.mat', 'dlxu')
load('Grid_resolution.mat', 'dlyv')
iw = 10;ie = 1;
jn = 10;js = 10;
lonp_grid= Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid= Exclude_sponge(iw,ie,jn,js,latp_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
bottom_index= Exclude_sponge(iw,ie,jn,js,bottom_index);
zzout= Exclude_sponge(iw,ie,jn,js,zzout);
dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
load('CoastalDakar_index.mat')
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);
ddpo_grid= ddpo_grid(select_indicex,select_indicey,:);
zzout = zzout(select_indicex,select_indicey,:);
dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% Topography gradients
f_coe1 = sw_f(latp_grid); %[rad/s-1]
f_coe =f_coe1;
% M2
sigma = 2*pi/(12.4206012*3600);  %[rad/s-1]
[DHdy,DHdx] = gradient(depto_grid);
DHdy= -DHdy./dlyv;
DHdx= DHdx./dlxu;

DHdl = DHdy.*DHdy + DHdx.*DHdx;
DHdl = sqrt(DHdl);
%%
N2_bottom = zeros(ie,je);
ang = zeros(ie,je);
slope = zeros(ie,je);
%%
for m_select=1:12 % 2014
    load(['../ave_Nsquare_', month_file{m_select}, '_from_ts_MSS.mat']);
     Nsquare_year(:,:,:,m_select)= Nsquare_month;
end
for m_select=12+1:24 % 2015
    load(['../../../../../../2015/Withtide/post_process/Season/Average/ave_Nsquare_', month_file{m_select-12}, '_from_ts_MSS.mat']);
     Nsquare_year(:,:,:,m_select)= Nsquare_month;
end
for m_select=24+1:36 % 2016
    load(['../../../../../../2015/Withtide/post_process/Season/Average/ave_Nsquare_', month_file{m_select-24}, '_from_ts_MSS.mat']);
     Nsquare_year(:,:,:,m_select)= Nsquare_month;
end
Nsquare_year_mean =nanmean(Nsquare_year,4);
N2_bottom = zeros(ie,je);
ang = zeros(ie,je);
slope = zeros(ie,je);
for i = 1:ie
    for j =1:je
        if (weto_p(i,j,1) == 1)
            % g = sw_g(latp_grid(i,j),ZZZ(i,j,bottom_index(i,j)));

            % N2_bottom(i,j) = - g/RRR(i,j,bottom_index(i,j)) * ...
            %     (RRR(i,j,bottom_index(i,j)-1) - RRR(i,j,bottom_index(i,j))) / ...
            %     (ZZZ(i,j,bottom_index(i,j)) - ZZZ(i,j,bottom_index(i,j)-1));

             b_index = find(zzout(i,j,1:bottom_index(i,j)) <= depto_grid(i,j));
             N2_bottom(i,j) = Nsquare_year_mean(i,j,b_index(end));  %[rad/s]^2

             % 
             % N2_average = sum(Nsquare_month(i,j,1:bottom_index(i,j)).*ddpo_grid(i,j,1:bottom_index(i,j)),3)./depto_grid(i,j);
             % N2_bottom(i,j) = N2_average;

             
             ang(i,j)  = sqrt( (sigma.^2 - f_coe(i,j).^2) / (N2_bottom(i,j)- sigma.^2) );

            % ang(i,j) = sqrt((sigma^2 - f_coe(i,j)^2)/(N2_max- sigma^2));
            if  real(ang(i,j)) ~=0
                slope(i,j) = abs(DHdl(i,j))./real(ang(i,j));
            else
                slope(i,j) = nan;
            end
        else
            slope(i,j) = nan;
        end
    end
end

save(['MSS_GD_average_3year.mat'], ...
         'slope','N2_bottom','-v7.3');
