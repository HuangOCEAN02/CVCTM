clear;clc;close all
%% check zonal variations base on pic_flux_map_merge_time.m (Figure(11)) ofr NDA
Loc2014 ='./mode_function_MSS/'
Loc2015='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/mode_function_MSS/';
Loc2016='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/mode_function_MSS/';

Loc2014_CVP ='../BC_CVP/mode_function_CVP/'
Loc2015_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_CVP/mode_function_CVP/';
Loc2016_CVP='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_CVP/mode_function_CVP/';

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

Flux_x_upwelling2 = zeros(ie,je,12,3);
Flux_y_upwelling2  = zeros(ie,je,12,3);

C_upwelling =  zeros(ie,je,12,3);
%% 2014
pic_mode = 1;
for m_select = 1:12
    % load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
    load([Loc2014,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2014,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x_MSS=Flux_x(:,:,pic_mode);Flux_y_MSS=Flux_y(:,:,pic_mode);
    C_MSS = C_mode;
    Flux_x_MSS2=Flux_x(:,:,2);Flux_y_MSS2=Flux_y(:,:,2);
    clear Flux_x Flux_y C R


    load([Loc2014_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2014_CVP,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x2 = Flux_x;
    Flux_y2 = Flux_y;
    Flux_x(end,:,pic_mode) = (Flux_x(end-1,:,pic_mode) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:,pic_mode) = (Flux_y(end-1,:,pic_mode) + Flux_y_MSS(1,:))/2.0;
    Flux_x_CVP(:,:) = Flux_x(:,:,pic_mode);Flux_y_CVP(:,:) = Flux_y(:,:,pic_mode);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    C = [C_mode;C_MSS];

    Flux_x2(end,:,2) = (Flux_x2(end-1,:,2) + Flux_x_MSS2(1,:))/2.0;
    Flux_y2(end,:,2) = (Flux_y2(end-1,:,2) + Flux_y_MSS2(1,:))/2.0;
    Flux_x_CVP2(:,:) = Flux_x2(:,:,2);Flux_y_CVP2(:,:) = Flux_y2(:,:,2);
    Flux_x2 = [Flux_x_CVP2;Flux_x_MSS2];
    Flux_y2 = [Flux_y_CVP2;Flux_y_MSS2];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_mode
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,1) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,1) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,1) =  C;

    Flux_x_upwelling2(:,:,m_select,1) = Flux_x2*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling2(:,:,m_select,1) = Flux_y2*1e-6.*depto_grid.*dlxp_grid(:,:);
end
%% 2015
for m_select = 1:12
    load([Loc2015,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2015,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x_MSS=Flux_x(:,:,pic_mode);Flux_y_MSS=Flux_y(:,:,pic_mode);
    C_MSS = C_mode;
    Flux_x_MSS2=Flux_x(:,:,2);Flux_y_MSS2=Flux_y(:,:,2);
    clear Flux_x Flux_y C R

    load([Loc2015_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2015_CVP,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x2 = Flux_x;
    Flux_y2 = Flux_y;

    Flux_x(end,:,pic_mode) = (Flux_x(end-1,:,pic_mode) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:,pic_mode) = (Flux_y(end-1,:,pic_mode) + Flux_y_MSS(1,:))/2.0;
    Flux_x_CVP(:,:) = Flux_x(:,:,pic_mode);Flux_y_CVP(:,:) = Flux_y(:,:,pic_mode);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    C = [C_mode;C_MSS];

    Flux_x2(end,:,2) = (Flux_x2(end-1,:,2) + Flux_x_MSS2(1,:))/2.0;
    Flux_y2(end,:,2) = (Flux_y2(end-1,:,2) + Flux_y_MSS2(1,:))/2.0;
    Flux_x_CVP2(:,:) = Flux_x2(:,:,2);Flux_y_CVP2(:,:) = Flux_y2(:,:,2);
    Flux_x2 = [Flux_x_CVP2;Flux_x_MSS2];
    Flux_y2 = [Flux_y_CVP2;Flux_y_MSS2];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_mode
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,2) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,2) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,2) =  C;

    Flux_x_upwelling2(:,:,m_select,2) = Flux_x2*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling2(:,:,m_select,2) = Flux_y2*1e-6.*depto_grid.*dlxp_grid(:,:);
end
%% 2016
for m_select = 1:12
    load([Loc2016,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2016,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x_MSS=Flux_x(:,:,pic_mode);Flux_y_MSS=Flux_y(:,:,pic_mode);
    C_MSS = C_mode;
    Flux_x_MSS2=Flux_x(:,:,2);Flux_y_MSS2=Flux_y(:,:,2);
    clear Flux_x Flux_y C R

    load([Loc2016_CVP,'Mode_Flux/M2_Flux_Mode_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2016_CVP,'Mode_Gene_1/M2_Mode1_Conversion_', month_file{m_select}, '.mat'],'C_mode');

    Flux_x2 = Flux_x;
    Flux_y2 = Flux_y;

    Flux_x(end,:,pic_mode) = (Flux_x(end-1,:,pic_mode) + Flux_x_MSS(1,:))/2.0;
    Flux_y(end,:,pic_mode) = (Flux_y(end-1,:,pic_mode) + Flux_y_MSS(1,:))/2.0;
    Flux_x_CVP(:,:) = Flux_x(:,:,pic_mode);Flux_y_CVP(:,:) = Flux_y(:,:,pic_mode);
    Flux_x = [Flux_x_CVP;Flux_x_MSS];
    Flux_y = [Flux_y_CVP;Flux_y_MSS];
    C = [C_mode;C_MSS];

    Flux_x2(end,:,2) = (Flux_x2(end-1,:,2) + Flux_x_MSS2(1,:))/2.0;
    Flux_y2(end,:,2) = (Flux_y2(end-1,:,2) + Flux_y_MSS2(1,:))/2.0;
    Flux_x_CVP2(:,:) = Flux_x2(:,:,2);Flux_y_CVP2(:,:) = Flux_y2(:,:,2);
    Flux_x2 = [Flux_x_CVP2;Flux_x_MSS2];
    Flux_y2 = [Flux_y_CVP2;Flux_y_MSS2];

    clear Flux_y_CVP Flux_x_CVP Flux_x_MSS Flux_y_MSS C_mode
    clear Flux_x_MSS2 Flux_y_MSS2 Flux_x_CVP2 Flux_y_CVP2
    Flux_x_upwelling(:,:,m_select,3) = Flux_x*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling(:,:,m_select,3) = Flux_y*1e-6.*depto_grid.*dlxp_grid(:,:);
    C_upwelling(:,:,m_select,3) =  C;

    Flux_x_upwelling2(:,:,m_select,3) = Flux_x2*1e-6.*depto_grid.*dlyp_grid(:,:);
    Flux_y_upwelling2(:,:,m_select,3) = Flux_y2*1e-6.*depto_grid.*dlxp_grid(:,:);
end
%% CVTM
% LocCVTM ='/Users/josephhuang/Desktop/workingplace/斜压模拟/内潮斜压流';
% load([LocCVTM,'/M2_Flux.mat'],'Flux_x','Flux_y');
% is_index = 271; % -22
% ie_index = 511; %-18
% js_index = 55; %  17.996566772460938
% je_index = 242; % 15.008684158325195
% 
% Flux_x_CVTM(:,:) = Flux_x(is_index:ie_index,js_index:je_index);
% Flux_y_CVTM(:,:) = Flux_y(is_index:ie_index,js_index:je_index);
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
% Flux_x_CVTM(:,:) = Flux_x_CVTM(:,:).*1e-6.*depto_grid(is_index:ie_index,js_index:je_index).*dlyp_grid(is_index:ie_index,js_index:je_index);
u_flux_NDA= sum(Flux_x_upwelling(is_index:ie_index,js_index:je_index,:,:),2,'omitmissing');
u_flux_NDA_certian = squeeze(u_flux_NDA);
u_flux_NDA_mean = mean(u_flux_NDA,4);
u_flux_NDA_mean = squeeze(u_flux_NDA_mean);

% y-flux
% Flux_y_CVTM(:,:) = Flux_y_CVTM(:,:).*1e-6.*depto_grid(is_index:ie_index,js_index:je_index).*dlxp_grid(is_index:ie_index,js_index:je_index);
v_flux_NDA= sum(Flux_y_upwelling(is_index:ie_index,js_index:je_index,:,:),1,'omitmissing');
v_flux_NDA_certian = squeeze(v_flux_NDA);
v_flux_NDA_mean = mean(v_flux_NDA,4);
v_flux_NDA_mean = squeeze(v_flux_NDA_mean);


u_flux_NDA2= sum(Flux_x_upwelling2(is_index:ie_index,js_index:je_index,:,:),2,'omitmissing');
u_flux_NDA_certian2 = squeeze(u_flux_NDA2);
u_flux_NDA_mean2 = mean(u_flux_NDA2,4);
u_flux_NDA_mean2 = squeeze(u_flux_NDA_mean2);

v_flux_NDA2= sum(Flux_y_upwelling2(is_index:ie_index,js_index:je_index,:,:),1,'omitmissing');
v_flux_NDA_certian2 = squeeze(v_flux_NDA2);
v_flux_NDA_mean2 = mean(v_flux_NDA2,4);
v_flux_NDA_mean2 = squeeze(v_flux_NDA_mean2);

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
xlim([18 22]);
ylim([40 100]);

y_MDA = [ 20 ylimup;  20  ylimdown; 18.5 ylimdown;  18.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor','yellow','Facealpha',.1,'EdgeColor','none')
%%
figure(11);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650]);
h2 = axes('position',[0.15 0.12 0.80 0.32]);
yyaxis left;
u_flux_NDA_upwelling = mean(u_flux_NDA_mean(:,1:4),2,'omitmissing');
u_flux_NDA_relaxation = mean(u_flux_NDA_mean(:,5:8),2,'omitmissing');
u_flux_NDA_downwelling = mean(u_flux_NDA_mean(:,9:12),2,'omitmissing');
% u_flux_NDA_CVTM = sum(Flux_x_CVTM,2,'omitmissing');
plot(Lon_transect,u_flux_NDA_upwelling,'LineWidth',1.5,'linestyle','-','Color',[0.8500 0.3250 0.0980]);hold on;
plot(Lon_transect,u_flux_NDA_relaxation,'LineWidth',1.5,'linestyle','--','Color',[0.8500 0.3250 0.0980]);hold on;
plot(Lon_transect,u_flux_NDA_downwelling,'LineWidth',1.5,'linestyle',':','Color',[0.8500 0.3250 0.0980]);hold on;
% plot(Lon_transect,u_flux_NDA_CVTM,'LineWidth',1.5,'linestyle','--','Color','k');hold on;
set(gca,'fontsize',24,'LineWidth',2,'fontname','Arial');
set(gca,'XAxisLocation','bottom','Xtick',[18:0.5:22]);
set(gca,'Layer','top','fontweight','bold','XDir','reverse');
% hbar = legend('Upwelling','Relaxation','Downwelling');
% set(hbar,'NumColumns',3,'Location','northeast','LineWidth',2,...
%     'FontSize',16,'AutoUpdate','off');
ylim([40 80]);
grid on;
set(gca,'ylim',[40 80],'YTick',[40:10:80],'fontname','Arial','fontweight','bold');
set(gca,'YColor',[0.8500 0.3250 0.0980]);
ylimup = 130;
ylimdown =-130;
pp = [1 2 3 4];
hold on;
y_MDA = [ 18.5 ylimup;  18.5  ylimdown; 17.5 ylimdown;  17.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor',[0.85,0.33,0.10],'Facealpha',.2,'EdgeColor','none')
y_MDA = [ 20 ylimup;  20  ylimdown; 18.5 ylimdown;  18.5 ylimup];
patch('Faces',pp,'Vertices',y_MDA,'Facecolor','yellow','Facealpha',.1,'EdgeColor','none')
y_CVA = [ 22 ylimup;  22  ylimdown; 21.75 ylimdown;  21.75 ylimup];
patch('Faces',pp,'Vertices',y_CVA,'Facecolor','blue','Facealpha',.1,'EdgeColor','none')

set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridAlpha',0.3,'GridColor','k');
xlim([18 22]);

yyaxis right;
u_flux_NDA_upwelling2 = mean(u_flux_NDA_mean2(:,1:4),2,'omitmissing');
u_flux_NDA_relaxation2 = mean(u_flux_NDA_mean2(:,5:8),2,'omitmissing');
u_flux_NDA_downwelling2 = mean(u_flux_NDA_mean2(:,9:12),2,'omitmissing');

plot(Lon_transect,u_flux_NDA_upwelling2,'LineWidth',1.5,'linestyle','-','Color','b');hold on;
plot(Lon_transect,u_flux_NDA_relaxation2,'LineWidth',1.5,'linestyle','--','Color','b');hold on;
plot(Lon_transect,u_flux_NDA_downwelling2,'LineWidth',1.5,'linestyle',':','Color','b');hold on;

set(gca,'ylim',[0 50],'YTick',[0:10:50],'fontname','Arial','fontweight','bold');
% ylabel([' Cumulative fraction  \newline ' ...
%     ' $(MW)$'],'Interpreter','latex','Rotation',90,'FontSize',25,'FontWeight','bold','fontname','Arial')
set(gca,'YColor','b','YLim',[0 50]);

exportgraphics(gcf,['Zonal_Modal_Energy_to_NDA.tiff'], 'Resolution',300);
