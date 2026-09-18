**free
ctl-opt main(B2B009);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export Ident-Stamm Erweiterung (TEEW) nach B2B
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 21.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: PH 28.05.2025 Case #04303295 "B2B-Erweiterung Status 80 Ablauf"
//            Gemäß Rücksprache mit GS und in Abstimmung zwischen GS und IK
//            vom 28.05.2025:
//            Erweiterung der XML-Ausgabe um das Feld TEIL.TEERTE, mit dessen
//            Inhalt das XML-Element <ReplacementItem> bestückt wird.
//  Änderung: PH 25.09.2025 Projekt Dometic Germany - B2B (Case #03777387).
//            E-Mail von IK vom 25.09.2025: Erweiterung der XML-Ausgabe um das Feld TEIL.TEINHP
//            "Inhaltsprüfung", mit dessen Inhalt das XML-Element <PackCheck> bestückt wird.
//  Änderung: PH 14./15.10.2025 Projekt Dometic Germany - B2B (Case #03777387).
//            E-Mail von IK vom 14.10.2025: Ausgabe nur von Artukeln mit einem in der SYTP-
//            Tabelle "TESTTRDB2B" hinterlegten Ident-Status (aktuell nur die Stati '01' und '80')
//  Änderung: PH 06./09.02.2026 Projekt Dometic Germany - B2B (Case 03777387). Anpassung an den
//            Aufruf für den Export einer konkreten an das Programm übergebnen Ident-Nr (und
//            deren Firmen-Nr), deren Status TEIL.TETEST auf <= '90' gesetzt worden ist (Aufruf
//            aus dem Trigger-Programm B2B019, EXB009PGST = 'TEST90') sowie an die Erstbefüllung
//            für Artikel mit dem Status TEIL.TETEST >= '90' (EXB009PGST = 'EXPA90'). Die TEEW
//            für die Artikel mit TEIL.TETEST >= '90' werden grundätzlich mit dem leeren XML-
//            Element 'ProductGroup' exportiert, während die TEEW-Sätze für die Artikel mit
//            TEIL.TETEST < '90' mit 'ProductGroup' = TEEWPRGR, wobei für die Artikel mit
//            TEIL.TETEST < '90'bzw. mit TEIl.TETEST aus der SYTP-Tabelle "TESTTRDB2B" nun
//            nur noch die TEEW-Sätze mit TEEWPRGR <> *BLANK selektiert werden.
//*************************************************************************
//
//  Dieses Programm wird manuell über das Programm B2B008ST oder als zeit-
//  gesteuerter Job über B2B008SJ aufgerufen.
//
//  Das Programm liest alle Sätze der Datei TEEW "Ident-Stamm Erweiterung"
//  (für DAFIRM) in Verbindung mit den dazugehörigen TEIL-Datensätzen
//  und gibt bestimmte Felder aus dieser als XML in ein IFS-Verzeichnis aus.
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
dcl-ds TEEW        ext inz end-ds;
dcl-ds KYTEEW      ext inz end-ds;

dcl-ds TEIL        ext inz end-ds;
dcl-ds KYTEIL      ext inz end-ds;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
dcl-ds EXDATA      ext inz end-ds;
dcl-ds RTDATA      ext inz end-ds;

dcl-ds EXB2B009    ext inz end-ds;

dcl-ds EXXL02      ext inz end-ds;
dcl-ds RTXL02      ext inz end-ds;

//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
dcl-ds wkNVP       likeds(NameValueList_t);

//*************************************************************************
//**  Konstanten                                                        ***
//*************************************************************************
dcl-c PGM_NAME     const('B2B009');
dcl-c LC_TREND     const('/trend');

// Namen, der XML-Elemente (Ebenen):
// Entweder die LC_Xml*-Konstanten verwenden, oder die LC_Soap*- Kontanten
dcl-c LC_XmlRoot   const('FileData');
dcl-c LC_XmlHeader const('HeaderData');
dcl-c LC_XmlRecord const('RecordData');
dcl-c LC_XmlSubDta const('SubData');

dcl-c LC_SoapRoot     const('Document');
dcl-c LC_SoapBody     const('Products');

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
// Program name: C_INZDATASTR
// Purpose:
// Returns:
// Parameter:      #EXDATA
// Parameter:      #RTDATA
//--------------------------------------------------
dcl-pr C_INZDATASTR extpgm('INZDATASTR');
  #EXDATA          likeds(EXDATA);
  #RTDATA          likeds(RTDATA);
end-pr;

//*************************************************************************
//*** Start des Programmes
//*************************************************************************
dcl-proc B2B009;
  dcl-pi *n;
    #EXB2B009      likeds(EXB2B009);
  end-pi;

  dcl-ds wkEx      likeds(wkInEx_t) inz;

  /include QCPYSRC,PGINIT

  // Übernahme der Aufrufparameter in die internen Datenstrukturen
  EXB2B009 = #EXB2B009;

  exsr UEBB2B009;

  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  select;

  // Export eines konkrten Artikels, dessen Status TETEST auf >= '90' gesetzt worden ist
  when EXB009PGST = 'TEST90';
    exsr VTEEW90;

  // Erstbefüllung für alle Artikel mit dem Status TETEST >= '90'
  when EXB009PGST = 'EXPA90';
    exsr ALLTEEW90;

  other;

  exsr VTEEW;

  endsl;

  if WKKOPF = *ON;
    exsr IFSCLOSE;
  endif;

  WKFIRM = DAFIRM;
  // Rückgabe der Aufrufparameter
  #EXB2B009 = EXB2B009;
  return;

  //*************************************************************************
  //**  Uebernahme Kommunikationsparameter EXB2B009                       ***
  //*************************************************************************
  begsr UEBB2B009;

    clear EXDATA;
    EXDATAFILE = 'EXB2B009';
    EXDATADATA = EXB2B009;
    C_INZDATASTR(EXDATA:RTDATA);
    EXB2B009 = RTDATADATA;

  endsr;

  //*************************************************************************
  //**  ERÖFFNUNGSZYKLUS                                                  ***
  //*************************************************************************
  begsr ANFANG;

    WKC001 = *BLANK;
    WKN010 = *ZERO;

    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSUSER;

    KYTEEWFIRM = DAFIRM; // TEEW
    KYTEFI     = DAFIRM; // TEIL

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

    // 'Products' - untergeordnet 'Document'
    WKBodyNode   = LC_SoapBody;

    WKRecordNode = 'DOMPRODUCT';

    WKSubDtaNode = '';

    WKRecordCount = *ZERO;

  endsr;

  //*************************************************************************
  //** Lesen TEEW  für eine konkrete an das Programm üebergebene Ident-Nr,***
  //** deren Status auf '90' gesetzt worden ist                          ,***
  //*************************************************************************
  begsr VTEEW90;

    WKSTMT = 'SELECT * FROM TEEW'
           + ' INNER JOIN TEIL'
           +  ' ON TEEW.TEEWFIRM = TEIL.TEFIRM'
           + ' AND TEEW.TEEWTENR = TEIL.TETENR'
           + ' WHERE TEEW.TEEWFIRM = ''' + EXB009FIRM + ''''
             + ' AND TEEW.TEEWTENR = ''' + EXB009TENR + ''''
           +   ' AND TEIL.TETEST >= ''90'''
           + ' ORDER BY TEEW.TEEWFIRM, TEEW.TEEWTENR'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQTEEW2 FROM :WKSTMT;
    EXEC SQL DECLARE B2B009C2 CURSOR FOR SQTEEW2;
    EXEC SQL OPEN B2B009C2;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B009C2 INTO :TEEW, :TEIL;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr XLTEEW;

      // Pro 400 gelesenen TEEW-Sätze eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B009C2;

  endsr;

  //*************************************************************************
  //** Erstbefüllung für alle Artikel mit dem Status TETEST >= '90'       ***
  //*************************************************************************
  begsr ALLTEEW90;

    WKSTMT = 'SELECT TEEW.TEEWTENR FROM TEEW'
           + ' INNER JOIN TEIL'
           +  ' ON TEEW.TEEWFIRM = TEIL.TEFIRM'
           + ' AND TEEW.TEEWTENR = TEIL.TETENR'
           + ' WHERE TEEW.TEEWFIRM = ''' + DAFIRM + ''''
           +   ' AND TEIL.TETEST >= ''90'''
           + ' ORDER BY TEEW.TEEWFIRM, TEEW.TEEWTENR'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQTEEW3 FROM :WKSTMT;
    EXEC SQL DECLARE B2B009C3 CURSOR FOR SQTEEW3;
    EXEC SQL OPEN B2B009C3;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B009C3 INTO :KYTEEWTENR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      CHIDS  = '01C';
      exsr CHTEEW;

      KYTENR = TEEWTENR;
      CHIDS  = '01C';
      exsr CHTEIL;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr XLTEEW;

      // Pro 400 gelesenen TEEW-Sätze eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B009C3;

  endsr;

  //*************************************************************************
  //**  Lesen TEEW                                                        ***
  //*************************************************************************
  begsr VTEEW;

    WKSTMT = 'SELECT TEEW.TEEWTENR FROM TEEW'
           + ' INNER JOIN TEIL'
           +  ' ON TEEW.TEEWFIRM = TEIL.TEFIRM'
           + ' AND TEEW.TEEWTENR = TEIL.TETENR'
           + ' WHERE TEEW.TEEWFIRM = ''' + DAFIRM + ''''
           +   ' AND TEEW.TEEWPRGR <> ''    '''
           //+   ' AND TEIL.TETEST < ''90'''
           + ' AND EXISTS(SELECT 1 FROM SYTP'
           +     ' WHERE SYTP.SYTPFIRM = TEIL.TEFIRM'
           +       ' AND SYTP.SYTPTCDE = TEIL.TETEST'
           +       ' AND SYTP.SYTPTART = ''TESTTRDB2B'''
           +       ' AND SYTP.SYTPTFLG = 0)'
           + ' ORDER BY TEEW.TEEWFIRM, TEEW.TEEWTENR'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQTEEW FROM :WKSTMT;
    EXEC SQL DECLARE B2B009C1 CURSOR FOR SQTEEW;
    EXEC SQL OPEN B2B009C1;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B009C1 INTO :KYTEEWTENR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      CHIDS  = '01C';
      exsr CHTEEW;

      KYTENR = TEEWTENR;
      CHIDS  = '01C';
      exsr CHTEIL;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr XLTEEW;

      // Pro 400 gelesenen TEEW-Sätze eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B009C1;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr XLTEEW;

    trNameValue(wkNVP: '*clear');

    if wkEx.Format = 'TRXL02';
      exsr VTEEWXML;
    else;
      exsr VTEEWDFT;
    endif;

  endsr;

  //*************************************************************************
  //**  Export über einfache Standardstruktur                             ***
  //*************************************************************************
  begsr VTEEWDFT;

    cpy_ExportRow(wkEx: wkNVP: LC_XmlRecord);

  endsr;

  //*************************************************************************
  //**  Export über strukturiertes XML                                    ***
  //*************************************************************************
  begsr VTEEWXML;

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
    // WKBodyNode = LC_SoapBody const('Products')
    // Unter <Document> ein <Products> anhängen:
    trEdiAddBlock(EXXL02: WKRootNode: WKBodyNode);

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der "Positionsdaten" in den Block                   **
  //**  Document/Products/DOMPRODUCT/, welcher in diesem Programm der      **
  //**  "Positionsblock" ist                                               **
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMPRODUCT'
    // Unter <Products> ein <DOMPRODUCT> anhängen:
    // Document/Products/DOMPRODUCT/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMPRODUCT>
    trEdiAddElem(EXXL02: WKRecordNode: 'ItemNo': TEEWTENR);
   /if defined(never)
   if EXB009PGST = 'TEST90' or EXB009PGST = 'EXPA90';
   /endif
   if TETEST >= '90';
    /if defined(never)
    trEdiAddElem(EXXL02: WKRecordNode: 'ProductGroup': *BLANK: 'MANDATORY');
   /endif
    trEdiAddElem(EXXL02: WKRecordNode: 'ProductGroup': *BLANK);
   else;
    trEdiAddElem(EXXL02: WKRecordNode: 'ProductGroup': TEEWPRGR);
   endif;
    trEdiAddElem(EXXL02: WKRecordNode: 'Status': TETEST);
    trEdiAddElem(EXXL02: WKRecordNode: 'ReplacementItem': TEERTE);
    trEdiAddElem(EXXL02: WKRecordNode: 'Packagingunit': %editc(TEIVPE:'X'));
    trEdiAddElem(EXXL02: WKRecordNode: 'PackCheck': TEINHP);

  endsr;

  //*************************************************************************
  //**  Öffnen    IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSOPEN;

    C_EXTSTP(WKTSTP);

    // Die Prozedur cpy_ExportInit() ermittelt auch den Pfad!
    // Die Prozedur cpy_ExportOpen() ermittelt auch den Pfad + Dateiname
    wkEx.NTYP = PGM_NAME;
    WKFENR = cpy_ExportInit(wkEx: 'TEEW');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'TEEW_' + %CHAR(WKTSTP) + '.xml': wkNVP);

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
  /include QCPYSRC,CHTEEW
  /include QCPYSRC,CHTEIL
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
