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

     C*Grundaufbau patrikII
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKII
     c+ SELECT     *
     c+ from FBUBEW00
     c+ WHERE BUB0_FIRMA = 51 and
     c+       BUB0_BUPJJM > '201000' and
     c+       ( BUB0_KTO ='311010000' or
     c+         BUB0_KTO ='311020000' or
     c+         BUB0_KTO ='311030000' )
     c/end-exec

     C*Grundaufbau patrikIII
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKIII
     c+ SELECT     *
     c+ from patrikII, FBUTXT00
     c+ WHERE BTX0_FIRMA = 51 and
     c+       BTX0_LFDBUCHNR = PATRIKII.BUB0_LFDBUCHNR and
     c+       BTX0_BUTXTART='I' and
     c+       BTX0_LFDBUCHPOS = 0
     c/end-exec

     C*Grundaufbau patrikIIIb
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKIIIb
     c+ SELECT     distinct
     c+            BUB0_BELEGNR,
     c+            BTX0_BELEGTXT0001,
     c+            BUB0_BELEGJJMT,
     c+            sum(BUB0_EUDM)
     c+ FROM patrikIII
     c+ group by  BUB0_BELEGNR,
     c+           BTX0_BELEGTXT0001,
     c+           BUB0_BELEGJJMT
     c/end-exec

     C*Grundaufbau patrikIV
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKIV
     c+ SELECT     BUB0_BELEGNR,
     c+            BTX0_BELEGTXT0001,
     c+            BUB0_BELEGJJMT,
     c+            dec(sum(BUB0_EUDM ), 13, 2) Euro ,
     c+            dec(count(*), 13, 2) c,
     c+            dec(0, 13, 2) quantity,
     c+            dec(0, 13, 2) stk3,
     c+            zoned(0, 8) RKREDA FROM
     c+ patrikIIIb GROUP BY BUB0_BELEGNR,
     c+                     BTX0_BELEGTXT0001,
     c+                     BUB0_BELEGJJMT
     c/end-exec

     C*Grundaufbau  patrikV
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKV
     c+ SELECT RPRGJJ,RKRGNR,RPTENR,rkreda,
     c+        dec(sum(APGLMG), 13, 2) APGLMG
     c+ FROM statistik
     c+ GROUP BY RPRGJJ,RKRGNR ,RPTENR,rkreda
     c/end-exec

     C*update
     c/exec sql
     c+ update patrikIV       set quantity=
     c+ (select APGLMG from patrikV where char(RPRGJJ) =
     c+  char(substr(BUB0_BELEGNR, 1, 4)) and
     c+  RKRGNR = char(substr(BUB0_BELEGNR, 5, 6)) and
     c+  RPTENR = char(substr(BTX0_BELEGTXT0001, 1, 15)))
     c+ where exists
     c+  (select APGLMG from patrikV where char(RPRGJJ) =
     c+   char(substr(BUB0_BELEGNR, 1, 4)) and
     c+   RKRGNR = char(substr(BUB0_BELEGNR, 5, 6)) and
     c+   RPTENR = char(substr(BTX0_BELEGTXT0001, 1, 15)))
     c/end-exec

     C*update
     c/exec sql
     c+ update patrikIV       set rkreda  =
     c+ (select rkreda from patrikV where char(RPRGJJ) =
     c+  char(substr(BUB0_BELEGNR, 1, 4)) and
     c+  RKRGNR = char(substr(BUB0_BELEGNR, 5, 6)) and
     c+  RPTENR = char(substr(BTX0_BELEGTXT0001, 1, 15)))
     c+ where exists
     c+  (select rkreda from patrikV where char(RPRGJJ) =
     c+   char(substr(BUB0_BELEGNR, 1, 4)) and
     c+   RKRGNR = char(substr(BUB0_BELEGNR, 5, 6)) and
     c+   RPTENR = char(substr(BTX0_BELEGTXT0001, 1, 15)))
     c/end-exec

     C*...
     c/exec sql
     c+ update patrikIV set stk3=EURO/quantity where quantity <> 0
     c/end-exec

     C*...
     c/exec sql
     c+ update patrikIV set stk3=stk3 * -1  where stk3 < 0
     c/end-exec

     C*Grundaufbau  PATRIKVI
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKVI
     c+ SELECT BTX0_BELEGTXT0001  artikel,
     c+        min(BUB0_BELEGJJMT) dateschil,
     c+        STK3,
     c+        min(RKREDA) dateRech,
     c+        dec(sum(euro), 13, 2) euro,
     c+        dec(sum( QUANTITY), 13, 2) quantity
     c+ FROM patrikIV GROUP BY
     c+        BTX0_BELEGTXT0001,
     c+        STK3
     c/end-exec

     C*Grundaufbau  PATRIKVII
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKVII
     c+ SELECT artikel,
     c+        dec(count(*), 13, 2) c
     c+ FROM patrikVI GROUP BY
     c+        artikel
     c/end-exec

     C*Grundaufbau  PATRIKVIII
     c/exec sql
     c+ insert into tvrelwaeco/PATRIKVIII
     c+ SELECT PATRIKVI.ARTIKEL,
     c+        DATESCHIL,
     c+        STK3, DATERECH,
     c+        EURO, QUANTITY,
     c+        PATRIKVII.C,
     c+        current timestamp tstamp
     c+ FROM patrikVI, patrikvII
     c+ WHERE  PATRIKVI.ARTIKEL = PATRIKVII.ARTIKEL
     c+ ORDER  BY PATRIKVI.ARTIKEL, PATRIKVI.DATERECH
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
