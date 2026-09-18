     H DECEDIT('0,') DATEDIT(*DMY.)
      //*************************************************************************
      /TITLE  Releasewechsel Aktualisierungsprogramm
      //*************************************************************************
      //  Copyright 2006 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 14.06.2015 Projekt 10804
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
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
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
      //
     D TEOS          E DS                  INZ
     D KYTEOS        E DS                  INZ
      //
     D TEVP          E DS                  INZ
     D KYTEVP        E DS                  INZ
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
     D I1              S              3S 0
     D WKUSER          S                   LIKE(TEUSER)
     D DSLANG          S                   LIKE(TELANG)
     D DSBREI          S                   LIKE(TEBREI)
     D DSHOHE          S                   LIKE(TEHOHE)
     D DSGWBR          S                   LIKE(TEGWBR)
     D DSTEVPLAMM      S                   LIKE(TEVPLAMM)
     D DSTEVPBRMM      S                   LIKE(TEVPBRMM)
     D DSTEVPHOMM      S                   LIKE(TEVPHOMM)
     D DSTEVPSTGW      S                   LIKE(TEVPSTGW)
     D DSTEVPIVPE      S                   LIKE(TEVPIVPE)
      /FREE
       EXSR ANFANG;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       EXSR OTEOS;
       EXSR VTEOS;

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
       //**  ÖFFENEN CURSOR TEOSC1                                             ***
       //*************************************************************************
       BEGSR OTEOS;
         EXEC SQL
         DECLARE TEOSC1 CURSOR FOR SELECT * FROM TEOS
         WHERE TEOSKLCD = '1000'
         ORDER BY TEOSFIRM
         FOR READ ONLY;

         EXEC SQL
         OPEN TEOSC1;
       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN TEOS                                                  ***
       //*************************************************************************
       BEGSR VTEOS;
         CLEAR KYTEIL;
         CLEAR KYTEVP;
         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;
           EXEC SQL
           FETCH TEOSC1 INTO :TEOS;

           IF SQLCOD = *ZERO;
             MONITOR;
               DUN100 = %INT(TEOSMM01);
               DSLANG = DUN100/10;
             ON-ERROR;
               DSLANG = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM02);
               DSBREI = DUN100/10;
             ON-ERROR;
               DSBREI = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM03);
               DSHOHE = DUN100/10;
             ON-ERROR;
               DSHOHE = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM04);
               DSGWBR = DUN100/1000;
             ON-ERROR;
               DSGWBR = *ZERO;
             ENDMON;

             MONITOR;
               DUN100 = %INT(TEOSMM05);
               DSTEVPLAMM = DUN100;
             ON-ERROR;
               DSTEVPLAMM = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM06);
               DSTEVPBRMM = DUN100;
             ON-ERROR;
               DSTEVPBRMM = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM07);
               DSTEVPHOMM = DUN100;
             ON-ERROR;
               DSTEVPHOMM = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM08);
               DSTEVPSTGW = DUN100/1000;
             ON-ERROR;
               DSTEVPSTGW = *ZERO;
             ENDMON;
             MONITOR;
               DUN100 = %INT(TEOSMM09);
               DSTEVPIVPE = DUN100;
             ON-ERROR;
               DSTEVPIVPE = *ZERO;
             ENDMON;

             EXSR UTEIL;
             IF DSTEVPLAMM <> *ZERO
               OR DSTEVPBRMM <> *ZERO
               OR DSTEVPHOMM <> *ZERO
               OR DSTEVPSTGW <> *ZERO
               OR DSTEVPIVPE <> *ZERO;
               EXSR UTEVP;
             ENDIF;
           ENDIF;
         ENDDO;

         EXEC SQL
         CLOSE TEOSC1;
       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI TEIL                                                 ***
       //*************************************************************************
       BEGSR UTEIL;
         KYTEFI = TEOSFIRM;
         KYTENR = TEOSTENR;
         CHIDS = '01CU';
         EXSR CHTEIL;

         IF DSGWBR <> *ZERO;
           TEGWBR = DSGWBR;
         ENDIF;
         IF DSLANG <> *ZERO;
           TELANG = DSLANG;
         ENDIF;
         IF DSBREI <> *ZERO;
           TEBREI = DSBREI;
         ENDIF;
         IF DSHOHE <> *ZERO;
           TEHOHE = DSHOHE;
         ENDIF;
         IF DSLANG <> *ZERO
           AND DSBREI <> *ZERO
           AND DSHOHE <> *ZERO;
           EVAL(H) TEVOLU = (TELANG/100) * (TEBREI/100) * (TEHOHE/100);
         ENDIF;

         SELECT;
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHTEIL;
         ENDSL;
       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI TEVP                                                 ***
       //*************************************************************************
       BEGSR UTEVP;
         KYTEVPFIRM = TEOSFIRM;
         KYTEVPTENR = TEOSTENR;
         CHIDS = '01CU';
         EXSR CHTEVP;

         IF DSTEVPLAMM <> *ZERO;
           TEVPLAMM = DSTEVPLAMM;
         ENDIF;
         IF DSTEVPBRMM <> *ZERO;
           TEVPBRMM = DSTEVPBRMM;
         ENDIF;
         IF DSTEVPHOMM <> *ZERO;
           TEVPHOMM = DSTEVPHOMM;
         ENDIF;
         IF DSTEVPSTGW <> *ZERO;
           TEVPSTGW = DSTEVPSTGW;
         ENDIF;
         IF DSTEVPIVPE <> *ZERO;
           TEVPIVPE = DSTEVPIVPE;
         ENDIF;
         IF DSTEVPLAMM <> *ZERO
           AND  DSTEVPBRMM <> *ZERO
           AND DSTEVPHOMM <> *ZERO;
           EVAL(H) TEVPVOLU = (TEVPLAMM/1000) * (TEVPBRMM/1000)
                                              * (TEVPHOMM/1000);
         ENDIF;

         SELECT;
         WHEN CHI(6) = *ON;
           CHIDS = '01W';
           EXSR CHTEVP;
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHTEVP;
         ENDSL;
       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER...                                      ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEOS
     C/COPY QCPYSRC,CHTEVP
     C/COPY QCPYSRC,PRFIRMFIRM
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
