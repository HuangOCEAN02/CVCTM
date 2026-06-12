clear;clc;close all
addpath ../Grid/
%% Averaged window from m_start to m_end [months]
%% above 500 m currents monthly mean （Two-dimensional fields）
m_start = 1;
m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Average/UVGEO'];
%%
load('Grid_info.mat','ke','depto_grid','weto_p');
load('Grid_info_u.mat','dduo_grid');
load('Grid_info_v.mat','ddue_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
dduo_grid = Exclude_sponge(iw,ie,jn,js,dduo_grid);
ddue_grid = Exclude_sponge(iw,ie,jn,js,ddue_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);

dduo_grid_ssh = dduo_grid;
ddue_grid_ssh = ddue_grid;
%%
ke_level = 30; % approximately 500m
ssh_considered = 1;

UOO = zeros(ie+1,je,ke_level);
VOE = zeros(ie,je+1,ke_level);

Ugeo = zeros(ie+1,je);
Vgeo = zeros(ie,je+1);

Ugo_sum = zeros(ie+1,je);
Vgo_sum = zeros(ie,je+1);

ugo_season  = zeros(ie+1,je,m_end-m_start+1);
vgo_season  = zeros(ie,je+1,m_end-m_start+1);

if ssh_considered 
    SSH = zeros(ie,je);
    SSH_sum = zeros(ie,je);
    ssh_season  = zeros(ie,je,m_end-m_start+1);
end
count = 0;

for m_select = m_start:m_end
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])

    Ugo_month = zeros(ie+1,je,tee);
    Vgo_month = zeros(ie,je+1,tee);
    SSH_month = zeros(ie,je,tee);
    for t= 1:1:tee  % Time
          
        tag = sprintf('%08d', LDTRUN_range(t));
        name_u = [Location,'uoo/UOO_',tag,'.nc'];
        name_v = [Location,'voe/VOE_',tag,'.nc'];
        
        UOO(:,:,1:ke_level) = ncread(name_u,'UOO',...
                   [iw+1, jn+1,1],[ie+1,je,ke_level]);  

        VOE(:,:,1:ke_level) = ncread(name_v,'VOE',...
                   [iw+1, jn+1, 1],[ie,je+1,ke_level]);  

      if ssh_considered 
            clear ZOO
            dduo_grid_ssh = dduo_grid;
            ddue_grid_ssh = ddue_grid;
            name_z =  [Location,'zoo/ZOO_',tag,'.nc'];
            ZOO(:,:) = ncread(name_z,'ZOO',...
                           [iw+1,jn+1],[ie,je]); 
            dduo_grid_ssh(2:ie+1,:,1) = dduo_grid(2:ie+1,:,1) +  ZOO(:,:);
            ddue_grid_ssh(:,2:je+1,1) = ddue_grid(:,2:je+1,1) +  ZOO(:,:);
            SSH(:,:) = ZOO(:,:);
            % SSH_sum = SSH + SSH_sum;
            SSH_month(:,:,t) = SSH;
      end
        
        Ugeo = sum(UOO(:,:,:).*dduo_grid_ssh(:,:,1:ke_level),3)./sum(dduo_grid_ssh(:,:,1:ke_level),3);
        Vgeo = sum(VOE(:,:,:).*ddue_grid_ssh(:,:,1:ke_level),3)./sum(ddue_grid_ssh(:,:,1:ke_level),3);   
        % year
        % Ugo_sum = Ugeo + Ugo_sum;
        % Vgo_sum = Vgeo + Vgo_sum;
        % month
        Ugo_month(:,:,t) = Ugeo;
        Vgo_month(:,:,t) = Vgeo;

        count = count + 1;
        disp(['  Day = ',datestr(time_index_range(t,:))]);
    end 
     save([SaveLocation,'/ave_ugo_', month_file{m_select}, '_CVCTM.mat'], ...
     'Ugo_month','-v7.3');
     save([SaveLocation,'/ave_vgo_', month_file{m_select}, '_CVCTM.mat'], ...
     'Vgo_month','-v7.3');
     save([SaveLocation,'/ave_ssh_', month_file{m_select}, '_CVCTM.mat'], ...
     'SSH_month','-v7.3');

     Ugo_month_mean(:,:) = mean(Ugo_month,3);
     Vgo_month_mean(:,:) = mean(Vgo_month,3);
     SSH_month_mean(:,:) = mean(SSH_month,3);
     save([SaveLocation,'/ave_ugo_', month_file{m_select}, 'mean_CVCTM.mat'], ...
     'Ugo_month_mean','-v7.3');
     save([SaveLocation,'/ave_vgo_', month_file{m_select}, 'mean_CVCTM.mat'], ...
     'Vgo_month_mean','-v7.3');
     save([SaveLocation,'/ave_ssh_', month_file{m_select}, 'mean_CVCTM.mat'], ...
     'SSH_month_mean','-v7.3');
end % month
% disp([' The average windows = ',num2str(count)])
% ugo_mean = weto_p(:,:,1).*Ugo_sum./count;
% vgo_mean = weto_p(:,:,1).*Vgo_sum./count;
% ssh_mean = weto_p(:,:,1).*SSH_sum./count;
% 
% save([SaveLocation,'/ave_ugo_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'ugo_mean','-v7.3');
% save([SaveLocation,'/ave_vgo_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'vgo_mean','-v7.3');
% save([SaveLocation,'/ave_ssh_', num2str(m_start),'_to_',num2str(m_end), '_CVCTM.mat'], ...
%      'ssh_mean','-v7.3');
% save([SaveLocation,'/ave_ugo_monthly_CVCTM.mat'], ...
%      'ugo_season','-v7.3');
% save([SaveLocation,'/ave_vgo_monthly_CVCTM.mat'], ...
%      'vgo_season','-v7.3');
% save([SaveLocation,'/ave_ssh_monthly_CVCTM.mat'], ...
%      'ssh_season','-v7.3');
