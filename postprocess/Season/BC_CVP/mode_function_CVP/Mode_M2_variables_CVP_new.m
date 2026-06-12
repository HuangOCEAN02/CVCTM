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
Data3Location ='../Velocity/';

Save1Location = './Buoyancy/';
Save2Location = './Pressure/';
Save3Location = './Velocity/';

load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
zzout  = zzout(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);
ie = size(depto_grid,1);
je = size(depto_grid,2);
issign = 1;
%%
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
for m_select = 1:12
    zwmodes = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'zwmodes');
    wmodes  = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wmodes');  
    wzmodes = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'wzmodes'); 
    Nsqmodes = ncread([LoadLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'],'Nsqmodes'); 

    if issign
        sig = ncread([LoadLocation,'M2_Modal_Sign_',month_file{m_select},'_CVP.nc'],'sign');
        sign4 = reshape(sig, size(sig,1), size(sig,2), 1, size(sig,3));
        for k = 1:size(wmodes,3)
            wmodes(:,:,k,:) = (wmodes(:,:,k,:)).*sign4(:,:,:,:);
        end
        for k = 1:size(wzmodes,3)
            wzmodes(:,:,k,:) = wzmodes(:,:,k,:).*sign4(:,:,:,:);
        end
    end
    load([Data1Location,'res_bbc_',month_file{m_select},'_CVCTM.mat'], 'ba_bc','bg_bc')
    load([Data2Location,'res_pbc_',month_file{m_select},'_CVCTM.mat'], 'pa_bc','pg_bc')

    load([Data3Location,'res_uko_',month_file{m_select},'_CVCTM.mat'], 'ua_bc','ug_bc')
    load([Data3Location,'res_vke_',month_file{m_select},'_CVCTM.mat'], 'va_bc','vg_bc')

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

    ua = ua_bc;ug = ug_bc;
    va = va_bc;vg = vg_bc;
    ua = reshape(ua,[ie+1,je,ke]);
    va = reshape(va,[ie,je+1,ke]);
    ug = reshape(ug,[ie+1,je,ke]);
    vg = reshape(vg,[ie,je+1,ke]); 

    [Alpha_u] = orctm_uv_to_p(ua.*cosd(ug),'u');
    [Beta_u] = orctm_uv_to_p(ua.*sind(ug),'u');

    [Alpha_v] = orctm_uv_to_p(va.*cosd(vg),'v');
    [Beta_v] = orctm_uv_to_p(va.*sind(vg),'v');

    clear ba_bc bg_bc pa_bc pg_bc
    clear ba bg pa pg
    clear ua va ug vg
%% Least squares fit method

    mode = 10;
    Amp_p =  zeros(ie,je,mode); % An(z)
    Pha_p =  zeros(ie,je,mode);
    
    Amp_b =  zeros(ie,je,mode);
    Pha_b =  zeros(ie,je,mode);
    
    Amp_u = zeros(ie,je,mode); % An(z)
    Pha_u = zeros(ie,je,mode);
    
    Amp_v = zeros(ie,je,mode);
    Pha_v = zeros(ie,je,mode);

    Ab_A =  zeros(ie,je,mode);
    Ab_B =  zeros(ie,je,mode);

    Ap_A =  zeros(ie,je,mode);
    Ap_B =  zeros(ie,je,mode);

    Au_A = zeros(ie,je,mode);
    Au_B = zeros(ie,je,mode);
    
    Av_A = zeros(ie,je,mode);
    Av_B = zeros(ie,je,mode);

    Eigen_level = zeros(ie,je);
    diary(['Baroclinic_Month=',month_file{m_select},'_output_log.txt'])
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
                clear Bm alpha beta Ga Gb Ba Bb
                for k=1:nz
                    Bm(k,1:mode) = wmodes(i,j,k,1:mode).*Nsqmodes(i,j,k);
                end
                alpha = interp1(zp,squeeze(Alpha_b(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_b(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap'); % B(x,z)
                zfit = squeeze(zwmodes(i,j,1:nz));
                [Ga,Ba] = LeastSquaresFit_weighted(Bm, alpha, zfit);
                [Gb,Bb] = LeastSquaresFit_weighted(Bm, beta,  zfit);
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
                clear Pm Ga Ba Gb Bb alpha beta AAp BBp zp_pressure
                Pm(:,1:mode) = squeeze(wzmodes(i,j,1:nz,1:mode));
                zp_pressure = [squeeze(zzout(i,j,1:bottom_index(i,j)));depto_grid(i,j)]; % model depth
                alpha = interp1(zp_pressure,squeeze(Alpha_p(i,j,1:bottom_index(i,j)+1)),squeeze(zwmodes(i,j,1:nz)),'linear','extrap');  % A(x,z)
                beta = interp1(zp_pressure,squeeze(Beta_p(i,j,1:bottom_index(i,j)+1)),squeeze(zwmodes(i,j,1:nz)),'linear','extrap'); % B(x,z)
                zfit = squeeze(zwmodes(i,j,1:nz));
                [Ga,Ba] = LeastSquaresFit_weighted(Pm, alpha, zfit);
                [Gb,Bb] = LeastSquaresFit_weighted(Pm, beta,  zfit);
                %
                AAp = Ga\Ba; % AApn(x)
                BBp = Gb\Bb; % BBpn(x)
    
                Amp_p(i,j,1:mode) = sqrt(AAp.^2+BBp.^2);
                Pha_p(i,j,1:mode) = atan2d(BBp,AAp); % -180 <= atan2d(Y,X) <= 180.
                    
                Ap_A(i,j,1:mode)  = AAp;
                Ap_B(i,j,1:mode)  = BBp; 
%% U
                clear Um alpha beta Ga Gb Ba Bb Au Bu
                Um(:,1:mode) = squeeze(wzmodes(i,j,1:nz,1:mode));
                alpha = interp1(zp,squeeze(Alpha_u(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_u(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap'); % B(x,z)
                % alpha = squeeze(Alpha_u(i,j,1:nz)); % A(x,z)
                %  beta = squeeze(Beta_u(i,j,1:nz)); % B(x,z)
                zfit = squeeze(zwmodes(i,j,1:nz));
                [Ga,Ba] = LeastSquaresFit_weighted(Um, alpha, zfit);
                [Gb,Bb] = LeastSquaresFit_weighted(Um, beta,  zfit);
                 Au = Ga\Ba; % An(x)
                 Bu = Gb\Bb; % Bn(x)
                Amp_u(i,j,1:mode) = sqrt(Au.^2+Bu.^2);
                Pha_u(i,j,1:mode) = atan2d(Bu,Au); % atan2d  -180 <= atan2d(Y,X) <= 180.
                Au_A(i,j,1:mode)  = Au;
                Au_B(i,j,1:mode)  = Bu;
%% V
                clear alpha beta Ga Gb Ba Bb Av Bv
                alpha = interp1(zp,squeeze(Alpha_v(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_v(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'linear','extrap'); % B(x,z)
               
                % A(x,z) = Sum(Avn(x)*Um(z))
                % B(x,z) = Sum(Bvn(x)*Um(z))
                [Ga,Ba] = LeastSquaresFit_weighted(Um, alpha, zfit);
                [Gb,Bb] = LeastSquaresFit_weighted(Um, beta,  zfit);

                Av = Ga\Ba; % An(x)
                Bv = Gb\Bb; % Bn(x)

                Amp_v(i,j,1:mode) = sqrt(Av.^2+Bv.^2);
                Pha_v(i,j,1:mode) = atan2d(Bv,Av); %-180 <= atan2d(Y,X) <= 180.
                Av_A(i,j,1:mode)  = Av;
                Av_B(i,j,1:mode)  = Bv;
             end
        end
    end
    diary off
    save([Save1Location,'M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'-v7.3','Amp_b','Pha_b','Ab_A','Ab_B','Eigen_level');
    save([Save2Location,'M2_Modal_Pressure_',month_file{m_select},'.mat'],'-v7.3','Amp_p','Pha_p','Ap_A','Ap_B');
    save([Save3Location,'M2_Modal_Horizontal_Zonal_',month_file{m_select},'.mat'],'-v7.3','Amp_u','Pha_u','Au_A','Au_B');
    save([Save3Location,'M2_Modal_Horizontal_Meridional_',month_file{m_select},'.mat'],'-v7.3','Amp_v','Pha_v','Av_A','Av_B');

end
