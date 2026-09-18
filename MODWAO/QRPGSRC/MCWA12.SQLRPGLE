     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2016')
      //*************************************************************************
      /TITLE MC-Routine für Datei WA12
      //*************************************************************************
      //  Copyright 2016 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 01.02.2016 DOMETIC Projekt 11363
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //
      //*************************************************************************
      //
      //  Dieses Programm dient zur Matchcode-Anzeige der Datei WA12.
      //  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
      //  rufende Programm.
      //  Die Parameter werden in dem Feld #CKOMM übergeben.
      //
      //  KOM(01) = KYWA12AFAT KD-Af-Art
      //  KOM(04) = KYWA12KDNR Kunden-Nr
      //  KOM(14) = KYWA12PRGR Produkt-Gruppe
      //  KOM(18) = KYWA12TENR Ident-Nr

      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FMCWA12FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWA12R1:RCDNBR)
     F                                     SFILE(DLWA12R1:WKRCNO)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ

     D SFLWA12         S                   LIKE(KYWA12) DIM(999)
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
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ

     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D WA12          E DS
     D KYWA12        E DS                  INZ
     D UXWA12        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ

     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ

     D EXWA12        E DS                  INZ
     D RTWA12        E DS                  INZ

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
     D SFWA12PRGR      S             40
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
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPAGE          S                   LIKE(PAGNBR)
     D W$PAGE          S                   LIKE(PAGNBR)
     D WKRENO          S                   LIKE(RCDNBR)
     D W$RCNO          S                   LIKE(RCDNBR)
     D WKWA12          S                   LIKE(KYWA12)
     D WKUXMCPARM      S                   LIKE(EXUXMCPARM)
     D WKPROG          S                   LIKE(RTWA12PROG)
     D WKDANA          S                   LIKE(RTWA12DANA)
     D WKFFLD          S                   LIKE(RTWA12FFLD)
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
      // Program name: C_TRWA12
      // Purpose:
      // Returns:
      // Parameter:      #EXWA12
      // Parameter:      #RTWA12
      //--------------------------------------------------
     D C_TRWA12...
     D                 PR                  EXTPGM('TRWA12')
     D  #EXWA12                            LIKEDS(EXWA12)
     D  #RTWA12                            LIKEDS(RTWA12)

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
     C                   PARM                    WA12

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
       EXSR KEYWA12;
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
           OPEN MCWA12FM;
           WKIOKZ = *ON;
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
         CLEAR WA12;
       ENDIF;

       IF WKIOKZ = *ON
         AND WKIWND = *ON;
         CLOSE MCWA12FM;
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
         KYAAFI = DAFIRM;      // AFPA
         KYKDFI = DAFIRM;      // KUND
         KYTEFI = DAFIRM;      // TEIL
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA12FIRM = DAFIRM;  // WA12

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         // Benutzersprache in allen Keystrukturen setzen
         EXTEXTSPCD = DAUSSP;  // TEXT

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;
         %SUBST(W99DS:01) = EXFIRMKNAM;
         %SUBST(W99DS:31) = *BLANK;

         EXTRDNDANA = 'MCWA12';
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;

         DSKOPF = W99DS;
         WNKOPF = %SUBST(W99DS:32);

         EXTEXTMSGA = 'UEB';
         EXTEXTMSGN = 'KEIN';
         EXTEXTPGST = 'PRUEFE';

         C_TRTEXT(EXTEXT:RTTEXT);
         TXKEIN = RTTEXTTEXT;

         WKIFMT = '01';
         WKMCKZ = '01';
         WKPAGE = *ZERO;

         SFLWA12 = *BLANK;
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

         EXFLPOFMTN = 'MCWA12FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme KOM-Bereich                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

         IF #CPGST <> WKPGST;
           SFLWA12 = *BLANK;
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
         DSWA12AFAT = %SUBST(#CKOMM:01);
         DSWA12KDNR = %SUBST(#CKOMM:04);
         DSWA12PRGR = %SUBST(#CKOMM:14);
         DSWA12TENR = %SUBST(#CKOMM:18);

         // Optionszeile setzen
         IF #CUEBE = *BLANK;

           IF WKPGST = '5     '; // Anzeigemodus
             #CUEBE = '0012';
           ELSE;
             #CUEBE = '0209';    // 4=Löschen  5=Detail
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
           AND WKPGST <> '5     ';
           WKIFMT = '01';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Keybestückung WA12                                                ***
       //*************************************************************************
       BEGSR KEYWA12;

         WKSTMT =
           'SELECT * FROM WA12 '  +
           'WHERE WA12FIRM = ''' + DAFIRM + '''';

         IF DSWA12AFAT <> *BLANK;
           IF %SCAN(WCTRD:DSWA12AFAT) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA12AFAT = ''' + DSWA12AFAT + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA12AFAT) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA12AFAT)) + '''';
           ENDIF;
         ENDIF;

         IF DSWA12KDNR <> *BLANK;
           IF %SCAN(WCTRD:DSWA12KDNR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA12KDNR = ''' + DSWA12KDNR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA12KDNR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA12KDNR)) + '''';
           ENDIF;
         ENDIF;

         IF DSWA12PRGR <> *BLANK;
           IF %SCAN(WCTRD:DSWA12PRGR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA12PRGR = ''' + DSWA12PRGR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA12PRGR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA12PRGR)) + '''';
           ENDIF;
         ENDIF;

         IF DSWA12TENR <> *BLANK;
           IF %SCAN(WCTRD:DSWA12TENR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA12TENR = ''' + DSWA12TENR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA12TENR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA12TENR)) + '''';
           ENDIF;
         ENDIF;

         WKSTMT = %TRIM(WKSTMT) +
           ' ORDER BY WA12FIRM, WA12AFAT, WA12KDNR, WA12PRGR, WA12TENR ';

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
           WRITE MCWA1201;
           WRITE MCWA12K1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT05 = *ON;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;

           SELECT;
           WHEN WKPGST = '5     '
             OR WKPGST = 'DETAIL';
             WRITE MCWA12B2;
           WHEN WKBT24 = *OFF;
             FUKT06 = *ON;
             WRITE MCWA12B1;
           WHEN WKBT24 = *ON;
             FUKT06 = *ON;
             FUKT20 = *ON;
             FUKT24 = *ON;
             WRITE MCWA12B3;
           ENDSL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) MCWA12K1;
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

           WHEN C#EXIT = *ON
             AND FUKT03 = *ON;
             #CPGST = 'ENDE  ';
             DAFEHL = *ON;
             #CRTCD = 'N';
             WKIFMT = '00';
             LEAVE;

           WHEN C#UPDT = *ON
             AND FUKT05 = *ON;
             SFLWA12 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#NEWR = *ON
             AND FUKT06 = *ON;
             SFLWA12 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = *BLANK;
             IF %SCAN(WCTRD:DSWA12AFAT) = *ZERO;
               KYWA12AFAT = DSWA12AFAT;
             ELSE;
               KYWA12AFAT = *BLANK;
             ENDIF;
             IF %SCAN(WCTRD:DSWA12KDNR) = *ZERO;
               KYWA12KDNR = DSWA12KDNR;
             ELSE;
               KYWA12KDNR = *BLANK;
             ENDIF;
             IF %SCAN(WCTRD:DSWA12PRGR) = *ZERO;
               KYWA12PRGR = DSWA12PRGR;
             ELSE;
               KYWA12PRGR = *BLANK;
             ENDIF;
             IF %SCAN(WCTRD:DSWA12TENR) = *ZERO;
               KYWA12TENR = DSWA12TENR;
             ELSE;
               KYWA12TENR = *BLANK;
             ENDIF;
             EXSR TRWA12;
             LEAVE;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#BACK = *ON
             AND FUKT10 = *ON;
             SFAUSW = *BLANK;
             EXSR TRTRDZ;

             IF WKFENR <> *ZERO;
               ITER;
             ENDIF;

             LEAVE;

           WHEN C#VIEW = *ON
             AND FUKT11 = *ON;
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

           WHEN C#CANC = *ON
             AND FUKT12 = *ON;
             EXSR RFMTS;
             #CPGST = *BLANK;
             #CRTCD = 'N';
             SFLWA12 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#INFO = *ON
             AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#MUST = *ON
             AND FUKT20 = *ON;
             SFLWA12 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = 'MUSTER';
             KYWA12AFAT = *BLANK;
             KYWA12KDNR = *BLANK;
             KYWA12PRGR = *BLANK;
             KYWA12TENR = *BLANK;
             EXSR TRWA12;
             LEAVE;

           WHEN C#WEIT = *ON
             AND FUKT24 = *ON;

             IF WKBT24 = *OFF;
               WKBT24 = *ON;
             ELSE;
               WKBT24 = *OFF;
             ENDIF;

             ITER;

           WHEN C#PGUP = *ON
             AND FUKT26 = *ON;
             EXSR BLAET;
             ITER;

           WHEN C#FUKT <> *ZERO
             AND FUKT10 = *ON;
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
         WRITE MCWA12K1;

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
             EXSR WA12KY;
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
           CHAIN RCDNBR MCWA12R1;
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

           UPDATE MCWA12R1;
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
         WKWA12 = KYWA12;
         SFLWA12 = *BLANK;
         SFLAUSW = *BLANK;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           CLEAR KYWA12;
           KYWA12FIRM = DAFIRM;
           READC MCWA12R1;

           // Kein geänderter Satz mehr vorhanden, Format schliessen
           IF %EOF;
             PCPGST = 'ENDE  ';
             EXSR TRWA12;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE MCWA12R1;
           C#NEXT = *OFF;

           I2 += 1;
           SFLWA12(I2) = KYWA12;
           SFLAUSW(I2) = SFAUSW;
         ENDDO;

         KYWA12 = WKWA12;

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

           READC MCWA12R1;

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
           UPDATE MCWA12R1;
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

           IF #CRTCD = 'N'
             OR WKFENR <> *ZERO;
             LEAVE;
           ENDIF;

           IF PCPGST = '4     ';

             WKWA12 = KYWA12;

             IF WKIDEL = *OFF;

               WKIFMT = 'DL';
               EXSR BILDDL;
               KYWA12 = WKWA12;
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
             EXSR TRWA12;

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
             EXSR TRWA12;

             IF PCPGST <> '5'                                                   // ANZEIGEN
               AND PCPGST <> '4'                                                // LÖSCHEN
               AND PCPGST <> '3'                                                // KOPIEREN
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

           CHAIN RCDNBR MCWA12R1;
           *IN97 = NOT %FOUND;
           SFAUSW = *BLANK;
           UPDATE MCWA12R1;
           EXSR LAUSW;

           SELECT;

           WHEN PCPGST = '1     ';
             LEAVE;

           WHEN PCPGST = '3     ';
             PCPGST = '2     ';
             KYWA12AFAT = RTWA12AFAT;
             KYWA12KDNR = RTWA12KDNR;
             KYWA12PRGR = RTWA12PRGR;
             KYWA12TENR = RTWA12TENR;
             EXSR TRWA12;

           ENDSL;

         ENDDO;

         IF WKFENR <> *ZERO
           AND RCDNBR > *ZERO;

           CHAIN RCDNBR MCWA12R1;
           *IN97 = NOT %FOUND;
           C_AUSW = *ON;
           C#NEXT = *ON;
           UPDATE MCWA12R1;
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
         EXSR CHWA12;

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

           WRITE MCWA1201;
           WRITE DLWA12K1;
           EXSR OFFUKT;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;
           WRITE MCWA12DL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) DLWA12K1;
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
         WRITE DLWA12K1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;

         RCDNBR = 1;
         WKRCNO = *ZERO;

         DOU *INLR = *ON;

           IF SFAUSW = '4 '
             OR SFAUSW = ' 4';
             WKRCNO += 1;
             WRITE DLWA12R1;
             EXSR UXDLWRTE;
           ENDIF;

           READC MCWA12R1;
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
           UPDATE MCWA12R1;
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
           CHAIN WKRCNO DLWA12R1;

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

           UPDATE DLWA12R1;
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
           WRITE MCWA12W1;
           WRITE MCWA12M1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           WRITE W1WA12B1;
           WKIWND = *ON;

           SELECT;
           WHEN WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDSL;

           C#WNDW = *OFF;

           READ(E) MCWA12M1;
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

           EXSR KEYWA12;

           SFLWA12 = *BLANK;
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

         EXFLPOFLDN = 'DSWA12AFAT';
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für BILDM1                                          ***
       //*************************************************************************
       BEGSR BM1PR;

         WKFENR = *ZERO;

         EXSR PRWA12AFAT;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRWA12KDNR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRWA12PRGR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRWA12TENR;
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
           EXFLPOFLDN = 'DSWA12AFAT';

         WHEN FLDNAM = 'DSWA12AFAT';
           EXSR MCWA12AFAT;

         WHEN FLDNAM = 'DSWA12KDNR';
           EXSR MCWA12KDNR;

         WHEN FLDNAM = 'DSWA12PRGR';
           EXSR MCWA12PRGR;

         WHEN FLDNAM = 'DSWA12TENR';
           EXSR MCWA12TENR;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine AFAT                                                   ***
       //*************************************************************************
       BEGSR MCWA12AFAT;

         C#WNDW = *ON;

         IF DSWA12AFAT = *BLANK;
           TXWA12AFAT = *BLANK;
         ENDIF;

         KOM = *BLANK;
         #CPGST = 'AFPA01';
         #CUEBE = '0526';
         EXSR MCAFPA;

         IF WKFENR = *ZERO
           AND WKTRTP = *OFF;
           DSWA12AFAT = AAAFAT;
           TXWA12AFAT = AAABEZ;
           WKTRTP = *ON;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine AFAT                                                   ***
       //*************************************************************************
       BEGSR PRWA12AFAT;

         EXFLPOFLDN = 'DSWA12AFAT';
         TXWA12AFAT = *BLANK;
         T1WA12AFAT = *BLANK;

         IF DSWA12AFAT <> *BLANK
           AND %SCAN(WCTRD:DSWA12AFAT) = *ZERO;                                 // "*"-Funktion
           KYAAAT = DSWA12AFAT;                                                 // PRÜFEN DER
           CHIDS = '01C';
           EXSR CHAFPA;
           TXWA12AFAT = AAABEZ;
           T1WA12AFAT = AAABEZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Roitine KDNR                                                   ***
       //*************************************************************************
       BEGSR MCWA12KDNR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA12KDNR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCKUND;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA12KDNR = KDKDNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine KDNR                                                   ***
       //*************************************************************************
       BEGSR PRWA12KDNR;

         EXFLPOFLDN = 'DSWA12KDNR';
         DSKUNDKNAM = *BLANK;

         IF DSWA12KDNR <> *BLANK;
           KYKDNR = DSWA12KDNR;
           CHIDS = '01C';
           EXSR CHKUND;

           IF WKFENR = *ZERO
             OR %SCAN(WCTRD:DSWA12KDNR) <> *ZERO;  // "*"-FUNKTION
             DSWA12KDNR = KDKDNR;
             DSKUNDKNAM = KDKNAM;
             WKFENR = *ZERO;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR MCWA12PRGR;

         C#WNDW = *ON;

         IF DSWA12PRGR = *BLANK;
           TXWA12PRGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'PRGR';
         %SUBST(KOMDS:12) = DSWA12PRGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA12PRGR = TPTCDE;
           TXWA12PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR PRWA12PRGR;

         EXFLPOFLDN = 'DSWA12PRGR';
         TXWA12PRGR = *BLANK;
         T1WA12PRGR = *BLANK;

         IF DSWA12PRGR <> *BLANK
           AND %SCAN(WCTRD:DSWA12PRGR) = *ZERO;
           KYTPTA = 'PRGR';
           KYTPTC = DSWA12PRGR;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXWA12PRGR = TPTTXT;
           T1WA12PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Roitine TENR                                                   ***
       //*************************************************************************
       BEGSR MCWA12TENR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA12TENR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA12TENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRWA12TENR;

         EXFLPOFLDN = 'DSWA12TENR';
         DSTEILTBZ1 = *BLANK;

         IF DSWA12TENR <> *BLANK;
           KYTENR = DSWA12TENR;
           CHIDS = '01C';
           EXSR CHTEIL;

           IF WKFENR = *ZERO
             OR %SCAN(WCTRD:DSWA12TENR) <> *ZERO;  // "*"-FUNKTION
             DSWA12TENR = TETENR;
             DSTEILTBZ1 = TETBZ1;
             WKFENR = *ZERO;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Blaetterroutine                                                   ***
       //*************************************************************************
       BEGSR BLAET;

         SELECT;
         WHEN WKMCKZ = 'KY';
           EXSR WA12KY;
         ENDSL;

         WRITE MCWA12LO;
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
         EXSR CCWA12KY;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  open cursor                                                       ***
       //*************************************************************************
       BEGSR OCURSOR;

        IF WKMCKZ = 'KY'
          AND WKOPENKY <> *ON;

          EXSR OCWA12KY;

        ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Öffenen cursor WA12KY                                             ***
       //*************************************************************************
       BEGSR OCWA12KY;

         WKOPENKY = *ON;

         EXEC SQL PREPARE SQWA12 FROM :WKSTMT;

         EXEC SQL DECLARE WA12KY SCROLL CURSOR FOR SQWA12;

         EXEC SQL OPEN WA12KY;

       ENDSR;

       //*************************************************************************
       //**  Anzeigen Datei WA12                                               ***
       //*************************************************************************
       BEGSR WA12KY;

         SFAUSW = *BLANK;
         C#NDSP = *OFF;
         WKILER = *OFF;
         W$PAGE = 10;
         I0 = 1;

         IF C#PGUP = *ON;
           EXEC SQL
           FETCH CURRENT FROM WA12KY INTO :WA12;
           RCDNBR = WKRENO;
         ELSE;
           EXEC SQL
           FETCH NEXT FROM WA12KY INTO :WA12;
         ENDIF;

         DOW I0 <=(W$PAGE+1);

           IF (SQLCOD < 0 OR
             SQLCOD >= 100) OR
             RCDNBR = 9999;
             C#MORE = *ON;      // SFLEND-KENNZ.
             LEAVE;
           ENDIF;

           IF I0 <= W$PAGE;
             KYWA12AFAT = WA12AFAT;
             KYWA12KDNR = WA12KDNR;
             KYWA12PRGR = WA12PRGR;
             KYWA12TENR = WA12TENR;

             RCDNBR += 1;

             EXSR ADUMM;

             EXSR ERSIC;

             EXSR FAUSW;
             EXSR FKONS;

             WRITE MCWA12R1;
             EXSR UXMCWRTE;

             EXEC SQL
             FETCH NEXT FROM WA12KY INTO :WA12;
           ENDIF;

           I0 += 1;
         ENDDO;

         EXSR ERPAGE;

       ENDSR;

       //*************************************************************************
       //**  close cursor Datei WA12KY                                         ***
       //*************************************************************************
       BEGSR CCWA12KY;

         WKOPENKY = *OFF;

         EXEC SQL CLOSE WA12KY;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten für Anzeigen                                          ***
       //*************************************************************************
       BEGSR ADUMM;

         KYAAAT = WA12AFAT;
         CHIDS = '01C';
         EXSR CHAFPA;

         KYKDNR = WA12KDNR;
         CHIDS = '01C';
         EXSR CHKUND;

         KYTPTA = 'PRGR';
         KYTPTC = WA12PRGR;
         CHIDS = '01C';
         EXSR CHTRTP;
         SFWA12PRGR = TPTTXT;

         KYTENR = WA12TENR;
         CHIDS = '01C';
         EXSR CHTEIL;

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

         I1 = %LOOKUP(KYWA12:SFLWA12:I1);
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

         I1 = %LOOKUP(KYWA12:SFLWA12:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           SFLAUSW(I1) = *BLANK;
           SFLWA12(I1) = *BLANK;
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

           WRITE MCWA12R1;
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
       //**  Update dDteI WA12                                                 ***
       //*************************************************************************
       BEGSR TRWA12;

         CLEAR EXWA12;
         EXWA12PGST = PCPGST;
         EXWA12AFAT = KYWA12AFAT;
         EXWA12KDNR = KYWA12KDNR;
         EXWA12PRGR = KYWA12PRGR;
         EXWA12TENR = KYWA12TENR;
         C_TRWA12(EXWA12:RTWA12);

         WKPROG = RTWA12PROG;
         WKDANA = RTWA12DANA;
         WKFFLD = RTWA12FFLD;
         WKFENR = RTWA12FENR;
         W$PA03 = RTWA12PA03;
         W$PA04 = RTWA12PA04;
         W$PA05 = RTWA12PA05;
         W$PA06 = RTWA12PA06;
         W$PA07 = RTWA12PA07;

         #CRTCD = RTWA12RTCD;

       ENDSR;

       //*************************************************************************
       //**  Aufruf Subfile-Zeilen-Ermittlung                                  ***
       //*************************************************************************
       BEGSR TRAUFRSBFL;

         CLEAR E1SBFL;
         CLEAR EXSBFL;

         EXSBFLPROG = 'MCWA12';
         EXSBFLFMTN = 'MCWA12FM';
         EXSBFLPGST = WKSBFLPGST;
         EXSBFLISIC = WKSBFLISIC;

         EXSBFLFIL1 = 'WA12';
         EXSBFLDAT1 = WA12;

         EXSBFLFIL2 = 'AFPA';
         EXSBFLDAT2 = AFPA;

         EXSBFLFIL3 = 'KUND';
         EXSBFLDAT3 = KUND;

         EXSBFLFIL4 = 'TEIL';
         EXSBFLDAT4 = TEIL;

         EXSBFLAF01 = 'TXWA12PRGR';
         EXSBFLAL01 = SFWA12PRGR;

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

           EXTRDNPGNA = 'MCWA12';
           EXTRDNPGST = 'AUFRUF';

           IF SFAUSW = *BLANK;                                                    // F10=OPTIONEN
             EXTRDNPGNA = 'MCWA12B1';

             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDNPGNA = 'MCWA12B2';
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

           WHEN EXTRDNDANA = 'XXXXXX';

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
         EXSR CHWA12;

         CHAIN RCDNBR MCWA12R1;
         *IN97 = NOT %FOUND;

         KYWA12AFAT = WA12AFAT;
         KYWA12KDNR = WA12KDNR;
         KYWA12PRGR = WA12PRGR;
         KYWA12TENR = WA12TENR;

         C#NDSP = *OFF;

         EXSR ADUMM;

         EXSR ERSIC;

         EXSR FAUSW;
         EXSR FKONS;

         // als geändert markiert lassen
         C#NEXT = *ON;
         UPDATE MCWA12R1;
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
         EXUXMCINAM = 'MCSBFWA12';
         EXUXMCILIB = 'QTEMP';
         EXUXMCIATR = 'TREND';
         EXUXMCDTLG = 4 + 996;
         EXUXMCKYLG = 4;
         EXUXMCITXT = 'Subfile MCWA12';

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
         UXWA12FIRM  = KYWA12FIRM;
         UXWA12AFAT  = KYWA12AFAT;
         UXWA12KDNR  = KYWA12KDNR;
         UXWA12PRGR  = KYWA12PRGR;
         UXWA12TENR  = KYWA12TENR;
         EXUXMCIDTA  = EXUXSICHT + UXWA12;
         EXUXMCIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXMCREAD;

         CLEAR KYWA12;

         DUN040 = RCDNBR;
         EXUXMCIKEY  = DUC004;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXMCIDTA;
         DUN030      = %LEN(UXWA12);
         UXWA12      = %SUBST(EXUXMCIDTA:765:DUN030);
         KYWA12FIRM  = UXWA12FIRM;
         KYWA12AFAT  = UXWA12AFAT;
         KYWA12KDNR  = UXWA12KDNR;
         KYWA12PRGR  = UXWA12PRGR;
         KYWA12TENR  = UXWA12TENR;

       ENDSR;

       //*************************************************************************
       //**  Löschen   Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCRMKY;

         DUN040 = RCDNBR;

         EXUXMCIKEY = DUC004;
         EXUXRCNR     = RCDNBR;
         UXWA12FIRM  = KYWA12FIRM;
         UXWA12AFAT  = KYWA12AFAT;
         UXWA12KDNR  = KYWA12KDNR;
         UXWA12PRGR  = KYWA12PRGR;
         UXWA12TENR  = KYWA12TENR;
         EXUXMCIDTA = EXUXSICHT + UXWA12;
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
         EXUXDLINAM  = 'DLSBFWA12';
         EXUXDLILIB  = 'QTEMP';
         EXUXDLIATR  = 'TREND';
         EXUXDLDTLG  = 4 + 996;
         EXUXDLKYLG  = 4;
         EXUXDLITXT  = 'Subfile DLWA12';

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
         UXWA12FIRM  = KYWA12FIRM;
         UXWA12AFAT  = KYWA12AFAT;
         UXWA12KDNR  = KYWA12KDNR;
         UXWA12PRGR  = KYWA12PRGR;
         UXWA12TENR  = KYWA12TENR;
         EXUXDLIDTA  = EXUXSICHT + UXWA12;
         EXUXDLIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXDLREAD;

         CLEAR KYWA12;

         DUN040 = WKRCNO;
         EXUXDLIKEY  = DUC004;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXDLIDTA;
         DUN030      = %LEN(UXWA12);
         UXWA12      = %SUBST(EXUXDLIDTA:765:DUN030);
         KYWA12FIRM  = UXWA12FIRM;
         KYWA12AFAT  = UXWA12AFAT;
         KYWA12KDNR  = UXWA12KDNR;
         KYWA12PRGR  = UXWA12PRGR;
         KYWA12TENR  = UXWA12TENR;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten der Nachrichten                                       ***
       //*************************************************************************
       BEGSR AUMSG;

         C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
         W$PA06:W$PA07);

         PGMNAM = 'MCWA12';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA12W1;
         OTHER;
           WRITE MCWA12CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA12W1;
         OTHER;
           WRITE MCWA12CT;
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
      /COPY QCPYSRC,CHAFPA
      /COPY QCPYSRC,CHKUND
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA12
      /COPY QCPYSRC,ERSBFL
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCAFPA
      /COPY QCPYSRC,MCKUND
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,UMUEBE
      /COPY QCPYSRC,UMUEBEJV
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  Ende des Programms                                                ***
       //*************************************************************************
      /END-FREE
