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
      * SELECT RPMUPLDTE, RPMFOO, RPMUPLENT, RPMCOO, RPMSKU, RPMSC,
      * RPMPRCQTY, RPMPRCUNT, RPMCOM, RPMSTK3, RPMWHG, RPMGUEVON,
      * RPMGUEBIS, RPMBRAND, RPMREPORT, RPMTMP, ULAND, lIEFERANT1,
      * LIEFERANT2 , artnr, artsku, artbezfra, char(' ', 035) lief1,
      * char(' ', 035) lief2 FROM TVRELWAECO/RPMIIUPLOD ,
      * bar_kalk/kalk_file WHERE RPMFOO ='DE411' and (RPMSKU = artsku or
      * RPMSKU = artsku or RPMSKU = artbezfra) and version='$$EL_PS_DB'
      * Datei RPMIICHECK in TVRELWAECO wurde ersetzt.
      * and artsku not in (select RPMSKU from tvrelwaeco/RPMII)
      *
      * update        RPMIICHECK   set lief1 =
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant1 and lffirm='01')
      * where exists
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant1 and lffirm='01')
      *
      * update        RPMIICHECK   set lief2 =
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant2 and lffirm='01')
      * where exists
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant2 and lffirm='01')
      *
      * update        RPMIICHECK
      * set lieferant2 =' ' where lieferant1=lieferant2
      * 1489 Zeilen in RPMIICHECK in TVRELWAECO aktualisiert.
      * update        RPMIICHECK
      * set lief2      =' ' where lief1     =lief2
      * 1489 Zeilen in RPMIICHECK in TVRELWAECO aktualisiert.
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      * Achtung für stk3 upload = uploadstk ='1' sonst kein upload
      * Achtung, da Uneinigkeit besteht, wer der Eigner des Artikels
      *          ist, wird vorrrangig unterstellt, doppelte Eigner
      *          werden als Priorität der Lokalität DE411 zugeordnet.
      *****************************************************************
     hALWNULL(*USRCTL)

     fRPMKALKUL uf   e             disk    RENAME(RPMKALKUL:phy01r)
     f                                        USROPN

     f#PREIL1   if   e           k disk    RENAME(prei1:log01r)
     f#PREIL3   if   e           k disk    RENAME(prei1:log03r)

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
     d#073             s                   like(PREZPR)
     d#073_von         s                   like(PRGADA)
     d#073_bis         s                   like(PRGBDA)
     d#173             s                   like(PREZPR)
     d#173_von         s                   like(PRGADA)
     d#173_bis         s                   like(PRGBDA)
     d#273             s                   like(PREZPR)
     d#273_von         s                   like(PRGADA)
     d#273_bis         s                   like(PRGBDA)
     d#373             s                   like(PREZPR)
     d#373_von         s                   like(PRGADA)
     d#373_bis         s                   like(PRGBDA)
     d#400             s                   like(PREZPR)
     d#400_von         s                   like(PRGADA)
     d#400_bis         s                   like(PRGBDA)
     d#EVP             s                   like(PREZPR)
     d#evp_von         s                   like(PRGADA)
     d#evp_bis         s                   like(PRGBDA)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dstatus           s            132A   inz
     Derr_msg          s              1a   inz
     Dsuffix           s             06A   inz
     Dtransfer         s             30A   inz
     Dstring_file      s             60A   inz
     D§records         s              9s 0 inz
     D§text            s             48a   inz
     D p_inFIL         s             24a   inz
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     D*-------------------------------------------------------------------------
       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a


      // dummy512
      //------------------------------------------------------------------------
      // p_md            s            001a   inz
      //                                     dim(256)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz


      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying


     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    run_for          06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   eval      status =
     c                             'Start RPMIISTK3R Übergabe Stk3-Daten '
     c                             + run_for
     c                   exsr      SR_log

     C*                 Bereiche löschen
     c                   exsr      sr9000
     C*                 reine de411 artikel ermitteln
     c                   exsr      sr0950
     C*                 letzte Stk3 Daten
     c                   exsr      sr1000
     C*                 grunddaten holen aus letzten Stk3 -lauf
     c                   exsr      sr2000
     C*                 Stk3  file ableiten
     c                   exsr      sr4000
     C*                 zusätzliche Preise laden
     c                   if        run_for   =   'DE411'
     c                   open      RPMKALKUL
     c                   exsr      sr4100
     c                   close     RPMKALKUL
     c                   endif

     C*                 für ftp aufbereiten tvrelwaeco/#RP0540 Ausgabe
     c                   if        run_for   =   'DE411'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten
     c                   exsr      sr8000
     c                   exsr      sr8500
     c                   eval      suffix         =  'DE411'
     c                   exsr      file_out
     c                   endif
     c                   if        run_for   =   'CH412'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten CH412
     c                   exsr      sr8000ch
     c                   exsr      sr8500
     c                   eval      suffix         =  'CH412'
     c                   exsr      file_out
     c                   endif
     c                   if        run_for   =   'BE111'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten BE111
     c                   exsr      sr8000be
     c                   exsr      sr8500
     c                   eval      suffix         =  'BE111'
     c                   exsr      file_out
     c                   endif
     c                   if        run_for   =   'NL411'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten NL411
     c                   exsr      sr8000nl
     c                   exsr      sr8500
     c                   eval      suffix         =  'NL411'
     c                   exsr      file_out
     c                   endif
     c                   if        run_for   =   'AT411'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten AT411
     c***                exsr      sr8000AT
     c                   exsr      sr8500
     c                   eval      suffix         =  'AT411'
     c                   exsr      file_out
     c                   endif
     c                   if        run_for   =   'DE117'
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten DE117 EZETIL
     c                   exsr      sr8000de2
     c                   exsr      sr8500
     c                   eval      suffix         =  'DE117'
     c                   exsr      file_out
     c                   endif
     c                   exsr      SR_reportII
     c                   eval      status =
     c                             'Ende RPMIISTK3R Uebergabe StK3  -Daten '
     c                             + run_for
     c                   exsr      SR_log
     c                   exsr      return

     C**************************************************************************
     C*Definition: - letzte STK3 Daten aus 001!!!!!!!!!!!!!!
     C*-------------------------------------------------------------------------
     C*
     C     sr0950        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##0950
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     c/exec sql
     c+ insert into tvrelwaeco/DE411LIEF
     c+ SELECT ARTNR, lieferant2, lflfat
     c+ FROM bar_kalk/kalk_file,lief01
     c+ WHERE version='$$EL_PS_DB' and
     c*****   (KCJMNG_VJ<>0 and KCJMNG_AJ <> 0) and
     c+       (lieferant1 <> ' ' or lieferant2 <> ' ') and
     c+       LFFIRM ='01' and
     c+       lieferant2 =LFLFNR and lflfat<> '000'
     c/end-exec

     C     ##0950        ENDSR

     C**************************************************************************
     C*Definition: - letzte STK3 Daten aus 001!!!!!!!!!!!!!!
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     c/exec sql
     c+ insert into tvrelwaeco/#RP0550
     c+ SELECT
     c+ max(char(digits(WAOFKAJJ)) concat WAOFKANR) key, WAOFVEUR
     c+ FROM waof WHERE (WAOFFIRM='01' or WAOFFIRM='51')
     c+      and (year(date(substr(char(waofjdat), 1, 4) concat '-'
     c+      concat  substr(char(waofjdat), 5, 2) concat '-' concat
     c+      substr(char(waofjdat), 7, 2))) > year(current date  -2 year))
     c+      and waofbere='001'  GROUP BY WAOFVEUR ORDER BY  WAOFVEUR
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*Definition: - letzte Stk3 Daten
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
     c/exec sql
     c+ insert into tvrelwaeco/#RP0555
     c+ SELECT * FROM waof a
     c+ WHERE  (WAOFFIRM='01' or WAOFFIRM='51') and waofveur in
     c+        (select WAOFVEUR from #RP0550 where WAOFKANR =
     c+     substr(key, 5, 6) and  char(WAOFKAJJ)=substr(key, 1, 4))
     c/end-exec

     C     ##2000        ENDSR

     C**************************************************************************
     C*Definition: - Kalkbasisdaten        TEEWPACO
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     c/exec sql
     c+ insert into tvrelwaeco/RPMKALKUL
     c+ SELECT WAOFFIRM,WAOFBERE,WAOFKAJJ,WAOFKANR,WAOFVEUR,
     c+ ARTBEZ,ARTGRP,STATNR,ABC,WAOFKAJJ concat ' ' concat WAOFKANR
     c+ buchung2, uland,LIEFERANT1,LIEFERANT2, ZOLLNR,ARTZ1,WACDEK,
     c+ WAOFWF01 EK_WAECO_Impex,WAOFWF02 kurs, WAOFWF03
     c+ EK_Preis_Impex_EU,WAOFWF04 EK, WAOFWF49 Fremdl, WAOFWF05 Fracht,
     c+ WAOFWF06 Zoll,WAOFWF07 Versicherung,WAOFWF08 Zusatz, WAOFWF09
     c+ Bezugskosten,WAOFWF16 Lohn,WAOFWF11 STK_I,WAOFWF12 FGK, WAOFWF13
     c+ MGK, WAOFWF14 Stk2, WAOFWF15 Sondereinzelkosten, WAOFWF10 ST3_Kalk,
     c+ WAOFWF17 STK3_FIX, WAOFWF18 ICS_berechnet, WAOFWF19 ICS_Preisliste,
     c+ WAOFWF20 ICS_Neu, WAOFWF21 ICS_final, WAOFWF22 ICN_berechnet,
     c+ WAOFWF23 ICN_Preisliste, WAOFWF24 ICN_Neu, WAOFWF25
     c+ ICN_final,WAOFWF26 EXS_berechnet,WAOFWF27 EXS_Preisliste, WAOFWF28
     c+ EXS_Neu, WAOFWF29 EXS_final, WAOFWF30 EXN_berechnet, WAOFWF31
     c+ EXN_Preisliste, WAOFWF32 EXN_Neu, WAOFWF33 EXN_final, WAOFWF22
     c+ ICN_berechnet, WAOFWF23 ICN_Preisliste, WAOFWF24 ICN_Neu, WAOFWF25
     c+ ICN_final,WAOFWF26 EXS_berechnet,WAOFWF27 EXS_Preisliste, WAOFWF28
     c+ EXS_Neu, WAOFWF29 EXS_final, WAOFWF30 EXN_berechnet, WAOFWF31
     c+ EXN_Preisliste, WAOFWF32 EXN_Neu, WAOFWF33 EXN_final, WAOFWF34
     c+ OEM_berechnet, WAOFWF35 OEM_Preisliste, WAOFWF36 OEM_Neu, WAOFWF37
     c+ OEM_final, WAOFWF38 GH_netto_berechnet, WAOFWF39 GH_netto_neu,
     c+ WAOFWF40 GH_Rabatt_berechnet, WAOFWF41*0+EVP_AJ EVP_Preisliste,
     c+ WAOFWF42 GH_Rabatt_neue, WAOFWF43 EVP_netto_Kalk, WAOFWF44
     c+ EVP_brutto_kalk,
     c+ ANLDAT,#TEVOZ1,#TEVOA1,ARTSKU,FAKTOR#,FAKTOR#EK,STK_LCP,
     c+ COSTPRS_AR,COSTPRS_AJ,TSTAMP,E10, substr(e10, 1, 1) MSAA,
     c+ substr(e10, 2, 1) OTRA, substr(e10, 3, 1) MKAB, substr(e10, 4, 1)
     c+ MF, substr(e10, 5, 1) GKFZB, substr(e10, 6, 1) BT, substr(e10, 7,
     c+ 1) DIVFRIGO, substr(e10, 8, 1) MINIBUS, substr(e10, 9, 1) DEFA,
     c+ substr(e10, 10, 1) OETEILE, substr(e10, 11, 1) KLIMATEILE, e1,
     c+ e2,e3,e4,e5,e6,e7,e8,e9,LAENGE,BREITE,HOEHE,GEWICHT, ARTZ3
     c+ ArtStatus, PREISKDU,ARTEAN,ARTZ2,MARGE_NEU1,BUCHUNG2, SYS01 id_art,
     c+ LIEFNR DomPB,DEC(0, 11, 2) #0073, DEC(0, 11, 2) #0173, DEC(0, 11,
     c+ 2) #0273, DEC(0, 11, 2) #0373, DEC(0, 11, 2) #0400, KCJMNG_VJ,
     c+ KCJMNG_AJ, KCJUMS_VJ, KCJUMS_AJ, sys02, CCSTCK, char(' ', 50)
     c+ sup_item, char(' ', 10) PA_code , current timestamp tstamp FROM
     c+ #rp0555, bar_kalk/kalk_file WHERE WAOFVEUR= artnr and version
     c+ ='$$EL_PS_DB'
     c/end-exec

     c/exec sql
     c+ update rpmkalkul set   BUCHUNG2   =WAOFVEUR
     c/end-exec

     c/exec sql
     c+ update   rpmkalkul set BUCHUNG201=
     c+ (select substr(LPIDEN, 1, 20) from lpif01    where
     c+  WAOFVEUR=LPTENR and lpfirm='01' and lieferant1=LPLFNR)
     c+ where exists
     c+ (select substr(LPIDEN, 1, 20) from lpif01    where
     c+  WAOFVEUR=LPTENR and lpfirm='01' and lieferant1=LPLFNR)
     c/end-exec

     c/exec sql
     c+ update rpmkalkul set   E10=WAOFVEUR
     c/end-exec

     c/exec sql
     c+ update rpmkalkul set   WAOFVEUR =  ARTSKU
     c+                        WHERE WAOFVEUR <> ARTSKU and
     c+ substr(ARTSKU, 1, 1) <> '0' and substr(waofveur, 11, 1)<>' '
     c/end-exec

     C*73480 deaktiviert 13.01.2020
     c***/exec sql
     c***+ update  rpmkalkul set   WAOFVEUR =  ARTSKU
     c***+                         WHERE WAOFVEUR <> ARTSKU and substr(ARTSKU,
     c***+ 1, 1) <> '0' and (substr(waofveur, 1, 1)<>'8' and substr(waofveur,
     c***+ 1, 1)<>'9' and substr(waofveur, 1, 1)<>'4')
     c***+ and (substr(waofveur, 1, 1)<>'4')
     c***/end-exec


     c/exec sql
     c+ update RPMKALKUL set sup_item  =
     c+ (select LPIDEN from lpif01 where
     c+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c+     LIEFERANT1=LPLFNR)
     c+ where exists
     c+ (select LPIDEN from lpif01 where
     c+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c+     LIEFERANT1=LPLFNR)
     c/end-exec


     c/exec sql
     c+ update RPMKALKUL set sup_item  =
     c+ (select LPIDEN from lpif01 where
     c+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c+     LIEFERANT2=LPLFNR and sup_item = ' ')
     c+ where exists
     c+ (select LPIDEN from lpif01 where
     c+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c+     LIEFERANT2=LPLFNR and sup_item = ' ')
     c/end-exec


     c/exec sql
     c+ update RPMKALKUL set sup_item  =
     c+ substr(sup_item, 1, 16) concat
     c+ (select TEWBKT from teil01 where
     c+  teFIRM ='01' and teTENR =WAOFVEUR)
     c+ where exists
     c+ (select TEWBKT from teil01 where
     c+  teFIRM ='01' and teTENR =WAOFVEUR)
     c/end-exec


     c/exec sql
     c+ update RPMKALKUL set  PA_code  =
     c+ (select TEEWPACD  from teew01 where
     c+  TEEWFIRM ='01' and TEEWTENR =WAOFVEUR)
     c+ where exists
     c+ (select TEEWPACD  from teew01 where
     c+  TEEWFIRM ='01' and TEEWTENR =WAOFVEUR)
     c/end-exec


     C     ##4000        ENDSR

     C**************************************************************************
     C*....
     C*-------------------------------------------------------------------------
     C*
     C     sr4100        BEGSR

     c                   DO        *HIVAL
     c                   READ      RPMKALKUL                              95
     c                   IF        *in95 = '1'
     c                   leave
     c                   else
     c                   setoff                                       70
     C     ';':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     ',':'.'       xlate     ARTBEZ        ARTBEZ                 70
     C     '"':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     '´':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     '`':' '       xlate     ARTBEZ        ARTBEZ                 70
     c                   exsr      sr7000
     C                   update    phy01r
     c                   endif
     c                   enddo

     C     ##4100        ENDSR

     C**************************************************************************
     C* SR7000:
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
     C*
     c     key7000       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA
     c****               kfld                    PRKDLG

     c                   movel     '01'          PRFIRM
     c                   movel     'PKG'         PRBEGR
     c                   movel     WAOFVEUR      PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     c                   clear                   #073
     c                   clear                   #073_von
     c                   clear                   #073_bis
     c                   clear                   #173
     c                   clear                   #173_von
     c                   clear                   #173_bis
     c                   clear                   #273
     c                   clear                   #273_von
     c                   clear                   #273_bis
     c                   clear                   #373
     c                   clear                   #373_von
     c                   clear                   #373_bis
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
     c     PRTENR        orne      WAOFVEUR
     c     PRWACD        orne      'EUR'
     c*    PRWACD        orne      KDWACD
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     C                   if        PRKDLG = '073'
     C                   eval      #073     =      PREZPR
     C                   eval      #0073    =      PREZPR
     C                   eval      #073_von =      PRGADA
     C                   eval      #073_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '173'
     C                   eval      #173     =      PREZPR
     C                   eval      #0173    =      PREZPR
     C                   eval      #173_von =      PRGADA
     C                   eval      #173_bis =      PRGBDA
     C                   endif
     C                   if        PRKDLG = '273'
     C                   eval      #273     =     PREZPR
     C                   eval      #0273    =     PREZPR
     C                   eval      #273_von =     PRGADA
     C                   eval      #273_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '373'
     C                   eval      #373     =     PREZPR
     C                   eval      #0373    =     PREZPR
     C                   eval      #373_von =     PRGADA
     C                   eval      #373_bis =     PRGBDA
     C                   endif
     C                   if        PRKDLG = '400'
     C                   eval      #400     =     PREZPR
     C                   eval      #0400    =     PREZPR
     C                   eval      #400_von =     PRGADA
     C                   eval      #400_bis =     PRGBDA
     C                   endif
     C
     C                   endif
     C                   endif
     C                   enddo
     C                   endif

     c                   movel     '01'          PRFIRM
     c                   movel     'PVK'         PRBEGR
     c                   movel     WAOFVEUR      PRTENR
     c                   movel     'EUR'         PRWACD
     c                   clear                   PRGADA

     C     KEY7000       SETLL     #PREIL3                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL3                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'PVK'
     c     PRTENR        orne      WAOFVEUR
     c     PRWACD        orne      'EUR'
     C                   leave
     C                   else
     c                   if        WAOFVEUR  ='9103300448'
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

     C*
     C     ##7000        ENDSR
     C*
     C**************************************************************************
     C*
     C*Definition: STK3                     aus  tvrelwaeco/RPMKALKUL
     C* + anschließend manipulation
     C*update              tvrelwaeco/RPMIIuplod set RPMSTK3 =3828
     C*                                          WHERE RPMSKU ='8887100007'
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C**************> STK3_FIX   COSTPRS_AR
     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artnr,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     c+     and statnr < '799'  and  artnr <> '8887100008'
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     c+     and statnr < '799' and  artnr <> '8887100008'
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c+     and ((lieferant2 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))
     c+     and
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 <>' ' ))
     c+     and statnr < '799'  and  artnr <> '8887100008'
     c/end-exec

     C     ##8000        ENDSR

     C**************************************************************************
     C*Definition: CH411
     C*-------------------------------------------------------------------------
     C*
     C     sr8000CH      BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8000ch
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT  char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('CH412', 10) factory,
     c+ char('CH412', 10) UploadUT, char('CH', 10) Country , tETENR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(TESTPR*100, 11, 0)
     c+ STK3, char('CHF', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('DometicCH    ', 20) Brand, char('          ', 20) comment,
     c+ tETENR,tETENR, tETENR                  , current timestamp
     c+            FROM teil01, gang/CODEKUNDEs ,
     c+ lief01 WHERE TEFIRM = '55' and testlf <> ' ' and TEFIRM = LFFIRM
     c+ and TESTLF = LFLFNR and lflfat<>'000'
     c+
     c/end-exec


     c***/exec sql
     c***+ update tvrelwaeco/RPMIIuplod set RPMSC  ='DE411' where RPMSC ='CH412'
     c***+                              and RPMFOO ='CH412'
     c***/end-exec


     C     ##8000CH      ENDSR

     C**************************************************************************
     C*Definition: BE111
     C*-------------------------------------------------------------------------
     C*
     C     sr8000BE      BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8000be
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT  char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('BE111', 10) factory,
     c+ char('BE111', 10) UploadUT, char('BE', 10) Country , tETENR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(TESTPR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('DOM BNL   ', 20) Brand, char('          ', 20) comment,
     c+ tETENR,tETENR, tETENR                  , current timestamp
     c+            FROM teil01, gang/CODEKUNDEs ,
     c+ lief01 WHERE TEFIRM = '08' and testlf <> ' ' and TEFIRM = LFFIRM
     c+ and TESTLF = LFLFNR and lflfat<>'000'
     c+
     c/end-exec


     c***/exec sql
     c***+ update tvrelwaeco/RPMIIuplod set RPMSC  ='DE411' where RPMSC ='BE111'
     c***+                              and RPMFOO ='BE111'
     c***/end-exec


     C     ##8000BE      ENDSR

     C**************************************************************************
     C*Definition: NL411
     C*-------------------------------------------------------------------------
     C*
     C     sr8000NL      BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8000nl
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT  char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('NL411', 10) factory,
     c+ char('NL411', 10) UploadUT, char('NL', 10) Country , tETENR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(TESTPR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('DOM BNL   ', 20) Brand, char('          ', 20) comment,
     c+ tETENR,tETENR, tETENR                  , current timestamp
     c+            FROM teil01, gang/CODEKUNDEs ,
     c+ lief01 WHERE TEFIRM = '52' and testlf <> ' ' and TEFIRM = LFFIRM
     c+ and TESTLF = LFLFNR and lflfat<>'000'
     c+
     c/end-exec

     c***/exec sql
     c***+ update tvrelwaeco/RPMIIuplod set RPMSC  ='DE411' where RPMSC ='NL111'
     c***+                              and RPMFOO ='NL111'
     c***/end-exec

     C     ##8000NL      ENDSR

     C**************************************************************************
     C*Definition: DE117
     C*-------------------------------------------------------------------------
     C*
     C     sr8000de2     BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8000de2
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT  char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE117', 10) factory,
     c+ char('DE117', 10) UploadUT, char('DE', 10) Country , tETENR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(TESTPR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('DometicEzetil', 20) Brand, char('          ', 20) comment,
     c+ tETENR,tETENR, tETENR                  , current timestamp
     c+            FROM teil01, gang/CODEKUNDEs ,
     c+ lief01 WHERE TEFIRM = '20' and testlf <> ' ' and TEFIRM = LFFIRM
     c+ and TESTLF = LFLFNR and lflfat<>'000'
     c+
     c/end-exec


     c***/exec sql
     c***+ update tvrelwaeco/RPMIIuplod set RPMSC  ='DE411' where RPMSC ='CH412'
     c***+                              and RPMFOO ='CH412'
     c***/end-exec


     C     ##8000de2     ENDSR

     C**************************************************************************
     C*Definition: - für FTP
     C*-------------------------------------------------------------------------
     C*
     C     sr8500        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##8500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ update RPMIIUPLOD set  RPMSKU =  $ARTBEZFRA
     c+ WHERE RPMSKU <> $ARTBEZFRA and $ARTBEZFRA <> ' '
     c/end-exec

     c/exec sql
     c+ update RPMIIUPLOD set   RPMSKU =  $ARTNR
     c+ WHERE RPMSKU <> $ARTNR and substr(rpmsku, 1, 1) = '0'
     c+      and $ARTBEZFRA = ' '
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/#RP0540
     c+ SELECT
     c+ distinct RPMUPLDTE, RPMFOO, RPMUPLENT, RPMCOO, RPMSKU, RPMSC,
     c+          RPMPRCQTY, RPMPRCUNT, RPMCOM, RPMSTK3, RPMWHG, RPMGUEVON,
     c+          RPMGUEBIS, RPMBRAND  FROM  RPMIIUPLOD
     c/end-exec

     C     ##8500        ENDSR

     C**************************************************************************
     C*...  stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9000        BEGSR

     C**   *** step 1 aktuelle Kalkulationen ermitteln                       */
      /FREE
         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/#RP0550) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/#RP0550)  ';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C**   *** step 2 alle Ableitungen  ermitteln                       */
      /FREE
         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/#RP0555) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/#RP0555)  ';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C**   *** step 3 Kalkulationen Stk3 ermitteln                    */
      /FREE
         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/RPMKALKUL) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/RPMKALKUL) ';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C**   *** step 4a evtl.Stk3 Daten ermitteln  für upload        */
      /FREE
         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/RPMIIUPLOD) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/RPMIIUPLOD)  ';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C**   *** step 4b evtl.Stk3 Daten ermitteln  für upload        */
      /FREE
         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/#RP0540) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/#RP0540)  ';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C**   *** reine DE411 artikel                                  */
      /FREE
         clear     Wrk.var1;
         clear     status;

         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/DE411LIEF)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/DE411LIEF)';
               exsr      SR_log;
               err_msg = '1';
         endmon;
      /End-FREE

     C     ##9000        ENDSR

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

      /FREE
       begsr file_out;

       //sql handling
          exec sql
                     whenever not found CONTINUE;;
          exec sql
                     WHENEVER SQLWARNING CONTINUE;
          exec sql
                     WHENEVER SQLERROR  CONTINUE;

       //Ausgabe der einzelnen Files über variable
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#RP0544';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  %TrimR(suffix)+
                                  '_STK3';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export Datei vorher vom Inhalt löschen
         MONITOR;
            Wrk.var1 =
                'clrpfm file(TVRELWAECO/'+ p_outfil +')';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error clrpfm file ' +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#RP0544';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  %TrimR(suffix)+
                                  '_STK3';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*REPLACE  ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:    p_print:
                        p_outfil: p_lib:    p_repadd);


         §text          = *blank;
         §text          =  'temporäre Übertragung: '              +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            ' '                                   +
                            %char(%dec(%char(%time():*iso0):8:0));

         eval p_outfil  =  %TrimR(suffix)+
                                  '_STK3';

       //Aufbereitung für Export Datei Info in Beschreibung
       //MONITOR;
       //   Wrk.var1 =
       //       'CHGOBJD OBJ(TVRELWAECO/'+ p_outfil +')' +
       //       ' OBJTYPE(*FILE)'                         +
       //       ' TEXT(''+
       //       '+ §text +'+
       //       '''+
       //       ')';
       //   cmd = %TrimR(Wrk.Var1);
       //   L      = %Len(Cmd);
       //   QCMDEXC(cmd: %len(cmd));
       //   on-error;
       //      status='error CHGOBJD OBJ ' +
       //              p_outfil;
       //      //Aufbereitung für Export  Abbruch
       //      exsr      SR_log;
       //endmon;

         eval  transfer =  %trimr(suffix) +'-'                   +
                            %char(%dec(%char(%date():*iso0):8:0)) +
                            %char(%dec(%char(%time():*iso0):8:0)) +
                            '.txt';

         clear     Wrk.var1;
         clear     status;

       //Aufbereitung für Export in Übertragungsdatei
         MONITOR;
            Wrk.var1 =
                'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                'TOFILE(TVRELWAECO/RPMII4_OUT RPMII4_OUT) '+
                'MBROPT(*REPLACE) STRDLM('' '') '+
                'RMVBLANK(*BOTH) FLDDLM('';'') DECPNT(*COMMA) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CPYTOIMPF FROMFILE '  +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
               exsr      SR_log;
         endmon;

         eval p_outfil  =  %TrimR(suffix)+
                                  '_STK3';
         clear     Wrk.var1;
         clear     status;

         §records=*zero;
       exec sql
         select count(*) into :§records
                from RPMII4_OUT;

       if §records <> *zero;
       //OVRDBF FILE INPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(RPMSTK3C)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  %TrimR(suffix)+
                                     '_STK3';
            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(RPMSTK3)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

       //Info in Outfile timestamp
            clear p_md;
            eval p_msg     =  '#DC0010';
            eval p_msgf    =  *blank;
            eval p_print   =  *blank;
            eval p_outfil  =  'OUTPUT    ';
            eval p_lib     =  'TVRELWAECO';
            eval p_repadd  =  '*ADD';

            callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                           p_outfil: p_lib:    p_repadd);

            eval p_outfil  =  %TrimR(suffix)+
                                     '_STK3';

            clear  string_file;
            eval   string_file = 'APPEND ' +
                                 'RPMII4_OUT ' +
                                 transfer;

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //FTP-Befehl
            MONITOR;
               Wrk.var1 =
                   'FTP RMTSYS(''ftp.seit.dometic.com'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;

            if err_msg = '1';
               status='error ftp.seit.dometic.com '    +
                                                  %trimr(suffix) + ' ' +
                                                  transfer             +
                                                  ' '                  +
                                                  %char(§records);
               exsr      SR_log;
            else;
               status='transfer successful '    +
                                                  %trimr(suffix) + ' ' +
                                                  transfer             +
                                                  ' '                  +
                                                  %char(§records);
               exsr      SR_log;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';

               §text          = *blank;
               §text          = %trimr(suffix) + ' ' +
                                transfer             +
                                ' '                  +
                                %char(§records);
               exsr      SR_report;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';
       //Aufbereitung für Export Datei Info in Beschreibung
               MONITOR;
               Wrk.var1 =
                   'CHGOBJD OBJ(TVRELWAECO/'+ p_outfil +')' +
                   ' OBJTYPE(*FILE)'                         +
                   ' TEXT(''+
                   '+ §text +'+
                   '''+
                   ')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error CHGOBJD OBJ ' +
                         p_outfil;
                  //Aufbereitung für Export  Abbruch
                  exsr      SR_log;
            endmon;

            endif;
            exsr SR_reportII;
       else;
          status='Übertragungsdatei leer ' + p_outfil;
          exsr      SR_log;
       endif;

       endsr;

      /End-FREE

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_report;

       MONITOR;
       Wrk.var1 =
           'RMVLNK    OBJLNK(''/SALESCOMPANY/RPMII/'+ p_outfil +''+
                      '.csc'')';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/RPMII/'+ p_outfil +''  +
                      '.csc'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object #RP0540                   ';
          exsr      SR_log;
       endmon;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/SALESCOMPANY/RPMII/'+ p_outfil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/RPMII)         ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/RPMII)        ';
       endmon;


       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''#RP0540'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object ' +
                         p_outfil +'csv';
          exsr      SR_log;
       endmon;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';

       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
           ''' '' '' '' '' '')';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by DUMMY512                        ';
          exsr      SR_log;
       endmon;

       endsr;

      /End-FREE

       //-----------------------------------------------------------------------
       //report im Verzeichnis ablegen  ==> RPMKALKUL
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_reportII;

       //Ausgabe der einzelnen Files über variable
         eval p_infil   =  'RPMKALKUL' + '_'  +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'RPMKALKUL';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/SALESCOMPANY/RPMII/RPMKALKUL*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed stk3_RPMKALKUL*      ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object stk3_RPMKALKUL*         ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RPMKALKUL';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/RPMII/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for RPMKALKUL             ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object RPMKALKUL                 ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'RPMKALKUL';


       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/SALESCOMPANY/RPMII/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/STK3)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/stk3)       ';
       endmon;


       endsr;

      /End-FREE

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
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

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

     C     sr_log        BEGSR

      /FREE
         clear p_md;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

      /End-FREE

     c                   clear                   status
     C
     C     #sr_log       ENDSR

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
