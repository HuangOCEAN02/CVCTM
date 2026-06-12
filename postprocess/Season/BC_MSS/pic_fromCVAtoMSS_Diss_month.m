clear;clc;close all
set(0,'defaultAxesXColor','k');         % x 轴黑色
set(0,'defaultAxesYColor','k');         % x 轴黑色
set(0,'defaultTextColor','k');          % 所有文字黑色
Loc2014 ='./'
Loc2015='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/';
Loc2016='/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/';
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
addpath ../../Grid/
%% 
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('Grid_resolution.mat', 'dlyp','dlxp')
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p     =  Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
dlyp = dlyp(select_indicex,select_indicey);
dlxp = dlxp(select_indicex,select_indicey);
ie = size(depto_grid,1);
je = size(depto_grid,2);

%% month
for m_select = 1:12
    SaveLocation = ['Pressure/',month_file{m_select}];
    % load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
    % load([Loc2014,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2014,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2014,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');
    % Flux_x_upwelling(:,:,m_select,1) = Flux_x.*depto_grid; %.*dlyp;
    % Flux_y_upwelling(:,:,m_select,1) = Flux_y.*depto_grid; %.*dlxp;
    C_upwelling(:,:,m_select,1) =  C;
    R_upwelling(:,:,m_select,1) =  R;

    % load([SaveLocation,'/M2_Flux_Divergence_', month_file{m_select}, '.mat'],'Div_F');
    % load([Loc2015,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2015,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2015,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');
    % Flux_x_upwelling(:,:,m_select,2) = Flux_x.*depto_grid;% .*dlyp;
    % Flux_y_upwelling(:,:,m_select,2) = Flux_y.*depto_grid;% .*dlxp;
    C_upwelling(:,:,m_select,2) =  C;
    R_upwelling(:,:,m_select,2) =  R;

    % load([Loc2016,SaveLocation,'/M2_Flux_', month_file{m_select}, '.mat'],'Flux_x','Flux_y');
    load([Loc2016,SaveLocation,'/M2_conversion_', month_file{m_select}, '.mat'],'C');
    load([Loc2016,SaveLocation,'/M2_dissipation_', month_file{m_select}, '.mat'],'R');
    % Flux_x_upwelling(:,:,m_select,3) = Flux_x.*depto_grid;% .*dlyp;
    % Flux_y_upwelling(:,:,m_select,3) = Flux_y.*depto_grid;% .*dlxp;
    C_upwelling(:,:,m_select,3) =  C;
    R_upwelling(:,:,m_select,3) =  R;

    %% Try to plot 
    load(['../Average/CriticalSlope_MSS/MSS_GD', month_file{m_select}, '.mat'],'slope');
    slope_upwelling(:,:,m_select,1) = slope;% .*dlyp;   

    load(['../../../../../2015/Withtide/post_process/Season/Average/CriticalSlope_MSS/MSS_GD', month_file{m_select}, '.mat'],'slope');
    slope_upwelling(:,:,m_select,2) = slope;% .*dlyp;   

    load(['../../../../../2016/Withtide/post_process/Season/Average/CriticalSlope_MSS/MSS_GD', month_file{m_select}, '.mat'],'slope');
    slope_upwelling(:,:,m_select,3) = slope;% .*dlyp;   
end
load('MSS_coast_index.mat');
le = length(coast_x);
%% using coastal cooridiantes
Grid_range = 200;
time=[];
for m_year = 1:3
for m_select = 1:12
    % load(['Time_info_',month_file{m_select},'.mat']);
    % if m_select==2
    %     SDtime_range(673:end)=[];
    % end
    % time = [time,SDtime_range];
       for pp = 1:le
           for qq = Grid_range:-1:1
                 % C_month(pp,m_select) = nanmean(C_ave([coast_x(pp)-Grid_range:coast_x(pp)-1],pp,m_select));
                 % u_flux_month(qq,pp,m_select,m_year) =(Flux_x_upwelling([coast_x(pp)-qq],pp,m_select,m_year));
                 % v_flux_month(qq,pp,m_select,m_year) = (Flux_y_upwelling([coast_x(pp)-qq],pp,m_select,m_year));
                 C_month(qq,pp,m_select,m_year) = (C_upwelling([coast_x(pp)-qq],pp,m_select,m_year)); 
                 R_month(qq,pp,m_select,m_year) = (R_upwelling([coast_x(pp)-qq],pp,m_select,m_year)); 
                 % C_month(pp,m_select) = nanmean(C_ave([coast_x(pp)-Grid_range:coast_x(pp)-1],pp,m_select));
                 % u_flux_month(qq,pp,m_select,m_year) = (Flux_x_upwelling([coast_x(pp)-qq],pp,m_select,m_year));
                 % v_flux_month(qq,pp,m_select,m_year) = (Flux_y_upwelling([coast_x(pp)-qq],pp,m_select,m_year));
                 slope_month(qq,pp,m_select,m_year)  = (slope_upwelling([coast_x(pp)-qq],pp,m_select,m_year));
                 % R_month(pp,m_select) = nanmean(R_ave([coast_x(pp)-Grid_range:coast_x(pp)-1],pp,m_select));
        end
     end
end
end
%%
for pp = 1:le
    for qq = Grid_range:-1:1
        Lx(qq,pp) = sum(dlxp([coast_x(pp)-qq:coast_x(pp)],pp));
        Depto_lx(qq,pp) = depto_grid([coast_x(pp)-qq],pp);
    end
    Lx(1:end,pp) =  Lx(1:end,pp) - Lx(1,pp);
end
%%
Lx=Lx*1e-3;
% u_flux_month = u_flux_month*1e-3;
% v_flux_month = v_flux_month*1e-3;

Lat_coast=zeros(size(Lx));
for i=1:Grid_range
    Lat_coast(i,:) = lat_coast(:);
end

C_month_average = mean(mean(C_month,4,'omitmissing'),3,'omitmissing');
C_month_average(isnan(C_month_average))=0;
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[0,0,580,976])

axes('position',[0.08 0.09 0.38+0.38 0.4+0.32]); 
 % axes('position',[0.05 0.10 0.38 0.35]);
pcolor(Lx,Lat_coast,C_month_average);shading interp;hold on;
[c,h] = contour(Lx,Lat_coast,Depto_lx,[200:200:2600],'LineWidth',0.5,'color','k','linestyle','-');hold on;
clabel(c,h,'LabelSpacing',1000,'color','k',...
        'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

xlim([0 150]);ylim([13 18]);

set(gca,'Xdir','reverse');
load('WhiteBlueGreenYellowRed.mat');colormap(WhiteBlueGreenYellowRed);hold on;
hold on;
cbar1=colorbar;
% set(cbar1,'Location','eastoutside','Ticks',[-0.05:0.025:0.05]);


set(cbar1,'Location','northoutside');
clim([0 0.015])
set(cbar1,'Ticks',[0:0.0025:0.015]);
cbar1.Ruler.Exponent = -3;
set(cbar1,'fontsize',20,'fontname','Arial', ...
    'Position', [0.2 0.83 0.5 0.039]);hold on;
set(get(cbar1,'Title'),'string',['$\langle  \overline{\textbf{\textit{C}}} \rangle \; W \; m^{-2}$'],'fontsize',21,'Interpreter','latex');
set(gca,'fontsize',21,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','YAxisLocation','right',...
'Xdir','reverse','XTick',[0:10:150],'Layer','top');  

img=getframe(gcf);
imwrite(img.cdata,['Monthly_average_results/Coastal_coordinate_generation.tiff'], 'tiff', 'Resolution', 300)


D_month_average = mean(mean(R_month,4,'omitmissing'),3,'omitmissing');
D_month_average(isnan(D_month_average))=0;
% 
% figure(2);clf;set(gcf,'color','w');set(gcf,'position',[0,0,580,976])
% axes('position',[0.08 0.09 0.38+0.38 0.4+0.32]); 
%  % axes('position',[0.05 0.10 0.38 0.35]);
% pcolor(Lx,Lat_coast,D_month_average);shading interp;hold on;
% [c,h] = contour(Lx,Lat_coast,Depto_lx,[200:200:2600],'LineWidth',0.5,'color','k','linestyle','-');hold on;
% clabel(c,h,'LabelSpacing',1000,'color','k',...
%         'fontsize',8,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
% 
% xlim([0 150]);ylim([13 18]);
% 
% set(gca,'Xdir','reverse');
% load('WhiteBlueGreenYellowRed.mat');colormap(WhiteBlueGreenYellowRed);hold on;
% hold on;
% cbar1=colorbar;
% % set(cbar1,'Location','eastoutside','Ticks',[-0.05:0.025:0.05]);
% 
% 
% set(cbar1,'Location','northoutside');
% clim([0 0.0125])
% set(cbar1,'Ticks',[0:0.0025:0.0125]);
% cbar1.Ruler.Exponent = -3;
% set(cbar1,'fontsize',20,'fontname','Arial', ...
%     'Position', [0.2 0.83 0.5 0.039]);hold on;
% set(get(cbar1,'Title'),'string',['$\langle  \overline{\textbf{\textit{D}}} \rangle \; W \; m^{-2}$'],'fontname','Arial','fontweight','bold','fontsize',21,'Interpreter','latex');
% set(gca,'fontsize',21,'LineWidth',2,'fontname','Arial',...
% 'Xaxislocation','bottom','fontweight','bold','YAxisLocation','right',...
% 'Xdir','reverse','XTick',[0:10:150],'Layer','top');  

% img=getframe(gcf);
% imwrite(img.cdata,['Monthly_average_results/Coastal_coordinate_dissipation.tiff'], 'tiff', 'Resolution', 300)

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

le_nda = length([1:244]);
nda_index= [1:244];
le_sda = length([245:338]);
sda_index= [245:338];

% Slope_index_nda = [1:29];% 50km
Slope_index_nda = [30:85];% 50km
CVP_index_nda = [86:200];

% Slope_index_sda = [1:50];% 100km
Slope_index_sda = [51:85];% 100km
CVP_index_sda = [86:200];


[TT,LAT_nda] = meshgrid(xt,lat_coast(nda_index));

% Mean along distance for along-lat distribution
%
R_alonglat_nda(:,:,:) = mean(R_month(:,nda_index,:,:),1,'omitmissing');
R_alonglat_nda = reshape(R_alonglat_nda,[le_nda,12*3]);


R_alonglat_sda(:,:,:) = mean(R_month(:,sda_index,:,:),1,'omitmissing');
R_alonglat_sda = reshape(R_alonglat_sda,[le_sda,12*3]);


%%
% Mean along lattitude for along-lat distribution
clear Fu_alongdis_nda R_alongdis_nda Fu_alongdis_sda R_alongdis_sda
% Fu_alongdis_nda(:,:,:) = nanmean(u_flux_month(:,nda_index,:,:),2);
% Fu_alongdis_nda = reshape(Fu_alongdis_nda,[Grid_range,12*3]);

R_alongdis_nda(:,:,:) = mean(R_month(:,nda_index,:,:),2,'omitmissing');
R_alongdis_nda = reshape(R_alongdis_nda,[Grid_range,12*3]);

C_alongdis_nda(:,:,:) = mean(C_month(:,nda_index,:,:),2,'omitmissing');
C_alongdis_nda = reshape(C_alongdis_nda,[Grid_range,12*3]);

CS_alongdis_nda = slope_month(:,nda_index,:,:);
slope_shading = CS_alongdis_nda;
slope_shading(CS_alongdis_nda<0.8)=0;
slope_shading(CS_alongdis_nda>=0.8 & CS_alongdis_nda<=1.5)=0;
slope_shading(CS_alongdis_nda>=1.5)=2;
slope_shading(isnan(CS_alongdis_nda))=0;
CS_alongdis_nda = sum(slope_shading,2,'omitmissing');
CS_alongdis_nda = reshape(CS_alongdis_nda,[Grid_range,12*3]);
CS_alongdis_nda(CS_alongdis_nda==0)=nan;
% figure(1);
% [TT_1,LL] = meshgrid(xt,mean(Lx,2));
% pcolor(LL,TT_1,CS_alongdis_nda);shading interp;hold on;
% clim([0 20])




%%

R_alongdis_sda(:,:,:) = mean(R_month(:,sda_index,:,:),2,'omitmissing');
R_alongdis_sda = reshape(R_alongdis_sda,[Grid_range,12*3]);

C_alongdis_sda(:,:,:) = mean(C_month(:,sda_index,:,:),2,'omitmissing');
C_alongdis_sda = reshape(C_alongdis_sda,[Grid_range,12*3]);


CS_alongdis_sda = slope_month(:,sda_index,:,:);
slope_shading = CS_alongdis_sda;
slope_shading(CS_alongdis_sda<0.8)=0;
slope_shading(CS_alongdis_sda>=0.8 & CS_alongdis_sda<=1.5)=0;
slope_shading(CS_alongdis_sda>=1.5)=2;
slope_shading(isnan(CS_alongdis_sda))=0;
CS_alongdis_sda = sum(slope_shading,2,'omitmissing');
CS_alongdis_sda = reshape(CS_alongdis_sda,[Grid_range,12*3]);
CS_alongdis_sda(CS_alongdis_sda==0)=nan;

load('cmp_b2r.mat');
%%


% for i=1:size(CS_NDA_regular,1)
%     S(i,:) = 1 + 200 * normalize(CS_NDA_regular(i,:),'range');
% end
[TT_1,LL] = meshgrid(xt,mean(Lx,2));
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[0,0,1300,985])
xx_cs = [0:10:200];
[TT_cs,LL_cs] = meshgrid(xt,xx_cs);
CS_NDA_regular = interp2(TT_1,LL,CS_alongdis_nda,TT_cs,LL_cs);
S = zeros(size(CS_NDA_regular));

F1 =  axes('position',[0.05 0.51-0.05 0.38 0.4]); 
pcolor(LL,TT_1,C_alongdis_nda);shading interp;hold on;
% contour(LL, TT_1,CS_alongdis_nda,[20,40],'linewidth',1,'color','k');
% scatter(LL_cs(:,1:3:end), TT_cs(:,1:3:end),S(:,1:3:end), ...
%         '-', ...
%         'MarkerFaceColor', 'none', ...   % 不填充，只画边
%         'MarkerEdgeColor', 'k', ...
%         'LineWidth', 1.5, ...
%         'MarkerEdgeAlpha', 0.8);

Lmax = 5; 
S = normalize(CS_NDA_regular,'range');
hold on
for i = 1:length(LL_cs(:))
    x0 = LL_cs(i);
    y0 = TT_cs(i);
    L = Lmax * S(i);   % 横条长度

    plot([x0, x0+L], [y0, y0], ...
         'k-', 'LineWidth', 2);   % 横条
end


set(F1,'fontsize',21,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','Xdir','reverse');
load('WhiteBlueGreenYellowRed.mat');colormap(F1,WhiteBlueGreenYellowRed);hold on;
hold on;clim([-0.01 0.01]);clim([0 0.005])
set(F1,'XTick',[0:10:350]);
datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F1,'YTick',xt(1:3:end),'YTickLabel',datestr(xt(1:3:end),'mmm'),'XTickLabel',{' '});
F1.YAxis.MinorTick="on"
F1.YAxis.MinorTickValues = xt(1:1:end);
F1.YAxis.TickLength = [0.03 0.02]

grid on;set(F1,'GridLineWidth',0.3,'GridLineStyle','--')
set(gca,'Layer','top');xlim([0 150])
cbar1=colorbar;
set(cbar1,'Location','northoutside','Ticks',[0:0.001:0.005]);
cbar1.Ruler.Exponent = -3;
set(cbar1,'fontsize',20,'fontname','Arial','Position',...
    [0.1 0.87 0.260833333333335 0.0268536342094262]);hold on;
%set(get(cbar,'Title'),'string',['$\mathbf{F_x} (kW \ m^{-1})$'],'Interpreter','latex');
set(get(cbar1,'Title'),'string',['$\langle  \overline{\textbf{\textit{C}}} \rangle \; (W \; m^{-2})$'],'Interpreter','latex','fontsize',21, ...
    'Position',[127.1562500000008,43.42741285331538,0]);
plot([0,150],[datenum(2015,01,01),datenum(2015,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');
plot([0,150],[datenum(2016,01,01),datenum(2016,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');
% load('MPL_RdPu.mat');colormap(F1,MPL_RdPu);hold on;
% load('MPL_Purples.mat');colormap(F1,MPL_Purples);hold on;


CS_SDA_regular = interp2(TT_1,LL,CS_alongdis_sda,TT_cs,LL_cs);
S = zeros(size(CS_SDA_regular));

F2 = axes('position',[0.05 0.10 0.38 0.35]);
pcolor(LL,TT_1,C_alongdis_sda);shading interp;hold on;
set(F2,'fontsize',21,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','Xdir','reverse');   
load('WhiteBlueGreenYellowRed.mat');colormap(F2,WhiteBlueGreenYellowRed);hold on;
hold on;clim([0 0.02])
Lmax = 5; 
S = normalize(CS_SDA_regular,'range');
hold on
for i = 1:length(LL_cs(:))
    x0 = LL_cs(i);
    y0 = TT_cs(i);
    L = Lmax * S(i);  
    plot([x0, x0+L], [y0, y0], ...
         'k-', 'LineWidth', 2);   % horziontal bar
end

datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F2,'YTick',xt(1:3:end),'YTickLabel',datestr(xt(1:3:end),'mmm'));
F2.YAxis.MinorTick="on"
F2.YAxis.MinorTickValues = xt(1:1:end);
F2.YAxis.TickLength = [0.03 0.02]
grid on;set(F2,'GridLineWidth',0.5,'GridLineStyle','--')
set(gca,'Layer','top');
set(F2,'XTick',[0:10:150]);
xlim([0 150]);
cbar2=colorbar;
set(cbar2,'Ticks',[0:0.005:0.02],'location','northoutside','AxisLocation','in');
cbar2.Ruler.Exponent = -2;
set(cbar2,'fontsize',15,'fontname','Arial','Position',...
    [0.31 0.11 0.1 0.02]);hold on;
% set(get(cbar2,'Title'),'string',['$\langle  \overline{\textbf{\textit{C}}} \rangle \; (W \; m^{-2})$'],'Interpreter','latex','fontsize',20);

plot([0,150],[datenum(2015,01,01),datenum(2015,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');
plot([0,150],[datenum(2016,01,01),datenum(2016,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');



F3 =  axes('position',[0.50 0.51-0.05 0.38 0.4]); 
pcolor(LL,TT_1,R_alongdis_nda);shading interp;hold on;
set(F3,'fontsize',21,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','Xdir','reverse');  
load('WhiteBlueGreenYellowRed.mat');colormap(F3,WhiteBlueGreenYellowRed);hold on;
hold on;clim([0 0.01])

Lmax = 5; 
S = normalize(CS_NDA_regular,'range');
hold on
for i = 1:length(LL_cs(:))
    x0 = LL_cs(i);
    y0 = TT_cs(i);
    L = Lmax * S(i);   % 横条长度

    plot([x0, x0+L], [y0, y0], ...
         'k-', 'LineWidth', 2);   % 横条
end

% load('NCV_blue_red.mat');colormap(F3,NCV_blue_red);hold on;
% load('cmp_b2r.mat');colormap(F3,cmp_b2r);
set(F3,'XTick',[0:10:350]);
datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F3,'YTick',xt(1:3:end),'YTickLabel',datestr(xt(1:3:end),'mmm'),'XTickLabel',{' '});
F3.YAxis.MinorTick="on"
F3.YAxis.MinorTickValues = xt(1:1:end);
F3.YAxis.TickLength = [0.03 0.02]
grid on;set(F3,'GridLineWidth',0.3,'GridLineStyle','--')
set(gca,'Layer','top');xlim([0 150])
cbar3=colorbar;
set(cbar3,'Location','northoutside','Ticks',[0:0.002:0.01]);
cbar3.Ruler.Exponent = -2;
set(cbar3,'fontsize',20,'fontname','Arial','Position',...
    [0.55 0.87 0.260833333333335 0.0268536342094262]);hold on;
%set(get(cbar,'Title'),'string',['$\mathbf{F_x} (kW \ m^{-1})$'],'Interpreter','latex');
set(get(cbar3,'Title'),'string',['$\langle  \overline{\textbf{\textit{D}}} \rangle \; (W \; m^{-2})$'],'Interpreter','latex','fontsize',21, ...
    'Position',[127.1562500000008,43.42741285331538,0]);
plot([0,150],[datenum(2015,01,01),datenum(2015,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');
plot([0,150],[datenum(2016,01,01),datenum(2016,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');


F4 =axes('position',[0.50 0.10 0.38 0.35]); % southeast  
pcolor(LL,TT_1,R_alongdis_sda);shading interp;hold on;
% contourf(LL,TT_1,R_alongdis_sda,20,'linestyle','none');hold on;
set(F4,'fontsize',21,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','Xdir','reverse');   
load('WhiteBlueGreenYellowRed.mat');colormap(F4,WhiteBlueGreenYellowRed);hold on;
Lmax = 5; 
S = normalize(CS_SDA_regular,'range');
hold on
for i = 1:length(LL_cs(:))
    x0 = LL_cs(i);
    y0 = TT_cs(i);
    L = Lmax * S(i);  
    plot([x0, x0+L], [y0, y0], ...
         'k-', 'LineWidth', 2);   % horziontal bar
end
hold on;clim([0 0.01])
datetick('y', 'mm', 'keeplimits'); % 把 X 轴格式化成时间
set(F4,'YTick',xt(1:3:end),'YTickLabel',datestr(xt(1:3:end),'mmm'));
F4.YAxis.MinorTick="on"
F4.YAxis.MinorTickValues = xt(1:1:end);
F4.YAxis.TickLength = [0.03 0.02]
grid on;set(F4,'GridLineWidth',0.3,'GridLineStyle','--')
set(gca,'Layer','top');
set(F4,'XTick',[0:10:150]);
xlim([0 150]);
plot([0,150],[datenum(2015,01,01),datenum(2015,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');
plot([0,150],[datenum(2016,01,01),datenum(2016,01,01)], ...
    'linewidth',1.5,'linestyle','-.','color','k');

save Energy_rate_alongcoast.mat C_alongdis_nda C_alongdis_sda R_alongdis_nda R_alongdis_sda TT_1 LL

exportgraphics(gcf,['Monthly_average_results/GenDis_coast_monthly.tiff'], 'Resolution',300);