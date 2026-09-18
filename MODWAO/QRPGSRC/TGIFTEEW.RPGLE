     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H ALWNULL(*USRCTL)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE Trigger für Schnittstelle Stammdaten Identstamm Erweiterung
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 21.08.2015 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Das Programm wird bei *INSERT, *UPDATE oder *DELETE auf TEEW von dem
      //  CL-Programm TGIFTEEWSB per Submit aufgerufen.
      //  Bei *INSERT oder *DELETE wird direkt ein Datensatz in IFST geschrieben.
      //  Bei *UPDATE anaylsiert das Programm den Inhalt der Datenstruktur TEEW
      //  ab Stelle 56 (FIRM). Bei einer Differenz wird ein Datensatz in IFST
      //  geschrieben.
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D IFST          E DS                  INZ
     D KYIFST        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ

     D TGPARM1         DS
     D  TGDATEI                      10A
     D  TGBIB                        10A
     D  TGMBR                        10A
     D  TGEVENT                       1A
      //   1 = INSERT
      //   2 = DELETE
      //   3 = UPDATE
     D  TGTIME                        1A
      //   1 = AFTER
      //   2 = BEFORE
     D  TGCMTLL                       1A
      //   0 = NONE
      //   1 = CHG
      //   2 = CS
      //   3 = ALL
     D  TGF1                          3A
     D  TGCCSID                       8B 0
     D  TGF2                          8A
     D  TGOLD_OFF                     8B 0
     D  TGOLD_LEN                     8B 0
     D  TGOLD_N_MAP                   8B 0
     D  TGOLD_N_LEN                   8B 0
     D  TGNEW_OFF                     8B 0
     D  TGNEW_LEN                     8B 0
     D  TGNEW_N_MAP                   8B 0
     D  TGNEW_N_LEN                   8B 0
     D  TGF3                         16A
     D  TGDATEN                   10000A

     D TGPARM2         DS
     D  TGBUFL                        8B 0
      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXTX01
     D/COPY QCPYSRC,EXTRDA

     D TEEWOLD         DS                  LIKEDS(TEEW) INZ(*LIKEDS)
     D TEEWNEW         DS                  LIKEDS(TEEW) INZ(*LIKEDS)

     D DSIFST          DS                  LIKEDS(IFST) INZ(*LIKEDS)

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKI000          S              1
     D WKTRPATEEW      S              1
     D WKFENR          S              4
     D WKFFLD          S             10
     D WKIFST          S              1
     D DSFIRM          S                   LIKE(DAFIRM)
     D WKFIRM          S                   LIKE(DSFIRM)
     D WKUSER          S                   LIKE(DAUSER)
     D WKNEWPOS        S                   LIKE(DUN050) INZ
     D WKNEWLNG        S                   LIKE(DUN050) INZ
     D WKOLDPOS        S                   LIKE(DUN050) INZ
     D WKOLDLNG        S                   LIKE(DUN050) INZ

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #IFSTTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #IFSTTSTP                          LIKE(IFSTTSTP)
      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    TGPARM1
     C                   PARM                    TGPARM2
      /FREE
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       EXSR VORLAUF;
       EXSR ETRPA;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       IF WKTRPATEEW = *ON;
         EXSR VERARB;
       ENDIF;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKCHPN = DAPROG;
         WKCHPL = DABIBL;
         WKUSER = DAUSER;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;
         WKNEWPOS = TGNEW_OFF + 1;
         WKNEWLNG = TGNEW_LEN;
         WKOLDPOS = TGOLD_OFF + 1;
         WKOLDLNG = TGOLD_LEN;

         IF TGEVENT = '1'
           OR TGTIME = '1' AND TGEVENT <> '2';
           TEEW = %SUBST(TGPARM1:WKNEWPOS:WKNEWLNG);
         ELSE;
           TEEW = %SUBST(TGPARM1:WKOLDPOS:WKOLDLNG);
         ENDIF;

         IF TGEVENT <> '3';
           LEAVESR;
         ENDIF;

         IF WKOLDPOS <> *ZERO;                                                  // FÜR DEN FELDVERGL
           TEEWOLD = %SUBST(TGPARM1:WKOLDPOS:WKOLDLNG);
         ENDIF;

         IF WKNEWPOS <> *ZERO;
           TEEWNEW = %SUBST(TGPARM1:WKNEWPOS:WKNEWLNG);
         ENDIF;
       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG                                                      ***
       //*************************************************************************
       BEGSR VERARB;
         CLEAR DSIFST;
         DSIFST.IFSTSTAT = '00';

         SELECT;
         WHEN TGEVENT = '1';                                                    // INSERT
           DSIFST.IFSTSZAR = '1';
           DSIFST.IFSTDANA = 'TEEW';
           EXSR PRIFST;
           IF WKFENR = '0000';
             EXSR UIFST;
           ENDIF;
         WHEN TGEVENT = '2';                                                    // DELETE
           DSIFST.IFSTSZAR = '2';
           DSIFST.IFSTDANA = 'TEEW';
           EXSR PRIFST;
           IF WKFENR = '0000';
             EXSR UIFST;
           ENDIF;
         WHEN TGEVENT = '3';                                                    // UPDATE
           DSIFST.IFSTSZAR = '3';
           DSIFST.IFSTDANA = 'TEIL';
           EXSR PRUPDT;

           IF WKIFST = *ON;
             EXSR PRIFST;
               IF WKFENR = '0000';
               EXSR UIFST;
             ENDIF;
           ENDIF;
         ENDSL;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN UPDATE ÄNDERUNG                                            ***
       //*************************************************************************
       BEGSR PRUPDT;
         WKIFST = *OFF;
         WKNEWPOS = WKNEWPOS + 55;
         WKNEWLNG = WKNEWLNG - 55;
         WKOLDPOS = WKOLDPOS + 55;
         WKOLDLNG = WKOLDLNG - 55;

         IF %SUBST(TGPARM1:WKOLDPOS:WKOLDLNG) <>
           %SUBST(TGPARM1:WKNEWPOS:WKNEWLNG);
           WKIFST = *ON;
         ENDIF;
       ENDSR;
       //*************************************************************************
       //**  PRÜFEN DATEI IFST                                                 ***
       //*************************************************************************
       BEGSR PRIFST;

       WKIFST = *ON;

       KYIFSTFIRM = TEEWFIRM;
       KYIFSTSTAT = '00';
       KYIFSTDANA = DSIFST.IFSTDANA;
       KYIFSTDAKY = TEEWTENR;
       KYIFSTTSTP = *LOVAL;
       CHIDS = '03+';
       EXSR CHIFST;

       DOW WKFENR = '0000'
         AND IFSTFIRM = KYIFSTFIRM
         AND IFSTSTAT = KYIFSTSTAT
         AND IFSTDANA = KYIFSTDANA
         AND IFSTDAKY = KYIFSTDAKY;

         SELECT;
         WHEN IFSTSZAR  = '1' AND DSIFST.IFSTSZAR = '2';
           WKIFST = *OFF;
           DSIFST.IFSTTSTP = IFSTTSTP;
           DSIFST.IFSTSTAT = '90';
           LEAVE;
         WHEN IFSTSZAR  = '1' AND DSIFST.IFSTSZAR = '3';
           WKIFST = *OFF;
           DSIFST.IFSTTSTP = IFSTTSTP;
           DSIFST.IFSTSZAR = IFSTSZAR;
           DSIFST.IFSTSTAT = '00';
           LEAVE;
         WHEN IFSTSZAR  = DSIFST.IFSTSZAR;
           WKIFST = *OFF;
           DSIFST.IFSTTSTP = IFSTTSTP;
           DSIFST.IFSTSTAT = '00';
           LEAVE;
         OTHER;
           WKIFST = *ON;
           CLEAR DSIFST.IFSTTSTP;
           DSIFST.IFSTSTAT = '00';
           LEAVE;
         ENDSL;

         CHIDS = '03R';
         EXSR CHIFST;
       ENDDO;

       WKFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI IFST                                                 ***
       //*************************************************************************
       BEGSR UIFST;

       CLEAR KYTEIL;
       KYTEFI = TEEWFIRM;
       KYTENR = TEEWTENR;
       KYTEEZ = *BLANK;
       CHIDS = '01C';
       EXSR CHTEIL;

       CLEAR KYIFST;
       KYIFSTFIRM = TEEWFIRM;
       KYIFSTTSTP = DSIFST.IFSTTSTP;
       CHIDS = '01CU';
       EXSR CHIFST;

       IFSTDANA = DSIFST.IFSTDANA;
       IFSTDAKY = TEEWTENR;
       IFSTBEZ1 = TETBZ1;
       IFSTBEZ2 = TETBZ2;
       IFSTSTAT = DSIFST.IFSTSTAT;
       IFSTSZAR = DSIFST.IFSTSZAR;
       IFSTWKNR = TEWKNR;

       IFSTJNAM = DAJNAM;
       IFSTPROG = DAPROG;
       IFSTBIBL = WKCHPL;
       IFSTUSER = DAUSER;
       IFSTJZEI = %DEC(%TIME());
       IFSTJDAT = %DEC(%DATE():*ISO);

       SELECT;
       WHEN CHI(6) = *ON;
         C_EXTSTP(IFSTTSTP);
         IFSTERUS = DAUSER;
         CHIDS = '01W';
         EXSR CHIFST;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFST;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ETRPA  ERMITTELN DATEN AUS FIRMEN-PARAMETER                       ***
       //*************************************************************************
       BEGSR ETRPA;

         KYTAFI = TEEWFIRM;
         KYTATA = 'TRIGGER';
         KYTATC = 'IFST';
         KYTAPA = 'TEEW';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPATEEW = TAPCDE;
           IF WKTRPATEEW <> *ON;
             WKTRPATEEW = *OFF;
           ENDIF;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHIFST
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
