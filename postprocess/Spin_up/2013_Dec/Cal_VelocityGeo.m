clear;clc;close all
% Model grid info.
% addpath /Users/josephhuang/Desktop/workingplace/风场试验/Spin_up/2011/UP
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/Spin_up/Grid
%%
load('Time_info_case.mat', 'SDtime','LDTRUN','time_index');
S_time = datenum(2013,12,25,0,0,0);
E_time = datenum(2013,12,31,23,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%%
load('Grid_info.mat','ke','weto_p','depto_grid','latp_grid','lonp_grid');
load('Grid_info_u.mat','dduo_grid');
load('Grid_info_v.mat','ddue_grid');
iw = 10;ie = 1;
jn = 10;js = 10;
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
dduo_grid = Exclude_sponge(iw,ie,jn,js,dduo_grid);
ddue_grid = Exclude_sponge(iw,ie,jn,js,ddue_grid);
% load('Grid_info_u.mat','latu_grid');
% load('Grid_info_v.mat','lonv_grid');

% latu_grid  = Exclude_sponge(iw,ie,jn,js,latu_grid);
% lonu_grid  = Exclude_sponge(iw,ie,jn,js,lonu_grid);

% latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);
% lonv_grid  = Exclude_sponge(iw,ie,jn,js,lonv_grid);


% latpis_grid = (latu_grid(2:end-1,1:1:end-1)+latu_grid(2:end-1,2:1:end))/2.0; % dy
% lonpis_grid = (lonv_grid(1:1:end-1,2:end-1)+lonv_grid(2:1:end,2:end-1))/2.0; % dx
% 
% f_lat = 2*pi/(86164)*sind(latpis_grid);

% load('Grid_resolution.mat', 'dlxu')
% load('Grid_resolution.mat', 'dlyv')
% dlxv  = Exclude_sponge(iw,ie,jn,js,dlxv);
% dlyu  = Exclude_sponge(iw,ie,jn,js,dlyu);

% dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
% dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);

ie = size(depto_grid,1);
je = size(depto_grid,2);


%      u     u     u     u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u     u     u     u

% differences should be same size of matrix
% dlxvpsi = (dlxv(1:1:end-1,2:end-1)+dlxv(2:1:end,2:end-1))/2.0; % dy
% dlyupsi = (dlyu(2:end-1,1:1:end-1)+dlyu(2:end-1,2:1:end))/2.0; % dx

ke_level = 30;
ssh_considered = 1;
Ugeo = zeros(ie+1,je,t_e-t_s+1); % SSS
Vgeo = zeros(ie,je+1,t_e-t_s+1); % SST
UOO = zeros(ie+1,je,ke_level); % SSS
VOE = zeros(ie,je+1,ke_level); % SSS

dduo_grid_ssh = zeros(ie+1,je,ke);  
ddue_grid_ssh = zeros(ie,je+1,ke);  

dduo_grid_ssh = dduo_grid;
ddue_grid_ssh = ddue_grid;
%% READ
Location = ['../'];
% save_Location_ssv = ['./SSV/'];

for t= t_s:1:t_e
    if (LDTRUN(t)<10)
          name_u = [Location,'uoo/UOO_0000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000000',num2str(LDTRUN(t)),'.nc'];
        name_t = [Location,'tho/THO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_s = [Location,'sao/SAO_0000000',num2str(LDTRUN(t)),'.nc'];
        name_z = [Location,'zoo/ZOO_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
          name_u = [Location,'uoo/UOO_000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000000',num2str(LDTRUN(t)),'.nc'];
        name_t = [Location,'tho/THO_000000',num2str(LDTRUN(t)),'.nc'];
        name_s = [Location,'sao/SAO_000000',num2str(LDTRUN(t)),'.nc'];
        name_z = [Location,'zoo/ZOO_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
          name_u = [Location,'uoo/UOO_00000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00000',num2str(LDTRUN(t)),'.nc'];
           name_t = [Location,'tho/THO_00000',num2str(LDTRUN(t)),'.nc'];
           name_s = [Location,'sao/SAO_00000',num2str(LDTRUN(t)),'.nc'];
           name_z = [Location,'zoo/ZOO_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
          name_u = [Location,'uoo/UOO_0000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000',num2str(LDTRUN(t)),'.nc'];
           name_t = [Location,'tho/THO_0000',num2str(LDTRUN(t)),'.nc'];
            name_s = [Location,'sao/SAO_0000',num2str(LDTRUN(t)),'.nc']; 
            name_z = [Location,'zoo/ZOO_0000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 100000)
          name_u = [Location,'uoo/UOO_000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000',num2str(LDTRUN(t)),'.nc'];
           name_t = [Location,'tho/THO_000',num2str(LDTRUN(t)),'.nc'];
            name_s = [Location,'sao/SAO_000',num2str(LDTRUN(t)),'.nc']; 
            name_z = [Location,'zoo/ZOO_000',num2str(LDTRUN(t)),'.nc'];
          else if(LDTRUN(t) < 1000000)
          name_u = [Location,'uoo/UOO_00',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00',num2str(LDTRUN(t)),'.nc'];
           name_t = [Location,'tho/THO_00',num2str(LDTRUN(t)),'.nc'];
            name_s = [Location,'sao/SAO_00',num2str(LDTRUN(t)),'.nc'];
            name_z = [Location,'zoo/ZOO_00',num2str(LDTRUN(t)),'.nc'];
          end
          end
        end
      end
     end
    end

   

    UOO(:,:,1:ke_level) = ncread(name_u,'UOO',...
                   [iw+1, jn+1,1],[ie+1,je,ke_level]);  

    VOE(:,:,1:ke_level) = ncread(name_v,'VOE',...
                   [iw+1, jn+1, 1],[ie,je+1,ke_level]);     
   
    %%
    if ssh_considered 
        clear ZOO
        ZOO(:,:) = ncread(name_z,'ZOO',...
                       [iw+1,jn+1],[ie,je]); 
        dduo_grid_ssh(2:ie+1,:,1) = dduo_grid(2:ie+1,:,1) +  ZOO(:,:);
        ddue_grid_ssh(:,2:je+1,1) = ddue_grid(:,2:je+1,1) +  ZOO(:,:);
    end

    Ugeo(:,:,t-t_s+1) = sum(UOO(:,:,:).*dduo_grid_ssh(:,:,1:ke_level),3)./sum(dduo_grid_ssh(:,:,1:ke_level),3);
    Vgeo(:,:,t-t_s+1) = sum(VOE(:,:,:).*ddue_grid_ssh(:,:,1:ke_level),3)./sum(ddue_grid_ssh(:,:,1:ke_level),3);
    

     disp(['LDTRUN = ',num2str(LDTRUN(t))])
end

save ./SST/UGEO_Velocity.mat Ugeo lonp_grid latp_grid -v7.3
save ./SST/VGEO_Velocity.mat Vgeo lonp_grid latp_grid -v7.3
