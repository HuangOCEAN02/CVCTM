clear;clc;close all
%% THis is more accurate!!!!
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
%% Monthly mean of M2 within the CVA
addpath ../../Grid/
load('Grid_info.mat','ke','depto_grid','ddpo_grid','weto_p','zzout','bottom_index','latp_grid');
load('Grid_info_w.mat','zzout_w');
iw = 10;ie = 1;
jn = 10;js = 10;
latp_grid= Exclude_sponge(iw,ie,jn,js,latp_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
bottom_index= Exclude_sponge(iw,ie,jn,js,bottom_index);
zzout_w= Exclude_sponge(iw,ie,jn,js,zzout_w);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
% load('ave_tho_monthly_CVCTM.mat');
% load('ave_sao_monthly_CVCTM.mat');
%%
load('CapeVerdeplateau_index.mat')

latp_grid = latp_grid(select_indicex,select_indicey);
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
ddpo_grid = ddpo_grid(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);
zzout = zzout(select_indicex,select_indicey,:);
zzout_w = zzout_w(select_indicex,select_indicey,:);
% THO_MSS  = tho_season(select_indicex,select_indicey,:,:);
% SAO_MSS  = sao_season(select_indicex,select_indicey,:,:);
ie = size(depto_grid,1);
je = size(depto_grid,2);

Nsquare_month = zeros(ie,je,ke); % CVA
saveloc = '/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/Average/Average'
%%
for m_select = 1:12
        % loading 
    load(['ave_tho_', month_file{m_select}, '_CVCTM.mat']); % tho_month
    load(['ave_sao_', month_file{m_select}, '_CVCTM.mat']); % sao_month
    THO_MSS = tho_month(select_indicex,select_indicey,:);
    SAO_MSS = sao_month(select_indicex,select_indicey,:);
for i = 1:ie
    for j =1:je
        if weto_p(i,j,1)~=0
            clear T S Z T_w S_w P_w p_ave Z Z_w Z_new N2 N_result
 
           T(:) = [squeeze(THO_MSS(i,j,1));... 
               squeeze(THO_MSS(i,j,1:bottom_index(i,j)));...
               squeeze(THO_MSS(i,j,bottom_index(i,j)))];  
           S(:) = [squeeze(SAO_MSS(i,j,1));... 
               squeeze(SAO_MSS(i,j,1:bottom_index(i,j)));...
               squeeze(SAO_MSS(i,j,bottom_index(i,j))) ];           
           Z (:)= [0;squeeze(zzout(i,j,1:bottom_index(i,j)));depto_grid(i,j)];
           Z_w(:) = [squeeze(zzout_w(i,j,1:bottom_index(i,j)));depto_grid(i,j)];

           T_w(:) = interp1(Z,T,Z_w,'linear'); % length is bottom_index(i,j) + 1
           S_w(:) = interp1(Z,S,Z_w,'linear'); % length is bottom_index(i,j) + 1
     
           P_w(:) = sw_pres(Z_w,latp_grid(i,j));
           [N2,~,p_ave] = sw_bfrq(S_w,T_w,P_w,latp_grid(i,j));
           Z_new = sw_dpth(p_ave',latp_grid(i,j));
           N_result = interp1(Z_new, N2 ,squeeze(zzout(i,j,1:bottom_index(i,j))),'linear');
           [Nsquare_month(i,j,1:bottom_index(i,j))] = Check_Nsquare(N_result', squeeze(zzout(i,j,1:bottom_index(i,j))));
        end
    end
end
disp(['Month = ',month_file{m_select}])
save([saveloc,'/ave_Nsquare_', month_file{m_select}, '_from_ts_CVP.mat'], ...
         'Nsquare_month','-v7.3');
end