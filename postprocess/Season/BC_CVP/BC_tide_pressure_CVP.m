clear;clc;close all
%% T-tide using least square method for pressure
tic
ttide = 1;     % whether use the t_tide.
para  = 1;     % whether use the parallel.
maxNumCompThreads = 32;
if para == 1
   parpool ('local',maxNumCompThreads)
end
%% Please selct the month[m_select]
addpath ../../Grid/
for m_select = 10:12
idx = ceil((1:12)/3);   
month_dir = {'JFM','AMJ','JAS','OND'};
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
group_per_month = month_dir(idx);
load(['Time_info_',month_file{m_select},'.mat'])
Location = ['../../../',group_per_month{m_select},'/'];
SaveLocation =['./Pressure'];
if ttide == 1
   addpath /gxfs_home/geomar/smomw557/Model_H2/t_tide_v1.3beta
   start_time = time_index_range(1,:);
   t_freq = 0.0805;
   t_name = ['M2  '];
end
%% Model GRID & background stratification 
load('Grid_info.mat','ke','depto_grid','weto_p','latp_grid','lonp_grid','zzout','ddpo_grid',...
    'bottom_index');
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
 ddpo_grid  = Exclude_sponge(iw,ie,jn,js,ddpo_grid);
    weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
 latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
 lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
     zzout  = Exclude_sponge(iw,ie,jn,js,zzout);
bottom_index = Exclude_sponge(iw,ie,jn,js,bottom_index);

ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);
%% CVP area
load('CapeVerdeplateau_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
ddpo_grid    = ddpo_grid(select_indicex,select_indicey,:);
weto_p       = weto_p(select_indicex,select_indicey,:);
latp_grid    = latp_grid(select_indicex,select_indicey);
lonp_grid    = lonp_grid(select_indicex,select_indicey);
zzout        = zzout(select_indicex,select_indicey,:);
bottom_index = bottom_index(select_indicex,select_indicey);

ie = size(depto_grid,1);
je = size(depto_grid,2);
%%
ddpo_grid= reshape(ddpo_grid,ie*je,ke);
zzout  = reshape(zzout,ie*je,ke);
weto_p = reshape(weto_p,ie*je,ke);
bottom_index= reshape(bottom_index,ie*je,1);
depto_grid = reshape(depto_grid,ie*je,1); 
latpo = reshape(latp_grid,[ie*je,1]);
lonpo = reshape(lonp_grid,[ie*je,1]);
%%
pa_bc =  zeros(ie*je,ke+1);
pg_bc =  zeros(ie*je,ke+1);
G = 9.81;
for k = 1:ke+1
    fprintf('!!!!!! STRAT --> Vertical Level k = %d\n', k);
    p_bc_time = zeros(ie*je,tee);
    for t= 1:1:tee % Time
        tag = sprintf('%08d', LDTRUN_range(t));
        name_r = [Location,'roo/ROO_',tag,'.nc'];
        name_z = [Location,'zoo/ZOO_',tag,'.nc'];
        roo = ncread(name_r,'ROO',...
                     [iw+1 jn+1 1],[ie_global,je_global,ke]);
        zoo = ncread(name_z,'ZOO',...
                     [iw+1 jn+1],[ie_global,je_global]);
        
        % using the MSS index
        roo = roo(select_indicex,select_indicey,:);
        zoo = zoo(select_indicex,select_indicey);

        roo = reshape(roo,[ie*je,ke]);
        zoo = reshape(zoo,[ie*je,1]);
        for ii = 1:ie*je
            
            % Water grid & at the k-level 
            if (weto_p(ii,1)~=0 && k<= bottom_index(ii)+1 && bottom_index(ii)>0)
                poo = zeros(bottom_index(ii)+1, 1);
                
               % convert to hydrostatic pressure
       
                % surface k =1
                poo(1) = G.*(zzout(ii,1)+zoo(ii)).*roo(ii,1); % barotropic level
            
                % internal
                for vi = 2:bottom_index(ii)
                    poo(vi) = poo(vi-1) + G.*(zzout(ii,vi) - zzout(ii,vi-1)) ...
                        .*(roo(ii,vi)+roo(ii,vi-1))/2.0;
                end
            
                % bottom  
                poo(bottom_index(ii)+1) = poo(bottom_index(ii)) + ...
                    G.*(depto_grid(ii) - zzout(ii,bottom_index(ii))).*roo(ii,bottom_index(ii));
    
                pbar =  sum(poo(1:bottom_index(ii)) .* ddpo_grid(ii,1:bottom_index(ii))' ) / depto_grid(ii);
                % decompose the pressure work at k level
                p_bc_time(ii,t)  = poo(k) - pbar;
            else
                p_bc_time(ii,t) = 0;
            end

        end
end % Time for bc pressure

mask = (bottom_index > 0) & (k<=bottom_index+1);
pa_level = zeros(ie*je,1);
pg_level = zeros(ie*je,1);
if ttide == 1
     resp = zeros([4 5]);
     parfor i = 1:(ie*je)
       sp = p_bc_time(i,:);
       if (mask(i)~=0)  % masko(ij) == 0
%% Pressure
         [~,~,resp]=t_tide(sp,'start time',start_time,'interval',1,'latitude',latpo(i),...
             'output','none','rayleigh', ['M2'], 'error','wboot');
         pa_level(i,:)=resp(1,1); %the first line is amplitude
         pg_level(i,:)=resp(1,3); %the third line is lag angle
         disp(['the current processing Num of Pressure: ',num2str(i)]); 
       end
     end
end
pa_bc(:,k)=pa_level; %the first line is amplitude
pg_bc(:,k)=pg_level; %the third line is lag angle  
disp(['!!!!!! END --> Vertical Level k = ',num2str(k)])
end % Vertical level

if ttide == 1
    save([SaveLocation,'/res_pbc_', month_file{m_select}, '_CVCTM.mat'], ...
         'pa_bc','pg_bc','t_name','-v7.3');
end
end

t1 = toc;
if ttide == 1
    disp(['Using t_tide, the time passes by: ',num2str(t1),' s']);
end

if para == 1
    delete(gcp('nocreate'))
end
clearvars -except  p_bc_level latpo lonpo
