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
    'SouthDakar_index.mat'])
lonp_sds = lonp_grid(select_indicex,select_indicey);
latp_sds = latp_grid(select_indicex,select_indicey);
dlxp_sds = dlxp(select_indicex,select_indicey);
dlyp_sds = dlyp(select_indicex,select_indicey);
depto_sds = depto_grid(select_indicex,select_indicey);
lonp_14(:) = lonp_sds(:,43);
%%
for iy= 1:3
    loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    if iy==2
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    end
    if iy==3
        loadloc = ['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/Withtide/post_process/Season/BC_MSS/mode_function_MSS/Mode_1_balance'];
    end
    for im=1:1
        load([loadloc,'/14NBalance/14N_Mode',num2str(im),'_budget.mat']);
        C_14N_mode(:,:,iy,im) = C_sds_14(:,:)*1e+3;
        R_14N_mode(:,:,iy,im) = R_sds_14(:,:)*1e+3;
        Div_F_14N_mode(:,:,iy,im) = Div_F_14(:,:)*1e+3;
        Amn_14N_mode(:,:,iy,im) = Amn_sds_14(:,:)*1e+3;
        PBmn_14N_mode(:,:,iy,im) = PBmn_sds_14(:,:)*1e+3;
        PSmn_h_14N_mode(:,:,iy,im) = PSmn_h_sds_14(:,:)*1e+3;
        PSmn_v_14N_mode(:,:,iy,im) = PSmn_v_sds_14(:,:)*1e+3;
    end
    for im=1:3 % Mode 1
        load([loadloc,'/14NBalance/14N_Mode',num2str(im),'_budget.mat']);
        C_14N_allmode(:,:,iy,im) = C_sds_14(:,:)*1e+3;
        R_14N_allmode(:,:,iy,im) = R_sds_14(:,:)*1e+3;
    end
end
       
C_14N = sum(C_14N_mode,4,"omitmissing");
R_14N = sum(R_14N_mode,4,"omitmissing");
D_14N = sum(Div_F_14N_mode,4,"omitmissing");
A_14N = sum(Amn_14N_mode,4,"omitmissing");
B_14N = sum(PBmn_14N_mode,4,"omitmissing");
Sh_14N = sum(PSmn_h_14N_mode,4,"omitmissing");
Sv_14N = sum(PSmn_v_14N_mode,4,"omitmissing");

C_14N_mode2 = C_14N_allmode(:,:,:,2);
C_14N_mode3 = C_14N_allmode(:,:,:,3);

R_14N_mode2 = R_14N_allmode(:,:,:,2);
R_14N_mode3 = R_14N_allmode(:,:,:,3);


C_14N_mean = mean(C_14N,3,'omitmissing');
R_14N_mean = mean(R_14N,3,'omitmissing');
D_14N_mean = mean(D_14N,3,'omitmissing');
A_14N_mean = mean(A_14N,3,'omitmissing');
B_14N_mean = mean(B_14N,3,'omitmissing');
Sh_14N_mean = mean(Sh_14N,3,'omitmissing');
Sv_14N_mean = mean(Sv_14N,3,'omitmissing');


C_m2_14N_mean = mean(C_14N_mode2,3,'omitmissing');
C_m3_14N_mean = mean(C_14N_mode3,3,'omitmissing');

R_m2_14N_mean = mean(R_14N_mode2,3,'omitmissing');
R_m3_14N_mean = mean(R_14N_mode3,3,'omitmissing');


C_14N_season(:,1) = mean(C_14N_mean(:,1:4),2,'omitmissing');
C_14N_season(:,2) = mean(C_14N_mean(:,5:8),2,'omitmissing');
C_14N_season(:,3) = mean(C_14N_mean(:,9:12),2,'omitmissing');

C_m2_14N_season(:,1) = mean(C_m2_14N_mean(:,1:4),2,'omitmissing');
C_m2_14N_season(:,2) = mean(C_m2_14N_mean(:,5:8),2,'omitmissing');
C_m2_14N_season(:,3) = mean(C_m2_14N_mean(:,9:12),2,'omitmissing');

C_m3_14N_season(:,1) = mean(C_m3_14N_mean(:,1:4),2,'omitmissing');
C_m3_14N_season(:,2) = mean(C_m3_14N_mean(:,5:8),2,'omitmissing');
C_m3_14N_season(:,3) = mean(C_m3_14N_mean(:,9:12),2,'omitmissing');

R_m2_14N_season(:,1) = mean(R_m2_14N_mean(:,1:4),2,'omitmissing');
R_m2_14N_season(:,2) = mean(R_m2_14N_mean(:,5:8),2,'omitmissing');
R_m2_14N_season(:,3) = mean(R_m2_14N_mean(:,9:12),2,'omitmissing');

R_m3_14N_season(:,1) = mean(R_m3_14N_mean(:,1:4),2,'omitmissing');
R_m3_14N_season(:,2) = mean(R_m3_14N_mean(:,5:8),2,'omitmissing');
R_m3_14N_season(:,3) = mean(R_m3_14N_mean(:,9:12),2,'omitmissing');


R_14N_season(:,1) = mean(R_14N_mean(:,1:4),2,'omitmissing');
R_14N_season(:,2) = mean(R_14N_mean(:,5:8),2,'omitmissing');
R_14N_season(:,3) = mean(R_14N_mean(:,9:12),2,'omitmissing');

D_14N_season(:,1) = mean(D_14N_mean(:,1:4),2,'omitmissing');
D_14N_season(:,2) = mean(D_14N_mean(:,5:8),2,'omitmissing');
D_14N_season(:,3) = mean(D_14N_mean(:,9:12),2,'omitmissing');


A_14N_season(:,1) = mean(A_14N_mean(:,1:4),2,'omitmissing');
A_14N_season(:,2) = mean(A_14N_mean(:,5:8),2,'omitmissing');
A_14N_season(:,3) = mean(A_14N_mean(:,9:12),2,'omitmissing');

B_14N_season(:,1) = mean(B_14N_mean(:,1:4),2,'omitmissing');
B_14N_season(:,2) = mean(B_14N_mean(:,5:8),2,'omitmissing');
B_14N_season(:,3) = mean(B_14N_mean(:,9:12),2,'omitmissing');

Sh_14N_season(:,1) = mean(Sh_14N_mean(:,1:4),2,'omitmissing');
Sh_14N_season(:,2) = mean(Sh_14N_mean(:,5:8),2,'omitmissing');
Sh_14N_season(:,3) = mean(Sh_14N_mean(:,9:12),2,'omitmissing');


Sv_14N_season(:,1) = mean(Sv_14N_mean(:,1:4),2,'omitmissing');
Sv_14N_season(:,2) = mean(Sv_14N_mean(:,5:8),2,'omitmissing');
Sv_14N_season(:,3) = mean(Sv_14N_mean(:,9:12),2,'omitmissing');
%%
lonp_14N = -lonp_sds(:,43);
saveloc = ['./14NBalance/'];
xleft = 17.1;
xright =  18.5
figure(1);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 200])
plot(lonp_14N,depto_sds(:,43)*1e-3,'Color','k','LineWidth',2,'LineStyle','-');
area(lonp_14N,depto_sds(:,43)*1e-3,'FaceColor',[.4 .4 .4],'BaseValue',3,'linewidth',2.0);hold on
%area(depto_sds(:,15)*1e-3,lonp_14N,'FaceColor',[.4 .4 .4],'BaseValue',16,'linewidth',2.0);hold on
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','YDir','reverse','XDir','reverse','XTick',[16.5:0.25:18.5]);  
ylim([-0.4 3]);
xlim([xleft xright]);
exportgraphics(gcf,[saveloc,'14N_depth.tiff'], 'Resolution',300);


figure(2);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_14N,A_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_14N,A_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_14N,A_14N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'GridLineStyle','-.','GridLineWidth',0.5);
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.5:0.25:18.5],'XTickLabel',{' '},'YTick',[-4:1:1]);  
xlim([xleft xright]);
title(['$\langle  \overline{\textbf{\textit{A}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'A_14N_depth.tiff'], 'Resolution',300);



figure(3);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_14N,B_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_14N,B_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_14N,B_14N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.5:0.25:18.5],'XTickLabel',{' '},'YTick',[-1:0.5:1]);  
xlim([xleft xright]);
title(['$\langle  \overline{\textbf{\textit{Pb}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'Pb_14N_depth.tiff'], 'Resolution',300);



figure(4);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_14N,Sh_14N_season(:,1)+Sv_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_14N,Sh_14N_season(:,2)+Sv_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_14N,Sh_14N_season(:,3)+Sv_14N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.5:0.25:18.5],'XTickLabel',{' '});  
xlim([xleft xright]);
title(['$\langle  \overline{\textbf{\textit{Ps}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'Ps_14N_depth.tiff'], 'Resolution',300);


figure(5);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_14N,C_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_14N,C_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_14N,C_14N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;

% plot(lonp_14N,C_m2_14N_season(:,1)+C_m3_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling','LineStyle','--');hold on;
% plot(lonp_14N,C_m2_14N_season(:,2)+C_m3_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation','LineStyle','--');hold on;
% plot(lonp_14N,C_m2_14N_season(:,3)+C_m3_14N_season(:,2),'r','LineWidth',1.5,'DisplayName','Downwelling','LineStyle','--');hold on;
ax = gca();
% ax.YRuler.Exponent = -2;
grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.5:0.25:18.5],'XTickLabel',{' '},'YTick',[0:20:80]);  
xlim([xleft xright]);ylim([-10 75])
title(['$\langle  \overline{\textbf{\textit{C}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')
exportgraphics(gcf,[saveloc,'C_14N_depth.tiff'], 'Resolution',300);


figure(6);clf;set(gcf,'color','w');set(gcf,'position',[50 50 700 250])
plot(lonp_14N,R_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling');hold on;
plot(lonp_14N,R_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation');hold on;
plot(lonp_14N,R_14N_season(:,3),'r','LineWidth',1.5,'DisplayName','Downwelling');hold on;

% plot(lonp_14N,R_m2_14N_season(:,1)+R_m3_14N_season(:,1),'b','LineWidth',1.5,'DisplayName','Upwelling','LineStyle','--');hold on;
% plot(lonp_14N,R_m2_14N_season(:,2)+R_m3_14N_season(:,2),'k','LineWidth',1.5,'DisplayName','Relaxation','LineStyle','--');hold on;
% plot(lonp_14N,R_m2_14N_season(:,3)+R_m3_14N_season(:,2),'r','LineWidth',1.5,'DisplayName','Downwelling','LineStyle','--');hold on;

grid on;
set(gca,'GridLineStyle','-.','GridLineWidth',1,'GridColor','k');
set(gca,'Layer','top','fontweight','bold');
set(gca,'fontsize',25,'LineWidth',2,'fontname','Arial',...
'Xaxislocation','bottom','fontweight','bold','XDir','reverse','XTick',[16.5:0.25:18.5],'XTickLabel',{' '},'YTick',[0:20:80]);  
xlim([xleft xright]);ylim([-15 85])
title(['$\langle  \overline{\textbf{\textit{C}}_{1}} \rangle  - \nabla_{h}\cdot \langle \overline{\textbf{\textit{F}}_{1}} \rangle$'],'fontname','Arial','fontweight','bold','fontsize',25,'Interpreter','latex')

exportgraphics(gcf,[saveloc,'R_14N_depth.tiff'], 'Resolution',300);