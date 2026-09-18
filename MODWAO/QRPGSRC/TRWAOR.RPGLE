     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2012')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOR
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 12.07.2012 Projekt 8587
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 16.08.2013 Projekt 9659 neues Feld Gewicht
     H*  Änderung: ZG 16.05.2014 Projekt 10273 neues Feld Versand-Bed-Gruppe
     H*  Änderung: ZG 10.07.2015 Projekt 11466 neues Feld Sortierung Anz.Pos.
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOR.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAORFM  CF   E             WORKSTN USROPN
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
     D*
     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ
     D*
     D WAOR          E DS                  INZ
     D KYWAOR        E DS                  INZ
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
     D EXTREND       E DS
     D RTTREND       E DS
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
     D EXWAOR          DS                  INZ
     D  EXWAORPRKZ                  256
     D   EXWAORIFKZ                   1    OVERLAY(EXWAORPRKZ:*NEXT)
     D  EXWAORKEYB                  256
     D   EXWAORVSBD                        OVERLAY(EXWAORKEYB:*NEXT)
     D                                     LIKE(WAORVSBD)
     D  EXWAORNKEY                  256
     D   EXWAORNVSB                        OVERLAY(EXWAORNKEY:*NEXT)
     D                                     LIKE(WAORVSBD)
     D  EXWAORDATE                 1024
     D   EXWAOREXPO                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAOREXPO)
     D   EXWAORAZAF                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORAZAF)
     D   EXWAORPOAZ                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORPOAZ)
     D   EXWAORSTAZ                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORSTAZ)
     D   EXWAORGEWT                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORGEWT)
     D   EXWAORVBGR                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORVBGR)
     D   EXWAORSOPO                        OVERLAY(EXWAORDATE:*NEXT)
     D                                     LIKE(WAORSOPO)
     C*
     D RTWAOR          DS                  INZ
     D  RTWAORKEYB                  256
     D   RTWAORVSBD                        OVERLAY(RTWAORKEYB:*NEXT)
     D                                     LIKE(WAORVSBD)
     D  RTWAORNKEY                  256
     D   RTWAORNVSB                        OVERLAY(RTWAORNKEY:*NEXT)
     D                                     LIKE(WAORVSBD)
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
     C                   CLOSE     TRWAORFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERGWGR'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C                   Z-ADD     WAORGEWT      DUN091
     C                   MOVEL(P)  DUC009        RTTRNDDATE
     C                   EVAL      %SUBST(RTTRNDDATE: 10: 3) = WAORVBGR
     C                   EVAL      %SUBST(RTTRNDDATE: 13: 1) = WAORSOPO
     C                   MOVEL     WKFENR        RTTRNDFENR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERVBGR'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVEL     WAORVBGR      RTTRNDDATE
     C                   MOVEL     WKFENR        RTTRNDFENR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOR '
     C                   EXSR      PWAOR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOR
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAORIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOR                                       UPDATE
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
     C                   OPEN      TRWAORFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRWAORFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
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
     C                   MOVEL(P)  DAFIRM        KYVBFI                         VSBD
     C                   MOVEL(P)  DAFIRM        KYWAORFIRM                     WAOR
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAORFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAORFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXTREND'     EXDATAFILE
     C                   MOVEL(P)  EXTREND       EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C                   MOVEL(P)  EXTRNDPRKZ    EXWAORPRKZ
     C*--------------------------------------------------------
     C                   CLEAR                   EXWAORKEYB
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXWAORVSBD
     C*
     C                   MOVEL(P)  EXWAORVSBD    KYWAORVSBD
     C*
     C                   MOVEL(P)  EXWAORVSBD    DSWAORVSBD
     C*--------------------------------------------------------
     C                   CLEAR                   EXWAORNKEY
     C                   MOVEA(P)  EXTRNDNKEY    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXWAORNVSB
     C*
     C                   MOVEL(P)  EXWAORNVSB    DSWAORNVSB
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
     C                   MOVEL(P)  'TRWAOR'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C**                 MOVEA(P)  W99           DSKOPF
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
     C                   MOVEL     'TRWAOR01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAORW2
     C                   WRITE     TRWAOR01
     C                   WRITE     W2WAORB1
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
     C                   READ      TRWAOR01                             9899
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
     C                   EXSR      UWAOR
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
     C                   MOVEL     *BLANK        KYWAORVSBD
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOR
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOR
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
     C                   CLEAR                   WAOR
     C                   EXSR      ETRMU
     C                   EXSR      EWAOR
     C                   MOVEL(P)  KYWAORVSBD    WAORVSBD
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVEL(P)  WAORUSER      WKUSER
     C                   Z-ADD     WAORJDAT      WKJDAT
     C                   Z-ADD     WAORJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOR
     C                   EXSR      EWAOR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAORVSBD      DSWAORVSBD
     C*
     C                   MOVEL(P)  WAOREXPO      DSWAOREXPO
     C                   Z-ADD     WAORAZAF      DSWAORAZAF
     C                   Z-ADD     WAORPOAZ      DSWAORPOAZ
     C                   Z-ADD     WAORSTAZ      DSWAORSTAZ
     C                   Z-ADD     WAORGEWT      DSWAORGEWT
     C                   MOVEL(P)  WAORVBGR      DSWAORVBGR
     C                   MOVEL(P)  WAORSOPO      DSWAORSOPO
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAORVSBD                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOREXPO                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAORVBGR                                  N
     C                   MOVEL     *BLANK        TXWAORSOPO                                  N
     C*-------------------------------------------------------------------------
     C     DSWAORVSBD    CASNE     *BLANK        PRWAORVSBD                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOREXPO    CASNE     *BLANK        PRWAOREXPO
     C                   ENDCS
     C     DSWAORVBGR    CASNE     *BLANK        PRWAORVBGR
     C                   ENDCS
     C     DSWAORSOPO    CASNE     *BLANK        PRWAORSOPO
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOR01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOREXPO'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOREXPO'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSWAORVSBD'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAORK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAORW2
     C                   WRITE     TRWAORK1
     C                   WRITE     W2WAORB1
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
     C                   READ      TRWAORK1                             9899
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
     C                   EXSR      KWAOR
     C                   EXSR      UWAOR
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAORVSBD    RTWAORVSBD
     C*
     C                   MOVEA(P)  RTWAORVSBD    KOM(01)
     C                   MOVEA(P)  KOM           RTTRNDKEYB
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
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
     C                   MOVEL(P)  KYWAORVSBD    DSWAORVSBD
     C*
     C                   MOVEL(P)  *BLANK        DSWAORNVSB
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORNVSB'  EXFLPOFLDN
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
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAORVSBD'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOREXPO'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAORVSBD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAORVSBD'
     C                   EXSR      MCWAORVSBD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOREXPO'
     C                   EXSR      MCWAOREXPO
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAORNVSB'
     C                   EXSR      MCWAORNVSB
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAORVBGR'
     C                   EXSR      MCWAORVBGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAORSOPO'
     C                   EXSR      MCWAORSOPO
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
     C     FLDNAM        WHENEQ    'DSWAORVSBD'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAORVSBD
     C     FLDNAM        WHENEQ    'DSWAOREXPO'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOREXPO
     C     FLDNAM        WHENEQ    'DSWAORAZAF'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORAZAF
     C     FLDNAM        WHENEQ    'DSWAORPOAZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORPOAZ
     C     FLDNAM        WHENEQ    'DSWAORSTAZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORSTAZ
     C     FLDNAM        WHENEQ    'DSWAORGEWT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORGEWT
     C     FLDNAM        WHENEQ    'DSWAORVBGR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORVBGR
     C     FLDNAM        WHENEQ    'DSWAORSOPO'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAORSOPO
     C     FLDNAM        WHENEQ    'DSWAORNVSB'
     C                   EXSR      PRWAORNVSB
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
     C                   MOVEL(P)  DSWAORNVSB    KYWAORVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAORNVSB'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAORVSBD    KYWAORVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAORVSBD'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAORVSBD'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOR'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOR          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAOR                                     ***
     C**************************************************************************
     C     KWAOR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAORVSBD    KYWAORVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  WAOREXPO      DSWAOREXPO
     C                   Z-ADD     WAORAZAF      DSWAORAZAF
     C                   Z-ADD     WAORPOAZ      DSWAORPOAZ
     C                   Z-ADD     WAORSTAZ      DSWAORSTAZ
     C                   Z-ADD     WAORGEWT      DSWAORGEWT
     C                   MOVEL(P)  WAORVBGR      DSWAORVBGR
     C                   MOVEL(P)  WAORSOPO      DSWAORSOPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOR-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAORVSBD    OFWAORVSBD
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAORFIRM      ANDEQ     KYWAORFIRM
     C     WAORVSBD      ANDLE     OFWAORVSBD
     C*--------------------------------------------------------
     C     WAORLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAORLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOR                                          ***
     C**************************************************************************
     C     LWAOR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAORVSBD    OFWAORVSBD
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAORFIRM      ANDEQ     KYWAORFIRM
     C     WAORVSBD      ANDLE     OFWAORVSBD
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAORVSBD      KYWAORVSBD
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOR
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOR
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOR
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
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
     C                   MOVEL(P)  EXWAOREXPO    DSWAOREXPO
     C                   Z-ADD     EXWAORAZAF    DSWAORAZAF
     C                   Z-ADD     EXWAORPOAZ    DSWAORPOAZ
     C                   Z-ADD     EXWAORSTAZ    DSWAORSTAZ
     C                   Z-ADD     EXWAORGEWT    DSWAORGEWT
     C                   MOVEL(P)  EXWAORVBGR    DSWAORVBGR
     C                   MOVEL(P)  EXWAORSOPO    DSWAORSOPO
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRWAOR01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAORIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAORVSBD    KYWAORVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
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
     C     EXWAOREXPO    IFNE      *BLANK
     C                   MOVEL(P)  EXWAOREXPO    DSWAOREXPO
     C                   ENDIF
     C*
     C     EXWAORAZAF    IFNE      *ZERO
     C                   MOVEL(P)  EXWAORAZAF    DSWAORAZAF
     C                   ENDIF
     C*
     C     EXWAORPOAZ    IFNE      *ZERO
     C                   Z-ADD     EXWAORPOAZ    DSWAORPOAZ
     C                   ENDIF
     C*
     C     EXWAORSTAZ    IFNE      *ZERO
     C                   Z-ADD     EXWAORSTAZ    DSWAORSTAZ
     C                   ENDIF
     C*
     C     EXWAORGEWT    IFNE      *ZERO
     C                   Z-ADD     EXWAORGEWT    DSWAORGEWT
     C                   ENDIF
     C*
     C     EXWAORVBGR    IFNE      *BLANK
     C                   MOVEL(P)  EXWAORVBGR    DSWAORVBGR
     C                   ENDIF
     C*
     C     EXWAORSOPO    IFNE      *BLANK
     C                   MOVEL(P)  EXWAORSOPO    DSWAORSOPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOR01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAOR
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C     K#WAORLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOR                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOR                                                 ***
     C**************************************************************************
     C     UWAOR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAORVSBD    KYWAORVSBD
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAORNVSB    KYWAORVSBD
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOREXPO    WAOREXPO
     C                   Z-ADD     DSWAORAZAF    WAORAZAF
     C                   Z-ADD     DSWAORPOAZ    WAORPOAZ
     C                   Z-ADD     DSWAORSTAZ    WAORSTAZ
     C                   Z-ADD     DSWAORGEWT    WAORGEWT
     C                   MOVEL(P)  DSWAORVBGR    WAORVBGR
     C                   MOVEL(P)  DSWAORSOPO    WAORSOPO
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAORJNAM
     C                   MOVEL(P)  DAPROG        WAORPROG
     C                   MOVEL(P)  WKCHPL        WAORBIBL
     C                   MOVEL(P)  DAUSER        WAORUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAORJZEI
     C                   MOVE      WKTDAT        WAORJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOR
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL     DUN120        WAORERZT
     C                   MOVE      WKTDAT        WAORERDA
     C                   MOVEL(P)  DAUSER        WAORERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOR
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOR
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VSBD                                                   ***
     C**************************************************************************
     C     MCWAORVSBD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAORVSBD    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAORVSBD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'VSBD'        KOM(02)
     C                   MOVEA     DSWAORVSBD    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAORVSBD
     C                   MOVEL(P)  TPTTXT        TXWAORVSBD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VSBD                                                   ***
     C**************************************************************************
     C     PRWAORVSBD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORVSBD'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAORVSBD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'VSBD'        KYTPTA
     C                   MOVEL(P)  DSWAORVSBD    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFNE      *ZERO
     C     DSWAORVSBD    ANDNE     *BLANK
     C                   MOVEL(P)  '$$WAORVBGR'  KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSWAORVSBD    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*
     C                   MOVEL(P)  TPTTXT        TXWAORVSBD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE EXPO                                                   ***
     C**************************************************************************
     C     MCWAOREXPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOREXPO    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOREXPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ    '    EXTRPCPGGR
     C                   MOVEL(P)  DSWAOREXPO    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOREXPO
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOREXPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE EXPO                                                   ***
     C**************************************************************************
     C     PRWAOREXPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOREXPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ    '    EXTRPCPGGR
     C                   MOVEL(P)  DSWAOREXPO    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOREXPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE SOPO                                                   ***
     C**************************************************************************
     C     MCWAORSOPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAORSOPO    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAORSOPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ    '    EXTRPCPGGR
     C                   MOVEL(P)  DSWAORSOPO    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAORSOPO
     C                   MOVEL(P)  EXTRPCTEXT    TXWAORSOPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SOPO                                                   ***
     C**************************************************************************
     C     PRWAORSOPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAORSOPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ    '    EXTRPCPGGR
     C                   MOVEL(P)  DSWAORSOPO    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAORSOPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE AZAF                                                   ***
     C**************************************************************************
     C     PRWAORAZAF    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORAZAF'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAORAZAF<=0
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE POAZ                                                   ***
     C**************************************************************************
     C     PRWAORPOAZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORPOAZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAORPOAZ<=0
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE STAZ                                                   ***
     C**************************************************************************
     C     PRWAORSTAZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORSTAZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAORSTAZ<0
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GEWT                                                   ***
     C**************************************************************************
     C     PRWAORGEWT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORGEWT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAORGEWT<0
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VBGR                                                   ***
     C**************************************************************************
     C     MCWAORVBGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAORVBGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAORVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAORVBGR'  KOM(02)
     C                   MOVEA     DSWAORVBGR    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAORVBGR
     C                   MOVEL(P)  TPTTXT        TXWAORVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VBGR                                                   ***
     C**************************************************************************
     C     PRWAORVBGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAORVBGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAORVBGR
     C*-------------------------------------------------------------------------
     C     DSWAORVBGR    IFNE      *BLANK
     C                   MOVEL(P)  '$$WAORVBGR'  KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSWAORVBGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAORVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NVSB                                                   ***
     C**************************************************************************
     C     MCWAORNVSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'VSBD'        KOM(02)
     C                   MOVEA     DSWAORNVSB    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAORNVSB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NVSB                                                   ***
     C**************************************************************************
     C     PRWAORNVSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAORNVSB'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'VSBD'        KYTPTA
     C                   MOVEL(P)  DSWAORNVSB    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFNE      *ZERO
     C     DSWAORVSBD    ANDNE     *BLANK
     C                   MOVEL(P)  '$$WAORVBGR'  KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSWAORNVSB    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOR'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOR
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOR'        EXDATAFILE
     C                   MOVEL(P)  WAOR          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WAOREXPO      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        WAOREXPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAORAZAF      IFEQ      *ZERO
     C                   Z-ADD     WKTRPAAZAF    WAORAZAF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAORPOAZ      IFEQ      *ZERO
     C                   Z-ADD     WKTRPAPOAZ    WAORPOAZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAORSOPO      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        WAORSOPO
     C                   ENDIF
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
     C                   MOVEL(P)  'TRWAOR'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODXXX'      KYTATC
     C                   MOVEL(P)  'MODXXX'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODXXX
     C*
     C     MODXXX        IFNE      *ON
     C                   MOVE      *OFF          MODXXX
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'QQQQ'        KYTATC
     C                   MOVEL(P)  'QQQQ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAQQQQ
     C*
     C     WKTRPAQQQQ    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAQQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODYYY'      KYTATC
     C                   MOVEL(P)  'MODYYY'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODYYY
     C                   ELSE
     C                   MOVE      *OFF          MODYYY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'ANZLAFNR'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL     TAPCDE        DUC003
     C                   TESTN                   DUC003               97
     C     *IN(97)       IFNE      '1'
     C                   Z-ADD     3             WKTRPAAZAF
     C                   ELSE
     C                   MOVEL     TAPCDE        WKTRPAAZAF
     C                   ENDIF
     C*---------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'ANZLAFPO'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL     TAPCDE        DUC003
     C                   TESTN                   DUC003               97
     C     *IN(97)       IFNE      '1'
     C                   Z-ADD     4             WKTRPAPOAZ
     C                   ELSE
     C                   MOVEL     TAPCDE        WKTRPAPOAZ
     C                   ENDIF
     C*-------------------------------------------------------------------
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
     C                   MOVEL(P)  'TRWAOR'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAORB1'    EXTRDNPGNA
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
     C     EXTRDNDANA    WHENEQ    'TRTK'
     C                   EXSR      MCAUFRTRTK
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
     C     *LIKE         DEFINE    WKC001        MODXXX
     C     *LIKE         DEFINE    WKC001        MODYYY
     C     *LIKE         DEFINE    WKC001        WKTRPAQQQQ
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
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
     C     *LIKE         DEFINE    WKN010        WKTRPAAZAF      + 2
     C     *LIKE         DEFINE    WKN010        WKTRPAPOAZ      + 2
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
     C     *LIKE         DEFINE    KYWAORVSBD    OFWAORVSBD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
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
     C                   MOVEL(P)  'TRWAOR'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAORW2
     C                   OTHER
     C                   WRITE     CTWAORW2
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAORW2
     C                   OTHER
     C                   WRITE     CTWAORW2
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
     C/COPY QCPYSRC,CHVSBD
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOR
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
