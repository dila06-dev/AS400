     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fumwelt    up   e           k disk    RENAME(umweltt:phy01r)
     fteos01    uf a e           k disk
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

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

      *                 ...                                                   
     c  n25              exsr      sr9999
     c                   seton                                        25
     c********           if        artikel = '290-0001272    '   or
     c********                     artikel = 'RV-590         '   or
     c********                     artikel = 'C4023000D001   '
     c********                     artikel = '               '   or
     c********                     artikel = '000009108554742'   or
     c********                     artikel = '000009108552898'
     C                   clear                   artikel#
     C                   movel     artikel       artikel#         15
     c                   if        PAPPE_GR  > 0 or
     c                             KUNST_GR  > 0 or
     c                             HOLZ_GR   > 0
     c                   exsr      SR5860
     c                   exsr      SR5890
     c                   endif
     c                   if        ELEKTRO_GR > 0
     c                   exsr      SR5870
     c                   endif
     c                   if        ( BATTERIE  <> '0' and
     c                               BATTERIE  <> *blank) or
     c                             BATT_ANZ  > 0       or
     c                             BATT_GR   > 0
     c                   exsr      SR5880
     c                   endif
     c*********          exsr      sr9000
     c                   eval      protokoll    =  '1'
     c                   eval      TIME_RELEA   =  tstampi
     c                   eval      DATE_RELEA   =  datum
     c                   update    phy01r
     c********           endif

     c
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
     c                   movel     artikel#      TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #4#               8 0
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
     C* SR5870: TEOS01   4010
     C*-------------------------------------------------------------------------
     C*
     C     SR5870        BEGSR
     C*
     c     KEY5870       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '4010'        TEOSKLCD
     c                   movel     artikel#      TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #4#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   TEOSMM01
     C                   clear                   TEOSMM02
     C                   clear                   TEOSMM03
     C                   clear                   TEOSMM04
     c     KEY5870       chain     TEOS01
     c                   movel     'J'           TEOSMM01
     c                   eval      #2# = ELEKTRO_GR *1
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
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
     C     ##5870        ENDSR
     C*
     C**************************************************************************
     C* SR5880: TEOS01   4020
     C*-------------------------------------------------------------------------
     C*
     C     SR5880        BEGSR
     C*
     c     KEY5880       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '4020'        TEOSKLCD
     c                   movel     artikel#      TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #4#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   TEOSMM01
     C                   clear                   TEOSMM02
     C                   clear                   TEOSMM03
     C                   clear                   TEOSMM04
     c     KEY5880       chain     TEOS01
     c                   movel     'J'           TEOSMM01
     c                   movel     BATTERIE      TEOSMM02
     c                   eval      #3# = BATT_ANZ *1
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   eval      #4# = BATT_GR  *1
     c                   move      #4#           TEOSMM04
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
     C     ##5880        ENDSR
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
     c                   movel     artikel#      TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #4#               8 0
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
     c                   movel     artikel#      tetenr
     C*
     c                   clear                   br                9 4
     c                   clear                   vol              11 4
     c     teilkey       chain     TEIL1
     C                   movel     §§§usr        teuser
     C                   movel     §§§pgm        tePROG
     C                   movel     §§§job        tejnam
     C                   movel     §§§LIB        tebibl
     c                   movel     date          teJDAT
     c                   movel     zeit          teJZEI
     c                   IF        %found(TEIL00)
     c                   update    teil1
     c                   else
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C**************************************************************************
     C* SR9999:
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
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
