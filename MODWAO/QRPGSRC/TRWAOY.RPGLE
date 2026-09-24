     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2021')
      //*************************************************************************
      /TITLE Verwalten Datei WAOY
      //*************************************************************************
      //  Copyright 2021 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 01.03.2021 Projekt 16393-01
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WAOY.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWAOYFM  CF   E             WORKSTN USROPN
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
     D WAOY          E DS                  INZ
     D KYWAOY        E DS                  INZ

     D LAND          E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

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
     D EXTRPC        E DS                  INZ

     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXWAOY        E DS
     D RTWAOY        E DS

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

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
     D OFWAOYLAND      S                   LIKE(KYWAOYLAND)
     D OFWAOYTENR      S                   LIKE(KYWAOYTENR)
     D WKWAOYLAND      S                   LIKE(KYWAOYLAND)
     D WKWAOYEASC      S                   LIKE(WAOYEASC)
     D WKPROG          S                   LIKE(RTWAOYPROG)
     D WKDANA          S                   LIKE(RTWAOYDANA)
     D WKFFLD          S                   LIKE(RTWAOYFFLD)
     D WKFEAT          S              1
     D WKFENR          S              4
     D WKINFO          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10
     D W$MSGA          S              3

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WAOYTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WAOYTSTP                          LIKE(WAOYTSTP)

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
      // Parameter:      #W$MSGA
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
     D  #W$MSGA                            LIKE(W$MSGA)
     D                                     OPTIONS(*NOPASS)

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
     C                   PARM                    EXWAOY
     C                   PARM                    RTWAOY
      /FREE
       EXSR UEBWAOY;
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
           CLOSE TRWAOYFM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';

       WHEN PCPGST = 'PWAOY ';
         EXSR PWAOY;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWAOY;

         IF WKFENR = *ZERO;
           EXSR LWAOY;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = 'PRAUFR';                                                  // EXTERNE PRÜFUNG
         EXSR PRAUFR;
         WKIFMT = '00';
       WHEN EXWAOYIFKZ <> *BLANK;                                               // EXTERNES
         EXSR IFWAOY;                                                           // UPDATE
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
           OPEN(E) TRWAOYFM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
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
         CLOSE(E) TRWAOYFM;
         WKIOKZ = *OFF;
       ENDIF;

       RTWAOYRTCD = #CRTCD;

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
         KYWAOYFIRM = DAFIRM;  // WAOY
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWAOYFM';

         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWAOYFM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXWAOY                         ***
       //*************************************************************************
       BEGSR UEBWAOY;

        CLEAR EXDATA;
        EXDATAFILE = 'EXWAOY';
        EXDATADATA = EXWAOY;
        C_INZDATASTR(EXDATA:RTDATA);
        EXWAOY = RTDATADATA;

        PCPGST = EXWAOYPGST;

        KYWAOYLAND = EXWAOYLAND;
        KYWAOYTENR = EXWAOYTENR;

        DSWAOYLAND = EXWAOYLAND;
        DSWAOYTENR = EXWAOYTENR;

        DSWAOYNLND = EXWAOYNLND;
        DSWAOYNTEN = EXWAOYNTEN;

        CLEAR RTWAOY;
        RTWAOYFENR = *ZERO;

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

         EXTRDNDANA = 'TRWAOY';
         EXSR RDTRDNTRDN;
         DSKOPF = %SUBST(EXFIRMKNAM:1:30) + ' ' + EXTRDNTEXT;
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

          %SUBST(WKFLPORECN:1:8) = 'TRWAOY01';
          EXSR EFLPO;
          WRITE TRWAOY01;
          WRITE TRWAOYB1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          //FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          SELECT;
          WHEN WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDSL;

          C#WNDW = *OFF;

          READ(E) TRWAOY01;
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

            EXSR UWAOY;

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
            KYWAOYLAND = EXWAOYLAND;
            KYWAOYTENR = EXWAOYTENR;
            EXSR B01DS;
          ENDIF;

        ENDDO;

        SELECT;
        WHEN PCPGST = 'F     ';
          CHIDS = '01F';
          EXSR CHWAOY;
        WHEN #CRTCD = 'N';
          CHIDS = '01CF';
          EXSR CHWAOY;
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
          CLEAR WAOY;
          EXSR ETRMU;
          EXSR EWAOY;
          WAOYLAND = KYWAOYLAND;
          WAOYTENR = KYWAOYTENR;

        OTHER;
          CHIDS = '01C';
          EXSR CHWAOY;

          EXINFOFILE = 'WAOY';
          EXINFODATA = %ADDR(WAOY);
          C_TRINFO(EXINFO:DSINFO);

          WKUSER = WAOYUSER;
          WKJDAT = WAOYJDAT;
          WKJZEI = WAOYJZEI;

          IF PCPGST = '2     ';
            CHIDS = '01CL';
            EXSR CHWAOY;
            EXSR EWAOY;
          ENDIF;

        ENDSL;

        IF CHI(5) = 'L';
          PCPGST = 'F     ';
        ENDIF;

        DSWAOYLAND = WAOYLAND;
        DSWAOYTENR = WAOYTENR;
        DSWAOYEASC = WAOYEASC;

        // Initialisieren der Textfelder
        TXWAOYLAND = *BLANK;
        DSTEILTBZ1 = *BLANK;
        DSTEILTBZ2 = *BLANK;
        TXWAOYEASC = *BLANK;

        // Füllen der Textfelder mit Interpretationen
        IF DSWAOYLAND <> *BLANK;
          EXSR PRWAOYLAND;
        ENDIF;

        IF DSWAOYTENR <> *BLANK;
          EXSR PRWAOYTENR;
        ENDIF;

        IF DSWAOYEASC <> *BLANK;
          EXSR PRWAOYEASC;
        ENDIF;

        EXTRPBBFMT = 'TRWAOY01';
        EXSR CSTRPB;

        WKFENR = *ZERO;
        W$MSGA = *BLANK;
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
          EXFLPOFLDN = 'DSWAOYEASC';

          IF RTTRPBCUSR <> *BLANK;
            EXFLPOFLDN = RTTRPBCUSR;
          ENDIF;

        WHEN PCPGST = 'MUSTER';
          C#LCK1 = *ON;
          EXFLPOFLDN = 'DSWAOYEASC';

        WHEN PCPGST = 'F     ';
          WKFENR = '0001';
          C#LCK0 = *ON;
          C#LCK1 = *ON;

        OTHER;
          SELECT;
          WHEN DSWAOYLAND = *BLANK;
            EXFLPOFLDN = 'DSWAOYLAND';
          WHEN DSWAOYTENR = *BLANK;
            EXFLPOFLDN = 'DSWAOYTENR';
          OTHER;
            EXFLPOFLDN = 'DSWAOYEASC';
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
       //**  Steuerroutine BILDK1                                              ***
       //*************************************************************************
       BEGSR BILDK1;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR BK1DS;

         DOW WKIFMT = 'K1';
           WKFLPORECN = 'TRWAOYK1';
           EXSR EFLPO;
           WRITE TRWAOYW2;
           WRITE TRWAOYK1;
           WRITE W2WAOYB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWAOYK1;

           IF %ERROR OR %EOF;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON AND FUKT04 = *ON;
             EXSR MCAUFR;
             IF WKTRTP = *ON
               OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           EXSR BILDPR;
           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR KWAOY;
           //EXSR UWAOY;
           RTWAOYLAND = KYWAOYLAND;
           IF DSWAOYNTEN <> *BLANK;
             RTWAOYTENR = KYWAOYTENR;
           ENDIF;
           WKIFMT = '00';
         ENDDO;

         RTWAOYRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWAOYLAND = KYWAOYLAND;
         DSWAOYTENR = KYWAOYTENR;

         DSWAOYNLND = KYWAOYLAND;
         DSWAOYNTEN = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWAOYNTEN';

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
           AND FLDNAM = 'DSWAOYLAND';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWAOYTENR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON
           AND FLDNAM = 'DSWAOYEASC';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWAOYLAND';

         WHEN FLDNAM = 'DSWAOYLAND';
           EXSR MCWAOYLAND;

         WHEN FLDNAM = 'DSWAOYTENR';
           EXSR MCWAOYTENR;

         WHEN FLDNAM = 'DSWAOYEASC';
           EXSR MCWAOYEASC;

         WHEN FLDNAM = 'DSWAOYNLND';
           EXSR MCWAOYNLND;

         WHEN FLDNAM = 'DSWAOYNTEN';
           EXSR MCWAOYNTEN;

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
           WHEN FLDNAM = 'DSWAOYTENR'
             AND C#LCK1 = *OFF;
             EXSR PRWAOYTENR;
           WHEN FLDNAM = 'DSWAOYLAND'
             AND C#LCK1 = *OFF;
             EXSR PRWAOYLAND;
           WHEN FLDNAM = 'DSWAOYEASC'
             AND C#LCK0 = *OFF;
             EXSR PRWAOYEASC;
           WHEN FLDNAM = 'DSWAOYNLND';
             EXSR PRWAOYNLND;
           WHEN FLDNAM = 'DSWAOYNTEN';
             EXSR PRWAOYNTEN;
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWAOYLAND = DSWAOYNLND;
           KYWAOYTENR = DSWAOYNTEN;
           CHIDS = '01C';
           EXSR CHWAOY;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWAOYNTEN';
             LEAVESR;
           ENDIF;

           KYWAOYLAND = DSWAOYLAND;
           CLEAR KYWAOYTENR;
           CHIDS = '01+';
           EXSR CHWAOY;
           IF WKFENR = 'N'
             OR WAOYFIRM <> KYWAOYFIRM
             OR WAOYLAND <> KYWAOYLAND;
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWAOYTENR';
             LEAVESR;
           ENDIF;

           IF DSWAOYNLND <> DSWAOYLAND;
             WKWAOYLAND = DSWAOYNLND;
             WKWAOYEASC = WAOYEASC;
             EXSR PREASC;
             IF WKFENR <> *ZERO;
               EXFLPOFLDN = 'DSWAOYNLND';
               LEAVESR;
             ENDIF;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWAOYTENR = DSWAOYTENR;
           KYWAOYLAND = DSWAOYLAND;
           CHIDS = '01C';
           EXSR CHWAOY;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWAOYTENR';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWAOYTENR';
             LEAVESR;
           ENDSL;

           WKWAOYLAND = DSWAOYLAND;
           WKWAOYEASC = DSWAOYEASC;
           EXSR PREASC;
           IF WKFENR <> *ZERO;
             EXFLPOFLDN = 'DSWAOYEASC';
             LEAVESR;
           ENDIF;

         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WAOY';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WAOY;

         TRMUJNAM = DAJNAM;
         TRMUPROG = WKCHPN;
         TRMUBIBL = WKCHPL;
         TRMUUSER = DAUSER;
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
       //**  Kopieren Sätze aus Datei WAOY                                     ***
       //*************************************************************************
       BEGSR KWAOY;

         KYWAOYLAND = DSWAOYLAND;
         OFWAOYLAND = DSWAOYLAND;
         KYWAOYTENR = DSWAOYTENR;
         OFWAOYTENR = DSWAOYTENR;
         IF DSWAOYTENR = *BLANK;
           OFWAOYTENR = *HIVAL;
         ENDIF;
         CHIDS = '00+';
         EXSR CHWAOY;
         DOW CHI(5) = 'J'
           AND WAOYFIRM = KYWAOYFIRM
           AND WAOYLAND <= OFWAOYLAND
           AND WAOYTENR <= OFWAOYTENR;

           DSWAOYEASC = WAOYEASC;

           EXSR UWAOY;

           CHIDS = '00R';
           EXSR CHWAOY;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WAOY-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWAOY;

         OFWAOYLAND = KYWAOYLAND;
         OFWAOYTENR = KYWAOYTENR;
         CHIDS = '01+';
         EXSR CHWAOY;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WAOYFIRM = KYWAOYFIRM
           AND WAOYLAND <= OFWAOYLAND
           AND WAOYTENR <= OFWAOYTENR;

           IF WAOYLOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WAOYLOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWAOY;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTWAOY;
         RTWAOYPROG = WKPROG;
         RTWAOYDANA = WKDANA;
         RTWAOYFFLD = WKFFLD;
         RTWAOYFENR = WKFENR;
         RTWAOYPA03 = W$PA03;
         RTWAOYPA04 = W$PA04;
         RTWAOYPA05 = W$PA05;
         RTWAOYPA06 = W$PA06;
         RTWAOYPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WAOY                                          ***
       //*************************************************************************
       BEGSR LWAOY;

         OFWAOYLAND = KYWAOYLAND;
         OFWAOYTENR = KYWAOYTENR;
         CHIDS = '01+';
         EXSR CHWAOY;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WAOYFIRM = KYWAOYFIRM
           AND WAOYLAND <= OFWAOYLAND
           AND WAOYTENR <= OFWAOYTENR;

           EXSR LPOSI;

           KYWAOYLAND = WAOYLAND;
           KYWAOYTENR = WAOYTENR;
           CHIDS = '01CU';
           EXSR CHWAOY;

           CHIDS = '01D';
           EXSR CHWAOY;

           CHIDS = '01R';
           EXSR CHWAOY;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTWAOY;
         RTWAOYPROG = WKPROG;
         RTWAOYDANA = WKDANA;
         RTWAOYFFLD = WKFFLD;
         RTWAOYFENR = WKFENR;
         RTWAOYPA03 = W$PA03;
         RTWAOYPA04 = W$PA04;
         RTWAOYPA05 = W$PA05;
         RTWAOYPA06 = W$PA06;
         RTWAOYPA07 = W$PA07;

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

         DSWAOYEASC = EXWAOYEASC;

         SELECT;
         WHEN EXWAOYFLDN = 'WAOYEASC';
           EXSR PRWAOYEASC;
         OTHER;
           WKFLPORECN = 'TRWAOY01';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDSL;

         IF WKFENR <> *ZERO;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWAOY;
         RTWAOYPROG = WKPROG;
         RTWAOYDANA = WKDANA;
         RTWAOYFFLD = WKFFLD;
         RTWAOYFENR = WKFENR;
         RTWAOYPA03 = W$PA03;
         RTWAOYPA04 = W$PA04;
         RTWAOYPA05 = W$PA05;
         RTWAOYPA06 = W$PA06;
         RTWAOYPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWAOY;

         IF EXWAOYIFKZ = '0';

           // Satz auf Existenz prüfen
           KYWAOYTENR = EXWAOYTENR;
           KYWAOYLAND = EXWAOYLAND;
           CHIDS = '01C';
           EXSR CHWAOY;

           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;

         ENDIF;

         EXSR B01DS;

         IF EXWAOYEASC <> *BLANK;
           DSWAOYEASC = EXWAOYEASC;
         ENDIF;

         WKFLPORECN = 'TRWAOY01';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR UWAOY;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTWAOY;
         RTWAOYPROG = WKPROG;
         RTWAOYDANA = WKDANA;
         RTWAOYFFLD = WKFFLD;
         RTWAOYFENR = WKFENR;
         RTWAOYPA03 = W$PA03;
         RTWAOYPA04 = W$PA04;
         RTWAOYPA05 = W$PA05;
         RTWAOYPA06 = W$PA06;
         RTWAOYPA07 = W$PA07;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WAOYLOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWAOY;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WAOY                                                 ***
       //*************************************************************************
       BEGSR UWAOY;

         KYWAOYTENR = DSWAOYTENR;
         KYWAOYLAND = DSWAOYLAND;

         IF PCPGST = '3     ';
           KYWAOYLAND = DSWAOYNLND;
           KYWAOYTENR = DSWAOYNTEN;
           IF DSWAOYNTEN = *BLANK;
             KYWAOYTENR = WAOYTENR;
           ENDIF;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWAOY;

         WAOYEASC = DSWAOYEASC;

         WAOYJNAM = DAJNAM;
         WAOYPROG = DAPROG;
         WAOYBIBL = WKCHPL;
         WAOYUSER = DAUSER;
         WAOYJZEI = %DEC(%TIME());
         WAOYJDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWAOY;

         WHEN CHI(6) = *ON;
           C_EXTSTP(WAOYTSTP);
           WAOYERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWAOY;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWAOY;

           #CRTCD = 'U';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Anzeige LAND                                                   ***
       //*************************************************************************
       BEGSR MCWAOYLAND;

         C#WNDW = *ON;

         IF DSWAOYLAND = *BLANK;
           TXWAOYLAND = *BLANK;
         ENDIF;

         %SUBST(KOMDS:1) = DSWAOYLAND;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOYLAND = LNLDNR;
           EXSR PRWAOYLAND;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine LAND                                                   ***
       //*************************************************************************
       BEGSR PRWAOYLAND;

         EXFLPOFLDN = 'DSWAOYLAND';

         %SUBST(KOMDS:1) = DSWAOYLAND;
         EXSR PRLANDLAND;
         TXWAOYLAND = %SUBST(KOMDS:8);

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCWAOYTENR;

         C#WNDW = *ON;

         IF DSWAOYTENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWAOYTENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOYTENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRWAOYTENR;

         EXFLPOFLDN = 'DSWAOYTENR';

         IF WKIFMT = 'K1' AND DSWAOYTENR = *BLANK AND DSWAOYNTEN = *BLANK;
           LEAVESR;
         ENDIF;

         KYTENR = DSWAOYTENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWAOYTENR = TETENR;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine EASC                                                   ***
       //*************************************************************************
       BEGSR MCWAOYEASC;

         C#WNDW = *ON;

         IF DSWAOYEASC = *BLANK;
           TXWAOYEASC = *BLANK;
         ENDIF;

         CLEAR EXTRPC;
         EXTRPCPGST = '5     ';
         EXTRPCPGGR = 'EASCWAOY';
         EXTRPCCODE = DSWAOYEASC;
         EXTRPCUEBE = '0010';
         EXSR MCTRPC;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOYEASC = EXTRPCCODE;
           TXWAOYEASC = EXTRPCTEXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine EASC                                                   ***
       //*************************************************************************
       BEGSR PRWAOYEASC;

         EXFLPOFLDN = 'DSWAOYEASC';

         EXTRPCPGGR = 'EASCWAOY';
         EXTRPCCODE = DSWAOYEASC;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         TXWAOYEASC = EXTRPCTEXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Anzeige NLND                                                   ***
       //*************************************************************************
       BEGSR MCWAOYNLND;

         C#WNDW = *ON;

         %SUBST(KOMDS:1) = DSWAOYNLND;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOYNLND = LNLDNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NLND                                                   ***
       //*************************************************************************
       BEGSR PRWAOYNLND;

         EXFLPOFLDN = 'DSWAOYNLND';

         %SUBST(KOMDS:1) = DSWAOYNLND;
         EXSR PRLANDLAND;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR MCWAOYNTEN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWAOYNTEN;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOYNTEN = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR PRWAOYNTEN;

         EXFLPOFLDN = 'DSWAOYNTEN';

         IF DSWAOYNTEN = *BLANK AND DSWAOYTENR = *BLANK;
           LEAVESR;
         ENDIF;

         KYTENR = DSWAOYNTEN;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWAOYNTEN = TETENR;

       ENDSR;

       //*************************************************************************
       //**  Prüfen bereits vorhandene Hinterlegungen für das Land auf         ***
       //**  Ein-/Ausschluss                                                   ***
       //*************************************************************************
       BEGSR PREASC;

         KYWAOYLAND = WKWAOYLAND;
         CLEAR KYWAOYTENR;
         CHIDS = '01+';
         EXSR CHWAOY;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WAOYFIRM = KYWAOYFIRM
           AND WAOYLAND = KYWAOYLAND;

           IF PCPGST = '2     ' AND WAOYTENR = DSWAOYTENR;
             CHIDS = '01R';
             EXSR CHWAOY;
             WKFENR = *ZERO;
             ITER;
           ENDIF;

           IF WAOYEASC = WKWAOYEASC;
             LEAVE;
           ENDIF;

           IF WAOYEASC = '1';
             // Das Land hat bereits eine Einschluss-Hinterlegung
             WKFENR = '0354';
             W$MSGA = '#MO';
             LEAVE;
           ELSE;
             // Das Land hat bereits eine Ausschluss-Hinterlegung
             WKFENR = '0355';
             W$MSGA = '#MO';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWAOY;
           WKFENR = *ZERO;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Musterdatei                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WAOY';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;
           WAOY = TRMUDATA;

           CLEAR EXDATA;
           EXDATAFILE = 'WAOY';
           EXDATADATA = WAOY;
           C_INZDATASTR(EXDATA:RTDATA);
           WAOY = RTDATADATA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWAOY;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWAOY';
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
           EXTRDNPGNA = 'TRWAOY';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWAOYB1'    EXTRDNPGNA
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
         W$PA06:W$PA07:W$MSGA);
         PGMNAM = 'TRWAOY';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOYW2;
         OTHER;
           WRITE TRWAOYCT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOYW2;
         OTHER;
           WRITE TRWAOYCT;
         ENDSL;

         W$PA03 = *BLANK;
         W$PA04 = *BLANK;
         W$PA05 = *BLANK;
         W$PA06 = *BLANK;
         W$PA07 = *BLANK;
         W$PA08 = *BLANK;
         W$MSGA = *BLANK;
         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWAOY
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCLAND
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRLANDLAND
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
