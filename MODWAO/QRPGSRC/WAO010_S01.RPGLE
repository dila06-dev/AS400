**free
//------------------------------------------------------------------------------
/title Programm zum Updaten des Status in KUND/KDVS/LIEF/AFKO/BBEK/AGKO/BAGK
/title aufgrund des Status BOYHSTAT
//------------------------------------------------------------------------------
//  Copyright 2024 by    trend SWM EDV-Beratung GmbH & Co. KG
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//------------------------------------------------------------------------------
//  Erstellt: PH 03.12.2024 Case #03813644
//------------------------------------------------------------------------------
//  Änderung: XX XX.XX.XXXX
//------------------------------------------------------------------------------
//  Beschreibung:
//
//  Das Programm wird aos dem Programm WAO010CL aufgerufen, welches die Umgebung
//  für die Verarbeitung der trend-Dateien setzt und den Zeitstempel als Zugriffs-
//  schlüssel für die Datei BOYH an dieses Programm durchreicht (Feld BOYHTSTP).
//  Mit diesem Schlüssel greift das Programm auf den entsprechenden BOYH-Satz zu und,
//  sofern dieser den Status BOYHSTAT = '90' hat, den Status in der entsprechenden
//  trend-Datei (KUND/KDVS/LIEF/AFKO/BBEK/AGKO/BAGK) auf '99' = "Sanktionssperre"
//  und dann den Status BOYHSTAT auf '95' setzt.
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(WAO010);

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
dcl-ds AFKO   ext inz end-ds;
dcl-ds KYAFKO ext inz end-ds;

dcl-ds AGKO   ext inz end-ds;
dcl-ds KYAGKO ext inz end-ds;

dcl-ds BAGK   ext inz prefix(BAGK:2) end-ds;
dcl-ds KYBAGK ext inz prefix(BAGK) end-ds;

dcl-ds BBEK   ext inz end-ds;
dcl-ds KYBBEK ext inz end-ds;

dcl-ds BOYH   ext inz end-ds;
dcl-ds KYBOYH ext inz end-ds;

dcl-ds KDVS   ext inz end-ds;
dcl-ds KYKDVS ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds LIEF   ext inz end-ds;
dcl-ds KYLIEF ext inz end-ds;

dcl-ds TRPA   ext inz end-ds;
dcl-ds KYTRPA ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;
dcl-ds EXTR03 ext inz end-ds;

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

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
dcl-pr WAO010  extpgm('WAO010');
  #KYBOYHTSTP char(26);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc WAO010;
  dcl-pi *n;
    #KYBOYHTSTP char(26);
  end-pi;

  exsr UEBKYBOYHTSTP;
  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //----------------------------------------------------------------------------
  //  Programmsteuerung
  //----------------------------------------------------------------------------
  CHIDS = '01C';
  exsr CHBOYH;
  if CHI(5) = 'J' and BOYHSTAT = '90';
    select;
    when BOYHSZAR = *BLANK and BOYHDANA = 'KUND';
      exsr UKUND;
    when BOYHSZAR = 'ADAG' or BOYHSZAR = 'ADRE' or BOYHSZAR = 'ADVS'
      or BOYHSZAR = 'ADAB' or BOYHSZAR = 'ADEK' or BOYHSZAR = 'ADSP';
      exsr UAFKO;
    when BOYHSZAR = *BLANK and BOYHDANA = 'KDVS';
      exsr UKDVS;
    when BOYHDANA = 'AGAD' and BOYHSZAR = 'AGAD';
      exsr UAGKO;
    when BOYHSZAR = *BLANK and BOYHDANA = 'LIEF';
      exsr ULIEF;
    when BOYHSZAR = 'BBAD' or BOYHSZAR = 'BBEL' or BOYHSZAR = 'BBVS'
      or BOYHSZAR = 'BRLK';
      exsr UBBEK;
    when BOYHDANA = 'BAGA' and BOYHSZAR = 'BAGA';
      exsr UBAGK;
    endsl;
  endif;

  #KYBOYHTSTP = %char(KYBOYHTSTP);

  return;

//------------------------------------------------------------------------------
//  Eröffnungszyklus
//------------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;
    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    KYAKFI = DAFIRM;     // AFKO
    KYGKFI = DAFIRM;     // AGKO
    BAGKKYGKFI = DAFIRM; // BAGK
    KYEKFI = DAFIRM;     // BBEK
    KYBOYHFIRM = DAFIRM; // BOYH
    KYVSFI = DAFIRM;     // KDVS
    KYKDFI = DAFIRM;     // KUND
    KYLFFI = DAFIRM;     // LIEF
    KYTAFI = DAFIRM;     // TRPA

  endsr;

//------------------------------------------------------------------------------
//  Uebernahme Kommunikationsparamter KYBOYHTSTP
//------------------------------------------------------------------------------
  begsr UEBKYBOYHTSTP;

    //Übernahme der Aufrufparameter in die interne Datenstrukturen
    monitor;
      KYBOYHTSTP = %timestamp(#KYBOYHTSTP);
    on-error;
      clear KYBOYHTSTP;
    endmon;

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
  //  Update Status KUND
  //----------------------------------------------------------------------------
  begsr UKUND;

    KYKDNR = BOYHKDNR;
    CHIDS = '01CU';
    exsr CHKUND;
    if CHI(5) = 'J';
      KDKDST = '99';
      CHIDS = '01U';
      exsr CHKUND;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status AFKO
  //----------------------------------------------------------------------------
  begsr UAFKO;

    KYAKJH = BOYHJAHR;
    KYAKAF = BOYHNUKR;
    CHIDS = '01CU';
    exsr CHAFKO;
    if CHI(5) = 'J';
      AKAFST = '99';
      CHIDS = '01U';
      exsr CHAFKO;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status KDVS
  //----------------------------------------------------------------------------
  begsr UKDVS;

    KYVSKD = BOYHKDNR;
    KYVSNR = BOYHVSNR;
    CHIDS = '01CU';
    exsr CHKDVS;
    if CHI(5) = 'J';
      VSVSST = '99';
      CHIDS = '01U';
      exsr CHKDVS;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status AGKO
  //----------------------------------------------------------------------------
  begsr UAGKO;

    KYGKJH = BOYHJAHR;
    KYGKAG = BOYHNUKR;
    CHIDS = '01CU';
    exsr CHAGKO;
    if CHI(5) = 'J';
      GKAGST = '99';
      CHIDS = '01U';
      exsr CHAGKO;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status LIEF
  //----------------------------------------------------------------------------
  begsr ULIEF;

    KYLFNR = BOYHLFNR;
    CHIDS = '01CU';
    exsr CHLIEF;
    if CHI(5) = 'J';
      LFLFST = '99';
      CHIDS = '01U';
      exsr CHLIEF;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status BBEK
  //----------------------------------------------------------------------------
  begsr UBBEK;

    KYEKJH = BOYHJAHR;
    KYEKBE = BOYHNUKR;
    CHIDS = '01CU';
    exsr CHBBEK;
    if CHI(5) = 'J';
      EKBEST = '99';
      CHIDS = '01U';
      exsr CHBBEK;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status BAGK
  //----------------------------------------------------------------------------
  begsr UBAGK;

    BAGKKYGKJH = BOYHJAHR;
    BAGKKYGKAG = BOYHNUKR;
    CHIDS = '01CU';
    exsr CHBAGK;
    if CHI(5) = 'J';
      BAGKAGST = '99';
      CHIDS = '01U';
      exsr CHBAGK;

      exsr UBOYH;
    endif;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status BOYH
  //----------------------------------------------------------------------------
  begsr UBOYH;

    CHIDS = '01CU';
    exsr CHBOYH;
    if CHI(5) = 'J';
      BOYHSTAT = '95';
      CHIDS = '01U';
      exsr CHBOYH;
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
/copy QCPYSRC,CHAFKO
/copy QCPYSRC,CHAGKO
/copy QCPYSRC,CHBAGK
/copy QCPYSRC,CHBBEK
/copy QCPYSRC,CHBOYH
/copy QCPYSRC,CHKDVS
/copy QCPYSRC,CHKUND
/copy QCPYSRC,CHLIEF
/copy QCPYSRC,CHTRPA
/copy QCPYSRC,VRMVMONMSG
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
