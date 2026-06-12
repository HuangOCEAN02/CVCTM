clear;clc;close all
addpath ../Grid/
%% Averaged window from m_start to m_end [months]
%% Roo （Three-dimensional fields）
m_start = 5;
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
roo_sum = zeros(ie,je,ke);
roo = zeros(ie,je,ke);
% roo_seaon  = zeros(ie,je,ke,m_end-m_start+1);
count = 0;

for m_select = m_start:m_end
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])
     roo_month = zeros(ie,je,ke);
      for t= 1:1:tee  % Time
          
        tag = sprintf('%08d', LDTRUN_range(t));
        name_r = [Location,'roo/ROO_',tag,'.nc'];
        
        roo(:,:,:) = zeros(ie,je,ke);
        roo(:,:,:) = ncread(name_r,'ROO',...
                     [iw+1 jn+1 1],[ie,je,ke]);
        roo_month = roo_month + roo;
        % roo_sum = roo_sum + roo;
        count = count + 1;
        disp(['  Day = ',datestr(time_index_range(t,:))]);
      end % time
      roo_month = weto_p.*roo_month./tee;
      save([SaveLocation,'/ave_roo_', month_file{m_select}, '_CVCTM.mat'], ...
     'roo_month','-v7.3');
end % month
% 
% disp([' The average windows = ',num2str(count)])
% roo_mean = weto_p.*roo_sum./count;

% save([SaveLocation,'/ave_roo_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'roo_mean','-v7.3');
% save([SaveLocation,'/ave_roo_monthly_CVCTM.mat'], ...
%      'roo_seaon','-v7.3');
