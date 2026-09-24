     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2014')
      //*************************************************************************
      /TITLE  RECHNUNGEN FÜR UMSATZSTEUER-PRÜFUNG
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: RE 18.11.2014 für Kunde Dometic Projekt 11070
      //  -----------------------------------------------------------------------
      //*************************************************************************
      //
      //  Programm für die Ermittlung RECHNUNGEN FÜR UMSATZSTEUER-PRÜFUNG
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D WAOW          E DS                  INZ
     D KYWAOW        E DS                  INZ
      //
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
      //
     D KUEG          E DS                  INZ
     D KYKUEG        E DS                  INZ
      //
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
      //
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
      //
     D AFRK          E DS                  INZ
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
      //
     D EXTREND       E DS
     D RTTREND       E DS
      //
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
      //
      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)
     D WKSTMT          S           1000    VARYING
     D WKAFRKREDA      S                   LIKE(RKREDA)
     D WKAFRKRED2      S                   LIKE(RKREDA)
     D ADVSAFAD        DS                  LIKEDS(AFAD)
     D ADREAFAD        DS                  LIKEDS(AFAD)

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
       EXSR DWAOW;
       EXSR VAFRK;
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

       KYTAFI = DAFIRM;                                                         // TRPA
       KYADFI = DAFIRM;                                                         // AFAD
       KYKLFI = DAFIRM;                                                         // AFLK
       KYKEFI = DAFIRM;                                                         // KUEG
       KYWAOWFIRM = DAFIRM;                                                     // WAOW

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

       KOMDS = EXTRNDKEYB;

       MONITOR;
         WKAFRKREDA = %INT(%SUBST(KOMDS:1:8));
       ON-ERROR;
         WKAFRKREDA = *ZERO;
       ENDMON;

       MONITOR;
         WKAFRKRED2 = %INT(%SUBST(KOMDS:9:8));
       ON-ERROR;
         WKAFRKRED2 = *ZERO;
       ENDMON;

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
       //**  LÖSCHEN WAOW                                                      ***
       //*************************************************************************
       BEGSR DWAOW;

       WKSTMT = 'DELETE FROM WAOW WHERE WAOWFIRM = ' +
                '''' + DAFIRM + '''';
       WKSTMT += ' AND WAOWREDA >= ' +
                   %CHAR(WKAFRKREDA);
       WKSTMT += ' AND WAOWREDA <= ' +
                   %CHAR(WKAFRKRED2);

       EXEC SQL
         PREPARE SQWAOW FROM :WKSTMT;

       EXEC SQL
         EXECUTE SQWAOW;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG AFRK                                                 ***
       //*************************************************************************
       BEGSR VAFRK;

       WKSTMT = 'SELECT * FROM AFRK WHERE RKFIRM = ' +
                '''' + DAFIRM + '''';
       WKSTMT += ' AND RKREDA >= ' +
                   %CHAR(WKAFRKREDA);
       WKSTMT += ' AND RKREDA <= ' +
                   %CHAR(WKAFRKRED2);
       WKSTMT += ' ORDER BY RKFIRM, RKRGJJ, RKRGNR, RKLIJJ, RKLINR';

       EXEC SQL
         PREPARE SQAFRK FROM :WKSTMT;

       EXEC SQL
         DECLARE AFRKCU CURSOR FOR SQAFRK;

       EXEC SQL
         OPEN AFRKCU;

       DOW SQLCOD = *ZERO;

         EXEC SQL
         FETCH AFRKCU INTO :AFRK;
         IF SQLCOD <> *ZERO;
           LEAVE;
         ENDIF;

         KYKLJH = RKLIJJ;
         KYKLLI = RKLINR;
         CHIDS = '01C';
         EXSR CHAFLK;

         KYADJH = KLAFJJ;
         KYADAF = KLAFNR;
         KYADPO = *ZERO;
         KYADAA = 'ADVS';
         CHIDS = '01C';
         EXSR CHAFAD;
         IF WKFENR <> *ZERO;
           KYADAA = 'ADAG';
           CHIDS = '01C';
           EXSR CHAFAD;
         ENDIF;
         ADVSAFAD = AFAD;

         KYADJH = KLAFJJ;
         KYADAF = KLAFNR;
         KYADPO = *ZERO;
         KYADAA = 'ADRE';
         CHIDS = '01C';
         EXSR CHAFAD;
         IF WKFENR <> *ZERO;
           KYADAA = 'ADAG';
           CHIDS = '01C';
           EXSR CHAFAD;
         ENDIF;
         ADREAFAD = AFAD;

         IF RKUSTI = *BLANK;
           KYKEKD = RKRAKD;
           KYKELD = ADREAFAD.ADLAND;
           KYKEVS = *BLANK;
           CHIDS = '01C';
           EXSR CHKUEG;

           IF CHI(05) = 'N';
             KYKEKD = RKKDNR;
             KYKELD = ADREAFAD.ADLAND;
             KYKEVS = KLVSNR;
             CHIDS = '01C';
             EXSR CHKUEG;
           ENDIF;

           IF CHI(05) = 'N';
             KYKEKD = RKKDNR;
             KYKELD = ADREAFAD.ADLAND;
             KYKEVS = *BLANK;
             CHIDS = '01C';
             EXSR CHKUEG;
           ENDIF;

           RKUSTI = KEUSTI;
         ENDIF;

         EXSR UWAOW;
       ENDDO;

       EXEC SQL
         CLOSE AFRKCU;

       ENDSR;
       //************************************************************************
       //**  UPDATE DATEI WAOW                                                 **
       //************************************************************************
       BEGSR UWAOW;
         KYWAOWRGJJ = RKRGJJ;
         KYWAOWRGNR = RKRGNR;
         KYWAOWLIJJ = RKLIJJ;
         KYWAOWLINR = RKLINR;
         CHIDS = '01CU';
         EXSR CHWAOW;

         WAOWNAM1 = ADVSAFAD.ADNAM1;
         WAOWNAM2 = ADVSAFAD.ADNAM2;
         WAOWSTRA = ADVSAFAD.ADSTRA;
         WAOWPOLZ = ADVSAFAD.ADPOLZ;
         WAOWWORT = ADVSAFAD.ADWORT;
         WAOWLAND = ADVSAFAD.ADLAND;

         WAOWRNA1 = ADREAFAD.ADNAM1;
         WAOWRNA2 = ADREAFAD.ADNAM2;
         WAOWRSTR = ADREAFAD.ADSTRA;
         WAOWRPLZ = ADREAFAD.ADPOLZ;
         WAOWRWOR = ADREAFAD.ADWORT;
         WAOWRLAN = ADREAFAD.ADLAND;

         WAOWRAKD = RKRAKD;
         WAOWKDNR = RKKDNR;
         WAOWUSTI = RKUSTI;

         WAOWREDA = RKREDA;
         WAOWWAWT = RKWAWT + RKWAW2 + RKWAW3;
         WAOWMWBT = RKMWS1 + RKMWS2 + RKMWS3;
         WAOWBRSU = RKBRSU;

         WAOWJNAM = DAJNAM;
         WAOWPROG = DAPROG;
         WAOWBIBL = WKCHPL;
         WAOWUSER = DAUSER;
         WAOWJZEI = %DEC(%TIME());
         WAOWJDAT = %DEC(%DATE:*ISO);

         SELECT;
         WHEN CHI(6) = *ON;
           CHIDS = '01W';
           EXSR CHWAOW;
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHWAOW;
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
      /END-FREE
     C/COPY QCPYSRC,CHWAOW
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHKUEG
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRDATE
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
