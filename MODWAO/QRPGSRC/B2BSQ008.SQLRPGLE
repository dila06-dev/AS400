**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Generierung KD-Auftrag auf Basis KD-Angebots-Positionen
//------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: MG 13.02.2026 Case #05947700 Neue Angebotsabwicklung B2B
//  ----------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, generiert einen Kunndenauftrag auf
//  Basis der angegebenen Angebotspositionen
//
//  Übergabeparameter:
//  ##FIRM      - Firma
//  ##AGNR      - KD-Angebots-Jahr/Nummer
//  ##POSI      - Pos|LF-Termin;Pos|LF-Termin;Pos|LF-Termin
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ008);
/include QCPYSRC,CTLOPTIONS

//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
/if defined(never)
/include QSYSINC/QRPGLESRC,QUSEC
/endif
/include QCPYSRC,EXPSDS
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXTYPES
/include QCPYSRC,SXTRPA

//------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//------------------------------------------------------------------------------
/include QCPYSRC,EXTRBR

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds AGKO   ext inz end-ds;
dcl-ds KYAGKO ext inz end-ds;

dcl-ds AGPA   ext inz end-ds;
dcl-ds KYAGPA ext inz end-ds;

dcl-ds AGPO   ext inz end-ds;
dcl-ds KYAGPO ext inz end-ds;

dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXTXBE ext inz end-ds;

dcl-ds EXAFKO ext inz end-ds;
dcl-ds RTAFKO ext inz end-ds;

dcl-ds EXAFKN ext inz end-ds;
dcl-ds RTAFKN ext inz end-ds;

dcl-ds EXAFPO ext inz end-ds;
dcl-ds RTAFPO ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  AFNR         varchar(11);
  FFLD         varchar(10);
  ERRMSG       varchar(132);
end-ds;

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s ##CHI      char(8);
dcl-s KEYVAR     char(4);
dcl-s WKTRPAAFAT char(3);
dcl-s WKTRPAEXAT char(3);
dcl-s EXAFKOICKZ char(1);
dcl-s I0         zoned(3);
dcl-s I1         zoned(3);
dcl-s WKFENR     char(4);
dcl-s WKFFLD     char(10);
dcl-s W$PA03     char(10);
dcl-s W$PA04     char(10);
dcl-s W$PA05     char(10);
dcl-s W$PA06     char(10);
dcl-s W$PA07     char(10);
dcl-s WKTEXT     char(132);
dcl-s wkDta      char(13) dim(99);
dcl-s wkPosi     char(4) dim(99);
dcl-s wkDate     char(8) dim(99);
dcl-s WKFIRM     like(DAFIRM);
dcl-s WKUSER     like(DAUSER);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------

//--------------------------------------------------
// Program name: C_TRFEHLC1
// Purpose:              Fehlertext ermitteln
// Returns:
// Parameter:      #WKFENR
// Parameter:      #KEYVAR
// Parameter:      #DSJNAM
// Parameter:      #DSUSER
// Parameter:      #W$PA03
// Parameter:      #W$PA04
// Parameter:      #W$PA05
// Parameter:      #W$PA06
// Parameter:      #W$PA07
// Parameter:      #W$TEXT
//--------------------------------------------------
DCL-PR C_TRFEHLC1  EXTPGM('TRFEHLC1');
  #WKFENR          LIKE(WKFENR);
  #KEYVAR          LIKE(KEYVAR);
  #DSJNAM          LIKE(DSJNAM);
  #DSUSER          LIKE(DSUSER);
  #W$PA03          LIKE(W$PA03);
  #W$PA04          LIKE(W$PA04);
  #W$PA05          LIKE(W$PA05);
  #W$PA06          LIKE(W$PA06);
  #W$PA07          LIKE(W$PA07);
  #W$TEXT          LIKE(WKTEXT);
END-PR;

//--------------------------------------------------
// Program name: C_TRAB04
// Purpose:
// Returns:
// Parameter:    #EXTR02
// Parameter:    #EXAFPO
// Parameter:    #RTAFPO
//--------------------------------------------------
dcl-pr C_TRAB04  extpgm('TRAB04');
  #EXTR02        likeds(EXTR02);
  #EXAFPO        likeds(EXAFPO);
  #RTAFPO        likeds(RTAFPO);
end-pr;

//--------------------------------------------------
// Program name: C_TRAFKO
// Purpose:
// Returns:
// Parameter:    #EXKOND
// Parameter:    #RTKOND
//--------------------------------------------------
dcl-pr C_TRAFKO  extpgm('TRAFKO');
  #EXAFKO        likeds(EXAFKO);
  #RTAFKO        likeds(RTAFKO);
end-pr;

//--------------------------------------------------
// Program name: C_TRAFKN
// Purpose:
// Returns:
// Parameter:    #EXAFKN
// Parameter:    #RTAFKN
//--------------------------------------------------
dcl-pr C_TRAFKN  extpgm('TRAFKN');
  #EXAFKN        likeds(EXAFKN);
  #RTAFKN        likeds(RTAFKN);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ008;
  dcl-pi *n;
    inFIRM char(2);
    inAGNR char(11);
    inPOSI varchar(5000);
  end-pi;

  in EXTRLD;

  if inFIRM = *BLANK;
    // Defaultwert Firmennummer
    inFIRM = '01';
  endif;

  // Setzen Datenstationsarbeitsbereich
  if DAFIRM <> inFIRM;
    KYFIRMFIRM = inFIRM;
    CHIDS = '01C';
    exsr CHFIRM;

    DAFIRM = FIRMFIRM;
    DASPCD = FIRMSPCD;
    DAJNKZ = FIRMJAKZ;
    DANEKZ = FIRMNEKZ;
    out EXTRLD;
  endif;

  // Firmenwechsel
  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  WKFENR = *zero;
  RowCount = *zero;
  clear RESULT;

  // Übernahme er Positionsnummer in einer Feldgruppe
  clear wkDta;
  clear wkPosi;
  clear wkDate;
  wkDta = %split(inPOSI: ';');
  for I0 = 1 to %elem(wkDta);
    I1 = %scan('|':wkDta(I0));
    if I1 <> *zero;
      wkPosi(I0) = %subst(wkDta(I0): 1: I1-1);
      wkDate(I0) = %subst(wkDta(I0): I1+1: 8);
    endif;
  endfor;

  // Prüfen, ob Lieferung Komplett
  KYGKJH = trdec(%subst(inAGNR: 1: 4));
  KYGKAG = %subst(inAGNR: 6: 6);
  CHIDS = '01C';
  exsr CHAGKO;
  if GKTLKZ = DAJNKZ;
    exsr PRAGPO;
  endif;

  dow WKFENR = *zero;
    // Angebot zum Auftragsdatum ungültig
    if GKGADA > %dec(%date():*iso)
      or GKGBDA < %dec(%date():*iso) and GKGBDA <> *zero;
      WKFENR = '0041';
      leave;
    endif;

    // Ermitteln Daten aus dem KD-Angebots-Art Parameter
    KYAGPAAGAT = GKAGAR;
    CHIDS = '01C';
    exsr CHAGPA;
    // Es darf kein Rahmenvertrag kopiert werden
    if AGPAANGB <> DAJNKZ;
      WKFENR = '0120';
      leave;
    endif;

    // Ermitteln Daten aus dem Kundenstamm
    KYKDNR = GKKDNR;
    CHIDS = '01C';
    exsr CHKUND;

    // Anlage KD-Auftrag
    exsr TRAFKO;
    if RTAFKOFENR <> *zero;
      WKFENR = RTAFKOFENR;
      WKFFLD = RTAFKOFFLD;
      leave;
    endif;

    // Kopieren Bewegngstexte
    exsr KTXBE;

    // Kopieren Schlusskondition
    exsr TRAFKN;

    // Kopieren KD-Angebots-Position
    exsr VAGPO;
    if RTAFPOFENR <> *zero;
      // Löschen KD-Auftrag
      clear EXAFKO;
      EXAFKOPGST = 'LIFAK ';
      EXAFKOAFJJ = RTAFKOAFJJ;
      EXAFKOAFNR = RTAFKOAFNR;
      C_TRAFKO(EXAFKO:RTAFKO);

      // Löschen KD-Auftrags-Nr
      clear RTAFKO;
      RTAFKOFENR = '0000';

      WKFENR = RTAFPOFENR;
      WKFFLD = RTAFPOFFLD;
      leave;
    endif;

    // Abschliessen KD-Auftrag
    clear EXAFKO;
    EXAFKOIFKZ = *OFF;
    EXAFKOICKZ = *ON;
    EXAFKOABKZ = *ON;
    EXAFKOPGST = 'UPAFKN';
    EXAFKOAFJJ = RTAFKOAFJJ;
    EXAFKOAFNR = RTAFKOAFNR;
    C_TRAFKO(EXAFKO:RTAFKO);

    WKFENR = '0000';
    leave;
  enddo;

  // Rückgabe der Informationen an das Programm
  RowCount += 1;
  if WKFENR = *zero;
    RESULT(RowCount).AFNR = %trim(%char(RTAFKOAFJJ) + '/' + RTAFKOAFNR);
  else;
    C_TRFEHLC1(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
        W$PA06:W$PA07:WKTEXT);
    RESULT(RowCount).FFLD = %trim(WKFFLD);
    RESULT(RowCount).ERRMSG = %trim(WKTEXT);
  endif;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    KYKDFI = DAFIRM;     // KUND
    KYGKFI = DAFIRM;     // AGKO
    KYAGPAFIRM = DAFIRM; // AGPA
    KYGPFI = DAFIRM;     // AGPO

  endsr;

//------------------------------------------------------------------------------
//  Kopieren Bewegungstexte
//------------------------------------------------------------------------------
  begsr KTXBE;

    KOM = *BLANK;
    #CUEBE = *BLANK;

    clear EXTXBE;
    EXTBCALL = 'TRAB03';
    EXTBAUSW = 'TXAFKO';
    EXTBPGCD = '3     ';
    EXTBPROG = 'MCAFKO';
    EXTBDSPF = *BLANK;
    // von
    EXTBTXAR = 'AGDA';
    EXTBJHJJ = GKAGJJ;
    EXTBAFNR = GKAGNR;
    EXTBTCDE = *BLANK;
    EXTBSPCD = *BLANK;
    // nach
    EXTBNTXA = 'AFDA';
    EXTBNJHJ = RTAFKOAFJJ;
    EXTBNAFN = RTAFKOAFNR;
    EXTBNTCD = *BLANK;
    EXTBNSPC = *BLANK;
    // Druck-Kennzeichen ???
    EXTBDRK1 = *BLANK;
    EXTBDRK2 = *BLANK;
    EXTBDRK3 = *BLANK;
    EXTBDRK4 = *BLANK;
    EXTBDRK5 = *BLANK;

    exsr TRTX55;

  endsr;

//------------------------------------------------------------------------------
//  Prüfen Lieferung komplett
//------------------------------------------------------------------------------
  begsr PRAGPO;

    KYGPJH = GKAGJJ;
    KYGPAG = GKAGNR;
    KYGPPO = *LOVAL;
    CHIDS = '01+';
    exsr CHAGPO;
    dow CHI(5) = 'J'
      and GPfirm = KYGPFI
      and GPAGJJ = KYGPJH
      and GPAGNR = KYGPAG;

      // Komplettlieferung->Pos.fehlt &3
      if %lookup(%char(GPAGPO): wkPOSI: 1) = *zero;
        WKFFLD = 'GPAGPO';
        WKFENR = '9214';
        W$PA03 = %char(GPAGPO);
        leavesr;
      endif;

      CHIDS = '01R';
      exsr CHAGPO;
    enddo;

    WKFENR = '0000';

  endsr;

//------------------------------------------------------------------------------
//  Verarbeiten AGPO
//------------------------------------------------------------------------------
  begsr VAGPO;

    for I0 = 1 to %elem(wkPOSI);
      if trdec(wkPOSI(I0)) = *zero;
        iter;
      endif;

      KYGPJH = GKAGJJ;
      KYGPAG = GKAGNR;
      KYGPPO = trdec(WKPOSI(I0));
      CHIDS = '01C';
      exsr CHAGPO;

      // Angebotsposition ist nicht vorhanden
      if CHI(5) = 'N';
        RTAFPOFENR = '1127';
        leavesr;
      endif;

      // Anlage KD-Auftrags-Position
      exsr TRAB04;
      if RTAFPOFENR <> *ZERO;
        leavesr;
      endif;

      // Kopieren Bewegungstexte
      // exsr KTXBE
    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //  Generieren Kundenauftrag auf Basis Kundenangebot
  //----------------------------------------------------------------------------
  begsr TRAFKO;

    CLEAR EXAFKO;
    EXAFKOPGST = *BLANK; // Neuanlage
    EXAFKOIFKZ = *OFF;   // externes Update
    EXAFKOICKZ = *ON;    // IC-Abwicklung
    EXAFKOAFJJ = %subdt(%date(): *years);
    EXAFKOKDNR = GKKDNR;
    //EXAFKOVSNR = GKVSNR;
    EXAFKOWKNR = GKWKNR;
    EXAFKOAFAT = WKTRPAAFAT;
    IF KDABMA = 'E';
      EXAFKOAFAT = WKTRPAEXAT;
    ENDIF;
    EXAFKOABTL = GKABTL;
    EXAFKOREF1 = GKARF1;
    EXAFKOREF2 = GKARF2;
    EXAFKOWACD = GKWACD;
    EXAFKOVSBD = GKVSBD;
    EXAFKOLIBD = GKLIBD;
    //EXAFKOLIBO = GKLIBO;
    EXAFKOZABD = GKZABD;
    EXAFKOVPEI = GKVPEI;
    EXAFKOSABE = GKSABE;
    EXAFKOSABE = 'B2B';   // FIXE Einstellung für B2B-Dometic
    EXAFKOPJNR = GKPJNR;
    C_TRAFKO(EXAFKO:RTAFKO);

  endsr;

//------------------------------------------------------------------------------
//  Update Datei AFKN
//------------------------------------------------------------------------------
  begsr TRAFKN;

    CLEAR EXAFKN;
    EXANPGCD = 'KAFKN';
    // von
    EXANKART = 'AGNR';
    EXANKOJJ = GKAGJJ;
    EXANKONR = GKAGNR;
    // nach
    EXANNKAR = 'AFNR';
    EXANNKOJ = RTAFKOAFJJ;
    EXANNKON = RTAFKOAFNR;
    C_TRAFKN(EXAFKN:RTAFKN);

  endsr;

//------------------------------------------------------------------------------
//  Update Datei AFPO
//------------------------------------------------------------------------------
  begsr TRAB04;

    // Kopieren KD-Angebot
    clear EXTR02;
    clear EXAFPO;
    clear RTAFPO;
    // nach
    %subst(#CKOMM:1:4) = %editc(RTAFKOAFJJ:'X');
    %subst(#CKOMM:5:6) = RTAFKOAFNR;
    // von
    %subst(#CKOMM:14:4) = %editc(GPAGJJ:'X');
    %subst(#CKOMM:18:6) = GPAGNR;
    %subst(#CKOMM:27:8) = wkDate(I0);
    %subst(#CKOMM:209:4) = %editc(GPAGPO:'X');
    // Druck-Kennzeichen ???
    %subst(#CKOMM:46:1) = *BLANK;
    %subst(#CKOMM:47:1) = *BLANK;
    %subst(#CKOMM:48:1) = *BLANK;
    %subst(#CKOMM:49:1) = *BLANK;
    %subst(#CKOMM:50:1) = *BLANK;
    // IC-Abwicklung (keine Formatanzeige)
    %subst(#CKOMM:207:1) = *ON;
    #CPGST = *BLANK;
    C_TRAB04(EXTR02:EXAFPO:RTAFPO);

    RTAFPOFENR = %subst(#CKOMM:16:4);
    RTAFPOFFLD = %subst(#CKOMM:20:10);
    leavesr;

    clear EXTR02;
    clear EXAFPO;
    clear RTAFPO;
    %subst(#CKOMM:01:04) = %editc(RTAFKOAFJJ:'X');
    %subst(#CKOMM:05:06) = RTAFKOAFNR;
    %subst(#CKOMM:86:04) = %editc(GPAGPO:'X');
    %subst(#CKOMM:135:15) = GPTENR;
    %subst(#CKOMM:150:11) = %editc(GPMENG:'X'); // Bestell-Menge
    %subst(#CKOMM:124:3) = GPPRAR;              // Preis-Art
    %subst(#CKOMM:161:11) = %editc(GPPREI:'X'); // Einzelpreis
    %subst(#CKOMM:173:1) = GPPDIM;              // Preisdimension
    EXAFPOKWTE = %dec(%date():*iso);
    EXAFPOLFTE = %dec(%date():*iso);
    //EXAFPOGEBI = AGGBGEBI;
    //EXAFPOFUMG = AGGBFUMG;
    //EXAFPOMEFM = AGGBMEFM;
    //IF AGGBBSMG <> *ZERO;
    //  %subst(#CKOMM:150:11) = %editc(AGGBBSMG:'X'); // Gebinde-Menge
    //endif;
    EXAFPOICKZ = *ON;                  // IC-Abwicklung
    #CPGST = 'NEUANL';
    C_TRAB04(EXTR02:EXAFPO:RTAFPO);

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPAAFAT  = getTRPACode('T1AGKO': 'DEFAULT': 'AFAT');
    WKTRPAEXAT  = getTRPACode('T1AGKO': 'DEFAULT': 'AFATEXPO');

  endsr;

  //---------------------------------------------------------------------------
  //  COPY-Module
  //---------------------------------------------------------------------------
  /include QCPYSRC,CHAGKO
  /include QCPYSRC,CHAGPA
  /include QCPYSRC,CHAGPO
  /include QCPYSRC,CHFIRM
  /include QCPYSRC,CHKUND
  /include QCPYSRC,EXJOBA
  /include QCPYSRC,TRTX55
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
