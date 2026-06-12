clear;clc;close all
addpath ../Grid/
%% Averaged window from m_start to m_end [months]
%% Temperature & Salinity （Three-dimensional fields）
m_start = 1;
m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Average/Coast'];
%%
load('Grid_info.mat','ke','depto_grid','weto_p');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
load('CoastalDakar_index.mat','select_indicex','select_indicey')
MSS_select_indicex = select_indicex;
MSS_select_indicey = select_indicey;

mask(:,:) = weto_p(MSS_select_indicex,MSS_select_indicey,1);

load('MSS_coast_index.mat', 'coast_x','coast_y','lat_coast');
le = length(coast_x);
%%
for m_select = m_start:m_end
    load(['Time_info_',month_file{m_select},'.mat']);
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])
     SST_month = zeros(le,tee);
     SSS_month = zeros(le,tee);
     SSH_month = zeros(le,tee);
      for t= 1:1:tee  % Time
          
        tag = sprintf('%08d', LDTRUN_range(t));
        name_t = [Location,'tho/THO_',tag,'.nc']; % SST
        name_s = [Location,'sao/SAO_',tag,'.nc']; % SSS
        name_z = [Location,'zoo/ZOO_',tag,'.nc']; % SSH

        tho(:,:) = zeros(ie,je);
        sao(:,:) = zeros(ie,je);
        zoo(:,:) = zeros(ie,je);

        tho(:,:) = ncread(name_t,'THO',...
                     [iw+1 jn+1 1],[ie,je,1]);
        sao(:,:) = ncread(name_s,'SAO',...
                     [iw+1 jn+1 1],[ie,je,1]);
        zoo(:,:) = ncread(name_z,'ZOO',...
                            [iw+1 jn+1],[ie,je]);  

        tho_mss = tho(MSS_select_indicex,MSS_select_indicey);
        sao_mss = sao(MSS_select_indicex,MSS_select_indicey);
        zoo_mss = zoo(MSS_select_indicex,MSS_select_indicey);

        tho_mss(mask==0)=nan;
        sao_mss(mask==0)=nan;
        zoo_mss(mask==0)=nan;
        for pp=1:le
            if lat_coast(pp) <=14.75 % SDS
                SST_month(pp,t) = nanmean(tho_mss([coast_x(pp)-51:coast_x(pp)-1],pp));
                SSS_month(pp,t) = nanmean(sao_mss([coast_x(pp)-51:coast_x(pp)-1],pp));
                SSH_month(pp,t) = nanmean(zoo_mss([coast_x(pp)-51:coast_x(pp)-1],pp));
            else % NDS
                SST_month(pp,t) = nanmean(tho_mss([coast_x(pp)-31:coast_x(pp)-1],pp));
                SSS_month(pp,t) = nanmean(sao_mss([coast_x(pp)-31:coast_x(pp)-1],pp));
                SSH_month(pp,t) = nanmean(zoo_mss([coast_x(pp)-31:coast_x(pp)-1],pp));
            end
        end
        disp(['  Day = ',datestr(time_index_range(t,:))]);
      end % time
     save([SaveLocation,'/Coast_sst_', month_file{m_select}, '_CVCTM.mat'], ...
     'SST_month','-v7.3');
     save([SaveLocation,'/Coast_sss_', month_file{m_select}, '_CVCTM.mat'], ...
     'SSS_month','-v7.3');
     save([SaveLocation,'/Coast_ssh_', month_file{m_select}, '_CVCTM.mat'], ...
     'SSH_month','-v7.3');    
end % month
