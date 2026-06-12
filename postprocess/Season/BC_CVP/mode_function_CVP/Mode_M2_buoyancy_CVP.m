clear;clc;close all
tic
%%
addpath ../../../Grid/
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid','Depth','Depth_w','DZW','latp_grid','zzout', ...
    'bottom_index');
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);
LoadLocation = './Mode_function/';
Data1Location ='../Buoyancy/';
Data2Location ='../Pressure/';

Save1Location = './Buoyancy/';
Save2Location = './Pressure/';

load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
zzout  = zzout(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);
ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
% load([LoadLocation,'M2_Modal_Buoyancy_MSS.mat']);
% load([LoadLocation,'M2_Modal_Pressure_MSS.mat']);
% load([LoadLocation,'M2_Modal_Vertical_MSS.mat'],'zwmodes');
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
for m_select = 11:12
    % zwmodes bmodes pmodes
    % load([LoadLocation,'M2_Modal_Buoyancy_',month_file{m_select},'_MSS.mat']);
    % load([LoadLocation,'M2_Modal_Pressure_',month_file{m_select},'_MSS.mat']);
    % load([LoadLocation,'M2_Modal_Vertical_',month_file{m_select},'_MSS.mat'],'zwmodes');
    zwmodes = ncread([LoadLocation,'M2_Modal_Vertical_',month_file{m_select},'_CVP.nc'],'zwmodes');
    bmodes = ncread([LoadLocation,'M2_Modal_Buoyancy_',month_file{m_select},'_CVP.nc'],'bmodes');  
    pmodes = ncread([LoadLocation,'M2_Modal_Pressure_',month_file{m_select},'_CVP.nc'],'pmodes'); 
    load([Data1Location,'res_bbc_',month_file{m_select},'_CVCTM.mat'], 'ba_bc','bg_bc')
    load([Data2Location,'res_pbc_',month_file{m_select},'_CVCTM.mat'], 'pa_bc','pg_bc')
    ba = ba_bc;bg = bg_bc;
    pa = pa_bc;pg = pg_bc;
    ba = reshape(ba,[ie,je,ke]);
    pa = reshape(pa,[ie,je,ke+1]);
    bg = reshape(bg,[ie,je,ke]);
    pg = reshape(pg,[ie,je,ke+1]); 
    % buoyancy
    Alpha_b = ba.*cosd(bg);
    Beta_b = ba.*sind(bg);
    % Pressure
    Alpha_p = pa.*cosd(pg);
    Beta_p = pa.*sind(pg);
    clear ba_bc bg_bc pa_bc pg_bc
    clear ba bg pa pg
%% Least squares fit method

    mode = 10;
    Amp_p =  zeros(ie,je,mode); % An(z)
    Pha_p =  zeros(ie,je,mode);
    
    Amp_b =  zeros(ie,je,mode);
    Pha_b =  zeros(ie,je,mode);
    
    Ab_A =  zeros(ie,je,mode);
    Ab_B =  zeros(ie,je,mode);
    Ap_A =  zeros(ie,je,mode);
    Ap_B =  zeros(ie,je,mode);
    Eigen_level = zeros(ie,je);
    diary(['Buoyancy_Month=',month_file{m_select},'_output_log.txt'])
    for i = 1:ie  % Model grid
        for j = 1: je
             if (weto_p(i,j,1) ~= 0)
                 % disp([num2str(depto_grid(i,j)),'m'])
                 % disp(['i=',num2str(i),'j=',num2str(j)])
                 zp = squeeze(zzout(i,j,1:bottom_index(i,j))); % model depth
                 nz = bottom_index(i,j)+1;  % nz<=ke+1
                 %% Ensure the minimum mode numbers 12
                 if nz <= mode+2
                      nz = mode+2; % new nz = mode
                 end
                 Eigen_level(i,j) = nz; % Vertical level size
%% Buoyancy
                clear Bm Pm alpha beta
                Bm(:,1:mode) = (-1)*(bmodes(i,j,1:nz,1:mode));
                alpha = interp1(zp,squeeze(Alpha_b(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_b(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap'); % B(x,z)
                [Ga,Ba] = LeastSquaresFit(Bm,alpha);
                [Gb,Bb] = LeastSquaresFit(Bm,beta);
                %
                AAb = Ga\Ba; % AAbn(x)
                BBb = Gb\Bb; % BBbn(x)
                %
                Amp_b(i,j,1:mode) = sqrt(AAb.^2+BBb.^2);
                Pha_b(i,j,1:mode) = atan2d(BBb,AAb); % -180 <= atan2d(Y,X) <= 180.
                Ab_A(i,j,1:mode)  = AAb;
                Ab_B(i,j,1:mode)  = BBb;
%% Pressure 
% Attention: including the bottom Pressure
                clear Pm Ga Ba Gb Bb alpha beta AAb BBb zp_pressure
                Pm(:,1:mode) = (-1).*(pmodes(i,j,1:nz,1:mode));
                zp_pressure = [squeeze(zzout(i,j,1:bottom_index(i,j)));depto_grid(i,j)]; % model depth
                alpha = interp1(zp_pressure,squeeze(Alpha_p(i,j,1:bottom_index(i,j)+1)),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap');  % A(x,z)
                beta = interp1(zp_pressure,squeeze(Beta_p(i,j,1:bottom_index(i,j)+1)),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap'); % B(x,z)
                [Ga,Ba] = LeastSquaresFit(Pm,alpha);
                [Gb,Bb] = LeastSquaresFit(Pm,beta);
                %
                AAp = Ga\Ba; % AApn(x)
                BBp = Gb\Bb; % BBpn(x)
    
                Amp_p(i,j,1:mode) = sqrt(AAp.^2+BBp.^2);
                Pha_p(i,j,1:mode) = atan2d(BBp,AAp); % -180 <= atan2d(Y,X) <= 180.
                    
                Ap_A(i,j,1:mode)  = AAp;
                Ap_B(i,j,1:mode)  = BBp; 
             end
        end
    end
    diary off
    save([Save1Location,'M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'-v7.3','Amp_b','Pha_b','Ab_A','Ab_B','Eigen_level');
    save([Save2Location,'M2_Modal_Pressure_',month_file{m_select},'.mat'],'-v7.3','Amp_p','Pha_p','Ap_A','Ap_B');

end
