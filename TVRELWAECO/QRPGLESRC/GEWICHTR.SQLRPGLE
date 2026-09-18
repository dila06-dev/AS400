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

     fgewicht   up   e           k disk    RENAME(gewicht:phy01r)
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
     c                   if        protokoll = *blank
     c********           if        artikel = '000000059000216'   or
     c********                     artikel = '000000600340734'   or
     c********                     artikel = '000000000000000'   or
     c********                     artikel = '000009103303387'   or
     c********                     artikel = '000009108554742'   or
     c********                     artikel = '000009108552898'
     c                   exsr      srartikel
     c                   exsr      SR5850
     c                   if        PAPPE_GR  > 0 or
     c                             KUNST_GR  > 0 or
     c                             HOLZ_GR   > 0
     c                   exsr      SR5860
     c                   exsr      SR5890
     c                   endif
     c                   exsr      sr9000
     c                   eval      protokoll    =  '1'
     c                   eval      TIME_RELEA   =  tstampi
     c                   eval      DATE_RELEA   =  datum
     c                   update    phy01r
     c                   endif
     c*********          endif

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
     c                   movel     artikel#      TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #6#               8 0
     C                   clear                   TEOSMM01
     C                   clear                   TEOSMM02
     C                   clear                   TEOSMM03
     C                   clear                   TEOSMM04
     c     KEY5850       chain     TEOS01
     c                   eval      #1# = laenge  *10
     c                   move      #1#           TEOSMM01
     c     ' ':'0'       xlate     TEOSMM01      TEOSMM01
     c                   eval      #2# = breite  *10
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   eval      #3# = hoehe  *10
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   eval      #6# = BRUTTO_KG  *1000
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
     C     ##5850        ENDSR
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
     c                   movel     artikel#      TEOSTENR
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
     c                   movel     artikel#      TEOSTENR
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
     c                   eval      br = BRUTTO_KG *1
     c                   z-add     br            tegwbr
     c*                  Umrechnung auf von dm³ auf m³
     c                   eval      vol = VOLUMEN  /1000
     c                   z-add     vol           TEVOLU
     c                   if        tevolu = *zero
     c                   z-add     0,0001        TEVOLU
     c                   endif
     c                   IF        %found(TEIL00)
     c                   update    teil1
     c                   else
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C**************************************************************************
     C* SRartikel lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SRartikel     BEGSR
     C*
     C                   clear                   artikel#
     C                   select
     C                   when      PROTOKOLLA  = '1'
     C                   movel     artikel       artikel#         15
     C                   when      PROTOKOLLA  = '2'
     C                   eval      artikel# = %subst(artikel: 2: 14)
     C                   when      PROTOKOLLA  = '3'
     C                   eval      artikel# = %subst(artikel: 3: 13)
     C                   when      PROTOKOLLA  = '4'
     C                   eval      artikel# = %subst(artikel: 4: 12)
     C                   when      PROTOKOLLA  = '5'
     C                   eval      artikel# = %subst(artikel: 5: 11)
     C                   when      PROTOKOLLA  = '6'
     C                   eval      artikel# = %subst(artikel: 6: 10)
     C                   when      PROTOKOLLA  = '7'
     C                   eval      artikel# = %subst(artikel: 7: 09)
     C                   when      PROTOKOLLA  = '8'
     C                   eval      artikel# = %subst(artikel: 8: 08)
     C                   when      PROTOKOLLA  = '9'
     C                   eval      artikel# = %subst(artikel: 9: 07)
     C                   when      PROTOKOLLA  = 'A'
     C                   eval      artikel# = %subst(artikel:10: 06)
     C                   when      PROTOKOLLA  = 'B'
     C                   eval      artikel# = %subst(artikel:11: 05)
     C                   when      PROTOKOLLA  = 'C'
     C                   eval      artikel# = %subst(artikel:12: 04)
     C                   when      PROTOKOLLA  = 'D'
     C                   eval      artikel# = %subst(artikel:13: 03)
     c                   ENDsl                                                  %found(WAECOLCP)
     C*
     C     ##artikel     ENDSR
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
