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

%% Try to plot 
% load('./Energy_analysis/Slope_depth_2014_sorted.mat');
% Alpha_NDA(:,1:12) = Alpha_NDA_month_sorted;
% Alpha_SDA(:,1:12) = Alpha_SDA_month_sorted;
% load('./Energy_analysis/Slope_depth_2015_sorted.mat');
% Alpha_NDA(:,13:24) = Alpha_NDA_month_sorted;
% Alpha_SDA(:,13:24) = Alpha_SDA_month_sorted;
% load('./Energy_analysis/Slope_depth_2016_sorted.mat');
% Alpha_NDA(:,25:36) = Alpha_NDA_month_sorted;
% Alpha_SDA(:,25:36) = Alpha_SDA_month_sorted;
% 
% Alpha_NDA_upwelling = squeeze(mean(Alpha_NDA(:,[1:4,12+1:12+4,24+1:24+4],:),2));
% Alpha_SDA_upwelling = squeeze(mean(Alpha_SDA(:,[1:4,12+1:12+4,24+1:24+4],:),2));
% 
% slope = Alpha_NDA_upwelling;
% Alpha_NDA_upwelling(slope<0.8)=0;
% Alpha_NDA_upwelling(slope>=0.8 & slope<=1.5)=1;
% Alpha_NDA_upwelling(slope>=1.5)=2;
% 
% slope = Alpha_SDA_upwelling;
% Alpha_SDA_upwelling(slope<0.8)=0;
% Alpha_SDA_upwelling(slope>=0.8 & slope<=1.5)=1;
% Alpha_SDA_upwelling(slope>=1.5)=2;
% 
% 
% 
% Alpha_NDA_relaxation = squeeze(mean(Alpha_NDA(:,[5:8,12+5:12+8,24+5:24+8],:),2));
% Alpha_SDA_relaxation = squeeze(mean(Alpha_SDA(:,[5:8,12+5:12+8,24+5:24+8],:),2));
% 
% slope = Alpha_NDA_relaxation;
% Alpha_NDA_relaxation(slope<0.8)=0;
% Alpha_NDA_relaxation(slope>=0.8 & slope<=1.5)=1;
% Alpha_NDA_relaxation(slope>=1.5)=2;
% 
% slope = Alpha_SDA_relaxation;
% Alpha_SDA_relaxation(slope<0.8)=0;
% Alpha_SDA_relaxation(slope>=0.8 & slope<=1.5)=1;
% Alpha_SDA_relaxation(slope>=1.5)=2;
% 
% 
% Alpha_NDA_summer = squeeze(mean(Alpha_NDA(:,[9:12,12+9:12+12,24+9:24+12]),2));
% Alpha_SDA_summer = squeeze(mean(Alpha_SDA(:,[9:12,12+9:12+12,24+9:24+12]),2));
% 
% 
% slope = Alpha_NDA_summer;
% Alpha_NDA_summer(slope<0.8)=0;
% Alpha_NDA_summer(slope>=0.8 & slope<=1.5)=1;
% Alpha_NDA_summer(slope>=1.5)=2;
% 
% slope = Alpha_SDA_summer;
% Alpha_SDA_summer(slope<0.8)=0;
% Alpha_SDA_summer(slope>=0.8 & slope<=1.5)=1;
% Alpha_SDA_summer(slope>=1.5)=2;
% 
% 
% Alpha_NDA_mean = squeeze(mean(Alpha_NDA(:,:),2));
% Alpha_SDA_mean = squeeze(mean(Alpha_SDA(:,:),2));
% 
% slope = Alpha_NDA_mean;
% Alpha_NDA_mean_sub = zeros(size(slope));
% Alpha_NDA_mean_sup = zeros(size(slope));
% Alpha_NDA_mean_cs = zeros(size(slope));
% 
% Alpha_NDA_mean_sub(slope<0.8)=1;
% Alpha_NDA_mean_cs(slope>=0.8 & slope<=1.5)=1;
% Alpha_NDA_mean_sup(slope>=1.5)=1;
% 
% slope = Alpha_SDA_mean;
% Alpha_SDA_mean_sub = zeros(size(slope));
% Alpha_SDA_mean_sup = zeros(size(slope));
% Alpha_SDA_mean_cs = zeros(size(slope));
% 
% Alpha_SDA_mean_sub(slope<0.8)=1;
% Alpha_SDA_mean_cs(slope>=0.8 & slope<=1.5)=1;
% Alpha_SDA_mean_sup(slope>=1.5)=1;
% 
% 
% inteval = 100;
% for iiz = 1:1:5000/inteval
%        up =  (iiz-1)*inteval;
%        dow = (iiz)*inteval;
%        dpe(iiz) = (up+dow)./2;
% 
%        point_num = length(find(depto_NDA_x<=dow & depto_NDA_x>up));
%        CS_NDA(iiz) = sum(Alpha_NDA_mean_cs(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing')/point_num;
%        SUPERCS_NDA(iiz) = sum(Alpha_NDA_mean_sup(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing')/point_num;
%        SUBERCS_NDA(iiz) = sum(Alpha_NDA_mean_sub(depto_NDA_x<=dow & depto_NDA_x>up),'omitmissing')/point_num;
% 
%        CS_SDA(iiz) = sum(Alpha_SDA_mean_cs(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing')/point_num;
%        SUPERCS_SDA(iiz) = sum(Alpha_SDA_mean_sup(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing')/point_num;
%        SUBERCS_SDA(iiz) = sum(Alpha_SDA_mean_sub(depto_SDA_x<=dow & depto_SDA_x>up),'omitmissing')/point_num;
% end
% SUPERCS_NDA(isnan(SUPERCS_NDA))=0;
% SUPERCS_SDA(isnan(SUPERCS_SDA))=0;
% plot(dpe,CS_NDA*100);hold on;
% plot(dpe,SUPERCS_NDA*100);hold on;
% plot(dpe,CS_SDA*100);hold on;
% plot(dpe,SUPERCS_SDA*100);
% 
% x_alpha_NDA = dpe(SUPERCS_NDA>=0.1);
% x_alpha_SDA = dpe(SUPERCS_NDA>=0.1);
% 
% % 提取条件下的点
% y_CS = 10.*dpe(SUPERCS_NDA>=0.1)./dpe(SUPERCS_NDA>=0.1);
% y_CS1 = -10.*dpe(SUPERCS_NDA>=0.1)./dpe(SUPERCS_NDA>=0.1);
% 
% % 设置横向的半宽度
% dx = 20;
% x_fill = [x_alpha_NDA-dx; x_alpha_NDA+dx; x_alpha_NDA+dx; x_alpha_NDA-dx]; % 上下两条边
% y_fill = [y_CS;y_CS;y_CS1;y_CS1];% 左右拼接
% % 
% % % 绘制填色区域
% fill(x_fill(:,1), y_fill(:,1),[0.85,0.33,0.15], ...
%     'FaceAlpha', 0.2, ...         % 透明度
%     'EdgeColor', 'none', ...      % 去掉边框
%     'DisplayName', '\boldmath$\alpha > 1$');
% hold on;
% leg = legend('AutoUpdate','off');
% 
% fill(x_fill, y_fill,[0.85,0.33,0.15], ...
%     'FaceAlpha', 0.2, ...         % 透明度
%     'EdgeColor', 'none');
% hold on;
%%
SaveLocation = './Energy_analysis'
% Mode1
figure(1);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,1)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,1)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,1)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling');hold on;
xlim([30 3000]);ylim([-2 4]);
title(['$\langle \overline{\textbf{\textit{C}}_{1}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
% leg = legend('AutoUpdate','off');
% set(leg,...
%     'Orientation','horizontal','NumColumns',3,...
%     'Location','best',...
%     'FontSize',20,...
%     'EdgeColor',[0 0 0],...
%     'fontname','Arial','fontweight','bold',...
%     'AutoUpdate','off');
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-2:1:5],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode1_Generation_NDA_123.tiff'], 'Resolution',300);

% Mode2
figure(2);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,2)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,2)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,2)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-0.5 3.5]);
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
title(['$\langle \overline{\textbf{\textit{C}}_{2}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-0.5:0.5:3.5],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode2_Generation_NDA_123.tiff'], 'Resolution',300);

% Mode3
figure(3);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,3)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,3)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,3)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;
xlim([30 3000]);ylim([-0.2 1.2]);
title(['$\langle \overline{\textbf{\textit{C}}_{3}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-0.2:0.2:1.2],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
exportgraphics(gcf,[SaveLocation,'/Mode3_Generation_NDA_123.tiff'], 'Resolution',300);

% total
figure(4);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,4)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,4)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,4)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling');hold on;
xlim([30 3000]);ylim([-1 7]);
title(['$\langle \overline{\textbf{\textit{C}}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
xlim([0 3000]);
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-1:1:7],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k');
set(gca,'Layer','top','LineWidth',3,'TickDir','out');



% 提取条件下的点
y_CS = 10.*x_alpha_NDA./x_alpha_NDA;
y_CS1 = -10.*x_alpha_NDA./x_alpha_NDA;

% 设置横向的半宽度
dx = 20;
x_fill = [x_alpha_NDA'-dx; x_alpha_NDA'+dx; x_alpha_NDA'+dx; x_alpha_NDA'-dx]; % 上下两条边
y_fill = [y_CS';y_CS';y_CS1';y_CS1'];% 左右拼接


fill(x_fill, y_fill,[0.85,0.33,0.10], ...
    'FaceAlpha', 0.1, ...         % 透明度
    'EdgeColor', 'none');
hold on;

exportgraphics(gcf,[SaveLocation,'/Mode_total_Generation_NDA_123.tiff'], 'Resolution',300);