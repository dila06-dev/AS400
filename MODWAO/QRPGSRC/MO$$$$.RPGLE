**free
//------------------------------------------------------------------------------
/title Programm für die kundenspezifische Prüfungen und Ermittlungen
//------------------------------------------------------------------------------
//  Copyright 2019 by    trend SWM
//                       Verwaltung GmbH
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//------------------------------------------------------------------------------
//  Erstellt: XY 18.08.2020 trend SWM, Projekt 13511-15
//------------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX XXX
//------------------------------------------------------------------------------
//  Beschreibung:
//
//  Welche Kundenspezifischen Zugriffe werden mit diesem Programm durchgeführt.
//  Wo ist der Aufruf integriert?
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(MO$$$$);

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
dcl-ds $$$$ ext inz end-ds;
dcl-ds KY$$$$ ext inz end-ds;

dcl-ds TRPA ext inz end-ds;
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
dcl-s DS$$$$QQQQ like($$$$QQQQ);
dcl-s DS$$$$YYYY like($$$$YYYY);

// /include QCPYSRC,TREND
dcl-pr MO$$$$  extpgm('MO$$$$');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc MO$$$$;
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

//------------------------------------------------------------------------------
//  Programmsteuerung
//------------------------------------------------------------------------------
  select;
  when PCPGST = 'PR$$$$';
    exsr PR$$$$;
  when PCPGST = 'ER$$$$';
    exsr ER$$$$;
  endsl;

  #EXTREND = EXTREND;
  #RTTREND = RTTREND;

  return;
  *INLR = *ON;

//------------------------------------------------------------------------------
//  Eröffnungszyklus
//------------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;
    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    KY$$$$FIRM = DAFIRM; // $$$$
    KYTAFI = DAFIRM;     // TRPA
  endsr;

//------------------------------------------------------------------------------
//  Uebernahme Kommunikationsparamter EXTREND
//------------------------------------------------------------------------------
  begsr UEBTREND;

    //Übernahme der Aufrufparameter in die interne Datenstrukturen
    EXTREND = #EXTREND;
    RTTREND = #RTTREND;

    PCPGST = EXTRNDPGST;
    DS$$$$QQQQ = %SUBST(EXTRNDKEYB:1);
    DS$$$$YYYY = %SUBST(EXTRNDKEYB:11);

    clear RTTREND;
    RTTRNDFENR = *ZERO;

  endsr;

//------------------------------------------------------------------------------
//  Vorlauf
//------------------------------------------------------------------------------
  begsr VORLAUF;

    DAFEHL = *BLANK;
    ##RTCD = *BLANK;
    #CRTCD = *BLANK;

  endsr;

//------------------------------------------------------------------------------
//  Kundenspezifische Prüfung
//------------------------------------------------------------------------------
  begsr PR$$$$;

    WKFENR = *ZERO;
    KY$$$$QQQQ = DS$$$$QQQQ;
    KY$$$$YYYY = DS$$$$YYYY;
    CHIDS = '01C';

    exsr CH$$$$;
    if $$$$ZZZZ <> 'XYZ';
      WKFENR = '9900';
    endif;

    clear RTTREND;
    RTTRNDFENR = WKFENR;

  endsr;

//------------------------------------------------------------------------------
//  Ermitteln $$$$
//------------------------------------------------------------------------------
  begsr ER$$$$;

    KY$$$$QQQQ = DS$$$$QQQQ;
    KY$$$$YYYY = DS$$$$YYYY;
    CHIDS = '01C';
    exsr CH$$$$;

    clear RTTREND;
    RTTRNDFENR = *ZERO;
    %SUBST(RTTRNDDATE:01:10)= $$$$QQQQ;
    %SUBST(RTTRNDDATE:11:10)= $$$$YYYY;
    %SUBST(RTTRNDDATE:21:10)= $$$$ZZZZ;

  endsr;

//------------------------------------------------------------------------------
//  Ermitteln Parameterwerte
//------------------------------------------------------------------------------
  begsr ETRPA;

    WKTRPA = *ON;

  endsr;

//------------------------------------------------------------------------------
//  COPY-Module
//------------------------------------------------------------------------------

/copy QCPYSRC,CH$$$$
/copy QCPYSRC,CHTRPA
/copy QCPYSRC,EXJOBA
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
