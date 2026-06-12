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
i_cvoo = 166; j_cvoo = 110; % from global matrix

lat_mooring = latp_grid(i_cvoo,j_cvoo);
lon_mooring = lonp_grid(i_cvoo,j_cvoo);

ke_index = 63;

UOO_mooring=[];%THO_month=zeros(ke,12);
VOE_mooring=[];%SAO_month=zeros(ke,12);
ZOO_mooring=[];%ROO_month=zeros(ke,12);
time =[];
for m_select = 1:12
    name_tracer = ['./mat_file/CVOO_velocity_',month_file{m_select},'_CVCTM.mat'];
    load(name_tracer,'uko_time','vke_time','zoo_time');
    load(['Time_info_',month_file{m_select},'.mat']);
    if m_select == 2
        uko_time(:,673:end)=[];
        vke_time(:,673:end)=[];
        zoo_time(673:end)=[];
        SDtime_range(673:end)=[];
    end

    % THO_month(:,m_select)=nanmean(tho_time,2);
    % SAO_month(:,m_select)=nanmean(sao_time,2);
    % ROO_month(:,m_select)=nanmean(roo_time,2);
    
    UOO_mooring = [UOO_mooring,uko_time];
    VOE_mooring = [VOE_mooring,vke_time];
    ZOO_mooring = [ZOO_mooring,zoo_time];    
    time = [time,SDtime_range];
end

% THO_month(64:end,:)=[];
% SAO_month(64:end,:)=[];
% ROO_month(64:end,:)=[];

UOO_mooring(64:end,:)=[];
VOE_mooring(64:end,:)=[];
ZOO_mooring(64:end,:)=[];

TE = size(UOO_mooring,2);
z = squeeze(zzout(i_cvoo,j_cvoo,1:ke_index));
delZ = squeeze(ddpo_grid(i_cvoo,j_cvoo,1:ke_index));

S_time = datenum(2014,01,01,0,0,0);
E_time = datenum(2014,12,31,23,0,0);

weto = zeros(ke_index,TE);
for tt = 1:TE
    weto(:,tt) = weto_p(i_cvoo,j_cvoo,1:ke_index);
end
UOO_mooring(weto==0)=nan;
VOE_mooring(weto==0)=nan;
ZOO_mooring(weto==0)=nan;
save CVOO_UOO_2014.mat UOO_mooring -v7.3;
save CVOO_VOE_2014.mat VOE_mooring -v7.3;
save CVOO_Grid.mat z delZ time
%% Spectrum
load('CVOO_month_2014.mat', 'Nsquare_month')
Nsquare_year = mean(Nsquare_month,2);
dt = 3600/86400; %Sampling interval dt in days
params= Gm76Params;
params.jstar=6;
params.Ef=0.055;
% N=5.23e-3     % 3cph = (3).*24 cpd

% params.N0 =5.23e-3 ; 

params.N0 = 1.5 * 2*pi / 3600;
N_cpd = params.N0 * 86400 / (2*pi);

figure(1);clf;set(gcf,'position',[10 10 800 450]);
for  k_level=13:1:13
z(k_level) % about 101m
cv = UOO_mooring(k_level,:);
N_level = sqrt(Nsquare_year(k_level));

cv = cv';
P=8;K=7;% 7
psi=sleptap(length(cv),P,K); 

[f,spp_u,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies

cv = VOE_mooring(k_level,:);
cv = cv';

[f,spp_v,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies

spp = spp_u + spp_v; % (m/s)^2 * days

spp = spp.* (params.N0)./N_level;


% f = f./86400; % cpm
% spp=spp.*86400; % (m/s)^2 * second



    [ra,rb]=mconf(2*P-1,0.95,'log10'); %compute confidence intervals
    h_ci=plot(f,[10^ra 10^rb].*spp);linestyle(h_ci,'C-');hold on
    set(h_ci,'LineWidth',1.0)
    h=plot(f,spp);xlim([f(2) f(end)]),xlog,ylog;hold on
    % ylim(10.^([-4 -1.8]))
    set(h(1),'linewidth',1.5,'color','k');hold on
%% GM
    fcor = sw_f(lat_mooring);
    f_GM_start = f(2) *2*pi/86400 ; %rad/s
    f_GM_end = f(end) *2*pi/86400;
    
    % N = f_GM_end;
    om = linspace(f_GM_start,f_GM_end,5000); % rad/s
    S = GmOm('Vel',om,fcor,N_level,params); % (m/s)^2 * rad/s
    
    S = S.* (params.N0)./N_level;
    % S = S.* max(sqrt(N2(:)))./N_level;
    om = om.*86400/(2*pi); % 
    S = S *(2*pi)/86400;
    
    hold on;
    h_GM=plot(om,S,'LineWidth',2,'color','b','LineStyle','-.');

    xlim([om(1)/3 om(end)])
    % vlines(N_level.*86400/(2*pi),':');
end
  xlim(10.^([-0.5 2.0]))
  ylim(10.^([-8 -2]))
    xlim([om(1)/3 om(end)])
vlines(corfreq(lat_mooring)/2/pi*24,'2r--')
vlines(tidefreq('m2')/2/pi*24,'2--');
vlines(tidefreq('s2')/2/pi*24,'1--');
% vlines(tidefreq('n2')/2/pi*24,'2--');
vlines((tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
% vlines((2*tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
vlines(tidefreq('K1')/2/pi*24,'1--');
vlines(tidefreq('O1')/2/pi*24,'1--');
vlines(2*tidefreq('m2')/2/pi*24,'1--');
vlines(3*tidefreq('m2')/2/pi*24,'1--');

% vlines(N_cpd,'2k--');
% vlines((tidefreq('m2')-corfreq(Lat_CVOO))/2/pi*24,'1--');

grid off;

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   

set(gca,'fontsize',25,'XTick',[10^0,10^1,10^2,10^3],'LineWidth',2,'fontname','Arial',...
    'Xaxislocation','bottom')

set(gca,'Layer','top');
set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.3)


set(gca,'Layer','top');
% set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

ylabel(['$\phi\ ','N_{0}/N','\ (m^2\ s^{-2}\ cpd^{-1})$'],'fontsize',28,'Interpreter','latex')
xlabel('Frequency (cpd)','fontsize',28,'fontname','Arial')  

