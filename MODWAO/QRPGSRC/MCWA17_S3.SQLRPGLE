     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE MC-Routine für Datei WA17
      //*************************************************************************
      //  Copyright 2024 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 05.11.2024 Case #03895676
      //  -----------------------------------------------------------------------
      //  Änderung: PH 19.11.2024 Case #03895676. E-Mail von IK vom 19.11.2024:
      //            - Ausgabe der Textzeile 1 der TRTP "$$TEEWPRGR" in die Sicht
      //            - Ausgabe Konditionswert in die Sicht.
      //            - Aufruf MCKOND ohne Anzeige des Selektionsformats MCKONDMx aber
      //              mit dem gesetzten Kz. für die Anzeige der leeren Subfile MCKOND
      //  Änderung: PH 21.11.2024 Case #03895676, Nachtrag: Abstimmung GS/PH vom 20.11.2024:
      //            Feld "Segment" (1. Textzeile des Anwendungscodes (TRTP-Tabelle) "$$TEEWPRGR")
      //            als Selektionsfeld eingefügt.
      //*************************************************************************
      //
      //  Dieses Programm dient zur Matchcode-Anzeige der Datei WA17.
      //  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
      //  rufende Programm.
      //  Die Parameter werden in dem Feld #CKOMM übergeben.
      //
      //  KOM(01) = KYWA17KDGR Kundengruppe
      //  KOM(05) = KYWA17PRGR Produktgruppe

      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FMCWA17FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWA17R1:RCDNBR)
     F                                     SFILE(DLWA17R1:WKRCNO)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ

     D SFLWA17         S                   LIKE(KYWA17) DIM(999)
     D SFLAUSW         S                   LIKE(SFAUSW) DIM(999)

      //*************************************************************************
      //**  Indicators                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,MCCURSOR

      //*************************************************************************
      //**  Konstantendefinition                                              ***
      //*************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')

      //*************************************************************************
      //**  Dateien                                                           ***
      //*************************************************************************
     D KOND          E DS                  INZ
     D KYKOND        E DS                  INZ

     D TRDZ          E DS                  INZ
     D KYTRDZ        E DS                  INZ
     D UXTRDZ        E DS                  INZ

     D TRDN          E DS                  INZ
     D KYTRDN        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D WA17          E DS
     D KYWA17        E DS                  INZ
     D UXWA17        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ

     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ

     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  Interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX05

      //*************************************************************************
      //**  Programmstatus Datenstruktur                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D PCPGST          S              6
     D WKPGST          S              6
     D WKIFMT          S              2
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKILER          S              1
     D WKAT01          S              1
     D WKAT02          S              1
     D WKIOKZ          S              1
     D WKIWND          S              1
     D WKMCKZ          S              2
     D WKBT24          S              1
     D WKUXMCOPEN      S              1
     D WKUXDLOPEN      S              1
     D WKOPENKY        S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D SFWA17KDGR      S             40
     D SFWA17PRGR      S             40
     D S1WA17PRGR      S             40
     D SFKOKZ          S              1
     D SFKOWT          S             15
     D TXKOKZ          S              1
     D WKSUPD          S              1
     D WKIDEL          S              1
     D WKTRDZZYKL      S              1
     D TXKEIN          S             76
     D WKSTMT          S           1000
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D SI              S              3S 0
     D WKISIC          S              2S 0
     D WKTRPABEGR      S                   LIKE(KOBEGR)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPAGE          S                   LIKE(PAGNBR)
     D W$PAGE          S                   LIKE(PAGNBR)
     D WKRENO          S                   LIKE(RCDNBR)
     D W$RCNO          S                   LIKE(RCDNBR)
     D WKWA17          S                   LIKE(KYWA17)
     D WKUXMCPARM      S                   LIKE(EXUXMCPARM)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKFEAT          S              1
     D WKFENR          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRWA17
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_TRWA17...
     D                 PR                  EXTPGM('TRWA17')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

      //--------------------------------------------------
      // Program name: C_TRFEHLCL
      // Purpose:
      // Returns:
      // Parameter:      #WKFENR
      // Parameter:      #KEYVAR
      // Parameter:      #DSJNAM
      // Parameter:      #DSUSER
      // Parameter:      #W$PA03
      // Parameter:      #W$PA04
      // Parameter:      #W$PA05
      // Parameter:      #W$PA06
      // Parameter:      #W$PA07
      //--------------------------------------------------
     D C_TRFEHLCL...
     D                 PR                  EXTPGM('TRFEHLCL')
     D  #WKFENR                            LIKE(WKFENR)
     D  #KEYVAR                            LIKE(KEYVAR)
     D  #DSJNAM                            LIKE(DSJNAM)
     D  #DSUSER                            LIKE(DSUSER)
     D  #W$PA03                            LIKE(W$PA03)
     D  #W$PA04                            LIKE(W$PA04)
     D  #W$PA05                            LIKE(W$PA05)
     D  #W$PA06                            LIKE(W$PA06)
     D  #W$PA07                            LIKE(W$PA07)

      //--------------------------------------------------
      // Program name: C_TRTEXT
      // Purpose:
      // Returns:
      // Parameter:      #EXTEXT
      // Parameter:      #RTTEXT
      //--------------------------------------------------
     D C_TRTEXT...
     D                 PR                  EXTPGM('TRTEXT')
     D  #EXTEXT                            LIKEDS(EXTEXT)
     D  #RTTEXT                            LIKEDS(RTTEXT)

      //--------------------------------------------------
      // Program name: C_TRTRDZ
      // Purpose:
      // Returns:
      // Parameter:      #EXTRDN
      //--------------------------------------------------
     D C_TRTRDZ...
     D                 PR                  EXTPGM('TRTRDZ')
     D  #EXTRDN                            LIKEDS(EXTRDN)

      //*************************************************************************
      //**  Programmstart                                                     ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    WA17

      /FREE
       EXSR UEBKOM;

       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       IF WKTRPA <> *ON;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;
       EXSR KEYWA17;
       EXSR OFFUKT;

       *IN = *OFF;
       *IN28 = C#IN28;

       EXSR BM1PR;
       IF WKFENR <> *ZERO;
         WKIFMT = 'M1';
       ENDIF;

       //*************************************************************************
       //**  Programmsteuerung                                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           OPEN MCWA17FM;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZAUSW = 'MCWA17';
             EXTRDZFUKT = 'MCWA17B1';
             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDZFUKT = 'MCWA17B2';
             ENDIF;
             EXSR ERTRDZ;
             WKTRDZ = *ON;
           ENDIF;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         WHEN WKIFMT = 'DL';
           EXSR BILDDL;
         WHEN WKIFMT = 'M1';
           EXSR BILDM1;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         OR #CRTCD = '9';
         CLEAR WA17;
       ENDIF;

       IF WKIOKZ = *ON
         AND WKIWND = *ON;
         CLOSE MCWA17FM;
         WKIOKZ = *OFF;
       ENDIF;

       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         #CDATN = *ZERO;
         #CDATV = *ZERO;
         #CDAKW = *ZERO;
         #CDAJJ = *ZERO;
         #CMCAZ = *ZERO;

         WKFIRM = DAFIRM;
         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         // Firma in alle Keystrukten setzen
         KYKOFI = DAFIRM;      // KOND
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA17FIRM = DAFIRM;  // WA17

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         // Benutzersprache in allen Keystrukturen setzen
         EXTEXTSPCD = DAUSSP;  // TEXT

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'MCWA17';
         EXSR RDTRDNTRDN;

         DSKOPF = %SUBST(EXFIRMKNAM:1:30) + ' ' + EXTRDNTEXT;
         WNKOPF = EXTRDNTEXT;

         EXTEXTMSGA = 'UEB';
         EXTEXTMSGN = 'KEIN';
         EXTEXTPGST = 'PRUEFE';
         C_TRTEXT(EXTEXT:RTTEXT);
         TXKEIN = RTTEXTTEXT;

         WKIFMT = '01';
         WKMCKZ = '01';
         WKPAGE = *ZERO;

         SFLWA17 = *BLANK;
         SFLAUSW = *BLANK;

         C#LCK0 = *OFF;
         C#LCK1 = *OFF;
         WKIN30 = C#LCK0;
         WKIN31 = C#LCK1;

         WKAT01 = X'00';
         WKAT01 = X'22';
         WKAT02 = X'00';
         WKAT02 = X'24';

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         WKFEAT = 'F';
         MCF = *BLANK;
         WKIOKZ = *OFF;

         EXFLPOFMTN = 'MCWA17FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme KOM-Bereich                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

         IF #CPGST <> WKPGST;
           SFLWA17 = *BLANK;
           SFLAUSW = *BLANK;
           RCDNBR = *ZERO;
         ENDIF;

         MCFDS = #CMCFG;
         WKPGST = #CPGST;

         // auf reinen Anzeigemodus umschalten
         IF DATEST = '5'
           AND WKPGST = *BLANK;
           WKPGST = '5     ';
         ENDIF;

         KOMDS = #CKOMM;
         DSWA17KDGR = %SUBST(#CKOMM:01);
         DSWA17PRGR = %SUBST(#CKOMM:05);

         // Optionszeile setzen
         IF #CUEBE = *BLANK;

           IF WKPGST = '5     ' OR WKPGST = 'DETAIL'; // Anzeigemodus
             #CUEBE = '0557';    // 5=Detail  10=Optionen
           ELSE;
             #CUEBE = '0561';    // 4=Löschen  5=Detail  10=Optionen
           ENDIF;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Vorlauf                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         EXTEXTMSGA = 'BNR';
         EXTEXTMSGN = #CUEBE;
         EXTEXTPGST = 'ERMBSK';
         C_TRTEXT(EXTEXT:RTTEXT);
         DSBT01 = RTTEXTTEXT;
         BSKDS = RTTEXTBSKZ;

         WKBT24 = *OFF;

         WKIFMT = 'M1';
         FMTDS = *BLANK;

         FM = 1;
         FMT(FM) = '00';
         WKIWND = *OFF;

         IF WKPGST <> *BLANK
           AND WKPGST <> '5     '
           OR DSWA17KDGR <> *BLANK
           OR DSWA17PRGR <> *BLANK;
           WKIFMT = '01';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Keybestückung WA17                                                ***
       //*************************************************************************
       BEGSR KEYWA17;

         KYWA17KDGR = DSWA17KDGR;
         KYWA17PRGR = DSWA17PRGR;

         // Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
         // Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.

         WKSTMT =
           'SELECT * FROM WA17 '  +
           'WHERE WA17FIRM = ''' + DAFIRM + '''';

         IF DSWA17KDGR <> *BLANK;
           IF %SCAN(WCTRD:DSWA17KDGR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA17KDGR = ''' + DSWA17KDGR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA17KDGR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA17KDGR)) + '''';
           ENDIF;
         ENDIF;

         IF DSWA17PRGR <> *BLANK;
           IF %SCAN(WCTRD:DSWA17PRGR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA17PRGR = ''' + DSWA17PRGR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA17PRGR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA17PRGR)) + '''';
           ENDIF;
         ENDIF;

         // Segment
         IF T1TEEWPRGR <> *BLANK;
           WKSTMT = %TRIM(WKSTMT)
           + ' AND EXISTS (SELECT 1 FROM TRTP'
           + ' WHERE TRTP.TPFIRM = ''' + DAFIRM + ''''
           +   ' AND TRTP.TPSPCD = ''' + DASPCD + ''''
           +   ' AND TRTP.TPTART = ''$$TEEWPRGR'''
           +   ' AND TRTP.TPTCDE = WA17.WA17PRGR'
           +   ' AND TRTP.TPTFLG = 1';

           IF %SCAN(WCTRD:T1TEEWPRGR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND LCASE(TRTP.TPTTXT) = LCASE(''' + T1TEEWPRGR + ''')';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND LCASE(TRIM(TRTP.TPTTXT)) LIKE LCASE(''' +
             %TRIM(%XLATE(WCTRD:WCSQL:T1TEEWPRGR)) + ''')';
           ENDIF;

           WKSTMT = %TRIM(WKSTMT) + ')';
         ENDIF;

         WKSTMT = %TRIM(WKSTMT) +
           ' ORDER BY WA17FIRM, WA17KDGR, WA17PRGR ';

         WKSTMT = %TRIM(WKSTMT) + ' FOR FETCH ONLY';
         WKSTMT = %TRIM(WKSTMT) + ' OPTIMIZE FOR 200 ROWS ';

         WKMCKZ = 'KY';

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILD01                                              ***
       //*************************************************************************
       BEGSR BILD01;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR B01DS;

         DOW WKIFMT = '01';
           WRITE MCWA17CL;
           IF RCDNRTRDZ > *ZERO;
             WRITE SFTRDZK1;
           ENDIF;
           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;
           WRITE MCWA1701;
           WRITE MCWA17K1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT05 = *ON;
           //FUKT10 = *ON;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;

           SELECT;
           WHEN WKPGST = '5     '
             OR WKPGST = 'DETAIL';
             WRITE MCWA17B2;
           WHEN WKBT24 = *OFF;
             FUKT06 = *ON;
             //FUKT20 = *ON;
             //FUKT24 = *ON;
             WRITE MCWA17B1;
           WHEN WKBT24 = *ON;
             FUKT06 = *ON;
             FUKT20 = *ON;
             FUKT24 = *ON;
             WRITE MCWA17B3;
           ENDSL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) MCWA17K1;
           *IN98 = %ERROR;
           *IN99 = %EOF;

           IF *IN99 = *ON;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#EXIT = *ON AND FUKT03 = *ON;
             #CPGST = 'ENDE  ';
             DAFEHL = *ON;
             #CRTCD = 'N';
             WKIFMT = '00';
             LEAVE;

           WHEN C#UPDT = *ON AND FUKT05 = *ON;
             SFLWA17 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#NEWR = *ON AND FUKT06 = *ON;
             SFLWA17 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = *BLANK;
             IF %SCAN(WCTRD:DSWA17KDGR) = *ZERO;
               KYWA17KDGR = DSWA17KDGR;
             ELSE;
               KYWA17KDGR = *BLANK;
             ENDIF;
             KYWA17PRGR = *BLANK;
             EXSR TRWA17;
             LEAVE;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#BACK = *ON AND FUKT10 = *ON;
             KYWA17KDGR = DSWA17KDGR;
             KYWA17PRGR = DSWA17PRGR;
             SFAUSW = *BLANK;
             EXSR TRTRDZ;

             IF WKFENR <> *ZERO;
               ITER;
             ENDIF;

             LEAVE;

           WHEN C#VIEW = *ON AND FUKT11 = *ON;
             SI += 1;

             IF SI > 10
               OR FSI(SI) = *ZERO;
               SI = 1;
             ENDIF;

             WKISIC = FSI(SI);
             EXSR MCUEB;
             EXSR B01SI;

             IF CSRRRN > *ZERO;
               PAGNBR = CSRRRN;
             ENDIF;

             WKFENR = *ZERO;
             ITER;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             EXSR RFMTS;
             #CPGST = *BLANK;
             #CRTCD = 'N';
             SFLWA17 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#MUST = *ON AND FUKT20 = *ON;
             SFLWA17 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = 'MUSTER';
             KYWA17KDGR = *BLANK;
             KYWA17PRGR = *BLANK;
             EXSR TRWA17;
             LEAVE;

           WHEN C#WEIT = *ON AND FUKT24 = *ON;

             IF WKBT24 = *OFF;
               WKBT24 = *ON;
             ELSE;
               WKBT24 = *OFF;
             ENDIF;

             ITER;

           WHEN C#PGUP = *ON AND FUKT26 = *ON;
             EXSR BLAET;
             ITER;

           WHEN C#FUKT <> *ZERO AND FUKT10 = *ON;
             KYWA17KDGR = DSWA17KDGR;
             KYWA17PRGR = DSWA17PRGR;
             SFAUSW = *BLANK;
             EXSR TRTRDZ;

             IF WKFENR <> *ZERO;
               ITER;
             ENDIF;

             LEAVE;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           OTHER;
             EXSR B01RA;
             EXSR B01SF;

             IF CSRRRN > *ZERO;
               PAGNBR = CSRRRN;
             ENDIF;

             SELECT;
             WHEN WKFENR <> *ZERO
               AND WKSUPD = *OFF
               OR #CRTCD = 'N'
               AND WKSUPD = *OFF;
               ITER;
             WHEN WKSUPD = *OFF;
               ITER;
             OTHER;
               LEAVE;
             ENDSL;

           ENDSL;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 01                                        ***
       //*************************************************************************
       BEGSR B01DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         IF WKUXMCOPEN = *ON;
           EXUX05PARM = EXUXMCPARM;
           EXSR EXMCCLOS;
           WKUXMCOPEN = *OFF;
         ENDIF;

         IF WKUXMCOPEN <> *ON;
           EXSR UXMCOPEN;
         ENDIF;

         C#INIT = *ON;
         WRITE MCWA17K1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;
         RCDNBR = *ZERO;
         PAGNBR = *ZERO;

         EXSR CCURSOR;
         EXSR OCURSOR;

         DOW W$RCNO > RCDNBR
           OR W$RCNO = *ZERO;

           SELECT;
           WHEN WKMCKZ = 'KY';
             EXSR WA17KY;
           ENDSL;

           C#PGUP = *ON;

           IF C#MORE = *ON
             OR W$RCNO = *ZERO;
             LEAVE;
           ENDIF;

         ENDDO;

         C#PGUP = *OFF;

         IF W$RCNO > *ZERO
           AND W$RCNO <= RCDNBR;
           PAGNBR = W$RCNO;
         ENDIF;

         EXSR MCUEB;

         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Lesen Subfile zum Füllen von KONS bei F11                         ***
       //*************************************************************************
       BEGSR B01SI;

         DUN040 = 1;
         EXUXMCIKEY  = DUC004;
         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         DOW EXUXMCRTCD = *ZERO;

           EXUXSICHT = EXUXMCIDTA;
           RCDNBR = EXUXRCNR;
           CHAIN RCDNBR MCWA17R1;
           *IN97 = NOT %FOUND;

           IF *IN97 = *ON;
             LEAVE;
           ENDIF;

           EXSR FKONS;                                                          // SICHT IN SFL SUCH

           IF SFAUSW <> *BLANK;                                                 // GEÄNDERTE SÄTZE A
             C#NEXT = *ON;                                                      // GEÄNDERT MARKIERT
           ELSE;                                                                // LASSEN
             C#NEXT = *OFF;
           ENDIF;

           UPDATE MCWA17R1;
           C#NEXT = *OFF;

           EXSR EXMCNEXT;
           EXUXMCPARM =  EXUX05PARM;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Retten der Auswahl                                                ***
       //*************************************************************************
       BEGSR B01RA;

         I2 = *ZERO;
         WKWA17 = KYWA17;
         SFLWA17 = *BLANK;
         SFLAUSW = *BLANK;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           CLEAR KYWA17;
           KYWA17FIRM = DAFIRM;
           READC MCWA17R1;

           // Kein geänderter Satz mehr vorhanden, Format schliessen
           IF %EOF;
             PCPGST = 'ENDE  ';
             EXSR TRWA17;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE MCWA17R1;
           C#NEXT = *OFF;

           I2 += 1;
           SFLWA17(I2) = KYWA17;
           SFLAUSW(I2) = SFAUSW;
         ENDDO;

         KYWA17 = WKWA17;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für Subfile                                         ***
       //*************************************************************************
       BEGSR B01SF;

         WKFENR = *ZERO;
         #CPGST = *BLANK;
         PCPGST = *BLANK;
         WKIDEL = *OFF;
         WKSUPD = *OFF;
         WKRCNO = *ZERO;
         W$RCNO = *ZERO;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           READC MCWA17R1;

           IF %EOF;
             PCPGST = 'ENDE  ';
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           W$RCNO = RCDNBR;
           C#NEXT = *ON;
           UPDATE MCWA17R1;
           C#NEXT = *OFF;

           #CRTCD = *BLANK;

           SELECT;
           WHEN %TRIM(SFAUSW)='1' AND BSK(1)='J';
             PCPGST = '1     ';
           WHEN %TRIM(SFAUSW)='2' AND BSK(2)='J';
             PCPGST = '2     ';
           WHEN %TRIM(SFAUSW)='3' AND BSK(3)='J';
             PCPGST = '3     ';
           WHEN %TRIM(SFAUSW)='4' AND BSK(4)='J';
             PCPGST = '4     ';
           WHEN %TRIM(SFAUSW)='5' AND BSK(5)='J';
             PCPGST = '5     ';
           WHEN %TRIM(SFAUSW)<>' ' AND BSK(10)='J';
             PCPGST = 'TRTRDZ';
           WHEN %TRIM(SFAUSW)=' ';
             PCPGST = '      ';
           OTHER;
             WKFENR = '0051';
             LEAVE;
           ENDSL;

           EXSR B01PR;

           IF #CRTCD = 'N' OR WKFENR <> *ZERO;
             LEAVE;
           ENDIF;

           IF PCPGST = '4     ';

             WKWA17 = KYWA17;

             IF WKIDEL = *OFF;

               WKIFMT = 'DL';
               EXSR BILDDL;
               KYWA17 = WKWA17;
               RCDNBR = W$RCNO;

               IF #CRTCD = 'N'
                 OR WKFENR <> *ZERO;
                 LEAVE;
               ENDIF;

               WKIDEL = *ON;

             ENDIF;

           ENDIF;

           SELECT;

           WHEN PCPGST = '1     ';
             #CRTCD = 'J';
             WKIFMT = '00';
             *IN99 = *ON;

           WHEN PCPGST = '4     ';
             EXSR TRWA17;

             IF #CRTCD = 'N'
               OR WKFENR <> *ZERO;
               LEAVE;
             ENDIF;

             WKSUPD = *ON;

           WHEN PCPGST = 'TRTRDZ';
             EXSR TRTRDZ;

             IF #CRTCD = 'N'
               OR WKFENR <> *ZERO;
               LEAVE;
             ENDIF;

           WHEN PCPGST <> *BLANK;
             EXSR TRWA17;

             IF PCPGST <> '5     '                                              // ANZEIGEN
               AND PCPGST <> '4     '                                           // LÖSCHEN
               AND PCPGST <> '3     '                                           // KOPIEREN
               AND #CRTCD <> 'N';                                               // F12 GEDRÜCKT
               EXSR UPSBFL;                                                     // UPDATE SUBFILE
             ENDIF;

             SELECT;
             WHEN PCPGST = '2     ';

             WHEN DATEST = *BLANK
               AND PCPGST <> '5     ';
               WKSUPD = *ON;
             ENDSL;

           ENDSL;

           IF #CRTCD = 'N'
             OR WKFENR <> *ZERO;
             WKSUPD = *OFF;
             LEAVE;
           ENDIF;

           CHAIN RCDNBR MCWA17R1;
           *IN97 = NOT %FOUND;
           SFAUSW = *BLANK;
           UPDATE MCWA17R1;
           EXSR LAUSW;

           SELECT;

           WHEN PCPGST = '1     ';
             LEAVE;

           WHEN PCPGST = '3     ';
             IF %SUBST(RTTRNDKEYB:11:04) <> *BLANK; // WA17PRGR
               PCPGST = '2     ';
               KYWA17KDGR = %SUBST(RTTRNDKEYB:01:04);
               KYWA17PRGR = %SUBST(RTTRNDKEYB:05:04);
               EXSR TRWA17;
             ENDIF;

           ENDSL;

         ENDDO;

         IF WKFENR <> *ZERO
           AND RCDNBR > *ZERO;

           CHAIN RCDNBR MCWA17R1;
           *IN97 = NOT %FOUND;
           C_AUSW = *ON;
           C#NEXT = *ON;
           UPDATE MCWA17R1;
           C_AUSW = *OFF;
           C#NEXT = *OFF;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung BILD01                                              ***
       //*************************************************************************
       BEGSR B01PR;

         WKFENR = *ZERO;

         CHIDS = '01C';
         EXSR CHWA17;

         IF WKFENR <> *ZERO;
           C#LCK1 = *ON;
           LEAVESR;
         ENDIF;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine Löschanzeige                                        ***
       //*************************************************************************
       BEGSR BILDDL;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR BDLDS;

         DOW WKIFMT = 'DL';

           WRITE MCWA1701;
           WRITE DLWA17K1;
           EXSR OFFUKT;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;
           WRITE MCWA17DL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) DLWA17K1;
           *IN98 = %ERROR;
           *IN99 = %EOF;

           IF *IN99 = *ON;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#VIEW = *ON
             AND FUKT11 = *ON;
             SI += 1;

             IF SI > 10
               OR FSI(SI) = *ZERO;
               SI = 1;
             ENDIF;

             WKISIC = FSI(SI);
             EXSR MCUEB;
             EXSR BDLSI;
             WKFENR = *ZERO;

             IF CSRRRN > *ZERO;
               PAGNBR = CSRRRN;
             ENDIF;

             ITER;

           WHEN C#CANC = *ON
             AND FUKT12 = *ON;
             EXSR RFMTS;
             #CRTCD = 'N';
             LEAVE;

           WHEN C#INFO = *ON
             AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           OTHER;
             EXSR RFMTS;

           ENDSL;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Löschanzeige                                               ***
       //*************************************************************************
       BEGSR BDLDS;

         #CRTCD = *BLANK;
         WKFENR = *ZERO;

         IF WKUXDLOPEN = *ON;
           EXUX05PARM = EXUXDLPARM;
           EXSR EXMCCLOS;
           WKUXDLOPEN = *OFF;
         ENDIF;

         IF WKUXDLOPEN <> *ON;
           EXSR UXDLOPEN;
         ENDIF;

         C#INIT = *ON;
         WRITE DLWA17K1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;

         RCDNBR = 1;
         WKRCNO = *ZERO;

         DOU *INLR = *ON;

           IF SFAUSW = '4 '
             OR SFAUSW = ' 4';
             WKRCNO += 1;
             WRITE DLWA17R1;
             EXSR UXDLWRTE;
           ENDIF;

           READC MCWA17R1;
           *IN99 = %EOF;

           IF *IN99 = *ON;
             C#MORE = *ON;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE MCWA17R1;
           C#NEXT = *OFF;
         ENDDO;

         WKPGNO = 1;
         WKFENR = '0005';

       ENDSR;

       //*************************************************************************
       //**  Lesen Subfile zum Füllen von KONS bei F11                         ***
       //*************************************************************************
       BEGSR BDLSI;

         DUN040 = 1;
         EXUXDLIKEY  = DUC004;
         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         DOW EXUXDLRTCD = *ZERO;
           EXUXSICHT   = EXUXDLIDTA;
           WKRCNO      = EXUXRCNR;
           CHAIN WKRCNO DLWA17R1;

           IF NOT %FOUND;
             LEAVE;
           ENDIF;

           // Sicht in Subfile suchen
           EXSR FKONS;

           // Geänderte Sätze als geändert markiert lassen
           IF SFAUSW <> *BLANK;
             C#NEXT = *ON;
           ELSE;
             C#NEXT = *OFF;
           ENDIF;

           UPDATE DLWA17R1;
           C#NEXT = *OFF;
           EXSR EXMCNEXT;
           EXUXDLPARM  = EXUX05PARM;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILDM1                                              ***
       //*************************************************************************
       BEGSR BILDM1;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR BM1DS;

         DOW WKIFMT = 'M1';

           EXSR EFLPO;
           WRITE MCWA17W1;
           WRITE MCWA17M1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           WRITE W1WA17B1;
           WKIWND = *ON;

           SELECT;
           WHEN WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDSL;

           C#WNDW = *OFF;

           READ(E) MCWA17M1;
           *IN98 = %ERROR;
           *IN99 = %EOF;

           IF *IN98 = *ON
             OR *IN99 = *ON;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#EXIT = *ON
             AND FUKT03 = *ON;
             #CPGST = 'ENDE  ';
             DAFEHL = *ON;
             #CRTCD = 'N';
             WKIFMT = '00';
             LEAVE;

           WHEN C#SELC = *ON
             AND FUKT04 = *ON;
             EXSR MCAUFR;

             IF WKTRTP = *ON
               OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON
             AND FUKT12 = *ON;
             EXSR RFMTS;
             #CPGST = *BLANK;
             #CRTCD = 'N';
             LEAVE;

           WHEN C#INFO = *ON
             AND FUKT13 = *ON;
             EXSR VINFO;
             C#WNDW = *ON;
             ITER;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           EXSR BM1PR;
           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR KEYWA17;

           SFLWA17 = *BLANK;
           SFLAUSW = *BLANK;
           W$RCNO = *ZERO;
           WKIFMT = '01';

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat M1                                        ***
       //*************************************************************************
       BEGSR BM1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;

         EXFLPOFLDN = 'DSWA17KDGR';
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für BILDM1                                          ***
       //*************************************************************************
       BEGSR BM1PR;

         WKFENR = *ZERO;

         EXSR PRWA17KDGR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRWA17PRGR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Funktionstaste 4 BILDM1                                           ***
       //*************************************************************************
       BEGSR MCAUFR;

         WKTRTP = *OFF;
         WKFENR = *ZERO;

         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;

         WHEN EXFLPOKZIO = *OFF;
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA17KDGR';

         WHEN FLDNAM = 'DSWA17KDGR';
           EXSR MCWA17KDGR;

         WHEN FLDNAM = 'DSWA17PRGR';
           EXSR MCWA17PRGR;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KDGR                                                   ***
       //*************************************************************************
       BEGSR MCWA17KDGR;

         C#WNDW = *ON;

         IF DSWA17KDGR = *BLANK;
           TXWA17KDGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSWA17KDGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17KDGR = TPTCDE;
           TXWA17KDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune KDGR                                                   ***
       //*************************************************************************
       BEGSR PRWA17KDGR;

         EXFLPOFLDN = 'DSWA17KDGR';
         TXWA17KDGR = *BLANK;

         IF DSWA17KDGR <> *BLANK AND %SCAN(WCTRD:DSWA17KDGR) = *ZERO;
           KYTPTA = 'KDGR';
           KYTPTC = DSWA17KDGR;
           CHIDS  = '01C';
           EXSR CHTRTP;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
           TXWA17KDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR MCWA17PRGR;

         C#WNDW = *ON;

         IF DSWA17PRGR = *BLANK;
           TXWA17PRGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$TEEWPRGR';
         %SUBST(KOMDS:12) = DSWA17PRGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17PRGR = TPTCDE;
           TXWA17PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune PRGR                                                   ***
       //*************************************************************************
       BEGSR PRWA17PRGR;

         EXFLPOFLDN = 'DSWA17PRGR';
         TXWA17PRGR = *BLANK;

         IF DSWA17PRGR <> *BLANK AND %SCAN(WCTRD:DSWA17PRGR) = *ZERO;
           KYTPTA = '$$TEEWPRGR';
           KYTPTC = DSWA17PRGR;
           CHIDS  = '01C';
           EXSR CHTRTP;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
           TXWA17PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KOND                                                   ***
       //*************************************************************************
       BEGSR MCAUFRKOND;

         C#WNDW = *ON;
         EXFLPOFLDN = 'SFAUSW';

         %SUBST(KOMDS:01) = WKTRPABEGR;
         %SUBST(KOMDS:15) = WA17PRGR;
         %SUBST(KOMDS:58) = WA17KDGR;
         %SUBST(KOMDS:217) = '1';     // Leere MCKOND-Subfile anzeigen
         %SUBST(KOMDS:219) = '0';     // Kein Selektionsformat MCKONDMx anzeigen
         #CPGST = 'KWAO01';
         #CUEBE = '0172';
         IF WKPGST = '5     ' OR WKPGST = 'DETAIL' OR DATEST = '5';
           #CUEBE = '0031';
         ENDIF;
         EXSR MCKOND;

       ENDSR;

       //*************************************************************************
       //**  Blaetterroutine                                                   ***
       //*************************************************************************
       BEGSR BLAET;

         SELECT;
         WHEN WKMCKZ = 'KY';
           EXSR WA17KY;
         ENDSL;

         WRITE MCWA17LO;
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Matchcode Überschrift ermitteln                                   ***
       //*************************************************************************
       BEGSR MCUEB;

         WKSBFLPGST = 'ERMCUB';
         WKSBFLISIC = WKISIC;
         EXSR TRAUFRSBFL;

         DSUEBE = RTSBFLMCUB;
         EXSR UMUEBE;

         DSUEBEJV = RTSBFLMCUB;
         EXSR UMUEBEJV;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  close cursor                                                      ***
       //*************************************************************************
       BEGSR CCURSOR;

         IF WKOPENKY = *ON;
           EXSR CCWA17KY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  open cursor                                                       ***
       //*************************************************************************
       BEGSR OCURSOR;

         IF WKMCKZ = 'KY'
           AND WKOPENKY <> *ON;
           EXSR OCWA17KY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Öffenen cursor WA17KY                                             ***
       //*************************************************************************
       BEGSR OCWA17KY;

         WKOPENKY = *ON;

         EXEC SQL PREPARE SQWA17 FROM :WKSTMT;

         EXEC SQL DECLARE WA17KY SCROLL CURSOR FOR SQWA17;

         EXEC SQL OPEN WA17KY;

       ENDSR;

       //*************************************************************************
       //**  Anzeigen Datei WA17                                               ***
       //*************************************************************************
       BEGSR WA17KY;

         SFAUSW = *BLANK;
         C#NDSP = *OFF;
         WKILER = *OFF;
         W$PAGE = 10;
         I0 = 1;

         IF C#PGUP = *ON;
           EXEC SQL
           FETCH CURRENT FROM WA17KY INTO :WA17;
           RCDNBR = WKRENO;
         ELSE;
           EXEC SQL
           FETCH NEXT FROM WA17KY INTO :WA17;
         ENDIF;

         DOW I0 <=(W$PAGE+1);

           IF (SQLCOD < 0 OR
             SQLCOD >= 100) OR
             RCDNBR = 9999;
             C#MORE = *ON;      // SFLEND-KENNZ.
             LEAVE;
           ENDIF;

           IF I0 <= W$PAGE;
             KYWA17KDGR = WA17KDGR;
             KYWA17PRGR = WA17PRGR;

             RCDNBR += 1;

             EXSR ADUMM;

             EXSR ERSIC;

             EXSR FAUSW;
             EXSR FKONS;

             WRITE MCWA17R1;
             EXSR UXMCWRTE;

             EXEC SQL
             FETCH NEXT FROM WA17KY INTO :WA17;
           ENDIF;

           I0 += 1;
         ENDDO;

         EXSR ERPAGE;

       ENDSR;

       //*************************************************************************
       //**  close cursor Datei WA17KY                                         ***
       //*************************************************************************
       BEGSR CCWA17KY;

         WKOPENKY = *OFF;

         EXEC SQL CLOSE WA17KY;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten für Anzeigen                                          ***
       //*************************************************************************
       BEGSR ADUMM;

         KYTPTA = 'KDGR';
         KYTPTC = WA17KDGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         SFWA17KDGR = TPTTXT;

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = WA17PRGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         SFWA17PRGR = TPTTXT;

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = WA17PRGR;
         KYTPTF = 1;
         CHIDS  = '01C';
         EXSR CHTRTP;
         S1WA17PRGR = TPTTXT;
         CLEAR KYTPTF;

         SFKOKZ = *BLANK;
         TXKOKZ = *BLANK;

         IF WKTRPABEGR <> *BLANK;
           DUN080 = %DEC(%DATE():*ISO);
           CLEAR KOND;
           CLEAR SFKOWT;
           SQLCOD = *ZERO;

           EXEC SQL SELECT KOND.KORABA, KOND.KORBKZ, KOND.KOWACD
           INTO :KORABA, :KORBKZ, :KOWACD FROM KOND
           WHERE KOND.KOFIRM = :DAFIRM
             AND KOND.KOBEGR = :WKTRPABEGR
             AND KOND.KOKDLG = :WA17KDGR
             AND KOND.KOPRGR = :WA17PRGR
             AND KOND.KOGADA <= :DUN080
             AND (KOND.KOGBDA = 0 OR KOND.KOGBDA >= :DUN080)
             ORDER BY KOND.KOFIRM DESC, KOND.KOBEGR DESC, KOND.KOPSLI DESC,
                      KOND.KOABTL DESC, KOND.KOLAND DESC, KOND.KOBLGA DESC,
                      KOND.KOKDLI DESC, KOND.KOVSNR DESC, KOND.KOPJNR DESC,
                      KOND.KOKDLG DESC, KOND.KOPRGR DESC, KOND.KOMAGR DESC,
                      KOND.KOVKGB DESC, KOND.KOPOLZ DESC, KOND.KOSTCD DESC,
                      KOND.KOTENR DESC, KOND.KOGEBI DESC, KOND.KOWACD DESC,
                      KOND.KOGADA DESC
           FETCH FIRST ROW ONLY;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             SFKOKZ = *OFF;
             CLEAR KOND;
           ELSE;
             SFKOKZ = *ON;
           ENDIF;

           EXTRPCPGGR = 'BOOL';
           EXTRPCCODE = SFKOKZ;
           EXTRPCPGST = 'PRUEFE';
           EXSR PRTRPC;
           TXKOKZ = EXTRPCTEXT;

           IF KORABA <> *ZERO;
             IF KORBKZ = DAJNKZ;
               SFKOWT = %TRIM(%EDITC(KORABA:'M')) + '%';
             ELSE;
               SFKOWT = %TRIM(%EDITC(KORABA:'M')) +' ' + KOWACD;
             ENDIF;
           ENDIF;

           SQLCOD = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Sichten                                                           ***
       //*************************************************************************
       BEGSR ERSIC;

         SIC = 1;

         DOW SIC <= 10
           AND FSI(SIC) <> *ZERO;

           WKSBFLPGST = 'ERMCUZ';
           WKSBFLISIC = FSI(SIC);
           EXSR TRAUFRSBFL;

           SELECT;
           WHEN SIC = 1
             AND C#IN28 = *OFF;
             EXUXS1 = RTSBFLMCUZ;
           WHEN SIC = 1
             AND C#IN28 = *ON;
             EXUXS1JV = RTSBFLMCUZ;
           WHEN SIC = 2
             AND C#IN28 = *OFF;
             EXUXS2 = RTSBFLMCUZ;
           WHEN SIC = 2
             AND C#IN28 = *ON;
             EXUXS2JV = RTSBFLMCUZ;
           WHEN SIC = 3;
             EXUXS3 = RTSBFLMCUZ;
           WHEN SIC = 4;
             EXUXS4 = RTSBFLMCUZ;
           WHEN SIC = 5;
             EXUXS5 = RTSBFLMCUZ;
           WHEN SIC = 6;
             EXUXS6 = RTSBFLMCUZ;
           WHEN SIC = 7;
             EXUXS7 = RTSBFLMCUZ;
           WHEN SIC = 8;
             EXUXS8 = RTSBFLMCUZ;
           WHEN SIC = 9;
             EXUXS9 = RTSBFLMCUZ;
           WHEN SIC = 10;
             EXUXS10 = RTSBFLMCUZ;
           ENDSL;

           SIC += 1;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen von KONS mit der jeweiligen Sicht                          ***
       //*************************************************************************
       BEGSR FKONS;

         SELECT;
         WHEN SI = 1;
           SFKONS = EXUXS1;
           SFKONSJV = EXUXS1JV;
         WHEN SI = 2;
           SFKONS = EXUXS2;
           SFKONSJV = EXUXS2JV;
         WHEN SI = 3;
           SFKONS = EXUXS3;
         WHEN SI = 4;
           SFKONS = EXUXS4;
         WHEN SI = 5;
           SFKONS = EXUXS5;
         WHEN SI = 6;
           SFKONS = EXUXS6;
         WHEN SI = 7;
           SFKONS = EXUXS7;
         WHEN SI = 8;
           SFKONS = EXUXS8;
         WHEN SI = 9;
           SFKONS = EXUXS9;
         WHEN SI = 10;
           SFKONS = EXUXS10;
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Füllen von AUSW beim Neuaufbau der Subfile                        ***
       //*************************************************************************
       BEGSR FAUSW;

         I1 = 1;

         I1 = %LOOKUP(KYWA17:SFLWA17:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           C#NEXT = *ON;
           SFAUSW = SFLAUSW(I1);
         ELSE;
           C#NEXT = *OFF;
           SFAUSW = *BLANK;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  LÖSCHEN VON AUSW NACH ERFOLGREICHER BEARBEITUNG                   ***
       //*************************************************************************
       BEGSR LAUSW;

         I1 = 1;

         I1 = %LOOKUP(KYWA17:SFLWA17:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           SFLAUSW(I1) = *BLANK;
           SFLWA17(I1) = *BLANK;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Seite                                                   ***
       //*************************************************************************
       BEGSR ERPAGE;

         SELECT;

         WHEN RCDNBR = *ZERO;
           RCDNBR = 1;
           PAGNBR = 1;
           C#NDSP = *ON;
           WKILER = *ON;

           IF C#IN28 = *OFF;
             EXUXS1 = TXKEIN;
             EXUXS2 = TXKEIN;
             EXUXS3 = TXKEIN;
             EXUXS4 = TXKEIN;
             EXUXS5 = TXKEIN;
             EXUXS6 = TXKEIN;
             EXUXS7 = TXKEIN;
             EXUXS8 = TXKEIN;
             EXUXS9 = TXKEIN;
             EXUXS10 = TXKEIN;
             SFKONS = TXKEIN;
           ELSE;
             EXUXS1JV = TXKEIN;
             EXUXS2JV = TXKEIN;
           SFKONSJV = TXKEIN;

           ENDIF;

           WRITE MCWA17R1;
           EXSR UXMCWRTE;

         WHEN RCDNBR <> *ZERO;
           PAGNBR = RCDNBR - 1;
           PAGNBR /= W$PAGE;
           PAGNBR += 1;
           PAGNBR = PAGNBR * W$PAGE;
           PAGNBR -= W$PAGE;
           PAGNBR += 1;
           WKPAGE = PAGNBR;
           WKRENO = RCDNBR;

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Update DateI WA17                                                 ***
       //*************************************************************************
       BEGSR TRWA17;

         CLEAR EXTREND;
         EXTRNDPGST = PCPGST;
         %SUBST(EXTRNDKEYB:01:04) = KYWA17KDGR;
         %SUBST(EXTRNDKEYB:05:04) = KYWA17PRGR;
         C_TRWA17(EXTREND:RTTREND);

         WKPROG = RTTRNDPROG;
         WKDANA = RTTRNDDANA;
         WKFFLD = RTTRNDFFLD;
         WKFENR = RTTRNDFENR;
         W$PA03 = RTTRNDPA03;
         W$PA04 = RTTRNDPA04;
         W$PA05 = RTTRNDPA05;
         W$PA06 = RTTRNDPA06;
         W$PA07 = RTTRNDPA07;

         #CRTCD = RTTRNDRTCD;

       ENDSR;

       //*************************************************************************
       //**  Aufruf Subfile-Zeilen-Ermittlung                                  ***
       //*************************************************************************
       BEGSR TRAUFRSBFL;

         CLEAR E1SBFL;
         CLEAR EXSBFL;

         EXSBFLPROG = 'MCWA17';
         EXSBFLFMTN = 'MCWA17FM';
         EXSBFLPGST = WKSBFLPGST;
         EXSBFLISIC = WKSBFLISIC;

         EXSBFLFIL1 = 'WA17';
         EXSBFLDAT1 = WA17;

         EXSBFLAF01 = 'TXWA17KDGR';
         EXSBFLAL01 = SFWA17KDGR;

         EXSBFLAF02 = 'TXWA17PRGR';
         EXSBFLAL02 = SFWA17PRGR;

         EXSBFLAF03 = '##KOKZ';
         EXSBFLAL03 = SFKOKZ;

         EXSBFLAF04 = 'TXKOKZ';
         EXSBFLAL04 = TXKOKZ;

         EXSBFLAF05 = 'T1WA17PRGR';
         EXSBFLAL05 = S1WA17PRGR;

         EXSBFLAF06 = '##KOWT';
         EXSBFLAL06 = SFKOWT;

         EXSR TRSBFL;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Firmen-Parameter                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         WKSBFLPGST = 'ERMCSI';
         WKSBFLISIC = *ZERO;
         EXSR TRAUFRSBFL;

         WSIDS = RTSBFLMCSI;

         SI = *ZERO;
         FSI = *ZERO;

         FOR I1 = 1 TO 10;

           MONITOR;
             SI          = SI + 1;
             FSI(SI)     = %INT(WSI(I1));
           ON-ERROR *PROGRAM;
             SI          = SI - 1;
           ENDMON;

         ENDFOR;

         SI = 1;
         WKISIC = FSI(SI);

         KYTATA = 'TRWA17';
         KYTATC = 'KOND';
         KYTAPA = 'BEGR';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPABEGR = TAPCDE;

       ENDSR;

       //*************************************************************************
       //**  Auswahl 10 und Zugriff auf TRTRDZ                                 ***
       //*************************************************************************
       BEGSR TRTRDZ;

         WKTRTP = *OFF;
         WKFENR = *ZERO;
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;

           CLEAR EXTRDN;
           EXTRDNAWCD = SFAUSW;

           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;

           EXTRDNPGNA = 'MCWA17';
           EXTRDNPGST = 'AUFRUF';

           IF SFAUSW = *BLANK;                                                    // F10=OPTIONEN
             EXTRDNPGNA = 'MCWA17B1';

             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDNPGNA = 'MCWA17B2';
             ENDIF;

             EXTRDNFUKT = C#FUKT;
           ENDIF;

           IF WKTRDZZYKL = *OFF;
             EXTRDNMCKZ = *ON;
             WKTRDZZYKL = *ON;
           ENDIF;

           C_TRTRDZ(EXTRDN);
           IF EXTRDNRTCD = 'N'
             OR EXTRDNFENR <> *ZERO;
             WKFENR = EXTRDNFENR;
             LEAVE;
           ENDIF;

           SELECT;

           WHEN EXTRDNDANA = 'KOND';
             EXSR MCAUFRKOND;
             EXSR UPSBFL;

           ENDSL;

           #CRTCD = *BLANK;

           IF RTTRDZAWCD <> *BLANKS;
             LEAVE;
           ENDIF;

           IF SFAUSW <> *BLANK
             AND SFAUSW <> '10';
             LEAVE;
           ENDIF;

           IF C#FUKT <> *ZERO
             AND C#BACK <> *ON;
             LEAVE;
           ENDIF;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Update Subfile-Satz                                               ***
       //*************************************************************************
       BEGSR UPSBFL;

         CHIDS = '01C';
         EXSR CHWA17;

         CHAIN RCDNBR MCWA17R1;
         *IN97 = NOT %FOUND;

         KYWA17KDGR = WA17KDGR;
         KYWA17PRGR = WA17PRGR;

         C#NDSP = *OFF;

         EXSR ADUMM;

         EXSR ERSIC;

         EXSR FAUSW;
         EXSR FKONS;

         // als geändert markiert lassen
         C#NEXT = *ON;
         UPDATE MCWA17R1;
         EXSR UXMCRMKY;
         EXSR UXMCWRTE;
         C#NEXT = *OFF;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Öffnen Userindex                                                  ***
       //*************************************************************************
       BEGSR UXMCOPEN;

         CLEAR EXUXMCPARM;
         EXUXMCINAM = 'MCSBFWA17';
         EXUXMCILIB = 'QTEMP';
         EXUXMCIATR = 'TREND';
         EXUXMCDTLG = 4 + 996;
         EXUXMCKYLG = 4;
         EXUXMCITXT = 'Subfile MCWA17';

         EXUX05PARM =  EXUXMCPARM;
         EXSR EXMCOPEN;

         WKUXMCOPEN = *ON;

       ENDSR;

       //*************************************************************************
       //**  Schreiben Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCWRTE;

         DUN040 = RCDNBR;

         EXUXMCIKEY  = DUC004;
         EXUXRCNR    = RCDNBR;
         UXWA17FIRM  = KYWA17FIRM;
         UXWA17KDGR  = KYWA17KDGR;
         UXWA17PRGR  = KYWA17PRGR;
         EXUXMCIDTA  = EXUXSICHT + UXWA17;
         EXUXMCIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXMCREAD;

         CLEAR KYWA17;

         DUN040 = RCDNBR;
         EXUXMCIKEY  = DUC004;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXMCIDTA;
         DUN030      = %LEN(UXWA17);
         UXWA17      = %SUBST(EXUXMCIDTA:765:DUN030);
         KYWA17FIRM  = UXWA17FIRM;
         KYWA17KDGR  = UXWA17KDGR;
         KYWA17PRGR  = UXWA17PRGR;

       ENDSR;

       //*************************************************************************
       //**  Löschen   Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCRMKY;

         DUN040 = RCDNBR;

         EXUXMCIKEY = DUC004;
         EXUXRCNR     = RCDNBR;
         UXWA17FIRM  = KYWA17FIRM;
         UXWA17KDGR  = KYWA17KDGR;
         UXWA17PRGR  = KYWA17PRGR;
         EXUXMCIDTA = EXUXSICHT + UXWA17;
         EXUXMCIMDE = EXUX07NORP;

         EXUX05PARM =  EXUXMCPARM;
         EXSR EXMCBYKY;

         EXUX05PARM =  EXUXMCPARM;
         EXSR EXMCRMKY;

       ENDSR;

       //*************************************************************************
       //**  Öffnen Userindex                                                  ***
       //*************************************************************************
       BEGSR UXDLOPEN;

         CLEAR EXUXDLPARM;
         EXUXDLINAM  = 'DLSBFWA17';
         EXUXDLILIB  = 'QTEMP';
         EXUXDLIATR  = 'TREND';
         EXUXDLDTLG  = 4 + 996;
         EXUXDLKYLG  = 4;
         EXUXDLITXT  = 'Subfile DLWA17';

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCOPEN;

         WKUXDLOPEN = *ON;

       ENDSR;

       //*************************************************************************
       //**  Schreiben Userindex                                               ***
       //*************************************************************************
       BEGSR UXDLWRTE;

         DUN040 = WKRCNO;

         EXUXDLIKEY  = DUC004;
         EXUXRCNR    = WKRCNO;
         UXWA17FIRM  = KYWA17FIRM;
         UXWA17KDGR  = KYWA17KDGR;
         UXWA17PRGR  = KYWA17PRGR;
         EXUXDLIDTA  = EXUXSICHT + UXWA17;
         EXUXDLIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXDLREAD;

         CLEAR KYWA17;

         DUN040 = WKRCNO;
         EXUXDLIKEY  = DUC004;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXDLIDTA;
         DUN030      = %LEN(UXWA17);
         UXWA17      = %SUBST(EXUXDLIDTA:765:DUN030);
         KYWA17FIRM  = UXWA17FIRM;
         KYWA17KDGR  = UXWA17KDGR;
         KYWA17PRGR  = UXWA17PRGR;

       ENDSR;

      /END-FREE
     C/COPY QCPYSRC,SFTRDZ
      /FREE
       //*************************************************************************
       //**  Aufbereiten der Nachrichten                                       ***
       //*************************************************************************
       BEGSR AUMSG;

         C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
         W$PA06:W$PA07);

         PGMNAM = 'MCWA17';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA17W1;
         OTHER;
           WRITE MCWA17CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA17W1;
         OTHER;
           WRITE MCWA17CT;
         ENDSL;

         W$PA03 = *BLANK;
         W$PA04 = *BLANK;
         W$PA05 = *BLANK;
         W$PA06 = *BLANK;
         W$PA07 = *BLANK;
         W$PA08 = *BLANK;
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHKOND
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA17
      /COPY QCPYSRC,ERSBFL
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCKOND
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,UMUEBE
      /COPY QCPYSRC,UMUEBEJV
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  Ende des Programms                                                ***
       //*************************************************************************
      /END-FREE
