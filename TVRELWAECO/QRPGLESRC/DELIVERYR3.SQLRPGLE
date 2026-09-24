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
      * Orderdat:  Bestelldatum
      * Entrydat:
      * INPUTDAT:  Eingang der Order
      * Delivdat:  Auslieferungsdatum
      * CUSTOMDAT: Position, Kundenwunsch
      * Delivdatp: Lieferdatum aus Position nach Eingang der Auftragsposition
      * Billdat:   Rechnungsdatum
      * Pickdat:   Kommisionierungsdatum
      *
      *  exsr      sr6666   *on
      * SELECT ASSPED, ALREDA, ALTENR, ALTBZ1, dec(sum(AVGWBR), 13, 2)
      * bruttogew, dec(sum(Alglmg), 13, 2) quantity, dec(count(*), 13, 2)
      * rate FROM db_sped_sc GROUP BY ASSPED, ALREDA, ALTENR,ALTBZ1
      * Datei MEIER in TVRELWAECO wurde ersetzt.
      *
      *
      *
      *
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

     C*data base three
     c***                exsr      sr6000
     c***                exsr      sr6500
     C*packages
     c                   exsr      sr6600
     c***                exsr      sr6666

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

     c*****/exec sql
     c*****+ insert into tvrelwaeco/#DP0060inv
     c*****+ SELECT * FROM afko b, afpo a, statistik c where
     c*****+ b.AKFIRM=a.apFIRM and b.AKAFJJ=a.apAFJJ and b.AKAFNN=a.apAFNN  and
     c*****+ c.apFIRM=a.apFIRM and c.apAFJJ=a.apAFJJ and c.apAFNN=a.apAFNN  and
     c*****+ c.APAFPO=a.APAFPO                                              and
     c*****+ b.akfirm in ('01', '51') and a.apfirm in ('01', '51') and
     c*+  date(substr(char(c.RKREDA), 1, 4) concat '-'
     c*+ concat substr(char(c.RKREDA), 5, 2) concat '-'
     c*+ concat substr(char(c.RKREDA), 7, 2) ) > current date -031 days
     c*****+  substr(char(rkreda), 1, 4)=char(year(current date -0 year))
     c*****/end-exec
     C*
     C*
     c*****/exec sql
     c*****+ update #DP0060inv set apkwte = aplfte WHERE apkwte = 0
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update   #DP0060inv  set apkoda = '19990101' where apkoda = 0
     c*****/end-exec

     C*
     c*****/exec sql
     c*****+ insert into tvrelwaeco/DB_INV_PER
     c*****+ SELECT AKAFJJ,AKAFNR,AKKDNR,kdNAM1 amnam1,kdPOLZ ampolz,
     c*****+        kdPOLD ampold,
     c*****+ date(substr(char(akafda), 1, 4) concat '-' concat
     c*****+      substr(char(akafda), 5, 2) concat '-' concat
     c*****+      substr(char(akafda), 7, 2)  ) inputdat,
     c*****+ date(substr(char(apafda), 1, 4) concat '-' concat
     c*****+      substr(char(apafda), 5, 2) concat '-' concat
     c*****+      substr(char(apafda), 7, 2)  ) inputdatp,
     c*****+ AKLIAR,AKPRIO,kdPOLZ  AMPOLZ01,kdPOLD AMPOLD01,
     c*****+ APAFST status, AKAFAT,char(' ', 50) Notes, apAFPO ALAFPO01,
     c*****+ aptenr ALTENR01,                 ABC,APBSMG, ARTGRP, statnr,
     c*****+ date(substr(char(APKWTE), 1, 4) concat '-' concat
     c*****+      substr(char(APKWTE), 5, 2) concat '-' concat
     c*****+      substr(char(APKWTE), 7, 2)  ) customdat,
     c*****+ date(substr(char(APLFTE), 1, 4) concat '-' concat
     c*****+      substr(char(APLFTE), 5, 2) concat '-' concat
     c*****+      substr(char(APLFTE), 7, 2)  ) delivdatp,
     c*****+ zoned( 0, 8) WAO8LFTE,char(' ', 1) FIXEDFLAG,
     c*****+ date(substr(char(apkoda), 1, 4) concat '-' concat
     c*****+      substr(char(apkoda), 5, 2) concat '-' concat
     c*****+      substr(char(apkoda), 7, 2)  ) PICKDAT2,
     c*****+                           AKKOSP PICKBLOCK,
     c*****+                      AKKOSP HOLDS, char(' ', 10) NEXTSUPPLY,
     c*****+ zoned( 0, 8) supplydate, rpLIJJ ALLIJJ01, rpLINR ALLINR01,
     c*****+ rpLIPO  ALLIPO01,current date  DELIVDAT,current date
     c*****+ DELIVDAT01,APGLMG,char(' ', 10) ASSPED,
     c*****+ zoned( 0, 8) PICKUP , zoned( 0, 9, 4) AVGWBR,char(' ', 20) AVPAKN,
     c*****+ char(' ', 15) AVTENR, char(' ', 20) AVDPDN,             RKRGJJ ,
     c*****+              RKRGNR,
     c*****+ date(substr(char(rkreda), 1, 4) concat '-' concat
     c*****+      substr(char(rkreda), 5, 2) concat '-' concat
     c*****+      substr(char(rkreda), 7, 2)  ) billdat,
     c*****+                                                       APGLMG01,
     c*****+ decimal( 0, 12, 4) STK_LCP,decimal( 0, 12, 2) salevalue,
     c*****+ decimal( 0, 15, 0) week,
     c*****+ AKAFST statush,aksabe staff, KDKDGR, KDNIGB ,KDKSTC,
     c*****+ APRSDA rsvdate,
     c*****+ char(' ', 10) adKDNR,char(' ', 30) ADNAM1,char(' ', 10) ADPOLZ,
     c*****+ char(' ', 03) ADPOLD, LIEFERANT1,char(' ', 30) supplname,
     c*****+ ULAND,#TESAAV,#TEDIAV,#TEVOZ1,ARTZ1,
     c*****+ current timestamp tstamp, apTBZ1 ALTBZ101
     c*****+ FROM tvrelwaeco/#DP0060inv, kund01,bar_kalk/kalk_file
     c*****+ WHERE #DP0060inv.AKKDNR=KUND01.KDKDNR and #DP0060inv.APTENR= artnr
     c*****+ and version = '$$EL_PS_DB' and kdfirm in ('01', '51')
     c*****/end-exec

     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    PICKDAT2 =
     c*****+ (select  max(date(substr(char(askmda), 1, 4) concat '-' concat
     c*****+      substr(char(askmda), 5, 2) concat '-' concat
     c*****+      substr(char(askmda), 7, 2))) from #DP0050  where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and askmda <>0  group by askmda)
     c*****+  where exists
     c*****+ (select  max(date(substr(char(askmda), 1, 4) concat '-' concat
     c*****+      substr(char(askmda), 5, 2) concat '-' concat
     c*****+      substr(char(askmda), 7, 2))) from #DP0050  where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and askmda <>0  group by askmda)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    delivdat =
     c*****+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c*****+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c*****+      substr(char(ALLSDA), 7, 2))) from #DP0050  where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and askmda <>0  and ALLSDA <>0 group by askmda)
     c*****+  where exists
     c*****+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c*****+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c*****+      substr(char(ALLSDA), 7, 2))) from #DP0050  where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and askmda <>0  and ALLSDA <>0 group by askmda)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    delivdat =
     c*****+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c*****+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c*****+      substr(char(ALLSDA), 7, 2))) from aflp     where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and ALFIRM in ('01','51') and ALLSDA <>0 group by ALLSDA)
     c*****+  where exists
     c*****+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c*****+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c*****+      substr(char(ALLSDA), 7, 2))) from aflp     where
     c*****+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+  and ALFIRM in ('01','51') and ALLSDA <>0 group by ALLSDA)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set SUPPLNAME  =
     c*****+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR
     c*****+ and lffirm in ('01','51'))
     c*****+  where exists
     c*****+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR
     c*****+ and lffirm in ('01','51'))
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set    adKDNR=
     c*****+ (select adKDNR from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****+ where exists
     c*****+ (select adKDNR from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set    adnam1=
     c*****+ (select adnam1 from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****+ where exists
     c*****+ (select adKDNR from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set    adpolz=
     c*****+ (select adpolz from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****+ where exists
     c*****+ (select adKDNR from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set    adpold=
     c*****+ (select adpold from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****+ where exists
     c*****+ (select adKDNR from afad
     c*****+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS'
     c*****+  and adfirm in ('01','51'))
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    ASSPED=
     c*****+ (select  max(ASSPED) from #DP0050  where
     c*****+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by assped)
     c*****+  where exists
     c*****+ (select  max(ASSPED) from #DP0050  where
     c*****+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by assped)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    avpakn=
     c*****+ (select  max(avpakn) from #DP0050  where
     c*****+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by avpakn)
     c*****+  where exists
     c*****+ (select  max(avpakn) from #DP0050  where
     c*****+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by avpakn)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    AVDPDN=
     c*****+ (select  max(AVDPDN) from #DP0050  where
     c*****+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVDPDN)
     c*****+  where exists
     c*****+ (select  max(AVDPDN) from #DP0050  where
     c*****+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVDPDN)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    AVGWBR=
     c*****+ (select  max(AVGWBR) from #DP0050  where
     c*****+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVGWBR)
     c*****+  where exists
     c*****+ (select  max(AVGWBR) from #DP0050  where
     c*****+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVGWBR)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER a set    AVTENR=
     c*****+ (select  max(AVTENR) from #DP0050  where
     c*****+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVTENR)
     c*****+  where exists
     c*****+ (select  max(AVTENR) from #DP0050  where
     c*****+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c*****+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c*****+   and askmda <>0  group by AVTENR)
     c*****/end-exec
     C*
     c*****/exec sql
     c*****+ update tvrelwaeco/DB_INV_PER set    STK_LCP =
     c*****+ (select STK_LCP  from bar_kalk/kalk_file where artnr=ALTENR01
     c*****+   and   version = '$$EL_PS_DB')
     c*****+ where exists
     c*****+ (select STK_LCP  from bar_kalk/kalk_file where artnr=ALTENR01
     c*****+   and   version = '$$EL_PS_DB')
     c*****/end-exec
     C*

     C     ##6000        ENDSR

     C**************************************************************************
     C*...
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
     c*/exec sql
     c*+ update tvrelwaeco/DB_INV_PER set WAO8LFTE =
     c*+ (select WAO8LFTE from #wao8        where AKAFNR= WAO8AFNR and
     c*+      AKAFJJ=WAO8AFJJ and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c*+ where exists
     c*+ (select WAO8LFTE from #wao8        where AKAFNR= WAO8AFNR and
     c*+      AKAFJJ=WAO8AFJJ and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c*/end-exec
     C*
     c*/exec sql
     c*+ update tvrelwaeco/DB_INV_PER set FIXEDFLAG= 'J' where
     c*+         WAO8LFTE <> 0
     c*/end-exec
     c*
     c*/exec sql
     c*+ update DB_INV_PER set week = dec(year(inputdat) concat
     c*+ week(inputdat))
     c*/end-exec
     c*

     C     ##6500        ENDSR


     C**************************************************************************
     C*beispiel 5 days
     C*SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     C*       AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     C*       AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     C*       concat char(AlAFNR) concat '/' concat
     C*       char(digits(AlAFPO)), 20)
     C*FROM tvrelwaeco/#dp0050
     C*WHERE askmda <> 0 and ((
     C*date(substr(char(askmda), 1, 4) concat '-' concat
     C*substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     C*7, 2) ) = current date - 5 day ) or ( ALLSDA<>ALREDA and
     C*              alreda <> 0 and                              (
     C*date(substr(char(ALREDA), 1, 4) concat '-' concat
     C*substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     C*7, 2) ) = current date - 5 day ))) and substr(amKDNR, 1, 6) in
     C*(select SALES# from SALESCOMP)
     C*-------------------------------------------------------------------------
     C*
     C     sr6600        BEGSR
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
      * Achtung: Lieferschein und Rechnungsdatum können gleich sein
      * ab 22.02.2013
     c*+ 7, 2) ) = current date - 1 day ) or ( ALLSDA<>ALREDA and
     c/exec sql
     c+ insert into tvrelwaeco/DB_SPED
     c+ SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     c+        AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     c+        AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     c+        concat char(AlAFNR) concat '/' concat
     c+        char(digits(AlAFPO)), 20), AVFIRM, AVKMJJ, AVKMNR, AVKMPO,
     c+        ALKMPO
     c+ FROM tvrelwaeco/#dp0050
     c+ WHERE askmda <> 0 and ((
     c+ date(substr(char(askmda), 1, 4) concat '-' concat
     c+ substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     c+ 7, 2) ) = current date - 001 day ) or (
     c+               alreda <> 0 and                              (
     c+ date(substr(char(ALREDA), 1, 4) concat '-' concat
     c+ substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     c+ 7, 2) ) = current date - 001 day ))) and substr(amKDNR, 1, 6) in
     c+ (select SALES# from SALESCOMP) and
     c+ substr(amKDNR, 1, 6) <> '055278'
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/DB_SPED
     c+ SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     c+        AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     c+        AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     c+        concat char(AlAFNR) concat '/' concat
     c+        char(digits(AlAFPO)), 20), AVFIRM, AVKMJJ, AVKMNR, AVKMPO,
     c+        ALKMPO
     c+ FROM tvrelwaeco/#dp0050
     c+ WHERE askmda <> 0 and ((
     c+ date(substr(char(askmda), 1, 4) concat '-' concat
     c+ substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     c+ 7, 2) ) = current date - 001 day )
     c+            or
     c+            (  alreda <> 0 and                              (
     c+ date(substr(char(ALREDA), 1, 4) concat '-' concat
     c+ substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     c+ 7, 2) ) = current date - 001 day )
     c+            or
     c+            (  AVJDAT <> 0 and                              (
     c+ date(substr(char(AVJDAT), 1, 4) concat '-' concat
     c+ substr(char(AVJDAT), 5, 2) concat '-' concat substr(char(AVJDAT),
     c+ 7, 2) ) = current date - 001 day ))
     c+                                 ))
     c+ and substr(amKDNR, 1, 6) in (select SALES# from SALESCOMP) and
     c+ substr(amKDNR, 1, 6) =  '055278'
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/db_sped_sc
     c+ SELECT DISTINCT * FROM db_sped
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/db_sped_sc  set almaaf =
     c+ (select substr(akref1, 1, 10)
     c+                from afko01 where  AMKDNR in
     c+                ('x08138', 'x05084', 'x42634')      and
     c+         DB_SPED_SC.ALAFJJ = AFKO01.AKAFJJ  and
     c+         DB_SPED_SC.ALAFNR = AFKO01.AkAFNR  and
     c+         AFKO01.Akfirm  = '01')
     c+ where exists
     c+ (select substr(akref1, 1, 10)
     c+                from afko01 where  AMKDNR in
     c+                ('x08138', 'x05084', 'x42634')      and
     c+         DB_SPED_SC.ALAFJJ = AFKO01.AKAFJJ  and
     c+         DB_SPED_SC.ALAFNR = AFKO01.AkAFNR  and
     c+         AFKO01.Akfirm  = '01')
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/B2BTRACKER
     c+ SELECT PKANR1,PKAPN, PKAPPO, PKIDEN, PKSTCK, PKEGEW,PKSGEW, PKPMEN,
     c+ PKTOUR ,PKKDNR,PKDTP,        PKANRP, PKANRU,
     c+ PKBENR, PKPALN,PKPALP, PKPKNR, PKVENR, char('PPAKET', 10) ort
     c+ FROM domdatv7/ppaket WHERE PKAPPO>0 and PKDTP > 20230115
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/B2BTRACKER
     c+ SELECT PKANR1, PKAPN, PKAPPO, PKIDEN, PKSTCK, PKEGEW, PKSGEW, PKPMEN,
     c+ PKTOUR ,PKKDNR,PKDTP,        PKANRP, PKANRU, PKBENR,
     c+ PKPALN,PKPALP, PKPKNR, PKVENR, char('PPAKET2', 10) ort
     c+ FROM DOMCOMV7/ppaket2 WHERE PKAPPO>0 and PKDTP > 20230115
     c/end-exec
     C*
     c/exec sql
     c+ insert into tvrelwaeco/B2BTRACKER
     c+ SELECT PKANR1, PKAPN, PKAPPO, PKIDEN, PKSTCK, PKEGEW, PKSGEW, PKPMEN,
     c+ PKTOUR, PKKDNR, PKDTP,         PKANRP, PKANRU, PKBENR,
     c+ PKPALN, PKPALP, PKPKNR, PKVENR, 'KONSOL    ' FROM B2BTRACKER GROUP BY
     c+        PKANR1, PKAPN, PKAPPO, PKIDEN, PKSTCK, PKEGEW, PKSGEW, PKPMEN,
     c+ PKTOUR, PKKDNR, PKDTP,         PKANRP, PKANRU, PKBENR, PKPALN,
     c+ PKPALP, PKPKNR, PKVENR
     c/end-exec
     C*             ohne pkvenr by tracker!
     c/exec sql
     c+ insert into tvrelwaeco/TRACKER
     c+ SELECT ALAFJJ,ALAFNR,ALAFPO,ALLIJJ,ALLINR,ALLIPO,ASSPED,
     c+ AVPAKN,AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,ALREDA,
     c+ AMKDNR,AMKDNR01,ALTENR,ALTBZ1,ALAFDA,SEL0021,AVFIRM,AVKMJJ
     c+ AVKMNR,AVKMPO,PKANR1,PKAPN,PKAPPO,PKIDEN,PKSTCK,PKEGEW,
     c+ PKSGEW,PKTOUR,PKKDNR,PKANRP,PKANRU,dec(sum(PKPMEN), 9, 2) output,
     c+ dec(sum(PKPMEN)-ALGLMG, 9, 2) deviation, dec(0,00, 4, 0) SC_pos,
     c+ char(' ', 1) status, current timestamp tstamp
     c+ FROM db_sped_sc ,b2btracker
     c+ WHERE AMKDNR=PKKDNR and PKANR1='K' concat avfirm concat
     c+ substr(char(avkmjj), 1, 4) concat substr(AVKMNR, 1, 6)
     c+ and ort='KONSOL  ' and PKANRP=ALKMPO
     c+ GROUP BY ALAFJJ,ALAFNR,ALAFPO,ALLIJJ,ALLINR,ALLIPO,ASSPED,
     c+ AVPAKN,AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,ALREDA,
     c+ AMKDNR,AMKDNR01,ALTENR,ALTBZ1,ALAFDA,SEL0021,AVFIRM,AVKMJJ,
     c+ AVKMNR,AVKMPO,PKANR1,PKAPN,PKAPPO,PKIDEN,PKSTCK,PKEGEW,
     c+ PKSGEW,PKTOUR,PKKDNR,PKANRP,PKANRU
     c/end-exec
     C*
     C*             Position Sc
     c/exec sql
     c+  update tracker set SC_pos =
     c+  (select IFAPIFPO from ifap01
     c+   where  ALAFJJ=IFApAFJJ and ALAFNR=IFApAFNR and
     c+          ALAFPO=IFAPAFPO and IFAPFIRM='01'
     c+          and status = ' ' )
     c+   where exists
     c+  (select IFAPIFPO from ifap01
     c+   where  ALAFJJ=IFApAFJJ and ALAFNR=IFApAFNR and
     c+          ALAFPO=IFAPAFPO and IFAPFIRM='01'
     c+          and status = ' ' )
     c/end-exec
     C*
     C*             Status Standard
     c/exec sql
     c+  update tracker set status =
     c+  (select min(snsts)    from  VLF95DWE/frdtn
     c+   where  vsrhf like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          elj=substr(char(PKANR1), 4, 4)         and
     c+          AVDPDN=vsrhe                           and
     c+          status = ' '                       )
     c+   where exists
     c+  (select snsts    from  VLF95DWE/frdtn
     c+   where  vsrhf like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          elj=substr(char(PKANR1), 4, 4)         and
     c+          AVDPDN=vsrhe                           and
     c+          status = ' '                       )
     c/end-exec
     C*
     C*             Status Standard II
     c/exec sql
     c+  update tracker set status =
     c+  (select min(snsts)    from  VLF95DWE/frdtn
     c+   where  vsrhf like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          status=' ' and
     c+          elj=substr(char(PKANR1), 4, 4) )
     c+   where exists
     c+  (select snsts    from  VLF95DWE/frdtn
     c+   where  vsrhf like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          status=' ' and
     c+          elj=substr(char(PKANR1), 4, 4) )
     c/end-exec
     C*
     C*             Status Beipack
     c/exec sql
     c+  update tracker set status =
     c+  (select min(snsts)
     c+          from vlf95dwe.frdtn a inner join vlf95dwe.frdtp t
     c+   on     a.fir  = t.fir and
     c+          a.btnr = t.btnr and
     c+          a.elj  = t.elj and
     c+          a.vsnr = t.vsnr and
     c+          a.vspn = t.vspn
     c+   where  bcd like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          status=' ' and
     c+          substr(a.vsrhf, 1, 13) <> substr(t.bcd, 1, 13) and
     c+          a.elj=substr(char(PKANR1), 4, 4) group by a.elj )
     c+   where exists
     c+  (select min(snsts)
     c+          from vlf95dwe.frdtn a inner join vlf95dwe.frdtp t
     c+   on     a.fir  = t.fir and
     c+          a.btnr = t.btnr and
     c+          a.elj  = t.elj and
     c+          a.vsnr = t.vsnr and
     c+          a.vspn = t.vspn
     c+   where  bcd like
     c+          substr(char(PKANR1), 1, 13) concat '%' and
     c+          status=' ' and
     c+          substr(a.vsrhf, 1, 13) <> substr(t.bcd, 1, 13) and
     c+          a.elj=substr(char(PKANR1), 4, 4) group by a.elj )
     c+
     c/end-exec
     C*date(substr(char(ALREDA
     C*select t.bcd, a.vsrhf, a.*
     C* from vlf95dwe.frdtn a inner join vlf95dwe.frdtp t on
     C*a.fir  = t.fir and
     C*a.btnr = t.btnr and
     C*a.elj  = t.elj and
     C*a.vsnr = t.vsnr and
     C*a.vspn = t.vspn
     C*where  bcd like 'K012023112857%'
     C*and substr(a.vsrhf, 1, 13) <> substr(t.bcd, 1, 13)

     C     ##6600        ENDSR


     C**************************************************************************
     C*beispiel 5 days
     C*SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     C*       AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     C*       AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     C*       concat char(AlAFNR) concat '/' concat
     C*       char(digits(AlAFPO)), 20)
     C*FROM tvrelwaeco/#dp0050
     C*WHERE askmda <> 0 and ((
     C*date(substr(char(askmda), 1, 4) concat '-' concat
     C*substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     C*7, 2) ) = current date - 5 day ) or ( ALLSDA<>ALREDA and
     C*              alreda <> 0 and                              (
     C*date(substr(char(ALREDA), 1, 4) concat '-' concat
     C*substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     C*7, 2) ) = current date - 5 day ))) and substr(amKDNR, 1, 6) in
     C*(select SALES# from SALESCOMP)
     C*-------------------------------------------------------------------------
     C*
     C     sr6666        BEGSR
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
      * Achtung: Lieferschein und Rechnungsdatum können gleich sein
      * ab 22.02.2013
     c*+ 7, 2) ) = current date - 1 day ) or ( ALLSDA<>ALREDA and
     c/exec sql
     c+ insert into tvrelwaeco/db_sped_sc
     c+ SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     c+        AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     c+        AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     c+        concat char(AlAFNR) concat '/' concat
     c+        char(digits(AlAFPO)), 20), AVFIRM, AVKMJJ, AVKMNR, AVKMPO,
     c+        ALKMPO
     c+ FROM tvrelwaeco/#dp0050
     c+ WHERE askmda <> 0 and ((
     c+ year(substr(char(askmda), 1, 4) concat '-' concat
     c+ substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     c+ 7, 2) ) = year(current date)   ) or (
     c+               alreda <> 0 and                              (
     c+ year(substr(char(ALREDA), 1, 4) concat '-' concat
     c+ substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     c+ 7, 2) ) = year(current date)   )))
     c/end-exec
     C*
     C*
     c/exec sql
     c+ update tvrelwaeco/db_sped_sc  set almaaf =
     c+ (select substr(akref1, 1, 10)
     c+                from afko01 where  AMKDNR in
     c+                ('x08138', 'x05084', 'x42634')      and
     c+         DB_SPED_SC.ALAFJJ = AFKO01.AKAFJJ  and
     c+         DB_SPED_SC.ALAFNR = AFKO01.AkAFNR  and
     c+         AFKO01.Akfirm  = '01')
     c+ where exists
     c+ (select substr(akref1, 1, 10)
     c+                from afko01 where  AMKDNR in
     c+                ('x08138', 'x05084', 'x42634')      and
     c+         DB_SPED_SC.ALAFJJ = AFKO01.AKAFJJ  and
     c+         DB_SPED_SC.ALAFNR = AFKO01.AkAFNR  and
     c+         AFKO01.Akfirm  = '01')
     c/end-exec
     C*
     C*
     C*

     C     ##6666        ENDSR


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
