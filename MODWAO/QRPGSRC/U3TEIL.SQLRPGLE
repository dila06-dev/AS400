     H DECEDIT('0,') DATEDIT(*DMY.)
      //*************************************************************************
      /TITLE  Releasewechsel Aktualisierungsprogramm
      //*************************************************************************
      //  Copyright 2006 by    trend SWM
      //                       Verwaltung GmbH
      //                       Gundelfinger Straße 11
      //                       DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 10.10.2006 gemäss i Sitzung vom 07.08.2006
      //  -----------------------------------------------------------------------
      //  Änderung: GS 23.10.2007 Verarbeiten der "Input-Datei" mit SQL
      //  Änderung: CG 20.03.2013 Doppelt def. WKCHPL, WKCHPN, WKUSER entfernt
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
      /FREE
       EXSR ANFANG;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       EXSR OTEIL;
       EXSR VTEIL;

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
       //**  ÖFFENEN CURSOR TEILC1                                             ***
       //*************************************************************************
       BEGSR OTEIL;
         EXEC SQL
         DECLARE TEILC1 CURSOR FOR SELECT * FROM TEIL
         ORDER BY TEFIRM
         FOR READ ONLY;

         EXEC SQL
         OPEN TEILC1;
       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN TEIL                                                  ***
       //*************************************************************************
       BEGSR VTEIL;
         CLEAR KYTEIL;
         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;
           EXEC SQL
           FETCH TEILC1 INTO :TEIL;

           IF SQLCOD = *ZERO;
             IF TEFIRM   <> EXFIRMFIRM;
               EXFIRMFIRM = TEFIRM;                                             // ERMITTELN JA/NEIN
               EXSR PRFIRMFIRM;
             ENDIF;

             KYTEOSFIRM= TEFIRM;
             KYTEOSKLCD = '1000';
             KYTEOSTENR = TETENR;
             CHIDS = '01C';
             EXSR CHTEOS;
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

             EXSR UTEIL;
           ENDIF;
         ENDDO;

         EXEC SQL
         CLOSE TEILC1;
       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI TEIL                                                 ***
       //*************************************************************************
       BEGSR UTEIL;
         KYTEFI = TEFIRM;
         KYTENR = TETENR;
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
         TEVOLU = (TELANG/100) * (TEBREI/100) * (TEHOHE/100);

         SELECT;
         WHEN CHI(6) = *OFF;
           CHIDS = '01U';
           EXSR CHTEIL;
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
     C/COPY QCPYSRC,PRFIRMFIRM
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
