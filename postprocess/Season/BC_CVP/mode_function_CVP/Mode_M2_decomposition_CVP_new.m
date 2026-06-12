clear;clc;close all
tic
%% Monthly average based on 3-year
addpath ../../../Grid/
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
load('Grid_info.mat','ke','weto_p','depto_grid','zzout','Depth','Depth_w','DZW','latp_grid','zzout_w');
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
zzout = Exclude_sponge(iw,ie,jn,js,zzout);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
latp_grid = Exclude_sponge(iw,ie,jn,js,latp_grid);
zzout_w= Exclude_sponge(iw,ie,jn,js,zzout_w);
SaveLocation = './Mode_function/';
%%
load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
zzout = zzout(select_indicex,select_indicey,:);
zzout_w  = zzout_w(select_indicex,select_indicey,:);
latp_grid = latp_grid(select_indicex,select_indicey);
ie = size(depto_grid,1);
je = size(depto_grid,2);

%% add functions
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/2014_tide/post_process/Season/Modal_M2_Fun/IT_funs
%%
sigma = 2*pi/(12.4206012*3600); % (rad/s)
mode = 10;
back2orignal = false;
% N2_NDA = zeros(ke,12);
% Monthly average based on 3-year
Nsquare_MSS_2014 = zeros(ie,je,ke,12);
for m_select = 1:12
    load(['./Stratification/ave_Nsquare_',month_file{m_select},'_from_ts_CVP.mat'],'Nsquare_month');
    Nsquare_MSS_2014(:,:,:,m_select) = Nsquare_month;
end
Nsquare_MSS = (Nsquare_MSS_2014);
for m_select = 1:12
    %%
    disp(['Month=',num2str(m_select)])
    Modal = zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2));
    wmodes = zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2),ke,mode);
    wzmodes = zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2),ke,mode);
    zwmodes= zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2),ke);
    cemodes = zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2),mode);
    Nsqmodes = zeros(size(Nsquare_MSS,1),size(Nsquare_MSS,2),ke);
    for i = 1:size(Nsquare_MSS,1)
        for j = 1:size(Nsquare_MSS,2)
            if (weto_p(i,j,1)==1)
                clear zw zu zm zz NsqNsq pres Wm Ce Pm Um Bm Cp Cg
                ke_level = sum(weto_p(i,j,:));
                %
                % [zz,NsqNsq] = modify_N2(depto_grid(i,j),squeeze(zzout_w(i,j,2:ke_level))', ...
                %     squeeze(Nsquare_MSS(i,j,1:ke_level))',squeeze(zzout(i,j,1:ke_level))'); 
                %
                zw = squeeze(zzout_w(i,j,1:ke_level+1))';
                zu = squeeze(zzout(i,j,1:ke_level))';
                Nsq = squeeze(Nsquare_MSS(i,j,1:ke_level,m_select))';
                [zz,NsqNsq] = Vertical_N2(zw,Nsq,zu);
                
                 nz = length(zz); % nz<=ke+1
                 %%
                 if nz <= mode+2
                     [zz,NsqNsq] = refine_Nsquare(zz,NsqNsq,mode+2);
                      nz = length(zz); % new nz = mode
                 end
                 %%
                 % Mode decomposition based on the Buoyancy frequecny (NsqNsq,zz)
                 [Wm,~,Ce] = dynmodes(NsqNsq,zz,mode);
                 % Normalization of Vertical functions (Wm)
                 % Calculate the vertical derivatives (Wmdz)
                 [Wm] = orthogonal_normalize_new(Wm,NsqNsq,zz,Ce);
                 [Wmdz] = dynmodes_1st(Wm,zz);
                 if length(Ce) > mode
                     nm = mode;
                 else
                     nm = length(Ce);
                 end
	             Modal(i,j) = nm;
                 zwmodes(i,j,1:nz) = zz;
                 cemodes(i,j,1:nm) = Ce(1:nm);
   		 % zmodes(i,j,1:nz-1) = 0.5*(zz(1:nz-1) + zz(2:nz));  % Mid-points of each verical cell.
                 if back2orignal==true
                     wmodes(i,j,1:ke_level,1:nm) = Back2Depth(real(Wm(:,1:nm)),zz,zu'); 
                 else
                     wmodes(i,j,1:nz,1:nm) = real(Wm(:,1:nm)); 
                     wzmodes(i,j,1:nz,1:nm) = real(Wmdz(:,1:nm)); 
                     Nsqmodes(i,j,1:nz) = NsqNsq(:); 
                 end
            end
        end
    end

      disp(['End Month = ',month_file{m_select}])

      %% M2_Modal_Vertical_
      nc_vertical = [SaveLocation,'M2_Modal_eigenfunction_',month_file{m_select},'_CVP.nc'];
      if exist(nc_vertical,'file'); delete(nc_vertical); end
      sz = size(wmodes);
      nccreate(nc_vertical,'wmodes','Dimensions',{'i',sz(1),'j',sz(2),'k',sz(3),'m',sz(4)});
      nccreate(nc_vertical,'wzmodes','Dimensions',{'i',sz(1),'j',sz(2),'k',sz(3),'m',sz(4)});
      nccreate(nc_vertical,'Modal','Dimensions',{'i',sz(1),'j',sz(2)});
      nccreate(nc_vertical,'zwmodes','Dimensions',{'i',sz(1),'j',sz(2),'k',sz(3)});
      nccreate(nc_vertical,'Nsqmodes','Dimensions',{'i',sz(1),'j',sz(2),'k',sz(3)});
      ncwrite(nc_vertical,'wmodes',wmodes);
      ncwrite(nc_vertical,'wzmodes',wzmodes);
      ncwrite(nc_vertical,'Modal',Modal);
      ncwrite(nc_vertical,'zwmodes',zwmodes);
      ncwrite(nc_vertical,'Nsqmodes',Nsqmodes);


      nc_speed = [SaveLocation,'M2_Modal_eigenspeed_',month_file{m_select},'_CVP.nc'];
      if exist(nc_speed,'file'); delete(nc_speed); end
      sz = size(cemodes);
      nccreate(nc_speed,'ce','Dimensions',{'i',sz(1),'j',sz(2),'m',sz(3)});
      ncwrite(nc_speed,'ce',cemodes);      
end

t1 = toc;
disp(['M2 Modal Decomposition, the time passes by: ',num2str(t1),' s']);
