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

     fsbgagt00  up   e           k disk
     fTXST02    uf a e           k disk
     fSBGKDS00  IF   E           K DISK

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

     c
     c                   setoff                                       77
     c                   if        AGT010  <>    #AGT010  or
     c                             AGT020  <>    #AGT020  or
     c                             AGT030  <>    #AGT030
     c                   seton                                        77
     c                   z-add     AGT010        #AGT010           2 0
     c                   movel     AGT020        #AGT020           1
     c                   z-add     AGT030        #AGT030           5 0
     c                   endif
     c
     C*                 update prei
     c     key001        klist
     c                   kfld                    TTFIRM
     c                   kfld                    TTTCDE
     c                   kfld                    TTTENR
     c                   kfld                    TTKDLI
     c                   kfld                    TTA115
     c                   kfld                    TTA215
     C                   kfld                    TTSPCD
     C                   kfld                    TTUCDE
     C                   kfld                    TTGADA
     C                   kfld                    TTLFZN

     c                   if        AGT020  = 'K'
     c                   exsr      sr8000
     c                   endif

     c                   if        AGT020  = 'K'  and *in45 = '1'
     C                   movel     '01'          TTFIRM
     C                   movel     'TRTX02  '    TTTCDE
     C                   clear                   TTTENR
     C                   clear                   TTKDLI
     C                   move      AGT030        #TTKDLI           6
     C                   movel     '0'           #TTKDLI
     C                   movel     #TTKDLI       TTKDLI
     C                   clear                   TTA115
     C                   clear                   TTA215
     C                   movel     'D'           TTSPCD
     C                   movel     '1'           TTUCDE
     C                   clear                   TTGADA
     C                   z-add     AGT040        TTLFZN
     C   77              clear                   TTLFZN

     c     key001        chain     TXST02                             93
     C   93              clear                   txst1

     C                   movel     '01'          TTFIRM
     C                   movel     'TRTX02  '    TTTCDE
     C                   clear                   TTTENR
     C                   clear                   TTKDLI
     C                   move      AGT030        #TTKDLI           6
     C                   movel     '0'           #TTKDLI
     C                   movel     #TTKDLI       TTKDLI
     C                   clear                   TTA115
     C                   clear                   TTA215
     C                   movel     'D'           TTSPCD
     C                   movel     '1'           TTUCDE
     C                   clear                   TTGADA
     C                   z-add     AGT040        TTLFZN
     C   77              clear                   TTLFZN

     C                   movel     AGT050        TTTEXT
     C                   movel     ' '           TTDR01
     C                   movel     ' '           TTDR02
     C                   movel     ' '           TTDR03
     C                   movel     ' '           TTDR04
     C                   movel     ' '           TTDR05

     C                   movel     §§§usr        ttuser
     C                   movel     §§§pgm        ttPROG
     C   93              write     txst1
     C  n93              update    txst1
     C                   endif

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*

     C     KEY8000       KLIST
     C                   KFLD                    #firma            2 0
     C                   KFLD                    #kunde            5 0

     C                   z-add     1             #firma
     C                   z-add     AGT030        #kunde

     c                   seton                                        45
     c     key8000       chain     sbgkds00                           94
     c                   if        kds200 =  99 or
     c                             *in94  = '1'
     c                   setoff                                       45
     c                   endif

     C*
     C     ##8000        ENDSR

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
