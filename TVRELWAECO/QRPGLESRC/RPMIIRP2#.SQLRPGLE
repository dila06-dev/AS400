     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      *
      *
      * SELECT * FROM rpmII_TO WHERE DOCtype not in ( '10', '11', '12',
      * '13','16', '17', '18', '19', '20', '81', '82' ,'83') and APPRGR <
      * '901 ' and DIVISION not in ('GROUP', '     ') ORDER BY doctype
      * SELECT COUNT_ISO, substr(RKREDA, 1, 6), sum(RPNESU) FROM #RP0530S#
      * WHERE COUNT_ISO <> 'CH' GROUP BY COUNT_ISO,substr(RKREDA, 1, 6)
      * ORDER BY COUNT_ISO,substr(RKREDA, 1, 6)
      * check
      * SELECT * FROM statistik# WHERE
      * (char(RPRGJJ concat '/' concat char(RPRGNR) concat '/' concat
      * char(digits(rplijj)) concat '/' concat char(rplinr) concat '/'
      * concat char(digits(rplipo)) concat '/' concat substr(akafat, 1, 3)
      * concat '/' concat (akfirm), 35) not in (select doc from #RP0530S#))
      * Datei CHECK in QTEMP wurde erstellt.
      *
      * update  qtemp/check           set  AKGRON        =
      * (sELECT substr(KDEWKSST, 1, 8)  from kdew     where
      * KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
      *                 and     akfirm              =  KDEWfirm)
      * where exists
      * (sELECT substr(KDEWKSST, 1, 8)  from kdew     where
      * KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
      *                 and     akfirm              =  KDEWfirm)
      * 9871 Zeilen in CHECK in QTEMP aktualisiert.
      *
      * update  qtemp/check           set  akgron   = case
      * When akgron   = '1001    ' then 'RVOE    '
      * When akgron   = '1002    ' then 'RVAM    '
      * When akgron   = '1003    ' then 'RETL    '
      * When akgron   = '1004    ' then 'LODG    '
      * When akgron   = '1005    ' then 'AUOE    '
      * When akgron   = '1006    ' then 'AUAM    '
      * When akgron   = '1007    ' then 'MAOE    '
      * When akgron   = '1008    ' then 'MAAM    '
      * When akgron   = '1009    ' then 'MEDI    '
      * When akgron   = '1015    ' then 'GROUP   '
      * When akgron   = '1020    ' then 'OTHER   '
      * When akgron   = '6050    ' then 'OTHER   '
      * else akgron
      * end
      * 9871 Zeilen in CHECK in QTEMP aktualisiert.
      *
      * update  qtemp/check set  akgron = substr(akgron, 1, 8) concat
      * (select TEEWPRGR    from  teew01            WHERE
      *      APTENR= TEEWTENR and TEEWFIRM in ('08', '52', '55')
      *               and     akfirm              =  TEEWFIRM)
      * where exists
      * (select TEEWPRGR    from  teew01            WHERE
      *      APTENR= TEEWTENR and TEEWFIRM in ('08', '52', '55')
      *               and     akfirm              =  TEEWFIRM)
      * 9868 Zeilen in CHECK in QTEMP aktualisiert.
      *
      *
      * SELECT substr(char(current date, iso), 1, 4)
      *        concat substr(char(current date, iso), 6, 2) concat
      *        substr(char(current date, iso), 9, 2) postdate,
      *        char('DE411', 5 ) entity,char('DE', 2) Count_iso,
      * rptenr sku,APTBZ1,APGLMG,char(days((date(substr(char(RKREDA), 1, 4)
      * concat '-' concat substr(char(RKREDA), 5, 2) concat '-' concat
      * substr(char(RKREDA), 7, 2) )))) entry#, char(AKAFAT, 20) doctype,
      * char(RPRGJJ concat '/' concat char(RPRGNR) concat '/' concat
      * char(digits(rplijj)) concat '/' concat char(rplinr) concat '/'
      * concat char(digits(rplipo)) concat '/' concat
      * substr(akafat, 1, 3) concat '/'  concat (akfirm), 35) doc,rkreda,
      * decimal(0, 11, 2) cost_unit,RPBRSU rpnesu,RKWACD,APPRGR,
      * char('   ', 8) division, RKKDNR,char( ' ', 30) kdrbez,ALGLMG,
      * altenr,rptenr artsku, char(' ', 15) artbezfra,AKGRON
      * FROM check , #AFLPL1  where
      *     alfirm=rpfirm and ALRGJJ=rprgjj and alRGNR=rprgnr
      * and allijj=rplijj and allinr=rplinr and allipo=rplipo
      * Datei CHECK2 in QTEMP wurde erstellt.
      *
      *
      *
      *
      *
      *
      *
      *
      *  CHGDTAARA DTAARA(#DAYMINUS *ALL) VALUE(1)
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)

     fRPMII_TO# uf   e             disk
     f                                     RENAME(RPMII_TO#:phy01r)
     F                                     USROPN

     fwaeh01    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z
     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     Dweek             s              1s 0

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
b
     c                   exsr      sr9999
     C                   z-add     1             z                 2 0
     c                   if        week   = 1
     C                   z-add     3             z                 2 0
     c                   endif
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   exsr      sr3000
     c                   exsr      return

     C**************************************************************************
     C*Definition: Filterung aller Eigenproduktionsartikel mit Absatz
     C*            und einem STK3 Wert > 0,
     C*            die in dieser Datei zum ersten mal auflaufen und
     C*            Kunden der Group sind (Verzeichnis)
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

     c/exec sql
     c+ insert into tvrelwaeco/RPMII_TO#
     c+ SELECT substr(char(current date, iso), 1, 4)
     c+        concat substr(char(current date, iso), 6, 2) concat
     c+        substr(char(current date, iso), 9, 2) postdate,
     c+        char('DE411', 5 ) entity,char('DE', 2) Count_iso,
     c+ rptenr sku,APTBZ1,APGLMG,char(days((date(substr(char(RKREDA), 1, 4)
     c+ concat '-' concat substr(char(RKREDA), 5, 2) concat '-' concat
     c+ substr(char(RKREDA), 7, 2) )))) entry#, char(AKAFAT, 20) doctype,
     c+ char(RPRGJJ concat '/' concat char(RPRGNR) concat '/' concat
     c+ char(digits(rplijj)) concat '/' concat char(rplinr) concat '/'
     c+ concat char(digits(rplipo)) concat '/' concat
     c+ substr(akafat, 1, 3) concat '/'  concat (akfirm), 35) doc,rkreda,
     c+ decimal(0, 11, 2) cost_unit,RPBRSU rpnesu,RKWACD,APPRGR,
     c+ char('   ', 8) division, RKKDNR,char( ' ', 30) kdrbez,ALGLMG,
     c+ altenr,rptenr artsku, char(' ', 15) artbezfra,
     c+ char('  ', 2) custcode
     c+ FROM statistik#, #AFLPL1 where
     c+    (year(date(substr(char(RKREDA), 1, 4) concat '-'
     c+       concat substr(char(RKREDA), 5, 2) concat '-'
     c+       concat substr(char(RKREDA), 7, 2))) =
     c+                  year(current date))
     c+  and AKAFAT in ('01 ','02 ','03 ','05 ','06 ','08 ',
     c+                 '25 ','26 ','27 ','28 ',
     c+                 '31 ','55 ',
     c+                 '70 ','71 ',
     c+                 '72 ','A01')  and rptenr <> '8887100008'
     c**+  and     RPRGNR =     '516558'
     c+  and (char(RPRGJJ concat '/' concat char(RPRGNR) concat '/' concat
     c+  char(digits(rplijj)) concat '/' concat char(rplinr) concat '/'
     c+  concat char(digits(rplipo)) concat '/' concat
     c+  substr(akafat, 1, 3) concat '/'  concat (akfirm), 35)
     c+  not in (select doc from #RP0530S#))
     c********+  and (rkreda not in (select rkreda from #RP0530S#))
     c+  and alfirm=rpfirm and ALRGJJ=rprgjj and alRGNR=rprgnr
     c+  and allijj=rplijj and allinr=rplinr and allipo=rplipo
     c/end-exec

     C*Kostenstelle
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  division      =
     c+ (sELECT max(substr(KDEWKSST, 1, 8))  from kdew     where
     c+ KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
     c+                 and     substr(doc, 34, 2)  =  KDEWfirm)
     c+ where exists
     c+ (sELECT max(substr(KDEWKSST, 1, 8))  from kdew     where
     c+ KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
     c+                 and     substr(doc, 34, 2)  =  KDEWfirm)
     c/end-exec

     C*rpm-zuordnung
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  custcode      =
     c+ (sELECT substr(kDEWRPMG, 2, 2)  from kdew     where
     c+ KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
     c+                 and     substr(doc, 34, 2)  =  KDEWfirm)
     c+ where exists
     c+ (sELECT substr(kDEWRPMG, 2, 2)  from kdew     where
     c+ KDEWFIRM in ('08', '52', '55') and  RKKDNR  =  KDEWKDNR
     c+                 and     substr(doc, 34, 2)  =  KDEWfirm)
     c/end-exec

     C*Kostenstelle
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  division = case
     c+ When division = '1001    ' then 'RVOEM   '
     c+ When division = '1002    ' then 'RVAM    '
     c+ When division = '1003    ' then 'RETL    '
     c+ When division = '1004    ' then 'LODG    '
     c****+ When division = '1005    ' then 'CPVE    '
     c+ When division = '1005    ' then 'CPVOEM  '
     c****+ When division = '1006    ' then 'AUAM    '
     c+ When division = '1006    ' then 'CPVAM   '
     c****+ When division = '1007    ' then 'MAOE    '
     c+ When division = '1007    ' then 'MAOEM   '
     c+ When division = '1008    ' then 'MAAM    '
     c+ When division = '1009    ' then 'MEDI    '
     c+ When division = '1015    ' then 'GROUP   '
     c+ When division = '1020    ' then 'OTHER   '
     c+ When division = '6050    ' then 'OTHER   '
     c+ else division
     c+ end
     c/end-exec

     C*Bezeichnung
     c/exec sql
     c+ delete from tvrelwaeco/rpmII_TO#
     c+ where division='GROUP   '
     c/end-exec

     C*Entity
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  entity   = case
     c+ When substr(doc, 34, 2) = '08' then 'BE111'
     c+ When substr(doc, 34, 2) = '52' then 'NL411'
     c+ When substr(doc, 34, 2) = '55' then 'CH412'
     c+ else division
     c+ end
     c/end-exec

     C*Count_iso
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  Count_iso = case
     c+ When substr(doc, 34, 2) = '08' then 'BE'
     c+ When substr(doc, 34, 2) = '52' then 'NL'
     c+ When substr(doc, 34, 2) = '55' then 'CH'
     c+ else division
     c+ end
     c/end-exec

     C*Bezeichnung
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  KDRBEZ        =
     c+ (sELECT KDNAM1                  from kund01   where
     c+ KDFIRM in ('08', '52', '55') and  RKKDNR  =  KDKDNR
     c+               and     substr(doc, 34, 2)  =  KDfirm)
     c+ where exists
     c+ (sELECT KDNAM1                  from kund01   where
     c+ KDFIRM in ('08', '52', '55') and  RKKDNR  =  KDKDNR
     c+               and     substr(doc, 34, 2)  =  KDfirm)
     c/end-exec

     C*Bezeichnung
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  COUNT_ISO     =
     c+ (sELECT KDPOLD                  from kund01   where
     c+ KDFIRM in ('08', '52', '55') and  RKKDNR  =  KDKDNR
     c+               and     substr(doc, 34, 2)  =  KDfirm)
     c+ where exists
     c+ (sELECT KDPOLD                  from kund01   where
     c+ KDFIRM in ('08', '52', '55') and  RKKDNR  =  KDKDNR
     c+               and     substr(doc, 34, 2)  =  KDfirm)
     c/end-exec

     C*price
     c*/exec sql
     c*+ update  tvrelwaeco/rpmII_TO#  set  COST_UNIT   =
     c*+ (select testpr      from bar_kalk/kalk_file WHERE   f
     c*+         altenr = artnr  and version ='$$EL_PS_DB')
     c*+ where exists
     c*+ (select COSTPRS_AR  from bar_kalk/kalk_file WHERE
     c*+         altenr = artnr  and version ='$$EL_PS_DB')
     c*/end-exec

     C*price
     c*/exec sql
     c*+ update  tvrelwaeco/rpmII_TO#  set  COST_UNIT   =
     c*+ (select TESTPV      from teil               WHERE
     c*+         altenr = TETENR and TEFIRM in ('08', '52', '55')
     c*+               and     substr(doc, 34, 2)  =  tefirm)
     c*+ where exists
     c*+ (select TESTPV      from teil               WHERE
     c*+         altenr = TETENR and TEFIRM in ('08', '52', '55')
     c*+               and     substr(doc, 34, 2)  =  tefirm)
     c*/end-exec

     C*price
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  COST_UNIT   =
     c+ (select TESTPR      from teil               WHERE
     c+         altenr = TETENR and TEFIRM in ('08', '52', '55')
     c+               and     substr(doc, 34, 2)  =  tefirm)
     c+ where exists
     c+ (select TESTPR      from teil               WHERE
     c+         altenr = TETENR and TEFIRM in ('08', '52', '55')
     c+               and     substr(doc, 34, 2)  =  tefirm)
     c/end-exec

     C*sku ???????
     c*/exec sql
     c*+ update  tvrelwaeco/rpmII_TO#  set  sku         =
     c*+ (select artsku      from bar_kalk/kalk_file WHERE
     c*+         sku  = artnr  and version ='$$EL_PS_DB')
     c*+ where exists
     c*+ (select artsku      from bar_kalk/kalk_file WHERE
     c*+         sku  = artnr  and version ='$$EL_PS_DB')
     c*/end-exec

     C*dometic gruppe
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  APPRGR      =
     c+ (select TEEWPRGR    from  teew01            WHERE
     c+      ALTENR= TEEWTENR and TEEWFIRM in ('08', '52', '55')
     c+               and     substr(doc, 34, 2)  =  TEEWFIRM)
     c+ where exists
     c+ (select TEEWPRGR    from  teew01            WHERE
     c+      ALTENR= TEEWTENR and TEEWFIRM in ('08', '52', '55')
     c+               and     substr(doc, 34, 2)  =  TEEWFIRM)
     c/end-exec

     C*doc_type
     c*+ When doctype  = 'A11     ' then 'nein                '
     c*+ When doctype  = '98      ' then 'nein                '
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  doctype  = case
     c+ When doctype  = 'A01     ' then 'Sales Invoice     01'
     c+ When doctype  = '01      ' then 'Sales Invoice     01'
     c+ When doctype  = '02      ' then 'Sales Invoice     02'
     c+ When doctype  = '03      ' then 'Sales Invoice     03'
     c+ When doctype  = '04      ' then 'Sales Invoice     04'
     c+ When doctype  = '05      ' then 'Sales Invoice     05'
     c+ When doctype  = '06      ' then 'Sales Invoice     06'
     c+ When doctype  = '08      ' then 'Sales Invoice     08'
     c+ When doctype  = '10      ' then 'Sales Invoice     10'
     c+ When doctype  = '10      ' then 'Sales Invoice     10'
     c+ When doctype  = '25      ' then 'Sales Invoice     25'
     c+ When doctype  = '26      ' then 'Sales Invoice     26'
     c+ When doctype  = '27      ' then 'Sales Invoice     27'
     c+ When doctype  = '28      ' then 'Sales Invoice     28'
     c+ When doctype  = '31      ' then 'Sales Invoice     31'
     c+ When doctype  = '55      ' then 'Sales Invoice     55'
     c+ When doctype  = '83      ' then 'Sales Invoice     83'
     c+ When doctype  = '88      ' then '88 for customs      '
     c+ When doctype  = '11      ' then 'Sales CR/Adj Note 11'
     c+ When doctype  = '14      ' then 'Sales CR/Adj Note 14'
     c+ When doctype  = '15      ' then 'Sales CR/Adj Note 15'
     c+ When doctype  = '16      ' then 'Sales CR/Adj Note 16'
     c+ When doctype  = '17      ' then 'Sales CR/Adj Note 17'
     c+ When doctype  = '18      ' then 'Sales CR/Adj Note 18'
     c+ When doctype  = '20      ' then 'Sales CR/Adj Note 20'
     c+ When doctype  = '44      ' then 'Sales CR/Adj Note 44'
     c+ When doctype  = '50      ' then 'Sales CR/Adj Note 50'
     c+ When doctype  = '70      ' then 'Sales CR/Adj Note 70'
     c+ When doctype  = '71      ' then 'Sales CR/Adj Note 71'
     c+ When doctype  = '72      ' then 'Sales CR/Adj Note 72'
     c+ When doctype  = '81      ' then 'Sales CR/Adj Note 81'
     c+ When doctype  = '82      ' then 'Sales CR/Adj Note 82'
     c+ When doctype  = '99      ' then 'Sales CR/Adj Note 99'
     c+ else doctype
     c+ end
     c/end-exec

     C*Umsetzung falscher vergebener ITems bzw. Zuordnung neu
     c*/exec sql
     c*+ update  tvrelwaeco/rpmII_TO#  set  sku         =
     c*+ (select KPTENR      from  kpif              WHERE
     c*+     sku = KPIDEN and KPFIRM ='01' and KPiden<>KPTENR and
     c**+     substr(KPiden, 1, 5) ='91090' and
     c*+     ((kpkdnr ='015177' and ENTITY='NL411') or
     c*+      (kpkdnr ='062765' and ENTITY='BE111'))   )
     c*+ where exists
     c*+ (select KPTENR      from  kpif              WHERE
     c*+     sku = KPIDEN and KPFIRM ='01' and KPiden<>KPTENR and
     c**+    substr(KPiden, 1, 5) ='91090' and
     c*+     ((kpkdnr ='015177' and ENTITY='NL411') or
     c*+      (kpkdnr ='062765' and ENTITY='BE111'))   )
     c*/end-exec

     C*-------------------------------------------------------------
     C*sku wenn artbezfra = *blank dann aus Feld sku
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  sku         =
     c+ (select artsku      from bar_kalk/kalk_file WHERE
     c+       ALTENR = artnr  and version ='$$EL_PS_DB' and
     c+       artbezfra =  ' ' and
     c+       substr(artsku, 1, 3)<> '001' and
     c+       lieferant1 not in ('90025','90489','90526') and
     c+       DIVISION <> 'GROUP'           )
     c+ where exists
     c+ (select artsku      from bar_kalk/kalk_file WHERE
     c+       ALTENR = artnr  and version ='$$EL_PS_DB' and
     c+       artbezfra =  ' ' and
     c+       substr(artsku, 1, 3)<> '001' and
     c+       lieferant1 not in ('90025','90489','90526') and
     c+       DIVISION <> 'GROUP'           )
     c/end-exec

     C*sku wenn artbezfra <> *blank dann aus Feld artbezfra
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO#  set  sku         =
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  ALTENR = artnr and version ='$$EL_PS_DB' and artbezfra <> ' '
     c+  and  substr(artbezfra, 1, 3)<> '001' and
     c+       lieferant1 not in ('90025','90489','90526') and
     c+       DIVISION <> 'GROUP'           )
     c+ where exists
     c+ (select substr(artbezfra, 1, 10) from bar_kalk/kalk_file WHERE
     c+  ALTENR = artnr and version ='$$EL_PS_DB' and artbezfra <> ' '
     c+  and  substr(artbezfra, 1, 3)<> '001' and
     c+       lieferant1 not in ('90025','90489','90526') and
     c+       DIVISION <> 'GROUP'           )
     c/end-exec

     C*-------------------------------------------------------------

     C*Protokoll
     c/exec sql
     c+ update tvrelwaeco/rpmII_TO# set
     c+        artbezfra=substr(artbezfra, 1, 14) concat
     c+ (select '#'        from teos
     c+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c+       ('01','51')  and TEOSMM01 <> ' ' )
     c+ where exists
     c+ (select '#'        from teos
     c+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c+       ('01','51')  and TEOSMM01 <> ' ' )
     c/end-exec

     C*und evtl. erneuter Anpassung
     C*sku ??????? Achtung mit 01/51 lesen   inaktiv 26.09.2013
     c***/exec sql
     c***+ update  tvrelwaeco/rpmII_TO#  set  sku         =
     c***+ (select TEOSMM01   from teos
     c***+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c***+       ('01','51')  and TEOSMM01 <> ' ' )
     c***+ where exists
     c***+ (select TEOSMM01   from teos
     c***+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c***+       ('01','51')  and TEOSMM01 <> ' ' )
     c***/end-exec

     C*Protokoll
     c/exec sql
     c+ update tvrelwaeco/rpmII_TO# set
     c+                     artbezfra=substr(artbezfra, 1, 14) concat
     c+ (select '§'         from bar_kalk/kalk_file WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB'  and
     c+         substr(artbezfra, 15, 1) =' '  )
     c+ where exists
     c+ (select '§'         from bar_kalk/kalk_file WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB'  and
     c+         substr(artbezfra, 15, 1) =' '  )
     c/end-exec

     C*sku ???????                            inaktiv 26.09.2013
     c***/exec sql
     c***+ update  tvrelwaeco/rpmII_TO# a set  sku         =
     c***+ (select artsku      from bar_kalk/kalk_file b WHERE
     c***+         sku  = artnr  and version ='$$EL_PS_DB' and
     c***+                b.artbezfra         =' '  )
     c***+ where exists
     c***+ (select artsku      from bar_kalk/kalk_file b WHERE
     c***+         sku  = artnr  and version ='$$EL_PS_DB' and
     c***+                b.artbezfra         =' '  )
     c***/end-exec

     C*Ausgabe Protokoll für Abstimmung
     c/exec sql
     c+ insert into tvrelwaeco/RPMII_TO#p
     c+ SELECT ENTITY,SKU,APPRGR,ALTENR,ARTSKU,ARTBEZFRA, char(' ', 4)
     c+ apprgr_EM FROM RPMII_TO# GROUP BY ENTITY,SKU,APPRGR,ALTENR,
     c+ ARTSKU,ARTBEZFRA ORDER BY ENTITY,artSKU,APPRGR,ALTENR,ARTSKU,
     c+ ARTBEZFRA
     c/end-exec

     C*Prüfung der Gruppe gegen Emsdetten  -1- a.sku  = artsku
     c/exec sql
     c+ update  tvrelwaeco/RPMII_TO#p a set  apprgr_EM     =
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.sku  = artsku                       ) and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c+ where exists
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.sku  = artsku                       ) and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c/end-exec

     C*Prüfung der Gruppe gegen Emsdetten  -2- a.sku = artbezfra
     c/exec sql
     c+ update  tvrelwaeco/RPMII_TO#p a set  apprgr_EM     =
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.sku = artbezfra                     ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c+ where exists
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.sku = artbezfra                     ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c/end-exec

     C*Prüfung der Gruppe gegen Emsdetten   -3-  a.altenr =artsku
     c/exec sql
     c+ update  tvrelwaeco/RPMII_TO#p a set  apprgr_EM     =
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.altenr = artsku                        ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c+ where exists
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.altenr = artsku                        ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c/end-exec

     C*Prüfung der Gruppe gegen Emsdetten  -4- a.altenr = artbezfra
     c/exec sql
     c+ update  tvrelwaeco/RPMII_TO#p a set  apprgr_EM     =
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.altenr = artbezfra                  ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c+ where exists
     c+ (select distinct max(liefnr) from bar_kalk/kalk_file WHERE
     c+         (a.altenr = artbezfra                  ) and
     c+          apprgr_EM =  ' '                    and
     c+          version ='$$EL_PS_DB'               and
     c+          substr(a.artbezfra, 15, 1) <> ' '  group by liefnr)
     c/end-exec


     C*Gruppenberichtigung
     c/exec sql
     c+ update  RPMII_TO# set apprgr = '000' WHERE APPRGR = '   '
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMII_ERR#
     c+ SELECT
     c+ POSTDATE, ENTITY, COUNT_ISO, SKU, APTBZ1, APGLMG, ENTRY#,
     c+ DOCTYPE, DOC, RKREDA, COST_UNIT, RPNESU, RKWACD, APPRGR, DIVISION,
     c+ RKKDNR, KDRBEZ, ALGLMG, ALTENR,custcode,
     c+ char('country code fehlt oder falsch', 130) errormsg
     c+ from tvrelwaeco/RPMII_TO# where COUNT_ISO ='  '
     c/end-exec


     C*Bereinigung Fehler und spezielle Artikel
     c/exec sql
     c+ delete from tvrelwaeco/RPMII_TO#
     c+ where COUNT_ISO ='  '       or division = ' '  or
     c+       altenr    ='8887100008'
     c/end-exec


     C     ##1000        ENDSR

     c**************************************************************************
     C*Bereinigung dollar
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*

     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c
     C                   open      RPMII_TO#
     C                   DO        *HIVAL
     C                   READ      RPMII_TO#                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   if        RKWACD <> 'EUR' and COUNT_ISO <> 'CH'
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C                   movel     '0'           *in95
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        ifeq      'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      RKWACD='EUR'
     c                   eval      rpnesu=(rpnesu*wakurs)
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C                   endif
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C                   close     RPMII_TO#
     C*

     C     ##2000        ENDSR

     c**************************************************************************
     C*Bereinigung dollar
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*

     C                   open      RPMII_TO#
     C                   DO        *HIVAL
     C                   READ      RPMII_TO#                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   if        RKWACD <> 'CHF' and COUNT_ISO = 'CH'
     C                   eval      WAFIRM  = '55'
     C                   eval      WASTWC  = 'CHF'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C                   movel     '0'           *in95
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        ifeq      'CHF'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '55'
     c     WASTWC        orne      'CHF'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      RKWACD='CHF'
     c                   eval      rpnesu=(rpnesu*wakurs)
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C                   endif
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C                   close     RPMII_TO#
     C*

     C     ##3000        ENDSR

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
     c+ select current timestamp, current date, current date -365 day,
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0)
     c+ into   :tstampi, :datum, :datum2, :zeit, :week
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

     c     *DTAARA       DEFINE                  #dayminus         4 0
     c                   IN        #dayminus
     c
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
