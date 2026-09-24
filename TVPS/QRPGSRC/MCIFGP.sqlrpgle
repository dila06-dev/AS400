**free
//------------------------------------------------------------------------------
/title Subfile-Anzeige der Datei IFGP "Interface KD-Angebots-, RV-Position"
//--------------------------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ------------------------------------------------------------------------------------------------
//  Erstellt: PH 17.09.2026 DOMETIC Case 06160649
//  ------------------------------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//--------------------------------------------------------------------------------------------------
//  Beschreibung:
//
//  Subfile-Anzeige der Datei IFGP "Interface KD-Angebots-, RV-Position"
//  Weitere Informationen sind der Beschreibung im Verwaltungsprogramm TRIFGP zu entnehmen.
//
//  ------------------------------------------------------------------------------------------------
//  Nachfolgend sind die Empfangsparameter aus dem Feld #CKOMM aufgeführt.

//  #CKOMM:01:26 = KYIFGPIFGK Zeit-Stempel IFGK (Kopf)
//  #CKOMM:27:05 = KYIFGPIFFI IF Firmen-Nr
//  #CKOMM:32:32 = KYIFGPIFNR IF Auftrags-Nr
//  #CKOMM:64:15 = DSIFGPTENR Ident-Nr
//  #CKOMM:79:02 = DSIFGPIFST IF Status
//  #CKOMM:81:04 = KYIFGPAGJJ Vertrag Jahr
//  #CKOMM:85:06 = KYIFGPAGNR Vertrags-Nr
//--------------------------------------------------------------------------------------------------
//  Verfügbare Funktionen:
//    ...
//
//--------------------------------------------------------------------------------------------------
//  Optionen
//--------------------------------------------------------------------------------------------------
ctl-opt main(MCIFGP);
/include QCPYSRC,CTLOPTIONS

//--------------------------------------------------------------------------------------------------
//  Dateibeschreibungen
//--------------------------------------------------------------------------------------------------
dcl-f MCIFGPFM workstn usropn indds(DSINDICATORS)
  sfile(MCIFGPR1:RCDNBR)
  sfile(DLIFGPR1:WKRCNO)
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

/include QCPYSRC,C_TRIFGP
/include QCPYSRC,C_TRTRDZ

//--------------------------------------------------------------------------------------------------
//  Dateien
//--------------------------------------------------------------------------------------------------
dcl-ds AGKO   ext inz end-ds;
dcl-ds KYAGKO ext inz end-ds;

dcl-ds AGPO   ext inz end-ds;
dcl-ds KYAGPO ext inz end-ds;

dcl-ds IFGK   ext inz end-ds;
dcl-ds KYIFGK ext inz end-ds;

dcl-ds IFGP   ext inz end-ds;
dcl-ds KYIFGP ext inz end-ds;
dcl-ds UXIFGP ext inz end-ds;

dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds TEIL   ext inz end-ds;
dcl-ds KYTEIL ext inz end-ds;

dcl-ds TRTK   EXT inz end-ds;

//--------------------------------------------------------------------------------------------------
//  Kommunikationsparameter
//--------------------------------------------------------------------------------------------------
dcl-ds RTDATE EXT INZ end-ds;
dcl-ds EXFLPO EXT inz end-ds;
dcl-ds EXFIRM EXT inz end-ds;

dcl-ds EXTEXT EXT inz end-ds;
dcl-ds RTTEXT EXT inz end-ds;

//--------------------------------------------------------------------------------------------------
//  Interne Datenstruktur
//--------------------------------------------------------------------------------------------------
dcl-ds EXUXMCPARM likeds(EXUX05Parm_t);
dcl-ds EXUXDLPARM likeds(EXUX05Parm_t);
dcl-ds EXUXSICHT    likeds(EXUXSICHT_t) inz(*likeds);

//--------------------------------------------------------------------------------------------------
//  Konstanten
//--------------------------------------------------------------------------------------------------
// Programmsteuerinformationen
dcl-c PGM_NAME const('MCIFGP');
dcl-c FMT_NAME const('MCIFGPFM');
dcl-c FMT_FUKTEDIT const('MCIFGPB1');
dcl-c FMT_FUKTDETAIL const('MCIFGPB2');

// Formate
dcl-c FMT_NONE const('00');
dcl-c FMT_SELECT_M1 const('M1');
dcl-c FMT_SUBFILE_01 const('01');
dcl-c FMT_DELETE const('DL');

//--------------------------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//--------------------------------------------------------------------------------------------------
dcl-s SFLIFGP like(KYIFGP) dim(999);
dcl-s SFLAUSW like(SFAUSW) dim(999);

//--------------------------------------------------------------------------------------------------
//  Einzelfelder
//--------------------------------------------------------------------------------------------------
dcl-s WKIFGP like(KYIFGP);
dcl-s WKWEIS like(WKAT01) inz;
dcl-s WKROTF like(WKAT01) inz;

dcl-s WKINEU char(1);
dcl-s SFIFGPAGNR char(10) inz;
dcl-s SFIFGPFENR varucs2(132) inz;

dcl-s fmtList    like(fmtList_t) inz;

dcl-s WKSTMT     like(WKSTMT_t)  inz;

//--------------------------------------------------------------------------------------------------
//  Programmstart
//--------------------------------------------------------------------------------------------------
dcl-proc MCIFGP;
  dcl-pi *n;
    #EXTR02 likeds(EXTR02);
    #IFGP   likeds(IFGP);
  end-pi;

 /include QCPYSRC,PGINITMC

  exsr UEBKOM;

  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;
  exsr KEYIFGP;

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
      dspOpen('MCIFGPFM': DSINDICATORS);
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
    clear IFGP;
  endif;

  if WKIOKZ = *ON and WKIWND = *ON;
    dspClose('MCIFGPFM');
    WKIOKZ = *OFF;
  endif;

  #EXTR02 = EXTR02;
  #IFGP = IFGP;
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
    KYGPFI = DAFIRM;      // AGPO
    KYIFGKFIRM = DAFIRM;  // IFGK
    KYIFGPFIRM = DAFIRM;  // IFGP
    KYVSFI = DAFIRM;      // KDVS
    KYKDFI = DAFIRM;      // KUND
    KYTEFI = DAFIRM;      // TEIL

    // Firmensprache in allen Keystrukturen setzen

    // Benutzersprache in allen Keystrukturen setzen
    EXTEXTSPCD = DAUSSP;  // TEXT

    EXFIRMFIRM = DAFIRM;
    exsr PRFIRMFIRM;

    WNKOPF = getKeyText(PGM_NAME: 'TRDN': DAUSSP);
    DSKOPF = %SUBST(EXFIRMKNAM:1:30) + %UCS2(' ') + WNKOPF;

    WKIFMT = FMT_SUBFILE_01;

    SFLIFGP = *BLANK;
    SFLAUSW = *BLANK;

    C#LCK0 = *OFF;
    C#LCK1 = *OFF;
    WKIN30 = C#LCK0;
    WKIN31 = C#LCK1;

    WKAT01 = COLOR_WHITE;
    WKWEIS = COLOR_WHITE;
    WKROTF = COLOR_RED;

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
    IFGP   = #IFGP;
    EXTR02 = #EXTR02;

    if #CPGST <> WKPGST;
      SFLIFGP = *BLANK;
      SFLAUSW = *BLANK;
      RCDNBR = *ZERO;
    endif;

    MCFDS = #CMCFG;
    WKPGST = #CPGST;

    // Auf reinen Anzeigemodus umschalten
    if DATEST = PGST_DETAIL and WKPGST = *BLANK;
      WKPGST = PGST_DETAIL;
    endif;

    DSIFGPIFGK = trTimestamp(%subst(#CKOMM:01:26));
    DSIFGPIFFI = %subst(#CKOMM:27:05);
    DSIFGPIFNR = %subst(#CKOMM:32:32);
    DSIFGPTENR = %subst(#CKOMM:64:15);
    DSIFGPIFST = %subst(#CKOMM:79:02);
    DSIFGPAGJJ = trDec(%subst(#CKOMM:81:04));
    DSIFGPAGNR = %subst(#CKOMM:85:06);

    // Optionszeile setzen
    if #CUEBE = *BLANK;

      if WKPGST = PGST_DETAIL; // Anzeigemodus
        // 5=Detail  10=Optionen
        #CUEBE = '0557';
      else;
        // 2=Ändern  4=Löschen  5=Detail  6=Storno  10=Optionen
        #CUEBE = '0574';
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
    WKINEU = *ON;

    if (WKPGST <> *BLANK and WKPGST <> PGST_DETAIL)
      or DSIFGPIFGK <> *LOVAL
      or DSIFGPIFFI <> *BLANK and DSIFGPIFNR <> *BLANK
      or DSIFGPTENR <> *BLANK
      or DSIFGPAGJJ <> *ZERO and DSIFGPAGNR <> *BLANK;
      WKIFMT = FMT_SUBFILE_01;
    endif;

    C#IN28 = trGetJobType();

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Select-Statement IFGP
  //------------------------------------------------------------------------------------------------
  begsr KEYIFGP;

    WKSTMT = 'SELECT * FROM IFGP WHERE 1 = 1';

    // Zeit-Stempel IFGK (Kopf)
    if DSIFGPIFGK <> *LOVAL;
      WKSTMT += ' AND IFGP.IFGPIFGK = ''' + %char(DSIFGPIFGK) + '''';
    endif;

    // IF Firmen-Nr
    if DSIFGPIFFI <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGP.IFGPIFFI': DSIFGPIFFI);
    endif;

    // IF Auftrags-Nr
    if DSIFGPIFNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGP.IFGPIFNR': DSIFGPIFNR);
    endif;

    // Ident-Nr
    if DSIFGPTENR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGP.IFGPTENR': DSIFGPTENR);
    endif;

    // IF Status
    if DSIFGPIFST <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGP.IFGPIFST': DSIFGPIFST);
    endif;

    // Vertrags-Jahr
    if DSIFGPAGJJ <> *ZERO;
      WKSTMT += ' AND' + getSQLWhereDecimal('IFGP.IFGPAGJJ':DSIFGPAGJJ:'*EQ');
    endif;

    // Vertrags-Nr
    if DSIFGPAGNR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('IFGP.IFGPAGNR': DSIFGPAGNR);
    endif;

    /if defined(trendrel21ff)
    // optional: Ermitteln TRSB Berechtigung
    WKSTMT += getSQLwhereTRSB('IFGP');
    /endif
    WKSTMT += ' ORDER BY IFGP.IFGPIFGK, IFGP.IFGPIFGP ';
    WKSTMT += ' FOR FETCH ONLY OPTIMIZE FOR 200 ROWS ';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Steuerroutine BILD01
  //------------------------------------------------------------------------------------------------
  begsr BILD01;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr B01DS;

    dow WKIFMT = FMT_SUBFILE_01;
      dspWrite('MCIFGPCL');

      if RCDNRTRDZ > *ZERO or DStoreValue('*SF.AUSW.MAX') > UC_0;
        dspWrite('SFTRDZK1');
      endif;

      if RCDNRTRDZB > *ZERO or DStoreValue('*SF.FUKT.MAX') > UC_0;
        dspWrite('SFTRDZBK1');
      endif;

      dspWrite('MCIFGP01');
      dspWrite('MCIFGPK1');
      clear fKeysAllowed.Number;
      // Standard F-Tasten aktivieren (max. 8 auf mal)
      dspFKeysAllowed(fKeysAllowed.Number: 3: 5: 10: 11: 12: 13: 26);
      // spezifische Funtionstasten ggf. einzeln (de)aktivieren:
      fkeysAllowed.Number(8) = *OFF;

      select;
      when WKPGST = PGST_DETAIL or WKPGST = 'DETAIL';
        dspWrite('MCIFGPB2');
      when WKBT24 = *OFF;
        dspFKeysAllowed(fKeysAllowed.Number: 6: 7: 20: 24);
        dspWrite('MCIFGPB1');
      when WKBT24 = *ON;
        dspFKeysAllowed(fKeysAllowed.Number: 6: 7: 20: 24);
        dspWrite('MCIFGPB3');
      endsl;

      if WKILER = *ON
        and WKINEU = *ON
        and WKPGST <> PGST_DETAIL
        and BSK(2) = 'J'
        and DSIFGPIFGK <> *LOVAL;
        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        PCPGST = *BLANK;
        KYIFGPIFGK = DSIFGPIFGK;
        KYIFGPIFGP = *ZERO;
        exsr TRIFGP;
        WKINEU = *OFF;
        leave;
      endif;

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      *IN99 = dspRead('MCIFGPK1');

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
        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        leave;

      when C#NEWR = *ON;
        exsr PRIFGPIFGK;
        if WKFENR <> *ZERO;
          iter;
        endif;

        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        PCPGST = *BLANK;
        KYIFGPIFGK = DSIFGPIFGK;
        KYIFGPIFGP = *ZERO;
        exsr TRIFGP;
        leave;

      when C#FT07 = *ON;
        WKIFMT = trListRemoveLAST(FmtList);
        #CPGST = *BLANK;
        #CRTCD = *BLANK;
        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        leave;

      when RTTRDZAWCD <> *BLANKS;
        WKPGST = PGST_CALL;
        exsr TRTRDZ;
        C#WNDW = *ON;
        iter;

      when C#ACCS = *ON;
        KYIFGPIFGK = DSIFGPIFGK;
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
        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        leave;

      when C#MUST = *ON;
        SFLIFGP = *BLANK;
        SFLAUSW = *BLANK;
        PCPGST = PGST_MUSTER;
        clear KYIFGPIFGK;
        KYIFGPIFGP = *ZERO;
        exsr TRIFGP;
        leave;

      when C#WEIT = *ON;
        WKBT24 = (WKBT24 = '0');
        iter;

      when C#PGUP = *ON;
        exsr BLAET;
        iter;

      when C#FUKT <> *ZERO and fkeysAllowed.Number(10) = *ON;
        KYIFGPIFGK = DSIFGPIFGK;
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
      EXUXMCPARM = DStoreListOpen('MCSBFIFGP': 4 + 1996: 4: 'Subfile MCIFGP');
      WKUXMCOPEN = *ON;
    endif;

    C#INIT = *ON;
    dspWrite('MCIFGPK1');

    C#INIT = *OFF;
    C#MORE = *OFF;
    C#NEXT = *OFF;
    RCDNBR = *ZERO;
    PAGNBR = *ZERO;

    dspSflLayout(PGM_NAME: rtViewNumbers.Number(SI): '*');

    exsr CCURSOR;
    exsr OCURSOR;

    dow W$RCNO > RCDNBR or W$RCNO = *ZERO;

      exsr IFGPKY;

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
    WKIFGP = KYIFGP;
    SFLIFGP = *BLANK;
    SFLAUSW = *BLANK;

    dou RCDNBR = *ZERO;

      if RCDNBR = *ZERO;
        WKFENR = ERR_INVLD_F4;
        leave;
      endif;

      clear KYIFGP;
      KYIFGPFIRM = DAFIRM;
      *IN99 = dspReadC('MCIFGPR1');

      // Kein geänderter Satz mehr vorhanden, Format schliessen
      // todo: PGST_END erforderlich, um SFTDZ-SFLs zu schließen
      if *IN99;
        PCPGST = PGST_END;
        exsr TRIFGP;
        leave;
      endif;

      exsr UXMCREAD;

      if EXUXMCPARM.EXUX05RTCD <> *ZERO;
        iter;
      endif;

      C#NEXT = *ON;
      dspUpdate('MCIFGPR1');
      C#NEXT = *OFF;

      I2 += 1;
      SFLIFGP(I2) = KYIFGP;
      SFLAUSW(I2) = SFAUSW;
    enddo;

    KYIFGP = WKIFGP;

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

      *IN99 = dspReadC('MCIFGPR1');

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
      dspUpdate('MCIFGPR1');
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

        WKIFGP = KYIFGP;

        if WKIDEL = *OFF;

          WKIFMT = FMT_DELETE;
          exsr BILDDL;
          KYIFGP = WKIFGP;
          RCDNBR = W$RCNO;

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
        exsr TRIFGP;

        if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
          leave;
        endif;

        WKSUPD = *ON;

      when PCPGST = PGST_TRTRDZ;
        exsr TRTRDZ;

        if #CRTCD = RTCD_CANCEL or WKFENR <> *ZERO;
          leave;
        endif;

      when PCPGST <> *BLANK;
        exsr TRIFGP;

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

      dspChain('MCIFGPR1': RCDNBR);
      SFAUSW = *BLANK;
      dspUpdate('MCIFGPR1');
      exsr LAUSW;

      select;

      when PCPGST = PGST_select;
        leave;

      when PCPGST = PGST_COPY;
        PCPGST = PGST_EDIT;
        KYIFGPIFGK = RTIFGPIFGK;
        KYIFGPIFGP = RTIFGPIFGP;
        exsr TRIFGP;

      endsl;

    enddo;

    if WKFENR <> *ZERO and RCDNBR > *ZERO;

      dspChain('MCIFGPR1': RCDNBR);
      C_AUSW = *ON;
      C#NEXT = *ON;
      dspUpdate('MCIFGPR1');
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
    exsr CHIFGP;

    if WKFENR <> *ZERO;
      C#LCK1 = *ON;
      leavesr;
    endif;

    if PCPGST = PGST_DETAIL
      or PCPGST = PGST_TRTRDZ
      or PCPGST = *BLANK;
      leavesr;
    endif;

    if IFGPIFST >= '20';
      W$PA03 = %subst(%char(getTRPCText('STATIFGK': IFGPIFST)):01);
      W$PA04 = %subst(%char(getTRPCText('STATIFGK': IFGPIFST)):11);
      WKFENR = '0014';
      C_AUSW = *ON;
      leavesr;
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

      dspWrite('MCIFGP01');
      dspWrite('DLIFGPK1');
      clear fKeysAllowed;
      dspFKeysAllowed(fKeysAllowed.Number: 11: 12: 13: 26);
      dspWrite('MCIFGPDL');

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      *in99 = dspRead('DLIFGPK1');

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
        SI = dsp_Sichtwechsel('DLIFGPR1': SI: rtViewNumbers: EXUXDLPARM);
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
      EXUXDLPARM = DStoreListOpen('DLSBFIFGP': 4 + 1996: 4: 'Subfile DLIFGP');
      WKUXDLOPEN = *ON;
    endif;

    C#INIT = *ON;
    dspWrite('DLIFGPK1');

    C#INIT = *OFF;
    C#MORE = *OFF;
    C#NEXT = *OFF;

    RCDNBR = 1;
    WKRCNO = *ZERO;

    dou C#MORE = *ON;

      if %TRIM(SFAUSW) = PGST_DELETE;
        WKRCNO += 1;
        dspWriteSfl('DLIFGPR1': WKRCNO);
        exsr UXDLWRTE;
      endif;

      *in99 = dspReadC('MCIFGPR1');

      if *IN99;
        C#MORE = *ON;
        leave;
      endif;

      exsr UXMCREAD;

      if EXUXMCPARM.EXUX05RTCD <> *ZERO;
        iter;
      endif;

      C#NEXT = *ON;
      dspUpdate('MCIFGPR1');
      C#NEXT = *OFF;
    enddo;

    WKPGNO = 1;
    WKFENR = '0005';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Steuerroutine BILDM1
  //------------------------------------------------------------------------------------------------
  begsr BILDM1;

    trListAppend(FmtList: WKIFMT: *ON);

    exsr BM1DS;

    dow WKIFMT = FMT_SELECT_M1;

      exsr EFLPO;
      dspWrite('MCIFGPW3');
      dspWrite('MCIFGPM1');
      clear fKeysAllowed.Number;
      dspFKeysAllowed(fKeysAllowed.Number: 3: 4: 12: 13);
      dspWrite('W3IFGPB1');
      WKIWND = *ON;

      if WKFENR <> *ZERO;
        exsr AUMSG;
      endif;

      C#WNDW = *OFF;

      *IN99 = dspRead('MCIFGPM1');

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

      exsr KEYIFGP;

      SFLIFGP = *BLANK;
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

    #CPGST = *BLANK;
    #CRTCD = *BLANK;

    EXFLPOFLDN = 'DSIFGPTENR';
    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Plausiprüfung für BILDM1
  //------------------------------------------------------------------------------------------------
  begsr BM1PR;

    WKFENR = *ZERO;

    exsr PRIFGPIFGK;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGPIFFI;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGPIFNR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGPTENR;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGPIFST;
    if WKFENR <> *ZERO;
      leavesr;
    endif;

    exsr PRIFGPAGNR;
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
      EXFLPOFLDN = 'DSIFGPTENR';

    when FLDNAM = 'DSIFGPIFGK';
      exsr MCIFGPIFGK;

    when FLDNAM = 'DSIFGPIFNR';
      exsr MCIFGPIFNR;

    when FLDNAM = 'DSIFGPTENR';
      exsr MCIFGPTENR;

    when FLDNAM = 'DSIFGPIFST';
      exsr MCIFGPIFST;

    when FLDNAM = 'DSIFGPAGNR';
      exsr MCIFGPAGNR;

    other;
      WKFENR = ERR_INVLD_F4;

    endsl;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine IFGK
  //------------------------------------------------------------------------------------------------
  begsr MCIFGPIFGK;

    C#WNDW = *ON;

    %subst(KOMDS:01) = DSIFGPIFFI;
    %subst(KOMDS:06) = DSIFGPIFNR;
    #CPGST = '5     ';
    #CUEBE = '0010';
    exsr MCIFGK;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      DSIFGPIFGK = IFGKTSTP;
      DSIFGPIFFI = IFGKIFFI;
      DSIFGPIFNR = IFGKIFNR;
      WKTRTP = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFGK
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPIFGK;

    EXFLPOFLDN = 'DSIFGPIFGK';
    clear DSIFGKKDNR;
    clear TXIFGKKDNR;
    clear DSIFGKVSNR;
    clear TXIFGKVSNR;

    if DSIFGPIFGK <> *LOVAL or C#NEWR = *ON;
      KYIFGKTSTP = DSIFGPIFGK;
      CHIDS = '01C';
      exsr CHIFGK;
      if WKFENR <> *ZERO;
        // Kopf-Satz nicht vorhanden
        WKFENR = '2808';
        leavesr;
      endif;

      if DSIFGPIFFI = *BLANK or DSIFGPIFFI <> IFGKIFFI;
        DSIFGPIFFI = IFGKIFFI;
      endif;

      if DSIFGPIFNR = *BLANK or DSIFGPIFNR <> IFGKIFNR;
        DSIFGPIFNR = IFGKIFNR;
      endif;

      if IFGKKDNR <> *BLANK;
        DSIFGKKDNR = IFGKKDNR;
        KYKDNR = DSIFGKKDNR;
        CHIDS  = '01C';
        exsr CHKUND;
        TXIFGKKDNR = KDKNAM;

        if IFGKVSNR <> *BLANK;
          DSIFGKVSNR = IFGKVSNR;
          KYVSKD = DSIFGKKDNR;
          KYVSNR = DSIFGKVSNR;
          CHIDS  = '01C';
          exsr CHKDVS;
          TXIFGKVSNR = VSKNAM;
        endif;
        WKFENR = NO_ERROR;
      endif;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFFI
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPIFFI;

    EXFLPOFLDN = 'DSIFGPIFFI';

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine IFNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGPIFNR;

    C#WNDW = *ON;

    %subst(KOMDS:01) = DSIFGPIFFI;
    %subst(KOMDS:06) = DSIFGPIFNR;
    #CPGST = '5     ';
    #CUEBE = '0010';
    exsr MCIFGK;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      DSIFGPIFGK = IFGKTSTP;
      DSIFGPIFFI = IFGKIFFI;
      DSIFGPIFNR = IFGKIFNR;
      WKTRTP = *ON;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFNR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPIFNR;

    EXFLPOFLDN = 'DSIFGPIFNR';

    if DSIFGPIFNR <> *BLANK or C#NEWR = *ON;
      KYIFGKIFFI = DSIFGPIFFI;
      KYIFGKIFNR = DSIFGPIFNR;
      CHIDS = '03C';
      exsr CHIFGK;
      if WKFENR <> *ZERO;
        // Kopf-Satz nicht vorhanden
        WKFENR = '2808';
        leavesr;
      endif;

      if DSIFGPIFGK = *LOVAL;
        DSIFGPIFGK = IFGKTSTP;
        exsr PRIFGPIFGK;
      endif;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine TENR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGPTENR;

    C#WNDW = *ON;

    %subst(KOMDS:1) = DSIFGPTENR;
    #CPGST = *BLANK;
    #CUEBE = '0526';
    exsr MCTEIL;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      DSIFGPTENR = TETENR;
      WKTRTP = *ON;
    endif;


  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine TENR
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPTENR;

    EXFLPOFLDN = 'DSIFGPTENR';

    if DSIFGPTENR <> *BLANK;
      KYTENR = DSIFGPTENR;
      CHIDS  = '01C';
      exsr CHTEIL;

      if WKFENR <> *ZERO and %SCAN(ASTERISK:DSIFGPTENR) = *ZERO;
        leavesr;
      endif;

      WKFENR = NO_ERROR;
      DSIFGPTENR = TETENR;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine IFST
  //------------------------------------------------------------------------------------------------
  begsr MCIFGPIFST;

    C#WNDW = *ON;

    WKFENR = dspMCAUFR(PGM_NAME: FLDNAM: 'TRPC': 'STATIFGK');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine IFST
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPIFST;

    EXFLPOFLDN = 'DSIFGPIFST';

    WKFENR = dspChkFldFENR(EXFLPOFLDN: NO_ERROR: 'TRPC': 'STATIFGK');

  endsr;

  //------------------------------------------------------------------------------------------------
  //  MC-Routine AGNR
  //------------------------------------------------------------------------------------------------
  begsr MCIFGPAGNR;

    C#WNDW = *ON;

    KOM = *BLANK;
    %subst(KOMDS:24) = %editc(DSIFGPAGJJ:'X');
    %subst(KOMDS:39) = DSIFGPAGNR;
    #CPGST = '5     ';
    #CUEBE = '0535';
    exsr MCAGKO;

    if WKTRTP = *OFF and WKFENR = *ZERO;
      WKTRTP = *ON;
      DSIFGPAGJJ = GKAGJJ;
      DSIFGPAGNR = GKAGNR;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  PR-Routine AGNR                                                   ´
  //------------------------------------------------------------------------------------------------
  begsr PRIFGPAGNR;

    EXFLPOFLDN = 'DSIFGPAGNR';

    if DSIFGPAGNR <> *BLANK and %scan(ASTERISK:DSIFGPAGNR) = *ZERO;
      KYGKJH = DSIFGPAGJJ;
      KYGKAG = DSIFGPAGNR;
      CHIDS = '01C';
      exsr CHAGKO;
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

    exsr IFGPKY;

    dspWrite('MCIFGPLO');
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
      EXEC SQL CLOSE IFGPKY;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  open cursor
  //------------------------------------------------------------------------------------------------
  begsr OCURSOR;

    if WKOPENKY <> *ON;
      WKOPENKY = *ON;
      EXEC SQL PREPARE SQIFGP FROM :WKSTMT;
      EXEC SQL DECLARE IFGPKY SCROLL CURSOR FOR SQIFGP;
      EXEC SQL OPEN IFGPKY;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Anzeigen Datei IFGP
  //------------------------------------------------------------------------------------------------
  begsr IFGPKY;

    SFAUSW = *BLANK;
    C#NDSP = *OFF;
    WKILER = *OFF;
    W$PAGE = dspSflPageSize(PGM_NAME: 09);
    I0 = 1;

    if C#PGUP = *ON;
      EXEC SQL FETCH CURRENT FROM IFGPKY INTO :IFGP;
      RCDNBR = WKRENO;
    else;
      EXEC SQL FETCH NEXT FROM IFGPKY INTO :IFGP;
    endif;

    dow I0 <=(W$PAGE+1);

      if isSQLEOForError(SqlState) OR RCDNBR = 9999;
        WKFENR = getSQLError(SqlState);
        W$PA03 = SqlState;
        C#MORE = *ON;      // SFLEND-KENNZ.
        leave;
      endif;

      if I0 <= W$PAGE;
        KYIFGPIFGK = IFGPIFGK;
        KYIFGPIFGP = IFGPIFGP;

        RCDNBR += 1;

        exsr ADUMM;
        exsr ERSIC;
        exsr FAUSW;
        dsp_FKONS(EXUXSICHT: SI);
        exsr UXMCWRTE;

        dspWriteSFL('MCIFGPR1': RCDNBR);

        EXEC SQL FETCH NEXT FROM IFGPKY INTO :IFGP;
      endif;

      I0 += 1;

    enddo;

    WKRENO = dsp_SetPage(RCDNBR: 'MCIFGPR1': W$PAGE: EXUXMCPARM);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Aufbereiten für Anzeigen
  //------------------------------------------------------------------------------------------------
  begsr ADUMM;

    SFIFGPAGNR = *BLANK;
    if IFGPAGJJ <> *ZERO;
      SFIFGPAGNR = %editc(IFGPAGJJ:'X') + IFGPAGNR;
    endif;

    KYTENR = IFGPTENR;
    CHIDS  = '01C';
    exsr CHTEIL;

    if IFGPTBZ1 = *BLANK;
      IFGPTBZ1 = TETBZ1;
    endif;

    clear AGKO;
    clear AGPO;

    if IFGPAGPO <> *ZERO
      and IFGPFENR = NO_ERROR
      and IFGPIFST < '90';

      KYGPFI = IFGPFIRM;
      KYGPJH = IFGPAGJJ;
      KYGPAG = IFGPAGNR;
      KYGPPO = IFGPAGPO;
      CHIDS  = '01C';
      exsr CHAGPO;
      if CHI(05) = 'N';
        IFGPFENR = '0031';
        IFGPFFLD = 'DSAGPO';
      endif;
    endif;

    if IFGPAGNR <> *BLANK;
      KYGKFI = IFGPFIRM;
      KYGKJH = IFGPAGJJ;
      KYGKAG = IFGPAGNR;
      CHIDS  = '01C';
      exsr CHAGKO;
      if CHI(05) = 'N';
        IFGPFENR = '0031';
        IFGPFFLD = 'DSAGNR';
      endif;
    endif;

    clear SFIFGPFENR;

    select;
    when IFGPFENR = *ZERO
      or IFGPFENR = *BLANK
      or IFGPIFST >= '90';
      clear EXTR02;
      IFGPFENR = *BLANK;
      clear SFIFGPFENR;
      WKAT01 = WKWEIS;

    when IFGPFENR <> *ZERO;
      SFIFGPFENR = getKeyText('STA' + IFGPFENR: 'TEXT': DASPCD);
      WKAT01 = WKROTF;
    endsl;

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

    I1 = %LOOKUP(KYIFGP:SFLIFGP);
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

    I1 = %LOOKUP(KYIFGP:SFLIFGP);
    if I1 > 0;
      SFLAUSW(I1) = *BLANK;
      SFLIFGP(I1) = *BLANK;
    endif;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Update Datei IFGP
  //------------------------------------------------------------------------------------------------
  begsr TRIFGP;

    clear EXIFGP;
    EXIFGPPGST = PCPGST;
    EXIFGPIFGK = KYIFGPIFGK;
    EXIFGPIFGP = KYIFGPIFGP;
    if PCPGST = *BLANK;
      EXIFGPIFFI = DSIFGPIFFI;
      EXIFGPIFNR = DSIFGPIFNR;
    endif;
    C_TRIFGP(EXIFGP:RTIFGP);

    WKFFLD = RTIFGPFFLD;
    WKFENR = RTIFGPFENR;
    W$PA03 = RTIFGPPA03;
    W$PA04 = RTIFGPPA04;
    W$PA05 = RTIFGPPA05;
    W$PA06 = RTIFGPPA06;
    W$PA07 = RTIFGPPA07;

    #CRTCD = RTIFGPRTCD;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Ermitteln Daten aus Firmen-Parameter
  //------------------------------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPA = *ON;

    rtViewNumbers = dspSflViewNumbers(PGM_NAME);

    SI = 1;

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

      when EXTRDNDANA = 'TRIFGP02';
        PCPGST = 'STATUS';
        exsr TRIFGP;

      when EXTRDNDANA = 'TRTK';
        exsr MCAUFRTRTK;

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
    exsr CHIFGP;

    dspChain('MCIFGPR1': RCDNBR);

    KYIFGPIFGK = IFGPIFGK;
    KYIFGPIFGP = IFGPIFGP;

    C#NDSP = *OFF;

    exsr ADUMM;
    exsr ERSIC;
    exsr FAUSW;
    dsp_FKONS(EXUXSICHT: SI);
    exsr UXMCWRTE;

    // als geändert markiert lassen
    C#NEXT = *ON;
    dspUpdate('MCIFGPR1');
    C#NEXT = *OFF;

    WKFENR = *ZERO;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Schreiben Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXMCWRTE;

    UXIFGPIFGK = KYIFGPIFGK;
    UXIFGPIFGP = KYIFGPIFGP;
    DStoreListWrite(EXUXSICHT: RCDNBR: UXIFGP: EXUXMCPARM);

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Lesen Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXMCREAD;

    UXIFGP = DStoreListChain(RCDNBR: EXUXMCPARM);
    EXUXSICHT   = EXUXMCPARM.EXUX05IDTA;
    KYIFGPIFGK = UXIFGPIFGK;
    KYIFGPIFGP = UXIFGPIFGP;

  endsr;

  //------------------------------------------------------------------------------------------------
  //  Schreiben Userindex
  //------------------------------------------------------------------------------------------------
  begsr UXDLWRTE;

    UXIFGPIFGK = KYIFGPIFGK;
    UXIFGPIFGP = KYIFGPIFGP;
    DStoreListWrite(EXUXSICHT: WKRCNO: UXIFGP: EXUXDLPARM);

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
      dspWrite('CTIFGPW3');
      C#INIT = *OFF;
      dspSndMsg('CTIFGPW3': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
    other;
      dspWrite('MCIFGPCT');
      C#INIT = *OFF;
      dspSndMsg('MCIFGPCT': WKFENR: DSJNAM:DSUSER:W$PA03:W$PA04:W$PA05:W$PA06:W$PA07);
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
  /include QCPYSRC,CHAGPO
  /include QCPYSRC,CHIFGK
  /include QCPYSRC,CHIFGP
  /include QCPYSRC,CHKDVS
  /include QCPYSRC,CHKUND
  /include QCPYSRC,CHTEIL
  /include QCPYSRC,EXFLPO
  /include QCPYSRC,MCAGKO
  /include QCPYSRC,MCIFGK
  /include QCPYSRC,MCTEIL
  /include QCPYSRC,MCTRTK
  /include QCPYSRC,PRFIRMFIRM
end-proc;

//--------------------------------------------------------------------------------------------------
// Interne Prozeduren
//--------------------------------------------------------------------------------------------------
//--------------------------------------------------------------------------------------------------
//  Aufruf Subfile-Zeilen-Ermittlung
//--------------------------------------------------------------------------------------------------
dcl-proc trAufrSbfl;

  // Files:
  dspSflFileRef(PGM_NAME: 'IFGP': IFGP: WKAT01);
  dspSflFileRef(PGM_NAME: 'TEIL': TEIL: WKAT01);
  // Felder:
  dspSflColumnValue(PGM_NAME: '##IFGPAGNR': SFIFGPAGNR:WKAT01);
  dspSflColumnValue(PGM_NAME: 'TXIFGPFENR': SFIFGPFENR);

END-PROC;

//--------------------------------------------------------------------------------------------------
/include QCPYGEN,MCIFGPFM
/include QCPYSRC,CXIOFKTMC

//--------------------------------------------------------------------------------------------------
//  Ende des Programms
//--------------------------------------------------------------------------------------------------

