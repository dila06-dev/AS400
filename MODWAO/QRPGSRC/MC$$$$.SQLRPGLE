     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2003')
     H**************************************************************************
     H/TITLE MC-Routine für Datei $$$$
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 16.02.2000
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 02.01.2002 Befehlsnummern aus TRBN ermitteln
     H*  Änderung: RE 07.01.2002 Gültige Funktionstasten für spätere Abfrage
     H*            setzen analog TR-Programm
     H*  Änderung: ZG 22.02.2002 Korr. Erm. des Textets Keine Sätze ....
     H*  Änderung: SC 02.08.2002 OPTION(*SRCSTMT : *NODEBUGIO)
     H*  Änderung: SC 29.08.2002 MC + FILENAME + FELDNAME = MC$$$$QQQQ etc
     H*  Änderung: SC 13.09.2002 TXQQQQ UND TXYYYY umbenannt
     H*  Änderung: HR 20.01.2003 Detailanzeige ohne Window Aufruf mit #CPGST=
     H*            'DETAIL'
     H*  Änderung: X2 14.03.2003 Anpassung Trend-Java-Client
     H*  Änderung: SZ 16.05.2003 Anzeige mit SQL-Selektion
     H*  Änderung: SZ 19.05.2003 LEAVE in Subroutinen gegen LEAVESR getauscht
     H*  Änderung: MG 23.06.2003 F10=Optionen statt einzelne Funktionstaste
     H*  Änderung: SZ 13.08.2003 Close Cursor aus Schleife in B01DS genommen
     H*            Open Cursor analog Close Cursor erstellt.
     H*  Änderung: SC 20.08.2003 Suroutine MCAUFR nach der letzten Prüfroutine
     H*            BM1PR statt mittendrin.
     H*  Änderung: MG 02.09.2003 Bei SQL-Datei nur soviel Sätze lesen wie angezeigt werden
     H*  Änderung: SC 03.09.2003 #CMORE statt *IN91 in SQL-Lese-Routine gesetzt.
     H*  Änderung: SZ 24.10.2003 OTHER Bedingung in MCAUFRUF mit Übergabe des
     H*            Feldnamens. Dadurch können Abfragen auf Feldnamen entfallen,
     H*            für die kein F4 möglich ist.
     H*  Änderung: RE 20.04.2004 SELECT-Anweisung bei Ermitteln des WKMCKZ in
     H*            Routine KEY$$$$, damit nach Löschen der Selektions-Kriterien
     H*            wieder WKMCKZ =01 gesetzt wird
     H*  Änderung: MG 22.04.2004 gemäss I-Series 400 Sitzung vom 05.04.2004
     H*            Separater Objekteintrag in der TRDN für das MC- und TR-Programm
     H*  Änderung: RE 30.04.2004 gemäss I-Series 400 Sitzung vom 05.04.2004
     H*            Sichtensteuerung
     H*  Änderung: SZ 07.06.2004 Zugriff TEXT mit DAUSSP statt DASPCD
     H*  Änderung: RE 10.08.2004
     H*            trend-Java-Client-Sichtensteuerung
     H*  Änderung: RE 25.08.2004 Standard
     H*            Sichten werden in USER-Index gespeichert statt in der Subfile
     H*  Änderung: RE 13.09.2004 Standard
     H*            diverse Korrektur bei SQL-Routine, diese wird nicht mehr mit
     H*            WKMCKZ='02' sondern mit WKMCKZ='KY' gelesen
     H*  Änderung: RE 27.09.2004 Programmstatus ENDE entfernt
     H*  Änderung: RE 30.09.2004 F4 aus Subfile-Anzeige entfernt
     H*            C#CLEA entfernt, da der Cursor nicht mehr über Bezeugszahlen
     H*            gesteuert werden.
     H*  Änderung: MG 18.10.2004 Das TR-Format wird mit 'ENDE  ' geschlossen
     H*            wenn die komplette Subfile verarbeitet ist.
     H*  Änderung: SC 08.11.2004 Status ERMBSK an TRTEXT übergeben, Aufruf TRTRBN
     H*            wird aus TRTEXT durchgeführt.
     H*  Änderung: RE 16.11.2004 WRITE in Routine TRTRDZ entfernt
     H*  Änderung: RE 26.11.2004
     H*            Der XLATE-Befehl für die Umsetzung des Bildschirmfeldes  entfernt
     H*            und direkt über die UCASE-Routine im SQL umgesetzt
     H*            Feldnamen für die SQL-Funktion auf 10 Stellen gekürzt. (SQL... ==> SQ....)
     H*  Änderung: SZ 24.12.2004 FLDNAM in MCAUFR grundsätzlich in EXFLPOFLDN
     H*            ausgeben. Dadurch kann die Übergabe in jeder einzelnen MC-
     H*            Routine entfallen
     H*  Änderung: SZ/RE 10.05.2005 Routine MCAUFR: Aufruf EXFLPO und Abfrage auf
     H*            EXFLPOKZIO für F4 aktiv/inaktiv statt C#LCK0 bzw C#LCK1
     H*  Änderung: RE 24.05.2005 Aktualisierung der Subfile bei den Optionen "2=Ändern,
     H*            3=Kopieren oder 4=Löschen",ansonsten muß die Subfile über F5 aktualisiert werden.
     H*  Änderung: RE 25.05.2005 i-Series400 Sitzung vom 04.11.2004 SQL-Funktion
     H*            Integration der Wildcard-Funktion
     H*  Änderung: MG 04.05.2006 Füllen PCPGST bei Ende der Subfile (Mehrfachauswahl)
     H*  Änderung: RE 14.07.2006 FETCH bei Lesen des CURSOR ans Ende verschoben
     H*            damit C#MORE richtig gesetzt wird (Routine $$$$KY)
     H*            in den Routinen B01SI und BDLSI (F11) wird der User-Index gelesen
     H*            und nicht mehr die Subfile, damit erschein die Sytem-Message
     H*            "Subfile-Satz konnte nicht gelesen werden " nicht mehr
     H*  Änderung: RE 03.08.2006
     H*  Änderung: SZ 29.08.2006 ORDER BY immer mit FIRM wegen Indexaufbau!
     H*  Änderung: RE 07.05.2007 FETCH CURRENT beim Blättern
     H*  Änderung: RE 13.06.2007 dynamischer SQL
     H*            RTSBFLFLDF im Format
     H*  Änderung: WM 30.10.2007 Projekt 3157  Routine UPSBFL integriert
     H*  Änderung: MG 26.02.2008 Korrektur dynamischer SQL
     H*            Leerzeichen bei Eingabe Endfragment nicht berücksichtigen
     H*  Änderung: RE 12.06.2008 bei Update der Subfile wird auch der User-Index
     H*            aktualisiert
     H*  Änderung: RE 24.07.2008 Bei F11 wird die CSRRN nicht mehr in die PAGNBR
     H*            übertragen
     H*            Inaktivieren der Blättertasten bei RCDNBR = 9999
     H*  Änderung: RE 07.08.2008 SQL-Optimierung
     H*            SQL-TRIM entfernt
     H*            FOR FETCH ONLY statt FOR READ ONLY
     H*            OPTIMIZE FOR 200 ROWS
     H*  Änderung: RE 22.04.2009 Subfile wird nach Kopieren immer aktualisiert,
     H*            auch wenn das Verwaltungs-Format mit F12 verlassen wurde
     H*            Bei F11 wird die CSRRN wieder in die PAGNBR übertragen
     H*            sonst wird beim F11 nach dem Rückwärtsblättern falsch in der
     H*            Subfile positioniert (letzte Seite beil Blättern)
     H*  Änderung: RE 07.05.2009 Feld SQ$$$$ZZZZ entfernt, da nicht mehr benötigt.
     H*  Änderung: RE 30.09.2009 RE/CG
     H*            Routine ERPAGE: getrennte Bestückung von Green-Screen und Client-
     H*            Sichten (Abfrage C#IN28)
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei $$$$.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KY$$$$QQQQ Feldbezeichnung
     F*  KOM(11) = KY$$$$YYYY Feldbezeichnung
     F*  KOM(21) = KY$$$$ZZZZ Feldbezeichnung
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMC$$$$FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MC$$$$R1:RCDNBR)
     F                                     SFILE(DL$$$$R1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFL$$$$         S                   LIKE(KY$$$$) DIM(999) DESCEND
     D SFLAUSW         S                   LIKE(SFAUSW) DIM(999)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,MCCURSOR
     D*
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D $$$$          E DS
     D KY$$$$        E DS                  INZ
     D UX$$$$        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
     D*
     D EX$$$$        E DS                  INZ
     D RT$$$$        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX05
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    $$$$
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      KEY$$$$
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      'M1'          WKIFMT
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      MC$$$$FM
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'DL'          BILDDL
     C     WKIFMT        CASEQ     'M1'          BILDM1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     #CRTCD        OREQ      '9'
     C                   CLEAR                   $$$$
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     MC$$$$FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN
     C                   Z-ADD     *ZERO         #CDATV
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KY$$$$FIRM                     $$$$
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'MC$$$$'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         EXTEXTMSGA
     C                   MOVEL(P)  'KEIN'        EXTEXTMSGN
     C                   MOVE      'PRUEFE'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C                   MOVEL(P)  RTTEXTTEXT    TXKEIN
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVE      '01'          WKMCKZ
     C                   Z-ADD     *ZERO         WKPAGE
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*--------------------------------------------------------
     C                   BITOFF    '01234567'    WKAT01
     C                   BITON     '26'          WKAT01
     C                   BITOFF    '01234567'    WKAT02
     C                   BITON     '25'          WKAT02
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *OFF          WKIOKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MC$$$$FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     #CPGST        IFNE      WKPGST
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CMCFG        MCF
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     WKPGST        ANDEQ     *BLANK                                       auf reinen Anzeige-
     C                   MOVE      '5     '      WKPGST                         modus umschalten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DS$$$$QQQQ
     C                   MOVEA(P)  KOM(11)       DS$$$$YYYY
     C                   MOVEA(P)  KOM(21)       DS$$$$ZZZZ
     C                   MOVEA(P)  KOM(31)       DUC008
     C                   TESTN                   DUC008               97
     C*
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC008
     C                   ENDIF
     C*
     C                   Z-ADD     DUN080        WK$$$$VDAT
     C                   MOVEA(P)  KOM(39)       DUC008
     C                   TESTN                   DUC008               97
     C*
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC008
     C                   ENDIF
     C*
     C                   Z-ADD     DUN080        WK$$$$BDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0531'        #CUEBE
     C     #CUEBE        WHENEQ    *BLANK
     C                   MOVE      '0012'        #CUEBE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BNR'         EXTEXTMSGA
     C                   MOVEL(P)  #CUEBE        EXTEXTMSGN
     C                   MOVE      'ERMBSK'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C*
     C                   MOVEL(P)  RTTEXTTEXT    DSBT01
     C                   MOVEA(P)  RTTEXTBSKZ    BSK
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKBT24
     C*-------------------------------------------------------------------------
     C                   MOVE      'M1'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C                   MOVE      *OFF          WKIWND
     C*-------------------------------------------------------------------------
     C     WKPGST        IFNE      *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG $$$$                                                ***
     C**************************************************************************
     C     KEY$$$$       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  DS$$$$YYYY    KY$$$$YYYY
     C                   MOVEL(P)  DS$$$$ZZZZ    KY$$$$ZZZZ
     C*-------------------------------------------------------------------------
     C* Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
     C* Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        UF$$$$QQQQ
     C                   MOVE      *HIVAL        OF$$$$QQQQ
     C                   EVAL      UF$$$$QQQQ = %TRIMR(KY$$$$QQQQ) + UF$$$$QQQQ
     C                   EVAL      OF$$$$QQQQ = %TRIMR(KY$$$$QQQQ) + OF$$$$QQQQ
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        UF$$$$YYYY
     C                   MOVE      *HIVAL        OF$$$$YYYY
     C                   EVAL      UF$$$$YYYY = %TRIMR(KY$$$$YYYY) + UF$$$$YYYY
     C                   EVAL      OF$$$$YYYY = %TRIMR(KY$$$$YYYY) + OF$$$$YYYY
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WK$$$$VDAT    UF$$$$DATE
     C                   MOVEL(P)  WK$$$$BDAT    OF$$$$DATE
     C*
     C     WK$$$$VDAT    IFEQ      *ZERO
     C                   MOVE      *LOVAL        UF$$$$DATE
     C                   ENDIF
     C     WK$$$$BDAT    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OF$$$$DATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM $$$$ '  +
     C                             'WHERE $$$$FIRM = ''' + DAFIRM + ''''
     C*
     C     DS$$$$QQQQ    IFNE      *BLANK
     C                   IF        %SCAN(WCTRD:DS$$$$QQQQ) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND $$$$QQQQ = ''' + DS$$$$QQQQ + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND $$$$QQQQ LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DS$$$$QQQQ)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C     DS$$$$YYYY    IFNE      *BLANK
     C                   IF        %SCAN(WCTRD:DS$$$$YYYY) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND $$$$YYYY = ''' + DS$$$$YYYY + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND $$$$YYYY LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DS$$$$YYYY)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C     DS$$$$VDAT    IFNE      *ZERO
     C     DS$$$$BDAT    ORNE      *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND $$$$DATE BETWEEN ' + %CHAR(UF$$$$DATE)+
     C                             ' AND ' + %CHAR(OF$$$$DATE)
     C                   ENDIF
     C*
     C     DS$$$$ZZZZ    IFNE      *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND UCASE(TRIM($$$$ZZZZ)) +
     C                             LIKE UCASE( + ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DS$$$$ZZZZ))+ ''')'
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY $$$$FIRM, $$$$QQQQ, $$$$YYYY '
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' OPTIMIZE FOR 200 ROWS '
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DS$$$$QQQQ    WHENNE    *BLANK
     C                   MOVE      '01'          WKMCKZ
     C                   OTHER
     C                   MOVE      'KY'          WKMCKZ
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD01                                              ***
     C**************************************************************************
     C     BILD01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   WRITE     MC$$$$01
     C                   WRITE     MC$$$$K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   SELECT
     C     WKPGST        WHENEQ    '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   WRITE     MC$$$$B2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MC$$$$B1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MC$$$$B3
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      MC$$$$K1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#UPDT        WHENEQ    *ON
     C     FUKT05        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVE      *BLANK        KY$$$$YYYY
     C                   EXSR      TR$$$$
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEl(P)  DS$$$$YYYY    KY$$$$YYYY
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      B01SI
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#MUST        WHENEQ    *ON
     C     FUKT20        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   MOVE      *BLANK        KY$$$$QQQQ
     C                   MOVE      *BLANK        KY$$$$YYYY
     C                   EXSR      TR$$$$
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#WEIT        WHENEQ    *ON
     C     FUKT24        ANDEQ     *ON
     C*
     C     WKBT24        IFEQ      *OFF
     C                   MOVE      *ON           WKBT24
     C                   ELSE
     C                   MOVE      *OFF          WKBT24
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#PGUP        WHENEQ    *ON
     C     FUKT26        ANDEQ     *ON
     C                   EXSR      BLAET
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEl(P)  DS$$$$YYYY    KY$$$$YYYY
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      B01RA
     C                   EXSR      B01SF
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C     WKSUPD        ANDEQ     *OFF
     C     #CRTCD        OREQ      'N'
     C     WKSUPD        ANDEQ     *OFF
     C                   ITER
     C     WKSUPD        WHENEQ    *OFF
     C                   ITER
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C     WKUXMCOPEN    IFEQ      *ON
     C                   MOVEL     EXUXMCPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXMCOPEN
     C                   ENDIF
     C*
     C     WKUXMCOPEN    IFNE      *ON
     C                   EXSR      UXMCOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     MC$$$$K1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C                   Z-ADD     *ZERO         RCDNBR
     C                   Z-ADD     *ZERO         PAGNBR
     C*-------------------------------------------------------------------------
     C                   EXSR      CCURSOR
     C                   EXSR      OCURSOR
     C*-------------------------------------------------------------------------
     C     W$RCNO        DOWGT     RCDNBR
     C     W$RCNO        OREQ      *ZERO
     C*
     C                   SELECT
     C     WKMCKZ        WHENEQ    '01'
     C                   EXSR      $$$$01
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      $$$$KY
     C                   ENDSL
     C*
     C                   MOVE      *ON           C#PGUP
     C*--------------------------------------------------------
     C     C#MORE        IFEQ      *ON
     C     W$RCNO        OREQ      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#PGUP
     C*
     C     W$RCNO        IFGT      *ZERO
     C     W$RCNO        ANDLE     RCDNBR
     C                   Z-ADD     W$RCNO        PAGNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      MCUEB
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     B01SI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXMCRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      RCDNBR = EXUXRCNR
     C     RCDNBR        CHAIN     MC$$$$R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK                                       GEÄNDERTE SÄTZE ALS
     C                   MOVE      *ON           C#NEXT                         GEÄNDERT MARKIERT
     C                   ELSE                                                   LASSEN
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    MC$$$$R1
     C                   MOVE      *OFF          C#NEXT
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RETTEN DER AUSWAHL                                                ***
     C**************************************************************************
     C     B01RA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I2
     C                   MOVEL(P)  KY$$$$        WK$$$$
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KY$$$$
     C                   MOVEL(P)  DAFIRM        KY$$$$FIRM
     C                   READC     MC$$$$R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TR$$$$                                       FORMAT SCHLIESSEN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MC$$$$R1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KY$$$$        SFL$$$$(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WK$$$$        KY$$$$
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR SUBFILE                                         ***
     C**************************************************************************
     C     B01SF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      *OFF          WKIDEL
     C                   MOVE      *OFF          WKSUPD
     C                   Z-ADD     *ZERO         WKRCNO
     C                   Z-ADD     *ZERO         W$RCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*-------------------------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MC$$$$R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'ENDE  '      PCPGST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     RCDNBR        W$RCNO
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MC$$$$R1
     C                   MOVE      *OFF          C#NEXT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      %TRIM(SFAUSW)='1' AND BSK(1)='J'
     C                   MOVE      '1     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='2' AND BSK(2)='J'
     C                   MOVE      '2     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='3' AND BSK(3)='J'
     C                   MOVE      '3     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='4' AND BSK(4)='J'
     C                   MOVE      '4     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='5' AND BSK(5)='J'
     C                   MOVE      '5     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)<>' ' AND BSK(10)='J'
     C                   MOVE      'TRTRDZ'      PCPGST
     C                   WHEN      %TRIM(SFAUSW)=' '
     C                   MOVE      '      '      PCPGST
     C                   OTHER
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   MOVEL(P)  KY$$$$        WK$$$$
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WK$$$$        KY$$$$
     C                   Z-ADD     W$RCNO        RCDNBR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKIDEL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   MOVE      'J'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *ON           *IN99
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      TR$$$$
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL     *ON           WKSUPD
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'TRTRDZ'
     C                   EXSR      TRTRDZ
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENNE    *BLANK
     C                   EXSR      TR$$$$
     C*
     C     PCPGST        IFNE      '5'                                          ANZEIGEN
     C     PCPGST        ANDNE     '4'                                          LÖSCHEN
     C     PCPGST        ANDNE     '3'                                          KOPIEREN
     C     #CRTCD        ANDNE     'N'                                          F12 GEDRÜCKT
     C                   EXSR      UPSBFL                                       UPDATE SUBFILE
     C                   ENDIF
     C*
     C                   SELECT
     C     PCPGST        WHENEQ    '2     '
     C*
     C     DATEST        WHENEQ    *BLANK
     C     PCPGST        ANDNE     '5     '
     C                   MOVEL     *ON           WKSUPD
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   MOVEL     *OFF          WKSUPD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MC$$$$R1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    MC$$$$R1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      '2     '      PCPGST
     C                   MOVEL     RT$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL     RT$$$$YYYY    KY$$$$YYYY
     C                   EXSR      TR$$$$
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     RCDNBR        ANDGT     *ZERO
     C     RCDNBR        CHAIN     MC$$$$R1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MC$$$$R1
     C                   MOVE      *OFF          C_AUSW
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG BILD01                                              ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      *ON           C#LCK1
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE LÖSCHANZEIGE                                        ***
     C**************************************************************************
     C     BILDDL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BDLDS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'DL'
     C                   WRITE     MC$$$$01
     C                   WRITE     DL$$$$K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     MC$$$$DL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DL$$$$K1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      BDLSI
     C                   MOVE      *ZERO         WKFENR
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      RFMTS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN LÖSCHANZEIGE                                               ***
     C**************************************************************************
     C     BDLDS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     WKUXDLOPEN    IFEQ      *ON
     C                   MOVEL     EXUXDLPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXDLOPEN
     C                   ENDIF
     C*
     C     WKUXDLOPEN    IFNE      *ON
     C                   EXSR      UXDLOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     DL$$$$K1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     *ZERO         WKRCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      '4 '
     C     SFAUSW        OREQ      ' 4'
     C                   ADD       1             WKRCNO
     C                   WRITE     DL$$$$R1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MC$$$$R1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MC$$$$R1
     C                   MOVE      *OFF          C#NEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             WKPGNO
     C                   MOVE      '0005'        WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     BDLSI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXDLRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      WKRCNO      = EXUXRCNR
     C     WKRCNO        CHAIN     DL$$$$R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK                                       GEÄNDERTE SÄTZE ALS
     C                   MOVE      *ON           C#NEXT                         GEÄNDERT MARKIERT
     C                   ELSE                                                   LASSEN
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    DL$$$$R1
     C                   MOVE      *OFF          C#NEXT
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDM1                                              ***
     C**************************************************************************
     C     BILDM1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'M1'
     C                   EXSR      EFLPO
     C                   WRITE     MC$$$$W3
     C                   WRITE     MC$$$$M1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W3$$$$B1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MC$$$$M1                             9899
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KEY$$$$
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFL$$$$
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         W$RCNO
     C                   MOVE      '01'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT M1                                        ***
     C**************************************************************************
     C     BM1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDM1                                          ***
     C**************************************************************************
     C     BM1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PR$$$$QQQQ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PR$$$$YYYY
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PR$$$$ZZZZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PR$$$$VDAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PR$$$$BDAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILDM1                                           ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$QQQQ'
     C                   EXSR      MC$$$$QQQQ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$YYYY'
     C                   EXSR      MC$$$$YYYY
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$VDAT'
     C                   EXSR      MC$$$$VDAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$BDAT'
     C                   EXSR      MC$$$$BDAT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE QQQQ                                                   ***
     C**************************************************************************
     C     MC$$$$QQQQ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVEA     DS$$$$QQQQ    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$QQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE QQQQ                                                   ***
     C**************************************************************************
     C     PR$$$$QQQQ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DS$$$$QQQQ    IFNE      *BLANK
     C                   MOVEL(P)  'QQQQ'        KYTPTA
     C                   MOVEL(P)  DS$$$$QQQQ    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE YYYY                                                   ***
     C**************************************************************************
     C     MC$$$$YYYY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'YYYY'        KOM(02)
     C                   MOVEA     DS$$$$YYYY    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$YYYY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE YYYY                                                   ***
     C**************************************************************************
     C     PR$$$$YYYY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$YYYY'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DS$$$$YYYY    IFNE      *BLANK
     C                   MOVEL(P)  'YYYY'        KYTPTA
     C                   MOVEL(P)  DS$$$$YYYY    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ZZZZ                                                   ***
     C**************************************************************************
     C     PR$$$$ZZZZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$ZZZZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VDAT                                                   ***
     C**************************************************************************
     C     MC$$$$VDAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$VDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*
     C     DS$$$$VDAT    IFEQ      *ZERO
     C                   MOVEL(P)  'POSAKT'      EXDATEPGCD
     C                   ENDIF
     C*
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   Z-ADD     RTDATEDATE    DS$$$$VDAT
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VDAT                                                   ***
     C**************************************************************************
     C     PR$$$$VDAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$VDAT'  EXFLPOFLDN
     C                   MOVEL(P)  *ZERO         WK$$$$VDAT
     C*-------------------------------------------------------------------------
     C     DS$$$$VDAT    IFNE      *ZERO
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$VDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C                   Z-ADD     RTDATEDATE    DS$$$$VDAT
     C*
     C                   MOVEL     DS$$$$VDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WK$$$$VDAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE BDAT                                                   ***
     C**************************************************************************
     C     MC$$$$BDAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$BDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*
     C     DS$$$$BDAT    IFEQ      *ZERO
     C                   MOVEL(P)  'POSAKT'      EXDATEPGCD
     C                   ENDIF
     C*
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   Z-ADD     RTDATEDATE    DS$$$$BDAT
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BDAT                                                   ***
     C**************************************************************************
     C     PR$$$$BDAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$BDAT'  EXFLPOFLDN
     C                   MOVEL(P)  *ZERO         WK$$$$BDAT
     C*-------------------------------------------------------------------------
     C     DS$$$$BDAT    IFNE      *ZERO
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$BDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C                   Z-ADD     RTDATEDATE    DS$$$$BDAT
     C*
     C                   MOVEL     DS$$$$BDAT    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WK$$$$BDAT
     C*
     C     WK$$$$VDAT    IFGT      WK$$$$BDAT
     C                   MOVEL     '3175'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'SFAUSW'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BLAETTERROUTINE                                                   ***
     C**************************************************************************
     C     BLAET         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    '01'
     C                   EXSR      $$$$01
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      $$$$KY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     MC$$$$LO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE ÜBERSCHRIFT ERMITTELN                                   ***
     C**************************************************************************
     C     MCUEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCUB'      WKSBFLPGST
     C                   Z-ADD     WKISIC        WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBE
     C                   EXSR      UMUEBE
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBEJV
     C                   EXSR      UMUEBEJV
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR                                                      ***
     C**************************************************************************
     C     CCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKOPENKY      WHENEQ    *ON
     C                   EXSR      CC$$$$KY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  OPEN CURSOR                                                       ***
     C**************************************************************************
     C     OCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    'KY'
     C     WKOPENKY      ANDNE     *ON
     C                   EXSR      OC$$$$KY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI $$$$                                               ***
     C**************************************************************************
     C     $$$$01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     11            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFNE      *ON
     C                   MOVEL(P)  UF$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  UF$$$$YYYY    KY$$$$YYYY
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CH$$$$
     C*--------------------------------------------------------
     C                   ELSE
     C*--------------------------------------------------------
     C                   MOVEL(P)  OG$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  OG$$$$YYYY    KY$$$$YYYY
     C                   MOVEA     '01G     '    CHI
     C                   EXSR      CH$$$$
     C                   Z-ADD     WKRENO        RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE +1)
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CH$$$$
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     $$$$FIRM      ORGT      KY$$$$FIRM
     C     $$$$QQQQ      ORGT      OF$$$$QQQQ
     C     $$$$YYYY      ORGT      OF$$$$YYYY
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      9999
     C                   MOVEL     '0374'        WKFENR
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C                   MOVEL     $$$$QQQQ      KY$$$$QQQQ
     C                   MOVEL     $$$$YYYY      KY$$$$YYYY
     C*
     C                   ADD       1             RCDNBR
     C*
     C                   EXSR      ADUMM
     C*                                                                         ANZEIGE
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW
     C                   EXSR      FKONS
     C*
     C                   WRITE     MC$$$$R1
     C                   EXSR      UXMCWRTE
     C*
     C                   MOVEL(P)  $$$$QQQQ      OG$$$$QQQQ
     C                   MOVEL(P)  $$$$YYYY      OG$$$$YYYY
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             I0
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      ERPAGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR $$$$KY                                             ***
     C**************************************************************************
     C     OC$$$$KY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQ$$$$   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE $$$$KY SCROLL CURSOR FOR SQ$$$$
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN $$$$KY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI $$$$                                               ***
     C**************************************************************************
     C     $$$$KY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     11            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C/EXEC SQL
     C+ FETCH CURRENT FROM $$$$KY INTO :$$$$
     C/END-EXEC
     C                   Z-ADD     WKRENO        RCDNBR                         ZURÜCKSCHR.
     C                   ELSE
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM $$$$KY INTO :$$$$
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE+1)
     C*--------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C     RCDNBR        OREQ      9999
     C                   MOVE      *ON           C#MORE                         SFLEND-KENNZ.
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C                   MOVEL     $$$$QQQQ      KY$$$$QQQQ
     C                   MOVEL     $$$$YYYY      KY$$$$YYYY
     C*
     C                   ADD       1             RCDNBR
     C*
     C                   EXSR      ADUMM
     C*
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW
     C                   EXSR      FKONS
     C*
     C                   WRITE     MC$$$$R1
     C                   EXSR      UXMCWRTE
     C*
     C/EXEC SQL
     C+ FETCH NEXT FROM $$$$KY INTO :$$$$
     C/END-EXEC
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             I0
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      ERPAGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI $$$$KY                                         ***
     C**************************************************************************
     C     CC$$$$KY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE $$$$KY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN FÜR ANZEIGEN                                          ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QQQQ'        KYTPTA
     C                   MOVEL(P)  $$$$QQQQ      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TX$$$$QQQQ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'YYYY'        KYTPTA
     C                   MOVEL(P)  $$$$YYYY      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TX$$$$YYYY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SICHTEN                                                           ***
     C**************************************************************************
     C     ERSIC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SIC
     C*
     C     SIC           DOWLE     10
     C     FSI(SIC)      ANDNE     *ZERO
     C                   MOVEL     'ERMCUZ'      WKSBFLPGST
     C                   Z-ADD     FSI(SIC)      WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C
     C                   SELECT
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1JV
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2JV
     C     SIC           WHENEQ    3
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS3
     C     SIC           WHENEQ    4
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS4
     C     SIC           WHENEQ    5
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS5
     C     SIC           WHENEQ    6
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS6
     C     SIC           WHENEQ    7
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS7
     C     SIC           WHENEQ    8
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS8
     C     SIC           WHENEQ    9
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS9
     C     SIC           WHENEQ    10
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS10
     C                   ENDSL
     C*
     C                   ADD       1             SIC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON KONS MIT DER JEWEILIGEN SICHT                          ***
     C**************************************************************************
     C     FKONS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     SI            WHENEQ    1
     C                   MOVEL     EXUXS1        SFKONS
     C                   MOVEL     EXUXS1JV      SFKONSJV
     C     SI            WHENEQ    2
     C                   MOVEL     EXUXS2        SFKONS
     C                   MOVEL     EXUXS2JV      SFKONSJV
     C     SI            WHENEQ    3
     C                   MOVEL     EXUXS3        SFKONS
     C     SI            WHENEQ    4
     C                   MOVEL     EXUXS4        SFKONS
     C     SI            WHENEQ    5
     C                   MOVEL     EXUXS5        SFKONS
     C     SI            WHENEQ    6
     C                   MOVEL     EXUXS6        SFKONS
     C     SI            WHENEQ    7
     C                   MOVEL     EXUXS7        SFKONS
     C     SI            WHENEQ    8
     C                   MOVEL     EXUXS8        SFKONS
     C     SI            WHENEQ    9
     C                   MOVEL     EXUXS9        SFKONS
     C     SI            WHENEQ    10
     C                   MOVEL     EXUXS10       SFKONS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON AUSW BEIM NEUAUFBAU DER SUBFILE                        ***
     C**************************************************************************
     C     FAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KY$$$$        LOOKUP    SFL$$$$(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#NEXT
     C                   MOVEL(P)  SFLAUSW(I1)   SFAUSW
     C                   ELSE
     C                   MOVE      *OFF          C#NEXT
     C                   MOVE      *BLANK        SFAUSW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN VON AUSW NACH ERFOLGREICHER BEARBEITUNG                   ***
     C**************************************************************************
     C     LAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KY$$$$        LOOKUP    SFL$$$$(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFL$$$$(I1)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SEITE                                                   ***
     C**************************************************************************
     C     ERPAGE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     RCDNBR        WHENEQ    *ZERO
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     1             PAGNBR
     C                   MOVE      *ON           C#NDSP
     C                   MOVE      *ON           WKILER
     C     C#IN28        IFEQ      *OFF
     C                   MOVEL(P)  TXKEIN        EXUXS1
     C                   MOVEL(P)  TXKEIN        EXUXS2
     C                   MOVEL(P)  TXKEIN        EXUXS3
     C                   MOVEL(P)  TXKEIN        EXUXS4
     C                   MOVEL(P)  TXKEIN        EXUXS5
     C                   MOVEL(P)  TXKEIN        EXUXS6
     C                   MOVEL(P)  TXKEIN        EXUXS7
     C                   MOVEL(P)  TXKEIN        EXUXS8
     C                   MOVEL(P)  TXKEIN        EXUXS9
     C                   MOVEL(P)  TXKEIN        EXUXS10
     C                   MOVEL(P)  TXKEIN        SFKONS
     C                   ELSE
     C                   MOVEL(P)  TXKEIN        EXUXS1JV
     C                   MOVEL(P)  TXKEIN        EXUXS2JV
     C                   MOVEL(P)  TXKEIN        SFKONSJV
     C                   ENDIF
     C                   WRITE     MC$$$$R1
     C                   EXSR      UXMCWRTE
     C*--------------------------------------------------------
     C     RCDNBR        WHENNE    *ZERO
     C     RCDNBR        SUB       1             PAGNBR
     C                   DIV       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   MULT      W$PAGE        PAGNBR
     C                   SUB       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   Z-ADD     PAGNBR        WKPAGE
     C                   Z-ADD     RCDNBR        WKRENO
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI $$$$                                                 ***
     C**************************************************************************
     C     TR$$$$        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EX$$$$
     C                   MOVEL(P)  PCPGST        EX$$$$PGST
     C                   MOVEL(P)  KY$$$$QQQQ    EX$$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    EX$$$$YYYY
     C*
     C                   CALL      'TR$$$$'
     C                   PARM                    EX$$$$
     C                   PARM                    RT$$$$
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RT$$$$PROG    WKPROG
     C                   MOVEL(P)  RT$$$$DANA    WKDANA
     C                   MOVEL(P)  RT$$$$FFLD    WKFFLD
     C                   MOVEL(P)  RT$$$$FENR    WKFENR
     C                   MOVEL(P)  RT$$$$PA03    W$PA03
     C                   MOVEL(P)  RT$$$$PA04    W$PA04
     C                   MOVEL(P)  RT$$$$PA05    W$PA05
     C                   MOVEL(P)  RT$$$$PA06    W$PA06
     C                   MOVEL(P)  RT$$$$PA07    W$PA07
     C*
     C                   MOVEL(P)  RT$$$$RTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF SUBFILE-ZEILEN-ERMITTLUNG                                  ***
     C**************************************************************************
     C     TRAUFRSBFL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSBFL
     C                   MOVEL(P)  'MC$$$$'      EXSBFLPROG
     C                   MOVEL(P)  'MC$$$$FM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  '$$$$'        EXSBFLFIL1
     C                   MOVEL(P)  $$$$          EXSBFLDAT1
     C*
     C                   MOVEL(P)  '##QQQQ'      EXSBFLAF01
     C                   MOVEL(P)  TX$$$$QQQQ    EXSBFLAL01
     C*
     C                   MOVEL(P)  '##YYYY'      EXSBFLAF02
     C                   MOVEL(P)  TX$$$$YYYY    EXSBFLAL02
     C*
     C                   EXSR      TRSBFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCSI'      WKSBFLPGST
     C                   Z-ADD     *ZERO         WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEA(P)  RTSBFLMCSI    WSI
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SI
     C                   Z-ADD     *ZERO         FSI
     C*--------------------------------------------------------
     C                   DO        10            I1
     C                   TESTN                   WSI(I1)              97
     C*
     C     *IN97         IFEQ      *ON
     C                   ADD       1             SI
     C                   MOVE      WSI(I1)       FSI(SI)
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SI
     C                   Z-ADD     FSI(SI)       WKISIC                         SICHT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSWAHL 10 UND ZUGRIFF AUF TRTRDZ                                 ***
     C**************************************************************************
     C     TRTRDZ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *OFF          WKTRDZZYKL
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRDN
     C                   MOVEL(P)  SFAUSW        EXTRDNAWCD
     C                   MOVEL(P)  'MC$$$$'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'MC$$$$B1'    EXTRDNPGNA
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'MC$$$$B2'    EXTRDNPGNA
     C                   ENDIF
     C*
     C                   MOVE      C#FUKT        EXTRDNFUKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRTK'
     C                   EXSR      MCAUFRTRTK
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*
     C     SFAUSW        IFNE      *BLANK
     C     SFAUSW        ANDNE     '10'
     C                   LEAVE
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#BACK        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE SUBFILE-SATZ                                               ***
     C**************************************************************************
     C     UPSBFL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MC$$$$R1                           97
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  $$$$QQQQ      KY$$$$QQQQ
     C                   MOVEL(P)  $$$$YYYY      KY$$$$YYYY
     C*--------------------------------------------------------                 ANZEIGE
     C                   MOVE      *OFF          C#NDSP
     C*
     C                   EXSR      ADUMM
     C*
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW                                        PRÜFEN, OB AUSW EXIT
     C                   EXSR      FKONS                                        SICHT ÄNDERN
     C*
     C                   MOVE      *ON           C#NEXT                         ALS GEÄNDERT
     C                   UPDATE    MC$$$$R1                                     MARKIERT LASSEN
     C                   EXSR      UXMCRMKY
     C                   EXSR      UXMCWRTE
     C                   MOVE      *OFF          C#NEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXMCOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXMCPARM
     C                   EVAL      EXUXMCINAM = 'MCSBF$$$$'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile MC$$$$'
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXMCOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXMCWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = RCDNBR
     C                   EVAL      UX$$$$FIRM  = KY$$$$FIRM
     C                   EVAL      UX$$$$QQQQ  = KY$$$$QQQQ
     C                   EVAL      UX$$$$YYYY  = KY$$$$YYYY
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UX$$$$
     C                   EVAL      EXUXMCIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXMCREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KY$$$$
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UX$$$$)
     C                   EVAL      UX$$$$      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KY$$$$FIRM  = UX$$$$FIRM
     C                   EVAL      KY$$$$QQQQ  = UX$$$$QQQQ
     C                   EVAL      KY$$$$YYYY  = UX$$$$YYYY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN   USERINDEX                                               ***
     C**************************************************************************
     C     UXMCRMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUXRCNR     = RCDNBR
     C                   EVAL      UX$$$$FIRM  = KY$$$$FIRM
     C                   EVAL      UX$$$$QQQQ  = KY$$$$QQQQ
     C                   EVAL      UX$$$$YYYY  = KY$$$$YYYY
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UX$$$$
     C                   EVAL      EXUXMCIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCRMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXDLOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXDLPARM
     C                   EVAL      EXUXDLINAM  = 'DLSBF$$$$'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DL$$$$'
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXDLOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXDLWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = WKRCNO
     C                   EVAL      UX$$$$FIRM  = KY$$$$FIRM
     C                   EVAL      UX$$$$QQQQ  = KY$$$$QQQQ
     C                   EVAL      UX$$$$YYYY  = KY$$$$YYYY
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UX$$$$
     C                   EVAL      EXUXDLIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXDLREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KY$$$$
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UX$$$$)
     C                   EVAL      UX$$$$      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KY$$$$FIRM  = UX$$$$FIRM
     C                   EVAL      KY$$$$QQQQ  = UX$$$$QQQQ
     C                   EVAL      KY$$$$YYYY  = UX$$$$YYYY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILER
     C     *LIKE         DEFINE    WKC001        WKAT01
     C     *LIKE         DEFINE    WKC001        WKAT02
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIWND
     C     *LIKE         DEFINE    WKC001        WKMCKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKBT24
     C*
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPENKY
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        TX$$$$QQQQ      +39
     C     *LIKE         DEFINE    WKC001        TX$$$$YYYY      +39
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSUPD
     C     *LIKE         DEFINE    WKC001        WKIDEL
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        TXKEIN          +75
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        SI              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKISIC           +1
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    PAGNBR        WKPAGE
     C     *LIKE         DEFINE    PAGNBR        W$PAGE
     C     *LIKE         DEFINE    RCDNBR        WKRENO
     C     *LIKE         DEFINE    RCDNBR        W$RCNO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KY$$$$        WK$$$$
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KY$$$$QQQQ    OG$$$$QQQQ
     C     *LIKE         DEFINE    KY$$$$QQQQ    UF$$$$QQQQ
     C     *LIKE         DEFINE    KY$$$$QQQQ    OF$$$$QQQQ
     C*
     C     *LIKE         DEFINE    KY$$$$YYYY    OG$$$$YYYY
     C     *LIKE         DEFINE    KY$$$$YYYY    UF$$$$YYYY
     C     *LIKE         DEFINE    KY$$$$YYYY    OF$$$$YYYY
     C*
     C     *LIKE         DEFINE    $$$$DATE      UF$$$$DATE
     C     *LIKE         DEFINE    $$$$DATE      OF$$$$DATE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RT$$$$PROG    WKPROG
     C     *LIKE         DEFINE    RT$$$$DANA    WKDANA
     C     *LIKE         DEFINE    RT$$$$FFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    $$$$DATE      WK$$$$VDAT
     C     *LIKE         DEFINE    $$$$DATE      WK$$$$BDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'
     C                   PARM                    WKFENR
     C                   PARM                    KEYVAR
     C                   PARM                    DSJNAM
     C                   PARM                    DSUSER
     C                   PARM                    W$PA03
     C                   PARM                    W$PA04
     C                   PARM                    W$PA05
     C                   PARM                    W$PA06
     C                   PARM                    W$PA07
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MC$$$$'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CT$$$$W3
     C                   OTHER
     C                   WRITE     MC$$$$CT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CT$$$$W3
     C                   OTHER
     C                   WRITE     MC$$$$CT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *BLANK        W$PA08
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CH$$$$
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRSBFL
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
