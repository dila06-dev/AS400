     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
      //*************************************************************************
      /TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 23.09.2014 WAECO Projekt 10722
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //  SR-PRVSBD: Prüfen Versandbedingung beim generieren KD-Auftrag
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
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

     D EXFIRM        E DS

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
     D EXTRNDLFNR      S             10
     D EXTRNDVSBD      S              3
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D PCPGST          S                   LIKE(#CPGST)
     D WKPROG          S                   LIKE(RTTRNDPROG)
     D WKDANA          S                   LIKE(RTTRNDDANA)
     D WKFFLD          S                   LIKE(RTTRNDFFLD)

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

       WHEN PCPGST = 'PRVSBD';
         EXSR PRVSBD;

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

         KYTPTA = DAFIRM;  // TRTP
         KYTAFI = DAFIRM;  // TRPA

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         EXTRNDLFNR = %SUBST(EXTRNDDATE:01:10);
         EXTRNDVSBD = %SUBST(EXTRNDDATE:11:03);

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

       ENDSR;

       //*************************************************************************
       //**  KUNDENSPEZIFISCHE PRÜFUNG                                         ***
       //*************************************************************************
       BEGSR PRVSBD;

         WKFENR = '0000';

         KYTPFI = EXFIRMFIRM;
         KYTPSP = EXFIRMSPCD;
         KYTPTA = 'VSBD';
         KYTPTC = EXTRNDVSBD;
         CHIDS = '01C';
         EXSR CHTRTP;

         IF WKFENR <> *ZERO;
           RTTRNDFENR = '0977';
           RTTRNDPA03 = EXTRNDVSBD;
           RTTRNDPA04 = EXFIRMFIRM;
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'FIRM';
         KYTATC = 'LFNRKD';
         KYTAPA = EXTRNDLFNR;
         CHIDS = '01C';
         EXSR CHTRPA;

         EXFIRMFIRM = %SUBST(TAPTXT:14);
         EXSR PRFIRMFIRM;

       ENDSR;

       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM

      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
