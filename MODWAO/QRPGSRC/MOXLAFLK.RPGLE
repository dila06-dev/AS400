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
     D AFLK          E DS
     D AFLP          E DS
     D ALGB          E DS
     D KUND          E DS
     D KPIF          E DS

     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ

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

     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ

     D EXTREND       E DS
     D E1TREND       E DS

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
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKPROG          S                   LIKE(DAPROG)
     D WKBIBL          S                   LIKE(DABIBL)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D ##TRNDLIJJ      S                   LIKE(ALLIJJ)
     D ##TRNDLINR      S                   LIKE(ALLINR)
     D WKLAND          S                   LIKE(EXDRFLLDNR)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    E1TREND
     C                   PARM                    AFLK
     C                   PARM                    AFLP
     C                   PARM                    ALGB
     C                   PARM                    KUND
     C                   PARM                    KPIF
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
       WHEN EXDRFLBLOC = 'MODWAOTEEW  ';
         EXSR XLAFLP;
       ENDSL;

       WKFIRM = DAFIRM;
       RETURN;
       *INLR = *ON;

       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         MONITOR;
           ##TRNDLIJJ = %INT(%SUBST(EXTRNDKEYB:01:04));
         ON-ERROR *PROGRAM;
           ##TRNDLIJJ = *ZERO;
           EXSR RMVMONMSG;
         ENDMON;
         ##TRNDLINR = %SUBST(EXTRNDKEYB:05);

         KUNDSPCD = %SUBST(EXTRNDDATE:80);

         WKLAND = EXDRFLLDNR;

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
       //**  AUSGABE AFLP                                                      ***
       //*************************************************************************
       BEGSR XLAFLP;

         KYTEEWTENR = ALTENR;
         CHIDS = '01C';
         EXSR CHTEEW;

         WKDRFLPGST = 'ADDBLOC';
         WKDRFLBLOC = 'MODWAOTEEW  ';
         EXSR ERAUFRDRFL;

       ENDSR;


       //*************************************************************************
       //**  XML Erzeugen                                                      ***
       //*************************************************************************
       BEGSR ERAUFRDRFL;

         EXSR INIDRFL;

         EXDRFLPGST = WKDRFLPGST;
         EXDRFLBLOC = WKDRFLBLOC;
         EXDRFLSPCD = KUNDSPCD;

         EXDRFLDANA = 'AFLK';
         EXDRFLJAHR = ##TRNDLIJJ;
         EXDRFLNMKR = ##TRNDLINR;
         EXDRFLFIRM = DAFIRM;
         EXDRFLWKNR = ALWKNR;
         EXDRFLKDLI = KLKDNR;
         EXDRFLBLGA = KLAFAT;
         EXDRFLSABE = ALSABE;
         EXDRFLLDNR = WKLAND;

         SELECT;
         WHEN EXDRFLBLOC = 'MODWAOTEEW  ';
           %OCCUR(EXXMLFILE) = 1;
           EXDRFLFILE = 'TEEW    ';
           EXDRFLDATA = TEEW;
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
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,ERDRFL
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
