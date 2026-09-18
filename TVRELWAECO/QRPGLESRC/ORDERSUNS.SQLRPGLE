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
      *SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
      *apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
      *aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
      *char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
      *APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
      *dec(0, 06) #cc,char('  ', 2) status,current date #date,
      *current timestamp #stamp, char(' ', 120) Zusatz FROM
      *afpo01 WHERE apafjj >2014 and APJDAT > 20160100
      *and APAFAT <> '71' and apfirm='01' and APAFAT <> '70'
      *and APAFAT <> '05' and APAFAT <> '02' and APAFST < 89
      *and aptenr in (select ITEM from tvrelwaeco/SUNSLOWAKI)
      *and char ( apfirm concat
      *     apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
      *not in  (select order from tvrelwaeco/ordersun   )
      *and apafnr in ( select akafnr from afko01
      *    where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
      *     and   akref2 not like '%bereits erfasst%' ) and
      *aptenr in (select tetenr from abestand where Lager='001'
      *and bestand > 0)
      *_______________________________________________________________________________
      *25.08.2015 Gang
      *bestandsführende lager erweitert auf
      *    LBBSLANR in ('001', '060', '070')
      *für Markisen aus slowakai
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

     C*data base three
     C*inaktiv ab 04. 12. 2020 12:00
     c********           exsr      sr6000
     C*aktiv ab 09. 06. 2017 (nur für Auftragsart 58)
     C*inaktiv ab 01. 10. 2029 (nur für Auftragsart 58)
     c********           exsr      sr600058
     C*aktiv ab 01. 07. 2015 (function) slowakia awnings
     C*                      prüfung gegen tvrelwaeco/SUNSLOWAKI
     C*                      raus 08.03.2016
     c********           exsr      sr6010
     C*data base from NL and BE
     c********           exsr      sr7000

     C*data base from AU
     c********           exsr      sr7500

     C*data base from CH
     c********           exsr      sr7600

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
     c/exec sql
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2015 and (APPRGR ='349' or APPRGR ='343')
     c+  and APAFAT <> '17' and APAFAT <> '58'      and APAFAT <> '02'
     c+  and APAFAT <> '01' and APAFAT <> '58'      and APAFAT <> '02'
     c+ and APAFAT <> '71' and apfirm='01' and APAFAT <> '70' and
     c+ APAFAT <> '14' and APAFAT <> '97' and APAFDA > 20160200
     c+ and APAFAT <> '05' and apafat <> '03' and apafnr <> '747753'
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+     and   akref2 not like '%bereits erfasst%'
     c+     and   AKAFST <> '89')
     c/end-exec

     c/exec sql
     c+    create index    tvrelwaeco/ORDERSUNl
     c+           on       tvrelwaeco/ORDERSUN
     c+    (APFIRM,APAFJJ,APAFNR,APAFPO)
     c/end-exec

     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr600058      BEGSR
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
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2019 and (APPRGR ='349' or APPRGR ='343')
     c+  and APAFAT =  '58' and apfirm='01' and APAFDA > 20190000
     c+  and apafnr <> '747753'
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+     and   akref2 not like '%bereits erfasst%' )
     c+ and apafnr in ( select EUAFNR from bbeu01
     c+     where apfirm = eufirm and apafjj=euafjj and apafpo=euafpo)
     c/end-exec

     C*
     c/exec sql
     c+ insert into ###bbeu
     c+ select * from bbeu01 a
     c+ where (a.EUAFNR not in (select b.EUAFNR from ###bbeu b where
     c+ a.EUAFJJ=b.EUAFJJ and a.euafpo=b.euafpo and a.eufirm=b.eufirm)) and
     c+         (a.euafnr in   (select apafnr from ordersun where
     c+ a.euafjj=apafjj   and   a.euafpo=apafpo and a.eufirm=  apfirm)) and
     c+      (a.euafnr in     (select apafnr from afpo01   where
     c+  a.euafjj=apafjj and      a.euafpo=apafpo and a.eufirm=apfirm
     c+                                                   and apafat='58'))
     c/end-exec

     c/exec sql
     c+    create index    tvrelwaeco/ORDERSUNl
     c+           on       tvrelwaeco/ORDERSUN
     c+    (APFIRM,APAFJJ,APAFNR,APAFPO)
     c/end-exec

     C     ##600058      ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6010        BEGSR
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
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2015 and APJDAT > 20160200
     c+ and APAFAT <> '71' and apfirm='01' and APAFAT <> '70'
     c+ and APAFAT <> '05' and APAFAT <> '02' and APAFST < 89 and
     c+ APAFAT <> '14' and APAFAT <> '97' and APAFAT <> '17'
     c+ and aptenr in (select ITEM from tvrelwaeco/SUNSLOWAKI)
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+      and   akref2 not like '%bereits erfasst%' )
     c+      and   aptenr not in (select TETENR from abestand
     c+            where bestand > APBSMG or bestand = APBSMG)
     c***+ (aptenr not in (SELECT A.LBBSTENR  FROM LBBs01 a, lbsd01 b where
     c***+            LBBSFIRM=01 and LDFIRM=01 and LBBSFIRM=LDFIRM and
     c***+            LBBSLANR in ('001', '060', '070') and
     c***+            LBBSlanr=LDlanr and LBBSSPKZ<>'J'
     c***+            and (LBBSLAGB ) > 0 )  and
     c***+ aptenr  in  (SELECT A.LBrsTENR  FROM LBrs01 a     where
     c***+             LBrsFIRM=APFIRM and LBRSAFJJ=APAFJJ and
     c***+             LBRSAFNR=APAFNR and LBRSAFPO=APAFPO )    )
     c/end-exec
     C*in  aptenr not in (SELECT A.LBBSTENR  FROM LBBs01 a, lbsd01 b where
     C*               LBBSFIRM=01 and LDFIRM=01 and LBBSFIRM=LDFIRM and
     C*               LBBSLANR='001' and LBBSlanr=LDlanr and LBBSSPKZ<>'J'
     C*               and (LBBSLAGB ) > 0 )
     C*  sind nur Sätze mit Bestand, die wollen wir nicht, da vorrangig aus
     C*  unserem Lager

     C     ##6010        ENDSR

     C**************************************************************************
     C*Niederlande und Belgien
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

     C*
     C*Achtung mit Auftragsart 01, diese wir nicht übergeben nach EDC
     c/exec sql
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2015 and APPRGR ='155' and APAFAT =  '01'
     c+ and (apfirm='52' or apfirm ='08') and APAFDA > 20160200
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+     and   akref2 not like '%bereits erfasst%' )
     c***+ and aptenr in (select tetenr from teil01 where apfirm=tefirm
     c***+     and   TELFNR  = '6450350   ' or TELFNR  = '6450350   ' )
     c/end-exec

     C     ##7000        ENDSR

     C**************************************************************************
     C*Österreich
     C*-------------------------------------------------------------------------
     C*
     C     sr7500        BEGSR
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
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2015 and (APPRGR ='349' or APPRGR ='343')
     c+                                             and APAFAT =  '01'
     c+ and (apfirm='61')                 and APAFDA > 20160200
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+     and   akref2 not like '%bereits erfasst%' )
     c**+ and aptenr in (select tetenr from teil01 where apfirm=tefirm
     c**+     and   TELFNR  = '330266    ' )
     c/end-exec

     C     ##7500        ENDSR

     C**************************************************************************
     C*Schweiz
     C*-------------------------------------------------------------------------
     C*
     C     sr7600        BEGSR
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
     c+ insert into tvrelwaeco/ORDERSUN
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APFIRM,char ( apfirm concat
     c+ apafjj concat APAFNR concat char(digits(APAFPO)) , 16) order,
     c+ aptenr,APAFST,char(' ', 2) RKFIRM,APAFJJ*0 RKRGJJ,
     c+ char(' ', 06) RKRGNR,APAFJJ*0 RKLIJJ,char(' ', 06) RKLINR,
     c+ APUSER, APBSMG, APLFTE, APAFDA, APMAAF, APKDNR,
     c+ dec(0, 06) #cc,char('  ', 2) status,current date #date,
     c+ current timestamp #stamp, char(' ', 120) Zusatz FROM
     c+ afpo01 WHERE apafjj >2017 and (APPRGR ='349' or APPRGR ='343')
     c+                                             and
     c+ ( APAFAT =  'G01' or APAFAT =  'G01' )
     c+ and (apfirm='55') and APAFDA > 20180000
     c+ and char ( apfirm concat
     c+      apafjj concat APAFNR concat char(digits(APAFPO)) , 16)
     c+ not in  (select order from tvrelwaeco/ordersun   )
     c+ and apafnr in ( select akafnr from afko01
     c+     where apfirm = akfirm and apafjj=akafjj and AKLOCK = ' '
     c+     and   akref2 not like '%bereits erfasst%' )
     c**+ and aptenr in (select tetenr from teil01 where apfirm=tefirm
     c**+     and   TELFNR  = '330266    ' )
     c/end-exec

     C     ##7600        ENDSR

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
