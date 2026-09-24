**free
//------------------------------------------------------------------------------
/title Subfile-Anzeige der Datei IFGK "Interface KD-Angebot, Rahmenvertrag"
//--------------------------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ------------------------------------------------------------------------------------------------
//  Erstellt: PH 19.08.2026 DOMETIC Case 06160649
//  ------------------------------------------------------------------------------------------------
//  Änderung: PH 31.08.2026 DOMETIC Case 06160649. Backport auf R10.0
//--------------------------------------------------------------------------------------------------
//  Beschreibung:
//
//  Subfile-Anzeige der Datei IFGK "Interface KD-Angebot, Rahmenvertrag"
//  Weitere Informationen sind der Beschreibung im Verwaltungsprogramm TRIFGK zu entnehmen.
//
//  ------------------------------------------------------------------------------------------------
//  Nachfolgend sind die Empfangsparameter aus dem Feld #CKOMM aufgeführt.

//  #CKOMM:01:05 = KYIFGKIFFI IF Firmen-Nr
//  #CKOMM:06:32 = KYIFGKIFNR IF Auftrags-Nr
//--------------------------------------------------------------------------------------------------
//  Verfügbare Funktionen:
//    ...
//
//--------------------------------------------------------------------------------------------------
//  Optionen
//--------------------------------------------------------------------------------------------------
ctl-opt main(MCIFGK);
/include QCPYSRC,CTLOPTIONS

//--------------------------------------------------------------------------------------------------
//  Dateibeschreibungen
//--------------------------------------------------------------------------------------------------
dcl-f MCIFGKFM workstn usropn indds(DSINDICATORS)
  sfile(MCIFGKR1:RCDNBR)
  sfile(DLIFGKR1:WKRCNO)
  sfile(SFTRDZR1:RCDNRTRDZ)
  sfile(SFTRDZBR1:RCDNRTRDZB);

//--------------------------------------------------------------------------------------------------
// Includes
//--------------------------------------------------------------------------------------------------
/define TVORLAGE23
/define TVORLAGE24
/include QCPYSRC,STDMC
/include QCPYSRC,SXSICHT
/include QCPYSRC,CXIODCL
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSQL
/include QCPYSRC,SXTEXT
/include QCPYSRC,SXTRPC
/include QCPYSRC,SXTRTP
/include QCPYSRC,SXTRPA
/if defined(trendrel21ff)
/include QCPYSRC,SXTRSB
/endif
/include QCPYSRC,SXDATE

/include QCPYSRC,C_TRIFGK
/include QCPYSRC,C_TRTRDZ
///include QCPYSRC,C_T2ADRS

//--------------------------------------------------------------------------------------------------
//  Dateien
//--------------------------------------------------------------------------------------------------
dcl-ds AGKO   ext inz end-ds;
dcl-ds KYAGKO ext inz end-ds;

dcl-ds AGPA   ext inz end-ds;
dcl-ds KYAGPA ext inz end-ds;

dcl-ds IFGK   ext inz end-ds;
dcl-ds KYIFGK ext inz end-ds;
dcl-ds UXIFGK ext inz end-ds;

dcl-ds IFGP   ext inz end-ds;

dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds TRTK   ext inz end-ds;

dcl-ds TRWK   ext inz end-ds;
dcl-ds KYTRWK ext inz end-ds;

dcl-ds USIF   ext inz end-ds;
dcl-ds KYUSIF ext inz end-ds;

dcl-ds WERK   ext inz end-ds;
dcl-ds KYWERK ext inz end-ds;

dcl-ds ZKUN   ext inz end-ds;
dcl-ds KYZKUN ext inz end-ds;

//--------------------------------------------------------------------------------------------------
//  Kommunikationsparameter
//--------------------------------------------------------------------------------------------------
dcl-ds EXAFKU ext inz end-ds;
dcl-ds RTAFKU ext inz end-ds;

dcl-ds RTDATE ext inz end-ds;
dcl-ds EXFLPO ext inz end-ds;
dcl-ds EXFIRM ext inz end-ds;

dcl-ds EXTEXT ext inz end-ds;
dcl-ds RTTEXT ext inz end-ds;

dcl-ds EXUSIF ext inz end-ds;
dcl-ds RTUSIF ext inz end-ds;

dcl-ds EXUSZU ext inz end-ds;
dcl-ds RTUSZU ext inz end-ds;

dcl-ds EXWERK ext inz end-ds;

//--------------------------------------------------------------------------------------------------
//  Interne Datenstruktur
//--------------------------------------------------------------------------------------------------
dcl-ds EXUXMCPARM likeds(EXUX05Parm_t);
dcl-ds EXUXDLPARM likeds(EXUX05Parm_t);
dcl-ds EXUXSICHT  likeds(EXUXSICHT_t) inz(*likeds);
//dcl-ds KUNDADRS likeds(RTADRS01) inz;
//dcl-ds KDVSADRS likeds(RTADRS01) inz;

//--------------------------------------------------------------------------------------------------
//  Konstanten
//--------------------------------------------------------------------------------------------------
// Programmsteuerinformationen
dcl-c PGM_NAME const('MCIFGK');
dcl-c FMT_NAME const('MCIFGKFM');
dcl-c FMT_FUKTEDIT const('MCIFGKB1');
dcl-c FMT_FUKTDETAIL const('MCIFGKB2');

// Formate
dcl-c FMT_NONE const('00');
dcl-c FMT_SELECT_M1 const('M1');
dcl-c FMT_SUBFILE_01 const('01');
dcl-c FMT_DELETE const('DL');

//--------------------------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//--------------------------------------------------------------------------------------------------
dcl-s SFLIFGK like(KYIFGK) dim(999);
dcl-s SFLAUSW like(SFAUSW) dim(999);

dcl-s WKZ dim(99) inz like(IFGKWKNR);

//--------------------------------------------------------------------------------------------------
//  Einzelfelder
//--------------------------------------------------------------------------------------------------
dcl-s W1FIRM     like(DAFIRM);
dcl-s MODWAO     char(1);
dcl-s MODLAB     char(1);
dcl-s WKTRPAAFKU char(1);
dcl-s WKAFKUBENU char(1);
dcl-s WKTRPAWKNR char(1);
dcl-s WKTRPATRWK char(2);
dcl-s WKTRPABIFS like(IFGKIFST);
dcl-s WKTRPAUSIF char(1);

dcl-s WKIN91 like(C#MORE);
dcl-s WKIFGK like(KYIFGK);
dcl-s WKIFFI like(IFGKIFFI);
dcl-s WKWEIS like(WKAT01) inz;
dcl-s WKROTF like(WKAT01) inz;
dcl-s WKAT01ST like(WKAT01) inz;
dcl-s WKAT01KO like(WKAT01) inz;
dcl-s WKAT01PO like(WKAT01) inz;
dcl-s SFIFGKIFST like(IFGKIFST) inz;
dcl-s SFIFGKIFKO like(IFGKIFKO) inz;
dcl-s SFIFGKIFPO like(IFGKIFPO) inz;

dcl-s WNKOPF     varucs2(37) inz;
dcl-s SFIFGKAGNR char(10) inz;
dcl-s SFIFGKFENR varucs2(132) inz;

dcl-s fmtList    like(fmtList_t) inz;

dcl-s WKSTMT     like(WKSTMT_t)  inz;
dcl-s WKSTMT1    like(WKSTMT_t)  inz;

//--------------------------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_GNIFGK
// Purpose:
// Returns:
// Parameter:      #EXIFGK
// Parameter:      #RTIFGK
//--------------------------------------------------
dcl-pr C_GNIFGK extpgm('GNIFGK');
  #EXIFGK likeds(EXIFGK);
  #RTIFGK likeds(RTIFGK);
end-pr;

//--------------------------------------------------
// Program name: C_GNIFGKSB
// Purpose:
// Returns:
// Parameter:      #EXIFGK
// Parameter:      #RTIFGK
//--------------------------------------------------
dcl-pr C_GNIFGKSB extpgm('GNIFGKSB');
  #EXIFGK likeds(EXIFGK);
  #RTIFGK likeds(RTIFGK);
end-pr;

//--------------------------------------------------
// Program name: C_RUIFGKSB
// Purpose:
// Returns:
// Parameter:      #EXIFGK
// Parameter:      #RTIFGK
//--------------------------------------------------
dcl-pr C_RUIFGKSB extpgm('RUIFGKSB');
  #EXIFGK likeds(EXIFGK);
  #RTIFGK likeds(RTIFGK);
end-pr;

//--------------------------------------------------
// Program name: C_TRAFKU
// Purpose:
// Returns:
// Parameter:      #EXAFKU
// Parameter:      #RTAFKU
//--------------------------------------------------
dcl-pr C_TRAFKU extpgm('TRAFKU');
  #EXAFKU likeds(EXAFKU);
  #RTAFKU likeds(RTAFKU);
end-pr;

//--------------------------------------------------
// Program name: C_TRIFAK01FI
// Purpose:
// Returns:
// Parameter:      #W1FIRM
//--------------------------------------------------
dcl-pr C_TRIFAK01FI extpgm('TRIFAK01FI');
  #W1FIRM like(W1FIRM);
end-pr;

//--------------------------------------------------
// Program name: C_TRUSIF
// Purpose:
// Returns:
// Parameter:      #EXUSIF
// Parameter:      #RTUSIF
//--------------------------------------------------
DCL-PR C_TRUSIF    EXTPGM('TRUSIF');
  #EXUSIF          LIKEDS(EXUSIF);
  #RTUSIF          LIKEDS(RTUSIF);
END-PR;

//--------------------------------------------------------------------------------------------------
//  Programmstart
//--------------------------------------------------------------------------------------------------
dcl-proc MCIFGK;
  dcl-pi *n;
    #EXTR02 likeds(EXTR02);
    #IFGK   likeds(IFGK);
  end-pi;

 /include QCPYSRC,PGINITMC

  exsr UEBKOM;

  in EXTRLD;

  W1FIRM = DAFIRM;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;
  exsr KEYIFGK;

  *IN = *OFF;

  exsr BM1PR;
  if WKFENR <> *ZERO;
    WKIFMT = FMT_SELECT_M1;
  endif;

  //------------------------------------------------------------------------------------------------
  //  Programmsteuerung
  //------------------------------------------------------------------------------------------------
  dow WKIFMT <> FMT_NONE;

    if WKIOKZ <> *ON;
      dspOpen('MCIFGKFM': DSINDICATORS);
      WKIOKZ = *ON;

      fKeysAllowed.TRDZFUKT = FMT_FUKTEDIT;

      if WKPGST = PGST_DETAIL or WKPGST = 'DETAIL';
        fKeysAllowed.TRDZFUKT = FMT_FUKTDETAIL;
      endif;
      dsp_BuildOptionList(PGM_NAME: fKeysAllowed.TRDZFUKT);
      clear FmtList;
    endif;

    select;
    when WKIFMT = FMT_SUBFILE_01;
      exsr BILD01;
    when WKIFMT = FMT_DELETE;
      exsr BILDDL;
    when WKIFMT = FMT_SELECT_M1;
      exsr BILDM1;
    when WKIFMT = *blank
      or WKIFMT = FMT_NONE;
      leave;
    other;
      #CRTCD = '9';   // undefinierte Maske/Bildfolge
      leave;
    endsl;

  enddo;

  if #CRTCD = RTCD_CANCEL or #CRTCD = '9';
    clear IFGK;
  endif;

  if WKIOKZ = *ON and WKIWND = *ON;
    dspClose('MCIFGKFM');
    WKIOKZ = *OFF;
  endif;

  if W1FIRM <> DAFIRM;
    C_TRIFAK01FI(W1FIRM);
    in EXTRLD;
  endif;

  #EXTR02 = EXTR02;
  #IFGK = IFGK;
  return;

  //------------------------------------------------------------------------------------------------
  //  Eröffnungszyklus
  //------------------------------------------------------------------------------------------------
  begsr ANFANG;

    #CDATN = *ZERO;
    #CDATV = *ZERO;
    #CDAKW = *ZERO;
    #CDAJJ = *ZERO;
    #CMCAZ = *ZERO;

    WKFIRM = DAFIRM;
    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    // Firma in alle Keystrukten setzen
    KYGKFI = DAFIRM;      // AGKO
    KYAGPAFIRM = DAFIRM;  // AGPA
    KYIFGKFIRM = DAFIRM;  // IFGK
    KYIFGKIFFI = DAFIRM;  // IFGK
    KYVSFI = DAFIRM;      // KDVS
    KYKDFI = DAFIRM;      // KUND
    KYTWFI = DAFIRM;      // TRWK
    KYWRFI = DAFIRM;      // WERK
    KYKZFI = DAFIRM;      // ZKUN

    // Firmensprache in allen Keystrukturen setzen

    // Benutzersprache in allen Keystrukturen setzen
    EXTEXTSPCD = DAUSSP;  // TEXT

    EXFIRMFIRM = DAFIRM;
    exsr PRFIRMFIRM;

    WNKOPF = getKeyText(PGM_NAME: 'TRDN': DAUSSP);
    DSKOPF = %SUBST(EXFIRMKNAM:1:30) + %UCS2(' ') + WNKOPF;

    WKIFMT = FMT_SUBFILE_01;

    SFLIFGK = *BLANK;
    SFLAUSW = *BLANK;

    C#LCK0 = *OFF;
    C#LCK1 = *OFF;
    WKIN30 = C#LCK0;
    WKIN31 = C#LCK1;

    WKAT01 = COLOR_WHITE;
    WKWEIS = COLOR_WHITE;
    WKROTF = COLOR_RED;

    WKAT01ST = WKAT01;
    WKAT01KO = WKAT01;
    WKAT01PO = WKAT01;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    MCF = *BLANK;
    WKIOKZ = *OFF;

    EXFLPOFMTN = FMT_NAME;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Uebernahme KOM-Bereich
  //------------------------------------------------------------------------------------------------
  begsr UEBKOM;

    // Übernahme der Aufrufparameter in die internen Datenstrukturen
    IFGK   = #IFGK;
    EXTR02 = #EXTR02;

    if #CPGST <> WKPGST;
      SFLIFGK = *BLANK;
      SFLAUSW = *BLANK;
      RCDNBR = *ZERO;
    endif;

    MCFDS = #CMCFG;
    WKPGST = #CPGST;

    // Auf reinen Anzeigemodus umschalten
    if DATEST = PGST_DETAIL and WKPGST = *BLANK;
      WKPGST = PGST_DETAIL;
    endif;

    DSIFGKIFFI = %subst(#CKOMM:01);
    DSIFGKIFNR = %subst(#CKOMM:06);

    // Optionszeile setzen
    if #CUEBE = *BLANK;

      if WKPGST = PGST_DETAIL; // Anzeigemodus
        // 5=Detail  7=Positionen  10=Optionen
        #CUEBE = '0602';
      else;
        // 2=Ändern  4=Löschen  5=Detail  7=Positionen  10=Optionen
        #CUEBE = '0575';
      endif;

    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Vorlauf
  //------------------------------------------------------------------------------------------------
  begsr VORLAUF;

    EXTEXTMSGA = 'BNR';
    EXTEXTMSGN = #CUEBE;
    EXTEXTPGST = 'ERMBSK';
    C_TRTEXT(EXTEXT:RTTEXT);
    DSBT01 = RTTEXTTEXT;
    BSKDS = RTTEXTBSKZ;

    WKBT24 = *OFF;

    WKIFMT = FMT_SELECT_M1;

    WKIWND = *OFF;

    if WKPGST <> *BLANK and WKPGST <> PGST_DETAIL;
      WKIFMT = FMT_SUBFILE_01;
    endif;

    C#IN28 = trGetJobType();

    if WKTRPAWKNR = *ON
      and DSIFGKIFFI = *BLANK
      and DSIFGKIFNR = *BLANK
      and DSIFGKVIFS = *BLANK
      and DSIFGKBIFS = *BLANK
      and DSIFGKWKNR = *BLANK
      and DSIFGKAGAR = *BLANK
      and DSIFGKSABE = *BLANK
      and DSIFGKKDNR = *BLANK
      and DSIFGKVSNR = *BLANK
      and DSIFGKARF1 = *BLANK
      and DSIFGKARF2 = *BLANK
      and DSIFGKVWVD = *ZERO
      and DSIFGKBWVD = *ZERO
      and DSIFGKAGJJ = *ZERO
      and DSIFGKAGNR = *BLANK;
      exsr PRUSZU;
      DSIFGKWKNR = RTUSZUWKNR;
    endif;

    if WKTRPATRWK < '90';
      exsr ETRWK;
    endif;

    if DSIFGKBIFS = *BLANK;
      DSIFGKBIFS = WKTRPABIFS;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Select-Statement IFGK
  //------------------------------------------------------------------------------------------------
  begsr KEYIFGK;

    WKSTMT = 'SELECT * FROM IFGK WHERE IFGK.IFGKIFFI = ''' + DSIFGKIFFI + '''';

    // IF Auftrags-Nr
    if DSIFGKIFNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKIFNR': DSIFGKIFNR);
    endif;

    // IF Status von
    if DSIFGKVIFS <> *BLANK;
      WKSTMT += ' AND IFGK.IFGKIFST >= ''' + DSIFGKVIFS + '''';
    endif;

    // IF Status bis
    if DSIFGKBIFS <> *BLANK;
      WKSTMT += ' AND IFGK.IFGKIFST <= ''' + DSIFGKBIFS + '''';
    endif;

    // Werks-Nr
    if DSIFGKWKNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKWKNR': DSIFGKWKNR);
    endif;

    // Vertragsart
    if DSIFGKAGAR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKAGAR': DSIFGKAGAR);
    endif;

    // Sachbearbeiter
    if DSIFGKSABE <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKSABE': DSIFGKSABE);
    endif;

    // Kunden-Nr
    if DSIFGKKDNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKKDNR': DSIFGKKDNR: '1');
    endif;

    // Versand-Adr-Nr
    if DSIFGKVSNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKVSNR': DSIFGKVSNR);
    endif;

    // Referenz 1
    if DSIFGKARF1 <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKARF1': DSIFGKARF1: '1');
    endif;

    // Referenz 2
    if DSIFGKARF2 <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKARF2': DSIFGKARF2: '1');
    endif;

    // Wiedervorlage von
    if DSIFGKVWVD <> *ZERO;
      WKSTMT += ' AND ' + getSQLWhereDateDec('IFGK.IFGKWVDA':DSIFGKVWVD:'*GE');
    endif;

    // Wiedervorlage bis
    if DSIFGKBWVD <> *ZERO;
      WKSTMT += ' AND ' + getSQLWhereDateDec('IFGK.IFGKWVDA':DSIFGKBWVD:'*LE');
    endif;

    // Vertrags-Jahr
    IF DSIFGKAGJJ <> *ZERO;
      WKSTMT += ' AND' + getSQLWhereDecimal('IFGK.IFGKAGJJ':DSIFGKAGJJ:'*EQ');
    ENDIF;

    // Vertrags-Nr
    if DSIFGKAGNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGK.IFGKAGNR': DSIFGKAGNR);
    endif;

    /if defined(trendrel21ff)
    // optional: Ermitteln TRSB Berechtigung
    WKSTMT += getSQLwhereTRSB('IFGK');
    /endif
    WKSTMT += ' ORDER BY IFGK.IFGKIFST DESC, IFGK.IFGKTSTP DESC ';
    WKSTMT += ' FOR FETCH ONLY OPTIMIZE FOR 200 ROWS ';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Steuerroutine BILD01
  //------------------------------------------------------------------------------------------------
  begsr BILD01;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr B01DS;

    dow WKIFMT = FMT_SUBFILE_01;
      dspWrite('MCIFGKCL');

      if RCDNRTRDZ > *ZERO or DStoreValue('*SF.AUSW.MAX') > UC_0;
        dspWrite('SFTRDZK1');
      endif;

      if RCDNRTRDZB > *ZERO or DStoreValue('*SF.FUKT.MAX') > UC_0;
        dspWrite('SFTRDZBK1');
      endif;

      dspWrite('MCIFGK01');
      dspWrite('MCIFGKK1');
      clear fKeysAllowed.Number;
      // Standard F-Tasten aktivieren (max. 8 auf mal)
      dspFKeysAllowed(fKeysAllowed.Number: 3: 5: 10: 11: 12: 13: 26);
      // spezifische Funtionstasten ggf. einzeln (de)aktivieren:
      fkeysAllowed.Number(8) = *OFF;

      select;
      when WKPGST = PGST_DETAIL or WKPGST = 'DETAIL';
        dspWrite('MCIFGKB2');
      when WKBT24 = *OFF;
        dspFKeysAllowed(fKeysAllowed.Number: 6: 20: 24);
        dspWrite('MCIFGKB1');
      when WKBT24 = *ON;
        dspFKeysAllowed(fKeysAllowed.Number: 6: 20: 24);
        dspWrite('MCIFGKB3');
      endsl;

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      *IN99 = dspRead('MCIFGKK1');

      if *IN99;
        #CRTCD = RTCD_CANCEL;
        DAFEHL = *ON;
        #CPGST = *BLANK;
        WKIFMT = FMT_NONE;
        leave;
      endif;

      select;
      when fKeysAllowed.fKeyPressed > *zero
      and not (fkeysAllowed.Number(fKeysAllowed.fKeyPressed) = *ON);
        WKFENR = ERR_INVLDFUKT;
        iter;

      when C#EXIT = *ON;
        #CPGST = PGST_END;
        DAFEHL = *ON;
        #CRTCD = RTCD_CANCEL;
        WKIFMT = FMT_NONE;
        leave;

      when C#UPDT = *ON;
        SFLIFGK = *BLANK;
        SFLAUSW = *BLANK;
        leave;

      when C#NEWR = *ON;
        SFLIFGK = *BLANK;
        SFLAUSW = *BLANK;
        PCPGST = *BLANK;
        clear KYIFGKTSTP;
        exsr TRIFGK;
        leave;

      when RTTRDZAWCD <> *BLANKS;
        WKPGST = PGST_CALL;
        exsr TRTRDZ;
        C#WNDW = *ON;
        iter;

      when C#ACCS = *ON;
        SFAUSW = *BLANK;
        exsr TRTRDZ;

        if WKFENR <> *ZERO;
          iter;
        endif;

        leave;

      when C#VIEW = *ON;
        SI = dsp_Sichtwechsel('R1': SI: rtViewNumbers: EXUXMCPARM);
        iter;

      when C#CANC = *ON;
        WKIFMT = trListRemoveLAST(FmtList);
        #CPGST = *BLANK;
        #CRTCD = RTCD_CANCEL;
        SFLIFGK = *BLANK;
        SFLAUSW = *BLANK;
        leave;

      when C#MUST = *ON;
        SFLIFGK = *BLANK;
        SFLAUSW = *BLANK;
        PCPGST = PGST_MUSTER;
        clear KYIFGKTSTP;
        exsr TRIFGK;
        leave;

      when C#WEIT = *ON;
        WKBT24 = (WKBT24 = '0');
        iter;

      when C#PGUP = *ON;
        exsr BLAET;
        iter;

      when C#FUKT <> *ZERO and fkeysAllowed.Number(10) = *ON;
        SFAUSW = *BLANK;
        exsr TRTRDZ;

        if WKFENR <> *ZERO;
          iter;
        endif;

        leave;

      when C#FUKT <> *ZERO;
        if CSRRRN > *ZERO;
          PAGNBR = CSRRRN;
        endif;
        WKFENR = ERR_INVLDFUKT;
        iter;

      other;
        exsr B01RA;
        exsr B01SF;

        if CSRRRN > *ZERO;
          PAGNBR = CSRRRN;
        endif;

        select;
        when (WKFENR <> *ZERO and WKSUPD = *OFF)
          or (#CRTCD = RTCD_CANCEL and WKSUPD = *OFF);
          iter;
        when WKSUPD = *OFF;
          iter;
        other;
          leave;
        endsl;

      endsl;

    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Füllen Bildschirmformat 01
  //------------------------------------------------------------------------------------------------
  begsr B01DS;

    C#LCK0 = WKIN30;
    C#LCK1 = WKIN31;

    if WKUXMCOPEN = *ON;
      DStoreListClose(EXUXMCPARM);
      WKUXMCOPEN = *OFF;
    endif;

    if WKUXMCOPEN <> *ON;
      EXUXMCPARM = DStoreListOpen('MCSBFIFGK': 4 + 1996: 4: 'Subfile MCIFGK');
      WKUXMCOPEN = *ON;
    endif;

    C#INIT = *ON;
    dspWrite('MCIFGKK1');

    C#INIT = *OFF;
    C#MORE = *OFF;
    C#NEXT = *OFF;
    RCDNBR = *ZERO;
    PAGNBR = *ZERO;

    dspSflLayout(PGM_NAME: rtViewNumbers.Number(SI): '*');

    exsr CCURSOR;
    exsr OCURSOR;

    dow W$RCNO > RCDNBR or W$RCNO = *ZERO;

      exsr IFGKKY;

      C#PGUP = *ON;

      if C#MORE = *ON or W$RCNO = *ZERO;
        leave;
      endif;

    enddo;

    C#PGUP = *OFF;

    if W$RCNO > *ZERO and W$RCNO <= RCDNBR;
      PAGNBR = W$RCNO;
    endif;

    dspMCUEB(PGM_NAME: rtViewNumbers.Number(SI));
    WKFENR = NO_ERROR;

    #CRTCD = *BLANK;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Retten der Auswahl
  //------------------------------------------------------------------------------------------------
  begsr B01RA;

    I2 = *ZERO;
    WKIFGK = KYIFGK;
    SFLIFGK = *BLANK;
    SFLAUSW = *BLANK;

    dou RCDNBR = *ZERO;

      if RCDNBR = *ZERO;
        WKFENR = ERR_INVLD_F4;
        leave;
      endif;

      clear KYIFGK;
      KYIFGKFIRM = DAFIRM;
      *IN99 = dspReadC('MCIFGKR1');

      // Kein geänderter Satz mehr vorhanden, Format schliessen
      // todo: PGST_END erforderlich, um SFTDZ-SFLs zu schließen
      if *IN99;
        PCPGST = PGST_END;
        exsr TRIFGK;
        leave;
      endif;

      exsr UXMCREAD;

      if EXUXMCPARM.EXUX05RTCD <> *ZERO;
        iter;
      endif;

      C#NEXT = *ON;
      dspUpdate('MCIFGKR1');
      C#NEXT = *OFF;

      I2 += 1;
      SFLIFGK(I2) = KYIFGK;
      SFLAUSW(I2) = SFAUSW;
    enddo;

    KYIFGK = WKIFGK;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Plausiprüfung für Subfile
  //------------------------------------------------------------------------------------------------
  begsr B01SF;

    WKFENR = *ZERO;
    #CPGST = *BLANK;
    PCPGST = *BLANK;
    WKIDEL = *OFF;
    WKSUPD = *OFF;
    WKRCNO = *ZERO;
    W$RCNO = *ZERO;

    dou RCDNBR = *ZERO;

      if RCDNBR = *ZERO;
        WKFENR = ERR_INVLDINPUT;
        leave;
      endif;

      *IN99 = dspReadC('MCIFGKR1');

      if *IN99;
        PCPGST = PGST_END;
        leave;
      endif;

      exsr UXMCREAD;

      if EXUXMCPARM.EXUX05RTCD <> *ZERO;
        iter;
      endif;

      W$RCNO = RCDNBR;
      C#NEXT = *ON;
      dspUpdate('MCIFGKR1');
      C#NEXT = *OFF;

      #CRTCD = *BLANK;

      select;
      when %TRIM(SFAUSW) = PGST_SELECT and BSK(1) = 'J';
        PCPGST = PGST_select;
      when %TRIM(SFAUSW) = PGST_EDIT and BSK(2) = 'J';
        PCPGST = PGST_EDIT;
      when %TRIM(SFAUSW) = PGST_COPY and BSK(3) = 'J';
        PCPGST = PGST_COPY;
      when %TRIM(SFAUSW) = PGST_DELETE and BSK(4) = 'J';
        PCPGST = PGST_DELETE;
      when %TRIM(SFAUSW) = PGST_DETAIL and BSK(5) = 'J';
        PCPGST = PGST_DETAIL;
      when %TRIM(SFAUSW)='7' and BSK(7)='J';
        PCPGST = '7     ';
      when %TRIM(SFAUSW) <>' ' and BSK(10) = 'J';
        PCPGST = PGST_TRTRDZ;
      when %TRIM(SFAUSW) =' ';
        PCPGST = '      ';
      other;
        WKFENR = '0051';
        leave;
      endsl;

      exsr B01PR;

      if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
        leave;
      endif;

      if PCPGST = PGST_DELETE;

        WKIFGK = KYIFGK;
        WKIN91 = C#MORE;

        if WKIDEL = *OFF;

          WKIFMT = FMT_DELETE;
          exsr BILDDL;
          KYIFGK = WKIFGK;
          RCDNBR = W$RCNO;
          C#MORE = WKIN91;

          if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
            leave;
          endif;

          WKIDEL = *ON;

        endif;

      endif;

      select;

      when PCPGST = PGST_select;
        #CRTCD = 'J';
        WKIFMT = FMT_NONE;
        *IN99 = *ON;

      when PCPGST = PGST_DELETE;
        exsr TRIFGK;

        if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
          leave;
        endif;

        WKSUPD = *ON;

      when PCPGST = '7     ';
        exsr MCAUFRIFGP;

      when PCPGST = PGST_TRTRDZ;
        exsr TRTRDZ;

        if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
          leave;
        endif;

      when PCPGST <> *BLANK;
        exsr TRIFGK;

        if PCPGST <> PGST_DETAIL
          and PCPGST <> PGST_DELETE
          and PCPGST <> PGST_COPY
          and #CRTCD <> RTCD_CANCEL;

          // Subfile updaten
          exsr UPSBFL;
        endif;

        select;
        when PCPGST = PGST_EDIT;

        when DATEST = *BLANK and PCPGST <> PGST_DETAIL;
          WKSUPD = *ON;
        endsl;

      endsl;

      if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
        WKSUPD = *OFF;
        leave;
      endif;

      dspChain('MCIFGKR1': RCDNBR);
      SFAUSW = *BLANK;
      dspUpdate('MCIFGKR1');
      exsr LAUSW;

      select;

      when PCPGST = PGST_select;
        leave;

      when PCPGST = PGST_COPY;
        PCPGST = PGST_EDIT;
        KYIFGKTSTP = RTIFGKTSTP;
        exsr TRIFGK;

      endsl;

    enddo;

    if WKFENR <> *ZERO and RCDNBR > *ZERO;

      dspChain('MCIFGKR1': RCDNBR);
      C_AUSW = *ON;
      C#NEXT = *ON;
      dspUpdate('MCIFGKR1');
      C_AUSW = *OFF;
      C#NEXT = *OFF;

    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Plausiprüfung BILD01
  //------------------------------------------------------------------------------------------------
  begsr B01PR;

    WKFENR = *ZERO;

    CHIDS = '01C';
    exsr CHIFGK;

    if WKFENR <> *ZERO;
      C#LCK1 = *ON;
      leavesr;
    endif;

    if PCPGST = PGST_SELECT
      or PCPGST = PGST_DETAIL
      or PCPGST = '7     '
      or PCPGST = PGST_TRTRDZ
      or PCPGST = *BLANK;
      leavesr;
    endif;

    if PCPGST <> PGST_DELETE and PCPGST <> '6' and PCPGST <> *BLANK;
      if IFGKIFST >= '20';
        W$PA03 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):01);
        W$PA04 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):11);
        WKFENR = '0014';
        C_AUSW = *ON;
        leavesr;
      endif;
    endif;

    if PCPGST = PGST_DELETE or PCPGST = '6';
      if IFGKIFST > '20';
        W$PA03 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):01);
        W$PA04 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):11);
        WKFENR = '0014';
        C_AUSW = *ON;
        leavesr;
      endif;
    endif;

    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Steuerroutine Löschanzeige
  //------------------------------------------------------------------------------------------------
  begsr BILDDL;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr BDLDS;

    dow WKIFMT = FMT_DELETE;

      dspWrite('MCIFGK01');
      dspWrite('DLIFGKK1');
      clear fKeysAllowed;
      dspFKeysAllowed(fKeysAllowed.Number: 11: 12: 13: 26);
      dspWrite('MCIFGKDL');

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      *in99 = dspRead('DLIFGKK1');

      if *IN99;
        #CRTCD = RTCD_CANCEL;
        DAFEHL = *ON;
        #CPGST = *BLANK;
        WKIFMT = FMT_NONE;
        leave;
      endif;

      select;

      when fKeysAllowed.fKeyPressed > *zero
        and not (fkeysAllowed.Number(fKeysAllowed.fKeyPressed) = *ON);
        WKFENR = ERR_INVLDFUKT;
        iter;

      when C#VIEW = *ON;
        SI = dsp_Sichtwechsel('DLIFGKR1': SI: rtViewNumbers: EXUXDLPARM);
        iter;

      when C#CANC = *ON;
        WKIFMT = trListRemoveLast(FmtList);
        #CRTCD = RTCD_CANCEL;
        leave;

      when C#FUKT <> *ZERO;
        WKFENR = ERR_INVLDFUKT;
        iter;

      other;
        WKIFMT = trListRemoveLast(FmtList);
        leave;

      endsl;

    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Füllen Löschanzeige
  //------------------------------------------------------------------------------------------------
  begsr BDLDS;

    #CRTCD = *BLANK;
    WKFENR = *ZERO;

    if WKUXDLOPEN = *ON;
      DStoreListClose(EXUXDLPARM);
      WKUXDLOPEN = *OFF;
    endif;

    if WKUXDLOPEN <> *ON;
      EXUXDLPARM = DStoreListOpen('DLSBFIFGK': 4 + 1996: 4: 'Subfile DLIFGK');
      WKUXDLOPEN = *ON;
    endif;

    C#INIT = *ON;
    dspWrite('DLIFGKK1');

    C#INIT = *OFF;
    C#MORE = *OFF;
    C#NEXT = *OFF;

    RCDNBR = 1;
    WKRCNO = *ZERO;

    dou C#MORE = *ON;

      if WKIDEL = *ON and %trim(SFAUSW) = PGST_DELETE;
        WKRCNO += 1;
        dspWriteSfl('DLIFGKR1': WKRCNO);
        exsr UXDLWRTE;
      endif;

      *in99 = dspReadC('MCIFGKR1');

      if *IN99;
        C#MORE = *ON;
        leave;
      endif;

      exsr UXMCREAD;

      if EXUXMCPARM.EXUX05RTCD <> *ZERO;
        iter;
      endif;

      C#NEXT = *ON;
      dspUpdate('MCIFGKR1');
      C#NEXT = *OFF;
    enddo;

    WKPGNO = 1;
    select;
    when WKIDEL = *ON;
      // Datensatz wird gelöscht.
      WKFENR = '0005';
    endsl;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Steuerroutine BILDM1
  //------------------------------------------------------------------------------------------------
  begsr BILDM1;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr BM1DS;

    dow WKIFMT = FMT_SELECT_M1;

      exsr EFLPO;
      dspWrite('MCIFGKM1');
      clear fKeysAllowed.Number;
      dspFKeysAllowed(fKeysAllowed.Number: 3: 4: 12: 13);
      dspWrite('MCIFGKB4');
      WKIWND = *ON;

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      C#WNDW = *OFF;

      *IN99 = dspRead('MCIFGKM1');

      if *IN99;
        #CRTCD = RTCD_CANCEL;
        DAFEHL = *ON;
        #CPGST = *BLANK;
        WKIFMT = FMT_NONE;
        leave;
      endif;

      select;
      when fKeysAllowed.fKeyPressed > *zero
      and not (fkeysAllowed.Number(fKeysAllowed.fKeyPressed) = *ON);
        WKFENR = ERR_INVLDFUKT;
        iter;

      when C#EXIT = *ON;
        #CPGST = PGST_END;
        DAFEHL = *ON;
        #CRTCD = RTCD_CANCEL;
        WKIFMT = FMT_NONE;
        leave;

      when C#SELC = *ON;
        exsr MCAUFR;

        if WKTRTP = *ON or WKFENR <> *ZERO;
          iter;
        endif;

      when C#CANC = *ON;
        WKIFMT = trListRemoveLast(FmtList);
        #CPGST = *BLANK;
        #CRTCD = RTCD_CANCEL;
        leave;

      when C#FUKT <> *ZERO;
        WKFENR = ERR_INVLDFUKT;
        iter;

      endsl;

      exsr BM1PR;

      if WKFENR <> *ZERO;
        iter;
      endif;

      exsr KEYIFGK;

      SFLIFGK = *BLANK;
      SFLAUSW = *BLANK;
      W$RCNO = *ZERO;
      WKIFMT = FMT_SUBFILE_01;
      leave;

    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Füllen Bildschirmformat M1
  //------------------------------------------------------------------------------------------------
  begsr BM1DS;

    C#LCK0 = WKIN30;
    C#LCK1 = WKIN31;

    if DSIFGKIFFI = *BLANK;
      #CPGST = 'DEFAUL';
      WKIFFI = *BLANK;
      exsr TRUSIF;
      DSIFGKIFFI = RTUSIFIFFI;
    endif;

    if WKTRPAAFKU = *ON
      and WKAFKUBENU = *ON;
      clear EXAFKU;
      clear RTAFKU;
      EXAFKUPGST = 'ERKDNR';
      EXAFKUBENU = DAUSER;
      exsr TRAFKU;
      if RTAFKUKDNR <> *BLANK;
        DSIFGKKDNR = RTAFKUKDNR;
      endif;
    endif;

    TXIFGKIFFI = *BLANK;
    TXIFGKKDNR = *BLANK;

    if DSIFGKIFFI <> *BLANK;
      TXIFGKIFFI = getTRTPText('IFFI': DSIFGKIFFI);
    endif;

    if DSIFGKKDNR <> *BLANK;
      exsr PRIFGKKDNR;
    endif;

    #CPGST = *BLANK;
    #CRTCD = *BLANK;

    if DSIFGKIFFI = *BLANK;
      EXFLPOFLDN = 'DSIFGKIFFI';
    else;
      EXFLPOFLDN = 'DSIFGKVIFS';
    endif;
    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Plausiprüfung für BILDM1
  //------------------------------------------------------------------------------------------------
  begsr BM1PR;

    WKFENR = *ZERO;

    exsr PRIFGKIFFI;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKIFNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKVIFS;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKBIFS;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKWKNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKAGAR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKSABE;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKKDNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKVSNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKARF1;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGKARF2;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    trReturns = trDateCheck(DSIFGKVWVD: C_EUR: *ON: RTDATEDATE);
    DSIFGKVWVD = RTDATEDATE;
    EXFLPOFLDN = 'DSIFGKVWVD';
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    trReturns = trDateCheck(DSIFGKBWVD: C_EUR: *ON: RTDATEDATE);
    DSIFGKBWVD = RTDATEDATE;
    EXFLPOFLDN = 'DSIFGKBWVD';
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    trReturns = trDateRangeCheck(DSIFGKVWVD: DSIFGKBWVD: C_EUR: *ON);
    if WKFENR <> *ZERO;
      // DS-Datumsfeldbezeichnung, WKFFLD = 'V' oder 'B'
      EXFLPOFLDN = ifTrue(WKFFLD = 'V': 'DSIFGKVWVD': 'DSIFGKBWVD');
      leavesr;
    endif;

    exsr PRIFGKAGNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Funktionstaste 4 BILDM1
  //------------------------------------------------------------------------------------------------
  begsr MCAUFR;

    WKTRTP = *OFF;
    WKFENR = *ZERO;

    EXFLPOFLDN = FLDNAM;
    exsr EFLPO;

    select;

    when EXFLPOKZIO = *OFF;
      WKFENR = '0052';

    when FLDNAM = *BLANK;
      WKFENR = ERR_INVLD_F4;
      EXFLPOFLDN = 'DSIFGKVIFS';

    when FLDNAM = 'DSIFGKIFFI';
      exsr MCIFGKIFFI;

    when FLDNAM = 'DSIFGKVIFS';
      exsr MCIFGKVIFS;

    when FLDNAM = 'DSIFGKBIFS';
      exsr MCIFGKBIFS;

    when FLDNAM = 'DSIFGKWKNR';
      exsr MCIFGKWKNR;

    when FLDNAM = 'DSIFGKAGAR';
      exsr MCIFGKAGAR;

    when FLDNAM = 'DSIFGKSABE';
      exsr MCIFGKSABE;

    when FLDNAM = 'DSIFGKKDNR';
      exsr MCIFGKKDNR;

    when FLDNAM = 'DSIFGKVSNR';
      exsr MCIFGKVSNR;

    when FLDNAM = 'DSIFGKVWVD';
      exsr MCIFGKVWVD;

    when FLDNAM = 'DSIFGKBWVD';
      exsr MCIFGKBWVD;

    when FLDNAM = 'DSIFGKAGNR';
      exsr MCIFGKAGNR;

    other;
      WKFENR = ERR_INVLD_F4;

    endsl;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine IFFI
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKIFFI;

    C#WNDW = *ON;

    if DSIFGKIFFI = *BLANK;
      TXIFGKIFFI = *BLANK;
    endif;

    %subst(KOMDS:1) = DAUSER;
    if WKTRPAUSIF = '1';
      %SUBST(KOMDS:16) = DAFIRM;
    ENDIF;
    #CPGST = 'USIF01';
    #CUEBE = '0010';
    exsr MCUSIF;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      DSIFGKIFFI = USIFIFFI;
      TXIFGKIFFI = getTRTPText('IFFI': DSIFGKIFFI);
      WKTRTP = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFFI
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKIFFI;

    EXFLPOFLDN = 'DSIFGKIFFI';
    TXIFGKIFFI = *BLANK;

    // Ermitteln IF-Firmen-Nr aus Datei IFGK
    if DSIFGKIFFI = *BLANK and MODWAO = *ON;
      select;
      when DSIFGKAGNR <> *BLANK;
        KYIFGKAGJJ = DSIFGKAGJJ;
        KYIFGKAGNR = DSIFGKAGNR;
        CHIDS = '04C';
        exsr CHIFGK;
        DSIFGKIFFI = IFGKIFFI;
      endsl;
    endif;

    // Eingabe IF Firmen-Nr erforderlich
    if DSIFGKIFFI = *BLANK;
      WKFENR = ERR_INVLDINPUT;
      leavesr;
    endif;

    #CPGST = 'PRUEFE';
    WKIFFI = DSIFGKIFFI;
    exsr TRUSIF;

    if WKFENR <> *ZERO;
      leavesr;
    elseif WKTRPAUSIF = '1' and USIFFIRM <> DAFIRM;
      WKFENR = ERR_INVLDINPUT;
      leavesr;
    endif;

    WKFENR = dspChkFldFENR(EXFLPOFLDN: ERR_INVLDINPUT: 'TRTP': 'IFFI');

    #CPGST = 'ERUSIF';
    WKIFFI = DSIFGKIFFI;
    exsr TRUSIF;

    if DAFIRM <> RTUSIFFIRM;

      if WKIOKZ = *ON;
        dspClose('MCIFGKFM');
        WKIOKZ = *OFF;
      endif;

      C_TRIFAK01FI(RTUSIFFIRM);
      in EXTRLD;

      exsr ANFANG;
      exsr ETRPA;
      //exsr ESBFL;
      exsr VORLAUF;

      trListAppend(FmtList: WKIFMT: *ON);

      if WKIOKZ <> *ON;
        dspOpen('MCIFGKFM': DSINDICATORS);
        WKIOKZ = *ON;
      endif;

      trListAppend(FmtList: WKIFMT: *ON);

    endif;

    WKFENR = NO_ERROR;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKIFNR;

    EXFLPOFLDN = 'DSIFGKIFNR';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine VIFS
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKVIFS;

    C#WNDW = *ON;

    WKFENR = dspMCAUFR(PGM_NAME: FLDNAM: 'TRPC': 'STATIFGK');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine VIFS
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKVIFS;

    EXFLPOFLDN = 'DSIFGKVIFS';

    WKFENR = dspChkFldFENR(EXFLPOFLDN: NO_ERROR: 'TRPC': 'STATIFGK');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine BIFS
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKBIFS;

    C#WNDW = *ON;

    WKFENR = dspMCAUFR(PGM_NAME: FLDNAM: 'TRPC': 'STATIFGK');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine BIFS
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKBIFS;

    EXFLPOFLDN = 'DSIFGKBIFS';

    WKFENR = dspChkFldFENR(EXFLPOFLDN: NO_ERROR: 'TRPC': 'STATIFGK');
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    if DSIFGKBIFS <> *BLANK and DSIFGKBIFS < DSIFGKBIFS;
      // Von WERT ist größer als bis WERT
      WKFENR = '0038';
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine WKNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKWKNR;

    C#WNDW = *ON;

    if DSIFGKWKNR = *BLANK;
      TXIFGKWKNR = *BLANK;
    endif;

    %subst(KOMDS:01) = DSIFGKWKNR;
    #CUEBE = '0010';
    exsr MCWERK;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGKWKNR = WRWKNR;
      //TXIFGKWKNR = WRKNAM;
      TXIFGKWKNR = WRWKBZ;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine WKNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKWKNR;

    EXFLPOFLDN = 'DSIFGKWKNR';
    TXIFGKWKNR = *BLANK;

    if DSIFGKWKNR <> *BLANK and %scan(ASTERISK:DSIFGKWKNR) = *ZERO;
      KYWRNR = DSIFGKWKNR;
      CHIDS  = '01C';
      exsr CHWERK;
      //TXIFGKWKNR = WRKNAM;
      TXIFGKWKNR = WRWKBZ;
      if WKFENR <> *ZERO;
        leavesr;
      endif;

      EXWERKWKNR = DSIFGKWKNR;
      EXWERKBENU = WKUSER;
      exsr PRWERK;
      if WKFENR <> *ZERO;
        W$PA03 = DSIFGKWKNR;
        W$PA04 = WKUSER;
      endif;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine AGAR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKAGAR;

    C#WNDW = *ON;

    %subst(KOMDS:01) = DSIFGKAGAR;
    #CPGST = 'DETAIL';
    #CUEBE = '0117';
    exsr MCAGPA;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGKAGAR = AGPAAGAT;
      TXIFGKAGAR = AGPAABEZ;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine AGAR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKAGAR;

    EXFLPOFLDN = 'DSIFGKAGAR';
    TXIFGKAGAR = *BLANK;

    if DSIFGKAGAR <> *BLANK and %scan(ASTERISK:DSIFGKAGAR) = *ZERO;
      KYAGPAAGAT = DSIFGKAGAR;
      CHIDS  = '01C';
      exsr CHAGPA;
      TXIFGKAGAR = AGPAABEZ;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine SABE
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKSABE;

    C#WNDW = *ON;

    if DSIFGKSABE = *BLANK;
      TXIFGKSABE = *BLANK;
    endif;

    WKFENR = dspMCAUFR(PGM_NAME: FLDNAM: 'TRTP': 'SABE');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine SABE
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKSABE;

    EXFLPOFLDN = 'DSIFGKSABE';
    TXIFGKSABE = *BLANK;

    WKFENR = dspChkFldFENR(EXFLPOFLDN: '*': 'TRTP': 'SABE');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine KDNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKKDNR;

    C#WNDW = *ON;

    if DSIFGKKDNR = *BLANK;
      TXIFGKKDNR = KDKNAM;
    endif;

    %subst(KOMDS:01) = DSIFGKKDNR;
    #CPGST = *BLANK;
    #CUEBE = '0526';
    exsr MCKUND;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGKKDNR = KDKDNR;
      TXIFGKKDNR = KDKNAM;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine KDNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKKDNR;

    EXFLPOFLDN = 'DSIFGKKDNR';
    TXIFGKKDNR = *BLANK;

    if DSIFGKKDNR <> *BLANK;
      KYKDNR = DSIFGKKDNR;
      CHIDS  = '01C';
      exsr CHKUND;

      if WKFENR <> *ZERO and %scan(ASTERISK:DSIFGKKDNR) = *ZERO;
        leavesr;
      endif;

      WKFENR = *ZERO;
      DSIFGKKDNR = KDKDNR;
      TXIFGKKDNR = KDKNAM;

      if %scan(ASTERISK:DSIFGKKDNR) = *ZERO;
        if WKTRPATRWK < '90';
          //clear EXWERK;
          //EXWERKPGST = 'PRUEFE';
          //EXWERKBENU = DAUSER;
          //EXWERKWKNR = KDWKNR;
          //exsr PRWERK;
          //if WKFENR <> *ZERO;
          //  W$PA03 = KDWKNR;
          //  W$PA04 = DAUSER;
          //  leavesr;
          //endif;
        endif;

        if WKTRPAAFKU = *ON
          and WKAFKUBENU = *ON;

          clear EXAFKU;
          clear RTAFKU;
          EXAFKUPGST = 'PRKDNR';
          EXAFKUBENU = DAUSER;
          EXAFKUKDNR = DSIFGKKDNR;
          exsr TRAFKU;
          if WKFENR <> *ZERO;
            leavesr;
          endif;
        endif;
      endif;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine VSNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKVSNR;

    C#WNDW = *ON;

    %subst(KOMDS:01) = DSIFGKKDNR;
    %subst(KOMDS:11) = DSIFGKVSNR;
    #CUEBE = '0526';
    #CPGST = *BLANK;
    exsr MCKDVS;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGKKDNR = VSKDNR;
      DSIFGKVSNR = VSVSNR;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine VSNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKVSNR;

    EXFLPOFLDN = 'DSIFGKVSNR';

    if DSIFGKVSNR <> *BLANK;
      KYVSKD = DSIFGKKDNR;
      KYVSNR = DSIFGKVSNR;
      CHIDS  = '01C';
      exsr CHKDVS;

      if WKFENR <> *ZERO and %scan(ASTERISK:DSIFGKVSNR) = *ZERO;
        leavesr;
      endif;

      WKFENR = *ZERO;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine ARF1
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKARF1;

    EXFLPOFLDN = 'DSIFGKARF1';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine ARF2
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKARF2;

    EXFLPOFLDN = 'DSIFGKARF2';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine VWVD
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKVWVD;

    C#WNDW = *ON;

    RTDATE = trDateAufruf(DSIFGKVWVD:C_EUR:C_EUR:WKFENR:WKTRTP:
    ifTrue((DSIFGKVWVD = *ZERO): C_POSANF: *BLANK));

    if WKFENR = *ZERO and WKTRTP = *OFF;
      DSIFGKVWVD = RTDATEDATE;
      WKTRTP = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine BWVD
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKBWVD;

    C#WNDW = *ON;

    RTDATE = trDateAufruf(DSIFGKBWVD:C_EUR:C_EUR:WKFENR:WKTRTP:
    ifTrue((DSIFGKBWVD = *ZERO): C_POSANF: *BLANK));

    if WKFENR = *ZERO and WKTRTP = *OFF;
      DSIFGKBWVD = RTDATEDATE;
      WKTRTP = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine AGNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGKAGNR;

    C#WNDW = *ON;

    KOM = *BLANK;
    %subst(KOMDS:24) = %editc(DSIFGKAGJJ:'X');
    %subst(KOMDS:39) = DSIFGKAGNR;
    #CPGST = '5     ';
    #CUEBE = '0535';
    exsr MCAGKO;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGKAGJJ = GKAGJJ;
      DSIFGKAGNR = GKAGNR;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine AGNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKAGNR;

    EXFLPOFLDN = 'DSIFGKAGNR';

    if DSIFGKAGNR <> *BLANK and %scan(ASTERISK:DSIFGKAGNR) = *ZERO;
      KYGKJH = DSIFGKAGJJ;
      KYGKAG = DSIFGKAGNR;
      CHIDS = '01C';
      exsr CHAGKO;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine IFGP
  //------------------------------------------------------------------------------------------------
  begsr MCAUFRIFGP;

    C#WNDW = *ON;
    EXFLPOFLDN = 'SFAUSW';

    if WKPGST <> PGST_DETAIL and WKPGST <> 'DETAIL' and DATEST = *BLANK;
      CHIDS = '01CL';
      exsr CHIFGK;
      if CHI(5) = 'L';
        // Benutzer &1 bearbeitet diesen Datensatz durch Bildschirm &2
        WKFENR = '0001';
        leavesr;
      endif;
    endif;

    %subst(KOMDS:01) = %char(KYIFGKTSTP);
    %subst(KOMDS:27) = IFGKIFFI;
    %subst(KOMDS:32) = IFGKIFNR;
    #CUEBE = *BLANK;
    if IFGKIFST >= '90'
      and IFGKIFST <> '99'
      or IFGKIFPO >= '90'
      and IFGKIFPO <> '99'
      or DATEST <> *BLANK
      or WKPGST = PGST_DETAIL
      or WKPGST = 'DETAIL'
      or BSK(02) <> 'J';
      #CPGST = PGST_DETAIL;
    endif;
    exsr MCIFGP;

    if K#IFGKLOCK = 'L';
      CHIDS  = '01CF';
      exsr CHIFGK;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine TRTK
  //------------------------------------------------------------------------------------------------
  begsr MCAUFRTRTK;

    C#WNDW = *ON;
    EXFLPOFLDN = 'SFAUSW';

    %SUBST(KOMDS:01) = DASPCD;
    %SUBST(KOMDS:02) = 'QQQQ';
    #CPGST = *BLANK;
    #CUEBE = '0010';
    exsr MCTRTK;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Blaetterroutine
  //------------------------------------------------------------------------------------------------
  begsr BLAET;

    exsr IFGKKY;

    dspWrite('MCIFGKLO');
    WKFENR = *ZERO;

    // Maximale Ansicht Datensätze erreicht
    if RCDNBR >= 9999;
      WKFENR = '4436';
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  close cursor
  //------------------------------------------------------------------------------------------------
  begsr CCURSOR;

    if WKOPENKY = *ON;
      WKOPENKY = *OFF;
      EXEC SQL CLOSE IFGKKY;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  open cursor
  //------------------------------------------------------------------------------------------------
  begsr OCURSOR;

    if WKOPENKY <> *ON;
      WKOPENKY = *ON;
      EXEC SQL PREPARE SQIFGK FROM :WKSTMT;
      EXEC SQL DECLARE IFGKKY SCROLL CURSOR FOR SQIFGK;
      EXEC SQL OPEN IFGKKY;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Anzeigen Datei IFGK
  //------------------------------------------------------------------------------------------------
  begsr IFGKKY;

    SFAUSW = *BLANK;
    C#NDSP = *OFF;
    WKILER = *OFF;
    W$PAGE = dspSflPageSize(PGM_NAME: 12);
    I0 = 1;

    if C#PGUP = *ON;
      EXEC SQL FETCH CURRENT FROM IFGKKY INTO :IFGK;
      RCDNBR = WKRENO;
    else;
      EXEC SQL FETCH NEXT FROM IFGKKY INTO :IFGK;
    endif;

    dow I0 <=(W$PAGE+1);

      if isSQLEOForError(SqlState) or RCDNBR = 9999;
        WKFENR = getSQLError(SqlState);
        W$PA03 = SqlState;
        C#MORE = *ON;      // SFLEND-KENNZ.
        leave;
      endif;

      exsr PRIFGKKY;                                                         // PRÜFEN
      if WKFENR <> *ZERO;
        EXEC SQL FETCH NEXT FROM IFGKKY INTO :IFGK;
        iter;
      endif;

      if I0 <= W$PAGE;
        KYIFGKTSTP = IFGKTSTP;

        RCDNBR += 1;

        exsr ADUMM;

        exsr ERSIC;

        exsr FAUSW;
        dsp_FKONS(EXUXSICHT: SI);

        dspWriteSFL('MCIFGKR1': RCDNBR);
        exsr UXMCWRTE;

        EXEC SQL FETCH NEXT FROM IFGKKY INTO :IFGK;
      endif;

      I0 += 1;

    enddo;

    WKRENO = dsp_SetPage(RCDNBR: 'MCIFGKR1': W$PAGE: EXUXMCPARM);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Prüfungen für die Anzeige
  //------------------------------------------------------------------------------------------------
  begsr PRIFGKKY;

    WKFENR = *ZERO;

    #CPGST = 'PRUEFE';
    WKIFFI = IFGKIFFI;
    exsr TRUSIF;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    if WKTRPATRWK < '90';
      select;
      when IFGKWKNR <> *BLANKS;
        I2 = %lookup(IFGKWKNR:WKZ);
        if I2 = *ZERO;
          WKFENR = '4462';
          leavesr;
        endif;
      //when IFGKWKNR = *BLANK;
      //  KYKDNR = IFGKKDNR;
      //  CHIDS  = '01C';
      //  exsr CHKUND;
      //  WKFENR = *ZERO;
      //  if KDWKNR <> *BLANK;
      //    I2 = %LOOKUP(KDWKNR:WKZ);
      //    if I2 = *ZERO;
      //      WKFENR = '4462';
      //      leavesr;
      //    endif;
      //  endif;
        endsl;
    endif;

    if WKTRPAAFKU = *ON
      and WKAFKUBENU = *ON;
      clear EXAFKU;
      clear RTAFKU;
      EXAFKUPGST = 'PRKDNR';
      EXAFKUBENU = DAUSER;
      EXAFKUKDNR = IFGKKDNR;
      exsr TRAFKU;
      if WKFENR <> *ZERO;
        leavesr;
      endif;
    endif;

    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Aufbereiten für Anzeigen
  //------------------------------------------------------------------------------------------------
  begsr ADUMM;

    SFIFGKAGNR = *BLANK;
    if IFGKAGJJ <> *ZERO;
      SFIFGKAGNR = %editc(IFGKAGJJ:'X') + IFGKAGNR;
    endif;

    SFIFGKIFST = IFGKIFST;
    SFIFGKIFKO = IFGKIFKO;
    SFIFGKIFPO = IFGKIFPO;

    KYKDNR = IFGKKDNR;
    CHIDS  = '01C';
    exsr CHKUND;

    //clear EXADRS01;
    //EXAD01DANA = 'KUND';
    //EXAD01KDNR = KDKDNR;
    //C_T2ADRS(EXADRS01:KUNDADRS);

    KYKZKD = IFGKKDNR;
    CHIDS  = '01C';
    exsr CHZKUN;

    KYVSKD = IFGKKDNR;
    KYVSNR = IFGKVSNR;
    CHIDS  = '01C';
    exsr CHKDVS;

    //clear EXADRS01;
    //EXAD01DANA = 'KDVS';
    //EXAD01KDNR = VSKDNR;
    //EXAD01VSNR = VSVSNR;
    //C_T2ADRS(EXADRS01:KDVSADRS);

    clear AGKO;

    IF IFGKAGNR <> *BLANK
      and IFGKFENR = NO_ERROR
      and IFGKIFST < '90';
      KYGKFI = IFGKFIRM;
      KYGKJH = IFGKAGJJ;
      KYGKAG = IFGKAGNR;
      CHIDS  = '01C';
      exsr CHAGKO;
      if CHI(05) = 'N';
        IFGKFENR = '0031';
        IFGKFFLD = 'DSAFNR';
      endif;
    endif;

    clear SFIFGKFENR;

    select;
    when IFGKFENR = *ZERO
      or IFGKFENR = *BLANK
      or IFGKIFST >= '90';
      clear EXTR02;
      IFGKFENR = *BLANK;
      clear SFIFGKFENR;
      WKAT01 = WKWEIS;

    when IFGKFENR <> *ZERO;
      SFIFGKFENR = getKeyText('STA'+IFGKFENR: 'TEXT': DAUSSP);
      WKAT01 = WKROTF;
    endsl;

    if IFGKIFST = '15' or IFGKIFST = '20';
      WKAT01ST = WKROTF;
    else;
      WKAT01ST = WKWEIS;
    endif;

    if IFGKIFPO = '15' or IFGKIFPO = '20';
      WKAT01PO = WKROTF;
    else;
      WKAT01PO = WKWEIS;
    endif;

    clear AGPA;
    if IFGKAGAR <> *BLANK;
      KYAGPAAGAT = IFGKAGAR;
      CHIDS  = '01C';
      exsr CHAGPA;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Sichten
  //------------------------------------------------------------------------------------------------
  begsr ERSIC;

    // todo: Bei wechselnden Sichtenbedingungen pro Zeile: hier dspSflLayout() aufrufen
    // dspSflLayout(PGM_NAME: rtViewNumbers.Number(SI): '*');
    trAufrSBFL();

    SIC = 1;

    dow SIC <= 10 and rtViewNumbers.Number(SIC) <> *ZERO;

      select;
      when C#IN28 = *ON and SIC <= %elem(EXUXSICHT.SatzJV);
        EXUXSICHT.SatzJV(SIC) = dspSflRow(PGM_NAME: rtViewNumbers.Number(SIC));
      other;
        EXUXSICHT.Satz(SIC) = dspSflRow(PGM_NAME: rtViewNumbers.Number(SIC));
      ENDSL;
      SIC += 1;

    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Füllen von AUSW beim Neuaufbau der Subfile
  //------------------------------------------------------------------------------------------------
  begsr FAUSW;

    I1 = %LOOKUP(KYIFGK:SFLIFGK);
    if I1 > 0;
      C#NEXT = *ON;
      SFAUSW = SFLAUSW(I1);
    else;
      C#NEXT = *OFF;
      SFAUSW = *BLANK;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Löschen von Ausw nach erfolgreicher Bearbeitung
  //------------------------------------------------------------------------------------------------
  begsr LAUSW;

    I1 = %LOOKUP(KYIFGK:SFLIFGK);
    if I1 > 0;
      SFLAUSW(I1) = *BLANK;
      SFLIFGK(I1) = *BLANK;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei IFGK
  //------------------------------------------------------------------------------------------------
  begsr TRIFGK;

    clear EXIFGK;
    EXIFGKPGST = PCPGST;
    EXIFGKTSTP = KYIFGKTSTP;
    if PCPGST = *BLANK;
      EXIFGKIFFI = DSIFGKIFFI;
    endif;
    C_TRIFGK(EXIFGK:RTIFGK);

    WKFFLD = RTIFGKFFLD;
    WKFENR = RTIFGKFENR;
    W$PA03 = RTIFGKPA03;
    W$PA04 = RTIFGKPA04;
    W$PA05 = RTIFGKPA05;
    W$PA06 = RTIFGKPA06;
    W$PA07 = RTIFGKPA07;

    #CRTCD = RTIFGKRTCD;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Übernehmen in KD-Angebot, Rahmenvertrag
  //------------------------------------------------------------------------------------------------
  begsr GNIFGK;

    clear EXIFGK;
    clear RTIFGK;
    EXIFGKPGST = PCPGST;
    EXIFGKTSTP = KYIFGKTSTP;
    EXIFGKIFFI = IFGKIFFI;
    EXIFGKIFNR = IFGKIFNR;
    if EXTRDNDANA = 'MCIFGKF8' or C#IN28 = *ON;
      C_GNIFGKSB(EXIFGK:RTIFGK);
    else;
      C_GNIFGK(EXIFGK:RTIFGK);
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Status auf '10' = "IF KD-Angebot, RV erstellt" zurücksetzen
  //------------------------------------------------------------------------------------------------
  begsr RUIFGK;

    clear EXIFGK;
    clear RTIFGK;
    EXIFGKPGST = PCPGST;
    EXIFGKTSTP = KYIFGKTSTP;
    EXIFGKIFFI = IFGKIFFI;
    EXIFGKIFNR = IFGKIFNR;
    if C#IN28 = *ON;                                                        // XML-CLIENT
      C_RUIFGKSB(EXIFGK:RTIFGK);
    else;
      C_TRIFGK(EXIFGK:RTIFGK);
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  UEIFGK Komplettbernahme
  //------------------------------------------------------------------------------------------------
  begsr UEIFGK;

    WKSTMT = 'SELECT * FROM IFGK WHERE IFGK.IFGKIFFI = ''' + DSIFGKIFFI + '''';

    // IF Auftrags-Nr
    if DSIFGKIFNR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKIFNR': DSIFGKIFNR);
    endif;

    // IF Status von
    if DSIFGKVIFS <> *BLANK;
      WKSTMT1 += ' AND IFGK.IFGKIFST >= ''' + DSIFGKVIFS + '''';
    endif;

    // IF Status bis
    if DSIFGKBIFS <> *BLANK;
      WKSTMT1 += ' AND IFGK.IFGKIFST <= ''' + DSIFGKBIFS + '''';
    endif;

    WKSTMT1 += ' AND IFGK.IFGKIFST BETWEEN ''10'' AND ''20''';

    // Werks-Nr
    if DSIFGKWKNR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKWKNR': DSIFGKWKNR);
    endif;

    // Vertragsart
    if DSIFGKAGAR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKAGAR': DSIFGKAGAR);
    endif;

    // Sachbearbeiter
    if DSIFGKSABE <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKSABE': DSIFGKSABE);
    endif;

    // Kunden-Nr
    if DSIFGKKDNR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKKDNR': DSIFGKKDNR: '1');
    endif;

    // Versand-Adr-Nr
    if DSIFGKVSNR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKVSNR': DSIFGKVSNR);
    endif;

    // Referenz 1
    if DSIFGKARF1 <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKARF1': DSIFGKARF1: '1');
    endif;

    // Referenz 2
    if DSIFGKARF2 <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKARF2': DSIFGKARF2: '1');
    endif;

    // Wiedervorlage von
    if DSIFGKVWVD <> *ZERO;
      WKSTMT1 += ' AND ' + getSQLWhereDateDec('IFGK.IFGKWVDA':DSIFGKVWVD:'*GE');
    endif;

    // Wiedervorlage bis
    if DSIFGKBWVD <> *ZERO;
      WKSTMT1 += ' AND ' + getSQLWhereDateDec('IFGK.IFGKWVDA':DSIFGKBWVD:'*LE');
    endif;

    // Vertrags-Jahr
    IF DSIFGKAGJJ <> *ZERO;
      WKSTMT1 += ' AND' + getSQLWhereDecimal('IFGK.IFGKAGJJ':DSIFGKAGJJ:'*EQ');
    ENDIF;

    // Vertrags-Nr
    if DSIFGKAGNR <> *BLANK;
      WKSTMT1 += ' AND ' + getSQLWhereString('IFGK.IFGKAGNR': DSIFGKAGNR);
    endif;

    /if defined(trendrel21ff)
    // optional: Ermitteln TRSB Berechtigung
    WKSTMT1 += getSQLwhereTRSB('IFGK');
    /endif
    WKSTMT1 += ' ORDER BY IFGK.IFGKIFST DESC, IFGK.IFGKTSTP DESC ';
    WKSTMT1 += ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQIFGK1 FROM :WKSTMT1;

    EXEC SQL DECLARE IFGKC1 CURSOR FOR SQIFGK1;

    EXEC SQL OPEN IFGKC1;

    SQLCOD = *ZERO;

    dow SQLCOD = *ZERO;

      EXEC SQL FETCH NEXT FROM IFGKC1 INTO :IFGK;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      exsr PRIFGKKY;
      if WKFENR = *ZERO;
        KYIFGKTSTP = IFGKTSTP;
        PCPGST = 'GNAGKO';
        exsr GNIFGK;
      endif;

    enddo;

    EXEC SQL CLOSE IFGKC1;

    exsr KEYIFGK;                                                          // FÜLLEN KEY

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Prüfen Datei AFKU
  //------------------------------------------------------------------------------------------------
  begsr TRAFKU;

    C_TRAFKU(EXAFKU:RTAFKU);

    WKPROG = RTAFKUPROG;
    WKDANA = RTAFKUDANA;
    WKFFLD = RTAFKUFFLD;
    WKFENR = RTAFKUFENR;
    W$PA03 = RTAFKUPA03;
    W$PA04 = RTAFKUPA04;
    W$PA05 = RTAFKUPA05;
    W$PA06 = RTAFKUPA06;
    W$PA07 = RTAFKUPA07;

    #CRTCD = RTAFKURTCD;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Prüfen Datei USIF
  //------------------------------------------------------------------------------------------------
  begsr TRUSIF;

    clear EXUSIF;
    clear RTUSIF;
    EXUSIFPGST = #CPGST;
    EXUSIFIFFI = WKIFFI;
    EXUSIFBENU = DAUSER;
    C_TRUSIF(EXUSIF:RTUSIF);

    #CRTCD = RTUSIFRTCD;
    WKFENR = RTUSIFFENR;
    W$PA03 = RTUSIFPA03;
    W$PA04 = RTUSIFPA04;
    W$PA05 = RTUSIFPA05;
    W$PA06 = RTUSIFPA06;
    W$PA07 = RTUSIFPA07;

  ENDSR;

  //------------------------------------------------------------------------------------------------
  //  Ermitteln Daten aus Firmen-Parameter
  //------------------------------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPA = *ON;

    rtViewNumbers = dspSflViewNumbers(PGM_NAME);

    SI = 1;

    // Prüfen, ob die Modifikationen für Fa. La Biosthetique aktiv sind
    MODLAB = getTRPAisMod('MODLAB');

    // Prüfen, ob die Modifikationen für Fa. WAECO aktiv sind
    MODWAO = getTRPAisMod('MODWAO');

    WKTRPABIFS = getTRPACode('MCIFGK': 'DEFAULT': 'BIFS');

    WKTRPAUSIF = (getTRPACode('MCIFGK': 'MCUSIF' : 'FIRM') = '1');

    WKTRPAWKNR = (getTRPACode('MCIFGK': 'DEFAULT': 'WKNR') = '1');

    exsr PRWERK;
    WKFENR = *ZERO;

    if EXWERKWSKZ = *ON
      and MODLAB = *OFF;
      WKTRPATRWK = '01';
    else;
      WKTRPATRWK = '90';
    endif;

    // Prüfen, ob die trend-Kunden-User-Zuordnung aktiv ist
    WKTRPAAFKU = (getTRPACode('TREND': 'AFKU': 'AFKU') = '1');

    WKAFKUBENU = *OFF;
    if WKTRPAAFKU = *ON;
      clear EXAFKU;
      clear RTAFKU;
      EXAFKUPGST = 'PRBENU';
      EXAFKUBENU = DAUSER;
      exsr TRAFKU;
      if RTAFKUFENR <> *ZERO;
        WKAFKUBENU = *ON;
      endif;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Ermitteln Werkszulassung
  //------------------------------------------------------------------------------------------------
  begsr ETRWK;

    WKZ = *BLANK;

    KYTWUS = DAUSER;
    KYTWWK = *BLANK;
    if DSIFGKWKNR <> *BLANK and %scan(ASTERISK:DSIFGKWKNR) = *ZERO;
      KYTWWK = DSIFGKWKNR;
    endif;
    CHIDS  = '01+';
    exsr CHTRWK;
    dow CHI(5) = 'J';

      if TWFIRM > KYTWFI
        or TWZUUS > KYTWUS;
        leave;
      endif;

      if %lookup(TWZUWK: WKZ) = *ZERO;
        I1 = %lookup(*BLANK: WKZ);
        if I1 > *ZERO;
          WKZ(I1) = TWZUWK;
        endif;
      endif;

      CHIDS  = '01R';
      exsr CHTRWK;
    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Auswahl 10 und Zugriff auf TRTRDZ
  //------------------------------------------------------------------------------------------------
  begsr TRTRDZ;

    WKTRTP = *OFF;
    WKFENR = *ZERO;
    WKTRDZZYKL = *OFF;

    dow WKFENR = *ZERO;

      clear EXTRDN;
      EXTRDNAWCD = SFAUSW;

      if RTTRDZAWCD <> *BLANKS;
        EXTRDNAWCD = RTTRDZAWCD;
        RTTRDZAWCD = *BLANK;
      endif;

      EXTRDNPGNA = PGM_NAME;
      EXTRDNPGST = PGST_CALL;

      // F10 = Optionen
      if SFAUSW = *BLANK;
        EXTRDNPGNA = FMT_FUKTEDIT;

        if WKPGST = PGST_DETAIL or WKPGST = 'DETAIL';
          EXTRDNPGNA = FMT_FUKTDETAIL;
        endif;

        EXTRDNFUKT = C#FUKT;
      endif;

      if WKTRDZZYKL = *OFF;
        EXTRDNMCKZ = *ON;
        WKTRDZZYKL = *ON;
      endif;

      C_TRTRDZ(EXTRDN);
      if EXTRDNRTCD = RTCD_CANCEL or EXTRDNFENR <> *ZERO;
        WKFENR = EXTRDNFENR;
        leave;
      endif;

      //TRDZ-Optionen anlegen
      select;

      when EXTRDNDANA = 'TRIFGK02';
        PCPGST = 'STATUS';
        EXSR TRIFGK;

      when EXTRDNDANA = 'TRTK';
        exsr MCAUFRTRTK;

      when EXTRDNDANA = 'TRIFGK01';
        if DATEST <> *BLANK
          or WKPGST = PGST_DETAIL
          or WKPGST = 'DETAIL'
          or BSK(2) = 'N';
          // Auswahl im Anzeige-Modus nicht relevant
          WKFENR = '0909';
          leave;
        endif;

        if IFGKIFST <= '20';
          PCPGST = 'GNAGKO';
          exsr GNIFGK;
          WKSUPD = *ON;
        else;
          W$PA03 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):01);
          W$PA04 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):11);
          WKFENR = '0014';
        endif;

        leave;

      when EXTRDNDANA = 'TRIFGKRU';
        if DATEST <> *BLANK
          or WKPGST = PGST_DETAIL
          or WKPGST = 'DETAIL'
          or BSK(2) = 'N';
          // Auswahl im Anzeige-Modus nicht relevant
          WKFENR = '0909';
          leave;
        endif;

        select;

        // Komplettübernahme
        when EXTRDNDANA = 'MCIFGKF8';
          exsr UEIFGK;
          // Job wurde zur Ausführung in die Warteschlange übertragen.
          WKFENR = '3558';
          #CRTCD = *BLANK;
          WKSUPD = *ON;
          leave;

        when IFGKIFST <= '10';
          // Es dürfen nur Sätze mit zur Auswahl passendem Status ausgewählt werden.
          WKFENR = '4299';
          leave;
        when IFGKIFST >= '90';
          W$PA03 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):01);
          W$PA04 = %subst(%char(getTRPCText('STATIFGK': IFGKIFST)):11);
          // "Auftrag hat bereits Status:"" &3&4"". Änderung nicht möglich."
          WKFENR = '4127';
          leave;
        other;
          PCPGST = 'RUIFGK';
          exsr RUIFGK;
          WKSUPD = *ON;
        endsl;

      when EXTRDNDANA = 'MCIFGP';
        exsr MCAUFRIFGP;

      other;
        WKFENR = '1217';  // "Ausgewählte Funktion wird nicht unterstützt."

      endsl;

      #CRTCD = *BLANK;

      if RTTRDZAWCD <> *BLANKS;
        leave;
      endif;

      if SFAUSW <> *BLANK and SFAUSW <> '10';
        leave;
      endif;

      if C#FUKT <> *ZERO and C#ACCS <> *ON;
        leave;
      endif;

    enddo;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Subfile-Satz
  //------------------------------------------------------------------------------------------------
  begsr UPSBFL;

    CHIDS = '01C';
    exsr CHIFGK;

    dspChain('MCIFGKR1': RCDNBR);

    KYIFGKTSTP = IFGKTSTP;

    C#NDSP = *OFF;

    exsr ADUMM;

    exsr ERSIC;

    exsr FAUSW;
    dsp_FKONS(EXUXSICHT: SI);

    // als geändert markiert lassen
    C#NEXT = *ON;
    dspUpdate('MCIFGKR1');
    DStoreListDelete(RCDNBR: EXUXMCPARM);
    exsr UXMCWRTE;
    C#NEXT = *OFF;

    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Schreiben Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXMCWRTE;

    UXIFGKTSTP = KYIFGKTSTP;
    DStoreListWrite(EXUXSICHT: RCDNBR: UXIFGK: EXUXMCPARM);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Lesen Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXMCREAD;

    UXIFGK = DStoreListChain(RCDNBR: EXUXMCPARM);
    EXUXSICHT   = EXUXMCPARM.EXUX05IDTA;
    KYIFGKTSTP = UXIFGKTSTP;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Schreiben Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXDLWRTE;

    UXIFGKTSTP = KYIFGKTSTP;
    DStoreListWrite(EXUXSICHT: WKRCNO: UXIFGK: EXUXDLPARM);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Aufbereiten der Nachrichten
  //------------------------------------------------------------------------------------------------
  begsr AUMSG;

    C_TRFEHLCL(WKFENR:KEYVAR:DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05: W$PA06:W$PA07);

    PGMNAM = PGM_NAME;
    C#INIT = *ON;

    select;
    when WKIFMT = FMT_SELECT_M1;
      dspWrite('MCIFGKCT');
      C#INIT = *OFF;
      dspSndMsg('MCIFGKCT': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    other;
      dspWrite('MCIFGKCT');
      C#INIT = *OFF;
      dspSndMsg('MCIFGKCT': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    endsl;

    C#INIT = *OFF;

    W$PA03 = *BLANK;
    W$PA04 = *BLANK;
    W$PA05 = *BLANK;
    W$PA06 = *BLANK;
    W$PA07 = *BLANK;
    W$PA08 = *BLANK;
    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  COPY-Module
  //------------------------------------------------------------------------------------------------
  /include QCPYSRC,CHAGKO
  /include QCPYSRC,CHAGPA
  /include QCPYSRC,CHIFGK
  /include QCPYSRC,CHKDVS
  /include QCPYSRC,CHKUND
  /include QCPYSRC,CHTRWK
  /include QCPYSRC,CHWERK
  /include QCPYSRC,CHZKUN
  /include QCPYSRC,EXFLPO
  /include QCPYSRC,MCAGKO
  /include QCPYSRC,MCAGPA
  /include QCPYSRC,MCKDVS
  /include QCPYSRC,MCKUND
  /include QCPYSRC,MCIFGP
  /include QCPYSRC,MCUSIF
  /include QCPYSRC,MCWERK
  /include QCPYSRC,MCTRTK
  /include QCPYSRC,PRFIRMFIRM
  /include QCPYSRC,PRUSZU
  /include QCPYSRC,PRWERK
end-proc;

//--------------------------------------------------------------------------------------------------
// Interne Prozeduren
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Aufruf Subfile-Zeilen-Ermittlung
//--------------------------------------------------------------------------------------------------
dcl-proc trAufrSbfl;

  // Files:
  dspSflFileRef(PGM_NAME: 'IFGK': IFGK);
  dspSflFileRef(PGM_NAME: 'KUND': KUND);
  //dspSflFileRef(PGM_NAME: 'KUNDADRS': KUNDADRS);
  dspSflFileRef(PGM_NAME: 'ZKUN': ZKUN);
  dspSflFileRef(PGM_NAME: 'KDVS': KDVS);
  //dspSflFileRef(PGM_NAME: 'KDVSADRS': KDVSADRS);
  dspSflFileRef(PGM_NAME: 'AGPA': AGPA);
  // Felder:
  dspSflColumnValue(PGM_NAME: '##IFGKAGNR': SFIFGKAGNR:WKAT01);
  dspSflColumnValue(PGM_NAME: 'TXIFGKFENR': SFIFGKFENR);
  dspSflColumnValue(PGM_NAME: '##IFST': SFIFGKIFST:WKAT01ST);
  dspSflColumnValue(PGM_NAME: '##IFKO': SFIFGKIFKO:WKAT01KO);
  dspSflColumnValue(PGM_NAME: '##IFPO': SFIFGKIFKO:WKAT01PO);

END-PROC;

//--------------------------------------------------------------------------------------------------
/include QCPYGEN,MCIFGKFM
/include QCPYSRC,CXIOFKTMC

//--------------------------------------------------------------------------------------------------
//  Ende des Programms
//--------------------------------------------------------------------------------------------------

