     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               zur Datenübernahme aus qs36f/trpkdw00
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

     ftrpkdw00  up   e           k disk
     f#ZKUNL1   uf a e           k disk

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

     C*                 update zkun
     c     key001        klist
     c                   kfld                    KZFIRM
     c                   kfld                    KZKDNR
     c                   kfld                    KZEDIB

     C                   movel     kdw010        KZFIRM
     C                   move      kdw020        #KZKDNR           6
     C                   movel     '0'           #KZKDNR           6
     C                   movel     #KZKDNR       KZKDNR
     C                   movel     kdw430        KZEDIB

     c     key001        chain     #zkunL1                            93
     C   93              clear                   zkun1
     C                   movel     kdw010        KZFIRM
     C                   movel     kdw020        KZKDNR
     C                   movel     kdw430        KZEDIB
     C                   movel     §§§usr        kzuser
     C                   movel     §§§pgm        kzPROG
     C   93              write     zkun1
     C  n93              update    zkun1

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
