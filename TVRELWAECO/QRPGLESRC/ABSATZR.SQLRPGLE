     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :insert into tvrelwaeco/statistik   JJ==>OK
      * ==>          :insert into tvrelwaeco/ABSATZ      JJjjmmtt    RKREDA
      * ==>          :insert into tvrelwaeco/ABSATZa1    2011        sel003
      * ==>          :insert into tvrelwaeco/ABSATZa2    JJ==>OK
      * ==>          :insert into tvrelwaeco/ABSATZB     JJjjmmtt    RKREDA
      * ==>          :insert into tvrelwaeco/ABSATZB2    no ==> RPMII
      * ==>          :insert into tvrelwaeco/ABSATZB3    jhjj
      * ==>          :insert into tvrelwaeco/ABSATZB4    jhjj
      * ==>          :insert into tvrelwaeco/ABSATZc     no
      * ==>          :insert into tvrelwaeco/statistik2  2011     book
      * ==>          :insert into tvrelwaeco/LFBEW       JJ==>OK
      * ==>          :insert into tvrelwaeco/LFBEW2      JJ==>OK
      * ==>          :insert into tvrelwaeco/booka1      jjjjmmtt #LBLBBDAT
      * ==>          :insert into tvrelwaeco/booka2      JHJJMM  ==>OK
      * ==>          :insert into tvrelwaeco/booka3      JHJJMM  ==>OK
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
      * SELECT EPLFNR, EPBEJJ, EPBENR, EPBEPO, EPTENR, EPTBZ1, EPMENG,
      * EPBETE, EPGLMG, EPBRMG, EPBEDA, EPBEST, char(' ', 1) kennung FROM
      * statistik2 WHERE EPLFNR ='90139' and ( EPBEDA > 20110000 and EPBEDA
      * < 20110524)
      *
      * Datei T90139 in GANG wurde erstellt.
      *
      * update t90139 set kennung = '1' WHERE EPLFNR in ( select #AELFNR
      * from datenkw/#lblb where EPLFNR=#AELFNR and EPBEJJ=#AEBEJJ and
      * EPBENR=#AEBENR and EPBEPO=#aeBEPO)
      * 80 Zeilen in T90139 in GANG aktualisiert.
      *
      *
      * SELECT * FROM t90139, datenkw/#lblb WHERE EPLFNR=#AELFNR and
      * EPBEJJ=#AEBEJJ and EPBENR=#AEBENR and EPBEPO=#aeBEPO
      * Datei T90139#2 in GANG wurde erstellt.
      *
      *
      *
      * SELECT * FROM absatzb WHERE (APTENR= 'MSH-50' or APTENR=
      * '9105300006') and substr(RKREDA, 1, 6) = '201102' and APKDNR =
      * '020812'
      *
      * Lieferbedingungen: wo
      * SELECT * FROM statistik, afad WHERE AKAFNN = 925336 and
      * akaFNR = AdAFNR and ADAART ='ADVS' and AKAFJJ = ADAFJJ
      *
      * SELECT ARTNR, char((char(artsku) concat '     '), 15),
      *    char(' ', 10)               , current date , current
      * timestamp,char(' ', 256), current date, current timestamp FROM
      * bar_kalk/kalk_file WHERE (version = '$$EL_PS_DB' and anldat >
      * 20121200) and ARTBEZFRA = ' '
      * Teildatei SKUTRANSF in Datei SKUTRANSF in TVRELWAECO wurde ersetzt.
      *
      * insert into tvrelwaeco/albersvj
      * SELECT APKDNR,KDNAM1,KDNAM2,KDSTRA,KDPOLD,KDPOLZ,KDWORT ,APTENR,
      * APTBZ1,APKDNR,KGR,APPRGR, dec( (jana+feba+ MAEA+ APRA+ MAIA+
      * JUNA+ JULA+ AUGA+ SEPA+ OKTA+ NOVA+ DEZA ), 13, 0) ab, dec(
      * (janu+febu+ MAEu+ APRu+ MAIu+ JUNu+ JULu+ AUGu+ SEPu+ OKTu+ NOVu+
      * DEZu ), 13, 0) um FROM
      *
      *                         ABSATZBVJ , kund01 WHERE apprgr='106'
      * and  aptenr in (SELECT artnr
      *           FROM bar_kalk/kalk_file WHERE version='$$EL_PS_DB' and
      *           artbez not like('%Schutzhaube%')   and
      *   statnr='106' and (( lieferant1 ='90862' or lieferant2 ='90862')
      *                or  ( lieferant1 ='92434' or lieferant2 ='92434')))
      *  and
      * APKDNR=KDKDNR and kdfirm in ('01', '51')    ORDER BY APKDNR, APTENR
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fabsatz    uf   e             disk
     f                                     RENAME(absatz:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fabsatzb   uf   e             disk
     f                                     RENAME(absatzb:phy02r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fbooka3    uf   e             disk
     f                                     RENAME(booka3:phy03r)
     f***                                  INFDS(DSF2)
     F                                     USROPN
     fwaeh01    if   e           k disk
     fekbestand if   e           k disk
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
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C     *DTAARA       DEFINE                  ABSATZR          10
     C     *lock         IN        ABSATZR
     C                   movel     absatzr       #AB              10
     C                   clear                   ABSATZR
     C                   out       ABSATZR

     C*Absatz/Umsatzdaten
     c                   if        #ab =*blank or #ab ='SR1000'
     c                   exsr      sr1000
     c                   endif
     C*Katalogdaten
     c                   if        #ab =*blank or #ab ='SR2000'
     c********           exsr      sr2000
     c                   endif
     C*Einkaufsdaten/Bestellwesen
     c                   if        #ab =*blank or #ab ='SR3000'
     c*******            exsr      sr3000
     c                   endif
     C*Einkaufsdaten/Bestellwesen Book
     c                   if        #ab =*blank or #ab ='SR4000'
     c******             exsr      sr4000
     c                   endif
     C*Albers
     c                   if        #ab =*blank or #ab ='SR5000'
     c                   exsr      sr5000
     c                   endif
     C*Transportbereiche Test hier UK
     c                   if        #ab =*blank or #ab ='SR40631'
     c***********        exsr      sr40631
     c                   endif
     C*Transportbereiche Test hier Italien
     c                   if        #ab =*blank or #ab ='SR55278'
     c***********        exsr      sr55278
     c                   endif
     C*Transportbereiche Test hier Schweden
     c                   if        #ab =*blank or #ab ='SR08138'
     c***********        exsr      sr08138
     c                   endif
     C*QM_Management Web Applikation
     c                   if        #ab =*blank or #ab ='SR11000'
     c*******            exsr      sr11000
     c                   endif

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Aufbau aller Sätze mit Status erledigt (Positionen auf 90)
     c/exec sql
     c+ insert into tvrelwaeco/statistik
     c+ SELECT * FROM afko, afpo, afrp, afrk WHERE
     c+ AKFIRM=apFIRM and AKAFJJ=apAFJJ and AKAFNN=apAFNN and
     c+ RPFIRM=aPFIRM and RPAFJJ=aPAFJJ and RPAFNR=aPAFNR and RPAFPO=aPAFPO
     c+ and
     c+ RKFIRM=RpFIRM and RKRGJJ=RpRGJJ and RKRGNR=RpRGNR and RKLIJJ=RpLIJJ
     c+ and
     c+ RKLINR=RpLINR
     c+            and apAFST = '90' and (APFIRM in ('01','51') and AKWKNR
     c+                                  ='001')
     c+                              and RKRGJJ > 2022
     c/end-exec

     C*Korrketur auf Menge, hier dürfen keine Mengen in die Statistik
     c/exec sql
     c+ update statistik set APGLMG = apglmg * 0
     c+ where APAFAT In ('  ', '05', '70')
     c/end-exec


     C*Korrketur auf Menge, negative Mengen für Statistik
     c/exec sql
     c+ update statistik set APGLMG = apglmg * -1
     c+ where APAFAT In ('50', '71', '14', '82')
     c/end-exec

     C*Korrketur Fehlmengenauslieferung
     c/exec sql
     c+ update statistik set apglmg =
     c+ (SELECT                 alglmg  FROM aflp WHERE apafnr=
     c+ alafnr and aptenr= altenr and apafjj= ALAFJJ and apafpo=ALAFPO and
     c+ rplijj=allijj and rplinr=ALLINR and rplipo=ALLIPO and rprgjj=ALRGJJ
     c+ and rprgnr = ALRGNR and apglmg<>alglmg and apglmg >0 and alglmg >0
     c+ and aflp.alfirm in ('01', '51'))
     c+ where exists
     c+ (SELECT                 alglmg  FROM aflp WHERE apafnr=
     c+ alafnr and aptenr= altenr and apafjj= ALAFJJ and apafpo=ALAFPO and
     c+ rplijj=allijj and rplinr=ALLINR and rplipo=ALLIPO and rprgjj=ALRGJJ
     c+ and rprgnr = ALRGNR and apglmg<>alglmg and apglmg >0 and alglmg >0
     c+ and aflp.alfirm in ('01', '51'))
     c/end-exec

      *#####################################################################
      *1. Ableitung ==> tvrelwaeco/ABSATZ
      *#####################################################################
     C*mit Filter ohne Divisor = 0, keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZ
     c+ SELECT APAFAT,RKREDA,RKWACD, APTENR ,APGLMG , RPNESU, RPBRSU,
     c+ RPERG1, RPERG2, RPERG3, RPERG4, RKERG1 z1, RKERG2 z2, RKERG3
     c+ z3,rKERG4 z4, RKMWS1, RKWAWT,
     c+ dec((RKERG1*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11, 2)
     c+ za1, dec((RKERG2*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11,
     c+ 2) za2 , dec((RKERG3*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za4,
     c+ zoned(00000000, 8, 0) wagada, zoned(00000000, 11, 6) wakurs
     c+ FROM statistik
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) <> 0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec

     C*mit Filter mit Divisor = 0 ( mathematisch /1 )
     C*                           keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZ
     c+ SELECT APAFAT,RKREDA,RKWACD, APTENR ,APGLMG , RPNESU, RPBRSU,
     c+ RPERG1, RPERG2, RPERG3, RPERG4, RKERG1 z1, RKERG2 z2, RKERG3
     c+ z3,rKERG4 z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/1), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/1), 11, 2) za2, dec((RKERG3*RPBRSU/1), 11, 2)
     c+ za3, dec((RKERG4*RPBRSU/1), 11, 2) za4,
     c+ zoned(00000000, 8, 0) wagada, zoned(00000000, 11, 6) wakurs
     c+ FROM statistik
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) =  0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '82', '17', '18', '20')
     c/end-exec

     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c
     C                   open      absatz
     C                   DO        *HIVAL
     C                   READ      absatz                                 95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        andne     'EUR'
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
     c                   eval      wagada    =   wagada
     c                   eval      wakurs    =   wakuvk
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C                   close     absatz

     C*Ableitung tvrelwaeco/ABSATZa1 aus tvrelwaeco/ABSATZ
     C*GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4)  J a h r e s w e r t
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZa1
     c+ SELECT APAFAT,APTENR, substr(RKREDA, 1, 4),
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
     c+ FROM absatz
     c+ GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4)
     c/end-exec

     C*Ableitung tvrelwaeco/ABSATZa1 aus tvrelwaeco/ABSATZ
     C*GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4)  M o n a t s w e r t e
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZa2
     c+ SELECT APAFAT,APTENR, substr(RKREDA, 1, 4) JJJJ,
     c+        substr(RKREDA, 5, 2) MM,
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
     c+ FROM absatz
     c+ GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4), substr(RKREDA, 5, 2)
     c/end-exec

     C*Übernahme der Absätze in die Bar_kalk/kalk_file Jahreswert
     c/exec sql
     c+ update  bar_kalk/kalk_file set  KCJMNG_AJ =
     c+ (sELECT sum(APGLMG) from absatza1
     c+ where SEL0003=year(current date)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c+ where exists
     c+ (sELECT sum(APGLMG) from absatza1
     c+ where SEL0003=year(current date)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c/end-exec

     C*Übernahme der Umsätze in die Bar_kalk/kalk_file Jahreswerte
     c/exec sql
     c+ update  bar_kalk/kalk_file set  KCJUMS_AJ =
     c+ (sELECT sum(RPNESU+RPERG1+RPERG2+RPERG3+RPERG4+ZA1+ZA2+ZA3+ZA4)
     c+         from absatza1 where SEL0003=year(current date)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c+ where exists
     c+ (sELECT sum(RPNESU+RPERG1+RPERG2+RPERG3+RPERG4+ZA1+ZA2+ZA3+ZA4)
     c+         from absatza1 where SEL0003=year(current date)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c/end-exec

     C*Übernahme der Absätze in die Bar_kalk/kalk_file VorJahreswert
     c/exec sql
     c+ update  bar_kalk/kalk_file set  KCJMNG_VJ =
     c+ (sELECT sum(APGLMG) from absatza1
     c+ where SEL0003=year(current date -1 year)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c+ where exists
     c+ (sELECT sum(APGLMG) from absatza1
     c+ where SEL0003=year(current date -1 year)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c/end-exec

     C*Übernahme der Umsätze in die Bar_kalk/kalk_file Jahreswerte
     c/exec sql
     c+ update  bar_kalk/kalk_file set  KCJUMS_VJ =
     c+ (sELECT sum(RPNESU+RPERG1+RPERG2+RPERG3+RPERG4+ZA1+ZA2+ZA3+ZA4)
     c+         from absatza1 where SEL0003=year(current date -1 year)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c+ where exists
     c+ (sELECT sum(RPNESU+RPERG1+RPERG2+RPERG3+RPERG4+ZA1+ZA2+ZA3+ZA4)
     c+         from absatza1 where SEL0003=year(current date -1 year)
     c+ and artnr=APTENR  and "VERSION" = '$$EL_PS_DB' and APAFAT <>'yy'
     c+ group by aptenr)
     c/end-exec

     C*Übernahme der Umsätze in die Bar_kalk/kalk_file Jahreswerte
     c/exec sql
     c+ update  bar_kalk/kalk_file       set  liefnr      =
     c+ (select TEEWPRGR    from  teew  WHERE version='$$EL_PS_DB' and
     c+      artnr = TEEWTENR and TEEWFIRM in ('01', '51'))
     c+ where exists
     c+ (select TEEWPRGR    from  teew  WHERE version='$$EL_PS_DB' and
     c+      artnr = TEEWTENR and TEEWFIRM in ('01', '51'))
     c/end-exec

      *#####################################################################
      *SELECT WAOFKAJJ, WAOFKANR, WAOFVEUR, WAOFWF10 FROM waof WHERE
      *(WAOFKANR =903194 or WAOFKANR =903195) and WAOFKAJJ=2012 and
      *(WAOFFIRM='01' or WAOFFIRM='51')
      *Datei KALKBASEI in TVRELWAECO wurde erstellt.
      *..
      *SELECT VSKAJJ, VSKANR, VSVEUR, VSRANG, VSRSAT, VSUFLD, VSRAWT FROM
      *kvks WHERE vsufld='VKWF10' and vskanr= 902450
      *Datei Y in QTEMP wurde erstellt.
      *
      *SELECT * FROM bar_kalk/kalk_file, waof WHERE version = '$$EL_PS_DB'
      *and KALK_FILE.ARTNR = WAOF.WAOFVEUR and (WAOFKAJJ concat '/' concat
      *WAOFKANR) = buchung2
      *Datei PHILIP in TVRELWAECO wurde ersetzt.
      * ...... neu
      * SELECT JAHR, LIEFNR, ARTNR, ARTBEZ, ARTGRP, KALK_FILE.STATNR, ABC,
      * KALK_FILE.KSCHEMA, ULAND, KALK_FILE.LIEFERANT1, LIEFERANT2,
      * KALK_FILE.ZOLLNR, ARTZ1, KALK_FILE.ARTZ2, ARTZ3, WACDVK, WACDEK,
      * WEKPR, DATUMV, FRACHTSATZ, FRACHT, ZOLLSATZ, ZOLL, VERSICHERU,
      * KCJUMS_VJ, KCJUMS_AJ, ANLDAT, STK_LCP_A, WAOFVEUR, WAOFWF01,
      * WAOFWF02, WAOFWF03, WAOFWF04, WAOFWF05, WAOFWF06, WAOFWF07,
      * WAOFWF09, WAOFWF16, WAOFWF11, WAOFWF12, WAOFWF13,
      * WAOFWF14, WAOFWF17 FROM
      * bar_kalk/kalk_file, waof WHERE version = '$$EL_PS_DB' and ARTNR =
      * WAOFVEUR and (WAOFKAJJ concat '/' concat WAOFKANR) = buchung2
      * Datei KALKBASE in TVRELWAECO wurde ersetzt.
      *
      *update bar_kalk/kalk_file a set b005      =
      *(select lpmibm     from lpif
      * where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
      *        and (LPFIRM ='01' or LPFIRM ='51')
      *        where exists
      *(select lpmibm     from lpif
      * where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
      *        and (LPFIRM ='01' or LPFIRM ='51')
      *34148 Zeilen in KALK_FILE in BAR_KALK aktualisiert.
      *
      *
      *#####################################################################
     C*Übernahme der Umsätze in die Bar_kalk/kalk_file Jahreswerte
     c/exec sql
     c+ update bar_kalk/kalk_file a set buchung2   =
     c+  (select WAOFKAJJ concat '/' concat WAOFKANR from KALKBASEI
     c+        where artnr = WAOFVEUR  and version='$$EL_PS_DB')
     c+          where exists
     c+  (select WAOFKAJJ concat '/' concat WAOFKANR from KALKBASEI
     c+        where artnr = WAOFVEUR  and version='$$EL_PS_DB')
     c/end-exec

     C*Übernahme der Umsätze in die Bar_kalk/kalk_file Jahreswerte
     c/exec sql
     c+ update bar_kalk/kalk_file a set MARGE_NEU1 =
     c+  (select waofwf10*1 from KALKBASEI
     c+        where artnr = WAOFVEUR  and version='$$EL_PS_DB')
     c+          where exists
     c+  (select waofwf10*1 from KALKBASEI
     c+        where artnr = WAOFVEUR  and version='$$EL_PS_DB')
     c/end-exec

     C*Artsku
     C*23.02.2013  updaten zentrale Stelle mit Meldung   #job
     c/exec sql
     c+ update bar_kalk/kalk_file a set artbezfra  =
     c+ (select distinct TEOSMM01   from teos
     c+  where artnr=TEOSTENR and teosklcd='SKU 'and version='$$EL_PS_DB'
     c+         and TEOSFIRM in ('01','51'))
     c+         where exists
     c+ (select distinct TEOSMM01   from teos
     c+  where artnr=TEOSTENR and teosklcd='SKU 'and version='$$EL_PS_DB'
     c+         and TEOSFIRM in ('01','51'))
     c/end-exec

     c/exec sql
     c+ update bar_kalk/kalk_file a set b005      = 0
     c/end-exec

     C*Mindestbestellmenge updaten
     c/exec sql
     c+ update bar_kalk/kalk_file a set b005      =
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c+  where exists
     c+ (select lpmibm     from lpif
     c+  where artnr=lptenr and lieferant1=LPLFNR  and version='$$EL_PS_DB'
     c+                     and lpstat <> '90' and LPFIRM in ('01', '51'))
     c/end-exec

     C*Mindestbestellmenge updaten
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

     C*Sicherheitsbestand  updaten
     c/exec sql
     c+ update bar_kalk/kalk_file a set ##ART290  =
     c+ (select tesibe     from teil
     c+  where artnr=tetenr  and version='$$EL_PS_DB'
     c+                      and tefirm in ('01', '51'))
     c+  where exists
     c+ (select tesibe     from teil
     c+  where artnr=tetenr  and version='$$EL_PS_DB'
     c+                      and tefirm in ('01', '51'))
     c/end-exec


      *#####################################################################
      *2. Ableitung ==> tvrelwaeco/ABSATZB
      *#####################################################################
     C*mit Filter ohne Divisor = 0, keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB
     c+ SELECT APAFAT,RKREDA,RKWACD,APTENR,APGLMG,RPNESU,RPBRSU,
     c+ RPERG1,RPERG2,RPERG3,RPERG4,RKERG1 z1, RKERG2 z2, RKERG3 z3,rKERG4
     c+ z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11, 2)
     c+ za2 , dec((RKERG3*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za4, zoned(00000000, 8, 0) wagada,
     c+ zoned(00000000, 11, 6) wakurs,akprio,AKVSBD,AKLIBD,RKZABD,RKVALT,
     c+ rkvada,APKDNR,APSTKD,apWACD,APKDGR,APVTN1,APVTN2,APVTN3,APKOKZ,
     c+ APKSTC,APSPTE,APKURS,APPRGR,APLANR,APTBZ1,APTBZ2,char(' ', 60) st,
     c+ dec(rrn(statistik), 16, 0) RRN, current timestamp ts,
     c+ dec(0, 13, 2) JanA,dec(0, 13, 2) FEBA,dec(0, 13, 2) MAEA,
     c+ dec(0, 13, 2) APRA,dec(0, 13, 2) MaiA,dec(0, 13, 2) junA,
     c+ dec(0, 13, 2) JulA,dec(0, 13, 2) augA,dec(0, 13, 2) sepA,
     c+ dec(0, 13, 2) oktA,dec(0, 13, 2) novA,dec(0, 13, 2) dezA,
     c+ dec(0, 13, 2) Janu,dec(0, 13, 2) FEBu,dec(0, 13, 2) MAEu,
     c+ dec(0, 13, 2) APRu,dec(0, 13, 2) Maiu,dec(0, 13, 2) junu,
     c+ dec(0, 13, 2) Julu,dec(0, 13, 2) augu,dec(0, 13, 2) sepu,
     c+ dec(0, 13, 2) oktu,dec(0, 13, 2) novu,dec(0, 13, 2) dezu
     c+ FROM statistik
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) <> 0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec

     C*mit Filter mit Divisor = 0 ( mathematisch /1 )
     C*                           keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB
     c+ SELECT APAFAT,RKREDA,RKWACD,APTENR,APGLMG,RPNESU,RPBRSU,
     c+ RPERG1,RPERG2,RPERG3,RPERG4,RKERG1 z1, RKERG2 z2, RKERG3 z3,rKERG4
     c+ z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/(1
     c+              )), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/(1                                  )), 11, 2)
     c+ za2 , dec((RKERG3*RPBRSU/(1                                  )),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(1
     c+              )), 11, 2) za4, zoned(00000000, 8, 0) wagada,
     c+ zoned(00000000, 11, 6) wakurs,akprio,AKVSBD,AKLIBD,RKZABD,RKVALT,
     c+ rkvada,APKDNR,APSTKD,apWACD,APKDGR,APVTN1,APVTN2,APVTN3,APKOKZ,
     c+ APKSTC,APSPTE,APKURS,APPRGR,APLANR,APTBZ1,APTBZ2,char(' ', 60) st,
     c+ dec(rrn(statistik), 16, 0) RRN, current timestamp ts,
     c+ dec(0, 13, 2) JanA,dec(0, 13, 2) FEBA,dec(0, 13, 2) MAEA,
     c+ dec(0, 13, 2) APRA,dec(0, 13, 2) MaiA,dec(0, 13, 2) junA,
     c+ dec(0, 13, 2) JulA,dec(0, 13, 2) augA,dec(0, 13, 2) sepA,
     c+ dec(0, 13, 2) oktA,dec(0, 13, 2) novA,dec(0, 13, 2) dezA,
     c+ dec(0, 13, 2) Janu,dec(0, 13, 2) FEBu,dec(0, 13, 2) MAEu,
     c+ dec(0, 13, 2) APRu,dec(0, 13, 2) Maiu,dec(0, 13, 2) junu,
     c+ dec(0, 13, 2) Julu,dec(0, 13, 2) augu,dec(0, 13, 2) sepu,
     c+ dec(0, 13, 2) oktu,dec(0, 13, 2) novu,dec(0, 13, 2) dezu
     c+ FROM statistik
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) =  0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec
     C
     C                   open      absatzb
     C                   DO        *HIVAL
     C                   READ      absatzb                                95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C     KEY001        SETgt     WAEH01                             95
     C     *IN95         IFEQ      '0'
     C     RKWACD        andne     'EUR'
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
     c                   eval      wagada    =   wagada
     c                   eval      wakurs    =   wakuvk
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C                   endif
     C
     c                   endif
     c                   exsr      sr8000
     c                   update    phy02r
     c                   enddo
     C                   close     absatzb
     C
     C*
     C*                           Gruppierung  tvrelwaeco/ABSATZB2
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB2
     c+ SELECT APTENR,APTBZ1,APKDNR,
     c+        char(substr(APKSTC, 1, 1), 1) kgr, APPRGR,
     c+ dec(sum(JANA), 13, 2) jana, dec(sum(febA), 13, 2) feba,
     c+ dec(sum(maeA), 13, 2) maea, dec(sum(aprA), 13, 2) apra,
     c+ dec(sum(maiA), 13, 2) maia, dec(sum(junA), 13, 2) juna,
     c+ dec(sum(julA), 13, 2) jula, dec(sum(augA), 13, 2) auga,
     c+ dec(sum(sepA), 13, 2) sepa, dec(sum(oktA), 13, 2) okta,
     c+ dec(sum(novA), 13, 2) nova, dec(sum(dezA), 13, 2) deza,
     c+ dec(sum(janU), 13, 2) janU, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeU), 13, 2) maeU, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiU), 13, 2) maiU, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julU), 13, 2) julU, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepU), 13, 2) sepU, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novU), 13, 2) novU, dec(sum(dezu), 13, 2) dezu,
     c+ current timestamp ts, dec(count(*), 10) anzahl
     c+ FROM absatzb
     c+ GROUP BY APTENR,APTBZ1,APKDNR,
     c+          char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*
     C*             ohne kunde    Gruppierung  tvrelwaeco/ABSATZc
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZc
     c+ SELECT APTENR,APTBZ1,APPRGR,
     c+ dec(sum(JANA), 13, 0) jana, dec(sum(feba),
     c+ 13, 0) feba, dec(sum(MAEA), 13, 0) MAEA, dec(sum(APRA), 13, 0)
     c+ APRA, dec(sum(MAIA), 13, 0) MAIA, dec(sum(JUNA), 13, 0) JUNA,
     c+ dec(sum(JUlA), 13, 0) JUlA, dec(sum(auga), 13, 0) auga,
     c+ dec(sum(sepa), 13, 0) sepa, dec(sum(okta), 13, 0) okta,
     c+ dec(sum(nova), 13, 0) nova, dec(sum(deza), 13, 0) deza,
     c+ dec(sum(JANu), 13, 2) janu, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeu), 13, 2) maeu, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiu), 13, 2) maiu, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julu), 13, 2) julu, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepu), 13, 2) sepu, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novu), 13, 2) novu, dec(sum(dezu), 13, 2) dezu,
     c+ dec(sum(anzahl), 13, 0) anzahl, ts FROM absatzb2 GROUP BY
     c+ APTENR,APTBZ1,APPRGR,ts
     c/end-exec
     C
     C*  __________jahresbezogene Werte_01__akt year__________
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB2II
     c+ SELECT APTENR,APTBZ1,APKDNR,
     c+        char(substr(APKSTC, 1, 1), 1) kgr, APPRGR,
     c+ dec(sum(JANA), 13, 2) jana, dec(sum(febA), 13, 2) feba,
     c+ dec(sum(maeA), 13, 2) maea, dec(sum(aprA), 13, 2) apra,
     c+ dec(sum(maiA), 13, 2) maia, dec(sum(junA), 13, 2) juna,
     c+ dec(sum(julA), 13, 2) jula, dec(sum(augA), 13, 2) auga,
     c+ dec(sum(sepA), 13, 2) sepa, dec(sum(oktA), 13, 2) okta,
     c+ dec(sum(novA), 13, 2) nova, dec(sum(dezA), 13, 2) deza,
     c+ dec(sum(janU), 13, 2) janU, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeU), 13, 2) maeU, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiU), 13, 2) maiU, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julU), 13, 2) julU, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepU), 13, 2) sepU, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novU), 13, 2) novU, dec(sum(dezu), 13, 2) dezu,
     c+ current timestamp ts, dec(count(*), 10) anzahl
     c+ FROM absatzb
     c+ where
     c+ year(date(substr(char(rkreda), 1, 4) concat '-' concat
     c+      substr(char(rkreda), 5, 2) concat '-' concat
     c+      substr(char(rkreda), 7, 2) )) =year(current date)
     c+ GROUP BY APTENR,APTBZ1,APKDNR,
     c+          char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*
     C*             ___________________02
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZcII
     c+ SELECT APTENR,APTBZ1,APPRGR,
     c+ dec(sum(JANA), 13, 0) jana, dec(sum(feba),
     c+ 13, 0) feba, dec(sum(MAEA), 13, 0) MAEA, dec(sum(APRA), 13, 0)
     c+ APRA, dec(sum(MAIA), 13, 0) MAIA, dec(sum(JUNA), 13, 0) JUNA,
     c+ dec(sum(JUlA), 13, 0) JUlA, dec(sum(auga), 13, 0) auga,
     c+ dec(sum(sepa), 13, 0) sepa, dec(sum(okta), 13, 0) okta,
     c+ dec(sum(nova), 13, 0) nova, dec(sum(deza), 13, 0) deza,
     c+ dec(sum(JANu), 13, 2) janu, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeu), 13, 2) maeu, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiu), 13, 2) maiu, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julu), 13, 2) julu, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepu), 13, 2) sepu, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novu), 13, 2) novu, dec(sum(dezu), 13, 2) dezu,
     c+ dec(sum(anzahl), 13, 0) anzahl, ts FROM ABSATZB2II GROUP BY
     c+ APTENR,APTBZ1,APPRGR,ts
     c/end-exec
     C
     C*SELECT APKDNR,KDNAM1,KDNAM2,KDSTRA,KDPOLD,KDPOLZ,KDWORT ,APTENR,
     C*APTBZ1,APKDNR,KGR,APPRGR, dec( (jana+feba+ MAEA+ APRA+ MAIA+
     C*JUNA+ JULA+ AUGA+ SEPA+ OKTA+ NOVA+ DEZA ), 13, 0) ab, dec(
     C*(janu+febu+ MAEu+ APRu+ MAIu+ JUNu+ JULu+ AUGu+ SEPu+ OKTu+ NOVu+
     C*DEZu ), 13, 0) um FROM
     C*                        ABSATZBVJ,
     C*                                    kund01 WHERE aptenr in
     C*('8885200089', '8885200092', '8885200094', '8885200095',
     C*'8885200096',  '8885200063/AU', '8885200080/AU',
     C*'8885200097', '8885200099', '8885200063', '8885200099',
     C*'8885200063', '8885200063/IT', '8885200072', '8885200074',
     C*'8885200075', '8885200076', '8885200076/IT', '8885200078',
     C*'8885200080/IT', '8885200085', '8885200080', '8885200087',
     C*'8885200097/IT', 'VAS 6381/10A ', 'VAS 6381A ', '81342147235',
     C*'8885200107   ', '8885200102   ', 'VAS 6744 ', '81342147235/SE',
     C*'8885200103   ', '8885200104   ', '8885200106', '8885200107',
     C*'8885200116   ', '8885200117   ', '8885200118', '8885200119',
     C*'8885200120   ', 'VAS 6380B    ', 'VAS 6381B ', 'VAS 6746A  ',
     C*'8885200254   ', '8885200255   ', '8885200106', '8885200107',
     C*'8885200109   ', 'VAS 6746     ', '8885200106', 'VAS 6380/10A MX',
     C*'9103301815   ', '9103301819   ', '9103301826', '9103301829     ',
     C*'9103301830   ', '9103301831   ', '9103301832', '9103301835     ',
     C*'9103301830   ', '8885200110   ', '8885200113', '8885200114     ',
     C*'8885200115   ', '8885200265   ', '9103301824', '9103301834     ',
     C*'81342286807 ', '81432286324',
     C*'82643     ', 'VAS 6380/10A ', 'VAS 6380A ', '8885200076/ECO') and
     C*APKDNR=KDKDNR and kdfirm in ('01', '51')    ORDER BY APKDNR, APTENR
     C*Datei ALBERSVJ in TVRELWAECO wurde ersetzt.
     C*             insert into tvrelwaeco/albersvj    !!!!!!!!! zum anfang
     C*     ===>    FROM ABSATZBVJ                     !!!!!!!!!
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZBVJ
     c+ SELECT APTENR,APTBZ1,APKDNR,
     c+        char(substr(APKSTC, 1, 1), 1) kgr, APPRGR,
     c+ dec(sum(JANA), 13, 2) jana, dec(sum(febA), 13, 2) feba,
     c+ dec(sum(maeA), 13, 2) maea, dec(sum(aprA), 13, 2) apra,
     c+ dec(sum(maiA), 13, 2) maia, dec(sum(junA), 13, 2) juna,
     c+ dec(sum(julA), 13, 2) jula, dec(sum(augA), 13, 2) auga,
     c+ dec(sum(sepA), 13, 2) sepa, dec(sum(oktA), 13, 2) okta,
     c+ dec(sum(novA), 13, 2) nova, dec(sum(dezA), 13, 2) deza,
     c+ dec(sum(janU), 13, 2) janU, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeU), 13, 2) maeU, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiU), 13, 2) maiU, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julU), 13, 2) julU, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepU), 13, 2) sepU, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novU), 13, 2) novU, dec(sum(dezu), 13, 2) dezu,
     c+ current timestamp ts, dec(count(*), 10) anzahl
     c+ FROM absatzb
     c+ WHERE substr(char(rkreda), 1, 4)=char(year(current date -1 year))
     c+ GROUP BY APTENR,APTBZ1,APKDNR,
     c+          char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*
     C*             ohne kunde    Gruppierung  tvrelwaeco/ABSATZc
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZcvj
     c+ SELECT APTENR,APTBZ1,APPRGR,
     c+ dec(sum(JANA), 13, 0) jana, dec(sum(feba),
     c+ 13, 0) feba, dec(sum(MAEA), 13, 0) MAEA, dec(sum(APRA), 13, 0)
     c+ APRA, dec(sum(MAIA), 13, 0) MAIA, dec(sum(JUNA), 13, 0) JUNA,
     c+ dec(sum(JUlA), 13, 0) JUlA, dec(sum(auga), 13, 0) auga,
     c+ dec(sum(sepa), 13, 0) sepa, dec(sum(okta), 13, 0) okta,
     c+ dec(sum(nova), 13, 0) nova, dec(sum(deza), 13, 0) deza,
     c+ dec(sum(JANu), 13, 2) janu, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeu), 13, 2) maeu, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiu), 13, 2) maiu, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julu), 13, 2) julu, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepu), 13, 2) sepu, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novu), 13, 2) novu, dec(sum(dezu), 13, 2) dezu,
     c+ dec(sum(anzahl), 13, 0) anzahl, ts FROM ABSATZBvj  GROUP BY
     c+ APTENR,APTBZ1,APPRGR,ts
     c/end-exec
     C
     C*             __aktjahr__________03
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZBaj
     c+ SELECT APTENR,APTBZ1,APKDNR,
     c+        char(substr(APKSTC, 1, 1), 1) kgr, APPRGR,
     c+ dec(sum(JANA), 13, 2) jana, dec(sum(febA), 13, 2) feba,
     c+ dec(sum(maeA), 13, 2) maea, dec(sum(aprA), 13, 2) apra,
     c+ dec(sum(maiA), 13, 2) maia, dec(sum(junA), 13, 2) juna,
     c+ dec(sum(julA), 13, 2) jula, dec(sum(augA), 13, 2) auga,
     c+ dec(sum(sepA), 13, 2) sepa, dec(sum(oktA), 13, 2) okta,
     c+ dec(sum(novA), 13, 2) nova, dec(sum(dezA), 13, 2) deza,
     c+ dec(sum(janU), 13, 2) janU, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeU), 13, 2) maeU, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiU), 13, 2) maiU, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julU), 13, 2) julU, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepU), 13, 2) sepU, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novU), 13, 2) novU, dec(sum(dezu), 13, 2) dezu,
     c+ current timestamp ts, dec(count(*), 10) anzahl
     c+ FROM absatzb
     c+ WHERE substr(char(rkreda), 1, 4)=char(year(current date -0 year))
     c+ GROUP BY APTENR,APTBZ1,APKDNR,
     c+          char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*
     C*             ohne kunde    Gruppierung  tvrelwaeco/ABSATZc
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZcaj
     c+ SELECT APTENR,APTBZ1,APPRGR,
     c+ dec(sum(JANA), 13, 0) jana, dec(sum(feba),
     c+ 13, 0) feba, dec(sum(MAEA), 13, 0) MAEA, dec(sum(APRA), 13, 0)
     c+ APRA, dec(sum(MAIA), 13, 0) MAIA, dec(sum(JUNA), 13, 0) JUNA,
     c+ dec(sum(JUlA), 13, 0) JUlA, dec(sum(auga), 13, 0) auga,
     c+ dec(sum(sepa), 13, 0) sepa, dec(sum(okta), 13, 0) okta,
     c+ dec(sum(nova), 13, 0) nova, dec(sum(deza), 13, 0) deza,
     c+ dec(sum(JANu), 13, 2) janu, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeu), 13, 2) maeu, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiu), 13, 2) maiu, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julu), 13, 2) julu, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepu), 13, 2) sepu, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novu), 13, 2) novu, dec(sum(dezu), 13, 2) dezu,
     c+ dec(sum(anzahl), 13, 0) anzahl, ts FROM ABSATZBaj  GROUP BY
     c+ APTENR,APTBZ1,APPRGR,ts
     c/end-exec
     C
     C*  _____________________________________________________
     C
     C*                           Gruppierung  tvrelwaeco/ABSATZB3
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB3
     c+ SELECT APTENR,APTBZ1,APKDNR, substr(char(RKREDA) , 1, 4) jahr,
     c+ char(substr(APKSTC, 1, 1), 1) kgr, APPRGR, dec(sum(JANA), 13, 2)
     c+ jana, dec(sum(febA), 13, 2) feba, dec(sum(maeA), 13, 2) maea,
     c+ dec(sum(aprA), 13, 2) apra, dec(sum(maiA), 13, 2) maia,
     c+ dec(sum(junA), 13, 2) juna, dec(sum(julA), 13, 2) jula,
     c+ dec(sum(augA), 13, 2) auga, dec(sum(sepA), 13, 2) sepa,
     c+ dec(sum(oktA), 13, 2) okta, dec(sum(novA), 13, 2) nova,
     c+ dec(sum(dezA), 13, 2) deza, dec(sum(janU), 13, 2) janU,
     c+ dec(sum(febu), 13, 2) febu, dec(sum(maeU), 13, 2) maeU,
     c+ dec(sum(apru), 13, 2) apru, dec(sum(maiU), 13, 2) maiU,
     c+ dec(sum(junu), 13, 2) junu, dec(sum(julU), 13, 2) julU,
     c+ dec(sum(augu), 13, 2) augu, dec(sum(sepU), 13, 2) sepU,
     c+ dec(sum(oktu), 13, 2) oktu, dec(sum(novU), 13, 2) novU,
     c+ dec(sum(dezu), 13, 2) dezu, current timestamp ts, dec(count(*), 10)
     c+ anzahl FROM absatzb GROUP BY APTENR,APTBZ1,APKDNR,
     c+ substr(char(RKREDA), 1, 4) ,char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*                           Gruppierung  tvrelwaeco/ABSATZB4
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB4
     c+ SELECT apkdnr,aptenr,jahr,        dec(
     c+ sum(jana+feba+MAEA+apra+maia+juna+jula+auga+sepa+okta+nova+ deza ),
     c+ 13, 2) qu, dec(
     c+ sum(janu+febu+MAEu+apru+maiu+junu+julu+augu+sepu+oktu+novu+ dezu ),
     c+ 13, 2) to FROM absatzb3           GROUP BY apkdnr,aptenr,jahr
     c/end-exec
     C
     C*
     C
     C     ##1000        ENDSR

     C**************************************************************************
     C*Katalogdaten
     C*update teil00 set tevikz = 'J'
     C*
     C*update teil00 set tevikz = 'J' where tetenr in (select
     C*substr(kataloge.artnr, 1, 15) from kataloge)
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Katalog MSAA       -01-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10        =
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and  MSAA =
     c+ '1' and     "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and  MSAA =
     c+ '1' and     "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog OTRA       -02-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 1) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ otra = '1' and      "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ otra = '1' and      "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog MKAB       -03-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 2) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+  MKAB = '1' and       "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+  MKAB = '1' and       "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog MF         -04-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 3) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ MF   = '1' and       "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ MF   = '1' and       "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog GKFZB      -05-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 4) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ GKFZB = '1' and  "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ GKFZB = '1' and  "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog BT         -06-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 5) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ BT    = '1' and   "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ BT    = '1' and   "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog DIVFRIGO   -07-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 6) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ DIVFRIGO='1' and    "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ DIVFRIGO='1' and    "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog MINIBUS    -08-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 7) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and MINIBUS
     c+  ='1' and       "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and MINIBUS
     c+  ='1' and       "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog DEFA       -09-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 8) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ DEFA    ='1' and    "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ DEFA    ='1' and    "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog OETEILE    -10-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 9) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ OETEILE ='1' and       "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr = artnr and
     c+ OETEILE ='1' and       "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Katalog KLIMATEILE -11-
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  a.e10  = substr(e10, 1, 10) concat
     c+ (sELECT '1' from gang/kataloge where a.artnr=artnr and KLIMATEILE=
     c+ '1' and "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from gang/kataloge where a.artnr=artnr and KLIMATEILE=
     c+ '1' and "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C*Teil update Kennzeichen Katalog
     c***/exec sql
     c***+ update teil set TEVIKZ = 'N'
     c***/end-exec
     C
     c/exec sql
     c+ update bar_kalk/kalk_file set preiskdu='N'
     c+ where  "VERSION"='$$EL_PS_DB'
     c/end-exec
     C

     C*Katalog Anpassung in teil
     c***/exec sql
     c***+ update teil  set TEVIKZ =
     c***+ (sELECT 'J' from gang/kataloge where artnr=TETENR and
     c***+  PREISKDU='1')
     c***+  where exists
     c***+ (sELECT 'J' from gang/kataloge where artnr=TETENR and
     c***+  PREISKDU='1')
     c***/end-exec
     C
     C*Katalog Anpassung in bar_kalk/kalk_file
     c/exec sql
     c+ update  bar_kalk/kalk_file a set  preiskdu =
     c+ (sELECT '1' from gang/kataloge where a.artnr=artnr and
     c+ PREISKDU  ='1' and   "VERSION"= '$$EL_PS_DB')
     c+  where exists
     c+ (sELECT '1' from kataloge where a.artnr=artnr and PREISKDU  ='1' and
     c+  PREISKDU  ='1' and   "VERSION"= '$$EL_PS_DB')
     c/end-exec
     C

     C     ##2000        ENDSR

     C
     C**************************************************************************
     C*Einkaufsdaten/Bestellwesen
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C
     c/exec sql
     c+ whenever not found goto ##3000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Aufbau aller Sätze statusunabhängig
     C*25.08.2020 alle routinen auf Kommentar!!!!!!!!!!!!!!!!
     c***/exec sql
     c***+ insert into tvrelwaeco/statistik2
     c***+ SELECT * FROM bbek, bbep
     c***+ WHERE EKFIRM = EPFIRM and EKBEJJ = EpBEJJ and
     c***+       EKBENR = EPBENR and EKBEJJ > 2009 and epfirm in ('01', '51')
     c***/end-exec

     c***/exec sql
     c***+ insert into tvrelwaeco/LFBEW
     c***+ SELECT * FROM tvrelwaeco/statistik2 a, datenkw/#LBLBL2 WHERE
     c***+ A.EPBEJJ= #AEBEJJ and A.EPBENR= #AEBENR and A.EPBEPO= #AEBEPO
     c***/end-exec
     C
     c***/exec sql
     c***+ insert into tvrelwaeco/LFBEW2
     c***+ SELECT EKLFNR, EKBEJJ, EKBENN, EKBEAT, EKSABE, EKWACD, EKBEDA,
     c***+ EKBER1, EKBER2, EKVSBD, EKLIBD, EKZABD, EKBEST, EKVADA, EKBAST,
     c***+ EPBEPO, EPVSBD, EPLIBD, EPZABD, EPVPEI, EPBEAT, EPSABE, EPANJJ,
     c***+ EPANNR, EPBEST, EPBEAR, EPWACD, EPABDA, EPABNR, EPLFSB, EPTENR,
     c***+ EPMENG, EPBETE, EPBEJK, EPBETA, EPTBZ1, EPMEIN, EPMEPR, EPGLMG,
     c***+ EPBRMG, EPPRAR, EPPREI, EPNESU, EPBEDA, EPDAMA, EPDAER,
     c***+ EPDAAB,#LBLBBDAT, #LBLBBWMG, #LBLBBWME FROM tvrelwaeco/LFBEW
     c***/end-exec
     C
     C     ##3000        ENDSR
     C*

     C**************************************************************************
     C*Einkaufsdaten/Bestellwesen
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C
     c/exec sql
     c+ whenever not found goto ##4000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Aufbau aller Sätze Zwischendatei hier Filter TVRELWAECO/BOOKA1
     c/exec sql
     c+ insert into tvrelwaeco/booka1
     c+ SELECT #LBLBTENR, #LBLBLANR, #LBLBBWMG, #LBLBBDAT, #LBLBDAKY
     c+ from datenkw/#lblb
     c+ WHERE #LBLBLANR in ('002', '200', '300')
     c+ and #LBLBLSTC in ('130', '810')
     c+ and char(substr(char(current date, eur), 7, 4))
     c+     = substr(#LBLBBDAT, 1, 4)
     c/end-exec
     C
     C*Aufbau aller Sätze statusunabhängig Gruppembildung TVRELWAECO/BOOKA2
     c/exec sql
     c+ insert into tvrelwaeco/booka2
     c+ SELECT #LBLBTENR, #LBLBLANR, char(substr(#LBLBBDAT, 1, 6)) JHJJMM,
     c+ dec(sum(#LBLBBWMG), 13, 2) menge
     c+ FROM booka1 GROUP BY #LBLBTENR,
     c+ #LBLBLANR, char(substr(#LBLBBDAT, 1, 6))
     c/end-exec
     C
     C*Aufbau aller Sätze statusunabhängig Gruppembildung TVRELWAECO/BOOKA3
     c/exec sql
     c+ insert into tvrelwaeco/booka3
     c+ SELECT #TESAAV,#TEDIAV,ARTGRP,STATNR,LIEFERANT1,ARTNR,ARTBEZ,ABC,E1,
     c+ E2,#LBLBLANR,JHJJMM,MENGE,STK_LCP,current timestamp ts,
     c+ dec(0, 13, 2) JanA1,dec(0, 13, 2) FEBA1,dec(0, 13, 2) MAEA1,
     c+ dec(0, 13, 2) APRA1,dec(0, 13, 2) MaiA1,dec(0, 13, 2) junA1,
     c+ dec(0, 13, 2) JulA1,dec(0, 13, 2) augA1,dec(0, 13, 2) sepA1,
     c+ dec(0, 13, 2) oktA1,dec(0, 13, 2) novA1,dec(0, 13, 2) dezA1,
     c+ dec(0, 13, 2) JanA2,dec(0, 13, 2) FEBA2,dec(0, 13, 2) MAEA2,
     c+ dec(0, 13, 2) APRA2,dec(0, 13, 2) MaiA2,dec(0, 13, 2) junA2,
     c+ dec(0, 13, 2) JulA2,dec(0, 13, 2) augA2,dec(0, 13, 2) sepA2,
     c+ dec(0, 13, 2) oktA2,dec(0, 13, 2) novA2,dec(0, 13, 2) dezA2,
     c+ dec(0, 13, 2) JanA3,dec(0, 13, 2) FEBA3,dec(0, 13, 2) MAEA3,
     c+ dec(0, 13, 2) APRA3,dec(0, 13, 2) MaiA3,dec(0, 13, 2) junA3,
     c+ dec(0, 13, 2) JulA3,dec(0, 13, 2) augA3,dec(0, 13, 2) sepA3,
     c+ dec(0, 13, 2) oktA3,dec(0, 13, 2) novA3,dec(0, 13, 2) dezA3,
     c+ dec(0, 13, 2) au, dec(0, 13, 2) aures,
     c+ dec(0, 13, 2) bst1,dec(0, 13, 2) bst2,dec(0, 13, 2) bst3,
     c+ dec(0, 13, 2) ob
     c+ from bar_kalk/kalk_file, booka2
     c+ WHERE ARTNR = #LBLBTENR and version = '$$EL_PS_DB' and
     c+ statnr in ('105', '106', '190', '196', '197', '198', '199', '201',
     c+ '203', '204', '207', '208', '209', '210', '211', '212', '290',
     c+ '299', '339', '341', '695')
     c/end-exec
     C
     C                   open      booka3
     C                   DO        *HIVAL
     C                   READ      booka3                                 95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   endif
     c                   exsr      sr8100
     c
     c                   movel     '001'         lager
     c                   exsr      sr8200
     c                   z-add     BESTAND       bst1
     c     aures         add       reserv        aures
     c
     c                   movel     '100'         lager
     c                   exsr      sr8200
     c                   z-add     BESTAND       bst2
     c     aures         add       reserv        aures
     c
     c                   movel     '500'         lager
     c                   exsr      sr8200
     c                   z-add     BESTAND       bst3
     c     aures         add       reserv        aures
     c
     c                   update    phy03r
     c                   enddo
     C                   close     booka3
     C
     C     ##4000        ENDSR
     C*

     C**************************************************************************
     C*Einkaufsdaten/Bestellwesen
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C
     c/exec sql
     c+ whenever not found goto ##5000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Aufbau aller Sätze Zwischendatei hier Filter  a l t
     c*exec sql
     c* insert into tvrelwaeco/albers
     c* SELECT APKDNR,KDNAM1,KDNAM2,KDSTRA,KDPOLD,KDPOLZ,KDWORT ,APTENR,
     c* APTBZ1,APKDNR,KGR,APPRGR, dec( (jana+feba+ MAEA+ APRA+ MAIA+
     c* JUNA+ JULA+ AUGA+ SEPA+ OKTA+ NOVA+ DEZA ), 13, 0) ab, dec(
     c* (janu+febu+ MAEu+ APRu+ MAIu+ JUNu+ JULu+ AUGu+ SEPu+ OKTu+ NOVu+
     c* DEZu ), 13, 0) um FROM  ABSATZB2II, kund01 WHERE apprgr='106'
     c* and  aptenr in (SELECT artnr
     c*           FROM bar_kalk/kalk_file WHERE version='$$EL_PS_DB' and
     c*           artbez not like('%Schutzhaube%')   and
     c*   statnr='106' and (( lieferant1 ='90862' or lieferant2 ='90862')
     c*                or  ( lieferant1 ='92434' or lieferant2 ='92434')))
     c*  and
     c* APKDNR=KDKDNR and kdfirm in ('01', '51')    ORDER BY APKDNR, APTENR
     c*end-exec
     C
     C
     C
     C*Aufbau aller Sätze Zwischendatei hier Filter TVRELWAECO/BOOKA1
     c/exec sql
     c+ insert into tvrelwaeco/albers
     c+ SELECT APKDNR,KDNAM1,KDNAM2,KDSTRA,KDPOLD,KDPOLZ,KDWORT ,APTENR,
     c+ APTBZ1,APKDNR,KGR,APPRGR,       jana,feba, MAEA, APRA, MAIA,
     c+ JUNA, JULA, AUGA, SEPA, OKTA, NOVA, DEZA         ,
     c+  janu,febu, MAEu, APRu, MAIu, JUNu, JULu, AUGu, SEPu, OKTu, NOVu,
     c+ DEZu              FROM  ABSATZB2II, kund01 WHERE apprgr='106'
     c+ and  aptenr in (SELECT artnr
     c+           FROM bar_kalk/kalk_file WHERE version='$$EL_PS_DB' and
     c+           artbez not like('%Schutzhaube%')   and
     c+   statnr='106' and (( lieferant1 ='90862' or lieferant2 ='90862')
     c+                or  ( lieferant1 ='92434' or lieferant2 ='92434')))
     c+  and
     c+ APKDNR=KDKDNR and kdfirm in ('01', '51')    ORDER BY APKDNR, APTENR
     c/end-exec
     C
     C
     C     ##5000        ENDSR
     C*

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR

     C                   movel     rkreda        #rkreda           8
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA = JANA + (APGLMG)
     c                   eval      JANU = JANU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA = FEBA + (APGLMG)
     c                   eval      FEBU = FEBU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA = MAEA + (APGLMG)
     c                   eval      MAEU = MAEU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA = APRA + (APGLMG)
     c                   eval      APRU = APRU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA = MAIA + (APGLMG)
     c                   eval      MAIU = MAIU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA = JUNA + (APGLMG)
     c                   eval      JUNU = JUNU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA = JULA + (APGLMG)
     c                   eval      JULU = JULU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA = AUGA + (APGLMG)
     c                   eval      AUGU = AUGU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA = SEPA + (APGLMG)
     c                   eval      SEPU = SEPU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA = OKTA + (APGLMG)
     c                   eval      OKTU = OKTU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA = NOVA + (APGLMG)
     c                   eval      NOVU = NOVU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA = DEZA + (APGLMG)
     c                   eval      DEZU = DEZU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     c                   other
     c                   endsl

     C     ##8000        ENDSR

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8100        BEGSR

     C                   movel     JHJJMM        #rkreda           8
     C                   if        #LBLBLANR  = '002'
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA1= JANA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA1= FEBA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA1= MAEA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA1= APRA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA1= MAIA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA1= JUNA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA1= JULA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA1= AUGA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA1= SEPA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA1= OKTA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA1= NOVA1+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA1= DEZA1+ (menge)
     c                   other
     c                   endsl
     C                   endif
     C
     C                   if        #LBLBLANR  = '200'
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA2= JANA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA2= FEBA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA2= MAEA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA2= APRA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA2= MAIA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA2= JUNA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA2= JULA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA2= AUGA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA2= SEPA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA2= OKTA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA2= NOVA2+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA2= DEZA2+ (menge)
     c                   other
     c                   endsl
     C                   endif
     C
     C                   if        #LBLBLANR  = '300'
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA3= JANA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA3= FEBA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA3= MAEA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA3= APRA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA3= MAIA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA3= JUNA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA3= JULA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA3= AUGA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA3= SEPA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA3= OKTA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA3= NOVA3+ (menge)
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA3= DEZA3+ (menge)
     c                   other
     c                   endsl
     C                   endif

     C     ##8100        ENDSR

     C**************************************************************************
     C*Einkauf Lager
     C*-------------------------------------------------------------------------
     C*
     C     sr8200        BEGSR

     C*                 lesen bestand
     c     key8200       klist
     c                   kfld                    ARTNR
     c                   kfld                    LAGER

     c     key8200       chain     ekbestand                          93
     c   93              clear                   BESTAND
     c   93              clear                   reserv

     C     ##8200        ENDSR

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
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C*uk 40631
     C*-------------------------------------------------------------------------
     C*
     C     sr40631       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##40631
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*                 Steuerdatei Inhalte aus afkm und afvs
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4500'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#AFKM40631'  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD      '  REPADD           10
     C                   clear                   md
     C*
     C*                 zu hohe Anzahl an feldern
     c/exec sql
     c+ insert into tvrelwaeco/#dc4501
     c+ SELECT * FROM afkm a, afvs b, afsp c, aflp d, #afkm40631 e where
     c+ status =  ' '  and e.AMFIRM = a.AMFIRM and e.AMkmjj = a.AMkmjj and
     c+ e.AMKMNR = a.AMKMNR and e.AVDPDN =b.AVDPDN and a.AMKMJJ=AvKMJJ and
     c+ a.AMKMNR=AvKMNR and A.AMFIRM=B.AVFIRM and ASJAHR=a.AMKMJJ AND
     c+ ASNUMM=a.AMKMNR and a.AMKMJJ = ALKMJJ AND a.AMKMNR = ALKMNR and
     c+ a.Amfirm in ('01', '51') and d.alfirm in ('01', '51')
     c/end-exec
     C
     C*                 Steuerdatei statusänderung
     C***                clear                   md
     C***                CALL      'DUMMY512'
     C***                PARM                    MD
     C***                PARM      '#DC4502'     MSG               7
     C***                PARM      *blank        MSGF             10
     C***                PARM      *BLANK        PRINT            10
     C***                PARM      *BLANK        OUTFIL           10
     C***                PARM      *BLANK        LIB              10
     C***                PARM      *BLANK        REPADD           10
     C***                clear                   md
     C*
     C*                 Ausgabe vorab
     C*                 WHERE AVDPDN = '10406315716541'
     C*
     c

     C     ##40631       ENDSR

     C**************************************************************************
     C*italien 55278
     C*-------------------------------------------------------------------------
     C*
     C     sr55278       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##55278
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*                 Steuerdatei Inhalte aus afkm und afvs
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4511'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#AFKM55278'  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD      '  REPADD           10
     C                   clear                   md
     C*
     C*                 zu hohe Anzahl an feldern
     c/exec sql
     c+ insert into tvrelwaeco/#dc4512
     c+ SELECT * FROM afkm a, afvs b, afsp c, aflp d, #afkm55278 e where
     c+ status =  ' '  and e.AMFIRM = a.AMFIRM and e.AMkmjj = a.AMkmjj and
     c+ e.AMKMNR = a.AMKMNR and e.AVDPDN =b.AVDPDN and a.AMKMJJ=AvKMJJ and
     c+ a.AMKMNR=AvKMNR and A.AMFIRM=B.AVFIRM and ASJAHR=a.AMKMJJ AND
     c+ ASNUMM=a.AMKMNR and a.AMKMJJ = ALKMJJ AND a.AMKMNR = ALKMNR and
     c+ a.Amfirm in ('01', '51') and d.alfirm in ('01', '51')
     c/end-exec
     C
     C*                 Steuerdatei statusänderung
     C***                clear                   md
     C***                CALL      'DUMMY512'
     C***                PARM                    MD
     C***                PARM      '#DC4502'     MSG               7
     C***                PARM      *blank        MSGF             10
     C***                PARM      *BLANK        PRINT            10
     C***                PARM      *BLANK        OUTFIL           10
     C***                PARM      *BLANK        LIB              10
     C***                PARM      *BLANK        REPADD           10
     C***                clear                   md
     C*
     C*                 Ausgabe vorab
     C*                 WHERE AVDPDN = '10406315716541'
     C*
     c/exec sql
     c+ insert into tvrelwaeco/scairo
     c+ SELECT AMKMJJ,AMKMNR,AMKMDA,AMKDNR,AMVSBD,AMLIBD,AMLIAR,AMKOKZ,
     c+ AMNAM1,AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c+ AMLFTE,AVGWBR,AVTENR,AVKDLI,AVDPDN,ASSPED,ASAFJJ,ASAFNR,ASKMDA,
     c+ ALMAAF,ALTENR,ALTBZ1,ALWAWT,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,
     c+ ALKMPO,ALLIJJ,ALLINR,ALLIPO,#TSTAMP,AVKMPO,AVANZA,AVGWNT,AVVOLU,
     c+ aVDSKZ,AVPAKN,ALGLMG,date('01/01/1950') l060, char(' ') l070,
     c+ timestamp('1950-01-01-00.00.00.000000') l190  from #DC4512
     c+ group by
     c+        AMKMJJ,AMKMNR,AMKMDA,AMKDNR,AMVSBD,AMLIBD,AMLIAR,AMKOKZ,
     c+ AMNAM1,AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c+ AMLFTE,AVGWBR,AVTENR,AVKDLI,AVDPDN,ASSPED,ASAFJJ,ASAFNR,ASKMDA,
     c+ ALMAAF,ALTENR,ALTBZ1,ALWAWT,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,
     c+ ALKMPO,ALLIJJ,ALLINR,ALLIPO,#TSTAMP,AVKMPO,AVANZA,AVGWNT,AVVOLU,
     c+ aVDSKZ,AVPAKN,ALGLMG
     c/end-exec
     C
     c/exec sql
     c+ insert into tvrelwaeco/#helpit
     c+ SELECT AMKMJJ, AMKMNR, AMKMDA, AMKDNR, AMVSBD, AMLIBD, AMLIAR,
     c+ AMKOKZ, AMNAM1, AMNAM2, AMNAM3, AMSTRA, AMPOLD, AMPOLZ, AMWORT,
     c+ AMPOFA, AMLAND, AMLFTE, AVGWBR, AVTENR, AVKDLI, AVDPDN, ASSPED,
     c+ ASAFJJ, ASAFNR, ASKMDA, ALMAAF, ALTENR, ALTBZ1, ALWAWT, ALAFJJ,
     c+ ALAFNR, ALAFPO, ALKMJJ, ALKMNR, ALKMPO, ALLIJJ, ALLINR, ALLIPO,
     c+ #TSTAMP, AVKMPO, AVANZA, AVGWNT, AVVOLU, AVDSKZ,ALGLMG,
     c+ AVPAKN,scairo.L060, scairo.L070, scairo.L190, L010, L020, L030,
     c+ L040, L050, orderl.L060, orderl.L070, L080, L090, L100, L110, L120,
     c+ L130, L140, L150, L160, L170, L180, orderl.L190, L200, L210, L220,
     c+ L230, L240, L250, L990, rrn(orderl) FROM scairo,orderl WHERE L250 =
     c+ 55278 and ALTENR = l080 and almaaf like '%' concat trim
     c+ (substr("L040", 2, 8)) concat '%' and almaaf <> ' ' and l040 <> ' '
     c/end-exec
     C
     c/exec sql
     c+ update tvrelwaeco/scairo a set a.l060 =
     c+ (select max(b.L06001) from #helpit b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L06001) from #helpit b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c/exec sql
     c+ update tvrelwaeco/scairo a set a.l070 =
     c+ (select max(b.L07001) from #helpit b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L07001) from #helpuk b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c/exec sql
     c+ update tvrelwaeco/scairo a set a.l190 =
     c+ (select max(b.L19001) from #helpuk b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L19001) from #helpuk b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c*/exec sql
     c*+ insert into tvrelwaeco/deliv_it_a
     c*+ SELECT DISTINCT ALMAAF, ALTENR,ALGLMG,L060,L070,L190,AMNAM1,
     c*+ AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c*+ AMLFTE,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,ALKMPO,ASKMDA
     c*+ ,ALLIJJ,ALLINR,ALLIPO,ALWAWT,ASSPED ,AVPAKN, AVDPDN FROM scairo
     c*+ WHERE
     c*+ ASKMDA <> 0 and (date(substr(char(ASKMDA), 1, 4) concat '-'
     c*+ concat substr(char(ASKMDA), 5, 2) concat '-' concat
     c*+ substr(char(ASKMDA), 7, 2) )) = current date - 1 day
     c*/end-exec
     c
     c*/exec sql
     c*+ insert into tvrelwaeco/deliv_it
     c*+ SELECT DISTINCT ALMAAF, ALTENR,ALGLMG,L060,L070,AMLFTE,ASKMDA,
     c*+ ALWAWT,ASSPED FROM scairo a               WHERE
     c*+     ASKMDA <> 0 and (date(substr(char(ASKMDA), 1, 4) concat '-'
     c*+ concat substr(char(ASKMDA), 5, 2) concat '-' concat
     c*+ substr(char(ASKMDA), 7, 2) )) = current date - 1 day
     c*/end-exec
     c
     c

     C     ##55278       ENDSR

     C**************************************************************************
     C*schweden 08138
     C*-------------------------------------------------------------------------
     C*
     C     sr08138       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##08138
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*                 Steuerdatei Inhalte aus afkm und afvs
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC4510'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#AFKM08138'  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD      '  REPADD           10
     C                   clear                   md
     C*
     C*                 zu hohe Anzahl an feldern
     c/exec sql
     c+ insert into tvrelwaeco/#dc4511
     c+ SELECT * FROM afkm a, afvs b, afsp c, aflp d, #afkm08138 e where
     c+ status =  ' '  and e.AMFIRM = a.AMFIRM and e.AMkmjj = a.AMkmjj and
     c+ e.AMKMNR = a.AMKMNR and e.AVDPDN =b.AVDPDN and a.AMKMJJ=AvKMJJ and
     c+ a.AMKMNR=AvKMNR and A.AMFIRM=B.AVFIRM and ASJAHR=a.AMKMJJ AND
     c+ ASNUMM=a.AMKMNR and a.AMKMJJ = ALKMJJ AND a.AMKMNR = ALKMNR and
     c+ a.Amfirm in ('01', '51') and d.alfirm in ('01', '51')
     c/end-exec
     C
     C*                 Steuerdatei statusänderung
     C***                clear                   md
     C***                CALL      'DUMMY512'
     C***                PARM                    MD
     C***                PARM      '#DC4502'     MSG               7
     C***                PARM      *blank        MSGF             10
     C***                PARM      *BLANK        PRINT            10
     C***                PARM      *BLANK        OUTFIL           10
     C***                PARM      *BLANK        LIB              10
     C***                PARM      *BLANK        REPADD           10
     C***                clear                   md
     C*
     C*                 Ausgabe vorab
     C*                 WHERE AVDPDN = '10406315716541'
     C*
     c/exec sql
     c+ insert into tvrelwaeco/ingemar
     c+ SELECT AMKMJJ,AMKMNR,AMKMDA,AMKDNR,AMVSBD,AMLIBD,AMLIAR,AMKOKZ,
     c+ AMNAM1,AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c+ AMLFTE,AVGWBR,AVTENR,AVKDLI,AVDPDN,ASSPED,ASAFJJ,ASAFNR,ASKMDA,
     c+ ALMAAF,ALTENR,ALTBZ1,ALWAWT,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,
     c+ ALKMPO,ALLIJJ,ALLINR,ALLIPO,#TSTAMP,AVKMPO,AVANZA,AVGWNT,AVVOLU,
     c+ aVDSKZ,AVPAKN,ALGLMG,date('01/01/1950') l060, char(' ') l070,
     c+ timestamp('1950-01-01-00.00.00.000000') l190  from #DC4511
     c+ group by
     c+        AMKMJJ,AMKMNR,AMKMDA,AMKDNR,AMVSBD,AMLIBD,AMLIAR,AMKOKZ,
     c+ AMNAM1,AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c+ AMLFTE,AVGWBR,AVTENR,AVKDLI,AVDPDN,ASSPED,ASAFJJ,ASAFNR,ASKMDA,
     c+ ALMAAF,ALTENR,ALTBZ1,ALWAWT,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,
     c+ ALKMPO,ALLIJJ,ALLINR,ALLIPO,#TSTAMP,AVKMPO,AVANZA,AVGWNT,AVVOLU,
     c+ aVDSKZ,AVPAKN,ALGLMG
     c/end-exec
     C
     c/exec sql
     c+ insert into tvrelwaeco/#helpSE
     c+ SELECT AMKMJJ, AMKMNR, AMKMDA, AMKDNR, AMVSBD, AMLIBD, AMLIAR,
     c+ AMKOKZ, AMNAM1, AMNAM2, AMNAM3, AMSTRA, AMPOLD, AMPOLZ, AMWORT,
     c+ AMPOFA, AMLAND, AMLFTE, AVGWBR, AVTENR, AVKDLI, AVDPDN, ASSPED,
     c+ ASAFJJ, ASAFNR, ASKMDA, ALMAAF, ALTENR, ALTBZ1, ALWAWT, ALAFJJ,
     c+ ALAFNR, ALAFPO, ALKMJJ, ALKMNR, ALKMPO, ALLIJJ, ALLINR, ALLIPO,
     c+ #TSTAMP, AVKMPO, AVANZA, AVGWNT, AVVOLU, AVDSKZ,ALGLMG,
     c+ AVPAKN,ingemar.L060, ingemar.L070, ingemar.L190, L010, L020, L030,
     c+ L040, L050, orderl.L060, orderl.L070, L080, L090, L100, L110, L120,
     c+ L130, L140, L150, L160, L170, L180, orderl.L190, L200, L210, L220,
     c+ L230, L240, L250, L990, rrn(orderl) FROM ingemar,orderl WHERE L250 =
     c+ 08138 and ALTENR = l080 and almaaf like '%' concat trim
     c+ (substr("L040", 2, 8)) concat '%' and almaaf <> ' ' and l040 <> ' '
     c/end-exec
     C
     c/exec sql
     c+ update tvrelwaeco/ingemar a set a.l060 =
     c+ (select max(b.L06001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L06001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c/exec sql
     c+ update tvrelwaeco/ingemar a set a.l070 =
     c+ (select max(b.L07001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L07001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c/exec sql
     c+ update tvrelwaeco/ingemar a set a.l190 =
     c+ (select max(b.L19001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c+   where exists
     c+ (select max(b.L19001) from #helpse b where a.alafjj = alafjj and
     c+ a.alafnr = alafnr and  a.alafpo = alafpo and  a.alkmjj = alkmjj and
     c+ a.alkmpo = alkmpo and  a.allijj = allijj and  a.allinr = allinr and
     c+ a.allipo = allipo and  a.avkmpo = avkmpo and  a.almaaf = almaaf and
     c+ a.altenr = altenr group by  alafjj,alafnr,alafpo,alkmjj,alkmpo,
     c+ allijj,allinr,allipo,avkmpo,almaaf,altenr)
     c/end-exec
     c
     c*/exec sql
     c*+ insert into tvrelwaeco/deliv_se_a
     c*+ SELECT DISTINCT ALMAAF, ALTENR,ALGLMG,L060,L070,L190,AMNAM1,
     c*+ AMNAM2,AMNAM3,AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,
     c*+ AMLFTE,ALAFJJ,ALAFNR,ALAFPO,ALKMJJ,ALKMNR,ALKMPO,ASKMDA
     c*+ ,ALLIJJ,ALLINR,ALLIPO,ALWAWT,ASSPED ,AVPAKN, AVDPDN FROM ingemar
     c*+ WHERE
     c*+ ASKMDA <> 0 and (date(substr(char(ASKMDA), 1, 4) concat '-'
     c*+ concat substr(char(ASKMDA), 5, 2) concat '-' concat
     c*+ substr(char(ASKMDA), 7, 2) )) = current date - 1 day
     c*/end-exec
     c
     c*/exec sql
     c*+ insert into tvrelwaeco/deliv_se
     c*+ SELECT DISTINCT ALMAAF, ALTENR,ALGLMG,L060,L070,AMLFTE,ASKMDA,
     c*+ ALWAWT,ASSPED FROM ingemar a              WHERE
     c*+     ASKMDA <> 0 and (date(substr(char(ASKMDA), 1, 4) concat '-'
     c*+ concat substr(char(ASKMDA), 5, 2) concat '-' concat
     c*+ substr(char(ASKMDA), 7, 2) )) = current date - 1 day
     c*/end-exec
     c

     C     ##08138       ENDSR

     C**************************************************************************
     C*Sonderdatei Kappen
     C*-------------------------------------------------------------------------
     C*
     C     sr11000       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##11000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     C*                 zu hohe Anzahl an feldern
     c/exec sql
     c+ insert into tvrelwaeco/#QUALITY
     c+ SELECT AKUSER, AKFIRM, AKAFNR, AKKDNR, AKAFAT, AKREF1, AKREF2,
     c+ AKMAAF, AKVPEI, AKKDGR, AKSABE, APVSNR, APAFNR, APAFPO, APPREI,
     c+ APLFDR, RPRGNR, RPUSER, RPAFNR, RKFIRM, RKRGNR, AKAFNN FROM
     c+ statistik WHERE AKAFAT = '82'
     c/end-exec
     C
     c/exec sql
     c+ insert into tvrelwaeco/#QUALITYc
     c+ SELECT aKUSER, AKFIRM, AKAFNR, AKKDNR, AKAFAT, AKREF1, AKREF2,
     c+ AKMAAF, AKVPEI, AKKDGR, AKSABE, APVSNR, APAFNR, APAFPO, APPREI,
     c+ APLFDR, RPRGNR, RPUSER, RPAFNR, RKFIRM, RKRGNR, AKAFNN,
     c+ KUND01.KDNAM1, KUND01.KDNAM2, KUND01.KDNAM3, KUND01.KDSTRA,
     c+ KUND01.KDPOLD, KUND01.KDPOLZ, KUND01.KDWORT, KUND01.KDPOFA,
     c+ char(' ', 01) bezahlt  FROM
     c+ #quality, kund01 WHERE #QUALITY.AKKDNR= KUND01.KDKDNR and
     c+ kdfirm in ('01', '51')
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/kappen1
     c+ SELECT * FROM datenkw/#lblb WHERE #LBLBTENR ='4445900200' and
     c+ #LBLBLSTC = '130' or #LBLBLSTC ='140'
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/kappen2
     c+ seLECT #LBLBTENR, #LBLBBDAT, AKAFJJ, #LBLBBZEI, AKAFNN, #LBLBBWMG,
     c+ AKAFNR, #LBLBBWME, AKKDNR, AKREF1, AKBEDA, KUND01.KDKDNR,
     c+ KUND01.KDKDST, KUND01.KDNAM1, KUND01.KDNAM2, KUND01.KDNAM3,
     c+ KUND01.KDSTRA, KUND01.KDPOLD, KUND01.KDPOLZ, KUND01.KDWORT,
     c+ KUND01.KDPOFA, KUND01.KDTLNR FROM kappen1, afko, kund01 WHERE
     c+ substr(#LBLBDAKY, 1, 4) = akAFJJ and substr(#LBLBDAKY, 5, 6) =
     c+ akAFNR and #LBLBFIRM = AKFIRM and akkdnr = KDKDNR  and
     c+ akfirm in ('01', '51') and kdfirm in ('01', '51')
     c/end-exec

     C     ##11000       ENDSR

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
