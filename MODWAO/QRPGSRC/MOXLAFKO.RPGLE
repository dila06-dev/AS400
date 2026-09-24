     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2021')
      //*************************************************************************
      /TITLE  XML-Ausgabe Modifikationen
      //*************************************************************************
      //  Copyright 2023 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: ZG 26.06.2023 DOMETIC Projekt 220505-08.
      //            Erweiterung der Druckprogramme um die Ausgabe der Datei TEEW auf Positionsebene.
      //  Änderung: PH 08.11.2024 DOMETIC Case #03853367. Die Ausgabe der F-Gas Informationen.
      //*************************************************************************
      //  Dieses Programm erstellt die XML-Blöcke der Modifikationen zum
      //  Lieferschein. Es erhält die XML- sowie Schlüsseldaten aus dem
      //  aufrufenden Programm XLAFRK0x. XML-Blöcke werden direkt im
      //  Hauptspeicher hinzugefügt
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFKO          E DS
     D AFPO          E DS
     D KUND          E DS

     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D FGTEEWTENR      S                   LIKE(TEEWTENR) INZ DIM(999)
     D FGTEEWBSMG      S                   LIKE(APBSMG) INZ DIM(999)

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ

     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ

     D E1XLST        E DS                  INZ

      //*************************************************************************
      //**     Konstantendefinition                                           ***
      //*************************************************************************

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
     D KUNDSPCD        S              1
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKFENR          S              4
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKIOKZ          S              1
     D WKI000          S              1
     D I1              S              3S 0
     D PTTEEWTRFQ      S             11S 3
     D PTTEEWTOTO      S             11S 3
     D SUTEEWTRFQ      S             11S 3
     D SUTEEWTOTO      S             11S 3
     D TXTEEWRFTY      S                   LIKE(TPTTXT)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPROG          S                   LIKE(DAPROG)
     D WKBIBL          S                   LIKE(DABIBL)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D WKDRFLPGNA      S                   LIKE(EXDRFLPGNA)
     D WKDRFLKOPI      S                   LIKE(EXDRFLKOPI)
     D WKDRFLSABE      S                   LIKE(EXDRFLSABE)
     D WKDRFLLDNR      S                   LIKE(EXDRFLLDNR)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    AFKO
     C                   PARM                    AFPO
     C                   PARM                    KUND
     C                   PARM                    EXXMLDRFL

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       SELECT;
       WHEN PCPGST = 'INITKO';
         EXSR INITKO;
       WHEN EXDRFLBLOC = 'MODWAOAFPO  ';
         EXSR XLAFPO;
       WHEN EXDRFLBLOC = 'MODWAOFGAS';
         EXSR XLFGAS;
       ENDSL;

       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = #CPGST;
         KUNDSPCD = %SUBST(#CKOMM:80);

         WKDRFLPGNA = EXDRFLPGNA;
         WKDRFLKOPI = EXDRFLKOPI;
         WKDRFLSABE = EXDRFLSABE;
         WKDRFLLDNR = EXDRFLLDNR;

       ENDSR;

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

         KYTEEWFIRM = DAFIRM; // TEEW
         KYTEFI     = DAFIRM; // TEIL
         KYTAFI = DAFIRM;     // TRPA

         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Initialisieren Daten auf Kopf-Ebene                               ***
       //*************************************************************************
       BEGSR INITKO;

         CLEAR FGTEEWTENR;
         CLEAR FGTEEWBSMG;

       ENDSR;

       //*************************************************************************
       //**  AUSGABE AFPO                                                      ***
       //*************************************************************************
       BEGSR XLAFPO;

         KYTEEWTENR = APTENR;
         CHIDS = '01C';
         EXSR CHTEEW;

         WKDRFLPGST = 'ADDBLOC';
         WKDRFLBLOC = 'MODWAOAFPO  ';
         EXSR ERAUFRDRFL;

         // Speichern den Artikel und die Bestellmenge (verdichtet pro Artikel) in Feldgruppen,
         // wenn das TEEW-Kz. "F-Gas Verordnung" für den Artikel aktiv ist.
         // Diese Daten werden für die Ausgabe der F-Gas-bezogenen Informationen aus
         // der TEEW im Fuß benötigt.

         // Kz. "F-Gas Verordnung" ist aktiv
         IF TEEWFGVE = *ON;

           I1 = %LOOKUP(TEEWTENR:FGTEEWTENR);
           IF I1 = *ZERO;
             I1 = %LOOKUP(*BLANK:FGTEEWTENR);
             IF I1 > *ZERO;
               FGTEEWTENR(I1) = TEEWTENR;
               FGTEEWBSMG(I1) = APBSMG;
             ENDIF;
           ELSE;
             FGTEEWBSMG(I1) += APBSMG;
           ENDIF;

         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe F-Gas Informationen im Fuß                                ***
       //*************************************************************************
       BEGSR XLFGAS;

         SUTEEWTRFQ = *ZERO;
         SUTEEWTOTO = *ZERO;

         // Ausgabe F-Gas Informationen
         FOR I1 = 1 TO 999;

           IF FGTEEWTENR(I1) = *BLANK;
             LEAVE;
           ENDIF;

           KYTEEWTENR = FGTEEWTENR(I1);
           CHIDS = '01C';
           EXSR CHTEEW;

           TXTEEWRFTY = *BLANK;
           IF TEEWRFTY <> *BLANK;
             KYTPTA = '$$TEEWRFTY';
             KYTPTC = TEEWRFTY;
             KYTPTF = *ZERO;
             CHIDS = '01C';
             EXSR CHTRTP;
             TXTEEWRFTY = TPTTXT;
           ENDIF;

           KYTENR = FGTEEWTENR(I1);
           KYTEEZ = *BLANK;
           CHIDS  = '01C';
           EXSR CHTEIL;

           EVAL(H) PTTEEWTRFQ = FGTEEWBSMG(I1) * TEEWRFQT / 1000;
           EVAL(H) PTTEEWTOTO = TEEWGWPN * PTTEEWTRFQ / 1000;

           WKDRFLPGST = 'ADDBLOC';
           WKDRFLBLOC = 'MODWAOFGAS  ';
           EXSR ERAUFRDRFL;

           SUTEEWTRFQ += PTTEEWTRFQ;
           SUTEEWTOTO += PTTEEWTOTO;
         ENDFOR;

         // Ausgabe Summenwerte "Total refrigerant qty" und "Total tonnes CO2-eq"
         WKDRFLPGST = 'ADDBLOC';
         WKDRFLBLOC = 'MODWAOSUFGAS  ';
         EXSR ERAUFRDRFL;

       ENDSR;

       //*************************************************************************
       //**  XML Erzeugen                                                      ***
       //*************************************************************************
       BEGSR ERAUFRDRFL;

         EXSR INIDRFL;

         EXDRFLPGNA = WKDRFLPGNA;
         EXDRFLPGST = WKDRFLPGST;
         EXDRFLBLOC = WKDRFLBLOC;
         EXDRFLSPCD = KUNDSPCD;
         EXDRFLKOPI = WKDRFLKOPI;

         EXDRFLDANA = 'AFKO';
         EXDRFLJAHR = AKAFJJ;
         EXDRFLNMKR = AKAFNR;
         EXDRFLFIRM = DAFIRM;
         EXDRFLWKNR = AKWKNR;
         EXDRFLKDLI = AKKDNR;
         EXDRFLBLGA = AKAFAT;
         EXDRFLSABE = WKDRFLSABE;
         EXDRFLLDNR = WKDRFLLDNR;

         SELECT;

         WHEN EXDRFLBLOC = 'MODWAOAFPO  ';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'TEEW    ';
           EXDRFLDATA = TEEW;

         WHEN EXDRFLBLOC = 'MODWAOFGAS  ';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'TEEW    ';
           EXDRFLDATA = TEEW;
           %OCCUR(EXXMLFILE) += 1;
           EXDRFLFILE = 'TEIL    ';
           EXDRFLDATA = TEIL;

           %OCCUR(EXXMLALPH) = 1;
           EXDRFLALPF = 'TXTEEWRFTY';
           EXDRFLALPH = TXTEEWRFTY;

           %OCCUR(EXXMLNUMM) = 1;
           EXDRFLNUMF = '##BSMG';
           EXDRFLNUMM = FGTEEWBSMG(I1);
           %OCCUR(EXXMLNUMM) += 1;
           EXDRFLNUMF = '##TRFQ';
           EXDRFLNUMM = PTTEEWTRFQ;
           %OCCUR(EXXMLNUMM) += 1;
           EXDRFLNUMF = '##TOTO';
           EXDRFLNUMM = PTTEEWTOTO;

         WHEN EXDRFLBLOC = 'MODWAOSUFGAS';
           %OCCUR(EXXMLNUMM) = 1;
           EXDRFLNUMF = '##TRFQ';
           EXDRFLNUMM = SUTEEWTRFQ;
           %OCCUR(EXXMLNUMM) += 1;
           EXDRFLNUMF = '##TOTO';
           EXDRFLNUMM = SUTEEWTOTO;

         ENDSL;

         EXSR ERDRFL;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHTEEW
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,ERDRFL
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
