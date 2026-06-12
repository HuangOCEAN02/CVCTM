clear;clc;close all
addpath ../Grid/
%% Extract the velocity based on the index
%% From m_start to m_end
m_start = 5;m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Transect/18N'];
%% 18°N Transect
addpath ../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
% lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
% latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
% bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);
% ddpo_grid =  Exclude_sponge(iw,ie,jn,js,ddpo_grid);
ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);
%% Two column for 18N
j_index_global = 84; % global
j_index_exclude = 74; % exlude sponge grids
je = 2;
%%
for m_select = m_start:m_end
    disp(['loading time....']);
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])
    % disp(['loading BT velocity....']);
    % load(['./Velocity/res_uso_',month_file{m_select},'_CVCTM.mat'],'ua_bt','ug_bt');
    % load(['./Velocity/res_vso_',month_file{m_select},'_CVCTM.mat'],'va_bt','vg_bt');
    % 
    % ua_bt = reshape(ua_bt,[ie_global+1,je_global]);
    % ug_bt = reshape(ug_bt,[ie_global+1,je_global]);
    % va_bt = reshape(va_bt,[ie_global,je_global+1]);
    % vg_bt = reshape(vg_bt,[ie_global,je_global+1]);
    % 
    % UA = ua_bt(:,j_index_exclude);UG = ug_bt(:,j_index_exclude);
    % VA = va_bt(:,j_index_exclude-1:j_index_exclude);
    % VG = vg_bt(:,j_index_exclude-1:j_index_exclude);
    % clear ua_bt ug_bt va_bt vg_bt

    uko_time = zeros(ie_global+1,ke,tee);
    vke_time = zeros(ie_global,2,ke,tee);
    tho_time = zeros(ie_global,ke,tee);
    sao_time = zeros(ie_global,ke,tee);
    roo_time = zeros(ie_global,ke,tee);
    zoo_time = zeros(ie_global,tee);
    for t= 1:1:tee  % Time
        tag = sprintf('%08d', LDTRUN_range(t));

        name_u = [Location,'uoo/UOO_',tag,'.nc'];
        name_v = [Location,'voe/VOE_',tag,'.nc'];
        name_t = [Location,'tho/THO_',tag,'.nc'];
        name_s = [Location,'sao/SAO_',tag,'.nc'];
        name_r = [Location,'roo/ROO_',tag,'.nc'];
        name_z = [Location,'zoo/ZOO_',tag,'.nc'];
        % using the index
        tho = ncread(name_t,'THO',...
                     [iw+1 j_index_global 1],[ie_global,1,ke]);
        sao = ncread(name_s,'SAO',...
                     [iw+1 j_index_global 1],[ie_global,1,ke]);
        roo = ncread(name_r,'ROO',...
                     [iw+1 j_index_global 1],[ie_global,1,ke]);

        uko = ncread(name_u,'UOO',...
                     [iw+1 j_index_global 1],[ie_global+1,1,ke]);   
        vke = ncread(name_v,'VOE',...
                     [iw+1 j_index_global-1 1],[ie_global,2,ke]);
        zoo = ncread(name_z,'ZOO',...
                           [iw+1 j_index_global],[ie_global,1]); 

        sao = squeeze(sao);
        tho = squeeze(tho);
        uko = squeeze(uko);
        vke = squeeze(vke);
        zoo = squeeze(zoo);


        uko_time(:,:,t) = uko;
        vke_time(:,:,:,t) = vke;
        tho_time(:,:,t) = tho;
        sao_time(:,:,t) = sao;
        zoo_time(:,t) = zoo;
    end

    % tho_mean = nanmean(tho_time,3);
    % sao_mean = nanmean(sao_time,3);
    % uko_mean = nanmean(uko_time,3);
    % vke_mean = nanmean(vke_time,4);

    % save([SaveLocation,'/ave_18N_', month_file{m_select}, '_CVCTM.mat'], ...
    %  'uko_mean','vke_mean','tho_mean','sao_mean','-v7.3');
    save([SaveLocation,'/Transect18_velocity_', month_file{m_select}, '_CVCTM.mat'], ...
     'zoo_time','uko_time','vke_time','-v7.3');
    save([SaveLocation,'/Transect18_tracer_', month_file{m_select}, '_CVCTM.mat'], ...
     'tho_time','sao_time','roo_time','-v7.3');
end
