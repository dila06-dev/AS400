     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2014')
      //*************************************************************************
      /TITLE  XML-Ausgabe Modifikationen
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 26.08.2015 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: PH XX.XX.XXXX
      //*************************************************************************
      //  Dieses Programm erstellt die XML-Blöcke der Modifikationen zum
      //  Wareneingansschein. Es erhält die XML- sowie Schlüsseldaten aus dem
      //  aufrufenden Programm XLBWAE01. XML-Blöcke werden direkt im
      //  Hauptspeicher hinzugefügt
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BWAE          E DS
     D TEIL          E DS

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
     D RTTREND       E DS                  INZ

     D E1TREND       E DS
     D R1TREND       E DS                  INZ

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
     D WKC001          S              1    INZ
     D WKN010          S              1S 0 INZ
     D ##CHI           S              8    INZ
     D ##RTCD          S              1    INZ
     D ##PGST          S              1    INZ
     D WKFENR          S              4    INZ
     D WKTRTP          S              1    INZ
     D WKTRPA          S              1    INZ
     D WKIOKZ          S              1    INZ
     D WKI000          S              1    INZ
     D PTWENRBARC      S              9    INZ
     D I1              S              3S 0 INZ
     D I2              S              3S 0 INZ
     D I3              S              3S 0 INZ
     D WKUSER          S                   INZ LIKE(DAUSER)
     D WKPROG          S                   INZ LIKE(DAPROG)
     D WKBIBL          S                   INZ LIKE(DABIBL)
     D PCPGST          S                   INZ LIKE(#CPGST)
     D WKPGST          S                   INZ LIKE(#CPGST)
     D PCRTCD          S                   INZ LIKE(#CRTCD)
     D WKDRFLPGNA      S                   INZ LIKE(EXDRFLPGNA)
     D WKDRFLKOPI      S                   INZ LIKE(EXDRFLKOPI)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************

     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    E1TREND
     C                   PARM                    BWAE
     C                   PARM                    TEIL
     C                   PARM                    EXXMLDRFL

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;                                                           // ANFANGROUTINE
       ENDIF;

       IF WKTRPA <> *ON;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       SELECT;
       WHEN EXDRFLBLOC = 'MODWAOHEADER';
         EXSR XLKOPF;
       ENDSL;

       RETURN;
       // *INLR = *ON;

       //*************************************************************************
       //**  UEBERNAHME EXTREND                                                ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         WKDRFLPGNA = EXDRFLPGNA;
         WKDRFLKOPI = EXDRFLKOPI;

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
       //**  AUSGABE KOPF                                                      ***
       //*************************************************************************
       BEGSR XLKOPF;

         PTWENRBARC = 'W' + %SUBST(%EDITC(AEWEJJ:'X'):3:2) + AEWENR;

         WKDRFLPGST = 'ADDBLOC';
         WKDRFLBLOC = 'MODWAOHEADER';
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
         EXDRFLSPCD = DASPCD;
         EXDRFLKOPI = WKDRFLKOPI;

         EXDRFLDANA = 'BWAE';
         EXDRFLJAHR = AEWEJJ;
         EXDRFLNMKR = AEWENR;
         EXDRFLFIRM = DAFIRM;
         EXDRFLWKNR = AEWKNR;
         EXDRFLKDLI = AELFNR;
         EXDRFLSABE = AESABE;

         SELECT;

         WHEN EXDRFLBLOC = 'MODWAOHEADER';
           %OCCUR(EXXMLALPH) = 1;
           EXDRFLALPF = '##WENRBARC';
           EXDRFLALPH = PTWENRBARC;

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
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,ERDRFL
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
