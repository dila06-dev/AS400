**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittlung der Konditionen aus der Vertragsposition (AGPO)
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: MG 01.08.2025 Case #03777387 ID: 21.1  Quotation details
//  ----------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und berechnet die Konditionen
//  für den angegebenen Verursacher.
//
//  Übergabeparameter:
//  ##FIRM      - Firma
//  ##AGNR      - Nummer
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ007);
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

dcl-s SFLPOS dim(999) inz like(GPAGPO);
dcl-s SFLKON dim(999) inz like(GPKON1);
dcl-s SFLKOW dim(999) inz like(GPKOW1);
dcl-s SFLPRZ dim(999) inz like(GPPRZ1);
dcl-s SFLERG dim(999) inz like(RTKONDERG1);
dcl-s SFLKUM dim(999) inz like(RTKONDKUM1);

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds AGPO   ext inz end-ds;
dcl-ds KYAGPO ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXKOND ext inz end-ds;
dcl-ds RTKOND ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  POSITION     zoned(4);
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
dcl-s WKFENR     char(4);
dcl-s WKFIRM     like(DAFIRM);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------

//--------------------------------------------------
// Program name: C_BRPRKO
// Purpose:
// Returns:
// Parameter:    #EXKOND
// Parameter:    #RTKOND
//--------------------------------------------------
dcl-pr C_BRPRKO  extpgm('BRPRKO');
  #EXKOND        likeds(EXKOND);
  #RTKOND        likeds(RTKOND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ007;
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

  // Ermitteln/Berechnen Konditionen
  exsr VAGPO;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYGPFI = DAFIRM;     // AGPO

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten der an das Programm übermittelten Konditionsnummer/Art
  //----------------------------------------------------------------------------
  begsr VAGPO;

    // Initialisieren Feldruppen
    clear SFLPOS;
    clear SFLKON;
    clear SFLKOW;
    clear SFLPRZ;
    clear SFLERG;
    clear SFLKUM;

    KYGPJH = trdec(%subst(inAGNR: 1: 4));
    KYGPAG = %subst(inAGNR: 6: 6);
    KYGPPO = *loval;
    CHIDS  = '01+';
    exsr CHAGPO;
    dow CHI(5) = 'J'
      and GPFIRM = KYGPFI
      and GPAGJJ = KYGPJH
      and GPAGNR = KYGPAG;
      // Berechnen Preis und Konditionen
      if GPKON1 <> *blank;
        exsr BRPRKO;
      endif;

      CHIDS  = '01R';
      exsr CHAGPO;
    enddo;

    // Rückgabe Schlusskonditionen / Ergebnis
    for SF = 1 to %elem(SFLKON);
      if SFLKON(SF) = *blank;
        leave;
      endif;

      RowCount += 1;
      RESULT(RowCount).POSITION = SFLPOS(SF);
      RESULT(RowCount).CHARGE = %trim(SFLKON(SF));
      RESULT(RowCount).AMOUNT = SFLKOW(SF);
      if SFLPRZ(SF) = DAJNKZ;
        RESULT(RowCount).PERCENTAGE = '1';
      else;
        RESULT(RowCount).PERCENTAGE = '0';
      endif;
      RESULT(RowCount).RESULT = SFLERG(SF);
      RESULT(RowCount).KUMUL  = SFLKUM(SF);
      RESULT(RowCount).ERRMSG = '';
    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //  Berechnen Preis und Konditionen
  //----------------------------------------------------------------------------
  begsr BRPRKO;

    clear EXKOND;
    clear RTKOND;
    EXKONDVPKZ = 'V';
    EXKONDTENR = GPTENR;
    EXKONDMEIN = GPMEIN;
    EXKONDMEPR = GPMEPR;
    EXKONDMENG = GPMENG;
    EXKONDPRAR = GPPRAR;
    EXKONDPREI = GPPREI;
    EXKONDPDIM = GPPDIM;
    EXKONDAFDA = GPAGDA;

    EXKONDKON1 = GPKON1;
    EXKONDKOW1 = GPKOW1;
    EXKONDPRZ1 = GPPRZ1;
    EXKONDPDI1 = GPPDI1;
    EXKONDBAS1 = GPBAS1;

    EXKONDKON2 = GPKON2;
    EXKONDKOW2 = GPKOW2;
    EXKONDPRZ2 = GPPRZ2;
    EXKONDPDI2 = GPPDI2;
    EXKONDBAS2 = GPBAS2;

    EXKONDKON3 = GPKON3;
    EXKONDKOW3 = GPKOW3;
    EXKONDPRZ3 = GPPRZ3;
    EXKONDPDI3 = GPPDI3;
    EXKONDBAS3 = GPBAS3;

    EXKONDKON4 = GPKON4;
    EXKONDKOW4 = GPKOW4;
    EXKONDPRZ4 = GPPRZ4;
    EXKONDPDI4 = GPPDI4;
    EXKONDBAS4 = GPBAS4;

    EXKONDPGST = 'BRPRKO';

    C_BRPRKO(EXKOND:RTKOND);

    // Rückgabe Ergebnis / Kumulierung
    if GPKON1 <> *blanK;
      SF = %lookup('   ': sflkon: 1);
      if SF <> *zero;
        SFLPOS(SF) = GPAGPO;
        SFLKON(SF) = GPKON1;
        SFLKOW(SF) = GPKOW1;
        SFLPRZ(SF) = GPPRZ1;
        SFLERG(SF) = RTKONDERG1;
        SFLKUM(SF) = RTKONDKUM1;
      endif;
    endif;

    if GPKON2 <> *blanK;
      SF = %lookup('   ': sflkon: 1);
      if SF <> *zero;
        SFLPOS(SF) = GPAGPO;
        SFLKON(SF) = GPKON2;
        SFLKOW(SF) = GPKOW2;
        SFLPRZ(SF) = GPPRZ2;
        SFLERG(SF) = RTKONDERG2;
        SFLKUM(SF) = RTKONDKUM2;
      endif;
    endif;

    if GPKON3 <> *blanK;
      SF = %lookup('   ': sflkon: 1);
      if SF <> *zero;
        SFLPOS(SF) = GPAGPO;
        SFLKON(SF) = GPKON3;
        SFLKOW(SF) = GPKOW3;
        SFLPRZ(SF) = GPPRZ3;
        SFLERG(SF) = RTKONDERG3;
        SFLKUM(SF) = RTKONDKUM3;
      endif;
    endif;

    if GPKON4 <> *blanK;
      SF = %lookup('   ': sflkon: 1);
      if SF <> *zero;
        SFLPOS(SF) = GPAGPO;
        SFLKON(SF) = GPKON4;
        SFLKOW(SF) = GPKOW4;
        SFLPRZ(SF) = GPPRZ4;
        SFLERG(SF) = RTKONDERG4;
        SFLKUM(SF) = RTKONDKUM4;
      endif;
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
  /include QCPYSRC,CHAGPO
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
