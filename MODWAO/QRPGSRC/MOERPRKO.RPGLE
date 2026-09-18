     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2020')
      //*************************************************************************
      /TITLE  Programm für kundenspezifischen Sterung in Bezug auf die Preis-/Konditionsermittlung
      //*************************************************************************
      //  Copyright 2020 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 21.09.2020 DOMETIC Projekt 15986-02
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Das Programm entält kundenspezifische Steurungen in Bezug
      //  auf die Preis-/Konditionsermittlung
      //*************************************************************************
      //**  Tabellen und Feldgruppen                                          ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRTR

      //*************************************************************************
      //**  Dateien                                                           ***
      //*************************************************************************
     D KOND          E DS                  INZ
     D KYKOND        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  Kommunikationsparameter                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ

     D EXPRKO01      E DS
     D RTPRKO01      E DS

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

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
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D WKAT01          S              1
     D I1              S              3S 0
     D I2              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D PCPGST          S                   LIKE(#CPGST)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************

      //*************************************************************************
      //**  Programmstart                                                     ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXPRKO01
     C                   PARM                    RTPRKO01

      /FREE
       EXSR UEBPRKO01;
       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  Programmsteuerung                                                 ***
       //*************************************************************************
       SELECT;
       WHEN PCPGST = 'EKOPVS';
         // Ermitteln Kondition "PVS" (pro Land/Ident-Nr)
         EXSR ERKONDPVS;
       ENDSL;

       WKFIRM = DAFIRM;
       RETURN;                                                                  // !!!!!!!!!!!

       *INLR = *ON;                                                             // nur DEFINITIOM

       //*************************************************************************
       //**  Uebernahme Kommunikationsparamter  EXPRKO01                       ***
       //*************************************************************************
       BEGSR UEBPRKO01;

         PCPGST = EXPRKOPGST;

       ENDSR;

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

         KYKOFI = DAFIRM;     // KOND
         KYTAFI = DAFIRM;     // TRPA
         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;

       ENDSR;

       //*************************************************************************
       //**  Vorlauf                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Kondition "PVS" pro Land / Ident-Nr und, wenn eine      ***
       //**  solche gefunden wurde, den 'PVS'-Preis um diese verändern         ***
       //*************************************************************************
       BEGSR ERKONDPVS;

         // Die Kondition 'PVS' nur für den Preis 'PVK' relevant
         IF RTPRKOPRAR <> 'PVK';
           LEAVESR;
         ENDIF;

         CLEAR KYKOND;
         KYKOFI = DAFIRM;
         KYKOBG = 'PVS';
         KYKOLD = EXPRKOLAND;
         KYKOTE = EXPRKOTENR;
         KYKOWC = EXPRKOWACD;
         KYKODA = EXPRKODATE;
         CHIDS = '00-';
         EXSR CHKOND;

         IF CHI(5) = 'N'
           OR KOFIRM <> KYKOFI
           OR KOBEGR <> KYKOBG
           OR KOPSLI <> KYKOPS
           OR KOABTL <> KYKOAB
           OR KOLAND <> KYKOLD
           OR KOBLGA <> KYKOBL
           OR KOPRGR <> KYKOPG
           OR KOMAGR <> KYKOMG
           OR KOVKGB <> KYKOVG
           OR KOPOLZ <> KYKOPZ
           OR KOSTCD <> KYKOSC
           OR KOKDLI <> KYKOKL
           OR KOVSNR <> KYKOVS
           OR KOKDLG <> KYKOKG
           OR KOTENR <> KYKOTE
           OR KOGEBI <> KYKOGB
           OR KOPJNR <> KYKOPJ
           OR KOWACD <> KYKOWC;

           CLEAR KOND;
           LEAVESR;
         ENDIF;

         IF KOGBDA <> *ZERO AND KOGBDA < EXPRKODATE;
           CLEAR KOND;
           LEAVESR;
         ENDIF;

         // Wenn eine (absolute) 'PVS' Kondition für das Land und Artikel gefunden wurde,
         // den 'PVK'-Preis um 'PVS' - Kondition verändern
         IF RTPRKOPREI <> *ZERO;
           RTPRKOPREI += KORABA;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameterwerte                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHKOND
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,CHTRTP
       //*************************************************************************
       //**  ENDE des Programms                                                ***
       //*************************************************************************
