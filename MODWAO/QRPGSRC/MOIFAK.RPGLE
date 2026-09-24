**free
//------------------------------------------------------------------------------
/title Programm für die kundenspezifischen Prüfungen, Ermittlungen und sonstige
/title kundenspeziellen Steuerungen in BEZUG auf die IFAK "Interface KD-Auftrag"
//------------------------------------------------------------------------------
//  Copyright 2024 by    trend SWM
//                       Verwaltung GmbH
//                       Jechtinger Straße 9
//                       DE 79111 Freiburg
//------------------------------------------------------------------------------
//  Erstellt: PH 18.01.2024 DOMETIC Projekt 230617-01
//------------------------------------------------------------------------------
//  Änderung: MG 21.11.2025 DOMETIC Case #05823378 Angebotszuordnung mit erweiterter
//            Zuordnungsregel. Prüfung auf die Angebotsmenge.
//------------------------------------------------------------------------------
//  Beschreibung:
//
//  PCPGST = 'PRAGPO' Prüfung auf gültige Angebote
//
//------------------------------------------------------------------------------
//  Optionen
//------------------------------------------------------------------------------
/include QCPYSRC,CTLOPTIONS
ctl-opt main(MOIFAK);

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
dcl-ds AGPO   ext inz end-ds;
dcl-ds KYAGPO ext inz end-ds;

dcl-ds IFAK   ext inz end-ds;
dcl-ds KYIFAK ext inz end-ds;

dcl-ds IFAP   ext inz end-ds;
dcl-ds KYIFAP ext inz end-ds;

dcl-ds KUND   ext inz end-ds;
dcl-ds KYKUND ext inz end-ds;

dcl-ds TRPA   ext inz end-ds;
dcl-ds KYTRPA ext inz end-ds;

//------------------------------------------------------------------------------
//  Kommunikationsparameter
//------------------------------------------------------------------------------
dcl-ds EXTR01 ext inz end-ds;
dcl-ds EXTR02 ext inz end-ds;
dcl-ds EXTR03 ext inz end-ds;

dcl-ds EXTREND ext inz end-ds;
dcl-ds RTTREND ext inz end-ds;

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
dcl-s W$MSGA char(3);
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
dcl-s DSIFAKIFFI like(IFAKIFFI);
dcl-s DSIFAKIFNR like(IFAKIFNR);
dcl-s WKAFDA like(IFAKAFDA);

// /include QCPYSRC,TREND
dcl-pr MOIFAK  extpgm('MOIFAK');
  #EXTREND likeds(EXTREND);
  #RTTREND likeds(RTTREND);
end-pr;

//------------------------------------------------------------------------------
//  Programmstart
//------------------------------------------------------------------------------
dcl-proc MOIFAK;
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
  when PCPGST = 'PRAGPO';
    exsr PRAGPO;
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

    KYGPFI = DAFIRM;     // AGPO
    KYIFAKFIRM = DAFIRM; // IFAK
    KYIFAPFIRM = DAFIRM; // IFAP
    KYKDFI = DAFIRM;     // KUND
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
    DSIFAKIFFI = %SUBST(EXTRNDKEYB:01);
    DSIFAKIFNR = %SUBST(EXTRNDKEYB:06);

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
  //  Prüfen auf gültige Angebote
  //----------------------------------------------------------------------------
  begsr PRAGPO;

    for I0 = 1 to 1;

      WKFENR = *ZERO;
      W$MSGA = *BLANK;

      KYIFAKIFFI = DSIFAKIFFI;
      KYIFAKIFNR = DSIFAKIFNR;
      CHIDS = '01C';
      exsr CHIFAK;
      WKFENR = *ZERO;
      if CHI(5) = 'N';
        leave;
      endif;

      if IFAKAFDA <> *ZERO;
        WKAFDA = IFAKAFDA;
      else;
        WKAFDA = %DEC(%DATE():*ISO);
      endif;

      KYKDNR = IFAKKDNR;
      CHIDS = '01C';
      exsr CHKUND;
      WKFENR = *ZERO;
      if CHI(5) = 'N';
        leave;
      endif;

      WKFENR = *ZERO;
      W$MSGA = *BLANK;

      // Zuerst versuchen, mit der Konditionskunden-Nr KDKOKD ein gültiges angebot zu ermitteln
      if KDKOKD <> *BLANK;
        KYIFAPIFFI = KYIFAKIFFI;
        KYIFAPIFNR = KYIFAKIFNR;
        clear KYIFAPIFPO;
        CHIDS = '01+';
        exsr CHIFAP;
        WKFENR = *ZERO;
        dow CHI(05) = 'J'
          and IFAPIFFI = KYIFAPIFFI
          and IFAPIFNR = KYIFAPIFNR;

          KYGPTE = IFAPTENR;
          KYGPKD = KDKOKD;
          KYGPJH = *ZERO;
          KYGPAG = *LOVAL;
          KYGPPO = *LOVAL;
          CHIDS = '02+';
          exsr CHAGPO;
          WKFENR = *ZERO;
          dow CHI(5) = 'J'
            and GPFIRM = KYGPFI
            and GPTENR = KYGPTE
            and GPKDNR = KYGPKD;

            select;
            // Prüfung auf die Vertragsmenge
            when IFAPBSMG <> GPMENG;
              CHIDS = '02R';
              exsr CHAGPO;
              WKFENR = *ZERO;

            when WKAFDA >= GPGADA
              and WKAFDA <= GPGBDA
              and GPAGST < '40';
              // Gültiges Angebot vorhanden
              W$MSGA = '#MO';
              WKFENR = '0025';
              leave;

            other;
              CHIDS = '02R';
              exsr CHAGPO;
              WKFENR = *ZERO;
            endsl;

          enddo;

          if WKFENR <> *ZERO;
            leave;
          endif;

          CHIDS = '01R';
          exsr CHIFAP;
          WKFENR = *ZERO;
        enddo;
      endif;

      if WKFENR <> *ZERO or KDKOKD = KDKDNR;
        leave;
      endif;

      // Es wurde mit der von KDKDNR abweichenden KDKOKD kein gültiges Angebot gefunden
      // Jetzt versuchen, mit der Kunden-Nr KDKDNR ein gültiges Angebot zu ermitteln
      KYIFAPIFFI = KYIFAKIFFI;
      KYIFAPIFNR = KYIFAKIFNR;
      clear KYIFAPIFPO;
      CHIDS = '01+';
      exsr CHIFAP;
      WKFENR = *ZERO;
      dow CHI(05) = 'J'
        and IFAPIFFI = KYIFAPIFFI
        and IFAPIFNR = KYIFAPIFNR;

        KYGPTE = IFAPTENR;
        KYGPKD = KDKDNR;
        KYGPJH = *ZERO;
        KYGPAG = *LOVAL;
        KYGPPO = *LOVAL;
        CHIDS = '02+';
        exsr CHAGPO;
        WKFENR = *ZERO;
        dow CHI(5) = 'J'
          and GPFIRM = KYGPFI
          and GPTENR = KYGPTE
          and GPKDNR = KYGPKD;

          select;
          when WKAFDA >= GPGADA
            and WKAFDA <= GPGBDA
            and GPAGST < '40';
            // Gültiges Angebot vorhanden
            W$MSGA = '#MO';
            WKFENR = '0025';
            leave;

          other;
            CHIDS = '02R';
            exsr CHAGPO;
            WKFENR = *ZERO;
          endsl;

        enddo;

        if WKFENR <> *ZERO;
          leave;
        endif;

        CHIDS = '01R';
        exsr CHIFAP;
        WKFENR = *ZERO;
      enddo;

    endfor;

    clear RTTREND;
    RTTRNDPRKZ = W$MSGA; // Nachrichten-Art
    RTTRNDFENR = WKFENR;

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
/copy QCPYSRC,CHAGPO
/copy QCPYSRC,CHIFAK
/copy QCPYSRC,CHIFAP
/copy QCPYSRC,CHKUND
/copy QCPYSRC,CHTRPA
/copy QCPYSRC,EXJOBA
end-proc;
//------------------------------------------------------------------------------
//  Ende des Programms
//------------------------------------------------------------------------------
