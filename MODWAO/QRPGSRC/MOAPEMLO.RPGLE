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
     H*  Erstellt: MG 30.08.2011 Projekt 7668 Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MB DATUM      Referenz
     H*
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     F*  Projekt 7668: Planungssystem
     F*
     F*      SR-EAPEH: Ermitteln Daten aus Erhöhungstabelle Dometic (WAOK)
     F*
     F*      SR-EAPPZ: Ermitteln Daten aus %-Sätze Jahresebene (WAOM)
     F*
     F*      SR-LAPEM: Aktualisieren Absatz-Plan Dometic (WAOL)
     F*      SR-WAPEM: Aktualisieren Absatz-Plan Dometic (WAOL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SFLPDIM         S                   DIM(99) INZ LIKE(APEMPDIM)           Preis-Dimension
     D SFLTNUM         S                   DIM(99) INZ LIKE(TPTNUM)             num. Wert
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D APEH          E DS                  INZ
     D*
     D APPZ          E DS                  INZ
     D*
     D APEM          E DS                  INZ
     D KYAPEM        E DS                  INZ
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
     D WAOK          E DS                  INZ
     D KYWAOK        E DS                  INZ
     D*
     D WAOL          E DS                  INZ
     D KYWAOL        E DS                  INZ
     D*
     D WAOM          E DS                  INZ
     D KYWAOM        E DS                  INZ
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
     C     PCPGST        WHENEQ    'EAPEH '
     C                   EXSR      EAPEH
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'EAPPZ '
     C                   EXSR      EAPPZ
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LAPEM '
     C                   EXSR      LAPEM
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'WAPEM '
     C                   EXSR      WAPEM
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
     C                   MOVEL(P)  DAFIRM        KYWAOKFIRM                     WAOK
     C                   MOVEL(P)  DAFIRM        KYWAOLFIRM                     WAOL
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM                     WAOM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C* Ermitteln Preisdimension aus Anwendungs-Code
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRTPPDIM
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
     C                   MOVEL     EXTRNDKEYB    KYAPEM
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
     C***  ERMITTELN DATEN AUS ERHÖHUNGSTABELLE DOMETIC                      ***
     C**************************************************************************
     C     EAPEH         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produktgruppe aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYAPEMTENR
     C                   MOVEL     KYAPEMTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Planungskz, Kundenplanung aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C     KDEWKDNR      IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Kundengruppe, Vertriebsbereich aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Prozentsaätze aus Erhöhungstabelle
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOK
     C                   MOVEL     DAFIRM        KYWAOKFIRM
     C                   SELECT
     C     KDEWPLKZ      WHENEQ    '1'
     C                   MOVEL     KDKSTC        KYWAOKKSTC
     C     KDEWPLKZ      WHENEQ    '2'
     C                   MOVEL     KDKDGR        KYWAOKKDGR
     C     KDEWPLKZ      WHENEQ    '3'
     C                   MOVEL     KDEWKDPL      KYWAOKKDPL
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL     KDKDNR        KYWAOKKDNR
     C                   OTHER
     C                   MOVEL     KDKSTC        KYWAOKKSTC
     C                   ENDSL
     C                   MOVEL     TEPRGR        KYWAOKPRGR
     C                   MOVEL     KYAPEMJJMO    KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     WKFENR        RTTRNDFENR
     C*
     C                   CLEAR                   APEH
     C                   MOVEL     WAOKFIRM      APEHFIRM
     C                   MOVEL     WAOKKSTC      APEHKSTC
     C                   MOVEL     WAOKPRGR      APEHPRGR
     C                   Z-ADD     WAOKJAHR      APEHJAHR
     C                   Z-ADD     WAOKMGPZ      APEHMGPZ
     C                   Z-ADD     WAOKPRPZ      APEHPRPZ
     C                   MOVEL     APEH          RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS %-SÄTZE JAHRESEBENE DOMETIC                   ***
     C**************************************************************************
     C     EAPPZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produktgruppe aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYAPEMTENR
     C                   MOVEL     KYAPEMTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Planungskz, Kundenplanung aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C     KDEWKDNR      IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Kundengruppe, Vertriebsbereich aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Prozentsaätze aus Erhöhungstabelle
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOM
     C                   MOVEL     DAFIRM        KYWAOMFIRM
     C                   SELECT
     C     KDEWPLKZ      WHENEQ    '1'
     C                   MOVEL     KDKSTC        KYWAOMKSTC
     C     KDEWPLKZ      WHENEQ    '2'
     C                   MOVEL     KDKDGR        KYWAOMKDGR
     C     KDEWPLKZ      WHENEQ    '3'
     C                   MOVEL     KDEWKDPL      KYWAOMKDPL
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL     KDKDNR        KYWAOMKDNR
     C                   OTHER
     C                   MOVEL     KDKSTC        KYWAOMKSTC
     C                   ENDSL
     C                   MOVEL     TEPRGR        KYWAOMPRGR
     C                   MOVEL     KYAPEMJJMO    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     WKFENR        RTTRNDFENR
     C*
     C                   CLEAR                   APPZ
     C                   MOVEL     WAOMFIRM      APPZFIRM
     C                   MOVEL     WAOMKDNR      APPZKDNR
     C                   MOVEL     WAOMKDGR      APPZKDGR
     C                   MOVEL     WAOMPRGR      APPZPRGR
     C                   Z-ADD     WAOMJAHR      APPZJAHR
     C                   Z-ADD     WAOMPZ01      APPZPZ01
     C                   Z-ADD     WAOMPZ02      APPZPZ02
     C                   Z-ADD     WAOMPZ03      APPZPZ03
     C                   Z-ADD     WAOMPZ04      APPZPZ04
     C                   Z-ADD     WAOMPZ05      APPZPZ05
     C                   Z-ADD     WAOMPZ06      APPZPZ06
     C                   Z-ADD     WAOMPZ07      APPZPZ07
     C                   Z-ADD     WAOMPZ08      APPZPZ08
     C                   Z-ADD     WAOMPZ09      APPZPZ09
     C                   Z-ADD     WAOMPZ10      APPZPZ10
     C                   Z-ADD     WAOMPZ11      APPZPZ11
     C                   Z-ADD     WAOMPZ12      APPZPZ12
     C                   MOVEL     APPZ          RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOL                                          ***
     C**************************************************************************
     C     LAPEM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Aufbereiten Schlüssel-Felder Datei WAOL
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOL
     C*
     C                   MOVEL     EXTRNDDATE    APEM
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C*-------------------------------------------------------------------------
     C                   SUB       APEMPLMG      WAOLPLMG
     C*--------------------------------------------------------
     C                   Z-ADD     1             I0
     C     APEMPDIM      LOOKUP    SFLPDIM(I0)                            99
     C*
     C     *IN99         IFEQ      *ON
     C     SFLTNUM(I0)   ANDNE     *ZERO
     C     APEMPLMG      MULT      APEMPLPR      DUN112
     C                   DIV       SFLTNUM(I0)   DUN112
     C                   ELSE
     C     APEMPLMG      MULT      APEMPLPR      DUN112
     C                   ENDIF
     C*
     C                   SUB       DUN112        WAOLPLUM
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
     C     WAPEM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Aufbereiten Schlüssel-Felder Datei WAOL
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOL
     C*
     C                   MOVEL     EXTRNDDATE    APEM
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C*-------------------------------------------------------------------------
     C                   ADD       APEMPLMG      WAOLPLMG
     C*--------------------------------------------------------
     C                   Z-ADD     1             I0
     C     APEMPDIM      LOOKUP    SFLPDIM(I0)                            99
     C*
     C     *IN99         IFEQ      *ON
     C     SFLTNUM(I0)   ANDNE     *ZERO
     C     APEMPLMG      MULT      APEMPLPR      DUN112
     C                   DIV       SFLTNUM(I0)   DUN112
     C                   ELSE
     C     APEMPLMG      MULT      APEMPLPR      DUN112
     C                   ENDIF
     C*
     C                   ADD       DUN112        WAOLPLUM
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
     C     TETENR        IFNE      KYAPEMTENR
     C                   MOVEL     KYAPEMTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Planungskz, Kundenplanung aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C     KDEWKDNR      IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Kundengruppe, Vertriebsbereich aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      KYAPEMKDLI
     C                   MOVEL     KYAPEMKDLI    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Prozentsaätze aus Erhöhungstabelle
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOL
     C                   MOVEL     KYAPEMFIRM    KYWAOLFIRM
     C                   MOVEL     KYAPEMPLAT    KYWAOLPLAT
     C                   MOVEL     KYAPEMWKNR    KYWAOLWKNR
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
     C                   MOVEL     KYAPEMJJMO    KYWAOLJAHR
     C                   MOVE      KYAPEMJJMO    KYWAOLMONA
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
     C***  ERMITTELN PREIS-DIMENSION AUS TABELLE "PDIM"                      ***
     C**************************************************************************
     C     ETRTPPDIM     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I0
     C                   MOVE      *BLANK        SFLPDIM
     C                   MOVE      *ZERO         SFLTNUM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVE      *LOVAL        KYTPTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        OFTPTA
     C*--------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     TPFIRM        ANDEQ     KYTPFI
     C     TPSPCD        ANDEQ     KYTPSP
     C     TPTART        ANDEQ     OFTPTA
     C*--------------------------------------------------------
     C     I0            IFLT      99
     C     TPTFLG        ANDEQ     *ZERO
     C                   ADD       1             I0
     C                   MOVEL(P)  TPTCDE        SFLPDIM(I0)
     C                   Z-ADD     TPTNUM        SFLTNUM(I0)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
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
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
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
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
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
     C/COPY QCPYSRC,CHWAOK
     C/COPY QCPYSRC,CHWAOL
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
