     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
      //*************************************************************************
      /TITLE  Programm für die kundenspezifischen Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 02.09.2015 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: PH 22.09.2015 DOMETIC Projekt 11427. In Rücksprache mit RE wurde
      //            die Abfrage von AFKM.AMBAST auf 1 wurde invertiert (von <> in =)
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //  SR-PRBAST: Prüfen, ob alle Kom-Scheine zu einem Auftrag den Bearbeitungs-
      //             stand (AFKM.AMBAST) <> 1 haben
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ

     D EXTREND       E DS
     D RTTREND       E DS

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
      //**  R E C H E N B E S T I M M U N G E N                               ***
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
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)
     D EXTRNDAFJJ      S                   LIKE(AMAFJJ)
     D EXTRNDAFNR      S                   LIKE(AMAFNR)

     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND

      /FREE
       EXSR UEBTREND;

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
       SELECT;
       WHEN PCPGST = 'PRBAST';
         EXSR PRBAST;
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

         KYAMFI = DAFIRM;  // AFKM
         KYTAFI = DAFIRM;  // TRPA
         KYTPFI = DAFIRM;  // TRTP
         KYTPSP = DASPCD;  // TRTP

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         SELECT;
         WHEN PCPGST = 'PRBAST';
           MONITOR;
             EXTRNDAFJJ = %INT(%SUBST(EXTRNDKEYB:01:04));
           ON-ERROR *PROGRAM;
             EXTRNDAFJJ = *ZERO;
           ENDMON;

           EXTRNDAFNR = %SUBST(EXTRNDKEYB:05);
         ENDSL;

         CLEAR RTTREND;
         RTTRNDFENR = *ZERO;

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
       //**  Prüfen, ob alle Kom-Scheine zu einem KD-Auftrag den Bearbeitungs- ***
       //**  stand (AFKM.AMBAST) <> 1 haben                                    ***
       //*************************************************************************
       BEGSR PRBAST;

         WKFENR = *ZERO;

         KYAMJJ = EXTRNDAFJJ;
         KYAMAF = EXTRNDAFNR;
         CLEAR KYAMJH;
         CLEAR KYAMKM;
         CHIDS = '06+';
         EXSR CHAFKM;
         WKFENR = *ZERO;
         DOW CHI(5) = 'J'
           AND AMFIRM = KYAMFI
           AND AMAFJJ = KYAMJJ
           AND AMAFNR = KYAMAF;

           IF AMBAST = '1';
             WKFENR = '4937';   // Auftrag momentan gesperrt.
             LEAVE;
           ENDIF;

           CHIDS = '06R';
           EXSR CHAFKM;
           WKFENR = *ZERO;
         ENDDO;

         CLEAR RTTREND;
         RTTRNDFENR = WKFENR;

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
      /COPY QCPYSRC,CHAFKM
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,PRFIRMFIRM
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
