clear;clc;close all
clear;clc;close all
Loc2014 ='../Transect/18N'
Loc2015='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/Transect/18N';
Loc2016='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/Transect/18N';
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
addpath ../../Grid/
%%
load('Grid_info.mat','ke','lonp_grid','latp_grid','depto_grid','weto_p','zzout','bottom_index','ddpo_grid');
% load('Grid_info_v.mat','latv_grid','lonv_grid','deute_grid','weto_v','zzout_v')
load('Grid_info_w.mat','zzout_w');
iw = 10;ie = 1;
jn = 10;js = 10;

index_j = 84; % global

lonp_18 = lonp_grid(iw+1:end,index_j); 
latp_18 = latp_grid(iw+1:end,index_j); 
zzout_18(:,:) = zzout(iw+1:end,index_j,:);
weto_p18(:,:) =  weto_p(iw+1:end,index_j,:);
ddpo_p18(:,:) = ddpo_grid(iw+1:end,index_j,:);
bottom_index18 = bottom_index(iw+1:end,index_j); 
zzout_w18(:,:) = zzout_w(iw+1:end,index_j,:);
zzout_18(weto_p18==0)=nan;
depto_18  = depto_grid(iw+1:end,index_j);

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
UKO = zeros(ie,je+2);
for i = 1:ie
   XX_p(i,:) = lonp_18(i);
end
%% READ
is18N_tracermat = 0
if is18N_tracermat == 1
    tho_month = zeros(ie,ke,12,3);
    sao_month = zeros(ie,ke,12,3);
    N2_month  =  zeros(ie,ke,12,3);
    vke_month =  zeros(ie,ke,12,3);
    uko_month =  zeros(ie,ke,12,3);
    for y_select = 1:3
        if y_select==1
            SaveLocation = './Monthly_average_results/Gen_map/2014';
            Loc = Loc2014;
        end
        if y_select==2
            SaveLocation = './Monthly_average_results/Gen_map/2015';
            Loc = Loc2015;
        end    
        if y_select==3
            SaveLocation = './Monthly_average_results/Gen_map/2016';
            Loc = Loc2016;
        end
        disp(['Year:',num2str(y_select)])
        for m_select = 1:12
            load([Loc,'/Transect18_tracer_', month_file{m_select}, '_CVCTM.mat'],'tho_time','sao_time');
            load([Loc,'/Transect18_velocity_', month_file{m_select}, '_CVCTM.mat'],'vke_time','uko_time');
            % vke_cell_time = squeeze(nanmean(vke_time,2));%clear vke_time
            uko_cell_time = (uko_time(1:end-1,:,:) + uko_time(2:end,:,:))/2.0;
            tho_month(:,:,m_select,y_select) = mean(tho_time,3);
            sao_month(:,:,m_select,y_select) = mean(sao_time,3);
            uko_month(:,:,m_select,y_select) = mean(uko_cell_time,3);
            vke_month(:,:,m_select,y_select) = squeeze(mean(mean(vke_time,2),4));
            % zoo_month(:,m_select) = mean(zoo_time,2);
            N2_month(:,:,m_select,y_select) = Cal_N2_fromtransect(tho_month(:,:,m_select,y_select), sao_month(:,:,m_select,y_select) , ...
                zzout_18,zzout_w18,bottom_index18,depto_18,mask,latp_18);
            disp(['Month:',num2str(m_select)])
        end
    end
    save 18N_tracer.mat N2_month tho_month sao_month -v7.3
    save 18N_velocity.mat vke_month uko_month -v7.3
else
    load('18N_tracer.mat');
    N2_month(N2_month==0)=nan;
    sao_month(sao_month==0)=nan;
    tho_month(tho_month==0)=nan;
    N2_average_year = mean(N2_month,4,'omitmissing');
    load('18N_velocity.mat');
    vke_month(vke_month==0)=nan;
    uko_month(uko_month==0)=nan;
end

%from the coast to 19W
NDS_index = [471:650];
N2_NDA(:,:) = mean(N2_average_year(NDS_index,:,:),1,'omitmissing');

Temp_Mar = tho_month(:,:,3,2);
Sao_Mar = sao_month(:,:,3,2);
N2_Mar = N2_month(:,:,3,2);
vke_Mar = vke_month(:,:,3,2);
uko_Mar = uko_month(:,:,3,2);

Temp_Nov = tho_month(:,:,11,2);
Sao_Nov= sao_month(:,:,11,2);
N2_Nov = N2_month(:,:,11,2);
vke_Nov = vke_month(:,:,11,2);
uko_Nov = uko_month(:,:,11,2);

Temp_Mar(weto_p18==0)=nan;
Sao_Mar(weto_p18==0)=nan;
N2_Mar(weto_p18==0)=nan;
vke_Mar(weto_p18==0)=nan;
uko_Mar(weto_p18==0)=nan;


Temp_Nov(weto_p18==0)=nan;
Sao_Nov(weto_p18==0)=nan;
N2_Nov(weto_p18==0)=nan;
vke_Nov(weto_p18==0)=nan;
uko_Nov(weto_p18==0)=nan;


ZZ_p = zeros(ie,je+2);
THO_Mar  = zeros(ie,je+2);
THO_Nov  = zeros(ie,je+2);
SAO_Mar  = zeros(ie,je+2);
SAO_Nov  = zeros(ie,je+2);
VVV_Mar  = zeros(ie,je+2);
VVV_Nov  = zeros(ie,je+2);
UUU_Mar  = zeros(ie,je+2);
UUU_Nov  = zeros(ie,je+2);
Nsquare_Mar  = zeros(ie,je+2);
Nsquare_Nov  = zeros(ie,je+2);
for i = 1:ie
    if mask(i,1)~=0
        % Temperature
        [THO_Mar(i,:),ZZ_p(i,:)] = Fillcolumn(zzout_18(i,:),Temp_Mar(i,:),depto_18(i));
        [THO_Nov(i,:),~] = Fillcolumn(zzout_18(i,:),Temp_Nov(i,:),depto_18(i));
        % Nsquare
        [SAO_Mar(i,:),~] = Fillcolumn(zzout_18(i,:),Sao_Mar(i,:),depto_18(i));
        [SAO_Nov(i,:),~] = Fillcolumn(zzout_18(i,:),Sao_Nov(i,:),depto_18(i));
        % Velocity
        [VVV_Mar(i,:),~] = Fillcolumn(zzout_18(i,:),vke_Mar(i,:),depto_18(i));
        [VVV_Nov(i,:),~] = Fillcolumn(zzout_18(i,:),vke_Nov(i,:),depto_18(i));
        % Velocity
        [UUU_Mar(i,:),~] = Fillcolumn(zzout_18(i,:),uko_Mar(i,:),depto_18(i));
        [UUU_Nov(i,:),~] = Fillcolumn(zzout_18(i,:),uko_Nov(i,:),depto_18(i));
       % Nsquare
         [Nsquare_Mar(i,:),~] = Fillcolumn(zzout_18(i,:),N2_Mar(i,:),depto_18(i));
         [Nsquare_Nov(i,:),~] = Fillcolumn(zzout_18(i,:),N2_Nov(i,:),depto_18(i));
    end
end
% change units to cph
Nsquare_Mar = sqrt(Nsquare_Mar)*3600/(2*pi);
Nsquare_Nov = sqrt(Nsquare_Nov)*3600/(2*pi);
%%
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[20 50 1300 850])
h1 = axes('position',[0.05 0.50 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
% xlim([16.175 20]);ylim([0, 3500]);
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,THO_Mar);shading interp;
colormap(h1,"turbo");clim([8 28])
[c,h]=contour(abs(XX_p),ZZ_p,THO_Mar,[12:2:18],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',300,'color','k',...
     'fontsize',20,'fontname','Arial')
 [c,h]=contour(abs(XX_p),ZZ_p,THO_Mar,[20,20],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',150,'color','k',...
     'fontsize',20,'fontname','Arial')
%title(['Upwelling seasonal mean'],'fontname','Arial',...
%        'fontweight','bold','fontsize',22)
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'Xticklabel',{' '});
% grid on;set(h1,'GridLineWidth','-.','GridAlpha',0.5)
set(gca,'Layer','top')

hbar1=colorbar('location','northoutside','fontsize',18,'fontweight','bold','Position',...
    [0.05+0.02 0.87 0.136333333333333 0.0284615384615384]);
set(hbar1,'Ticks',[8:5:28],'LineWidth',1.5,'TickLength',0.05);
annotation(figure(1),'textbox',...
    [0.21 0.87 0.0629999999999994 0.0468253968253972],...
    'String','$\it\Theta(^\circ{C})$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');


h2 = axes('position',[0.25+0.035 0.50 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'Xticklabel',{' '},'YTickLabel',{' '});
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,(SAO_Mar));shading interp;
load('cmp_haxby_r.mat');
colormap(h2,cmp_haxby_r);
clim([35.2 36.5])
clim([34 36])
[c,h]=contour(abs(XX_p),ZZ_p,SAO_Mar,[30:0.2:37],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',20,'fontname','Arial')
set(gca,'Layer','top')
hbar2=colorbar('location','northoutside','fontsize',18,'fontweight','bold','Position',...
    [0.25+0.03+0.02  0.87 0.136333333333333 0.0284615384615384]);
set(hbar2,'Ticks',[34:1:36.5],'LineWidth',1.5,'TickLength',0.05);
annotation(figure(1),'textbox',...
    [0.25+0.03+0.2-0.04 0.87 0.0629999999999994 0.0468253968253972],...
    'String','$\it\textbf{S}({psu})$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');


h3 = axes('position',[0.25+0.035+0.2+0.035 0.50 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'Xticklabel',{' '},'YTickLabel',{' '});
pcolor(abs(XX_p),ZZ_p,Nsquare_Mar);shading interp;
colormap(h3,"jet");clim([0 12])
xlim([16.08 18]);ylim([0 500]);
[c,h]=contour(abs(XX_p),ZZ_p,Nsquare_Mar,[4:2:12],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',200,'color','k',...
     'fontsize',20,'fontname','Arial')

set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'Xticklabel',{' '});
% grid on;set(h1,'GridLineWidth','-.','GridAlpha',0.5)
set(gca,'Layer','top')
hbar3=colorbar('location','northoutside','fontsize',18,'fontweight','bold','Position',...
    [0.25+0.03+0.2+0.03+0.02 0.87 0.136333333333333 0.0284615384615384]);
set(hbar3,'Ticks',[0:4:12],'LineWidth',1.5,'TickLength',0.05);
annotation(figure(1),'textbox',...
    [0.25+0.03+0.2+0.03+0.2-0.04 0.87 0.0629999999999994 0.0468253968253972],...
    'String','$\it\textbf{N}({cph})$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');


h4 = axes('position',[0.25+0.035+0.2+0.035+0.2+0.035 0.50 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'Xticklabel',{' '},'YTickLabel',{' '});
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,VVV_Mar);shading interp;
load('NCV_blue_red.mat')
colormap(h4,NCV_blue_red);clim([-0.3 0.3])
[c,h]=contour(abs(XX_p),ZZ_p,VVV_Mar,[-0.1,0.1],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',1200,'color','k',...
     'fontsize',20,'fontname','Arial')

hbar4=colorbar('location','northoutside','fontsize',18,'fontweight','bold','Position',...
    [0.25+0.03+0.2+0.03+0.2+0.03+0.02 0.87 0.136333333333333 0.0284615384615384]);
set(hbar4,'Ticks',[-0.3:0.15:0.3],'LineWidth',1.5,'TickLength',0.05);
% hbar4.Ruler.Exponent = -1;
annotation(figure(1),'textbox',...
    [0.25+0.03+0.2+0.03+0.2+0.03+0.2-0.04 0.87 0.0629999999999994 0.0468253968253972],...
    'String','$\it\textbf{V}({m\:s^{-1}})$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',20,...
    'FontName','Arial',...
    'FitBoxToText','off');
%%
h5 = axes('position',[0.05 0.1 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold','XTick',[16.5:0.5:18]);
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,THO_Nov);shading interp;
colormap(h5,"turbo");clim([8 28])
[c,h]=contour(abs(XX_p),ZZ_p,THO_Nov,[12:2:18,24],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',20,'fontname','Arial')
%title(['Upwelling seasonal mean'],'fontname','Arial',...
%        'fontweight','bold','fontsize',22)
set(gca,'Layer','top')


h6 = axes('position',[0.25+0.035 0.1 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'YTickLabel',{' '},'XTick',[16.5:0.5:18]);
xlim([16.08 18]);ylim([0 500]);

pcolor(abs(XX_p),ZZ_p,SAO_Nov);shading interp;
clim([34 36])
[c,h]=contour(abs(XX_p),ZZ_p,SAO_Nov,[30:0.2:37],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',800,'color','k',...
     'fontsize',20,'fontname','Arial')
colormap(h6,cmp_haxby_r);
set(gca,'Layer','top')


h7 = axes('position',[0.25+0.035+0.2+0.035 0.1 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'YTickLabel',{' '},'XTick',[16.5:0.5:18]);
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,Nsquare_Nov);shading interp;
colormap(h7,"jet");clim([0 14])
[c,h]=contour(abs(XX_p),ZZ_p,Nsquare_Nov,[4:4:12],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',350,'color','k',...
     'fontsize',20,'fontname','Arial')
set(gca,'Layer','top')




h8 = axes('position',[0.25+0.035+0.2+0.035+0.2+0.035 0.1 0.2 0.36]); % temp
area(abs(lonp_18),depto_18,'FaceColor',[.4 .4 .5],'BaseValue',max(depto_18),'linewidth',2.0);hold on
set(gca,'fontsize',20,'LineWidth',1.5,'fontname','Arial',...
        'Xdir','reverse','Ydir','reverse','Xaxislocation','bottom','fontweight','bold',...
        'YTickLabel',{' '},'XTick',[16.5:0.5:18]);
xlim([16.08 18]);ylim([0 500]);
pcolor(abs(XX_p),ZZ_p,VVV_Nov);shading interp;
[c,h]=contour(abs(XX_p),ZZ_p,VVV_Nov,[-0.1,0.1],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',400,'color','k',...
     'fontsize',20,'fontname','Arial')
load('NCV_blue_red.mat')
colormap(h8,NCV_blue_red);clim([-0.3 0.3])
set(gca,'Layer','top')

% exportgraphics(gcf,['Transect18N.tiff'], 'Resolution',300);
% 
 exportgraphics(gcf,['Transect18N_new.tiff'], 'Resolution',300);
