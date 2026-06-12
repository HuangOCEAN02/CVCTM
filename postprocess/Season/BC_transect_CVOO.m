clear;clc;close all
%% Extract the velocity based on the index
%% From m_start to m_end
m_start = 1;m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./Transect/CVOO'];
%% CVOO transect
addpath ../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('CVOO_transect.mat')

Lon_area = lonp_grid(lon_index,lat_index);
Lat_area = latp_grid(lon_index,lat_index);
depth_area = depto_grid(lon_index,lat_index);
weto_area = weto_p(lon_index,lat_index,:);



le = length(lon_line);
i_s = lon_index(1);
j_s = lat_index(1);
ie = size(lon_index,2);
je = size(lat_index,2);
land = zeros(ie,je,ke);
land(weto_area==0)=1;
%%
for m_select = m_start:m_end
    disp(['loading time....']);
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])

    uko_time = zeros(le,ke,tee);
    vke_time = zeros(le,ke,tee);
    tho_time = zeros(le,ke,tee);
    sao_time = zeros(le,ke,tee);
    roo_time = zeros(le,ke,tee);
    zoo_time = zeros(le,tee);
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
                     [i_s j_s 1],[ie,je,ke]);
        sao = ncread(name_s,'SAO',...
                     [i_s j_s 1],[ie,je,ke]);
        roo = ncread(name_r,'ROO',...
                     [i_s j_s 1],[ie,je,ke]);

        uko = ncread(name_u,'UOO',...
                     [i_s j_s 1],[ie+1,je,ke]);   
        vke = ncread(name_v,'VOE',...
                     [i_s j_s 1],[ie,je+1,ke]);
        zoo = ncread(name_z,'ZOO',...
                     [i_s j_s],[ie,je]); 

        sao = squeeze(sao);
        tho = squeeze(tho);
        uko = squeeze(uko);
        vke = squeeze(vke);
        zoo = squeeze(zoo);

        zoo_time(:,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
            lat_line,lon_line,zoo,land(:,:,1));  

        for k =1:ke
            uop(:,:) = orctm_interp2p(uko(:,:,k),ie,je,'u');
            vep(:,:) = orctm_interp2p(vke(:,:,k),ie,je,'v');
    
            uko_time(:,k,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
                lat_line,lon_line,uop(:,:),land(:,:,k));
            vke_time(:,k,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
                lat_line,lon_line,vep(:,:),land(:,:,k));
            tho_time(:,k,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
                lat_line,lon_line,tho(:,:,k),land(:,:,k));
            sao_time(:,k,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
                lat_line,lon_line,sao(:,:,k),land(:,:,k));
            roo_time(:,k,t) = BLN2HOP_new(ie,je,le,1,Lat_area,Lon_area,...
                lat_line,lon_line,roo(:,:,k),land(:,:,k));
        end

    end
    
    save([SaveLocation,'/CVOO_transect_tho_', month_file{m_select}, '_CVCTM.mat'], ...
     'tho_time','-v7.3');
    save([SaveLocation,'/CVOO_transect_sao_', month_file{m_select}, '_CVCTM.mat'], ...
     'sao_time','-v7.3');
    save([SaveLocation,'/CVOO_transect_roo_', month_file{m_select}, '_CVCTM.mat'], ...
     'roo_time','-v7.3');
    save([SaveLocation,'/CVOO_transect_uko_', month_file{m_select}, '_CVCTM.mat'], ...
     'uko_time','-v7.3');
    save([SaveLocation,'/CVOO_transect_vke_', month_file{m_select}, '_CVCTM.mat'], ...
     'vke_time','-v7.3');   
    save([SaveLocation,'/CVOO_transect_zoo_', month_file{m_select}, '_CVCTM.mat'], ...
     'zoo_time','-v7.3'); 
end
