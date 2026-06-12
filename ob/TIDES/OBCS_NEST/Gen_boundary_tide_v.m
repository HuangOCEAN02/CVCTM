clear;clc;close all
% get t_md data automatically
    t_mdAddress=which('tmd');
    t_mdAddress(t_mdAddress=='\')='/';
    tideDataAddress=[t_mdAddress(1:end-5)  'DATA/Model_atlas_v1'];
%     tideDataAddress='..\..\..\..\basic data\T_md_data\DATA\Model_YS';%T_MD 数据

logfid = fopen('GenBoundaryTide_v.log.txt','w');
isoutput=1;%==1 write out ; ==0 no output files will be created
istopo = 1;%==1 apply mask
%%
datakind={'v'};
subtide_num = [1:8];
subtide_kind ={'m2','s2','n2','k2','k1','o1','p1','q1'};
%---------------ORCTM 网格参数--------------
ie_g=817;je_g=619;
load('V_MASK.mat')
% convert to radian
Gila = Gila*pi/180;
Giph = Giph*pi/180;
%-----------------gird location data--------------------------------------%
lon_w=(lon(1,:));   lat_w=(lat(1,:));
lon_e=(lon(end,:)); lat_e=(lat(end,:));
lon_n=(lon(2:end-1,1))';   lat_n=(lat(2:end-1,1))';
lon_s=(lon(2:end-1,end))'; lat_s=(lat(2:end-1,end))';

Grid_nswe=['e';'w';'s';'n'];

%---------------二进制输出参数--------------
ieee='b';
prec='real*8';
%---------------时间参数--------------
base_date=datenum(2014,09,01,0,0,0);
End_date=datenum(2014,10,01,0,0,0);

pred_date=base_date+(End_date-base_date)/2;

%---------------潮周期参数--------------
TidePeriodList = [  12.4206011981605
                    12.000000004799999
                    12.658348214571882
                    11.967234802522507
                    23.934469605045013
                    25.819341694366
                    24.06589023189846 
                    26.868356600676353];
%%
%----------------Difference along the four Open Boundaries-----------------
% V-point: ie_g*(je_g+1)
% make sure that when only 1 subtide is used, the "dlat_i", "dlon_i" "..."
% are still array of 1*N
% % DELTXY == dlat_i, :: Difference in +I's positive direction 
% dlat_iw = (giph(2,1:2:end)-giph(1,1:2:end));
% dlat_ie = (giph(ie_g,1:2:end)-giph(ie_g-1,1:2:end));
% dlat_is(1:ie_g) = (giph(2:2:end,end)-giph(1:2:end-2,end));
% dlat_in(1:ie_g) = (giph(2:2:end,1)-giph(1:2:end-2,1));
% 
% % DELTXX == dlon_i, :: Difference in +I's positive direction 
% dlon_iw = (gila(2,1:2:end)-gila(1,1:2:end)).*cos(giph(2,1:2:end));
% dlon_ie = (gila(ie_g,1:2:end)-gila(ie_g-1,1:2:end)).*cos(giph(ie_g,1:2:end));
% dlon_is(1:ie_g) = (gila(2:2:end,end)-gila(1:2:end-2,end)).*cos(giph(2:2:end,end));
% dlon_in(1:ie_g) = (gila(2:2:end,1)-gila(1:2:end-2,1)).*cos(giph(2:2:end,1));


% DELTXY == dlat_i, :: Difference in +I's positive direction 
% f minus v
dlat_iw = (Giph(2,2:2:2*je_g+2)-Giph(1,2:2:2*je_g+2));
dlat_ie = (Giph(end,2:2:2*je_g+2)-Giph(end-1,2:2:2*je_g+2));
dlat_is(1:ie_g) = (Giph(4:2:2*ie_g+2,2*je_g+2)-Giph(3:2:2*ie_g+1,2*je_g+2));
dlat_in(1:ie_g) = (Giph(4:2:2*ie_g+2,2)-Giph(3:2:2*ie_g+1,2));

% DELTXX == dlon_i, :: Difference in +I's positive direction 
dlon_iw = (Gila(2,2:2:2*je_g+2)-Gila(1,2:2:2*je_g+2)).*cos(Giph(2,2:2:2*je_g+2));
dlon_ie = (Gila(end,2:2:2*je_g+2)-Gila(end-1,2:2:2*je_g+2)).*cos(Giph(end,2:2:2*je_g+2));
dlon_is(1:ie_g) = (Gila(4:2:2*ie_g+2,2*je_g+2)-Gila(3:2:2*ie_g+1,2*je_g+2)).*cos(Giph(4:2:2*ie_g+2,2*je_g+2));
dlon_in(1:ie_g) = (Gila(4:2:2*ie_g+2,2)-Gila(3:2:2*ie_g+1,2)).*cos(Giph(4:2:2*ie_g+2,2));


%%
%-----------------计算相位订正时需要的参数---------------------
t_md_tide_list = {'m2  ','s2  ','n2  ','k2  ','k1  ','o1  ','p1  ','q1  '};
% 计算初始时刻相位V、交点订正相位U、交点订正振幅F
[U,V,F,Up,Vp,Fp] = Phase_revise(base_date,pred_date,t_md_tide_list(subtide_num));
%
locStrList={'East','West','South','North'};

for iloc = 1:4
    
    locStr=locStrList{iloc};
    disp([ '------' locStr ' Boundary'  ' ' datakind{1} '------' ])
    clear maj min pha inc alpha
    switch iloc
        
         case 1  %EAST-----------------------
                lat_HCinput = lat_e;
                lon_HCinput = lon_e;
                axisValue   = lat_e;
                mask = deute(end,:) > 0;
         case 2  %West-----------------------
                lat_HCinput = lat_w;
                lon_HCinput = lon_w;
                axisValue   = lat_w;
                mask = deute(1,:) > 0;
         case 3  %South-----------------------
                lon_HCinput = lon_s;
                lat_HCinput = lat_s;
                axisValue   = lon_s;
                mask = deute(:,end) > 0;
                mask = mask';
          case 4  %North-----------------------
                lon_HCinput = lon_n;
                lat_HCinput = lat_n;
                axisValue   = lon_n;
                mask = deute(:,1) > 0;
                mask = mask';
        end%--------------------------------------------    
   
        [Au,PHIu,Depth,conList]= tmd_extract_HC(tideDataAddress,...
                 lat_HCinput,lon_HCinput,'u',subtide_num);
        [Av,PHIv,Depth,conList]= tmd_extract_HC(tideDataAddress,...
                 lat_HCinput,lon_HCinput,'v',subtide_num);
         
        eval(['alpha = atan2d(dlat_i',Grid_nswe(iloc),',dlon_i',Grid_nswe(iloc),');']);         
        [maj,ecc,inc,pha] = ORCTM_ellipse(Au, PHIu, Av, PHIv, alpha);             
        % umajor,uminor,uphase,uincl - tidal ellipse parameters (cm/s,o) in lat,lon
        
      
        
        % make sure that when only 1 subtide is used, the "maj", "ecc" "..."
        % are still array of 1*N
        if length(subtide_kind)==1
            if size(umaj,1)~=1
                maj=maj';
                ecc=ecc';
                pha=pha';
                inc=inc';
            end
        end        
        
         %------ ignore boundary without water grid
        if sum(mask) == 0
            temstr = [locStr ' is all land'];
            disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
            disp(temstr)
            disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
            fprintf(logfid,'%s \n',temstr);
            
            amp([1:size(subtide_kind,2)],[1:length(mask)]) = 0;
            Gph([1:size(subtide_kind,2)],[1:length(mask)]) = 0;
            if isoutput
                fid=fopen(['OB_' locStr '_' datakind{1} '_Amp.bin'],'w',ieee); 
                fwrite(fid,amp',prec); fclose(fid);
                fid=fopen(['OB_' locStr '_' datakind{1} '_Gph.bin'],'w',ieee); 
                fwrite(fid,Gph',prec); fclose(fid);
            end            
            
            continue
        end
        
        [u_amp,u_gph,amp,Gph] = ep2ap(maj,ecc,inc,pha);
        
        amp0=amp;
        Gph0=Gph;
        
        %interpolatoin ----------------------------------------------------
        Gphx=cosd(Gph);
        Gphy=sind(Gph);
        for ii=1:size(amp,1)
            validloc = ~isnan(amp(ii,:));
            amp(ii,:) = interp1(axisValue(validloc),amp(ii,validloc),axisValue,'linear');
            Gphx(ii,:) = interp1(axisValue(validloc),Gphx(ii,validloc),axisValue,'nearest');
            Gphy(ii,:) = interp1(axisValue(validloc),Gphy(ii,validloc),axisValue,'nearest');
            % Gph(ii,:) = interp1(axisValue(validloc),Gph(ii,validloc),axisValue,'nearest','extrap');
        end
        
        for ii=1:size(amp,1)
            validloc = ~isnan(amp(ii,:));
            amp(ii,:) = interp1(axisValue(validloc),amp(ii,validloc),axisValue,'nearest','extrap');
            Gphx(ii,:) = interp1(axisValue(validloc),Gphx(ii,validloc),axisValue,'nearest','extrap');
            Gphy(ii,:) = interp1(axisValue(validloc),Gphy(ii,validloc),axisValue,'nearest','extrap');
           % Gph(ii,:) = interp1(axisValue(validloc),Gph(ii,validloc),axisValue,'nearest','extrap');
        end
        % get Gph from Gph*cosd & Gph*sind
        Gph = atan2(Gphy,Gphx)/pi*180;
        Gph(Gph<0)=Gph(Gph<0)+360;
        
        % apply mask mat --------------------------------------------------
        if istopo
            for ii=1:size(amp,1)
                amp(ii,:)=amp(ii,:).*mask;
                Gph(ii,:)=Gph(ii,:).*mask; % It's not necessary
            end
        end
		%------------------------------------------------------------------
                
        % 相位订正&振幅订正
        [amp,Gph] = g2Phase(amp,Gph,U,V,F,Up,Vp,Fp);

        %对Gph做订正使其满足量纲[s]的要求        
        for ii=1:size(Gph,1)
            Gph(ii,:) = (Gph(ii,:)/180*pi)/(2*pi)*TidePeriodList(subtide_num(ii))*3600;
        end
        
        %对amp做订正使其满足量纲[m/s]的要求
        amp = amp./100.0;
        
        eval([locStr '.' datakind{1} '.amp = amp;']);
        eval([locStr '.' datakind{1} '.Gph = Gph;']);
        
        if isoutput
         
        save(['Tide_OB_' locStr '_' datakind{1} '.mat'], locStr, ['lon_',Grid_nswe(iloc)] ,['lat_',Grid_nswe(iloc)],['mask'])
        fid=fopen(['OB_' locStr '_' datakind{1} '_Amp.bin'],'w',ieee); fwrite(fid,amp',prec); fclose(fid);
        fid=fopen(['OB_' locStr '_' datakind{1} '_Gph.bin'],'w',ieee); fwrite(fid,Gph',prec); fclose(fid);
        end
end 
        
        
        
        