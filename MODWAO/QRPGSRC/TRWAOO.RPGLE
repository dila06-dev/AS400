     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOO
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 23.01.2012 Projekt 7558 DOMETIC
     H*  -----------------------------------------------------------------------
     H*  Änderung: VU 25.06.2012 Projekt 8469 DOMETIC
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOO.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOOFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D/COPY QCPYSRC,EXTRDA
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D WAOO          E DS                  INZ
     D KYWAOO        E DS                  INZ
     D*
     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ
     D*
     D LGPA          E DS                  INZ
     D KYLGPA        E DS                  INZ
     D*
     D SLPO          E DS                  INZ
     D*
     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LGFB          E DS                  INZ
     D KYLGFB        E DS                  INZ
     D*
     D FEPA          E DS                  INZ
     D KYFEPA        E DS                  INZ
     D*
     D FEAZ          E DS                  INZ
     D KYFEAZ        E DS                  INZ
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
     D EXTRPC        E DS                  INZ
     D EXTXST        E DS                  INZ
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
     D EXWAOO        E DS
     D RTWAOO        E DS
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
     C                   PARM                    EXWAOO
     C                   PARM                    RTWAOO
     C*
     C                   EXSR      UEBWAOO
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
     C                   CLOSE     TRWAOOFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOO '
     C                   EXSR      PWAOO
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOO
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOO
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      '01'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAOOIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOO                                       UPDATE
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
     C                   OPEN      TRWAOOFM                             98
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
     C                   CLOSE     TRWAOOFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOORTCD
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
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYWAOOFIRM                     WAOO
     C                   MOVEL(P)  DAFIRM        KYLGKOFIRM                     LGKO
     C                   MOVEL(P)  DAFIRM        KYLGPAFIRM                     LGPA
     C                   MOVEL(P)  DAFIRM        KYLGPOFIRM                     LGPO
     C                   MOVEL(P)  DAFIRM        KYLGFBFIRM                     LGFB
     C                   MOVEL(P)  DAFIRM        KYFEAZFIRM                     FEAZ
     C                   MOVEL(P)  DAFIRM        KYFEPAFIRM                     FEPA
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOOFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOOFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXWAOO                         ***
     C**************************************************************************
     C     UEBWAOO       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXWAOO'      EXDATAFILE
     C                   MOVEL(P)  EXWAOO        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXWAOO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXWAOOPGST    PCPGST
     C*
     C                   Z-ADD     EXWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  EXWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     EXWAOOLGPO    KYWAOOLGPO
     C                   MOVEL(P)  EXWAOOFBNR    KYWAOOFBNR
     C                   MOVE      EXWAOOTSTP    KYWAOOTSTP
     C*
     C                   Z-ADD     EXWAOOLGJJ    DSWAOOLGJJ
     C                   MOVEL(P)  EXWAOOLGNR    DSWAOOLGNR
     C                   Z-ADD     EXWAOOLGPO    DSWAOOLGPO
     C                   MOVEL(P)  EXWAOOFBNR    DSWAOOFBNR
     C                   MOVE      EXWAOOTSTP    DSWAOOTSTP
     C*
     C                   Z-ADD     EXWAOONLGJ    DSWAOONLGJ
     C                   MOVEL(P)  EXWAOONLGN    DSWAOONLGN
     C                   Z-ADD     EXWAOONLGP    DSWAOONLGP
     C                   MOVEL(P)  EXWAOONFBN    DSWAOONFBN
     C                   MOVE      EXWAOONTST    DSWAOONTST
     C*
     C                   MOVEL(P)  EXWAOOPERG    DSWAOOPERG
     C                   MOVEL(P)  EXWAOOFEAR    DSWAOOFEAR
     C                   MOVEL(P)  EXWAOOFEUS    DSWAOOFEUS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOO
     C                   MOVEL     *ZERO         RTWAOOFENR
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
     C                   MOVEL(P)  'TRWAOO'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
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
     C                   MOVEL     'TRWAOO01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOO01
     C                   WRITE     TRWAOOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C**                 MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRWAOO01                             9899
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
     C     DSWAOOFBNR    IFNE      *BLANK
     C                   EXSR      ULGFB
     C                   ENDIF
     C                   EXSR      UWAOO
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
     C                   CLEAR                   KYWAOOTSTP
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOO
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOO
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
     C                   CLEAR                   WAOO
     C                   EXSR      ETRMU
     C                   EXSR      EWAOO
     C     PCPGST        IFEQ      *BLANK
     C                   EXSR      NWAOO
     C                   ENDIF
     C                   Z-ADD     KYWAOOLGJJ    WAOOLGJJ
     C                   MOVEL(P)  KYWAOOLGNR    WAOOLGNR
     C                   Z-ADD     KYWAOOLGPO    WAOOLGPO
     C                   MOVEL(P)  KYWAOOFBNR    WAOOFBNR
     C                   MOVE      KYWAOOTSTP    WAOOTSTP
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOO
     C                   MOVEL(P)  WAOOUSER      WKUSER
     C                   Z-ADD     WAOOJDAT      WKJDAT
     C                   Z-ADD     WAOOJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOO
     C                   EXSR      EWAOO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOOLGJJ      DSWAOOLGJJ
     C                   MOVEL(P)  WAOOLGNR      DSWAOOLGNR
     C                   Z-ADD     WAOOLGPO      DSWAOOLGPO
     C                   MOVEL(P)  WAOOFBNR      DSWAOOFBNR
     C                   MOVE      WAOOTSTP      DSWAOOTSTP
     C                   MOVEL(P)  WAOOFEAT      DSWAOOFEAT
     C                   MOVEL(P)  WAOOFEAR      DSWAOOFEAR
     C                   MOVEL(P)  WAOOFEUS      DSWAOOFEUS
     C                   MOVEL(P)  WAOOFEBM      DSWAOOFEBM
     C                   MOVEL(P)  WAOOPERG      DSWAOOPERG
     C                   MOVEL(P)  WAOOBGTE      DSWAOOBGTE
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        DSLGKOKDNR                     INITIALISIEREN
     C                   MOVEL     *BLANK        DSKUNDKNAM                     TEXTFELDER
     C                   MOVEL     *BLANK        DSLGKOEXBL
     C                   MOVEL     *BLANK        DSLGKOLGAT
     C                   MOVEL     *BLANK        TXLGKOLGAT
     C                   MOVEL     *BLANK        DSLGKOWKNR
     C                   MOVEL     *BLANK        TXLGKOWKNR
     C                   MOVEL     *BLANK        DSLGKORTNR
     C*
     C                   MOVEL     *BLANK        DSLGPOTENR
     C                   MOVEL     *BLANK        DSLGPOTBZ1
     C                   MOVEL     *BLANK        DSLGPOTBZ2
     C                   Z-ADD     *ZERO         DSLGPOSOMG
     C                   Z-ADD     *ZERO         DSLGPOISMG
     C                   Z-ADD     *ZERO         DSLGPOOFMG
     C                   MOVEL     *BLANK        DSLGPOMEIN
     C                   MOVEL     *BLANK        TXLGPOMEIN
     C*
     C                   MOVEL(P)  *BLANK        TXWAOOFEAR
     C                   MOVEL(P)  *BLANK        TXWAOOFEUS
     C                   MOVEL(P)  *BLANK        TXWAOOFEBM
     C                   MOVEL(P)  *BLANK        TXWAOOPERG
     C*-------------------------------------------------------------------------
     C     DSWAOOLGNR    CASNE     *BLANK        PRWAOOLGNR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOOLGPO    CASNE     *ZERO         PRWAOOLGPO
     C                   ENDCS
     C     DSWAOOFBNR    CASNE     *ZERO         PRWAOOFBNR
     C                   ENDCS
     C     DSWAOOFEAT    CASNE     *ZERO         PRWAOOFEAT
     C                   ENDCS
     C     DSWAOOFEAR    CASNE     *ZERO         PRWAOOFEAR
     C                   ENDCS
     C     DSWAOOFEUS    CASNE     *ZERO         PRWAOOFEUS
     C                   ENDCS
     C     DSWAOOFEBM    CASNE     *ZERO         PRWAOOFEBM
     C                   ENDCS
     C     DSWAOOPERG    CASNE     *ZERO         PRWAOOPERG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOO01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOOFEAT'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAOOFEAT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOOFEAR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOOFEUS'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOOFEBM'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOOPERG'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOOBGTE'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOFEAT'
     C                   EXSR      MCWAOOFEAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOFEAR'
     C                   EXSR      MCWAOOFEAR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOFEUS'
     C                   EXSR      MCWAOOFEUS
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOFEBM'
     C                   EXSR      MCWAOOFEBM
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOPERG'
     C                   EXSR      MCWAOOPERG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOBGTE'
     C                   EXSR      MCWAOOBGTE
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE FEAT                                                   ***
     C**************************************************************************
     C     MCWAOOFEAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOOFEAT    KOM(01)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   EXSR      MCFEPA
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  FEPAFEAT      DSWAOOFEAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FEAT                                                   ***
     C**************************************************************************
     C     PRWAOOFEAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSWAOOFEAT    IFEQ      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOFEAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOOFEAT    KYFEPAFEAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHFEPA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE FEAR                                                   ***
     C**************************************************************************
     C     MCWAOOFEAR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOOFEAR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOOFEAT    KOM(01)
     C                   MOVEA(P)  'TRTX53'      KOM(04)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   EXSR      MCFEAZ
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  FEAZUCDE      DSWAOOFEAR
     C                   EXSR      PRWAOOFEAR
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FEAR                                                   ***
     C**************************************************************************
     C     PRWAOOFEAR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOFEAR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT  '      EXTTPGCD
     C                   MOVEL     *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRARTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C*VU                MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL     EXTTTEXT      TXWAOOFEAR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOOFEAT    KYFEAZFEAT
     C                   MOVEL(P)  'TRTX53'      KYFEAZTCDE
     C                   MOVEL(P)  DSWAOOFEAR    KYFEAZUCDE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHFEAZ
     C*
     C     WKFENR        IFNE      *ZERO
     C*VU                MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRARTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX53'      EXTTTCDE
     C                   MOVEL     'TRWAOO'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     DSWAOOFEAR    EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     PCPGST        OREQ      '5     '
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE FEUS                                                   ***
     C**************************************************************************
     C     MCWAOOFEUS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOOFEUS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOOFEAT    KOM(01)
     C                   MOVEA(P)  'TRTX54'      KOM(04)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   EXSR      MCFEAZ
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  FEAZUCDE      DSWAOOFEUS
     C                   EXSR      PRWAOOFEUS
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FEUS                                                   ***
     C**************************************************************************
     C     PRWAOOFEUS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOFEUS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT  '      EXTTPGCD
     C                   MOVEL     *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRUSTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C*VU                MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL     EXTTTEXT      TXWAOOFEUS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOOFEAT    KYFEAZFEAT
     C                   MOVEL(P)  'TRTX54'      KYFEAZTCDE
     C                   MOVEL(P)  DSWAOOFEUS    KYFEAZUCDE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHFEAZ
     C*
     C     WKFENR        IFNE      *ZERO
     C*VU                MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE FEBM                                                   ***
     C**************************************************************************
     C     MCWAOOFEBM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOOFEBM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'F04   '      EXTTPGCD
     C                   MOVEL     *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRBMTXST
     C*
     C     EXTTUCDE      IFNE      *BLANK
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL     EXTTUCDE      DSWAOOFEBM
     C                   EXSR      PRWAOOFEBM
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FEBM                                                   ***
     C**************************************************************************
     C     PRWAOOFEBM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOFEBM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   LEAVESR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT  '      EXTTPGCD
     C                   MOVEL     *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRBMTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL     EXTTTEXT      TXWAOOFEBM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRUSTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX54'      EXTTTCDE
     C                   MOVEL     'TRWAOO'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     DSWAOOFEUS    EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     PCPGST        OREQ      '5     '
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRBMTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX55'      EXTTTCDE
     C                   MOVEL     'TRWAOO'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     DSWAOOFEBM    EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     PCPGST        OREQ      '5     '
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PERG                                                   ***
     C**************************************************************************
     C     MCWAOOPERG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C     DSWAOOPERG    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOOPERG
     C                   ENDIF
     C*-----------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PERG'        KOM(02)
     C                   MOVEA     DSWAOOPERG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOOPERG
     C                   MOVEL(P)  TPTTXT        TXWAOOPERG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PERG                                                   ***
     C**************************************************************************
     C     PRWAOOPERG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOPERG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PERG'        KYTPTA
     C                   MOVEL(P)  DSWAOOPERG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOOPERG
     C                   MOVEL(P)  *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE BGTE                                                   ***
     C**************************************************************************
     C     MCWAOOBGTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  '100'         KOM(1)
     C                   MOVEA     DSLGPOTENR    KOM(4)
     C                   MOVEA     'TV'          KOM(24)
     C                   MOVEL     'TRSL34'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCSLPO
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  SPTENR        DSWAOOBGTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BGTE                                                   ***
     C**************************************************************************
     C     PRWAOOBGTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOBGTE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOOBGTE    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOOBGTE    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  TETENR        DSWAOOBGTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR FORMATE                                         ***
     C**************************************************************************
     C     BILDPR        BEGSR
     C*
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
     C     FLDNAM        WHENEQ    'DSWAOOFBNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOOFBNR
     C     FLDNAM        WHENEQ    'DSWAOOFEAT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOFEAT
     C     FLDNAM        WHENEQ    'DSWAOOFEAR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOFEAR
     C     FLDNAM        WHENEQ    'DSWAOOFEUS'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOFEUS
     C     FLDNAM        WHENEQ    'DSWAOOFEBM'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOFEBM
     C     FLDNAM        WHENEQ    'DSWAOOPERG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOPERG
     C     FLDNAM        WHENEQ    'DSWAOOBGTE'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOOBGTE
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
     C                   Z-ADD     DSWAOONLGJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOONLGN    KYWAOOLGNR
     C                   Z-ADD     DSWAOONLGP    KYWAOOLGPO
     C                   MOVEL(P)  DSWAOONFBN    KYWAOOFBNR
     C                   MOVE      DSWAOONTST    KYWAOOTSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOO
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOONFBN'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL(P)  DSWAOOFBNR    KYWAOOFBNR
     C                   MOVE      DSWAOOTSTP    KYWAOOTSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOO
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOO'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOO          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAOO                                     ***
     C**************************************************************************
     C     KWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL(P)  DSWAOOFBNR    KYWAOOFBNR
     C                   MOVE      DSWAOOTSTP    KYWAOOTSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  WAOOFEAT      DSWAOOFEAT
     C                   MOVEL(P)  WAOOFEAR      DSWAOOFEAR
     C                   MOVEL(P)  WAOOFEUS      DSWAOOFEUS
     C                   MOVEL(P)  WAOOFEBM      DSWAOOFEBM
     C                   MOVEL(P)  WAOOPERG      DSWAOOPERG
     C                   MOVEL(P)  WAOOBGTE      DSWAOOBGTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOO-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYWAOOLGJJ    OFWAOOLGJJ
     C                   MOVEL(P)  KYWAOOLGNR    OFWAOOLGNR
     C                   Z-ADD     KYWAOOLGPO    OFWAOOLGPO
     C                   MOVEL(P)  KYWAOOFBNR    OFWAOOFBNR
     C                   MOVE      KYWAOOTSTP    OFWAOOTSTP
     C     KYWAOOTSTP    IFEQ      WKTMSTNULL
     C     KYWAOOFBNR    IFEQ      *BLANK
     C                   MOVEL     *HIVAL        OFWAOOFBNR
     C                   ENDIF
     C                   MOVEL     *HIVAL        OFWAOOTSTP
     C                   ENDIF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOOFIRM      ANDEQ     KYWAOOFIRM
     C     WAOOLGJJ      ANDLE     OFWAOOLGJJ
     C     WAOOLGNR      ANDLE     OFWAOOLGNR
     C     WAOOLGPO      ANDLE     OFWAOOLGPO
     C     WAOOFBNR      ANDLE     OFWAOOFBNR
     C     WAOOTSTP      ANDLE     OFWAOOTSTP
     C*--------------------------------------------------------
     C     WAOOLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOOLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOO
     C                   MOVEL(P)  WKPROG        RTWAOOPROG
     C                   MOVEL(P)  WKDANA        RTWAOODANA
     C                   MOVEL(P)  WKFFLD        RTWAOOFFLD
     C                   MOVEL(P)  WKFENR        RTWAOOFENR
     C                   MOVEL(P)  W$PA03        RTWAOOPA03
     C                   MOVEL(P)  W$PA04        RTWAOOPA04
     C                   MOVEL(P)  W$PA05        RTWAOOPA05
     C                   MOVEL(P)  W$PA06        RTWAOOPA06
     C                   MOVEL(P)  W$PA07        RTWAOOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOO                                          ***
     C**************************************************************************
     C     LWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYWAOOLGJJ    OFWAOOLGJJ
     C                   MOVEL(P)  KYWAOOLGNR    OFWAOOLGNR
     C                   Z-ADD     KYWAOOLGPO    OFWAOOLGPO
     C                   MOVEL(P)  KYWAOOFBNR    OFWAOOFBNR
     C                   MOVE      KYWAOOTSTP    OFWAOOTSTP
     C     KYWAOOTSTP    IFEQ      WKTMSTNULL
     C     KYWAOOFBNR    IFEQ      *BLANK
     C                   MOVEL     *HIVAL        OFWAOOFBNR
     C                   ENDIF
     C                   MOVEL     *HIVAL        OFWAOOTSTP
     C                   ENDIF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOOFIRM      ANDEQ     KYWAOOFIRM
     C     WAOOLGJJ      ANDLE     OFWAOOLGJJ
     C     WAOOLGNR      ANDLE     OFWAOOLGNR
     C     WAOOLGPO      ANDLE     OFWAOOLGPO
     C     WAOOFBNR      ANDLE     OFWAOOFBNR
     C     WAOOTSTP      ANDLE     OFWAOOTSTP
     C*
     C                   EXSR      LPOSI
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     WAOOLGJJ      KYWAOOLGJJ
     C                   MOVEL(P)  WAOOLGNR      KYWAOOLGNR
     C                   Z-ADD     WAOOLGPO      KYWAOOLGPO
     C                   MOVEL(P)  WAOOFBNR      KYWAOOFBNR
     C                   MOVE      WAOOTSTP      KYWAOOTSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOO
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOO
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOO
     C                   MOVEL(P)  WKPROG        RTWAOOPROG
     C                   MOVEL(P)  WKDANA        RTWAOODANA
     C                   MOVEL(P)  WKFFLD        RTWAOOFFLD
     C                   MOVEL(P)  WKFENR        RTWAOOFENR
     C                   MOVEL(P)  W$PA03        RTWAOOPA03
     C                   MOVEL(P)  W$PA04        RTWAOOPA04
     C                   MOVEL(P)  W$PA05        RTWAOOPA05
     C                   MOVEL(P)  W$PA06        RTWAOOPA06
     C                   MOVEL(P)  W$PA07        RTWAOOPA07
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
     C                   MOVEL(P)  EXWAOOFBNR    DSWAOOFBNR
     C                   MOVE      EXWAOOTSTP    DSWAOOTSTP
     C                   MOVEL(P)  EXWAOOFEAT    DSWAOOFEAT
     C                   MOVEL(P)  EXWAOOFEAR    DSWAOOFEAR
     C                   MOVEL(P)  EXWAOOFEUS    DSWAOOFEUS
     C                   MOVEL(P)  EXWAOOFEBM    DSWAOOFEBM
     C                   MOVEL(P)  EXWAOOPERG    DSWAOOPERG
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXWAOOFLDN    WHENEQ    'WAOOFBNR'
     C                   EXSR      PRWAOOFBNR
     C     EXWAOOFLDN    WHENEQ    'WAOOFEAT'
     C                   EXSR      PRWAOOFEAT
     C     EXWAOOFLDN    WHENEQ    'WAOOFEAR'
     C                   EXSR      PRWAOOFEAR
     C     EXWAOOFLDN    WHENEQ    'WAOOFEUS'
     C                   EXSR      PRWAOOFEUS
     C     EXWAOOFLDN    WHENEQ    'WAOOFEBM'
     C                   EXSR      PRWAOOFEBM
     C     EXWAOOFLDN    WHENEQ    'WAOOPERG'
     C                   EXSR      PRWAOOPERG
     C                   OTHER
     C                   MOVEL     'TRWAOO01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOO
     C                   MOVEL(P)  WKPROG        RTWAOOPROG
     C                   MOVEL(P)  WKDANA        RTWAOODANA
     C                   MOVEL(P)  WKFFLD        RTWAOOFFLD
     C                   MOVEL(P)  WKFENR        RTWAOOFENR
     C                   MOVEL(P)  W$PA03        RTWAOOPA03
     C                   MOVEL(P)  W$PA04        RTWAOOPA04
     C                   MOVEL(P)  W$PA05        RTWAOOPA05
     C                   MOVEL(P)  W$PA06        RTWAOOPA06
     C                   MOVEL(P)  W$PA07        RTWAOOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAOOIFKZ    IFEQ      '0'
     C                   Z-ADD     EXWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  EXWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     EXWAOOLGPO    KYWAOOLGPO
     C                   MOVEL(P)  EXWAOOFBNR    KYWAOOFBNR
     C                   MOVE      EXWAOOTSTP    KYWAOOTSTP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOO
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
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOO01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAOO
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOO
     C                   MOVEL(P)  WKPROG        RTWAOOPROG
     C                   MOVEL(P)  WKDANA        RTWAOODANA
     C                   MOVEL(P)  WKFFLD        RTWAOOFFLD
     C                   MOVEL(P)  WKFENR        RTWAOOFENR
     C                   MOVEL(P)  W$PA03        RTWAOOPA03
     C                   MOVEL(P)  W$PA04        RTWAOOPA04
     C                   MOVEL(P)  W$PA05        RTWAOOPA05
     C                   MOVEL(P)  W$PA06        RTWAOOPA06
     C                   MOVEL(P)  W$PA07        RTWAOOPA07
     C*-------------------------------------------------------------------------
     C     K#WAOOLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOO                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOO                                                 ***
     C**************************************************************************
     C     UWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL(P)  DSWAOOFBNR    KYWAOOFBNR
     C                   MOVE      DSWAOOTSTP    KYWAOOTSTP
     C*
     C     PCPGST        IFEQ      '3     '
     C                   Z-ADD     DSWAOONLGJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOONLGN    KYWAOOLGNR
     C                   Z-ADD     DSWAOONLGP    KYWAOOLGPO
     C                   MOVEL(P)  DSWAOONFBN    KYWAOOFBNR
     C                   MOVE      DSWAOONTST    KYWAOOTSTP
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOOFEAT    WAOOFEAT
     C                   MOVEL(P)  DSWAOOFEAR    WAOOFEAR
     C                   MOVEL(P)  DSWAOOFEUS    WAOOFEUS
     C                   MOVEL(P)  DSWAOOFEBM    WAOOFEBM
     C                   MOVEL(P)  DSWAOOPERG    WAOOPERG
     C                   MOVEL(P)  DSWAOOBGTE    WAOOBGTE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOOJNAM
     C                   MOVEL(P)  DAPROG        WAOOPROG
     C                   MOVEL(P)  WKCHPL        WAOOBIBL
     C                   MOVEL(P)  DAUSER        WAOOUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOOJZEI
     C                   MOVE      WKTDAT        WAOOJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOO
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    WAOOTSTP
     C                   MOVEL(P)  DAUSER        WAOOERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOO
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOO
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LGFB                                                 ***
     C**************************************************************************
     C     ULGFB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    KYLGFBLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYLGFBLGNR
     C                   Z-ADD     DSWAOOLGPO    KYLGFBLGPO
     C                   MOVEL(P)  DSWAOOFBNR    KYLGFBFBNR
     C*
     C     PCPGST        IFEQ      '3     '
     C                   Z-ADD     DSWAOONLGJ    KYLGFBLGJJ
     C                   MOVEL(P)  DSWAOONLGN    KYLGFBLGNR
     C                   Z-ADD     DSWAOONLGP    KYLGFBLGPO
     C                   MOVEL(P)  DSWAOONFBN    KYLGFBFBNR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLGFB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        LGFBJNAM
     C                   MOVEL(P)  DAPROG        LGFBPROG
     C                   MOVEL(P)  WKCHPL        LGFBBIBL
     C                   MOVEL(P)  DAUSER        LGFBUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LGFBJZEI
     C                   MOVE      WKTDAT        LGFBJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHLGFB
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    LGFBTSTP
     C                   MOVEL(P)  DAUSER        LGFBERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLGFB
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLGFB
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGNR                                                   ***
     C**************************************************************************
     C     PRWAOOLGNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOLGNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    KYLGKOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYLGKOLGNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGKO
     C*
     C                   MOVEL(P)  LGKOKDNR      DSLGKOKDNR
     C                   MOVEL(P)  DSLGKOKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C*
     C                   MOVEL(P)  LGKORTNR      DSLGKORTNR
     C*
     C                   MOVEL(P)  LGKOLGAT      DSLGKOLGAT
     C                   MOVEL(P)  DSLGKOLGAT    KYLGPALGAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPA
     C                   MOVEL(P)  LGPAABEZ      TXLGKOLGAT
     C*
     C                   MOVEL(P)  LGKOWKNR      DSLGKOWKNR
     C                   MOVEL(P)  DSLGKOWKNR    KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXLGKOWKNR
     C*
     C                   MOVEL(P)  LGKOEXBL      DSLGKOEXBL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGPO                                                   ***
     C**************************************************************************
     C     PRWAOOLGPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOLGPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    KYLGPOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYLGPOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYLGPOLGPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPO
     C*
     C                   MOVEL(P)  LGPOTENR      DSLGPOTENR
     C                   MOVEL(P)  LGPOTBZ1      DSLGPOTBZ1
     C                   MOVEL(P)  LGPOTBZ2      DSLGPOTBZ2
     C*
     C                   Z-ADD     LGPOSOMG      DSLGPOSOMG
     C                   Z-ADD     LGPOISMG      DSLGPOISMG
     C*
     C     LGPOSOMG      SUB       LGPOISMG      DSLGPOOFMG
     C     DSLGPOOFMG    IFLT      *ZERO
     C                   Z-ADD     *ZERO         DSLGPOOFMG
     C                   ENDIF
     C*
     C                   MOVEL(P)  LGPOMEIN      DSLGPOMEIN
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  DSLGPOMEIN    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXLGPOMEIN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FBNR                                                   ***
     C**************************************************************************
     C     PRWAOOFBNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOFBNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOOFBNR    IFEQ      *BLANK
     C*                  MOVE      '0031'        WKFENR
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
     C                   MOVEL(P)  'WAOO'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOO
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOO'        EXDATAFILE
     C                   MOVEL(P)  WAOO          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI NEUANLAGE                               ***
     C**************************************************************************
     C     NWAOO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOOPERG    WAOOPERG
     C                   MOVEL(P)  DSWAOOFEAR    WAOOFEAR
     C                   MOVEL(P)  DSWAOOFEUS    WAOOFEUS
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
     C                   MOVEL(P)  'TRWAOO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  'TRWAOO'      EXTRDNPGNA
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
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTEST
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
     C     *LIKE         DEFINE    #CPGST        PCPGSTSAV
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOOLGJJ    OFWAOOLGJJ
     C     *LIKE         DEFINE    KYWAOOLGNR    OFWAOOLGNR
     C     *LIKE         DEFINE    KYWAOOLGPO    OFWAOOLGPO
     C     *LIKE         DEFINE    KYWAOOFBNR    OFWAOOFBNR
     C     *LIKE         DEFINE    KYWAOOTSTP    OFWAOOTSTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOOLGJJ    DSWAOONLGJ
     C     *LIKE         DEFINE    KYWAOOLGNR    DSWAOONLGN
     C     *LIKE         DEFINE    KYWAOOLGPO    DSWAOONLGP
     C     *LIKE         DEFINE    KYWAOOFBNR    DSWAOONFBN
     C     *LIKE         DEFINE    KYWAOOTSTP    DSWAOONTST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOOTSTP    DSWAOOTSTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOOPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOODANA    WKDANA
     C     *LIKE         DEFINE    RTWAOOFFLD    WKFFLD
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
     C                   MOVEL(P)  'TRWAOO'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C                   OTHER
     C                   WRITE     TRWAOOCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   OTHER
     C                   WRITE     TRWAOOCT
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
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHWAOO
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPA
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHLGFB
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHFEPA
     C/COPY QCPYSRC,CHFEAZ
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCSLPO
     C/COPY QCPYSRC,MCFEPA
     C/COPY QCPYSRC,MCFEAZ
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRTX50
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
