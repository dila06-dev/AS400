**free
ctl-opt main(B2B003);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export Kundenstamm/KD-Versandadresse mit dem Status >= '90'
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 15.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: PH 16.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            Pro 400 gelesenen Kunden eie separate XML-Datei ausgeben.
//*************************************************************************
//
//  Dieses Programm wird aus dem Programm B2B002 aufgerufen, welches an das Programm
//  ein Zeitstempel zum Vergleich des letzten Änderungsdatum/der letzten Änderungszeit
//  für die nachfolgende Selektion der zu verarbeitenden Kunden-Nr übergibt.
//
//  Falls der an das Programm übergebene Zeitstempel nicht gefüllt ist, wird bei
//  EXB2B003.EXB003PGST <> 'EXPALL', also nicht bei der 1. Befüllung, zum Vergleich
//  der Zeitpunkt genommen, der 1 Stunde vor dem Programmaufruf liegt (hauptsächlich
//  auch für Testzwecke).
//
//  Das Programm liest alle KUND-Datensätze, deren Kunden-Nr in der KD-Stamm-
//  Erweiterungsdatei KDEW mit dem Kennzeichen KDEWKZKY = '1  ' = "B2B Customer"
//  hinterlegt sind und den Status KUND,KDKDST >) '90' haben.
//  Ferner werden dazu noch die evetuell vorhandenen KDVS-Sätze gelesen, wobei
//  KDVS-Sätze gelesen, wobei auch nur die Sätze berücksichtigt werden, die den Status
//  KDVS.VSVSST >= '90' haben.
//  Bei allen oben aufgeführten Dateien werden nur die Datensätze gelesen, deren letzte
//  Änderungsdatum/Änderungszeit NACH dem Zeitpunkt aus dem an das Programm übergebenen
//  Zeitstempel liegt (von dem vorher zur Sicherheit noch 2 Minute abgezogen werden).
//
//  Die von B2B benötigten Daten gibt das Programm als XML in ein IFS-Verzeichnis aus.
//
//*************************************************************************
/include QCPYSRC,STDPGM
/include QCPYSRC,SXBASE
/include QCPYSRC,SXIFS2
/include QCPYSRC,SXEDI
/include QCPYSRC,SXDATE
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSQL
/include QCPYSRC,SXTLOG
/include QCPYSRC,SXTRTP
/include QCPYSRC,SXTRPA
/include QCPYSRC,SXICSV

//*************************************************************************
//**  DATEIEN                                                           ***
//*************************************************************************
dcl-ds KDEW        ext inz end-ds;
dcl-ds KYKDEW      ext inz end-ds;

dcl-ds KDVS        ext inz end-ds;
dcl-ds KYKDVS      ext inz end-ds;

dcl-ds KUND        ext inz end-ds;
dcl-ds KYKUND      ext inz end-ds;

//dcl-ds TRTP        ext inz end-ds;
dcl-ds KYTRTP      ext inz end-ds;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
dcl-ds EXDATA      ext inz end-ds;
dcl-ds RTDATA      ext inz end-ds;

dcl-ds EXB2B003    ext inz end-ds;

dcl-ds EXXL02      ext inz end-ds;
dcl-ds RTXL02      ext inz end-ds;

//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************
dcl-ds wkNVP       likeds(NameValueList_t);

//*************************************************************************
//**  Konstanten                                                        ***
//*************************************************************************
dcl-c PGM_NAME     const('B2B003');
dcl-c LC_TREND     const('/trend');

// Namen, der XML-Elemente (Ebenen):
// Entweder die LC_Xml*-Konstanten verwenden, oder die LC_Soap*- Kontanten
dcl-c LC_XmlRoot   const('FileData');
dcl-c LC_XmlHeader const('HeaderData');
dcl-c LC_XmlRecord const('RecordData');
dcl-c LC_XmlSubDta const('SubData');

dcl-c LC_SoapRoot  const('Document');
dcl-c LC_SoapBody  const('Entities');

//*************************************************************************
//**  Tabellen und Feldgruppen                                          ***
//*************************************************************************
dcl-s FGKDNR like(KDKDNR) dim(9999) inz;

//*************************************************************************
//**  Einzelfelder                                                      ***
//*************************************************************************
dcl-s WKC001       CHAR(1);
dcl-s WKN010       ZONED(1);
dcl-s I3           zoned(4);
dcl-s ##PGST       CHAR(1);
dcl-s WKI000       CHAR(1);
dcl-s WKKOPF       CHAR(1);
dcl-s WKTSTP       TIMESTAMP INZ;
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
dcl-s WKKDNR       like(KDKDNR);
dcl-s WKJDAT       like(KDJDAT);
dcl-s WKJZEI       like(KDJZEI);

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
dcl-proc B2B003;
  dcl-pi *n;
    #EXB2B003      likeds(EXB2B003);
  end-pi;

  dcl-ds wkEx      likeds(wkInEx_t) inz;

  /include QCPYSRC,PGINIT

  // Übernahme der Aufrufparameter in die internen Datenstrukturen
  EXB2B003 = #EXB2B003;

  // zum Test:
  //clear EXB2B003;     // nur test !!!!

  exsr UEBB2B003;

  in EXTRLD;

  if WKI000 <> *ON;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  // Erstbefüllung
  if EXB003PGST = 'EXPALL';
    exsr ALLKUND;
  else;
    exsr VERA;
  endif;

  if WKKOPF = *ON;
    exsr IFSCLOSE;
  endif;

  // Rückgabe der Aufrufparameter
  #EXB2B003 = EXB2B003;
  return;

  //*************************************************************************
  //**  Uebernahme Kommunikationsparameter EXB2B003                       ***
  //*************************************************************************
  begsr UEBB2B003;

    clear EXDATA;
    EXDATAFILE = 'EXB2B003';
    EXDATADATA = EXB2B003;
    C_INZDATASTR(EXDATA:RTDATA);
    EXB2B003 = RTDATADATA;

    if EXB003PGST <> 'EXPALL';
      if EXB003TSTP = *LOVAL;
        EXB003TSTP = %timestamp() - %hours(1);
      else;
        EXB003TSTP = EXB003TSTP - %minutes(2);
      endif;
      WKJDAT = %dec(%date(EXB003TSTP):*ISO);
      WKJZEI = %dec(%time(EXB003TSTP));
    else;
      WKJDAT = *ZERO;
      WKJZEI = *ZERO;
    endif;

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

    KYKDEWFIRM = DAFIRM; // KDEW
    KYVSFI = DAFIRM;     // KDVS
    KYKDFI = DAFIRM;     // KUND
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
    wkEx.ZUBG   = 'B2B';    // nur zum Test!

    // Todo: Im Beispiel/Test wird ein SOAP-XML aufgebaut.
    // Statt der LC_SOAP*-Konstanten ggf die LC_XML-Konstanten verwenden

    // 'Document' - Die oberste Ebene
    WKRootNode   = LC_SoapRoot;

    // 'Entities' - untergeordnet 'Document'
    WKBodyNode   = LC_SoapBody;

    WKRecordNode = 'DOMCUSTOMERANDADDRESSESENTITY';

    WKSubDtaNode = '';

    WKRecordCount = *ZERO;

    clear FGKDNR;

  endsr;

  //*************************************************************************
  //**  Erstbefüllung, alle relevanten Kunden
  //*************************************************************************
  begsr ALLKUND;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    WKSTMT = 'SELECT KUND.KDKDNR FROM KUND'
           + ' WHERE KUND.KDFIRM = ''' + DAFIRM + ''''
           +   ' AND KUND.KDKDST >= ''90'''
           +   ' AND EXISTS(SELECT 1 FROM KDEW)'
           +       ' WHERE KDEW.KDEWFIRM = KUND.KDFIRM'
           +         ' AND KDEW.KDEWKDNR = KUND.KDKDNR'
           +         ' AND KDEW.KDEWKZKY = ''1  '')'
           + ' ORDER BY KUND.KDKDNR ASC'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQKUND1 FROM :WKSTMT;
    EXEC SQL DECLARE B2B003C1 CURSOR FOR SQKUND1;
    EXEC SQL OPEN B2B003C1;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B003C1 INTO :WKKDNR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      exsr VKUND;

      // Pro 400 gelesenen Kunden eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B003C1;

  endsr;

  //*************************************************************************
  //**  Verarbeiten der an B2B zu exportierenden Kunden                   ***
  //*************************************************************************
  begsr VERA;

    exsr KEYKUND;
    exsr VERAKUND;

    exsr KEYKDVS;
    exsr VERAKDVS;

  endsr;

  //*************************************************************************
  //**  Selektieren Kunden-Nr anhand der KUND-/KDEW-Datensätze mit        ***
  //**  passenden letzten Änderungsdatum/Änderungszeit                    ***
  //*************************************************************************
  begsr KEYKUND;

    WKSTMT = 'SELECT KUND.KDKDNR FROM KUND'
           + ' INNER JOIN KDEW'
           +  ' ON KDEW.KDEWFIRM = KUND.KDFIRM'
           + ' AND KDEW.KDEWKDNR = KUND.KDKDNR'
           + ' WHERE KUND.KDFIRM = ''' + DAFIRM + '''';

    if EXB003KDNR <> *BLANK;
      WKSTMT +=  ' AND KUND.KDKDNR = ''' + EXB003KDNR + '''';
    endif;

    WKSTMT += ' AND KUND.KDKDST >= ''90'''
            + ' AND KDEW.KDEWKZKY = ''1  '''
            + ' AND KDEW.KDEWKZKY = ''1  '''
            + ' AND (KUND.KDJDAT = ' + %editc(WKJDAT:'X')
            + ' AND KUND.KDJZEI > '  + %editc(WKJZEI:'X')
            +  ' OR KUND.KDJDAT > ' + %editc(WKJDAT:'X') + ')'
            + ' ORDER BY KUND.KDKDNR ASC'
            + ' FOR FETCH ONLY';

  endsr;

  //*************************************************************************
  //**  Lesen der anhand der KUND-/KDEW-Datensätze selektierten Kunden-Nr ***
  //*************************************************************************
  begsr VERAKUND;

    WKDANA = *BLANK;
    WKKOPF = *OFF;
    trNameValue(wkNVP: '*INIT');

    EXEC SQL PREPARE SQKUND2 FROM :WKSTMT;
    EXEC SQL DECLARE B2B003C2 CURSOR FOR SQKUND2;
    EXEC SQL OPEN B2B003C2;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B003C2 INTO :WKKDNR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      if %lookup(WKKDNR:FGKDNR) > *ZERO;
        iter;
      else;
        I3 = %lookup(*BLANK:FGKDNR);
        if I3 > *ZERO;
          FGKDNR(I3) = WKKDNR;
        endif;
      endif;

      exsr VKUND;

      // Pro 400 gelesenen Kunden eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B003C2;

  endsr;

  //*************************************************************************
  //**  Selektieren Kunden-Nr anhand der KDVS-Datensätze mit passenden    ***
  //**  letzten Änderungsdatum/Änderungszeit                              ***
  //*************************************************************************
  begsr KEYKDVS;

    WKSTMT = 'SELECT KDVS.VSKDNR FROM KDVS'
           + ' WHERE KDVS.VSFIRM = ''' + DAFIRM + ''''
           +   ' AND KDVS.VSVSST >= ''90''';

    if EXB003KDNR <> *BLANK;
      WKSTMT +=  ' AND KDVS.VSKDNR = ''' + EXB003KDNR + '''';
    endif;

    WKSTMT += ' AND EXISTS(SELECT 1 FROM KUND'
            + ' WHERE KUND.KDFIRM = KDVS.VSFIRM'
            +   ' AND KUND.KDKDNR = KDVS.VSKDNR'
            +   ' AND EXISTS(SELECT 1 FROM KDEW'
            +       ' WHERE KDEW.KDEWFIRM = KUND.KDFIRM'
            +         ' AND KDEW.KDEWKDNR = KUND.KDKDNR'
            +         ' AND KDEW.KDEWKZKY = ''1  ''))'
            +   ' AND (KDVS.VSJDAT = ' + %editc(WKJDAT:'X')
            +   ' AND KDVS.VSJZEI > '  + %editc(WKJZEI:'X')
            +    ' OR KDVS.VSJDAT > ' + %editc(WKJDAT:'X') + ')'
            + ' GROUP BY KDVS.VSKDNR'
            + ' ORDER BY KDVS.VSKDNR ASC'
            + ' FOR FETCH ONLY';

  endsr;

  //*************************************************************************
  //**  Lesen der anhand der KDSP-Datensätze selektierten Kunden-Nr       ***
  //*************************************************************************
  begsr VERAKDVS;

    if WKKOPF = *OFF;
      WKDANA = *BLANK;
      WKKOPF = *OFF;
      trNameValue(wkNVP: '*INIT');
    endif;

    EXEC SQL PREPARE SQKDVS FROM :WKSTMT;
    EXEC SQL DECLARE B2B003C3 CURSOR FOR SQKDVS;
    EXEC SQL OPEN B2B003C3;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B003C3 INTO :WKKDNR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

      if WKKOPF = *OFF;
        exsr IFSOPEN;
        WKKOPF = *ON;
      endif;

      if %lookup(WKKDNR:FGKDNR) > *ZERO;
        iter;
      else;
        I3 = %lookup(*BLANK:FGKDNR);
        if I3 > *ZERO;
          FGKDNR(I3) = WKKDNR;
        endif;
      endif;

      exsr VKUND;

      // Pro 400 gelesenen Kunden eine separate XML-Datei ausgeben
      if WKRecordCount = 400;
        exsr IFSCLOSE;
        WKKOPF = *OFF;
      endif;

    enddo;

    EXEC SQL CLOSE B2B003C3;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr VKUND;

    trNameValue(wkNVP: '*clear');

    KYKDNR = WKKDNR;
    CHIDS  = '01C';
    exsr CHKUND;

    if wkEx.Format = 'TRXL02';
      exsr VKUNDXML;
    else;
      exsr VKUNDDFT;
    endif;

  endsr;

  //*************************************************************************
  //**  Export über einfache Standardstruktur                             ***
  //*************************************************************************
  begsr VKUNDDFT;

    cpy_ExportRow(wkEx: wkNVP: LC_XmlRecord);

  endsr;

  //*************************************************************************
  //**  Export über strukturiertes XML                                    ***
  //*************************************************************************
  begsr VKUNDXML;

    if WKRecordCount = *zero;
      exsr XLKOPF;
    endif;

    WKRecordCount += 1;
    exsr XLPOSITION;

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der Daten, die pro Programmaufruf nur einmalig und ***
  //**  ohne Bezug zu den nachfolgend ausgegebenen (in diesem Programm    ***
  //**  kundenbezogenen) Daten gleich am Anfang der XML-Ausgabe ausgegeben***
  //**  werden.                                                           ***
  //*************************************************************************
  begsr XLKOPF;

    // WKRootNode = LC_SoapRoot const('Document')
    // WKBodyNode = LC_SoapBody const('Entities')
    // Unter <Document> ein <Entities> anhängen:
    trEdiAddBlock(EXXL02: WKRootNode: WKBodyNode);

  endsr;

  //*************************************************************************
  //**  Aufbau/Ausgabe der "Positionsdaten"                               ***
  //**  (in diesem Programm kundenbezogenen Daten in den Block            ***
  //**  Document/Entities/DOMCUSTOMERANDADDRESSESENTITY/, welcher in      ***
  //**  diesem Programm der "Positionsblock" ist)                         ***
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMCUSTOMERANDADDRESSESENTITY'
    // Unter <Entities> ein <DOMCUSTOMERANDADDRESSESENTITY> anhängen:
    // Document/Entities/DOMCUSTOMERANDADDRESSESENTITY/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMCUSTOMERANDADDRESSESENTITY>
    trEdiAddElem(EXXL02: WKRecordNode: 'OrganizationNumber': KDKDNR);

    //-----------------------------------------------------------------------
    // Ausgabe KD-Versandadressen
    exsr XLKDVS;

    // Default DE411 ??
    trEdiAddElem(EXXL02: WKRecordNode: 'LegalEntityID': 'DE411');
    // Not available ??
    trEdiAddElem(EXXL02: WKRecordNode: 'ValidFrom': '');
    // Passt das so ???
    if KDKDST >= '90';
      trEdiAddElem(EXXL02: WKRecordNode: 'IsCustomerDeleted': 'Y');
    else;
      trEdiAddElem(EXXL02: WKRecordNode: 'IsCustomerDeleted': 'N');
    endif;

  endsr;

  //*************************************************************************
  //**  Ausgabe KD-Versandadresse(n)                                      ***
  //**  Aufbau Block <KDVS> und Ausgabe der diesem Block untergeordneten  ***
  //**  Adrressdaten                                                      ***
  //*************************************************************************
  begsr XLKDVS;

    // Zuerst Ausgabe der KD-Adresse als "KD-Versandadresse" mit Versand-Adress-Nr '000',
    // wenn die Kundenr-Nr den Status >= '90' hat
    if KDKDST >= '90';
      // WKRecordNode = 'DOMCUSTOMERANDADDRESSESENTITY';
      // Unter <DOMCUSTOMERANDADDRESSESENTITY> ein <KDVS> anhängen:
      // Document/Etities/DOMCUSTOMERANDADDRESSESENTITY/KDVS/
      trEdiAddBlock(EXXL02: WKRecordNode: 'KDVS');

      // Elemente des Blocks <KDVS>
      trEdiAddElem(EXXL02: 'KDVS': 'AddressLocationId': KDKDNR);
      trEdiAddElem(EXXL02: 'KDVS': 'AddressID': '000');
      if KDKDST >= '90';
        trEdiAddElem(EXXL02: 'KDVS': 'IsCustomerDeleted': 'Y');
      else;
        trEdiAddElem(EXXL02: 'KDVS': 'IsCustomerDeleted': 'N');
      endif;
    endif;

    exsr XLKDVS_ITEM;

  endsr;

  //*************************************************************************
  //**  Ausgabe einzelner KD-Versandadressen mit dem Status KDVS.VSVSST   ***
  //**  >= '90' in den Block <KDVS> in einer Schleife                     ***
  //*************************************************************************
  begsr XLKDVS_ITEM;

    KYVSKD = KDKDNR;
    clear KYVSNR;
    CHIDS  = '01+';
    exsr CHKDVS;
    dow CHI(5) = 'J'
      and VSFIRM = KYVSFI
      and VSKDNR = KYVSKD;

      if VSVSST < '90';
        CHIDS  = '01R';
        exsr CHKDVS;
        iter;
      endif;

      // WKRecordNode = 'DOMCUSTOMERANDADDRESSESENTITY';
      // Unter <DOMCUSTOMERANDADDRESSESENTITY> ein <KDVS> anhängen:
      // Document/Etities/DOMCUSTOMERANDADDRESSESENTITY/KDVS/
      trEdiAddBlock(EXXL02: WKRecordNode: 'KDVS');

      // Elemente des Blocks <KDVS>
      trEdiAddElem(EXXL02: 'KDVS': 'AddressLocationId': VSKDNR);
      trEdiAddElem(EXXL02: 'KDVS': 'AddressID': VSVSNR);
      if VSVSST >= '90';
        trEdiAddElem(EXXL02: 'KDVS': 'IsCustomerDeleted': 'Y');
      else;
        trEdiAddElem(EXXL02: 'KDVS': 'IsCustomerDeleted': 'N');
      endif;

      CHIDS  = '01R';
      exsr CHKDVS;
    enddo;

  endsr;

  //*************************************************************************
  //**  Öffnen    IFS-Datei                                               ***
  //*************************************************************************
  begsr IFSOPEN;

    C_EXTSTP(WKTSTP);

    // Die Prozedur cpy_ExportInit() ermittelt auch den Pfad!
    // Die Prozedur cpy_ExportOpen() ermittelt auch den Pfad + Dateiname
    wkEx.NTYP = PGM_NAME;
    WKFENR = cpy_ExportInit(wkEx: 'KUND90');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'KUND90_' + %char(WKTSTP) + '.xml': wkNVP);

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
  /include QCPYSRC,CHKDEW
  /include QCPYSRC,CHKDVS
  /include QCPYSRC,CHKUND
  /include QCPYSRC,CHTRTP
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
