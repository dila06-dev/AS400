     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
      //*************************************************************************
      /TITLE Verwalten Datei WAOX
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 13.08.2015 Projekt 11567
      //  -----------------------------------------------------------------------
      //  Änderung: PH 13.08.2015 Projekt 11567. Backport auf Release 10.0
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei WAOX.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRWAOXFM  CF   E             WORKSTN USROPN
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

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

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

     D WAOX          E DS                  INZ
     D KYWAOX        E DS                  INZ

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
     D ##TRNDTENR      S                   LIKE(KYWAOXTENR)
     D OFWAOXTENR      S                   LIKE(KYWAOXTENR)
     D OFWAOXLAND      S                   LIKE(KYWAOXLAND)
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
      // Parameter:      #WAOXTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WAOXTSTP                          LIKE(WAOXTSTP)

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
           CLOSE TRWAOXFM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';
       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRWAOXK1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KWAOX;
           EXSR UWAOX;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PWAOX ';
         EXSR PWAOX;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PWAOX;

         IF WKFENR = *ZERO;
           EXSR LWAOX;
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
           OPEN(E) TRWAOXFM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRWAOX';
             EXTRDZAUSW = 'TRWAOX';
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
         CLOSE(E) TRWAOXFM;
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
         KYTEFI = DAFIRM;      // TEIL
         KYTRMUFIRM = DAFIRM;  // TRMU
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYWAOXFIRM = DAFIRM;  // WAOX

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRWAOXFM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRWAOXFM';

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

         KYWAOXTENR = %SUBST(EXTRNDKEYB:01);
         ##TRNDTENR = %SUBST(EXTRNDKEYB:01);
         KYWAOXLAND = %SUBST(EXTRNDKEYB:16);

         DSWAOXTENR = %SUBST(EXTRNDKEYB:01);
         DSWAOXLAND = %SUBST(EXTRNDKEYB:16);

         DSWAOXNTEN = %SUBST(EXTRNDNKEY:01);
         DSWAOXNLAN = %SUBST(EXTRNDNKEY:16);

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
         %SUBST(W99DS:01) = EXFIRMKNAM;
         %SUBST(W99DS:31) = *BLANK;

         EXTRDNDANA = 'TRWAOX';
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;
         //DSKOPF = W99DS;
         WNKOPF = %SUBST(W99DS:32);

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
           WKFLPORECN = 'TRWAOX01';
           //WRITE TRWAOXCL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRWAOXW1;
           WRITE TRWAOX01;
           WRITE W1WAOXB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           //FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRWAOX01;
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

             EXSR UWAOX;

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
             IF ##TRNDTENR = *BLANK;
               KYWAOXTENR = *BLANK;
             ELSE;
               KYWAOXTENR = ##TRNDTENR;
             ENDIF;
             KYWAOXLAND = *BLANK;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHWAOX;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHWAOX;
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
           CLEAR WAOX;
           EXSR ETRMU;
           EXSR EWAOX;
           WAOXTENR = KYWAOXTENR;
           WAOXLAND = KYWAOXLAND;
         OTHER;
           CHIDS = '01C';
           EXSR CHWAOX;

           EXINFOFILE = 'WAOX';
           EXINFODATA = %ADDR(WAOX);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = WAOXUSER;
           WKJDAT = WAOXJDAT;
           WKJZEI = WAOXJZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHWAOX;
             EXSR EWAOX;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSWAOXTENR = WAOXTENR;
         DSWAOXLAND = WAOXLAND;

         // Initialisieren der Textfelder
         DSTEILTBZ1 = *BLANK;
         DSTEILTBZ2 = *BLANK;
         TXWAOXLAND = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSWAOXTENR <> *BLANK;
           EXSR PRWAOXTENR;
         ENDIF;

         IF DSWAOXLAND <> *BLANK;
           EXSR PRWAOXLAND;
         ENDIF;

         EXTRPBBFMT = 'TRWAOX01';
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
           EXFLPOFLDN = 'DSWAOXLAND';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;
         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSWAOXLAND';
         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;
         OTHER;
           IF DSWAOXTENR <> *BLANK;
             EXFLPOFLDN = 'DSWAOXLAND';
           ELSE;
             EXFLPOFLDN = 'DSWAOXTENR';
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
           WKFLPORECN = 'TRWAOXK1';
           EXSR EFLPO;
           WRITE TRWAOXW2;
           WRITE TRWAOXK1;
           WRITE W2WAOXB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRWAOXK1;

           IF %ERROR OR %EOF;
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

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           EXSR BILDPR;
           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR KWAOX;
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

         DSWAOXTENR = KYWAOXTENR;
         DSWAOXLAND = KYWAOXLAND;

         DSWAOXNTEN = KYWAOXTENR;
         DSWAOXNLAN = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         EXFLPOFLDN = 'DSWAOXNLAN';

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
           AND FLDNAM = 'DSWAOXTENR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON
           AND FLDNAM = 'DSWAOXLAND';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSWAOXTENR';

         WHEN FLDNAM = 'DSWAOXTENR';
           EXSR MCWAOXTENR;

         WHEN FLDNAM = 'DSWAOXLAND';
           EXSR MCWAOXLAND;

         WHEN FLDNAM = 'DSWAOXNTEN';
           EXSR MCWAOXNTEN;

         WHEN FLDNAM = 'DSWAOXNLAN';
           EXSR MCWAOXNLAN;

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

           WHEN FLDNAM = 'DSWAOXTENR'
             AND C#LCK1 = *OFF;
             EXSR PRWAOXTENR;

           WHEN FLDNAM = 'DSWAOXLAND'
             AND C#LCK1 = *OFF;
             EXSR PRWAOXLAND;

           WHEN FLDNAM = 'DSWAOXNTEN';
             EXSR PRWAOXNTEN;

           WHEN FLDNAM = 'DSWAOXNLAN';
             EXSR PRWAOXNLAN;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;
         WHEN PCPGST = '3     ';
           KYWAOXTENR = DSWAOXNTEN;
           KYWAOXLAND = DSWAOXNLAN;
           CHIDS = '01C';
           EXSR CHWAOX;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWAOXNLAN';
             LEAVESR;
           ENDIF;
         WHEN PCPGST = '2     '
           OR PCPGST = *BLANK;
           KYWAOXTENR = DSWAOXTENR;
           KYWAOXLAND = DSWAOXLAND;
           CHIDS = '01C';
           EXSR CHWAOX;

           SELECT;
           WHEN WKFENR = *ZERO
             AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSWAOXLAND';
             LEAVESR;
           WHEN WKFENR <> *ZERO
             AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSWAOXLAND';
             LEAVESR;
           ENDSL;
         ENDSL;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  UPDATE DATEI TRMU                                                 ***
       //*************************************************************************
       BEGSR UTRMU;

         KYTRMUDANA = 'WAOX';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = WAOX;
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
       //**  Kopieren Sätze aus Datei WAOX                                     ***
       //*************************************************************************
       BEGSR KWAOX;

         IF DSWAOXLAND <> *BLANK
           AND DSWAOXTENR = *BLANK;
           EXSR KWAOX02;
         ELSE;
           EXSR KWAOX00;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WAOX pro Ident-Nr                        ***
       //*************************************************************************
       BEGSR KWAOX00;

         KYWAOXTENR = DSWAOXTENR;
         OFWAOXTENR = DSWAOXTENR;
         KYWAOXLAND = DSWAOXLAND;
         OFWAOXLAND = DSWAOXLAND;
         IF DSWAOXLAND = *BLANK;
           OFWAOXLAND = *HIVAL;
         ENDIF;
         CHIDS = '00+';
         EXSR CHWAOX;
         DOW CHI(5) = 'J'
           AND WAOXFIRM = KYWAOXFIRM
           AND WAOXTENR <= OFWAOXTENR
           AND WAOXLAND <= OFWAOXLAND;

           EXSR UWAOX;

           CHIDS = '00R';
           EXSR CHWAOX;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Sätze aus Datei WAOX pro Land                            ***
       //*************************************************************************
       BEGSR KWAOX02;

         KYWAOXLAND = DSWAOXLAND;
         OFWAOXLAND = DSWAOXLAND;
         KYWAOXTENR = DSWAOXTENR;
         OFWAOXTENR = DSWAOXTENR;
         IF DSWAOXTENR = *BLANK;
           OFWAOXTENR = *HIVAL;
         ENDIF;
         CHIDS = '02+';
         EXSR CHWAOX;
         DOW CHI(5) = 'J'
           AND WAOXFIRM = KYWAOXFIRM
           AND WAOXLAND <= OFWAOXLAND
           AND WAOXTENR <= OFWAOXTENR;

           EXSR UWAOX;

           CHIDS = '02R';
           EXSR CHWAOX;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob WAOX-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PWAOX;

         OFWAOXTENR = KYWAOXTENR;
         OFWAOXLAND = KYWAOXLAND;
         OFWAOXLAND = KYWAOXLAND;
         IF KYWAOXLAND = *BLANK;
           OFWAOXLAND = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWAOX;
         WKFENR = *ZERO;

         DOW CHI(5) = 'J'
           AND WAOXFIRM = KYWAOXFIRM
           AND WAOXTENR <= OFWAOXTENR
           AND WAOXLAND <= OFWAOXLAND;

           IF WAOXLOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'WAOXLOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHWAOX;
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
       //**  Löschen Sätze Datei WAOX                                          ***
       //*************************************************************************
       BEGSR LWAOX;

         OFWAOXTENR = KYWAOXTENR;
         OFWAOXLAND = KYWAOXLAND;
         OFWAOXLAND = KYWAOXLAND;
         IF KYWAOXLAND = *BLANK;
           OFWAOXLAND = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHWAOX;
         WKFENR = *ZERO;

         DOW CHI(5) = 'J'
           AND WAOXFIRM = KYWAOXFIRM
           AND WAOXTENR <= OFWAOXTENR
           AND WAOXLAND <= OFWAOXLAND;

           EXSR LPOSI;

           KYWAOXTENR = WAOXTENR;
           KYWAOXLAND = WAOXLAND;
           CHIDS = '01CU';
           EXSR CHWAOX;

           CHIDS = '01D';
           EXSR CHWAOX;

           CHIDS = '01R';
           EXSR CHWAOX;
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
       //**  Update Datei WAOX                                                 ***
       //*************************************************************************
       BEGSR UWAOX;

         KYWAOXTENR = DSWAOXTENR;
         KYWAOXLAND = DSWAOXLAND;

         IF PCPGST = '3     ';
           KYWAOXTENR = DSWAOXNTEN;
           IF DSWAOXNTEN = *BLANK;
             KYWAOXTENR = WAOXTENR;
           ENDIF;
           KYWAOXLAND = DSWAOXNLAN;
           IF DSWAOXNLAN = *BLANK;
             KYWAOXLAND = WAOXLAND;
           ENDIF;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHWAOX;

         WAOXJNAM = DAJNAM;
         WAOXPROG = DAPROG;
         WAOXBIBL = WKCHPL;
         WAOXUSER = DAUSER;
         WAOXJZEI = %DEC(%TIME());
         WAOXJDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHWAOX;
         WHEN CHI(6) = *ON;
           C_EXTSTP(WAOXTSTP);
           WAOXERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHWAOX;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWAOX;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCWAOXTENR;

         C#WNDW = *ON;

         IF DSWAOXTENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWAOXTENR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOXTENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRWAOXTENR;

         EXFLPOFLDN = 'DSWAOXTENR';

         SELECT;
         WHEN WKFLPORECN = 'TRWAOXK1'
           AND DSWAOXTENR = *BLANK
           AND DSWAOXLAND = *BLANK;
           WKFENR = '0031';
           LEAVESR;
         WHEN WKFLPORECN = 'TRWAOXK1'
           AND DSWAOXTENR = *BLANK
           AND DSWAOXNTEN = *BLANK;
           LEAVESR;
         ENDSL;

         KYTENR = DSWAOXTENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWAOXTENR = TETENR;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine LAND                                                   ***
       //*************************************************************************
       BEGSR MCWAOXLAND;

         C#WNDW = *ON;

         IF DSWAOXLAND = *BLANK;
           TXWAOXLAND = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSWAOXLAND;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOXLAND = LNLDNR;
           TXWAOXLAND = LNLBEZ;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine LAND                                                   ***
       //*************************************************************************
       BEGSR PRWAOXLAND;

         EXFLPOFLDN = 'DSWAOXLAND';

         SELECT;
         WHEN WKFLPORECN = 'TRWAOXK1'
           AND DSWAOXLAND = *BLANK
           AND DSWAOXNLAN = *BLANK;
           LEAVESR;
         ENDSL;

         %SUBST(KOMDS:01) = DSWAOXLAND;
         EXSR PRLANDLAND;
         TXWAOXLAND = %SUBST(KOMDS:08);

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR MCWAOXNTEN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWAOXNTEN;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOXNTEN = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR PRWAOXNTEN;

         EXFLPOFLDN = 'DSWAOXNTEN';

         SELECT;
         WHEN WKFLPORECN = 'TRWAOXK1'
           AND DSWAOXTENR = *BLANK
           AND DSWAOXNTEN = *BLANK;
           LEAVESR;
         ENDSL;

         KYTENR = DSWAOXNTEN;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSWAOXNTEN = TETENR;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NLAN                                                   ***
       //*************************************************************************
       BEGSR MCWAOXNLAN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSWAOXNLAN;
         #CPGST = 'LAND01';
         #CUEBE = '0010';
         EXSR MCLAND;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSWAOXNLAN = LNLDNR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine NLAN                                                   ***
       //*************************************************************************
       BEGSR PRWAOXNLAN;

         EXFLPOFLDN = 'DSWAOXNLAN';

         SELECT;
         WHEN WKFLPORECN = 'TRWAOXK1'
           AND DSWAOXLAND = *BLANK
           AND DSWAOXNLAN = *BLANK;
           LEAVESR;
         ENDSL;

         %SUBST(KOMDS:01) = DSWAOXNLAN;
         EXSR PRLANDLAND;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TRTK                                                   ***
       //*************************************************************************
       BEGSR MCAUFRTRTK;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'QQQQ';
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTK;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'WAOX';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = WAOX;

           CLEAR EXDATA;
           EXDATAFILE = 'WAOX';
           EXDATADATA = WAOX;
           C_INZDATASTR(EXDATA: RTDATA);

           WAOX = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EWAOX;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRWAOX';
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

           EXTRDNPGNA = 'TRWAOX';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRWAOXB1'    EXTRDNPGNA
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
           WHEN EXTRDNDANA = 'TRTK';
             EXSR MCAUFRTRTK;
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

         PGMNAM = 'TRWAOX';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOXW2;
         OTHER;
           WRITE CTWAOXW1;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTWAOXW2;
         OTHER;
           WRITE CTWAOXW1;
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
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHWAOX
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCLAND
      /COPY QCPYSRC,MCTEIL
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
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
