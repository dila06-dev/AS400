     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      * create index tvrelwaeco/AVISHELLl1
      * on TVRELWAECO/AVISHELLPF(APAFJJ,APAFNR,ALLIJJ,ALLINR)
      * Index AVISHELLL1 in TVRELWAECO für Tabelle AVISHELLPF in TVRELWAECO
      *
      * create index tvrelwaeco/LBLBHELLl1
      * on TVRELWAECO/LBLBHELLpf(#AEWEJJ,#AEWENR)
      * Index LBLBHELLL1 in TVRELWAECO für Tabelle LBLBHELLPF in TVRELWAECO
      *
      * SELECT * FROM AVISorder ORDER BY substr(AVISORDER, 3, 12) ,
      *                                  substr(AVISORDER, 1, 01)
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
b
     D**********************************************************************
     D Wrk             DS                  Qualified inz
     D Var1                         200A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*...
     C*Wareneingänge

     C                   exsr      sr9000
     C                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Sätze update
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

     C*Grundaufbau Neuaufnahme (nicht löschen diese Dateí Historie)
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR1
     c+ SELECT EkLFNR, EpBEJJ, EpBENR , epmeng, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, epbest , dec( (days (date(substr(char(EPBETE), 1, 4) concat
     c+ '-' concat substr(char(EPBETE), 5, 2) concat '-' concat
     c+ substr(char(EPBETE), 7, 2) )) - days(current date) ), 8, 0) differ,
     c+ current timestamp FROM bbek, bbep WHERE EKFIRM=epFIRM and
     c+ EKBEJJ=epbeJJ and EKBENR=EpBENR and epbejj>2011 and epbest < '30'
     c+ and ekfirm in ('01', '51') and epfirm in ('01', '51')
     c/end-exec

     C*abschliessende Analyse  aus db_optlfr1
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR2
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, dec(max(differ), 8, 0) maximal , dec(min(differ),
     c+ 8, 0) minimal , dec(count(*), 8, 0) count, current timestamp FROM
     c+ DB_OPTLFR1 GROUP BY EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO,
     c+ EKBEDA, EPBETE, EPBEST ORDER BY EKLFNR, EPBEJJ, EPBENR
     c/end-exec

     C*Abstimmung mit WE's 825
     c/exec sql
     c+ insert into tvrelwaeco/DB_OBT_WAE
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,#AEBEJJ,#AEBENR,#AEBEPO,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE #STORNO<>'J' and  #LBLBLSTC in
     c+   ('825','825','825','825','825','825','000','000','000') and
     c+   #STORNO <> 'J' and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) >year(current date -1 year)
     c/end-exec

     C*abschliessende Analyse mit Zuordnung WE's
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR3
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, MAXIMAL, MINIMAL, "COUNT", SEL0013, #LBLBLSTC,
     c+ #LBLBTENR, #LBLBBDAT, #LBLBBWMG, #LBLBBWME, #LBLBLGBS, #AEBEJJ,
     c+ #AEBENR, #AEBEPO, SEL0010, SEL0011, SEL0012, TSTAMP,
     c+ dec(0, 12, 2) a001, char(' ', 50) Name                 FROM
     c+ DB_OPTLFR2, DB_OBT_WAE WHERE EPBEJJ = #AEBEJJ and EPBENR = #aeBENR
     c+ and EPBEPO = #aeBEPO
     c/end-exec

     C*abschliessende Analyse ohne WE's
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR3
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, MAXIMAL, MINIMAL, "COUNT", SEL0013, ' ' #LBLBLSTC,
     c+ ' ' #LBLBTENR, 0 #LBLBBDAT, 0 #LBLBBWMG, ' ' #LBLBBWME,
     c+ 0  #LBLBLGBS, 0 #AEBEJJ, ' ' #AEBENR, 0  #AEBEPO,
     c+ 0  SEL0010, 0 SEL0011, 0 SEL0012, current timestamp TSTAMP,
     c+ dec(0, 12, 2) a001, char(' ', 50) Name                     FROM
     c+ DB_OPTLFR2    WHERE  epbejj not in ( select #AEBEJJ from DB_OBT_WAE
     c+ where  EPBENR=#aeBENR and  EPBEPO =#aeBEPO)
     c/end-exec

     c/exec sql
     c+ update DB_OPTLFR3  set a001=
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_Lg  WHERE eptenr= LBBSTENR and
     c+  LBBSLANR in ('130','060','070','100','400','110','410','001',
     c+               '200','300','240')
     c+  group by LBBSTENR )
     c+  where exists
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_Lg  WHERE eptenr= LBBSTENR and
     c+  LBBSLANR in ('130','060','070','100','400','110','410','001',
     c+               '200','300','240')
     c+  group by LBBSTENR )
     c/end-exec

     c/exec sql
     c+ update DB_OPTLFR3  set Name  =
     c+ (SELECT LFNAM1 FROM lief01 WHERE EKLFNR= LFLFNR and LFFIRM='01')
     c+  where exists
     c+ (SELECT LFNAM1 FROM lief01 WHERE EKLFNR= LFLFNR and LFFIRM='01')
     c/end-exec

     C     ##1000        ENDSR
     c*
     C**************************************************************************
     C*t...
     C*-------------------------------------------------------------------------

     C     sr9000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/DB_OPTLFR2';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/DB_OPTLFR3';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/DB_OBT_WAE';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##9000        ENDSR

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
