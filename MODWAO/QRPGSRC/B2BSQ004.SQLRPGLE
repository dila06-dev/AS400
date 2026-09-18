**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittlung der Schlusskonditionen für Kunden-Nr/Versandadresse
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 05.06.Projekt Dometic Germany - B2B (Case #03777387)
//            ID 23.1 "Determining the conditions for the order preview"
//  ----------------------------------------------------------------------------
//  Änderung: PH 21.08.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 23.1 "Determining the conditions for the order preview"
//            E.Mail von RR vom 21.08.2025. Wenn keine Schlusskondition ermittelt
//            werden konnte, einen Satz mit der Kondition = 0 ausgeben.
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und berechnet die
//  Schlusskonditionen für die an das Programm übergebene Kunden-Nr, eventuell
//  eine Versand-Adress-Nr, Menge und Wert
//
//  Übergabeparameter:
//  #FIRM      - Firma
//  #KDNR      - Kunden-Nr
//  #VSNR      - Versand-Adr-Nr
//  #MENG      - Menge
//  #WERT      - Wert
//
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ004);
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

dcl-s SFLKON dim(4) inz like(RTKOS1KON1);
dcl-s SFLKOW dim(4) inz like(RTKOS1KOW1);
dcl-s SFLPRZ dim(4) inz like(RTKOS1PRZ1);
dcl-s SFLERG dim(4) inz like(RTKOSCERG1);
dcl-s SFLKUM dim(4) inz like(RTKOSCKUM1);

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds AFPA   ext inz end-ds;
dcl-ds KYAFPA ext inz end-ds;

dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds LAND   ext inz end-ds;
dcl-ds KYLAND ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXKOSC ext inz end-ds;
dcl-ds RTKOSC ext inz end-ds;

dcl-ds EXKOSC01 ext inz end-ds;
dcl-ds RTKOSC01 ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
dcl-ds WKEXKOSC01 likeds(EXKOSC01) inz;
dcl-ds AGKD       likeds(KUND) inz;

// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  CHARGE       varchar(3);
  AMOUNT       zoned(9:2);
  PERCENTAGE   char(1);
  RESULT       zoned(11:2);
  KUMUL        zoned(11:2);
  ERRMSG       varchar(10);
end-ds;

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s ##CHI      char(8);
dcl-s SF         zoned(3);
dcl-s WKMENG     zoned(11:2);
dcl-s WKWERT     zoned(11:2);
dcl-s WKFENR     char(4);
dcl-s WKFIRM     varchar(2);
dcl-s WKKDNR     varchar(10);
dcl-s WKVSNR     varchar(3);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_BRKOSC
// Purpose:
// Returns:
// Parameter:    #EXKOND
// Parameter:    #RTKOND
//--------------------------------------------------
dcl-pr C_BRKOSC  extpgm('BRKOSC');
  #EXKOSC        likeds(EXKOSC);
  #RTKOSC        likeds(RTKOSC);
end-pr;

//--------------------------------------------------
// Program name: C_ERKOSC
// Purpose:
// Returns:
// Parameter:      #EXKOSC01
// Parameter:      #RTKOSC01
//--------------------------------------------------
dcl-pr C_ERKOSC extpgm('ERKOSC');
  #EXKOSC01     likeds(EXKOSC01);
  #RTKOSC01     likeds(RTKOSC01);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ004;
  dcl-pi *n;
    #FIRM like(WKFIRM);
    #KDNR like(WKKDNR);
    #VSNR like(WKVSNR);
    #MENG zoned(11:2);
    #WERT zoned(11:2);
  end-pi;

  // Übernahme der Aufrufparameter in die internen Felder
  WKFIRM = #FIRM;
  WKKDNR = #KDNR;
  WKVSNR = #VSNR;
  WKMENG = #MENG;
  WKWERT = #WERT;

  in EXTRLD;

  if WKFIRM = *BLANK;
    // Defaultwert Firmennummer
    WKFIRM = '01';
  endif;

  // Setzen Datenstationsarbeitsbereich
  if DAFIRM <> WKFIRM;
    KYFIRMFIRM = WKFIRM;
    CHIDS = '01C';
    exsr CHFIRM;

    DAFIRM = FIRMFIRM;
    DASPCD = FIRMSPCD;
    DAJNKZ = FIRMJAKZ;
    DANEKZ = FIRMNEKZ;
    out EXTRLD;
  endif;

  exsr ANFANG;
  exsr ETRPA;

  WKFENR = *ZERO;
  RowCount = *ZERO;
  clear RESULT;

  // Ermitteln/Berechnen Schlusskonditionen
  exsr ERKOSC;

  // Rückgabe Schlusskonditionen / Ergebnis
  for SF = 1 to %elem(SFLKON);
    if SFLKON(SF) = *BLANK and SF > 1;
      leave;
    endif;

    RowCount += 1;
    RESULT(RowCount).CHARGE = %trim(SFLKON(SF));
    RESULT(RowCount).AMOUNT = SFLKOW(SF);
    if SFLPRZ(SF) = DAJNKZ;
      RESULT(RowCount).PERCENTAGE = '1';
    else;
      RESULT(RowCount).PERCENTAGE = '0';
    endif;
    RESULT(RowCount).RESULT = SFLERG(SF);
    RESULT(RowCount).KUMUL  = SFLKUM(SF);
    if SFLKON(SF) = *BLANK and SFLKUM(SF) = *ZERO;
      RESULT(RowCount).KUMUL = WKWERT;
    endif;
    RESULT(RowCount).ERRMSG = '';
  endfor;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYAAFI = DAFIRM;     // AFPA
    KYVSFI = DAFIRM;     // KDVS
    KYKDFI = DAFIRM;     // KUND

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln/Berechnen Schlusskonditionen
  //----------------------------------------------------------------------------
  begsr ERKOSC;

    // Initialisieren Feldruppen
    clear SFLKON;
    clear SFLKOW;
    clear SFLPRZ;
    clear SFLERG;
    clear SFLKUM;

    KYKDNR = WKKDNR;
    CHIDS  = '01C';
    exsr CHKUND;
    AGKD = KUND;
    if CHI(5) = 'N';
      leavesr;
    endif;

    KYLNNR = KDLAND;
    CHIDS  = '01C';
    exsr CHLAND;
    // EG-Lieferung
    if LNLDGR = '0001';
      // Normalauftrag
      KYAAAT = '01';
    else;
      // Export Normalauftrag
      KYAAAT = '08';
    endif;
    CHIDS  = '01C';
    exsr CHAFPA;

    clear WKEXKOSC01;

    // Zuerst bestücken die Felder der Work-DS WKEXKOSC01 anhand der an das Programm übergebenen
    // Auftraggeber-Kunden-Nr
    WKEXKOSC01.EXKOS1LAND = KDLAND;
    WKEXKOSC01.EXKOS1AAGR = AAAAGR;
    WKEXKOSC01.EXKOS1AFAT = AAAFAT;
    WKEXKOSC01.EXKOS1VSBD = KDVSBD;
    WKEXKOSC01.EXKOS1LIBD = KDLIBD;
    WKEXKOSC01.EXKOS1ZABD = KDZABD;
    WKEXKOSC01.EXKOS1VKGB = KDVKGB;
    WKEXKOSC01.EXKOS1POLZ = KDPOLZ;
    WKEXKOSC01.EXKOS1KDNR = KDKDNR;
    WKEXKOSC01.EXKOS1KDGR = KDKDGR;
    WKEXKOSC01.EXKOS1WACD = KDWACD;
    WKEXKOSC01.EXKOS1STCD = KDKSTC;

    if AGKD.KDKOKD <> AGKD.KDKDNR
      and AGKD.KDKOKD <> *BLANK;
      exsr ERKOKD;
      KUND = AGKD;
    endif;

    if WKVSNR <> *BLANK;
      exsr ERVSNR;
    endif;

    if AGKD.KDRAKD <> AGKD.KDKDNR
      and AGKD.KDRAKD <> *BLANK;
      exsr ERRAKD;
      KUND = AGKD;
    endif;

    // Ermitteln Schlusskonditionen
    clear EXKOSC01;
    clear RTKOSC01;

    EXKOS1VPKZ = 'V';

    EXKOS1LAND = WKEXKOSC01.EXKOS1LAND;
    EXKOS1AAGR = WKEXKOSC01.EXKOS1AAGR;
    EXKOS1AFAT = WKEXKOSC01.EXKOS1AFAT;
    EXKOS1VSBD = WKEXKOSC01.EXKOS1VSBD;
    EXKOS1LIBD = WKEXKOSC01.EXKOS1LIBD;
    EXKOS1ZABD = WKEXKOSC01.EXKOS1ZABD;
    EXKOS1VKGB = WKEXKOSC01.EXKOS1VKGB;
    EXKOS1POLZ = WKEXKOSC01.EXKOS1POLZ;
    EXKOS1KDNR = WKEXKOSC01.EXKOS1KDNR;
    EXKOS1VSNR = WKEXKOSC01.EXKOS1VSNR;
    EXKOS1KDGR = WKEXKOSC01.EXKOS1KDGR;
    EXKOS1WACD = WKEXKOSC01.EXKOS1WACD;
    EXKOS1STCD = WKEXKOSC01.EXKOS1STCD;
    EXKOS1DATE = %dec(%date():*ISO);
    EXKOS1VKMG = WKMENG;
    EXKOS1AFNT = WKWERT;
    EXKOS1RBBA = WKWERT;
    EXKOS1AFDA = %dec(%date():*ISO);

    EXKOS1PGST = *BLANK;
    C_ERKOSC(EXKOSC01:RTKOSC01);

    // Berechnen Schlusskonditionen
    exsr BRKOSC;

  endsr;

  //---------------------------------------------------------------------------
  //  SR-ERVSNR     Daten von Kundenversandadresse
  //---------------------------------------------------------------------------
  begsr ERVSNR;

    KYVSFI = DAFIRM;
    KYVSKD = KDKDNR;
    KYVSNR = WKVSNR;
    CHIDS  = '01C';
    exsr CHKDVS;
    if CHI(5) = 'N';
      clear KDVS;
      leavesr;
    endif;

    // Bestücken die Felder der Work-DS WKEXKOSC01 anhand der an das Programm übergebenen
    // Versand-Adress-Nr
    WKEXKOSC01.EXKOS1VSNR = VSVSNR;

    //WKEXKOSC01.EXKOS1LAND = VSLAND;

    //KYLNNR = VSLAND;
    //CHIDS  = '01C';
    //exsr CHLAND;
    //// EG-Lieferung
    //if LNLDGR = '0001';
    //  // Normalauftrag
    //  KYAAAT = '01';
    //else;
    //  // Export Normalauftrag
    //  KYAAAT = '08';
    //endif;
    //CHIDS  = '01C';
    //exsr CHAFPA;
    //WKEXKOSC01.EXKOS1AAGR = AAAAGR;
    //WKEXKOSC01.EXKOS1AFAT = AAAFAT;

    if VSVSBD <> *BLANK;
      WKEXKOSC01.EXKOS1VSBD = VSVSBD;
    endif;

    if VSLIBD <> *BLANK;
      WKEXKOSC01.EXKOS1LIBD = VSLIBD;
    endif;

  endsr;

  //---------------------------------------------------------------------------
  //  SR-ERKOKD     Daten von Kunde Kondition
  //---------------------------------------------------------------------------
  begsr ERKOKD;

    KYKDNR = AGKD.KDKOKD;
    CHIDS  = '01C';
    exsr CHKUND;
    if CHI(5) = 'N';
      clear KUND;
      leavesr;
    endif;

    KYLNNR = KDLAND;
    CHIDS  = '01C';
    exsr CHLAND;
    // EG-Lieferung
    if LNLDGR = '0001';
      // Normalauftrag
      KYAAAT = '01';
    else;
      // Export Normalauftrag
      KYAAAT = '08';
    endif;
    CHIDS  = '01C';
    exsr CHAFPA;

    // Bestücken die Felder der Work-DS WKEXKOSC01 anhand der Kundenstamm-Daten
    // der Konditions-Kunden-Nr
    WKEXKOSC01.EXKOS1LAND = KDLAND;
    WKEXKOSC01.EXKOS1AAGR = AAAAGR;
    WKEXKOSC01.EXKOS1AFAT = AAAFAT;
    WKEXKOSC01.EXKOS1VKGB = KDVKGB;
    WKEXKOSC01.EXKOS1POLZ = KDPOLZ;
    WKEXKOSC01.EXKOS1KDNR = KDKDNR;
    WKEXKOSC01.EXKOS1KDGR = KDKDGR;

  endsr;

  //---------------------------------------------------------------------------
  //  SR-ERRAKD     Daten von Kunde Rechnung
  //---------------------------------------------------------------------------
  begsr ERRAKD;

    KYKDNR = AGKD.KDRAKD;
    CHIDS  = '01C';
    exsr CHKUND;
    if CHI(5) = 'N';
      clear KUND;
      leavesr;
    endif;

    // Bestücken die Felder der Work-DS WKEXKOSC01 anhand der Kundenstamm-Daten
    // der Rechnungsempfänger-Kunden-Nr
    WKEXKOSC01.EXKOS1ZABD = KDZABD;

  endsr;

  //----------------------------------------------------------------------------
  //  Berechnen Schlusskonditionen
  //----------------------------------------------------------------------------
  begsr BRKOSC;

    clear EXKOSC;
    clear RTKOSC;

    EXKOSCWTNT = WKWERT;
    EXKOSCRBBA = WKWERT;

    EXKOSCKON1 = RTKOS1KON1;
    EXKOSCKOW1 = RTKOS1KOW1;
    EXKOSCPRZ1 = RTKOS1PRZ1;
    EXKOSCBAS1 = RTKOS1BAS1;

    EXKOSCKON2 = RTKOS1KON2;
    EXKOSCKOW2 = RTKOS1KOW2;
    EXKOSCPRZ2 = RTKOS1PRZ2;
    EXKOSCBAS2 = RTKOS1BAS2;

    EXKOSCKON3 = RTKOS1KON3;
    EXKOSCKOW3 = RTKOS1KOW3;
    EXKOSCPRZ3 = RTKOS1PRZ3;
    EXKOSCBAS3 = RTKOS1BAS3;

    EXKOSCKON4 = RTKOS1KON4;
    EXKOSCKOW4 = RTKOS1KOW4;
    EXKOSCPRZ4 = RTKOS1PRZ4;
    EXKOSCBAS4 = RTKOS1BAS4;

    EXKOSCPGST = *BLANK;
    C_BRKOSC(EXKOSC:RTKOSC);

    // Rückgabe Ergebnis / Kumulierung
    SFLKON(1) = RTKOS1KON1;
    SFLKOW(1) = RTKOS1KOW1;
    SFLPRZ(1) = RTKOS1PRZ1;
    SFLERG(1) = RTKOSCERG1;
    SFLKUM(1) = RTKOSCKUM1;

    SFLKON(2) = RTKOS1KON2;
    SFLKOW(2) = RTKOS1KOW2;
    SFLPRZ(2) = RTKOS1PRZ2;
    SFLERG(2) = RTKOSCERG2;
    SFLKUM(2) = RTKOSCKUM2;

    SFLKON(3) = RTKOS1KON3;
    SFLKOW(3) = RTKOS1KOW3;
    SFLPRZ(3) = RTKOS1PRZ3;
    SFLERG(3) = RTKOSCERG3;
    SFLKUM(3) = RTKOSCKUM3;

    SFLKON(4) = RTKOS1KON4;
    SFLKOW(4) = RTKOS1KOW4;
    SFLPRZ(4) = RTKOS1PRZ4;
    SFLERG(4) = RTKOSCERG4;
    SFLKUM(4) = RTKOSCKUM4;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

  endsr;

  //---------------------------------------------------------------------------
  //  COPY-Module
  //---------------------------------------------------------------------------
  /include QCPYSRC,CHAFPA
  /include QCPYSRC,CHFIRM
  /include QCPYSRC,CHKDVS
  /include QCPYSRC,CHKUND
  /include QCPYSRC,CHLAND
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
