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
      **** Änderung der Vorselektion Gude 25.04.2013  (alte Version)         */
      * ((STATNR in ('190','199','290','299','399','490','491', '499')
      *   and version = '$$EL_PS_DB')                                  or
      *  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
      *  (a001 <> 0       and      version = '$$EL_PS_DB')             or
      *  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
      *  (date (date(substr(char(anldat), 1, 4) concat '-' concat
      *        substr(char(anldat), 5, 2) concat '-' concat
      *        substr(char(anldat), 7, 2) )) > current date -31 days and
      *                            version = '$$EL_PS_DB'))
      *
      *
      *********************************************************************************

     fDB_OPT_JQLuf a e           k disk
     f                                     RENAME(DB_OPT_JQ:phy01r)
     f****                                 INFDS(DSF1)
     F                                     USROPN

     fDB_OPTREPLif   e             disk
     f                                     RENAME(DB_OPTREP2:phy02r)
     f****                                 INFDS(DSF2)
     F                                     USROPN
     f                                     prefix('§')

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
     c                   exsr      sr2000
     C*alle Lagerbestände anpassen per Definition
     c                   exsr      sr8000
     c                   exsr      sr8500

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

     C*alle lagerdaten aufbauen für Folgeprozess
     c*/exec sql
     c*+ insert into tvrelwaeco/DB_OPT_LAG
     c*+ SELECT DISTINCT LBBSLANR, ldlbz1, A.LBBSTENR,LBBSMEIN,
     c*+ decimal(sum(LBBSLAGB ), 13, 2) amount
     c*+ FROM LBBs a, lbsd b where
     c*+ LBBSFIRM=01 and LDFIRM=1 and LBBSFIRM=LDFIRM and
     c*+ LBBSlanr=LDlanr and LBBSSPKZ<>'J' GROUP BY LBBSLANR,
     c*+ ldlbz1,A.LBBSTENR, LBBSMEIN
     c*/end-exec

     c/exec sql
     c+ update bar_kalk/kalk_file a set b005      = 0
     c/end-exec

     C*Mindestbestellmenge updaten
     c/exec sql
     c+ update bar_kalk/kalk_file a set b005      =
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
     c+         and (LPFIRM ='01' or LPFIRM ='51'))
     c+ where exists
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
     c+         and (LPFIRM ='01' or LPFIRM ='51'))
     c/end-exec

     C*Mindestbestellmenge updaten Sonderfall
     c/exec sql
     c+ update bar_kalk/kalk_file a set b005      =
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant2=LPLFNR  and version='$$EL_PS_DB'
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51')
     c+                     and lieferant1 ='90733')
     c+  where exists
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant2=LPLFNR  and version='$$EL_PS_DB'
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51')
     c+                     and lieferant1 ='90733')
     c/end-exec

     C*databas
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPT_JQ
     c+ SELECT char('level     ' , 10) level,
     c+ ARTNR,ARTBEZ,ARTGRP,STATNR,
     c+ char( LIEFERANT2 concat '                               ', 40)
     c+ lieferant1, b005,stK_LCP,WEKPR,wacdek,EKPR,
     c+ KWAKURS,abc,substr(ARTZ3, 1, 2) Status,a001,##ART290 sib,#TEVOZ1,
     c+ LAENGE,BREITE,HOEHE,GEWICHT,e1,#TESAAV,#TEDIAV,ZOLLNR,CCSTCK,
     c+ ANLDAT,ARTSKU,ARTEAN, EVP_AJ, KCJMNG_VJ,KCJMNG_AJ,TSTAMP,
     c+ sys02 TEARKZ, veh,dec(0, 13, 2) Purcha,dec(0, 13 , 2) Transit,
     c+ dec(0, 13, 2) blocked,
     c+ int(0) mvv1,int(0) mvv2,int(0) mvv3,int(0) mvv4,int(0) mvv5,
     c+ int(0) mvv6,int(0) mvv7,int(0) mvv8,int(0) mvv9,int(0) mvv10,
     c+ int(0) mvv11,int(0) mvv12,
     c+ int(0) mv1,int(0) mv2,int(0) mv3,int(0) mv4,int(0) mv5,int(0) mv6,
     c+ int(0) mv7,int(0) mv8,int(0) mv9,int(0) mv10,int(0) mv11,
     c+ int(0) mv12,
     c+ int(0) mp1,int(0) mp2,int(0) mp3,int(0) mp4,int(0) mp5,int(0) mp6,
     c+ int(0) mp7,int(0) mp8,int(0) mp9,int(0) mp10,int(0) mp11,
     c+ int(0) mp12,
     c+ int(0) mc1,int(0) mc2,int(0) mc3,int(0) mc4,int(0) mc5,int(0) mc6,
     c+ int(0) mc7,int(0) mc8,int(0) mc9,int(0) mc10,int(0) mc11,
     c+ int(0) mc12,
     c+ int(0) TApJ,int(0) TAcJ,int(0) A825pJ,int(0) TA825pJ,
     c+ int(0) openord,int(0) backord,
     c+ version,int(0) su,char(' ', 15) mainitem,
     c+ int(0) openordp, int(0) backordp,zoned(00000000, 8, 0) lvk,
     c+ zoned(00000000, 8, 0) lbew, zoned(00000000, 8, 0) reservqty,
     c+ zoned(00000000, 8, 0) opprod, zoned(00000000, 8, 0) opprodst,
     c+                                   current timestamp Laufzeit
     c+ from bar_kalk/kalk_file WHERE
     c+ (
     c+  (statnr <'900' and version = '$$EL_PS_DB' and sys01 <> 'P ') )
     c/end-exec
     C*update Lieferanten
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set LIEFERANT1 =
     c+ substr(LIEFERANT1, 1, 6) concat
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = LIEFERANT1 and lfFIRM in ('01','51'))
     c+  where exists
     c+ (SELECT LFNAM1 FROM lief WHERE
     c+  LFLFNR = LIEFERANT1 and lfFIRM in ('01','51'))
     c/end-exec

     C*Verpackungseinheit initialisieren
     c/exec sql
     c+  update tvrelwaeco/DB_OPT_JQ set veh       = 0
     c/end-exec

     C*Verpackungseinheit aus Lieferantenzuordnung
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set veh       =
     c+ (select LPGBGR     from lpif
     c+  where artnr=lptenr and substr(lieferant1, 1, 5) =LPLFNR
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c+  where exists
     c+ (select LPGBGR     from lpif
     c+  where artnr=lptenr and substr(lieferant1, 1, 5) =LPLFNR
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c/end-exec

     C*Initialisierung der Mindestbestellmenge
     c/exec sql
     c+ update tvrelwaeco/DB_opt_jq set b005      = 0
     c/end-exec

     C*Verpackungseinheit aus Lieferantenzuordnung
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set b005      =
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and substr(lieferant1, 1, 5) =LPLFNR
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c+  where exists
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and substr(lieferant1, 1, 5) =LPLFNR
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c/end-exec

     C*eindeutige sku zuordnen
     c/exec sql
     c+ update  tvrelwaeco/db_opt_jq a set  a.artsku      =
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  a.artnr=artnr and version ='$$EL_PS_DB' and artbezfra <> ' ')
     c+ where exists
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  a.artnr=artnr and version ='$$EL_PS_DB' and artbezfra <> ' ')
     c/end-exec


     C     ##1000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/SIEVOII
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
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
     C*current date year DB_OPTLBCD
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLBCD
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE  #LBLBLSTC in
     c+   ('130','610','810','817','825','820','530','531','532') and
     c**+ ('130','000','810','817','000','000','000','000','000') and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) =year(current date)
     c/end-exec

     C*previous year DB_OPTLBC2
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLBC2
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE  #LBLBLSTC in
     c+   ('130','610','810','817','825','820','530','531','532') and
     c**+ ('130','000','810','817','000','000','000','000','000') and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) =year(current date -1 year)
     c/end-exec

     C*pre previous year DB_OPTLBC3
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLBC3
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE  #LBLBLSTC in
     c+  ('130','610','810','817','825','820','530','531','532') and
     c** ('130','000','810','817','000','000','000','000','000') and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) =year(current date -2 year)
     c/end-exec

     C*pre pre previous year DB_OPTLBC4
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLBC4
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE  #LBLBLSTC in
     c+  ('130','610','810','817','825','820','530','531','532') and
     c** ('130','000','810','817','000','000','000','000','000') and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) =year(current date -3 year)
     c/end-exec

     C*last 365 days DB_OPTLBC5
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLBC5
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE  #LBLBLSTC in
     c+   ('130','610','810','817','825','820','530','531','532') and
     c**+ ('130','000','810','817','000','000','000','000','000') and
     c+ date(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) >(current date -365 days)
     c/end-exec

     C*            _________________________________________
     C*
     C*update mc1 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc1 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mc2 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc2 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mc3 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc3 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mc4 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc4 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mc5 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc5 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mc6 current year
     c/exec sql
     c+ update DB_OPT_JQ   set mc6 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc7 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc8 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc9 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc10 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc11 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mc12 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBCD
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*            _________________________________________
     C*
     C*update mp1 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp1 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mp2 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp2 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mp3 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp3 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mp4 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp4 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mp5 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp5 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mp6 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mp6 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp7 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp8 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp9 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp10 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp11 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mp12 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC2
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*            _________________________________________
     C*
     C*update mv1 pre previous year
     c/exec sql
     c+ update DB_OPT_JQ   set mv1 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv2 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mv2 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv3 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mv3 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv4 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mv4 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv5 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mv5 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv6 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mv6 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv7 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv8 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv9 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv10 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv11 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mv12 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC3
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c*               _______________________________

     C*update mv1 pre previous year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv1 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=01 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv2 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv2 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=02 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv3 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv3 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=03 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv4 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv4 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=04 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv5 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv5 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=05 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update mv6 prvious year
     c/exec sql
     c+ update DB_OPT_JQ   set mvv6 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=06 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv7 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=07 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv8 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=08 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv9 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=09 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv10 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=10 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv11 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=11 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c/exec sql
     c+ update DB_OPT_JQ   set mvv12 =
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC4
     c+  where artnr=#LBLBTENR and SEL0008=12 and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     c*               _______________________________
     C*
     C*update TAcJ current year Transaktionen letzten 365 Days
     c/exec sql
     c+ update DB_OPT_JQ   set TAcJ=
     c+ (select count(*)       from DB_OPTLBC5
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select count(*)       from DB_OPTLBCD
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('130','610','810','817','530','531','532')
     c+  group by #LBLBTENR)
     c/end-exec

     C*
     C*update TApJ previous year Transaktionen komplett
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set tapj       =
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_LAG WHERE artnr = LBBSTENR
     c+  group by LBBSTENR )
     c+  where exists
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_LAG WHERE artnr = LBBSTENR
     c+  group by LBBSTENR )
     c/end-exec

     C*update A825pJ previous year quantity
     C*geändert 2 Bedingung war falsch auf DB_OPTLBC2 05.03.2014
     c/exec sql
     c+ update DB_OPT_JQ   set A825pJ=
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC5
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('825','820','820','820')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select sum(#LBLBBWMG) from DB_OPTLBC5
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('825','820','820','820')
     c+  group by #LBLBTENR)
     c/end-exec

     C*update TA825pJ previous year Transaktionen
     C*geändert 2 Bedingung war falsch auf DB_OPTLBC2 05.03.2014
     c/exec sql
     c+ update DB_OPT_JQ   set TA825pJ=
     c+ (select count(*)       from DB_OPTLBC5
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('825','820','820','820')
     c+  group by #LBLBTENR)
     c+ where exists
     c+ (select count(*)       from DB_OPTLBC5
     c+  where artnr=#LBLBTENR                and
     c+        #LBLBLSTC in ('825','820','820','820')
     c+  group by #LBLBTENR)
     c/end-exec

     C*alle offene Bestellungen AUSGANGSDATEI
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE4
     c+ SELECT dec(sum(EPMENG), 13, 2) epmeng, EPTENR FROM bbek, bbep
     c+ WHERE EKFIRM=epFIRM and EKBEJJ=epbeJJ and EKBENR=EpBENR and
     c+ epbejj>2011 and epbest < '30' and ekfirm in ('01', '51') and
     c+ epfirm in ('01', '51') GROUP BY EPTENR
     c/end-exec

     C*ungeklärten Aufträge Kopf und Position  wie z.B.
     C*97 ==> Freigabevermerk durch Buchhaltung fehlt für weitere
     C*       Transaktion
     C*96 ==> Fehlerfall in Schnittstelle, wartet auf weitere Bearbeitung
     C*89 ==> Auftrag nicht abgeschlossen ( zum Testen, evtl. wird evtl.
     C*       auch direkt zum Auftrag)
     C*91 ==> Freigabe durch Vertriebsbereich erforderlich ( wegen
     C*       Kreditprüfung/Limitprüfung )
     C*87 ==> Embargoprüfung
     C*
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE6
     c+ SELECT aptenr,dec(APBSMG-APglmG, 13, 0) APglmG,
     c+        APFIRM,APAFST,APAFJJ,APAFNR,APAFPO,APAFJJ,APAFNR,APAFPO
     c+        AkAFJJ,AkAFNR,AkAFST,dec(0, 13, 4) LBRSRSMG
     c+ from afpo, afko
     c+ WHERE APAFST <  '20' and aplanr not in ('004', '011')
     c+       and apfirm in ('01')
     c+       and APAFAT in ('01','08','11','16','17','18',
     c+                      '20','25','26','27','28',
     c+                      '41','44',
     c+                      '81','A02') and
     c+ (date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+       substr(char(APLFTE), 5, 2) concat '-' concat
     c+       substr(char(APLFTE), 7, 2))) > current date - 365 day and
     c+       AkAFJJ=apafjj and AkAFNR=ApAFNR  and akfirm=apfirm
     c+       and AkAFST  <> '  '
     c/end-exec

     C*und Verknüpfung mit aktiven Reservierungen
     C*
     c/exec sql
     c+ update DB_OPTWEE6 a         set LBRSRSMG  =
     c+ (select LBRSRSMG   from lbrs
     c+  where APFIRM = LBRSFIRM and APAFJJ = LBRSAFJJ and
     c+        APAFNR = LBRSAFNR and APAFPO = LBRSAFPO and
     c+        LBRSSTAT <> '90' )
     c+ where exists
     c+ (select LBRSRSMG   from lbrs
     c+  where APFIRM = LBRSFIRM and APAFJJ = LBRSAFJJ and
     c+        APAFNR = LBRSAFNR and APAFPO = LBRSAFPO  and
     c+        LBRSSTAT <> '90' )
     c/end-exec

     C*----------------------------------------------
     C*alle offenen Bestellungen Lieferantenbewertung
     C*Achtung nicht löschen !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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

     C*abschliessende Analyse
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

     C*----------------------------------------------

     C*update Purcha offene Bestellungen
     c/exec sql
     c+ update DB_OPT_JQ   set Purcha=
     c+ (select EPMENG from DB_OPTWEE4 where artnr=EPTENR)
     c+ where exists
     c+ (select EPMENG from DB_OPTWEE4 where artnr=EPTENR)
     c/end-exec

     C*alle Bestellungen im Transit AUSGANGSDATEI
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTWEE5
     c+ SELECT epbest, count(*) FROM bbek b, bbep a WHERE EKFIRM=epFIRM
     c+ and EKBEJJ=epbeJJ and EKBENR=EpBENR and epbejj=2012 and epbest
     c+ > '29' and epbest < '41' and ekfirm in ('01', '51') and epfirm
     c+ in ('01', '51') GROUP BY epbest ORDER BY epbest
     c/end-exec

     C*update Transit für im transit befindliche Ware
     c*/exec sql
     c*+ update DB_OPT_JQ   set Transit  =
     c*+ (select EPMENG from DB_OPTWEE5 where artnr=EPTENR)
     c*+ where exists
     c*+ (select EPMENG from DB_OPTWEE5 where artnr=EPTENR)
     c*/end-exec
     C*
     C*update Transit für im transit befindliche Ware
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set Transit  =
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_LAG WHERE artnr = LBBSTENR and
     c+ LBBSLANR in ('500','510')
     c+ group by LBBSTENR )
     c+ where exists
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_LAG WHERE artnr = LBBSTENR and
     c+ LBBSLANR in ('500','510')
     c+ group by LBBSTENR )
     c/end-exec
     C*
     C*update offene Verkaufsorder 365 Tages-Regelung
     c/exec sql
     c+ update DB_OPT_JQ   set OPENORD =
     c+ (select sum(APGLMG) from DB_OPTWEE3 where artnr = APTENR
     c+  group by aptenr)
     c+ where exists
     c+ (select sum(APGLMG) from DB_OPTWEE3 where artnr = APTENR
     c+  group by aptenr)
     c/end-exec

     C*update offene Verkaufsorder Rückstände
     c/exec sql
     c+ update DB_OPT_JQ   set BACKORD =
     c+ (SELECT dec((sum(APBSMG)-sum(APglmG)), 13, 0) from afpo
     c+         WHERE APAFST='17' and artnr=APTENR and apfirm='01' and
     c+               APAFAT <> '45' and aplanr not in ('004', '011')
     c+               and APAFAT in ('01','08','11','16','17','18',
     c+                              '20','25','26','27','28',
     c+                              '41','44',
     c+                              '81','A02') and
     c+ (date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+       substr(char(APLFTE), 5, 2) concat '-' concat
     c+       substr(char(APLFTE), 7, 2))) > current date - 365 day
     c+       GROUP BY aptenr)
     c+ where exists
     c+ (SELECT dec((sum(APBSMG)-sum(APglmG)), 13, 0) from afpo
     c+         WHERE APAFST='17' and artnr=APTENR and apfirm='01' and
     c+               APAFAT <> '45' and aplanr not in ('004', '011')
     c+               and APAFAT in ('01','08','11','16','17','18',
     c+                              '20','25','26','27','28',
     c+                              '41','44',
     c+                              '81','A02') and
     c+ (date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+       substr(char(APLFTE), 5, 2) concat '-' concat
     c+       substr(char(APLFTE), 7, 2))) > current date - 365 day
     c+       GROUP BY aptenr)
     c/end-exec

     C*update offene Bestellorder
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set OPENORDP   =
     c+ (SELECT decimal(sum(EPmeng-EPglmg), 13, 2) FROM bbep WHERE
     c+  artnr = eptenr and EPFIRM = '01' and  EPLANR<>'011'  and
     c+  EPBEST < '60' and EPBEST not in ('40', '45', '50')
     c+  group by EPTENR )
     c+  where exists
     c+ (SELECT decimal(sum(EPmeng-EPglmg), 13, 2) FROM bbep WHERE
     c+  artnr = eptenr and EPFIRM = '01' and  EPLANR<>'011'  and
     c+  EPBEST < '60' and EPBEST not in ('40', '45', '50')
     c+  group by EPTENR )
     c/end-exec

     C*update offene Bestellorder Rückstände
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set backordP   =
     c+ (SELECT decimal(sum(EPmeng-EPglmg), 13, 2) FROM bbep WHERE
     c+  artnr = eptenr and EPFIRM = '01' and  EPLANR<>'011'  and
     c+  EPBEST < '60' and EPBEST not in ('40', '45', '50') and
     c+  date(substr(char(EPBETE), 1, 4) concat '-' concat
     c+       substr(char(EPBETE), 5, 2) concat '-' concat
     c+       substr(char(EPBETE), 7, 2) ) < (current date)
     c+  group by EPTENR )
     c+  where exists
     c+ (SELECT decimal(sum(EPmeng-EPglmg), 13, 2) FROM bbep WHERE
     c+  artnr = eptenr and EPFIRM = '01' and  EPLANR<>'011'  and
     c+  EPBEST < '60' and EPBEST not in ('40', '45', '50') and
     c+  date(substr(char(EPBETE), 1, 4) concat '-' concat
     c+       substr(char(EPBETE), 5, 2) concat '-' concat
     c+       substr(char(EPBETE), 7, 2) ) < (current date)
     c+  group by EPTENR )
     c/end-exec

     C*reservierte Mengen
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set RESERVQTY  =
     c+ (SELECT  sum(LBRSRSMG)  FROM LBRS WHERE
     c+  artnr = LBRSTENR and LBRSFIRM = '01' and LBRSSTAT <> '90'
     c+  group by LBRSTENR )
     c+  where exists
     c+ (SELECT  sum(LBRSRSMG)  FROM LBRS WHERE
     c+  artnr = LBRSTENR and LBRSFIRM = '01' and LBRSSTAT <> '90'
     c+  group by LBRSTENR )
     c/end-exec

     C     ##2000        ENDSR

     C**************************************************************************
     C*tvrelwaeco/SIEVOII
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
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

     C* Lagermengen per Definition
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set A001       =
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_Lg  WHERE artnr = LBBSTENR and
     c+  LBBSLANR in ('130','060','070','100','400','110','410','001',
     c+               '200','300','240','008','009')
     c+  group by LBBSTENR )
     c+  where exists
     c+ (SELECT sum(AMOUNT) FROM DB_OPT_Lg  WHERE artnr = LBBSTENR and
     c+  LBBSLANR in ('130','060','070','100','400','110','410','001',
     c+               '200','300','240','008','009')
     c+  group by LBBSTENR )
     c/end-exec

     C*Sperrlager per Definition
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set BLOCKED    =
     c+ (SELECT decimal(sum(LBBSLAGB), 13, 2) FROM lbbs WHERE
     c+  artnr = LBBSTENR and LBBSFIRM = '01' and
     c+  LBBSSPKZ='J' and  LBBSSPGR in('88', '80')
     c+  group by LBBSTENR )
     c+  where exists
     c+ (SELECT decimal(sum(LBBSLAGB), 13, 2) FROM lbbs WHERE
     c+  artnr = LBBSTENR and LBBSFIRM = '01' and
     c+  LBBSSPKZ='J' and  LBBSSPGR in('88', '80')
     c+  group by LBBSTENR )
     c/end-exec

     C*letztes Vk-datum übergeben
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set     Lvk    =
     c+ (select max(LBLBBDAT) from lblb WHERE
     c+  LBLBFIRM ='01' and LBLBLSTC in ('130')
     c+  and artnr = LBLBTENR
     c+  group by LBLBTENR )
     c+  where exists
     c+ (select max(LBLBBDAT) from lblb WHERE
     c+  LBLBFIRM ='01' and LBLBLSTC in ('130')
     c+  and artnr = LBLBTENR
     c+  group by LBLBTENR )
     c/end-exec

     C*Produktionsmengen des Hauptartikels
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set     OPPROD =
     c+ (select sum(UKPPMG)-sum(UKRMMG) from pauk01 WHERE
     c+  UKFIRM='01' and UKPPAT in ('100', '200','300','400')
     c+  and UKPPS3 in ('04', '50') and (UKPPMG > UKRMMG)
     c+  and artnr = uktenr  group by uktenr)
     c+  where exists
     c+ (select sum(UKPPMG)-sum(UKRMMG) from pauk01 WHERE
     c+  UKFIRM='01' and UKPPAT in ('100', '200','300','400')
     c+  and UKPPS3 in ('04', '50') and (UKPPMG > UKRMMG)
     c+  and artnr = uktenr  group by uktenr)
     c/end-exec

     C*Produktionsmengen des Nebenartikels aus Stückliste
     c/exec sql
     c+ insert into tvrelwaeco/DBOPPRODST
     c+ SELECT ITTENR, dec(sum(UKPPMG)-sum(UKRMMG), 13, 0) prodstk,
     c+ count(*) FROM DIST01,pauk01 WHERE UKFIRM='01' and iTFIRM='01' and
     c+ ITLANR='300' and ITBPOS<>0 and UKPPAT in ('100', '200','300','400')
     c+ and UKPPS3 in ('04', '50') and (UKPPMG > UKRMMG) and itbgjj=UKPPJJ
     c+ and ITBGNR=UKPPNR GROUP BY ittenr
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ set  OPPRODst=
     c+ (select PRODSTK from DBOPPRODST WHERE
     c+  artnr=ITTENR)
     c+  where exists
     c+ (select PRODSTK from DBOPPRODST WHERE
     c+  artnr=ITTENR)
     c/end-exec


     C     ##8000        ENDSR

     C**************************************************************************
     C*Handhabung der replacements
     C*-------------------------------------------------------------------------
     C*
     C     sr8500        BEGSR
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

     C* Alle abhängigen Replacements (fehlerfrei ohne Doppelkombination)
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP1
     c+ SELECT ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ bar_kalk/kalk_file WHERE e1 <> ' ' and version = '$$EL_PS_DB' and
     c+ (artnr<>e1 and artnr<>e2 and artnr<>e3 and artnr<>e4 and artnr<>e5
     c+ and artnr<>e6 and artnr<>e7 and artnr<>e8 and artnr<>e9)
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e1<>' ' and (e1=e2 or e1=e3 or e1=e4 or e1=e5 or e1=e6 or
     c+                e1=e7 or e1=e8 or e1=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e2<>' ' and (e2=e3 or e2=e4 or e2=e5 or e2=e6 or e1=e6 or
     c+                e2=e7 or e2=e8 or e2=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e3<>' ' and (e3=e4 or e3=e5 or e3=e6 or e3=e7 or e3=e8 or e3=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e4<>' ' and (e4=e5 or e4=e6 or e4=e7 or e4=e8 or e4=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e5<>' ' and (e5=e6 or e5=e7 or e5=e8 or e5=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e6<>' ' and (e6=e7 or e6=e8 or e6=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e7<>' ' and (e7=e8 or e7=e9))
     c/end-exec

     C* Bereinigung
     c/exec sql
     c+ DELETE   from db_optrep1 where
     c+ ( e8<>' ' and (e8=e9))
     c/end-exec

     C* Hauptartikel e9
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E9 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e9<>' '
     c/end-exec

     C* Hauptartikel e8
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E8 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e8<>' ' and e9=' '
     c/end-exec

     C* Hauptartikel e7
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E7 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e7<>' ' and e9=' ' and e8=' '
     c/end-exec

     C* Hauptartikel e6
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E6 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e6<>' ' and e9=' ' and e8=' ' and e7=' '
     c/end-exec

     C* Hauptartikel e5
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E5 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e5<>' ' and e9=' ' and e8=' ' and e7=' '
     c+                          and e6=' '
     c/end-exec

     C* Hauptartikel e4
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E4 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e4<>' ' and e9=' ' and e8=' ' and e7=' '
     c+                          and e6=' ' and e5=' '
     c/end-exec

     C* Hauptartikel e3
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E3 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e3<>' ' and e9=' ' and e8=' ' and e7=' '
     c+                          and e6=' ' and e5=' ' and e4=' '
     c/end-exec

     C* Hauptartikel e2
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E2 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e2<>' ' and e9=' ' and e8=' ' and e7=' '
     c+                          and e6=' ' and e5=' ' and e4=' '
     c+                          and e3=' '
     c/end-exec

     C* Hauptartikel e1
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP2
     c+ SELECT E1 item, ARTNR, E1, E2, E3, E4, E5, E6, E7, E8, E9 FROM
     c+ DB_OPTREP1 WHERE e1<>' ' and e9=' ' and e8=' ' and e7=' '
     c+                          and e6=' ' and e5=' ' and e4=' '
     c+                          and e3=' ' and e2=' '
     c/end-exec

     C* Hauptartikel im Hauptverzeichnis schreiben
     c/exec sql
     c+ update tvrelwaeco/DB_OPT_JQ a set mainitem   =
     c+ (SELECT item FROM DB_OPTREP2 where a.artnr = item group by item)
     c+ where exists
     c+ (SELECT item FROM DB_OPTREP2 where a.artnr = item group by item)
     c/end-exec

     C* alle in Frage kommenden Artikel filtern für update
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTREP3
     c+ SELECT * FROM tvrelwaeco/DB_OPT_JQ WHERE
     c+ artnr in (select e1 from DB_OPTREP2) or
     c+ artnr in (select e2 from DB_OPTREP2) or
     c+ artnr in (select e3 from DB_OPTREP2) or
     c+ artnr in (select e4 from DB_OPTREP2) or
     c+ artnr in (select e5 from DB_OPTREP2) or
     c+ artnr in (select e6 from DB_OPTREP2) or
     c+ artnr in (select e7 from DB_OPTREP2) or
     c+ artnr in (select e8 from DB_OPTREP2) or
     c+ artnr in (select e9 from DB_OPTREP2) or
     c+ artnr in (select artnr from DB_OPTREP2)
     c******************+ artnr in (select item from DB_OPTREP2)
     c/end-exec

     C* Key
     c/exec sql
     c+ create index tvrelwaeco/db_optrepl on tvrelwaeco/db_optrep2
     c+ (ITEM, E1, E2, E3, E4, E5, E6, E7, E8, E9)
     c/end-exec

     C* Key
     c/exec sql
     c+ create index tvrelwaeco/db_opt_jql on tvrelwaeco/DB_opt_jq
     c+ (LEVEL, ARTNR)
     c/end-exec

     c     keysr         klist
     c                   kfld                    LEVEL
     c                   kfld                    ARTNR

     C                   open      DB_OPTREPL
     C                   open      db_opt_jql
     C                   DO        *HIVAL
     C
     C                   READ      DB_OPTREPL                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   z-add     0             leave             2 0
     C                   movel     'level     '  level
     C                   movel     §artnr        ARTNR
     c     keysr         chain     db_opt_jql                         96
     C
     c******             if        *in96 ='0'
     C                   DO        *HIVAL
     c                   exsr      srcum
     c     keysr         chain     db_opt_jql                         96
     c                   if        artnr = ' '
     c                   leave
     c                   endif
     c                   enddo
     C                   movel     'level     '  level
     C                   movel     §item         ARTNR
     c     keysr         chain     db_opt_jql                         96
     c                   movel     'mainitem'    level
     c                   move      leave         level
     c                   exsr      sr_ueb
     C                   z-add     0             leave             2 0
     C* hauptartikel muss da sein wäre der letzte in der Kette
     C                   movel     §item         ARTNR
     c                   write     phy01r
     c****               endif
     C
     c                   endif
     C                   enddo
     C                   if        leave  <> 0
     C                   movel     'level     '  level
     C                   movel     §item         ARTNR
     c     keysr         chain     db_opt_jql                         96
     c                   movel     'mainitem'    level
     c                   move      leave         level
     c                   exsr      sr_ueb
     C                   movel     §item         ARTNR
     c                   write     phy01r
     C                   endif
     C
     C                   close     db_opt_jql
     C                   close     DB_OPTREPL
     C
     C     ##8500        ENDSR

     C**************************************************************************
     C* srcum : additionen
     C*-------------------------------------------------------------------------
     C*
     C     srcum         BEGSR
     C*
     c  n96              eval      #b005      =  b005       +  #b005
     c  n96              eval      #a001      =  a001       +  #a001
     c  n96              eval      #sib       =  sib        +  #sib
     c  n96              eval      #KCJMNG_VJ =  KCJMNG_VJ  +  #KCJMNG_VJ
     c  n96              eval      #KCJMNG_aJ =  KCJMNG_aJ  +  #KCJMNG_aJ
     c  n96              eval      #PURCHA    =  PURCHA     +  #PURCHA
     c  n96              eval      #TRANSIT   =  TRANSIT    +  #TRANSIT
     c  n96              eval      #BLOCKED   =  BLOCKED    +  #BLOCKED
     c  n96              eval      #MVV1      =  MVV1       +  #MVV1
     c  n96              eval      #MVV2      =  MVV2       +  #MVV2
     c  n96              eval      #MVV3      =  MVV3       +  #MVV3
     c  n96              eval      #MVV4      =  MVV4       +  #MVV4
     c  n96              eval      #MVV5      =  MVV5       +  #MVV5
     c  n96              eval      #MVV6      =  MVV6       +  #MVV6
     c  n96              eval      #MVV7      =  MVV7       +  #MVV7
     c  n96              eval      #MVV8      =  MVV8       +  #MVV8
     c  n96              eval      #MVV9      =  MVV9       +  #MVV9
     c  n96              eval      #MVV10     =  MVV10      +  #MVV10
     c  n96              eval      #MVV11     =  MVV11      +  #MVV11
     c  n96              eval      #MVV12     =  MVV12      +  #MVV12
     c  n96              eval      #MV1       =  MV1        +  #MV1
     c  n96              eval      #MV2       =  MV2        +  #MV2
     c  n96              eval      #MV3       =  MV3        +  #MV3
     c  n96              eval      #MV4       =  MV4        +  #MV4
     c  n96              eval      #MV5       =  MV5        +  #MV5
     c  n96              eval      #MV6       =  MV6        +  #MV6
     c  n96              eval      #MV7       =  MV7        +  #MV7
     c  n96              eval      #MV8       =  MV8        +  #MV8
     c  n96              eval      #MV9       =  MV9        +  #MV9
     c  n96              eval      #MV10      =  MV10       +  #MV10
     c  n96              eval      #MV11      =  MV11       +  #MV11
     c  n96              eval      #MV12      =  MV12       +  #MV12
     c  n96              eval      #MP1       =  MP1        +  #MP1
     c  n96              eval      #MP2       =  MP2        +  #MP2
     c  n96              eval      #MP3       =  MP3        +  #MP3
     c  n96              eval      #MP4       =  MP4        +  #MP4
     c  n96              eval      #MP5       =  MP5        +  #MP5
     c  n96              eval      #MP6       =  MP6        +  #MP6
     c  n96              eval      #MP7       =  MP7        +  #MP7
     c  n96              eval      #MP8       =  MP8        +  #MP8
     c  n96              eval      #MP9       =  MP9        +  #MP9
     c  n96              eval      #MP10      =  MP10       +  #MP10
     c  n96              eval      #MP11      =  MP11       +  #MP11
     c  n96              eval      #MP12      =  MP12       +  #MP12
     c  n96              eval      #MC1       =  MC1        +  #MC1
     c  n96              eval      #MC2       =  MC2        +  #MC2
     c  n96              eval      #MC3       =  MC3        +  #MC3
     c  n96              eval      #MC4       =  MC4        +  #MC4
     c  n96              eval      #MC5       =  MC5        +  #MC5
     c  n96              eval      #MC6       =  MC6        +  #MC6
     c  n96              eval      #MC7       =  MC7        +  #MC7
     c  n96              eval      #MC8       =  MC8        +  #MC8
     c  n96              eval      #MC9       =  MC9        +  #MC9
     c  n96              eval      #MC10      =  MC10       +  #MC10
     c  n96              eval      #MC11      =  MC11       +  #MC11
     c  n96              eval      #MC12      =  MC12       +  #MC12
     c  n96              eval      #TAPJ      =  TAPJ       +  #TAPJ
     c  n96              eval      #TACJ      =  TACJ       +  #TACJ
     c  n96              eval      #A825PJ    =  A825PJ     +  #A825PJ
     c  n96              eval      #TA825PJ   =  TA825PJ    +  #TA825PJ
     c  n96              eval      #OPENORD   =  OPENORD    +  #OPENORD
     c  n96              eval      #BACKORD   =  BACKORD    +  #BACKORD
     c  n96              eval      #OPENORDp  =  OPENORDp   +  #OPENORDp
     c  n96              eval      #BACKORDp  =  BACKORDp   +  #BACKORDp
     c  n96              eval      #RESERVQTY =  RESERVQTY  +  #RESERVQTY
     c  n96              eval      #OPPROD    =  OPPROD     +  #OPPROD
     c  n96              eval      #OPPRODST  =  OPPRODST   +  #OPPRODST
     c                   eval      leave = leave + 1
     C                   clear                   ARTNR
     c                   if        leave= 1
     C                   movel     'level    '   level
     C                   movel     §E1           ARTNR
     c                   endif
     c                   if        leave= 2
     C                   movel     'level    '   level
     C                   movel     §E2           ARTNR
     c                   endif
     c                   if        leave= 3
     C                   movel     'level    '   level
     C                   movel     §E3           ARTNR
     c                   endif
     c                   if        leave= 4
     C                   movel     'level    '   level
     C                   movel     §E4           ARTNR
     c                   endif
     c                   if        leave= 5
     C                   movel     'level    '   level
     C                   movel     §E5           ARTNR
     c                   endif
     c                   if        leave= 6
     C                   movel     'level    '   level
     C                   movel     §E6           ARTNR
     c                   endif
     c                   if        leave= 7
     C                   movel     'level    '   level
     C                   movel     §E7           ARTNR
     c                   endif
     c                   if        leave= 8
     C                   movel     'level    '   level
     C                   movel     §E8           ARTNR
     c                   endif
     c                   if        leave= 9
     C                   movel     'level    '   level
     C                   movel     §E9           ARTNR
     c                   endif
     C*
     C     ##srcum       ENDSR
     C*
     C**************************************************************************
     C* srcum : additionen
     C*-------------------------------------------------------------------------
     C*
     C     sr_ueb        BEGSR
     C*
     c                   eval      b005       =                #b005
     c                   eval      a001       =                #a001
     c                   eval      sib        =                #sib
     c                   eval      KCJMNG_VJ  =                #KCJMNG_VJ
     c                   eval      KCJMNG_aJ  =                #KCJMNG_aJ
     c                   eval      PURCHA     =                #PURCHA
     c                   eval      TRANSIT    =                #TRANSIT
     c                   eval      BLOCKED    =                #BLOCKED
     c                   eval      MVV1       =                #MVV1
     c                   eval      MVV2       =                #MVV2
     c                   eval      MVV3       =                #MVV3
     c                   eval      MVV4       =                #MVV4
     c                   eval      MVV5       =                #MVV5
     c                   eval      MVV6       =                #MVV6
     c                   eval      MVV7       =                #MVV7
     c                   eval      MVV8       =                #MVV8
     c                   eval      MVV9       =                #MVV9
     c                   eval      MVV10      =                #MVV10
     c                   eval      MVV11      =                #MVV11
     c                   eval      MVV12      =                #MVV12
     c                   eval      MV1        =                #MV1
     c                   eval      MV2        =                #MV2
     c                   eval      MV3        =                #MV3
     c                   eval      MV4        =                #MV4
     c                   eval      MV5        =                #MV5
     c                   eval      MV6        =                #MV6
     c                   eval      MV7        =                #MV7
     c                   eval      MV8        =                #MV8
     c                   eval      MV9        =                #MV9
     c                   eval      MV10       =                #MV10
     c                   eval      MV11       =                #MV11
     c                   eval      MV12       =                #MV12
     c                   eval      MP1        =                #MP1
     c                   eval      MP2        =                #MP2
     c                   eval      MP3        =                #MP3
     c                   eval      MP4        =                #MP4
     c                   eval      MP5        =                #MP5
     c                   eval      MP6        =                #MP6
     c                   eval      MP7        =                #MP7
     c                   eval      MP8        =                #MP8
     c                   eval      MP9        =                #MP9
     c                   eval      MP10       =                #MP10
     c                   eval      MP11       =                #MP11
     c                   eval      MP12       =                #MP12
     c                   eval      MC1        =                #MC1
     c                   eval      MC2        =                #MC2
     c                   eval      MC3        =                #MC3
     c                   eval      MC4        =                #MC4
     c                   eval      MC5        =                #MC5
     c                   eval      MC6        =                #MC6
     c                   eval      MC7        =                #MC7
     c                   eval      MC8        =                #MC8
     c                   eval      MC9        =                #MC9
     c                   eval      MC10       =                #MC10
     c                   eval      MC11       =                #MC11
     c                   eval      MC12       =                #MC12
     c                   eval      TAPJ       =                #TAPJ
     c                   eval      TACJ       =                #TACJ
     c                   eval      A825PJ     =                #A825PJ
     c                   eval      TA825PJ    =                #TA825PJ
     c                   eval      OPENORD    =                #OPENORD
     c                   eval      BACKORD    =                #BACKORD
     c                   eval      OPENORDp   =                #OPENORDp
     c                   eval      BACKORDp   =                #BACKORDp
     c                   eval      lvk        =                #lvk
     c                   eval      lbew       =                #lbew
     c                   eval      RESERVQTY  =                #RESERVQTY
     c                   eval      OPPROD     =                #OPPROD
     c                   eval      OPPRODST   =                #OPPRODST
     C*
     c                   clear                   #b005
     c                   clear                   #a001
     c                   clear                   #sib
     c                   clear                   #KCJMNG_VJ
     c                   clear                   #KCJMNG_aJ
     c                   clear                   #PURCHA
     c                   clear                   #TRANSIT
     c                   clear                   #BLOCKED
     c                   clear                   #MVV1
     c                   clear                   #MVV2
     c                   clear                   #MVV3
     c                   clear                   #MVV4
     c                   clear                   #MVV5
     c                   clear                   #MVV6
     c                   clear                   #MVV7
     c                   clear                   #MVV8
     c                   clear                   #MVV9
     c                   clear                   #MVV10
     c                   clear                   #MVV11
     c                   clear                   #MVV12
     c                   clear                   #MV1
     c                   clear                   #MV2
     c                   clear                   #MV3
     c                   clear                   #MV4
     c                   clear                   #MV5
     c                   clear                   #MV6
     c                   clear                   #MV7
     c                   clear                   #MV8
     c                   clear                   #MV9
     c                   clear                   #MV10
     c                   clear                   #MV11
     c                   clear                   #MV12
     c                   clear                   #MP1
     c                   clear                   #MP2
     c                   clear                   #MP3
     c                   clear                   #MP4
     c                   clear                   #MP5
     c                   clear                   #MP6
     c                   clear                   #MP7
     c                   clear                   #MP8
     c                   clear                   #MP9
     c                   clear                   #MP10
     c                   clear                   #MP11
     c                   clear                   #MP12
     c                   clear                   #MC1
     c                   clear                   #MC2
     c                   clear                   #MC3
     c                   clear                   #MC4
     c                   clear                   #MC5
     c                   clear                   #MC6
     c                   clear                   #MC7
     c                   clear                   #MC8
     c                   clear                   #MC9
     c                   clear                   #MC10
     c                   clear                   #MC11
     c                   clear                   #MC12
     c                   clear                   #TAPJ
     c                   clear                   #TACJ
     c                   clear                   #A825PJ
     c                   clear                   #TA825PJ
     c                   clear                   #OPENORD
     c                   clear                   #BACKORD
     c                   clear                   #OPENORDp
     c                   clear                   #BACKORDp
     c                   clear                   #lvk
     c                   clear                   #lbew
     c                   clear                   #RESERVQTY
     c                   clear                   #OPPROD
     c                   clear                   #OPPRODST
     C*
     C     ##srueb       ENDSR
     C*
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
     C     *LIKE         DEFINE    b005          #b005
     C     *LIKE         DEFINE    a001          #a001
     C     *LIKE         DEFINE    sib           #sib
     C     *LIKE         DEFINE    KCJMNG_VJ     #KCJMNG_VJ
     C     *LIKE         DEFINE    KCJMNG_aJ     #KCJMNG_aJ
     C     *LIKE         DEFINE    PURCHA        #PURCHA
     C     *LIKE         DEFINE    TRANSIT       #TRANSIT
     C     *LIKE         DEFINE    BLOCKED       #BLOCKED
     C     *LIKE         DEFINE    MVV1          #MVV1
     C     *LIKE         DEFINE    MVV2          #MVV2
     C     *LIKE         DEFINE    MVV3          #MVV3
     C     *LIKE         DEFINE    MVV4          #MVV4
     C     *LIKE         DEFINE    MVV5          #MVV5
     C     *LIKE         DEFINE    MVV6          #MVV6
     C     *LIKE         DEFINE    MVV7          #MVV7
     C     *LIKE         DEFINE    MVV8          #MVV8
     C     *LIKE         DEFINE    MVV9          #MVV9
     C     *LIKE         DEFINE    MVV10         #MVV10
     C     *LIKE         DEFINE    MVV11         #MVV11
     C     *LIKE         DEFINE    MVV12         #MVV12
     C     *LIKE         DEFINE    MV1           #MV1
     C     *LIKE         DEFINE    MV2           #MV2
     C     *LIKE         DEFINE    MV3           #MV3
     C     *LIKE         DEFINE    MV4           #MV4
     C     *LIKE         DEFINE    MV5           #MV5
     C     *LIKE         DEFINE    MV6           #MV6
     C     *LIKE         DEFINE    MV7           #MV7
     C     *LIKE         DEFINE    MV8           #MV8
     C     *LIKE         DEFINE    MV9           #MV9
     C     *LIKE         DEFINE    MV10          #MV10
     C     *LIKE         DEFINE    MV11          #MV11
     C     *LIKE         DEFINE    MV12          #MV12
     C     *LIKE         DEFINE    MP1           #MP1
     C     *LIKE         DEFINE    MP2           #MP2
     C     *LIKE         DEFINE    MP3           #MP3
     C     *LIKE         DEFINE    MP4           #MP4
     C     *LIKE         DEFINE    MP5           #MP5
     C     *LIKE         DEFINE    MP6           #MP6
     C     *LIKE         DEFINE    MP7           #MP7
     C     *LIKE         DEFINE    MP8           #MP8
     C     *LIKE         DEFINE    MP9           #MP9
     C     *LIKE         DEFINE    MP10          #MP10
     C     *LIKE         DEFINE    MP11          #MP11
     C     *LIKE         DEFINE    MP12          #MP12
     C     *LIKE         DEFINE    MC1           #MC1
     C     *LIKE         DEFINE    MC2           #MC2
     C     *LIKE         DEFINE    MC3           #MC3
     C     *LIKE         DEFINE    MC4           #MC4
     C     *LIKE         DEFINE    MC5           #MC5
     C     *LIKE         DEFINE    MC6           #MC6
     C     *LIKE         DEFINE    MC7           #MC7
     C     *LIKE         DEFINE    MC8           #MC8
     C     *LIKE         DEFINE    MC9           #MC9
     C     *LIKE         DEFINE    MC10          #MC10
     C     *LIKE         DEFINE    MC11          #MC11
     C     *LIKE         DEFINE    MC12          #MC12
     C     *LIKE         DEFINE    TAPJ          #TAPJ
     C     *LIKE         DEFINE    TACJ          #TACJ
     C     *LIKE         DEFINE    A825PJ        #A825PJ
     C     *LIKE         DEFINE    TA825PJ       #TA825PJ
     C     *LIKE         DEFINE    OPENORD       #OPENORD
     C     *LIKE         DEFINE    BACKORD       #BACKORD
     C     *LIKE         DEFINE    OPENORDp      #OPENORDp
     C     *LIKE         DEFINE    BACKORDp      #BACKORDp
     C     *LIKE         DEFINE    lvk           #lvk
     C     *LIKE         DEFINE    lbew          #lbew
     C     *LIKE         DEFINE    RESERVQTY     #RESERVQTY
     C     *LIKE         DEFINE    OPPROD        #OPPROD
     C     *LIKE         DEFINE    OPPRODST      #OPPRODST
     C
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
