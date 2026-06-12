clear;clc;close all
%% Time
%% 2011 UP
load('../2011/UP/Time_info.mat', 'SDtime');
load('../2011/UP/PE_KE/Model_Energy_timeseries.mat');
S_time = datenum(2011,01,05,0,0,0);
E_time = datenum(2011,06,29,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
te = 0;
te = te + length([t_s:t_e]);
KE_time = KE;
% PE_time = PE;
SPINUP_time = [datenum(2011,01,01,0,0,0),SDtime];
%% 2011 DOWN
clear KE
load('../2011/DOWN/Time_info_case.mat', 'SDtime');
load('../2011/DOWN/PE_KE/Model_Energy_timeseries.mat');
S_time = datenum(2011,07,04,0,0,0);
E_time = datenum(2011,12,31,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
te = te + length([t_s:t_e]);
% KE(1) = (KE(1)*5*86400/40 + KE(2)*5*86400/40 + KE_time(end)*5*86400/40)/(14*86400/40);
KE(1) =(KE(2)+KE_time(end))/2;
KE_time = [KE_time,KE];
%PE_time = [PE_time,PE];
SPINUP_time= [SPINUP_time,SDtime];
%% 2012 UP
clear KE
load('../2012/UP/Time_info_case.mat', 'SDtime');
load('../2012/UP/PE_KE/Model_Energy_timeseries.mat');
S_time = datenum(2012,01,04,0,0,0);
E_time = datenum(2012,6,27,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
te = te + length([t_s:t_e]);
KE_time = [KE_time,KE];
% PE_time = [PE_time,PE];
SPINUP_time= [SPINUP_time,SDtime];
%% 2012 DOWN
clear KE
load('../2012/DOWN/Time_info_case.mat', 'SDtime');
load('../2012/DOWN/PE_KE/Model_Energy_timeseries.mat');
S_time = datenum(2012,07,04,0,0,0);
E_time = datenum(2012,12,31,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
te = te + length([t_s:t_e]);
KE(1) =(KE(2)+KE_time(end))/2;
% PE(1) = (PE(2)+PE_time(end))/2;
KE_time = [KE_time,KE];
% PE_time = [PE_time,PE];
SPINUP_time= [SPINUP_time,SDtime];
%% 2013 UP
load('./Up/Time_info_case.mat', 'SDtime');
load('./Up/PE_KE/Model_Energy_timeseries.mat');
S_time = datenum(2013,01,04,0,0,0);
E_time = datenum(2013,06,28,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
te = te + length([t_s:t_e]);
KE(1) =(KE(2)+KE_time(end))/2;
KE_time = [KE_time,KE];
% PE_time = [PE_time,PE];
SPINUP_time= [SPINUP_time,SDtime];
%% 2013 Down
load('./Down/Time_info_case.mat', 'SDtime');
load('./Down/PE_KE/Model_Energy_timeseries.mat');
% KE_5days = retime(timetable(datetime(SDtime,'ConvertFrom','datenum')',KE'),'regular','mean','TimeStep',days(5));
% PE_5days = retime(timetable(datetime(SDtime,'ConvertFrom','datenum')',PE'),'regular','mean','TimeStep',days(5));
S_time = datenum(2013,07,04,0,0,0);
E_time = datenum(2013,12,31,0,0,0);
t_s = find ( SDtime == S_time);
t_e = find ( SDtime == E_time);
% te = te + length(PE_5days.Var1);
te = te + length([t_s:t_e]);
KE(1) =(KE(2)+KE_time(end))/2;
KE_time = [KE_time,KE];
SPINUP_time= [SPINUP_time,SDtime];
% KE_time = [KE_time,KE_5days.Var1'];
% PE_time = [PE_time,KE_5days.Var1'];
% SPINUP_time= [SPINUP_time,SDtime(1:5:end)];
%%
t_min = datetime('2011-01-01 00:00:00','Locale','en_US');
t_max = datetime('2014-01-01 00:00:00','Locale','en_US');

start_date = datetime('2011-01-01 00:00:00','Locale','en_US');
end_date = datetime('2014-01-01 00:00:00','Locale','en_US');

% x_period_dates=[start_date:days(30):end_date];
x_period_dates=[start_date:calmonths(1):end_date];
x_dates_label_major=string(x_period_dates);

x_period_minor_dates = [start_date:days(5):end_date];

%%
% xx = [0:5:te*5];

xx_time = datetime(SPINUP_time,'ConvertFrom','datenum');


figure(3);clf;set(gcf,'color','w');set(gcf,'position',[5 5 900 200])

h=plot(xx_time,[0,KE_time]);
set(h,'LineStyle','-','color','k','linewidth',2);
hold on;
% plot([datetime('2011-01-01 00:00:00'),datetime('2011-01-01 00:00:00')],...
%     [0,4e+8],'k--','linewidth',2);hold on;
plot([datetime('2012-01-01 00:00:00'),datetime('2012-01-01 00:00:00')], ...
    [0,18e+15],'k--','linewidth',2);hold on;
plot([datetime('2013-01-01 00:00:00'),datetime('2013-01-01 00:00:00')], ...
    [0,18e+15],'k--','linewidth',2);hold on;

title(['Kinetic Energy'],'fontsize',20,'fontname','Arial','fontweight','bold','color','k','Interpreter','latex');
ylabel(['$ KE  \ (J)$'],'fontsize',18,'fontname','Arial','fontweight','bold','color','k','Interpreter','latex')
xlabel('Time','fontsize',18,'fontname','Arial')  
ylim([0 1.6e+16])


ax=gca;
ax.YAxis.TickValues=[0:0.4e+16:1.6e+16];
ax.XAxis.TickValues =x_period_dates;
ax.XAxis.TickLabel={' '};
ax.YAxis.Exponent = 16;
xtickformat('M')
ax.XMinorTick = 'off';
ax.XAxis.MinorTickValues = x_period_minor_dates;  % 每 0.5 个单位一个次要刻度
set(gca,'GridLineStyle','-.','GridLineWidth',1.2,'GridAlpha',0.3);grid on

set(gca,'MinorGridLineStyle','-.','MinorGridLineWidth',1.2,'MinorGridAlpha',0.3);
grid on
set(gca,'linewidth',2,'fontsize',18,'fontname','Arial','fontweight','bold');
xlim([xx_time(1) xx_time(214)])
img=getframe(gcf);
imwrite(img.cdata,['Three_year_spin_up_KE.tiff'], 'tiff', 'Resolution', 300)
%%
load('/Users/josephhuang/Desktop/workingplace/风场试验/Spin_up/2013_Dec_tide/4Dec_snapshot/SST/BT_KE_Energy.mat','BT_KE_energy','KE');
load('../2013_Dec/4Dec_snapshot/Time_info_case.mat', 'SDtime');
BT_KE_energy= BT_KE_energy;
x_tide = datetime(SDtime,'ConvertFrom','datenum');
x_period_dates=[x_tide(1):days(5):x_tide(end)];
x_dates_label_major=string(x_period_dates);
BT_KE_energy_5_days  = movmean(BT_KE_energy,5*24);


KE_origin = timetable(x_tide(:),BT_KE_energy(:),KE(:));

% 
% 
% H=axes;
% set(H,'Position',[0.68 0.34 0.222560975609756 0.1975])
% hold(H,'on');
% axis on;set(gca,'Layer','top','fontname','Arial','linewidth',1.0,...
%             'XColor','b','YColor','b');grid on
% pg = plot([1:744],KE_origin.Var1,'r-','linewidth',1);hold on;
% % pg_ave = plot([1:744],BT_KE_energy_5_days,'r-','linewidth',1);
% ax=gca;xlog;ylog;
% xlim([1 744]);box on;
% % ax.XAxis.TickValues =x_period_dates;
% % ax.XAxis.TickLabel=x_dates_label_major;
% % xtickformat('dd');
% % xlim([x_tide(1) x_tide(end) ])
% grid(H,'on');
% hold(H,'off');
% ax.YAxis.Exponent = 12; 
% ylim([0 12e+12]);
% xlabel('Model time (hour) in Dec 2013','fontsize',20,'fontname','Arial')  
% set(gca,'fontname','Arial','fontweight','bold','fontsize',15)
% title(['The total KE of Barotropic Velocity'],'fontsize',20,'fontname','Arial','fontweight','bold','color','k','Interpreter','latex');
% set(gca,'GridLineStyle','-.','GridColor','b','GridAlpha',0.5)
% grid on;
% % leg = legend('$KE_{BT}$');set(leg, 'fontname','Arial','fontweight','bold','linewidth',1.5,'Interpreter','latex')
% 
% img=getframe(gcf);
% imwrite(img.cdata,['Three_year_spin_up_KE.tiff'], 'tiff', 'Resolution', 300)
%%
figure(4);clf;set(gcf,'color','w');set(gcf,'position',[5 5 900 200])
yyaxis left
pg = plot([1:744],KE_origin.Var2,'b-','linewidth',1);hold on;
set(gca,'Layer','top','fontname','Arial','linewidth',0.8,...
            'XColor','k','YColor','b');grid on
ax=gca;xlog;ylog;
xlim([1 744]);
ylim([0 18e+15]);
ylabel('$ KE  \ (J)$','fontsize',18,'fontname','Arial','fontweight','bold','color','b','Interpreter','latex')
% set(gca,'Xtick',[10^0,10^0.5,10^1,10^1.5,10^2.5]);
% ax.XAxis.TickValues =[10^0,10^0.5,10^1,10^1.5,10^2.5];
yyaxis right
pg = plot([1:744],KE_origin.Var1,'r-','linewidth',1);hold on;
set(gca,'Layer','top','fontname','Arial','linewidth',0.8,...
            'XColor','k','YColor','r');grid on
ylabel('$ KE^{ bt}  \ (J)$','fontsize',18,'fontname','Arial','fontweight','bold','color','r','Interpreter','latex')

% pg_ave = plot([1:744],BT_KE_energy_5_days,'r-','linewidth',1);
ax=gca;xlog;ylog;
xlim([1 744]);box on;
ylim([0 12e+15]);
% set(gca,'Xtick',[10^0,10^0.5,10^1,10^1.5,10^2.5]);
% ax.XAxis.TickValues =x_period_dates;
% ax.XAxis.TickLabel=x_dates_label_major;
% xtickformat('dd');
% xlim([x_tide(1) x_tide(end) ])

xlabel('Model time (hour) in Dec 2013','fontsize',18,'fontname','Arial')  
set(gca,'fontname','Arial','fontweight','bold','fontsize',15)
% title(['The KE of Barotropic Velocity'],'fontsize',18,'fontname','Arial','fontweight','bold','color','k','Interpreter','latex');
set(gca,'GridLineStyle','-.','GridColor','b','GridAlpha',0.3)
grid on;
set(gca,'linewidth',2,'fontsize',18,'fontname','Arial','fontweight','bold');
% annotation(figure(4),'textbox',...
%     [0.568750000000001 0.0100000000000001 0.452500000000001 0.175],...
%     'String','Model time (hour) in Dec 2013',...
%     'LineStyle','none',...
%     'FontSize',16,...
%     'FontName','Arial',...
%     'FitBoxToText','off');
img=getframe(gcf);
imwrite(img.cdata,['Dec_spin_up_KE.tiff'], 'tiff', 'Resolution', 300)