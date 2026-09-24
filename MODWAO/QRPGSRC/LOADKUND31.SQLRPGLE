     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2004')
      //*************************************************************************
      /TITLE  Verdichten FIBU-Sätze und Übertragen in Schnittstellendateien
      //*************************************************************************
      //  Copyright 2004 by    trend EVM
      //  -----------------------------------------------------------------------
      //  Version für SCHILLING-Buchhaltung
      //
      //  ACHTUNG - Aufruf sollte im Client erfolgen. Grün und im Dialog funktioniert
      //            die Fortschreibung der Schnittstelle nicht!
      //  -----------------------------------------------------------------------
      //  Erstellt: JK 19.10.2020
      //
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
      //
      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTRLD        EUDS                  DTAARA(*LDA)
     D  DABEGR               242    243

     D  WKTRPAFIRM     S              4
     D  WKTRPAKDST     S              2
      //*************************************************************************
     D I               S              7  0
     D WKC001          S              1
     D WKN010          S              1S 0
     D WKFENR          S              4
     D ##CHI           S              8

      //--------------------------------------------------
      // Program name: C_trkusc
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #KUND
      //--------------------------------------------------
     D C_TRKUSC...
     D                 PR                  EXTPGM('TRKUSC')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #KUND                              LIKEDS(KUND)
      //
      /FREE
       IN EXTRLD;

       EXSR ETRPA;
       I = 0;

       EXEC SQL DECLARE  KD CURSOR FOR SELECT * FROM KUND
        WHERE KDFIRM = :DAFIRM AND
        KDKDNR LIKE '31%';

       EXEC SQL OPEN KD;

       DOW SQLCOD = 0;
       EXEC SQL Fetch KD into :KUND;

       IF SQLCOD = 0;
          I += 1;
         // AT ZU A UMSCHLÜSSELN
         IF KDPOLD = 'AT' ;
          KDPOLD ='A ';
         ENDIF;
         //* SCHNITTSTELLE ZU SCHILLING AUFRUFEN
         IF KDKDST <= WKTRPAKDST;
           EXSR SCHILLING;
         ENDIF;

       ENDIF;

       ENDDO;

       EXEC SQL CLOSE KD;

       *INLR = *ON;
       //*************************************************************************
       //**  schreiben Schilling Schittstelle                                  ***
       //*************************************************************************
       BEGSR SCHILLING;

       KOMDS = *BLANK;
       //%SUBST(KOMDS:01) = DSWKNR;
       //%SUBST(KOMDS:04:10) = DSDBNR;
       //%SUBST(KOMDS:14:10) = DSLFBK;
       %SUBST(KOMDS:38:6) = 'TRKUND';
       #CKOMM = KOMDS;
       #CPGST = 'U     ';

       C_TRKUSC(EXTR02:KUND);
       Endsr;
       //*************************************************************************
       //**  ERMITTELN DER PARAMETERWERTE                                      ***
       //*************************************************************************
       BEGSR ETRPA;

        KYTAFI = DAFIRM;

        KYTATA = 'FIRM';
        KYTATC = 'BUHA';
        KYTAPA = 'FIRM';
        CHIDS = '01C';
        EXSR CHTRPA;

        IF CHI(5) = 'J'
          AND TAPCDE <> *BLANK;
          WKTRPAFIRM = TAPCDE;
        ELSE;
          WKTRPAFIRM = 'FIRM';
        ENDIF;
        // STATUS AB DEM KEINE ÜBERNAHME MEHR ERFOLGT
        WKTRPAKDST = '80';

       ENDSR;
       //*************************************************************************
       //**  DEFINITION DER WORKFELDER                                         ***
       //*************************************************************************

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
