     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
     H BNDDIR('TRTXT') DFTACTGRP(*NO)
      //*************************************************************************
      /TITLE  Einlesen der Daten aus PPAKET2 von Erhard + Partner
      //*************************************************************************
      //  Copyright 2015 by trend SWM
      //                    Verwaltung GmbH
      //                    Gundelfinger Straße 11
      //                    DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 07.09.2015 Projekt 11427 Dometic WAECO
      //  -----------------------------------------------------------------------
      //  Änderung: SZ 27.10.2015 Aufbau der übergebenen Kom.-Schein-Nr. mit
      //            Mandant und 4-stelligem Jahr
      //  Änderung: SZ 23.01.2016 Projekt 11998 erneute Verarbeitung und Druck
      //            Lieferschein.
      //  Änderung: SZ 06.02.2016 Projekt 11427, Paketnummer aus anderem Feld
      //  Änderung: SZ 20.08.2018 Spediteur aus Versandbedingung ermitteln
      //
      //*************************************************************************
      //
      //  Dieses Programm füllt die trend Standard Schnittstellenfile IFVS mit
      //  den Daten aus PPAKET2. Die eingelesenen Daten werden in PPAKET2 als
      //  verarbeitet gekennzeichnet.
      //  Das Programm wird über CALL WAIFKMST direkt aus E+P aufgerufen und
      //  verarbeitet jeweils nur die Daten aus dem übergebenen Arbeitspaket.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPPAKET2L1 UF A E           K DISK    USROPN RENAME(PPAKETF:PPAKETFL1)

      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ

     D IFVS          E DS                  INZ
     D KYIFVS        E DS                  INZ
     D WKIFVS        E DS                  EXTNAME(IFVS) PREFIX(WK) INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ

     D KYPPAKET2L1     DS                  LIKEREC(PPAKETFL1:*KEY)

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
     D ##CHI           S              8
     D ##PGST          S              1
     D ##RTCD          S              1
     D WKTRTP          S              1
     D WKI000          S              1
     D WKIIFL          S              1
     D WKFENR          S              4
     D WKIFVSC100      S            100A
     D WKIFVSN080      S              8S 0
     D WKIFVSN100      S             10S 0
     D WKIFVSN134      S             13S 4
     D WKIFVSN145      S             14S 5
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
      // Parameter:      #WKIFVSTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKIFVSTSTP                        LIKE(WKIFVSTSTP)

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
       OPEN PPAKET2L1;
       EXSR VPPAKET2;
       CLOSE PPAKET2L1;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYAMFI = DAFIRM;                                                         // AFKM
       KYIFVSFIRM = DAFIRM;                                                     // IFVS
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYVBFI = DAFIRM;                                                         // VSBD

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
         EXSR RMVMONMSG;
       ENDMON;

       MONITOR;
         WKLFS_APPO = %DEC(%SUBST(#CKOMM:16:6):6:0);
       ON-ERROR;
         WKLFS_APPO = 0;
         EXSR RMVMONMSG;
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
         EXSR RMVMONMSG;
       ENDMON;

       WKLFS_SART = %SUBST(#CKOMM:22:1);
       WKLFS_FIRM = %SUBST(#CKOMM:23:2);
       WKLFS_KMNR = %SUBST(#CKOMM:29:6);

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
       BEGSR VPPAKET2;

       KYPPAKET2L1.PKKONZ = WKLFS_KONZ;
       KYPPAKET2L1.PKFIRM = WKLFS_MAND;
       KYPPAKET2L1.PKAPN = WKLFS_APNR;
       KYPPAKET2L1.PKPKNR = *ZERO;
       SETLL %KDS(KYPPAKET2L1:4) PPAKET2L1;

       DOW NOT %EOF(PPAKET2L1) AND NOT %ERROR;
         WKIIFL = *OFF;
         //READ(N) PPAKET2L1;
         READ PPAKET2L1;

         IF %EOF OR %ERROR OR
           PKKONZ <> KYPPAKET2L1.PKKONZ OR
           PKFIRM <> KYPPAKET2L1.PKFIRM OR
           PKAPN <> KYPPAKET2L1.PKAPN;
           LEAVE;
         ENDIF;

         EXSR INWKIFVS;

         IF WKIFVSFENR <> '0000';                                               // KEINE DATEN MEHR
           LEAVE;
         ENDIF;

         IF PKVSH1 <> *ON;
           WKIIFL = *ON;
         ENDIF;

         IF PCPGST = 'NDRUCK';                                                  // ERNEUT VERARBEITE
           WKIIFL = *ON;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPPAKET2;
           EXSR EIFVS;
           EXSR UIFVS;
           EXSR UPPAKET2;
           #CRTCD = ' ';
         ENDIF;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  INIFVS- Inititalisieren WKIFVS                                    ***
       //*************************************************************************
       BEGSR INWKIFVS;

       CLEAR WKIFVS;
       WKIFVSFIRM = DAFIRM;
       WKIFVSWKNR = '001';
       WKIFVSSTAT = '00';
       WKIFVSDTEI = 'PPAKET2';
       WKIFVSFENR = '0000';
       WKIFVSKZ01 = *OFF;
       WKIFVSKZ02 = *OFF;
       WKIFVSKZ03 = *OFF;
       WKIFVSKZ04 = *OFF;
       WKIFVSKZ05 = *OFF;
       WKIFVSKZ06 = *OFF;
       WKIFVSKZ07 = *OFF;
       WKIFVSKZ08 = *OFF;
       WKIFVSKZ09 = *OFF;
       WKIFVSKZ10 = *OFF;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR EIFVS;

       SELECT;
       WHEN WKIFVSDANA = 'AFKM';
         WKIFVSSZAR = '03';                                                     // Rückmeldung AFKM
         EXSR EAFKM;
       WHEN WKIFVSDANA = 'PAUK';
         WKIFVSSZAR = '11';
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN FÜR KOMMISSIONIERUNG                              ***
       //*************************************************************************
       BEGSR EAFKM;

       KYAMJH = WKIFVSJAHR;
       KYAMKM = WKIFVSNMKR;
       CHIDS = '01C';
       EXSR CHAFKM;
       WKIFVSKMJJ = AMKMJJ;
       WKIFVSKMNR = AMKMNR;

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR UIFVS;

       KYIFVSFIRM = WKIFVSFIRM;
       KYIFVSTSTP = WKIFVSTSTP;
       CHIDS = '01CU';
       EXSR CHIFVS;

       IFVSWKNR = WKIFVSWKNR;
       IFVSDANA = WKIFVSDANA;
       IFVSJAHR = WKIFVSJAHR;
       IFVSNMKR = WKIFVSNMKR;
       IFVSPOSI = WKIFVSPOSI;
       IFVSKMJJ = WKIFVSKMJJ;
       IFVSKMNR = WKIFVSKMNR;
       IFVSKMPO = WKIFVSKMPO;
       IFVSKMNN = WKIFVSKMNN;
       IFVSANZA = WKIFVSANZA;
       IFVSGWBR = WKIFVSGWBR;
       IFVSGWNT = WKIFVSGWNT;
       IFVSVOLU = WKIFVSVOLU;
       IFVSTENR = WKIFVSTENR;
       IFVSKLKZ = WKIFVSKLKZ;
       IFVSABJJ = WKIFVSABJJ;
       IFVSABNR = WKIFVSABNR;
       IFVSKDLI = WKIFVSKDLI;
       IFVSABMS = WKIFVSABMS;
       IFVSTMST = WKIFVSTMST;
       IFVSDPDN = WKIFVSDPDN;
       IFVSDSKZ = WKIFVSDSKZ;
       IFVSDSDF = WKIFVSDSDF;
       IFVSPAKN = WKIFVSPAKN;
       IFVSKDNR = WKIFVSKDNR;
       IFVSVSNR = WKIFVSVSNR;
       IFVSSDJJ = WKIFVSSDJJ;
       IFVSSDNR = WKIFVSSDNR;
       IFVSLANR = WKIFVSLANR;
       IFVSLORT = WKIFVSLORT;
       IFVSPMLA = WKIFVSPMLA;
       IFVSPMTS = WKIFVSPMTS;

       IFVSKZ01 = WKIFVSKZ01;
       IFVSKZ02 = WKIFVSKZ02;
       IFVSKZ03 = WKIFVSKZ03;
       IFVSKZ04 = WKIFVSKZ04;
       IFVSKZ05 = WKIFVSKZ05;
       IFVSKZ06 = WKIFVSKZ06;
       IFVSKZ07 = WKIFVSKZ07;
       IFVSKZ08 = WKIFVSKZ08;
       IFVSKZ09 = WKIFVSKZ09;
       IFVSKZ10 = WKIFVSKZ10;

       IFVSSZAR = WKIFVSSZAR;
       IFVSDTEI = WKIFVSDTEI;
       IFVSFENR = WKIFVSFENR;
       IFVSFFLD = WKIFVSFFLD;

       IFVSJNAM = WKIFVSJNAM;
       IFVSPROG = WKIFVSPROG;
       IFVSBIBL = WKIFVSBIBL;
       IFVSUSER = WKIFVSUSER;
       IFVSJZEI = WKIFVSJZEI;
       IFVSJDAT = WKIFVSJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFVSERDA = WKIFVSERDA;
         IFVSERZT = WKIFVSERZT;
         IFVSERUS = WKIFVSERUS;
         IFVSSTAT = WKIFVSSTAT;
         CHIDS = '01W';
         EXSR CHIFVS;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFVS;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPPAKET2;

         WKIFVSTSTP = %DATE(PKDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(PKTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(PKTIDI:'X'):7:6):6:0));

         SELECT;
         WHEN PKANR1 <> *BLANK AND %SUBST(PKANR1:1:1) = 'K';                     // Kom.-Schein
           MONITOR;
             WKIFVSJAHR = %DEC(%SUBST(PKANR1:4:4):4:0);
           ON-ERROR;
             WKIFVSJAHR = 0;
             EXSR RMVMONMSG;
           ENDMON;

           WKIFVSKMPO = PKANRP;
           WKIFVSNMKR = %SUBST(PKANR1:8:6);
           WKIFVSDANA = 'AFKM';
           WKIFVSKDLI = *BLANK;
           EXSR EVSBD;

         WHEN PKANR1 <> *BLANK AND %SUBST(PKANR1:1:1) = 'T';                     // Kom.-Schein
           MONITOR;                                                              // Trägergestell
             WKIFVSJAHR = %DEC(%SUBST(PKANR1:4:4):4:0);
           ON-ERROR;
             WKIFVSJAHR = 0;
             EXSR RMVMONMSG;
           ENDMON;

           WKIFVSKMPO = PKANRP;
           WKIFVSNMKR = %SUBST(PKANR1:8:6);
           WKIFVSDANA = 'AFKM';
           WKIFVSKDLI = *BLANK;
           EXSR EVSBD;

         WHEN PKANR1 <> *BLANK AND %SUBST(PKANR1:1:1) = 'P';                     // Prod.-Auftrag
           MONITOR;
             WKIFVSJAHR = %DEC(%SUBST(PKANR1:4:4):4:0);
           ON-ERROR;
             WKIFVSJAHR = 0;
             EXSR RMVMONMSG;
           ENDMON;

           WKIFVSKMPO = PKANRP;
           WKIFVSNMKR = %SUBST(PKANR1:8:6);
           WKIFVSDANA = 'PAUK';
         ENDSL;

         WKIFVSKMNN = *ZERO;
         WKIFVSANZA = *ZERO;
         MONITOR;
           WKIFVSGWBR = PKBGEW;
         ON-ERROR;
           WKIFVSGWBR = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           WKIFVSGWNT = PKNGEW;
         ON-ERROR;
           WKIFVSGWNT = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         MONITOR;
           WKIFVSVOLU = PKCM3;
         ON-ERROR;
           WKIFVSVOLU = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         WKIFVSTENR = PKIDEN;
         WKIFVSKLKZ = *BLANK;
         WKIFVSABJJ = *ZERO;
         WKIFVSABNR = *BLANK;
         WKIFVSABMS = *BLANK;
         WKIFVSTMST = *ZERO;
         WKIFVSDPDN = *BLANK;
         WKIFVSDSKZ = *BLANK;
         WKIFVSDSDF = *BLANK;
         WKIFVSPAKN = PKVENR;
         WKIFVSKDNR = PKKDNR;
         WKIFVSVSNR = *BLANK;
         WKIFVSSDJJ = *ZERO;
         WKIFVSSDNR = *BLANK;
         WKIFVSLANR = '001';
         WKIFVSLORT = '001';
         WKIFVSPMLA = *BLANK;
         WKIFVSPMTS = *ZERO;

         WKIFVSJNAM = PKBS;
         WKIFVSPROG = PKPGM;
         WKIFVSBIBL = WKCHPL;
         WKIFVSJZEI = %DEC(%TIME());
         WKIFVSJDAT = %DEC(%DATE():*ISO);
         WKIFVSUSER = DAUSER;
         WKIFVSERUS = PKUSER;

         IF PKDTB <> 0;
           WKIFVSERDA = PKDTB;
         ELSE;
           WKIFVSERDA = %DEC(%DATE():*ISO);
         ENDIF;

         IF PKTIB <> 0;
           WKIFVSERZT = PKTIB;
         ELSE;
           WKIFVSERZT = %DEC(%TIME());
         ENDIF;
       ENDSR;
       //-------------------------------------------------------------------------------------------
       // Die nachfolgend aufgeführten Felder entsprechen in Ausprägung und Reihenfolge den Feldern
       // in der File PPAKET2.
       // Wenn der Inhalt aus zusätzlichen Feldern nach trend übernommen werden soll, dann die
       // Felder in den Bereich über die Linie kopieren (nicht ausschneiden). Danke.
       //
       BEGSR DUMMY;

         WKIFVSC100 = PKKONZ;     // EMS                           A    1    3    KONZERN
         WKIFVSC100 = PKFIRM;     // DWI                           A    4    6    FIRMA
         WKIFVSN100 = PKLFDN;     //                               S    7   15 0  LFD NUMMER
         WKIFVSN100 = PKLENR;     //                               S   16   24 0  LADE- EINHEIT
         WKIFVSN100 = PKZULE;     //                               S   25   33 0  ZUGANGS- LADEEINHE
         WKIFVSC100 = PKZUNV;     //                               A   34   79    ZUGANGS- NVE-NUMME
         WKIFVSN100 = PKZUPK;     //                               S   80   88 0  ZUGANGS- PACKSTÜCK
         WKIFVSC100 = PKEXLE;     //                               A   89  108    EXTERNE LADEEINHEI
         WKIFVSN100 = PKNRKS;     //                               S  109  117 0  NR.KOMM- SERIE
         WKIFVSN100 = PKBENR;     //                               S  118  126 0  BEHÄLTER- NUMMER
         WKIFVSN100 = PKPALN;     //                               S  127  135 0  TPA-NR
         WKIFVSN100 = PKPALP;     //                               S  136  138 0  TPA POS
         WKIFVSN100 = PKPKNR;     //                               S  139  147 0  PACKSTÜCK- NUMMER
         WKIFVSN100 = PKMPKN;     //                               S  148  156 0  MASTER- PACKST-NR
         WKIFVSN100 = PKPSNR;     //                               S  157  165 0  SAMMEL-NR PACKDIAL
         WKIFVSC100 = PKIDEN;     //                               A  166  193    ARTIKELNUMMER
         WKIFVSC100 = PKIDV;      //                               A  194  208    ARTIKELVARIANTE
         WKIFVSC100 = PKIDVA;     //                               A  209  223    ZUSATZART. VARIANT
         WKIFVSC100 = PKEAN;      //                               A  224  237    EAN-NR / GTIN
         WKIFVSN100 = PKPMEN;     //                               S  238  248 3  PACKMENGE
         WKIFVSN100 = PKSMEN;     //                               S  249  259 3  SOLLMENGE
         WKIFVSN100 = PKZMEN;     //                               S  260  270 3  RÜCKLIEFER MENGE
         WKIFVSN100 = PKCMEN;     //                               S  271  281 3  STORNIERTE MENGE
         WKIFVSC100 = PKME;       //                               A  282  284    MENGEN- EINHEIT
         WKIFVSN100 = PKVPE;      //                               S  285  295 3  MENGE IN VERPACK-E
         WKIFVSC100 = PKME1;      //                               A  296  298    ME DER VPE
         WKIFVSN100 = PKVPE2;     //                               S  299  309 3  MENGE IN /UMVERP-E
         WKIFVSC100 = PKME2;      //                               A  310  312    ME DER UVPE
         WKIFVSN100 = PKSTCK;     //                               S  313  321 3  ANZAHL STÜCK
         WKIFVSN100 = PKEGEW;     //                               S  322  335 5  EINZEL-GEW IN KG
         WKIFVSN100 = PKSGEW;     //                               S  336  349 5  SUMME-GEW IN KG
         WKIFVSN100 = PKAPN;      //                               S  350  358 0  ARBEITS- PAKET-NR
         WKIFVSN100 = PKAPPO;     //                               S  359  364 0  ARBEITS- PAKET-POS
         WKIFVSN100 = PKAPN1;     //                               S  365  373 0  AP-NR 1.K-STUFE
         WKIFVSN100 = PKAPP1;     //                               S  374  379 0  AP-POS 1.K-STUFE
         WKIFVSN100 = PKLFD1;     //                               S  380  388 0  LFDN-SATZ-NR AP-ST
         WKIFVSN100 = PKAPN2;     //                               S  389  397 0  AP-NR 2.K-STUFE
         WKIFVSN100 = PKAPP2;     //                               S  398  403 0  AP-POS 2.K-STUFE
         WKIFVSN100 = PKPALA;     //                               S  404  412 0  ALTE PAL-NR
         WKIFVSN100 = PKPAPA;     //                               S  413  415 0  ALTE PAL-POS
         WKIFVSC100 = PKRVOR;     //                               A  416  425    NR. RÜST- VORSCHRI
         WKIFVSC100 = PKTOUR;     //                               A  426  431    TOUR
         WKIFVSC100 = PKSNDG;     //                               A  432  441    SENDUNGS-NR.
         WKIFVSC100 = PKVART;     //                               A  442  445    VERSAND- ART
         WKIFVSC100 = PKSSC;      //                               A  446  449    VERSAND- SERVICE-C
         WKIFVSC100 = PKBVAR;     //                               A  450  453    BASIS- VERS-ART
         WKIFVSC100 = PKMVAR;     //                               A  454  457    MASTER- VERS-ART
         WKIFVSC100 = PKUVAR;     //                               A  458  461    URSPRUNGS- VERS-AR
         WKIFVSC100 = PKUSSC;     //                               A  462  465    URSPRUNGS- SERVICE
         WKIFVSC100 = PKSTEU;     //                               A  466  469    KENNZ. STEUERER
         WKIFVSC100 = PKAART;     //                               A  470  473    AUFTRAGS- ART
         WKIFVSC100 = PKAPSR;     //                               A  474  483    AP-SERIE/WAVE
         WKIFVSC100 = PKEXPO;     //                               A  484  486    EXPORT-KZ
         WKIFVSN100 = PKPSST;     //                               S  487  489 0  PACK- SST
         WKIFVSN100 = PKZSST;     //                               S  490  492 0  ZIEL- SST
         WKIFVSC100 = PKBEM1;     //                               C  493  544    ARTIKELBEMERKUNG 1
         WKIFVSC100 = PKBEM2;     //                               C  545  596    ARTIKELBEMERKUNG 2
         WKIFVSC100 = PKBEM3;     //                               C  597  648    ARTIKELBEMERKUNG 3
         WKIFVSC100 = PKKZEA;     //                               A  649  649    KZ ERSATZ- ARTIKEL
         WKIFVSC100 = PKTXEA;     //                               C  650  709    TEXT F ERSATZARTIK
         WKIFVSC100 = PKBHF;      //                               A  710  719    BAHNHOF
         WKIFVSC100 = PKRTGN;     //                               A  720  759    ROUTING NR
         WKIFVSC100 = PKC215;     //                               A  760  761    C215 STEUERUNG
         WKIFVSN100 = PKKOKT;     //                               S  762  762 0  KENNZ. ORI-KTN
         WKIFVSN100 = PKLOKT;     //                               S  763  771 0  LFD ORI-KTN-NR
         WKIFVSN100 = PKDTRF;     //                               S  772  779 0  REIFE- DATUM
         WKIFVSN100 = PKDTLI;     //                               S  780  787 0  DATUM LETZTE INV
         WKIFVSN100 = PKDTSK;     //                               S  788  795 0  SOLL-KOMM DATUM
         WKIFVSN100 = PKTISK;     //                               S  796  801 0  SOLL-KOMM Uhrzeit
         WKIFVSC100 = PKTZSK;     //                               A  802  811    ZEIT- ZONE
         WKIFVSN100 = PKDTK;      //                               S  812  819 0  KOMM.- DATUM
         WKIFVSN100 = PKTIK;      //                               S  820  825 0  KOMM.- ZEIT
         WKIFVSC100 = PKTZK;      //                               A  826  835    ZEIT- ZONE
         WKIFVSN100 = PKDTB;      //                               S  836  843 0  PACK- DATUM
         WKIFVSN100 = PKTIB;      //                               S  844  849 0  PACK- ZEIT
         WKIFVSC100 = PKTZB;      //                               A  850  859    ZEIT- ZONE
         WKIFVSC100 = PKALP;      //                               A  860  869    AUSLAGER- PUNKT
         WKIFVSC100 = PKHW;       //                               C  870  949    TRANSPORT HINWEIS
         WKIFVSC100 = PKBAUG;     //                               A  950  959    BAUGRUPPE
         WKIFVSC100 = PKBST1;     //                               A  960  984    BESTELL-NR
         WKIFVSN100 = PKBSTP;     //                               S  985  990 0  BESTELL- POS
         WKIFVSC100 = PKWENR;     //                               A  991 1000    WE-NUMMER
         WKIFVSN100 = PKWEPO;     //                               S 1001 1006 0  WE-POS
         WKIFVSC100 = PKLSNR;     //                               A 1007 1022    LIEFERSCHEIN- NUMM
         WKIFVSN100 = PKLSNP;     //                               S 1023 1027 0  LIEFERSCHEIN- POSI
         WKIFVSN100 = PKTLSN;     //                               S 1028 1033 0  TEILLIEFER- SCHEIN
         WKIFVSC100 = PKLIEF;     //                               A 1034 1048    LIEFERANTEN- NUMME
         WKIFVSC100 = PKANR1;     //                               A 1049 1073    AUFTRAGS-NR. KUNDE
         WKIFVSN100 = PKANRP;     //                               S 1074 1079 0  AUFTRAGS-NR. KUNDE
         WKIFVSN100 = PKANRU;     //                               S 1080 1085 0  AUFTRAGS-NR. UNTER
         WKIFVSC100 = PKFNR1;     //                               A 1086 1110    FERTIG.-NR
         WKIFVSN100 = PKFNRP;     //                               S 1111 1116 0  FERTIG. POS
         WKIFVSC100 = PKKDNR;     //                               A 1117 1126    KUNDEN-NR
         WKIFVSC100 = PKHKLD;     //                               A 1127 1129    HERKUNFTS- LAND
         WKIFVSC100 = PKPRNR;     //                               A 1130 1144    PRÜF-NR/CHARGE
         WKIFVSC100 = PKREVS;     //                               A 1145 1164    REVISIONS- STAND
         WKIFVSN100 = PKMDRF;     //                               S 1165 1173 0  MODUL- REFERENZ
         WKIFVSC100 = PKSRN;      //                               A 1174 1198    SERIENNUMMER
         WKIFVSC100 = PKPRN;      //                               A 1199 1223    PROJEKTNUMMER
         WKIFVSN100 = PKZUBE;     //                               S 1224 1232 0  ZUGANGS- BELEG
         WKIFVSN100 = PKKST;      //                               S 1233 1239 0  KOSTEN- STELLE
         WKIFVSC100 = PKANB;      //                               A 1240 1242    ANBINDUNG AN
         WKIFVSC100 = PKRFNR;     //                               A 1243 1292    REFERENZ-NUMMER
         WKIFVSN100 = PKPNPM;     //                               S 1293 1301 0  PICK-NR PICK-MANAG
         WKIFVSN100 = PKEXRF;     //                               S 1302 1310 0  EXTERNE REFERENZ-N
         WKIFVSN100 = PKSRRF;     //                               S 1311 1319 0  SERIENNUMMER REFER
         WKIFVSC100 = PKSKGW;     //                               A 1320 1329    SAMMEL-KOM. GERÄT
         WKIFVSN100 = PKSKGF;     //                               S 1330 1333 0  SKG- FACH
         WKIFVSN100 = PKGTNR;     //                               S 1334 1337 0  GERAETE NUMMER
         WKIFVSN100 = PKGHOR;     //                               S 1338 1340 0  HORIZ.
         WKIFVSN100 = PKGVER;     //                               S 1341 1342 0  VERT.
         WKIFVSC100 = PKGRKO;     //                               A 1343 1344    KZ GRUPPEN- KOMM
         WKIFVSC100 = PKPZUC;     //                               A 1345 1346    PACKDIALOG ZUGRIFF
         WKIFVSN100 = PKPZUN;     //                               S 1347 1355 0  PACKDIALOG ZUGRIFF
         WKIFVSC100 = PKTXTP;     //                               C 1356 1435    TEXT GEPARKTE WARE
         WKIFVSC100 = PKKZP;      //                               A 1436 1436    KZ GEPARKTE WARE
         WKIFVSN100 = PKBGEW;     //                               S 1437 1450 5  BRUTTOGEW IN KG
         WKIFVSN100 = PKNGEW;     //                               S 1451 1464 5  NETTOGEW IN KG
         WKIFVSN100 = PKTARA;     //                               S 1465 1478 5  TARA-GEW IN KG
         WKIFVSC100 = PKQKZ;      //                               A 1479 1480    QUALITÄTS- KENNZEI
         WKIFVSC100 = PKQSTA;     //                               A 1481 1481    QUALITÄTS- STATUS
         WKIFVSC100 = PKQCHR;     //                               A 1482 1541    QUALITÄTS MERKMALE
         WKIFVSN100 = PKDTEE;     //                               S 1542 1549 0  DATUM ERSTEINLAG
         WKIFVSN100 = PKDTZU;     //                               S 1550 1557 0  DATE ZUGANG
         WKIFVSN100 = PKDTDC;     //                               S 1558 1565 0  MHD
         WKIFVSN100 = PKCM3;      //                               S 1566 1576 2  LM-VOLUMEN IN CM3
         WKIFVSN100 = PKKTL;      //                               S 1577 1583 2  LM-LÄNGE IN CM
         WKIFVSN100 = PKKTB;      //                               S 1584 1590 2  LM-BREITE IN CM
         WKIFVSN100 = PKKTH;      //                               S 1591 1597 2  LM-HÖHE IN CM
         WKIFVSC100 = PKPTYP;     //                               A 1598 1600    LADE- MITTEL
         WKIFVSC100 = PKVLMT;     //                               A 1601 1603    VERSAND LM-TYP
         WKIFVSN100 = PKANZP;     //                               S 1604 1612 0  ANZAHL PAKETE/COLL
         WKIFVSC100 = PKACWA;     //                               A 1613 1614    AKTIONSCODE WAREN-
         WKIFVSC100 = PKWEKZ;     //                               A 1615 1615    WAREN- KZ. ALT
         WKIFVSC100 = PKWAKZ;     //                               A 1616 1616    WAREN- KENNZEICHEN
         WKIFVSC100 = PKKOMA;     //                               A 1617 1617    KONSI- MAT.
         WKIFVSC100 = PKOWNR;     //                               A 1618 1627    EIGENTÜMER
         WKIFVSC100 = PKZCDE;     //                               A 1628 1642    ZOLL-CODE
         WKIFVSN100 = PKAPKN;     //                               S 1643 1651 0  ZUSATZ PACKSTÜCK N
         WKIFVSC100 = PKPSTS;     //                               A 1652 1652    PACK- STATUS
         WKIFVSC100 = PKBS;       //                               A 1653 1662    BILDSCHIRM
         WKIFVSC100 = PKUSER;     //                               A 1663 1672    USER
         WKIFVSC100 = PKPGM;      //                               A 1673 1682    PROGRAMM NAME
         WKIFVSC100 = PKVENR;     //                               A 1683 1728    VERSANDEINHEITEN-
         WKIFVSC100 = PKMVEN;     //                               A 1729 1774    MASTER NVE
         WKIFVSN100 = PKDISK;     //                               S 1775 1783 0  DISKETTEN- NR
         WKIFVSN100 = PKDTDE;     //                               S 1784 1791 0  DATUM DISK-ERSTELL
         WKIFVSN100 = PKTIDE;     //                               S 1792 1797 0  ZEIT DISK-ERSTELLT
         WKIFVSC100 = PKTZDE;     //                               A 1798 1807    ZEIT- ZONE
         WKIFVSC100 = PKVLZI;     //                               A 1808 1817    VERLADEZIEL
         WKIFVSC100 = PKVLBR;     //                               A 1818 1827    VERLADEBEREICH
         WKIFVSC100 = PKVLKZ;     //                               A 1828 1828    VERLADE- KZ
         WKIFVSC100 = PKVLRL;     //                               A 1829 1829    VERLADE- RELEVANT
         WKIFVSC100 = PKKOP;      //                               A 1830 1839    KONSOLIDIER- PLATZ
         WKIFVSC100 = PKKOP2;     //                               A 1840 1849    KONSOLIDIER- PLATZ
         WKIFVSC100 = PKPPLZ;     //                               A 1850 1859    PUFFER- PLATZ
         WKIFVSC100 = PKLOC;      //                               A 1860 1861    LOCATION
         WKIFVSC100 = PKPSTU;     //                               A 1862 1862    PACK- STUFE
         WKIFVSC100 = PKPPTY;     //                               A 1863 1864    PACKPLATZ- TYP
         WKIFVSC100 = PKPPLA;     //                               A 1865 1874    PACKPLATZ
         WKIFVSC100 = PKRTGR;     //                               A 1875 1876    RETOUREN- GRUND
         WKIFVSN100 = PKRTNR;     //                               S 1877 1885 0  RETOUREN- NUMMER
         WKIFVSC100 = PKPUSR;     //                               A 1886 1895    VERPACKER 2.STUFE
         WKIFVSC100 = PKPBS;      //                               A 1896 1905    BILDSCHIRM 2.STUFE
         WKIFVSC100 = PKPPGM;     //                               A 1906 1915    PROGRAMM 2.STUFE
         WKIFVSN100 = PKDTP;      //                               S 1916 1923 0  PACKDATUM 2.STUFE
         WKIFVSN100 = PKTIP;      //                               S 1924 1929 0  PACKZEIT 2.STUFE
         WKIFVSC100 = PKTZP;      //                               A 1930 1939    ZEIT- ZONE
         WKIFVSC100 = PKMUSR;     //                               A 1940 1949    VERPACKER MASTER
         WKIFVSC100 = PKMBS;      //                               A 1950 1959    BILDSCHIRM MASTER
         WKIFVSC100 = PKMPGM;     //                               A 1960 1969    PROGRAMM MASTER
         WKIFVSN100 = PKDTM;      //                               S 1970 1977 0  PACKDATUM MASTER
         WKIFVSN100 = PKTIM;      //                               S 1978 1983 0  PACKZEIT MASTER
         WKIFVSC100 = PKTZM;      //                               A 1984 1993    ZEIT- ZONE
         WKIFVSC100 = PKRTUR;     //                               A 1994 2003    USER RETOURE
         WKIFVSC100 = PKRTBS;     //                               A 2004 2013    TERMINAL RETOURE
         WKIFVSC100 = PKRTPG;     //                               A 2014 2023    PROGRAMM RETOURE
         WKIFVSN100 = PKDTRT;     //                               S 2024 2031 0  DATUM RETOURE
         WKIFVSN100 = PKTIRT;     //                               S 2032 2037 0  ZEIT RETOURE
         WKIFVSC100 = PKTZRT;     //                               A 2038 2047    ZEIT- ZONE
         WKIFVSN100 = PKDTPS;     //                               S 2048 2055 0  EFF.DATUM VERP.STA
         WKIFVSN100 = PKTIPS;     //                               S 2056 2061 0  EFF.ZEIT VERP.STAR
         WKIFVSC100 = PKTZPS;     //                               A 2062 2071    ZEIT- ZONE
         WKIFVSN100 = PKDTPE;     //                               S 2072 2079 0  EFF.DATUM VERP.END
         WKIFVSN100 = PKTIPE;     //                               S 2080 2085 0  EFF.ZEIT VERP.ENDE
         WKIFVSC100 = PKTZPE;     //                               A 2086 2095    ZEIT- ZONE
         WKIFVSN100 = PKDTVS;     //                               S 2096 2103 0  DATUM VERL.START
         WKIFVSN100 = PKTIVS;     //                               S 2104 2109 0  ZEIT VERL.START
         WKIFVSC100 = PKTZVS;     //                               A 2110 2119    ZEIT- ZONE
         WKIFVSN100 = PKDTVE;     //                               S 2120 2127 0  DATUM VERL.ENDE
         WKIFVSN100 = PKTIVE;     //                               S 2128 2133 0  ZEIT VERL.ENDE
         WKIFVSC100 = PKTZVE;     //                               A 2134 2143    ZEIT- ZONE
         WKIFVSC100 = PKVLUS;     //                               A 2144 2153    USER VERL.
         WKIFVSC100 = PKVLBS;     //                               A 2154 2163    TERMINAL VERL.
         WKIFVSC100 = PKVLPG;     //                               A 2164 2173    PROGRAMM VERL.
         WKIFVSN100 = PKDTSE;     //                               S 2174 2181 0  SYS-EING.- DATUM
         WKIFVSN100 = PKTISE;     //                               S 2182 2187 0  SYS-EING.- ZEIT
         WKIFVSC100 = PKTZSE;     //                               A 2188 2197    ZEIT- ZONE
         WKIFVSC100 = PKKZCE;     //                               A 2198 2198    KZ CHARGEN- ERFASS
         WKIFVSC100 = PKKZGE;     //                               A 2199 2199    KZ GEW.- ERFASS.
         WKIFVSC100 = PKKZDE;     //                               A 2200 2200    KZ MHD- ERFASS.
         WKIFVSN100 = PKBSTU;     //                               S 2201 2201 0  BESTANDS- ÜBERNAHM
         WKIFVSC100 = PKSPNR;     //                               A 2202 2211    SPEDITEUR NUMMER
         WKIFVSC100 = PKTTST;     //                               A 2212 2212    TRCK&TRAC STS ACT.
         WKIFVSN100 = PKDTTT;     //                               S 2213 2220 0  TRCK&TRAC DATE ACT
         WKIFVSN100 = PKTITT;     //                               S 2221 2226 0  TRCK&TRAC TIME ACT
         WKIFVSC100 = PKTZTT;     //                               A 2227 2236    ZEIT- ZONE
         WKIFVSC100 = PKTTPG;     //                               A 2237 2246    TRCK&TRAC PGM ACT
         WKIFVSC100 = PKTTUS;     //                               A 2247 2256    TRCK&TRAC USR ACT
         WKIFVSC100 = PKTTBS;     //                               A 2257 2266    TRCK&TRAC BS ACT
         WKIFVSC100 = PKTTHW;     //                               C 2267 2386    TRCK&TRAC HINW ACT
         WKIFVSC100 = PKTTCS;     //                               A 2387 2406    T&T STATUS SPEDI.
         WKIFVSC100 = PKSSST;     //                               A 2407 2407    SHIPM-SYST. STATUS
         WKIFVSN100 = PKDTSS;     //                               S 2408 2415 0  SHIP-SYST. PRINTIN
         WKIFVSN100 = PKTISS;     //                               S 2416 2421 0  SHIP-SYST. PRINTIN
         WKIFVSC100 = PKTZSS;     //                               A 2422 2431    ZEIT- ZONE
         WKIFVSC100 = PKSEP1;     //                               A 2432 2441    BESTANDS- TRENNUNG
         WKIFVSC100 = PKSEP2;     //                               A 2442 2451    BESTANDS- TRENNUNG
         WKIFVSC100 = PKBOEN;     //                               A 2452 2466    ZOLL- ZUGANGSBELEG
         WKIFVSC100 = PKBOEX;     //                               A 2467 2481    ZOLL- ABGANGSBELEG
         WKIFVSN100 = PKEXRT;     //                               S 2482 2489 4  WECHSELKURS
         WKIFVSN100 = PKPPR;      //                               S 2490 2500 4  EINST.-PREIS STD-W
         WKIFVSC100 = PKWAER;     //                               A 2501 2503    WAEHRUNGS- SCHLÜSS
         WKIFVSN100 = PKPPRF;     //                               S 2504 2514 4  EINST.-PREIS FREMD
         WKIFVSC100 = PKWAEF;     //                               A 2515 2517    WAEHRUNGS- SCHLÜSS
         WKIFVSC100 = PKCPPR;     //                               A 2518 2520    FREMDWÄHRUNG
         WKIFVSC100 = PKRECN;     //                               A 2521 2540    RECHNUNGS-NR
         WKIFVSC100 = PKFDOK;     //                               A 2541 2560    FRACHTDOKUMENT
         WKIFVSC100 = PKSHMT;     //                               A 2561 2570    LIEFERUNG
         WKIFVSN100 = PKFRCO;     //                               S 2571 2581 4  FRACHTKOSTEN
         WKIFVSN100 = PKADCO;     //                               S 2582 2592 4  NEBENKOSTEN
         WKIFVSN100 = PKAWB;      //                               S 2593 2604 0  AIR WAYBILL
         WKIFVSN100 = PKMAWB;     //                               S 2605 2616 0  MASTER AIR WAYBILL
         WKIFVSC100 = PKJISPG;    //                               A 2617 2620    JIS PROD-GRP
         WKIFVSC100 = PKJISPL;    //                               A 2621 2623    JIS PROD-LINE
         WKIFVSC100 = PKJISSQ;    //                               A 2624 2628    JIS SEQUENZ
         WKIFVSC100 = PKINRF1;    //                               A 2629 2658    INBOUND REFERENCE1
         WKIFVSC100 = PKINRF2;    //                               A 2659 2688    INBOUND REFERENCE2
         WKIFVSC100 = PKINRF3;    //                               A 2689 2718    INBOUND REFERENCE3
         WKIFVSC100 = PKOURF1;    //                               A 2719 2748    OUTBOUND REFERENCE
         WKIFVSC100 = PKOURF2;    //                               A 2749 2778    OUTBOUND REFERENCE
         WKIFVSC100 = PKOURF3;    //                               A 2779 2808    OUTBOUND REFERENCE
         WKIFVSN100 = PKLFPK;     //                               S 2809 2814 0  LFD PACKST-NR
         WKIFVSN100 = PKLFMX;     //                               S 2815 2820 0  LFD PACK MAX
         WKIFVSC100 = PKCPYR;     //                               A 2821 2830    FRACHTZAHLER
         WKIFVSC100 = PKDPYR;     //                               A 2831 2840    ZOLLZAHLER
         WKIFVSN100 = PKVASR;     //                               S 2841 2841 0  VAS RELEVANT
         WKIFVSN100 = PKHAZG;     //                               S 2842 2842 0  KENNZ. GEFAHRGUT
         WKIFVSC100 = PKUNNR;     //                               A 2843 2846    UN-NUMMER GGVS
         WKIFVSN100 = PKRN1;      //                               S 2847 2847 0  RES-1,0 RN1
         WKIFVSN100 = PKRN2;      //                               S 2848 2849 0  RES-2,0 RN2
         WKIFVSN100 = PKRN5;      //                               S 2850 2854 0  RES-5,0 RN5
         WKIFVSN100 = PKRN7;      //                               S 2855 2861 0  RES-7,0 RN7
         WKIFVSN100 = PKRN9;      //                               S 2862 2870 0  RES-9,0 RN9
         WKIFVSN100 = PKRN92;     //                               S 2871 2879 2  RES-9,2 RN92
         WKIFVSN100 = PKRN113;    //                               S 2880 2890 3  RES-11,3 RN113
         WKIFVSN100 = PKRN114;    //                               S 2891 2901 4  RES-11,4 RN114
         WKIFVSC100 = PKRA1;      //                               A 2902 2902    RES-1A RA1
         WKIFVSC100 = PKRA2;      //                               A 2903 2904    RES-2A RA2
         WKIFVSC100 = PKRA3;      //                               A 2905 2907    RES-3A RA3
         WKIFVSC100 = PKRA4;      //                               A 2908 2911    RES-4A RA4
         WKIFVSC100 = PKRA5;      //                               A 2912 2916    RES-5A RA5
         WKIFVSC100 = PKRA7;      //                               A 2917 2923    RES-7A RA7
         WKIFVSC100 = PKRA10;     //                               A 2924 2933    RES-10A RA10
         WKIFVSC100 = PKRA13;     //                               A 2934 2946    RES-13A RA13
         WKIFVSC100 = PKRA15;     //                               A 2947 2961    RES-15A RA15
         WKIFVSC100 = PKRA18;     //                               A 2962 2979    RES-18A RA18
         WKIFVSN100 = PKFN1;      //                               S 2980 2980 0  RES-1,0 FN1
         WKIFVSN100 = PKFN2;      //                               S 2981 2982 0  RES-2,0 FN2
         WKIFVSN100 = PKFN5;      //                               S 2983 2987 0  RES-5,0 FN5
         WKIFVSN100 = PKFN7;      //                               S 2988 2994 0  RES-7,0 FN7
         WKIFVSN100 = PKFN9;      //                               S 2995 3003 0  RES-9,0 FN9
         WKIFVSN100 = PKFN92;     //                               S 3004 3012 2  RES-9,2 FN92
         WKIFVSN100 = PKFN113;    //                               S 3013 3023 3  RES-11,3 FN113
         WKIFVSN100 = PKFN114;    //                               S 3024 3034 4  RES-11,4 FN114
         WKIFVSC100 = PKFA1;      //                               A 3035 3035    RES-1A FA1
         WKIFVSC100 = PKFA2;      //                               A 3036 3037    RES-2A FA2
         WKIFVSC100 = PKFA3;      //                               A 3038 3040    RES-3A FA3
         WKIFVSC100 = PKFA4;      //                               A 3041 3044    RES-4A FA4
         WKIFVSC100 = PKFA5;      //                               A 3045 3049    RES-5A FA5
         WKIFVSC100 = PKFA7;      //                               A 3050 3056    RES-7A FA7
         WKIFVSC100 = PKFA10;     //                               A 3057 3066    RES-10A FA10
         WKIFVSC100 = PKFA13;     //                               A 3067 3079    RES-13A FA13
         WKIFVSC100 = PKFA15;     //                               A 3080 3094    RES-15A FA15
         WKIFVSC100 = PKFA18;     //                               A 3095 3112    RES-18A FA18
         WKIFVSN100 = PKDTE;      //                               S 3113 3120 0  ERL./RÜCKCH. DATUM
         WKIFVSN100 = PKTIE;      //                               S 3121 3126 0  ERL./RÜCKCH. ZEIT
         WKIFVSC100 = PKTZE;      //                               A 3127 3136    ZEIT- ZONE
         WKIFVSC100 = PKVSTS;     //                               A 3137 3137    VERARB.- STATUS
         WKIFVSC100 = PKVSSA;     //                               A 3138 3138    VER.STS SAP
         WKIFVSC100 = PKVSMV;     //                               A 3139 3139    VER.STS MOVEX
         WKIFVSC100 = PKVSED;     //                               A 3140 3140    VER.STS EDI
         WKIFVSC100 = PKVSXM;     //                               A 3141 3141    VER.STS XML
         WKIFVSC100 = PKVSFT;     //                               A 3142 3142    VER.STS FTP
         WKIFVSC100 = PKVSHD;     //                               A 3143 3143    VER.STS ESS
         WKIFVSC100 = PKVSMA;     //                               A 3144 3144    VER.STS MAS90
         WKIFVSC100 = PKVSSB;     //                               A 3145 3145    VER.STS STEEB
         WKIFVSC100 = PKVSKT;     //                               A 3146 3146    VER.STS KTL
         WKIFVSC100 = PKVSSD;     //                               A 3147 3147    VER.STS STRADA/SD
         WKIFVSC100 = PKVSH1;     //                               A 3148 3148    VER.STS HOST 1
         WKIFVSC100 = PKVSH2;     //                               A 3149 3149    VER.STS HOST 2
         WKIFVSC100 = PKVSH3;     //                               A 3150 3150    VER.STS HOST 3
         WKIFVSC100 = PKVSH4;     //                               A 3151 3151    VER.STS HOST 4
         WKIFVSC100 = PKVSH5;     //                               A 3152 3152    VER.STS HOST 5
         WKIFVSC100 = PKFCD;      //                               A 3153 3162    FEHLER- CODE
         WKIFVSC100 = PKFTXT;     //                               C 3163 3322    FEHLERTEXT
         WKIFVSN100 = PKDTDI;     //                               S 3323 3330 0  DB DATUM WRITE
         WKIFVSN100 = PKTIDI;     //                               S 3331 3342 0  DB ZEIT WRITE
         WKIFVSC100 = PKDIUSR;    //                               A 3343 3352    DB USER WRITE
         WKIFVSC100 = PKDIBS;     //                               A 3353 3362    DB JOB WRITE
         WKIFVSC100 = PKDIJBN;    //                               A 3363 3368    DB JOBNR. WRITE
         WKIFVSC100 = PKDIUSRB;   //                               A 3369 3378    DB USER BATCH WRIT
         WKIFVSC100 = PKDIBSB;    //                               A 3379 3388    DB JOB BATCH WRITE
         WKIFVSC100 = PKDIJBNB;   //                               A 3389 3394    DB JOBNR. BATCH WR
         WKIFVSC100 = PKDIPGM;    //                               A 3395 3404    DB PGM WRITE
         WKIFVSC100 = PKDIPGMU;   //                               A 3405 3414    USER DEF. DB PGM W
         WKIFVSN100 = PKDTDU;     //                               S 3415 3422 0  DB DATUM REWRITE
         WKIFVSN100 = PKTIDU;     //                               S 3423 3434 0  DB ZEIT REWRITE
         WKIFVSC100 = PKDUUSR;    //                               A 3435 3444    DB USER REWRITE
         WKIFVSC100 = PKDUBS;     //                               A 3445 3454    DB JOB REWRITE
         WKIFVSC100 = PKDUJBN;    //                               A 3455 3460    DB JOBNR. REWRITE
         WKIFVSC100 = PKDUUSRB;   //                               A 3461 3470    DB USER BATCH REWR
         WKIFVSC100 = PKDUBSB;    //                               A 3471 3480    DB JOB BATCH REWRI
         WKIFVSC100 = PKDUJBNB;   //                               A 3481 3486    DB JOBNR. BATCH RE
         WKIFVSC100 = PKDUPGM;    //                               A 3487 3496    DB PGM REWRITE
         WKIFVSC100 = PKDUPGMU;   //                               A 3497 3506    USER DEF. DB PGM R

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN LIEFERANT AUS VERSANDBEDINGUNG                          ***
       //*************************************************************************
       BEGSR EVSBD;

       KYVBBD = PKVART;
       CHIDS = '01C';
       EXSR CHVSBD;
       WKIFVSKDLI = VBSPED;

       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS IN PPAKET2                                          ***
       //*************************************************************************
       BEGSR UPPAKET2;

       //KYPPAKET2L1.PKKONZ = PKKONZ;
       //KYPPAKET2L1.PKFIRM = PKFIRM;
       //KYPPAKET2L1.PKAPN = PKAPN;
       //KYPPAKET2L1.PKPKNR = PKPKNR;
       //CHAIN %KDS(KYPPAKET2L1:3) PPAKET2L1;
       PKTIM = %DEC(%TIME());
       PKDTM = %DEC(%DATE():*ISO);
       PKVSH1 = *ON;
       UPDATE PPAKETFL1;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHAFKM
      /COPY QCPYSRC,CHIFVS
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHVSBD
      /COPY QCPYSRC,VRMVMONMSG
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
