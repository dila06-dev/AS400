**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittlung der Schlusskonditionen (AFKN)
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: MG 05.06.2025 Case #03777387 ID: 6.1 Order histoty Details
//  ----------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und berechnet die
//  Schlusskonditionen für den angegebenen Verursacher.
//
//  Übergabeparameter:
//  ##FIRM      - Firma
//  ##KOJJ      - Jahr
//  ##KONR      - Nummer
//  ##KART      - Satzart
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ003);
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

dcl-s SFLKON dim(4) inz like(ANKON1);
dcl-s SFLKOW dim(4) inz like(ANKOW1);
dcl-s SFLPRZ dim(4) inz like(ANPRZ1);
dcl-s SFLERG dim(4) inz like(RTKOSCERG1);
dcl-s SFLKUM dim(4) inz like(RTKOSCKUM1);

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds AFKN   ext inz end-ds;
dcl-ds KYAFKN ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXAFPO ext inz end-ds;
dcl-ds RTAFPO ext inz end-ds;

dcl-ds EXKOSC ext inz end-ds;
dcl-ds RTKOSC ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
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
dcl-s WKFENR     char(4);
dcl-s WKFIRM     like(DAFIRM);

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
// Program name: C_TRAFPO
// Purpose:
// Returns:
// Parameter:    #EXKOND
// Parameter:    #RTKOND
//--------------------------------------------------
dcl-pr C_TRAFPO  extpgm('TRAFPO01');
  #EXAFPO        likeds(EXAFPO);
  #RTAFPO        likeds(RTAFPO);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ003;
  dcl-pi *n;
    inFIRM char(2);
    inKONR char(11);
    inKART char(4);
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

  // Ermitteln/Berechnen Schlusskonditionen
  exsr VAFKN;

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYANFI = DAFIRM;     // AFKN

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten der an das Programm übermittelten Konditionsnummer/Art
  //----------------------------------------------------------------------------
  begsr VAFKN;

    // Initialisieren Feldruppen
    clear SFLKON;
    clear SFLKOW;
    clear SFLPRZ;
    clear SFLERG;
    clear SFLKUM;

    KYANJH = trdec(%subst(inKONR: 1: 4));
    KYANKN = %subst(inKONR: 6: 6);
    KYANKA = inKART;
    CHIDS  = '01C';
    exsr CHAFKN;
    // Zugriff auf die Datei nicht erfolgreich oder keine Schlusskondition hinterlegt
    if CHI(5) = 'N' or ANKON1 = *blank;
      leavesr;
    endif;

    // Ermitteln Auftragswert
    clear EXAFPO;
    EXAFPOPGST = 'ERAFNT';
    EXAFPOAFJJ = ANKOJJ;
    EXAFPOAFNR = ANKONR;
    C_TRAFPO(EXAFPO:RTAFPO);

    // Berechnen Schlusskonditionen
    exsr BRKOSC;

    // Rückgabe Schlusskonditionen / Ergebnis
    for SF = 1 to %elem(SFLKON);
      if SFLKON(SF) = *blank;
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
      RESULT(RowCount).ERRMSG = '';
    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //  Berechnen Schlusskonditionen
  //----------------------------------------------------------------------------
  begsr BRKOSC;

    clear EXKOSC;
    clear RTKOSC;

    EXKOSCWTNT = RTAFPOAFNT;
    EXKOSCRBBA = RTAFPORBBA;
    EXKOSCGWBR = RTAFPOGSBR;

    EXKOSCKON1 = ANKON1;
    EXKOSCKOW1 = ANKOW1;
    EXKOSCPRZ1 = ANPRZ1;
    EXKOSCBAS1 = ANBAS1;

    EXKOSCKON2 = ANKON2;
    EXKOSCKOW2 = ANKOW2;
    EXKOSCPRZ2 = ANPRZ2;
    EXKOSCBAS2 = ANBAS2;

    EXKOSCKON3 = ANKON3;
    EXKOSCKOW3 = ANKOW3;
    EXKOSCPRZ3 = ANPRZ3;
    EXKOSCBAS3 = ANBAS3;

    EXKOSCKON4 = ANKON4;
    EXKOSCKOW4 = ANKOW4;
    EXKOSCPRZ4 = ANPRZ4;
    EXKOSCBAS4 = ANBAS4;

    EXKOSCPGST = *blank;
    C_BRKOSC(EXKOSC:RTKOSC);

    // Rückgabe Ergebnis / Kumulierung
    SFLKON(1) = ANKON1;
    SFLKOW(1) = ANKOW1;
    SFLPRZ(1) = ANPRZ1;
    SFLERG(1) = RTKOSCERG1;
    SFLKUM(1) = RTKOSCKUM1;

    SFLKON(2) = ANKON2;
    SFLKOW(2) = ANKOW2;
    SFLPRZ(2) = ANPRZ2;
    SFLERG(2) = RTKOSCERG2;
    SFLKUM(2) = RTKOSCKUM2;

    SFLKON(3) = ANKON3;
    SFLKOW(3) = ANKOW3;
    SFLPRZ(3) = ANPRZ3;
    SFLERG(3) = RTKOSCERG3;
    SFLKUM(3) = RTKOSCKUM3;

    SFLKON(4) = ANKON4;
    SFLKOW(4) = ANKOW4;
    SFLPRZ(4) = ANPRZ4;
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
  /include QCPYSRC,CHFIRM
  /include QCPYSRC,CHAFKN
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
