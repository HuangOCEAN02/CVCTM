clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
SaveLocation = './Energy_analysis'
imodes = 10;
%%
for m_select = 1: 12
    load([SaveLocation,'/Generation_depth_Mode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select,1) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select,1) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select,2) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select,2) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select,3) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select,3) = C_SDA_sum(:);

    % C_NDA_ALL(:,m_select,4) =  C_NDA_ALL(:,m_select,3) + C_NDA_ALL(:,m_select,2) + C_NDA_ALL(:,m_select,1);
    % C_SDA_ALL(:,m_select,4) =  C_SDA_ALL(:,m_select,3) + C_SDA_ALL(:,m_select,2) + C_SDA_ALL(:,m_select,1);
    % 

    load([SaveLocation,'/Generation_depth_ALLMode_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select,4) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select,4) = C_SDA_sum(:);
end

for m_select = 1: 12
    SaveLocation = '../../../../../2015/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/Generation_depth_Mode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12,1) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12,1) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12,2) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12,2) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12,3) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12,3) = C_SDA_sum(:);

    % C_NDA_ALL(:,m_select+12,4) =  C_NDA_ALL(:,m_select+12,3) + C_NDA_ALL(:,m_select+12,2) + C_NDA_ALL(:,m_select+12,1);
    % C_SDA_ALL(:,m_select+12,4) =  C_SDA_ALL(:,m_select+12,3) + C_SDA_ALL(:,m_select+12,2) + C_SDA_ALL(:,m_select+12,1);
    load([SaveLocation,'/Generation_depth_ALLMode_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12,4) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12,4) = C_SDA_sum(:);
end


for m_select = 1: 12
    SaveLocation = '../../../../../2016/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/Generation_depth_Mode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12+12,1) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12+12,1) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12+12,2) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12+12,2) = C_SDA_sum(:);

    load([SaveLocation,'/Generation_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12+12,3) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12+12,3) = C_SDA_sum(:);

    % C_NDA_ALL(:,m_select+12+12,4) =  C_NDA_ALL(:,m_select+12+12,3) + C_NDA_ALL(:,m_select+12+12,2) + C_NDA_ALL(:,m_select+12+12,1);
    % C_SDA_ALL(:,m_select+12+12,4) =  C_SDA_ALL(:,m_select+12+12,3) + C_SDA_ALL(:,m_select+12+12,2) + C_SDA_ALL(:,m_select+12+12,1);

    load([SaveLocation,'/Generation_depth_ALLMode_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select+12+12,4) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select+12+12,4) = C_SDA_sum(:);
end

%%
% 1-4
C_NDA_upwelling = squeeze(mean(C_NDA_ALL(:,[1:4,12+1:12+4,24+1:24+4],:),2));
C_SDA_upwelling = squeeze(mean(C_SDA_ALL(:,[1:4,12+1:12+4,24+1:24+4],:),2));


% 5-8
C_NDA_relaxation = squeeze(mean(C_NDA_ALL(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_relaxation = squeeze(mean(C_SDA_ALL(:,[5:8,12+5:12+8,24+5:24+8],:),2));


% 9-12
C_NDA_summer = squeeze(mean(C_NDA_ALL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_summer = squeeze(mean(C_SDA_ALL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
%%
SaveLocation = './Energy_analysis'
% Mode1
figure(1);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_SDA_upwelling(:,1)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_SDA_relaxation(:,1)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_SDA_summer(:,1)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-1.5 7.5]);
title(['$\langle \overline{\textbf{\textit{C}}_{1}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
leg = legend('AutoUpdate','off');
set(leg,...
    'Orientation','horizontal','NumColumns',1,...
    'Location','best',...
    'FontSize',20,...
    'EdgeColor',[0 0 0],...
    'fontname','Arial','fontweight','bold',...
    'AutoUpdate','off');
l4 = plot([0,dpe],[0;C_SDA_summer(:,4)-C_SDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;

set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-1.5:1.5:8],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode1_Generation_SDA_123.tiff'], 'Resolution',300);

% Mode2
figure(2);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_SDA_upwelling(:,2)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_SDA_relaxation(:,2)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_SDA_summer(:,2)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-0.5 2.1]);
title(['$\langle \overline{\textbf{\textit{C}}_{2}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
l4 = plot([0,dpe],[0;C_SDA_summer(:,4)-C_SDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;

set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-0.5:0.5:2.5],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode2_Generation_SDA_123.tiff'], 'Resolution',300);

% Mode3
figure(3);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_SDA_upwelling(:,3)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_SDA_relaxation(:,3)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_SDA_summer(:,3)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-0.3 0.8]);
title(['$\langle \overline{\textbf{\textit{C}}_{3}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
l4 = plot([0,dpe],[0;C_SDA_summer(:,4)-C_SDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;

set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-0.4:0.2:1.2],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode3_Generation_SDA_123.tiff'], 'Resolution',300);

% total
figure(4);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_SDA_upwelling(:,4)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_SDA_relaxation(:,4)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_SDA_summer(:,4)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-2 10]);
title(['$\langle \overline{\textbf{\textit{C}}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
l4 = plot([0,dpe],[0;C_SDA_summer(:,4)-C_SDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;

set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-2:2:10],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k');
set(gca,'Layer','top','LineWidth',3,'TickDir','out');
exportgraphics(gcf,[SaveLocation,'/Mode_total_Generation_SDA_123.tiff'], 'Resolution',300);