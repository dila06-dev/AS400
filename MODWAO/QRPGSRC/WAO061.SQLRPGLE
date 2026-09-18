     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2016')
      //*************************************************************************
     H/TITLE  Excel-Ausgabe von Verkaufspreislisten
      //*************************************************************************
      //  Copyright 2016 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: NI 13.01.2016 DOMETIC Projekt 11864
      //  -----------------------------------------------------------------------
      //  Änderung: NI 22.09.2016 DOMETIC Projekt 11864 Erweiterung um Ausgabe
      //            Produktgruppe
      //
      //*************************************************************************
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXEXPO04
      //
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D  WKZEIT         S              6S 0 INZ
      //
     D WKDATEDS        DS                  INZ
     D  WKDATE                        8  0
     D   WKJHJJ                       4  0 OVERLAY(WKDATE)
     D   WKMONA                       2  0 OVERLAY(WKDATE:5)
     D   WKTAGE                       2  0 OVERLAY(WKDATE:7)
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D PREI          E DS                  INZ
      //
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
      //
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
      //
     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ
      //
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
      //
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXGEWI        E DS                  INZ
     D RTGEWI        E DS                  INZ
      //
     D EXMAIL        E DS                  INZ
     D EXTXST        E DS                  INZ
      //
     D EXPRKO01      E DS                  INZ
     D RTPRKO01      E DS                  INZ
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
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
     D WKIOKZ          S              1
     D WKI000          S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D WKC010          S             10
     D WKTEMG          S             15  6
     D WKVKMG          S             15  6
     D WKAKTD          S              8S 0
     D WKCNTKPIF       S             10I 0
     D WKCNTEASC0      S             10I 0
     D WKCNTEASC3      S             10I 0
     D WKCNTKDZR       S             10I 0
     D WKPATH          S            100
     D SQSTMT          S           2000    VARYING
     D SQKDGR          S              5
     D VGKDNR          S                   LIKE(KDKDNR)
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D FL              S              4S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D WKFENR          S              4
     D WKINFO          S              4
     D W$PA03          S             10
     D W$PA04          S             10
     D W$PA05          S             10
     D W$PA06          S             10
     D W$PA07          S             10
     D W$PA08          S             10

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TREXPO04
      // Purpose:
      // Returns:
      // Parameter:      #EXEXPO04
      //--------------------------------------------------
     D C_TREXPO04      PR                  EXTPGM('TREXPO04')
     D  #EXEXPO04                          LIKEDS(EXEXPO04)

      //--------------------------------------------------
      // Program name: C_ERGEWI
      // Purpose:
      // Returns:
      // Parameter:      #EXGEWI
      // Parameter:      #RTGEWI
      //--------------------------------------------------
     D C_ERGEWI...
     D                 PR                  EXTPGM('ERGEWI')
     D  #EXGEWI                            LIKEDS(EXGEWI)
     D  #RTGEWI                            LIKEDS(RTGEWI)

      //--------------------------------------------------
      // Program name: C_ERPRKO
      // Purpose:
      // Returns:
      // Parameter:      #EXPRKO01
      // Parameter:      #RTPRKO01
      //--------------------------------------------------
     D C_ERPRKO...
     D                 PR                  EXTPGM('ERPRKO')
     D  #EXPRKO01                          LIKEDS(EXPRKO01)
     D  #RTPRKO01                          LIKEDS(RTPRKO01)

      //--------------------------------------------------
      // Program name: C_MAIL
      // Purpose:
      // Returns:
      // Parameter:      #EXMAIL
      //--------------------------------------------------
     D C_MAIL...
     D                 PR                  EXTPGM('TRMAIL')
     D  #EXMAIL                            LIKEDS(EXMAIL)

      //--------------------------------------------------
      // Program name: MAIN
      // Purpose:
      // Returns:
      // Parameter:    #PRGR  = Produktgruppe
      // Parameter:    #KDNR  = Kunde
      // Parameter:    #KDGR  = Kundengruppe
      // Parameter:    #TESV  = Artikelstatus von
      // Parameter:    #TESB  = Artikelstatus bis
      //--------------------------------------------------
     D MAIN            PR                  EXTPGM('WAO061')
     D  #DATE                         8S 0
     D  #KDNR                              LIKE(KDKDNR)
     D  #KDGR                              LIKE(KDKDGR)
     D  #PRGR                              LIKE(TEPRGR)
     D  #TESV                              LIKE(TETEST)
     D  #TESB                              LIKE(TETEST)

     D MAIN            PI
     D  #DATE                         8S 0
     D  #KDNR                              LIKE(KDKDNR)
     D  #KDGR                              LIKE(KDKDGR)
     D  #PRGR                              LIKE(TEPRGR)
     D  #TESV                              LIKE(TETEST)
     D  #TESB                              LIKE(TETEST)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
      //
      /FREE

       IN EXTRLD;

       KYTEFI = DAFIRM;
       KYKPFI = DAFIRM;
       KYKDFI = DAFIRM;
       KYTPFI = DAFIRM;
       KYTUFI = DAFIRM;

       // Firmensprache in allen Keystrukturen setzen
       KYTPSP = DASPCD;      // TRTP

       WKPATH = '/trend/echt/' +
                DAFIRM +
                %TRIM(#KDNR) +
                'Preisliste.xls';

       IF #KDNR <> *BLANKS;
         KYKDNR = #KDNR;
         CHIDS = '01C';
         EXSR CHKUND;
         SQKDGR = KDKDGR + '%';
       ELSE;
         SQKDGR = *ALL'%';
       ENDIF;

       RESET EXEXPO04;
       EXEXPO04.PGST = 'CREATE';
       EXEXPO04.FILE = WKPATH;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDSHE';
       EXEXPO04.SHEET = 'PREISE';
       C_TREXPO04(EXEXPO04);

       EXSR VKOPF;

       EXSR VPREISE;

       RESET EXEXPO04;
       EXEXPO04.PGST = 'FREEZE';
       EXEXPO04.MERGE.CM_FROMROW = 1;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'AUTOFT';
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'WRITE';
       C_TREXPO04(EXEXPO04);

       EXSR SMAIL;

       *INLR = *ON;

       //*************************************************************************
       //**  Erstellen Kopf                                                    ***
       //*************************************************************************
       BEGSR VKOPF;

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDROW';
       EXEXPO04.ROWH = 200;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Kunde';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Kundenname';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Kundengruppe';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Name der Kundengruppe';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Produktgruppe';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Name der Produktgruppe';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelnummer';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelbezeichnung 1 TEIL';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelbezeichnung 2 TEIL';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Katalogartikel ja/nein';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preisart PREI';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Ein-Ausschluss KPIF';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelnummer KPIF';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelbezeichnung 1 KPIF';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Artikelbezeichnung 2 KPIF';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Einzelpreis';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Währung';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Menge 2';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preis 2';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Menge 3';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preis 3';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Menge 4';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preis 4';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Menge 5';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preis 5';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Menge 6';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Preis 6';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattart';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattwert';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt Dim.';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt %';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattart';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattwert';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt Dim.';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt %';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattart';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabattwert';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt Dim.';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Rabatt %';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Gültig von';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = 'Gültig bis';
       EXEXPO04.CELL.C_align = 'C';
       EXEXPO04.CELL.C_ROTATION = 90;
       EXEXPO04.CELL.C_size = 16;
       C_TREXPO04(EXEXPO04);

       ENDSR;

       //*************************************************************************
       //**  Erstellen Zeile                                                   ***
       //*************************************************************************
       BEGSR VZEILE;

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDROW';
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRBEGR <> 'PVK';
         EXEXPO04.VALUE = KDKDNR;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRBEGR <> 'PVK';
         EXEXPO04.VALUE = KDNAM1;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = PRKDLG;
       IF EXEXPO04.VALUE = *BLANKS AND
          #KDGR <> *BLANKS;
         EXEXPO04.VALUE = #KDGR;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       KYTPTA = 'KDGR';
       KYTPTC = KDKDGR;
       CHIDS = '01C';
       EXSR CHTRTP;
       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TPTTXT;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = PRPRGR;
       IF #PRGR <> *BLANKS;
         EXEXPO04.VALUE = #PRGR;
       ELSE;
         EXEXPO04.VALUE = TEPRGR;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       KYTPTA = 'PRGR';
       KYTPTC = TEPRGR;
       CHIDS = '01C';
       EXSR CHTRTP;
       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TPTTXT;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TETENR;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TETBZ1;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TETBZ2;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = TEEWKATL;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = PRBEGR;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF WKCNTKDZR > *ZERO;
         EXEXPO04.VALUE = 'J';
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = KPIDEN;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = KPIBZ1;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = KPIBZ2;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.CELL.C_TYPE = 'S';
       EXEXPO04.CELL.C_FORMAT = '0.000';
       EXEXPO04.VALUE = %TRIM(%EDITC(PREZPR:'P'));
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = PRWACD;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRMG01 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRMG01:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRPR01 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.000';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRPR01:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRMG02 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRMG02:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRPR02 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.000';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRPR02:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRMG03 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRMG03:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRPR03 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.000';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRPR03:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRMG04 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRMG04:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRPR04 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.000';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRPR04:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRMG05 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRMG05:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRPR05 <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.000';
         EXEXPO04.VALUE = %TRIM(%EDITC(PRPR05:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = RTPRKOKON1;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON1 <> *BLANKS;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(RTPRKOKOW1:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON1 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPDI1;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOPRZ1 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPRZ1;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = RTPRKOKON2;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON2 <> *BLANKS;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(RTPRKOKOW2:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON2 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPDI2;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOPRZ2 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPRZ2;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.VALUE = RTPRKOKON3;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON3 <> *BLANKS;
         EXEXPO04.CELL.C_TYPE = 'S';
         EXEXPO04.CELL.C_FORMAT = '0.00';
         EXEXPO04.VALUE = %TRIM(%EDITC(RTPRKOKOW3:'P'));
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOKON3 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPDI3;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF RTPRKOPRZ3 <> *BLANKS;
         EXEXPO04.VALUE = RTPRKOPRZ3;
       ENDIF;
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       EXEXPO04.CELL.C_TYPE = 'D';
       EXEXPO04.VALUE = %CHAR(PRGADA);
       C_TREXPO04(EXEXPO04);

       RESET EXEXPO04;
       EXEXPO04.PGST = 'ADDCEL';
       IF PRGBDA <> *ZERO;
         EXEXPO04.CELL.C_TYPE = 'D';
         EXEXPO04.VALUE = %CHAR(PRGBDA);
       ENDIF;
       C_TREXPO04(EXEXPO04);

       ENDSR;

       //*************************************************************************
       //**  TRPREI  PREIS/KONDITIONENERFINDUNGSPROGRAMM                       ***
       //*************************************************************************
       BEGSR TRPREI;

       CLEAR EXPRKO01;
       CLEAR RTPRKO01;

         EXPRKOVPKZ = 'V';
         EXPRKOPRAR = PRBEGR;
         EXPRKOPSLI = KDPSLI;
         EXPRKOLAND = KDLAND;
         EXPRKOBLGA = *BLANKS;
         EXPRKOPRGR = TEPRGR;
         EXPRKOMAGR = TEMAGR;
         EXPRKOVTLI = TEVTLI;
         EXPRKOVKGB = KDVKGB;
         EXPRKOPOLZ = KDPOLZ;
         EXPRKOKDNR = KDKDNR;
         EXPRKOKDGR = KDKDGR;
         EXPRKOVBKD = *BLANKS;
         EXPRKOAGKD = PRKDLI;
         EXPRKOTENR = PRTENR;
         EXPRKOGEBI = *BLANKS;
         EXPRKOWACD = PRWACD;

         EXPRKODATE = WKAKTD;

         KYTUTE = TETENR;                                                       // UMRECHNEN
         KYTUME = TEMEVK;                                                       // MENGE IN
         WKV1V2 = 1;                                                            // IDENT-ME
         EXSR VTEUF;
      /END-FREE
     C                   Z-ADD(H)  WKV1V2        WKTEMG
      /FREE

         CLEAR EXGEWI;
         CLEAR RTGEWI;
         EXGEWITENR = TETENR;
      /END-FREE
     C                   Z-ADD     WKTEMG        EXGEWIMENG
      /FREE
         EXGEWIMEIN = TEMEIN;

         C_ERGEWI(EXGEWI:RTGEWI);
         EXPRKOGWNT = RTGEWIGWRE;

         KYTUTE = TETENR;                                                       // UMRECHNEN
         KYTUME = TEMPVK;                                                       // MENGE IN
         WKV2V1 = WKTEMG;                                                       // VERKAUF-ME
         EXSR VTEUF;                                                            // IDENTSTAMM
      /END-FREE
     C                   Z-ADD(H)  WKV2V1        WKVKMG
     C                   Z-ADD(H)  WKV2V1        EXPRKOMENG
      /FREE

         KYTUTE = TETENR;
         KYTUME = TEMPVK;
         WKV1V2 = 1;
         EXSR VTEUF;
      /END-FREE
     C                   Z-ADD(H)  WKV1V2        WKTEMG
      /FREE

         KYTUTE = TETENR;
         KYTUME = TEMPVK;
         WKV2V1 = WKTEMG;
         EXSR VTEUF;
      /END-FREE
     C                   Z-ADD(H)  WKV2V1        EXPRKONRMG
      /FREE

         EXPRKOMEIN = TEMPVK;                                                   // BESTELL-ME
         EXPRKOVSBD = KDVSBD;                                                   // VERSANDBEDINGUNG
         EXPRKOLIBD = KDLIBD;                                                   // LIEFERBEDIGUNG

         CALLP(E) C_ERPRKO(EXPRKO01:RTPRKO01);

       ENDSR;
       //*************************************************************************
       //**  Verarbeitung Preise                                               ***
       //*************************************************************************
       BEGSR VPREISE;

         WKAKTD = #DATE;

         SQSTMT = 'SELECT * FROM PREI, TEIL ' +
                  'WHERE PRFIRM = ' + '''' + DAFIRM + '''' + ' AND ' +
                  '((PRGBDA = 0 AND PRGADA <= ' + %CHAR(WKAKTD) + ') OR ' +
                  '(PRGBDA >= ' + %CHAR(WKAKTD) + ' AND PRGADA <= ' +
                  %CHAR(WKAKTD) + ' AND ' +
                  'PRGADA <= ' + %CHAR(WKAKTD) + ')) AND ' +
                  ' PRFIRM = TEFIRM AND ' +
                  ' PRTENR = TETENR AND ' +
                  'EXISTS(SELECT * FROM TRPA ' +
                  'WHERE TAFIRM = PRFIRM AND ' +
                  'TATART = ' + '''' + 'ZUAR' + '''' + ' AND ' +
                  'TATCDE = ' + '''' + 'PREI' + '''' + ' AND ' +
                  'TAPCDE = PRBEGR)';

         IF #TESV <> *BLANKS OR
            #TESB <> *BLANKS;
           SELECT;
             WHEN #TESV <> *BLANKS AND
                  #TESB <> *BLANKS;
               SQSTMT += ' AND TETEST BETWEEN ' +
                         '''' + #TESV + '''' +
                         ' AND ' +
                         '''' + #TESV + '''';
             WHEN #TESV <> *BLANKS;
               SQSTMT += ' AND TETEST >= ' +
                         '''' + #TESV + '''';
             WHEN #TESB <> *BLANKS;
               SQSTMT += ' AND TETEST <= ' +
                         '''' + #TESB + '''';
           ENDSL;
         ENDIF;

         IF #PRGR <> *BLANKS;
           SQSTMT += ' AND TEPRGR = ' + '''' + #PRGR + '''';
         ENDIF;

         IF #KDGR <> *BLANKS AND
            #KDNR = *BLANKS;
           SQSTMT += ' AND PRKDLG = ' + '''' + #KDGR + '''';
         ENDIF;

         IF #KDNR <> *BLANKS;
           SQSTMT += ' AND ((PRBEGR =' +
                     '''' + 'PKG' + '''' +
                     ' AND PRKDLG = ' + '''' + KDKDGR + '''' +
                     ') OR PRKDLI = ' +
                     '''' + #KDNR + '''';
           IF KDPSLI <> *BLANKS;
             SQSTMT += ') OR (PRBEGR = ' + '''' + 'PRL' + '''' +
                       ' AND PRPSLI = ' + '''' + KDPSLI + '''' + ')';
           ENDIF;
           SQSTMT += ')';
         ENDIF;

         SQSTMT += ' ORDER BY PRBEGR, PRKDLI ' +
                   'FOR FETCH ONLY';

         EXEC SQL PREPARE SQPREISE FROM :SQSTMT;

         EXEC SQL DECLARE PREISECU CURSOR FOR SQPREISE;

         EXEC SQL
           OPEN PREISECU;

         DOW SQLCOD = *ZERO;

           EXEC SQL
             FETCH PREISECU INTO :PREI,
                                 :TEIL;
           IF SQLCOD < 0 OR
              SQLCOD >= 100;
             LEAVE;
           ENDIF;

           IF PRKDLI <> *BLANKS;
             IF PRKDLI <> VGKDNR;
               KYKDNR = PRKDLI;
               CHIDS = '01C';
               EXSR CHKUND;
               IF WKFENR <> *ZERO;
                 ITER;
               ENDIF;
               VGKDNR = KDKDNR;
             ENDIF;
           ENDIF;

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTKPIF FROM KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR;

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTEASC0 FROM KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR AND
                     KPEASC IN ('0', ' ');

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTEASC3 FROM KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR AND
                     KPKDNR = :KDKDNR AND
                     KPEASC = '3';

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTKDZR FROM KDZR, KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR AND
                     KPKDNR = :KDKDNR AND
                     KDZRFIRM = KPFIRM AND
                     KDZRKPIF = KPKDNR AND
                     KPEASC = '3';

           IF WKCNTKPIF = *ZERO OR
              WKCNTEASC0 > *ZERO OR
              WKCNTEASC3 > *ZERO OR
              WKCNTKDZR > *ZERO;
           ELSE;
             ITER;
           ENDIF;

           IF #KDNR <> *BLANKS;
             KYKPKD = #KDNR;
             KYKPTE = TETENR;
             CHIDS = '01+';
             EXSR CHKPIF;
             IF WKFENR <> *ZERO OR
                KPKDNR <> KYKPKD OR
                KPTENR <> KYKPTE;
               CLEAR KPIF;
             ENDIF;
           ENDIF;

           EXSR TRPREI;

           KYTEEWFIRM = TEFIRM;
           KYTEEWTENR = TETENR;
           CHIDS = '01C';
           EXSR CHTEEW;
           IF WKFENR <> *ZERO;
             CLEAR TEEW;
           ENDIF;

           EXSR VZEILE;

         ENDDO;

         EXEC SQL
           CLOSE PREISECU;

         SQSTMT = 'SELECT * FROM PREI, TEIL ' +
                  'WHERE PRFIRM = ' + '''' + DAFIRM + '''' + ' AND ' +
                  '((PRGBDA = 0 AND PRGADA <= ' + %CHAR(WKAKTD) + ') OR ' +
                  '(PRGBDA >= ' + %CHAR(WKAKTD) + ' AND PRGADA <= ' +
                  %CHAR(WKAKTD) + ' AND ' +
                  'PRGADA <= ' + %CHAR(WKAKTD) + ')) AND ' +
                  ' PRFIRM = TEFIRM AND ' +
                  ' PRTENR = TETENR AND ' +
                  ' PRBEGR = ' +
                  '''' + 'PVK' + '''';

         IF #TESV <> *BLANKS OR
            #TESB <> *BLANKS;
           SELECT;
             WHEN #TESV <> *BLANKS AND
                  #TESB <> *BLANKS;
               SQSTMT += ' AND TETEST BETWEEN ' +
                         '''' + #TESV + '''' +
                         ' AND ' +
                         '''' + #TESV + '''';
             WHEN #TESV <> *BLANKS;
               SQSTMT += ' AND TETEST >= ' +
                         '''' + #TESV + '''';
             WHEN #TESB <> *BLANKS;
               SQSTMT += ' AND TETEST <= ' +
                         '''' + #TESB + '''';
           ENDSL;
         ENDIF;

         IF #PRGR <> *BLANKS;
           SQSTMT += ' AND TEPRGR = ' + '''' + #PRGR + '''';
         ENDIF;

         SQSTMT += ' ORDER BY PRTENR ' +
                   'FOR FETCH ONLY';

         EXEC SQL PREPARE SQTEILE FROM :SQSTMT;

         EXEC SQL DECLARE TEILECU CURSOR FOR SQTEILE;

         EXEC SQL
           OPEN TEILECU;

         DOW SQLCOD = *ZERO;

           EXEC SQL
             FETCH TEILECU INTO :PREI,
                                :TEIL;
           IF SQLCOD < 0 OR
              SQLCOD >= 100;
             LEAVE;
           ENDIF;

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTKPIF FROM KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR;

           EXEC SQL
             SELECT COUNT(*) INTO :WKCNTEASC0 FROM KPIF
               WHERE KPFIRM = :DAFIRM AND
                     KPTENR = :TETENR AND
                     KPEASC IN ('0', ' ');

           IF #KDNR = *BLANKS;
             EXEC SQL
               SELECT COUNT(*) INTO :WKCNTEASC3 FROM KPIF
                 WHERE KPFIRM = :DAFIRM AND
                       KPTENR = :TETENR AND
             //        KPKDNR = :KDKDNR AND
                       KPEASC = '3';
           ELSE;
             EXEC SQL
               SELECT COUNT(*) INTO :WKCNTEASC3 FROM KPIF
                 WHERE KPFIRM = :DAFIRM AND
                       KPTENR = :TETENR AND
                       KPKDNR = :#KDNR AND
                       KPEASC = '3';
           ENDIF;

           IF #KDNR = *BLANKS;
             EXEC SQL
               SELECT COUNT(*) INTO :WKCNTKDZR FROM KDZR, KPIF
                 WHERE KPFIRM = :DAFIRM AND
                       KPTENR = :TETENR AND
             //        KPKDNR = :KDKDNR AND
                       KDZRFIRM = KPFIRM AND
                       KDZRKPIF = KPKDNR AND
                       KPEASC = '3';
           ELSE;
             EXEC SQL
               SELECT COUNT(*) INTO :WKCNTKDZR FROM KDZR, KPIF
                 WHERE KPFIRM = :DAFIRM AND
                       KPTENR = :TETENR AND
                       KPKDNR = :#KDNR AND
                       KDZRFIRM = KPFIRM AND
                       KDZRKPIF = KPKDNR AND
                       KPEASC = '3';
           ENDIF;

           IF WKCNTKPIF = *ZERO OR
              WKCNTEASC0 > *ZERO OR
              WKCNTEASC3 > *ZERO OR
              WKCNTKDZR > *ZERO;
           ELSE;
             ITER;
           ENDIF;

           IF #KDNR <> *BLANKS;
             KYKPKD = #KDNR;
             KYKPTE = TETENR;
             CHIDS = '01+';
             EXSR CHKPIF;
             IF WKFENR <> *ZERO OR
                KPKDNR <> KYKPKD OR
                KPTENR <> KYKPTE;
               CLEAR KPIF;
             ENDIF;
           ENDIF;

           EXSR TRPREI;

           KYTEEWFIRM = TEFIRM;
           KYTEEWTENR = TETENR;
           CHIDS = '01C';
           EXSR CHTEEW;
           IF WKFENR <> *ZERO;
             CLEAR TEEW;
           ENDIF;

           EXSR VZEILE;

         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  SENDEN E-MAIL                                                     ***
       //*************************************************************************
       BEGSR SMAIL;

         CLEAR EXTXST;
         EXTTPGCD = 'TEXT';
         EXTTTCDE = 'TRTX64';
         EXTTBENU = DAUSER;
         EXTTPROG = 'MCUSZU';
         EXTTSPCD = DASPCD;
         EXTTUCDE = 'EMAIL ';
         EXSR TRTX50;
         IF EXTTTEXT = *BLANKS;
           LEAVESR;
         ENDIF;

         CLEAR EXMAIL;
         EXMAILFROM = 'preise@dometic.com';
         EXMAILSUBJ = 'Verkaufs-Preislisten';
         EXMAILBODY = 'siehe Anhang';
         EXMAILRCPT = EXTTTEXT;
         EXMAILATTC = WKPATH;
         C_MAIL(EXMAIL);

       ENDSR;
       //*************************************************************************
       //**  COPY-Module                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHKPIF
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,TRTX50
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
