clear;clc;close all
addpath ../Grid/
%% Averaged window from m_start to m_end [months]
%% Temperature & Salinity （Three-dimensional fields）
m_start = 12;
m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Average'];
%%
load('Grid_info.mat','ke','depto_grid','weto_p');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
% tho_sum = zeros(ie,je,ke);
tho = zeros(ie,je,ke);
% tho_season  = zeros(ie,je,ke,m_end-m_start+1);
% sao_sum = zeros(ie,je,ke);
sao = zeros(ie,je,ke);
% sao_season  = zeros(ie,je,ke,m_end-m_start+1);
count = 0;

for m_select = m_start:m_end
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])
     tho_month = zeros(ie,je,ke);
     sao_month = zeros(ie,je,ke);
      for t= 1:1:tee  % Time
          
        tag = sprintf('%08d', LDTRUN_range(t));
        name_t = [Location,'tho/THO_',tag,'.nc'];
        name_s = [Location,'sao/SAO_',tag,'.nc'];

        tho(:,:,:) = zeros(ie,je,ke);
        sao(:,:,:) = zeros(ie,je,ke);

        tho(:,:,:) = ncread(name_t,'THO',...
                     [iw+1 jn+1 1],[ie,je,ke]);
        sao(:,:,:) = ncread(name_s,'SAO',...
                     [iw+1 jn+1 1],[ie,je,ke]);

        tho_month = tho_month + tho;
        % tho_sum = tho_sum + tho;

        sao_month = sao_month + sao;
        % sao_sum = sao_sum + sao;

        count = count + 1;
        disp(['  Day = ',datestr(time_index_range(t,:))]);
      end % time
     tho_month = weto_p.*tho_month./tee;
     sao_month = weto_p.*sao_month./tee; 
     save([SaveLocation,'/ave_tho_', month_file{m_select}, '_CVCTM.mat'], ...
     'tho_month','-v7.3');
     save([SaveLocation,'/ave_sao_', month_file{m_select}, '_CVCTM.mat'], ...
     'sao_month','-v7.3');
end % month
% disp([' The average windows = ',num2str(count)])
% tho_mean = weto_p.*tho_sum./count;
% sao_mean = weto_p.*sao_sum./count;
% 
% save([SaveLocation,'/ave_tho_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'tho_mean','-v7.3');
% save([SaveLocation,'/ave_sao_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'sao_mean','-v7.3');
% save([SaveLocation,'/ave_tho_monthly_CVCTM.mat'], ...
%      'tho_season','-v7.3');
% save([SaveLocation,'/ave_sao_monthly_CVCTM.mat'], ...
%      'sao_season','-v7.3');
