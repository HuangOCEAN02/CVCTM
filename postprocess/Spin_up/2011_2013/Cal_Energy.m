clear;clc;close all
% Model grid info.
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/Spin_up/Grid
%% Time
load('Time_info_case.mat', 'SDtime','LDTRUN','time_index');
S_time = datenum(2013,07,04,0,0,0);
E_time = datenum(2013,12,31,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%% Grid
load('Grid_info.mat','ke','weto_p','depto_grid','ddpo_grid');
load('Grid_resolution.mat','dlxp','dlyp');
iw = 10;ie = 1;
jn = 10;js = 10;
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);

ie = size(depto_grid,1);
je = size(depto_grid,2);
area = dlxp.*dlyp;
Volume = zeros(ie,je,ke);
for k = 1:ke
    Volume(:,:,k) = area.*(ddpo_grid(:,:,k));
end
Volume(weto_p==0)=0;


%% Variables
KE = zeros(1,t_e-t_s+1);
%PE = zeros(1,t_e-t_s+1);

uoo = zeros(ie+1,je,ke);
voe = zeros(ie,je+1,ke);
%zoo = zeros(ie,je);

rou0 = 1025;
g = 9.81;
%% READ
Location = ['../'];
% save_Location_ssv = ['./SSV/'];

for t= t_s:1:t_e
    if (LDTRUN(t)<10)
          name_u = [Location,'uoo/UOO_0000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000000',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
          name_u = [Location,'uoo/UOO_000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000000',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
          name_u = [Location,'uoo/UOO_00000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00000',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
          name_u = [Location,'uoo/UOO_0000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_0000',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_0000',num2str(LDTRUN(t)),'.nc'];           
          else if(LDTRUN(t) < 100000)
          name_u = [Location,'uoo/UOO_000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_000',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_000',num2str(LDTRUN(t)),'.nc']; 
          else if(LDTRUN(t) < 1000000)
          name_u = [Location,'uoo/UOO_00',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00',num2str(LDTRUN(t)),'.nc'];
          name_z = [Location,'zoo/ZOO_00',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_00',num2str(LDTRUN(t)),'.nc']; 
          end
          end
        end
      end
     end
    end

    

    uoo(:,:,:) = ncread(name_u,'UOO',...
                   [iw+1 jn+1 1],[ie+1,je,ke]);     
    voe(:,:,:) = ncread(name_v,'VOE',...
                   [iw+1 jn+1 1],[ie,je+1,ke]);
%    zoo(:,:)   =  ncread(name_z,'ZOO',...
%                   [iw+1 jn+1],[ie,je]);

    KE(t-t_s+1) = sum(rou0/2 .* Volume.*( ...
        ((uoo(1:1:end-1,:,:) +uoo(2:1:end,:,:))./2).^2 + ...
        ((voe(:,1:1:end-1,:) +voe(:,2:1:end,:))./2).^2   ),'all');
    
%    PE(t-t_s+1) = nansum(rou0.* g.*zoo(:,:),'all');
    disp(['LDTRUN = ',num2str(LDTRUN(t))])
end

save ./PE_KE/Model_Energy_timeseries.mat KE
