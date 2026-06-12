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
#if defined ORLANSKI || defined OBCS_TST_NEST
          REAL, POINTER :: UOBC(:,:,:),VOBC(:,:,:),      &
         &                 TOBC(:,:,:)
#endif
         CONTAINS
    
          SUBROUTINE alloc_obcs_restart
#if defined ORLANSKI || defined OBCS_TST_NEST
         ALLOCATE(UOBC(I_start:ie,je,ke),VOBC(ie,j_start:je,ke),      &
         &                 TOBC(ie,je,ke))
    
         UOBC=0.0;VOBC=0.0;TOBC=0.0
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
          INTEGER k, J, l
          REAL(KIND=sp) rldt, rldays
          
          IF(p_pe==p_io) THEN
                OPEN(IO_IN_O370,FILE='OBC37',    &
             &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
        
                OPEN(IO_IN_O380,FILE='OBC38',    &
             &  STATUS='UNKNOWN',ACCESS='SEQUENTIAL',FORM='UNFORMATTED')
        
                REWIND(IO_IN_O370)
                REWIND(IO_IN_O380)
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
    ! OBC file variables code:::
    !
    !       USOT(I_start:IE,JE): 63
    !       VSET(IE,J_start:JE): 64
    !              ZetaT(IE,JE): 82
    !          zeta_subT(IE,JE): 83
    !    ICODE Rules
    !    1(Boundary)   2(Dimension)   3(Varaibles)
    !        1             1D:   0         T: 0    LINE
    !        1             1D+K: 1         S: 1    WALL
    !        1             2D:   2         U: 2    SURFACE
    !        1             2D+K: 3         V: 3    VOLUME

    ! Variables code: 999 
    !       63 64 82 83
    !       102 112 103 113 
    !       110 111 122 123
    !       132 133 130 131
    !
    ! Attention: ZOOOLD & USOOLD VSEOLD
    ! W :USOR_wb1(1:3,je) uko_wb1(1:3,1:je,ke) vke_wb1(1:3,J_start:je,ke) tho_wb1(1:3,je,ke)  sao_wb1(1:3,je,ke)
    ! E: USOR_eb1(ie-3:ie1,je) uko_eb1(ie-3:ie1,je,ke) vke_eb1(ie2:ie,J_start:je,ke) tho_eb1(ie2:ie,je,ke) sao_eb1(ie2:ie,je,ke)
    ! N: VSER_nb1(ie,1:3) uko_nb1(i_start:ie,1:3,ke) vke_nb1(ie,1:3,ke) tho_nb1(ie,1:3,ke) sao_nb1(ie,1:3,ke)
    ! S: VSER_sb1(ie,je-3:je1) uko_sb1(i_start:ie,je2:je,ke) vke_sb1(ie,je-3:je1,ke)  tho_sb1(ie,je2:je,ke) sao_sb1(ie,je2:je,ke)
    !
    ! Orlanski radiation 
    ! U:  uoo_wb1(0:2,je,ke) uoo_eb1(ie2:ie,je,ke) uoo_nb1(I_start:ie,1:3,ke) uoo_sb1(I_start:ie,je2:je,ke)
    ! V: voe_wb1(1:3,J_start:je,ke) voe_eb1(ie2:ie,J_start:je,ke) voe_nb1(ie,0:2,ke)  voe_sb1(ie,je2:je,ke)
    !
    ! OBCS boundary array size :  
    !                     FLA    FLA    SUBTIDE  SUBTIDE orlanski  orlanski
    !  W :  obc_ubarw(je)  obc_vbarw(J_start:je) obcf_uw(je,ke)  obcf_vw(J_start:je,ke) cli_tw(je,ke)  cli_sw(je,ke) 
    !  E  :  obc_ubare(je)  obc_vbare(J_start:je) obcf_ue(je,ke)  obcf_ve(J_start:je,ke)  cli_te(je,ke)  cli_se(je,ke) 
    !  N :   obc_ubarn(I_start:ie) obc_vbarn(ie)  obcf_un(I_start:ie,ke) obcf_vn(ie,ke) cli_tn(ie, ke) cli_sn(ie,ke)
    !  S :  obc_ubars(I_start:ie) obc_vbars(ie) obcf_us(I_start:ie,ke) obcf_vs(ie,ke) cli_ts(ie,ke) cli_ss(ie, ke)
    !
    !:: WRITE TIME STEP INFORMATION
           ! var999
           KCODE=-100
           ICODE=999
           IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM00
           IF(p_pe==p_io) WRITE(OUNIT) RLDT,RLDAYS
#ifdef OBC_TIDE
    !:: WRITE USOT(I_start:IE,JE) obc_uTNw obc_uTNe  obc_uTNs obc_uTNn
           ! var63
           ICODE=63
           KCODE=-100
           IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
           CALL write_slice(OUNIT,USOT,1)
           
    !:: WRITE VSET(IE,J_start:JE)
           ! var64
           ICODE=64
           KCODE=-100
           IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
           CALL write_slice(OUNIT,VSET,2)
    
    
    !:: WRITE ZetaT(IE,JE)
           ! var82
           ICODE=82
           KCODE=-100
           IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
           CALL write_slice(OUNIT,ZetaT)
#endif
    
#ifdef OBC_SUBTIDE
    !:: WRITE zeta_subT(IE,JE)
           ! var83
           ICODE=83
           KCODE=-100
           IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
           CALL write_slice(OUNIT,zeta_subT)
#endif
    
    
    !:: U
    !:: obc_ubarw(je) obc_ubare(je) obc_ubarn(I_start:ie) obc_ubars(I_start:ie) 
        ! var102
        KCODE=-100
        ICODE=102
        UOBC=0.0
        if (have_g_is .and. west) then
            UOBC(I_start,:,1)=obc_ubarw(1:je)
        endif
        if (have_g_ie .and. east) then
            UOBC(ie,:,1)=obc_ubare(1:je)
        endif
        if (have_g_js .and. north) then
            UOBC(:,1,1)=obc_ubarn(I_start:ie)
        endif
        if (have_g_je .and. south) then
            UOBC(:,je,1)=obc_ubars(I_start:ie)
        endif

        IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
        CALL write_slice(OUNIT,UOBC(:,:,1),1)


    !:: obcf_uw(je,ke) obcf_ue(je,ke) obcf_un(I_start:ie,ke) obcf_us(I_start:ie,ke)
        ! var112
        ICODE=112
        UOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                UOBC(I_start,:,k)=obcf_uw(1:je,k)
            endif
            if (have_g_ie .and. east) then
                UOBC(ie,:,k)=obcf_ue(1:je,k)
            endif
            if (have_g_js .and. north) then
                UOBC(:,1,k)=obcf_un(I_start:ie,k)
            endif
            if (have_g_je .and. south) then
                UOBC(:,je,k)=obcf_us(I_start:ie,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
            CALL write_slice(OUNIT,UOBC(:,:,k),1)
        ENDDO

        ! V
        KCODE=-100
        !   obc_vbarw(J_start:je) obc_vbare(J_start:je) obc_vbarn(1:ie) obc_vbars(1:ie) 
        ! var103
        ICODE=103
        VOBC=0.0
        if (have_g_is .and. west) then
            VOBC(1,:,1)=obc_vbarw(J_start:je)
        endif
        if (have_g_ie .and. east) then
            VOBC(ie,:,1)=obc_vbare(J_start:je)
        endif
        if (have_g_js .and. north) then
            VOBC(:,J_start,1)=obc_vbarn(1:ie)
        endif
        if (have_g_je .and. south) then
            VOBC(:,je,1)=obc_vbars(1:ie)
        endif

        IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
        CALL write_slice(OUNIT,VOBC(:,:,1),2)


        ! obcf_vw(J_start:je,ke) obcf_ve(J_start:je,ke) obcf_vn(ie,ke) obcf_vs(ie,ke)
        ! var113
        ICODE = 113
        VOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                VOBC(1,:,k)=obcf_vw(J_start:je,k)
            endif
            if (have_g_ie .and. east) then
                VOBC(ie,:,k)=obcf_ve(J_start:je,k)
            endif
            if (have_g_js .and. north) then
                VOBC(:,J_start,k)=obcf_vn(1:ie,k)
            endif
            if (have_g_je .and. south) then
                VOBC(:,je,k)=obcf_vs(1:ie,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
            CALL write_slice(OUNIT,VOBC(:,:,k),2)
        ENDDO

        ! T 
        ! cli_tw(je,ke) cli_te(je,ke) cli_tn(ie, ke) cli_ts(ie,ke)
        ! var110
        ICODE = 110
        TOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                TOBC(1,:,k)=cli_tw(1:je,k)
            endif
            if (have_g_ie .and. east) then
                TOBC(ie,:,k)=cli_te(1:je,k)
            endif
            if (have_g_js .and. north) then
                TOBC(:,1,k)=cli_tn(1:ie,k)
            endif
            if (have_g_je .and. south) then
                TOBC(:,je,k)=cli_ts(1:ie,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
            CALL write_slice(OUNIT,TOBC(:,:,k))
        ENDDO

        ! S
        ! cli_sw(je,ke) cli_se(je,ke) cli_sn(ie, ke) cli_ss(ie,ke)
        ! var111
        ICODE = 111
        TOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                TOBC(1,:,k)=cli_sw(1:je,k)
            endif
            if (have_g_ie .and. east) then
                TOBC(ie,:,k)=cli_se(1:je,k)
            endif
            if (have_g_js .and. north) then
                TOBC(:,1,k)=cli_sn(1:ie,k)
            endif
            if (have_g_je .and. south) then
                TOBC(:,je,k)=cli_ss(1:ie,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
            CALL write_slice(OUNIT,TOBC(:,:,k))
        ENDDO

#ifdef OBCS_TST_NEST

    !  USOR_wb1(1:3,1:je) USOR_eb1(ie-3:ie1,je) 
        ! var122
        ICODE = 122
        KCODE = -100
        UOBC=0.0
        if (have_g_is .and. west) then
            UOBC(I_start:I_start+2,:,1)=USOR_wb1(1:3,1:je)
        endif
        if (have_g_ie .and. east) then
            UOBC(ie-3:ie1,:,1)=USOR_eb1(ie-3:ie1,1:je)
        endif
        IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
        CALL write_slice(OUNIT,UOBC(:,:,1),1)

    ! VSER_nb1(ie,1:3) VSER_sb1(ie,je-3:je1) (122)
        ! var123
        ICODE = 123
        VOBC=0.0
        if (have_g_js .and. north) then
            VOBC(:,J_start:J_start+2,1)=VSER_nb1(1:ie,1:3)
        endif
        if (have_g_je .and. south) then
            VOBC(:,je-3:je1,1)=VSER_sb1(1:ie,je-3:je1)
        endif
        IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
        CALL write_slice(OUNIT,VOBC(:,:,1),2)
#ifdef ORLANSKI    

    !  U:
    ! uko_wb1(1:3,je,ke) uko_eb1(ie-3:ie1,je,ke) uko_nb1(i_start:ie,1:3,ke) uko_sb1(i_start:ie,je2:je,ke)
        ! var132
        ICODE = 132
        UOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                UOBC(I_start:I_start+2,:,k)=uko_wb1(1:3,1:je,k)
            endif
            if (have_g_ie .and. east) then
                UOBC(ie-3:ie1,:,k)=uko_eb1(ie-3:ie1,1:je,k)
            endif
            if (have_g_js .and. north) then
                UOBC(:,1:3,k)=uko_nb1(i_start:ie,1:3,k)
            endif
            if (have_g_je .and. south) then
                UOBC(:,je2:je,k)=uko_sb1(i_start:ie,je2:je,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
            CALL write_slice(OUNIT,UOBC(:,:,k),1)
        ENDDO
    !  V: 
    ! vke_wb1(1:3,J_start:je,ke) vke_eb1(ie2:ie,J_start:je,ke) vke_nb1(ie,1:3,ke) vke_sb1(ie,je-3:je1,ke) 
        ! var133
        ICODE = 133
        VOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                VOBC(1:3,:,k)=vke_wb1(1:3,J_start:je,k)
            endif
            if (have_g_ie .and. east) then
                VOBC(ie2:ie,:,k)=vke_eb1(ie2:ie,J_start:je,k)
            endif
            if (have_g_js .and. north) then
                VOBC(:,J_start:J_start+2,k)=vke_nb1(1:ie,1:3,k)
            endif
            if (have_g_je .and. south) then
                VOBC(:,je-3:je1,k)=vke_sb1(1:ie,je-3:je1,k)
            endif  
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
            CALL write_slice(OUNIT,VOBC(:,:,k),2)
        ENDDO

#endif

#else
    ! Purely Orlanski conditionwithout TST boundary
#ifdef ORLANSKI
    !  U:
    !  uoo_wb1(0:2,je,ke) uoo_eb1(ie2:ie,je,ke) uoo_nb1(I_start:ie,1:3,ke) uoo_sb1(I_start:ie,je2:je,ke)
        ! var132
        ICODE = 132
        UOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                UOBC(I_start:I_start+2,:,k)=uoo_wb1(0:2,1:je,k)
            endif
            if (have_g_ie .and. east) then
                UOBC(ie2:ie,:,k)=uoo_eb1(ie2:ie,1:je,k)
            endif
            if (have_g_js .and. north) then
                UOBC(:,1:3,k)=uko_nb1(i_start:ie,1:3,k)
            endif
            if (have_g_je .and. south) then
                UOBC(:,je2:je,k)=uko_sb1(i_start:ie,je2:je,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMU
            CALL write_slice(OUNIT,UOBC(:,:,k),1)
        ENDDO

    ! V:
    ! voe_wb1(1:3,J_start:je,ke) voe_eb1(ie2:ie,J_start:je,ke) voe_nb1(ie,0:2,ke)  voe_sb1(ie,je2:je,ke)
        ! var133
        ICODE = 133
        VOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                VOBC(1:3,:,k)=voe_wb1(1:3,J_start:je,k)
            endif
            if (have_g_ie .and. east) then
                VOBC(ie2:ie,:,k)=voe_eb1(ie2:ie,J_start:je,k)
            endif
            if (have_g_js .and. north) then
                VOBC(:,0:2,k)=voe_nb1(1:ie,0:2,k)
            endif
            if (have_g_je .and. south) then
                VOBC(:,je2:je,k)=voe_sb1(1:ie,je2:je,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIMV
            CALL write_slice(OUNIT,VOBC(:,:,k),2)
        ENDDO

#endif
#endif

#ifdef ORLANSKI

    ! T 
    ! tho_wb1(1:3,je,ke) tho_eb1(ie2:ie,je,ke) tho_nb1(ie,1:3,ke) tho_sb1(ie,je2:je,ke)
        ! var130
        ICODE = 130
        TOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                TOBC(1:3,:,k)=tho_wb1(1:3,1:je,k)
            endif
            if (have_g_ie .and. east) then
                TOBC(ie2:ie,:,k)=tho_eb1(ie2:ie,1:je,k) 
            endif
            if (have_g_js .and. north) then
                TOBC(:,1:3,k)=tho_nb1(1:ie,1:3,k)
            endif
            if (have_g_je .and. south) then
                TOBC(:,je2:je,k)=tho_sb1(1:ie,je2:je,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
            CALL write_slice(OUNIT,TOBC(:,:,k))
        ENDDO

    ! S
    ! sao_wb1(1:3,je,ke) sao_eb1(ie2:ie,je,ke) sao_nb1(ie,1:3,ke) sao_sb1(ie,je2:je,ke)
        ICODE = 131
        TOBC=0.0
        DO K=1,KE
            if (have_g_is .and. west) then
                TOBC(1:3,:,k)=sao_wb1(1:3,1:je,k)
            endif
            if (have_g_ie .and. east) then
                TOBC(ie2:ie,:,k)=sao_eb1(ie2:ie,1:je,k)
            endif
            if (have_g_js .and. north) then
                TOBC(:,1:3,k)=sao_nb1(1:ie,1:3,k)
            endif
            if (have_g_je .and. south) then
                TOBC(:,je2:je,k)=sao_sb1(1:ie,je2:je,k)
            endif
            KCODE=TIESTU(K)
            IF(p_pe==p_io) WRITE(OUNIT) IDATE,ICODE,KCODE,IEDIM
            CALL write_slice(OUNIT,TOBC(:,:,k))
        ENDDO

#endif
          OFLAG=-OFLAG
          IF(p_pe==p_io) then
            WRITE(IO_STDOUT,*)' ++++++ AUFW_OBCS BOUNDARY WRITTEN'
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
                OFLAG=10
              ELSE
                OUNIT=IO_IN_O380
                OFLAG=-10
              ENDIF
              
              REWIND(OUNIT)
            ! var999
              READ(OUNIT) I4DATE
              READ(OUNIT) RDT
            ENDIF
            
            ! attentions 
            CALL p_bcast(OFLAG,p_io)  
            CALL p_bcast(OUNIT,p_io)
        !    ICODE Rules
        !    1(Boundary)   2(Dimension)   3(Varaibles)
        !        1             1D:  0         T: 0    LINE
        !        1             1D+K: 1        S: 1    WALL
        !        1             2D: 2          U: 2    SURFACE
        !        1             3D: 3          V: 3    VOLUME
        !       USOT(I_start:IE,JE): 63
        !       VSET(IE,J_start:JE): 64
        !              ZetaT(IE,JE): 82
        !          zeta_subT(IE,JE): 83
        ! Variables code: 999 
        !       63 64 82 83
        !       102 112 103 113 
        !       110 111 122 123
        !       132 133 130 131
 !CCC
#ifdef OBC_TIDE
      !  READ USOT(I_start:IE,JE) obc_uTNw obc_uTNe  obc_uTNs obc_uTNn
            ! var63
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT,USOT,1)
            
      !  READ VSET(IE,J_start:JE)
            ! var64
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT,VSET,2)
      
      !  READ ZetaT(IE,JE)
            ! var82
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, ZetaT)
#endif
#ifdef OBC_SUBTIDE
      !  READ zeta_subT(IE,JE)
            ! var83
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, zeta_subT)
#endif
  !
#ifdef OBCS_TST_NEST
        ! :: UPDATE TST OBCS VALUES AT THE FORMER STEP
            CALL OBCS_TST_FIRST
            WRITE(IO_STDOUT,*)' ++++++ OBCS_TST_FIRST BOUNDARY RESTART'
#endif
  !
            !  var102
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, UOBC(:,:,1),1)
            !
            if (have_g_is .and. west) then
                obc_ubarw(1:je)=UOBC(I_start,:,1)
            endif
            if (have_g_ie .and. east) then
                obc_ubare(1:je)=UOBC(ie,:,1)
            endif
            if (have_g_js .and. north) then
                obc_ubarn(I_start:ie)=UOBC(:,1,1)
            endif
            if (have_g_je .and. south) then
                obc_ubars(I_start:ie)=UOBC(:,je,1)
            endif
  
        !  var112
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, UOBC(:,:,K),1)
            !  var112
            if (have_g_is .and. west) then
                obcf_uw(1:je,k)=UOBC(I_start,:,k)
            endif
            if (have_g_ie .and. east) then
                obcf_ue(1:je,k)=UOBC(ie,:,k)
            endif
            if (have_g_js .and. north) then
                obcf_un(I_start:ie,k)=UOBC(:,1,k)
            endif
            if (have_g_je .and. south) then
                obcf_us(I_start:ie,k)=UOBC(:,je,k)
            endif
        ENDDO
  
        !  var103
        IF(p_pe==p_io) READ(OUNIT) I4DATE
        CALL read_slice(OUNIT, VOBC(:,:,1),2)
        if (have_g_is .and. west) then
            obc_vbarw(J_start:je)=VOBC(1,:,1)
        endif
        if (have_g_ie .and. east) then
            obc_vbare(J_start:je)=VOBC(ie,:,1)
        endif
        if (have_g_js .and. north) then
            obc_vbarn(1:ie)=VOBC(:,J_start,1)
        endif
        if (have_g_je .and. south) then
            obc_vbars(1:ie)=VOBC(:,je,1)
        endif
  
        !  var113
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, VOBC(:,:,K),2)
            if (have_g_is .and. west) then
                obcf_vw(J_start:je,k)=VOBC(1,:,k)
            endif
            if (have_g_ie .and. east) then
                obcf_ve(J_start:je,k)=VOBC(ie,:,k)
            endif
            if (have_g_js .and. north) then
                obcf_vn(1:ie,k)=VOBC(:,J_start,k)
            endif
            if (have_g_je .and. south) then
                obcf_vs(1:ie,k)=VOBC(:,je,k)
            endif
        ENDDO
  
        ! var110
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, TOBC(:,:,K))
            if (have_g_is .and. west) then
                cli_tw(1:je,k)=TOBC(1,:,k)
            endif
            if (have_g_ie .and. east) then
                cli_te(1:je,k)=TOBC(ie,:,k)
            endif
            if (have_g_js .and. north) then
                cli_tn(1:ie,k)=TOBC(:,1,k)
            endif
            if (have_g_je .and. south) then
                cli_ts(1:ie,k)=TOBC(:,je,k)
            endif
        ENDDO
  
        ! var111
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, TOBC(:,:,K))
            if (have_g_is .and. west) then
                cli_sw(1:je,k)=TOBC(1,:,k)
            endif
            if (have_g_ie .and. east) then
                cli_se(1:je,k)=TOBC(ie,:,k)
            endif
            if (have_g_js .and. north) then
                cli_sn(1:ie,k)=TOBC(:,1,k)
            endif
            if (have_g_je .and. south) then
                cli_ss(1:ie,k)=TOBC(:,je,k)
            endif
        ENDDO
  
#ifdef OBCS_TST_NEST
        ! var122    
        IF(p_pe==p_io) READ(OUNIT) I4DATE
        CALL read_slice(OUNIT, UOBC(:,:,1),1)
        if (have_g_is .and. west) then
            USOR_wb1(1:3,1:je)=UOBC(I_start:I_start+2,:,1)
        endif
        if (have_g_ie .and. east) then
            USOR_eb1(ie-3:ie1,1:je)=UOBC(ie-3:ie1,:,1)
        endif
        ! var123
        IF(p_pe==p_io) READ(OUNIT) I4DATE
        CALL read_slice(OUNIT, VOBC(:,:,1),2)
        if (have_g_js .and. north) then
            VSER_nb1(1:ie,1:3)=VOBC(:,J_start:J_start+2,1)
        endif
        if (have_g_je .and. south) then
            VSER_sb1(1:ie,je-3:je1)=VOBC(:,je-3:je1,1)
        endif
  
#ifdef ORLANSKI   
        ! var132
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, UOBC(:,:,K),1)
            if (have_g_is .and. west) then
                uko_wb1(1:3,1:je,k)=UOBC(I_start:I_start+2,:,k)
            endif
            if (have_g_ie .and. east) then
                uko_eb1(ie-3:ie1,1:je,k)=UOBC(ie-3:ie1,:,k)
            endif
            if (have_g_js .and. north) then
                uko_nb1(i_start:ie,1:3,k)=UOBC(:,1:3,k)
            endif
            if (have_g_je .and. south) then
                uko_sb1(i_start:ie,je2:je,k)=UOBC(:,je2:je,k)
            endif
        ENDDO

        ! var133
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, VOBC(:,:,K),2)
            if (have_g_is .and. west) then
                vke_wb1(1:3,J_start:je,k)=VOBC(1:3,:,k)
            endif
            if (have_g_ie .and. east) then
                vke_eb1(ie2:ie,J_start:je,k)=VOBC(ie2:ie,:,k)
            endif
            if (have_g_js .and. north) then
                vke_nb1(1:ie,1:3,k)=VOBC(:,J_start:J_start+2,k)
            endif
            if (have_g_je .and. south) then
                vke_sb1(1:ie,je-3:je1,k)=VOBC(:,je-3:je1,k)
            endif
        ENDDO
#endif
#else
      ! Purely Orlanski conditionwithout TST boundary
#ifdef ORLANSKI
        ! var132
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, UOBC(:,:,K),1)
            if (have_g_is .and. west) then
                uoo_wb1(0:2,1:je,k)=UOBC(I_start:I_start+2,:,k)
            endif
            if (have_g_ie .and. east) then
                uoo_eb1(ie2:ie,1:je,k)=UOBC(ie2:ie,:,k)
            endif
            if (have_g_js .and. north) then
                uoo_nb1(i_start:ie,1:3,k)=UOBC(:,1:3,k)
            endif
            if (have_g_je .and. south) then
                uoo_sb1(i_start:ie,je2:je,k)=UOBC(:,je2:je,k)
            endif
        ENDDO
    
        ! var133
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, VOBC(:,:,K),2)
            if (have_g_is .and. west) then
                voe_wb1(1:3,J_start:je,k)=VOBC(1:3,:,k)
            endif
            if (have_g_ie .and. east) then
                voe_eb1(ie2:ie,J_start:je,k)=VOBC(ie2:ie,:,k)
            endif
            if (have_g_js .and. north) then
                voe_nb1(1:ie,0:2,k)=VOBC(:,0:2,k)
            endif
            if (have_g_je .and. south) then
                voe_sb1(1:ie,je2:je,k)=VOBC(:,je2:je,k)
            endif
        ENDDO
  
#endif
#endif
  
#ifdef ORLANSKI
        ! var130
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, TOBC(:,:,K))
            if (have_g_is .and. west) then
                tho_wb1(1:3,1:je,k)=TOBC(1:3,:,k)
            endif
            if (have_g_ie .and. east) then
                tho_eb1(ie2:ie,1:je,k)=TOBC(ie2:ie,:,k)
            endif
            if (have_g_js .and. north) then
                tho_nb1(1:ie,1:3,k)=TOBC(:,1:3,k)
            endif
            if (have_g_je .and. south) then
                tho_sb1(1:ie,je2:je,k)=TOBC(:,je2:je,k)
            endif
        ENDDO
    
    
        ! var131
        DO K=1,KE
            IF(p_pe==p_io) READ(OUNIT) I4DATE
            CALL read_slice(OUNIT, TOBC(:,:,K))
            if (have_g_is .and. west) then
                sao_wb1(1:3,1:je,k)=TOBC(1:3,:,k)
            endif
            if (have_g_ie .and. east) then
                sao_eb1(ie2:ie,1:je,k)=TOBC(ie2:ie,:,k)
            endif
            if (have_g_js .and. north) then
                sao_nb1(1:ie,1:3,k)=TOBC(:,1:3,k)
            endif
            if (have_g_je .and. south) then
                sao_sb1(1:ie,je2:je,k)=TOBC(:,je2:je,k)
            endif
        ENDDO
  
#endif
      
        IF(p_pe==p_io) THEN
            WRITE(IO_STDOUT,*)' ++++++ AUFR_OBCS BOUNDARY READ'
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
        
#endif
        ENDIF
#endif
      END SUBROUTINE OBCS_TST_FIRST 

#endif
     END MODULE MO_OBCS_RESTART



      
      
