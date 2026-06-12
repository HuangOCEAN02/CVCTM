clear;clc;close all
tic
%%
addpath ../../../Grid/
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid','Depth','Depth_w','DZW','latp_grid','zzout', ...
    'bottom_index');

iw = 10; ie = 1;
jn = 10; js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);
LoadLocation = './Mode_function/';
DataLocation ='../Velocity/';
SaveLocation = './Velocity/';

load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
zzout  = zzout(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);
ie = size(depto_grid,1);
je = size(depto_grid,2);

addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
%%
for m_select = 1:12

    load([DataLocation,'res_uko_',month_file{m_select},'_CVCTM.mat'], 'ua_bc','ug_bc')
    load([DataLocation,'res_vke_',month_file{m_select},'_CVCTM.mat'], 'va_bc','vg_bc')
    % umodes  zwmodes
    % load([LoadLocation,'M2_Modal_Vertical_',month_file{m_select},'_MSS.mat']);
    % load([LoadLocation,'M2_Modal_Horizontal_',month_file{m_select},'_MSS.mat']);
    zwmodes = ncread([LoadLocation,'M2_Modal_Vertical_',month_file{m_select},'_CVP.nc'],'zwmodes');
    umodes = ncread([LoadLocation,'M2_Modal_Horizontal_',month_file{m_select},'_CVP.nc'],'umodes');    
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

%% Least squares fit method   
    mode = 10;
    Amp_u = zeros(ie,je,mode); % An(z)
    Pha_u = zeros(ie,je,mode);
    
    Amp_v = zeros(ie,je,mode);
    Pha_v = zeros(ie,je,mode);
    
    Au_A = zeros(ie,je,mode);
    Au_B = zeros(ie,je,mode);
    
    Av_A = zeros(ie,je,mode);
    Av_B = zeros(ie,je,mode);
    modal_nz = zeros(ie,je,2);

    % fid = fopen(['Month=',month_file{m_select},'_output_log.txt'], 'a'); 
    diary(['Velocity_Month=',month_file{m_select},'_output_log.txt'])
    for i = 1:ie  % Model grid
        for j = 1: je
             if (weto_p(i,j,1) ~= 0)
                 % disp([num2str(depto_grid(i,j)),'m'])
                 % disp(['i=',num2str(i),'j=',num2str(j)])
                 % fprintf(fid, '%sm\n', num2str(depto_grid(i,j)));
                 % fprintf(fid, 'i=%d, j=%d\n', i, j);
                 zp = squeeze(zzout(i,j,1:bottom_index(i,j))); % model depth
                 z_eigen = squeeze(zwmodes(i,j,:)); % Eigenfunciton depth
                 nz = bottom_index(i,j)+1;  % nz<=ke+1
                 %%
                 if nz <= mode+2
                      nz = mode+2; % new nz = mode
                 end
%% U
                clear Um alpha beta Ga Gb Ba Bb Au Bu
                Um(:,1:mode) = squeeze(umodes(i,j,1:nz,1:mode));
                % Um(:,1:mode) = GuiYiHua(Um(:,1:mode)); % Um(z)
                % Um(:,1:mode) = (-1)* sqrt(Um(:,1:mode).^2);
                alpha = interp1(zp,squeeze(Alpha_u(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_u(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap'); % B(x,z)
                % alpha = squeeze(Alpha_u(i,j,1:nz)); % A(x,z)
                %  beta = squeeze(Beta_u(i,j,1:nz)); % B(x,z)
                 [Ga,Ba] = LeastSquaresFit(Um,alpha);
                 [Gb,Bb] = LeastSquaresFit(Um,beta);
                 Au = Ga\Ba; % An(x)
                 Bu = Gb\Bb; % Bn(x)
                Amp_u(i,j,1:mode) = sqrt(Au.^2+Bu.^2);
                Pha_u(i,j,1:mode) = atan2d(Bu,Au); % atan2d  -180 <= atan2d(Y,X) <= 180.
                Au_A(i,j,1:mode)  = Au;
                Au_B(i,j,1:mode)  = Bu;
%% V
                clear alpha beta Ga Gb Ba Bb Av Bv
                % alpha = squeeze(Alpha_v(i,j,1:nz)); % A(x,z)
                %  beta = squeeze(Beta_v(i,j,1:nz)); % B(x,z)
                alpha = interp1(zp,squeeze(Alpha_v(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap');  % A(x,z)
                beta = interp1(zp,squeeze(Beta_v(i,j,1:bottom_index(i,j))),squeeze(zwmodes(i,j,1:nz)),'nearest','extrap'); % B(x,z)
               
                % A(x,z) = Sum(Avn(x)*Um(z))
                [Ga,Ba] = LeastSquaresFit(Um,alpha);
                % B(x,z) = Sum(Bvn(x)*Um(z))
                [Gb,Bb] = LeastSquaresFit(Um,beta);

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
    save([SaveLocation,'M2_Modal_Horizontal_Zonal_',month_file{m_select},'.mat'],'-v7.3','Amp_u','Pha_u','Au_A','Au_B');
    save([SaveLocation,'M2_Modal_Horizontal_Meridional_',month_file{m_select},'.mat'],'-v7.3','Amp_v','Pha_v','Av_A','Av_B');
   % save([DataLocation,'M2_Modal_number_leastfit_',month_file{m_select},'.mat'],'-v7.3','modal')
end
