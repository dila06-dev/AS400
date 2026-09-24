     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei WA17
      //*************************************************************************
      //  Copyright 2024 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 05.11.2024 Case #03895676
      //  -----------------------------------------------------------------------
      //  Änderung: MG 07.11.2024 Ermitteln Daten für die Preis/Konditionsermittlung
      //  Änderung: PH 19.11.2024 Case #03895676. Anruf von IK: Die Prüfung, dass die
      //            Produktgruppe bereits einer anderen Kundengruppe zugeordnet ist, deaktiviert.
      //  Änderung: PH 20.11.2024 Case #03895676. E-Mail von IK vom 19.11.2024:
      //            - Aufruf MCKOND ohne Anzeige des Selektionsformats MCKONDMx aber
      //              mit dem gesetzten Kz. für die Anzeige der leeren Subfile MCKOND
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA17.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA17FM  CF   E             WORKSTN USROPN
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
     D KOND          E DS                  INZ

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

     D WA17          E DS                  INZ
     D KYWA17        E DS                  INZ

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
     D/COPY QCPYSRC,EXUX01
     D/COPY QCPYSRC,EXUX05

     D EXWA17          DS                  INZ
     D  EXWA17PRKZ                  256
     D   EXWA17IFKZ                   1    OVERLAY(EXWA17PRKZ:*NEXT)
     D   EXWA17PRRT                   1    OVERLAY(EXWA17PRKZ:*NEXT)

     D  EXWA17KEYB                  256
     D   EXWA17KDGR                        OVERLAY(EXWA17KEYB:*NEXT)
     D                                     LIKE(WA17KDGR)
     D   EXWA17PRGR                        OVERLAY(EXWA17KEYB:*NEXT)
     D                                     LIKE(WA17PRGR)

     D  EXWA17NKEY                  256
     D   EXWA17NKDG                        OVERLAY(EXWA17NKEY:*NEXT)
     D                                     LIKE(WA17KDGR)
     D   EXWA17NPRG                        OVERLAY(EXWA17NKEY:*NEXT)
     D                                     LIKE(WA17PRGR)

     D  EXWA17DATE                 1024

     D RTWA17          DS                  INZ
     D  RTWA17KEYB                  256
     D   RTWA17KDGR                        OVERLAY(RTWA17KEYB:*NEXT)
     D                                     LIKE(WA17KDGR)
     D   RTWA17PRGR                        OVERLAY(RTWA17KEYB:*NEXT)
     D                                     LIKE(WA17PRGR)

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
     D WKTRPABEGR      S                   LIKE(KOBEGR)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFWA17KDGR      S                   LIKE(KYWA17KDGR)
     D OFWA17PRGR      S                   LIKE(KYWA17PRGR)
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
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WA17TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA17TSTP                          LIKE(WA17TSTP)

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
           CLOSE TRWA17FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRWA17K1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KWA17;
           EXSR UWA17;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PWA17 ';
         EXSR PWA17;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA17;

         IF WKFENR = *ZERO;
           EXSR LWA17;
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
           OPEN(E) TRWA17FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA17';
             EXTRDZAUSW = 'TRWA17';
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
         CLOSE(E) TRWA17FM;
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
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA17FIRM = DAFIRM;  // WA17

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA17FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA17FM';

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

         PCPGST  = EXTRNDPGST;
         EXWA17PRKZ = EXTRNDPRKZ;

         EXWA17KEYB = EXTRNDKEYB;
         KYWA17KDGR = EXWA17KDGR;
         KYWA17PRGR = EXWA17PRGR;

         DSWA17KDGR = EXWA17KDGR;
         DSWA17PRGR = EXWA17PRGR;

         EXWA17NKEY = EXTRNDNKEY;
         DSWA17NKDG = EXWA17NKDG;
         DSWA17NPRG = EXWA17NPRG;

         EXWA17DATE = EXTRNDDATE;

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

         EXTRDNDANA = 'TRWA17';
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
           WKFLPORECN = 'TRWA1701';
           //WRITE TRWA17CL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWA17W1;
           WRITE TRWA1701;
           WRITE W1WA17B3;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA1701;
           *IN98 = %ERROR;
           *IN99 = %EOF;

           IF *IN98 = *ON OR *IN99 = *ON;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON AND FUKT04 = *ON;

             EXSR MCAUFR;
             IF WKTRTP = *ON OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN RTTRDZAWCD <> *BLANKS;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#ACCS = *ON AND FUKT10 = *ON;
             WKPGST = 'AUFRUF';
             EXSR TRTRDZ;
             C#WNDW = *ON;
             ITER;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
             EXSR VINFO;
             C#WNDW = *ON;
             ITER;

           WHEN C#FUKT <> *ZERO AND FUKT10 = *ON;
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

           IF PCPGST <> '5     ' AND PCPGST <> 'F     ';

             IF PCPGST <> 'MUSTER';
               EXSR BILDPR;
               IF WKFENR <> *ZERO;
                 ITER;
                 ENDIF;
               ENDIF;

             EXSR UWA17;

             SELECT;
             WHEN PCPGST = 'MUSTER';
               EXSR UTRMU;
             ENDSL;
           ENDIF;

           IF PCPGST <> 'MUSTER';
             WKPGST = 'DIREKT';
             EXSR TRTRDZ;
           ENDIF;

           IF PCPGST <> *BLANK OR WKCFMT = *ON;
             #CRTCD = *BLANK;
             #CPGST = *BLANK;
             WKIFMT = '00';
           ELSE;
             IF EXWA17KDGR = *BLANK;
               KYWA17KDGR = *BLANK;
             ELSE;
               KYWA17KDGR = EXWA17KDGR;
             ENDIF;
             KYWA17PRGR = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA17;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA17;
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
         WHEN PCPGST = *BLANK OR PCPGST = 'MUSTER';
           CLEAR WA17;
           EXSR ETRMU;
           EXSR EWA17;
           WA17KDGR = KYWA17KDGR;
           WA17PRGR = KYWA17PRGR;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA17;

           EXINFOFILE = 'WA17';
           EXINFODATA = %ADDR(WA17);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA17USER;
           WKJDAT = WA17JDAT;
           WKJZEI = WA17JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA17;
             EXSR EWA17;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA17KDGR = WA17KDGR;
         DSWA17PRGR = WA17PRGR;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA17IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         TXWA17KDGR = *BLANK;
         TXWA17PRGR = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA17KDGR <> *BLANK;
           EXSR PRWA17KDGR;
         ENDIF;

         IF DSWA17PRGR <> *BLANK;
           EXSR PRWA17PRGR;
         ENDIF;

         EXTRPBBFMT = 'TRWA1701';
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
           EXFLPOFLDN = 'DSWA17PRGR';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA17PRGR';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSWA17KDGR <> *BLANK;
             EXFLPOFLDN = 'DSWA17PRGR';
           ELSE;
             EXFLPOFLDN = 'DSWA17KDGR';
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
           WKFLPORECN = 'TRWA17K1';
           EXSR EFLPO;
           WRITE TRWA17W2;
           WRITE TRWA17K1;
           WRITE W2WA17B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA17K1;

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
             IF WKTRTP = *ON OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#INFO = *ON AND FUKT13 = *ON;
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

           EXSR KWA17;
           EXSR UWA17;

           WKIFMT = '00';
           //IF DSWA17NPRG <> *BLANK;
           //  %SUBST(RTTRNDKEYB:01:04) = KYWA17KDGR;
           //  %SUBST(RTTRNDKEYB:05:04) = KYWA17PRGR;
           //ENDIF;
         ENDDO;

         RTTRNDRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA17KDGR = KYWA17KDGR;
         DSWA17PRGR = KYWA17PRGR;

         DSWA17NKDG = KYWA17KDGR;
         DSWA17NPRG = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA17NPRG';

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
         W$MSGA = *BLANK;
         EXFLPOFLDN = FLDNAM;
         EXSR EFLPO;

         SELECT;

         WHEN EXFLPOKZIO = *OFF;
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA17KDGR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA17PRGR';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA17KDGR';

         WHEN FLDNAM = 'DSWA17KDGR';
           EXSR MCWA17KDGR;

         WHEN FLDNAM = 'DSWA17PRGR';
           EXSR MCWA17PRGR;

         WHEN FLDNAM = 'DSWA17NKDG';
           EXSR MCWA17NKDG;

         WHEN FLDNAM = 'DSWA17NPRG';
           EXSR MCWA17NPRG;

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
         W$MSGA = *BLANK;
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

           WHEN FLDNAM = 'DSWA17KDGR' AND C#LCK1 = *OFF;
             EXSR PRWA17KDGR;

           WHEN FLDNAM = 'DSWA17PRGR' AND C#LCK1 = *OFF;
             EXSR PRWA17PRGR;

           WHEN FLDNAM = 'DSWA17NKDG';
             EXSR PRWA17NKDG;

           WHEN FLDNAM = 'DSWA17NPRG';
             EXSR PRWA17NPRG;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA17KDGR = DSWA17NKDG;
           KYWA17PRGR = DSWA17NPRG;
           CHIDS = '01C';
           EXSR CHWA17;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA17NPRG';
             LEAVESR;
           ENDIF;

           KYWA17PRGR = DSWA17NPRG;
           CLEAR KYWA17KDGR;
           CHIDS = '02+';
           EXSR CHWA17;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
           IF CHI(5) = 'J'
             AND WA17FIRM = KYWA17FIRM
             AND WA17PRGR = KYWA17PRGR;
             // Die Prod-Gruppe ist bereits der KD-Gruppe &3 zugeprdnet.
             //W$PA03 = WA17KDGR;
             //WKFENR = '0036';
             //W$MSGA = '#MO';
             //EXFLPOFLDN = 'DSWA17NKDG';
             //LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA17KDGR = DSWA17KDGR;
           KYWA17PRGR = DSWA17PRGR;
           CHIDS = '01C';
           EXSR CHWA17;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA17PRGR';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA17PRGR';
             LEAVESR;
           ENDSL;

           KYWA17PRGR = DSWA17PRGR;
           CLEAR KYWA17KDGR;
           CHIDS = '02+';
           EXSR CHWA17;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
           IF CHI(5) = 'J'
             AND WA17FIRM = KYWA17FIRM
             AND WA17PRGR = KYWA17PRGR;

             IF WA17KDGR <> DSWA17KDGR;
               // Die Prod-Gruppe ist bereits der KD-Gruppe &3 zugeprdnet.
               //W$PA03 = WA17KDGR;
               //WKFENR = '0036';
               //W$MSGA = '#MO';
               //EXFLPOFLDN = 'DSWA17KDGR';
               //LEAVESR;
             ENDIF;
           ENDIF;

         ENDSL;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA17';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA17;
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
       //**  Kopieren Sätze aus Datei WA17                                     ***
       //*************************************************************************
       BEGSR KWA17;

         KYWA17KDGR = DSWA17KDGR;
         KYWA17PRGR = DSWA17PRGR;
         CHIDS = '01C';
         EXSR CHWA17;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA17-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA17;

         OFWA17KDGR = KYWA17KDGR;
         OFWA17PRGR = KYWA17PRGR;
         IF KYWA17PRGR = *BLANK;
           OFWA17PRGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA17;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA17FIRM = KYWA17FIRM
           AND WA17KDGR <= OFWA17KDGR
           AND WA17PRGR <= OFWA17PRGR;

           IF WA17LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA17LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA17;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
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
       //**  Löschen Sätze Datei WA17                                          ***
       //*************************************************************************
       BEGSR LWA17;

         OFWA17KDGR = KYWA17KDGR;
         OFWA17PRGR = KYWA17PRGR;
         IF KYWA17PRGR = *BLANK;
           OFWA17PRGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA17;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA17FIRM = KYWA17FIRM
           AND WA17KDGR <= OFWA17KDGR
           AND WA17PRGR <= OFWA17PRGR;

           EXSR LPOSI;

           KYWA17KDGR = WA17KDGR;
           KYWA17PRGR = WA17PRGR;
           CHIDS = '01CU';
           EXSR CHWA17;

           CHIDS = '01D';
           EXSR CHWA17;

           CHIDS = '01R';
           EXSR CHWA17;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
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
         W$MSGA = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA17                                                 ***
       //*************************************************************************
       BEGSR UWA17;

         KYWA17KDGR = DSWA17KDGR;
         KYWA17PRGR = DSWA17PRGR;

         IF PCPGST = '3     ';
           KYWA17KDGR = DSWA17NKDG;
           KYWA17PRGR = DSWA17NPRG;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA17;

         WA17JNAM = DAJNAM;
         WA17PROG = DAPROG;
         WA17BIBL = WKCHPL;
         WA17USER = DAUSER;
         WA17JZEI = %DEC(%TIME());
         WA17JDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA17;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA17TSTP);
           WA17ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA17;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA17;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KDGR                                                   ***
       //*************************************************************************
       BEGSR MCWA17KDGR;

         C#WNDW = *ON;

         IF DSWA17KDGR = *BLANK;
           TXWA17KDGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSWA17KDGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17KDGR = TPTCDE;
           TXWA17KDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune KDGR                                                   ***
       //*************************************************************************
       BEGSR PRWA17KDGR;

         EXFLPOFLDN = 'DSWA17KDGR';

         KYTPTA = 'KDGR';
         KYTPTC = DSWA17KDGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXWA17KDGR = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR MCWA17PRGR;

         C#WNDW = *ON;

         IF DSWA17PRGR = *BLANK;
           TXWA17PRGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$TEEWPRGR';
         %SUBST(KOMDS:12) = DSWA17PRGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17PRGR = TPTCDE;
           TXWA17PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune PRGR                                                   ***
       //*************************************************************************
       BEGSR PRWA17PRGR;

         EXFLPOFLDN = 'DSWA17PRGR';

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = DSWA17PRGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXWA17PRGR = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NKDG                                                   ***
       //*************************************************************************
       BEGSR MCWA17NKDG;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSWA17NKDG;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17NKDG = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NKDG                                                   ***
       //*************************************************************************
       BEGSR PRWA17NKDG;

         EXFLPOFLDN = 'DSWA17NKDG';

         KYTPTA = 'KDGR';
         KYTPTC = DSWA17NKDG;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NPRG                                                   ***
       //*************************************************************************
       BEGSR MCWA17NPRG;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$TEEWPRGR';
         %SUBST(KOMDS:12) = DSWA17NPRG;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA17NPRG = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NPRG                                                   ***
       //*************************************************************************
       BEGSR PRWA17NPRG;

         EXFLPOFLDN = 'DSWA17NPRG';

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = DSWA17NPRG;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KOND                                                   ***
       //*************************************************************************
       BEGSR MCAUFRKOND;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = WKTRPABEGR;
         %SUBST(KOMDS:15) = DSWA17PRGR;
         %SUBST(KOMDS:58) = DSWA17KDGR;
         %SUBST(KOMDS:217) = '1';     // Leere MCKOND-Subfile anzeigen
         %SUBST(KOMDS:219) = '0';     // Kein Selektionsformat MCKONDMx anzeigen
         #CPGST = 'KWAO01';
         #CUEBE = '0172';
         IF PCPGST = '5     ';
           #CUEBE = '0031';
         ENDIF;
         EXSR MCKOND;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA17';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA17;

           CLEAR EXDATA;
           EXDATAFILE = 'WA17';
           EXDATADATA = WA17;
           C_INZDATASTR(EXDATA: RTDATA);

           WA17 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA17;

       ENDSR;
       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA17';
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

         KYTATA = 'TRWA17';
         KYTATC = 'KOND';
         KYTAPA = 'BEGR';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPABEGR = TAPCDE;

       ENDSR;

       //*************************************************************************
       //**  Zugriffe                                                          ***
       //*************************************************************************
       BEGSR TRTRDZ;

         WKTRTP = *OFF;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;
           CLEAR EXTRDN;
           EXTRDNPGST = WKPGST;
           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;

           EXTRDNPGNA = 'TRWA17';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA17B1'    EXTRDNPGNA
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
           WHEN EXTRDNDANA = 'KOND';
             EXSR MCAUFRKOND;
           ENDSL;

           IF EXTRDNPGST = 'DIREKT';
             WKPGST = 'WEITER';
             WKFENR = *ZERO;
             W$MSGA = *BLANK;
           ENDIF;

           IF EXTRDNPGST = 'WEITER';
             WKPGST = 'WEITER';
             WKFENR = *ZERO;
             W$MSGA = *BLANK;
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
         W$PA06:W$PA07:W$MSGA);

         PGMNAM = 'TRWA17';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA17W2;
         OTHER;
           WRITE CTWA17W1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA17W2;
         OTHER;
           WRITE CTWA17W1;
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
      /END-FREE
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA17
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCKOND
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
