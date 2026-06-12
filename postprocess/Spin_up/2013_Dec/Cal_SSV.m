clear;clc;close all
% Model grid info.
addpath /gxfs_work/geomar/smomw557/BC_exp/Wind_forcing_exp/Spin_up/Grid
%%
load('Time_info_case.mat', 'SDtime','LDTRUN','time_index');
S_time = datenum(2013,12,25,0,0,0);
E_time = datenum(2013,12,31,23,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
%%
load('Grid_info.mat','ke','weto_p','depto_grid');
iw = 10;ie = 1;
jn = 10;js = 10;
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

load('Grid_info_u.mat','latu_grid');
load('Grid_info_v.mat','lonv_grid');

latu_grid  = Exclude_sponge(iw,ie,jn,js,latu_grid);
% lonu_grid  = Exclude_sponge(iw,ie,jn,js,lonu_grid);

% latv_grid  = Exclude_sponge(iw,ie,jn,js,latv_grid);
lonv_grid  = Exclude_sponge(iw,ie,jn,js,lonv_grid);


latpis_grid = (latu_grid(2:end-1,1:1:end-1)+latu_grid(2:end-1,2:1:end))/2.0; % dy
lonpis_grid = (lonv_grid(1:1:end-1,2:end-1)+lonv_grid(2:1:end,2:end-1))/2.0; % dx

f_lat = 2*pi/(86164)*sind(latpis_grid);


load('Grid_resolution.mat', 'dlxv')
load('Grid_resolution.mat', 'dlyu')
dlxv  = Exclude_sponge(iw,ie,jn,js,dlxv);
dlyu  = Exclude_sponge(iw,ie,jn,js,dlyu);


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
dlxvpsi = (dlxv(1:1:end-1,2:end-1)+dlxv(2:1:end,2:end-1))/2.0; % dy
dlyupsi = (dlyu(2:end-1,1:1:end-1)+dlyu(2:end-1,2:1:end))/2.0; % dx

uoo = zeros(ie-1,je); % dy
voe = zeros(ie,je-1); % dx

ssv = zeros(ie-1,je-1,t_e-t_s+1);  % votricity 
%% READ
Location = ['../'];
% save_Location_ssv = ['./SSV/'];

for t= t_s:1:t_e
    if (LDTRUN(t)<10)
          name_u = [Location,'uoo/UOO_0000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_p = [Location,'poo/POO_0000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_0000000',num2str(LDTRUN(t)),'.nc'];
     else if(LDTRUN(t) < 100)
          name_u = [Location,'uoo/UOO_000000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000000',num2str(LDTRUN(t)),'.nc'];
        % name_p = [Location,'poo/POO_000000',num2str(LDTRUN(t)),'.nc'];
        % name_r = [Location,'roo/ROO_000000',num2str(LDTRUN(t)),'.nc'];
       else if(LDTRUN(t) < 1000)
          name_u = [Location,'uoo/UOO_00000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_00000',num2str(LDTRUN(t)),'.nc'];
           % name_r = [Location,'roo/ROO_00000',num2str(LDTRUN(t)),'.nc'];
        else if(LDTRUN(t) < 10000)
          name_u = [Location,'uoo/UOO_0000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_0000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_0000',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_0000',num2str(LDTRUN(t)),'.nc'];           
          else if(LDTRUN(t) < 100000)
          name_u = [Location,'uoo/UOO_000',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_000',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_000',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_000',num2str(LDTRUN(t)),'.nc']; 
          else if(LDTRUN(t) < 1000000)
          name_u = [Location,'uoo/UOO_00',num2str(LDTRUN(t)),'.nc'];
          name_v = [Location,'voe/VOE_00',num2str(LDTRUN(t)),'.nc'];
           % name_p = [Location,'poo/POO_00',num2str(LDTRUN(t)),'.nc'];
           %  name_r = [Location,'roo/ROO_00',num2str(LDTRUN(t)),'.nc']; 
          end
          end
        end
      end
     end
    end

    

    uoo(:,:) = ncread(name_u,'UOO',...
                   [iw+1+1 jn+1 1],[ie-1,je,1]);     
    voe(:,:) = ncread(name_v,'VOE',...
                   [iw+1 jn+1+1 1],[ie,je-1,1]);

    ssv(:,:,t-t_s+1) = (voe(2:1:end,:)-voe(1:1:end-1,:))./dlxvpsi(:,:)...
        - (uoo(:,1:1:end-1)-uoo(:,2:1:end))./dlyupsi(:,:);

    % dvdx = 

     % 
     % disp([datestr(SDtime(t))])
     % eval(['save ',Save_Location,'zao_',datestr(SDtime(t),30),'.mat',' zao'])

     disp(['LDTRUN = ',num2str(LDTRUN(t))])
end

save ./SSV/Latlonis.mat lonpis_grid latpis_grid -v7.3
save ./SSV/SSV_timeseries.mat ssv -v7.3

