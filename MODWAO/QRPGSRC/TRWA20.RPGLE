     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei WA20
      //*************************************************************************
      //  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 05.12.2024 Case #03829427
      //  -----------------------------------------------------------------------
      //  Änderung: JK 21.01.2025 löschen WA20 und WA21 - prüfung # status darf nicht
      //            90 sein
      //            Wenn löschen zulässig, dann BKOK und BKOP mit löschen
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WA20.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWA20FM  CF   E             WORKSTN USROPN
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
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ

     D BLPA          E DS                  INZ
     D KYBLPA        E DS                  INZ

     D BLPO          E DS                  INZ
     D KYBLPO        E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

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

     D WA20          E DS                  INZ
     D KYWA20        E DS                  INZ

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

     D EXKUSR        E DS                  INZ

     D EXBKOK        E DS
     D RTBKOK        E DS

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

     D EXWA20          DS                  INZ
     D  EXWA20PRKZ                  256
     D   EXWA20IFKZ                   1    OVERLAY(EXWA20PRKZ:*NEXT)
     D   EXWA20PRRT                   1    OVERLAY(EXWA20PRKZ:*NEXT)

     D  EXWA20KEYB                  256
     D   EXWA20BLJJ                        OVERLAY(EXWA20KEYB:*NEXT)
     D                                     LIKE(WA20BLJJ)
     D   EXWA20BLNR                        OVERLAY(EXWA20KEYB:*NEXT)
     D                                     LIKE(WA20BLNR)

     D  EXWA20NKEY                  256
     D   EXWA20NBLJ                        OVERLAY(EXWA20NKEY:*NEXT)
     D                                     LIKE(WA20BLJJ)
     D   EXWA20NBLN                        OVERLAY(EXWA20NKEY:*NEXT)
     D                                     LIKE(WA20BLNR)

     D  EXWA20DATE                 1024
     D   EXWA20BLNN                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20BLNN)
     D   EXWA20BLGA                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20BLGA)
     D   EXWA20LFNR                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20LFNR)
     D   EXWA20FRUS                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20FRUS)
     D   EXWA20FRDA                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20FRDA)
     D   EXWA20STAT                        OVERLAY(EXWA20DATE:*NEXT)
     D                                     LIKE(WA20STAT)

     D RTWA20          DS                  INZ
     D  RTWA20KEYB                  256
     D   RTWA20BLJJ                        OVERLAY(RTWA20KEYB:*NEXT)
     D                                     LIKE(WA20BLJJ)
     D   RTWA20BLNR                        OVERLAY(RTWA20KEYB:*NEXT)
     D                                     LIKE(WA20BLNR)

     D  RTWA20DATE                 1024
     D   RTWA20BLNN                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20BLNN)
     D   RTWA20BLGA                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20BLGA)
     D   RTWA20LFNR                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20LFNR)
     D   RTWA20FRUS                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20FRUS)
     D   RTWA20FRDA                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20FRDA)
     D   RTWA20STAT                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20STAT)
     D   RTWA20TSTP                        OVERLAY(RTWA20DATE:*NEXT)
     D                                     LIKE(WA20TSTP)

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
     D OFWA20BLJJ      S                   LIKE(KYWA20BLJJ)
     D OFWA20BLNR      S                   LIKE(KYWA20BLNR)
     D DSWA20BLNN      S                   LIKE(WA20BLNN)
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
      // Parameter:      #WA20TSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WA20TSTP                          LIKE(WA20TSTP)

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
      // Program name: C_TRWA21
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_TRWA21...
     D                 PR                  EXTPGM('TRWA21')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

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
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRBKOK
      // Purpose:
      // Returns:
      // Parameter:      #EXBKOK
      // Parameter:      #RTBKOK
      //--------------------------------------------------
     D C_TRBKOK...
     D                 PR                  EXTPGM('TRBKOK')
     D  #EXBKOK                            LIKEDS(EXBKOK)
     D  #RTBKOK                            LIKEDS(RTBKOK)

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
           CLOSE TRWA20FM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '1     ';
         DSWA20STAT = '90';
         EXSR UWA20;
         EXSR UBKOK;
         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKIFMT = 'K1';

       WHEN PCPGST = 'PWA20 ';
         EXSR PWA20;
         WKIFMT = '00';

       WHEN PCPGST = '4     ';
         EXSR PWA20;

         IF WKFENR = *ZERO;
           EXSR LWA20;
           EXSR TRBKOK;
         ENDIF;

         WKIFMT = '00';

       // Externes Update
       WHEN EXWA20IFKZ <> *BLANK;
         exsr IFWA20;
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
           OPEN(E) TRWA20FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWA20';
             EXTRDZAUSW = 'TRWA20';
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
         CLOSE(E) TRWA20FM;
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
         KYBLKOFIRM = DAFIRM;  // BLKO
         KYBLPAFIRM = DAFIRM;  // BLPA
         KYLFFI = DAFIRM;      // LIEF
         KYSYTPFIRM = DAFIRM;  // SYTP
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWA20FIRM = DAFIRM;  // WA20

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWA20FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWA20FM';

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
         EXWA20PRKZ = EXTRNDPRKZ;

         EXWA20KEYB = EXTRNDKEYB;
         MONITOR;
           EXWA20BLJJ = %INT(%SUBST(EXWA20KEYB:01:04));
         ON-ERROR *PROGRAM;
           EXWA20BLJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         KYWA20BLJJ = EXWA20BLJJ;
         KYWA20BLNR = EXWA20BLNR;

         DSWA20BLJJ = EXWA20BLJJ;
         DSWA20BLNR = EXWA20BLNR;

         EXWA20NKEY = EXTRNDNKEY;
         MONITOR;
           EXWA20NBLJ = %INT(%SUBST(EXWA20NKEY:01:04));
         ON-ERROR *PROGRAM;
           EXWA20NBLJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         DSWA20NBLJ = EXWA20NBLJ;
         DSWA20NBLN = EXWA20NBLN;

         EXWA20DATE = EXTRNDDATE;
         MONITOR;
           EXWA20BLNN = %INT(%SUBST(EXWA20DATE:01:06));
         ON-ERROR *PROGRAM;
           EXWA20BLNN = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;

         CLEAR RTTREND;

         CLEAR RTWA20BLJJ;
         RTTRNDKEYB = RTWA20KEYB;

         CLEAR RTWA20DATE;
         CLEAR RTWA20BLNN;
         CLEAR RTWA20FRDA;
         CLEAR RTWA20TSTP;
         RTTRNDDATE = RTWA20DATE;

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

         EXTRDNDANA = 'TRWA20';
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
           WKFLPORECN = 'TRWA2001';
           WRITE TRWA20CL;
           EXSR EFLPO;

           IF RCDNRTRDZB > *ZERO;
             WRITE SFTRDZBK1;
           ENDIF;

           WRITE TRWA2001;
           WRITE TRWA20B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           //FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWA2001;
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

             EXSR UWA20;

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
             KYWA20BLJJ = *ZERO;
             KYWA20BLNR = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWA20;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWA20;
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
           CLEAR WA20;
           EXSR ETRMU;
           EXSR EWA20;
           WA20BLJJ = KYWA20BLJJ;
           WA20BLNR = KYWA20BLNR;
         OTHER;
           CHIDS = '01C';
           EXSR CHWA20;

           EXINFOFILE = 'WA20';
           EXINFODATA = %ADDR(WA20);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WA20USER;
           WKJDAT = WA20JDAT;
           WKJZEI = WA20JZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWA20;
             EXSR EWA20;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWA20BLJJ = WA20BLJJ;
         DSWA20BLNR = WA20BLNR;

         DSWA20BLNN = WA20BLNN;

         DSWA20BLGA = WA20BLGA;
         DSWA20LFNR = WA20LFNR;
         DSWA20FRUS = WA20FRUS;

         CLEAR EXDATE;
         EXDATEDATV = WA20FRDA;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSWA20FRDA = RTDATEDATE;

         DSWA20STAT = WA20STAT;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXWA20IFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         TXWA20LFNR = *BLANK;
         DSLIEFPOLD = *BLANK;
         DSLIEFPOLZ = *BLANK;

         TXWA20BLGA = *BLANK;
         TXWA20FRUS = *BLANK;
         TXWA20STAT = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWA20LFNR <> *BLANK;
           EXSR PRWA20LFNR;
         ENDIF;

         IF DSWA20BLGA <> *BLANK;
           EXSR PRWA20BLGA;
         ENDIF;

         IF DSWA20FRUS <> *BLANK;
           EXSR PRWA20FRUS;
         ENDIF;

         IF DSWA20STAT <> *BLANK;
           EXSR PRWA20STAT;
         ENDIF;

         EXTRPBBFMT = 'TRWA2001';
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
           EXFLPOFLDN = 'DSWA20BLGA';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWA20BLGA';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSWA20BLJJ <> *ZERO;
             EXFLPOFLDN = 'DSWA20BLNR';
           ELSE;
             EXFLPOFLDN = 'DSWA20BLJJ';
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
           WKFLPORECN = 'TRWA20K1';
           EXSR EFLPO;
           WRITE TRWA20W2;
           WRITE TRWA20K1;
           WRITE W2WA20B1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWA20K1;

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

           EXSR KWA20;
           EXSR UWA20;

           WKIFMT = '00';
           %SUBST(RTTRNDKEYB:01:04) = %EDITC(KYWA20BLJJ:'X');
           %SUBST(RTTRNDKEYB:05:06) = KYWA20BLNR;
         ENDDO;

         RTTRNDRTCD = #CRTCD;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat K1                                        ***
       //*************************************************************************
       BEGSR BK1DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         DSWA20BLJJ = KYWA20BLJJ;
         DSWA20BLNR = KYWA20BLNR;

         DSWA20NBLJ = KYWA20BLJJ;
         DSWA20NBLN = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSWA20NBLN';

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

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSWA20BLNR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA20BLGA';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA20LFNR';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA20FRUS';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA20FRDA';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSWA20STAT';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWA20BLNR';

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

           WHEN FLDNAM = 'DSWA20BLNR' AND C#LCK1 = *OFF;
             EXSR PRWA20BLNR;

           WHEN FLDNAM = 'DSWA20BLGA' AND C#LCK0 = *OFF;
             EXSR PRWA20BLGA;

           WHEN FLDNAM = 'DSWA20LFNR' AND C#LCK0 = *OFF;
             EXSR PRWA20LFNR;

           WHEN FLDNAM = 'DSWA20FRUS' AND C#LCK0 = *OFF;
             EXSR PRWA20FRUS;

           WHEN FLDNAM = 'DSWA20FRDA' AND C#LCK0 = *OFF;
             EXSR PRWA20FRDA;

           WHEN FLDNAM = 'DSWA20STAT' AND C#LCK0 = *OFF;
             EXSR PRWA20STAT;

           WHEN FLDNAM = 'DSWA20NBLN';
             EXSR PRWA20NBLN;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYWA20BLJJ = DSWA20NBLJ;
           KYWA20BLNR = DSWA20NBLN;
           CHIDS = '01C';
           EXSR CHWA20;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA20NBLN';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYWA20BLJJ = DSWA20BLJJ;
           KYWA20BLNR = DSWA20BLNR;
           CHIDS = '01C';
           EXSR CHWA20;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWA20BLNR';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWA20BLNR';
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

         KYTRMUDANA = 'WA20';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WA20;
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
       //**  Kopieren Sätze aus Datei WA20                                     ***
       //*************************************************************************
       BEGSR KWA20;

         KYWA20BLJJ = DSWA20BLJJ;
         KYWA20BLNR = DSWA20BLNR;
         CHIDS = '01C';
         EXSR CHWA20;
         IF WKFENR = *ZERO;
           DSWA20BLGA = WA20BLGA;
           DSWA20LFNR = WA20LFNR;
           DSWA20FRUS = WA20FRUS;

           CLEAR EXDATE;
           EXDATEDATV = WA20FRDA;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           DSWA20FRDA = RTDATEDATE;

           DSWA20STAT = WA20STAT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WA20-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWA20;

         OFWA20BLJJ = KYWA20BLJJ;
         OFWA20BLNR = KYWA20BLNR;
         CHIDS = '01+';
         EXSR CHWA20;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA20FIRM = KYWA20FIRM
           AND WA20BLJJ <= OFWA20BLJJ
           AND WA20BLNR <= OFWA20BLNR;

           IF WA20LOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WA20LOCK';
             LEAVE;
           ENDIF;

           IF WA20STAT = '90';
             WKFENR = '0004';
             WKFFLD = 'WA20LOCK';
             LEAVE;
           ENDIF;

           PCPGST = 'PWA21 ';
           EXSR TRWA21;
           IF WKFENR <> *ZERO;
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWA20;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;

         CLEAR RTWA20BLJJ;
         RTTRNDKEYB = RTWA20KEYB;

         CLEAR RTWA20DATE;
         CLEAR RTWA20BLNN;
         CLEAR RTWA20FRDA;
         CLEAR RTWA20TSTP;
         RTTRNDDATE = RTWA20DATE;

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
       //**  Löschen Sätze Datei WA20                                          ***
       //*************************************************************************
       BEGSR LWA20;

         OFWA20BLJJ = KYWA20BLJJ;
         OFWA20BLNR = KYWA20BLNR;
         CHIDS = '01+';
         EXSR CHWA20;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND WA20FIRM = KYWA20FIRM
           AND WA20BLJJ <= OFWA20BLJJ
           AND WA20BLNR <= OFWA20BLNR;

           EXSR LPOSI;

           KYWA20BLJJ = WA20BLJJ;
           KYWA20BLNR = WA20BLNR;
           CHIDS = '01CU';
           EXSR CHWA20;

           CHIDS = '01D';
           EXSR CHWA20;

           CHIDS = '01R';
           EXSR CHWA20;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
         ENDDO;

         CLEAR RTTREND;

         CLEAR RTWA20BLJJ;
         RTTRNDKEYB = RTWA20KEYB;

         CLEAR RTWA20DATE;
         CLEAR RTWA20BLNN;
         CLEAR RTWA20FRDA;
         CLEAR RTWA20TSTP;
         RTTRNDDATE = RTWA20DATE;

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

         PCPGST = '4     ';
         EXSR TRWA21;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI BKOK - löschen                                       ***
       //*************************************************************************
       BEGSR TRBKOK;

       CLEAR EXBKOK;
       EXBKOKBLAT = 'RE';
       EXBKOKBLJJ = KYWA20BLJJ;
       EXBKOKBLNR = KYWA20BLNR;
       EXBKOKPGST = '4';
       CALLP(E) C_TRBKOK(EXBKOK:RTBKOK);
       *IN98 = %ERROR;

       WKPROG = RTBKOKPROG;
       WKDANA = RTBKOKDANA;
       WKFFLD = RTBKOKFFLD;
       WKFENR = RTBKOKFENR;
       W$PA03 = RTBKOKPA03;
       W$PA04 = RTBKOKPA04;
       W$PA05 = RTBKOKPA05;
       W$PA06 = RTBKOKPA06;
       W$PA07 = RTBKOKPA07;
       #CRTCD = RTBKOKRTCD;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI BKOK - statusupdate                                  ***
       //*************************************************************************
       BEGSR UBKOK;

       CLEAR EXBKOK;
       EXBKOKBLAT = 'RE';
       EXBKOKBLJJ = KYWA20BLJJ;
       EXBKOKBLNR = KYWA20BLNR;
       EXBKOKOKST = '30';
       EXBKOKPGST = '8';
       CALLP(E) C_TRBKOK(EXBKOK:RTBKOK);
       *IN98 = %ERROR;

       WKPROG = RTBKOKPROG;
       WKDANA = RTBKOKDANA;
       WKFFLD = RTBKOKFFLD;
       WKFENR = RTBKOKFENR;
       W$PA03 = RTBKOKPA03;
       W$PA04 = RTBKOKPA04;
       W$PA05 = RTBKOKPA05;
       W$PA06 = RTBKOKPA06;
       W$PA07 = RTBKOKPA07;
       #CRTCD = RTBKOKRTCD;

       ENDSR;
       //*************************************************************************
       //**  Update aus externen Programmen                                    ***
       //*************************************************************************
       BEGSR IFWA20;

         IF EXWA20IFKZ = '0';
           // Satz auf Existenz prüfen
           KYWA20BLJJ = EXWA20BLJJ;
           KYWA20BLNR = EXWA20BLNR;
           CHIDS = '01C';
           EXSR CHWA20;
           IF CHI(05) = 'N';
             // Neuanlage
             PCPGST = *BLANK;
           ELSE;
             // Änderung
             PCPGST = '2     ';
           ENDIF;
         ENDIF;

         EXSR B01DS;

         IF EXWA20BLNN <> *ZERO;
           DSWA20BLNN = EXWA20BLNN;
         ENDIF;

         IF EXWA20BLGA <> *BLANK;
           DSWA20BLGA = EXWA20BLGA;
         ENDIF;

         IF EXWA20LFNR <> *BLANK;
           DSWA20LFNR = EXWA20LFNR;
         ENDIF;

         IF EXWA20FRUS <> *BLANK;
           DSWA20FRUS = EXWA20FRUS;
         ENDIF;

         IF EXWA20FRDA <> *ZERO;
           CLEAR EXDATE;
           EXDATEDATV = EXWA20FRDA;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           DSWA20FRDA = RTDATEDATE;
         ENDIF;

         IF EXWA20STAT <> *BLANK;
           DSWA20STAT = EXWA20STAT;
         ENDIF;

         // Prüfung der Felder nur dann wenn dies expliziet von extern mitgegeben wird
         WKFENR = *ZERO;
         IF EXWA20PRRT = *ON OR EXWA20PRRT = *BLANK;
           WKFLPORECN = 'TRWA2001';
           EXSR EFLPO;
           EXSR BILDPR;
         ENDIF;

         IF WKFENR = *ZERO;
           EXSR UWA20;
         ELSE;
           WKFFLD = %SUBST(EXFLPOFLDN:3:8);
         ENDIF;

         CLEAR RTTREND;

         CLEAR RTWA20BLJJ;
         RTTRNDKEYB = RTWA20KEYB;

         RTTRNDPROG = WKPROG;
         RTTRNDDANA = WKDANA;
         RTTRNDFFLD = WKFFLD;
         RTTRNDFENR = WKFENR;
         RTTRNDPA03 = W$PA03;
         RTTRNDPA04 = W$PA04;
         RTTRNDPA05 = W$PA05;
         RTTRNDPA06 = W$PA06;
         RTTRNDPA07 = W$PA07;

         CLEAR RTWA20DATE;
         CLEAR RTWA20BLNN;
         CLEAR RTWA20FRDA;
         IF #CRTCD = 'W';  // TSTP für neu angelegten Satz zurückgeben
           RTWA20TSTP = WA20TSTP;
         ELSE;
           CLEAR RTWA20TSTP;
         ENDIF;
         RTTRNDDATE = RTWA20DATE;

         // Wenn Satz gesperrt wurde, dann freigeben
         IF K#WA20LOCK = 'L';
           CHIDS = '01CF';
           EXSR CHWA20;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA20                                                 ***
       //*************************************************************************
       BEGSR UWA20;

         KYWA20BLJJ = DSWA20BLJJ;
         KYWA20BLNR = DSWA20BLNR;

         IF PCPGST = '3     ';
           KYWA20BLJJ = DSWA20NBLJ;
           KYWA20BLNR = DSWA20NBLN;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWA20;

         WA20BLNN = DSWA20BLNN;

         WA20BLGA = DSWA20BLGA;
         WA20LFNR = DSWA20LFNR;
         // WA20FRUS = DSWA20FRUS;

         CLEAR EXDATE;
         EXDATEDATV = DSWA20FRDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         // WA20FRDA = RTDATEDATE;

         WA20STAT = DSWA20STAT;

         WA20JNAM = DAJNAM;
         WA20PROG = DAPROG;
         WA20BIBL = WKCHPL;
         WA20USER = DAUSER;
         WA20JZEI = %DEC(%TIME());
         WA20JDAT = %DEC(%DATE:*ISO);

         IF  PCPGST = '1     ';
           WA20FRUS = DAUSER;
           WA20FRDA = %DEC(%DATE:*ISO);
         ENDIF;

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWA20;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WA20TSTP);
           WA20ERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWA20;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWA20;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune BLNR                                                   ***
       //*************************************************************************
       BEGSR PRWA20BLNR;

         EXFLPOFLDN = 'DSWA20BLNR';

         KYBLKOBLJJ = DSWA20BLJJ;
         KYBLKOBLNR = DSWA20BLNR;
         CHIDS  = '01C';
         EXSR CHBLKO;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune BLGA                                                   ***
       //*************************************************************************
       BEGSR PRWA20BLGA;

         EXFLPOFLDN = 'DSWA20BLGA';
         TXWA20BLGA = *BLANK;

         IF DSWA20BLGA <> *BLANK;
           KYBLPABLGA = DSWA20BLGA;
           CHIDS  = '01C';
           EXSR CHBLPA;
           TXWA20BLGA = BLPAABEZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune LFNR                                                   ***
       //*************************************************************************
       BEGSR PRWA20LFNR;

         EXFLPOFLDN = 'DSWA20LFNR';
         TXWA20LFNR = *BLANK;
         DSLIEFPOLD = *BLANK;
         DSLIEFPOLZ = *BLANK;

         KYLFNR = DSWA20LFNR;
         CHIDS  = '01C';
         EXSR CHLIEF;
         DSWA20LFNR = LFLFNR;
         TXWA20LFNR = LFKNAM;
         DSLIEFPOLD = LFPOLD;
         DSLIEFPOLZ = LFPOLZ;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune FRUS                                                   ***
       //*************************************************************************
       BEGSR PRWA20FRUS;

         EXFLPOFLDN = 'DSWA20FRUS';
         TXWA20FRUS = *ZERO;

         IF DSWA20FRUS <> *BLANK;
           EXKUSRUUSR = DSWA20FRUS;
           EXSR PRKUSR;
           TXWA20FRUS = EXKUSRUNAM;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine FRDA                                                   ***
       //*************************************************************************
       BEGSR PRWA20FRDA;

         EXFLPOFLDN = 'DSWA20FRDA';

         IF DSWA20FRDA <> *ZERO;
           CLEAR EXDATE;
           EXDATEDATV = DSWA20FRDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAPR';
           EXSR TRDATE;
           IF WKFENR = *ZERO;
             LEAVESR;
           ENDIF;

           DSWA20FRDA = RTDATEDATE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine STAT                                                   ***
       //*************************************************************************
       BEGSR PRWA20STAT;

         EXFLPOFLDN = 'DSWA20STAT';
         TXWA20STAT = *BLANK;

         IF DSWA20STAT <> *BLANK;
           KYSYTPTART = '$$WA20STAT';
           KYSYTPTCDE = DSWA20STAT;
           KYSYTPTFLG = *ZERO;
           CHIDS = '01C';
           EXSR CHSYTP;
           TXWA20STAT = SYTPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NBLN                                                   ***
       //*************************************************************************
       BEGSR PRWA20NBLN;

         EXFLPOFLDN = 'DSWA20NBLN';

         KYBLKOBLJJ = DSWA20NBLJ;
         KYBLKOBLNR = DSWA20NBLN;
         CHIDS  = '01C';
         EXSR CHBLKO;

       ENDSR;

       //*************************************************************************
       //**  Update Datei WA21                                                 ***
       //*************************************************************************
       BEGSR TRWA21;

         CLEAR EXTREND;
         EXTRNDPGST = PCPGST;
         %SUBST(EXTRNDKEYB:01:04) = %EDITC(KYWA20BLJJ:'X');
         %SUBST(EXTRNDKEYB:05:06) = KYWA20BLNR;
         CALLP(E) C_TRWA21(EXTREND:RTTREND);

         WKPROG = RTTRNDPROG;
         WKDANA = RTTRNDDANA;
         WKFFLD = RTTRNDFFLD;
         WKFENR = RTTRNDFENR;
         W$PA03 = RTTRNDPA03;
         W$PA04 = RTTRNDPA04;
         W$PA05 = RTTRNDPA05;
         W$PA06 = RTTRNDPA06;
         W$PA07 = RTTRNDPA07;

         IF WKFENR = *BLANK;
           WKFENR = *ZERO;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WA20';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WA20;

           CLEAR EXDATA;
           EXDATAFILE = 'WA20';
           EXDATADATA = WA20;
           C_INZDATASTR(EXDATA: RTDATA);

           WA20 = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWA20;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWA20';
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

           EXTRDNPGNA = 'TRWA20';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWA20B1'    EXTRDNPGNA
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

         PGMNAM = 'TRWA20';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA20W2;
         OTHER;
           WRITE TRWA20CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWA20W2;
         OTHER;
           WRITE TRWA20CT;
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
      /COPY QCPYSRC,CHBLKO
      /COPY QCPYSRC,CHBLPA
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWA20
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,PRKUSR
      /COPY QCPYSRC,PRTRPC
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
