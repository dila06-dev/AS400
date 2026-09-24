     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
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
      * update DIRMAIL/DMITMHDR
      * set ihref='DOMETIC file transfer itemserv'
      * WHERE IHMID ='A77NPFBEJIM7NKIT'
      *
      *
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      * ORDERDAT  ENTRYDAT  INPUTDAT  DELIVDAT  CUSTOMDAT  DELIVDATP  BILLDAT   PICKDAT2
      * 07.01.10  30.12.10  27.01.10  12.08.11  29.01.10   30.12.10   15.08.11  11.08.11
      * 10.02.10  30.12.10  10.02.10  13.09.11  10.02.10   16.09.11   16.09.11  09.09.11
      * 17.02.10  30.12.10  17.02.10  05.01.11  20.12.10   30.12.10   06.01.11  05.01.11
      * 14.03.10  30.12.10  04.03.10  17.08.11  21.09.10   19.08.11   17.08.11  16.08.11
      * 12.03.10  30.12.10  12.03.10  15.08.11  06.05.10   30.12.10   22.08.11  11.08.11
      * 16.03.10  30.12.10  16.03.10  15.08.11  19.03.10   30.12.10   18.08.11  11.08.11
      * 13.04.10  30.12.10  13.04.10  06.01.11  13.04.10   30.12.10   10.01.11  06.01.11
      *
      * Orderdat:  Bestelldatum
      * Entrydat:
      * INPUTDAT:  Eingang der Order
      * Delivdat:  Auslieferungsdatum
      * CUSTOMDAT: Position, Kundenwunsch
      * Delivdatp: Lieferdatum aus Position nach Eingang der Auftragsposition
      * Billdat:   Rechnungsdatum
      * Pickdat:   Kommisionierungsdatum
      *
      *********************************************************************************

     f**itemserv  uf   e             disk
     f**                                     RENAME(itemserv:phy01r)
     f**                                     INFDS(DSF1)
     F**                                     USROPN

     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0

     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0

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
     Dpos              s             10i 0
     D
     D Wrk             DS                  Qualified inz
     D Var1                         200A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C*    *ENTRY        PLIST
     C*                  PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base three
     c                   exsr      sr2000

     C*...
     c                   exsr      sr6000
b

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     C*Ausgabedatei
     c/exec sql
     c+ insert into tvrelwaeco/OFFENEORD
     c+ SELECT aptenr,dec((sum(APBSMG)-sum(APglmG)), 13, 0) APglmG,
     c+                         apafnr,apafpo,apkdnr,APLFTE,APUSER,apafst,
     c+ int(week(substr(char(APLFTE), 1, 4) concat '-' concat
     c+          substr(char(APLFTE), 5, 2) concat '-' concat
     c+          substr(char(APLFTE), 7, 2))) week,APPRAR, APPREI from afpo
     c+          WHERE (APAFST <  '20' or APAFST ='79')
     c+                and aplanr not in ('004', '011')
     c+                and apfirm in ('01')
     c+                and APAFAT in ('01','08','11','16','17','18',
     c+                               '20','25','26','27','28',
     c+                               '41','44','45',
     c+                               '81','A02') and aplfte>20190101
     c+ GROUP BY aptenr,apafnr,apafpo,apkdnr,APLFTE,APUSER,apafst,
     c+                                                    APPRAR, APPREI,
     c+ int(week(substr(char(APLFTE), 1, 4) concat '-' concat
     c+          substr(char(APLFTE), 5, 2) concat '-' concat
     c+          substr(char(APLFTE), 7, 2)))
     c/end-exec


     C*update gelieferte Artikel
     c/exec sql
     c+ insert into tvrelwaeco/OFFENEORD#
     c+ SELECT APTENR,APKDNR , KDNAM1, KDNAM2, APAFNR, APAFPO, APKDNR,
     c+ APGLMG, APLFTE, APUSER,APAFST, WEEK,APPRAR, APPREI, ITEMSERV."DESC",
     c+ ITEMSERV.DUTY#, EAN, STATUS, REPLACEM, SKU, UPDATE_ID, MATGROUP,
     c+ PRODGROUP, DOMGROUP , char(' ', 50) kpif FROM OFFENEORD ,
     c+ kund01,itemserv WHERE APKDNR= KDKDNR and KDFIRM ='01' and APTENR=
     c+ ITEM
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ update offeneord# set kpif =
     c+ (select max(KPIDEN) from kpif where APKDNR=kpkdnr
     c+            and kpfirm='01' and kptenr=aptenr group by kpkdnr,kptenr)
     c+  where exists
     c+ (select max(KPIDEN) from kpif where APKDNR=kpkdnr
     c+            and kpfirm='01' and kptenr=aptenr group by kpkdnr,kptenr)
     c/end-exec


     c*

     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/OFFENEORD';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/OFFENEORD#';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
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
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec


     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

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
