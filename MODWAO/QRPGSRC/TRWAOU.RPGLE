     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
      //*************************************************************************
      /TITLE Verwalten Datei WAOU
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 14.01.2014 Projekt 9787
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WAOU.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWAOUFM  CF   E             WORKSTN USROPN
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
     D WAOU          E DS                  INZ
     D KYWAOU        E DS                  INZ

     D CRKD          E DS                  INZ

     D LAND          E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

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

     D EXWAOU        E DS
     D RTWAOU        E DS

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
     D OFWAOUTENR      S                   LIKE(KYWAOUTENR)
     D OFWAOULAND      S                   LIKE(KYWAOULAND)
     D WKPROG          S                   LIKE(RTWAOUPROG)
     D WKDANA          S                   LIKE(RTWAOUDANA)
     D WKFFLD          S                   LIKE(RTWAOUFFLD)
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
      // Parameter:      #WAOUTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WAOUTSTP                          LIKE(WAOUTSTP)

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
     C                   PARM                    EXWAOU
     C                   PARM                    RTWAOU
      /FREE
       EXSR UEBWAOU;
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
           CLOSE TRWAOUFM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';

       WHEN PCPGST = 'PWAOU ';
         EXSR PWAOU;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWAOU;

         IF WKFENR = *ZERO;
           EXSR LWAOU;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = 'PRAUFR';                                                  // EXTERNE PRÜFUNG
         EXSR PRAUFR;
         WKIFMT = '00';
       WHEN EXWAOUIFKZ <> *BLANK;                                               // EXTERNES
         EXSR IFWAOU;                                                           // UPDATE
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
           OPEN(E) TRWAOUFM;
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
         CLOSE(E) TRWAOUFM;
         WKIOKZ = *OFF;
       ENDIF;

       RTWAOURTCD = #CRTCD;

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
         KYWAOUFIRM = DAFIRM;  // WAOU
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWAOUFM';

         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWAOUFM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXWAOU                         ***
       //*************************************************************************
       BEGSR UEBWAOU;

        CLEAR EXDATA;
        EXDATAFILE = 'EXWAOU';
        EXDATADATA = EXWAOU;
        C_INZDATASTR(EXDATA:RTDATA);
        EXWAOU = RTDATADATA;

        PCPGST = EXWAOUPGST;

        KYWAOUTENR = EXWAOUTENR;
        KYWAOULAND = EXWAOULAND;

        DSWAOUTENR = EXWAOUTENR;
        DSWAOULAND = EXWAOULAND;

        CLEAR RTWAOU;
        RTWAOUFENR = '0000';

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

         EXTRDNDANA = 'TRWAOU';
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;

         DSKOPF = W99DS;

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

          %SUBST(WKFLPORECN:1:8) = 'TRWAOU01';
          EXSR EFLPO;
          WRITE TRWAOU01;
          WRITE TRWAOUB1;
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

          READ(E) TRWAOU01;
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

            EXSR UWAOU;

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
            KYWAOUTENR = EXWAOUTENR;
            KYWAOULAND = EXWAOULAND;
            EXSR B01DS;
          ENDIF;

        ENDDO;

        SELECT;
        WHEN PCPGST = 'F     ';
          CHIDS = '01F';
          EXSR CHWAOU;
        WHEN #CRTCD = 'N';
          CHIDS = '01CF';
          EXSR CHWAOU;
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
          CLEAR WAOU;
          EXSR ETRMU;
          EXSR EWAOU;
          WAOUTENR = KYWAOUTENR;
          WAOULAND = KYWAOULAND;

        OTHER;
          CHIDS = '01C';
          EXSR CHWAOU;

          EXINFOFILE = 'WAOU';
          EXINFODATA = %ADDR(WAOU);

          C_TRINFO(EXINFO:DSINFO);
          WKUSER = WAOUUSER;
          WKJDAT = WAOUJDAT;
          WKJZEI = WAOUJZEI;

          IF PCPGST = '2     ';
            CHIDS = '01CL';
            EXSR CHWAOU;
            EXSR EWAOU;
          ENDIF;

        ENDSL;

        IF CHI(5) = 'L';
          PCPGST = 'F     ';
        ENDIF;

        DSWAOUTENR = WAOUTENR;
        DSWAOULAND = WAOULAND;
        DSWAOUWEBS = WAOUWEBS;

        // Initialisieren der Textfelder
        DSTEILTBZ1 = *BLANK;
        DSTEILTBZ2 = *BLANK;
        TXWAOULAND = *BLANK;

        // Füllen der Textfelder mit Interpretationen
        IF DSWAOUTENR <> *BLANK;
          EXSR PRWAOUTENR;
        ENDIF;

        IF DSWAOULAND <> *BLANK;
          EXSR PRWAOULAND;
        ENDIF;

        EXTRPBBFMT = 'TRWAOU01';
        EXSR CSTRPB;

        WKFENR = '0000';
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
          EXFLPOFLDN = 'DSWAOUWEBS';

          IF RTTRPBCUSR <> *BLANK;
            EXFLPOFLDN = RTTRPBCUSR;
          ENDIF;

        WHEN PCPGST = 'MUSTER';
          C#LCK1 = *ON;
          EXFLPOFLDN = 'DSWAOUWEBS';

        WHEN PCPGST = 'F     ';
          WKFENR = '0001';
          C#LCK0 = *ON;
          C#LCK1 = *ON;

        OTHER;
          SELECT;
          WHEN DSWAOUTENR = *BLANK;
            EXFLPOFLDN = 'DSWAOUTENR';
          WHEN DSWAOULAND = *BLANK;
            EXFLPOFLDN = 'DSWAOULAND';
          OTHER;
            EXFLPOFLDN = 'DSWAOUWEBS';
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
         WKFENR = '0000';
         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;

         WHEN EXFLPOKZIO = *OFF;
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWAOUTENR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWAOULAND';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON
           AND FLDNAM = 'DSWAOUWEBS';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWAOUTENR';

         WHEN FLDNAM = 'DSWAOUTENR';
           EXSR MCWAOUTENR;

         WHEN FLDNAM = 'DSWAOULAND';
           EXSR MCWAOULAND;

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

         WKFENR = '0000';
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
           WHEN FLDNAM = 'DSWAOUTENR'
             AND C#LCK1 = *OFF;
             EXSR PRWAOUTENR;
           WHEN FLDNAM = 'DSWAOULAND'
             AND C#LCK1 = *OFF;
             EXSR PRWAOULAND;
           WHEN FLDNAM = 'DSWAOUWEBS'
             AND C#LCK0 = *OFF;
             EXSR PRWAOUWEBS;
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';

         WHEN PCPGST = '2     '
           OR PCPGST = '      ';
           KYWAOUTENR = DSWAOUTENR;
           KYWAOULAND = DSWAOULAND;
           CHIDS = '01C';
           EXSR CHWAOU;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWAOUTENR';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWAOUTENR';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = '0000';

       ENDSR;

       //*************************************************************************
       //**  Update Datei TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WAOU';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WAOU;

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
       //**  Kopieren Sätze aus Datei WAOU                                     ***
       //*************************************************************************
       BEGSR KWAOU;

         KYWAOUTENR = DSWAOUTENR;
         KYWAOULAND = DSWAOULAND;
         CHIDS = '01C';
         EXSR CHWAOU;

         IF WKFENR = *ZERO;
           DSWAOUWEBS = WAOUWEBS;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WAOU-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWAOU;

         OFWAOUTENR = KYWAOUTENR;
         OFWAOULAND = KYWAOULAND;
         CHIDS = '01+';
         EXSR CHWAOU;
         WKFENR = '0000';

         DOW CHI(5) = 'J'
           AND WAOUFIRM = KYWAOUFIRM
           AND WAOUTENR <= OFWAOUTENR
           AND WAOULAND <= OFWAOULAND;

           IF WAOULOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WAOULOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWAOU;
           WKFENR = '0000';

         ENDDO;

         CLEAR RTWAOU;
         RTWAOUPROG = WKPROG;
         RTWAOUDANA = WKDANA;
         RTWAOUFFLD = WKFFLD;
         RTWAOUFENR = WKFENR;
         RTWAOUPA03 = W$PA03;
         RTWAOUPA04 = W$PA04;
         RTWAOUPA05 = W$PA05;
         RTWAOUPA06 = W$PA06;
         RTWAOUPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WAOU                                          ***
       //*************************************************************************
       BEGSR LWAOU;

         OFWAOUTENR = KYWAOUTENR;
         OFWAOULAND = KYWAOULAND;
         CHIDS = '01+';
         EXSR CHWAOU;
         WKFENR = '0000';

         DOW CHI(5) = 'J'
           AND WAOUFIRM = KYWAOUFIRM
           AND WAOUTENR <= OFWAOUTENR
           AND WAOULAND <= OFWAOULAND;

           EXSR LPOSI;

           KYWAOUTENR = WAOUTENR;
           KYWAOULAND = WAOULAND;
           CHIDS = '01CU';
           EXSR CHWAOU;

           CHIDS = '01D';
           EXSR CHWAOU;

           CHIDS = '01R';
           EXSR CHWAOU;
           WKFENR = '0000';

         ENDDO;

         CLEAR RTWAOU;
         RTWAOUPROG = WKPROG;
         RTWAOUDANA = WKDANA;
         RTWAOUFFLD = WKFFLD;
         RTWAOUFENR = WKFENR;
         RTWAOUPA03 = W$PA03;
         RTWAOUPA04 = W$PA04;
         RTWAOUPA05 = W$PA05;
         RTWAOUPA06 = W$PA06;
         RTWAOUPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen der abhängigen Sätze                                      ***
       //*************************************************************************
       BEGSR LPOSI;

         WKFENR = '0000';

         PCPGST = '4      ';
         EXSR TRCRKD;

       ENDSR;

       //*************************************************************************
       //**  Prüfen Dateifelder                                                ***
       //*************************************************************************
       BEGSR PRAUFR;

         WKFENR = '0000';

         DSWAOUWEBS = EXWAOUWEBS;

         SELECT;
         WHEN EXWAOUFLDN = 'WAOUWEBS';
           EXSR PRWAOUWEBS;
         OTHER;
           %SUBST(WKFLPORECN:1:8) = 'TRWAOU01';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDSL;

         IF WKFENR <> *ZERO;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWAOU;
         RTWAOUPROG = WKPROG;
         RTWAOUDANA = WKDANA;
         RTWAOUFFLD = WKFFLD;
         RTWAOUFENR = WKFENR;
         RTWAOUPA03 = W$PA03;
         RTWAOUPA04 = W$PA04;
         RTWAOUPA05 = W$PA05;
         RTWAOUPA06 = W$PA06;
         RTWAOUPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWAOU;

         IF EXWAOUIFKZ = '0';

           // Satz auf Existenz prüfen
           KYWAOUTENR = EXWAOUTENR;
           KYWAOULAND = EXWAOULAND;
           CHIDS = '01C';
           EXSR CHWAOU;

           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;

         ENDIF;

         EXSR B01DS;

         IF EXWAOUWEBS <> *BLANK;
           DSWAOUWEBS = EXWAOUWEBS;
         ENDIF;

         %SUBST(WKFLPORECN:1:8) = 'TRWAOU01';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR UWAOU;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWAOU;
         RTWAOUPROG = WKPROG;
         RTWAOUDANA = WKDANA;
         RTWAOUFFLD = WKFFLD;
         RTWAOUFENR = WKFENR;
         RTWAOUPA03 = W$PA03;
         RTWAOUPA04 = W$PA04;
         RTWAOUPA05 = W$PA05;
         RTWAOUPA06 = W$PA06;
         RTWAOUPA07 = W$PA07;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WAOULOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWAOU;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WAOU                                                 ***
       //*************************************************************************
       BEGSR UWAOU;

         KYWAOUTENR = DSWAOUTENR;
         KYWAOULAND = DSWAOULAND;

         IF PCPGST = '3     ';
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWAOU;

         WAOUWEBS = DSWAOUWEBS;

         WAOUJNAM = DAJNAM;
         WAOUPROG = DAPROG;
         WAOUBIBL = WKCHPL;
         WAOUUSER = DAUSER;

         WKTDAT = %DATE;
         WAOUJZEI = %DEC(%TIME());
         WAOUJDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWAOU;

         WHEN CHI(6) = *ON;
           C_EXTSTP(WAOUTSTP);
           WAOUERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWAOU;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWAOU;

           #CRTCD = 'U';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  ANZEIGEN  IDENT-STAMM                                             ***
       //*************************************************************************
       BEGSR MCWAOUTENR;

         C#WNDW = *ON;

         IF DSWAOUTENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWAOUTENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOUTENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PRÜFEN IDENT-NR                                                   ***
       //*************************************************************************
       BEGSR PRWAOUTENR;

         EXFLPOFLDN = 'DSWAOUTENR';

         KYTENR = DSWAOUTENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

         IF WKFENR = *ZERO;
           DSWAOUTENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ANZEIGE LÄNDER-STAMM                                              ***
       //*************************************************************************
       BEGSR MCWAOULAND;

         C#WNDW = *ON;

         IF DSWAOULAND = *BLANK;
           TXWAOULAND = *BLANK;
         ENDIF;

         %SUBST(KOMDS:1) = DSWAOULAND;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOULAND = LNLDNR;
           EXSR PRWAOULAND;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PRÜFEN LAND-NR                                                    ***
       //*************************************************************************
       BEGSR PRWAOULAND;

         EXFLPOFLDN = 'DSWAOULAND';

         %SUBST(KOMDS:1) = DSWAOULAND;
         EXSR PRLANDLAND;
         TXWAOULAND = %SUBST(KOMDS:8);

       ENDSR;

       //*************************************************************************
       //**  PRÜFEN WEB-ADRESSE                                                ***
       //*************************************************************************
       BEGSR PRWAOUWEBS;

         EXFLPOFLDN = 'DSWAOUWEBS';


       ENDSR;

       //*************************************************************************
       //**  ANZEIGEN  KAMPAGNEN-MANAGEMENT-DOKUMENT                           ***
       //*************************************************************************
       BEGSR MCAUFRCRKD;

         %SUBST(KOMDS:01) = 'WAOU';
         DUC026 = %CHAR(WAOUTSTP);
         %SUBST(KOMDS:11:26) = DUC026;
         #CPGST = *BLANK;
         IF WKPGST = '5     ';
           #CPGST = '5     ';
         ENDIF;
         #CUEBE = *BLANK;
         EXSR MCCRKD;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Musterdatei                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WAOU';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;
           WAOU = TRMUDATA;

           CLEAR EXDATA;
           EXDATAFILE = 'WAOU';
           EXDATADATA = WAOU;
           C_INZDATASTR(EXDATA:RTDATA);
           WAOU = RTDATADATA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI CRKD                                                 ***
       //*************************************************************************
       BEGSR TRCRKD;

         CLEAR EXCRKD;
         EXCRKDPGST = PCPGST;
         EXCRKDDANA = 'WAOU';
      /END-FREE
     C                   MOVE      WAOUTSTP      DUC026
      /FREE
         EXCRKDDAKY = DUC026;

         C_TRCRKD(EXCRKD:RTCRKD);
         WKPROG = RTCRKDPROG;
         WKDANA = RTCRKDDANA;
         WKFFLD = RTCRKDFFLD;
         WKFENR = RTCRKDFENR;
         W$PA03 = RTCRKDPA03;
         W$PA04 = RTCRKDPA04;
         W$PA05 = RTCRKDPA05;
         W$PA06 = RTCRKDPA06;
         W$PA07 = RTCRKDPA07;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWAOU;


       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWAOU';
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
         WKFENR = '0000';
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;

           CLEAR EXTRDN;
           EXTRDNPGST = WKPGST;
           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;
           EXTRDNPGNA = 'TRWAOU';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWAOUB1'    EXTRDNPGNA
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

           WHEN EXTRDNDANA = 'MCCRKD';
             EXSR MCAUFRCRKD;

           ENDSL;

           IF EXTRDNPGST = 'DIREKT';
             WKPGST = 'WEITER';
             WKFENR = '0000';
           ENDIF;

           IF EXTRDNPGST = 'WEITER';
             WKPGST = 'WEITER';
             WKFENR = '0000';
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
         PGMNAM = 'TRWAOU';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOUW2;
         OTHER;
           WRITE TRWAOUCT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOUW2;
         OTHER;
           WRITE TRWAOUCT;
         ENDSL;

         W$PA03 = *BLANK;
         W$PA04 = *BLANK;
         W$PA05 = *BLANK;
         W$PA06 = *BLANK;
         W$PA07 = *BLANK;
         W$PA08 = *BLANK;
         WKFENR = '0000';

       ENDSR;

       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWAOU
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCCRKD
      /COPY QCPYSRC,MCLAND
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRLANDLAND
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO

       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
