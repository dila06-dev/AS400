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
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base three
     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
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
     C*alle Wareneingänge präpariert
     c/exec sql
     c+ insert into tvrelwaeco/DB_WAE130
     c+ SELECT AKAFJJ,AKAFNR,AKKDNR,kdNAM1 amnam1,kdPOLZ ampolz,
     c+        kdPOLD ampold,
     c+ date(substr(char(akafda), 1, 4) concat '-' concat
     c+      substr(char(akafda), 5, 2) concat '-' concat
     c+      substr(char(akafda), 7, 2)  ) inputdat,
     c+ date(substr(char(apafda), 1, 4) concat '-' concat
     c+      substr(char(apafda), 5, 2) concat '-' concat
     c+      substr(char(apafda), 7, 2)  ) inputdatp,
     c+ AKLIAR,AKPRIO,kdPOLZ  AMPOLZ01,kdPOLD AMPOLD01,
     c+ APAFST status, AKAFAT,char(' ', 50) Notes, apAFPO ALAFPO01,
     c+ aptenr ALTENR01,ABC,APBSMG,ARTGRP,statnr,
     c+ date(substr(char(APKWTE), 1, 4) concat '-' concat
     c+      substr(char(APKWTE), 5, 2) concat '-' concat
     c+      substr(char(APKWTE), 7, 2)  ) customdat,
     c+ date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+      substr(char(APLFTE), 5, 2) concat '-' concat
     c+      substr(char(APLFTE), 7, 2)  ) delivdatp,
     c+ zoned( 0, 8) WAO8LFTE,char(' ', 1) FIXEDFLAG,
     c+ date(substr(char(apkoda), 1, 4) concat '-' concat
     c+      substr(char(apkoda), 5, 2) concat '-' concat
     c+      substr(char(apkoda), 7, 2)  ) PICKDAT2,
     c+ AKKOSP PICKBLOCK,AKKOSP HOLDS, char(' ', 10) NEXTSUPPLY,
     c+ zoned( 0, 8) supplydate, rpLIJJ ALLIJJ01, rpLINR ALLINR01,
     c+ rpLIPO  ALLIPO01,current date  DELIVDAT,current date
     c+ DELIVDAT01,APGLMG,char(' ', 10) ASSPED,
     c+ zoned( 0, 8) PICKUP,zoned( 0, 9, 4) AVGWBR,char(' ', 20) AVPAKN,
     c+ char(' ', 15) AVTENR, char(' ', 20) AVDPDN,RKRGJJ,RKRGNR,
     c+ date(substr(char(rkreda), 1, 4) concat '-' concat
     c+      substr(char(rkreda), 5, 2) concat '-' concat
     c+      substr(char(rkreda), 7, 2)  ) billdat,APGLMG01,
     c+ decimal( 0, 12, 4) STK_LCP,decimal( 0, 12, 2) salevalue,
     c+ decimal( 0, 15, 0) week,AKAFST statush,aksabe staff,
     c+ KDKDGR, KDNIGB,KDKSTC,APRSDA rsvdate, char(' ', 10) adKDNR,
     c+ char(' ', 30) ADNAM1,char(' ', 10) ADPOLZ,char(' ', 03) ADPOLD,
     c+ LIEFERANT1,char(' ', 30) supplname,ULAND,#TESAAV,#TEDIAV,#TEVOZ1,
     c+ ARTZ1,current timestamp tstamp, apTBZ1 ALTBZ101,rkwacd,rpnesu,
     c+ rpbrsu,rperg1,rperg2,rperg3,rperg4,rkmws1,rkwawt,
     c+ kdfirm,kdkdst,       kdpold,kdland,kdabma,kdvkgb,
     c+ kdstub,kdfr03,dec((rpnesu/apglmg), 13, 2) PREIS, e1
     c+ FROM tvrelwaeco/#DP0060inv, kund01,bar_kalk/kalk_file
     c+ WHERE #DP0060inv.AKKDNR=KUND01.KDKDNR and #DP0060inv.APTENR= artnr
     c+ and version = '$$EL_PS_DB' and kdfirm in ('01', '51')
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    PICKDAT2 =
     c+ (select  max(date(substr(char(askmda), 1, 4) concat '-' concat
     c+      substr(char(askmda), 5, 2) concat '-' concat
     c+      substr(char(askmda), 7, 2))) from #DP0050  where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and askmda <>0  group by askmda)
     c+  where exists
     c+ (select  max(date(substr(char(askmda), 1, 4) concat '-' concat
     c+      substr(char(askmda), 5, 2) concat '-' concat
     c+      substr(char(askmda), 7, 2))) from #DP0050  where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and askmda <>0  group by askmda)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    delivdat =
     c+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c+      substr(char(ALLSDA), 7, 2))) from #DP0050  where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and askmda <>0  and ALLSDA <>0 group by askmda)
     c+  where exists
     c+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c+      substr(char(ALLSDA), 7, 2))) from #DP0050  where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and askmda <>0  and ALLSDA <>0 group by askmda)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    delivdat =
     c+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c+      substr(char(ALLSDA), 7, 2))) from aflp     where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and ALFIRM in ('01', '51') and ALLSDA <>0 group by ALLSDA)
     c+  where exists
     c+ (select  max(date(substr(char(ALLSDA), 1, 4) concat '-' concat
     c+      substr(char(ALLSDA), 5, 2) concat '-' concat
     c+      substr(char(ALLSDA), 7, 2))) from aflp     where
     c+  a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+  a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+  and ALFIRM in ('01', '51') and ALLSDA <>0 group by ALLSDA)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set SUPPLNAME  =
     c+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR and
     c+                                       LFFIRM in ('01', '51'))
     c+  where exists
     c+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR and
     c+                                       LFFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    adKDNR=
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    adnam1=
     c+ (select adnam1 from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    adpolz=
     c+ (select adpolz from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    adpold=
     c+ (select adpold from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+                                           AdFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    ASSPED=
     c+ (select  max(ASSPED) from #DP0050  where
     c+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by assped)
     c+  where exists
     c+ (select  max(ASSPED) from #DP0050  where
     c+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by assped)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    avpakn=
     c+ (select  max(avpakn) from #DP0050  where
     c+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by avpakn)
     c+  where exists
     c+ (select  max(avpakn) from #DP0050  where
     c+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by avpakn)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    AVDPDN=
     c+ (select  max(AVDPDN) from #DP0050  where
     c+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVDPDN)
     c+  where exists
     c+ (select  max(AVDPDN) from #DP0050  where
     c+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVDPDN)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    AVGWBR=
     c+ (select  max(AVGWBR) from #DP0050  where
     c+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVGWBR)
     c+  where exists
     c+ (select  max(AVGWBR) from #DP0050  where
     c+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVGWBR)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  a set    AVTENR=
     c+ (select  max(AVTENR) from #DP0050  where
     c+   a.akAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVTENR)
     c+  where exists
     c+ (select  max(AVTENR) from #DP0050  where
     c+   a.AKAFJJ=ALAFJJ and a.AKAFNR=ALAFNR and a.ALAFPO01=alafpo and
     c+   a.ALLIJJ01=ALLIJJ and a.ALLINR01=ALLINR and a.ALLIPO01=ALLIPO
     c+   and askmda <>0  group by AVTENR)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    STK_LCP =
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr=ALTENR01
     c+   and   version = '$$EL_PS_DB')
     c+ where exists
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr=ALTENR01
     c+   and   version = '$$EL_PS_DB')
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set WAO8LFTE =
     c+ (select WAO8LFTE from #wao8        where AKAFNR= WAO8AFNR and
     c+      AKAFJJ=WAO8AFJJ and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c+ where exists
     c+ (select WAO8LFTE from #wao8        where AKAFNR= WAO8AFNR and
     c+      AKAFJJ=WAO8AFJJ and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set FIXEDFLAG= 'J' where
     c+         WAO8LFTE <> 0
     c/end-exec
     c*
     c/exec sql
     c+ update DB_INV_PER set week = dec(year(inputdat) concat
     c+ week(inputdat))
     c/end-exec
     c*

     C     ##1000        ENDSR

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
