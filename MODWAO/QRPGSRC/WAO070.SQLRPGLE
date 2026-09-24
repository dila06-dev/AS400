     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE CSV-Datei Hymer,Knaus,Dethleffs Basis Lieferschein
      //*************************************************************************
      //  Copyright 2014 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Gundelfinger Straße 11
      //                       D-79108 Freiburg
      //  ----------------------------------------------------------------------
      //  Erstellt: GS 10.07.2018 Projekt 13987 Dometic
      //  ----------------------------------------------------------------------
      //  Änderung: SZ 17.07.2018 Übergabeparameter auf EXIFKM/RTIFKM geändert
      //            Zulesen der Aufträge, die von Siegen übertragen werden.
      //  Änderung: SZ 24.07.2018 PWINORH ist nach Verarbeitung leer. Die Daten
      //            werden in PWINORHS gesichert.
      //  Änderung: SZ 10.08.2018 Die Artikelnummer des Kunden (KPIDEN) muss für
      //            die Aufträge aus Siegen aus PWINORDS ermittelt werden.
      //  Änderung: SZ 18.10.2018 Verschiedene Anpassungen gemäß E-Mail von Hymer
      //  Änderung: SZ 25.10.2018 Zugriff SYTP für relevante Kundennummern
      //  Änderung: SZ 30.11.2018 Dateiname Hymer angepasst. Der Name muss mit
      //            der Kundennummer von Dometic WAECO bei Hymer beginnen.
      //  Änderung: SZ 19.12.2018 Nach Rückmeldung von Hymer muss die Dateinamen-
      //            erweiterung ".txt" klein geschrieben werden.
      //  Änderung: SZ 26.06.2019 Nach Umfirmierung in Dometic Germany hat Hymer
      //            eine neue Kundennummer vergeben.
      //
      //*************************************************************************
      //  Erstellen der CSV-Dateien für Hymer, Knaus und Dethleffs auf Basis des
      //  gedruckten Lieferscheines. Das Programm ist im SBM-Job der LFS-Schnittstelle
      //  WAIFKMSB integriert und wird pro Lieferschein-Jahr/Nummer aufgerufen.
      //  Die CSV-Datei wird in das Verzeichnis"trend/echt/edi/out/desadv/.."
      //  unter den Kz. Hymer (HY...) Knaus, (KN.. bzw.Dethleffs (DE..) gestellt.
      //
      //  TVRELWAECO/PWINORH
      //  ORH040    Auftragnummer (AKREF1, Stellen 2 - 7)
      //  ORH330    Lieferantennummer von Dometic beim Kunden
      //  ORH512=J  Ja, Kunde wünscht den LIEFERAVIS (lt. CIVD)
      //  ORH513=J  Ja, Kunde wünscht das Transportlabel (lt. CIVD)
      //  TVRELWAECO/PWINORD
      //  ORD040    Auftragnummer (AKREF1, Stellen 2 - 7)
      //  ORD220    Artikelnummer des Werks (normalerweise identisch mit ORD230)
      //  ORD230    SKU (Identnummer Dometic)
      //  ORD235    Artikelnummer des Kunden
      //
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
     FPWINORH   UF A E           K DISK    USROPN

      //*************************************************************************
      //**  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D KDN             S                   DIM(99) INZ LIKE(KDKDNR)
     D KNA             S                   DIM(99) INZ LIKE(KDKNAM)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ

     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ

     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ

     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ

     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS

     D EXIFKM        E DS
     D RTIFKM        E DS

     D EXFIRM        E DS                  INZ
     D EXINIT        E DS                  INZ
     D RTINIT        E DS                  INZ
     D
     D EXKPIF        E DS                  INZ
     D RTKPIF        E DS                  INZ

     D EXFTPI        E DS                  INZ
     D RTFTPI        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXFS03        E DS                  INZ
     D RTFS03        E DS                  INZ
     D EXFS04        E DS                  INZ
     D RTFS04        E DS                  INZ

     D KYPWINORH       DS                  LIKEREC(ORH00R1:*KEY)

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKTSTP          S               Z
     D WKAFLKLIJJ      S                   LIKE(ALLIJJ)
     D WKAFLKLINR      S                   LIKE(ALLINR)
     D LOCAL_ROOT      S            256A
     D WKDIR           S            256A
     D WKFILE          S             34A   INZ
     D WKC001          S              1
     D WKN010          S              1S 0
     D I1              S              3S 0
     D I2              S              3S 0
     D ##CHI           S              8
     D PCPGST          S              6
     D WKFENR          S              4
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKIEIG          S              1
     D WKIFRM          S              1
     D WKTRPABEGR      S             10
     D WKROOT          S              1
     D WKENVI          S                   LIKE(DUC004)
     D WKH030          S             10
     D WKH330          S             10
     D WKH512          S              1
     D WKH513          S              1
     D WKREF1          S                   LIKE(AKREF1)
     D WKIDEN          S                   LIKE(KPIDEN)
     D WKLSDA          S                   LIKE(KLLSDA)
     D/COPY QCPYSRC,EXTX01
      //*************************************************************************
      //**  Kz.für die Datei-Kennung ersten beiden Stellen
      //*************************************************************************
      // KZ für Hymer(HY), Dethleffs (DE) , Knaus (KN)
     D WKKZIDHYMER     C                   CONST('50018293')
     D WKKZIDKNAUS     C                   CONST('KN')
     D WKKZIDDETHLEFF  C                   CONST('DE')
      //*************************************************************************
      //**  Ausgabefelder für die TXT.-Datei                                  ***
      //*************************************************************************
     D WKKZID          S             10
     D ABSENDERHYMER   C                   CONST('50018293')
     D ABSENDERKNAUS   C                   CONST('KN')
     D ABSENDERDETHLE  C                   CONST('50018293')
     D ABSENDER        S             10
     D EMPFAENGER      S             20
     D ERSTDATUM       S             16
     D ARTIKELKUNDE    S             15
     D ARTIKELLIEF     S             25
     D LIEFERMENGE     S              8S 3
     D LIEFEREINH      C                   CONST('ST')
     D BESTELLNR       S             13
     D BESTELLPOS      S              5
     D LIEFERSCHEINNR  S             20
     D LIEFERSCHEINPO  S              5
     D REFERENZ        S             20

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)


      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
      // Program name: C_EXTSTP
      // Purpose:
      // Returns:
      // Parameter:      #WKTSTP
      //--------------------------------------------------
     D C_EXTSTP...
     D                 PR                  EXTPGM('EXTSTP')
     D  #WKTSTP                            LIKE(WKTSTP)

      //--------------------------------------------------
      // Program name: C_TRFTPI
      // Purpose:
      // Returns:
      // Parameter:      #EXFTPI
      // Parameter:      #RTFTPI
      //--------------------------------------------------
     D C_TRFTPI...
     D                 PR                  EXTPGM('TRFTPI')
     D  #EXFTPI                            LIKEDS(EXFTPI)
     D  #RTFTPI                            LIKEDS(RTFTPI)

      //--------------------------------------------------
      // Program name: C_TRFS03
      // Purpose:
      // Returns:
      // Parameter:      #EXFS03
      // Parameter:      #RTFS03
      //--------------------------------------------------
     D C_TRFS03...
     D                 PR                  EXTPGM('TRFS03')
     D  #EXFS03                            LIKEDS(EXFS03)
     D  #RTFS03                            LIKEDS(RTFS03)

      //--------------------------------------------------
      // Program name: C_TRFS04
      // Purpose:
      // Returns:
      // Parameter:      #EXFS04
      // Parameter:      #RTFS04
      //--------------------------------------------------
     D C_TRFS04...
     D                 PR                  EXTPGM('TRFS04')
     D  #EXFS04                            LIKEDS(EXFS04)
     D  #RTFS04                            LIKEDS(RTFS04)

      //--------------------------------------------------
      // Program name: C_TRINIT
      // Purpose:
      // Returns:
      // Parameter:      #EXINIT
      // Parameter:      #RTINIT
      //--------------------------------------------------
     D C_TRINIT...
     D                 PR                  EXTPGM('TRINIT')
     D  #EXINIT                            LIKEDS(EXINIT)
     D  #RTINIT                            LIKEDS(RTINIT)
     D
      //--------------------------------------------------
      // Program name: C_TRKPIF
      // Purpose:
      // Returns:
      // Parameter:      #EXKPIF
      // Parameter:      #RTKPIF
      //--------------------------------------------------
     D C_TRKPIF...
     D                 PR                  EXTPGM('TRKPIF')
     D  #EXKPIF                            LIKEDS(EXKPIF)
     D  #RTKPIF                            LIKEDS(RTKPIF)

      //*************************************************************************
      //**                                                                    ***
      //*************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXIFKM
     C                   PARM                    RTIFKM
      /FREE
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       IF WKTRPA <> *ON;
         EXSR ETRPA;
         EXSR ERKDNR;
       ENDIF;
       //*************************************************************************
       //**     P R O G R A M M S T E U E R U N G                              ***
       //*************************************************************************
       // Initialisierung der Verzeichnisse
       EXSR INIT;

       // Verarbeiten der Lieferscheine
       OPEN PWINORH;
       EXSR VAFLK;

       // Schliessen der TXT.-Datei
       IF WKROOT = *ON;
         EXSR AENDE;
         WKROOT = *OFF;
       ENDIF;

       CLOSE PWINORH;
       *INLR = *ON;
       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

       WKI000 = *ON;

       WKC001 = *BLANK;
       WKN010 = *ZERO;

       WKFENR = '0000';

       KYTAFI = DAFIRM;
       KYKLFI = DAFIRM;
       KYADFI = DAFIRM;
       KYAKFI = DAFIRM;
       KYKPFI = DAFIRM;
       KYALFI = DAFIRM;
       KYKDFI = DAFIRM;
       KYSYTPFIRM = DAFIRM;

       ENDSR;
       //*************************************************************************
       //**  Initialisierung                                                   ***
       //*************************************************************************
       BEGSR INIT;

       CLEAR EXINIT;
       CLEAR RTINIT;
       EXINITPGST = 'ERINIT';
       EXINITMSGA = 'FIR';
       EXINITMSGN = '0016';
       C_TRINIT(EXINIT:RTINIT);
       WKENVI = RTINITWERT;

       // Ermitteln der Verzeichnisse aus der FTPI
       CLEAR EXFTPI;
       EXFTPIPGST = 'ERFTPI';
       EXFTPIZUBG = WKTRPABEGR;
       C_TRFTPI(EXFTPI:RTFTPI);

       IF RTFTPIFENR <> *ZERO;
         RTFTPISEVZ = '/trend/&umgebung/edi/out/desadv';
       ENDIF;

       // Setzen der Umgebung (Echt, Rel oder Test)
       RTFTPISEVZ = P_SCANRPL(RTFTPISEVZ:
       '&umgebung':
       WKENVI);

       LOCAL_ROOT = %TRIM(RTFTPISEVZ);
       WKDIR      = %TRIM(LOCAL_ROOT);

       WKROOT = *OFF;

       EXSR CHKDIR;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN UND ANLEGEN VERZEICHNIS                                    ***
       //*************************************************************************
       BEGSR CHKDIR;

         CLEAR EXFS03;
         EXFS03PGST = 'CHECK';
         EXFS03PATH = %TRIMR(WKDIR:'/');
         C_TRFS03(EXFS03:RTFS03);
         IF RTFS03FENR = *ZERO;
           LEAVESR;
         ENDIF;

         CLEAR EXFS03;
         EXFS03PGST = 'CREATE';
         EXFS03PATH = %TRIMR(WKDIR:'/');
         EXFS03AUTH = 'AAA';
         C_TRFS03(EXFS03:RTFS03);

       ENDSR;

       //*************************************************************************
       //**  AUSGABE ROOT-ANGABEN                                              ***
       //*************************************************************************
       BEGSR AROOT;

         // Zusammenbau des Dateinamens
         C_EXTSTP(WKTSTP);

         CLEAR EXDATE;
         EXDATEDATV = KLLSDA;
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*EUR';
         EXDATEPGST = 'TRDAUM';
         EXSR TRDATE;
         WKLSDA = RTDATEDATE;

         WKFILE = %TRIM(WKKZID) + '_' + %EDITC(WKLSDA:'X')
                + '_' + %EDITC(KLLIJJ:'X') + KLLINR;

         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.txt';
         C_TRFS04(EXFS04:RTFS04);

         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'DELETE';
           EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.txt';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'OPEN';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.txt';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;
       //*************************************************************************
       //**  AUSGABE DER DATEI                                                 ***
       //*************************************************************************
       BEGSR AENDE;

         CLEAR EXFS04;
         EXFS04PGST = 'CLOSE';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;
       //*************************************************************************
       //**  Ermitteln der Daten pro Lieferschein                              ***
       //*************************************************************************
       BEGSR VAFLK;

       WKH030 = *BLANK;
       WKH330 = *BLANK;
       WKH512 = *BLANK;
       WKH513 = *BLANK;
       WKREF1 = *BLANK;
       WKIDEN = *BLANK;
       WKIEIG = *OFF;     // eigener Kunde
       WKIFRM = *OFF;     // fremder Kunde

       // Lieferschein-Kopf-Informationen
       KYKLJH = RTIFKMLIJJ;
       KYKLLI = RTIFKMLINR;
       CHIDS = '01C';
       EXSR CHAFLK;
       IF  WKFENR <> '0000';
         LEAVESR;
       ENDIF;

       // Auftragskopf-Daten
       KYAKJH = KLAFJJ;
       KYAKAF = KLAFNR;
       CHIDS = '01C';
       EXSR CHAFKO;
       IF  WKFENR <> '0000';
         LEAVESR;
       ENDIF;

       // Ermitteln Kundenstamm für die Umsetzung des "Datei-Kz."
       KYKDNR = KLKDNR;
       CHIDS = '01C';
       EXSR CHKUND;
       IF  WKFENR <> '0000';
         LEAVESR;
       ENDIF;

       // Abfrage auf Hymer, Dethleffs, Knaus ansonsten keine Übertragung.
       I2 = %LOOKUP(KLKDNR:KDN:1);

       SELECT;
       WHEN I2 > 0;
         WKIEIG = *ON;

         SELECT;
         WHEN %SUBST(KNA(I2):1:1) = 'H';
           WKKZID = WKKZIDHYMER;
         WHEN %SUBST(KNA(I2):1:1) = 'D';
           WKKZID = WKKZIDDETHLEFF;
         WHEN %SUBST(KNA(I2):1:1) = 'K';
           WKKZID = WKKZIDKNAUS;
         ENDSL;
       OTHER;
         EXSR PRPWINORH;

         IF WKH512 <> 'J';
           LEAVESR;
         ENDIF;
         WKIFRM = *ON;
       ENDSL;


       // öffnen der TXT.-Datei
       IF WKROOT = *OFF;
         EXSR AROOT;
         WKROOT = *ON;
       ENDIF;

       // Lesen der Lieferpositionen und ausgeben der txt.-Datei
         EXSR VAFLP;

       ENDSR;
       //*************************************************************************
       //**  Ermitteln der Lieferpositionen                                    ***
       //*************************************************************************
       BEGSR VAFLP;

       // Lesen der Lieferpositionen
       KYALLJ = KLLIJJ;
       KYALLI = KLLINR;
       KYALLP = *ZERO;
       CHIDS = '05+';
       EXSR CHAFLP;

       DOW WKFENR = '0000'
         AND ALFIRM = KYALFI
         AND ALLIJJ = KYALLJ
         AND ALLINR = KYALLI;

         // Kunden-Produkt-Informationen
         IF WKIEIG = *ON;
           KYKPKD = KLKDNR;
           KYKPVS = *BLANK;
           KYKPTE = ALTENR;
           KYKPDA = *ZERO;
           CHIDS = '01C';
           EXSR CHKPIF;
         ELSE;
           EXSR PRPWINORD;
         ENDIF;

         EXSR OTXTDATEN;

         CHIDS = '05R';
         EXSR CHAFLP;
       ENDDO;

       ENDSR;
       //*************************************************************************
       //**  Ausgabe der Felder in die TXT.-Datei                              ***
       //*************************************************************************
       BEGSR OTXTDATEN;

       // Füllen der Variablen aus den Dateien
       IF WKIEIG = *ON;
         EMPFAENGER = KLKDNR;
       ELSE;
         EMPFAENGER = WKH030;
       ENDIF;

       ERSTDATUM = %CHAR(%DATE(WKLSDA:*EUR)) + ' '
                 + %SUBST(%EDITC(KLJZEI:'X'):1:2)
                 + ':' + %SUBST(%EDITC(KLJZEI:'X'):3:2);
       ARTIKELKUNDE = KPIDEN;

       IF ARTIKELKUNDE = *BLANK;
         ARTIKELKUNDE = '0000000';
       ENDIF;

       SELECT;
       WHEN WKIEIG = *ON
         AND WKKZID = WKKZIDHYMER;
         ABSENDER = ABSENDERHYMER;
       WHEN WKIEIG = *ON
         AND WKKZID = WKKZIDKNAUS;
         ABSENDER = ABSENDERKNAUS;
       WHEN WKIEIG = *ON
         AND WKKZID = WKKZIDDETHLEFF;
         ABSENDER = ABSENDERDETHLE;
       WHEN WKIEIG = *ON;
         ABSENDER = 'WAECO';
       OTHER;
         ABSENDER = WKH330;
       ENDSL;

       ARTIKELLIEF = ALTENR;
       LIEFERMENGE = ALGLMG;
       BESTELLNR = AKREF1;
       BESTELLPOS = %CHAR(%DEC(ALLIPO / 10:4:0));
       LIEFERSCHEINNR = %EDITC(ALLIJJ:'X') + ALLINR;
       LIEFERSCHEINPO = %CHAR(ALLIPO);
       EVALR DUC003 = %EDITC(%DEC(ALLIPO/10:4:0):'X');
       REFERENZ = 'BP' + %TRIM(AKREF1) + DUC003;

       // Füllen des Strings und Ausgabe in der TXT.-Datei
       CLEAR EXFS04;
       EVAL EXFS04TEXT = ';' +
                         %TRIM(ABSENDER) +
                         ';' +
                         ';' +
                         %TRIM(EMPFAENGER) +
                         ';' +
                         ';' +
                         %TRIM(ERSTDATUM) +
                         ';' +
                         %TRIM(ERSTDATUM) +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         %TRIM(ARTIKELKUNDE) +
                         ';' +
                         %TRIM(ARTIKELLIEF) +
                         ';' +
                         %TRIM(%CHAR(%DEC(LIEFERMENGE: 5: 0))) +
                         ';' +
                         %TRIM(LIEFEREINH) +
                         ';' +
                         %TRIM(BESTELLNR) +
                         ';' +
                         %TRIM(BESTELLPOS) +
                         ';' +
                         %TRIM(LIEFERSCHEINNR) +
                         ';' +
                         %TRIM(LIEFERSCHEINPO) +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         ';' +
                         %TRIM(REFERENZ) +
                         ';' +
                         ';' +
                         ';' ;

       EXFS04PGST = 'WRITEL';
       C_TRFS04(EXFS04:RTFS04);

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

       WKTRPA = *ON;

       KYTATA = 'MODWAO';
       KYTATC = 'WAO070';
       KYTAPA = 'FTPIEDI';
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPABEGR = TAPCDE;
       IF WKTRPABEGR = *BLANK;
         WKTRPABEGR = 'EDIWAO070';
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  PRÜFEN DATEN PWINORH (AUFTRAG AUS SIEGEN)                         ***
       //*************************************************************************
       BEGSR PRPWINORH;

       //KYPWINORH.ORH010 = '        ';
       //KYPWINORH.ORH020 = '        ';
       //KYPWINORH.ORH030 = '        ';
       //CHAIN %KDS(KYPWINORH:3) ORH00R1;
       //UPDATE ORH00R1;
       //SETLL %KDS(KYPWINORH:3) ORH00R1;
       //READ ORH00R1;
       //IF %EOF OR %ERROR OR
       //  ORH010 <> KYPWINORH.ORH010 OR
       //  ORH020 <> KYPWINORH.ORH020 OR
       //  ORH030 <> KYPWINORH.ORH030;
       //  LEAVESR;
       //ENDIF;

         WKREF1 = %SUBST(AKREF1:2:6);

         EXEC SQL
           SELECT ORH030, ORH330, ORH512, ORH513
           INTO :WKH030, :WKH330, :WKH512, :WKH513
           FROM PWINORHS
           WHERE ORH040 = :WKREF1;

         IF WKH512 <> 'J';
           LEAVESR;
         ENDIF;

         KYADJH = KLAFJJ;
         KYADAF = KLAFNR;
         KYADPO = *ZERO;
         KYADAA = 'ADVS';
         CHIDS = '01C';
         EXSR CHAFAD;

         WKKZID = WKH330;
         LEAVESR;

         SELECT;
         WHEN %SCAN('Dethleffs':ADNAM1) > 0;
           WKKZID = WKKZIDDETHLEFF;
         WHEN %SCAN('Hymer':ADNAM1) > 0;
           WKKZID = WKKZIDHYMER;
         WHEN %SCAN('Knaus':ADNAM1) > 0;
           WKKZID = WKKZIDKNAUS;
         ENDSL;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS PWINORD (AUFTRAG AUS SIEGEN)                  ***
       //*************************************************************************
       BEGSR PRPWINORD;

         WKREF1 = %SUBST(AKREF1:2:6);

         EXEC SQL
           SELECT ORD235 INTO :WKIDEN FROM PWINORDS
           WHERE ORD040 = :WKREF1 AND ORD220 = :ALTENR;
         KPIDEN = WKIDEN;
       ENDSR;
       //*************************************************************************
       //**  ERMITTELN RELEVANTE KUNDENNUMMERN                                 ***
       //*************************************************************************
       BEGSR ERKDNR;
         CLEAR KDN;
         CLEAR KNA;
         KYSYTPTART = '$$WAO070';
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

           KDN(I1) = SYTPTCDE;
           KNA(I1) = SYTPTTXT;
         ENDFOR;
       ENDSR;
       //*************************************************************************
       //**  A U F R U F - M O D U L E                                         ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHKUND
      /COPY QCPYSRC,CHKPIF
      /COPY QCPYSRC,CHAFLK
      /COPY QCPYSRC,CHAFAD
      /COPY QCPYSRC,CHAFKO
      /COPY QCPYSRC,CHAFLP
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,TRDATE
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
