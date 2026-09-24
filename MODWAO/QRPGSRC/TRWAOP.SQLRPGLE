     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOP
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 15.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 11.06.2012 Projekt 8559, Artikel statt Produktgruppe
     H*  Änderung: MG 21.08.2012 Projekt 8751, Satzberechtigung (TRSB)
     H*  Änderung: MG 26.11.2012 Projekt 9103  Vereinfachte Möglichkeit der Veränderung %-Sätze
     H*            Erweiterung der Datei WAOM um die Felder WAOMLDNR, WAOMSTKD
     H*            Neuverteilung der Plan-Werte bei Änderung %-Sätze (#CPGST='UWAOM ')
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOP.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOPFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D SFLPZ           S                   DIM(12) INZ LIKE(WAOMPZ01)
     D*
     D SFLMG           S                   DIM(12) INZ LIKE(WAOPPLMG)
     D SFLUM           S                   DIM(12) INZ LIKE(WAOPPLUM)
     D SFLER           S                   DIM(12) INZ LIKE(WAOPERTR)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')
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
     D LAND          E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
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
     D WAOM          E DS                  INZ
     D KYWAOM        E DS                  INZ
     D*
     D WAOP          E DS                  INZ
     D KYWAOP        E DS                  INZ
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
     D EXTRSB        E DS
     D EXTRSBPTR§      S               *
     D RTTRSB        E DS
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXWAOP        E DS
     D RTWAOP        E DS
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
     C                   PARM                    EXWAOP
     C                   PARM                    RTWAOP
     C*
     C                   EXSR      UEBWAOP
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
     C                   CLOSE     TRWAOPFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BILD02'
     C                   MOVE      '2     '      PCPGST
     C                   EXSR      B01DS
     C*
     C                   MOVE      '02'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UWAOM '
     C                   EXSR      KEYWAOP
     C                   EXSR      OWAOP
     C                   EXSR      VWAOP
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOP '
     C                   EXSR      PWAOP
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOP
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOP
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAOPIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOP                                       UPDATE
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
     C                   OPEN      TRWAOPFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRWAOPFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOPRTCD
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
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM                     WAOM
     C                   MOVEL(P)  DAFIRM        KYWAOPFIRM                     WAOP
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOPFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOPFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST = 'SQL'
     C                   EVAL      EXTRSBFILE = 'KDEW'
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C*--------------------------------------------------------
     C                   MOVEL(P)  RTTRSBSQST    RTTRSBKDEW
     C*-------------------------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST = 'SQL'
     C                   EVAL      EXTRSBFILE = 'KUND'
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C*--------------------------------------------------------
     C                   MOVEL(P)  RTTRSBSQST    RTTRSBKUND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXWAOP                         ***
     C**************************************************************************
     C     UEBWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXWAOP'      EXDATAFILE
     C                   MOVEL(P)  EXWAOP        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXWAOP
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXWAOPPGST    PCPGST
     C*
     C                   MOVEL(P)  EXWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  EXWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  EXWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  EXWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  EXWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  EXWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  EXWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  EXWAOPTENR    KYWAOPTENR
     C                   Z-ADD     EXWAOPJAHR    KYWAOPJAHR
     C*
     C                   MOVEL(P)  EXWAOPPLAT    DSWAOPPLAT
     C                   MOVEL(P)  EXWAOPWKNR    DSWAOPWKNR
     C                   MOVEL(P)  EXWAOPKSTC    DSWAOPKSTC
     C                   MOVEL(P)  EXWAOPKDGR    DSWAOPKDGR
     C                   MOVEL(P)  EXWAOPKDPL    DSWAOPKDPL
     C                   MOVEL(P)  EXWAOPKDNR    DSWAOPKDNR
     C                   MOVEL(P)  EXWAOPLDNR    DSWAOPLDNR
     C                   MOVEL(P)  EXWAOPTENR    DSWAOPTENR
     C                   Z-ADD     EXWAOPJAHR    DSWAOPJAHR
     C*
     C                   MOVEL(P)  EXWAOPKSST    DSKDEWKSST
     C                   MOVEL(P)  EXWAOPGEBT    DSLANDGEBT
     C                   MOVEL(P)  EXWAOPPRGR    DSTEILPRGR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOP
     C                   MOVEL     *ZERO         RTWAOPFENR
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
     C                   MOVEL(P)  'TRWAOP'      EXTRDNDANA
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
     C                   MOVEL     'TRWAOP01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOP01
     C                   WRITE     TRWAOPB1
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
     C                   READ      TRWAOP01                             9899
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
     C                   EXSR      UWAOP
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  EXWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  EXWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  EXWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  EXWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  EXWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  EXWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  EXWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  EXWAOPTENR    KYWAOPTENR
     C                   Z-ADD     EXWAOPJAHR    KYWAOPJAHR
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOP
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOP
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
     C                   CLEAR                   WAOP
     C                   EXSR      ETRMU
     C                   EXSR      EWAOP
     C                   MOVEL(P)  KYWAOPPLAT    WAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    WAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    WAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    WAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    WAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    WAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    WAOPLDNR
     C                   MOVEL(P)  KYWAOPTENR    WAOPTENR
     C                   Z-ADD     KYWAOPJAHR    WAOPJAHR
     C*
     C                   MOVEL(P)  EXFIRMWACD    WAOPWACD
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOP
     C                   MOVEL(P)  WAOPUSER      WKUSER
     C                   Z-ADD     WAOPJDAT      WKJDAT
     C                   Z-ADD     WAOPJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOP
     C                   EXSR      EWAOP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOPPLAT      DSWAOPPLAT
     C                   MOVEL(P)  WAOPWKNR      DSWAOPWKNR
     C                   MOVEL(P)  WAOPKSTC      DSWAOPKSTC
     C                   MOVEL(P)  WAOPKDGR      DSWAOPKDGR
     C                   MOVEL(P)  WAOPKDPL      DSWAOPKDPL
     C                   MOVEL(P)  WAOPKDNR      DSWAOPKDNR
     C                   MOVEL(P)  WAOPLDNR      DSWAOPLDNR
     C                   MOVEL(P)  WAOPTENR      DSWAOPTENR
     C                   Z-ADD     WAOPJAHR      DSWAOPJAHR
     C*
     C                   Z-ADD     WAOPPLMG      DSWAOPPLMG
     C                   Z-ADD     WAOPPLUM      DSWAOPPLUM
     C                   Z-ADD     WAOPSTPR      DSWAOPSTPR
     C                   MOVEL(P)  WAOPPDAV      DSWAOPPDAV
     C                   Z-ADD     WAOPERTR      DSWAOPERTR
     C                   Z-ADD     WAOPMG01      DSWAOPMG01
     C                   Z-ADD     WAOPMG02      DSWAOPMG02
     C                   Z-ADD     WAOPMG03      DSWAOPMG03
     C                   Z-ADD     WAOPMG04      DSWAOPMG04
     C                   Z-ADD     WAOPMG05      DSWAOPMG05
     C                   Z-ADD     WAOPMG06      DSWAOPMG06
     C                   Z-ADD     WAOPMG07      DSWAOPMG07
     C                   Z-ADD     WAOPMG08      DSWAOPMG08
     C                   Z-ADD     WAOPMG09      DSWAOPMG09
     C                   Z-ADD     WAOPMG10      DSWAOPMG10
     C                   Z-ADD     WAOPMG11      DSWAOPMG11
     C                   Z-ADD     WAOPMG12      DSWAOPMG12
     C                   Z-ADD     WAOPUM01      DSWAOPUM01
     C                   Z-ADD     WAOPUM02      DSWAOPUM02
     C                   Z-ADD     WAOPUM03      DSWAOPUM03
     C                   Z-ADD     WAOPUM04      DSWAOPUM04
     C                   Z-ADD     WAOPUM05      DSWAOPUM05
     C                   Z-ADD     WAOPUM06      DSWAOPUM06
     C                   Z-ADD     WAOPUM07      DSWAOPUM07
     C                   Z-ADD     WAOPUM08      DSWAOPUM08
     C                   Z-ADD     WAOPUM09      DSWAOPUM09
     C                   Z-ADD     WAOPUM10      DSWAOPUM10
     C                   Z-ADD     WAOPUM11      DSWAOPUM11
     C                   Z-ADD     WAOPUM12      DSWAOPUM12
     C                   Z-ADD     WAOPER01      DSWAOPER01
     C                   Z-ADD     WAOPER02      DSWAOPER02
     C                   Z-ADD     WAOPER03      DSWAOPER03
     C                   Z-ADD     WAOPER04      DSWAOPER04
     C                   Z-ADD     WAOPER05      DSWAOPER05
     C                   Z-ADD     WAOPER06      DSWAOPER06
     C                   Z-ADD     WAOPER07      DSWAOPER07
     C                   Z-ADD     WAOPER08      DSWAOPER08
     C                   Z-ADD     WAOPER09      DSWAOPER09
     C                   Z-ADD     WAOPER10      DSWAOPER10
     C                   Z-ADD     WAOPER11      DSWAOPER11
     C                   Z-ADD     WAOPER12      DSWAOPER12
     C                   MOVEL(P)  WAOPWACD      DSWAOPWACD
     C                   MOVEL(P)  WAOPSTKD      DSWAOPSTKD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOPPLMG      DHWAOPPLMG                     SPEICHERN
     C                   Z-ADD     WAOPPLUM      DHWAOPPLUM                     DATENSATZ
     C                   Z-ADD     WAOPSTPR      DHWAOPSTPR
     C                   MOVEL(P)  WAOPPDAV      DHWAOPPDAV
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAOPPLAT                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOPWKNR                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAOPKSTC
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   MOVEL     *BLANK        DSTEILTBZ1
     C                   MOVEL     *BLANK        DSTEILTBZ2
     C                   MOVEL     *BLANK        TXWAOPLDNR
     C                   MOVEL     *BLANK        TXWAOPPDAV
     C*-------------------------------------------------------------------------
     C     EXWAOPIFKZ    IFEQ      *BLANK
     C     DSWAOPPLAT    CASNE     *BLANK        PRWAOPPLAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOPWKNR    CASNE     *BLANK        PRWAOPWKNR
     C                   ENDCS
     C     DSWAOPKSTC    CASNE     *BLANK        PRWAOPKSTC
     C                   ENDCS
     C     DSWAOPKDGR    CASNE     *BLANK        PRWAOPKDGR
     C                   ENDCS
     C     DSWAOPKDPL    CASNE     *BLANK        PRWAOPKDPL
     C                   ENDCS
     C     DSWAOPKDNR    CASNE     *BLANK        PRWAOPKDNR
     C                   ENDCS
     C     DSWAOPLDNR    CASNE     *BLANK        PRWAOPLDNR
     C                   ENDCS
     C     DSWAOPTENR    CASNE     *BLANK        PRWAOPTENR
     C                   ENDCS
     C     DSWAOPPDAV    CASNE     *BLANK        PRWAOPPDAV
     C                   ENDCS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOP01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOPPLMG'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOPPLMG'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     WAOPPLAT      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C     WAOPWKNR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPWKNR'  EXFLPOFLDN
     C     WAOPKDPL      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPKDPL'  EXFLPOFLDN
     C     WAOPTENR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPTENR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOPPLMG'  EXFLPOFLDN
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
     C***  STEUERROUTINE BILD02                                              ***
     C**************************************************************************
     C     BILD02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B02DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '02'
     C                   MOVEL     'TRWAOP02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOPW3
     C                   WRITE     TRWAOP02
     C                   WRITE     W3WAOPB1
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
     C                   READ      TRWAOP02                             9899
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
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UWAOP
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
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
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C* Berechnen Mengen-Erhöhung
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPMG01
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOPMG01'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C                   ENDSL
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
     C                   MOVEL     'TRWAOPK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOPW3
     C                   WRITE     TRWAOPK1
     C                   WRITE     W3WAOPB1
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
     C                   READ      TRWAOPK1                             9899
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
     C                   EXSR      KWAOP
     C*                  EXSR      UWAOP
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAOPPLAT    RTWAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    RTWAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    RTWAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    RTWAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    RTWAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    RTWAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    RTWAOPLDNR
     C                   MOVEL(P)  KYWAOPTENR    RTWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    RTWAOPJAHR
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOPRTCD
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
     C                   MOVEL(P)  KYWAOPPLAT    DSWAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    DSWAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    DSWAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    DSWAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    DSWAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    DSWAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    DSWAOPLDNR
     C                   MOVE      *BLANK        DSTEILPRGR
     C                   MOVEL(P)  KYWAOPTENR    DSWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    DSWAOPJAHR
     C*
     C                   MOVE      *BLANK        DSWAOPNPLA
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPNPLA'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAOPPLAT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPWKNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPKSTC'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPKDGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPKDPL'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPLDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPTENR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOPJAHR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPPLAT'
     C                   EXSR      MCWAOPPLAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPWKNR'
     C                   EXSR      MCWAOPWKNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKSTC'
     C                   EXSR      MCWAOPKSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDGR'
     C                   EXSR      MCWAOPKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDPL'
     C                   EXSR      MCWAOPKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDNR'
     C                   EXSR      MCWAOPKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPLDNR'
     C                   EXSR      MCWAOPLDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEILPRGR'
     C                   EXSR      MCTEILPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPTENR'
     C                   EXSR      MCWAOPTENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPPDAV'
     C                   EXSR      MCWAOPPDAV
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPWACD'
     C                   EXSR      MCWAOPWACD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPNPLA'
     C                   EXSR      MCWAOPNPLA
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
     C     FLDNAM        WHENEQ    'DSWAOPPLAT'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPPLAT
     C     FLDNAM        WHENEQ    'DSWAOPWKNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPWKNR
     C     FLDNAM        WHENEQ    'DSWAOPKSTC'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPKSTC
     C     FLDNAM        WHENEQ    'DSWAOPKDGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPKDGR
     C     FLDNAM        WHENEQ    'DSWAOPKDPL'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPKDPL
     C     FLDNAM        WHENEQ    'DSWAOPKDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPKDNR
     C     FLDNAM        WHENEQ    'DSWAOPLDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPLDNR
     C     FLDNAM        WHENEQ    'DSWAOPTENR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPTENR
     C     FLDNAM        WHENEQ    'DSWAOPJAHR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOPJAHR
     C     FLDNAM        WHENEQ    'DSWAOPPLMG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOPPLMG
     C     FLDNAM        WHENEQ    'DSWAOPPLUM'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOPPLUM
     C     FLDNAM        WHENEQ    'DSWAOPSTPR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOPSTPR
     C     FLDNAM        WHENEQ    'DSWAOPPDAV'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOPPDAV
     C     FLDNAM        WHENEQ    'DSWAOPMG01'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOPMG01
     C     FLDNAM        WHENEQ    'DSTEILPRGR'
     C                   EXSR      PRTEILPRGR
     C     FLDNAM        WHENEQ    'DSWAOPNPLA'
     C                   EXSR      PRWAOPNPLA
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
     C     PCPGST        WHENEQ    '3     '
     C                   MOVEL(P)  DSWAOPNPLA    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOP
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOPNPLA'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOP
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDSL
     C*----------------------------------------------------------
     C* Ermitteln KD-Nr Statistik aus Kunden-Stamm
     C*----------------------------------------------------------
     C     PCPGST        IFEQ      *BLANK
     C                   EXSR      EKDEW
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
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
     C                   MOVEL(P)  'WAOP'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOP          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAOP                                     ***
     C**************************************************************************
     C     KWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOP
     C                   EXSR      OWAOP
     C                   EXSR      VWAOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAOP                                                ***
     C**************************************************************************
     C     KEYWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             ' SELECT * FROM WAOP '  +
     C                             ' WHERE WAOPFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        DSWAOPPLAT <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPPLAT) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPPLAT = ''' + DSWAOPPLAT + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPPLAT) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPPLAT)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPWKNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPWKNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPWKNR = ''' + DSWAOPWKNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPWKNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPWKNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSKDEWKSST <> *BLANK OR RTTRSBKDEW <> ' '
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             ' WHERE  KDEW.KDEWFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KDEW.KDEWKDNR=WAOP.WAOPSTKD '
     C*
     C                   IF        RTTRSBKDEW <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                                      ' ' + %TRIM(RTTRSBKDEW)
     C                   ENDIF
     C*
     C                   IF        DSKDEWKSST <> *BLANK
     C                   IF        %SCAN(WCTRD:DSKDEWKSST) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKSST = ''' + DSKDEWKSST + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KDEW.KDEWKSST) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSKDEWKSST)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOPKSTC <> *BLANK OR DSWAOPKDGR <> *BLANK
     C                                                  OR RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOP.WAOPSTKD '
     C*
     C                   IF        RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                                      ' ' + %TRIM(RTTRSBKUND)
     C                   ENDIF
     C*
     C                   IF        DSWAOPKSTC <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKSTC) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKSTC = ''' + DSWAOPKSTC + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKSTC) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKSTC)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDGR = ''' + DSWAOPKDGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKDGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDPL <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDPL) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDPL = ''' + DSWAOPKDPL + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPKDPL) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDPL)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDNR = ''' + DSWAOPKDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPKDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSLANDGEBT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT LNGEBT FROM LAND ' +
     C                             ' WHERE  LAND.LNLDNR=WAOP.WAOPLDNR '
     C*
     C                   IF        %SCAN(WCTRD:DSLANDGEBT) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND LAND.LNGEBT = ''' + DSLANDGEBT + ''')'
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(LAND.LNGEBT) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSLANDGEBT))+ ''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPLDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPLDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPLDNR = ''' + DSWAOPLDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPLDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPLDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSTEILPRGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSTEILPRGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TEIL.TEPRGR = ''' + DSTEILPRGR + ''')'
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TRIM(TEIL.TEPRGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSTEILPRGR)) +''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPTENR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPTENR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPTENR = ''' + DSWAOPTENR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPTENR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPTENR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPJAHR = ' + %CHAR(DSWAOPJAHR)
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOPC1                                             ***
     C**************************************************************************
     C     OWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOP   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOPC1 SCROLL CURSOR FOR SQWAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN CURSOR WAOPC1                                         ***
     C**************************************************************************
     C     VWAOP         BEGSR
     C*
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM WAOPC1 INTO :WAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UWAOM '
     C                   CLEAR                   EXWAOP
     C                   MOVEL     *OFF          EXWAOPIFKZ
     C                   MOVEL     PCPGST        EXWAOPPGST
     C                   MOVEL     WAOPPLAT      EXWAOPPLAT
     C                   MOVEL     WAOPWKNR      EXWAOPWKNR
     C                   MOVEL     WAOPKSTC      EXWAOPKSTC
     C                   MOVEL     WAOPKDGR      EXWAOPKDGR
     C                   MOVEL     WAOPKDPL      EXWAOPKDPL
     C                   MOVEL     WAOPKDNR      EXWAOPKDNR
     C                   MOVEL     WAOPLDNR      EXWAOPLDNR
     C                   MOVEL     WAOPTENR      EXWAOPTENR
     C                   Z-ADD     WAOPJAHR      EXWAOPJAHR
     C*
     C                   EXSR      IFWAOP
     C                   MOVEL     EXWAOPPGST    PCPGST
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVEL(P)  WAOPPLAT      DSWAOPPLAT
     C                   MOVEL(P)  WAOPWKNR      DSWAOPWKNR
     C                   MOVEL(P)  WAOPKSTC      DSWAOPKSTC
     C                   MOVEL(P)  WAOPKDGR      DSWAOPKDGR
     C                   MOVEL(P)  WAOPKDPL      DSWAOPKDPL
     C                   MOVEL(P)  WAOPKDNR      DSWAOPKDNR
     C                   MOVEL(P)  WAOPLDNR      DSWAOPLDNR
     C                   MOVEL(P)  WAOPTENR      DSWAOPTENR
     C                   Z-ADD     WAOPJAHR      DSWAOPJAHR
     C*
     C                   Z-ADD     WAOPPLMG      DSWAOPPLMG
     C                   Z-ADD     WAOPPLUM      DSWAOPPLUM
     C                   Z-ADD     WAOPSTPR      DSWAOPSTPR
     C                   MOVEL(P)  WAOPPDAV      DSWAOPPDAV
     C                   Z-ADD     WAOPERTR      DSWAOPERTR
     C                   Z-ADD     WAOPMG01      DSWAOPMG01
     C                   Z-ADD     WAOPMG02      DSWAOPMG02
     C                   Z-ADD     WAOPMG03      DSWAOPMG03
     C                   Z-ADD     WAOPMG04      DSWAOPMG04
     C                   Z-ADD     WAOPMG05      DSWAOPMG05
     C                   Z-ADD     WAOPMG06      DSWAOPMG06
     C                   Z-ADD     WAOPMG07      DSWAOPMG07
     C                   Z-ADD     WAOPMG08      DSWAOPMG08
     C                   Z-ADD     WAOPMG09      DSWAOPMG09
     C                   Z-ADD     WAOPMG10      DSWAOPMG10
     C                   Z-ADD     WAOPMG11      DSWAOPMG11
     C                   Z-ADD     WAOPMG12      DSWAOPMG12
     C                   Z-ADD     WAOPUM01      DSWAOPUM01
     C                   Z-ADD     WAOPUM02      DSWAOPUM02
     C                   Z-ADD     WAOPUM03      DSWAOPUM03
     C                   Z-ADD     WAOPUM04      DSWAOPUM04
     C                   Z-ADD     WAOPUM05      DSWAOPUM05
     C                   Z-ADD     WAOPUM06      DSWAOPUM06
     C                   Z-ADD     WAOPUM07      DSWAOPUM07
     C                   Z-ADD     WAOPUM08      DSWAOPUM08
     C                   Z-ADD     WAOPUM09      DSWAOPUM09
     C                   Z-ADD     WAOPUM10      DSWAOPUM10
     C                   Z-ADD     WAOPUM11      DSWAOPUM11
     C                   Z-ADD     WAOPUM12      DSWAOPUM12
     C                   Z-ADD     WAOPER01      DSWAOPER01
     C                   Z-ADD     WAOPER02      DSWAOPER02
     C                   Z-ADD     WAOPER03      DSWAOPER03
     C                   Z-ADD     WAOPER04      DSWAOPER04
     C                   Z-ADD     WAOPER05      DSWAOPER05
     C                   Z-ADD     WAOPER06      DSWAOPER06
     C                   Z-ADD     WAOPER07      DSWAOPER07
     C                   Z-ADD     WAOPER08      DSWAOPER08
     C                   Z-ADD     WAOPER09      DSWAOPER09
     C                   Z-ADD     WAOPER10      DSWAOPER10
     C                   Z-ADD     WAOPER11      DSWAOPER11
     C                   Z-ADD     WAOPER12      DSWAOPER12
     C                   MOVEL(P)  WAOPWACD      DSWAOPWACD
     C                   MOVEL(P)  WAOPSTKD      DSWAOPSTKD
     C*
     C                   EXSR      UWAOP
     C*--------------------------------------------------------
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOP-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOPPLAT    OFWAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    OFWAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    OFWAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    OFWAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    OFWAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    OFWAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    OFWAOPLDNR
     C                   MOVEL(P)  KYWAOPTENR    OFWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    OFWAOPJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOPFIRM      ANDEQ     KYWAOPFIRM
     C     WAOPPLAT      ANDLE     OFWAOPPLAT
     C     WAOPWKNR      ANDLE     OFWAOPWKNR
     C     WAOPKSTC      ANDLE     OFWAOPKSTC
     C     WAOPKDGR      ANDLE     OFWAOPKDGR
     C     WAOPKDPL      ANDLE     OFWAOPKDPL
     C     WAOPKDNR      ANDLE     OFWAOPKDNR
     C     WAOPLDNR      ANDLE     OFWAOPLDNR
     C     WAOPTENR      ANDLE     OFWAOPTENR
     C     WAOPJAHR      ANDLE     OFWAOPJAHR
     C*--------------------------------------------------------
     C     WAOPLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOPLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOP
     C                   MOVEL(P)  WKPROG        RTWAOPPROG
     C                   MOVEL(P)  WKDANA        RTWAOPDANA
     C                   MOVEL(P)  WKFFLD        RTWAOPFFLD
     C                   MOVEL(P)  WKFENR        RTWAOPFENR
     C                   MOVEL(P)  W$PA03        RTWAOPPA03
     C                   MOVEL(P)  W$PA04        RTWAOPPA04
     C                   MOVEL(P)  W$PA05        RTWAOPPA05
     C                   MOVEL(P)  W$PA06        RTWAOPPA06
     C                   MOVEL(P)  W$PA07        RTWAOPPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOP                                          ***
     C**************************************************************************
     C     LWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOPPLAT    OFWAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    OFWAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    OFWAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    OFWAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    OFWAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    OFWAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    OFWAOPLDNR
     C                   MOVEL(P)  KYWAOPTENR    OFWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    OFWAOPJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOPFIRM      ANDEQ     KYWAOPFIRM
     C     WAOPPLAT      ANDLE     OFWAOPPLAT
     C     WAOPWKNR      ANDLE     OFWAOPWKNR
     C     WAOPKSTC      ANDLE     OFWAOPKSTC
     C     WAOPKDGR      ANDLE     OFWAOPKDGR
     C     WAOPKDPL      ANDLE     OFWAOPKDPL
     C     WAOPKDNR      ANDLE     OFWAOPKDNR
     C     WAOPLDNR      ANDLE     OFWAOPLDNR
     C     WAOPTENR      ANDLE     OFWAOPTENR
     C     WAOPJAHR      ANDLE     OFWAOPJAHR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAOPPLAT      KYWAOPPLAT
     C                   MOVEL(P)  WAOPWKNR      KYWAOPWKNR
     C                   MOVEL(P)  WAOPKSTC      KYWAOPKSTC
     C                   MOVEL(P)  WAOPKDGR      KYWAOPKDGR
     C                   MOVEL(P)  WAOPKDPL      KYWAOPKDPL
     C                   MOVEL(P)  WAOPKDNR      KYWAOPKDNR
     C                   MOVEL(P)  WAOPLDNR      KYWAOPLDNR
     C                   MOVEL(P)  WAOPTENR      KYWAOPTENR
     C                   Z-ADD     WAOPJAHR      KYWAOPJAHR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOP
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOP
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOP
     C                   MOVEL(P)  WKPROG        RTWAOPPROG
     C                   MOVEL(P)  WKDANA        RTWAOPDANA
     C                   MOVEL(P)  WKFFLD        RTWAOPFFLD
     C                   MOVEL(P)  WKFENR        RTWAOPFENR
     C                   MOVEL(P)  W$PA03        RTWAOPPA03
     C                   MOVEL(P)  W$PA04        RTWAOPPA04
     C                   MOVEL(P)  W$PA05        RTWAOPPA05
     C                   MOVEL(P)  W$PA06        RTWAOPPA06
     C                   MOVEL(P)  W$PA07        RTWAOPPA07
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
     C                   Z-ADD     EXWAOPPLMG    DSWAOPPLMG
     C                   Z-ADD     EXWAOPPLUM    DSWAOPPLUM
     C                   Z-ADD     EXWAOPSTPR    DSWAOPSTPR
     C                   MOVEL(P)  EXWAOPPDAV    DSWAOPPDAV
     C                   Z-ADD     EXWAOPERTR    DSWAOPERTR
     C                   Z-ADD     EXWAOPMG01    DSWAOPMG01
     C                   Z-ADD     EXWAOPMG02    DSWAOPMG02
     C                   Z-ADD     EXWAOPMG03    DSWAOPMG03
     C                   Z-ADD     EXWAOPMG04    DSWAOPMG04
     C                   Z-ADD     EXWAOPMG05    DSWAOPMG05
     C                   Z-ADD     EXWAOPMG06    DSWAOPMG06
     C                   Z-ADD     EXWAOPMG07    DSWAOPMG07
     C                   Z-ADD     EXWAOPMG08    DSWAOPMG08
     C                   Z-ADD     EXWAOPMG09    DSWAOPMG09
     C                   Z-ADD     EXWAOPMG10    DSWAOPMG10
     C                   Z-ADD     EXWAOPMG11    DSWAOPMG11
     C                   Z-ADD     EXWAOPMG12    DSWAOPMG12
     C                   Z-ADD     EXWAOPUM01    DSWAOPUM01
     C                   Z-ADD     EXWAOPUM02    DSWAOPUM02
     C                   Z-ADD     EXWAOPUM03    DSWAOPUM03
     C                   Z-ADD     EXWAOPUM04    DSWAOPUM04
     C                   Z-ADD     EXWAOPUM05    DSWAOPUM05
     C                   Z-ADD     EXWAOPUM06    DSWAOPUM06
     C                   Z-ADD     EXWAOPUM07    DSWAOPUM07
     C                   Z-ADD     EXWAOPUM08    DSWAOPUM08
     C                   Z-ADD     EXWAOPUM09    DSWAOPUM09
     C                   Z-ADD     EXWAOPUM10    DSWAOPUM10
     C                   Z-ADD     EXWAOPUM11    DSWAOPUM11
     C                   Z-ADD     EXWAOPUM12    DSWAOPUM12
     C                   Z-ADD     EXWAOPER01    DSWAOPER01
     C                   Z-ADD     EXWAOPER02    DSWAOPER02
     C                   Z-ADD     EXWAOPER03    DSWAOPER03
     C                   Z-ADD     EXWAOPER04    DSWAOPER04
     C                   Z-ADD     EXWAOPER05    DSWAOPER05
     C                   Z-ADD     EXWAOPER06    DSWAOPER06
     C                   Z-ADD     EXWAOPER07    DSWAOPER07
     C                   Z-ADD     EXWAOPER08    DSWAOPER08
     C                   Z-ADD     EXWAOPER09    DSWAOPER09
     C                   Z-ADD     EXWAOPER10    DSWAOPER10
     C                   Z-ADD     EXWAOPER11    DSWAOPER11
     C                   Z-ADD     EXWAOPER12    DSWAOPER12
     C                   MOVEL     EXWAOPWACD    DSWAOPWACD
     C                   MOVEL     EXWAOPSTKD    DSWAOPSTKD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXWAOPFLDN    WHENEQ    'WAOPPLMG'
     C                   EXSR      PRWAOPPLMG
     C     EXWAOPFLDN    WHENEQ    'WAOPPLUM'
     C                   EXSR      PRWAOPPLUM
     C     EXWAOPFLDN    WHENEQ    'WAOPSTPR'
     C                   EXSR      PRWAOPSTPR
     C     EXWAOPFLDN    WHENEQ    'WAOPPDAV'
     C                   EXSR      PRWAOPPDAV
     C     EXWAOPFLDN    WHENEQ    'WAOPERTR'
     C                   EXSR      PRWAOPERTR
     C     EXWAOPFLDN    WHENEQ    'WAOPWACD'
     C                   EXSR      PRWAOPWACD
     C                   OTHER
     C                   MOVEL     'TRWAOP01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOP
     C                   MOVEL(P)  WKPROG        RTWAOPPROG
     C                   MOVEL(P)  WKDANA        RTWAOPDANA
     C                   MOVEL(P)  WKFFLD        RTWAOPFFLD
     C                   MOVEL(P)  WKFENR        RTWAOPFENR
     C                   MOVEL(P)  W$PA03        RTWAOPPA03
     C                   MOVEL(P)  W$PA04        RTWAOPPA04
     C                   MOVEL(P)  W$PA05        RTWAOPPA05
     C                   MOVEL(P)  W$PA06        RTWAOPPA06
     C                   MOVEL(P)  W$PA07        RTWAOPPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAOPIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  EXWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  EXWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  EXWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  EXWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  EXWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  EXWAOPTENR    KYWAOPTENR
     C                   Z-ADD     EXWAOPJAHR    KYWAOPJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOP
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
     C     EXWAOPPLMG    IFNE      *ZERO
     C                   Z-ADD     EXWAOPPLMG    DSWAOPPLMG
     C                   ENDIF
     C*
     C     EXWAOPPLUM    IFNE      *ZERO
     C                   Z-ADD     EXWAOPPLUM    DSWAOPPLUM
     C                   ENDIF
     C*
     C     EXWAOPSTPR    IFNE      *ZERO
     C                   Z-ADD     EXWAOPSTPR    DSWAOPSTPR
     C                   ENDIF
     C*
     C     EXWAOPPDAV    IFNE      *BLANK
     C                   MOVEL(P)  EXWAOPPDAV    DSWAOPPDAV
     C                   ENDIF
     C*
     C     EXWAOPERTR    IFNE      *ZERO
     C                   Z-ADD     EXWAOPERTR    DSWAOPERTR
     C                   ENDIF
     C*
     C     EXWAOPMG01    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG01    DSWAOPMG01
     C                   ENDIF
     C*
     C     EXWAOPMG02    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG02    DSWAOPMG02
     C                   ENDIF
     C*
     C     EXWAOPMG03    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG03    DSWAOPMG03
     C                   ENDIF
     C*
     C     EXWAOPMG04    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG04    DSWAOPMG04
     C                   ENDIF
     C*
     C     EXWAOPMG05    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG05    DSWAOPMG05
     C                   ENDIF
     C*
     C     EXWAOPMG06    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG06    DSWAOPMG06
     C                   ENDIF
     C*
     C     EXWAOPMG07    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG07    DSWAOPMG07
     C                   ENDIF
     C*
     C     EXWAOPMG08    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG08    DSWAOPMG08
     C                   ENDIF
     C*
     C     EXWAOPMG09    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG09    DSWAOPMG09
     C                   ENDIF
     C*
     C     EXWAOPMG10    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG10    DSWAOPMG10
     C                   ENDIF
     C*
     C     EXWAOPMG11    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG11    DSWAOPMG11
     C                   ENDIF
     C*
     C     EXWAOPMG12    IFNE      *ZERO
     C                   Z-ADD     EXWAOPMG12    DSWAOPMG12
     C                   ENDIF
     C*
     C     EXWAOPUM01    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM01    DSWAOPUM01
     C                   ENDIF
     C*
     C     EXWAOPUM02    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM02    DSWAOPUM02
     C                   ENDIF
     C*
     C     EXWAOPUM03    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM03    DSWAOPUM03
     C                   ENDIF
     C*
     C     EXWAOPUM04    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM04    DSWAOPUM04
     C                   ENDIF
     C*
     C     EXWAOPUM05    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM05    DSWAOPUM05
     C                   ENDIF
     C*
     C     EXWAOPUM06    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM06    DSWAOPUM06
     C                   ENDIF
     C*
     C     EXWAOPUM07    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM07    DSWAOPUM07
     C                   ENDIF
     C*
     C     EXWAOPUM08    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM08    DSWAOPUM08
     C                   ENDIF
     C*
     C     EXWAOPUM09    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM09    DSWAOPUM09
     C                   ENDIF
     C*
     C     EXWAOPUM10    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM10    DSWAOPUM10
     C                   ENDIF
     C*
     C     EXWAOPUM11    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM11    DSWAOPUM11
     C                   ENDIF
     C*
     C     EXWAOPUM12    IFNE      *ZERO
     C                   Z-ADD     EXWAOPUM12    DSWAOPUM12
     C                   ENDIF
     C*
     C     EXWAOPER01    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER01    DSWAOPER01
     C                   ENDIF
     C*
     C     EXWAOPER02    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER02    DSWAOPER02
     C                   ENDIF
     C*
     C     EXWAOPER03    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER03    DSWAOPER03
     C                   ENDIF
     C*
     C     EXWAOPER04    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER04    DSWAOPER04
     C                   ENDIF
     C*
     C     EXWAOPER05    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER05    DSWAOPER05
     C                   ENDIF
     C*
     C     EXWAOPER06    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER06    DSWAOPER06
     C                   ENDIF
     C*
     C     EXWAOPER07    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER07    DSWAOPER07
     C                   ENDIF
     C*
     C     EXWAOPER08    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER08    DSWAOPER08
     C                   ENDIF
     C*
     C     EXWAOPER09    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER09    DSWAOPER09
     C                   ENDIF
     C*
     C     EXWAOPER10    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER10    DSWAOPER10
     C                   ENDIF
     C*
     C     EXWAOPER11    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER11    DSWAOPER11
     C                   ENDIF
     C*
     C     EXWAOPER12    IFNE      *ZERO
     C                   Z-ADD     EXWAOPER12    DSWAOPER12
     C                   ENDIF
     C*
     C     EXWAOPWACD    IFNE      *BLANK
     C                   MOVEL     EXWAOPWACD    DSWAOPWACD
     C                   ENDIF
     C*
     C     EXWAOPSTKD    IFNE      *BLANK
     C                   MOVEL     EXWAOPSTKD    DSWAOPSTKD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOP01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     'TRWAOP02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDIF
     C*
     C     WKFENR        IFEQ      *ZERO
     C     EXWAOPPROG    OREQ      'T2WAOP'
     C                   EXSR      UWAOP
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOP
     C                   MOVEL(P)  WKPROG        RTWAOPPROG
     C                   MOVEL(P)  WKDANA        RTWAOPDANA
     C                   MOVEL(P)  WKFFLD        RTWAOPFFLD
     C                   MOVEL(P)  WKFENR        RTWAOPFENR
     C                   MOVEL(P)  W$PA03        RTWAOPPA03
     C                   MOVEL(P)  W$PA04        RTWAOPPA04
     C                   MOVEL(P)  W$PA05        RTWAOPPA05
     C                   MOVEL(P)  W$PA06        RTWAOPPA06
     C                   MOVEL(P)  W$PA07        RTWAOPPA07
     C*-------------------------------------------------------------------------
     C     K#WAOPLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOP                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOP                                                 ***
     C**************************************************************************
     C     UWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAOPNPLA    KYWAOPPLAT
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOPPLMG    WAOPPLMG
     C                   Z-ADD     DSWAOPPLUM    WAOPPLUM
     C                   Z-ADD     DSWAOPSTPR    WAOPSTPR
     C                   MOVEL(P)  DSWAOPPDAV    WAOPPDAV
     C                   Z-ADD     DSWAOPERTR    WAOPERTR
     C                   Z-ADD     DSWAOPMG01    WAOPMG01
     C                   Z-ADD     DSWAOPMG02    WAOPMG02
     C                   Z-ADD     DSWAOPMG03    WAOPMG03
     C                   Z-ADD     DSWAOPMG04    WAOPMG04
     C                   Z-ADD     DSWAOPMG05    WAOPMG05
     C                   Z-ADD     DSWAOPMG06    WAOPMG06
     C                   Z-ADD     DSWAOPMG07    WAOPMG07
     C                   Z-ADD     DSWAOPMG08    WAOPMG08
     C                   Z-ADD     DSWAOPMG09    WAOPMG09
     C                   Z-ADD     DSWAOPMG10    WAOPMG10
     C                   Z-ADD     DSWAOPMG11    WAOPMG11
     C                   Z-ADD     DSWAOPMG12    WAOPMG12
     C                   Z-ADD     DSWAOPUM01    WAOPUM01
     C                   Z-ADD     DSWAOPUM02    WAOPUM02
     C                   Z-ADD     DSWAOPUM03    WAOPUM03
     C                   Z-ADD     DSWAOPUM04    WAOPUM04
     C                   Z-ADD     DSWAOPUM05    WAOPUM05
     C                   Z-ADD     DSWAOPUM06    WAOPUM06
     C                   Z-ADD     DSWAOPUM07    WAOPUM07
     C                   Z-ADD     DSWAOPUM08    WAOPUM08
     C                   Z-ADD     DSWAOPUM09    WAOPUM09
     C                   Z-ADD     DSWAOPUM10    WAOPUM10
     C                   Z-ADD     DSWAOPUM11    WAOPUM11
     C                   Z-ADD     DSWAOPUM12    WAOPUM12
     C                   Z-ADD     DSWAOPER01    WAOPER01
     C                   Z-ADD     DSWAOPER02    WAOPER02
     C                   Z-ADD     DSWAOPER03    WAOPER03
     C                   Z-ADD     DSWAOPER04    WAOPER04
     C                   Z-ADD     DSWAOPER05    WAOPER05
     C                   Z-ADD     DSWAOPER06    WAOPER06
     C                   Z-ADD     DSWAOPER07    WAOPER07
     C                   Z-ADD     DSWAOPER08    WAOPER08
     C                   Z-ADD     DSWAOPER09    WAOPER09
     C                   Z-ADD     DSWAOPER10    WAOPER10
     C                   Z-ADD     DSWAOPER11    WAOPER11
     C                   Z-ADD     DSWAOPER12    WAOPER12
     C                   MOVEL(P)  DSWAOPWACD    WAOPWACD
     C                   MOVEL(P)  DSWAOPSTKD    WAOPSTKD
     C*--------------------------------------------------------
     C                   SELECT
     C     WAOPKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  '4'           WAOPPLKZ
     C     WAOPKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  '3'           WAOPPLKZ
     C     WAOPKDGR      WHENNE    *BLANK
     C                   MOVEL(P)  '2'           WAOPPLKZ
     C     WAOPKSTC      WHENNE    *BLANK
     C                   MOVEL(P)  '1'           WAOPPLKZ
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOPJNAM
     C                   MOVEL(P)  DAPROG        WAOPPROG
     C                   MOVEL(P)  WKCHPL        WAOPBIBL
     C                   MOVEL(P)  DAUSER        WAOPUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOPJZEI
     C                   MOVE      WKTDAT        WAOPJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOP
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOP
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOP
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
     C     MCWAOPPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOPPLAT    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'APAT'        KOM(02)
     C                   MOVEA     DSWAOPPLAT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPPLAT
     C                   MOVEL(P)  TPTTXT        TXWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PERIODEN-DEFINITION                                        ***
     C**************************************************************************
     C     PRWAOPPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPPLAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APAT'        KYTPTA
     C                   MOVEL(P)  DSWAOPPLAT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPPLAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  WERKS-STAMM                                             ***
     C**************************************************************************
     C     MCWAOPWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOPWKNR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPWKNR    KOM(01)
     C                   MOVE      'WERK01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCWERK
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  WRWKNR        DSWAOPWKNR
     C                   MOVEL(P)  WRWKBZ        TXWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WERKS-NR                                                   ***
     C**************************************************************************
     C     PRWAOPWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPWKNR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPWKNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPWKNR    KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXWAOPWKNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOPKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKSTC
     C                   MOVEL(P)  TPTTXT        TXWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE                                     ***
     C**************************************************************************
     C     PRWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPKSTC    IFEQ      *BLANK
     C     PCPGST        ANDEQ     '3      '
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPKSTC    IFNE      *BLANK
     C     DSWAOPKDGR    OREQ      *BLANK
     C     DSWAOPKDPL    ANDEQ     *BLANK
     C     DSWAOPKDNR    ANDEQ     *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOPKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKSTC
     C*
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*--------------------------------------------------------
     C                   EXSR      PCHECKTRSB
     C*
     C                   IF        RTTRSBBERE  = *OFF
     C                   EVAL      WKFENR      = '0089'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOPKDGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKDGR
     C                   MOVEL(P)  TPTTXT        TXWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE                                              ***
     C**************************************************************************
     C     PRWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C*-------------------------------------------------------------------------
     C     DSWAOPKDGR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOPKSTC    IFNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOPKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOPKDPL    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKDPL
     C                   MOVEL(P)  TPTTXT        TXWAOPKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG                                             ***
     C**************************************************************************
     C     PRWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C*-------------------------------------------------------------------------
     C     DSWAOPKDPL    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOPKSTC    IFNE      *BLANK
     C     DSWAOPKDGR    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOPKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKDPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      DSWAOPSTKD
     C                   ELSE
     C                   MOVE      '1810'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STAMM                                             ***
     C**************************************************************************
     C     MCWAOPKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR                                                  ***
     C**************************************************************************
     C     PRWAOPKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDNR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C     DSWAOPKDNR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOPKSTC    IFNE      *BLANK
     C     DSWAOPKDGR    ORNE      *BLANK
     C     DSWAOPKDPL    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVEL(P)  KDKDNR        DSWAOPSTKD
     C*--------------------------------------------------------
     C* Der Status des Datensatzes lässt eine Bearbeitung nicht zu
     C*--------------------------------------------------------
     C     KDKDST        IFGE      '90'
     C                   MOVE      '0009'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     KDEWPLKZ      IFNE      '4'
     C                   MOVEL(P)  'KDEWPLKZ'    KYTPTA
     C                   MOVEL(P)  KDEWPLKZ      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   EVAL      W$PA03      = %TRIM(TPTCDE)
     C                   EVAL      W$PA04      = %SUBST(TPTTXT:1:10)
     C                   EVAL      W$PA05      = %SUBST(TPTTXT:11:10)
     C                   EVAL      WKFENR      = '0598'
     C                   MOVE      '0598'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LÄNDER-STAMM                                              ***
     C**************************************************************************
     C     MCWAOPLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPLDNR    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOPLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LAND-NR                                                    ***
     C**************************************************************************
     C     PRWAOPLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPLDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPLDNR    IFEQ      *BLANK
     C                   SELECT
     C*--------------------------------------------------------
     C     DSWAOPKDNR    WHENNE    *BLANK
     C                   MOVEL(P)  KDLAND        DSWAOPLDNR
     C*--------------------------------------------------------
     C     DSWAOPKDPL    WHENNE    *BLANK
     C                   MOVEL(P)  DSWAOPKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDLAND        DSWAOPLDNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPLDNR    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXWAOPLDNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKT-GRUPPE                                           ***
     C**************************************************************************
     C     MCTEILPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSTEILPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEILPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKT-GRUPPE                                             ***
     C**************************************************************************
     C     PRTEILPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEILPRGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSTEILPRGR    IFNE      *BLANK
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSTEILPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN IDENT-STAMM                                              ***
     C**************************************************************************
     C     MCWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPTENR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        DSTEILTBZ1
     C                   MOVEL     *BLANK        DSTEILTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPTENR    KOM(01)
     C                   MOVE      '0117'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   MOVEL(P)  TETBZ1        DSTEILTBZ1
     C                   MOVEL(P)  TETBZ2        DSTEILTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN IDENT-NR                                                   ***
     C**************************************************************************
     C     PRWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPTENR    IFEQ      *BLANK
     C     PCPGST        ANDEQ     '3     '
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   ENDIF
     C*
     C                   MOVEL(P)  TETBZ1        DSTEILTBZ1
     C                   MOVEL(P)  TETBZ2        DSTEILTBZ2
     C*-------------------------------------------------------------------------
     C     TETART        IFEQ      'P'
     C     TEPRGR        ORGT      '901'
     C                   MOVE      '0051'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR                                                       ***
     C**************************************************************************
     C     PRWAOPJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOPJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-MENGE                                                 ***
     C**************************************************************************
     C     PRWAOPPLMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPLMG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Eingabe Plan-Menge oder Plan-Umsatz
     C*-------------------------------------------------------------------------
     C     DSWAOPPLMG    IFEQ      *ZERO
     C     DSWAOPPLUM    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Verteilen jahres-Absatz/Umsatz auf Monatsebene
     C*-------------------------------------------------------------------------
     C     DSWAOPPLMG    IFNE      DHWAOPPLMG
     C     DSWAOPPLUM    ORNE      DHWAOPPLUM
     C     DSWAOPSTPR    ORNE      DHWAOPSTPR
     C     DSWAOPPDAV    ORNE      DHWAOPPDAV
     C     EXWAOPPGST    OREQ      'UWAOM '                                     Update Datei WAOM
     C                   EXSR      EWAOM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-UMSATZ                                                ***
     C**************************************************************************
     C     PRWAOPPLUM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPLUM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN STANDARD-PREIS                                             ***
     C**************************************************************************
     C     PRWAOPSTPR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPSTPR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPSTPR    IFEQ      *ZERO
     C     DSWAOPPDAV    ANDEQ     *BLANK
     C     DSWAOPERTR    ANDEQ     *ZERO
     C                   Z-ADD     TESTPR        DSWAOPSTPR
     C                   MOVEL(P)  TEPDAV        DSWAOPPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCWAOPPDAV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPPDAV    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSWAOPPDAV    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPPDAV
     C                   MOVEL(P)  TPTTXT        TXWAOPPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREIS-DIMENSION (STANDARD-PREIS)                           ***
     C**************************************************************************
     C     PRWAOPPDAV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPDAV'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPSTPR    IFNE      *ZERO
     C     DSWAOPPDAV    ORNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSWAOPPDAV    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPPDAV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN ROHERTRAG                                                  ***
     C**************************************************************************
     C     PRWAOPERTR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPERTR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-MENGE                                                 ***
     C**************************************************************************
     C     PRWAOPMG01    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPMG01'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Berechnen Mengen-Erhöhung
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOPMG01    SFLMG(01)
     C                   Z-ADD     DSWAOPMG02    SFLMG(02)
     C                   Z-ADD     DSWAOPMG03    SFLMG(03)
     C                   Z-ADD     DSWAOPMG04    SFLMG(04)
     C                   Z-ADD     DSWAOPMG05    SFLMG(05)
     C                   Z-ADD     DSWAOPMG06    SFLMG(06)
     C                   Z-ADD     DSWAOPMG07    SFLMG(07)
     C                   Z-ADD     DSWAOPMG08    SFLMG(08)
     C                   Z-ADD     DSWAOPMG09    SFLMG(09)
     C                   Z-ADD     DSWAOPMG10    SFLMG(10)
     C                   Z-ADD     DSWAOPMG11    SFLMG(11)
     C                   Z-ADD     DSWAOPMG12    SFLMG(12)
     C                   XFOOT     SFLMG         DUN090
     C*
     C     DSWAOPPLMG    IFNE      DUN090
     C                   EVAL      DUN090      = DSWAOPPLMG - DUN090
     C                   EVAL      W$PA03      = %TRIM(%EDITC(DUN090 : 'M'))
     C                   MOVE      '0686'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Speichern den Feldgruppen-Index des höchsten %-Satzes
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFGT      SFLMG(I0)
     C     SFLMG(I1)     ANDNE     *ZERO
     C     SFLMG(I0)     OREQ      *ZERO
     C                   Z-ADD     I1            I0
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Berechnen Plan-Preis/Umsatz
     C*-------------------------------------------------------------------------
     C     DSWAOPPLMG    IFNE      *ZERO
     C     DSWAOPPLUM    DIV       DSWAOPPLMG    DUN113
     C                   ELSE
     C                   Z-ADD     *ZERO         DUN113
     C                   ENDIF
     C*
     C     SFLMG         MULT      DUN113        SFLUM
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLUM         DUN112
     C     DSWAOPPLUM    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLUM(I0)
     C*
     C                   Z-ADD     SFLUM(01)     DSWAOPUM01
     C                   Z-ADD     SFLUM(02)     DSWAOPUM02
     C                   Z-ADD     SFLUM(03)     DSWAOPUM03
     C                   Z-ADD     SFLUM(04)     DSWAOPUM04
     C                   Z-ADD     SFLUM(05)     DSWAOPUM05
     C                   Z-ADD     SFLUM(06)     DSWAOPUM06
     C                   Z-ADD     SFLUM(07)     DSWAOPUM07
     C                   Z-ADD     SFLUM(08)     DSWAOPUM08
     C                   Z-ADD     SFLUM(09)     DSWAOPUM09
     C                   Z-ADD     SFLUM(10)     DSWAOPUM10
     C                   Z-ADD     SFLUM(11)     DSWAOPUM11
     C                   Z-ADD     SFLUM(12)     DSWAOPUM12
     C*-------------------------------------------------------------------------
     C* Berechnen Rohertrag
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSWAOPPDAV    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
     C*
     C     TPTNUM        IFEQ      *ZERO
     C     DSWAOPSTPR    DIV       DSWAOPPLMG    DUN113
     C                   ELSE
     C     DSWAOPSTPR    DIV       TPTNUM        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     TPTNUM        WHENEQ    *ZERO
     C     DSWAOPPLUM    SUB       DSWAOPSTPR    DSWAOPERTR
     C*--------------------------------------------------------
     C     DSWAOPSTPR    WHENNE    *ZERO
     C     DSWAOPPLMG    MULT      DUN113        DSWAOPERTR
     C     DSWAOPPLUM    SUB       DSWAOPERTR    DSWAOPERTR
     C*--------------------------------------------------------
     C     DSWAOPPLMG    WHENNE    *ZERO
     C     DSWAOPPLUM    SUB       DSWAOPERTR    DUN219
     C     DUN219        DIV       DSWAOPPLMG    DUN113
     C     DSWAOPPLMG    IFLT      *ZERO
     C                   Z-SUB     DUN113        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   OTHER
     C                   Z-ADD     *ZERO         DUN113
     C                   ENDSL
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFNE      *ZERO
     C     SFLMG(I1)     MULT      DUN113        SFLER(I1)
     C     SFLMG(I1)     IFLT      *ZERO
     C                   Z-SUB     SFLER(I1)     SFLER(I1)
     C                   ENDIF
     C     SFLUM(I1)     SUB       SFLER(I1)     SFLER(I1)
     C                   ELSE
     C                   Z-ADD     *ZERO         SFLER(I1)
     C                   ENDIF
     C                   ENDDO
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLER         DUN112
     C     DSWAOPERTR    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLER(I0)
     C*
     C                   Z-ADD     SFLER(01)     DSWAOPER01
     C                   Z-ADD     SFLER(02)     DSWAOPER02
     C                   Z-ADD     SFLER(03)     DSWAOPER03
     C                   Z-ADD     SFLER(04)     DSWAOPER04
     C                   Z-ADD     SFLER(05)     DSWAOPER05
     C                   Z-ADD     SFLER(06)     DSWAOPER06
     C                   Z-ADD     SFLER(07)     DSWAOPER07
     C                   Z-ADD     SFLER(08)     DSWAOPER08
     C                   Z-ADD     SFLER(09)     DSWAOPER09
     C                   Z-ADD     SFLER(10)     DSWAOPER10
     C                   Z-ADD     SFLER(11)     DSWAOPER11
     C                   Z-ADD     SFLER(12)     DSWAOPER12
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  WÄHRUNGS-STAMM                                          ***
     C**************************************************************************
     C     MCWAOPWACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPWACD    KOM(1)
     C                   MOVE      'DETAIL'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCWACD
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  WCWACD        DSWAOPWACD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WÄHRUNG                                                    ***
     C**************************************************************************
     C     PRWAOPWACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPWACD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPWACD    IFNE      *BLANK
     C     DSWAOPPLUM    ORNE      *ZERO
     C                   MOVEA(P)  DSWAOPWACD    KOM(1)
     C                   EXSR      PRWACDWACD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  PLAN-ART                                                ***
     C**************************************************************************
     C     MCWAOPNPLA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'APAT'        KOM(02)
     C                   MOVEA     DSWAOPNPLA    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPNPLA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLAN-ART (NACH)                                            ***
     C**************************************************************************
     C     PRWAOPNPLA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPNPLA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APAT'        KYTPTA
     C                   MOVEL(P)  DSWAOPNPLA    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOP'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOP
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOP'        EXDATAFILE
     C                   MOVEL(P)  WAOP          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS %-SÄTZE                                       ***
     C**************************************************************************
     C     EWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Generieren Absatz/Umsatz-Plan
     C*-------------------------------------------------------------------------
     C     EXWAOPPROG    IFEQ      'T2WAOP'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Berechnen Umsatz bei Mengen-Änderung
     C*-------------------------------------------------------------------------
     C     DSWAOPPLMG    IFNE      DHWAOPPLMG
     C     DSWAOPPLUM    ANDEQ     DHWAOPPLUM
     C     DHWAOPPLMG    ANDNE     *ZERO
     C     DSWAOPPLMG    MULT      DSWAOPPLUM    DUN219
     C     DUN219        DIV       DHWAOPPLMG    DSWAOPPLUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Initialisieren Feldgruppen
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SFLPZ
     C                   CLEAR                   SFLMG
     C                   CLEAR                   SFLUM
     C                   CLEAR                   SFLER
     C*-------------------------------------------------------------------------
     C* Ermitteln Produktgruppe aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      DSWAOPTENR
     C                   MOVEL(P)  DSWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln %-Sätze Jahresebene
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSWAOPKSTC    KYWAOMKSTC
     C                   MOVEL     DSWAOPKDGR    KYWAOMKDGR
     C                   MOVEL     DSWAOPKDPL    KYWAOMKDPL
     C                   MOVEL     DSWAOPKDNR    KYWAOMKDNR
     C                   MOVEL     DSWAOPLDNR    KYWAOMLDNR
     C                   MOVEL     TEPRGR        KYWAOMPRGR
     C                   Z-ADD     DSWAOPJAHR    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C* Es sind keine %-Sätze zur Verteilung der Plan-Menge hinterlegt
     C     CHI(5)        IFEQ      'N'
     C                   MOVE      '0778'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   Z-ADD     WAOMPZ01      SFLPZ(01)
     C                   Z-ADD     WAOMPZ02      SFLPZ(02)
     C                   Z-ADD     WAOMPZ03      SFLPZ(03)
     C                   Z-ADD     WAOMPZ04      SFLPZ(04)
     C                   Z-ADD     WAOMPZ05      SFLPZ(05)
     C                   Z-ADD     WAOMPZ06      SFLPZ(06)
     C                   Z-ADD     WAOMPZ07      SFLPZ(07)
     C                   Z-ADD     WAOMPZ08      SFLPZ(08)
     C                   Z-ADD     WAOMPZ09      SFLPZ(09)
     C                   Z-ADD     WAOMPZ10      SFLPZ(10)
     C                   Z-ADD     WAOMPZ11      SFLPZ(11)
     C                   Z-ADD     WAOMPZ12      SFLPZ(12)
     C*-------------------------------------------------------------------------
     C* Speichern den Feldgruppen-Index des höchsten %-Satzes
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLPZ(I1)     IFGT      SFLPZ(I0)
     C                   Z-ADD     I1            I0
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Verteilen Absatz
     C*-------------------------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLPZ(I1)     IFNE      *ZERO
     C     DSWAOPPLMG    MULT      SFLPZ(I1)     DUN112
     C     DUN112        DIV       100           SFLMG(I1)
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Absatz-Plan ohne Nachkommastellen
     C*-------------------------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFNE      *ZERO
     C                   Z-ADD(H)  SFLMG(I1)     DUN090
     C                   Z-ADD     DUN090        SFLMG(I1)
     C                   ENDIF
     C                   ENDDO
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   Z-ADD(H)  DSWAOPPLMG    DUN090
     C                   Z-ADD     DUN090        DSWAOPPLMG
     C*
     C                   XFOOT     SFLMG         DUN090
     C     DSWAOPPLMG    SUB       DUN090        DUN090
     C                   ADD       DUN090        SFLMG(I0)
     C*-------------------------------------------------------------------------
     C* Berechnen Plan-Preis/Umsatz
     C*-------------------------------------------------------------------------
     C     DSWAOPPLMG    IFNE      *ZERO
     C     DSWAOPPLUM    DIV       DSWAOPPLMG    DUN113
     C*
     C     SFLMG         MULT      DUN113        SFLUM
     C                   ENDIF
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLUM         DUN112
     C     DSWAOPPLUM    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLUM(I0)
     C*-------------------------------------------------------------------------
     C* Berechnen Rohertrag
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSWAOPPDAV    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
     C*
     C     TPTNUM        IFEQ      *ZERO
     C     DSWAOPSTPR    DIV       DSWAOPPLMG    DUN113
     C                   ELSE
     C     DSWAOPSTPR    DIV       TPTNUM        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     TPTNUM        WHENEQ    *ZERO
     C     DSWAOPPLUM    SUB       DSWAOPSTPR    DSWAOPERTR
     C                   OTHER
     C     DSWAOPPLMG    MULT      DUN113        DSWAOPERTR
     C     DSWAOPPLUM    SUB       DSWAOPERTR    DSWAOPERTR
     C                   ENDSL
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFNE      *ZERO
     C     SFLMG(I1)     MULT      DUN113        SFLER(I1)
     C     SFLMG(I1)     IFLT      *ZERO
     C                   Z-SUB     SFLER(I1)     SFLER(I1)
     C                   ENDIF
     C     SFLUM(I1)     SUB       SFLER(I1)     SFLER(I1)
     C                   ENDIF
     C                   ENDDO
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLER         DUN112
     C     DSWAOPERTR    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLER(I0)
     C*-------------------------------------------------------------------------
     C* Füllen Bildschirmfelder
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SFLMG(01)     DSWAOPMG01
     C                   Z-ADD     SFLMG(02)     DSWAOPMG02
     C                   Z-ADD     SFLMG(03)     DSWAOPMG03
     C                   Z-ADD     SFLMG(04)     DSWAOPMG04
     C                   Z-ADD     SFLMG(05)     DSWAOPMG05
     C                   Z-ADD     SFLMG(06)     DSWAOPMG06
     C                   Z-ADD     SFLMG(07)     DSWAOPMG07
     C                   Z-ADD     SFLMG(08)     DSWAOPMG08
     C                   Z-ADD     SFLMG(09)     DSWAOPMG09
     C                   Z-ADD     SFLMG(10)     DSWAOPMG10
     C                   Z-ADD     SFLMG(11)     DSWAOPMG11
     C                   Z-ADD     SFLMG(12)     DSWAOPMG12
     C*
     C                   Z-ADD     SFLUM(01)     DSWAOPUM01
     C                   Z-ADD     SFLUM(02)     DSWAOPUM02
     C                   Z-ADD     SFLUM(03)     DSWAOPUM03
     C                   Z-ADD     SFLUM(04)     DSWAOPUM04
     C                   Z-ADD     SFLUM(05)     DSWAOPUM05
     C                   Z-ADD     SFLUM(06)     DSWAOPUM06
     C                   Z-ADD     SFLUM(07)     DSWAOPUM07
     C                   Z-ADD     SFLUM(08)     DSWAOPUM08
     C                   Z-ADD     SFLUM(09)     DSWAOPUM09
     C                   Z-ADD     SFLUM(10)     DSWAOPUM10
     C                   Z-ADD     SFLUM(11)     DSWAOPUM11
     C                   Z-ADD     SFLUM(12)     DSWAOPUM12
     C*
     C                   Z-ADD     SFLER(01)     DSWAOPER01
     C                   Z-ADD     SFLER(02)     DSWAOPER02
     C                   Z-ADD     SFLER(03)     DSWAOPER03
     C                   Z-ADD     SFLER(04)     DSWAOPER04
     C                   Z-ADD     SFLER(05)     DSWAOPER05
     C                   Z-ADD     SFLER(06)     DSWAOPER06
     C                   Z-ADD     SFLER(07)     DSWAOPER07
     C                   Z-ADD     SFLER(08)     DSWAOPER08
     C                   Z-ADD     SFLER(09)     DSWAOPER09
     C                   Z-ADD     SFLER(10)     DSWAOPER10
     C                   Z-ADD     SFLER(11)     DSWAOPER11
     C                   Z-ADD     SFLER(12)     DSWAOPER12
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KD-NR STATISTIK AUS KUNDEN-STAMM                        ***
     C**************************************************************************
     C     EKDEW         BEGSR
     C*
     C                   MOVE      *BLANK        DSWAOPSTKD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKSTC    UFKUNDKSTC
     C                   MOVEL(P)  DSWAOPKSTC    OFKUNDKSTC
     C*
     C     DSWAOPKSTC    IFEQ      *BLANK
     C                   MOVE      *LOVAL        UFKUNDKSTC
     C                   MOVE      *HIVAL        OFKUNDKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKDGR    UFKUNDKDGR
     C                   MOVEL(P)  DSWAOPKDGR    OFKUNDKDGR
     C*
     C     DSWAOPKDGR    IFEQ      *BLANK
     C                   MOVE      *LOVAL        UFKUNDKDGR
     C                   MOVE      *HIVAL        OFKUNDKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKDPL    UFKDEWKDPL
     C                   MOVEL(P)  DSWAOPKDPL    OFKDEWKDPL
     C*
     C     DSWAOPKDPL    IFEQ      *BLANK
     C                   MOVE      *LOVAL        UFKDEWKDPL
     C                   MOVE      *HIVAL        OFKDEWKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPKDNR    UFKDEWKDNR
     C                   MOVEL(P)  DSWAOPKDNR    OFKDEWKDNR
     C*
     C     DSWAOPKDNR    IFEQ      *BLANK
     C                   MOVE      *LOVAL        UFKDEWKDNR
     C                   MOVE      *HIVAL        OFKDEWKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE KDEWC1 CURSOR FOR
     C+ SELECT KDKDNR FROM KUND, KDEW
     C+ WHERE KDEW.KDEWFIRM = :DAFIRM
     C+ AND   KDEW.KDEWKDNR BETWEEN :UFKDEWKDNR AND :OFKDEWKDNR
     C+ AND   KDEW.KDEWKDPL BETWEEN :UFKDEWKDPL AND :OFKDEWKDPL
     C+ AND   KDEW.KDEWFIRM = KUND.KDFIRM
     C+ AND   KDEW.KDEWKDNR = KUND.KDKDNR
     C+ AND   KUND.KDKDGR BETWEEN :UFKUNDKDGR AND :OFKUNDKDGR
     C+ AND   KUND.KDKSTC BETWEEN :UFKUNDKSTC AND :OFKUNDKSTC
     C+ AND   KUND.KDLAND   = :DSWAOPLDNR
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN KDEWC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH KDEWC1 INTO :KDKDNR
     C/END-EXEC
     C*-------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*--------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*--------------------------------------------------------
     C     RTTRSBKUND    IFNE      *BLANK
     C     EXWAOPPROG    ANDNE     'T2WAOP'
     C                   MOVEL(P)  KDKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*--------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST  = 'CHECK'
     C                   EVAL      EXTRSBFILE  = 'KUND'
     C                   EVAL      EXTRSBPTR§  = %ADDR(KUND)
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C                   PARM                    EXTRSBPTR§
     C*
     C                   IF        RTTRSBBERE  = *OFF
     C                   EVAL      WKFENR      = '0089'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*--------------------------------------------------------
     C     RTTRSBKDEW    IFNE      *BLANK
     C     EXWAOPPROG    ANDNE     'T2WAOP'
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST  = 'CHECK'
     C                   EVAL      EXTRSBFILE  = 'KDEW'
     C                   EVAL      EXTRSBPTR§  = %ADDR(KDEW)
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C                   PARM                    EXTRSBPTR§
     C*
     C                   IF        RTTRSBBERE  = *OFF
     C                   EVAL      WKFENR      = '0089'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        DSWAOPSTKD
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE KDEWC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFUNG SATZBERECHTIGUNG                                          ***
     C**************************************************************************
     C     PCHECKTRSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C*
     C                   EVAL      EXTRSBPGST = 'CHECK'
     C                   EVAL      EXTRSBFILE = 'TRTP'
     C                   EVAL      EXTRSBPTR§ = %ADDR(TRTP)
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C                   PARM                    EXTRSBPTR§
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
     C                   MOVEL(P)  'TRWAOP'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
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
     C                   MOVEL(P)  'TRWAOP'      EXTRDNPGNA
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
     C     EXTRDNDANA    WHENEQ    'TRWAOP02'                                   MENGEN-VERTEILUNG
     C                   MOVE      '02'          WKIFMT
     C                   EXSR      BILD02
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
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
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
     C     *LIKE         DEFINE    KDEWKDNR      UFKDEWKDNR
     C     *LIKE         DEFINE    KDEWKDNR      OFKDEWKDNR
     C*
     C     *LIKE         DEFINE    KDEWKDPL      UFKDEWKDPL
     C     *LIKE         DEFINE    KDEWKDPL      OFKDEWKDPL
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KDKSTC        UFKUNDKSTC
     C     *LIKE         DEFINE    KDKSTC        OFKUNDKSTC
     C*
     C     *LIKE         DEFINE    KDKDGR        UFKUNDKDGR
     C     *LIKE         DEFINE    KDKDGR        OFKUNDKDGR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOPPLAT    OFWAOPPLAT
     C     *LIKE         DEFINE    KYWAOPWKNR    OFWAOPWKNR
     C     *LIKE         DEFINE    KYWAOPKSTC    OFWAOPKSTC
     C     *LIKE         DEFINE    KYWAOPKDGR    OFWAOPKDGR
     C     *LIKE         DEFINE    KYWAOPKDPL    OFWAOPKDPL
     C     *LIKE         DEFINE    KYWAOPKDNR    OFWAOPKDNR
     C     *LIKE         DEFINE    KYWAOPLDNR    OFWAOPLDNR
     C     *LIKE         DEFINE    KYWAOPTENR    OFWAOPTENR
     C     *LIKE         DEFINE    KYWAOPJAHR    OFWAOPJAHR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOPPLMG      DHWAOPPLMG
     C     *LIKE         DEFINE    WAOPPLUM      DHWAOPPLUM
     C     *LIKE         DEFINE    WAOPSTPR      DHWAOPSTPR
     C     *LIKE         DEFINE    WAOPPDAV      DHWAOPPDAV
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOPUM01      DSWAOPUM01
     C     *LIKE         DEFINE    WAOPUM02      DSWAOPUM02
     C     *LIKE         DEFINE    WAOPUM03      DSWAOPUM03
     C     *LIKE         DEFINE    WAOPUM04      DSWAOPUM04
     C     *LIKE         DEFINE    WAOPUM05      DSWAOPUM05
     C     *LIKE         DEFINE    WAOPUM06      DSWAOPUM06
     C     *LIKE         DEFINE    WAOPUM07      DSWAOPUM07
     C     *LIKE         DEFINE    WAOPUM08      DSWAOPUM08
     C     *LIKE         DEFINE    WAOPUM09      DSWAOPUM09
     C     *LIKE         DEFINE    WAOPUM10      DSWAOPUM10
     C     *LIKE         DEFINE    WAOPUM11      DSWAOPUM11
     C     *LIKE         DEFINE    WAOPUM12      DSWAOPUM12
     C*
     C     *LIKE         DEFINE    WAOPER01      DSWAOPER01
     C     *LIKE         DEFINE    WAOPER02      DSWAOPER02
     C     *LIKE         DEFINE    WAOPER03      DSWAOPER03
     C     *LIKE         DEFINE    WAOPER04      DSWAOPER04
     C     *LIKE         DEFINE    WAOPER05      DSWAOPER05
     C     *LIKE         DEFINE    WAOPER06      DSWAOPER06
     C     *LIKE         DEFINE    WAOPER07      DSWAOPER07
     C     *LIKE         DEFINE    WAOPER08      DSWAOPER08
     C     *LIKE         DEFINE    WAOPER09      DSWAOPER09
     C     *LIKE         DEFINE    WAOPER10      DSWAOPER10
     C     *LIKE         DEFINE    WAOPER11      DSWAOPER11
     C     *LIKE         DEFINE    WAOPER12      DSWAOPER12
     C*
     C     *LIKE         DEFINE    WAOPSTKD      DSWAOPSTKD
     C*
     C     *LIKE         DEFINE    EXWAOPKSST    DSKDEWKSST
     C     *LIKE         DEFINE    EXWAOPGEBT    DSLANDGEBT
     C     *LIKE         DEFINE    EXWAOPPRGR    DSTEILPRGR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKDEW
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKUND
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOPPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOPDANA    WKDANA
     C     *LIKE         DEFINE    RTWAOPFFLD    WKFFLD
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
     C                   MOVEL(P)  'TRWAOP'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTWAOPW3
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOPW3
     C                   OTHER
     C                   WRITE     TRWAOPCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTWAOPW3
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOPW3
     C                   OTHER
     C                   WRITE     TRWAOPCT
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
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,CHWAOP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCLAND
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCWACD
     C/COPY QCPYSRC,MCWERK
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRLANDLAND
     C/COPY QCPYSRC,PRWACDWACD
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
