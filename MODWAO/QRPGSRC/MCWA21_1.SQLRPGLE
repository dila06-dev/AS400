     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE MC-Routine für Datei WA21
      //*************************************************************************
      //  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 05.12.2024 Case #03829427
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm dient zur Matchcode-Anzeige der Datei WA21.
      //  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
      //  rufende Programm.
      //  Die Parameter werden in dem Feld #CKOMM übergeben.
      //
      //  KOM(01) = KYWA21BLJJ Beleg-Jahr
      //  KOM(05) = KYWA21BLNR Beleg-Nr
      //  KOM(11) = KYWA21BLPO Beleg-Pos

      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FMCWA21FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWA21R1:RCDNBR)
     F                                     SFILE(DLWA21R1:WKRCNO)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ

     D SFLWA21         S                   LIKE(KYWA21) DIM(999)
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
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ

     D BLPA          E DS                  INZ
     D KYBLPA        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

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

     D WA20          E DS                  INZ
     D KYWA20        E DS                  INZ

     D WA21          E DS
     D KYWA21        E DS                  INZ
     D UXWA21        E DS                  INZ

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

     D EXKUSR        E DS                  INZ

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
     D SFWA21BLNR      S             10
     D SFWA21KANR      S             10
     D SFWA21PDIM      S             50
     D SFWA21TLKZ      S             40
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
     D WKWA21          S                   LIKE(KYWA21)
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
      // Program name: C_TRWA21
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_TRWA21...
     D                 PR                  EXTPGM('TRWA21')
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
     C                   PARM                    WA21

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
       EXSR KEYWA21;
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
           OPEN MCWA21FM;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZAUSW = 'MCWA21';
             EXTRDZFUKT = 'MCWA21B1';
             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDZFUKT = 'MCWA21B2';
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
         CLEAR WA21;
       ENDIF;

       IF WKIOKZ = *ON
         AND WKIWND = *ON;
         CLOSE MCWA21FM;
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
         KYBLKOFIRM = DAFIRM;  // BLKO
         KYBLPAFIRM = DAFIRM;  // BLPA
         KYLFFI = DAFIRM;      // LIEF
         KYSYTPFIRM = DAFIRM;  // SYTP
         KYTEFI = DAFIRM;      // TEIL
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA20FIRM = DAFIRM;  // WA20
         KYWA21FIRM = DAFIRM;  // WA21

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         // Benutzersprache in allen Keystrukturen setzen
         EXTEXTSPCD = DAUSSP;  // TEXT

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'MCWA21';
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

         SFLWA21 = *BLANK;
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

         EXFLPOFMTN = 'MCWA21FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme KOM-Bereich                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

         IF #CPGST <> WKPGST;
           SFLWA21 = *BLANK;
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

         MONITOR;
           DSWA21BLJJ = %INT(%SUBST(#CKOMM:01:04));
         ON-ERROR *PROGRAM;
           DSWA21BLJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         DSWA21BLNR = %SUBST(#CKOMM:05);

         MONITOR;
           DSWA21BLPO = %INT(%SUBST(#CKOMM:11:04));
         ON-ERROR *PROGRAM;
           DSWA21BLPO = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         // Optionszeile setzen
         IF #CUEBE = *BLANK;

           IF WKPGST = '5     ' OR WKPGST = 'DETAIL'; // Anzeigemodus
             #CUEBE = '0012';    // 5=Detail
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
           AND WKPGST <> '5     '
           OR DSWA21BLJJ <> *ZERO
           OR DSWA21BLNR <> *BLANK
           OR DSWA21BLPO <> *ZERO;
           WKIFMT = '01';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Keybestückung WA21                                                ***
       //*************************************************************************
       BEGSR KEYWA21;

         KYWA21BLJJ = DSWA21BLJJ;
         KYWA21BLNR = DSWA21BLNR;
         KYWA21BLPO = DSWA21BLPO;

         // Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
         // Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.

         WKSTMT =
           'SELECT * FROM WA21 '  +
           'WHERE WA21FIRM = ''' + DAFIRM + '''';

         // Beleg-Jahr
         IF DSWA21BLJJ <> *ZERO;
           WKSTMT = %TRIM(WKSTMT) +
           ' AND WA21BLJJ = ' + %EDITC(DSWA21BLJJ:'X');
         ENDIF;

         IF DSWA21BLNR <> *BLANK;
           IF %SCAN(WCTRD:DSWA21BLNR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND WA21BLNR = ''' + DSWA21BLNR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(WA21BLNR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSWA21BLNR)) + '''';
           ENDIF;
         ENDIF;

         // Beleg-Pos
         IF DSWA21BLPO <> *ZERO;
           WKSTMT = %TRIM(WKSTMT) +
           ' AND WA21BLPO = ' + %EDITC(DSWA21BLPO:'X');
         ENDIF;

         WKSTMT = %TRIM(WKSTMT) +
           ' ORDER BY WA21FIRM, WA21BLJJ DESC, WA21BLNR DESC, WA21BLPO ';

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
           WRITE MCWA21CL;
           IF RCDNRTRDZ > *ZERO;
             WRITE SFTRDZK1;
           ENDIF;
           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;
           WRITE MCWA2101;
           WRITE MCWA21K1;
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
             WRITE MCWA21B2;
           WHEN WKBT24 = *OFF;
             //FUKT06 = *ON;
             //FUKT20 = *ON;
             //FUKT24 = *ON;
             WRITE MCWA21B1;
           WHEN WKBT24 = *ON;
             FUKT06 = *ON;
             FUKT20 = *ON;
             FUKT24 = *ON;
             WRITE MCWA21B3;
           ENDSL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) MCWA21K1;
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
             SFLWA21 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#NEWR = *ON AND FUKT06 = *ON;
             SFLWA21 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = *BLANK;
             KYWA21BLJJ = *ZERO;
             KYWA21BLNR = *BLANK;
             KYWA21BLPO = *ZERO;
             EXSR TRWA21;
             LEAVE;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#BACK = *ON AND FUKT10 = *ON;
             KYWA21BLJJ = DSWA21BLJJ;
             KYWA21BLNR = DSWA21BLNR;
             KYWA21BLPO = DSWA21BLPO;
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
             SFLWA21 = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#MUST = *ON AND FUKT20 = *ON;
             SFLWA21 = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = 'MUSTER';
             KYWA21BLJJ = *ZERO;
             KYWA21BLNR = *BLANK;
             KYWA21BLPO = *ZERO;
             EXSR TRWA21;
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
             KYWA21BLJJ = DSWA21BLJJ;
             KYWA21BLNR = DSWA21BLNR;
             KYWA21BLPO = DSWA21BLPO;
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
         WRITE MCWA21K1;

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
             EXSR WA21KY;
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
           CHAIN RCDNBR MCWA21R1;
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

           UPDATE MCWA21R1;
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
         WKWA21 = KYWA21;
         SFLWA21 = *BLANK;
         SFLAUSW = *BLANK;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           CLEAR KYWA21;
           KYWA21FIRM = DAFIRM;
           READC MCWA21R1;

           // Kein geänderter Satz mehr vorhanden, Format schliessen
           IF %EOF;
             PCPGST = 'ENDE  ';
             EXSR TRWA21;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE MCWA21R1;
           C#NEXT = *OFF;

           I2 += 1;
           SFLWA21(I2) = KYWA21;
           SFLAUSW(I2) = SFAUSW;
         ENDDO;

         KYWA21 = WKWA21;

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

           READC MCWA21R1;

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
           UPDATE MCWA21R1;
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

             WKWA21 = KYWA21;

             IF WKIDEL = *OFF;

               WKIFMT = 'DL';
               EXSR BILDDL;
               KYWA21 = WKWA21;
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
             EXSR TRWA21;

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
             EXSR TRWA21;

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

           CHAIN RCDNBR MCWA21R1;
           *IN97 = NOT %FOUND;
           SFAUSW = *BLANK;
           UPDATE MCWA21R1;
           EXSR LAUSW;

           SELECT;

           WHEN PCPGST = '1     ';
             LEAVE;

           WHEN PCPGST = '3     ';
             PCPGST = '2     ';
             MONITOR;
               KYWA21BLJJ = %INT(%SUBST(RTTRNDKEYB:01:04));
             ON-ERROR *PROGRAM;
               KYWA21BLJJ = *ZERO;
               EXSR RMVMONMSG;
             ENDMON;
             KYWA21BLNR = %SUBST(RTTRNDKEYB:05:06);
             MONITOR;
               KYWA21BLPO = %INT(%SUBST(RTTRNDKEYB:11:04));
             ON-ERROR *PROGRAM;
               KYWA21BLPO = *ZERO;
               EXSR RMVMONMSG;
             ENDMON;
             EXSR TRWA21;

           ENDSL;

         ENDDO;

         IF WKFENR <> *ZERO
           AND RCDNBR > *ZERO;

           CHAIN RCDNBR MCWA21R1;
           *IN97 = NOT %FOUND;
           C_AUSW = *ON;
           C#NEXT = *ON;
           UPDATE MCWA21R1;
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
         EXSR CHWA21;

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

           WRITE MCWA2101;
           WRITE DLWA21K1;
           EXSR OFFUKT;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;
           WRITE MCWA21DL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) DLWA21K1;
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
         WRITE DLWA21K1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;

         RCDNBR = 1;
         WKRCNO = *ZERO;

         DOU *INLR = *ON;

           IF SFAUSW = '4 '
             OR SFAUSW = ' 4';
             WKRCNO += 1;
             WRITE DLWA21R1;
             EXSR UXDLWRTE;
           ENDIF;

           READC MCWA21R1;
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
           UPDATE MCWA21R1;
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
           CHAIN WKRCNO DLWA21R1;

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

           UPDATE DLWA21R1;
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
           WRITE MCWA21W1;
           WRITE MCWA21M1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           WRITE W1WA21B1;
           WKIWND = *ON;

           SELECT;
           WHEN WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDSL;

           C#WNDW = *OFF;

           READ(E) MCWA21M1;
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

           EXSR KEYWA21;

           SFLWA21 = *BLANK;
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

         EXFLPOFLDN = 'DSWA21BLNR';
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für BILDM1                                          ***
       //*************************************************************************
       BEGSR BM1PR;

         WKFENR = *ZERO;

         EXSR PRWA21BLNR;
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
           EXFLPOFLDN = 'DSWA21BLNR';

         WHEN FLDNAM = 'DSWA21BLNR';
           EXSR MCWA21BLNR;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine BLNR                                                   ***
       //*************************************************************************
       BEGSR MCWA21BLNR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01:04) = %EDITC(DSWA21BLJJ:'X');
         %SUBST(KOMDS:05) = DSWA21BLNR;
         #CPGST = 'DETAIL';
         #CUEBE = '0010';
         EXSR MCBLKO;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA21BLJJ = BLKOBLJJ;
           DSWA21BLNR = BLKOBLNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune BLNR                                                   ***
       //*************************************************************************
       BEGSR PRWA21BLNR;

         EXFLPOFLDN = 'DSWA21BLNR';
         DSWA20LFNR = *BLANK;
         TXWA20LFNR = *BLANK;
         DSLIEFPOLD = *BLANK;
         DSLIEFPOLZ = *BLANK;

         DSWA20BLGA = *BLANK;
         TXWA20BLGA = *BLANK;

         DSWA20FRUS = *BLANK;
         TXWA20FRUS = *BLANK;

         DSWA20FRDA = *ZERO;

         IF DSWA21BLJJ <> *ZERO AND DSWA21BLNR <> *BLANK
           AND %SCAN(WCTRD:DSWA21BLNR) = *ZERO;
           KYBLKOBLJJ = DSWA21BLJJ;
           KYBLKOBLNR = DSWA21BLNR;
           CHIDS  = '01C';
           EXSR CHBLKO;
           WKFENR = *ZERO;

           KYWA20BLJJ = DSWA21BLJJ;
           KYWA20BLNR = DSWA21BLNR;
           CHIDS  = '01C';
           EXSR CHWA20;
           DSWA20LFNR = WA20LFNR;
           DSWA20FRUS = WA20FRUS;
           DSWA20BLGA = WA20BLGA;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

           KYLFNR = DSWA20LFNR;
           CHIDS  = '01C';
           EXSR CHLIEF;
           TXWA20LFNR = LFKNAM;
           DSLIEFPOLD = LFPOLD;
           DSLIEFPOLZ = LFPOLZ;

           IF DSWA20BLGA <> *BLANK;
             KYBLPABLGA = DSWA20BLGA;
             CHIDS  = '01C';
             EXSR CHBLPA;
             TXWA20BLGA = BLPAABEZ;
           ENDIF;

           IF DSWA20FRUS <> *BLANK;
             EXKUSRUUSR = DSWA20FRUS;
             EXSR PRKUSR;
             TXWA20FRUS = EXKUSRUNAM;
           ENDIF;

           IF WA20FRDA <> *ZERO;
             CLEAR EXDATE;
             EXDATEDATV = WA20FRDA;
             EXDATEFMTV = '*ISO';
             EXDATEFMTN = '*EUR';
             EXDATEPGST = 'TRDAUM';
             EXSR TRDATE;
             DSWA20FRDA = RTDATEDATE;
           ENDIF;

           WKFENR = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Blaetterroutine                                                   ***
       //*************************************************************************
       BEGSR BLAET;

         SELECT;
         WHEN WKMCKZ = 'KY';
           EXSR WA21KY;
         ENDSL;

         WRITE MCWA21LO;
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
           EXSR CCWA21KY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  open cursor                                                       ***
       //*************************************************************************
       BEGSR OCURSOR;

         IF WKMCKZ = 'KY'
           AND WKOPENKY <> *ON;
           EXSR OCWA21KY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Öffenen cursor WA21KY                                             ***
       //*************************************************************************
       BEGSR OCWA21KY;

         WKOPENKY = *ON;

         EXEC SQL PREPARE SQWA21 FROM :WKSTMT;

         EXEC SQL DECLARE WA21KY SCROLL CURSOR FOR SQWA21;

         EXEC SQL OPEN WA21KY;

       ENDSR;

       //*************************************************************************
       //**  Anzeigen Datei WA21                                               ***
       //*************************************************************************
       BEGSR WA21KY;

         SFAUSW = *BLANK;
         C#NDSP = *OFF;
         WKILER = *OFF;
         W$PAGE = 09;
         I0 = 1;

         IF C#PGUP = *ON;
           EXEC SQL
           FETCH CURRENT FROM WA21KY INTO :WA21;
           RCDNBR = WKRENO;
         ELSE;
           EXEC SQL
           FETCH NEXT FROM WA21KY INTO :WA21;
         ENDIF;

         DOW I0 <=(W$PAGE+1);

           IF (SQLCOD < 0 OR
             SQLCOD >= 100) OR
             RCDNBR = 9999;
             C#MORE = *ON;      // SFLEND-KENNZ.
             LEAVE;
           ENDIF;

           IF I0 <= W$PAGE;
             KYWA21BLJJ = WA21BLJJ;
             KYWA21BLNR = WA21BLNR;
             KYWA21BLPO = WA21BLPO;

             RCDNBR += 1;

             EXSR ADUMM;

             EXSR ERSIC;

             EXSR FAUSW;
             EXSR FKONS;

             WRITE MCWA21R1;
             EXSR UXMCWRTE;

             EXEC SQL
             FETCH NEXT FROM WA21KY INTO :WA21;
           ENDIF;

           I0 += 1;
         ENDDO;

         EXSR ERPAGE;

       ENDSR;

       //*************************************************************************
       //**  close cursor Datei WA21KY                                         ***
       //*************************************************************************
       BEGSR CCWA21KY;

         WKOPENKY = *OFF;

         EXEC SQL CLOSE WA21KY;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten für Anzeigen                                          ***
       //*************************************************************************
       BEGSR ADUMM;

         SFWA21BLNR = %EDITC(WA21BLJJ:'X') + WA21BLNR;

         KYTENR = WA21TENR;
         CHIDS = '01C';
         EXSR CHTEIL;

         CLEAR SFWA21KANR;
         IF WA21KAJJ <> *ZERO OR WA21KANR <> *BLANK;
           SFWA21KANR = %EDITC(WA21KAJJ:'X') + WA21KANR;
         ENDIF;

         KYTPTA = 'PDIM';
         KYTPTC = WA21PDIM;
         CHIDS = '01C';
         EXSR CHTRTP;
         SFWA21PDIM = TPTTXT;

         EXTRPCPGGR = 'BOOL';
         EXTRPCCODE = WA21TLKZ;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         SFWA21TLKZ = EXTRPCTEXT;

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

         I1 = %LOOKUP(KYWA21:SFLWA21:I1);
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

         I1 = %LOOKUP(KYWA21:SFLWA21:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           SFLAUSW(I1) = *BLANK;
           SFLWA21(I1) = *BLANK;
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

           WRITE MCWA21R1;
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
       //**  Update DateI WA21                                                 ***
       //*************************************************************************
       BEGSR TRWA21;

         CLEAR EXTREND;
         EXTRNDPGST = PCPGST;
         %SUBST(EXTRNDKEYB:01:04) = %EDITC(KYWA21BLJJ:'X');
         %SUBST(EXTRNDKEYB:05:06) = KYWA21BLNR;
         %SUBST(EXTRNDKEYB:11:04) = %EDITC(KYWA21BLPO:'X');
         C_TRWA21(EXTREND:RTTREND);

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

         EXSBFLPROG = 'MCWA21';
         EXSBFLFMTN = 'MCWA21FM';
         EXSBFLPGST = WKSBFLPGST;
         EXSBFLISIC = WKSBFLISIC;

         EXSBFLFIL1 = 'WA21';
         EXSBFLDAT1 = WA21;

         EXSBFLFIL2 = 'TEIL';
         EXSBFLDAT2 = TEIL;

         EXSBFLAF01 = '##BLNR';
         EXSBFLAL01 = SFWA21BLNR;

         EXSBFLAF02 = '##KANR';
         EXSBFLAL02 = SFWA21KANR;

         EXSBFLAF03 = 'TXWA21PDIM';
         EXSBFLAL03 = SFWA21PDIM;

         EXSBFLAF04 = 'TXWA21TLKZ';
         EXSBFLAL04 = SFWA21TLKZ;

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

           EXTRDNPGNA = 'MCWA21';
           EXTRDNPGST = 'AUFRUF';

           IF SFAUSW = *BLANK;                                                    // F10=OPTIONEN
             EXTRDNPGNA = 'MCWA21B1';

             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDNPGNA = 'MCWA21B2';
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
         EXSR CHWA21;

         CHAIN RCDNBR MCWA21R1;
         *IN97 = NOT %FOUND;

         KYWA21BLJJ = WA21BLJJ;
         KYWA21BLNR = WA21BLNR;
         KYWA21BLPO = WA21BLPO;

         C#NDSP = *OFF;

         EXSR ADUMM;

         EXSR ERSIC;

         EXSR FAUSW;
         EXSR FKONS;

         // als geändert markiert lassen
         C#NEXT = *ON;
         UPDATE MCWA21R1;
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
         EXUXMCINAM = 'MCSBFWA21';
         EXUXMCILIB = 'QTEMP';
         EXUXMCIATR = 'TREND';
         EXUXMCDTLG = 4 + 996;
         EXUXMCKYLG = 4;
         EXUXMCITXT = 'Subfile MCWA21';

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
         UXWA21FIRM  = KYWA21FIRM;
         UXWA21BLJJ  = KYWA21BLJJ;
         UXWA21BLNR  = KYWA21BLNR;
         UXWA21BLPO  = KYWA21BLPO;
         EXUXMCIDTA  = EXUXSICHT + UXWA21;
         EXUXMCIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXMCREAD;

         CLEAR KYWA21;

         DUN040 = RCDNBR;
         EXUXMCIKEY  = DUC004;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXMCIDTA;
         DUN030      = %LEN(UXWA21);
         UXWA21      = %SUBST(EXUXMCIDTA:765:DUN030);
         KYWA21FIRM  = UXWA21FIRM;
         KYWA21BLJJ  = UXWA21BLJJ;
         KYWA21BLNR  = UXWA21BLNR;
         KYWA21BLPO  = UXWA21BLPO;

       ENDSR;

       //*************************************************************************
       //**  Löschen   Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCRMKY;

         DUN040 = RCDNBR;

         EXUXMCIKEY = DUC004;
         EXUXRCNR   = RCDNBR;
         UXWA21FIRM = KYWA21FIRM;
         UXWA21BLJJ = KYWA21BLJJ;
         UXWA21BLNR = KYWA21BLNR;
         UXWA21BLPO = KYWA21BLPO;
         EXUXMCIDTA = EXUXSICHT + UXWA21;
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
         EXUXDLINAM  = 'DLSBFWA21';
         EXUXDLILIB  = 'QTEMP';
         EXUXDLIATR  = 'TREND';
         EXUXDLDTLG  = 4 + 996;
         EXUXDLKYLG  = 4;
         EXUXDLITXT  = 'Subfile DLWA21';

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
         UXWA21FIRM  = KYWA21FIRM;
         UXWA21BLJJ  = KYWA21BLJJ;
         UXWA21BLNR  = KYWA21BLNR;
         UXWA21BLPO  = KYWA21BLPO;
         EXUXDLIDTA  = EXUXSICHT + UXWA21;
         EXUXDLIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXDLREAD;

         CLEAR KYWA21;

         DUN040 = WKRCNO;
         EXUXDLIKEY  = DUC004;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXDLIDTA;
         DUN030      = %LEN(UXWA21);
         UXWA21      = %SUBST(EXUXDLIDTA:765:DUN030);
         KYWA21FIRM  = UXWA21FIRM;
         KYWA21BLJJ  = UXWA21BLJJ;
         KYWA21BLNR  = UXWA21BLNR;
         KYWA21BLPO  = UXWA21BLPO;

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

         PGMNAM = 'MCWA21';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA21W1;
         OTHER;
           WRITE MCWA21CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTWA21W1;
         OTHER;
           WRITE MCWA21CT;
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
      /COPY QCPYSRC,CHBLKO
      /COPY QCPYSRC,CHBLPA
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA20
      /COPY QCPYSRC,CHWA21
      /COPY QCPYSRC,ERSBFL
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCBLKO
      /COPY QCPYSRC,MCBLPA
      /COPY QCPYSRC,MCKUSR
      /COPY QCPYSRC,MCLIEF
      /COPY QCPYSRC,MCSYTP
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,MCWA20
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRKUSR
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,UMUEBE
      /COPY QCPYSRC,UMUEBEJV
      /COPY QCPYSRC,VINFO
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  Ende des Programms                                                ***
       //*************************************************************************
      /END-FREE
