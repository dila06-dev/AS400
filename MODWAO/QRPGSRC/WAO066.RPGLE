     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2018')
      //*************************************************************************
      /TITLE  Auswahl Ermitlung/Ausgabe Planartikel
      //*************************************************************************
      //  Copyright 2018 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 10.07.2018 DOMETIC Projekt 14166-01
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Über dieses Programm wird die Ermitlung/Ausgabe von Planartikeln
      //  gestartet
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FWAO066FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)

      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR

      //*************************************************************************
      //**  Konstantendefinition                                              ***
      //*************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')

      //*************************************************************************
      //**  INDICATORS                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ

     D EXTREND       E DS

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
     D  DASTDA               237    244  0
     D  DASTUZ               245    250  0

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
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

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_WAO067SB
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      //--------------------------------------------------
     D C_WAO067SB...
     D                 PR                  EXTPGM('WAO067SB')
     D  #EXTREND                           LIKEDS(EXTREND)

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

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND

      /FREE
       EXSR UEBTREND;

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

       SELECT;

       WHEN PCPGST = 'SCDJOB';                                                  // SCD-AUFRUF

         EXSR B01DS;
         EXSR B01PR;

         IF WKFENR = *ZERO;
           EXSR UPDTREND;

           C_WAO067SB(EXTREND);
         ENDIF;

         WKIFMT = '00';

       ENDSL;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           OPEN WAO066FM;
           WKIOKZ = *ON;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) WAO066FM;
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

         KYTEFI = DAFIRM;               // TEIL
         KYTAFI = DAFIRM;               // TRPA

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'WAO066';
         EXSR RDTRDNTRDN;

         WNKOPF = EXTRDNTEXT;

         EXFLPOFMTN = 'WAO066FM';

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR EXDATA;
         CLEAR RTDATA;
         EXDATAFILE = 'EXTREND';
         EXDATADATA = EXTREND;
         C_INZDATASTR(EXDATA:RTDATA);
         EXTREND = RTDATADATA;

         PCPGST = EXTRNDPGST;

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
           WRITE WAO066W1;
           WRITE WAO06601;
           WRITE W1W066B1;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) WAO06601;
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

             EXSR UPDTREND;

             C_WAO067SB(EXTREND);
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

         DSSTDA = %DEC(%DATE:*EUR);
         DSSTUZ = %DEC(%TIME());
         CLEAR DSTENR;

         WKFENR = *ZERO;
         EXFLPOFLDN = 'DSSTDA';

       ENDSR;

       //*************************************************************************
       //**  PLAUSIPRÜFUNG FÜR BILD01                                          ***
       //*************************************************************************
       BEGSR B01PR;

         WKFENR = *ZERO;

         EXSR PRSTDA;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRSTUZ;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         EXSR PRTENR;
         IF WKFENR <> *ZERO;
           LEAVESR;
         ENDIF;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
       //*************************************************************************
       BEGSR MCAUFR;

         WKTRTP = *OFF;
         WKFENR = *ZERO;
         EXFLPOFLDN = FLDNAM;

         SELECT;

         WHEN FLDNAM = *BLANK;
           WKFENR = '0050';
           EXFLPOFLDN = 'DSSTDA    ';

         WHEN FLDNAM = 'DSSTDA';
           EXSR MCAUFRSTDA;

         WHEN FLDNAM = 'DSTENR';
           EXSR MCAUFRTENR;

         OTHER;
           WKFENR = '0050';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  MC-ROUTINE STDA                                                   ***
       //*************************************************************************
       BEGSR MCAUFRSTDA;

         C#WNDW = *ON;

         CLEAR EXDATE;
         EXDATEDATV = DSSTDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         IF DSSTDA = *ZERO;
           EXDATEPGCD = 'POSAKT';
         ENDIF;
         EXSR TRDATE;

         IF WKFENR = *ZERO;
           DSSTDA = RTDATEDATE;
           WKTRTP = *ON;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE STDA                                                   ***
       //*************************************************************************
       BEGSR PRSTDA;

         EXFLPOFLDN = 'DSSTDA';

         CLEAR EXDATE;
         EXDATEDATV = DSSTDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAPR';
         EXSR TRDATE;
         WKFENR = RTDATEFENR;

         IF WKFENR = *ZERO;
           DSSTDA = RTDATEDATE;

           CLEAR EXDATE;
           EXDATEDATV = DSSTDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;
           IF RTDATEDATE < %DEC(%DATE():*ISO);
             WKFENR = '0036';
           ENDIF;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-ROUTINE STUZ                                                   ***
       //*************************************************************************
       BEGSR PRSTUZ;

         EXFLPOFLDN = 'DSSTUZ';

         #CDATV = DSSTUZ;
         #CFMTV = '  HHMMSS';
         EXSR TRZTPR;

       ENDSR;

       //*************************************************************************
       //**  MC-Aufruf TENR                                                    ***
       //*************************************************************************
       BEGSR MCAUFRTENR;

         C#WNDW = *ON;

         %SUBST(KOMDS:01) = DSTENR;
         #CPGST = *BLANK;
         #CUEBE = '0526';
         EXSR MCTEIL;

         IF WKTRTP = *OFF
           AND WKFENR = *ZERO;
           WKTRTP = *ON;
           DSTENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRTENR;

         EXFLPOFLDN = 'DSTENR';

         IF DSTENR <> *BLANK;
           KYTENR = DSTENR;
           CHIDS = '01C';
           EXSR CHTEIL;
           IF WKFENR  <>  *ZERO
             AND %SCAN(WCTRD:DSTENR) = *ZERO;                                 // "*"-Funktion
             LEAVESR;
           ELSE;
             WKFENR = *ZERO;
           ENDIF;

           DSTENR = TETENR;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  UPDATE EXTREND                                                    ***
       //*************************************************************************
       BEGSR UPDTREND;

         %SUBST(EXTRNDKEYB:01) = DSTENR;

         CLEAR EXDATE;
         EXDATEDATV = DSSTDA;
         EXDATEFMTV = '*EUR';
         EXDATEFMTN = DAJDFM;
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DASTDA = RTDATEDATE;
         DASTUZ = DSSTUZ;

         OUT EXTRLD;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  AUFBEREITEN DER NACHRICHTEN                                       ***
       //*************************************************************************
       BEGSR AUMSG;

         C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
         W$PA06:W$PA07);

         PGMNAM = 'WAO066';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTW066W1;
         OTHER;
           WRITE WAO066CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTW066W1;
         OTHER;
           WRITE WAO066CT;
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
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,MCTEIL
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,TRZTPR
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
