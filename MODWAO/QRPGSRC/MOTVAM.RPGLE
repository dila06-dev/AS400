     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 22.09.2011 Projekt 7668 Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MB DATUM      Referenz
     H*
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     F*  Projekt 7668: Planungssystem
     F*
     F*      SR-LTVAM: Aktualisieren Statistik Dometic (WAOL)
     F*      SR-WTVAM: Aktualisieren Statistik Dometic (WAOL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TVAM          E DS                  INZ
     D KYTVAM        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOL          E DS                  INZ
     D KYWAOL        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
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
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBTREND
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
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LTVAM '
     C                   EXSR      LTVAM
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'WTVAM '
     C                   EXSR      WTVAM
     C*--------------------------------------------------------
     C                   ENDSL
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
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAOLFIRM                     WAOL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEL     EXTRNDKEYB    KYTVAM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOL                                          ***
     C**************************************************************************
     C     LTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Aufbereiten Schlüssel-Felder Datei WAOL
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOL
     C*
     C                   MOVEL     EXTRNDDATE    TVAM
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C*-------------------------------------------------------------------------
     C                   SUB       VMMGST        WAOLSTMG
     C                   SUB       VMWTST        WAOLSTUM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOLJNAM
     C                   MOVEL(P)  DAPROG        WAOLPROG
     C                   MOVEL(P)  WKCHPL        WAOLBIBL
     C                   MOVEL(P)  DAUSER        WAOLUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOLJZEI
     C                   MOVE      WKTDAT        WAOLJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C     WAOLPLMG      WHENEQ    *ZERO
     C     WAOLSTMG      ANDEQ     *ZERO
     C     WAOLSTUM      ANDEQ     *ZERO
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  HINZUFÜGEN SÄTZE DATEI WAOL                                       ***
     C**************************************************************************
     C     WTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Aufbereiten Schlüssel-Felder Datei WAOL
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOL
     C*
     C                   MOVEL     EXTRNDDATE    TVAM
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C*-------------------------------------------------------------------------
     C                   ADD       VMMGST        WAOLSTMG
     C                   ADD       VMWTST        WAOLSTUM
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN SCHLÜSSEL-FELDER                                      ***
     C**************************************************************************
     C     KEYWAOL       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produktgruppe aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYVMTE
     C                   MOVEL     KYVMTE        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Planungskz, Kundenplanung aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C     KDEWKDNR      IFNE      KYVMKD
     C                   MOVEL     KYVMKD        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Kundengruppe, Vertriebsbereich aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      KYVMKD
     C                   MOVEL     KYVMKD        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Prozentsaätze aus Erhöhungstabelle
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOL
     C                   MOVEL     KYVMFI        KYWAOLFIRM
     C                   MOVEL     KYVMWK        KYWAOLWKNR
     C                   SELECT
     C     KDEWPLKZ      WHENEQ    '1'
     C                   MOVEL     KDKSTC        KYWAOLKSTC
     C     KDEWPLKZ      WHENEQ    '2'
     C                   MOVEL     KDKDGR        KYWAOLKDGR
     C     KDEWPLKZ      WHENEQ    '3'
     C                   MOVEL     KDEWKDPL      KYWAOLKDPL
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL     KDKDNR        KYWAOLKDNR
     C                   OTHER
     C                   MOVEL     KDKSTC        KYWAOLKSTC
     C                   ENDSL
     C                   MOVEL     TEPRGR        KYWAOLPRGR
     C                   Z-ADD     KYVMJH        KYWAOLJAHR
     C                   Z-ADD     KYVMMO        KYWAOLMONA
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
     C                   MOVEL(P)  'MCAPEM'      KYTATA                         STATISTIK-ART
     C                   MOVEL(P)  'TVAM'        KYTATC                         FÜR ANZEIGE
     C                   MOVEL(P)  'BEGRIFF'     KYTAPA                         MONATS-UMSATZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTVAMBEGR
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
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTVAMBEGR      + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOL
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
