     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
     H BNDDIR('TRTXT') DFTACTGRP(*NO)
      //*************************************************************************
      /TITLE  Einlesen der Daten aus PMATZUG2 von Erhard + Partner
      //*************************************************************************
      //  Copyright 2015 by trend SWM
      //                    Verwaltung GmbH
      //                    Gundelfinger Straße 11
      //                    DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 28.08.2015 Projekt 11427 Dometic WAECO
      //  -----------------------------------------------------------------------
      //  Änderung:
      //
      //*************************************************************************
      //
      //  Dieses Programm füllt die trend Standard Schnittstellenfile IFLB mit
      //  den Daten aus PMATZUG2. Die eingelesenen Daten werden in PMATZUG2 als
      //  verarbeitet gekennzeichnet.
      //
      //  Über dieses Programm sollen Buchungen für folgende Vorgänge eigelesen
      //  werden:
      //  - Einlagerung WE
      //  - Einlagerung Retoure
      //  - Umbuchung
      //  - Zustandänderung (sperren/freigeben)
      //  - Bereitstellung Rohstoff Produktion
      //  - Rückmeldung Produktion Fertigware
      //  - ungeplanter Zugang (Ware gefunden)
      //  - ungeplanter Abgang
      //  - Bruchbuchung
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPMATZUG2L1UF A E           K DISK    USROPN RENAME(PMATZUGF:PMATZUGFL1)
     FPMATZUG2L2UF A E           K DISK    USROPN RENAME(PMATZUGF:PMATZUGFL2)
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
     D BBEK          E DS                  INZ
     D KYBBEK        E DS                  INZ
      //
     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ
      //
     D IFLB          E DS                  INZ
     D KYIFLB        E DS                  INZ
     D WKIFLB        E DS                  EXTNAME(IFLB) PREFIX(WK) INZ
      //
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ
      //
     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ
      //
     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ
      //
     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ
      //
     D LGPA          E DS                  INZ
     D KYLGPA        E DS                  INZ
      //
     D PARK          E DS                  INZ
     D KYPARK        E DS                  INZ
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
     D KYPMATZUG2L1    DS                  LIKEREC(PMATZUGFL1:*KEY)
     D KYPMATZUG2L2    DS                  LIKEREC(PMATZUGFL2:*KEY)
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
     D WKSAVD          S            256
     D WKPATH          S           1024
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##PGST          S              1
     D ##RTCD          S              1
     D WKTRTP          S              1
     D WKI000          S              1
     D WKIIFL          S              1
     D WKIUML          S              1
     D WKFENR          S              4
     D WKIFLBC100      S            100A
     D WKIFLBN080      S              8S 0
     D WKIFLBN120      S             12S 0
     D WKIFLBN134      S             13S 4
     D WKIFLBN145      S             14S 5
     D WKLSTCBRU       S                   LIKE(IFLBLSTC)
     D WKLSTCABG       S                   LIKE(IFLBLSTC)
     D WKLSTCAB2       S                   LIKE(IFLBLSTC)
     D WKLSTCWAE       S                   LIKE(IFLBLSTC)
     D WKLSTCPRD       S                   LIKE(IFLBLSTC)
     D WKLSTCRET       S                   LIKE(IFLBLSTC)
     D WKLSTCINM       S                   LIKE(IFLBLSTC)
     D WKLSTCINP       S                   LIKE(IFLBLSTC)
     D WKLSTCDIM       S                   LIKE(IFLBLSTC)
     D WKLSTCDIP       S                   LIKE(IFLBLSTC)
     D WKLSTCUML       S                   LIKE(IFLBLSTC)
     D WKLSTCINV       S                   LIKE(IFLBLSTC)

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKIFLBTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKIFLBTSTP                        LIKE(WKIFLBTSTP)

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
       OPEN PMATZUG2L1;
       OPEN PMATZUG2L2;
       EXSR VPMATZUG2;

       CLOSE PMATZUG2L1;
       CLOSE PMATZUG2L2;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYIFLBFIRM = DAFIRM;                                                     // IFLB
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYAMFI = DAFIRM;                                                         // AFKM
       KYAAFI = DAFIRM;                                                         // AFPA
       KYEKFI = DAFIRM;                                                         // BBEK
       KYPAFI = DAFIRM;                                                         // BBPa
       KYLSFI = DAFIRM;                                                         // LBSS
       KYLGKOFIRM = DAFIRM;                                                     // LGKO
       KYLGPOFIRM = DAFIRM;                                                     // LGPO
       KYLGPAFIRM = DAFIRM;                                                     // LGPA
       KYRKFI = DAFIRM;                                                         // PARK
       KYLBLBFIRM = DAFIRM;                                                     // LBLB
       KYTEFI = DAFIRM;                                                         // TEIL

       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;

       WKLSTCBRU = '510';                                                       // ABGANG BRUCH
       WKLSTCRET = '140';                                                       // RÜCKLIEFERUNG VON
       WKLSTCABG = '130';                                                       // ABGANG VERSAND
       WKLSTCAB2 = '810';                                                       // ABGANG PRODUKTION
       WKLSTCWAE = '825';                                                       // WARENEINGANG
       WKLSTCPRD = '820';                                                       // ZUGANG PRODUKTION
       WKLSTCINM = '911';                                                       // INVENTUR ABGANG
       WKLSTCINP = '921';                                                       // INVENTUR ZUGANG
       WKLSTCINV = '910';                                                       // INVENTUR
       WKLSTCDIM = '210';                                                       // BEST.DIFF. ABGANG
       WKLSTCDIP = '220';                                                       // BEST.DIFF. ZUGANG
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

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;


       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG DATEN VON LFS                                        ***
       //*************************************************************************
       BEGSR VPMATZUG2;

       KYPMATZUG2L1.MZKONZ = 'EMS';
       KYPMATZUG2L1.MZFIRM = 'DWI';
       KYPMATZUG2L1.MZDTB = %DEC(%DATE():*ISO);
       SETLL %KDS(KYPMATZUG2L1:3) PMATZUG2L1;

       DOW NOT %EOF(PMATZUG2L1) AND NOT %ERROR;
         WKIIFL = *OFF;
         READ(N) PMATZUG2L1;

         IF %EOF OR %ERROR OR
           MZKONZ <> KYPMATZUG2L1.MZKONZ OR
           MZFIRM <> KYPMATZUG2L1.MZFIRM OR
           MZDTB > KYPMATZUG2L1.MZDTB;
           LEAVE;
         ENDIF;

         EXSR INWKIFLB;

         IF WKIFLBFENR <> '0000';                                               // KEINE DATEN MEHR
           LEAVE;
         ENDIF;

         IF MZVSH1 <> *ON;
           WKIIFL = *ON;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPMATZUG2;
           EXSR EIFLB;
           EXSR UIFLB;
           EXSR UPMATZUG2;
         ENDIF;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  INIFLB- Inititalisieren WKIFLB                                    ***
       //*************************************************************************
       BEGSR INWKIFLB;

       CLEAR WKIFLB;
       WKIFLBFIRM = DAFIRM;
       WKIFLBWKNR = '001';
       WKIFLBSTAT = '00';
       WKIFLBPGST = 'WAIFLB';
       WKIFLBDTEI = 'PMATZUG2';
       WKIFLBERZT = %DEC(%TIME());
       WKIFLBERDA = %DEC(%DATE():*ISO);
       WKIFLBERUS = DAUSER;
       WKIFLBFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR EIFLB;

       SELECT;
       WHEN WKIFLBDANA = 'AFKM';                                                // Rückmeldung AFKM
         EXSR EAFKM;
       WHEN WKIFLBDANA = 'BRUC';                                                // Vernichtung
         EXSR ETENR;
       WHEN WKIFLBDANA = 'LBAK';                                                // Umbuchung LBAK/LB
         EXSR ELBAK;
       WHEN WKIFLBDANA = 'BRLK';                                                // Rückmeldung BRLK
         EXSR EBRLK;
       WHEN WKIFLBDANA = 'PARK';                                                // Wareneingang PARK
         EXSR EPARK;
       WHEN WKIFLBDANA = 'BWAE';                                                // Wareneingang BWAE
         EXSR EBBEK;
       WHEN WKIFLBDANA = 'LGKO';                                                // Wareneingang LGKO
         EXSR ELGKO;
       WHEN WKIFLBDANA = 'INVE';                                                // Inventur
         EXSR ETENR;
       WHEN WKIFLBDANA = '    ';                                                // Lagerbewegung
         EXSR ETENR;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR KOMMISSIONIERUNG                              ***
       //*************************************************************************
       BEGSR EAFKM;

       KYAMJH = WKIFLBBLJJ;
       KYAMKM = WKIFLBBLNR;
       CHIDS = '01C';
       EXSR CHAFKM;

       KYAAAT = AMAFAT;
       CHIDS = '01C';
       EXSR CHAFPA;

       IF WKIFLBLSTC = *BLANK;
         WKIFLBLSTC = AALSTC;
       ENDIF;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       KYTENR = WKIFLBTENR;
       CHIDS = '01C';
       EXSR CHTEIL;

       IF WKIFLBBWME = *BLANK;
         WKIFLBBWME = TEMEVK;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR UMLAGERUNG                                    ***
       //*************************************************************************
       BEGSR ELBAK;


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RÜCKLIEFERUNG AN LIEFERANTEN                  ***
       //*************************************************************************
       BEGSR EBRLK;


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BESTELLUNG                                    ***
       //*************************************************************************
       BEGSR EBBEK;

       KYEKJH = WKIFLBBLJJ;
       KYEKBE = WKIFLBBLNR;
       CHIDS = '01C';
       EXSR CHBBEK;

       KYPAAT = EKBEAT;
       CHIDS = '01C';
       EXSR CHBBPA;

       IF WKIFLBLSTC = *BLANK;
         WKIFLBLSTC = PALSTC;
       ENDIF;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       KYTENR = WKIFLBTENR;
       CHIDS = '01C';
       EXSR CHTEIL;

       IF WKIFLBBWME = *BLANK;
         WKIFLBBWME = TEMEVK;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR LAGERBUCHUNG                                  ***
       //*************************************************************************
       BEGSR ETENR;

       KYTENR = WKIFLBTENR;
       CHIDS = '01C';
       EXSR CHTEIL;

       IF WKIFLBBWME = *BLANK;
         WKIFLBBWME = TEMEVK;
       ENDIF;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RETOUREN VOM KUNDEN                           ***
       //*************************************************************************
       BEGSR ELGKO;

       KYLGKOLGJJ = WKIFLBBLJJ;
       KYLGKOLGNR = WKIFLBBLNR;
       CHIDS = '01C';
       EXSR CHLGKO;

       KYLGPALGAT = LGKOLGAT;
       CHIDS = '01C';
       EXSR CHLGPA;

       IF WKIFLBLSTC = *BLANK;
         WKIFLBLSTC = LGPALSTC;
       ENDIF;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       KYTENR = WKIFLBTENR;
       CHIDS = '01C';
       EXSR CHTEIL;

       IF WKIFLBBWME = *BLANK;
         WKIFLBBWME = TEMEVK;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RÜCKMELDUNG PROD.-AUFTRAG                     ***
       //*************************************************************************
       BEGSR EPARK;

       KYRKJH = WKIFLBBLJJ;
       KYRKPP = WKIFLBBLNR;
       KYRKUP = WKIFLBBLPO;
       CHIDS = '01C';
       EXSR CHPARK;

       KYLBLBTMST = RKTMST;
       CHIDS = '01C';
       EXSR CHLBLB;

       IF WKIFLBLSTC = *BLANK;
         WKIFLBLSTC = LBLBLSTC;
       ENDIF;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR UIFLB;

       KYIFLBFIRM = WKIFLBFIRM;
       KYIFLBTSTP = WKIFLBTSTP;
       CHIDS = '01CU';
       EXSR CHIFLB;

       IFLBWKNR = WKIFLBWKNR;
       IFLBPGST = WKIFLBPGST;
       IFLBSTKZ = WKIFLBSTKZ;
       IFLBLSTC = WKIFLBLSTC;
       IFLBLBSC = WKIFLBLBSC;
       IFLBTMST = WKIFLBTMST;
       IFLBBSLA = WKIFLBBSLA;
       IFLBLANR = WKIFLBLANR;
       IFLBLORT = WKIFLBLORT;
       IFLBTENR = WKIFLBTENR;
       IFLBFBNR = WKIFLBFBNR;
       IFLBGEBI = WKIFLBGEBI;
       IFLBCONT = WKIFLBCONT;
       IFLBBHNR = WKIFLBBHNR;
       IFLBCHAR = WKIFLBCHAR;
       IFLBFUMG = WKIFLBFUMG;
       IFLBMEIN = WKIFLBMEIN;
       IFLBKDNR = WKIFLBKDNR;
       IFLBLFNR = WKIFLBLFNR;
       IFLBQUMM = WKIFLBQUMM;
       IFLBBDAT = WKIFLBBDAT;
       IFLBBZEI = WKIFLBBZEI;
       IFLBBWMG = WKIFLBBWMG;
       IFLBBWME = WKIFLBBWME;
       IFLBSTMG = WKIFLBSTMG;
       IFLBDANA = WKIFLBDANA;
       IFLBDAKY = WKIFLBDAKY;
       IFLBBLJJ = WKIFLBBLJJ;
       IFLBBLNR = WKIFLBBLNR;
       IFLBBLPO = WKIFLBBLPO;
       IFLBBLUP = WKIFLBBLUP;
       IFLBWBKT = WKIFLBWBKT;
       IFLBEBKT = WKIFLBEBKT;
       IFLBKONT = WKIFLBKONT;
       IFLBKOTR = WKIFLBKOTR;
       IFLBKSST = WKIFLBKSST;
       IFLBKOAR = WKIFLBKOAR;
       IFLBBEZ1 = WKIFLBBEZ1;
       IFLBBEZ2 = WKIFLBBEZ2;

       IFLBUBSL = WKIFLBUBSL;
       IFLBULNR = WKIFLBULNR;
       IFLBUORT = WKIFLBUORT;
       IFLBUBHN = WKIFLBUBHN;
       IFLBUQUM = WKIFLBUQUM;
       IFLBUFBN = WKIFLBUFBN;

       IFLBFRNN = WKIFLBFRNN;
       IFLBLBRS = WKIFLBLBRS;
       IFLBRSKZ = WKIFLBRSKZ;
       IFLBQSST = WKIFLBQSST;
       IFLBQSTM = WKIFLBQSTM;
       IFLBQSES = WKIFLBQSES;
       IFLBRPTS = WKIFLBRPTS;
       IFLBGECH = WKIFLBGECH;
       IFLBLAPR = WKIFLBLAPR;
       IFLBSPKZ = WKIFLBSPKZ;
       IFLBSPGR = WKIFLBSPGR;
       IFLBPOSI = WKIFLBPOSI;
       IFLBFESP = WKIFLBFESP;
       IFLBCHEX = WKIFLBCHEX;
       IFLBHSDA = WKIFLBHSDA;
       IFLBHSZT = WKIFLBHSZT;
       IFLBVEDA = WKIFLBVEDA;
       IFLBREFN = WKIFLBREFN;

       IFLBKZ01 = WKIFLBKZ01;
       IFLBKZ02 = WKIFLBKZ02;
       IFLBKZ03 = WKIFLBKZ03;
       IFLBKZ04 = WKIFLBKZ04;
       IFLBKZ05 = WKIFLBKZ05;
       IFLBKZ06 = WKIFLBKZ06;
       IFLBKZ07 = WKIFLBKZ07;
       IFLBKZ08 = WKIFLBKZ08;
       IFLBKZ09 = WKIFLBKZ09;
       IFLBKZ10 = WKIFLBKZ10;
       IFLBKZ11 = WKIFLBKZ11;
       IFLBKZ12 = WKIFLBKZ12;
       IFLBKZ13 = WKIFLBKZ13;
       IFLBKZ14 = WKIFLBKZ14;
       IFLBKZ15 = WKIFLBKZ15;
       IFLBKZ16 = WKIFLBKZ16;
       IFLBKZ17 = WKIFLBKZ17;
       IFLBKZ18 = WKIFLBKZ18;
       IFLBKZ19 = WKIFLBKZ19;
       IFLBKZ20 = WKIFLBKZ20;

       IFLBSTAT = WKIFLBSTAT;
       IFLBSZAR = WKIFLBSZAR;
       IFLBDTEI = WKIFLBDTEI;
       IFLBFENR = WKIFLBFENR;
       IFLBFFLD = WKIFLBFFLD;

       IFLBJNAM = WKIFLBJNAM;
       IFLBPROG = WKIFLBPROG;
       IFLBBIBL = WKIFLBBIBL;
       IFLBUSER = WKIFLBUSER;
       IFLBJZEI = WKIFLBJZEI;
       IFLBJDAT = WKIFLBJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFLBERDA = WKIFLBERDA;
         IFLBERZT = WKIFLBERZT;
         IFLBERUS = WKIFLBERUS;
         CHIDS = '01W';
         EXSR CHIFLB;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFLB;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPMATZUG2;

         WKIUML = *OFF;
         WKIFLBTSTP = %DATE(MZDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(MZTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(MZTIDI:'X'):7:6):6:0));
         WKIFLBSTKZ = *BLANK;

         SELECT;
         WHEN MZBUSL = 'UML';
           WKIFLBLSTC = WKLSTCUML;
           WKIUML = *ON;
         WHEN MZBUSL = 'BR-';
           WKIFLBLSTC = WKLSTCINM;
         WHEN MZBUSL = 'BF ';
           WKIFLBLSTC = WKLSTCINP;
         WHEN MZBUSL = 'QS ';
           WKIFLBLSTC = WKLSTCUML;
         OTHER;
           WKIFLBLSTC = MZBUSL;
         ENDSL;

         WKIFLBSZAR = MZSART;
         WKIFLBLBSC = *BLANK;
         WKIFLBTMST = *ZERO;
         WKIFLBBSLA = *BLANK;
         WKIFLBLANR = '001';
         WKIFLBLORT = *BLANK;
         WKIFLBTENR = MZIDEN;

         IF MZSSC <> *BLANK;
           WKIFLBFBNR = MZSSC;
         ELSE;
           WKIFLBFBNR = MZZUNV;
         ENDIF;

         WKIFLBGEBI = *BLANK;
         WKIFLBCONT = *BLANK;

         IF MZBENR <> 0;
           WKIFLBBHNR = %CHAR(MZBENR);
         ENDIF;

         WKIFLBCHAR = MZPRNR;
         WKIFLBFUMG = *ZERO;
         WKIFLBMEIN = *BLANK;
         WKIFLBKDNR = MZKDNR;
         WKIFLBLFNR = MZLIEF;
         WKIFLBQUMM = *BLANK;

         IF MZDTB <> 0;
           WKIFLBBDAT = MZDTB;
         ELSE;
           WKIFLBBDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF MZTIB <> 0;
           WKIFLBBZEI = MZTIB;
         ELSE;
           WKIFLBBZEI = %DEC(%TIME());
         ENDIF;

         WKIFLBBWMG = MZBMEN;

         SELECT;
         WHEN MZME = 'ST';
           WKIFLBBWME = 'S';
         WHEN MZME = 'KG';
           WKIFLBBWME = 'K';
         ENDSL;

         WKIFLBSTMG = *ZERO;
         WKIFLBDANA = *BLANK;
         WKIFLBDAKY = *BLANK;

         SELECT;
         WHEN MZWENR <> *BLANK;                                                  // Wareneingang
           MONITOR;
             WKIFLBBLJJ = %DEC(%SUBST(MZWENR:2:2):2:0) + 2000;
           ON-ERROR;
             WKIFLBBLJJ = 0;
           ENDMON;

           WKIFLBBLNR = %SUBST(MZWENR:4:6);
           WKIFLBBLPO = MZWEPO;
           WKIFLBDANA = 'BWAE';
           WKIFLBDAKY = %EDITC(WKIFLBBLJJ:'X') + WKIFLBBLNR +
                        %EDITC(WKIFLBBLPO:'X') + '000';
         WHEN MZFNR1 <> *BLANK;                                                  // Prod.-Auftrag
           MONITOR;
             WKIFLBBLJJ = %DEC(%SUBST(MZFNR1:2:2):2:0) + 2000;
           ON-ERROR;
             WKIFLBBLJJ = 0;
           ENDMON;

           WKIFLBBLNR = %SUBST(MZFNR1:4:6);
           WKIFLBBLPO = MZFNRP;
           WKIFLBDANA = 'PAUM';
           WKIFLBDAKY = %EDITC(WKIFLBBLJJ:'X') + WKIFLBBLNR +
                        %EDITC(WKIFLBBLPO:'X') + '000';
         WHEN MZBBER = 'BF';                                                     // Bestandführung
           WKIFLBBLNR = *BLANK;
           WKIFLBBLPO = *ZERO;
           WKIFLBDANA = '    ';
           WKIFLBDAKY = *BLANK;
           WKIFLBLSTC = WKLSTCUML;
           WKIUML = *ON;
         ENDSL;

         WKIFLBBLUP = *ZERO;
         WKIFLBWBKT = *BLANK;
         WKIFLBEBKT = *BLANK;
         WKIFLBKONT = *BLANK;
         WKIFLBKOTR = *BLANK;

         IF MZKST <> 0;
           WKIFLBKSST = %EDITC(MZKST:'X');
         ENDIF;

         WKIFLBKOAR = *BLANK;
         WKIFLBBEZ1 = %CHAR(MZHW);
         WKIFLBBEZ2 = *BLANK;

         IF WKIUML = *ON;                                                        // Umlagerung
           WKIFLBUBSL = *BLANK;
           WKIFLBULNR = *BLANK;
           WKIFLBUORT = *BLANK;
           WKIFLBUBHN = *BLANK;
           WKIFLBUQUM = *BLANK;
           WKIFLBUFBN = *BLANK;
         ENDIF;

         WKIFLBFRNN = *ZERO;
         WKIFLBLBRS = *BLANK;
         WKIFLBRSKZ = *BLANK;
         WKIFLBQSST = *BLANK;
         WKIFLBQSTM = *ZERO;
         WKIFLBQSES = *BLANK;
         CLEAR WKIFLBRPTS;
         WKIFLBGECH = *BLANK;
         WKIFLBLAPR = *BLANK;
         WKIFLBSPKZ = *BLANK;
         WKIFLBSPGR = *BLANK;
         WKIFLBPOSI = *ZERO;
         WKIFLBFESP = *BLANK;
         WKIFLBCHEX = *BLANK;
         WKIFLBHSDA = *ZERO;
         WKIFLBHSZT = *ZERO;
         WKIFLBVEDA = MZDTDC;

         IF MZEXRF <> 0;
           WKIFLBREFN = %CHAR(MZEXRF);
         ENDIF;

         WKIFLBJNAM = MZBS;
         WKIFLBPROG = MZPGM;
         WKIFLBBIBL = WKCHPL;
         WKIFLBUSER = MZUSER;

         IF MZDTB <> 0;
           WKIFLBJDAT = MZDTB;
         ELSE;
           WKIFLBJDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF MZTIB <> 0;
           WKIFLBJZEI = MZTIB;
         ELSE;
           WKIFLBJZEI = %DEC(%TIME());
         ENDIF;

       ENDSR;
       //-------------------------------------------------------------------------------------------
       // Die nachfolgend aufgeführten Felder entsprechen in Ausprägung und Reihenfolge den Feldern
       // in der File PMATZUG2.
       // Wenn der Inhalt aus zusätzlichen Feldern nach trend übernommen werden soll, dann die
       // Felder in den Bereich über die Linie kopieren (nicht ausschneiden). Danke.
       //
       BEGSR DUMMY;

         WKIFLBC100 = MZKONZ;     // 111                           A    1    3    KONZERN
         WKIFLBC100 = MZFIRM;     // 010                           A    4    6    FIRMA
         WKIFLBC100 = MZLGNR;     // *BLANK                        A    7   14    LAGERNUMMER
         WKIFLBC100 = MZSYSN;     // *BLANK                        A   15   22    SYSTEMNAME
         WKIFLBC100 = MZTTYP;     // E, U, A                       A   23   23    TPA- TYP
         WKIFLBC100 = MZBUSL;     // BR-, UML, QS, BF              A   24   26    BUCHUNGS- SCHLÜSSE
         WKIFLBC100 = MZBBER;     // BF                            A   27   28    BUCHUNGS- BEREICH
         WKIFLBC100 = MZBWA;      // S, B                          A   29   29    BEWEGUNGS- ART
         WKIFLBN080 = MZVSST;     // 0, teilweise Werte            S   30   32 0  VON SST
         WKIFLBN080 = MZNSST;     // 0, teilweise Werte            S   33   35 0  NACH SST
         WKIFLBN120 = MZLFDN;     // z.B. 100513254                S   36   44 0  LFD NUMMER
         WKIFLBN120 = MZLFMT;     // z.B. 100018815                S   45   53 0  LFD-SATZ-NR PMZTAB
         WKIFLBC100 = MZSART;     // QK01, BF                      A   54   57    SATZ- ART
         WKIFLBC100 = MZVORT;     // HRA, LEE, LHM, RES, DLR       A   58   60    VON ORT
         WKIFLBC100 = MZVBER;     // 01, R, *BLANK, 11             A   61   62    VON BER.
         WKIFLBC100 = MZVHLO;     // *BLANK                        A   63   72    VON-HOST LAGERORT
         WKIFLBC100 = MZVAWB;     // *BLANK, ND1                   A   73   75    VON-ABW.- BEREICH
         WKIFLBC100 = MZVLOC;     // *BLANK, 00                    A   76   77    VON LOCATION
         WKIFLBC100 = MZNORT;     // HRA, RES, LEE, LHM            A   78   80    NACH ORT
         WKIFLBC100 = MZNBER;     // 01, R, *BLANK, 11             A   81   82    NACH BER.
         WKIFLBC100 = MZNHLO;     // *BLANK                        A   83   92    NACH-HOST LAGERORT
         WKIFLBC100 = MZNAWB;     // *BLANK                        A   93   95    NACH-ABW.- BEREICH
         WKIFLBC100 = MZNLOC;     // 00, *BLANK                    A   96   97    NACH LOCATION
         WKIFLBC100 = MZPPLZ;     // *BLANK                        A   98  107    PUFFER- PLATZ
         WKIFLBN120 = MZPALN;     // z.B. 107579111                S  108  116 0  TPA-NR
         WKIFLBN080 = MZPALP;     // 1                             S  117  119 0  TPA POS
         WKIFLBN120 = MZLENR;     // z.B. 107579109                S  120  128 0  LADE- EINHEIT
         WKIFLBN120 = MZZULE;     // z.B. 107579109                S  129  137 0  ZUGANGS- LADEEINHE
         WKIFLBC100 = MZZUNV;     // 34154511255000000470, *BLANK  A  138  183    ZUGANGS- NVE-NUMME
         WKIFLBN120 = MZZUPK;     // 0, oder z.B. 100190542        S  184  192 0  ZUGANGS- PACKSTÜCK
         WKIFLBC100 = MZEXLE;     // *BLANK                        A  193  212    EXTERNE LADEEINHEI
         WKIFLBN120 = MZBENR;     // 0                             S  213  221 0  BEHÄLTER- NUMMER
         WKIFLBN120 = MZBENR2;    // 0                             S  222  230 0  ALTE BEH-NR 2-ST-K
         WKIFLBN120 = MZZUSL;     // 0, oder z.B. 107481962        S  231  239 0  ZUGRIFFS- SCHLÜSSE
         WKIFLBN120 = MZZUNR;     // 0                             S  240  248 0  ZUGRIFFS- NR
         WKIFLBC100 = MZMOIQ;     // 91, *BLANK                    A  249  250    MODUL IDENT. QUALI
         WKIFLBC100 = MZMOID;     // z.B. 107481970                A  251  296    MODUL IDENTIFIKATI
         WKIFLBN120 = MZPNPM;     // 0                             S  297  305 0  ZUGRIFFS- NR
         WKIFLBN120 = MZAZVG;     // 0                             S  306  314 0  AUFTR-ZUS- VORGANG
         WKIFLBC100 = MZAZKZ;     // *BLANK                        A  315  315    AUFTRAGS ZUS.FÜHRU
         WKIFLBN120 = MZNRKS;     // 0                             S  316  324 0  NR.KOMM- SERIE
         WKIFLBC100 = MZIDEN;     // MAR1, 101, EUROVOLL, ...      A  325  352    ARTIKELNUMMER
         WKIFLBC100 = MZIDV;      // *BLANK                        A  353  367    ARTIKELVARIANTE
         WKIFLBC100 = MZIDVA;     // *BLANK                        A  368  382    ZUSATZART. VARIANT
         WKIFLBC100 = MZBHF;      // *BLANK                        A  383  392    BAHNHOF
         WKIFLBC100 = MZTOUR;     // *BLANK                        A  393  398    TOUR
         WKIFLBC100 = MZVART;     // *BLANK                        A  399  402    VERSAND- ART
         WKIFLBC100 = MZSSC;      // *BLANK                        A  403  406    VERSAND- SERVICE-C
         WKIFLBC100 = MZKDNR;     // *BLANK, 1234                  A  407  416    KUNDEN-NR
         WKIFLBC100 = MZHW;       // *BLANK, Text                  C  417  496    TRANSPORT HINWEIS
         WKIFLBC100 = MZACWA;     // *BLANK                        A  497  498    AKTIONSCODE WAREN-
         WKIFLBC100 = MZWEKZ;     // *BLANK                        A  499  499    WAREN- KZ. ALT
         WKIFLBC100 = MZWAKZ;     // *BLANK                        A  500  500    WAREN- KENNZEICHEN
         WKIFLBC100 = MZKOMA;     // *BLANK                        A  501  501    KONSI- MAT.
         WKIFLBC100 = MZOWNR;     // *BLANK                        A  502  511    EIGENTÜMER
         WKIFLBC100 = MZRVOR;     // *BLANK                        A  512  521    NR. RÜST- VORSCHRI
         WKIFLBC100 = MZZCDE;     // *BLANK                        A  522  536    ZOLL-CODE
         WKIFLBN134 = MZBMEN;     // immer gefüllt                 S  537  547 3  BESTANDSMENGE
         WKIFLBC100 = MZME;       // ST, *BLANK                    A  548  550    MENGEN- EINHEIT
         WKIFLBC100 = MZHUM;      // *BLANK                        A  551  553    UNIT OF MEASURE HO
         WKIFLBC100 = MZHUMI;     // *BLANK                        A  554  556    UNIT OF MEASURE IS
         WKIFLBN134 = MZVPE;      // 0                             S  557  567 3  MENGE IN VERPACK-E
         WKIFLBC100 = MZME1;      // 0                             A  568  570    ME DER VPE
         WKIFLBN134 = MZVPE2;     // 0                             S  571  581 3  MENGE IN /UMVERP-E
         WKIFLBC100 = MZME2;      // 0                             A  582  584    ME DER UVPE
         WKIFLBN134 = MZSTCK;     // 0                             S  585  593 3  ANZAHL STÜCK
         WKIFLBN145 = MZEGEW;     // 0                             S  594  607 5  EINZEL-GEW IN KG
         WKIFLBN145 = MZSGEW;     // 0                             S  608  621 5  SUMME-GEW IN KG
         WKIFLBN145 = MZTARA;     // 15,0 oder 0                   S  622  635 5  TARA-GEW IN KG
         WKIFLBC100 = MZBEM1;     // *BLANK                        C  636  687    ARTIKELBEMERKUNG 1
         WKIFLBC100 = MZBEM2;     // *BLANK                        C  688  739    ARTIKELBEMERKUNG 2
         WKIFLBC100 = MZBEM3;     // *BLANK                        C  740  791    ARTIKELBEMERKUNG 3
         WKIFLBC100 = MZKSTR;     // *BLANK                        A  792  792    KOMM- STRAT.
         WKIFLBN080 = MZPLST;     // 0                             S  793  793 0  PACK- LISTE
         WKIFLBN120 = MZPKNR;     // 0                             S  794  802 0  PACKSTÜCK- NUMMER
         WKIFLBC100 = MZVENR;     // *BLANK                        A  803  848    VERSANDEINHEITEN-
         WKIFLBC100 = MZKZEA;     // *BLANK                        A  849  849    KZ ERSATZ- ARTIKEL
         WKIFLBC100 = MZTXEA;     // *BLANK                        C  850  909    TEXT F ERSATZARTIK
         WKIFLBN080 = MZDTB;      // z.B. 20150206                 S  910  917 0  BEREITST. DATUM
         WKIFLBN080 = MZTIB;      // z.B. 114806                   S  918  923 0  BEREITST. ZEIT
         WKIFLBC100 = MZTZB;      // *BLANK                        A  924  933    ZEIT- ZONE
         WKIFLBN080 = MZDTV;      // 0                             S  934  941 0  VERARBEIT. DATUM
         WKIFLBN080 = MZTIV;      // 0                             S  942  947 0  VERARBEIT. ZEIT
         WKIFLBC100 = MZTZV;      // *BLANK                        A  948  957    ZEIT- ZONE
         WKIFLBC100 = MZPGM;      // LGPGM9260, LGPGM230           A  958  967    PROGRAMM NAME
         WKIFLBC100 = MZBS;       // EKLA0, R07MARS0, ...          A  968  977    BILDSCHIRM
         WKIFLBC100 = MZUSER;     // MAR, EKL, QUSER, ...          A  978  987    USER
         WKIFLBN120 = MZAPN;      // 0, 100237040, ...             S  988  996 0  ARBEITS- PAKET-NR
         WKIFLBN120 = MZAPPO;     // 0, 1, ?                       S  997 1002 0  ARBEITS- PAKET-POS
         WKIFLBC100 = MZAPSR;     // *BLANK                        A 1003 1012    AP-SERIE/WAVE
         WKIFLBN120 = MZAPN1;     // 0                             S 1013 1021 0  AP-NR 1.K-STUFE
         WKIFLBN080 = MZAPP1;     // 0                             S 1022 1027 0  AP-POS 1.K-STUFE
         WKIFLBN120 = MZLFD1;     // 0                             S 1028 1036 0  LFDN-SATZ-NR AP-ST
         WKIFLBN120 = MZAPN2;     // 0                             S 1037 1045 0  AP-NR 2.K-STUFE
         WKIFLBN080 = MZAPP2;     // 0                             S 1046 1051 0  AP-POS 2.K-STUFE
         WKIFLBC100 = MZSNDG;     // *BLANK                        A 1052 1061    SENDUNGS-NR.
         WKIFLBC100 = MZPRN;      // *BLANK                        A 1062 1086    PROJEKTNUMMER
         WKIFLBC100 = MZLIEF;     // *BLANK                        A 1087 1101    LIEFERANTEN- NUMME
         WKIFLBC100 = MZPRNR;     // teilweise gefüllt             A 1102 1116    PRÜF-NR/CHARGE
         WKIFLBC100 = MZREVS;     // *BLANK                        A 1117 1136    REVISIONS- STAND
         WKIFLBN120 = MZMDRF;     // 0                             S 1137 1145 0  MODUL- REFERENZ
         WKIFLBC100 = MZSRN;      // *BLANK                        A 1146 1170    SERIENNUMMER
         WKIFLBN080 = MZDTDC;     // z.B. 20150306                 S 1171 1178 0  MHD
         WKIFLBC100 = MZTLM;      // 110, 120, ...                 A 1179 1181    TRÄGER- LADEMITTEL
         WKIFLBC100 = MZLM;       // 110, 120, ...                 A 1182 1184    LADE- MITTEL
         WKIFLBC100 = MZWENR;     // z.B. WE00027648               A 1185 1194    WE-NUMMER
         WKIFLBN080 = MZWEPO;     // 1, 2, ...                     S 1195 1200 0  WE-POS
         WKIFLBC100 = MZBAUG;     // *BLANK                        A 1201 1210    BAUGRUPPE
         WKIFLBC100 = MZFNR1;     // *BLANK                        A 1211 1235    FERTIG.-NR
         WKIFLBN080 = MZFNRP;     // 0                             S 1236 1241 0  FERTIG. POS
         WKIFLBC100 = MZLSNR;     // *BLANK                        A 1242 1257    LIEFERSCHEIN- NUMM
         WKIFLBN080 = MZLSNP;     // 0                             S 1258 1262 0  LIEFERSCHEIN- POSI
         WKIFLBC100 = MZANR1;     // *BLANK, MAR0707-03, ...       A 1263 1287    AUFTRAGS-NR. KUNDE
         WKIFLBN080 = MZANRP;     // 0, 1, ...                     S 1288 1293 0  AUFTRAGS-NR. KUNDE
         WKIFLBC100 = MZREKZ;     // *BLANK                        A 1294 1294    RESERVIERUNGS- KZ
         WKIFLBC100 = MZRENR;     // *BLANK                        A 1295 1319    RESERVIERUNGS- NR
         WKIFLBC100 = MZBST1;     // *BLANK                        A 1320 1344    BESTELL-NR
         WKIFLBN080 = MZBSTP;     // 0                             S 1345 1350 0  BESTELL- POS
         WKIFLBN080 = MZKST;      // 0                             S 1351 1357 0  KOSTEN- STELLE
         WKIFLBC100 = MZKZP;      // *BLANK                        A 1358 1358    KZ GEPARKTE WARE
         WKIFLBC100 = MZQSTA;     // 9, *BLANK                     A 1359 1359    ALTER QUALITÄTS- S
         WKIFLBC100 = MZQKZA;     // 98, *BLANK                    A 1360 1361    ALTER SCHLÜSSEL SP
         WKIFLBC100 = MZQSHA;     // *BLANK                        A 1362 1363    ALTER QUAL.- STATU
         WKIFLBC100 = MZQCHA;     // 98, 97, 26, *BLANK            A 1364 1423    QUALITÄTS MERKMALE
         WKIFLBC100 = MZQSTN;     // *BLANK, 9                     A 1424 1424    NEUER QUALITÄTS- S
         WKIFLBC100 = MZQKZN;     // *BLANK, 98                    A 1425 1426    NEUER SCHLÜSSEL SP
         WKIFLBC100 = MZQCHN;     // *BLANK, 98, 97                A 1427 1486    QUALITÄTS MERKMALE
         WKIFLBC100 = MZQSHN;     // *BLANK                        A 1487 1488    NEUER QUAL.- STATU
         WKIFLBN120 = MZZUBE;     // 0                             S 1489 1497 0  ZUGANGS- BELEG
         WKIFLBN080 = MZVCNR;     // 0                             S 1498 1504 0  VON COLLI-NR
         WKIFLBN080 = MZBCNR;     // 0                             S 1505 1511 0  BIS COLLI-NR
         WKIFLBC100 = MZANB;      // *BLANK                        A 1512 1514    ANBINDUNG AN
         WKIFLBC100 = MZRFNR;     // *BLANK                        A 1515 1564    REFERENZ-NUMMER
         WKIFLBC100 = MZRFNR2;    // *BLANK                        A 1565 1614    REFERENZ-NR 2
         WKIFLBN120 = MZEXRF;     // 0                             S 1615 1623 0  EXTERNE REFERENZ-N
         WKIFLBN120 = MZSRRF;     // 0                             S 1624 1632 0  SERIENNUMMER REFER
         WKIFLBC100 = MZIDOC;     // *BLANK                        A 1633 1648    SAP IDOC-NUMMER
         WKIFLBC100 = MZSKGW;     // *BLANK                        A 1649 1658    SAMMEL-KOM. GERÄT
         WKIFLBN080 = MZSKGF;     // 0                             S 1659 1662 0  SKG- FACH
         WKIFLBC100 = MZLSTA;     // *BLANK                        A 1663 1664    LIEFER- STATUS
         WKIFLBC100 = MZEWE;      // *BLANK                        A 1665 1665    ENDE WAREN- EINGAN
         WKIFLBC100 = MZEWEP;     // *BLANK                        A 1666 1666    ENDE WAREN- EINGAN
         WKIFLBC100 = MZHERK;     // Z, *BLANK                     A 1667 1667    SATZ- HERKUNFT
         WKIFLBC100 = MZLWEG;     // *BLANK                        A 1668 1677    LAUFWEG
         WKIFLBC100 = MZLWPK;     // *BLANK                        A 1678 1697    ERLEDIGTE LW.-PUNK
         WKIFLBC100 = MZSARM;     // *BLANK                        A 1698 1698    SAP RÜCKMELDE- PFL
         WKIFLBN120 = MZSATN;     // 0                             S 1699 1708 0  SAP TA-NUMMER
         WKIFLBN080 = MZSATP;     // 0                             S 1709 1712 0  SAP TA-POS
         WKIFLBC100 = MZSAEV;     // *BLANK                        A 1713 1732    SAP LE-NR VON
         WKIFLBC100 = MZSAEN;     // *BLANK                        A 1733 1752    SAP LE-NR NACH
         WKIFLBC100 = MZSARN;     // *BLANK                        A 1753 1762    SAP REFERENZ- NUMM
         WKIFLBC100 = MZSAKN;     // *BLANK                        A 1763 1763    SAP KZ NULL- KONTR
         WKIFLBC100 = MZKZCE;     // *BLANK                        A 1764 1764    KZ CHARGEN- ERFASS
         WKIFLBC100 = MZKZGE;     // *BLANK                        A 1765 1765    KZ GEW.- ERFASS.
         WKIFLBC100 = MZKZDE;     // *BLANK                        A 1766 1766    KZ MHD- ERFASS.
         WKIFLBC100 = MZLOID;     // *BLANK                        A 1767 1768    LÖSCH-ID
         WKIFLBC100 = MZLOEG;     // *BLANK                        C 1769 1848    LÖSCHGRUND
         WKIFLBC100 = MZMODG;     // *BLANK                        A 1849 1850    MODIFIKATIONS- GRU
         WKIFLBN080 = MZBSTU;     // 0                             S 1851 1851 0  BESTANDS- ÜBERNAHM
         WKIFLBC100 = MZFCD;      // *BLANK                        A 1852 1861    FEHLER- CODE
         WKIFLBC100 = MZFTXT;     // *BLANK                        C 1862 2021    FEHLERTEXT
         WKIFLBC100 = MZKZ1;      // *BLANK                        A 2022 2022    RES-1A KZ1
         WKIFLBC100 = MZKZ2;      // *BLANK                        A 2023 2023    RES-1A KZ2
         WKIFLBC100 = MZKZ3;      // *BLANK                        A 2024 2024    RES-1A KZ3
         WKIFLBC100 = MZKZ4;      // *BLANK                        A 2025 2025    RES-1A KZ4
         WKIFLBN080 = MZDTSE;     // 0                             S 2026 2033 0  SYS-EING.- DATUM
         WKIFLBN080 = MZTISE;     // 0                             S 2034 2039 0  SYS-EING.- ZEIT
         WKIFLBC100 = MZTZSE;     // *BLANK                        A 2040 2049    ZEIT- ZONE
         WKIFLBC100 = MZSEP1;     // *BLANK                        A 2050 2059    BESTANDS- TRENNUNG
         WKIFLBC100 = MZSEP2;     // *BLANK                        A 2060 2069    BESTANDS- TRENNUNG
         WKIFLBC100 = MZBOEN;     // *BLANK                        A 2070 2084    ZOLL- ZUGANGSBELEG
         WKIFLBC100 = MZBOEX;     // *BLANK                        A 2085 2099    ZOLL- ABGANGSBELEG
         WKIFLBN134 = MZEXRT;     // 0                             S 2100 2107 4  WECHSELKURS
         WKIFLBN134 = MZPPR;      // 0                             S 2108 2118 4  EINST.-PREIS STD-W
         WKIFLBC100 = MZWAER;     // *BLANK                        A 2119 2121    WAEHRUNGS- SCHLÜSS
         WKIFLBN134 = MZPPRF;     // 0                             S 2122 2132 4  EINST.-PREIS FREMD
         WKIFLBC100 = MZWAEF;     // *BLANK                        A 2133 2135    WAEHRUNGS- SCHLÜSS
         WKIFLBC100 = MZCPPR;     // *BLANK                        A 2136 2138    FREMDWÄHRUNG
         WKIFLBC100 = MZRECN;     // *BLANK                        A 2139 2158    RECHNUNGS-NR
         WKIFLBC100 = MZFDOK;     // *BLANK                        A 2159 2178    FRACHTDOKUMENT
         WKIFLBC100 = MZSHMT;     // *BLANK                        A 2179 2188    LIEFERUNG
         WKIFLBC100 = MZRFRR;     // *BLANK                        A 2189 2190    ABWEISUNGS- GRUND
         WKIFLBC100 = MZJISPG;    // *BLANK                        A 2191 2194    JIS PROD-GRP
         WKIFLBC100 = MZJISPL;    // *BLANK                        A 2195 2197    JIS PROD-LINE
         WKIFLBC100 = MZJISSQ;    // *BLANK                        A 2198 2202    JIS SEQUENZ
         WKIFLBC100 = MZRTGR;     // *BLANK                        A 2203 2204    RETOUREN- GRUND
         WKIFLBC100 = MZRTHA;     // *BLANK                        A 2205 2206    RETOUREN- ABWICKLU
         WKIFLBN120 = MZRTNR;     // 0                             S 2207 2215 0  RETOUREN- NUMMER
         WKIFLBC100 = MZRTTX;     // *BLANK                        C 2216 2295    RETOURENTEXT
         WKIFLBC100 = MZINRF1;    // *BLANK                        A 2296 2325    INBOUND REFERENCE1
         WKIFLBC100 = MZINRF2;    // *BLANK                        A 2326 2355    INBOUND REFERENCE2
         WKIFLBC100 = MZINRF3;    // *BLANK                        A 2356 2385    INBOUND REFERENCE3
         WKIFLBC100 = MZOURF1;    // *BLANK                        A 2386 2415    OUTBOUND REFERENCE
         WKIFLBC100 = MZOURF2;    // *BLANK                        A 2416 2445    OUTBOUND REFERENCE
         WKIFLBC100 = MZOURF3;    // *BLANK                        A 2446 2475    OUTBOUND REFERENCE
         WKIFLBN080 = MZRN1;      // 0                             S 2476 2476 0  RES-1,0 RN1
         WKIFLBN080 = MZRN2;      // 0                             S 2477 2478 0  RES-2,0 RN2
         WKIFLBN080 = MZRN5;      // 0                             S 2479 2483 0  RES-5,0 RN5
         WKIFLBN080 = MZRN7;      // 0                             S 2484 2490 0  RES-7,0 RN7
         WKIFLBN120 = MZRN9;      // 0                             S 2491 2499 0  RES-9,0 RN9
         WKIFLBN134 = MZRN92;     // 0                             S 2500 2508 2  RES-9,2 RN92
         WKIFLBN134 = MZRN113;    // 0                             S 2509 2519 3  RES-11,3 RN113
         WKIFLBN134 = MZRN114;    // 0                             S 2520 2530 4  RES-11,4 RN114
         WKIFLBC100 = MZRA1;      // *BLANK                        A 2531 2531    RES-1A RA1
         WKIFLBC100 = MZRA2;      // *BLANK                        A 2532 2533    RES-2A RA2
         WKIFLBC100 = MZRA3;      // *BLANK                        A 2534 2536    RES-3A RA3
         WKIFLBC100 = MZRA4;      // *BLANK                        A 2537 2540    RES-4A RA4
         WKIFLBC100 = MZRA5;      // *BLANK                        A 2541 2545    RES-5A RA5
         WKIFLBC100 = MZRA7;      // *BLANK                        A 2546 2552    RES-7A RA7
         WKIFLBC100 = MZRA10;     // *BLANK                        A 2553 2562    RES-10A RA10
         WKIFLBC100 = MZRA13;     // *BLANK                        A 2563 2575    RES-13A RA13
         WKIFLBC100 = MZRA15;     // *BLANK                        A 2576 2590    RES-15A RA15
         WKIFLBC100 = MZRA18;     // *BLANK                        A 2591 2608    RES-18A RA18
         WKIFLBN080 = MZFN1;      // 0                             S 2609 2609 0  RES-1,0 FN1
         WKIFLBN080 = MZFN2;      // 0                             S 2610 2611 0  RES-2,0 FN2
         WKIFLBN080 = MZFN5;      // 0                             S 2612 2616 0  RES-5,0 FN5
         WKIFLBN080 = MZFN7;      // 0                             S 2617 2623 0  RES-7,0 FN7
         WKIFLBN120 = MZFN9;      // 0                             S 2624 2632 0  RES-9,0 FN9
         WKIFLBN134 = MZFN92;     // 0                             S 2633 2641 2  RES-9,2 FN92
         WKIFLBN134 = MZFN113;    // 0                             S 2642 2652 3  RES-11,3 FN113
         WKIFLBN134 = MZFN114;    // 0                             S 2653 2663 4  RES-11,4 FN114
         WKIFLBC100 = MZFA1;      // *BLANK                        A 2664 2664    RES-1A FA1
         WKIFLBC100 = MZFA2;      // *BLANK                        A 2665 2666    RES-2A FA2
         WKIFLBC100 = MZFA3;      // *BLANK                        A 2667 2669    RES-3A FA3
         WKIFLBC100 = MZFA4;      // *BLANK                        A 2670 2673    RES-4A FA4
         WKIFLBC100 = MZFA5;      // *BLANK                        A 2674 2678    RES-5A FA5
         WKIFLBC100 = MZFA7;      // *BLANK                        A 2679 2685    RES-7A FA7
         WKIFLBC100 = MZFA10;     // *BLANK                        A 2686 2695    RES-10A FA10
         WKIFLBC100 = MZFA13;     // *BLANK                        A 2696 2708    RES-13A FA13
         WKIFLBC100 = MZFA15;     // *BLANK                        A 2709 2723    RES-15A FA15
         WKIFLBC100 = MZFA18;     // *BLANK                        A 2724 2741    RES-18A FA18
         WKIFLBC100 = MZVSTS;     // *BLANK                        A 2742 2761    VERARB.- STATUS
         WKIFLBC100 = MZVSSA;     // *BLANK                        A 2762 2762    VER.STS SAP
         WKIFLBC100 = MZVSMV;     // *BLANK                        A 2763 2763    VER.STS MOVEX
         WKIFLBC100 = MZVSED;     // *BLANK                        A 2764 2764    VER.STS EDI
         WKIFLBC100 = MZVSXM;     // *BLANK                        A 2765 2765    VER.STS XML
         WKIFLBC100 = MZVSFT;     // *BLANK                        A 2766 2766    VER.STS FTP
         WKIFLBC100 = MZVSHD;     // *BLANK                        A 2767 2767    VER.STS ESS
         WKIFLBC100 = MZVSMA;     // *BLANK                        A 2768 2768    VER.STS MAS90
         WKIFLBC100 = MZVSSB;     // *BLANK                        A 2769 2769    VER.STS STEEB
         WKIFLBC100 = MZVSKT;     // *BLANK                        A 2770 2770    VER.STS KTL
         WKIFLBC100 = MZVSSD;     // *BLANK                        A 2771 2771    VER.STS STRADA/SD
         WKIFLBC100 = MZVSH1;     // *BLANK                        A 2772 2772    VER.STS HOST 1
         WKIFLBC100 = MZVSH2;     // *BLANK                        A 2773 2773    VER.STS HOST 2
         WKIFLBC100 = MZVSH3;     // *BLANK                        A 2774 2774    VER.STS HOST 3
         WKIFLBC100 = MZVSH4;     // *BLANK                        A 2775 2775    VER.STS HOST 4
         WKIFLBC100 = MZVSH5;     // *BLANK                        A 2776 2776    VER.STS HOST 5
         WKIFLBN080 = MZDTDI;     // z.B. 20150720                 S 2777 2784 0  DB DATUM WRITE
         WKIFLBN120 = MZTIDI;     // z.B. 134322853296             S 2785 2796 0  DB ZEIT WRITE
         WKIFLBC100 = MZDIUSR;    // z.B. QUSER                    A 2797 2806    DB USER WRITE
         WKIFLBC100 = MZDIBS;     // z.B. LGBAT01                  A 2807 2816    DB JOB WRITE
         WKIFLBC100 = MZDIJBN;    // z.B. 420328                   A 2817 2822    DB JOBNR. WRITE
         WKIFLBC100 = MZDIUSRB;   // z.B. QUSER                    A 2823 2832    DB USER BATCH WRIT
         WKIFLBC100 = MZDIBSB;    // z.B. LGBAT01                  A 2833 2842    DB JOB BATCH WRITE
         WKIFLBC100 = MZDIJBNB;   // z.B. 420328                   A 2843 2848    DB JOBNR. BATCH WR
         WKIFLBC100 = MZDIPGM;    // z.B. DUPGM004                 A 2849 2858    DB PGM WRITE
         WKIFLBC100 = MZDIPGMU;   // *BLANK                        A 2859 2868    USER DEF. DB PGM W
         WKIFLBN080 = MZDTDU;     // 0                             S 2869 2876 0  DB DATUM REWRITE
         WKIFLBN080 = MZTIDU;     // 0                             S 2877 2888 0  DB ZEIT REWRITE
         WKIFLBC100 = MZDUUSR;    // *BLANK                        A 2889 2898    DB USER REWRITE
         WKIFLBC100 = MZDUBS;     // *BLANK                        A 2899 2908    DB JOB REWRITE
         WKIFLBC100 = MZDUJBN;    // *BLANK                        A 2909 2914    DB JOBNR. REWRITE
         WKIFLBC100 = MZDUUSRB;   // *BLANK                        A 2915 2924    DB USER BATCH REWR
         WKIFLBC100 = MZDUBSB;    // *BLANK                        A 2925 2934    DB JOB BATCH REWRI
         WKIFLBC100 = MZDUJBNB;   // *BLANK                        A 2935 2940    DB JOBNR. BATCH RE
         WKIFLBC100 = MZDUPGM;    // *BLANK                        A 2941 2950    DB PGM REWRITE
         WKIFLBC100 = MZDUPGMU;   // *BLANK                        A 2951 2960    USER DEF. DB PGM R

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;


       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS IN PMATZUG2                                         ***
       //*************************************************************************
       BEGSR UPMATZUG2;

       KYPMATZUG2L2.MZKONZ = MZKONZ;
       KYPMATZUG2L2.MZFIRM = MZFIRM;
       KYPMATZUG2L2.MZLFDN = MZLFDN;
       CHAIN %KDS(KYPMATZUG2L2:3) PMATZUG2L2;
       MZTIV = %DEC(%TIME());
       MZDTV = %DEC(%DATE():*ISO);
       MZVSH1 = *ON;
       UPDATE PMATZUGFL2;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHBBEK
     C/COPY QCPYSRC,CHBBPA
     C/COPY QCPYSRC,CHIFLB
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHLBSS
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHLGPA
     C/COPY QCPYSRC,CHPARK
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
