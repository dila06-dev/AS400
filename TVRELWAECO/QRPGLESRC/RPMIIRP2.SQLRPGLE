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
      * SELECT RKREDA, count(*) FROM RPMII_TOs WHERE DIVISION not in
      * ('GROUP', 'OTHER','6050') and substr(DOCTYPE, 19, 2) not in
      * ('10','11','12','13', '14','15','16','17','18','19','20','81','82',
      * '83','44', '  ') and APPRGR<'901 ' and APPRGR<>' ' GROUP BY rkreda
      * ORDER BY rkreda
      *
      *
      *c+ where (  (date(substr(char(RKREDA), 1, 4) concat '-'
      *c+           concat substr(char(RKREDA), 5, 2) concat '-'
      *c+           concat substr(char(RKREDA), 7, 2))) =
      *c+                 (current date) - :#dayminus day
      *c+        or
      *c+          (date(substr(char(RKREDA), 1, 4) concat '-'
      *c+           concat substr(char(RKREDA), 5, 2) concat '-'
      *c+           concat substr(char(RKREDA), 7, 2))) in
      *c+           ('04.03.13','11.03.13','18.03.13','25.03.13',
      *c+            '01.04.13','08.04.13','15.04.13'           )   )
      *c+  and alfirm=rpfirm and ALRGJJ=rprgjj and alRGNR=rprgnr
      *c+  and allijj=rplijj and allinr=rplinr and allipo=rplipo
      *
      * SELECT RKKDNR, KDRBEZ ,sku, dec(sum(apglmg), 13, 2) apglmg,
      * dec(sum(rpnesu), 13, 2) rpnesu, char(' ', 15) item FROM
      * tvrelwaeco/RPMII_TO WHERE DIVISION ='GROUP' GROUP BY RKKDNR, KDRBEZ
      * ,sku
      * ==> tvrelwaeco/RPMGROUP
      *
      * update  tvrelwaeco/rpmgroup  set  item        =
      * (select max(artnr)       from bar_kalk/kalk_file2 WHERE
      *         sku  = artbezfra  and version ='$$EL_PS_DB' and
      *                item  =' '   and artbezfra <> ' ' group by artnr)
      * where exists
      * (select max(artnr)       from bar_kalk/kalk_file2 WHERE
      *         sku  = artbezfra  and version ='$$EL_PS_DB' and
      *                item  =' '   and artbezfra <> ' ' group by artnr)
      *
      *
      * update  tvrelwaeco/rpmgroup  set  item        =
      * (select max(artnr)       from bar_kalk/kalk_file2 WHERE
      *         sku  = artsku     and version ='$$EL_PS_DB' and
      *                item  =' '   and artsku    <> ' ' group by artsku   )
      * where exists
      * (select max(artnr)       from bar_kalk/kalk_file2 WHERE
      *         sku  = artsku     and version ='$$EL_PS_DB' and
      *                item  =' '   and artsku    <> ' ' group by artsku   )
      * 153 Zeilen in RPMGROUP in TVRELWAECO aktualisiert.
      *
      *
      * update  tvrelwaeco/RPMGROUP     set  sku         =
      * (select artbezfra   from bar_kalk/kalk_file2 WHERE
      *         sku  = artnr  and version ='$$EL_PS_DB' and
      *                artbezfra         =' '   )
      * where exists
      * (select artbezfra   from bar_kalk/kalk_file2 WHERE
      *         sku  = artnr  and version ='$$EL_PS_DB' and
      *                artbezfra         =' '   )
      *
      *  CHGDTAARA DTAARA(#DAYMINUS *ALL) VALUE(1)
      *
      *  Nachrichtentext der 2. Ebene . .   'SELECT
      * postdate,ENTITY,COUNT_ISO,SKU,APTBZ1
      * ,dec(APGLMG*001, 10, 0) APGLMG,ENTRY#,substr(DOCTYPE, 1, 18)
      * doctype,doc,rkreda,
      *  dec(cost_UNIT*100, 13, 0) cost_UNIT,dec(RPNESU*100, 13, 0)
      * RPNESU,RKWACD,APPRGR
      * ,DIVISION,RKKDNR,KDRBEZ FROM RPMII_TO  WHERE DIVISION not in
      * (''GROUP'', ''OTHER
      * '', ''6050'') and substr(DOCTYPE,  19, 2) not in (''  '',''  '',''
      * '',''  '',
      * ''  '', ''  '', ''  '',''  '',''  '',''  '',''  '',''  '',''  '', ''
      * '',''  '',
      *  ''  '') and APPRGR<''901 '' and APPRGR<>''000 '' and APPRGR<>'' '''
      * ...
      *
      *
      *
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)

     fRPMII_TO  uf   e             disk
     f                                     RENAME(RPMII_TO:phy01r)
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
     c+ insert into tvrelwaeco/RPMII_TO
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
     c+ substr(akafat, 1, 3), 35) doc,                            rkreda,
     c+ decimal(0, 11, 2) cost_unit,RPBRSU rpnesu,RKWACD,APPRGR,
     c+ char('   ', 8) division, RKKDNR,char( ' ', 30) kdrbez,ALGLMG,
     c+ altenr,char('  ', 2) custcode  FROM statistik, #AFLPL1 where
     c+    (year(date(substr(char(RKREDA), 1, 4) concat '-'
     c+       concat substr(char(RKREDA), 5, 2) concat '-'
     c+       concat substr(char(RKREDA), 7, 2))) =
     c+                  year(current date))
     c+  and AKAFAT in ('01 ','02 ','03 ','05 ','06 ','08 ',
     c+                 '25 ','26 ','27 ','28 ',
     c+                 '31 ','55 ',
     c+                 '70 ','71 ')    and rptenr <> '8887100008'
     c+  and (char(RPRGJJ concat '/' concat char(RPRGNR) concat '/' concat
     c+  char(digits(rplijj)) concat '/' concat char(rplinr) concat '/'
     c+  concat char(digits(rplipo)) concat '/' concat
     c+  substr(akafat, 1, 3), 35)
     c+  not in (select doc from #RP0530s))
     c**********+    (rkreda not in (select rkreda from #RP0530s))
     c+  and alfirm=rpfirm and ALRGJJ=rprgjj and alRGNR=rprgnr
     c+  and allijj=rplijj and allinr=rplinr and allipo=rplipo
     c/end-exec

     C*Kostenstelle
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  division      =
     c+ (sELECT max(substr(KDEWKSST, 1, 8))  from kdew     where
     c+ KDEWFIRM in ('01', '51') and  RKKDNR  =  KDEWKDNR   )
     c+ where exists
     c+ (sELECT max(substr(KDEWKSST, 1, 8))  from kdew     where
     c+ KDEWFIRM in ('01', '51') and  RKKDNR  =  KDEWKDNR   )
     c/end-exec

     C*rpm
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set custcode       =
     c+ (sELECT substr(kDEWRPMG, 2, 2)  from kdew     where
     c+ KDEWFIRM in ('01', '51') and  RKKDNR  =  KDEWKDNR   )
     c+ where exists
     c+ (sELECT substr(kDEWRPMG, 2, 2)  from kdew     where
     c+ KDEWFIRM in ('01', '51') and  RKKDNR  =  KDEWKDNR   )
     c/end-exec

     C*Kostenstelle
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  division = case
     c+ When division = '1001    ' then 'RVOEM   '
     c+ When division = '1002    ' then 'RVAM    '
     c+ When division = '1003    ' then 'RETL    '
     c+ When division = '1004    ' then 'LODG    '
     c+ When division = '1005    ' then 'CPVOEM  '
     c+ When division = '1006    ' then 'CPVAM   '
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
     c+ delete from tvrelwaeco/rpmII_TO
     c+ where division='GROUP   '
     c/end-exec


     C*Bezeichnung
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  KDRBEZ        =
     c+ (sELECT KDNAM1                  from kund01   where
     c+ KDFIRM in ('01', '51') and  RKKDNR  =  KDKDNR  )
     c+ where exists
     c+ (sELECT KDNAM1                  from kund01   where
     c+ KDFIRM in ('01', '51') and  RKKDNR  =  KDKDNR  )
     c/end-exec

     C*count_iso
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  COUNT_ISO     =
     c+ (sELECT KDPOLD                  from kund01   where
     c+ KDFIRM in ('01', '51') and  RKKDNR  =  KDKDNR  )
     c+ where exists
     c+ (sELECT KDPOLD                  from kund01   where
     c+ KDFIRM in ('01', '51') and  RKKDNR  =  KDKDNR  )
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/RPMII_TO set COUNT_ISO ='DE' where
     c+                                COUNT_ISO ='  '
     c/end-exec

     C*price
     c*/exec sql
     c*+ update  tvrelwaeco/rpmII_TO  set  COST_UNIT   =
     c*+ (select COSTPRS_AR  from bar_kalk/kalk_file WHERE
     c*+         altenr = artnr  and version ='$$EL_PS_DB')
     c*+ where exists
     c*+ (select COSTPRS_AR  from bar_kalk/kalk_file WHERE
     c*+         altenr = artnr  and version ='$$EL_PS_DB')
     c*/end-exec

     C*price kalkulatorisch
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  COST_UNIT   =
     c+ (select TESTPV      from teil               WHERE
     c+         altenr = TETENR and TEFIRM in ('01', '51'))
     c+ where exists
     c+ (select TESTPV      from teil               WHERE
     c+         altenr = TETENR and TEFIRM in ('01', '51'))
     c/end-exec

     C*neue sku als overwrite
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO   set  sku  =
     c+ (select TEOSMM01   from teos
     c+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c+       ('01','51')  and TEOSMM01 <> ' '    and
     c+                substr(TEOSMM01, 1, 3)<> '001' )
     c+ where exists
     c+ (select TEOSMM01   from teos
     c+  where sku   =TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c+       ('01','51')  and TEOSMM01 <> ' '    and
     c+                substr(TEOSMM01, 1, 3)<> '001' )
     c/end-exec

     C*sku, nur wenn artbezfra nicht gepflegt ist
     C*ohne group wegen performance
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  sku         =
     c+ (select artsku      from bar_kalk/kalk_file2 WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB' and
     c+                artbezfra         =' '   and
     c+                substr(artsku, 1, 3)<> '001'  and
     c+                lieferant1 not in ('90025','90489','90526') and
     c+                DIVISION <> 'GROUP'           )
     c+ where exists
     c+ (select artsku      from bar_kalk/kalk_file2 WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB' and
     c+                artbezfra         =' '   and
     c+                substr(artsku, 1, 3)<> '001'  and
     c+                lieferant1 not in ('90025','90489','90526') and
     c+                DIVISION <> 'GROUP'           )
     c/end-exec

     C*sku, alle, die eine neue Zuordnung erhalten haben
     C*ohne group wegen performance
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  sku         =
     c+ (select artbezfra   from bar_kalk/kalk_file2 WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB' and
     c+                artbezfra        <>' '   and
     c+                substr(artbezfra, 1, 3)<> '001'  and
     c+                lieferant1 not in ('90025','90489','90526') and
     c+                DIVISION <> 'GROUP'           )
     c+ where exists
     c+ (select artbezfra   from bar_kalk/kalk_file2 WHERE
     c+         sku  = artnr  and version ='$$EL_PS_DB' and
     c+                artbezfra        <>' '   and
     c+                substr(artbezfra, 1, 3)<> '001'  and
     c+                lieferant1 not in ('90025','90489','90526') and
     c+                DIVISION <> 'GROUP'           )
     c/end-exec

     C*defa und tracer bleiben als Original erhalten
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  sku = ALTENR
     c+ where altenr in
     c+       (select artnr from bar_kalk/kalk_file2 WHERE
     c+               altenr = artnr  and version ='$$EL_PS_DB' and
     c+               lieferant1 in ('90025','90489','90526'))
     c/end-exec


     C*dometic gruppe
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  APPRGR      =
     c+ (select TEEWPRGR    from  teew01            WHERE
     c+      ALTENR= TEEWTENR and TEEWFIRM in ('01', '51'))
     c+ where exists
     c+ (select TEEWPRGR    from  teew01            WHERE
     c+      ALTENR= TEEWTENR and TEEWFIRM in ('01', '51'))
     c/end-exec

     C*doc_type
     c/exec sql
     c+ update  tvrelwaeco/rpmII_TO  set  doctype  = case
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
     c+ When doctype  = '81      ' then 'Sales CR/Adj Note 81'
     c+ When doctype  = '82      ' then 'Sales CR/Adj Note 82'
     c+ When doctype  = '99      ' then 'Sales CR/Adj Note 99'
     c+ else doctype
     c+ end
     c/end-exec


     c/exec sql
     c+ insert into tvrelwaeco/RPMII_ERR
     c+ SELECT
     c+ POSTDATE, ENTITY, COUNT_ISO, SKU, APTBZ1, APGLMG, ENTRY#,
     c+ DOCTYPE, DOC, RKREDA, COST_UNIT, RPNESU, RKWACD, APPRGR, DIVISION,
     c+ RKKDNR, KDRBEZ, ALGLMG, ALTENR,custcode,
     c+ char('country code fehlt oder falsch', 130) errormsg
     c+ from tvrelwaeco/RPMII_TO where COUNT_ISO ='  '
     c/end-exec


     C*Bereinigung Fehler und spezielle Artikel
     c/exec sql
     c+ delete from tvrelwaeco/RPMII_TO
     c+ where COUNT_ISO ='  '       or
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
     C                   open      RPMII_TO
     C                   DO        *HIVAL
     C                   READ      RPMII_TO                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   if        RKWACD <> 'EUR'
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
     C                   close     RPMII_TO
     C*

     C     ##2000        ENDSR

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
