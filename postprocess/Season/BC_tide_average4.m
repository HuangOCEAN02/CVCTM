clear;clc;close all
addpath ../Grid/
%% Averaged window from m_start to m_end [months]
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Average/BackgroundCurrent'];
%%
load('Grid_info.mat','ke','depto_grid','weto_p');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
ke_level = 80; % approximately 500m

UOO = zeros(ie+1,je,ke_level);
VOE = zeros(ie,je+1,ke_level);

UOO_sum = zeros(ie+1,je,ke_level);
VOE_sum = zeros(ie,je+1,ke_level);

count = 0;
for m_select = 1:1:12
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])

    UOO_sum = zeros(ie+1,je,ke_level);
    VOE_sum = zeros(ie,je+1,ke_level);
    for t= 1:1:tee  % Time
          
        tag = sprintf('%08d', LDTRUN_range(t));
        name_u = [Location,'uoo/UOO_',tag,'.nc'];
        name_v = [Location,'voe/VOE_',tag,'.nc'];
        
        UOO(:,:,1:ke_level) = ncread(name_u,'UOO',...
                   [iw+1, jn+1,1],[ie+1,je,ke_level]);  

        VOE(:,:,1:ke_level) = ncread(name_v,'VOE',...
                   [iw+1, jn+1, 1],[ie,je+1,ke_level]);  

        
        UOO_sum = UOO_sum + UOO(:,:,:);
        VOE_sum = VOE_sum + VOE(:,:,:);

        count = count + 1;
        disp(['  Day = ',datestr(time_index_range(t,:))]);
    end 
    UOO_month = UOO_sum / count; % Calculate the average UOO
    VOE_month = VOE_sum / count; % Calculate the average VOE
    save([SaveLocation,'/ave_uoo_', month_file{m_select}, '_CVCTM.mat'], ...
     'UOO_month','-v7.3');
    save([SaveLocation,'/ave_voe_', month_file{m_select}, '_CVCTM.mat'], ...
     'VOE_month','-v7.3');
end % month
