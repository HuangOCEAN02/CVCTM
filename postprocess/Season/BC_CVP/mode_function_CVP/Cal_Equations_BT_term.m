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
BTVelocityloc = ['../../Velocity/']
MeanCurrentloc = ['../../Average/BackgroundCurrent'];
Effectloc = ['./Mean_effective_term'];
% Modeloc=['/Volumes/BackupPlus/CVCTM/标准实验/2014/WithTide/post_process/Season/BC_MSS/mode_function_MSS/Mode_function'];
if ~exist('Equation_term','dir'); mkdir Equation_term; end
%addpath /Users/josephhuang/Desktop/workingplace/斜压模拟/内潮基本要素/IT_functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
imodes = 10;
g=9.81;
rou0 = 1025;
thr =  0.05;   % %5
for m_select = 1:1:12
    disp([num2str(m_select),'  Month']);
    ce = ncread([Modeloc,'/M2_Modal_eigenspeed_',month_file{m_select},'_CVP.nc'],'ce'); 
    load([Pressloc,'/M2_Modal_Pressure_',month_file{m_select},'.mat'],'Amp_p','Pha_p');
    load([Buoyaloc,'/M2_Modal_Buoyancy_',month_file{m_select},'.mat'],'Amp_b','Pha_b');
    load([Velocityloc,'/M2_Modal_Horizontal_Zonal_',month_file{m_select},'.mat'],'Amp_u','Pha_u');
    load([Velocityloc,'/M2_Modal_Horizontal_Meridional_',month_file{m_select},'.mat'],'Amp_v','Pha_v');
%% BT velocity
    load([BTVelocityloc,'/res_uso_', month_file{m_select}, '_CVCTM.mat'], ...
        'ua_bt','ug_bt');
    load([BTVelocityloc,'/res_vse_', month_file{m_select}, '_CVCTM.mat'], ...
        'va_bt','vg_bt');
    
    ua_bt = reshape(ua_bt,[ie_global+1,je_global]);Amp_ubt = ua_bt(select_indicex,select_indicey);
    ug_bt = reshape(ug_bt,[ie_global+1,je_global]);Pha_ubt = ug_bt(select_indicex,select_indicey);
    va_bt = reshape(va_bt,[ie_global,je_global+1]);Amp_vbt = va_bt(select_indicex,select_indicey);
    vg_bt = reshape(vg_bt,[ie_global,je_global+1]);Pha_vbt = vg_bt(select_indicex,select_indicey);
%% Effective BT terms
    load([Effectloc,'/Mean_velocity_Umn_BT_', month_file{m_select}, '.mat'],'Umn_btx','Umn_bty');
    load([Effectloc,'/Mean_velocity_Uzmn_BT_', month_file{m_select}, '.mat'],'Uzmn_btx','Uzmn_bty');
    load([Effectloc,'/Mean_buoyancy_Bmn_BT_', month_file{m_select}, '.mat'],'Bmn_btx','Bmn_bty');

    Upmn_btx = zeros(size(Uzmn_btx));
    Upmn_bty = zeros(size(Uzmn_bty));

%% Gradidents
    Pha_px = zeros(size(Pha_p));Amp_px= zeros(size(Amp_p));
    Pha_py = zeros(size(Pha_p));Amp_py= zeros(size(Amp_p));  
    Pha_ux = zeros(size(Pha_u));Amp_ux= zeros(size(Amp_u));  
    Pha_uy = zeros(size(Pha_u));Amp_uy= zeros(size(Amp_u));  
    Pha_vx = zeros(size(Pha_v));Amp_vx= zeros(size(Amp_v));  
    Pha_vy = zeros(size(Pha_v));Amp_vy= zeros(size(Amp_v));
    Amp_p = Amp_p/rou0;
    % BT
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Pha_ubtx = zeros(size(Pha_ubt));Amp_ubtx= zeros(size(Amp_ubt));  
    Pha_ubty = zeros(size(Pha_ubt));Amp_ubty= zeros(size(Amp_ubt));  
    Pha_vbtx = zeros(size(Pha_ubt));Amp_vbtx= zeros(size(Amp_ubt));  
    Pha_vbty = zeros(size(Pha_ubt));Amp_vbty= zeros(size(Amp_ubt));  

    Pha_u_use = zeros(size(Pha_u));
    Pha_v_use = zeros(size(Pha_v));
    Pha_p_use = zeros(size(Pha_p));
    Pha_b_use = zeros(size(Pha_b));
    Pha_p = deg2rad(Pha_p);
    Pha_b = deg2rad(Pha_b);
    Pha_u = deg2rad(Pha_u);Pha_ubt = deg2rad(Pha_ubt);
    Pha_v = deg2rad(Pha_v);Pha_vbt = deg2rad(Pha_vbt);

    Umn_ubt_dx = zeros(size(Umn_btx));Umn_vbt_dx = zeros(size(Umn_bty));
    Umn_ubt_dy = zeros(size(Umn_btx));Umn_vbt_dy = zeros(size(Umn_bty));
    
     % Phase gradient
    [Pha_ubtx(:,:), Pha_ubty(:,:)] = phase_gradient_unitcomplex(Pha_ubt(:,:),dlxu,dlyv);
    [Pha_vbtx(:,:), Pha_vbty(:,:)] = phase_gradient_unitcomplex(Pha_vbt(:,:),dlxu,dlyv);

     wetmask = weto_p(:,:,1)~=0; 
     Amp_mode(:,:) = Amp_ubt(:,:).*depto_grid(:,:);
     [Amp_ubtx(:,:), Amp_ubty(:,:)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
     Amp_ubt(:,:) = Amp_mode(:,:);

     Amp_mode(:,:) = Amp_vbt(:,:).*depto_grid(:,:);
     [Amp_vbtx(:,:), Amp_vbty(:,:)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
     Amp_vbt(:,:) = Amp_mode(:,:);

     Pha_ubt_use(:,:) = Pha_ubt;
     Pha_vbt_use(:,:) = Pha_vbt;
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    mask_all  = zeros(ie,je,imodes);
    
    for m = 1:imodes

        % NOTE:
        % array row = physical -y
        % array col = physical +x
        % Phase using rad

        % Phase gradient
        [Pha_px(:,:,m), Pha_py(:,:,m)] = phase_gradient_unitcomplex(Pha_p(:,:,m),dlxu,dlyv);
        [Pha_ux(:,:,m), Pha_uy(:,:,m)] = phase_gradient_unitcomplex(Pha_u(:,:,m),dlxu,dlyv);
        [Pha_vx(:,:,m), Pha_vy(:,:,m)] = phase_gradient_unitcomplex(Pha_v(:,:,m),dlxu,dlyv);

        % Amplitude
        % Note:
        % Velocity times depth
         Amp_mode(:,:) = Amp_p(:,:,m);
         [Amp_px(:,:,m), Amp_py(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);

         Amp_mode(:,:) = Amp_u(:,:,m).*depto_grid(:,:);
         [Amp_ux(:,:,m), Amp_uy(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
         Amp_u(:,:,m) = Amp_mode(:,:);

         Amp_mode(:,:) = Amp_v(:,:,m).*depto_grid(:,:);
         [Amp_vx(:,:,m), Amp_vy(:,:,m)] = grad2_ocean_noland_orctm(Amp_mode, wetmask, dlxu, dlyv);
         Amp_v(:,:,m) = Amp_mode(:,:);

         Pha_u_use(:,:,m) = Pha_u(:,:,m);
         Pha_v_use(:,:,m) = Pha_v(:,:,m);
         Pha_p_use(:,:,m) = Pha_p(:,:,m);
         Pha_b_use(:,:,m) = Pha_b(:,:,m);

        for n=1:2
            % Gradients of mean effective currents
            [Umn_ubt_dx(:,:,m,n), Umn_ubt_dy(:,:,m,n)] = grad2_ocean_noland_orctm(Umn_btx(:,:,m,n), wetmask, dlxu, dlyv);
            [Umn_vbt_dx(:,:,m,n), Umn_vbt_dy(:,:,m,n)] = grad2_ocean_noland_orctm(Umn_bty(:,:,m,n), wetmask, dlxu, dlyv);
        end
    end

%% Advection term
    Amn_bt = zeros(ie,je,imodes,2);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   nn=1; % n=0
                        Amn_bt(i,j,m,nn) = ...
                          ((1/2)*Umn_btx(i,j,m,nn)*(Amp_ux(i,j,m)*Amp_ubt(i,j)*cos(Pha_u_use(i,j,m)-Pha_ubt_use(i,j)) - ...
                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_ubt(i,j)*sin(Pha_u_use(i,j,m)-Pha_ubt_use(i,j))) + ...
                          (1/2)*Umn_bty(i,j,m,nn)*(Amp_uy(i,j,m)*Amp_ubt(i,j)*cos(Pha_u_use(i,j,m)-Pha_ubt_use(i,j)) - ...
                                                Pha_uy(i,j,m)*Amp_u(i,j,m)*Amp_ubt(i,j)*sin(Pha_u_use(i,j,m)-Pha_ubt_use(i,j))) + ...
                          (1/2)*Umn_btx(i,j,m,nn)*(Amp_vx(i,j,m)*Amp_vbt(i,j)*cos(Pha_v_use(i,j,m)-Pha_vbt_use(i,j)) - ...
                                                Pha_vx(i,j,m)*Amp_v(i,j,m)*Amp_vbt(i,j)*sin(Pha_v_use(i,j,m)-Pha_vbt_use(i,j))) + ...
                          (1/2)*Umn_bty(i,j,m,nn)*(Amp_vy(i,j,m)*Amp_vbt(i,j)*cos(Pha_v_use(i,j,m)-Pha_vbt_use(i,j)) - ...
                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_vbt(i,j)*sin(Pha_v_use(i,j,m)-Pha_vbt_use(i,j))))/depto_grid(i,j);
               end
               for n = 1:imodes
                   mm=2; % m=0
                        Amn_bt(i,j,n,mm) = ...
                          ((1/2)*Umn_btx(i,j,n,mm)*(Amp_ubtx(i,j)*Amp_u(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_u_use(i,j,n)) - ...
                                                Pha_ubtx(i,j)*Amp_ubt(i,j)*Amp_u(i,j,n)*sin(Pha_ubt_use(i,j)-Pha_u_use(i,j,n))) + ...
                          (1/2)*Umn_bty(i,j,n,mm)*(Amp_ubty(i,j)*Amp_u(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_u_use(i,j,n)) - ...
                                                Pha_ubty(i,j)*Amp_ubt(i,j)*Amp_u(i,j,n)*sin(Pha_ubt_use(i,j)-Pha_u_use(i,j,n))) + ...
                          (1/2)*Umn_btx(i,j,n,mm)*(Amp_vbtx(i,j)*Amp_v(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_v_use(i,j,n)) - ...
                                                Pha_vbtx(i,j)*Amp_vbt(i,j)*Amp_v(i,j,n)*sin(Pha_vbt_use(i,j)-Pha_v_use(i,j,n))) + ...
                          (1/2)*Umn_bty(i,j,n,mm)*(Amp_vbty(i,j)*Amp_v(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_v_use(i,j,n)) - ...
                                                Pha_vbty(i,j)*Amp_vbt(i,j)*Amp_v(i,j,n)*sin(Pha_vbt_use(i,j)-Pha_v_use(i,j,n))))/depto_grid(i,j);
               end
            end
        end
    end

    save(['./Equation_term/Advection_BT_', month_file{m_select}, '.mat'], ...
         'Amn_bt','-v7.3');

%% Shear term
    PSmn_v_bt = zeros(ie,je,imodes,2);
    PSmn_h_bt = zeros(ie,je,imodes,2);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   nn=1; % n=0
                        PSmn_v_bt(i,j,m,nn) = ...
                           Uzmn_btx(i,j,m,nn)/(2*depto_grid(i,j))*(Amp_ux(i,j,m)*Amp_ubt(i,j)*cos(Pha_u_use(i,j,m)-Pha_ubt_use(i,j)) - ...
                                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_ubt(i,j)*sin(Pha_u_use(i,j,m)-Pha_ubt_use(i,j)) + ...
                                                                Amp_vy(i,j,m)*Amp_ubt(i,j)*cos(Pha_v_use(i,j,m)-Pha_ubt_use(i,j)) - ...
                                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_ubt(i,j)*sin(Pha_v_use(i,j,m)-Pha_ubt_use(i,j))) + ...
                           Uzmn_bty(i,j,m,nn)/(2*depto_grid(i,j))*(Amp_ux(i,j,m)*Amp_vbt(i,j)*cos(Pha_u_use(i,j,m)-Pha_vbt_use(i,j)) - ...
                                                                Pha_ux(i,j,m)*Amp_u(i,j,m)*Amp_vbt(i,j)*sin(Pha_u_use(i,j,m)-Pha_vbt_use(i,j)) + ...
                                                                Amp_vy(i,j,m)*Amp_vbt(i,j)*cos(Pha_v_use(i,j,m)-Pha_vbt_use(i,j)) - ...
                                                                Pha_vy(i,j,m)*Amp_v(i,j,m)*Amp_vbt(i,j)*sin(Pha_v_use(i,j,m)-Pha_vbt_use(i,j)));
                        PSmn_h_bt(i,j,m,nn) = ...
                            - (Umn_ubt_dx(i,j,m,nn)/depto_grid(i,j)*Amp_u(i,j,m)*Amp_ubt(i,j)*cos(Pha_u_use(i,j,m)-Pha_ubt_use(i,j)) + ...
                            Umn_ubt_dy(i,j,m,nn)/depto_grid(i,j)*Amp_v(i,j,m)*Amp_ubt(i,j)*cos(Pha_v_use(i,j,m)-Pha_ubt_use(i,j)) + ...
                            Umn_vbt_dx(i,j,m,nn)/depto_grid(i,j)*Amp_u(i,j,m)*Amp_vbt(i,j)*cos(Pha_u_use(i,j,m)-Pha_vbt_use(i,j)) + ...
                            Umn_vbt_dy(i,j,m,nn)/depto_grid(i,j)*Amp_v(i,j,m)*Amp_vbt(i,j)*cos(Pha_v_use(i,j,m)-Pha_vbt_use(i,j)));
               end
               for n = 1:imodes
                   mm = 2; % m =0
                        PSmn_v_bt(i,j,n,mm) = ...
                           Uzmn_btx(i,j,n,mm)/(2*depto_grid(i,j))*(Amp_ubtx(i,j)*Amp_u(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_u_use(i,j,n)) - ...
                                                                Pha_ubtx(i,j)*Amp_ubt(i,j)*Amp_u(i,j,n)*sin(Pha_ubt_use(i,j)-Pha_u_use(i,j,n)) + ...
                                                                Amp_vbty(i,j)*Amp_u(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_u_use(i,j,n)) - ...
                                                                Pha_vbty(i,j)*Amp_vbt(i,j)*Amp_u(i,j,n)*sin(Pha_vbt_use(i,j)-Pha_u_use(i,j,n))) + ...
                           Uzmn_bty(i,j,n,mm)/(2*depto_grid(i,j))*(Amp_ubtx(i,j)*Amp_v(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_v_use(i,j,n)) - ...
                                                                Pha_ubtx(i,j)*Amp_ubt(i,j)*Amp_v(i,j,n)*sin(Pha_ubt_use(i,j)-Pha_v_use(i,j,n)) + ...
                                                                Amp_vbty(i,j)*Amp_v(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_v_use(i,j,n)) - ...
                                                                Pha_vbty(i,j)*Amp_vbt(i,j)*Amp_v(i,j,n)*sin(Pha_vbt_use(i,j)-Pha_v_use(i,j,n)));
                        PSmn_h_bt(i,j,n,mm) = ...
                            - (Umn_ubt_dx(i,j,n,mm)/depto_grid(i,j)*Amp_ubt(i,j)*Amp_u(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_u_use(i,j,n)) + ...
                            Umn_ubt_dy(i,j,n,mm)/depto_grid(i,j)*Amp_vbt(i,j)*Amp_u(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_u_use(i,j,n)) + ...
                            Umn_vbt_dx(i,j,n,mm)/depto_grid(i,j)*Amp_ubt(i,j)*Amp_v(i,j,n)*cos(Pha_ubt_use(i,j)-Pha_v_use(i,j,n)) + ...
                            Umn_vbt_dy(i,j,n,mm)/depto_grid(i,j)*Amp_vbt(i,j)*Amp_v(i,j,n)*cos(Pha_vbt_use(i,j)-Pha_v_use(i,j,n)));

               end
            end
        end
    end

    save(['./Equation_term/ShearProduct_BT_', month_file{m_select}, '.mat'], ...
         'PSmn_v_bt','PSmn_h_bt','-v7.3');

%% Buoyancy terms
    PBmn_bt = zeros(ie,je,imodes,2);
    PBmn_bt_b = zeros(ie,je,imodes,2);
    for i = 1:ie
        for j =1:je
            if weto_p(i,j,1)~=0
               for m = 1:imodes
                   nn = 1; % n=0
                         PBmn_bt(i,j,m,nn) = 0;

               end
               for n = 1:imodes
                   mm = 2; % m=0
                          PBmn_bt(i,j,n,mm) = ...
                            Bmn_btx(i,j,n,mm)/(ce(i,j,n)^2) * ...
                            Amp_ubt(i,j)*Amp_p(i,j,n) * ...
                            cos(Pha_ubt_use(i,j)-Pha_p_use(i,j,n)) ...
                          + ...
                            Bmn_bty(i,j,n,mm)/(ce(i,j,n)^2) * ...
                            Amp_vbt(i,j)*Amp_p(i,j,n) * ...
                            cos(Pha_vbt_use(i,j)-Pha_p_use(i,j,n));
                          PBmn_bt_b(i,j,n,mm) = ...
                          - Bmn_btx(i,j,n,mm) * ...
                            Amp_ubt(i,j)*Amp_b(i,j,n) * ...
                            cos(Pha_ubt_use(i,j)-Pha_b_use(i,j,n)) ...
                          - ...
                            Bmn_bty(i,j,n,mm) * ...
                            Amp_vbt(i,j)*Amp_b(i,j,n) * ...
                            cos(Pha_vbt_use(i,j)-Pha_b_use(i,j,n));
               end
           end
        end
     end
   
    save(['./Equation_term/BuoyancyProduct_BT_', month_file{m_select}, '.mat'], ...
         'PBmn_bt','PBmn_bt_b','-v7.3');
end
