     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2008')
     H**************************************************************************
     H/TITLE  XML-Ausgabe Modifikationen zum Einlagerung-Position
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: VU 02.07.2012 Projekt 8604 - Andrucken Kennzeichen
     H*                          R = Zuordnung/Reservierung vorhanden
     H*                          V = Eintrag der Länge in TEOS fehlt
     H*                          D = Eintrag der Verpackungs-Einheit Länge fehlt
     H*  -----------------------------------------------------------------------
     H*  Geändert: MG 15.06.2015 Projekt 10804, Datei TEOS ersetzt durch TEIL, TEVP
     H*
     H**************************************************************************
     F*
     F*  Dieses Programm erstellt die XML-Blöcke der Modifikationen zur
     F*  Einlagerung-Position. Es erhält die XML, sowie Schlüsseldaten aus dem
     F*  aufrufenden Programm XLLBEP01. XML-Blöcke werden direkt im
     F*  Hauptspeicher hinzugefügt
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D LBEP          E DS
     D*
     D BBEU          E DS                  INZ
     D KYBBEU        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEVP          E DS                  INZ
     D KYTEVP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
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
     C                   PARM                    LBEP
     C                   PARM                    EXXMLDRFL
     C*
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      XLLBEP
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYEUFI                         BBEU
     C                   MOVEL     DAFIRM        KYAEFI                         BWAE
     C                   MOVEL     DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYTEVPFIRM                     TEVP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE Kennzeichnen R/V/D                                        ***
     C**************************************************************************
     C     XLLBEP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKKENR
     C                   MOVE      *BLANK        WKKENV
     C                   MOVE      *BLANK        WKKEND
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------
     C     LBEPDANA      WHENEQ    'BWAE'
     C                   Z-ADD     LBEPJAHR      KYAEWJ
     C                   MOVEL(P)  LBEPNMKR      KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C     CHI(5)        IFEQ      'J'
     C                   Z-ADD     AEBEJJ        KYEUJH
     C                   MOVEL     AEBENR        KYEUBE
     C                   Z-ADD     AEBEPO        KYEUPO
     C                   Z-ADD     *ZERO         KYEUUP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBBEU
     C     CHI(5)        IFEQ      'J'
     C     EUFIRM        ANDEQ     KYEUFI
     C     EUBEJJ        ANDEQ     KYEUJH
     C     EUBENR        ANDEQ     KYEUBE
     C     EUBEPO        ANDEQ     KYEUPO
     C                   MOVE      'R'           WKKENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------
     C     LBEPDANA      WHENEQ    'LBLB'
     C                   MOVEL(P)  LBEPDANA      KYLBRSDANA
     C                   Z-ADD     LBEPJAHR      KYLBRSJAHR
     C                   MOVEL(P)  LBEPNMKR      KYLBRSNMKR
     C                   Z-ADD     LBEPPOSI      KYLBRSPOSI
     C                   MOVE      *LOVAL        KYLBRSTMST
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C     CHI(5)        IFEQ      'J'
     C     LBRSFIRM      ANDEQ     KYLBRSFIRM
     C     LBRSDANA      ANDEQ     KYLBRSDANA
     C     LBRSJAHR      ANDEQ     KYLBRSJAHR
     C     LBRSNMKR      ANDEQ     KYLBRSNMKR
     C     LBRSPOSI      ANDEQ     KYLBRSPOSI
     C                   MOVE      'R'           WKKENR
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBEPTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     TELANG        IFEQ      *ZERO
     C                   MOVE      'V'           WKKENV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBEPTENR      KYTEVPTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEVP
     C     TEVPLAMM      IFEQ      *ZERO
     C                   MOVE      'D'           WKKEND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKDRFLPGST = 'ADDBLOC'
     C                   EVAL      WKDRFLBLOC = 'MODWAOLBEP  '
     C                   EXSR      ERAUFRDRFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  XML Erzeugen                                                      ***
     C**************************************************************************
     C     ERAUFRDRFL    BEGSR
     C*-------------------------------------------------------------------------
     C                   EXSR      INIDRFL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'XLLBEP01'    EXDRFLPGNA
     C                   MOVEL(P)  WKDRFLPGST    EXDRFLPGST
     C                   MOVEL(P)  WKDRFLBLOC    EXDRFLBLOC
     C                   MOVEL(P)  DASPCD        EXDRFLSPCD
     C*
     C                   MOVEL(P)  LBEPDANA      EXDRFLDANA
     C                   Z-ADD     LBEPJAHR      EXDRFLJAHR
     C                   MOVEL(P)  LBEPNMKR      EXDRFLNMKR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*----------------------------------------------------------
     C     EXDRFLBLOC    WHENEQ    'MODWAOLBEP'
     C     1             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##KENR    '  EXDRFLALPF
     C                   MOVEL(P)  WKKENR        EXDRFLALPH
     C     2             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##KENV    '  EXDRFLALPF
     C                   MOVEL(P)  WKKENV        EXDRFLALPH
     C     3             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##KEND    '  EXDRFLALPF
     C                   MOVEL(P)  WKKEND        EXDRFLALPH
     C*----------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      ERDRFL
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKENR
     C     *LIKE         DEFINE    WKC001        WKKENV
     C     *LIKE         DEFINE    WKC001        WKKEND
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,ERDRFL
     C/COPY QCPYSRC,CHBBEU
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEVP
