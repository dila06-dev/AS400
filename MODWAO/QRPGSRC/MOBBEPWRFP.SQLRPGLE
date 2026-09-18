     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2017')
      //*************************************************************************
      /TITLE  Ermittlung Dispobestände Workflow
      //*************************************************************************
      //  Copyright 2017 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 18.05.2017 Projekt 13201
      //  -----------------------------------------------------------------------
      //  Änderung: GS 13.03.2018 Projekt 13201 Auftragsart 45 nicht beücksichtigen
      //  Änderung: GS 06.04.2018 Projekt 13201 KD-Aufträge mit Reservierung (LBRS)
      //            dürfen nicht berücksichtigt werden.
      //  Änderung: GS 29.05.2018 Service, AFPO-Sätze < '90' nicht berücksichtigen
      //*************************************************************************
      //
      //  Das Programm ermittelt die Dispobestände und gibt negative Bestände
      //  zurück
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BBEP          E DS                  INZ
      //
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D DIST          E DS                  INZ
     D KYDIST        E DS                  INZ
      //
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
      //
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
      //
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
      //
     D WKREC           S          10000    BASED(WKREC§)
     D WKREC§          S               *
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXTREND       E DS
     D RTTREND       E DS
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
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
     D WKVFBS          S                   LIKE(DUN134)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D WKOBJN          S             10
     D WKPTRA§         S               *
     D WKPTRB§         S               *
     D WKERMPGMSTAT    S              1
     D WKERMPGMDS      DS
     D  WKERMFILE                    10    DIM(5)
     D  WKERMFILE§                     *   DIM(5)

      //--------------------------------------------------
      // Program name: C_TRVFB1
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRVFB1...
     D                 PR                  EXTPGM('TRVFB1')
     D  #EXTR02                            LIKEDS(EXTR02)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKOBJN
     C                   PARM                    WKPTRA§
     C                   PARM                    WKPTRB§
     C                   PARM                    WKERMPGMSTAT
     C                   PARM                    WKERMPGMDS
      /FREE
       EXSR UEBTREND;
       IN EXTRLD;
         SELECT;
         WHEN WKFIRM <> DAFIRM;
           EXSR ANFANG;
         ENDSL;
       EXSR EXJOBA;
         SELECT;
         WHEN WKFIRM <> DAFIRM;
           EXSR ETRPA;
         ENDSL;
       EXSR VORLAUF;
       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       EXSR VBBEP;
       RETURN;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;
         WKI000 = *ON;
         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

         KYTAFI = DAFIRM;                                                       // TRPA
         KYAKFI = DAFIRM;                                                       // AFKO
         KYAPFI = DAFIRM;                                                       // AFPO
         KYITFI = DAFIRM;                                                       // DIST
         KYKDFI = DAFIRM;                                                       // KUND
         KYLBRSFIRM = DAFIRM;
       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;
         PCPGST = EXTRNDPGST;
         CLEAR RTTREND;
         RTTRNDFENR = '0000';
         WKREC§ = WKPTRA§;
         EXEC SQL
           SET OPTION CLOSQLCSR = *ENDACTGRP;
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
       //**  ERMITELLN BESTÄNDE                                                ***
       //*************************************************************************
       BEGSR VBBEP;

         BBEP = WKREC;

         KYITTE = EPTENR;
         IF WKERMPGMSTAT = *BLANKS;
           CHIDS = '02+';
         ELSE;
           CHIDS = '02R';
         ENDIF;
         DOW 1 = 1;
         EXSR CHDIST;
         IF ITFIRM <> KYITFI OR
            ITTENR <> KYITTE;
           WKERMPGMSTAT = *OFF;
           LEAVESR;
         ENDIF;

         // Nur Kundenaufträge TVA '010' alles andere nicht berücksichtigen
         IF ITBEGR <> '010';
           CHIDS = '02R';
           ITER;
         ENDIF;

         // Auftragsart 45 nicht berücksichtigen
         KYAKJH = ITBGJJ;
         KYAKAF = ITBGNR;
         CHIDS = '01C';
         EXSR CHAFKO;
         IF AKAFAT = '45';
           CHIDS = '02R';
           ITER;
         ENDIF;

         // AFPO-Positionen nur Status < '90'
         KYAPJH = ITBGJJ;
         KYAPAF = ITBGNR;
         KYAPPO = ITBPOS;
         CHIDS = '01C';
         EXSR CHAFPO;
         IF APAFST >= '90';
           CHIDS = '02R';
           ITER;
         ENDIF;

         // Falls eine Reservierung vorhanden ist, Satz nicht berücksichtigen
         KYLBRSAFDN = 'AFPO';
         KYLBRSAFJJ = ITBGJJ;
         KYLBRSAFNR = ITBGNR;
         KYLBRSAFPO = ITBPOS;
         KYLBRSAFUP = *LOVAL;
         CHIDS = '03+';
         EXSR CHLBRS;

         IF LBRSFIRM = KYLBRSFIRM
           AND LBRSAFDN = KYLBRSAFDN
           AND LBRSAFJJ = KYLBRSAFJJ
           AND LBRSAFNR = KYLBRSAFNR
           AND LBRSAFPO = KYLBRSAFPO;
           CHIDS = '02R';
           ITER;
         ENDIF;

         // Verfügbarkeitsberechnung
         EXSR EVFBS;
         IF WKVFBS >= *ZERO;
           CHIDS = '02R';
           ITER;
         ENDIF;

         // Korrekter Satz ermittelt, ausgeben für den Workflow
         WKERMPGMSTAT = *ON;

         CLEAR WKERMPGMDS;
         WKERMFILE(1) = 'DIST';
         WKERMFILE§(1) = %ADDR(DIST);

         KYAKJH = ITBGJJ;
         KYAKAF = ITBGNR;
         CHIDS = '01C';
         EXSR CHAFKO;
         WKERMFILE(2) = 'AFKO';
         WKERMFILE§(2) = %ADDR(AFKO);

         KYAPJH = ITBGJJ;
         KYAPAF = ITBGNR;
         KYAPPO = ITBPOS;
         CHIDS = '01C';
         EXSR CHAFPO;
         WKERMFILE(3) = 'AFPO';
         WKERMFILE§(3) = %ADDR(AFPO);

         KYKDNR = AKKDNR;
         CHIDS = '01C';
         EXSR CHKUND;
         WKERMFILE(4) = 'KUND';
         WKERMFILE§(4) = %ADDR(KUND);

         LEAVESR;
       ENDDO;

       ENDSR;
       //*******************************************************************
       //**                                                              ***
       //**  SR-EVFBS   ERMITTELN DER VERFÜGBARER BESTAND                ***
       //**                                                              ***
       //*******************************************************************
       BEGSR EVFBS;

       WKVFBS = *ZERO;

       KOM = *BLANK;
       %SUBST(KOMDS:1:1) = 'P';
       %SUBST(KOMDS:2) = *BLANK;
       %SUBST(KOMDS:5:15) = ITTENR;
       DUN080 = ITRSDA;
       %SUBST(KOMDS:20:8) = DUC008;
       %SUBST(KOMDS:28:3) = ITBEGR;

       DUN040 = ITBGJJ;
       %SUBST(KOMDS:31:4) = DUC004;
       %SUBST(KOMDS:35:6) = ITBGNR;
       DUN050 = ITBPOS;
       %SUBST(KOMDS:41:5) = DUC005;
       DUN050 = ITUPOS;
       %SUBST(KOMDS:46:5) = DUC005;
       %SUBST(KOMDS:51:1) = DAJNKZ;
       %SUBST(KOMDS:83:3) = *BLANK;
       %SUBST(KOMDS:89:3) = ITWKNR;

       #CPGST = 'TRBP21';
       #CKOMM = *BLANK;
       #CKOMM = KOMDS;

       C_TRVFB1(EXTR02);
       KOM = *BLANK;
       KOMDS = #CKOMM;

       DUC011 = %SUBST(KOMDS:1);
       WKVFBS = DUN112;

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
      /END-FREE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHDIST
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,EXJOBA

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
