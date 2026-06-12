clear;clc;close all
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/Spin_up/Grid
%%
load('Time_info_case.mat', 'SDtime','LDTRUN','time_index');
S_time = datenum(2013,12,01,0,0,0);
E_time = datenum(2013,12,31,23,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%%
load('Grid_info.mat','ke','weto_p','depto_grid','latp_grid','lonp_grid','ddpo_grid');
load('Grid_info_u.mat','dduo_grid');
load('Grid_info_v.mat','ddue_grid');
load('Grid_resolution.mat','dlxp','dlyp');
iw = 10;ie = 1;
jn = 10;js = 10;
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
dduo_grid = Exclude_sponge(iw,ie,jn,js,dduo_grid);
ddue_grid = Exclude_sponge(iw,ie,jn,js,ddue_grid);
ddpo_grid = Exclude_sponge(iw,ie,jn,js,ddpo_grid);

dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

ie = size(depto_grid,1);
je = size(depto_grid,2);

area = dlxp.*dlyp;
Volume = zeros(ie,je,ke);
for k = 2:ke
    Volume(:,:,k) = area.*(ddpo_grid(:,:,k));
end
Volume(weto_p==0)=0;


%      u     u     u     u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u  *  u  *  u  *  u
%   v  p  v  p  v  p  v  p  v 
%      u     u     u     u


ke_level = 80;
ssh_considered = 1;
UBT = zeros(ie+1,je); % SSS
VBT = zeros(ie,je+1); % SST
BT_KE_energy = zeros(t_e-t_s+1,1);
KE = zeros(1,t_e-t_s+1);
UOO = zeros(ie+1,je,ke_level); % SSS
VOE = zeros(ie,je+1,ke_level); % SSS

dduo_grid_ssh = zeros(ie+1,je,ke);  
ddue_grid_ssh = zeros(ie,je+1,ke);  
ddpo_grid_ssh = zeros(ie,je,ke);  
dduo_grid_ssh = dduo_grid;
ddue_grid_ssh = ddue_grid;
%% READ
Location = ['../'];
% save_Location_ssv = ['./SSV/'];
rou0 = 1025;
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
        ddpo_grid_ssh(:,:,1) = ddpo_grid(:,:,1) +  ZOO(:,:);
        Volume(:,:,1)  = area.* ddpo_grid_ssh(:,:,1);
    end

    UBT(:,:) = sum(UOO(:,:,:).*dduo_grid_ssh(:,:,1:ke_level),3)./sum(dduo_grid_ssh(:,:,1:ke_level),3);
    VBT(:,:) = sum(VOE(:,:,:).*ddue_grid_ssh(:,:,1:ke_level),3)./sum(ddue_grid_ssh(:,:,1:ke_level),3);

    uuu = orctm_uv_to_p(UBT,'u');
    vvv = orctm_uv_to_p(VBT,'v');

    Volume_2D  = sum(Volume,3);

    BT_KE_energy(t-t_s+1) = nansum(1025.*Volume_2D.*(uuu.^2+vvv.^2)./2,'all');  

    KE(t-t_s+1) = sum(rou0/2 .* Volume.*( ...
        ((UOO(1:1:end-1,:,:) + UOO(2:1:end,:,:))./2).^2 + ...
        ((VOE(:,1:1:end-1,:) + VOE(:,2:1:end,:))./2).^2   ),'all');
 
    disp(['LDTRUN = ',num2str(LDTRUN(t))])
end

save ./SST/BT_KE_Energy.mat BT_KE_energy KE -v7.3
