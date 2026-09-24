**free
//------------------------------------------------------------------------------
/title Trigger TEIL für B2B
//------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Str. 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 05.02.2026 Projekt Dometic Germany - B2B (Case 03777387)
//  ----------------------------------------------------------------------------
//  Änderung: PH 06.02.2026 Aufruf  Dometic Germany - B2B (Case 03777387)
//            Aufruf B2B009 "B2B Ident-Stamm Erweiterung (TEEW) EXPORT" mit
//            EXB009PGST = 'TEST90' statt B2B020 für den Export der Ident-Nr, wenn
//            deren Status von einem anderen wert auf >= '90' gesetzt worden ist.
//  Änderung: PH 03.06.2026 Case 06140464. Aufruf B2B009 "B2B Ident-Stamm Erweiterung (TEEW) EXPORT"
//            nicht nur nei Ident-Status-Wechsel von < '90' auf <= '90', sondern auch bei Wechsel
//            von < '90' auf einen nucht in der SYTP-Tabelle 'TESTTRDB2B' enthaltenen Status.
//------------------------------------------------------------------------------
//
//  Das Programm B2B019 ist ein Trigger-Programm, d.h. es wird bei
//  Änderungen (INSERT, UPDATE, DELETE) an der Datei TEIL in der Datenbank
//  aktiviert.
//  Über den Befehl GO CMDTRG wird die Trigger-Steuerung der iSeries aufgerufen.
//  Der Trigger muss jeweils für INSERT, UPDATE und DELETE angelegt werden.
//  Dort muss das Programm B2B019 als Auslöser eingetragen werden.
//
//  Bei Änderungen an den bestimmten Feldern der Datei TEIL (s. Routine PRUPDT)
//  werden abhängig davon, welche Felder das sind, weitere Verarbeitungen
//  aufgerufen.
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt
  main(B2B019);

//------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//------------------------------------------------------------------------------
/copy QCPYSRC,EXTRDR

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds SYTP   ext inz end-ds;
dcl-ds KYSYTP ext inz end-ds;

dcl-ds TEIL   ext inz end-ds;
dcl-ds KYTEIL ext inz end-ds;

dcl-ds TRPA   ext inz end-ds;
dcl-ds KYTRPA ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;
dcl-ds EXB2B009 ext inz end-ds;

// Erster Parameter der Trigger Buffer Section
// Berechnung Länge des Parameters: (Dateilänge * 2) + 96 (Header)
// Siehe https://www.ibm.com/support/knowledgecenter/en/ssw_ibm_i_73/dbp/rbaforzahftrc.htm
dcl-ds TGPARM1;
  TGDATEI char(10);
  TGBIB char(10);
  TGMBR char(10);
  TGEVENT char(1);
  TGTIME char(1);
  TGCMTLL char(1);
  TGF1 char(3);
  TGCCSID bindec(8:0);
  TGF2 char(8);
  TGOLD_OFF bindec(8:0);
  TGOLD_LEN bindec(8:0);
  TGOLD_N_MAP bindec(8:0);
  TGOLD_N_LEN bindec(8:0);
  TGNEW_OFF bindec(8:0);
  TGNEW_LEN bindec(8:0);
  TGNEW_N_MAP bindec(8:0);
  TGNEW_N_LEN bindec(8:0);
  TGF3 char(16);
  TGDATA varchar(10000);
end-ds;

dcl-ds TGPARM2;
  TGBUFL bindec(8:0);
end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
/copy QCPYSRC,EXTRIN
/copy QCPYSRC,SXSTRING
/copy QCPYSRC,EXTRDA

dcl-ds TEILOLD likeds(TEIL) inz(*LIKEDS);
dcl-ds TEILNEW likeds(TEIL) inz(*LIKEDS);

//------------------------------------------------------------------------------
//  Konstanten
//------------------------------------------------------------------------------
// Werte für TGEVENT
dcl-c WKEVENTINSERT const('1');
dcl-c WKEVENTDELETE const('2');
dcl-c WKEVENTUPDATE const('3');
dcl-c WKEVENTREAD const('4');

// Werte für TGTIME
dcl-c WKTIMEAFTER const('1');
dcl-c WKTIMEBEFORE const('2');
dcl-c WKTIMEINSTEAD const('3');

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s ##CHI char(8);
dcl-s ##RTCD char(1);
dcl-s ##PGST char(1);
dcl-s WKI000 char(1);
dcl-s WKFENR char(4);
dcl-s WKFFLD char(10);

// WKTRIGGER = 1: Trigger wird wirklich ausgeführt
// WKTRIGGER = 0: Trigger wird ohne Aktion beendet
dcl-s WKTRIGGER1 char(1);
dcl-s WKTRIGGER2 char(1);
dcl-s DSFIRM like(DAFIRM);
dcl-s WKFIRM like(DSFIRM);
dcl-s WKUSER like(DAUSER);
dcl-s WKNEWPOS zoned(5:0) inz;
dcl-s WKNEWLNG zoned(5:0) inz;
dcl-s WKOLDPOS zoned(5:0) inz;
dcl-s WKOLDLNG zoned(5:0) inz;

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
dcl-pr B2B019 extpgm('B2B019');
  #TGPARM1 likeds(TGPARM1);
  #TGPARM2 likeds(TGPARM2);
end-pr;

//--------------------------------------------------
// Program name: C_B2B009
// Purpose:
// Returns:
// Parameter:    #EXB2B009
//--------------------------------------------------
dcl-pr C_B2B009 extpgm('B2B009');
  #EXB2B009     likeds(EXB2B009);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2B019;
  dcl-pi *n;
    #TGPARM1 likeds(TGPARM1);
    #TGPARM2 likeds(TGPARM2);
  end-pi;

  // Übernahme der Aufrufparameter in die internen Datenstrukturen
  TGPARM1 = #TGPARM1;
  TGPARM2 = #TGPARM2;

  in EXTRLD;

  if WKI000 <> *ON;
    exsr ANFANG;
  endif;

  exsr VORLAUF;
  exsr ETRPA;

  //----------------------------------------------------------------------------
  //  Programmsteuerung
  //----------------------------------------------------------------------------
  exsr VERARB;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;

    WKCHPN = DAPROG;
    WKCHPL = DABIBL;
    WKUSER = DAUSER;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;

  endsr;

  //----------------------------------------------------------------------------
  //  Vorlauf
  //----------------------------------------------------------------------------
  begsr VORLAUF;

    WKNEWPOS = TGNEW_OFF + 1;
    WKNEWLNG = TGNEW_LEN;
    WKOLDPOS = TGOLD_OFF + 1;
    WKOLDLNG = TGOLD_LEN;

    // INSERT ist auslösende Aktion ODER
    // Trigger-Time ist AFTER und Auslöser ist nicht DELETE
    if TGEVENT = WKEVENTINSERT or TGTIME = WKTIMEAFTER
       and TGEVENT <> WKEVENTDELETE;
      TEIL = %SUBST(TGPARM1:WKNEWPOS:WKNEWLNG);
      TEILNEW = TEIL;
    else;
      TEIL = %SUBST(TGPARM1:WKOLDPOS:WKOLDLNG);
      TEILOLD = TEIL;
    endif;

    if TGEVENT <> WKEVENTUPDATE;
      leavesr;
    endif;

    // Für den Feldvergleich
    if WKOLDPOS <> *ZERO;
      TEILOLD = %SUBST(TGPARM1:WKOLDPOS:WKOLDLNG);
    endif;

    if WKNEWPOS <> *ZERO;
      TEILNEW = %SUBST(TGPARM1:WKNEWPOS:WKNEWLNG);
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeitung
  //----------------------------------------------------------------------------
  begsr VERARB;

    // Verarbeitung der einzelnen Aktionen INSERT, UPDATE und DELETE steuern

    select;

    // INSERT - Neuanlage
    when TGEVENT = WKEVENTINSERT;
      // Satz-Art = WKEVENTINSERT

      exsr PRTRIGGER;
      if WKTRIGGER1 = *ON or WKTRIGGER2 = *ON;
        //exsr UTRIGGER;
      endif;

    // DELETE - Löschen
    when TGEVENT = WKEVENTDELETE;
      // Satz-Art = WKEVENTDELETE

      exsr PRTRIGGER;
      if WKTRIGGER1 = *ON or WKTRIGGER2 = *ON;
        //exsr UTRIGGER;
      endif;

    // UPDATE - Aktualisieren
    when TGEVENT = WKEVENTUPDATE;
      // Satz-Art = WKEVENTUPDATE

      // Steuerung bei UPDATE speziell für einen Kunden
      // Standard Update-Behandlung
      exsr PRUPDT;

      if WKTRIGGER1 = *ON or WKTRIGGER2 = *ON;
        exsr PRTRIGGER;
      endif;

      if WKTRIGGER1 = *ON or WKTRIGGER2 = *ON;
        exsr UTRIGGER;
      endif;

    endsl;

  endsr;

  //----------------------------------------------------------------------------
  //  Prüfen Update Änderung TEIL
  //----------------------------------------------------------------------------
  begsr PRUPDT;

    WKTRIGGER1 = *OFF;
    WKTRIGGER2 = *OFF;

    // Prüfung für einzelen Felder - wenn der Wert dieser Felder verändert wurde,
    // wird ein UPDATE ausgeführt

    KYSYTPFIRM = TEILNEW.TEFIRM;
    KYSYTPTART = 'TESTTRDB2B';
    KYSYTPTCDE = TEILNEW.TETEST;
    KYSYTPTFLG = *ZERO;
    CHIDS = '01C';
    exsr CHSYTP;

    if TEILOLD.TETEST <> TEILNEW.TETEST
      and TEILOLD.TETEST < '90'
      and (TEILNEW.TETEST >= '90' or CHI(5) = 'N');
      WKTRIGGER1 = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------
  //  Prüfen
  //------------------------------------------------------------------------------
  begsr PRTRIGGER;


  endsr;

  //------------------------------------------------------------------------------
  //  Aufruf weiterer Verarbeitungen
  //------------------------------------------------------------------------------
  begsr UTRIGGER;

    // Was soll der Trigger ausführen?

    // Aufruf B2B Artikel (Status >= '90') EXPORT
    if WKTRIGGER1 = *ON;
      clear EXB2B009;
      EXB009PGST = 'TEST90';
      EXB009FIRM = TEFIRM;
      EXB009TENR = TETENR;
      C_B2B009(EXB2B009);
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  ETRPA  Ermitteln Daten aus Firmen-Parameter
  //----------------------------------------------------------------------------
  begsr ETRPA;

  endsr;

  //----------------------------------------------------------------------------
  //  COPY-Module
  //----------------------------------------------------------------------------
  /copy QCPYSRC,CHSYTP
  /copy QCPYSRC,CHTRPA
end-proc;

//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
