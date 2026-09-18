     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H DFTACTGRP(*NO)
     H BNDDIR('TRTXT')
      //*************************************************************************
      /TITLE Übernahme "plandaten.txt" und erstellen APPL/APPW
      //*************************************************************************
      //  Copyright 2019 by    trend SWM
      //                       Verwaltungs GmbH
      //                       Jechtingerstrasse 9
      //                       D-79112 Freiburg
      //  --------------------------------------------------------------
      //  Erstellung GS: 04.03.2019 Projekt 14337 Umstellung von Monat auf KW
      //                 Einlesen einer plandaten.TXT-Datei und ausgeben in APPL/APPW
      //  --------------------------------------------------------------
      //  Änderungen GS: 10.09.2019 Projekt 15052, Vorgabe der .TXT. Datei von ","
      //             auf'~'geändert
      //*******************************************************************
      /// Dieses Programm wird durch das CL-Programm WAO065ST bzw. WAO065SJ
      /// aufgerufen und liest aus dem Verzeichnis trend/echt/in/dsx die Datei
      /// "plandaten.txt"ein und erstellt hieraus APPL/APPW-Sätze.
      /// Zuvor werden diese Sätze ab der aktuellen KW in der APPW gelöscht.
      //
      //*************************************************************************
      //*************************************************************************
      //**  DATEIBESCHREIBUNGEN                                               ***
      //*************************************************************************
      //*************************************************************************
      //**  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRDR

      //*************************************************************************
      //**  DATEIEN                                                           ***
      //*************************************************************************
     D APPL          E DS                  INZ
     D KYAPPL        E DS                  INZ

     D APPW          E DS                  INZ
     D KYAPPW        E DS                  INZ

     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ

      //*************************************************************************
      //**  KOMMUNIKATIONSPARAMETER                                           ***
      //*************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS


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

     D EXAPPL        E DS                  INZ
     D RTAPPL        E DS                  INZ
      //
     D EXAPPW        E DS                  INZ
     D RTAPPW        E DS                  INZ

      //*************************************************************************
      //**  INTERNE DATENSTRUKTUR                                             ***
      //*************************************************************************
     D/COPY QCPYSRC,EXTRIN
      //*************************************************************************
      //**  VARIABLE                                                          ***
      //*************************************************************************
     D WKTSTP          S               Z
     D WKAPPLTENR      S                   LIKE(EXAPPLTENR)
     D WKAPPWJAHR      S                   LIKE(EXAPPWJAHR)
     D WKAPPWKAWO      S                   LIKE(EXAPPWKAWO)
     D WKAPPWPLMG      S                   LIKE(EXAPPWPLMG)
     D WKDATEJJKW      S                   LIKE(AWJJKW)
     D WKPLANDATE      S              8S 0
     D WKAPPLPLAT      S                   LIKE(EXAPPLPLAT) INZ('001')
     D WKAPPLWKNR      S                   LIKE(EXAPPLWKNR) INZ('001')
     D WKFILE          S             34A   INZ('plandaten')
     D POSTXT          S              3S 0
     D POSANF          S              3S 0
     D POSEND          S              3S 0
     D FLDLEN          S              3S 0
     D LOCAL_ROOT      S            256A
     D WKDIR           S            256A
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
     D

      // Program name: C_TRAPPL
      // Purpose:
      // Returns:
      // Parameter:      #EXAPPL
      // Parameter:      #RTAPPL
      //--------------------------------------------------
     D C_TRAPPL...
     D                 PR                  EXTPGM('TRAPPL')
     D  #EXAPPL                            LIKEDS(EXAPPL)
     D  #RTAPPL                            LIKEDS(RTAPPL)

      //--------------------------------------------------
      // Program name: C_TRAPPW
      // Purpose:
      // Returns:
      // Parameter:      #EXAPPW
      // Parameter:      #RTAPPW
      //--------------------------------------------------
     D C_TRAPPW...
     D                 PR                  EXTPGM('TRAPPW')
     D  #EXAPPW                            LIKEDS(EXAPPW)
     D  #RTAPPW                            LIKEDS(RTAPPW)
      //*************************************************************************
      //**                                                                    ***
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
       // Löschen der zukünftigen APPW-Sätze
       EXSR DAPPW;

       // Initialisierung der Verzeichnisse
       EXSR INIT;

       // Öffnen der Plandaten.TXT-Datei
       IF RTFS03FENR = *ZERO;
         EXSR OPlandaten;
         // Verarbeiten der Plandaten.txt - Datei
         IF RTFS03FENR = *ZERO;
           EXSR VPlandaten;
         ENDIF;
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

       KYTAFI = DAFIRM;

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
         RTFTPIEMVZ = '/trend/&umgebung/edi/in/dsx';
       ENDIF;

       // Setzen der Umgebung (Echt, Rel oder Test)
       RTFTPIEMVZ = P_SCANRPL(RTFTPIEMVZ: '&umgebung':WKENVI);

       LOCAL_ROOT = %TRIM(RTFTPIEMVZ);
       WKDIR      = %TRIM(LOCAL_ROOT);

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

       ENDSR;
       //*************************************************************************
       //**  Open der Plandatei                                                ***
       //*************************************************************************
       BEGSR OPlandaten;

         // Prüfen ob "tmp" - Plandatei vorhanden dann löschen
         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.tmp';
         C_TRFS04(EXFS04:RTFS04);

         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'DELETE';
           EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.tmp';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         // Prüfen ob 'txt' Datei vorhanden dann für die Verarbeitung umbennen
         CLEAR EXFS04;
         EXFS04PGST = 'CHECK';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.txt';
         C_TRFS04(EXFS04:RTFS04);

         IF RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'RENAME';
           EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.txt';
           EXFS04FILE = %TRIM(WKFILE)+'.tmp';
           C_TRFS04(EXFS04:RTFS04);
         ENDIF;

         CLEAR EXFS04;
         EXFS04PGST = 'OPEN';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.tmp';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;
       //*************************************************************************
       //**  Verarbeiten der Plandaten.txt-Datei                               ***
       //*************************************************************************
       BEGSR VPlandaten;

         RTFS04FENR = *ZERO;

         DOW RTFS04FENR = *ZERO;
           CLEAR EXFS04;
           EXFS04PGST = 'READL';
           EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.tmp';
           EXFS04FILE = %TRIM(WKFILE)+'.tmp';
           C_TRFS04(EXFS04:RTFS04);

           IF %SUBST(RTFS04TEXT:1:1) <> *BLANK;
            EXSR VTXTDATEI;
           ENDIF;

         ENDDO;

       // Schliessen der "tmp" - Datei
         CLEAR EXFS04;
         EXFS04PGST = 'CLOSE';
         EXFS04PATH = %TRIM(LOCAL_ROOT)+'/'+%TRIM(WKFILE)+'.tmp';
         EXFS04AUTH = 'AAA';
         C_TRFS04(EXFS04:RTFS04);

       ENDSR;
       //*************************************************************************
       //**  Verarbeiten der TXT-Datei und Update APPL/APPW                    ***
       //*************************************************************************
       BEGSR VTXTDATEI;

       // Austauschen '|' in '~'
       RTFS04TEXT = P_SCANRPL(RTFS04TEXT:'|':'~');

       // Splitten des Feldinhaltes in einzelne Felder
       RC_SPLIT = P_SPLIT(RTFS04TEXT:'~');

       // Identnummer Feld 4
       WKAPPLTENR = RC_SPLIT_FLD(4);

       // Planungsdatum Feld 11
       RC_SPLIT_FLD(11) = P_SCANRPL(RC_SPLIT_FLD(11): '-': '-');
       WKPLANDATE =  %dec(%date(RC_SPLIT_FLD(11): *ISO): *ISO);

       // Ermitteln Kalenderwoche für das Datum
       EXDATEDATV = WKPLANDATE;
       EXDATEFMTV = '*ISO';
       EXDATEFMTN = '*ISO';
       EXDATEPGST = 'TRERKW';
       EXSR TRDATE;
       WKAPPWJAHR = RTDATEKWJJ;
       WKAPPWKAWO = RTDATEDAKW;

       // Planmenge Feld 12
       WKAPPWPLMG = %dec(RC_SPLIT_FLD(12): 11: 2);

       // Update der Absatzplan-Kopf-Datei
       IF WKAPPLTENR <> EXAPPLTENR;
         EXSR TRAPPL;
       ENDIF;

       // Update der Absatzplan-Wochendatei
       EXSR TRAPPW;

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI APPL                                                 ***
       //*************************************************************************
       BEGSR TRAPPL;

       CLEAR EXAPPL;
       EXAPPLPGST = 'IFAPPL';
       EXAPPLPEDF = 'W';
       EXAPPLPLAT = WKAPPLPLAT;
       EXAPPLWKNR = WKAPPLWKNR;
       EXAPPLTENR = WKAPPLTENR;
       C_TRAPPL(EXAPPL:RTAPPL);

       ENDSR;
       //*************************************************************************
       //**  UPDATE DATEI APPW                                                 ***
       //*************************************************************************
       BEGSR TRAPPW;

       CLEAR EXAPPW;
       EXAPPWIFKZ = *ON;
       EXAPPWPGST = *BLANK;
       EXAPPWPLAT = WKAPPLPLAT;
       EXAPPWWKNR = WKAPPLWKNR;
       EXAPPWTENR = WKAPPLTENR;
       EXAPPWJAHR = WKAPPWJAHR;
       EXAPPWKAWO = WKAPPWKAWO;
       EXAPPWPLMG = WKAPPWPLMG;
       C_TRAPPW(EXAPPW:RTAPPW);

       ENDSR;
       //*******************************************************************
       //**  SR-DAPPW   Löschen APPW-Sätze ab 1. KW im aktuellen Monat
       //*******************************************************************
       BEGSR DAPPW;

       // Ermitteln aktuelle Kalenderwoche
       EXDATEDATV = %DEC(%DATE(): *ISO);
       EXDATEFMTV = '*ISO';
       EXDATEFMTN = '*ISO';
       EXDATEPGST = 'TRERKW';
       EXSR TRDATE;
       WKDATEJJKW = (RTDATEKWJJ * 100) + RTDATEDAKW;

       EXEC SQL
       DELETE FROM APPW
       WHERE AWFIRM =  :DAFIRM
       AND   AWPLAT =  :WKAPPLPLAT
       AND   AWWKNR =  :WKAPPLWKNR
       AND   AWJJKW >= :WKDATEJJKW;

       ENDSR;
       //*************************************************************************
       //**  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
       //*************************************************************************
       BEGSR ETRPA;

       WKTRPA = *ON;

       KYTATA = 'MODWAO';
       KYTATC = 'WAO065';
       KYTAPA = 'FTPIEDI';
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPABEGR = TAPCDE;
       IF WKTRPABEGR = *BLANK;
         WKTRPABEGR = 'EDIWAO065';
       ENDIF;

       ENDSR;
       //*************************************************************************
       //**  A U F R U F - M O D U L E                                         ***
       //*************************************************************************
      /END-FREE
      /COPY QCPYSRC,CHTRPA
      /COPY QCPYSRC,TRDATE
      //*************************************************************************
      //**  ENDE DES PROGRAMMS                                                ***
      //*************************************************************************
