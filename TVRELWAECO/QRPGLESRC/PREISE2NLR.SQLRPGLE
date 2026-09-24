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

     fa_preis   up   e           k disk
     f#PREIL3   uf a e           k disk    RENAME(prei1:phy01r)

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
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*                 update prei
     c     key001        klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c                   kfld                    PRGADA

     C                   movel     '52'          #prs010
     c                   exsr      sr1500

     c     key001        chain     #PREIL3                            93
     C   93              clear                   phy01r

     c                   exsr      sr1500

     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     C   93              write     phy01r
     C  n93              update    phy01r

     c   93              movel     'W'           #MODUS
     c  n93              movel     'U'           #MODUS
     c                   move      prJDAT        #GEBUCHT



     C*                  movel     '08'          #prs010
     c*                  exsr      sr1500

     c*    key001        chain     #PREIL3                            93
     C*  93              clear                   phy01r

     c*                  exsr      sr1500

     C*                  movel     §§§usr        pruser
     C*                  movel     §§§pgm        prPROG
     C*                  movel     §§§job        prjnam
     C*                  movel     §§§LIB        prbibl
     C*  93              write     phy01r
     C* n93              update    phy01r


     C**************************************************************************
     C*fill in
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR

     C                   movel     #prs010       PRFIRM
     C                   movel     'PVK'         PRBEGR
     C                   movel     #prs040       PRTENR
     C                   movel     'EUR'         PRWACD

     c                   move      #prs070       jj                2 0
     c                   movel     #prs070       jjmm              4 0
     c                   movel     #prs070       tt                2 0
     c                   move      jjmm          mm                2 0
     c                   eval      prgada=(20000000+(jj*10000)+(mm*100)+tt)
     c                   if        prgada   > 20500000
     c                   movel     '19'          prgada
     c                   endif
     c
     c                   movel     date          prJDAT
     c                   if        prgada <      prjdat
     c                   movel     date          prgada
     c                   endif
     c
     C                   z-add     #prs050       prezpr
     C                   Movel     '1'           prpdvk
     C                   Movel     'S'           prmepr
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     c                   movel     date          prJDAT
     c                   movel     zeit          prJZEI
     c                   movel     tstampi       PRTSTP

     C     ##1500        ENDSR

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
     C                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
