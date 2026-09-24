**free
//------------------------------------------------------------------------------
/TITLE  Anzeigen des IFS-Dateipfades für einen in die Schnitstelle zu übernehmenden KD-Auftrag
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 10.07.2025 Case 04264118. Integration Dometic Siegen in DE411 1/2
//  ----------------------------------------------------------------------------
//  Änderung: PH 14.07.2025 Case 04264118. Integration Dometic Siegen in DE411 1/2
//            Prüfroutine PRPATH, ob der Pfad von der Anzeige im audrufenden Programm
//            ausgeschlossen wird.
//--------------------------------------------------------------------------
//
//  Über dieses Programm zeigt den IFS-Datempfad  für einen in die Schnitstelle zu
//  übernehmenden KD-Auftrag an. Die Bestandteile des Dateipfades werden an
//  das Programm aus MCFS05 übergeben.
//------------------------------------------------------------------------------
//**  DATEIBESCHREIBUNGEN
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(WAO016);

//------------------------------------------------------------------------------
//  Dateibeschreibungen
//------------------------------------------------------------------------------
dcl-f WAO016FM workstn(*ext) usage(*INPUT:*OUTPUT)
  usropn indds(DSINDICATORS);

//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
/define TVORLAGE23

/include QCPYSRC,STDTR
/include QCPYSRC,CXIODCL

/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXTRPA
/include QCPYSRC,SXTRTP

//------------------------------------------------------------------------------
//**  Dateien
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//**  Externe Datenstrukturen
//------------------------------------------------------------------------------
dcl-ds EXTREND     ext inz end-ds;
dcl-ds RTTREND     ext inz end-ds;

dcl-ds EXFIRM      ext inz end-ds;
dcl-ds EXFLPO      ext inz end-ds;
dcl-ds EXTRDN      ext inz end-ds;

//------------------------------------------------------------------------------
//**  Interne Datenstruktur
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//  Konstanten
//------------------------------------------------------------------------------
// Allgemeine Programmsteuerinformationen
dcl-c PGM_NAME const('WAO016');
dcl-c FMT_NAME const('WAO016FM');

// Formate
dcl-c FMT_NONE const('00');
dcl-c FMT_EDIT_01 const('01');

//------------------------------------------------------------------------------
//**  Einzelfelder
//------------------------------------------------------------------------------
dcl-s WKC001       char(1);
dcl-s WKN010       zoned(1);
dcl-s do_x         zoned(1);
dcl-s WKI000       char(1);
dcl-s WKBIBL       like(DABIBL);
dcl-s fmtList      like(fmtList_t);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_WAO017
// Purpose:
// Returns:
// Parameter:      #EXTREND
// Parameter:      #RTTREND
//--------------------------------------------------
dcl-pr C_WAO017 extpgm('WAO017');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc WAO016;
  dcl-pi *n;
    #EXTREND likeds(EXTREND);
    #RTTREND likeds(RTTREND);
  end-pi;

  /include QCPYSRC,PGINITTR

  exsr UEBTREND;
  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  if WKIOKZ = *ON;
    C#WNDW = *ON;
  endif;

  // Verarbeitung des PCPGST aus aufrufendem Programm
  select;
  when PCPGST = PGST_END;
    // Bildschirmformat schliessen
    if WKIOKZ = *ON;
      dspClose('WAO016FM');
    endif;
    WKIFMT = FMT_NONE;
  when PCPGST = 'PRPATH';
    exsr PRPATH;
    WKIFMT = FMT_NONE;
  endsl;

  //----------------------------------------------------------------------------
  //**  Programmsteuerung
  //----------------------------------------------------------------------------
  dow WKIFMT <> FMT_NONE;

    if WKIOKZ <> *ON;
      exsr AUFFOR;
      dspOpen('WAO016FM': DSINDICATORS);
      WKIOKZ = *ON;
    endif;

    select;

    when WKIFMT = FMT_EDIT_01;
      exsr BILD01;

    other;
      leave;
    endsl;

  enddo;

  if #CRTCD = RTCD_CANCEL and WKIOKZ = *ON;
    dspClose('WAO016FM');
    WKIOKZ = *OFF;
  endif;

  WKFIRM = DAFIRM;
  RTTRNDRTCD = #CRTCD;
  // Rückgabe der Aufrufparameter
  #RTTREND = RTTREND;
  return;

  //----------------------------------------------------------------------------
  //**  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;

    WKC001 = *BLANK;
    WKN010 = *ZERO;

    WKPROG = EXPSDSPROC;
    WKBIBL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    EXFLPOFMTN = FMT_NAME;

  endsr;

  //----------------------------------------------------------------------------
  //**  Uebernahme EXTREND
  //----------------------------------------------------------------------------
  begsr UEBTREND;

    // Übernahme der Aufrufparameter in die internen Datenstrukturen
    EXTREND = #EXTREND;
    RTTREND = #RTTREND;

    PCPGST = EXTRNDPGST;

    clear RTTREND;
    RTTRNDFENR = *ZERO;

  endsr;

  //----------------------------------------------------------------------------
  //**  Vorlauf
  //----------------------------------------------------------------------------
  begsr VORLAUF;

    C#LCK0 = *OFF;
    C#LCK1 = *OFF;
    WKIN30 = C#LCK0;
    WKIN31 = C#LCK1;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    #CRTCD = *BLANK;
    WKFEAT = 'F';
    MCF = *BLANK;

    clear fmtList;
    WKIFMT = FMT_EDIT_01;

    C#IN28 = trGetJobType();

    *IN = *OFF;

  endsr;

  //----------------------------------------------------------------------------
  //  Aufbereitung für Formatanzeige
  //----------------------------------------------------------------------------
  begsr AUFFOR;

    EXFIRMFIRM = DAFIRM;
    exsr PRFIRMFIRM;

    EXTRDNDANA = PGM_NAME;
    exsr RDTRDNTRDN;
    DSKOPF = %SUBST(EXFIRMKNAM:1:30) + %UCS2(' ') + EXTRDNTEXT;
    //WNKOPF = EXTRDNTEXT;

  endsr;

  //----------------------------------------------------------------------------
  //**  Steuerroutine BILD01
  //----------------------------------------------------------------------------
  begsr BILD01;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr B01DS;

    dow WKIFMT = FMT_EDIT_01;
      WKFLPORECN = 'WAO01601';
      exsr EFLPO;
      dspWrite('WAO01601');
      dspWrite('WAO016B1');

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      C#WNDW = *OFF;

      *in99 = dspRead('WAO01601');

      IF *IN99;
        #CRTCD = RTCD_CANCEL;
        DAFEHL = *ON;
        #CPGST = *BLANK;
        WKIFMT = FMT_NONE;
        leave;
      endif;

      select;

      when C#SELC = *ON;
        exsr MCAUFR;
        if WKTRTP = *ON or WKFENR <> *ZERO;
          iter;
        endif;

      when C#CANC = *ON;
        #CRTCD = RTCD_CANCEL;
        #CPGST = *BLANK;
        DAFEHL = *ON;
        WKIFMT = trListRemoveLast(fmtList);

      when C#FUKT <> *ZERO;
        WKFENR = ERR_INVLDFUKT;
        iter;

      other;
        exsr B01PR;
        if WKFENR <> *ZERO;
          iter;
        endif;

        exsr WAO017;
        if WKFENR <> *ZERO;
          iter;
        endif;

        WKIFMT = trListRemoveLast(fmtList);

      endsl;

    enddo;

  endsr;

  //----------------------------------------------------------------------------
  //**  Füllen Bildschirmformat 01
  //----------------------------------------------------------------------------
  begsr B01DS;

    C#LCK0 = WKIN30;
    C#LCK1 = WKIN31;

    #CRTCD = *BLANK;

             // Vezeichnis (Pfad)
    DSPATH = %trim(EXTRNDKEYB);
    if %subst(DSPATH:%len(%trim(DSPATH)):1) <> '/';
      DSPATH = %trim(DSPATH) + '/';
    endif;
                             // Dateiname
    DSPATH = %trim(DSPATH) + %trim(EXTRNDDATE);

    WKFENR = *ZERO;
    EXFLPOFLDN = *BLANK;

  endsr;

  //----------------------------------------------------------------------------
  //**  Plausiprüfung für BILD01
  //----------------------------------------------------------------------------
  begsr B01PR;

    WKFENR = *ZERO;

    WKFENR = *ZERO;

  endsr;

  //----------------------------------------------------------------------------
  //**  Funktionstaste F4 für alle Bilder
  //----------------------------------------------------------------------------
  begsr MCAUFR;

    WKTRTP = *OFF;
    WKFENR = *ZERO;

    EXFLPOFLDN = FLDNAM;
    exsr EFLPO;

    select;

    other;
      WKFENR = ERR_INVLD_F4;

    endsl;

  endsr;

  //----------------------------------------------------------------------------
  //**  Aufruf WA017 )Übernahme Kundenaufträge
  //----------------------------------------------------------------------------
  begsr WAO017;

    clear EXTREND;
    EXTRNDKEYB = #EXTREND.EXTRNDKEYB; // Verzeichnis
    EXTRNDDATE = #EXTREND.EXTRNDDATE; // Datei
    C_WAO017(EXTREND:RTTREND);

    WKFENR = RTTRNDFENR;

  endsr;

  //----------------------------------------------------------------------------
  //**  Prüfen, ob der Pfad von der Anzeige (in MCFS05) ausgeschlossen wird
  //----------------------------------------------------------------------------
  begsr PRPATH;

    for do_x = 1 to 1;
      // Wenn der Typ des Verzeichniseintrags <> '*STMF' ist
      if %trim(%subst(EXTRNDPRKZ:1:10)) <> '*STMF';
        RTTRNDFENR = '0051';
        leave;
      endif;
    endfor;

  endsr;

  //----------------------------------------------------------------------------
  //**  Ermitteln Daten aus Firmen-Parameter
  //----------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPA = *ON;

  endsr;

  //----------------------------------------------------------------------------
  //**  Aufbereiten der Nachrichten
  //----------------------------------------------------------------------------
  begsr AUMSG;

    C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:
        W$PA06:W$PA07);

    PGMNAM = PGM_NAME;
    C#INIT = *ON;

    select;
    when WKIFMT = FMT_EDIT_01;
      dspWrite('WAO016CT');
    other;
      dspWrite('WAO016CT');
    endsl;

    C#INIT = *OFF;

    select;
    when WKIFMT = FMT_EDIT_01;
      dspSndMsg('WAO016CT': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    other;
      dspSndMsg('WAO016CT': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    endsl;

    W$PA03 = *BLANK;
    W$PA04 = *BLANK;
    W$PA05 = *BLANK;
    W$PA06 = *BLANK;
    W$PA07 = *BLANK;
    W$PA08 = *BLANK;
    WKFENR = *ZERO;

  endsr;

  //----------------------------------------------------------------------------
  //  COPY-Module
  //----------------------------------------------------------------------------
  /include QCPYSRC,EXFLPO
  /include QCPYSRC,MCTRTP
  /include QCPYSRC,PRFIRMFIRM
  /include QCPYSRC,PRFUKT
  /include QCPYSRC,RDTRDNTRDN
end-proc;
//------------------------------------------------------------------------------
//  Prozeduren
//------------------------------------------------------------------------------
/include QCPYGEN,WAO016FM

//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
