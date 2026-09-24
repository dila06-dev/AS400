     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2024')
      //*************************************************************************
      /TITLE Verwalten Datei ZOTE
      //*************************************************************************
      //  Copyright 2026 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: ZG 14.01.2026 Case #05780597
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Dieses Programm verwaltet die Datei ZOTE.
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FTRZOTEFM  CF   E             WORKSTN USROPN
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

     D ZOTE          E DS                  INZ
     D KYZOTE        E DS                  INZ

     D ZOTN          E DS                  INZ
     D KYZOTN        E DS                  INZ

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

     D EXZOTE          DS                  INZ
     D  EXZOTEPRKZ                  256
     D   EXZOTEIFKZ                   1    OVERLAY(EXZOTEPRKZ:*NEXT)
     D   EXZOTEPRRT                   1    OVERLAY(EXZOTEPRKZ:*NEXT)

     D  EXZOTEKEYB                  256
     D   EXZOTETENR                        OVERLAY(EXZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTETENR)
     D   EXZOTEIMEX                        OVERLAY(EXZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTEIMEX)
     D   EXZOTEGADA                        OVERLAY(EXZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTEGADA)

     D  EXZOTENKEY                  256
     D   EXZOTENTEN                        OVERLAY(EXZOTENKEY:*NEXT)
     D                                     LIKE(ZOTETENR)
     D   EXZOTENIME                        OVERLAY(EXZOTENKEY:*NEXT)
     D                                     LIKE(ZOTEIMEX)
     D   EXZOTENGAD                        OVERLAY(EXZOTENKEY:*NEXT)
     D                                     LIKE(ZOTEGADA)

     D  EXZOTEDATE                 1024
     D   EXZOTEZOTN                        OVERLAY(EXZOTEDATE:*NEXT)
     D                                     LIKE(ZOTETENR)
     D   EXZOTECODE                        OVERLAY(EXZOTEDATE:*NEXT)
     D                                     LIKE(ZOTECODE)
     D   EXZOTECBZ1                        OVERLAY(EXZOTEDATE:*NEXT)
     D                                     LIKE(ZOTECBZ1)
     D   EXZOTEGBDA                        OVERLAY(EXZOTEDATE:*NEXT)
     D                                     LIKE(ZOTEGBDA)


     D RTZOTE          DS                  INZ
     D  RTZOTEKEYB                  256
     D   RTZOTETENR                        OVERLAY(RTZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTETENR)
     D   RTZOTEIMEX                        OVERLAY(RTZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTEIMEX)
     D   RTZOTEGADA                        OVERLAY(RTZOTEKEYB:*NEXT)
     D                                     LIKE(ZOTEGADA)

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
     D WKTRPAZOTN      S              1
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
     D OFZOTETENR      S                   LIKE(KYZOTETENR)
     D OFZOTEIMEX      S                   LIKE(KYZOTEIMEX)
     D OFZOTEGADA      S                   LIKE(KYZOTEGADA)
     D WKZOTEGBDA      S                   LIKE(KYZOTEGADA)
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
      // Parameter:      #ZOTETSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #ZOTETSTP                          LIKE(ZOTETSTP)

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

      //--------------------------------------------------
      // Program name: C_TRZOTN
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRZOTN...
     D                 PR                  EXTPGM('TRZOTN')
     D  #EXTR02                            LIKEDS(EXTR02)

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
           CLOSE TRZOTEFM;
           WKIOKZ = *OFF;
         ENDIF;

         WKIFMT = '00';

       WHEN PCPGST = '3     ';
         WKFLPORECN = 'TRZOTEK1';
         EXSR EFLPO;
         EXSR BILDPR;

         IF WKFENR = *ZERO;
           EXSR KZOTE;
           EXSR UZOTE;
           WKIFMT = '00';
         ELSE;
           WKIFMT = 'K1';
         ENDIF;
       WHEN PCPGST = 'PZOTE ';
         EXSR PZOTE;
         WKIFMT = '00';
       WHEN PCPGST = '4     ';
         EXSR PZOTE;

         IF WKFENR = *ZERO;
           EXSR LZOTE;
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
           OPEN(E) TRZOTEFM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'TRZOTE';
             EXTRDZAUSW = 'TRZOTE';
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
         CLOSE(E) TRZOTEFM;
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
         KYZOTEFIRM = DAFIRM;  // ZOTE

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'TRZOTEFM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'TRZOTEFM';

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
         EXZOTEPRKZ = EXTRNDPRKZ;

         EXZOTEKEYB = EXTRNDKEYB;
         KYZOTETENR = EXZOTETENR;
         KYZOTEIMEX = EXZOTEIMEX;
         KYZOTEGADA = EXZOTEGADA;

         DSZOTETENR = EXZOTETENR;
         DSZOTEIMEX = EXZOTEIMEX;
         DSZOTEGADA = EXZOTEGADA;

         if EXTRNDNKEY = *BLANK;
           DSZOTENTEN = *BLANK;
           DSZOTENIME = *BLANK;
           DSZOTENGAD = *ZERO;
         else;
           EXZOTENKEY = EXTRNDNKEY;
           DSZOTENTEN = EXZOTENTEN;
           DSZOTENIME = EXZOTENIME;
           DSZOTENGAD = EXZOTENGAD;
         endif;

         EXZOTEDATE = EXTRNDDATE;

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

         EXTRDNDANA = 'TRZOTE';
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
           WKFLPORECN = 'TRZOTE01';
           //WRITE TRZOTECL;
           EXSR EFLPO;

           //IF RCDNRTRDZB > *ZERO;
             //WRITE SFTRDZBK1;
           //ENDIF;

           WRITE TRZOTE01;
           WRITE TRZOTEB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT10 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) TRZOTE01;
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

             EXSR UZOTE;

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
             IF EXZOTETENR = *BLANK;
               KYZOTETENR = *BLANK;
             ELSE;
               KYZOTETENR = EXZOTETENR;
             ENDIF;
             KYZOTEIMEX = EXZOTEIMEX;
             KYZOTEGADA = *ZERO;
             EXSR B01DS;
           ENDIF;
         ENDDO;

         SELECT;
         WHEN PCPGST = 'F     ';
           CHIDS = '01F';
           EXSR CHZOTE;
         WHEN #CRTCD = 'N';
           CHIDS = '01CF';
           EXSR CHZOTE;
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
           CLEAR ZOTE;
           EXSR ETRMU;
           EXSR EZOTE;
           ZOTETENR = KYZOTETENR;
           ZOTEIMEX = KYZOTEIMEX;
           ZOTEGADA = KYZOTEGADA;
         OTHER;
           CHIDS = '01C';
           EXSR CHZOTE;

           EXINFOFILE = 'ZOTE';
           EXINFODATA = %ADDR(ZOTE);
           C_TRINFO(EXINFO:DSINFO);

           WKUSER = ZOTEUSER;
           WKJDAT = ZOTEJDAT;
           WKJZEI = ZOTEJZEI;

           IF PCPGST = '2     ';
             CHIDS = '01CL';
             EXSR CHZOTE;
             EXSR EZOTE;
           ENDIF;
         ENDSL;

         IF CHI(5) = 'L';
           PCPGST = 'F     ';
         ENDIF;

         DSZOTETENR = ZOTETENR;
         DSZOTEIMEX = ZOTEIMEX;
         DSZOTEZOTN = ZOTEZOTN;
         DSZOTECODE = ZOTECODE;
         DSZOTECBZ1 = %SUBST(ZOTECBZ1:1: %LEN(DSZOTECBZ1));
         DSZOTECBZ2 = %SUBST(ZOTECBZ1:(1+%LEN(DSZOTECBZ1)):%LEN(DSZOTECBZ2));
         DSZOTECBZ3 = %SUBST(ZOTECBZ1:(1+%LEN(DSZOTECBZ1)+%LEN(DSZOTECBZ2)):
           %LEN(DSZOTECBZ3));
         DSZOTECBZ4 = %SUBST(ZOTECBZ1:(1+%LEN(DSZOTECBZ1)+%LEN(DSZOTECBZ2)+
           %LEN(DSZOTECBZ3)):
           %LEN(DSZOTECBZ4));

         CLEAR EXDATE;
         EXDATEDATV = ZOTEGADA;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSZOTEGADA = RTDATEDATE;

         CLEAR EXDATE;
         EXDATEDATV = ZOTEGBDA;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSZOTEGBDA = RTDATEDATE;

         // Routine verlassen wenn diese über den externen Update aufgerufen wird.
         IF EXZOTEIFKZ <> *BLANK;
           LEAVESR;
         ENDIF;

         // Initialisieren der Textfelder
         DSTEILTBZ1 = *BLANK;
         DSTEILTBZ2 = *BLANK;
         TXZOTEIMEX = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSZOTETENR <> *BLANK;
           EXSR PRZOTETENR;
         ENDIF;

         IF DSZOTEIMEX <> *BLANK;
           EXSR PRZOTEIMEX;
         ENDIF;

         EXTRPBBFMT = 'TRZOTE01';
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
           EXFLPOFLDN = 'DSZOTEZOTN';

           IF RTTRPBCUSR <> *BLANK;
             EXFLPOFLDN = RTTRPBCUSR;
           ENDIF;

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSZOTEIMEX';

         WHEN PCPGST = 'F     ';
           WKFENR = '0001';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           IF DSZOTETENR <> *BLANK;
             EXFLPOFLDN = 'DSZOTEIMEX';
           ELSE;
             EXFLPOFLDN = 'DSZOTETENR';
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
           WKFLPORECN = 'TRZOTEK1';
           EXSR EFLPO;
           WRITE TRZOTEW2;
           WRITE TRZOTEK1;
           WRITE W2ZOTEB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRZOTEK1;

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

           EXSR KZOTE;
           EXSR UZOTE;

           WKIFMT = '00';
           //IF DSZOTENIME <> *BLANK;
           //  %SUBST(RTTRNDKEYB:01:04) = KYZOTETENR;
           //  %SUBST(RTTRNDKEYB:05:04) = KYZOTEIMEX;
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

         DSZOTETENR = KYZOTETENR;
         DSZOTEIMEX = KYZOTEIMEX;
         DSZOTEGADA = KYZOTEGADA;

         DSZOTENTEN = KYZOTETENR;
         DSZOTENIME = *BLANK;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = 'DSZOTENIME';

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

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSZOTETENR';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSZOTEIMEX';
           WKFENR = '0052';

         WHEN C#LCK1 = *ON AND FLDNAM = 'DSZOTEGADA';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSZOTEGBDA';
           WKFENR = '0052';

         WHEN C#LCK0 = *ON AND FLDNAM = 'DSZOTEZOTN';
           WKFENR = '0052';

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSZOTETENR';

         WHEN FLDNAM = 'DSZOTETENR';
           EXSR MCZOTETENR;

         WHEN FLDNAM = 'DSZOTEIMEX';
           EXSR MCZOTEIMEX;

         WHEN FLDNAM = 'DSZOTEGADA';
           EXSR MCZOTEGADA;

         WHEN FLDNAM = 'DSZOTEGBDA';
           EXSR MCZOTEGBDA;

         WHEN FLDNAM = 'DSZOTEZOTN' and WKTRPAZOTN = *ON;
           EXSR MCZOTEZOTN;

         WHEN FLDNAM = 'DSZOTENTEN';
           EXSR MCZOTENTEN;

         WHEN FLDNAM = 'DSZOTENIME';
           EXSR MCZOTENIME;

         WHEN FLDNAM = 'DSZOTENGAD';
           EXSR MCZOTENGAD;

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

           WHEN FLDNAM = 'DSZOTETENR' AND C#LCK1 = *OFF;
             EXSR PRZOTETENR;

           WHEN FLDNAM = 'DSZOTEIMEX' AND C#LCK1 = *OFF;
             EXSR PRZOTEIMEX;

           WHEN FLDNAM = 'DSZOTEGADA' AND C#LCK1 = *OFF;
             EXSR PRZOTEGADA;

           WHEN FLDNAM = 'DSZOTEGBDA' AND C#LCK0 = *OFF;
             EXSR PRZOTEGBDA;

           WHEN FLDNAM = 'DSZOTEZOTN' AND C#LCK0 = *OFF;
             EXSR PRZOTEZOTN;

           WHEN FLDNAM = 'DSZOTECODE' AND C#LCK0 = *OFF;
             EXSR PRZOTECODE;

           WHEN FLDNAM = 'DSZOTENTEN';
             EXSR PRZOTENTEN;

           WHEN FLDNAM = 'DSZOTENIME';
             EXSR PRZOTENIME;

           WHEN FLDNAM = 'DSZOTENGAD';
             EXSR PRZOTENGAD;

           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         SELECT;

         WHEN PCPGST = '3     ';
           KYZOTETENR = DSZOTENTEN;
           KYZOTEIMEX = DSZOTENIME;
           CLEAR EXDATE;
           EXDATEDATV = DSZOTENGAD;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           KYZOTEGADA = RTDATEDATE;
           CHIDS = '01C';
           EXSR CHZOTE;

           IF WKFENR = *ZERO;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSZOTENGAD';
             LEAVESR;
           ENDIF;

         WHEN PCPGST = '2     ' OR PCPGST = *BLANK;
           KYZOTETENR = DSZOTETENR;
           KYZOTEIMEX = DSZOTEIMEX;
           CLEAR EXDATE;
           EXDATEDATV = DSZOTEGADA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           KYZOTEGADA = RTDATEDATE;
           CHIDS = '01C';
           EXSR CHZOTE;

           SELECT;
           WHEN WKFENR = *ZERO AND PCPGST = *BLANK;
             WKFENR = '0092';
             EXFLPOFLDN = 'DSZOTEGADA';
             LEAVESR;
           WHEN WKFENR <> *ZERO AND PCPGST = '2     ';
             WKFENR = '0901';
             EXFLPOFLDN = 'DSZOTEGADA';
             LEAVESR;
           ENDSL;

           KYZOTEIMEX = DSZOTEIMEX;
           CLEAR KYZOTETENR;
           CHIDS = '02+';
           EXSR CHZOTE;
           WKFENR = *ZERO;
           W$MSGA = *BLANK;
           IF CHI(5) = 'J'
             AND ZOTEFIRM = KYZOTEFIRM
             AND ZOTEIMEX = KYZOTEIMEX;

             IF ZOTETENR <> DSZOTETENR;
               // Die Prod-Gruppe ist bereits der KD-Gruppe &3 zugeprdnet.
               //W$PA03 = ZOTETENR;
               //WKFENR = '0036';
               //W$MSGA = '#MO';
               //EXFLPOFLDN = 'DSZOTETENR';
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

         KYTRMUDANA = 'ZOTE';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01CU';
         EXSR CHTRMU;

         TRMUDATA = ZOTE;
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
       //**  Kopieren Sätze aus Datei ZOTE                                     ***
       //*************************************************************************
       BEGSR KZOTE;

         KYZOTETENR = DSZOTETENR;
         KYZOTEIMEX = DSZOTEIMEX;
         CHIDS = '01C';
         EXSR CHZOTE;

       ENDSR;

       //*************************************************************************
       //**  Prüfen, ob ZOTE-Satz gelöscht werden darf                         ***
       //*************************************************************************
       BEGSR PZOTE;

         OFZOTETENR = KYZOTETENR;
         OFZOTEIMEX = KYZOTEIMEX;
         IF KYZOTEIMEX = *BLANK;
           OFZOTEIMEX = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHZOTE;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND ZOTEFIRM = KYZOTEFIRM
           AND ZOTETENR <= OFZOTETENR
           AND ZOTEIMEX <= OFZOTEIMEX;

           IF ZOTELOCK = 'L';
             WKFENR = '0004';
             WKFFLD = 'ZOTELOCK';
             LEAVE;
           ENDIF;

           CHIDS = '01R';
           EXSR CHZOTE;
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
       //**  Löschen Sätze Datei ZOTE                                          ***
       //*************************************************************************
       BEGSR LZOTE;

         OFZOTETENR = KYZOTETENR;
         OFZOTEIMEX = KYZOTEIMEX;
         IF KYZOTEIMEX = *BLANK;
           OFZOTEIMEX = *HIVAL;
         ENDIF;
         OFZOTEGADA = KYZOTEGADA;
         IF KYZOTEGADA = *ZERO;
           OFZOTEGADA = *HIVAL;
         ENDIF;
         CHIDS = '01+';
         EXSR CHZOTE;
         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         DOW CHI(5) = 'J'
           AND ZOTEFIRM = KYZOTEFIRM
           AND ZOTETENR <= OFZOTETENR
           AND ZOTEIMEX <= OFZOTEIMEX
           AND ZOTEGADA <= OFZOTEGADA;

           EXSR LPOSI;

           KYZOTETENR = ZOTETENR;
           KYZOTEIMEX = ZOTEIMEX;
           KYZOTEGADA = ZOTEGADA;
           CHIDS = '01CU';
           EXSR CHZOTE;

           CHIDS = '01D';
           EXSR CHZOTE;

           CHIDS = '01R';
           EXSR CHZOTE;
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
       //**  Update Datei ZOTE                                                 ***
       //*************************************************************************
       BEGSR UZOTE;

         KYZOTETENR = DSZOTETENR;
         KYZOTEIMEX = DSZOTEIMEX;
         CLEAR EXDATE;
         EXDATEDATV = DSZOTEGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         KYZOTEGADA = RTDATEDATE;

         IF PCPGST = '3     ';
           KYZOTETENR = DSZOTENTEN;
           KYZOTEIMEX = DSZOTENIME;
           CLEAR EXDATE;
           EXDATEDATV = DSZOTENGAD;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           KYZOTEGADA = RTDATEDATE;
         ENDIF;

         CHIDS = '01CU';
         EXSR CHZOTE;

         ZOTEZOTN = DSZOTEZOTN;
         ZOTECODE = DSZOTECODE;
         ZOTECBZ1 = DSZOTECBZ1 + DSZOTECBZ2 + DSZOTECBZ3 + DSZOTECBZ4;

         CLEAR EXDATE;
         EXDATEDATV = DSZOTEGBDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         ZOTEGBDA = RTDATEDATE;

         ZOTEJNAM = DAJNAM;
         ZOTEPROG = DAPROG;
         ZOTEBIBL = WKCHPL;
         ZOTEUSER = DAUSER;
         ZOTEJZEI = %DEC(%TIME());
         ZOTEJDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN PCPGST = 'MUSTER';
           CHIDS = '01F';
           EXSR CHZOTE;
         WHEN CHI(6) = *ON;
           C_EXTSTP(ZOTETSTP);
           ZOTEERUS = DAUSER;

           CHIDS = '01W';
           EXSR CHZOTE;
           #CRTCD = 'W';
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHZOTE;
           #CRTCD = 'U';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR MCZOTETENR;

         C#WNDW = *ON;

         IF DSZOTETENR = *BLANK;
           DSTEILTBZ1 = *BLANK;
           DSTEILTBZ2 = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DSZOTETENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTETENR = TETENR;
           DSTEILTBZ1 = TETBZ1;
           DSTEILTBZ2 = TETBZ2;
         ENDIF;


       ENDSR;

       //*************************************************************************
       //**  PR-Routune TENR                                                   ***
       //*************************************************************************
       BEGSR PRZOTETENR;

         EXFLPOFLDN = 'DSZOTETENR';

         KYTENR = DSZOTETENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine IMEX                                                   ***
       //*************************************************************************
       BEGSR MCZOTEIMEX;

         C#WNDW = *ON;

         IF DSZOTEIMEX = *BLANK;
           TXZOTEIMEX = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$ZOTEIMEX';
         %SUBST(KOMDS:12) = DSZOTEIMEX;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTEIMEX = TPTCDE;
           TXZOTEIMEX = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune IMEX                                                   ***
       //*************************************************************************
       BEGSR PRZOTEIMEX;

         EXFLPOFLDN = 'DSZOTEIMEX';

         KYTPTA = '$$ZOTEIMEX';
         KYTPTC = DSZOTEIMEX;
         CHIDS  = '01C';
         EXSR CHTRTP;
         TXZOTEIMEX = TPTTXT;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine GADA                                                   ***
       //*************************************************************************
       BEGSR MCZOTEGADA;

         C#WNDW = *ON;

         CLEAR EXDATE;
         EXDATEDATV = DSZOTEGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         IF DSZOTEGADA = *ZERO;
          EXDATEPGCD = 'POSAKT';
         ENDIF;
         EXSR TRDATE;
         IF WKFENR = *ZERO
           AND RTDATEDATE <> *ZERO;
           DSZOTEGADA = RTDATEDATE;
           WKTRTP = *ON;
        ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune GADA                                                   ***
       //*************************************************************************
       BEGSR PRZOTEGADA;

         EXFLPOFLDN = 'DSZOTEGADA';

         CLEAR EXDATE;
         EXDATEDATV = DSZOTEGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAPR';
         EXSR TRDATE;

         IF WKFENR <> *ZERO;
          LEAVESR;
         ENDIF;

         DSZOTEGADA = RTDATEDATE;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine GBDA                                                   ***
       //*************************************************************************
       BEGSR MCZOTEGBDA;

         C#WNDW = *ON;

         CLEAR EXDATE;
         EXDATEDATV = DSZOTEGBDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         IF DSZOTEGADA = *ZERO;
          EXDATEPGCD = 'POSAKT';
         ENDIF;
         EXSR TRDATE;
         IF WKFENR = *ZERO
           AND RTDATEDATE <> *ZERO;
           DSZOTEGBDA = RTDATEDATE;
           WKTRTP = *ON;
        ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune GBDA                                                   ***
       //*************************************************************************
       BEGSR PRZOTEGBDA;

         EXFLPOFLDN = 'DSZOTEGBDA';

         IF DSZOTEGBDA <> *ZERO;
           CLEAR EXDATE;
           EXDATEDATV = DSZOTEGBDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*EUR';
           EXDATEPGST = 'TRDAPR';
           EXSR TRDATE;
           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;

           DSZOTEGBDA = RTDATEDATE;

           CLEAR EXDATE;
           EXDATEDATV = DSZOTEGBDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           WKZOTEGBDA = RTDATEDATE;

           IF DSZOTEGADA <> *ZERO;
             CLEAR EXDATE;
             EXDATEDATV = DSZOTEGADA;
             EXDATEFMTV = '*EUR';
             EXDATEFMTN = '*ISO';
             EXDATEPGST = 'TRDAUM';
             EXSR TRDATE;

             if  WKZOTEGBDA < RTDATEDATE;
               // Gültig bis Datum ist kleiner Gültig ab Datum
               WKFENR = '2073';
              LEAVESR;
             endif;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine ZOTE                                                   ***
       //*************************************************************************
       BEGSR MCZOTEZOTN;

         C#WNDW = *ON;
         EXFLPOFLDN = 'SFAUSW';

         %SUBST(KOMDS:01) = DSZOTEZOTN;
         #CPGST = 'ZOTN01';
         #CUEBE = '0010';
         EXSR MCZOTN;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTEZOTN = ZOTNZOTN;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune ZOTN                                                   ***
       //*************************************************************************
       BEGSR PRZOTEZOTN;

         EXFLPOFLDN = 'DSZOTEZOTN';

         IF DSZOTEZOTN = *BLANK;
             WKFENR = '0031';
             LEAVESR;
         ENDIF;

         IF WKTRPAZOTN = *ON;
           %SUBST(KOMDS:01) = DSZOTEZOTN;
           #CKOMM = KOMDS;
           #CPGST = 'ERMFLD';
           C_TRZOTN(EXTR02);
           KOMDS = #CKOMM;
           IF DSZOTEZOTN <> %SUBST(KOMDS:01:15);
             WKFENR = '0031';
             LEAVESR;
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune CODE                                                   ***
       //*************************************************************************
       BEGSR PRZOTECODE;

         EXFLPOFLDN = 'DSZOTECODE';

       ENDSR;

       //*************************************************************************
       //**  PR-Routune CBZ1                                                   ***
       //*************************************************************************
       BEGSR PRZOTECBZ1;

         EXFLPOFLDN = 'DSZOTECBZ1';

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NTEN                                                   ***
       //*************************************************************************
       BEGSR MCZOTENTEN;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSZOTETENR;
         #CPGST = '5     ';
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTENTEN = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NTEN                                                   ***
       //*************************************************************************
       BEGSR PRZOTENTEN;

         EXFLPOFLDN = 'DSZOTENTEN';

         KYTENR = DSZOTENTEN;
         CHIDS = '01C';
         EXSR CHTEIL;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NIME                                                   ***
       //*************************************************************************
       BEGSR MCZOTENIME;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = '$$ZOTEIMEX';
         %SUBST(KOMDS:12) = DSZOTENIME;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSZOTENIME = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NIME                                                   ***
       //*************************************************************************
       BEGSR PRZOTENIME;

         EXFLPOFLDN = 'DSZOTENIME';

         KYTPTA = '$$ZOTEIMEX';
         KYTPTC = DSZOTENIME;
         CHIDS  = '01C';
         EXSR CHTRTP;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine NGAD                                                   ***
       //*************************************************************************
       BEGSR MCZOTENGAD;

         C#WNDW = *ON;

         CLEAR EXDATE;
         EXDATEDATV = DSZOTENGAD;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         IF DSZOTEGADA = *ZERO;
          EXDATEPGCD = 'POSAKT';
         ENDIF;
         EXSR TRDATE;
         IF WKFENR = *ZERO
           AND RTDATEDATE <> *ZERO;
           DSZOTENGAD = RTDATEDATE;
           WKTRTP = *ON;
        ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routune NGAD                                                   ***
       //*************************************************************************
       BEGSR PRZOTENGAD;

         EXFLPOFLDN = 'DSZOTENGAD';

         CLEAR EXDATE;
         EXDATEDATV = DSZOTENGAD;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAPR';
         EXSR TRDATE;

         IF WKFENR <> *ZERO;
          LEAVESR;
         ENDIF;

         DSZOTENGAD = RTDATEDATE;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
       //*************************************************************************
       BEGSR ETRMU;

         KYTRMUDANA = 'ZOTE';
         KYTRMUKEY1 = *BLANK;
         KYTRMUKEY2 = *BLANK;
         KYTRMUKEY3 = *BLANK;
         CHIDS = '01C';
         EXSR CHTRMU;

         IF WKFENR = *ZERO;

           TRMUDATA = ZOTE;

           CLEAR EXDATA;
           EXDATAFILE = 'ZOTE';
           EXDATADATA = ZOTE;
           C_INZDATASTR(EXDATA: RTDATA);

           ZOTE = RTDATADATA;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Vorbelegung bei Änderung für neue Felder                ***
       //*************************************************************************
       BEGSR EZOTE;

       ENDSR;
       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'NEUANLAGE';
         KYTATC = 'AKTUALISIE';
         KYTAPA = 'TRZOTE';
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

         KYTATA = 'TRTEIL';
         KYTATC = 'ZOTN';
         KYTAPA = 'ZOTN';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAZOTN = TAPCDE;
         IF WKTRPAZOTN <> *ON;
           WKTRPAZOTN = *OFF;
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

           EXTRDNPGNA = 'TRZOTE';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'TRZOTEB1'    EXTRDNPGNA
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
           WHEN EXTRDNDANA = 'xxxx';
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

         PGMNAM = 'TRZOTE';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTZOTEW2;
         OTHER;
           WRITE TRZOTECT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = 'K1';
           WRITE CTZOTEW2;
         OTHER;
           WRITE TRZOTECT;
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
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRMU
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHZOTE
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,MCTRPC
      /COPY QCPYSRC,MCTRTK
      /COPY QCPYSRC,MCTRTP
      /COPY QCPYSRC,MCZOTN
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
