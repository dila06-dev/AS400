     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
      //*************************************************************************
      /TITLE  Ermitteln Rückstandsemneg für die LFS-Schnittstellendatei PBESTSS2
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 28.08.2015 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //  Dieses Programm  ermittelt die Rückstandsmenge zu einem Artikel.
      //  Der im Feld R1TRNDNU01 zurückgegebene Wert "Rückstandsmenge" ist in das
      //  entsprechende Feld in PBESTSS2 zu schreiben
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFPO          E DS                  INZ

     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ

     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

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

     D E1TREND       E DS
     D R1TREND       E DS

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

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
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKUDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)

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

      //*************************************************************************
      //**  Rechenbestimmungen                                                ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    E1TREND
     C                   PARM                    R1TREND

      /FREE
       EXSR UEBTREND;
       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       EXSR O1AFPO;
       EXSR V1AFPO;

       EXSR O2AFPO;
       EXSR V2AFPO;

       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         KYAEFI = DAFIRM;     // BWAE
         KYTUFI = DAFIRM;     // TEUF
         KYTAFI = DAFIRM;     // TRPA
         KYTPFI = DAFIRM;     // TRTP

         KYTPSP = DASPCD;     //TRTP

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER E1TREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR EXDATA;
         EXDATAFILE = 'E1TREND';
         EXDATADATA = E1TREND;
         C_INZDATASTR(EXDATA:RTDATA);
         E1TREND = RTDATADATA;

         CLEAR EXDATA;
         EXDATAFILE = 'R1TREND';
         EXDATADATA = R1TREND;
         C_INZDATASTR(EXDATA:RTDATA);
         R1TREND = RTDATADATA;

         CLEAR R1TREND;

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

         KYAEWJ = E1TRNDJAHR;
         KYAEWE = E1TRNDNMKR;
         CHIDS = '07C';
         EXSR CHBWAE;

         WKUDAT = %DEC(%DATE:*ISO);

       ENDSR;

       //*************************************************************************
       //**  Selektieren AFPO-Sätze, die der Bestell-Position aus WE zugeordnet **
       //**  sind (SQL-Cursor ADPOC1)
       //*************************************************************************
       BEGSR O1AFPO;

         EXEC SQL
         DECLARE AFPOC1 CURSOR FOR SELECT * FROM AFPO
         WHERE APFIRM = :DAFIRM AND APAFST < '20'
               AND APKMTE < :WKUDAT
               AND EXISTS(SELECT BBEU.EUFIRM FROM BBEU
               WHERE BBEU.EUFIRM = AFPO.APFIRM
               AND BBEU.EUVPKZ = 'V'
               AND BBEU.EUAFJJ = AFPO.APAFJJ
               AND BBEU.EUAFNR = AFPO.APAFNR
               AND BBEU.EUAFPO = AFPO.APAFPO
               AND BBEU.EUBEJJ = :AEBEJJ
               AND BBEU.EUBENR = :AEBENR
               AND BBEU.EUBEPO = :AEBEPO);

         EXEC SQL OPEN AFPOC1;

       ENDSR;

       //*************************************************************************
       //**  Verarbeiten AFPOC1                                                ***
       //*************************************************************************
       BEGSR V1AFPO;

         SQLCOD = *ZERO;
         DOW SQLCOD >= *ZERO AND  SQLCOD < 100 ;

           EXEC SQL FETCH NEXT FROM AFPOC1 INTO :AFPO;
           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           KYTUTE = APTENR;
           KYTUME = APMEIN;
           WKV1V2 = APKMMG;
           EXSR VTEUF;
           R1TRNDNU01 += WKV1V2;

         ENDDO;

         EXEC SQL CLOSE AFPOC1;

       ENDSR;

       //*************************************************************************
       //**  Selektieren AFPO-Sätze mit dem Artikel aus WE, die keiner          **
       //**  Bestellung zugeordnet sind (SQL-Cursor ADPOC2)                     **
       //*************************************************************************
       BEGSR O2AFPO;

         EXEC SQL
         DECLARE AFPOC2 CURSOR FOR SELECT * FROM AFPO
         WHERE APFIRM = :DAFIRM AND APAFST < '20'
               AND APKMTE < :WKUDAT
               AND APTENR = :AETENR
               AND NOT EXISTS(SELECT BBEU.EUFIRM FROM BBEU
               WHERE BBEU.EUFIRM = AFPO.APFIRM
               AND BBEU.EUVPKZ = 'V'
               AND BBEU.EUAFJJ = AFPO.APAFJJ
               AND BBEU.EUAFNR = AFPO.APAFNR
               AND BBEU.EUAFPO = AFPO.APAFPO);

         EXEC SQL OPEN AFPOC2;

       ENDSR;

       //*************************************************************************
       //**  Verarbeiten AFPOC2                                                ***
       //*************************************************************************
       BEGSR V2AFPO;

         SQLCOD = *ZERO;
         DOW SQLCOD >= *ZERO AND  SQLCOD < 100 ;

           EXEC SQL FETCH NEXT FROM AFPOC2 INTO :AFPO;
           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           KYTUTE = APTENR;
           KYTUME = APMEIN;
           WKV1V2 = APKMMG;
           EXSR VTEUF;
           R1TRNDNU01 += WKV1V2;

         ENDDO;

         EXEC SQL CLOSE AFPOC2;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHBWAE
      /COPY QCPYSRC,CHTEUF
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,VTEUF
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
