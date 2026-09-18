**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Generierung KD-Auftrag auf Basis KD-Angebot
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: MG 26.06.2025 Case #03777387 ID: 22 Quotation Submission
//  ----------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, generiert einen Kunndenauftrag auf
//  Basis der angegebenen Angebotsnummer.
//
//  Übergabeparameter:
//  ##FIRM      - Firma
//  ##AGNR      - KD-Angebots-Jahr/Nummer
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ005);
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
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXAGKO ext inz end-ds;
dcl-ds RTAGKO ext inz end-ds;

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
dcl-s WKFENR     char(4);
dcl-s W$PA03     char(10);
dcl-s W$PA04     char(10);
dcl-s W$PA05     char(10);
dcl-s W$PA06     char(10);
dcl-s W$PA07     char(10);
dcl-s WKTEXT     char(132);
dcl-s WKFIRM     like(DAFIRM);

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
// Program name: C_T1AGKO
// Purpose:
// Returns:
// Parameter:    #EXKOND
// Parameter:    #RTKOND
//--------------------------------------------------
dcl-pr C_T1AGKO  extpgm('T1AGKO');
  #EXAGKO        likeds(EXAGKO);
  #RTAGKO        likeds(RTAGKO);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ005;
  dcl-pi *n;
    inFIRM char(2);
    inAGNR char(11);
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

  WKFENR = *ZERO;
  RowCount = *ZERO;
  clear RESULT;

  // Generieren Kundenauftrag auf Basis Kundenangebot
  exsr T1AGKO;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

  endsr;

  //----------------------------------------------------------------------------
  //  Generieren Kundenauftrag auf Basis Kundenangebot
  //----------------------------------------------------------------------------
  begsr T1AGKO;

    clear EXAGKO;
    EXAGKOAGJJ = trdec(%subst(inAGNR: 1: 4));
    EXAGKOAGNR = %subst(inAGNR: 6: 6);
    C_T1AGKO(EXAGKO:RTAGKO);

    /// Rückgabe der Informationen pro an das Programm übergeben Ident-Nr/Menge
    RowCount += 1;
    if RTAGKOFENR = *zero;
      RESULT(RowCount).AFNR = %trim(%char(RTAGKOAGJJ) + '/' + RTAGKOAGNR);
    else;
      C_TRFEHLC1(RTAGKOFENR:KEYVAR:DSJNAM:DSUSER:RTAGKOPA03:RTAGKOPA04:RTAGKOPA05:
          RTAGKOPA06:RTAGKOPA07:WKTEXT);
      RESULT(RowCount).FFLD = %trim(RTAGKOFFLD);
      RESULT(RowCount).ERRMSG = %trim(WKTEXT);
    endif;

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
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
