clear;clc;close all
addpath ../Grid/
load('Grid_info.mat','ke');
%% Extract the model output at the cvoo mooring grid
% CVOO 17°36.40 N 24°14.98  W 
% 17.6067 
% -24.2497
%% From m_start to m_end
m_start = 12;m_end  = 12;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
SaveLocation =['./CVOO'];
i_cvoo = 166; j_cvoo = 110; % from global matrix
%% The matrix of size each month:(80,744)
for m_select = m_start:m_end
    disp(['loading time....']);
    load(['Time_info_',month_file{m_select},'.mat'])
    % Location = ['../../',group_per_month{m_select},'/post_process/'];
    Location = ['../../',group_per_month{m_select},'/'];
    disp(['Month = ',month_file{m_select},' in ',group_per_month{m_select}])

    uko_time = zeros(ke,tee);
    vke_time = zeros(ke,tee);
    tho_time = zeros(ke,tee);
    sao_time = zeros(ke,tee);
    roo_time = zeros(ke,tee);
    zoo_time = zeros(1,tee);
    for t= 1:1:tee  % Time
        tag = sprintf('%08d', LDTRUN_range(t));
        name_u = [Location,'uoo/UOO_',tag,'.nc'];
        name_v = [Location,'voe/VOE_',tag,'.nc'];
        name_t = [Location,'tho/THO_',tag,'.nc'];
        name_s = [Location,'sao/SAO_',tag,'.nc'];
        name_r = [Location,'roo/ROO_',tag,'.nc'];
        name_z = [Location,'zoo/ZOO_',tag,'.nc'];

        tho = ncread(name_t,'THO',...
                     [i_cvoo j_cvoo 1],[1,1,ke]);
        sao = ncread(name_s,'SAO',...
                     [i_cvoo j_cvoo 1],[1,1,ke]);
        roo = ncread(name_r,'ROO',...
                     [i_cvoo j_cvoo 1],[1,1,ke]);

        uko = ncread(name_u,'UOO',...
                     [i_cvoo j_cvoo 1],[1,1,ke]);   
        vke = ncread(name_v,'VOE',...
                     [i_cvoo j_cvoo 1],[1,1,ke]);
        zoo = ncread(name_z,'ZOO',...
                           [i_cvoo j_cvoo],[1,1]); 

        sao = squeeze(sao);
        tho = squeeze(tho);
        uko = squeeze(uko);
        vke = squeeze(vke);
        zoo = squeeze(zoo);
        % using the MSS index
        uko_time(:,t) = uko;
        vke_time(:,t) = vke;
        tho_time(:,t) = tho;
        sao_time(:,t) = sao;
        roo_time(:,t) = roo;
        zoo_time(t) = zoo;
    end
    save([SaveLocation,'/CVOO_velocity_', month_file{m_select}, '_CVCTM.mat'], ...
     'zoo_time','uko_time','vke_time','-v7.3');
    save([SaveLocation,'/CVOO_tracer_', month_file{m_select}, '_CVCTM.mat'], ...
     'tho_time','sao_time','roo_time','-v7.3');
end
