     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
      //*************************************************************************
      /TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2002 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: JK 16.10.2020 dometic Projekt 16061
      //  Änderung: JK 17.11.2020 dometic Projekt 16126 Nummervergabe gem. NUKR/NUMM
      //  Änderung: JK 16.02.2021 dometic CCC 20210212-033 satzsperre auf KDDB
      //  Änderung: PH 08.12.2022 DOMETIC Projekt 220571-01. Bestücvkung KDDBZABD, KDDBVSBD und
      //            KDDBLIBD mit dem Inhalt der gleichnamigen Felder aus denm Kundenstamm KUND.
      //  Änderung: JK 28.06.2023 dometic projekt 220505 - neues werk 010 KDDB satz auch
      //            für dieses Werk zusätzlich zum werk 001
      //  Änderung: GS 30.06.2025 Case 04397352 Bestückung ZABD,VSBD,LIBD aus dem Kundenstamm
      //            wieder entfernen.
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D KDDB          E DS                  INZ
     D KYKDDB        E DS                  INZ
      //
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
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
     D WKNMKR          S              6
     D I0              S              3S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D DSKDDBKDNR      S                   LIKE(KDDBKDNR)
     D DSKDDBDBNR      S                   LIKE(KDDBDBNR)
     D DSKDDBWKNR      S                   LIKE(KDDBWKNR)
     D DSKDDBLDNR      S              3

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRNUMM
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRNUMM...
     D                 PR                  EXTPGM('TRNUMM')
     D  #EXTR02                            LIKEDS(EXTR02)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND

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
       SELECT;

       WHEN PCPGST = 'WRKDDB';
         EXSR WRKDDB;
         EXSR WRKDDB001;
         EXSR WRKDDB010;

       ENDSL;

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

       KYKDDBFIRM = DAFIRM;                                                     // KDDB
       KYKDFI     = DAFIRM;                                                     // KUND
       KYTAFI = DAFIRM;                                                         // TRPA

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

       PCPGST = EXTRNDPGST;

       KOMDS = EXTRNDKEYB;
       DSKDDBKDNR = %SUBST(KOMDS:01);
       DSKDDBLDNR = %SUBST(KOMDS:11);
       DSKDDBWKNR = %SUBST(KOMDS:14);

       CLEAR RTTREND;
       RTTRNDFENR = '0000';

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

       DAFEHL = *BLANK;
       ##RTCD = *BLANK;
       #CRTCD = *BLANK;

       IF DSKDDBKDNR <> *BLANK;
         KYKDNR = DSKDDBKDNR;
         CHIDS = '01C';
         EXSR CHKUND;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Schreiben KDDB Satz                                               ***
       //*************************************************************************
       BEGSR WRKDDB;

       CLEAR RTTREND;
       WKFENR = '0000';

       SELECT;
         WHEN DAFIRM ='01';

           SELECT;
             WHEN DSKDDBLDNR = '003';
               DSKDDBWKNR = '002';
             WHEN DSKDDBLDNR = '017';
               DSKDDBWKNR = '003';
             WHEN DSKDDBLDNR = '038';
               DSKDDBWKNR = '004';
             WHEN DSKDDBLDNR = '039';
               DSKDDBWKNR = '005';
             OTHER;
               LEAVESR;
           ENDSL;

         OTHER;
           LEAVESR;
       ENDSL;

       KYKDDBKDNR = DSKDDBKDNR;
       KYKDDBWKNR = DSKDDBWKNR;
       CHIDS = '01CU';
       EXSR CHKDDB;
       IF WKFENR = '0000'  ;
         WKFENR = '0092';
         RTTRNDFENR = WKFENR;
         CHIDS = '01F ';
         EXSR CHKDDB;
         LEAVESR;
       ELSE;
         KDDBKDNR = DSKDDBKDNR;

         EXSR EDBNR;

         KDDBDBNR = DSKDDBDBNR;
         KDDBWKNR = DSKDDBWKNR;
       //  KDDBZABD = KDZABD;
       //  KDDBVSBD = KDVSBD;
       //  KDDBLIBD = KDLIBD;

         KDDBJDAT = %DEC(%DATE:*ISO);
         KDDBJZEI = %DEC(%TIME);
         KDDBJNAM = DAJNAM;
         KDDBPROG = WKCHPN;
         KDDBBIBL = WKCHPL;
         KDDBUSER = DAUSER;

         CHIDS = '01W ';
         EXSR CHKDDB;
         WKFENR = '0000';
         RTTRNDFENR = WKFENR;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  Schreiben KDDB Satz werk 001 - generell -                         ***
       //*************************************************************************
       BEGSR WRKDDB001;

       CLEAR RTTREND;
       WKFENR = '0000';

       IF DAFIRM <> '01';
           LEAVESR;
       ENDIF;

       DSKDDBWKNR = '001';

       KYKDDBKDNR = DSKDDBKDNR;
       KYKDDBWKNR = DSKDDBWKNR;
       CHIDS = '01CU';
       EXSR CHKDDB;
       IF WKFENR = '0000'  ;
         WKFENR = '0092';
         RTTRNDFENR = WKFENR;
         CHIDS = '01F ';
         EXSR CHKDDB;
         LEAVESR;
       ELSE;
         KDDBKDNR = DSKDDBKDNR;
         KDDBDBNR = DSKDDBKDNR;
         KDDBWKNR = DSKDDBWKNR;
       //  KDDBZABD = KDZABD;
       //  KDDBVSBD = KDVSBD;
       //  KDDBLIBD = KDLIBD;

         KDDBJDAT = %DEC(%DATE:*ISO);
         KDDBJZEI = %DEC(%TIME);
         KDDBJNAM = DAJNAM;
         KDDBPROG = WKCHPN;
         KDDBBIBL = WKCHPL;
         KDDBUSER = DAUSER;

         CHIDS = '01W ';
         EXSR CHKDDB;
         WKFENR = '0000';
         RTTRNDFENR = WKFENR;
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  Schreiben KDDB Satz werk 010 - generell -                         ***
       //*************************************************************************
       BEGSR WRKDDB010;

       CLEAR RTTREND;
       WKFENR = '0000';

       IF DAFIRM <> '01';
           LEAVESR;
       ENDIF;

       DSKDDBWKNR = '010';

       KYKDDBKDNR = DSKDDBKDNR;
       KYKDDBWKNR = DSKDDBWKNR;
       CHIDS = '01CU';
       EXSR CHKDDB;
       IF WKFENR = '0000'  ;
         WKFENR = '0092';
         RTTRNDFENR = WKFENR;
         CHIDS = '01F ';
         EXSR CHKDDB;
         LEAVESR;
       ELSE;
         KDDBKDNR = DSKDDBKDNR;
         KDDBDBNR = DSKDDBKDNR;
         KDDBWKNR = DSKDDBWKNR;
       //  KDDBZABD = KDZABD;
       //  KDDBVSBD = KDVSBD;
       //  KDDBLIBD = KDLIBD;

         KDDBJDAT = %DEC(%DATE:*ISO);
         KDDBJZEI = %DEC(%TIME);
         KDDBJNAM = DAJNAM;
         KDDBPROG = WKCHPN;
         KDDBBIBL = WKCHPL;
         KDDBUSER = DAUSER;

         CHIDS = '01W ';
         EXSR CHKDDB;
         WKFENR = '0000';
         RTTRNDFENR = WKFENR;
       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ERMITELLN KDDB                                                    ***
       //*************************************************************************
       BEGSR ERKDDB;

       KYKDDBKDNR = DSKDDBKDNR;
       KYKDDBWKNR = DSKDDBWKNR;
       CHIDS = '01C';
       EXSR CHKDDB;

       RTTRNDFENR = '0000';
       %SUBST(RTTRNDDATE:01:10)= KDDBKDNR;
       %SUBST(RTTRNDDATE:11:10)= KDDBWKNR;

       ENDSR;

       //*************************************************************************
       //**  ERMITELLN Debitorennummer aus Nummernkreis                        ***
       //*************************************************************************
       BEGSR EDBNR;

       WKNMKR = *BLANK;

       SELECT;
         WHEN DAFIRM ='01';

           SELECT;
             WHEN DSKDDBLDNR = '003';
               WKNMKR = 'KDDBNL';
             WHEN DSKDDBLDNR = '017';
               WKNMKR = 'KDDBBE';
             WHEN DSKDDBLDNR = '038';
               WKNMKR = 'KDDBAT';
             WHEN DSKDDBLDNR = '039';
               WKNMKR = 'KDDBCH';
             OTHER;
               LEAVESR;
           ENDSL;

         OTHER;
           LEAVESR;
       ENDSL;

       IF WKNMKR <> *BLANK;
         KOM = *BLANK;
         %SUBST(KOMDS:1:6) = 'NUMMER';
         %SUBST(KOMDS:11:4) = '0000';
         %SUBST(KOMDS:15:6) = WKNMKR;
         #CKOMM = KOMDS;
         C_TRNUMM(EXTR02);
         KOMDS = #CKOMM;
         DSKDDBDBNR = %SUBST(KOMDS:1);

         IF WKNMKR ='KDDBNL';
           DSKDDBDBNR = '0' + %SUBST(KOMDS:1);
         ENDIF;
       ENDIF;

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
     C/COPY QCPYSRC,CHKDDB
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
