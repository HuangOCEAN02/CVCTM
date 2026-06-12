PROGRAM FORCING_region_JRA55
  USE chpar
  IMPLICIT NONE
  ! This is a regional version by H.H
  !     SOME CONSTANTS FROM FORCED FIELD
  REAL :: gaulat(IFE+2,JFE+2), gaulon(IFE+2,JFE+2), gaussla(JFE), gausslo(IFE)
  REAL :: land(IFE+2, JFE+2), dummy(IFE, JFE),EQP,ALFA
  REAL :: fiin(IFE+2, JFE+2, 7) ! The 7th scalar
  REAL :: temin(IFE+2, JFE+2), tdewin(IFE+2, JFE+2), SHUMIN(IFE+2,JFE+2), pratein(IFE+2, JFE+2), &
       dwlwin(IFE+2, JFE+2), u10in(IFE+2, JFE+2), uwin(IFE+2, JFE+2), vwin(IFE+2, JFE+2), &
       swradin(IFE+2, JFE+2), pressin(IFE+2, JFE+2)
  !     SOME CONSTANTS FROM MODEL FIELD
  REAL :: GILA(2*IE_G+1,2*JE_G+1),GIPH(2*IE_G+1,2*JE_G+1)
  REAL :: HOPLAT(IE_G,JE_G),HOPLON(IE_G,JE_G)
  REAL :: HOPLAT_U(IE_G+1,JE_G),HOPLON_U(IE_G+1,JE_G)
  REAL :: HOPLAT_V(IE_G,JE_G+1),HOPLON_V(IE_G,JE_G+1)
  REAL :: FIOUT(IE_G,JE_G,7)  ! The 7th scalar 
  ! The East-West Grid and North-South Grid of u&v
  REAL :: FIOUT_U(IE_G+1,JE_G,2),FIOUT_V(IE_G,JE_G+1,2) 
  REAL :: UWOUT_U(IE_G+1,JE_G), VWOUT_U(IE_G+1,JE_G), &
          UWOUT_V(IE_G,JE_G+1), VWOUT_V(IE_G,JE_G+1), &
          UKE_U(IE_G+1,JE_G), VKE_U(IE_G+1,JE_G),&
          UKE_V(IE_G,JE_G+1), VKE_V(IE_G,JE_G+1)
  REAL :: temout(IE_G,JE_G), pressout(IE_G,JE_G), tdewout(IE_G,JE_G), &
       swradout(IE_G,JE_G), dwlwout(IE_G,JE_G), prateout(IE_G,JE_G), u10out(IE_G,JE_G), runoff(IE_G,JE_G)      
  REAL :: UHOPE(IE_G+1,JE_G),VHOPE(IE_G,JE_G+1)
  
  REAL :: deltxx, deltxy, deltyx, deltyy, promeru, promerv, schugeo, schugr
  INTEGER :: i, iday, j, m, n, im, ip
  INTEGER(kind=4) :: ext4_hdr(4)
  INTEGER(kind=8) :: ext8_hdr(4)
  INTEGER, PARAMETER :: io_in_anta=81, io_out_giwix=52, io_out_giwiy=53, &
       io_in_lsm=10, io_out_gitem=54, io_out_gitdew=55, io_out_giprec=56, &
       io_out_gicloud=57, io_out_giu10=58, io_out_swrad=59, io_out_gipress=61

  REAL SVAL
  DATA SVAL / 0./
  !   Grid of JRA-55-TL319 
  !   Latitude
   DATA GAUSSLA/ &
          89.570, 89.013, 88.453, 87.892, 87.331, 86.769, &
          86.208, 85.647, 85.085, 84.523, 83.962, 83.400, &
          82.839, 82.277, 81.716, 81.154, 80.592, 80.031, &
          79.469, 78.908, 78.346, 77.784, 77.223, 76.661, &
          76.100, 75.538, 74.976, 74.415, 73.853, 73.291, &
          72.730, 72.168, 71.607, 71.045, 70.483, 69.922, &
          69.360, 68.799, 68.237, 67.675, 67.114, 66.552, &
          65.990, 65.429, 64.867, 64.306, 63.744, 63.182, &
          62.621, 62.059, 61.498, 60.936, 60.374, 59.813, &
          59.251, 58.689, 58.128, 57.566, 57.005, 56.443, &
          55.881, 55.320, 54.758, 54.196, 53.635, 53.073, &
          52.512, 51.950, 51.388, 50.827, 50.265, 49.704, &
          49.142, 48.580, 48.019, 47.457, 46.895, 46.334, &
          45.772, 45.211, 44.649, 44.087, 43.526, 42.964, &
          42.402, 41.841, 41.279, 40.718, 40.156, 39.594, &
          39.033, 38.471, 37.909, 37.348, 36.786, 36.225, &
          35.663, 35.101, 34.540, 33.978, 33.416, 32.855, &
          32.293, 31.732, 31.170, 30.608, 30.047, 29.485, &
          28.924, 28.362, 27.800, 27.239, 26.677, 26.115, &
          25.554, 24.992, 24.431, 23.869, 23.307, 22.746, &
          22.184, 21.622, 21.061, 20.499, 19.938, 19.376, &
          18.814, 18.253, 17.691, 17.129, 16.568, 16.006, &
          15.445, 14.883, 14.321, 13.760, 13.198, 12.636, &
          12.075, 11.513, 10.952, 10.390,  9.828,  9.267, &
           8.705,  8.144,  7.582,  7.020,  6.459,  5.897, &
           5.335,  4.774,  4.212,  3.651,  3.089,  2.527, &
           1.966,  1.404,  0.842,  0.281, -0.281, -0.842, &
          -1.404, -1.966, -2.527, -3.089, -3.651, -4.212, &
          -4.774, -5.335, -5.897, -6.459, -7.020, -7.582, &
          -8.144, -8.705, -9.267, -9.828,-10.390, -10.952,&
         -11.513,-12.075,-12.636,-13.198,-13.760, -14.321,&
         -14.883,-15.445,-16.006,-16.568,-17.129, -17.691,&
         -18.253,-18.814,-19.376,-19.938,-20.499, -21.061,&
         -21.622,-22.184,-22.746,-23.307,-23.869, -24.431,&
         -24.992,-25.554,-26.115,-26.677,-27.239, -27.800,&
         -28.362,-28.924,-29.485,-30.047,-30.608, -31.170,&
         -31.732,-32.293,-32.855,-33.416,-33.978, -34.540,&
         -35.101,-35.663,-36.225,-36.786,-37.348, -37.909,&
         -38.471,-39.033,-39.594,-40.156,-40.718, -41.279,&
         -41.841,-42.402,-42.964,-43.526,-44.087, -44.649,&
         -45.211,-45.772,-46.334,-46.895,-47.457, -48.019,&
         -48.580,-49.142,-49.704,-50.265,-50.827, -51.388,&
         -51.950,-52.512,-53.073,-53.635,-54.196, -54.758,&
         -55.320,-55.881,-56.443,-57.005,-57.566, -58.128,&
         -58.689,-59.251,-59.813,-60.374,-60.936, -61.498,&
         -62.059,-62.621,-63.182,-63.744,-64.306, -64.867,&
         -65.429,-65.990,-66.552,-67.114,-67.675, -68.237,&
         -68.799,-69.360,-69.922,-70.483,-71.045, -71.607,&
         -72.168,-72.730,-73.291,-73.853,-74.415, -74.976,&
         -75.538,-76.100,-76.661,-77.223,-77.784, -78.346,&
         -78.908,-79.469,-80.031,-80.592,-81.154, -81.716,&
         -82.277,-82.839,-83.400,-83.962,-84.523, -85.085,&
         -85.647,-86.208,-86.769,-87.331,-87.892, -88.453,&
         -89.013,-89.570/  
  !  Longitude
   gausslo(1) = 0.
  DO I=2,IFE
    gausslo(i) = gausslo(i-1) + resol_fe
  ENDDO
  ! Meshgrid
  DO I=1,IFE
  DO J=1,JFE
      GAULAT(I+1, J+1) = GAUSSLA(J)
      GAULON(I+1, J+1) = GAUSSLO(I)
    ENDDO
  ENDDO
     !     ZYKL.RAND OST/WEST
  DO J=1,JFE+2
    GAULAT(1,J)=GAULAT(IFE+1,J)
    GAULAT(IFE+2,J)=GAULAT(2,J) 
    gaulon(1, j) = gaulon(IFE+1, j) - 360.
    gaulon(IFE+2, j) = gaulon(2, j) + 360.
  ENDDO

  !     POLE (SCHUMMELN: OBEN UND UNTEN EINE REIHE HINZU)
  DO I=1, IFE+2
    gaulat(i, 1) = 180. - gaulat(i, 2)
    gaulat(i, JFE+2) = -180. - gaulat(i, JFE+1)
    gaulon(i, 1) = gaulon(i, 2)
    gaulon(i, JFE+2) = gaulon(i, JFE+1)
  ENDDO

  !     NOCHMAL ZYKL.RAND OST/WEST
  DO J=2, JFE+1
    GAULAT(1, J) = GAULAT(IFE+1, J)
    GAULAT(IFE+2, J) = GAULAT(2, J)
    gaulon(1, j) = gaulon(IFE+1, j) - 360.
    gaulon(IFE+2, j) = gaulon(2, j) + 360.
  ENDDO
  
  ! Degree(°) changed to Radian 
  DO I=1, IFE+2
    DO J=1, JFE+2
      gaulat(i, j) = gaulat(i, j) / aradtogra
      gaulon(i, j) = gaulon(i, j) / aradtogra
    ENDDO
  ENDDO
  
   ! Gaulat
   ! the every line [line from 1(N) to JFE+2(S)] is the same
   
   ! (90.43)       (-90.43)
   !   ---------------
   !   |             |
   !   |             |
   !   |             |
   !   |             |
   !   |             |
   !   ---------------
   ! (90.43)       (-90.43)
  
  ! Gaulon
   ! the every row [row from 1(W) to IFE+2(E)] is the same
   ! (-0.5625)    (-0.5625)
   !   ---------------
   !   |             |
   !   |             |
   !   |             |
   !   |             |
   !   |             |
   !   ---------------
   ! (360)          (360)
    
  ! ************ Regional Model Gird **********************
  OPEN(io_in_anta, file='../../anta', access='SEQUENTIAL', &
       form='UNFORMATTED', action='read')
  	READ (io_in_anta) ext8_hdr
  	READ (io_in_anta) GILA
  	READ (io_in_anta) ext8_hdr
  	READ (io_in_anta) GIPH
  ! ************ JRA Gird Mask *******************
  OPEN(io_in_lsm, file='../land_sea_mask.JRA.2011.ext', access='sequential', &
       form='unformatted', action='read')
    ! 陆地点为1，干湿点为0-1 水点为0（原始值）
  	READ(io_in_lsm) ext4_hdr
  	READ(io_in_lsm) ((dummy(i,j), i=1, IFE), j=1, JFE) 
  	FORALL (I = 1:IFE, j=1:JFE)
  	! 水点为0，干湿点和陆地点为1 [smooth]
    	! land(i+1,j+1) = MERGE(1., dummy(i, j), dummy(i, j) .GT. 1.e-4)
    ! JRA no smooth
    	land(i+1,j+1)=0 
  	END FORALL
  		
  	DO i=1, IFE+2
    	land(i, 1) = 0.
    	land(i, JFE+2) = 1.
  	ENDDO
  	
  	DO j=1, JFE+2
    	land(1,j) = land(IFE+1,j)
    	land(IFE+2,j) = land(2,j)
  	ENDDO
  	  	
  	! ************ vector field **********************
  OPEN(io_out_giwix, file='GIWIX', access='SEQUENTIAL', &
       form='UNFORMATTED', action='write')
  OPEN(io_out_giwiy, file='GIWIY', access='SEQUENTIAL', &
       form='unformatted', action='write')
  ! ************ scalar field **********************
  OPEN(io_out_gitem, file='GITEM', access='sequential', &
       form='unformatted', action='write')
  OPEN(io_out_gitdew, file='GITDEW', access='sequential', &
       form='unformatted', action='write')
  OPEN(io_out_giprec, file='GIPREC', access='sequential', &
       form='unformatted', action='write')
! Choose one of GIDWLW and GICOUD, depends on FORCE_DWLW in mpiom.f90
IF (FORCE_DWLW) then
! DWLW : Downward Longwave Radiation
   OPEN(io_out_gicloud,FILE='GIDWLW',ACCESS='SEQUENTIAL',&
        FORM='UNFORMATTED',action='write')
ELSE
! Total Cloud Cover
  OPEN(io_out_gicloud, file='GICLOUD', access='sequential', &
       form='unformatted', action='write')
ENDIF

  OPEN(io_out_giu10, file='GIU10', access='sequential', &
       form='unformatted', action='write')
  OPEN(io_out_swrad, file='GISWRAD', access='sequential', &
       form='unformatted', action='write')
  OPEN(io_out_gipress, file='GIPRESS', access='sequential', &
       form='unformatted', action='write')
  OPEN(999, file='GIRIV', access='sequential', form='unformatted', action='write')
  	DO I=1, IE_G
    	DO J=1, JE_G
      	runoff(i, j) = 0
    	ENDDO
  	ENDDO
  	
DO IDAY=1,LDAY
    PRINT *, 'DATUM ', IDAY
    ! READ INPUT FILES  
    ! 2m air temperature above sea surface
    OPEN(2,FILE='tmp2m_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(2) ext4_hdr
    READ(2) ((DUMMY(I,J),I=1,IFE),J=1,JFE)
    FORALL (I =1:IFE, J = 1:JFE)
      temin(i+1, j+1) = dummy(i,j) - 273.15
    END FORALL
    	
    ! 2m specific humidity above sea surface
    OPEN(11,FILE='spfh_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(11) ext4_hdr
    READ(11)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    DO I=1,IFE
     DO J=1,JFE
      SHUMIN(i+1, j+1)=dummy(i, j)
     enddo
    enddo
    
    ! precipitation[m/s]
    OPEN(12,FILE='tprat_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(12) ext4_hdr
    READ(12)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    DO I=1,IFE
      DO J=1,JFE
       pratein(i+1,j+1) = MAX(0., dummy(i,j))
      enddo
    enddo
   ! Alternative NO.13
IF (FORCE_DWLW) then
	! Downward Longwave Radiation
    OPEN(13,FILE='dlwrf_6hour.ext'&
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
ELSE
	! Total Cloud Cover(0%～100%) of JRA55 that needs to be 0～1
    OPEN(13,FILE='allcloudcover_daily.ext'&
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
ENDIF
    READ(13) ext4_hdr
    READ(13)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    DO I=1,IFE
     DO J=1,JFE
     	IF (FORCE_DWLW) then
      	 dwlwin(i+1, j+1) = dummy(i, j)
        ELSE
      	 dwlwin(i+1, j+1) = dummy(i, j)/100.0
        ENDIF
     ENDDO
    ENDDO
    
    ! 10m velocity speed【scalar wind】 above sea surface [m/s]
    OPEN(14,FILE='u10m_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(14) ext4_hdr
    READ(14)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    FORALL (i = 1:IFE, j = 1:JFE)
      u10in(i+1, j+1) = dummy(i, j)
    END FORALL

    ! short wave radiation [w/m^2]
    OPEN(15,FILE='dswrf_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(15) ext4_hdr
    READ(15)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    DO I=1,IFE
     DO J=1,JFE
      SWRADIN(I+1,J+1)=MAX(0.,DUMMY(I,J))
     ENDDO
    ENDDO
    
    ! u momentum flux at sea surface
    OPEN(3,FILE='uflx_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(3) ext4_hdr
    READ(3)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    FORALL (i = 1:IFE, j = 1:JFE)
      uwin(i+1, j+1) = dummy(i, j)*(-1.0)
    END FORALL
    	
		! v momentum flux at sea surface
    OPEN(4,FILE='vflx_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(4) ext4_hdr
    READ(4)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    FORALL (i = 1:IFE, j = 1:JFE)
      vwin(i+1, j+1) = dummy(i, j)*(-1.0)
    END FORALL
    	
    ! sea surface pressure (unit: Pa, be sure it is not hPa)
    OPEN(16,FILE='pres_6hour.ext' &
         ,ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    READ(16) ext4_hdr
    READ(16)((DUMMY(I,J),I=1,IFE),J=1,JFE)
    DO I=1,IFE
     DO J=1,JFE
      pressin(i+1, j+1) = dummy(i, j)
     ENDDO
    ENDDO
    
    ! calculate dew point temperature, by peterspy
      DO I=1,IFE
        DO J=1,JFE
          EQP=(SHUMIN(I+1,J+1)*PRESSIN(I+1,J+1))/(0.378*SHUMIN(I+1,J+1)+0.6222)
          ALFA=(1./7.5)*LOG10(EQP/611.)
          TDEWIN(I+1,J+1)=(273.16-(35.86*alfa))/(1.-alfa)
        ENDDO
      ENDDO    
    
     DO J=1,JFE+2
      	uwin(1, j) = uwin(IFE+1, j)
      	uwin(IFE+2, j) = uwin(2, j)

      	vwin(1, j) = vwin(IFE+1, j)
      	vwin(IFE+2, j) = vwin(2, j)

      	temin(1, j) = temin(IFE+1, j)
      	temin(IFE+2, J) = temin(2, j)

      	pressin(1, j) = pressin(IFE+1, j)
      	pressin(IFE+2, j) = pressin(2, j)

      	tdewin(1, j) = tdewin(IFE+1, j)
      	tdewin(IFE+2, j) = tdewin(2, j)

      	pratein(1, j) = pratein(IFE+1, j)
      	pratein(IFE+2, j) = pratein(2, j)

      	dwlwin(1, j) = dwlwin(IFE+1, j)
      	dwlwin(IFE+2, j) = dwlwin(2, j)

      	u10in(1, j) = u10in(IFE+1, j)
      	u10in(IFE+2, j) = u10in(2, j)

      	swradin(1, j) = swradin(IFE+1, j)
      	swradin(IFE+2, j) = swradin(2, j)
    ENDDO

    !     POLE (EINE REIHE HINZU)
    DO I=1,IFE+2
       uwin(i, 1) = uwin(i, 2)
       uwin(i, JFE+2) = uwin(i, JFE+1)

       vwin(i, 1) = vwin(i, 2)
       vwin(i, JFE+2) = vwin(i, JFE+1)

       temin(i, 1) = temin(i, 2)
       temin(i, JFE+2) = temin(i, JFE+1)

       pressin(i, 1) = pressin(i, 2)
       pressin(i, JFE+2) = pressin(i, JFE+1)

       tdewin(i, 1) = tdewin(i, 2)
       tdewin(i, JFE+2) = tdewin(i, JFE+1)

       pratein(i, 1) = pratein(i, 2)
       pratein(i, JFE+2) = pratein(i, JFE+1)

       dwlwin(i, 1) = dwlwin(i,2)
       dwlwin(i, JFE+2) = dwlwin(i, JFE+1)

       u10in(i, 1) = u10in(i, 2)
       u10in(i, JFE+2) = u10in(i, JFE+1)

       swradin(i, 1) = swradin(i, 2)
       swradin(i, JFE+2) = swradin(i, JFE+1)
    ENDDO
! ************ SCALAR VARIABLE BILINEAR INTERPOLATION START **********************     
    ! input the points of scalar: HOPLON HOPLAT
    DO M=1,IE_G
     DO N=1,JE_G
       HOPLON(M,N)=GILA(2*M,2*N)
       HOPLAT(M,N)=GIPH(2*M,2*N)
       IF (HOPLON(M,N).GT.(2.*API))  HOPLON(M,N)=HOPLON(M,N)-(2.*API)
       IF (HOPLON(M,N).LT.0.)        HOPLON(M,N)=HOPLON(M,N)+(2.*API)
     ENDDO
   ENDDO

   DO I=1,IFE+2
    DO J=1,JFE+2
        FIIN(I, J, 1) = temin(i, j)
        FIIN(I, J, 2) = tdewin(i, j)
        FIIN(I, J, 3) = pratein(i, j)
        FIIN(I, J, 4) = dwlwin(i, j)
        FIIN(I, J, 5) = u10in(i, j)
        FIIN(I, J, 6) = swradin(i, j)
        FIIN(I, J, 7) = pressin(i, j)
    ENDDO
   ENDDO

   CALL BLN2HOP(7,IFE,JFE,IE_G,JE_G,GAULAT,GAULON,HOPLAT,HOPLON,FIIN,FIOUT,LAND)
   
   DO M=1,IE_G
    DO N=1,JE_G
        temout(m, n) = fiout(m, n, 1)
        tdewout(m, n) = fiout(m, n, 2)
        prateout(m, n) = fiout(m, n, 3)
        dwlwout(m, n) = fiout(m, n, 4)
        u10out(m, n) = fiout(m, n, 5)
        swradout(m, n) = fiout(m, n, 6)
        pressout(m, n) = fiout(m, n, 7)
    ENDDO
   ENDDO   
! ************ SCALAR VARIABLE BILINEAR INTERPOLATION END **********************   
  
    ext8_hdr(1) = INT(iday)
    ext8_hdr(3) = INT(ext4_hdr(3))
    ext8_hdr(4) = INT(IE_G * JE_G)

    ext8_hdr(2) = 167
    WRITE(io_out_gitem) ext8_hdr
    WRITE(io_out_gitem) temout

    ext8_hdr(2) = 168
    WRITE(io_out_gitdew) ext8_hdr
    WRITE(io_out_gitdew) tdewout

    ext8_hdr(2) = 423
    WRITE(io_out_giprec) ext8_hdr
    WRITE(io_out_giprec) prateout

    ext8_hdr(2) = 177
    WRITE(io_out_gicloud) ext8_hdr
    WRITE(io_out_gicloud) dwlwout

    ext8_hdr(2) = 665
    WRITE(io_out_giu10) ext8_hdr
    WRITE(io_out_giu10) u10out

    ext8_hdr(2) = 276
    WRITE(io_out_swrad) ext8_hdr
    WRITE(io_out_swrad) swradout

    ext8_hdr(2) = 151
    WRITE(io_out_gipress) ext8_hdr
    WRITE(io_out_gipress) pressout

    ext8_hdr(2) = 999
    WRITE(999) ext8_hdr
    WRITE(999) runoff   
 
! ************ VECTOR[U] VARIABLE BILINEAR INTERPOLATION START **********************
   ! input the points of vector(u): HOPLON HOPLAT
   ! bilinear interpolation of U momentum flux at sea surface      
   DO M=1,IE_G+1
      DO N=1,JE_G
        HOPLON_U(M,N)=GILA((2*M)-1,2*N)
        HOPLAT_U(M,N)=GIPH((2*M)-1,2*N)
        IF (HOPLON_U(M,N).GT.(2.*API)) HOPLON_U(M,N)=HOPLON_U(M,N)-(2.*API)
        IF (HOPLON_U(M,N).LT.0.) HOPLON_U(M,N)=HOPLON_U(M,N)+(2.*API)
      ENDDO
    ENDDO

    DO I=1,IFE+2
      DO J=1,JFE+2
        fiin(i, j, 1) = uwin(i, j)
        fiin(i, j, 2) = vwin(i, j)
      ENDDO
    ENDDO

    CALL BLN2HOP(2,IFE,JFE,IE_G+1,JE_G,GAULAT,GAULON,HOPLAT_U,HOPLON_U,FIIN,FIOUT_U,LAND)
    
    DO M=1,IE_G+1
      DO N=1,JE_G
        UWOUT_U(M,N)=FIOUT_U(M,N,1)
        VWOUT_U(M,N)=FIOUT_U(M,N,2)
      ENDDO
    ENDDO
! ************ VECTOR[U] VARIABLE BILINEAR INTERPOLATION END **********************      
    ! the X and Y direction of wind stress of Cartesian grid exchanged into U-direction of the Orthogonal grid
    ! Vector (DELTAXX,DELTAXY) and (DELTAYY,DELTAYX)
    ! Construct the N/S,O/W system
    ! Windstress unit: (N/kg)/rho

    DO M=1,IE_G+1
       im=2*M-1
      DO N=1,JE_G
         ip=2*N
        IF ((UWOUT_U(M,N).NE.SVAL).AND.(VWOUT_U(M,N).NE.SVAL)) THEN
          UWOUT_U(M,N)=UWOUT_U(M,N)/1025.
          VWOUT_U(M,N)=VWOUT_U(M,N)/1025.
          if (M==1) then  
            DELTXX = -GILA(im,ip)+GILA(im+1,ip)          
            DELTXY = -GIPH(im,ip)+GIPH(im+1,ip)
          else         
            DELTXX = GILA(im,ip)-GILA(im-1,ip)
            DELTXY = GIPH(im,ip)-GIPH(im-1,ip)
          endif
          DELTYY = GIPH(im,ip-1)-GIPH(im,ip)
          DELTYX = GILA(im,ip-1)-GILA(im,ip)
          IF(DELTXX.GT. API) DELTXX = DELTXX - 2.*API
          IF(DELTXX.LT.-API) DELTXX = DELTXX + 2.*API
          IF(DELTYX.LT.-API) DELTYX = DELTYX + 2.*API
          IF(DELTYX.GT. API) DELTYX = DELTYX - 2.*API


          ! Test Mercator Projection

          PROMERU = COS(GIPH(im,ip))
          DELTXX=DELTXX*PROMERU
          DELTYX=DELTYX*PROMERU

          ! H       PROJEKTION VON UKE AUS RICHTUNG I,J IN RICHTUNG N/S, O/W
          ! H       MITTELS SKALARPRODUKT = A1*B1+A2*B2+...

          UKE_U(M,N) = (UWOUT_U(M,N)*DELTXX) + (VWOUT_U(M,N)*DELTXY)
          VKE_U(M,N) = (UWOUT_U(M,N)*DELTYX) + (VWOUT_U(M,N)*DELTYY)

          ! H       ES MUESSTE EIGENTLICH NOCH DURCH DEN BETRAG
          ! H       VON DELTA GETEILT WERDEN DA DELTA KEIN EINHEITSVEKTOR IST

          ! H       TEST
          IF ((DELTXX*DELTYX+DELTYY*DELTXY).GT.0.1) THEN
            PRINT*,'ORTHOGONAL?',M,N,(DELTXX*DELTYX+DELTYY*DELTXY)
          ENDIF

          UKE_U(M,N) = UKE_U(M,N) / SQRT(DELTXX**2+DELTXY**2)
          VKE_U(M,N) = VKE_U(M,N) / SQRT(DELTYY**2+DELTYX**2)

          ! H       ES WIRD PASSEND SKALIERT

          ! H       BETRAG VOR DER DREHUNG
          SCHUGEO = SQRT(UWOUT_U(M,N)**2 + VWOUT_U(M,N)**2)

          ! H       BETRAG NACH DER DREHUNG
          SCHUGR = SQRT(UKE_U(M,N)**2+VKE_U(M,N)**2)

          ! H       QUOTIENT ALS KORREKTURFAKTOR

          UHOPE(M,N) = UKE_U(M,N)*SCHUGEO / SCHUGR

        ELSE

          UHOPE(M,N)=0.

        ENDIF

      ENDDO
    ENDDO
    
    ext8_hdr(1) = INT(iday)
    ext8_hdr(2) = 180
    ext8_hdr(3) = INT(ext4_hdr(3))
    ext8_hdr(4) = INT((IE_G+1) * JE_G)
    WRITE(io_out_giwix) ext8_hdr
    WRITE(io_out_giwix) uhope
    
! ************ VECTOR[V] VARIABLE BILINEAR INTERPOLATION START **********************      
    DO M=1,IE_G
      DO N=1,JE_G+1
        HOPLON_V(M,N)=GILA(2*M,(2*N)-1)
        HOPLAT_V(M,N)=GIPH(2*M,(2*N)-1)
        
        IF (HOPLON_V(M,N).GT.(2.*API)) HOPLON_V(M,N)=HOPLON_V(M,N)-(2.*API)
        IF (HOPLON_V(M,N).LT.0.) HOPLON_V(M,N)=HOPLON_V(M,N)+(2.*API)
      ENDDO
    ENDDO
    
    FORALL (i = 1:IFE+2, j = 1:JFE+2)
      fiin(i, j, 1) = uwin(i, j)
      fiin(i, j, 2) = vwin(i, j)
    END FORALL
    
    CALL BLN2HOP(2,IFE,JFE,IE_G,JE_G+1,GAULAT,GAULON,HOPLAT_V,HOPLON_V,FIIN,FIOUT_V,LAND)
    
    ! the X and Y direction of wind stress of Cartesian grid exchanged into V-direction of the Orthogonal grid
    ! Vector (DELTAXX,DELTAXY) and (DELTAYY,DELTAYX)
    ! Construct the N/S,O/W system
    ! Windstress unit: (N/kg)/rho
    
    DO M=1,IE_G
      DO N=1,IE_G+1
        UWOUT_V(M,N) = FIOUT_V(M,N,1)
        VWOUT_V(M,N) = FIOUT_V(M,N,2)
      ENDDO
    ENDDO 
    
    DO M=1,IE_G
       im=2*M
      DO N=1,JE_G+1
         ip=2*N-1
        IF ((UWOUT_V(M,N).NE.SVAL).AND.(VWOUT_V(M,N).NE.SVAL)) THEN

          UWOUT_V(M,N)= UWOUT_V(M,N)/1025.
          VWOUT_V(M,N)= VWOUT_V(M,N)/1025.
          IF (N==1) THEN
           DELTYY = -GIPH(im,ip+1)+GIPH(im,ip)
           DELTYX = -GILA(im,ip+1)+GILA(im,ip)
          ELSE
           DELTYY =  GIPH(im,ip-1)-GIPH(im,ip)
           DELTYX =  GILA(im,ip-1)-GILA(im,ip)
          ENDIF
          DELTXX =  GILA(im,ip)  -GILA(im-1,ip)
          DELTXY =  GIPH(im,ip)  -GIPH(im-1,ip)

          IF(DELTXX.GT. API) DELTXX = DELTXX - 2.*API
          IF(DELTXX.LT.-API) DELTXX = DELTXX + 2.*API
          IF(DELTYX.LT.-API) DELTYX = DELTYX + 2.*API
          IF(DELTYX.GT. API) DELTYX = DELTYX - 2.*API

          ! H       TEST WINKELTREUE MERKATORPROJECTION

          PROMERV = COS(GIPH(im,ip))
          DELTXX=DELTXX*PROMERV
          DELTYX=DELTYX*PROMERV


          ! H       PROJEKTION VON VKE AUS RICHTUNG I,J IN RICHTUNG N/S, O/W
          ! H       MITTELS SKALARPRODUKT = A1*B1+A2*B2+...

          UKE_V(M,N) = (UWOUT_V(M,N)*DELTXX) + (VWOUT_V(M,N)*DELTXY)
          VKE_V(M,N) = (UWOUT_V(M,N)*DELTYX) + (VWOUT_V(M,N)*DELTYY)

          ! H       ES MUESSTE EIGENTLICH NOCH DURCH DEN BETRAG
          ! H       VON DELTA GETEILT WERDEN DA DELTA KEIN EINHEITSVEKTOR IST

          ! H       TEST
          IF ((DELTXX*DELTYX+DELTYY*DELTXY).GT.0.1) THEN
            PRINT*,'ORTHOGONAL?',M,N,(DELTXX*DELTYX+DELTYY*DELTXY)
          ENDIF

          UKE_V(M,N) = UKE_V(M,N) / SQRT(DELTXX**2+DELTXY**2)
          VKE_V(M,N) = VKE_V(M,N) / SQRT(DELTYY**2+DELTYX**2)

          ! H       ES WIRD PASSEND SKALIERT

          ! H       BETRAG VOR DER DREHUNG
          SCHUGEO = SQRT(UWOUT_V(M,N)**2 + VWOUT_V(M,N)**2)

          ! H       BETRAG NACH DER DREHUNG
          SCHUGR = SQRT(UKE_V(M,N)**2+VKE_V(M,N)**2)

          ! H       QUOTIENT ALS KORREKTURFAKTOR

          VHOPE(M,N) = VKE_V(M,N)*SCHUGEO / SCHUGR

        ELSE

          VHOPE(M,N)=0.

        ENDIF

      ENDDO
    ENDDO
    
    ext8_hdr(1) = INT(iday)
    ext8_hdr(2) = 181
    ext8_hdr(3) = INT(ext4_hdr(3))
    ext8_hdr(4) = INT(IE_G * (JE_G+1))
    WRITE(io_out_giwiy) ext8_hdr
    WRITE(io_out_giwiy) vhope
! ************ VECTOR[V] VARIABLE BILINEAR INTERPOLATION END **********************     

ENDDO 
  stop
END PROGRAM FORCING_region_JRA55  

  
!     CALL BLN2HOP(7,    IFE,  JFE,    IE_G,JE_G,  GAULAT,GAULON,HOPLAT,HOPLON,FIIN,FIOUT,LAND)
!     CALL BLN2HOP(2,    IFE,  JFE,  IE_G+1,JE_G,  GAULAT,GAULON,HOPLAT_U,HOPLON_U,FIIN,FIOUT_U,LAND)
!     CALL BLN2HOP(2,    IFE,  JFE,    IE_G,JE_G+1,GAULAT,GAULON,HOPLAT_V,HOPLON_V,FIIN,FIOUT_V,LAND)   
SUBROUTINE BLN2HOP(NUMFI,IFE_1,JFE_1,IE_1,JE_1,ALAT2,ALON2,ALAT1,ALON1,SOE,SREG,LAND)
! 		BILINEAR INTERPOLATION 
! 		FROM ONE     GLOBAL GRID[(IFE_1,JFE_1),ALAT2,ALON2] 
! 		TO ANOTHER REGIONAL GRID[(IE_1,JE_1),ALAT1,ALON1]
	IMPLICIT NONE
  INTEGER,INTENT(in) :: numfi, IFE_1, JFE_1, IE_1, JE_1  ! in表示参数只能读，不能改
  REAL,INTENT(inout) :: SOE(IFE_1+2, JFE_1+2, numfi)     ! soe即强迫场数据，inout表示没啥用
  REAL,INTENT(out) :: SREG(IE_1, JE_1, numfi)            ! sreg即插值后的强迫场，out表示参数必须修改，否则编译出现警告
  REAL,INTENT(in) :: alat2(IFE_1+2, JFE_1+2), alon2(IFE_1+2, JFE_1+2)  ! forcing field gird
  REAL,INTENT(in) :: alat1(IE_1, JE_1), alon1(IE_1, JE_1)      ! regional model gird
  REAL,INTENT(in) :: land(IFE_1+2, JFE_1+2)
  REAL,PARAMETER :: eps=1.e-12
  REAL,PARAMETER :: api=3.1415926
  REAL :: G(IFE_1+2,JFE_1+2),HG(IFE_1+2,JFE_1+2),rsumg
  REAL :: alpha, beta, wwwalpha, wwwbeta
  REAL :: HX(IFE_1+2,JFE_1+2,NUMFI),HHX(IFE_1+2,JFE_1+2,NUMFI)
  INTEGER :: i, il, ilu, ir, iter, j, jlu, jo, ju, l, m, n, nland
  
!  ************ 100th soomth  ************************************
  !     DIFFUSION INTO LAND (NEW 12/99)
  !     SOE => HHX
  DO L=1,NUMFI
    DO J=1,JFE_1+2
      DO I=1,IFE_1+2
        HHX(I,J,L)=SOE(I,J,L)
        ! HHX*((LAND(I,J)-1.))*(-1.)
      ENDDO
    ENDDO
  ENDDO
  
  ! Choose sea point，before this, land and w-d(wet-dry) points equal 1 
  ! And land => HG
  DO J=1,JFE_1+2
    DO I=1,IFE_1+2
          HG(I,J)=1.
          IF (LAND(I,J).ge.0.5) HG(I,J)=1.E-12
  ! land >= 0.5（w-d&land point）	       land  : 1.e-12
  ! 															  hg   w-d  : 1.e-12
  ! 															       sea  :  1.   
    ENDDO
  ENDDO
  
  ! smooth 100th start
  DO ITER=1,100
  ! HG => G
  ! HHX => HX
    DO J=1,JFE_1+2
      DO I=1,IFE_1+2
        G(I,J)=HG(I,J)
        DO L=1,NUMFI
          HX(I,J,l)=HHX(I,J,l)
        ENDDO
      ENDDO
    ENDDO
    
    
    
    DO J=1,JFE_1+2
       JO=MAX(J-1,1)
       JU=MIN(J+1,JFE_1+2)
        DO I=1,IFE_1+2
           IL=I-1
           IF(IL.LT.1) IL=IFE_1-2
        	 IR=I+1
           IF(IR.GT.IFE_1+2) IR=3
        	 RSUMG=0.
        ! （wet-dry point）
           IF (LAND(I,J) .GE. 0.5)THEN 
          	RSUMG=(4.*G(I,J)+G(IL,J)+G(IR,J)+G(I,JO)+G(I,JU))/8.
						! 8 points smooth
          	HG(I,J)=MIN(RSUMG,0.125)
          		DO L=1,NUMFI
            		 HHX(I,J,L)=(4.*HX(I,J,L)*G(I,J) &
                 							+HX(IL,J,L)*G(IL,J) &
                 							+HX(IR,J,L)*G(IR,J) &
                 							+HX(I,JO,L)*G(I,JO) &
                 							+HX(I,JU,L)*G(I,JU))/8.
            		 HHX(I,J,L)=HHX(I,J,L)/RSUMG
          		ENDDO
          ENDIF
      	ENDDO
    ENDDO

   nland=0
    Do I=1,IFE_1
      DO j=1,JFE_1
        IF (HG(i,j) .LE. 2.*eps) nland=nland+1
      ENDDO
    ENDDO
    ! PRINT*,iter,' Nland: ', nland
  ENDDO

!  HG(or smoothed) => G
! HHX(or smoothed) => SOE
  DO J=1,JFE_1+2
    DO I=1,IFE_1+2
      G(i,j)=HG(i,j)
      DO L=1,NUMFI
        SOE(I,J,L)=HHX(I,J,L)
        IF (ABS(SOE(I,J,L)).LT. eps) SOE(I,J,L)=0.
      ENDDO
    ENDDO
  ENDDO
!  ************ 100 soomth end  ******************************************** 
!  ************ BILINEAR INTERPOLATION  ************************************

  DO M=1,IE_1
    DO N=1,JE_1

      ! alat2 alon2 :   Global Grid
      			! alat2: the line [line from 1(N) to JFE+2(S)] is same number
      			! alon2: the row   [row from 1(W) to IFE+2(E)] is same number
      ! alat1 alon1 : Regional Gird
      
      ! find the line
      DO J=1,JFE_1+2
        IF (alat2(2, j) .GE. alat1(m, n)) JO=J
      ENDDO
      
      ! find the row
      DO I=1,IFE_1+2
        IF (alon2(i,2) .LE. alon1(m,n)) IL=I
      ENDDO
      
      JLU=JO+1
      ILU=IL
   ! JO=J at this point (line:JLU-1) alon2 >= alat1(m,n)
   ! IL=I at this point (row:ILU)    alon2 <= alon1(m,n)
   
   !                N------------------------------S 
   !      W             (ILU,JLU-1)      (ILU,JLU)
   !      |         -        ---------------
   !      |    BETA |        |             |
   !      |         |        |             |
   !      |         -        |      *      |
   !      |  1-BETA |        |    (m,n)    |
   !      |         |        |             |
   !      |         -        ---------------
   !      |            (ILU+1,JLU-1)    (ILU+1,JLU)
   !      |
   !      E                  |------|------|
   !                          1-ALPHA ALPHA   


      WWWALPHA =ALAT2(ILU,JLU)-ALAT1(M,N)
      WWWBETA  =ALON2(ILU,JLU)-ALON1(M,N)
      
      IF(WWWBETA.GE.API) 	WWWBETA=WWWBETA-2.*API
      IF(WWWBETA.LE.-API) WWWBETA=WWWBETA+2.*API
      
   ! --- normalizing
      ALPHA = (WWWALPHA)/(ALAT2(ILU,JLU)-ALAT2(ILU,JLU-1))
      BETA  = (WWWBETA)/(ALON2(ILU,JLU)-ALON2(ILU+1,JLU))
   ! --- interpolating
      DO I=1,NUMFI
        SREG(M,N,I)=ALPHA*BETA*SOE(ILU+1,JLU-1,I)*G(ILU+1,JLU-1) &
             					+(1.-ALPHA)*(1.-BETA)*SOE(ILU,JLU,I)*G(ILU,JLU) &
             					+(1.-ALPHA)*(BETA)*SOE(ILU+1,JLU,I)*G(ILU+1,JLU) &
             					+(ALPHA)*(1.-BETA)*SOE(ILU,JLU-1,I)*G(ILU,JLU-1)
        SREG(M,N,I)=SREG(M,N,I)/ &
             					(ALPHA*BETA*G(ILU+1,JLU-1) &
             					+(1.-ALPHA)*(1.-BETA)*G(ILU,JLU) &
             					+(1.-ALPHA)*(BETA)*G(ILU+1,JLU) &
             					+(ALPHA)*(1.-BETA)*G(ILU,JLU-1))
      
      ENDDO
      
    ENDDO
  ENDDO
!  ************ BILINEAR INTERPOLATION END ************************************
  RETURN
END SUBROUTINE BLN2HOP
    
    
  
  
  
  
  
  



   
  	
  	
  	
  	
  	
  	
  	
  	
  	
  
  
  
