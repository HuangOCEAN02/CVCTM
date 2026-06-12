clear;clc;close all
%% Abandon this!!!!
%% check zonal variations base on pic_flux_map_merge_time.m (Figure(11)) ofr NDA
Loc2014 ='./'
Loc2015='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/';
Loc2016='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/';

Loc2014_CVP ='../BC_CVP/'
Loc2015_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_CVP/';
Loc2016_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_CVP/';

month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
year_str = {'2014','2015','2016'};
addpath ../../Grid/
%% 
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);

 load('./Pressure/NorthDakar_index.mat')
 lon_mcs  = lonp_grid(select_indicex,select_indicey);
 lat_mcs  = latp_grid(select_indicex,select_indicey);
   
 clear select_indicex select_indicey
    
 load('./Pressure/SouthDakar_index.mat')
 lon_scs  = lonp_grid(select_indicex,select_indicey);
 lat_scs = latp_grid(select_indicex,select_indicey);


load('CapeVerdeplateau_index.mat')
depto_grid_CVP   = depto_grid(select_indicex,select_indicey);
weto_p_CVP       = weto_p(select_indicex,select_indicey,:);
lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
latp_grid_CVP = latp_grid(select_indicex,select_indicey);
dlxp_CVP = dlxp(select_indicex,select_indicey);
dlyp_CVP = dlyp(select_indicex,select_indicey);

load('CoastalDakar_index.mat')
depto_grid_MSS   = depto_grid(select_indicex,select_indicey);
weto_p_MSS       = weto_p(select_indicex,select_indicey,:);
lonp_grid_MSS = lonp_grid(select_indicex,select_indicey);
latp_grid_MSS = latp_grid(select_indicex,select_indicey);
dlxp_MSS = dlxp(select_indicex,select_indicey);
dlyp_MSS = dlyp(select_indicex,select_indicey);

depto_grid = [depto_grid_CVP;depto_grid_MSS];
weto_p = [weto_p_CVP;weto_p_MSS];
lonp_grid = [lonp_grid_CVP;lonp_grid_MSS];
latp_grid = [latp_grid_CVP;latp_grid_MSS];
dlxp_grid = [dlxp_CVP;dlxp_MSS];
dlyp_grid = [dlyp_CVP;dlyp_MSS];

load('CapeVerdeplateau_index.mat','select_indicex');
select_indicex_CVP = select_indicex;
load('CoastalDakar_index.mat','select_indicex');
select_indicex_MSS = select_indicex;
select_indicex = [select_indicex_CVP;select_indicex_MSS];


ie = size(depto_grid,1);
je = size(depto_grid,2);

clear ddpo_grid_CVP ddpo_grid_MSS zzout_CVP zzout_MSS depto_grid_CVP depto_grid_MSS
clear weto_p_CVP weto_p_MSS lonp_grid_CVP lonp_grid_MSS
clear latp_grid_CVP latp_grid_MSS
%% month
Flux_x_upwelling = zeros(ie,je,12,3);
Flux_y_upwelling  = zeros(ie,je,12,3);
C_upwelling =  zeros(ie,je,12,3);
%% 2014
for m_select = 1:12
    SaveLocation = ['Pressure/',month_file{m_select}];
    % load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
    load([Loc2014,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2014,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2014,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x_MSS=Flux_x;Flux_y_MSS=Flux_y;
    C_MSS = C;R_MSS=R;
    clear Flux_x Flux_y C R

    load([Loc2014_CVP,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2014_CVP,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2014_CVP,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Flux_x = [Flux_x;Flux_x_MSS];
    Flux_y = [Flux_y;Flux_y_MSS];
    C = [C;C_MSS];
    R = [R;R_MSS];

    Flux_x_upwelling(:,:,m_select,1) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,1) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,1) =  C;
    R_upwelling(:,:,m_select,1) =  R;
end
%% 2015
for m_select = 1:12
    SaveLocation = ['Pressure/',month_file{m_select}];
    % load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
    load([Loc2015,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2015,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2015,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x_MSS=Flux_x;Flux_y_MSS=Flux_y;
    C_MSS = C;R_MSS=R;
    clear Flux_x Flux_y C R

    load([Loc2015_CVP,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2015_CVP,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2015_CVP,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Flux_x = [Flux_x;Flux_x_MSS];
    Flux_y = [Flux_y;Flux_y_MSS];
    C = [C;C_MSS];
    R = [R;R_MSS];

    Flux_x_upwelling(:,:,m_select,2) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,2) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,2) =  C;
    R_upwelling(:,:,m_select,2) =  R;
end
%% 2016
for m_select = 1:12
    SaveLocation = ['Pressure/',month_file{m_select}];

    load([Loc2016,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2016,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2016,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x_MSS=Flux_x;Flux_y_MSS=Flux_y;
    C_MSS = C;R_MSS=R;
    clear Flux_x Flux_y C R

    load([Loc2016_CVP,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2016_CVP,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2016_CVP,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');

    Flux_x(end,:) = (Flux_x(end-1,:) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:) = (Flux_y(end-1,:) + Flux_y_MSS(1,:))/2.0;
    Flux_x = [Flux_x;Flux_x_MSS];
    Flux_y = [Flux_y;Flux_y_MSS];
    C = [C;C_MSS];
    R = [R;R_MSS];

    Flux_x_upwelling(:,:,m_select,3) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,3) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,3) =  C;
    R_upwelling(:,:,m_select,3) =  R;
end
%% CVTM
LocCVTM ='/Users/josephhuang/Desktop/workingplace/斜压模拟/内潮斜压流';
load([LocCVTM,'/M2_Flux.mat'],'Flux_x','Flux_y');
is_index = 271; % -22
ie_index = 511; %-18
js_index = 55; %  17.996566772460938
je_index = 242; % 15.008684158325195

Flux_x_CVTM(:,:) = Flux_x(is_index:ie_index,js_index:je_index);
Flux_y_CVTM(:,:) = Flux_y(is_index:ie_index,js_index:je_index);
%%
time =[];
for m_select=1:12
    load(['Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time = [time,SDtime_range];
end
Time = datetime(time,'ConvertFrom','datenum');

time_2015 = [];
for m_select=1:12
    load(['../../../../../2015/Withtide/post_process/Grid/Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time_2015 = [time_2015,SDtime_range];
end
Time_2015 = datetime(time_2015,'ConvertFrom','datenum');


time_2016 = [];
for m_select=1:12
    load(['../../../../../2016/Withtide/post_process/Grid/Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time_2016 = [time_2016,SDtime_range];
end
Time_2016 = datetime(time_2016,'ConvertFrom','datenum');

time = [time,time_2015,time_2016];
Time =[Time,Time_2015,Time_2016];

t0 = dateshift(Time(1),'start','month');   % 第一个月的1号
t1 = dateshift(Time(end),'start','month'); % 最后一个月的1号
xt = datenum(t0:calmonths(1):t1);       % 每月一个

%% space map
is_index = 291;
ie_index = 531;
js_index = 26; % 17.996566772460938
je_index = 213; % 15.008684158325195
je_transect = je_index - js_index + 1;
% x-flux
Flux_x_CVTM(:,:) = Flux_x_CVTM(:,:).*1e-6.*depto_grid(is_index:ie_index,js_index:je_index).*dlyp_grid(is_index:ie_index,js_index:je_index);
u_flux_NDA= sum(Flux_x_upwelling(is_index:ie_index,js_index:je_index,:,:),2,'omitmissing');
u_flux_NDA_certian = squeeze(u_flux_NDA);
u_flux_NDA_mean = mean(u_flux_NDA,4);
u_flux_NDA_mean = squeeze(u_flux_NDA_mean);

% y-flux
Flux_y_CVTM(:,:) = Flux_y_CVTM(:,:).*1e-6.*depto_grid(is_index:ie_index,js_index:je_index).*dlxp_grid(is_index:ie_index,js_index:je_index);
v_flux_NDA= sum(Flux_y_upwelling(is_index:ie_index,js_index:je_index,:,:),1,'omitmissing');
v_flux_NDA_certian = squeeze(v_flux_NDA);
v_flux_NDA_mean = mean(v_flux_NDA,4);
v_flux_NDA_mean = squeeze(v_flux_NDA_mean);

save u_flux_origin.mat u_flux_NDA_certian
% dissipation
% Flux_y_CVTM(:,:) = Flux_y_CVTM(:,:).*1e-6.*depto_grid(is_index:ie_index,js_index:je_index).*dlxp_grid(is_index:ie_index,js_index:je_index);
R_NDA_zonal= sum(R_upwelling(is_index:ie_index,js_index:je_index,:,:),2,'omitmissing');
R_NDA_certian = squeeze(R_NDA_zonal);
R_NDA_zonal_mean = mean(R_NDA_zonal,4);
R_NDA_zonal_mean = squeeze(R_NDA_zonal_mean);

R_NDA_meridional= sum(R_upwelling(is_index:ie_index,js_index:je_index,:,:),1,'omitmissing');
R_NDA_certian = squeeze(R_NDA_meridional);
R_NDA_meridional_mean = mean(R_NDA_meridional,4);
R_NDA_meridional_mean = squeeze(R_NDA_meridional_mean);

Lat_transect = latp_grid(is_index,js_index:je_index);
Lon_transect = lonp_grid(is_index:ie_index,js_index);
mycolors = [1 0 0; ...
            0 1 0; ...
            0 0 1; ...
            0 1 1; ...
            1 0 1; ...
            0 0.4470 0.7410; ...
            0.8500 0.3250 0.0980;...
            0.9290 0.6940 0.1250;...
            0.4940 0.1840 0.5560;...
            0.4660 0.6740 0.1880;...
            0.3010 0.7450 0.9330;...
            0.6350 0.0780 0.1840;...
             0 0 0; ...
             1 1 0; ...
             0.28235 0.23922 0.5451; ...
             0.18431 0.3098 0.3098];

figure(11);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650]);
h1 = axes('position',[0.15 0.5 0.80 0.42]);
Lon_transect = -Lon_transect;
for i = 1:4
    plot(Lon_transect,u_flux_NDA_mean(:,i),'LineWidth',1.5,'linestyle','-');hold on;
end
for i = 5:8
    plot(Lon_transect,u_flux_NDA_mean(:,i),'LineWidth',1.5,'linestyle','-.');hold on;
end
for i = 9:12
    plot(Lon_transect,u_flux_NDA_mean(:,i),'LineWidth',1.5,'linestyle','--');hold on;
end
ylimup = 140;
ylimdown = 1e-2;
pp = [1 2 3 4];
hold on;
y_MDA = [ 18.5 ylimup;  18.5  ylimdown; 17.5 ylimdown;  17.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor',[0.85,0.33,0.10],'Facealpha',.2,'EdgeColor','none')
ax = gca; 
ax.ColorOrder = mycolors;
h = legend('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug',...
    'Sep','Oct','Nov','Dec');
set(h,'NumColumns',6,'Location','northeast','LineWidth',2,...
    'FontSize',16,'AutoUpdate','off');
set(gca,'fontsize',24,'LineWidth',2,'fontname','Arial','XDir','reverse');
set(gca,'XAxisLocation','bottom','XTickLabel',{' '},'Xtick',[18:0.5:22]);
set(gca,'Layer','top','fontweight','bold');grid on;xlim([18 22])
% title('Energy Zonal Transport towards the NDA','FontSize',20,'fontname','Arial')
xlim([18 22]);ylim([46 140]);
ylog;
y_MDA = [ 20 ylimup;  20  ylimdown; 18.5 ylimdown;  18.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor','yellow','Facealpha',.1,'EdgeColor','none')
%%
h2 = axes('position',[0.15 0.12 0.80 0.34]);
u_flux_NDA_upwelling = mean(u_flux_NDA_mean(:,1:4),2,'omitmissing');
u_flux_NDA_relaxation = mean(u_flux_NDA_mean(:,5:8),2,'omitmissing');
u_flux_NDA_downwelling = mean(u_flux_NDA_mean(:,9:12),2,'omitmissing');
u_flux_NDA_CVTM = sum(Flux_x_CVTM,2,'omitmissing');

plot(Lon_transect,u_flux_NDA_upwelling,'LineWidth',1.5,'linestyle','-','Color','b');hold on;
plot(Lon_transect,u_flux_NDA_relaxation,'LineWidth',1.5,'linestyle','-','Color','g');hold on;
plot(Lon_transect,u_flux_NDA_downwelling,'LineWidth',1.5,'linestyle','-','Color','r');hold on;
plot(Lon_transect,u_flux_NDA_CVTM,'LineWidth',1.5,'linestyle','--','Color','k');hold on;
set(gca,'fontsize',24,'LineWidth',2,'fontname','Arial');
set(gca,'XAxisLocation','bottom','Xtick',[18:0.5:22]);
set(gca,'Layer','top','fontweight','bold','XDir','reverse');
hbar = legend('Upwelling','Relaxation','Downwelling','CVTM');
set(hbar,'NumColumns',2,'Location','northeast','LineWidth',2,...
    'FontSize',16,'AutoUpdate','off');
ylim([20 130]);
grid on;

ylimup = 130;
ylimdown =-130;
pp = [1 2 3 4];
hold on;
y_MDA = [ 18.5 ylimup;  18.5  ylimdown; 17.5 ylimdown;  17.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor',[0.85,0.33,0.10],'Facealpha',.2,'EdgeColor','none')
y_MDA = [ 20 ylimup;  20  ylimdown; 18.5 ylimdown;  18.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor','yellow','Facealpha',.1,'EdgeColor','none')
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridAlpha',0.3);
xlim([18 22])
exportgraphics(gcf,['Zonal_Energy_to_NDA.tiff'], 'Resolution',300);
