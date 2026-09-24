**free
ctl-opt main(B2B002);
/include QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Export Kundenstamm/KD-Stamm-Erweiterung/KD-Stamm Grüner Punkt/KD-Versandadresse
//*************************************************************************
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: PH 12.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//  -----------------------------------------------------------------------
//  Änderung: PH 16.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            Pro 400 gelesenen Kunden eie separate XML-Datei ausgeben.
//  Änderung: PH 22.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            Bestücken das XML-Element "Market" nicht mehr mit der Landbezeichnung
//            TXLAND, wondern mit der über SYTP "LDNRTRDB2B" umgesetzten Land-Nr KDLAND
//  Änderung: PH 26.05.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            Bestücken das XML-Element "PaymentTerms" nicht mehr mit der
//            Interpretation TXKUNDZABD, sondern mit KUND.KDZABD.
//  Änderung: PH 25.08.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            E-Mail von IK vom 25.08.2025: Bestücken das XML-Element "CountryCode" nicht
//            mehr mit KUND.KDPOLD bzw. KDVS.VSPOLD, sondern mit der über SYTP "LDNRTRDB2B"
//            umgesetzten Land-Nr KUND.KDLAND bzw. KDVS.VSLAND.
//  Änderung: FM 09.09.2025 Schreibebn Satz in ED96 für aktuelle Timestamp
//  Änderung: PH 27.11.2025 Projekt Dometic Germany - B2B (Case 03777387). Ausgabe
//            des Feldes KUND.KDLIAE "Lief. Komplett" als XML-Element 'Complete'
//*************************************************************************
//
//  Dieses Programm wird von der EDI-Steuerung aufgerufen, welche an das Programm
//  ein Zeitstempel zum Vergleich des letzten Änderungsdatum/der letzten Änderungszeit
//  für die nachfolgende Selektion der zu verarbeitenden Kunden-Nr übergibt.
//
//  Zu Testzwecken kann das Programm über B1B001ST aufgerufen werden, aus welchem
//  eine bestimmte Kunden-Nr übergeben werden kann.
//
//  Falls der an das Programm übergebene Zeitstempel nicht gefüllt ist, wird bei
//  EXB2B002.EXB002PGST <> 'EXPALL', also nicht bei der 1. Befüllung, zum Vergleich
//  der Zeitpunkt genommen, der 1 Stunde vor dem Programmaufruf liegt (hauptsächlich
//  auch für Testzwecke).
//
//  Das Programm liest alle KUND-Datensätze, deren Kunden-Nr in der KD-Stamm-
//  Erweiterungsdatei KDEW mit dem Kennzeichen KDEWKZKY = '1  ' = "B2B Customer"
//  hinterlegt sind und den Status KUND,KDKDST < '90' haben.
//  Ferner werden dazu noch die KDEW sowie die evetuell vorhandenen KDGP- und
//  KDVS-Sätze gelesen, wobei bei der KDVS nur die Sätze berücksichtigt werden,
//  die den Status KDVS.VSVSST < '90' haben.
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

dcl-ds KDGP        ext inz end-ds;
dcl-ds KYKDGP      ext inz end-ds;

dcl-ds KDVS        ext inz end-ds;
dcl-ds KYKDVS      ext inz end-ds;

dcl-ds KUEG        ext inz end-ds;
dcl-ds KYKUEG      ext inz end-ds;

dcl-ds KUND        ext inz end-ds;
dcl-ds KYKUND      ext inz end-ds;

dcl-ds SYTP        ext inz end-ds;
dcl-ds KYSYTP      ext inz end-ds;

//dcl-ds TRTP        ext inz end-ds;
dcl-ds KYTRTP      ext inz end-ds;

dcl-ds WA16        ext inz end-ds;
dcl-ds KYWA16      ext inz end-ds;

dcl-ds ED96        ext inz end-ds;
dcl-ds KYED96      ext inz end-ds;

//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
dcl-ds EXDATA      ext inz end-ds;
dcl-ds RTDATA      ext inz end-ds;

dcl-ds EXB2B002    ext inz end-ds;
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
dcl-c PGM_NAME     const('B2B002');
dcl-c LC_TREND     const('/trend');
dcl-c LC_TSTPCHG   const(z'2000-01-01-00.00.00.000000');

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
dcl-s SPCD like(KYTPSP) dim(3) inz;
dcl-s FGKDNR like(KDKDNR) dim(9999) inz;

//*************************************************************************
//**  Einzelfelder                                                      ***
//*************************************************************************
dcl-s WKC001       CHAR(1);
dcl-s WKN010       ZONED(1);
dcl-s I3           zoned(4);
dcl-s ISP          zoned(3);
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

dcl-s OFTPTA       like(KYTPTA);
dcl-s OFTPTC       like(KYTPTC);
dcl-s WKSTMT       varucs2(10000);
dcl-s WKKDNR       like(KDKDNR);
dcl-s WKJDAT       like(KDJDAT);
dcl-s WKJZEI       like(KDJZEI);
dcl-s WKB2BLDNR    char(30);
dcl-s WKB2BKDVSLDNR char(30);
dcl-s TXLAND       char(30);
dcl-s TXKUNDZABD   char(40);
dcl-s TXKDEWKSST   char(40);
dcl-s TXKDEWKDPL   char(40);
dcl-s TXKDGPESOR   char(40);
dcl-s WKWA16KDGR   varchar(500);

//*************************************************************************
//**  Externe Call-Prozeduren                                           ***
//*************************************************************************
//--------------------------------------------------
// Program name: C_B2B003
// Purpose:
// Returns:
// Parameter:      #EXB2B003
//--------------------------------------------------
dcl-pr C_B2B003  extpgm('B2B003');
  #EXB2B003      likeds(EXB2B003);
end-pr;

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
dcl-proc B2B002;
  dcl-pi *n;
    #EXB2B002      likeds(EXB2B002);
  end-pi;

  dcl-ds wkEx      likeds(wkInEx_t) inz;

  /include QCPYSRC,PGINIT

  // Übernahme der Aufrufparameter in die internen Datenstrukturen
  EXB2B002 = #EXB2B002;

  // zum Test:
  //clear EXB2B002;     // nur test !!!!

  exsr UEBB2B002;

  in EXTRLD;

  if WKI000 <> *ON;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //*************************************************************************
  //**  P R O G R A M M S T E U E R U N G                                 ***
  //*************************************************************************
  // Timestamp für Verarbeitungsdatum. Wichtig für Selektion aller Änderungen
  C_EXTSTP(KYED96TSTP);

  // Erstbefüllung
  if EXB002PGST = 'EXPALL';
    exsr ALLKUND;
  else;
    exsr VERA;
  endif;

  if WKKOPF = *ON;
    exsr IFSCLOSE;
    exsr UED96;
  endif;

  if EXB002PGST <> 'EXPALL';
    clear EXB2B003;
    EXB003TSTP = EXB002TSTP;
    //EXB003KDNR = EXB002KDNR;
    C_B2B003(EXB2B003);
  endif;

  // Rückgabe der Aufrufparameter
  #EXB2B002 = EXB2B002;
  return;

  //*************************************************************************
  //**  Uebernahme Kommunikationsparameter EXB2B002                       ***
  //*************************************************************************
  begsr UEBB2B002;

    clear EXDATA;
    EXDATAFILE = 'EXB2B002';
    EXDATADATA = EXB2B002;
    C_INZDATASTR(EXDATA:RTDATA);
    EXB2B002 = RTDATADATA;

    if EXB002PGST = 'NEWCHG';
      exec sql select max(ED96TSTP)  into :EXB002TSTP
        from ED96
        where ED96NTYP = 'B2B' and ED96DANA='KUND'
        and ED96PROG = :EXPSDSPROC;
      if sqlcode <> *zero;
         EXB002TSTP = %timestamp() - %days(2);
      ENDIF;
      WKJDAT = %dec(%date(EXB002TSTP):*ISO);
      WKJZEI = %dec(%time(EXB002TSTP));

    elseif EXB002PGST = 'EXPALL';
      EXB002TSTP = %timestamp();
      WKJDAT = *ZERO;
      WKJZEI = *ZERO;

    else;
      if EXB002TSTP = *LOVAL;
        EXB002TSTP = %timestamp() - %hours(1);
      else;
        EXB002TSTP = EXB002TSTP - %minutes(2);
      endif;
      WKJDAT = %dec(%date(EXB002TSTP):*ISO);
      WKJZEI = %dec(%time(EXB002TSTP));
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
    KYKDGPFIRM = DAFIRM; // KDGP
    KYVSFI = DAFIRM;     // KDVS
    KYKEFI = DAFIRM;     // KUEG
    KYKDFI = DAFIRM;     // KUND
    KYSYTPFIRM = DAFIRM; // SYTP
    KYTPFI = DAFIRM;     // TRTP
    KYWA16FIRM = DAFIRM; // WA16

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

    WKRecordNode = 'DOMCUSTOMERDETAILSANDADDRESSESENTITY';

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
           +   ' AND KUND.KDKDST < ''90'''
           +   ' AND EXISTS(SELECT 1 FROM KDEW'
           +       ' WHERE KDEW.KDEWFIRM = KUND.KDFIRM'
           +         ' AND KDEW.KDEWKDNR = KUND.KDKDNR'
           +         ' AND KDEW.KDEWKZKY = ''1  '')'
           + ' ORDER BY KUND.KDKDNR ASC'
           + ' FOR FETCH ONLY';

    EXEC SQL PREPARE SQKUND1 FROM :WKSTMT;
    EXEC SQL DECLARE B2B002C1 CURSOR FOR SQKUND1;
    EXEC SQL OPEN B2B002C1;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B002C1 INTO :WKKDNR;

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

    EXEC SQL CLOSE B2B002C1;

  endsr;

  //*************************************************************************
  //**  Verarbeiten der an B2B zu exportierenden Kunden                   ***
  //*************************************************************************
  begsr VERA;

    exsr KEYKUND;
    exsr VERAKUND;

    exsr KEYKDGP;
    exsr VERAKDGP;

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

    if EXB002KDNR <> *BLANK;
      WKSTMT +=  ' AND KUND.KDKDNR = ''' + EXB002KDNR + '''';
    endif;

    WKSTMT += ' AND KUND.KDKDST < ''90'''
            + ' AND KDEW.KDEWKZKY = ''1  '''
            + ' AND ((KUND.KDJDAT = ' + %editc(WKJDAT:'X')
            + ' AND KUND.KDJZEI > '  + %editc(WKJZEI:'X')
            +  ' OR KUND.KDJDAT > ' + %editc(WKJDAT:'X') + ')'
            +  ' OR (KDEW.KDEWJDAT = ' + %editc(WKJDAT:'X')
            + ' AND KDEW.KDEWJZEI > '  + %editc(WKJZEI:'X')
            +  ' OR KDEW.KDEWJDAT > ' + %editc(WKJDAT:'X') + '))'
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
    EXEC SQL DECLARE B2B002C2 CURSOR FOR SQKUND2;
    EXEC SQL OPEN B2B002C2;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B002C2 INTO :WKKDNR;

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

    EXEC SQL CLOSE B2B002C2;

  endsr;

  //*************************************************************************
  //**  Selektieren Kunden-Nr anhand der KDGP-Datensätze mit passenden    ***
  //**  letzten Änderungsdatum/Änderungszeit                              ***
  //*************************************************************************
  begsr KEYKDGP;

    WKSTMT = 'SELECT KDGP.KDGPKDNR FROM KDGP'
           + ' WHERE KDGP.KDGPFIRM = ''' + DAFIRM + '''';

    if EXB002KDNR <> *BLANK;
      WKSTMT +=  ' AND KDGP.KDGPKDNR = ''' + EXB002KDNR + '''';
    endif;

    WKSTMT += ' AND EXISTS(SELECT 1 FROM KUND'
            + ' WHERE KUND.KDFIRM = KDGP.KDGPFIRM'
            +   ' AND KUND.KDKDNR = KDGP.KDGPKDNR'
            +   ' AND KUND.KDKDST < ''90'''
            +   ' AND EXISTS(SELECT 1 FROM KDEW'
            +       ' WHERE KDEW.KDEWFIRM = KUND.KDFIRM'
            +         ' AND KDEW.KDEWKDNR = KUND.KDKDNR'
            +         ' AND KDEW.KDEWKZKY = ''1  ''))'
            +   ' AND (KDGP.KDGPJDAT = ' + %editc(WKJDAT:'X')
            +   ' AND KDGP.KDGPJZEI > '  + %editc(WKJZEI:'X')
            +    ' OR KDGP.KDGPJDAT > ' + %editc(WKJDAT:'X') + ')'
            + ' ORDER BY KDGP.KDGPKDNR ASC'
            + ' FOR FETCH ONLY';

  endsr;

  //*************************************************************************
  //**  Lesen der anhand der KDGP-Datensätze selektierten Kunden-Nr       ***
  //*************************************************************************
  begsr VERAKDGP;

    if WKKOPF = *OFF;
      WKDANA = *BLANK;
      WKKOPF = *OFF;
      trNameValue(wkNVP: '*INIT');
    endif;

    EXEC SQL PREPARE SQKDGP FROM :WKSTMT;
    EXEC SQL DECLARE B2B002C3 CURSOR FOR SQKDGP;
    EXEC SQL OPEN B2B002C3;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B002C3 INTO :WKKDNR;

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

    EXEC SQL CLOSE B2B002C3;

  endsr;

  //*************************************************************************
  //**  Selektieren Kunden-Nr anhand der KDVS-Datensätze mit passenden    ***
  //**  letzten Änderungsdatum/Änderungszeit                              ***
  //*************************************************************************
  begsr KEYKDVS;

    WKSTMT = 'SELECT KDVS.VSKDNR FROM KDVS'
           + ' WHERE KDVS.VSFIRM = ''' + DAFIRM + ''''
           +   ' AND KDVS.VSVSST < ''90''';

    if EXB002KDNR <> *BLANK;
      WKSTMT +=  ' AND KDVS.VSKDNR = ''' + EXB002KDNR + '''';
    endif;

    WKSTMT += ' AND EXISTS(SELECT 1 FROM KUND'
            + ' WHERE KUND.KDFIRM = KDVS.VSFIRM'
            +   ' AND KUND.KDKDNR = KDVS.VSKDNR'
            +   ' AND KUND.KDKDST < ''90'''
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
  //**  Lesen der anhand der KDVS-Datensätze selektierten Kunden-Nr       ***
  //*************************************************************************
  begsr VERAKDVS;

    if WKKOPF = *OFF;
      WKDANA = *BLANK;
      WKKOPF = *OFF;
      trNameValue(wkNVP: '*INIT');
    endif;

    EXEC SQL PREPARE SQKDVS FROM :WKSTMT;
    EXEC SQL DECLARE B2B002C4 CURSOR FOR SQKDVS;
    EXEC SQL OPEN B2B002C4;

    dow 1 = 1;

      EXEC SQL FETCH NEXT FROM B2B002C4 INTO :WKKDNR;

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

    EXEC SQL CLOSE B2B002C4;

  endsr;

  //*************************************************************************
  //**  Exportieren Satz, Einfacher Aufbau                                ***
  //*************************************************************************
  begsr VKUND;

    trNameValue(wkNVP: '*clear');

    KYKDNR = WKKDNR;
    CHIDS  = '01C';
    exsr CHKUND;

    SPCD(1) = KDSPCD;
    SPCD(2) = 'E';
    SPCD(3) = DASPCD;

    KYTPTA = 'ZABD';
    KYTPTC = KDZABD;
    CHIDS  = '01C';
    exsr ERTRTP;
    TXKUNDZABD = TPTTXT;

    KYKDEWKDNR = WKKDNR;
    CHIDS  = '01C';
    exsr CHKDEW;

    KYTPTA = 'KOST';
    KYTPTC = KDEWKSST;
    CHIDS  = '01C';
    exsr ERTRTP;
    TXKDEWKSST = TPTTXT;

    KYTPTA = 'KDEWKDPL';
    KYTPTC = KDEWKDPL;
    CHIDS  = '01C';
    exsr ERTRTP;
    TXKDEWKDPL = TPTTXT;

    KYKDGPKDNR = WKKDNR;
    CHIDS  = '01C';
    exsr CHKDGP;

    KYTPTA = 'ESOR';
    KYTPTC = KDGPESOR;
    CHIDS  = '01C';
    exsr ERTRTP;
    TXKDGPESOR = TPTTXT;

    clear WKWA16KDGR;
    KYWA16KDNR = KDKDNR;
    clear KYWA16KDGR;
    CHIDS = '01+';
    exsr CHWA16;
    dow CHI(5) = 'J'
      and WA16FIRM = KYWA16FIRM
      and WA16KDNR = KYWA16KDNR;

      WKWA16KDGR += %trim(WA16KDGR) + ',';

      CHIDS = '01R';
      exsr CHWA16;
    enddo;

    if WKWA16KDGR <> *BLANK
      and %subst(WKWA16KDGR:%len(%trimr(WKWA16KDGR)):1) = ',';
      %subst(WKWA16KDGR:%len(%trimr(WKWA16KDGR)):1) = *BLANK;
    endif;

    KYKELD = KDLAND;
    KYKEKD = KDKDNR;
    CHIDS = '01C';
    exsr CHKUEG;

    %subst(KOMDS:01) = KDLAND;
    %subst(KOMDS:06) = KDSPCD;
    exsr PRLANDLAND;
    TXLAND = %subst(KOMDS:08);
    if TXLAND = *BLANK;
      %subst(KOMDS:01) = KDLAND;
      %subst(KOMDS:06) = 'E';
      exsr PRLANDLAND;
      TXLAND = %subst(KOMDS:08);
    endif;
    if TXLAND = *BLANK;
      %subst(KOMDS:01) = KDLAND;
      %subst(KOMDS:06) = DASPCD;
      exsr PRLANDLAND;
      TXLAND = %subst(KOMDS:08);
    endif;

    KYSYTPTART = 'LDNRTRDB2B';
    KYSYTPTCDE = KDLAND;
    KYSYTPTFLG = *ZERO;
    CHIDS = '01C';
    exsr CHSYTP;
    WKB2BLDNR = SYTPTTXT;

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
  //**  Document/Entities/DOMCUSTOMERDETAILSANDADDRESSESENTITY/, welcher  ***
  //**  in diesem Programm der "Positionsblock" ist)                      ***
  //*************************************************************************
  begsr XLPOSITION;

    // Falls das neue Element (BLOCK, dritter Parameter) die Form "xxx:yy" hat,
    // so ist "xxx" der Namespace. Dieser wird/kann auf untergeordnete Elemente vererbt werden.

    // Todo: Namesapces: (Elementnamen wie "xxx:yyy") -> xxx vom Parent verwenden
    // Entweder EXXL02NMSA = '3' setzen, oder trEdiAddElem(x; y: Z: '*XMLNS');

    //-----------------------------------------------------------------------
    // WKRecordNode = 'DOMCUSTOMERDETAILSANDADDRESSESENTITY'
    // Unter <Entities> ein <DOMCUSTOMERDETAILSANDADDRESSESENTITY> anhängen:
    // Document/Entities/DOMCUSTOMERDETAILSANDADDRESSESENTITY/
    trEdiAddBlock(EXXL02: WKBodyNode: WKRecordNode);

    // Elemente des Blocks <DOMCUSTOMERDETAILSANDADDRESSESENTITY>
    trEdiAddElem(EXXL02: WKRecordNode: 'OrganizationNumber': KDKDNR);
    trEdiAddElem(EXXL02: WKRecordNode: 'Name': %trim(KDNAM1) + ' '
    + %trim(KDNAM2));
    trEdiAddElem(EXXL02: WKRecordNode: 'Group': %trim(TXKDEWKSST));
    trEdiAddElem(EXXL02: WKRecordNode: 'PriceGroups': %trim(WKWA16KDGR));
    trEdiAddElem(EXXL02: WKRecordNode: 'VatNumber': %trim(KEUSTI));
    //trEdiAddElem(EXXL02: WKRecordNode: 'Market': %trim(TXLAND));
    trEdiAddElem(EXXL02: WKRecordNode: 'Market': %trim(WKB2BLDNR));
    trEdiAddElem(EXXL02: WKRecordNode: 'CreditLimit': %trim(%char(KDKLSU)));
    trEdiAddElem(EXXL02: WKRecordNode: 'Currency': %trim(KDWACD));
    //trEdiAddElem(EXXL02: WKRecordNode: 'PaymentTerms': %trim(TXKUNDZABD));
    trEdiAddElem(EXXL02: WKRecordNode: 'PaymentTerms': %trim(KDZABD));

    //trEdiAddElem(EXXL02: WKRecordNode: 'ChargeGroup': %trim(TXKDGPESOR));
    trEdiAddElem(EXXL02: WKRecordNode: 'ChargeGroup': %trim(KDGPESOR));

    // "CompanyChain" is not defined yet (KDEWKDPL, TXKDEWKDPL ??)
    //trEdiAddElem(EXXL02: WKRecordNode: 'CompanyChain': %trim(KDEWKDPL));
    //trEdiAddElem(EXXL02: WKRecordNode: 'CompanyChain': %trim(TXKDEWKDPL));
    trEdiAddElem(EXXL02: WKRecordNode: 'CompanyChain': '');

    if KDKDST < '90';
      trEdiAddElem(EXXL02: WKRecordNode: 'CustomerOnHoldStatus': 'Active');
    else;
      trEdiAddElem(EXXL02: WKRecordNode: 'CustomerOnHoldStatus': 'Inactive');
    endif;

    // Default DE411?
    trEdiAddElem(EXXL02: WKRecordNode: 'LegalEntityID': 'DE411');
    trEdiAddElem(EXXL02: WKRecordNode: 'Complete': %trim(KDLIAR));

    //-----------------------------------------------------------------------
    // Ausgabe KD-Versandadressen
    exsr XLKDVS;

  endsr;

  //*************************************************************************
  //**  Ausgabe KD-Versandadresse(n)                                      ***
  //**  Aufbau Block <KDVS> und Ausgabe der diesem Block untergeordneten  ***
  //**  Adrressdaten                                                      ***
  //*************************************************************************
  begsr XLKDVS;

    // WKRecordNode = 'DOMCUSTOMERDETAILSANDADDRESSESENTITY';
    // Unter <DOMCUSTOMERDETAILSANDADDRESSESENTITY> ein <KDVS> anhängen:
    // Document/Etities/DOMCUSTOMERDETAILSANDADDRESSESENTITY/KDVS/
    trEdiAddBlock(EXXL02: WKRecordNode: 'KDVS');

    // Zuerst Ausgabe der KD-Adresse als "KD-Versandadresse" mit Versand-Adress-Nr '000'
    trEdiAddElem(EXXL02: 'KDVS': 'AddressLocationId': KDKDNR);
    trEdiAddElem(EXXL02: 'KDVS': 'AddressID': '000');
    trEdiAddElem(EXXL02: 'KDVS': 'IsShippingAddress': 'Y');
    trEdiAddElem(EXXL02: 'KDVS': 'Name': %trim(KDNAM1));
    trEdiAddElem(EXXL02: 'KDVS': 'Line1': %trim(KDNAM2));
    trEdiAddElem(EXXL02: 'KDVS': 'Line2': %trim(KDSTRA));
    trEdiAddElem(EXXL02: 'KDVS': 'City': %trim(KDWORT));
    //trEdiAddElem(EXXL02: 'KDVS': 'CountryCode': %trim(KDPOLD));
    trEdiAddElem(EXXL02: 'KDVS': 'CountryCode': %trim(WKB2BLDNR));
    trEdiAddElem(EXXL02: 'KDVS': 'PostalCode': %trim(KDPOLZ));

    exsr XLKDVS_ITEM;

  endsr;

  //*************************************************************************
  //**  Ausgabe einzelner KD-Versandadressen mit dem Status KDVS.VSVSST   ***
  //**  < '90' in den Block <KDVS> in einer Schleife                      ***
  //*************************************************************************
  begsr XLKDVS_ITEM;

    KYVSKD = KDKDNR;
    clear KYVSNR;
    CHIDS  = '01+';
    exsr CHKDVS;
    dow CHI(5) = 'J'
      and VSFIRM = KYVSFI
      and VSKDNR = KYVSKD;

      if VSVSST >= '90';
        CHIDS  = '01R';
        exsr CHKDVS;
        iter;
      endif;

      KYSYTPTART = 'LDNRTRDB2B';
      KYSYTPTCDE = VSLAND;
      KYSYTPTFLG = *ZERO;
      CHIDS = '01C';
      exsr CHSYTP;
      WKB2BKDVSLDNR = SYTPTTXT;

      // WKRecordNode = 'DOMCUSTOMERDETAILSANDADDRESSESENTITY';
      // Unter <DOMCUSTOMERDETAILSANDADDRESSESENTITY> ein <KDVS> anhängen:
      // Document/Etities/DOMCUSTOMERDETAILSANDADDRESSESENTITY/KDVS/
      trEdiAddBlock(EXXL02: WKRecordNode: 'KDVS');

      // Elemente des Blocks <KDVS>
      trEdiAddElem(EXXL02: 'KDVS': 'AddressLocationId': VSKDNR);
      trEdiAddElem(EXXL02: 'KDVS': 'AddressID': VSVSNR);
      trEdiAddElem(EXXL02: 'KDVS': 'IsShippingAddress': 'Y');
      trEdiAddElem(EXXL02: 'KDVS': 'Name': %trim(VSNAM1));
      trEdiAddElem(EXXL02: 'KDVS': 'Line1': %trim(VSNAM2));
      trEdiAddElem(EXXL02: 'KDVS': 'Line2': %trim(VSSTRA));
      trEdiAddElem(EXXL02: 'KDVS': 'City': %trim(VSWORT));
      //trEdiAddElem(EXXL02: 'KDVS': 'CountryCode': %trim(VSPOLD));
      trEdiAddElem(EXXL02: 'KDVS': 'CountryCode': %trim(WKB2BKDVSLDNR));
      trEdiAddElem(EXXL02: 'KDVS': 'PostalCode': %trim(VSPOLZ));

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
    WKFENR = cpy_ExportInit(wkEx: 'KUND');

    // Optional: wkEx.ALIA = '$$$$';
    // Optional: Den Dateinamen als dritten Parameter
                              // LC_SoapRoot  const('Document');
    trNameValue(wkNVP: 'root': LC_SoapRoot);
    WKFENR = cpy_ExportOpen(wkEx: 0: 'KUND_' + %char(WKTSTP) + '.xml': wkNVP);

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
  //*********************************************************************
  //**  SR-UED96      UPDATEN PROTKOLL-DATEI
  //*********************************************************************
  BEGSR UED96;

    CHIDS  = '01CU';
    EXSR CHED96;

    ED96DIRE = %TRIM(wkEx.IfsDir);
    ED96MEMB = wkEx.IfsFileName;

    ED96DANA = 'KUND';
    ED96NTYP = 'B2B';
    ED96EDIF = 'XL';
    ED96STAT = '90';

    ED96UEUS = DAUSER;
    ED96UEDA = %DEC(%DATE:*ISO);
    ED96JNAM = DAJNAM;
    ED96PROG = EXPSDSPROC;
    ED96BIBL = WKCHPL;
    ED96USER = DAUSER;
    ED96JZEI = %DEC(%TIME());
    ED96JDAT = %DEC(%DATE:*ISO);

    SELECT;

    WHEN CHI(6) = *ON;
      CHIDS  = '01W';
      EXSR CHED96;

    WHEN CHI(6) = *OFF;
      CHIDS  = '01U';
      EXSR CHED96;
    ENDSL;

  ENDSR;
  //*************************************************************************
  //**  COPY-MODULE                                                       ***
  //*************************************************************************
  /include QCPYSRC,CHED96
  /include QCPYSRC,CHKDEW
  /include QCPYSRC,CHKDGP
  /include QCPYSRC,CHKDVS
  /include QCPYSRC,CHKUEG
  /include QCPYSRC,CHKUND
  /include QCPYSRC,CHSYTP
  /include QCPYSRC,CHTRTP
  /include QCPYSRC,CHWA16
  /include QCPYSRC,ERTRTP
  /include QCPYSRC,PRLANDLAND
end-proc;
//*************************************************************************
//**  Prozeduren                                                        ***
//*************************************************************************
/include QCPYSRC,SXICSV
//*************************************************************************
//**  Ende des Programms                                                ***
//*************************************************************************
