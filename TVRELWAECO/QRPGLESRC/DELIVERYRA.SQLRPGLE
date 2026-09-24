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
      * SELECT ITEM, "DESC", DUTY#, EAN, ITEMSERV.STATUS, LENGTH, WIDTH,
      * HEIGHT, WEIGHT, ICS_PRICE, REPLACEM, SC_ITEM, QUANTITY, TURNOVER,
      * ITEMSERV.STK_LCP, ITEMSERV.ICS_, ITEMSERV.ICS_VON,
      * ITEMSERV.ICS_BIS, ITEMSERV.ICS_2, ITEMSERV.ICS_VON2,
      * ITEMSERV.ICS_BIS2, SUREQTY, SKU, ITEMSERV.ABC, MATGROUP, PRODGROUP,
      * DOMGROUP, UPDATE_ID, ENDUSERPNJ, MCOB_SKU, MDP_SKU, MF_SKU,
      * OTRA_SKU, CURRENCY, PRICEGROUP, BIRTHDATE, ITEMSERV.TSTAMP,
      * LIEFERANT1, LIEFERANT2, char(' ', 50) liefdesc FROM itemserv,
      * bar_kalk/kalk_file WHERE item = artnr and version='$$EL_PS_DB' and
      * lieferant1 in ('90025', '90489', '90526', '92404', '92025',
      * '90325', '90204')
      * Datei ITEMSERV2 in TVRELWAECO wurde erstellt.
      *
      * update itemserv2 set liefdesc =
      * (select lfnam1 from lief01 where LFFIRM='01' and LFLFNR=LIEFERANT1)
      *  where exists
      * (select lfnam1 from lief01 where LFFIRM='01' and LFLFNR=LIEFERANT1)
      * 2179 Zeilen in ITEMSERV2 in TVRELWAECO aktualisiert.
      *
      * SELECT ITEM, "DESC", DUTY#, EAN, STATUS, LENGTH, WIDTH, HEIGHT,
      * WEIGHT, ICS_PRICE, REPLACEM, SC_ITEM, QUANTITY, TURNOVER, STK_LCP,
      * ICS_, ICS_VON, ICS_BIS, ICS_2, ICS_VON2, ICS_BIS2, SUREQTY, SKU,
      * ABC, MATGROUP, PRODGROUP, DOMGROUP, UPDATE_ID, ENDUSERPNJ,
      * MCOB_SKU, MDP_SKU, MF_SKU, OTRA_SKU, CURRENCY, PRICEGROUP,
      * BIRTHDATE,min(tstamp) FROM itemserv
      * group by
      *        ITEM, "DESC", DUTY#, EAN, STATUS, LENGTH, WIDTH, HEIGHT,
      * WEIGHT, ICS_PRICE, REPLACEM, SC_ITEM, QUANTITY, TURNOVER, STK_LCP,
      * ICS_, ICS_VON, ICS_BIS, ICS_2, ICS_VON2, ICS_BIS2, SUREQTY, SKU,
      * ABC, MATGROUP, PRODGROUP, DOMGROUP, UPDATE_ID, ENDUSERPNJ,
      * MCOB_SKU, MDP_SKU, MF_SKU, OTRA_SKU, CURRENCY, PRICEGROUP,
      * BIRTHDATE
      *
      * update tischler set sc_item=REPLACEM
      * where replacem <> ' '
      * 1158 Zeilen in TISCHLER in TVRELWAECO aktualisiert.
      *
      * update tischler set sc_item=sku where sc_item = ' ' and
      * sku in (select artnr from bar_kalk/kalk_file where
      *                 version='$$EL_PS_DB')
      * 6758 Zeilen in TISCHLER in TVRELWAECO aktualisiert.
      *
      * update tischler set sc_item=item
      * where SC_ITEM =' '
      * 5291 Zeilen in TISCHLER in TVRELWAECO aktualisiert.
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *
      *********************************************************************************

     fitemserv  uf   e             disk
     f                                     RENAME(itemserv:phy01r)
     f                                     INFDS(DSF1)
     F                                     USROPN
     f#PREIL1   if   e           k disk    RENAME(prei1:log01r)
     f#PREIL14  if   e           k disk    RENAME(prei1:log06r)
     f#PREIL2   if   e           k disk    RENAME(prei1:log02r)
     f#PREIL3   if   e           k disk    RENAME(prei1:log03r)
     f#PREIL5   if   e           k disk    RENAME(prei1:log05r)
     fkund01    if   e           k disk

     d#073             s                   like(PREZPR)
     d#073_von         s                   like(PRGADA)
     d#073_bis         s                   like(PRGBDA)
     d#173             s                   like(PREZPR)
     d#173_von         s                   like(PRGADA)
     d#173_bis         s                   like(PRGBDA)
     d#174             s                   like(PREZPR)
     d#174_von         s                   like(PRGADA)
     d#174_bis         s                   like(PRGBDA)
     d#175             s                   like(PREZPR)
     d#175_von         s                   like(PRGADA)
     d#175_bis         s                   like(PRGBDA)
     d#273             s                   like(PREZPR)
     d#273_von         s                   like(PRGADA)
     d#273_bis         s                   like(PRGBDA)
     d#373             s                   like(PREZPR)
     d#373_von         s                   like(PRGADA)
     d#373_bis         s                   like(PRGBDA)
     d#473             s                   like(PREZPR)
     d#473_von         s                   like(PRGADA)
     d#473_bis         s                   like(PRGBDA)
     d#400             s                   like(PREZPR)
     d#400_von         s                   like(PRGADA)
     d#400_bis         s                   like(PRGBDA)
     d#EVP             s                   like(PREZPR)
     d#evp_von         s                   like(PRGADA)
     d#evp_bis         s                   like(PRGBDA)

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
     C     *ENTRY        PLIST
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base three
     c                   exsr      sr2000
     c*                  if        §§amkdnr  =   'x00000'
     c*                  exsr      sr3000
     c*                  else
     c*                  exsr      sr3005
     c*                  endif
     c                   exsr      sr6000

     C*...
     c                   exsr      sr5000

     C                   open      ITEMSERV
     C                   DO        *HIVAL
     C
     C                   READ      ITEMSERV                               95
     C                   if        ITEM ='9600008898  '
     C                   clear                   gggg              1
     C                   endif
     C
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c                   movel     KDWACD        currency
     c                   movel     KDKDGR        pricegroup
     C********           exsr      srlines
     C*                 PKD
     C*                      AKG (Aktion)
     C*                           PKG
     C*                                PVK (Artikelkatalogpreis)
     C                   exsr      srl_PKD
     C                   exsr      srl_lp1
     c                   clear                   EndUserPNJ
     C                   exsr      srl_PVK2
     c                   z-add     #evp          EndUserPNJ
     c                   if        #evp <> EndUserPNJ
     c                   z-add     #evp          EndUserPNJ
     c                   movel     item          ff               15
     c                   endif
     c     ';':' '       xlate     desc          desc
     c     ',':'.'       xlate     desc          desc
     c     '"':' '       xlate     desc          desc
     c     '´':' '       xlate     desc          desc
     c     '`':' '       xlate     desc          desc
     c*__________________________________________________________________
     c                   select
     c****************** when      §§amkdnr  =   '061796' or
     c******************           §§amkdnr  =   '191453'
     c                   when      pricegroup=   '073'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c****************** when      §§amkdnr  =   '083383' or
     c******************           §§amkdnr  =   '049511'
     c                   when      pricegroup=   '373'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c****************** when      §§amkdnr  =   '+54939'
     c                   when      pricegroup=   '473'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c****************** when      §§amkdnr  =   '015177' or
     c******************           §§amkdnr  =   '062765'
     c                   when      pricegroup=   '400'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c                   when      §§amkdnr  =   '00*173' or
     c                             pricegroup=   '173'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c                   when      §§amkdnr  =   '00*175' or
     c                             pricegroup=   '175'
     c******************           §§amkdnr  =   '040631'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c
     c****************** when      §§amkdnr  =   '055390' or
     c******************           §§amkdnr  =   '089644' or
     c******************           §§amkdnr  =   '091092' or
     c******************           §§amkdnr  =   '021556' or
     c******************           §§amkdnr  =   '064575' or
     c******************           §§amkdnr  =   '705488' or
     c******************           §§amkdnr  =   '005488' or
     c******************           §§amkdnr  =   '099296' or
     c******************           §§amkdnr  =   '775488' or
     c******************           §§amkdnr  =   '718853' or
     c******************           §§amkdnr  =   '019292' or
     c******************           §§amkdnr  =   '060207' or
     c******************           §§amkdnr  =   '018853'
     c                   when      pricegroup=   '273'
     c                   move      tstamp        #tstamp          26
     c                   move      '273'         #tstamp
     c                   move      #tstamp       tstamp
     c
     c                   when      §§amkdnr  =   '054939' or
     c                             pricegroup=   '174'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c                   other
     c                   ENDsl
     c*__________________________________________________________________
     c                   movel     item          #item            15
     c*                  clear                   item
     c*                  move      #item         item
     c                   update    phy01r
     c                   endif
     C
     C                   enddo
     C                   close     ITEMSERV
b
     c                   exsr      sr6500
     C*Ausgabe für rpm
     c                   exsr      sr7000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
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
     c+ CREATE TABLE qtemp/itemserv
     c+ (ITEM      CHAR(16) CCSID 273, "DESC"   CHAR(30) CCSID 273,
     c+  DUTY#     CHAR(12) CCSID 273,  EAN     CHAR(15) CCSID 273,
     c+  STATUS    CHAR( 6) CCSID 273,
     c+  LENGTH    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  WIDTH     NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  HEIGHT    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  WEIGHT    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  ICS_PRICE NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  REPLACEM  CHAR(15) CCSID 273,  SC_ITEM CHAR(15) CCSID 273,
     c+  QUANTITY  decimal(09, 2),      TURNOVER  decimal(09, 2),
     c+  STK_LCP   decimal(03, 2),
     c+  ICS_      NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  ICS_VON   NUMERIC(08, 0) NOT NULL DEFAULT 0 ,
     c+  ICS_BIS   NUMERIC(08, 0) NOT NULL DEFAULT 0 ,
     c+  ICS_2     decimal(12, 4),ICS_VON2  decimal(08, 0),
     c+  ICS_BIS2  decimal(08, 0),
     c+  SUREQTY   NUMERIC(03, 0) NOT NULL DEFAULT 0 ,
     c+  SKU       CHAR(10) CCSID 273,  ABC       CHAR(01) CCSID 273,
     c+  MATGROUP  CHAR(03) CCSID 273,  PRODGROUP CHAR(03) CCSID 273,
     c+  DOMGROUP  CHAR(03) CCSID 273,  UPDATE_ID CHAR(01) CCSID 273,
     c+  ENDUSERPNJ decimal(09, 2),
     c+  MCOB_SKU  CHAR(15) CCSID 273,  MDP_SKU    CHAR(15) CCSID 273,
     c+  MF_SKU    CHAR(15) CCSID 273,  OTRA_SKU   CHAR(15) CCSID 273,
     c+  CURRENCY  CHAR(03) CCSID 273,  PRICEGROUP CHAR(03) CCSID 273,
     c+  BIRTHDATE NUMERIC(08, 0) NOT NULL DEFAULT 0,
     c+  tstamp TIMESTAMP)
     c/end-exec
     c*

     C     ##3000        ENDSR

     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv
     C*-------------------------------------------------------------------------
     C*
     C     sr3005        BEGSR
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
     c+ CREATE TABLE qtemp/itemserv
     c+ (ITEM      CHAR(16) CCSID 273, "DESC"   CHAR(30) CCSID 273,
     c+  DUTY#     CHAR(12) CCSID 273,  EAN     CHAR(15) CCSID 273,
     c+  STATUS    CHAR( 6) CCSID 273,
     c+  LENGTH    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  WIDTH     NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  HEIGHT    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  WEIGHT    NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  ICS_PRICE NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  REPLACEM  CHAR(15) CCSID 273,  SC_ITEM CHAR(15) CCSID 273,
     c+  QUANTITY  decimal(09, 2),      TURNOVER  decimal(09, 2),
     c+  STK_LCP   decimal(03, 2),
     c+  ICS_      NUMERIC(12, 4) NOT NULL DEFAULT 0 ,
     c+  ICS_VON   NUMERIC(08, 0) NOT NULL DEFAULT 0 ,
     c+  ICS_BIS   NUMERIC(08, 0) NOT NULL DEFAULT 0 ,
     c+  ICS_2     decimal(12, 4),ICS_VON2  decimal(08, 0),
     c+  ICS_BIS2  decimal(08, 0),
     c+  SUREQTY   NUMERIC(03, 0) NOT NULL DEFAULT 0 ,
     c+  SKU       CHAR(10) CCSID 273,  ABC       CHAR(01) CCSID 273,
     c+  MATGROUP  CHAR(03) CCSID 273,  PRODGROUP CHAR(03) CCSID 273,
     c+  DOMGROUP  CHAR(03) CCSID 273,  UPDATE_ID CHAR(01) CCSID 273,
     c+  ENDUSERPNJ decimal(09, 2),
     c+  MCOB_SKU  CHAR(15) CCSID 273,  MDP_SKU    CHAR(15) CCSID 273,
     c+  MF_SKU    CHAR(15) CCSID 273,  OTRA_SKU   CHAR(15) CCSID 273,
     c+  CURRENCY  CHAR(03) CCSID 273,  PRICEGROUP CHAR(03) CCSID 273,
     c+  BIRTHDATE NUMERIC(08, 0) NOT NULL DEFAULT 0,
     c+  tstamp TIMESTAMP)
     c/end-exec
     c*

     C     ##3005        ENDSR

     C**************************************************************************
     C*übernahme
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
     c                   if        §§amkdnr <> '055278'  and
     c                             §§amkdnr <> '098848'
     C*Ausgabedatei
     c/exec sql
     c+ insert into tvrelwaeco/ITEMSERV
     c+ SELECT char(a.ARTNR, 16)  item,
     c+                     a.ARTBEZ desc,ZOLLNR duty#,artean EAN, ARTZ3
     c+ Status,LAENGE LENGTH, BREITE WIDTH, HOEHE HEIGHT, GEWICHT WEIGHT,
     c+ a.ICS_*0 ICS_Price, E1 replacem, char(' ', 15) sc_item, dec(0, 9, 2)
     c+ quantity, dec(0, 9, 2) turnover, 0,00 stk_lcp, B.ICS_*0, B.ICS_VON
     c+ *0, B.ICS_BIS*0,
     c+ dec(0, 12, 4) ICS_2, dec(0, 8, 0) ICS_VON2, dec(0, 8, 0) ICS_BIS2,
     c+ #TEVOZ1 sureqty,artsku SKU,abc,ARTGRP MatGroup, STATNR prodgroup,
     c+ LIEFNR DOMGroup,char('X', 1) update_ID,dec(0, 9, 2) EndUserPNJ,
     c+                 char(' ', 15) mcob_sku, char(' ', 15) mdp_sku,
     c+                 char(' ', 15) mf_sku,   char(' ', 15)OTRA_sku,
     c+                 char(' ', 03) currency, char(' ', 03) pricegroup,
     c+                 anldat birthdate,a.tstamp
     c+ FROM bar_kalk/kalk_file a,
     c+ BAR_KALK/preisakt b WHERE a.version = '$$EL_PS_DB'
     c+ and (ARTZ3 <> '90' or  KCJMNG_VJ<> 0 or KCJMNG_AJ<> 0)
     c**+ and abc    not in ('K')
     c+ and ARTZ3  not in ('82', '83', '81')
     c****+ and (a.artnr='RV-30K' or a.artnr='9103500697')
     c+ and artgrp not in
     c+     ('LOH','GAR','M01','M02','M03','M04','M05','M06','M10','M11')
     c+ and a.ARTNR=b.artnr and A.TSTAMP=b.tstamp
     c/end-exec
     C*
     c                   endif


     c                   if        §§amkdnr =  '055278'
     C*
     C*Ausgabedatei
     c/exec sql
     c+ insert into tvrelwaeco/ITEMSERV
     c+ SELECT char(a.ARTNR, 16)  item,
     c+                     a.ARTBEZ desc,ZOLLNR duty#,artean EAN, ARTZ3
     c+ Status,LAENGE LENGTH, BREITE WIDTH, HOEHE HEIGHT, GEWICHT WEIGHT,
     c+ a.ICS_*0 ICS_Price, E1 replacem, char(' ', 15) sc_item, dec(0, 9, 2)
     c+ quantity, dec(0, 9, 2) turnover, 0,00 stk_lcp, B.ICS_*0, B.ICS_VON
     c+ *0, B.ICS_BIS*0,
     c+ dec(0, 12, 4) ICS_2, dec(0, 8, 0) ICS_VON2, dec(0, 8, 0) ICS_BIS2,
     c+ #TEVOZ1 sureqty,artsku SKU,abc,ARTGRP MatGroup, STATNR prodgroup,
     c+ LIEFNR DOMGroup,char('X', 1) update_ID,dec(0, 9, 2) EndUserPNJ,
     c+                 char(' ', 15) mcob_sku, char(' ', 15) mdp_sku,
     c+                 char(' ', 15) mf_sku,   char(' ', 15)OTRA_sku,
     c+                 char(' ', 03) currency, char(' ', 03) pricegroup,
     c+                 anldat birthdate,a.tstamp
     c+ FROM bar_kalk/kalk_file a,
     c+ BAR_KALK/preisakt b WHERE a.version = '$$EL_PS_DB'
     c+
     c**+ and abc    not in ('K')
     c+ and ARTZ3  not in ('82', '83', '81')
     c****+ and (a.artnr='RV-30K' or a.artnr='9103500697')
     c+ and artgrp not in
     c+     ('LOH','GAR','M01','M02','M03','M04','M05','M06','M10','M11')
     c+ and a.ARTNR=b.artnr and A.TSTAMP=b.tstamp
     c/end-exec
     c                   endif

     C*
     c                   if        §§amkdnr =  '098848'  and
     c                             §§amkdnr =  '098848'
     C*Ausgabedatei
     c/exec sql
     c+ insert into tvrelwaeco/ITEMSERV
     c+ SELECT char(a.ARTNR, 16)  item,
     c+                     a.ARTBEZ desc,ZOLLNR duty#,artean EAN, ARTZ3
     c+ Status,LAENGE LENGTH, BREITE WIDTH, HOEHE HEIGHT, GEWICHT WEIGHT,
     c+ a.ICS_*0 ICS_Price, E1 replacem, char(' ', 15) sc_item, dec(0, 9, 2)
     c+ quantity, dec(0, 9, 2) turnover, 0,00 stk_lcp, B.ICS_*0, B.ICS_VON
     c+ *0, B.ICS_BIS*0,
     c+ dec(0, 12, 4) ICS_2, dec(0, 8, 0) ICS_VON2, dec(0, 8, 0) ICS_BIS2,
     c+ #TEVOZ1 sureqty,artsku SKU,abc,ARTGRP MatGroup, STATNR prodgroup,
     c+ LIEFNR DOMGroup,char('X', 1) update_ID,dec(0, 9, 2) EndUserPNJ,
     c+                 char(' ', 15) mcob_sku, char(' ', 15) mdp_sku,
     c+                 char(' ', 15) mf_sku,   char(' ', 15)OTRA_sku,
     c+                 char(' ', 03) currency, char(' ', 03) pricegroup,
     c+                 anldat birthdate,a.tstamp
     c+ FROM bar_kalk/kalk_file a,
     c+ BAR_KALK/preisakt b WHERE a.version = '$$EL_PS_DB'
     c+ and (ARTZ3 <> '90' or  KCJMNG_VJ<> 0 or KCJMNG_AJ<> 0)
     c**+ and abc    not in ('K')
     c+ and ARTZ3  not in (      '83', '81')
     c****+ and (a.artnr='RV-30K' or a.artnr='9103500697')
     c+ and artgrp not in
     c+     ('LOH','GAR','M01','M02','M03','M04','M05','M06','M10','M11')
     c+ and a.ARTNR=b.artnr and A.TSTAMP=b.tstamp
     c/end-exec
     C*
     c                   endif


     c                   if        §§amkdnr <> '000000' or
     c                             §§amkdnr <> '00*073' or
     c                             §§amkdnr <> '00*173' or
     c                             §§amkdnr <> '00*174' or
     c                             §§amkdnr <> '00*273' or
     c                             §§amkdnr <> '00*373' or
     c                             §§amkdnr <> '00*473' or
     c                             §§amkdnr <> '00*400'
     c
     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set SC_ITEM   =
     c+ (SELECT distinct item       FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date) )
     c+  where exists
     c+ (SELECT distinct item       FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date) )
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set quantity  =
     c+ (SELECT sum(APGLMG)         FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date)
     c+       group by aptenr )
     c+  where exists
     c+ (SELECT sum(APGLMG)         FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date)
     c+       group by aptenr )
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set TURNOVER  =
     c+ (SELECT sum(RPBRSU*APKURS)  FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c+  where exists
     c+ (SELECT sum(RPBRSU*APKURS)  FROM absatzb where
     c+  APKDNR=:§§amkdnr and ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c/end-exec
     C*
     c                   endif


     c                   if        §§amkdnr =  '000000' or
     c                             §§amkdnr =  '00*073' or
     c                             §§amkdnr =  '00*173' or
     c                             §§amkdnr =  '00*174' or
     c                             §§amkdnr =  '00*175' or
     c                             §§amkdnr =  '00*273' or
     c                             §§amkdnr =  '00*373' or
     c                             §§amkdnr =  '00*473' or
     c                             §§amkdnr =  '00*400'
     c
     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set SC_ITEM   =
     c+ (SELECT distinct item       FROM absatzb where
     c+                       ITEM=APTENR and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year))
     c+  where exists
     c+ (SELECT distinct item       FROM absatzb where
     c+                       ITEM=APTENR and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year))
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set quantity  =
     c+ (SELECT sum(APGLMG)         FROM absatzb where
     c+                       ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c+  where exists
     c+ (SELECT sum(APGLMG)         FROM absatzb where
     c+                       ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c/end-exec

     C*update gelieferte Artikel
     c/exec sql
     c+ update tvrelwaeco/ITEMSERV set TURNOVER  =
     c+ (SELECT sum(RPBRSU*APKURS)  FROM absatzb where
     c+                       ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c+  where exists
     c+ (SELECT sum(RPBRSU*APKURS)  FROM absatzb where
     c+                       ITEM=APTENR and APGLMG <> 0 and
     c+  year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+       substr(char(rkreda), 5, 2) concat '-' concat
     c+       substr(char(rkreda), 7, 2) )) =year(current date -0 year)
     c+       group by aptenr )
     c/end-exec
     C*
     c                   endif

     c/exec sql
     c+ update  tvrelwaeco/itemserv  a set  a.sku         =
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  a.item=artnr and version ='$$EL_PS_DB' and artbezfra <> ' ')
     c+ where exists
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  a.item=artnr and version ='$$EL_PS_DB' and artbezfra <> ' ')
     c/end-exec
     C*
     C*Katalog MCOB
     c/exec sql
     c+ update itemserv   a set MCOB_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c/end-exec
     C*Katalog MCOB
     c/exec sql
     c+ update itemserv   a set MCOB_sku =
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c/end-exec

     C*Katalog MDP
     c/exec sql
     c+ update itemserv   a set MDP_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c/end-exec
     C*Katalog MDP
     c/exec sql
     c+ update itemserv   a set MDP_sku =
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c/end-exec

     C*Katalog MF
     c/exec sql
     c+ update itemserv   a set MF_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c/end-exec
     C*Katalog MF
     c/exec sql
     c+ update itemserv   a set MF_sku =
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c/end-exec

     C*Katalog OTRA
     c/exec sql
     c+ update itemserv   a set otra_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c/end-exec
     C*Katalog OTRA
     c/exec sql
     c+ update itemserv   a set otra_sku =
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.sku  = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c/end-exec

     c/exec sql
     c+ update  tvrelwaeco/itemserv  a set a.UPDATE_ID = '0' where item in
     c+ (select artnr from bar_kalk/kalk_file WHERE version='$$EL_PS_DB'
     c+  and lieferant1 in
     c+  ('90025', '90489', '90526', '92404', '92025', '90325', '90204'))
     c/end-exec
     C*

     c/exec sql
     c+ update tvrelwaeco/itemserv a set a.UPDATE_ID = '0'
     c+ where substr(prodgroup, 2, 2)='99'
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/itemserv a set a.UPDATE_ID = '0'
     c+ where matgroup in
     c+ ('PRO','SON','FRA','FWK','DRU','ENT','WER')
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/itemserv a set a.UPDATE_ID = '0'
     c+ where matgroup in
     c+ ('PRO','SON','FRA','FWK','DRU','ENT','WER')
     c/end-exec
     C*
     c******/exec sql
     c******+ delete   FROM itemserv
     c******+ WHERE PRODGROUP in
     c******+ ('190','204','211','214','290','327','346',
     c******+ '413','417','418','419','422', '423','426','490','491')
     c******+ and QUANTITY = 0 and TURNOVER =0
     c******/end-exec
     C*
     c******/exec sql
     c******+ delete   FROM itemserv
     c******+ WHERE substr(PRODGROUP, 1, 1)='9' and
     c******+ (BIRTHDATE < 20130000 or QUANTITY = 0)
     c******/end-exec
     C*
     C*preise aus $$p2014
     c/exec sql
     c+ update itemserv   a set a.EndUserPNJ =
     c+ (select EVP_AJ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$p2014')
     c+ where exists
     c+ (select EVP_AJ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$p2014')
     c/end-exec

     C*Artikel Leugers  OEM
     c/exec sql
     c+ update itemserv   a set a.status =
     c+ (select substr(ARTZ3, 1, 2) concat #TEDIAV
     c+ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$EL_PS_DB' and #TEDIAV ='LR')
     c+ where exists
     c+ (select substr(ARTZ3, 1, 2) concat #TEDIAV
     c+ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$EL_PS_DB' and #TEDIAV ='LR')
     c/end-exec

     C*Artikel Hoffmann OEM
     c/exec sql
     c+ update itemserv   a set a.status =
     c+ (select substr(ARTZ3, 1, 2) concat #TEDIAV
     c+ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$EL_PS_DB' and #TEDIAV ='HOF'
     c+ and ARTGRP in ('041','042','043','044','050','054','068','076',
     c+                '088','094','097'))
     c+ where exists
     c+ (select substr(ARTZ3, 1, 2) concat #TEDIAV
     c+ from bar_kalk/kalk_file b where
     c+ a.item  = b.artnr and version='$$EL_PS_DB' and #TEDIAV ='HOF'
     c+ and ARTGRP in ('041','042','043','044','050','054','068','076',
     c+                '088','094','097'))
     c/end-exec


     c                   if        §§amkdnr <> '000000' or
     c                             §§amkdnr <> '00*073' or
     c                             §§amkdnr <> '00*173' or
     c                             §§amkdnr <> '00*174' or
     c                             §§amkdnr <> '00*175' or
     c                             §§amkdnr <> '00*273' or
     c                             §§amkdnr <> '00*373' or
     c                             §§amkdnr <> '00*473' or
     c                             §§amkdnr <> '00*400'
     C*
     c/exec sql
     c+ delete   FROM itemserv
     c+ WHERE status like '%LR%' or status like '%HOF%' and
     c+       item  <> '9103540428'
     c/end-exec
     c                   endif
     c
     C*update der Kontrolldatei
     c/exec sql
     c+ update  §§MSGSCC b set "GROUP" =
     c+ (select KDKDGR concat KDWACD from kund01 a
     c+         where a.kdFIRM='01' and a.KdFIRM=b.kpfirm and
     c+                                 a.KdKDNR=b.kpkdnr)
     c+  where exists
     c+ (select KDKDGR concat KDWACD from kund01 a
     c+         where a.kdFIRM='01' and a.KdFIRM=b.kpfirm and
     c+                                 a.KdKDNR=b.kpkdnr)
     c/end-exec
     c*

     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6500        BEGSR
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
     c*
     c/exec sql
     c+ insert into tvrelwaeco/itemwrite
     c+ SELECT * FROM itemserv WHERE UPDATE_ID ='X' and SKU = REPLACEM
     c+ and ITEM <> sku
     c/end-exec

     c*

     C     ##6500        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/itemwrite';
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
           'TVRELWAECO/itemserv';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'dltf' + ' ' +
           'qtemp/itemserv';
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
           'TVRELWAECO/transferp';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C* SR7000:
     C*-------------------------------------------------------------------------
     C*
     C     srlines       BEGSR
     C*
     C                   if        ITEM ='10776710'
     C                   clear                   gggg              1
     C                   endif

     c                   movel     '01'          PRFIRM
     c                   movel     'PKG'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     'EUR'         PRWACD
     c                   movel     KDWACD        PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     c                   clear                   #073
     c                   clear                   #073_von
     c                   clear                   #073_bis
     c                   clear                   #173
     c                   clear                   #173_von
     c                   clear                   #173_bis
     c                   clear                   #174
     c                   clear                   #174_von
     c                   clear                   #174_bis
     c                   clear                   #175
     c                   clear                   #175_von
     c                   clear                   #175_bis
     c                   clear                   #273
     c                   clear                   #273_von
     c                   clear                   #273_bis
     c                   clear                   #373
     c                   clear                   #373_von
     c                   clear                   #373_bis
     c                   clear                   #473
     c                   clear                   #473_von
     c                   clear                   #473_bis
     c                   clear                   #400
     c                   clear                   #400_von
     c                   clear                   #400_bis
     c                   clear                   #EVP
     c                   clear                   #evp_von
     c                   clear                   #evp_bis

     C     KEY7000       SETLL     #PREIL1                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL1                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PKG'
     c     PRTENR        orne      item
     c*    PRWACD        orne      'EUR'
     c     PRWACD        orne      KDWACD
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     C                   if        PRKDLG = '073'
     C                   eval      #073     =      PREZPR
     C                   eval      #073_von =      PRGADA
     C                   eval      #073_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '173'
     C                   eval      #173     =      PREZPR
     C                   eval      #173_von =      PRGADA
     C                   eval      #173_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '174'
     C                   eval      #174     =      PREZPR
     C                   eval      #174_von =      PRGADA
     C                   eval      #174_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '175'
     C                   eval      #175     =      PREZPR
     C                   eval      #175_von =      PRGADA
     C                   eval      #175_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '273'
     C                   eval      #273     =     PREZPR
     C                   eval      #273_von =     PRGADA
     C                   eval      #273_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '373'
     C                   eval      #373     =     PREZPR
     C                   eval      #373_von =     PRGADA
     C                   eval      #373_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '400'
     C                   eval      #400     =     PREZPR
     C                   eval      #400_von =     PRGADA
     C                   eval      #400_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '473'
     C                   eval      #473     =      PREZPR
     C                   eval      #473_von =      PRGADA
     C                   eval      #473_bis =      PRGBDA
     C                   endif
     C
     C                   endif
     C                   endif
     C                   enddo
     C                   endif

     c                   movel     '01'          PRFIRM
     c                   movel     'PVK'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA

     C     KEY7000       SETLL     #PREIL3                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL3                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PVK'
     c     PRTENR        orne      item
     c     PRWACD        orne      'EUR'
     C                   leave
     C                   else
     c                   if        item='9103300448'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      #EVP    =      PREZPR
     C                   eval      #evp_von=      PRGADA
     C                   eval      #evp_bis=      PRGBDA
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     c                   if        §§amkdnr  ='191453'
     c                   movel     'RUB'         CURRENCY
     c                   movel     '01'          PRFIRM
     c                   movel     'PKD'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     CURRENCY      PRWACD
     c                   clear                   PRGADA
     C     KEY7001       SETLL     #PREIL2                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL2                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PKD'
     c     PRKDLI        orne      §§amkdnr
     c     PRTENR        orne      item
     c     PRWACD        orne      CURRENCY
     C                   leave
     C                   else
     c                   if        item='9105900008'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      #073     =      PREZPR
     C                   eval      #073_von =      PRGADA
     C                   eval      #073_bis =      PRGBDA
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C                   endif

     c                   if        §§amkdnr     = '054939'
     c                   clear                   ICS_PRICE
     c                   movel     '61'          PRFIRM
     c                   movel     'LP1'         PRBEGR
     c                   movel     '000999'      PRKDLI
     c                   movel     item          PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA


     C     KEY7000b      SETLL     #PREIL5                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL5                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '61'
     c     PRBEGR        orne      'LP1'
     c     PRTENR        orne      item
     c     PRWACD        orne      'EUR'
     C                   leave
     C                   else
     c                   if        item='9106600859' or
     c                             item='9104116106' or
     c                             item='9104116107'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      ICS_PRICE   =  PREZPR
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C                   endif
     C
     C*
     C     ##lines       ENDSR
     C*
     C**************************************************************************
     C* PKD_lines
     C*-------------------------------------------------------------------------
     C*
     C*PKD ********************************************************************
     C     srl_PKD       BEGSR
     C*
     c                   if        item='10776710  '
     c                   clear                   ppp               1
     c                   endif
     c                   movel     '0'           run               1
     c     key7001       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    §§amkdnr
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA
     c****               kfld                    PRKDLG
     C
     c                   movel     KDWACD        CURRENCY
     c                   movel     '01'          PRFIRM
     c                   movel     'PKD'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     CURRENCY      PRWACD
     c                   clear                   PRGADA
     C     KEY7001       SETLL     #PREIL2                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL2                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PKD'
     c     PRKDLI        orne      §§amkdnr
     c     PRTENR        orne      item
     c     PRWACD        orne      CURRENCY
     C                   leave
     C                   else
     c                   if        item='9105900008'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     c                   eval      ICS_2     =   PREZPR
     c                   eval      ICS_von2  =   PRGADA
     c                   eval      ICS_bis2  =   PRGBDA
     c                   eval      run = '1'
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C*
     c                   if        run = '0'
     c                   exsr      srl_aKG
     c                   else
     c                   eval      pricegroup  = 'PKD'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c                   endif
     C*
     C     ##l_pkd       ENDSR
     C*
     C**************************************************************************
     C* aKG_lines  Aktionspreise
     C*-------------------------------------------------------------------------
     C*
     C*aKG ********************************************************************
     C     srl_aKG       BEGSR
     C*
     C                   if        ITEM ='ACFC01'
     C                   clear                   gggg              1
     C                   endif

     c                   movel     '01'          PRFIRM
     c                   movel     'AKG'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     currency      PRWACD
     c                   movel     KDWACD        PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     C     KEY7000       SETLL     #PREIL14                           92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL14                               92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'AKG'
     c     PRTENR        orne      item
     c     PRWACD        orne      currency
     c     PRWACD        orne      KDWACD
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     C                   if        PRKDLG = KDKDGR
     c                   eval      ICS_2     =   PREZPR
     c                   eval      ICS_von2  =   PRGADA
     c                   eval      ICS_bis2  =   PRGBDA
     c                   eval      run = '1'
     C                   endif
     C
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     c                   if        run = '0'
     c                   exsr      srl_PKG
     c                   else
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c                   endif

     C     ##l_akg       ENDSR
     C*
     C**************************************************************************
     C* PKG_lines
     C*-------------------------------------------------------------------------
     C*
     C*PKG ********************************************************************
     C     srl_PKG       BEGSR
     C*
     C                   if        ITEM ='ACFC01'
     C                   clear                   gggg              1
     C                   endif
     c     key7000       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA
     c****               kfld                    PRKDLG

     c                   movel     '01'          PRFIRM
     c                   movel     'PKG'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     currency      PRWACD
     c                   movel     KDWACD        PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     C     KEY7000       SETLL     #PREIL1                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL1                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PKG'
     c     PRTENR        orne      item
     c     PRWACD        orne      currency
     c     PRWACD        orne      KDWACD
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     C                   if        PRKDLG = KDKDGR
     c                   eval      ICS_2     =   PREZPR
     c                   eval      ICS_von2  =   PRGADA
     c                   eval      ICS_bis2  =   PRGBDA
     c                   eval      run = '1'
     C                   endif
     C
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     c                   if        run = '0'
     c                   exsr      srl_PVK
     c                   else
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c                   endif

     C     ##l_pkg       ENDSR
     C*
     C**************************************************************************
     C* PVK_lines
     C*-------------------------------------------------------------------------
     C*
     C*PVK ********************************************************************
     C     srl_PVK       BEGSR
     C*
     c                   movel     '01'          PRFIRM
     c                   movel     'PVK'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     currency      PRWACD
     c                   clear                   PRGADA

     C     KEY7000       SETLL     #PREIL3                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL3                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PVK'
     c     PRTENR        orne      item
     c     PRWACD        orne      currency
     C                   leave
     C                   else
     c                   if        item='9103300448'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     c                   eval      ICS_2     =   PREZPR
     c                   eval      ICS_von2  =   PRGADA
     c                   eval      ICS_bis2  =   PRGBDA
     c                   eval      run = '1'
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     c                   if        run = '0'
     c                   eval      pricegroup  = '???'
     c                   eval      ICS_2     =   *zero
     c                   eval      ICS_von2  =   *zero
     c                   eval      ICS_bis2  =   *zero
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     c                   else
     c                   eval      pricegroup  = 'PVK'
     c                   move      tstamp        #tstamp          26
     c                   move      #tstamp       tstamp
     C                   endif
     C*
     C     ##l_pVK       ENDSR
     C*
     C**************************************************************************
     C* LP1_lines  Einkaufspreise für Österreich Abweichung feststellen AT_preise
     C*-------------------------------------------------------------------------
     C*
     C*lp1 ********************************************************************
     C     srl_lp1       BEGSR
     C*
     c                   if        §§amkdnr     = '054939'
     c                   clear                   ICS_PRICE
     c                   movel     '61'          PRFIRM
     c                   movel     'LP1'         PRBEGR
     c                   movel     '000999'      PRKDLI
     c                   movel     item          PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA

     c     key7000b      klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLI
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA

     C     KEY7000b      SETLL     #PREIL5                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL5                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '61'
     c     PRBEGR        orne      'LP1'
     c     PRTENR        orne      item
     c     PRWACD        orne      'EUR'
     C                   leave
     C                   else
     c                   if        item='9106600859' or
     c                             item='9104116106' or
     c                             item='9104116107'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      ICS_PRICE   =  PREZPR
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C                   endif
     C
     C     ##l_lp1       ENDSR
     C*
     C**************************************************************************
     C* PVK_lines nur für enduserpreis
     C*-------------------------------------------------------------------------
     C*
     C*PVK für enduserpreis ***************************************************
     C     srl_PVK2      BEGSR
     C*
     c                   clear                   #EVP
     c                   clear                   #evp_von
     c                   clear                   #evp_bis
     C*
     c                   movel     '01'          PRFIRM
     c                   movel     'PVK'         PRBEGR
     c                   movel     item          PRTENR
     c                   movel     currency      PRWACD
     c                   clear                   PRGADA

     C     KEY7000       SETLL     #PREIL3                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL3                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PVK'
     c     PRTENR        orne      item
     c     PRWACD        orne      currency
     C                   leave
     C                   else
     c                   if        item='9103300448'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      #EVP    =      PREZPR
     C                   eval      #evp_von=      PRGADA
     C                   eval      #evp_bis=      PRGBDA
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     C*
     C     ##l_pVK2      ENDSR
     C*
     C**************************************************************************
     C* sr5000: Kundenzuordnung order  -2-
     C* sr5000: KDWACD, KDKDGR FROM kund01 WHERE KDKDNR
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c     #kund01       klist
     c                   kfld                    kdFIRM
     c                   kfld                    §§amkdnr
     c
     c                   movel     '01'          kdFIRM
     c
     c     #kund01       chain     kund01                             97
     c   97              clear                   KDWACD
     c   97              clear                   KDKDGR
     c                   if        §§amkdnr  ='000000'
     c                   movel     'EUR'         KDWACD
     c                   movel     '173'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*073'
     c                   movel     'EUR'         KDWACD
     c                   movel     '073'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*173'
     c                   movel     'SEK'         KDWACD
     c                   movel     '173'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*174'
     c                   movel     'EUR'         KDWACD
     c                   movel     '174'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*175'
     c                   movel     'EUR'         KDWACD
     c                   movel     '175'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*273'
     c                   movel     'SEK'         KDWACD
     c                   movel     '273'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*373'
     c                   movel     'SEK'         KDWACD
     c                   movel     '373'         KDKDGR
     c                   endif
     c                   if        §§amkdnr  ='00*473'
     c                   movel     'SEK'         KDWACD
     c                   movel     '473'         KDKDGR
     c                   endif
     C*
     C     ##5000        ENDSR
     C*
     C**************************************************************************
     C*Datei generieren CREATE TABLE qtemp/itemserv
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
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

     C                   clear                   #code             8
     c/exec sql
     C+ select substr(code, 1, 8) into :#code
     C+            from gang/CODEKUNDE
     C+            where KUNDEN#1 = :§§amkdnr
     c/end-exec
     C*
     C*
     c                   if        #code <> *blank
     C*Ausgabedatei
     c/exec sql
     c+  insert into tvrelwaeco/TRANSFERP
     c+  SELECT char('DE411', 8) uplentity, item sku, :#code custentity,
     c+  substr(char(tstamp), 1, 4) concat substr(char(tstamp), 6, 2)
     c+  concat '01' validfrom, char(dec(ICS_2*100, 11, 0))
     c+  transfer,  char('001', 3) unit ,          CURRENCY
     c+                FROM itemserv
     c+  where ics_2 > 0
     c/end-exec
     c*
     c                   exsr      sr7500
     c*
     c                   endif

     C     ##7000        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr7500        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'QSYS/CPYTOIMPF FROMFILE(tvrelwaeco/transferp) ' +
           'TOFILE(TVRELWAECO/transferp#) '                 +
           'MBROPT(*ADD) STRDLM('' '')  '                   +
           'RMVBLANK(*BOTH) FLDDLM('';'') DECPNT(*COMMA) ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##7500        ENDSR

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

     c                   eval      pjahr = pjahr + 0
     c                   clear                   xp                8 0
     c                   eval      xp=(pjahr*10000)+(pmonat*100)+ptag
     c*                  move      '0101'        xp
     c*                  move      '0101'        xp
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
