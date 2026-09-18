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

     fdualsys   uf   e             disk
     f                                     RENAME(dualsys:phy01r)
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
     c                   exsr      sr2000

     C                   EXSR      RETURN

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

     C*clear
     c/exec sql
     c+ delete   from  DUALSYS
     c/end-exec
     c*
     C*Grundaufbau Umweltmanagementfile
     c/exec sql
     c+ insert into tvrelwaeco/DUALSYS
     c+ SELECT ARTNR,ARTBEZ,ARTGRP, STATNR, ABC, LIEFERANT1, LIEFERANT2,
     c+ KCJMNG_AJ , KCJMNG_vj,  ARTZ3,icss Gewichtnet,icns laenge, exss
     c+ breite, exns volumen, e1,e2, e3,e4,
     c+ char(' ', 4) T4000, char(' ', 10) M40001, char(' ', 10) M40002,
     c+ char(' ', 4) T4010, char(' ', 10) M40101, char(' ', 10) M40102,
     c+                     char(' ', 10) M40103,
     c+ char(' ', 4) T4020, char(' ', 10) M40201, char(' ', 10) M40202,
     c+ char(' ', 10) M40203,
     c+ char(' ', 10) M40303, char(' ', 4) T1000, char(' ', 10) M10008,
     c+ tstamp
     c+ FROM bar_kalk/kalk_file WHERE version='$$EL_PS_DB'
     c/end-exec

     C*TEOS 4000
     c/exec sql
     c+ update DUALSYS         set T4000  =
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where artnr  = TEOSTENR and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c/end-exec
     c*
     C*TEOS 4010
     c/exec sql
     c+ update dualsys        set T4010  =
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
     c+ update dualsys         set T4020  =
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
     c+ update dualsys         set M40001 =
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where artnr  = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update dualsys         set M40002 =
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where artnr  = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c*
     C*TEOS 40101 Grundgewicht Elektro
     c/exec sql
     c+ update dualsys         set M40101 =
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
     c+ update dualsys         set M40102 =
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
     c+ update dualsys         set M40103 =
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
     c+ update dualsys         set M40201 =
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
     c+ update dualsys        set M40202 =
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
     c+ update dualsys        set M40203 =
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4020' and TEOSMM01 ='J')
     c/end-exec
     c
     C*TEOS 40303 Holz
     c/exec sql
     c+ update dualsys        set M40303 =
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM04 from teos where artnr  = TEOSTENR and
     c+         TEOSMM04 <> '0000000000' and
     c+         TEOSFIRM in ('01', '51')
     c+                        and TEOSKLCD ='4030' and TEOSMM01 ='J')
     c/end-exec
     c*
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

     C                   open      dualsys

     C                   DO        *HIVAL
     C                   READ      dualsys                                95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c                   update    phy01r
     C                   endif
     C                   enddo
     c                   close     dualsys

     C     ##8000        ENDSR

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
