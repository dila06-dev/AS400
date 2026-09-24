**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittelung von Preisen für eine Liste(!) von Teilen/Mengen
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: FM 03.06.2025 Case #04303295 "B2B", Preisermittlung
//  ----------------------------------------------------------------------------
//  Änderung: PH 27.01.2026 Case 05925626. Keine Rundung beim Aufruf BRPRKO (EXKONDKUKZ = *OFF)
//            und Übergabe 'B2BSQ002' an EXKONDPROG, damit in BRPRKO keine Rundung auf 15,2 erfolgt
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und ermittelt die Priese für
//  die angegebenen Teile für den angegebenen Kunden.
//
//  Übergabeparameter:
//  ##FIRM      - Firma
//  ##KDNR      - Kunden-Nr
//  ##AREA      - Gebiet wie "DE411"  todo: Bedeutung/Verwendung?
//  ##LIST      - Liste TENR + Menge
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ002);
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
dcl-s dummy char(1);

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds AGKD   inz likeds(KUND);

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds TEIL   ext inz end-ds;
dcl-ds KYTEIL ext inz end-ds;

dcl-ds TEUF   ext inz end-ds;
dcl-ds KYTEUF ext inz end-ds;

dcl-ds TRTP   ext inz end-ds;
dcl-ds KYTRTP ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01   ext inz end-ds;
dcl-ds EXTR02   ext inz end-ds;

dcl-ds EXGEWI   ext inz end-ds;
dcl-ds RTGEWI   ext inz end-ds;

dcl-ds EXKOND   ext inz end-ds;
dcl-ds RTKOND   ext inz end-ds;

dcl-ds EXPRKO01 ext inz end-ds;
dcl-ds RTPRKO01 ext inz end-ds;

//------------------------------------------------------------------------------
dcl-c LC_DELIMITER2 const(x'BB');   // u'007C', "|" pipe
//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  KDNR             varchar(10);
  TRANSDATE        zoned(8);
  CURRENCY         varchar(3);
  SKU              varchar(15);     // TENR
  QUANTITY         zoned(6);
  //NETPRICE         zoned(15: 2);
  NETPRICE         like(RTKONDNESU);
  RETAILPRICE      zoned(15: 2);
  DISCOUNT         zoned(15: 2);
  ERRMSG           varucs2(80);
end-ds;

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s ##CHI      char(8);
dcl-s WKC001     char(1);
dcl-s WKN219     zoned(21:9);
dcl-s WKFENR     char(4);
dcl-s WKTEMG     zoned(15:6);
dcl-s WKERRORMSG char(10);
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

//--------------------------------------------------
// Program name: C_ERGEWI
// Purpose:
// Returns:
// Parameter:    #EXGEWI
// Parameter:    #RTGEWI
//--------------------------------------------------
dcl-pr C_ERGEWI  extpgm('ERGEWI');
  #EXGEWI        likeds(EXGEWI);
  #RTGEWI        likeds(RTGEWI);
end-pr;

//--------------------------------------------------
// Program name: C_ERPRKO
// Purpose:
// Returns:
// Parameter:    #EXPRKO01
// Parameter:    #RTPRKO01
//--------------------------------------------------
dcl-pr C_ERPRKO  extpgm('ERPRKO');
  #EXPRKO01      likeds(EXPRKO01);
  #RTPRKO01      likeds(RTPRKO01);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ002;
  dcl-pi *n;
    inFIRM         varchar( 2);
    inKDNR         varchar(10);
    inGADA         zoned(8);
    inReqDta       varchar(5000);
  end-pi;

  dcl-ds wk        qualified inz;
    ListFmt        char(4);
    TestJson       varchar(500);
    pos            uns(5);
    Request        varchar(50);
    KDNR           char(15);
    GADA           zoned(8);
    TENR           char(15);
    MENG           char(15);  // Workfeld! ggf. mit Dezialtrennzeichen
  END-DS;
  // Die Liste der angefordeten (Teile-)Positionen wird als String übergeben.
  // Dieser muss entsprechend erst zerlegt werden:
  // Trennzeichen, ähnlich CSV:
  // <TENR>|<MENG>;
  // JSON:
  // {"root": [{"TENR": tenr, "MENG": meng}, ... ] }

  in EXTRLD;

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

  // Ermitteln Daten aus dem Kunden-Stamm
  exsr EKUND;

  WKFENR = *ZERO;
  RowCount = *ZERO;
  clear RESULT;

  if %subst(inReqDta: 1: 1) = u'0027';  // '{';
    // nur als Ansatz... nicht auscodiert
    wk.ListFmt = 'JSON';
    exsr VJSON;
  else;
    wk.ListFmt = 'CSV';
    exsr VCSV;
  ENDIF;


  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYKDFI = DAFIRM;     // KUND
    KYTEFI = DAFIRM;     // TEIL
    KYTUFI = DAFIRM;     // TEUF

    KYTPFI = DAFIRM;     // TRTP
    KYTPSP = DASPCD;

  endsr;

  //----------------------------------------------------------------------------
  //  Verarbeiten der Liste mit TENR + MENG , CSV-Format
  //----------------------------------------------------------------------------
  begsr VCSV;

    wk.KDNR = inKDNR;
    wk.GADA = inGADA;

    // Das if-define hie rnur, weil rdi das nicht richtig erkennt
    /if defined(xcal04)
    for-each wk.request in %split(inReqDta: ';');
    /else
    for x = 1 to 2;
    /endif
      wk.pos = %scan(LC_DELIMITER2: wk.Request);
      if wk.pos > *zero;
        wk.TENR = %trim(%subst(wk.Request: 1: wk.pos -1));
        wk.MENG = %subst(wk.Request: wk.pos +1);
        exsr VPREIS;
      endif;

    endfor;

  ENDSR;
  //----------------------------------------------------------------------------
  //  Verarbeiten der Liste mit TENR + MENG , JSON-Format
  //----------------------------------------------------------------------------
  begsr VJSON;

  // nur als beispiel:
  wk.TestJson = inReqDta;
  if wk.TestJson = *blank;
  wk.TestJson = '{';
  wk.TestJson += '"kdnr" : { "nr":"4711", "area":"de411" },';
  wk.TestJson += '"positions": [ ';
  wk.TestJson += '{ "TENR":"teil-01", "MENG":"1"},';
  wk.TestJson += '{ "TENR":"teil-02", "MENG":"4"}';
  wk.TestJson += ']';
  wk.TestJson += '}';
  endif;

  /if defined(InputAsJson)
    // Das hier ist jetzt ein Beispiel. wie mit SQL ein json gesleen werden kann:
  exec sql
    with js as(
    select '{
    "kdnr" : { "nr":"4711", "area":"de411" },
    "positions": [ { "TENR":"teil-01", "MENG":"1"},
                { "TENR":"teil02", "MENG":"4"}]
    }' as doc
    from sysibm.sysdummy1
    )
    SELECT U.*
    FROM js,
    JSON_TABLE(js.doc,
    'lax $'
    COLUMNS( id FOR ORDINALITY,
    kdnr VARCHAR(20) PATH 'lax $.kdnr.nr',
    area VARCHAR(20) PATH 'lax $.kdnr.area',
    NESTED PATH 'lax $.positions[*]' COLUMNS (
    id2 FOR ORDINALITY,
    tenr VARCHAR(20) PATH 'lax $.TENR',
    meng VARCHAR(20) PATH 'lax $.MENG')
    )
    ) as u;
    /endif

  ENDSR;
  //----------------------------------------------------------------------------
  //  Verarbeiten die an das Programm übergebene Ident-Nr
  //----------------------------------------------------------------------------
  begsr VPREIS;

  // Ermitteln Daten aus dem Ident-Stamm
  KYTENR = wk.TENR;
  CHIDS = '01C';
  exsr CHTEIL;

  // Ermittlen Preis und Konditionen
  exsr ERPRKO;

  // Berechnen Preis und Koditionen
  exsr BRPRKO;

  // Berechnen Einzelpreis
  KYTPTA = 'PDIM';
  KYTPTC = RTPRKOPDIM;
  CHIDS = '01C';
  exsr CHTRTP;
  if TPTNUM = *zero;
    TPTNUM = 1;
  endif;

  // Rückgabe Preis und Konditionen pro Kunden/Artikel
  RowCount += 1;
  RESULT(RowCount).KDNR = %trim(WK.KDNR);
  RESULT(RowCount).TRANSDATE = WK.GADA;
  RESULT(RowCount).CURRENCY = %trim(KDWACD);
  RESULT(RowCount).SKU = %trim(wk.TENR);
  RESULT(RowCount).QUANTITY = trdec(wk.MENG);
  RESULT(RowCount).NETPRICE = RTKONDNESU;
  RESULT(RowCount).RETAILPRICE = RTPRKOPREI / TPTNUM;
  RESULT(RowCount).DISCOUNT = RTKONDERG1 + RTKONDERG2 + RTKONDERG3 + RTKONDERG4 + RTKONDERG5;
  WKN219 = RTKONDERG1 + RTKONDERG2 + RTKONDERG3 + RTKONDERG4 + RTKONDERG5;
  RESULT(RowCount).ERRMSG = '';

  // Ausgabe Konditionen als Prozentsatz
  if RESULT(RowCount).DISCOUNT < 0;
    eval(h) RESULT(RowCount).DISCOUNT = (%abs(RESULT(RowCount).DISCOUNT) / RTKONDERGB) * 100;
    eval(h) RESULT(RowCount).DISCOUNT = (%abs(WKN219) / RTKONDERGB) * 100;
  endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Preis und Konditionen
  //----------------------------------------------------------------------------
  begsr ERPRKO;

  clear EXPRKO01;
  EXPRKOVPKZ = 'V';
  EXPRKOPSLI = KDPSLI;
  EXPRKOLAND = KDLAND;
  EXPRKOPRGR = TEPRGR;
  EXPRKOMAGR = TEMAGR;
  EXPRKOVTLI = TEVTLI;
  EXPRKOVKGB = KDVKGB;
  EXPRKOPOLZ = KDPOLZ;
  EXPRKOKDNR = KDKDNR;
  EXPRKOKDGR = KDKDGR;
  EXPRKOVBKD = AGKD.KDVBKD;
  EXPRKOAGKD = wk.KDNR;
  EXPRKOTENR = wk.TENR;
  EXPRKOWACD = KDWACD;
  EXPRKODATE = wk.GADA;

  // Umrechnen Menge in Stammeinheit
  KYTUTE = TETENR;
  KYTUME = TEMEVK;
  WKV1V2 = trdec(wk.MENG);
  EXSR VTEUF;
  eval(h) WKTEMG = WKV1V2;
  eval(h) EXPRKOSTMG = WKV1V2;

  clear EXGEWI;
  clear RTGEWI;
  EXGEWITENR = TETENR;
  EXGEWIMENG = WKTEMG;
  EXGEWIMEIN = TEMEIN;
  C_ERGEWI(EXGEWI:RTGEWI);
  EXPRKOGWNT = RTGEWIGWRE;

  // Umrechnen Stamm-Menge in ME VK-Preis
  KYTUTE = TETENR;
  KYTUME = TEMPVK;
  WKV2V1 = WKTEMG;
  EXSR VTEUF;
  eval(h) EXPRKOMENG = WKV2V1;

  EXPRKOMEIN = TEMPVK;
  EXPRKOVSBD = KDVSBD;
  EXPRKOLIBD = KDLIBD;

  EXPRKOPROG = 'TRPR25';
  C_ERPRKO(EXPRKO01:RTPRKO01);

  endsr;

  //----------------------------------------------------------------------------
  //  Berechnen Preis und Konditionen
  //----------------------------------------------------------------------------
  begsr BRPRKO;

  clear EXKOND;
  clear RTKOND;

  EXKONDVPKZ = 'V';
  EXKONDTENR = wk.TENR;
  EXKONDMEIN = TEMPVK;
  EXKONDMEPR = TEMPVK;
  if RTPRKOMEPR <> *blank;
    EXKONDMEPR = RTPRKOMEPR;
  endif;
  EXKONDMENG = EXPRKOMENG;
  EXKONDPRAR = RTPRKOPRAR;
  EXKONDPREI = RTPRKOPREI;
  EXKONDPDIM = RTPRKOPDIM;

  EXKONDKON1 = RTPRKOKON1;
  EXKONDKOW1 = RTPRKOKOW1;
  EXKONDPRZ1 = RTPRKOPRZ1;
  EXKONDPDI1 = RTPRKOPDI1;
  EXKONDBAS1 = RTPRKOBAS1;

  EXKONDKON2 = RTPRKOKON2;
  EXKONDKOW2 = RTPRKOKOW2;
  EXKONDPRZ2 = RTPRKOPRZ2;
  EXKONDPDI2 = RTPRKOPDI2;
  EXKONDBAS2 = RTPRKOBAS2;

  EXKONDKON3 = RTPRKOKON3;
  EXKONDKOW3 = RTPRKOKOW3;
  EXKONDPRZ3 = RTPRKOPRZ3;
  EXKONDPDI3 = RTPRKOPDI3;
  EXKONDBAS3 = RTPRKOBAS3;

  EXKONDKON4 = RTPRKOKON4;
  EXKONDKOW4 = RTPRKOKOW4;
  EXKONDPRZ4 = RTPRKOPRZ4;
  EXKONDPDI4 = RTPRKOPDI4;
  EXKONDBAS4 = RTPRKOBAS4;

  EXKONDKON5 = RTPRKOKON5;
  EXKONDKOW5 = RTPRKOKOW5;
  EXKONDPRZ5 = RTPRKOPRZ5;
  EXKONDPDI5 = RTPRKOPDI5;
  EXKONDBAS5 = RTPRKOBAS5;

  EXKONDKUKZ = *OFF;       // Runden = NEIN
  EXKONDPROG = 'B2BSQ002';
  EXKONDPGST = 'BRPRKO';
  C_BRPRKO(EXKOND:RTKOND);

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Daten aus dem Kunden-Stamm
  //----------------------------------------------------------------------------
  begsr EKUND;

  KYKDNR = inKDNR;
  CHIDS = '01C';
  exsr CHKUND;
  AGKD = KUND;

  // Kundenummer Kondition
  if KDKOKD <> KDKDNR
    and KDKOKD <> *blank;
    KYKDNR = KDKOKD;
    CHIDS = '01C';
    exsr CHKUND;
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
  /copy QCPYSRC,CHFIRM
  /copy QCPYSRC,CHKUND
  /copy QCPYSRC,CHTEIL
  /copy QCPYSRC,CHTEUF
  /copy QCPYSRC,CHTRTP
  /copy QCPYSRC,VTEUF
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
