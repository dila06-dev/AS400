     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
      //*************************************************************************
      /TITLE Bestandabgleich Schnittstelle IFBS
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 23.11.2015 Projekt 11427 Dometic WAECO
      //  -----------------------------------------------------------------------
      //  Änderung: SZ 03.02.2016 Projekt 11427 Dometic WAECO, Status in IFBS
      //            fortschreiben
      //  Änderung: SZ 23.05.2016 Projekt 11427 Dometic WAECO, Update TLOG bei
      //            einem Buchungsfehler wenn Schalter TRLBBS = *ON.
      //            Im Userindex zusätzlich den Zeitstempel aus IFBS als Key für
      //            den späteren Update speichern.
      //  Änderung: SZ 12.08.2022 Projekt 17015 Dometic, Lagernummern 097 und 099
      //  Änderung: SZ 30.11.2022 Projekt 17015 Dometic, Lagernummer 091
      //  Änderung: SZ 13.12.2023 Projekt 17015 Dometic, Lagernummer 093
      //
      //*************************************************************************
      //
      //  Dieses Programm kann mit unterschiedlichen Parametern aufgerufen werden
      //  Bei PGST = 'ERLBBS' wird der Bestand für das Lager ermittelt und in
      //  einen Benutzerindex geschrieben.
      //  Bei PGST = 'UPDATE' wird mit den übergebenen Beständen ein Update auf
      //  den Benutzerindex ausgeführt.
      //  Bei PGST = 'BUCHEN' werden die Bestanddifferenzen über TRLBBS gebucht.
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D LAN             S              3    DIM(100)                             LAGER

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D LBBS          E DS                  INZ
     D KYLBBS        E DS                  INZ

     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ

     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ

     D IFBS          E DS                  INZ
     D KYIFBS        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ

     D TLOG          E DS                  INZ
     D KYTLOG        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRWL          E DS                  INZ
     D KYTRWL        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ

     D EXIFBS        E DS
     D RTIFBS        E DS

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01

      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKRTCD          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKILPO          S              1
     D WKILBS          S              1
     D WKIN30          S              1
     D WKIN31          S              1
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D WKZAHL          S              7S 0
     D WKTSTP          S               Z   INZ
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D SVTR02          S                   LIKE(EXTR02)
     D WKPGST          S                   LIKE(#CPGST)
     D WKLSTCINP       S                   LIKE(IFBSLSTC)
     D WKLSTCINM       S                   LIKE(IFBSLSTC)
     D WKCHAR          S                   LIKE(IFBSCHAR)
     D WKSUMM          S                   LIKE(IFBSLAGB)
     D WKDIFF          S                   LIKE(IFBSLAGB)
     D WKWKNR          S                   LIKE(IFBSWKNR)
     D WKPROG          S                   LIKE(RTIFBSPROG)
     D WKDANA          S                   LIKE(RTIFBSDANA)
     D WKFENR          S                   LIKE(RTIFBSFENR)
     D WKFFLD          S                   LIKE(RTIFBSFFLD)
     D WKLAGB          S                   LIKE(EXLBBWMG)
     D WKRESB          S                   LIKE(EXLBBWMG)
     D WKTENR          S                   LIKE(EXLBTENR)
     D WKLANR          S                   LIKE(EXLBLANR)
     D WKLORT          S                   LIKE(EXLBLORT)
     D WKLSTC          S                   LIKE(EXLBLSTC)

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_TRLBBS
      // Purpose:
      // Returns:
      // Parameter:      #EXLBLB
      // Parameter:      #RTLBLB
      //--------------------------------------------------
     D C_TRLBBS...
     D                 PR                  EXTPGM('TRLBBS')
     D  #EXLBLB                            LIKEDS(EXLBLB)
     D  #RTLBLB                            LIKEDS(RTLBLB)

      //--------------------------------------------------
      // Program name: C_TRLBB2
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRLBB2...
     D                 PR                  EXTPGM('TRLBB2')
     D  #EXTR02                            LIKEDS(EXTR02)

      //--------------------------------------------------
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #IFBSTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #IFBSTSTP                          LIKE(IFBSTSTP)

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

       EXSR VORLAUF;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       SELECT;
       WHEN WKPGST = 'ERLBBS' AND
         WKWKNR <> *BLANK;
         RTIFBSRTCD  = *ON;
         RETURN;
       WHEN WKPGST = 'ERLBBS';
         EXSR ETRWL;
         EXSR ERLBBS;
         WKWKNR = EXIFBSWKNR;
         RETURN;
       WHEN WKPGST = 'UPDATE' AND
         WKWKNR <> EXIFBSWKNR;
         RTIFBSRTCD = *ON;
         RETURN;
       WHEN WKPGST = 'UPDATE';
         EXSR UPDATE;
         RETURN;
       WHEN WKPGST = 'BUCHEN' AND
         WKWKNR <> EXIFBSWKNR;
         RTIFBSRTCD  = *ON;
         RETURN;
       WHEN WKPGST = 'BUCHEN';
         EXSR BUCHEN;
         WKWKNR = *BLANK;
       ENDSL;

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

       KYLBBSFIRM = DAFIRM;                                                     // LBBS
       KYLDFI = DAFIRM;                                                         // LBSD
       KYLSFI = DAFIRM;                                                         // LBSS
       KYIFBSFIRM = DAFIRM;                                                     // IFBS
       KYTEFI = DAFIRM;                                                         // TEIL
       KYTUFI = DAFIRM;                                                         // TEUF
       KYTLOGFIRM = DAFIRM;                                                     // TLOG
       KYTAFI = DAFIRM;                                                         // TRPA
       KYWLFI = DAFIRM;                                                         // TRWL

       WKLSTCINM = '911';                                                       // INVENTUR ABGANG
       WKLSTCINP = '921';                                                       // INVENTUR ZUGANG

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXIFBS                         ***
       //*************************************************************************
       BEGSR UEBIFBS;

       WKPGST = EXIFBSPGST;

       TEST(E) EXIFBSTSTP;
       *IN98 = %ERROR;

       IF *IN98 = *ON;
         KYIFBSTSTP = WKTSTP;
       ELSE;
         KYIFBSTSTP = EXIFBSTSTP;
       ENDIF;

       KYIFBSTENR = EXIFBSTENR;

       CLEAR RTIFBS;
       RTIFBSFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

       WKZAHL = *ZERO;

       ENDSR;
       //*************************************************************************
       //**  LESEN LAGERNUMMERN                                                ***
       //*************************************************************************
       BEGSR ETRWL;

       LAN = *BLANK;
       I1 = *ZERO;

       KYWLWK = EXIFBSWKNR;
       KYWLLA = *BLANK;
       CHIDS = '01L';
       EXSR CHTRWL;

       DOW WKFENR = *ZERO;
         CHIDS = '01R';
         EXSR CHTRWL;

         IF I1 = 100;
           LEAVE;
         ENDIF;

         IF WKFENR <> *ZERO
           OR WLFIRM <> KYWLFI
           OR WLWKNR <> KYWLWK;
           LEAVE;
         ENDIF;

         I1 = I1 + 1;
         LAN(I1) = WLLANR;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN BESTÄNDE                                                ***
       //*************************************************************************
       BEGSR ERLBBS;

       EXSR UXOPEN;
       EXSR UXWRTE;

       ENDSR;
       //*************************************************************************
       //**  UPDATE BESTANDSÄTZE                                               ***
       //*************************************************************************
       BEGSR UPDATE;

       CLEAR LBBS;
       EXUX01IKEY = DAFIRM + EXIFBSLANR + EXIFBSLORT
       + EXIFBSTENR + EXIFBSCHAR;
       EXSR EXUXBYKY;

       IF EXUX01RTCD = 00 OR EXUX01RTCD = 21;                                    // UPDATE
         LBBS = %SUBST(EXUX01IDTA: 114: 465);
         DUC026 = %SUBST(EXUX01IDTA: 579: 26);
         DUC013 = %SUBST(EXUX01IDTA: 101: 13);
         DUN134 = DUN134 + EXIFBSLAGB;
         EXUX01IDTA = EXUX01IKEY + DUC013 + LBBS + %CHAR(EXIFBSTSTP);
         EXUX01IMDE = EXUX03REPL;
         EXSR EXUXWRTE;
       ELSE;
         CLEAR LBBS;                                                            // WRITE
         LBBSJDAT = %DEC(%DATE():*ISO);
         LBBSJZEI = %DEC(%TIME());
         LBBSFIRM = DAFIRM;
         LBBSLANR = EXIFBSLANR;
         LBBSLORT = EXIFBSLORT;
         LBBSTENR = EXIFBSTENR;
         LBBSCHAR = EXIFBSCHAR;
         EXUX01IKEY = DAFIRM + EXIFBSLANR + EXIFBSLORT
         + EXIFBSTENR + EXIFBSCHAR;
         DUN134 = EXIFBSLAGB;
         EXUX01IDTA = EXUX01IKEY + DUC013 + LBBS + %CHAR(EXIFBSTSTP);
         EXUX01IMDE = EXUX03NORP;
         EXSR EXUXWRTE;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  BUCHEN DIFFERENZEN                                                ***
       //*************************************************************************
       BEGSR BUCHEN;

       EXSR UXREAD;
       EXSR EXUXCLOS;

       ENDSR;
       //*************************************************************************
       //**  BUCHEN                                                            ***
       //*************************************************************************
       BEGSR TRLBBS;

       IF EXIFBSERDA = *ZERO;
         EXIFBSERDA = %DEC(%DATE():*ISO);
         EXIFBSERZT = %DEC(%TIME());
       ENDIF;

       CLEAR EXLBLB;
       EXLBPGST = 'BUCHEN';
       EXLBLSTC = WKLSTC;
       EXLBLANR = LBBSLANR;
       EXLBLORT = LBBSLORT;
       EXLBTENR = LBBSTENR;
       EXLBCHAR = LBBSCHAR;
       EXLBBHNR = LBBSBHNR;
       EXLBBWMG = WKDIFF;
       EXLBSTMG = WKDIFF;
       EXLBBWME = TEMEIN;
       EXLBBZEI = EXIFBSERZT;
       EXLBBDAT = EXIFBSERDA;
       EXLBBEZ1 = 'IFBS';
       EXLBBEZ2 = *BLANK;

       IF EXIFBSBLNR <> *BLANK;
         EXLBDANA = 'IFBS';
         DUN040 = EXIFBSBLJJ;
         DUN050 = EXIFBSBLPO;
         EXLBDAKY = DUC004 + EXIFBSBLNR + DUC005 +
         '0000';
       ENDIF;

       C_TRLBBS(EXLBLB:RTLBLB);
       WKZAHL = WKZAHL + 1;
       RTIFBSFENR = RTLBFENR;
       RTIFBSFFLD = RTLBFFLD;

       ENDSR;
       //*************************************************************************
       //**  DATEI MIT DIFFERENZEN SCHREIBEN                                   ***
       //*************************************************************************
       BEGSR WTLOG;

       CLEAR TLOG;
       TLOGJDAT = LBBSJDAT;
       TLOGJZEI = LBBSJZEI;
       TLOGJNAM = LBBSJNAM;
       TLOGUSER = LBBSUSER;
       TLOGERUS = LBBSUSER;
       TLOGPROG = LBBSPROG;
       TLOGBIBL = LBBSBIBL;
       TLOGFILE = 'IFBS';
       TLOGSTAT = '00';
       TLOGFENR = RTLBFENR;
       TLOGFFLD = RTLBFFLD;
       TLOGDANA = 'IFBS';
       TLOGDAKY = WKLSTC + LBBSLANR + LBBSLORT + LBBSTENR;
       TLOGPGNA = WKCHPN;
       TLOGCHPL = WKCHPL;
       TLOGREF1 = WKLSTC;
       TLOGREF2 = LBBSLANR + LBBSLORT;
       TLOGREF3 = LBBSTENR;
       TLOGREF4 = %EDITC(WKDIFF:'X');
       TLOGTEXT = WKLSTC + LBBSLANR + LBBSTENR + LBBSCHAR + %EDITC(LBBSLAGB:'X')
                + %EDITC(WKSUMM:'X') + TEMEIN;

       TLOGFIRM = LBBSFIRM;
       C_EXTSTP(TLOGTSTP);
       CHIDS = '01W';
       EXSR CHTLOG;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS IDENSTAMM                                     ***
       //*************************************************************************
       BEGSR ETEIL;

       KYTENR = LBBSTENR;
       KYTEEZ = *BLANK;
       CHIDS = '01C';
       EXSR CHTEIL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'TREND';
         KYTATC = 'IFIFBS';
         KYTAPA = 'BUCHEN';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKILBS = TAPCDE;

         IF WKILBS <> *ON;
           WKILBS = *OFF;
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  ÖFFNEN CURSOR LBBS                                                ***
       //*************************************************************************
       BEGSR OCLBBS1;

       EXEC SQL
       DECLARE LBBSC1 CURSOR FOR SELECT * FROM LBBS
       WHERE LBBSFIRM  = :DAFIRM AND
       LBBSLANR  IN ('001', '091', '093', '094', '095', '096', '097', '099')
       ORDER BY LBBSFIRM, LBBSLANR, LBBSLORT, LBBSTENR, LBBSCHAR
       FOR READ ONLY;

         EXEC SQL
         OPEN LBBSC1;

       ENDSR;
       //*************************************************************************
       //**  ÖFFNEN USERINDEX                                                  ***
       //*************************************************************************
       BEGSR UXOPEN;

         CLEAR EXUX01PARM;
         EXUX01INAM = 'IFBSLBBS';
         EXUX01ILIB = 'QTEMP';
         EXUX01IATR = 'TREND';
         EXUX01DTLG = 1000;
         EXUX01KYLG = 100;
         EXUX01ITXT = 'Bestandsabgleich IFBSLBBS';
         EXSR EXUXOPEN;

       ENDSR;
       //*************************************************************************
       //**  SCHREIBEN USERINDEX                                               ***
       //*************************************************************************
       BEGSR UXWRTE;

         WKTENR = *BLANK;
         WKCHAR = *BLANK;
         WKLANR = *BLANK;
         WKSUMM = *ZERO;
         WKDIFF = *ZERO;
         WKILPO = *OFF;
         SQLCOD = *ZERO;

         EXSR OCLBBS1;
         EXEC SQL
         FETCH NEXT FROM LBBSC1 INTO :LBBS;

         DOW SQLCOD = *ZERO;

           IF LBBSTENR <> WKTENR OR
             LBBSCHAR <> WKCHAR OR
             LBBSLANR <> WKLANR;

             IF WKSUMM <> *ZERO;
               EXSR EXUXWRTE;
             ENDIF;

             WKTENR = LBBSTENR;
             WKCHAR = LBBSCHAR;
             WKLANR = LBBSLANR;
             WKSUMM = LBBSLAGB;
           ELSE;
             WKSUMM = WKSUMM + LBBSLAGB;
           ENDIF;

           LBBSJDAT = %DEC(%DATE():*ISO);
           LBBSJZEI = %DEC(%TIME());
           EXUX01IKEY = LBBSFIRM + LBBSLANR + LBBSLORT + LBBSTENR + LBBSCHAR;
           LBBSLAGB = WKSUMM;
           DUN134 = *ZERO;
           EXUX01IDTA = EXUX01IKEY + DUC013 + LBBS + %CHAR(WKTSTP);
           EXUX01IMDE = EXUX03REPL;

           EXEC SQL
           FETCH NEXT FROM LBBSC1 INTO :LBBS;
         ENDDO;

         IF WKSUMM <> *ZERO;
           EXSR EXUXWRTE;
         ENDIF;

         EXEC SQL
         CLOSE LBBSC1;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN  USERINDEX                                            ***
       //*************************************************************************
       BEGSR UXREAD;

         WKTENR = *BLANK;
         EXSR EXUXREAD;

         DOW EXUX01RTCD = *ZERO;
           MONITOR;
             WKSUMM = %DEC(%SUBST(EXUX01IDTA: 101: 13):13:0) / 10000;
           ON-ERROR;
             WKSUMM = *ZERO;
           ENDMON;
           LBBS = %SUBST(EXUX01IDTA: 114: 465);
           DUC026 = %SUBST(EXUX01IDTA: 579: 26);

           IF WKSUMM <> LBBSLAGB;

             IF LBBSTENR <> WKTENR;
               EXSR ETEIL;
               WKTENR = LBBSTENR;
             ENDIF;

             SELECT;
             WHEN WKSUMM > *ZERO AND WKSUMM > LBBSLAGB;
               WKLSTC = WKLSTCINP;
               WKDIFF = WKSUMM - LBBSLAGB;
             WHEN WKSUMM > *ZERO;
               WKLSTC = WKLSTCINM;
               WKDIFF = LBBSLAGB - WKSUMM;
             WHEN WKSUMM = *ZERO;
               WKLSTC = WKLSTCINM;
               WKDIFF = LBBSLAGB;
             OTHER;
               WKLSTC = WKLSTCINP;
               WKDIFF = LBBSLAGB + WKSUMM;
             ENDSL;

             IF WKILBS = *ON;
               EXSR TRLBBS;
               EXSR UIFBS;
               IF RTLBFENR <> '0000';
                 EXSR WTLOG;
               ENDIF;
             ELSE;
               RTLBFENR = '0000';
               RTLBFFLD = *BLANK;
               EXSR WTLOG;
             ENDIF;

           ENDIF;

           EXSR EXUXNEXT;
         ENDDO;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN LAGERBESTAND                                            ***
       //*************************************************************************
       BEGSR PLAGB;

         WKLAGB = *ZERO;
         WKRESB = *ZERO;

         #CKOMM = *BLANK;
         %SUBST(#CKOMM:1:1) = *ON;                                              // PRÜFUNG-KZ
         %SUBST(#CKOMM:2:1) = *ON;                                              // ERM.LAGERBESTAND
         %SUBST(#CKOMM:3:1) = *ON;                                              // ERM.LAGERRESERV.
         %SUBST(#CKOMM:4:1) = *OFF;                                             // ERM.DIST RESERV.
         %SUBST(#CKOMM:5:1) = *OFF;                                             // BEDARFSPLAN-LAGER
         %SUBST(#CKOMM:6:1) = *BLANK;
         %SUBST(#CKOMM:7:1) = *OFF;                                             // LAGERPLATZSPERRUN
         %SUBST(#CKOMM:8:1) = *OFF;
         %SUBST(#CKOMM:10:15) = LBBSTENR;
         %SUBST(#CKOMM:25:3) = LBBSLANR;
         %SUBST(#CKOMM:28:15) = *BLANK;
         %SUBST(#CKOMM:43:20) = LBBSCHAR;
         %SUBST(#CKOMM:63:8) = LBBSLORT;
         %SUBST(#CKOMM:102:3) = *BLANK;
         %SUBST(#CKOMM:105:1) = *ON;                                            // SPERRLAGER
         %SUBST(#CKOMM:166:20) = LBBSFBNR;
         #CPGST = *BLANK;

         C_TRLBB2(EXTR02);
         WKLAGB = %DEC(%SUBST(#CKOMM:1:13):13:4) / 10000;
         WKRESB = %DEC(%SUBST(#CKOMM:92:13):13:4) / 10000;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI IFBS                                                 ***
       //*************************************************************************
       BEGSR UIFBS;

       MONITOR;
         KYIFBSTSTP = %TIMESTAMP(DUC026);
       ON-ERROR;
         KYIFBSTSTP = WKTSTP;
       ENDMON;

       CHIDS = '01CU';
       EXSR CHIFBS;

       IF RTLBFENR <> '0000';
         IFBSSTAT = '50';
       ELSE;
         IFBSSTAT = '90';
       ENDIF;

       IFBSTMST = RTLBTMST;
       IFBSFENR = RTLBFENR;
       IFBSFFLD = RTLBFFLD;

       IFBSJNAM = DAJNAM;
       IFBSPROG = WKCHPN;
       IFBSBIBL = WKCHPL;
       IFBSUSER = DAUSER;
       IFBSJZEI = %DEC(%TIME());
       IFBSJDAT = %DEC(%DATE():*ISO);

       SELECT;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFBS;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHLBBS
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHLBSS
     C/COPY QCPYSRC,CHIFBS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTLOG
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRWL
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,VTEUF
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
