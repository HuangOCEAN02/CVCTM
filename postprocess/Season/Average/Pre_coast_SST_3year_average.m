clear;clc;close all
addpath ../../Grid/
load('MSS_coast_index.mat');
Location='./Coast';
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
time =[];
for m_select=1:12
    load(['Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time = [time,SDtime_range];
end
Time = datetime(time,'ConvertFrom','datenum');

load('Coast_SST_detide.mat','sst_detide_hourly');
load('Coast_SSH_detide.mat','ssha_detide_hourly');
sst_detide_hourly_2014 = sst_detide_hourly;
ssha_detide_hourly_2014 = ssha_detide_hourly;

load('../../../../../2015/Withtide/post_process/Season/Average/Coast_SST_detide.mat','sst_detide_hourly');
load('../../../../../2015/Withtide/post_process/Season/Average/Coast_SSH_detide.mat','ssha_detide_hourly');
sst_detide_hourly_2015 = sst_detide_hourly;
ssha_detide_hourly_2015 = ssha_detide_hourly;
time_2015 = [];
for m_select=1:12
    load(['../../../../../2015/Withtide/post_process/Grid/Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time_2015 = [time_2015,SDtime_range];
end
Time_2015 = datetime(time_2015,'ConvertFrom','datenum');


load('../../../../../2016/Withtide/post_process/Season/Average/Coast_SST_detide.mat','sst_detide_hourly');
load('../../../../../2016/Withtide/post_process/Season/Average/Coast_SSH_detide.mat','ssha_detide_hourly');
sst_detide_hourly_2016 = sst_detide_hourly;
ssha_detide_hourly_2016 = ssha_detide_hourly;
time_2016 = [];
for m_select=1:12
    load(['../../../../../2016/Withtide/post_process/Grid/Time_info_',month_file{m_select},'.mat']);
    if m_select==2
        SDtime_range(673:end)=[];
    end
    time_2016 = [time_2016,SDtime_range];
end
Time_2016 = datetime(time_2016,'ConvertFrom','datenum');
%% Average
sst_detide_hourly = sst_detide_hourly_2014 + sst_detide_hourly_2015 +sst_detide_hourly_2016;
ssha_detide_hourly = ssha_detide_hourly_2014 + ssha_detide_hourly_2015 + ssha_detide_hourly_2016;
sst_detide_hourly = sst_detide_hourly./3;
ssha_detide_hourly= ssha_detide_hourly./3;
%% connecting
% sst_detide_hourly = [sst_detide_hourly_2014,sst_detide_hourly_2015,sst_detide_hourly_2016];
% ssha_detide_hourly = [ssha_detide_hourly_2014,ssha_detide_hourly_2015,ssha_detide_hourly_2016];
% time = [time,time_2015,time_2016];
% Time =[Time,Time_2015,Time_2016];
%%
clear Time_2015 Time_2016 time_2015 time_2016
clear sst_detide_hourly_2014 ssha_detide_hourly_2014
clear sst_detide_hourly_2015 ssha_detide_hourly_2015
clear sst_detide_hourly_2016 ssha_detide_hourly_2016

[TT,LAT] = meshgrid(time,lat_coast);
figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 1150 990])
F1 = axes('position',[0.12 0.5 0.75 0.48]);
pcolor(TT,LAT,sst_detide_hourly);shading interp;hold on;
colormap(F1,"turbo");
[c,h]=contour(TT,LAT,ssha_detide_hourly.*100,[0,0],...
    'linewidth',1,'color','k','linestyle','-.');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
[c,h]=contour(TT,LAT,ssha_detide_hourly*100,[3,3],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
[c,h]=contour(TT,LAT,ssha_detide_hourly*100,[-3,-3],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',700,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')

 
 clim([16 30]);
ylim([14.8 18.3])
xlim([time(1) time(end)])
% ylim([13 18.3])
t0 = dateshift(Time(1),'start','month');   % 第一个月的1号
t1 = dateshift(Time(end),'start','month'); % 最后一个月的1号
xt = datenum(t0:calmonths(1):t1);       % 每月一个

set(gca,'XTick',xt,'XTickLabel',{' '})
% datetick('x', 'mmm', 'keeplimits'); % 把 X 轴格式化成时间
% set(gca,'XTickLabel',{' '});
set(gca,'Layer','top');
set(gca,'fontsize',30,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  
set(F1,'fontsize',30,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold'); 
% ylabel('Latitude(°N)','FontSize',25,'fontname','Arial','fontweight','bold')



F2 = axes('position',[0.12 0.1 0.75 0.36]);
pcolor(TT,LAT,sst_detide_hourly);shading interp;hold on;
set(F2,'fontsize',30,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');  
colormap(F2,"turbo");

[c,h]=contour(TT,LAT,ssha_detide_hourly.*100,[0,0],...
    'linewidth',1,'color','k','linestyle','-.');hold on;
 clabel(c,h,'LabelSpacing',200,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
[c,h]=contour(TT,LAT,ssha_detide_hourly*100,[3,3],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',200,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')
[c,h]=contour(TT,LAT,ssha_detide_hourly*100,[-3,-3],...
    'linewidth',2,'color','k','linestyle','-');hold on;
 clabel(c,h,'LabelSpacing',400,'color','k',...
     'fontsize',28,'fontname','Times New Roman','FontSmoothing','on','fontweight','bold')


ylim([13 14.6])
xlim([time(1) time(end)])
 set(F2,'XTick',xt,'XTickLabel',datestr(xt,'m'));
% set(F2,'Layer','top','fontweight','bold');
% datetick('x', 'mmm', 'keeplimits'); % 把 X 轴格式化成时间

clim([16 30]);
bar = colorbar;
set(bar,'fontsize',30,'fontname','Arial','fontweight','bold','linewidth',2,'Position',...
    [0.894576435665815 0.313937753721245 0.0277312566418774 0.437753684200187]);hold on;
set(get(bar,'Title'),'string','°C','fontname','Arial','fontweight','bold','fontsize',25);
set(bar,'Ticks',[16:2:30]);
set(gca,'Layer','top');

% 
% annotation(figure(3),'textbox',...
%     [0.13 0.020 0.058047619047619 0.0230040595399188],...
%     'String','NDA',...
%     'LineStyle','none',...
%     'FontSize',25,...
%     'FontName','Arial','fontweight','bold',...
%     'FitBoxToText','off');
% annotation(figure(3),'textbox',...
%     [0.387 0.020 0.058047619047619 0.0230040595399188],...
%     'String','2015',...
%     'LineStyle','none',...
%     'FontSize',25,...
%     'FontName','Arial','fontweight','bold',...
%     'FitBoxToText','off');
% annotation(figure(3),'textbox',...
%     [0.633 0.020 0.058047619047619 0.0230040595399188],...
%     'String','2016',...
%     'LineStyle','none',...
%     'FontSize',25,...
%     'FontName','Arial','fontweight','bold',...
%     'FitBoxToText','off');
exportgraphics(gcf,[Location,'/SST_MSS_3year_average.tiff'], 'Resolution',300);
