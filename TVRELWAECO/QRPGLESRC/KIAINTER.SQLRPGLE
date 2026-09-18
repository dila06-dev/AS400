     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
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
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   exsr      sr1000
     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
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

     c/exec sql
     c+ insert into tvrelwaeco/kiainter
     c+ SELECT char('KIA     ') distr, char('276     ') countr,
     c+ char('Dometic WAECO International GmbH') SUPPLWORLD,
     c+ char('Zubehör') category,
     c+ char('Dometic WAECO International GmbH') SUPPLLOCAL,
     c+ char('Dometic WAECO') BRAND,TPTTXT,TEEANR,ARTNR,TETBZ1,
     c+ dec(max(PREZPR), 12, 2) billing,
     c+ (dec(max(PREZPR), 12, 2) * dec(max(KORABA*-1), 12, 2)/100)
     c+ + 0,005 Rabatt,
     c+ dec(max(PREZPR), 12, 2)  -
     c+ (dec(max(PREZPR), 12, 2) * dec(max(KORABA*-1), 12, 2)/100)
     c+                    + 0,0049 Netto, TEPRGR,
     c+          dec(max(KORABA*-1), 12, 2) RABATTp
     c+ FROM mdpkatalog, teil, trtp00, kond00, prei00
     c+ WHERE ARTNR=TETENR and TPTCDE=TEPRGR and
     c+               TPTART = 'PRGR' and TPTFLG=0 and KOBEGR='RP5' and
     c+               KOKDLG = '101'  and TEPRGR=KOPRGR and
     c+               PRBEGR = 'PVK'  and PRTENR=ARTNR  and
     c+       date(substr(char(KOGADA), 1, 4) concat '-' concat
     c+            substr(char(KOGADA), 5, 2) concat '-' concat
     c+            substr(char(KOGADA), 7, 2) ) < current date -1 day and
     c***+       date(substr(char(KOGBDA), 1, 4) concat '-' concat
     c***+            substr(char(KOGBDA), 5, 2) concat '-' concat
     c***+            substr(char(KOGBDA), 7, 2) ) > current date and
     c+       date(substr(char(PRGADA), 1, 4) concat '-' concat
     c+            substr(char(PRGADA), 5, 2) concat '-' concat
     c+            substr(char(PRGADA), 7, 2) ) < current date -1 day
     c+ GROUP BY TPTTXT,TEEANR,ARTNR,TETBZ1,TEPRGR
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
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
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
