     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
      //*************************************************************************
      /TITLE Verarbeiten Bestandsdaten aus IFBS (PBESTLO3)
      //*************************************************************************
      //  Copyright 2022 by    trend SWM
      //                       Verwaltung GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 12.08.2022 Dometic Projekt 17015
      //  -----------------------------------------------------------------------
      //  Änderung:
      //
      //*************************************************************************
      //
      //  Wenn das Programm mit PGST = 'VIFBS' aufgerufen wird, wird der Inhalt
      //  der Datei IFBS nach Status verarbeitet. Dem Bestand vom Fremdsystem
      //  wird der Bestand aus LBBS gegenübergestellt. Dies erfolgt über IFIFBS
      //  bei Aufruf mit PGST 'ERLBBS'. Der Bestand aus LBBS wird dabei verdich-
      //  tet nach Lager/Artikelnummer in einen Benutzerindex geschrieben.
      //  Bei der folgenden Verarbeitung von IFBS wird IFIFBS mit PGST 'UPDATE'
      //  aufgerufen. Die Bestände vom Fremdsystem werden dabei im Feld STMG
      //  übergeben und per Update in den Benutzerindex geschrieben. Zuletzt
      //  wird IFIFBS mit PGST 'BUCHEN' aufgerufen. Dabei werden festgestellte
      //  Differenzen in IFIFBS direkt über TRLBBS als positive bzw. negative
      //  Korrektur gebucht.
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D IFBS          E DS                  INZ
     D KYIFBS        E DS                  INZ
     D WKIFBS        E DS                  INZ EXTNAME(IFBS) PREFIX(WK)
      //
     D CHST          E DS                  INZ
     D KYCHST        E DS                  INZ
      //
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXIFBS        E DS
     D RTIFBS        E DS
      //
      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)
      //
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D WKTRPA          S              1
     D WKFENR          S              4
     D WKI000          S              1
     D WKTLKZ          S              1
     D WKIUML          S              1
     D WKIPOS          S              1
     D WKISTS          S              1
     D WKIGRP          S              1
     D WKIGR2          S              1
     D WKISLK          S              1
     D WKIUPD          S              1
     D WKISPE          S              1
     D WKIAUT          S              1
     D WKI1DG          S              1
     D WKIBSA          S              1
     D WKC010          S             10
     D WKTRPAFXDR      S              1
     D WKTRPAMLDR      S              1
     D WKTRPALSTC      S              3
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              4S 0
     D WKTSTP          S               Z   INZ
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKDAUSER        S                   LIKE(DAUSER)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPGST          S                   LIKE(#CPGST)
     D PCRTCD          S                   LIKE(#CRTCD)
     D OFIFBSTSTP      S                   LIKE(KYIFBSTSTP)
     D OFIFBSSTAT      S                   LIKE(KYIFBSSTAT)
     D OFIFBSTENR      S                   LIKE(KYIFBSTENR)
     D WKIFBSSTME      S                   LIKE(IFBSLBME)
     D SVIFBS          S                   LIKE(IFBS)
     D SVKYIFBS        S                   LIKE(KYIFBS)
     D DO_X            S              7  0

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_IFIFBS
      // Purpose:
      // Returns:
      // Parameter:      #EXIFBS
      // Parameter:      #RTIFBS
      //--------------------------------------------------
     D C_IFIFBS...
     D                 PR                  EXTPGM('IFIFBS')
     D  #EXIFBS                            LIKEDS(EXIFBS)
     D  #RTIFBS                            LIKEDS(RTIFBS)

      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKTSTP                            LIKE(WKTSTP)

      //--------------------------------------------------
      // Program name: C_TRCHST
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRCHST...
     D                 PR                  EXTPGM('TRCHST')
     D  #EXTR02                            LIKEDS(EXTR02)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXIFBS
     C                   PARM                    RTIFBS
      /FREE
       EXSR UEBIFBS;
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       SELECT;
       WHEN WKTRPA <> *ON;
         EXSR ETRPA;
       ENDSL;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       WKI1DG = *OFF;
       WKIBSA = *OFF;

       SELECT;
       WHEN PCPGST = 'VIFBS ';
         OFIFBSSTAT = '80';
         EXSR VIFBS;
         EXSR BUCHEN;
       WHEN PCPGST = 'BUCHEN';
         EXSR BUCHEN;
       WHEN PCPGST = 'UPSTAT';
         EXSR UPSTAT;
       ENDSL;

       RTIFBSRTCD = #CRTCD;
       RETURN;
       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;
       WKFIRM = DAFIRM;
       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;
       WKUSER = EXPSDSUSER;

       KYIFBSFIRM = DAFIRM;                                                     // IFBS
       KYCHSTFIRM = DAFIRM;                                                     // CHST
       KYTEFI = DAFIRM;                                                         // TEIL
       KYTUFI = DAFIRM;                                                         // TEUF
       KYTAFI = DAFIRM;                                                         // TRPA
       KYTPFI = DAFIRM;                                                         // TRTP

       KYTPSP = DASPCD;                                                         // TRTP

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXIFBS                          ***
       //*************************************************************************
       BEGSR UEBIFBS;

       PCPGST = EXIFBSPGST;
       TEST(E) EXIFBSTSTP;

       IF %ERROR;
         KYIFBSTSTP = WKTSTP;
       ELSE;
         KYIFBSTSTP = EXIFBSTSTP;
       ENDIF;

       CLEAR RTIFBS;
       RTIFBSFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN DATEI IFBS                                            ***
       //*************************************************************************
       BEGSR VIFBS;

       KYIFBSSTAT = OFIFBSSTAT;
       KYIFBSTSTP = *LOVAL;
       CHIDS = '02L';
       EXSR CHIFBS;

       CLEAR WKIFBS;

       DOW *INLR = *OFF;
         CHIDS = '02R';
         EXSR CHIFBS;

         IF OFIFBSSTAT = '50' AND
           IFBSTSTP > OFIFBSTSTP;
           CHIDS = '02CF';
           EXSR CHIFBS;
           LEAVE;
         ENDIF;

         IF WKFENR <> '0000' OR
           IFBSFIRM <> KYIFBSFIRM OR
           IFBSSTAT <> KYIFBSSTAT;
           CHIDS = '02CF';
           EXSR CHIFBS;
           LEAVE;
         ENDIF;

         WKIFBS = IFBS;

         IF IFBSSTAT = '80';
           WKIFBSFENR = '0000';
           WKIFBSFFLD = *BLANK;
         ENDIF;

         EXSR LWKFLD;                                                           // LÖSCHEN INHALT WK
         EXSR VIFBS01;
         EXSR UIFBS;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  LÖSCHEN INHALT ARBEITSFELDER                                      ***
       //*************************************************************************
       BEGSR LWKFLD;


       ENDSR;
       //*************************************************************************
       //**  AUSGABE DIFFERENZEN BESTANDSVERGLEICH                             ***
       //*************************************************************************
       BEGSR BUCHEN;

       LEAVESR;
       CLEAR EXIFBS;
       EXIFBSPGST = 'BUCHEN';
       EXIFBSWKNR = WKIFBSWKNR;
       EXIFBSERDA = WKIFBSERDA;
       EXIFBSERZT = WKIFBSERZT;
       C_IFIFBS(EXIFBS:RTIFBS);

       ENDSR;
       //*************************************************************************
       //**  ANFORDERUNG BESTANDSVERGLEICH                                     ***
       //*************************************************************************
       BEGSR VIFBS01;

       WKIFBSSTAT = '50';
       WKIFBSFENR = '0000';
       WKIFBSFFLD = *BLANK;
       EXSR EVARI;
       EXSR ETEIL;

       IF WKIFBSCHAR <> *BLANK AND
         WKIFBSTENR <> *BLANK;
         EXSR ECHST;
       ENDIF;

       IF WKIFBSLANR = *BLANK;
         WKIFBSFENR = '0031';
         WKIFBSFFLD = 'IFBSLANR';
         LEAVESR;
       ENDIF;

       EXSR VLAGB;

       IF WKI1DG <> *ON;
         CLEAR EXIFBS;
         EXIFBSPGST = 'ERLBBS';
         EXIFBSWKNR = WKIFBSWKNR;
         EXIFBSERDA = WKIFBSERDA;
         EXIFBSERZT = WKIFBSERZT;
         C_IFIFBS(EXIFBS:RTIFBS);
         WKI1DG = *ON;
       ENDIF;

       CLEAR EXIFBS;
       EXIFBSPGST = 'UPDATE';
       EXIFBSWKNR = WKIFBSWKNR;
       EXIFBSTENR = WKIFBSTENR;
       EXIFBSCHAR = WKIFBSCHAR;
       EXIFBSLANR = WKIFBSLANR;
       EXIFBSLORT = WKIFBSLORT;
       EXIFBSLAGB = WKIFBSSTMG;
       EXIFBSLBME = WKIFBSSTME;
       EXIFBSERDA = WKIFBSERDA;
       EXIFBSERZT = WKIFBSERZT;
       C_IFIFBS(EXIFBS:RTIFBS);
       WKIFBSFENR = RTIFBSFENR;
       WKIFBSFFLD = RTIFBSFFLD;

       IF WKIFBSFENR = *BLANK;
         WKIFBSFENR = '0000';
       ENDIF;

       IF RTIFBSRTCD <> *ON AND
         WKIFBSFENR = '0000';
         WKIFBSFFLD = *BLANK;
         WKIFBSSTAT = '90';
         WKIBSA = *ON;
       ENDIF;

       IF RTIFBSRTCD = *ON;
         WKIFBSFENR = '0000';
         WKIFBSFFLD = *BLANK;
         WKIFBSSTAT = '80';
         WKIBSA = *OFF;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN/EINSTELLEN VARIABLEN                                       ***
       //*************************************************************************
       BEGSR EVARI;

       WKIUML = *OFF;

       SELECT;
       WHEN WKIFBSSZAR = '    ';                                                // INVENTUR
         WKIFBSDANA = *BLANK;
         WKIFBSDAKY = *BLANK;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI IFBS                                                 ***
       //*************************************************************************
       BEGSR UIFBS;

       KYIFBSTSTP = WKIFBSTSTP;
       CHIDS = '01CU';
       EXSR CHIFBS;

       IFBSLSTC = WKIFBSLSTC;
       IFBSLBSC = WKIFBSLBSC;
       IFBSDANA = WKIFBSDANA;
       IFBSDAKY = WKIFBSDAKY;
       IFBSLANR = WKIFBSLANR;
       IFBSLORT = WKIFBSLORT;
       IFBSTMST = WKIFBSTMST;

       IFBSBDAT = WKIFBSBDAT;
       IFBSBZEI = WKIFBSBZEI;
       IFBSBEM1 = WKIFBSBEM1;
       IFBSBEM2 = WKIFBSBEM2;

       IFBSSTAT = WKIFBSSTAT;
       IFBSFENR = WKIFBSFENR;
       IFBSFFLD = WKIFBSFFLD;

       IFBSJNAM = DAJNAM;
       IFBSPROG = WKCHPN;
       IFBSBIBL = WKCHPL;
       IFBSUSER = DAUSER;
       IFBSJZEI = %DEC(%TIME());
       IFBSJDAT = %DEC(%DATE():*ISO);

       SELECT;
       WHEN CHI(6) = *ON;
         C_EXTSTP(IFBSTSTP);
         CHIDS = '01W';
         EXSR CHIFBS;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFBS;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN CHARGE                                                  ***
       //*************************************************************************
       BEGSR ECHST;

       IF TECHKZ <> DAJNKZ AND
         TETENR <> *BLANK;
         WKIFBSCHAR = *BLANK;
         LEAVESR;
       ENDIF;

       IF WKIFBSLAGB <> *ZERO AND
         WKIFBSCHAR = *BLANK;
         LEAVESR;
       ENDIF;

       IF WKIFBSLAGB = *ZERO AND
         WKIFBSCHAR = *BLANK;
         LEAVESR;
       ENDIF;

       KYCHSTTENR = WKIFBSTENR;
       KYCHSTCHAR = WKIFBSCHAR;
       CHIDS = '01C';
       EXSR CHCHST;

       SELECT;
       WHEN WKFENR <> '0000';
         EXSR UCHST;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  UPDATE CHARGENSTAMM                                               ***
       //*************************************************************************
       BEGSR UCHST;

       CLEAR #CKOMM;
       %SUBST(#CKOMM:1:20) = WKIFBSCHAR;
       %SUBST(#CKOMM:21:15) = WKIFBSTENR;
       %SUBST(#CKOMM:36:4) = 'RIU3';
       %SUBST(#CKOMM:40:8) = %EDITC(WKIFBSHSDA:'X');
       %SUBST(#CKOMM:48:3) = WKIFBSWKNR;
       %SUBST(#CKOMM:57:8) = %EDITC(WKIFBSVEDA:'X');
       %SUBST(#CKOMM:143:20) = WKIFBSCHEX;
       %SUBST(#CKOMM:163:6) = %EDITC(WKIFBSHSZT:'X');
       #CPGST = 'WCHST ';
       C_TRCHST(EXTR02);

       IF #CRTCD <> 'W' AND
         #CRTCD <> 'U';
         WKIFBSFENR = '0031';
         WKIFBSFFLD = 'TRCHST';
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS                                                     ***
       //*************************************************************************
       BEGSR UPSTAT;

       CHIDS = '01C';
       EXSR CHIFBS;

       CHIDS = '01CU';
       EXSR CHIFBS;
       IFBSSTAT = '90';
       IFBSBEM1 = ' ';
       CHIDS = '01U';
       EXSR CHIFBS;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS IDENSTAMM                                     ***
       //*************************************************************************
       BEGSR ETEIL;

       IF WKIFBSTENR  = *BLANK;
         CLEAR TEIL;
         LEAVESR;
       ENDIF;

       KYTENR = WKIFBSTENR;
       KYTEEZ = *BLANK;
       CHIDS = '01C';
       EXSR CHTEIL;

       IF WKFENR <> '0000';
         CLEAR TEIL;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  UMRECHNEN LAGERBESTAND                                            ***
       //*************************************************************************
       BEGSR VLAGB;

       KYTUTE = WKIFBSTENR;                                                     // MENGE
       KYTUME = WKIFBSLBME;
       WKV1V2 = WKIFBSLAGB;
       EXSR VTEUF;
       WKIFBSSTMG = WKV1V2;
       WKIFBSSTME = TEMEIN;

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
     C/COPY QCPYSRC,CHCHST
     C/COPY QCPYSRC,CHIFBS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,VTEUF
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
