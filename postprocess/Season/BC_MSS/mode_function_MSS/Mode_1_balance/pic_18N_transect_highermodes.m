clear;clc;close all
addpath ../../../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')

iw = 10;ie = 1;
jn = 10;js = 10;

weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
%%
load('CoastalDakar_index.mat')
depto_grid   = depto_grid(select_indicex,select_indicey);
weto_p       = weto_p(select_indicex,select_indicey,:);
lonp_grid = lonp_grid(select_indicex,select_indicey);
latp_grid = latp_grid(select_indicex,select_indicey);
dlxp = dlxp(select_indicex,select_indicey);
dlyp = dlyp(select_indicex,select_indicey);

load(['../../Pressure/' ...
    'NorthDakar_index.mat'])
lonp_nds = lonp_grid(select_indicex,select_indicey);
latp_nds = latp_grid(select_indicex,select_indicey);
dlxp_nds = dlxp(select_indicex,select_indicey);
dlyp_nds = dlyp(select_indicex,select_indicey);
depto_nds = depto_grid(select_indicex,select_indicey);
lonp_18(:) = lonp_nds(:,25);
%%
for iy= 1:3
    loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    if iy==2
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    end
    if iy==3
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    end
    for im=2:3 % Mode 2-3
        load([loadloc,'/18NBalance/18N_Mode',num2str(im),'_budget.mat']);
        C_18N_mode(:,:,iy,im) = C_nds_18(:,:);
        R_18N_mode(:,:,iy,im) = R_nds_18(:,:);
        Div_F_18N_mode(:,:,iy,im) = Div_F_18(:,:);
        Amn_18N_mode(:,:,iy,im) = Amn_nds_18(:,:);
        PBmn_18N_mode(:,:,iy,im) = PBmn_nds_18(:,:);
        PSmn_h_18N_mode(:,:,iy,im) = PSmn_h_nds_18(:,:);
        PSmn_v_18N_mode(:,:,iy,im) = PSmn_v_nds_18(:,:);
    end

    for im=1:3 % Mode 1
        load([loadloc,'/18NBalance/18N_Mode',num2str(im),'_budget.mat']);
        C_18N_allmode(:,:,iy,im) = C_nds_18(:,:);
        R_18N_allmode(:,:,iy,im) = R_nds_18(:,:);
    end
end
    
C_18N = sum(C_18N_mode,4,"omitmissing");
R_18N = sum(R_18N_mode,4,"omitmissing");
D_18N = sum(Div_F_18N_mode,4,"omitmissing");
A_18N = sum(Amn_18N_mode,4,"omitmissing");
B_18N = sum(PBmn_18N_mode,4,"omitmissing");
Sh_18N = sum(PSmn_h_18N_mode,4,"omitmissing");
Sv_18N = sum(PSmn_v_18N_mode,4,"omitmissing");

C_18N_mode2 = C_18N_allmode(:,:,:,2);
C_18N_mode3 = C_18N_allmode(:,:,:,3);

R_18N_mode2 = R_18N_allmode(:,:,:,2);
R_18N_mode3 = R_18N_allmode(:,:,:,3);


C_18N_mean = mean(C_18N,3,'omitmissing');
R_18N_mean = mean(R_18N,3,'omitmissing');
D_18N_mean = mean(D_18N,3,'omitmissing');
A_18N_mean = mean(A_18N,3,'omitmissing');
B_18N_mean = mean(B_18N,3,'omitmissing');
Sh_18N_mean = mean(Sh_18N,3,'omitmissing');
Sv_18N_mean = mean(Sv_18N,3,'omitmissing');


C_m2_18N_mean = mean(C_18N_mode2,3,'omitmissing');
C_m3_18N_mean = mean(C_18N_mode3,3,'omitmissing');

R_m2_18N_mean = mean(R_18N_mode2,3,'omitmissing');
R_m3_18N_mean = mean(R_18N_mode3,3,'omitmissing');


C_18N_season(:,1) = mean(C_18N_mean(:,1:4),2,'omitmissing');
C_18N_season(:,2) = mean(C_18N_mean(:,5:8),2,'omitmissing');
C_18N_season(:,3) = mean(C_18N_mean(:,9:12),2,'omitmissing');

C_m2_18N_season(:,1) = mean(C_m2_18N_mean(:,1:4),2,'omitmissing');
C_m2_18N_season(:,2) = mean(C_m2_18N_mean(:,5:8),2,'omitmissing');
C_m2_18N_season(:,3) = mean(C_m2_18N_mean(:,9:12),2,'omitmissing');

C_m3_18N_season(:,1) = mean(C_m3_18N_mean(:,1:4),2,'omitmissing');
C_m3_18N_season(:,2) = mean(C_m3_18N_mean(:,5:8),2,'omitmissing');
C_m3_18N_season(:,3) = mean(C_m3_18N_mean(:,9:12),2,'omitmissing');

R_m2_18N_season(:,1) = mean(R_m2_18N_mean(:,1:4),2,'omitmissing');
R_m2_18N_season(:,2) = mean(R_m2_18N_mean(:,5:8),2,'omitmissing');
R_m2_18N_season(:,3) = mean(R_m2_18N_mean(:,9:12),2,'omitmissing');

R_m3_18N_season(:,1) = mean(R_m3_18N_mean(:,1:4),2,'omitmissing');
R_m3_18N_season(:,2) = mean(R_m3_18N_mean(:,5:8),2,'omitmissing');
R_m3_18N_season(:,3) = mean(R_m3_18N_mean(:,9:12),2,'omitmissing');


R_18N_season(:,1) = mean(R_18N_mean(:,1:4),2,'omitmissing');
R_18N_season(:,2) = mean(R_18N_mean(:,5:8),2,'omitmissing');
R_18N_season(:,3) = mean(R_18N_mean(:,9:12),2,'omitmissing');

D_18N_season(:,1) = mean(D_18N_mean(:,1:4),2,'omitmissing');
D_18N_season(:,2) = mean(D_18N_mean(:,5:8),2,'omitmissing');
D_18N_season(:,3) = mean(D_18N_mean(:,9:12),2,'omitmissing');


A_18N_season(:,1) = mean(A_18N_mean(:,1:4),2,'omitmissing');
A_18N_season(:,2) = mean(A_18N_mean(:,5:8),2,'omitmissing');
A_18N_season(:,3) = mean(A_18N_mean(:,9:12),2,'omitmissing');

B_18N_season(:,1) = mean(B_18N_mean(:,1:4),2,'omitmissing');
B_18N_season(:,2) = mean(B_18N_mean(:,5:8),2,'omitmissing');
B_18N_season(:,3) = mean(B_18N_mean(:,9:12),2,'omitmissing');

Sh_18N_season(:,1) = mean(Sh_18N_mean(:,1:4),2,'omitmissing');
Sh_18N_season(:,2) = mean(Sh_18N_mean(:,5:8),2,'omitmissing');
Sh_18N_season(:,3) = mean(Sh_18N_mean(:,9:12),2,'omitmissing');


Sv_18N_season(:,1) = mean(Sv_18N_mean(:,1:4),2,'omitmissing');
Sv_18N_season(:,2) = mean(Sv_18N_mean(:,5:8),2,'omitmissing');
Sv_18N_season(:,3) = mean(Sv_18N_mean(:,9:12),2,'omitmissing');

%%
lonp_18N = -lonp_nds(:,25);
saveloc = ['./18NBalance/'];
figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_18N,A_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_18N,A_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_18N,A_18N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.25:0.25:18.5],'XTickLabel',{' '});  
xlim([16.16 18.5]);
title(['$\langle  \overline{\textbf{\textit{A}}_{n>1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
% exportgraphics(gcf,[saveloc,'A_18N_depth.tiff'], 'Resolution',300);

figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_18N,B_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_18N,B_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_18N,B_18N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.25:0.25:18.5],'XTickLabel',{' '},'YTick',[-3e-3:1e-3:2e-2]);  
xlim([16.16 18.5]);
title(['$\langle  \overline{\textbf{\textit{Pb}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
% exportgraphics(gcf,[saveloc,'Pb_18N_depth.tiff'], 'Resolution',300);

figure(4);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_18N,Sh_18N_season(:,1)+Sv_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_18N,Sh_18N_season(:,2)+Sv_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_18N,Sh_18N_season(:,3)+Sv_18N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.25:0.25:18.5],'XTickLabel',{' '});  
xlim([16.16 18.5]);
title(['$\langle  \overline{\textbf{\textit{Ps}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
% exportgraphics(gcf,[saveloc,'Ps_18N_depth.tiff'], 'Resolution',300);

figure(5);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_18N,C_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_18N,C_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_18N,C_18N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;

% plot(lonp_18N,C_m2_18N_season(:,1)+C_m3_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling','LineStyle','--');hold on;
% plot(lonp_18N,C_m2_18N_season(:,2)+C_m3_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation','LineStyle','--');hold on;
% plot(lonp_18N,C_m2_18N_season(:,3)+C_m3_18N_season(:,2),'r','LineWidth',1.5,'DisplayName','Downwelling','LineStyle','--');hold on;

grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.25:0.25:18.5],'XTickLabel',{' '},'YTick',[-10e-3:5e-3:5e-3]);  
xlim([16.16 18.5]);ylim([-10e-3 5e-3])
title(['$\langle  \overline{\textbf{\textit{C}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'Csum_18N_depth.tiff'], 'Resolution',300);


figure(6);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_18N,R_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_18N,R_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_18N,R_18N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;

% plot(lonp_18N,R_m2_18N_season(:,1)+R_m3_18N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling','LineStyle','--');hold on;
% plot(lonp_18N,R_m2_18N_season(:,2)+R_m3_18N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation','LineStyle','--');hold on;
% plot(lonp_18N,R_m2_18N_season(:,3)+R_m3_18N_season(:,2),'r','LineWidth',1.5,'DisplayName','Downwelling','LineStyle','--');hold on;
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.25:0.25:18.5],'XTickLabel',{' '}, ...
'YTick',[-5e-2:2.5e-2:5e-2]);  
ax = gca();
ax.YRuler.Exponent = -2;
% ax.YRuler.TickLabelFormat = '%.1f';
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
ylim([-3e-2 5.2e-2])
xlim([16.16 18.5]);
title(['$\langle  \overline{\textbf{\textit{C}}_{1}} \rangle  - \nabla_{h}\cdot \langle \overline{\textbf{\textit{F}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'Rsum_18N_depth.tiff'], 'Resolution',300);