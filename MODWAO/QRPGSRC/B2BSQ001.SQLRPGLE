**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermitteln/Prüfen der Verfügbarkeit von Auslaufartikeln
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 27.05.2025 Case #04303295 "B2B-Erweiterung Status 80 Ablauf"
//  ----------------------------------------------------------------------------
//  Änderung: PH 05.06.2025 Case #04303295 "B2B-Erweiterung Status 80 Ablauf"
//            ERRORMESSAGE trimmen (E-Mail von RR vom 05.06.2025)
//  Änderung: PH 25.06.2025 Case #04303295 "B2B-Erweiterung Status 80 Ablauf". Nachtrag:
//            Übergabe mehrerer Ident-Nr und der dazugehörigen Mengen in einem langen String
//            REQDTA. Der Übergabeparameter FIRM ist nun als VARCHAR statt CHAR definiert.
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und prüft die Lieferbarkeit
//  der an das Programm übergebenen Ident-Nr unter Berücksichtigung der ebenfalls
//  an das Programm übergebenen Bestell-Menge und des intern im Programm ermittelten
//  verfügbaren Gesamtbestandes und gibt das Ergebnis der Prüfung als Code, den ermittel-
//  ten verfügbaren Gesamtbestand und die Errormesage ("SUCCESS". "ERROR") zurück.
//
//  Übergabeparameter:
//  #FIRM      - Firma
//  #REQDTA    - Liste Ident-Nr + Bestell-Menge
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ001);
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
  TENR         varchar(15);
  RQUANTITY    zoned(11:2);
  CODE         like(WKCODE);
  QUANTITY     like(WKVFGSBS);
  ERRORMESSAGE like(WKERRORMSG);
end-ds;

//------------------------------------------------------------------------------
//  Konstanten
//------------------------------------------------------------------------------
dcl-c LC_DELIMITER2 const(x'BB');   // u'007C', "|" pipe

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s DO_X       uns(5);
dcl-s ##CHI      char(8);
dcl-s WKFENR     char(4);
dcl-s WKCODE     char(1);
dcl-s WKTRPALGBE char(3);
dcl-s WKMENG     zoned(15:6);
dcl-s WKVFGSBS   zoned(11:2);
dcl-s WKERRORMSG varchar(10);
dcl-s WKFIRM     varchar(2);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_MOAFPO
// Purpose:
// Returns:
// Parameter:      #EXTREND
// Parameter:      #RTTREND
//--------------------------------------------------
dcl-pr C_MOAFPO extpgm('MOAFPO');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ001;
  dcl-pi *n;
    #FIRM like(WKFIRM);
    #REQDTA varchar(5000);
  end-pi;

  dcl-ds wk        qualified inz;
    pos            uns(5);
    Request        varchar(50);
    TENR           char(15);
    MENG           char(15);  // Workfeld! ggf. mit Dezimaltrennzeichen
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

      wk.pos = %scan(LC_DELIMITER2: wk.Request);
      if wk.pos > *ZERO;
        wk.TENR = %trim(%subst(wk.Request: 1: wk.pos - 1));
        wk.MENG = %subst(wk.Request: wk.pos + 1);
        exsr VTENR;
      endif;

    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten die an das Programm übergebenen Ident-Nummern aus der Liste #REQDTA
  //----------------------------------------------------------------------------
  begsr VTENR;

    WKCODE = *BLANK;
    WKVFGSBS = *ZERO;
    WKERRORMSG = *BLANK;

    WKMENG = trdec(wk.MENG);

   for DO_X = 1 to 1;

    KYTENR = wk.TENR;
    CHIDS  = '01C';
    exsr CHTEIL;
    if CHI(5) = 'N' or TETEST <> '80';
      // Zugriff auf den Ident-Stamm nicht erfolgreich oder der Ident-Status <> '80',
      // dann Fehler und keine weitere Verarbeutung
      WKERRORMSG = 'ERROR';
      leave;
    endif;

    // Ermitteln den "verfügbaren Gesamtbestand"
    clear EXTREND;
    %subst(EXTRNDDATE:01) = TETENR;
    %subst(EXTRNDDATE:86) = WKTRPALGBE;
    EXTRNDPGST = 'ERVGBS';
    C_MOAFPO(EXTREND:RTTREND);
    WKVFGSBS = alnumToDec(RTTRNDDATE: 11: 2: 01);

    select;

    when WKMENG <= WKVFGSBS;
      // Fall 5: Die an das Programm übergebene Bestell-Menge übersteigt nicht
      // den verfügbaren Gesamtbestand ==> keine Fehlerausgabe
      WKCODE = '5';
      WKERRORMSG = 'SUCCESS';

    when WKVFGSBS > *ZERO and TEERTE = *BLANK;
      // Fall 4: "Der gewünschte Artikel läuft aus, es sind nur noch <WKVFGSBS> Stück an lieferbar.
      WKCODE = '4';
      WKERRORMSG = 'SUCCESS';

    //when WKVFGSBS = *ZERO and TEERTE = *BLANK;
    when WKVFGSBS <= *ZERO and TEERTE = *BLANK;
      // Fall 3: "Der gewünschte Artikel ist leider nicht mehr verfügbar
      // und steht für Bestellungen nicht mehr zur Verfügung"
      WKCODE = '3';
      WKERRORMSG = 'SUCCESS';

    when WKVFGSBS > *ZERO and TEERTE <> *BLANK;
      // Fall 2: "Der gewünschte Artikel läuft aus, wir haben noch <WKVFGSBS> Stück an Lager.
      // Bitte reduzieren Sie die Menge und/oder bestellen Sie den Nachfolgeartikel <TEIL.TEERTE>"
      WKCODE = '2';
      WKERRORMSG = 'SUCCESS';

    //when WKVFGSBS = *ZERO and TEERTE <> *BLANK;
    when WKVFGSBS <= *ZERO and TEERTE <> *BLANK;
      // Fall 1: "Der gewünschte Artikel läuft aus,
      // bitte bestellen Sie den Nachfolgeartikel <TEIL.TEERTE>"
      WKCODE = '1';
      WKERRORMSG = 'SUCCESS';

    endsl;

   endfor;

    /// Rückgabe der Informationen pro an das Programm übergeben Ident-Nr/Menge
    RowCount += 1;
    RESULT(RowCount).TENR = %trim(wk.TENR);
    RESULT(RowCount).RQUANTITY = trdec(wk.MENG);
    RESULT(RowCount).CODE = WKCODE;
    RESULT(RowCount).QUANTITY = WKVFGSBS;
    RESULT(RowCount).ERRORMESSAGE = %trim(WKERRORMSG);

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPALGBE = getTRPACode('MODWAO': 'MOAFPO': 'TEIL80LGBE');

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
