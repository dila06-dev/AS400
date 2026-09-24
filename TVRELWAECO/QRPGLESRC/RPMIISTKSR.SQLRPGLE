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
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   eval      status =
     c                             'Start RMPIISTKSR Übergabe STK-Daten   '
     c                   exsr      SR_log

     C*                 Bereiche löschen
     c                   exsr      sr9000
     C*                 letzte Budgetdaten
     c                   exsr      sr1000
     C*                 grunddaten holen aus letzten Budgetlauf
     c                   exsr      sr2000
     C*                 Budgetfile ableiten
     c                   exsr      sr4000
     C*                 zusätzliche Preise laden
     c                   open      RPMKALKUL
     c                   exsr      sr4100
     c                   close     RPMKALKUL
     C*                 für ftp aufbereiten
     c                   exsr      sr8000
     c                   exsr      sr8500
     c                   exsr      file_out
     c                   eval      status =
     c                             'Ende RMPIISTKSR Übergabe STK-Daten   '
     c                   exsr      SR_log
     c                   exsr      return

     C**************************************************************************
     C*Definition: - letzte Budgetdaten
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
     c+      substr(char(waofjdat), 7, 2))) = year(current date  -1 year))
     c+      and waofbere='001'  GROUP BY WAOFVEUR ORDER BY  WAOFVEUR
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*Definition: - letzte Budgetdaten
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
     C*Definition: - Kalkbasisdaten
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
     c+ SELECT
     c+ WAOFFIRM,WAOFBERE,WAOFKAJJ,WAOFKANR,WAOFVEUR,
     c+ ARTBEZ,ARTGRP,STATNR,ABC,WAOFKAJJ concat ' ' concat WAOFKANR
     c+ buchung2, uland,LIEFERANT1,LIEFERANT2,
     c+ ZOLLNR,ARTZ1,WACDEK,
     c+ WAOFWF01 EK_WAECO_Impex,WAOFWF02 kurs,
     c+ WAOFWF03 EK_Preis_Impex_EU,WAOFWF04 EK, WAOFWF05 Fracht,
     c+ WAOFWF06 Zoll,WAOFWF07 Versicherung,WAOFWF08 Zusatz,
     c+ WAOFWF09 Bezugskosten,WAOFWF16 Lohn,WAOFWF11 STK_I,WAOFWF12 FGK,
     c+ WAOFWF13 MGK, WAOFWF14 Stk2, WAOFWF15 Sondereinzelkosten,
     c+ WAOFWF10 ST3_Kalk, WAOFWF17 STK3_FIX, WAOFWF18 ICS_berechnet,
     c+ WAOFWF19 ICS_Preisliste, WAOFWF20 ICS_Neu, WAOFWF21 ICS_final,
     c+ WAOFWF22 ICN_berechnet, WAOFWF23 ICN_Preisliste, WAOFWF24 ICN_Neu,
     c+ WAOFWF25 ICN_final,WAOFWF26 EXS_berechnet,WAOFWF27 EXS_Preisliste,
     c+ WAOFWF28 EXS_Neu, WAOFWF29 EXS_final, WAOFWF30 EXN_berechnet,
     c+ WAOFWF31 EXN_Preisliste, WAOFWF32 EXN_Neu, WAOFWF33 EXN_final,
     c+ WAOFWF34 OEM_berechnet, WAOFWF35 OEM_Preisliste, WAOFWF36 OEM_Neu,
     c+ WAOFWF37 OEM_final, WAOFWF38 GH_netto_berechnet,
     c+ WAOFWF39 GH_netto_neu, WAOFWF40 GH_Rabatt_berechnet,
     c+ WAOFWF41*0+EVP_AJ    EVP_Preisliste, WAOFWF42 GH_Rabatt_neue,
     c+ WAOFWF43 EVP_netto_Kalk, WAOFWF44 EVP_brutto_kalk,
     c+ ANLDAT,#TEVOZ1,#TEVOA1,ARTSKU,FAKTOR#,FAKTOR#EK,STK_LCP,
     c+ COSTPRS_AR,COSTPRS_AJ,TSTAMP,E10, substr(e10, 1, 1) MSAA,
     c+ substr(e10, 2, 1) OTRA,     substr(e10, 3, 1) MKAB,
     c+ substr(e10, 4, 1) MF,       substr(e10, 5, 1) GKFZB,
     c+ substr(e10, 6, 1) BT,       substr(e10, 7, 1) DIVFRIGO,
     c+ substr(e10, 8, 1) MINIBUS,  substr(e10, 9, 1) DEFA,
     c+ substr(e10, 10, 1) OETEILE, substr(e10, 11, 1) KLIMATEILE,
     c+ e1, e2,e3,e4,e5,e6,e7,e8,e9,LAENGE,BREITE,HOEHE,GEWICHT,
     c+ ARTZ3 ArtStatus, PREISKDU,ARTEAN,ARTZ2,MARGE_NEU1,BUCHUNG2,
     c+ SYS01 id_art, LIEFNR DomPB,DEC(0, 11, 2) #0073,
     c+ DEC(0, 11, 2) #0173, DEC(0, 11, 2) #0273,
     c+ DEC(0, 11, 2) #0373, DEC(0, 11, 2) #0400,
     c+ KCJMNG_VJ, KCJMNG_AJ, KCJUMS_VJ, KCJUMS_AJ      FROM #rp0555,
     c+ bar_kalk/kalk_file WHERE WAOFVEUR= artnr and version ='$$EL_PS_DB'
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
     C*Definition: B U D G E T - D A T E N  aus  tvrelwaeco/RPMKALKUL
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

     C**   *** Grundaufbau für RPM-Ausgabe                                   */
     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+         ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     c+     and statnr < '799'
     c/end-exec

     C**   *** Grundaufbau für RPM-Ausgabe                                   */
     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+     ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     c+     and statnr < '799'
     c/end-exec

     C**   *** Grundaufbau für RPM-Ausgabe                                   */
     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +1 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+     ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant2 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))
     c+     and  (LIEFERANT1  = ' ' and LIEFERANT2 <>' ' ))
     c+     and statnr < '799'
     c/end-exec

     C     ##8000        ENDSR

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
     c+ insert into tvrelwaeco/#RP0540
     c+ SELECT
     c+ distinct RPMUPLDTE, RPMFOO, RPMUPLENT, RPMCOO, $ARTNR, RPMSC,
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
         err_msg = ' ';

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

     C**   *** step 3 Kalkulationen Budget ermitteln                    */
      /FREE
         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

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

     C**   *** step 4a evtl.Budgetdaten ermitteln  für upload        */
      /FREE
         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

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

     C**   *** step 4b evtl.Budgetdaten ermitteln  für upload        */
      /FREE
         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';

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
         suffix         =  'DE411';
         clear p_md;
         eval p_md      =  suffix;

         eval p_msg     =  '#RP0543';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  %TrimR(suffix)+
                                  '_BUDG';
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

         eval p_msg     =  '#RP0543';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  %TrimR(suffix)+
                                  '_BUDG';
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
                                  '_BUDG';

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
                                  '_BUDG';
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
                   'MBR(RPMBUDGETC)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            eval p_outfil  =  %TrimR(suffix)+
                                     '_BUDG';
            clear     Wrk.var1;
            clear     status;

       //OVRDBF FILE OUTPUT
            MONITOR;
               Wrk.var1 =
                   'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(RPMBUDGET)';
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
                                     '_BUDG';

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
                   'FTP RMTSYS(''xxx.seit.dometic.com'')';
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
                                        '_BUDG';

               §text          = *blank;
               §text          = %trimr(suffix) + ' ' +
                                transfer             +
                                ' '                  +
                                %char(§records);

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
       else;
          status='Übertragungsdatei leer ' + p_outfil;
          exsr      SR_log;
       endif;

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
