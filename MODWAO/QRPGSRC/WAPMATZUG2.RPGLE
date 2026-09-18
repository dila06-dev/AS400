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
      //  Änderung: SZ 16.10.2015 eingelesene Daten auf IFLB, IFLG und IFRK ver-
      //            teilen
      //  Änderung: SZ 21.10.2015 bei bestimmten Buchungsschlüsseln zusätzliche
      //            Felder füllen (nach Lager)
      //  Änderung: SZ 28.10.2015 Auch bei Prod.-Auftrag Rückmeldung steht die
      //            trend Belegnummer in MZWENR
      //  Änderung: SZ 05.11.2015 die Verteilung auf IFLG und IFRK ist nicht
      //            mehr relevant. Die Rückmeldungen zu Retouren sind nur Umbu-
      //            chungen von Lager 180 auf 001. Ebenso sind die Rückmeldungen
      //            zu Produktionsaufträgen nur die Umbuchungen von Lager 300
      //            bzw. 200 auf 001.
      //  Änderung: SZ 24.11.2015 bei Rückmeldung der Bereitstellung Material zur
      //            Produktion/Konfektionierung steht die Vorgangsnummer in Feld
      //            MZANR1.
      //  Änderung: SZ 25.11.2015 bei Beistellung auch
      //  Änderung: SZ 10.12.2015 SR ELANR zur Festlegung der Lagernummern
      //            Abfrage Buchungsschlüssel überarbeitet.
      //  Änderung: SZ 12.01.2016 Sperrlager 94, 95, 96 analog Sperrgrund statt
      //            Platz 002
      //  Änderung: SZ 01.02.2016 Umlagerung von Lager 180 auf 001, Reparatur
      //  Änderung: SZ 04.02.2016 Reihenfolge für Festlegung DANA, DAKY geändert
      //  Änderung: SZ 24.02.2016 nach Absprache mit Hr. Schneider die letzen 3
      //            Stellen der Kostenstelle übernehmen.
      //  Änderung: SZ 20.07.2016 Umlagerungen auf Lager 008/009 mit Platz 001
      //  Änderung: SZ 14.11.2017 Sätze mit Sperrgrund '98' überlesen
      //  Änderung: SZ 18.04.2018 Lager 210 für Produktion EZetil
      //  Änderung: SZ 07.08.2019 Projekt 15084, 2.Firma LFS, Verarbeitung in
      //            Schleife
      //  Änderung: SZ 15.12.2021 Update PMATZUG2 auch bei Art '98' nur, wenn
      //            nicht schon geflagt.
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
      //  Die automatisch eingestellten Lager und Plätze sind abhängig von den
      //  Buchungsschlüsseln:
      //  LSTC         Lager Platz      nach Lager nach Platz
      //  950          100   ohne       001        001        WE Umbuchung
      //  950          110   ohne       094        ohne       WE Umbuchung QS
      //  950          500   ohne       001        001        WE Umbuchung FOB
      //  950          001   001        300        ohne       Bereitstellung Prod.
      //
      //  950          001   001        008        001        Umlagerung Reparatur
      //  950          001   001        009        001        Umlagerung Reparatur
      //  950          100   ohne       008        001        Umlagerung WE nach Reparatur
      //  950          100   ohne       009        001        Umlagerung WE nach Reparatur
      //
      //  510          001   001        ohne       ohne       Abgang Bruch
      //  513          001   001        094        ohne       Bruch im Bestand
      //  140                                                 Rücklieferung von
      //  130          001   001        ohne       ohne       Abgang Versand
      //  825                                                 Wareneingang
      //  300                                                 Umlagerung
      //  822          001   001        004        ohne       Umlagerung in Verkauf
      //  950                                                 Umlagerung automatisch
      //  601          001   001        200        ohne       Umlagerung Produktion
      //  600          001   001        300        ohne       Umlagerung Konfektionierung
      //  911          001   001        ohne       ohne       Inventurdifferenz -
      //  921          ohne  ohne       001        001        Inventurdifferenz +
      //  930          001   001        ohne       ohne       Bestandsdifferenz -
      //  931          ohne  ohne       001        001        Bestandsdifferenz +
      //  957          001   001        094        ohne       sperren
      //  958          094   ohne       001        001        entsperren
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPMATZUG2L1UF A E           K DISK    USROPN RENAME(PMATZUGF:PMATZUGFL1)
     FPMATZUG2L2UF A E           K DISK    USROPN RENAME(PMATZUGF:PMATZUGFL2)

      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D MND             S                   DIM(99) INZ LIKE(MZFIRM)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BBEK          E DS                  INZ
     D KYBBEK        E DS                  INZ

     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ

     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ

     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ

     D IFLB          E DS                  INZ
     D KYIFLB        E DS                  INZ
     D WKIFLB        E DS                  EXTNAME(IFLB) PREFIX(WK) INZ

     D IFLG          E DS                  INZ
     D KYIFLG        E DS                  INZ
     D WKIFLG        E DS                  EXTNAME(IFLG) PREFIX(WK) INZ

     D IFRK          E DS                  INZ
     D KYIFRK        E DS                  INZ
     D WKIFRK        E DS                  EXTNAME(IFRK) PREFIX(WK) INZ

     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ

     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ

     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ

     D LGPA          E DS                  INZ
     D KYLGPA        E DS                  INZ

     D LGWE          E DS                  INZ
     D KYLGWE        E DS                  INZ

     D PAFP          E DS                  INZ
     D KYPAFP        E DS                  INZ

     D PARK          E DS                  INZ
     D KYPARK        E DS                  INZ

     D PAUK          E DS                  INZ
     D KYPAUK        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ

     D KYPMATZUG2L1    DS                  LIKEREC(PMATZUGFL1:*KEY)
     D KYPMATZUG2L2    DS                  LIKEREC(PMATZUGFL2:*KEY)

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

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
     D WKIUPD          S              1
     D WKVOAR          S              1
     D WKFENR          S              4
     D WKIFLBC100      S            100A
     D WKIFLBN080      S              8S 0
     D WKIFLBN120      S             12S 0
     D WKIFLBN134      S             13S 4
     D WKIFLBN145      S             14S 5
     D WKLSTCBRU       S                   LIKE(IFLBLSTC)
     D WKLSTCBRB       S                   LIKE(IFLBLSTC)
     D WKLSTCABG       S                   LIKE(IFLBLSTC)
     D WKLSTCABE       S                   LIKE(IFLBLSTC)
     D WKLSTCWAE       S                   LIKE(IFLBLSTC)
     D WKLSTCPRD       S                   LIKE(IFLBLSTC)
     D WKLSTCRET       S                   LIKE(IFLBLSTC)
     D WKLSTCREP       S                   LIKE(IFLBLSTC)
     D WKLSTCINM       S                   LIKE(IFLBLSTC)
     D WKLSTCINP       S                   LIKE(IFLBLSTC)
     D WKLSTCBAB       S                   LIKE(IFLBLSTC)
     D WKLSTCBZU       S                   LIKE(IFLBLSTC)
     D WKLSTCUML       S                   LIKE(IFLBLSTC)
     D WKLSTCUMP       S                   LIKE(IFLBLSTC)
     D WKLSTCUMK       S                   LIKE(IFLBLSTC)
     D WKLSTCUMA       S                   LIKE(IFLBLSTC)
     D WKLSTCUMV       S                   LIKE(IFLBLSTC)
     D WKLSTCSPE       S                   LIKE(IFLBLSTC)
     D WKLSTCENT       S                   LIKE(IFLBLSTC)
     D I1              S              3S 0
     D I2              S              3S 0

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
         EXSR ESYTP;
       ENDIF;

       EXSR VORLAUF;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       OPEN PMATZUG2L1;
       OPEN PMATZUG2L2;

       I1 = 1;
       DOW MND(I1) <> *BLANK;
         EXSR VPMATZUG2;
         I1 = I1 + 1;
       ENDDO;

       CLOSE PMATZUG2L1;
       CLOSE PMATZUG2L2;

       IF WKIUPD = *OFF;
         DAFEHL = *ON;
       ENDIF;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYIFLBFIRM = DAFIRM;                                                     // IFLB
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYEKFI = DAFIRM;                                                         // BBEK
       KYBBKMFIRM = DAFIRM;                                                     // BBKM
       KYPAFI = DAFIRM;                                                         // BBPA
       KYAEFI = DAFIRM;                                                         // BWAE
       KYLSFI = DAFIRM;                                                         // LBSS
       KYLFFI = DAFIRM;                                                         // LIEF
       KYLGKOFIRM = DAFIRM;                                                     // LGKO
       KYLGPOFIRM = DAFIRM;                                                     // LGPO
       KYLGPAFIRM = DAFIRM;                                                     // LGPA
       KYLGWEFIRM = DAFIRM;                                                     // LGWE
       KYFPFI = DAFIRM;                                                         // PAFP
       KYRKFI = DAFIRM;                                                         // PARK
       KYUKFI = DAFIRM;                                                         // PAUK
       KYLBLBFIRM = DAFIRM;                                                     // LBLB
       KYTEFI = DAFIRM;                                                         // TEIL

       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;

       WKLSTCBRU = '510';                                                       // ABGANG BRUCH
       WKLSTCBRB = '513';                                                       // BRUCH IM BESTAND
       WKLSTCRET = '140';                                                       // RÜCKLIEFERUNG VON
       WKLSTCABE = '141';                                                       // ABGANG E-TEILE
       WKLSTCREP = '142';                                                       // REPARATUR
       WKLSTCABG = '130';                                                       // ABGANG VERSAND
       WKLSTCWAE = '825';                                                       // WARENEINGANG
       WKLSTCPRD = '820';                                                       // ZUGANG PRODUKTION
       WKLSTCUML = '300';                                                       // UMLAGERUNG
       WKLSTCUMV = '822';                                                       // UMLAGERUNG VERKAU
       WKLSTCUMA = '950';                                                       // UMLAGERUNG AUTOMA
       WKLSTCUMP = '601';                                                       // UMLAGERUNG PRODUK
       WKLSTCUMK = '600';                                                       // UMLAGERUNG KONFEK
       WKLSTCINM = '911';                                                       // INVENTUR ABGANG
       WKLSTCINP = '921';                                                       // INVENTUR ZUGANG
       WKLSTCBAB = '930';                                                       // BESTAND ABGANG
       WKLSTCBZU = '931';                                                       // BESTAND ZUGANG
       WKLSTCSPE = '957';                                                       // SPERREN
       WKLSTCENT = '958';                                                       // ENTSPERREN

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

       DAFEHL = *OFF;
       WKIUPD = *OFF;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG DATEN VON LFS                                        ***
       //*************************************************************************
       BEGSR VPMATZUG2;

       KYPMATZUG2L1.MZKONZ = 'EMS';
       KYPMATZUG2L1.MZFIRM = MND(I1);
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

         IF WKIIFL = *ON
           AND (MZQKZA = '98'
           OR MZQKZN = '98');
           WKIIFL = *OFF;
           EXSR UPMATZUG2;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPMATZUG2;
           EXSR ELANR;
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
       WKIFLBDTEI = 'PMATZUG2';
       WKIFLBERZT = %DEC(%TIME());
       WKIFLBERDA = %DEC(%DATE():*ISO);
       WKIFLBERUS = DAUSER;
       WKIFLBFENR = '0000';
       WKIFLBKZ01 = *OFF;
       WKIFLBKZ02 = *OFF;
       WKIFLBKZ03 = *OFF;
       WKIFLBKZ04 = *OFF;
       WKIFLBKZ05 = *OFF;
       WKIFLBKZ06 = *OFF;
       WKIFLBKZ07 = *OFF;
       WKIFLBKZ08 = *OFF;
       WKIFLBKZ09 = *OFF;
       WKIFLBKZ10 = *OFF;
       WKIFLBKZ11 = *OFF;
       WKIFLBKZ12 = *OFF;
       WKIFLBKZ13 = *OFF;
       WKIFLBKZ14 = *OFF;
       WKIFLBKZ15 = *OFF;
       WKIFLBKZ16 = *OFF;
       WKIFLBKZ17 = *OFF;
       WKIFLBKZ18 = *OFF;
       WKIFLBKZ19 = *OFF;
       WKIFLBKZ20 = *OFF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN LAGER                                                   ***
       //*************************************************************************
       BEGSR ELANR;

         IF WKIFLBLANR = '001';
           WKIFLBLORT = '001';
         ENDIF;

         SELECT;
         WHEN WKIFLBULNR = '001';
           WKIFLBUORT = '001';
         WHEN WKIFLBULNR = '008';
           WKIFLBUORT = '001';
         WHEN WKIFLBULNR = '009';
           WKIFLBUORT = '001';
         ENDSL;

         IF WKIFLBLANR = '110';
           WKIFLBULNR = '094';
           WKIFLBUORT = '   ';
         ENDIF;

         SELECT;
         WHEN WKIFLBLSTC = WKLSTCSPE;                                            // Sperren
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
           WKIFLBULNR = '0' + WKIFLBSPGR;
           WKIFLBUORT = '   ';
         WHEN WKIFLBLSTC = WKLSTCBRB;                                            // Bruch im Bestand
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
           WKIFLBULNR = '0' + WKIFLBSPGR;
           WKIFLBUORT = '   ';
         WHEN WKIFLBLSTC = WKLSTCENT;                                            // Entsperren
           WKIFLBLANR = '0' + WKIFLBSPGR;
           WKIFLBLORT = '   ';
           WKIFLBULNR = '001';
           WKIFLBUORT = '001';
           WKIFLBSPKZ = ' ';
           WKIFLBSPGR = ' ';
         WHEN WKIFLBLSTC = WKLSTCUMV;                                            // Umlagerung Verka
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
           WKIFLBULNR = '004';
           WKIFLBUORT = *BLANK;
         WHEN WKIFLBLSTC = WKLSTCRET;                                            // Umlagerung Retou
           WKIFLBLANR = '180';
           WKIFLBLORT = *BLANK;
           WKIFLBULNR = '001';
           WKIFLBUORT = '001';
           WKIFLBSPKZ = ' ';
           WKIFLBSPGR = ' ';
         WHEN WKIFLBLSTC = WKLSTCREP;                                            // Umlagerung Repar
           WKIFLBLANR = '180';
           WKIFLBLORT = *BLANK;
           WKIFLBULNR = '001';
           WKIFLBUORT = '001';
         WHEN WKIFLBLSTC = WKLSTCUMP;                                            // Umlagerung Produ
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
           WKIFLBULNR = '200';
           WKIFLBUORT = *BLANK;
         WHEN WKIFLBLSTC = WKLSTCUMA AND                                         // Umlagerung Trans
           WKIFLBLANR = '240';
           WKIFLBLORT = *BLANK;
           WKIFLBULNR = '001';
           WKIFLBUORT = '001';
         WHEN WKIFLBLSTC = WKLSTCINP AND                                         // Inventur +
           WKIFLBULNR = '001';
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
         WHEN WKIFLBLSTC = WKLSTCBZU AND                                         // Korrektur +
           WKIFLBULNR = '001';
           WKIFLBLANR = '001';
           WKIFLBLORT = '001';
         ENDSL;

         SELECT;
         WHEN WKIUML = *ON AND WKIFLBULNR = *BLANK AND WKIFLBUORT = *BLANK;
           WKIFLBULNR = WKIFLBLANR;
           WKIFLBUORT = WKIFLBLORT;
         ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN ZUSATZDATEN                                             ***
       //*************************************************************************
       BEGSR EIFLB;

       SELECT;
       WHEN WKIFLBDANA = 'BBKM';                                                // Beistellung BBKM
         EXSR EBBKM;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'BRLK';                                                // Rückmeldung BRLK
         EXSR EBRLK;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'PARK';                                                // Wareneingang PARK
         EXSR EPARK;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'BWAE';                                                // Wareneingang BWAE
         EXSR EBWAE;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'LGKO';                                                // Wareneingang LGKO
         EXSR ELGKO;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'LGPO';                                                // Wareneingang LGPO
         EXSR ELGPO;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'LGWE';                                                // Wareneingang LGWE
         EXSR ELGWE;
         EXSR ETENR;
       WHEN WKIFLBDANA = 'INVE';                                                // Inventur
         EXSR ETENR;
       WHEN WKIFLBDANA = 'PAUM';                                                // Bereitstellung Pr
         EXSR EPAUM;
         EXSR ETENR;
       WHEN WKIFLBDANA = '    ';                                                // Lagerbewegung
         EXSR ETENR;
       ENDSL;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BEISTELLUNG                                   ***
       //*************************************************************************
       BEGSR EBBKM;

       KYBBKMKMJJ = WKIFLBBLJJ;
       KYBBKMKMNR = WKIFLBBLNR;
       CHIDS = '01C';
       EXSR CHBBKM;

       IF WKFENR <> '0000';
         WKIFLBFENR = WKFENR;
         WKIFLBFFLD = 'CHBBKM';
         LEAVESR;
       ENDIF;

       KYLFNR = BBKMLFNR;
       CHIDS = '01C';
       EXSR CHLIEF;

       IF WKFENR <> '0000';
         WKIFLBFENR = WKFENR;
         WKIFLBFFLD = 'CHLIEF';
         LEAVESR;
       ENDIF;

       WKIFLBULNR = LFLANR;
       //WKIFLBUORT = LFLFNR;
       WKIFLBUORT = *BLANK;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RÜCKLIEFERUNG AN LIEFERANTEN                  ***
       //*************************************************************************
       BEGSR EBRLK;


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BESTELLUNG                                    ***
       //*************************************************************************
       BEGSR EBWAE;

       KYAEWJ = WKIFLBBLJJ;
       KYAEWE = WKIFLBBLNR;
       CHIDS = '07C';
       EXSR CHBWAE;

       KYEKJH = AEBEJJ;
       KYEKBE = AEBENR;
       CHIDS = '01C';
       EXSR CHBBEK;

       KYPAAT = EKBEAT;
       CHIDS = '01C';
       EXSR CHBBPA;

       IF WKIFLBLSTC = *BLANK;
         WKIFLBLSTC = PALSTC;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR LAGERBUCHUNG                                  ***
       //*************************************************************************
       BEGSR ETENR;

       SELECT;
       WHEN WKIFLBTENR <> *BLANK AND WKIFLBTENR <> 'ENDE';
         KYTENR = WKIFLBTENR;
         CHIDS = '01C';
         EXSR CHTEIL;

         IF WKIFLBBWME = *BLANK;
           WKIFLBBWME = TEMEVK;
         ENDIF;
       WHEN WKIFLBTENR = 'ENDE';
         WKIFLBPGST = WKIFLBTENR;
       ENDSL;

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

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RETOUREN VOM KUNDEN                           ***
       //*************************************************************************
       BEGSR ELGPO;

       KYLGPOLGJJ = WKIFLBBLJJ;
       KYLGPOLGNR = WKIFLBBLNR;
       KYLGPOLGPO = WKIFLBPOSI;
       CHIDS = '01C';
       EXSR CHLGPO;

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

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR RETOUREN VOM KUNDEN UNTERPOSITION             ***
       //*************************************************************************
       BEGSR ELGWE;

       KYLGPOLGJJ = WKIFLBBLJJ;
       KYLGPOLGNR = WKIFLBBLNR;
       KYLGPOLGPO = WKIFLBBLPO;
       CHIDS = '01C';
       EXSR CHLGPO;

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

       KYLGWELGJJ = WKIFLBBLJJ;
       KYLGWELGNR = WKIFLBBLNR;
       KYLGWELGPO = WKIFLBBLPO;
       KYLGWEUPOS = *ZERO;
       CHIDS = '01+';
       EXSR CHLGWE;

       DOW WKFENR = '0000' AND
         LGWEFIRM = KYLGWEFIRM AND
         LGWELGJJ = KYLGWELGJJ AND
         LGWELGNR = KYLGWELGNR AND
         LGWELGPO = KYLGWELGPO;
           IF LGWEBARC = WKIFLBREFN;
             WKIFLBBLUP = LGWEUPOS;
             LEAVE;
           ENDIF;
         CHIDS = '01R';
         EXSR CHLGWE;
       ENDDO;

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

       WKIFLBLSTC = WKLSTCUML;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       KYFPAT = RKPPAT;
       CHIDS = '01C';
       EXSR CHPAFP;

       SELECT;
       WHEN RKZULG <> *BLANK;
         WKIFLBLANR = RKZULG;
         WKIFLBLORT = RKLORT;
       WHEN FPZULG <> *BLANK;
         WKIFLBLANR = FPZULG;
         WKIFLBLORT = RKLORT;
       WHEN RKPPAT = '300';                                                      // KONFEKTIONIERUNG
         WKIFLBLANR = '300';
         WKIFLBLORT = *BLANK;
       WHEN RKPPAT = '100';                                                      // PRODUKTION
         WKIFLBLANR = '200';
         WKIFLBLORT = *BLANK;
       WHEN RKPPAT = '600';                                                      // EZETIL
         WKIFLBLANR = '210';
         WKIFLBLORT = *BLANK;
       ENDSL;

         WKIFLBULNR = '001';
         WKIFLBUORT = '001';
         WKFENR = '0000';
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BEREITSTELLUNG ZU PROD.-AUFTRAG               ***
       //*************************************************************************
       BEGSR EPAUM;

       KYUKJH = WKIFLBBLJJ;
       KYUKPP = WKIFLBBLNR;
       CHIDS = '01C';
       EXSR CHPAUK;

       KYLSTC = WKIFLBLSTC;
       KYLSLA = *BLANK;
       CHIDS = '01C';
       EXSR CHLBSS;
       WKIFLBLBSC = LSLBSC;

       KYFPAT = UKPPAT;
       CHIDS = '01C';
       EXSR CHPAFP;

       SELECT;
       WHEN UKZULG <> *BLANK;
         WKIFLBULNR = UKZULG;
         WKIFLBUORT = *BLANK;
         WKIFLBLSTC = WKLSTCUMK;
       WHEN UKPPAT = '300';                                                      // KONFEKTIONIERUNG
         WKIFLBULNR = '300';
         WKIFLBUORT = *BLANK;
         WKIFLBLSTC = WKLSTCUMK;
       WHEN UKPPAT = '100';                                                      // PRODUKTION
         WKIFLBULNR = '200';
         WKIFLBUORT = *BLANK;
         WKIFLBLSTC = WKLSTCUMP;
       WHEN UKPPAT = '600';                                                      // EZETIL
         WKIFLBULNR = '210';
         WKIFLBUORT = *BLANK;
         WKIFLBLSTC = WKLSTCUMP;
       ENDSL;

         WKIFLBLANR = '001';
         WKIFLBLORT = '001';
         WKFENR = '0000';
       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI IFLB                                       ***
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

       WKIUPD = *ON;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI IFLG                                       ***
       //*************************************************************************
       BEGSR UIFLG;

       KYIFLGFIRM = WKIFLBFIRM;
       KYIFLGTSTP = WKIFLBTSTP;
       CHIDS = '01CU';
       EXSR CHIFLG;

       IFLGLGJJ = WKIFLBBLJJ;
       IFLGLGNR = WKIFLBBLNR;
       IFLGLGPO = WKIFLBBLPO;
       IFLGUPOS = WKIFLBBLUP;
       IFLGLANR = WKIFLBLANR;
       IFLGLORT = WKIFLBLORT;
       IFLGTENR = WKIFLBTENR;
       IFLGGEBI = WKIFLBGEBI;
       IFLGCHAR = WKIFLBCHAR;
       IFLGFUMG = WKIFLBFUMG;
       IFLGMEFM = WKIFLBMEIN;
       IFLGBARC = WKIFLBBHNR;
       IFLGBDAT = WKIFLBBDAT;
       IFLGBZEI = WKIFLBBZEI;
       IFLGISMG = WKIFLBBWMG;
       IFLGMEIN = WKIFLBBWME;
       IFLGHSDA = WKIFLBHSDA;
       IFLGVEDA = WKIFLBVEDA;
       IFLGTLKZ = DANEKZ;

       IFLGSEDA = WKIFLBBDAT;
       IFLGSEZT = WKIFLBBZEI;
       IFLGSTAT = WKIFLBSTAT;
       IFLGDATN = WKIFLBDTEI;
       IFLGFENR = WKIFLBFENR;
       IFLGFFLD = WKIFLBFFLD;

       IFLGJNAM = WKIFLBJNAM;
       IFLGPROG = WKIFLBPROG;
       IFLGBIBL = WKIFLBBIBL;
       IFLGUSER = WKIFLBUSER;
       IFLGJZEI = WKIFLBJZEI;
       IFLGJDAT = WKIFLBJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFLGERDA = WKIFLBERDA;
         IFLGERZT = WKIFLBERZT;
         IFLGERUS = WKIFLBERUS;
         CHIDS = '01W';
         EXSR CHIFLG;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFLG;
       ENDSL;

       WKIUPD = *ON;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI IFRK                                       ***
       //*************************************************************************
       BEGSR UIFRK;

       KYIFRKFIRM = WKIFLBFIRM;
       KYIFRKTSTP = WKIFLBTSTP;
       CHIDS = '01CU';
       EXSR CHIFRK;

       IFRKPPJJ = WKIFLBBLJJ;
       IFRKPPNR = WKIFLBBLNR;
       IFRKLANR = WKIFLBLANR;
       IFRKLORT = WKIFLBLORT;
       IFRKTENR = WKIFLBTENR;
       IFRKCHAR = WKIFLBCHAR;
       IFRKMEIN = WKIFLBMEIN;
       IFRKBDAT = WKIFLBBDAT;
       IFRKBZEI = WKIFLBBZEI;
       IFRKRMMG = WKIFLBBWMG;
       IFRKMEIN = WKIFLBBWME;
       IFRKHSDA = WKIFLBHSDA;
       IFRKVEDA = WKIFLBVEDA;

       IFRKSTAT = WKIFLBSTAT;
       IFRKDATN = WKIFLBDTEI;
       IFRKFENR = WKIFLBFENR;
       IFRKFFLD = WKIFLBFFLD;

       IFRKJNAM = WKIFLBJNAM;
       IFRKPROG = WKIFLBPROG;
       IFRKBIBL = WKIFLBBIBL;
       IFRKUSER = WKIFLBUSER;
       IFRKJZEI = WKIFLBJZEI;
       IFRKJDAT = WKIFLBJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFRKERDA = WKIFLBERDA;
         IFRKERZT = WKIFLBERZT;
         IFRKERUS = WKIFLBERUS;
         CHIDS = '01W';
         EXSR CHIFRK;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFRK;
       ENDSL;

       WKIUPD = *ON;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPMATZUG2;

         WKIUML = *OFF;
         WKVOAR = ' ';
         WKIFLBTSTP = %DATE(MZDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(MZTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(MZTIDI:'X'):7:6):6:0));
         WKIFLBSTKZ = *BLANK;
         WKIFLBLSTC = MZBUSL;

         SELECT;
         WHEN MZBUSL = WKLSTCWAE; // Umlagerung Wareneingang in 001
           WKIFLBLSTC = WKLSTCUMA;
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCPRD; // Umlagerung Fertigware in 001
           WKIFLBLSTC = WKLSTCUMA;
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCUMP; // Umlagerung Bereitstellung Produktion
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCUMK; // Umlagerung Bereitstellung Konfektionierung
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCUML; // Umlagerung manuell
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCUMA; // Umlagerung automatisch (Interface)
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCUMV; // Umlagerung in den Werkverkauf
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCRET; // Umlagerung Retoure von 180 nach 001
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCREP; // Umlagerung Retoure von 180 nach 001
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCENT; // Entsperren
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCSPE; // Sperren
           WKIUML = *ON;
         WHEN MZBUSL = WKLSTCBRB; // Bruch im Bestand
           WKIUML = *ON;
         ENDSL;

         WKIFLBSZAR = MZSART;
         WKIFLBLBSC = *BLANK;
         WKIFLBTMST = *ZERO;
         WKIFLBBSLA = *BLANK;
         WKIFLBLANR = MZVHLO;
         WKIFLBULNR = MZNHLO;
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
         OTHER;
           WKIFLBBWME = MZME;
         ENDSL;

         WKIFLBSTMG = *ZERO;

         IF %SUBST(MZANR1:1:1) = 'U' OR %SUBST(MZANR1:1:1) = 'B';
           WKVOAR = %SUBST(MZANR1:1:1);
         ELSE;
           WKVOAR = %SUBST(MZWENR:1:1);
             SELECT;
             WHEN WKVOAR = 'B';
               WKVOAR = 'G';
             WHEN WKVOAR = 'W' AND MZVSST = 110;
               WKVOAR = 'W';
             WHEN WKVOAR = 'W' AND MZVSST = 115;
               WKVOAR = 'W';
             WHEN WKVOAR = 'W';
               WKVOAR = 'F';
             ENDSL;
         ENDIF;

         SELECT;
         WHEN WKVOAR = 'U' OR WKVOAR = 'B';
           MONITOR;
             WKIFLBBLJJ = %DEC(%SUBST(MZANR1:4:4):4:0);
           ON-ERROR;
             WKIFLBBLJJ = 0;
           ENDMON;

           WKIFLBBLNR = %SUBST(MZANR1:8:6);

           MONITOR;
             WKIFLBBLPO = %DEC(MZANRP:5:0);
           ON-ERROR;
             WKIFLBBLPO = 1;
           ENDMON;
         WHEN WKVOAR = 'P' OR WKVOAR = 'W' OR WKVOAR = 'R';
           MONITOR;
             WKIFLBBLJJ = %DEC(%SUBST(MZWENR:2:2):2:0) + 2000;
           ON-ERROR;
             WKIFLBBLJJ = 0;
           ENDMON;

           WKIFLBBLNR = %SUBST(MZWENR:4:6);

           MONITOR;
             WKIFLBBLPO = %DEC(MZWEPO:5:0);
           ON-ERROR;
             WKIFLBBLPO = 1;
           ENDMON;
         WHEN WKVOAR = 'G';
           MONITOR;
             WKIFLBBLJJ = %DEC(%SUBST(MZWENR:2:2):2:0) + 2000;
           ON-ERROR;
             WKIFLBBLJJ = 0;
           ENDMON;

           WKIFLBBLNR = %SUBST(MZWENR:4:6);
           WKIFLBREFN = MZIDV;

           MONITOR;
             WKIFLBBLPO = %DEC(MZBSTP:5:0);
           ON-ERROR;
             WKIFLBBLPO = 1;
           ENDMON;
         ENDSL;

         IF WKIFLBBLNR <> *BLANK;
           WKIFLBDAKY = %EDITC(WKIFLBBLJJ:'X') + WKIFLBBLNR +
                        %EDITC(WKIFLBBLPO:'X') + '000';
         ENDIF;

         SELECT;
         WHEN WKIFLBLSTC = WKLSTCUMP;                                            // Umlagerung Produ
           WKIFLBDANA = 'PAUM';
           WKIFLBDAKY = *BLANK;
         WHEN WKIFLBLSTC = WKLSTCSPE                                             // Sperren
           OR WKIFLBLSTC = WKLSTCENT                                             // Entsperren
           OR WKIFLBLSTC = WKLSTCUMV                                             // Umlagerung Verka
           OR WKIFLBLSTC = WKLSTCBAB                                             // Bestand Abgang
           OR WKIFLBLSTC = WKLSTCBZU                                             // Bestand Zugang
           OR WKIFLBLSTC = WKLSTCBRU                                             // Bruch
           OR WKIFLBLSTC = WKLSTCBRB                                             // Bruch im Bestand
           OR WKIFLBLSTC = WKLSTCABE                                             // Abgang E-Teile
           OR WKIFLBLSTC = WKLSTCREP;                                            // Reparatur
           WKIFLBDANA = *BLANK;
           WKIFLBDAKY = *BLANK;
         WHEN WKVOAR = 'W';                                                      // Wareneingang
           WKIFLBDANA = 'BWAE';
         WHEN WKVOAR = 'U';                                                      // Bereitstellung P
           WKIFLBDANA = 'PAUM';
         WHEN WKVOAR = 'P';                                                      // Prod.-Auftrag
           WKIFLBDANA = 'PARK';
         WHEN WKVOAR = 'L';                                                      // Retourenposition
           WKIFLBDANA = 'LGPO';
         WHEN WKVOAR = 'R';                                                      // Retoure
           WKIFLBDANA = 'LGKO';
         WHEN WKVOAR = 'G';                                                      // Retoure Unterpos
           WKIFLBDANA = 'LGWE';
         WHEN WKVOAR = 'B';                                                      // Beistellung
           WKIFLBDANA = 'BBKM';
         WHEN WKVOAR = 'F';                                                      // Bestandführung
           WKIFLBDANA = *BLANK;
           WKIFLBDAKY = *BLANK;
         WHEN MZBBER = 'BF';                                                     // Bestandführung
           WKIFLBDANA = *BLANK;
           WKIFLBDAKY = *BLANK;
         ENDSL;

         WKIFLBBLUP = *ZERO;
         WKIFLBWBKT = *BLANK;
         WKIFLBEBKT = *BLANK;
         WKIFLBKONT = *BLANK;
         WKIFLBKOTR = *BLANK;

         SELECT;
         WHEN MZKST > 999;
           WKIFLBKSST = %SUBST(%EDITC(MZKST:'X'):4:4);
         WHEN MZKST <> 0;
           WKIFLBKSST = %SUBST(%EDITC(MZKST:'X'):5:3);
         ENDSL;

         WKIFLBKOAR = *BLANK;
         WKIFLBBEZ1 = %CHAR(MZHW);
         WKIFLBBEZ2 = *BLANK;

         WKIFLBFRNN = *ZERO;
         WKIFLBLBRS = *BLANK;
         WKIFLBRSKZ = *BLANK;
         WKIFLBQSST = *BLANK;
         WKIFLBQSTM = *ZERO;
         WKIFLBQSES = *BLANK;
         CLEAR WKIFLBRPTS;
         WKIFLBGECH = *BLANK;
         WKIFLBLAPR = *BLANK;

         SELECT;
         WHEN MZQKZN <> *BLANK;
           WKIFLBSPKZ = DAJNKZ;
           WKIFLBSPGR = MZQKZN;
         WHEN MZQKZA <> *BLANK;
           WKIFLBSPKZ = DAJNKZ;
           WKIFLBSPGR = MZQKZA;
         ENDSL;

         WKIFLBPOSI = *ZERO;
         WKIFLBFESP = *BLANK;
         WKIFLBCHEX = *BLANK;
         WKIFLBHSDA = *ZERO;
         WKIFLBHSZT = *ZERO;
         WKIFLBVEDA = MZDTDC;

         IF MZEXRF <> 0 AND WKIFLBREFN = *BLANK;
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
       //**  ERMITTELN FIRMEN LFS AUS TABELLE                                  ***
       //*************************************************************************
       BEGSR ESYTP;

         CLEAR MND;
         KYSYTPTART = '$$COMPANY';
         KYSYTPTCDE = *BLANK;
         KYSYTPTFLG = *ZERO;
         CHIDS = '01L';
         EXSR CHSYTP;

         FOR I1 = 1 TO 99;
           CHIDS = '01R';
           EXSR CHSYTP;

           IF WKFENR <> *ZERO
             OR SYTPFIRM <> KYSYTPFIRM
             OR SYTPTART <> KYSYTPTART;
             LEAVE;
           ENDIF;

           MND(I1) = SYTPTCDE;
         ENDFOR;

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
     C/COPY QCPYSRC,CHBBEK
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHBBPA
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHIFLB
     C/COPY QCPYSRC,CHIFLG
     C/COPY QCPYSRC,CHIFRK
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHLBSS
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHLGPA
     C/COPY QCPYSRC,CHLGWE
     C/COPY QCPYSRC,CHPAFP
     C/COPY QCPYSRC,CHPARK
     C/COPY QCPYSRC,CHPAUK
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
