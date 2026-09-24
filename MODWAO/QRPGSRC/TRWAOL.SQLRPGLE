     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOL
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 15.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MB Datum      Referenz
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOL.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOLFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D SFLPDIM         S                   DIM(99) INZ LIKE(WAOLPDIM)
     D SFLTNUM         S                   DIM(99) INZ LIKE(TPTNUM)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAOL          E DS                  INZ
     D KYWAOL        E DS                  INZ
     D*
     D APEM          E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WACD          E DS                  INZ
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
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
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
     D EXAPEM        E DS                  INZ
     D RTAPEM        E DS                  INZ
     D*
     D EXWAOL        E DS
     D RTWAOL        E DS
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
     C                   PARM                    EXWAOL
     C                   PARM                    RTWAOL
     C*
     C                   EXSR      UEBWAOL
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
     C                   CLOSE     TRWAOLFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOL '
     C                   EXSR      PWAOL
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOL
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAOLIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOL                                       UPDATE
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
     C                   OPEN      TRWAOLFM                             98
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
     C                   CLOSE     TRWAOLFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOLRTCD
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
     C                   MOVEL(P)  DAFIRM        KYWAOLFIRM                     WAOL
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C* Ermitteln Preisdimension aus Anwendungs-Code
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRTPPDIM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOLFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOLFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXWAOL                         ***
     C**************************************************************************
     C     UEBWAOL       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXWAOL'      EXDATAFILE
     C                   MOVEL(P)  EXWAOL        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXWAOL
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXWAOLPGST    PCPGST
     C*
     C                   MOVEL(P)  EXWAOLPLAT    KYWAOLPLAT
     C                   MOVEL(P)  EXWAOLWKNR    KYWAOLWKNR
     C                   MOVEL(P)  EXWAOLKSTC    KYWAOLKSTC
     C                   MOVEL(P)  EXWAOLKDGR    KYWAOLKDGR
     C                   MOVEL(P)  EXWAOLKDPL    KYWAOLKDPL
     C                   MOVEL(P)  EXWAOLKDNR    KYWAOLKDNR
     C                   MOVEL(P)  EXWAOLPRGR    KYWAOLPRGR
     C                   Z-ADD     EXWAOLJAHR    KYWAOLJAHR
     C                   Z-ADD     EXWAOLMONA    KYWAOLMONA
     C*
     C                   MOVEL(P)  EXWAOLPLAT    DSWAOLPLAT
     C                   MOVEL(P)  EXWAOLWKNR    DSWAOLWKNR
     C                   MOVEL(P)  EXWAOLKSTC    DSWAOLKSTC
     C                   MOVEL(P)  EXWAOLKDGR    DSWAOLKDGR
     C                   MOVEL(P)  EXWAOLKDPL    DSWAOLKDPL
     C                   MOVEL(P)  EXWAOLKDNR    DSWAOLKDNR
     C                   MOVEL(P)  EXWAOLPRGR    DSWAOLPRGR
     C                   Z-ADD     EXWAOLJAHR    DSWAOLJAHR
     C                   Z-ADD     EXWAOLMONA    DSWAOLMONA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOL
     C                   MOVEL     *ZERO         RTWAOLFENR
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
     C                   MOVEL(P)  'TRWAOL'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
     C*                  MOVEA(P)  W99(32)       WNKOPF
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
     C                   MOVEL     'TRWAOL01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOL01
     C                   WRITE     TRWAOLB1
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
     C                   READ      TRWAOL01                             9899
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
     C                   EXSR      UWAOL
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C     EXWAOLPLAT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLPLAT
     C                   ENDIF
     C     EXWAOLWKNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLWKNR
     C                   ENDIF
     C     EXWAOLKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLKSTC
     C                   ENDIF
     C     EXWAOLKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLKDGR
     C                   ENDIF
     C     EXWAOLKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLKDPL
     C                   ENDIF
     C     EXWAOLKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLKDNR
     C                   ENDIF
     C     EXWAOLPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOLPRGR
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYWAOLJAHR
     C                   Z-ADD     *ZERO         KYWAOLMONA
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOL
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOL
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
     C                   CLEAR                   WAOL
     C                   EXSR      ETRMU
     C                   EXSR      EWAOL
     C                   MOVEL(P)  KYWAOLPLAT    WAOLPLAT
     C                   MOVEL(P)  KYWAOLWKNR    WAOLWKNR
     C                   MOVEL(P)  KYWAOLKSTC    WAOLKSTC
     C                   MOVEL(P)  KYWAOLKDGR    WAOLKDGR
     C                   MOVEL(P)  KYWAOLKDPL    WAOLKDPL
     C                   MOVEL(P)  KYWAOLKDNR    WAOLKDNR
     C                   MOVEL(P)  KYWAOLPRGR    WAOLPRGR
     C                   Z-ADD     KYWAOLJAHR    WAOLJAHR
     C                   Z-ADD     KYWAOLMONA    WAOLMONA
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOL
     C                   MOVEL(P)  WAOLUSER      WKUSER
     C                   Z-ADD     WAOLJDAT      WKJDAT
     C                   Z-ADD     WAOLJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOL
     C                   EXSR      EWAOL
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOLPLAT      DSWAOLPLAT
     C                   MOVEL(P)  WAOLWKNR      DSWAOLWKNR
     C                   MOVEL(P)  WAOLKSTC      DSWAOLKSTC
     C                   MOVEL(P)  WAOLKDGR      DSWAOLKDGR
     C                   MOVEL(P)  WAOLKDPL      DSWAOLKDPL
     C                   MOVEL(P)  WAOLKDNR      DSWAOLKDNR
     C                   MOVEL(P)  WAOLPRGR      DSWAOLPRGR
     C                   Z-ADD     WAOLJAHR      DSWAOLJAHR
     C                   Z-ADD     WAOLMONA      DSWAOLMONA
     C*
     C                   Z-ADD     WAOLPLMG      DSWAOLPLMG
     C                   Z-ADD     WAOLPLPR      DSWAOLPLPR
     C                   MOVEL(P)  WAOLPDIM      DSWAOLPDIM
     C                   Z-ADD     WAOLPLUM      DSWAOLPLUM
     C                   MOVEL(P)  WAOLWACD      DSWAOLWACD
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAOLPLAT                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOLWKNR                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAOLKSTC
     C                   MOVEL     *BLANK        TXWAOLKDGR
     C                   MOVEL     *BLANK        TXWAOLKDPL
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   MOVEL     *BLANK        TXWAOLPRGR
     C                   MOVEL     *BLANK        TXWAOLPDIM
     C*-------------------------------------------------------------------------
     C     DSWAOLPLAT    CASNE     *BLANK        PRWAOLPLAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOLWKNR    CASNE     *BLANK        PRWAOLWKNR
     C                   ENDCS
     C     DSWAOLKSTC    CASNE     *BLANK        PRWAOLKSTC
     C                   ENDCS
     C     DSWAOLKDGR    CASNE     *BLANK        PRWAOLKDGR
     C                   ENDCS
     C     DSWAOLKDPL    CASNE     *BLANK        PRWAOLKDPL
     C                   ENDCS
     C     DSWAOLKDNR    CASNE     *BLANK        PRWAOLKDNR
     C                   ENDCS
     C     DSWAOLPRGR    CASNE     *BLANK        PRWAOLPRGR
     C                   ENDCS
     C     DSWAOLPDIM    CASNE     *BLANK        PRWAOLPDIM
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOL01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOLPLMG'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOLPLMG'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     WAOLPLAT      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOLPLAT'  EXFLPOFLDN
     C     WAOLWKNR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOLWKNR'  EXFLPOFLDN
     C     WAOLKSTC      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOLKSTC'  EXFLPOFLDN
     C     WAOLPRGR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOLPRGR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOLPLMG'  EXFLPOFLDN
     C                   ENDSL
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
     C     C#LCK0        WHENEQ    *ON
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLPLAT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLWKNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLKSTC'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLKDGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLKDPL'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLPRGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLJAHR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOLMONA'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOLPLAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLPLAT'
     C                   EXSR      MCWAOLPLAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLWKNR'
     C                   EXSR      MCWAOLWKNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLKSTC'
     C                   EXSR      MCWAOLKSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLKDGR'
     C                   EXSR      MCWAOLKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLKDPL'
     C                   EXSR      MCWAOLKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLKDNR'
     C                   EXSR      MCWAOLKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLPRGR'
     C                   EXSR      MCWAOLPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLPDIM'
     C                   EXSR      MCWAOLPDIM
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOLWACD'
     C                   EXSR      MCWAOLWACD
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
     C     FLDNAM        WHENEQ    'DSWAOLPLAT'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLPLAT
     C     FLDNAM        WHENEQ    'DSWAOLWKNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLWKNR
     C     FLDNAM        WHENEQ    'DSWAOLKSTC'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLKSTC
     C     FLDNAM        WHENEQ    'DSWAOLKDGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLKDGR
     C     FLDNAM        WHENEQ    'DSWAOLKDPL'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLKDPL
     C     FLDNAM        WHENEQ    'DSWAOLKDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLKDNR
     C     FLDNAM        WHENEQ    'DSWAOLPRGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLPRGR
     C     FLDNAM        WHENEQ    'DSWAOLJAHR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLJAHR
     C     FLDNAM        WHENEQ    'DSWAOLMONA'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOLMONA
     C     FLDNAM        WHENEQ    'DSWAOLPLMG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOLPLMG
     C     FLDNAM        WHENEQ    'DSWAOLPLPR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOLPLPR
     C     FLDNAM        WHENEQ    'DSWAOLPDIM'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOLPDIM
     C     FLDNAM        WHENEQ    'DSWAOLPLUM'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOLPLUM
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAOLPLAT    KYWAOLPLAT
     C                   MOVEL(P)  DSWAOLWKNR    KYWAOLWKNR
     C                   MOVEL(P)  DSWAOLKSTC    KYWAOLKSTC
     C                   MOVEL(P)  DSWAOLKDGR    KYWAOLKDGR
     C                   MOVEL(P)  DSWAOLKDPL    KYWAOLKDPL
     C                   MOVEL(P)  DSWAOLKDNR    KYWAOLKDNR
     C                   MOVEL(P)  DSWAOLPRGR    KYWAOLPRGR
     C                   Z-ADD     DSWAOLJAHR    KYWAOLJAHR
     C                   Z-ADD     DSWAOLMONA    KYWAOLMONA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOL
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOLPLAT'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOLPLAT'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOL'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOL          TRMUDATA
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
     C***  PRÜFEN, OB WAOL-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOLPLAT    OFWAOLPLAT
     C                   MOVEL(P)  KYWAOLWKNR    OFWAOLWKNR
     C                   MOVEL(P)  KYWAOLKSTC    OFWAOLKSTC
     C                   MOVEL(P)  KYWAOLKDGR    OFWAOLKDGR
     C                   MOVEL(P)  KYWAOLKDPL    OFWAOLKDPL
     C                   MOVEL(P)  KYWAOLKDNR    OFWAOLKDNR
     C                   MOVEL(P)  KYWAOLPRGR    OFWAOLPRGR
     C                   Z-ADD     KYWAOLJAHR    OFWAOLJAHR
     C                   Z-ADD     KYWAOLMONA    OFWAOLMONA
     C     KYWAOLMONA    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFWAOLMONA
     C                   ENDIF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOL
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOLFIRM      ANDEQ     KYWAOLFIRM
     C     WAOLPLAT      ANDLE     OFWAOLPLAT
     C     WAOLWKNR      ANDLE     OFWAOLWKNR
     C     WAOLKSTC      ANDLE     OFWAOLKSTC
     C     WAOLKDGR      ANDLE     OFWAOLKDGR
     C     WAOLKDPL      ANDLE     OFWAOLKDPL
     C     WAOLKDNR      ANDLE     OFWAOLKDNR
     C     WAOLPRGR      ANDLE     OFWAOLPRGR
     C     WAOLJAHR      ANDLE     OFWAOLJAHR
     C     WAOLMONA      ANDLE     OFWAOLMONA
     C*--------------------------------------------------------
     C     WAOLLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOLLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOL
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOL
     C                   MOVEL(P)  WKPROG        RTWAOLPROG
     C                   MOVEL(P)  WKDANA        RTWAOLDANA
     C                   MOVEL(P)  WKFFLD        RTWAOLFFLD
     C                   MOVEL(P)  WKFENR        RTWAOLFENR
     C                   MOVEL(P)  W$PA03        RTWAOLPA03
     C                   MOVEL(P)  W$PA04        RTWAOLPA04
     C                   MOVEL(P)  W$PA05        RTWAOLPA05
     C                   MOVEL(P)  W$PA06        RTWAOLPA06
     C                   MOVEL(P)  W$PA07        RTWAOLPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOL                                          ***
     C**************************************************************************
     C     LWAOL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOLPLAT    OFWAOLPLAT
     C                   MOVEL(P)  KYWAOLWKNR    OFWAOLWKNR
     C                   MOVEL(P)  KYWAOLKSTC    OFWAOLKSTC
     C                   MOVEL(P)  KYWAOLKDGR    OFWAOLKDGR
     C                   MOVEL(P)  KYWAOLKDPL    OFWAOLKDPL
     C                   MOVEL(P)  KYWAOLKDNR    OFWAOLKDNR
     C                   MOVEL(P)  KYWAOLPRGR    OFWAOLPRGR
     C                   Z-ADD     KYWAOLJAHR    OFWAOLJAHR
     C                   Z-ADD     KYWAOLMONA    OFWAOLMONA
     C     KYWAOLMONA    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFWAOLMONA
     C                   ENDIF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOL
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOLFIRM      ANDEQ     KYWAOLFIRM
     C     WAOLPLAT      ANDLE     OFWAOLPLAT
     C     WAOLWKNR      ANDLE     OFWAOLWKNR
     C     WAOLKSTC      ANDLE     OFWAOLKSTC
     C     WAOLKDGR      ANDLE     OFWAOLKDGR
     C     WAOLKDPL      ANDLE     OFWAOLKDPL
     C     WAOLKDNR      ANDLE     OFWAOLKDNR
     C     WAOLPRGR      ANDLE     OFWAOLPRGR
     C     WAOLJAHR      ANDLE     OFWAOLJAHR
     C     WAOLMONA      ANDLE     OFWAOLMONA
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAOLPLAT      KYWAOLPLAT
     C                   MOVEL(P)  WAOLWKNR      KYWAOLWKNR
     C                   MOVEL(P)  WAOLKSTC      KYWAOLKSTC
     C                   MOVEL(P)  WAOLKDGR      KYWAOLKDGR
     C                   MOVEL(P)  WAOLKDPL      KYWAOLKDPL
     C                   MOVEL(P)  WAOLKDNR      KYWAOLKDNR
     C                   MOVEL(P)  WAOLPRGR      KYWAOLPRGR
     C                   Z-ADD     WAOLJAHR      KYWAOLJAHR
     C                   Z-ADD     WAOLMONA      KYWAOLMONA
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOL
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOL
     C                   MOVEL(P)  WKPROG        RTWAOLPROG
     C                   MOVEL(P)  WKDANA        RTWAOLDANA
     C                   MOVEL(P)  WKFFLD        RTWAOLFFLD
     C                   MOVEL(P)  WKFENR        RTWAOLFENR
     C                   MOVEL(P)  W$PA03        RTWAOLPA03
     C                   MOVEL(P)  W$PA04        RTWAOLPA04
     C                   MOVEL(P)  W$PA05        RTWAOLPA05
     C                   MOVEL(P)  W$PA06        RTWAOLPA06
     C                   MOVEL(P)  W$PA07        RTWAOLPA07
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
     C                   Z-ADD     EXWAOLPLMG    DSWAOLPLMG
     C                   Z-ADD     EXWAOLPLPR    DSWAOLPLPR
     C                   MOVEL     EXWAOLPDIM    DSWAOLPDIM
     C                   Z-ADD     EXWAOLPLUM    DSWAOLPLUM
     C                   MOVEL     EXWAOLWACD    DSWAOLWACD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXWAOLFLDN    WHENEQ    'WAOLPLMG'
     C                   EXSR      PRWAOLPLMG
     C     EXWAOLFLDN    WHENEQ    'WAOLPLPR'
     C                   EXSR      PRWAOLPLPR
     C     EXWAOLFLDN    WHENEQ    'WAOLPDIM'
     C                   EXSR      PRWAOLPDIM
     C     EXWAOLFLDN    WHENEQ    'WAOLPLUM'
     C                   EXSR      PRWAOLPLUM
     C     EXWAOLFLDN    WHENEQ    'WAOLWACD'
     C                   EXSR      PRWAOLWACD
     C                   OTHER
     C                   MOVEL     'TRWAOL01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOL
     C                   MOVEL(P)  WKPROG        RTWAOLPROG
     C                   MOVEL(P)  WKDANA        RTWAOLDANA
     C                   MOVEL(P)  WKFFLD        RTWAOLFFLD
     C                   MOVEL(P)  WKFENR        RTWAOLFENR
     C                   MOVEL(P)  W$PA03        RTWAOLPA03
     C                   MOVEL(P)  W$PA04        RTWAOLPA04
     C                   MOVEL(P)  W$PA05        RTWAOLPA05
     C                   MOVEL(P)  W$PA06        RTWAOLPA06
     C                   MOVEL(P)  W$PA07        RTWAOLPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAOLIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAOLPLAT    KYWAOLPLAT
     C                   MOVEL(P)  EXWAOLWKNR    KYWAOLWKNR
     C                   MOVEL(P)  EXWAOLKDGR    KYWAOLKDGR
     C                   MOVEL(P)  EXWAOLKDPL    KYWAOLKDPL
     C                   MOVEL(P)  EXWAOLKDNR    KYWAOLKDNR
     C                   MOVEL(P)  EXWAOLPRGR    KYWAOLPRGR
     C                   Z-ADD     EXWAOLJAHR    KYWAOLJAHR
     C                   Z-ADD     EXWAOLMONA    KYWAOLMONA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOL
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
     C     EXWAOLPLMG    IFNE      *ZERO
     C                   Z-ADD     EXWAOLPLMG    DSWAOLPLMG
     C                   ENDIF
     C*
     C     EXWAOLPLPR    IFNE      *ZERO
     C                   Z-ADD     EXWAOLPLPR    DSWAOLPLPR
     C                   ENDIF
     C*
     C     EXWAOLPDIM    IFNE      *BLANK
     C                   MOVEL     EXWAOLPDIM    DSWAOLPDIM
     C                   ENDIF
     C*
     C     EXWAOLPLUM    IFNE      *ZERO
     C                   Z-ADD     EXWAOLPLUM    DSWAOLPLUM
     C                   ENDIF
     C*
     C     EXWAOLWACD    IFNE      *BLANK
     C                   MOVEL     EXWAOLWACD    DSWAOLWACD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOL01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAOL
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOL
     C                   MOVEL(P)  WKPROG        RTWAOLPROG
     C                   MOVEL(P)  WKDANA        RTWAOLDANA
     C                   MOVEL(P)  WKFFLD        RTWAOLFFLD
     C                   MOVEL(P)  WKFENR        RTWAOLFENR
     C                   MOVEL(P)  W$PA03        RTWAOLPA03
     C                   MOVEL(P)  W$PA04        RTWAOLPA04
     C                   MOVEL(P)  W$PA05        RTWAOLPA05
     C                   MOVEL(P)  W$PA06        RTWAOLPA06
     C                   MOVEL(P)  W$PA07        RTWAOLPA07
     C*-------------------------------------------------------------------------
     C     K#WAOLLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOL                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOL                                                 ***
     C**************************************************************************
     C     UWAOL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOLPLAT    KYWAOLPLAT
     C                   MOVEL(P)  DSWAOLWKNR    KYWAOLWKNR
     C                   MOVEL(P)  DSWAOLKSTC    KYWAOLKSTC
     C                   MOVEL(P)  DSWAOLKDGR    KYWAOLKDGR
     C                   MOVEL(P)  DSWAOLKDPL    KYWAOLKDPL
     C                   MOVEL(P)  DSWAOLKDNR    KYWAOLKDNR
     C                   MOVEL(P)  DSWAOLPRGR    KYWAOLPRGR
     C                   Z-ADD     DSWAOLJAHR    KYWAOLJAHR
     C                   Z-ADD     DSWAOLMONA    KYWAOLMONA
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOLPLMG    WAOLPLMG
     C                   Z-ADD     DSWAOLPLPR    WAOLPLPR
     C                   MOVEL(P)  DSWAOLPDIM    WAOLPDIM
     C                   Z-ADD     DSWAOLPLUM    WAOLPLUM
     C                   MOVEL(P)  DSWAOLWACD    WAOLWACD
     C*--------------------------------------------------------
     C                   SELECT
     C     WAOLKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  '4'           WAOLPLKZ
     C     WAOLKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  '3'           WAOLPLKZ
     C     WAOLKDGR      WHENNE    *BLANK
     C                   MOVEL(P)  '2'           WAOLPLKZ
     C     WAOLKSTC      WHENNE    *BLANK
     C                   MOVEL(P)  '1'           WAOLPLKZ
     C                   ENDSL
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
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOL
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOL
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOL
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  PERIODEN-DEFINITION                                     ***
     C**************************************************************************
     C     MCWAOLPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOLPLAT    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOLPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'APAT'        KOM(02)
     C                   MOVEA     DSWAOLPLAT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLPLAT
     C                   MOVEL(P)  TPTTXT        TXWAOLPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PERIODEN-DEFINITION                                        ***
     C**************************************************************************
     C     PRWAOLPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPLAT'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOLPLAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APAT'        KYTPTA
     C                   MOVEL(P)  DSWAOLPLAT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLPLAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  WERKS-STAMM                                             ***
     C**************************************************************************
     C     MCWAOLWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOLWKNR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOLWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOLWKNR    KOM(01)
     C                   MOVE      'WERK01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCWERK
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  WRWKNR        DSWAOLWKNR
     C                   MOVEL(P)  WRWKBZ        TXWAOLWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WERKS-NR                                                   ***
     C**************************************************************************
     C     PRWAOLWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLWKNR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOLWKNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOLWKNR    KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXWAOLWKNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOLKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOLKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOLKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLKSTC
     C                   MOVEL(P)  TPTTXT        TXWAOLKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE                                     ***
     C**************************************************************************
     C     PRWAOLKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOLKSTC    IFNE      *BLANK
     C     DSWAOLKDGR    OREQ      *BLANK
     C     DSWAOLKDPL    ANDEQ     *BLANK
     C     DSWAOLKDNR    ANDEQ     *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOLKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOLKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOLKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOLKDGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLKDGR
     C                   MOVEL(P)  TPTTXT        TXWAOLKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE                                              ***
     C**************************************************************************
     C     PRWAOLKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOLKDGR
     C*-------------------------------------------------------------------------
     C     DSWAOLKDGR    IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOLKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOLKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOLKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOLKDPL    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLKDPL
     C                   MOVEL(P)  TPTTXT        TXWAOLKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG                                             ***
     C**************************************************************************
     C     PRWAOLKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOLKDPL
     C*-------------------------------------------------------------------------
     C     DSWAOLKDPL    IFNE      *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOLKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STAMM                                             ***
     C**************************************************************************
     C     MCWAOLKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOLKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOLKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR                                                  ***
     C**************************************************************************
     C     PRWAOLKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLKDNR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C     DSWAOLKDNR    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOLKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDKDNR        DSWAOLKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     KDEWPLKZ      IFNE      '4'
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C* Der Status des Datensatzes lässt eine Bearbeitung nicht zu
     C*--------------------------------------------------------
     C     KDKDST        IFGE      '90'
     C                   MOVE      '0009'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKTGRUPPEN                                           ***
     C**************************************************************************
     C     MCWAOLPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOLPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOLPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLPRGR
     C                   MOVEL(P)  TPTTXT        TXWAOLPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKTGRUPPE                                              ***
     C**************************************************************************
     C     PRWAOLPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPRGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOLPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLPRGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR                                                       ***
     C**************************************************************************
     C     PRWAOLJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOLJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MONAT                                                      ***
     C**************************************************************************
     C     PRWAOLMONA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLMONA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOLMONA    IFLE      *ZERO
     C     DSWAOLMONA    ORGT      12
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-MENGE                                                 ***
     C**************************************************************************
     C     PRWAOLPLMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPLMG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Eingabe Plan-Menge oder Plan-Umsatz
     C*-------------------------------------------------------------------------
     C     DSWAOLPLMG    IFEQ      *ZERO
     C     DSWAOLPLUM    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-PREIS                                                 ***
     C**************************************************************************
     C     PRWAOLPLPR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPLPR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOLPLPR    IFLE      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREISDIMENSION                                           ***
     C**************************************************************************
     C     MCWAOLPDIM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOLPDIM    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOLPDIM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSWAOLPDIM    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOLPDIM
     C                   MOVEL(P)  TPTTXT        TXWAOLPDIM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREISDIMENSION                                             ***
     C**************************************************************************
     C     PRWAOLPDIM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPDIM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSWAOLPDIM    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOLPDIM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-UMSATZ                                                ***
     C**************************************************************************
     C     PRWAOLPLUM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLPLMG'  EXFLPOFLDN
     C                   Z-ADD     *ZERO         DUN210
     C*-------------------------------------------------------------------------
     C* Berechnen Plan-Menge
     C*-------------------------------------------------------------------------
     C     DSWAOLPLMG    IFEQ      *ZERO
     C                   Z-ADD     1             I0
     C     DSWAOLPDIM    LOOKUP    SFLPDIM(I0)                            99
     C*
     C     *IN99         IFEQ      *ON
     C     SFLTNUM(I0)   ANDNE     *ZERO
     C     DSWAOLPLUM    MULT      SFLTNUM(I0)   DUN210
     C                   DIV(H)    DSWAOLPLPR    DUN210
     C                   ENDIF
     C*
     C                   Z-ADD(H)  DUN210        DSWAOLPLMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Berechnen Plan-Umsatz
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C     DSWAOLPDIM    LOOKUP    SFLPDIM(I0)                            99
     C*
     C     *IN99         IFEQ      *ON
     C     SFLTNUM(I0)   ANDNE     *ZERO
     C     DSWAOLPLMG    MULT      DSWAOLPLPR    DUN219
     C                   DIV(H)    SFLTNUM(I0)   DUN219
     C                   ENDIF
     C*
     C                   SELECT
     C     DSWAOLPLUM    WHENEQ    *ZERO
     C                   Z-ADD     DUN219        DSWAOLPLUM
     C     DSWAOLPLUM    WHENNE    DUN219
     C                   MOVE      '0031'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  WÄHRUNGS-STAMM                                          ***
     C**************************************************************************
     C     MCWAOLWACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOLWACD    KOM(1)
     C                   MOVE      'DETAIL'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCWACD
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  WCWACD        DSWAOLWACD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WÄHRUNG                                                    ***
     C**************************************************************************
     C     PRWAOLWACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOLWACD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOLWACD    IFNE      *BLANK
     C     DSWAOLPLUM    ORNE      *ZERO
     C                   MOVEA(P)  DSWAOLWACD    KOM(1)
     C                   EXSR      PRWACDWACD
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
     C                   MOVEL(P)  'WAOL'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOL
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOL'        EXDATAFILE
     C                   MOVEL(P)  WAOL          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOL         BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  'TRWAOL'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Preisdimension aus Anwendungs-Code
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRTPPDIM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PREISDIMENSION AUS ANWENDUNGS-CODE                      ***
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
     C                   MOVEL(P)  'TRWAOL'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
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
     C     EXTRDNDANA    WHENEQ    'XXXX'
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
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        TXWAOLPDIM     + 39
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
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOLPLAT    OFWAOLPLAT
     C     *LIKE         DEFINE    KYWAOLWKNR    OFWAOLWKNR
     C     *LIKE         DEFINE    KYWAOLKSTC    OFWAOLKSTC
     C     *LIKE         DEFINE    KYWAOLKDGR    OFWAOLKDGR
     C     *LIKE         DEFINE    KYWAOLKDPL    OFWAOLKDPL
     C     *LIKE         DEFINE    KYWAOLKDNR    OFWAOLKDNR
     C     *LIKE         DEFINE    KYWAOLPRGR    OFWAOLPRGR
     C     *LIKE         DEFINE    KYWAOLJAHR    OFWAOLJAHR
     C     *LIKE         DEFINE    KYWAOLMONA    OFWAOLMONA
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOLPLPR      DSWAOLPLPR
     C     *LIKE         DEFINE    WAOLPDIM      DSWAOLPDIM
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOLPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOLDANA    WKDANA
     C     *LIKE         DEFINE    RTWAOLFFLD    WKFFLD
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
     C                   MOVEL(P)  'TRWAOL'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOLCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOLCT
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
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOL
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCWACD
     C/COPY QCPYSRC,MCWERK
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRWACDWACD
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
