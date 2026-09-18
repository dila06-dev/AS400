**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittelung des Wiederverfügbarkeitstermins (ähnlich der
/TITLE Ermittlung im MCSIST über den Programmaufruf WAO008
//------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 16.02.2026 Case 05947674 "B2B Wiederverfügbarkeit"
//  ----------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt den Wiederverfügnarkeitstermin
//  ähnlich der Ermittlung im Programm MCDIST über den Programmazfruf WAO008 und gibt
//  den ermittelten Wiederverfügnarkeitstermin pro Artikel zurück.
//
//  Übergabeparameter:
//  #FIRM      - Firma
//  #REQDTA    - Liste Ident-Nr
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ009);
/include QCPYSRC,CTLOPTIONS

//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
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
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds TEIL   ext inz end-ds;
dcl-ds KYTEIL ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXTREND ext inz end-ds;
dcl-ds RTTREND ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  SKU          varchar(15);
  RE_AVAILABLE zoned(8);
end-ds;

//------------------------------------------------------------------------------
//  Konstanten
//------------------------------------------------------------------------------
dcl-c LC_DELIMITER2 const(x'BB');   // u'007C', "|" pipe

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s ##CHI      char(8);
dcl-s WKFENR     char(4);
dcl-s WKWVTE     zoned(8);
dcl-s WKERRORMSG varchar(10);
dcl-s WKFIRM     varchar(2);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_WAO008
// Purpose:
// Returns:
// Parameter:      #EXTREND
// Parameter:      #RTTREND
//--------------------------------------------------
dcl-pr C_WAO008 extpgm('WAO008');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ009;
  dcl-pi *n;
    #FIRM like(WKFIRM);
    #REQDTA varchar(5000);
  end-pi;

  dcl-ds wk        qualified inz;
    pos            uns(5);
    Request        varchar(50);
    TENR           char(15);
  end-ds;

  // Übernahme der Aufrufparameter in die internen Felder
  WKFIRM = #FIRM;

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

  exsr VCSV;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYTEFI = DAFIRM;     // TEIL

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten der Liste mit TENR + MENG , CSV-Format
  //----------------------------------------------------------------------------
  begsr VCSV;

    // Das if-define hier nur, weil RDi das nicht richtig erkennt
    /if defined(xcal04)
    for-each wk.Request in %split(#REQDTA: ';');
    /else
    for x = 1 to 2;
    /endif

      wk.TENR = %trim(wk.Request);
      exsr VTENR;
    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten die an das Programm übergebenen Ident-Nummern aus der Liste #REQDTA
  //----------------------------------------------------------------------------
  begsr VTENR;

    WKWVTE = *ZERO;
    WKERRORMSG = *BLANK;

    KYTENR = wk.TENR;
    CHIDS  = '01C';
    exsr CHTEIL;

    // Ermitteln den Wiederverfügbarkeitstermin
    clear EXTREND;
    clear RTTREND;
    %subst(EXTRNDKEYB:16) = TETENR;
    %subst(EXTRNDKEYB:36) = '001';  // Werks-Nr
    C_WAO008(EXTREND:RTTREND);
    WKWVTE = alnumToDec(%subst(RTTRNDDATE: 1: 8): 8: 0);

    /// Rückgabe der Informationen pro an das Programm übergeben Ident-Nr
    RowCount += 1;
    RESULT(RowCount).SKU = %trim(wk.TENR);
    RESULT(RowCount).RE_AVAILABLE = WKWVTE;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

  endsr;

  //---------------------------------------------------------------------------
  //  COPY-Module
  //---------------------------------------------------------------------------
  /include QCPYSRC,CHFIRM
  /include QCPYSRC,CHTEIL
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
