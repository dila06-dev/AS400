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
      *
      *********************************************************************************

     f***man       uf   e             disk
     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)
     F***                                     USROPN

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
     C*                  open      man
     C*                  DO        *HIVAL
     C*
     C*                  READ      man                                    95
     C*                  IF        *in95 = '1'
     C*                  leave
     C*                  else
     C*                  movel     man12         artnr
     C*                  exsr      srlines
     c*                  update    phy01r
     c*                  endif
     C
     C*                  enddo
     C*                  close     man
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base tvrelwaeco/SIEVOII
     c                   exsr      sr1000
     C*data base tvrelwaeco/DB_OPTIMUM  level Trans825
     c                   exsr      sr3000
     C*data base tvrelwaeco/DB_OPTIMUM  level Orderqty
     c                   exsr      sr3300
     C*data base tvrelwaeco/DB_OPTIMUM  level Orderinv
     c                   exsr      sr3600
     C*data base tvrelwaeco/DB_OPTIMUM  level Ordersales
     c                   exsr      sr4000
     C*data base tvrelwaeco/DB_OPTIMUM  level Orderturno
     c                   exsr      sr4300
     C*data base tvrelwaeco/DB_OPTIMUM  level OpenOrders
     c                   exsr      sr5000
     C*data base tvrelwaeco/DB_OPTIMUM  level OpenOrderC
     c                   exsr      sr5300
     C*data base tvrelwaeco/DB_OPTIMUM  Bereinigung
     C*                                 level OpenOrderC und openOrders
     c                   exsr      sr5600

     C                   EXSR      RETURN

     C**************************************************************************
     C*tvrelwaeco/SIEVOII
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
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
     C*alle Bestellungen mit Bestelldatum > current date -007 days
     C*oder offene Bestellungen
     c/exec sql
     c+ insert into tvrelwaeco/SIEVOII
     c+ SELECT #LBLBTENR, EPTBZ1, EPMENG, dec(0, 11, 2) STK3,
     c+ dec(0, 11, 2) qtyinv,char(' ', 5) currency, dec(0, 11, 2) invval,
     c+ dec(0, 11, 2) inveuro, #AELFNRR, char(' ', 30) #AELFNRRb,
     c+ #AELFNR, char(' ', 30) #AELFNRb ,char(' ', 30) #AELFNRlnd,
     c+ #AEBEJJ,#AEBENR,#AEBEPO, #LBLBBDAT,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp,
     c+ #WE#EL, dec(0, 17, 0) renr FROM datenkw/#lblb, bbep WHERE
     c+ #LBLBLSTC ='825' and #aefirm= BBEP.EPFIRM and #aebejj=EPBEJJ and
     c+ #aebenr=EPBENR and #aebepo=EPBEpo and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) =year(current date)
     c/end-exec

     C*update Lieferanten
     c/exec sql
     c+ update tvrelwaeco/SIEVOII  set #AELFNRRB  =
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = #AELFNRR and lfFIRM in ('01','51'))
     c+  where exists
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = #AELFNRR and lfFIRM in ('01','51'))
     c/end-exec

     C*update lieferanten
     c/exec sql
     c+ update tvrelwaeco/SIEVOII  set #AELFNRB   =
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = #AELFNR  and lfFIRM in ('01','51'))
     c+  where exists
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = #AELFNR  and lfFIRM in ('01','51'))
     c/end-exec

     C*update lieferanten country
     c/exec sql
     c+ update tvrelwaeco/SIEVOII  set #AELFNRlnd =
     c+ (SELECT LFPOLD FROM lief WHERE
     c+  LFLFNR = #AELFNR  and lfFIRM in ('01','51'))
     c+  where exists
     c+ (SELECT LFPOLD FROM lief WHERE
     c+  LFLFNR = #AELFNR  and lfFIRM in ('01','51'))
     c/end-exec

     C*update stk3
     c/exec sql
     c+ update tvrelwaeco/SIEVOII    set    STK3    =
     c+ (select STK_LCP from bar_kalk/kalk_file where artnr=#LBLBTENR
     c+   and   version = '$$EL_PS_DB')
     c+ where exists
     c+ (select STK_LCP from bar_kalk/kalk_file where artnr=#LBLBTENR
     c+   and   version = '$$EL_PS_DB')
     c/end-exec

     C*update Rechnungsbetrag
     c/exec sql
     c+ update tvrelwaeco/SIEVOII    set    INVVAL  =
     c+  (select sum(RECBTR) from   prodwin51/PRJ627P
     c+    where #WE#EL    = WENR group by WENR)
     c+    where exists
     c+  (select sum(RECBTR) from   prodwin51/PRJ627P
     c+    where #WE#EL    = WENR group by WENR)
     c/end-exec

     C*update Rechnungsnummer
     c/exec sql
     c+ update tvrelwaeco/SIEVOII set renr    =
     c+ (select  max(renr) from prodwin51/PRJ627P
     c+   where #WE#EL = WENR and RECMNG >0 group by wenr)
     c+   where exists
     c+ (select  max(renr) from prodwin51/PRJ627P
     c+   where #WE#EL = WENR and RECMNG >0 group by wenr)
     c/end-exec

     C*update Rechnungsmenge
     c/exec sql
     c+ update tvrelwaeco/SIEVOII    set    QTYINV  =
     c+  (select sum(recmng) from   prodwin51/PRJ627P
     c+    where #WE#EL    = WENR group by WENR)
     c+    where exists
     c+  (select sum(recmng) from   prodwin51/PRJ627P
     c+    where #WE#EL    = WENR group by WENR)
     c/end-exec

     C*update currency
     c/exec sql
     c+ update tvrelwaeco/SIEVOII a set currency  =
     c+ (select  max(WKBEZ) from prodwin51/PRJ626P b
     c+   where a.renr = b.renr group by b.renr)
     c+   where exists
     c+ (select  max(WKBEZ) from prodwin51/PRJ626P b
     c+   where a.renr = b.renr group by b.renr)
     c/end-exec

     C*update quotation
     c/exec sql
     c+ update tvrelwaeco/SIEVOII a set    INVEURO=
     c+ (select  max(wkur)  from prodwin51/PRJ626P b
     c+   where a.renr = b.renr group by b.renr)
     c+   where exists
     c+ (select  max(Wkur)  from prodwin51/PRJ626P b
     c+   where a.renr = b.renr group by b.renr)
     c/end-exec


     C     ##1000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level Trans825
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


     C*update Lieferanten
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTweek
     c+ SELECT #LBLBTENR, dec(sum(EPMENG), 13, 0) EKQTY,
     c+                   dec(sum(QTYINV), 13, 0) INVQTY, int(count(*)) c,
     c+ int(week(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+          substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+          substr(char(#LBLBBDAT), 7, 2))) week from SIEVOII
     c+ GROUP BY #LBLBTENR,
     c+ int(week(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+          substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+          substr(char(#LBLBBDAT), 7, 2)))
     c/end-exec
     C*
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('Trans825  ' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=01)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=01)
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=02)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=02)
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=03)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=03)
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=04)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=04)
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=05)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=05)
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=06)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=06)
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=07)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=07)
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=08)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=08)
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=09)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=09)
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=10)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=10)
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=11)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=11)
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=12)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=12)
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=13)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=13)
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=14)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=14)
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=15)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=15)
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=16)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=16)
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=17)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=17)
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=18)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=18)
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=19)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=19)
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=20)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=20)
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=21)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=21)
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=22)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=22)
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=23)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=23)
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=24)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=24)
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=25)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=25)
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=26)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=26)
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=27)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=27)
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=28)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=28)
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=29)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=29)
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=30)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=30)
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=31)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=31)
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=32)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=32)
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=33)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=33)
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=34)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=34)
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=35)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=35)
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=36)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=36)
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=37)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=37)
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=38)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=38)
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=39)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=39)
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=40)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=40)
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=41)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=41)
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=42)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=42)
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=43)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=43)
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=44)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=44)
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=45)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=45)
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=46)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=46)
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=47)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=47)
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=48)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=48)
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=49)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=49)
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=50)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=50)
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=51)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=51)
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=52)
     c+ where exists
     c+ (select c from DB_OPTWEEK where artnr = #LBLBTENR and week=52)
     c/end-exec

     C     ##3000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level Orderqty
     C*-------------------------------------------------------------------------
     C*
     C     sr3300        BEGSR
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
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('Orderqty  ' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=01
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=01
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=02
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=02
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=03
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=03
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=04
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=04
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=05
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=05
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=06
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=06
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=07
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=07
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=08
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=08
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=09
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=09
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=10
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=10
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=11
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=11
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=12
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=12
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=13
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=13
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=14
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=14
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=15
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=15
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=16
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=16
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=17
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=17
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=18
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=18
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=19
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=19
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=20
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=20
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=21
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=21
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=22
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=22
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=23
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=23
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=24
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=24
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=25
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=25
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=26
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=26
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=27
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=27
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=28
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=28
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=29
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=29
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=30
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=30
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=31
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=31
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=32
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=32
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=33
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=33
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=34
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=34
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=35
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=35
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=36
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=36
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=37
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=37
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=38
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=38
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=39
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=39
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=40
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=40
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=41
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=41
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=42
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=42
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=43
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=43
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=44
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=44
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=45
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=45
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=46
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=46
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=47
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=47
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=48
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=48
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=49
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=49
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=50
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=50
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=51
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=51
     c+         and level= 'Orderqty ')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=52
     c+         and level= 'Orderqty ')
     c+ where exists
     c+ (select EKQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=52
     c+         and level= 'Orderqty ')
     c/end-exec

     C     ##3300        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level Orderinv
     C*-------------------------------------------------------------------------
     C*
     C     sr3600        BEGSR
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
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('Orderinv  ' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=01
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=01
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=02
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=02
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=03
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=03
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=04
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=04
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=05
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=05
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=06
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=06
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=07
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=07
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=08
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=08
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=09
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=09
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=10
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=10
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=11
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=11
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=12
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=12
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=13
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=13
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=14
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=14
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=15
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=15
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=16
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=16
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=17
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=17
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=18
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=18
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=19
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=19
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=20
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=20
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=21
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=21
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=22
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=22
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=23
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=23
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=24
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=24
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=25
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=25
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=26
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=26
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=27
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=27
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=28
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=28
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=29
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=29
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=30
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=30
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=31
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=31
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=32
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=32
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=33
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=33
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=34
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=34
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=35
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=35
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=36
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=36
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=37
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=37
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=38
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=38
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=39
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=39
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=40
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=40
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=41
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=41
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=42
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=42
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=43
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=43
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=44
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=44
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=45
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=45
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=46
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=46
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=47
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=47
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=48
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=48
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=49
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=49
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=50
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=50
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=51
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=51
     c+         and level= 'Orderinv ')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=52
     c+         and level= 'Orderinv ')
     c+ where exists
     c+ (select INVQTY from DB_OPTWEEK where artnr = #LBLBTENR and week=52
     c+         and level= 'Orderinv ')
     c/end-exec

     C     ##3600        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level Ordersales
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
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

     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE2
     c+ select aptenr,
     c+ int(week(substr(char(rkreda), 1, 4) concat '-' concat
     c+          substr(char(rkreda), 5, 2) concat '-' concat
     c+          substr(char(rkreda), 7, 2))) week,
     c+ dec(sum(APGLMG*1     ), 13, 2) APGLMG,
     c+ dec(sum(RPNESU*WAKURS), 13, 2) RPNESU,
     c+ dec(sum(RPBRSU*WAKURS), 13, 2) RPBRSU,
     c+ dec(sum(RPERG1*WAKURS), 13, 2) RPERG1,
     c+ dec(sum(RPERG2*WAKURS), 13, 2) RPERG2,
     c+ dec(sum(RPERG3*WAKURS), 13, 2) RPERG3,
     c+ dec(sum(RPERG4*WAKURS), 13, 2) RPERG4,
     c+ dec(sum(ZA1*WAKURS), 13, 2) ZA1,
     c+ dec(sum(ZA2*WAKURS), 13, 2) ZA2,
     c+ dec(sum(ZA3*WAKURS), 13, 2) ZA3,
     c+ dec(sum(ZA4*WAKURS), 13, 2) ZA4
     c+ FROM tvrelwaeco/absatz  where
     c+ year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+      substr(char(rkreda), 5, 2) concat '-' concat
     c+      substr(char(rkreda), 7, 2) )) =year(current date)
     c+ group by aptenr,
     c+ int(week(substr(char(rkreda), 1, 4) concat '-' concat
     c+          substr(char(rkreda), 5, 2) concat '-' concat
     c+          substr(char(rkreda), 7, 2)))
     c/end-exec
     C*
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('Ordersales' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=01
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=01
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=02
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=02
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=03
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=03
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=04
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=04
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=05
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=05
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=06
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=06
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=07
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=07
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=08
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=08
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=09
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=09
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=10
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=10
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=11
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=11
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=12
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=12
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=13
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=13
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=14
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=14
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=15
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=15
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=16
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=16
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=17
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=17
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=18
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=18
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=19
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=19
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=20
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=20
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=21
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=21
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=22
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=22
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=23
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=23
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=24
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=24
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=25
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=25
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=26
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=26
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=27
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=27
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=28
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=28
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=29
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=29
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=30
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=30
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=31
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=31
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=32
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=32
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=33
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=33
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=34
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=34
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=35
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=35
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=36
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=36
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=37
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=37
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=38
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=38
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=39
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=39
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=40
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=40
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=41
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=41
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=42
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=42
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=43
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=43
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=44
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=44
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=45
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=45
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=46
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=46
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=47
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=47
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=48
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=48
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=49
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=49
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=50
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=50
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=51
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=51
     c+         and level= 'Ordersales')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=52
     c+         and level= 'Ordersales')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE2 where artnr = APTENR    and week=52
     c+         and level= 'Ordersales')
     c/end-exec

     C     ##4000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level Orderturno
     C*-------------------------------------------------------------------------
     C*
     C     sr4300        BEGSR
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
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('Orderturno' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=01
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=01
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=02
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=02
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=03
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=03
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=04
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=04
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=05
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=05
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=06
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=06
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=07
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=07
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=08
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=08
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=09
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=09
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=10
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=10
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=11
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=11
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=12
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=12
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=13
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=13
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=14
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=14
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=15
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=15
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=16
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=16
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=17
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=17
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=18
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=18
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=19
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=19
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=20
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=20
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=21
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=21
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=22
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=22
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=23
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=23
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=24
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=24
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=25
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=25
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=26
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=26
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=27
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=27
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=28
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=28
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=29
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=29
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=30
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=30
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=31
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=31
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=32
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=32
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=33
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=33
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=34
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=34
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=35
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=35
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=36
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=36
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=37
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=37
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=38
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=38
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=39
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=39
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=40
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=40
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=41
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=41
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=42
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=42
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=43
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=43
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=44
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=44
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=45
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=45
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=46
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=46
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=47
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=47
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=48
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=48
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=49
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=49
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=50
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=50
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=51
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=51
     c+         and level= 'Orderturno')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=52
     c+         and level= 'Orderturno')
     c+ where exists
     c+ (select RPBRSU from DB_OPTWEE2 where artnr = APTENR    and week=52
     c+         and level= 'Orderturno')
     c/end-exec

     C     ##4300        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level OpenOrders
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
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

      * (year(substr(char(APLFTE), 1, 4) concat '-' concat
      *       substr(char(APLFTE), 5, 2) concat '-' concat
      *       substr(char(APLFTE), 7, 2))) = year(current date)
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE3
     c+ SELECT aptenr,    dec((sum(APBSMG)-sum(APglmG)), 13, 0) APglmG,
     c+                   int(count(*)) c,
     c+ int(week(substr(char(APLFTE), 1, 4) concat '-' concat
     c+          substr(char(APLFTE), 5, 2) concat '-' concat
     c+          substr(char(APLFTE), 7, 2))) week from afpo
     c+          WHERE APAFST <  '20' and aplanr not in ('004', '011')
     c+                and apfirm in ('01')
     c+                and APAFAT in ('01','08','11','16','17','18',
     c+                               '20','25','26','27','28',
     c+                               '41','44',
     c+                               '81','A02') and
     c+    (date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+          substr(char(APLFTE), 5, 2) concat '-' concat
     c+          substr(char(APLFTE), 7, 2))) > current date - 365 day
     c+ GROUP BY aptenr,
     c+ int(week(substr(char(APLFTE), 1, 4) concat '-' concat
     c+          substr(char(APLFTE), 5, 2) concat '-' concat
     c+          substr(char(APLFTE), 7, 2)))
     c/end-exec
     C*
     C*intergartion abhängiger Verkaufsstücklisten
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE3
     c+ SELECT AUKOTE, dec((aUMENG*APglmG), 13, 0) ,count(*) ,week FROM
     c+ afup, db_optwee3 WHERE AUFIRM ='01' and AUBGTE= APTENR GROUP BY
     c+ AUBGTE, AUKOTE ,aumeng,APglmG,week ORDER BY aukote
     c/end-exec
     C*
     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('OpenOrders' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c+ ) and artnr in (select APTENR from tvrelwaeco/DB_OPTWEE3)
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=01
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=01
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=02
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=02
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=03
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=03
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=04
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=04
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=05
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=05
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=06
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=06
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=07
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=07
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=08
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=08
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=09
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=09
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=10
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=10
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=11
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=11
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=12
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=12
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=13
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=13
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=14
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=14
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=15
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=15
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=16
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=16
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=17
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=17
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=18
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=18
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=19
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=19
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=20
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=20
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=21
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=21
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=22
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=22
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=23
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=23
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=24
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=24
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=25
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=25
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=26
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=26
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=27
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=27
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=28
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=28
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=29
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=29
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=30
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=30
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=31
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=31
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=32
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=32
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=33
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=33
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=34
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=34
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=35
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=35
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=36
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=36
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=37
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=37
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=38
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=38
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=39
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=39
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=40
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=40
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=41
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=41
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=42
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=42
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=43
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=43
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=44
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=44
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=45
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=45
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=46
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=46
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=47
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=47
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=48
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=48
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=49
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=49
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=50
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=50
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=51
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=51
     c+         and level= 'OpenOrders')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=52
     c+         and level= 'OpenOrders')
     c+ where exists
     c+ (select APGLMG from DB_OPTWEE3 where artnr = APTENR    and week=52
     c+         and level= 'OpenOrders')
     c/end-exec

     C     ##5000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  level OpenOrderC
     C*-------------------------------------------------------------------------
     C*
     C     sr5300        BEGSR
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

     C*vorlauf
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTIMUM
     c+ SELECT char('OpenOrderC' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,LIEFERANT1,
     c+ b005, stK_LCP,WEKPR,wacdek,EKPR,KWAKURS,abc, substr(ARTZ3, 1, 2)
     c+ Status,a001,##ART290 sib,
     c+ #TEVOZ1,LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,
     c+ #TEDIAV,ZOLLNR,CCSTCK,ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,
     c+ KCJMNG_AJ,TSTAMP,
     c+                  char(' ', 2) TEARKZ,dec(0, 13, 2) Purcha,
     c+ dec(0, 13 , 2) Transit,dec(0, 13, 2) blocked,
     c+                  int(0) w1,int(0) w2,int(0) w3,int(0) w4,
     c+ int(0) w5,int(0) w6,int(0) w7,int(0) w8,int(0) w9,int(0) w10,
     c+ int(0) w11,int(0) w12,int(0) w13,int(0) w14,int(0) w15, int(0) w16,
     c+ int(0) w17,int(0) w18,int(0) w19,int(0) w20,int(0) w21, int(0) w22,
     c+ int(0) w23,int(0) w24,int(0) w25,int(0) w26,int(0) w27, int(0) w28,
     c+ int(0) w29,int(0) w30,int(0) w31,int(0) w32,int(0) w33, int(0) w34,
     c+ int(0) w35,int(0) w36,int(0) w37,int(0) w38,int(0) w39, int(0) w40,
     c+ int(0) w41,int(0) w42,int(0) w43,int(0) w44,int(0) w45, int(0) w46,
     c+ int(0) w47,int(0) w48,int(0) w49,int(0) w50,int(0) w51, int(0) w52,
     c+ version,int(0) su from bar_kalk/kalk_file WHERE
     c+ (
     c+ (STATNR in ('190','199','290','299','399','490','491', '499')
     c+   and version = '$$EL_PS_DB')                                  or
     c+  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
     c+  (a001 <> 0       and      version = '$$EL_PS_DB')             or
     c+  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
     c+  (date (date(substr(char(anldat), 1, 4) concat '-' concat
     c+        substr(char(anldat), 5, 2) concat '-' concat
     c+        substr(char(anldat), 7, 2) )) > current date -31 days and
     c+                            version = '$$EL_PS_DB')
     c+ ) and artnr in (select APTENR from tvrelwaeco/DB_OPTWEE3)
     c/end-exec

     C*update w1
     c/exec sql
     c+ update db_optimum  set w1 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=01
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=01
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w2
     c/exec sql
     c+ update db_optimum  set w2 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=02
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=02
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w3
     c/exec sql
     c+ update db_optimum  set w3 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=03
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=03
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w4
     c/exec sql
     c+ update db_optimum  set w4 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=04
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=04
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w5
     c/exec sql
     c+ update db_optimum  set w5 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=05
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=05
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w6
     c/exec sql
     c+ update db_optimum  set w6 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=06
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=06
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w7
     c/exec sql
     c+ update db_optimum  set w7 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=07
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=07
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w8
     c/exec sql
     c+ update db_optimum  set w8 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=08
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=08
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w9
     c/exec sql
     c+ update db_optimum  set w9 =
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=09
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=09
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w10
     c/exec sql
     c+ update db_optimum  set w10=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=10
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=10
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w11
     c/exec sql
     c+ update db_optimum  set w11=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=11
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=11
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w12
     c/exec sql
     c+ update db_optimum  set w12=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=12
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=12
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w13
     c/exec sql
     c+ update db_optimum  set w13=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=13
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=13
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w14
     c/exec sql
     c+ update db_optimum  set w14=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=14
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=14
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w15
     c/exec sql
     c+ update db_optimum  set w15=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=15
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=15
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w16
     c/exec sql
     c+ update db_optimum  set w16=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=16
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=16
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w17
     c/exec sql
     c+ update db_optimum  set w17=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=17
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=17
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w18
     c/exec sql
     c+ update db_optimum  set w18=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=18
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=18
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w19
     c/exec sql
     c+ update db_optimum  set w19=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=19
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=19
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w20
     c/exec sql
     c+ update db_optimum  set w20=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=20
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=20
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w21
     c/exec sql
     c+ update db_optimum  set w21=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=21
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=21
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w22
     c/exec sql
     c+ update db_optimum  set w22=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=22
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=22
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w23
     c/exec sql
     c+ update db_optimum  set w23=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=23
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=23
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w24
     c/exec sql
     c+ update db_optimum  set w24=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=24
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=24
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w25
     c/exec sql
     c+ update db_optimum  set w25=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=25
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=25
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w26
     c/exec sql
     c+ update db_optimum  set w26=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=26
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=26
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w27
     c/exec sql
     c+ update db_optimum  set w27=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=27
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=27
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w28
     c/exec sql
     c+ update db_optimum  set w28=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=28
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=28
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w29
     c/exec sql
     c+ update db_optimum  set w29=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=29
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=29
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w30
     c/exec sql
     c+ update db_optimum  set w30=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=30
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=30
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w31
     c/exec sql
     c+ update db_optimum  set w31=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=31
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=31
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w32
     c/exec sql
     c+ update db_optimum  set w32=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=32
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=32
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w33
     c/exec sql
     c+ update db_optimum  set w33=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=33
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=33
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w34
     c/exec sql
     c+ update db_optimum  set w34=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=34
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=34
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w35
     c/exec sql
     c+ update db_optimum  set w35=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=35
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=35
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w36
     c/exec sql
     c+ update db_optimum  set w36=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=36
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=36
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w37
     c/exec sql
     c+ update db_optimum  set w37=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=37
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=37
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w38
     c/exec sql
     c+ update db_optimum  set w38=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=38
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=38
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w39
     c/exec sql
     c+ update db_optimum  set w39=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=39
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=39
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w40
     c/exec sql
     c+ update db_optimum  set w40=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=40
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=40
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w41
     c/exec sql
     c+ update db_optimum  set w41=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=41
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=41
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w42
     c/exec sql
     c+ update db_optimum  set w42=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=42
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=42
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w43
     c/exec sql
     c+ update db_optimum  set w43=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=43
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=43
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w44
     c/exec sql
     c+ update db_optimum  set w44=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=44
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=44
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w45
     c/exec sql
     c+ update db_optimum  set w45=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=45
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=45
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w46
     c/exec sql
     c+ update db_optimum  set w46=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=46
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=46
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w47
     c/exec sql
     c+ update db_optimum  set w47=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=47
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=47
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w48
     c/exec sql
     c+ update db_optimum  set w48=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=48
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=48
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w49
     c/exec sql
     c+ update db_optimum  set w49=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=49
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=49
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w50
     c/exec sql
     c+ update db_optimum  set w50=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=50
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=50
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w51
     c/exec sql
     c+ update db_optimum  set w51=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=51
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=51
     c+         and level= 'OpenOrderC')
     c/end-exec

     C*update w52
     c/exec sql
     c+ update db_optimum  set w52=
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=52
     c+         and level= 'OpenOrderC')
     c+ where exists
     c+ (select c      from DB_OPTWEE3 where artnr = APTENR    and week=52
     c+         and level= 'OpenOrderC')
     c/end-exec

     C     ##5300        ENDSR

     C**************************************************************************
     C*tvrelwaeco/DB_OPTIMUM  Bereinigung level OpenOrders und OpenOrderC
     C*-------------------------------------------------------------------------
     C*
     C     sr5600        BEGSR
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

     C*vorlauf
     c/exec sql
     c+ delete FROM db_optimum WHERE LEVEL in ('OpenOrderC','OpenOrders')
     c+ and   w1=0 and w2=0 and w3=0 and w4=0 and w5=0 and w6=0 and
     c+  w7=0 and  w8=0 and  w9=0 and w10=0 and w11=0 and w12=0 and
     c+ w13=0 and w14=0 and w15=0 and w16=0 and w17=0 and w18=0 and
     c+ w19=0 and w20=0 and w21=0 and w22=0 and w23=0 and w24=0 and
     c+ w25=0 and w26=0 and w27=0 and w28=0 and w29=0 and w30=0 and
     c+ w31=0 and w32=0 and w33=0 and w34=0 and w35=0 and w36=0 and
     c+ w37=0 and w38=0 and w39=0 and w40=0 and w41=0 and w42=0 and
     c+ w43=0 and w44=0 and w45=0 and w46=0 and w47=0 and w48=0 and
     c+ w49=0 and w50=0 and w51=0 and w52=0
     c/end-exec

     C     ##5600        ENDSR

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
