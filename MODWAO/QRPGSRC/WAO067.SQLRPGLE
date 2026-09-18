     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2018')
      //*************************************************************************
      /TITLE  Ermittlung/Ausgabe Planartikel
      //*************************************************************************
      //  Copyright 2018 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 09./10.07.2018 DOMETIC Projekt 14166-01
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //  Das Programm liest alle Artikel der Firma '01' mit TETART <> '3',
      //  ermittelt zu diesen anhand deren Ident-Status bzw. Ersatz-ID-Nummer
      //  unter Berücksichtigung des TEEW-Kennzeichens TEEWTEAK "Artikel-Aktuell"
      //  eine Plan-Artikel-Nr  und gibt die Ausgagangs-Artikel-Nr als "Artikel-Nr"
      //  und die Plan-Artikel-Nr als "Plan-Artikel-Nr" in die Excel-Datei
      //  Planartikel.xlsx aus
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D ERTE            S                   DIM(999) LIKE(TEERTE) INZ

      //*************************************************************************
      //**  Konstantendefinition                                              ***
      //*************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D TEEW          E DS                  INZ

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

     D EXINIT        E DS                  INZ
     D RTINIT        E DS                  INZ

     D EXTREND       E DS

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXEXPO04

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
     D I1              S              3S 0
     D I2              S              3S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D WKKOPF          S              1
     D WKENVI          S              4
     D WKPATH          S            256
     D WKSTMT          S           1000    VARYING
     D EXTRNDTENR      S                   LIKE(TETENR)
     D WKTEILTENR      S                   LIKE(TETENR)
     D WKTEEWPLTE      S                   LIKE(TEEWTENR)
     D WKERTE          S                   LIKE(TEERTE)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)

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
      // Program name: C_TREXPO04
      // Purpose:
      // Returns:
      // Parameter:      #EXEXPO04
      //--------------------------------------------------
     D C_TREXPO04      PR                  EXTPGM('TREXPO04')
     D  #EXEXPO04                          LIKEDS(EXEXPO04)

      //--------------------------------------------------
      // Program name: C_TRINIT
      // Purpose:
      // Returns:
      // Parameter:      #EXINIT
      // Parameter:      #RTINIT
      //--------------------------------------------------
     D C_TRINIT...
     D                 PR                  EXTPGM('TRINIT')
     D  #EXINIT                            LIKEDS(EXINIT)
     D  #RTINIT                            LIKEDS(RTINIT)

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

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       EXSR OTEIL;
       EXSR VTEIL;

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

       ENDSR;

       //*************************************************************************
       //**  Übernahme Kommunikationsparameter EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR EXDATA;
         CLEAR RTDATA;
         EXDATAFILE = 'EXTREND';
         EXDATADATA = EXTREND;
         C_INZDATASTR(EXDATA:RTDATA);
         EXTREND = RTDATADATA;

         EXTRNDTENR = %SUBST(EXTRNDKEYB:01);

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

         CLEAR EXINIT;
         CLEAR RTINIT;
         EXINITPGST = 'ERINIT';
         EXINITMSGA = 'FIR';
         EXINITMSGN = '0016';
         C_TRINIT(EXINIT:RTINIT);
         WKENVI = RTINITWERT;

         WKPATH = '/trend/' + %TRIM(WKENVI)
         + '/imko/plandaten/Planartikel.xlsx';
         //+ '/imko/plandaten/Planartikel.xls';


       ENDSR;

       //*************************************************************************
       //**  Öffnen SQL-Cursor TEILC1 zur Selktion der TEIL-Sätze              ***
       //*************************************************************************
       BEGSR OTEIL;

         WKSTMT = 'SELECT * FROM TEIL, TEEW'
         + ' WHERE TEIL.TEFIRM = ''01'' AND TEIL.TETART <> ''3''';

         IF EXTRNDTENR <> *BLANK;
           IF %SCAN(WCTRD:EXTRNDTENR) = *ZERO;
             WKSTMT += ' AND TEIL.TETENR = ''' + EXTRNDTENR + '''';
           ELSE;
             WKSTMT += ' AND TRIM(TEIL.TETENR) LIKE '''
             + %TRIMR(%XLATE(WCTRD:WCSQL:EXTRNDTENR)) + '''';
           ENDIF;
         ENDIF;

         WKSTMT += ' AND TEEW.TEEWFIRM = TEIL.TEFIRM'
         + ' AND TEEW.TEEWTENR = TEIL.TETENR'
         + ' ORDER BY TEIL.TEFIRM, TEIL.TETENR'
         + ' FOR FETCH ONLY';

         EXEC SQL PREPARE SQTEIL FROM :WKSTMT;

         EXEC SQL DECLARE TEILC1 CURSOR FOR SQTEIL;

         EXEC SQL OPEN TEILC1;

       ENDSR;

       //*************************************************************************
       //**  Verarbeiten selektierte TEIL-Sätze                                ***
       //*************************************************************************
       BEGSR VTEIL;

         WKKOPF = *OFF;

         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;

           EXEC SQL FETCH NEXT FROM TEILC1 INTO :TEIL, :TEEW;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           WKTEILTENR = TETENR;
           WKTEEWPLTE = *BLANK;

           IF TEEWTEAK = '1';
             EXSR VTEAKAKTI;    // Verarbeitung für Artikel mit TEEWTEAK "Artikel-Aktuell" = *ON
           ELSE;
             EXSR VTEAKIAKT;    // Verarbeitung für Artikel mit TEEWTEAK "Artikel-Aktuell" = *OFF
           ENDIF;

           IF WKTEEWPLTE <> *BLANK;
             IF WKKOPF = *OFF;
               EXSR VKOPF;
               WKKOPF = *ON;
             ENDIF;

             EXSR VZEILE;
           ENDIF;

         ENDDO;

         IF WKKOPF = *ON;
           RESET EXEXPO04;
           EXEXPO04.PGST = 'AUTOFT';
           C_TREXPO04(EXEXPO04);

           RESET EXEXPO04;
           EXEXPO04.PGST = 'WRITE';
           C_TREXPO04(EXEXPO04);
         ENDIF;

         EXEC SQL CLOSE TEILC1;

       ENDSR;

       //************************************************************************
       //**  Verarbeitung für Artikel mit TEEWTEAK "Artikel-Aktuell" = *ON     **
       //************************************************************************
       BEGSR VTEAKAKTI;

         IF TEERTE = *BLANK
           OR TETEST <> '90';
           WKTEEWPLTE = WKTEILTENR;
         ELSE;
           EXSR EERTEAKTI;
           WKTEEWPLTE = WKERTE;
         ENDIF;

       ENDSR;

       //************************************************************************
       //**  Ermitteln der 1. Ersatz-ID-Nr mit TETEST <> '90'                  **
       //**  für den gerade gelesenen Artikel                                  **
       //************************************************************************
       BEGSR EERTEAKTI;

         ERTE = *BLANK;
         ERTE(01) = TETENR;

         WKERTE = *BLANK;

         DOW WKERTE = *BLANK;
           KYTEFI = TEFIRM;
           KYTENR = TEERTE;
           CHIDS = '01C';
           EXSR CHTEIL;
           IF WKFENR <> *ZERO;
             LEAVE;
           ENDIF;

           I1 =  %LOOKUP(TETENR:ERTE);
           IF I1 > *ZERO;
             *IN98 = *ON;
           ELSE;
             *IN98 = *OFF;
           ENDIF;
           IF I1 = *ZERO;
             I1 =  %LOOKUP(*BLANK:ERTE);
             IF I1 > *ZERO;
               ERTE(I1) = TETENR;
             ENDIF;
           ENDIF;

           SELECT;

           WHEN TETEST <> '90';
             WKERTE = TETENR;
             LEAVE;

           WHEN TEERTE = *BLANK;  // Kein weiterer Ersatzartikel vorhanden
             LEAVE;

           WHEN TEERTE <> *BLANK   // Ersatzartikel vorhanden, der Artikel wurde aber schon
             AND *IN98 = *ON;     // mal aufgelöst => In-sich-Verwendung
             LEAVE;

           ENDSL;
         ENDDO;

       ENDSR;

       //************************************************************************
       //**  Verarbeitung für Artikel mit TEEWTEAK "Artikel-Aktuell" = *OFF    **
       //************************************************************************
       BEGSR VTEAKIAKT;

         SELECT;

         WHEN TEERTE = *BLANK;
           WKTEEWPLTE = WKTEILTENR;

         WHEN TETEST = '01';
           WKTEEWPLTE = TEERTE;

           KYTEFI = TEFIRM;
           KYTENR = TEERTE;
           CHIDS = '01C';
           EXSR CHTEIL;
           IF TETENR = '90';
             WKTEEWPLTE = WKTEILTENR;
           ENDIF;

         WHEN TETEST = '90';
           EXSR EERTEIAKT;
           WKTEEWPLTE = WKERTE;

         OTHER;                       // Der Ausgangs-Artikel hat weder den Status '01' noch '90'
           WKTEEWPLTE = WKTEILTENR;

         ENDSL;

       ENDSR;

       //************************************************************************
       //**  Ermitteln der Ersatz-ID-Nr ohne weitere Ersatz-ID-Nr, um diese    **
       //**  dann in den Plan-Artikel zu überbehmnen                           **
       //************************************************************************
       BEGSR EERTEIAKT;

         ERTE = *BLANK;
         ERTE(01) = TETENR;

         WKERTE = *BLANK;

         DOW TEERTE <> *BLANK;
           KYTEFI = TEFIRM;
           KYTENR = TEERTE;
           CHIDS = '01C';
           EXSR CHTEIL;
           IF WKFENR <> *ZERO;
             LEAVE;
           ENDIF;

           I1 =  %LOOKUP(TETENR:ERTE);
           IF I1 > *ZERO;
             *IN98 = *ON;
           ELSE;
             *IN98 = *OFF;
           ENDIF;
           IF I1 = *ZERO;
             I1 =  %LOOKUP(*BLANK:ERTE);
             IF I1 > *ZERO;
               ERTE(I1) = TETENR;
             ENDIF;
           ENDIF;

           SELECT;

           // Den letzten (oder ersten) Ersatz-Artikel mit TETEST <> '89' merken
           // laut IK ist dies aber so nicht gewünscht, deshalb deaktiviert
           //WHEN TETEST <> '90';
             //WKERTE = TETENR;
             //LEAVE;            // <== um den ERSTEN Ersatzartikel mit TETEST <> '90' zu ermitteln

           WHEN TEERTE = *BLANK;  // Kein weiterer Ersatzartikel vorhanden
             WKERTE = TETENR;
             LEAVE;

           WHEN TEERTE <> *BLANK  // Ersatzartikel vorhanden, der Artikel wurde aber schon
             AND *IN98 = *ON;     // mal aufgelöst => In-sich-Verwendung
             LEAVE;

           WHEN TEERTE <> *BLANK; // Ersatzartikel vorhanden, der Artikel wurde aber schon
             WKERTE = TETENR;

           ENDSL;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Erstellen Excel-Tabelle Überschrift                               ***
       //*************************************************************************
       BEGSR VKOPF;

         RESET EXEXPO04;
         EXEXPO04.PGST = 'CREATE';
         EXEXPO04.FILE = WKPATH;
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDSHE';
         EXEXPO04.SHEET = 'PLANARTIKEL';
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDROW';
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDCEL';
         EXEXPO04.VALUE = 'Artikel-Nr';
         EXEXPO04.CELL.C_align = 'C';
         EXEXPO04.CELL.C_size = 16;
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDCEL';
         EXEXPO04.VALUE = 'Plan-Artikel-Nr';
         EXEXPO04.CELL.C_align = 'C';
         EXEXPO04.CELL.C_size = 16;
         C_TREXPO04(EXEXPO04);

       ENDSR;

       //*************************************************************************
       //**  Erstellen neu Zeile der Excel-Tabelle                             ***
       //*************************************************************************
       BEGSR VZEILE;

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDROW';
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDCEL';
         EXEXPO04.VALUE = WKTEILTENR;
         C_TREXPO04(EXEXPO04);

         RESET EXEXPO04;
         EXEXPO04.PGST = 'ADDCEL';
         EXEXPO04.VALUE = WKTEEWPLTE;
         C_TREXPO04(EXEXPO04);

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameter                                               ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRPA
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
