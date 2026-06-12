clear;clc;close all
% hourly data
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
%%
addpath ../../Grid/
load('MPL_RdYlBu_r.mat')
load('NCV_jaisnd.mat')
load('BlueWhiteOrangeRed.mat')

load('Grid_info.mat','ke','weto_p','zzout','ddpo_grid','latp_grid','lonp_grid')
load('Grid_info_w.mat','zzout_w')
i_cvoo = 166; j_cvoo = 110; % from global matrix

lat_mooring = latp_grid(i_cvoo,j_cvoo);
lon_mooring = lonp_grid(i_cvoo,j_cvoo);

ke_index = 63;

THO_mooring=[];THO_month=zeros(ke,12);
SAO_mooring=[];SAO_month=zeros(ke,12);
ROO_mooring=[];ROO_month=zeros(ke,12);
time =[];
for m_select = 1:12
    name_tracer = ['./mat_file/CVOO_tracer_',month_file{m_select},'_CVCTM.mat'];
    load(name_tracer,'tho_time','sao_time','roo_time');
    load(['Time_info_',month_file{m_select},'.mat']);
    if m_select == 2
        tho_time(:,673:end)=[];
        sao_time(:,673:end)=[];
        roo_time(:,673:end)=[];
        SDtime_range(673:end)=[];
    end

    THO_month(:,m_select)=nanmean(tho_time,2);
    SAO_month(:,m_select)=nanmean(sao_time,2);
    ROO_month(:,m_select)=nanmean(roo_time,2);
    
    THO_mooring = [THO_mooring,tho_time];
    SAO_mooring = [SAO_mooring,sao_time];
    ROO_mooring = [ROO_mooring,roo_time];    
    time = [time,SDtime_range];
end

THO_month(64:end,:)=[];
SAO_month(64:end,:)=[];
ROO_month(64:end,:)=[];

THO_mooring(64:end,:)=[];
SAO_mooring(64:end,:)=[];
ROO_mooring(64:end,:)=[];

TE = size(THO_mooring,2);
z = squeeze(zzout(i_cvoo,j_cvoo,1:ke_index));
z_w = squeeze(zzout_w(i_cvoo,j_cvoo,1:ke_index+1));
delZ = squeeze(ddpo_grid(i_cvoo,j_cvoo,1:ke_index));

S_time = datenum(2014,01,01,0,0,0);
E_time = datenum(2014,12,31,23,0,0);

weto = zeros(ke_index,TE);
for tt = 1:TE
    weto(:,tt) = weto_p(i_cvoo,j_cvoo,1:ke_index);
end
THO_mooring(weto==0)=nan;
SAO_mooring(weto==0)=nan;
ROO_mooring(weto==0)=nan;

%% Buoyancy frequecny
Z (:)= [0;z;sum(delZ)];
Z_w(:)= [z_w];
P_w(:) = sw_pres(Z_w,lat_mooring);
Nsquare_month = zeros(size(THO_month));
for m=1:12

 
     T(:) = [squeeze(THO_month(1,m));... 
               squeeze(THO_month(:,m));...
               squeeze(THO_month(end,m))];  
     S(:) = [squeeze(SAO_month(1,m));... 
               squeeze(SAO_month(:,m));...
               squeeze(SAO_month(end,m))];        

      T_w(:) = interp1(Z,T,Z_w,'linear'); % length is bottom_index(i,j) + 1
      S_w(:) = interp1(Z,S,Z_w,'linear'); % length is bottom_index(i,j) + 1
       
      [N2,~,p_ave] = sw_bfrq(S_w,T_w,P_w,lat_mooring);
      Z_new = sw_dpth(p_ave',lat_mooring);
      N_result = interp1(Z_new, N2 ,z,'linear');
      Nsquare_month(:,m) = Check_Nsquare(N_result', z);
end
% pcolor(Nsquare_month);shading interp;
save CVOO_month_2014.mat Nsquare_month THO_month SAO_month ROO_month -v7.3
%% pic stratification
tho_upwelling = mean(THO_mooring(:,1:4),2);
tho_relaxation = mean(THO_mooring(:,5:9),2);

figure(2);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 350]);
hold on;plot(tho_upwelling,z,'r');
hold on;plot(tho_relaxation,z,'b');
set(gca,'YDir','reverse');ylog;





%% test
S_time = datenum(2014,02,01,0,0,0);
E_time = datenum(2014,02,28,0,0,0);

t_s = find (time == S_time);
t_e = find (time == E_time);
t_se = [t_s:1:t_e]; te = length(t_se);
TO = THO_mooring(:,t_s:t_e);

run_perday = 24;
formatOut = 'mm-dd';
DAY = time([t_s:run_perday:t_e]);
day_indx = t_s;
for t = 1 : 1 : length(DAY)
    xdate{t} =  datestr(time(day_indx),formatOut);
    day_indx = day_indx + run_perday;
end
% vertical interpolation
firstLevel = min(z);
lastLevel = max(z);

d_inter = [30:10:1000]'; % vertial grid 
T_inter = zeros(size(d_inter,1),size(TO,2));
for t=1:size(TO,2)
    TO_inter(:,t)= interp1(z,TO(:,t),d_inter,'linear');
end
t = t_se;
[TT,ZZ] = meshgrid(t,d_inter);

figure(1);clf;set(gcf,'color','w');
set(gcf,'position',[50 50 500 350]);
% pcolor(TT,ZZ,TO_inter_ana);shading interp;hold on;
% pcolor(TT,ZZ,TO_inter);shading interp;hold on;
contourf(TT,ZZ,TO_inter,[3.5,4:1:20],'LineStyle','-','LineWidth',1.5,'color','k')
hold on;
clim([3 18]);

colormap(jet);
colormap(NCV_jaisnd);

h2=colorbar('eastoutside','fontsize',10);
set(h2,...
    'LineWidth',1.0)
set(get(h2,'Title'),'string','°C','fontname','Arial');

% axis([xx(1)-24 xx(end)+24 ,min(min(yy)) max(max(yy))])
axis([TT(1)-run_perday TT(end)+run_perday ,10 1000])
% axis([tt(1)-10000 tt(end)+10000 ,750 1350])
set(gca,'fontsize',10,'LineWidth',2,'fontname','Arial',...
'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');   
set(gca,'fontsize',10,'XTick',[t_s:run_perday:t_e],'XTickLabel',xdate,'LineWidth',2,'fontname','Arial',...
    'YTick',[0:100:4000],'Ydir','reverse','Xaxislocation','bottom','fontweight','bold');

set(gca,'Layer','top');grid on
set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

xlabel('Time','fontsize',10,'fontname','Arial')
ylabel('Depth(m)','fontsize',10,'fontname','Arial')  
%% 




