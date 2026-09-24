     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2021')
      //*************************************************************************
      /TITLE Verwalten Datei WA14
      //*************************************************************************
      //  Copyright 2021 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 30.04.2021 DOMETIC Projekt 16416-01
      //  -----------------------------------------------------------------------
      //  Änderung: ZG 08.11.2021 Service#: 20211105-005 Dometic: lange Laufzeit
      //            Kein Aufruf INZDATASTR für PGM-Status "PRWA14"
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA14.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA14FM  CF   E             WORKSTN USROPN
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
     D WA14          E DS                  INZ
     D KYWA14        E DS                  INZ

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
     D EXWA14IFKZ      S              1
     D OFWA14TENR      S                   LIKE(KYWA14TENR)
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
           CLOSE TRWA14FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';

       WHEN PCPGST = 'PWA14 ';
         EXSR PWA14;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA14;

         IF WKFENR = *ZERO;
           EXSR LWA14;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = 'PRWA14';
         EXSR PRWA14;
         WKIFMT = '00';
       WHEN EXWA14IFKZ <> *BLANK;                                               // EXTERNES
         EXSR IFWA14;                                                           // UPDATE
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
           OPEN(E) TRWA14FM;
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
         CLOSE(E) TRWA14FM;
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
         KYWA14FIRM = DAFIRM;  // WA14
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA14FM';

         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA14FM';

       ENDSR;

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXTREND                        ***
       //*************************************************************************
       BEGSR UEBTREND;

        IF EXTRNDPGST <> 'PRWA14';
          CLEAR EXDATA;
          EXDATAFILE = 'EXTREND';
          EXDATADATA = EXTREND;
          C_INZDATASTR(EXDATA:RTDATA);
          EXTREND = RTDATADATA;
        ENDIF;

        PCPGST = EXTRNDPGST;

        KYWA14TENR = %SUBST(EXTRNDKEYB:01);

        DSWA14TENR = %SUBST(EXTRNDKEYB:01);

        DSWA14NTEN = %SUBST(EXTRNDNKEY:01);

        EXWA14IFKZ = %SUBST(EXTRNDPRKZ:01);

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

         EXTRDNDANA = 'TRWA14';
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

          WKFLPORECN = 'TRWA1401';
          EXSR EFLPO;
          WRITE TRWA14W1;
          WRITE TRWA1401;
          WRITE W1WA14B1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          //FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          IF WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDIF;

          C#WNDW = *OFF;

          READ(E) TRWA1401;
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

            EXSR UWA14;

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
            CLEAR KYWA14TENR;
            EXSR B01DS;
          ENDIF;

        ENDDO;

        SELECT;
        WHEN PCPGST = 'F     ';
          CHIDS = '01F';
          EXSR CHWA14;
        WHEN #CRTCD = 'N';
          CHIDS = '01CF';
          EXSR CHWA14;
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
          CLEAR WA14;
          EXSR ETRMU;
          EXSR EWA14;
          WA14TENR = KYWA14TENR;

        OTHER;
          CHIDS = '01C';
          EXSR CHWA14;

          EXINFOFILE = 'WA14';
          EXINFODATA = %ADDR(WA14);
          C_TRINFO(EXINFO:DSINFO);

          WKUSER = WA14USER;
          WKJDAT = WA14JDAT;
          WKJZEI = WA14JZEI;

          IF PCPGST = '2     ';
            CHIDS = '01CL';
            EXSR CHWA14;
            EXSR EWA14;
          ENDIF;

        ENDSL;

        IF CHI(5) = 'L';
          PCPGST = 'F     ';
        ENDIF;

        DSWA14TENR = WA14TENR;

        // Initialisieren der Textfelder
        DSTEILTBZ1 = *BLANK;
        DSTEILTBZ2 = *BLANK;

        // Füllen der Textfelder mit Interpretationen
        IF DSWA14TENR <> *BLANK;
          EXSR PRWA14TENR;
        ENDIF;

        EXTRPBBFMT = 'TRWA1401';
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
          EXFLPOFLDN = 'DSWA14TENR';

          IF RTTRPBCUSR <> *BLANK;
            EXFLPOFLDN = RTTRPBCUSR;
          ENDIF;

        WHEN PCPGST = 'MUSTER';
          C#LCK1 = *ON;
          EXFLPOFLDN = 'DSWA14TENR';

        WHEN PCPGST = 'F     ';
          WKFENR = '0001';
          C#LCK0 = *ON;
          C#LCK1 = *ON;

        OTHER;
          EXFLPOFLDN = 'DSWA14TENR';

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
           WKFLPORECN = 'TRWA14K1';
           EXSR EFLPO;
           WRITE TRWA14W2;
           WRITE TRWA14K1;
           WRITE W2WA14B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA14K1;

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

           EXSR KWA14;
           EXSR UWA14;
           %SUBST(RTTRNDKEYB:01) = KYWA14TENR;
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

         DSWA14TENR = KYWA14TENR;

         DSWA14NTEN = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA14NTEN';

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
           AND FLDNAM = 'DSWA14TENR';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA14TENR';

         WHEN FLDNAM = 'DSWA14TENR';
           EXSR MCWA14TENR;

         WHEN FLDNAM = 'DSWA14NTEN';
           EXSR MCWA14NTEN;

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
           WHEN FLDNAM = 'DSWA14TENR'
             AND C#LCK1 = *OFF;
             EXSR PRWA14TENR;
           WHEN FLDNAM = 'DSWA14NTEN';
             EXSR PRWA14NTEN;
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA14TENR = DSWA14NTEN;
           CHIDS = '01C';
           EXSR CHWA14;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA14NTEN';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA14TENR = DSWA14TENR;
           CHIDS = '01C';
           EXSR CHWA14;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA14TENR';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA14TENR';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA14';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA14;

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
       //**  Kopieren Sätze aus Datei WA14                                     ***
       //*************************************************************************
       BEGSR KWA14;

         KYWA14TENR = DSWA14TENR;
         CHIDS = '01C';
         EXSR CHWA14;
         IF WKFENR = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA14-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA14;

         OFWA14TENR = KYWA14TENR;
         CHIDS = '01+';
         EXSR CHWA14;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA14FIRM = KYWA14FIRM
           AND WA14TENR <= OFWA14TENR;

           IF WA14LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA14LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA14;
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
       //**  Löschen Sätze Datei WA14                                          ***
       //*************************************************************************
       BEGSR LWA14;

         OFWA14TENR = KYWA14TENR;
         CHIDS = '01+';
         EXSR CHWA14;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA14FIRM = KYWA14FIRM
           AND WA14TENR <= OFWA14TENR;

           EXSR LPOSI;

           KYWA14TENR = WA14TENR;
           CHIDS = '01CU';
           EXSR CHWA14;

           CHIDS = '01D';
           EXSR CHWA14;

           CHIDS = '01R';
           EXSR CHWA14;
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
       BEGSR IFWA14;

         IF EXWA14IFKZ = '0';

           // Satz auf Existenz prüfen
           KYWA14TENR = %SUBST(EXTRNDKEYB:01);
           CHIDS = '01C';
           EXSR CHWA14;

           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;

         ENDIF;

         EXSR B01DS;

         WKFLPORECN = 'TRWA1401';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR UWA14;
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
         IF K#WA14LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA14;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA14                                                 ***
       //*************************************************************************
       BEGSR UWA14;

         KYWA14TENR = DSWA14TENR;

         IF PCPGST = '3     ';
           KYWA14TENR = DSWA14NTEN;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA14;

         WA14JNAM = DAJNAM;
         WA14PROG = DAPROG;
         WA14BIBL = WKCHPL;
         WA14USER = DAUSER;
         WA14JZEI = %DEC(%TIME());
         WA14JDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA14;

         WHEN CHI(6) = *ON;

           CHIDS = '01W';
           EXSR CHWA14;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA14;

           #CRTCD = 'U';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCWA14TENR;

         C#WNDW = *ON;

         IF DSWA14TENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA14TENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA14TENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRWA14TENR;

         EXFLPOFLDN = 'DSWA14TENR';

         KYTENR = DSWA14TENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWA14TENR = TETENR;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR MCWA14NTEN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA14NTEN;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA14NTEN = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR PRWA14NTEN;

         EXFLPOFLDN = 'DSWA14NTEN';

         KYTENR = DSWA14NTEN;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWA14NTEN = TETENR;

       ENDSR;

       //*************************************************************************
       //**  Prüfen der Hinterlegung eines Artikels in WA14                    ***
       //*************************************************************************
       BEGSR PRWA14;

         CHIDS = '01C';
         EXSR CHWA14;
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

         KYTRMUDANA = 'WA14';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;
           WA14 = TRMUDATA;

           CLEAR EXDATA;
           EXDATAFILE = 'WA14';
           EXDATADATA = WA14;
           C_INZDATASTR(EXDATA:RTDATA);
           WA14 = RTDATADATA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA14;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA14';
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
           EXTRDNPGNA = 'TRWA14';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA14B1'    EXTRDNPGNA
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
         PGMNAM = 'TRWA14';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTWA14W1;
         WHEN WKIFMT = 'K1';
           WRITE CTWA14W2;
         OTHER;
           WRITE TRWA14CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTWA14W1;
         WHEN WKIFMT = 'K1';
           WRITE CTWA14W2;
         OTHER;
           WRITE TRWA14CT;
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
      /COPY QCPYSRC,CHWA14
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCTEIL
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
