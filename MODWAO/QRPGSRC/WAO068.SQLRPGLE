     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2019')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE Ermittlung/Ausgabe der aktuellen KD-Aufträge als Kundenauftraege.txt
      //*************************************************************************
      //  Copyright 2019 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  --------------------------------------------------------------
      //  Erstellung PH 18.03.2019 DOMETIC Projekt 14434-01
      //  --------------------------------------------------------------
      //  Änderungen GS 08.05.2019 Interpretation KDEWKSST, sowie Ausschluss
      //             KDEWKSST = '1015'
      //  Änderung:  PH 06.06.2019 DOMETIC Projekt 14434-03. Kumulieren Menge bei den sonst
      //             identischen TXT-Zeilen mit der Ausgabe einer einzelnen Summenzeile
      //  Änderung:  GS 05.11.2019 Projekt 15309 Ermitteln FIRMHINW für die Ausgabe.
      //             Ausgabe der Dateien pro Firma (Endung XY.txt) xy = Firma
      //  Änderung:  PH 10.01.2022 DOMETIC Projekt 17033-01. Ausgabe der KD-Auftragsposi-
      //             tionen, deren Liefertermin vor dem Montag der aktuellen Woche liegt,
      //             jedoch nicht älter als 12 Monate als das Tagesdatum ist, in eine
      //             separate IFS-Datei "RueckstaendeXY.txt" in dasselbe Verzeichnis wie
      //             die Datei "KundenauftraegeXY.txt" mit den Unterscheiden. dass anstelle
      //             von "Sales Orders" "Equivalent Unit 1" und anstelle des 1. Tags der KW
      //             des LF-Termins des jeweiligen AFPO-Satzes der 1. Tag (Montag) der zurück-
      //             liegenden Woche ausgegeben werden.
      //  Änderung:  PH 07.01.2026 DOMETIC Case 05887383. Ausgabe der KD-Auftragspositionen mit den
      //             in der neuen SYTK-/SYTP-Tabelle "WAO068FCAA" hinterlegten KD-Auftragsarten in
      //             eine separate IFS-Datei "ForecastsXY.txt" in dasselbe Verzeichnis wie die Datei
      //             "KundenauftraegeXY.txt" mit dem Unterschied. dass anstelle von "Planning"
      //             "Forecast" und anstelle von "Sales Orders" "Customer Forecast" ausgegeben
      //             werden.
      //*******************************************************************
      //  Dieses Programm wird durch das CL-Programm WAO068SJ aufgerufen, ermittelt
      //  die aktuellen KD-Aufträge (AFPO.APAFST < '90') mit den in der SYTK-Tabelle "WAO068AFAT"
      //  hinterlegten KD-Auftragsarten und AFKO.AKABMA <> 'V' und gibt diese in die Datei
      //  "Kundenauftraege.txt" im Verzeichnis TREND/echt/edi/out/dsx/ aus. Sollte es
      //  diese Datei in diesem Verzeichnis bereits geben, wird sie vorher gelöscht.
      //
      //  Die KD-Auftragspositionen, deren LF-Termin vor dem Montag der aktuellen Woche aber
      //  nicht mehr als 12 Monate vom Tagesdatum gerechnet zurückliegt, werden (kumuliert)
      //  in eine separate Datei "RueckstaendeXY.txt" in dasselbe IFS-Vezeichnis ausgegeben.
      //
      //  Die KD-Auftragspositionen mit den in der SYTK-/SYTP-Tabelle "WAO068FCAA" hinterlegten
      //  KD-Auftragsarten werden (kumuliert) in eine neue separate Datei "ForecastsXY" in
      //  in dasselbe IFS-Vezeichnis ausgegeben.
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
      //*************************************************************************
      //**  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D AFA             S                   INZ DIM(999) LIKE(APAFAT)
     D FCA             S                   INZ DIM(999) LIKE(APAFAT)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ

     D FIRM          E DS                  INZ
     D KYFIRM        E DS                  INZ

     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ

     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ

     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ

     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ

     D EXFIRM        E DS                  INZ
     D EXINIT        E DS                  INZ
     D RTINIT        E DS                  INZ
     D
     D EXFTPI        E DS                  INZ
     D RTFTPI        E DS                  INZ

     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ

     D EXFS03        E DS                  INZ
     D RTFS03        E DS                  INZ

     D EXFS04        E DS                  INZ
     D RTFS04        E DS                  INZ

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKTSTP          S               Z
     D WKFILE          S             34A   INZ('Kundenauftraege')
     D WKFILE_RS       S             34A   INZ('Rueckstaende')
     D WKFILE_FC       S             34A   INZ('Forecasts')
     D LOCAL_ROOT      S            256A
     D WKDIR           S            256A
     D WKC001          S              1
     D WKN010          S              1S 0
     D WKBSMG          S             13S 2
     D WKSTMT          S          10000    INZ VARYING
     D I1              S              3S 0
     D I2              S              3S 0
     D IU              S             20S 0
     D ##CHI           S              8
     D PCPGST          S              6
     D WKFENR          S              4
     D WKTRTP          S              1
     D WKTRPA          S              1
     D WKI000          S              1
     D WKIEIG          S              1
     D WKIFRM          S              1
     D WKTRPABEGR      S             10
     D TXKDEWKSST      S             40
     D WKROOT          S              1
     D WKROOT_RS       S              1
     D WKROOT_FC       S              1
     D WKENVI          S                   LIKE(DUC004)
     D WKLFTE          S                   LIKE(APLFTE)
     D UFAFPOLFTE      S                   LIKE(APLFTE)
     D WKABGRDARS      S                   LIKE(APLFTE)
     D WKLFTE_RS       S                   LIKE(APLFTE)
     D WKSYTPLANR      S                   LIKE(SYTPTTXT)
     D WKFS04TEXT      S                   LIKE(EXFS04TEXT)
     D W1FS04TEXT      S                   LIKE(EXFS04TEXT)
     D WKFIRMHINW      S              5

     D/COPY QCPYSRC,EXTX01

      //*************************************************************************
      //** Konstanten-Definition
      //*************************************************************************

      //*************************************************************************
      //**  DATENSTATIONSARBEITSBEREICH                                       ***
      //*************************************************************************
     D EXTRLD        EUDS                  DTAARA(*LDA)

      //*************************************************************************
      //**  PROZEDUREN                                                        ***
      //*************************************************************************
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

      //*************************************************************************
      //**  R E C H E N B E S T I M M U N G E N                               ***
      //*************************************************************************
      /FREE
       IN EXTRLD;

       IF WKI000 <> *ON;
         EXSR ANFANG;
       ENDIF;

       IF WKTRPA <> *ON;
         EXSR ETRPA;
       ENDIF;

       //*************************************************************************
       //**     P R O G R A M M S T E U E R U N G                              ***
       //*************************************************************************
       // Initialisierung der Verzeichnisse
       EXSR INIT;

       EXSR OAFPO;
       EXSR VAFPO;

       // Schliessen der TXT.-Datei
       IF WKROOT = *ON;
         EXSR AENDE;
         WKROOT = *OFF;
       ENDIF;

       // Verarbeitung für die Rückstände
       EXSR VAFPORS;

       // Schliessen der Datei "Rueckstaende.txt"
       IF WKROOT_RS = *ON;
         EXSR AENDE;
         WKROOT_RS = *OFF;
       ENDIF;

       EXSR OAFPOFC;
       // Verarbeitung für die Forecasts
       EXSR VAFPOFC;

       // Schliessen der Datei "Forecasts.txt"
       IF WKROOT_FC = *ON;
         EXSR AENDE;
         WKROOT_FC = *OFF;
       ENDIF;

       *INLR = *ON;

       //*************************************************************************
       //**  Eröffnungszyklus                                                  ***
       //*************************************************************************
       BEGSR ANFANG;

         WKI000 = *ON;

         WKC001 = *BLANK;
         WKN010 = *ZERO;

         WKFENR = '0000';

         KYTPFI = DAFIRM;      // TRTP
         KYTPSP = DASPCD;
         KYADFI = DAFIRM;      // AFAD
         KYAPFI = DAFIRM;      // AFPO
         KYKDEWFIRM = DAFIRM;  // KDEW
         KYKDFI = DAFIRM;      // KUND
         KYSYTPFIRM = DAFIRM;  // SYTP
         KYTAFI = DAFIRM;      // TRPA

         KYFIRMFIRM = DAFIRM;
         CHIDS = '01C';
         EXSR CHFIRM;
         WKFIRMHINW = FIRMHINW;

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
           RTFTPIEMVZ = '/trend/&umgebung/edi/out/dsx';
         ENDIF;

         // Setzen der Umgebung (Echt, Rel oder Test)
         RTFTPIEMVZ = P_SCANRPL(RTFTPIEMVZ: '&umgebung':WKENVI);

         LOCAL_ROOT = %TRIM(RTFTPIEMVZ);
         WKDIR = %TRIM(LOCAL_ROOT);

         WKROOT = *OFF;
         WKROOT_RS = *OFF;
         WKROOT_FC = *OFF;

         EXSR CHKDIR;

       ENDSR;

       //*************************************************************************
       //**  PRÜFEN Verzeichnis                                                ***
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
       //**  Bestücken AFPO/Öffnen des SQL-Cursors                             ***
       //*************************************************************************
       BEGSR OAFPO;

         WKSTMT = 'SELECT * FROM AFPO, AFAD, SYTP';
         WKSTMT += ' WHERE AFPO.APFIRM = ''' + DAFIRM + '''';
         WKSTMT += ' AND AFPO.APAFST < ''90''';
         WKSTMT += ' AND EXISTS (SELECT AFKO.AKFIRM FROM AFKO';
         WKSTMT += ' WHERE AFKO.AKFIRM = AFPO.APFIRM';
         WKSTMT += ' AND AFKO.AKAFJJ = AFPO.APAFJJ';
         WKSTMT += ' AND AFKO.AKAFNR = AFPO.APAFNR';
         WKSTMT += ' AND AFKO.AKABMA <> ''V'')';
         WKSTMT += ' AND EXISTS (SELECT KDEW.KDEWFIRM FROM KDEW';
         WKSTMT += ' WHERE KDEW.KDEWFIRM = AFPO.APFIRM';
         WKSTMT += ' AND KDEW.KDEWKDNR = AFPO.APKDNR';
         WKSTMT += ' AND KDEW.KDEWKSST <> ''1015'')';
         WKSTMT += ' AND AFAD.ADFIRM = AFPO.APFIRM';
         WKSTMT += ' AND AFAD.ADAFJJ = AFPO.APAFJJ';
         WKSTMT += ' AND AFAD.ADAFNR = AFPO.APAFNR';
         WKSTMT += ' AND AFAD.ADAART = ''ADAG''';
         WKSTMT += ' AND SYTP.SYTPFIRM = AFPO.APFIRM';
         WKSTMT += ' AND SYTP.SYTPTART = ''LANRTRDDSX''';
         WKSTMT += ' AND SYTP.SYTPTCDE = AFPO.APLANR';

         // Wenn zumndest eine KD-Af-Art in SYTK 'WAO068AFAT' hinterlegt ist:
         IF AFA(1) <> *BLANK;
           WKSTMT += ' AND';

           FOR I1 = 1 TO 999;

             IF AFA(I1) = *BLANK;
               LEAVE;
             ENDIF;

             SELECT;

             WHEN I1 = 1;
               IF AFA(2) <> *BLANK;
                 WKSTMT += ' (AFPO.APAFAT = ''' + AFA(I1) + '''';
               ELSE;
                 WKSTMT += ' AFPO.APAFAT = ''' + AFA(I1) + '''';
               ENDIF;

             WHEN I1 > 1;
               WKSTMT += ' OR AFPO.APAFAT = ''' + AFA(I1) + '''';

             ENDSL;

           ENDFOR;

           IF AFA(2) <> *BLANK;
             WKSTMT += ')';
           ENDIF;

         ENDIF;

         WKSTMT += ' ORDER BY AFPO.APFIRM, AFPO.APTENR, AFPO.APKDNR,';
         WKSTMT += ' AFAD.ADLAND, AFPO.APLFTE, SYTP.SYTPTTXT';
         WKSTMT += ' FOR FETCH ONLY';

       ENDSR;

       //*************************************************************************
       //**  Lesen der Datei AFPO                                              ***
       //*************************************************************************
       BEGSR VAFPO;

         // Untergrenze für den Liefertermin
         UFAFPOLFTE = %DEC(%DATE() - %MONTHS(12):*ISO);

         // Ermitteln Kalenderwoche für das Tagesdatum
         CLEAR EXDATE;
         EXDATEDATV = %DEC(%DATE():*ISO);
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRERKW';
         EXSR TRDATE;

         // Ermitteln den 1. Tag (Montag) der Kalenderwoche des Tagesdatums
         // als Abgrenzdatum für die Rückstände
         CLEAR EXDATE;
         EXDATEJAHR = RTDATEKWJJ;
         EXDATEDAKW = RTDATEDAKW;
         EXDATEWOTG = 1;
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRKWDA';
         EXSR TRDATE;
         WKABGRDARS = RTDATEDATE;

         // Ermitteln den 1. Tag (Montag) der zurückliefenden Kalenderwoche
         // (den auszuweisenden "Liefertermin" für die Rückstände)
         WKLFTE_RS = %DEC(%DATE(WKABGRDARS) - %DAYS(7):*ISO);

         // Öffnen User-Index für die Rückstände
         CLEAR EXUX01PARM;
         EXUX01INAM = 'WAO068';
         EXUX01ILIB = 'QTEMP';
         EXUX01IATR = 'TREND';
         EXUX01DTLG = 20 + 980;   // MAX 100 +  900 !!
         EXUX01KYLG = 20;         // MAX 100
         EXUX01ITXT = 'Rückstände KD-Aufträge WAO068';
         EXSR EXUXOPEN;

         EXEC SQL PREPARE SQAFPO FROM :WKSTMT;
         EXEC SQL DECLARE AFPOC1 CURSOR FOR SQAFPO;
         EXEC SQL OPEN AFPOC1;

         SQLCOD = *ZERO;

         CLEAR WKFS04TEXT;
         CLEAR W1FS04TEXT;
         IU = *ZERO;

         DOW SQLCOD >= *ZERO AND SQLCOD < 100;

           EXEC SQL FETCH NEXT FROM AFPOC1 INTO :AFPO;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           KYADJH = APAFJJ;
           KYADAF = APAFNR;
           KYADAA = 'ADAG';
           CHIDS = '01C';
           EXSR CHAFAD;

           KYLNNR = ADLAND;
           CHIDS = '01C';
           EXSR CHLAND;

           KYKDEWKDNR = APKDNR;
           CHIDS = '01C';
           EXSR CHKDEW;

           KYTPTA = 'KOST';
           KYTPTC = KDEWKSST;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXKDEWKSST = TPTTXT;

           KYSYTPTART = 'LANRTRDDSX';
           KYSYTPTCDE = APLANR;
           KYSYTPTFLG = *ZERO;
           CHIDS = '01C';
           EXSR CHSYTP;
           WKSYTPLANR = SYTPTTXT;

          // Ermitteln Kalenderwoche für den Liefertermin
          CLEAR EXDATE;
          EXDATEDATV = APLFTE;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRERKW';
          EXSR TRDATE;

          // Ermitteln den 1. Tag der Kalenderwoche für den Liefertermin
          CLEAR EXDATE;
          EXDATEJAHR = RTDATEKWJJ;
          EXDATEDAKW = RTDATEDAKW;
          EXDATEWOTG = 1;
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRKWDA';
          EXSR TRDATE;
          WKLFTE = RTDATEDATE;

           // öffnen der TXT.-Datei
           IF WKROOT = *OFF;
             EXSR AROOT;
             WKROOT = *ON;
           ENDIF;

           WKFS04TEXT = %TRIMR(APTENR)
                      + '~'
                      + %TRIMR(LNLISO)
                      + '~'
                      + %TRIMR(TXKDEWKSST)
                      + '~'
                      + %TRIM(WKSYTPLANR)
                      + '~'
                      + %TRIM(WKFIRMHINW)
                      + '^'
                      + %TRIMR(APKDNR)
                      + '~'
                      + 'Planning'
                      + '~'
                      + 'Sales Orders'
                      + '~'
                      + %TRIM(%EDITW(WKLFTE:'    /  /  '))
                      + '~';

           IF WKFS04TEXT <> W1FS04TEXT;
             IF W1FS04TEXT <> *BLANK;
               EXSR OTXTDATEN;
             ENDIF;

             WKBSMG = APBSMG;
             W1FS04TEXT = WKFS04TEXT;
           ELSE;
             WKBSMG += APBSMG;
           ENDIF;

           // User-Index für die Rückstände füllen
           IF APLFTE >= UFAFPOLFTE AND APLFTE < WKABGRDARS;
             IU += 1;
             EXUX01IDTA = %EDITC(IU:'X') + %EDITC(APAFJJ:'X') + APAFNR
             + %EDITC(APAFPO:'X') + LNLISO + TXKDEWKSST + WKSYTPLANR;
             EXUX01IMDE = EXUX03REPL;
             EXSR EXUXWRTE;
           ENDIF;

         ENDDO;

         IF W1FS04TEXT <> *BLANK;
           EXSR OTXTDATEN;
         ENDIF;

         EXEC SQL CLOSE AFPOC1;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe ROOT-Angaben                                              ***
       //*************************************************************************
       BEGSR AROOT;

         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+%TRIM(DAFIRM)+'.txt';
         C_TRFS04(EXFS04:RTFS04);
         IF RTFS04FENR = *ZERO;
          CLEAR EXFS04;
          EXFS04PGST = 'DELETE';
          EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+%TRIM(DAFIRM)+'.txt';
          C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_RS)
         + %TRIM(DAFIRM) + '.txt';
         C_TRFS04(EXFS04:RTFS04);
         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'DELETE';
           EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_RS)
           + %TRIM(DAFIRM) + '.txt';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'OPEN';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+%TRIM(DAFIRM)+'.txt';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;

       //*************************************************************************
       //**  Lesen der Datei AFPO (über den User-Index) für die Ausgabe        ***
       //**  der Rückstände                                                    ***
       //*************************************************************************
       BEGSR VAFPORS;

         CLEAR WKFS04TEXT;
         CLEAR W1FS04TEXT;

         EXSR EXUXREAD;
         DOW EXUX01RTCD = *ZERO;

           MONITOR;
             KYAPJH = %INT(%SUBST(EXUX01IDTA: 21: 04));
           ON-ERROR *PROGRAM;
             KYAPJH = *ZERO;
             EXSR RMVMONMSG;
           ENDMON;
           KYAPAF = %SUBST(EXUX01IDTA: 25: 06);
           MONITOR;
             KYAPPO = %INT(%SUBST(EXUX01IDTA: 31: 04));
           ON-ERROR *PROGRAM;
             KYAPPO = *ZERO;
             EXSR RMVMONMSG;
           ENDMON;
           CHIDS = '01C';
           EXSR CHAFPO;
           IF CHI(5) = 'J';
             LNLISO = %SUBST(EXUX01IDTA: 35: %LEN(LNLISO));
             TXKDEWKSST = %SUBST(EXUX01IDTA: 35 + %LEN(LNLISO):
             %LEN(TXKDEWKSST));
             WKSYTPLANR = %SUBST(EXUX01IDTA: 35 + %LEN(LNLISO)
             + %LEN(TXKDEWKSST): %LEN(WKSYTPLANR));

             // Öffnen der Datei "RueckstaendeXY.txt"
             IF WKROOT_RS = *OFF;
               EXSR AROOTRS;
               WKROOT_RS = *ON;
             ENDIF;

             WKFS04TEXT = %TRIMR(APTENR)
                        + '~'
                        + %TRIMR(LNLISO)
                        + '~'
                        + %TRIMR(TXKDEWKSST)
                        + '~'
                        + %TRIM(WKSYTPLANR)
                        + '~'
                        + %TRIM(WKFIRMHINW)
                        + '^'
                        + %TRIMR(APKDNR)
                        + '~'
                        + 'Planning'
                        + '~'
                        + 'Equivalent Unit 1'
                        + '~'
                        + %TRIM(%EDITW(WKLFTE_RS:'    /  /  '))
                        + '~';

             IF WKFS04TEXT <> W1FS04TEXT;
               IF W1FS04TEXT <> *BLANK;
                 EXSR OTXTDATEN;
               ENDIF;

               WKBSMG = APBSMG;
               W1FS04TEXT = WKFS04TEXT;
             ELSE;
               WKBSMG += APBSMG;
             ENDIF;

           ENDIF;

           EXSR EXUXNEXT;
         ENDDO;

         IF W1FS04TEXT <> *BLANK;
           EXSR OTXTDATEN;
         ENDIF;

         EXSR EXUXCLOS;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe ROOT-Angaben für die Rückstände                           ***
       //*************************************************************************
       BEGSR AROOTRS;

         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_RS)
         + %TRIM(DAFIRM) + '.txt';
         C_TRFS04(EXFS04:RTFS04);
         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'DELETE';
           EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_RS)
           + %TRIM(DAFIRM) + '.txt';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'OPEN';
         EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_RS)
         + %TRIM(DAFIRM) + '.txt';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;

       //*************************************************************************
       //**  Bestücken AFPO/Öffnen des SQL-Cursors für Forecasts               ***
       //*************************************************************************
       BEGSR OAFPOFC;

         WKSTMT = 'SELECT * FROM AFPO, AFAD, SYTP';
         WKSTMT += ' WHERE AFPO.APFIRM = ''' + DAFIRM + '''';
         WKSTMT += ' AND AFPO.APAFST < ''90''';
         WKSTMT += ' AND EXISTS (SELECT AFKO.AKFIRM FROM AFKO';
         WKSTMT += ' WHERE AFKO.AKFIRM = AFPO.APFIRM';
         WKSTMT += ' AND AFKO.AKAFJJ = AFPO.APAFJJ';
         WKSTMT += ' AND AFKO.AKAFNR = AFPO.APAFNR';
         WKSTMT += ' AND AFKO.AKABMA <> ''V'')';
         WKSTMT += ' AND EXISTS (SELECT KDEW.KDEWFIRM FROM KDEW';
         WKSTMT += ' WHERE KDEW.KDEWFIRM = AFPO.APFIRM';
         WKSTMT += ' AND KDEW.KDEWKDNR = AFPO.APKDNR';
         WKSTMT += ' AND KDEW.KDEWKSST <> ''1015'')';
         WKSTMT += ' AND AFAD.ADFIRM = AFPO.APFIRM';
         WKSTMT += ' AND AFAD.ADAFJJ = AFPO.APAFJJ';
         WKSTMT += ' AND AFAD.ADAFNR = AFPO.APAFNR';
         WKSTMT += ' AND AFAD.ADAART = ''ADAG''';
         WKSTMT += ' AND SYTP.SYTPFIRM = AFPO.APFIRM';
         WKSTMT += ' AND SYTP.SYTPTART = ''LANRTRDDSX''';
         WKSTMT += ' AND SYTP.SYTPTCDE = AFPO.APLANR';

         // Wenn zumndest eine Forecast-KD-Af-Art in SYTK 'WAO068FCAA' hinterlegt ist:
         IF FCA(1) <> *BLANK;
           WKSTMT += ' AND';

           FOR I1 = 1 TO 999;

             IF FCA(I1) = *BLANK;
               LEAVE;
             ENDIF;

             SELECT;

             WHEN I1 = 1;
               IF FCA(2) <> *BLANK;
                 WKSTMT += ' (AFPO.APAFAT = ''' + FCA(I1) + '''';
               ELSE;
                 WKSTMT += ' AFPO.APAFAT = ''' + FCA(I1) + '''';
               ENDIF;

             WHEN I1 > 1;
               WKSTMT += ' OR AFPO.APAFAT = ''' + FCA(I1) + '''';

             ENDSL;

           ENDFOR;

           IF FCA(2) <> *BLANK;
             WKSTMT += ')';
           ENDIF;

         ENDIF;

         WKSTMT += ' ORDER BY AFPO.APFIRM, AFPO.APTENR, AFPO.APKDNR,';
         WKSTMT += ' AFAD.ADLAND, AFPO.APLFTE, SYTP.SYTPTTXT';
         WKSTMT += ' FOR FETCH ONLY';

       ENDSR;

       //*************************************************************************
       //**  Lesen der Datei AFPO für Forecast-KD-Aufträge                     ***
       //*************************************************************************
       BEGSR VAFPOFC;

         EXEC SQL PREPARE SQAFPOFC FROM :WKSTMT;
         EXEC SQL DECLARE AFPOFCC1 CURSOR FOR SQAFPOFC;
         EXEC SQL OPEN AFPOFCC1;

         SQLCOD = *ZERO;

         CLEAR WKFS04TEXT;
         CLEAR W1FS04TEXT;

         DOW SQLCOD >= *ZERO AND SQLCOD < 100;

           EXEC SQL FETCH NEXT FROM AFPOFCC1 INTO :AFPO;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           KYADJH = APAFJJ;
           KYADAF = APAFNR;
           KYADAA = 'ADAG';
           CHIDS = '01C';
           EXSR CHAFAD;

           KYLNNR = ADLAND;
           CHIDS = '01C';
           EXSR CHLAND;

           KYKDEWKDNR = APKDNR;
           CHIDS = '01C';
           EXSR CHKDEW;

           KYTPTA = 'KOST';
           KYTPTC = KDEWKSST;
           CHIDS = '01C';
           EXSR CHTRTP;
           TXKDEWKSST = TPTTXT;

           KYSYTPTART = 'LANRTRDDSX';
           KYSYTPTCDE = APLANR;
           KYSYTPTFLG = *ZERO;
           CHIDS = '01C';
           EXSR CHSYTP;
           WKSYTPLANR = SYTPTTXT;

          // Ermitteln Kalenderwoche für den Liefertermin
          CLEAR EXDATE;
          EXDATEDATV = APLFTE;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRERKW';
          EXSR TRDATE;

          // Ermitteln den 1. Tag der Kalenderwoche für den Liefertermin
          CLEAR EXDATE;
          EXDATEJAHR = RTDATEKWJJ;
          EXDATEDAKW = RTDATEDAKW;
          EXDATEWOTG = 1;
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRKWDA';
          EXSR TRDATE;
          WKLFTE = RTDATEDATE;

           // öffnen der TXT.-Datei
           IF WKROOT_FC = *OFF;
             EXSR AROOTFC;
             WKROOT_FC = *ON;
           ENDIF;

           WKFS04TEXT = %TRIMR(APTENR)
                      + '~'
                      + %TRIMR(LNLISO)
                      + '~'
                      + %TRIMR(TXKDEWKSST)
                      + '~'
                      + %TRIM(WKSYTPLANR)
                      + '~'
                      + %TRIM(WKFIRMHINW)
                      + '^'
                      + %TRIMR(APKDNR)
                      + '~'
                      + 'Forecast'
                      + '~'
                      + 'Customer Forecast'
                      + '~'
                      + %TRIM(%EDITW(WKLFTE:'    /  /  '))
                      + '~';

           IF WKFS04TEXT <> W1FS04TEXT;
             IF W1FS04TEXT <> *BLANK;
               EXSR OTXTDATEN;
             ENDIF;

             WKBSMG = APBSMG;
             W1FS04TEXT = WKFS04TEXT;
           ELSE;
             WKBSMG += APBSMG;
           ENDIF;

         ENDDO;

         IF W1FS04TEXT <> *BLANK;
           EXSR OTXTDATEN;
         ENDIF;

         EXEC SQL CLOSE AFPOFCC1;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe ROOT-Angaben für die Forecasts                            ***
       //*************************************************************************
       BEGSR AROOTFC;

         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_FC)
         + %TRIM(DAFIRM) + '.txt';
         C_TRFS04(EXFS04:RTFS04);
         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'DELETE';
           EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_FC)
           + %TRIM(DAFIRM) + '.txt';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'OPEN';
         EXFS04PATH = %TRIM(LOCAL_ROOT) + '/' + %TRIM(WKFILE_FC)
         + %TRIM(DAFIRM) + '.txt';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;

       //*************************************************************************
       //**  Ausgabe der Felder in die TXT.-Datei                              ***
       //*************************************************************************
       BEGSR OTXTDATEN;

         // Füllen des Strings und Ausgabe in die TXT.-Datei
         CLEAR EXFS04;
         EXFS04TEXT = %TRIMR(W1FS04TEXT) + %TRIM(%EDITC(%INT(WKBSMG):'P'));

         EXFS04PGST = 'WRITEL';
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
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

         WKTRPA = *ON;

         KYTATA = 'MODWAO';
         KYTATC = 'WAO068';
         KYTAPA = 'FTPIEDI';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPABEGR = TAPCDE;
         IF WKTRPABEGR = *BLANK;
           WKTRPABEGR = 'EDIWAO068';
         ENDIF;

         EXSR VAFA;
         EXSR VFCA;

       ENDSR;

       //*************************************************************************
       //**  Einlesen relevante KD-Auftragsarten                               ***
       //*************************************************************************
       BEGSR VAFA;

         CLEAR AFA;

         KYSYTPTART = 'WAO068AFAT';
         KYSYTPTCDE = *BLANK;
         KYSYTPTFLG = *ZERO;
         CHIDS = '01L';
         EXSR CHSYTP;

         FOR I1 = 1 TO 999;
           CHIDS = '01R';
           EXSR CHSYTP;
           IF CHI(5) = 'N'
             OR SYTPFIRM <> KYSYTPFIRM
             OR SYTPTART <> KYSYTPTART;
             LEAVE;
           ENDIF;

           AFA(I1) = SYTPTCDE;
         ENDFOR;

       ENDSR;

       //*************************************************************************
       //**  Einlesen relevante KD-Auftragsarten für Forecasts                 ***
       //*************************************************************************
       BEGSR VFCA;

         CLEAR FCA;

         KYSYTPTART = 'WAO068FCAA';
         KYSYTPTCDE = *BLANK;
         KYSYTPTFLG = *ZERO;
         CHIDS = '01L';
         EXSR CHSYTP;

         FOR I1 = 1 TO 999;
           CHIDS = '01R';
           EXSR CHSYTP;
           IF CHI(5) = 'N'
             OR SYTPFIRM <> KYSYTPFIRM
             OR SYTPTART <> KYSYTPTART;
             LEAVE;
           ENDIF;

           FCA(I1) = SYTPTCDE;
         ENDFOR;

       ENDSR;

       //*************************************************************************
       //**  A U F R U F - M O D U L E                                         ***
       //*************************************************************************
      /COPY QCPYSRC,CHFIRM
      /COPY QCPYSRC,CHAFAD
      /COPY QCPYSRC,CHAFPO
      /COPY QCPYSRC,CHKDEW
      /COPY QCPYSRC,CHTRTP
      /COPY QCPYSRC,CHKUND
      /COPY QCPYSRC,CHLAND
      /COPY QCPYSRC,CHSYTP
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,EXUX04
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,VRMVMONMSG
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
