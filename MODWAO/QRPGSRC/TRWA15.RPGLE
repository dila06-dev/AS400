     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2021')
      //*************************************************************************
      /TITLE Verwalten Datei WA15
      //*************************************************************************
      //  Copyright 2021 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: JK 31.08.2021 DOMETIC Projekt 16637
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA15.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA15FM  CF   E             WORKSTN USROPN
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
     D WA15          E DS                  INZ
     D KYWA15        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

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

     D EXTREND       E DS
     D RTTREND       E DS

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
     D EXWA15IFKZ      S              1
     D OFWA15LFNR      S                   LIKE(KYWA15LFNR)
     D OFWA15VSBD      S                   LIKE(KYWA15VSBD)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
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
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
      /FREE
       EXSR UEBTREND;
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
           CLOSE TRWA15FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';

       WHEN PCPGST = 'PWA15 ';
         EXSR PWA15;
         WKIFMT = '00';

       WHEN PCPGST = '4     ';
         EXSR PWA15;

         IF WKFENR = *ZERO;
           EXSR LWA15;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = 'PRWA15';
         EXSR PRWA15;
         WKIFMT = '00';

       WHEN PCPGST = 'PWA15L';
         EXSR PWA15L;
         WKIFMT = '00';

       WHEN EXWA15IFKZ <> *BLANK;                                               // EXTERNES
         EXSR IFWA15;                                                           // UPDATE
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
           OPEN(E) TRWA15FM;
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
         CLOSE(E) TRWA15FM;
         WKIOKZ = *OFF;
       ENDIF;

       RTTRNDRTCD = #CRTCD;

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
         KYWA15FIRM = DAFIRM;  // WA15
         KYLFFI = DAFIRM;      // LIEF
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA15FM';

         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA15FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXTREND                        ***
       //*************************************************************************
       BEGSR UEBTREND;

        CLEAR EXDATA;
        EXDATAFILE = 'EXTREND';
        EXDATADATA = EXTREND;
        C_INZDATASTR(EXDATA:RTDATA);
        EXTREND = RTDATADATA;

        PCPGST = EXTRNDPGST;

        KYWA15LFNR = %SUBST(EXTRNDKEYB:01);

        DSWA15LFNR = %SUBST(EXTRNDKEYB:01);

        KYWA15VSBD = %SUBST(EXTRNDKEYB:11);

        DSWA15VSBD = %SUBST(EXTRNDKEYB:11);

        DSWA15NLFN = %SUBST(EXTRNDNKEY:01);
        DSWA15NVSB = %SUBST(EXTRNDNKEY:11);

        EXWA15IFKZ = %SUBST(EXTRNDPRKZ:01);

        CLEAR RTTREND;
        RTTRNDFENR = *ZERO;

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

         EXTRDNDANA = 'TRWA15';
         EXSR RDTRDNTRDN;
         //DSKOPF = %SUBST(EXFIRMKNAM:1:30) + ' ' + EXTRDNTEXT;
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

          WKFLPORECN = 'TRWA1501';
          EXSR EFLPO;
          WRITE TRWA15W1;
          WRITE TRWA1501;
          WRITE W1WA15B1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          //FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          IF WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDIF;

          C#WNDW = *OFF;

          READ(E) TRWA1501;
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

            EXSR UWA15;

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
            CLEAR KYWA15LFNR;
            CLEAR KYWA15VSBD;
            EXSR B01DS;
          ENDIF;

        ENDDO;

        SELECT;
        WHEN PCPGST = 'F     ';
          CHIDS = '01F';
          EXSR CHWA15;
        WHEN #CRTCD = 'N';
          CHIDS = '01CF';
          EXSR CHWA15;
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
          CLEAR WA15;
          EXSR EWA15;
          WA15LFNR = KYWA15LFNR;
          WA15VSBD = KYWA15VSBD;

        OTHER;
          CHIDS = '01C';
          EXSR CHWA15;

          EXINFOFILE = 'WA15';
          EXINFODATA = %ADDR(WA15);
          C_TRINFO(EXINFO:DSINFO);

          WKUSER = WA15USER;
          WKJDAT = WA15JDAT;
          WKJZEI = WA15JZEI;

          IF PCPGST = '2     ';
            CHIDS = '01CL';
            EXSR CHWA15;
            EXSR EWA15;
          ENDIF;

        ENDSL;

        IF CHI(5) = 'L';
          PCPGST = 'F     ';
        ENDIF;

        DSWA15LFNR = WA15LFNR;
        DSWA15VSBD = WA15VSBD;
        DSWA15VSTA = WA15VSTA;

        // Initialisieren der Textfelder
        DSLIEFNAM1 = *BLANK;
        DSTRTPTXT1 = *BLANK;

        // Füllen der Textfelder mit Interpretationen
        IF DSWA15LFNR <> *BLANK;
          EXSR PRWA15LFNR;
        ENDIF;

        IF DSWA15VSBD <> *BLANK;
          EXSR PRWA15VSBD;
        ENDIF;

        DSWA15VSTA = WA15VSTA;

        EXTRPBBFMT = 'TRWA1501';
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
          EXFLPOFLDN = 'DSWA15VSTA';

          IF RTTRPBCUSR <> *BLANK;
            EXFLPOFLDN = RTTRPBCUSR;
          ENDIF;

        WHEN PCPGST = 'MUSTER';
          C#LCK1 = *ON;
          EXFLPOFLDN = 'DSWA15LFNR';

        WHEN PCPGST = 'F     ';
          WKFENR = '0001';
          C#LCK0 = *ON;
          C#LCK1 = *ON;

        OTHER;
          EXFLPOFLDN = 'DSWA15LFNR';

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
           WKFLPORECN = 'TRWA15K1';
           EXSR EFLPO;
           WRITE TRWA15W2;
           WRITE TRWA15K1;
           WRITE W2WA15B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA15K1;

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

           EXSR KWA15;
           EXSR UWA15;
           %SUBST(RTTRNDKEYB:01) = KYWA15LFNR;
           %SUBST(RTTRNDKEYB:11) = KYWA15VSBD;
           WKIFMT = '00';
         ENDDO;

         RTTRNDRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA15LFNR = KYWA15LFNR;

         DSWA15NLFN = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA15NLFN';

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
           AND FLDNAM = 'DSWA15LFNR';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA15LFNR';

         WHEN FLDNAM = 'DSWA15LFNR';
           EXSR MCWA15LFNR;

         WHEN FLDNAM = 'DSWA15VSBD';
           EXSR MCWA15VSBD;

         WHEN FLDNAM = 'DSWA15NLFN';
           EXSR MCWA15NLFN;

         WHEN FLDNAM = 'DSWA15NVSB';
           EXSR MCWA15NVSB;

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
           WHEN FLDNAM = 'DSWA15LFNR'
             AND C#LCK1 = *OFF;
             EXSR PRWA15LFNR;

           WHEN FLDNAM = 'DSWA15VSBD'
             AND C#LCK1 = *OFF;
             EXSR PRWA15VSBD;

           WHEN FLDNAM = 'DSWA15NLFN';
             EXSR PRWA15NLFN;

           WHEN FLDNAM = 'DSWA15NVSB';
             EXSR PRWA15NVSB;
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA15LFNR = DSWA15NLFN;
           KYWA15LFNR = DSWA15NVSB;
           CHIDS = '01C';
           EXSR CHWA15;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA15NLFN';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA15LFNR = DSWA15LFNR;
           KYWA15VSBD = DSWA15VSBD;
           CHIDS = '01C';
           EXSR CHWA15;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA15LFNR';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA15LFNR';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA15';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA15;

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
       //**  Kopieren Sätze aus Datei WA15                                     ***
       //*************************************************************************
       BEGSR KWA15;

         KYWA15LFNR = DSWA15LFNR;
         KYWA15VSBD = DSWA15VSBD;
         CHIDS = '01C';
         EXSR CHWA15;
         IF WKFENR = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA15-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA15;

         OFWA15LFNR = KYWA15LFNR;
         CHIDS = '01+';
         EXSR CHWA15;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA15FIRM = KYWA15FIRM
           AND WA15LFNR <= OFWA15LFNR;

           IF WA15LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA15LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA15;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTTREND;
         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen Sätze Datei WA15                                          ***
       //*************************************************************************
       BEGSR LWA15;

         OFWA15LFNR = KYWA15LFNR;
         CHIDS = '01+';
         EXSR CHWA15;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA15FIRM = KYWA15FIRM
           AND WA15LFNR  <= OFWA15LFNR;

           EXSR LPOSI;

           KYWA15LFNR = WA15LFNR;
           CHIDS = '01CU';
           EXSR CHWA15;

           CHIDS = '01D';
           EXSR CHWA15;

           CHIDS = '01R';
           EXSR CHWA15;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTTREND;
         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

       ENDSR;

       //*************************************************************************
       //**  Löschen der abhängigen Sätze                                      ***
       //*************************************************************************
       BEGSR LPOSI;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWA15;

         IF EXWA15IFKZ = '0';

           // Satz auf Existenz prüfen
           KYWA15LFNR = %SUBST(EXTRNDKEYB:01);
           CHIDS = '01C';
           EXSR CHWA15;

           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;

         ENDIF;

         EXSR B01DS;

         WKFLPORECN = 'TRWA1501';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR UWA15;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTTREND;
         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WA15LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA15;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA15                                                 ***
       //*************************************************************************
       BEGSR UWA15;

         KYWA15LFNR = DSWA15LFNR;
         KYWA15VSBD = DSWA15VSBD;

         IF PCPGST = '3     ';
           KYWA15LFNR = DSWA15NLFN;
           KYWA15VSBD = DSWA15NVSB;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA15;

         WA15VSTA = DSWA15VSTA;

         WA15JNAM = DAJNAM;
         WA15PROG = DAPROG;
         WA15BIBL = WKCHPL;
         WA15USER = DAUSER;
         WA15JZEI = %DEC(%TIME());
         WA15JDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA15;

         WHEN CHI(6) = *ON;

           CHIDS = '01W';
           EXSR CHWA15;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA15;

           #CRTCD = 'U';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine LFNR                                                   ***
       //*************************************************************************
       BEGSR MCWA15LFNR;

         C#WNDW = *ON;

         IF DSWA15LFNR = *BLANK;
           DSLIEFNAM1= *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA15LFNR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCLIEF;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA15LFNR = LFLFNR;
           DSLIEFNAM1 = LFNAM1;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine LFNR                                                   ***
       //*************************************************************************
       BEGSR PRWA15LFNR;

         EXFLPOFLDN = 'DSWA15LFNR';

         KYLFNR = DSWA15LFNR;
         CHIDS = '01C';
         EXSR CHLIEF;
         DSWA15LFNR = LFLFNR;
         DSLIEFNAM1 = LFNAM1;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NLFN                                                   ***
       //*************************************************************************
       BEGSR MCWA15NLFN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA15NLFN;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCLIEF;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA15NLFN = LFLFNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NLFN                                                   ***
       //*************************************************************************
       BEGSR PRWA15NLFN;

         EXFLPOFLDN = 'DSWA15NLFN';

         KYLFNR = DSWA15NLFN;
         CHIDS = '01C';
         EXSR CHLIEF;
         DSWA15NLFN = LFLFNR;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine VSBD                                                   ***
       //*************************************************************************
       BEGSR MCWA15VSBD;
         KOM = *BLANK;
         %SUBST(KOMDS:01:1) = DASPCD;
         %SUBST(KOMDS:02:4) = 'VSBD';
         %SUBST(KOMDS:12:3) = DSWA15VSBD;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
         AND WKFENR = *ZERO;
           DSWA15VSBD = TPTCDE;
           DSTRTPTXT1 = TPTTXT;
           WKTRTP = *ON;
         ENDIF;
       ENDSR;

       //*************************************************************************
       //**  MC-Routine NVSB                                                   ***
       //*************************************************************************
       BEGSR MCWA15NVSB;
         KOM = *BLANK;
         %SUBST(KOMDS:01:1) = DASPCD;
         %SUBST(KOMDS:02:4) = 'VSBD';
         %SUBST(KOMDS:12:3) = DSWA15NVSB;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
         AND WKFENR = *ZERO;
           DSWA15NVSB = TPTCDE;
           WKTRTP = *ON;
         ENDIF;
       ENDSR;

       //*************************************************************************
       //**  Prüf-Routine VSBD                                                 ***
       //*************************************************************************
       BEGSR PRWA15VSBD;
         KYTPTA = 'VSBD';
         KYTPTC = DSWA15VSBD;
         CHIDS  = '01C';
         EXSR CHTRTP;
         DSTRTPTXT1 = TPTTXT;

         EXFLPOFLDN = 'DSWA15VSBD';

         IF WKFENR <> *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüf-Routine NVSB                                                 ***
       //*************************************************************************
       BEGSR PRWA15NVSB;
         KYTPTA = 'VSBD';
         KYTPTC = DSWA15NVSB;
         CHIDS  = '01C';
         EXSR CHTRTP;

         EXFLPOFLDN = 'DSWA15NVSB';

         IF WKFENR <> *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen existenz einer Lieferant/Versandbedingungs definition      ***
       //*************************************************************************
       BEGSR PRWA15;

         CHIDS = '01C';
         EXSR CHWA15;
         IF CHI(5) = 'J';
           #CRTCD = 'J';
         ELSE;
           #CRTCD = 'N';
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  Prüfen existenz einer Lieferant/Versandbedingungs definition      ***
       //*************************************************************************
       BEGSR PWA15L;

         CHIDS = '01+';
         EXSR CHWA15;
         IF CHI(5) = 'J';
           #CRTCD = 'J';
         ELSE;
           #CRTCD = 'N';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Daten aus Musterdatei                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA15';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;
           WA15 = TRMUDATA;

           CLEAR EXDATA;
           EXDATAFILE = 'WA15';
           EXDATADATA = WA15;
           C_INZDATASTR(EXDATA:RTDATA);
           WA15 = RTDATADATA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA15;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA15';
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
           EXTRDNPGNA = 'TRWA15';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA15B1'    EXTRDNPGNA
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
         PGMNAM = 'TRWA15';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTWA15W1;
         WHEN WKIFMT = 'K1';
           WRITE CTWA15W2;
         OTHER;
           WRITE TRWA15CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTWA15W1;
         WHEN WKIFMT = 'K1';
           WRITE CTWA15W2;
         OTHER;
           WRITE TRWA15CT;
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
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA15
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCLIEF
      /COPY QCPYSRC,MCTRPC
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
      /END-FREE
