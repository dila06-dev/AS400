**free
ctl-opt main(B2B012);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export Lagerbestand (LBBS) nach B2B
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 23.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: PH 09.09.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            Korrektur: Bestückung EXTRNDPGST mit 'ERSOLI' beim Aufruf WAO00Y fehlte.
//*************************************************************************
//
//  Dieses Programm wird manuell über das Programm B2B011ST oder als zeit-
//  gesteuerter Job über B2B011SJ aufgerufen.
//
//  Das Programm liest alle Sätze der Datei LBBS "Lagerbestand" mit der
//  Lager-Nr '001' und aktiven Artikeln (TEIL.TETEST < '90'), ermittelt
//  dazu noch den "sofort lieferbaren Bestand" für den jeweiligen Artikel
//  und gibt bestimmte Felder aus der LBBS sowie den ermittelten Wert als
//  XML in ein IFS-Verzeichnis aus.
//*************************************************************************
/include QCPYSRC,STDPGM
/include QCPYSRC,SXBASE
/include QCPYSRC,SXIFS2
/include QCPYSRC,SXEDI
/include QCPYSRC,SXDATE
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXTLOG
/include QCPYSRC,SXTRTP
/include QCPYSRC,SXTRPA
/include QCPYSRC,SXICSV
/include QCPYSRC,SXSQL

//*************************************************************************
//**  DATEIEN                                                           ***
//*************************************************************************
dcl-ds LBBS        ext inz end-ds;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
dcl-ds EXDATA      ext inz end-ds;
dcl-ds RTDATA      ext inz end-ds;

dcl-ds EXTREND     ext inz end-ds;
dcl-ds RTTREND     ext inz end-ds;

dcl-ds EXXL02      ext inz end-ds;
dcl-ds RTXL02      ext inz end-ds;

//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
dcl-ds wkNVP       likeds(NameValueList_t);

//*************************************************************************
//**  Konstanten                                                        ***
//*************************************************************************
dcl-c PGM_NAME     const('B2B012');
dcl-c LC_TREND     const('/trend');

// Namen, der XML-Elemente (Ebenen):
// Entweder die LC_Xml*-Konstanten verwenden, oder die LC_Soap*- Kontanten
dcl-c LC_XmlRoot   const('FileData');
dcl-c LC_XmlHeader const('HeaderData');
dcl-c LC_XmlRecord const('RecordData');
dcl-c LC_XmlSubDta const('SubData');

dcl-c LC_SoapRoot     const('Document');
dcl-c LC_SoapBody     const('Inventory');

//*************************************************************************
//**  Einzelfelder                                                      ***
//*************************************************************************
dcl-s WKC001       char(1);
dcl-s WKN010       zoned(1);
dcl-s ##PGST       char(1);
dcl-s WKI000       char(1);
dcl-s WKKOPF       char(1);
dcl-s WKTSTP       TIMESTAMP INZ;
dcl-s WKTMSTNULL   TIMESTAMP INZ;
dcl-s WKENVI       char(4);
dcl-s wkData       varucs2(5000);
dcl-s WKExportType char(10);
dcl-s WKRecordCount uns(5);
dcl-s wkFileId     like(ifsFileHandle_t);
dcl-s wkFileName   varchar(100);
dcl-s wkFileNameTemp varchar(100);
dcl-s wkPath       varchar(500);

dcl-s WKRootNode   varucs2(50);
dcl-s WKHeaderNode varucs2(50);
dcl-s WKBodyNode   varucs2(50);
dcl-s wkRecordParentNode varucs2(50);
dcl-s WKRecordNode varucs2(50);
dcl-s WKSubDtaNode varucs2(50);
dcl-s WKXmlOpt     varchar(50);

dcl-s WKSTMT       varucs2(10000);
dcl-s WKSOLI       zoned(11:2);

//*************************************************************************
//**  Externe Call-Prozeduren                                           ***
//*************************************************************************
//--------------------------------------------------
// Program name: C_EXTSTP
// Purpose:
// Returns:
// Parameter:      #WKTSTP
//--------------------------------------------------
dcl-pr C_EXTSTP    extpgm('EXTSTP');
   #WKTSTP         like(WKTSTP);
end-pr;

//--------------------------------------------------
// Program name: C_WAO00Y
// Purpose:
// Returns:
// Parameter:      #EXTREND
// Parameter:      #RTTREND
//--------------------------------------------------
dcl-pr C_WAO00Y    extpgm('WAO00Y');
   #EXTREND        like(EXTREND);
   #RTTREND        like(RTTREND);
end-pr;

//*************************************************************************
//*** Start des Programmes
//*************************************************************************
dcl-proc B2B012;
  dcl-pi *n;
  end-pi;

  dcl-ds wkEx      likeds(wkInEx_t) inz;

  /include QCPYSRC,PGINIT

  // Übernahme der Aufrufparameter in die internen Datenstrukturen

  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  exsr VLBBS;

  if WKKOPF = *ON;
    exsr IFSCLOSE;
  endif;

  WKFIRM = DAFIRM;
  // Rückgabe der Aufrufparameter
  return;

  //*************************************************************************
  //**  ERÖFFNUNGSZYKLUS                                                  ***
  //*************************************************************************
  begsr ANFANG;

    WKC001 = *BLANK;
    WKN010 = *ZERO;

    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSUSER;

  endsr;

  //*************************************************************************
  //**  VORLAUF                                                           ***
  //*************************************************************************
  begsr VORLAUF;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    #CRTCD = *BLANK;

    WKENVI = getINITValue('FIR0016');

    clear wkEx;
    wkEx.Format = 'TRXL02';

    // Todo: Dies ("B2B") ist nur zum Beispiel-Test! Anpassen/löschen!
    wkEx.ZUBG   = 'B2B';   // nur zum Test!

    // Todo: Im Beispiel/Test wird ein SOAP-XML aufgebaut.
    // Statt der LC_SOAP*-Konstanten ggf die LC_XML-Konstanten verwenden

    // 'Document' - Die oberste Ebene
    WKRootNode   = LC_SoapRoot;

    // 'Inventory' - untergeordnet 'Document'
    WKBodyNode   = LC_SoapBody;

    WKRecordNode = 'DOMINVENTORYRECORD';

    WKSubDtaNode = '';

    WKRecordCount = *ZERO;

  endsr;

  //*************************************************************************
  //**  Lesen LBBS                                                        ***
  //*************************************************************************
  begsr VLBBS;

    WKSTMT = 'SELECT LBBS.* FROM LBBS'
           + ' INNER JOIN TEIL'
           +  ' ON LBBS.LBBSFIRM = TEIL.TEFIRM'
           + ' AND LBBS.LBBSTENR = TEIL.TETENR'
           + ' WHERE LBBS.LBBSFIRM = ''' + DAFIRM + ''''
           +   ' AND LBBS.LBBSLANR = ''001'''
           +   ' AND TEIL.TETEST < ''90'''
           + ' ORDER BY LBBS.LBBSFIRM, LBBS.LBBSTENR, LBBS.LBBSLANR,'
           + ' LBBS.LBBSBSLA, LBBS.LBBSBSTY, LBBS.LBBSWKNR, LBBS.LBBSKDNR,'
           + ' LBBS.LBBSLFNR, LBBS.LBBSFBNR, LBBS.LBBSGEBI, LBBS.LBBSCONT,'
           + ' LBBS.LBBSBHNR, LBBS.LBBSLORT, LBBS.LBBSCHAR, LBBS.LBBSFUMG,'
           + ' LBBS.LBBSMEIN, LBBS.LBBSQUMM'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQLBBS FROM :WKSTMT;
    EXEC SQL DECLARE B2B012C1 CURSOR FOR SQLBBS;
    EXEC SQL OPEN B2B012C1;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B012C1 INTO :LBBS;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr XLLBBS;

      // Pro 400 gelesenen LBBS-Sätze eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B012C1;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr XLLBBS;

    trNameValue(wkNVP: '*clear');

    clear EXTREND;
    clear RTTREND;
    EXTRNDPGST = 'ERSOLI';
    %subst(EXTRNDKEYB:01) = LBBSTENR;
    %SUBST(EXTRNDKEYB:16) = 'P';
    C_WAO00Y(EXTREND:RTTREND);
    eval(h) WKSOLI = alnumToDec(RTTRNDDATE: 13: 4: 066);
    if WKSOLI < *ZERO;
      WKSOLI = *ZERO;
    endif;

    if wkEx.Format = 'TRXL02';
      exsr VLBBSXML;
    else;
      exsr VLBBSDFT;
    endif;

  endsr;

  //*************************************************************************
  //**  Export über einfache Standardstruktur                             ***
  //*************************************************************************
  begsr VLBBSDFT;

    cpy_ExportRow(wkEx: wkNVP: LC_XmlRecord);

  endsr;

  //*************************************************************************
  //**  Export über strukturiertes XML                                    ***
  //*************************************************************************
  begsr VLBBSXML;

    if WKRecordCount = *zero;
      exsr XLKOPF;
    endif;

    WKRecordCount += 1;
    exsr XLPOSITION;

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der Daten, die pro Programmaufruf nur einmalig und ***
  //**  ohne Bezug zu den nachfolgend ausgegebenen Daten gleich am Anfang ***
  //**  der XML-Ausgabe ausgegeben werden.                                ***
  //*************************************************************************
  begsr XLKOPF;

    // WKRootNode = LC_SoapRoot const('Document')
    // WKBodyNode = LC_SoapBody const('Inventory')
    // Unter <Document> ein <Inventory> anhängen:
    trEdiAddBlock(EXXL02: WKRootNode: WKBodyNode);

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der "Positionsdaten" in den Block                   **
  //**  Document/Inventory/DOMINVENTORYRECORD/, welcher in diesem Programm **
  //**  der "Positionsblock" ist                                           **
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMINVENTORYRECORD'
    // Unter <Inventory> ein <DOMINVENTORYRECORD> anhängen:
    // Document/Inventory/DOMINVENTORYRECORD/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMINVENTORYRECORD>
    trEdiAddElem(EXXL02: WKRecordNode: 'SkuNumber': LBBSTENR);
    trEdiAddElem(EXXL02: WKRecordNode: 'Warehouse': LBBSLANR);
    trEdiAddElem(EXXL02: WKRecordNode: 'Quantity':
    %trim(%editc(WKSOLI:'3')));

  endsr;

  //*************************************************************************
  //**  Öffnen    IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSOPEN;

    C_EXTSTP(WKTSTP);

    // Die Prozedur cpy_ExportInit() ermittelt auch den Pfad!
    // Die Prozedur cpy_ExportOpen() ermittelt auch den Pfad + Dateiname
    wkEx.NTYP = PGM_NAME;
    WKFENR = cpy_ExportInit(wkEx: 'LBBS');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'LBBS_' + %CHAR(WKTSTP) + '.xml': wkNVP);

    clear EXXL02;
    EXXL02PATH = wkEx.IfsDir;
    EXXL02FILE = wkEx.IfsFileName + '.tmp';

    clear WKRecordCount;

  endsr;

  //*************************************************************************
  //**  Schließen IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSCLOSE;

    if wkEx.Format = 'TRXL02';
      clear EXXL02;
      EXXL02PGST = 'WRITE';
      C_TRXL02(EXXL02:RTXL02);
    endif;

    cpy_ExportClose(wkEx: WKFENR);
    clear WKRecordCount;

  endsr;

  //*************************************************************************
  //**  ERMITTELN PARAMETERWERTE                                          ***
  //*************************************************************************
  begsr ETRPA;


  endsr;

  //*************************************************************************
  //**  COPY-MODULE                                                       ***
  //*************************************************************************
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
