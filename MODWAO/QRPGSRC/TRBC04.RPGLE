     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2000')
     H**************************************************************************
     H/TITLE manuelle Lagerbuchungen mit PTC-System
     H**************************************************************************
     H*  Copyright 2000 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 27.10.2000
     H*  -----------------------------------------------------------------------
     H*  Änderung: HR 20.04.2001 Korr. PRLORT
     H*  Änderung: ZG 25.04.2001 Für FAWU Bestandlager = Lagernummer
     H*            Keien Anzeige des Bestandslager
     H*  Änderung: HR 19.11.2001 Formatkorrektur Fa. Fawu
     H*            Vorbelegung Mengeneinheit bei Gebindebuchung SR-B02DS
     H*  Änderung: HR 29.11.2001 Formaterweiterung Fa. FAWO Projekt 974
     H*  Änderung: HR 24.05.2011 Fa. Waeco Buchung mit Umbuchung der Reservierung
     H*  Änderung: HR 27.05.2011 Fa. Waeco Umbuchung der Reservierung wird wieder
     H*            unterdrückt für Buchungen mit Abgangslager 001
     H*  Änderung: RE 17.01.2012 DOMETIC  Mail vom RS am 17.01.2012
     H*            Lagertrennung: analog zum Lager 001 dürfen auch von Lager 060
     H*            und Lager 070 keine Reservierungen umgebucht werden.
     F**************************************************************************
     F*
     F*  Dieses Programm erfasst die Daten für die manuelle Buchung über PTC.
     F*  Die Buchungen werden über das PGM TRLBLB durchgeführt.
     F*
     F*  Input-Felder:
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRBC04FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,TRCURSOR
     D*
     D  C_LSTC                41     41N
     D  C_TENR                42     42N
     D  C_BSLA                43     43N
     D  C_LANR                44     44N
     D  C_LORT                45     45N
     D*
     D  C_CHAR                46     46N
     D  C_GEBI                47     47N
     D  C_FUMG                48     48N
     D  C_MEIN                49     49N
     D  C_BWMG                50     50N
     D  C_BWME                51     51N
     D*
     D  C_UBSL                52     52N
     D  C_ULNR                53     53N
     D  C_UORT                54     54N
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D CHST          E DS                  INZ
     D KYCHST        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D LBSS          E DS                  INZ
     D KYLBSS        E DS                  INZ
     D*
     D GEBI          E DS                  INZ
     D KYGEBI        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     PCPGST        ANDNE     'ENDE  '
     C     PCPGST        ANDNE     'PRUEFE'
     C                   MOVE      '5     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON                                          FORMAT NEU
     C                   MOVE      *ON           C#WNDW                         AUFBAUEN
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '                                     BILDSCHIRMFORMAT
     C*                                                                         SCHLIESSEN
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRBC04FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRBC04FM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C     PCPGST        OREQ      'MUSTER'
     C                   CLOSE     TRBC04FM                             98
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
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN                         DATUMFELDER
     C                   Z-ADD     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  DAUSER        WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYLSFI
     C                   MOVE      DAFIRM        KYLDFI                         LBSD
     C                   MOVE      DAFIRM        KYCHSTFIRM                     CHST
     C                   MOVE      DAFIRM        KYLLFI                         LBPL
     C                   MOVEL     DAFIRM        KYGEBIFIRM                     GEBI
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'BC04'        EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99(32)       WNKOPF
     C                   MOVEA(P)  W99(32)       W1KOPF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVE      #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  KOM(01)       DSLSTC
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
     C                   MOVE      'F'           WKFEAT                         MSG-FELDER
     C                   MOVE      *BLANK        MCF                            MC-PROGRAMME
     C                   MOVEL     *OFF          WKBT03
     C                   MOVEL     *OFF          WKBT12
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD01                                              ***
     C**************************************************************************
     C     BILD01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C     WKBT12        IFEQ      *OFF                                         FÜLLEN BILD-
     C     WKBT03        ANDEQ     *OFF                                         FÜLLEN BILD-
     C                   EXSR      B01DS                                        SCHIRMFELDER
     C                   ENDIF
     C                   MOVEL     *OFF          WKBT03
     C                   MOVEL     *OFF          WKBT12
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C                   WRITE     TRBC04F2
     C     MODMIE        WHENEQ    *ON
     C                   WRITE     TRBC04M2
     C     PCPGST        WHENEQ    'SCANT1'
     C                   WRITE     TRBC04T2
     C     PCPGST        WHENEQ    'SCANH1'
     C                   WRITE     TRBC04H2
     C     PCPGST        WHENEQ    'SCANF1'
     C                   WRITE     TRBC04F1
     C     WKTRPABSLA    WHENEQ    *ON
     C                   WRITE     TRBC0402
     C                   OTHER
     C                   WRITE     TRBC0401
     C                   ENDSL
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C                   READ      TRBC04F2                             9899    LESEN DES BILDS
     C     MODMIE        WHENEQ    *ON
     C                   READ      TRBC04M2                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANT1'
     C                   READ      TRBC04T2                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANH1'
     C                   READ      TRBC04H2                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANF1'
     C                   READ      TRBC04F1                             9899    LESEN DES BILDS
     C     WKTRPABSLA    WHENEQ    *ON
     C                   READ      TRBC0402                             9899    LESEN DES BILDS
     C                   OTHER
     C                   READ      TRBC0401                             9899    LESEN DES BILDS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#SELC        WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
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
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '02'          WKIFMT                         NÄCHSTES BILD
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
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSTENR
     C                   MOVE      *BLANK        D1TENR
     C                   MOVE      *BLANK        D2TENR
     C                   MOVE      *BLANK        DSBSLA
     C                   MOVE      *BLANK        DSLANR
     C                   MOVE      *BLANK        DSLORT
     C*
     C                   MOVE      *BLANK        DSCHAR
     C                   MOVE      *BLANK        DSGEBI
     C                   MOVE      *ZERO         DSFUMG
     C                   MOVE      *BLANK        DSMEIN
     C                   MOVE      *ZERO         DSBWMG
     C                   MOVE      *BLANK        DSBWME
     C*
     C                   MOVE      *BLANK        DSULNR
     C                   MOVE      *BLANK        DSUORT
     C*
     C                   MOVE      *BLANK        D1CHAR
     C                   MOVE      *BLANK        D1GEBI
     C                   MOVE      *ZERO         D1FUMG
     C                   MOVE      *ZERO         D1BWMG
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKLBBSBSTY
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C     PCRTCD        IFEQ      'W'                                          DATENSTZ HINZU
     C                   SELECT
     C     LSLBSC        WHENEQ    '+'                                          BUCHUNG PLUS
     C                   MOVE      '9120'        WKFENR                         GEFÜGT
     C     LSLBSC        WHENEQ    '-'                                          BUCHUNG PLUS
     C                   MOVE      '9131'        WKFENR                         GEFÜGT
     C     LSLAUC        WHENEQ    DAJNKZ                                       LAGERUMBUCHUNG
     C                   MOVE      '9132'        WKFENR                         GEFÜGT
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK0                         ANZEIGE
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK1                         ÄNDERUNG
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '                                     SATZ IST
     C                   MOVE      '0001'        WKFENR                         GESPERRT
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C     DSLSTC        IFNE      *BLANK
     C     MODMIE        ANDEQ     *ON
     C                   MOVE      *ON           C_LANR
     C                   ELSE
     C                   MOVE      *ON           C_LSTC
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLSTC
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     MODFWW        IFNE      *ON
     C     MODMIE        ANDNE     *ON
     C     PCPGST        ANDNE     'SCANT1'
     C     PCPGST        ANDNE     'SCANH1'
     C                   EXSR      PRTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPABSLA    IFEQ      *ON
     C*
     C     MODFWW        IFEQ      *ON
     C                   MOVEL     DSLANR        DSBSLA
     C                   ENDIF
     C                   EXSR      PRBSLA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLANR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     MODFWW        IFNE      *ON
     C     MODMIE        ANDNE     *ON
     C     PCPGST        ANDNE     'SCANT1'
     C     PCPGST        ANDNE     'SCANH1'
     C*
     C                   EXSR      ERBSTY
     C*
     C     WKLBBSBSTY    IFNE      'LB01'
     C     WKLBBSBSTY    ANDNE     'LB02'
     C     WKLBBSBSTY    ANDNE     'LB03'
     C     WKLBBSBSTY    ANDNE     'LB04'
     C     WKLBBSBSTY    ANDNE     'GB01'
     C     WKLBBSBSTY    ANDNE     'GB02'
     C     WKLBBSBSTY    ANDNE     'GB03'
     C     WKLBBSBSTY    ANDNE     'GB04'
     C                   MOVEL     'BSTY'        W$PA03
     C                   MOVE      '9118'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLORT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD02                                              ***
     C**************************************************************************
     C     BILD02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C                   EXSR      B02DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '02'
     C*
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C                   WRITE     TRBC04F3
     C     MODMIE        WHENEQ    *ON
     C                   WRITE     TRBC04M4
     C     PCPGST        WHENEQ    'SCANT1'
     C                   WRITE     TRBC04T4
     C     PCPGST        WHENEQ    'SCANH1'
     C                   WRITE     TRBC04H4
     C     PCPGST        WHENEQ    'SCANF1'
     C                   WRITE     TRBC04F5
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C                   WRITE     TRBC0405
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C                   WRITE     TRBC0405
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C                   WRITE     TRBC0404
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C                   WRITE     TRBC0404
     C                   OTHER
     C                   WRITE     TRBC0403
     C                   ENDSL
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C                   READ      TRBC04F3                             9899    LESEN DES BILDS
     C     MODMIE        WHENEQ    *ON
     C                   READ      TRBC04M4                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANT1'
     C                   READ      TRBC04T4                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANH1'
     C                   READ      TRBC04H4                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANF1'
     C                   READ      TRBC04F5                             9899    LESEN DES BILDS
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C                   READ      TRBC0405                             9899    LESEN DES BILDS
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C                   READ      TRBC0405                             9899    LESEN DES BILDS
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C                   READ      TRBC0404                             9899    LESEN DES BILDS
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C                   READ      TRBC0404                             9899    LESEN DES BILDS
     C                   OTHER
     C                   READ      TRBC0403                             9899    LESEN DES BILDS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#SELC        WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVEL     *ON           WKBT03
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVEL     *ON           WKBT12
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
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
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     LSLAUC        WHENEQ    DAJNKZ                                       LAGERUMBUCHUNG
     C                   MOVE      '03'          WKIFMT
     C                   OTHER
     C*
     C                   EXSR      TRLBLB
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   EXSR      RFMTS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 02                                        ***
     C**************************************************************************
     C     B02DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     WKLBBSBSTY    OREQ      'LB02'
     C     WKLBBSBSTY    OREQ      'LB03'
     C     WKLBBSBSTY    OREQ      'LB04'
     C                   MOVE      TEMEIN        DSBWME
     C     WKLBBSBSTY    WHENEQ    'GB01'
     C     WKLBBSBSTY    OREQ      'GB02'
     C     WKLBBSBSTY    OREQ      'GB03'
     C     WKLBBSBSTY    OREQ      'GB04'
     C     MODFWW        IFEQ      *ON
     C                   MOVE      'F'           DSBWME
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK0                         ANZEIGE
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK1                         ÄNDERUNG
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '                                     SATZ IST
     C                   MOVE      '0001'        WKFENR                         GESPERRT
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C*
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C     MODMIE        OREQ      *ON
     C     PCPGST        OREQ      'SCANT1'
     C     PCPGST        OREQ      'SCANH1'
     C                   MOVE      *ON           C_TENR
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     WKLBBSBSTY    OREQ      'LB04'
     C     WKLBBSBSTY    OREQ      'GB03'
     C     WKLBBSBSTY    OREQ      'GB04'
     C                   MOVE      *ON           C_CHAR
     C                   OTHER
     C                   MOVE      *ON           C_BWMG
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD02                                          ***
     C**************************************************************************
     C     B02PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C                   MOVEL     D1TENR        DSTENR
     C                   MOVEL     D1CHAR        DSCHAR
     C                   MOVEL     D1GEBI        DSGEBI
     C                   Z-ADD     D1FUMG        DSFUMG
     C                   Z-ADD     D1BWMG        DSBWMG
     C     PCPGST        WHENEQ    'SCANT1'
     C     PCPGST        OREQ      'SCANH1'
     C                   MOVEL     D2TENR        DSTENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     MODFWW        IFEQ      *ON
     C     MODMIE        OREQ      *ON
     C     PCPGST        OREQ      'SCANT1'
     C     PCPGST        OREQ      'SCANH1'
     C                   EXSR      PRTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      ERBSTY
     C*
     C     WKLBBSBSTY    IFNE      'LB01'
     C     WKLBBSBSTY    ANDNE     'LB02'
     C     WKLBBSBSTY    ANDNE     'LB03'
     C     WKLBBSBSTY    ANDNE     'LB04'
     C     WKLBBSBSTY    ANDNE     'GB01'
     C     WKLBBSBSTY    ANDNE     'GB02'
     C     WKLBBSBSTY    ANDNE     'GB03'
     C     WKLBBSBSTY    ANDNE     'GB04'
     C                   MOVEL     'BSTY'        W$PA03
     C                   MOVE      '9118'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRCHAR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRGEBI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRFUMG
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRMEIN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBWMG
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBWME
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD03                                              ***
     C**************************************************************************
     C     BILD03        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)                                      FORMAT MERKEN
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------FÜLLEN BILD
     C                   EXSR      B03DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '03'
     C*
     C                   SELECT
     C     MODMIE        WHENEQ    *ON
     C                   WRITE     TRBC04M6
     C     WKTRPABSLA    WHENEQ    *ON
     C     MODFWW        ANDEQ     *ON
     C                   WRITE     TRBC04F6
     C     PCPGST        WHENEQ    'SCANT1'
     C                   WRITE     TRBC04T6
     C     PCPGST        WHENEQ    'SCANF1'
     C                   WRITE     TRBC04X6
     C     WKTRPABSLA    WHENEQ    *ON
     C                   WRITE     TRBC0407
     C                   OTHER
     C                   WRITE     TRBC0406
     C                   ENDSL
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODMIE        WHENEQ    *ON
     C                   READ      TRBC04M6                             9899    LESEN DES BILDS
     C     WKTRPABSLA    WHENEQ    *ON
     C     MODFWW        ANDEQ     *ON
     C                   READ      TRBC04F6                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANT1'
     C                   READ      TRBC04T6                             9899    LESEN DES BILDS
     C     PCPGST        WHENEQ    'SCANF1'
     C                   READ      TRBC04X6                             9899    LESEN DES BILDS
     C     WKTRPABSLA    WHENEQ    *ON
     C                   READ      TRBC0407                             9899    LESEN DES BILDS
     C                   OTHER
     C                   READ      TRBC0406                             9899    LESEN DES BILDS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON                                          FEHLER
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
     C     C#SELC        WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
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
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B03PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      TRLBLB
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      RFMTS
     C                   EXSR      RFMTS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 03                                        ***
     C**************************************************************************
     C     B03DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0                         EINGABE SPERRE
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRLBLB'      KYTPTA                         ÜBERSCHRIFT
     C                   MOVEL     'UMBNAC'      KYTPTC                         FIRMENNAME
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        WNKOPF1
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK0                         ANZEIGE
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '                                     SPERREN BEI
     C                   MOVE      *ON           C#LCK1                         ÄNDERUNG
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '                                     SATZ IST
     C                   MOVE      '0001'        WKFENR                         GESPERRT
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C     WKTRPABSLA    IFEQ      *ON
     C                   MOVE      *ON           C_UBSL
     C                   ELSE
     C                   MOVE      *ON           C_ULNR
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD03                                          ***
     C**************************************************************************
     C     B03PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     WKTRPABSLA    IFEQ      *ON
     C*
     C     MODFWW        IFEQ      *ON
     C                   MOVEL     DSULNR        DSUBSL
     C                   ENDIF
     C                   EXSR      PRUBSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRULNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRUORT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_LSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLSTC'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_LSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTENR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_TENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBSLA'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_BSLA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_LANR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLORT'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_LORT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSCHAR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_CHAR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSGEBI'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_GEBI
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSFUMG'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_FUMG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSMEIN'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_MEIN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBWMG'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_BWMG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBWME'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_BWME
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSUBSL'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_UBSL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSULNR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_ULNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSUORT'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_UORT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN LAGERSTEUERUNGSSCHLÜSSEL                                ***
     C***                                                                    ***
     C**************************************************************************
     C     PRLSTC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_LSTC
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLSTC        KYLSTC
     C                   MOVEL     *BLANK        KYLSLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSS
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9130'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN IDENTNUMMER                                             ***
     C***                                                                    ***
     C**************************************************************************
     C     PRTENR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_TENR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     MODWAO        IFEQ      *ON
     C     DSTENR        ANDNE     *BLANK
     C                   MOVEL     DSTENR        KYTEEA
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '91C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSTENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSTENR        KYTENR                         PRÜFEN TEILE-
     C                   MOVEL     *BLANK        KYTEEZ                         NUMMER OB
     C                   MOVEA     '01C     '    CHI                            VORHANDEN
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSTENR
     C                   ENDIF
     C*
     C     WKFENR        IFNE      *ZERO
     C     TETART        OREQ      'P'                                          PSEUDO-IDENT
     C     TEBSKZ        ORNE      DAJNKZ                                       BESTANDSFÜHRUNG
     C                   MOVE      '9101'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN BESTANDSLAGER                                           ***
     C***                                                                    ***
     C**************************************************************************
     C     PRBSLA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_BSLA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSBSLA        KYLDLA                         LAFER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C*-------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9124'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------
     C     LDBSKZ        IFNE      DAJNKZ                                       FEHLER
     C                   MOVE      '9128'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN LAGERNUMMER                                             ***
     C***                                                                    ***
     C**************************************************************************
     C     PRLANR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_LANR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLANR        KYLDLA                         LAFER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C*-------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9105'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------
     C     WKTRPABSLA    IFEQ      *ON
     C     LDLAKZ        IFNE      DAJNKZ
     C     LDLAKZ        ANDNE     *BLANK
     C                   MOVE      '9129'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN LAGERORT                                                ***
     C***                                                                    ***
     C**************************************************************************
     C     PRLORT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_LORT
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODFWW        WHENEQ    *ON
     C     DSLORT        ANDEQ     *BLANK
     C     MODMIE        OREQ      *ON
     C     DSLORT        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSLORT        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSLORT        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSLORT        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSLORT        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB01'
     C     DSLORT        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB01'
     C     DSLORT        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB03'
     C     DSLORT        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB03'
     C     DSLORT        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLANR        KYLLLA                         PRÜFEN LAGER-
     C*                                                                         LAGERPLATZ
     C     WKTRPABSLA    IFEQ      *ON                                          MIT BESTANDSLAGER
     C                   MOVEL     DSBSLA        KYLLLA                         FALLS PARAMETER
     C                   ENDIF                                                  AKTIV
     C*
     C                   MOVEL     DSTENR        KYLLTE
     C                   MOVEL     DSLORT        KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9107'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN CHARGE                                                  ***
     C***                                                                    ***
     C**************************************************************************
     C     PRCHAR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_CHAR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSCHAR        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSCHAR        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSCHAR        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSCHAR        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSCHAR        ANDEQ     *BLANK
     C                   MOVE      '9102'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSCHAR        ANDEQ     *BLANK
     C                   MOVE      '9102'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB01'
     C     DSCHAR        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB01'
     C     DSCHAR        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB02'
     C     DSCHAR        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB02'
     C     DSCHAR        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB03'
     C     DSCHAR        ANDEQ     *BLANK
     C                   MOVE      '9102'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'GB04'
     C     DSCHAR        ANDEQ     *BLANK
     C                   MOVE      '9102'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSCHAR        KYCHSTCHAR
     C                   MOVEL     DSTENR        KYCHSTTENR
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHCHST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9102'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN GEBINDE                                                 ***
     C***                                                                    ***
     C**************************************************************************
     C     PRGEBI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_GEBI
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSGEBI        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSGEBI        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSGEBI        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSGEBI        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSGEBI        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSGEBI        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSGEBI        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSGEBI        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSGEBI        KYTENR
     C                   MOVEL     *BLANK        KYTEEZ                         GEBINDE
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9101'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C     TEGBKZ        IFNE      DAJNKZ
     C                   MOVE      '1251'        WKFENR
     C                   ENDIF
     C*
     C     DSBWME        IFEQ      *BLANK
     C                   MOVEL     TEMEIN        DSBWME
     C                   ENDIF
     C*-------------------------------------------------
     C                   MOVEL     'GB2'         KYGEBIBEGR
     C                   MOVEL     DSTENR        KYGEBITENR
     C                   MOVEL     DSGEBI        KYGEBIGEBI                     PRÜFEN
     C                   MOVEA     '01C     '    CHI                            GEBINDESTEUERUNG
     C                   EXSR      CHGEBI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9101'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C     DSMEIN        IFEQ      *BLANK
     C                   MOVEL     GEBIMEIN      DSMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FUMG                                                   ***
     C**************************************************************************
     C     PRFUMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_FUMG
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSFUMG        ANDEQ     *ZERO
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSFUMG        ANDNE     *ZERO
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSFUMG        ANDEQ     *ZERO
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSFUMG        ANDNE     *ZERO
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSFUMG        ANDEQ     *ZERO
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSFUMG        ANDNE     *ZERO
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSFUMG        ANDEQ     *ZERO
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSFUMG        ANDNE     *ZERO
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     DSFUMG        IFLE      *ZERO
     C                   MOVE      '9109'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN MENGENEINHEIT                                           ***
     C***                                                                    ***
     C**************************************************************************
     C     PRMEIN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_BWME
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSMEIN        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB01'
     C     DSMEIN        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSMEIN        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB02'
     C     DSMEIN        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSMEIN        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB03'
     C     DSMEIN        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSMEIN        ANDEQ     *BLANK
     C                   LEAVE
     C     WKLBBSBSTY    WHENEQ    'LB04'
     C     DSMEIN        ANDNE     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL     'MEIN'        KYTPTA                         PRÜFEN
     C                   MOVEL     DSMEIN        KYTPTC                         MENGENEINHEIT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9115'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BWMG                                                   ***
     C**************************************************************************
     C     PRBWMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_BWMG
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSBWMG        IFLE      *ZERO
     C                   MOVE      '9109'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN MENGENEINHEIT                                           ***
     C***                                                                    ***
     C**************************************************************************
     C     PRBWME        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_BWME
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSBWME        IFEQ      *BLANK
     C                   MOVE      TEMEIN        DSBWME
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSTENR        KYTUTE                         PRÜFEN
     C                   IF        %SUBST(WKLBBSBSTY:1 :2)='GB'
     C                   MOVEL     DSGEBI        KYTUTE                         PRÜFEN
     C                   ENDIF
     C                   MOVEL     DSBWME        KYTUME                         UMRECHNUNGS-
     C                   MOVEA     '01C     '    CHI                            FAKTOR
     C                   EXSR      CHTEUF
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9115'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN BESTANDSLAGER NACH                                      ***
     C***                                                                    ***
     C**************************************************************************
     C     PRUBSL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_UBSL
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSUBSL        KYLDLA                         LAFER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C*-------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9124'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------
     C     LDBSKZ        IFNE      DAJNKZ                                       FEHLER
     C                   MOVE      '9128'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN LAGERNUMMER NACH                                        ***
     C***                                                                    ***
     C**************************************************************************
     C     PRULNR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_ULNR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSULNR        KYLDLA                         LAFER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C*-------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9105'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------
     C     WKTRPABSLA    IFEQ      *ON
     C     LDLAKZ        IFNE      DAJNKZ
     C     LDLAKZ        ANDNE     *BLANK
     C                   MOVE      '9129'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-PRÜFEN LAGERORT NACH                                           ***
     C***                                                                    ***
     C**************************************************************************
     C     PRUORT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_UORT
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSUORT        IFNE      *BLANK
     C                   MOVEL     DSULNR        KYLLLA                         PRÜFEN LAGER-
     C*                                                                         LAGERPLATZ
     C     WKTRPABSLA    IFEQ      *ON                                          MIT BESTANDSLAGER
     C                   MOVEL     DSUBSL        KYLLLA                         FALLS PARAMETER
     C                   ENDIF                                                  AKTIV
     C*
     C                   MOVEL     DSTENR        KYLLTE
     C                   MOVEL     DSUORT        KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9107'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-ERBSTY ERMITTELN BESTANDSTYP                                   ***
     C***                                                                    ***
     C**************************************************************************
     C     ERBSTY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL     'EBSTY '      EXLBPGST
     C                   MOVEL     DSLANR        EXLBLANR
     C     WKTRPABSLA    IFEQ      *ON
     C                   MOVEL     DSBSLA        EXLBBSLA
     C                   ENDIF
     C                   MOVEL     DSTENR        EXLBTENR
     C*
     C                   CALL      'TRLBBS  '
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*--------------------------------------------------------
     C                   MOVEL     RTLBBSTY      WKLBBSBSTY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C***  SR-TRLBLB     VERBUCHEN DER LAGERBEWEGUNG                         ***
     C***                                                                    ***
     C**************************************************************************
     C     TRLBLB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      'ULBLB '      #CPGST
     C*--------------------------------------------------------
     C                   CLEAR                   RTLBLB
     C                   CLEAR                   EXLBLB
     C*
     C                   MOVEL     DSBSLA        EXLBBSLA
     C                   MOVEL     DSLANR        EXLBLANR
     C                   MOVEL     DSTENR        EXLBTENR
     C                   MOVEL     DSLORT        EXLBLORT
     C                   MOVEL     DSCHAR        EXLBCHAR
     C*
     C                   MOVEL     DSLSTC        EXLBLSTC
     C*
     C                   MOVEL     DSGEBI        EXLBGEBI
     C                   Z-ADD     DSFUMG        EXLBFUMG
     C                   MOVEL     DSMEIN        EXLBMEIN                       GEBINDEMENGENEINHEIT
     C*
     C                   Z-ADD     DSBWMG        EXLBBWMG
     C                   MOVEL     DSBWME        EXLBBWME
     C*
     C                   MOVE      DSUBSL        EXLBUBSL
     C                   MOVE      DSULNR        EXLBULNR
     C                   MOVE      DSUORT        EXLBUORT
     C*
     C                   MOVE      WKNEIN        EXLBRSKZ
     C     EXLBLSTC      IFEQ      '300'                                       UMBUCHUNG
     C     EXLBLANR      ANDNE     '001'                                       ABGANGSLAGER
     C     EXLBLANR      ANDNE     '060'
     C     EXLBLANR      ANDNE     '070'
     C                   MOVEL(P)  DAJNKZ        EXLBRSKZ                      BUCHUNG MIT
     C                   MOVEL(P)  DANEKZ        EXLBLBRS                      RESERVIERUNG
     C                   ENDIF
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        EXLBBDAT
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      'W'           #CRTCD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      '1238'
     C     RTLBFFLD      ANDEQ     'EXLBSTMG  '
     C                   EXSR      TRLBB2
     C                   Z-ADD     DUN134        DUN092
     C                   EVAL      W$PA03 = %TRIM(%EDITW(DUN092 : '       ,  '))
     C                   MOVE      '9135'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LAGERBESTAND                                            ***
     C**************************************************************************
     C     TRLBB2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *OFF          KOM(3)                         REVERV.BESTAND
     C                   MOVE      *OFF          KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     DSTENR        KOM(10)
     C                   MOVEA     DSLANR        KOM(25)                        LAGER
     C                   MOVEA     DSGEBI        KOM(28)
     C                   MOVEA     DSCHAR        KOM(43)
     C                   MOVEA     DSLORT        KOM(63)
     C                   Z-ADD     DSFUMG        DUN114
     C                   MOVEA     DUC011        KOM(86)
     C                   MOVEA     DSMEIN        KOM(98)
     C                   MOVEA     DSBSLA        KOM(102)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C*-------------------------------------------------------------------------
     C                   ENDDO
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
     C* BESTANDSLAGERVERWALTUNG
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYTAFI                         ERMITTELN
     C                   MOVEL     'TREND'       KYTATA                         OB BESTANDSLAGER
     C                   MOVEL     'BSLA  '      KYTATC                         AKTIV IST.
     C                   MOVEL     'BSLA  '      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPABSLA        1
     C     WKTRPABSLA    IFNE      *ON
     C                   MOVE      *OFF          WKTRPABSLA
     C                   END
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'NEIN'        KYTATC                         NEIN
     C                   MOVEL     'NEIN'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKNEIN
     C*-------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL     'MODFWW'      KYTATC                         FIRMA FAWU
     C                   MOVEL     'MODFWW'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODFWW
     C     MODFWW        IFNE      *ON
     C                   MOVEL     *OFF          MODFWW
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL     'MODWAO'      KYTATC                         FIRMA FAWU
     C                   MOVEL     'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODWAO
     C     MODWAO        IFNE      *ON
     C                   MOVEL     *OFF          MODWAO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL     'MODMIE'      KYTATC                         FIRMA VOGT
     C                   MOVEL     'MODMIE'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVEL     *ON           MODMIE
     C                   ELSE
     C                   MOVEL     *OFF          MODMIE
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKIOKZ                         OPEN KZ. FORMAT
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKCFMT                         IND.CLOSE FORMAT
     C     *LIKE         DEFINE    WKC001        MODFWW                         MOD. FWW
     C     *LIKE         DEFINE    WKC001        MODMIE                         MOD. VOGT
     C     *LIKE         DEFINE    WKC001        MODWAO                         MOD. VOGT
     C     *LIKE         DEFINE    WKC001        WKBT03
     C     *LIKE         DEFINE    WKC001        WKBT12
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN31                         RETTEN INDICAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    #CRTCD        PCRTCD                         RETURNCODE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTLBBSTY      WKLBBSBSTY
     C     *LIKE         DEFINE    EXLBRSKZ      WKNEIN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT                         MSG-ART (F,I)
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9            ÜBERGABEPARAMET
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
     C                   MOVEL(P)  'TRBC04'      PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           C#INIT                         SUBFILE
     C*
     C                   SELECT
     C     MODMIE        WHENEQ    *ON
     C     PCPGST        OREQ      'SCANT1'
     C                   WRITE     TRBC0MCT
     C     PCPGST        WHENEQ    'SCANF1'
     C                   WRITE     TRBC0XCT
     C                   OTHER
     C                   WRITE     TRBC04CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODMIE        WHENEQ    *ON
     C     PCPGST        OREQ      'SCANT1'
     C                   WRITE     TRBC0MCT
     C     PCPGST        WHENEQ    'SCANF1'
     C                   WRITE     TRBC0XCT
     C                   OTHER
     C                   WRITE     TRBC04CT
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
     C/COPY TAMP/QCPYSRC,CHCHST
     C/COPY TAMP/QCPYSRC,CHGEBI
     C/COPY TAMP/QCPYSRC,CHTRPA
     C/COPY TAMP/QCPYSRC,CHTRTP
     C/COPY TAMP/QCPYSRC,CHLBSS
     C/COPY TAMP/QCPYSRC,CHLBSD
     C/COPY TAMP/QCPYSRC,CHLBPL
     C/COPY TAMP/QCPYSRC,CHTEIL
     C/COPY TAMP/QCPYSRC,CHTEUF
     C/COPY TAMP/QCPYSRC,PRFIRMFIRM
     C/COPY TAMP/QCPYSRC,RDTRDNTRDN
     C/COPY TAMP/QCPYSRC,TRDAUM
     C/COPY TAMP/QCPYSRC,TRIFMT
     C/COPY TAMP/QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
