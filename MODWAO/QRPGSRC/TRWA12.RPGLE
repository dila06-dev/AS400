     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2016')
      //*************************************************************************
      /TITLE Verwalten Datei WA12
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
      //  Dieses Programm verwaltet die Datei WA12.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA12FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)

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
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ

     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D WA12          E DS                  INZ
     D KYWA12        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ

     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXCRKD        E DS                  INZ
     D RTCRKD        E DS                  INZ

     D EXWA12        E DS
     D RTWA12        E DS

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

     D  WKTDAT         S               D   DATFMT(*ISO) INZ

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
     D OFWA12AFAT      S                   LIKE(KYWA12AFAT)
     D OFWA12KDNR      S                   LIKE(KYWA12KDNR)
     D OFWA12PRGR      S                   LIKE(KYWA12PRGR)
     D OFWA12TENR      S                   LIKE(KYWA12TENR)
     D WKPROG          S                   LIKE(RTWA12PROG)
     D WKDANA          S                   LIKE(RTWA12DANA)
     D WKFFLD          S                   LIKE(RTWA12FFLD)
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
      // Parameter:      #WA12TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA12TSTP                          LIKE(WA12TSTP)

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
      // Program name: C_TRCRKD
      // Purpose:
      // Returns:
      // Parameter:      #EXCRKD
      // Parameter:      #RTCRKD
      //--------------------------------------------------
     D C_TRCRKD...
     D                 PR                  EXTPGM('TRCRKD')
     D  #EXCRKD                            LIKEDS(EXCRKD)
     D  #RTCRKD                            LIKEDS(RTCRKD)

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
     C                   PARM                    EXWA12
     C                   PARM                    RTWA12
      /FREE
       EXSR UEBWA12;
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
           CLOSE TRWA12FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';

       WHEN PCPGST = 'PWA12 ';
         EXSR PWA12;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA12;

         IF WKFENR = *ZERO;
           EXSR LWA12;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = 'PRAUFR';                                                  // EXTERNE PRÜFUNG
         EXSR PRAUFR;
         WKIFMT = '00';
       WHEN EXWA12IFKZ <> *BLANK;                                               // EXTERNES
         EXSR IFWA12;                                                           // UPDATE
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
           OPEN(E) TRWA12FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) TRWA12FM;
         WKIOKZ = *OFF;
       ENDIF;

       RTWA12RTCD = #CRTCD;

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
         KYAAFI = DAFIRM;      // AFPA
         KYKDFI = DAFIRM;      // KUND
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA12FIRM = DAFIRM;  // WA12

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA12FM';

         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA12FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXWA12                         ***
       //*************************************************************************
       BEGSR UEBWA12;

        CLEAR EXDATA;
        EXDATAFILE = 'EXWA12';
        EXDATADATA = EXWA12;
        C_INZDATASTR(EXDATA:RTDATA);
        EXWA12 = RTDATADATA;

        PCPGST = EXWA12PGST;

        KYWA12AFAT = EXWA12AFAT;
        KYWA12KDNR = EXWA12KDNR;
        KYWA12PRGR = EXWA12PRGR;
        KYWA12TENR = EXWA12TENR;

        DSWA12AFAT = EXWA12AFAT;
        DSWA12KDNR = EXWA12KDNR;
        DSWA12PRGR = EXWA12PRGR;
        DSWA12TENR = EXWA12TENR;

        CLEAR RTWA12;
        RTWA12FENR = *ZERO;

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

         EXTRDNDANA = 'TRWA12';
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;
         //DSKOPF = W99DS;
         WNKOPF = EXTRDNTEXT;

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

          WKFLPORECN = 'TRWA1201';
          EXSR EFLPO;
          WRITE TRWA12W2;
          WRITE TRWA1201;
          WRITE W2WA12B1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          SELECT;
          WHEN WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDSL;

          C#WNDW = *OFF;

          READ(E) TRWA1201;
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

            EXSR UWA12;

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
            KYWA12AFAT = EXWA12AFAT;
            KYWA12KDNR = EXWA12KDNR;
            KYWA12PRGR = EXWA12PRGR;
            KYWA12TENR = EXWA12TENR;
            EXSR B01DS;
          ENDIF;

        ENDDO;

        SELECT;
        WHEN PCPGST = 'F     ';
          CHIDS = '01F';
          EXSR CHWA12;
        WHEN #CRTCD = 'N';
          CHIDS = '01CF';
          EXSR CHWA12;
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
          CLEAR WA12;
          EXSR ETRMU;
          EXSR EWA12;
          WA12AFAT = KYWA12AFAT;
          WA12KDNR = KYWA12KDNR;
          WA12PRGR = KYWA12PRGR;
          WA12TENR = KYWA12TENR;

        OTHER;
          CHIDS = '01C';
          EXSR CHWA12;

          EXINFOFILE = 'WA12';
          EXINFODATA = %ADDR(WA12);
          C_TRINFO(EXINFO:DSINFO);

          WKUSER = WA12USER;
          WKJDAT = WA12JDAT;
          WKJZEI = WA12JZEI;

          IF PCPGST = '2     ';
            CHIDS = '01CL';
            EXSR CHWA12;
            EXSR EWA12;
          ENDIF;

        ENDSL;

        IF CHI(5) = 'L';
          PCPGST = 'F     ';
        ENDIF;

        DSWA12AFAT = WA12AFAT;
        DSWA12KDNR = WA12KDNR;
        DSWA12PRGR = WA12PRGR;
        DSWA12TENR = WA12TENR;

        // Initialisieren der Textfelder
        TXWA12AFAT = *BLANK;
        DSKUNDKNAM = *BLANK;
        TXWA12PRGR = *BLANK;
        DSTEILTBZ1 = *BLANK;
        DSTEILTBZ2 = *BLANK;

        // Füllen der Textfelder mit Interpretationen
        IF DSWA12AFAT <> *BLANK;
          EXSR PRWA12AFAT;
        ENDIF;

        IF DSWA12KDNR <> *BLANK;
          EXSR PRWA12KDNR;
        ENDIF;

        IF DSWA12TENR <> *BLANK;
          EXSR PRWA12TENR;
        ENDIF;

        IF DSWA12PRGR <> *BLANK;
          EXSR PRWA12PRGR;
        ENDIF;

        EXTRPBBFMT = 'TRWA1201';
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
          EXFLPOFLDN = 'DSWA12AFAT';

          IF RTTRPBCUSR <> *BLANK;
            EXFLPOFLDN = RTTRPBCUSR;
          ENDIF;

        WHEN PCPGST = 'MUSTER';
          C#LCK1 = *ON;
          EXFLPOFLDN = 'DSWA12AFAT';

        WHEN PCPGST = 'F     ';
          WKFENR = '0001';
          C#LCK0 = *ON;
          C#LCK1 = *ON;

        OTHER;
          SELECT;
          WHEN DSWA12AFAT = *BLANK;
            EXFLPOFLDN = 'DSWA12AFAT';
          WHEN DSWA12KDNR = *BLANK;
            EXFLPOFLDN = 'DSWA12KDNR';
          WHEN DSWA12PRGR = *BLANK;
            EXFLPOFLDN = 'DSWA12PRGR';
          OTHER;
            EXFLPOFLDN = 'DSWA12TENR';
          ENDSL;

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
           AND FLDNAM = 'DSWA12AFAT';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWA12KDNR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWA12PRGR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWA12TENR';
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
           WHEN FLDNAM = 'DSWA12AFAT'
             AND C#LCK1 = *OFF;
             EXSR PRWA12AFAT;
           WHEN FLDNAM = 'DSWA12KDNR'
             AND C#LCK1 = *OFF;
             EXSR PRWA12KDNR;
           WHEN FLDNAM = 'DSWA12PRGR'
             AND C#LCK1 = *OFF;
             EXSR PRWA12PRGR;
           WHEN FLDNAM = 'DSWA12TENR'
             AND C#LCK1 = *OFF;
             EXSR PRWA12TENR;
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';

         WHEN PCPGST = '2     '
           OR PCPGST = *BLANK;
           KYWA12AFAT = DSWA12AFAT;
           KYWA12KDNR = DSWA12KDNR;
           KYWA12PRGR = DSWA12PRGR;
           KYWA12TENR = DSWA12TENR;
           CHIDS = '01C';
           EXSR CHWA12;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA12TENR';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA12TENR';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA12';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA12;

         TRMUJNAM = DAJNAM;
         TRMUPROG = WKCHPN;
         TRMUBIBL = WKCHPL;
         TRMUUSER = DAUSER;

         WKTDAT = %DATE;
         TRMUJZEI = %DEC(%TIME());
         TRMUJDAT = %DEC(%DATE():*ISO);

         IF CHI(6) = *ON;
           CHIDS = '01W';
           EXSR CHTRMU;
           #CRTCD = 'W';

         ELSE;
           CHIDS = '01U';
           EXSR CHTRMU;
           #CRTCD = 'U';

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA12-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA12;

         OFWA12AFAT = KYWA12AFAT;
         OFWA12KDNR = KYWA12KDNR;
         OFWA12PRGR = KYWA12PRGR;
         OFWA12TENR = KYWA12TENR;
         CHIDS = '01+';
         EXSR CHWA12;
         WKFENR = *ZERO;

         DOW CHI(5) = 'J'
           AND WA12FIRM = KYWA12FIRM
           AND WA12AFAT <= OFWA12AFAT
           AND WA12KDNR <= OFWA12KDNR
           AND WA12PRGR <= OFWA12PRGR
           AND WA12TENR <= OFWA12TENR;

           IF WA12LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA12LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA12;
           WKFENR = *ZERO;

         ENDDO;

         CLEAR RTWA12;
         RTWA12PROG = WKPROG;
         RTWA12DANA = WKDANA;
         RTWA12FFLD = WKFFLD;
         RTWA12FENR = WKFENR;
         RTWA12PA03 = W$PA03;
         RTWA12PA04 = W$PA04;
         RTWA12PA05 = W$PA05;
         RTWA12PA06 = W$PA06;
         RTWA12PA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WA12                                          ***
       //*************************************************************************
       BEGSR LWA12;

         OFWA12AFAT = KYWA12AFAT;
         OFWA12KDNR = KYWA12KDNR;
         OFWA12PRGR = KYWA12PRGR;
         OFWA12TENR = KYWA12TENR;
         CHIDS = '01+';
         EXSR CHWA12;
         WKFENR = *ZERO;

         DOW CHI(5) = 'J'
           AND WA12FIRM = KYWA12FIRM
           AND WA12AFAT <= OFWA12AFAT
           AND WA12KDNR <= OFWA12KDNR
           AND WA12PRGR <= OFWA12PRGR
           AND WA12TENR <= OFWA12TENR;

           EXSR LPOSI;

           KYWA12AFAT = WA12AFAT;
           KYWA12KDNR = WA12KDNR;
           KYWA12PRGR = WA12PRGR;
           KYWA12TENR = WA12TENR;
           CHIDS = '01CU';
           EXSR CHWA12;

           CHIDS = '01D';
           EXSR CHWA12;

           CHIDS = '01R';
           EXSR CHWA12;
           WKFENR = *ZERO;

         ENDDO;

         CLEAR RTWA12;
         RTWA12PROG = WKPROG;
         RTWA12DANA = WKDANA;
         RTWA12FFLD = WKFFLD;
         RTWA12FENR = WKFENR;
         RTWA12PA03 = W$PA03;
         RTWA12PA04 = W$PA04;
         RTWA12PA05 = W$PA05;
         RTWA12PA06 = W$PA06;
         RTWA12PA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen der abhängigen Sätze                                      ***
       //*************************************************************************
       BEGSR LPOSI;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Prüfen Dateifelder                                                ***
       //*************************************************************************
       BEGSR PRAUFR;

         WKFENR = *ZERO;

         SELECT;
         OTHER;
           WKFLPORECN = 'TRWA1201';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDSL;

         IF WKFENR <> *ZERO;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWA12;
         RTWA12PROG = WKPROG;
         RTWA12DANA = WKDANA;
         RTWA12FFLD = WKFFLD;
         RTWA12FENR = WKFENR;
         RTWA12PA03 = W$PA03;
         RTWA12PA04 = W$PA04;
         RTWA12PA05 = W$PA05;
         RTWA12PA06 = W$PA06;
         RTWA12PA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWA12;

         IF EXWA12IFKZ = '0';

           // Satz auf Existenz prüfen
           KYWA12AFAT = EXWA12AFAT;
           KYWA12KDNR = EXWA12KDNR;
           KYWA12PRGR = EXWA12PRGR;
           KYWA12TENR = EXWA12TENR;
           CHIDS = '01C';
           EXSR CHWA12;

           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;

         ENDIF;

         EXSR B01DS;

         WKFLPORECN = 'TRWA1201';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR UWA12;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWA12;
         RTWA12PROG = WKPROG;
         RTWA12DANA = WKDANA;
         RTWA12FFLD = WKFFLD;
         RTWA12FENR = WKFENR;
         RTWA12PA03 = W$PA03;
         RTWA12PA04 = W$PA04;
         RTWA12PA05 = W$PA05;
         RTWA12PA06 = W$PA06;
         RTWA12PA07 = W$PA07;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WA12LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA12;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA12                                                 ***
       //*************************************************************************
       BEGSR UWA12;

         KYWA12AFAT = DSWA12AFAT;
         KYWA12KDNR = DSWA12KDNR;
         KYWA12PRGR = DSWA12PRGR;
         KYWA12TENR = DSWA12TENR;

         CHIDS = '01CU';
         EXSR CHWA12;

         WA12JNAM = DAJNAM;
         WA12PROG = DAPROG;
         WA12BIBL = WKCHPL;
         WA12USER = DAUSER;
         WA12JZEI = %DEC(%TIME());
         WA12JDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA12;

         WHEN CHI(6) = *ON;
           C_EXTSTP(WA12TSTP);
           WA12ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA12;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA12;

           #CRTCD = 'U';

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

         IF DSWA12AFAT = *BLANK
           AND DSWA12KDNR = *BLANK
           AND DSWA12PRGR = *BLANK
           AND DSWA12TENR = *BLANK;
           WKFENR = '0933';  // Es muß mindestens ein Feld gefüllt sei
           LEAVESR;
         ENDIF;

         IF DSWA12AFAT <> *BLANK;
           KYAAAT = DSWA12AFAT;
           CHIDS = '01C';
           EXSR CHAFPA;
           TXWA12AFAT = AAABEZ;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

           IF DSWA12KDNR <> *BLANK
             OR DSWA12PRGR <> *BLANK
             OR DSWA12TENR <> *BLANK;
             WKFENR = '1685';  // Keine weitere Eingabe möglich
             SELECT;
             WHEN DSWA12KDNR <> *BLANK;
               EXFLPOFLDN = 'DSWA12KDNR';
             WHEN DSWA12PRGR <> *BLANK;
               EXFLPOFLDN = 'DSWA12PRGR';
             WHEN DSWA12TENR <> *BLANK;
               EXFLPOFLDN = 'DSWA12TENR';
             ENDSL;
             LEAVESR;
           ENDIF;

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
           DSWA12KDNR = KDKDNR;
           DSKUNDKNAM = KDKNAM;
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

         IF DSWA12PRGR <> *BLANK;
           KYTPTA = 'PRGR';
           KYTPTC = DSWA12PRGR;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXWA12PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Anzeige TENR                                                   ***
       //*************************************************************************
       BEGSR MCWA12TENR;

         C#WNDW = *ON;

         IF DSWA12TENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA12TENR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA12TENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PRÜFEN IDENT-NR                                                   ***
       //*************************************************************************
       BEGSR PRWA12TENR;

         EXFLPOFLDN = 'DSWA12TENR';

         IF DSWA12TENR <> *BLANK;
           KYTENR = DSWA12TENR;
           CHIDS = '01C';
           EXSR CHTEIL;
           DSWA12TENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

           IF DSWA12PRGR <> *BLANK;
             WKFENR = '1684'; // Entweder Produkt-Gruppe oder Ident-Nr eingeben
           ENDIF;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Musterdatei                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA12';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;
           WA12 = TRMUDATA;

           CLEAR EXDATA;
           EXDATAFILE = 'WA12';
           EXDATADATA = WA12;
           C_INZDATASTR(EXDATA:RTDATA);
           WA12 = RTDATADATA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA12;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA12';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKCFMT = TAPCDE;
         IF WKCFMT <> *ON;
           WKCFMT = *OFF;
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
           EXTRDNPGNA = 'TRWA12';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA12B1'    EXTRDNPGNA
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

           WHEN EXTRDNDANA = 'XXXXXX';

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

       //*************************************************************************
       //**  Aufbereiten der Nachrichten                                       ***
       //*************************************************************************
       BEGSR AUMSG;

         C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
         W$PA06:W$PA07);
         PGMNAM = 'TRWA12';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA12W2;
         OTHER;
           WRITE CTWA12W2;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA12W2;
         OTHER;
           WRITE CTWA12W2;
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
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA12
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCAFPA
      /COPY QCPYSRC,MCKUND
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
