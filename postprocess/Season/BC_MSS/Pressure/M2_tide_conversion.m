clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
for m_select = 1: 12
SaveLocation = ['./',month_file{m_select}];
load(['../../Velocity/res_uso_', month_file{m_select}, '_CVCTM.mat']);
load(['../../Velocity/res_vse_', month_file{m_select}, '_CVCTM.mat']);
uam = ua_bt;uph = ug_bt;
vam = va_bt;vph = vg_bt;

load(['res_pbc_', month_file{m_select}, '_CVCTM.mat']);
pa = pa_bc(:,:);
pg = pg_bc(:,:);
%%
addpath ../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','bottom_index');
load('Grid_resolution.mat', 'dlyv','dlxu');

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);

bottom_index =  Exclude_sponge(iw,ie,jn,js,bottom_index);

dlxu  = Exclude_sponge(iw+1,ie,jn,js,dlxu);
dlyv  = Exclude_sponge(iw,ie,jn+1,js,dlyv);


ie_global = size(depto_grid,1);
je_global = size(depto_grid,2);

uam = reshape(uam,[ie_global+1,je_global]);
vam = reshape(vam,[ie_global,je_global+1]);
uph = reshape(uph,[ie_global+1,je_global]);
vph = reshape(vph,[ie_global,je_global+1]);

%%
load('CoastalDakar_index.mat')
select_indicexu = [select_indicex(1)-1;select_indicex];
select_indiceyv = [select_indicey(1)-1,select_indicey];

weto_p       = weto_p(select_indicex,select_indicey,:);

depto_grid   = depto_grid(select_indicex,select_indicey);

bottom_index  = bottom_index(select_indicex,select_indicey);

dlxu = dlxu(select_indicex,select_indicey);
dlyv = dlyv(select_indicex,select_indicey);

uam = uam(select_indicexu,select_indicey);
vam = vam(select_indicex,select_indiceyv);
uph = uph(select_indicexu,select_indicey);
vph = vph(select_indicex,select_indiceyv);

ie = size(depto_grid,1);
je = size(depto_grid,2);

pa = reshape(pa,[ie,je,ke+1]); 
pg = reshape(pg,[ie,je,ke+1]); 
%% wbt
C = zeros(ie,je);
% depto_grid(539,405) = nanmean(depto_grid(538:540,404:406),'all');

[dHy,dHx] = gradient(-depto_grid);
dHx = dHx./dlxu;
dHy = -dHy./dlyv;

for i = 1 : ie
    for j = 1 : je
        if weto_p(i,j,1)~=0
        % C(i,j) = (1/2) * pa(i,j,bottom_index(i,j)) * ((uam(i,j)+uam(i+1,j))/2.0) * ...
        %     cosd(((uph(i,j)+uph(i+1,j))/2.0) - pg(i,j,bottom_index(i,j))) * ...
        %     dHx(i,j) + ...
        %         (1/2) * pa(i,j,bottom_index(i,j)) * ((vam(i,j)+vam(i,j+1))/2.0) * ...
        %     cosd(((vph(i,j)+vph(i,j+1))/2.0) - pg(i,j,bottom_index(i,j))) * ...
        %     dHy(i,j);

        C(i,j) = (1/2) * pa(i,j,bottom_index(i,j)+1) * ((uam(i,j)+uam(i+1,j))/2.0) * ...
            cosd(((uph(i,j)+uph(i+1,j))/2.0) - pg(i,j,bottom_index(i,j)+1)) * ...
            dHx(i,j) + ...
                (1/2) * pa(i,j,bottom_index(i,j)+1) * ((vam(i,j)+vam(i,j+1))/2.0) * ...
            cosd(((vph(i,j)+vph(i,j+1))/2.0) - pg(i,j,bottom_index(i,j)+1)) * ...
            dHy(i,j);
        end
    end
end

% C(539,405) = nanmean(C(538:540,404:406),'all');

save([SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'], ...
     'C','-v7.3');
end
%%
