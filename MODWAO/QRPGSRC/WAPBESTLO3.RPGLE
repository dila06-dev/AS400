     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2015')
     H BNDDIR('TRTXT') DFTACTGRP(*NO)
      //*************************************************************************
      /TITLE  Einlesen der Daten aus PBESTLO3 von Erhard + Partner
      //*************************************************************************
      //  Copyright 2015 by trend SWM
      //                    Verwaltung GmbH
      //                    Gundelfinger Straße 11
      //                    DE 79108 Freiburg
      //  -----------------------------------------------------------------------
      //  Erstellt: SZ 03.12.2015 Projekt 11427 Dometic WAECO
      //  -----------------------------------------------------------------------
      //  Änderung: SZ 02.02.2016 Projekt 11427 Dometic WAECO, Sperrlager 094,
      //            095, 096 mit berücksichtigen
      //  Änderung: SZ 01.12.2017 Sperrkennzeichen '98' ist LFS interne Sperrung
      //            In trend als freien Bestand kennzeichnen und verarbeiten.
      //  Änderung: SZ 07.08.2019 Projekt 15084, 2.Firma LFS, Verarbeitung in
      //            Schleife
      //
      //*************************************************************************
      //
      //  Dieses Programm füllt die trend Standard Schnittstellenfile IFBS mit
      //  den Daten aus PBESTLO3. Die eingelesenen Daten werden in PBESTLO3 als
      //  verarbeitet gekennzeichnet.
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPBESTLO3L3UF A E           K DISK    USROPN RENAME(PBESTLOF:PBESTLOFL3)

      //*************************************************************************
      //**  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D MND             S                   DIM(99) INZ LIKE(BMFIRM)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D IFBS          E DS                  INZ
     D KYIFBS        E DS                  INZ
     D WKIFBS        E DS                  EXTNAME(IFBS) PREFIX(WK) INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS

     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ

     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ

     D KYPBESTLO3L3    DS                  LIKEREC(PBESTLOFL3:*KEY)

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
      //*************************************************************************
     D/COPY QCPYSRC,EXPSDS

      //*************************************************************************
      //**  DEFINITION DER WORKFELDER...                                      ***
      //*************************************************************************
     D ##CHI           S              8
     D ##PGST          S              1
     D ##RTCD          S              1
     D WKTRTP          S              1
     D WKI000          S              1
     D WKIIFL          S              1
     D WKIDAT          S              1
     D WKFENR          S              4
     D WKIFBSC100      S            100A
     D WKIFBSN080      S              8S 0
     D WKIFBSN100      S             10S 0
     D WKIFBSN134      S             13S 4
     D WKIFBSN145      S             14S 5
     D WKLSTCABG       S                   LIKE(IFBSLSTC)
     D WKLSTCAB2       S                   LIKE(IFBSLSTC)
     D WKLSTCUML       S                   LIKE(IFBSLSTC)
     D WKLFS_KONZ      S              3A
     D WKLFS_MAND      S              3A
     D WKLFS_SART      S              1A
     D I1              S              3S 0
     D I2              S              3S 0

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKIFBSTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKIFBSTSTP                        LIKE(WKIFBSTSTP)

      //--------------------------------------------------
      // Program name: C_INZDATASTR
      // Purpose:
      // Returns:
      // Parameter:      #EXDATA
      // Parameter:      #RTDATA
      //--------------------------------------------------
     D C_INZDATASTR...
     D                 PR                  EXTPGM('INZDATASTR')
     D  #EXDATA                            LIKEDS(EXDATA)
     D  #RTDATA                            LIKEDS(RTDATA)

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
      /FREE
       EXSR UEBKOM;
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
         EXSR ETRPA;
         EXSR ESYTP;
       ENDIF;

       EXSR VORLAUF;
       //*************************************************************************
       //**  P R O G R A M M S T E U E R U N G                                 ***
       //*************************************************************************
       OPEN PBESTLO3L3;

       I1 = 1;
       DOW MND(I1) <> *BLANK;
         EXSR VPBESTLO3;
         I1 = I1 + 1;
       ENDDO;

       CLOSE PBESTLO3L3;

       IF WKIDAT = *ON;
         #CRTCD = ' ';
       ELSE;
         #CRTCD = 'N';
       ENDIF;

       *INLR = *ON;
       //*************************************************************************
       //**  ERÖFFNUNGSZYKLUS                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       KYIFBSFIRM = DAFIRM;                                                     // IFBS
       KYSYTPFIRM = DAFIRM;                                                     // SYTP
       KYTEFI = DAFIRM;                                                         // TEIL

       WKCHPN = EXPSDSPROC;
       WKCHPL = EXPSDSBIBL;

       ENDSR;
       //*************************************************************************
       //**  UEBERNAHME KOM-BEREICH                                            ***
       //*************************************************************************
       BEGSR UEBKOM;

       CLEAR EXDATA;
       EXDATAFILE = 'EXTR02';
       EXDATADATA = EXTR02;
       C_INZDATASTR(EXDATA:RTDATA);
       EXTR02 = RTDATADATA;


       WKLFS_KONZ = %SUBST(#CKOMM:1:3);
       WKLFS_MAND = %SUBST(#CKOMM:4:3);

       ENDSR;
       //*************************************************************************
       //**  VORLAUF                                                           ***
       //*************************************************************************
       BEGSR VORLAUF;

         WKIDAT = *OFF;

       ENDSR;
       //*************************************************************************
       //**  VERARBEITUNG DATEN VON LFS                                        ***
       //*************************************************************************
       BEGSR VPBESTLO3;

       KYPBESTLO3L3.BMKONZ = WKLFS_KONZ;
       KYPBESTLO3L3.BMFIRM = MND(I1);
       KYPBESTLO3L3.BMIDEN = *LOVAL;
       KYPBESTLO3L3.BMHLO = *LOVAL;
       KYPBESTLO3L3.BMIDV = *LOVAL;
       KYPBESTLO3L3.BMIDVA = *LOVAL;
       KYPBESTLO3L3.BMWAKZ = *LOVAL;
       KYPBESTLO3L3.BMPRNR = *LOVAL;
       KYPBESTLO3L3.BMSRN = *LOVAL;
       KYPBESTLO3L3.BMQKZ = *LOVAL;
       KYPBESTLO3L3.BMLOC = *LOVAL;
       KYPBESTLO3L3.BMDTDC = *LOVAL;
       SETLL %KDS(KYPBESTLO3L3:4) PBESTLO3L3;

       DOW NOT %EOF(PBESTLO3L3) AND NOT %ERROR;
         WKIIFL = *OFF;
         READ PBESTLO3L3;

         IF %EOF OR %ERROR OR
           BMKONZ <> KYPBESTLO3L3.BMKONZ OR
           BMFIRM <> KYPBESTLO3L3.BMFIRM;
           LEAVE;
         ENDIF;

         EXSR INWKIFBS;

         IF WKIFBSFENR <> '0000';
           LEAVE;
         ENDIF;

         IF BMSTS1 <> *ON;
           WKIIFL = *ON;
         ENDIF;

         IF WKIIFL = *ON;
           EXSR EPBESTLO3;
           EXSR UIFBS;
           EXSR UPBESTLO3;
           WKIDAT = *ON;
         ENDIF;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  INIFBS- Inititalisieren WKIFBS                                    ***
       //*************************************************************************
       BEGSR INWKIFBS;

       CLEAR WKIFBS;
       WKIFBSFIRM = DAFIRM;
       WKIFBSWKNR = '001';
       WKIFBSSTAT = '00';
       WKIFBSDTEI = 'PBESTLO3';
       WKIFBSERZT = %DEC(%TIME());
       WKIFBSERDA = %DEC(%DATE():*ISO);
       WKIFBSERUS = DAUSER;
       WKIFBSFENR = '0000';

       ENDSR;
       //*************************************************************************
       //**  UPDATEN EMPFANGS-DATEI                                            ***
       //*************************************************************************
       BEGSR UIFBS;

       KYIFBSFIRM = WKIFBSFIRM;
       KYIFBSTSTP = WKIFBSTSTP;
       CHIDS = '01CU';
       EXSR CHIFBS;

       IFBSWKNR = WKIFBSWKNR;
       IFBSPGST = WKIFBSPGST;
       IFBSLSTC = WKIFBSLSTC;
       IFBSLBSC = WKIFBSLBSC;
       IFBSBSLA = WKIFBSBSLA;
       IFBSLANR = WKIFBSLANR;
       IFBSLORT = WKIFBSLORT;
       IFBSTENR = WKIFBSTENR;
       IFBSFBNR = WKIFBSFBNR;
       IFBSGEBI = WKIFBSGEBI;
       IFBSCONT = WKIFBSCONT;
       IFBSBHNR = WKIFBSBHNR;
       IFBSCHAR = WKIFBSCHAR;
       IFBSFUMG = WKIFBSFUMG;
       IFBSMEIN = WKIFBSMEIN;
       IFBSKDNR = WKIFBSKDNR;
       IFBSLFNR = WKIFBSLFNR;
       IFBSQUMM = WKIFBSQUMM;

       IFBSBDAT = WKIFBSBDAT;
       IFBSBZEI = WKIFBSBZEI;
       IFBSLAGB = WKIFBSLAGB;
       IFBSLBME = WKIFBSLBME;
       IFBSSTMG = WKIFBSSTMG;
       IFBSDANA = WKIFBSDANA;
       IFBSDAKY = WKIFBSDAKY;
       IFBSTMST = WKIFBSTMST;
       IFBSBLJJ = WKIFBSBLJJ;
       IFBSBLNR = WKIFBSBLNR;
       IFBSBLPO = WKIFBSBLPO;
       IFBSWBKT = WKIFBSWBKT;
       IFBSEBKT = WKIFBSEBKT;
       IFBSKONT = WKIFBSKONT;
       IFBSKOTR = WKIFBSKOTR;
       IFBSKSST = WKIFBSKSST;
       IFBSBEM1 = WKIFBSBEM1;
       IFBSBEM2 = WKIFBSBEM2;

       IFBSQSST = WKIFBSQSST;
       IFBSQSTM = WKIFBSQSTM;
       IFBSQSES = WKIFBSQSES;
       IFBSSPKZ = WKIFBSSPKZ;
       IFBSSPGR = WKIFBSSPGR;
       IFBSCHEX = WKIFBSCHEX;
       IFBSHSDA = WKIFBSHSDA;
       IFBSHSZT = WKIFBSHSZT;
       IFBSVEDA = WKIFBSVEDA;
       IFBSREFN = WKIFBSREFN;

       IFBSSTAT = WKIFBSSTAT;
       IFBSSZAR = WKIFBSSZAR;
       IFBSDTEI = WKIFBSDTEI;
       IFBSFENR = WKIFBSFENR;
       IFBSFFLD = WKIFBSFFLD;

       IFBSJNAM = WKIFBSJNAM;
       IFBSPROG = WKIFBSPROG;
       IFBSBIBL = WKIFBSBIBL;
       IFBSUSER = WKIFBSUSER;
       IFBSJZEI = WKIFBSJZEI;
       IFBSJDAT = WKIFBSJDAT;

       SELECT;
       WHEN CHI(6) = *ON;
         IFBSERDA = WKIFBSERDA;
         IFBSERZT = WKIFBSERZT;
         IFBSERUS = WKIFBSERUS;
         CHIDS = '01W';
         EXSR CHIFBS;
       WHEN CHI(6) = *OFF;
         CHIDS = '01U';
         EXSR CHIFBS;
       ENDSL;

       ENDSR;
       //*************************************************************************
       //**  EINLESEN FREMDDATEN                                               ***
       //*************************************************************************
       BEGSR EPBESTLO3;

         WKIFBSTSTP = %DATE(BMDTDI:*ISO) +
                      %TIME(%DEC(%SUBST(%EDITC(BMTIDI:'X'):1:6):6:0):*HMS) +
                      %MSECONDS(%DEC(%SUBST(%EDITC(BMTIDI:'X'):7:6):6:0));

         IF BMDTA <> 0;
           WKIFBSBDAT = BMDTA;
         ELSE;
           WKIFBSBDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF BMTIA <> 0;
           WKIFBSBZEI = BMTIA;
         ELSE;
           WKIFBSBZEI = %DEC(%TIME());
         ENDIF;

         WKIFBSTENR = BMIDEN;
         WKIFBSBEM1 = BMBEZ1;
         WKIFBSBEM2 = BMBEZ2;
         WKIFBSCHAR = BMPRNR;
         WKIFBSLBSC = *BLANK;
         WKIFBSBSLA = *BLANK;
         WKIFBSLANR = BMHLO;
         WKIFBSLORT = BMHLO;

         IF WKIFBSLANR = *BLANK;
           WKIFBSLANR = '001';
           WKIFBSLORT = '001';
         ENDIF;

         SELECT;
         WHEN BMQKZ <> *BLANK AND BMQKZ <> '98';
           WKIFBSSPKZ = DAJNKZ;
           WKIFBSSPGR = BMQKZ;
           WKIFBSLANR = '0' + BMQKZ;
           WKIFBSLORT = *BLANK;
         ENDSL;

         WKIFBSLAGB = BMBMEN;

         IF BMBMEN = 0 AND BMSPM <> 0;
           WKIFBSLAGB = BMSPM;
           IF BMQKZ <> '98';
             WKIFBSSPKZ = DAJNKZ;
             WKIFBSSPGR = BMQKZ;
             WKIFBSLANR = '0' + BMQKZ;
             WKIFBSLORT = *BLANK;
           ENDIF;
         ENDIF;

         SELECT;
         WHEN BMME = 'St';
           WKIFBSLBME = 'S';
         WHEN BMME = 'Kg';
           WKIFBSLBME = 'K';
         OTHER;
           WKIFBSLBME = BMME;
         ENDSL;

         WKIFBSVEDA = BMDTDC;

         WKIFBSJNAM = BMBS;
         WKIFBSPROG = BMPGM;
         WKIFBSBIBL = WKCHPL;
         WKIFBSUSER = BMUSR;

         IF BMDTA <> 0;
           WKIFBSJDAT = BMDTA;
         ELSE;
           WKIFBSJDAT = %DEC(%DATE():*ISO);
         ENDIF;

         IF BMTIA <> 0;
           WKIFBSJZEI = BMTIA;
         ELSE;
           WKIFBSJZEI = %DEC(%TIME());
         ENDIF;
       ENDSR;
       //-------------------------------------------------------------------------------------------
       // Die nachfolgend aufgeführten Felder entsprechen in Ausprägung und Reihenfolge den Feldern
       // in der File PBESTLO3.
       // Wenn der Inhalt aus zusätzlichen Feldern nach trend übernommen werden soll, dann die
       // Felder in den Bereich über die Linie kopieren (nicht ausschneiden). Danke.
       //
       BEGSR DUMMY;

         WKIFBSC100 = BMKONZ;     // EMS                           A    1    3    KONZERN
         WKIFBSC100 = BMFIRM;     // DWI                           A    4    6    FIRMA
         WKIFBSC100 = BMORT;      //                               A    7    9    LAGER- ORT
         WKIFBSC100 = BMBER;      //                               A   10   11    LAGER- BER.
         WKIFBSN100 = BMSST;      //                               A   12   14 3  SST NUMMER
         WKIFBSC100 = BMHLO;      //                               A   15   24    HOST LAGERORT
         WKIFBSC100 = BMLOC;      //                               A   25   26    LOCATION
         WKIFBSC100 = BMIDEN;     //                               A   27   54    ARTIKELNUMMER
         WKIFBSC100 = BMBEZ1;     //                               A   55  114    ART-BEZEICHNUNG 1
         WKIFBSC100 = BMBEZ2;     //                               A  115  174    ART-BEZEICHNUNG 2
         WKIFBSC100 = BMIDV;      //                               A  175  189    ARTIKELVARIANTE
         WKIFBSC100 = BMIDVA;     //                               A  190  204    ZUSATZART. VARIANT
         WKIFBSC100 = BMWAKZ;     //                               A  205  205    WAREN- KENNZEICHEN
         WKIFBSC100 = BMKOMA;     //                               A  206  206    KONSI- MAT.
         WKIFBSC100 = BMPRNR;     //                               A  207  221    PRÜF-NR/CHARGE
         WKIFBSC100 = BMREVS;     //                               A  222  241    REVISIONS- STAND
         WKIFBSC100 = BMSRN;      //                               A  242  266    SERIENNUMMER
         WKIFBSC100 = BMQKZ;      //                               A  267  268    QUALITÄTS- KENNZEI
         WKIFBSC100 = BMQSH;      //                               A  269  270    SCHLÜSSEL SPERRGR.
         WKIFBSN100 = BMDTDC;     //                               S  271  278 0  MHD
         WKIFBSN100 = BMBMEN;     //                               S  279  289 3  BESTANDSMENGE
         WKIFBSN100 = BMHMEN;     //                               S  290  300 3  BESTANDSMENGE HOST
         WKIFBSN100 = BMRMEN;     //                               S  301  311 3  RESERVIERTE MENGE
         WKIFBSN100 = BMSPM;      //                               S  312  322 3  GESPERRTE MENGE
         WKIFBSC100 = BMME;       //                               A  323  325    MENGEN- EINHEIT
         WKIFBSN100 = BMDTA;      //                               S  326  333 0  AUSGESTELLT DATUM
         WKIFBSN100 = BMTIA;      //                               S  334  339 0  AUSGESTELLT ZEIT
         WKIFBSC100 = BMTZA;      //                               A  340  349    ZEIT- ZONE
         WKIFBSC100 = BMBS;       //                               A  350  359    ERSTELLT VON BILDS
         WKIFBSC100 = BMUSR;      //                               A  360  369    ERSTELLT VON USER
         WKIFBSC100 = BMPGM;      //                               A  370  379    ERSTELLT VON PROGR
         WKIFBSC100 = BMSTS1;     //                               A  380  380    VERARB.- STATUS
         WKIFBSC100 = BMSTS2;     //                               A  381  381    VERARB.- STATUS
         WKIFBSC100 = BMSEP1;     //                               A  382  391    BESTANDS- TRENNUNG
         WKIFBSC100 = BMSEP2;     //                               A  392  401    BESTANDS- TRENNUNG
         WKIFBSC100 = BMBOEN;     //                               A  402  416    ZOLL- ZUGANGSBELEG
         WKIFBSC100 = BMBOEX;     //                               A  417  431    ZOLL- ABGANGSBELEG
         WKIFBSN100 = BMEXRT;     //                               S  432  439 4  WECHSELKURS
         WKIFBSN100 = BMPPR;      //                               S  440  450 4  EINST.-PREIS STD-W
         WKIFBSC100 = BMWAER;     //                               A  451  453    WAEHRUNGS- SCHLÜSS
         WKIFBSN100 = BMPPRF;     //                               S  454  464 4  EINST.-PREIS FREMD
         WKIFBSC100 = BMWAEF;     //                               A  465  467    WAEHRUNGS- SCHLÜSS
         WKIFBSC100 = BMCPPR;     //                               A  468  470    FREMDWÄHRUNG
         WKIFBSC100 = BMRECN;     //                               A  471  490    RECHNUNGS-NR
         WKIFBSC100 = BMFDOK;     //                               A  491  510    FRACHTDOKUMENT
         WKIFBSC100 = BMINRF1;    //                               A  511  540    INBOUND REFERENCE1
         WKIFBSC100 = BMINRF2;    //                               A  541  570    INBOUND REFERENCE2
         WKIFBSC100 = BMINRF3;    //                               A  571  600    INBOUND REFERENCE3
         WKIFBSC100 = BMRTSQ;     //                               A  601  620    AUSLAGERFOLGE
         WKIFBSN100 = BMVASR;     //                               S  621  621 0  VAS RELEVANT
         WKIFBSN100 = BMRN1;      //                               S  622  622 0  RES-1,0 RN1
         WKIFBSN100 = BMRN2;      //                               S  623  624 0  RES-2,0 RN2
         WKIFBSN100 = BMRN5;      //                               S  625  629 0  RES-5,0 RN5
         WKIFBSN100 = BMRN7;      //                               S  630  636 0  RES-7,0 RN7
         WKIFBSN100 = BMRN9;      //                               S  637  645 0  RES-9,0 RN9
         WKIFBSN100 = BMRN92;     //                               S  646  654 2  RES-9,2 RN92
         WKIFBSN100 = BMRN113;    //                               S  655  665 3  RES-11,3 RN113
         WKIFBSN100 = BMRN114;    //                               S  666  676 4  RES-11,4 RN114
         WKIFBSC100 = BMRA1;      //                               A  677  677    RES-1A RA1
         WKIFBSC100 = BMRA2;      //                               A  678  679    RES-2A RA2
         WKIFBSC100 = BMRA3;      //                               A  680  682    RES-3A RA3
         WKIFBSC100 = BMRA4;      //                               A  683  686    RES-4A RA4
         WKIFBSC100 = BMRA5;      //                               A  687  691    RES-5A RA5
         WKIFBSC100 = BMRA7;      //                               A  692  698    RES-7A RA7
         WKIFBSC100 = BMRA10;     //                               A  699  708    RES-10A RA10
         WKIFBSC100 = BMRA13;     //                               A  709  721    RES-13A RA13
         WKIFBSC100 = BMRA15;     //                               A  722  736    RES-15A RA15
         WKIFBSC100 = BMRA18;     //                               A  737  754    RES-18A RA18
         WKIFBSN100 = BMFN1;      //                               S  755  755 0  RES-1,0 FN1
         WKIFBSN100 = BMFN2;      //                               S  756  757 0  RES-2,0 FN2
         WKIFBSN100 = BMFN5;      //                               S  758  762 0  RES-5,0 FN5
         WKIFBSN100 = BMFN7;      //                               S  763  769 0  RES-7,0 FN7
         WKIFBSN100 = BMFN9;      //                               S  770  778 0  RES-9,0 FN9
         WKIFBSN100 = BMFN92;     //                               S  779  787 2  RES-9,2 FN92
         WKIFBSN100 = BMFN113;    //                               S  788  798 3  RES-11,3 FN113
         WKIFBSN100 = BMFN114;    //                               S  799  809 4  RES-11,4 FN114
         WKIFBSC100 = BMFA1;      //                               A  810  810    RES-1A FA1
         WKIFBSC100 = BMFA2;      //                               A  811  812    RES-2A FA2
         WKIFBSC100 = BMFA3;      //                               A  813  815    RES-3A FA3
         WKIFBSC100 = BMFA4;      //                               A  816  819    RES-4A FA4
         WKIFBSC100 = BMFA5;      //                               A  820  824    RES-5A FA5
         WKIFBSC100 = BMFA7;      //                               A  825  831    RES-7A FA7
         WKIFBSC100 = BMFA10;     //                               A  832  841    RES-10A FA10
         WKIFBSC100 = BMFA13;     //                               A  842  854    RES-13A FA13
         WKIFBSC100 = BMFA15;     //                               A  855  869    RES-15A FA15
         WKIFBSC100 = BMFA18;     //                               A  870  887    RES-18A FA18
         WKIFBSN100 = BMDTDI;     //                               S  888  895 0  DB DATUM WRITE
         WKIFBSN100 = BMTIDI;     //                               S  896  907 0  DB ZEIT WRITE
         WKIFBSC100 = BMDIUSR;    //                               A  908  917    DB USER WRITE
         WKIFBSC100 = BMDIBS;     //                               A  918  927    DB JOB WRITE
         WKIFBSC100 = BMDIJBN;    //                               A  928  933    DB JOBNR. WRITE
         WKIFBSC100 = BMDIUSRB;   //                               A  934  943    DB USER BATCH WRIT
         WKIFBSC100 = BMDIBSB;    //                               A  944  953    DB JOB BATCH WRITE
         WKIFBSC100 = BMDIJBNB;   //                               A  954  959    DB JOBNR. BATCH WR
         WKIFBSC100 = BMDIPGM;    //                               A  960  969    DB PGM WRITE
         WKIFBSC100 = BMDIPGMU;   //                               A  970  979    USER DEF. DB PGM W
         WKIFBSN100 = BMDTDU;     //                               S  980  987 0  DB DATUM REWRITE
         WKIFBSN100 = BMTIDU;     //                               S  988  999 0  DB ZEIT REWRITE
         WKIFBSC100 = BMDUUSR;    //                               A 1000 1009    DB USER REWRITE
         WKIFBSC100 = BMDUBS;     //                               A 1010 1019    DB JOB REWRITE
         WKIFBSC100 = BMDUJBN;    //                               A 1020 1025    DB JOBNR. REWRITE
         WKIFBSC100 = BMDUUSRB;   //                               A 1026 1035    DB USER BATCH REWR
         WKIFBSC100 = BMDUBSB;    //                               A 1036 1045    DB JOB BATCH REWRI
         WKIFBSC100 = BMDUJBNB;   //                               A 1046 1051    DB JOBNR. BATCH RE
         WKIFBSC100 = BMDUPGM;    //                               A 1052 1061    DB PGM REWRITE
         WKIFBSC100 = BMDUPGMU;   //                               A 1062 1071    USER DEF. DB PGM R

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN PARAMETERWERTE                                          ***
       //*************************************************************************
       BEGSR ETRPA;


       ENDSR;
       //*************************************************************************
       //**  ERMITTELN FIRMEN LFS AUS TABELLE                                  ***
       //*************************************************************************
       BEGSR ESYTP;

         CLEAR MND;
         KYSYTPTART = '$$COMPANY';
         KYSYTPTCDE = *BLANK;
         KYSYTPTFLG = *ZERO;
         CHIDS = '01L';
         EXSR CHSYTP;

         FOR I1 = 1 TO 99;
           CHIDS = '01R';
           EXSR CHSYTP;

           IF WKFENR <> *ZERO
             OR SYTPFIRM <> KYSYTPFIRM
             OR SYTPTART <> KYSYTPTART;
             LEAVE;
           ENDIF;

           MND(I1) = SYTPTCDE;
         ENDFOR;

         IF MND(1) = *BLANK;
           MND(I1) = WKLFS_MAND;
         ENDIF;
       ENDSR;
       //*************************************************************************
       //**  UPDATE STATUS IN PBESTLO3                                         ***
       //*************************************************************************
       BEGSR UPBESTLO3;

       BMTIDU = %DEC(%TIME());
       BMDTDU = %DEC(%DATE():*ISO);
       BMSTS1 = *ON;
       BMDUUSR = DAUSER;
       BMDUBS = WKCHPN;
       UPDATE PBESTLOFL3;

       ENDSR;
       //*************************************************************************
       //**  COPY-MODULE                                                       ***
       //*************************************************************************
      /END-FREE
     C/COPY QCPYSRC,CHIFBS
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
