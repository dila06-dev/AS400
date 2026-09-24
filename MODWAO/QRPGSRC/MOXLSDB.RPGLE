     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
      //*************************************************************************
      /TITLE  XML-Ausgabe Stammtext Sicherheitsdatenblatt
      //*************************************************************************
      //  Copyright 2016 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 10.08.2016 Projekt 12646
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Dieses Programm dient zur XML-Ausgabe eines SDB-Stammtext
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ

     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ

     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ

     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ

     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TXST          E DS                  INZ
     D KYTXST        E DS                  INZ

     D WAOU          E DS                  INZ
     D KYWAOU        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ

     D EXTREND       E DS
     D RTTREND       E DS                  INZ

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
      //**  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
      //*************************************************************************
     D/COPY QCPYSRC,TRSPOL

      //*************************************************************************
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKRTCD          S              1
     D WKFENR          S              4
     D WKI000          S              1
     D WKTXST          S              1
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D WKDRFLPGNA      S                   LIKE(EXDRFLPGNA)
     D WKDRFLSPCD      S                   LIKE(EXDRFLSPCD)
     D WKDRFLKOPI      S                   LIKE(EXDRFLKOPI)
     D WKDRFLDANA      S                   LIKE(EXDRFLDANA)
     D WKDRFLJAHR      S                   LIKE(EXDRFLJAHR)
     D WKDRFLNMKR      S                   LIKE(EXDRFLNMKR)
     D WKDRFLFIRM      S                   LIKE(EXDRFLFIRM)
     D WKDRFLWKNR      S                   LIKE(EXDRFLWKNR)
     D WKDRFLKDLI      S                   LIKE(EXDRFLKDLI)
     D WKDRFLBLGA      S                   LIKE(EXDRFLBLGA)
     D WKDRFLSABE      S                   LIKE(EXDRFLSABE)
     D WKDRFLLDNR      S                   LIKE(EXDRFLLDNR)
     D WKLAND          S                   LIKE(ADLAND)
     D WKVSLD          S                   LIKE(ADLAND)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_DRTXSTCL
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_DRTXSTCL...
     D                 PR                  EXTPGM('DRTXSTCL')
     D  #EXTR02                            LIKEDS(EXTR02)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXXMLDRFL
     C                   PARM                    EXTREND

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       SELECT;
       WHEN %SUBST(WKDRFLPGNA:1:6) = 'XLAFKO';
         EXSR XLAFPO;
       WHEN %SUBST(WKDRFLPGNA:1:6) = 'XLAFLK';
         EXSR XLAFLP;
       WHEN WKDRFLPGNA = 'XLAFRK01';
         EXSR XLAFLP;
       WHEN WKDRFLPGNA = 'XLAFRK02';
         EXSR XLAFLP26;
       ENDSL;

       RETURN;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;
         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         KYADFI = DAFIRM;     // AFAD
         KYAKFI = DAFIRM;     // AFKO
         KYALFI = DAFIRM;     // AFLP
         KYAPFI = DAFIRM;     // AFPO
         KYTEEWFIRM = DAFIRM; // TEEW
         KYTAFI = DAFIRM;     // TRPA
         KYTTFI = DAFIRM;     // TXST
         KYWAOUFIRM = DAFIRM; // WAOU
       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;
         WKDRFLPGNA = EXDRFLPGNA;
         WKDRFLSPCD = EXDRFLSPCD;
         WKDRFLKOPI = EXDRFLKOPI;

         WKDRFLDANA = EXDRFLDANA;
         WKDRFLJAHR = EXDRFLJAHR;
         WKDRFLNMKR = EXDRFLNMKR;
         WKDRFLFIRM = EXDRFLFIRM;
         WKDRFLWKNR = EXDRFLWKNR;
         WKDRFLKDLI = EXDRFLKDLI;
         WKDRFLBLGA = EXDRFLBLGA;
         WKDRFLSABE = EXDRFLSABE;
         WKDRFLLDNR = EXDRFLLDNR;

         CLEAR RTTREND;
         RTTRNDFENR = '0000';
       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;
         WKTXST = *OFF;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS KUNDEN-AUFTRAGSPOSITION                       ***
       //*************************************************************************
       BEGSR XLAFPO;
         KYAFPO = EXTRNDKEYB;
         CHIDS = '01+';
         EXSR CHAFPO;
         DOW CHI(5) = 'J'
           AND APFIRM = KYAPFI
           AND APAFJJ = KYAPJH
           AND APAFNR = KYAPAF;
           // Ermitteln Land aus der Versandadresse
           IF APFIRM <> ADFIRM
             OR APAFJJ <> ADAFJJ
             OR APAFNR <> ADAFNR;
             KYADJH = APAFJJ;
             KYADAF = APAFNR;
             EXSR XLAFAD;
           ENDIF;

           // Ermitteln SDB-Pflicht
           KYTEEWTENR = APTENR;
           EXSR XLTEEW;
           IF WKTXST = *ON;
             LEAVESR;
           ENDIF;

           CHIDS = '01R';
           EXSR CHAFPO;
         ENDDO;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS KD-AUFTRAG LIEFERPOSITION                     ***
       //*************************************************************************
       BEGSR XLAFLP;
         KYAFLP = EXTRNDKEYB;
         CHIDS = '05+';
         EXSR CHAFLP;
         DOW CHI(5) = 'J'
           AND ALFIRM = KYALFI
           AND ALLIJJ = KYALLJ
           AND ALLINR = KYALLI;
           // Ermitteln Land aus der Versandadresse
           IF ALFIRM <> ADFIRM
             OR ALAFJJ <> ADAFJJ
             OR ALAFNR <> ADAFNR;
             KYADJH = ALAFJJ;
             KYADAF = ALAFNR;
             EXSR XLAFAD;
           ENDIF;

           // Ermitteln SDB-Pflicht
           KYTEEWTENR = ALTENR;
           EXSR XLTEEW;
           IF WKTXST = *ON;
             LEAVESR;
           ENDIF;

           CHIDS = '05R';
           EXSR CHAFLP;
         ENDDO;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS KD-AUFTRAG LIEFERPOSITION                     ***
       //*************************************************************************
       BEGSR XLAFLP26;
         KYAFLP = EXTRNDKEYB;
         CHIDS = '26+';
         EXSR CHAFLP;
         DOW CHI(5) = 'J'
           AND ALFIRM = KYALFI
           AND ALREDA = KYALRD
           AND ALRGJJ = KYALRJ
           AND ALRGNR = KYALRN;
           // Ermitteln Land aus der Versandadresse
           IF ALFIRM <> ADFIRM
             OR ALAFJJ <> ADAFJJ
             OR ALAFNR <> ADAFNR;
             KYADJH = ALAFJJ;
             KYADAF = ALAFNR;
             EXSR XLAFAD;
           ENDIF;

           // Ermitteln SDB-Pflicht
           KYTEEWTENR = ALTENR;
           EXSR XLTEEW;
           IF WKTXST = *ON;
             LEAVESR;
           ENDIF;

           CHIDS = '26R';
           EXSR CHAFLP;
         ENDDO;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS KD-AUFTRAG ADRESSEN                           ***
       //*************************************************************************
       BEGSR XLAFAD;
         KYADAA = 'ADAG';
         CHIDS = '01C';
         EXSR CHAFAD;
         WKLAND = ADLAND;
         WKVSLD = ADLAND;

         KYADAA = 'ADVS';
         CHIDS = '01C';
         EXSR CHAFAD;
         IF CHI(5) = 'J';
           WKVSLD = ADLAND;
         ENDIF;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS IDENT-STAMM ERWEITERUNG                       ***
       //*************************************************************************
       BEGSR XLTEEW;
         // Ermitteln Kz "SDB-Pflicht"
         CHIDS = '01C';
         EXSR CHTEEW;

         IF TEEWSDBP = *ON;
           // Prüfen Sicherheitsdatenblätter pro Land, Artikel
           KYWAOUTENR = TEEWTENR;
           KYWAOULAND = WKVSLD;
           CHIDS = '01C';
           EXSR CHWAOU;
           IF CHI(5) = 'N';
             // XML-Ausgabe Stammtext SDB
             EXSR XLTXST;
           ENDIF;
         ENDIF;
       ENDSR;
       //*************************************************************************
       //**  AUSGABE STAMMTEXT SDB                                             ***
       //*************************************************************************
       BEGSR XLTXST;

         KYTTTC = 'TRTX09';
         KYTTSP = WKDRFLSPCD;
         KYTTUC = 'SDB';
         CHIDS = '01+';
         EXSR CHTXST;
         DOW CHI(5) = 'J'
           AND TTTCDE = KYTTTC
           AND TTKDLI = KYTTKL
           AND TTTENR = KYTTTE
           AND TTA115 = KYTTA1
           AND TTA215 = KYTTA2
           AND TTSPCD = KYTTSP
           AND TTUCDE = KYTTUC;
           WKTXST = *ON;

           IF TTLFZN = *ZERO;
             WKDRFLPGST = 'ADDBLOC';
           ELSE;
             WKDRFLPGST = 'ADDFIEL';
           ENDIF;
           WKDRFLBLOC = 'MODWAOSDB   ';
           EXSR ERAUFRDRFL;

           CHIDS = '01R';
           EXSR CHTXST;
         ENDDO;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;
       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************
       BEGSR ERAUFRDRFL;
         EXSR INIDRFL;

         EXDRFLPGNA = WKDRFLPGNA;
         EXDRFLPGST = WKDRFLPGST;
         EXDRFLBLOC = WKDRFLBLOC;
         EXDRFLSPCD = WKDRFLSPCD;
         EXDRFLKOPI = WKDRFLKOPI;

         EXDRFLDANA = WKDRFLDANA;
         EXDRFLJAHR = WKDRFLJAHR;
         EXDRFLNMKR = WKDRFLNMKR;
         EXDRFLFIRM = WKDRFLFIRM;
         EXDRFLWKNR = WKDRFLWKNR;
         EXDRFLKDLI = WKDRFLKDLI;
         EXDRFLBLGA = WKDRFLBLGA;
         EXDRFLSABE = WKDRFLSABE;
         EXDRFLLDNR = WKDRFLLDNR;

         SELECT;
         WHEN EXDRFLBLOC = 'MODWAOSDB   ';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'TXST    ';
           EXDRFLDATA = TXST;
         ENDSL;

         EXSR ERDRFL;
       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTXST
     C/COPY QCPYSRC,CHWAOU
     C/COPY QCPYSRC,ERDRFL
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
