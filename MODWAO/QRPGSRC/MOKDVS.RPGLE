**free
//------------------------------------------------------------------------------
/title Programm für die kundenspezifischen Prüfungen, Ermittlungen und sonstige
/title kundenspeziellen Steuerungen in Bezug auf die KDVS "Kunden-Versand-Adresse"
//------------------------------------------------------------------------------
//  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//------------------------------------------------------------------------------
//  Erstellt: PH 10.12.2024 Case #03813644
//------------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX XXX
//  Änderung: PH 04.06.2025 Projekt Dometic Germany - B2B (Case #03777387). Aktualisieren das
//            Änderung-Job-Datum/die letzte Änderungs-Job-Zeit in der Update-Routine "UPVSST".
//------------------------------------------------------------------------------
//  Beschreibung:
//
//  PCPGST = 'UPVSST' Update Status KDVS,VSVSST mit dem von extern übergebenen Wert
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(MOKDVS);

//------------------------------------------------------------------------------
//  Tabellen und Feldgruppen
//------------------------------------------------------------------------------
/copy QCPYSRC,EXTRDR

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds TRPA   ext inz end-ds;
dcl-ds KYTRPA ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;
dcl-ds EXTR03 ext inz end-ds;

dcl-ds EXTREND ext end-ds;
dcl-ds RTTREND ext end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
/copy QCPYSRC,EXTRIN

//------------------------------------------------------------------------------
//  Programmstatus Datenstruktur
//------------------------------------------------------------------------------
/copy QCPYSRC,EXPSDS

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
dcl-s ##CHI char(8);
dcl-s ##RTCD char(1);
dcl-s ##PGST char(1);
dcl-s WKRTCD char(1);
dcl-s WKTRTP char(1);
dcl-s WKTRPA char(1);
dcl-s WKI000 char(1);
dcl-s WKFENR char(4);
dcl-s I0 zoned(3:0);
dcl-s I1 zoned(3:0);
dcl-s I2 zoned(3:0);
dcl-s WKFIRM like(DAFIRM);
dcl-s WKUSER like(DSUSER);
dcl-s WKJDAT like(DSJDAT);
dcl-s WKJZEI like(DSJZEI);
dcl-s PCPGST like(#CPGST);
dcl-s WKPROG like(RTTRNDPROG);
dcl-s WKDANA like(RTTRNDDANA);
dcl-s WKFFLD like(RTTRNDFFLD);
dcl-s DSKDVSKDNR like(VSKDNR);
dcl-s DSKDVSVSNR like(VSVSNR);

// /include QCPYSRC,TREND
dcl-pr MOKDVS  extpgm('MOKDVS');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc MOKDVS;
  dcl-pi *n;
    #EXTREND likeds(EXTREND);
    #RTTREND likeds(RTTREND);
  end-pi;

  exsr UEBTREND;
  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
  endif;

  exsr EXJOBA;

  if WKFIRM <> DAFIRM;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //----------------------------------------------------------------------------
  //  Programmsteuerung
  //----------------------------------------------------------------------------
  select;
  when PCPGST = 'UPVSST';
    exsr UPVSST;
  endsl;

  #EXTREND = EXTREND;
  #RTTREND = RTTREND;

  return;
  *INLR = *ON;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;
    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    KYVSFI = DAFIRM;     // KDVS
    KYTAFI = DAFIRM;     // TRPA

  endsr;

  //----------------------------------------------------------------------------
  //  Uebernahme Kommunikationsparamter EXTREND
  //----------------------------------------------------------------------------
  begsr UEBTREND;

    //Übernahme der Aufrufparameter in die interne Datenstrukturen
    EXTREND = #EXTREND;
    RTTREND = #RTTREND;

    PCPGST = EXTRNDPGST;
    DSKDVSKDNR = %SUBST(EXTRNDKEYB:01);
    DSKDVSVSNR = %SUBST(EXTRNDKEYB:11);

    clear RTTREND;
    RTTRNDFENR = *ZERO;

  endsr;

  //----------------------------------------------------------------------------
  //  Vorlauf
  //----------------------------------------------------------------------------
  begsr VORLAUF;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    #CRTCD = *BLANK;

  endsr;

  //----------------------------------------------------------------------------
  //  SR-UPKDST  Updaten LF-Status KDVS.VSVSST
  //----------------------------------------------------------------------------
  begsr UPVSST;

    KYVSKD = DSKDVSKDNR;
    KYVSNR = DSKDVSVSNR;
    CHIDS = '01CU';
    exsr CHKDVS;
    if CHI(5) = 'J';
      VSVSST = %subst(EXTRNDDATE:01);
      VSJNAM = DAJNAM;
      VSPROG = DAPROG;
      VSBIBL = WKCHPL;
      VSUSER = DAUSER;
      VSJZEI = %dec(%time());
      VSJDAT = %dec(%date():*ISO);
      CHIDS = '01U';
      exsr CHKDVS;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Ermitteln Parameterwerte
  //----------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPA = *ON;

  endsr;

//------------------------------------------------------------------------------
//  COPY-Module
//------------------------------------------------------------------------------
/copy QCPYSRC,CHKDVS
/copy QCPYSRC,CHTRPA
/copy QCPYSRC,EXJOBA
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
