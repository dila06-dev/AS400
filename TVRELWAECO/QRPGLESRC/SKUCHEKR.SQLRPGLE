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
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*...
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
     C*Grundaufbau Basisdaten Kunde
     c/exec sql
     c+ insert into tvrelwaeco/skuscs
     c+ SELECT * FROM absatzb WHERE APKDNR in ( select sales# from
     c+ salescomp)
     c/end-exec

     C*Grundaufbau Basisdaten Kunde/gruppen
     c/exec sql
     c+ insert into tvrelwaeco/skuscs2
     c+ SELECT substr(digits(RKREDA), 1, 4),aptenr, dec(sum(APGLMG), 13, 2)
     c+ apglmg, dec(sum(rpnesu), 13, 2) rpnesu FROM skuscs GROUP BY
     c+ substr(digits(RKREDA), 1, 4),aptenr
     c/end-exec

     C*Grundaufbau Basisdaten Artikel
     c/exec sql
     c+ insert into tvrelwaeco/skucheck
     c+ SELECT ARTNR,ARTBEZ,ARTGRP,STATNR,ABC,ICS_, LIEFNR
     c+ ,ARTZ1,ARTZ2,artz3 ,#TESAAV,#TEDIAV,#TEVOZ1, #TEVOA1, E1, E2, E3,
     c+ E4, E5, LAENGE,BREITE,HOEHE, GEWICHT,artsku, dec(0, 8, 0)
     c+ in2011,dec(0, 8, 0) in2012 ,anldat FROM bar_kalk/kalk_file WHERE
     c+ version = '$$EL_PS_DB'
     c/end-exec

     C*update auf 2011
     c/exec sql
     c+ update  tvrelwaeco/skucheck a set  a.in2011     =
     c+ (sELECT APGLMG from skuscs2  where a.artnr = aptenr and sel0001=
     c+ '2011')
     c+  where exists
     c+ (sELECT APGLMG from skuscs2  where a.artnr = aptenr and sel0001=
     c+ '2011')
     c/end-exec

     C*update auf 2012
     c/exec sql
     c+ update tvrelwaeco/skucheck a  set  a.in2012     =
     c+ (sELECT APGLMG from skuscs2  where a.artnr = aptenr and sel0001=
     c+ '2012')
     c+  where exists
     c+ (sELECT APGLMG from skuscs2  where a.artnr = aptenr and sel0001=
     c+ '2012')
     c/end-exec

     c*
     C     ##1000        ENDSR
     c*
     c*
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
