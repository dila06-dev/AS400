     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2000')
     H**************************************************************************
     H/TITLE PTC Menübild 1
     H**************************************************************************
     H*  Copyright 2000 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: HR 17.10.2003
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 28.06.2013 Projekt 8363 Nachschub
     H*  Änderung: ZG 13.02.2014 Projekt 9797 MDE-Menü-Steuerung für Staplerterminals
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet PTC Menübild 1.
     F*
     F*  Input-Felder:
     F*  WKIUSR  = 1
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRBC01FM  CF   E             WORKSTN USROPN
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
     D  C_AUSW                41     41N
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
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
     D EXTRDN        E DS                  INZ
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
     C                   PARM                    WKIUSR
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
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
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRBC01FM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRBC01FM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C**                 RETURN
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
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTPTA                         ÜBERSCHRIFT
     C                   MOVEL(P)  DAFIRM        KYTPTC                         FIRMENNAME
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C                   MOVEL(P)  TPTTXT        TXFIRM
     C                   MOVEL(P)  DAFIRM        DSFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C                   EXSR      B01DS                                        SCHIRMFELDER
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C*
     C                   SELECT
     C     WKIUSR        WHENEQ    '1'
     C                   WRITE     TRBC0101
     C                   WRITE     TRBC01B1
     C     WKIUSR        WHENEQ    '2'
     C                   WRITE     TRBC0102
     C                   WRITE     TRBC01B2
     C                   OTHER
     C                   WRITE     TRBC0101
     C                   WRITE     TRBC01B1
     C                   ENDSL
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIUSR        WHENEQ    '1'
     C                   READ      TRBC0101                             9899    LESEN DES BILDS
     C     WKIUSR        WHENEQ    '2'
     C                   READ      TRBC0102                             9899    LESEN DES BILDS
     C                   OTHER
     C                   READ      TRBC0101                             9899    LESEN DES BILDS
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
     C     C#EXIT        WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C*    C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
     C*                  EXSR      VINFO
     C*                  MOVE      *ON           C#WNDW
     C*                  ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UAUSW
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT                         NÄCHSTES BILD
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
     C                   MOVEL(P)  *BLANK        DSAUSW
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         LÖSCHEN FEHLER
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C_AUSW
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
     C                   EXSR      PRAUSW
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
     C                   MOVE      *ON           C_AUSW
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAUSW'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           C_AUSW
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE  AUSWAHL                                                   ***
     C**************************************************************************
     C     UAUSW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSAUSW        DAFEHL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE AUSW                                                   ***
     C**************************************************************************
     C     PRAUSW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *ON           C_AUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSAUSW        WHENEQ    '1'
     C     DSAUSW        WHENEQ    '2'
     C     DSAUSW        WHENEQ    '3'
     C     DSAUSW        WHENEQ    '4'
     C     WKIUSR        ANDEQ     '1'
     C     DSAUSW        WHENEQ    '4'
     C     WKIUSR        ANDEQ     '2'
     C     DSAUSW        WHENEQ    '9'
     C                   OTHER
     C                   MOVE      '0051'        WKFENR
     C                   ENDSL
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
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    #CRTCD        PCRTCD                         RETURNCODE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIUSR                         IND.USER
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
     C                   MOVEL(P)  'TRBC01'      PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           C#INIT                         SUBFILE
     C*
     C                   SELECT
     C     WKIUSR        WHENEQ    '2'
     C                   WRITE     TRBC02CT
     C                   OTHER
     C                   WRITE     TRBC01CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIUSR        WHENEQ    '2'
     C                   WRITE     TRBC02CT
     C                   OTHER
     C                   WRITE     TRBC01CT
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
     C/COPY TAMP/QCPYSRC,CHTRTP
     C/COPY TAMP/QCPYSRC,TRIFMT
     C/COPY TAMP/QCPYSRC,VINFO
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
