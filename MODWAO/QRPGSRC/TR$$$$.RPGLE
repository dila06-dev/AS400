     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei $$$$
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 13.02.2001 für Kunde XXX Projekt XXXX
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 08.01.2004 Übergabe F-Taste beim Aufruf TRTRDZ
     H*  Änderung: SZ 12.01.2004 Aufruf TRDATE korrigiert (CLEAR u. PGST)
     H*  Änderung: ZG 09.03.2004 CLOSE TR$$$$FM immer am Ende
     H*  Änderung: MG 22.04.2004 gemäss I-Series 400 Sitzung vom 05.04.2004
     H*            Separater Objekteintrag in der TRDN für das MC- und TR-
     H*            Programm
     H*  Änderung: MG 06.05.2004 gemäss I-Series 400 Sitzung vom 03.05.2004
     H*            Im TR-Programm wird nur der TR-Eintrag verwendet für die
     H*            F10=Option.
     H*  Änderung: RE 02.06.2004 Aufruf Programm INZDATASTR in Routine UEB$$$$
     H*            und ETRMU zur Initialisierung der Datenstrukturen
     H*  Änderung: MG 22.06.2004 Aufruf der Anfangsroutine bei Firmenwechsel
     H*            (DAFIRM/WKFIRM)
     H*  Änderung: RE 27.09.2004 Programmstatus ENDE entfernt
     H*  Änderung: RE 30.09.2004
     H*            C#CLEA entfernt, da der Cursor nicht mehr über Bezeugszahlen
     H*            gesteuert werden.
     H*  Änderung: MG 18.10.2004 Das TR-Format wird mit 'ENDE  ' geschlossen
     H*            wenn die komplette Subfile verarbeitet ist.
     H*  Änderung: MG 09.11.2004 Löschroutine L$$$$ und P$$$$ geändert
     H*            WKFENR muß zurückgesetzt werden wenn keine Datensatz in der
     H*            Datei vorhanden ist, anderfalls führt das Löschen zu einem
     H*            Fehler
     H*  Änderung: RE 16.11.2004 WRITE in Routine TRTRDZ entfernt
     H*  Änderung: SZ 24.12.2004 FLDNAM in MCAUFR grundsätzlich in EXFLPOFLDN
     H*            ausgeben. Dadurch kann die Übergabe in jeder einzelnen MC-
     H*            Routine entfallen
     H*  Änderung: SZ 28.12.2004 Bei Aufruf TRDATE als MC-Aufruf jetzt WKTRTP
     H*            abfragen (alt: RTDATEDATE <> *ZERO). Setzen WKTRTP wurde neu
     H*            in /COPY-Modul aufgenommen.
     H*  Änderung: SZ 08.05.2005 Routine AUFFOR (Aufbereiten für Format). Die
     H*            Zugriffe für Überschrift u.a. wurden in diese Routine ver-
     H*            lagert.
     H*  Änderung: SZ/RE 10.05.2005 Routine MCAUFR: Aufruf EXFLPO und Abfrage
     H*            auf EXFLPOKZIO für F4 aktiv/inaktiv statt C#LCK0 bzw C#LCK1
     H*  Änderung: RE 24.05.2005 Externes Update
     H*            EX$$$$IFKZ = '1' der übergebene PGM-Status ist für die Steue-
     H*                             rung Neuanlage oder Änderung ausschlaggebend
     H*            EX$$$$IFKZ = '0' das PGM ermittelt selber, ob Neuanlage oder
     H*                             Änderung
     H*            Fehlermeldung in Prüf-Routine B01PR, wenn der Datensatz bei
     H*            PGM-Status "2=Ändern" nicht vorhanden ist
     H*  Änderung: GS 14.11.2005 Aufruf der Routine E$$$$ unmittelbar nach der
     H*            ETRMU-Routine damit bei Neuanlage auch die J/N-Felder
     H*            vorbelegt werden. (XCAL-Problematik)
     H*  Änderung: SZ 25.01.2006 WKTDAT als Einzelfeld gekennzeichnet, damit
     H*            das Feld nicht Teil der im Source vorangehenden Struktur wird
     H*  Änderung: SZ 25.01.2006 RT-Strukturen nicht beim Programmaufruf ini-
     H*            tialisieren. Diese werden im aufgerufenen Programm initiali-
     H*  Änderung: GS 09.06.2006 Integration Externe Prüfung PRAUFR. Siehe hierzu auch
     H*            Erweiterung in EX$$$$ (neues Feld EX$$$$FLDN)
     H*  Änderung: SZ 29.06.2006 In Routine MCAUFR müssen weiterhin über C#LCK0,
     H*            C#LCK1 usw. gesperrte Felder einzeln abgefragt werden, damit
     H*            im gesperrten Zustand kein F4 möglich ist.
     H*  Änderung: RE 03.08.2006
     H*  Änderung: RE 14.06.2007 Freigabe des Satz in der Routine IF$$$$
     H*  Änderung: RE 24.07.2008 Routine BIDLPR: Aufruf EXFLPO und Abfrage
     H*            auf EXFLPOKZIO
     H*  Änderung: RE 31.07.2008 Routine U$$$$: Update $$$$PROG mit DAPROG
     H*  Änderung: RE 04.10.2011 "DIREKT"-Aufruf von TRTRDZ auch im Anzeige-Modus
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei $$$$.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTR$$$$FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D $$$$          E DS                  INZ
     D KY$$$$        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
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
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EX$$$$        E DS
     D RT$$$$        E DS
     D*
     D EXQQQQ        E DS                  INZ
     D RTQQQQ        E DS                  INZ
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
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
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
     C                   PARM                    EX$$$$
     C                   PARM                    RT$$$$
     C*
     C                   EXSR      UEB$$$$
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '                                     BILDSCHIRMFORMAT
     C*                                                                         SCHLIESSEN
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TR$$$$FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'P$$$$ '
     C                   EXSR      P$$$$
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      P$$$$
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      L$$$$
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EX$$$$IFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IF$$$$                                       UPDATE
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     DATEST        WHENEQ    '5'
     C                   MOVE      '5     '      PCPGST
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      TR$$$$FM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TR$$$$FM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RT$$$$RTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        WKFIRM
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
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KY$$$$FIRM                     $$$$
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TR$$$$FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TR$$$$FM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EX$$$$                         ***
     C**************************************************************************
     C     UEB$$$$       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EX$$$$'      EXDATAFILE
     C                   MOVEL(P)  EX$$$$        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EX$$$$
     C*-------------------------------------------------------------------------
     C                   MOVEL     EX$$$$PGST    PCPGST
     C*
     C                   MOVEL(P)  EX$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  EX$$$$YYYY    KY$$$$YYYY
     C*
     C                   MOVEL(P)  EX$$$$QQQQ    DS$$$$QQQQ
     C                   MOVEL(P)  EX$$$$YYYY    DS$$$$YYYY
     C*
     C                   MOVEL(P)  EX$$$$NQQQ    DS$$$$NQQQ
     C                   MOVEL(P)  EX$$$$NYYY    DS$$$$NYYY
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RT$$$$
     C                   MOVEL     *ZERO         RT$$$$FENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITUNG FÜR FORMATANZEIGE                                    ***
     C**************************************************************************
     C     AUFFOR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'TR$$$$'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
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
     C                   MOVEL     'TR$$$$01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TR$$$$01
     C                   WRITE     TR$$$$B1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TR$$$$01                             9899
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
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#ACCS        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C*
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
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      U$$$$
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C                   MOVE      *BLANK        KY$$$$QQQQ
     C                   MOVE      *BLANK        KY$$$$YYYY
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CH$$$$
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CH$$$$
     C                   ENDSL
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
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   $$$$
     C                   EXSR      ETRMU
     C                   EXSR      E$$$$
     C                   MOVEL(P)  KY$$$$QQQQ    $$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    $$$$YYYY
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C                   MOVEL(P)  $$$$USER      WKUSER
     C                   Z-ADD     $$$$JDAT      WKJDAT
     C                   Z-ADD     $$$$JZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CH$$$$
     C                   EXSR      E$$$$
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  $$$$QQQQ      DS$$$$QQQQ
     C                   MOVEL(P)  $$$$YYYY      DS$$$$YYYY
     C                   MOVEL(P)  $$$$ZZZZ      DS$$$$ZZZZ
     C                   Z-ADD     $$$$0000      DS$$$$0000
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     $$$$DATE      EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TX$$$$QQQQ                     INITIALISIEREN
     C                   MOVE      *BLANK        TX$$$$YYYY                     TEXTFELDER
     C*-------------------------------------------------------------------------
     C     DS$$$$QQQQ    CASNE     *BLANK        PR$$$$QQQQ                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DS$$$$YYYY    CASNE     *BLANK        PR$$$$YYYY
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TR$$$$01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     PCRTCD        IFEQ      'W'
     C                   MOVE      '0070'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DS$$$$ZZZZ'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DS$$$$ZZZZ'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     PCPGST        ANDNE     *BLANK
     C     PCPGST        ANDNE     'MUSTER'
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKJDAT        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   EVAL      W$PA03 = %TRIM(%EDITW(RTDATEDATE :
     C                              '0 .  .    '))
     C                   MOVEL(P)  WKUSER        W$PA04
     C                   EVAL      W$PA05 = %TRIM(%EDITW(WKJZEI : '0 :  :  '))
     C                   MOVE      '0076'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDK1                                              ***
     C**************************************************************************
     C     BILDK1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BK1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'K1'
     C                   MOVEL     'TR$$$$K1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TR$$$$W2
     C                   WRITE     TR$$$$K1
     C                   WRITE     W2$$$$B1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TR$$$$K1                             9899
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
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
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
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      K$$$$
     C                   EXSR      U$$$$
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KY$$$$QQQQ    RT$$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    RT$$$$YYYY
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RT$$$$RTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT K1                                        ***
     C**************************************************************************
     C     BK1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KY$$$$QQQQ    DS$$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    DS$$$$YYYY
     C*
     C                   MOVEL(P)  KY$$$$QQQQ    DS$$$$NQQQ
     C                   MOVE      *BLANK        DS$$$$NYYY
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$NYYY'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DS$$$$QQQQ'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DS$$$$YYYY'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DS$$$$DATE'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DS$$$$JNKZ'
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
     C     FLDNAM        WHENEQ    'DS$$$$DATE'
     C                   EXSR      MC$$$$DATE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$JNKZ'
     C                   EXSR      MC$$$$JNKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$NQQQ'
     C                   EXSR      MC$$$$NQQQ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DS$$$$NYYY'
     C                   EXSR      MC$$$$NYYY
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR FORMATE                                         ***
     C**************************************************************************
     C     BILDPR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEA     EXFLPOFLDA    FLD
     C*-------------------------------------------------------------------------
     C     1             DO        100           FL
     C*-------------------------------------------------------------------------
     C     FLD(FL)       IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     FLD(FL)       FLDNAM
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*----------------------------------------------------------
     C                   SELECT
     C     EXFLPOKZIO    WHENEQ    *OFF
     C*
     C     FLDNAM        WHENEQ    'DS$$$$QQQQ'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PR$$$$QQQQ
     C     FLDNAM        WHENEQ    'DS$$$$YYYY'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PR$$$$YYYY
     C     FLDNAM        WHENEQ    'DS$$$$ZZZZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PR$$$$ZZZZ
     C     FLDNAM        WHENEQ    'DS$$$$0000'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PR$$$$0000
     C     FLDNAM        WHENEQ    'DS$$$$DATE'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PR$$$$DATE
     C     FLDNAM        WHENEQ    'DS$$$$JNKZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PR$$$$JNKZ
     C     FLDNAM        WHENEQ    'DS$$$$NQQQ'
     C                   EXSR      PR$$$$NQQQ
     C     FLDNAM        WHENEQ    'DS$$$$NYYY'
     C                   EXSR      PR$$$$NYYY
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    '3     '
     C                   MOVEL(P)  DS$$$$NQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  DS$$$$NYYY    KY$$$$YYYY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DS$$$$NYYY'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      '      '
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  DS$$$$YYYY    KY$$$$YYYY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DS$$$$QQQQ'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDSL
     C*----------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRMU                                                 ***
     C**************************************************************************
     C     UTRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '$$$$'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  $$$$          TRMUDATA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TRMUJNAM
     C                   MOVEL(P)  WKCHPN        TRMUPROG
     C                   MOVEL(P)  WKCHPL        TRMUBIBL
     C                   MOVEL(P)  DAUSER        TRMUUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TRMUJZEI
     C                   MOVE      WKTDAT        TRMUJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'W'           #CRTCD
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'U'           #CRTCD
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOPIEREN SÄTZE AUS DATEI $$$$                                     ***
     C**************************************************************************
     C     K$$$$         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  DS$$$$YYYY    KY$$$$YYYY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  $$$$ZZZZ      DS$$$$ZZZZ
     C                   Z-ADD     $$$$0000      DS$$$$0000
     C                   MOVEL(P)  $$$$JNKZ      DS$$$$JNKZ
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     $$$$DATE      EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB $$$$-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     P$$$$         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KY$$$$QQQQ    OF$$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    OF$$$$YYYY
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CH$$$$
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     $$$$FIRM      ANDEQ     KY$$$$FIRM
     C     $$$$QQQQ      ANDLE     OF$$$$QQQQ
     C     $$$$YYYY      ANDLE     OF$$$$YYYY
     C*--------------------------------------------------------
     C     $$$$LOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  '$$$$LOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      'PQQQQ '      PCPGST
     C                   EXSR      TRQQQQ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CH$$$$
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RT$$$$
     C                   MOVEL(P)  WKPROG        RT$$$$PROG
     C                   MOVEL(P)  WKDANA        RT$$$$DANA
     C                   MOVEL(P)  WKFFLD        RT$$$$FFLD
     C                   MOVEL(P)  WKFENR        RT$$$$FENR
     C                   MOVEL(P)  W$PA03        RT$$$$PA03
     C                   MOVEL(P)  W$PA04        RT$$$$PA04
     C                   MOVEL(P)  W$PA05        RT$$$$PA05
     C                   MOVEL(P)  W$PA06        RT$$$$PA06
     C                   MOVEL(P)  W$PA07        RT$$$$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI $$$$                                          ***
     C**************************************************************************
     C     L$$$$         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KY$$$$QQQQ    OF$$$$QQQQ
     C                   MOVEL(P)  KY$$$$YYYY    OF$$$$YYYY
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CH$$$$
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     $$$$FIRM      ANDEQ     KY$$$$FIRM
     C     $$$$QQQQ      ANDLE     OF$$$$QQQQ
     C     $$$$YYYY      ANDLE     OF$$$$YYYY
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  $$$$QQQQ      KY$$$$QQQQ
     C                   MOVEL(P)  $$$$YYYY      KY$$$$YYYY
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CH$$$$
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CH$$$$
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CH$$$$
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RT$$$$
     C                   MOVEL(P)  WKPROG        RT$$$$PROG
     C                   MOVEL(P)  WKDANA        RT$$$$DANA
     C                   MOVEL(P)  WKFFLD        RT$$$$FFLD
     C                   MOVEL(P)  WKFENR        RT$$$$FENR
     C                   MOVEL(P)  W$PA03        RT$$$$PA03
     C                   MOVEL(P)  W$PA04        RT$$$$PA04
     C                   MOVEL(P)  W$PA05        RT$$$$PA05
     C                   MOVEL(P)  W$PA06        RT$$$$PA06
     C                   MOVEL(P)  W$PA07        RT$$$$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN DER ABHÄNGIG. SÄTZE                                       ***
     C**************************************************************************
     C     LPOSI         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      '4     '      PCPGST
     C                   EXSR      TRQQQQ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN DATEI-FELDER                                               ***
     C**************************************************************************
     C     PRAUFR        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EX$$$$ZZZZ    DS$$$$ZZZZ
     C                   Z-ADD     EX$$$$0000    DS$$$$0000
     C*--------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     EX$$$$DATE    EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EX$$$$FLDN    WHENEQ    '$$$$ZZZZ'
     C                   EXSR      PR$$$$ZZZZ
     C     EX$$$$FLDN    WHENEQ    '$$$$0000'
     C                   EXSR      PR$$$$0000
     C     EX$$$$FLDN    WHENEQ    '$$$$DATE'
     C                   EXSR      PR$$$$DATE
     C                   OTHER
     C                   MOVEL     'TR$$$$01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RT$$$$
     C                   MOVEL(P)  WKPROG        RT$$$$PROG
     C                   MOVEL(P)  WKDANA        RT$$$$DANA
     C                   MOVEL(P)  WKFFLD        RT$$$$FFLD
     C                   MOVEL(P)  WKFENR        RT$$$$FENR
     C                   MOVEL(P)  W$PA03        RT$$$$PA03
     C                   MOVEL(P)  W$PA04        RT$$$$PA04
     C                   MOVEL(P)  W$PA05        RT$$$$PA05
     C                   MOVEL(P)  W$PA06        RT$$$$PA06
     C                   MOVEL(P)  W$PA07        RT$$$$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IF$$$$        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EX$$$$IFKZ    IFEQ      '0'
     C                   MOVEL(P)  EX$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  EX$$$$YYYY    KY$$$$YYYY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CH$$$$
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*
     C     EX$$$$ZZZZ    IFNE      *BLANK
     C                   MOVEL     EX$$$$ZZZZ    DS$$$$ZZZZ
     C                   ENDIF
     C*
     C     EX$$$$0000    IFNE      *ZERO
     C                   Z-ADD     EX$$$$0000    DS$$$$0000
     C                   ENDIF
     C*
     C     EX$$$$DATE    IFNE      *ZERO
     C                   CLEAR                   EXDATE
     C                   Z-ADD     EX$$$$DATE    EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TR$$$$01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      U$$$$
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RT$$$$
     C                   MOVEL(P)  WKPROG        RT$$$$PROG
     C                   MOVEL(P)  WKDANA        RT$$$$DANA
     C                   MOVEL(P)  WKFFLD        RT$$$$FFLD
     C                   MOVEL(P)  WKFENR        RT$$$$FENR
     C                   MOVEL(P)  W$PA03        RT$$$$PA03
     C                   MOVEL(P)  W$PA04        RT$$$$PA04
     C                   MOVEL(P)  W$PA05        RT$$$$PA05
     C                   MOVEL(P)  W$PA06        RT$$$$PA06
     C                   MOVEL(P)  W$PA07        RT$$$$PA07
     C*-------------------------------------------------------------------------
     C     K#$$$$LOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CH$$$$                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI $$$$                                                 ***
     C**************************************************************************
     C     U$$$$         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DS$$$$QQQQ    KY$$$$QQQQ
     C                   MOVEL(P)  DS$$$$YYYY    KY$$$$YYYY
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DS$$$$NQQQ    KY$$$$QQQQ
     C                   MOVE(P)   DS$$$$NYYY    KY$$$$YYYY
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CH$$$$
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DS$$$$ZZZZ    $$$$ZZZZ
     C                   Z-ADD     DS$$$$0000    $$$$0000
     C                   MOVEL(P)  DS$$$$JNKZ    $$$$JNKZ
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$DATE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    $$$$DATE
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        $$$$JNAM
     C                   MOVEL(P)  DAPROG        $$$$PROG
     C                   MOVEL(P)  WKCHPL        $$$$BIBL
     C                   MOVEL(P)  DAUSER        $$$$USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        $$$$JZEI
     C                   MOVE      WKTDAT        $$$$JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CH$$$$
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    $$$$TSTP
     C                   MOVEL(P)  DAUSER        $$$$ERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CH$$$$
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CH$$$$
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
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
     C*--------------------------------------------------------
     C     DS$$$$QQQQ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TX$$$$QQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVEA     DS$$$$QQQQ    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$QQQQ
     C                   MOVEL(P)  TPTTXT        TX$$$$QQQQ
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
     C                   MOVEL(P)  'QQQQ'        KYTPTA
     C                   MOVEL(P)  DS$$$$QQQQ    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TX$$$$QQQQ
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
     C*--------------------------------------------------------
     C     DS$$$$YYYY    IFEQ      *BLANK
     C                   MOVE      *BLANK        TX$$$$YYYY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'YYYY'        KOM(02)
     C                   MOVEA     DS$$$$YYYY    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$YYYY
     C                   MOVEL(P)  TPTTXT        TX$$$$YYYY
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
     C                   MOVEL(P)  'YYYY'        KYTPTA
     C                   MOVEL(P)  DS$$$$YYYY    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TX$$$$YYYY
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
     C     DS$$$$ZZZZ    IFEQ      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE 0000                                                   ***
     C**************************************************************************
     C     PR$$$$0000    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$0000'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DS$$$$0000    IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE JNKZ                                                   ***
     C**************************************************************************
     C     MC$$$$JNKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DS$$$$JNKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TX$$$$JNKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DS$$$$JNKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DS$$$$JNKZ
     C                   MOVEL(P)  EXTRPCTEXT    TX$$$$JNKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE JNKZ                                                   ***
     C**************************************************************************
     C     PR$$$$JNKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DS$$$$JNKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DS$$$$JNKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TX$$$$JNKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     MC$$$$DATE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$DATE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DS$$$$DATE    IFEQ      *ZERO
     C                   MOVEL(P)  'POSAKT'      EXDATEPGCD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     PR$$$$DATE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$DATE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DS$$$$DATE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DS$$$$DATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NQQQ                                                   ***
     C**************************************************************************
     C     MC$$$$NQQQ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVEA     DS$$$$NQQQ    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$NQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NQQQ                                                   ***
     C**************************************************************************
     C     PR$$$$NQQQ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$NQQQ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QQQQ'        KYTPTA
     C                   MOVEL(P)  DS$$$$NQQQ    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NYYY                                                   ***
     C**************************************************************************
     C     MC$$$$NYYY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'YYYY'        KOM(02)
     C                   MOVEA     DS$$$$NYYY    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DS$$$$NYYY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NYYY                                                   ***
     C**************************************************************************
     C     PR$$$$NYYY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DS$$$$NYYY'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'YYYY'        KYTPTA
     C                   MOVEL(P)  DS$$$$NYYY    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
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
     C***  UPDATE DATEI QQQQ                                                 ***
     C**************************************************************************
     C     TRQQQQ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXQQQQ
     C                   MOVEL(P)  PCPGST        EXQQQQPGST
     C                   MOVEL(P)  $$$$QQQQ      EXQQQQQQQQ
     C*
     C                   CALL      'TRQQQQ'                             99
     C                   PARM                    EXQQQQ
     C                   PARM                    RTQQQQ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTQQQQPROG    WKPROG
     C                   MOVEL(P)  RTQQQQDANA    WKDANA
     C                   MOVEL(P)  RTQQQQFFLD    WKFFLD
     C                   MOVEL(P)  RTQQQQFENR    WKFENR
     C                   MOVEL(P)  RTQQQQPA03    W$PA03
     C                   MOVEL(P)  RTQQQQPA04    W$PA04
     C                   MOVEL(P)  RTQQQQPA05    W$PA05
     C                   MOVEL(P)  RTQQQQPA06    W$PA06
     C                   MOVEL(P)  RTQQQQPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '$$$$'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      $$$$
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  '$$$$'        EXDATAFILE
     C                   MOVEL(P)  $$$$          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    $$$$
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     E$$$$         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     $$$$JNKZ      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        $$$$JNKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TR$$$$'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODXXX'      KYTATC
     C                   MOVEL(P)  'MODXXX'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODXXX
     C*
     C     MODXXX        IFNE      *ON
     C                   MOVE      *OFF          MODXXX
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'QQQQ'        KYTATC
     C                   MOVEL(P)  'QQQQ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAQQQQ
     C*
     C     WKTRPAQQQQ    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAQQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODYYY'      KYTATC
     C                   MOVEL(P)  'MODYYY'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODYYY
     C                   ELSE
     C                   MOVE      *OFF          MODYYY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFE                                                          ***
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
     C                   MOVEL(P)  WKPGST        EXTRDNPGST
     C                   MOVEL(P)  'TR$$$$'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TR$$$$B1'    EXTRDNPGNA
     C                   MOVE      C#FUKT        EXTRDNFUKT                     F-TASTEN
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
     C     EXTRDNPGST    IFEQ      'DIREKT'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     EXTRDNPGST    IFEQ      'WEITER'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#ACCS        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        #CRTCD
     C                   ENDDO
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODXXX
     C     *LIKE         DEFINE    WKC001        MODYYY
     C     *LIKE         DEFINE    WKC001        WKTRPAQQQQ
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        FL              + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KY$$$$QQQQ    OF$$$$QQQQ
     C     *LIKE         DEFINE    KY$$$$YYYY    OF$$$$YYYY
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RT$$$$PROG    WKPROG
     C     *LIKE         DEFINE    RT$$$$DANA    WKDANA
     C     *LIKE         DEFINE    RT$$$$FFLD    WKFFLD
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
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3
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
     C                   MOVEL(P)  'TR$$$$'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CT$$$$W2
     C                   OTHER
     C                   WRITE     TR$$$$CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CT$$$$W2
     C                   OTHER
     C                   WRITE     TR$$$$CT
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
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CH$$$$
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
