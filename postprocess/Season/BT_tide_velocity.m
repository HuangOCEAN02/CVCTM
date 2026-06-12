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
addpath ../Grid/
m_select = 9;
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
load(['Time_info_',month_file{m_select},'.mat'])
%Location = ['../../',group_per_month{m_select},'/post_process/'];
Location = ['../../',group_per_month{m_select},'/'];
%if m_select==9
%    Location = ['../../',group_per_month{m_select},'/Sep/'];
%end
SaveLocation =['./Velocity'];
if ttide == 1
   addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
   start_time = time_index_range(1,:)
   t_order = [4,5,6,11,12];  %the ID , the 29 tide 
   t_name = ['O1','K1','N2','M2','S2'];
end
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid','weto_p','latp_grid');
load('Grid_info_u.mat','weto_u','latu_grid','lonu_grid','deuto_grid');
load('Grid_info_v.mat','weto_v','latv_grid','lonv_grid','deute_grid');

iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
weto_u  = Exclude_sponge(iw,ie,jn,js,weto_u);
weto_v  = Exclude_sponge(iw,ie,jn,js,weto_v);

latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);

latu_grid  = Exclude_sponge(iw,ie,jn,js,latu_grid);
lonu_grid  = Exclude_sponge(iw,ie,jn,js,lonu_grid);

latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);
lonv_grid  = Exclude_sponge(iw,ie,jn,js,lonv_grid);

deuto_grid = Exclude_sponge(iw,ie,jn,js,deuto_grid);
deute_grid = Exclude_sponge(iw,ie,jn,js,deute_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
ua_bt =  zeros((ie+1)*je,1);
ug_bt =  zeros((ie+1)*je,1);

va_bt =  zeros(ie*(je+1),1);
vg_bt =  zeros(ie*(je+1),1);

ua_level =  zeros((ie+1)*je,1);
ug_level =  zeros((ie+1)*je,1);

va_level =  zeros(ie*(je+1),1);
vg_level =  zeros(ie*(je+1),1);

za_bt = zeros(ie*je,1);
zg_bt = zeros(ie*je,1);

za_level = zeros(ie*je,1);
zg_level = zeros(ie*je,1);

latpo = reshape(latp_grid,[ie*je,1]);

latuo = reshape(latu_grid,[(ie+1)*je,1]);
lonuo = reshape(lonu_grid,[(ie+1)*je,1]);

latvo = reshape(latv_grid,[ie*(je+1),1]);
lonvo = reshape(lonv_grid,[ie*(je+1),1]);
%%
uso_time = zeros(ie+1,je,tee); 
vse_time = zeros(ie,je+1,tee); 
zoo_time= zeros(ie,je,tee); 
  for t= 1:1:tee % time
    % 1) Read data at the time t
    tag = sprintf('%08d', LDTRUN_range(t));
    name_u = [Location,'uoo/UOO_',tag,'.nc'];
    name_v = [Location,'voe/VOE_',tag,'.nc'];

     name_U = [Location,'uso/USO_',tag,'.nc'];
     name_V = [Location,'vse/VSE_',tag,'.nc'];
     name_Z = [Location,'zoo/ZOO_',tag,'.nc'];
    
       
     uko_1 = ncread(name_u,'UOO',...
                         [iw+1 jn+1 1],[ie+1,je,1]);   
     vke_1 = ncread(name_v,'VOE',...
                         [iw+1 jn+1 1],[ie,je+1,1]);
     u_bt = ncread(name_U,'USO',...
                     [iw+1 jn+1 1],[ie+1,je 1]);
     v_bt = ncread(name_V,'VSE',...
                     [iw+1 jn+1 1],[ie,je+1 1]);
    
     zoo = ncread(name_Z,'ZOO',...
                            [iw+1 jn+1],[ie,je]);  
    
        uko_1 = squeeze(uko_1);u_bt  = squeeze(u_bt);
        vke_1 = squeeze(vke_1);v_bt  = squeeze(v_bt);
        zoo   = squeeze(zoo); 
    
        % [u_bt, v_bt, ~, ~] = barotropic_decomposition( ...
        %     uko, vke, dduo_grid, ddue_grid, zoo, weto_u(:,:,1), weto_v(:,:,1));
    
        [uso_time(:,:,t), vse_time(:,:,t)] = Correct_barotropic( ...
             u_bt, v_bt, uko_1, vke_1, zoo, deuto_grid, deute_grid);
        zoo_time(:,:,t) = zoo;
  end % time
%% Preprocess 
   disp(['!!!!!! STRAT --> Barotropic velocity '])
   uko_level = reshape(uso_time,[(ie+1)*je,tee]);
   vke_level = reshape(vse_time,[ie*(je+1),tee]);
   zoo_level = reshape(zoo_time,[ie*je,tee]);
    mask_u   = reshape(weto_u(:,:,1),[(ie+1)*je,1]);
    mask_v   = reshape(weto_v(:,:,1),[ie*(je+1),1]);
    mask_z   = reshape(weto_p(:,:,1),[ie*je,1]);
  if ttide == 1
%% U
     res=zeros([4 1]);
     parfor i = 1:((ie+1)*je)
       su = uko_level(i,:);
       if (mask_u(i)~=0)  % masko(ij) == 0
         [~,~,res]=t_tide(su,'start time',start_time,'interval',1,'latitude',latuo(i),...
             'output','none','rayleigh',['M2'],'error','linear','synthesis',-1);
         ua_level(i,:)=res(:,1);
         ug_level(i,:)=res(:,3);
       end
       % disp(['the current processing Num of uso: ',num2str(i)]); 
    end
%% V
    res=zeros([4 1]);
    parfor j = 1 : (ie*(je+1))
       sv = vke_level(j,:);
       if (mask_v(j)~=0)  % masko(ij) == 0
         [~,~,res]=t_tide(sv,'start time',start_time,'interval',1,'latitude',latvo(j),...
             'output','none','rayleigh',['M2'],'error','linear','synthesis',-1);
         va_level(j,:)=res(:,1); %the first line is amplitude
         vg_level(j,:)=res(:,3); %the third line is lag angle
       end
       disp(['the current processing Num of vse: ',num2str(j)]); 
    end
%% Z
    res=zeros([4 1]);
    parfor j = 1 : (ie*je)
       sz = zoo_level(j,:);
       if (mask_z(j)~=0)  % masko(ij) == 0
         [~,~,res]=t_tide(sz,'start time',start_time,'interval',1,'latitude',latpo(j),...
             'output','none','rayleigh',['M2'],'error','linear','synthesis',-1);
         za_level(j,:)=res(:,1); %the first line is amplitude
         zg_level(j,:)=res(:,3); %the third line is lag angle
       end
    end
  end
  ua_bt(:,:)=ua_level; %the first line is amplitude
  ug_bt(:,:)=ug_level; %the third line is lag angle
  va_bt(:,:)=va_level; %the first line is amplitude
  vg_bt(:,:)=vg_level; %the third line is lag angle 
  za_bt(:,:)=za_level; %the first line is amplitude
  zg_bt(:,:)=zg_level; %the third line is lag angle   
  disp(['!!!!!! END '])

if ttide == 1
save([SaveLocation,'/res_uso_', month_file{m_select}, '_CVCTM.mat'], ...
     'ua_bt','ug_bt','latuo','lonuo','-v7.3');
save([SaveLocation,'/res_vse_', month_file{m_select}, '_CVCTM.mat'], ...
     'va_bt','vg_bt','latvo','lonvo','-v7.3');
save([SaveLocation,'/res_zoo_', month_file{m_select}, '_CVCTM.mat'], ...
     'za_bt','zg_bt','latpo','-v7.3');

if para == 1
    delete(gcp('nocreate'))
end
t1 = toc;

disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);
end

