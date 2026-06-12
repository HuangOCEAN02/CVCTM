clear;clc;close all
tic
%% Monthly average based on 3-year
addpath ../../../Grid/
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
load('Grid_info.mat','ke','weto_p','depto_grid','zzout','Depth','Depth_w','DZW','latp_grid','zzout_w');
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

LoadLocation = './Mode_function/';
SaveLocation = './Mode_function/';
%%
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);

ie = size(depto_grid,1);
je = size(depto_grid,2);
for m_select = 1:12
    %%
    disp(['Month=',num2str(m_select)]);
    zwmodes = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_MSS.nc'],'zwmodes');% wmodes对应水深
    wmodes  = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_MSS.nc'],'wmodes');   % Wm
    wzmodes = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_MSS.nc'],'wzmodes');  % 1st 导数

    % ========= sign propagation (per mode) for wmodes & wzmodes =========

    [ie,je,nz,nm] = size(wmodes);
    sign = ones(ie,je,nm);
    for i = 1:ie
        for j = 1:je
            for n = 1:nm
                w1 = squeeze(wmodes(i,j,:,n));
                if w1(2) < 0
                    sign(i,j,n) = -1;
                end
            end
    
        end
    end

      nc_sign = [SaveLocation,'M2_Modal_Sign_',month_file{m_select},'_MSS.nc'];
      if exist(nc_sign,'file'); delete(nc_sign); end
      sz = size(sign);
      nccreate(nc_sign,'sign','Dimensions',{'i',sz(1),'j',sz(2),'m',sz(3)});
      ncwrite(nc_sign,'sign',sign);
end
