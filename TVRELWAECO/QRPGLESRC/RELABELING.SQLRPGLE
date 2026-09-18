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
     c+ insert into tvrelwaeco/RELABELING
     c+ sELECT item, ITEMwrite."DESC" , itemwrite.SKU,ITEMwrite.EAN ean_alt,
     c+ ITEMwrite.EAN ean_neu,A001, BLOCKED, RESERVQTY, OPPROD,
     c+ OPPRODST,ITEMwrite.UPDATE_ID, DB_OPT_JQ.LAUFZEIT,
     c+ dec(1,00*(A001- RESERVQTY), 13, 0) umlabeln, BACKORD
     c+ FROM db_opt_jq,
     c+ itemwrite WHERE LEVEL ='level' and DB_OPT_JQ.ARTNR= ITEMwrite.ITEM
     c+ and DB_OPT_JQ.ARTNR<>sku and ITEMwrite.UPDATE_ID='X'
     c+ and substr(statnr, 2, 2)<>'99'
     c/end-exec
     c* and a001 > 100 and DB_OPT_JQ.ARTNR<>sku and ITEMwrite.UPDATE_ID='X'

     C*23.01.2014 BACKORD ist mit Bezug auf sku
     c/exec sql
     c+ update RELABELING a set backord =
     c+ (select backord  from   db_opt_jq b where
     c+       b.artnr=a.sku and LEVEL ='level' )
     c+  where exists
     c+ (select backord  from   db_opt_jq b where
     c+       b.artnr=a.sku and LEVEL ='level' )
     c/end-exec

     c/exec sql
     c+ delete  FROM relabeling WHERE SKU in (select artnr from DB_OPT_JQ
     c+ where DB_OPT_JQ.a001 > 0 and LEVEL ='level')
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ delete   FROM relabeling
     c+ WHERE A001 =0 and RESERVQTY =0 and OPPROD=0 and OPPRODST =0
     c/end-exec

     c/exec sql
     c+ delete FROM relabeling WHERE sku not in (select item from
     c+ itemwrite) and EAN_NEU = ' '
     c/end-exec

     c
     C*update gelieferte Artikel
     c/exec sql
     c+ update relabeling set ean_neu=' '
     c/end-exec

     c
     C*update gelieferte Artikel
     c/exec sql
     c+ update relabeling a set ean_neu =
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.sku  and version='$$EL_PS_DB')
     c+  where exists
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.sku  and version='$$EL_PS_DB')
     c/end-exec


     C*Ausgabedatei
     c/exec sql
     c+ insert into tvrelwaeco/pp
     c+ SELECT DISTINCT LBBSLANR, ldlbz1,LBBSLORT, A.LBBSTENR,LBBSMEIN,
     c+ LBBSSPKZ,decimal(sum(LBBSLAGB ), 13, 2) amount FROM LBBs a, lbsd b
     c+ WHERE LBBSFIRM=01 and LDFIRM=01 and LBBSFIRM=LDFIRM and
     c+ LBBSLANR in ('001','060') and
     c+ LBBSlanr=LDlanr and LBBSSPGR not in('88', '80') GROUP BY LBBSLANR,
     c+ ldlbz1,LBBSLORT, A.LBBSTENR, LBBSMEIN,LBBSSPKZ
     c/end-exec


     c/exec sql
     c+ insert into tvrelwaeco/relabeling
     c+ SELECT char(LBBSTENR, 16),
     c+ char(LBBSLANR concat substr(LDLBZ1, 1, 27), 30),
     c+ char( 'L:' concat LBBSLORT, 10),
     c+ char(LBBSMEIN concat ' ' concat LBBSSPKZ ,
     c+ 15), char(' ', 15), zoned(AMOUNT, 12, 2), dec(0, 13,
     c+ 2),zoned(00000000, 8, 0), zoned(00000000, 8, 0),zoned(00000000, 8,
     c+ 0), char(' ', 1) , current timestamp, dec(0, 13),dec(0, 13)
     c+      FROM pp where lbbstenr in (select item from RELABELING)
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
           'TVRELWAECO/RELABELING';
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
           'TVRELWAECO/PP';
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
