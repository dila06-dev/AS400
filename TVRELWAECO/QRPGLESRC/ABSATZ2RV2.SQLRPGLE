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
      **** §PWC000001 in TVRELWAECO                                          */
      * SELECT DISTINCT char(substr(rkreda, 1, 6)) RKREDA, APTENR ,APGLMG,
      * ADPOLD, APAFJJ,APAFNR,APAFPO,ADAART, RPFIRM, RPRGJJ, RPRGNR,
      * RPLIJJ, RPLINR, RPLIPO ,rkreda FROM afad,statistik WHERE ADAART
      * in('ADVS', 'ADAG') and akaFNR = AdAFNR and AKAFJJ = ADAFJJ and    =
      * ADFIRM in ('01', '51') and rkreda > 20121200 and rkreda < 20130000
      * Datei §PWC000001 in TVRELWAECO wurde ersetzt.
      *
      **** §PWC000002 in TVRELWAECO                                          */
      * SELECT DISTINCT char(substr(rkreda, 1, 6)) RKREDA, APTENR ,APGLMG,
      * ADPOLD, APAFJJ,APAFNR,APAFPO,ADAART, RPFIRM, RPRGJJ, RPRGNR,
      * RPNESU, RPBRSU, RPLIJJ, RPLINR, RPLIPO ,rkreda , STATISTIK.APPRGR
      * FROM afad,statistik WHERE                   ADAART in('ADVS',     =
      * 'ADAG') and akaFNR = AdAFNR and AKAFJJ = ADAFJJ and ADFIRM in
      * ('01', '51') and rkreda > 20120000 and rkreda < 20130000
      * Datei §PWC000002 in TVRELWAECO wurde erstellt.
      *
      *
      **** Ausrichtung Basisdaten Artikel                             */
      *    -  gültige Einträge vorhanden                        wenn ja
      *    -  Umsätze vorhanden                                 wenn ja
      *       *** Ausrichtung Kunde
      *       -  ist der Kunde eine Ausnahme Vertrag           wenn nein
      *          (seit 2012 (Trend) keine relevante Prüfung,
      *          daher stehen alle Kunden grundsätzlich auf
      *          Nein und sind Bestandteil der Berechnung
      *          *** Ausrichtung Belieferung
      *          -  wohin wurde geliefert nur DE ist relevant  wenn DE
      *             -  wohin wurde tatsächlich geliefert
      *                ist Rechnungsadresse DE und Lieferadresse
      *                vorhanden, entscheidet die Lieferadresse
      *                diese muß DE sein
      *
      *SELECT APTENR, APAFJJ, APAFNR, APAFPO, ADAART, RKREDA, APGLMG,
      *ADPOLD FROM ummfile1 WHERE RKREDA> 201600 and rkreda < 202000 and
      *APTENR in ('9105204142','8880400428','RV-50-OE1 ',
      *'9102200030','8880400320','TK-280SB  ',
      *'8880400261','8880100053','9105705356',
      *'9103555825','9104100091','9105705359',
      *'9105305506','VAS 581 001','9104108580', '9105302940','9103301819',
      *'9107200098', '9101700023','9105202819') ORDER BY APTENR, APAFJJ,
      *APAFNR, APAFPo
      *
      * SELECT APTENR, APAFJJ, APAFNR, APAFPO, ADAART ,rkredA,
      * apglmg,adpold FROM ummfile1 WHERE aptenr='9105204142'
      * Datei PVC001 in TVRELWAECO wurde erstellt.
      *
      * SELECT APTENR, APAFJJ, APAFNR, APAFPO, ADAART ,rkredA,
      * apglmg,adpold FROM ummfile1 WHERE aptenr='9105302940'
      * 1084 Sätze zu Teildatei PVC001 in Datei PVC001 hinzugefügt.
      *
      * SELECT APTENR, ARTBEZ, STATNR, JANA, FEBA, MAEA, APRA, MAIA, JUNA,
      * JULA, AUGA, SEPA, OKTA, NOVA, DEZA, dec( (JANA+ FEBA+ MAEA+ APRA+
      * MAIA+ JUNA+ JULA+ AUGA+ SEPA+ OKTA+ NOVA+ DEZA), 13, 0) summe
      * FROM ummfile3 WHERE aptenr in ('9105202819','9105202809',
      * '9105305825','9105302940','9105302772',
      * '9600000482','A411412   ','9105306210',
      * '9103501265','9105203202','9103300508',
      * '9103301741','9104100237','9104114007',
      * '9600000668','9600000057','9103301736',
      * '9600000063','9600000110','9102100026',
      * 'A460785   ','          ','          ')
      * Datei PVC002 in TVRELWAECO wurde erstellt.
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fenvironmv2uf   e             disk
     f                                     RENAME(environmv2:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN

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
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying
     I*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   z-add     0             p                 1 0
     C*Absatz/Umsatzdaten
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/UMMFILE1V2';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ummfile1_V';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ummfile4v2';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ummfile2v2';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ummfile3v2';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/environmv2';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
             p=1;
       endmon;
      /End-Free
     c                   if        p=0
     c                   exsr      sr1000
     c*****************  exsr      sr8000
     c                   exsr      sr8001
     c                   endif

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

     C*Grundaufbau Umweltmanagementfile
     c/exec sql
     c+ insert into tvrelwaeco/ummfile1V2
     c+ SELECT distinct
     c+ char(substr(rkreda, 1, 6)) RKREDA,item APTENR ,
     c+ dec(sum(APGLMG), 13, 2) APGLMG, ADPOLD,
     c+ char(' ', 4) T4000, char(' ', 10) M40001, char(' ', 10) M40002,
     c+ char(' ', 4) T4010, char(' ', 10) M40101, char(' ', 10) M40102,
     c+                     char(' ', 10) M40103,
     c+ char(' ', 4) T4020, char(' ', 10) M40201, char(' ', 10) M40202,
     c+ char(' ', 10) M40203, char(' ', 4) T1000, char(' ', 10) M10008,
     c+ dec(A01, 13, 2) jana, dec(A02, 13, 2) feba, dec(A03, 13, 2) maea,
     c+ dec(A04, 13, 2) apra, dec(A05, 13, 2) maia, dec(A06, 13, 2) juna,
     c+ dec(A07, 13, 2) jula, dec(A08, 13, 2) auga, dec(A09, 13, 2) sepa,
     c+ dec(A10, 13, 2) okta, dec(A11, 13, 2) nova, dec(A12, 13, 2) deza,
     c+ AKAFJJ,AKAFNR,DOC,ADAART,apprgr, division,customer,teprgr,
     c+ artnr, artsku, artbezfra
     c+ FROM afad,rpmsales#
     c+ WHERE ENTITY ='DE411' and h1 <> 'supplement' and J01=2018 and
     c***********+    adpold = 'DE' and ADAART in('ADVS', 'ADAG') and
     c+                                 ADAART in('ADVS', 'ADAG') and
     c+       adfirm in ('01','51') and akaFNR = AdAFNR and AKAFJJ = ADAFJJ
     c+ group by RKREDA,item,ADPOLD,AkAFJJ,AkAFNR,doc,ADAART,
     c+          apprgr, division,customer,teprgr,
     c+          a01, a02, a03, a04, a05, a06,
     c+          a07, a08, a09, a10, a11, a12,
     c+          artnr, artsku, artbezfra
     c/end-exec


     C*Gruppierung greift sonst nichtle
     c/exec sql
     c+ insert into tvrelwaeco/ummfile1_V
     c+ SELECT RKREDA, APTENR, dec(sum(APGLMG), 13, 2) APGLMG,
     c+                                ADPOLD, T4000, M40001, M40002,
     c+ T4010, M40101, M40102, M40103, T4020, M40201, M40202, M40203,
     c+ T1000, M10008, JANA, FEBA, MAEA, APRA, MAIA, JUNA, JULA, AUGA,
     c+ SEPA, OKTA, NOVA, DEZA, AKAFJJ, AKAFNR, DOC, ADAART, APPRGR,
     c+ DIVISION, CUSTOMER, TEPRGR, ARTNR, ARTSKU, ARTBEZFRA
     c+ FROM ummfile1v2
     c+ group by
     c+        RKREDA, APTENR,
     c+                                ADPOLD, T4000, M40001, M40002,
     c+ T4010, M40101, M40102, M40103, T4020, M40201, M40202, M40203,
     c+ T1000, M10008, JANA, FEBA, MAEA, APRA, MAIA, JUNA, JULA, AUGA,
     c+ SEPA, OKTA, NOVA, DEZA, AKAFJJ, AKAFNR, DOC, ADAART, APPRGR,
     c+ DIVISION, CUSTOMER, TEPRGR, ARTNR, ARTSKU, ARTBEZFRA
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ delete from ummfile1v2
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ insert into ummfile1v2
     c+ select * from ummfile1_v
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ insert into tvrelwaeco/ummfile4v2
     c+ SELECT akafjj, akafnr, doc,    count(*) FROM ummfile1_V GROUP BY
     c+ akafjj, akafnr, doc    HAVING count(*) > 1
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ delete from ummfile1v2 where
     c+ adaart = 'ADAG' and AKAFnr in
     c+    (select ummfile1v2.aKafnr from ummfile4v2 where
     c+            ummfile1v2.AkAFJJ= ummfile4v2.AkAFJJ
     c+        and ummfile1v2.AkAFnr= ummfile4v2.AkAFnr
     c+        and ummfile1v2.doc   = ummfile4v2.doc     )
     c/end-exec

     C*TEOS 4000
     c/exec sql
     c+ update ummfile1v2     set T4000  =
     c+ (select max(TEOSKLCD) from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000')
     c+         group by TEOSKLCD)
     c+ where exists
     c+ (select max(TEOSKLCD) from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000')
     c+         group by TEOSKLCD)
     c/end-exec
     c*
     C*TEOS 4010
     c/exec sql
     c+ update ummfile1v2     set T4010  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 4020
     c/exec sql
     c+ update ummfile1v2     set T4020  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 40001 Papier/Pappe in Gramm
     c/exec sql
     c+ update ummfile1v2     set M40001 =
     c+ (select max(TEOSMM02) from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM02)
     c+ where exists
     c+ (select max(TEOSMM02) from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM02)
     c/end-exec
     c*
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update ummfile1v2     set M40002 =
     c+ (select max(TEOSMM03) from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM03)
     c+ where exists
     c+ (select max(TEOSMM03) from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM03)
     c/end-exec
     c*
     C*TEOS 40101 Grundgewicht Elektro
     c/exec sql
     c+ update ummfile1v2     set M40101 =
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40102 Kategorie
     c/exec sql
     c+ update ummfile1v2     set M40102 =
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40103 Sammelgruppe
     c/exec sql
     c+ update ummfile1v2     set M40103 =
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40201 Batterietyp
     c/exec sql
     c+ update ummfile1v2     set M40201 =
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40202 Anzahl Batterien
     c/exec sql
     c+ update ummfile1v2     set M40202 =
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40203 Gewicht eine Batterie
     c/exec sql
     c+ update ummfile1v2     set M40203 =
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 4000
     c/exec sql
     c+ update ummfile1v2     set T4000  =
     c+ (select max(TEOSKLCD) from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000')
     c+         group by TEOSKLCD)
     c+ where exists
     c+ (select max(TEOSKLCD) from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000')
     c+         group by TEOSKLCD)
     c/end-exec
     c*
     C*TEOS 4010
     c/exec sql
     c+ update ummfile1v2     set T4010  =
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 4020
     c/exec sql
     c+ update ummfile1v2     set T4020  =
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 40001 Papier/Pappe in Gramm
     c/exec sql
     c+ update ummfile1v2     set M40001 =
     c+ (select max(TEOSMM02) from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM02)
     c+ where exists
     c+ (select max(TEOSMM02) from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM02)
     c/end-exec
     c*
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update ummfile1v2     set M40002 =
     c+ (select max(TEOSMM03) from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM03)
     c+ where exists
     c+ (select max(TEOSMM03) from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+         group by TEOSMM03)
     c/end-exec
     c*
     C*TEOS 40101 Grundgewicht Elektro
     c/exec sql
     c+ update ummfile1v2     set M40101 =
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40102 Kategorie
     c/exec sql
     c+ update ummfile1v2     set M40102 =
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40103 Sammelgruppe
     c/exec sql
     c+ update ummfile1v2     set M40103 =
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4010' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40201 Batterietyp
     c/exec sql
     c+ update ummfile1v2     set M40201 =
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40202 Anzahl Batterien
     c/exec sql
     c+ update ummfile1v2     set M40202 =
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40203 Gewicht eine Batterie
     c/exec sql
     c+ update ummfile1v2     set M40203 =
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where Artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c*
     c/exec sql
     c+ update ummfile1v2 set m40001 ='0000000000' where m40001=' '
     c/end-exec
     c/exec sql
     c+ update ummfile1v2 set m40002 ='0000000000' where m40002=' '
     c/end-exec
     c*
     c/exec sql
     c+ update ummfile1v2 set m40101 ='0000000000' where m40101=' '
     c/end-exec
     c*
     c/exec sql
     c+ update ummfile1v2 set m40201 ='0000000000' where m40201=' '
     c/end-exec
     c/exec sql
     c+ update ummfile1v2 set m40202 ='0000000000' where m40202=' '
     c/end-exec
     c/exec sql
     c+ update ummfile1v2 set m40203 ='0000000000' where m40203=' '
     c/end-exec
     c/exec sql
     c+ update ummfile1v2 set m10008 ='0000000000' where m10008=' '
     c/end-exec
     c*
     C     ##1000        ENDSR
     c*
     c*
     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR

     C                   open      environmv2

     C                   DO        *HIVAL
     C                   READ      environmv2                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   select
     C                   when      %subst(weight_cl: 1: 3) < '200'
     c                   eval      weight_cl='                     '
     C                   when      %subst(weight_cl: 1: 3) < '210'
     c                   eval      weight_cl='0000 - 0050 gr '
     C                   when      %subst(weight_cl: 1: 3) < '219'
     c                   eval      weight_cl='0051 - 0150 gr '
     C                   when      %subst(weight_cl: 1: 3) < '227'
     c                   eval      weight_cl='0151 - 0250 gr '
     C                   when      %subst(weight_cl: 1: 3) < '235'
     c                   eval      weight_cl='0251 - 0500 gr '
     C                   when      %subst(weight_cl: 1: 3) < '243'
     c                   eval      weight_cl='0501 - 0100 gr '
     C                   when      %subst(weight_cl: 1: 3) < '251'
     c                   eval      weight_cl='1001 - 2000 gr '
     C                   when      %subst(weight_cl: 1: 3) < '268'
     c                   eval      weight_cl='2001 - 4000 gr '
     C                   when      %subst(weight_cl: 1: 3) > '266'
     c                   eval      weight_cl='then Knopfzelle  '
     c                   other
     c                   eval      weight_cl='???              '
     c                   endsl
     C
     C                   select
     C                   when      %subst(batt_cl: 1: 3) = '000'
     c                   eval      batt_cl='                       '
     C                   when      %subst(batt_cl: 1: 3) = '201' or
     C                             %subst(batt_cl: 1: 3) = '202' or
     C                             %subst(batt_cl: 1: 3) = '203' or
     C                             %subst(batt_cl: 1: 3) = '204' or
     C                             %subst(batt_cl: 1: 3) = '210' or
     C                             %subst(batt_cl: 1: 3) = '211' or
     C                             %subst(batt_cl: 1: 3) = '212' or
     C                             %subst(batt_cl: 1: 3) = '213' or
     C                             %subst(batt_cl: 1: 3) = '219' or
     C                             %subst(batt_cl: 1: 3) = '220' or
     C                             %subst(batt_cl: 1: 3) = '221' or
     C                             %subst(batt_cl: 1: 3) = '222' or
     C                             %subst(batt_cl: 1: 3) = '227' or
     C                             %subst(batt_cl: 1: 3) = '228' or
     C                             %subst(batt_cl: 1: 3) = '229' or
     C                             %subst(batt_cl: 1: 3) = '230' or
     C                             %subst(batt_cl: 1: 3) = '235' or
     C                             %subst(batt_cl: 1: 3) = '236' or
     C                             %subst(batt_cl: 1: 3) = '237' or
     C                             %subst(batt_cl: 1: 3) = '238' or
     C                             %subst(batt_cl: 1: 3) = '243' or
     C                             %subst(batt_cl: 1: 3) = '244' or
     C                             %subst(batt_cl: 1: 3) = '245' or
     C                             %subst(batt_cl: 1: 3) = '246' or
     C                             %subst(batt_cl: 1: 3) = '251' or
     C                             %subst(batt_cl: 1: 3) = '252' or
     C                             %subst(batt_cl: 1: 3) = '253' or
     C                             %subst(batt_cl: 1: 3) = '254' or
     C                             %subst(batt_cl: 1: 3) = '259' or
     C                             %subst(batt_cl: 1: 3) = '260' or
     C                             %subst(batt_cl: 1: 3) = '261' or
     C                             %subst(batt_cl: 1: 3) = '262' or
     C                             %subst(batt_cl: 1: 3) = '268' or
     C                             %subst(batt_cl: 1: 3) = '269' or
     C                             %subst(batt_cl: 1: 3) = '270' or
     C                             %subst(batt_cl: 1: 3) = '271' or
     C                             %subst(batt_cl: 1: 3) = '276' or
     C                             %subst(batt_cl: 1: 3) = '277'
     c                   eval      batt_cl='Batterie chargeable    '
     c                   other
     c                   eval      batt_cl='Batterie non chargeable'
     c                   endsl
     C
     C                   select
     C                   when      %subst(batt_type: 1: 3) = '201'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '202'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '203'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '204'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '205'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '206'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '207'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '208'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '209'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C                   when      %subst(batt_type: 1: 3) = '210'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '211'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '212'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '213'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '214'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '215'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '216'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '217'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '218'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C                   when      %subst(batt_type: 1: 3) = '219'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '220'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '221'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '222'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '223'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '224'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '225'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '226'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C
     C                   when      %subst(batt_type: 1: 3) = '227'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '228'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '229'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '230'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '231'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '232'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '233'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '234'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C
     C                   when      %subst(batt_type: 1: 3) = '235'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '236'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '237'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '238'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '239'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '240'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '241'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '242'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C                   when      %subst(batt_type: 1: 3) = '243'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '244'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '245'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '246'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '247'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '248'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '249'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '250'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '
     C
     C                   when      %subst(batt_type: 1: 3) = '251'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '252'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '253'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '254'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '255'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '256'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '257'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '258'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '

     C                   when      %subst(batt_type: 1: 3) = '259'
     c                   eval      batt_type='Zink- Kohle (ZnC)           '
     C                   when      %subst(batt_type: 1: 3) = '260'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '261'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '262'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '263'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '264'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '265'
     c                   eval      batt_type='Kleinblei (Pb)              '
     C                   when      %subst(batt_type: 1: 3) = '266'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '


     C                   when      %subst(batt_type: 1: 3) = '268'
     c                   eval      batt_type='Silberoxid (AgO)            '
     C                   when      %subst(batt_type: 1: 3) = '269'
     c                   eval      batt_type='Alkali- Mangan (AlMn)       '
     C                   when      %subst(batt_type: 1: 3) = '270'
     c                   eval      batt_type='Zink- Luft (ZnLuft)         '
     C                   when      %subst(batt_type: 1: 3) = '271'
     c                   eval      batt_type='Lithium (Li)                '
     C                   when      %subst(batt_type: 1: 3) = '272'
     c                   eval      batt_type=
     c                                 'Li-Ion (inkl. Li-Polymer) (Li-Ion)'
     C                   when      %subst(batt_type: 1: 3) = '273'
     c                   eval      batt_type='Nickel- Metallhydrid (NiMH) '
     C                   when      %subst(batt_type: 1: 3) = '274'
     c                   eval      batt_type='Nickel- Cadmium (NiCd)      '

     C                   when      %subst(batt_type: 1: 3) = '276'
     c                   eval      batt_type='AgO rund, aus Knopfz. aufgebaut'
     C                   when      %subst(batt_type: 1: 3) = '277'
     c                   eval      batt_type='AlMn rund, aus Knopfz. aufgebaut'

     C                   when      %subst(batt_type: 1: 3) = '000'
     c                   eval      batt_type=*blank

     c                   other
     c                   eval      batt_type=batt_type
     c                   endsl
     C
     C                   select
     C                   when      %subst(producttyp: 1: 3) = '1-1'
     c                   eval      producttyp=
     c                             'Kältegeräte, klimageräte, Ölradiatoren' +
     c                             ' f.d. Nutzung in privaten Haushalten'
     C                   when      %subst(producttyp: 1: 3) = '2-1'
     c                   eval      producttyp=
     c                             'Haushaltskleingeräte ' +
     c                             ' f.d. Nutzung in privaten Haushalten'
     C                   when      %subst(producttyp: 1: 3) = '6-1'
     c                   eval      producttyp=
     c                             'Elektrische und elektronische Werkzeuge' +
     c                             ' f.d. Nutzung in privaten Haushalten'
     C                   when      %subst(producttyp: 1: 3) = '6-2'
     c                   eval      producttyp=
     c                             'Elektrische und elektronische Werkzeuge' +
     c                             ' f.d. Nutzung NICHT in privaten Haushalten'
     C                   when      %subst(producttyp: 1: 3) = '9-1'
     c                   eval      producttyp=
     c                             'Überwachungs.- u.Kontrollinstrumente' +
     c                             ' f.d. Nutzung in privaten Haushalten'
     C                   when      %subst(producttyp: 1: 3) = '9-2'
     c                   eval      producttyp=
     c                             'Überwachungs.- u.Kontrollinstrumente' +
     c                             ' für ausschließlich gewerbliche Nutzung'
     c                   other
     c                   eval      producttyp = producttyp
     c                   endsl
     C
     c                   update    phy01r
     C                   endif
     C                   enddo
     c                   close     environmv2

     C     ##8000        ENDSR

     C**************************************************************************
     C*abschluss
     C*-------------------------------------------------------------------------

     C     sr8001        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8001
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ insert into tvrelwaeco/ummfile2v2
     c+ select      substr(rkreda, 1, 4)     r_year,
     c+ APTENR, T4000, M40001, M40002, T4010, M40101, M40102, M40103,
     c+ APTENR, T4000, M40001, M40002, T4010, M40101, M40102, M40103,
     c+  T4020, M40201, M40202, M40203,
     c+ dec(sum(jana), 13, 2) jana, dec(sum(feba), 13, 2) feba,
     c+ dec(sum(maea), 13, 2) maea, dec(sum(apra), 13, 2) apra,
     c+ dec(sum(maia), 13, 2) maia, dec(sum(juna), 13, 2) juna,
     c+ dec(sum(jula), 13, 2) jula, dec(sum(auga), 13, 2) auga,
     c+ dec(sum(sepa), 13, 2) sepa, dec(sum(okta), 13, 2) okta,
     c+ dec(sum(nova), 13, 2) nova, dec(sum(deza), 13, 2) deza,
     c+ APPRGR,TEPRGR,DIVISION,ARTNR,       ARTBEZFRA
     c+ from  ummfile1v2
     c****+ where (T4000<>' ' or T4010<>' ' or T4020<>' ')
     c+ GROUP BY substr(RKREDA, 1, 4),
     c+ APTENR, T4000, M40001, M40002, T4010, M40101, M40102, M40103,
     c+  T4020, M40201, M40202, M40203,
     c+ APPRGR,TEPRGR,DIVISION,ARTNR,       ARTBEZFRA
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/ummfile3v2
     c+ SELECT APTENR,ARTNR, case when T4000='4000' then 'J' else 'N' end
     c+ as duales_sys, dec(M40001, 8, 2) Paper,dec(M40002, 8, 2) Plastic,
     c+ case when T4010 ='4010' then 'J' else 'N' end as
     c+ electro,dec(M40101, 6, 2) netweight, char(M40102, 2)classwaste,
     c+ char(M40103, 4) producttyp, case when T4020='4020' then 'J' else
     c+ 'N' end as Batterie, dec(M40201, 8, 2) weightclass,dec(M40202, 8,
     c+ 2) batt_class, dec(M40203, 8, 2) batt_type, dec(0, 3, 0)
     c+ batt_count, dec(0, 7, 2) batt_weight,JANA, FEBA, MAEA, APRA, MAIA,
     c+ JUNA, JULA, AUGA, SEPA, OKTA, NOVA, DEZA,APPRGR, TEPRGR, DIVISION
     c+ FROM tvrelwaeco/ummfile2v2 ORDER BY aptenr
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/ENVIRONMV2
     c+ sELECT r_year,APTENR, char(' ', 1) rpm1,artnr,char(' ', 1) rpm2,
     c+              char(' ', 50) descript,char(' ', 15) replace,
     c+                      case when T4000='4000' then 'J' else 'N' end
     c+ as duales_sys, dec(M40001, 8, 2) Paper,dec(M40002, 8, 2) Plastic,
     c+ case when T4010 ='4010' then 'J' else 'N' end as
     c+ electrog,dec(M40101, 7, 2) netweight, char(M40102, 25)classwaste,
     c+ char(M40103, 80) producttyp, case when T4020='4020' then 'J' else
     c+ 'N' end as Batterie,
     c+ char (substr(M40201, 1, 3), 15) weight_cl,
     c+ char (substr(M40201, 1, 3), 25) batt_cl,
     c+ char (substr(M40201, 1, 3), 50) batt_type,
     c+ dec(M40202, 3, 0) batt_count,
     c+ dec(M40203, 7, 2) batt_weight,JANA,FEBA,MAEA,APRA,MAIA,JUNA,JULA,
     c+ AUGA,SEPA,OKTA,NOVA,DEZA,APPRGR,TEPRGR, DIVISION,
     c+ char(' ', 50) skudes,char(' ', 10) skumodel,char(' ', 30) factory,
     c+ char(' ', 04) country,char(' ', 30) master,char(' ', 30) status,
     c+ char(' ', 30) brand FROM tvrelwaeco/ummfile2v2 ORDER BY APTENR
     c/end-exec

     C                   exsr      sr8000

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.descript=
     c+ (select b.artbez from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.APTENR= b.ARTNR)                      )
     c+ where exists
     c+ (select b.artbez from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.APTENR= b.ARTNR)                      )
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.descript=
     c+ (select b.artbez from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.artnr = b.artnr and a.descript=' ' ))
     c+ where exists
     c+ (select b.artbez from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.artnr = b.artnr and a.descript=' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.replace=
     c+ (select b.E1 from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.APTENR= b.ARTNR)                      )
     c+ where exists
     c+ (select b.E1 from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.APTENR= b.ARTNR)                      )
     c/end-exec


     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.replace=
     c+ (select b.E1 from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.artnr = b.artnr and a.replace=' ' ))
     c+ where exists
     c+ (select b.E1 from bar_kalk/kalk_file b
     c+  WHERE version = '$$EL_PS_DB' and
     c+  (a.artnr = b.artnr and a.replace=' ' ))
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set length=
     c+ (select LAENGE FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and LENGTH=0)
     c+ where exists
     c+ (select LAENGE FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and LENGTH=0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set length=
     c+ (select LAENGE FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr and LENGTH=0)
     c+ where exists
     c+ (select LAENGE FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr and LENGTH=0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set width =
     c+ (select breite FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and width =0)
     c+ where exists
     c+ (select breite FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and width =0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set width =
     c+ (select breite FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and width =0)
     c+ where exists
     c+ (select breite FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and width =0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set hight =
     c+ (select hoehe  FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and hight =0)
     c+ where exists
     c+ (select hoehe  FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and hight =0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set hight =
     c+ (select hoehe  FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and hight =0)
     c+ where exists
     c+ (select hoehe  FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and hight =0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set GROSSWEI=
     c+ (select gewicht FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and GROSSWEI=0)
     c+ where exists
     c+ (select gewicht FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.APTENR and GROSSWEI=0)
     c/end-exec

     c/exec sql
     c+ update ENVIRONMV2 b set GROSSWEI=
     c+ (select gewicht FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and GROSSWEI=0)
     c+ where exists
     c+ (select gewicht FROM bar_kalk/kalk_file a where
     c+  version='$$EL_PS_DB' and a.artnr=b.artnr  and GROSSWEI=0)
     c/end-exec

     c*/exec sql
     c*+ insert into  tvrelwaeco/UMMFILE3
     c*+ SELECT APTENR, ARTBEZ, ARTGRP, STATNR, ABC, JANA, FEBA, MAEA, aPRA,
     c*+ MAIA, JUNA, JULA, AUGA, SEPA, OKTA, NOVA, DEZA, T4000, M40001,
     c*+ M40002, T4010, M40101, M40102, M40103,
     c*+                        T4020, M40201, M40202, M40203, GEWICHT,
     c*+ LAENGE, BREITE, HOEHE, current timestamp tstamp FROM ummfile2,
     c*+ bar_kalk/kalk_file WHERE version = '$$EL_PS_DB' and APTENR= ARTNR
     c*+ ORDER BY artnr
     c*/end-exec


     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.rpm1='J'
     c+ WHERE a.APTENR in (select sku from tvrelwaeco/domstruc_o)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.rpm2='J'
     c+ WHERE a.Artnr in (select sku from tvrelwaeco/domstruc_o)
     c/end-exec

     C*descript
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.skudes =
     c+ (select b.skudes from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.skudes=' ' ))
     c+ where exists
     c+ (select b.skudes from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.skudes=' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.skudes =
     c+ (select b.skudes from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.skudes=' ' ))
     c+ where exists
     c+ (select b.skudes from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.skudes=' ' ))
     c/end-exec

     C*SKUMODEL
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.SKUMODEL =
     c+ (select b.P_SKUMODEL from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.SKUMODEL=' ' ))
     c+ where exists
     c+ (select b.P_SKUMODEL from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.SKUMODEL=' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.SKUMODEL =
     c+ (select b.P_SKUMODEL from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.SKUMODEL=' ' ))
     c+ where exists
     c+ (select b.P_SKUMODEL from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.SKUMODEL=' ' ))
     c/end-exec

     C*FACTORY
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.FACTORY  =
     c+ (select b.P_FACTORY  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.FACTORY =' ' ))
     c+ where exists
     c+ (select b.p_FACTORY  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.FACTORY =' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.FACTORY  =
     c+ (select b.p_FACTORY  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.FACTORY =' ' ))
     c+ where exists
     c+ (select b.p_FACTORY  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.FACTORY =' ' ))
     c/end-exec

     C*COUNTRY
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.COUNTRY  =
     c+ (select b.p_COUNTRYc  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.COUNTRY =' ' ))
     c+ where exists
     c+ (select b.P_COUNTRYc  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.COUNTRY =' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.COUNTRY  =
     c+ (select b.P_COUNTRYc  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.COUNTRY =' ' ))
     c+ where exists
     c+ (select b.P_COUNTRYc  from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.COUNTRY =' ' ))
     c/end-exec

     C*MASTER
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.MASTER   =
     c+ (select b.itemMASTER   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.MASTER  =' ' ))
     c+ where exists
     c+ (select b.itemMASTER   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.MASTER  =' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.MASTER   =
     c+ (select b.itemMASTER   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.MASTER  =' ' ))
     c+ where exists
     c+ (select b.itemMASTER   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.MASTER  =' ' ))
     c/end-exec

     C*STATUS
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.STATUS   =
     c+ (select b.STATUS_sku   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.STATUS  =' ' ))
     c+ where exists
     c+ (select b.STATUS_sku   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.STATUS  =' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.STATUS   =
     c+ (select b.STATUS_sku   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.STATUS  =' ' ))
     c+ where exists
     c+ (select b.STATUS_sku   from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.STATUS  =' ' ))
     c/end-exec

     C*brand
     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.brand    =
     c+ (select b.brand        from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.brand   =' ' ))
     c+ where exists
     c+ (select b.brand        from tvrelwaeco/domstruc_o b
     c+  WHERE (a.aptenr= b.sku and a.brand   =' ' ))
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/ENVIRONMV2 a set a.brand    =
     c+ (select b.brand        from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.brand   =' ' ))
     c+ where exists
     c+ (select b.brand        from tvrelwaeco/domstruc_o b
     c+  WHERE (a.artnr = b.sku and a.brand   =' ' ))
     c/end-exec


     C     ##8001        ENDSR


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
