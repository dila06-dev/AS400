     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
     H BNDDIR('TRTXT') DFTACTGRP(*NO)
      //*************************************************************************
      /TITLE  Einlesen der Daten aus PSAVEAP2 von Erhard + Partner
      //*************************************************************************
      //  Copyright 2015 by trend SWM
      //                    Verwaltung GmbH
      //                    Gundelfinger Straße 11
      //                    DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 03.09.2015 Projekt 11427 Dometic WAECO
      //  -----------------------------------------------------------------------
      //  Änderung: SZ 27.10.2015 Aufbau der übergebenen Kom.-Schein-Nr. mit
      //            Mandant und 4-stelligem Jahr
      //  Änderung: SZ 28.11.2015 Buchungsdatum + -zeit aus anderen Feldern über-
      //            nehmen.
      //  Änderung: SZ 23.01.2016 Projekt 11998 erneute Verarbeitung und Druck
      //            Lieferschein.
      //  Änderung: SZ 30.01.2016 Projekt 11427, wegen Artikeln ohne Bestands-
      //            führung: Lesen AFPO und prüfen TEBSKZ sowie TETART. Dann
      //            schreiben zusätzliche IFKP Sätze für solche Artikel, die
      //            nicht von LFS zurückgemeldet werden.
      //  Änderung: SZ 01.02.2016 Projekt 11427, der ENDE Satz ist in Key L5 aus-
      //            geschlossen. Daher darf das Abschliessen nicht abhängig von
      //            Datensatz ENDE erfolgen.
      //  Änderung: MG 16.06.2016 Projekt 12321, Setzen Kz "Nachlieferung"
      //            bei Nullrückmeldung
      //*************************************************************************
      //
      //  Dieses Programm füllt die trend Standard Schnittstellenfile IFKP mit
      //  den Daten aus PSAVEAP2. Die eingelesenen Daten werden in PSAVEAP2 als
      //  verarbeitet gekennzeichnet.
      //  Das Programm wird über CALL WAIFKMST direkt aus E+P aufgerufen und
      //  verarbeitet jeweils nur die Daten aus dem übergebenen Arbeitspaket.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPSAVEAP2L5UF A E           K DISK    USROPN RENAME(PANFPOSF:PANFPOSFL5)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
      //
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
      //
     D AFPO          E DS                  INZ PREFIX(AFPO:2)
     D KYAFPO        E DS                  INZ
      //
     D AFUP          E DS                  INZ
     D KYAFUP        E DS                  INZ
      //
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
      //
     D IFKP          E DS                  INZ
     D KYIFKP        E DS                  INZ
     D WKIFKP        E DS                  EXTNAME(IFKP) PREFIX(WK) INZ
      //
     D LBAK          E DS                  INZ
     D KYLBAK        E DS                  INZ
      //
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
      //
     D PAUK          E DS                  INZ
     D KYPAUK        E DS                  INZ
      //
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
      //
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
      //
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
      //
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
      //
     D KYPSAVEAP2L5    DS                  LIKEREC(PANFPOSFL5:*KEY)
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  DEFINITION DER WORKFELDER...                                      ***
      //*************************************************************************
     D ##CHI           S              8
     D ##PGST          S              1
     D ##RTCD          S              1
     D WKTRTP          S              1
     D WKI000          S              1
     D WKIIFL          S              1
     D WKIGEN          S              1
     D WKIDAT          S              1
     D WKFENR          S              4
     D WKIFKPC100      S            100A
     D WKIFKPN080      S              8S 0
     D WKIFKPN100      S             10S 0
     D WKIFKPN134      S             13S 4
     D WKIFKPN145      S             14S 5
     D WKLSTCABG       S                   LIKE(IFKPLSTC)
     D WKLSTCAB2       S                   LIKE(IFKPLSTC)
     D WKLSTCUML       S                   LIKE(IFKPLSTC)
     D SVIFKPTENR      S                   LIKE(IFKPTENR)
     D SVIFKPBWMG      S                   LIKE(IFKPBWMG)
     D SVIFKPBWME      S                   LIKE(IFKPBWME)
     D SVIFKPTSTP      S                   LIKE(IFKPTSTP)
     D SVIFKPPOSI      S                   LIKE(IFKPPOSI)
     D SVIFKPKMPO      S                   LIKE(IFKPKMPO)
     D SVIFKPAFPO      S                   LIKE(IFKPAFPO)
     D SVIFKPAFUP      S                   LIKE(IFKPAFUP)
     D WKLFS_KONZ      S              3A
     D WKLFS_MAND      S              3A
     D WKLFS_APNR      S              9S 0
     D WKLFS_APPO      S              6S 0
     D WKLFS_SART      S              1A
     D WKLFS_FIRM      S                   LIKE(AMFIRM)
     D WKLFS_KMJJ      S                   LIKE(AMKMJJ)
     D WKLFS_KMNR      S                   LIKE(AMKMNR)
     D PCPGST          S                   LIKE(#CPGST)

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKIFKPTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKIFKPTSTP                        LIKE(WKIFKPTSTP)

      //--------------------------------------------------
      // Program name: C_INZDATASTR
      // Purpose:
      // Returns:
      // Parameter:      #EXDATA
      // Parameter:      #RTDATA
      //--------------------------------------------------
     D C_INZDATASTR...
     D                 PR                  EXTPGM('INZDATASTR')
     D  #EXDATA                            LIKEDS(EXDATA)
     D  #RTDATA                            LIKEDS(RTDATA)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
      /FREE
       EXSR UEBKOM;
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       OPEN PSAVEAP2L5;
       EXSR VPSAVEAP2;
       CLOSE PSAVEAP2L5;

       IF WKIDAT = *ON OR
         PCPGST = 'NDRUCK';
         EXSR ABSCH;
         #CRTCD = ' ';
       ELSE;
         #CRTCD = 'N';
       ENDIF;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYAMFI = DAFIRM;                                                         // AFKM
       KYAAFI = DAFIRM;                                                         // AFPA
       KYAPFI = DAFIRM;                                                         // AFPO
       KYAUFI = DAFIRM;                                                         // AFUP
       KYBBKMFIRM = DAFIRM;                                                     // BBKM
       KYLBAKFIRM = DAFIRM;                                                     // LBAK
       KYLBAPFIRM = DAFIRM;                                                     // LBAP
       KYIFKPFIRM = DAFIRM;                                                     // IFKP
       KYUKFI = DAFIRM;                                                         // PAUK
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYTEFI = DAFIRM;                                                         // TEIL

       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;

       WKLSTCABG = '130';                                                       // ABGANG VERSAND
       WKLSTCAB2 = '810';                                                       // ABGANG PRODUKTION
       WKLSTCUML = '950';                                                       // UMLAGERUNG

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOM-BEREICH                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

       CLEAR EXDATA;
       EXDATAFILE = 'EXTR02';
       EXDATADATA = EXTR02;
       C_INZDATASTR(EXDATA:RTDATA);
       EXTR02 = RTDATADATA;

       PCPGST = #CPGST;
       WKLFS_KONZ = %SUBST(#CKOMM:1:3);
       WKLFS_MAND = %SUBST(#CKOMM:4:3);
       MONITOR;
         WKLFS_APNR = %DEC(%SUBST(#CKOMM:7:9):9:0);
       ON-ERROR;
         WKLFS_APNR = 0;
       ENDMON;

       MONITOR;
         WKLFS_APPO = %DEC(%SUBST(#CKOMM:16:6):6:0);
       ON-ERROR;
         WKLFS_APPO = 0;
       ENDMON;

       // Kom.-Nummer wird in der Form Kffxxxxyyyyyy ab Stelle 22 übergeben
       // K = Kom.-Nummer
       // ff = Firma 2-stellig
       // xxxx = Jahr 4-stellig
       // yyyyyy = Kom.-Nummer 6-stellig
       MONITOR;
         WKLFS_KMJJ = %DEC(%SUBST(#CKOMM:25:4):4:0);
       ON-ERROR;
         WKLFS_KMJJ = 0;
       ENDMON;

       WKLFS_SART = %SUBST(#CKOMM:22:1);
       WKLFS_FIRM = %SUBST(#CKOMM:23:2);
       WKLFS_KMNR = %SUBST(#CKOMM:29:6);

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         WKIDAT = *OFF;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG DATEN VON LFS                                        ***
       //*************************************************************************
       BEGSR VPSAVEAP2;

       KYPSAVEAP2L5.APKONZ = WKLFS_KONZ;
       KYPSAVEAP2L5.APFIRM = WKLFS_MAND;
       KYPSAVEAP2L5.APAPN = WKLFS_APNR;
       KYPSAVEAP2L5.APAPPO = 0;
       SETLL %KDS(KYPSAVEAP2L5:4) PSAVEAP2L5;

       DOW NOT %EOF(PSAVEAP2L5) AND NOT %ERROR;
         WKIIFL = *OFF;
         READ PSAVEAP2L5;

         IF %EOF OR %ERROR OR
           APKONZ <> KYPSAVEAP2L5.APKONZ OR
           APFIRM <> KYPSAVEAP2L5.APFIRM OR
           APAPN <> KYPSAVEAP2L5.APAPN;
           LEAVE;
         ENDIF;

         EXSR INWKIFKP;

         IF WKIFKPFENR <> '0000';
           LEAVE;
         ENDIF;

         IF APVSH1 <> *ON;
           WKIIFL = *ON;
         ENDIF;

         IF PCPGST = 'NDRUCK';                                                  // ERNEUT VERARBEITE
           WKIIFL = *ON;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPSAVEAP2;
           EXSR EIFKP;
           WKIGEN = *OFF;
           EXSR UIFKP;
           EXSR UPSAVEAP2;
           WKIDAT = *ON;
         ELSE;
           WKIDAT = *OFF;
         ENDIF;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  INIFKP- Inititalisieren WKIFKP                                    ***
       //*************************************************************************
       BEGSR INWKIFKP;

       CLEAR WKIFKP;
       WKIFKPFIRM = DAFIRM;
       WKIFKPWKNR = '001';
       WKIFKPSTAT = '00';
       WKIFKPDTEI = 'PSAVEAP2';
       WKIFKPERZT = %DEC(%TIME());
       WKIFKPERDA = %DEC(%DATE():*ISO);
       WKIFKPERUS = DAUSER;
       WKIFKPFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR EIFKP;

       SELECT;
       WHEN WKIFKPDANA = 'AFKM';
         WKIFKPSZAR = '03';                                                     // Rückmeldung AFKM
         EXSR EAFKM;
       WHEN WKIFKPDANA = 'BBKM';
         WKIFKPSZAR = '20';                                                     // Beistellung
         EXSR EBBKM;
       WHEN WKIFKPDANA = 'PAUK';
         WKIFKPSZAR = '11';
         EXSR EPAUK;
       ENDSL;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ABSCHLIESSEN FÜR ARTIKEL OHNE BESTANDSFÜHRUNG                     ***
       //*************************************************************************
       BEGSR ABSCH;

       IF WKIDAT = *ON;
         WKIFKPSZAR = '03';
         EXSR PAFKM;
       ENDIF;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR KOMMISSIONIERUNG                              ***
       //*************************************************************************
       BEGSR EAFKM;

       KYAMJH = WKIFKPJAHR;
       KYAMKM = WKIFKPNMKR;
       CHIDS = '01C';
       EXSR CHAFKM;
       WKIFKPAFJJ = AMAFJJ;
       WKIFKPAFNR = AMAFNR;
       WKIFKPKMJJ = AMKMJJ;
       WKIFKPKMNR = AMKMNR;
       WKIFKPKMPO = *ZERO;
       // Setzen Kz. "Nachlieferung" bei Nullrückmeldung
       IF WKIFKPBWMG = *ZERO;
         WKIFKPNLKZ = DAJNKZ;
       ENDIF;

       KYAAAT = AMAFAT;
       CHIDS = '01C';
       EXSR CHAFPA;

       KYTENR = WKIFKPTENR;
       CHIDS = '01C';
       EXSR CHTEIL;
       WKIFKPBEM1 = TETBZ1;
       WKIFKPBEM2 = TETBZ2;

       KYLBAPDANA = WKIFKPDANA;
       KYLBAPJAHR = AMAFJJ;
       KYLBAPNMKR = AMAFNR;
       KYLBAPPOSI = WKIFKPPOSI;
       CHIDS = '01C';
       EXSR CHLBAP;

       KYAPKJ = WKIFKPJAHR;
       KYAPKN = WKIFKPNMKR;
       KYAPKP = WKIFKPPOSI;
       CHIDS = '13C';
       EXSR CHAFPO;
       WKIFKPAFPO = AFPOAFPO;

       IF WKIFKPAFUP <> *ZERO;
         KYAUJH = AFPOAFJJ;
         KYAUAF = AFPOAFNR;
         KYAUPO = WKIFKPAFPO;
         KYAUUP = WKIFKPAFUP;
         CHIDS = '01C';
         EXSR CHAFUP;
       ELSE;
         WKIFKPAFUP = *ZERO;
       ENDIF;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN POSITIONEN MIT ARTIKELN OHNE BESTANDSFÜHRUNG            ***
       //*************************************************************************
       BEGSR PAFKM;

       KYAMJH = WKIFKPJAHR;
       KYAMKM = WKIFKPNMKR;
       CHIDS = '01C';
       EXSR CHAFKM;
       WKIFKPAFJJ = AMAFJJ;
       WKIFKPAFNR = AMAFNR;
       WKIFKPKMJJ = AMKMJJ;
       WKIFKPKMNR = AMKMNR;
       WKIFKPKMPO = *ZERO;
       WKIGEN = *OFF;

       SVIFKPTENR = WKIFKPTENR;
       SVIFKPBWMG = WKIFKPBWMG;
       SVIFKPBWME = WKIFKPBWME;
       SVIFKPTSTP = WKIFKPTSTP;
       SVIFKPPOSI = WKIFKPPOSI;
       SVIFKPKMPO = WKIFKPKMPO;
       SVIFKPAFPO = WKIFKPAFPO;
       SVIFKPAFUP = WKIFKPAFUP;

       KYAPKJ = WKIFKPJAHR;
       KYAPKN = WKIFKPNMKR;
       KYAPKP = *ZERO;
       CHIDS = '13+';
       EXSR CHAFPO;

       DOW WKFENR = '0000' AND
         AFPOFIRM = KYAPFI AND
         AFPOKMJJ = KYAPKJ AND
         AFPOKMNR = KYAPKN;
         KYIFKPFIRM = AFPOFIRM;
         KYIFKPDANA = 'AFKM';
         KYIFKPJAHR = AFPOKMJJ;
         KYIFKPNMKR = AFPOKMNR;
         KYIFKPPOSI = AFPOKMPO;
         CHIDS = '02C';
         EXSR CHIFKP;

         IF WKFENR <> '0000';
           KYTENR = AFPOTENR;
           CHIDS = '01C';
           EXSR CHTEIL;

           IF TEBSKZ = DANEKZ AND TETART <> 'P';
             WKIFKPPOSI = AFPOKMPO;
             WKIFKPKMPO = AFPOKMPO;
             WKIFKPAFPO = AFPOAFPO;
             WKIFKPAFUP = *ZERO;
             WKIFKPRMMG = *ZERO;
             WKIFKPBWMG = AFPOKMMG;
             WKIFKPBWME = AFPOMEIN;
             WKIFKPTENR = TETENR;
             WKIFKPBEM1 = TETBZ1;
             WKIFKPBEM2 = TETBZ2;
             C_EXTSTP(WKIFKPTSTP);
             WKIFKPDAKY = *BLANK;
             WKIGEN = *ON;
             EXSR UIFKP;
           ENDIF;

         ENDIF;

         CHIDS = '13R';
         EXSR CHAFPO;
       ENDDO;

       WKIFKPKMPO = *ZERO;
       WKIFKPRMMG = *ZERO;
       WKIFKPBWMG = SVIFKPBWMG;
       WKIFKPBWME = SVIFKPBWME;
       WKIFKPTENR = SVIFKPTENR;
       WKIFKPBEM1 = *BLANK;
       WKIFKPBEM2 = *BLANK;
       WKIFKPTSTP = SVIFKPTSTP;
       WKIFKPDAKY = *BLANK;
       WKIFKPPOSI = SVIFKPPOSI;
       WKIFKPAFPO = SVIFKPAFPO;
       WKIFKPAFUP = SVIFKPAFUP;
       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BEISTELLKOMMISSIONIERUNG                      ***
       //*************************************************************************
       BEGSR EBBKM;

       KYBBKMKMJJ = WKIFKPJAHR;
       KYBBKMKMNR = WKIFKPNMKR;
       CHIDS = '01C';
       EXSR CHBBKM;
       WKIFKPAFJJ = BBKMBEJJ;
       WKIFKPAFNR = BBKMBENR;
       WKIFKPKMJJ = WKIFKPJAHR;
       WKIFKPKMNR = WKIFKPNMKR;
       WKIFKPKMPO = *ZERO;

       KYTENR = WKIFKPTENR;
       CHIDS = '01C';
       EXSR CHTEIL;
       WKIFKPBEM1 = TETBZ1;
       WKIFKPBEM2 = TETBZ2;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR PRODUKTIONSAUFTRAG                            ***
       //*************************************************************************
       BEGSR EPAUK;

       KYUKJH = WKIFKPJAHR;
       KYUKPP = WKIFKPNMKR;
       CHIDS = '01C';
       EXSR CHPAUK;

       KYTENR = WKIFKPTENR;
       CHIDS = '01C';
       EXSR CHTEIL;
       WKIFKPBEM1 = TETBZ1;
       WKIFKPBEM2 = TETBZ2;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR UIFKP;

       KYIFKPFIRM = WKIFKPFIRM;
       KYIFKPTSTP = WKIFKPTSTP;
       CHIDS = '01CU';
       EXSR CHIFKP;

       IFKPWKNR = WKIFKPWKNR;
       IFKPDANA = WKIFKPDANA;
       IFKPJAHR = WKIFKPJAHR;
       IFKPNMKR = WKIFKPNMKR;
       IFKPPOSI = WKIFKPPOSI;
       IFKPAFJJ = WKIFKPAFJJ;
       IFKPAFNR = WKIFKPAFNR;
       IFKPAFPO = WKIFKPAFPO;
       IFKPAFUP = WKIFKPAFUP;
       IFKPKMJJ = WKIFKPKMJJ;
       IFKPKMNR = WKIFKPKMNR;
       IFKPKMPO = WKIFKPKMPO;
       IFKPTENR = WKIFKPTENR;
       IFKPKDNR = WKIFKPKDNR;
       IFKPLSTC = WKIFKPLSTC;
       IFKPLBSC = WKIFKPLBSC;
       IFKPBSLA = WKIFKPBSLA;
       IFKPLANR = WKIFKPLANR;
       IFKPLORT = WKIFKPLORT;
       IFKPBWMG = WKIFKPBWMG;
       IFKPBWME = WKIFKPBWME;
       IFKPRMMG = WKIFKPRMMG;
       IFKPUBSL = WKIFKPUBSL;
       IFKPULAN = WKIFKPULAN;
       IFKPULOR = WKIFKPULOR;
       IFKPTMST = WKIFKPTMST;
       IFKPBEM1 = WKIFKPBEM1;
       IFKPBEM2 = WKIFKPBEM2;
       IFKPNLKZ = WKIFKPNLKZ;
       IFKPAFDN = WKIFKPAFDN;
       IFKPCHAR = WKIFKPCHAR;
       IFKPCHEX = WKIFKPCHEX;
       IFKPHSDA = WKIFKPHSDA;
       IFKPHSZT = WKIFKPHSZT;
       IFKPVEDA = WKIFKPVEDA;
       IFKPSTNR = WKIFKPSTNR;
       IFKPPCJJ = WKIFKPPCJJ;
       IFKPPCNR = WKIFKPPCNR;
       IFKPLAKZ = WKIFKPLAKZ;
       IFKPEXKZ = WKIFKPEXKZ;
       IFKPELBE = WKIFKPELBE;
       IFKPSTKZ = WKIFKPSTKZ;
       IFKPBEME = WKIFKPBEME;
       IFKPLPBE = WKIFKPLPBE;
       IFKPDAKY = WKIFKPDAKY;
       IFKPBUDA = WKIFKPBUDA;
       IFKPBUZT = WKIFKPBUZT;
       IFKPPAKN = WKIFKPPAKN;

       IFKPSZAR = WKIFKPSZAR;
       IFKPDTEI = WKIFKPDTEI;
       IFKPFENR = WKIFKPFENR;
       IFKPFFLD = WKIFKPFFLD;

       IFKPJNAM = WKIFKPJNAM;
       IFKPPROG = WKIFKPPROG;
       IFKPBIBL = WKIFKPBIBL;
       IFKPUSER = WKIFKPUSER;
       IFKPJZEI = WKIFKPJZEI;
       IFKPJDAT = WKIFKPJDAT;

       SELECT;
       WHEN CHI(6) = *OFF AND WKIGEN = *ON;
         IFKPERDA = WKIFKPERDA;
         IFKPERZT = WKIFKPERZT;
         IFKPERUS = WKIFKPERUS;
         IFKPSTAT = WKIFKPSTAT;
         C_EXTSTP(WKIFKPTSTP);
         CHIDS = '01W';
         EXSR CHIFKP;

         DOW CHI(05) = 'N';
           C_EXTSTP(WKIFKPTSTP);
           CHIDS = '01W';
           EXSR CHIFKP;
         ENDDO;
       WHEN CHI(6) = *ON;
         IFKPERDA = WKIFKPERDA;
         IFKPERZT = WKIFKPERZT;
         IFKPERUS = WKIFKPERUS;
         IFKPSTAT = WKIFKPSTAT;
         CHIDS = '01W';
         EXSR CHIFKP;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFKP;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPSAVEAP2;

         WKIFKPTSTP = %DATE(APDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(APTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(APTIDI:'X'):7:6):6:0));
         WKIFKPAFPO = APAPPO;

         IF APDTB <> 0;
           WKIFKPBUDA = APDTE;
         ELSE;
           WKIFKPBUDA = %DEC(%DATE():*ISO);
         ENDIF;

         IF APTIB <> 0;
           WKIFKPBUZT = APTIE;
         ELSE;
           WKIFKPBUZT = %DEC(%TIME());
         ENDIF;

         WKIFKPTENR = APIDEN;

         SELECT;
         WHEN APIDEN = 'ENDE' AND %SUBST(APANR1:1:1) = 'K';                      // letzte Pos.
           MONITOR;
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'AFKM';
           WKIFKPDAKY = 'ENDE';

         WHEN APANR1 <> *BLANK AND %SUBST(APANR1:1:1) = 'K';                     // Kom.-Schein
           MONITOR;
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'AFKM';
           WKIFKPLSTC = WKLSTCABG;

         WHEN APIDEN = 'ENDE' AND %SUBST(APANR1:1:1) = 'B';                      // letzte Pos.
           MONITOR;
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'BBKM';
           WKIFKPDAKY = 'ENDE';

         WHEN APANR1 <> *BLANK AND %SUBST(APANR1:1:1) = 'B';                     // Beistellung
           MONITOR;
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'BBKM';
           WKIFKPLSTC = WKLSTCABG;

         WHEN APIDEN = 'ENDE' AND %SUBST(APANR1:1:1) = 'T';                      // letzte Pos.
           MONITOR;                                                              // Trägergestell
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'AFKM';
           WKIFKPDAKY = 'ENDE';

         WHEN APANR1 <> *BLANK AND %SUBST(APANR1:1:1) = 'T';                     // Kom.-Schein
           MONITOR;                                                              // Trägergestell
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'AFKM';
           WKIFKPLSTC = WKLSTCABG;

         WHEN APANR1 <> *BLANK AND %SUBST(APANR1:1:1) = 'P';                     // Prod.-Auftrag
           MONITOR;
             WKIFKPJAHR = %DEC(%SUBST(APANR1:4:4):4:0);
           ON-ERROR;
             WKIFKPJAHR = 0;
           ENDMON;

           WKIFKPNMKR = %SUBST(APANR1:8:6);
           WKIFKPPOSI = APANRP;
           WKIFKPAFUP = APRN5;
           WKIFKPDANA = 'PAUK';
           WKIFKPLSTC = WKLSTCAB2;
         ENDSL;

         WKIFKPKDNR = APKDNR;
         WKIFKPLBSC = *BLANK;
         WKIFKPBSLA = *BLANK;
         WKIFKPLANR = APORT;
         WKIFKPLORT = APORT;

         IF WKIFKPLANR = *BLANK;
           WKIFKPLANR = '001';
           WKIFKPLORT = '001';
         ENDIF;

         IF APSTEU = 'OEM';
           WKIFKPBWMG = APALM;                                                   // Kom.-Menge
         ELSE;
           WKIFKPBWMG = APPM1;                                                   // verpackte Menge
         ENDIF;

         SELECT;
         WHEN APME = 'St';
           WKIFKPBWME = 'S';
         WHEN APME = 'Kg';
           WKIFKPBWME = 'K';
         OTHER;
           WKIFKPBWME = APME;
         ENDSL;

         WKIFKPRMMG = *ZERO;
         WKIFKPUBSL = *BLANK;
         WKIFKPULAN = *BLANK;
         WKIFKPULOR = *BLANK;
         WKIFKPTMST = *ZERO;
         WKIFKPBEM1 = *BLANK;
         WKIFKPBEM2 = *BLANK;
         WKIFKPNLKZ = *BLANK;
         WKIFKPAFDN = *BLANK;
         WKIFKPCHAR = APPRNR;
         WKIFKPCHEX = *BLANK;
         WKIFKPHSDA = *ZERO;
         WKIFKPHSZT = *ZERO;
         WKIFKPVEDA = *ZERO;
         WKIFKPSTNR = *BLANK;
         WKIFKPPCJJ = *ZERO;
         WKIFKPPCNR = *BLANK;
         WKIFKPLAKZ = *BLANK;
         WKIFKPEXKZ = *BLANK;
         WKIFKPELBE = *BLANK;
         WKIFKPSTKZ = *BLANK;
         WKIFKPBEME = %CHAR(APHW);
         WKIFKPLPBE = *BLANK;
         WKIFKPPAKN = APSNDG;

         WKIFKPJNAM = APBS;
         WKIFKPPROG = APPGM;
         WKIFKPBIBL = WKCHPL;
         WKIFKPUSER = APUSER;

         IF APDTB <> 0;
           WKIFKPJDAT = APDTB;
         ELSE;
           WKIFKPJDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF APTIB <> 0;
           WKIFKPJZEI = APTIB;
         ELSE;
           WKIFKPJZEI = %DEC(%TIME());
         ENDIF;
       ENDSR;
       //-------------------------------------------------------------------------------------------
       // Die nachfolgend aufgeführten Felder entsprechen in Ausprägung und Reihenfolge den Feldern
       // in der File PSAVEAP2.
       // Wenn der Inhalt aus zusätzlichen Feldern nach trend übernommen werden soll, dann die
       // Felder in den Bereich über die Linie kopieren (nicht ausschneiden). Danke.
       //
       BEGSR DUMMY;

         WKIFKPC100 = APKONZ;     // EMS                           A    1    3    KONZERN
         WKIFKPC100 = APFIRM;     // DWI                           A    4    6    FIRMA
         WKIFKPN100 = APLFDN;     // z.B. 100680237 oder 0         S    7   15 0  LFD NUMMER
         WKIFKPN100 = APAPN;      // z.B. 100245051, immer gefüllt S   16   24 0  ARBEITS- PAKET-NR
         WKIFKPN100 = APAPPO;     // 0, 1, 2, 3, ...               S   25   30 0  ARBEITS- PAKET-POS
         WKIFKPN100 = APAPN1;     // 0                             S   31   39 0  AP-NR 1.K-STUFE
         WKIFKPN100 = APAPP1;     // 0                             S   40   45 0  AP-POS 1.K-STUFE
         WKIFKPN100 = APAPN2;     // 0                             S   46   54 0  AP-NR 2.K-STUFE
         WKIFKPN100 = APAPN3;     // 0                             S   55   63 0  ALTE AP-NR
         WKIFKPN100 = APAPP3;     // 0                             S   64   69 0  ALTE AP-NR POS.
         WKIFKPN100 = APUAPN;     // 0                             S   70   78 0  URSPRUNGS- ARB-PAK
         WKIFKPN100 = APUAPP;     // 0                             S   79   84 0  URSPRUNGS- ARB-PAK
         WKIFKPC100 = APUSTS;     // *BLANK                        A   85   85    URSPR. STS LFS
         WKIFKPC100 = APUKZH;     // *BLANK                        A   86   86    KZ HERK. 1=UR
         WKIFKPN100 = APULFD;     // 0                             S   87   95 0  LFDN-SATZ-NR UR-AR
         WKIFKPN100 = APAPNA;     // 0                             S   96  104 0  ANHÄNGENDES ARB-PA
         WKIFKPN100 = APAPPA;     // 0                             S  105  110 0  ANHÄNGENDE ARB-PAK
         WKIFKPC100 = APSAP3;     // *BLANK                        A  111  111    STATUS APN3
         WKIFKPN100 = APREVG;     // 0                             S  112  120 0  NR. RESERV. VORGAN
         WKIFKPC100 = APSTEU;     // LFS, *BLANK                   A  121  124    KENNZ. STEUERER
         WKIFKPC100 = APGKZ;      // z.B. 4702, 4621, *BLANK       A  125  128    GRUPPIERUNGS- KZ
         WKIFKPC100 = APTOUR;     // z.B. KOLTI, LTZ, DAS4         A  129  134    TOUR
         WKIFKPC100 = APVART;     // z.B. 029, 008, 113, ...       A  135  138    VERSAND- ART
         WKIFKPC100 = APSSC;      // *BLANK                        A  139  142    VERSAND- SERVICE-C
         WKIFKPC100 = APAART;     // *BLANK                        A  143  146    AUFTRAGS- ART
         WKIFKPC100 = APAARF;     // *BLANK                        A  147  150    AUFTRAGS- FEIN-KOM
         WKIFKPC100 = APAPSR;     // *BLANK                        A  151  160    AP-SERIE/WAVE
         WKIFKPN100 = APAPSP;     // 0                             S  161  163 0  SERIE/WAVE POS.
         WKIFKPN100 = APDTB;      // z.B. 20150907 oder 0          S  164  171 0  BEREITST. DATUM
         WKIFKPN100 = APTIB;      // z.B. 104218 oder 0            S  172  177 0  BEREITST. ZEIT
         WKIFKPC100 = APTZB;      // *BLANK                        A  178  187    ZEIT- ZONE
         WKIFKPC100 = APTKZ;      // *BLANK                        A  188  188    TERMIN KZ.
         WKIFKPC100 = APACWA;     // *BLANK                        A  189  190    AKTIONSCODE WAREN-
         WKIFKPC100 = APWEKZ;     // *BLANK                        A  191  191    WAREN- KZ. ALT
         WKIFKPC100 = APWAKZ;     // *BLANK                        A  192  192    WAREN- KENNZEICHEN
         WKIFKPC100 = APKOMA;     // *BLANK                        A  193  193    KONSI- MAT.
         WKIFKPC100 = APOWNR;     // *BLANK                        A  194  203    EIGENTÜMER
         WKIFKPC100 = APSCHS;     // *BLANK                        A  204  204    KZ FÜR SCHNELLSCHU
         WKIFKPC100 = APORT;      // *BLANK                        A  205  207    LAGER- ORT
         WKIFKPC100 = APBER;      // *BLANK                        A  208  209    LAGER- BER.
         WKIFKPN100 = APSST;      // z.B. 320, 0                   S  210  212 0  SST NUMMER
         WKIFKPC100 = APBHF;      // z.B. Packplatz, WA, VERSAND   A  213  222    BAHNHOF
         WKIFKPC100 = APALP;      // *BLANK                        A  223  232    AUSLAGER- PUNKT
         WKIFKPC100 = APHW;       // *BLANK                        C  233  312    TRANSPORT HINWEIS
         WKIFKPC100 = APBAUG;     // *BLANK                        A  313  322    BAUGRUPPE
         WKIFKPC100 = APFNR1;     // *BLANK                        A  323  347    FERTIG.-NR
         WKIFKPN100 = APFNRP;     // 0                             S  348  353 0  FERTIG. POS
         WKIFKPC100 = APBST1;     // *BLANK                        A  354  378    BESTELL-NR
         WKIFKPN100 = APBSTP;     // 0                             S  379  384 0  BESTELL- POS
         WKIFKPC100 = APKDNR;     // z.B. TEST-53                  A  385  394    KUNDEN-NR
         WKIFKPC100 = APLSNR;     // z.B. 111111, 222222           A  395  410    LIEFERSCHEIN- NUMM
         WKIFKPN100 = APLSNP;     // 0                             S  411  415 0  LIEFERSCHEIN- POSI
         WKIFKPC100 = APANR1;     // z.B. DASTEST01                A  416  440    AUFTRAGS-NR. KUNDE
         WKIFKPN100 = APANRP;     // 0, 1, 2, 3, ...               S  441  446 0  AUFTRAGS-NR. KUNDE
         WKIFKPC100 = APPRNR;     // *BLANK                        A  447  461    PRÜF-NR/CHARGE
         WKIFKPC100 = APREVS;     // *BLANK                        A  462  481    REVISIONS- STAND
         WKIFKPC100 = APSRN;      // *BLANK                        A  482  506    SERIENNUMMER
         WKIFKPC100 = APPRN;      // *BLANK                        A  507  531    PROJEKTNUMMER
         WKIFKPN100 = APKST;      // 0                             S  532  538 0  KOSTEN- STELLE
         WKIFKPC100 = APIDEN;     // z.B. 9105305738, ENDE (!)     A  539  566    ARTIKELNUMMER
         WKIFKPC100 = APIDV;      // *BLANK                        A  567  581    ARTIKELVARIANTE
         WKIFKPC100 = APIDVA;     // *BLANK                        A  582  596    ZUSATZART. VARIANT
         WKIFKPN100 = APBSTM;     // z.B. 35,000                   S  597  607 3  BESTELL- MENGE
         WKIFKPN100 = APANFM;     // z.B. 35,000                   S  608  618 3  ANFORDERUNGS- MENG
         WKIFKPN100 = APRESM;     // z.B. 35,000                   S  619  629 3  RESERVIERTE MENGE
         WKIFKPN100 = APSBM;      // 0                             S  630  640 3  SOF.BEREITST- MENG
         WKIFKPN100 = APALM;      // z.B. 35,000                   S  641  651 3  BEREITS AUSGEL MEN
         WKIFKPN100 = APHMENR;    // 0                             S  652  662 3  HILFS-MENGE RES-LA
         WKIFKPN100 = APZMEN;     // 0                             S  663  673 3  RÜCKLIEFER MENGE
         WKIFKPN100 = APPM1;      // z.B. 35,000                   S  674  684 3  VERPACKTE MENGE
         WKIFKPN100 = APPM2;      // z.B. 35,000                   S  685  695 3  VERLADENE MENGE
         WKIFKPN100 = APPM3;      // 0                             S  696  706 3  PACKMENGE 3
         WKIFKPN100 = APPM4;      // 0                             S  707  717 3  PACKMENGE 4
         WKIFKPN100 = APDQTY;     // 0                             S  718  728 3  GELIEFERTE MENGE
         WKIFKPN100 = APNTSQT;    // z.B. 35,000                   S  729  739 3  NICHTVERSTERM- GER
         WKIFKPN100 = APRQTO;     // 0                             S  740  750 3  RETOUR.MENGE EIGEN
         WKIFKPN100 = APRQTE;     // 0                             S  751  761 3  RETOUR.MENGE FREMD
         WKIFKPN100 = APSEPM;     // 0                             S  762  772 3  SEPARIERTE MENGE
         WKIFKPC100 = APIAKZ;     // *BLANK                        A  773  773    INAKTIV- KZ
         WKIFKPC100 = APTXTP;     // *BLANK                        C  774  853    TEXT GEPARKTE WARE
         WKIFKPC100 = APKZP;      // *BLANK                        A  854  854    KZ GEPARKTE WARE
         WKIFKPC100 = APAVEN;     // *BLANK                        A  855  900    ANGEFORDERTE- VERS
         WKIFKPC100 = APQKZ;      // *BLANK                        A  901  902    QUALITÄTS- KENNZEI
         WKIFKPN100 = APKZEI;     // 0,00                          S  903  908 2  KOMM-ZEIT IN SEK
         WKIFKPN100 = APKGEW;     // z.B. 765,695                  S  909  922 5  KOMM-GEWICHT IN KG
         WKIFKPN100 = APKVOL;     // 0,000                         S  923  931 3  KOMM-VOLUMEN IN M3
         WKIFKPN100 = APEPR;      // 0,0000                        S  932  942 4  EINZEL- PREIS
         WKIFKPC100 = APWAE;      // *BLANK                        A  943  945    WAEHRUNGS- SCHLÜSS
         WKIFKPC100 = APSNDG;     // *BLANK                        A  946  955    SENDUNGS-NR.
         WKIFKPC100 = APVENR;     // *BLANK                        A  956 1001    VERSANDEINHEITEN-
         WKIFKPC100 = APKSTR;     // *BLANK                        A 1002 1002    KOMM- STRAT.
         WKIFKPN100 = APRELF;     // z.B. 311233                   S 1003 1011 0  Lfdn Res-Lauf
         WKIFKPC100 = APATYP;     // z.B. 1, *BLANK                A 1012 1012    AUFTRAGS- TYP
         WKIFKPN100 = APPLST;     // 0                             S 1013 1013 0  PACK- LISTE
         WKIFKPC100 = APBEM1;     // *BLANK                        C 1014 1065    ARTIKELBEMERKUNG 1
         WKIFKPC100 = APBEM2;     // *BLANK                        C 1066 1117    ARTIKELBEMERKUNG 2
         WKIFKPC100 = APBEM3;     // *BLANK                        C 1118 1169    ARTIKELBEMERKUNG 3
         WKIFKPC100 = APTLVB;     // *BLANK                        A 1170 1170    TEILLIEFER VERBOT
         WKIFKPN100 = APARKO;     // 0                             S 1171 1171 0  ART-REIN KOMMISS.
         WKIFKPC100 = APIDE2;     // *BLANK                        A 1172 1199    HERZUST. ARTIKEL
         WKIFKPC100 = APIDV2;     // *BLANK                        A 1200 1214    HERZUST. ARTIKELVA
         WKIFKPC100 = APIDV2A;    // *BLANK                        A 1215 1229    HERZUST. ARTIKELVA
         WKIFKPC100 = APIDEK;     // *BLANK                        A 1230 1257    KUNDEN- ARTIKEL
         WKIFKPC100 = APIDVK;     // *BLANK                        A 1258 1272    KUNDEN- ARTIKELVAR
         WKIFKPC100 = APPAK2;     // *BLANK                        A 1273 1274    HERZUST. PAKO KZ
         WKIFKPN100 = APBMEN;     // 0,000                         S 1275 1285 3  HERZUST. MENGE
         WKIFKPN100 = APHMEN;     // 0,000                         S 1286 1296 3  BEREITS HERGEST.ME
         WKIFKPC100 = APME2;      // *BLANK                        A 1297 1299    MENGEN- EINHEIT
         WKIFKPC100 = APLM;       // z.B. 112, 212, 116, *BLANK    A 1300 1302    LADE- MITTEL
         WKIFKPN100 = APMLM;      // 0,000                         S 1303 1313 3  MENGE JE LADEMITTE
         WKIFKPC100 = APME;       // z.B. S, *BLANK                A 1314 1316    MENGEN- EINHEIT
         WKIFKPC100 = APHUM;      // *BLANK                        A 1317 1319    UNIT OF MEASURE HO
         WKIFKPC100 = APHUMI;     // *BLANK                        A 1320 1322    UNIT OF MEASURE IS
         WKIFKPC100 = APHUS;      // *BLANK                        A 1323 1325    UNIT OF MEASURE HO
         WKIFKPC100 = APHUSI;     // *BLANK                        A 1326 1328    UNIT OF MEASURE IS
         WKIFKPC100 = APRKZ;      // z.B. G, *BLANK                A 1329 1330    RES.KZ HOST
         WKIFKPC100 = APALKZ;     // z.B. A, *BLANK                A 1331 1331    AUSL-KZ START
         WKIFKPC100 = APRSTR;     // *BLANK                        A 1332 1332    RESERV- STRAT.
         WKIFKPC100 = APSTS1;     // *BLANK                        A 1333 1333    VERARB. STS LFS
         WKIFKPC100 = APSTS2;     // *BLANK                        A 1334 1334    VERARB.STS  AB-SYS
         WKIFKPC100 = APIPKT;     // *BLANK                        A 1335 1336    I-PUNKT
         WKIFKPC100 = APFRG;      // z.B. F, *BLANK                A 1337 1337    FREIG.KZ ZUR AUSL.
         WKIFKPC100 = APDISP;     // *BLANK                        A 1338 1338    DISPONENT
         WKIFKPC100 = APKZHK;     // *BLANK                        A 1339 1339    KZ HERK.
         WKIFKPN100 = APPOSP;     // 0                             S 1340 1340 0  POSITION AUFBRECHE
         WKIFKPC100 = APMODG;     // *BLANK                        A 1341 1342    MODIFIKATIONS- GRU
         WKIFKPC100 = APMOPR;     // *BLANK                        A 1343 1344    MODIFIKATIONS- PRO
         WKIFKPC100 = APANB;      // *BLANK                        A 1345 1347    ANBINDUNG AN
         WKIFKPC100 = APRFNR;     // *BLANK                        A 1348 1397    REFERENZ-NUMMER
         WKIFKPC100 = APIDOC;     // *BLANK                        A 1398 1413    SAP IDOC-NUMMER
         WKIFKPC100 = APGRKO;     // 01                            A 1414 1415    KZ GRUPPEN- KOMM
         WKIFKPC100 = APSPID;     // *BLANK                        A 1416 1418    SPRACHEN ID
         WKIFKPC100 = APUSR;      // *BLANK                        A 1419 1428    USER LETZTE MODI.
         WKIFKPC100 = APTERM;     // *BLANK                        A 1429 1438    TERMINAL LETZTE MO
         WKIFKPN100 = APDTM;      // 0                             S 1439 1446 0  MODIFIK. DATUM
         WKIFKPN100 = APTIM;      // 0                             S 1447 1452 0  MODIFIK. ZEIT
         WKIFKPC100 = APTZM;      // *BLANK                        A 1453 1462    ZEIT- ZONE
         WKIFKPN100 = APLFD1;     // 0                             S 1463 1471 0  LFDN-SATZ-NR AP-ST
         WKIFKPN100 = APMDE3;     // 0                             S 1472 1473 0  PRIO AUSL/UML. MDE
         WKIFKPC100 = APPAKO;     // *BLANK                        A 1474 1475    KZ PAKO KO,PA,..
         WKIFKPC100 = APCDPA;     // *BLANK                        A 1476 1478    CODE PREISAUSZ.
         WKIFKPC100 = APMCD;      // *BLANK                        A 1479 1481    MANIPUL.- CODE
         WKIFKPC100 = APLWEG;     // *BLANK                        A 1482 1491    LAUFWEG
         WKIFKPC100 = APABR1;     // *BLANK                        A 1492 1493    ART-GR. LOG-DL
         WKIFKPC100 = APABR2;     // *BLANK                        A 1494 1497    ABR-SCHL. IST (ABR
         WKIFKPC100 = APABR3;     // *BLANK                        A 1498 1501    ABR-SCHL. VP SOLL
         WKIFKPC100 = APABR4;     // *BLANK                        A 1502 1505    ABR-SCHL. KO SOLL
         WKIFKPC100 = APABR5;     // *BLANK                        A 1506 1515    ABRECHN.- KZ 5
         WKIFKPC100 = APABR6;     // *BLANK                        A 1516 1525    ABRECHN.- KZ 6
         WKIFKPN100 = APSENR;     // 0,0                           S 1526 1534 1  SETBILDUNGS- NUMME
         WKIFKPC100 = APSTCD;     // *BLANK                        A 1535 1535    MWST- ART
         WKIFKPN100 = APMWSZ;     // 0,00                          S 1536 1539 2  MWST-SATZ [%]
         WKIFKPN100 = APDSCO;     // 0,000                         S 1540 1546 4  RABATT
         WKIFKPN100 = AP3RPD;     // 0                             S 1547 1547 0  STRECKEN GESCHAEFT
         WKIFKPC100 = AP3PRN;     // *BLANK                        A 1548 1572    STR.-GESCH REFEREN
         WKIFKPN100 = AP3PRP;     // 0                             S 1573 1578 0  STR.-GESCH REF-POS
         WKIFKPN100 = APADDU;     // 0                             S 1579 1579 0  AVIS.- PFLICHT
         WKIFKPN100 = APGRTS;     // 0                             S 1580 1580 0  GRATIS
         WKIFKPC100 = APRQI1;     // *BLANK                        A 1581 1584    ANFORD. KZ 1
         WKIFKPC100 = APRQK1;     // *BLANK                        A 1585 1604    ANFORD. SCHLÜSSEL
         WKIFKPC100 = APRQI2;     // *BLANK                        A 1605 1608    ANFORD. KZ 2
         WKIFKPC100 = APRQK2;     // *BLANK                        A 1609 1628    ANFORD. SCHLÜSSEL
         WKIFKPC100 = APRQI3;     // *BLANK                        A 1629 1632    ANFORD. KZ 3
         WKIFKPC100 = APRQK3;     // *BLANK                        A 1633 1652    ANFORD. SCHLÜSSEL
         WKIFKPC100 = APORTH;     // *BLANK                        A 1653 1655    ORDER TYPE HOST
         WKIFKPN100 = APMWKZ;     // 0                             S 1656 1656 0  MEHRWEG KZ
         WKIFKPC100 = APSHMT;     // *BLANK                        A 1657 1666    LIEFERUNG
         WKIFKPC100 = APJISPG;    // *BLANK                        A 1667 1670    JIS PROD-GRP
         WKIFKPC100 = APJISPL;    // *BLANK                        A 1671 1673    JIS PROD-LINE
         WKIFKPC100 = APJISSQ;    // *BLANK                        A 1674 1678    JIS SEQUENZ
         WKIFKPC100 = APOURF1;    // *BLANK                        A 1679 1708    OUTBOUND REFERENCE
         WKIFKPC100 = APOURF2;    // *BLANK                        A 1709 1738    OUTBOUND REFERENCE
         WKIFKPC100 = APOURF3;    // *BLANK                        A 1739 1768    OUTBOUND REFERENCE
         WKIFKPC100 = APVAS1;     // *BLANK                        A 1769 1778    VAS PROFIL 1
         WKIFKPC100 = APVAS2;     // *BLANK                        A 1779 1788    VAS PROFIL 2
         WKIFKPC100 = APVAS3;     // *BLANK                        A 1789 1798    VAS PROFIL 3
         WKIFKPC100 = APVAS4;     // *BLANK                        A 1799 1808    VAS PROFIL 4
         WKIFKPC100 = APVAS5;     // *BLANK                        A 1809 1818    VAS PROFIL 5
         WKIFKPC100 = APVAS6;     // *BLANK                        A 1819 1828    VAS PROFIL 6
         WKIFKPC100 = APVAS7;     // *BLANK                        A 1829 1838    VAS PROFIL 7
         WKIFKPC100 = APVAS8;     // *BLANK                        A 1839 1848    VAS PROFIL 8
         WKIFKPC100 = APVAS9;     // *BLANK                        A 1849 1858    VAS PROFIL 9
         WKIFKPN100 = APVSQ1;     // 0                             S 1859 1859 0  VAS REIHENFOLGE 1
         WKIFKPN100 = APVSQ2;     // 0                             S 1860 1860 0  VAS REIHENFOLGE 2
         WKIFKPN100 = APVSQ3;     // 0                             S 1861 1861 0  VAS REIHENFOLGE 3
         WKIFKPN100 = APVSQ4;     // 0                             S 1862 1862 0  VAS REIHENFOLGE 4
         WKIFKPN100 = APVSQ5;     // 0                             S 1863 1863 0  VAS REIHENFOLGE 5
         WKIFKPN100 = APVSQ6;     // 0                             S 1864 1864 0  VAS REIHENFOLGE 6
         WKIFKPN100 = APVSQ7;     // 0                             S 1865 1865 0  VAS REIHENFOLGE 7
         WKIFKPN100 = APVSQ8;     // 0                             S 1866 1866 0  VAS REIHENFOLGE 8
         WKIFKPN100 = APVSQ9;     // 0                             S 1867 1867 0  VAS REIHENFOLGE 9
         WKIFKPN100 = APRTNR;     // z.B. 30403                    S 1868 1876 0  RETOUREN- NUMMER
         WKIFKPC100 = APRTTI;     // *BLANK                        A 1877 1879    RÜCKLIEFER- FRIST
         WKIFKPC100 = APUNNR;     // *BLANK                        A 1880 1883    UN-NUMMER GGVS
         WKIFKPN100 = APRN1;      // 0                             S 1884 1884 0  RES-1,0 RN1
         WKIFKPN100 = APRN2;      // 0                             S 1885 1886 0  RES-2,0 RN2
         WKIFKPN100 = APRN5;      // 0                             S 1887 1891 0  RES-5,0 RN5
         WKIFKPN100 = APRN7;      // 0                             S 1892 1898 0  RES-7,0 RN7
         WKIFKPN100 = APRN9;      // 0                             S 1899 1907 0  RES-9,0 RN9
         WKIFKPN100 = APRN92;     // 0,00                          S 1908 1916 2  RES-9,2 RN92
         WKIFKPN100 = APRN113;    // 0,000                         S 1917 1927 3  RES-11,3 RN113
         WKIFKPN100 = APRN114;    // 0,0000                        S 1928 1938 4  RES-11,4 RN114
         WKIFKPC100 = APRA1;      // *BLANK                        A 1939 1939    RES-1A RA1
         WKIFKPC100 = APRA2;      // *BLANK                        A 1940 1941    RES-2A RA2
         WKIFKPC100 = APRA3;      // *BLANK                        A 1942 1944    RES-3A RA3
         WKIFKPC100 = APRA4;      // *BLANK                        A 1945 1948    RES-4A RA4
         WKIFKPC100 = APRA5;      // *BLANK                        A 1949 1953    RES-5A RA5
         WKIFKPC100 = APRA7;      // *BLANK                        A 1954 1960    RES-7A RA7
         WKIFKPC100 = APRA10;     // *BLANK                        A 1961 1970    RES-10A RA10
         WKIFKPC100 = APRA13;     // *BLANK                        A 1971 1983    RES-13A RA13
         WKIFKPC100 = APRA15;     // *BLANK                        A 1984 1998    RES-15A RA15
         WKIFKPC100 = APRA18;     // *BLANK                        A 1999 2016    RES-18A RA18
         WKIFKPN100 = APFN1;      // 0                             S 2017 2017 0  RES-1,0 FN1
         WKIFKPN100 = APFN2;      // 0                             S 2018 2019 0  RES-2,0 FN2
         WKIFKPN100 = APFN5;      // 0                             S 2020 2024 0  RES-5,0 FN5
         WKIFKPN100 = APFN7;      // 0                             S 2025 2031 0  RES-7,0 FN7
         WKIFKPN100 = APFN9;      // 0                             S 2032 2040 0  RES-9,0 FN9
         WKIFKPN100 = APFN92;     // 0,00                          S 2041 2049 2  RES-9,2 FN92
         WKIFKPN100 = APFN113;    // 0,000                         S 2050 2060 3  RES-11,3 FN113
         WKIFKPN100 = APFN114;    // 0,0000                        S 2061 2071 4  RES-11,4 FN114
         WKIFKPC100 = APFA1;      // *BLANK                        A 2072 2072    RES-1A FA1
         WKIFKPC100 = APFA2;      // *BLANK                        A 2073 2074    RES-2A FA2
         WKIFKPC100 = APFA3;      // *BLANK                        A 2075 2077    RES-3A FA3
         WKIFKPC100 = APFA4;      // *BLANK                        A 2078 2081    RES-4A FA4
         WKIFKPC100 = APFA5;      // *BLANK                        A 2082 2086    RES-5A FA5
         WKIFKPC100 = APFA7;      // *BLANK                        A 2087 2093    RES-7A FA7
         WKIFKPC100 = APFA10;     // *BLANK                        A 2094 2103    RES-10A FA10
         WKIFKPC100 = APFA13;     // *BLANK                        A 2104 2116    RES-13A FA13
         WKIFKPC100 = APFA15;     // *BLANK                        A 2117 2131    RES-15A FA15
         WKIFKPC100 = APFA18;     // *BLANK                        A 2132 2149    RES-18A FA18
         WKIFKPN100 = APDTE;      // z.B. 20150907                 S 2150 2157 0  ERL./RÜCKCH. DATUM
         WKIFKPN100 = APTIE;      // z.B. 103848                   S 2158 2163 0  ERL./RÜCKCH. ZEIT
         WKIFKPC100 = APTZE;      // *BLANK                        A 2164 2173    ZEIT- ZONE
         WKIFKPC100 = APUSER;     // z.B. LUETZKENDO               A 2174 2183    USER
         WKIFKPC100 = APBS;       // z.B. DOM10606C2               A 2184 2193    BILDSCHIRM
         WKIFKPC100 = APPGM;      // LGPGM611                      A 2194 2203    PROGRAMM NAME
         WKIFKPN100 = APBSTU;     // 0                             S 2204 2204 0  BESTANDS- ÜBERNAHM
         WKIFKPC100 = APVSTS;     // *BLANK                        A 2205 2205    VERARB.- STATUS
         WKIFKPC100 = APVSSA;     // *BLANK                        A 2206 2206    VER.STS SAP
         WKIFKPC100 = APVSMV;     // *BLANK                        A 2207 2207    VER.STS MOVEX
         WKIFKPC100 = APVSED;     // *BLANK                        A 2208 2208    VER.STS EDI
         WKIFKPC100 = APVSXM;     // *BLANK                        A 2209 2209    VER.STS XML
         WKIFKPC100 = APVSFT;     // *BLANK                        A 2210 2210    VER.STS FTP
         WKIFKPC100 = APVSHD;     // *BLANK                        A 2211 2211    VER.STS ESS
         WKIFKPC100 = APVSMA;     // *BLANK                        A 2212 2212    VER.STS MAS90
         WKIFKPC100 = APVSSB;     // *BLANK                        A 2213 2213    VER.STS STEEB
         WKIFKPC100 = APVSKT;     // *BLANK                        A 2214 2214    VER.STS KTL
         WKIFKPC100 = APVSSD;     // *BLANK                        A 2215 2215    VER.STS STRADA/SD
         WKIFKPC100 = APVSH1;     // *BLANK                        A 2216 2216    VER.STS HOST 1
         WKIFKPC100 = APVSH2;     // *BLANK                        A 2217 2217    VER.STS HOST 2
         WKIFKPC100 = APVSH3;     // *BLANK                        A 2218 2218    VER.STS HOST 3
         WKIFKPC100 = APVSH4;     // *BLANK                        A 2219 2219    VER.STS HOST 4
         WKIFKPC100 = APVSH5;     // *BLANK                        A 2220 2220    VER.STS HOST 5
         WKIFKPC100 = APFCD ;     // *BLANK                        A 2221 2230    FEHLER- CODE
         WKIFKPC100 = APFTXT;     // *BLANK                        C 2231 2390    FEHLERTEXT
         WKIFKPN100 = APDTDI;     // z.B. 20150907                 S 2391 2398 0  DB DATUM WRITE
         WKIFKPN100 = APTIDI;     // z.B. 110731296064             S 2399 2410 0  DB ZEIT WRITE
         WKIFKPC100 = APDIUSR;    // LFSBATCH                      A 2411 2420    DB USER WRITE
         WKIFKPC100 = APDIBS;     // z.B. LGBAT01, LGBAT02         A 2421 2430    DB JOB WRITE
         WKIFKPC100 = APDIJBN;    // z.B. 410650                   A 2431 2436    DB JOBNR. WRITE
         WKIFKPC100 = APDIUSRB;   // LFSBATCH                      A 2437 2446    DB USER BATCH WRIT
         WKIFKPC100 = APDIBSB;    // z.B. LGBAT01, LGBAT02         A 2447 2456    DB JOB BATCH WRITE
         WKIFKPC100 = APDIJBNB;   // z.B. 414650                   A 2457 2462    DB JOBNR. BATCH WR
         WKIFKPC100 = APDIPGM;    // DUPGM006                      A 2463 2472    DB PGM WRITE
         WKIFKPC100 = APDIPGMU;   // *BLANK                        A 2473 2482    USER DEF. DB PGM W
         WKIFKPN100 = APDTDU;     // 0                             S 2483 2490 0  DB DATUM REWRITE
         WKIFKPN100 = APTIDU;     // 0                             S 2491 2502 0  DB ZEIT REWRITE
         WKIFKPC100 = APDUUSR;    // *BLANK                        A 2503 2512    DB USER REWRITE
         WKIFKPC100 = APDUBS;     // *BLANK                        A 2513 2522    DB JOB REWRITE
         WKIFKPC100 = APDUJBN;    // *BLANK                        A 2523 2528    DB JOBNR. REWRITE
         WKIFKPC100 = APDUUSRB;   // *BLANK                        A 2529 2538    DB USER BATCH REWR
         WKIFKPC100 = APDUBSB;    // *BLANK                        A 2539 2548    DB JOB BATCH REWRI
         WKIFKPC100 = APDUJBNB;   // *BLANK                        A 2549 2554    DB JOBNR. BATCH RE
         WKIFKPC100 = APDUPGM;    // *BLANK                        A 2555 2564    DB PGM REWRITE
         WKIFKPC100 = APDUPGMU;   // *BLANK                        A 2565 2574    USER DEF. DB PGM R

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;


       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS IN PSAVEAP2                                         ***
       //*************************************************************************
       BEGSR UPSAVEAP2;

       //KYPSAVEAP2L5.APKONZ = APKONZ;
       //KYPSAVEAP2L5.APFIRM = APFIRM;
       //KYPSAVEAP2L5.APAPN = APAPN;
       //KYPSAVEAP2L5.APAPPO = APAPPO;
       //CHAIN %KDS(KYPSAVEAP2L5:3) PSAVEAP2L5;
       APTIM = %DEC(%TIME());
       APDTM = %DEC(%DATE():*ISO);
       APVSH1 = *ON;
       UPDATE PANFPOSFL5;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFUP
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHIFKP
     C/COPY QCPYSRC,CHLBAK
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHPAUK
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
