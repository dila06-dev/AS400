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
      //  Erstellt: PH 03.11.2015 DOMETIC Projekt 11683
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Programm für die Kundenspezifische Prüfungen und Ermittlungen
      //
      //  SR-ERPRTN: Ermitteln Partner-Nummer
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

     D ZVDA          E DS                  INZ
     D KYZVDA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXFIRM        E DS                  INZ

     D EXTREND       E DS
     D RTTREND       E DS

     D EXTXST        E DS                  INZ

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
     D EXTRNDNTYP      S              6
     D RTTRNDPRTN      S             35
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
     D EXTRNDKDNR      S                   LIKE(ZVDAKDNR)

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
       WHEN PCPGST = 'ERPRTN';
         EXSR ERPRTN;
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

         KYTAFI = DAFIRM;     // TRPA
         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;     // TRTP
         KYZVDAFIRM = DAFIRM; // ZVDA

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         SELECT;
         WHEN PCPGST = 'ERPRTN';
           EXTRNDNTYP = %SUBST(EXTRNDDATE:01);
           EXTRNDKDNR = %SUBST(EXTRNDDATE:07);
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
       //**  Ermitteln Partner-Nr                                              ***
       //*************************************************************************
       BEGSR ERPRTN;

         CLEAR RTTRNDPRTN;

         SELECT;
         WHEN EXTRNDNTYP = 'INVOIC'
           OR EXTRNDNTYP = 'DESADV';
           KYZVDAKDNR = EXTRNDKDNR;
           CHIDS = '01C';
           EXSR CHZVDA;
           SELECT;
           WHEN EXTRNDNTYP = 'INVOIC';
             RTTRNDPRTN = ZVDAOFRE;
           WHEN EXTRNDNTYP = 'DESADV';
             RTTRNDPRTN = ZVDAOFLS;
           ENDSL;
         WHEN EXTRNDNTYP = 'ORDRSP';
           CLEAR EXTXST;
           EXTTPGCD = 'TEXT  ';
           EXTTTCDE = 'TRTX02';
           EXTTPROG = 'TRKUND';
           EXTTKDLI = EXTRNDKDNR;
           EXTTUCDE = 'ABPRTN';
           EXTTSPCD = DASPCD;
           KOMDS = *BLANK;
           #CUEBE = '0006';
           #CPGST = '5     ';
           EXSR TRTX50;
           RTTRNDPRTN = EXTTTEXT;
         ENDSL;

         CLEAR RTTREND;
         RTTRNDFENR = *ZERO;
         %SUBST(RTTRNDDATE:01) = RTTRNDPRTN;

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
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,TRTX50
      /COPY QCPYSRC,CHZVDA
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
