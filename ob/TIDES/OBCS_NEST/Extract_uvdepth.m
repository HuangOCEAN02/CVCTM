% ORCTM 水深设置:
% 水深低于1,设置为0,即陆地
% 最小水深: 设置为前两层厚度+1
% 最大水深: 设置为所有垂向分层厚度的和
%%
clear;clc;close all
ie_g=817;je_g=619;
ito = 2*ie_g + 3; jto = 2*je_g + 3;
% West: p:je_g; u:je_g, v:je_g+1
% East: p:je_g; u:je_g, v:je_g+1
% North: p:ie_g; u:ie_g+1, v:je_g
% South: p:ie_g; u:ie_g+1, v:je_g
api =  3.1415926;
aradtogra = 180/api;
Gila = ncread('../anta_region.nc','var54');
Giph = ncread('../anta_region.nc','var55');
depto = ncread('../anta_region.nc','var507');
Gila = Gila*aradtogra;Giph = Giph*aradtogra;
Gila = reshape(Gila,[ito,jto]);
Giph = reshape(Giph,[ito,jto]);

depto = reshape(depto,[ie_g,je_g]);
deuto = zeros(ie_g+1,je_g);
deute = zeros(ie_g,je_g+1);

for i = 2:ie_g
    for j = 1:je_g
      deuto(i,j)  = min([depto(i-1,j),depto(i,j)]);    
    end
end
% boundary depth
deuto(1,:) = depto(2,:);
deuto(ie_g+1,:) = depto(ie_g,:);


for i = 1:ie_g
    for j = 2:je_g
      deute(i,j)  = min([depto(i,j-1),depto(i,j)]);   
    end
end
% boundary depth
deute(:,1) = depto(:,2);
deute(:,je_g+1) = depto(:,je_g);

%% eta
clear lon lat
lon = Gila(1:2:ito,1:2:jto);
lat = Giph(1:2:ito,1:2:jto);
save E_MASK.mat lon lat depto 
%% uso
clear lon lat
lon = Gila(2:2:ito-1,1:2:jto);
lat = Giph(2:2:ito-1,1:2:jto);
save U_MASK.mat lon lat deuto Gila Giph
%% vse
clear lon lat
lon = Gila(1:2:ito,2:2:jto-1);
lat = Giph(1:2:ito,2:2:jto-1);
save V_MASK.mat lon lat deute Gila Giph