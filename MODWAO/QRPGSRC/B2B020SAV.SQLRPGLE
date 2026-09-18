**free
ctl-opt main(B2B020);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export einer Ident-Nr mit dem Status >= '90' nach B2B
//*************************************************************************
//  Copyright 2026 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 05.02.2026 Projekt Dometic Germany - B2B (Case 03777387)
//            Neuer B2B Export ID26
//  -----------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//*************************************************************************
//
//  Dieses Programm wird aus dem Trigger Programm B2B019 beim Setzen
//  des status eines Artikels auf >= '90' aufgerufen.
//
//  An das Programm wird der TEIL-Schlüssel (TEFIRM + TETENR) übergeben.
//  Das Programm greift damit auf die TEIL zu und gibt den Inhalt
//  bestimmter Felder als XML in ein IFS-Verzeichnis aus.
//
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
dcl-ds TEIL        ext inz end-ds;
dcl-ds KYTEIL      ext inz end-ds;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
dcl-ds EXDATA      ext inz end-ds;
dcl-ds RTDATA      ext inz end-ds;

dcl-ds EXXL02      ext inz end-ds;
dcl-ds RTXL02      ext inz end-ds;

//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
dcl-ds wkNVP       likeds(NameValueList_t);

//*************************************************************************
//**  Konstanten                                                        ***
//*************************************************************************
dcl-c PGM_NAME     const('B2B020');
dcl-c LC_TREND     const('/trend');

// Namen, der XML-Elemente (Ebenen):
// Entweder die LC_Xml*-Konstanten verwenden, oder die LC_Soap*- Kontanten
dcl-c LC_XmlRoot   const('FileData');
dcl-c LC_XmlHeader const('HeaderData');
dcl-c LC_XmlRecord const('RecordData');
dcl-c LC_XmlSubDta const('SubData');

dcl-c LC_SoapRoot     const('Document');
dcl-c LC_SoapBody     const('DeletedItems');

//*************************************************************************
//**  Einzelfelder                                                      ***
//*************************************************************************
dcl-s WKC001       char(1);
dcl-s WKN010       zoned(1);
dcl-s I3           zoned(4);
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

//*************************************************************************
//*** Start des Programmes
//*************************************************************************
dcl-proc B2B020;
  dcl-pi *n;
    #FIRM      like(TEFIRM);
    #TENR      like(TETENR);
  end-pi;

  dcl-ds wkEx      likeds(wkInEx_t) inz;

  /include QCPYSRC,PGINIT

  // Übernahme der Aufrufparameter in die internen Felder
  KYTEFI = #FIRM;
  KYTENR = #TENR;

  in EXTRLD;

  if WKI000 <> *ON;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  exsr VTEIL;

  if WKKOPF = *ON;
    exsr IFSCLOSE;
  endif;

  // Rückgabe der Aufrufparameter
  #FIRM = KYTEFI;
  #TENR = KYTENR;
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

    // 'DeletedItems' - untergeordnet 'Document'
    WKBodyNode   = LC_SoapBody;

    WKRecordNode = 'DOMDELETEDITEM';

    WKSubDtaNode = '';

    WKRecordCount = *ZERO;

  endsr;

  //*************************************************************************
  //**  Lesen TEIL                                                        ***
  //*************************************************************************
  begsr VTEIL;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    SQLCOD = *ZERO;
    EXEC SQL SELECT * INTO :TEIL FROM TEIL
    WHERE TEIL.TEFIRM = :KYTEFI
      AND TEIL.TETENR = :KYTENR
      FETCH FIRST ROW ONLY;

    if isSQLEOForError(SqlState) or TETEST < '90';
      leavesr;
    endif;

    if WKKOPF = *OFF;
      exsr IFSOPEN;
      WKKOPF = *ON;
    endif;

    exsr XLTEIL;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr XLTEIL;

    trNameValue(wkNVP: '*clear');

    if wkEx.Format = 'TRXL02';
      exsr VTEILXML;
    else;
      exsr VTEILDFT;
    endif;

  endsr;

  //*************************************************************************
  //**  Export über einfache Standardstruktur                             ***
  //*************************************************************************
  begsr VTEILDFT;

    cpy_ExportRow(wkEx: wkNVP: LC_XmlRecord);

  endsr;

  //*************************************************************************
  //**  Export über strukturiertes XML                                    ***
  //*************************************************************************
  begsr VTEILXML;

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
    // WKBodyNode = LC_SoapBody const('DeletedItems')
    // Unter <Document> ein <DeletedItems> anhängen:
    trEdiAddBlock(EXXL02: WKRootNode: WKBodyNode);

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der "Positionsdaten" in den Block                   **
  //**  Document/DeletedItems/DOMDELETEDITEM/, welcher in diesem Programm  **
  //**  der "Positionsblock" ist                                           **
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMDELETEDITEM'
    // Unter <DeletedItems> ein <DOMDELETEDITEM> anhängen:
    // Document/DeletedItems/DOMDELETEDITEM/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMDISCOUNTSCHARGES>
    trEdiAddElem(EXXL02: WKRecordNode: 'ItemNo': TETENR);
    trEdiAddElem(EXXL02: WKRecordNode: 'LegalEntityID': 'DE411');
    trEdiAddElem(EXXL02: WKRecordNode: 'Itemdeleted': 'Y');

  endsr;

  //*************************************************************************
  //**  Öffnen    IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSOPEN;

    C_EXTSTP(WKTSTP);

    // Die Prozedur cpy_ExportInit() ermittelt auch den Pfad!
    // Die Prozedur cpy_ExportOpen() ermittelt auch den Pfad + Dateiname
    wkEx.NTYP = PGM_NAME;
    WKFENR = cpy_ExportInit(wkEx: 'TEIL90');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'TEIL90_' + %char(WKTSTP) + '.xml': wkNVP);

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
  /include QCPYSRC,CHTEIL
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
