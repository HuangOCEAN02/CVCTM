clear;clc;close all
%% 2014 CVCM vs CVCTM vs KPO mooring 1128
load('MPL_RdYlBu_r.mat')
load('NCV_jaisnd.mat')
load('BlueWhiteOrangeRed.mat')
load('CVOO_site.mat')
%%  CVCTM
Um = [];
Vm =[];
To =[];
load('CVOO_UOO_2014.mat')
load('CVOO_VOE_2014.mat')
load('CVOO_Grid.mat')
Um = [Um;UOO_mooring];
Vm = [Vm;VOE_mooring];
To = [To,time];

To = datetime(To','ConvertFrom','datenum');
clear time 

Nsquare_time=[]
load('CVOO_month_2014.mat', 'Nsquare_month')
Nsquare_time = [Nsquare_time,Nsquare_month];

%%  CVCM
Um_CVCM = [];
Vm_CVCM =[];
To_CVCM =[];
load('../../../../WithoutTide/post_process/Season/CVOO/CVOO_UOO_2014.mat')
load('../../../../WithoutTide/post_process/Season/CVOO/CVOO_VOE_2014.mat')
load('../../../../WithoutTide/post_process/Season/CVOO/CVOO_Grid.mat')
Um_CVCM = [Um_CVCM;UOO_mooring_CVCM];
Vm_CVCM = [Vm_CVCM;VOE_mooring_CVCM];

clear time 
Nsquare_time_CVCM=[]
load('../../../../WithoutTide/post_process/Season/CVOO/CVOO_month_2014.mat', 'Nsquare_month_CVCM')
Nsquare_time_CVCM = [Nsquare_time,Nsquare_month_CVCM];




%% Time correct
load('./mooring_file/CVOO_ADCP_grid.mat');
load('./mooring_file/CVOO_ADCP_time.mat');
load('./mooring_file/CVOO_ADCP_u.mat');
load('./mooring_file/CVOO_ADCP_v.mat');
Uo = u_time_original;
Vo = v_time_original;
% [~, ito, ib] = intersect(To, time_original);
% Um_level = Um(:,ito);
% Vm_level = Vm(:,ito);
% clear u_time_original v_time_original Um Vm
%% Depth correct
Um_full = zeros(size(Uo,1),size(Um,2));
Vm_full = zeros(size(Uo,1),size(Um,2));
Um_full_CVCM = zeros(size(Uo,1),size(Um,2));
Vm_full_CVCM = zeros(size(Uo,1),size(Um,2));
for t=1 : size(UOO_mooring,2)
    Um_full(:,t) = interp1(z,Um(:,t),d_inter,'linear');
    Vm_full(:,t) = interp1(z,Vm(:,t),d_inter,'linear');
    Um_full_CVCM(:,t) = interp1(z,Um_CVCM(:,t),d_inter,'linear');
    Vm_full_CVCM(:,t) = interp1(z,Vm_CVCM(:,t),d_inter,'linear');
end
%% 100-200 Averaged
k_above = 1;
k_below = 15;
d_inter([k_above:k_below])
%%
k_level = 35; % 100m:15 200m:35
Nsquare_mean = mean(Nsquare_time,2);
Nsquare_mean_CVCM = mean(Nsquare_time_CVCM,2);

dt = 3600/86400; % Sampling interval dt in days
params= Gm76Params;
params.jstar=6;
params.Ef=0.055;

% N=5.23e-3   
% 3cph = (3).*24 cpd
% params.N0 =5.23e-3 ;

params.N0 = 1.5 * 2*pi / 3600;
N_cpd = params.N0 * 86400 / (2*pi);

d_inter(k_level) % about 101m

N_level = mean(sqrt(Nsquare_mean(k_above:k_below)));
N_level_CVCM = mean(sqrt(Nsquare_mean_CVCM(k_above:k_below)));

for k_level=k_above:k_below
    d_inter(k_level)
    %% CVCTM
    cv = Um_full(k_level,:)';
    P=4;K=5;% 7

    psi=sleptap(length(cv),P,K); 
    [fm,spp_u,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    cv = Vm_full(k_level,:)';
    
    [fm,spp_v,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    spp = spp_u + spp_v; % (m/s)^2 * days
    
    sppm(:,k_level-k_above+1) = spp; % .* (params.N0)./N_level;
    
    %% CVCM
    cv = Um_full_CVCM(k_level,:)';
    P=2;K=7;% 7

    psi=sleptap(length(cv),P,K); 
    [fm,spp_u,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    cv = Vm_full_CVCM(k_level,:)';
    
    [fm,spp_v,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    spp = spp_u + spp_v; % (m/s)^2 * days
    
    sppm_CVCM(:,k_level-k_above+1) = spp; % .* (params.N0)./N_level;
    %% KPO mooring
    cv = Uo(k_level,:)';
    
    P=8;K=7;% 7
    psi=sleptap(length(cv),P,K); 
    [fo,spp_u,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    cv = Vo(k_level,:)';
    [fo,spp_v,~] = mspec(dt,cv,psi,'cyclic'); %specify to mspec to output cyclic frequencies
    
    spp = spp_u + spp_v; % (m/s)^2 * days
    sppo(:,k_level-k_above+1) = spp; % .* (params.N0)./N_level;

end
% figure(1);clf;set(gcf,'position',[10 10 900 450]);
% subplot(131)
% pcolor(d_inter([k_above:k_below]),fo,log10(sppo));shading interp;clim([-4 -2]);ylog;
% 
% subplot(132)
% pcolor(d_inter([k_above:k_below]),fm,log10(sppm));shading interp;clim([-4 -2]);ylog;
% 
% subplot(133)
% pcolor(d_inter([k_above:k_below]),fm,log10(sppm_CVCM));shading interp;clim([-4 -2]);ylog;


    figure(2);clf;set(gcf,'position',[10 10 900 450]);
    hm=plot(fm,mean(sppm,2),'DisplayName','CVCTM');xlim([fm(2) fm(end)]),xlog,ylog;hold on
    set(hm(1),'linewidth',3,'color','r');hold on
    hm=plot(fm,mean(sppm_CVCM,2),'DisplayName','CVCM');xlim([fm(2) fm(end)]),xlog,ylog;hold on
    set(hm(1),'linewidth',3,'color','b');hold on    
    ho=plot(fo,mean(sppo,2),'DisplayName','CVOO');set(ho(1),'linewidth',3,'color',[.4 .4 .4]);hold on
%% GM
    fcor = sw_f(Lat_CVOO);
    f_GM_start = fm(2) *2*pi/86400 ; %rad/s
    f_GM_end = fm(end) *2*pi/86400;
    
    % N = f_GM_end;
    om = linspace(f_GM_start,f_GM_end,5000); % rad/s
    S = GmOm('Vel',om,fcor,N_level,params); % (m/s)^2 * rad/s
    
    % S = S.* (params.N0)./N_level;
    % S = S.* max(sqrt(N2(:)))./N_level;
    om = om.*86400/(2*pi); % 
    S = S *(2*pi)/86400;
    
    hold on;
    h_GM=plot(om,S,'LineWidth',3,'color','k','LineStyle','-.','DisplayName','GM76');

    xlim([om(1)/3 om(end)])
    % vlines(N_level.*86400/(2*pi),':');

   leg = legend('AutoUpdate','off');
   set(leg,'NumColumns',1,'Location','southwest','LineWidth',2,...
    'Interpreter','latex','fontsize',25);

  xlim(10.^([-2 1.0]))
  ylim(10.^([-7 -0.5]))
  % xlim([om(1)/3 om(end)])
vlines(corfreq(Lat_CVOO)/2/pi*24,'2k--') % f
vlines(tidefreq('m2')/2/pi*24,'2k--'); % M2
% vlines(tidefreq('s2')/2/pi*24,'k--');
% vlines(tidefreq('n2')/2/pi*24,'2--');
% vlines((tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
% vlines((2*tidefreq('m2')+tidefreq('k1'))/2/pi*24,'1--');
% vlines(tidefreq('K1')/2/pi*24,'1--');
% vlines(tidefreq('O1')/2/pi*24,'1--');
vlines(2*tidefreq('m2')/2/pi*24,'1--'); % M4
% vlines(3*tidefreq('m2')/2/pi*24,'1--'); % M6

% vlines(N_cpd,'2k--');
% vlines((tidefreq('m2')-corfreq(Lat_CVOO))/2/pi*24,'1--');

grid on;

set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold');   

set(gca,'fontsize',25,'XTick',[10^-3,10^-2,10^-1,10^0,10^1,10^2,10^3],'LineWidth',2,'fontname','Arial',...
    'Xaxislocation','bottom','YTick',[10^-6,10^-5,10^-4,10^-3,10^-2,10^-1,10^0])

set(gca,'Layer','top');
set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.3)


set(gca,'Layer','top');
% set(gca,'GridLineStyle','-.','GridColor',[.2 .2 .2]','GridAlpha',0.1)

ylabel(['$PSD ','\ (m^2\ s^{-2}\ cpd^{-1})$'],'fontsize',28,'Interpreter','latex')
xlabel('Frequency (cpd)','fontsize',28,'fontname','Arial');

annotation(figure(2),'textbox',...
    [0.5766266832586 0.928888888888889 0.0622498462185967 0.0914638687687211],...
    'String','$f$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',22,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');

annotation(figure(2),'textbox',...
    [0.706771288375397,0.928888888888889,0.062249846218597,0.091463868768721],...
    'String','$M_{2}$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',22,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');

annotation(figure(2),'textbox',...
    [0.777961499721337,0.928888888888889,0.062249846218597,0.091463868768721],...
    'String','$M_{4}$',...
    'LineStyle','none',...
    'Interpreter','latex',...
    'FontSize',22,...
    'FontName','Arial',...
    'FitBoxToText','off',...
    'EdgeColor','none');

exportgraphics(gcf,['PSD_comparision3.tiff'], 'Resolution',300);








%%