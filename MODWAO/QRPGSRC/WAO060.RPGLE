     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2016')
      //*************************************************************************
      /TITLE  Aufruf Excel-Ausgabe von Verkaufspreislisten
      //*************************************************************************
      //  Copyright 2016 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Ziegelhofstraße 210a
      //                       DE 79110 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 14.01.2016 Projekt 11864
      //  -----------------------------------------------------------------------
      //
      //*************************************************************************
      //
      //  Über dieses Programm wird die Ausgabe der Preislisten per EXCEL
      //  gestartet
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FWAO060FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR
      //
      //*************************************************************************
      //**  INDICATORS                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
      //
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKIFMT          S              2
     D PCPGST          S              6
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKIOKZ          S              1
     D WKI000          S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D I1              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPROG          S                   LIKE(DAPROG)
     D WKBIBL          S                   LIKE(DABIBL)
     D WKFEAT          S              1
     D WKFENR          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10

      //--------------------------------------------------
      // Program name: C_WAO060SB
      // Purpose:
      // Returns:
      // Parameter:      #PREIGADA
      // Parameter:      #KUNDKDNR
      // Parameter:      #KUNDKDGR
      // Parameter:      #TEILPRGR
      // Parameter:      #TEILTESV
      // Parameter:      #TEILTESB
      //--------------------------------------------------
     D C_WAO060SB...
     D                 PR                  EXTPGM('WAO060SB')
     D  #PREIGADA                     8S 0
     D  #KUNDKDNR                          LIKE(DSKUNDKDNR)
     D  #KUNDKDGR                          LIKE(DSKUNDKDGR)
     D  #TEILPRGR                          LIKE(DSTEILPRGR)
     D  #TEILTESV                          LIKE(DSTEILTESV)
     D  #TEILTESB                          LIKE(DSTEILTESB)

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
     C*    *ENTRY        PLIST
     C*                  PARM                    EXWAOE00

      /FREE
       EXSR UEBWAOE;

       //
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       SELECT;
       WHEN WKTRPA <> *ON;
         EXSR ETRPA;
       ENDSL;

       EXSR VORLAUF;

       *IN = *OFF;
       *IN28 = C#IN28;

       IF WKIOKZ = *ON;
         C#WNDW = *ON;
       ENDIF;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           OPEN(E) WAO060FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) WAO060FM;
         *IN98 = %ERROR;
         WKIOKZ = *OFF;
       ENDIF;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       WKC001 = *BLANK;
       WKN010 = *ZERO;

       WKFIRM = DAFIRM;
       WKPROG = EXPSDSPROC;
       WKBIBL = EXPSDSBIBL;
       WKUSER = EXPSDSUSER;

       KYTAFI = DAFIRM;                                                         // TRPA
       KYTPFI = DAFIRM;                                                         // TRTP
       KYKDFI = DAFIRM;                                                         // KUND

       KYTPSP = DASPCD;

       EXFIRMFIRM = DAFIRM;
       EXSR PRFIRMFIRM;
       %SUBST(W99DS:01) = EXFIRMKNAM;
       %SUBST(W99DS:31) = *BLANK;

       EXTRDNDANA = 'WAO060';
       EXSR RDTRDNTRDN;
       %SUBST(W99DS:32) = EXTRDNTEXT;

       WNKOPF = EXTRDNTEXT;

       EXFLPOFMTN = 'WAO060FM';


       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME EXWAOE                                                 ***
       //*************************************************************************
       BEGSR UEBWAOE;



       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
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
       //**  STEUERROUTINE BILD01                                              ***
       //*************************************************************************
       BEGSR BILD01;


       IF WKIFMT <> FMT(FM);
         EXSR IFMTS;
       ENDIF;

       EXSR B01DS;

       DOW WKIFMT = '01';
         EXSR EFLPO;
         WRITE WAO060W2;
         WRITE WAO06001;
         WRITE W2WAOEB1;

         SELECT;
         WHEN WKFENR <> *ZERO;
           EXSR AUMSG;
         ENDSL;

         C#WNDW = *OFF;

         READ(E) WAO06001;
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

         WHEN C#EXIT = *ON;
           MCF = *BLANK;
           #CPGST = *BLANK;
           DAFEHL = *ON;
           #CRTCD = 'N';
           WKIFMT = '00';

         WHEN C#SELC = *ON;
           EXSR MCAUFR;

           IF WKTRTP = *ON
             OR WKFENR <> *ZERO;
             ITER;
           ENDIF;

         WHEN C#CANC = *ON;
           #CPGST = *BLANK;
           DAFEHL = *ON;
           #CRTCD = 'N';
           EXSR RFMTS;

         WHEN C#INFO = *ON;
           EXSR VINFO;
           C#WNDW = *ON;
           ITER;

         WHEN C#FUKT <> *ZERO;
           WKFENR = '0075';
           ITER;

         OTHER;

           EXSR B01PR;

           IF WKFENR <> *ZERO;
             ITER;
           ENDIF;

           EXSR SJWAO060;

           EXSR RFMTS;

         ENDSL;

       ENDDO;


       ENDSR;
       //*************************************************************************
       //**  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
       //*************************************************************************
       BEGSR B01DS;


       C#LCK0 = WKIN30;
       C#LCK1 = WKIN31;

       #CRTCD = *BLANK;

       DSPREIGADA = %DEC(%DATE:*EUR);

       DSTEILTESV = '01';
       DSTEILTESB = '01';

       WKFENR = '0000';
       EXFLPOFLDN = 'DSKUNDKDNR';


       ENDSR;
       //*************************************************************************
       //**  PLAUSIPRÜFUNG FÜR BILD01                                          ***
       //*************************************************************************
       BEGSR B01PR;


       WKFENR = '0000';

       EXSR PRPREIGADA;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRKUNDKDNR;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRKUNDKDGR;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRTEILPRGR;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRTEILTESV;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRTEILTESB;
       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       IF DSTEILPRGR = *BLANKS AND
          DSKUNDKDNR = *BLANKS AND
          DSKUNDKDGR = *BLANKS AND
          DSTEILTESV = *BLANKS AND
          DSTEILTESB = *BLANKS;
         WKFENR = '0031';
         EXFLPOFLDN = 'DSTEILPRGR';
         LEAVESR;
       ENDIF;

       WKFENR = '0000';


       ENDSR;
       //*************************************************************************
       //**  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
       //*************************************************************************
       BEGSR MCAUFR;


       WKTRTP = *OFF;
       WKFENR = '0000';

       EXFLPOFLDN = FLDNAM;

       SELECT;

       WHEN FLDNAM = *BLANK;
         WKFENR = '0050';
         EXFLPOFLDN = 'DSKUNDKDNR';

       WHEN FLDNAM = 'DSPREIGADA';
         EXSR MCPREIGADA;

       WHEN FLDNAM = 'DSTEILPRGR';
         EXSR MCTEILPRGR;

       WHEN FLDNAM = 'DSKUNDKDNR';
         EXSR MCKUNDKDNR;

       WHEN FLDNAM = 'DSKUNDKDGR';
         EXSR MCKUNDKDGR;

       WHEN FLDNAM = 'DSTEILTESV';
         EXSR MCTEILTESV;

       WHEN FLDNAM = 'DSTEILTESB';
         EXSR MCTEILTESB;

       OTHER;
         WKFENR = '0050';
       ENDSL;


       ENDSR;
       //*************************************************************************
       //**  MC-Routine DATE                                                   ***
       //*************************************************************************
       BEGSR MCPREIGADA;

         C#WNDW = *ON;

         CLEAR EXDATE;
         EXDATEDATV = DSPREIGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';

         IF DSPREIGADA = *ZERO;
           EXDATEPGCD = 'POSAKT';
         ENDIF;

         EXSR TRDATE;

         IF WKFENR = *ZERO
           AND WKTRTP = *OFF;
           DSPREIGADA = RTDATEDATE;
           WKTRTP = *ON;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine DATE                                                   ***
       //*************************************************************************
       BEGSR PRPREIGADA;

         EXFLPOFLDN = 'DSPREIGADA';

         CLEAR EXDATE;
         EXDATEDATV = DSPREIGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAPR';
         EXSR TRDATE;
         IF WKFENR = *ZERO;
           DSPREIGADA = RTDATEDATE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR MCTEILPRGR;

         C#WNDW = *ON;

         IF DSTEILPRGR = *BLANK;
           TXTEILPRGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'PRGR';
         %SUBST(KOMDS:12) = DSTEILPRGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSTEILPRGR = TPTCDE;
           TXTEILPRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine PRGR                                                   ***
       //*************************************************************************
       BEGSR PRTEILPRGR;

         EXFLPOFLDN = 'DSTEILPRGR';

         IF DSTEILPRGR <> *BLANKS;
           KYTPTA = 'PRGR';
           KYTPTC = DSTEILPRGR;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXTEILPRGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-ROUTINE KDNR                                                   ***
       //*************************************************************************
       BEGSR MCKUNDKDNR;

       C#WNDW = *ON;
       EXFLPOFLDN = 'DSKUNDKDNR';

       %SUBST(KOMDS:01) = DSKUNDKDNR;
       #CUEBE = '0526';
       #CPGST = *BLANK;
       EXSR MCKUND;

       IF WKTRTP = *OFF
         AND WKFENR = *ZERO;
         WKTRTP = *ON;
         DSKUNDKDNR = KDKDNR;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE KDNR                                                   ***
       //*************************************************************************
       BEGSR PRKUNDKDNR;

       EXFLPOFLDN = 'DSKUNDKDNR';

       IF DSKUNDKDNR = *BLANK AND
          DSKUNDKDGR = *BLANK;
         WKFENR = '0040';
         LEAVESR;
       ENDIF;

       IF DSKUNDKDNR <> *BLANK AND
          DSKUNDKDGR <> *BLANK;
         WKFENR = '0537';
         LEAVESR;
       ENDIF;

       IF DSKUNDKDNR <> *BLANK;
         KYKDNR = DSKUNDKDNR;
         CHIDS = '01C';
         EXSR CHKUND;
         DSKUNDKDNR = KDKDNR;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine KDGR                                                   ***
       //*************************************************************************
       BEGSR MCKUNDKDGR;

         C#WNDW = *ON;

         IF DSKUNDKDGR = *BLANK;
           TXKUNDKDGR = *BLANK;
         ENDIF;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'KDGR';
         %SUBST(KOMDS:12) = DSKUNDKDGR;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSKUNDKDGR = TPTCDE;
           TXKUNDKDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine KDGR                                                   ***
       //*************************************************************************
       BEGSR PRKUNDKDGR;

         EXFLPOFLDN = 'DSKUNDKDGR';

         IF DSKUNDKDGR <> *BLANKS;
           KYTPTA = 'KDGR';
           KYTPTC = DSKUNDKDGR;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXKUNDKDGR = TPTTXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TESV                                                   ***
       //*************************************************************************
       BEGSR MCTEILTESV;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'TEST';
         %SUBST(KOMDS:12) = DSTEILTESV;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSTEILTESV = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TESV                                                   ***
       //*************************************************************************
       BEGSR PRTEILTESV;

         EXFLPOFLDN = 'DSTEILTESV';

         IF DSTEILTESV <> *BLANKS;
           KYTPTA = 'TEST';
           KYTPTC = DSTEILTESV;
           CHIDS = '01C';
           EXSR CHTRTP;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  MC-Routine TESB                                                   ***
       //*************************************************************************
       BEGSR MCTEILTESB;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DASPCD;
         %SUBST(KOMDS:02) = 'TEST';
         %SUBST(KOMDS:12) = DSTEILTESB;
         #CPGST = *BLANK;
         #CUEBE = '0010';
         EXSR MCTRTP;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSTEILTESB = TPTCDE;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TESB                                                   ***
       //*************************************************************************
       BEGSR PRTEILTESB;

         EXFLPOFLDN = 'DSTEILTESB';

         IF DSTEILTESB <> *BLANKS;
           KYTPTA = 'TEST';
           KYTPTC = DSTEILTESB;
           CHIDS = '01C';
           EXSR CHTRTP;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  UPDATE EXED80                                                     ***
       //*************************************************************************
       BEGSR SJWAO060;

         CLEAR EXDATE;
         EXDATEDATV = DSPREIGADA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;

         IF DSKUNDKDNR <> *BLANKS;
           DSKUNDKDGR = KDKDGR;
         ENDIF;

         C_WAO060SB(RTDATEDATE:
                    DSKUNDKDNR:
                    DSKUNDKDGR:
                    DSTEILPRGR:
                    DSTEILTESV:
                    DSTEILTESB);


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

       WKTRPA = *ON;



       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  AUFBEREITEN DER NACHRICHTEN                                       ***
       //*************************************************************************
       BEGSR AUMSG;



       C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
       W$PA06:W$PA07);
       PGMNAM = 'WAO060';
       C#INIT = *ON;

       SELECT;
       WHEN WKIFMT = '01';
         WRITE CTWAOEW2;
       OTHER;
         WRITE WAO060CT;
       ENDSL;

       C#INIT = *OFF;

       SELECT;
       WHEN WKIFMT = '01';
         WRITE CTWAOEW2;
       OTHER;
         WRITE WAO060CT;
       ENDSL;

       W$PA03 = *BLANK;
       W$PA04 = *BLANK;
       W$PA05 = *BLANK;
       W$PA06 = *BLANK;
       W$PA07 = *BLANK;
       W$PA08 = *BLANK;
       WKFENR = '0000';


       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRZTPR
     C/COPY QCPYSRC,VINFO
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
