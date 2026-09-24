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
      *
      * SELECT ITEMSERV.ITEM, KALK_FILE.ARTSKU,ITEMSERV.DUTY#,
      * ULAND,WEIGHT,dec((WEIGHT-((dec(M40001)+dec(M40002)+dec(M40303))/1000
      * )), 13, 4) netWEIGHT, REPLACEM, LENGTH, WIDTH, HEIGHT , dec(M40001)
      * paper,dec(M40002) plastic, dec(M40303) wood, SC_ITEM, QUANTITY,
      * TURNOVER FROM itemserv, bar_kalk/kalk_file,umweltfile WHERE
      * ITEMSERV.ITEM =artnr and APTENR =artnr and version='$$EL_PS_DB'
      *  and artnr <> 'U2012000AT27' and artnr <> 'U2600000FB24'
      *  and artnr <> '8880100324  ' and artnr <> 'U2600000FB24'
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fUMMFILEb1 uf   e             disk
     f                                     RENAME(ummfileb1:phy01r)
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
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   seton                                        30
     c  n30              exsr      sr1000
     c   30              exsr      sr2000
     c  n30              exsr      sr8000
     c  n30              exsr      sr8001

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
     c+ insert into tvrelwaeco/ummfileb1
     c+ SELECT distinct
     c+        char(substr(rkreda, 1, 6)) RKREDA, APTENR ,APGLMG, ADPOLD,
     c+ char(' ', 4) T4000, char(' ', 10) M40001, char(' ', 10) M40002,
     c+ char(' ', 4) T4010, char(' ', 10) M40101, char(' ', 10) M40102,
     c+                     char(' ', 10) M40103,
     c+ char(' ', 4) T4020, char(' ', 10) M40201, char(' ', 10) M40202,
     c+ char(' ', 10) M40203,
     c+ char(' ', 10) M40303, char(' ', 4) T1000, char(' ', 10) M10008,
     c+ dec(0, 13, 2) jana, dec(0, 13, 2) feba,
     c+ dec(0, 13, 2) maea, dec(0, 13, 2) apra,
     c+ dec(0, 13, 2) maia, dec(0, 13, 2) juna,
     c+ dec(0, 13, 2) jula, dec(0, 13, 2) auga,
     c+ dec(0, 13, 2) sepa, dec(0, 13, 2) okta,
     c+ dec(0, 13, 2) nova, dec(0, 13, 2) deza,APAFJJ,APAFNR,APAFPO,ADAART
     c+ FROM afad,statistik
     c+ WHERE                   ADAART in('ADVS', 'ADAG')
     c+                     and akaFNR = AdAFNR and AKAFJJ = ADAFJJ
     c******                and AKKDNR not in (select kdnr from ummfile6)
     c+                     and ADFIRM in ('01', '51')
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ insert into tvrelwaeco/ummfileb4
     c+ SELECT APAFJJ, APAFNR, APAFPO, count(*) FROM ummfileb1 GROUP BY
     c+ APAFJJ, APAFNR, APAFPO HAVING count(*) > 1
     c/end-exec

     C*doppelte ermitteln
     c/exec sql
     c+ delete from ummfileb1 where
     c+ adaart = 'ADAG' and APAFnr in
     c+    (select ummfileb4.apafnr from ummfileb4 where
     c+            ummfileb1.APAFJJ= ummfileb4.APAFJJ
     c+        and ummfileb1.APAFnr= ummfileb4.APAFnr
     c+        and ummfileb1.APAFpo= ummfileb4.APAFpo  )
     c/end-exec

     C*TEOS 4000
     c/exec sql
     c+ update ummfileb1       set T4000  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 4010
     c/exec sql
     c+ update ummfileb1      set T4010  =
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
     c+ update ummfileb1       set T4020  =
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
     c+ update ummfileb1       set M40001 =
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update ummfileb1       set M40002 =
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40101 Grundgewicht Elektro
     c/exec sql
     c+ update ummfileb1       set M40101 =
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
     c+ update ummfileb1       set M40102 =
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
     c+ update ummfileb1       set M40103 =
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
     c+ update ummfileb1       set M40201 =
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
     c+ update ummfileb1      set M40202 =
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
     c+ update ummfileb1      set M40203 =
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
     c*
     C*TEOS 40303 Holz
     c/exec sql
     c+ update ummfileb1      set M40303 =
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c/end-exec
     c*
     c*
     C     ##1000        ENDSR
     c*
     c*
     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##2000
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
     c+ insert into tvrelwaeco/ummfileall
     c+ select substr(char(current timestamp), 1, 4) concat
     c+        substr(char(current timestamp), 6, 2) RKREDA,
     c+ artnr aptenr, zoned(0, 11, 2) apglmg, char('   ', 3) ADPOLD,
     c+ char(' ', 4) T4000, char(' ', 10) M40001, char(' ', 10) M40002,
     c+ char(' ', 4) T4010, char(' ', 10) M40101, char(' ', 10) M40102,
     c+                     char(' ', 10) M40103,
     c+ char(' ', 4) T4020, char(' ', 10) M40201, char(' ', 10) M40202,
     c+ char(' ', 10) M40203,
     c+ char(' ', 10) M40303, char(' ', 4) T1000, char(' ', 10) M10008,
     c+ dec(0, 13, 2) jana, dec(0, 13, 2) feba,
     c+ dec(0, 13, 2) maea, dec(0, 13, 2) apra,
     c+ dec(0, 13, 2) maia, dec(0, 13, 2) juna,
     c+ dec(0, 13, 2) jula, dec(0, 13, 2) auga,
     c+ dec(0, 13, 2) sepa, dec(0, 13, 2) okta,
     c+ dec(0, 13, 2) nova, dec(0, 13, 2) deza,
     c+ zoned(0, 4, 0) APAFJJ, char(' ', 6) APAFNR,
     c+ zoned(0, 4, 0) APAFPO, char(' ', 4) ADAART
     c+ FROM bar_kalk/kalk_file  WHERE  version ='$$EL_PS_DB'
     c/end-exec

     C*TEOS 4000
     c/exec sql
     c+ update ummfileall      set T4000  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 4010
     c/exec sql
     c+ update ummfileall     set T4010  =
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
     c+ update ummfileall      set T4020  =
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
     c+ update ummfileall      set M40001 =
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update ummfileall      set M40002 =
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40101 Grundgewicht Elektro
     c/exec sql
     c+ update ummfileall      set M40101 =
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
     c+ update ummfileall      set M40102 =
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
     c+ update ummfileall      set M40103 =
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
     c+ update ummfileall      set M40201 =
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
     c+ update ummfileall     set M40202 =
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
     c+ update ummfileall     set M40203 =
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
     c
     C*TEOS 40303 Holz
     c/exec sql
     c+ update ummfileall     set M40303 =
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where APTENR = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c/end-exec
     c*
     c*
     C*Ausgabe (derzeit)
     c/exec sql
     c+ insert into tvrelwaeco/UMWELTFILE
     c+ SELECT RKREDA, APTENR, T4000, M40001, M40002, T4010, M40101,
     c+ M40102, M40103, T4020, M40201, M40202, M40203,
     c+ M40303, T1000, M10008
     c+ ARTBEZ, ARTGRP, STATNR, ABC, LIEFERANT1, LIEFERANT2, ZOLLNR, ARTZ1,
     c+ ARTZ2, ARTZ3, EVP_N_BR, ARTGEW, E1, LAENGE, BREITE, HOEHE, GEWICHT,
     c+ VLAENGE, VBREITE, VHOEHE FROM ummfileall, bar_kalk/kalk_file WHERE
     c+ APTENR=artnr and version ='$$EL_PS_DB'
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40001  = case
     c+ When M40001   = '          ' then '0000000000'
     c+ else m40001
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40002  = case
     c+ When M40002   = '          ' then '0000000000'
     c+ else m40002
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40101  = case
     c+ When M40101   = '          ' then '0000000000'
     c+ else M40101
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40102  = case
     c+ When M40102   = '          ' then '0000000000'
     c+ else M40102
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40103  = case
     c+ When M40103   = '          ' then '0000000000'
     c+ else M40103
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40201  = case
     c+ When M40201   = '          ' then '0000000000'
     c+ else M40201
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40202  = case
     c+ When M40202   = '          ' then '0000000000'
     c+ else M40202
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set m40203  = case
     c+ When M40203   = '          ' then '0000000000'
     c+ else M40203
     c+ end
     c/end-exec
     c*
     c/exec sql
     c+ update  tvrelwaeco/umweltfile   set M40303  = case
     c+ When M40303   = '          ' then '0000000000'
     c+ else M40303
     c+ end
     c/end-exec
     c*
     C     ##2000        ENDSR
     c*
     c*
     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR

     C                   open      UMMFILEb1

     C                   DO        *HIVAL
     C                   READ      UMMFILEb1                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   movel     rkreda        #rkreda           8
     C                   if        %subst(#RKREDA: 1: 4) = '2012'
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA = JANA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA = FEBA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA = MAEA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA = APRA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA = MAIA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA = JUNA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA = JULA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA = AUGA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA = SEPA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA = OKTA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA = NOVA + (APGLMG)
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA = DEZA + (APGLMG)
     c                   other
     c                   endsl
     c                   update    phy01r
     C                   endif
     C                   endif
     C                   enddo
     c                   close     UMMFILEb1

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
     c+ insert into tvrelwaeco/ummfileb2
     c+ select
     c+ APTENR, T4000, M40001, M40002, T4010, M40101, M40102, M40103,
     c+  T4020, M40201, M40202, M40203, M40303,
     c+ dec(sum(jana), 13, 2) jana, dec(sum(feba), 13, 2) feba,
     c+ dec(sum(maea), 13, 2) maea, dec(sum(apra), 13, 2) apra,
     c+ dec(sum(maia), 13, 2) maia, dec(sum(juna), 13, 2) juna,
     c+ dec(sum(jula), 13, 2) jula, dec(sum(auga), 13, 2) auga,
     c+ dec(sum(sepa), 13, 2) sepa, dec(sum(okta), 13, 2) okta,
     c+ dec(sum(nova), 13, 2) nova, dec(sum(deza), 13, 2) deza
     c+ from  ummfileb1
     c+ where (T4000<>' ' or T4010<>' ' or T4020<>' ')
     c+ GROUP BY
     c+ APTENR, T4000, M40001, M40002, T4010, M40101, M40102, M40103,
     c+  T4020, M40201, M40202, M40203, M40303
     c/end-exec

     c/exec sql
     c+ insert into  tvrelwaeco/UMMFILEb3
     c+ SELECT APTENR, ARTBEZ, ARTGRP, STATNR, ABC, JANA, FEBA, MAEA, aPRA,
     c+ MAIA, JUNA, JULA, AUGA, SEPA, OKTA, NOVA, DEZA, T4000, M40001,
     c+ M40002, T4010, M40101, M40102, M40103,
     c+              T4020, M40201, M40202, M40203, M40303, GEWICHT,
     c+ LAENGE, BREITE, HOEHE, current timestamp tstamp FROM ummfileb2,
     c+ bar_kalk/kalk_file WHERE version = '$$EL_PS_DB' and APTENR= ARTNR
     c+ ORDER BY artnr
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
