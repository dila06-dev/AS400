     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE MC-Routine für Datei ZOTE
      //*************************************************************************
      //  Copyright 2026 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: ZG 14.01.2026 Case #05780597
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Dieses Programm dient zur Matchcode-Anzeige der Datei ZOTE.
      //  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
      //  rufende Programm.
      //  Die Parameter werden in dem Feld #CKOMM übergeben.
      //
      //  KOM(01) = KYZOTETENR Identnummer
      //  KOM(16) = KYZOTEIMEX Import/Export

      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FMCZOTEFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCZOTER1:RCDNBR)
     F                                     SFILE(DLZOTER1:WKRCNO)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ

     D SFLZOTE         S                   LIKE(KYZOTE) DIM(999)
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

     D ZOTE          E DS
     D KYZOTE        E DS                  INZ
     D UXZOTE        E DS                  INZ

     D ZOTN          E DS
     D KYZOTN        E DS                  INZ

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
     D SFZOTEIMEX      S             40
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
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPAGE          S                   LIKE(PAGNBR)
     D W$PAGE          S                   LIKE(PAGNBR)
     D WKRENO          S                   LIKE(RCDNBR)
     D W$RCNO          S                   LIKE(RCDNBR)
     D WKZOTE          S                   LIKE(KYZOTE)
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
     D WKTRPAZOTN      S              1

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRZOTE
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_TRZOTE...
     D                 PR                  EXTPGM('TRZOTE')
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

      //--------------------------------------------------
      // Program name: C_TRZOTN
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRZOTN...
     D                 PR                  EXTPGM('TRZOTN')
     D  #EXTR02                            LIKEDS(EXTR02)

      //*************************************************************************
      //**  Programmstart                                                     ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    ZOTE

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
       EXSR KEYZOTE;
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
           OPEN MCZOTEFM;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZAUSW = 'MCZOTE';
             EXTRDZFUKT = 'MCZOTEB1';
             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDZFUKT = 'MCZOTEB2';
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
         CLEAR ZOTE;
       ENDIF;

       IF WKIOKZ = *ON
         AND WKIWND = *ON;
         CLOSE MCZOTEFM;
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
         KYTEFI = DAFIRM;      // TEIL
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYZOTEFIRM = DAFIRM;  // ZOTE

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         // Benutzersprache in allen Keystrukturen setzen
         EXTEXTSPCD = DAUSSP;  // TEXT

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'MCZOTE';
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

         SFLZOTE = *BLANK;
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

         EXFLPOFMTN = 'MCZOTEFM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme KOM-Bereich                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

         IF #CPGST <> WKPGST;
           SFLZOTE = *BLANK;
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
         DSZOTETENR = %SUBST(#CKOMM:01);
         DSZOTEIMEX = %SUBST(#CKOMM:16);

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
           OR DSZOTETENR <> *BLANK
           OR DSZOTEIMEX <> *BLANK;
           WKIFMT = '01';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Keybestückung ZOTE                                                ***
       //*************************************************************************
       BEGSR KEYZOTE;

         KYZOTETENR = DSZOTETENR;
         KYZOTEIMEX = DSZOTEIMEX;
         KYZOTEZOTN = DSZOTEZOTN;

         // Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
         // Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.

         WKSTMT =
           'SELECT * FROM ZOTE '  +
           'WHERE ZOTEFIRM = ''' + DAFIRM + '''';

         IF DSZOTETENR <> *BLANK;
           IF %SCAN(WCTRD:DSZOTETENR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND ZOTETENR = ''' + DSZOTETENR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(ZOTETENR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSZOTETENR)) + '''';
           ENDIF;
         ENDIF;

         IF DSZOTEIMEX <> *BLANK;
           IF %SCAN(WCTRD:DSZOTEIMEX) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND ZOTEIMEX = ''' + DSZOTEIMEX + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(ZOTEIMEX) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSZOTEIMEX)) + '''';
           ENDIF;
         ENDIF;

         IF DSZOTEZOTN <> *BLANK;
           IF %SCAN(WCTRD:DSZOTEZOTN) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND ZOTEZOTN = ''' + DSZOTEZOTN + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(ZOTEZOTN) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSZOTEZOTN)) + '''';
           ENDIF;
         ENDIF;

         WKSTMT = %TRIM(WKSTMT) +
           ' ORDER BY ZOTEFIRM, ZOTETENR, ZOTEIMEX, ZOTEGADA DESC';

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
           WRITE MCZOTECL;
           IF RCDNRTRDZ > *ZERO;
             WRITE SFTRDZK1;
           ENDIF;
           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;
           WRITE MCZOTE01;
           WRITE MCZOTEK1;
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
             WRITE MCZOTEB2;
           WHEN WKBT24 = *OFF;
             FUKT06 = *ON;
             //FUKT20 = *ON;
             //FUKT24 = *ON;
             WRITE MCZOTEB1;
           WHEN WKBT24 = *ON;
             FUKT06 = *ON;
             FUKT20 = *ON;
             FUKT24 = *ON;
             WRITE MCZOTEB3;
           ENDSL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) MCZOTEK1;
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
             SFLZOTE = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#NEWR = *ON AND FUKT06 = *ON;
             SFLZOTE = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = *BLANK;
             IF %SCAN(WCTRD:DSZOTETENR) = *ZERO;
               KYZOTETENR = DSZOTETENR;
             ELSE;
               KYZOTETENR = *BLANK;
             ENDIF;
             KYZOTEIMEX = *BLANK;
             KYZOTEGADA = *ZERO;
             EXSR TRZOTE;
             LEAVE;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#BACK = *ON AND FUKT10 = *ON;
             KYZOTETENR = DSZOTETENR;
             KYZOTEIMEX = DSZOTEIMEX;
             KYZOTEGADA = *ZERO;
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
             SFLZOTE = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#MUST = *ON AND FUKT20 = *ON;
             SFLZOTE = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = 'MUSTER';
             KYZOTETENR = *BLANK;
             KYZOTEIMEX = *BLANK;
             KYZOTEGADA = *ZERO;
             EXSR TRZOTE;
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
             KYZOTETENR = DSZOTETENR;
             KYZOTEIMEX = DSZOTEIMEX;
             KYZOTEGADA = *ZERO;
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
         WRITE MCZOTEK1;

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
             EXSR ZOTEKY;
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
           CHAIN RCDNBR MCZOTER1;
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

           UPDATE MCZOTER1;
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
         WKZOTE = KYZOTE;
         SFLZOTE = *BLANK;
         SFLAUSW = *BLANK;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           CLEAR KYZOTE;
           KYZOTEFIRM = DAFIRM;
           READC MCZOTER1;

           // Kein geänderter Satz mehr vorhanden, Format schliessen
           IF %EOF;
             PCPGST = 'ENDE  ';
             EXSR TRZOTE;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE MCZOTER1;
           C#NEXT = *OFF;

           I2 += 1;
           SFLZOTE(I2) = KYZOTE;
           SFLAUSW(I2) = SFAUSW;
         ENDDO;

         KYZOTE = WKZOTE;

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

           READC MCZOTER1;

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
           UPDATE MCZOTER1;
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

             WKZOTE = KYZOTE;

             IF WKIDEL = *OFF;

               WKIFMT = 'DL';
               EXSR BILDDL;
               KYZOTE = WKZOTE;
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
             EXSR TRZOTE;

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
             EXSR TRZOTE;

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

           CHAIN RCDNBR MCZOTER1;
           *IN97 = NOT %FOUND;
           SFAUSW = *BLANK;
           UPDATE MCZOTER1;
           EXSR LAUSW;

           SELECT;

           WHEN PCPGST = '1     ';
             LEAVE;

           WHEN PCPGST = '3     ';
             IF %SUBST(RTTRNDKEYB:11:04) <> *BLANK; // ZOTEIMEX
               PCPGST = '2     ';
               KYZOTETENR = %SUBST(RTTRNDKEYB:01:16);
               KYZOTEIMEX = %SUBST(RTTRNDKEYB:16:01);
               KYZOTEGADA = %INT(%SUBST(RTTRNDKEYB:17:08));
               EXSR TRZOTE;
             ENDIF;

           ENDSL;

         ENDDO;

         IF WKFENR <> *ZERO
           AND RCDNBR > *ZERO;

           CHAIN RCDNBR MCZOTER1;
           *IN97 = NOT %FOUND;
           C_AUSW = *ON;
           C#NEXT = *ON;
           UPDATE MCZOTER1;
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
         EXSR CHZOTE;

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

           WRITE MCZOTE01;
           WRITE DLZOTEK1;
           EXSR OFFUKT;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;
           WRITE MCZOTEDL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) DLZOTEK1;
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
         WRITE DLZOTEK1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;

         RCDNBR = 1;
         WKRCNO = *ZERO;

         DOU *INLR = *ON;

           IF SFAUSW = '4 '
             OR SFAUSW = ' 4';
             WKRCNO += 1;
             WRITE DLZOTER1;
             EXSR UXDLWRTE;
           ENDIF;

           READC MCZOTER1;
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
           UPDATE MCZOTER1;
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
           CHAIN WKRCNO DLZOTER1;

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

           UPDATE DLZOTER1;
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
           WRITE MCZOTEW1;
           WRITE MCZOTEM1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           WRITE W1ZOTEB1;
           WKIWND = *ON;

           SELECT;
           WHEN WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDSL;

           C#WNDW = *OFF;

           READ(E) MCZOTEM1;
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

           EXSR KEYZOTE;

           SFLZOTE = *BLANK;
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

         EXFLPOFLDN = 'DSZOTETENR';
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für BILDM1                                          ***
       //*************************************************************************
       BEGSR BM1PR;

         WKFENR = *ZERO;

         EXSR PRZOTETENR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRZOTEIMEX;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRZOTEZOTN;
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
           EXFLPOFLDN = 'DSZOTETENR';

         WHEN FLDNAM = 'DSZOTETENR';
           EXSR MCZOTETENR;

         WHEN FLDNAM = 'DSZOTEIMEX';
           EXSR MCZOTEIMEX;

         WHEN FLDNAM = 'DSZOTEZOTN';
           EXSR MCZOTEZOTN;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCZOTETENR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSZOTETENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTETENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune TENR                                                   ***
       //*************************************************************************
       BEGSR PRZOTETENR;

         EXFLPOFLDN = 'DSZOTETENR';

         IF DSZOTETENR <> *BLANK AND %SCAN(WCTRD:DSZOTETENR) = *ZERO;
           KYTENR = DSZOTETENR;
           CHIDS = '01C';
           EXSR CHTEIL;

           IF WKFENR = *ZERO
             OR %SCAN(WCTRD:DSZOTETENR) <> *ZERO;  // "*"-FUNKTION
             DSZOTETENR = TETENR;
             WKFENR = '0000';
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine IMEX                                                   ***
       //*************************************************************************
       BEGSR MCZOTEIMEX;

         C#WNDW = *ON;

         IF DSZOTEIMEX = *BLANK;
           TXZOTEIMEX = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$ZOTEIMEX';
         %SUBST(KOMDS:12) = DSZOTEIMEX;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTEIMEX = TPTCDE;
           TXZOTEIMEX = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune IMEX                                                   ***
       //*************************************************************************
       BEGSR PRZOTEIMEX;

         EXFLPOFLDN = 'DSZOTEIMEX';
         TXZOTEIMEX = *BLANK;

         IF DSZOTEIMEX <> *BLANK AND %SCAN(WCTRD:DSZOTEIMEX) = *ZERO;
           KYTPTA = '$$ZOTEIMEX';
           KYTPTC = DSZOTEIMEX;
           CHIDS  = '01C';
           EXSR CHTRTP;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
           TXZOTEIMEX = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine ZOTE                                                   ***
       //*************************************************************************
       BEGSR MCZOTEZOTN;

         C#WNDW = *ON;
         EXFLPOFLDN = 'SFAUSW';

         %SUBST(KOMDS:01) = DSZOTEZOTN;
         #CPGST = 'ZOTN01';
         #CUEBE = '0010';
         EXSR MCZOTN;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTEZOTN = ZOTNZOTN;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune ZOTN                                                   ***
       //*************************************************************************
       BEGSR PRZOTEZOTN;

         EXFLPOFLDN = 'DSZOTEZOTN';

         IF DSZOTEZOTN <> *BLANK AND %SCAN(WCTRD:DSZOTEZOTN) = *ZERO
           AND WKTRPAZOTN = *ON;
           %SUBST(KOMDS:01) = DSZOTEZOTN;
           #CKOMM = KOMDS;
           #CPGST = 'ERMFLD';
           C_TRZOTN(EXTR02);
           KOMDS = #CKOMM;

           IF DSZOTEZOTN <> %SUBST(KOMDS:01:15);
             WKFENR = '0031';
             LEAVESR;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Blaetterroutine                                                   ***
       //*************************************************************************
       BEGSR BLAET;

         SELECT;
         WHEN WKMCKZ = 'KY';
           EXSR ZOTEKY;
         ENDSL;

         WRITE MCZOTELO;
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
           EXSR CCZOTEKY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  open cursor                                                       ***
       //*************************************************************************
       BEGSR OCURSOR;

         IF WKMCKZ = 'KY'
           AND WKOPENKY <> *ON;
           EXSR OCZOTEKY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Öffenen cursor ZOTEKY                                             ***
       //*************************************************************************
       BEGSR OCZOTEKY;

         WKOPENKY = *ON;

         EXEC SQL PREPARE SQZOTE FROM :WKSTMT;

         EXEC SQL DECLARE ZOTEKY SCROLL CURSOR FOR SQZOTE;

         EXEC SQL OPEN ZOTEKY;

       ENDSR;

       //*************************************************************************
       //**  Anzeigen Datei ZOTE                                               ***
       //*************************************************************************
       BEGSR ZOTEKY;

         SFAUSW = *BLANK;
         C#NDSP = *OFF;
         WKILER = *OFF;
         W$PAGE = 10;
         I0 = 1;

         IF C#PGUP = *ON;
           EXEC SQL
           FETCH CURRENT FROM ZOTEKY INTO :ZOTE;
           RCDNBR = WKRENO;
         ELSE;
           EXEC SQL
           FETCH NEXT FROM ZOTEKY INTO :ZOTE;
         ENDIF;

         DOW I0 <=(W$PAGE+1);

           IF (SQLCOD < 0 OR
             SQLCOD >= 100) OR
             RCDNBR = 9999;
             C#MORE = *ON;      // SFLEND-KENNZ.
             LEAVE;
           ENDIF;

           IF I0 <= W$PAGE;
             KYZOTETENR = ZOTETENR;
             KYZOTEIMEX = ZOTEIMEX;
             KYZOTEGADA = ZOTEGADA;

             RCDNBR += 1;

             EXSR ADUMM;

             EXSR ERSIC;

             EXSR FAUSW;
             EXSR FKONS;

             WRITE MCZOTER1;
             EXSR UXMCWRTE;

             EXEC SQL
             FETCH NEXT FROM ZOTEKY INTO :ZOTE;
           ENDIF;

           I0 += 1;
         ENDDO;

         EXSR ERPAGE;

       ENDSR;

       //*************************************************************************
       //**  close cursor Datei ZOTEKY                                         ***
       //*************************************************************************
       BEGSR CCZOTEKY;

         WKOPENKY = *OFF;

         EXEC SQL CLOSE ZOTEKY;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten für Anzeigen                                          ***
       //*************************************************************************
       BEGSR ADUMM;

         // Ermitteln Daten aus dem Ident-Stamm
         KYTENR = ZOTETENR;
         CHIDS = '01C';
         exsr CHTEIL;

         KYTPTA = '$$ZOTEIMEX';
         KYTPTC = ZOTEIMEX;
         CHIDS  = '01C';
         EXSR CHTRTP;
         SFZOTEIMEX = TPTTXT;

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

         I1 = %LOOKUP(KYZOTE:SFLZOTE:I1);
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

         I1 = %LOOKUP(KYZOTE:SFLZOTE:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           SFLAUSW(I1) = *BLANK;
           SFLZOTE(I1) = *BLANK;
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

           WRITE MCZOTER1;
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
       //**  Update DateI ZOTE                                                 ***
       //*************************************************************************
       BEGSR TRZOTE;

         CLEAR EXTREND;
         EXTRNDPGST = PCPGST;
         %SUBST(EXTRNDKEYB:01:15) = KYZOTETENR;
         %SUBST(EXTRNDKEYB:16:01) = KYZOTEIMEX;
         %SUBST(EXTRNDKEYB:17:08) = %editc(KYZOTEGADA:'X');
         C_TRZOTE(EXTREND:RTTREND);

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

         EXSBFLPROG = 'MCZOTE';
         EXSBFLFMTN = 'MCZOTEFM';
         EXSBFLPGST = WKSBFLPGST;
         EXSBFLISIC = WKSBFLISIC;

         EXSBFLFIL1 = 'ZOTE';
         EXSBFLDAT1 = ZOTE;

         EXSBFLFIL2 = 'TEIL';
         EXSBFLDAT2 = TEIL;

         EXSBFLAF01 = 'TXZOTEIMEX';
         EXSBFLAL01 = SFZOTEIMEX;

         EXSR TRSBFL;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Firmen-Parameter                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'TRTEIL';
         KYTATC = 'ZOTN';
         KYTAPA = 'ZOTN';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAZOTN = TAPCDE;
         IF WKTRPAZOTN <> *ON;
           WKTRPAZOTN = *OFF;
         ENDIF;

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

           EXTRDNPGNA = 'MCZOTE';
           EXTRDNPGST = 'AUFRUF';

           IF SFAUSW = *BLANK;                                                    // F10=OPTIONEN
             EXTRDNPGNA = 'MCZOTEB1';

             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDNPGNA = 'MCZOTEB2';
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

           WHEN EXTRDNDANA = 'XXXX';

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
         EXSR CHZOTE;

         CHAIN RCDNBR MCZOTER1;
         *IN97 = NOT %FOUND;

         KYZOTETENR = ZOTETENR;
         KYZOTEIMEX = ZOTEIMEX;
         KYZOTEGADA = ZOTEGADA;

         C#NDSP = *OFF;

         EXSR ADUMM;

         EXSR ERSIC;

         EXSR FAUSW;
         EXSR FKONS;

         // als geändert markiert lassen
         C#NEXT = *ON;
         UPDATE MCZOTER1;
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
         EXUXMCINAM = 'MCSBFZOTE';
         EXUXMCILIB = 'QTEMP';
         EXUXMCIATR = 'TREND';
         EXUXMCDTLG = 4 + 996;
         EXUXMCKYLG = 4;
         EXUXMCITXT = 'Subfile MCZOTE';

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
         UXZOTEFIRM  = KYZOTEFIRM;
         UXZOTETENR  = KYZOTETENR;
         UXZOTEIMEX  = KYZOTEIMEX;
         UXZOTEGADA  = KYZOTEGADA;
         EXUXMCIDTA  = EXUXSICHT + UXZOTE;
         EXUXMCIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXMCREAD;

         CLEAR KYZOTE;

         DUN040 = RCDNBR;
         EXUXMCIKEY  = DUC004;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXMCIDTA;
         DUN030      = %LEN(UXZOTE);
         UXZOTE      = %SUBST(EXUXMCIDTA:765:DUN030);
         KYZOTEFIRM  = UXZOTEFIRM;
         KYZOTETENR  = UXZOTETENR;
         KYZOTEIMEX  = UXZOTEIMEX;
         KYZOTEGADA  = UXZOTEGADA;

       ENDSR;

       //*************************************************************************
       //**  Löschen   Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCRMKY;

         DUN040 = RCDNBR;

         EXUXMCIKEY = DUC004;
         EXUXRCNR     = RCDNBR;
         UXZOTEFIRM  = KYZOTEFIRM;
         UXZOTETENR  = KYZOTETENR;
         UXZOTEIMEX  = KYZOTEIMEX;
         UXZOTEGADA  = KYZOTEGADA;
         EXUXMCIDTA = EXUXSICHT + UXZOTE;
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
         EXUXDLINAM  = 'DLSBFZOTE';
         EXUXDLILIB  = 'QTEMP';
         EXUXDLIATR  = 'TREND';
         EXUXDLDTLG  = 4 + 996;
         EXUXDLKYLG  = 4;
         EXUXDLITXT  = 'Subfile DLZOTE';

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
         UXZOTEFIRM  = KYZOTEFIRM;
         UXZOTETENR  = KYZOTETENR;
         UXZOTEIMEX  = KYZOTEIMEX;
         UXZOTEGADA  = KYZOTEGADA;
         EXUXDLIDTA  = EXUXSICHT + UXZOTE;
         EXUXDLIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXDLREAD;

         CLEAR KYZOTE;

         DUN040 = WKRCNO;
         EXUXDLIKEY  = DUC004;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXDLIDTA;
         DUN030      = %LEN(UXZOTE);
         UXZOTE      = %SUBST(EXUXDLIDTA:765:DUN030);
         KYZOTEFIRM  = UXZOTEFIRM;
         KYZOTETENR  = UXZOTETENR;
         KYZOTEIMEX  = UXZOTEIMEX;
         KYZOTEGADA  = UXZOTEGADA;

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

         PGMNAM = 'MCZOTE';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTZOTEW1;
         OTHER;
           WRITE MCZOTECT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTZOTEW1;
         OTHER;
           WRITE MCZOTECT;
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
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHZOTE
      /COPY QCPYSRC,ERSBFL
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,MCZOTN
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
