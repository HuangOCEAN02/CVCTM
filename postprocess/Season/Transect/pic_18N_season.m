clear;clc;close all
% This is for model Validation
load("Along_shore_Temp_ThreeYears.mat")
load('Along_shore_velocity_ThreeYears.mat')
load('NCV_bright.mat')
load('BlueDarkRed18.mat');
load('MPL_RdYlBu_r.mat');
load('NCV_jaisnd.mat');
load('MPL_bwr.mat');
load('NCV_blue_red.mat');
load('BlRe.mat');
%%
addpath ../../Grid/
load('Grid_info.mat','ke','lonp_grid','latp_grid','depto_grid','weto_p','zzout','bottom_index','ddpo_grid');
% load('Grid_info_v.mat','latv_grid','lonv_grid','deute_grid','weto_v','zzout_v')
iw = 10;ie = 1;
jn = 10;js = 10;

index_j = 84; % global

lonp_18(:) = lonp_grid(iw+1:end,index_j); 
zzout_18(:,:) = zzout(iw+1:end,index_j,:);
weto_p18(:,:) =  weto_p(iw+1:end,index_j,:);

zzout_18(weto_p18==0)=nan;

depto_18(:)  = depto_grid(iw+1:end,index_j);

mask = zeros(size(zzout_18));
mask(:,:) = 1 ;
mask(isnan(zzout_18))=0;


ie = size(zzout_18,1);
je = size(zzout_18,2);

XX_p = zeros(ie,je);

for j = 1:je
    XX_p(:,j) =  lonp_18(:);
end
%% Mesh grid
XX_p = zeros(ie,je+2);
ZZ_p = zeros(ie,je+2);
THO  = zeros(ie,je+2);
VOE = zeros(ie,je+2);
for i = 1:ie
   XX_p(i,:) = lonp_18(i);
end

VOE_upwelling = mean(vke_upwelling,2);
VOE_relaxation = mean(vke_relaxation,2);

VOE_relaxation(weto_p18==0)=nan;
VOE_upwelling(weto_p18==0)=nan;

for i = 1:ie
    if mask(i,1)~=0
        [THO(i,:),ZZ_p(i,:)] = Fillcolumn(zzout_18(i,:),tho_upwelling(i,:),depto_18(i));
        [VOE(i,:),~] = Fillcolumn(zzout_18(i,:),VOE_upwelling(i,:),depto_18(i));
    end
end

figure(1);clf;set(gcf,'color','w');set(gcf,'position',[10 20 1200 380])
F1 = axes('position',[0.1 0.10 0.39 0.8]);


area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .4],'BaseValue',max(depto_18),'linewidth',2.0);hold on
% xlim([16.175 20]);ylim([0, 3500]);

xlim([16.08 17.5]);ylim([0 500]);
    
pcolor(abs(XX_p),ZZ_p,VOE);shading interp;
colormap(NCV_blue_red);hold on;
clim([-0.25 0.25]);
% cbarrow
[c,h]=contour(abs(XX_p),ZZ_p,THO,[11:1:30],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
%title(['Upwelling seasonal mean'],'fontname','Arial',...
%        'fontweight','bold','fontsize',22)
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold');
set(gca,'Layer','top')
%%
THO  = zeros(ie,je+2);
VOE = zeros(ie,je+2);
for i = 1:ie
    if mask(i,1)~=0
        [THO(i,:),ZZ_p(i,:)] = Fillcolumn(zzout_18(i,:),tho_relaxation(i,:),depto_18(i));
        [VOE(i,:),~] = Fillcolumn(zzout_18(i,:),VOE_relaxation(i,:),depto_18(i));
    end
end



F2 = axes('position',[0.55 0.10 0.40 0.8]);
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .4],'BaseValue',max(depto_18),'linewidth',2.0);hold on
% xlim([16.175 20]);ylim([0, 3500]);
xlim([16.08 17.5]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,VOE);shading interp;
colormap(NCV_blue_red);hold on;
clim([-0.25 0.25]);
[c,h]=contour(abs(XX_p),ZZ_p,THO,[11:1:30],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',15,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
%title(['Upwelling seasonal mean'],'fontname','Arial',...
%        'fontweight','bold','fontsize',22)
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold');
% annotation(figure(1),'textbox',...
%     [0.373840544871796 0.117142857142857 0.0886594551282038 0.0882539682539697],...
%     'Color',[1 1 1],...
%     'String','Upwelling',...
%     'LineStyle','none',...
%     'FontSize',20,...
%     'FontName','Arial',...
%     'FitBoxToText','off');

% annotation(figure(1),'textbox',...
%     [0.815507211538464 0.117142857142857 0.0928261217948694 0.076825396825398],...
%     'Color',[1 1 1],...
%     'String','Relaxation',...
%     'LineStyle','none',...
%     'FontSize',20,...
%     'FontName','Arial',...
%     'FitBoxToText','off');
h2=colorbar('location','eastOutside','fontsize',22,'fontweight','bold','linewidth',2);
set(get(h2,'Title'),'string','m s^-^1','fontname','Arial');
set(h2,'Ticks',[-0.2:0.1:0.2]);
cbarrow;
set(gca,'Layer','top')
exportgraphics(gcf,['CVCTM-18N.tiff'], 'Resolution',300);


