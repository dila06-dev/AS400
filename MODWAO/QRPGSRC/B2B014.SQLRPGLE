**free
ctl-opt main(B2B014);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export Vorgezogene Recyclinggebühr (KOND) in Verbindung mit GRPP (Artikel) nach B2B
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 26.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: PH 25.06.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 12 "Environmental fee", Nachtrag: Ausgabe nur KORABA als <Fee>.
//            TXKONDPDVK wird separat als <chargeCategory> ausgegeben
//            (Post von IK vom 25.06.2025).
//*************************************************************************
//
//  Dieses Programm wird manuell über das Programm B2B013ST oder als zeit-
//  gesteuerter Job über B2B013SJ aufgerufen.
//
//  Das Programm liest alle aktuell gültigen Sätze der Datei KOND mit dem
//  Konditionsbegriff 'VRG' = "vorgezogene Recyclinggebühr" mit KOND.KORABA <> 0,
//  für deren Material-Gruppe in der Datei GRPP "DS Packmittel-Mengenanteile"
//  Artikel mit dem Ident-Status TEIL.TETEST < '90' hinterlegt sind, und gibt
//  den Inhalt bestimmter Felder aus der KOND zusammen mit den Artikeln GRPPTENR
//  als XML in ein IFS-Verzeichnis aus.
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
dcl-ds GRPP        ext inz end-ds;
dcl-ds KOND        ext inz end-ds;

//dcl-ds TRTP        ext inz end-ds;
dcl-ds KYTRTP      ext inz end-ds;

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
dcl-c PGM_NAME     const('B2B014');
dcl-c LC_TREND     const('/trend');

// Namen, der XML-Elemente (Ebenen):
// Entweder die LC_Xml*-Konstanten verwenden, oder die LC_Soap*- Kontanten
dcl-c LC_XmlRoot   const('FileData');
dcl-c LC_XmlHeader const('HeaderData');
dcl-c LC_XmlRecord const('RecordData');
dcl-c LC_XmlSubDta const('SubData');

dcl-c LC_SoapRoot     const('Document');
dcl-c LC_SoapBody     const('EnvironmentalFee');

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
dcl-s TXKONDPDVK   char(40);

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
dcl-proc B2B014;
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
  exsr VKOND;

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

    KYTPFI = DAFIRM;     // TRTP

    // Firmensprache in allen Keystrukturen setzen
    KYTPSP = DASPCD;      // TRTP

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

    // 'EnvironmentalFee' - untergeordnet 'Document'
    WKBodyNode   = LC_SoapBody;

    WKRecordNode = 'DOMENVIRONMENTALFEE';

    WKSubDtaNode = '';

    WKRecordCount = *ZERO;

  endsr;

  //*************************************************************************
  //**  Lesen KOND                                                        ***
  //*************************************************************************
  begsr VKOND;

    WKSTMT = 'SELECT KOND.*, GRPP.* FROM KOND'
           + ' INNER JOIN GRPP'
           +  ' ON KOND.KOFIRM = GRPP.GRPPFIRM'
           + ' AND KOND.KOMAGR = GRPP.GRPPGPMG'
           + ' INNER JOIN TEIL'
           +  ' ON GRPP.GRPPFIRM = TEIL.TEFIRM'
           + ' AND GRPP.GRPPTENR = TEIL.TETENR'
           + ' WHERE KOND.KOFIRM = ''' + DAFIRM + ''''
           +   ' AND KOND.KOBEGR = ''VRG'''
           +   ' AND KOND.KORABA <> 0'
           +   ' AND KOND.KOGADA <= ' + %editc(%dec(%date():*ISO):'X')
           +   ' AND (KOND.KOGBDA = 0'
           +    ' OR KOND.KOGBDA >= ' + %editc(%dec(%date():*ISO):'X') + ')'
           +   ' AND TEIL.TETEST < ''90'''
           + ' ORDER BY KOND.KOFIRM, KOND.KOBEGR, KOND.KOPSLI, KOND.KOABTL,'
           + ' KOND.KOLAND, KOND.KOBLGA, KOND.KOKDLI, KOND.KOVSNR,'
           + ' KOND.KOPJNR, KOND.KOKDLG, KOND.KOPRGR, KOND.KOMAGR,'
           + ' KOND.KOVKGB, KOND.KOPOLZ, KOND.KOSTCD, KOND.KOTENR,'
           + ' KOND.KOGEBI, KOND.KOWACD, KOND.KOGADA DESC, GRPP.GRPPTENR'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQKOND FROM :WKSTMT;
    EXEC SQL DECLARE B2B014C1 CURSOR FOR SQKOND;
    EXEC SQL OPEN B2B014C1;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B014C1 INTO :KOND, : GRPP;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr XLKOND;

      // Pro 400 gelesenen KOND/GRPP-Sätze eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B014C1;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr XLKOND;

    trNameValue(wkNVP: '*clear');

    KYTPTA = 'PDIM';
    KYTPTC = KOPDVK;
    CHIDS  = '01C';
    exsr CHTRTP;
    TXKONDPDVK = TPTTXT;
    if TPTNUM = *ZERO;
      clear TXKONDPDVK;
    endif;

    if wkEx.Format = 'TRXL02';
      exsr VKONDXML;
    else;
      exsr VKONDDFT;
    endif;

  endsr;

  //*************************************************************************
  //**  Export über einfache Standardstruktur                             ***
  //*************************************************************************
  begsr VKONDDFT;

    cpy_ExportRow(wkEx: wkNVP: LC_XmlRecord);

  endsr;

  //*************************************************************************
  //**  Export über strukturiertes XML                                    ***
  //*************************************************************************
  begsr VKONDXML;

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
    // WKBodyNode = LC_SoapBody const('EnvironmentalFee')
    // Unter <Document> ein <EnvironmentalFee> anhängen:
    trEdiAddBlock(EXXL02: WKRootNode: WKBodyNode);

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der "Positionsdaten" in den Block                   **
  //**  Document/EnvironmentalFee/DOMENVIRONMENTALFEE/, welcher in diesem  **
  //**  Programm der "Positionsblock" ist                                           **
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMENVIRONMENTALFEE'
    // Unter <EnvironmentalFee> ein <DOMENVIRONMENTALFEE> anhängen:
    // Document/EnvironmentalFee/DOMENVIRONMENTALFEE/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMENVIRONMENTALFEE>
    trEdiAddElem(EXXL02: WKRecordNode: 'MaterialGroup': KOMAGR);
    trEdiAddElem(EXXL02: WKRecordNode: 'CustomerGroup': KOKDLI);
    //if TXKONDPDVK <> *BLANK;
    //  trEdiAddElem(EXXL02: WKRecordNode: 'Fee': %trim(%editc(KORABA:'3'))
    //  + ' / ' + %trim(TXKONDPDVK) + ' unit');
    //else;
      trEdiAddElem(EXXL02: WKRecordNode: 'Fee': %trim(%editc(KORABA:'3')));
    //endif;
    trEdiAddElem(EXXL02: WKRecordNode: 'chargeCategory': %trim(TXKONDPDVK));
    trEdiAddElem(EXXL02: WKRecordNode: 'Currency': KOWACD);
    trEdiAddElem(EXXL02: WKRecordNode: 'SKU': GRPPTENR);

  endsr;

  //*************************************************************************
  //**  Öffnen    IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSOPEN;

    C_EXTSTP(WKTSTP);

    // Die Prozedur cpy_ExportInit() ermittelt auch den Pfad!
    // Die Prozedur cpy_ExportOpen() ermittelt auch den Pfad + Dateiname
    wkEx.NTYP = PGM_NAME;
    WKFENR = cpy_ExportInit(wkEx: 'KOND');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'KOND_' + %char(WKTSTP) + '.xml': wkNVP);

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
  /include QCPYSRC,CHTRTP
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
