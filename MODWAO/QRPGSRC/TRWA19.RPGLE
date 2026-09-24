     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2025')
      //*************************************************************************
      /TITLE Verwalten Datei WA19
      //*************************************************************************
      //  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
      //                       Verwaltung GmbH
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 08.05.2025 Case #04280892
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA19.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA19FM  CF   E             WORKSTN USROPN
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

     D WA19          E DS                  INZ
     D KYWA19        E DS                  INZ

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

     D EXWA19          DS                  INZ
     D  EXWA19PRKZ                  256
     D   EXWA19IFKZ                   1    OVERLAY(EXWA19PRKZ:*NEXT)
     D   EXWA19PRRT                   1    OVERLAY(EXWA19PRKZ:*NEXT)

     D  EXWA19KEYB                  256
     D   EXWA19TEPG                        OVERLAY(EXWA19KEYB:*NEXT)
     D                                     LIKE(WA19TEPG)
     D   EXWA19PRGR                        OVERLAY(EXWA19KEYB:*NEXT)
     D                                     LIKE(WA19PRGR)

     D  EXWA19NKEY                  256
     D   EXWA19NTEP                        OVERLAY(EXWA19NKEY:*NEXT)
     D                                     LIKE(WA19TEPG)
     D   EXWA19NPRG                        OVERLAY(EXWA19NKEY:*NEXT)
     D                                     LIKE(WA19PRGR)

     D  EXWA19DATE                 1024

     D RTWA19          DS                  INZ
     D  RTWA19KEYB                  256
     D   RTWA19TEPG                        OVERLAY(RTWA19KEYB:*NEXT)
     D                                     LIKE(WA19TEPG)
     D   RTWA19PRGR                        OVERLAY(RTWA19KEYB:*NEXT)
     D                                     LIKE(WA19PRGR)

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
     D OFWA19TEPG      S                   LIKE(KYWA19TEPG)
     D OFWA19PRGR      S                   LIKE(KYWA19PRGR)
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
      // Parameter:      #WA19TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA19TSTP                          LIKE(WA19TSTP)

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
           CLOSE TRWA19FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRWA19K1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KWA19;
           EXSR UWA19;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PWA19 ';
         EXSR PWA19;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA19;

         IF WKFENR = *ZERO;
           EXSR LWA19;
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
           OPEN(E) TRWA19FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA19';
             EXTRDZAUSW = 'TRWA19';
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
         CLOSE(E) TRWA19FM;
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
         KYWA19FIRM = DAFIRM;  // WA19

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA19FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA19FM';

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
         EXWA19PRKZ = EXTRNDPRKZ;

         EXWA19KEYB = EXTRNDKEYB;
         KYWA19TEPG = EXWA19TEPG;
         KYWA19PRGR = EXWA19PRGR;

         DSWA19TEPG = EXWA19TEPG;
         DSWA19PRGR = EXWA19PRGR;

         EXWA19NKEY = EXTRNDNKEY;
         DSWA19NTEP = EXWA19NTEP;
         DSWA19NPRG = EXWA19NPRG;

         EXWA19DATE = EXTRNDDATE;

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

         EXTRDNDANA = 'TRWA19';
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
           WKFLPORECN = 'TRWA1901';
           //WRITE TRWA19CL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWA19W1;
           WRITE TRWA1901;
           WRITE W1WA19B3;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA1901;
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

             EXSR UWA19;

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
             IF EXWA19TEPG = *BLANK;
               KYWA19TEPG = *BLANK;
             ELSE;
               KYWA19TEPG = EXWA19TEPG;
             ENDIF;
             KYWA19PRGR = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA19;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA19;
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
           CLEAR WA19;
           EXSR ETRMU;
           EXSR EWA19;
           WA19TEPG = KYWA19TEPG;
           WA19PRGR = KYWA19PRGR;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA19;

           EXINFOFILE = 'WA19';
           EXINFODATA = %ADDR(WA19);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA19USER;
           WKJDAT = WA19JDAT;
           WKJZEI = WA19JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA19;
             EXSR EWA19;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA19TEPG = WA19TEPG;
         DSWA19PRGR = WA19PRGR;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA19IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         TXWA19TEPG = *BLANK;
         TXWA19PRGR = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA19TEPG <> *BLANK;
           EXSR PRWA19TEPG;
         ENDIF;

         IF DSWA19PRGR <> *BLANK;
           EXSR PRWA19PRGR;
         ENDIF;

         EXTRPBBFMT = 'TRWA1901';
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
           EXFLPOFLDN = 'DSWA19PRGR';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA19PRGR';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSWA19TEPG <> *BLANK;
             EXFLPOFLDN = 'DSWA19PRGR';
           ELSE;
             EXFLPOFLDN = 'DSWA19TEPG';
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
           WKFLPORECN = 'TRWA19K1';
           EXSR EFLPO;
           WRITE TRWA19W2;
           WRITE TRWA19K1;
           WRITE W2WA19B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA19K1;

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

           EXSR KWA19;
           EXSR UWA19;

           WKIFMT = '00';
           //IF DSWA19NPRG <> *BLANK;
           //  %SUBST(RTTRNDKEYB:01:04) = KYWA19TEPG;
           //  %SUBST(RTTRNDKEYB:05:04) = KYWA19PRGR;
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

         DSWA19TEPG = KYWA19TEPG;
         DSWA19PRGR = KYWA19PRGR;

         DSWA19NTEP = KYWA19TEPG;
         DSWA19NPRG = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA19NPRG';

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

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA19TEPG';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA19PRGR';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA19TEPG';

         WHEN FLDNAM = 'DSWA19TEPG';
           EXSR MCWA19TEPG;

         WHEN FLDNAM = 'DSWA19PRGR';
           EXSR MCWA19PRGR;

         WHEN FLDNAM = 'DSWA19NTEP';
           EXSR MCWA19NTEP;

         WHEN FLDNAM = 'DSWA19NPRG';
           EXSR MCWA19NPRG;

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

           WHEN FLDNAM = 'DSWA19TEPG' AND C#LCK1 = *OFF;
             EXSR PRWA19TEPG;

           WHEN FLDNAM = 'DSWA19PRGR' AND C#LCK1 = *OFF;
             EXSR PRWA19PRGR;

           WHEN FLDNAM = 'DSWA19NTEP';
             EXSR PRWA19NTEP;

           WHEN FLDNAM = 'DSWA19NPRG';
             EXSR PRWA19NPRG;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA19TEPG = DSWA19NTEP;
           KYWA19PRGR = DSWA19NPRG;
           CHIDS = '01C';
           EXSR CHWA19;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA19NPRG';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA19TEPG = DSWA19TEPG;
           KYWA19PRGR = DSWA19PRGR;
           CHIDS = '01C';
           EXSR CHWA19;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA19PRGR';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA19PRGR';
             LEAVESR;
           ENDSL;

           KYWA19PRGR = DSWA19PRGR;
           CLEAR KYWA19TEPG;
           CHIDS = '02+';
           EXSR CHWA19;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
           IF CHI(5) = 'J'
             AND WA19FIRM = KYWA19FIRM
             AND WA19PRGR = KYWA19PRGR;

             IF WA19TEPG <> DSWA19TEPG;
               // Die Prod-Gruppe ist bereits der KD-Gruppe &3 zugeprdnet.
               //W$PA03 = WA19TEPG;
               //WKFENR = '0036';
               //W$MSGA = '#MO';
               //EXFLPOFLDN = 'DSWA19TEPG';
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

         KYTRMUDANA = 'WA19';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA19;
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
       //**  Kopieren Sätze aus Datei WA19                                     ***
       //*************************************************************************
       BEGSR KWA19;

         KYWA19TEPG = DSWA19TEPG;
         KYWA19PRGR = DSWA19PRGR;
         CHIDS = '01C';
         EXSR CHWA19;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA19-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA19;

         OFWA19TEPG = KYWA19TEPG;
         OFWA19PRGR = KYWA19PRGR;
         IF KYWA19PRGR = *BLANK;
           OFWA19PRGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA19;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA19FIRM = KYWA19FIRM
           AND WA19TEPG <= OFWA19TEPG
           AND WA19PRGR <= OFWA19PRGR;

           IF WA19LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA19LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA19;
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
       //**  Löschen Sätze Datei WA19                                          ***
       //*************************************************************************
       BEGSR LWA19;

         OFWA19TEPG = KYWA19TEPG;
         OFWA19PRGR = KYWA19PRGR;
         IF KYWA19PRGR = *BLANK;
           OFWA19PRGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA19;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA19FIRM = KYWA19FIRM
           AND WA19TEPG <= OFWA19TEPG
           AND WA19PRGR <= OFWA19PRGR;

           EXSR LPOSI;

           KYWA19TEPG = WA19TEPG;
           KYWA19PRGR = WA19PRGR;
           CHIDS = '01CU';
           EXSR CHWA19;

           CHIDS = '01D';
           EXSR CHWA19;

           CHIDS = '01R';
           EXSR CHWA19;
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
       //**  Update Datei WA19                                                 ***
       //*************************************************************************
       BEGSR UWA19;

         KYWA19TEPG = DSWA19TEPG;
         KYWA19PRGR = DSWA19PRGR;

         IF PCPGST = '3     ';
           KYWA19TEPG = DSWA19NTEP;
           KYWA19PRGR = DSWA19NPRG;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA19;

         WA19JNAM = DAJNAM;
         WA19PROG = DAPROG;
         WA19BIBL = WKCHPL;
         WA19USER = DAUSER;
         WA19JZEI = %DEC(%TIME());
         WA19JDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA19;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA19TSTP);
           WA19ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA19;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA19;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TEPG                                                   ***
       //*************************************************************************
       BEGSR MCWA19TEPG;

         C#WNDW = *ON;

         IF DSWA19TEPG = *BLANK;
           TXWA19TEPG = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$TEEWPRGR';
         %SUBST(KOMDS:12) = DSWA19TEPG;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA19TEPG = TPTCDE;
           TXWA19TEPG = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune TEPG                                                   ***
       //*************************************************************************
       BEGSR PRWA19TEPG;

         EXFLPOFLDN = 'DSWA19TEPG';

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = DSWA19TEPG;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXWA19TEPG = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR MCWA19PRGR;

         C#WNDW = *ON;

         IF DSWA19PRGR = *BLANK;
           TXWA19PRGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'PRGR';
         %SUBST(KOMDS:12) = DSWA19PRGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA19PRGR = TPTCDE;
           TXWA19PRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune PRGR                                                   ***
       //*************************************************************************
       BEGSR PRWA19PRGR;

         EXFLPOFLDN = 'DSWA19PRGR';

         KYTPTA = 'PRGR';
         KYTPTC = DSWA19PRGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXWA19PRGR = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEP                                                   ***
       //*************************************************************************
       BEGSR MCWA19NTEP;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$TEEWPRGR';
         %SUBST(KOMDS:12) = DSWA19NTEP;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA19NTEP = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NTEP                                                   ***
       //*************************************************************************
       BEGSR PRWA19NTEP;

         EXFLPOFLDN = 'DSWA19NTEP';

         KYTPTA = '$$TEEWPRGR';
         KYTPTC = DSWA19NTEP;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NPRG                                                   ***
       //*************************************************************************
       BEGSR MCWA19NPRG;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'PRGR';
         %SUBST(KOMDS:12) = DSWA19NPRG;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA19NPRG = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NPRG                                                   ***
       //*************************************************************************
       BEGSR PRWA19NPRG;

         EXFLPOFLDN = 'DSWA19NPRG';

         KYTPTA = 'PRGR';
         KYTPTC = DSWA19NPRG;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA19';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA19;

           CLEAR EXDATA;
           EXDATAFILE = 'WA19';
           EXDATADATA = WA19;
           C_INZDATASTR(EXDATA: RTDATA);

           WA19 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA19;

       ENDSR;
       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA19';
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
         W$MSGA = *BLANK;
         WKTRDZZYKL = *OFF;

         DOW WKFENR = *ZERO;
           CLEAR EXTRDN;
           EXTRDNPGST = WKPGST;
           IF RTTRDZAWCD <> *BLANKS;
             EXTRDNAWCD = RTTRDZAWCD;
           ENDIF;

           EXTRDNPGNA = 'TRWA19';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA19B1'    EXTRDNPGNA
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
           WHEN EXTRDNDANA = '    ';
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

         PGMNAM = 'TRWA19';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA19W2;
         OTHER;
           WRITE CTWA19W1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA19W2;
         OTHER;
           WRITE CTWA19W1;
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
      /COPY QCPYSRC,CHWA19
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
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
