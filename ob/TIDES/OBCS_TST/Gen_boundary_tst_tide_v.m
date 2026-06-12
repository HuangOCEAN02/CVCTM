clear;clc;close all
% get t_md data automatically
    t_mdAddress=which('tmd');
    t_mdAddress(t_mdAddress=='\')='/';
    tideDataAddress=[t_mdAddress(1:end-5)  'DATA/Model_atlas_v1'];
%     tideDataAddress='..\..\..\..\basic data\T_md_data\DATA\Model_YS';%T_MD 数据

logfid = fopen('GenBoundary_Tst_Tide_v.log.txt','w');
isoutput=1;%==1 write out ; ==0 no output files will be created
istopo = 1;%==1 apply mask
istmd = 1;%==1 apply tmd ; ==0 apply parent domain
addpath ../OBCS_NEST/
%%
datakind={'v'};
subtide_num = [1:8];
subtide_kind ={'m2','s2','n2','k2','k1','o1','p1','q1'};
%---------------潮周期参数--------------
TidePeriodList = [  12.4206011981605
                    12.000000004799999
                    12.658348214571882
                    11.967234802522507
                    23.934469605045013
                    25.819341694366
                    24.06589023189846 
                    26.868356600676353];

%---------------ORCTM 网格参数--------------
ie_g=817;je_g=619;
load('../OBCS_NEST/V_MASK.mat')
% convert to radian
Gila = Gila*pi/180;
Giph = Giph*pi/180;
%-----------------TST gird location data--------------------------------------%
%-------------- tangential component inclued OB grid ----------------%
lon_w=(lon(2:4,:));   lat_w=(lat(2:4,:));
lon_e=(lon(end-3:end-1,:)); lat_e=(lat(end-3:end-1,:));
%-------------- normal component exluded OB grid ----------------------%
lon_n=(lon(2:end-1,2:4))';   lat_n=(lat(2:end-1,2:4))';
lon_s=(lon(2:end-1,end-3:end-1))'; lat_s=(lat(2:end-1,end-3:end-1))';

Grid_nswe=['e';'w';'s';'n'];
%---------------Model Grid Projection--------------
% DELTXY == dlat_i :: Difference in +I's positive direction 
% f minus v
dlat_iw(1:3,1:je_g+1) = (Giph(4:2:8,2:2:2*je_g+2)-Giph(3:2:7,2:2:2*je_g+2));
dlat_ie(1:3,1:je_g+1) = (Giph(end-5:2:end-1,2:2:2*je_g+2)-Giph(end-6:2:end-2,2:2:2*je_g+2));
dlat_is(1:ie_g,1:3) = (Giph(4:2:2*ie_g+2,end-7:2:end-3)-Giph(3:2:2*ie_g+1,end-7:2:end-3));
dlat_in(1:ie_g,1:3) = (Giph(4:2:2*ie_g+2,4:2:8)-Giph(3:2:2*ie_g+1,4:2:8));

% DELTXX == dlon_i, :: Difference in +I's positive direction 
dlon_iw(1:3,1:je_g+1) = (Gila(4:2:8,2:2:2*je_g+2)-Gila(3:2:7,2:2:2*je_g+2)).*cos(Giph(4:2:8,2:2:2*je_g+2));
dlon_ie(1:3,1:je_g+1) = (Gila(end-5:2:end-1,2:2:2*je_g+2)-Gila(end-6:2:end-2,2:2:2*je_g+2)).*cos(Giph(end-5:2:end-1,2:2:2*je_g+2));
dlon_is(1:ie_g,1:3) = (Gila(4:2:2*ie_g+2,end-7:2:end-3)-Gila(3:2:2*ie_g+1,end-7:2:end-3)).*cos(Giph(4:2:2*ie_g+2,end-7:2:end-3));
dlon_in(1:ie_g,1:3) = (Gila(4:2:2*ie_g+2,4:2:8)-Gila(3:2:2*ie_g+1,4:2:8)).*cos(Giph(3:2:2*ie_g+1,4:2:8));

dlat_is = dlat_is';
dlat_in = dlat_in';
dlon_is = dlon_is';
dlon_in = dlon_in';

%---------------二进制输出参数--------------
ieee='b';
prec='real*8';
%---------------时间参数--------------
% base_date=datenum(2013,12,01,0,0,0);
% End_date=datenum(2014,01,01,0,0,0);

% base_date=datenum(2014,01,01,0,0,0);
% End_date=datenum(2014,04,01,0,0,0);
% 
% base_date=datenum(2014,04,01,0,0,0);
% End_date=datenum(2014,07,01,0,0,0);

% base_date=datenum(2014,07,01,0,0,0);
% End_date=datenum(2014,10,01,0,0,0);

base_date=datenum(2014,09,01,0,0,0);
End_date=datenum(2014,10,01,0,0,0);

% base_date=datenum(2014,10,01,0,0,0);
% End_date=datenum(2015,01,01,0,0,0);
%
pred_date=base_date+(End_date-base_date)/2;
%
%%
%-----------------计算相位订正时需要的参数---------------------
t_md_tide_list = {'m2  ','s2  ','n2  ','k2  ','k1  ','o1  ','p1  ','q1  '};
% 计算初始时刻相位V、交点订正相位U、交点订正振幅F
[U,V,F,Up,Vp,Fp] = Phase_revise(base_date,pred_date,t_md_tide_list(subtide_num));
%
locStrList={'East','West','South','North'};

for iloc = 1:4
%
    locStr=locStrList{iloc};
    disp([ '------' locStr ' Boundary'  ' ' datakind{1} '------' ])
%
    clear maj min pha inc alpha
    clear AMP GPH
%
    switch iloc
        
         case 1  %EAST-----------------------
                lat_HCinput = lat_e;
                lon_HCinput = lon_e;
                axisValue   = lat_e;
                mask = deute(end-2:end,:) > 0;
         case 2  %West-----------------------
                lat_HCinput = lat_w;
                lon_HCinput = lon_w;
                axisValue   = lat_w;
                mask = deute(1:3,:) > 0;
         case 3  %South-----------------------
                lon_HCinput = lon_s;
                lat_HCinput = lat_s;
                axisValue   = lon_s;
                mask = deute(:,end-3:end-1) > 0;
                mask = mask';
          case 4  %North-----------------------
                lon_HCinput = lon_n;
                lat_HCinput = lat_n;
                axisValue   = lon_n;
                mask = deute(:,2:4) > 0;
                mask = mask';
     end%-------------------------------------------- 
%   
        % Please Make Sure the size of
        % lon, lat, axisValue, and mask : 3 * N
%%  
        AMP = zeros(size(subtide_kind,2),size(mask,2),3);
        GPH = zeros(size(subtide_kind,2),size(mask,2),3);
%
        for Line = 1 : 3
%
          axisValue_line = axisValue(Line,:);
          if  istmd
            [Au,PHIu,Depth,conList]= tmd_extract_HC(tideDataAddress,...
                 lat_HCinput(Line,:),lon_HCinput(Line,:),'u',subtide_num);
            [Av,PHIv,Depth,conList]= tmd_extract_HC(tideDataAddress,...
                 lat_HCinput(Line,:),lon_HCinput(Line,:),'v',subtide_num);
          else
         %------ From Parent results


         %------ 
          end
         %------  Model Grid Projection
         %  -180 <= atan2d(Y,X) <= 180.
          eval(['alpha = atan2d(dlat_i',Grid_nswe(iloc),'(',num2str(Line),',:),' ...
              ,'dlon_i',Grid_nswe(iloc),'(',num2str(Line),',:));']);         
          [maj,ecc,inc,pha] = ORCTM_ellipse(Au, PHIu, Av, PHIv, alpha);

           % umajor,uminor,uphase,uincl - tidal ellipse parameters (cm/s,o) in lat,lon
           % make sure that when only 1 subtide is used, the "maj", "min" "..."
           % are still array of 1 (subtide number) * N
           if length(subtide_kind)==1
                if size(umaj,1)~=1
                    maj=maj';
                    ecc=ecc';
                    pha=pha';
                    inc=inc';
                end
           end        
         %------ Check boundary land grid
           if Line == 1  % The OB line or column is land
                if sum(mask(Line,:)) == 0 % This line or column is land
                    temstr = [locStr,' : No.',num2str(Line),' is all land'];
                    disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')
                    disp(temstr)
                    disp('<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<')                    
                    AMP([1:size(subtide_kind,2)],[1:size(mask,2)],[1:3]) = 0;
                    GPH([1:size(subtide_kind,2)],[1:size(mask,2)],[1:3]) = 0;
                  % which does not need generate file
%                   if isoutput
%                       fid=fopen(['OB_' locStr '_' datakind{1} '_Amp.bin'],'w',ieee); 
%                       fwrite(fid,amp',prec); fclose(fid);
%                       fid=fopen(['OB_' locStr '_' datakind{1} '_Gph.bin'],'w',ieee); 
%                       fwrite(fid,Gph',prec); fclose(fid);
%                   end            
            
                break

                end
           end       

           [u_amp,u_gph,amp,Gph] = ep2ap(maj,ecc,inc,pha);

           amp0=amp;
           Gph0=Gph;

%------------interpolatoin ------------------------------------------------
           Gphx=cosd(Gph);
           Gphy=sind(Gph);
           for ii=1:size(amp,1)
                validloc = ~isnan(amp(ii,:));
                amp(ii,:) = interp1(axisValue_line(validloc),amp(ii,validloc),axisValue_line,'linear');
                Gphx(ii,:) = interp1(axisValue_line(validloc),Gphx(ii,validloc),axisValue_line,'nearest');
                Gphy(ii,:) = interp1(axisValue_line(validloc),Gphy(ii,validloc),axisValue_line,'nearest');
            % Gph(ii,:) = interp1(axisValue_line(validloc),Gph(ii,validloc),axisValue_line,'nearest','extrap');
           end
        
           for ii=1:size(amp,1)
                validloc = ~isnan(amp(ii,:));
                amp(ii,:) = interp1(axisValue_line(validloc),amp(ii,validloc),axisValue_line,'nearest','extrap');
                Gphx(ii,:) = interp1(axisValue_line(validloc),Gphx(ii,validloc),axisValue_line,'nearest','extrap');
                Gphy(ii,:) = interp1(axisValue_line(validloc),Gphy(ii,validloc),axisValue_line,'nearest','extrap');
           % Gph(ii,:) = interp1(axisValue_line(validloc),Gph(ii,validloc),axisValue_line,'nearest','extrap');
           end
            % get Gph from Gph*cosd & Gph*sind
           Gph = atan2(Gphy,Gphx)/pi*180;
           Gph(Gph<0)=Gph(Gph<0)+360;

            % apply mask mat --------------------------------------------------
           if istopo
                for ii=1:size(amp,1)
                    amp(ii,:)=amp(ii,:).*mask(Line,:);
                    Gph(ii,:)=Gph(ii,:).*mask(Line,:); % It's not necessary
                end
           end

           % 相位订正&振幅订正
           [amp,Gph] = g2Phase(amp,Gph,U,V,F,Up,Vp,Fp);

           %对Gph做订正使其满足量纲[s]的要求
           for ii=1:size(Gph,1)
                Gph(ii,:) = (Gph(ii,:)/180*pi)/(2*pi)*TidePeriodList(subtide_num(ii))*3600;
           end
        
           %对amp做订正使其满足量纲[m/s]的要求
           amp = amp./100.0;

		%------------------------------------------------------------------
           AMP(:,:,Line) = amp;
           GPH(:,:,Line) = Gph;

        end

        eval([locStr '.' datakind{1} '.amp = AMP;']);
        eval([locStr '.' datakind{1} '.Gph = GPH;']);

        if isoutput && sum(mask(1,:)) ~= 0
            save(['./OB_tst/Tide_TSTOB_' locStr '_' datakind{1} '.mat'], locStr, ['lon_',Grid_nswe(iloc)] ,['lat_',Grid_nswe(iloc)],['mask'])
            fid_amp=fopen(['./OB_tst/OBTST_' locStr '_' datakind{1} '_Amp.bin'],'w',ieee); 
            for ii=1:3
                out = AMP(:,:,ii);
                out = squeeze(out);
                fwrite(fid_amp,out',prec);
            end
            fclose(fid_amp);
            fid_gph=fopen(['./OB_tst/OBTST_' locStr '_' datakind{1} '_Gph.bin'],'w',ieee); 
            for ii=1:3
                out = GPH(:,:,ii);
                out = squeeze(out);
                fwrite(fid_gph,out',prec); 
            end
            fclose(fid_gph);
        end 
end


temstr = ['-----------all done!-----------'];
fprintf(logfid,'%s \n',temstr);
fclose(logfid);

disp('All done!') 







