clear;clc;close all
%% load modal eigenfunctions & Define the topographic coupleing coefficients
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
%% Model global grid
addpath ../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','bottom_index','zzout','ddpo_grid');
load('Grid_resolution.mat', 'dlyv','dlxu');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);
dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);
zzout= Exclude_sponge(iw,ie,jn,js,zzout);
ddpo_grid= Exclude_sponge(iw,ie,jn,js,ddpo_grid);
ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

load('CapeVerdeplateau_index.mat')
weto_p       = weto_p(select_indicex,select_indicey,:);
ddpo_grid = ddpo_grid(select_indicex,select_indicey,:);
depto_grid   = depto_grid(select_indicex,select_indicey);
bottom_index  = bottom_index(select_indicex,select_indicey);
zzout = zzout(select_indicex,select_indicey,:);
dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%% terms of equations
Modeloc=['./Mode_function'];
Buoyaloc = ['./Buoyancy'];
Pressloc = ['./Pressure'];
Velocityloc = ['./Velocity'];
MeanCurrentloc = [' ../../Average/BackgroundCurrent'];
Effectloc = ['./Mean_effective_term'];
% Modeloc=['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function'];
if ~exist('Equation_term','dir'); mkdir Equation_term; end
%addpath /Users/josephhuang/Desktop/workingplace/斜压模拟/内潮基本要素/IT_functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
imodes = 10;
g=9.81;
rou0=1025;
thr = 0.05;   % %5
for m_select = 1:1:12
    disp([num2str(m_select),'  Month']);
    ce = ncread([Modeloc,'/M2_Modal_eigenspeed_',month_file{m_select},'_CVP.nc'],'ce'); 
    load([Pressloc,'/M2_Modal_Pressure_',month_file{m_select},'.mat'],'Amp_p','Pha_p');
    load([Buoyaloc,'/M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'Amp_b','Pha_b');
    load([Velocityloc,'/M2_Modal_Horizontal_Zonal_',month_file{m_select},'.mat'],'Amp_u','Pha_u');
    load([Velocityloc,'/M2_Modal_Horizontal_Meridional_',month_file{m_select},'.mat'],'Amp_v','Pha_v');
%% Effective terms
    load([Effectloc,'/Mean_velocity_Umn_', month_file{m_select}, '.mat'],'Umn_x','Umn_y');
    load([Effectloc,'/Mean_velocity_Upmn_', month_file{m_select}, '.mat'],'Upmn_x','Upmn_y');
    load([Effectloc,'/Mean_velocity_Uzmn_', month_file{m_select}, '.mat'],'Uzmn_x','Uzmn_y');
    load([Effectloc,'/Mean_buoyancy_Bmn_', month_file{m_select}, '.mat'],'Bmn_x','Bmn_y');
%% Gradidents
    Pha_px = zeros(size(Pha_p));Amp_px= zeros(size(Amp_p));
    Pha_py = zeros(size(Pha_p));Amp_py= zeros(size(Amp_p));  
    Pha_ux = zeros(size(Pha_u));Amp_ux= zeros(size(Amp_u));  
    Pha_uy = zeros(size(Pha_u));Amp_uy= zeros(size(Amp_u));  
    Pha_vx = zeros(size(Pha_v));Amp_vx= zeros(size(Amp_v));  
    Pha_vy = zeros(size(Pha_v));Amp_vy= zeros(size(Amp_v));    
    alpha = zeros(ie,je,imodes);
    Pha_u_use = zeros(size(Pha_u));
    Pha_v_use = zeros(size(Pha_v));
    Pha_p_use = zeros(size(Pha_p));
    Pha_b_use = zeros(size(Pha_b));
    Pha_p = deg2rad(Pha_p);
    Pha_u = deg2rad(Pha_u);
    Pha_v = deg2rad(Pha_v);
    Pha_b = deg2rad(Pha_b);
    Amp_p = Amp_p/rou0;

    Umn_u_dx = zeros(size(Umn_x));Umn_v_dx = zeros(size(Umn_y));
    Umn_u_dy = zeros(size(Umn_x));Umn_v_dy = zeros(size(Umn_y));
    mask_all  = zeros(ie,je,imodes);
    for m = 1:imodes
        % Phase gradient
        [Pha_px(:,:,m), Pha_py(:,:,m)] = phase_gradient_unitcomplex(Pha_p(:,:,m),dlxu,dlyv);
        [Pha_ux(:,:,m), Pha_uy(:,:,m)] = phase_gradient_unitcomplex(Pha_u(:,:,m),dlxu,dlyv);
        [Pha_vx(:,:,m), Pha_vy(:,:,m)] = phase_gradient_unitcomplex(Pha_v(:,:,m),dlxu,dlyv);
        % Amplitude gradient
        % Note:
        % Velocity times depth
         wetmask = weto_p(:,:,1)~=0; 
         Amp_mode(:,:) = Amp_p(:,:,m);
         [Amp_px(:,:,m), Amp_py(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);

         Amp_mode(:,:) = Amp_u(:,:,m).*depto_grid(:,:);
         [Amp_ux(:,:,m), Amp_uy(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
         Amp_u(:,:,m) = Amp_mode(:,:);

         Amp_mode(:,:) = Amp_v(:,:,m).*depto_grid(:,:);
         [Amp_vx(:,:,m), Amp_vy(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
         Amp_v(:,:,m) = Amp_mode(:,:);

         alpha(:,:,m) = g.*depto_grid(:,:)./(ce(:,:,m).*ce(:,:,m));
         Pha_u_use(:,:,m) = Pha_u(:,:,m);
         Pha_v_use(:,:,m) = Pha_v(:,:,m);
         Pha_p_use(:,:,m) = Pha_p(:,:,m);
         Pha_b_use(:,:,m) = Pha_b(:,:,m);

        for n=1:imodes
            % Gradients of mean effective currents
            [Umn_u_dx(:,:,m,n), Umn_u_dy(:,:,m,n)] = grad2_ocean_noland_orctm(Umn_x(:,:,m,n), wetmask, dlxu, dlyv);
            [Umn_v_dx(:,:,m,n), Umn_v_dy(:,:,m,n)] = grad2_ocean_noland_orctm(Umn_y(:,:,m,n), wetmask, dlxu, dlyv);
        end
    end

%% advection term
    Amn = zeros(ie,je,imodes,imodes);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   for n=1:imodes
                        % if ~(mask_all(i,j,m) && mask_all(i,j,n))
                        %     Amn(i,j,m,n) = NaN;
                        %     continue
                        % end
                        Amn(i,j,m,n) = ...
                          ((1/2)*Umn_x(i,j,m,n)*(Amp_ux(i,j,m)*Amp_u(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_u_use(i,j,n)) - ...
                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_u(i,j,n)*sin(Pha_u_use(i,j,m)-Pha_u_use(i,j,n))) + ...
                          (1/2)*Umn_y(i,j,m,n)*(Amp_uy(i,j,m)*Amp_u(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_u_use(i,j,n)) - ...
                                                Pha_uy(i,j,m)*Amp_u(i,j,m)*Amp_u(i,j,n)*sin(Pha_u_use(i,j,m)-Pha_u_use(i,j,n))) + ...
                          (1/2)*Umn_x(i,j,m,n)*(Amp_vx(i,j,m)*Amp_v(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_v_use(i,j,n)) - ...
                                                Pha_vx(i,j,m)*Amp_v(i,j,m)*Amp_v(i,j,n)*sin(Pha_v_use(i,j,m)-Pha_v_use(i,j,n))) + ...
                          (1/2)*Umn_y(i,j,m,n)*(Amp_vy(i,j,m)*Amp_v(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_v_use(i,j,n)) - ...
                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_v(i,j,n)*sin(Pha_v_use(i,j,m)-Pha_v_use(i,j,n))))/depto_grid(i,j) + ...
                          (1/2)*alpha(i,j,n)*Upmn_x(i,j,m,n)*(Amp_px(i,j,m)*Amp_p(i,j,n)*cos(Pha_p_use(i,j,m)-Pha_p_use(i,j,n)) - ...
                                                              Pha_px(i,j,m)*Amp_p(i,j,m)*Amp_p(i,j,n)*sin(Pha_p_use(i,j,m)-Pha_p_use(i,j,n))) + ...
                          (1/2)*alpha(i,j,n)*Upmn_y(i,j,m,n)*(Amp_py(i,j,m)*Amp_p(i,j,n)*cos(Pha_p_use(i,j,m)-Pha_p_use(i,j,n)) - ...
                                                              Pha_py(i,j,m)*Amp_p(i,j,m)*Amp_p(i,j,n)*sin(Pha_p_use(i,j,m)-Pha_p_use(i,j,n)));
                   end
               end
            end
        end
    end
    save(['./Equation_term/Advection_', month_file{m_select}, '.mat'], ...
         'Amn','-v7.3');
%% Shear term
    PSmn_v = zeros(ie,je,imodes,imodes);
    PSmn_h = zeros(ie,je,imodes,imodes);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   for n=1:imodes
                        % if ~(mask_all(i,j,m) && mask_all(i,j,n))
                        %     PSmn(i,j,m,n) = NaN;
                        %     continue
                        % end
                        PSmn_v(i,j,m,n) = ...
                           Uzmn_x(i,j,m,n)/(2*depto_grid(i,j))*(Amp_ux(i,j,m)*Amp_u(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_u_use(i,j,n)) - ...
                                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_u(i,j,n)*sin(Pha_u_use(i,j,m)-Pha_u_use(i,j,n)) + ...
                                                                Amp_vy(i,j,m)*Amp_u(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_u_use(i,j,n)) - ...
                                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_u(i,j,n)*sin(Pha_v_use(i,j,m)-Pha_u_use(i,j,n))) + ...
                           Uzmn_y(i,j,m,n)/(2*depto_grid(i,j))*(Amp_ux(i,j,m)*Amp_v(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_v_use(i,j,n)) - ...
                                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_v(i,j,n)*sin(Pha_u_use(i,j,m)-Pha_v_use(i,j,n)) + ...
                                                                Amp_vy(i,j,m)*Amp_v(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_v_use(i,j,n)) - ...
                                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_v(i,j,n)*sin(Pha_v_use(i,j,m)-Pha_v_use(i,j,n)));
                        PSmn_h(i,j,m,n) = ...
                           -(Umn_u_dx(i,j,m,n)/depto_grid(i,j)*Amp_u(i,j,m)*Amp_u(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_u_use(i,j,n)) + ...
                            Umn_u_dy(i,j,m,n)/depto_grid(i,j)*Amp_v(i,j,m)*Amp_u(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_u_use(i,j,n)) + ...
                            Umn_v_dx(i,j,m,n)/depto_grid(i,j)*Amp_u(i,j,m)*Amp_v(i,j,n)*cos(Pha_u_use(i,j,m)-Pha_v_use(i,j,n)) + ...
                            Umn_v_dy(i,j,m,n)/depto_grid(i,j)*Amp_v(i,j,m)*Amp_v(i,j,n)*cos(Pha_v_use(i,j,m)-Pha_v_use(i,j,n)));
                   end

               end
            end
        end
    end

    save(['./Equation_term/ShearProduct_', month_file{m_select}, '.mat'], ...
         'PSmn_v','PSmn_h','-v7.3');
%% Buoyancy terms
    PBmn = zeros(ie,je,imodes,imodes);
    PBmn_b = zeros(ie,je,imodes,imodes);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   for n=1:imodes
                        % if ~(mask_all(i,j,m) && mask_all(i,j,n))
                        %     PBmn(i,j,m,n) = NaN;
                        %     continue
                        % end
                         PBmn(i,j,m,n) = ...
                            Bmn_x(i,j,m,n)/(ce(i,j,n)^2) * ...
                            Amp_u(i,j,m)*Amp_p(i,j,n) * ...
                            cos(Pha_u_use(i,j,m)-Pha_p_use(i,j,n)) ...
                          + ...
                            Bmn_y(i,j,m,n)/(ce(i,j,n)^2) * ...
                            Amp_v(i,j,m)*Amp_p(i,j,n) * ...
                            cos(Pha_v_use(i,j,m)-Pha_p_use(i,j,n));
                         % Using buoyancy amp & phase
                         PBmn_b(i,j,m,n) = ...
                           - Bmn_x(i,j,m,n) * ...
                            Amp_u(i,j,m)*Amp_b(i,j,n) * ...
                            cos(Pha_u_use(i,j,m)-Pha_b_use(i,j,n)) ...
                          - ...
                            Bmn_y(i,j,m,n) * ...
                            Amp_v(i,j,m)*Amp_b(i,j,n) * ...
                            cos(Pha_v_use(i,j,m)-Pha_b_use(i,j,n));            
                   end
               end
            end
        end
    end

    save(['./Equation_term/BuoyancyProduct_', month_file{m_select}, '.mat'], ...
         'PBmn','PBmn_b','-v7.3');
end
