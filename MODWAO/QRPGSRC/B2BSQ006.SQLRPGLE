**free
//------------------------------------------------------------------------------
/TITLE SQL-CALL für die Ermittlung der Auftragsdetail-Informationen
//------------------------------------------------------------------------------
//  Copyright 2025 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//  ----------------------------------------------------------------------------
//  Erstellt: PH 18.06.Projekt Dometic Germany - B2B (Case #03777387)
//            ID 6.1 "Order History Details"
//  ----------------------------------------------------------------------------
//  Änderung: PH 25.06.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 6.1 "Order History Details". E-Mail von RR vom 25.06.2025:
//            Korrektur Schreibfehler: WKAFKOSTAT = 'CLOSED' statt 'CLOSESD'.
//  Änderung: PH 10.09.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 6.1 "Order History Details". Zu WKSUBTOTAL noch RTANGPW1 +
//            RTANGPW2 + RTANGPW3 (Grüner Punkt-Werte) dazuaddieren.
//  Änderung: PH 10.09.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 6.1 "Order History Details". Übergeben 'B2BSQ006' statt
//            'TRAFMS' an EXAFKN.EXANPROG.
//  Änderung: PH 11.09.2025 Projekt Dometic Germany - B2B (Case #03777387)
//            ID 6.1 "Order History Details". WKINVOICEAMOUNT runden analog PTBRSU in XLAFKO01
//  ----------------------------------------------------------------------------
//
//  Dieses Programm wird per SQL aufgerufen, ermittelt und berechnet bestimmte
//  Auftragsdetail-Informationen.
//
//  Übergabeparameter:
//  #FIRM      - Firma
//  #KDNR      - Kunden-Nr
//  #AFJJNR    - KD-AuftragsäJahr/Nr
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
ctl-opt main(B2BSQ006);
/include QCPYSRC,CTLOPTIONS

//------------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------------
/if defined(never)
/include QSYSINC/QRPGLESRC,QUSEC
/endif
/include QCPYSRC,EXPSDS
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSTRING
/include QCPYSRC,SXTYPES
/include QCPYSRC,SXTRPA

//------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//------------------------------------------------------------------------------
/include QCPYSRC,EXTRBR

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds FIRM   ext inz end-ds;
dcl-ds KYFIRM ext inz end-ds;

dcl-ds AFAD   ext inz end-ds;
dcl-ds KYAFAD ext inz end-ds;

dcl-ds AFKO   ext inz end-ds;
dcl-ds KYAFKO ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;

dcl-ds EXAFKN ext inz end-ds;
dcl-ds RTAFKN ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
// Rückgabewert an das SQL
dcl-ds RESULT dim(100) qualified;
  AFKOKDNR             like(WKAFKOKDNR);
  AFKOREF1             like(WKAFKOREF1);
  AFKOEIDA             like(WKAFKOEIDA);
  AFKOBEAR             like(WKAFKOBEAR);
  AFKOWACD             like(WKAFKOWACD);
  AFKOZABD             like(WKAFKOZABD);
  STATUS               like(WKAFKOSTAT); // 90+94 = CLOSED, ansonsten OPEN
  ORDERNUMBER          like(WKAFJJNR);
  SUBTOTAL             like(WKSUBTOTAL);
  SALESTAX1            like(WKSALESTAX1);
  SALESTAX2            like(WKSALESTAX2);
  INVOICEAMOUNT        like(WKINVOICEAMOUNT);
  INVOICEADRESSSTREET  like(WKINVOICEADRESSSTREET);
  INVOICEADRESSZIPCODE like(WKINVOICEADRESSZIPCODE);
  INVOICEADRESSCITY    like(WKINVOICEADRESSCITY);
  INVOICEADRESSCO      like(WKINVOICEADRESSCO);
  CUSTOMERNAME         like(WKCUSTOMERNAME);
  SHIPTOADRESSSTREET   like(WKSHIPTOADRESSSTREET);
  SHIPTOADRESSZIPCODE  like(WKSHIPTOADRESSZIPCODE);
  SHIPTOADRESSCITY     like(WKSHIPTOADRESSCITY);
  SHIPTOADRESSCO       like(WKSHIPTOADRESSCO);
  ERRMSG               varchar(10);
end-ds;

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s RowCount   uns(5);
dcl-s ##CHI      char(8);
dcl-s WKFENR     char(4);
dcl-s WKFIRM     varchar(2);
dcl-s WKKDNR     varchar(10);
dcl-s WKAFKOSTAT varchar(6);
dcl-s WKAFJJNR   char(11);
dcl-s WKSUBTOTAL             zoned(11:2);
dcl-s WKSALESTAX1            zoned(11:2);
dcl-s WKSALESTAX2            zoned(11:2);
dcl-s WKINVOICEAMOUNT        zoned(11:2);
dcl-s WKINVOICEADRESSSTREET  varucs2(50);
dcl-s WKINVOICEADRESSZIPCODE varchar(10);
dcl-s WKINVOICEADRESSCITY    varucs2(50);
dcl-s WKINVOICEADRESSCO      varucs2(50);
dcl-s WKCUSTOMERNAME         varucs2(50);
dcl-s WKSHIPTOADRESSSTREET   varucs2(50);
dcl-s WKSHIPTOADRESSZIPCODE  varchar(10);
dcl-s WKSHIPTOADRESSCITY     varucs2(50);
dcl-s WKSHIPTOADRESSCO       varucs2(50);

dcl-s WKTRPAMWST like(EXAFKNMWS1);
dcl-s WKAFKOKDNR varchar(10);
dcl-s WKAFKOREF1 varchar(30);
dcl-s WKAFKOEIDA like(AKEIDA);
dcl-s WKAFKOBEAR varchar(1);
dcl-s WKAFKOWACD varchar(3);
dcl-s WKAFKOZABD varchar(3);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
//--------------------------------------------------
// Program name: C_VEAFKN
// Purpose:
// Returns:
// Parameter:    #EXTR02
// Parameter:    #EXAFKN
// Parameter:    #RTAFKN
//--------------------------------------------------
dcl-pr C_VEAFKN  extpgm('VEAFKN');
  #EXTR02        likeds(EXTR02);
  #EXAFKN        likeds(EXAFKN);
  #RTAFKN        likeds(RTAFKN);
end-pr;


//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc B2BSQ006;
  dcl-pi *n;
    #FIRM like(WKFIRM);
    #KDNR like(WKKDNR);
    #AFJJNR like(WKAFJJNR);
  end-pi;

  // Übernahme der Aufrufparameter in die internen Felder
  WKFIRM = #FIRM;
  WKKDNR = #KDNR;
  WKAFJJNR = #AFJJNR;

  in EXTRLD;

  if WKFIRM = *BLANK;
    // Defaultwert Firmennummer
    WKFIRM = '01';
  endif;

  // Setzen Datenstationsarbeitsbereich
  if DAFIRM <> WKFIRM;
    KYFIRMFIRM = WKFIRM;
    CHIDS = '01C';
    exsr CHFIRM;

    DAFIRM = FIRMFIRM;
    DASPCD = FIRMSPCD;
    DAJNKZ = FIRMJAKZ;
    DANEKZ = FIRMNEKZ;
    out EXTRLD;
  endif;

  exsr ANFANG;
  exsr ETRPA;

  // Berechnen Schlusskonditionen inklusive MwSt
  exsr VEAFKN;

  // Ermitteln Auftraggeber-Adresse (InvoiceAdress)
  exsr ERADAG;

  // Ermitteln Versandadresse (ShipToAdress)
  exsr ERADVS;

  WKFENR = *ZERO;
  RowCount = *ZERO;
  clear RESULT;

  RowCount += 1;
  RESULT(RowCount).AFKOKDNR = WKAFKOKDNR;
  RESULT(RowCount).AFKOREF1 = WKAFKOREF1;
  RESULT(RowCount).AFKOEIDA = WKAFKOEIDA;
  RESULT(RowCount).AFKOBEAR = WKAFKOBEAR;
  RESULT(RowCount).AFKOWACD = WKAFKOWACD;
  RESULT(RowCount).AFKOZABD = WKAFKOZABD;
  RESULT(RowCount).STATUS = WKAFKOSTAT;
  RESULT(RowCount).ORDERNUMBER = WKAFJJNR;

  RESULT(RowCount).SUBTOTAL = WKSUBTOTAL;
  RESULT(RowCount).SALESTAX1 = WKSALESTAX1;
  RESULT(RowCount).SALESTAX2 = WKSALESTAX2;
  RESULT(RowCount).INVOICEAMOUNT = WKINVOICEAMOUNT;

  RESULT(RowCount).INVOICEADRESSSTREET = %trim(WKINVOICEADRESSSTREET);
  RESULT(RowCount).INVOICEADRESSZIPCODE = %trim(WKINVOICEADRESSZIPCODE);
  RESULT(RowCount).INVOICEADRESSCITY = %trim(WKINVOICEADRESSCITY);
  RESULT(RowCount).INVOICEADRESSCO = %trim(WKINVOICEADRESSCO);
  RESULT(RowCount).CUSTOMERNAME = %trim(WKCUSTOMERNAME);

  RESULT(RowCount).SHIPTOADRESSSTREET = %trim(WKSHIPTOADRESSSTREET);
  RESULT(RowCount).SHIPTOADRESSZIPCODE = %trim(WKSHIPTOADRESSZIPCODE);
  RESULT(RowCount).SHIPTOADRESSCITY = %trim(WKSHIPTOADRESSCITY);
  RESULT(RowCount).SHIPTOADRESSCO = %trim(WKSHIPTOADRESSCO);

  RESULT(RowCount).ERRMSG = '';

  // Rückgabe Resultset (Zeilen) an SQL-Aufrufendes-Programm:
  EXEC SQL
  SET RESULT SETS FOR RETURN TO CLIENT ARRAY :RESULT FOR :RowCount ROWS;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    KYADFI = DAFIRM;     // AFAD
    KYAKFI = DAFIRM;     // AFKO

  endsr;

  //----------------------------------------------------------------------------
  //  Berechnen der Schlusskonditionen inklusive MwSt
  //----------------------------------------------------------------------------
  begsr VEAFKN;

    clear WKAFKOKDNR;
    clear WKAFKOREF1;
    clear WKAFKOEIDA;
    clear WKAFKOBEAR;
    clear WKAFKOWACD;
    clear WKAFKOZABD;
    clear WKAFKOSTAT;

    clear WKSUBTOTAL;
    clear WKSALESTAX1;
    clear WKSALESTAX2;
    clear WKINVOICEAMOUNT;

    clear WKINVOICEADRESSSTREET;
    clear WKINVOICEADRESSZIPCODE;
    clear WKINVOICEADRESSCITY;
    clear WKINVOICEADRESSCO;
    clear WKCUSTOMERNAME;
    clear WKSHIPTOADRESSSTREET;
    clear WKSHIPTOADRESSZIPCODE;
    clear WKSHIPTOADRESSCITY;
    clear WKSHIPTOADRESSCO;

    KYAKJH = trdec(%subst(WKAFJJNR: 1: 4));
    KYAKAF = %subst(WKAFJJNR: 6: 6);
    CHIDS  = '01C';
    exsr CHAFKO;

    WKAFKOKDNR = %trim(AKKDNR);
    WKAFKOREF1 = %trim(AKREF1);
    WKAFKOEIDA = AKEIDA;
    WKAFKOBEAR = AKBEAR;
    WKAFKOWACD = %trim(AKWACD);
    WKAFKOZABD = %trim(AKZABD);

    WKAFKOSTAT =  'OPEN';
    IF AKAFST = '90' OR AKAFST = '94';
      WKAFKOSTAT = 'CLOSED';
    ENDIF;

    clear EXAFKN;
    clear RTAFKN;
    EXANPROG = 'TRAFMS';
    EXANPROG = 'B2BSQ006';
    EXANDANA = 'AFKO';
    EXANAFJJ = trdec(%subst(WKAFJJNR: 1: 4));
    EXANAFNR = %subst(WKAFJJNR: 6: 6);
    EXAFKNLDNR = AKVSLD;
    EXAFKNMWS1 = WKTRPAMWST;
    EXANZABD = *BLANK;
    EXANAFKN = *ON;
    EXANMWST = *ON;
    EXANSKTO = *OFF;
    #CKOMM = *BLANK;
    C_VEAFKN(EXTR02:EXAFKN:RTAFKN);
    if RTANFENR = *ZERO;
      WKSUBTOTAL = RTANNES1 + RTANER11 + RTANER12 + RTANER13 + RTANER14;
      WKSUBTOTAL += RTANGPW1 + RTANGPW2 + RTANGPW2;
      WKSALESTAX1 = RTANMWS1;
      WKSALESTAX2 = RTANMWS2;
      WKINVOICEAMOUNT = WKSUBTOTAL + RTANMWS1 + RTANMWS2;
      if WKINVOICEAMOUNT <> *ZERO;
        %subst(#CKOMM:01) = AKWACD;
        #CKOMM = decToAlnum(WKINVOICEAMOUNT: 15: 2: 04: #CKOMM);
        %subst(#CKOMM:34:1) = '1';
        exsr TRRUND;
        if WKFENR = *ZERO;
          WKINVOICEAMOUNT = alnumToDec(#CKOMM: 15: 2: 04);
        endif;
      endif;

    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Auftraggeber-Adresse (InvoiceAdress)
  //----------------------------------------------------------------------------
  begsr ERADAG;

    clear WKINVOICEADRESSSTREET;
    clear WKINVOICEADRESSZIPCODE;
    clear WKINVOICEADRESSCITY;
    clear WKINVOICEADRESSCO;
    clear WKCUSTOMERNAME;

    KYADJH = trdec(%subst(WKAFJJNR: 1: 4));
    KYADAF = %subst(WKAFJJNR: 6: 6);
    KYADPO = *ZERO;
    KYADAA = 'ADAG';
    CHIDS  = '01C';
    exsr CHAFAD;
    if chi(5) = 'J';
      WKINVOICEADRESSSTREET = ADSTRA;
      WKINVOICEADRESSZIPCODE = ADPOLZ;
      WKINVOICEADRESSCITY = ADWORT;
      WKINVOICEADRESSCO = %TRIM(ADNAM1) +' '+ %TRIM(ADNAM2);
      WKCUSTOMERNAME = %TRIM(ADNAM1) +' '+ %TRIM(ADNAM2);

    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Versand-Adresse (ShipToAdress)
  //----------------------------------------------------------------------------
  begsr ERADVS;

    clear WKSHIPTOADRESSSTREET;
    clear WKSHIPTOADRESSZIPCODE;
    clear WKSHIPTOADRESSCITY;
    clear WKSHIPTOADRESSCO;

    KYADJH = trdec(%subst(WKAFJJNR: 1: 4));
    KYADAF = %subst(WKAFJJNR: 6: 6);
    KYADPO = *ZERO;
    KYADAA = 'ADVS';
    CHIDS  = '01C';
    exsr CHAFAD;
    if chi(5) = 'N';
      KYADJH = trdec(%subst(WKAFJJNR: 1: 4));
      KYADAF = %subst(WKAFJJNR: 6: 6);
      KYADPO = *ZERO;
      KYADAA = 'ADAG';
      CHIDS  = '01C';
      exsr CHAFAD;
    endif;
    if chi(5) = 'J';
      WKSHIPTOADRESSSTREET = ADSTRA;
      WKSHIPTOADRESSZIPCODE = ADPOLZ;
      WKSHIPTOADRESSCITY = ADWORT;
      WKSHIPTOADRESSCO = %TRIM(ADNAM1) +' '+ %TRIM(ADNAM2);
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPAMWST = getTRPACode('TRAFMS': 'DEFAULT': 'MWST');

  endsr;

  //---------------------------------------------------------------------------
  //  COPY-Module
  //---------------------------------------------------------------------------
  /include QCPYSRC,CHAFAD
  /include QCPYSRC,CHAFKO
  /include QCPYSRC,CHFIRM
  /include QCPYSRC,TRRUND
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
