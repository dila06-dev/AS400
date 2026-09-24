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

     fmeasure   up   e           k disk    RENAME(measure:phy01r)
     fARTDATEN  uf a e           k disk

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

     I*phy01r
     I*              measure                     sentence
     I*

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*                 update zkun

     C                   movel     f1            #1a
     C     ';':' '       xlate     #1a           #1a

     c     #1A           chain     artdaten                           93
     C   93              clear                   artdatenr
     C     ';':' '       xlate     f2            f2
     C     '.':','       xlate     f2            f2
     C                   select
     C                   when      %subst(f2:1:1) = ' '
     C*
     C                   when      %subst(f2:2:1) = ' '
     C                   eval      p1 = %subst(f2:1:1)
     c                   testn                   p1                   20
     c  n20              eval      error = '1'
     C*    p2 ==>  2,
     C                   when      %subst(f2:3:1) = ' '
     C                   eval      p2 = %subst(f2:1:2)
     c                   eval      xpos = %scan(',': p2)
     c                   eval      ypos = 2 - xpos
     c                   eval      p1 = %triml(%subst(f2:1:1))
     c                   testn                   p1                   20
     c  n20              eval      error = '1'
     C*    p3 ==>  2,5
     C                   when      %subst(f2:4:1) = ' '
     C                   eval      p3 = %subst(f2:1:3)
     c                   eval      xpos = %scan(',': p3)
     c                   eval      xpos = xpos -1
     c                   eval      ypos = 3 - xpos +1
     c                   eval      p3 = %triml(%subst(f2:1:xpos)) +
     c                                  %triml(%subst(f2:1:3))
     c                   testn                   p2                   20
     c  n20              eval      error = '1'
     C*
     C                   when      %subst(f2:5:1) = ' '
     C                   eval      p4 = %subst(f2:1:4)
     c                   testn                   p4                   20
     c  n20              eval      error = '1'
     C                   when      %subst(f2:6:1) = ' '
     C                   eval      p5 = %subst(f2:1:5)
     c                   testn                   p5                   20
     c  n20              eval      error = '1'
     C                   when      %subst(f2:7:1) = ' '
     C                   eval      p6 = %subst(f2:1:6)
     c                   testn                   p6                   20
     c  n20              eval      error = '1'
     C                   when      %subst(f2:8:1) = ' '
     C                   eval      p7 = %subst(f2:1:7)
     c                   testn                   p7                   20
     c  n20              eval      error = '1'
     c                   other
     C                   endsl
     C   93              write     artdatenr
     C  n93              update    artdatenr

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     C                   clear                   p1                1
     C                   clear                   p2                2
     C                   clear                   p3                3
     C                   clear                   p4                4
     C                   clear                   p5                5
     C                   clear                   p6                6
     C                   clear                   p7                7
     C                   clear                   p8                8
     C                   clear                   p9                9
     C                   setoff                                       20
     C                   clear                   error             1
     C                   clear                   xpos              3 0

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
