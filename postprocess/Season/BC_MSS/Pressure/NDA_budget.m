clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
for m_select = 1: 12
% m_select = 4;
SaveLocation = ['./',month_file{m_select}];
load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
load([SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
load([SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
load([SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');
% K: kilo 10^3
% M: mega 10^6
% G: giga 10^9
% T: tera 10^12
% P: peta 10^15
% E: exa 10^18
%%
addpath ../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
%%
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
dlxp = dlxp(select_indicex,select_indicey);
dlyp = dlyp(select_indicex,select_indicey);
%%
C(isnan(depto_grid)==1)=nan;
Div_F(isnan(depto_grid)==1)=nan;
R(isnan(depto_grid)==1)=nan;  

u_flux = Flux_x;
v_flux = Flux_y;
u_flux = u_flux.*depto_grid; % w/m
v_flux = v_flux.*depto_grid;
%%
load('NorthDakar_index.mat')

C_nda = C(select_indicex,select_indicey);
lon_nda  = lonp_grid(select_indicex,select_indicey);
lat_nda  = latp_grid(select_indicex,select_indicey);
dlxp_nda = dlxp(select_indicex,select_indicey);
dlyp_nda = dlyp(select_indicex,select_indicey);
depto_nda = depto_grid(select_indicex,select_indicey);
Fx_nda = u_flux(select_indicex,select_indicey);
Fy_nda = v_flux(select_indicex,select_indicey);
R_nda = R(select_indicex,select_indicey);
Div_F_nda = Div_F(select_indicex,select_indicey);
pcolor(lon_nda,lat_nda,C_nda);shading interp;colorbar;clim([-0.05 0.05])
%% UNITS: W
% First column: Energy generation
% Second column: West boundary energy flux 
% Third column: East boundary energy flux 
% Fourth column: North boundary energy flux 
% Fifth column: South boundary energy flux 
% Sixed column: Energy dissipation
% seventh column: Energy radiation

% W and E
Region_energy_M2(1,2) = nansum(Fx_nda(1,:).*dlyp_nda(1,:),'all');
Region_energy_M2(1,3) = nansum(Fx_nda(end,:).*dlyp_nda(end,:),'all');
% N and S
Region_energy_M2(1,4) = nansum(Fy_nda(:,1).*dlxp_nda(:,1),'all');
Region_energy_M2(1,5) = nansum(Fy_nda(:,end).*dlxp_nda(:,end),'all');

CC_nda = C_nda.*dlxp_nda.*dlyp_nda;
RR_nda = R_nda.*dlxp_nda.*dlyp_nda;
divergence_nda = Div_F_nda.*dlxp_nda.*dlyp_nda;


Region_energy_M2(1,1) = nansum(CC_nda, 'all');
Region_energy_M2(1,6) = nansum(RR_nda, 'all');
Region_energy_M2(1,7) = nansum(divergence_nda, 'all');

Region_energy_M2 =round(Region_energy_M2, 5, 'significant'); 
disp(['Radiation'])
Region_energy_M2(1,2) ... % W
 - Region_energy_M2(1,3)... % E
 - Region_energy_M2(1,4) ... % N
 + Region_energy_M2(1,5) ... % S

disp(['conversion'])
Region_energy_M2(1,1)

disp(['dissipation'])
Region_energy_M2(1,6)
Region_energy_M2(1,7)-Region_energy_M2(1,1)

save([SaveLocation,'/NDA_budget_', month_file{m_select}, '.mat'], ...
     'Region_energy_M2','-v7.3');
end