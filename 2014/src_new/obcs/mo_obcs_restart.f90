      MODULE MO_OBCS_RESTART
!
#if defined ORLANSKI || defined OBCS_TST_NEST
!  Trunning on OBCS_TST_NEST with FLATHER is default on
      USE MO_PARAM1
      USE MO_MPI
      USE MO_PARALLEL
      USE MO_COMMO1
      USE MO_COMMO2
      
      USE MO_OBCS
      USE MO_OBCS_NEST
      USE MO_UNITS
!
      INTEGER :: OUNIT,OFLAG
#ifdef OBCS_TST_NEST
      REAL, POINTER :: UOBC_WB(:,:),VOBC_WB(:,:),      &
     &                 UOBC_EB(:,:),VOBC_EB(:,:),                     &
     &                 UOBC_NB(:,:),VOBC_NB(:,:),                     &
     &                 UOBC_SB(:,:),VOBC_SB(:,:)
#endif
     CONTAINS

      SUBROUTINE alloc_obcs_restart
#ifdef OBCS_TST_NEST
     ALLOCATE(UOBC_WB(1:3,JE_G), VOBC_WB(1:3,0:JE_G),     &
     &                   UOBC_EB(1:3,JE_G),VOBC_EB(1:3,0:JE_G),      &
     &                  UOBC_NB(0:IE_G,1:3),VOBC_NB(IE_G,1:3),        &
     &                  UOBC_SB(0:IE_G,1:3),VOBC_SB(IE_G,1:3))

     UOBC_WB=0.0;VOBC_WB=0.0;UOBC_EB=0.0;VOBC_EB=0.0
     UOBC_NB=0.0;VOBC_NB=0.0;UOBC_SB=0.0;VOBC_SB=0.0
#endif
        END SUBROUTINE alloc_obcs_restart
!****************************************************************
!
!     AAAAAA  U    U  FFFFFF  W    W
!     A    A  U    U  F       W    W
!     AAAAAA  U    U  FFFFF   W WW W
!     A    A  U    U  F       WWWWWW
!     A    A  UUUUUU  F       WW  WW
!
!
!*****************************************************************
! SUBROUTINE AUFW_OBCS
!
!     THIS SBR WRITES ROUTINELY AT CERTAIN TIME INTERVALS
!     A RESTART FILE ON OBC37 OR OBC38 FOR OPEN BOUNDARY CONDITIONS
!
!-----------------------------------------------------------------
     SUBROUTINE AUFW_OBCS
      INTEGER(KIND=i4) IDATE,ICODE,KCODE,IEDIM00,IEDIM,IEDIMU,IEDIMV
      INTEGER k, J, l, IND
      REAL(KIND=sp) rldt, rldays
      IND = 3  ! tst 
      
      IF(p_pe==p_io) THEN
            OPEN(IO_IN_O370,FILE='OBC37',    &
         &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    
            OPEN(IO_IN_O380,FILE='OBC38',    &
         &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    
            REWIND(IO_IN_O370)
            REWIND(IO_IN_O370)
      ENDIF
      
      OUNIT=OUNIT+OFLAG
      WRITE(IO_STDOUT,*) ' RESTRAT OBCS: AUFW OUNIT OFLAG',OUNIT,OFLAG
      REWIND(OUNIT)
      WRITE(IO_STDOUT,*)' ++++++ WRITING  OBCS RESTART FILE ON ',OUNIT        &
         &,' AFTER ',LDT                                                    &
         &,' TIME STEPS . CALCULATED YEAR : ',LYEARS,' MONTH : ',LMONTS
         
       IDATE= (LYEARS*10000)+(LMONTS*100)+LDAYS
       RLDT=REAL(LDT)
       RLDAYS=REAL(LDAYS)
       IEDIM00=2
       IEDIM=IE_G*JE_G
       IEDIMU=(IE_G+1)*JE_G
       IEDIMV=IE_G*(JE_G+1)

!    ICODE Rules
!    1(Boundary)   2(Dimension)   3(Varaibles)
!        W:1                 1D:  0              T:  0
!        E: 2       1D+Level: 1              S: 1
!        N: 3                 2D: 2               U: 2
!        S: 4                 3D: 3               V: 3
!       USOT(I_start:IE,JE) : 63
!       VSET(IE,J_start:JE):  64
!                   ZetaT(IE,JE): 82
!            zeta_subT(IE,JE): 83

! Attention: ZOOOLD & USOOLD VSEOLD
! W :USOR_wb1(1:3,je) uko_wb1(1:3,1:je,ke) vke_wb1(1:3,J_start:je,ke) tho_wb1(1:3,je,ke)  sao_wb1(1:3,je,ke)
! E: USOR_eb1(ie-3:ie1,je) uko_eb1(ie-3:ie1,je,ke) vke_eb1(ie2:ie,J_start:je,ke) tho_eb1(ie2:ie,je,ke) sao_eb1(ie2:ie,je,ke)
! N: VSER_nb1(ie,1:3) uko_nb1(i_start:ie,1:3,ke) vke_nb1(ie,1:3,ke) tho_nb1(ie,1:3,ke) sao_nb1(ie,1:3,ke)
! S: VSER_sb1(ie,je-3:je1) uko_sb1(i_start:ie,je2:je,ke) vke_sb1(ie,je-3:je1,ke)  tho_sb1(ie,je2:je,ke) sao_sb1(ie,je2:je,ke)

! Orlanski radiation 
! U:  uoo_wb1(0:2,je,ke) uoo_eb1(ie2:ie,je,ke) uoo_nb1(I_start:ie,1:3,ke) uoo_sb1(I_start:ie,je2:je,ke)
! V: voe_wb1(1:3,J_start:je,ke) voe_eb1(ie2:ie,J_start:je,ke) voe_nb1(ie,0:2,ke)  voe_sb1(ie,je2:je,ke)

! OBCS boundary array size :  
!                     FLA    FLA    SUBTIDE  SUBTIDE orlanski  orlanski
!  W :  obc_ubarw(je)  obc_vbarw(J_start:je) obcf_uw(je,ke)  obcf_vw(J_start:je,ke) cli_tw(je,ke)  cli_sw(je,ke) 
!  E  :  obc_ubare(je)  obc_vbare(J_start:je) obcf_ue(je,ke)  obcf_ve(J_start:je,ke)  cli_te(je,ke)  cli_se(je,ke) 
!  N :   obc_ubarn(I_start:ie) obc_vbarn(ie)  obcf_un(I_start:ie,ke) obcf_vn(ie,ke) cli_tn(ie, ke) cli_sn(ie,ke)
!  S :  obc_ubars(I_start:ie) obc_vbars(ie) obcf_us(I_start:ie,ke) obcf_vs(ie,ke) cli_ts(ie,ke) cli_ss(ie, ke)

!:: WRITE TIME STEP INFORMATION
       KCODE=-100
       ICODE=999
       IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM00
       IF(p_pe==p_io) WRITE(OUNIT) RLDT,RLDAYS
#ifdef OBC_TIDE
!:: WRITE USOT(I_start:IE,JE) obc_uTNw obc_uTNe  obc_uTNs obc_uTNn
       ICODE=63
       KCODE=-100
       IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
       CALL write_slice(OUNIT,USOT,1)
       
!:: WRITE VSET(IE,J_start:JE)
       ICODE=64
       KCODE=-100
       IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
       CALL write_slice(OUNIT,VSET,2)


!:: WRITE ZetaT(IE,JE)
       ICODE=82
       KCODE=-100
       IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
       CALL write_slice(OUNIT,ZetaT)
#endif

#ifdef OBC_SUBTIDE
!:: WRITE zeta_subT(IE,JE)
       ICODE=83
       KCODE=-100
       IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
       CALL write_slice(OUNIT,zeta_subT)
#endif

!:: WRITE WEST BOUNDARY
      if (WEST) THEN
             IEDIM = JE_G
             IEDIMU = IND * JE_G
             IEDIMV= IND * (JE_G+1)
!:: WRITE 1-D LEVEL FIELDS
             KCODE=-100
!   obc_ubarw(je) (102)
             IEDIM = JE_G
             ICODE = 102
             ! obc processor
             if (have_g_is) then
                UOBC_WB(1,p_joff+1:p_joff+je) = obc_ubarw(1:je)
             endif

             CALL p_bcast(UOBC_WB,p_io)

             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                 WRITE(OUNIT) REAL(UOBC_WB(1,1:JE_G),sp)
             ENDIF
!   obc_vbarw(0:je) (103)
          !   IEDIM = JE_G+1
          !   ICODE = 103
          !   VOBC_WB(1,p_joff+j_start:p_joff+je) = obc_vbarw(j_start:je)
          !   IF(p_pe==p_io) THEN
          !       WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
          !       WRITE(OUNIT) REAL(VOBC_WB(1,0:JE_G),sp)
          !   ENDIF
! obcf_uw(je,ke) (112)
             IEDIM = JE_G
             ICODE = 112
             DO k=1,KE
                if (have_g_is) then
                 UOBC_WB(1,p_joff+1:p_joff+je) = obcf_uw(1:je,k)
                ENDIF
                CALL p_bcast(UOBC_WB,p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_WB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
! obcf_vw(J_start:je,ke) (113)
             IEDIM = JE_G+1
             ICODE = 113
             DO k=1,KE
                if (have_g_is) then
                    VOBC_WB(1,p_joff+J_start:p_joff+je) = obcf_vw(J_start:je,k)
                endif
                CALL p_bcast(VOBC_WB,p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_WB(1,0:JE_G),sp)
                 ENDIF
             ENDDO
! cli_tw(je,ke)  (110)
             IEDIM = JE_G
             ICODE = 110
             DO k=1,KE
                if (have_g_is) then
                    UOBC_WB(1,p_joff+1:p_joff+je) = cli_tw(1:je,k)
                endif
                CALL p_bcast(UOBC_WB,p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_WB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
!  cli_sw(je,ke)  (111)
             IEDIM = JE_G
             ICODE = 111
             DO k=1,KE
                if (have_g_is) then
                    UOBC_WB(1,p_joff+1:p_joff+je) = cli_sw(1:je,k)
                endif
                CALL p_bcast(UOBC_WB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_WB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
#ifdef OBCS_TST_NEST
!:: WRITE 2-D FIELDS
!   USOR_wb1(1:3,1:je) (122)
             ICODE = 122
      	     KCODE = -100
            if (have_g_is) then
             DO i = 1,3
                 UOBC_WB(i,p_joff+1:p_joff+je) = USOR_wb1(i,1:je)
             ENDDO
            endif
            CALL p_bcast(UOBC_WB, p_io)
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                 WRITE(OUNIT) REAL(UOBC_WB, sp)
             ENDIF
!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
!  uko_wb1(1:3,1:je,ke) (132)
             ICODE = 132
      	     DO k = 1, ke
                if (have_g_is) then
      	         UOBC_WB(1:3,p_joff+1:p_joff+je) = uko_wb1(1:3,1:je,k)
                endif
                CALL p_bcast(UOBC_WB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_WB, sp)
                ENDIF
             ENDDO
!  vke_wb1(1:3,J_start:je,ke) (133)
             ICODE = 133
      	     DO k = 1,ke
                if (have_g_is) then
                 VOBC_WB(1:3,p_joff+J_start:p_joff+je) = vke_wb1(1:3,J_start:je,k)
                endif
      	         KCODE=TIESTU(K)
                CALL p_bcast(VOBC_WB, p_io)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_WB, sp)
                ENDIF
             ENDDO
#endif
#else
!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
!  uoo_wb1(0:2,je,ke) (132)
             ICODE = 132
      	     DO k = 1, ke
                if (have_g_is) then
      	         UOBC_WB(1:3,p_joff+1:p_joff+je) = uoo_wb1(0:2,1:je,k)
                endif
                CALL p_bcast(UOBC_WB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_WB, sp)
                ENDIF
             ENDDO
!  voe_wb1(1:3,J_start:je,ke) (133)
             ICODE = 133
      	     DO k = 1,ke
                if (have_g_is) then
                 VOBC_WB(1:3,p_joff+J_start:p_joff+je) = voe_wb1(1:3,J_start:je,k)
                endif
                CALL p_bcast(VOBC_WB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_WB, sp)
                ENDIF
             ENDDO
#endif
#endif
!
#ifdef ORLANSKI
! tho_wb1(1:3,je,ke) (130)
            ICODE = 130
      	     DO k = 1,ke
                if (have_g_is) then
                 UOBC_WB(1:3,p_joff+1:p_joff+je) = tho_wb1(1:3,1:je,k)
                endif
                CALL p_bcast(UOBC_WB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_WB, sp)
                ENDIF
             ENDDO

! sao_wb1(1:3,je,ke) (131)
            ICODE = 131
      	     DO k = 1,ke
                if (have_g_is) then
                 UOBC_WB(1:3,p_joff+1:p_joff+je) = sao_wb1(1:3,1:je,k)
                endif
                CALL p_bcast(UOBC_WB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_WB, sp)
                ENDIF
             ENDDO
#endif
      ENDIF

! EAST BOUNDARY
      if (East) THEN
             IEDIM = JE_G
             IEDIMU = IND * JE_G
             IEDIMV= IND * (JE_G+1)
!:: WRITE 1-D FIELDS
             KCODE=-100
!   obc_ubare(je) (202)
             IEDIM = JE_G
             ICODE = 202
             if (have_g_ie) then
             UOBC_EB(1,p_joff+1:p_joff+je) = obc_ubare(1:je)
             endif
             CALL p_bcast(UOBC_EB, p_io)
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                 WRITE(OUNIT) REAL(UOBC_EB(1,1:JE_G),sp)
             ENDIF
!   obc_vbare(0:je) (203)
          !   IEDIM = JE_G+1
          !   ICODE = 203
          !   VOBC_EB(1,p_joff+j_start:p_joff+je) = obc_vbare(j_start:je)
          !   IF(p_pe==p_io) THEN
          !       WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
          !       WRITE(OUNIT) REAL(VOBC_EB(1,0:JE_G),sp)
          !   ENDIF
!  obcf_ue(je,ke) (212)
             IEDIM = JE_G
             ICODE = 212
             DO k=1,KE
                if (have_g_ie) then
                 UOBC_EB(1,p_joff+1:p_joff+je) = obcf_ue(1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_EB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
! obcf_ve(J_start:je,ke) (213)
             IEDIM = JE_G+1
             ICODE = 213
             DO k=1,KE
                if (have_g_ie) then
                 VOBC_EB(1,p_joff+J_start:p_joff+je) = obcf_ve(J_start:je,k)
                endif
                CALL p_bcast(VOBC_EB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_EB(1,0:JE_G),sp)
                 ENDIF
             ENDDO
!  cli_te(je,ke)   (210)
             IEDIM = JE_G
             ICODE = 210
             DO k=1,KE
                if (have_g_ie) then
                 UOBC_EB(1,p_joff+1:p_joff+je) = cli_te(1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_EB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
! cli_se(je,ke)   (211)
             IEDIM = JE_G
             ICODE = 211
             DO k=1,KE
                if (have_g_ie) then
                 UOBC_EB(1,p_joff+1:p_joff+je) = cli_se(1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_EB(1,1:JE_G),sp)
                 ENDIF
             ENDDO
#ifdef OBCS_TST_NEST
!:: WRITE 2-D FIELDS
!   USOR_eb1(1:3,1:je) (222)
             ICODE = 222
      	     DO i = ie-3,ie1
                if (have_g_ie) then
                 UOBC_EB(i+4-ie,p_joff+1:p_joff+je) = USOR_eb1(i,1:je)
                endif
                CALL p_bcast(UOBC_EB, p_io)
             ENDDO
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                 WRITE(OUNIT) REAL(UOBC_EB, sp)
             ENDIF
             
!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
!  uko_eb1(ie-3:ie1,je,ke)(232)
             ICODE = 232
      	     DO k = 1, ke
                if (have_g_ie) then
      	         UOBC_EB(1:3,p_joff+1:p_joff+je) = uko_eb1(ie-3:ie1,1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_EB, sp)
                ENDIF
             ENDDO
             
!  vke_eb1(ie2:ie,J_start:je,ke)  (233)
             ICODE = 233
      	     DO k = 1,ke
                if (have_g_ie) then
                 VOBC_EB(1:3,p_joff+J_start:p_joff+je) = vke_eb1(ie2:ie,J_start:je,k)
                endif
                CALL p_bcast(VOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_EB, sp)
                ENDIF
             ENDDO
#endif
#else
!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
! uoo_eb1(ie2:ie,je,ke)  (232)
             ICODE = 232
      	     DO k = 1, ke
                if (have_g_ie) then
      	         UOBC_EB(1:3,p_joff+1:p_joff+je) = uoo_eb1(ie2:ie,1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_EB, sp)
                ENDIF
             ENDDO
! voe_eb1(ie2:ie,J_start:je,ke)  (233)
             ICODE = 233
      	     DO k = 1,ke
                if (have_g_ie) then
                 VOBC_EB(1:3,p_joff+J_start:p_joff+je) = voe_eb1(ie2:ie,J_start:je,k)
                endif
                CALL p_bcast(VOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_EB, sp)
                ENDIF
             ENDDO
#endif
#endif
#ifdef ORLANSKI
! tho_wb1(1:3,je,ke) (230)
            ICODE = 230
      	     DO k = 1,ke
                if (have_g_ie) then
                 UOBC_EB(1:3,p_joff+1:p_joff+je) = tho_eb1(ie2:ie,1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_EB, sp)
                ENDIF
             ENDDO

! sao_wb1(1:3,je,ke) (231)
            ICODE = 231
      	     DO k = 1,ke
                if (have_g_ie) then
                 UOBC_EB(1:3,p_joff+1:p_joff+je) = sao_wb1(ie2:ie,1:je,k)
                endif
                CALL p_bcast(UOBC_EB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_EB, sp)
                ENDIF
             ENDDO
#endif
      ENDIF
! NORTH BOUNDARY
      if (North) THEN
             IEDIM = IE_G
             IEDIMV = (IE_G)*IND
             IEDIMU= (IE_G+1)*IND
!:: WRITE 1-D FIELDS
             KCODE=-100
! obc_ubarn(I_start:ie) (302)
           !  IEDIM = IE_G+1
           !  ICODE = 302
           !  UOBC_NB(p_ioff+I_start:p_ioff+ie,1) = obc_ubarn(I_start:ie)
           !  IF(p_pe==p_io) THEN
           !      WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
           !      WRITE(OUNIT) REAL(UOBC_NB(0:IE_G,1),sp)
           !  ENDIF
! obc_vbarn(ie) (303)
             IEDIM = IE_G
             ICODE = 303
             if (have_g_js) then
             VOBC_NB(p_ioff+1:p_ioff+ie,1) = obc_vbarn(1:ie)
             endif
             CALL p_bcast(VOBC_NB, p_io)
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                 WRITE(OUNIT) REAL(VOBC_NB(1:IE_G,1),sp)
             ENDIF
!  obcf_un(I_start:ie,ke)  (312)
             IEDIM = IE_G+1
             ICODE = 312
             DO k=1,KE
                if (have_g_js) then
                 UOBC_NB(p_ioff+I_start:p_ioff+ie,1) = obcf_un(I_start:ie,k)
                endif
                CALL p_bcast(UOBC_NB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_NB(0:IE_G,1),sp)
                 ENDIF
             ENDDO
! obcf_vn(ie,ke) (313)
             IEDIM = IE_G
             ICODE = 313
             DO k=1,KE
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1) = obcf_vn(1:ie,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_NB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
! cli_tn(ie, ke) (310)
             IEDIM = IE_G
             ICODE = 310
             DO k=1,KE
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1) = cli_tn(1:ie,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_NB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
! cli_sn(ie,ke) (311)
             IEDIM = IE_G
             ICODE = 311
             DO k=1,KE
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1) = cli_sn(1:ie,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_NB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
#ifdef OBCS_TST_NEST
!:: WRITE 2-D FIELDS
!   VSER_nb1(ie,1:3) (322)
             KCODE = -100
             ICODE = 322
      	     DO j = 1,3
                 VOBC_NB(p_ioff+1:p_ioff+ie,j) = VSER_nb1(1:ie,j)
             ENDDO
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                 WRITE(OUNIT) REAL(VOBC_NB, sp)
             ENDIF

!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
!  uko_nb1(i_start:ie,1:3,ke)
             ICODE = 332
      	     DO k = 1, ke
                if (have_g_js) then
      	         UOBC_NB(p_ioff+i_start:p_ioff+ie,1:3) = uko_nb1(i_start:ie,1:3,k)
                endif
                CALL p_bcast(UOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_NB, sp)
                ENDIF
             ENDDO

!  vke_nb1(ie,1:3,ke)  (333)
             ICODE = 333
      	     DO k = 1,ke
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1:3) = vke_nb1(1:ie,1:3,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_NB, sp)
                ENDIF
             ENDDO
#endif
#else
#ifdef ORLANSKI
!  uoo_nb1(I_start:ie,1:3,ke)
             ICODE = 332
      	     DO k = 1, ke
                if (have_g_js) then
      	         UOBC_NB(p_ioff+i_start:p_ioff+ie,1:3) = uoo_nb1(i_start:ie,1:3,k)
                endif
                CALL p_bcast(UOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_NB, sp)
                ENDIF
             ENDDO

!  voe_nb1(ie,0:2,ke)   (333)
             ICODE = 333
      	     DO k = 1,ke
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1:3) = voe_nb1(ie,0:2,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_NB, sp)
                ENDIF
             ENDDO
#endif
#endif
#ifdef ORLANSKI
! tho_nb1(ie,1:3,ke) 
            ICODE = 330
      	     DO k = 1,ke
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1:3) = tho_eb1(1:ie,1:3,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(VOBC_NB, sp)
                ENDIF
             ENDDO

! sao_nb1(ie,1:3,ke)
            ICODE = 331
      	     DO k = 1,ke
                if (have_g_js) then
                 VOBC_NB(p_ioff+1:p_ioff+ie,1:3) = sao_nb1(1:ie,1:3,k)
                endif
                CALL p_bcast(VOBC_NB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(VOBC_NB, sp)
                ENDIF
             ENDDO
#endif
      ENDIF

     if (South) THEN
             IEDIM = IE_G
             IEDIMV = (IE_G)*IND
             IEDIMU= (IE_G+1)*IND
!:: WRITE 1-D FIELDS
             KCODE=-100
! obc_ubars(I_start:ie) (402)
           !  IEDIM = IE_G+1
           !  ICODE = 402
           !  UOBC_SB(p_ioff+i_start:p_ioff+ie,1) = obc_ubars(I_start:ie)
           !  IF(p_pe==p_io) THEN
           !      WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
           !      WRITE(OUNIT) REAL(UOBC_SB(0:IE_G,1),sp)
           !  ENDIF
! obc_vbarn(ie) (403)
             IEDIM = IE_G
             ICODE = 403
             if (have_g_je) then
                VOBC_SB(p_ioff+1:p_ioff+ie,1) = obc_vbars(1:ie)
             endif
             CALL p_bcast(VOBC_SB, p_io)
             WRITE(IO_STDOUT,*)' ++++++ South Var 403'
             WRITE(IO_STDOUT,*)' ++++++ obc_vbars',obc_vbars(1:ie)
             WRITE(IO_STDOUT,*)' ++++++ VOBC_SB',VOBC_SB(p_ioff+1:p_ioff+ie,1)
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                 WRITE(OUNIT) REAL(VOBC_SB(1:IE_G,1),sp)
             ENDIF
!  obcf_us(I_start:ie,ke)  (412)
             IEDIM = IE_G+1
             ICODE = 412
             DO k=1,KE
                if (have_g_je) then
                 UOBC_SB(p_ioff+I_start:p_ioff+ie,1) = obcf_us(I_start:ie,k)
                endif
                CALL p_bcast(UOBC_SB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(UOBC_SB(0:IE_G,1),sp)
                 ENDIF
             ENDDO
! obcf_vs(ie,ke) (413)
             IEDIM = IE_G
             ICODE = 413
             DO k=1,KE
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1) = obcf_vs(1:ie,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_SB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
! cli_ts(ie,ke)  (410)
             IEDIM = IE_G
             ICODE = 410
             DO k=1,KE
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1) = cli_ts(1:ie,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_SB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
! cli_ss(ie, ke) (411)
             IEDIM = IE_G
             ICODE = 411
             DO k=1,KE
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1) = cli_ss(1:ie,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
                 KCODE=TIESTU(K)
                 IF(p_pe==p_io) THEN
                     WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
                     WRITE(OUNIT) REAL(VOBC_SB(1:IE_G,1),sp)
                 ENDIF
             ENDDO
#ifdef OBCS_TST_NEST
!:: WRITE 2-D FIELDS
!   VSER_sb1(ie,je-3:je1) (422)
             KCODE = -100
             ICODE = 422
      	     DO j = je-3,je1
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,j+4-je) = VSER_sb1(1:ie,j)
                endif
                CALL p_bcast(VOBC_SB, p_io)
             ENDDO
             IF(p_pe==p_io) THEN
                 WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                 WRITE(OUNIT) REAL(VOBC_SB, sp)
             ENDIF

!:: WRITE 3-D FIELDS
#ifdef ORLANSKI
!  uko_sb1(i_start:ie,je2:je,ke)   
             ICODE = 432
      	     DO k = 1, ke
                if (have_g_je) then
      	         UOBC_SB(p_ioff+i_start:p_ioff+ie,1:3) = uko_sb1(i_start:ie,je2:je,k)
                endif
                CALL p_bcast(UOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_SB, sp)
                ENDIF
             ENDDO

!  vke_sb1(ie,je-3:je1,ke)  (433)
             ICODE = 433
      	     DO k = 1,ke
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1:3) = vke_sb1(1:ie,je-3:je1,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_SB, sp)
                ENDIF
             ENDDO
#endif
#else
#ifdef ORLANSKI
!:: WRITE 3-D FIELDS
!  uoo_sb1(I_start:ie,je2:je,ke)
             ICODE = 432
      	     DO k = 1, ke
                if (have_g_je) then
      	         UOBC_SB(p_ioff+i_start:p_ioff+ie,1:3) = uoo_sb1(I_start:ie,je2:je,ke)
                endif
                CALL p_bcast(UOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(UOBC_SB, sp)
                ENDIF
             ENDDO

!  voe_sb1(ie,je2:je,ke) (433)
             ICODE = 433
      	     DO k = 1,ke
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1:3) = voe_sb1(ie,je2:je,ke) 
                endif
                CALL p_bcast(VOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
                    WRITE(OUNIT) REAL(VOBC_SB, sp)
                ENDIF
             ENDDO
#endif
#endif /*OBCS_TST_NEST*/
#ifdef ORLANSKI
!  tho_sb1(ie,je2:je,ke)
            ICODE = 430
      	     DO k = 1,ke
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1:3) = tho_sb1(1:ie,je2:je,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(VOBC_SB, sp)
                ENDIF
             ENDDO

! sao_sb1(ie,je2:je,ke)
            ICODE = 431
      	     DO k = 1,ke
                if (have_g_je) then
                 VOBC_SB(p_ioff+1:p_ioff+ie,1:3) = sao_nb1(1:ie,je2:je,k)
                endif
                CALL p_bcast(VOBC_SB, p_io)
      	         KCODE=TIESTU(K)
                IF(p_pe==p_io) THEN
                    WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
                    WRITE(OUNIT) REAL(VOBC_SB, sp)
                ENDIF
             ENDDO
#endif
      ENDIF
      
      OFLAG=-OFLAG
      IF(p_pe==p_io) THEN
        REWIND(OUNIT)
        CLOSE(IO_IN_O370)
        CLOSE(IO_IN_O380)
      ENDIF
      
     END SUBROUTINE AUFW_OBCS
!****************************************************************
!
!     AAAAAA  U    U  FFFFFF  RRRRRR
!     A    A  U    U  F       R    R
!     AAAAAA  U    U  FFFFF   RRRRRR
!     A    A  U    U  F       R  RR
!     A    A  UUUUUU  F       R   RR
!
!
!
!*****************************************************************
! SUBROUTINE AUFR_OBCS
!
!     THIS SBR WRITES ROUTINELY AT CERTAIN TIME INTERVALS
!     A RESTART FILE ON OBC37 OR OBC38 FOR OPEN BOUNDARY CONDITIONS
!
!-----------------------------------------------------------------
      SUBROUTINE AUFR_OBCS

      REAL(KIND=sp) ODT27, ODT28, RDT(2)
      INTEGER(KIND=i4) I4DATE(4)
      INTEGER i, j, k
     
      IF (p_pe==p_io) THEN
            OPEN(IO_IN_O370,FILE='OBC37',    &
         &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    
            OPEN(IO_IN_O380,FILE='OBC38',    &
         &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
    
            REWIND(IO_IN_O370)
            REWIND(IO_IN_O380)
!
        READ(IO_IN_O370,ERR=99,END=99) I4DATE
        READ(IO_IN_O370,ERR=99,END=99) ODT27
        GOTO 1
   99   ODT27=0.0
        WRITE(IO_STDOUT,*)'NO DATA ON RESTART FILE OBC370 !!!'
    1   READ(IO_IN_O380,ERR=88,END=88) I4DATE
        READ(IO_IN_O380,ERR=88,END=88) ODT28
        GOTO 2
   88   ODT28=0.0
        WRITE(IO_STDOUT,*)'NO DATA ON RESTART FILE OBC380 !!!'
    2   WRITE(IO_STDOUT,6000)ODT27,ODT28
 6000   FORMAT(' OBC370 TIMESTEPS : ',F10.0                            &
     &        ,' OBC380 TIMESTEPS : ',F10.0)
!
        IF(ODT27.GT.ODT28)THEN
          OUNIT=IO_IN_O370
          OFLAG=1
        ELSE
          OUNIT=IO_IN_O380
          OFLAG=-1
        ENDIF
        
        REWIND(OUNIT)
!      var999
        READ(OUNIT) I4DATE
        READ(OUNIT) RDT
      ENDIF
      
      ! attentions 
      CALL p_bcast(OFLAG,p_io)  
      CALL p_bcast(OUNIT,p_io)
      
!CCC
#ifdef OBC_TIDE
!  READ USOT(I_start:IE,JE) obc_uTNw obc_uTNe  obc_uTNs obc_uTNn
      IF(p_pe==p_io) READ(OUNIT) I4DATE
      CALL read_slice(OUNIT,USOT,1)
      
!  READ VSET(IE,J_start:JE)
      IF(p_pe==p_io) READ(OUNIT) I4DATE
      CALL read_slice(OUNIT,VSET,2)

!  READ ZetaT(IE,JE)
      IF(p_pe==p_io) READ(OUNIT) I4DATE
      CALL read_slice(OUNIT, ZetaT)
#endif
#ifdef OBC_SUBTIDE
!  READ zeta_subT(IE,JE)
!  var83
      IF(p_pe==p_io) READ(OUNIT) I4DATE
      CALL read_slice(OUNIT, zeta_subT)
#endif
#ifdef OBCS_TST_NEST
      ! :: UPDATE TST OBCS VALUES AT THE FORMER STEP
      CALL OBCS_TST_FIRST
       WRITE(IO_STDOUT,*)' ++++++ OBCS_TST_FIRST BOUNDARY RESTART'
#endif

!:: READ WEST BOUNDARY
      if (WEST) THEN
!   obc_ubarw(je) (102) ---> obc_ubarNw
!    var102  
        WRITE(IO_STDOUT,*)' ++++++ WEST OBC BOUNDARY RESTART'
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 WRITE(IO_STDOUT,*) I4DATE
                 READ(OUNIT) UOBC_WB(1,1:JE_G)
             ENDIF
            CALL p_bcast(UOBC_WB,p_io)
            if (have_g_is) then
             obc_ubarNw(1:je) = UOBC_WB(1,p_joff+1:p_joff+je) 
            endif

!   obc_vbarw(0:je) (103) 
           !  IF(p_pe==p_io) THEN
           !      READ(OUNIT) I4DATE
           !      READ(OUNIT) VOBC_WB(1,0:JE_G),
           !  ENDIF
           !  obc_vbarNw(1:je) = VOBC_WB(1,p_joff+j_start:p_joff+je) 

!    obcf_uw(je,ke) (112) ---> obc_uNw
           DO K=1,KE
           IF(p_pe==p_io) THEN
               READ(OUNIT) I4DATE
               READ(OUNIT) UOBC_WB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_WB,p_io)
           if (have_g_is) then
            obc_uNw(1:je,K) = UOBC_WB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
            
! obcf_vw(J_start:je,ke) (113)  --->  obc_vNw
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_WB(1,0:JE_G)
           ENDIF
           CALL p_bcast(VOBC_WB,p_io)
           if (have_g_is) then
            obc_vNw(J_start:je,K) =  VOBC_WB(1,p_joff+J_start:p_joff+je) 
           endif
           ENDDO

! cli_tw(je,ke)  (110) --->  cli_tNw
           DO K=1,KE
           IF(p_pe==p_io) THEN
               READ(OUNIT) I4DATE
               READ(OUNIT) UOBC_WB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_WB,p_io)
           if (have_g_is) then
            cli_tNw(1:je,K) = UOBC_WB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
           
! cli_sw(je,ke)  (111) --->  cli_sNw
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
               READ(OUNIT) UOBC_WB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_WB,p_io)
           if (have_g_is) then
            cli_sNw(1:je,K) = UOBC_WB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
#ifdef OBCS_TST_NEST
!:: READ 2-D FIELDS
!   USOR_wb1(1:3,1:je) (122)
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_WB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_WB,p_io)
             if (have_g_is) then
      	     DO i = 1,3
                 USOR_wb1(i,1:je) = UOBC_WB(i,p_joff+1:p_joff+je) 
             ENDDO
             endif
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uko_wb1(1:3,1:je,ke) (132)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_WB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_WB,p_io)
             if (have_g_is) then
             uko_wb1(1:3,1:je,K)  = UOBC_WB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO
!  vke_wb1(1:3,J_start:je,ke) (133)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_WB(i,j),j=0,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(VOBC_WB,p_io)
             if (have_g_is) then
             vke_wb1(1:3,J_start:je,K)  = UOBC_WB(1:3,p_joff+J_start:p_joff+je)
            endif
            ENDDO
#endif
#else
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uoo_wb1(0:2,je,ke) (132)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_WB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_WB,p_io)
             if (have_g_is) then
             uoo_wb1(0:2,1:je,K)  = UOBC_WB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO
!  voe_wb1(1:3,J_start:je,ke)  (133)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_WB(i,j),j=0,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(VOBC_WB,p_io)
             if (have_g_is) then
             voe_wb1(1:3,J_start:je,K)  = UOBC_WB(1:3,p_joff+J_start:p_joff+je)
            endif
            ENDDO
#endif
#endif
#ifdef ORLANSKI
! tho_wb1(1:3,je,ke) (131)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_WB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_WB,p_io)
             if (have_g_is) then
             tho_wb1(1:3,1:je,K)  = UOBC_WB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO
! sao_wb1(1:3,je,ke) (132)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_WB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_WB,p_io)
             if (have_g_is) then
             sao_wb1(1:3,1:je,K)  = UOBC_WB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO
#endif
	    WRITE(IO_STDOUT,*)' ++++++ West BOUNDARY RESTART'
      ENDIF ! West end
      
      if (East) THEN
!:: READ 1-D FIELDS
!   obc_ubare(je) (202)  --> obc_ubarNe
           WRITE(IO_STDOUT,*)' ++++++ East OBC BOUNDARY RESTART'
           IF(p_pe==p_io) THEN
           	   READ(OUNIT) I4DATE
               READ(OUNIT) UOBC_EB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_EB,p_io)
           if (have_g_je) then
           obc_ubarNe(1:je) = UOBC_EB(1,p_joff+1:p_joff+je) 
           endif
!   obc_vbare(0:je) (203) --> obc_vbarNe
         !  IF(p_pe==p_io) THEN
         !  	   READ(OUNIT) I4DATE
         !      READ(OUNIT) VOBC_EB(1,0:JE_G)
         !  ENDIF
         !  obc_vbarNe(J_start:je) = VOBC_EB(1,p_joff+J_start:p_joff+je) 
!  obcf_ue(je,ke) (212)  --> obc_uNe
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) UOBC_EB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_EB,p_io)
           if (have_g_je) then
           obc_uNe(:,K) = UOBC_EB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
! obcf_ve(J_start:je,ke) (213)  --> obc_vNe
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_EB(1,0:JE_G)
           ENDIF
           CALL p_bcast(VOBC_EB,p_io)
           if (have_g_je) then
           obc_vNe(J_start:je,K) = VOBC_EB(1,p_joff+J_start:p_joff+je)
           endif
           ENDDO
           
! cli_te(je,ke)  (210) --->  cli_tNe
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) UOBC_EB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_EB,p_io)
           if (have_g_je) then
           cli_tNe(:,K) = UOBC_EB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
           
! cli_se(je,ke)  (211) --->  cli_sNe
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) UOBC_EB(1,1:JE_G)
           ENDIF
           CALL p_bcast(UOBC_EB,p_io)
           if (have_g_je) then
           cli_sNe(:,K) = UOBC_EB(1,p_joff+1:p_joff+je)
           endif
           ENDDO
#ifdef OBCS_TST_NEST
!:: READ 2-D FIELDS
!   USOR_eb1(ie-3:ie1,je) (222)
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_EB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_EB,p_io)
             if (have_g_je) then
      	     DO i = ie-3,ie1
                 USOR_eb1(i,1:je) = UOBC_EB(i+4-ie,p_joff+1:p_joff+je) 
             ENDDO
             endif
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uko_eb1(ie-3:ie1,je,ke) (232)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_EB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_EB,p_io)
             if (have_g_je) then
             uko_eb1(ie-3:ie1,1:je,k)  = UOBC_EB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO

!  vke_eb1(ie2:ie,J_start:je,ke) (233)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_EB(i,j),j=0,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(VOBC_EB,p_io)
             if (have_g_je) then
             vke_eb1(ie2:ie,J_start:je,k)  = VOBC_EB(1:3,p_joff+J_start:p_joff+je)
            endif
            ENDDO
#endif
#else

!:: READ 3-D FIELDS
#ifdef ORLANSKI
!  uoo_eb1(ie2:ie,je,ke)(232)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_EB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_EB,p_io)
             if (have_g_je) then
             uoo_eb1(ie2:ie,1:je,k)  = UOBC_EB(1:3,p_joff+1:p_joff+je)
            endif
            ENDDO

!  voe_eb1(ie2:ie,J_start:je,ke)(233)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_EB(i,j),j=0,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(VOBC_EB,p_io)
             if (have_g_je) then
             voe_eb1(ie2:ie,J_start:je,k)  = VOBC_EB(1:3,p_joff+J_start:p_joff+je)
            endif
            ENDDO
#endif
#endif
#ifdef ORLANSKI
! tho_wb1(ie2:ie,je,ke) (230)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_EB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_EB,p_io) 
             if (have_g_je) then
             tho_eb1(ie2:ie,1:je,k) = UOBC_EB(1:3,p_joff+1:p_joff+je) 
            endif
            ENDDO
            
! sao_wb1(ie2:ie,je,ke) (231)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_EB(i,j),j=1,JE_G),i=1,3)
             ENDIF
             CALL p_bcast(UOBC_EB,p_io)
             if (have_g_je) then
             sao_wb1(ie2:ie,1:je,k) = UOBC_EB(1:3,p_joff+1:p_joff+je) 
            endif
            ENDDO
#endif
	    WRITE(IO_STDOUT,*)' ++++++ East BOUNDARY RESTART'
      ENDIF ! East end

      if (North) THEN
        WRITE(IO_STDOUT,*)' ++++++ North OBC BOUNDARY RESTART'
!:: READ 1-D FIELDS
! obc_ubarn(I_start:ie) (302) --> obc_ubarNn
        !   IF(p_pe==p_io) THEN
        !   	   READ(OUNIT) I4DATE
        !       READ(OUNIT) UOBC_NB(0:IE_G,1)
        !   ENDIF
        !   obc_ubarNn(I_start:ie) = UOBC_EB(1,p_ioff+I_start:p_ioff+ie) 
! obc_vbarn(ie) (303) --> obc_vbarNn
      	  IF(p_pe==p_io) THEN
      	      READ(OUNIT) I4DATE
      	      READ(OUNIT) VOBC_NB(1:IE_G,1)
      	  ENDIF
          CALL p_bcast(VOBC_NB,p_io)
          if (have_g_js) then
      	  obc_vbarNn(1:ie) = VOBC_NB(p_ioff+1:p_ioff+ie,1) 
          endif
!  obcf_un(I_start:ie,ke)  (312) --> obc_uNn
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) UOBC_NB(0:IE_G,1)
           ENDIF
           CALL p_bcast(UOBC_NB,p_io)
           if (have_g_js) then
           obc_uNn(I_start:ie,K) = UOBC_NB(p_ioff+I_start:p_ioff+ie,1)
           endif
           ENDDO
! obcf_vn(ie,ke) (313) --> obc_vNn
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_NB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_NB,p_io)   
           if (have_g_js) then
           obc_vNn(1:ie,k) = VOBC_NB(p_ioff+1:p_ioff+ie,1) 
           endif
           ENDDO
! cli_tn(ie, ke) (310)   --> cli_tNn
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_NB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_NB,p_io)
           if (have_g_js) then
           cli_tNn(1:ie,k) = VOBC_NB(p_ioff+1:p_ioff+ie,1) 
           endif
           ENDDO

! cli_sn(ie,ke)  (311) --> cli_sNn
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_NB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_NB,p_io)
           if (have_g_js) then
           cli_sNn(1:ie,k) = VOBC_NB(p_ioff+1:p_ioff+ie,1) 
           endif
           ENDDO
#ifdef OBCS_TST_NEST
!:: READ 2-D FIELDS
!   VSER_nb1(ie,1:3) (322)
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_NB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_NB,p_io)
             if (have_g_js) then
      	     DO j=1,3
                 VSER_nb1(1:ie,j) = VOBC_NB(p_ioff+1:p_ioff+ie,j) 
             ENDDO
             endif
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uko_nb1(i_start:ie,1:3,ke)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_NB(i,j),i=0,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(UOBC_NB,p_io)
             if (have_g_js) then
             uko_nb1(i_start:ie,1:3,k) = UOBC_NB(p_ioff+i_start:p_ioff+ie,1:3) 
            endif
            ENDDO

!  vke_nb1(ie,1:3,ke)  (333)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_NB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_NB,p_io)
             if (have_g_js) then
             vke_nb1(1:ie,1:3,k)= VOBC_NB(p_ioff+1:p_ioff+ie,1:3)
            endif
            ENDDO
#endif 
#else
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uoo_nb1(I_start:ie,1:3,ke)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_NB(i,j),i=0,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(UOBC_NB,p_io)
             if (have_g_js) then
             uoo_nb1(I_start:ie,1:3,k) = UOBC_NB(p_ioff+i_start:p_ioff+ie,1:3) 
            endif
            ENDDO

!  voe_nb1(ie,0:2,ke)  (333)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_NB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_NB,p_io)
             if (have_g_js) then
             voe_nb1(1:ie,0:2,k)= VOBC_NB(p_ioff+1:p_ioff+ie,1:3)
            endif
            ENDDO
#endif
#endif
#ifdef ORLANSKI
! tho_nb1(ie,1:3,ke) (330)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_NB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_NB,p_io)
             if (have_g_js) then
             tho_nb1(1:ie,1:3,k)= VOBC_NB(p_ioff+1:p_ioff+ie,1:3)
            endif
            ENDDO
! sao_nb1(ie,1:3,ke) (331)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_NB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_NB,p_io)
             sao_nb1(1:ie,1:3,k)= VOBC_NB(p_ioff+1:p_ioff+ie,1:3)
            ENDDO
#endif            
     	 WRITE(IO_STDOUT,*)' ++++++ North BOUNDARY RESTART'
      ENDIF ! North end

      if (South) THEN
        WRITE(IO_STDOUT,*)' ++++++ South OBC BOUNDARY RESTART'
!:: READ 1-D FIELDS
! obc_ubars(I_start:ie) (402) --> obc_ubarNs
        !   IF(p_pe==p_io) THEN
        !   	   READ(OUNIT) I4DATE
        !       READ(OUNIT) UOBC_SB(0:IE_G,1)
        !   ENDIF
        !   obc_ubarNs(I_start:ie) = UOBC_SB(p_ioff+I_start:p_ioff+ie,1) 
! obc_vbarn(ie) (403) --> obc_vbarNn
      	  IF(p_pe==p_io) THEN
      	      READ(OUNIT) I4DATE
      	      READ(OUNIT) VOBC_SB(1:IE_G,1)
      	  ENDIF
            CALL p_bcast(VOBC_SB,p_io)
            if (have_g_je) then
      	        obc_vbarNs(1:ie) = VOBC_SB(p_ioff+1:p_ioff+ie,1) 
            endif
!  obcf_us(I_start:ie,ke)  (412)  --> obc_uNs
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) UOBC_SB(0:IE_G,1)
           ENDIF
           CALL p_bcast(UOBC_SB,p_io)
           if (have_g_ie) then
                obc_uNs(I_start:ie,K) = UOBC_SB(p_ioff+I_start:p_ioff+ie,1)
           endif
           ENDDO
! obcf_vs(ie,ke) (413)  --> obc_vNs
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_SB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_SB,p_io)
           if (have_g_ie) then
                obc_vNs(1:ie,K) = VOBC_SB(p_ioff+1:p_ioff+ie,1)
           endif
           ENDDO
! cli_ts(ie,ke)  (410)  --> cli_tNs
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_SB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_SB,p_io)
           if (have_g_ie) then
                 cli_tNs(1:ie,K) = VOBC_SB(p_ioff+1:p_ioff+ie,1)
           endif
           ENDDO
! cli_ss(ie, ke) (411)  --> cli_sNs
           DO K=1,KE
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) VOBC_SB(1:IE_G,1)
           ENDIF
           CALL p_bcast(VOBC_SB,p_io)
           if (have_g_ie) then
                 cli_sNs(1:ie,K) = VOBC_SB(p_ioff+1:p_ioff+ie,1)
           endif
           ENDDO
#ifdef OBCS_TST_NEST
!:: READ 2-D FIELDS
!   VSER_sb1(ie,je-3:je1) (422)
           IF(p_pe==p_io) THEN
              	READ(OUNIT) I4DATE
                READ(OUNIT) ((VOBC_SB(i,j),i=1,IE_G),j=1,3)
           ENDIF
           CALL p_bcast(VOBC_SB,p_io)
           if (have_g_je) then
      	   DO j = je-3,je1
     	       VSER_sb1(1:ie,j) = VOBC_SB(p_ioff+1:p_ioff+ie,j+4-je)
     	     ENDDO
           endif
#ifdef ORLANSKI
!:: READ 3-D FIELDS
!  uko_sb1(i_start:ie,je2:je,ke)  (432)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_SB(i,j),i=0,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(UOBC_SB,p_io)
             if (have_g_ie) then
             uko_sb1(i_start:ie,je2:je,k) =  UOBC_SB(p_ioff+I_start:p_ioff+ie,1:3)
            endif
            ENDDO

!  vke_sb1(ie,je-3:je1,ke)  (433)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_SB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_SB,p_io)
             if (have_g_ie) then
             vke_sb1(1:ie,je-3:je1,k) =  VOBC_SB(p_ioff+1:p_ioff+ie,1:3) 
            endif
            ENDDO
#endif
#else
!:: READ 3-D FIELDS
#ifdef ORLANSKI
!  uoo_sb1(I_start:ie,je2:je,ke) (432)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((UOBC_SB(i,j),i=0,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(UOBC_SB,p_io)
             if (have_g_ie) then
             uoo_sb1(i_start:ie,je2:je,k) =  UOBC_SB(p_ioff+I_start:p_ioff+ie,1:3)
            endif
            ENDDO

!  voe_sb1(ie,je2:je,ke) (433)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_SB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_SB,p_io)
             if (have_g_ie) then
             voe_sb1(1:ie,je2:je,k) =  VOBC_SB(p_ioff+1:p_ioff+ie,1:3) 
            endif
            ENDDO
#endif
#endif
#ifdef ORLANSKI
!  tho_sb1(ie,je2:je,ke) (430)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_SB(i,j),i=1,IE_G),j=1,3)
             ENDIF
             CALL p_bcast(VOBC_SB,p_io)
             if (have_g_ie) then
             tho_sb1(1:ie,je2:je,k)=  VOBC_SB(p_ioff+1:p_ioff+ie,1:3) 
            endif
            ENDDO

! sao_sb1(ie,je2:je,ke) (431)
            DO K=1,KE
             IF(p_pe==p_io) THEN
                 READ(OUNIT) I4DATE
                 READ(OUNIT) ((VOBC_SB(i,j),i=1,IE_G),j=1,3)
             ENDIF
              CALL p_bcast(VOBC_SB,p_io)
              if (have_g_ie) then
              sao_sb1(1:ie,je2:je,k)=  VOBC_SB(p_ioff+1:p_ioff+ie,1:3) 
              endif
            ENDDO
#endif            
        WRITE(IO_STDOUT,*)' ++++++ South BOUNDARY RESTART'
         ENDIF ! South end


         IF(p_pe==p_io) THEN
           REWIND(OUNIT)
           CLOSE(IO_IN_O370)
           CLOSE(IO_IN_O380)
         ENDIF
      
      RETURN
      END SUBROUTINE AUFR_OBCS
     

      SUBROUTINE OBCS_TST_FIRST 
#ifdef OBCS_TST_NEST
        IF (WEST .and. have_g_is) THEN
#ifdef OBC_TIDE
        	obc_uTNw(1:3,:) = USOT(1:3,:)
        	obc_vTNw(1:3,:) = VSET(1:3,:)
          obc_zTNw(1:je)    =0.5*(zetaT(1,1:je) + zetaT(2,1:je))
#endif
#ifdef OBC_SUBTIDE
          obc_zsubNw(1:je)     = zeta_subT(1,1:je) 
#endif
        ENDIF
      
        IF (EAST .and. have_g_ie) THEN
#ifdef OBC_TIDE
        	 obc_uTNe(ie-3:ie1,:) = USOT(ie-3:ie1,:)
        	 obc_vTNe(ie2:ie,:) = VSET(ie2:ie,:)
           obc_zTNe(1:je)    = 0.5*(zetaT(ie,1:je)+zetaT(ie1,1:je)) 
#endif
#ifdef OBC_SUBTIDE
           obc_zsubNe(1:je)     = zeta_subT(ie,1:je)
#endif
        ENDIF
      
        IF (NORTH .and. have_g_js) THEN
#ifdef OBC_TIDE
        	 obc_uTNn(:,1:3) = USOT(:,1:3)
        	 obc_vTNn(:,1:3) = VSET(:,1:3)
           obc_zTNn(1:ie)   = 0.5*(zetaT(1:ie,1) + zetaT(1:ie,2) ) 
#endif
#ifdef OBC_SUBTIDE
           obc_zsubNn(1:ie)    = zeta_subT(1:ie,1)
#endif
        ENDIF
        
        IF (SOUTH .and. have_g_je) THEN
#ifdef OBC_TIDE
        	 obc_uTNs(:,je2:je) = USOT(:,je2:je)
        	 obc_vTNs(:,je-3:je-1) = VSET(:,je-3:je-1)
           obc_zTNs(1:ie)   =  0.5*(zetaT(1:ie,je) + zetaT(1:ie,je1) )
#endif
#ifdef OBC_SUBTIDE
           obc_zsubNs(1:ie)    = zeta_subT(1:ie,je)
        ENDIF
#endif
#endif
      END SUBROUTINE OBCS_TST_FIRST 

#endif
     END MODULE MO_OBCS_RESTART



      
      
