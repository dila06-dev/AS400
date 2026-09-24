     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2019')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE Ermittlung/Ausgabe des aktuellen LG-Bestnds + Zugänge (offene Bestellmenge)
      /TITLE als TREND/echt/edi/out/dsx/BESTANDZUGANG.txt
      //*************************************************************************
      //  Copyright 2019 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtinger Straße 9
      //                       DE 79111 Freiburg
      //  --------------------------------------------------------------
      //  Erstellung PH 19.03.2019 DOMETIC Projekt 14735-01
      //  --------------------------------------------------------------
      //  Änderung:  PH 06.06.2019 DOMETIC Projekt 14735-03. Berücksichtigen bei der Mengen-
      //             berechnung auch die Dispo-Menge für DIST.ITBEGR = '043' = "Ware unterwegs".
      //             Den KOM-Bereich für den Aufruf TRLBB2 analog zu dem in MCDIST bestücken.
      //*******************************************************************
      //  Dieses Programm wird durch das CL-Programm WAO069SJ aufgerufen. Es liest
      //  alle Identstamm-Sätze mit TEIL.TETEST < '90', dazu den aktuellen LG-Bestand
      //  + offene Bestellmenge aus den Bestellungen mit Liefertermin in der Vergangen-
      //  heit und in der aktuellen Kalenderwoche und für die nächsten 51 Wochen nur
      //  die Zugänge (offene Bestellmenge für die Bestellungen mit Liefertermin in der
      //  jeweiligen KW) und deren Ausgabe in die Datei BESTANDZUGANG.txt im IFS-
      //  Verzeichnis TREND/echt/edi/out/dsx/ pro Artikel und KW. Sollte es diese
      //  Datei in diesem Verzeichnis bereits geben, wird sie vorher gelöscht.
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
      //*************************************************************************
      //**  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

     D ADATKW          S                   INZ DIM(52) LIKE(EPBETE)
     D EDATKW          S                   INZ DIM(52) LIKE(EPBETE)

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ

     D DIST          E DS                  INZ

     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ

     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

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

      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKTSTP          S               Z
     D WKFILE          S             34A   INZ('BESTANDZUGANG')
     D LOCAL_ROOT      S            256A
     D WKDIR           S            256A
     D WKC001          S              1
     D WKN010          S              1S 0
     D WKSTMT          S          10000    INZ VARYING
     D I1              S              3S 0
     D I2              S              3S 0
     D WKLAGB          S             13S 4
     D WKMENG          S             19S 4
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
     D ADATAKKW        S                   LIKE(EPBETE)
     D EDATAKKW        S                   LIKE(EPBETE)

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
      // Program name: C_TRDIMG
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #DIST
      //--------------------------------------------------
     D C_TRDIMG...
     D                 PR                  EXTPGM('TRDIMG')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #DIST                              LIKEDS(DIST)

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

      //--------------------------------------------------
      // Program name: C_TRLBB2
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      //--------------------------------------------------
     D C_TRLBB2...
     D                 PR                  EXTPGM('TRLBB2')
     D  #EXTR02                            LIKEDS(EXTR02)

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

       EXSR OTEIL;
       EXSR VTEIL;

       // Schliessen der TXT.-Datei
       IF WKROOT = *ON;
         EXSR AENDE;
         WKROOT = *OFF;
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

         KYTEFI = DAFIRM;      // TEIL
         KYTUFI = DAFIRM;      // TEUF
         KYEPFI = DAFIRM;      // BBEP
         KYTAFI = DAFIRM;      // TRPA

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
       //**  Bestücken TEIL/Öffnen des SQL-Cursors                             ***
       //*************************************************************************
       BEGSR OTEIL;

         WKSTMT = 'SELECT * FROM TEIL';
         WKSTMT += ' WHERE TEFIRM = ''' + DAFIRM + '''';
         WKSTMT += ' AND TETEST < ''90''';

         WKSTMT += ' ORDER BY TEFIRM, TETENR';
         WKSTMT += ' FOR FETCH ONLY';

       ENDSR;

       //*************************************************************************
       //**  Lesen der Datei TEIL                                              ***
       //*************************************************************************
       BEGSR VTEIL;

         EXEC SQL PREPARE SQTEIL FROM :WKSTMT;
         EXEC SQL DECLARE TEILC1 CURSOR FOR SQTEIL;
         EXEC SQL OPEN TEILC1;

         SQLCOD = *ZERO;

         DOW SQLCOD >= *ZERO AND SQLCOD < 100;

           EXEC SQL FETCH NEXT FROM TEILC1 INTO :TEIL;

           IF SQLCOD < *ZERO OR SQLCOD >= 100;
             LEAVE;
           ENDIF;

           // Ermitteln aktuellen LG-Gesamtbestand
           EXSR ELAGB;

           FOR I1 = 1 TO 52;

             WKSTMT = 'SELECT * FROM BBEP';
             WKSTMT += ' WHERE EPFIRM = ''' + TEFIRM + '''';
             WKSTMT += ' AND EPTENR = ''' + TETENR + '''';
             WKSTMT += ' AND EPBEST < ''40''';

             IF I1 = 1;
               WKSTMT += ' AND EPBETE <= ' + %EDITC(EDATKW(I1):'X');
             ELSE;
               WKSTMT += ' AND EPBETE >= ' + %EDITC(ADATKW(I1):'X');
               WKSTMT += ' AND EPBETE <= ' + %EDITC(EDATKW(I1):'X');
             ENDIF;

             WKSTMT += ' FOR FETCH ONLY';

             EXEC SQL PREPARE SQBBEP FROM :WKSTMT;
             EXEC SQL DECLARE BBEPC1 CURSOR FOR SQBBEP;
             EXEC SQL OPEN BBEPC1;

             IF I1 = 1;
               // In der aktuellen (1.) Woche noch den aktuellen LG-Gesamtbestand berücksichtigen
               WKMENG = WKLAGB;
             ELSE;
               WKMENG = *ZERO;
             ENDIF;

             SQLCOD = *ZERO;

             DOW SQLCOD >= *ZERO AND SQLCOD < 100;

               EXEC SQL FETCH NEXT FROM BBEPC1 INTO :BBEP;

               IF SQLCOD < *ZERO OR SQLCOD >= 100;
                 LEAVE;
               ENDIF;

               IF EPMEIN = TEMEIN;
                 DUN219 = EPMENG + EPNRMG - EPGLMG;
               ELSE;
                 KYTUTE = EPTENR;
                 KYTUME = EPMEIN;
                 WKV1V2 = EPMENG + EPNRMG - EPGLMG;
                 EXSR VTEUF;
                 DUN219 = WKV1V2;
               ENDIF;

               // Die Zugänge (offene Bestellmengen) in der Stamm-ME zu WKMENG zusammenaddieren
               EVAL(H) WKMENG += DUN219;

             ENDDO;

             EXEC SQL CLOSE BBEPC1;

             // Berücksichtigen "Ware unterwegs"
             WKSTMT = 'SELECT * FROM DIST';
             WKSTMT += ' WHERE ITFIRM = ''' + TEFIRM + '''';
             WKSTMT += ' AND ITTENR = ''' + TETENR + '''';
             WKSTMT += ' AND ITBEGR = ''043''';

             IF I1 = 1;
               WKSTMT += ' AND ITRSDA <= ' + %EDITC(EDATKW(I1):'X');
             ELSE;
               WKSTMT += ' AND ITRSDA >= ' + %EDITC(ADATKW(I1):'X');
               WKSTMT += ' AND ITRSDA <= ' + %EDITC(EDATKW(I1):'X');
             ENDIF;

             WKSTMT += ' FOR FETCH ONLY';

             EXEC SQL PREPARE SQDIST FROM :WKSTMT;
             EXEC SQL DECLARE DISTC1 CURSOR FOR SQDIST;
             EXEC SQL OPEN DISTC1;

             SQLCOD = *ZERO;

             DOW SQLCOD >= *ZERO AND SQLCOD < 100;

               EXEC SQL FETCH NEXT FROM DISTC1 INTO :DIST;

               IF SQLCOD < *ZERO OR SQLCOD >= 100;
                 LEAVE;
               ENDIF;

               #CRTCD = *BLANK;
               CLEAR #CKOMM;
               #CPGST = 'ERMMGE';
               CALLP(E) C_TRDIMG(EXTR02:DIST);
               IF #CRTCD = *BLANK;
                 DUC011 = %SUBST(#CKOMM:01);
                 MONITOR;
                   *IN(98) = *ON;
                   DUN110 *= 1;
                 ON-ERROR;
                   *IN(98) = *OFF;
                     EXSR RMVMONMSG;
                 ENDMON;
                 IF *IN(98) <> *ON;
                   DUC011 = *ZERO;
                 ENDIF;

                 EVAL(H) WKMENG += DUN112;
               ENDIF;

             ENDDO;

             EXEC SQL CLOSE DISTC1;

             SQLCOD = *ZERO;

             // öffnen der TXT.-Datei
             IF WKROOT = *OFF;
               EXSR AROOT;
               WKROOT = *ON;
             ENDIF;

             EXSR OTXTDATEN;

           ENDFOR;

         ENDDO;

         EXEC SQL CLOSE TEILC1;

       ENDSR;

       //*************************************************************************
       //**  Ermitteln aktueller LG-Gesamtbestand                              ***
       //*************************************************************************
       BEGSR ELAGB;

         %SUBST(#CKOMM:01:01) = *OFF;
         %SUBST(#CKOMM:01:01) = *ON;
         %SUBST(#CKOMM:02:01) = *ON;
         %SUBST(#CKOMM:03:01) = *ON;
         %SUBST(#CKOMM:04:01) = *OFF;
         %SUBST(#CKOMM:05:01) = *OFF;
         %SUBST(#CKOMM:06) = *BLANK;
         %SUBST(#CKOMM:07:01) = *OFF;
         %SUBST(#CKOMM:07:01) = *ON;
         %SUBST(#CKOMM:10) = TETENR;
         %SUBST(#CKOMM:215:01) = *ON;
         #CPGST = *BLANK;
         C_TRLBB2(EXTR02);
         DUC013 = %SUBST(#CKOMM:01);
         WKLAGB = DUN134;

       ENDSR;

       //*************************************************************************
       //**  Ausgabe ROOT-Angaben                                              ***
       //*************************************************************************
       BEGSR AROOT;

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
       //**  Ausgabe der Felder in die TXT.-Datei                              ***
       //*************************************************************************
       BEGSR OTXTDATEN;

         // Füllen des Strings und Ausgabe in die TXT.-Datei
         CLEAR EXFS04;
         EXFS04TEXT = 'Global|EMEA | SKU|'
                    + %TRIMR(TETENR)
                    + '~~~~~Forecast~Supply Forecast~'
                    + %TRIM(%EDITW(ADATKW(I1):'    /  /  '))
                    + '~'
                    + %TRIM(%EDITC(%INT(WKMENG):'P'));

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
         KYTATC = 'WAO069';
         KYTAPA = 'FTPIEDI';
         CHIDS = '01C';
         EXSR CHTRPA;
         WKTRPABEGR = TAPCDE;
         IF WKTRPABEGR = *BLANK;
           WKTRPABEGR = 'EDIWAO069';
         ENDIF;

         EXSR VAEDATKW;

       ENDSR;

       //*************************************************************************
       //**  Bestücken ADATKW und EDATKW mit dem Datum des 1. und des letzten  ***
       //**  Tag der aktuellen und der darauf folgenden 51 Kalenderwochen      ***
       //*************************************************************************
       BEGSR VAEDATKW;

         // Ermitteln Kalenderwoche des Tagesdatums;
         CLEAR EXDATE;
         EXDATEDATV = %DEC(%DATE():*ISO);
         EXDATEFMTV = '*ISO';
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRERKW';
         EXSR TRDATE;
         DUN040 = RTDATEKWJJ;
         DUN020 = RTDATEDAKW;

         // Ermitteln den 1. Tag der aktuellen Kalenderwoche
         CLEAR EXDATE;
         EXDATEJAHR = DUN040;
         EXDATEDAKW = DUN020;
         EXDATEWOTG = 1;
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRKWDA';
         EXSR TRDATE;
         ADATAKKW = RTDATEDATE;

         // Ermitteln den 7. (letzten) Tag der aktuellen Kalenderwoche
         CLEAR EXDATE;
         EXDATEJAHR = DUN040;
         EXDATEDAKW = DUN020;
         EXDATEWOTG = 7;
         EXDATEFMTN = '*ISO';
         EXDATEPGST = 'TRKWDA';
         EXSR TRDATE;
         EDATAKKW = RTDATEDATE;

         CLEAR ADATKW;
         CLEAR EDATKW;

         ADATKW(01) = ADATAKKW;
         EDATKW(01) = EDATAKKW;

         FOR I1 = 1 TO 51;
           CLEAR EXDATE;
           EXDATEDATV = ADATAKKW;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*ISO';
           EXDATEOPCD = '+';
           EXDATEWERT = I1 * 7;
           EXDATEPGST = 'TRERDA';
           EXSR TRDATE;
           ADATKW(I1 + 1) = RTDATEDATE;

           CLEAR EXDATE;
           EXDATEDATV = EDATAKKW;
           EXDATEFMTV = '*ISO';
           EXDATEFMTN = '*ISO';
           EXDATEOPCD = '+';
           EXDATEWERT = I1 * 7;
           EXDATEPGST = 'TRERDA';
           EXSR TRDATE;
           EDATKW(I1 + 1) = RTDATEDATE;
         ENDFOR;

       ENDSR;

       //*************************************************************************
       //**  A U F R U F - M O D U L E                                         ***
       //*************************************************************************
      /COPY QCPYSRC,CHBBEP
      /COPY QCPYSRC,CHTEIL
      /COPY QCPYSRC,CHTEUF
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,TRDATE
      /COPY QCPYSRC,VRMVMONMSG
      /COPY QCPYSRC,VTEUF
       //*************************************************************************
       //**  ENDE DES PROGRAMMS                                                ***
       //*************************************************************************
      /END-FREE
