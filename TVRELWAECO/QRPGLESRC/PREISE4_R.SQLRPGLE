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
      * checken, ob Kunde Konditionskunde
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

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

     c                   exsr      sr1000
     C                   EXSR      RETURN

     C**************************************************************************
     C*Katalogdaten
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*ics ==> 073        -01-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char(' 73XXX', 6) #PRS020,char('000',
     c+ 3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned((substr(char(ab), 7, 2) concat
     c+ substr(char(ab), 5, 2) concat
     c+ substr(char(ab), 3, 2)), 6, 0) #PRS070, char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A,
     c+            zoned(0, 6, 0) #PRS070_A,
     c+            char(' ', 15)   #PRS080_A,
     c+            zoned(0, 6, 0) #PRS120_A
     c+ FROM #PR2520 WHERE ICS_ = 0 and PRKDLG = '073'
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec


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
     C*
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR

     C**************************************************************************
