clear;clc;close all
%% T-tide using least square method for baroclinic velocity
tic
ttide = 1;     % whether use the t_tide.
para  = 1;     % whether use the parallel.
maxNumCompThreads = 32;
if para == 1
   parpool ('local',maxNumCompThreads)
end
%% Please selct the month[m_select]
addpath ../../Grid/
for m_select = 4:12
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
load(['Time_info_',month_file{m_select},'.mat'])
Location = ['../../../',group_per_month{m_select},'/'];
SaveLocation =['./Velocity'];
if ttide == 1
   addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
   start_time = time_index_range(1,:)
   t_order = [4,5,6,11,12];  %the ID , the 29 tide 
   t_freq = 0.0805;
   t_name = ['M2  '];

end
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid');
load('Grid_info_u.mat','weto_u','latu_grid');
load('Grid_info_v.mat','weto_v','latv_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);
latu_grid  = Exclude_sponge(iw,ie,jn,js,latu_grid);
latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);

ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

   % load BT tide consitutents
load(['../Velocity/res_uso_', month_file{m_select}, '_CVCTM.mat'], ...
    'ua_bt','ug_bt');
load(['../Velocity/res_vse_', month_file{m_select}, '_CVCTM.mat'], ...
    'va_bt','vg_bt');

ua_bt = reshape(ua_bt,[ie_global+1,je_global]);
ug_bt = reshape(ug_bt,[ie_global+1,je_global]);
va_bt = reshape(va_bt,[ie_global,je_global+1]);
vg_bt = reshape(vg_bt,[ie_global,je_global+1]);

%% MSS area
load('CoastalDakar_index.mat')
depto_grid = depto_grid(select_indicex,select_indicey);
latu_grid = latu_grid([select_indicex(1)-1;select_indicex],select_indicey);
latv_grid = latv_grid(select_indicex,[select_indicey(1)-1,select_indicey]);
weto_u = weto_u([select_indicex(1)-1;select_indicex],select_indicey,:);
weto_v = weto_v(select_indicex,[select_indicey(1)-1,select_indicey],:);

ua_bt = ua_bt([select_indicex(1)-1;select_indicex],select_indicey);
ug_bt = ug_bt([select_indicex(1)-1;select_indicex],select_indicey);
va_bt = va_bt(select_indicex,[select_indicey(1)-1,select_indicey]);
vg_bt = vg_bt(select_indicex,[select_indicey(1)-1,select_indicey]);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
ua_bc =  zeros((ie+1)*je,ke);
ug_bc =  zeros((ie+1)*je,ke);
va_bc =  zeros(ie*(je+1),ke);
vg_bc =  zeros(ie*(je+1),ke);

ua_level =  zeros((ie+1)*je,1);
ug_level =  zeros((ie+1)*je,1);
va_level =  zeros(ie*(je+1),1);
vg_level =  zeros(ie*(je+1),1);

latuo = reshape(latu_grid,[(ie+1)*je,1]);
latvo = reshape(latv_grid,[ie*(je+1),1]);

ua_bt = reshape(ua_bt,[(ie+1)*je,1]);
ug_bt = reshape(ug_bt,[(ie+1)*je,1]);
va_bt = reshape(va_bt,[ie*(je+1),1]);
vg_bt = reshape(vg_bt,[ie*(je+1),1]);
%%
for k = 1 : ke % k-level
  uko_time = zeros(ie+1,je,tee);
  vke_time = zeros(ie,je+1,tee);    
  for t= 1:1:tee % time
    % 1) Read data at the time t
    tag = sprintf('%08d', LDTRUN_range(t));
    name_u = [Location,'uoo/UOO_',tag,'.nc'];
    name_v = [Location,'voe/VOE_',tag,'.nc'];

    % k-level
    uko = ncread(name_u,'UOO',...
                     [iw+1 jn+1 k],[ie_global+1,je_global,1]);   
    vke = ncread(name_v,'VOE',...
                     [iw+1 jn+1 k],[ie_global,je_global+1,1]);

    uko = squeeze(uko);
    vke = squeeze(vke);

    % using the MSS index
    uko_time(:,:,t) = uko([select_indicex(1)-1;select_indicex],select_indicey);
    vke_time(:,:,t) = vke(select_indicex,[select_indicey(1)-1,select_indicey]);
  end % time
  % remove the tendency
   uko_time = uko_time - mean(uko_time,3);
   vke_time = vke_time - mean(vke_time,3);
%% Preprocess 
   disp(['!!!!!! STRAT --> Vertical Level k = ',num2str(k)])
   uko_level = reshape(uko_time,[(ie+1)*je,tee]);
   vke_level = reshape(vke_time,[ie*(je+1),tee]);
    mask_u   = reshape(weto_u(:,:,k),[(ie+1)*je,1]);
    mask_v   = reshape(weto_v(:,:,k),[ie*(je+1),1]);
  if ttide == 1
%% U
     res=zeros([4 1]);
     parfor i = 1:((ie+1)*je)
       su = uko_level(i,:);
       if (mask_u(i)~=0)  % masko(ij) == 0
            [~,~,res] = t_tide(su, 'start time', start_time, 'interval',1, ...
                               'latitude', latuo(i), 'output','none', ...
                               'rayleigh', ['M2'], 'error','linear','synthesis',0);
            A_tot = res(1,1);    A_bt  = ua_bt(i);   
            phi_tot = res(1,3);  phi_bt = ug_bt(i);    
            
            C_tot = A_tot .* exp(1i*deg2rad(phi_tot));
            C_bt  =  A_bt .* exp(1i*deg2rad(phi_bt));
            C_bc  = C_tot - C_bt;   
            
            % 回到幅相
            ua_level(i) = abs(C_bc);
            ug_level(i) = mod(rad2deg(angle(C_bc)), 360);  % 相位归一到[0,360)
       end
       % disp(['the current processing Num of uko: ',num2str(i)]); 
    end
%% V
    res=zeros([4 1]);
    parfor j = 1 : (ie*(je+1))
       sv = vke_level(j,:);
       if (mask_v(j)~=0)  % masko(ij) == 0
          [~,~,res] = t_tide(sv, 'start time', start_time, 'interval',1, ...
                               'latitude', latvo(j), 'output','none', ...
                               'rayleigh', ['M2'], 'error','linear','synthesis',0);
            A_tot = res(1,1);    A_bt  = va_bt(j);   
            phi_tot = res(1,3);  phi_bt = vg_bt(j);    
            
            C_tot = A_tot .* exp(1i*deg2rad(phi_tot));
            C_bt  =  A_bt .* exp(1i*deg2rad(phi_bt));
            C_bc  = C_tot - C_bt;   
            
            va_level(j,:) = abs(C_bc);
            vg_level(j,:) = mod(rad2deg(angle(C_bc)), 360);  % 相位归一到[0,360)
       end
       disp(['the current processing Num of vke: ',num2str(j)]); 
    end

  end
  ua_bc(:,k,:)=ua_level; %the first line is amplitude
  ug_bc(:,k,:)=ug_level; %the third line is lag angle
  va_bc(:,k,:)=va_level; %the first line is amplitude
  vg_bc(:,k,:)=vg_level; %the third line is lag angle  
  disp(['!!!!!! END --> Vertical Level k = ',num2str(k)])
end
if ttide == 1
save([SaveLocation,'/res_uko_', month_file{m_select}, '_CVCTM.mat'], ...
     'ua_bc','ug_bc','t_name','-v7.3');
save([SaveLocation,'/res_vke_', month_file{m_select}, '_CVCTM.mat'], ...
     'va_bc','vg_bc','t_name','-v7.3');
end

end % for

if para == 1
    delete(gcp('nocreate'))
end

clearvars -except uko_time vke_time latuo latvo latvo lonvo 
t1 = toc;
disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);

