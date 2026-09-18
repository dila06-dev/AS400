     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
      //*************************************************************************
      /TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2017 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 04.12.2017 WAECO Projekt 13482 IC-Abwicklung Kopieren Bewegungstexte
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  Dateien                                                           ***
      //*************************************************************************
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXAFPO        E DS                  INZ
     D RTAFPO        E DS                  INZ

     D EXTXBE        E DS
     D E1TXBE          DS                  INZ LIKEDS(EXTXBE)

      //*************************************************************************
      //**  interne Datenstruktur                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  Datenstationsarbeitsbereich                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  Programmstatus Datenstruktur                                      ***
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
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D WKIN30          S              1
     D WKIN31          S              1
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D EXTRNDLFNR      S             10
     D EXTRNDVSBD      S              3
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
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

      //--------------------------------------------------
      // Program name: C_T2AFPO
      // Purpose:
      // Returns:
      // Parameter:      #EXAFPO
      // Parameter:      #RTAFPO
      //--------------------------------------------------
     D C_T2AFPO...
     D                 PR                  EXTPGM('T2AFPO')
     D  #EXAFPO                            LIKEDS(EXAFPO)
     D  #RTAFPO                            LIKEDS(RTAFPO)

       //*************************************************************************
       //**  Programmstart                                                     ***
       //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTXBE

      /FREE
       EXSR UEBTXBE;

       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       EXSR EXJOBA;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;
       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       IF RTAFPOBZAN <> *BLANK;
         EXSR LTXBE;
         EXSR KTXBE;
       ENDIF;

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

         KYTAFI = DAFIRM;  // TRPA

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTXBE;

         CLEAR EXDATA;
         EXDATAFILE = 'EXTXBE';
         EXDATADATA = EXTXBE;
         C_INZDATASTR(EXDATA:RTDATA);

         E1TXBE = EXTXBE;

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

         CLEAR EXAFPO;
         EXAFPOPGST = 'PBBEU ';
         EXAFPOAFJJ = E1TXBE.EXTBJHJJ;
         EXAFPOAFNR = E1TXBE.EXTBAFNR;
         EXAFPOAFPO = E1TXBE.EXTBPOSI;
         C_T2AFPO(EXAFPO:RTAFPO);

       ENDSR;

       //*************************************************************************
       //**  Löschen Bewegungstexte                                            ***
       //*************************************************************************
       BEGSR LTXBE;

         CLEAR EXTXBE;
         EXTBCALL = E1TXBE.EXTBCALL;
         EXTBAUSW = E1TXBE.EXTBAUSW;
         EXTBPGCD = '4     ';
         EXTBFIRM = RTAFPOBZAF;
         EXTBTXAR = E1TXBE.EXTBTXAR;
         EXTBJHJJ = RTAFPOBZAJ;
         EXTBAFNR = RTAFPOBZAN;
         IF E1TXBE.EXTBPOSI <> *ZERO;
           EXTBPOSI = RTAFPOBZAP;
         ENDIF;
         EXTBPROG = E1TXBE.EXTBPROG;

         KOM = *BLANK;
         #CUEBE = *BLANK;
         #CPGST = *BLANK;
         EXSR TRTX55;

       ENDSR;

       //*************************************************************************
       //**  Kopieren Bewegungstexte                                           ***
       //*************************************************************************
       BEGSR KTXBE;

         CLEAR EXTXBE;
         EXTBCALL = E1TXBE.EXTBCALL;
         EXTBAUSW = E1TXBE.EXTBAUSW;
         EXTBPGCD = '3     ';
         EXTBFIRM = E1TXBE.EXTBFIRM;
         EXTBTXAR = E1TXBE.EXTBTXAR;
         EXTBJHJJ = E1TXBE.EXTBJHJJ;
         EXTBAFNR = E1TXBE.EXTBAFNR;
         EXTBPOSI = E1TXBE.EXTBPOSI;
         EXTBPROG = E1TXBE.EXTBPROG;

         EXTBNFIR = RTAFPOBZAF;
         EXTBNTXA = E1TXBE.EXTBTXAR;
         EXTBNJHJ = RTAFPOBZAJ;
         EXTBNAFN = RTAFPOBZAN;
         IF E1TXBE.EXTBPOSI <> *ZERO;
           EXTBNPOS = RTAFPOBZAP;
         ENDIF;

         KOM = *BLANK;
         #CUEBE = *BLANK;
         #CPGST = *BLANK;
         EXSR TRTX55;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRTX55

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
