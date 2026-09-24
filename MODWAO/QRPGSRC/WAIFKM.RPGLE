     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
     H BNDDIR('TRTXT') DFTACTGRP(*NO)
      //*************************************************************************
      /TITLE  Einlesen der Daten aus PSAVEAK2 von Erhard + Partner
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
      //  Änderung: SZ 23.01.2016 Projekt 11998 erneute Verarbeitung und Druck
      //            Lieferschein.
      //  Änderung: SZ 10.03.2016 Projekt 12321 AKDTLF nicht in LFTE sondern in
      //            LSDA (Lieferscheindatum) übernehmen.
      //  Änderung: SZ 19.07.2016 Beistellkommissionierung verarbeiten
      //
      //*************************************************************************
      //
      //  Dieses Programm füllt die trend Standard Schnittstellenfile IFKM mit
      //  den Daten aus PSAVEAK2. Die eingelesenen Daten werden in PSAVEAK2 als
      //  verarbeitet gekennzeichnet.
      //  Das Programm wird über CALL WAIFKMST direkt aus E+P aufgerufen und
      //  verarbeitet jeweils nur die Daten aus dem übergebenen Arbeitspaket.
      //  Die Kom.-Nummer wird zusätzlich zur Prüfung genutzt.
      //  Bei negativer Prüfung wird #CRTCD = 'N' zurückgegeben. Die weitere
      //  Verarbeitung in WAIFKMST wird dann abgebrochen.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPSAVEAK2L2UF A E           K DISK    USROPN RENAME(PANFKOPF:PANFKOPFL2)
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
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
      //
     D IFKM          E DS                  INZ
     D KYIFKM        E DS                  INZ
     D WKIFKM        E DS                  EXTNAME(IFKM) PREFIX(WK) INZ
      //
     D PAUK          E DS                  INZ
     D KYPAUK        E DS                  INZ
      //
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
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
     D KYPSAVEAK2L2    DS                  LIKEREC(PANFKOPFL2:*KEY)
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
     D WKIUML          S              1
     D WKFENR          S              4
     D WKIFKMC100      S            100A
     D WKIFKMN080      S              8S 0
     D WKIFKMN100      S             10S 0
     D WKIFKMN134      S             13S 4
     D WKIFKMN145      S             14S 5
     D WKLFS_KONZ      S              3A
     D WKLFS_MAND      S              3A
     D WKLFS_APNR      S              9S 0
     D WKLFS_APPO      S              6S 0
     D WKLFS_SART      S              1A
     D WKLFS_FIRM      S                   LIKE(AMFIRM)
     D WKLFS_KMJJ      S                   LIKE(AMKMJJ)
     D WKLFS_KMNR      S                   LIKE(AMKMNR)
     D WKLFS_DRUC      S                   LIKE(IFKMDRUC)
     D PCPGST          S                   LIKE(#CPGST)

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKIFKMTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKIFKMTSTP                        LIKE(WKIFKMTSTP)

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
       OPEN PSAVEAK2L2;
       EXSR VPSAVEAK2;
       CLOSE PSAVEAK2L2;
       EXSR UEGKOM;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYIFKMFIRM = DAFIRM;                                                     // IFKM
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYAMFI = DAFIRM;                                                         // AFKM
       KYAAFI = DAFIRM;                                                         // AFPA
       KYBBKMFIRM = DAFIRM;                                                     // BBKM
       KYUKFI = DAFIRM;                                                         // PAUK

       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;

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
       WKLFS_DRUC = %SUBST(#CKOMM:47:10);

       ENDSR;
       //*************************************************************************
       //**  UEBERGABE KOM-BEREICH                                             ***
       //*************************************************************************
       BEGSR UEGKOM;

       %SUBST(#CKOMM:57:26) = %CHAR(WKIFKMTSTP);

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         #CRTCD = ' ';

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG DATEN VON LFS                                        ***
       //*************************************************************************
       BEGSR VPSAVEAK2;

       KYPSAVEAK2L2.AKKONZ = WKLFS_KONZ;
       KYPSAVEAK2L2.AKFIRM = WKLFS_MAND;
       KYPSAVEAK2L2.AKAPN = WKLFS_APNR;
       SETLL %KDS(KYPSAVEAK2L2:3) PSAVEAK2L2;

       DOW NOT %EOF(PSAVEAK2L2) AND NOT %ERROR;
         WKIIFL = *OFF;
       //READ(N) PSAVEAK2L2;
         READ PSAVEAK2L2;

         IF %EOF OR %ERROR OR
           AKKONZ <> KYPSAVEAK2L2.AKKONZ OR
           AKFIRM <> KYPSAVEAK2L2.AKFIRM OR
           AKAPN <> KYPSAVEAK2L2.AKAPN;
           LEAVE;
         ENDIF;

         EXSR INWKIFKM;

         IF WKIFKMFENR <> '0000';
           LEAVE;
         ENDIF;

         IF AKVSH1 <> *ON;                                                      // SCHON VERARBEITET
           WKIIFL = *ON;
         ENDIF;

         IF PCPGST = 'NDRUCK';                                                  // ERNEUT VERARBEITE
           WKIIFL = *ON;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPSAVEAK2;
         ENDIF;

         IF (WKIFKMJAHR <> WKLFS_KMJJ OR
           WKIFKMNMKR <> WKLFS_KMNR) AND
           PCPGST <> 'NDRUCK';
           WKIIFL = *OFF;
           #CRTCD = 'N';
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EIFKM;
           EXSR UIFKM;
           EXSR UPSAVEAK2;
           #CRTCD = ' ';
         ELSE;
           #CRTCD = 'N';
         ENDIF;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  INIFKM- Inititalisieren WKIFKM                                    ***
       //*************************************************************************
       BEGSR INWKIFKM;

       CLEAR WKIFKM;
       WKIFKMFIRM = DAFIRM;
       WKIFKMWKNR = '001';
       WKIFKMSTAT = '00';
       WKIFKMDTEI = 'PSAVEAK2';
       WKIFKMERZT = %DEC(%TIME());
       WKIFKMERDA = %DEC(%DATE():*ISO);
       WKIFKMERUS = DAUSER;
       WKIFKMFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR EIFKM;

       SELECT;
       WHEN WKIFKMDANA = 'AFKM';
         WKIFKMSZAR = '03';                                                     // Rückmeldung AFKM
         EXSR EAFKM;
       WHEN WKIFKMDANA = 'BBKM';
         WKIFKMSZAR = '20';                                                     // Rückmeldung BBKM
         EXSR EBBKM;
       WHEN WKIFKMDANA = 'PAUK';
         WKIFKMSZAR = '11';
         EXSR EPAUK;
       ENDSL;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR KOMMISSIONIERUNG                              ***
       //*************************************************************************
       BEGSR EAFKM;

       KYAMJH = WKIFKMJAHR;
       KYAMKM = WKIFKMNMKR;
       CHIDS = '01C';
       EXSR CHAFKM;

       IF WKIFKMLFTE = *ZERO;
         WKIFKMLFTE = AMLFTE;
       ENDIF;

       KYAAAT = AMAFAT;
       CHIDS = '01C';
       EXSR CHAFPA;

       IF WKIFKMAFAT = *BLANK;
         WKIFKMAFAT = AMAFAT;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR BEISTELLUNG                                   ***
       //*************************************************************************
       BEGSR EBBKM;

       KYBBKMKMJJ = WKIFKMJAHR;
       KYBBKMKMNR = WKIFKMNMKR;
       CHIDS = '01C';
       EXSR CHBBKM;

       IF WKIFKMLFTE = *ZERO;
         WKIFKMLFTE = BBKMKMTE;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR PROD.-AUFTRAG                                 ***
       //*************************************************************************
       BEGSR EPAUK;

       KYUKJH = WKIFKMJAHR;
       KYUKPP = WKIFKMNMKR;
       CHIDS = '01C';
       EXSR CHPAUK;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR UIFKM;

       KYIFKMFIRM = WKIFKMFIRM;
       KYIFKMTSTP = WKIFKMTSTP;
       CHIDS = '01CU';
       EXSR CHIFKM;

       IFKMWKNR = WKIFKMWKNR;
       IFKMDANA = WKIFKMDANA;
       IFKMJAHR = WKIFKMJAHR;
       IFKMNMKR = WKIFKMNMKR;
       IFKMAFAT = WKIFKMAFAT;
       IFKMBSLA = WKIFKMBSLA;
       IFKMLANR = WKIFKMLANR;
       IFKMLORT = WKIFKMLORT;
       IFKMVSBD = WKIFKMVSBD;
       IFKMTOUR = WKIFKMTOUR;
       IFKMLKWN = WKIFKMLKWN;
       IFKMTFLG = WKIFKMTFLG;
       IFKMSORT = WKIFKMSORT;
       IFKMBUDA = WKIFKMBUDA;
       IFKMBUZT = WKIFKMBUZT;
       IFKMTENR = WKIFKMTENR;
       IFKMEANR = WKIFKMEANR;
       IFKMBWMG = WKIFKMBWMG;
       IFKMBWME = WKIFKMBWME;
       IFKMSTKZ = WKIFKMSTKZ;
       IFKMBEME = WKIFKMBEME;
       IFKMLIJJ = WKIFKMLIJJ;
       IFKMLINR = WKIFKMLINR;
       IFKMLSDA = WKIFKMLSDA;
       IFKMPCJJ = WKIFKMPCJJ;
       IFKMPCNR = WKIFKMPCNR;
       IFKMKMAT = WKIFKMKMAT;
       IFKMKMTE = WKIFKMKMTE;
       IFKMKMZT = WKIFKMKMZT;
       IFKMLFTE = WKIFKMLFTE;
       IFKMALZT = WKIFKMALZT;
       IFKMKDNR = WKIFKMKDNR;
       IFKMKOKZ = WKIFKMKOKZ;
       IFKMLAND = WKIFKMLAND;
       IFKMLIAR = WKIFKMLIAR;
       IFKMLIBD = WKIFKMLIBD;
       IFKMWKVS = WKIFKMWKVS;
       IFKMBAST = WKIFKMBAST;
       IFKMPRIO = WKIFKMPRIO;
       IFKMDRUC = WKIFKMDRUC;

       IFKMSZAR = WKIFKMSZAR;
       IFKMDTEI = WKIFKMDTEI;
       IFKMFENR = WKIFKMFENR;
       IFKMFFLD = WKIFKMFFLD;

       IFKMJNAM = WKIFKMJNAM;
       IFKMPROG = WKIFKMPROG;
       IFKMBIBL = WKIFKMBIBL;
       IFKMUSER = WKIFKMUSER;
       IFKMJZEI = WKIFKMJZEI;
       IFKMJDAT = WKIFKMJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFKMERDA = WKIFKMERDA;
         IFKMERZT = WKIFKMERZT;
         IFKMERUS = WKIFKMERUS;
         IFKMSTAT = WKIFKMSTAT;
         CHIDS = '01W';
         EXSR CHIFKM;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFKM;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPSAVEAK2;

         WKIUML = *OFF;
         WKIFKMTSTP = %DATE(AKDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(AKTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(AKTIDI:'X'):7:6):6:0));
         WKIFKMAFAT = AKAART;
         WKIFKMBSLA = *BLANK;
         WKIFKMLANR = AKORT;
         WKIFKMLORT = *BLANK;

         IF WKIFKMLANR = *BLANK;
           WKIFKMLANR = '001';
           WKIFKMLORT = '001';
         ENDIF;

         WKIFKMVSBD = AKVART;
         WKIFKMTOUR = AKTOUR;
         WKIFKMLKWN = *BLANK;
         WKIFKMTFLG = *ZERO;
         WKIFKMSORT = *BLANK;

         IF AKDTB <> 0;
           WKIFKMBUDA = AKDTB;
         ELSE;
           WKIFKMBUDA = %DEC(%DATE():*ISO);
         ENDIF;

         IF AKTIB <> 0;
           WKIFKMBUZT = AKTIB;
         ELSE;
           WKIFKMBUZT = %DEC(%TIME());
         ENDIF;

         WKIFKMTENR = *BLANK;
         WKIFKMEANR = *BLANK;
         WKIFKMBWMG = AKBMEN;

         SELECT;
         WHEN AKANR1 <> *BLANK AND %SUBST(AKANR1:1:1) = 'K';                     // Kom.-Schein
           MONITOR;
             WKIFKMJAHR = %DEC(%SUBST(AKANR1:4:4):4:0);
           ON-ERROR;
             WKIFKMJAHR = 0;
           ENDMON;

           WKIFKMNMKR = %SUBST(AKANR1:8:6);
           WKIFKMDANA = 'AFKM';

         WHEN AKANR1 <> *BLANK AND %SUBST(AKANR1:1:1) = 'B';                     // Beistellung
           MONITOR;
             WKIFKMJAHR = %DEC(%SUBST(AKANR1:4:4):4:0);
           ON-ERROR;
             WKIFKMJAHR = 0;
           ENDMON;

           WKIFKMNMKR = %SUBST(AKANR1:8:6);
           WKIFKMDANA = 'BBKM';

         WHEN AKANR1 <> *BLANK AND %SUBST(AKANR1:1:1) = 'T';                     // Kom.-Schein
           MONITOR;                                                              // Trägergestell
             WKIFKMJAHR = %DEC(%SUBST(AKANR1:4:4):4:0);
           ON-ERROR;
             WKIFKMJAHR = 0;
           ENDMON;

           WKIFKMNMKR = %SUBST(AKANR1:8:6);
           WKIFKMDANA = 'AFKM';

         WHEN AKANR1 <> *BLANK AND %SUBST(AKANR1:1:1) = 'P';                     // Prod.-Auftrag
           MONITOR;
             WKIFKMJAHR = %DEC(%SUBST(AKANR1:4:4):4:0);
           ON-ERROR;
             WKIFKMJAHR = 0;
           ENDMON;

           WKIFKMNMKR = %SUBST(AKANR1:8:6);
           WKIFKMDANA = 'PAUK';
         ENDSL;

         WKIFKMSTKZ = *BLANK;
         WKIFKMBEME = %CHAR(AKHW);
         WKIFKMLIJJ = *ZERO;
         WKIFKMLINR = *BLANK;
         WKIFKMLSDA = AKDTLF;
         WKIFKMPCJJ = *ZERO;
         WKIFKMPCNR = *BLANK;
         WKIFKMKMAT = *BLANK;
         WKIFKMKMTE = AKDTRD;
         WKIFKMKMZT = AKTIRD;
         WKIFKMLFTE = *ZERO;
         WKIFKMALZT = AKTILF;
         WKIFKMKDNR = AKKDNR;
         WKIFKMKOKZ = *BLANK;
         WKIFKMLAND = *BLANK;
         WKIFKMLIAR = *BLANK;
         WKIFKMLIBD = *BLANK;
         WKIFKMWKVS = *BLANK;
         WKIFKMBAST = *BLANK;
         WKIFKMPRIO = *BLANK;
         WKIFKMDRUC = AKOUTQ;

         IF WKLFS_DRUC <> *BLANK;
           WKIFKMDRUC = WKLFS_DRUC;
         ENDIF;

         IF PCPGST = 'NDRUCK';
           WKIFKMDRUC = WKLFS_DRUC;
         ENDIF;

         WKIFKMJNAM = AKBS;
         WKIFKMPROG = AKPGM;
         WKIFKMBIBL = WKCHPL;
         WKIFKMUSER = AKUSER;

         IF AKDTB <> 0;
           WKIFKMJDAT = AKDTB;
         ELSE;
           WKIFKMJDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF AKTIB <> 0;
           WKIFKMJZEI = AKTIB;
         ELSE;
           WKIFKMJZEI = %DEC(%TIME());
         ENDIF;
       ENDSR;
       //-------------------------------------------------------------------------------------------
       // Die nachfolgend aufgeführten Felder entsprechen in Ausprägung und Reihenfolge den Feldern
       // in der File PSAVEAK2.
       // Wenn der Inhalt aus zusätzlichen Feldern nach trend übernommen werden soll, dann die
       // Felder in den Bereich über die Linie kopieren (nicht ausschneiden). Danke.
       //
       BEGSR DUMMY;

         WKIFKMC100 = AKKONZ;     //                               A    1    3    KONZERN
         WKIFKMC100 = AKFIRM;     //                               A    4    6    FIRMA
         WKIFKMN100 = AKAPN;      //                               S    7   15 0  ARBEITS- PAKET-NR
         WKIFKMN100 = AKAPPO;     //                               S   16   21 0  ARBEITS- PAKET-POS
         WKIFKMN100 = AKAPN2;     //                               S   22   30 0  AP-NR 2.K-STUFE
         WKIFKMN100 = AKAPN3;     //                               S   31   39 0  ALTE AP-NR
         WKIFKMN100 = AKUAPN;     //                               S   40   48 0  URSPRUNGS- ARB-PAK
         WKIFKMC100 = AKUSTS;     //                               A   49   49    URSPR. STS LFS
         WKIFKMC100 = AKUKZH;     //                               A   50   50    KZ HERK. 1=UR
         WKIFKMC100 = AKUKNG;     //                               A   51   51    KENNUNG SPLITT-AP
         WKIFKMN100 = AKSPNO;     //                               S   52   60 0  SPLITT- NR
         WKIFKMC100 = AKSAP3;     //                               A   61   61    STATUS APN3
         WKIFKMC100 = AKSTEU;     //                               A   62   65    KENNZ. STEUERER
         WKIFKMC100 = AKGKZ;      //                               A   66   69    GRUPPIERUNGS- KZ
         WKIFKMC100 = AKTOUR;     //                               A   70   75    TOUR
         WKIFKMC100 = AKVART;     //                               A   76   79    VERSAND- ART
         WKIFKMC100 = AKSSC;      //                               A   80   83    VERSAND- SERVICE-C
         WKIFKMC100 = AKAART;     //                               A   84   87    AUFTRAGS- ART
         WKIFKMC100 = AKAARF;     //                               A   88   91    AUFTRAGS- FEIN-KOM
         WKIFKMC100 = AKAPSR;     //                               A   92  101    AP-SERIE/WAVE
         WKIFKMN100 = AKAPSP;     //                               S  102  104 0  SERIE/WAVE POS.
         WKIFKMC100 = AKRKZ;      //                               A  105  106    RES.KZ HOST
         WKIFKMC100 = AKALKZ;     //                               A  107  107    AUSL-KZ START
         WKIFKMC100 = AKALIP;     //                               A  108  108    AUSL-KZ I-PKT
         WKIFKMC100 = AKAPS1;     //                               A  109  113    AP-STATUS TYP 1
         WKIFKMC100 = AKAPS2;     //                               A  114  115    AP-STATUS TYP 2
         WKIFKMC100 = AKAPS3;     //                               A  116  120    AP-STATUS TYP 3
         WKIFKMC100 = AKAPS4;     //                               A  121  127    AP-STATUS TYP 4
         WKIFKMC100 = AKAPS5;     //                               A  128  134    AP-STATUS TYP 5
         WKIFKMC100 = AKSTS1;     //                               A  135  135    VERARB. STS LFS
         WKIFKMC100 = AKSTS2;     //                               A  136  136    VERARB.STS  AB-SYS
         WKIFKMC100 = AKFRG;      //                               A  137  137    FREIG.KZ ZUR AUSL.
         WKIFKMN100 = AKDTB;      //                               S  138  145 0  BEREITST. DATUM
         WKIFKMN100 = AKTIB;      //                               S  146  151 0  BEREITST. ZEIT
         WKIFKMC100 = AKTZB;      //                               A  152  161    ZEIT- ZONE
         WKIFKMN100 = AKFKAL;     //                               S  162  164 0  TAGE IM FABRIKKAL.
         WKIFKMC100 = AKTKZ;      //                               A  165  165    TERMIN KZ.
         WKIFKMC100 = AKSCHS;     //                               A  166  166    KZ FÜR SCHNELLSCHU
         WKIFKMC100 = AKORT;      //                               A  167  169    LAGER- ORT
         WKIFKMC100 = AKBER;      //                               A  170  171    LAGER- BER.
         WKIFKMN100 = AKSST;      //                               S  172  174 0  SST NUMMER
         WKIFKMC100 = AKBHF;      //                               A  175  184    BAHNHOF
         WKIFKMC100 = AKALP;      //                               A  185  194    AUSLAGER- PUNKT
         WKIFKMC100 = AKHW;       //                               C  195  274    TRANSPORT HINWEIS
         WKIFKMC100 = AKBAUG;     //                               A  275  284    BAUGRUPPE
         WKIFKMC100 = AKFNR1;     //                               A  285  309    FERTIG.-NR
         WKIFKMN100 = AKFNRP;     //                               S  310  315 0  FERTIG. POS
         WKIFKMC100 = AKKDNR;     //                               A  316  325    KUNDEN-NR
         WKIFKMN100 = AKKILN;     //                               S  326  338 0  ILN-NUMMER KUNDE
         WKIFKMC100 = AKLSNR;     //                               A  339  354    LIEFERSCHEIN- NUMM
         WKIFKMN100 = AKLSNP;     //                               S  355  359 0  LIEFERSCHEIN- POSI
         WKIFKMN100 = AKDKLS;     //                               S  360  360 0  DRUCK-KZ LIEFERSCH
         WKIFKMC100 = AKDKAZ;     //                               A  361  362    DRUCK-KZ AZL.
         WKIFKMC100 = AKANR1;     //                               A  363  387    AUFTRAGS-NR. KUNDE
         WKIFKMN100 = AKANRP;     //                               S  388  393 0  AUFTRAGS-NR. KUNDE
         WKIFKMC100 = AKPRN;      //                               A  394  418    PROJEKTNUMMER
         WKIFKMN100 = AKKST;      //                               S  419  425 0  KOSTEN- STELLE
         WKIFKMC100 = AKBST1;     //                               A  426  450    BESTELL-NR
         WKIFKMN100 = AKBSTP;     //                               S  451  456 0  BESTELL- POS
         WKIFKMN100 = AKANPO;     //                               S  457  462 0  ANZAHL- POS.
         WKIFKMN100 = AKACO;      //                               S  463  469 0  ANZAHL COLLIS IN A
         WKIFKMN100 = AKACOD;     //                               S  470  476 0  ANZAHL COLLIS GEDR
         WKIFKMN100 = AKANZP;     //                               S  477  485 0  ANZAHL PAKETE/COLL
         WKIFKMC100 = AKSTAT;     //                               A  486  486    STATUS
         WKIFKMC100 = AKVLAB;     //                               A  487  487    AUTOM.ABSCHL. VERL
         WKIFKMC100 = AKVLZI;     //                               A  488  497    VERLADEZIEL
         WKIFKMC100 = AKVLBR;     //                               A  498  507    VERLADEBEREICH
         WKIFKMC100 = AKLIAR;     //                               A  508  508    LIEFER ART
         WKIFKMC100 = AKKZHK;     //                               A  509  509    KZ HERK.
         WKIFKMC100 = AKVDRF;     //                               A  510  519    VERDICHTUNGS- REFE
         WKIFKMC100 = AKANB;      //                               A  520  522    ANBINDUNG AN
         WKIFKMC100 = AKRFNR;     //                               A  523  572    REFERENZ-NUMMER
         WKIFKMC100 = AKIDOC;     //                               A  573  588    SAP IDOC-NUMMER
         WKIFKMC100 = AKGRKO;     //                               A  589  590    KZ GRUPPEN- KOMM
         WKIFKMC100 = AKAN1;      //                               C  591  660    LIEFERANSCHR.ZEILE
         WKIFKMC100 = AKAN2;      //                               C  661  730    LIEFERANSCHR.ZEILE
         WKIFKMC100 = AKAN3;      //                               C  731  800    LIEFERANSCHR.ZEILE
         WKIFKMC100 = AKAN4;      //                               C  801  870    LIEFERANSCHR.ZEILE
         WKIFKMC100 = AKSTR;      //                               C  871  960    LIEFERANSCHR.STRAS
         WKIFKMC100 = AKLORT;     //                               C  961 1030    LIEFERANSCHRIFT OR
         WKIFKMC100 = AKLOTL;     //                               C 1031 1100    LIEFERANSCHRIFT OR
         WKIFKMC100 = AKLRGN;     //                               A 1101 1110    LIEFERANSCHR REGIO
         WKIFKMC100 = AKLAKZ;     //                               A 1111 1113    LIEF.ANSCHR. LÄNDE
         WKIFKMC100 = AKPLZ;      //                               A 1114 1123    LIEF.ANSCHR. PLZ
         WKIFKMC100 = AKTEL;      //                               C 1124 1163    TELEFON-NUMMER
         WKIFKMC100 = AKFAX;      //                               C 1164 1203    TELEFAX-NUMMER
         WKIFKMN100 = AKLGEX;     //                               S 1204 1212 6  GEOKOORDINATE X
         WKIFKMN100 = AKLGEY;     //                               S 1213 1221 6  GEOKOORDINATE Y
         WKIFKMC100 = AKEMAI;     //                               C 1222 1331    E-MAIL ADRESSE
         WKIFKMC100 = AKEXPO;     //                               A 1332 1334    EXPORT-KZ
         WKIFKMC100 = AKBKDN;     //                               A 1335 1362    KUNDEN-NR BESTELLE
         WKIFKMC100 = AKBAN1;     //                               C 1363 1432    BEST.ANSCHR. ZEILE
         WKIFKMC100 = AKBAN2;     //                               C 1433 1502    BEST.ANSCHR. ZEILE
         WKIFKMC100 = AKBAN3;     //                               C 1503 1572    BEST.ANSCHR. ZEILE
         WKIFKMC100 = AKBAN4;     //                               C 1573 1642    BEST.ANSCHR. ZEILE
         WKIFKMC100 = AKBSTR;     //                               C 1643 1732    BEST.ANSCHR. STRAS
         WKIFKMC100 = AKBORT;     //                               C 1733 1802    BEST.ANSCHR. ORT
         WKIFKMC100 = AKBOTL;     //                               C 1803 1872    BEST.ANSCHR. ORTST
         WKIFKMC100 = AKBRGN;     //                               A 1873 1882    BEST.ANSCHR. REGIO
         WKIFKMC100 = AKBLKZ;     //                               A 1883 1885    BEST.ANSCHR. LÄNDE
         WKIFKMC100 = AKBPLZ;     //                               A 1886 1895    BEST.ANSCHR. PLZ
         WKIFKMC100 = AKBTEL;     //                               C 1896 1935    BEST.ANSCHR. TELEF
         WKIFKMC100 = AKBFAX;     //                               C 1936 1975    BEST.ANSCHR.  TELE
         WKIFKMN100 = AKBGEX;     //                               S 1976 1984 6  BEST.ANSCHR. GEOKO
         WKIFKMN100 = AKBGEY;     //                               S 1985 1993 6  BEST.ANSCHR. GEOKO
         WKIFKMC100 = AKBEMA;     //                               C 1994 2103    BEST.ANSCHR. E-MAI
         WKIFKMN100 = AKDTLF;     //                               S 2104 2111 0  LIEFER- DATUM
         WKIFKMN100 = AKTILF;     //                               S 2112 2117 0  LIEFER- UHRZEIT
         WKIFKMC100 = AKTZLF;     //                               A 2118 2127    ZEIT- ZONE
         WKIFKMN100 = AKEPR;      //                               S 2128 2138 4  EINZEL- PREIS
         WKIFKMC100 = AKWAE;      //                               A 2139 2141    WAEHRUNGS- SCHLÜSS
         WKIFKMC100 = AKRTGN;     //                               A 2142 2181    ROUTING NR
         WKIFKMC100 = AKLOEG;     //                               C 2182 2261    LÖSCHGRUND
         WKIFKMC100 = AKLOID;     //                               A 2262 2263    LÖSCH-ID
         WKIFKMC100 = AKLUSR;     //                               A 2264 2273    GELOESCHT VON USER
         WKIFKMC100 = AKLBS;      //                               A 2274 2283    GELOESCHT VON BILD
         WKIFKMN100 = AKKLSD;     //                               S 2284 2284 0  KEINE LS-DRUCK
         WKIFKMN100 = AKWAWE;     //                               S 2285 2295 4  WAREN- WERT
         WKIFKMC100 = AKWSWW;     //                               A 2296 2298    WÄHR-SCHL WARENWER
         WKIFKMN100 = AKNNWE;     //                               S 2299 2309 4  NACHNAHME WERT
         WKIFKMC100 = AKWSNN;     //                               A 2310 2312    WÄHR-SCHL NACHNAHM
         WKIFKMN100 = AKTVWE;     //                               S 2313 2323 4  TP-VERS.- WERT
         WKIFKMC100 = AKWSTV;     //                               A 2324 2326    WÄHR-SCHL TP-VERSI
         WKIFKMC100 = AKAANR;     //                               A 2327 2346    AA-NR
         WKIFKMC100 = AKHRNR;     //                               A 2347 2366    HANDELS- RECHN-NR
         WKIFKMC100 = AKURZE;     //                               A 2367 2386    URSPRUNGS- ZEUGNIS
         WKIFKMC100 = AKKPAK;     //                               A 2387 2406    KOPIE AKKREDETIV
         WKIFKMC100 = AKT1NR;     //                               A 2407 2426    T1 NUMMER
         WKIFKMC100 = AKSPID;     //                               A 2427 2429    SPRACHEN ID
         WKIFKMN100 = AKLM1;      //                               S 2430 2434 0  ANZAHL LM 1
         WKIFKMN100 = AKKG1;      //                               S 2435 2441 2  KILO LM 1
         WKIFKMC100 = AKLMT1;     //                               A 2442 2444    LM TYP LM 1
         WKIFKMN100 = AKLM2;      //                               S 2445 2449 0  ANZAHL LM 2
         WKIFKMN100 = AKKG2;      //                               S 2450 2456 2  KILO LM 2
         WKIFKMC100 = AKLMT2;     //                               A 2457 2459    LM TYP LM 2
         WKIFKMN100 = AKLM3;      //                               S 2460 2464 0  ANZAHL LM 3
         WKIFKMN100 = AKKG3;      //                               S 2465 2471 2  KILO LM 3
         WKIFKMC100 = AKLMT3;     //                               A 2472 2474    LM TYP LM 3
         WKIFKMN100 = AKLM4;      //                               S 2475 2479 0  ANZAHL LM 4
         WKIFKMN100 = AKKG4;      //                               S 2480 2486 2  KILO LM 4
         WKIFKMC100 = AKLMT4;     //                               A 2487 2489    LM TYP LM 4
         WKIFKMN100 = AKLM5;      //                               S 2490 2494 0  ANZAHL LM 5
         WKIFKMN100 = AKKG5;      //                               S 2495 2501 2  KILO LM 5
         WKIFKMC100 = AKLMT5;     //                               A 2502 2504    LM TYP LM 5
         WKIFKMN100 = AKLM6;      //                               S 2505 2509 0  ANZAHL LM 6
         WKIFKMN100 = AKKG6;      //                               S 2510 2516 2  KILO LM 6
         WKIFKMC100 = AKLMT6;     //                               A 2517 2519    LM TYP LM 6
         WKIFKMN100 = AKGGEW;     //                               S 2520 2533 5  GESAMT- GEWICHT
         WKIFKMC100 = AKVLMT;     //                               A 2534 2536    VERSAND LM-TYP
         WKIFKMN100 = AKMDE3;     //                               S 2537 2538 0  PRIO AUSL/UML. MDE
         WKIFKMC100 = AKKUSR;     //                               A 2539 2548    USER KOMMIS.
         WKIFKMN100 = AKKZEI;     //                               S 2549 2554 2  KOMM-ZEIT IN SEK
         WKIFKMC100 = AKEKZEI;    //                               A 2555 2555    FEHL.STAMM-DAT. KO
         WKIFKMN100 = AKKGEW;     //                               S 2556 2569 5  KOMM-GEWICHT IN KG
         WKIFKMC100 = AKEKGEW;    //                               A 2570 2570    FEHL.STAMM-DAT. KO
         WKIFKMN100 = AKKVOL;     //                               S 2571 2579 3  KOMM-VOLUMEN IN M3
         WKIFKMC100 = AKEKVOL;    //                               A 2580 2580    FEHL.STAMM-DAT. KO
         WKIFKMN100 = AKKLM;      //                               S 2581 2588 2  KOMMISSIONIER- LAD
         WKIFKMC100 = AKEKLM;     //                               A 2589 2589    FEHL.STAMM-DAT. KO
         WKIFKMN100 = AKKCOL;     //                               S 2590 2596 0  KOMMISSIONIER- COL
         WKIFKMC100 = AKEKCOL;    //                               A 2597 2597    FEHL.STAMM-DAT. KO
         WKIFKMN100 = AKGUMA;     //                               S 2598 2603 4  GURTMAß IN M
         WKIFKMC100 = AKEGUMA;    //                               A 2604 2604    FEHL.STAMM-DAT. GU
         WKIFKMN100 = AKMACG;     //                               S 2605 2618 5  MAXIMALES COLLI-GE
         WKIFKMN100 = AKMACL;     //                               S 2619 2624 4  MAXIMALE COLLI-LAE
         WKIFKMC100 = AKKSND;     //                               A 2625 2626    KENNUNG SENDUNGSNR
         WKIFKMC100 = AKSNDG;     //                               A 2627 2636    SENDUNGS-NR.
         WKIFKMC100 = AKSNGR;     //                               A 2637 2640    SENDUNGS- GRUPPE
         WKIFKMN100 = AKDTAE;     //                               S 2641 2648 0  DATUM AUFTR.ERST.
         WKIFKMN100 = AKTIAE;     //                               S 2649 2654 0  UHRZEIT AUFTR.ERST
         WKIFKMC100 = AKTZAE;     //                               A 2655 2664    ZEIT- ZONE
         WKIFKMN100 = AKNOSL;     //                               S 2665 2671 2  ANZAHL STELLPLÄTZE
         WKIFKMN100 = AKLOM;      //                               S 2672 2678 2  LADE- METER
         WKIFKMN100 = AKLOM3;     //                               S 2679 2685 2  KUBIK- LADEMETER
         WKIFKMC100 = AKUSR;      //                               A 2686 2695    USER LETZTE MODI.
         WKIFKMC100 = AKTERM;     //                               A 2696 2705    TERMINAL LETZTE MO
         WKIFKMN100 = AKDTM;      //                               S 2706 2713 0  MODIFIK. DATUM
         WKIFKMN100 = AKTIM;      //                               S 2714 2719 0  MODIFIK. ZEIT
         WKIFKMC100 = AKTZM;      //                               A 2720 2729    ZEIT- ZONE
         WKIFKMN100 = AKDTBR;     //                               S 2730 2737 0  BASISDATUM REORG
         WKIFKMN100 = AKDTE;      //                               S 2738 2745 0  ERL./RÜCKCH. DATUM
         WKIFKMN100 = AKTIE;      //                               S 2746 2751 0  ERL./RÜCKCH. ZEIT
         WKIFKMC100 = AKTZE;      //                               A 2752 2761    ZEIT- ZONE
         WKIFKMC100 = AKUSER;     //                               A 2762 2771    USER
         WKIFKMC100 = AKBS;       //                               A 2772 2781    BILDSCHIRM
         WKIFKMC100 = AKPGM;      //                               A 2782 2791    PROGRAMM NAME
         WKIFKMC100 = AKKZ1;      //                               A 2792 2792    AUFTRAG KOMPLETT
         WKIFKMC100 = AKTOKZ;     //                               A 2793 2793    TOUREN- KZ
         WKIFKMC100 = AKUNAN;     //                               A 2794 2794    UNTERDR. ANZEIGE
         WKIFKMC100 = AKRIDS;     //                               A 2795 2795    RET.ITEMS DEL.STAT
         WKIFKMN100 = AKTNR;      //                               S 2796 2804 0  TOUREN- NR
         WKIFKMN100 = AKDTTPS;    //                               S 2805 2812 0  TOURENPL. START-DA
         WKIFKMN100 = AKTITPS;    //                               S 2813 2818 0  TOURENPL. START-ZE
         WKIFKMC100 = AKTZTPS;    //                               A 2819 2828    ZEIT- ZONE
         WKIFKMN100 = AKDTTPC;    //                               S 2829 2836 0  TOURENPL. CUT-OFF-
         WKIFKMN100 = AKTITPC;    //                               S 2837 2842 0  TOURENPL. CUT-OFF-
         WKIFKMC100 = AKTZTPC;    //                               A 2843 2852    ZEIT- ZONE
         WKIFKMN100 = AKDTTPE;    //                               S 2853 2860 0  TOURENPL. END-DATU
         WKIFKMN100 = AKTITPE;    //                               S 2861 2866 0  TOURENPL. END-ZEIT
         WKIFKMC100 = AKTZTPE;    //                               A 2867 2876    ZEIT- ZONE
         WKIFKMN100 = AKDTTIS;    //                               S 2877 2884 0  URSPRÜNGL. TPL STA
         WKIFKMN100 = AKTITIS;    //                               S 2885 2890 0  URSPRÜNGL. TPL STA
         WKIFKMC100 = AKTZTIS;    //                               A 2891 2900    ZEIT- ZONE
         WKIFKMN100 = AKDTTIC;    //                               S 2901 2908 0  URSPRÜNGL. TPL CUT
         WKIFKMN100 = AKTITIC;    //                               S 2909 2914 0  URSPRÜNGL. TPL CUT
         WKIFKMC100 = AKTZTIC;    //                               A 2915 2924    ZEIT- ZONE
         WKIFKMN100 = AKDTTIE;    //                               S 2925 2932 0  URSPRÜNGL. TPL END
         WKIFKMN100 = AKTITIE;    //                               S 2933 2938 0  URSPRÜNGL. TPL END
         WKIFKMC100 = AKTZTIE;    //                               A 2939 2948    ZEIT- ZONE
         WKIFKMN100 = AKDTRD;     //                               S 2949 2956 0  SOLL VERS- DATUM
         WKIFKMN100 = AKTIRD;     //                               S 2957 2962 0  SOLL VERS- ZEIT
         WKIFKMC100 = AKTZRD;     //                               A 2963 2972    ZEIT- ZONE
         WKIFKMC100 = AKVLKZ;     //                               A 2973 2973    VERLADE- KZ
         WKIFKMC100 = AKVLRL;     //                               A 2974 2974    VERLADE- RELEVANT
         WKIFKMN100 = AKDTL;      //                               S 2975 2982 0  VERLADE- DATUM
         WKIFKMN100 = AKTIL;      //                               S 2983 2988 0  VERLADE- ZEIT
         WKIFKMC100 = AKTZL;      //                               A 2989 2998    ZEIT- ZONE
         WKIFKMC100 = AKAVIS;     //                               A 2999 2999    ABHOLUNG AVISIERT
         WKIFKMC100 = AKVLST;     //                               A 3000 3009    VERLADE- STELLE
         WKIFKMC100 = AKPAKO;     //                               A 3010 3011    KZ PAKO PA,KO,..
         WKIFKMC100 = AKATYP;     //                               A 3012 3012    AUFTRAGS- TYP
         WKIFKMC100 = AKKSTR;     //                               A 3013 3013    KOMM- STRAT.
         WKIFKMN100 = AKPLST;     //                               S 3014 3014 0  PACK- LISTE
         WKIFKMC100 = AKPSTS;     //                               A 3015 3016    PACK- STATUS
         WKIFKMN100 = AKDTST;     //                               S 3017 3024 0  START KONF. DATUM
         WKIFKMN100 = AKTIST;     //                               S 3025 3030 0  START KONF. ZEIT
         WKIFKMC100 = AKTZST;     //                               A 3031 3040    ZEIT- ZONE
         WKIFKMN100 = AKDTEN;     //                               S 3041 3048 0  DATUM ENDE KONF.
         WKIFKMN100 = AKTIEN;     //                               S 3049 3054 0  ZEIT ENDE KONF.
         WKIFKMC100 = AKTZEN;     //                               A 3055 3064    ZEIT- ZONE
         WKIFKMC100 = AKKORT;     //                               A 3065 3067    ORT DER KONFEKT.
         WKIFKMC100 = AKIDE2;     //                               A 3068 3095    HERZUST. ARTIKEL
         WKIFKMC100 = AKIDV2;     //                               A 3096 3110    HERZUST. ARTIKELVA
         WKIFKMC100 = AKIDV2A;    //                               A 3111 3125    HERZUST. ARTIKELVA
         WKIFKMC100 = AKPRNR;     //                               A 3126 3140    PRÜF-NR/CHARGE
         WKIFKMC100 = AKSRN;      //                               A 3141 3165    SERIENNUMMER
         WKIFKMN100 = AKDTDC;     //                               S 3166 3173 0  MHD
         WKIFKMN100 = AKBMEN;     //                               S 3174 3184 3  HERZUST. MENGE
         WKIFKMN100 = AKHMEN;     //                               S 3185 3195 3  HERGEST. MENGE
         WKIFKMC100 = AKASTS;     //                               A 3196 3196    AUFTR.STATUS KONF.
         WKIFKMC100 = AKWABZ;     //                               C 3197 3256    WARENBEZEICHNUNG
         WKIFKMC100 = AKSHW1;     //                               C 3257 3326    SPEDI-HINWEIS-1
         WKIFKMC100 = AKSHW2;     //                               C 3327 3396    SPEDI-HINWEIS-2
         WKIFKMC100 = AKABV1;     //                               C 3397 3516    ABSENDERVERMERK 1
         WKIFKMC100 = AKABV2;     //                               C 3517 3636    ABSENDERVERMERK 1
         WKIFKMC100 = AKABV3;     //                               C 3637 3756    ABSENDERVERMERK 1
         WKIFKMC100 = AKATXT;     //                               C 3757 3816    AUFTRAGS-TEXT
         WKIFKMC100 = AKUREF;     //                               C 3817 3866    UNSERE REF.
         WKIFKMC100 = AKKREF;     //                               C 3867 3916    KUNDEN-REF.
         WKIFKMC100 = AKLHSB;     //                               C 3917 3966    UNSER SACHB.
         WKIFKMC100 = AKABOR;     //                               C 3967 4016    ABGANGSORT
         WKIFKMC100 = AKANOR;     //                               C 4017 4066    ANKUNFTSORT
         WKIFKMC100 = AKENDB;     //                               C 4067 4116    ENDBESTIMMUNG
         WKIFKMC100 = AKVSTX;     //                               C 4117 4166    VERSICH. TEXT
         WKIFKMC100 = AKVSSL;     //                               A 4167 4169    VERSICH. SCHLUESSE
         WKIFKMN100 = AKDTAB;     //                               S 4170 4177 0  ABFAHRTS- DATUM
         WKIFKMC100 = AKTRMI;     //                               C 4178 4227    TRANSPORTMITTEL
         WKIFKMN100 = AKDTAN;     //                               S 4228 4235 0  ANKUNFTS DATUM
         WKIFKMC100 = AKLBTX;     //                               C 4236 4285    LIEF.BEDINGUNG
         WKIFKMC100 = AKLBSL;     //                               A 4286 4288    LIEFER- SCHLUESSEL
         WKIFKMC100 = AKTLVB;     //                               A 4289 4289    TEILLIEFER VERBOT
         WKIFKMC100 = AKDEOQ;     //                               A 4290 4290    REDUZ. AUFTR-MEN.
         WKIFKMC100 = AKVSCD;     //                               A 4291 4294    VERSAND- STEUERCOD
         WKIFKMC100 = AKLTX1;     //                               C 4295 4354    LIEF.TXT 1
         WKIFKMC100 = AKLTX2;     //                               C 4355 4414    LIEF.TXT 2
         WKIFKMC100 = AKLTX3;     //                               C 4415 4474    LIEF.TXT 3
         WKIFKMC100 = AKLTX4;     //                               C 4475 4534    LIEF.TXT 4
         WKIFKMC100 = AKLTX5;     //                               C 4535 4594    LIEF.TXT 5
         WKIFKMC100 = AKLTX6;     //                               C 4595 4654    LIEF.TXT 6
         WKIFKMC100 = AKOUTQ;     //                               A 4655 4664    OUTQ
         WKIFKMC100 = AKKOP;      //                               A 4665 4674    KONSOLIDIER- PLATZ
         WKIFKMC100 = AKKOP2;     //                               A 4675 4684    KONSOLIDIER- PLATZ
         WKIFKMC100 = AKLWEG;     //                               A 4685 4694    LAUFWEG
         WKIFKMN100 = AKDTDF;     //                               S 4695 4702 0  DATUM DFÜ-ÜBERN.
         WKIFKMN100 = AKTIDF;     //                               S 4703 4708 0  UHRZEIT DFÜ-ÜBERN.
         WKIFKMC100 = AKTZDF;     //                               A 4709 4718    ZEIT- ZONE
         WKIFKMN100 = AKBSTU;     //                               S 4719 4719 0  BESTANDS- ÜBERNAHM
         WKIFKMC100 = AKSPNR;     //                               A 4720 4729    SPEDITEUR NUMMER
         WKIFKMC100 = AKSPED;     //                               C 4730 4779    SPEDITEUR/ABHOLER
         WKIFKMC100 = AKFAHR;     //                               C 4780 4829    NAME FAHRER
         WKIFKMC100 = AKTELD;     //                               C 4830 4869    TELEFON DRIVER
         WKIFKMC100 = AKEMAD;     //                               C 4870 4979    EMAIL DRIVER
         WKIFKMC100 = AKVHTY;     //                               A 4980 4982    FAHRZEUG ART
         WKIFKMC100 = AKVHLN;     //                               A 4983 5007    VEHICLE LICENSE NU
         WKIFKMC100 = AKVTLN;     //                               A 5008 5032    VH. TRAILER LICENS
         WKIFKMC100 = AKLSDE;     //                               A 5033 5035    LADE- SEITE
         WKIFKMC100 = AKZFZG;     //                               A 5036 5038    ZUG- FAHRZ.
         WKIFKMC100 = AKGRYM;     //                               A 5039 5044    YARDM. GRUPPE
         WKIFKMC100 = AKGRPA;     //                               A 5045 5050    PARKPLATZ- GRUPPE
         WKIFKMC100 = AKGRFW;     //                               A 5051 5056    SPEDITEUR- GRUPPE
         WKIFKMC100 = AKAGGN;     //                               A 5057 5086    VERDICHTUNGS-NUMME
         WKIFKMC100 = AKVHLP;     //                               A 5087 5089    LADE- POSITION
         WKIFKMN100 = AK3RPD;     //                               S 5090 5090 0  STRECKEN GESCHAEFT
         WKIFKMC100 = AKPDLN;     //                               A 5091 5091    DRUCK LIEFERSCH.
         WKIFKMC100 = AKDLNO;     //                               A 5092 5092    LIEFERSCH. OPTION
         WKIFKMN100 = AKPDLS;     //                               S 5093 5093 0  LIEFER BON
         WKIFKMC100 = AKRECN;     //                               A 5094 5113    RECHNUNGS-NR
         WKIFKMN100 = AKOTSU;     //                               S 5114 5114 0  ONL-TOUR SCAN NVE
         WKIFKMC100 = AKOTTP;     //                               A 5115 5115    ONL-TOUR ZAHL-ART
         WKIFKMN100 = AKDEPO;     //                               S 5116 5116 0  PFAND KZ
         WKIFKMC100 = AKCECD;     //                               A 5117 5117    LEERGUT BERECHN.
         WKIFKMN100 = AKAIDB;     //                               S 5118 5128 4  RECHN-BETR. SOLL
         WKIFKMN100 = AKAIAC;     //                               S 5129 5139 4  RECHN-BETR. IST
         WKIFKMN100 = AKACBA;     //                               S 5140 5150 4  BETRAG  GEZAHLT
         WKIFKMN100 = AKSTOP;     //                               S 5151 5151 0  AUFTRAGS STOP
         WKIFKMN100 = AKDTAR;     //                               S 5152 5159 0  ANKUNFTS DATUM
         WKIFKMN100 = AKTIAR;     //                               S 5160 5165 0  ANKUNFTS ZEIT
         WKIFKMC100 = AKTZAR;     //                               A 5166 5175    ZEIT- ZONE
         WKIFKMN100 = AKDTDP;     //                               S 5176 5183 0  START- DATUM
         WKIFKMN100 = AKTIDP;     //                               S 5184 5189 0  START- ZEIT
         WKIFKMC100 = AKTZDP;     //                               A 5190 5199    ZEIT- ZONE
         WKIFKMC100 = AKQUFU;     //                               A 5200 5249    USER QUITT VOLLGUT
         WKIFKMC100 = AKQSFU;     //                               A 5250 5299    UNTERSCHR. VOLLGUT
         WKIFKMC100 = AKQUEM;     //                               A 5300 5349    USER QUITT LEERGUT
         WKIFKMC100 = AKQSEM;     //                               A 5350 5399    UNTERSCHR. LEERGUT
         WKIFKMC100 = AKTTST;     //                               A 5400 5400    TRCK&TRAC STS ACT.
         WKIFKMN100 = AKDTTT;     //                               S 5401 5408 0  TRCK&TRAC DATE ACT
         WKIFKMN100 = AKTITT;     //                               S 5409 5414 0  TRCK&TRAC TIME ACT
         WKIFKMC100 = AKTZTT;     //                               A 5415 5424    ZEIT- ZONE
         WKIFKMC100 = AKTTPG;     //                               A 5425 5434    TRCK&TRAC PGM ACT
         WKIFKMC100 = AKTTUS;     //                               A 5435 5444    TRCK&TRAC USR ACT
         WKIFKMC100 = AKTTBS;     //                               A 5445 5454    TRCK&TRAC BS ACT
         WKIFKMC100 = AKTTHW;     //                               C 5455 5574    TRCK&TRAC HINW ACT
         WKIFKMC100 = AKANAP;     //                               A 5575 5594    ANHAENGEN POSITION
         WKIFKMC100 = AKDLPP;     //                               A 5595 5595    AUSLIEFERN ANBRUCH
         WKIFKMC100 = AKPCKS;     //                               A 5596 5596    PACK- SCHEMA
         WKIFKMC100 = AKSPQU;     //                               A 5597 5597    RESTMENGE SEPARIER
         WKIFKMC100 = AKCOQU;     //                               A 5598 5598    RESTMENGE ZUSAMMEN
         WKIFKMC100 = AKLBBD;     //                               A 5599 5599    LAGE JE MHD
         WKIFKMC100 = AKLLOT;     //                               A 5600 5600    LAGE JE CHARGE
         WKIFKMC100 = AKAUPC;     //                               A 5601 5610    AUTOMATIC PROCESS.
         WKIFKMC100 = AKORTH;     //                               A 5611 5613    ORDER TYPE HOST
         WKIFKMC100 = AKORTP;     //                               A 5614 5614    ORDER TYPE
         WKIFKMC100 = AKOPST;     //                               A 5615 5629    STATUS AUFTRAGSBEA
         WKIFKMC100 = AKCAAG;     //                               A 5630 5644    CARRIERS AGENT
         WKIFKMC100 = AKCUBT;     //                               A 5645 5645    ART DER  ZOLLBESCH
         WKIFKMC100 = AKPAYM;     //                               A 5646 5646    ZAHLUNGS- ART
         WKIFKMC100 = AKPREC;     //                               A 5647 5656    ZWISCHEN- TRANSPOR
         WKIFKMC100 = AKCTNR;     //                               A 5657 5676    CONTAINER-NR
         WKIFKMC100 = AKPLOR;     //                               A 5677 5696    ANNAHMEORT
         WKIFKMC100 = AKLAHA;     //                               A 5697 5711    LADEHAFEN
         WKIFKMC100 = AKLOHA;     //                               A 5712 5726    LOESCHHAFEN
         WKIFKMC100 = AKIMCD;     //                               A 5727 5751    IMPORTEUR
         WKIFKMC100 = AKREQU;     //                               A 5752 5761    ANFORDERER
         WKIFKMC100 = AKBERF;     //                               A 5762 5776    ZOLLANMELDUNG REF.
         WKIFKMC100 = AKBOEX;     //                               A 5777 5791    ZOLL- ABGANGSBELEG
         WKIFKMC100 = AKSHMT;     //                               A 5792 5801    LIEFERUNG
         WKIFKMC100 = AKFDOK;     //                               A 5802 5821    FRACHTDOKUMENT
         WKIFKMN100 = AKFRCO;     //                               S 5822 5832 4  FRACHTKOSTEN
         WKIFKMN100 = AKADCO;     //                               S 5833 5843 4  NEBENKOSTEN
         WKIFKMC100 = AKJISPL;    //                               A 5844 5846    JIS PROD-LINE
         WKIFKMC100 = AKJISSQ;    //                               A 5847 5851    JIS SEQUENZ
         WKIFKMN100 = AKHAZG;     //                               S 5852 5852 0  KENNZ. GEFAHRGUT
         WKIFKMN100 = AKPNTH;     //                               S 5853 5860 0  PUNKTZAHL GEF.GUT
         WKIFKMN100 = AKSHRT;     //                               S 5861 5861 0  STRASSEN TRANSPORT
         WKIFKMN100 = AKSHRW;     //                               S 5862 5862 0  BAHN- TRANSPORT
         WKIFKMN100 = AKSHIW;     //                               S 5863 5863 0  BINNEN- SCHIFF
         WKIFKMN100 = AKSHSS;     //                               S 5864 5864 0  SEE- SCHIFF
         WKIFKMN100 = AKSHAF;     //                               S 5865 5865 0  LUFT- FRACHT
         WKIFKMN100 = AKSHCA;     //                               S 5866 5866 0  FRACHT- FLUGZEUG
         WKIFKMN100 = AKSHPC;     //                               S 5867 5867 0  PASSAGIER+ FRACHTF
         WKIFKMC100 = AKAIR1;     //                               A 5868 5870    AIRLINE 1
         WKIFKMC100 = AKAIR2;     //                               A 5871 5873    AIRLINE 2
         WKIFKMC100 = AKAIR3;     //                               A 5874 5876    AITLINE 3
         WKIFKMN100 = AKCAO;      //                               S 5877 5877 0  NUR FRACHT- FLUGZE
         WKIFKMN100 = AKHGRT;     //                               S 5878 5878 0  GEFAHRGUT STRASSE
         WKIFKMN100 = AKHGRW;     //                               S 5879 5879 0  GEFAHRGUT BAHN
         WKIFKMN100 = AKHGIW;     //                               S 5880 5880 0  GEFAHRGUT BINNENSC
         WKIFKMN100 = AKHGSS;     //                               S 5881 5881 0  GEFAHRGUT SEESCHIF
         WKIFKMN100 = AKHGAF;     //                               S 5882 5882 0  GEFAHRGUT LUFTFRAC
         WKIFKMC100 = AKAOSO;     //                               A 5883 5892    ADRESS-NR VERTRIEB
         WKIFKMC100 = AKCPYR;     //                               A 5893 5902    FRACHTZAHLER
         WKIFKMC100 = AKDPYR;     //                               A 5903 5912    ZOLLZAHLER
         WKIFKMC100 = AKKPIG;     //                               A 5913 5916    KPI GRUPPE
         WKIFKMC100 = AKVAS1;     //                               A 5917 5926    VAS PROFIL 1
         WKIFKMC100 = AKVAS2;     //                               A 5927 5936    VAS PROFIL 2
         WKIFKMC100 = AKVAS3;     //                               A 5937 5946    VAS PROFIL 3
         WKIFKMC100 = AKVAS4;     //                               A 5947 5956    VAS PROFIL 4
         WKIFKMC100 = AKVAS5;     //                               A 5957 5966    VAS PROFIL 5
         WKIFKMC100 = AKVAS6;     //                               A 5967 5976    VAS PROFIL 6
         WKIFKMC100 = AKVAS7;     //                               A 5977 5986    VAS PROFIL 7
         WKIFKMC100 = AKVAS8;     //                               A 5987 5996    VAS PROFIL 8
         WKIFKMC100 = AKVAS9;     //                               A 5997 6006    VAS PROFIL 9
         WKIFKMN100 = AKVSQ1;     //                               S 6007 6007 0  VAS REIHENFOLGE 1
         WKIFKMN100 = AKVSQ2;     //                               S 6008 6008 0  VAS REIHENFOLGE 2
         WKIFKMN100 = AKVSQ3;     //                               S 6009 6009 0  VAS REIHENFOLGE 3
         WKIFKMN100 = AKVSQ4;     //                               S 6010 6010 0  VAS REIHENFOLGE 4
         WKIFKMN100 = AKVSQ5;     //                               S 6011 6011 0  VAS REIHENFOLGE 5
         WKIFKMN100 = AKVSQ6;     //                               S 6012 6012 0  VAS REIHENFOLGE 6
         WKIFKMN100 = AKVSQ7;     //                               S 6013 6013 0  VAS REIHENFOLGE 7
         WKIFKMN100 = AKVSQ8;     //                               S 6014 6014 0  VAS REIHENFOLGE 8
         WKIFKMN100 = AKVSQ9;     //                               S 6015 6015 0  VAS REIHENFOLGE 9
         WKIFKMN100 = AKRTNR;     //                               S 6016 6024 0  RETOUREN- NUMMER
         WKIFKMC100 = AKRTTI;     //                               A 6025 6027    RÜCKLIEFER- FRIST
         WKIFKMC100 = AKHVAR;     //                               A 6028 6031    HOST- VERS-ART
         WKIFKMC100 = AKHSSC;     //                               A 6032 6035    HOST- VERS.-SERV.-
         WKIFKMN100 = AKRN1;      //                               S 6036 6036 0  RES-1,0 RN1
         WKIFKMN100 = AKRN2;      //                               S 6037 6038 0  RES-2,0 RN2
         WKIFKMN100 = AKRN5;      //                               S 6039 6043 0  RES-5,0 RN5
         WKIFKMN100 = AKRN7;      //                               S 6044 6050 0  RES-7,0 RN7
         WKIFKMN100 = AKRN9;      //                               S 6051 6059 0  RES-9,0 RN9
         WKIFKMN100 = AKRN92;     //                               S 6060 6068 2  RES-9,2 RN92
         WKIFKMN100 = AKRN113;    //                               S 6069 6079 3  RES-11,3 RN113
         WKIFKMN100 = AKRN114;    //                               S 6080 6090 4  RES-11,4 RN114
         WKIFKMC100 = AKRA1;      //                               A 6091 6091    RES-1A RA1
         WKIFKMC100 = AKRA2;      //                               A 6092 6093    RES-2A RA2
         WKIFKMC100 = AKRA3;      //                               A 6094 6096    RES-3A RA3
         WKIFKMC100 = AKRA4;      //                               A 6097 6100    RES-4A RA4
         WKIFKMC100 = AKRA5;      //                               A 6101 6105    RES-5A RA5
         WKIFKMC100 = AKRA7;      //                               A 6106 6112    RES-7A RA7
         WKIFKMC100 = AKRA10;     //                               A 6113 6122    RES-10A RA10
         WKIFKMC100 = AKRA13;     //                               A 6123 6135    RES-13A RA13
         WKIFKMC100 = AKRA15;     //                               A 6136 6150    RES-15A RA15
         WKIFKMC100 = AKRA18;     //                               A 6151 6168    RES-18A RA18
         WKIFKMN100 = AKFN1;      //                               S 6169 6169 0  RES-1,0 FN1
         WKIFKMN100 = AKFN2;      //                               S 6170 6171 0  RES-2,0 FN2
         WKIFKMN100 = AKFN5;      //                               S 6172 6176 0  RES-5,0 FN5
         WKIFKMN100 = AKFN7;      //                               S 6177 6183 0  RES-7,0 FN7
         WKIFKMN100 = AKFN9;      //                               S 6184 6192 0  RES-9,0 FN9
         WKIFKMN100 = AKFN92;     //                               S 6193 6201 2  RES-9,2 FN92
         WKIFKMN100 = AKFN113;    //                               S 6202 6212 3  RES-11,3 FN113
         WKIFKMN100 = AKFN114;    //                               S 6213 6223 4  RES-11,4 FN114
         WKIFKMC100 = AKFA1;      //                               A 6224 6224    RES-1A FA1
         WKIFKMC100 = AKFA2;      //                               A 6225 6226    RES-2A FA2
         WKIFKMC100 = AKFA3;      //                               A 6227 6229    RES-3A FA3
         WKIFKMC100 = AKFA4;      //                               A 6230 6233    RES-4A FA4
         WKIFKMC100 = AKFA5;      //                               A 6234 6238    RES-5A FA5
         WKIFKMC100 = AKFA7;      //                               A 6239 6245    RES-7A FA7
         WKIFKMC100 = AKFA10;     //                               A 6246 6255    RES-10A FA10
         WKIFKMC100 = AKFA13;     //                               A 6256 6268    RES-13A FA13
         WKIFKMC100 = AKFA15;     //                               A 6269 6283    RES-15A FA15
         WKIFKMC100 = AKFA18;     //                               A 6284 6301    RES-18A FA18
         WKIFKMC100 = AKVSTS;     //                               A 6302 6302    VERARB.- STATUS
         WKIFKMC100 = AKVSSA;     //                               A 6303 6303    VER.STS SAP
         WKIFKMC100 = AKVSMV;     //                               A 6304 6304    VER.STS MOVEX
         WKIFKMC100 = AKVSED;     //                               A 6305 6305    VER.STS EDI
         WKIFKMC100 = AKVSXM;     //                               A 6306 6306    VER.STS XML
         WKIFKMC100 = AKVSFT;     //                               A 6307 6307    VER.STS FTP
         WKIFKMC100 = AKVSHD;     //                               A 6308 6308    VER.STS ESS
         WKIFKMC100 = AKVSMA;     //                               A 6309 6309    VER.STS MAS90
         WKIFKMC100 = AKVSSB;     //                               A 6310 6310    VER.STS STEEB
         WKIFKMC100 = AKVSKT;     //                               A 6311 6311    VER.STS KTL
         WKIFKMC100 = AKVSSD;     //                               A 6312 6312    VER.STS STRADA/SD
         WKIFKMC100 = AKVSH1;     //                               A 6313 6313    VER.STS HOST 1
         WKIFKMC100 = AKVSH2;     //                               A 6314 6314    VER.STS HOST 2
         WKIFKMC100 = AKVSH3;     //                               A 6315 6315    VER.STS HOST 3
         WKIFKMC100 = AKVSH4;     //                               A 6316 6316    VER.STS HOST 4
         WKIFKMC100 = AKVSH5;     //                               A 6317 6317    VER.STS HOST 5
         WKIFKMC100 = AKFCD;      //                               A 6318 6327    FEHLER- CODE
         WKIFKMC100 = AKFTXT;     //                               C 6328 6487    FEHLERTEXT
         WKIFKMN100 = AKDTDI;     //                               S 6488 6495 0  DB DATUM WRITE
         WKIFKMN100 = AKTIDI;     //                               S 6496 6507 0  DB ZEIT WRITE
         WKIFKMC100 = AKDIUSR;    //                               A 6508 6517    DB USER WRITE
         WKIFKMC100 = AKDIBS;     //                               A 6518 6527    DB JOB WRITE
         WKIFKMC100 = AKDIJBN;    //                               A 6528 6533    DB JOBNR. WRITE
         WKIFKMC100 = AKDIUSRB;   //                               A 6534 6543    DB USER BATCH WRIT
         WKIFKMC100 = AKDIBSB;    //                               A 6544 6553    DB JOB BATCH WRITE
         WKIFKMC100 = AKDIJBNB;   //                               A 6554 6559    DB JOBNR. BATCH WR
         WKIFKMC100 = AKDIPGM;    //                               A 6560 6569    DB PGM WRITE
         WKIFKMC100 = AKDIPGMU;   //                               A 6570 6579    USER DEF. DB PGM W
         WKIFKMN100 = AKDTDU;     //                               S 6580 6587 0  DB DATUM REWRITE
         WKIFKMN100 = AKTIDU;     //                               S 6588 6599 0  DB ZEIT REWRITE
         WKIFKMC100 = AKDUUSR;    //                               A 6600 6609    DB USER REWRITE
         WKIFKMC100 = AKDUBS;     //                               A 6610 6619    DB JOB REWRITE
         WKIFKMC100 = AKDUJBN;    //                               A 6620 6625    DB JOBNR. REWRITE
         WKIFKMC100 = AKDUUSRB;   //                               A 6626 6635    DB USER BATCH REWR
         WKIFKMC100 = AKDUBSB;    //                               A 6636 6645    DB JOB BATCH REWRI
         WKIFKMC100 = AKDUJBNB;   //                               A 6646 6651    DB JOBNR. BATCH RE
         WKIFKMC100 = AKDUPGM;    //                               A 6652 6661    DB PGM REWRITE
         WKIFKMC100 = AKDUPGMU;   //                               A 6662 6671    USER DEF. DB PGM R

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;


       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS IN PSAVEAK2                                         ***
       //*************************************************************************
       BEGSR UPSAVEAK2;

       KYPSAVEAK2L2.AKKONZ = AKKONZ;
       KYPSAVEAK2L2.AKFIRM = AKFIRM;
       KYPSAVEAK2L2.AKAPN = AKAPN;
       // CHAIN %KDS(KYPSAVEAK2L2:3) PSAVEAK2L2;
       AKTIDF = %DEC(%TIME());
       AKDTDF = %DEC(%DATE():*ISO);
       AKVSH1 = *ON;
       UPDATE PANFKOPFL2;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHIFKM
     C/COPY QCPYSRC,CHPAUK
     C/COPY QCPYSRC,CHSYTP
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
