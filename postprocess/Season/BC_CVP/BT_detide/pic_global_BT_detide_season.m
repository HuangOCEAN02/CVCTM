clear;clc;close all
month_file = {'01','02','03','04','05','06','07','08','09','10','11','12'};
month_str = {'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'};
name_CVP = 'Barotropic_monthlymean_CVP.nc';
name_MSS = 'Barotropic_monthlymean_MSS.nc';
%%
addpath ../../Grid/
load('Grid_info.mat','ke','weto_p','depto_grid','lonp_grid','latp_grid','ddpo_grid','zzout');
load('Grid_resolution.mat', 'dlxp')
load('Grid_resolution.mat', 'dlyp')
iw = 10;ie = 1;
jn = 10;js = 10;

depto_grid  = Exclude_sponge(iw,ie,jn,js,depto_grid);
weto_p  = Exclude_sponge(iw,ie,jn,js,weto_p);
lonp_grid  = Exclude_sponge(iw,ie,jn,js,lonp_grid);
latp_grid  = Exclude_sponge(iw,ie,jn,js,latp_grid);
dlxp = Exclude_sponge(iw,ie,jn,js,dlxp);
dlyp = Exclude_sponge(iw,ie,jn,js,dlyp);
ddpo_grid= Exclude_sponge(iw,ie,jn,js,ddpo_grid);

load('CapeVerdeplateau_index.mat')
ie_cvp = length(select_indicex);
je_cvp = length(select_indicey);
depto_grid_CVP   = depto_grid(select_indicex,select_indicey);
weto_p_CVP       = weto_p(select_indicex,select_indicey,:);
lonp_grid_CVP = lonp_grid(select_indicex,select_indicey);
latp_grid_CVP = latp_grid(select_indicex,select_indicey);
dlxp_CVP = dlxp(select_indicex,select_indicey);
dlyp_CVP = dlyp(select_indicex,select_indicey);
ddpo_grid_CVP= ddpo_grid(select_indicex,select_indicey,:);
zzout_CVP= zzout(select_indicex,select_indicey,:);


load('CoastalDakar_index.mat')
ie_mss = length(select_indicex);
je_mss = length(select_indicey);
depto_grid_MSS   = depto_grid(select_indicex,select_indicey);
weto_p_MSS       = weto_p(select_indicex,select_indicey,:);
lonp_grid_MSS = lonp_grid(select_indicex,select_indicey);
latp_grid_MSS = latp_grid(select_indicex,select_indicey);
dlxp_MSS = dlxp(select_indicex,select_indicey);
dlyp_MSS = dlyp(select_indicex,select_indicey);
ddpo_grid_MSS= ddpo_grid(select_indicex,select_indicey,:);
zzout_MSS= zzout(select_indicex,select_indicey,:);

depto_grid = [depto_grid_CVP;depto_grid_MSS];
weto_p = [weto_p_CVP;weto_p_MSS];
ddpo_grid = [ddpo_grid_CVP;ddpo_grid_MSS];
zzout_grid = [zzout_CVP;zzout_MSS];
lonp_grid = [lonp_grid_CVP;lonp_grid_MSS];
latp_grid = [latp_grid_CVP;latp_grid_MSS];
dlxp_grid = [dlxp_CVP;dlxp_MSS];
dlyp_grid = [dlyp_CVP;dlyp_MSS];

load('CapeVerdeplateau_index.mat','select_indicex');
select_indicex_CVP = select_indicex;
load('CoastalDakar_index.mat','select_indicex');
select_indicex_MSS = select_indicex;
select_indicex = [select_indicex_CVP;select_indicex_MSS];
clear depto_grid_CVP depto_grid_MSS weto_p_CVP weto_p_MSS ddpo_grid_CVP ddpo_grid_MSS zzout_CVP zzout_MSS
clear lonp_grid_CVP lonp_grid_MSS latp_grid_CVP latp_grid_MSS
clear dlxp_CVP dlxp_MSS dlyp_CVP dlyp_MSS
%%
for y_year = 1:3
    if y_year == 1
        Loc_SUB_MSS=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/WithTide/post_process/Season/BC_MSS/BT_detide/'];
        Loc_SUB_CVP=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/WithTide/post_process/Season/BC_CVP/BT_detide/'];
        Loc_N2_MSS =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/WithTide/post_process/Season/Average/'];
        Loc_N2_CVP =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2014/WithTide/post_process/Season/Modal_M2_Fun/Stratification/'];
    end
    if y_year == 2
        Loc_SUB_MSS=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_MSS/BT_detide/'];
        Loc_SUB_CVP=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/BC_CVP/BT_detide/'];
        Loc_N2_MSS =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/Average/'];
        Loc_N2_CVP =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2015/WithTide/post_process/Season/Modal_M2_Fun/Stratification/'];
    end
    if y_year == 3
        Loc_SUB_MSS=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_MSS/BT_detide/'];
        Loc_SUB_CVP=['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/BC_CVP/BT_detide/'];
        Loc_N2_MSS =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/Average/'];
        Loc_N2_CVP =['/Users/josephhuang/Desktop/workingplace/风场试验/标准试验/2016/WithTide/post_process/Season/Modal_M2_Fun/Stratification/'];

    end
   
     u_CVP = double(ncread([Loc_SUB_CVP,name_CVP],'u_circulation_month'));
     v_CVP = double(ncread([Loc_SUB_CVP,name_CVP],'v_circulation_month'));
     u_CVP = reshape(u_CVP,[ie_cvp+1,je_cvp,12]);u_CVP= orctm_uv_to_p(u_CVP,'u');
     v_CVP = reshape(v_CVP,[ie_cvp,je_cvp+1,12]);v_CVP= orctm_uv_to_p(v_CVP,'v');
     u_value = sqrt(u_CVP.^2+v_CVP.^2);
     u_CVP(u_value>=0.8)=0;v_CVP(u_value>=0.8)=0;
     u_MSS = double(ncread([Loc_SUB_MSS,name_MSS],'u_circulation_month'));
     v_MSS = double(ncread([Loc_SUB_MSS,name_MSS],'v_circulation_month'));
     u_MSS = reshape(u_MSS,[ie_mss+1,je_mss,12]);u_MSS= orctm_uv_to_p(u_MSS,'u');
     v_MSS = reshape(v_MSS,[ie_mss,je_mss+1,12]);v_MSS= orctm_uv_to_p(v_MSS,'v');
     u_value = sqrt(u_MSS.^2+v_MSS.^2);
     u_MSS(u_value>=0.8)=0;v_MSS(u_value>=0.8)=0;
     % March July November
     UUU(:,:,:,y_year) = [u_CVP(:,:,[3:4:11]);u_MSS(:,:,[3:4:11])];
     VVV(:,:,:,y_year) = [v_CVP(:,:,[3:4:11]);v_MSS(:,:,[3:4:11])];
     count=0;
     for m_select = 3:4:12
         count = count+1;
         load([Loc_N2_MSS,'ave_Nsquare_',month_file{m_select},'_from_ts_MSS.mat'],'Nsquare_month');
         Nsquare_month_MSS = Nsquare_month;
         load([Loc_N2_CVP,'ave_Nsquare_',month_file{m_select},'_from_ts_CVP.mat'],'Nsquare_month');
         Nsquare_month_CVP = Nsquare_month(:,:,:);
         Nsquare_map(:,:,:) = [Nsquare_month_CVP;Nsquare_month_MSS];
         ke_level = 13; % approximately 100m
         Nsquare_ave = sum(Nsquare_map(:,:,1:ke_level).*ddpo_grid(:,:,1:ke_level),3)./sum(ddpo_grid(:,:,1:ke_level),3);
         Nsquare_ave(Nsquare_ave<1e-7)=1e-7;
         N_cph(:,:,count,y_year) = sqrt(Nsquare_ave)*3600/(2*pi);
     end

end
UUU_season=mean(UUU,4,'omitmissing');
VVV_season=mean(VVV,4,'omitmissing');
Nsquare_season=mean(N_cph,4,'omitmissing');
LATLIMS = [min(min(latp_grid)) max(max(latp_grid))];
LONLIMS = [min(min(lonp_grid)) -15];

LONLIMS = [-26.5 -15.5];
LATLIMS = [12.6 18.38];
XX_pic = lonp_grid(2:12:end-2,2:12:end-2);
ZZ_pic = latp_grid(2:12:end-2,2:12:end-2);

labelx = [-16.5,-16.15];labelz = [13.1,13.15];
Location = ['./BT_velocity_pic/']
count=0;
for m_select = 3:4:12
        count = count+1;
        N_pic = Nsquare_season(:,:,count);
        UU_pic = UUU_season(2:12:end-2,2:12:end-2,count)*100;
        VV_pic = VVV_season(2:12:end-2,2:12:end-2,count)*100;

        figure(count);clf;set(gcf,'color','w');set(gcf,'position',[50 50 900 650])
        m_proj('Mercator','lon',LONLIMS,'lat',LATLIMS);
        m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
        % SLA
        m_pcolor(lonp_grid,latp_grid,N_pic);shading interp;hold on;
        bar = colorbar;set(bar,'fontsize',25,'fontname','Arial','Location','eastoutside','fontweight','bold');hold on;
        set(get(bar,'Title'),'string','cph','fontname','Arial','fontweight','bold','Position',[-33.25,268.073912131685,0]);
        set(bar,'Ticks',[0:1:11]);
        load('wh_bl_gr_ye_re.mat');colormap(wh_bl_gr_ye_re)
        clim([3 11])
 
        if (m_select==3)
            labelu = [5,0];
            scale_month = 2.5;
            clim([3 8])
        else
            labelu = [5,0];
            scale_month = 2.5;
             clim([6 11])
        
        end
        labelv=[0,0];
        
        scale_auto = Get_Autoscale(XX_pic,ZZ_pic,UU_pic,VV_pic); 
        scale_label = Get_Autoscale(labelx,labelz,labelu,labelv);
        scale_factor = scale_auto/scale_label;
            
        UU_pic((XX_pic>=-17.1 & XX_pic<=-16) & (ZZ_pic>=12 & ZZ_pic<=13.2))=nan;
        VV_pic((XX_pic>=-17.1 & XX_pic<=-16) & (ZZ_pic>=12 & ZZ_pic<=13.2))=nan;
        
        q_minus = m_quiver(XX_pic,ZZ_pic,UU_pic,VV_pic,...
                    scale_month/scale_factor,'MaxHeadSize',0.8,'color','k','linewidth',1.0);
        set(q_minus,'MaxHeadSize',1.2);
    
        m_gshhs_h('patch',[.4 .5 .4],'edgecolor','k','linewidth',1.5);
        
        q_label= m_quiver(labelx,labelz,labelu,labelv,...
                   scale_month,'MaxHeadSize',1.5,'color','w','linewidth',1.8);
        annotation(figure(count),'textbox',...
                [0.755383197941596,0.444615384615383,0.122424242424242,0.049230769230769],...
            'String',{month_str{m_select}},...
            'LineStyle','none',...
            'FontWeight','bold',...
            'FontSize',20,...
            'FontName','Arial',...
            'FitBoxToText','off',...
            'EdgeColor','none');
        
        hold on;
        m_grid('linestyle','none','linewidth',2,'fontsize',28,'fontname','Arial');hold on;  
    
        annotation(figure(count),'textbox',...
        [0.756474533994,0.246153846153845,0.122424242424242,0.049230769230769],...
        'String',[num2str(labelu(1)),' cm s^-^1'],...
        'LineStyle','none',...
        'FontSize',14,...
        'FontWeight','bold',...
        'FontName','Arial',...
        'FitBoxToText','off',...
        'EdgeColor','none');
        exportgraphics(gcf,[Location,'Global_BT_monthly_Season_',month_file{m_select},'.tiff'], 'Resolution',300);
end