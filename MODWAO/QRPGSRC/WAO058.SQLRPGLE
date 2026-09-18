     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
      //*************************************************************************
      /TITLE MC-Routine für Datei DIST
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 13.03.2015 DOMETIC Projekt 10777
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm dient zur Matchcode-Anzeige der Datei DIST.
      //  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
      //  rufende Programm.
      //  Die Parameter werden in dem Feld #CKOMM übergeben.
      //
      //  KOM(01) = KYITTE     Ident-Nr

      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FWAO058FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(WAO058R1:RCDNBR)
     F                                     SFILE(DLW058R1:WKRCNO)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ

     D SFLDIST         S                   LIKE(KYDIST) DIM(999)
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
     D BBEK          E DS                  INZ
     D KYBBEK        E DS                  INZ

     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ

     D BBEU          E DS                  INZ
     D KYBBEU        E DS                  INZ

     D DIST          E DS                  INZ
     D KYDIST        E DS                  INZ
     D UXDIST        E DS                  INZ

     D LBBS          E DS                  INZ

     D LBLB          E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D TRDZ          E DS                  INZ
     D KYTRDZ        E DS                  INZ
     D UXTRDZ        E DS                  INZ

     D TRDN          E DS                  INZ
     D KYTRDN        E DS                  INZ

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

     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ

     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ

     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  Work-Datenstruktur für Kopier-Funktion                            ***
      //*************************************************************************
     D D$DAST          DS          2048    INZ
     D KYSAVE          DS          1024    INZ

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
     D SFDISTBEGR      S             40    INZ
     D SFDISTBGNR      S             10    INZ
     D SFBBEUAFNR      S             11    INZ
     D WKSUPD          S              1
     D WKIDEL          S              1
     D WKTRDZZYKL      S              1
     D TXKEIN          S             76
     D WKSTMT          S           1000
     D WKTRPADART      S              2    INZ
     D WKTRPAPLBD      S              1    INZ
     D WKTRPASIBE      S              1    INZ
     D WKTRPAVFBD      S              1    INZ
     D WKRBKZ          S              2    INZ
     D WKKOKZ          S              1    INZ
     D WKWTKZ          S              1    INZ
     D WKBVKZ          S              1    INZ
     D WKAZBG          S              3    INZ
     D WKZOKZ          S              1    INZ
     D WKZRKZ          S              1    INZ
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
     D WKDIST          S                   LIKE(KYDIST)
     D WKUXMCPARM      S                   LIKE(EXUXMCPARM)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKDIMGBSKZ      S                   INZ LIKE(DAJNKZ)
     D WKABZ1          S                   INZ LIKE(TETBZ1)
     D WKABZ2          S                   INZ LIKE(TETBZ1)
     D WKOFMG          S             11S 2 INZ
     D WKMENG          S             11S 2 INZ
     D WKRSMG          S             11S 2 INZ
     D WKKOMB          S             11S 2 INZ
     D WKAUST          S              2S 0 INZ
     D DSRESS          S                   INZ LIKE(DUN112)
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
      // Program name: C_TRDIMG
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #DIST
      //--------------------------------------------------
     D C_TRDIMG...
     D                 PR                  EXTPGM('TRDIMG')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #DIST                              LIKEDS(DIST)

      //--------------------------------------------------
      // Program name: C_TRLBB2
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #EXLBB2
      // Parameter:      #RTLBB2
      //--------------------------------------------------
     D C_TRLBB2...
     D                 PR                  EXTPGM('TRLBB2')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #EXLBB2                            LIKEDS(EXLBB2)
     D  #RTLBB2                            LIKEDS(RTLBB2)

      //--------------------------------------------------
      // Program name: C_TXDIST
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TXDIST...
     D                 PR                  EXTPGM('TXDIST')
     D  #EXTR02                            LIKEDS(EXTR02)

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
      // Program name: C_WAO00Y
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_WAO00Y...
     D                 PR                  EXTPGM('WAO00Y')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

      //*************************************************************************
      //**  Programmstart                                                     ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C**                 PARM                    DIST

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
       EXSR KEYDIST;
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
           OPEN WAO058FM;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZAUSW = 'WAO058';
             EXTRDZFUKT = 'WAO058B1';
             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDZFUKT = 'WAO058B2';
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
         CLEAR DIST;
       ENDIF;

       IF WKIOKZ = *ON
         AND WKIWND = *ON;
         CLOSE WAO058FM;
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
         KYEKFI = DAFIRM;      // BBEK
         KYEPFI = DAFIRM;      // BBEP
         KYEUFI = DAFIRM;      // BBEU
         KYITFI = DAFIRM;      // DIST
         KYTEFI = DAFIRM;      // TEIL
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         // Benutzersprache in allen Keystrukturen setzen
         EXTEXTSPCD = DAUSSP;  // TEXT

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;
         %SUBST(W99DS:01) = EXFIRMKNAM;
         %SUBST(W99DS:31) = *BLANK;

         EXTRDNDANA = 'WAO058';
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

         SFLDIST = *BLANK;
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

         EXFLPOFMTN = 'WAO058FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme KOM-Bereich                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

         IF #CPGST <> WKPGST;
           SFLDIST = *BLANK;
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
         DSTENR  = %SUBST(#CKOMM:01);

         // Optionszeile setzen
         IF #CUEBE = *BLANK;

           IF WKPGST = '5     '  // Anzeigemodus
             OR WKPGST = 'DETAIL';
             #CUEBE = '0557';    // 5=Detail  10=Optionen
           ELSE;
             #CUEBE = '0557';
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
           OR  DSTENR <> *BLANK;
           WKIFMT = '01';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Keybestückung DIST                                                ***
       //*************************************************************************
       BEGSR KEYDIST;

         KYITTE = DSTENR;

         // Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
         // Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.

         WKSTMT =
           'SELECT * FROM DIST '  +
           'WHERE ITFIRM = ''' + DAFIRM + '''';

         IF DSTENR <> *BLANK;
           IF %SCAN(WCTRD:DSTENR) = *ZERO;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND ITTENR = ''' + DSTENR + '''';
           ELSE;
             WKSTMT = %TRIM(WKSTMT) +
             ' AND TRIM(ITTENR) LIKE ''' +
             %TRIMR(%XLATE(WCTRD:WCSQL:DSTENR)) + '''';
           ENDIF;
         ENDIF;

         WKSTMT = %TRIM(WKSTMT) +
           ' AND ITBEGR IN (''040'', ''041'', ''043'')';

         WKSTMT = %TRIM(WKSTMT) +
           ' ORDER BY ITFIRM, ITTENR, ITRSDA, ITRSZT, ITBEGR DESC, ITBGJJ,'
           + ' ITBGNR, ITBPOS, ITUPOS ';

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
           WRITE WAO058CL;
           IF RCDNRTRDZ > *ZERO;
             WRITE SFTRDZK1;
           ENDIF;
           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;
           WRITE WAO05801;
           WRITE WAO058K1;
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
             WRITE WAO058B2;
           WHEN WKBT24 = *OFF;
             //FUKT06 = *ON;
             //FUKT20 = *ON;
             //FUKT24 = *ON;
             WRITE WAO058B1;
           WHEN WKBT24 = *ON;
             FUKT06 = *ON;
             FUKT20 = *ON;
             FUKT24 = *ON;
             WRITE WAO058B3;
           ENDSL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) WAO058K1;
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
             SFLDIST = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#NEWR = *ON
             AND FUKT06 = *ON;
             SFLDIST = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = *BLANK;
             //CLEAR DIST;
             //EXSR TXDIST;
             LEAVE;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#BACK = *ON
             AND FUKT10 = *ON;
             KYITTE = DSTENR;
             ITTENR = DSTENR;
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
             SFLDIST = *BLANK;
             SFLAUSW = *BLANK;
             LEAVE;

           WHEN C#INFO = *ON
             AND FUKT13 = *ON;
             EXSR VINFO;
             ITER;

           WHEN C#MUST = *ON
             AND FUKT20 = *ON;
             SFLDIST = *BLANK;
             SFLAUSW = *BLANK;
             PCPGST = 'MUSTER';
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
             KYITTE = DSTENR;
             ITTENR = DSTENR;
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
         WRITE WAO058K1;

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
             EXSR DISTKY;
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
           CHAIN RCDNBR WAO058R1;
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

           UPDATE WAO058R1;
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
         WKDIST = KYDIST;
         SFLDIST = *BLANK;
         SFLAUSW = *BLANK;

         DOU *INLR = *ON;

           IF RCDNBR = *ZERO;
             WKFENR = '0031';
             LEAVE;
           ENDIF;

           CLEAR KYDIST;
           KYITFI = DAFIRM;
           READC WAO058R1;

           // Kein geänderter Satz mehr vorhanden, Format schliessen
           IF %EOF;
             PCPGST = 'ENDE  ';
             EXSR TRDIST;
             LEAVE;
           ENDIF;

           EXSR UXMCREAD;

           IF EXUXMCRTCD <> *ZERO;
             ITER;
           ENDIF;

           C#NEXT = *ON;
           UPDATE WAO058R1;
           C#NEXT = *OFF;

           I2 += 1;
           SFLDIST(I2) = KYDIST;
           SFLAUSW(I2) = SFAUSW;
         ENDDO;

         KYDIST = WKDIST;

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

           READC WAO058R1;

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
           UPDATE WAO058R1;
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

             WKDIST = KYDIST;

             IF WKIDEL = *OFF;

               WKIFMT = 'DL';
               EXSR BILDDL;
               KYDIST = WKDIST;
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
             //EXSR TRDIST;

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
             EXSR TRDIST;

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

           CHAIN RCDNBR WAO058R1;
           *IN97 = NOT %FOUND;
           SFAUSW = *BLANK;
           UPDATE WAO058R1;
           EXSR LAUSW;

           SELECT;

           WHEN PCPGST = '1     ';
             LEAVE;

           WHEN PCPGST = '3     ';
             PCPGST = '2     ';
             EXSR TRDIST;

           ENDSL;

         ENDDO;

         IF WKFENR <> *ZERO
           AND RCDNBR > *ZERO;

           CHAIN RCDNBR WAO058R1;
           *IN97 = NOT %FOUND;
           C_AUSW = *ON;
           C#NEXT = *ON;
           UPDATE WAO058R1;
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
         EXSR CHDIST;

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

           WRITE WAO05801;
           WRITE DLW058K1;
           EXSR OFFUKT;
           FUKT11 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           FUKT26 = *ON;
           WRITE WAO058DL;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           READ(E) DLW058K1;
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
         WRITE DLW058K1;

         C#INIT = *OFF;
         C#MORE = *OFF;
         C#NEXT = *OFF;

         RCDNBR = 1;
         WKRCNO = *ZERO;

         DOU *INLR = *ON;

           IF SFAUSW = '4 '
             OR SFAUSW = ' 4';
             WKRCNO += 1;
             WRITE DLW058R1;
             EXSR UXDLWRTE;
           ENDIF;

           READC WAO058R1;
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
           UPDATE WAO058R1;
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
           CHAIN WKRCNO DLW058R1;

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

           UPDATE DLW058R1;
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
           WRITE WAO058W1;
           WRITE WAO058M1;
           EXSR OFFUKT;
           FUKT03 = *ON;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;
           WRITE W1W058B1;
           WKIWND = *ON;

           SELECT;
           WHEN WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDSL;

           C#WNDW = *OFF;

           READ(E) WAO058M1;
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

           EXSR KEYDIST;

           SFLDIST = *BLANK;
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

         EXFLPOFLDN = 'DSTENR';
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für BILDM1                                          ***
       //*************************************************************************
       BEGSR BM1PR;

         WKFENR = *ZERO;

         EXSR PRTENR;
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
           EXFLPOFLDN = 'DSTENR';

         WHEN FLDNAM = 'DSTENR';
           EXSR MCAUFRTENR;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCAUFRTENR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSTENR;
         #CUEBE = '0526';
         #CPGST = *BLANK;
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSTENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRTENR;

         EXFLPOFLDN = 'DSTENR';
         DSTBZ1 = *BLANK;
         DSTBZ2 = *BLANK;
         DSERTE = *BLANK;
         DSALTE = *BLANK;
         TXALTE = *BLANK;
         DSPRGR = *BLANK;
         DSLAGB = *ZERO;
         DSRESN = *ZERO;
         DSWEMG = *ZERO;
         DSEZPR = *ZERO;
         DSSIBE = *ZERO;
         DSBESN = *ZERO;
         DSUNTW = *ZERO;
         DSTART = *BLANK;
         TXTART = *BLANK;
         DSMEIN = *BLANK;
         TXMEIN = *BLANK;
         DSTEST = *BLANK;
         TXTEST = *BLANK;
         DSSOLI = *ZERO;
         DSABC1 = *BLANK;
         TXABC1 = *BLANK;
         DSSPER = *ZERO;
         DSRESL = *ZERO;
         DSVBSB = *ZERO;

         KYTENR = DSTENR;
         KYTEEZ = *BLANK;
         CHIDS = '01C';
         EXSR CHTEIL;

         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         DSTENR = TETENR;
         DSTBZ1 = TETBZ1;
         DSTBZ2 = TETBZ2;
         DSERTE = TEERTE;

         D$DAST = TEIL;
         KYSAVE = KYTEIL;
         KYTEET = DSTENR;
         KYTENR = *BLANK;
         CHIDS = '06+';
         EXSR CHTEIL;
         IF CHI(5) = 'J'
           AND TEFIRM = KYTEFI
           AND TEERTE = KYTEET;
           DSALTE = TETENR;
           TXALTE = TETBZ1;
         ENDIF;
         TEIL = D$DAST;
         KYTEIL = KYSAVE;

         DSPRGR = TEPRGR;

         DSTART = TETART;
         KYTPTA = 'TART';
         KYTPTC = DSTART;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXTART = TPTTXT;

         DSMEIN = TEMEIN;
         KYTPTA = 'MEIN';
         KYTPTC = TEMEIN;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXMEIN = TPTTXT;

         DSTEST = TETEST;
         KYTPTA = 'TEST';
         KYTPTC = DSTEST;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXTEST = TPTTXT;

         DSABC1 = TEABC1;
         KYTPTA = 'TEILABC1';
         KYTPTC = DSABC1;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXABC1 = TPTTXT;

         EXSR TRLBB2;

         EXSR WAO00Y;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  TRLBB2  ERMITTELN VERFÜGBARER LAGERBESTAND                        ***
       //*************************************************************************
       BEGSR TRLBB2;

         DSLAGB = *ZERO;                                                        // LAGERBESTAND
         DSSIBE = *ZERO;                                                        // SICHERHEITSBESTAN
         DSRESL = *ZERO;                                                        // LAGERRESERVERIERU
         DSRESN = *ZERO;                                                        // BEDARF
         DSRESS = *ZERO;                                                        // SONDERBEDARF
         DSBESN = *ZERO;                                                        // BESTELLBESTAND
         DSVBSB = *ZERO;                                                        // VERFÜGBARER BSTD.

         CLEAR EXLBB2;
         CLEAR RTLBB2;
         #CKOMM = *BLANK;
         %SUBST(#CKOMM:001:01) = *ON;                                           // PRÜFUNG-KZ
         %SUBST(#CKOMM:002:01) = *ON;                                           // ERM.LAGERBESTAND
         IF WKTRPADART = '02'
           OR WKTRPADART = '03';
           %SUBST(#CKOMM:003:01) = *ON;                                         // ERM.LAGERRESERV.
         ELSE;
           %SUBST(#CKOMM:003:01) = *OFF;
         ENDIF;

         %SUBST(#CKOMM:004:01) = *ON;                                           // ERM.DIST RESERV.
         %SUBST(#CKOMM:005:01) = *OFF;                                          // BEDARFSPLAN-LAGER
         %SUBST(#CKOMM:006) = *BLANK;
         %SUBST(#CKOMM:007:01) = *ON;                                           // LAGERPLATZSPERRUN
         %SUBST(#CKOMM:009:01) = *OFF;                                          // NUR ABFÜLLBESTAND
         %SUBST(#CKOMM:010) = DSTENR;
         %SUBST(#CKOMM:215:01)= *ON;                                            // QUALITÄTSTYP PRÜF
         #CPGST = *BLANK;

         EXLBB2VPKZ = 'V';

         C_TRLBB2(EXTR02:EXLBB2:RTLBB2);

          DUC013 = %SUBST(#CKOMM:01);
          DSLAGB = %DEC(DUN134:11:2);

          DUC013 = %SUBST(#CKOMM:14); // Sicherheitsbestand
          DSSIBE = %DEC(DUN134:11:2);

          DUC013 = %SUBST(#CKOMM:40); // Bedarf
          DSRESN = %DEC(DUN134:11:2);

          DUC013 = %SUBST(#CKOMM:53); // Sonderbedarf
          DSRESS = %DEC(DUN134:11:2);

          DUC013 = %SUBST(#CKOMM:66); // Bestellbestand
          DSBESN = %DEC(DUN134:11:2);

          DUC013 = %SUBST(#CKOMM:92); // Reservierter Bestand
          DSRESL = %DEC(DUN134:11:2);

          IF WKTRPAPLBD = *ON;
            DUC007 = %SUBST(#CKOMM:213); // Planbedarf
            DSRESN += DUN071;
          ENDIF;

          IF WKTRPASIBE = *OFF;       // DIST-SIBE-KENNZ.
            DSVBSB = DSLAGB - DSSIBE; // Verfügbarer Lager-Bestand
          ELSE;
            DSVBSB = DSLAGB;
          ENDIF;

          IF WKTRPADART = '02'
            OR WKTRPADART = '03';     // BERÜCKSICHTIGEN
            DSVBSB -= DSRESL;         // LAGERRESERVIERUNGEN
          ENDIF;

          IF WKTRPAVFBD = *ON;                 // Minus Bedarf
            DSVBSB = DSVBSB - DSRESN - DSRESS; // Verf.-Bestand
          ENDIF;

       ENDSR;

       //*************************************************************************
       //**  WAO00Y   WAECO                                                    ***
       //*************************************************************************
       BEGSR WAO00Y;

         DSUNTW = *ZERO;
         DSWEMG = *ZERO;
         DSSPER = *ZERO;
         DSEZPR = *ZERO;
         DSSOLI = *ZERO;

         CLEAR EXTREND;
         CLEAR RTTREND;
         %SUBST(EXTRNDKEYB:01) = DSTENR;
         %SUBST(EXTRNDKEYB:16:01) = 'V';
         CALLP(E) C_WAO00Y(EXTREND:RTTREND);
         *IN99 = %ERROR;

         DUC013 = %SUBST(RTTRNDDATE:016:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSUNTW = DUN134;

         DUC013 = %SUBST(RTTRNDDATE:029:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSWEMG = DUN134;

         DUC013 = %SUBST(RTTRNDDATE:042:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSSPER = DUN134;

         DUC011 = %SUBST(RTTRNDDATE:055:011);
         MONITOR;
           *IN(97) = *ON;
           DUN110 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC011 = '00000000000';
         ENDIF;
         EVAL(H) DSEZPR = DUN113;

         DUC013 = %SUBST(RTTRNDDATE:066:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSSOLI = DUN134;
         IF DSSOLI < *ZERO;
           DSSOLI = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine LBBS                                                   ***
       //*************************************************************************
       BEGSR MCAUFRLBBS;

         C#WNDW = *ON;
         EXFLPOFLDN = 'SFAUSW';

         KOMDS = *BLANK;
         %SUBST(KOMDS:04) = ITTENR;
         #CPGST = '5     ';
         #CUEBE = *BLANK;
         EXSR MCLBBS;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine LBLB                                                   ***
       //*************************************************************************
       BEGSR MCAUFRLBLB;

         C#WNDW = *ON;
         EXFLPOFLDN = 'SFAUSW';

         KOM = *BLANK;
         %SUBST(KOMDS:04) = ITTENR;
         #CUEBE = '0012';
         #CPGST = '5     ';
         EXSR MCLBLB;

       ENDSR;

       //*************************************************************************
       //**  Blaetterroutine                                                   ***
       //*************************************************************************
       BEGSR BLAET;

         SELECT;
         WHEN WKMCKZ = 'KY';
           EXSR DISTKY;
         ENDSL;

         WRITE WAO058LO;
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
           EXSR CCDISTKY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  open cursor                                                       ***
       //*************************************************************************
       BEGSR OCURSOR;

        IF WKMCKZ = 'KY'
          AND WKOPENKY <> *ON;

          EXSR OCDISTKY;

        ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Öffenen cursor DISTKY                                             ***
       //*************************************************************************
       BEGSR OCDISTKY;

         WKOPENKY = *ON;

         EXEC SQL PREPARE SQDIST FROM :WKSTMT;

         EXEC SQL DECLARE DISTKY SCROLL CURSOR FOR SQDIST;

         EXEC SQL OPEN DISTKY;

       ENDSR;

       //*************************************************************************
       //**  Anzeigen Datei DIST                                               ***
       //*************************************************************************
       BEGSR DISTKY;

         SFAUSW = *BLANK;
         C#NDSP = *OFF;
         WKILER = *OFF;
         W$PAGE = 03;
         I0 = 1;

         IF C#PGUP = *ON;
           EXEC SQL
           FETCH CURRENT FROM DISTKY INTO :DIST;
           RCDNBR = WKRENO;
         ELSE;
           EXEC SQL
           FETCH NEXT FROM DISTKY INTO :DIST;
         ENDIF;

         DOW I0 <=(W$PAGE+1);

           IF (SQLCOD < 0 OR
             SQLCOD >= 100) OR
             RCDNBR = 9999;
             C#MORE = *ON;      // SFLEND-KENNZ.
             LEAVE;
           ENDIF;

           #CPGST = 'ERMMGE';
           EXSR TRDIMG;

           IF WKMENG = *ZERO;
             EXEC SQL
             FETCH NEXT FROM DISTKY INTO :DIST;
             ITER;
           ENDIF;

           IF I0 <= W$PAGE;
             KYITBG = ITBEGR;
             KYITJH = ITBGJJ;
             KYITNR = ITBGNR;
             KYITPO = ITBPOS;
             KYITUP = ITUPOS;
             KYITTE = ITTENR;
             KYITRD = ITRSDA;
             KYITRZ = ITRSZT;

             RCDNBR += 1;

             EXSR ADUMM;

             EXSR ERSIC;

             EXSR FAUSW;
             EXSR FKONS;

             WRITE WAO058R1;
             EXSR UXMCWRTE;

             EXEC SQL
             FETCH NEXT FROM DISTKY INTO :DIST;
           ENDIF;

           I0 += 1;
         ENDDO;

         EXSR ERPAGE;

       ENDSR;

       //*************************************************************************
       //**  close cursor Datei DISTKY                                         ***
       //*************************************************************************
       BEGSR CCDISTKY;

         WKOPENKY = *OFF;

         EXEC SQL CLOSE DISTKY;

       ENDSR;

       //*************************************************************************
       //**  Aufbereiten für Anzeigen                                          ***
       //*************************************************************************
       BEGSR ADUMM;

         CLEAR BBEU;
         CLEAR SFBBEUAFNR;
         IF ITBEGR = '040'
           OR ITBEGR = '041'
           OR ITBEGR = '023';

           KYEUJH = ITBGJJ;
           KYEUBE = ITBGNR;
           KYEUPO = %DEC(ITBPOS:4:0);
           KYEUUP = *LOVAL;
           CHIDS = '01+';
           EXSR CHBBEU;
           IF CHI(5) = 'J'
             AND EUFIRM = KYEUFI
             AND EUBEJJ = KYEUJH
             AND EUBENR = KYEUBE
             AND EUBEPO = KYEUPO;
             %SUBST(SFBBEUAFNR:01) = EUVPKZ;
             IF EUAFJJ <> *ZERO;
               %SUBST(SFBBEUAFNR:02:04) = %EDITC(EUAFJJ:'X');
             ENDIF;
             %SUBST(SFBBEUAFNR:06) = EUAFNR;
           ELSE;
             CLEAR BBEU;
           ENDIF;
         ENDIF;

         SFDISTBGNR = *BLANK;
         IF ITBGJJ <> *ZERO;
           %SUBST(SFDISTBGNR:1:4) = %EDITC(ITBGJJ:'X');
         ENDIF;
         %SUBST(SFDISTBGNR:5) = ITBGNR;

         EXTRPCPGGR = 'BEGR';
         EXTRPCCODE = ITBEGR;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         SFDISTBEGR = EXTRPCTEXT;

         CLEAR BBEP;
         KYEPFI = ITFIRM;
         KYEPJH = ITBGJJ;
         KYEPBE = ITBGNR;
         KYEPPO = ITBPOS;
         CHIDS = '01C';
         EXSR CHBBEP;

         KYEKJH = ITBGJJ;
         KYEKBE = ITBGNR;
         CHIDS = '01C';
         EXSR CHBBEK;

         KYTENR = ITTENR;
         KYTEEZ = *BLANK;
         CHIDS = '01C';
         EXSR CHTEIL;

         IF WKDIMGBSKZ <> *BLANK;
           CLEAR EXTEXT;
           EXTEXTMSGA = 'BST';      // Bestell-bestätigt
           EXTEXTMSGN = '0276';
           EXTEXTPGST = 'PRUEFE';
           EXTEXTSPCD = DAUSSP;
           C_TRTEXT(EXTEXT:RTTEXT);
           SFDISTBEGR = RTTEXTTEXT;
         ENDIF;

         IF WKWTKZ = '-';
           WKOFMG = WKOFMG * -1;
           WKMENG = WKMENG * -1;
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

         I1 = %LOOKUP(KYDIST:SFLDIST:I1);
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

         I1 = %LOOKUP(KYDIST:SFLDIST:I1);
         IF I1 > 0;
           *IN99 = *ON;
         ELSE;
           *IN99 = *OFF;
           I1 = 1;
         ENDIF;

         IF *IN99 = *ON;
           SFLAUSW(I1) = *BLANK;
           SFLDIST(I1) = *BLANK;
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

           WRITE WAO058R1;
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
       //**  Update Datei DIST                                                 ***
       //*************************************************************************
       BEGSR TRDIST;

         #CKOMM = *BLANK;
         %SUBST(#CKOMM:04) = KYITBG;
         %SUBST(#CKOMM:07:4) = %EDITC(KYITJH:'X');
         %SUBST(#CKOMM:11) = KYITNR;
         %SUBST(#CKOMM:17:5) = %EDITC(KYITPO:'X');
         %SUBST(#CKOMM:22:5) = %EDITC(KYITUP:'X');
         %SUBST(#CKOMM:27) = KYITTE;
         %SUBST(#CKOMM:42:8) = %EDITC(KYITRD:'X');
         %SUBST(#CKOMM:77:6) = %EDITC(KYITRZ:'X');
         #CPGST = PCPGST;

         CALLP(E) C_TXDIST(EXTR02);
         *IN99 = %ERROR;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DISPO-MENGE                                             ***
       //*************************************************************************
       BEGSR TRDIMG;

         WKDIMGBSKZ = *BLANK;
         WKOFMG = *ZERO;                                                        // OFFENE MENGE
         WKMENG = *ZERO;
         WKRSMG = *ZERO;
         WKRBKZ = *BLANK;
         WKKOKZ = *BLANK;
         WKWTKZ = *BLANK;
         WKBVKZ = *BLANK;
         WKAZBG = *BLANK;
         WKABZ1 = *BLANK;
         WKABZ2 = *BLANK;
         WKAUST = *ZERO;
         WKKOMB = *ZERO;                                                        // KOMM.MENGE
         WKZOKZ = *BLANK;
         WKZRKZ = *BLANK;
         WKFENR = *ZERO;

         %SUBST(#CKOMM:01) = 'V';

         #CRTCD = *BLANK;

         CALLP(E) C_TRDIMG(EXTR02:DIST);
         *IN99 = %ERROR;

         IF #CRTCD <> *BLANK;
           WKFENR = '0031';
         ELSE;
           DUC011 = %SUBST(#CKOMM:01);
           MONITOR;
             *IN(98) = *ON;
             DUN110 *= 1;
           ON-ERROR;
             *IN(98) = *OFF;
           ENDMON;
           IF *IN(98) <> *ON;                                                   // AUF
             DUC011 = '00000000000';                                            // NUMERISCHEN
           ENDIF;                                                               // INHALT

           WKMENG = DUN112;
           WKRBKZ = %SUBST(#CKOMM:12);
           WKWTKZ = %SUBST(#CKOMM:14);
           WKBVKZ = %SUBST(#CKOMM:15);
           WKAZBG = %SUBST(#CKOMM:16);
           WKABZ1 = %SUBST(#CKOMM:20);
           WKABZ2 = %SUBST(#CKOMM:50);

           DUC002 = %SUBST(#CKOMM:80);
           MONITOR;
             *IN(98) = *ON;
             DUN020 *= 1;
           ON-ERROR;
             *IN(98) = *OFF;
           ENDMON;
           IF *IN(98) <> *ON;                                                   // AUF
             DUC002 = '00';                                                     // NUMERISCHEN
           ENDIF;                                                               // INHALT

           WKAUST = DUN020;
           WKKOKZ = %SUBST(#CKOMM:82);
           WKZOKZ = %SUBST(#CKOMM:83);
           DUC011 = %SUBST(#CKOMM:84);
           MONITOR;
             *IN(98) = *ON;
             DUN110 *= 1;
           ON-ERROR;
             *IN(98) = *OFF;
           ENDMON;
           IF *IN(98) <> *ON;                                                   // AUF
             DUC011 = '00000000000';                                            // NUMERISCHEN
           ENDIF;                                                               // INHALT
           WKOFMG = DUN112;                                                     // OFFENE MENGE

           DUC011 = %SUBST(#CKOMM:95);
           MONITOR;
             *IN(98) = *ON;
             DUN110 *= 1;
           ON-ERROR;
             *IN(98) = *OFF;
           ENDMON;
           IF *IN(98) <> *ON;
             DUC011 = '00000000000';
           ENDIF;
           WKKOMB = DUN112;

           WKZRKZ = %SUBST(#CKOMM:106);

           WKDIMGBSKZ = %SUBST(#CKOMM:120);

           DUC011 = %SUBST(#CKOMM:129);
           MONITOR;
             *IN(98) = *ON;
             DUN110 *= 1;
           ON-ERROR;
             *IN(98) = *OFF;
           ENDMON;
           IF *IN(98) <> *ON;
             DUC011 = '00000000000';
           ENDIF;
           WKRSMG = DUN112;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Aufruf Subfile-Zeilen-Ermittlung                                  ***
       //*************************************************************************
       BEGSR TRAUFRSBFL;

         CLEAR E1SBFL;
         CLEAR EXSBFL;

         EXSBFLPROG = 'WAO058';
         EXSBFLFMTN = 'WAO058FM';
         EXSBFLPGST = WKSBFLPGST;
         EXSBFLISIC = WKSBFLISIC;

         EXSBFLFIL1 = 'DIST';
         EXSBFLDAT1 = DIST;

         EXSBFLFIL2 = 'BBEP';
         EXSBFLDAT2 = BBEP;

         EXSBFLFIL3 = 'BBEK';
         EXSBFLDAT3 = BBEK;

         EXSBFLFIL4 = 'BBEU';
         EXSBFLDAT4 = BBEU;

         EXSBFLFIL5 = 'TEIL';
         EXSBFLDAT5 = TEIL;

         EXSBFLAF01 = '##DISTBGNR';
         EXSBFLAL01 = SFDISTBGNR;

         EXSBFLAF02 = 'TXDISTBEGR';
         EXSBFLAL02 = SFDISTBEGR;

         EXSBFLAF03 = '##WKZOKZ';
         EXSBFLAL03 = WKZOKZ;

         EXSBFLAF03 = '##WKZRKZ';
         EXSBFLAL03 = WKZRKZ;

         EXSBFLAF04 = '##DIMGBSKZ';
         EXSBFLAL04 = WKDIMGBSKZ;

         EXSBFLAF05 = '##DIMGKOKZ';
         EXSBFLAL05 = WKKOKZ;

         EXSBFLAF06 = '##BBEUAFNR';
         EXSBFLAL06 = SFBBEUAFNR;

         EXSBFLNF01 = '##WKMENG';
         EXSBFLNU01 = WKMENG;

         EXSBFLNF02 = '##OFMG';
         EXSBFLNU02 = WKOFMG;

         EXSBFLNF03 = '##RSMG';
         EXSBFLNU03 = WKRSMG;

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

         KYTATA = 'FIRM';    // ERMITTELN
         KYTATC = 'DIST';    // DISPOART
         KYTAPA = 'DART';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPADART = TAPCDE;

         KYTATA = 'TRLBB2';    // Ermitteln
         KYTATC = 'DIST';      // DIST-Bedarf einschließlich
         KYTAPA = 'PLBD';      // Plan-Bedarf
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAPLBD = TAPCDE;
         IF WKTRPAPLBD <> *ON;
           WKTRPAPLBD = *OFF;
         ENDIF;

         KYTATA = 'FIRM';                                                       // ERMITTELN
         KYTATC = 'TRLG02';                                                     // OB SIBE
         KYTAPA = 'DIST';                                                       // MIT DISPO-DATEI
         CHIDS = '01C';
         EXSR CHTRPA;
         IF TAPCDE = '01';
           WKTRPASIBE = *ON;
         ELSE;
           WKTRPASIBE = *OFF;
         ENDIF;

         KYTATA = 'MCDIST';    // Verfügbarer Bestand = Lager-Bestand minus Bedarf
         KYTATC = 'VFBS';
         KYTAPA = 'BDMG';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAVFBD = TAPCDE;
         IF WKTRPAVFBD <> *ON;
           WKTRPAVFBD = *OFF;
         ENDIF;

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

           EXTRDNPGNA = 'WAO058';
           EXTRDNPGST = 'AUFRUF';

           IF SFAUSW = *BLANK;                                                    // F10=OPTIONEN
             EXTRDNPGNA = 'WAO058B1';

             IF WKPGST = '5     '
               OR WKPGST = 'DETAIL';
               EXTRDNPGNA = 'WAO058B2';
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

           WHEN EXTRDNDANA = 'MCLBBS';
             EXSR MCAUFRLBBS;

           WHEN EXTRDNDANA = 'MCLBLB';
             EXSR MCAUFRLBLB;

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
         EXSR CHDIST;

         CHAIN RCDNBR WAO058R1;
         *IN97 = NOT %FOUND;

         KYITBG = ITBEGR;
         KYITJH = ITBGJJ;
         KYITNR = ITBGNR;
         KYITPO = ITBPOS;
         KYITUP = ITUPOS;
         KYITTE = ITTENR;
         KYITRD = ITRSDA;
         KYITRZ = ITRSZT;

         C#NDSP = *OFF;

         EXSR ADUMM;

         EXSR ERSIC;

         EXSR FAUSW;
         EXSR FKONS;

         // als geändert markiert lassen
         C#NEXT = *ON;
         UPDATE WAO058R1;
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
         EXUXMCINAM = 'MCSBFW058';
         EXUXMCILIB = 'QTEMP';
         EXUXMCIATR = 'TREND';
         EXUXMCDTLG = 4 + 996;
         EXUXMCKYLG = 4;
         EXUXMCITXT = 'Subfile WAO058';

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
         UXDISTFIRM  = KYITFI;
         UXDISTBEGR  = KYITBG;
         UXDISTBGJJ  = KYITJH;
         UXDISTBGNR  = KYITNR;
         UXDISTBPOS  = KYITPO;
         UXDISTUPOS  = KYITUP;
         UXDISTTENR  = KYITTE;
         UXDISTRSDA  = KYITRD;
         UXDISTRSZT  = KYITRZ;
         EXUXMCIDTA  = EXUXSICHT + UXDIST;
         EXUXMCIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXMCREAD;

         CLEAR KYDIST;

         DUN040 = RCDNBR;
         EXUXMCIKEY  = DUC004;

         EXUX05PARM  = EXUXMCPARM;
         EXSR EXMCBYKY;
         EXUXMCPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXMCIDTA;
         DUN030      = %LEN(UXDIST);
         UXDIST      = %SUBST(EXUXMCIDTA:765:DUN030);
         KYITFI      = UXDISTFIRM;
         KYITBG      = UXDISTBEGR;
         KYITJH      = UXDISTBGJJ;
         KYITNR      = UXDISTBGNR;
         KYITPO      = UXDISTBPOS;
         KYITUP      = UXDISTUPOS;
         KYITTE      = UXDISTTENR;
         KYITRD      = UXDISTRSDA;
         KYITRZ      = UXDISTRSZT;

       ENDSR;

       //*************************************************************************
       //**  Löschen   Userindex                                               ***
       //*************************************************************************
       BEGSR UXMCRMKY;

         DUN040 = RCDNBR;

         EXUXMCIKEY = DUC004;
         EXUXRCNR     = RCDNBR;
         UXDISTFIRM  = KYITFI;
         UXDISTBEGR  = KYITBG;
         UXDISTBGJJ  = KYITJH;
         UXDISTBGNR  = KYITNR;
         UXDISTBPOS  = KYITPO;
         UXDISTUPOS  = KYITUP;
         UXDISTTENR  = KYITTE;
         UXDISTRSDA  = KYITRD;
         UXDISTRSZT  = KYITRZ;
         EXUXMCIDTA = EXUXSICHT + UXDIST;
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
         EXUXDLINAM  = 'DLSBFW058';
         EXUXDLILIB  = 'QTEMP';
         EXUXDLIATR  = 'TREND';
         EXUXDLDTLG  = 4 + 996;
         EXUXDLKYLG  = 4;
         EXUXDLITXT  = 'Subfile DLW058';

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
         UXDISTFIRM  = KYITFI;
         UXDISTBEGR  = KYITBG;
         UXDISTBGJJ  = KYITJH;
         UXDISTBGNR  = KYITNR;
         UXDISTBPOS  = KYITPO;
         UXDISTUPOS  = KYITUP;
         UXDISTTENR  = KYITTE;
         UXDISTRSDA  = KYITRD;
         UXDISTRSZT  = KYITRZ;
         EXUXDLIDTA  = EXUXSICHT + UXDIST;
         EXUXDLIMDE  = EXUX07NORP;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCWRTE;

       ENDSR;

       //*************************************************************************
       //**  Lesen Userindex                                                   ***
       //*************************************************************************
       BEGSR UXDLREAD;

         CLEAR KYDIST;

         DUN040 = WKRCNO;
         EXUXDLIKEY  = DUC004;

         EXUX05PARM  = EXUXDLPARM;
         EXSR EXMCBYKY;
         EXUXDLPARM  = EXUX05PARM;

         EXUXSICHT   = EXUXDLIDTA;
         DUN030      = %LEN(UXDIST);
         UXDIST      = %SUBST(EXUXDLIDTA:765:DUN030);
         KYITFI      = UXDISTFIRM;
         KYITBG      = UXDISTBEGR;
         KYITJH      = UXDISTBGJJ;
         KYITNR      = UXDISTBGNR;
         KYITPO      = UXDISTBPOS;
         KYITUP      = UXDISTUPOS;
         KYITTE      = UXDISTTENR;
         KYITRD      = UXDISTRSDA;
         KYITRZ      = UXDISTRSZT;

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

         PGMNAM = 'WAO058';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTW058W1;
         OTHER;
           WRITE WAO058CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'M1';
           WRITE CTW058W1;
         OTHER;
           WRITE WAO058CT;
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
      /COPY QCPYSRC,CHBBEK
      /COPY QCPYSRC,CHBBEP
      /COPY QCPYSRC,CHBBEU
      /COPY QCPYSRC,CHDIST
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,ERSBFL
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,MCLBBS
      /COPY QCPYSRC,MCLBLB
      /COPY QCPYSRC,MCTEIL
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
