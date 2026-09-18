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

     C*Grundaufbau Umweltmanagementfile
     c/exec sql
     c+ insert into tvrelwaeco/ummfile1
     c+ SELECT char(substr(rkreda, 1, 6)) RKREDA, APTENR ,APGLMG, ADPOLD,
     c+ char(' ', 4) T4000, char(' ', 10) M40001, char(' ', 10) M40002,
     c+ char(' ', 4) T4010, char(' ', 10) M40101,
     c+ char(' ', 4) T4020, char(' ', 10) M40201, char(' ', 10) M40202,
     c+ char(' ', 10) M40203, char(' ', 4) T1000, char(' ', 10) M10008
     c+ FROM afad,statistik
     c+ WHERE ADAART ='ADVS' and adpold = 'DE' and
     c+ akaFNR = AdAFNR and AKAFJJ = ADAFJJ
     c/end-exec

     C*TEOS 4000
     c/exec sql
     c+ update ummfile1       set T4000  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'))
     c/end-exec
     c+
     C*TEOS 4010
     c+ update ummfile1       set T4010  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000')                            )
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4010' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000')                            )
     c/end-exec
     c+
     C*TEOS 4020
     c/exec sql
     c+ update ummfile1       set T4020  =
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c+ where exists
     c+ (select TEOSKLCD from teos where APTENR = TEOSTENR and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4020' and TEOSMM01 ='J'
     c+    and  (TEOSMM02 <> '0000000000' or TEOSMM03 <> '0000000000'
     c+                                   or TEOSMM04 <> '0000000000'))
     c/end-exec
     c+
     C*TEOS 40001 Papier/Pappe in Gramm
     c/exec sql
     c+ update ummfile1       set M40001 =
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM02 from teos where APTENR = TEOSTENR and
     c+         TEOSMM02 <> '0000000000' and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c+
     C*TEOS 40002 Kunststoff in Gramm
     c/exec sql
     c+ update ummfile1       set M40002 =
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c+ where exists
     c+ (select TEOSMM03 from teos where APTENR = TEOSTENR and
     c+         TEOSMM03 <> '0000000000' and
     c+         TEOSFIRM ='01' and TEOSKLCD ='4000' and TEOSMM01 ='J')
     c/end-exec
     c+
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
