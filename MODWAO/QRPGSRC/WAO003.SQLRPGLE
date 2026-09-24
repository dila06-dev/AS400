     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2023')
      //*************************************************************************
      /TITLE  Update Liefertermin Bestellung
      //*************************************************************************
      //  Copyright 2023 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: PH 06.04.2023 DOMETIC Projekt 230165-01
      //  -----------------------------------------------------------------------
      //  Änderung: XX XX.XX.XXXX
      //*************************************************************************
      //  Das Programm liest alle offenen Bestellpositionen (BBEP.EPBEST < '30')
      //  und BBEP.EPVSTE <> *ZERO der an das Programm übergebenen Lieferanten-Nr.
      //  berechnet den neuen Liefertermin anhand der Verschiff-Tage und aktualisiert
      //  diesen in der ensprechenden Bestellposition
      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  Konstantendefinition                                              ***
      //*************************************************************************

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BBEP          E DS                  INZ

     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXBBEP        E DS                  INZ

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXTREND       E DS

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
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKC001          S              1
     D WKN010          S              1S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D ##CHI           S              8
     D ##RTCD          S              1
     D ##PGST          S              1
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKFENR          S              4
     D EXTRNDLFNR      S                   LIKE(LFLFNR)
     D WKFIRM          S                   LIKE(DAFIRM)
     D WKUSER          S                   LIKE(DSUSER)
     D WKJDAT          S                   LIKE(DSJDAT)
     D WKJZEI          S                   LIKE(DSJZEI)

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_INZDATASTR
      // Purpose:
      // Returns:
      // Parameter:      #EXDATA
      // Parameter:      #RTDATA
      //--------------------------------------------------
     D C_INZDATASTR...
     D                 PR                  EXTPGM('INZDATASTR')
     D  #EXDATA                            LIKEDS(EXDATA)
     D  #RTDATA                            LIKEDS(RTDATA)

      //--------------------------------------------------
      // Program name: C_TRBBEP
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #EXBBEP
      //--------------------------------------------------
     D C_TRBBEP...
     D                 PR                  EXTPGM('TRBBEP')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #EXBBEP                            LIKEDS(EXBBEP)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND

      /FREE
       EXSR UEBTREND;

       IN EXTRLD;

       IF WKFIRM <> DAFIRM;
         EXSR ANFANG;
       ENDIF;

       IF WKFIRM <> DAFIRM;
         EXSR ETRPA;
       ENDIF;

       EXSR VORLAUF;

       //*************************************************************************
       //**  PROGRAMMSTEUERUNG                                                 ***
       //*************************************************************************
       EXSR OBBEP;
       EXSR VBBEP;

       WKFIRM = DAFIRM;
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

         KYLFFI = DAFIRM;               // LIEF

       ENDSR;

       //*************************************************************************
       //**  Übernahme Kommunikationsparameter EXTREND                         ***
       //*************************************************************************
       BEGSR UEBTREND;

         CLEAR EXDATA;
         CLEAR RTDATA;
         EXDATAFILE = 'EXTREND';
         EXDATADATA = EXTREND;
         C_INZDATASTR(EXDATA:RTDATA);
         EXTREND = RTDATADATA;

         EXTRNDLFNR = %SUBST(EXTRNDKEYB:01);

       ENDSR;

       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         DAFEHL = *BLANK;
         ##RTCD = *BLANK;
         #CRTCD = *BLANK;

         KYLFNR = EXTRNDLFNR;
         CHIDS  = '01C';
         EXSR CHLIEF;

       ENDSR;

       //*************************************************************************
       //**  Öffnen SQL-Cursor BBEPC1 zur Selektion der TEIL-Sätze             ***
       //*************************************************************************
       BEGSR OBBEP;

         EXEC SQL DECLARE BBEPC1 CURSOR FOR
         SELECT * FROM BBEP
         WHERE EPFIRM = :DAFIRM
           AND EPLFNR = :EXTRNDLFNR
           AND EPBEST < '30'
           AND EPVSTE <> 0
         ORDER BY EPFIRM, EPBEJJ, EPBENR, EPBEPO
         FOR FETCH ONLY;

         EXEC SQL OPEN BBEPC1;

       ENDSR;

       //*************************************************************************
       //**  Verarbeiten selektierte BBEP-Sätze                                ***
       //*************************************************************************
       BEGSR VBBEP;

         SQLCOD = *ZERO;

         DOW SQLCOD = *ZERO;

           EXEC SQL FETCH NEXT FROM BBEPC1 INTO :BBEP;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           CLEAR EXDATE;
           EXDATEDATV = EPVSTE;
           EXDATEOPCD = '+';
           EXDATEWERT = LFVSTA;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*ISO';
           EXDATEPGST = 'TRERDA';
           EXSR TRDATE;

           %SUBST(#CKOMM:01:04) = %EDITC(EPBEJJ:'X');
           %SUBST(#CKOMM:05) = EPBENR;
           %SUBST(#CKOMM:11:04) = %EDITC(EPBEPO:'X');
           #CPGST = 'IFBBEP';
           CLEAR EXBBEP;
           EXEPPROG = 'WAO003';
           EXEPBEJJ = EPBEJJ;
           EXEPBENR = EPBENR;
           EXEPBEPO = EPBEPO;
           EXEPBETE = RTDATEDATE;
           C_TRBBEP(EXTR02:EXBBEP);

         ENDDO;

         EXEC SQL CLOSE BBEPC1;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln Parameter                                               ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

       ENDSR;

       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /COPY QCPYSRC,CHLIEF
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,TRDATE
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
