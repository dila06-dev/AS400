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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     c
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   exsr      sr3000
     C                   EXSR      RETURN
     c

     C**************************************************************************
     C*total
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/FREEZEwrk
     c+ SELECT APKDNR, APAFJJ, APAFNR, APAFPO , APAFST, APBSMG, APGLMG,
     c+ APTENR, APMAAF ,timestamp(ApJDAT concat digits(ApJZEI)) tstamp,
     c+ char('  ') freeze, current timestamp tstampp
     c+           FROM afpo WHERE apkdnr in (select SALES# from
     c+ salescomp) and timestamp (ApJDAT concat digits(ApJZEI)) > (select
     c+ tstamp from confirmbr)
     c/end-exec
     c
     C     ##1000        ENDSR

     C**************************************************************************
     C*Verarbeitung
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/FREEZE
     c+ SELECT APKDNR, APAFJJ, APAFNR FROM freezewrk WHERE ( APGLMG <>0
     c+ or apafst > '17') and tstamp > (select tstamp from confirmbr)
     c+ GROUP BY APKDNR, APAFJJ, APAFNR
     c/end-exec
     c
     c/exec sql
     c+ insert into tvrelwaeco/unFREEZE
     c+ SELECT zoned((apkdnr), 7) C010, char(apmaaf, 10) C020,
     c+ zoned(digits(APafpo*0), 5) C030, char (' ', 1) c040, char(APAFJJ
     c+ concat '/' concat char(APAFNR) concat '/' concat
     c+ char(digits(APAFPO)), 20) c050, tstamp c060, APTENR c070,
     c+ char('00', 2) c080 FROM freezewrk WHERE APGLMG = 0 and apafst <
     c+ '18' and apafnr not in (select APAFNR from tvrelwaeco/FREEZE where
     c+ apkdnr=apkdnr and apafjj=apafjj)
     c/end-exec
     c
     c/exec sql
     c+ update  unfreeze a set a.c030 =
     c+ (select max(c030) from confirm where a.c050 = c070 group by c030)
     c+  where exists
     c+ (select max(c030) from confirm where a.c050 = c070 group by c030)
     c/end-exec
     c
     C     ##2000        ENDSR

     C**************************************************************************
     C*changes selektiv
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##3000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ update confirmbr set tstamp =
     c+ (SELECT current timestamp tstamp FROM qsys2/qsqptabl)
     c/end-exec
     c
     C     ##3000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

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
