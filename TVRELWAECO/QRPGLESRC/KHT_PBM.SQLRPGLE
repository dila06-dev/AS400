     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * directory/object:
      * G:\Abteilungen\Prozess-Controlling EDC\KHT_PBM
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  option(*SRCSTMT:*NoDebugIO)

     fKHT_PBM   up   e           k disk    RENAME(KHT_PBMr:phy01r)
     fteos01    uf a e           k disk
     flbpm01    uf a e           k disk
     fTEIL00    uf   e           k disk

     D*Date             S               D   DATFMT(*EUR)
     DDate             S               D   DATFMT(*iso)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

      *                 ...                                                   
     c                   seton                                        25
     c                   if        status    = *blank  or
     c                             status    =
     c                             'error in command appeared: '+
     c                             'CPYFRMIMPF'
      *                 kl,Einheit                                            
     c                   if        H4        = *blank   and
     c                             UNITVPE   = 'kl,Einheit'
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     '
     c                   exsr      SR5850
     c                   clear                   PAPPE_GR         12 4
     c                   clear                   KUNST_GR         12 4
     c                   clear                   HOLZ_GR          12 4
     c                   if        PAPPE_GR  > 0 or
     c                             KUNST_GR  > 0 or
     c                             HOLZ_GR   > 0
     c                   exsr      SR5860
     c                   exsr      SR5890
     c                   endif
     c                   exsr      sr9000
     c                   eval      H4           =  '1'
     c                   eval      h6           =  tstampi
     c                   eval      h5           =  datum
     c                   update    phy01r
     c                   endif
     c                   endif
      *                 Palette                                               
     c                   if        H4        = *blank   and
     c                             UNITVPE   = 'Palette   '
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     '
     c                   exsr      SRPalette
     c                   exsr      sr9000
     c                   eval      H4           =   %subst(h4:01:01) + '2'
     c                   eval      h6           =  tstampi
     c                   eval      h5           =  datum
     c                   update    phy01r
     c                   endif
     c                   endif
      *                 VPE2                                                  
     c                   if        H4        = *blank   and
     c                             UNITVPE   = 'VPE2      '
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     '
     c                   exsr      SRVPE2
     c                   exsr      sr9000
     c                   eval      H4           =   %subst(h4:01:01) + '2'
     c                   eval      h6           =  tstampi
     c                   eval      h5           =  datum
     c                   update    phy01r
     c                   endif
     c                   endif
      *                 VPE                                                   
     c                   if        H4        = *blank   and
     c                             UNITVPE   = 'VPE       '
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     '
     c                   exsr      SR5865
     c                   exsr      sr9000
     c                   eval      H4           =   %subst(h4:01:01) + '2'
     c                   eval      h6           =  tstampi
     c                   eval      h5           =  datum
     c                   update    phy01r
     c                   endif
     c                   endif
     c                   endif

     c
     C**************************************************************************
     C* SR5850: TEOS01 1000
     C*-------------------------------------------------------------------------
     C*
     C     SR5850        BEGSR
     C*
     c     KEY5850       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '1000'        TEOSKLCD
     c                   movel     item          TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #6#               8 0
     c     KEY5850       chain     TEOS01
     c                   if        LENGTH  >   0
     C                   clear                   TEOSMM01
     c                   eval      #1# = LENGTH  *10
     c                   move      #1#           TEOSMM01
     c     ' ':'0'       xlate     TEOSMM01      TEOSMM01
     c                   endif
     c                   if        WIDTH   >   0
     C                   clear                   TEOSMM02
     c                   eval      #2# = WIDTH   *10
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   endif
     c                   if        HEIGHT  >   0
     C                   clear                   TEOSMM03
     c                   eval      #3# = HEIGHT *10
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   endif
     c                   if        CROSS_W >   0
     C                   clear                   TEOSMM04
     c                   eval      #6# = CROSS_W    *1000
     c                   move      #6#           TEOSMM04
     c     ' ':'0'       xlate     TEOSMM04      TEOSMM04
     c                   endif
     C                   movel     §§§usr        teosuser
     C                   movel     §§§pgm        teosPROG
     C                   movel     §§§job        teosjnam
     C                   movel     §§§LIB        teosbibl
     c                   movel     date          teosJDAT
     c                   movel     zeit          teosJZEI
     c                   IF        %found(TEOS01)
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5850        ENDSR
     C*
     C**************************************************************************
     C* SR5865: TEOS01 1000
     C*-------------------------------------------------------------------------
     C*
     C     SR5865        BEGSR
     C*
     c     KEY5865       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '1000'        TEOSKLCD
     c                   movel     item          TEOSTENR
     C*
     C                   clear                   #5#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   #7#               8 0
     C                   clear                   #8#               8 0
     C                   clear                   #9#               8 0
     c     KEY5865       chain     TEOS01
     C                   if        LENGTH  > 0
     C                   clear                   TEOSMM05
     c                   eval      #5# = LENGTH  *10
     c                   move      #5#           TEOSMM05
     c     ' ':'0'       xlate     TEOSMM05      TEOSMM05
     c                   endif
     C                   if        WIDTH   > 0
     C                   clear                   TEOSMM06
     c                   eval      #6# = WIDTH   *10
     c                   move      #6#           TEOSMM06
     c     ' ':'0'       xlate     TEOSMM06      TEOSMM06
     c                   endif
     C                   if        HEIGHT  > 0
     C                   clear                   TEOSMM07
     c                   eval      #7# = HEIGHT *10
     c                   move      #7#           TEOSMM07
     c     ' ':'0'       xlate     TEOSMM07      TEOSMM07
     c                   endif
     C                   if        CROSS_W > 0
     C                   clear                   TEOSMM08
     c                   eval      #8# = CROSS_W    *1000
     c                   move      #8#           TEOSMM08
     c     ' ':'0'       xlate     TEOSMM08      TEOSMM08
     c                   endif
     C                   if        QUANTVPE > 0
     C                   clear                   TEOSMM09
     c                   eval      #9# = QUANTVPE   *1
     c                   move      #9#           TEOSMM09
     c     ' ':'0'       xlate     TEOSMM09      TEOSMM09
     c                   endif
     C                   movel     §§§usr        teosuser
     C                   movel     §§§pgm        teosPROG
     C                   movel     §§§job        teosjnam
     C                   movel     §§§LIB        teosbibl
     c                   movel     date          teosJDAT
     c                   movel     zeit          teosJZEI
     c                   IF        %found(TEOS01)
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5865        ENDSR
     C*
     C**************************************************************************
     C* SR5860: TEOS01   4000
     C*-------------------------------------------------------------------------
     C*
     C     SR5860        BEGSR
     C*
     c     KEY5860       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '4000'        TEOSKLCD
     c                   movel     item          TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   TEOSMM01
     C                   clear                   TEOSMM02
     C                   clear                   TEOSMM03
     C                   clear                   TEOSMM04
     c     KEY5860       chain     TEOS01
     c                   movel     'J'           TEOSMM01
     c                   eval      #2# = PAPPE_GR *1
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   eval      #3# = KUNST_GR *1
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     C                   movel     §§§usr        teosuser
     C                   movel     §§§pgm        teosPROG
     C                   movel     §§§job        teosjnam
     C                   movel     §§§LIB        teosbibl
     c                   movel     date          teosJDAT
     c                   movel     zeit          teosJZEI
     c                   IF        %found(TEOS01)
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5860        ENDSR
     C*
     C**************************************************************************
     C* SR5890: TEOS01   4030
     C*-------------------------------------------------------------------------
     C*
     C     SR5890        BEGSR
     C*
     c     KEY5890       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '4030'        TEOSKLCD
     c                   movel     item          TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   TEOSMM01
     C                   clear                   TEOSMM02
     C                   clear                   TEOSMM03
     C                   clear                   TEOSMM04
     c     KEY5890       chain     TEOS01
     c                   movel     'J'           TEOSMM01
     c                   eval      #2# = PAPPE_GR *1
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   eval      #3# = KUNST_GR *1
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   eval      #6# = HOLZ_GR  *1
     c                   move      #6#           TEOSMM04
     c     ' ':'0'       xlate     TEOSMM04      TEOSMM04
     C                   movel     §§§usr        teosuser
     C                   movel     §§§pgm        teosPROG
     C                   movel     §§§job        teosjnam
     C                   movel     §§§LIB        teosbibl
     c                   movel     date          teosJDAT
     c                   movel     zeit          teosJZEI
     c                   IF        %found(TEOS01)
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5890        ENDSR
     C*
     C**************************************************************************
     C* SR9000: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9000        BEGSR
     C*
     c     teilkey       klist
     c                   kfld                    firma             2
     c                   kfld                    TETENR
     c                   clear                   firma
     c                   clear                   TETENR
     c                   movel     '01'          firma
     c                   movel     item          tetenr
     C*
     c                   clear                   br                9 4
     c                   clear                   vol              11 4
     c                   clear                   updteil           1
     c     teilkey       chain     TEIL1
     C                   movel     §§§usr        teuser
     C                   movel     §§§pgm        tePROG
     C                   movel     §§§job        tejnam
     C                   movel     §§§LIB        tebibl
     c                   movel     date          teJDAT
     c                   movel     zeit          teJZEI
     c                   if        CROSS_W   >   0
     c                   eval      br = CROSS_W   *1
     c                   z-add     br            tegwbr
     c                   endif
     c*                  Umrechnung auf von dm³ auf m³
     c                   if        VOLUME    >   0
     c                   eval      vol = VOLUME   /1000
     c                   eval      updteil  = '1'
     c                   z-add     vol           TEVOLU
     c                   endif
     c                   if        tevolu = *zero
     c                   z-add     0,0001        TEVOLU
     c                   eval      updteil  = '1'
     c                   endif
     c                   if        EAN    <> *blank
     c                   eval      TEEANR   =    EAN
     c                   eval      updteil  = '1'
     c                   endif
     c                   IF        %found(TEIL00) and updteil='1'
     c                   update    teil1
     c                   else
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C**************************************************************************
     C* SRPalette: Palette
     C*-------------------------------------------------------------------------
     C*
     C     SRPalette     BEGSR
     C*
     c     KEYLBPM       klist
     c                   kfld                    LBPMFIRM
     c                   kfld                    LBPMTENR
     c                   kfld                    LBPMVPMI
     C*
     C                   movel     '01'          LBPMFIRM
     c                   movel     item          LBPMTENR
     c                   clear                   LBPMVPMI
     c                   movel     '3'           LBPMVPMI
     C*
     c     KEYLBPM       chain     LBPM01
     c                   clear                   LBPMVPMI
     c                   movel     '3'           LBPMVPMI
     c                   eval      LBPMAZME  =   QUANTVPE
     c***?????           eval      LBPMLDMS
     c                   if        CROSS_W  > 0
     c                   eval      LBPMGWBR  =   CROSS_W
     c                   endif
     c                   if        LENGTH   > 0
     c                   eval      LBPMLDLA  =   LENGTH
     c                   endif
     c                   if        WIDTH    > 0
     c                   eval      LBPMLDBR  =   WIDTH
     c                   endif
     c                   if        HEIGHT   > 0
     c                   eval      LBPMLDHO  =   HEIGHT
     c                   endif
     C                   movel     tstampi       LBPMTSTP
     C                   movel     §§§usr        LBPMuser
     C                   movel     §§§pgm        LBPMPROG
     C                   movel     §§§job        LBPMjnam
     C                   movel     §§§LIB        LBPMbibl
     c                   movel     date          LBPMJDAT
     c                   movel     zeit          LBPMJZEI
     c                   IF        %found(LBPM01)
     c                   update    LBPM1
     c                   else
     c                   write     LBPM1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##Palette     ENDSR
     C*
     C**************************************************************************
     C* SRVPE2:    LBPM01
     C*-------------------------------------------------------------------------
     C*
     C     SRVPE2        BEGSR
     C*
     C                   movel     '01'          LBPMFIRM
     c                   movel     item          LBPMTENR
     c                   clear                   LBPMVPMI
     c                   movel     '3'           LBPMVPMI
     C*
     c     KEYLBPM       chain     LBPM01
     c                   clear                   LBPMVPMI
     c                   movel     '3'           LBPMVPMI
     c                   eval      LBPMAZM2  =   QUANTVPE
     c***?????           eval      LBPMLDM2
     c                   if        CROSS_W  > 0
     c                   eval      LBPMGWB2  =   CROSS_W
     c                   endif
     c                   if        LENGTH   > 0
     c                   eval      LBPMLDL2  =   LENGTH
     c                   endif
     c                   if        WIDTH    > 0
     c                   eval      LBPMLDB2  =   WIDTH
     c                   endif
     c                   if        HEIGHT   > 0
     c                   eval      LBPMLDH2  =   HEIGHT
     c                   endif
     C                   movel     tstampi       LBPMTSTP
     C                   movel     §§§usr        LBPMuser
     C                   movel     §§§pgm        LBPMPROG
     C                   movel     §§§job        LBPMjnam
     C                   movel     §§§LIB        LBPMbibl
     c                   movel     date          LBPMJDAT
     c                   movel     zeit          LBPMJZEI
     c                   IF        %found(LBPM01)
     c                   update    LBPM1
     c                   else
     c                   write     LBPM1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##VPE2        ENDSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     C                   setoff                                       20
     C                   clear                   error             1
     C                   clear                   xpos              3 0

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR

     c                   exsr      sr9999

     c                   clear                   Wrk.var1
     c                   clear                   status          132
      *
      /free
       MONITOR;
       Wrk.var1 =
           'call (TVRELWAECO/#LIBLIST) ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared TVRELWAECO/#LIBLIST     ';
          exsr      SR_log;
       endmon;
      /End-Free

      *
      /free
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/KHT_PBMIN) ' +
           'TOFILE(TVRELWAECO/KHT_PBM) MBROPT(*ADD) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(2) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;
      /End-Free

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR

     C                   ENDSR

     C**************************************************************************
     C*log report
     C*-------------------------------------------------------------------------
     C*
     C     sr_log        BEGSR

     C                   clear                   md
     C                   movea(p)  'KHT_PBM   '  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  status        md(033)
     C*                  MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md

     C     ##_log        ENDSR
     C**************************************************************************
