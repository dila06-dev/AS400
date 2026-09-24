     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei WA16
      //*************************************************************************
      //  Copyright 2024 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 04.11.2024 Case #03895676
      //  -----------------------------------------------------------------------
      //  Änderung: MG 07.11.2024 Ermitteln Daten für die Preis/Konditionsermittlung
      //  Änderung: PH 05.09.2025 Projekt Dometic Germany - B2B (Case #03777387). Gemäß Abstimmung
      //            mit GS am 05.09.2025: Update Standarfelder (Letztes Änderungsdatum/Zeit usw,)
      //            im Kunden-Stamm bei Neuanlage und Löschen eines WA16-Datensatzes, damit
      //            B2B002/B2B003 den entsprechenden Kundenstamm-Satz exportieren kann. Aufgrund
      //            einer möglichen lögischen Satzsperre im zu Kunden-Nr zugehörigen KUND-Daten-
      //            satz, wobei eine gewünschte Aktualisierung der letzten Änderungsdatum/Zeit
      //            im letzteren nicht gewärleistet ist, wird nun bei Neunlage/Löschen eines WA16-
      //            Datensatzes auf die logische Sperre im entsprechenden KUND-Satz geprüft.
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA16.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA16FM  CF   E             WORKSTN USROPN
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
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D WA17          E DS                  INZ
     D KYWA17        E DS                  INZ

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

     D WA16          E DS                  INZ
     D KYWA16        E DS                  INZ

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

     D EXWA16          DS                  INZ
     D  EXWA16PRKZ                  256
     D   EXWA16IFKZ                   1    OVERLAY(EXWA16PRKZ:*NEXT)
     D   EXWA16PRRT                   1    OVERLAY(EXWA16PRKZ:*NEXT)

     D  EXWA16KEYB                  256
     D   EXWA16KDNR                        OVERLAY(EXWA16KEYB:*NEXT)
     D                                     LIKE(WA16KDNR)
     D   EXWA16KDGR                        OVERLAY(EXWA16KEYB:*NEXT)
     D                                     LIKE(WA16KDGR)
     D   EXWA17PRGR                        OVERLAY(EXWA16KEYB:*NEXT)
     D                                     LIKE(WA17PRGR)

     D  EXWA16NKEY                  256
     D   EXWA16NKDN                        OVERLAY(EXWA16NKEY:*NEXT)
     D                                     LIKE(WA16KDNR)
     D   EXWA16NKDG                        OVERLAY(EXWA16NKEY:*NEXT)
     D                                     LIKE(WA16KDGR)

     D  EXWA16DATE                 1024

     D RTWA16          DS                  INZ
     D  RTWA16KEYB                  256
     D   RTWA16KDNR                        OVERLAY(RTWA16KEYB:*NEXT)
     D                                     LIKE(WA16KDNR)
     D   RTWA16KDGR                        OVERLAY(RTWA16KEYB:*NEXT)
     D                                     LIKE(WA16KDGR)

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
     D WKWA17PRGR      S                   LIKE(WA17PRGR)
     D OFWA16KDNR      S                   LIKE(KYWA16KDNR)
     D OFWA16KDGR      S                   LIKE(KYWA16KDGR)
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

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WA16TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA16TSTP                          LIKE(WA16TSTP)

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
           CLOSE TRWA16FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       when PCPGST = 'ERPRKO';
         exsr ERPRKO;
         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRWA16K1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KWA16;
           EXSR UWA16;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PWA16 ';
         EXSR PWA16;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWA16;

         IF WKFENR = *ZERO;
           EXSR LWA16;
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
           OPEN(E) TRWA16FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA16';
             EXTRDZAUSW = 'TRWA16';
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
         CLOSE(E) TRWA16FM;
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
         KYKDFI = DAFIRM;      // KUND
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA16FIRM = DAFIRM;  // WA16

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA16FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA16FM';

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
         EXWA16PRKZ = EXTRNDPRKZ;

         EXWA16KEYB = EXTRNDKEYB;
         KYWA16KDNR = EXWA16KDNR;
         KYWA16KDGR = EXWA16KDGR;

         DSWA16KDNR = EXWA16KDNR;
         DSWA16KDGR = EXWA16KDGR;
         WKWA17PRGR = EXWA17PRGR;

         EXWA16NKEY = EXTRNDNKEY;
         DSWA16NKDN = EXWA16NKDN;
         DSWA16NKDG = EXWA16NKDG;

         EXWA16DATE = EXTRNDDATE;

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

         EXTRDNDANA = 'TRWA16';
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
           WKFLPORECN = 'TRWA1601';
           //WRITE TRWA16CL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWA16W1;
           WRITE TRWA1601;
           WRITE W1WA16B3;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA1601;
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

             EXSR UWA16;

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
             IF EXWA16KDNR = *BLANK;
               KYWA16KDNR = *BLANK;
             ELSE;
               KYWA16KDNR = EXWA16KDNR;
             ENDIF;
             KYWA16KDGR = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA16;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA16;
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
           CLEAR WA16;
           EXSR ETRMU;
           EXSR EWA16;
           WA16KDNR = KYWA16KDNR;
           WA16KDGR = KYWA16KDGR;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA16;

           EXINFOFILE = 'WA16';
           EXINFODATA = %ADDR(WA16);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA16USER;
           WKJDAT = WA16JDAT;
           WKJZEI = WA16JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA16;
             EXSR EWA16;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA16KDNR = WA16KDNR;
         DSWA16KDGR = WA16KDGR;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA16IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         TXWA16KDNR = *BLANK;
         TXWA16KDGR = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA16KDNR <> *BLANK;
           EXSR PRWA16KDNR;
         ENDIF;

         IF DSWA16KDGR <> *BLANK;
           EXSR PRWA16KDGR;
         ENDIF;

         EXTRPBBFMT = 'TRWA1601';
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
           EXFLPOFLDN = 'DSWA16KDGR';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA16KDGR';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSWA16KDNR <> *BLANK;
             EXFLPOFLDN = 'DSWA16KDGR';
           ELSE;
             EXFLPOFLDN = 'DSWA16KDNR';
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
           WKFLPORECN = 'TRWA16K1';
           EXSR EFLPO;
           WRITE TRWA16W2;
           WRITE TRWA16K1;
           WRITE W2WA16B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA16K1;

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

           EXSR KWA16;
           WKIFMT = '00';
           //IF DSWA16NKDG <> *BLANK;
           //  %SUBST(RTTRNDKEYB:01:10) = KYWA16KDNR;
           //  %SUBST(RTTRNDKEYB:11:04) = KYWA16KDGR;
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

         DSWA16KDNR = KYWA16KDNR;
         DSWA16KDGR = KYWA16KDGR;

         DSWA16NKDN = KYWA16KDNR;
         DSWA16NKDG = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         EXFLPOFLDN = 'DSWA16NKDG';

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

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA16KDNR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA16KDGR';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA16KDNR';

         WHEN FLDNAM = 'DSWA16KDNR';
           EXSR MCWA16KDNR;

         WHEN FLDNAM = 'DSWA16KDGR';
           EXSR MCWA16KDGR;

         WHEN FLDNAM = 'DSWA16NKDN';
           EXSR MCWA16NKDN;

         WHEN FLDNAM = 'DSWA16NKDG';
           EXSR MCWA16NKDG;

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

           WHEN FLDNAM = 'DSWA16KDNR' AND C#LCK1 = *OFF;
             EXSR PRWA16KDNR;

           WHEN FLDNAM = 'DSWA16KDGR' AND C#LCK1 = *OFF;
             EXSR PRWA16KDGR;

           WHEN FLDNAM = 'DSWA16NKDN';
             EXSR PRWA16NKDN;

           WHEN FLDNAM = 'DSWA16NKDG';
             EXSR PRWA16NKDG;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;
         WHEN PCPGST = '3     ';
           KYWA16KDNR = DSWA16NKDN;
           KYWA16KDGR = DSWA16NKDG;
           CHIDS = '01C';
           EXSR CHWA16;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA16NKDG';
             LEAVESR;
           ENDIF;
         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA16KDNR = DSWA16KDNR;
           KYWA16KDGR = DSWA16KDGR;
           CHIDS = '01C';
           EXSR CHWA16;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA16KDGR';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA16KDGR';
             LEAVESR;
           ENDSL;
         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WA16';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA16;
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
       //**  Kopieren Sätze aus Datei WA16                                     ***
       //*************************************************************************
       BEGSR KWA16;

         EXSR KWA1600;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WA16 pro Kunden-Nr                       ***
       //*************************************************************************
       BEGSR KWA1600;

         KYWA16KDNR = DSWA16KDNR;
         OFWA16KDNR = DSWA16KDNR;
         KYWA16KDGR = DSWA16KDGR;
         OFWA16KDGR = DSWA16KDGR;
         IF DSWA16KDGR = *BLANK;
           OFWA16KDGR = *HIVAL;
         ENDIF;
         CHIDS = '00+';
         EXSR CHWA16;
         DOW CHI(5) = 'J'
           AND WA16FIRM = KYWA16FIRM
           AND WA16KDNR <= OFWA16KDNR
           AND WA16KDGR <= OFWA16KDGR;

           EXSR UWA16;

           CHIDS = '00R';
           EXSR CHWA16;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA16-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA16;

         OFWA16KDNR = KYWA16KDNR;
         OFWA16KDGR = KYWA16KDGR;
         IF KYWA16KDGR = *BLANK;
           OFWA16KDGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA16;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA16FIRM = KYWA16FIRM
           AND WA16KDNR <= OFWA16KDNR
           AND WA16KDGR <= OFWA16KDGR;

           IF WA16LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA16LOCK';
             LEAVE;
           ENDIF;

          KYKDNR = WA16KDNR;
          CHIDS = '01C';
          exsr CHKUND;
          if KDLOCK = 'L';
            WKFENR = '0416';
            W$PA03 = KDJNAM;
            W$PA04 = KDUSER;
            WKFFLD = 'KDLOCK';
            leave;
          endif;

           CHIDS = '01R';
           EXSR CHWA16;
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
       //**  Löschen Sätze Datei WA16                                          ***
       //*************************************************************************
       BEGSR LWA16;

         OFWA16KDNR = KYWA16KDNR;
         OFWA16KDGR = KYWA16KDGR;
         IF KYWA16KDGR = *BLANK;
           OFWA16KDGR = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWA16;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND WA16FIRM = KYWA16FIRM
           AND WA16KDNR <= OFWA16KDNR
           AND WA16KDGR <= OFWA16KDGR;

           EXSR LPOSI;

           KYWA16KDNR = WA16KDNR;
           KYWA16KDGR = WA16KDGR;
           CHIDS = '01CU';
           EXSR CHWA16;

           CHIDS = '01D';
           EXSR CHWA16;

           exsr UKUND;

           CHIDS = '01R';
           EXSR CHWA16;
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
       //**  Update Datei WA16                                                 ***
       //*************************************************************************
       BEGSR UWA16;

         KYWA16KDNR = DSWA16KDNR;
         KYWA16KDGR = DSWA16KDGR;

         IF PCPGST = '3     ';
           KYWA16KDNR = DSWA16NKDN;
           KYWA16KDGR = DSWA16NKDG;
           IF DSWA16NKDG = *BLANK;
             KYWA16KDGR = WA16KDGR;
           ENDIF;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA16;

         WA16JNAM = DAJNAM;
         WA16PROG = DAPROG;
         WA16BIBL = WKCHPL;
         WA16USER = DAUSER;
         WA16JZEI = %DEC(%TIME());
         WA16JDAT = %DEC(%DATE:*ISO);

         SELECT;

         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA16;

         WHEN CHI(6) = *ON;
           C_EXTSTP(WA16TSTP);
           WA16ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA16;

           exsr UKUND;

           #CRTCD = 'W';

         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA16;

           exsr UKUND;

           #CRTCD = 'U';

         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  Update Datei KUND                                                 ***
       //*************************************************************************
       begsr UKUND;

         KYKDNR = WA16KDNR;

         CHIDS = '01CU';
         exsr CHKUND;

         KDJNAM = DAJNAM;
         KDPROG = DAPROG;
         KDPROG = WKCHPN;
         KDBIBL = WKCHPL;
         KDUSER = DAUSER;
         KDJZEI = %DEC(%TIME());
         KDJDAT = %DEC(%DATE:*ISO);

         if CHI(5) = 'J';
           CHIDS = '01U';
           exsr CHKUND;
         endif;

       endsr;

       //*************************************************************************
       //**  MC-Routine KDNR                                                   ***
       //*************************************************************************
       BEGSR MCWA16KDNR;

         C#WNDW = *ON;

         IF DSWA16KDNR = *BLANK;
           TXWA16KDNR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWA16KDNR;
         #CUEBE = '0526';
         #CPGST = *BLANK;
         EXSR MCKUND;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA16KDNR = KDKDNR;
           TXWA16KDNR = KDKNAM;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine KDNR                                                   ***
       //*************************************************************************
       BEGSR PRWA16KDNR;

         EXFLPOFLDN = 'DSWA16KDNR';

         KYKDNR = DSWA16KDNR;
         CHIDS  = '01C';
         EXSR CHKUND;
         DSWA16KDNR = KDKDNR;
         TXWA16KDNR = KDKNAM;
         if WKFENR <> *ZERO;
           leavesr;
         endif;

         if KDLOCK = 'L';
           WKFENR = '0416';
           W$PA03 = KDJNAM;
           W$PA04 = KDUSER;
         endif;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KDGR                                                   ***
       //*************************************************************************
       BEGSR MCWA16KDGR;

         C#WNDW = *ON;

         IF DSWA16KDGR = *BLANK;
           TXWA16KDGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSWA16KDGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA16KDGR = TPTCDE;
           TXWA16KDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune KDGR                                                   ***
       //*************************************************************************
       BEGSR PRWA16KDGR;

         EXFLPOFLDN = 'DSWA16KDGR';
         TXWA16KDGR = *BLANK;

         SELECT;
         WHEN WKFLPORECN = 'TRWA16K1'
           AND DSWA16KDGR = *BLANK
           AND DSWA16NKDG = *BLANK;
           LEAVESR;
         ENDSL;

         KYTPTA = 'KDGR';
         KYTPTC = DSWA16KDGR;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXWA16KDGR = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NKDN                                                   ***
       //*************************************************************************
       BEGSR MCWA16NKDN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA16NKDN;
         #CUEBE = '0526';
         #CPGST = *BLANK;
         EXSR MCKUND;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA16NKDN = KDKDNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NKDN                                                   ***
       //*************************************************************************
       BEGSR PRWA16NKDN;

         EXFLPOFLDN = 'DSWA16NKDN';

         KYKDNR = DSWA16NKDN;
         CHIDS  = '01C';
         EXSR CHKUND;
         DSWA16NKDN = KDKDNR;
         if WKFENR <> *ZERO;
           leavesr;
         endif;

         if KDLOCK = 'L';
           WKFENR = '0416';
           W$PA03 = KDJNAM;
           W$PA04 = KDUSER;
         endif;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NKDG                                                   ***
       //*************************************************************************
       BEGSR MCWA16NKDG;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSWA16NKDG;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWA16NKDG = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NKDG                                                   ***
       //*************************************************************************
       BEGSR PRWA16NKDG;

         EXFLPOFLDN = 'DSWA16NKDG';

         SELECT;
         WHEN WKFLPORECN = 'TRWA16K1'
           AND DSWA16KDGR = *BLANK
           AND DSWA16NKDG = *BLANK;
           LEAVESR;
         ENDSL;

         KYTPTA = 'KDGR';
         KYTPTC = DSWA16NKDG;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine WA17                                                   ***
       //*************************************************************************
       BEGSR MCAUFRWA17;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWA16KDGR;
         #CPGST = *BLANK;
         IF PCPGST = '5     ';
           #CPGST = 'DETAIL';
         ENDIF;
         #CUEBE = *BLANK;
         EXSR MCWA17;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA16';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA16;

           CLEAR EXDATA;
           EXDATAFILE = 'WA16';
           EXDATADATA = WA16;
           C_INZDATASTR(EXDATA: RTDATA);

           WA16 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA16;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Preis und Konditionen                                   ***
       // WA16 Sätze pro Kunde lesen, KDGR/PRGR prüfen ob ein WA17 Satz
       // vorhanden ist, dann den WA17 an ERPRKO zurück geben.
       //*************************************************************************
       begsr ERPRKO;

         clear WA16;
         clear WA17;
         clear RTTREND;

         KYWA16KDNR = DSWA16KDNR;
         KYWA16KDGR = *LOVAL;
         CHIDS = '01+';
         exsr CHWA16;
         DOW CHI(5) = 'J'
            and WA16FIRM = KYWA16FIRM
            and WA16KDNR = KYWA16KDNR;

           KYWA17FIRM = WA16FIRM;
           KYWA17PRGR = WKWA17PRGR;
           KYWA17KDGR = WA16KDGR;
           CHIDS = '01C';
           exsr CHWA17;
           if CHI(5) = 'J';
             RTTRNDFENR = WKFENR;
             RTTRNDDATE = WA16;
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           exsr CHWA16;
         ENDDO;

       endsr;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA16';
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

           EXTRDNPGNA = 'TRWA16';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA16B1'    EXTRDNPGNA
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
           WHEN EXTRDNDANA = 'MCWA17';
             EXSR MCAUFRWA17;
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

         PGMNAM = 'TRWA16';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA16W2;
         OTHER;
           WRITE CTWA16W1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA16W2;
         OTHER;
           WRITE CTWA16W1;
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
      /COPY QCPYSRC,CHKUND
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA16
      /COPY QCPYSRC,CHWA17
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCKUND
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,MCWA17
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
