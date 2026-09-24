     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2014')
      //*************************************************************************
      /TITLE  BWAE-Sätze mit Lieferantenpreisen
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Ziegelhofstraße 210a
      //                       DE 79110 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 15.10.2014 DOMETIC Projekt 10797
      //  -----------------------------------------------------------------------
      //
      //*************************************************************************
      //
      //  Über dieses Programm wird die Übernahme der BWAE-Sätze mit
      //  Leferantenpreisen gestartet
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FWAO054FM  CF   E             WORKSTN USROPN
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
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
      //
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
      //
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
      //
     D EXTREND       E DS
     D RTTREND       E DS                  INZ
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
      // Program name: C_WAO053
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      //--------------------------------------------------
     D C_WAO053...
     D                 PR                  EXTPGM('WAO053SB')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

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

     C     *ENTRY        PLIST
     C                   PARM                    EXTREND

      /FREE
       EXSR UEBTREND;

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

       SELECT;
       WHEN PCPGST = 'SCDJOB';
         EXSR B01DS;

         CLEAR EXDATE;
         EXDATEDATV = %DEC(%DATE:*ISO);
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSSTDA = RTDATEDATE;

         EXSR B01PR;

         IF WKFENR = *ZERO;
           CLEAR EXTREND;

           CLEAR EXDATE;
           EXDATEDATV = DSSTDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;

           EXTRNDKEYB = %EDITC(DSBWAEWEJJ:'X') +
                        DSBWAEWENR +
                        %EDITC(RTDATEDATE:'X');

           C_WAO053(EXTREND:RTTREND);
         ENDIF;

         WKIFMT = '00';
       ENDSL;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           OPEN(E) WAO054FM;
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
         CLOSE(E) WAO054FM;
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
       KYAEFI = DAFIRM;                                                         // BWAE

       EXFIRMFIRM = DAFIRM;
       EXSR PRFIRMFIRM;
       %SUBST(W99DS:01) = EXFIRMKNAM;
       %SUBST(W99DS:31) = *BLANK;

       EXTRDNDANA = 'WAO054';
       EXSR RDTRDNTRDN;
       %SUBST(W99DS:32) = EXTRDNTEXT;

       WNKOPF = %SUBST(W99DS:32);

       EXFLPOFMTN = 'WAO054FM';


       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

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
         WRITE WAO054W1;
         WRITE WAO05401;
         WRITE W1W054B1;

         SELECT;
         WHEN WKFENR <> *ZERO;
           EXSR AUMSG;
         ENDSL;

         C#WNDW = *OFF;

         READ(E) WAO05401;
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

           CLEAR EXTREND;

           CLEAR EXDATE;
           EXDATEDATV = DSSTDA;
           EXDATEFMTV = '*EUR';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRDAUM';
           EXSR TRDATE;

           EXTRNDKEYB = %EDITC(DSBWAEWEJJ:'X') +
                        DSBWAEWENR +
                        %EDITC(RTDATEDATE:'X');

           C_WAO053(EXTREND:RTTREND);
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

       WKFENR = '0000';
       EXFLPOFLDN = 'DSW054STDA';


       ENDSR;
       //*************************************************************************
       //**  PLAUSIPRÜFUNG FÜR BILD01                                          ***
       //*************************************************************************
       BEGSR B01PR;


       WKFENR = '0000';

       EXSR PRBWAEWENR;

       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       EXSR PRSTDA;

       IF WKFENR <> *ZERO;
         LEAVESR;
       ENDIF;

       IF DSSTDA = *ZERO AND
          DSBWAEWEJJ = *ZERO AND
          DSBWAEWENR = *BLANKS;
         WKFENR = '0040';
         EXFLPOFLDN = 'DSW054STDA';
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
         EXFLPOFLDN = 'DSSTDA    ';

       WHEN FLDNAM = 'DSSTDA';
         EXSR MCAUFRSTDA;

       WHEN FLDNAM = 'DSBWAEWENR';
         EXSR MCBWAEWENR;

       OTHER;
         WKFENR = '0050';
       ENDSL;


       ENDSR;
       //*************************************************************************
       //**  MC-ROUTINE STDA                                                   ***
       //*************************************************************************
       BEGSR MCAUFRSTDA;


       C#WNDW = *ON;
       EXFLPOFLDN = 'DSSTDA';

       CLEAR EXDATE;
       EXDATEDATV = DSSTDA;
       EXDATEFMTV = '*EUR';
       EXDATEFMTN = '*EUR';
       IF DSSTDA = *ZERO;
         EXDATEPGCD = 'POSANF';
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


       C#CLEA = '0';
       EXFLPOFLDN = 'DSSTDA';

       IF DSSTDA = *ZERO;
         LEAVESR;
       ENDIF;

       CLEAR EXDATE;
       EXDATEDATV = DSSTDA;
       EXDATEFMTV = '*EUR';
       EXDATEFMTN = '*EUR';
       EXDATEPGST = 'TRDAPR';
       EXSR TRDATE;
       WKFENR = RTDATEFENR;

       IF WKFENR = *ZERO;
         DSSTDA = RTDATEDATE;
       ENDIF;


       ENDSR;
       //*************************************************************************
       //**  MC-ROUTINE WENR                                                   ***
       //*************************************************************************
       BEGSR MCBWAEWENR;


       C#WNDW = *ON;
       EXFLPOFLDN = 'DSBWAEWENR';

       KOMDS = *BLANK;
       %SUBST(KOMDS:15:04) = %EDITC(DSBWAEWEJJ:'X');
       %SUBST(KOMDS:19:06) = DSBWAEWENR;
       #CPGST = *BLANK;
       #CUEBE = '0010';
       EXSR MCBWAE;

       IF WKTRTP = *OFF
         AND WKFENR = *ZERO;
         WKTRTP = *ON;
         DSBWAEWEJJ = AEWEJJ;
         DSBWAEWENR = AEWENR;
       ENDIF;


       ENDSR;
       //*************************************************************************
       //**  PR-ROUTINE WENR                                                   ***
       //*************************************************************************
       BEGSR PRBWAEWENR;


       EXFLPOFLDN = 'DSBWAEWENR';

       IF DSBWAEWEJJ = *ZERO AND
          DSBWAEWENR = *BLANKS;
       ELSE;
         KYAEWJ = DSBWAEWEJJ;
         MONITOR;
           KYAEWN = %INT(%TRIM(DSBWAEWENR));
         ON-ERROR;
           KYAEWN = *ZERO;
         ENDMON;
         CHIDS = '09C';
         EXSR CHBWAE;
       ENDIF;


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
       PGMNAM = 'WAO054';
       C#INIT = *ON;

       SELECT;
       WHEN WKIFMT = '01';
         WRITE CTW054W1;
       OTHER;
         WRITE WAO054CT;
       ENDSL;

       C#INIT = *OFF;

       SELECT;
       WHEN WKIFMT = '01';
         WRITE CTW054W1;
       OTHER;
         WRITE WAO054CT;
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
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCBWAE
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
