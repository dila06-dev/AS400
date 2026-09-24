**free
//------------------------------------------------------------------------------
/title  Aktualisieren Zolltarif-Nr im ArtikelStamm
//------------------------------------------------------------------------------
ctl-opt main(WAO036);
/include QCPYSRC,CTLOPTIONS
//------------------------------------------------------------------------------
//  Copyright 2026 by    trend SWM
//                       Verwaltung GmbH
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//------------------------------------------------------------------------------
//  Erstellt: ZG 19.01.2026 Dometic Case 05780597
//------------------------------------------------------------------------------
//
//-----------------------------------------------------------------------------
//
//  Dieses Programm übernimmt die Zolltartif-Nr (ZOTE) in Artikelstamm
//
//------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//------------------------------------------------------------------------------
/include QCPYSRC,STDDR

//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
/define TVORLAGE23
/include QCPYSRC,SXSQL
/include QCPYSRC,SXSTRING

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
DCL-DS TEIL   EXT INZ END-DS;
DCL-DS KYTEIL EXT INZ END-DS;

DCL-DS TRPA   EXT INZ END-DS;
DCL-DS KYTRPA EXT INZ END-DS;

dcl-ds ZOTE   ext inz end-ds;
dcl-ds KYZOTE ext inz end-ds;

dcl-ds SYTP   ext inz end-ds;
dcl-ds KYSYTP ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXFIRM ext inz end-ds;

dcl-ds EXTEIL ext inz end-ds;
dcl-ds RTTEIL ext inz end-ds;

dcl-ds EXTREND ext inz end-ds;
dcl-ds RTTREND ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
/include QCPYSRC,EXTRIN

dcl-ds EXZOTE;
  EXZOTETENR like(TETENR);     // Artikel
  EXZOTEDATE like(DUN080);     // Datum
  EXZOTEIMEX like(ZOTEIMEX);   // Inport/Export
end-ds;

//------------------------------------------------------------------------------
//  Konstanten
//------------------------------------------------------------------------------
// Allgemeine Programmsteuerinformationen
dcl-c PGM_NAME const('WAO036');

//-----------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//  Einzelfelder
//-----------------------------------------------------------------------------
dcl-s WKSORT       char(100);
dcl-s WKSTMT       varucs2(10000) inz;
DCL-S WKTRPAZOTN   CHAR(1);

dcl-s WKTENR   like(TETENR);
dcl-s WKZOTN   like(TEZOTN);

//-----------------------------------------------------------------------------
//  Externe Call-Prozeduren
//-----------------------------------------------------------------------------
 //--------------------------------------------------
 // Program name: C_EXTSTP
 // Purpose:              Ermitteln Timestamp mit Microsekunden
 // Returns:
 // Parameter:      #ZOTETSTP
 //--------------------------------------------------
 DCL-PR C_EXTSTP    EXTPGM('EXTSTP');
   #ZOTETSTP        LIKE(ZOTETSTP);
 END-PR;

//--------------------------------------
// Program name: C_TRTEIL
// Purpose:
// Returns:
// Parameter:      #EXTEIL
// Parameter:      #RTTEIL
//--------------------------------------
dcl-pr C_TRTEIL extpgm('TRTEIL');
  #EXTEIL likeds(EXTEIL);
  #RTTEIL likeds(RTTEIL);
end-pr;


 //--------------------------------------------------
// Program name: C_TRZOTN
// Purpose:
// Returns:
// Parameter:      #EXTR02
//--------------------------------------------------
DCL-PR C_TRZOTN    EXTPGM('TRZOTN');
  #EXTR02          LIKEDS(EXTR02);
END-PR;

//--------------------------------------------------
// Program name: WAO036
// Purpose: Hauptprozedur des Programms
// Parameter:     #EXTREND
//--------------------------------------------------
dcl-pr WAO036      extpgm('WAO036');
  #EXTREND         likeds(EXTREND);
end-pr;

//-----------------------------------------------------------------------------
//  Programmstart
//-----------------------------------------------------------------------------
dcl-proc WAO036;
  dcl-pi *n;
    #EXTREND       likeds(EXTREND);
  end-pi;

  exsr UEBEXTREND;

  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ETRPA;
    exsr ANFANG;
  endif;

  exsr VORLAUF;

  //---------------------------------------------------------------------------
  //**  Programmsteuerung
  //---------------------------------------------------------------------------

  select;
  when PCPGST = 'SCDJOB';
    exsr KEYZOTE;
    exsr OZOTE;
    exsr VZOTE;
  endsl;

  WKFIRM = DAFIRM;
  // Rückgabe der Aufrufparameter
  #EXTREND = EXTREND;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYTEFI     = DAFIRM;     // TEIL
    KYZOTEFIRM = DAFIRM;     // ZOTE
    KYSYTPFIRM = DAFIRM;     // SYTP

  endsr;

  //----------------------------------------------------------------------------
  //  Uebernahme EXTREND
  //----------------------------------------------------------------------------
  begsr UEBEXTREND;

    // Übernahme der Aufrufparameter in die internen Datenstrukturen
    EXTREND = #EXTREND;

    EXZOTETENR = %SUBST(EXTRNDKEYB:01);
    EXZOTEIMEX = %SUBST(EXTRNDKEYB:16);

    if %SUBST(EXTRNDKEYB:17:08) = *BLANK;
      EXZOTEDATE = %dec(%date: *iso); // Aktuelles Datum
    else;
      EXZOTEDATE = trDec(%SUBST(EXTRNDKEYB:17:08));
    endif;


    PCPGST = EXTRNDPGST;

  endsr;

  //----------------------------------------------------------------------------
  //  Vorlauf
  //----------------------------------------------------------------------------
  begsr VORLAUF;


  endsr;

  //----------------------------------------------------------------------------
  //  SQL-Select für ZOTE
  //----------------------------------------------------------------------------
  begsr KEYZOTE;

    WKSTMT = 'SELECT * FROM ZOTE WHERE ZOTEFIRM = ''' + DAFIRM + '''';

    // TENR
    if EXZOTETENR <> *BLANK;
      WKSTMT += ' AND ' + getSQLWhereString('ZOTETENR': EXZOTETENR);
    endif;

    WKSTMT += ' AND ' + getSQLWhereDecimal('ZOTEGADA': EXZOTEDATE  : '*LE');

    WKSTMT += ' AND (' + getSQLWhereDecimal('ZOTEGBDA': EXZOTEDATE  : '*GE');
    WKSTMT += ' OR ZOTEGBDA = 0)';

    WKSTMT += ' AND ' + getSQLWhereString('ZOTEIMEX': EXZOTEIMEX);

    WKSTMT += ' ORDER BY ZOTEFIRM, ZOTETENR, ZOTEGADA , ZOTEIMEX';
    WKSTMT += ' FOR FETCH ONLY';

  endsr;

  //----------------------------------------------------------------------------
  //  Öffnen Cursor ZOTEC1
  //----------------------------------------------------------------------------
  begsr OZOTE;

    EXEC SQL PREPARE SQZOTE FROM :WKSTMT;
    EXEC SQL DECLARE ZOTEC1 CURSOR FOR SQZOTE;
    EXEC SQL OPEN ZOTEC1;

  endsr;

  //----------------------------------------------------------------------------
  //  Lesen selektierte ZOTE-Sätze
  //----------------------------------------------------------------------------
  begsr VZOTE;

    SQLCOD = *ZERO;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM ZOTEC1 INTO :ZOTE;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      exsr PRZOTE;
      if WKFENR <> *zero;
        iter;
      endif;

      exsr TRTEIL;

    enddo;

    EXEC SQL CLOSE ZOTEC1;

  endsr;

 //----------------------------------------------------------------------------
  //  Prüfungen
  //---------------------------------------------------------------------------
  begsr PRZOTE;

     if ZOTEGADA <> *ZERO
       and ZOTEGADA > EXZOTEDATE;
       WKFENR = '0036';
       LEAVESR;
     endif;

     if ZOTEGBDA <> *ZERO
       and ZOTEGBDA < EXZOTEDATE;
       WKFENR = '0036';
       LEAVESR;
     endif;

     KYTENR = ZOTETENR;
     CHIDS = '01C';
     EXSR CHTEIL;
     if WKFENR <> *zero;
       LEAVESR;
     endif;

     if ZOTEZOTN = *BLANK;
     //  WKFENR = '0031';
     //  LEAVESR;
     elseif ZOTEZOTN = TEZOTN;
     //  WKFENR = '0031';
     //  LEAVESR;
     endif;

     if WKTRPAZOTN = *ON
       and ZOTEZOTN <> *BLANK;
       %SUBST(KOMDS:01) = ZOTEZOTN;
       #CKOMM = KOMDS;
       #CPGST = 'ERMFLD';
       C_TRZOTN(EXTR02);
       KOMDS = #CKOMM;
       if ZOTEZOTN <> %SUBST(KOMDS:01:15);
         WKFENR = '0031';
         LEAVESR;
       endif;
     endif;

  endsr;

  //---------------------------------------------------------------------------
  //  Update TEIL
  //---------------------------------------------------------------------------
  begsr TRTEIL;

    CLEAR EXTEIL;
    CLEAR RTTEIL;
    EXTEILIFKZ = *ON;
    EXTEILPGST = '2     ';
    EXTEILTENR = ZOTETENR;
    EXTEILZOTN = ZOTEZOTN;
    C_TRTEIL(EXTEIL: RTTEIL);
    if RTTEILFENR <> *zero;
      WKFENR = RTTEILFENR;
      leavesr;
    endif;

  endsr;

  //---------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //---------------------------------------------------------------------------
  begsr ETRPA;

    KYTAFI= DAFIRM;
    KYTATA = 'TRTEIL';
    KYTATC = 'ZOTN';
    KYTAPA = 'ZOTN';
    CHIDS = '01C';
    EXSR CHTRPA;
    WKTRPAZOTN = TAPCDE;
    IF WKTRPAZOTN <> *ON;
      WKTRPAZOTN = *OFF;
    ENDIF;

  endsr;

  //----------------------------------------------------------------------------
  //  Copy-Module
  //----------------------------------------------------------------------------
  /include QCPYSRC,CHTEIL
  /include QCPYSRC,CHTRPA
  /include QCPYSRC,CHSYTP
  /include QCPYSRC,PRFIRMFIRM
end-proc;

//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
