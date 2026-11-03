clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
SaveLocation = './Energy_analysis'
imodes = 10;
isfile = 1;
%%
for m_select = 1: 12
    SaveLocation = './Energy_analysis'
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

    load([SaveLocation,'/Generation_depth_Mode3_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_ALL(:,m_select,3) = C_NDA_sum(:);
    C_SDA_ALL(:,m_select,3) = C_SDA_sum(:);

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

    load([SaveLocation,'/Generation_depth_Mode3_', month_file{m_select}, '.mat'], ...
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

    load([SaveLocation,'/Generation_depth_Mode3_', month_file{m_select}, '.mat'], ...
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

% check conservation
sum(sum(C_NDA_ALL(:,:,1:3),3),"all","omitmissing")./sum(C_NDA_ALL(:,:,4),'all','omitmissing')
sum(sum(C_SDA_ALL(:,:,1:3),3),"all","omitmissing")./sum(C_SDA_ALL(:,:,4),'all','omitmissing')

% 5-8
C_NDA_relaxation = squeeze(mean(C_NDA_ALL(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_relaxation = squeeze(mean(C_SDA_ALL(:,[5:8,12+5:12+8,24+5:24+8],:),2));


% 9-12
C_NDA_summer = squeeze(mean(C_NDA_ALL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_summer = squeeze(mean(C_SDA_ALL(:,[9:12,12+9:12+12,24+9:24+12],:),2));

%% Local generation 
for m_select = 1: 12
    SaveLocation = './Energy_analysis'
    load([SaveLocation,'/LocalGeneration_depth_InterMode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select,1) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select,1) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select,2) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select,2) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select,3) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select,3) = C_SDA_sum(:);

end

for m_select = 1: 12
    SaveLocation = '../../../../../2015/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/LocalGeneration_depth_InterMode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12,1) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12,1) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12,2) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12,2) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12,3) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12,3) = C_SDA_sum(:);

end


for m_select = 1: 12
    SaveLocation = '../../../../../2016/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/LocalGeneration_depth_InterMode1_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12+12,1) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12+12,1) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode2_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12+12,2) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12+12,2) = C_SDA_sum(:);

    load([SaveLocation,'/LocalGeneration_depth_Mode_Three_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOCAL(:,m_select+12+12,3) = C_NDA_sum(:);
    C_SDA_LOCAL(:,m_select+12+12,3) = C_SDA_sum(:);
end
clear C_NDA_sum C_SDA_sum
%%
C_NDA_NON_LOCAL = C_NDA_ALL(:,:,[1:3]) - C_NDA_LOCAL;
C_SDA_NON_LOCAL = C_SDA_ALL(:,:,[1:3]) - C_SDA_LOCAL;
% 1-4
C_NDA_LOCAL_upwelling = squeeze(mean(C_NDA_LOCAL(:,[1:4,12+1:12+4,24+1:24+4],:),2));
C_SDA_LOCAL_upwelling = squeeze(mean(C_SDA_LOCAL(:,[1:4,12+1:12+4,24+1:24+4],:),2));

C_NDA_NON_LOCAL_upwelling = squeeze(mean(C_NDA_NON_LOCAL(:,[1:4,12+1:12+4,24+1:24+4],:),2));
C_SDA_NON_LOCAL_upwelling = squeeze(mean(C_SDA_NON_LOCAL(:,[1:4,12+1:12+4,24+1:24+4],:),2));

% 5-8
C_NDA_LOCAL_relaxation = squeeze(mean(C_NDA_LOCAL(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_LOCAL_relaxation = squeeze(mean(C_SDA_LOCAL(:,[5:8,12+5:12+8,24+5:24+8],:),2));

C_NDA_NON_LOCAL_relaxation = squeeze(mean(C_NDA_NON_LOCAL(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_NON_LOCAL_relaxation = squeeze(mean(C_SDA_NON_LOCAL(:,[5:8,12+5:12+8,24+5:24+8],:),2));

% 9-12
C_NDA_LOCAL_summer = squeeze(mean(C_NDA_LOCAL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_LOCAL_summer = squeeze(mean(C_SDA_LOCAL(:,[9:12,12+9:12+12,24+9:24+12],:),2));

C_NDA_NON_LOCAL_summer = squeeze(mean(C_NDA_NON_LOCAL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_NON_LOCAL_summer = squeeze(mean(C_SDA_NON_LOCAL(:,[9:12,12+9:12+12,24+9:24+12],:),2));
%% Low mode generation (1-3) from higher modes
for m_select = 1: 12
    SaveLocation = './Energy_analysis'
    load([SaveLocation,'/Lowmode_Generation_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOWMODE(:,m_select,1) = C_NDA_sum(:);
    C_SDA_LOWMODE(:,m_select,1) = C_SDA_sum(:);
end

for m_select = 1: 12
    SaveLocation = '../../../../../2015/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/Lowmode_Generation_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOWMODE(:,m_select+12,1) = C_NDA_sum(:);
    C_SDA_LOWMODE(:,m_select+12,1) = C_SDA_sum(:);
end

for m_select = 1: 12
    SaveLocation = '../../../../../2016/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/Lowmode_Generation_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_LOWMODE(:,m_select+12+12,1) = C_NDA_sum(:);
    C_SDA_LOWMODE(:,m_select+12+12,1) = C_SDA_sum(:);
end
clear C_NDA_sum C_SDA_sum
% 1-4
C_NDA_LOW_upwelling = squeeze(mean(C_NDA_LOWMODE(:,[1:4,12+1:12+4,24+1:24+4],:),2));
C_SDA_LOW_upwelling = squeeze(mean(C_SDA_LOWMODE(:,[1:4,12+1:12+4,24+1:24+4],:),2));
% 5-8
C_NDA_LOW_relaxation = squeeze(mean(C_NDA_LOWMODE(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_LOW_relaxation = squeeze(mean(C_SDA_LOWMODE(:,[5:8,12+5:12+8,24+5:24+8],:),2));
% 9-12
C_NDA_LOW_summer = squeeze(mean(C_NDA_LOWMODE(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_LOW_summer = squeeze(mean(C_SDA_LOWMODE(:,[9:12,12+9:12+12,24+9:24+12],:),2));
%% High mode generation
for m_select = 1: 12
    SaveLocation = './Energy_analysis'
    load([SaveLocation,'/HighGeneration_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_HIGHMODE(:,m_select,1) = C_NDA_sum(:);
    C_SDA_HIGHMODE(:,m_select,1) = C_SDA_sum(:);
end

for m_select = 1: 12
    SaveLocation = '../../../../../2015/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/HighGeneration_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_HIGHMODE(:,m_select+12,1) = C_NDA_sum(:);
    C_SDA_HIGHMODE(:,m_select+12,1) = C_SDA_sum(:);
end

for m_select = 1: 12
    SaveLocation = '../../../../../2016/Withtide/post_process/Season/BC_MSS/Energy_analysis';
    load([SaveLocation,'/HighGeneration_depth_', month_file{m_select}, '.mat'], ...
     'C_NDA_sum','C_SDA_sum','dpe');
    C_SDA_sum =C_SDA_sum*1e-6;
    C_NDA_sum =C_NDA_sum*1e-6;    
    C_NDA_HIGHMODE(:,m_select+12+12,1) = C_NDA_sum(:);
    C_SDA_HIGHMODE(:,m_select+12+12,1) = C_SDA_sum(:);
end
clear C_NDA_sum C_SDA_sum
% 1-4
C_NDA_HIGH_upwelling = squeeze(mean(C_NDA_HIGHMODE(:,[1:4,12+1:12+4,24+1:24+4],:),2));
C_SDA_HIGH_upwelling = squeeze(mean(C_SDA_HIGHMODE(:,[1:4,12+1:12+4,24+1:24+4],:),2));
% 5-8
C_NDA_HIGH_relaxation = squeeze(mean(C_NDA_HIGHMODE(:,[5:8,12+5:12+8,24+5:24+8],:),2));
C_SDA_HIGH_relaxation = squeeze(mean(C_SDA_HIGHMODE(:,[5:8,12+5:12+8,24+5:24+8],:),2));
% 9-12
C_NDA_HIGH_summer = squeeze(mean(C_NDA_HIGHMODE(:,[9:12,12+9:12+12,24+9:24+12],:),2));
C_SDA_HIGH_summer = squeeze(mean(C_SDA_HIGHMODE(:,[9:12,12+9:12+12,24+9:24+12],:),2));

%% pic
if ~exist('FIG5','dir'); mkdir FIG5; end
SaveLocation = './FIG5'
% Mode1
figure(1);clf;set(gcf,'position',[10 10 850 350]);
% yyaxis left
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,1)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,1)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,1)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling');hold on;


% leg = legend('AutoUpdate','off');
% set(leg,...
%     'Orientation','horizontal','NumColumns',3,...
%     'Location','best',...
%     'FontSize',20,...
%     'EdgeColor',[0 0 0],...
%     'fontname','Arial','fontweight','bold',...
%     'AutoUpdate','off');
% yyaxis right
% l11 = plot([0,dpe],[0;C_NDA_LOCAL_upwelling(:,1)],'Color','b','linestyle','-.','linewidth',2);hold on;
% l22 = plot([0,dpe],[0;C_NDA_LOCAL_relaxation(:,1)],'Color','k','linestyle','-.','linewidth',2);hold on;
% l33 = plot([0,dpe],[0;C_NDA_LOCAL_summer(:,1)],'Color','r','linestyle','-.','linewidth',2);hold on;


xlim([30 3000]);
ylim([-1 4.5]);
title(['$\langle \overline{\textbf{\textit{C}}_{1}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);

% set(leg,...
%     'Orientation','horizontal','NumColumns',3,...
%     'Location','best',...
%     'FontSize',20,...
%     'EdgeColor',[0 0 0],...
%     'fontname','Arial','fontweight','bold',...
%     'AutoUpdate','off');
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-5:1:10],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
if isfile
    exportgraphics(gcf,[SaveLocation,'/Mode1_Generation_NDA_new.tiff'], 'Resolution',300);
end
% Mode2
figure(2);clf;set(gcf,'position',[10 10 850 350]);
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,2)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling season');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,2)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation season');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,2)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling season');hold on;

xlim([30 3000]);ylim([0 3.5]);
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;

title(['$\langle \overline{\textbf{\textit{C}}_{2}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
xlim([0 3000]);
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-4.5:0.5:4.5],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
if isfile
    exportgraphics(gcf,[SaveLocation,'/Mode2_Generation_NDA_new.tiff'], 'Resolution',300);
end
% High_modes
figure(3);clf;set(gcf,'position',[10 10 850 350]);
l11 = plot([0,dpe],[0;C_NDA_HIGH_upwelling],'Color','b','linestyle','-','linewidth',2);hold on;
l22 = plot([0,dpe],[0;C_NDA_HIGH_relaxation],'Color','k','linestyle','-','linewidth',2);hold on;
l33 = plot([0,dpe],[0;C_NDA_HIGH_summer],'Color','r','linestyle','-','linewidth',2);hold on;

xlim([30 3000]);ylim([-4.0 3.5]);

title(['$\langle \overline{\textbf{\textit{C}}_{\epsilon}} \rangle$'],'fontsize',25,'Interpreter','latex')
grid on;
l4 = plot([0,dpe],[0;C_NDA_summer(:,4)-C_NDA_summer(:,4)],'Color','k','linestyle','-.','linewidth',2);hold on;
set(gca,'fontsize',25,'fontname','Arial');
set(gca,'xlim',[0 3000],'XTick',[0:500:3500],'YTick',[-5.5:1:5.5],'fontname','Arial','fontweight','bold');
set(gca,'Layer','top','linewidth',2,'Gridalpha',0.1);
set(gca,'GridLineStyle','--','GridColor',[.2 .2 .2]','GridAlpha',0.2);
set(gca,'YColor','k','XTickLabel',{' '});
set(gca,'Layer','top','LineWidth',3,'TickDir','out')
if isfile
    exportgraphics(gcf,[SaveLocation,'/ModeHigh_Generation_NDA_new.tiff'], 'Resolution',300);
end
% total
figure(4);clf;set(gcf,'position',[10 10 850 350]);

% total generation
l1 = plot([0,dpe],[0;C_NDA_upwelling(:,4)],'Color','b','linestyle','-','linewidth',2,'DisplayName','Upwelling');hold on;
l2 = plot([0,dpe],[0;C_NDA_relaxation(:,4)],'Color','k','linestyle','-','linewidth',2,'DisplayName','Relaxation');hold on;
l3 = plot([0,dpe],[0;C_NDA_summer(:,4)],'Color','r','linestyle','-','linewidth',2,'DisplayName','Downwelling');hold on;


% l11 = plot([0,dpe],[0;C_NDA_LOCAL_upwelling(:,1)],'Color','b','linestyle','-.','linewidth',2);hold on;
% l22 = plot([0,dpe],[0;C_NDA_LOCAL_relaxation(:,1)],'Color','k','linestyle','-.','linewidth',2);hold on;
% l33 = plot([0,dpe],[0;C_NDA_LOCAL_summer(:,1)],'Color','r','linestyle','-.','linewidth',2);hold on;



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

if isfile
    exportgraphics(gcf,[SaveLocation,'/Mode_total_Generation_NDA_new.tiff'], 'Resolution',300);
end

%% calculate the contributions
% check the conservation
(sum(C_NDA_upwelling(:,1))+sum(C_NDA_upwelling(:,2))+sum(C_NDA_upwelling(:,3)))./sum(C_NDA_upwelling(:,4))

(sum(C_NDA_relaxation(:,1))+sum(C_NDA_relaxation(:,2)))./sum(C_NDA_relaxation(:,4))
(sum(C_NDA_summer(:,1))+sum(C_NDA_summer(:,2)))./sum(C_NDA_summer(:,4))
% mode1
sum(C_NDA_upwelling(:,1))./sum(C_NDA_upwelling(:,4))
sum(C_NDA_relaxation(:,1))./sum(C_NDA_relaxation(:,4))
sum(C_NDA_summer(:,1))./sum(C_NDA_summer(:,4))
% mode1+mode2
(sum(C_NDA_upwelling(:,1))+sum(C_NDA_upwelling(:,2)))./sum(C_NDA_upwelling(:,4))
(sum(C_NDA_relaxation(:,1))+sum(C_NDA_relaxation(:,2)))./sum(C_NDA_relaxation(:,4))
(sum(C_NDA_summer(:,1))+sum(C_NDA_summer(:,2)))./sum(C_NDA_summer(:,4))
% mode2
sum(C_NDA_upwelling(:,2))./sum(C_NDA_upwelling(:,4));
sum(C_NDA_relaxation(:,2))./sum(C_NDA_relaxation(:,4))
sum(C_NDA_summer(:,2))./sum(C_NDA_summer(:,4));


(sum(C_SDA_upwelling(:,1))+sum(C_SDA_upwelling(:,2)))./sum(C_SDA_upwelling(:,4))
(sum(C_SDA_relaxation(:,1))+sum(C_SDA_relaxation(:,2)))./sum(C_SDA_relaxation(:,4))
(sum(C_SDA_summer(:,1))+sum(C_SDA_summer(:,2)))./sum(C_SDA_summer(:,4))