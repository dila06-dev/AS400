     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2014')
      //*************************************************************************
      /TITLE Anzeigen Reservierungs-Parameter
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 17.12.2014 DOMETIC Projekt 10777
      //  -----------------------------------------------------------------------
      //  Änderung: RS 05.03.2014 Intergation des Feld Lieferung Komplett AKLIAR
      //  Änderung: PH 13.03.2014 DOMETIC Projekt 10777 Nachtrag: DSALTE füllen. Ermitteln das
      //            Datum der nächsten Wiederverfügbarkeit sowie die noch freie verfügbare Menge
      //*************************************************************************
      //
      //  Dieses Programm zeigt die Reservierung-Parameter zu einer KD-Auftrags-Position
      //
      //*************************************************************************
      //**  Dateibeschreibungen                                               ***
      //*************************************************************************
     FWAO057FM  CF   E             WORKSTN USROPN
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
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ

     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ

     D DIST          E DS                  INZ

     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ

     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRPC          E DS                  INZ

     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D TRDZ          E DS                  INZ
     D KYTRDZ        E DS                  INZ
     D UXTRDZ        E DS                  INZ

     D TRDN          E DS                  INZ
     D KYTRDN        E DS                  INZ

     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ

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

     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ

     D EXTREND       E DS
     D RTTREND       E DS

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  Work-Datenstruktur für Kopier-Funktion                            ***
      //*************************************************************************
     D D$DAST          DS          2048    INZ
     D KYSAVE          DS          1024    INZ

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
     D/COPY QCPYSRC,EXUX05

     D  WKTDAT         S               D   DATFMT(*ISO) INZ

      //*************************************************************************
      //**  Programmstatus Datenstruktur                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKC001          S              1    INZ
     D WKN010          S              1S 0 INZ
     D ##CHI           S              8    INZ
     D ##RTCD          S              1    INZ
     D ##PGST          S              1    INZ
     D WKIFMT          S              2    INZ
     D WKRTCD          S              1    INZ
     D WKTRTP          S              1    INZ
     D WKTRPA          S              1    INZ
     D WKIOKZ          S              1    INZ
     D WKI000          S              1    INZ
     D WKCFMT          S              1    INZ
     D WKTRPADART      S              2    INZ
     D WKTRPAPLBD      S              1    INZ
     D WKTRPASIBE      S              1    INZ
     D WKTRPAVFBD      S              1    INZ
     D WKTRDZZYKL      S              1    INZ
     D WKIN30          S              1    INZ
     D WKIN31          S              1    INZ
     D WKC010          S             10    INZ
     D WKTRAF16SJ      S              1    INZ
     D I0              S              3S 0 INZ
     D I1              S              3S 0 INZ
     D I2              S              3S 0 INZ
     D FL              S              4S 0 INZ
     D WKFIRM          S                   INZ LIKE(DAFIRM)
     D WKUSER          S                   INZ LIKE(DSUSER)
     D WKJDAT          S                   INZ LIKE(DSJDAT)
     D WKJZEI          S                   INZ LIKE(DSJZEI)
     D SVTR02          S                   INZ LIKE(EXTR02)
     D PCPGST          S                   INZ LIKE(#CPGST)
     D WKPGST          S                   INZ LIKE(#CPGST)
     D PCRTCD          S                   INZ LIKE(#CRTCD)
     D WKPROG          S                   INZ LIKE(RTTRNDPROG)
     D WKDANA          S                   INZ LIKE(RTTRNDDANA)
     D WKFFLD          S                   INZ LIKE(RTTRNDFFLD)
     D DSAFPOAFJJ      S                   INZ LIKE(KYAPJH)
     D DSAFPOAFNR      S                   INZ LIKE(KYAPAF)
     D DSAFPOAFPO      S                   INZ LIKE(KYAPPO)
     D WKLBRSJDAT      S                   INZ LIKE(LBRSJDAT)
     D WKZTFK          S                   INZ LIKE(ZTZTFK)
     D W1ZTFK          S                   INZ LIKE(ZTZTFK)
     D DSRESS          S                   INZ LIKE(DUN134)
     D WKFEAT          S              1    INZ
     D WKFENR          S              4    INZ
     D WKINFO          S              4    INZ
     D W$PA03          S             10    INZ
     D W$PA04          S             10    INZ
     D W$PA05          S             10    INZ
     D W$PA06          S             10    INZ
     D W$PA07          S             10    INZ
     D W$PA08          S             10    INZ

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
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
      // Program name: C_TRLBB2
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #EXLBB2
      // Parameter:      #RTLBB2
      //--------------------------------------------------
     D C_TRLBB2...
     D                 PR                  EXTPGM('TRLBB2')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #EXLBB2                            LIKEDS(EXLBB2)
     D  #RTLBB2                            LIKEDS(RTLBB2)

      //--------------------------------------------------
      // Program name: C_TRTEXT
      // Purpose:
      // Returns:
      // Parameter:      #EXTEXT
      // Parameter:      #RTTEXT
      //--------------------------------------------------
     D C_TRTEXT...
     D                 PR                  EXTPGM('TRTEXT')
     D  #EXTEXT                            LIKEDS(EXTEXT)
     D  #RTTEXT                            LIKEDS(RTTEXT)

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
      // Program name: C_WAO008
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_WAO008...
     D                 PR                  EXTPGM('WAO008')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

      //--------------------------------------------------
      // Program name: C_WAO00Y
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_WAO00Y...
     D                 PR                  EXTPGM('WAO00Y')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

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
           CLOSE WAO057FM;
           WKIOKZ = *OFF;
         ENDIF;
         WKIFMT = '00';

       //WHEN DATEST = '5';
         //PCPGST = '5     ';

       ENDSL;

       //*************************************************************************
       //**  Programmsteuerung                                                 ***
       //*************************************************************************
       DOW WKIFMT <> '00';

         IF WKIOKZ <> *ON;
           EXSR AUFFOR;
           OPEN(E) WAO057FM;
           *IN98 = %ERROR;
           WKIOKZ = *ON;
         ENDIF;

         IF C#IN28 = *ON;
           IF WKTRDZ <> *ON;
             EXTRDZFUKT = 'WAO057';
             EXTRDZAUSW = 'WAO057';
             EXSR ERTRDZ;
             WKTRDZ = *ON;
           ENDIF;
         ENDIF;

         SELECT;
         WHEN WKIFMT = '01';
           EXSR BILD01;
         WHEN WKIFMT = '02';
           EXSR BILD02;
         ENDSL;

       ENDDO;

       IF #CRTCD = 'N'
         AND WKIOKZ = *ON;
         CLOSE(E) WAO057FM;
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
         KYAKFI = DAFIRM;      // AFKO
         KYAPFI = DAFIRM;      // AFPO
         KYLBRSFIRM = DAFIRM;  // LBRS
         KYTEEWFIRM = DAFIRM;  // TEIL
         KYTEFI = DAFIRM;      // TEIL
         KYTAFI = DAFIRM;      // TRPA
         KYTPFI = DAFIRM;      // TRTP
         KYZTFI = DAFIRM;      // ZTDI

         // Firmensprache in allen Keystrukturen setzen
         KYTPSP = DASPCD;      // TRTP

         EXFLPOFMTN = 'WAO057FM';
         CLEAR EXTRPB;
         EXTRPBBPRG = 'WAO057FM';

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

         SELECT;

         WHEN PCPGST = 'BILD01';
           MONITOR;
             KYAPJH = %INT(%SUBST(EXTRNDKEYB:01:04));
           ON-ERROR *PROGRAM;
             KYAPJH = *ZERO;
           ENDMON;

           KYAPAF   = %SUBST(EXTRNDKEYB:05:06);

           MONITOR;
             KYAPPO = %INT(%SUBST(EXTRNDKEYB:11:04));
           ON-ERROR *PROGRAM;
             KYAPPO = *ZERO;
           ENDMON;

           DSAFPOAFJJ = KYAPJH;
           DSAFPOAFNR = KYAPAF;
           DSAFPOAFPO = KYAPPO;

         WHEN PCPGST = 'BILD02';

           KYTENR   = %SUBST(EXTRNDKEYB:01);
           DSTEILTENR = KYTENR;

         ENDSL;

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

         SELECT;
         WHEN PCPGST = 'BILD01';
           WKIFMT = '01';
         WHEN PCPGST = 'BILD02';
           WKIFMT = '02';
         ENDSL;

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

         SELECT;
         WHEN PCPGST = 'BILD01';
           EXTRDNDANA = 'WAO05701';
         WHEN PCPGST = 'BILD02';
           EXTRDNDANA = 'WAO05702';
         ENDSL;
         EXSR RDTRDNTRDN;
         %SUBST(W99DS:32) = EXTRDNTEXT;
         DSKOPF = W99DS;
         //WNKOPF = %SUBST(W99DS:32);

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
          %SUBST(WKFLPORECN:1:8) = 'WAO05701';

          WRITE WAO057CL;

          EXSR EFLPO;
          IF RCDNRTRDZB > *ZERO;
            WRITE SFTRDZBK1;
          ENDIF;

          WRITE WAO05701;
          WRITE WAO057B1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          //FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          SELECT;
          WHEN WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDSL;

          C#WNDW = *OFF;

          READ(E) WAO05701;
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

        ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 01                                        ***
       //*************************************************************************
       BEGSR B01DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;
         PCRTCD = #CRTCD;

         CHIDS = '01C';
         EXSR CHAFPO;

         DSAFPOAFJJ = APAFJJ;
         DSAFPOAFNR = APAFNR;
         DSAFPOAFPO = APAFPO;

         DSTEILTENR = APTENR;

         // INITIALISIEREN DER TEXTFELDER
         DSTEILTBZ1 = *BLANK;
         DSTEILTBZ2 = *BLANK;
         DSTEILTEST = *BLANK;
         TXTEILTEST = *BLANK;
         DSTEILMEIN = *BLANK;
         TXTEILMEIN = *BLANK;
         DSERTE     = *BLANK;
         DSALTE     = *BLANK;
         TXALTE     = *BLANK;
         DSPRGR     = *BLANK;
         DSSOLI     = *ZERO;
         DSVFBS     = *ZERO;
         DSLAGB     = *ZERO;

         DSTEILSAEK = *BLANK;
         TXTEILSAEK = *BLANK;
         DSWBZT     = *ZERO;
         DSTEILLVZ1 = *ZERO;
         DSLBRSJDAT = *ZERO;
         DSAFKOKOSP = *BLANK;
         TXAFKOKOSP = *BLANK;
         DSAFKOAFST = *BLANK;
         TXAFKOAFST = *BLANK;
         DSTEEWLVZT = *ZERO;
         DSRSAT     = *BLANK;
         DSRSZR     = *ZERO;
         DSWVTE     = *ZERO;
         DSAFKOLIAR = *BLANK;
         TXAFKOLIAR = *BLANK;

         // FÜLLEN DER TEXTFELDER MIT INTERPRETATIONEN
         IF DSAFPOAFNR <> *BLANK;
           EXSR PRAFPOAFNR;
         ENDIF;

         IF DSTEILTENR <> *BLANK;
           EXSR PRTEILTENR;
         ENDIF;

         KYTATA = 'TRAF17';
         KYTATC = 'RSZR';
         KYTAPA = 'RSZR';
         CHIDS = '01C';
         EXSR CHTRPA;
         DUC003 = TAPCDE;
         MONITOR;
           *IN(98) = *ON;
           DUN030 *= 1;
         ON-ERROR;
           *IN(98) = *OFF;
         ENDMON;
         IF *IN(98) <> *ON;
           DUC003 = '000';
         ENDIF;
         DSRSZR = DUN030;

         CLEAR EXTREND;
         CLEAR RTTREND;
         %SUBST(EXTRNDKEYB:01:04) = %EDITC(APAFJJ:'X');
         %SUBST(EXTRNDKEYB:05) = APAFNR;
         %SUBST(EXTRNDKEYB:11:05) = %EDITC(%DEC(APAFPO:5:0):'X');
         CALLP(E) C_WAO008(EXTREND:RTTREND);
         *IN99 = %ERROR;

         MONITOR;
           DSWVTE = %INT(%SUBST(RTTRNDDATE:01:08));
         ON-ERROR *PROGRAM;
           DSWVTE = *ZERO;
         ENDMON;

         CLEAR EXDATE;
         EXDATEDATV = DSWVTE;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSWVTE = RTDATEDATE;

         EXTRPBBFMT = 'WAO05701';
         EXSR CSTRPB;

         WKFENR = *ZERO;
         EXFLPOFLDN = *BLANK;

         SELECT;
         WHEN PCPGST = '5     ';
           C#LCK0 = *ON;
           C#LCK1 = *ON;
         ENDSL;

         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Steuerroutine BILD02                                              ***
       //*************************************************************************
       BEGSR BILD02;

        IF WKIFMT <> FMT(FM);
          EXSR IFMTS;
        ENDIF;

        EXSR B02DS;

        DOW WKIFMT = '02';
          %SUBST(WKFLPORECN:1:8) = 'WAO05702';

          WRITE WAO057CL;

          EXSR EFLPO;
          IF RCDNRTRDZB > *ZERO;
            WRITE SFTRDZBK1;
          ENDIF;

          WRITE WAO05702;
          WRITE WAO057B1;
          EXSR OFFUKT;
          FUKT04 = *ON;
          //FUKT10 = *ON;
          FUKT12 = *ON;
          FUKT13 = *ON;

          SELECT;
          WHEN WKFENR <> *ZERO;
            EXSR AUMSG;
          ENDSL;

          C#WNDW = *OFF;

          READ(E) WAO05702;
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

        ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 02                                        ***
       //*************************************************************************
       BEGSR B02DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;
         PCRTCD = #CRTCD;

         CHIDS = '01C';
         EXSR CHTEIL;

         DSTEILTENR = TETENR;

         // INITIALISIEREN DER TEXTFELDER
         DSTEILTBZ1 = *BLANK;
         DSTEILTBZ2 = *BLANK;
         DSTEILTEST = *BLANK;
         TXTEILTEST = *BLANK;
         DSTEILMEIN = *BLANK;
         TXTEILMEIN = *BLANK;
         DSERTE     = *BLANK;
         DSALTE     = *BLANK;
         TXALTE     = *BLANK;
         DSPRGR     = *BLANK;
         DSSOLI     = *ZERO;
         DSVFBS     = *ZERO;
         DSLAGB     = *ZERO;

         DSRESN     = *ZERO;
         DSWEMG     = *ZERO;
         DSSIBE     = *ZERO;
         DSBESN     = *ZERO;
         DSUNTW     = *ZERO;
         DSEZPR     = *ZERO;
         DSSPER     = *ZERO;
         DSRESL     = *ZERO;
         DSNAWV     = *ZERO;
         DSFRVF     = *ZERO;

         IF DSTEILTENR <> *BLANK;
           EXSR PRTEILTENR;
         ENDIF;

         EXTRPBBFMT = 'WAO05702';
         EXSR CSTRPB;

         WKFENR = *ZERO;
         EXFLPOFLDN = *BLANK;

         SELECT;
         WHEN PCPGST = '5     ';
           C#LCK0 = *ON;
           C#LCK1 = *ON;
         ENDSL;

         #CRTCD = *BLANK;

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
           ENDSL;

           IF WKFENR <> *ZERO;
             LEAVESR;
           ENDIF;
         ENDFOR;

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine AFNR                                                   ***
       //*************************************************************************
       BEGSR PRAFPOAFNR;

         KYAKJH = DSAFPOAFJJ;
         KYAKAF = DSAFPOAFNR;
         CHIDS = '01C';
         EXSR CHAFKO;

         DSAFKOKOSP = AKKOSP;

         EXTRPCPGGR = 'JNKZ';
         EXTRPCCODE = DSAFKOKOSP;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         TXAFKOKOSP = EXTRPCTEXT;

         EXTRPCPGGR = 'STATAFKO';
         EXTRPCCODE = DSAFKOAFST;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         TXAFKOAFST = EXTRPCTEXT;

         DSAFKOLIAR = AKLIAR;
         EXTRPCPGGR = 'JNKZ';
         EXTRPCCODE = DSAFKOLIAR;
         EXTRPCPGST = 'PRUEFE';
         EXSR PRTRPC;
         TXAFKOLIAR = EXTRPCTEXT;

         WKLBRSJDAT = *ZERO;
         WKTRAF16SJ = *OFF;

         KYLBRSAFDN = 'AFPO';
         KYLBRSAFJJ = DSAFPOAFJJ;
         KYLBRSAFNR = DSAFPOAFNR;
         KYLBRSAFPO = DSAFPOAFPO;
         KYLBRSAFUP = *ZERO;
         KYLBRSTMST = *ZERO;
         CHIDS = '03+';
         EXSR CHLBRS;
         DOW CHI(5) = 'J'
           AND LBRSFIRM = KYLBRSFIRM
           AND LBRSAFDN = KYLBRSAFDN
           AND LBRSAFJJ = KYLBRSAFJJ
           AND LBRSAFNR = KYLBRSAFNR
           AND LBRSAFPO = KYLBRSAFPO;

           IF LBRSPROG = 'TRAF16SJ';
             WKTRAF16SJ = *ON;
             WKLBRSJDAT = LBRSJDAT;
             LEAVE;
           ENDIF;

           IF WKLBRSJDAT = *ZERO;
             WKLBRSJDAT = LBRSJDAT;
           ENDIF;

           CHIDS = '03R';
           EXSR CHLBRS;
         ENDDO;

         CLEAR EXDATE;
         EXDATEDATV = WKLBRSJDAT;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSLBRSJDAT = RTDATEDATE;

         IF WKLBRSJDAT <> *ZERO;
           CLEAR EXTEXT;
           EXTEXTPGST = 'PRUEFE';
           EXTEXTSPCD = DASPCD;
           IF WKTRAF16SJ = *ON;
             EXTEXTMSGA = 'KON';
             EXTEXTMSGN = '8627'; // Automatisch
           ELSE;
             EXTEXTMSGA = 'KON';
             EXTEXTMSGN = '2732'; // Manuell
           ENDIF;
           C_TRTEXT(EXTEXT:RTTEXT);
           DSRSAT = RTTEXTTEXT;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  PR-Routine TENR                                                   ***
       //*************************************************************************
       BEGSR PRTEILTENR;

         EXFLPOFLDN = 'DSTEILTENR';

         KYTENR = DSTEILTENR;
         CHIDS = '01C';
         EXSR CHTEIL;
         DSTEILTENR = TETENR;
         DSTEILTBZ1 = TETBZ1;
         DSTEILTBZ2 = TETBZ2;
         DSTEILTEST = TETEST;
         DSTEILMEIN = TEMEIN;
         DSTEILSAEK = TESAEK;
         DSTEILLVZ1 = TELVZ1;

         DSERTE     = TEERTE;

         D$DAST = TEIL;
         KYSAVE = KYTEIL;
         KYTEET = DSTEILTENR;
         KYTENR = *BLANK;
         CHIDS = '06+';
         EXSR CHTEIL;
         IF CHI(5) = 'J'
           AND TEFIRM = KYTEFI
           AND TEERTE = KYTEET;
           DSALTE = TETENR;
           TXALTE = TETBZ1;
         ENDIF;
         TEIL = D$DAST;
         KYTEIL = KYSAVE;

         DSPRGR     = TEPRGR;

         KYTEEWTENR = TETENR;
         CHIDS = '01C';
         EXSR CHTEEW;

         KYTPTA = 'TEST';
         KYTPTC = DSTEILTEST;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXTEILTEST = TPTTXT;

         KYTPTA = 'MEIN';
         KYTPTC = DSTEILMEIN;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXTEILMEIN = TPTTXT;

         KYTPTA = 'SABE';
         KYTPTC = DSTEILSAEK;
         CHIDS = '01C';
         EXSR CHTRTP;
         TXTEILSAEK = TPTTXT;

         IF TEEWLVZA <> *BLANK
           AND TEEWLVZA <> TELVA1
           AND TELVA1 <> *BLANK;

           KYZTZD = TELVA1;
           CHIDS = '01C';
           EXSR CHZTDI;
           WKZTFK = ZTZTFK;
           IF WKZTFK = *ZERO;
             WKZTFK = 1;
           ENDIF;

           KYZTZD = TEEWLVZA;
           CHIDS = '01C';
           EXSR CHZTDI;
           W1ZTFK = ZTZTFK;
           IF WKZTFK = *ZERO;
             W1ZTFK = 1;
           ENDIF;

           DUN030 = W1ZTFK / WKZTFK;

           DSTEEWLVZT  = %DEC(TEEWLVZT * DUN030:3:0);
         ELSE;

           DSTEEWLVZT = TEEWLVZT;
         ENDIF;

         DSWBZT = TELVZ1 + DSTEEWLVZT;

         EXSR TRLBB2;

         EXSR WAO00Y;

         %SUBST(KOMDS:01) = DSTEILTENR;
         %SUBST(KOMDS:50:1) = 'V';
         %SUBST(KOMDS:51) = '902';
         #CPGST = 'E1RSDA';
         #CUEBE = '0704';
         EXSR MCDIST;

         DUC008 = %SUBST(#CKOMM:01);
         MONITOR;
           *IN(97) = *ON;
           DUN080 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC008 = '00000000';
         ENDIF;
         CLEAR EXDATE;
         EXDATEDATV = DUN080;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         DSNAWV = RTDATEDATE;

         DUC013 = %SUBST(#CKOMM:09:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         DSFRVF = %DEC(DUN134:11:2);

         WKFENR = *ZERO;

       ENDSR;

       //*************************************************************************
       //**  TRLBB2  ERMITTELN VERFÜGBARER LAGERBESTAND                        ***
       //*************************************************************************
       BEGSR TRLBB2;

         DSLAGB = *ZERO;                                                     // LAGERBESTAND
         DSSIBE = *ZERO;                                                     // SICHERHEITSBESTAND
         DSRESL = *ZERO;                                                     // LAGERRESERVERIERUNG
         DSRESN = *ZERO;                                                     // BEDARF
         DSRESS = *ZERO;                                                     // SONDERBEDARF
         DSBESN = *ZERO;                                                     // BESTELLBESTAND
         DSVFBS = *ZERO;                                                     // VERFÜGBARER BSTD.

         CLEAR EXLBB2;
         CLEAR RTLBB2;
         #CKOMM = *BLANK;
         %SUBST(#CKOMM:001:01) = *ON;                                           // PRÜFUNG-KZ
         %SUBST(#CKOMM:002:01) = *ON;                                           // ERM.LAGERBESTAND
         IF WKTRPADART = '02'
           OR WKTRPADART = '03';
           %SUBST(#CKOMM:003:01) = *ON;                                         // ERM.LAGERRESERV.
         ELSE;
           %SUBST(#CKOMM:003:01) = *OFF;
         ENDIF;

         %SUBST(#CKOMM:004:01) = *ON;                                           // ERM.DIST RESERV.
         %SUBST(#CKOMM:005:01) = *OFF;                                          // BEDARFSPLAN-LAGER
         %SUBST(#CKOMM:006) = *BLANK;
         %SUBST(#CKOMM:007:01) = *ON;                                           // LAGERPLATZSPERRUN
         %SUBST(#CKOMM:009:01) = *OFF;                                          // NUR ABFÜLLBESTAND
         %SUBST(#CKOMM:010) = DSTEILTENR;
         %SUBST(#CKOMM:215:01)= *ON;                                            // QUALITÄTSTYP PRÜF
         #CPGST = *BLANK;

         EXLBB2VPKZ = 'V';

         C_TRLBB2(EXTR02:EXLBB2:RTLBB2);

         DUC013 = %SUBST(#CKOMM:01);
         DSLAGB = DUN134;

         DUC013 = %SUBST(#CKOMM:14); // Sicherheitsbestand
         DSSIBE = DUN134;

         IF WKTRPASIBE = *OFF;       // DIST-SIBE-KENNZ.
           DSVFBS = DSLAGB - DSSIBE; // Verfügbarer Lager-Bestand
         ELSE;
           DSVFBS = DSLAGB;
         ENDIF;

         DUC013 = %SUBST(#CKOMM:40); // Bedarf
         DSRESN = DUN134;

         DUC013 = %SUBST(#CKOMM:53); // Sonderbedarf
         DSRESS = DUN134;

         DUC013 = %SUBST(#CKOMM:66); // Bestellbestand
         DSBESN = DUN134;

         DUC013 = %SUBST(#CKOMM:92); // Reservierter Bestand
         DSRESL = DUN134;

         IF WKTRPADART = '02'
           OR WKTRPADART = '03';     // BERÜCKSICHTIGEN
           DSVFBS -= DSRESL;         // LAGERRESERVIERUNGEN
         ENDIF;

         IF WKTRPAPLBD = *ON;
           DUC007 = %SUBST(#CKOMM:213); // Planbedarf
           DSRESN += DUN071;
         ENDIF;

         IF WKTRPAVFBD = *ON;                 // Minus Bedarf
           DSVFBS = DSVFBS - DSRESN - DSRESS; // Verf.-Bestand
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  WAO00Y   WAECO                                                    ***
       //*************************************************************************
       BEGSR WAO00Y;

         DSUNTW = *ZERO;
         DSWEMG = *ZERO;
         DSSPER = *ZERO;
         DSEZPR = *ZERO;
         DSSOLI = *ZERO;

         CLEAR EXTREND;
         CLEAR RTTREND;
         %SUBST(EXTRNDKEYB:01) = DSTEILTENR;
         %SUBST(EXTRNDKEYB:16) = 'V';
         CALLP(E) C_WAO00Y(EXTREND:RTTREND);
         *IN99 = %ERROR;

         DUC013 = %SUBST(RTTRNDDATE:016:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSUNTW = DUN134;

         DUC013 = %SUBST(RTTRNDDATE:029:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSWEMG = DUN134;

         DUC013 = %SUBST(RTTRNDDATE:042:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         EVAL(H) DSSPER = DUN134;

         DUC011 = %SUBST(RTTRNDDATE:055:011);
         MONITOR;
           *IN(97) = *ON;
           DUN110 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC011 = '00000000000';
         ENDIF;
         EVAL(H) DSEZPR = DUN113;

         DUC013 = %SUBST(RTTRNDDATE:066:013);
         MONITOR;
           *IN(97) = *ON;
           DUN130 *= 1;
         ON-ERROR;
           *IN(97) = *OFF;
         ENDMON;
         IF *IN97 = *OFF;
           DUC013 = '0000000000000';
         ENDIF;
         DSSOLI= DUN134;
         IF DSSOLI < *ZERO;
           DSSOLI = *ZERO;
         ENDIF;

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
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         KYTATA = 'FIRM';    // ERMITTELN
         KYTATC = 'ZTDI';    // STAMMZEIT-
         KYTAPA = 'ZTDI';    // DIMENSION
         CHIDS = '01C';
         EXSR CHTRPA;
         KYZTSZ = TAPCDE;    // STAMMZEITBASIS

         KYTATA = 'FIRM';    // ERMITTELN
         KYTATC = 'DIST';    // DISPOART
         KYTAPA = 'DART';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPADART = TAPCDE;

         KYTATA = 'TRLBB2';    // Ermitteln
         KYTATC = 'DIST';      // DIST-Bedarf einschließlich
         KYTAPA = 'PLBD';      // Plan-Bedarf
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAPLBD = TAPCDE;
         IF WKTRPAPLBD <> *ON;
           WKTRPAPLBD = *OFF;
         ENDIF;

         KYTATA = 'FIRM';                                                       // ERMITTELN
         KYTATC = 'TRLG02';                                                     // OB SIBE
         KYTAPA = 'DIST';                                                       // MIT DISPO-DATEI
         CHIDS = '01C';
         EXSR CHTRPA;
         IF TAPCDE = '01';
           WKTRPASIBE = *ON;
         ELSE;
           WKTRPASIBE = *OFF;
         ENDIF;

         KYTATA = 'MCDIST';    // Verfügbarer Bestand = Lager-Bestand minus Bedarf
         KYTATC = 'VFBS';
         KYTAPA = 'BDMG';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPAVFBD = TAPCDE;
         IF WKTRPAVFBD <> *ON;
           WKTRPAVFBD = *OFF;
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
           EXTRDNPGNA = 'WAO057';

           IF C#ACCS = *OFF                                                       // F10=OPTIONEN
             AND WKPGST <> 'DIREKT';
             //03.05.2004        MOVEL(P)  'WAO057B1'    EXTRDNPGNA
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
         PGMNAM = 'WAO057';

         C#INIT = *ON;

         SELECT;
         OTHER;
           WRITE WAO057CT;
         ENDSL;

         C#INIT = *OFF;

         SELECT;
         OTHER;
           WRITE WAO057CT;
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
      /COPY QCPYSRC,CHAFKO
      /COPY QCPYSRC,CHAFPO
      /COPY QCPYSRC,CHLBRS
      /COPY QCPYSRC,CHTEEW
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRDN
      /COPY QCPYSRC,CHTRDZ
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHZTDI
      /COPY QCPYSRC,CSTRPB
      /COPY QCPYSRC,EXFLPO
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,EXUX08
      /COPY QCPYSRC,MCDIST
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
      /END-FREE
