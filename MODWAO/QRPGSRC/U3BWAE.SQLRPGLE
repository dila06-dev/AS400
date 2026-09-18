     H DECEDIT('0,') DATEDIT(*DMY.)
      //*************************************************************************
      /TITLE  Rückmelden KA (Intercompany-Abwicklung)
      //*************************************************************************
      //  Copyright 2010 by    trend SWM
      //                       Verwaltung GmbH
      //                       Ziegelhofstraße 210a
      //                       DE 79110 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: MG 15.01.2010 Gutta
      //  -----------------------------------------------------------------------
      //  Änderung: MB Datum      Referenz
      //
      //*************************************************************************
      //
      //  Rückmelden KA (Intercompany-Abwicklung)
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
      /COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
      //
     D AFPO          E DS                  INZ
      //
     D BEAF          E DS                  INZ
     D KYBEAF        E DS                  INZ
      //
     D BEAL          E DS                  INZ
     D KYBEAL        E DS                  INZ
      //
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
      //
     D BBEU          E DS                  INZ
     D KYBBEU        E DS                  INZ
      //
     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ
      //
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
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
     D WKPGST          S                   LIKE(#CPGST)
     D WKUSER          S                   LIKE(EPUSER)

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

      /FREE
       IN EXTRLD;

       EXSR ANFANG;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       EXSR OBBEP;                                                              // ÖFFNEN BBEPC1
       EXSR VBBEP;                                                              // VERARBEIT.BBEPC1

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
       //**  ÖFFENEN CURSOR BBEPC1                                             ***
       //*************************************************************************
       BEGSR OBBEP;

         EXEC SQL
         DECLARE BBEPC1 CURSOR FOR SELECT EPFIRM, EPBEJJ, EPBENR, EPBEPO,
         EPBEAT, APFIRM, APKMJJ, APKMNR
         FROM BBEP,BBEU, AFPO
         WHERE EPFIRM = EUFIRM
         AND   EPBEJJ = EUBEJJ
         AND   EPBENR = EUBENR
         AND   EPBEPO = EUBEPO
         AND   EUFIRM = APFIRM
         AND   EUAFJJ = APAFJJ
         AND   EUAFNR = APAFNR
         AND   EUAFPO = APAFPO
         AND   APFIRM = '01'
         AND   APWKNR = '010'
         AND   APAFAT = '54 '
         AND   APAFJJ = 2024
         AND   APAFNR = '718507'
         AND   APAFPO in (60, 60)
         AND   APAFST = '20'
         AND   EPGLMG > APGLMG
         ORDER BY EPFIRM, EPBEAT, EPBEJJ, EPBENR, EPBEPO
         FOR READ ONLY;

         EXEC SQL
         OPEN BBEPC1;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN BBEP                                                  ***
       //*************************************************************************
       BEGSR VBBEP;

         CLEAR KYBBEP;
         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;

           EXEC SQL
           FETCH BBEPC1 INTO :EPFIRM, :EPBEJJ, :EPBENR, :EPBEPO, :EPBEAT,
                             :APFIRM, :APKMJJ, :APKMNR;

           IF SQLCOD = *ZERO;

             IF EPFIRM <> EXFIRMFIRM;
               EXFIRMFIRM = EPFIRM;
               EXSR PRFIRMFIRM;

    2          DAFIRM = EXFIRMFIRM;
    2          DASPCD = EXFIRMSPCD;
               DAJNKZ = EXFIRMJAKZ;
               DANEKZ = EXFIRMNEKZ;
               OUT EXTRLD;
             ENDIF;

             IF PAFIRM <> EPFIRM
               OR PABEAT <> EPBEAT;
               KYPAFI = EPFIRM;
               KYPAAT = EPBEAT;
               CHIDS = '01C';
               EXSR CHBBPA;
             ENDIF;

             IF PARMKA <> DAJNKZ;
               ITER;
             ENDIF;

             IF EPFIRM <> KYEPFI
               OR EPBEJJ <> KYEPJH
               OR EPBENR <> KYEPBE;

               IF KYEPJH <> *ZERO
                 AND KYEPBE <> *BLANK;
                 WKPGST = '*IN071';
                 EXSR TRBA58;
               ENDIF;

             ENDIF;

             EXSR VBWAE;

             WKPGST = 'A     ';
             KYEPFI = EPFIRM;
             KYEPJH = EPBEJJ;
             KYEPBE = EPBENR;
             KYEPPO = EPBEPO;
             EXSR TRBA58;

           ENDIF;

         ENDDO;

         IF KYEPJH <> *ZERO
           AND KYEPBE <> *BLANK;
           WKPGST = '*IN071';
           EXSR TRBA58;
         ENDIF;

         EXEC SQL
         CLOSE BBEPC1;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITEN BWAE                                                  ***
       //*************************************************************************
       BEGSR VBWAE;

         KYAEFI = EPFIRM;
         KYAEJH = EPBEJJ;
         KYAEBE = EPBENR;
         KYAEPO = EPBEPO;
         CHIDS = '01+';
         EXSR CHBWAE;

         DOW CHI(5) = 'J'
           AND AEFIRM = KYAEFI
           AND AEBEJJ = KYAEJH
           AND AEBENR = KYAEBE
           AND AEBEPO = KYAEPO;

           EXSR UBEAL;

           // Ermitteln LS-Datum
           KYKLFI = KYBEALFIRM;
           KYKLJH = KYBEALLIJJ;
           KYKLLI = KYBEALLINR;
           CHIDS = '01C';
           exsr CHAFLK;

           CHIDS = '01R';
           EXSR CHBWAE;
         ENDDO;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI BEAL                                                 ***
       //*************************************************************************
       BEGSR UBEAL;

         KYBEAFFIRM  = EPFIRM;
         KYBEAFBEJJ  = EPBEJJ;
         KYBEAFBENR  = EPBENR;
         KYBEAFBEPO  = EPBEPO;
         CHIDS = '01C';
         EXSR CHBEAF;

         IF CHI(5) = 'J';
           KYBEALFIRM  = BEAFAFFI;
           KYBEALLIJJ  = %INT(%SUBST(AEBLIN:1:4));
           KYBEALLINR  = %SUBST(AEBLIN:6:6);
           CHIDS = '01CU';
           EXSR CHBEAL;

           SELECT;
           WHEN CHI(6) = *OFF
             AND BEALBZLI <> *BLANK;
             CHIDS = '01F';
             EXSR CHBEAL;
           WHEN CHI(6) = *OFF
             AND BEALBZKM = APKMNR;
             CHIDS = '01F';
             EXSR CHBEAL;
           WHEN CHI(6) = *OFF;
             BEALBZKJ = APKMJJ;
             BEALBZKM = APKMNR;

             CHIDS = '01U';
             EXSR CHBEAL;
           ENDSL;
         ENDIF;

       ENDSR;
       //*************************************************************************
       //**  RÜCKMELDEN KUNDENAUFTRAG                                          ***
       //*************************************************************************
       BEGSR TRBA58;

         KOM = *BLANK;
         DUN040 = KYEPJH;
         %SUBST(KOMDS:01) = DUC004;
         %SUBST(KOMDS:05) = KYEPBE;
         DUN040 = KYEPPO;
         %SUBST(KOMDS:11) = DUC004;
         DUN040 = *ZERO;
         %SUBST(KOMDS:15) = DUC004;
         %SUBST(KOMDS:19) = *BLANK;
         %SUBST(KOMDS:26) = KYEPFI;
         %SUBST(KOMDS:38) = %editc(KLLSDA:'X');
         #CKOMM = KOMDS;
         #CPGST = WKPGST;
         C_TRBA58(EXTR02);

       ENDSR;
       //*************************************************************************
       //**  COPY - MODULE                                                     ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHAFLK
      /COPY QCPYSRC,CHBEAF
      /COPY QCPYSRC,CHBEAL
      /COPY QCPYSRC,CHBBPA
      /COPY QCPYSRC,CHBWAE
      /COPY QCPYSRC,PRFIRMFIRM
       //*************************************************************************
       //**  E N D E  D E S   P R O G R A M M S                                ***
       //*************************************************************************
