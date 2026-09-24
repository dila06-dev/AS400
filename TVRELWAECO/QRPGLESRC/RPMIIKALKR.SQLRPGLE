     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * SELECT * FROM select * from  prodwin51/prj015p
      * SELECT * FROM Datei PRJ015P#S in TVRELWAECO wurde erstellt.
      * SELECT * FROM 
      * SELECT * FROM 
      * SELECT * FROM 
      * CALL PGM(TVRELWAECO/RPMIIKALKR) PARM('DE000' 'ON' '200' 'x' '0' 'A460764' ' ')
      * 15. Okt.2010   GANG, MANFRED
      * losgrösse
      * SELECT TETENR,TEWBKT, TEEBKT, TEKOTR FROM teil01 WHERE TEFIRM ='01'
      * and substr(tewbkt, 8, 1) =' '
      *
      *
      *
      * SELECT TELOGR FROM teil WHERE TEFIRM ='01' and TETENR ='4444500112'
      * SELECT PRMG01, PRMG02, PRMG03, PRMG04, PRMG05, PRMG06 FROM prei01
      * WHERE PRFIRM ='01' and PRTENR ='4444500112' and PRBEGR='LP1'
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
      * LIEFERARPMSALESMnr, artsku, artbezfra, char(' ', 035) lief1,
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
      * Kalkulation über 001
      * Absprache: Fremdleistung Beschreibung
      *            WAOFWF49      Feld bei Trend Reihenfolge
      *            FREMDL        Feld in Kalkfile
      *
      *
      *
      *****************************************************************
     hALWNULL(*USRCTL)

     fRPMKALKUL uf   e             disk    RENAME(RPMKALKUL:phy01r)
     f                                     USROPN
     fprj015p   uf   e           k disk    USROPN
     f#prj015p  uf a e           k disk    USROPN
     f                                     RENAME(#prj015p:phy02r)
     fteil01    if   e           k disk

     f§teil01   uf   e           K DISK    RENAME(teil1:phy03r)
     f                                     USROPN

     f#PREIL1   if   e           k disk    RENAME(prei1:log01r)
     f#PREIL3   if   e           k disk    RENAME(prei1:log03r)
     f#PREIL5   if   e           k disk    RENAME(prei1:log05r)
     fwaeh01    if   e           k disk

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
     D p_inFIL         s             24a   inz


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
b    C     *ENTRY        PLIST
     C*z.B. DE411
b    C                   PARM                    run_for          06
     C*z.B. ON or nothing
b    C                   PARM                    elps             02
     C*z.B. Kalkbasis
b    C                   PARM                    kalk             03
     C*z.B. Basis/Artikelart
b    C                   PARM                    basis            01
     C*z.B. stkwert Null
b    C                   PARM                    stknull          01
     C*z.B. artkel
b    C                   PARM                    #art             15
     C*'update    prj015f' first
b    C                   PARM                    prj015upd        01
b
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   eval      status =
     c                             'Start RMPIIKALKR Übergabe Budget-Daten ' +
     c                             ' run_for:' + run_for + 'ELPS:' + elps   +
     c                             'Kalk:' +kalk
     c
     c                   exsr      SR_ovrdbf
     c                   open      §teil01
     c                   select
     c                   when      basis = '1'
     c                   eval      Fertigw    =       '1'
     c                   when      basis = '2'
     c                   eval      Verlwbank  =       '1'
     c                   when      basis = '3'
     c                   eval      ErsatzFw   =       '1'
     c                   when      basis = '4'
     c                   eval      BetriebsSt =       '1'
     c                   when      basis = '5'
     c                   eval      Rohstoff   =       '1'
     c                   when      basis = '6'
     c                   eval      EigenProd  =       '1'
     c                   when      basis = '7'
     c                   eval      Konfektion =       '1'
     c                   other
     c                   eval      Fertigw    =  '1'
     c                   eval      Verlwbank  =  '1'
     c                   eval      ErsatzFw   =  '1'
     c                   eval      BetriebsSt =  '1'
     c                   eval      Rohstoff   =  '1'
     c                   eval      EigenProd  =  '1'
     c                   eval      Konfektion =  '1'
     c                   endsl
     c                   exsr      SR_log
     C*                 Bereiche löschen
     c                   exsr      sr9000
     C*                 letzte Ist   daten waofbere in ('001', '001')
     C                   if        Kalk = '001'
     c                   exsr      sr1000b
     C                   endif
     C*                 letzte Budgetdaten waofbere in ('200', '200')
     C                   if        Kalk = '200'
     c                   exsr      sr1000c
     C                   endif
     C*                 letzte Budgetdaten waofbere in ('300', '300')
     C                   if        Kalk = '300'
     c                   exsr      sr1000
     C                   endif
     C*                 grunddaten holen aus letzten Budgetlauf
     c                   exsr      sr2000
     C*                 Budgetfile ableiten
     c                   exsr      sr4000
     C*                 zusätzliche Preise laden
     c**20201111*        open      RPMKALKUL
     c**20201111*        open      prj015p
     c**20201111*        open      #prj015p
     c**20201111*        exsr      sr4100
     c**20201111*        close     #prj015p
     c**20201111*        close     prj015p
     c**20201111*        close     RPMKALKUL
     C*                 für ftp aufbereiten tvrelwaeco/RPMIIuplod Grunddaten
     c                   exsr      sr8000
     C*                 für ftp aufbereiten tvrelwaeco/#RP0540 Ausgabe
     c                   exsr      sr8500
     c                   if        run_for   =   'DE411' and
     c                             elps      <>  'ON'
     C*                 file_out   ausgeknips 15.10.2019
     c                   exsr      file_out
     c                   endif
     C                   if        elps       <> 'ON'
     c                   exsr      SR_reportII
     c                   endif
     C* ==> restart second update for non found records
     C                   if        elps       =  'ON'
     C*                 ==> STK-Lauf Bereiche löschen
     c*******            exsr      sr9000
     C*******            ==> STK-Lauf letzte Budgetdaten waofbere in ('001', '001')
     c*******            exsr      sr1000b
     C*******           ==> STK-Lauf letzte Budgetdaten waofbere in ('200', '200') BUDGET
     c*******            exsr      sr1000c
     C*******           ==> STK-Lauf grunddaten holen aus letzten Budgetlauf
     c*******            exsr      sr2000
     C*******           Budgetfile ableiten
     c*******            exsr      sr4000
     C*                 zusätzliche Preise laden
     c                   open      RPMKALKUL
     c                   open      prj015p
     c                   open      #prj015p
     c                   exsr      sr4100
     c                   close     #prj015p
     c                   close     prj015p
     c                   close     RPMKALKUL
     c                   exsr      SR_reportII
     c                   endif
     c                   close     §teil01
     c                   exsr      SR_dltovr
     C* ==> ende restart second update for non found records
     c                   eval      status =
     c                             'Start RMPIIKALKR Übergabe Budget-Daten ' +
     c                             run_for
     c                   exsr      SR_log
     c                   exsr      return

     C**************************************************************************
     C*Definition: - letzte Budgetdaten aus 300!!!!!!!!!!!!!!
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
     c+ insert into tvrelwaeco/#RP0550b
     c+ SELECT
     c+ max(char(digits(WAOFKAJJ)) concat WAOFKANR) key, WAOFVEUR
     c+ FROM waof WHERE (WAOFFIRM='01' or WAOFFIRM='51')
     c+      and (year(date(substr(char(waofjdat), 1, 4) concat '-'
     c+      concat  substr(char(waofjdat), 5, 2) concat '-' concat
     c+      substr(char(waofjdat), 7, 2))) > year(current date  -1 year))
     c+      and waofbere in ('300', '300')
     c+      GROUP BY (char(digits(WAOFKAJJ)) concat WAOFKANR),WAOFVEUR
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/#RP0550
     c+ SELECT max("KEY"), WAOFVEUR FROM #RP0550b
     c+ GROUP BY WAOFVEUR
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*Definition: - letzte STK falls Budget nicht vorhanden
     C*                         falls Budget nicht vorhanden !!!!! noch einbauen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000b       BEGSR
     C*
     c* whenever not found goto ##1000b
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
     c+ delete from tvrelwaeco/#RP0550b
     c/end-exec

     c/exec sql
     c+ delete from tvrelwaeco/#RP0550
     c/end-exec

     c/exec sql
     c+ delete from tvrelwaeco/RPMKALKUL
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/#RP0550b
     c+ SELECT
     c+ max(char(digits(WAOFKAJJ)) concat WAOFKANR) key, WAOFVEUR
     c+ FROM waof WHERE (WAOFFIRM='01' or WAOFFIRM='51')
     c+      and (year(date(substr(char(waofjdat), 1, 4) concat '-'
     c+      concat  substr(char(waofjdat), 5, 2) concat '-' concat
     c+      substr(char(waofjdat), 7, 2))) > year(current date  -1 year))
     c+      and waofbere in ('001', '001')
     c+      GROUP BY (char(digits(WAOFKAJJ)) concat WAOFKANR),WAOFVEUR
     c/end-exec
     C*                         900383

     c/exec sql
     c+ insert into tvrelwaeco/#RP0550
     c+ SELECT max("KEY"), WAOFVEUR FROM #RP0550b
     c+ GROUP BY WAOFVEUR
     c/end-exec

     C     ##1000b       ENDSR

     C**************************************************************************
     C*Definition: - letzte Budgetdaten aus 200!!!!!!!!!!!!!!
     C*-------------------------------------------------------------------------
     C*
     C     sr1000c       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000c
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     c/exec sql
     c+ insert into tvrelwaeco/#RP0550b
     c+ SELECT
     c+ max(char(digits(WAOFKAJJ)) concat WAOFKANR) key, WAOFVEUR
     c+ FROM waof WHERE (WAOFFIRM='01' or WAOFFIRM='51')
     c+      and (year(date(substr(char(waofjdat), 1, 4) concat '-'
     c+      concat  substr(char(waofjdat), 5, 2) concat '-' concat
     c+      substr(char(waofjdat), 7, 2))) > year(current date  -2 year))
     c+      and waofbere in ('200', '200')
     c+      GROUP BY (char(digits(WAOFKAJJ)) concat WAOFKANR),WAOFVEUR
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/#RP0550
     c+ SELECT max("KEY"), WAOFVEUR FROM #RP0550b
     c+ GROUP BY WAOFVEUR
     c/end-exec

     C     ##1000c       ENDSR

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
     c+ update RPMKALKUL set artz2 =
     c+ ( select max(UKPPAT) from pauk01 where ukfirm='01'
     c+   and UKTENR=WAOFVEUR and UKPRst  > 0 and
     c+   date(substr(UKPRst, 1, 4) concat '-' concat
     c+        substr(UKPRst, 5, 2) concat '-' concat
     c+        substr(UKPRst, 7, 2))   >(current date-365 day)
     c+        group by  UKTENR         )
     c+ where exists
     c+ ( select max(UKPPAT) from pauk01 where ukfirm='01'
     c+   and UKTENR=WAOFVEUR and UKPRst  > 0 and
     c+   date(substr(UKPRst, 1, 4) concat '-' concat
     c+        substr(UKPRst, 5, 2) concat '-' concat
     c+        substr(UKPRst, 7, 2))   >(current date-365 day)
     c+        group by UKTENR         )
     c/end-exec

     c/exec sql
     c+ update RPMKALKUL set marge_neu1 =0
     c/end-exec
     c/exec sql
     c+ update RPMKALKUL set marge_neu1 =
     c+ (select sum(SLAZAUWT) FROM bar_kalk/SLAZS
     c+  where SLAZTENR = WAOFVEUR group by  SLAZTENR )
     c+ where exists
     c+ (select sum(SLAZAUWT) FROM bar_kalk/SLAZS
     c+  where SLAZTENR = WAOFVEUR group by  SLAZTENR )
     c/end-exec

     c*/exec sql
     c*+ update RPMKALKUL set sup_item  =
     c*+ (select LPIDEN from lpif01 where
     c*+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c*+     LIEFERANT1=LPLFNR)
     c*+ where exists
     c*+ (select LPIDEN from lpif01 where
     c*+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c*+     LIEFERANT1=LPLFNR)
     c*/end-exec


     c*/exec sql
     c*+ update RPMKALKUL set sup_item  =
     c*+ (select LPIDEN from lpif01 where
     c*+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c*+     LIEFERANT2=LPLFNR and sup_item = ' ')
     c*+ where exists
     c*+ (select LPIDEN from lpif01 where
     c*+  LPFIRM ='01' and LPTENR =WAOFVEUR and
     c*+    LIEFERANT2=LPLFNR and sup_item = ' ')
     c*/end-exec

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
     c                   if        WAOFVEUR   =  '8887200013'
     c                   move      WAOFVEUR      WAOFVEUR
     c                   endif
     c                   setoff                                       70
     C     ';':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     ',':'.'       xlate     ARTBEZ        ARTBEZ                 70
     C     '"':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     '´':' '       xlate     ARTBEZ        ARTBEZ                 70
     C     '`':' '       xlate     ARTBEZ        ARTBEZ                 70
     C*                 aktuelle Preise holen
     c                   exsr      sr7000
     C*                 elps updaten für einzelne Strukturen updaten
     C*                 Parameter ELPS-Daten aktualisieren
     C                   if        elps       =  'ON'
     c******             if        artstatus  <> '90'
     c                   if        WAOFVEUR   <> '88872nnn13'
     c******                       WAOFVEUR   =  '4444500111'  or
     c******                       WAOFVEUR   =  '9600005390'
     c                   move      Fertigw       Fertigw           1
     c                   move      Verlwbank     Verlwbank         1
     c                   move      ErsatzFw      ErsatzFw          1
     c                   move      BetriebsSt    BetriebsSt        1
     c                   move      Rohstoff      Rohstoff          1
     c                   move      EigenProd     EigenProd         1
     c                   move      Konfektion    Konfektion        1
     c                   if        Fertigw    =  '1'  or
     c                             Verlwbank  =  '1'  or
     c                             ErsatzFw   =  '1'  or
     c                             BetriebsSt =  '1'  or
     c                             Rohstoff   =  '1'  or
     c                             EigenProd  =  '1'  or
     c                             Konfektion =  '1'
     c                   if        #art       =  *blank or
     c                             #art       =  WAOFVEUR
     c                   exsr      sr_EL_PS
     c                   endif
     c                   endif
     c                   endif
     c                   endif
     C*                 update Kontrolldatei
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

     C**************************************************************************
     C*
     C*update elps
     C*Achtung invart wird nicht geändert
     C*-------------------------------------------------------------------------
     C*
     C     sr_EL_PS      BEGSR
     C*
     C                   movel     '0'           *in77
     C                   if        WAOFVEUR  = '4441450049-'  or
     C                             WAOFVEUR  = '4442700362 '  or
     C                             WAOFVEUR  = '9108001843-'  or
     C                             WAOFVEUR  = '9108001822-'  or
     C                             WAOFVEUR  = '9102600116-'
     C                   movel     '0'           *in77
     C                   endif
     c*                 *** nur aktuelle      Achtung Änderung nina 13.11.2020 status 90 auch*
     C                   if        artstatus  = '90'
     C                   movel     '0'           *in77
     c*                 *** auf aktiv gesetzt 16.11.2020 Nina                                *
     C                   movel     '1'           *in77
     C                   else
     C                   movel     '1'           *in77
     C                   endif
     c*                 *** SICHERUNG                                        */
     C                   movel     artsku        artnumI          10 0
     C                   z-add     artnumI       artnum
     c   77artnum        chain     prj015p
     C                   if         %found(prj015p)
     C                   if        (TBUSR  = 'GANGrr   '  and
     C                              TBDAT  = %dec(%char(%date():*iso0):8:0))
     C                   else
     C                   write     phy02r
     c                   if        lfdSTK3   >  0
     c*                 *** lfdSTK3   >  0     move      '1'           stk3   */
     c                   move      '1'           stk3              1
     c                   else
     c                   move      '0'           stk3              1
     c                   endif
     c*                 *** Bereinigung !!!!                                 */
     C                   clear                   lfdSTKMAT
     C                   clear                   lfdSTKLHN
     C                   clear                   lfdSTKFRA
     C                   clear                   lfdSTK
     C                   clear                   lfdMATKOS
     C                   clear                   lfdFERLOH
     C                   clear                   lfdFERGKV
     C                   clear                   lfdSTK1
     C                   clear                   lfdFERGKF
     C                   clear                   lfdMATGKO
     C                   clear                   lfdSTK2
     c                   if        Fertigw    =  '1'
     c*                 *** Achtung für Fertigwaren wird nur geändert bei LFSstk3 > 0 16.11.2020 Nina ***
     C                   else
     C                   clear                   lfdSTK3
     C                   endif
     C                   clear                   lfdFMDLOH
     C                   eval      TBUSR    =    'GANG     '
     C                   eval      TBDAT    =    %dec(%char(%date():*iso0):8:0)
     C*
     c*                 *** Hilfs. und Betriebsstoffe allgemein              */
     c                   if        statnr = '906' and
     c                             ccstck = 0
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdSTK    = ST3_KALK
     c                   eval(H)   lfdSTK1   = ST3_KALK
     c                   eval(H)   lfdMATGKO = MGK
     c                   eval(H)   lfdSTK2   = ST3_KALK
     c                   eval(H)   lfdSTK3   = ST3_KALK
     c                   movel     '800'         ##invart          3 0
     c                   move      '800'         BUCHUNG201
     c                   z-add     800           invart
     c                   eval      %subst(sup_item:01:03) = '800'
     c                   eval      %subst(sup_item:05:09) = '383500000'
     c****               moved     'B'           typ/prj602p2
     c*                 *** Hilfs. und Betriebsstoffe  KATALOGE              */
     c                   if        artgrp = 'KAT'
     c                   movel     '801'         ##invart
     c                   move      '801'         BUCHUNG201
     c                   movel     'Z'           typgrp
     c                   z-add     801           invart
     c                   eval      %subst(sup_item:01:03) = '801'
     c                   eval      %subst(sup_item:05:09) = '383510000'
     c                   endif
     c*                 *** Hilfs. und Betriebsstoffe  DISPLAYS              */
     c                   if        artgrp = 'DIS'
     c                   movel     '802'         ##invart
     c                   move      '802'         BUCHUNG201
     c                   movel     'Z'           typgrp
     c                   z-add     802           invart
     c                   eval      %subst(sup_item:01:03) = '802'
     c                   eval      %subst(sup_item:05:09) = '383520000'
     c                   endif
     c*                 *** Hilfs. und Betriebsstoffe  Bedienungsanleitungen */
     c                   if        artgrp = 'VER'
     c                   movel     '803'         ##invart
     c                   move      '803'         BUCHUNG201
     c                   movel     'Z'           typgrp
     c                   z-add     803           invart
     c                   eval      %subst(sup_item:01:03) = '803'
     c                   eval      %subst(sup_item:05:09) = '383530000'
     c                   endif
     c*                 *** Hilfs. und Betriebsstoffe  Marketingmaterial     */
     c                   if        artgrp = 'MAR'
     c                   movel     '804'         ##invart
     c                   move      '804'         BUCHUNG201
     c                   movel     'Z'           typgrp
     c                   z-add     804           invart
     c                   eval      %subst(sup_item:01:03) = '804'
     c                   eval      %subst(sup_item:05:09) = '383540000'
     c                   endif
     c                   if        BetriebsSt =  '1'
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     c                   endif
     c
     c*                 *** Rohstoffe  11                                    */
     C                   if        id_art=  '2 '  and
     c                             (statnr = '190' or
     c                              statnr = '290' or
     c*************** nina raus     statnr = '390' or    13.11.2020
     c                              statnr = '490' or
     c                              statnr = '491') and
     c                              ccstck = 0
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdSTK    = ST3_KALK - MGK
     c                   eval(H)   lfdSTK3   = ST3_KALK - MGK
     c                   movel     '11 '         ##invart
     c                   z-add     11            invart
     c                   movel     'Z'           typgrp
     c                   eval      %subst(sup_item:01:03) = '11 '
     c                   eval      %subst(sup_item:05:09) = '383200000'
     c                   if        Rohstoff  =  '1'
     c                   move      '11 '         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c*                 *** Ersatzteile Fertigware 500                       */
     C                   if        id_art=  '2 '  and
     c                             (statnr = '199' or
     c                              statnr = '299' or
     c                              statnr = '399' or
     c                              statnr = '499' or
     c                              statnr = '698') and
     c                              ccstck = 0
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdSTK    = ST3_KALK
     c                   eval(H)   lfdSTK1   = ST3_KALK
     c                   eval(H)   lfdMATGKO = MGK
     c                   eval(H)   lfdSTK2   = ST3_KALK
     c                   eval(H)   lfdSTK3   = ST3_KALK
     c                   movel     '500'         ##invart
     c                   z-add     500           invart
     c                   movel     'Z'           typgrp
     c                   eval      %subst(sup_item:01:03) = '500'
     c                   eval      %subst(sup_item:05:09) = '385000100'
     c                   if        ErsatzFw  =  '1'
     c                   move      '500'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c*                 *** Eigenproduktion  300                             */
     C                   if        id_art=  '1 '  and
     c                             artz2   = '100'
     c                   eval(H)   lfdmatkos = ek + FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdferloh = LOHN
     c                   eval(H)   lfdfergkf = FGK
     c                   eval(H)   lfdmatgko = MGK
     c                   eval(H)   lfdSTK1   = lfdmatkos+lfdferloh
     c                   eval(H)   lfdSTK2   = lfdSTK1 + lfdFERGKF + lfdMATGKO
     c                   eval(H)   lfdSTK3   = lfdSTK2
     c                   movel     '300'         ##invart
     c                   z-add     300           invart
     c                   movel     'E'           typgrp
     c                   eval      %subst(sup_item:01:03) = '300'
     c                   eval      %subst(sup_item:05:09) = '384100000'
     c*****************  if        Fertigw <> '1' and
     c*****************            Verlwbank <> '1' and
     c                   IF        EigenProd =  '1'
     c                   move      '300'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c*                 *** Konfektion  301                                  */
     C                   if        id_art=  '1 '  and
     c                             artz2   = '300'
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL
     c                   eval(H)   lfdSTK    = ST3_KALK
     c                   eval(H)   lfdSTK1   = ST3_KALK
     c                   eval(H)   lfdMATGKO = MGK
     c                   eval(H)   lfdSTK2   = ST3_KALK
     c                   eval(H)   lfdSTK3   = ST3_KALK
     c                   movel     '301'         ##invart
     c                   z-add     301           invart
     c                   movel     'E'           typgrp
     c                   eval      %subst(sup_item:01:03) = '301'
     c                   eval      %subst(sup_item:05:09) = '384105000'
     c****************** if        Fertigw <> '1' and
     c******************           Verlwbank <> '1' and
     c                   IF        Konfektion = '1'
     c                   move      '301'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c
     c*                 *** Konfektion  ABESTANB2C                           */
     c*                 ***                                                  */
     C                   if        id_art=  '2 '  and
     c                             LIEFERANT2 <> '90999' and
     c                             ccstck > 0
     c                   exsr      srl_lp1
     c*                 ***       lfdSTKMAT = ek-(lp1Preis)                  */
     c                   eval      lfdSTKMAT = EK -LP1Preis + MGK
     c                   eval      lfdSTKMAT = EK -LP1Preis + MGK +
     c                                         FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdSTKMAT = EK           + MGK +
     c                                         FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdSTKLHN = LP1Preis
     c                   eval      lfdSTKLHN = LP1Preis
     c                   eval      lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdSTKFRA = 0
     c                   eval      lfdSTK    = ek + lfdstkfra + mgk
     c                   eval      lfdSTK    = ek + lfdstkfra + mgk +
     c                                         FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdMATKOS = ek - lp1preis + lfdSTKFRA
     c                   eval      lfdMATKOS = ek - lp1preis +
     c                                         FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdMATKOS = ek            +
     c                                         FRACHT + ZOLL + WAOFWF07
     c                   eval      lfdFERLOH = *zero
     c                   eval      lfdFERGKV = *zero
     c                   eval      lfdFERGKF = *zero
     c                   eval      lfdMATGKO = MGK
     c                   eval      lfdFMDLOH = lp1Preis
     c                   eval      lfdSTK1   = EK + lfdSTKFRA +
     c                                         (FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK2   = ek + lfdSTKFRA + mgk +
     c                                         (FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK3   = ek + lfdSTKFRA + mgk +
     c                                         (FRACHT + ZOLL + WAOFWF07)
     c*                 ***       Abgleich                                   */
     c                   clear                   abgleich1        11 2
     c                   clear                   abgleich2        11 2
     c                   eval(H)   abgleich1 = lfdstkmat + lfdstklhn + lfdstkfra
     c                   eval(H)   abgleich2 = ST3_KALK  - abgleich1
     c                   eval(H)   lfdstkfra = lfdstkfra + abgleich2
     c*                 ***       ........                                   */
     c                   eval      lfdMATKOS = ek - lp1preis + lfdSTKFRA  +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdMATKOS = ek            + lfdSTKFRA  +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK    = ek + lfdstkfra + mgk +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK    = ek + lfdstkfra + mgk + LP1Preis +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK1   = EK + lfdSTKFRA       +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK1   = EK + lfdSTKFRA       + LP1Preis +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK2   = ek + lfdSTKFRA + mgk +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK2   = ek + lfdSTKFRA + mgk + LP1Preis +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK3   = ek + lfdSTKFRA + mgk +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   eval      lfdSTK3   = ek + lfdSTKFRA + mgk + LP1Preis +
     c                                         ( FRACHT + ZOLL + WAOFWF07)
     c                   movel     '428'         ##invart
     c                   z-add     428           invart
     c                   eval      %subst(sup_item:01:03) = '428'
     c                   eval      %subst(sup_item:05:09) = '384300000'
     c                   movel     'A'           typgrp
     c                   if        Verlwbank =  '1'
     c                   move      '428'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c
     c*                 *** Handelsware 701                                  */
     C                   if        *IN77 =  '1'  and
     c                             (statnr = '417' or
     c                              statnr = '418' or
     c                              statnr = '419' or
     c                              statnr = '423' or
     c                              statnr = '327')
     C******************************            and lfdSTK3    =  *zero
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdSTK    = ST3_KALK
     c                   eval(H)   lfdSTK1   = ST3_KALK
     c                   eval(H)   lfdMATGKO = MGK
     c                   eval(H)   lfdSTK2   = ST3_KALK
     c                   eval(H)   lfdSTK3   = ST3_KALK
     c                   movel     '701'         ##invart
     c                   z-add     701           invart
     c                   movel     'Z'           typgrp
     c                   eval      %subst(sup_item:01:03) = '701'
     c                   eval      %subst(sup_item:05:09) = '384502000'
     c                   if        Fertigw =  '1'
     c                   move      '701'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c
     c*                 *** Handelsware 700   der ganze Rest                 */
     C                   if        *IN77 =  '1'
     C******************************            and lfdSTK3    =  *zero
     c                   eval(H)   lfdSTKMAT = ek
     c                   eval(H)   lfdSTKFRA = FRACHT + ZOLL + WAOFWF07
     c                   eval(H)   lfdSTK    = ST3_KALK
     c                   eval(H)   lfdSTK1   = ST3_KALK
     c                   eval(H)   lfdMATGKO = MGK
     c                   eval(H)   lfdSTK2   = ST3_KALK
     c                   eval(H)   lfdSTK3   = ST3_KALK
     c                   movel     '700'         ##invart
     c                   z-add     700           invart
     c                   movel     'Z'           typgrp
     c                   eval      %subst(sup_item:01:03) = '700'
     c                   eval      %subst(sup_item:05:09) = '384500000'
     c                   if        Fertigw =  '1'
     c                   move      '700'         BUCHUNG201
     c*                 *** lfdSTK3   =  0  ==> move      '0'           stk3   */
     c                   if        (stknull = '1' and
     c                              stk3    = '0') or
     c                              stknull = '0'
     c                   if        prj015upd = '1'
     c   77              update    prj015f
     c                   endif
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c*                 *                                                      */
     c   77              exsr      sr_konto
     c                   else
     c                   clear                   BUCHUNG201
     c                   endif
     c  n77              clear                   BUCHUNG201
     c   77              setoff                                       77
     C   77              clear                   buchung2
     C   77              eval      buchung2 = %char(##invart)+
     C                                        %char(%date())
     C                   endif
     c
     c                   endif
     c                   endif
     C*
     C     ##_EL_PS      ENDSR
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
      *     ================> ST3_KALK  ==> STK3_FIX
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
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ >2017 and
     c+         ST3_KALK   > 0  and (ARTSTATUS ='01' or ARTSTATUS ='80')
     c+                                             and anldat <> 0
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
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ >2017 and
     c+         ST3_KALK   > 0  and (ARTSTATUS ='01' or ARTSTATUS ='80')
     c+                                             and anldat <> 0
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
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '0101', 8) ab,
     c+ char(substr(char(current date +0 year, eur), 7, 4)
     c+       concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15), current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ >2017 and
     c+         ST3_KALK   > 0  and (ARTSTATUS ='01' or ARTSTATUS ='80')
     c+                                             and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and  (lieferant2 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))
     c***** and  (LIEFERANT1  = ' ' and LIEFERANT2 <>' ' ))
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


     c/exec sql
     c+ update  tvrelwaeco/#RP0540
     c+ set    RPMGUEVON = 20250101, RPMGUEBIS = 20251231
     c/end-exec

     c                   if        #art       <> *blank
     c/exec sql
     c+ delete from tvrelwaeco/#RP0540
     c+ where  $ARTNR <> :#art
     c/end-exec
     c                   endif


     C     ##8500        ENDSR

     C**************************************************************************
     C* LP1_lines  Einkaufspreise für verlängerte Werkbank
     C*-------------------------------------------------------------------------
     C*
     C*lp1 ********************************************************************
     C     srl_lp1       BEGSR
     C*
     c     KEY2030       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     WAOFVEUR      TETENR
     C*
     c     KEY2030       chain     teil01                             98
     C  n98              z-add     TELOGR        #TELOGR          11 0
     C   98              clear                   #TELOGR          11 0
     C*
     c                   extrct    date:*Y       pjahr             4 0
     c                   extrct    date:*M       pmonat            2 0
     C                   extrct    date:*D       ptag              2 0

     c                   eval      pjahr = pjahr + 0
     c                   clear                   xp                8 0
     c                   eval      xp=(pjahr*10000)+(pmonat*100)+ptag
     c                   clear                   lp1Preis         11 4
     c                   movel     '01'          PRFIRM
     c                   movel     'LP1'         PRBEGR
     c                   movel     LIEFERANT1    PRKDLI
     c                   movel     WAOFVEUR      PRTENR
     c                   movel     wacdek        PRWACD
     c                   clear                   PRGADA

     c     key7000b      klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLI
     c                   kfld                    PRTENR
     c                   kfld                    PRWACD
     c****               kfld                    PRGADA

     C     KEY7000b      SETLL     #PREIL5                            92
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL5                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'LP1'
     c     PRTENR        orne      WAOFVEUR
     c     PRWACD        orne      PRWACD
     C                   leave
     C                   else
     c                   if        PRTENR='9106600859' or
     c                             PRTENR='9104116106' or
     c                             PRTENR='9104116107'
     c                   clear                   ppp               1
     c                   endif
     c*                  if        ( PRGADA > xp or PRGADA = xp )
     c*
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C                   eval      lp1Preis    =  PREZPR
     c                   if        #telogr  > *zero
     c                   select
     c                   when      (prmg01 =  #TELOGR  or
     c                              prmg01 >  #TELOGR) and
     c                             prmg02 >  #TELOGR
     C                   eval      lp1Preis    =  prpr01
     c                   when      (prmg02 =  #TELOGR  or
     c                              prmg02 >  #TELOGR) and
     c                             prmg03 >  #TELOGR
     C                   eval      lp1Preis    =  prpr02
     c                   when      (prmg03 =  #TELOGR  or
     c                              prmg03 >  #TELOGR) and
     c                             prmg04 >  #TELOGR
     C                   eval      lp1Preis    =  prpr03
     c                   when      (prmg04 =  #TELOGR  or
     c                              prmg04 >  #TELOGR) and
     c                             prmg05 >  #TELOGR
     C                   eval      lp1Preis    =  prpr04
     c                   when      (prmg05 =  #TELOGR  or
     c                              prmg05 >  #TELOGR) and
     c                             prmg06 >  #TELOGR
     C                   eval      lp1Preis    =  prpr05
     c                   when      (prmg06 =  #TELOGR  or
     c                              prmg06 >  #TELOGR) and
     c                             prmg07 >  #TELOGR
     C                   eval      lp1Preis    =  prpr06
     c                   when      (prmg07 =  #TELOGR  or
     c                              prmg07 >  #TELOGR) and
     c                             prmg08 >  #TELOGR
     C                   eval      lp1Preis    =  prpr07
     c                   when      (prmg08 =  #TELOGR  or
     c                              prmg08 >  #TELOGR) and
     c                             prmg09 >  #TELOGR
     C                   eval      lp1Preis    =  prpr08
     c                   when      (prmg09 =  #TELOGR  or
     c                              prmg09 >  #TELOGR) and
     c                             prmg10 >  #TELOGR
     C                   eval      lp1Preis    =  prpr09
     c                   other
     C                   eval      lp1Preis    =  prpr10
     c                   endsl
     c                   endif
     c                   if        FAKTOR# = '5'
     C                   eval      lp1Preis    =  lp1Preis / 10000
     c                   endif
     c                   if        FAKTOR# = '4'
     C                   eval      lp1Preis    =  lp1Preis / 1000
     c                   endif
     c                   if        FAKTOR# = '3'
     C                   eval      lp1Preis    =  lp1Preis / 100
     c                   endif
     c                   if        FAKTOR# = '2'
     C                   eval      lp1Preis    =  lp1Preis / 10
     c                   endif
     C                   endif
     C                   endif
     C                   enddo
     C                   endif
     C
     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c                   kfld                    WAPLKZ
     c
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = PRWACD
     C                   eval      WAGADA  = xp
     C                   eval      WAPLKZ  = 'J'
     C                   z-add     1             wakurs
     C     KEY001        SETgt     WAEH01                             95
     C     *IN95         IFEQ      '0'
     C     PRWACD        andne     'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      PRWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      wagada    =   wagada
     c                   eval      wakurs    =   wakuvk
     C                   leave
     c                   ENDIF
     C                   enddo
     C                   endif
     C
     C
     C*lp1 ab jetzt 01.02.2022 aus kalkulation Trend **************************
     C                   eval      lp1Preis    =  Fremdl
     C
     C
     C
     C
     C     ##l_lp1       ENDSR
     C*
     C**************************************************************************
     C* sr_konto   Konto
     C*-------------------------------------------------------------------------
     C*
     C*lp1 ********************************************************************
     C     sr_konto      BEGSR
     C*
     c     KEY2030#      klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     WAOFVEUR      TETENR
     C*
     c     KEY2030#      chain     §teil01                            55
     C  n55              eval      TEWBKT = %subst(sup_item:05:09) + ' '
     c  n55              update    phy03r
     C
     C     ##_konto      ENDSR
     C*
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
                'ADDLIBLE LIB(PRODWIN51) POSITION(*LAST)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
         endmon;


         MONITOR;
            Wrk.var1 =
                'CLRPFM (TVRELWAECO/#RP0550b) ';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM (TVRELWAECO/#RP0550)  ';
               exsr      SR_log;
               err_msg = '1';
         endmon;


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

     C**   *** step 3 Kalkulationen Budget ermitteln                    */
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

     C**   *** step 4a evtl.Budgetdaten ermitteln  für upload        */
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

     C**   *** step 4b evtl.Budgetdaten ermitteln  für upload        */
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
                                        '_BUDG';

               §text          = *blank;
               §text          = %trimr(suffix) + ' ' +
                                transfer             +
                                ' '                  +
                                %char(§records);
               exsr      SR_report;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_BUDG';
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
                                        '_BUDG';

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
                                        '_BUDG';

       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''#RP0540B'') OVRSCOPE(*JOB)';
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
                                        '_BUDG';

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


       //300
       if        Kalk = '300';
       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/SALESCOMPANY/BUDGET/RPMKALKUL*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed BUDGET_RPMKALKUL*      ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object BUDGET_RPMKALKUL*         ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RPMKALKUL';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/BUDGET/'+ p_infil +''  +
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
           'CHGAUT OBJ(''/SALESCOMPANY/BUDGET/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/BUDGET)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/BUDGET)       ';
       endmon;
       endif;

       //200
       if        Kalk = '200';
       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/SALESCOMPANY/FIX/RPMKALKUL*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed BUDGET_RPMKALKUL*      ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object BUDGET_RPMKALKUL*         ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RPMKALKUL';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/FIX/'+ p_infil +''  +
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
           'CHGAUT OBJ(''/SALESCOMPANY/FIX/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/BUDGET)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/BUDGET)       ';
       endmon;
       endif;

       //001
       if        Kalk = '001';
       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/SALESCOMPANY/KALK/RPMKALKUL*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed BUDGET_RPMKALKUL*      ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object BUDGET_RPMKALKUL*         ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'RPMKALKUL';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/KALK/'+ p_infil +''  +
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
           'CHGAUT OBJ(''/SALESCOMPANY/KALK/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/BUDGET)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/BUDGET)       ';
       endmon;
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

       //-----------------------------------------------------------------------
       //ovrdbf für update teil!!!!!!!!!!!!!!!!!!!!!!!
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_ovrdbf;

       //Ausgabe der einzelnen Files über variable

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'OVRDBF FILE(§TEIL01) TOFILE(TVPF/TEIL01) OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRDBF successful TVPF/TEIL01                    ';
          exsr      SR_log;
       on-error;
          status='Error by OVRDBF successful TVPF/TEIL01           ';
          exsr      SR_log;
       endmon;

       endsr;

      /End-FREE

       //-----------------------------------------------------------------------
       //dltovr für update teil!!!!!!!!!!!!!!!!!!!!!!!
       //-----------------------------------------------------------------------

      /FREE
       begsr SR_dltovr;

       //Ausgabe der einzelnen Files über variable

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'DLTOVR FILE(§TEIL01) LVL(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='DLTOVR successful TVPF/TEIL01                    ';
          exsr      SR_log;
       on-error;
          status='Error by DLTOVR successful TVPF/TEIL01           ';
          exsr      SR_log;
       endmon;

       endsr;

      /End-FREE

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
