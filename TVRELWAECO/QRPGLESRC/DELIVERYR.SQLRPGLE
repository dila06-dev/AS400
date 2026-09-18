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
      *wichtiger Hinweis:
      *die DB #DB0050 beinhaltet nur Sätze, die auch eine Lieferung
      *hatten, Auftragsart 02 (Gutschriften etc.) sind nicht Bestandteil.
      * insert into qtemp/#DP0050
      * SELECT * FROM afkm a, afvs b, afsp c, aflp d WHERE
      *                                      AMKMJJ > '2015'   and
      * a.AMKMNR=AvKMNR and A.AMFIRM=B.AVFIRM and ASJAHR=a.AMKMJJ AND
      * ASNUMM=a.AMKMNR and a.AMKMJJ = ALKMJJ AND a.AMKMNR = ALKMNR and
      * a.Amfirm in ('01', '51') and d.alfirm in ('01', '51') and
      * c.Asfirm in ('01', '51') and AMKDNR ='055278'
      * 5910 Zeilen in #DP0050 in QTEMP eingefügt.
      *
      *
      *
      * #DP0050 --
      *             #DP0053 --  #DP0054
      * #DP0051 --
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

     C*data base one
     c******             exsr      sr1000
     c                   call      '#DP0050'
     c                   exsr      sr2500
     c                   exsr      sr3000
     c                   exsr      sr5000
     C*data base two
     c                   exsr      sr6000
     c                   exsr      sr6500

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

      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ insert into tvrelwaeco/#DP0051
     c*+ SELECT * FROM statistik
     c*+ where substr(char(rkreda), 1, 4)>char(year(current date -2 year))
     c*/end-exec

      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ update #DP0051 set apkwte = aplfte WHERE apkwte = 0
     c*/end-exec

      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ update #DP0051 set aklock = ' '
     c*/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp      ==> #DP0053
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ whenever not found CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLERROR  CONTINUE
     c*/end-exec

      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ insert into tvrelwaeco/#DP0053
     c*+ select *
     c*+ FROM #DP0050, #DP0051 WHERE aklock=' ' and
     c*+       ALAFJJ=APAFJJ and ALAFNR= APAFNR and
     c*+       ALAFPO=APAFPO and rklinr=allinr
     c*/end-exec


     C     ##2500        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c*/exec sql
     c*+ whenever not found CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLERROR  CONTINUE
     c*/end-exec

      *wichtiger Hinweis: statistk enthält unterschiedliche Felder ab?
      *alle Nachfolgenden datein sind leer dadurch
     c*/exec sql
     c*+ insert into tvrelwaeco/#DP0054
     c*+ SELECT DISTINCT AKLOCK, AKFIRM, AKAFJJ, AKAFNR, AKKDNR, AKAFAT,
     c*+ AKBEDA, AKEIUZ, AKEIDA, AKAFDA, AKMAAF, AKVSNR, AKVSBD, AKLIBD,
     c*+ AKZABD, AKVPEI, AKLIAR, AKNLKZ, AKVSLD, AKKOSP, APZABD, APVSNR,
     c*+ APAFAT, APVSBD, APLIBD, APVALT, APVADA, APVPEI, APMAAF, APKMJJ,
     c*+ APKMNR, APKMPO, APEIUZ, APKMTE, APTENR, APLANR, APLFJK, allsda,
     c*+ APLFTG, APLFTA, APMEIN, APMEPR, APBSMG, APGLMG, APABDA, APKWTE,
     c*+ APLFTE, APPRAR, APPREI, APNESU, APTMST, RKREDA, RKZABD, ALAFJJ,
     c*+ ALAFNR, ALAFPO , AMLOCK,AMKMJJ, AMKMNR, AMKMDA, AMKDNR, AMVSBD,
     c*+ AMLIBD, AMLIAR, AMKOKZ, AMNAM1, AMNAM2, AMNAM3, AMSTRA, AMPOLD,
     c*+ AMPOLZ, AMWORT, AMPOFA, AMLAND, AMLFTE, AVGWBR, AVTENR, AVKDLI,
     c*+ AVDPDN, ASSPED, ASAFJJ, ASAFNR, ASKMDA, ALMAAF, ALTENR, ALTBZ1,
     c*+ ALWAWT, ALKMJJ, ALKMNR, ALKMPO, ALLIJJ, ALLINR, ALLIPO, AVKMPO,
     c*+ AVANZA, AVGWNT, AVVOLU, AVDSKZ, ALGLMG, AVPAKN, rkRGJJ, rkRGNR,
     c*+ RKLINR,
     c*+ AMKMJJ, AMKMNR, AMKMDA, AMKDNR, AMVSBD, AMLIBD, AMLIAR,
     c*+ AMKOKZ, AMNAM1, AMNAM2, AMNAM3, AMSTRA, AMPOLD, AMPOLZ, AMWORT,
     c*+ AMPOFA, AMLAND, AMLFTE, AVGWBR, AVTENR, AVKDLI, AVDPDN, ASSPED,
     c*+ ASAFJJ, ASAFNR, ASKMDA, ALMAAF, ALTENR, ALTBZ1, ALWAWT, ALAFJJ,
     c*+ ALAFNR, ALAFPO, ALKMJJ, ALKMNR, ALKMPO, ALLIJJ, ALLINR, ALLIPO,
     c*+ AVKMPO, AVANZA, AVGWNT, AVVOLU, AVDSKZ, ALGLMG, AVPAKN, AKPRIO,
     c*+ RKRGJJ,RKRGNR, char(' ', 50) notes, char(' ', 1) abc,
     c*+ char(' ', 3) artgrp, char(' ', 3) STATNR, char(' ', 6) ARTZ3 ,
     c*+ zoned( 0, 8) WAO8LFTE, zoned( 0, 8) pickup,
     c*+ decimal( 0, 12, 4) STK_LCP, char(' ', 10) flags,
     c*+ date(substr(char(akbeda), 1, 4) concat '-' concat
     c*+      substr(char(akbeda), 5, 2) concat '-' concat
     c*+      substr(char(akbeda), 7, 2)  ) orderdat,
     c**+ date(substr(char(akeida), 1, 4) concat '-' concat
     c*+      substr(char(akeida), 5, 2) concat '-' concat
     c*+      substr(char(akeida), 7, 2)  ) entrydat,
     c*+ date(substr(char(akafda), 1, 4) concat '-' concat
     c*+      substr(char(akafda), 5, 2) concat '-' concat
     c*+      substr(char(akafda), 7, 2)  ) inputdat,
     c*+ date(substr(char(allsda), 1, 4) concat '-' concat
     c*+      substr(char(allsda), 5, 2) concat '-' concat
     c*+      substr(char(allsda), 7, 2)  ) delivdat,
     c*+ date(substr(char(APKWTE), 1, 4) concat '-' concat
     c*+      substr(char(APKWTE), 5, 2) concat '-' concat
     c*+      substr(char(APKWTE), 7, 2)  ) customdat,
     c*+  date(substr(char(APLFTE), 1, 4) concat '-' concat
     c*+      substr(char(APLFTE), 5, 2) concat '-' concat
     c*+      substr(char(APLFTE), 7, 2)  ) delivdatp,
     c*+ date(substr(char(rkredA), 1, 4) concat '-' concat
     c*+      substr(char(rkreda), 5, 2) concat '-' concat
     c*+      substr(char(rkreda), 7, 2)  ) billdat,
     c*+ date(substr(char(amkmda), 1, 4) concat '-' concat
     c*+      substr(char(amkmda), 5, 2) concat '-' concat
     c*+      substr(char(amkmda), 7, 2)  ) pickdat2
     c*+ from      #DP0053
     c*/end-exec


     C     ##3000        ENDSR

     C**************************************************************************
     C*...
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

     C*
     c/exec sql
     c+ insert into tvrelwaeco/#WAO8
     c+ SELECT DISTINCT WAO8AFJJ,WAO8AFNR,WAO8AFPO,WAO8LFTE FROM wao8 WHERE
     c+ WAO8LFTE > 0 and  WAO8FIRM in ('01', '51')
     c+              GROUP BY WAO8AFJJ, WAO8AFNR, WAO8AFPO, WAO8LFTE
     c/end-exec
     c*

     C     ##5000        ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c*/exec sql
     c*+ whenever not found CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     c*/exec sql
     c*+ WHENEVER SQLERROR  CONTINUE
     c*/end-exec

     C*
     c*/exec sql
     c*+ insert into tvrelwaeco/#DP0060
     c*+ SELECT * FROM afko b, afpo a WHERE AKFIRM=apFIRM and AKAFJJ=apAFJJ
     c*+ and AKAFNN=apAFNN and a.apAFNR not in ( select apafnr from
     c*+ statistik where a.APAFPO = apafpo and a.APAFJJ =APAFJJ )
     c*+ and akfirm in ('01', '51') and apfirm in ('01', '51')
     c*+ and date(substr(char(apafda), 1, 4) concat '-' concat
     c*+          substr(char(apafda), 5, 2) concat '-' concat
     c*+          substr(char(apafda), 7, 2) ) > current date - 007 day
     c*/end-exec
     C*
     C*
     c*/exec sql
     c*+ delete   FROM #dp0060 WHERE APAFST = '90' and apafnr not in (
     c*+ select ALafnr from aflp where ALAFJJ = apafjj and alafpo=apafpo
     c*+                               and      ALFIRM in ('01', '51'))
     c*/end-exec
     C*
     c*/exec sql
     c*+ update #DP0060 set apkwte = aplfte WHERE apkwte = 0
     c*/end-exec
     C*
     c*/exec sql
     c*+ update   #DP0060  set apkoda = '19990101' where apkoda = 0
     c*/end-exec
     C*
     c*/exec sql
     c*+ insert into tvrelwaeco/DB_TWO_PER
     c*+ SELECT AKAFJJ,AKAFNR,AKKDNR,kdNAM1 amnam1,kdPOLZ ampolz,
     c*+        kdPOLD ampold,
     c*+ date(substr(char(akafda), 1, 4) concat '-' concat
     c*+      substr(char(akafda), 5, 2) concat '-' concat
     c*+      substr(char(akafda), 7, 2)  ) inputdat,
     c*+ date(substr(char(apafda), 1, 4) concat '-' concat
     c*+      substr(char(apafda), 5, 2) concat '-' concat
     c*+      substr(char(apafda), 7, 2)  ) inputdatp,
     c*+ AKLIAR,AKPRIO,kdPOLZ  AMPOLZ01,kdPOLD AMPOLD01,
     c*+ APAFST status, AKAFAT,char(' ', 50) Notes, apAFPO ALAFPO01,
     c*+ aptenr ALTENR01,                 ABC,APBSMG, ARTGRP, statnr,
     c*+ date(substr(char(APKWTE), 1, 4) concat '-' concat
     c*+      substr(char(APKWTE), 5, 2) concat '-' concat
     c*+      substr(char(APKWTE), 7, 2)  ) customdat,
     c*+ date(substr(char(APLFTE), 1, 4) concat '-' concat
     c*+      substr(char(APLFTE), 5, 2) concat '-' concat
     c*+      substr(char(APLFTE), 7, 2)  ) delivdatp,
     c*+ zoned( 0, 8) WAO8LFTE,char(' ', 1) FIXEDFLAG,
     c*+ date(substr(char(apkoda), 1, 4) concat '-' concat
     c*+      substr(char(apkoda), 5, 2) concat '-' concat
     c*+      substr(char(apkoda), 7, 2)  ) PICKDAT2,
     c*+                           AKKOSP PICKBLOCK,
     c*+                           AKKOSP HOLDS, char(' ', 10) NEXTSUPPLY,
     c*+ zoned( 0, 8) supplydate, zoned( 0, 4) ALLIJJ01,char(' ', 6) ALLINR01
     c*+ , zoned( 0, 4) ALLIPO01,current date  DELIVDAT,current date
     c*+ DELIVDAT01,APGLMG,char(' ', 10) ASSPED,
     c*+ zoned( 0, 8) PICKUP , zoned( 0, 9, 4) AVGWBR,char(' ', 20) AVPAKN,
     c*+ char(' ', 15) AVTENR, char(' ', 20) AVDPDN,zoned( 0, 4) RKRGJJ ,
     c*+ char(' ', 6) RKRGNR,current date billdat,zoned( 0, 11, 2) APGLMG01,
     c*+ decimal( 0, 12, 4) STK_LCP,decimal( 0, 12, 2) salevalue,
     c*+ decimal( 0, 15, 0) week,
     c*+ AKAFST statush,aksabe staff, KDKDGR, KDNIGB ,KDKSTC,
     c*+ APRSDA rsvdate,
     c*+ char(' ', 10) adKDNR,char(' ', 30) ADNAM1,char(' ', 10) ADPOLZ,
     c*+ char(' ', 03) ADPOLD, LIEFERANT1,char(' ', 30) supplname,
     c*+ ULAND,#TESAAV,#TEDIAV,#TEVOZ1,ARTZ1,
     c*+ current timestamp tstamp, apTBZ1 ALTBZ101
     c*+ FROM tvrelwaeco/#DP0060, kund01,bar_kalk/kalk_file
     c*+ WHERE #DP0060.AKKDNR = KUND01.KDKDNR and #DP0060.APTENR = artnr and
     c*+ version = '$$EL_PS_DB' and KDFIRM in ('01', '51')
     c*/end-exec

     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set APGLMG01 =
     c+ (select sum(ALGLMG) from aflp
     c+  WHERE AKAFJJ = AFLP.ALAFJJ and AKAFNR=alafnr and alafpo= ALAFPO01
     c+        and  AFLP.ALfirm in ('01', '51')
     c+      group by ALafnr,alafpo,ALLIJJ              )
     c+ where exists
     c+ (select sum(ALGLMG) from aflp
     c+  WHERE AKAFJJ = AFLP.ALAFJJ and AKAFNR=alafnr and alafpo= ALAFPO01
     c+        and  AFLP.ALfirm in ('01', '51')
     c+      group by ALafnr,alafpo,ALLIJJ              )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set SUPPLNAME  =
     c+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR and
     c+                     LFFIRM in ('01', '51'))
     c+  where exists
     c+ (select LFNAM1      from lief  WHERE  LIEFERANT1 = LFLFNR and
     c+                     LFFIRM in ('01', '51'))
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    adKDNR=
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    adnam1=
     c+ (select adnam1 from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    adpolz=
     c+ (select adpolz from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    adpold=
     c+ (select adpold from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c+ where exists
     c+ (select adKDNR from afad
     c+  WHERE AKAFJJ = adAFJJ and AKAFNR=adafnr and ADAART ='ADVS' and
     c+        adfirm in ('01', '51') )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    ASSPED=
     c+ (select ASSPED from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by assped)
     c+ where exists
     c+ (select ASSPED from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by assped)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    AVPAKN=
     c+ (select AVPAKN from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avpakn)
     c+ where exists
     c+ (select AVPAKN from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avpakn)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    AVDPDN=
     c+ (select AVDPDN from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avdpdn)
     c+ where exists
     c+ (select AVDPDN from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avdpdn)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    AVGWBR=
     c+ (select AVGWBR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by AVGWBR)
     c+ where exists
     c+ (select AVGWBR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by AVGWBR)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    AVTENR=
     c+ (select AVTENR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avtenr)
     c+ where exists
     c+ (select AVTENR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by avtenr)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    RKRGJJ=
     c+ (select ALRGJJ from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by alRGJJ)
     c+ where exists
     c+ (select RKRGJJ from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by alRGJJ)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    RKRGNR=
     c+ (select alRGNR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by alrgnr)
     c+ where exists
     c+ (select alRGNR from #dp0050
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO group by alrgnr)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    BILLDAT =
     c+ (select BILLDAT from #dp0054
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO )
     c+ where exists
     c+ (select BILLDAT from #dp0054
     c+  WHERE DB_TWO_PER.AKAFJJ = ALAFJJ and DB_TWO_PER.AKAFNR = ALAFNR and
     c+  DB_TWO_PER.ALAFPO01 = ALAFPO )
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set    STK_LCP =
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr = ALTENR01 and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr = ALTENR01 and
     c+         version = '$$EL_PS_DB')
     c/end-exec
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
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set WAO8LFTE =
     c+ (select WAO8LFTE from #wao8              where AKAFNR= WAO8AFNR and
     c+   AKAFJJ  = WAO8AFJJ  and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c+ where exists
     c+ (select WAO8LFTE from #wao8              where AKAFNR= WAO8AFNR and
     c+   AKAFJJ  = WAO8AFJJ  and ALAFPO01= WAO8AFPO and WAO8LFTE <> 0)
     c/end-exec
     C*
     c/exec sql
     c+ update tvrelwaeco/DB_TWO_PER set FIXEDFLAG= 'J' where
     c+         WAO8LFTE <> 0
     c/end-exec
     c*
     c/exec sql
     c+ update DB_TWO_PER set week = dec(year(inputdat) concat
     c+ week(inputdat))
     c/end-exec
     c*

     C     ##6500        ENDSR

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
