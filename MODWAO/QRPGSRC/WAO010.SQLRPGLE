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
//  Änderung: PH 09.01.2025 Case #03813644. Überarbeitung des Programms. An das Programm
//            wird keine BOYHTSTP mehr übergeben, es werden alle BOYH-Sätze mit dem Status
//            BOYHSTAT = '90' gelesen.
//  Änderung: PH 05.02.2025 Case #03813644. Nachtrag/Verbesserung: Lesen BOYH mit dem Status
//            BOYHSTAT = '90' jetzt GRUPPIERT nach BOYHDANA, BOYHSZAR, BOYHKDNR, BOYHVSNR, BOYHLFNR,
//            BOYHJAHR, BOYHNUKR. Setzen den BOYHSTAT auf '95' in ALLEN BOYH-Sätzen (bisher nur
//            in einem) mit BOYHSTAT = '90' und dem gleichen Inhalt der obigen BOYH-Felder.
//  Änderung: PH 20.03.2025 Case #03813644. Nachtrag/Verbesserung: Wenn der Status in der jeweiligen
//            trend-Datei bereits auf '99' steht, dann den Status in den entsprechenden BOYH-Daten-
//            sätzen gleich auf '95' setzen und keine weitere Verarbeitung vornehmen (bisher blieben
//            die BOYH-Sätze in einem solchen Fall auf '90' stehen, was dazu führen konnte, dass,
//            nachdem der entsprechende Datensatz in der trend-Datei bzgl. der Sanktionssperre
//            wieder freigegeben worden wäre, dieser aufgrund der auf den Status '90' stehen
//            gebliebenen BOYH-Datensätze wieder automatisch gesperrt und somit die Freigabe
//            unabsichtlich wieder rückgängig gemacht worden wäre).
//  Änderung: PH 04.06.2025 Projekt Dometic Germany - B2B (Case #03777387).
//            Aktualisieren das Änderung-Job-Datum/die letzte Änderungs-Job-Zeit
//            für die Dateien KUND und KDVS.
//------------------------------------------------------------------------------
//  Beschreibung:
//
//  Das Programm wird aus dem Programm WAO010CL aufgerufen, welches die Umgebung für
//  die Verarbeitung der trend-Dateien setzt. Das Programm liest alle BOYH-Sätze mit
//  dem Status BOYHSTAT = '90', setzt den Status in der entsprechenden trend-Datei
//  (KUND/KDVS/LIEF/AFKO/BBEK/AGKO/BAGK) auf '99' = "Sanktionssperre", sofern die
//  Bedingungen dafür erfüllt sind, und anschließend den Status BOYHSTAT auf '95',
//  wenn der Status in der entsprechenden trend-Datei auf '99' gesetzt werden konnte.
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(WAO010);

//------------------------------------------------------------------------------
//  Includes
//------------------------------------------------------------------------------
/define TVORLAGE23
/include QCPYSRC,STDDR
/include QCPYSRC,SXSYSTEM
/include QCPYSRC,SXSQL

//------------------------------------------------------------------------------
//  Datenstationsarbeitsbereich
//------------------------------------------------------------------------------
//dcl-ds EXTRLD ext dtaara(*auto:*usrctl:*LDA) end-ds;

//------------------------------------------------------------------------------
//  Dateien
//------------------------------------------------------------------------------
dcl-ds AFKO   ext inz end-ds;
dcl-ds KYAFKO ext inz end-ds;

dcl-ds AFPA   ext inz end-ds;
dcl-ds KYAFPA ext inz end-ds;

dcl-ds AFPO   ext inz end-ds;
dcl-ds KYAFPO ext inz end-ds;

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
//dcl-ds EXTR01 ext inz end-ds;
//dcl-ds EXTR02 ext inz end-ds;
//dcl-ds EXTR03 ext inz end-ds;

//------------------------------------------------------------------------------
//  Interne Datenstruktur
//------------------------------------------------------------------------------
/copy QCPYSRC,EXTRIN

//------------------------------------------------------------------------------
//  Programmstatus Datenstruktur
//------------------------------------------------------------------------------
///copy QCPYSRC,EXPSDS

//------------------------------------------------------------------------------
//  Einzelfelder
//------------------------------------------------------------------------------
//dcl-s ##CHI char(8);
//dcl-s ##RTCD char(1);
dcl-s ##PGST char(1);
dcl-s WKRTCD char(1);
//dcl-s WKTRTP char(1);
//dcl-s WKTRPA char(1);
dcl-s WKI000 char(1);
//dcl-s WKFENR char(4);
//dcl-s I0 zoned(3:0);
//dcl-s I1 zoned(3:0);
//dcl-s I2 zoned(3:0);
//dcl-s WKFIRM like(DAFIRM);
//dcl-s WKUSER like(DSUSER);
dcl-s WKJDAT like(DSJDAT);
dcl-s WKJZEI like(DSJZEI);
//dcl-s PCPGST like(#CPGST);

//------------------------------------------------------------------------------
//  Externe Call-Prozeduren
//------------------------------------------------------------------------------
dcl-pr WAO010  extpgm('WAO010');
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc WAO010;
  dcl-pi *n;
  end-pi;

  in EXTRLD;

  if WKFIRM <> DAFIRM;
    exsr ANFANG;
    exsr ETRPA;
  endif;

  exsr VORLAUF;

  //----------------------------------------------------------------------------
  //  Programmsteuerung
  //----------------------------------------------------------------------------
  exsr VBOYH;

  return;

  //----------------------------------------------------------------------------
  //  Eröffnungszyklus
  //----------------------------------------------------------------------------
  begsr ANFANG;

    WKI000 = *ON;
    WKCHPN = EXPSDSPROC;
    WKCHPL = EXPSDSBIBL;
    WKUSER = EXPSDSCUSR;

    KYAKFI = DAFIRM;     // AFKO
    KYAAFI = DAFIRM;     // AFPA
    KYAPFI = DAFIRM;     // AFPO
    KYGKFI = DAFIRM;     // AGKO
    BAGKKYGKFI = DAFIRM; // BAGK
    KYEKFI = DAFIRM;     // BBEK
    KYBOYHFIRM = DAFIRM; // BOYH
    KYVSFI = DAFIRM;     // KDVS
    KYKDFI = DAFIRM;     // KUND
    KYLFFI = DAFIRM;     // LIEF
    KYTAFI = DAFIRM;     // TRPA

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
  //  Lesen Datei BOYH (BOYH-Sätze mit dem Status BOYHSTAT = '90'
  //----------------------------------------------------------------------------
  begsr VBOYH;

    EXEC SQL DECLARE BOYHC1 CURSOR FOR
    SELECT BOYH.BOYHDANA, BOYH.BOYHSZAR, BOYH.BOYHKDNR, BOYH.BOYHVSNR,
    BOYH.BOYHLFNR, BOYH.BOYHJAHR, BOYH.BOYHNUKR FROM BOYH
    WHERE BOYH.BOYHFIRM = :DAFIRM
      AND BOYH.BOYHSTAT = '90'
    GROUP BY BOYH.BOYHDANA, BOYH.BOYHSZAR, BOYH.BOYHKDNR, BOYH.BOYHVSNR,
    BOYH.BOYHLFNR, BOYH.BOYHJAHR, BOYH.BOYHNUKR
    FOR FETCH ONLY;

    EXEC SQL OPEN BOYHC1;

    SQLCOD = *ZERO;
    dow SQLCOD = *ZERO;
      clear BOYH;
      EXEC SQL FETCH NEXT FROM BOYHC1 INTO :BOYHDANA, :BOYHSZAR,
      :BOYHKDNR, :BOYHVSNR, :BOYHLFNR, :BOYHJAHR, :BOYHNUKR;

      if isSQLEOForError(SqlState);
        leave;
      endif;

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

      SQLCOD = *ZERO;

    enddo;

    EXEC SQL CLOSE BOYHC1;

  endsr;

  //----------------------------------------------------------------------------
  //  Update Status KUND
  //----------------------------------------------------------------------------
  begsr UKUND;

    KYKDNR = BOYHKDNR;
    CHIDS = '01C';
    exsr CHKUND;
    select;
    when CHI(5) = 'N' or KDLOCK <> *BLANK
      or KDKDST >= '90' and KDKDST <> '99';
      leavesr;
    when KDKDST = '99';
      // KUND-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

    KYKDNR = BOYHKDNR;
    CHIDS = '01CU';
    exsr CHKUND;
    if CHI(5) = 'J';
      KDKDST = '99';
      KDJNAM = DAJNAM;
      KDPROG = WKCHPN;
      KDBIBL = WKCHPL;
      KDUSER = DAUSER;
      KDJZEI = %dec(%time());
      KDJDAT = %dec(%date():*ISO);
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
    CHIDS = '01C';
    exsr CHAFKO;
    select;
    when CHI(5) = 'N' or AKLOCK <> *BLANK
      or AKAFST >= '89' and AKAFST <> '99';
      leavesr;
    when AKAFST = '99';
      // AFKO-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

    KYAAAT = AKAFAT;
    CHIDS  = '01C';
    exsr CHAFPA;
    if AAKOMM <> DAJNKZ;
      leavesr;
    endif;

    KYAPST = '20';
    KYAPJH = AKAFJJ;
    KYAPAF = AKAFNR;
    KYAPPO = *ZERO;
    CHIDS  = '11+';
    exsr CHAFPO;
    if CHI(5) = 'J'
      and APFIRM = KYAPFI
      and APAFJJ = KYAPJH
      and APAFNR = KYAPAF
      and APAFST >= KYAPST;

      leavesr;
    endif;

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
    CHIDS = '01C';
    exsr CHKDVS;
    select;
    when CHI(5) = 'N' or VSLOCK <> *BLANK
      or VSVSST >= '90' and VSVSST <> '99';
      leavesr;
    when VSVSST = '99';
      // KDVS-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

    KYVSKD = BOYHKDNR;
    KYVSNR = BOYHVSNR;
    CHIDS = '01CU';
    exsr CHKDVS;
    if CHI(5) = 'J';
      VSVSST = '99';
      VSJNAM = DAJNAM;
      VSPROG = WKCHPN;
      VSBIBL = WKCHPL;
      VSUSER = DAUSER;
      VSJZEI = %dec(%time());
      VSJDAT = %dec(%date():*ISO);
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
    CHIDS = '01C';
    exsr CHAGKO;
    select;
    when CHI(5) = 'N' or GKLOCK <> *BLANK
      or GKAGST >= '90' and GKAGST <> '99';
      leavesr;
    when GKAGST = '99';
      // AGKO-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

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
    CHIDS = '01C';
    exsr CHLIEF;
    select;
    when CHI(5) = 'N' or LFLOCK <> *BLANK
      or LFLFST >= '90' and LFLFST <> '99';
      leavesr;
    when LFLFST = '99';
      // LIEF-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

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
    CHIDS = '01C';
    exsr CHBBEK;
    select;
    when CHI(5) = 'N' or EKLOCK <> *BLANK
      or EKBEST <> *BLANK and EKBEST <> '99';
      leavesr;
    when EKBEST = '99';
      // BBEK-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

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
    CHIDS = '01C';
    exsr CHBAGK;
    select;
    when CHI(5) = 'N' or BAGKLOCK <> *BLANK
      or BAGKAGST >= '90' and BAGKAGST <> '99';
      leavesr;
    when BAGKAGST = '99';
      // BAGK-Status ist bereits "Sanktionssperre", dann nur die BOYH-Sätze auf den Status = '95' se
      exsr UBOYH;
      leavesr;
    endsl;

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

    EXEC SQL
    UPDATE BOYH SET BOYH.BOYHSTAT = '95'
    WHERE BOYH.BOYHFIRM = :DAFIRM
      AND BOYH.BOYHDANA = :BOYHDANA
      AND BOYH.BOYHSZAR = :BOYHSZAR
      AND BOYH.BOYHKDNR = :BOYHKDNR
      AND BOYH.BOYHVSNR = :BOYHVSNR
      AND BOYH.BOYHLFNR = :BOYHLFNR
      AND BOYH.BOYHJAHR = :BOYHJAHR
      AND BOYH.BOYHNUKR = :BOYHNUKR
      AND BOYH.BOYHSTAT = '90';

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
/copy QCPYSRC,CHAFPA
/copy QCPYSRC,CHAFPO
/copy QCPYSRC,CHAGKO
/copy QCPYSRC,CHBAGK
/copy QCPYSRC,CHBBEK
/copy QCPYSRC,CHBOYH
/copy QCPYSRC,CHKDVS
/copy QCPYSRC,CHKUND
/copy QCPYSRC,CHLIEF
/copy QCPYSRC,CHTRPA
///copy QCPYSRC,VRMVMONMSG
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
