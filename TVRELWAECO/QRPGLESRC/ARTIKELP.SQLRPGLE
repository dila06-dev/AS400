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

     fsbgart00  up   e           k disk
     f#PREIL1   uf a e           k disk

     DDate             S               D   DATFMT(*EUR)
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
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*                 update prei
     c     key001        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA

     C                   movel     art010        prfirm
     C                   movel     'PR2'         prbegr
     C                   movel     art030        prtenr
     C                   movel     'EUR'         prwacd
     c                   movel     ART300        jj                2 0
     c                   movel     ART300        jjmm              4 0
     c                   move      ART300        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif

     c     key001        chain     #PREIL1                            93
     C   93              clear                   prei1
     C                   movel     art010        prfirm
     C                   movel     'PR2'         prbegr
     C                   movel     art030        prtenr
     C                   movel     'EUR'         prwacd
     C                   z-add     art290        prezpr
     c                   movel     ART300        jj                2 0
     c                   movel     ART300        jjmm              4 0
     c                   move      ART300        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     C                   movel     '1'           prpdvk
     C                   movel     'S'           prmepr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     '1'           prpdvk
     C                   movel     'S'           prmepr
     C   93              write     prei1
     C  n93              update    prei1

     C                   if        art310    > *zero
     C                   movel     art010        prfirm
     C                   movel     'PR2'         prbegr
     C                   movel     art030        prtenr
     C                   movel     'EUR'         prwacd
     c                   movel     ART320        jj                2 0
     c                   movel     ART320        jjmm              4 0
     c                   move      ART320        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c     key001        chain     #PREIL1                            93
     C   93              clear                   prei1
     C                   movel     art010        prfirm
     C                   movel     'PR2'         prbegr
     C                   movel     art030        prtenr
     C                   movel     'EUR'         prwacd
     C                   z-add     art310        prezpr
     c                   movel     ART320        jj                2 0
     c                   movel     ART320        jjmm              4 0
     c                   move      ART320        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     C                   movel     '1'           prpdvk
     C                   movel     'S'           prmepr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     '1'           prpdvk
     C                   movel     'S'           prmepr
     C   93              write     prei1
     C  n93              update    prei1

     C                   endif


     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
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
