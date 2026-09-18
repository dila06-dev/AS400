**free
ctl-opt main(MOBBEX);
ctl-opt dftactgrp(*NO) actgrp('QILE');
/COPY QCPYSRC,CTLOPTIONS
//*************************************************************************
/TITLE  Schnittstelle Export Bestellungen externe Rechnungsprüfung (Medius)
//*************************************************************************
//  Copyright 2002 by    trend SWM
//                       Verwaltungs GmbH
//                       Ziegelhofstraße 210a
//                       DE 79110 Freiburg
//  -----------------------------------------------------------------------
//  Erstellt: FM 08.03.2023 Projekt 16279, Dometic
//  Änderung: FM 13.04.2023 Projekt 16279, Dometic ...
//  Änderung: FM 12.07.2023 Projekt 16279, Dometic MWSt-Angaben
//  Änderung: FM 05.09.2023 Projekt 16279, Abweichender Einzelpreis Rechnung/Bestellung
//  Änderung: FM 07.09.2023 Projekt 16279, "mark-as-fetched"
//  Änderung: FM 02.10.2023 Projekt 16279, Exceptiontypes -> Zusatzkosten
//  Änderung: FM 08.12.2023 Projekt 16279, Auch Bestellunge < 2023 mit neuen BWAEs
//  Änderung: FM 09.04.2024 Projekt 16279, BBEK.LFNR -> LIEF -> LFRALF (Lieferant Rechnung)
//  Änderung: FM 21.05.2024 Projekt 16279, purchaseOrderLines.reference: Name von TESAEK/TEDIEK
//  Änderung: FM 11.02.2025 Projekt 16279, Korrektur... (ein Trennzeichen zu viel)
//  Änderung: FM 24,02.2025 Projekt 16279, Formale anpassung wgeen neuem Compiler (SQL-Warnungen)
//  Änderung: FM 24,02.2025 Projekt 16279, Fehler beim Ermitteln des BRBP-Satzes
//  Änderung: FM 12,03.2025 Projekt 16279, "unitPrice" über Preisdiemension auf 1-Stück umrechnen
//  Änderung: FM 16.04.2025 Projekt 16279, Nummerierung der Positionen LineNumber wie trend
//  Änderung: FM 02.05.2025 .. Lesen Zugangsdaten aus EDIP MEDIUS-&ENVI,
//  Änderung: FM 02.05.2025 .. zusätzliches Element AdditionalOrderIdentifier
//  Änderung: FM 02.05.2025 .. "UnitPrice" mit 6 dezimalen
//  Änderung: FM 16.05.2025 SABE -> e-mail-adresse (über TRTP)
//  Änderung: FM 22.05.2025 Medius-Priduktiv: andere urls (nicht nur andere ClientId+Pwd)
//  Änderung: FM 02.10.2025 purchaseOrderLines, EKSABE (->email aus TRTP)  als "reference"
//  Änderung: FM 19.01.2026 Empfangen Rechungen/Invoice: Längenbeschränkung  64k -> 360k
//  Änderung: FM 23.02.2026 Empfangen Rechungen/Invoice: "deviation" -> Konto "UNW"
//  Änderung: FM 24.02.2026 Empfangen Rechungen/Invoice: fix wegen Preisdimension
//  Änderung: FM 14.04.2026 BRBK-LS-Jahr/Nummer immer leer lassen
//  Änderung: FM 11.06.2026 BWAE: nur urspungs-WEs an Medius übertragen
//*************************************************************************
// Funktion:
// Bestellungen (BBEK, BBEP) selektieren, aufbereiten und an "Medius" übergeben
// Seletktion:
// - BBEK-Status < x
// - Datum < x
// - neu  oder Änderung seit letzter Übergabe (!)
// Aufbereitung:
// - als JSON oder XML
// - Übergabe per http-REST
// - Verarbeitung der Antwort...
// Die Verarbeitung der Daten bei Medius erfolgt asynchron.
// Es muss also zu einem späteren Zeitpunkt mit einem weiteren Aufruf überprüft werden,
// ob eine Übergabe erfolgreich bei Medius integriert werden konnte.
//*************************************************************************
//*************************************************************************
// todo: DB-Änderungen !! -> defines aktivieren
/define MOBBEX_BRBK
/define MOBBEX_BRBP

/COPY QCPYSRC,EXTRDR
/include QCPYSRC,SXBASE
/include QCPYSRC,SXDATE
// /include QCPYSRC,SXEDI
/include QCPYSRC,SXFILE
/include QCPYSRC,SXIFS2
// /include QCPYSRC,SXMWST
/include QCPYSRC,SXSQL
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXTLOG
/include QCPYSRC,SXTRPA
/include QCPYSRC,SXTRTP

/include QCPYSRC,HTTPAPI_H

//*************************************************************************
//**  Konstanten                                                        ***
//*************************************************************************
dcl-c PGM_NAME     const('MOBBEX');

dcl-c lc_JsonGroupStart const('{');
dcl-c lc_JsonGroupEnd   const('}');
dcl-c lc_JsonListStart  const('[');
dcl-c lc_JsonListEnd    const(']');
dcl-c lc_JsonDelimiter  const(', ');
dcl-c lc_JsonDlmt       const(', ');
dcl-c LC_Status         const('Status');
dcl-c LC_Send           const('Send');
dcl-c LC_MarkAsFetched  const('INV-IN');
dcl-c LC_MarkAsProcessed const('INV-OK');
dcl-c LC_MarkError      const('INV-ER');
dcl-c LC_MarkVoucher    const('INV-VO');

//*************************************************************************
//**  DATEIEN                                                           ***
//*************************************************************************
DCL-DS BBEK        EXT INZ END-DS;
DCL-DS KYBBEK      EXT INZ END-DS;
DCL-DS BBEP        EXT INZ END-DS;
DCL-DS KYBBEP      EXT INZ END-DS;
DCL-DS BWAE        EXT INZ END-DS;
DCL-DS KYBWAE      EXT INZ END-DS;
DCL-DS EXBRBK_t    EXT extname('EXBRBK') qualified prefix('': 6) INZ;
  // BLID in R10 noch nicht definiert.. erst ab Rel.14
  // bzw. mit Update ...
  /if not defined(TRENDREL22FF)
  // BLID             char(10) pos(62);
  /endif
END-DS;
DCL-DS EXBRBP_t    EXT extname('EXBRBP') qualified prefix('': 6) INZ END-DS;
//*************************************************************************
//**  KOMMUNIKATIONSPARAMETER                                           ***
//*************************************************************************
DCL-DS EXTR01      EXT INZ END-DS;
DCL-DS EXTR02      EXT INZ END-DS;
DCL-DS ED97        EXT INZ END-DS;
DCL-DS KYED97      EXT INZ END-DS;
//*************************************************************************
//**  INTERNE DATENSTRUKTUR                                             ***
//*************************************************************************

dcl-ds trReturns   likeds(trReturns_t) inz;

// Datenstruktur für Export:
// kann (ab R7.x) über RPG-Feature als json/xml exportiert werden...
dcl-ds PreCodingDimensions_t template;
  Dimension1    varchar(50);
  Dimension2    varchar(50);
  Dimension4    varchar(50);
  //Dimension3 - 12    varchar(10);
  FreeText1     varucs2(40);
  FreeText2     varucs2(40);
  FreeText5     varucs2(40);
  //FreeText3 - 5      varucs2(10);
END-DS;
dcl-ds PreCodingLine_t qualified template;  // xml-Element: PreCodingLine
  Amount           zoned(24: 2);
  dimensions       likeds(PreCodingDimensions_t);
  type             varchar(40);  // enum
  // At least one CodingLine with Type = Cost is mandatory to provide
  // to be able to import PO to Medius.
  //   "Cost",
  //   "ExceptionType",
  //   "DeviationUnitPrice",
  //   "DeviationQuantity",
  //   "DeviationLineTotal",
  //   "DeviationNetAmount",
  //   "DeviationUnitPriceWithinTolerance",
  //   "DeviationQuantityWithinTolerance",
  //   "DeviationLineTotalWithinTolerance",
  //   "DeviationLineTotalApproved",
  //   "DeviationLineTotalRejected",
  //   "DeviationUnitPriceApproved",
  //   "DeviationUnitPriceRejected",
  //   "DeviationQuantityApproved",
  //   "DeviationQuantityRejected",
  //   "DeviationNetAmountApproved",
  //   "DeviationNetAmountRejected",
  //   "DeviationSameAsCost"
END-DS;
dcl-ds CodingLines_Array qualified template;
  // See list for possible values.
  // At least one CodingLine with Type = Cost is mandatory to provide to be able to import PO ...
  count            int(3);
  PreCodingLine    likeds(PreCodingLine_t) dim(8);
  json             varucs2(2000);
END-DS;

dcl-ds DeliveryLine_t qualified template;
  ErpSourceId      varchar(50);
  ExternalSystemId varchar(50);
  IsActive         varchar(10) inz('true');
  Amount           zoned(24: 2);
  ConversionFactor int(3);
  DeliveryDate     varchar(30); //timestamp
  DeliveryNumber   varchar(30);
  DeliveryNote     varucs2(50);
  ReleaseNumber    varchar(20);
  Quantity         zoned(24: 3);
  Unit             varchar(10);
  UnitPrice        zoned(24: 2);
  IsFictive        varchar(6) inz('true');
  TotalInvoicedQuantity zoned(14: 3);
  purchaseOrderLineExternalSystemId varchar(50); // nutzbar für getrenntes Update Wareneingang
  //PurchaseOrderLineExternalSystemId
  json             varucs2(3000);
END-DS;

// ACHTUNG: Wenn da eine Bestllung mit400 Psoitionen
// und 100erten Wareneingänge pro Position kommt...
// ... dann sind das mehrere Megabyte...
// ... dann muss die Ausgebstruktur nochmal etwas geändert werden
dcl-ds DeliveryLines_array qualified template;
  count            int(5);
  // in der Praxis bei Dometic sind das mit den aktuellen Daten
  // bis zu 200 Wareneigänge für eine Position
  DeliveryLine     likeds(DeliveryLine_t) dim(10);
  Amount           zoned(24: 2);
  json             varucs2(120000);
END-DS;

dcl-ds PurchaseOrderLine_t qualified;
  ErpSourceId      varchar(50);
  ExternalSystemId varchar(50);
  IsActive         varchar(10) inz('true');
  Amount           zoned(24: 2);
  // CodingLines sind 12xDimension, 5xText und 1xAount.. -> Abweichungsregeln
  // ..sind aber mandatory!
  CodingLines      likeds(CodingLines_Array);
  ConversionFactor int(3);
  ItemDescription  varucs2(50);
  ItemNumber       varchar(40);    // z.B. EAN-Nr
  LineNumber       varchar(10);
  ItemId           varchar(40);    // TENR
  Quantity         zoned(24: 3);
  Unit             varchar(10);
  UnitPrice        zoned(24: 6);
  Reference        varchar(40);
  Reference2       varchar(40);
  DeliveryLines    likeds(DeliveryLines_array);
  TaxIndicator1    varchar(30);
  IsServiceBased   varchar(6) inz('false');
  IsTwoWayMatch    varchar(6) inz('false');
  TwoWayMatchTotalInvoicedQuantity varchar(6);
  Json             varucs2(200000);
END-DS;
dcl-ds PurchaseOrderLines_array qualified template;
  count            int(5);
  // innerhalb von "PurchaseOrderLines" gibt es zwar eine beliebige Menge von
  // "PurchaseOrderLine"-Elementen... aber das hier von der Dimension abzubilden
  // ist ungeeignent. Es gibt in der Praxis Bestellungen mit bis zu 400 Positionen!
  // -> Das ist also nur dummy-mäßig ein Array, es wird immer index=1 verwendet!
  PurchaseOrderLine likeds(PurchaseOrderLine_t) dim(2);
  Amount           zoned(24: 2);
  //Json             varucs2(50000);
END-DS;
dcl-ds PurchaseOrder qualified;
  count            int(3);
  ErpSourceId      varchar(50);
  customField_Text2 varchar(50);
  ExternalSystemId varchar(50);
  IsActive         varchar(10) inz('true');
  CompanyId        varchar(50);
  Amount           zoned(24: 2);
  CurrencyCode     char(5) inz('EUR');
  OrderIdentifier  varchar(40);
  RegisterDate     varchar(30); // timstamp, format: 2023-03-08T10:15:38.151Z
  DueDate          varchar(30); //timestamp
  Supplier         varchar(40);
  Reference        varchar(40);
  PaymentTerm      varchar(40);
  OrderType        char(1) inz('T');
  PurchaseOrderLines likeds(PurchaseOrderLines_array);
  // PurchaseOrderComments likeds(x);
  // 2025-04-24: AdditionalOrderIdentiers: Bestellreferenz ohne Slash
  Json             varucs2(500000);    // komplettes JSON für diese Bestellung
  // letztes Element der Gruppe, sogar NACH den ganzen Positionen
  //  "additionalOrderIdentifiers": [  "string"  ]  // Array von Werten
  AdditionalOrderIdentifier varucs2(300);
END-DS;
//---
  dcl-ds StsED97_t qualified template;
    CurGroup       int(5);
    FIRM           like(ED97FIRM);
    DAKY           like(ED97DAKY);
    JAHR           like(ED97JAHR);
    NMKR           like(ED97NMKR);
  END-DS;
//*************************************************************************
//**  DATENSTATIONSARBEITSBEREICH                                       ***
//*************************************************************************
DCL-DS EXTRLD      EXT DTAARA(*AUTO:*USRCTL:*LDA) END-DS;

//*************************************************************************
//**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
//*************************************************************************
/COPY QCPYSRC,EXPSDS
dcl-s dummy char(1);
//*************************************************************************
dcl-ds glb qualified inz;
  ENVI             varchar(4);
  CompanyId        varchar(50) inz('company[DE411]');
  ClientId         varchar(50);
  ClientSecret     varchar(64);
  ExSys            varchar(20);
  Bearer           varchar(2000);
  Tenant           varchar(50) inz('dometicQA');   // TRPA: MOBBEX-MEDIUSNAME-TEST|ECHT
  ErpSourceId      varchar(50) inz('Trend-&umgebung-&firma');
  DateTimeToday    varchar(20);

  DoIfsFile        ind;
  DoSendOrders     ind;
  DoOrdersRetry    ind;
  DoHttpTrace      ind;
  DoBacthId        ind;
  DoInvoicReTry    ind;
  BasePath         varchar(200) inz('/trend/test/temp/');
  SABEdefault      char(2);
  BEATignore       varchar(60);
  LineNumberEnum   char(3);
  LogDaky          char(40);
END-DS;
// DOMETIC: mit VRM 7.2 gibt's SQL-Einschränkungen
dcl-ds wkSql       qualified;
  String1          varucs2(50);
  String2          varucs2(50);
  String3          varucs2(50);
END-DS;
//*************************************************************************
dcl-pr C_EXTSTP extpgm('EXTSTP');
   #SPCDTSTP like(ED97TSTP);
end-pr;
//*************************************************************************
DCL-S ##CHI        CHAR(8);
DCL-S WKFENR like(WKFENR_t);
DCL-S WKFIRM like(DAFIRM);
DCL-S WKTEEWIDCO   varchar(10);
DCL-S wkTempString varucs2(80);
//*************************************************************************
//*** Start des Programmes
//*************************************************************************
// Parameter:
// PGST: CT = KommTrace,  FT=FileTrace
//       SO = SendOrders, OR=RetryOrders
///      BI = BatchID-Import
//       --> beliebig Kombinieren
//----
dcl-proc MOBBEX;
  dcl-pi *n;
    #PGST          char(10);
  end-pi;

  dcl-ds ex        likeds(PurchaseOrder);
  dcl-ds curPOL    likeds(PurchaseOrderLine_t) based(curPOL_ptr);
  dcl-ds curCodLin likeds(PreCodingLine_t) based(curCodLin_ptr);
  dcl-ds curDlvLin likeds(DeliveryLine_t) based(curDlvLin_ptr);
  dcl-ds wk        qualified inZ;
    POL            int(5);
    idx            int(5);
    pos            int(10);
    buff4k         varucs2(4000);
    OpenId         like(ifsFileHandle_t) inz(-1);
    NVP            likeds(NameValueList_t);
    BatchIdResult  likeds(NameValueList_t);
    ED97           likeds(StsED97_t);
    CurED97Data    like(ED97DATA);
    CurStatus      varchar(50);
    CurTSTPBB      varchar(50);
    CurTSTPEX      varchar(50);
    EPNESUsum      zoned(15: 2);
    PrvStatus      varchar(50);
    Name           varchar(50);
    NValue         varucs2(50);
    CurBatchId     varucs2(200);
    ExtSysId       varchar(50) dim(5);
    NullId         int(5);
    DummyBuffer    varucs2(100: 4);
    BufferCount    int(5);
    BufferCountMax int(5) inz(20);
    OrderCount     int(10);
    OrderCountMax  int(10) inz(9999);
    KRLF           char(10);
  END-DS;
  dcl-s WKKRLF     char(10);
  // Struktur STS: Status der Bereitstellung, wird in Datei ED97 gespeichert
  dcl-ds Sts qualified inz;
    SqlTSTP        varchar(40);
    CountED97      int(5);
    ED97           likeds(StsED97_t) dim(1000);
    CurGrpCount    int(5);
    NVP            likeds(NameValueList_t);
    FileNameQual   varchar(50);
  END-DS;
  //dcl-s WkBuffer   varucs2(32000);
  dcl-s WkBuffer   varucs2(564000);
  //dcl-s WkBuffer   varucs2(8000);

  /include QCPYSRC,PGINIT

  IN EXTRLD;

  IF WKFIRM <> DAFIRM;
    EXSR ANFANG;
    EXSR ETRPA;
  ENDIF;

  EXSR VORLAUF;

  if #PGST = 'INV' or #PGST = 'GETINV';
    glb.DoIfsFile = *ON;
    lcl_LoadInvoices('GETINV');
  else;
    exsr SBBEK;
  ENDIF;

  lcl_logErrors('WRITE');

  return;

  //*************************************************************************
  //**  ERÖFFNUNGSZYKLUS                                                  ***
  //*************************************************************************
  BEGSR ANFANG;

    KYEKFI = DAFIRM;      // AFED

  ENDSR;

  //*************************************************************************
  //**  VORLAUF                                                           ***
  //*************************************************************************
  BEGSR VORLAUF;

    glb.ExSys = 'company[DE411];';
    glb.DoIfsFile = (%scan('FT': #PGST) > *zero);
    glb.DoSendOrders = (%scan('OS': #PGST) > *zero);
    glb.DoOrdersRetry = (%scan('OR': #PGST) > *zero);
    glb.DoHttpTrace = (%scan('CT': #PGST) > *zero);
    glb.DoBacthId = (%scan('BI': #PGST) > *zero);

    glb.ENVI = %trim(getINITValue('FIR0016'));
    glb.BasePath = '/trend/' + glb.ENVI + '/temp/MOBBEX/';
    glb.Tenant = getTRPACode('MOBBEX': 'MEDIUSNAME': glb.ENVI);
    if glb.Tenant = *blank;
      glb.Tenant = 'dometicQA';
    endif;
    glb.Tenant = %trim(glb.Tenant);
    glb.ErpSourceId = 'Trend-' + glb.ENVI + '-' + DAFIRM;

    glb.DateTimeToday = %char(%dec(%date())) + %editc(%dec(%time()): 'X');

     WKCHPN = EXPSDSPROC;
     WKCHPL = EXPSDSBIBL;
     lcl_logErrors('INZ');
  ENDSR;

  //*************************************************************************
  //**  SBBEK - Selektieren BBEK-Sätze                                    ***
  //*************************************************************************
  BEGSR SBBEK;

    trNameValue(wk.NVP: '*INIT');
    trNameValue(Sts.NVP: '*INIT');

    Sts.CurGrpCount = 1;
    clear ex.Json;
    clear ex.count;
    //ex.Json = lc_JsonListStart;

    SQLCOD = *ZERO;
    // "dummes" SQL:
    exec sql DECLARE MOBBEX_C0 CURSOR FOR
               select EKFIRM, EKBEJJ, EKBENR, EKLFNR, EKBENN
              from BBEK
              where EKFIRM = :DAFIRM
              and EKBEST < '90'
              and EKBEJJ >= 2023
           order by EKFIRM, EKBEJJ, EKBENN;
    // SQL zum Ermitteln der relevanten Bestellungen:
    // Sobald es in EINER der untergeordneten Dateien (BBEP, BWAE)
    //   eine Änderung gibt, muss die GANZE Bestellung nochmals verarbeitet werden
    //   Dafür: Aus JDAT+JZEI jeweils eine TSTP bauen -> für Max() + Vergleich mit ED97
    // BBEK: nur aktive und zumindet von 2023 oder neuer, DAKY zusammenbauen!
    // BBEK: ... und alle, die einen Wareneingang nach 2023 haben
    // BBEP: nur Status 30-60, neuestes Änderungsdatum, Summe EPNESU
    // BWAE: muss zumindest vorhanden sein! + neuestes Änderungsdatum
    // ED97: DANA="BBEK" für Vergleich Änderungszeitpunkt
    //       DAKY=OK, Pending, error... JAHR+MNKR=BEJJ+BENR
    exec sql DECLARE MOBBEX_C1 CURSOR FOR
     with bk as(
     select EKFIRM, EKBEJJ, EKBENR, EKLFNR, EKBENN,
     --(varchar(ekbejj)||lpad(trim(ekbenr), 6, '0')) as DAKY,
     varchar(ekjdat)||lpad(varchar(ekjzei), 6, '0') as tstp
     from BBEK as BK
     where EKFIRM = :DAFIRM
      and EKBEST < '90'
      and ( EKBEJJ >= 2023
      --and (EKBEJJ > 2023 or  EKBENN >= 2000)       -- nur zum Test!
     or exists(select * from bwae where aefirm=bk.ekfirm
        and aebejj=bk.ekbejj and aebenr=bk.ekbenr and aeweda>20230101)
        )
     order by EKFIRM, EKBEJJ, EKBENN
     ),
     bp as(
     select epfirm, epbejj, epbenr, sum(epnesu) as epnesusum,
     max(varchar(epjdat)||lpad(varchar(epjzei), 6, '0')) as tstp
     from bbep
     where epbest >='30' and epBEST<'60'
     group by epfirm, epbejj, epbenr
     ),
     we as(
     select aefirm, aebejj, aebenr, count(*) as anz,
     max(varchar(aejdat)||lpad(varchar(aejzei), 6, '0')) as tstp
     from bwae
     group by aefirm, aebejj, aebenr
     ),
     ed as(
      select ed97firm, ed97daky, ED97DATA, ed97jahr, ed97nmkr,
      varchar(ed97jdat)||lpad(varchar(ed97jzei), 6, '0') as tstp
      --, regexp_substr(ed97data, '(?<=Status=)([^;]*)') as xStatus
      --, regexp_substr(ed97data, '(?<=validationTag=)([^;]*)') as xTag
      from ed97 where ed97dana='BBEK'
     )

     select bk.EKFIRM, bk.EKBEJJ, bk.EKBENR, bk.EKLFNR, bk.EKBENN,
       epnesusum, -- xStatus, xTag,
       max(bk.TSTP, bp.TSTP, we.TSTP) as TSTPBB,
       ed.tstp as TSTPEX,
       coalesce(ED97DATA, '')

     from bk
     join bp on bp.epfirm=bk.ekfirm
       and bp.epbejj=bk.ekbejj and bp.epbenr=bk.ekbenr
     join we on we.aefirm=bk.ekfirm
       and we.aebejj=bk.ekbejj and we.aebenr=bk.ekbenr
     left outer join ed as ed on ed97firm=bk.ekfirm
     and ed97jahr=bk.ekbejj and ed97nmkr=bk.ekbenr

     where EKLFNR <> '99905'    -- Test! dieser Kunde ist in Schilling/Medius anders

     order by bk.ekfirm, bk.ekbejj, bk.ekbenn;


    exec sql open MOBBEX_C1;

    DOW not %shtdn;

      EXEC SQL
          FETCH MOBBEX_C1 INTO :KYEKFI, :KYEKJH, :KYEKBE, :KYEKLF, :KYEKBN,
              :wk.EPNESUsum,
              :wk.CurTSTPBB,
              :wk.CurTSTPEX  :wk.Nullid,
              :wk.CurED97DATA;

      IF SQLCOD <> *ZERO;
        LEAVE;
      endif;

      trNameValue(wk.NVP: '*CLEAR');
      lcl_AtrListToNVP(wk.CurED97Data: wk.NVP);
      wk.ED97.FIRM = KYEKFI;
      wk.ED97.JAHR = KYEKJH;
      wk.ED97.NMKR = KYEKBE;

      wk.CurStatus = trNameValue(wk.NVP: LC_Status);
      if wk.CurTSTPBB > wk.CurTSTPEX;
        // Änderungen an der bestellung -> auf jden fall nochmal senden

      elseif (wk.CurStatus = LC_Send or wk.CurStatus = *blank)
      and trNameValue(wk.NVP: 'BatchId') > '0';
        // Daten wurden bereits gesendet,
        // Und die Bestellung hat sich lokal nicht geändert
        // ... es muss noch geprüft werden, ob der Empfang korrekt war
        exsr VBatchId;
        iter;

      elseif wk.CurStatus = 'Successful';
        // bereits erledigt
        iter;

      //elseif wk.CurStatus = 'notSuccessful' and not glb.DoOrdersRetry;
      elseif wk.CurStatus = 'notValid' and not glb.DoOrdersRetry;
        // Orders mit Fehler nicht nochmal versuchen
        // Hier macht es Sinn, dieses "retry" geziel aufzurufen
        // ... oder zumindest maximal einmal täglich
        iter;

      elseif glb.DoSendOrders = *off
      and    glb.DoIfsFile = *off;
        // nur BatchId's prüfen!
        iter;
      ENDIF;

      CHIDS = '01C';
      exsr CHBBEK;
      if wkFENR <> NO_ERROR;
        iter;
      elseif Sts.CountED97 >= %elem(Sts.ED97);
        leave;
      elseif %scan(EKBEAT: glb.BEATignore) > *zero;
        // Rücklieferungen ignorieren!
        iter;
      ENDIF;

      wk.OrderCount  += 1;
      exsr VBBEK;


      // mehr als 20 Bestellungen sollten nicht in einen "Batch"... da die NVPs
      // für die Auswertung des Ergebisses nur eingeschränkt Platz haben
      if %len(WkBuffer) + %len(ex.Json) + 1 >= %len(WkBuffer: *max)
      or wk.PrvStatus <> wk.CurStatus and wk.PrvStatus <> *blank
      or wk.BufferCount >= wk.BufferCountMax
      or wk.OrderCount >= wk.OrderCountMax;
        WkBuffer += lc_JsonListEnd;
        exsr UDATA;
        Sts.CurGrpCount += 1;
        clear WkBuffer;
        clear wk.BufferCount;
        WkBuffer = lc_JsonListStart;

      elseif Sts.CountED97  = 1;
        clear wk.BufferCount;
        WkBuffer = lc_JsonListStart;

      elseif Sts.CountED97 >= 2;
        WkBuffer += lc_JsonDelimiter;
      endif;

      wk.BufferCount += 1;
      WkBuffer += ex.Json;
      clear ex.Json;
      wk.PrvStatus = wk.CurStatus;

      if wk.OrderCount >= wk.OrderCountMax;
        leave;
      ENDIF;
    enddo;

    exec sql close MOBBEX_C1;

    WkBuffer += lc_JsonListEnd;
    exsr UDATA;

  ENDSR;

  //*************************************************************************
  //**  VBBEK         Verarbeiten EINES BBEK-Satzes                       ***
  //*************************************************************************
  BEGSR VBBEK;

    // Es sollen viele Bestellungen auf mal übertragen werden..
    // - nicht zu kleine Portionen (vor allem nicht: jede Bestellung einzeln)
    // - nicht zuviele auf mal (mehr als 500 seien nicht gut)

    // bei DOMETIC gibt es Bestellungen mit mehreren hundert bestellpositionen
    // Die Top-ten (ab 2022): 346, 298, 296, 259, 195, 173,....
    // Jede Postion braucht mindestens ein paar hundert byte (Wareneinhänge!)
    // -> Die Positinen müssen direkt in den Puffer geschrieben werden!
    // Blöd nur, dass die SUMME auf den Kopf muss -> SQL!

    // Struktur ist:
    // ArrayOfPurchaseOrder      <= root
    //   PurchaseOrder           <= BBEK-Ebene
    //     diverse Werte         <= BBEK.x
    //     PurchaseOrderLines    <= Strukturelement ohne Inhalt
    //       PurchaseOrderLine   <= BBEP-Ebene
    //         diverse Felder    <= BBEP.x wie TENR
    //         CodingLines.PreCodingLimnes .. ??
    //         DeliveryLines     <= Strukturelement ohne Inhalt
    //            DeliveryLine   <= BBEP.x ?? wie Lieferzeitpunkt
    //         diverse Felder
    //     PurchaseOrderComments <= keine Entsprechung
    //     AdditionalOrderIdentifiers <= keine Entsprechung

    // 9.4.2024: Statt der Lieferantennummer ggf. deb (abweichenden!) Rechnungsempfänger angeben.
    //    Dieser steht jedoch nur im LIEF-Satz und nicht in der BBEK.
    //    Bereitstellung der BBEK-Lieferantennummer in customField_Text2
    //    (customField_Text1 kommt bei der Rechnung schon zurück..)
      exec sql select LFKRLF into :WKKRLF
        from lief
        where LFFIRM = :EKFIRM and LFLFNR=:EKLFNR and LFKRLF <> ' ';
      if sqlcode <> *zero or WKKRLF = *blank;
        WKKRLF = EKLFNR;
      ENDIF;

      Sts.CountED97 += 1;
      clear Sts.ED97(Sts.CountED97);
      trNameValue(Sts.NVP: 'selected': wk.CurTSTPBB);
      Sts.ED97(Sts.CountED97).CurGroup = Sts.CurGrpCount;
      //Sts.ED97(Sts.CountED97).ED97DAKY = trRefNrToString(KYEKJH: KYEKBE);
      Sts.ED97(Sts.CountED97).JAHR = KYEKJH;
      Sts.ED97(Sts.CountED97).NMKR = KYEKBE;
      Sts.ED97(Sts.CountED97).DAKY = wk.CurTSTPBB;
      lcl_ED97(PGST_DETAIL: Sts.ED97(Sts.CountED97): '': Sts.NVP);

      clear ex.Json;
      ex.ErpSourceId = glb.ErpSourceId;
      //ex.ExternalSystemId = glb.ExSys + 'BBEK;' + trRefNrToString(KYEKJH: KYEKBE);
      ex.ExternalSystemId = lcl_ExtrernalId('BBEK': KYEKJH: KYEKBE);
      trNameValue(Sts.NVP: 'externalSystemId': ex.ExternalSystemId);
      ex.IsActive = ifTrue(EKBEST >= '90': 'false': 'true');
      ex.CompanyId = glb.CompanyId;
      ex.Amount = wk.EPNESUsum;  // Total Net.Amount -> Summe aus BBEP!
      // ex.CurrencyCode = 'EUR';
      ex.CurrencyCode = EKWACD;  //"ExternalSystemId to corresponding entity",
      ex.OrderIdentifier = l_RefNrToString(KYEKJH: KYEKBE); //"Order identifier, e.g. Order number"

      ex.RegisterDate = lcl_tstp(%timestamp(%date(EKBEDA)));
      //ex.DueDate = lcl_tstp(0: 0);

      // Lieferant: immer in customField_Text2,  als "supplier" ggf. den Rechnungssteller
      ex.customField_Text2 = glb.ExSys + 'BBEK.LFNR;2' + %trim(EKLFNR) + '000';
      ex.Supplier = glb.ExSys + EKLFNR;  // "ExternalSystemId to corresponding entity"
      // Lieferant: Vorgegebene Aufbereitung: "2" + 5-stelliger LF-Nr. + '000';
      ex.Supplier = glb.ExSys + '2' + %trim(EKLFNR) + '000';  // "ExternalSystemId ...
      ex.Supplier = glb.ExSys + '2' + %trim(WKKRLF) + '000';  // "ExternalSystemId ...

      // todo: Codes sind Vorgegeben
      ex.PaymentTerm = glb.ExSys + EKBEAT;  // "ExternalSystemId to corresponding entity"
      // todo: vorübergehdner fix
      if %scan(EKZABD: '004,005,006,007,008,009') > *zero;
      ex.PaymentTerm = glb.ExSys + %subst(EKZABD: 2);  // "ExternalSystemId to corresponding entity"
      elseif %scan(EKZABD: '011,012,006,007,008,009') > *zero;
      else;
      ex.PaymentTerm = glb.ExSys + EKZABD;  // "ExternalSystemId to corresponding entity"
      ENDIF;
      // ex.OrderType = 'T'(external, default) oder 'M' (internal)

      ex.Json += lc_JsonGroupStart;
      //ex.Json += lcl_jsonElem('ErpSourceId': ex.ErpSourceId) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('externalSystemId': ex.ExternalSystemId) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('customField_Text2': ex.customField_Text2) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('isActive': ex.IsActive) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('companyId': ex.CompanyId) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('amount': '': ex.Amount) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('currencyCode': ex.CurrencyCode) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('orderIdentifier': ex.OrderIdentifier) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('registerDate': ex.RegisterDate) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('supplier': ex.Supplier) + lc_JsonDelimiter;
      ex.Json += lcl_jsonElem('paymentTerm': ex.PaymentTerm) + lc_JsonDelimiter;

      // jetzt können hunderte von Bestellpositionen kommen...
      // Diese müssen direkt an das JSON angefügt werden - macht keinen Sinn
      // das erst lokal vorzuhalten
      clear ex.PurchaseOrderLines;
      monitor;
      exsr VBBEP;
      if ex.PurchaseOrderLines.Amount <> wk.EPNESUsum;
        // ... da ist was schief gelaufen! Die Netto-Summe aus SQL
        // und dem erzeugten JSON stimmt nicht überein
        // darf nicht passieren!
        ex.Amount = ex.PurchaseOrderLines.Amount; // Total Net.Amount -> Summe aus BBEP!
      ENDIF;

      ex.Json += lc_JsonDelimiter;
      ex.Json += '"purchaseOrderComments" : ' + lc_JsonGroupStart;
      ex.Json += lcl_jsonElem('erpSourceId': glb.CompanyId) + lc_JsonGroupEnd;

      // Alternative Schreibweise der Bestellung: "jahr+Nummer" (ohne Slash, ohne Nullen)
      ex.Json += lc_JsonDelimiter;
      ex.Json += '"AdditionalOrderIdentifier" : ' + lc_JsonListStart;
      ex.Json += '"' + %char(KYEKJH) +  %trim(KYEKBE) + '"' + lc_JsonListEnd;

      on-error;
        trNameValue(Sts.NVP: 'error': 'VBBEP-exception');
        lcl_logErrors('NVP': Sts.NVP);
      endmon;

      ex.Json += lc_JsonGroupEnd;

      trNameValue(Sts.NVP: 'Size': %Char(%len(ex.Json)));
      trNameValue(Sts.NVP: 'Seq': %Char(Sts.CountED97));
      trNameValue(Sts.NVP: 'Amount': trCharISO(ex.Amount: 2));
      trNameValue(Sts.NVP: 'IsActive': ex.IsActive);
      trNameValue(Sts.NVP: 'ZABD': EKZABD);
      lcl_ED97('UPD': Sts.ED97(Sts.CountED97): 'selected;Size;Seq;Amount;IsActive;ZABD': Sts.NVP);

  endsr;

  //*************************************************************************
  //**  Verarbeiten BBEP
  //*************************************************************************
  BEGSR VBBEP;
    clear wk.POL;
    clear ex.PurchaseOrderLines.Amount;
    clear ex.PurchaseOrderLines.count;

    ex.Json += '"purchaseOrderLines" : ';
    ex.Json += lc_JsonListStart;
    //ex.PurchaseOrderLines.Json += lc_JsonGroupStart;
    clear KYBBEP;
    KYEPFI = KYEKFI;
    KYEPJH = KYEKJH;
    KYEPBE = KYEKBE;
    KYEPLF = KYEKLF;
    KYEPPJ = KYEKPJ;
    KYEPPO = *ZERO;
    CHIDS = '01+';
  dou EPBENR <> KYEPBE;
    exsr CHBBEP;
    CHIDS = '01R';
    if wkFENR <> NO_ERROR;
      leave;
    elseif EPFIRM <> KYEPFI
      or   EPBEJJ <> KYEPJH
      or   EPBENR <> KYEPBE;
      leave;
    ENDIF;

    ex.PurchaseOrderLines.count += 1;
    wk.POL += 1;
    //curPOL_ptr = %addr(ex.PurchaseOrderLines.PurchaseOrderLine(wk.POL));
    curPOL_ptr = %addr(ex.PurchaseOrderLines.PurchaseOrderLine(1));
    clear curPol;
    curPOL.ErpSourceId = l_RefNrToString(EKBEJJ: EKBENR) + '.' + %char(EPBEPO);
    curPOL.ExternalSystemId = lcl_ExtrernalId('BBEP': EKBEJJ: EKBENR) + '.' + %char(EPBEPO);
    curPOL.IsActive = 'true';
    curPOL.Amount = EPNESU; // Total-Net
    ex.PurchaseOrderLines.Amount += EPNESU;
    //curPOL.codingLines = x;       // Regeln für zulässigeAbweichungen
    curPOL.ConversionFactor = 1;    // Conversion factor for unit price and quantity.
    curPOL.ItemDescription = %trimr(EPTBZ1) + ' ' + EPTBZ2;  // Item description
    curPOL.ItemNumber = EPTENR;     // Item-Nr.
    curPOL.LineNumber = %char(wk.POL);  // Position
    if glb.LineNumberEnum = 'seq';
      curPOL.LineNumber = %char(wk.POL);  // Position
    elseif glb.LineNumberEnum = 'key';
      // die "LineNumber" ist primärer Schlüssel in Medius!
      // Die "LineNumber" muss immer eine eindeutige Beziehung zur "externalSystemId" haben
      curPOL.LineNumber = %char(EPBEPO);  // Position
    elseif glb.LineNumberEnum = 'new'
      and (EKBEJJ = 2025 and EKBENR >= '6775' or EKBEJJ > 2025);
      curPOL.LineNumber = %char(EPBEPO);  // Position
    endif;
    curPOL.ItemId = glb.ExSys + EPTENR;  // ExternalSystemId...
    curPOL.Quantity = EPMENG;       // "Ordered quantity of the order line."
    //curPOL.Unit = DAFIRM + '/MEIN.' + EPMEIN;  // "ExternalSystemId to corresponding entity"
    curPOL.Unit = glb.ExSys + EPMEPR;  // "ExternalSystemId to corresponding entity"
    curPOL.Unit = '-'; // "-"=Default  // "ExternalSystemId to corresponding entity"
    curPOL.UnitPrice = EPPREI;      //"Unit price of the order line"
    if EPPDIM <= '1';
      // ok
    elseif EPPDIM = '2';
      curPOL.UnitPrice /= 10;
    elseif EPPDIM = '3';
      curPOL.UnitPrice /= 100;
    elseif EPPDIM = '4';
      curPOL.UnitPrice /= 1000;
    elseif EPPDIM = '5';
      curPOL.UnitPrice /= 10000;
    elseif EPPDIM = '6';
      curPOL.UnitPrice /= 100000;
    ENDIF;
    // ab 21.5.2024: reference[2]: Name von TESAEK, TEDIEK
    // ab April 2025 (Workshop in Emsdetten): ganze E-Mail-Adresse
    clear wkSql.String1;
    clear wkSql.String2;
    clear wkSql.String3;
    exec sql with na as(
      select distinct tpfirm, tptcde, tpttxt,
      varchar(trim(regexp_substr(tpttxt, '(?<=:)[^:]*'))) as txt
     from trtp
     where tpspcd='D' and tptart='SABE' and locate('@', tpttxt) > 0
      )
    select coalesce(na1.txt, ''), coalesce(na2.txt, ''), coalesce(na3.txt, '')
    into :wkSql.String1, :wkSql.String2, :wkSql.String3
    from TEIL
    left outer join na as na1 on na1.tpfirm= tefirm and na1.tptcde=tesaek
    left outer join na as na2 on na2.tpfirm= tefirm and na2.tptcde=tediek
    left outer join na as na3 on na3.tpfirm= tefirm and na3.tptcde=:EKSABE
    where TEFIRM = :DAFIRM and TETENR = :EPTENR
    fetch first row only;
    // SABE aus BBEK!
    if wkSql.String3 = *blank;
    curPOL.Reference = wkSql.String1;
    curPOL.Reference2 = wkSql.String2;
    else;
    curPOL.Reference = wkSql.String3;
    curPOL.Reference2 = wkSql.String1;
    endif;
    //curPOL.TaxIndicator1 = DAFIRM + '/MWST.' + EPx;  // "ExternalSystemId to ... (TaxGroup)"
    curPOL.IsTwoWayMatch = 'false'; // true=no goods receipts are expected
    //----
     clear curPol.Json;
     curPol.Json += lc_JsonGroupStart;
     // curPol.Json += lcl_jsonElem('ErpSourceId': curPOL.ErpSourceId) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('externalSystemId': curPOL.ExternalSystemId) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('isActive': curPOL.IsActive) + lc_JsonDelimiter;
     // amount: "Total NET amount of the order line. Currency taken from header. Decimal format (28,
     curPol.Json += lcl_jsonElem('amount': '': curPOL.Amount) + lc_JsonDelimiter;

     //curPol.Json += lcl_jsonElem('codingLines': curPOL.codingLines.json) + lc_JsonDelimiter;
     exsr CodingLines;
     curPol.Json += curPol.CodingLines.json + lc_JsonDelimiter;

     curPol.Json += lcl_jsonElem('conversionFactor': '': curPOL.ConversionFactor) +lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('itemDescription': curPOL.ItemDescription) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('itemNumber': curPOL.ItemNumber) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('lineNumber': curPOL.LineNumber) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('itemId': curPOL.ItemId) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('quantity': '': curPOL.Quantity) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('unit': curPOL.Unit) + lc_JsonDelimiter;
     // hm.. Elemetn "unitPrice" hat Anfang 2025 gefehlt... Wieso?
     // Funktion lcl_JsonElem() macht immer zwei Nachkommastellen. Hier werden ggf. mehr benötigt.
     if EPPDIM = '1';
       curPol.Json += lcl_jsonElem('unitPrice': '': curPOL.UnitPrice) + lc_JsonDelimiter;
     else;
       curPol.Json += lcl_jsonElem('unitPrice': trCharISO(curPOL.UnitPrice: 6)) + lc_JsonDelimiter;
     endif;
     curPol.Json += lcl_jsonElem('reference': curPOL.Reference) + lc_JsonDelimiter;
     curPol.Json += lcl_jsonElem('reference2': curPOL.Reference2) + lc_JsonDelimiter;

     clear curPol.DeliveryLines.count;
     clear curPol.DeliveryLines.json;
     exsr VBWAE;  // Wareneingänge
     //curPol.Json += lc_JsonDelimiter;
     curPol.Json += curPol.DeliveryLines.json;

     curPol.Json += lc_JsonGroupEnd;
     if ex.PurchaseOrderLines.count > 1;
       ex.Json += lc_JsonDelimiter;
     ENDIF;
     ex.Json += curPol.Json;

     enddo;
     ex.Json += lc_JsonListEnd;
  ENDSR;
  //*************************************************************************
  //**  UPDATE DATEI LOG
  //*************************************************************************
  BEGSR CodingLines;

    // Mandatory!
    curCodLin_ptr = %addr(curPol.CodingLines);
    clear curPol.CodingLines;
    curPol.CodingLines.json = '"codingLines": ';
    curPol.CodingLines.json += lc_JsonListStart;

    dou 1=1;  // Mandatory!
      if curPol.CodingLines.count >= 1;
        curPol.CodingLines.json += lc_JsonDelimiter;
      endif;
      curPol.CodingLines.json += lc_JsonGroupStart;

      curPol.CodingLines.count += 1;
      curCodLin_ptr = %addr(curPol.CodingLines.PreCodingLine(1));

      curCodLin.Amount = *zero;
      // Wert ans BBEP.EPWBKT  "Konto" gemäß TRTP-KOZK
      // Als: company[DE411];DIMENSION1;384500000
      // Diemnsion(gemäß Schilling) immer 9-stellig
      // Fixes:
      curCodLin.dimensions.Dimension1 = '';  // 21.03.2023: leer lassen!
      curCodLin.dimensions.Dimension1 = EPWBKT;
      curCodLin.dimensions.Dimension1 = glb.ExSys + 'DIMENSION1;' + EPWBKT;
      if     EPWBKT = '331000';
        curCodLin.dimensions.Dimension1 = glb.ExSys + 'DIMENSION1;' + '331000000';
      elseif EPWBKT = '845000';
        curCodLin.dimensions.Dimension1 = glb.ExSys + 'DIMENSION1;' + '384500000';
      elseif EPWBKT = *blank;
        // Fehler! kann/darf so nicht bereitgestellt werden
      ENDIF;
      clear wkTEEWIDCO;
      exec sql select TEEWIDCO into :wkTEEWIDCO
        from TEEW
      where TEEWFIRM = :DAFIRM and TEEWTENR = :EPTENR;
      curCodLin.dimensions.Dimension4 = wkTEEWIDCO;  // IDCO-COde aus TEEW
      curCodLin.dimensions.FreeText1 = 'default';
      curCodLin.dimensions.FreeText1 = getTRTPText('KOZK': EPWBKT);
      // Workshop 23.4.2025: Incoterm (BBEK.EKLIBD" als Text (!) in "freeText5"
      curCodLin.dimensions.FreeText5 = EKLIBD;
      clear wkTempString;
      exec sql select TPTTXT into :wkTempString
        from TRTP where TPFIRM=:DAFIRM and TPSPCD=:DASPCD
         and TPTART='LIBD' and TPTCDE=:EKLIBD and TPTFLG = 0
        fetch first row only;
      if wkTempString <> *blank;
      curCodLin.dimensions.FreeText5 = wkTempString;
      endif;
      // "type" ist enum
      curCodLin.type = 'Cost';

      curPol.CodingLines.json += lcl_jsonElem('amount': '': curCodLin.Amount);
      curPol.CodingLines.json += lc_JsonDelimiter;

      curPol.CodingLines.json += '"dimensions": ' + lc_JsonGroupStart;
      curPol.CodingLines.json += lcl_jsonElem('dimension1': curCodLin.dimensions.dimension1);
      curPol.CodingLines.json += lc_JsonDelimiter;
      /if defined(never)
      if curCodLin.dimensions.dimension4 <> *blank;
      curPol.CodingLines.json += lcl_jsonElem('dimension4': curCodLin.dimensions.dimension4);
      curPol.CodingLines.json += lc_JsonDelimiter;
      endif;
      /endif
      curPol.CodingLines.json += lcl_jsonElem('freeText1': curCodLin.dimensions.freeText1);
      curPol.CodingLines.json += lc_JsonDelimiter;
      curPol.CodingLines.json += lcl_jsonElem('freeText5': curCodLin.dimensions.freeText5);
      curPol.CodingLines.json += lc_JsonGroupEnd;
      curPol.CodingLines.json += lc_JsonDelimiter;

      curPol.CodingLines.json += lcl_jsonElem('type': curCodLin.type);

      curPol.CodingLines.json += lc_JsonGroupEnd;
      // todo: Das sind jetzt nur dummy-daten!
      leave;
    ENDDO;

    curPol.CodingLines.json += lc_JsonListEnd;

  ENDSR;

  //*************************************************************************
  //**  Verarbeiten BWAE
  //*************************************************************************
  BEGSR VBWAE;

    clear curPol.DeliveryLines.count;
    clear curPol.DeliveryLines.json;

    curPol.DeliveryLines.json = '"deliveryLines": ';
    curPol.DeliveryLines.json += lc_JsonListStart;

    clear KYBWAE;
    KYAEFI = KYEKFI;
    KYAEJH = KYEKJH;
    KYAEBE = KYEKBE;
    KYAELF = KYEKLF;
    KYAEPJ = KYEKPJ;
    KYAEPO = EPBEPO;
    CHIDS = '01+';
  dou EPBENR <> KYAEBE;
    exsr CHBWAE;
    CHIDS = '01R';
    if wkFENR <> NO_ERROR;
      leave;
    elseif AEFIRM <> KYAEFI
      or   AEBEJJ <> KYAEJH
      or   AEBENR <> KYAEBE
      or   AEBEPO <> KYAEPO;
      leave;
    ENDIF;
    if aeuwjj <> *zero or aeuwnr > *blank;
      // Das ist der neue WE nach einer Umbuchung. Diese ignorieren
      iter;
    elseif aelsmg <> aemeng;
      // Das ist der Ursprungs-WE... der aber auf andere WEs umgebucht wurde
      iter;
    ENDIF;

    curPol.DeliveryLines.count += 1;
    //curDlvLin_ptr = %addr(curPol.DeliveryLines.DeliveryLine(curPol.DeliveryLines.count));
    curDlvLin_ptr = %addr(curPol.DeliveryLines.DeliveryLine(1));
    clear curDlvLin;

    curDlvLin.ErpSourceId = l_RefNrToString(AEWEJJ: AEWENR);
    curDlvLin.ExternalSystemId = lcl_ExtrernalId('BWAE': AEWEJJ: AEWENR);
    curDlvLin.IsActive = 'true';
    curDlvLin.Amount = AENESU;
    curDlvLin.ConversionFactor = 1;
    curDlvLin.DeliveryDate = lcl_tstp(%timestamp(%date(AEWEDA)));
    //curDlvLin.DeliveryNumber = l_RefNrToString(AEWEJJ: AEWENR);
    // AEBLIN darf nicht leer sein!
    curDlvLin.DeliveryNumber = AEBLIN;
    if curDlvLin.DeliveryNumber = *blank;
    curDlvLin.DeliveryNumber = AEBUT1;
    ENDIF;
    if curDlvLin.DeliveryNumber = *blank;
    curDlvLin.DeliveryNumber = AEBLNR;
    ENDIF;
    curDlvLin.DeliveryNote = '';
    // Update 6.5.2025 basierend auf Workshop 23.4.2025: "DeliveryNote"
    // todo: prüfen ob das so brauchbar ist!
    curDlvLin.DeliveryNote = l_RefNrToString(AEBEJJ: AEBENR);
    curDlvLin.ReleaseNumber = '';
    curDlvLin.Quantity = AEMENG;
    curDlvLin.Unit = '-';  // Default!
    curDlvLin.UnitPrice = AEPREI;
    // Nach RS mit Medius am 11.3.2025:
    // Einzelpreis wirklich umrechnen auf Stückpreis, über PDIM.
    // PDIM ist 10er-Potenz: 1=1, 2=10, 3=100
    // hier fix.. eigentlich über TRTP.PDIM
    if AEPDIM <= '1';
      // ok
    elseif AEPDIM = '2';
      curDlvLin.UnitPrice /= 10;
    elseif AEPDIM = '3';
      curDlvLin.UnitPrice /= 100;
    elseif AEPDIM = '4';
      curDlvLin.UnitPrice /= 1000;
    elseif AEPDIM = '5';
      curDlvLin.UnitPrice /= 10000;
    elseif AEPDIM = '6';
      curDlvLin.UnitPrice /= 100000;
    ENDIF;
    curDlvLin.IsFictive = 'false';
    curDlvLin.TotalInvoicedQuantity = 0;       // todo: ??
    //curDlvLin.purchaseOrderLineExternalSystemId = x;

    curDlvLin.json += lc_JsonGroupStart;
     // curPol.Json += lcl_jsonElem('ErpSourceId': curPOL.ErpSourceId) + lc_JsonDelimiter;
    curDlvLin.json += lcl_jsonElem('externalSystemId': curDlvLin.ExternalSystemId) + lc_JsonDlmt;
    curDlvLin.json += lcl_jsonElem('isActive': curDlvLin.IsActive) + lc_JsonDelimiter;
    curDlvLin.json += lcl_jsonElem('amount': '': curDlvLin.Amount) + lc_JsonDelimiter;
    curDlvLin.json += lcl_jsonElem('conversionFactor': trCharISO(curDlvLin.ConversionFactor: 0))
                   + lc_JsonDlmt;
    curDlvLin.json += lcl_jsonElem('deliveryDate': curDlvLin.DeliveryDate) + lc_JsonDlmt;
    curDlvLin.json += lcl_jsonElem('deliveryNumber': curDlvLin.DeliveryNumber)
                     + lc_JsonDlmt;
    curDlvLin.json += lcl_jsonElem('quantity': '': curDlvLin.Quantity) + lc_JsonDelimiter;
    curDlvLin.json += lcl_jsonElem('unit': curDlvLin.Unit) + lc_JsonDelimiter;

    curDlvLin.json += lcl_jsonElem('unitPrice': '': curDlvLin.UnitPrice);
    curDlvLin.json += lc_JsonGroupEnd;
    if curPol.DeliveryLines.count > 1;
      curPol.DeliveryLines.json += lc_JsonDelimiter;
    ENDIF;
    curPol.DeliveryLines.json += curDlvLin.json;

    enddo;
    curPol.DeliveryLines.json += lc_JsonListEnd;
  ENDSR;
  //*************************************************************************
  //**  Medius-Status verarbeiten
  //*************************************************************************
  BEGSR VBatchId;
    // Das Ergebnis eines "Exports" wird asynchron zur Verfügung gestelllt.
    // Über die "Batch-ID" kann der Status abgerufen werden
    // Die Antwort beinhaltet das Ergebnis ALLER übertragenen Bestellungen!

    // Sinnvoller weise sollte dann hier die komplette Antwort verarbeitet werden!

    // Es muss als der passende Teil aus dem Liste extrahiert werden:
    // errors.externalSystemId(n) == aktuelle Bestellung
    // Ggf. sind in dem "Batch" sowohl korrekte als auch fehlerhafte enthalten
    // -> korrekte auf erledigt setzen,
    // -> fehlerhafte nochmnals probieren -> neue Batchid
    if glb.DoBacthId = *OFF;
      leavesr;
    elseif Sts.FileNameQual = *blank;
      Sts.FileNameQual = 'MOBBEX-' + %char(%date(): *ISO0) + '-BI';
    endif;

    if wk.CurBatchId <> trNameValue(wk.NVP: 'BatchId');
      // Die Daten zur "BatchId" sind typischerweise für mehrere Bestellungen gültig
      // Diese einfache Prüfung hier deckt das zwar nur teilweise ab, aber technisch
      // ist es zulässig, auch für einzelne Bestellungen nochmals das Ergebnis für die ganze
      // BatchId abzurufen
      // Wichtig: Es dürfen natürlich keine wesnetlichen Daten darin geändert werden!
      trNameValue(wk.BatchIdResult:'*INIT');
      trNameValue(wk.NVP: 'FileNameQual': Sts.FileNameQual);
      trNameValue(wk.NVP: 'state': '');
      trNameValue(wk.NVP: 'isSuccessful': '');
      trNameValue(wk.NVP: 'jsonDoArrays':'errors');
      clear wk.DummyBuffer;
      lcl_Medius('BID': wk.DummyBuffer: wk.NVP: wk.BatchIdResult);
      wk.CurBatchId = trNameValue(wk.NVP: 'BatchId');
      // Fehlermeldungen sammeln/Ausgeben:
      lcl_logErrors('BID': wk.BatchIdResult);
    ENDIF;

    if trNameValueCount(wk.BatchIdResult) = *zero;
      // Kommunikationsfehler? -> keine Antortdaten!
      leavesr;
    ENDIF;

    wk.ExtSysId(1) = trNameValue(wk.NVP: 'externalSystemId');
    if wk.ExtSysId(1) = *blank;
      wk.ExtSysId(1) = lcl_ExtrernalId('BBEK': KYEKJH: KYEKBE);
    ENDIF;
    wk.ExtSysId(2) = glb.ExSys + trRefNrToString(KYEKJH: KYEKBE); // nur zum testen!! kann dann weg!
    trNameValue(sts.NVP: 'Status': '');
    wk.ED97.DAKY = wk.CurTSTPBB;

    // Achtung: Der Wert "validationTag" wird in Sts:NVP gestellt - VORSICHT!
    //          dieser Wert gilt nicht für den ganzen "Batch"!
    if trNameValue(wk.BatchIdResult: 'isSuccessful') = 'false';
      trNameValue(sts.NVP: 'Status': 'notSuccessful');
      // -> dann einzelprüfung, ob diese Bestellung den Fehler verursacht hat
      for wk.idx = 0 to 100;
        wk.Name = 'errors' +lc_JsonListStart + %char(wk.idx) +lc_JsonListEnd;
        wk.NValue = trNameValue(wk.BatchIdResult: wk.Name + '.validationTag');
        trNameValue(sts.NVP: 'validationTag': wk.NValue);
        wk.NValue = trNameValue(wk.BatchIdResult: wk.Name + '.externalSystemId');
        if wk.NValue = *blank and wk.idx > 1;
          leave;

        elseif wk.ExtSysId(1) <> wk.NValue
        and    wk.ExtSysId(2) <> wk.NValue;
          iter;

        elseif  trNameValue(wk.BatchIdResult: wk.Name + '.validationTag') = '78';
          // Bestellung bereits hochgeladen... -> demnach gehen auch KEINE Updates!
          // .. also keine nachträglichen Wareneingänge
          trNameValue(sts.NVP: 'Status': 'duplicate');
          wk.ED97.DAKY = 'done';
          leave;

        else;
          if trNameValue(sts.NVP: 'validationTag') = '91';
            // debug!
            lcl_logErrors('NVP': wk.BatchIdResult);
          ENDIF;
          trNameValue(sts.NVP: 'Status': 'notValid');
          leave;
        endif;
      ENDFOR;

    elseif trNameValue(wk.BatchIdResult: 'isSuccessful') = 'true';
      trNameValue(sts.NVP: 'validationTag': '0');
      trNameValue(sts.NVP: 'Status': 'Successful');
      wk.ED97.DAKY = 'done';
    ENDIF;

    lcl_ED97('UPD': wk.ED97: 'Status;validationTag': Sts.NVP);

  ENDSR;
  //*************************************************************************
  //*************************************************************************
  //**  UPDATE Daten
  //*************************************************************************
  BEGSR UDATA;

  if  %len(WkBuffer) <= 4 or Sts.CurGrpCount <= *zero;
    // Das höchstens die leere Hülle!
    leavesr;
  ENDIF;

  Sts.FileNameQual = 'MOBBEX-' + %char(%date(): *ISO0) + '-' + %char(Sts.CurGrpCount);

  if glb.DoIfsFile;
    lcl_FileSave(WkBuffer: Sts.FileNameQual + '.json');
    /if defined(never)
    wk.OpenId = trIfsFileOpen(glb.BasePath: Sts.FileNameQual + '.json':
      'UTF8 REPLACE');
    wk.pos = 1;
    if wk.OpenId >= *zero;
      dow wk.pos < %len(WkBuffer);
        if wk.pos + 4000 > %len(WkBuffer);
          wk.buff4k = %subst(WkBuffer: wk.pos);
          leave;
        endif;
        wk.buff4k = %subst(WkBuffer: wk.pos: 4000);
        wk.pos += %len(wk.buff4k);
        trIfsFileWrite(wk.OpenId: wk.buff4k);
        clear wk.buff4k;
      ENDDO;
      trIfsFileWrite(wk.OpenId: wk.buff4k);
    ENDIF;
    trIfsFileClose(wk.OpenId);
    /endif
  ENDIF;

  if glb.DoSendOrders;
    trNameValue(wk.NVP: 'FileNameQual': Sts.FileNameQual);
    WKFENR = lcl_Medius(LC_Send : WkBuffer: wk.NVP);

    trNameValue(wk.NVP: 'FENR': WKFENR);
    for wk.idx = 1 to Sts.CountED97;
      if Sts.ED97(wk.idx).CurGroup = Sts.CurGrpCount;
        lcl_ED97('UPD': Sts.ED97(wk.idx): 'FENR;BatchId;Status': wk.NVP);
      endif;
    ENDFOR;
    trNameValue(wk.NVP: 'FENR': '');
    trNameValue(wk.NVP: 'BatchId': '');
    trNameValue(wk.NVP: 'Status': '');

  endif;

  ENDSR;

  //*************************************************************************
  //**  UPDATE DATEI LOG
  //*************************************************************************
  BEGSR ULOG;
     // Protokollierung und Datenmanagement:
     // BBEK: BEJJ, BENR
     // BBEP: BEPO
     // Trend-Daten:
     // BBEK-Hash / Änderungszeitpunkt
     // BBEP-Hash-Hash / neuester Änderungszeitpunkt
     // Übertrgunsreferenz (trend-Key)
     // Übertrgunsreferenz (medius-Key)
     // Übertragunsdatum -> Medius
     // Übertragungsstatus: ok, pending, fail
     // Log: Dateiname=prefix + trend-key + Filetyp

  ENDSR;

  //*************************************************************************
  //**  ERMITTELN PARAMETERWERTE                                          ***
  //*************************************************************************
  BEGSR ETRPA;

    glb.SABEdefault = getTRPACode('MOBBEX': 'DEFAULT': 'SABE');

    // Vergabe der "LineNumber" an Medius:
    // - "seq" -> neu duchnummerieren (default, da 2024 urpsüunglich so implementiert)
    // - "key" -> BBEP.BEPO aus trend verwenden
    // - "new" -> BBEK.BBJJ + BBNR größer als 2025/6775 (15.4.2025)
    glb.LineNumberEnum = 'new';
    // ACHTUNG!: beim Bestücken der medius-ECHT-Umgebung MUSS glb.LineNumberEnum='key' gelten!
    if %date() >= d'2025-05-19';
    glb.LineNumberEnum = 'key';
    endif;

    // Bestellart "Rücklieferung" ermitteln
    // Diese dürfen/sollen nicht an medius.. da diese keinen Eingangs-Lieferscheinnummer haben
    exec sql
      select listagg(pabeat, ';')  into :glb.BEATignore
      from bbpa as pa
      where pafirm = :DAFIRM and partkz in ('1', :DAJNKZ);


  ENDSR;
  //*************************************************************************
  //**  COPY-MODULE                                                       ***
  //*************************************************************************
  /COPY QCPYSRC,CHBBEK
  /COPY QCPYSRC,CHBBEP
  /COPY QCPYSRC,CHBWAE
end-proc;
//*****************************************************************************
dcl-proc lcl_LoadInvoices;
  dcl-pi *n;
    inPGST         char(6) value;
  END-PI;

  dcl-ds wk qualified inz;
    NVP            likeds(NameValueList_t);
    NVPlist        likeds(NameValueList_t);
    NVPinv         likeds(NameValueList_t);
    StsED97        likeds(StsED97_t);
    Seq            zoned(5);
    FileNameQual   varucs2(100);
    FileName       varucs2(100);
    FileNameNew    varucs2(100);
    FileNameGrp    zoned(4);
    MediusId       varchar(30);
    CurED97DAKY    like(ED97DAKY);
    CurED97Data    like(ED97DATA);
  END-DS;
  dcl-s wkBuffer   varucs2(1000: 4) inz;
  dcl-s wkResponse varucs2(256000: 4) inz;

  // alle unerledigten INVOIC-Dateien verarbeiten
  // Das BEVOR neue ermittelt werden, da die Dateien sich ggf. überschreiben
  // .. wichtig im TEST!
  // .. im ECHT-Betrieb werden die Dateien sowieso immer schon immer direkt verarbeitet

  trNameValue(wk.NVP: '*INIT');
  glb.LogDaky = 'lcl_LoadInvoices()';

  exec sql DECLARE MOBBEX_ED97_BRBK CURSOR FOR
    select ED97DAKY, ED97DATA
    from ED97 where ED97DANA = 'BRBK' and ED97DAKY <> 'done'
    ;

  exec sql open MOBBEX_ED97_BRBK;
  dou %shtdn;
    exec sql FETCH MOBBEX_ED97_BRBK INTO :wk.CurED97DAKY, :wk.CurED97Data;
    if sqlcode <> *zero;
      leave;
    ENDIF;
    lcl_AtrListToNVP(wk.CurED97Data: wk.NVP);
    trNameValue(wk.NVP: 'EXBRBK.BRST': UC_BLANK);
    wk.FileName = trNameValue(wk.NVP:'FileName');
    if wk.FileName = *blank;
      // Nur für Testphase von Bedeutung!
      wk.FileName = trNameValue(wk.NVP:'FileNameQual');
    endif;
    lcl_ReadInvoice(wk.FileName: wk.NVP);
    // wk.StsED97.DAKY
    if trNameValue(wk.NVP: 'EXBL') > *blank
    and trNameValue(wk.NVP: 'BENR') > *blank
    and trNameValue(wk.NVP: '*Json.Pos') = 'OK';
      wk.StsED97.DAKY = 'done';
      lcl_ED97('BRBK': wk.StsED97: 'EXBL;BENR': wk.NVP);
    else;
      lcl_ED97('BRBK': wk.StsED97: '': wk.NVP);
    endif;
    if trNameValue(wk.NVP: 'EXBRBK.BRST') >= '30';
      // Mark-as-fetched
    ENDIF;

  ENDDO;
  exec sql close MOBBEX_ED97_BRBK;

  wk.FileNameQual = 'MOBBEX-' + %char(%date(): *ISO0) + '-INV';
  trNameValue(wk.NVPlist: '*INIT');
  trNameValue(wk.NVPinv : '*INIT');
  trNameValue(wk.NVP: 'FileNameQual': wk.FileNameQual);
  glb.DoHttpTrace = *ON;

  lcl_Medius('INV': wkBuffer: wk.NVP: wk.NVPlist  );

  // sofern da jetzt Daten zurückkamen, können diese abgerufen werden:
  // Es kommt eine Liste (!) mit urls..
  wk.FileNameGrp = %DEC(%time()) / 100;
  for wk.Seq = 1 to 20;

    wkBuffer = trNameValue(wk.NVPlist: '[' + %char(wk.Seq) + '].url');
    // hinter der url verbirgt sich die "Rechnung":
    if wkbuffer = *blank;
      leave;
    ENDIF;
    // Die Empfangene Datei ggf. sichern!
    // eindeutigen sprechenden Dateinamen
    wk.FileName = wk.FileNameQual
                + '-' + %editc(wk.FileNameGrp: 'X')
                + '-' + %char(wk.Seq) + '.json';
    glb.LogDaky = wk.FileName;

    // Die Daten stehen in lcl_DataRead()
    trNameValue(wk.NVPinv : '*INIT');
    lcl_Medius('URLGET': wkBuffer: wk.NVP: wk.NVPinv   );
    lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));

    if glb.DoIfsFile or 1=1;
      lcl_FileSave(WKResponse: wk.FileName);
    endif;

    trNameValue(wk.NVPinv: '*JsonHandler': 'INVOICE');
    trNameValue(wk.NVPinv: 'EXBRBK.BRST' : UC_BLANK);
    lcl_readJson(WKResponse: wk.NVPinv);
    wk.MediusId = trNameValue(wk.NVPinv: 'MediusId');
    if wk.MediusId <> UC_BLANK;
      wk.FileNameNew = wk.FileName;
      wk.FileNameNew = %scanrpl('.json': '-'+wk.MediusId + '.json': %char(wk.FileName));
      trIfsFileRename(glb.BasePath: wk.FileName: wk.FileNameNew);
    endif;

    // Der "correlationKey" steht erst nach dem parsen des jsons zur Verfügung
    trNameValue(wk.NVP: 'correlationKey': trNameValue(wk.NVPinv: 'correlationKey'));
    wkBuffer = '{"newStatus": "fetched"}';
    lcl_Medius(LC_MarkAsFetched: wkBuffer: wk.NVP: wk.NVPinv   );

    clear wk.StsED97;

    trNameValue(wk.NVPinv: 'InvURL': wkbuffer);
    trNameValue(wk.NVPinv: 'FileName': wk.FileName);
    lcl_ED97('BRBK': wk.StsED97: 'InvURL;FileName': wk.NVPinv);

    if trNameValue(wk.NVPinv: 'EXBL') > *blank
    and trNameValue(wk.NVPinv: 'BENR') > *blank
    and trNameValue(wk.NVPinv: '*Json.Pos') = 'OK';
      wk.StsED97.DAKY = 'done';
      lcl_ED97('BRBK': wk.StsED97: 'InvURL;FileName;EXBL;BENR': wk.NVPinv);
    else;
      wk.StsED97.DAKY = %char(%timestamp());
      lcl_ED97('BRBK': wk.StsED97: 'InvURL;FileName': wk.NVPinv);
    endif;

    if trNameValue(wk.NVPinv: 'EXBRBK.BRST') >= '90'
    and trNameValue(wk.NVPinv: 'correlationKey') >= UC_BLANK;
      // Mark-as-fetched
      trNameValue(wk.NVP: 'correlationKey': trNameValue(wk.NVPinv: 'correlationKey'));
      wkBuffer = '{"newStatus": "processed"}';
      lcl_Medius(LC_MarkAsProcessed: wkBuffer: wk.NVP: wk.NVPinv   );
      if trNameValue(wk.NVPinv: 'Voucher') >= UC_BLANK;
      wkBuffer = '{  "voucher": ';
      wkBuffer += '{';
      wkBuffer += '"voucherValue": "' + trNameValue(wk.NVPinv: 'Voucher') + '"';
      //wkBuffer += ', "voucherDate": "2023-09-13T08:58:26.738Z"';
      wkBuffer += '}';
      wkBuffer += ', "correlationKey": "&CORRKEY" ';
      wkBuffer += '}';
      wkBuffer = %scanrpl(%ucs2('&TEXT'): %ucs2('see trend, BRBK'): wkBuffer);
      wkBuffer = %scanrpl(%ucs2('&CORRKEY'): trNameValue(wk.NVPinv: 'correlationKey'): wkBuffer);
      lcl_Medius(LC_MarkVoucher: wkBuffer: wk.NVP: wk.NVPinv   );

      ENDIF;

    elseif trNameValue(wk.NVPinv: 'EXBRBK.BRST') < '90'
    and trNameValue(wk.NVPinv: 'correlationKey') >= UC_BLANK;
      wkBuffer = '{"errors": [{ "message": "&TEXT" } ], ';
      wkBuffer += '"correlationKey": "&CORRKEY"';
      wkBuffer += '}';
      wkBuffer = %scanrpl(%ucs2('&TEXT'): %ucs2('see trend, BRBK'): wkBuffer);
      wkBuffer = %scanrpl(%ucs2('&CORRKEY'): trNameValue(wk.NVPinv: 'correlationKey'): wkBuffer);
      lcl_Medius(LC_MarkError: wkBuffer: wk.NVP: wk.NVPinv   );

    ENDIF;

  ENDFOR;
  clear  glb.LogDaky;

  return;
END-PROC;
//*****************************************************************************
// Abarbeiten gelesene Rechnung(en)
//*****************************************************************************
dcl-proc lcl_ReadInvoice;
  dcl-pi *n;
    inFileName     varchar(200) value;
    inNVP          likeds(NameValueList_t);
  END-PI;

  dcl-ds wk qualified inz;
    FileName       varchar(200);
    Buffer4K       varucs2(4000);
    OpenId         like(ifsFileHandle_t);
    NVP            likeds(NameValueList_t);
  END-DS;
  dcl-s wkBuffer   varucs2(256000) inz;

  trNameValue(wk.NVP: '*INIT');

  wk.OpenId = trIfsFileOpen(glb.BasePath: inFileName: 'READONLY');
  if wk.OpenId >= *zero;
    dow  trIfsFileRead(wk.OpenId: wk.Buffer4K: %len(wk.Buffer4K: *max)) = NO_ERROR
    and %len(wk.Buffer4K) > *zero;
      wkBuffer += wk.Buffer4K;
      clear wk.Buffer4K;
    enddo;

    trNameValue(wk.NVP: '*JsonHandler': 'INVOICE');
    lcl_readJson(wkBuffer: wk.NVP);
    if trNameValue(inNVP: '*Json.Pos') > %char(%len(wkBuffer) - 10);
      trNameValue(inNVP: '*Json.Pos': 'OK');
    ENDIF;
  else;
    // Datenleiche!
    // -> protokollieren?
  ENDIF;

END-PROC;
//*****************************************************************************
// Erzeugen ExternealId nach festen Schema
//*****************************************************************************
dcl-proc lcl_ExtrernalId;
  // Parameter nicht als "value", um exakte typen zu erzwingen
  dcl-pi *n varchar(50);
    inFile         varchar(10) value;
    inJahr         zoned(4);
    inNMKR         char(6);
  END-PI;

  dcl-s wkExtRefStr varchar(50) inz;

  wkExtRefStr = glb.ExSys + %trim(inFile) + ';' + DAFIRM + ';';
  if inJahr = 2023
  and inFile = 'BBEK'
  and glb.Tenant = 'dometicQA'
  and inNMKR <= '1253';
    // alte Schreibweise...  nur alte Daten im Testsystem
    wkExtRefStr = glb.ExSys + %trim(inFile) + ';';
  ENDIF;

  wkExtRefStr += trRefNrToString(inJahr: inNMKR);
  return wkExtRefStr;
END-PROC;
//*****************************************************************************
dcl-Proc lcl_ED97;
  dcl-pi *n;
    inPGST         char(6) value;
    inED97         likeds(StsED97_t);
    inKeyList      varucs2(100) value;
    inNVP          likeds(NameValueList_t);
  END-PI;

  dcl-ds wk qualified inz;
    idx            int(5);
    pos            int(5);
    LstElem        varucs2(300);
    NewData        like(ED97DATA);
    NewValue       varucs2(200);
    Key            varucs2(50);
    KeyValue       varucs2(250);
    UpdList        varucs2(2000);
    DANA           like(ED97DANA);
    ED97NVP        likeds(NameValueList_t);
  END-DS;

  KYED97FIRM = DAFIRM;
  if inPGST = 'BRBK';
    KYED97DANA = 'BRBK';
    inPGST = 'UPD';
  else;
    KYED97DANA = 'BBEK';
  ENDIF;

  //KYED97DAKY = inED97.ED97DAKY;
  exec sql select ED97ED96, ED97TSTP into :KYED97ED96, :KYED97TSTP
    from ED97
    where ED97FIRM=:DAFIRM and ED97DANA = :KYED97DANA --and ED97DAKY = :KYED97DAKY
     and ED97JAHR = :inED97.JAHR and ED97NMKR = :inED97.NMKR
   fetch first row only;

  if sqlcode <> *zero;
    clear KYED97TSTP;
  ENDIF;

  if inPGST = 'UPD';
    CHIDS = '01CU';
  else;
    CHIDS = '01C';
  endif;

  exsr CHED97;

    ED97FIRM = KYED97FIRM;
    ED97DANA = KYED97DANA;
    if inED97.DAKY > *blank;
      ED97DAKY = inED97.DAKY;
    ENDIF;
    if inED97.JAHR > *zero;
      ED97JAHR = inED97.JAHR;
      ED97NMKR = inED97.NMKR;
    endif;

    clear wk.NewData;
    trNameValue(wk.ED97NVP: '*INIT');
    if %len(inKeyList) > *zero;
      wk.NewData = %trimr(ED97DATA);
      for wk.idx = 1 to 99;
        wk.LstElem = trListElement(wk.NewData: wk.idx);
        wk.pos = %scan(UC_EQUAL: wk.LstElem);
        if wk.pos > 1 and wk.pos < %len(wk.LstElem);
          wk.key = %subst(wk.LstElem: 1: wk.pos-1);
          wk.KeyValue = %subst(wk.LstElem: wk.pos+1);
          trNameValue(wk.ED97NVP: wk.Key: wk.KeyValue);
        ENDIF;
        if %len(wk.NewData) = *zero;
          leave;
        elseif %len(wk.LstElem) <= 0;
          // keine Daten, Vergleich mit Länge/Pos wwürde einen fehler verursachen
        elseif %len(wk.NewData) >= %len(wk.LstElem)
        and %subst(wk.NewData: 1+ %len(wk.NewData) - %len(wk.LstElem)) = wk.LstElem;
          leave;
        ENDIF;
      endfor;
    endif;

    dow %len(inKeyList) > *zero;

      wk.Key = trListLastRemove(inKeyList);
      wk.NewValue = trNameValue(inNVP: wk.key);
      if wk.NewValue > *blank;
        trNameValue(wk.ED97NVP: wk.Key: wk.NewValue);
      ENDIF;
      /if defined(never)
      wk.key += '=';

      for wk.idx = 1 to 99;
        wk.LstElem = trListElement(ED97DATA: wk.idx);

        if %len(wk.LstElem) = *zero
        and %len(wk.Key) > 1;
          // neuen Wert am Ende anhängen
          %len(wk.Key) -= 1;  // "=" abschneiden
          if wk.NewValue > *blank;
            wk.LstElem = wk.Key + '=' + wk.NewValue;
            trListAppend(wk.NewData: wk.LstElem);
          endif;
          leave;

        elseif %len(wk.LstElem) < %len(wk.key)
        or wk.key = ''
        or %subst(wk.LstElem: 1: %len(wk.Key)) <> wk.Key
        or wk.NewValue = *blank;
          // altes Element/Wert übernehmen
          if wk.LstElem > *blank;
          trListAppend(wk.NewData: wk.LstElem);
          endif;

        elseif %len(wk.Key) > 1 and trNameValue(inNVP: wk.key) > *blank;
          // neuen Wert einsetzen
          %len(wk.Key) -= 1;  // "=" abschneiden
          wk.LstElem = wk.Key + '=' + trNameValue(inNVP: wk.key);
          trListAppend(wk.NewData: wk.LstElem);
          clear wk.key;

        else;
          // Default: altes Element/Wert übernehmen
          if wk.LstElem > *blank;
          trListAppend(wk.NewData: wk.LstElem);
          endif;
        ENDIF;
      ENDFOR;

      ED97DATA = wk.NewData;
      clear wk.NewData;
      /endif
    ENDDO;
   //... daten ändern
    if trNameValueCount(wk.ED97NVP) > *zero;
      clear wk.NewData;
      for wk.idx = 1 to trNameValueCount(wk.ED97NVP);
        wk.LstElem = wk.ed97nvp.Elem(wk.idx).Name + '=' + wk.ed97nvp.Elem(wk.idx).Value;
        trListAppend(wk.NewData: wk.LstElem);
      ENDFOR;
      ED97DATA = wk.NewData;
    endif;

    ED97JNAM = DAJNAM;
    ED97PROG = DAPROG;
    ED97BIBL = WKCHPL;
    ED97USER = DAUSER;
    ED97JZEI = %DEC(%TIME());
    ED97JDAT = %DEC(%DATE():*ISO);

    select;

    when INPGST <> PGST_EDIT
    and  INPGST <> 'UPD';
      // - nur lesen

    when INPGST = PGST_MUSTER;
      CHIDS = '01F';
      exsr CHED97;

    when CHI(5) = 'N';
      C_EXTSTP(ED97TSTP);
      ED97ERUS = DAUSER;
      CHIDS = '01W';
      exsr CHED97;
      #CRTCD = 'W';

    when CHI(5) = 'J';
      CHIDS = '01U';
      exsr CHED97;
      #CRTCD = 'U';

    endsl;

    inED97.FIRM = ED97FIRM;
    inED97.JAHR = ED97JAHR;
    inED97.NMKR = ED97NMKR;
    inED97.DAKY = ED97DAKY;
    return;

/copy QCPYSRC,CHED97
END-PROC;
//*****************************************************************************
// Aufbereitung Timestamp im Format: "2023-03-20T08:30:16.748Z"
//*****************************************************************************
dcl-proc lcl_tstp;
  dcl-pi *n varchar(30);
    inTSTP     timestamp value;
  END-PI;
  dcl-s wkTstp varchar(30);

  // wkTstp = '2023-03-20T08:30:16.748Z';
  wkTstp = %char(inTSTP);
  %subst(wkTstp: 11: 1) = 'T';
  %subst(wkTstp: 14: 1) = ':';
  %subst(wkTstp: 17: 1) = ':';
  %subst(wkTstp: 20: 1) = '.';
  %subst(wkTstp: 24) = 'Z';
  return wkTstp;
END-PROC;
//*****************************************************************************
// Medius-Informationen
// Interface aller APIs: http-REST,
// Berechtigung: OAuth2-Protokoll
// siehe: https://success.medius.com
//    /documentation/integration-documentation/technical/rest/authorization/
// Methode: "Client credentials": (Werte für client_id und client_secret !!)
//  POST /customer/connect/token HTTP/1.1
//  Host: login.medius.com
//  Accept: application/json
//  Content-Type: application/x-www-form-urlencoded
//  grant_type=client_credentials&scope=integration&client_id=xxxx&client_secret=xxxxx
// URL für APIs:
// https://cloud.mediusflow.com/dometicQA/api/connect/token
//
// https://api.medius.com/<tenant>/<api specific path>
//*****************************************************************************
// Die Trennung TEST/ECHT (Produktv) erfolgt anscheinen über "ClientId" +"Secret"
//*****************************************************************************
dcl-proc lcl_Medius;
  dcl-pi *n like(WKFENR_t);
    inPGST         char(6) value;
    inBuffer       varucs2(564000) options(*varsize);
    inNVP          likeds(NameValueList_t);
    inResultNVP    likeds(NameValueList_t) options(*nopass);
  END-PI;

  //dcl-c LC_BASEURL const('https://cloud.mediusflow.com/');
  dcl-c LC_BASEURL const('https://cloud.mediusflow.com/');
  //dcl-c LC_TENANT  const('dometicQA');
  dcl-S LC_TENANT  varchar(30) inz('dometicQA');
  dcl-c LC_CT_XML  const('application/xml');
  dcl-c LC_CT_JSON const('application/json');
  dcl-c LC_CT_URL  const('application/x-www-form-urlencoded');

  dcl-ds lcl qualified static inz;
    access_token   varchar(2000);
    debug          char(1);
    TraceFielName  varchar(500);
    MediusLoginDfn char(1);
    ZUBG           char(20);
  END-DS;

  dcl-ds FTPI      ext end-ds;
  dcl-ds KYFTPI    ext end-ds;
  dcl-ds wk qualified inz;
    HttpStatus     int(10) inz;
    Url            varucs2(300);
    RC             int(5);
    pos            int(10);
    Size           int(10);
    TimeOut        int(10) inz(60);
    UserAgent      varchar(50) inz('TrendAccess');
    NVP            likeds(NameValueList_t);
    ContentType    varchar(50);
    LocationId     varchar(500);
    httpMethode    char(4);
    Status         varchar(20);
    BufEBCDICrcv   varchar(1000: 4);
    BufEBCDICsnd   varchar(1000: 4);
  END-DS;
  dcl-s wkFENR     like(WKFENR_t) inz(ERR_INVLDFUKT);
  dcl-s wkFD       int(10) inz; // inhalt ist egal
  dcl-s WKResponse varucs2(355000: 4);

  dcl-ds sqData    qualified inz;
    Body           varucs2(5000: 4);
  END-DS;

  // Medius-ECHT (von Henrik Erikson), May 2025
  if glb.ENVI = 'ECHT';
    LC_TENANT = 'dometic';
  else;
    LC_TENANT = 'dometicQA';
  endif;

  if lcl.MediusLoginDfn <> '1';
  glb.ClientId = 'OhtY3A9JukV1L16MDGUOXIVKiyBOfnOm9ZX2oDlYJ0Y';
  glb.ClientSecret = 'poy0TnIwhx1pV60t1zP0nJtCQJUmtcDvQAn_pYiaRGI';
  // Vorbelegung Zugangsdaten mit Test-Daten (Stand 2024/25)
  glb.ClientId = 'b10b50cdd72e00f2b1a5e45798c25e64';
  glb.ClientSecret = 'zGiXGqSYlP7cEM1ghe079Tnu_IMkVZyL7KP35xmQQf0';
    lcl.MediusLoginDfn = '1';
    clear FTPI;
    clear KYFTPI;
    lcl.ZUBG = 'MEDIUS-' + glb.ENVI;
    KYFTPIFIRM = DAFIRM;
    KYFTPIZUBG = lcl.ZUBG;
    trCallCh('FTPI': '02C': FTPI: KYFTPI);
    if FTPIUEUS > *blank;
    glb.ClientId = %trim(FTPIUEUS);
    glb.ClientSecret = %trim(FTPIUEKW);
    endif;
  endif;

  if glb.DoHttpTrace;
    if lcl.TraceFielName <> trNameValue(inNVP: 'FileNameQual');
      lcl.TraceFielName = trNameValue(inNVP: 'FileNameQual');
      http_debug(*ON: glb.BasePath + lcl.TraceFielName + '-httpTrace.log');
    endif;
  endif;

  http_xproc( HTTP_POINT_ADDL_HEADER: %paddr(lcl_cb_header) );

  wkFENR = NO_ERROR;
  trNameValue(inNVP: 'HttpStatus': uc_Blank);

  dou wk.HttpStatus = -1;

    wk.Url  = LC_BASEURL + glb.Tenant;
    wkFD = 17;   // Darf nicht *zero sein!
    clear sqData.Body;

    if  lcl.access_token = *blank;
      wk.httpMethode = 'POST';
      wkFENR = ERR_INPUTREQUIRED;
      if glb.ENVI = 'ECHT';
      wk.Url = 'https://login.medius.com/dometic' + '/connect/token';
      else;
      wk.Url += '/api/connect/token';
      endif;
      lcl_Auth(wk.Url);
      sqData.Body += 'grant_type=client_credentials';
      sqData.Body += '&scope=Integration';
      sqData.Body = 'grant_type=client_credentials&scope=Integration';
      wk.size = lcl_cb_DataWrite(0: #CKOMM: 0: sqData.Body);
      wk.ContentType = LC_CT_URL;

    elseif inPGST = 'BID';
      wk.httpMethode = 'GET';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      wk.Url += '/api/integration/masterdata/v1/purchaseorderimportbatches';
      wk.Url += '/' + trNameValue(inNVP: 'BatchId');
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = LC_Send;
      wk.httpMethode = 'POST';
      trNameValue(inNVP: 'BatchId': uc_0);
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      //wk.Url += '/integration/masterdata/v1/PurchaseOrderImportBatches';
      wk.Url += '/api/integration/masterdata/v1/purchaseorderimportbatches';
      wk.size = lcl_cb_DataWrite(0: #CKOMM: 0: inBuffer);
      wk.ContentType = LC_CT_JSON;
      //wk.ContentType = LC_CT_URL;    // -> http-status 302

    elseif inPGST = 'INV';
      wk.httpMethode = 'GET';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      // .../message/v1/supplierinvoice/invoices/posted?tag=final&correlationKeyFilter=;;;;;
      wk.Url += '/api/integration/message/v1/supplierinvoice/invoices/posted';
      // Filterangaben über Schlüsselbegriffe in dieser Folge: (6 Stück)
      // PurchasingSystemId;OriginalDocumentType;CompanyId;SupplierId;InvoiceNumber;InvoiceDate;
      //wk.Url += '?tag=final&correlationKeyFilter=;;;;;';
      //wk.Url += '?tag=final&correlationKeyFilter=trend;;;;;;';
      //wk.Url += '?tag=final&correlationKeyFilter=company[DE411];;;;;';    // Schilling!
      wk.Url += '?tag=final&correlationKeyFilter=Trend;ORDER_BASED;;;;';    // Test 22.6.223
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = LC_MarkAsFetched; //'INV-IN';
      // Rückmelden, dass die Daten korrekt empfangen wurden
      // -> Wichtig, um die Daten nicht immer wieder bei PGST='INV', url "../posted"
      //    gelesen werden
      // Dieser Schrit soll erfolgen, wenn die Daten aus der BRBK in die BLKO
      //    übergeben worden sind.
      wk.httpMethode = 'PUT';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      // .../message/v1/supplierinvoice/invoices/posted?tag=final&correlationKeyFilter=;;;;;
      wk.Url += '/api/integration/message/v1/supplierinvoice/invoices/posted';
      wk.Url += '?tag=final';
      //wk.Url += '?tag=preliminary';
      wk.Url += '&correlationKeyFilter=' + trNameValue(inNVP: 'correlationKey');
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = LC_MarkAsProcessed; //'INV-OK';
      wk.httpMethode = 'PUT';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      // .../message/v1/supplierinvoice/invoices/posted?tag=final&correlationKeyFilter=;;;;;
      wk.Url += '/api/integration/message/v1/supplierinvoice/invoices/fetched';
      wk.Url += '?tag=final';
      //wk.Url += '?tag=preliminary';
      wk.Url += '&correlationKeyFilter=' + trNameValue(inNVP: 'correlationKey');
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = LC_MarkError; //'INV-ER';
      wk.httpMethode = 'PUT';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      // .../message/v1/supplierinvoice/invoices/posted?tag=final&correlationKeyFilter=;;;;;
      wk.Url += '/api/integration/message/v1/supplierinvoice/invoices/errors';
      //wk.Url += '?tag=final';
      //wk.Url += '?tag=preliminary';
      //wk.Url += '&correlationKeyFilter=' + trNameValue(inNVP: 'correlationKey');
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = LC_MarkVoucher; //'INV-VO';
      wk.httpMethode = 'PUT';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      // .../message/v1/supplierinvoice/invoices/posted?tag=final&correlationKeyFilter=;;;;;
      wk.Url += '/api/integration/message/v1/supplierinvoice/invoices/vouchers';
      //wk.Url += '?tag=final';
      //wk.Url += '?tag=preliminary';
      //wk.Url += '&correlationKeyFilter=' + trNameValue(inNVP: 'correlationKey');
      wk.ContentType = LC_CT_JSON;

    elseif inPGST = 'URLGET';
      wk.rc = http_setauth(HTTP_AUTH_NONE: glb.ClientId: glb.ClientSecret);
      wk.httpMethode = 'GET';
      wk.Url = inBuffer;
      wk.ContentType = LC_CT_JSON;
    else;
      leave;
    ENDIF;

    clear WKResponse;
    lcl_DataRead('INZ': WKResponse);
    if  wk.httpMethode = 'GET';
    // bei "BID" muss ein http-GET ausgeführt werden!
      wk.HttpStatus = http_url_get_raw(wk.Url:
                wkFD:
                %paddr(lcl_cb_DataRead): wk.TimeOut: wk.UserAgent);
      if wk.HttpStatus = 1;
        wk.HttpStatus = 200;
      ENDIF;

    elseif  wk.httpMethode = 'PUT';
      wk.BufEBCDICsnd = inBuffer;
      clear wk.BufEBCDICrcv;
      // setzt http-Lib version 142 voraus!
      wk.HttpStatus = http_req('PUT': wk.Url:
        *omit: wk.BufEBCDICrcv:
        *omit: wk.BufEBCDICsnd: wk.ContentType);
      WKResponse = wk.BufEBCDICrcv;
      lcl_DataRead('SET': WKResponse: %len(WKResponse));

    else;
    wk.HttpStatus = http_url_post_raw2(wk.Url:
                // %addr(sqData.Body:*data): %len(sqData.Body):
                wkFD: %paddr(lcl_cb_DataWrite): wk.Size:
                wkFD: %paddr(lcl_cb_DataRead): wk.TimeOut: wk.UserAgent: wk.ContentType);
    endif;

    WKFENR = ERR_INVLDINPUT;
    if wk.HttpStatus = 1 and lcl.access_token = *blank;
      wkFENR = '1999';  // "Anmeldung erfolgt"
      // ok...
      // Bei connect/Token jetzt die Antwort auslesen und das Token speichern
      lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));
      trNameValue(wk.NVP: '*INIT');
      lcl_readJson(WKResponse: wk.NVP);
      lcl.access_token = trNameValue(wk.NVP: 'access_token');
      wk.pos = %scan(%ucs2(lcl.access_token): WKResponse);
      lcl.access_token = %subst(WKResponse: wk.pos);
      %len(lcl.access_token) = %scan('"': lcl.access_token);
      %len(lcl.access_token) -= 1;
      glb.Bearer = lcl.access_token;
      if %len(lcl.access_token) > *zero;
        iter;
      ENDIF;

    elseif wk.HttpStatus = -1;
      wkFENR = '8120';  // "Verbindunsgfehler"
      leave;

    elseif wk.HttpStatus >= 200 and wk.HttpStatus <= 299
    or wk.HttpStatus = 1;
      WKFENR = *zero;
      // bei "POST" kommt keine Antwortdaten zurück!
      // lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));
      //     Erwartet wird soetwas:
      // location: https://cloud.mediusflow.com/dometicQA/api/i...es/b3112d0b-3bdd-4753-ae4e-869...
      // Davon sind aber eigentlich nur die letzten Zeichen relevant
      // DOMETIC: hat noch vrm 7.2 - da gibt es kein %scanR()
      if inPGST = lc_SEND;
        wk.LocationId = http_header('location');
        clear wk.pos;
        dou wk.pos = *zero;
          wk.pos = %scan('/': wk.LocationId);
          wk.LocationId = %subst(wk.LocationId: wk.pos+1);
        ENDDO;
        if wk.LocationId > *blank;
          trNameValue(inNVP: 'BatchId': %char(wk.LocationId));
          trNameValue(inNVP: LC_Status: 'Send');
        else;
          trNameValue(inNVP: LC_Status: 'Error');
        endif;
      elseif inPGST = 'BID';
        lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));
        trNameValue(inResultNVP: 'jsonDoArrays': trNameValue(inNVP: 'jsonDoArrays'));
        lcl_readJson(WKResponse: inResultNVP);
      elseif inPGST = 'INV';
        // JSON: Liste auf root-Ebene
        // ... in der Praxis aber noch nicht vorgekommen, nicht getestet
        lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));
        trNameValue(inResultNVP: 'jsonDoArrays':'');
        lcl_readJson(WKResponse: inResultNVP);
      elseif inPGST = 'URLGET';
        // die gelesenen Daten stehen jetzt über lcl_DataRead() zur Verfügung
      elseif inPGST = LC_MarkAsFetched;
        lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));
        lcl_readJson(WKResponse: inResultNVP);
      ENDIF;

    elseif wk.HttpStatus >= 300 and wk.HttpStatus <= 399;
      wkFENR = '8120';  // "Verbindunsgfehler"
      lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));

    elseif wk.HttpStatus >= 400 and wk.HttpStatus <= 499;
      // Ungültige Daten
      // Aber es wurden vermutlich Daten zurückgeliefert!
      wkFENR = '8120';  // "Verbindunsgfehler"
      lcl_DataRead('GET': WKResponse: %len(WKResponse:*max));

    elseif wk.HttpStatus >= 500 and wk.HttpStatus <= 599;
      wkFENR = '8120';  // "Verbindunsgfehler"
      // 500 Internal server error.
      // -> retry later

    else;
      wkFENR = ERR_INVLDINPUT;  // "Verbindunsgfehler"
    ENDIF;

    trNameValue(inNVP: 'HttpStatus': %char(wk.HttpStatus));
    leave;

  enddo;

  return wkFENR;
END-PROC;
//*****************************************************************************
dcl-proc lcl_Auth;
  dcl-pi *n;
    inUrl   varchar(1000) value;
  END-PI;
  dcl-ds wk        qualified inz;
    AuthType       char(1);
    Body           varucs2(200);
    Realm          char(124);
    isBasic        ind;
    isDigest       ind;
    rc             int(5);
  END-DS;

  wk.rc = http_url_get(inUrl: '/trend/test/temp/MOBBEX.CheckAuth.txt');
  wk.rc = http_getauth(wk.isBasic: wk.isDigest: wk.Realm);
  if wk.isBasic = *ON;
    wk.AuthType = HTTP_AUTH_BASIC;
  elseif wk.isDigest = *ON;
    wk.AuthType = HTTP_AUTH_MD5_DIGEST;
  else;
    wk.AuthType = HTTP_AUTH_BASIC;
  ENDIF;
  wk.rc = http_setauth(wk.AuthType: glb.ClientId: glb.ClientSecret);

  wk.Body = 'grant_type=client_credentials';
  wk.Body = '&scope=Integration';

END-PROC;
//*****************************************************************************
//*****************************************************************************
// Diese Funktion sollte nach SXSTRING, trNameValueImport()
dcl-proc lcl_readJson;
  dcl-pi *n;
    inBuffer       varucs2(256000) options(*varsize);
    inNVP          likeds(NameValueList_t);
  END-PI;

  dcl-ds path_t qualified inz;
    Path           varchar(300);
    CurName        varchar(50);
    Index          int(5);
    AppKey         varchar(100);
    GrpName        varchar(50);
    offset         int(10);
    GrpCount       int(5);
    isArray        ind;
    isGroup        ind;
    isIgnore       ind;
  END-DS;
  dcl-ds wk qualified inz;
    CurName        varchar(50);
    CurValue       varucs2(2000);
    Level          int(3);
    TokenLen       int(5);
    Status         char(1);
    PathX          likeds(path_t) dim(20);
    doArrayCount   int(3);
    doArray        varchar(30) dim(10);
    isIgnore       ind;
    HandlerResponse   varchar(32);
  END-DS;
  dcl-s posCur     int(10);
  dcl-s posEnd     int(10);
  dcl-s C1         ucs2(1);

  dcl-s lcl_JsonHandler_ptr pointer(*proc);
  dcl-pr lcl_JsonHandler varchar(32) extproc(lcl_JsonHandler_ptr);
    inPath         varchar(100) options(*varsize);
    inEvent        char(2) value;
    inName         varchar(50) value;
    inData         varucs2(9999) options(*varsize: *nopass);
    inNVP          likeds(NameValueList_t) options(*nopass);
  END-PR;

  PosCur = 1;
  wk.Status = 'N';
  wk.Level = 1;
  wk.CurValue = trNameValue(inNVP: 'jsonDoArrays');
  dow wk.CurValue > *zero;
    wk.doArrayCount += 1;
    wk.doArray(wk.doArrayCount) = trListLastRemove(wk.CurValue);
  ENDDO;

  if  trNameValue(inNVP: '*JsonHandler') = 'INVOICE';
    lcl_JsonHandler_ptr = %paddr(lcl_JsonHandlerInvoice);
    wk.isIgnore = *OFF;
  else;
    lcl_JsonHandler_ptr = %paddr(lcl_JsonHandlerNone);
    wk.isIgnore = *ON;
  endif;

  lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'DS': '');

  dou posCur > %len(inBuffer);
    trNameValue(inNVP: '*Json.Pos': %char(posCur));
    c1 = %subst(inBuffer: posCur: 1);
    select;
    when c1 = lc_JsonListStart;
      wk.Level += 1;
      clear wk.pathx(wk.Level);
      if wk.Level > 1;
        wk.PathX(wk.Level) = wk.PathX(wk.Level -1);
      ENDIF;
      if %len(wk.PathX(wk.Level -1).CurName) > *zero;
        wk.PathX(wk.Level).Path += wk.PathX(wk.Level -1).CurName;
      wk.PathX(wk.Level).GrpName = wk.PathX(wk.Level -1).CurName;
      endif;
      wk.PathX(wk.Level).CurName = lc_JsonListStart + '1' + lc_JsonListEnd;
      wk.PathX(wk.Level).Index   = 1;
      wk.PathX(wk.Level).isArray = *ON;
      wk.PathX(wk.Level).isGroup = *OFF;
      wk.PathX(wk.Level).offset = posCur;
      wk.PathX(wk.Level).GrpCount =*zero;
      wk.Status = 'N';
      lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'LS': wk.PathX(wk.Level-1).CurName);

    when c1 = lc_JsonListEnd;     // ignorieren
      if wk.PathX(wk.Level).GrpCount = *zero;
        wk.TokenLen = (posCur - wk.PathX(wk.Level).offset) -1;
        wk.CurValue = %subst(inBuffer: wk.PathX(wk.Level).offset +1: wk.TokenLen);
      else;
        clear wk.CurValue;
      endif;
      clear wk.pathx(wk.Level);
      wk.Level -= 1;
      lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'LE': wk.PathX(wk.Level).CurName: wk.CurValue);
      wk.PathX(wk.Level).CurName = '';


    when c1 = UC_COLON;           // Doppelpunkt -> Wert
      wk.Status = 'V';
      // falls dann kein " (UC_QUOT) kommt, ist das ein Wert

    when c1 = lc_JsonGroupStart;
      wk.PathX(wk.Level).GrpCount  += 1;
      // aktueller Name ist Strukturename
      wk.Level += 1;
      clear wk.pathx(wk.Level);
      if wk.Level > 1;
        wk.PathX(wk.Level)    = wk.PathX(wk.Level -1);
      ENDIF;
      wk.PathX(wk.Level).Index   = *zero;
      wk.PathX(wk.Level).isArray = *OFF;
      wk.PathX(wk.Level).isGroup = *ON;
      if %len(wk.PathX(wk.Level -1).CurName) > *zero;
        wk.PathX(wk.Level).GrpName = wk.PathX(wk.Level -1).CurName;
        wk.PathX(wk.Level).Path += wk.PathX(wk.Level -1).CurName + '.';
      endif;
      clear wk.PathX(wk.Level).CurName;
      wk.Status = 'N';
      lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'GS': wk.PathX(wk.Level).GrpName);

    when c1 = lc_JsonGroupEnd and wk.Status = 'V'
    and not wk.PathX(wk.Level).isIgnore;
      // Achtung! Das letzte Element/Wert muss noch mit dem aktuellen
      // Zustand verarbeitet werden!
      wk.Status = 'X';
      posCur -=1;     // dann nochmal!

    when c1 = lc_JsonGroupEnd;
      lcl_JsonHandler( wk.PathX(wk.Level).AppKey: 'GE': wk.PathX(wk.Level).GrpName);
      clear wk.pathx(wk.Level);
      wk.Level -= 1;
      clear wk.PathX(wk.Level).CurName;

    when c1 = lc_JsonDelimiter;
      if wk.PathX(wk.Level).GrpCount = *zero;
        // Werteliste? wie zum Beispiel: [1, 2, 3, 4]
        // -> Trennzeichen ingorieren!
        // .. die ganze Werteliste ist dann der Element-Wert
        wk.CurValue += C1;
      ENDIF;
      if not wk.PathX(wk.Level).isIgnore;
        wk.Status = 'X';
      else;
        clear wk.Status;
      endif;

      if wk.Level >= 1
      and wk.PathX(wk.Level).isArray;
        if wk.PathX(wk.Level).isGroup;
        lcl_JsonHandler( wk.PathX(wk.Level).AppKey: 'GR': wk.PathX(wk.Level).CurName);
        endif;
        clear wk.Status;
        wk.PathX(wk.Level).Index += 1;
        wk.PathX(wk.Level).CurName = lc_JsonListStart + %char(wk.PathX(wk.Level).Index)
             + lc_JsonListEnd;
        if wk.isIgnore = *OFF;
          // alle Mehrfachelemente zulassemn
        elseif wk.Level >= 2
        and %lookup(wk.PathX(wk.Level-1).CurName: wk.doArray) > *zero;
          // Mehrfache elemente zulassen
        else;
          // Achtung: Dieses Element noch verarbeiten! isIgnore zählt erst ab jetzt!
          wk.PathX(wk.Level).isIgnore = *ON;
        ENDIF;
      ENDIF;

    when c1 <= UC_BLANK;
      // ignorieren
      // Das sind Zeilenumbrüche, Tabs usw.
      // Diese dürfen (!!) innerhalb von Strings (QUOTs!) vorkommen

    when c1 = UC_QUOT;
      // -> weitersuchen bis ende
      dou posCur >= %len(inBuffer);
        posEnd = %scan(UC_QUOT: inBuffer: posCur +1);
        if %subst(inBuffer: posEnd+1: 1) = UC_QUOT;
          // Doppeltes Hochkomma->Maskierung!
          posCur = posEnd +1;
          iter;
        elseif posEnd = *zero;
          leave;  // darf nicht sein -> Fehler!
        endif;
        wk.TokenLen = (posEnd - PosCur) -1;
        if wk.Status = 'N';
          wk.Pathx(wk.Level).CurName = %subst(inBuffer: posCur +1: wk.TokenLen);
          clear wk.Status;
        elseif wk.PathX(wk.Level).isIgnore = *ON;
          // Wert ignorieren
        elseif wk.Status = 'V';
          wk.CurValue = %subst(inBuffer: posCur +1: wk.TokenLen);
          wk.Status = 'X';
          //lcl_JsonHandlerInvoice(wk.PathX(wk.Level).AppKey: 'NV': wk.PathX(wk.Level).CurName:
          //  wk.CurValue);
        ENDIF;
        PosCur = PosEnd;
        leave;
      enddo;

    when wk.Status = 'V';
      wk.CurValue += C1;
    ENDSL;

    if wk.Status = 'X'; // irgendein Ende erreicht, letztes Token ist CurValue
      if wk.PathX(wk.Level).CurName = *blank
      or wk.PathX(wk.Level).isArray;
        /// --
      elseif wk.PathX(wk.Level).CurName > *blank;
        wk.CurName = wk.PathX(wk.level).Path;
        wk.CurName += wk.PathX(wk.Level).CurName;
        wk.HandlerResponse =
        lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'NV': wk.PathX(wk.Level).CurName:
           wk.CurValue);
        if wk.HandlerResponse = '*';
          trNameValue(inNVP: wk.CurName: wk.CurValue);
        elseif wk.HandlerResponse = 'NV';
          trNameValue(inNVP: wk.PathX(wk.Level).CurName: wk.CurValue);
        elseif wk.HandlerResponse > *blank;
          trNameValue(inNVP: wk.HandlerResponse: wk.CurValue);
        ENDIF;
        clear wk.CurName;
      endif;
      clear wk.PathX(wk.Level).CurName;
      clear wk.CurValue;
      clear wk.Status;
      wk.Status = 'N';
    ENDIF;
    posCur +=1;
  ENDDO;

  clear wk.CurValue;
  lcl_JsonHandler(wk.PathX(wk.Level).AppKey: 'DE': '': wk.CurValue: inNVP);
  trNameValue(inNVP: '*Json.Pos': %char(posCur));
  trNameValue(inNVP: '*Json.Pos': 'OK');


END-PROC;
//*****************************************************************************
// Procedure name: lcl_jsonElem
// Purpose:        Erzeugen einfaches (!) json-Element der Form "name":wert
// Returns:        -
// Parameter:      Datenbuffer
// Parameter:      Element-Name
// Parameter:      Element-Wert (wird nicht maskiert!)
//*****************************************************************************
dcl-proc lcl_jsonElem;
  dcl-pi *n varucs2(1100);
    inElemName     varchar(50) value;
    inData         varucs2(1000) value;
    inNum          zoned(17: 2) value options(*nopass);
  END-PI;
  dcl-s WkRetStr  varucs2(100);

  if %parms >= %parmnum(inNum);
    WkRetStr = '"' + inElemName +'":' + trCharISO(inNum: 2);
  elseif inData = lc_JsonGroupStart
  or     inData = lc_JsonListStart;
    WkRetStr = '"' + inElemName +'":' + inData;
  elseif inData = 'false' or inData='true';
    WkRetStr = '"' + inElemName +'": ' + %trimr(inData) + ' ';
  else;
    // wk.pos = %scan(uc_QUOT: inData);
    inData = %scanrpl(UC_BACKSLASH: UC_BACKSLASH + UC_BACKSLASH: inData);
    inData = %scanrpl(UC_QUOT: UC_BACKSLASH + UC_QUOT: inData);

    WkRetStr = '"' + inElemName +'":"' + %trimr(inData) + '"';
  ENDIF;

  return WkRetStr;

END-PROC;
//*****************************************************************************
// Procedure name: lcl_cb_header
// Purpose:        call-back, um zusätzliche header-Felder zu setzen
// Returns:        -
// Parameter:      header-String: (Rückgabewert)
// Parameter:      userData (poiner): micht verwendet
// ACHTUNG: Das Interface ist durch das http-API definiert und darf NICHT geändert werden!
//*****************************************************************************
dcl-proc lcl_cb_header;
  dcl-pi *n;
    inHeader       varchar(8024);
    inUserData     pointer  value;
  END-PI;

  // Jedes Header-Element MUSS mit CRLF (in EBCDIC) abgeschlossen sein!
  inHeader = 'Accept: ' + 'application/json' + x'0d25';
  //inHeader = 'Scope: ' + 'Integration' + x'0d25';
  if glb.Bearer > *blank;
    inHeader += 'Bearer: ' + glb.Bearer + x'0d25';
    inHeader += 'Authorization: Bearer ' + glb.Bearer + x'0d25';
  ENDIF;

END-PROC;
//*****************************************************************************
// Procedure name: lcl_cb_DataWrite
// Purpose:        call-back, um sendedaten binär (!) zur Verfügung zu stellen
// Returns:        Anzahl bereitgestelten Bytes (! nicht Zeichen! utf-8!)
// Parameter:      FD (FileDescriptor, Integer): ID (hier fix)
// Parameter:      Data: Rückgabestring (max 8192 Bytes)
// Parameter:      Data-Länge: angeforderte Länge
// ACHTUNG: Das Interface ist durch das http-API definiert und darf NICHT geändert werden!
//*****************************************************************************
dcl-proc lcl_cb_DataWrite;
  dcl-pi *n        int(10);
    inFD           int(10) value;
    inData         char(8192) options(*varsize);
    inDataLen      int(10) value;
    inOutStr       varucs2(564000) options(*varsize);
  END-PI;

  dcl-s wkRetLen   int(10) inz;
  dcl-ds wkOutBuf  qualified static inz;
    len            int(10) pos(1);
    strUtf8        varchar(564000) ccsid(1208) pos(1);
    strBinary      varchar(564000) pos(1);
  END-DS;

  if %parms >= %parmnum(inOutStr);
    // mit %len() auf die CCSID(1208)-Variabel wird tatsächlcih die Länge in Bytes
    // zurückgeliefert, nicht die Zeichen!
    // ein Umlaut (also ein Zeichen mit zwei Bytes) liefert also eben 2 (Bytes)
    wkOutBuf.strUtf8 = inOutStr;
    wkOutBuf.strUtf8 += x'00';
    wkOutBuf.len = %scan(x'00': wkOutBuf.strBinary) -1;
    return wkOutBuf.len;
  ENDIF;

  if wkOutBuf.len <= *zero;
    wkRetLen = *zero;
  elseif inDataLen < wkOutBuf.len;
    inData = %subst(wkOutBuf.strBinary: 1: inDataLen);
    wkRetLen = inDataLen;
  else;
    inData = %subst(wkOutBuf.strBinary: 1: wkOutBuf.len);
    wkRetLen = wkOutBuf.len;
  ENDIF;

  if wkOutBuf.len > wkRetLen;
    wkOutBuf.strBinary = %subst(wkOutBuf.strBinary: wkRetLen +1);
  else;
    clear wkOutBuf.strBinary;
  ENDIF;

  return wkRetLen;
END-PROC;
//*****************************************************************************
// Procedure name: lcl_cb_DataRead
// Purpose:        call-back, um empfangene Daten ins RPG zu bekommen
// Returns:        Anzahl verarbeiter Zeichen. Sollte/muss übergebener Länge entsprechen
// Parameter:      FD (FileDescriptor, Integer): nicht verwendet
// Parameter:      Data-Pointer: Pointer auf Daten
// Parameter:      Data-Länge: Datenlänge (in Zeichen/Bytes)
// ACHTUNG: Das Interface ist durch das http-API definiert und darf NICHT geändert werden!
//*****************************************************************************
dcl-proc lcl_cb_DataRead;
  dcl-pi *n        int(10);
    inFD           int(10) value;
    inDataPtr      pointer value;
    inDataLen      int(10) value;
  END-PI;
  dcl-s wkData     char(65000) ccsid(1208) based(wkData_ptr);
  dcl-s wkString   varucs2(32000: 4);
  wkData_ptr = inDataPtr;
  // Daten beinhalten ggf. Zeilenumbrüche x'0D0A'
  wkString = %subst(WkData: 1: inDataLen);
  lcl_DataRead('ADD': wkString);
  return inDataLen;
END-PROC;
//*****************************************************************************
// Procedure name: lcl_DataRead
// Purpose:        Hilfsfunktion als Setter/Getter für Antwortdaten von http-Aufrufen
// Returns:        Anzahl verarbeiter Zeichen
// Parameter:      OpCode: SET, INZ, ADD, GET
// Parameter:      Buffer (varucs2)
// Parameter:      Datenlänge (in Zeichen)
//*****************************************************************************
dcl-proc lcl_DataRead;
  dcl-pi *n        int(10);
    inOpCode       char(6) value;
    inBuffer       varucs2(532000) options(*varsize);
    inLen          int(10) value options(*nopass);
  END-PI;
  dcl-s wkBuffer   varucs2(364000) static;
  dcl-s wkLeer     varucs2(1) inz;
  select;
  when inOpcode = 'ADD';
    // CRLF wird automatisch entfernt
    wkBuffer += %scanrpl(u'000D000A': wkLeer: inBuffer);
    if %len(wkbuffer) + %len(inBuffer) >= %len(wkBuffer: *max);
      logDefault('WARN': '1': 'MOBBEX': 'ADD': glb.LogDaky: '': 'size limit');
    ENDIF;

  when inOpcode = 'INZ';
    clear wkBuffer;

  when inOpcode = 'SET';
    wkBuffer = inBuffer;

  when inOpcode = 'GET';
    if inLen > %len(wkBuffer);
      inBuffer = wkBuffer;
    else;
      %len(inBuffer) = inLen;
      %subst(inBuffer: 1: inLen) = wkBuffer;
      logDefault('WARN': '1': 'MOBBEX': 'GET': glb.LogDaky: '': 'size limit');
    endif;
  endsl;
  return *zero;
END-PROC;
//*****************************************************************************
dcl-proc lcl_FileSave;
  dcl-pi *n;
    inBuffer       varucs2(999000) options(*varsize);
    inFileName     varchar(300) value;
  END-PI;

  dcl-ds wk qualified inz;
    OpenId         like(ifsFileHandle_t);
    Pos            int(10);
    Buff4K         varucs2(4000);
  END-DS;

    wk.OpenId = trIfsFileOpen(glb.BasePath: inFileName: 'UTF8 REPLACE');
    wk.pos = 1;
    if wk.OpenId >= *zero;
      dow wk.pos < %len(inBuffer);
        if wk.pos + 4000 > %len(inBuffer);
          wk.buff4k = %subst(inBuffer: wk.pos);
          leave;
        endif;
        wk.buff4k = %subst(inBuffer: wk.pos: 4000);
        wk.pos += %len(wk.buff4k);
        trIfsFileWrite(wk.OpenId: wk.buff4k);
        clear wk.buff4k;
      ENDDO;
      trIfsFileWrite(wk.OpenId: wk.buff4k);
    ENDIF;
    trIfsFileClose(wk.OpenId);

END-PROC;
//*****************************************************************************
dcl-proc lcl_logErrors;
  dcl-pi *n;
    inOPCD         char(6) value;
    inNVP          likeds(NameValueList_t) options(*nopass);
  END-PI;
  dcl-ds Entry_t   qualified template;
    Tag            varucs2(10);
    Msg            varucs2(100);
    anz            int(10);
    SystemId       varucs2(50);
  END-DS;
  dcl-ds lcl qualified static inz;
    count          int(5);
    Entry          likeds(Entry_t) dim(200);
  END-DS;
  dcl-ds wk qualified inz;
    idx            int(5);
    MaxEId         int(5);
    EId            int(5);
    Prefix         varchar(10);
    Entry          likeds(Entry_t);
  END-DS;
  dcl-s wkBuffer   varucs2(150000) static inz;
  if inOPCD = 'INZ';
    lcl.count = 1;
    clear lcl.Entry(1);
    clear wkBuffer;
    wkBuffer = lc_JsonGroupStart;
    wkBuffer += lcl_jsonElem('tstp': %char(%date()));
    wkBuffer += lc_JsonDelimiter;
    wkBuffer += lcl_jsonElem('errors': lc_JsonListStart);
  elseif inOPCD = 'BID';
    // Zu einer Fehlernachricht gehören immer drei Einträge
    wk.MaxEId = %div(inNVP.ElemCount: 3);
    for wk.idx = 1 to wk.MaxEId;
      // 46= Lieferant nicht gefunden
      // 91= CodingLines.Dimensions.Dimension1 nicht gefunden (331000=Konto)
       wk.Prefix = 'errors[' + %char(wk.idx) + '].';
       wk.Entry.Tag = trNameValue(inNVP: wk.Prefix + 'validationTag');
       wk.Entry.Msg = trNameValue(inNVP: wk.Prefix + 'validationMessage');
       wk.Entry.SystemId = trNameValue(inNVP: wk.Prefix + 'externalSystemId');
       if wk.Entry.Tag <> UC_BLANK
       and wk.Entry.Msg = UC_BLANK;
         wkBuffer += trNameValueExport(inNVP: 'JSON');
         wkBuffer += lc_JsonDelimiter  + u'000D000A';
       ENDIF;
       wk.Eid = %lookup(wk.Entry.Msg: lcl.Entry(*).Msg: 1: lcl.count);
       if wk.Eid > *zero;
         lcl.Entry(wk.EId).anz += 1;
       elseif lcl.Count < %elem(lcl.Entry);
         lcl.Count += 1;
         lcl.Entry(lcl.Count) = wk.Entry;
         lcl.Entry(lcl.Count).anz = 1;
       ENDIF;
    ENDFOR;
  elseif inOPCD='NVP';
    wkBuffer += trNameValueExport(inNVP: 'JSON');
    wkBuffer += lc_JsonDelimiter  + u'000D000A';
  elseif inOPCD='WRITE' and lcl.count > 1;
    if %len(wkBuffer) > *zero;
      wkBuffer += lcl_jsonElem('ende': %char(%date()));
      wkBuffer += lc_JsonListEnd;
      wkBuffer += lc_JsonGroupEnd;
      lcl_FileSave(wkBuffer: 'ErrLog-' + %char(%date(): *ISO) + 'undefined.json');
    endif;
    clear wkBuffer;
    for wk.idx = 1 to lcl.count;
      wkBuffer += %char(lcl.Entry(wk.idx).anz) + uc_Semicolon
                + uc_blank + lcl.Entry(wk.idx).Tag + uc_Semicolon
                + UC_QUOT + lcl.Entry(wk.idx).Msg + UC_QUOT + uc_Semicolon
                + UC_QUOT + lcl.Entry(wk.idx).SystemId + UC_QUOT + u'000D000A';
    ENDFOR;
    lcl_FileSave(wkBuffer: 'ErrLog-' + %char(%date(): *ISO) + '.csv');
  ENDIF;
END-PROC;
//*****************************************************************************
dcl-proc lcl_AtrListToNVP;
  dcl-pi *n        int(10);
    inBuffer       varucs2(4000) options(*varsize);
    inNVP          likeds(NameValueList_t);
  end-pi;

  dcl-ds wk qualified inz;
    Count          int(5);
    str            int(5);
    ende           int(5);
    pos            int(5);
    len            int(5);
    Name           varchar(50);
    Value          varucs2(250);
  end-ds;

  dow %len(inBuffer) > wk.Str +1;
    wk.str += 1;
    clear wk.Name;
    clear wk.Value;
    wk.pos = %scan(UC_EQUAL: inBuffer: wk.Str);
    if wk.Pos = *zero;
      leave;
    ENDIF;
    wk.len = (wk.pos - wk.str);
    wk.Name = %subst(inBuffer: wk.Str: wk.len);
    wk.Str = wk.pos +1;

    if wk.Str > %len(inBuffer);
      leave;
    ENDIF;

    wk.pos = wk.str;
    dow %subst(inBuffer: wk.pos: 1) = UC_QUOT;
      wk.len = %scan(UC_QUOT+UC_QUOT: inBuffer: wk.pos +1);
      if wk.len = *zero;
        leave;
      ENDIF;
      wk.pos = wk.len +2;
    ENDDO;

    wk.Ende = %scan(UC_SEMICOLON: inBuffer: wk.pos);
    if wk.Ende = *zero;
      // kein weiteres Element!
      wk.Ende = %len(inBuffer) +1;
    ENDIF;

    wk.len = (wk.Ende - wk.Str);
    wk.Value = %subst(inBuffer: wk.Str: wk.Len);
    if wk.Len > *zero and %subst(wk.Value: 1: 1) = UC_QUOT;
      wk.Value = %subst(wk.Value: 2);
      %len(wk.Value) -= 1;
    ENDIF;

    wk.Count += 1;
    trNameValue(inNVP: wk.Name: wk.Value);
    wk.Str = wk.Ende;
  ENDDO;

  return wk.Count;
END-PROC;
//*****************************************************************************
// Hier wird das JSON on-the-fly verarbeitet
// Die Elemente+Pfade sind zu lang/zu groß für NVPs
// Parallel dazu werden die Daten als XML erzeugt - das ist technisch nicht erforderloich
// darüber kann aber getestet/sichergestellt werden, dass die Logik vollständig ist,
// und nicht irgendein Element vergessen wird bzw. die Struktur falsch erkannt wird.
dcl-proc lcl_JsonHandlerNone;
  dcl-pi *n varchar(32);
    inPath         varchar(100) options(*varsize);
    inEvent        char(2) value;
    inName         varchar(50) value;
    inData         varucs2(9999) options(*varsize: *nopass);
  END-PI;
  return '*';
  return inEvent;
end-proc;
//*****************************************************************************
// Es kommen je Rechnung 5 Listen:
// 1: <invoiceLines> Liste der Rechnungspositionen
// 2: codingLines    (Summen-)Liste nach codingLines (Kostenstellen/Konten)
// 3: <taxLines>     Liste der Steuern  ==> BRBK-Satz!
// 4: <poLines>      Liste der Bestellpositionen
// 5: <poConnectionLines>    Liste der Wareneingänge
// Diese beziehen sich zum Teil aufeinander - und müssen daher als Array vorgehalten werden.
//*****************************************************************************
dcl-proc lcl_JsonHandlerInvoice;
  dcl-pi *n varchar(32);
    inPath         varchar(100) options(*varsize);
    inEvent        char(2) value;
    inName         varchar(50) value;
    inData         varucs2(9999) options(*varsize: *nopass);
    inNVP          likeds(NameValueList_t) options(*nopass);
  END-PI;
  dcl-ds InvoicLine_t  qualified template;
    InvLineNbr     varchar(10);
    amount         zoned(15: 5);
    UnitPrice      zoned(15: 5);
    quantity       zoned(15: 5);
  END-DS;
  dcl-ds poLine_t  qualified template;
    POLineNumber   varucs2(10);
    TENR           like(EXBRBP.TENR);
    GLMG           like(EXBRBP.GLMG);
    PREI           like(EXBRBP.PREI);
    BEJJ           like(EXBRBP.BEJJ);
    BENR           like(EXBRBP.BENR);
    BEPO           like(EXBRBP.BEPO);
    //-
    BRST           like(EXBRBP.BRST);
    MEIN           like(EXBRBP.MEIN);
    MEPR           like(EXBRBP.MEPR);
    PDIM           like(EXBRBP.PDIM);
    PRAR           like(EXBRBP.PRAR);
    WACD           like(EXBRBP.WACD);
    MWCD           like(EXBRBP.MWCD);
    BLPO           like(EXBRBP.BLPO);
  END-DS;
  dcl-ds CodingLine_t qualified template;
    TaxLineNbr     char(6);
    InvLineNbr     char(6);
    // je "CodingLine" immer auch schon ein "TaxLine" anlegen.
    // Dies ist dann das Template für weitere TaxLine's
    codingLineNumber varchar(10);
    CodingLineTag  varucs2(20);
    CodingLineAmount zoned(15: 5);
    dimension      varchar(40);  // --> wird zu "Konto"
    taxIndicator1  varchar(20);
    poConnectionLineNumbers varchar(20);
    amount         zoned(15: 5);
    // Aus TaxLine:
    TaxLineAmount  zoned(15: 5);
    netAmount      zoned(15: 5);
    grossAmount    varchar(20);
    percentage     varchar(10);
    TaxCode        varchar(10);
    MWCD           char(2);   // Trend-Code
  END-DS;
  dcl-ds poConnectionLine_t qualified template;
    connectedAmount    zoned(21: 5);
    connectedQuantity  zoned(21: 5);
    deliveredQuantity  zoned(21: 5);
    deliveredAmount    zoned(21: 5);
    deliveredUnitPrice zoned(21: 5);
    InvLineNbr     varchar(10);
  END-DS;
  dcl-ds lcl qualified inz static;
    str            varucs2(154000);
    isAttr         ind;
    pending        varucs2(20);
    // Daten aus dem json-Dokument:
    correlationKey varucs2(100);
    poLineCount    uns(5);
    poLine         likeds(poLine_t) dim(1000);
    // Jede "ConnectionLines" gehört zu genau einer "InvoiceLine"
    // - je InvoiceLine kann es mehrere CodingLines geben
    // - je InvoiceLine kann es mehrere poConnectionLines geben
    // - jede "CodingLines" gehört zu exakt einer "InvoiceLine"
    // jede "TaxLines"  gehört zu exakt einer "CodingLine"
    // ...aber: es kann meherere TaxLines für eine CodingLine geben
    // Aber: Zu einer Invoice-Line kann es n*m Coding/Tax_lines geben!
    // -> "TaxLines" durch-iterieren um je Position alle passenden Steuersätze zu finden
    InvoiceLineCount  uns(5);
    InvoiceLine    likeds(InvoicLine_t) dim(500);
    CodingLineCount   uns(5);
    CodingLine     likeds(CodingLine_t) dim(500);
    CurTaxLine     likeds(CodingLine_t);
    CurPoConnLine  likeds(poConnectionLine_t);
    //CurCodingLineTag    varucs2(20);
    //CurCodingLineAmount zoned(15: 5);
    ConnectionLineCount uns(5);
    ConnectionLevel   varucs2(20);
    InvoiceLineNumber varucs2(20);
    CodingLineNumbers varucs2(20);
  END-DS;
  dcl-ds wk qualified inz;
    DataStr        varucs2(200);
    pos            uns(10);
    poLineIdx      uns(5);
    MWStSatz       zoned(11: 5);
    HandlerResponse varchar(32);
    Faktor         zoned(24: 3);
    Konto          char(6);
  END-DS;
  dcl-ds EXBRBK    likeds(EXBRBK_t) static inz;
  dcl-ds EXBRBP    likeds(EXBRBP_t) static inz;
  dcl-s  WKFENR    like(WKFENR_t) inz;
  dcl-s  I1        INT(5);

  // zuerst der generische Teil:
  // Bauen der Daten als XML
  // (über dieses könnte am Ende auch via SQL die BRBK/BRBP-Sätze "gelesen" werden)
  wk.HandlerResponse = inEvent;
  if inEvent = 'NV';
    if lcl.isAttr = *ON;
      lcl.Str += ' ' + inName + '="' + inData + '"';
    else;
      lcl.Str += '<' + inName + '>' + inData + '</' + inName + '>';
      clear lcl.pending;
    ENDIF;
  else;
    lcl.Str += lcl.pending;
    clear lcl.pending;
  ENDIF;

  select;
  when inEvent = 'GE';
    if inName = *blank;
      lcl.Str += '</NN>';
    elseif %subst(inName: 1: 1) = lc_JsonListStart;
      lcl.Str += '</LI>';
    else;
      lcl.Str += '</' + inName + '>';
    endif;
    lcl.isAttr = *OFF;
  when inEvent = 'GS';
    lcl.isAttr = *ON;
    lcl.pending = UC_GT;
    if inName = *blank;
      lcl.Str += '<NN';
    elseif %subst(inName: 1: 1) = lc_JsonListStart;
      // in diesem Fall grundsätzlich keine
      // Werte in form von Attributen erzeugen, sondern immer als Elemente
      lcl.Str += '<LI seq="' + %subst(inName: 2);
      %len(lcl.Str) -= 1;
      lcl.Str += '">';
      lcl.isAttr = *OFF;
      clear lcl.pending;
      inPath += '/LI';
    else;
      inPath += '/' + inName;
      lcl.Str += '<' + inName;
    endif;
  when inEvent = 'GR';  // gleiche Gruppe nochmal (also: Liste von Gruppen)
    lcl.isAttr = *ON;
    if inName > *blank;
      lcl.Str += '</' + inName + '><' + inName;
    else;
      lcl.Str += '</NN><NN';
    endif;
    lcl.pending = UC_GT;
  when inEvent = 'LS';
    if inName > *blank;
      lcl.isAttr = *OFF;
      lcl.Str += '<' + inName + '>';
      inPath += '/' + inName;
    endif;
  when inEvent = 'LE';
    if inName > *blank;
      lcl.Str += '</' + inName + '>';
    endif;
    lcl.isAttr = *OFF;
  when inEvent = 'DS';
    inPath = 'root';
    lcl.Str = '<root';
    lcl.isAttr = *ON;
    lcl.pending = UC_GT;
  when inEvent = 'DE';
    lcl.Str += '</root>';
    lcl_FileSave(lcl.Str: 'InvoiceHandler.xml');
    if %parms >= %parmnum(inNVP);
    trNameValue(inNVP: 'MediusId': EXBRBK.BLID);
    endif;
  ENDSL;

  //------------------
  // jetzt die BRBK/BRBP-Felder bestücken:
  // unbenannte Knoten, die für die XML-Generierung "NN" benannt werden
  // sind NICHT Teil der Variable "inPath"
  // offen: BRBK.MWC1 / MWB1      aus json: "percentage": 0.0,
  //        WKNR
  //        VCKZ ??
  //        FENR  (sollte defaultmäßig "0000" sein)
  select;
  when inEvent = 'GS';
    if inName = 'invoice';
      clear EXBRBK;
      EXBRBK.UGDA = %dec(%date(): *ISO);
      EXBRBK.BRST = '10';   // Briefkastenstatus
      EXBRBK.BLJJ = *YEAR;
      EXBRBK.BLGA = '100';  // Belegart  100=Eingangsrechnung
      EXBRBK.FENR = NO_ERROR;
      clear EXBRBP;
      clear lcl.InvoiceLineCount;
      clear lcl.poLineCount;
      clear lcl.CodingLineCount;
      clear lcl.ConnectionLineCount;
      clear lcl.invoiceLineNumber;

    elseif inPath = 'root/invoice/invoiceLines/LI';
      lcl.InvoiceLineCount += 1;
      clear lcl.InvoiceLine(lcl.InvoiceLineCount);

    elseif inPath = 'root/invoice/codingLines/LI';
      lcl.CodingLineCount += 1;
      clear lcl.CodingLine(lcl.CodingLineCount);
      clear lcl.invoiceLineNumber;

    elseif inPath = 'root/invoice/taxLines/LI';
      clear lcl.CurTaxLine;
      clear lcl.invoiceLineNumber;

    elseif inPath = 'root/invoice/poLines/LI';
      lcl.poLineCount += 1;
      clear EXBRBP;
      // Initialwerte/Defaults... müssen bei poConnectionLines gesetzt sein!
      EXBRBP.BRST = '10';  // Briefkastenstatus
      EXBRBP.MEIN = 'S';
      EXBRBP.MEPR = 'S';   // ggf. via "conversionFactor"
      EXBRBP.PDIM = '1';
      EXBRBP.PRAR = 'LK1'; // Preisart wie "LP1", "PKG"... aus TRTP-KOLS (-> LK1)
      EXBRBP.PRAR = 'LP1'; // nach RS mit J.Kübler
      EXBRBP.WACD = EXBRBK.WACD;
      EXBRBP.MWCD = '  ';  // MWSt-Code..."taxIndicator" passt von der Codierung aber nicht
      EXBRBP.BLPO = *ZERO;
      EXBRBP.FENR = NO_ERROR;

    elseif inPath = 'root/invoice/poConnectionLines/LI';
      lcl.ConnectionLineCount += 1;
      clear lcl.connectionLevel;
      clear lcl.invoiceLineNumber;
      clear lcl.CurPoConnLine;
      clear EXBRBP;
    ENDIF;

  when inEvent = 'GE'
  or   inEvent = 'GR';
    // hier das Schreiben der Daten in die Dateien
    if glb.ENVI <> 'TEST' and 1=0;
      // keine Daten schreiben! Test-Phase!!!
    elseif inName = 'invoice';
      lcl_BRBK(EXBRBK);

    elseif inPath = 'root/invoice/taxLines/LI';
      wk.MWSTSATZ = trDec(lcl.CurTaxLine.percentage);
      //lcl.CurTaxLine.MWCD = l_GetMWStCode(wk.MWSTSATZ: EXBRBK.UGDA: lcl.CurTaxLine.TaxCode);
      lcl.CurTaxLine.MWCD = l_GetMWStCode(wk.MWSTSATZ: EXBRBK.REDA: lcl.CurTaxLine.TaxCode);
      i1 = %lookup(lcl.CurTaxLine.codingLineNumber: lcl.CodingLine(*).codingLineNumber:
           1: lcl.CodingLineCount);
      if i1 > *zero;
        // Codingine-Daten aus Array holen
        lcl.CurTaxLine.codingLineNumber = lcl.CodingLine(I1).codingLineNumber;
        lcl.CurTaxLine.codingLineTag    = lcl.CodingLine(I1).codingLineTag;
        lcl.CurTaxLine.codingLineAmount = lcl.CodingLine(I1).Amount;
        lcl.CurTaxLine.InvLineNbr       = lcl.CodingLine(I1).InvLineNbr;
        lcl.CurTaxLine.dimension        = lcl.CodingLine(I1).dimension;
        // TaxLine-Daten in Array Speichern
        lcl.CodingLine(I1).TaxLineNbr = lcl.CurTaxLine.TaxLineNbr;
        //lcl.CodingLine(I1).TaxLineAmount = lcl.CurTaxLine.TaxLineAmount;
        lcl.CodingLine(I1).grossAmount= lcl.CurTaxLine.grossAmount;
        lcl.CodingLine(I1).percentage = lcl.CurTaxLine.percentage;
        lcl.CodingLine(I1).TaxCode    = lcl.CurTaxLine.TaxCode;
        lcl.CodingLine(I1).MWCD       = lcl.CurTaxLine.MWCD;
      else;
        // Fehler!
      ENDIF;
      // Todo: Mappen des MWSt-Codes "taxCode" auf MWCD
      // Steuerbeträge auf Kopfebene:
      if lcl.CurTaxLine.MWCD = EXBRBK.MWC1 or EXBRBK.MWC1 = *blank;
        EXBRBK.MWC1 = lcl.CurTaxLine.MWCD;
        EXBRBK.MWB1 += lcl.CurTaxLine.TaxLineAmount;
      elseif lcl.CurTaxLine.MWCD = EXBRBK.MWC2 or EXBRBK.MWC2 = *blank;
        EXBRBK.MWC2 = lcl.CurTaxLine.MWCD;
        EXBRBK.MWB2 += lcl.CurTaxLine.TaxLineAmount;
      elseif lcl.CurTaxLine.MWCD = EXBRBK.MWC3 or EXBRBK.MWC3 = *blank;
        EXBRBK.MWC3 = lcl.CurTaxLine.MWCD;
        EXBRBK.MWB3 += lcl.CurTaxLine.TaxLineAmount;
      ENDIF;

      if  lcl.CurTaxLine.CodingLineTag = 'ExceptionType'
      and lcl.CurTaxLine.CodingLineAmount > *zero;
        // über "Kostenstelle (TRTP: "KOZK") Key: 325620000 kann das wohl erkannt werden
        // "dimensions": { "dimension1": "325620000",  ...
        // Info von Hr.Mockenhaupt, 29.9.2023: -> effektiv nur zwei Konten
        // Freight cost(Schilling Sachkonto,      [3]25620000)
        // Packaging cost(Schilling Sachkonto     [3]25620000)
        // Energy supplement(Schilling Sachkonto  [3]11100000)
        // Material surcharge(Schilling Sachkonto [3]11100000)
        // Minimum quantity surcharge(Schilling Sachkonto [3]11100000)
        // Umsclüssung über Tabelle!
        if lcl.CurTaxLine.dimension = '325620000';
          wk.KONTO = 'FKO';
        elseif lcl.CurTaxLine.dimension = '11100000';
          wk.KONTO = 'TRZ';
        else;
          wk.KONTO = 'FKO';
        ENDIF;

        lcl_EXBRBKxKonto(EXBRBK: wk.KONTO: lcl.CurTaxLine.netAmount: lcl.CurTaxLine.MWCD);
        /if defined(never)
        if EXBRBK.KON1 = *blank
        or EXBRBK.KON1 = wk.Konto;   // and EXBRBK.MWK1 = lcl.CurTaxLine.MWCD;
          EXBRBK.KON1 = wk.KONTO;  // todo: FKO=Frachtkosten ggf. dynamisch
          EXBRBK.KOB1 += lcl.CurTaxLine.netAmount;
          /if defined(MOBBEX_BRBK)
          EXBRBK.MWK1 = lcl.CurTaxLine.MWCD;
          /endif
        elseif EXBRBK.KON2 = *blank
        or EXBRBK.KON2 = wk.Konto;   // and EXBRBK.MWK2 = lcl.CurTaxLine.MWCD;
          EXBRBK.KON2 = wk.KONTO;  // todo: FKO=Frachtkosten ggf. dynamisch
          EXBRBK.KOB2 += lcl.CurTaxLine.netAmount;
          /if defined(MOBBEX_BRBK)
          EXBRBK.MWK2 = lcl.CurTaxLine.MWCD;
          /endif
        elseif EXBRBK.KON3 = *blank
        or EXBRBK.KON3 = wk.Konto;   // and EXBRBK.MWK2 = lcl.CurTaxLine.MWCD;
          EXBRBK.KON3 = wk.KONTO;  // todo: FKO=Frachtkosten ggf. dynamisch
          EXBRBK.KOB3 += lcl.CurTaxLine.netAmount;
          /if defined(MOBBEX_BRBK)
          EXBRBK.MWK3 = lcl.CurTaxLine.MWCD;
          /endif
        endif;
        /endif

      elseif  lcl.CurTaxLine.CodingLineTag = 'DeviationExceptionType'
      and lcl.CurTaxLine.CodingLineAmount > *zero;
        // UNW = Ungeprüfter Wert
        // Absprache mit JK, 17.03.2026: Keine Abweichung...
        // lcl_EXBRBKxKonto(EXBRBK: 'UNW': lcl.CurTaxLine.netAmount: lcl.CurTaxLine.MWCD);
      ENDIF;
      clear lcl.CurTaxLine;

    elseif inPath = 'root/invoice/poLines'
    or     inPath = 'root/invoice/poLines/LI';
      lcl.poLine(lcl.poLineCount).BRST = EXBRBP.BRST;
      lcl.poLine(lcl.poLineCount).MEIN = EXBRBP.MEIN;
      lcl.poLine(lcl.poLineCount).MEPR = EXBRBP.MEPR;
      lcl.poLine(lcl.poLineCount).PDIM = EXBRBP.PDIM;
      lcl.poLine(lcl.poLineCount).PRAR = EXBRBP.PRAR;
      lcl.poLine(lcl.poLineCount).WACD = EXBRBP.WACD;
      if EXBRBP.MWCD = *blank;
        // hm... MWST-Code
      ENDIF;
      lcl.poLine(lcl.poLineCount).MWCD = EXBRBP.MWCD;
      lcl.poLine(lcl.poLineCount).BLPO = EXBRBP.BLPO;
      //lcl.poLineCount += 1;
      //clear lcl.poLine(lcl.poLineCount);

    elseif inPath = 'root/invoice/poConnectionLines/LI';
      // Jetzt aus den "TaxLines" die MWst-Angaben ermitteln.
      // invoiceLineNumber -> TaxLine
      // Fallunterscheidung: "connectionLevel": "Head"
      //                     "connectionLevel": "LineDetail"
      // .. Verlinkung der Daten ist unterschiedlich (Tax-Angaben..)
      if  EXBRBP.MWCD = *blank;
      for I1 = 1 to lcl.CodingLineCount;
        if lcl.invoiceLineNumber > *blank
        and lcl.CodingLine(I1).InvLineNbr = lcl.invoiceLineNumber;
          // passende Zeile!
          // und es darf für die BRBP eh nur EINE Zeile/einen MWSt-Satz geben
          EXBRBP.MWCD = lcl.CodingLine(I1).MWCD;
          leave;
        elseif lcl.invoiceLineNumber = *blank
        and lcl.CodingLineNumbers=lcl.CodingLine(I1).codingLineNumber;
          // trifft nur, FALLS es eine 1:1 -Beziehung ist!
          EXBRBP.MWCD = lcl.CodingLine(I1).MWCD;
          leave;
        elseif lcl.invoiceLineNumber = *blank
        and  %char(I1) = lcl.CodingLine(I1).poConnectionLineNumbers;
          // trifft nur, FALLS es eine 1:1 -Beziehung ist!
          EXBRBP.MWCD = lcl.CodingLine(I1).MWCD;
          leave;

      ENDIF;
      ENDFOR;
      ENDIF;
      // Aus aktuellen Daten ggf. die abweichende Preisdiemnsion ermitteln:
      //	"connectedAmount": 40200.0,
      //	"connectedQuantity": 10000.0,
      // "connectionLevel": "LineDetail",
      // "conversionFactor": 0.0,
      // "deliveredQuantity": 10000.0,
      // "deliveredAmount": 402.0,
      // "deliveredUnitPrice": 4.02,
      // deliveredQuantity * deliveredUnitPrice = PDIM x deliveredAmount
      // 10000 * 4.02 = PDIM x 402.0
      // 40200.0      = PDIM x 402.0  -> PDIM=3 (also 1=1, 2=10, 3=100)
      if lcl.CurPoConnLine.deliveredAmount <> lcl.CurPoConnLine.deliveredUnitPrice;
        wk.Faktor = lcl.CurPoConnLine.deliveredQuantity * lcl.CurPoConnLine.deliveredUnitPrice;
        wk.Faktor /= lcl.CurPoConnLine.deliveredAmount;
        // das sollte jetzt eine glatte Zehnerpotenz sein
        if %inth(wk.Faktor) = 1;
          EXBRBP.PDIM = '1';
        elseif %inth(wk.Faktor) = 10;
          EXBRBP.PDIM = '2';
        elseif %inth(wk.Faktor) = 100;
          EXBRBP.PDIM = '3';
        elseif %inth(wk.Faktor) = 1000;
          EXBRBP.PDIM = '4';
        elseif %inth(wk.Faktor) = 10000;
          EXBRBP.PDIM = '5';
        ENDIF;
      ENDIF;
      wk.pos = %lookup(lcl.CurPoConnLine.InvLineNbr: lcl.InvoiceLine(*).InvLineNbr:
           1: lcl.InvoiceLineCount);
      if wk.pos > *zero;
        // Einzelpreis der Rechnung aus Rechnungsposition verwenden!
        // NESU mus zwingen mit Einzelpreis der InvoiceLine ermittelt werden!
        // ACHTUNg: EInzelpreis über Medius ggf. mit mehr als 3 Nachkommastellen!
        eval(h) EXBRBP.PREI = lcl.InvoiceLine(wk.Pos).UnitPrice;
        eval(h) EXBRBP.NESU = lcl.CurPoConnLine.connectedQuantity
                            * lcl.InvoiceLine(wk.Pos).UnitPrice;
      ENDIF;
      if EXBRBK.RGJJ = *zero;
        // erst BRBK-Satz anlegen, um den Kopf für die Positionen zu haben
        lcl_BRBK(EXBRBK);
      endif;
      lcl_BRBP(EXBRBK: EXBRBP);
      clear EXBRBP;
      clear lcl.CurPoConnLine;
    ENDIF;

  when inEvent = 'LE';
    // Wertelisten
    if %parms < %parmnum(inData)  or  %len(inData) <= *zero;
      // nichts zu tun
    elseif inPath = 'root/invoice/codingLines/LI'
    and inName = 'poConnectionLineNumbers';
      // Das ist ein Array von Werten... das kann der Scanner (lcl_ReadJson()) derzeit nicht
      lcl.CodingLine(lcl.CodingLineCount).poConnectionLineNumbers = inData;
    elseif inPath = 'root/invoice/poConnectionLines/LI'
    and inName = 'codingLineNumbers';
      lcl.CodingLineNumbers = inData;
    ENDIF;

  when inEvent =  'DE';
    if %parms >= %parmnum(inNVP);
      trNameValue(inNVP: 'correlationKey': lcl.correlationKey);
      if  EXBRBK.FENR = NO_ERROR
      and EXBRBK.BRST = '10';   // Briefkastenstatus
        // Übergabe an BLKO:
        lcl_BRBK(EXBRBK: 'IFBLKO');
      endif;
      trNameValue(inNVP: 'EXBRBK.BRST': EXBRBK.BRST);
      trNameValue(inNVP: 'Voucher': trRefNrToString(EXBRBK.BLJJ: EXBRBK.BLNR));
    ENDIF;
  when inEvent <> 'NV';

  when inPath = 'root' and inName = 'correlationKey';
    // der Wert mus zum Beispiel so aussehen:
    // "company[DE411];ORDER_BASED;DE411;292013000;202304061126;2023-04-06"
    // "company[DE411]" ist zwingend
    // "ORDER_BASED ist zwingend
    // Das Firmen-Mapping würde nicht funktionieren, da die für Medius KEIN
    //   Firmen-Mapping definiert ist!
    // correlationKey: TREND   <-- fix
    //                 ORDER_BASED  <-- fix, auch Element root.originalDocumentType
    //                 DE411   <-- fix, auch Element root.companyId
    //                 &id     <-- Element root.supplierId
    //                 &id     <-- Element root.invoiceNumber
    //                 &date   <-- YYYY-MM-DD wie Element root.finalBookingDate ,invoiceDate
    lcl.correlationKey = inData;

  when inPath = 'root/invoice';
    if inName = 'importedOrderIdentifier';
      // Bestellnummer, wie bereitgestellt über "OrderIdentifier"
      // Hierrüber kann auch zuverlässig die BBEK-Lieferantennumer ermittelt werden
      if %len(inData) < 5;
      elseif %subst(inData: 1: 4) = 'Nr.:';
        inData = %trim(%subst(inData: 5));
      ENDIF;
      EXBRBK.BEJJ = trDec(%subst(inData: 1: 4));
      EXBRBK.BENR = l_TrimNmKr(%subst(inData: 5)); // führende Nullen  +'/' entfernen
      if glb.ENVI = 'TEST';
        // jetzt ggf. die aktuellen Daten aus der ECHT-Umgebung in die TEST-Umgebung kopieren
        lcl_EchtToTest(EXBRBK.BEJJ: EXBRBK.BENR);  // Daten von ECHT nach TEST kopieren
      ENDIF;
      wk.HandlerResponse = 'BENR';

    elseif inName = 'documentId';
      EXBRBK.HINW = 'Medius Id: ' + inData;
      EXBRBK.BLID = inData;
      //trNameValue(inNVP: 'MediusId': inData);
    elseif inName = 'companyId';
      if inData = 'DE411';
        DAFIRM = '01';
      ENDIF;
    elseif inName = 'invoiceNumber';
      EXBRBK.EXBL = inData;
      wk.HandlerResponse = 'EXBL';
    elseif inName = 'invoiceDate';
      if %len(inData) >= 10;
        EXBRBK.EXDA = trDateFromString(%subst(inData: 1: 10): C_ISO: WKFENR);
        EXBRBK.REDA = trDateFromString(%subst(inData: 1: 10): C_ISO: WKFENR);
      endif;
    elseif inName = 'supplierId';
      // ACHTUNG: ggf. ist dies der Rechnungssteller!
      // BBEK.LFNR -> LIEF -> LFRALF (Liefernatennr. Rechnung)
      // in diesem Fall sollte die Orginal-LFNR der bestellung in customField_Text# stehen
      exec sql select EKLFNR into :EXBRBK.LFNR
        from BBEK where EKFIRM = :DAFIRM
        and EKBEJJ = :EXBRBK.BEJJ and EKBENR = :EXBRBK.BENR;

      // erst nur EXBRBK.KRLF bestücken.
      // Falls LFNR nicht gesetzt, den Wert übernehmen
      EXBRBK.KRLF = inData;   // 2xxxxx000
      if  %len(EXBRBK.KRLF) >= 7
      and %subst(EXBRBK.KRLF: 1: 1) = '2'
      and %subst(EXBRBK.KRLF: 7) = '000';
        EXBRBK.KRLF = %subst(inData: 2: 5);
      ENDIF;

      if EXBRBK.LFNR = *blank;
        EXBRBK.LFNR = EXBRBK.KRLF;
      ENDIF;

    elseif inName = 'paymentTerm';
      evalr EXBRBK.ZABD = '000' + inData;
      // Anforderung Dometic, Feb. 2026: Zahlungsbedingung ignorieren
      clear EXBRBK.ZABD;
    elseif inName = 'totalAmount';
      EXBRBK.BRBT = trDec(inData);
    elseif inName = 'totalCodedNetAmount';
      EXBRBK.NTBT = trDec(inData);
    elseif inName = 'currencyExternalSystemId';
      EXBRBK.WACD = inData;
    endif;

  // Positionsdaten: sind auf vier Blöcke verteilt
  // Da diese ALLE auf gleicher Ebene stehen aber nicht notwendigerweise
  // eine 1:1-Beziehung haben, wird das tricky...
  // es gibt ja nur einen einzigen BRBP-Satz
  // es gibt "invoiceLines", "codingLines", "taxLines", "poLines", "poConnectionLines"
  // "codingLines": Hier steht soetwas wie das "konto" drin
  // "taxLines": Hier stehen Steuerinfos drin
  // die "poLines" sind die originären Bestellpositionen, haben aber nicht alle
  //   Rechnungsinformationen
  //   --> in Struktur lcl.PoLine() vorhalten!!
  //
  // "poConnectionLines" entsprechen den Wareneingänge..
  //   -> dazu gibt es auch einen Bezug in der BRBP: BRBPWEJJ + BRBPWENR
  //   --> aus Struktur lcl.PoLine() Bestellbezug ermitteln

  when inPath = 'root/invoice/invoiceLines/LI';
    if lcl.InvoiceLineCount = *zero;
      // Fehler!
    elseif inName = 'amount';
      lcl.InvoiceLine(lcl.InvoiceLineCount).amount = trDec(inData);
    elseif inName = 'lineNumber';
      lcl.InvoiceLine(lcl.InvoiceLineCount).InvLineNbr = inData;
    elseif inName = 'quantity';
      lcl.InvoiceLine(lcl.InvoiceLineCount).quantity = trDec(inData);
    elseif inName = 'unitPrice';
      lcl.InvoiceLine(lcl.InvoiceLineCount).UnitPrice = trDec(inData);
    endif;

  when inPath = 'root/invoice/codingLines/LI';
    // bei "dimensions": {dimension1": "385000100", "freeText1": "zu definieren"},
    // fehlt hier die Angabe "invoiceLineNumber"
    // Diese wird aber benötigt, um den MWST-Code zu ermitteln

    clear wk.HandlerResponse;
    if lcl.CodingLineCount = *zero;
      // Fehler!
    elseif inName = 'amount';
      // hier ggf, Frachtkosten... -> siehe tag="ExceptionType"
      // Das ist der Netto-Betrag -> TaxLine.netAmount
      lcl.CodingLine(lcl.CodingLineCount).Amount = trDec(inData);
    elseif inName = 'invoiceLineNumber';
      lcl.CodingLine(lcl.CodingLineCount).InvLineNbr = inData;
    elseif inName = 'codingLineNumber';
      lcl.CodingLine(lcl.CodingLineCount).codingLineNumber = inData;
    elseif inName = 'poConnectionLineNumbers';
      // Das ist ein Array von Werten... das kann der Scanner (lcl_ReadJson()) derzeit nicht
      wk.DataStr = inData;   // nur zum debuggen
      lcl.CodingLine(lcl.CodingLineCount).poConnectionLineNumbers = inData;
    elseif inName = 'taxIndicator1';
      // wird ggf. zur Ermittlung des MWST-Codes auf Positionsebene benötigt
      lcl.CodingLine(lcl.CodingLineCount).taxIndicator1 = inData;
    elseif inName = 'tag';
      lcl.CodingLine(lcl.CodingLineCount).codingLineTag = inData;
      //  'ExceptionType' -> Zusatzkosten
    ENDIF;
  when inPath = 'root/invoice/codingLines/LI/dimensions';
    if lcl.CodingLineCount = *zero;
      // Fehler!
    elseif inName = 'dimension1';
      // da gibt es eine Liste von Elementen (Kein array!): dimension1.. dimension9
      lcl.CodingLine(lcl.CodingLineCount).dimension = inData;
    endif;

  when inPath = 'root/invoice/taxLines/LI';
    clear wk.HandlerResponse;
    // Werden benötigt, um den Steuersatz zu ermitteln
    // Je Rechnung/Position können es (technisch) aus mehr als einen Steuersatz geben
    if inName = 'codingLineNumber';
      lcl.CurTaxLine.codingLineNumber = inData;
    elseif inName = 'amount';
      lcl.CurTaxLine.TaxLineAmount = trDec(inData);
    elseif inName = 'grossAmount';
      lcl.CurTaxLine.grossAmount = inData;
    elseif inName = 'netAmount';
      lcl.CurTaxLine.netAmount = trDec(inData);
    elseif inName = 'percentage';
      lcl.CurTaxLine.percentage = inData;
    elseif inName = 'taxCode';
      lcl.CurTaxLine.TaxCode = inData;
    elseif inName = 'taxLineNumber';
      // ?? wurde bis zum 24.2.205 nicht bestückt! Müsste mit der seq-Number übereinstimmen
      // lcl.CurTaxLine.TaxLineNbr = inData;
    ENDIF;
  when inPath = 'root/invoice/poLines/LI';
    clear wk.HandlerResponse;
    //if lcl.poLineCount = *zero;
    //  lcl.poLineCount = 1;
    //ENDIF;
    if inName = 'purchaseOrderLineNumber';
      // bereitgestellter "key" aus usprünglichem Import, nicht zuverlässig
      //lcl.poLine(lcl.poLineCount).POLineNumber = inData;   // key für poConnectionLine!
    elseif inName = 'purchaseOrderNumber';
      // Falls hier eine abweichende Bestellnummer angegeben ist -> diese ggf. ECHT->TEST kopieren
      if glb.ENVI = 'TEST'
      and %len(inData) > 8
      and %scan(%trim(EXBRBK.BENR): %char(inDATA)) = *zero;
        // Annahme: zumindest das Bestelljahr ist gleich..
        lcl_EchtToTest(EXBRBK.BEJJ: %subst(inData:6));  // Daten von ECHT nach TEST kopieren
      endif;
    elseif inName = 'lineNumber';
      lcl.poLine(lcl.poLineCount).POLineNumber = inData;   // key für poConnectionLine!
    elseif inName = 'itemNumber';
      lcl.poLine(lcl.poLineCount).TENR = inData;   // Interne Ident-Nummer !!
    elseif inName = 'quantity';          // Bestellte Menge! -> unwichtig!
      // lcl.poLine(lcl.poLineCount).GLMG = trDec(inData);
    elseif inName = 'unitPrice';         // Bestellpreis! kann von Rechungspreis abweichen!
      lcl.poLine(lcl.poLineCount).PREI = trDec(inData);
    elseif inName = 'externalSystemId';
      // "company[DE411];BBEP;01;2023002284.10"
      wk.DataStr = trListElement(inData: 4);
      lcl.poLine(lcl.poLineCount).BEJJ = trdec(%subst(wk.DataStr: 1: 4));
      wk.DataStr = l_TrimNmKr(%subst(wk.DataStr: 5));
      wk.pos = %scan(%ucs2('.'): wk.DataStr);
      if wk.pos = *zero;
        lcl.poLine(lcl.poLineCount).BENR = wk.DataStr;
        lcl.poLine(lcl.poLineCount).BEPO += 1;
      else;
        lcl.poLine(lcl.poLineCount).BENR = %subst(wk.DataStr: 1: wk.pos-1);
        lcl.poLine(lcl.poLineCount).BEPO = trdec(%subst(wk.DataStr: wk.pos +1));
      endif;
    endif;

  when inPath = 'root/invoice/poConnectionLines/LI';
    clear wk.HandlerResponse;
    // Lieferscheinnummer
    // -> BRBP nochmals updaten
    // "purchaseOrderLineNumber" -> Verbindung zu poLines
    // über "deliveryLineExternalSystemId" ("company[DE411];BWAE;01;2023135295")
    //    die Lieferscheinnummer ermitteln. Diese wird als eindeutiger Key für die BRBP benötigt
    if inName = 'connectionLevel';
      lcl.connectionLevel = inData;

    elseif inName = 'purchaseOrderLineNumber';
      wk.poLineIdx = %lookup(inData: lcl.poLine(*).POlineNumber);
      if wk.poLineIdx = *zero;
        wk.poLineIdx = *zero;   // Fehler!
      ENDIF;
      // aus poLines, Initialwerte
      EXBRBP.BRST = l_FirstValueA(EXBRBP.BRST: lcl.poLine(wk.poLineIdx).BRST);
      EXBRBP.MEIN = l_FirstValueA(EXBRBP.MEIN: lcl.poLine(wk.poLineIdx).MEIN);
      EXBRBP.MEPR = l_FirstValueA(EXBRBP.MEPR: lcl.poLine(wk.poLineIdx).MEPR);
      EXBRBP.PDIM = l_FirstValueA(EXBRBP.PDIM: lcl.poLine(wk.poLineIdx).PDIM);
      EXBRBP.PRAR = l_FirstValueA(EXBRBP.PRAR: lcl.poLine(wk.poLineIdx).PRAR);
      EXBRBP.WACD = l_FirstValueA(EXBRBP.WACD: lcl.poLine(wk.poLineIdx).WACD);
      EXBRBP.MWCD = l_FirstValueA(EXBRBP.MWCD: lcl.poLine(wk.poLineIdx).MWCD);
      EXBRBP.BLPO = l_FirstValueS(EXBRBP.BLPO: lcl.poLine(wk.poLineIdx).BLPO);
      // aus poLines, Einzelwerte
      EXBRBP.TENR = l_FirstValueA(EXBRBP.TENR: lcl.poLine(wk.poLineIdx).TENR);
      EXBRBP.BEJJ = l_FirstValueS(EXBRBP.BEJJ: lcl.poLine(wk.poLineIdx).BEJJ);
      EXBRBP.BENR = l_FirstValueA(EXBRBP.BENR: lcl.poLine(wk.poLineIdx).BENR);
      EXBRBP.BEPO = l_FirstValueS(EXBRBP.BEPO: lcl.poLine(wk.poLineIdx).BEPO);
      // die folgenden Werte werden ggf. durch Wert im Wareneingang/poConnectionLines überschrieben
      EXBRBP.PREI = l_FirstValueS(EXBRBP.PREI: lcl.poLine(wk.poLineIdx).PREI);
      EXBRBP.GLMG = l_FirstValueS(EXBRBP.GLMG: lcl.poLine(wk.poLineIdx).GLMG);

    elseif inName = 'deliveryNumber';   // eingehende LS-Nummer
      // für die BRBP passt das nicht.. diese nutzt die LIJJ/LINR.LIPO für ausgehende LS
      // für den Key kann dann zwar LIJJ=akuelles Jahr gesetzt werden,
      // LINR bleibt leer, LIPO wird hochgezählt, um eindetige Keys zu erhalten
      EXBRBP.BLIN = inData;
      // folgendes ist ALT!!! nur Übergangsweise aktiv!!
      //if EXBRBP.LINR = *blank and %len(inData) >= 6
      //and %subst(inData: 5: 1) = '/';  // "YYYY/nnnn"
      //  EXBRBP.LIJJ = trdec(%subst(inData: 1: 4));
      //  EXBRBP.LINR = l_TrimNmKr(%subst(inData: 6));
      //ENDIF;
    elseif inName = 'connectedAmount';
      EXBRBP.NESU = trDec(inData);
      lcl.CurPoConnLine.connectedAmount = trDec(inData);
    elseif inName = 'connectedQuantity';
      lcl.CurPoConnLine.connectedQuantity = trDec(inData);
      EXBRBP.GLMG = trDec(inData);
    elseif inName = 'deliveredQuantity';
      lcl.CurPoConnLine.deliveredQuantity = trDec(inData);
    elseif inName = 'deliveredAmount';
      //EXBRBP.NESU = trDec(inData);
      lcl.CurPoConnLine.deliveredAmount = EXBRBP.NESU;
      // fix, 24.02.2026: hier den tatsächliche Werte von Medius speichern!
      // ggf. sonst später EXBRBP.NESU bzw connectedAmount verwenden
      lcl.CurPoConnLine.deliveredAmount = trDec(inData);
    elseif inName = 'deliveredUnitPrice';
      EXBRBP.PREI = trDec(inData);
      lcl.CurPoConnLine.deliveredUnitPrice = EXBRBP.PREI;
    elseif inName = 'invoiceLineNumber';    // die gibt's nicht!
      // WICHTIG! über diesen Wert werden am Ende auch die "TaxLines" verarbeitet,
      // um die MWSt-Angaben zu ermitteln
      lcl.InvoiceLineNumber = inData;
      lcl.CurPoConnLine.InvLineNbr = inData;
      if EXBRBP.BLPO = *zero;
      EXBRBP.BLPO = trDec(inData);
      endif;
    elseif inName = 'codingLineNumbers';
      // Das ist ein Array!!!
      lcl.CodingLineNumbers = inData;
    elseif inName = 'deliveryLineExternalSystemId';
      // "company[DE411];BWAE;01;2023135295.10",
      // "company[DE411];BWAE;01;2023135295",
      wk.DataStr = trListElement(inData: 4);
      /if not defined(MOBBEX_BRBP)
      if EXBRBP.LINR = *blank;
        EXBRBP.LIJJ = trdec(%subst(wk.DataStr: 1: 4));
        EXBRBP.LINR = l_TrimNmKr(%subst(wk.DataStr: 5));
      ENDIF;
      /endif
      /if defined(MOBBEX_BRBP)
      // Dometic: Keine BWAE-Infos in der BRBP!
      EXBRBP.WEJJ = trdec(%subst(wk.DataStr: 1: 4));
      wk.DataStr = l_TrimNmKr(%subst(wk.DataStr: 5));
      wk.pos = %scan(%ucs2('.'): wk.DataStr);
      if wk.pos = *zero;
        EXBRBP.WENR = wk.DataStr;
      else;
        // altedaten! nur test vor 21.4.2023
        EXBRBP.WENR = %subst(wk.DataStr: 1: wk.pos-1);
      endif;
      /endif
    endif;
  ENDSL;

  return wk.HandlerResponse;
END-PROC;
//*****************************************************************************
dcl-proc lcl_EXBRBKxKonto;
  dcl-pi *n;
    inEXBRBK       likeds(EXBRBK_t);
    inKonto        varchar(10) value;
    inBetrag       zoned(16: 2) value;
    inMwCd         varchar(10) value;
  END-PI;

  // ggf. sollte auch der MWSt-Code auf Gleichheit geprüft werden
  if inBetrag = *ZERO;
  // Falls der Betrag *zero ist, dann NICHT speicher!
  // -> die BRBP->BLBP kommtdamit später nicht zurecht

  elseif inEXBRBK.KON1 = *blank
  or inEXBRBK.KON1 = inKonto;
    inEXBRBK.KON1 = inKONTO;
    inEXBRBK.KOB1 += inBetrag;
    /if defined(MOBBEX_BRBK)
    inEXBRBK.MWK1 = inMwCd;
    /endif
  elseif inEXBRBK.KON2 = *blank
  or inEXBRBK.KON2 = inKonto;
    inEXBRBK.KON2 = inKONTO;
    inEXBRBK.KOB2 += inBetrag;
    /if defined(MOBBEX_BRBK)
    inEXBRBK.MWK2 = inMwCd;
    /endif
  elseif inEXBRBK.KON3 = *blank
  or inEXBRBK.KON3 = inKonto;
    inEXBRBK.KON3 = inKONTO;
    inEXBRBK.KOB3 += inBetrag;
    /if defined(MOBBEX_BRBK)
    inEXBRBK.MWK3 = inMwCd;
    /endif
  elseif inEXBRBK.KON4 = *blank
  or inEXBRBK.KON4 = inKonto;
    inEXBRBK.KON4 = inKONTO;
    inEXBRBK.KOB4 += inBetrag;
    /if defined(MOBBEX_BRBK)
    inEXBRBK.MWK4 = inMwCd;
    /endif
  endif;

END-PROC;
//*****************************************************************************
// Erzeugen BRBK-Satz
//*****************************************************************************
// Falls der BRBK-Satz schon existiert,                                      c
// und einen Status >= 20 hat, dürfen die Daten nicht mehr verändert werden.
dcl-proc lcl_BRBK;
  dcl-pi *n;
    inEXBRBK       likeds(EXBRBK_t);
    inPGST         like(#CPGST) value options(*nopass);
  END-PI;
  dcl-ds BRBK      ext inz end-ds;
  dcl-ds KYBRBK    ext inz end-ds;
  dcl-ds RTBRBK    ext inz end-ds;
  //-
  dcl-ds WK        qualified inz;
  END-DS;

  dcl-s WKFENR     like(WKFENR_t);
  DCL-PR C_TRBRBK    EXTPGM('TRBRBK');
    #EX              LIKEDS(EXBRBK_t);
    #RT              LIKEDS(RTBRBK);
  END-PR;
  DCL-PR C_TRNUMM    EXTPGM('TRNUMM');
    #EXTR02          LIKEDS(EXTR02);
  END-PR;

  if %parms >= %parmnum(inPGST)
  and inPGST = 'IFBLKO';
    inEXBRBK.PGST = inPGST;
    if inEXBRBK.BRST <= '20';
    callp(e) C_TRBRBK(inEXBRBK: RTBRBK);
    endif;
  ENDIF;

  WKFENR = *ZEROS;
  KYBRBKFIRM = DAFIRM;
  KYBRBKRGFI = inEXBRBK.RGFI;
  KYBRBKRGJJ = inEXBRBK.RGJJ;
  KYBRBKRGNR = inEXBRBK.RGNR;

  if KYBRBKRGNR = *blank;
    // Neuer Datensatz
    // bzw. über EXBL suchen
    exec sql select BRBKRGFI, BRBKRGJJ, BRBKRGNR
      into :KYBRBKRGFI, :KYBRBKRGJJ, :KYBRBKRGNR
      from BRBK where BRBKFIRM = :DAFIRM
      and BRBKEXBL = :inEXBRBK.EXBL
      and BRBKLFNR = :inEXBRBK.LFNR;
    if sqlcode = *zero;
      inEXBRBK.RGFI = KYBRBKRGFI;
      inEXBRBK.RGJJ = KYBRBKRGJJ;
      inEXBRBK.RGNR = KYBRBKRGNR;
    else;
      clear KYBRBKRGNR;
    ENDIF;
  ENDIF;

  if KYBRBKRGNR = *blank;
    %SUBST(#CKOMM:01) = 'NUMMER';
    %SUBST(#CKOMM:11:4) = decToAlnum(KYBRBKRGJJ: 4: 0);
    %SUBST(#CKOMM:15:4) = 'BRBK';
    C_TRNUMM(EXTR02);
    KYBRBKRGJJ = *YEAR;
    KYBRBKRGNR = %SUBST(#CKOMM:01);
    KYBRBKRGFI = DAFIRM;
    inEXBRBK.RGFI = DAFIRM;
    inEXBRBK.RGJJ = KYBRBKRGJJ;
    inEXBRBK.RGNR = KYBRBKRGNR;
  ENDIF;

  if inEXBRBK.PGST = 'IFBLKO';
    CHIDS  = '01C';
  else;
    CHIDS  = '01CU';
  ENDIF;
  EXSR CHBRBK;

  if CHI(6) = *ON
  or BRBKBRST <= '10';   // BRBK.Status<=10 -> neu/in Arbeit
    // Neuanlage
    /if defined(never)
    BRBKFIRM = KYBRBKFIRM;
    BRBKRGFI = KYBRBKRGFI;
    BRBKRGJJ = KYBRBKRGJJ;
    BRBKRGNR = KYBRBKRGNR;
    /endif
    BRBKBRST = inEXBRBK.BRST;
    // BRBK.BLID bei Dometic erst mit update... ansonsten: Verwendung der CDEX!
    // BRBKBLID = inEXBRBK.BLID;
    BRBKBLJJ = inEXBRBK.BLJJ;
    BRBKLFNR = inEXBRBK.LFNR;
    BRBKUGDA = inEXBRBK.UGDA;
    BRBKEXBL = inEXBRBK.EXBL;
    BRBKEXDA = inEXBRBK.EXDA;
    BRBKBEJJ = inEXBRBK.BEJJ;
    BRBKBENR = inEXBRBK.BENR;
    BRBKREDA = inEXBRBK.REDA;
    BRBKBLGA = inEXBRBK.BLGA;    // 100=Eingangsrechnung
    BRBKBRBT = inEXBRBK.BRBT;
    BRBKNTBT = inEXBRBK.NTBT;
    BRBKWACD = inEXBRBK.WACD;
    BRBKHINW = inEXBRBK.HINW;
    BRBKMWC1 = inEXBRBK.MWC1;  //MWSt-Code
    BRBKMWB1 = inEXBRBK.MWB1;
    BRBKMWC2 = inEXBRBK.MWC2;  //MWSt-Code
    BRBKMWB2 = inEXBRBK.MWB2;
    BRBKMWC3 = inEXBRBK.MWC3;  //MWSt-Code
    BRBKMWB3 = inEXBRBK.MWB3;
    BRBKKON1 = inEXBRBK.KON1;
    BRBKKOB1 = inEXBRBK.KOB1;
    BRBKKON1 = inEXBRBK.KON2;
    BRBKKOB1 = inEXBRBK.KOB2;
    BRBKKON1 = inEXBRBK.KON3;
    BRBKKOB1 = inEXBRBK.KOB3;
    BRBKKON1 = inEXBRBK.KON4;
    BRBKKOB1 = inEXBRBK.KOB4;
    /if defined(MOBBEX_BRBK)
    BRBKMWK1 = inEXBRBK.MWK1;
    BRBKMWK2 = inEXBRBK.MWK2;
    BRBKMWK3 = inEXBRBK.MWK3;
    BRBKMWK4 = inEXBRBK.MWK4;
    /ENDIF
    BRBKZABD = inEXBRBK.ZABD;
    BRBKWKNR = inEXBRBK.WKNR;
    BRBKFENR = inEXBRBK.FENR;
  endif;
  BRBKSABE = l_FirstValueA(BRBKSABE: glb.SABEdefault);

  BRBKJNAM = DAJNAM;
  BRBKPROG = WKCHPN;
  BRBKBIBL = WKCHPL;
  BRBKUSER = DAUSER;

  BRBKJZEI = %DEC(%TIME());
  BRBKJDAT = %DEC(%DATE:*ISO);

  SELECT;
  when inEXBRBK.PGST = 'IFBLKO';
    if BRBKLOCK <> *blank;
    CHIDS  = '01F';        // Satz wieder freigeben
    EXSR CHBRBK;
    endif;
    //-
  WHEN CHI(6) = *ON;
    CHIDS  = '01W';
    EXSR CHBRBK;
  WHEN CHI(6) = *OFF;
    if BRBKBRST >= '20';   // BRBK.Status>=20 -> bereits erledigt
    CHIDS  = '01F';        // Satz wieder freigeben
    else;
    CHIDS  = '01U';
    ENDIF;
    EXSR CHBRBK;
  ENDSL;

  if inEXBRBK.PGST <> 'IFBLKO'
  and inEXBRBK.BLID <> *blank
  and BRBKBRST < '20';   // BRBK.Status>=20 -> bereits erledigt
    lcl_DCEX(inEXBRBK: inEXBRBK.BLID);
  ENDIF;

  inEXBRBK.BRST = BRBKBRST;     // Status zurückgeben!

  return;
  /copy QCPYSRC,CHBRBK
END-PROC;
//*****************************************************************************
// Erzeugen BRBP-Satz
//*****************************************************************************
dcl-proc lcl_BRBP;
  dcl-pi *n;
    inEXBRBK       likeds(EXBRBK_t);
    inEXBRBP       likeds(EXBRBP_t);
  END-PI;
  dcl-ds BRBP      ext inz end-ds;
  dcl-ds KYBRBP    ext inz end-ds;
  //-
  dcl-ds WK        qualified inz;

  END-DS;
  dcl-s WKFENR     like(WKFENR_t);

  WKFENR = *ZEROS;
  KYBRBPFIRM = DAFIRM;
  KYBRBPRGFI = inEXBRBK.RGFI;
  KYBRBPRGJJ = inEXBRBK.RGJJ;
  KYBRBPRGNR = inEXBRBK.RGNR;

  if KYBRBPRGNR = *blank
  or inEXBRBK.BRST >= '20';   // BRBK.Status>=20 -> bereits erledigt
    return;
  ENDIF;

  KYBRBPLIJJ = inEXBRBP.LIJJ;
  KYBRBPLINR = inEXBRBP.LINR;
  KYBRBPLIPO = inEXBRBP.LIPO;
  /if defined(info)
  // LIJJ, LINR und LIPO sind bei "Einkauf" eigentlich immmer leer!
  // .. allerdings gehören die zum eindeutigen Schlüssel,
  // .. der WAEI-bezug muaa aber eindeutig sein!
  // -> LIJJ+LINR+LIPO immer leer lassen!
  //    ... mit Key aus WAEI bestücken
  // dopplete Sätze in der BRBP...
  // --> Doppelte Sätze ...da wird implizite die "LIPO" hochgezählt
  //     das ist unsauber
  //     aber blind addieren ist auch nicht so zuläassig
  exec sql SELECT rrn(brbp),
   BRBPLIJJ, BRBPLINR , brbpwenr,brbpbenr, brbpbepo,
   brbplipo, brbpnesu, brbprgnr
  FROM brbp WHERE brbpfirm ='01' and brbprgjj = 2026 and
   brbprgnr ='100070'
   order by rrn(brbp);

  /endif
  // 14.4.2026: LS-Bezug IMMER leer lessen! ("Position" wird benötigt für eindeutigen Schlüssel)
  clear KYBRBPLIJJ;
  clear KYBRBPLINR;

  /if defined(MOBBEX_BRBP)
  // (trend-) LS-Jahr/Nummer: Nicht optimal, aber besser als *zero/*blank:
  // inEXBRBP.RGJJ + RGNR sind ggf. nicht bestückt!
  // KYBRBPLIJJ = inEXBRBP.RGJJ;
  // KYBRBPLINR = inEXBRBP.RGNR;
  clear KYBRBPLIPO;
  // WEJJ+NR erst nach Update
  if inEXBRBP.WENR <> *blank;
    exec sql select  BRBPLIPO
      into  :KYBRBPLIPO
      from BRBP where BRBPFIRM = :DAFIRM
      and BRBPRGFI = :KYBRBPRGFI
      and BRBPRGJJ = :KYBRBPRGJJ
      and BRBPRGNR = :KYBRBPRGNR
      and BRBPLIJJ = :KYBRBPLIJJ
      and BRBPLINR = :KYBRBPLINR
      //and BRBPBLIN = :inEXBRBP.BLIN
      and BRBPWEJJ = :inEXBRBP.WEJJ
      and BRBPWENR = :inEXBRBP.WENR
   order by BRBPFIRM, BRBPLIJJ desc, BRBPLINR desc, BRBPLIPO desc
    fetch first row only;
  else;
    sqlcode = 100;
  endif;
  if sqlcode <> *zero and inEXBRBP.BLIN <> *blank;
    // BRBP-Satz: keinesfalls einen mit einer anderen/falschen WE-Nummer verwenden!
    exec sql select  BRBPLIPO
      into  :KYBRBPLIPO
      from BRBP where BRBPFIRM = :DAFIRM
      and BRBPRGFI = :KYBRBPRGFI
      and BRBPRGJJ = :KYBRBPRGJJ
      and BRBPRGNR = :KYBRBPRGNR
      and BRBPLIJJ = :KYBRBPLIJJ
      and BRBPLINR = :KYBRBPLINR
      and BRBPBLIN = :inEXBRBP.BLIN
      and BRBPWEJJ in(0,  :inEXBRBP.WEJJ)
      and BRBPWENR in(' ', :inEXBRBP.WENR)
   order by BRBPFIRM, BRBPLIJJ desc, BRBPLINR desc, BRBPLIPO desc
    fetch first row only;
  endif;
  /endif

  /if not defined(MOBBEX_BRBP)
  // alte Logik - OHNE BWAE-Bezug in der BRBP:
  if KYBRBPLINR = *blank;
    clear KYBRBPLIJJ;
    clear KYBRBPLINR;
    clear KYBRBPLIPO;
    exec sql select BRBPLIJJ, BRBPLINR, BRBPLIPO
      into :KYBRBPLIJJ, :KYBRBPLINR, :KYBRBPLIPO
      from BRBP where BRBPFIRM = :DAFIRM
      and BRBPRGFI = :KYBRBPRGFI
      and BRBPRGJJ = :KYBRBPRGJJ
      and BRBPRGNR = :KYBRBPRGNR
      // WEJJ+NR erst nach Update
      //and BRBPWEJJ = :inEXBRBP.WEJJ
      //and BRBPWENR = :inEXBRBP.WENR
   order by BRBPLIJJ desc, BRBPLINR desc, BRBPLIPO desc
    fetch first row only;
    if sqlcode = *zero;
      KYBRBPLIPO += 1;
      inEXBRBP.LIJJ = KYBRBPLIJJ;
      inEXBRBP.LINR = KYBRBPLINR;
      inEXBRBP.LIPO = KYBRBPLIPO;
    endif;

  endif;
  /endif

  if KYBRBPLIPO  = *zero;
    if KYBRBPLIJJ = *zero;
      KYBRBPLIJJ = *YEAR;
      // clear KYBRBPRGNR;
      clear KYBRBPLIJJ;
      clear KYBRBPLINR;
      clear KYBRBPLIPO;
    ENDIF;
    exec sql select coalesce(max(BRBPLIPO), 0)
      into  :KYBRBPLIPO
      from BRBP where BRBPFIRM = :DAFIRM
      and BRBPRGFI = :KYBRBPRGFI
      and BRBPRGJJ = :KYBRBPRGJJ
      and BRBPRGNR = :KYBRBPRGNR;

    KYBRBPLIPO += 1;
  /if not defined(MOBBEX_BRBP)
    inEXBRBP.LIJJ = KYBRBPLIJJ;
    inEXBRBP.LINR = KYBRBPLINR;
  /endif
    inEXBRBP.LIPO = KYBRBPLIPO;

  ENDIF;

  CHIDS  = '01CU';
  EXSR CHBRBP;

  if CHI(6) = *ON;
    // Neuanlage
    /if defined(never)
    BRBPFIRM = KYBRBPFIRM;
    BRBPRGFI = KYBRBPRGFI;
    BRBPRGJJ = KYBRBPRGJJ;
    BRBPRGNR = KYBRBPRGNR;
    BRBPLIJJ = KYBRBPLIJJ;
    BRBPLINR = KYBRBPLINR;
    BRBPLIPO = KYBRBPLIPO;
    /endif
  endif;

    BRBPBLJJ = l_FirstValueS(inEXBRBP.BLJJ: BRBPBLJJ);
    BRBPBLNR = l_FirstValueA(inEXBRBP.BLNR: BRBPBLNR);
    BRBPBRST = l_FirstValueA(inEXBRBP.BRST: BRBPBRST);
    BRBPBEJJ = l_FirstValueS(inEXBRBP.BEJJ: BRBPBEJJ);
    BRBPBENR = l_FirstValueA(inEXBRBP.BENR: BRBPBENR);
    BRBPBEPO = l_FirstValueS(inEXBRBP.BEPO: BRBPBEPO);
    BRBPBLIN = l_FirstValueA(inEXBRBP.BLIN: BRBPBLIN);
    BRBPTENR = l_FirstValueA(inEXBRBP.TENR: BRBPTENR);
    BRBPGLMG = l_FirstValueS(inEXBRBP.GLMG: BRBPGLMG);
    BRBPNRMG = l_FirstValueS(inEXBRBP.NRMG: BRBPNRMG);
    BRBPMEIN = l_FirstValueA(inEXBRBP.MEIN: BRBPMEIN);
    BRBPMEPR = l_FirstValueA(inEXBRBP.MEPR: BRBPMEPR);
    BRBPPRAR = l_FirstValueA(inEXBRBP.PRAR: BRBPPRAR);
    BRBPPREI = l_FirstValueS(inEXBRBP.PREI: BRBPPREI);
    BRBPPDIM = l_FirstValueA(inEXBRBP.PDIM: BRBPPDIM);

    BRBPKON1 = l_FirstValueA(inEXBRBP.KON1: BRBPKON1);
    BRBPKOW1 = l_FirstValueS(inEXBRBP.KOW1: BRBPKOW1);
    BRBPPRZ1 = l_FirstValueA(inEXBRBP.PRZ1: BRBPPRZ1);
    BRBPPDI1 = l_FirstValueA(inEXBRBP.PDI1: BRBPPDI1);
    BRBPBAS1 = l_FirstValueA(inEXBRBP.BAS1: BRBPBAS1);

    BRBPKON2 = l_FirstValueA(inEXBRBP.KON2: BRBPKON2);
    BRBPKOW2 = l_FirstValueS(inEXBRBP.KOW2: BRBPKOW2);
    BRBPPRZ2 = l_FirstValueA(inEXBRBP.PRZ2: BRBPPRZ2);
    BRBPPDI2 = l_FirstValueA(inEXBRBP.PDI2: BRBPPDI2);
    BRBPBAS2 = l_FirstValueA(inEXBRBP.BAS2: BRBPBAS2);

    BRBPKON3 = l_FirstValueA(inEXBRBP.KON3: BRBPKON3);
    BRBPKOW3 = l_FirstValueS(inEXBRBP.KOW3: BRBPKOW3);
    BRBPPRZ3 = l_FirstValueA(inEXBRBP.PRZ3: BRBPPRZ3);
    BRBPPDI3 = l_FirstValueA(inEXBRBP.PDI3: BRBPPDI3);
    BRBPBAS3 = l_FirstValueA(inEXBRBP.BAS3: BRBPBAS3);

    BRBPKON4 = l_FirstValueA(inEXBRBP.KON4: BRBPKON4);
    BRBPKOW4 = l_FirstValueS(inEXBRBP.KOW4: BRBPKOW4);
    BRBPPRZ4 = l_FirstValueA(inEXBRBP.PRZ4: BRBPPRZ4);
    BRBPPDI4 = l_FirstValueA(inEXBRBP.PDI4: BRBPPDI4);
    BRBPBAS4 = l_FirstValueA(inEXBRBP.BAS4: BRBPBAS4);

    BRBPKON5 = l_FirstValueA(inEXBRBP.KON5: BRBPKON5);
    BRBPKOW5 = l_FirstValueS(inEXBRBP.KOW5: BRBPKOW5);
    BRBPPRZ5 = l_FirstValueA(inEXBRBP.PRZ5: BRBPPRZ5);
    BRBPPDI5 = l_FirstValueA(inEXBRBP.PDI5: BRBPPDI5);
    BRBPBAS5 = l_FirstValueA(inEXBRBP.BAS5: BRBPBAS5);

    BRBPWACD = l_FirstValueA(inEXBRBP.WACD: BRBPWACD);
    BRBPNESU = l_FirstValueS(inEXBRBP.NESU: BRBPNESU);
    BRBPMWCD = l_FirstValueA(inEXBRBP.MWCD: BRBPMWCD);
    BRBPBLPO = l_FirstValueS(inEXBRBP.BLPO: BRBPBLPO);
    BRBPFENR = l_FirstValueA(inEXBRBP.FENR: BRBPFENR);
    BRBPFFLD = l_FirstValueA(inEXBRBP.FFLD: BRBPFFLD);

    /if not defined(alt)
    BRBPWEJJ = l_FirstValueS(inEXBRBP.WEJJ: BRBPWEJJ);
    BRBPWENR = l_FirstValueA(inEXBRBP.WENR: BRBPWENR);
    /endif
    //BRBPWBKT = l_FirstValueA(inEXBRBP.WBKT: BRBPWBKT);
    //BRBPEBKT = l_FirstValueA(inEXBRBP.EBKT: BRBPEBKT);
    /if not defined(alt)
    BRBPKSST = l_FirstValueA(inEXBRBP.KSST: BRBPKSST);
    BRBPKOTR = l_FirstValueA(inEXBRBP.KOTR: BRBPKOTR);
    /endif
    // .. und weitere

  // so: LS-Bezug IMMER clearen!:
  clear BRBPLIJJ;
  clear BRBPLINR;

  BRBPJNAM = DAJNAM;
  BRBPPROG = WKCHPN;
  BRBPBIBL = WKCHPL;
  BRBPUSER = DAUSER;

  BRBPJZEI = %DEC(%TIME());
  BRBPJDAT = %DEC(%DATE:*ISO);

  SELECT;
  WHEN CHI(6) = *ON;
    CHIDS  = '01W';
    EXSR CHBRBP;
  WHEN CHI(6) = *OFF;
    CHIDS  = '01U';
    EXSR CHBRBP;
  ENDSL;

  return;
  /copy QCPYSRC,CHBRBP
END-PROC;
//*****************************************************************************
// Update DCEX: BLID als DCID für DANA='BRBK' speichern
//*****************************************************************************
dcl-proc lcl_DCEX;
  dcl-pi *n;
    inEXBRBK       likeds(EXBRBK_t);
    inDCID         varchar(32) value;
  END-PI;

  dcl-ds DCEX      ext inz end-ds;
  dcl-ds KYDCEX    ext inz end-ds;

    KYDCEXFIRM = DAFIRM;
    KYDCEXDANA = 'BRBK';
    KYDCEXJHJJ = inEXBRBK.RGJJ;
    KYDCEXNMKR = inEXBRBK.RGNR;
    // KYDCEXPOSI = *ZERO;
    // KYDCEXUPOS = *ZERO;
    // KYDCEXKDLI = *BLANK;
    // KYDCEXTENR = *BLANK;
    // KYDCEXFLGE = *ZERO;

    CHIDS = '01CU';
    EXSR CHDCEX;

    DCEXDCID = inEXBRBK.BLID;

    DCEXJNAM = DAJNAM;
    DCEXPROG = WKCHPN;
    DCEXBIBL = WKCHPL;
    // DCEXUSER = DAUSER;

    DCEXJZEI = %DEC(%TIME());
    DCEXJDAT = %DEC(%DATE:*ISO);

    SELECT;
    WHEN CHI(6) = *ON;
      // C_EXTSTP(DCEXTSTP);
      // DCEXERUS = DAUSER;
      CHIDS  = '01W';
      EXSR CHDCEX;

    WHEN CHI(6) = *OFF;
      CHIDS  = '01U';
      EXSR CHDCEX;

    ENDSL;

    return;

  /copy QCPYSRC,CHDCEX
END-PROC;
//*****************************************************************************
dcl-proc l_RefNrToString;
  dcl-pi *n        varchar(12);
    inJAHR         zoned(4) value;
    inNMKR         char(6) value;
  END-PI;

  if inJAHR > *zero;
    return %char(inJAHR) + '/' + %trim(inNMKR);
  else;
    return '';
  ENDIF;

END-PROC;
//*****************************************************************************
dcl-proc l_TrimNmKr;
  dcl-pi *n        varchar(10);
    inVal          varchar(10) value;
  end-pi;
  dow %len(inVal) > 1
  and (%subst(inVal: 1: 1) = '0' or %subst(inVal: 1: 1) = '/');
    inVal = %subst(inVal: 2);
  ENDDO;
  return inVal;
END-PROC;
//*****************************************************************************
dcl-proc l_FirstValueA;
  dcl-pi *n        varchar(50);
    inVal1         varchar(50) value;
    inVal2         varchar(50) value;
  END-PI;
  if inVal1 > *blank;
    return inVal1;
  ENDIF;
  return inVal2;
END-PROC;
//*****************************************************************************
dcl-proc l_FirstValueS;
  dcl-pi *n        zoned(15: 4);
    inVal1         zoned(15: 4) value;
    inVal2         zoned(15: 4) value;
  END-PI;
  if inVal1 > *zero;
    return inVal1;
  ENDIF;
  return inVal2;
END-PROC;
//*****************************************************************************
dcl-proc l_GetMWStCode;
  dcl-pi *n        char(2);
    inPercent      zoned(11: 5) value;
    inDatum        zoned(8) value;
    inCode         varchar(3) value;
  END-PI;

  dcl-s WKMWCD     char(2) inz;
  dcl-s WKVSCD     char(3) inz;

  WKVSCD = 'V' + %trim(inCode);
  exec sql select MWSTMWCD
          into :WKMWCD
            from MWSt where MWSTFIRM = :DAFIRM
            and MWSTSATZ = :inPercent
            and MWSTGADA <= :inDatum
            and MWSTVSCD = :WKVSCD
            order by MWSTGADA desc
            fetch first row only;

  if sqlcode=100 and glb.ENVI = 'TEST';
  exec sql select MWSTMWCD
          into :WKMWCD
            from tvpf.MWSt where MWSTFIRM = :DAFIRM
            and MWSTSATZ = :inPercent
            and MWSTGADA <= :inDatum
            and MWSTVSCD = :WKVSCD
            order by MWSTGADA desc
            fetch first row only;
  ENDIF;
  return WKMWCD;
END-PROC;
//*****************************************************************************
// Test: Sätze aus ECHT nach TEST kopieren
//*****************************************************************************
dcl-proc lcl_EchtToTest;
  dcl-pi *n;
    inBEJJ         like(EKBEJJ) value;
    inBENR         like(EKBENR) value;
  END-PI;
   // Es wird genau EINE Bestellung kopiert!
   // ... nur die aktuell benötigte!

   // kopieren BBEK, BBEP, BWAE
   // NUMM: BENR, WENR
   // Ablauf:
   // 1. Lesen ECHT-BBEK
   // 2. prüfen TEST: falls frei -> ok
   //                 falls passend: -> ok
   //       - falls OK -> Satz in TEST löschen und aus ECHT kopieren
   // 3. Falls BBEK kopiert wurde, ALLE zugehörigen Sätze aus BBEP und BWAE
   //       - in TEST TEST löschen
   //       - von ECHTR nach TEST kopieren

   // Bestellungen aus ECHT selektieren, die äquivalent in der TEST sind:
   // Falls in der TEST-Umgebung neue Bestellungen erfasst wurden, so bleiben diese
   //    erhalten. Entsprechende Bestellungen aus ECHT werden dann nicht übertragen.
   // Nummerkreise-Werte in TEST ggf. ebenfalls aktualisieren!
   dcl-ds wk qualified inz;
     rrnECHT       int(10);
     rrnTEST       int(10);
     FIRM          like(DAFIRM);
     BEJJ          like(EKBEJJ);
     BENR          like(EKBENR);
     BENN          like(EKBENN);
     Matching      char(1);
     nummECHT      zoned(6);
     nummTEST      zoned(6);
     NUKR          char(10);
   END-DS;

   if glb.ENVI <> 'TEST';
     return;
   ENDIF;

   wk.NUKR = 'BENR';
   dou wk.NUKR > 'WENR';
     exec sql select echt.nummnumm, test.nummnumm
          into :wk.nummECHT, :wk.nummTEST
          from tamf.numm as Echt
          join tamftest.numm as test on echt.nummfirm=test.nummfirm
          and echt.nummjahr=test.nummjahr and echt.nummnukr=test.nummnukr
          where echt.nummfirm=:DAFIRM and echt.nummjahr=2023
          and echt.nummnukr = :wk.NUKR;
     if sqlcode <> *zero;
       leave;
     elseif sqlcode = *zero and wk.nummECHT > wk.nummTEST;
       exec sql update tamftest.numm set nummnumm = :wk.NummECHT
       where nummFIRM=:DAFIRM and NUMMNUKR=:wk.NUKR;
     ENDIF;
     if wk.NUKR = 'BENR';
       wk.NUKR = 'WENR';
     else;
       clear wk.NUKR;
       leave;
     endif;
   ENDDO;

   exec sql declare MOBBEX_CPY_BBEK cursor for
     select rrn(e), coalesce(rrn(t), 0),
     case
     when (t.eklfnr=e.eklfnr and t.ekbeda=e.ekbeda and t.EKBER1=e.EKBER1)
       then '1'
     else '0' end as matching,
     e.EKFIRM, e.EKBEJJ, e.EKBENR
     from TVPF.BBEK as e
     left outer
     join tvpftest.BBEK as t on t.EKFIRM=e.EKFIRM
        and t.EKBEJJ=e.EKBEJJ and t.EKBENR=e.EKBENR
     where e.EKBEJJ = :inBEJJ
     and   e.EKBENR = :inBENR;

   exec sql open MOBBEX_CPY_BBEK;

   dou %shtdn;
     exec sql FETCH MOBBEX_CPY_BBEK
       INTO :wk.rrnEcht, :wk.rrnTEST, :wk.matching,
       :wk.FIRM, :wk.BEJJ, :wk.BENR;
     if sqlcode <> *zero;
       leave;
     elseif wk.rrnTEST > *zero and wk.Matching <> '1';
       // Passende Bestellung.. aber unterschiedliche Inhalte -> nicht kopieren
       iter;
     elseif wk.rrnTEST > *zero;
       exec sql delete from TVPFTEST.BBEK as t where rrn(t)=:wk.rrnTEST;
     ENDIF;
     //exec sql INSERT INTO TVPFTEXT.BBEK (x)  VALUES(:var, 'value');
     exec sql INSERT INTO TVPFTEST.BBEK select * from TVPF.BBEK as e
         where rrn(e) = :wk.rrnECHT;

     // und dann die Positionssätze:
     exec sql delete from TVPFTEST.BBEP as t
       where EPFIRM=:wk.FIRM and EPBEJJ=:wk.BEJJ and EPBENR=:wk.BENR;
     exec sql INSERT INTO TVPFTEST.BBEP select * from TVPF.BBEP as e
       where e.EPFIRM=:wk.FIRM and e.EPBEJJ=:wk.BEJJ and e.EPBENR=:wk.BENR;

     exec sql delete from TVPFTEST.BWAE as t
       where AEFIRM=:wk.FIRM and AEBEJJ=:wk.BEJJ and AEBENR=:wk.BENR;
     exec sql INSERT INTO TVPFTEST.BWAE select * from TVPF.BWAE as e
       where e.AEFIRM=:wk.FIRM and e.AEBEJJ=:wk.BEJJ and e.AEBENR=:wk.BENR;

   ENDDO;

   exec sql close MOBBEX_CPY_BBEK;

END-PROC;
//*****************************************************************************
// Ende des Programms
//*****************************************************************************
