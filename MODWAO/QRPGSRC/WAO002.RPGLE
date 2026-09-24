     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2023')
      //*************************************************************************
      /TITLE  Aufruf Update Liefertermin Bestellung
      //*************************************************************************
      //  Copyright 2023 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 06.04.2023 DOMETIC Projekt 230165-01
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Über dieses Programm wird die Neuberechnung des Liefertermins auf Grundlage
      //  des Felds LIEF.LFVSTA "Verschiff-Tage" im Lieferanten-Stamm des an das Programm
      //  übergebenen Lieferanten und dessen nachfolgende Update in allen offenen
      //  Bestellpositionen des an das Programm Lieferanten gestartet.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FWAO002FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)

      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR

      //*************************************************************************
      //**  Konstantendefinition                                              ***
      //*************************************************************************

      //*************************************************************************
      //**  INDICATORS                                                        ***
      //*************************************************************************
     D/COPY QCPYSRC,TRCURSOR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

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
      // Program name: C_WAO003SB
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      //--------------------------------------------------
     D C_WAO003SB...
     D                 PR                  EXTPGM('WAO003SB')
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

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

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
           OPEN WAO002FM;
           WKIOKZ = *ON;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) WAO002FM;
         *IN98 = %ERROR;
         WKIOKZ = *OFF;
       ENDIF;

       WKFIRM = DAFIRM;
       RETURN;

       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKPROG = EXPSDSPROC;
         WKBIBL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         KYLFFI = DAFIRM;               // LIEF
         KYTAFI = DAFIRM;               // TRPA

         EXFIRMFIRM = DAFIRM;
         EXSR PRFIRMFIRM;

         EXTRDNDANA = 'WAO002';
         EXSR RDTRDNTRDN;

         WNKOPF = EXTRDNTEXT;

         EXFLPOFMTN = 'WAO002FM';

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
         DSLIEFLFNR = %SUBST(EXTRNDKEYB:01);

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
           WRITE WAO002W1;
           WRITE WAO00201;
           WRITE W1W002B1;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;

           READ(E) WAO00201;
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

             C_WAO003SB(EXTREND);
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

         KYLFNR = DSLIEFLFNR;
         CHIDS  = '01C';
         EXSR CHLIEF;
         DSLIEFNAM1 = LFNAM1;
         DSLIEFVSTA = LFVSTA;

         #CRTCD = *BLANK;

         WKFENR = *ZERO;
         EXFLPOFLDN = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  PLAUSIPRÜFUNG FÜR BILD01                                          ***
       //*************************************************************************
       BEGSR B01PR;

         WKFENR = *ZERO;

         KYLFNR = DSLIEFLFNR;
         CHIDS  = '01C';
         EXSR CHLIEF;
         IF CHI(5) = 'N';
           // Lieferant falsch
           WKFENR = '9143';
           LEAVESR;
         ELSEIF LFVSTA = *ZERO;
           // Bei diesem Lieferanten sind keine Verschiff-Tage hinterlegt.
           WKFENR = '2676';
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
           EXFLPOFLDN = *BLANK;

         OTHER;
           WKFENR = '0050';
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  UPDATE EXTREND                                                    ***
       //*************************************************************************
       BEGSR UPDTREND;

         %SUBST(EXTRNDKEYB:01) = DSLIEFLFNR;

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

         PGMNAM = 'WAO002';
         C#INIT = *ON;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTW002W1;
         OTHER;
           WRITE WAO002CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         WHEN WKIFMT = '01';
           WRITE CTW002W1;
         OTHER;
           WRITE WAO002CT;
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
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,PRFUKT
      /COPY QCPYSRC,RDTRDNTRDN
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,TRIFMT
      /COPY QCPYSRC,VINFO
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
