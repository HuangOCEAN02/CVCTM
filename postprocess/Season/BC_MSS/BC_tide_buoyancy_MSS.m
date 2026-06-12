clear;clc;close all
%% T-tide using least square method for buoyancy
tic
ttide = 1;     % whether use the t_tide.
para  = 1;     % whether use the parallel.
maxNumCompThreads = 32;
if para == 1
   parpool ('local',maxNumCompThreads)
end
%% Please selct the month[m_select]
addpath ../../Grid/
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
for m_select = 7:12
load(['Time_info_',month_file{m_select},'.mat'])
%Location = ['../../',group_per_month{m_select},'/post_process/'];
Location = ['../../../',group_per_month{m_select},'/'];
SaveLocation =['./Buoyancy'];
if ttide == 1
   addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
   start_time = time_index_range(1,:)
   t_freq = 0.0805;
   t_name = ['M2  '];
end
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid','weto_p','latp_grid','lonp_grid');
% load('../Average/ave_roo_monthly_CVCTM.mat'); % roo_seaon(ie,je,ke,12)
load(['../Average/ave_roo_',month_file{m_select},'_CVCTM.mat']);
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
    weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
 latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
 lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);

ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);
%% MSS area
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
latp_grid    = latp_grid(select_indicex,select_indicey);
lonp_grid    = lonp_grid(select_indicex,select_indicey);
roo_mean = roo_month(select_indicex,select_indicey,:);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
ba_bc =  zeros(ie*je,ke);
bg_bc =  zeros(ie*je,ke);

ba_level = zeros(ie*je,1);
bg_level = zeros(ie*je,1);

latpo = reshape(latp_grid,[ie*je,1]);
lonpo = reshape(lonp_grid,[ie*je,1]);
%%

for k = 1 : ke  % Vertical Level
  b_bc_time = zeros(ie,je,tee);
  roo = zeros(ie_global,je_global);
  roo_slect = zeros(ie,je);
  for t= 1:tee  % Time
    tag = sprintf('%08d', LDTRUN_range(t));
    name_r = [Location,'roo/ROO_',tag,'.nc'];
    roo(:,:) = ncread(name_r,'ROO',...
                 [iw+1 jn+1 k],[ie_global,je_global,1]);

     roo_slect = roo(select_indicex,select_indicey);
     % mask
     b_bc_time(:,:,t) = 9.81.*( roo_slect(:,:) - roo_mean(:,:,k))./roo_mean(:,:,k).*weto_p(:,:,k);
  end % Time

  disp(['!!!!!! STRAT --> Vertical Level k = ',num2str(k)])
  b_bc_level  = reshape(b_bc_time,[ie*je,tee]);
        mask   = reshape(weto_p(:,:,k),[ie*je,1]);
  if ttide == 1
     resb=zeros([4 1]);
     parfor i = 1:(ie*je)
       sb = b_bc_level(i,:);
       if (mask(i)~=0)  % masko(ij) == 0
%%  Density(buoyancy)
         [~,~,resb]=t_tide(sb,'start time',start_time,'latitude',latpo(i),...
             'output','none','rayleigh', ['M2'], 'error','wboot');
         ba_level(i,:)=resb(1,1); %the first line is amplitude
         bg_level(i,:)=resb(1,3); %the third line is lag angle
         disp(['the current processing Num of Buoyancy: ',num2str(i)]); 
       end
     end
  end
  ba_bc(:,k)=ba_level; %the first line is amplitude
  bg_bc(:,k)=bg_level; %the third line is lag angle  
  disp(['!!!!!! END --> Vertical Level k = ',num2str(k)])
end  % Vertical Level
if ttide == 1
    save([SaveLocation,'/res_bbc_', month_file{m_select}, '_CVCTM.mat'], ...
         'ba_bc','bg_bc','latpo','lonpo','t_name','-v7.3');
end
end
t1 = toc;
if ttide == 1
    disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);
end
if para == 1
    delete(gcp('nocreate'))
end
clearvars -except  b_bc_level latpo lonpo
