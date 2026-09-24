     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE  Update Datei WAOM
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 26.11.2012 Projekt 9103 - Veränderung monatlicher %-Sätze
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*/
     F*/ Update Datei WAOM
     F*/
     F*/ Projekt 9103 - Erweiterung der Datei WAOM um die Felder WAOMLDNR, WAOMSTKD
     F*/
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D WAOM          E DS                  INZ
     D KYWAOM        E DS                  INZ
     D WKWAOM        E DS                  EXTNAME(WAOM) PREFIX(WK)
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
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
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OWAOM
     C                   EXSR      VWAOM
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXPSDSPROC    WKCHPN
     C                   MOVEL     EXPSDSBIBL    WKCHPL
     C                   MOVEL     EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOMC1                                             ***
     C**************************************************************************
     C     OWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOMC1 CURSOR FOR SELECT * FROM WAOM
     C+ WHERE WAOMLDNR='   '
     C+ ORDER BY WAOMFIRM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOMC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN WAOM                                                  ***
     C**************************************************************************
     C     VWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  FETCH WAOMC1 INTO :WAOM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*--------------------------------------------------------
     C                   IF        WAOMFIRM   <> EXFIRMFIRM
     C                   MOVEL     WAOMFIRM      EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C*
     C                   MOVEL(P)  EXFIRMFIRM    DAFIRM
     C                   MOVEL(P)  EXFIRMSPCD    DASPCD
     C                   MOVEL(P)  EXFIRMJAKZ    DAJNKZ
     C                   MOVEL(P)  EXFIRMNEKZ    DANEKZ
     C                   OUT       EXTRLD                                       *LDA
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAOM          WKWAOM
     C*
     C                   SELECT
     C     WKWAOMKDNR    WHENNE    *BLANK
     C                   MOVEL(P)  WKWAOMKDNR    WKWAOMSTKD
     C     WKWAOMKDPL    WHENNE    *BLANK
     C                   MOVEL(P)  WKWAOMFIRM    KYKDEWFIRM
     C                   MOVEL(P)  WKWAOMKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      WKWAOMSTKD
     C                   ENDIF
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKWAOMFIRM    KYKDFI
     C                   MOVEL(P)  WKWAOMSTKD    KYKDNR
     C                   MOVEA     '01C   '      CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDLAND        WKWAOMLDNR
     C*
     C                   EXSR      UWAOM
     C*--------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOMC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOM                                                 ***
     C**************************************************************************
     C     UWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOMFIRM      KYWAOMFIRM
     C                   MOVEL(P)  WAOMKSTC      KYWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      KYWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      KYWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      KYWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      KYWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      KYWAOMPRGR
     C                   Z-ADD     WAOMJAHR      KYWAOMJAHR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWAOMLDNR    WAOMLDNR
     C                   MOVEL(P)  WKWAOMSTKD    WAOMSTKD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOM
     C*--------------------------------------------------------
     C                   ENDSL
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
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOMBIBL      WKCHPL
     C     *LIKE         DEFINE    WAOMPROG      WKCHPN
     C     *LIKE         DEFINE    WAOMUSER      WKUSER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
