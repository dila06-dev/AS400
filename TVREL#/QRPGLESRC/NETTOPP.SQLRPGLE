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

     fsbgprs00  up   e           k disk
     f#PREIL2   uf a e           k disk
     f#PREIL3   uf a e           k disk    RENAME(prei1:phy02r)

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

     c                   if        %subst(prs020:3:3) <> 'XXX'
     C*                 update prei
     c     key001        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLI
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA

     C                   movel     prs010        PRFIRM
     C                   movel     'PR1'         PRBEGR
     C                   move      prs020        #prs020           6
     C                   movel     '0'           #prs020           6
     c                   movel     #prs020       PRKDLI
     C                   movel     prs040        PRTENR
     C                   if        prs060 = 99 or prs060 = 00
     C                   movel     'EUR'         PRWACD
     C                   endif
     C                   if        prs060 = 09
     C                   movel     'USD'         PRWACD
     C                   endif

     c                   move      prs070        jj                2 0
     c                   movel     prs070        jjmm              4 0
     c                   movel     prs070        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      prs120        jj                2 0
     c                   movel     prs120        jjmm              4 0
     c                   movel     prs120        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgada
     c                   endif

     c     key001        chain     #PREIL2                            93
     C   93              clear                   prei1
     C                   movel     prs010        PRFIRM
     C                   movel     'PR1'         PRBEGR
     C                   move      prs020        #prs020           6
     C                   movel     '0'           #prs020           6
     c                   movel     #prs020       PRKDLI
     C                   movel     prs040        PRTENR
     C                   if        prs060 = 99 or prs060 = 00
     C                   movel     'EUR'         PRWACD
     C                   endif
     C                   if        prs060 = 09
     C                   movel     'USD'         PRWACD
     C                   endif

     c                   move      prs070        jj                2 0
     c                   movel     prs070        jjmm              4 0
     c                   movel     prs070        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      prs120        jj                2 0
     c                   movel     prs120        jjmm              4 0
     c                   movel     prs120        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     C                   z-add     prs050        prezpr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C   93              write     prei1
     C  n93              update    prei1
     C                   endif




     c                   if        %subst(prs020:3:3) =  'XXX'
     C*                 update prei
     c     key002        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLG
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA

     C                   movel     prs010        PRFIRM
     C                   movel     'PR4'         PRBEGR
     C                   move      prs020        #prs020           6
     C                   movel     '0'           #prs020           6
     C                   move      '   '         #prs020           6
     c                   movel     #prs020       PRKDLG
     C                   movel     prs040        PRTENR
     C                   if        prs060 = 99 or prs060 = 00
     C                   movel     'EUR'         PRWACD
     C                   endif
     C                   if        prs060 = 09
     C                   movel     'USD'         PRWACD
     C                   endif

     c                   move      prs070        jj                2 0
     c                   movel     prs070        jjmm              4 0
     c                   movel     prs070        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      prs120        jj                2 0
     c                   movel     prs120        jjmm              4 0
     c                   movel     prs120        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgada
     c                   endif

     c     key002        chain     #PREIL3                            93
     C   93              clear                   phy02r
     C                   movel     prs010        PRFIRM
     C                   movel     'PR4'         PRBEGR
     C                   move      prs020        #prs020           6
     C                   movel     '0'           #prs020           6
     C                   move      '   '         #prs020           6
     c                   movel     #prs020       PRKDLG
     C                   movel     prs040        PRTENR
     C                   if        prs060 = 99 or prs060 = 00
     C                   movel     'EUR'         PRWACD
     C                   endif
     C                   if        prs060 = 09
     C                   movel     'USD'         PRWACD
     C                   endif

     c                   move      prs070        jj                2 0
     c                   movel     prs070        jjmm              4 0
     c                   movel     prs070        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c                   move      prs120        jj                2 0
     c                   movel     prs120        jjmm              4 0
     c                   movel     prs120        tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgbda=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgbda   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     C                   z-add     prs050        prezpr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C   93              write     phy02r
     C  n93              update    phy02r
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
