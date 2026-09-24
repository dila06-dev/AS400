     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei WA18
      //*************************************************************************
      //  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 03.12.2024 Case #03829427
      //  -----------------------------------------------------------------------
      //  Änderung: JK 17.02.2025 Case #03829427 weder LFNR noch URLD pflicht
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA18.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA18FM  CF   E             WORKSTN USROPN
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
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

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

     D WA18          E DS                  INZ
     D KYWA18        E DS                  INZ

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

     D EXWA18          DS                  INZ
     D  EXWA18PRKZ                  256
     D   EXWA18IFKZ                   1    OVERLAY(EXWA18PRKZ:*NEXT)
     D   EXWA18PRRT                   1    OVERLAY(EXWA18PRKZ:*NEXT)

     D  EXWA18KEYB                  256
     D   EXWA18LFNR                        OVERLAY(EXWA18KEYB:*NEXT)
     D                                     LIKE(WA18LFNR)
     D   EXWA18URLD                        OVERLAY(EXWA18KEYB:*NEXT)
     D                                     LIKE(WA18URLD)

     D  EXWA18NKEY                  256
     D   EXWA18NLFN                        OVERLAY(EXWA18NKEY:*NEXT)
     D                                     LIKE(WA18LFNR)
     D   EXWA18NURL                        OVERLAY(EXWA18NKEY:*NEXT)
     D                                     LIKE(WA18URLD)

     D  EXWA18DATE                 1024
     D   EXWA18TLFK                        OVERLAY(EXWA18DATE:*NEXT)
     D                                     LIKE(WA18TLFK)

     D RTWA18          DS                  INZ
     D  RTWA18KEYB                  256
     D   RTWA18LFNR                        OVERLAY(RTWA18KEYB:*NEXT)
     D                                     LIKE(WA18LFNR)
     D   RTWA18URLD                        OVERLAY(RTWA18KEYB:*NEXT)
     D                                     LIKE(WA18URLD)

     D  RTWA18DATE                 1024
     D   RTWA18TLFK                        OVERLAY(RTWA18DATE:*NEXT)
     D                                     LIKE(WA18TLFK)
     D   RTWA18TSTP                        OVERLAY(RTWA18DATE:*NEXT)
     D                                     LIKE(WA18TSTP)

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
     D OFWA18LFNR      S                   LIKE(KYWA18LFNR)
     D OFWA18URLD      S                   LIKE(KYWA18URLD)
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
      // Parameter:      #WA18TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA18TSTP                          LIKE(WA18TSTP)

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
           CLOSE TRWA18FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';
       WHEN PCPGST = 'PWA18 ';
         EXSR PWA18;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA18;

         IF WKFENR = *ZERO;
           EXSR LWA18;
         ENDIF;

         WKIFMT = '00';

       // Externes Update
       WHEN EXWA18IFKZ <> *BLANK;
         exsr IFWA18;
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
           OPEN(E) TRWA18FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA18';
             EXTRDZAUSW = 'TRWA18';
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
         CLOSE(E) TRWA18FM;
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
         KYLFFI = DAFIRM;      // LIEF
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA18FIRM = DAFIRM;  // WA18

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA18FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA18FM';

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
         EXWA18PRKZ = EXTRNDPRKZ;

         EXWA18KEYB = EXTRNDKEYB;
         KYWA18LFNR = EXWA18LFNR;
         KYWA18URLD = EXWA18URLD;

         DSWA18LFNR = EXWA18LFNR;
         DSWA18URLD = EXWA18URLD;

         EXWA18NKEY = EXTRNDNKEY;
         DSWA18NLFN = EXWA18NLFN;
         DSWA18NURL = EXWA18NURL;

         EXWA18DATE = EXTRNDDATE;
         MONITOR;
           EXWA18TLFK = %DEC(%SUBST(EXWA18DATE:01:05):5:2);
         ON-ERROR *PROGRAM;
           EXWA18TLFK = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         CLEAR RTTREND;
         CLEAR RTWA18DATE;
         CLEAR RTWA18TLFK;
         CLEAR RTWA18TSTP;
         RTTRNDDATE = RTWA18DATE;
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

         EXTRDNDANA = 'TRWA18';
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
           WKFLPORECN = 'TRWA1801';
           //WRITE TRWA18CL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWA18W1;
           WRITE TRWA1801;
           WRITE W1WA18B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           //FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA1801;
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

             EXSR UWA18;

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
             KYWA18LFNR = *BLANK;
             KYWA18URLD = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA18;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA18;
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
           CLEAR WA18;
           EXSR ETRMU;
           EXSR EWA18;
           WA18LFNR = KYWA18LFNR;
           WA18URLD = KYWA18URLD;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA18;

           EXINFOFILE = 'WA18';
           EXINFODATA = %ADDR(WA18);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA18USER;
           WKJDAT = WA18JDAT;
           WKJZEI = WA18JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA18;
             EXSR EWA18;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA18LFNR = WA18LFNR;
         DSWA18URLD = WA18URLD;

         DSWA18TLFK = WA18TLFK;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA18IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         TXWA18LFNR = *BLANK;
         TXWA18URLD = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA18LFNR <> *BLANK;
           EXSR PRWA18LFNR;
         ENDIF;

         IF DSWA18URLD <> *BLANK;
           EXSR PRWA18URLD;
         ENDIF;

         EXTRPBBFMT = 'TRWA1801';
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
           EXFLPOFLDN = 'DSWA18TLFK';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA18TLFK';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSWA18LFNR <> *BLANK;
             EXFLPOFLDN = 'DSWA18URLD';
           ELSE;
             EXFLPOFLDN = 'DSWA18LFNR';
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
           WKFLPORECN = 'TRWA18K1';
           EXSR EFLPO;
           WRITE TRWA18W2;
           WRITE TRWA18K1;
           WRITE W2WA18B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA18K1;

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

           EXSR KWA18;
           EXSR UWA18;

           WKIFMT = '00';
           %SUBST(RTTRNDKEYB:01:10) = KYWA18LFNR;
           %SUBST(RTTRNDKEYB:11:03) = KYWA18URLD;
         ENDDO;

         RTTRNDRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA18LFNR = KYWA18LFNR;
         DSWA18URLD = KYWA18URLD;

         DSWA18NLFN = KYWA18LFNR;
         DSWA18NURL = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA18NURL';

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

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA18LFNR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA18URLD';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA18LFNR';

         WHEN FLDNAM = 'DSWA18LFNR';
           EXSR MCWA18LFNR;

         WHEN FLDNAM = 'DSWA18URLD';
           EXSR MCWA18URLD;

         WHEN FLDNAM = 'DSWA18NLFN';
           EXSR MCWA18NLFN;

         WHEN FLDNAM = 'DSWA18NURL';
           EXSR MCWA18NURL;

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

           WHEN FLDNAM = 'DSWA18LFNR' AND C#LCK1 = *OFF;
             EXSR PRWA18LFNR;

           WHEN FLDNAM = 'DSWA18URLD' AND C#LCK1 = *OFF;
             EXSR PRWA18URLD;

           WHEN FLDNAM = 'DSWA18TLFK' AND C#LCK0 = *OFF;
             EXSR PRWA18TLFK;

           WHEN FLDNAM = 'DSWA18NLFN';
             EXSR PRWA18NLFN;

           WHEN FLDNAM = 'DSWA18NURL';
             EXSR PRWA18NURL;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA18LFNR = DSWA18NLFN;
           KYWA18URLD = DSWA18NURL;
           CHIDS = '01C';
           EXSR CHWA18;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA18NURL';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA18LFNR = DSWA18LFNR;
           KYWA18URLD = DSWA18URLD;
           CHIDS = '01C';
           EXSR CHWA18;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA18URLD';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA18URLD';
             LEAVESR;
           ENDSL;

         ENDSL;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA18';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA18;
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
       //**  Kopieren Sätze aus Datei WA18                                     ***
       //*************************************************************************
       BEGSR KWA18;

         KYWA18LFNR = DSWA18LFNR;
         KYWA18URLD = DSWA18URLD;
         CHIDS = '01C';
         EXSR CHWA18;
         IF WKFENR = *ZERO;
           DSWA18TLFK = WA18TLFK;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA18-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA18;

         OFWA18LFNR = KYWA18LFNR;
         OFWA18URLD = KYWA18URLD;
         CHIDS = '01+';
         EXSR CHWA18;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA18FIRM = KYWA18FIRM
           AND WA18LFNR <= OFWA18LFNR
           AND WA18URLD <= OFWA18URLD;

           IF WA18LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA18LOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA18;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;
         CLEAR RTWA18DATE;
         CLEAR RTWA18TLFK;
         CLEAR RTWA18TSTP;
         RTTRNDDATE = RTWA18DATE;

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
       //**  Löschen Sätze Datei WA18                                          ***
       //*************************************************************************
       BEGSR LWA18;

         OFWA18LFNR = KYWA18LFNR;
         OFWA18URLD = KYWA18URLD;
         CHIDS = '01+';
         EXSR CHWA18;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA18FIRM = KYWA18FIRM
           AND WA18LFNR <= OFWA18LFNR
           AND WA18URLD <= OFWA18URLD;

           EXSR LPOSI;

           KYWA18LFNR = WA18LFNR;
           KYWA18URLD = WA18URLD;
           CHIDS = '01CU';
           EXSR CHWA18;

           CHIDS = '01D';
           EXSR CHWA18;

           CHIDS = '01R';
           EXSR CHWA18;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;
         CLEAR RTWA18DATE;
         CLEAR RTWA18TLFK;
         CLEAR RTWA18TSTP;
         RTTRNDDATE = RTWA18DATE;

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
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWA18;

         IF EXWA18IFKZ = '0';
           // Satz auf Existenz prüfen
           KYWA18LFNR = EXWA18LFNR;
           KYWA18URLD = EXWA18URLD;
           CHIDS = '01C';
           EXSR CHWA18;
           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;
         ENDIF;

         EXSR B01DS;

         IF EXWA18TLFK <> *ZERO;
           DSWA18TLFK = EXWA18TLFK;
         ENDIF;

         // Prüfung der Felder nur dann wenn dies expliziet von extern mitgegeben wird
         WKFENR = *ZERO;
         IF EXWA18PRRT = *ON OR EXWA18PRRT = *BLANK;
           WKFLPORECN = 'TRWA1801';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDIF;

         IF WKFENR = *ZERO;
           EXSR UWA18;
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

         CLEAR RTWA18DATE;
         CLEAR RTWA18TLFK;
         IF #CRTCD = 'W';  // TSTP für neu angelegten Satz zurückgeben
           RTWA18TSTP = WA18TSTP;
         ELSE;
           CLEAR RTWA18TSTP;
         ENDIF;
         RTTRNDDATE = RTWA18DATE;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WA18LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA18;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA18                                                 ***
       //*************************************************************************
       BEGSR UWA18;

         KYWA18LFNR = DSWA18LFNR;
         KYWA18URLD = DSWA18URLD;

         IF PCPGST = '3     ';
           KYWA18LFNR = DSWA18NLFN;
           KYWA18URLD = DSWA18NURL;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA18;

         WA18TLFK = DSWA18TLFK;

         WA18JNAM = DAJNAM;
         WA18PROG = DAPROG;
         WA18BIBL = WKCHPL;
         WA18USER = DAUSER;
         WA18JZEI = %DEC(%TIME());
         WA18JDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA18;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA18TSTP);
           WA18ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA18;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA18;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine LFNR                                                   ***
       //*************************************************************************
       BEGSR MCWA18LFNR;

         C#WNDW = *ON;

         IF DSWA18LFNR = *BLANK;
           TXWA18LFNR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA18LFNR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCLIEF;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA18LFNR = LFLFNR;
           TXWA18LFNR = LFKNAM;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune LFNR                                                   ***
       //*************************************************************************
       BEGSR PRWA18LFNR;

         EXFLPOFLDN = 'DSWA18LFNR';
         TXWA18LFNR = *BLANK;

         IF DSWA18LFNR <> *BLANK;
           KYLFNR = DSWA18LFNR;
           CHIDS  = '01C';
           EXSR CHLIEF;
           DSWA18LFNR = LFLFNR;
           TXWA18LFNR = LFKNAM;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine URLD                                                   ***
       //*************************************************************************
       BEGSR MCWA18URLD;

         C#WNDW = *ON;

         IF DSWA18URLD = *BLANK;
           TXWA18URLD = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA18URLD;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA18URLD = LNLDNR;
           TXWA18URLD = LNLBEZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune URLD                                                   ***
       //*************************************************************************
       BEGSR PRWA18URLD;

         EXFLPOFLDN = 'DSWA18URLD';
         TXWA18URLD = *BLANK;

         IF DSWA18URLD <> *BLANK;
           %SUBST(KOMDS:01) = DSWA18URLD;
           EXSR PRLANDLAND;
           TXWA18URLD = %SUBST(KOMDS:08);
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune TLFK                                                   ***
       //*************************************************************************
       BEGSR PRWA18TLFK;

         EXFLPOFLDN = 'DSWA18TLFK';

         IF DSWA18TLFK = *ZERO;
           WKFENR = '0031';
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NLFN                                                   ***
       //*************************************************************************
       BEGSR MCWA18NLFN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA18NLFN;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCLIEF;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA18NLFN = LFLFNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NLFN                                                   ***
       //*************************************************************************
       BEGSR PRWA18NLFN;

         EXFLPOFLDN = 'DSWA18NLFN';


         IF DSWA18NLFN <> *BLANK;
           KYLFNR = DSWA18NLFN;
           CHIDS  = '01C';
           EXSR CHLIEF;
           DSWA18NLFN = LFLFNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NURL                                                   ***
       //*************************************************************************
       BEGSR MCWA18NURL;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA18NURL;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA18NURL = LNLDNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NURL                                                   ***
       //*************************************************************************
       BEGSR PRWA18NURL;

         EXFLPOFLDN = 'DSWA18NURL';

         IF DSWA18NURL <> *BLANK;
           %SUBST(KOMDS:01) = DSWA18NURL;
           EXSR PRLANDLAND;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA18';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA18;

           CLEAR EXDATA;
           EXDATAFILE = 'WA18';
           EXDATADATA = WA18;
           C_INZDATASTR(EXDATA: RTDATA);

           WA18 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA18;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA18';
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

           EXTRDNPGNA = 'TRWA18';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA18B1'    EXTRDNPGNA
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

         PGMNAM = 'TRWA18';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA18W2;
         OTHER;
           WRITE CTWA18W1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA18W2;
         OTHER;
           WRITE CTWA18W1;
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
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA18
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCLAND
      /COPY QCPYSRC,MCLIEF
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRLANDLAND
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
