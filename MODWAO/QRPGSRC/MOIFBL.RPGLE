     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2015')
      //*************************************************************************
      /TITLE  Programm für die diverse Steurungen in Bezug auf IFBL "Schnittstelle Belege"
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 11.11.2015 DOMETIC Projekt 11427
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //
      //  Programm für dieverse Steurungen in Bezug auf die Datei IFBL
      //  "Schnittstelle Belege"
      //
      //  SR-GNIFBL: Generieren IFBL
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D IFBL          E DS                  INZ
     D KYIFBL        E DS                  INZ

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
     D EXTRNDDANA      S                   LIKE(IFBLDANA)
     D EXTRNDJAHR      S                   LIKE(IFBLJAHR)
     D EXTRNDNMKR      S                   LIKE(IFBLNMKR)
     D EXTRNDPOSI      S                   LIKE(IFBLPOSI)
     D EXTRNDUPOS      S                   LIKE(IFBLUPOS)
     D EXTRNDWKNR      S                   LIKE(IFBLWKNR)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #IFBLTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #IFBLTSTP                          LIKE(IFBLTSTP)

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
       WHEN PCPGST = 'GNIFBL';
         EXSR GNIFBL;
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

         KYIFBLFIRM = DAFIRM; // IFBL
         KYTAFI = DAFIRM;     // TRPA
         KYTPFI = DAFIRM;     // TRTP
         KYTPSP = DASPCD;     // TRTP

       ENDSR;

       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         PCPGST = EXTRNDPGST;

         EXTRNDDANA = %SUBST(EXTRNDKEYB:01);

         MONITOR;
           EXTRNDJAHR = %INT(%SUBST(EXTRNDKEYB:11:04));
         ON-ERROR *PROGRAM;
           EXTRNDJAHR  = *ZERO;
           RCMQMHRCVPM(RCMMSGINFO: %SIZE(RCMMSGINFO):
           'RCVM0100': '*': *ZERO: '*EXCP': *BLANK: *ZERO:
           '*REMOVE': RCMERRORCODE);
         ENDMON;

         EXTRNDNMKR = %SUBST(EXTRNDKEYB:15);

         MONITOR;
           EXTRNDPOSI = %INT(%SUBST(EXTRNDKEYB:21:05));
         ON-ERROR *PROGRAM;
           EXTRNDPOSI = *ZERO;
           RCMQMHRCVPM(RCMMSGINFO: %SIZE(RCMMSGINFO):
           'RCVM0100': '*': *ZERO: '*EXCP': *BLANK: *ZERO:
           '*REMOVE': RCMERRORCODE);
         ENDMON;

         MONITOR;
           EXTRNDUPOS = %INT(%SUBST(EXTRNDKEYB:26:05));
         ON-ERROR *PROGRAM;
           EXTRNDUPOS  = *ZERO;
           RCMQMHRCVPM(RCMMSGINFO: %SIZE(RCMMSGINFO):
           'RCVM0100': '*': *ZERO: '*EXCP': *BLANK: *ZERO:
           '*REMOVE': RCMERRORCODE);
         ENDMON;

         EXTRNDWKNR = %SUBST(EXTRNDDATE:01);

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
       //**  Generieren IFBL                                                   ***
       //*************************************************************************
       BEGSR GNIFBL;

         KYIFBLDANA = EXTRNDDANA;
         KYIFBLJAHR = EXTRNDJAHR;
         KYIFBLNMKR = EXTRNDNMKR;
         KYIFBLPOSI = EXTRNDPOSI;
         KYIFBLUPOS = EXTRNDUPOS;
         CLEAR KYIFBLTSTP;
         CHIDS = '02+';
         EXSR CHIFBL;
         IF CHI(5) = 'J'
           AND IFBLFIRM = KYIFBLFIRM
           AND IFBLDANA = KYIFBLDANA
           AND IFBLJAHR = KYIFBLJAHR
           AND IFBLNMKR = KYIFBLNMKR
           AND IFBLPOSI = KYIFBLPOSI
           AND IFBLUPOS = KYIFBLUPOS;
           LEAVESR;
         ENDIF;

         CLEAR KYIFBL;
         KYIFBLFIRM = DAFIRM;
         CHIDS = '01CU';
         EXSR CHIFBL;

         IFBLDANA = EXTRNDDANA;
         IFBLJAHR = EXTRNDJAHR;
         IFBLNMKR = EXTRNDNMKR;
         IFBLPOSI = EXTRNDPOSI;
         IFBLUPOS = EXTRNDUPOS;
         IFBLWKNR = EXTRNDWKNR;
         IFBLSTAT = '00';
         IFBLSZAR = '1';

         IFBLJNAM = DAJNAM;
         IFBLPROG = DAPROG;
         IFBLBIBL = WKCHPL;
         IFBLUSER = DAUSER;
         IFBLJZEI = %DEC(%TIME());
         IFBLJDAT = %DEC(%DATE():*ISO);

         SELECT;
         WHEN CHI(6) = *ON;
           C_EXTSTP(IFBLTSTP);
           IFBLERUS = DAUSER;
           CHIDS = '01W';
           EXSR CHIFBL;
         ENDSL;

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
      /COPY QCPYSRC,CHIFBL
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXJOBA
      /COPY QCPYSRC,PRFIRMFIRM
      /COPY QCPYSRC,TRTX50
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
