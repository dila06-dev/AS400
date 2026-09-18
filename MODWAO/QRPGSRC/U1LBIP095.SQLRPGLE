     H DECEDIT('0,') DATEDIT(*DMY.)
      //*************************************************************************
      /TITLE  Releasewechsel Aktualisierungsprogramm
      //*************************************************************************
      //  Copyright 2015 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: ZG 13.11.2015
      //  -----------------------------------------------------------------------
      //
      //*************************************************************************
      ///
      /// Vorbelegun neue Felder.
      ///
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D LBIP          E DS                  INZ
     D KYLBIP        E DS                  INZ
      //
      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
      //
     D EXFIRM        E DS                  INZ
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
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##PGST          S              1
     D ##RTCD          S              1
     D WKFENR          S              4
     D I1              S              5S 0
     D I2              S              5S 0
     D WKUSER          S                   LIKE(LBIPUSER)
      /FREE
       EXSR ANFANG;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       EXSR OLBIP;
       EXSR VLBIP;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;
         WKC001 = *BLANK;                                                       // INITIALISIEREN
         WKN010 = *ZERO;                                                        // FELDER

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;
       ENDSR;
       //*************************************************************************
       //**  ÖFFENEN CURSOR LBIPC1                                             ***
       //*************************************************************************
       BEGSR OLBIP;

         EXEC SQL
         DECLARE LBIPC1 CURSOR FOR SELECT * FROM LBIP
         WHERE LBIPFIRM='01' and LBIPIVJJ=2016 and LBIPIVST <'10'
               AND LBIPPOSI= 10000  AND LBIPLORT='   ' AND LBIPLANR='095'
         ORDER BY LBIPFIRM,LBIPIVJJ,LBIPIVNR,LBIPPOSI,LBIPTENR
         FOR READ ONLY;

         EXEC SQL
         OPEN LBIPC1;
       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN LBIP                                                  ***
       //*************************************************************************
       BEGSR VLBIP;

         CLEAR KYLBIP;
         SQLCOD = *ZERO;
         I1 = *ZERO;
         I2 = 10000;

         DOW SQLCOD = *ZERO;
           EXEC SQL
           FETCH LBIPC1 INTO :LBIP;

           IF SQLCOD = *ZERO;

             IF LBIPFIRM   <> EXFIRMFIRM;
               EXFIRMFIRM = LBIPFIRM;                                           // ERMITTELN JA/NEIN
               EXSR PRFIRMFIRM;
             ENDIF;

             I2 += 1;

           EXEC SQL
           UPDATE LBIP SET LBIPPOSI=:I2, LBIPSPOS=:I2 WHERE
             LBIPFIRM = :LBIPFIRM AND
             LBIPIVJJ = :LBIPIVJJ AND
             LBIPIVNR = :LBIPIVNR AND
             LBIPPOSI = :LBIPPOSI AND
             LBIPTENR = :LBIPTENR AND
             LBIPLORT = :LBIPLORT;

           ENDIF;
         ENDDO;

         EXEC SQL
         CLOSE LBIPC1;
       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,PRFIRMFIRM
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
