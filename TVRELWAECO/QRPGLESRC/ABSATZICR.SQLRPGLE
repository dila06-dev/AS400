     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
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
      *
      *
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
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
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

     C*Absatz/Umsatzdaten
     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/icsprice
     c+ SELECT KALK_FILE.ARTNR, KALK_FILE.ARTBEZ,
     c+ KALK_FILE.ZOLLNR, KALK_FILE.ARTEAN, ARTZ3, LAENGE, BREITE,
     c+ HOEHE,GEWICHT , KALK_FILE.ICS_ , KALK_FILE.ARTNR artnr2,
     c+ KALK_FILE.ARTBEZ artbez2, dec(0, 13, 2) quantity, dec(0, 13, 2)
     c+ turnover, PREISAKT.ICS_VON, PREISAKT.ICS_BIS,
     c+ PREISAKT.ICS_, PREISAKT.ICS_VON2,
     c+ PREISAKT.ICS_BIS2, PREISAKT.ICS_2, KALK_FILE.TSTAMP TSTAMP FROM
     c+ bar_kalk/kalk_file,bar_kalk/preisakt WHERE KALK_FILE."VERSION" =
     c+ '$$EL_PS_DB' and PREISAKT.ARTNR= KALK_FILE.ARTNR and
     c+ PREISAKT."VERSION" = KALK_FILE."VERSION" and KALK_FILE.TSTAMP =
     c+ PREISAKT.TSTAMP
     c/end-exec

     C*Initialisierungen
     c/exec sql
     c+ update tvrelwaeco/icsprice  set artnr2= ' ', artbez2=' '
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

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
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C*.
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
