clear;clc;close all
%% Calculate the ssh without tidal components.
tic
ttide = 1;     % whether use the t_tide.
para  = 1;     % whether use the parallel.
maxNumCompThreads = 32;
if para == 1
   parpool ('local',maxNumCompThreads)
end
%% Using Least-square methods to extract the subtidal signal.
%% Export the Two-dimensional fields
addpath ../../Grid/
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
if ttide == 1
   addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
   % Extranct  tide components asap
   cons_use = {'M2','S2','N2','K2','K1','O1','M4','MS4','MN4','M6'};
    outdir = './BT_detide';
    if ~exist(outdir, 'dir')
        mkdir(outdir);
    end
    file_uso   = fullfile(outdir, 'uso_detide_cvp.nc');
    file_vse   = fullfile(outdir, 'vse_detide_cvp.nc');
    file_month = fullfile(outdir, 'Barotropic_monthlymean_CVP.nc');
    if exist(file_uso,'file')
        delete(file_uso)
    end
    if exist(file_vse,'file')
        delete(file_vse)
    end
    if exist(file_month,'file')
        delete(file_month)
    end
end
%%
load('Grid_info.mat','ke','latp_grid','depto_grid');
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
%% MSS area
load('CapeVerdeplateau_index.mat')

select_indicexu = [select_indicex;select_indicex(end)+1];
select_indiceyv = [select_indicey,select_indicey(end)+1];
depto_grid = depto_grid(select_indicex,select_indicey);
latu_grid = latu_grid(select_indicexu,select_indicey);
latv_grid = latv_grid(select_indicex,select_indiceyv);
weto_u = weto_u(select_indicexu,select_indicey,:);
weto_v = weto_v(select_indicex,select_indiceyv,:);


ie = size(depto_grid,1);
je = size(depto_grid,2);

latuo = reshape(latu_grid,[(ie+1)*je,1]);
latvo = reshape(latv_grid,[ie*(je+1),1]);
mask_u   = reshape(weto_u(:,:,1),[(ie+1)*je,1]);
mask_v   = reshape(weto_v(:,:,1),[ie*(je+1),1]);

time =[];
for m_select=1:12
    load(['Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    t_s(m_select) = length(time)+1;
    time = [time,SDtime_range];
    t_e(m_select)  = length(SDtime_range);
end
tee_year = length(time);

%% saveing data
ijeu = (ie+1)*je;
nccreate(file_uso,'uso_detide','Dimensions',{'xy',ijeu,'t',tee_year},'Datatype','single');
uso_time= zeros(ijeu,tee_year); 
ijev = ie*(je+1);
nccreate(file_vse,'vse_detide','Dimensions',{'xy',ijev,'t',tee_year},'Datatype','single');
vse_time= zeros(ijev,tee_year); 
%% Read data
for m_select = 1:12
    load(['Time_info_',month_file{m_select},'.mat'])
    Location = ['../../../',group_per_month{m_select},'/'];
    disp(['month = ',datestr(SDtime_range(1))]);
    if m_select == 1
         start_time = time_index_range(1,:);
    end
    if m_select==2
        tee = 672; 
    end
    for t= 1:1:tee % time
        % 1) Read data at the time t
        tag = sprintf('%08d', LDTRUN_range(t));
        name_u = [Location,'uso/USO_',tag,'.nc'];
        uso = ncread(name_u,'USO',...
                                [iw+1 jn+1 1],[ie_global+1,je_global, 1]);
        uso = squeeze(uso);
        uso_time(:,t_s(m_select) + t-1) = reshape(uso(select_indicexu,select_indicey),[ijeu,1]);

        name_v = [Location,'vse/VSE_',tag,'.nc'];
        vse = ncread(name_v,'VSE',...
                                [iw+1 jn+1 1],[ie_global,je_global+1, 1]);
        vse = squeeze(vse);
        vse_time(:,t_s(m_select) + t-1) = reshape(vse(select_indicex,select_indiceyv),[ijev,1]);


    end % time
end
%%
disp(['!!!!!! STRAT UUU --> Time =',datestr(start_time)])
u_subtide_level = zeros(ijeu,tee_year);
if ttide == 1
    parfor j = 1 : ijeu
       su = uso_time(j,:);
       if (mask_u(j)~=0)  % masko(ij) == 0
          [cn_u,cu_f,tc_u] = t_tide(su, 'start time', start_time, 'interval',1, ...
                               'latitude', latuo(j), 'output','none', 'error','linear','synthesis',0);
          utide_removed = t_predic(time, cn_u, cu_f, tc_u, 'latitude', latuo(j));  
          u_subtide_level(j,:) = su - utide_removed; % detide!!!
          % disp(['the current processing Num of uso: ',num2str(j)]); 
       end
    end
end
ncwrite(file_uso,'uso_detide',u_subtide_level);

%%
disp(['!!!!!! STRAT VVV --> Time =',datestr(start_time)])
v_subtide_level = zeros(ijev,tee_year);
if ttide == 1
    parfor j = 1 : ijev
       sv = vse_time(j,:);
       if (mask_v(j)~=0)  % masko(ij) == 0
          [cn_v,cv_f,tc_v] = t_tide(sv, 'start time', start_time, 'interval',1, ...
                               'latitude', latvo(j), 'output','none', 'error','linear','synthesis',0);
          vtide_removed = t_predic(time, cn_v, cv_f, tc_v, 'latitude', latvo(j));  
          v_subtide_level(j,:) = sv - vtide_removed; % detide!!!
          % disp(['the current processing Num of vse: ',num2str(j)]); 
       end
    end
end
ncwrite(file_vse,'vse_detide',v_subtide_level);


%% monthly mean
uso_month = zeros(ijeu,12);
vse_month = zeros(ijev,12);
for m_select=1:12
    uso_month(:,m_select) = mean(u_subtide_level(:,[t_s(m_select):t_s(m_select)+t_e(m_select)-1]),2,'omitmissing');
    vse_month(:,m_select) = mean(v_subtide_level(:,[t_s(m_select):t_s(m_select)+t_e(m_select)-1]),2,'omitmissing');
 end

nccreate(file_month,'u_circulation_month','Dimensions',{'xy_u',ijeu,'t',m_select},'Datatype','single');
nccreate(file_month,'v_circulation_month','Dimensions',{'xy_v',ijev,'t',m_select},'Datatype','single');
ncwrite(file_month,'u_circulation_month',uso_month);
ncwrite(file_month,'v_circulation_month',vse_month);

disp(['Saving Barotropic_monthlymean_CVP.nc ...']); 


if para == 1
    delete(gcp('nocreate'))
end

t1 = toc;
disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);
