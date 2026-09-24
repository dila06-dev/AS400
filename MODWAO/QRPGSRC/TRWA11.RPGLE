     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2022')
      //*************************************************************************
      /TITLE Verwalten Datei WA11
      //*************************************************************************
      //  Copyright 2022 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 08.12.2022 Projekt 220567-02
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA11.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA11FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(SFTRDZR1:RCDNRTRDZ)
     F                                     SFILE(SFTRDZBR1:RCDNRTRDZB)

      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR

      //*************************************************************************
      //**  indicators                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR

      //*************************************************************************
      //**  Dateien                                                           ***
      //*************************************************************************
     D TRDN          E DS                  INZ
     D KYTRDN        E DS                  INZ

     D TRDZ          E DS                  INZ
     D KYTRDZ        E DS                  INZ
     D UXTRDZ        E DS                  INZ

     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D WA11          E DS                  INZ
     D KYWA11        E DS                  INZ

     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ

     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ

     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXWA11        E DS
     D RTWA11        E DS

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
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
     D WKIFMT          S              2
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKIOKZ          S              1
     D WKI000          S              1
     D WKCFMT          S              1
     D MODXXX          S              1
     D MODYYY          S              1
     D WKTRPAQQQQ      S              1
     D WKTRDZZYKL      S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D WKC010          S             10
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D FL              S              4S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFWA11WKNR      S                   LIKE(KYWA11WKNR)
     D OFWA11TEWK      S                   LIKE(KYWA11TEWK)
     D WKPROG          S                   LIKE(RTWA11PROG)
     D WKDANA          S                   LIKE(RTWA11DANA)
     D WKFFLD          S                   LIKE(RTWA11FFLD)
     D WKFEAT          S              1
     D WKFENR          S              4
     D WKINFO          S              4
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
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WA11TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA11TSTP                          LIKE(WA11TSTP)

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
      // Program name: C_TRINFO
      // Purpose:
      // Returns:
      // Parameter:      #EXINFO
      // Parameter:      #DSINFO
      //--------------------------------------------------
     D C_TRINFO...
     D                 PR                  EXTPGM('TRINFO')
     D  #EXINFO                            LIKE(EXINFO)
     D  #DSINFO                            LIKE(DSINFO)

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
     C                   PARM                    EXWA11
     C                   PARM                    RTWA11
      /FREE
       EXSR UEBWA11;
       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;
       EXSR OFFUKT;
       *IN = *OFF;
       *IN28 = C#IN28;

       IF WKIOKZ = *ON;
         C#WNDW = *ON;
       ENDIF;

       SELECT;
       WHEN PCPGST = 'ENDE  ';
         // Bildschirmformat schliessen
         IF WKIOKZ = *ON;
           CLOSE TRWA11FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRWA11K1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KWA11;
           EXSR UWA11;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PWA11 ';
         EXSR PWA11;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA11;

         IF WKFENR = *ZERO;
           EXSR LWA11;
         ENDIF;

         WKIFMT = '00';
       WHEN DATEST = '5';
         PCPGST = '5     ';
       ENDSL;

       //*************************************************************************
       //**  Programmsteuerung                                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';
         IF WKIOKZ <> *ON;
           EXSR AUFFOR;
           OPEN(E) TRWA11FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA11';
             EXTRDZAUSW = 'TRWA11';
             EXSR ERTRDZ;
             WKTRDZ = *ON;
           ENDIF;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         WHEN WKIFMT = 'K1';
           EXSR BILDK1;
         ENDSL;
       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) TRWA11FM;
         WKIOKZ = *OFF;
       ENDIF;

       RTWA11RTCD = #CRTCD;
       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;
         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         // Firma in alle Keystrukten setzen
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA11FIRM = DAFIRM;  // WA11
         KYWRFI = DAFIRM;      // WERK

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA11FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA11FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXWA11                         ***
       //*************************************************************************
       BEGSR UEBWA11;

         CLEAR EXDATA;
         EXDATAFILE = 'EXWA11';
         EXDATADATA = EXWA11;
         C_INZDATASTR(EXDATA:RTDATA);
         EXWA11 = RTDATADATA;
         PCPGST = EXWA11PGST;

         KYWA11WKNR = EXWA11WKNR;
         KYWA11TEWK = EXWA11TEWK;

         DSWA11WKNR = EXWA11WKNR;
         DSWA11TEWK = EXWA11TEWK;

         DSWA11NWKN = EXWA11NWKN;
         DSWA11NTEW = EXWA11NTEW;

         CLEAR RTWA11;
         RTWA11FENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Vorlauf                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         C#LCK0 = *OFF;
         C#LCK1 = *OFF;
         WKIN30 = C#LCK0;
         WKIN31 = C#LCK1;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;
         WKFEAT = 'F';
         MCF = *BLANK;

         WKIFMT = '01';
         FMTDS = *BLANK;

         FM = 1;
         FMT(FM) = '00';

       ENDSR;

       //*************************************************************************
       //**  Aufbereitung für Formatanzeige                                    ***
       //*************************************************************************
       BEGSR AUFFOR;

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;
         %SUBST(W99DS:01) = EXFIRMKNAM;
         %SUBST(W99DS:31) = *BLANK;

         EXTRDNDANA = 'TRWA11';
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;
         //DSKOPF = W99DS;
         WNKOPF = %SUBST(W99DS:32);

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
           WKFLPORECN = 'TRWA1101';
           //WRITE TRWA11CL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWA11W1;
           WRITE TRWA1101;
           WRITE W1WA11B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           //FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA1101;
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

           WHEN C#SELC = *ON
             AND FUKT04 = *ON;
             EXSR MCAUFR;
             IF WKTRTP = *ON
               OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#ACCS = *ON
             AND FUKT10 = *ON;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#CANC = *ON
             AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#INFO = *ON
             AND FUKT13 = *ON;
             EXSR VINFO;
             C#WNDW = *ON;
             ITER;

           WHEN C#FUKT <> *ZERO
             AND FUKT10 = *ON;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             IF WKFENR <> *ZERO;
               ITER;
             ENDIF;

             LEAVE;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           IF PCPGST <> '5     '
             AND PCPGST <> 'F     ';

             IF PCPGST <> 'MUSTER';
               EXSR BILDPR;
               IF WKFENR <> *ZERO;
                 ITER;
                 ENDIF;
               ENDIF;

             EXSR UWA11;

             SELECT;
             WHEN PCPGST = 'MUSTER';
               EXSR UTRMU;
             ENDSL;
           ENDIF;

           IF PCPGST <> 'MUSTER';
             WKPGST = 'DIREKT';
             EXSR TRTRDZ;
           ENDIF;

           IF PCPGST <> *BLANK
             OR WKCFMT = *ON;
             #CRTCD = *BLANK;
             #CPGST = *BLANK;
             WKIFMT = '00';
           ELSE;
             IF EXWA11WKNR = *BLANK;
               KYWA11WKNR = *BLANK;
             ELSE;
               KYWA11WKNR = EXWA11WKNR;
             ENDIF;
             KYWA11TEWK = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA11;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA11;
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 01                                        ***
       //*************************************************************************
       BEGSR B01DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;
         PCRTCD = #CRTCD;

         SELECT;
         WHEN PCPGST = *BLANK
           OR PCPGST = 'MUSTER';
           CLEAR WA11;
           EXSR ETRMU;
           EXSR EWA11;
           WA11WKNR = KYWA11WKNR;
           WA11TEWK = KYWA11TEWK;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA11;

           EXINFOFILE = 'WA11';
           EXINFODATA = %ADDR(WA11);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA11USER;
           WKJDAT = WA11JDAT;
           WKJZEI = WA11JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA11;
             EXSR EWA11;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA11WKNR = WA11WKNR;
         DSWA11TEWK = WA11TEWK;

         // Initialisieren der Textfelder
         DSWKNRWKBZ = *BLANK;
         DSTEWKWKBZ = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA11WKNR <> *BLANK;
           EXSR PRWA11WKNR;
         ENDIF;

         IF DSWA11TEWK <> *BLANK;
           EXSR PRWA11TEWK;
         ENDIF;

         EXTRPBBFMT = 'TRWA1101';
         EXSR CSTRPB;

         WKFENR = *ZERO;
         EXFLPOFLDN = *BLANK;

         IF PCRTCD = 'W';
           WKFENR = '0070';
         ENDIF;

         SELECT;
         WHEN PCPGST = '5     ';
           C#LCK0 = *ON;
           C#LCK1 = *ON;
         WHEN PCPGST = '2     ';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA11TEWK';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;
         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA11TEWK';
         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;
         OTHER;
           IF DSWA11WKNR <> *BLANK;
             EXFLPOFLDN = 'DSWA11TEWK';
           ELSE;
             EXFLPOFLDN = 'DSWA11WKNR';
           ENDIF;
         ENDSL;

         // Meldung "Bearbeitet ... am ... um ..." ausgeben
         IF WKFENR = *ZERO
           AND PCPGST <> *BLANK
           AND PCPGST <> 'MUSTER';
           CLEAR EXDATE;
           EXDATEDATV = WKJDAT;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           W$PA03 = %TRIM(%EDITW(RTDATEDATE: '0 .  .    '));
           W$PA04 = WKUSER;
           W$PA05 = %TRIM(%EDITW(WKJZEI: '0 :  :  '));
           WKFENR = '0076';
         ENDIF;

         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILDK1                                              ***
       //*************************************************************************
       BEGSR BILDK1;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR BK1DS;

         DOW WKIFMT = 'K1';
           WKFLPORECN = 'TRWA11K1';
           EXSR EFLPO;
           WRITE TRWA11W2;
           WRITE TRWA11K1;
           WRITE W2WA11B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA11K1;

           IF %ERROR OR %EOF;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON
             AND FUKT04 = *ON;
             EXSR MCAUFR;
             IF WKTRTP = *ON
               OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON
             AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
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

           EXSR BILDPR;
           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR KWA11;
           WKIFMT = '00';
         ENDDO;

         RTWA11RTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA11WKNR = KYWA11WKNR;
         DSWA11TEWK = KYWA11TEWK;

         DSWA11NWKN = KYWA11WKNR;
         DSWA11NTEW = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         EXFLPOFLDN = 'DSWA11NTEW';

       ENDSR;

       //*************************************************************************
       //**  Funktionstaste 4 für alle Bilder                                  ***
       //*************************************************************************
       BEGSR MCAUFR;

         //  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
         //  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
         //  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
         //  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
         WKTRTP = *OFF;
         WKFENR = *ZERO;
         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;

         WHEN EXFLPOKZIO = *OFF;
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWA11WKNR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWA11TEWK';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA11WKNR';

         WHEN FLDNAM = 'DSWA11WKNR';
           EXSR MCWA11WKNR;

         WHEN FLDNAM = 'DSWA11TEWK';
           EXSR MCWA11TEWK;

         WHEN FLDNAM = 'DSWA11NWKN';
           EXSR MCWA11NWKN;

         WHEN FLDNAM = 'DSWA11NTEW';
           EXSR MCWA11NTEW;

         OTHER;
           WKFENR = '0050';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Plausiprüfung für Formate                                         ***
       //*************************************************************************
       BEGSR BILDPR;

         //  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
         //  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
         //  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
         //  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).

         WKFENR = *ZERO;
         FLDDS = EXFLPOFLDA;

         FOR FL = 1 TO 100;
           IF FLD(FL) = *BLANK;
             LEAVE;
           ENDIF;

           FLDNAM = FLD(FL);
           EXFLPOFLDN = FLDNAM;
           EXSR EFLPO;

           SELECT;

           WHEN EXFLPOKZIO = *OFF;

           WHEN FLDNAM = 'DSWA11WKNR'
             AND C#LCK1 = *OFF;
             EXSR PRWA11WKNR;

           WHEN FLDNAM = 'DSWA11TEWK'
             AND C#LCK1 = *OFF;
             EXSR PRWA11TEWK;

           WHEN FLDNAM = 'DSWA11NWKN';
             EXSR PRWA11NWKN;

           WHEN FLDNAM = 'DSWA11NTEW';
             EXSR PRWA11NTEW;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;
         WHEN PCPGST = '3     ';
           KYWA11WKNR = DSWA11NWKN;
           KYWA11TEWK = DSWA11NTEW;
           CHIDS = '01C';
           EXSR CHWA11;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA11NTEW';
             LEAVESR;
           ENDIF;
         WHEN PCPGST = '2     '
           OR PCPGST = *BLANK;
           KYWA11WKNR = DSWA11WKNR;
           KYWA11TEWK = DSWA11TEWK;
           CHIDS = '01C';
           EXSR CHWA11;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA11TEWK';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA11TEWK';
             LEAVESR;
           ENDSL;
         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA11';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA11;
         TRMUJNAM = DAJNAM;
         TRMUPROG = WKCHPN;
         TRMUBIBL = WKCHPL;
         TRMUUSER = DAUSER;
         TRMUJZEI = %DEC(%TIME());
         TRMUJDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN CHI(6) = *ON;
           CHIDS = '01W';
           EXSR CHTRMU;
           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHTRMU;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WA11                                     ***
       //*************************************************************************
       BEGSR KWA11;

         EXSR KWA1100;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WA11 pro Ident-Nr                        ***
       //*************************************************************************
       BEGSR KWA1100;

         KYWA11WKNR = DSWA11WKNR;
         OFWA11WKNR = DSWA11WKNR;
         KYWA11TEWK = DSWA11TEWK;
         OFWA11TEWK = DSWA11TEWK;
         IF DSWA11TEWK = *BLANK;
           OFWA11TEWK = *HIVAL;
         ENDIF;
         CHIDS = '00+';
         EXSR CHWA11;
         DOW CHI(5) = 'J'
           AND WA11FIRM = KYWA11FIRM
           AND WA11WKNR <= OFWA11WKNR
           AND WA11TEWK <= OFWA11TEWK;

           EXSR UWA11;

           CHIDS = '00R';
           EXSR CHWA11;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA11-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA11;

         OFWA11WKNR = KYWA11WKNR;
         OFWA11TEWK = KYWA11TEWK;
         // <== Weil WA11TEWK = *BLANK zulässig ist
         //IF KYWA11TEWK = *BLANK;
         //  OFWA11TEWK = *HIVAL;
         //ENDIF;
         CHIDS = '01+';
         EXSR CHWA11;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA11FIRM = KYWA11FIRM
           AND WA11WKNR <= OFWA11WKNR
           AND WA11TEWK <= OFWA11TEWK;

           IF WA11LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA11LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA11;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTWA11;
         RTWA11PROG = WKPROG;
         RTWA11DANA = WKDANA;
         RTWA11FFLD = WKFFLD;
         RTWA11FENR = WKFENR;
         RTWA11PA03 = W$PA03;
         RTWA11PA04 = W$PA04;
         RTWA11PA05 = W$PA05;
         RTWA11PA06 = W$PA06;
         RTWA11PA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WA11                                          ***
       //*************************************************************************
       BEGSR LWA11;

         OFWA11WKNR = KYWA11WKNR;
         OFWA11TEWK = KYWA11TEWK;
         // <== Weil WA11TEWK = *BLANK zulässig ist
         //IF KYWA11TEWK = *BLANK;
         //  OFWA11TEWK = *HIVAL;
         //ENDIF;
         CHIDS = '01+';
         EXSR CHWA11;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA11FIRM = KYWA11FIRM
           AND WA11WKNR <= OFWA11WKNR
           AND WA11TEWK <= OFWA11TEWK;

           EXSR LPOSI;

           KYWA11WKNR = WA11WKNR;
           KYWA11TEWK = WA11TEWK;
           CHIDS = '01CU';
           EXSR CHWA11;

           CHIDS = '01D';
           EXSR CHWA11;

           CHIDS = '01R';
           EXSR CHWA11;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTWA11;
         RTWA11PROG = WKPROG;
         RTWA11DANA = WKDANA;
         RTWA11FFLD = WKFFLD;
         RTWA11FENR = WKFENR;
         RTWA11PA03 = W$PA03;
         RTWA11PA04 = W$PA04;
         RTWA11PA05 = W$PA05;
         RTWA11PA06 = W$PA06;
         RTWA11PA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen der abhängigen Sätze                                      ***
       //*************************************************************************
       BEGSR LPOSI;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA11                                                 ***
       //*************************************************************************
       BEGSR UWA11;

         KYWA11WKNR = DSWA11WKNR;
         KYWA11TEWK = DSWA11TEWK;

         IF PCPGST = '3     ';
           KYWA11WKNR = DSWA11NWKN;
           KYWA11TEWK = DSWA11NTEW;
           IF DSWA11NTEW = *BLANK;
             KYWA11TEWK = WA11TEWK;
           ENDIF;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA11;

         WA11JNAM = DAJNAM;
         WA11PROG = DAPROG;
         WA11BIBL = WKCHPL;
         WA11USER = DAUSER;
         WA11JZEI = %DEC(%TIME());
         WA11JDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA11;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA11TSTP);
           WA11ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA11;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA11;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine WKNR                                                   ***
       //*************************************************************************
       BEGSR MCWA11WKNR;

         C#WNDW = *ON;

         IF DSWA11WKNR = *BLANK;
           DSWKNRWKBZ = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA11WKNR;
         #CPGST = 'WERK01';
         #CUEBE = '0010';
         EXSR MCWERK;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA11WKNR = WRWKNR;
           DSWKNRWKBZ = WRWKBZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine WKNR                                                   ***
       //*************************************************************************
       BEGSR PRWA11WKNR;

         EXFLPOFLDN = 'DSWA11WKNR';

         KYWRNR = DSWA11WKNR;
         CHIDS  = '01C';
         EXSR CHWERK;
         DSWKNRWKBZ = WRWKBZ;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TEWK                                                   ***
       //*************************************************************************
       BEGSR MCWA11TEWK;

         C#WNDW = *ON;

         IF DSWA11TEWK = *BLANK;
           DSTEWKWKBZ = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA11TEWK;
         #CPGST = 'WERK01';
         #CUEBE = '0010';
         EXSR MCWERK;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA11TEWK = WRWKNR;
           DSTEWKWKBZ = WRWKBZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TEWK                                                   ***
       //*************************************************************************
       BEGSR PRWA11TEWK;

         EXFLPOFLDN = 'DSWA11TEWK';
         DSTEWKWKBZ = *BLANK;

         SELECT;
         WHEN WKFLPORECN = 'TRWA11K1'
           AND DSWA11TEWK = *BLANK
           AND DSWA11NTEW = *BLANK;
           LEAVESR;
         ENDSL;

         IF DSWA11TEWK <> *BLANK;
           KYWRNR = DSWA11TEWK;
           CHIDS  = '01C';
           EXSR CHWERK;
           DSTEWKWKBZ = WRWKBZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NWKN                                                   ***
       //*************************************************************************
       BEGSR MCWA11NWKN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA11NWKN;
         #CPGST = 'WERK01';
         #CUEBE = '0010';
         EXSR MCWERK;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA11NWKN = WRWKNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NWKN                                                   ***
       //*************************************************************************
       BEGSR PRWA11NWKN;

         EXFLPOFLDN = 'DSWA11NWKN';

         KYWRNR = DSWA11NWKN;
         CHIDS  = '01C';
         EXSR CHWERK;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEW                                                   ***
       //*************************************************************************
       BEGSR MCWA11NTEW;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA11NTEW;
         #CPGST = 'WERK01';
         #CUEBE = '0010';
         EXSR MCWERK;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA11NTEW = WRWKNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NTEW                                                   ***
       //*************************************************************************
       BEGSR PRWA11NTEW;

         EXFLPOFLDN = 'DSWA11NTEW';

         SELECT;
         WHEN WKFLPORECN = 'TRWA11K1'
           AND DSWA11TEWK = *BLANK
           AND DSWA11NTEW = *BLANK;
           LEAVESR;
         ENDSL;

         IF DSWA11NTEW <> *BLANK;
           KYWRNR = DSWA11NTEW;
           CHIDS  = '01C';
           EXSR CHWERK;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TRTK                                                   ***
       //*************************************************************************
       BEGSR MCAUFRTRTK;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'QQQQ';
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTK;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA11';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA11;

           CLEAR EXDATA;
           EXDATAFILE = 'WA11';
           EXDATADATA = WA11;
           C_INZDATASTR(EXDATA: RTDATA);

           WA11 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA11;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA11';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKCFMT = TAPCDE;
         IF WKCFMT <> *ON;
           WKCFMT = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'MODXXX';
         KYTAPA = 'MODXXX';
         CHIDS = '01C';
         EXSR CHTRPA;
         MODXXX = TAPCDE;
         IF MODXXX <> *ON;
           MODXXX = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'QQQQ';
         KYTAPA = 'QQQQ';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAQQQQ = TAPCDE;
         IF WKTRPAQQQQ <> *ON;
           WKTRPAQQQQ = *OFF;
         ENDIF;

         KYTATA = 'FIRM';
         KYTATC = 'MODYYY';
         KYTAPA = 'MODYYY';
         CHIDS = '01C';
         EXSR CHTRPA;
         IF TAPCDE = '01';
           MODYYY = *ON;
         ELSE;
           MODYYY = *OFF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Zugriffe                                                          ***
       //*************************************************************************
       BEGSR TRTRDZ;

         WKTRTP = *OFF;
         WKFENR = *ZERO;
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;
           CLEAR EXTRDN;
           EXTRDNPGST = WKPGST;
           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;

           EXTRDNPGNA = 'TRWA11';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA11B1'    EXTRDNPGNA
             EXTRDNFUKT = C#FUKT;                                                 // F-TASTEN
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
           WHEN EXTRDNDANA = 'TRTK';
             EXSR MCAUFRTRTK;
           ENDSL;

           IF EXTRDNPGST = 'DIREKT';
             WKPGST = 'WEITER';
             WKFENR = *ZERO;
           ENDIF;

           IF EXTRDNPGST = 'WEITER';
             WKPGST = 'WEITER';
             WKFENR = *ZERO;
           ENDIF;

           IF C#FUKT <> *ZERO
             AND C#ACCS <> *ON;
             LEAVE;
           ENDIF;

           #CRTCD = *BLANK;
         ENDDO;

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

         PGMNAM = 'TRWA11';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA11W2;
         OTHER;
           WRITE CTWA11W1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA11W2;
         OTHER;
           WRITE CTWA11W1;
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
      /END-FREE
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA11
      /COPY QCPYSRC,CHWERK
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCWERK
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
