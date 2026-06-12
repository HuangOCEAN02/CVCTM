function [SREG] = BLN2HOP_new(IFE_1,JFE_1,IE_1,JE_1,ALAT2,ALON2,ALAT1,ALON1,SOE,land)
%             H = BLN2HOP(bx,by,nx,ny,LAT_ORI,LON_ORI,LAT_GRID,LON_GRID,Bathmetry);
% BILINEAR INTERPOLATION 
% FROM ONE ORIGNAL GRID[(IFE_1,JFE_1),ALAT2,ALON2] 
% TO ANOTHER REGIONAL GRID[(IE_1,JE_1),ALAT1,ALON1]
% soe即强迫场数据 
% sreg即插值后的强迫场
%  disp(['BILINEAR INTERPOLATION START']);
      API = 3.1415926;
aradtogra = 180.0/API;
      eps = 1.E-12;
ALAT2 = ALAT2*aradtogra;
ALON2 = ALON2*aradtogra;
ALAT1 = ALAT1*aradtogra;
ALON1 = ALON1*aradtogra;

HHX = SOE;
% Choose sea pointbefore this, land and w-d(wet-dry) points equal 1 
% Landpoint = 1;  Seapoint = 0
hg = zeros(IFE_1,JFE_1)+1; % Seapoint = 1
hg(land >= 0.5) = eps; % Landpoint = 1.E-12


G = hg;
HX = HHX;
for ITER = 1:1
     for J=2:JFE_1-1
         JO=J-1;
         JU=J+1;
         for I=2:IFE_1-1
            IL=I-1;
         	IR=I+1;
            RSUMG=0.0;         
            if (land(I,J) >= 0.5) 
            	RSUMG = (4.*G(I,J)+G(IL,J)+G(IR,J)+G(I,JO)+G(I,JU))/8.0;
				% 8 points smooth
           	    HG(I,J) = min([RSUMG,0.125]);           		
                HHX(I,J)=(4.*HX(I,J)*G(I,J)...
                 		+HX(IL,J)*G(IL,J)...
                 		+HX(IR,J)*G(IR,J)...
                 		+HX(I,JO)*G(I,JO)...
                 		+HX(I,JU)*G(I,JU))/8.0;
                HHX(I,J)=HHX(I,J)/RSUMG;           		
            end
         end  
     end
end
SOE = HHX;

SOE(abs(SOE) < eps) = 0;
G = hg; 
SREG = zeros(IE_1,JE_1);
%  ************ BILINEAR INTERPOLATION  ************************************
% mkanta: 2:IE_1-1 2:JE_1-1
% new_spongerlayer: 1:IE_1 1:JE_1
  for M=1:IE_1
    for N=1:JE_1

      % alat2 alon2 :  Orignal Grid 【LAT_ORI,LON_ORI】
        % alat2: the line [line from 1(N) to JFE(S)] is same number
        % alon2: the row   [row from 1(W) to IFE(E)] is same number
      % alat1 alon1 : Regional Gird 【LAT_GRID,LON_GRID】
      
      % find the line
      for J=1:JFE_1
        if (ALAT2(2, J) >= ALAT1(M,N)) 
            JO=J;
        end
      end
      
      % find the row
      for I=1:IFE_1
        if (ALON2(I,2) <= ALON1(M,N))
            IL=I;
        end
      end
      
      JLU=JO+1;
      ILU=IL;
   % JO=J at this point (line:JLU-1) alon2 >= alat1(m,n)
   % IL=I at this point (row:ILU)    alon2 <= alon1(m,n)
   
   %                N------------------------------S 
   %      W             (ILU,JLU-1)      (ILU,JLU)
   %      |         -        ---------------
   %      |    BETA |        |             |
   %      |         |        |             |
   %      |         -        |      *      |
   %      |  1-BETA |        |    (m,n)    |
   %      |         |        |             |
   %      |         -        ---------------
   %      |            (ILU+1,JLU-1)    (ILU+1,JLU)
   %      |
   %      E                  |------|------|
   %                          1-ALPHA ALPHA   


      WWWALPHA = ALAT2(ILU,JLU)-ALAT1(M,N);
      WWWBETA  = ALON2(ILU,JLU)-ALON1(M,N);
      
      if(WWWBETA >= API) 
         WWWBETA = WWWBETA-2.0*API;
      end
      if(WWWBETA <= -API) 
         WWWBETA = WWWBETA+2.0*API;
      end
      
   % --- normalizing
      ALPHA = (WWWALPHA)/(ALAT2(ILU,JLU)-ALAT2(ILU,JLU-1));
      BETA  = (WWWBETA)/(ALON2(ILU,JLU)-ALON2(ILU+1,JLU));
   % --- interpolating
        SREG(M,N)=ALPHA*BETA*SOE(ILU+1,JLU-1)*G(ILU+1,JLU-1)...
                  +(1.0-ALPHA)*(1.0-BETA)*SOE(ILU,JLU)*G(ILU,JLU)...
                  +(1.0-ALPHA)*(BETA)*SOE(ILU+1,JLU)*G(ILU+1,JLU)...
                  +(ALPHA)*(1.0-BETA)*SOE(ILU,JLU-1)*G(ILU,JLU-1);
        SREG(M,N)=SREG(M,N)/(ALPHA*BETA*G(ILU+1,JLU-1)...
                  +(1.0-ALPHA)*(1.0-BETA)*G(ILU,JLU)...
                  +(1.0-ALPHA)*(BETA)*G(ILU+1,JLU)...
                  +(ALPHA)*(1.0-BETA)*G(ILU,JLU-1));
    end
  end
%   disp(['BILINEAR INTERPOLATION END']);
%  ************ BILINEAR INTERPOLATION END ************************************  
end

