**free
//*************************************************************************
/TITLE  Prüfen Identstamm Status 80
//*************************************************************************
//  Copyright 2002 by    trend SWM
//                       Verwaltungs GmbH
//                       Gundelfinger Straße 11
//                       DE 79108 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: RE 01.12.2010
//  -----------------------------------------------------------------------
//  Änderung: PH 17.01.2011 Projekt 7037. Prüfen/Setzen Status für Ausalaufartikel
//            II. Wahl
//  Änderung: RE 11.11.2013 Projekt 9939
//            Prüfen/Setzen Status für Artikel mit Status 79
//  Änderung: MG 13.10.2015 WAECO Service 20151009-013
//            Update Datei TEIL Mandant Österreich (TRTEIL)
//  Änderung: SZ 02.12.2018 Aufgrund von übermäßig vielen Aufrufen des
//            Triggers auf TEIL den Job überprüft und festgestellt, dass
//            auch bereits auf Status '90' gesetzte Artikel immer wieder
//            geändert werden.
//            Und wenn WKTEST auf Basis der Abfragen geändert wird, der
//            Update auf TEIL dann aber mit dem Inhalt von TETEST erfolgt,
//            wird sich an dem Status nie etwas ändern.
//            (UTEIL wurde durch TRTEIL ersetzt)
//  Änderung: MG 25.09.2020 DOMETIC Service 20200924-025 Der Ident-Status
//            wird aufgrund fehlende Berechtigung für den Benutzer TRDSCD nicht aktualisiert.
//            => Übergabe Abteilung "QS " für die Prüfung der Berechtigung.
//  Änderung: GS 18.05.2021 Projekt 16597 Prüfung Identstatus um weitere Lagerbereiche:
//            602,603,604,605
//  Änderung: MG 27.08.2024 Case 03841284 Prüfung des Bestands alle Lager außer 170 und 180
//************************************************************************
//
//*************************************************************************
//**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
//*************************************************************************
/COPY QCPYSRC,EXTRDR

DCL-S SFLLANR      LIKE(LDLANR) INZ DIM(999);
//*************************************************************************
//**  DATEIEN                                                           ***
//*************************************************************************
DCL-DS LBLZ        EXT INZ END-DS;
DCL-DS KYLBLZ      EXT INZ END-DS;

DCL-DS LBSD        EXT INZ END-DS;
DCL-DS KYLBSD      EXT INZ END-DS;

DCL-DS TEIL        EXT INZ END-DS;
DCL-DS KYTEIL      EXT INZ END-DS;

DCL-DS TRPA        EXT INZ END-DS;
DCL-DS KYTRPA      EXT INZ END-DS;

DCL-DS TRTP        EXT INZ END-DS;
DCL-DS KYTRTP      EXT INZ END-DS;
//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
DCL-DS EXTR01      EXT INZ END-DS;
DCL-DS EXTR02      EXT INZ END-DS;

DCL-DS EXTEIL      EXT INZ END-DS;
DCL-DS RTTEIL      EXT INZ END-DS;
//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
/COPY QCPYSRC,EXTRIN
//*************************************************************************
//**  DATENSTATIONSARBEITSBEREICH                                       ***
//*************************************************************************
DCL-DS EXTRLD      EXT DTAARA(*AUTO:*USRCTL:*LDA) END-DS;
//*************************************************************************
//**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
//*************************************************************************
/COPY QCPYSRC,EXPSDS
//*************************************************************************
//**  R E C H E N B E S T I M M U N G E N                               ***
//*************************************************************************
DCL-S WKC001       CHAR(1);
DCL-S WKN010       ZONED(1);
DCL-S ##CHI        CHAR(8);
DCL-S ##RTCD       CHAR(1);
DCL-S ##PGST       CHAR(1);
DCL-S WKRTCD       CHAR(1);
DCL-S WKFENR       CHAR(4);
DCL-S WKI000       CHAR(1);
DCL-S SF           ZONED(3);
DCL-S WKLANR       LIKE(LDLANR);
DCL-S WKLGBE       LIKE(LZLGBE);
DCL-S WKTEST       LIKE(TETEST);
DCL-S WKABC3       LIKE(TEABC3);

//*************************************************************************
//**  Externe Call-Prozeduren                                           ***
//*************************************************************************

//--------------------------------------------------
// Program name: C_TRLBB2
// Purpose:
// Returns:
// Parameter:      #EXTR02
//--------------------------------------------------
DCL-PR C_TRLBB2    EXTPGM('TRLBB2');
  #EXTR02          LIKEDS(EXTR02);
END-PR;

//--------------------------------------------------
// Program name: C_TRTEIL
// Purpose:
// Returns:
// Parameter:      #EXTEIL
// Parameter:      #RTTEIL
//--------------------------------------------------
DCL-PR C_TRTEIL    EXTPGM('TRTEIL');
  #EXTEIL          LIKEDS(EXTEIL);
  #RTTEIL          LIKEDS(RTTEIL);
END-PR;

IN EXTRLD;

IF WKI000 <> *ON;
  EXSR ANFANG;
  EXSR ETRPA;
ENDIF;

EXSR VORLAUF;
//*************************************************************************
//**  P R O G R A M M S T E U E R U N G                                 ***
//*************************************************************************
EXSR OTEIL;
EXSR VTEIL;

*INLR  = *ON;
//*************************************************************************
//**  ERÖFFNUNGSZYKLUS                                                  ***
//*************************************************************************
BEGSR ANFANG;

  WKI000 = *ON;

  WKC001 = *BLANK;
  WKN010 = *ZERO;

  KYLZFI = DAFIRM;
  KYLDFI = DAFIRM;
  KYTEFI = DAFIRM;
  KYTAFI = DAFIRM;

ENDSR;

//*************************************************************************
//**  VORLAUF                                                           ***
//*************************************************************************
BEGSR VORLAUF;

  // Füllen der Feldgruppe
  SFLLANR = *blank;

  KYLDFI = DAFIRM;
  KYLDLA = *loval;
  CHIDS = '01+';
  exsr CHLBSD;
  dow CHI(5) = 'J'
    and LDFIRM = KYLDFI;

    // Lager 170 und 180 ausschliessen
    if LDLANR = '170' or LDLANR = '180';
      CHIDS = '01R';
      exsr CHLBSD;
      iter;
    endif;

    // Lagerbereich "Auslauf Artikel II.Wahl" ausschliessen
    KYLZLB = '903';
    KYLZLA = LDLANR;
    CHIDS = '02C';
    exsr CHLBLZ;
    if CHI(5) = 'J';
      CHIDS = '01R';
      exsr CHLBSD;
      iter;
    endif;

    // Status
    if LDLDST < '90';
      SF = %lookup(*blank:SFLLANR:1);
      if SF <> *zero;
        SFLLANR(SF) = LDLANR;
      endif;
    endif;

    CHIDS = '01R';
    exsr CHLBSD;
  enddo;

ENDSR;

//*************************************************************************
//**  ERMITTELN PARAMETERWERTE                                          ***
//*************************************************************************
BEGSR ETRPA;

ENDSR;

//*************************************************************************
//**  ÖFFENEN CURSOR TEILC1                                             ***
//*************************************************************************
BEGSR OTEIL;

  EXEC SQL
      DECLARE TEILC1 CURSOR FOR SELECT * FROM TEIL
      WHERE TEFIRM = :DAFIRM
      AND   TETEST IN ('79', '80', '81', '90')
      FOR FETCH ONLY;

  EXEC SQL
      OPEN TEILC1;

ENDSR;

//*************************************************************************
//**  VTEIL                                                             ***
//*************************************************************************
BEGSR VTEIL;

  SQLCOD = *ZERO;

  DOW SQLCOD= *ZERO;
    EXEC SQL
        FETCH NEXT FROM TEILC1 INTO :TEIL;

    IF SQLCOD <> *ZERO;
      LEAVE;
    ENDIF;

    WKLGBE = *blank;
    WKLANR = *blank;

    WKTEST = TETEST;
    WKABC3 = TEABC3;

    for SF = 1 to %elem(SFLLANR);
      if SFLLANR(SF) = *blank;
        leave;
      endif;

      // Ermitteln des Bestands pro Lagernummer
      WKLANR = SFLLANR(SF);
      exsr PRTEIL;
      if WKFENR <> *zero;
        leave;
      endif;
    endfor;

    if WKFENR = *zero;
      // Ermitteln des Bestands pro Lagerbereich
      WKLGBE = '903';
      exsr PRTEIL;
      if WKFENR <> *zero;
        WKTEST = '81';
      else;
        WKTEST = '90';
      endif;

      if WKTEST = '90';
        WKABC3 = 'X';
      endif;

      if WKTEST <> TETEST or WKABC3 <> TEABC3;
        exsr TRTEIL;
      endif;
    endif;

  enddo;

endsr;

//*************************************************************************
//**  PRTEIL        Prüfen TEIL                                         ***
//*************************************************************************
BEGSR PRTEIL;

  WKFENR = *ZERO;

  KOMDS  = *BLANK;
  KOM(1) = *OFF;             // In-Haus Lager
  KOM(2) = *ON;              // Lagerbestand
  KOM(3) = *OFF;             // Lagerreservierung
  KOM(4) = *ON;              // Disposition
  KOM(5) = *OFF;             // Bedarfsplan
  %SUBST(KOMDS:6) = *BLANK;  // Lagerbereich "Produktion"
  KOM(7) = *OFF;             // Bestandsperrung

  %SUBST(KOMDS:10) = TETENR; // Identnummer
  if WKLGBE = *blank;
    %SUBST(KOMDS:25) = WKLANR; // Lagernummer
  endif;
  %SUBST(KOMDS:28) = *BLANK; // Gebinde
  %SUBST(KOMDS:43) = *BLANK; // Charge
  %SUBST(KOMDS:63) = *BLANK; // Lagerort
  KOM(105) = *ON;            // Sperrlager
  %SUBST(KOMDS:99) = WKLGBE; // Lagerbereich "Auslauf Artikel II.Wahl"
  #CKOMM = KOMDS;
  #CPGST = *BLANK;
  C_TRLBB2(EXTR02);
  KOMDS  = #CKOMM;

  DUC013 = %SUBST(KOMDS:01); // Lagerbestand
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;
  DUC013 = %SUBST(KOMDS:40); // Reservierbestand normal
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;
  DUC013 = %SUBST(KOMDS:53); // Reservierbestand Sonderaufträge
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;
  DUC013 = %SUBST(KOMDS:66); // Bestellbestand normal
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;
  DUC013 = %SUBST(KOMDS:79); // Bestellbestand Sonderaufträge
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;
  DUC013 = %SUBST(KOMDS:144); // Gesperrter Bestand
  IF DUN134 <> *ZERO;
    WKFENR = '0031';
    LEAVESR;
  ENDIF;

ENDSR;

//*************************************************************************
//**  UPDATE DATEI TEIL                                                 ***
//*************************************************************************
BEGSR TRTEIL;

  CLEAR EXTEIL;
  EXTEILPGST = '2     ';
  EXTEILIFKZ = *ON;
  EXTEILTENR = TETENR;
  EXTEILTEST = WKTEST;
  EXTEILABC3 = WKABC3;
  EXTEILABTL = 'QS ';
  C_TRTEIL(EXTEIL:RTTEIL);

ENDSR;

//*************************************************************************
//**  COPY-MODULE                                                       ***
//*************************************************************************
/COPY QCPYSRC,CHLBSD
/COPY QCPYSRC,CHLBLZ
/COPY QCPYSRC,CHTEIL
/COPY QCPYSRC,CHTRPA
//*************************************************************************
//**  ENDE DES PROGRAMMS                                                ***
//*************************************************************************
