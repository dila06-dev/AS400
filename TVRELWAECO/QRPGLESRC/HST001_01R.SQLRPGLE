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
      * SELECT DISTINCT STATISTIK.APAFJJ, STATISTIK.APAFNR,
      * STATISTIK.APAFPO, STATISTIK.APGLMG FROM statistik, afad WHERE
      * APTENR = '9103500212' and AKAFJJ =2011 and AKAFAT <> '08' and
      * AKAFJJ =2011 and adpold = 'DE' and akaFNR = AdAFNR and AKAFJJ =
      * ADAFJJ
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

     C*Grundaufbau Preselect
     c/exec sql
     c+ insert into tvrelwaeco/hst001_01
     c+ SELECT ARTNR, ARTBEZ, ARTGRP, STATNR, ABC, LIEFERANT1, LIEFERANT2,
     c+ ARTZ1, ARTZ2, ARTZ3 FROM bar_kalk/kalk_file WHERE substr(statnr, 1,
     c+ 1)='1' and version = '$$EL_PS_DB'
     c/end-exec

     C*Grundaufbau Preselect hier Preisdateien
     c/exec sql
     c+ insert into tvrelwaeco/hst001_02
     c+ SELECT EPPING.ARTNR, EPPING.ARTBEZ, EPPING.ARTGRP, EPPING.STATNR,
     c+ EPPING.ABC, EPPING.LIEFERANT1, EPPING.LIEFERANT2, EPPING.ARTZ1,
     c+ EPPING.ARTZ2, EPPING.ARTZ3, PREI.PRBEGR, PREI.PRKDLI, PREI.PRWACD,
     c+ PREI.PRGADA, PREI.PRGBDA, PREI.PREZPR,PRKDLG FROM epping, prei
     c+ WHERE EPPING.ARTNR = PREI.PRTENR and PREI.PRBEGR in ('PVK', 'LP1',
     c+ 'PKG') and PRKDLG in ('073', '   ') and ((PREI.PRGADA < 20110401
     c+ and PREI.PRGBDA = 0) or (PREI.PRGADA < 20110401 and PREI.PRGBDA <
     c+ 20120401)) ORDER BY EPPING.ARTNR, PREI.PRBEGR
     c/end-exec

     C*Grundaufbau Preselect hier Preisdateien
     c/exec sql
     c+ delete FROM hst001_02 WHERE PRGBDA < '20110331' and PRGBDA <> 0
     c/end-exec

     C*Grundaufbau Gruppe hier auf Preisdateien Gruppe maxwerte
     c/exec sql
     c+ insert into tvrelwaeco/hst001_03
     c+ SELECT ARTNR, PRBEGR, PRKDLI, PRWACD, max(PRGADA) PRGADA, PRKDLG
     c+ FROM hst001_02 GROUP BY ARTNR, PRBEGR, PRKDLI, PRWACD, PRKDLG
     c/end-exec

     C*Grundaufbau Preselect hier Preisdateien Gruppe wegen Eindeutigkeit
     C*auf max
     c/exec sql
     c+ insert into tvrelwaeco/hst001_04
     c+ SELECT HST001_02.ARTNR, HST001_02.ARTBEZ, HST001_02.ARTGRP,
     c+ HST001_02.STATNR, HST001_02.ABC, HST001_02.LIEFERANT1,
     c+ HST001_02.LIEFERANT2, HST001_02.ARTZ1, HST001_02.ARTZ2,
     c+ HST001_02.ARTZ3,  HST001_02.PRBEGR, HST001_02.PRKDLI,
     c+ HST001_02.PRWACD, HST001_02.PRGADA, HST001_02.PRGBDA,
     c+ HST001_02.PREZPR, HST001_02.PRKDLG
     c+ FROM HST001_02,HST001_03
     c+ where HST001_02.ARTNR = HST001_03.ARTNR and HST001_02.PRBEGR =
     c+ HST001_03.PRBEGR and HST001_02.PRKDLI = HST001_03.PRKDLI and
     c+ HST001_02.PRWACD = HST001_03.PRWACD and HST001_02.PRGADA =
     c+ HST001_03.PRGADA and HST001_02.PRKDLG = HST001_03.PRKDLG
     c/end-exec

     C*Grundaufbau Preselect hier Preisdateien Gruppe wegen Eindeutigkeit
     C*auf max
     c/exec sql
     c+ insert into tvrelwaeco/hst001_04
     c+ SELECT DISTINCT ARTNR, ARTBEZ, ARTGRP, STATNR, ABC, LIEFERANT1,
     c+ LIEFERANT2, ARTZ1, ARTZ2, ARTZ3, char('STK', 3) PRBEGR, char(' ',
     c+ 10) PRKDLI, char('EUR', 3) PRWACD, zoned((LUJHJJ concat
     c+ digits(LUMONA) concat '01'), 8, 0) PRGADA, zoned(((LUJHJJ +1)
     c+ concat digits(LUMONA) concat '01'), 8, 0) PRGBDA, LUBWPR
     c+ PREZPR,char(' ', 4) PRKDLG FROM hst001_01, lbsu WHERE artnr = LUTENR
     c+ and LUJHJJ = 2011 and LUMONA =04
     c/end-exec
     c*____________________________________________
     C*errors doppelte einträge
     c/exec sql
     c+ insert into tvrelwaeco/hst001_07
     c+ SELECT ARTNR , count(*) FROM hst001_04 WHERE LIEFERANT2 = ' ' and
     c+ PRBEGR ='LP1' and lieferant1 = PRKDLI GROUP BY artnr HAVING
     c+ count(*) > 1
     c/end-exec

     C*errors doppelte einträge
     c/exec sql
     c+ insert into tvrelwaeco/hst001_08
     c+ SELECT HST001_04.ARTNR,max(HST001_04.PRGADA) FROM hst001_07,
     c+ hst001_04 WHERE HST001_04.ARTNR = HST001_07.ARTNR and
     c+ HST001_04.PRBEGR ='LP1' GROUP BY HST001_04.ARTNR
     c/end-exec

     C*doppelte eliminieren
     c/exec sql
     c+ delete   from hst001_04 where HST001_04.PRBEGR ='LP1' and
     c+ LIEFERANT2 = ' ' and lieferant1 = PRKDLI              and
     c+ HST001_04.ARTNR in (select ARTNR from hst001_08 where SEL0002
     c+ <>  PRGADA )
     c/end-exec

     C*doppelte eliminieren
     c/exec sql
     c+ delete   from hst001_07
     c/end-exec
     C*doppelte eliminieren
     c/exec sql
     c+ delete   from hst001_08
     c/end-exec

     C*errors doppelte einträge
     c/exec sql
     c+ insert into tvrelwaeco/hst001_07
     c+ SELECT ARTNR , count(*) FROM hst001_04 WHERE PRBEGR ='LP1' and
     c+ (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+  gROUP BY artnr HAVING count(*) > 1
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/hst001_08
     c+ SELECT HST001_04.ARTNR,max(HST001_04.PRGADA) FROM hst001_07,
     c+ hst001_04 WHERE HST001_04.ARTNR = HST001_07.ARTNR and
     c+ HST001_04.PRBEGR ='LP1' GROUP BY HST001_04.ARTNR
     c/end-exec

     C*doppelte eliminieren
     c/exec sql
     c+ delete   from hst001_04 where HST001_04.PRBEGR ='LP1' and
     c+ (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3)) and
     c+ HST001_04.ARTNR in (select ARTNR from hst001_08 where SEL0002
     c+ <>  PRGADA )
     c/end-exec

     C*rest     eliminieren
     c/exec sql
     c+ delete   FROM hst001_04 WHERE PRBEGR ='LP1' and (substr(LIEFERANT2,
     c+ 8, 3) <> substr(prkdlI, 3, 3)) and (lieferant1 <> PRKDLI) and
     c+ (LIEFERANT2 <>' ')
     c/end-exec


     c*____________________________________________

     C*Grundaufbereitung
     c/exec sql
     c+ insert into tvrelwaeco/hst001_05
     c+ SELECT DISTINCT ARTNR, ARTBEZ, ARTGRP, STATNR, ABC, LIEFERANT1,
     c+ LIEFERANT2, ARTZ1, ARTZ2, ARTZ3, PRBEGR, PRKDLI, PRWACD, PRGADA,
     c+ PRGBDA, PREZPR, PRBEGR,         PRWACD, PRGADA, PRGBDA, PREZPR,
     c+ PRBEGR,         PRWACD, PRGADA, PRGBDA, PREZPR,
     c+ PRBEGR,         PRWACD, PRGADA, PRGBDA, PREZPR FROM hst001_04 ORDER
     c+ BY ARTNR, PRBEGR
     c/end-exec

     C*Grundaufbereitung clearing
     c/exec sql
     c+ update hst001_05 set  PRBEGR01 = ' ',
     c+                       PRWACD01 = ' ',
     c+                       PRGADA01 = 0  ,
     c+                       PRGBDA01 = 0  ,
     c+                       PREZPR01 = 0  ,
     c+                       PRBEGR02 = ' ',
     c+                       PRWACD02 = ' ',
     c+                       PRGADA02 = 0  ,
     c+                       PRGBDA02 = 0  ,
     c+                       PREZPR02 = 0  ,
     c+                       PRBEGR03 = ' ',
     c+                       PRWACD03 = ' ',
     c+                       PRGADA03 = 0  ,
     c+                       PRGBDA03 = 0  ,
     c+                       PREZPR03 = 0
     c/end-exec

     C*Grundaufbereitung clearing
     c/exec sql
     c+ update hst001_05 set  PRBEGR01 = PRBEGR,
     c+                       PRWACD01 = PRWACD,
     c+                       PRGADA01 = PRGADA,
     c+                       PRGBDA01 = PRGBDA,
     c+                       PREZPR01 = PREZPR
     c+        where   PRBEGR ='PVK'
     c/end-exec

     C*Grundaufbereitung clearing  stk
     c/exec sql
     c+ update hst001_05 set  PRBEGR02 = PRBEGR,
     c+                       PRWACD02 = PRWACD,
     c+                       PRGADA02 = PRGADA,
     c+                       PRGBDA02 = PRGBDA,
     c+                       PREZPR02 = PREZPR
     c+        where   PRBEGR ='STK'
     c/end-exec

     C*Grundaufbereitung clearing
     c/exec sql
     c+ update hst001_05 set  PRBEGR03 = PRBEGR,
     c+                       PRWACD03 = PRWACD,
     c+                       PRGADA03 = PRGADA,
     c+                       PRGBDA03 = PRGBDA,
     c+                       PREZPR03 = PREZPR
     c+        where   PRBEGR ='PKG'
     c/end-exec

     c/exec sql
     c+ update hst001_05 set  PRBEGR = ' ' ,
     c+                       PRKDLI = ' ' ,
     c+                       PRWACD = ' ' ,
     c+                       PRGADA = 0   ,
     c+                       PRGBDA = 0   ,
     c+                       PREZPR = 0
     c+        where   PRBEGR <>'LP1'
     c/end-exec

     C*Grundaufbereitung clearing  pvk
     c/exec sql
     c+ insert into tvrelwaeco/hst001_06
     c+ SELECT DISTINCT ARTNR ,
     c+        prkdli prkdli, PRBEGR01 PRBEGR, PRWACD01 PRWACD, PRGADA01
     c+ PRGADA, PRGBDA01 PRGBDA, PREZPR01 PREZPR FROM hst001_05 WHERE
     c+ PRBEGR01 <> ' '
     c/end-exec

     C*Grundaufbereitung clearing  pkg
     c/exec sql
     c+ insert into tvrelwaeco/hst001_06
     c+ SELECT DISTINCT ARTNR ,
     c+        prkdli prkdli, PRBEGR03 PRBEGR, PRWACD03 PRWACD, PRGADA03
     c+ PRGADA, PRGBDA03 PRGBDA, PREZPR03 PREZPR FROM hst001_05 WHERE
     c+ PRBEGR03 <> ' '
     c/end-exec

     C*Grundaufbereitung clearing  LP1
     c/exec sql
     c+ insert into tvrelwaeco/hst001_06
     c+ SELECT DISTINCT ARTNR , prkdli prkdli, PRBEGR PRBEGR, PRWACD
     c+ PRWACD, PRGADA PRGADA, PRGBDA PRGBDA, PREZPR PREZPR FROM hst001_05
     c+ WHERE PRBEGR <> ' ' and ( LIEFERANT1= PRKDLI or prkdli = ' ' or
     c+ (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3)) )
     c/end-exec

     C*update
     c/exec sql
     c+ update hst001_05 a set PRBEGR01 =
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRWACD01 =
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGADA01 =
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGBDA01 =
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PREZPR01 =
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'PVK' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec

     C*update
     c/exec sql
     c+ update hst001_05 a set PRBEGR03 =
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRWACD03 =
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGADA03 =
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGBDA03 =
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PREZPR03 =
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c+ where exists
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'PKG' and a.ARTNR = artnr and a.prbegr02='STK')
     c/end-exec


     C*update
     c/exec sql
     c+ update hst001_05 a set PRBEGR   =
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and ((substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+             and lieferant2 <> ' ')                         )
     c+ where exists
     c+ (select PRBEGR from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and ((substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+             and lieferant2 <> ' ')                         )
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRWACD   =
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c+ where exists
     c+ (select PRWACD from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGADA   =
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c+ where exists
     c+ (select PRGADA from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRGBDA   =
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c+ where exists
     c+ (select PRGBDA from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PREZPR   =
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c+ where exists
     c+ (select PREZPR from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
     c/end-exec
     c/exec sql
     c+ update hst001_05 a set PRKDLI   =
     c+ (select PRKDLI from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+             and lieferant2 <> ' ')
     c+ where exists
     c+ (select PRKDLI from hst001_06  where
     c+         PRBEGR = 'LP1' and a.ARTNR = artnr and a.prbegr02='STK'
     c+         and  (substr(LIEFERANT2, 8, 3) = substr(prkdlI, 3, 3))
     c+              and lieferant2 <> ' ')
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
