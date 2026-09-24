**FREE
ctl-opt main(WAO017);
/COPY QCPYSRC,CTLOPTIONS
//--------------------------------------------------------------------------------------------------
/TITLE Übernahme KD-Aufträge (Siegen)
//--------------------------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM
//                       Verwaltungs GmbH
//                       Jechtingerstrasse 9
//                       D-79112 Freiburg
//  ------------------------------------------------------------------------------------------------
//  Erstellt: MG 18.07.2025 Case #04264118 B2B Interface
//                 Integration Dometic Siegen
//  ------------------------------------------------------------------------------------------------
//  Änderung: MG 03.09.2025 Bei Forecasts sollen bei jeder neuen Übernahme alle Positionen gelöscht
//            und neu eingelesen werden ohneBerücksichtung der Frozen Zone.
//            Defaultkundenummer Forecast aus Programm-Tabelle WAO016TDIR
//  Änderung: MG 15.10.2025 TEAMS-Abstimmung mit Frau Jung am 15.10.2025
//            Werk 1000 Jandelsbrunn: Ist immer die Kd-Nr. 27001( 339087) oder 27005 (339083).
//            Wenn es die 27005 ist, befindet sich hinter den Kundenartikelnummern ein W.
//            Werk: 2000 (HU): Ist immer die Nr. 27007 (339085) oder 27008 (339088).
//            Wenn es die 27008 ist, befindet sich hinter den Kundenartikelnummern ein W.
//            Werk 3000 Sinntal: Ist immer die Kd Nr. 27002 (339086)
//  Änderung: MG 27.10.2025 E-Mail von IK Ermitteln Default-Kunde wenn keine Zuordnung
//  Änderung: MG 13.11.2025 Case 05834945 Jeder Auftrag, der über diese Schnittstelle generiert wird
//            muss die Versandadresse 001 haben.
//--------------------------------------------------------------------------------------------------
//  Beschreibung:
//
//  Dieses Programm wird durch das CL-Programm WAO065ST bzw. WAO065SJ
//  aufgerufen und liest aus dem Verzeichnis trend/echt/in/dsx die Datei
//  "plandaten.txt"ein und erstellt hieraus IFAK/IFAP-Sätze.
//  Zuvor werden diese Sätze ab der aktuellen KW in der IFAP gelöscht.
//
//--------------------------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//--------------------------------------------------------------------------------------------------
/include QCPYSRC,STDPGM
/include QCPYSRC,SXIFS2
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXDATE
/include QCPYSRC,SXTRPA

dcl-s SFLTDIR like(SYTPTTXT) dim(99);
dcl-s SFLKDNR like(SYTPTCDE) dim(99);

//--------------------------------------------------------------------------------------------------
//  Dateien
//--------------------------------------------------------------------------------------------------
dcl-ds AFKO   ext inz end-ds;
dcl-ds KYAFKO ext inz end-ds;

dcl-ds AFPO   ext inz end-ds;
dcl-ds KYAFPO ext inz end-ds;

dcl-ds IFAK   ext inz end-ds;

dcl-ds KPIF   ext inz end-ds;
dcl-ds KYKPIF ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds SYTP   ext inz end-ds;
dcl-ds KYSYTP ext inz end-ds;

dcl-ds TXST   ext inz end-ds;

dcl-ds W017   ext inz end-ds;
dcl-ds KYW017 ext inz end-ds;
dcl-ds WKW017 inz likeds(W017);

dcl-ds ZKUN   ext inz end-ds;
dcl-ds KYZKUN ext inz end-ds;

//--------------------------------------------------------------------------------------------------
//  Kommunikationsparameter
//--------------------------------------------------------------------------------------------------
dcl-ds EXDATE ext inz end-ds;
dcl-ds RTDATE ext inz end-ds;

dcl-ds EXAFKO ext inz end-ds;
dcl-ds RTAFKO ext inz end-ds;

dcl-ds EXAFPO ext inz end-ds;
dcl-ds RTAFPO ext inz end-ds;

dcl-ds EXFS03 ext inz end-ds;
dcl-ds RTFS03 ext inz end-ds;

dcl-ds EXFS04 ext inz end-ds;
dcl-ds RTFS04 ext inz end-ds;

dcl-ds EXIFAK ext inz end-ds;
dcl-ds RTIFAK ext inz end-ds;

dcl-ds EXIFAP ext inz end-ds;
dcl-ds RTIFAP ext inz end-ds;

dcl-ds EXIFAT ext inz end-ds;
dcl-ds RTIFAT ext inz end-ds;

dcl-ds EXIFEP ext inz end-ds;
dcl-ds RTIFEP ext inz end-ds;

dcl-ds EXTREND ext end-ds;
dcl-ds RTTREND ext end-ds;

//--------------------------------------------------------------------------------------------------
//  Interne Datenstruktur
//--------------------------------------------------------------------------------------------------
/COPY QCPYSRC,EXTRIN

//--------------------------------------------------------------------------------------------------
//  Konstanten
//--------------------------------------------------------------------------------------------------
dcl-c wkAFKOWKNR const('001');    // Werksnummer "Forecast"
dcl-c wkAFKOAFAT const('F01');    // KD-Auftrags-Art "Forecast"

dcl-C wkIFAKIFFI const('98264');  // IF-Firmen-Nr "Dometic Siegen"
dcl-C wkIFAKIFST const('20');     // IF-Firmen-Nr "Dometic Siegen"

dcl-C wkIFATIFTX const('1');      // IF-KD-Auftrag Text-At
dcl-C wkIFATIFUC const('SIEGEN'); // IF-KD-Auftrag Art
dcl-C wkIFAKVSNR const('001');    // IF-KD-Auftrag VS-Adress-Nr

//--------------------------------------------------------------------------------------------------
//  Einzelfelder
//--------------------------------------------------------------------------------------------------
dcl-s LOCAL_ROOT   char(256);
dcl-s wkDIR        char(256);
dcl-s wkFILE       char(20);
dcl-s wkTYP        char(10);
dcl-s wkROOT       char(1);
dcl-s wkTDIR       char(256);
dcl-s wkTFIL       char(50);
dcl-s wkTSTP       timestamp;
dcl-s FL           zoned(3);

dcl-s EXAFKOICKZ   char(1);

//--------------------------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//--------------------------------------------------------------------------------------------------

//--------------------------------------------------
// Program name: C_EXTSTP
// Purpose:      Ermitteln Timestamp mit Microsekunden
// Returns:
// Parameter:    #WKTSTP
//--------------------------------------------------
dcl-pr C_EXTSTP  extpgm('EXTSTP');
  #WKTSTP        like(wkTSTP);
end-pr;

//--------------------------------------------------
// Program name: C_GNIFAK
// Purpose:
// Returns:
// Parameter:    #EXIFAK
// Parameter:    #RTIFAK
//--------------------------------------------------
dcl-pr C_GNIFAK  extpgm('GNIFAK');
  #EXIFAK        likeds(EXIFAK);
  #RTIFAK        likeds(RTIFAK);
end-pr;

//--------------------------------------------------
// Program name: C_TRAB04
// Purpose:
// Returns:
// Parameter:      #EXTR02
// Parameter:      #EXAFPO
// Parameter:      #RTAFPO
//--------------------------------------------------
dcl-pr C_TRAB04    extpgm('TRAB04');
  #EXTR02          likeds(EXTR02);
  #EXAFPO          likeds(EXAFPO);
  #RTAFPO          likeds(RTAFPO);
end-pr;

//--------------------------------------------------
// Program name: C_TRAFKO
// Purpose:
// Returns:
// Parameter:      #EXAFKO
// Parameter:      #RTAFKO
//--------------------------------------------------
dcl-pr C_TRAFKO    extpgm('TRAFKO');
  #EXAFKO          likeds(EXAFKO);
  #RTAFKO          likeds(RTAFKO);
end-pr;

//--------------------------------------------------
// Program name: C_TRFS03
// Purpose:
// Returns:
// Parameter:    #EXFS03
// Parameter:    #RTFS03
//--------------------------------------------------
dcl-pr C_TRFS03  extpgm('TRFS03');
  #EXFS03        likeds(EXFS03);
  #RTFS03        likeds(RTFS03);
end-pr;

//--------------------------------------------------
// Program name: C_TRFS04
// Purpose:
// Returns:
// Parameter:    #EXFS04
// Parameter:    #RTFS04
//--------------------------------------------------
dcl-pr C_TRFS04  extpgm('TRFS04');
  #EXFS04        likeds(EXFS04);
  #RTFS04        likeds(RTFS04);
end-pr;

//--------------------------------------------------
// Program name: C_TRIFAK
// Purpose:
// Returns:
// Parameter:    #EXIFAK
// Parameter:    #RTIFAK
//--------------------------------------------------
dcl-pr C_TRIFAK  extpgm('TRIFAK');
  #EXIFAK        likeds(EXIFAK);
  #RTIFAK        likeds(RTIFAK);
end-pr;

//--------------------------------------------------
// Program name: C_TRIFAP
// Purpose:
// Returns:
// Parameter:    #EXIFAP
// Parameter:    #RTIFAP
//--------------------------------------------------
dcl-pr C_TRIFAP  extpgm('TRIFAP');
  #EXIFAP        likeds(EXIFAP);
  #RTIFAP        likeds(RTIFAP);
end-pr;

//--------------------------------------------------
// Program name: C_TRIFAT
// Purpose:
// Returns:
// Parameter:    #EXIFAT
// Parameter:    #RTIFAT
//--------------------------------------------------
dcl-pr C_TRIFAT  extpgm('TRIFAT');
  #EXIFAT        likeds(EXIFAT);
  #RTIFAT        likeds(RTIFAT);
end-pr;

//--------------------------------------------------
// Program name: C_TRIFEP
// Purpose:
// Returns:
// Parameter:    #EXIFEP
// Parameter:    #RTIFEP
//--------------------------------------------------
dcl-pr C_TRIFEP  extpgm('TRIFEP');
  #EXIFEP        likeds(EXIFEP);
  #RTIFEP        likeds(RTIFEP);
end-pr;

//--------------------------------------------------
// Program name: WAO017
// Purpose: Hauptprozedur des Programms
// Returns:
// Parameter:    #EXTREND
// Parameter:    #RTTREND
//--------------------------------------------------
dcl-pr WAO017    extpgm('WAO017');
  #EXTREND       likeds(EXTREND);
  #RTTREND       likeds(RTTREND);
end-pr;

//--------------------------------------------------------------------------------------------------
//  Programmstart
//--------------------------------------------------------------------------------------------------

dcl-proc WAO017;
  dcl-pi *n ;
    #EXTREND likeds(EXTREND);
    #RTTREND likeds(RTTREND);
  end-pi;

  //include QCPYSRC,PGINIT

  exsr UEBTREND;
  IN EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
    exsr ESYTP;
  endif;

  //------------------------------------------------------------------------------------------------
  //  Programmsteuerung
  //------------------------------------------------------------------------------------------------
  // Initialisierung des Verzeichnis
  exsr INIT;

  // Öffnen der IFS-Datei
  if RTFS03FENR = *zero;
    exsr OIFS;
    // Verarbeiten der IFS-Datei
    if RTFS03FENR = *zero;
      exsr VIFS;
    endif;
  endif;

  // Anlage KD-Aufträge "Forecast"
  exsr OW017AFKO;
  exsr VW017AFKO;

  // Anlage IF-KD-Aufträge
  exsr OW017IFAK;
  exsr VW017IFAK;

  // Anzeigen IF-KD-Aufträge
  exsr MCAUFRIFAK;

  WKFIRM = DAFIRM;
  #EXTREND = EXTREND;
  #RTTREND = RTTREND;
  return; // Ende der Main-Prozedur

  //------------------------------------------------------------------------------------------------
  //  Uebernahme Kommunikationsparamter  EXTREND
  //------------------------------------------------------------------------------------------------
  begsr UEBTREND;

    // Übernahme der Aufrufparameter in die internen Datenstrukturen
    EXTREND = #EXTREND;
    RTTREND = #RTTREND;

    clear RTTREND;
    RTTRNDFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Eröffnungszyklus
  //------------------------------------------------------------------------------------------------
  begsr ANFANG;

    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    // Firma in alle Keystrukturen setzen
    KYAKFI = DAFIRM;      // AFKO
    KYAPFI = DAFIRM;      // AFPO
    KYKPFI = DAFIRM;      // KPIF
    KYKDFI = DAFIRM;      // KUND
    KYVSFI = DAFIRM;      // KDVS
    KYSYTPFIRM = DAFIRM;  // SYTP
    KYW017FIRM = DAFIRM;  // W017
    KYKZFI = DAFIRM;      // ZKUN

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Initialisierung des Verzeichnis
  //------------------------------------------------------------------------------------------------
  begsr INIT;

    LOCAL_ROOT = %trim(EXTRNDKEYB);
    wkDIR      = %trim(LOCAL_ROOT); // Verzeichnis
    wkFILE     = %trim(EXTRNDDATE); // Datei

    if %scan('.':EXTRNDDATE) <> *zero;
      I1       = %scan('.':EXTRNDDATE);
      I2       = %len(%trimr(EXTRNDDATE));
      wkFILE   = %subst(EXTRNDDATE:1:I1-1);     // Datei
      wkTYP    = %subst(EXTRNDDATE:I1:I2-I1+1); // Typ
    endif;

    // IFS-Datei kopieren
    wkTDIR     = P_SCANRPL(EXTRNDKEYB: 'ECHT': 'ECHTSAVE'); // nach Verzeichnis
    wkTDIR     = P_SCANRPL(EXTRNDKEYB: 'TEST': 'TESTSAVE'); // nach Verzeichnis

    C_EXTSTP(wkTSTP);
    wkTFIL     = %trim(wkFILE) + %CHAR(wkTSTP);             // nach Datei

    wkROOT = *OFF;

    // Prüfen, ob Verzeichnis existiert
    clear EXFS03;
    EXFS03PGST = 'CHECK';
    EXFS03PATH = %trimr(wkDIR:'/');
    C_TRFS03(EXFS03:RTFS03);
    if RTFS03FENR = *zero;
      leavesr;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Öffnen der IFS-Datei
  //------------------------------------------------------------------------------------------------
  begsr OIFS;

    // Prüfen, ob IFS-Datei vorhanden
    clear EXFS04;
    EXFS04PGST = 'CHECK';
    EXFS04PATH = %trim(LOCAL_ROOT)+'/'+%trim(wkFILE)+%trim(wkTYP);
    C_TRFS04(EXFS04:RTFS04);

    if RTFS04FENR = *zero;
      // IFS-Datei kopieren
      trIfsFileCopy(%TRIM(LOCAL_ROOT)+'/'+%TRIM(wkFILE)+%trim(wkTYP):
          %trim(wkTDIR)+'/'+%trim(wkTFIL)+%trim(wkTYP));

      // IFS-Datei öffnen
      clear EXFS04;
      EXFS04PGST = 'OPEN';
      EXFS04PATH = %trim(LOCAL_ROOT)+'/'+%trim(wkFILE)+%trim(wkTYP);
      EXFS04AUTH = 'AAA';
      C_TRFS04(EXFS04:RTFS04);
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Verarbeiten der IFS-Datei
  //------------------------------------------------------------------------------------------------
  begsr VIFS;

    RTFS04FENR = *zero;

    dow RTFS04FENR = *zero;
      clear EXFS04;
      EXFS04PGST = 'READL';
      EXFS04PATH = %trim(LOCAL_ROOT)+'/'+%trim(wkFILE)+%trim(wkTYP);
      EXFS04FILE = %trim(wkFILE)+%trim(wkTYP);
      C_TRFS04(EXFS04:RTFS04);

      if %subst(RTFS04TEXT:1:1) <> *blank;
        exsr VTXTDATEI;
      endif;
    enddo;

    // Schliessen der tmp.Datei
    clear EXFS04;
    EXFS04PGST = 'CLOSE';
    EXFS04PATH = %trim(LOCAL_ROOT)+'/'+%trim(wkFILE)+%trim(wkTYP);
    EXFS04AUTH = 'AAA';
    C_TRFS04(EXFS04:RTFS04);

    WKFENR = trIfsFileDelete(%trim(wkDIR):%trim(wkFILE)+%trim(wkTYP));

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Verarbeiten der IFS-Datei
  //------------------------------------------------------------------------------------------------
  begsr VTXTDATEI;

    clear WKW017;
    WKW017.W017FIRM = DAFIRM;
    WKW017.W017TDIR = %trim(wkTDIR)+'/'+%trim(wkTFIL)+%trim(wkTYP);
    WKW017.W017FENR = '0000';

    // Splitten des Feldinhaltes in einzelne Felder
    RC_SPLIT = P_SPLIT(RTFS04TEXT:';');

    // Kunden-Identnummer
    WKW017.W017IDEN = RC_SPLIT_FLD(1);

    // Liefertermin
    WKW017.W017LFTE = trDateFromString(RC_SPLIT_FLD(10): C_EUR: WKFENR);
    if WKFENR <> *zero;
      WKW017.W017LFTE = *zero;
    endif;

    // Forecast
    WKW017.W017PLMG = trDec(RC_SPLIT_FLD(11));

    // Bestellnummer
    WKW017.W017REFN = RC_SPLIT_FLD(12);

    // Bestellposition
    WKW017.W017BEPO = trDec(RC_SPLIT_FLD(13));

    // Bestelldatum
    WKW017.W017BEDA = trDateFromString(RC_SPLIT_FLD(14): C_EUR: WKFENR);
    if WKFENR <> *zero;
      WKW017.W017BEDA = *zero;
    endif;

    // Kundenname
    WKW017.W017TEXT = RC_SPLIT_FLD(15);

    if %trim(WKW017.W017TEXT) = 'Werk 1000'    // Werk 1000 Jandelsbrunn
      or %trim(WKW017.W017TEXT) = 'Werk 2000'; // Werk 2000 (HU)

      if WKW017.W017IDEN <> *blank;
        FL = %len(%trimr(WKW017.W017IDEN));
        if %subst(WKW017.W017IDEN:FL:1) = 'W';
          WKW017.W017TEXT = %trim(WKW017.W017TEXT) + %subst(WKW017.W017IDEN:FL:1);
        endif;
      endif;
    endif;

    if WKW017.W017TEXT <> *blank;
      // Ermitteln der Kundennummer anhand dem Kunden-Stammtext "SIEGEN"
      exec sql
        select TTKDLI into :WKW017.W017KDNR
        from  TXST
        where TTFIRM = :DAFIRM
          and TTTCDE = 'TRTX02'
          and TTSPCD = :DASPCD
          and TTUCDE = 'SIEGEN'
          and TTLFZN = 0
          and TTTEXT = :WKW017.W017TEXT;
    else;
      // Defaultkundennummer Forecast
   // if  WKW017.W017REFN = *blank;
        for FL = 1 to %elem(SFLTDIR);
          if SFLTDIR(FL) <> *blank
          and %scan(%trim(SFLTDIR(FL)):WKW017.W017TDIR) > *zero;
            WKW017.W017KDNR = SFLKDNR(FL);
          endif;
        endfor;
   // endif;
    endif;

    // Versandadresse KD-Auftrag
    if WKW017.W017REFN <> *blank
      and  WKW017.W017KDNR <> *blank;
      KYVSKD = WKW017.W017KDNR;
      KYVSNR = wkIFAKVSNR;
      CHIDS = '01C';
      exsr CHKDVS;
      if CHI(5) = 'J';
        WKW017.W017VSNR = VSVSNR;
      endif;
    endif;

    // Kundenname
    WKW017.W017TEXT = RC_SPLIT_FLD(15);

    // offenen Menge
    WKW017.W017BSMG = trdec(RC_SPLIT_FLD(19));

    // Update Datei W017
    exsr WW017;

  endsr;

  //------------------------------------------------------------------------------
  //  Öffnen CURSOR W017C1
  //------------------------------------------------------------------------------
  begsr OW017AFKO;

    WKW017.W017TDIR = %trim(wkTDIR)+'/'+%trim(wkTFIL)+%trim(wkTYP);

    EXEC SQL DECLARE W017C1 CURSOR FOR
      SELECT * FROM W017
      WHERE W017TDIR = :WKW017.W017TDIR
      AND   W017REFN = ' '
      ORDER BY W017FIRM, W017KDNR, W017TENR, W017LFTE
      FOR READ ONLY;

      EXEC SQL OPEN W017C1;

  endsr;

  //------------------------------------------------------------------------------
  //  Verarbeiten W017
  //------------------------------------------------------------------------------
  begsr VW017AFKO;

    clear WKW017;
    SQLCOD = *ZERO;

    dow SQLCOD = *ZERO;

      EXEC SQL FETCH W017C1 INTO :W017;

      if SQLCOD = *ZERO;

        if W017KDNR <> WKW017.W017KDNR
          or W017TENR <> WKW017.W017TENR;

          // Abschliessen KD-Auftrag "Forecast"
          if WKW017.W017AFJJ <> *zero
            and WKW017.W017AFNR <> *blank;
            clear EXAFKO;
            EXAFKOIFKZ = *OFF;  // externes Update
            EXAFKOICKZ = *ON;   // IC-Abwicklung
            EXAFKOABKZ = *ON;   // KD-Auftrag abschliessen
            EXAFKOPGST = 'UPAFKN';
            EXAFKOAFJJ = WKW017.W017AFJJ;
            EXAFKOAFNR = WKW017.W017AFNR;
            C_TRAFKO(EXAFKO:RTAFKO);
          endif;

          // Speichern Datensatz
          clear WKW017;
          WKW017.W017KDNR = W017KDNR;
          WKW017.W017TENR = W017TENR;

          // Prüfen, ob der Liefertermin innerhalb der Frozen-Zone liegt
          // if W017FRZO <> *zero;
               // Bestelldatum = Tagesdatum
          //   WKW017.W017BEDA = W017BEDA;
          //   if WKW017.W017BEDA = *zero;
          //     WKW017.W017BEDA = %dec(%date():*iso);
          //   endif;

          //   if W017LFTE <= trDateGetNewDate(WKW017.W017BEDA: C_ISO: C_ISO: '+': W017FRZO);
          //     WKW017.W017STAT = '50';
          //     WKW017.W017FENR = '2768'; // Der LF-termin liegt innerhalb der Frozen Zone.
          //     exsr UW017;
          //
          //     iter;
          //   endif;
          // endif;

          // Löschen Auftragspositionen "Forecast"
          exsr PRAFKO;

          // Anlage Kundenauftrag "Forecast"
          if WKW017.W017AFNR = *blank;
            exsr TRAFKO;
            if RTAFKOFENR = '0000';
              WKW017.W017STAT = '90';
              WKW017.W017FENR = RTAFKOFENR;
              WKW017.W017AFJJ = RTAFKOAFJJ;
              WKW017.W017AFNR = RTAFKOAFNR;
            else;
              WKW017.W017STAT = '50';
              WKW017.W017FENR = RTAFKOFENR;
              WKW017.W017FFLD = RTAFKOFFLD;
            endif;
          endif;
        endif;

        // Anlage Auftragsposition "Forecast"
        if WKW017.W017AFJJ <> *zero
          and WKW017.W017AFNR <> *blank;
          exsr TRAB04;
          if RTAFPOFENR = '0000';
            WKW017.W017STAT = '90';
            WKW017.W017FENR = RTAFPOFENR;
            WKW017.W017AFPO = RTAFPOAFPO;
          else;
            WKW017.W017STAT = '50';
            WKW017.W017FENR = RTAFPOFENR;
            WKW017.W017FFLD = RTAFPOFFLD;
          endif;
        endif;

        // Update Datei W017
        exsr UW017;
      endif;

    enddo;

    // Abschliessen KD-Auftrag
    if WKW017.W017AFJJ <> *zero
      and WKW017.W017AFNR <> *blank;
      clear EXAFKO;
      EXAFKOIFKZ = *OFF;  // externes Update
      EXAFKOICKZ = *ON;   // IC-Abwicklung
      EXAFKOABKZ = *ON;   // KD-Auftrag abschliessen
      EXAFKOPGST = 'UPAFKN';
      EXAFKOAFJJ = WKW017.W017AFJJ;
      EXAFKOAFNR = WKW017.W017AFNR;
      C_TRAFKO(EXAFKO:RTAFKO);
    endif;

    EXEC SQL CLOSE W017C1;

  endsr;

  //------------------------------------------------------------------------------
  //  Öffnen CURSOR W017C2
  //------------------------------------------------------------------------------
  begsr OW017IFAK;

    WKW017.W017TDIR = %trim(wkTDIR)+'/'+%trim(wkTFIL)+%trim(wkTYP);
    EXEC SQL DECLARE W017C2 CURSOR FOR

      SELECT * FROM W017
      WHERE W017TDIR = :WKW017.W017TDIR
      AND   W017REFN <> ' '
      ORDER BY W017FIRM, W017REFN, W017KDNR, W017WKNR, W017AFAT
      FOR READ ONLY;

      EXEC SQL OPEN W017C2;

  endsr;

  //------------------------------------------------------------------------------
  //  Verarbeiten W017
  //------------------------------------------------------------------------------
  begsr VW017IFAK;

    clear WKW017;
    SQLCOD = *ZERO;

    dow SQLCOD = *ZERO;

      EXEC SQL FETCH W017C2 INTO :W017;

      if SQLCOD = *ZERO;

        // Prüfen, ob der Liefertermin innerhalb der Frozen-Zone liegt
        if W017FRZO <> *zero;
          if W017LFTE <= trDateGetNewDate(W017beda: C_ISO: C_ISO: '+': W017FRZO);
            // Abschliessen IF-KD-Auftrag
            if WKW017.W017IFFI <> *blank
              and WKW017.W017IFNR <> *blank;
              PCPGST = 'ABSCHL';
              exsr TRIFAK;

              // Übernahme in KD-Auftrag
              clear EXIFAK;
              EXIFAKPGST = 'GNAFKO';
              EXIFAKIFFI = WKW017.W017IFFI;
              EXIFAKIFNR = WKW017.W017IFNR;
              EXIFAKABKZ = *on;
              C_GNIFAK(EXIFAK:RTIFAK);
            endif;

            clear WKW017;
            WKW017.W017STAT = '50';
            WKW017.W017FENR = '2768'; // Der LF-termin liegt innerhalb der Frozen Zone.
            exsr UW017;

            iter;
          endif;
        endif;

        if W017REFN <> WKW017.W017REFN
          or W017KDNR <> WKW017.W017KDNR
          or W017WKNR <> WKW017.W017WKNR
          or W017AFAT <> WKW017.W017AFAT;

          // Abschliessen IF-KD-Auftrag
          if WKW017.W017IFFI <> *blank
            and WKW017.W017IFNR <> *blank;
            PCPGST = 'ABSCHL';
            exsr TRIFAK;

            // Übernahme in KD-Auftrag
            clear EXIFAK;
            EXIFAKPGST = 'GNAFKO';
            EXIFAKIFFI = WKW017.W017IFFI;
            EXIFAKIFNR = WKW017.W017IFNR;
            EXIFAKABKZ = *on;
            C_GNIFAK(EXIFAK:RTIFAK);
          endif;

          // Prüfen, ob die Referenz bereits vorhanden
          exsr PRW017REFN;
          if WKFENR <> *zero;
            clear WKW017;
            WKW017.W017STAT = '50';
            WKW017.W017FENR = '2127'; // Ein KD-Auftrag mit dieser Referenz 1 existiert bereits.
            exsr UW017;

            iter;
          endif;

          // Speichern Datensatz
          clear WKW017;
          WKW017.W017REFN = W017REFN;
          WKW017.W017KDNR = W017KDNR;
          WKW017.W017WKNR = W017WKNR;
          WKW017.W017AFAT = W017AFAT;

          // Anlage IF-KD-Auftrag
          PCPGST = 'UPDATE';
          exsr TRIFAK;
          if RTIFAKFENR = '0000';
            WKW017.W017STAT = '90';
            WKW017.W017FENR = RTIFAKFENR;
            WKW017.W017IFFI = RTIFAKIFFI;
            WKW017.W017IFNR = RTIFAKIFNR;
          else;
            WKW017.W017STAT = '50';
            WKW017.W017FENR = RTIFAKFENR;
            WKW017.W017FFLD = RTIFAKFFLD;
          endif;

          // Anlage IF-KD-Auftrag Text (Kunden-Stammtext)
          if WKW017.W017FENR = *zero
            and WKW017.W017KDNR = *blank;
            exsr TRIFAT;
          endif;
        endif;

        // Anlage IF-KD-Audtragsposition
        if WKW017.W017IFFI <> *blank
          and WKW017.W017IFNR <> *blank;
          exsr TRIFAP;
          if RTIFAPFENR = '0000';
            WKW017.W017STAT = '90';
            WKW017.W017FENR = RTIFAPFENR;
            WKW017.W017IFPO = RTIFAPIFPO;

            // Anlage IF-KD-Audtragsposition EDI
            exsr TRIFEP;
          else;
            WKW017.W017STAT = '50';
            WKW017.W017FENR = RTIFAPFENR;
            WKW017.W017FFLD = RTIFAPFFLD;
          endif;
        endif;

        // Update Datei W017
        exsr UW017;
      endif;

    enddo;

    // Abschliessen IF-KD-Auftrag
    if WKW017.W017IFFI <> *blank
      and WKW017.W017IFNR <> *blank;
      PCPGST = 'ABSCHL';
      exsr TRIFAK;

      // Übernahme in KD-Auftrag
      clear EXIFAK;
      EXIFAKPGST = 'GNAFKO';
      EXIFAKIFFI = WKW017.W017IFFI;
      EXIFAKIFNR = WKW017.W017IFNR;
      EXIFAKABKZ = *on;
      C_GNIFAK(EXIFAK:RTIFAK);
    endif;

    EXEC SQL CLOSE W017C2;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Löschen KD-Auftragspositionen "Forecast"
  //------------------------------------------------------------------------------------------------
  begsr PRAFKO;

    exec SQL
      select AKAFJJ, AKAFNR into :WKW017.W017AFJJ, :WKW017.W017AFNR from AFKO
        where AKFIRM = :W017FIRM
        and   AKKDNR = :W017KDNR
        and   AKWKNR = :W017WKNR
        and   AKAFAT = :W017AFAT
        and   AKAFST < '90'
        and exists (select * from AFPO where APFIRM=AKFIRM and APAFJJ=AKAFJJ and APAFNR=AKAFNR
                                         and APTENR = :W017TENR)
      order by AKFIRM, AKAFJJ desc, AKAFNR desc
      fetch first 1 row only;

    SQLCOD = *zero;

    // Anlage KD-Auftrag "Forecast"
    if WKW017.W017AFNR = *blank;
      WKW017.W017AFJJ = %subdt(%date(): *YEARS);
      leavesr;
    endif;

    // Löschen KD-Auftragspositionen "Forecast"
    if WKW017.W017AFNR <> *blank;
      KYAPJH = WKW017.W017AFJJ;
      KYAPAF = WKW017.W017AFNR;
      KYAPPO = *loval;
      CHIDS = '01+';
      exsr CHAFPO;
      dow CHI(5) = 'J'
        and APFIRM = KYAPFI
        and APAFJJ = KYAPJH
        and APAFNR = KYAPAF;
        // Löschen KD-Auftragsposition außerhalb der Frozen-Zone
        // if APLFTE > trDateGetNewDate(W017beda: C_ISO: C_ISO: '+': W017FRZO);
        //   clear EXTR02;
        //   clear EXAFPO;
        //   clear RTAFPO;
        //   %SUBST(#CKOMM:01:04) = %EDITC(APAFJJ:'X');
        //   %SUBST(#CKOMM:05:06) = APAFNR;
        //   %SUBST(#CKOMM:86:04) = %EDITC(APAFPO:'X');
        //   #CPGST = '4     ';
        //   C_TRAB04(EXTR02:EXAFPO:RTAFPO);
        // endif;

        // Löschen alle KD-Auftragsposition ohneBerücksichtung der Frozen Zone
        clear EXTR02;
        clear EXAFPO;
        clear RTAFPO;
        %SUBST(#CKOMM:01:04) = %EDITC(APAFJJ:'X');
        %SUBST(#CKOMM:05:06) = APAFNR;
        %SUBST(#CKOMM:86:04) = %EDITC(APAFPO:'X');
        #CPGST = '4     ';
        C_TRAB04(EXTR02:EXAFPO:RTAFPO);

        // Neuaufsetzen
        KYAPJH = APAFJJ;
        KYAPAF = APAFNR;
        KYAPPO = APAFPO;
        CHIDS = '01+';
        exsr CHAFPO;
      enddo;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Prüfen der Referenz
  //------------------------------------------------------------------------------------------------
  begsr PRW017REFN;

    KYAKR1 = W017REFN;
    CHIDS = '09+';
    exsr CHAFKO;
    dow CHI(5) = 'J'
      and AKFIRM = KYAKFI
      and AKREF1 = KYAKR1;

      if AKKDNR = W017KDNR
        and AKWKNR = W017WKNR;
        WKFENR = '2127'; // Ein KD-Auftrag mit dieser Referenz 1 existiert bereits.
        leavesr;
      endif;

      CHIDS = '09R';
      exsr CHAFKO;
    enddo;

    exec SQL
      select count(*) into :I0 from IFAK
        where IFAKIFFI = :wkIFAKIFFI
        and   IFAKREF1 = :W017REFN
        and   IFAKKDNR = :W017KDNR
        and   IFAKWKNR = :W017WKNR
        and   IFAKIFST <= '20';

    if I0 <> *zero;
      WKFENR = '2127'; // Ein KD-Auftrag mit dieser Referenz 1 existiert bereits.
      leavesr;
    endif;

    wkfenr = '0000';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Anzeigen IF-KD-Auftrag
  //------------------------------------------------------------------------------------------------
  begsr MCAUFRIFAK;

    exec SQL
      select count(*) into :I0 from IFAK
        where IFAKIFFI = :wkIFAKIFFI
        and   IFAKIFST <= :wkIFAKIFST;

    if I0 <> *zero;
      KOM = *BLANK;
      %subst(KOMDS:1:5) = wkIFAKIFFI;
      //%subst(KOMDS:68:2) = wkIFAKIFST;
      #CPGST = *BLANK;
      #CUEBE = *BLANK;
      exsr MCIFAK;
      #CRTCD = *BLANK;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei AFKO (Anlage Kundenauftrag)
  //------------------------------------------------------------------------------------------------
  begsr TRAFKO;

    clear EXAFKO;
    EXAFKOPGST = *BLANK;  // Neuanlage
    EXAFKOIFKZ = *OFF;    // externes Update
    EXAFKOICKZ = *ON;     // IC-Abwicklung
    EXAFKOAFJJ = WKW017.W017AFJJ;
    EXAFKOAFNR = WKW017.W017AFNR;
    EXAFKOKDNR = W017KDNR;
    EXAFKOWKNR = W017WKNR;
    EXAFKOAFAT = W017AFAT;
    EXAFKOREF1 = W017REFN;
    EXAFKOBEDA = W017BEDA;
    C_TRAFKO(EXAFKO:RTAFKO);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei AFPO (Anlage Auftragsposition)
  //------------------------------------------------------------------------------------------------
  begsr TRAB04;

    clear EXTR02;
    clear EXAFPO;
    clear RTAFPO;
    %subst(#CKOMM:01:04) = %editc(WKW017.W017AFJJ:'X');
    %subst(#CKOMM:05:06) = WKW017.W017AFNR;
    %subst(#CKOMM:86:04) = %editc(W017BEPO:'X');
    %subst(#CKOMM:135:15) = W017TENR;
    %subst(#CKOMM:150:11) = %editc(W017PLMG:'X'); // Plan-Menge
    %subst(#CKOMM:208:1) = '0';                   // Formatanzeige
    EXAFPOKWTE = W017LFTE;
    EXAFPOLFTE = W017LFTE;
    EXAFPOICKZ = *ON;                  // IC-Abwicklung
    #CPGST = 'NEUANL';
    C_TRAB04(EXTR02:EXAFPO:RTAFPO);

    RTAFPOFENR = %subst(#CKOMM:16:04);
    RTAFPOFFLD = %subst(#CKOMM:20:10);
    RTAFPOPA03 = %subst(#CKOMM:30:10);
    RTAFPOPA04 = %subst(#CKOMM:40:10);
    RTAFPOPA05 = %subst(#CKOMM:50:10);
    RTAFPOPA06 = %subst(#CKOMM:60:10);
    RTAFPOPA07 = %subst(#CKOMM:70:10);

    RTAFPOAFJJ = %INT(%subst(#CKOMM:01:04));
    RTAFPOAFNR = %subst(#CKOMM:05:06);
    RTAFPOAFPO = %INT(%subst(#CKOMM:11:05));

  endsr;

  //------------------------------------------------------------------------------
  //  Update Datei IFAK
  //------------------------------------------------------------------------------
  begsr TRIFAK;

    WKW017.W017IFFI = wkIFAKIFFI; // IF-Firmen-Nr "Dometic Siegen"

    clear EXIFAK;
    EXIFAKPGST = PCPGST;
    EXIFAKIFFI = WKW017.W017IFFI;
    EXIFAKIFNR = WKW017.W017IFNR;
    EXIFAKAFAT = W017AFAT;
    EXIFAKKDNR = W017KDNR;
    EXIFAKVSNR = W017VSNR;
    EXIFAKBEDA = W017BEDA;
    EXIFAKREF1 = W017REFN;
    EXIFAKWKNR = W017WKNR;
    EXIFAKPRKZ = *off;
    C_TRIFAK(EXIFAK:RTIFAK);

  endsr;

  //------------------------------------------------------------------------------
  //  Update Datei IFAP
  //------------------------------------------------------------------------------
  begsr TRIFAP;

    clear EXIFAP;
    EXIFAPPGST = 'UPDATE';
    EXIFAPIFFI = WKW017.W017IFFI;
    EXIFAPIFNR = WKW017.W017IFNR;
    EXIFAPIFPO = W017BEPO;
    EXIFAPLFTE = W017LFTE;
    EXIFAPTENR = W017TENR;
    EXIFAPBSMG = W017BSMG;
    EXIFAPPRKZ = *off;
    EXIFAPPRER = *on;
    C_TRIFAP(EXIFAP:RTIFAP);

  endsr;

  //------------------------------------------------------------------------------
  //  Update Datei IFAT
  //------------------------------------------------------------------------------
  begsr TRIFAT;

    clear EXIFAT;
    EXIFATPGST = 'UPDATE';
    EXIFATIFFI = WKW017.W017IFFI;
    EXIFATIFNR = WKW017.W017IFNR;
    EXIFATIFTX = wkIFATIFTX;
    EXIFATIFUC = wkIFATIFUC;
    EXIFATTEXT = W017TEXT;
    EXIFATPRKZ = *off;
    C_TRIFAT(EXIFAT:RTIFAT);

  endsr;

  //------------------------------------------------------------------------------
  //  Update Datei IFEP
  //------------------------------------------------------------------------------
  begsr TRIFEP;

    clear EXIFEP;
    EXIFEPPGST = *blank;
    EXIFEPIFKZ = *on;
    EXIFEPIFFI = RTIFAPIFFI;
    EXIFEPIFNR = RTIFAPIFNR;
    EXIFEPIFPO = RTIFAPIFPO;
    EXIFEPPOSI = W017BEPO;
    EXIFEPIDEN = W017IDEN;
    EXIFEPBSMG = W017BSMG;
    C_TRIFEP(EXIFEP:RTIFEP);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei W017
  //------------------------------------------------------------------------------------------------
  begsr UW017;

    KYW017TSTP = W017TSTP;
    CHIDS = '01CU';
    exsr CHW017;

    W017IFFI = WKW017.W017IFFI;
    W017IFNR = WKW017.W017IFNR;
    W017IFPO = WKW017.W017IFPO;

    W017AFJJ = WKW017.W017AFJJ;
    W017AFNR = WKW017.W017AFNR;
    W017AFPO = WKW017.W017AFPO;

    W017STAT = WKW017.W017STAT;
    W017FENR = WKW017.W017FENR;
    W017FFLD = WKW017.W017FFLD;

    W017JNAM = DAJNAM;
    W017PROG = DAPROG;
    W017BIBL = WKCHPL;
    W017USER = DAUSER;
    W017JZEI = %DEC(%TIME());
    W017JDAT = %DEC(%DATE():*ISO);

    CHIDS = '01U';
    exsr CHW017;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei W017
  //------------------------------------------------------------------------------------------------
  begsr WW017;

    // Füllen der Datei-Felder
    W017 = WKW017;

    // Ermitteln Absatzmarkt (Inland/Export) aus dem Kundenstamm
    KYKDNR = W017KDNR;
    CHIDS = '01C';
    exsr CHKUND;
    W017ABMA = KDABMA;

    // Ermitteln der Frozen-Zone aus dem EDI-Kundenstamm
    KYKZKD = W017KDNR;
    CHIDS = '01C';
    exsr CHZKUN;
    if CHI(5) = 'N';
      KZFRZO = 28; // Frozen Zone 4 Wochen
    endif;
    W017FRZO = KZFRZO;

    // Ermitteln KD-Auftrags-Art (Emsdetten/Ungarn) aus der Kunden-Produkt-Information
    KYKPKD = W017KDNR;
    KYKPID = W017IDEN;
    CHIDS = '02C';
    exsr CHKPIF;
    W017TENR = KPTENR;
    W017VWAR = KPVWAR;

    select;
      // Forecast
      when W017REFN = *blank;
        W017WKNR = wkAFKOWKNR;
        W017AFAT = wkAFKOAFAT;
      // Emsdetten Export
      when KPVWAR = '1' and KDABMA = 'E';
        W017WKNR = '001';
        W017AFAT = '08';
      // Emsdetten
      when KPVWAR = '1';
        W017WKNR = '001';
        W017AFAT = '01';
      // Ungarn
      when KPVWAR = '2';
        W017WKNR = '008';
        W017AFAT = '59';
    endsl;

    W017JNAM = DAJNAM;
    W017PROG = DAPROG;
    W017BIBL = WKCHPL;
    W017USER = DAUSER;
    W017JZEI = %DEC(%TIME());
    W017JDAT = %DEC(%DATE():*ISO);

    C_EXTSTP(W017TSTP);
    W017ERUS = DAUSER;
    W017ERDA = %DEC(%DATE():*ISO);

    // Datensatz hinzufügen
    CHIDS = '01W';
    exsr CHW017;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //------------------------------------------------------------------------------------------------
  begsr ETRPA;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Ermitteln Defaultkundennummer Forecast
  //------------------------------------------------------------------------------------------------
  begsr ESYTP;

    clear FL;
    clear SFLTDIR;
    clear SFLKDNR;

    KYSYTPTART = 'WAO016TDIR';
    KYSYTPTCDE = *loval;
    KYSYTPTFLG = *loval;
    CHIDS = '01+';
    exsr CHSYTP;
    dow CHI(5) = 'J'
      and SYTPFIRM = KYSYTPFIRM
      and SYTPTART = KYSYTPTART;

      if SYTPTFLG = *zero;
        FL = %lookup(' ':SFLKDNR:1);
        if FL <> *zero;
          SFLKDNR(FL) = SYTPTCDE;
          SFLTDIR(FL) = SYTPTTXT;
        endif;
      endif;

      CHIDS = '01R';
      exsr CHSYTP;
    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  COPY-Module
  //------------------------------------------------------------------------------------------------
/copy QCPYSRC,CHAFKO
/copy QCPYSRC,CHAFPO
/copy QCPYSRC,CHKPIF
/copy QCPYSRC,CHKUND
/copy QCPYSRC,CHKDVS
/copy QCPYSRC,CHSYTP
/copy QCPYSRC,CHW017
/copy QCPYSRC,CHZKUN
/copy QCPYSRC,MCIFAK

end-proc;
//------------------------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------------------------

