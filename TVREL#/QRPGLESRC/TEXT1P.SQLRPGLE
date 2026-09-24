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

     fsbgatx00  up   e           k disk
     fTXST02    uf a e           k disk

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

     c                   setoff                                       77
     c                   if        ATX020  <>    #ATX020
     c                   seton                                        77
     c                   movel     ATX020        #ATX020          15
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

     C                   movel     '01'          TTFIRM
     C                   movel     'TRTX03  '    TTTCDE
     C                   movel     ATX020        TTTENR
     C                   clear                   TTKDLI
     C                   clear                   TTA115
     C                   clear                   TTA215
     C                   movel     'D'           TTSPCD
     C                   movel     '1'           TTUCDE
     C                   clear                   TTGADA
     C                   z-add     atx030        TTLFZN
     C   77              clear                   TTLFZN
     C*
     c     key001        chain     TXST02                             93
     C   93              clear                   txst1
     C                   movel     '01'          TTFIRM
     C                   movel     'TRTX03  '    TTTCDE
     C                   movel     ATX020        TTTENR
     C                   clear                   TTKDLI
     C                   clear                   TTA115
     C                   clear                   TTA215
     C                   movel     'D'           TTSPCD
     C                   movel     '1'           TTUCDE
     C                   clear                   TTGADA
     C                   z-add     atx030        TTLFZN
     C   77              clear                   TTLFZN

     C                   movel     atx040        TTTEXT
     C                   movel     'D'           TTSPCD
     C                   movel     '1'           TTUCDE
     C                   movel     'A'           TTDR01
     C                   movel     'L'           TTDR02
     C                   movel     'R'           TTDR03
     C                   movel     'C'           TTDR04
     C                   movel     'G'           TTDR05

     C                   movel     §§§usr        ttuser
     C                   movel     §§§pgm        ttPROG
     C   93              write     txst1
     C  n93              update    txst1



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
