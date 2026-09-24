     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Auswahl Übernahme Speditionsdaten
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellung: SZ 17.11.2010
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Mit diesem Programm wird die Selektion zur Übergabe der Speditions-
     F*  daten abgewickelt.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRSP15FM  CF   E             WORKSTN USROPN
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
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRUE          E DS                  INZ
     D KYTRUE        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D*
     D EXFLPO        E DS                  INZ
     D*
     D EXSP16        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON                                          FORMAT NEU
     C                   MOVE      *ON           C#WNDW                         AUFBAUEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '                                     BILDSCHIRMFORMAT
     C*                                                                         SCHLIESSEN
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRSP15FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  F O R M A T S T E U E R U N G                                     ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRSP15FM                             98
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
     C                   CLOSE     TRSP15FM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        DSFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     A*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAUSSP        KYUESP                         ÜBERSCHRIFT
     C                   MOVEL(P)  'UEB'         KYUEMA                         PROGRAMMNAME
     C                   MOVEL(P)  'SP15'        KYUEMN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRUE
     C*
     C                   MOVEA     UEMSGT        W99(32)
     C                   MOVEA     W99           DSKOPF
     C*-------------------------------------------------------------------------
     C                   MOVE      'F'           WKFEAT                         MSG-FELDER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRSP15FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRSP15'      KYTATC                         VORBELEGUNG
     C                   MOVEL(P)  'WKNR'        KYTAPA                         WERKNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        DSWKNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRSP15'      KYTATC                         J/N-KENNZEICHEN
     C                   MOVEL(P)  'BOKZ'        KYTAPA                         FÜR BORDERO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        DSBOKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKIOKZ                         OPEN KZ. FORMAT
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5            INT.PROGR.STAT.
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5            INT.PROGR.STAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN31                         RETTEN INDICAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC060          +59            WORKFELD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DSGADA        WKGADA                         GÜTLIG AB DATUM
     C     *LIKE         DEFINE    DSSPE1        WKSPED                         SPEDITEUR
     C     *LIKE         DEFINE    DSFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAFIRM        DSFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AKAFJJ        WKAFJJ
     C     *LIKE         DEFINE    AKAFNR        WKAFNR
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
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   EXSR      EFLPO
     C                   WRITE     TRSP1501
     C                   WRITE     TRSP15B1
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA                         LÖSCHEN CURSOR
     C                   MOVE      *OFF          C#WNDW                         WINDOW NEU
     C*-------------------------------------------------------------------------
     C                   READ      TRSP1501                             9899    LESEN DES BILDS
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
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *ON           DAFEHL
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      B01F04
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON                                          F12=ABBRECHEN
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   EXSR      RFMTS
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON                                          INFO-SYSTEM
     C                   EXSR      VINFO
     C                   ITER
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
     C                   EXSR      USP16
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *OFF          DAFEHL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUELLEN BILDSCHIRMFELDER BILD01                                   ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C                   MOVE      WKIN30        C#LCK0                         SPERREN
     C                   MOVE      WKIN31        C#LCK1                         EINGABEFELDER
     C*-------------------------------------------------------------------------
     C                   WRITE     TRSP15LO                                     LÖSCHEN NACH-
     C                   MOVE      *ZERO         WKFENR                         RICHTENZEILE
     C*-------------------------------------------------------------------------
     C     DSGADA        IFEQ      *ZERO
     C                   MOVE      *DATE         DSGADA                         INITIALISIEREN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBOKZ        IFEQ      *BLANK
     C                   MOVEL(P)  DAJNKZ        DSBOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXWKNR
     C                   MOVE      *BLANK        TXBOKZ
     C*-------------------------------------------------------------------------
     C     DSWKNR        IFNE      *BLANK                                       WERKSBEZEICHNUNG
     C                   MOVEL(P)  DSWKNR        KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBOKZ        IFNE      *BLANK
     C                   MOVEL(P)  'JNKZ'        KYTPTA                         BORDERO
     C                   MOVEL(P)  DSBOKZ        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *YEAR         DSAJ10
     C                   MOVE      *YEAR         DSAJ11
     C                   MOVE      *YEAR         DSAJ12
     C                   MOVE      *YEAR         DSAJ13
     C                   MOVE      *YEAR         DSAJ14
     C                   MOVE      *YEAR         DSAJ15
     C                   MOVE      *YEAR         DSAJ16
     C                   MOVE      *YEAR         DSAJ17
     C                   MOVE      *YEAR         DSAJ18
     C                   MOVE      *YEAR         DSAJ19
     C*
     C                   MOVE      *YEAR         DSAJ20
     C                   MOVE      *YEAR         DSAJ21
     C                   MOVE      *YEAR         DSAJ22
     C                   MOVE      *YEAR         DSAJ23
     C                   MOVE      *YEAR         DSAJ24
     C                   MOVE      *YEAR         DSAJ25
     C                   MOVE      *YEAR         DSAJ26
     C                   MOVE      *YEAR         DSAJ27
     C                   MOVE      *YEAR         DSAJ28
     C                   MOVE      *YEAR         DSAJ29
     C*
     C                   MOVE      *YEAR         DSAJ30
     C                   MOVE      *YEAR         DSAJ31
     C                   MOVE      *YEAR         DSAJ32
     C                   MOVE      *YEAR         DSAJ33
     C                   MOVE      *YEAR         DSAJ34
     C                   MOVE      *YEAR         DSAJ35
     C                   MOVE      *YEAR         DSAJ36
     C                   MOVE      *YEAR         DSAJ37
     C                   MOVE      *YEAR         DSAJ38
     C                   MOVE      *YEAR         DSAJ39
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWKNR'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILD01                                           ***
     C**************************************************************************
     C     B01F04        BEGSR
     C*
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     WKTRTP        DOWEQ     *OFF
     C     FLDNAM        ANDNE     *BLANK
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     C#LCK1        OREQ      *ON
     C                   MOVE      '0052'        WKFENR                         GESCHÜTZTES
     C                   MOVE      *ON           WKTRTP                         FELD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWKNR'                                     WERKNUMMER
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSWKNR        KOM(01)
     C                   MOVE      'WERK01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCWERK
     C*
     C                   MOVEL(P)  'DSWKNR'      EXFLPOFLDN
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   MOVE      WRWKNR        DSWKNR
     C                   MOVEL(P)  WRWKBZ        TXWKNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBOKZ'                                     BORDERO
     C                   MOVE      *BLANK        KOM
     C                   MOVE      DASPCD        KOM(01)
     C                   MOVEA     'JNKZ'        KOM(02)
     C                   MOVEA     DSBOKZ        KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C                   MOVEL(P)  'DSBOKZ'      EXFLPOFLDN
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBOKZ
     C                   MOVEL(P)  TPTTXT        TXBOKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWPNR'                                     WECHSELPRITSCHE
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSWPNR'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSGADA'                                     DATUM
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSGADA'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSSPE1'                                     SPEDITEUR 1
     C                   MOVEA(P)  DSSPE1        KOM(01)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0005'        #CUEBE
     C                   EXSR      MCLIEF
     C*
     C                   MOVEL(P)  'DSSPE1'      EXFLPOFLDN
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LFLFNR        DSSPE1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSSPE2'                                     SPEDITEUR 2
     C                   MOVEA(P)  DSSPE2        KOM(01)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0005'        #CUEBE
     C                   EXSR      MCLIEF
     C*
     C                   MOVEL(P)  'DSSPE2'      EXFLPOFLDN
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LFLFNR        DSSPE2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSSPE3'                                     SPEDITEUR 3
     C                   MOVEA(P)  DSSPE3        KOM(01)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0005'        #CUEBE
     C                   EXSR      MCLIEF
     C*
     C                   MOVEL(P)  'DSSPE3'      EXFLPOFLDN
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LFLFNR        DSSPE3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ10'                                     AUFTRAGJAHR 10
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ10'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ11'                                     AUFTRAGJAHR 11
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ11'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ12'                                     AUFTRAGJAHR 12
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ12'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ13'                                     AUFTRAGJAHR 13
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ13'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ14'                                     AUFTRAGJAHR 14
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ14'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ15'                                     AUFTRAGJAHR 15
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ15'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ16'                                     AUFTRAGJAHR 16
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ16'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ17'                                     AUFTRAGJAHR 17
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ17'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ18'                                     AUFTRAGJAHR 18
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ18'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ19'                                     AUFTRAGJAHR 19
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ19'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ20'                                     AUFTRAGJAHR 20
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ20'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ21'                                     AUFTRAGJAHR 21
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ21'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ22'                                     AUFTRAGJAHR 22
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ22'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ23'                                     AUFTRAGJAHR 23
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ23'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ24'                                     AUFTRAGJAHR 24
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ24'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ25'                                     AUFTRAGJAHR 25
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ25'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ26'                                     AUFTRAGJAHR 26
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ26'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ27'                                     AUFTRAGJAHR 27
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ27'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ28'                                     AUFTRAGJAHR 28
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ28'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ29'                                     AUFTRAGJAHR 29
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ29'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ30'                                     AUFTRAGJAHR 30
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ30'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ31'                                     AUFTRAGJAHR 31
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ31'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ32'                                     AUFTRAGJAHR 32
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ32'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ33'                                     AUFTRAGJAHR 33
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ33'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ34'                                     AUFTRAGJAHR 34
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ34'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ35'                                     AUFTRAGJAHR 35
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ35'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ36'                                     AUFTRAGJAHR 36
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ36'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ37'                                     AUFTRAGJAHR 37
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ37'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ38'                                     AUFTRAGJAHR 38
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ38'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAJ39'                                     AUFTRAGJAHR 39
     C                   MOVE      '0050'        WKFENR                         F4 NICHT GÜLTIG
     C                   MOVEL(P)  'DSAJ39'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN10'
     C                   Z-ADD     DSAJ10        WKAFJJ
     C                   MOVEL(P)  DSAN10        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ10
     C                   MOVEL(P)  WKAFNR        DSAN10
     C                   MOVEL(P)  'DSAN10'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN11'
     C                   Z-ADD     DSAJ11        WKAFJJ
     C                   MOVEL(P)  DSAN11        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ11
     C                   MOVEL(P)  WKAFNR        DSAN11
     C                   MOVEL(P)  'DSAN11'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN12'
     C                   Z-ADD     DSAJ12        WKAFJJ
     C                   MOVEL(P)  DSAN12        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ12
     C                   MOVEL(P)  WKAFNR        DSAN12
     C                   MOVEL(P)  'DSAN12'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN13'
     C                   Z-ADD     DSAJ13        WKAFJJ
     C                   MOVEL(P)  DSAN13        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ13
     C                   MOVEL(P)  WKAFNR        DSAN13
     C                   MOVEL(P)  'DSAN13'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN14'
     C                   Z-ADD     DSAJ14        WKAFJJ
     C                   MOVEL(P)  DSAN14        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ14
     C                   MOVEL(P)  WKAFNR        DSAN14
     C                   MOVEL(P)  'DSAN14'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN15'
     C                   Z-ADD     DSAJ15        WKAFJJ
     C                   MOVEL(P)  DSAN15        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ15
     C                   MOVEL(P)  WKAFNR        DSAN15
     C                   MOVEL(P)  'DSAN15'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN16'
     C                   Z-ADD     DSAJ16        WKAFJJ
     C                   MOVEL(P)  DSAN16        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ16
     C                   MOVEL(P)  WKAFNR        DSAN16
     C                   MOVEL(P)  'DSAN16'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN17'
     C                   Z-ADD     DSAJ17        WKAFJJ
     C                   MOVEL(P)  DSAN17        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ17
     C                   MOVEL(P)  WKAFNR        DSAN17
     C                   MOVEL(P)  'DSAN17'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN18'
     C                   Z-ADD     DSAJ18        WKAFJJ
     C                   MOVEL(P)  DSAN18        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ18
     C                   MOVEL(P)  WKAFNR        DSAN18
     C                   MOVEL(P)  'DSAN18'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN19'
     C                   Z-ADD     DSAJ19        WKAFJJ
     C                   MOVEL(P)  DSAN19        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ19
     C                   MOVEL(P)  WKAFNR        DSAN19
     C                   MOVEL(P)  'DSAN19'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN20'
     C                   Z-ADD     DSAJ20        WKAFJJ
     C                   MOVEL(P)  DSAN20        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ20
     C                   MOVEL(P)  WKAFNR        DSAN20
     C                   MOVEL(P)  'DSAN20'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN21'
     C                   Z-ADD     DSAJ21        WKAFJJ
     C                   MOVEL(P)  DSAN21        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ21
     C                   MOVEL(P)  WKAFNR        DSAN21
     C                   MOVEL(P)  'DSAN21'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN22'
     C                   Z-ADD     DSAJ22        WKAFJJ
     C                   MOVEL(P)  DSAN22        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ22
     C                   MOVEL(P)  WKAFNR        DSAN22
     C                   MOVEL(P)  'DSAN22'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN23'
     C                   Z-ADD     DSAJ23        WKAFJJ
     C                   MOVEL(P)  DSAN23        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ23
     C                   MOVEL(P)  WKAFNR        DSAN23
     C                   MOVEL(P)  'DSAN23'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN24'
     C                   Z-ADD     DSAJ24        WKAFJJ
     C                   MOVEL(P)  DSAN24        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ24
     C                   MOVEL(P)  WKAFNR        DSAN24
     C                   MOVEL(P)  'DSAN24'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN25'
     C                   Z-ADD     DSAJ25        WKAFJJ
     C                   MOVEL(P)  DSAN25        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ25
     C                   MOVEL(P)  WKAFNR        DSAN25
     C                   MOVEL(P)  'DSAN25'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN26'
     C                   Z-ADD     DSAJ26        WKAFJJ
     C                   MOVEL(P)  DSAN26        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ26
     C                   MOVEL(P)  WKAFNR        DSAN26
     C                   MOVEL(P)  'DSAN26'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN27'
     C                   Z-ADD     DSAJ27        WKAFJJ
     C                   MOVEL(P)  DSAN27        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ27
     C                   MOVEL(P)  WKAFNR        DSAN27
     C                   MOVEL(P)  'DSAN27'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN28'
     C                   Z-ADD     DSAJ28        WKAFJJ
     C                   MOVEL(P)  DSAN28        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ28
     C                   MOVEL(P)  WKAFNR        DSAN28
     C                   MOVEL(P)  'DSAN28'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN29'
     C                   Z-ADD     DSAJ29        WKAFJJ
     C                   MOVEL(P)  DSAN29        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ29
     C                   MOVEL(P)  WKAFNR        DSAN29
     C                   MOVEL(P)  'DSAN29'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN30'
     C                   Z-ADD     DSAJ30        WKAFJJ
     C                   MOVEL(P)  DSAN30        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ30
     C                   MOVEL(P)  WKAFNR        DSAN30
     C                   MOVEL(P)  'DSAN30'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN31'
     C                   Z-ADD     DSAJ31        WKAFJJ
     C                   MOVEL(P)  DSAN31        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ31
     C                   MOVEL(P)  WKAFNR        DSAN31
     C                   MOVEL(P)  'DSAN31'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN32'
     C                   Z-ADD     DSAJ32        WKAFJJ
     C                   MOVEL(P)  DSAN32        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ32
     C                   MOVEL(P)  WKAFNR        DSAN32
     C                   MOVEL(P)  'DSAN32'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN33'
     C                   Z-ADD     DSAJ33        WKAFJJ
     C                   MOVEL(P)  DSAN33        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ33
     C                   MOVEL(P)  WKAFNR        DSAN33
     C                   MOVEL(P)  'DSAN33'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN34'
     C                   Z-ADD     DSAJ34        WKAFJJ
     C                   MOVEL(P)  DSAN34        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ34
     C                   MOVEL(P)  WKAFNR        DSAN34
     C                   MOVEL(P)  'DSAN34'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN35'
     C                   Z-ADD     DSAJ35        WKAFJJ
     C                   MOVEL(P)  DSAN35        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ35
     C                   MOVEL(P)  WKAFNR        DSAN35
     C                   MOVEL(P)  'DSAN35'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN36'
     C                   Z-ADD     DSAJ36        WKAFJJ
     C                   MOVEL(P)  DSAN36        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ36
     C                   MOVEL(P)  WKAFNR        DSAN36
     C                   MOVEL(P)  'DSAN36'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN37'
     C                   Z-ADD     DSAJ37        WKAFJJ
     C                   MOVEL(P)  DSAN37        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ37
     C                   MOVEL(P)  WKAFNR        DSAN37
     C                   MOVEL(P)  'DSAN37'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN38'
     C                   Z-ADD     DSAJ38        WKAFJJ
     C                   MOVEL(P)  DSAN38        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ38
     C                   MOVEL(P)  WKAFNR        DSAN38
     C                   MOVEL(P)  'DSAN38'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSAN39'
     C                   Z-ADD     DSAJ39        WKAFJJ
     C                   MOVEL(P)  DSAN39        WKAFNR
     C                   EXSR      MCAFNR
     C                   Z-ADD     WKAFJJ        DSAJ39
     C                   MOVEL(P)  WKAFNR        DSAN39
     C                   MOVEL(P)  'DSAN39'      EXFLPOFLDN
     C                   MOVE      *ON           WKTRTP
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRUEFUNG FUER BILD01                                        ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWKNR        KYWRNR                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            WERKNUMMER
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXWKNR
     C*
     C     WKFENR        IFNE      *ZERO                                        FEHLER
     C                   MOVEL(P)  'DSWKNR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSBOKZ        KYTPTC                         BORDERO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBOKZ
     C*
     C     WKFENR        IFNE      *ZERO                                        FEHLER
     C                   MOVEL(P)  'DSBOKZ'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSGADA        #CDATV
     C                   MOVEL(P)  '*DMY'        #CFMTV
     C                   EXSR      TRDAPR
     C*
     C     WKFENR        IFNE      *ZERO                                        FEHLER
     C                   MOVEL(P)  'DSGADA'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSSPE1        IFNE      *BLANK                                       PRÜFEN
     C                   MOVEL(P)  DSSPE1        KYLFNR                         LIEFERANT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSSPE1'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*
     C     LFLFST        IFGE      '80'
     C                   MOVEL(P)  'DSSPE1'      EXFLPOFLDN
     C                   MOVE      '0009'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSSPE2        IFNE      *BLANK                                       PRÜFEN
     C                   MOVEL(P)  DSSPE2        KYLFNR                         LIEFERANT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSSPE2'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*
     C     LFLFST        IFGE      '80'
     C                   MOVEL(P)  'DSSPE2'      EXFLPOFLDN
     C                   MOVE      '0009'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSSPE3        IFNE      *BLANK                                       PRÜFEN
     C                   MOVEL(P)  DSSPE3        KYLFNR                         LIEFERANT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSSPE3'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*
     C     LFLFST        IFGE      '80'
     C                   MOVEL(P)  'DSSPE3'      EXFLPOFLDN
     C                   MOVE      '0009'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN10        IFNE      *BLANK
     C                   Z-ADD     DSAJ10        KYAKJH
     C                   MOVE      DSAN10        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN10'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN10'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN11        IFNE      *BLANK
     C                   Z-ADD     DSAJ11        KYAKJH
     C                   MOVE      DSAN11        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN11'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN11'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN12        IFNE      *BLANK
     C                   Z-ADD     DSAJ12        KYAKJH
     C                   MOVE      DSAN12        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN12'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN12'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN13        IFNE      *BLANK
     C                   Z-ADD     DSAJ13        KYAKJH
     C                   MOVE      DSAN13        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN13'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN13'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN14        IFNE      *BLANK
     C                   Z-ADD     DSAJ14        KYAKJH
     C                   MOVE      DSAN14        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN14'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN14'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN15        IFNE      *BLANK
     C                   Z-ADD     DSAJ15        KYAKJH
     C                   MOVE      DSAN15        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN15'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN15'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN16        IFNE      *BLANK
     C                   Z-ADD     DSAJ16        KYAKJH
     C                   MOVE      DSAN16        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN16'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN16'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN17        IFNE      *BLANK
     C                   Z-ADD     DSAJ17        KYAKJH
     C                   MOVE      DSAN17        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN17'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN17'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN18        IFNE      *BLANK
     C                   Z-ADD     DSAJ18        KYAKJH
     C                   MOVE      DSAN18        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN18'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN18'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN19        IFNE      *BLANK
     C                   Z-ADD     DSAJ19        KYAKJH
     C                   MOVE      DSAN19        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN19'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE1        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN19'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN20        IFNE      *BLANK
     C                   Z-ADD     DSAJ20        KYAKJH
     C                   MOVE      DSAN20        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN20'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN20'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN21        IFNE      *BLANK
     C                   Z-ADD     DSAJ21        KYAKJH
     C                   MOVE      DSAN21        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN21'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN21'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN22        IFNE      *BLANK
     C                   Z-ADD     DSAJ22        KYAKJH
     C                   MOVE      DSAN22        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN22'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN22'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN23        IFNE      *BLANK
     C                   Z-ADD     DSAJ23        KYAKJH
     C                   MOVE      DSAN23        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN23'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN23'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN24        IFNE      *BLANK
     C                   Z-ADD     DSAJ24        KYAKJH
     C                   MOVE      DSAN24        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN24'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN24'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN25        IFNE      *BLANK
     C                   Z-ADD     DSAJ25        KYAKJH
     C                   MOVE      DSAN25        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN25'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN25'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN26        IFNE      *BLANK
     C                   Z-ADD     DSAJ26        KYAKJH
     C                   MOVE      DSAN26        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN26'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN26'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN27        IFNE      *BLANK
     C                   Z-ADD     DSAJ27        KYAKJH
     C                   MOVE      DSAN27        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN27'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN27'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN28        IFNE      *BLANK
     C                   Z-ADD     DSAJ28        KYAKJH
     C                   MOVE      DSAN28        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN28'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN28'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN29        IFNE      *BLANK
     C                   Z-ADD     DSAJ29        KYAKJH
     C                   MOVE      DSAN29        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN29'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE2        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN29'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN30        IFNE      *BLANK
     C                   Z-ADD     DSAJ30        KYAKJH
     C                   MOVE      DSAN30        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN30'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN30'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN31        IFNE      *BLANK
     C                   Z-ADD     DSAJ31        KYAKJH
     C                   MOVE      DSAN31        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN31'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN31'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN32        IFNE      *BLANK
     C                   Z-ADD     DSAJ32        KYAKJH
     C                   MOVE      DSAN32        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN32'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN32'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN33        IFNE      *BLANK
     C                   Z-ADD     DSAJ33        KYAKJH
     C                   MOVE      DSAN33        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN33'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN33'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN34        IFNE      *BLANK
     C                   Z-ADD     DSAJ34        KYAKJH
     C                   MOVE      DSAN34        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN34'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN34'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN35        IFNE      *BLANK
     C                   Z-ADD     DSAJ35        KYAKJH
     C                   MOVE      DSAN35        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN35'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN35'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN36        IFNE      *BLANK
     C                   Z-ADD     DSAJ36        KYAKJH
     C                   MOVE      DSAN36        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN36'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN36'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN37        IFNE      *BLANK
     C                   Z-ADD     DSAJ37        KYAKJH
     C                   MOVE      DSAN37        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN37'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN37'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN38        IFNE      *BLANK
     C                   Z-ADD     DSAJ38        KYAKJH
     C                   MOVE      DSAN38        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN38'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN38'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSAN39        IFNE      *BLANK
     C                   Z-ADD     DSAJ39        KYAKJH
     C                   MOVE      DSAN39        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSAN39'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     DSSPE3        IFEQ      *BLANK
     C                   MOVEL(P)  'DSAN39'      EXFLPOFLDN
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   LEAVE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE AFNR                                                   ***
     C**************************************************************************
     C     MCAFNR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     WKAFJJ        DUN040
     C                   MOVEA     DUC004        KOM(13)
     C                   MOVEA     WKAFNR        KOM(17)
     C                   MOVE      '5     '      #CPGST
     C                   MOVE      '0535'        #CUEBE
     C                   EXSR      MCAFKO
     C*
     C     WKTRTP        IFEQ      *ON                                          FEHLER
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKTRTP
     C                   Z-ADD     AKAFJJ        WKAFJJ
     C                   MOVEL(P)  AKAFNR        WKAFNR
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE FELDER SP16                                                ***
     C**************************************************************************
     C     USP16         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSGADA        IFNE      *ZERO
     C                   Z-ADD     DSGADA        #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        EXSP16GADA
     C                   ELSE
     C                   Z-ADD     *ZERO         EXSP16GADA
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWKNR        EXSP16WKNR                     WERKNUMMER
     C                   MOVEL(P)  DSBOKZ        EXSP16BOKZ                     BORDERO
     C                   MOVEL(P)  DSWPNR        EXSP16WPNR                     WP-NUMMER
     C                   MOVEL(P)  DSSPE1        EXSP16SPE1                     SPEDITEUR
     C                   MOVEL(P)  DSSPE2        EXSP16SPE2                     SPEDITEUR
     C                   MOVEL(P)  DSSPE3        EXSP16SPE3                     SPEDITEUR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSAJ10        EXSP16AJ10
     C                   MOVEL(P)  DSAN10        EXSP16AN10
     C                   Z-ADD     DSAJ11        EXSP16AJ11
     C                   MOVEL(P)  DSAN11        EXSP16AN11
     C                   Z-ADD     DSAJ12        EXSP16AJ12
     C                   MOVEL(P)  DSAN12        EXSP16AN12
     C                   Z-ADD     DSAJ13        EXSP16AJ13
     C                   MOVEL(P)  DSAN13        EXSP16AN13
     C                   Z-ADD     DSAJ14        EXSP16AJ14
     C                   MOVEL(P)  DSAN14        EXSP16AN14
     C                   Z-ADD     DSAJ15        EXSP16AJ15
     C                   MOVEL(P)  DSAN15        EXSP16AN15
     C                   Z-ADD     DSAJ16        EXSP16AJ16
     C                   MOVEL(P)  DSAN16        EXSP16AN16
     C                   Z-ADD     DSAJ17        EXSP16AJ17
     C                   MOVEL(P)  DSAN17        EXSP16AN17
     C                   Z-ADD     DSAJ18        EXSP16AJ18
     C                   MOVEL(P)  DSAN18        EXSP16AN18
     C                   Z-ADD     DSAJ19        EXSP16AJ19
     C                   MOVEL(P)  DSAN19        EXSP16AN19
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSAJ20        EXSP16AJ20
     C                   MOVEL(P)  DSAN20        EXSP16AN20
     C                   Z-ADD     DSAJ21        EXSP16AJ21
     C                   MOVEL(P)  DSAN21        EXSP16AN21
     C                   Z-ADD     DSAJ22        EXSP16AJ22
     C                   MOVEL(P)  DSAN22        EXSP16AN22
     C                   Z-ADD     DSAJ23        EXSP16AJ23
     C                   MOVEL(P)  DSAN23        EXSP16AN23
     C                   Z-ADD     DSAJ24        EXSP16AJ24
     C                   MOVEL(P)  DSAN24        EXSP16AN24
     C                   Z-ADD     DSAJ25        EXSP16AJ25
     C                   MOVEL(P)  DSAN25        EXSP16AN25
     C                   Z-ADD     DSAJ26        EXSP16AJ26
     C                   MOVEL(P)  DSAN26        EXSP16AN26
     C                   Z-ADD     DSAJ27        EXSP16AJ27
     C                   MOVEL(P)  DSAN27        EXSP16AN27
     C                   Z-ADD     DSAJ28        EXSP16AJ28
     C                   MOVEL(P)  DSAN28        EXSP16AN28
     C                   Z-ADD     DSAJ29        EXSP16AJ29
     C                   MOVEL(P)  DSAN29        EXSP16AN29
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSAJ30        EXSP16AJ30
     C                   MOVEL(P)  DSAN30        EXSP16AN30
     C                   Z-ADD     DSAJ31        EXSP16AJ31
     C                   MOVEL(P)  DSAN31        EXSP16AN31
     C                   Z-ADD     DSAJ32        EXSP16AJ32
     C                   MOVEL(P)  DSAN32        EXSP16AN32
     C                   Z-ADD     DSAJ33        EXSP16AJ33
     C                   MOVEL(P)  DSAN33        EXSP16AN33
     C                   Z-ADD     DSAJ34        EXSP16AJ34
     C                   MOVEL(P)  DSAN34        EXSP16AN34
     C                   Z-ADD     DSAJ35        EXSP16AJ35
     C                   MOVEL(P)  DSAN35        EXSP16AN35
     C                   Z-ADD     DSAJ36        EXSP16AJ36
     C                   MOVEL(P)  DSAN36        EXSP16AN36
     C                   Z-ADD     DSAJ37        EXSP16AJ37
     C                   MOVEL(P)  DSAN37        EXSP16AN37
     C                   Z-ADD     DSAJ38        EXSP16AJ38
     C                   MOVEL(P)  DSAN38        EXSP16AN38
     C                   Z-ADD     DSAJ39        EXSP16AJ39
     C                   MOVEL(P)  DSAN39        EXSP16AN39
     C*-------------------------------------------------------------------------
     C                   CALL      'TRSP16CL'
     C                   PARM                    EXSP16
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN NACHRICHTEN                                           ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT                         MSG-ART (F,I)
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9            ÜBERGABEPARAMETER
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9            ÜBERGABEPARAMETER
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9            ÜBERGABEPARAMETER
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9            ÜBERGABEPARAMETER
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9            ÜBERGABEPARAMETER
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'
     C                   PARM                    WKFENR
     C                   PARM                    KEYVAR
     C                   PARM                    DSJNAM
     C                   PARM                    WKUSER
     C                   PARM                    W$PA03
     C                   PARM                    W$PA04
     C                   PARM                    W$PA05
     C                   PARM                    W$PA06
     C                   PARM                    W$PA07
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRSP15'      PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           C#INIT                         SUBFILE
     C*
     C                   WRITE     TRSP15CT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*
     C                   WRITE     TRSP15CT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  C O P Y - M O D U L E                                             ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRUE
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,MCAFKO
     C/COPY QCPYSRC,MCLIEF
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCWERK
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDAPR
     C/COPY QCPYSRC,TRDAUM
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
