     H DECEDIT('0,') DATEDIT(*DMY.)
      //*************************************************************************
      /TITLE  Buchen WE (Intercompany-Abwicklung)
      //*************************************************************************
      //  Copyright 2009 by    trend SWM
      //                       Verwaltung GmbH
      //                       Ziegelhofstraße 210a
      //                       DE 79110 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 18.12.2009 Hawa
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Buchen WE (Intercompany-Abwicklung)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
      /COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
      //
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
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
      /COPY QCPYSRC,EXTRIN
      //
      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
      /COPY QCPYSRC,EXPSDS
      //
      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKFENR          S              4
     D I1              S              3S 0
     D WKUSER          S                   LIKE(ALUSER)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRBA58
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRBA58...
     D                 PR                  EXTPGM('TRBA58')
     D  #EXTR02                            LIKEDS(EXTR02)

      //--------------------------------------------------
      // Program name: C_TRBEAF
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRBEAF...
     D                 PR                  EXTPGM('TRBEAF')
     D  #EXTR02                            LIKEDS(EXTR02)

      //--------------------------------------------------
      // Program name: C_TRBE28
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRBE28...
     D                 PR                  EXTPGM('TRBE28')
     D  #EXTR02                            LIKEDS(EXTR02)

      /FREE
       IN EXTRLD;

       EXSR ANFANG;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       EXSR OAFLP;                                                              // ÖFFNEN AFLPC1
       EXSR VAFLP;                                                              // VERARBEIT.AFLPC1

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKCHPN = EXPSDSPROC;
         WKCHPL = EXPSDSBIBL;
         WKUSER = EXPSDSUSER;

       ENDSR;
       //*************************************************************************
       //**  ÖFFENEN CURSOR AFLPC1                                             ***
       //*************************************************************************
       BEGSR OAFLP;

         EXEC SQL
         DECLARE AFLPC1 CURSOR FOR SELECT * FROM AFLP
         WHERE AFLP.ALFIRM=:DAFIRM
         AND   AFLP.ALAFJJ=2024
         AND   AFLP.ALAFNR='650644'
         AND   EXISTS(SELECT * FROM BEAF WHERE BEAF.BEAFAFFI=AFLP.ALFIRM
                                         AND   BEAF.BEAFAFJJ=AFLP.ALAFJJ
                                         AND   BEAF.BEAFAFNR=AFLP.ALAFNR
                                         AND   BEAF.BEAFAFPO=AFLP.ALAFPO)
         ORDER BY ALFIRM, ALKMJJ, ALKMNR, ALKMPO
         FOR READ ONLY;

         EXEC SQL
         OPEN AFLPC1;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN AFLP                                                  ***
       //*************************************************************************
       BEGSR VAFLP;

         CLEAR KYAFLP;
         CLEAR BBEP;
         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;

           EXEC SQL
           FETCH AFLPC1 INTO :AFLP;

           IF SQLCOD = *ZERO;

             IF ALFIRM <> KYALFI
               OR ALKMJJ <> KYALKJ
               OR ALKMNR <> KYALKN;
               IF EPBEJJ <> *ZERO
                 AND EPBENR <> *BLANK;
                 EXSR TRBA58;                                                   // ABSCHLIESSEN KA
               ENDIF;
             ENDIF;

             EXSR TRBE28;                                                       // BUCHEN WE

             KYALFI = ALFIRM;
             KYALKJ = ALKMJJ;
             KYALKN = ALKMNR;

             KYALLD = ALLSDA;

           ENDIF;

         ENDDO;

         IF EPBEJJ <> *ZERO
           AND EPBENR <> *BLANK;
           EXSR TRBA58;                                                         // ABSCHLIESSEN KA
         ENDIF;

         EXEC SQL
         CLOSE AFLPC1;

       ENDSR;
       //*************************************************************************
       //**  RÜCKMELDEN KUNDENAUFTRAG                                          ***
       //*************************************************************************
       BEGSR TRBA58;

         DUN040 = EPBEJJ;
         %SUBST(KOMDS:01) = DUC004;
         %SUBST(KOMDS:05) = EPBENR;
         DUN040 = *ZERO;
         %SUBST(KOMDS:11) = DUC004;
         DUN040 = *ZERO;
         %SUBST(KOMDS:15) = DUC004;
         %SUBST(KOMDS:19) = *BLANK;
         %SUBST(KOMDS:38) = %editc(KYALLD:'X');
         #CKOMM = KOMDS;
         #CPGST = '*IN071';
         C_TRBA58(EXTR02);

       ENDSR;
       //*************************************************************************
       //**  BUCHEN WARENEINGANG                                               ***
       //*************************************************************************
       BEGSR TRBE28;

         // Ermitteln Bestell-Nr aus Bestell/Auftrags-Zuordnung (BEAF)
         KOM = *BLANK;
         DUN040 = *ZERO;
         %SUBST(KOMDS:1) = DUC004;
         %SUBST(KOMDS:5) = *BLANK;
         DUN040 = *ZERO;
         %SUBST(KOMDS:11) = DUC004;
         %SUBST(KOMDS:15) = ALFIRM;
         DUN040 = ALAFJJ;
         %SUBST(KOMDS:17) = DUC004;
         %SUBST(KOMDS:21) = ALAFNR;
         DUN040 = ALAFPO;
         %SUBST(KOMDS:27) = DUC004;
         #CKOMM = KOMDS;
         #CPGST = 'TRAFLP';
         C_TRBEAF(EXTR02);

         KOMDS = #CKOMM;
         KYEPFI = %SUBST(KOMDS:47);
         DUC004 = %SUBST(KOMDS:01);
         KYEPJH = DUN040;
         KYEPBE = %SUBST(KOMDS:05);
         DUC004 = %SUBST(KOMDS:11);
         KYEPPO = DUN040;
         CHIDS = '01C';
         EXSR CHBBEP;

         IF WKFENR = *ZERO
           AND EPGLMG  < EPMENG
           AND EPBEST  < '40';

           // Setzen Datenbereich *LDA
           IF EPFIRM <> EXFIRMFIRM;
             EXFIRMFIRM = EPFIRM;
             EXSR PRFIRMFIRM;

             DAFIRM = EXFIRMFIRM;
             DASPCD = EXFIRMSPCD;
             DAJNKZ = EXFIRMJAKZ;
             DANEKZ = EXFIRMNEKZ;
             OUT EXTRLD;
           ENDIF;

           // Buchen Wareneingang
           KOM = *BLANK;
           DUN040 = EPBEJJ;
           %SUBST(KOMDS:1) = DUC004;
           %SUBST(KOMDS:5) = EPBENR;
           DUN040 = EPBEPO;                                                     // POSITIONSNR
           %SUBST(KOMDS:11) = DUC004;
           %SUBST(KOMDS:15) = EPLANR;
           %SUBST(KOMDS:18) = ALSABE;
           DUN080 = *ZERO;
           %SUBST(KOMDS:21) = DUC008;
           DUN040 = ALLIJJ;
           %SUBST(KOMDS:29) = DUC004;
           %SUBST(KOMDS:33:1) = '/';
           %SUBST(KOMDS:34) = ALLINR;
           DUN040 = *ZERO;
           %SUBST(KOMDS:44) = DUC004;
           DUN040 = *ZERO;
           %SUBST(KOMDS:63) = DUC004;
           %SUBST(KOMDS:67) = *BLANK;
           DUN112 = ALGLMG;
           %SUBST(KOMDS:73) = DUC011;
           %SUBST(KOMDS:84) = ALTLKZ;
           %SUBST(KOMDS:85) = *BLANK;
           %SUBST(KOMDS:86) = *BLANK;
           %SUBST(KOMDS:87) = *BLANK;
           DUN040 = *ZERO;
           %SUBST(KOMDS:128) = DUC004;
           %SUBST(KOMDS:132) = *BLANK;
           DUN040 = *ZERO;
           %SUBST(KOMDS:138) = DUC004;
           DUN080 = *ZERO;
           %SUBST(KOMDS:142) = DUC008;
           #CKOMM = KOMDS;
           #CPGST = '1ALL  ';
           C_TRBE28(EXTR02);
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  COPY - MODULE                                                     ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHAFLP
      /COPY QCPYSRC,CHBBEP
      /COPY QCPYSRC,PRFIRMFIRM
       //*************************************************************************
       //**  E N D E  D E S   P R O G R A M M S                                ***
       //*************************************************************************
