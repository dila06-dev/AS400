     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei WAO6
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 22.07.2010 für Kunde Waeco Projekt 6231
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAO6.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAO6FM  CF   E             WORKSTN USROPN
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
     D WAO6          E DS                  INZ
     D KYWAO6        E DS                  INZ
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
     D  EXWAO6KEYB                  256
     D   EXWAO6TENR                  15    OVERLAY(EXWAO6KEYB:1)
     D   EXWAO6LPTY                   2    OVERLAY(EXWAO6KEYB:16)
     D*
     D  EXWAO6NKEY                  256
     D   EXWAO6NTEN                  15    OVERLAY(EXWAO6NKEY:1)
     D   EXWAO6NLPT                   2    OVERLAY(EXWAO6NKEY:16)
     D*
     D  EXWAO6DATE                 1024
     D   EXWAO6BZMG                  11  2 OVERLAY(EXWAO6DATE:1)
     D   EXWAO6B2MG                  11  2 OVERLAY(EXWAO6DATE:12)
     D*
     D  RTWAO6KEYB                  256
     D   RTWAO6TENR                  15    OVERLAY(RTWAO6KEYB:1)
     D   RTWAO6LPTY                   2    OVERLAY(RTWAO6KEYB:16)
     D*
     D  RTWAO6DATE                 1024
     D   RTWAO6BZMG                  11  2 OVERLAY(RTWAO6DATE:1)
     D   RTWAO6B2MG                  11  2 OVERLAY(RTWAO6DATE:12)
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
     C                   EXSR      UEBTRND
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
     C                   CLOSE     TRWAO6FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAO6 '
     C                   EXSR      PWAO6
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAO6
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAO6
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERLPTY'                                     EXTERNE PRÜFUNG
     C                   EXSR      ERLPTY
     C*
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
     C                   OPEN      TRWAO6FM                             98
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
     C                   CLOSE     TRWAO6FM                             98
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
     C                   MOVEL(P)  DAFIRM        KYWAO6FIRM                     WAO6
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAO6FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAO6FM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTRND                         ***
     C**************************************************************************
     C     UEBTRND       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C                   MOVEL(P)  EXTRNDKEYB    EXWAO6KEYB
     C                   MOVEL(P)  EXTRNDNKEY    EXWAO6NKEY
     C*
     C                   MOVEL(P)  EXWAO6TENR    KYWAO6TENR
     C                   MOVEL(P)  EXWAO6LPTY    KYWAO6LPTY
     C*
     C                   MOVEL(P)  EXWAO6TENR    DSWAO6TENR
     C                   MOVEL(P)  EXWAO6LPTY    DSWAO6LPTY
     C*
     C                   MOVEL(P)  EXWAO6NTEN    DSWAO6NTEN
     C                   MOVEL(P)  EXWAO6NLPT    DSWAO6NLPT
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
     C                   MOVEL(P)  'TRWAO6'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF           70
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
     C                   MOVEL     'TRWAO601'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAO6W2
     C                   WRITE     TRWAO601
     C                   WRITE     W2WAO6B1
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
     C                   READ      TRWAO601                             9899
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
     C                   EXSR      UWAO6
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
     C                   MOVE      *BLANK        KYWAO6TENR
     C                   MOVE      *BLANK        KYWAO6LPTY
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO6
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAO6
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
     C                   CLEAR                   WAO6
     C                   EXSR      ETRMU
     C                   EXSR      EWAO6
     C                   MOVEL(P)  KYWAO6TENR    WAO6TENR
     C                   MOVEL(P)  KYWAO6LPTY    WAO6LPTY
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO6
     C                   MOVEL(P)  WAO6USER      WKUSER
     C                   Z-ADD     WAO6JDAT      WKJDAT
     C                   Z-ADD     WAO6JZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAO6
     C                   EXSR      EWAO6
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO6TENR      DSWAO6TENR
     C                   MOVEL(P)  WAO6LPTY      DSWAO6LPTY
     C                   Z-ADD     WAO6BZMG      DSWAO6BZMG
     C                   Z-ADD     WAO6B2MG      DSWAO6B2MG
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSTENRTBZ1                     INITIALISIEREN
     C                   MOVE      *BLANK        DSTENRTBZ2
     C                   MOVE      *BLANK        TXWAO6LPTY                     TEXTFELDER
     C                   MOVE      *BLANK        TXBZMGMEIN                     TEXTFELDER
     C                   MOVE      *BLANK        TXB2MGMEIN                     TEXTFELDER
     C*-------------------------------------------------------------------------
     C     DSWAO6TENR    CASNE     *BLANK        PRWAO6TENR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAO6LPTY    CASNE     *BLANK        PRWAO6LPTY
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAO601'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAO6BZMG'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAO6BZMG'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSWAO6TENR'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAO6K1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAO6W2
     C                   WRITE     TRWAO6K1
     C                   WRITE     W2WAO6B1
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
     C                   READ      TRWAO6K1                             9899
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
     C                   EXSR      KWAO6
     C                   EXSR      UWAO6
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAO6TENR    RTWAO6TENR
     C                   MOVEL(P)  KYWAO6LPTY    RTWAO6LPTY
     C                   MOVEL(P)  RTWAO6KEYB    RTTRNDKEYB
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
     C                   MOVEL(P)  KYWAO6TENR    DSWAO6TENR
     C                   MOVEL(P)  KYWAO6LPTY    DSWAO6LPTY
     C*
     C                   MOVEL(P)  KYWAO6TENR    DSWAO6NTEN
     C                   MOVE      *BLANK        DSWAO6NLPT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6NLPT'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAO6TENR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO6LPTY'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO6BZMG'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO6B2MG'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAO6TENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO6TENR'
     C                   EXSR      MCWAO6TENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO6LPTY'
     C                   EXSR      MCWAO6LPTY
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO6NTEN'
     C                   EXSR      MCWAO6NTEN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO6NLPT'
     C                   EXSR      MCWAO6NLPT
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
     C     FLDNAM        WHENEQ    'DSWAO6TENR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO6TENR
     C     FLDNAM        WHENEQ    'DSWAO6LPTY'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO6LPTY
     C     FLDNAM        WHENEQ    'DSWAO6BZMG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO6BZMG
     C     FLDNAM        WHENEQ    'DSWAO6B2MG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO6B2MG
     C     FLDNAM        WHENEQ    'DSWAO6NTEN'
     C                   EXSR      PRWAO6NTEN
     C     FLDNAM        WHENEQ    'DSWAO6NLPT'
     C                   EXSR      PRWAO6NLPT
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
     C                   MOVEL(P)  DSWAO6NTEN    KYWAO6TENR
     C                   MOVEL(P)  DSWAO6NLPT    KYWAO6LPTY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO6
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAO6NLPT'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      '      '
     C                   MOVEL(P)  DSWAO6TENR    KYWAO6TENR
     C                   MOVEL(P)  DSWAO6LPTY    KYWAO6LPTY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO6
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAO6TENR'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAO6TENR'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAO6'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO6          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAO6                                     ***
     C**************************************************************************
     C     KWAO6         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6TENR    KYWAO6TENR
     C                   MOVEL(P)  DSWAO6LPTY    KYWAO6LPTY
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO6
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     WAO6BZMG      DSWAO6BZMG
     C                   Z-ADD     WAO6B2MG      DSWAO6B2MG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAO6-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAO6         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAO6TENR    OFWAO6TENR
     C                   MOVEL(P)  KYWAO6LPTY    OFWAO6LPTY
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO6
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO6FIRM      ANDEQ     KYWAO6FIRM
     C     WAO6TENR      ANDLE     OFWAO6TENR
     C     WAO6LPTY      ANDLE     OFWAO6LPTY
     C*--------------------------------------------------------
     C     WAO6LOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAO6LOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO6
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
     C***  LÖSCHEN SÄTZE DATEI WAO6                                          ***
     C**************************************************************************
     C     LWAO6         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAO6TENR    OFWAO6TENR
     C                   MOVEL(P)  KYWAO6LPTY    OFWAO6LPTY
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO6
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO6FIRM      ANDEQ     KYWAO6FIRM
     C     WAO6TENR      ANDLE     OFWAO6TENR
     C     WAO6LPTY      ANDLE     OFWAO6LPTY
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAO6TENR      KYWAO6TENR
     C                   MOVEL(P)  WAO6LPTY      KYWAO6LPTY
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO6
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAO6
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO6
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
     C                   MOVEL(P)  EXTRNDDATE    EXWAO6DATE
     C                   Z-ADD     EXWAO6BZMG    DSWAO6BZMG
     C                   Z-ADD     EXWAO6B2MG    DSWAO6B2MG
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*    EXTRNDFLDN    WHENEQ    'WAO6BZMG'
     C*                  EXSR      PRWAO6BZMG
     C*    EXTRNDFLDN    WHENEQ    'WAO6B2MG'
     C*                  EXSR      PRWAO6B2MG
     C                   OTHER
     C                   MOVEL     'TRWAO601'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
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
     C***  UPDATE DATEI WAO6                                                 ***
     C**************************************************************************
     C     UWAO6         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6TENR    KYWAO6TENR
     C                   MOVEL(P)  DSWAO6LPTY    KYWAO6LPTY
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAO6NTEN    KYWAO6TENR
     C                   MOVE(P)   DSWAO6NLPT    KYWAO6LPTY
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO6
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6BZMG    WAO6BZMG
     C                   Z-ADD     DSWAO6B2MG    WAO6B2MG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAO6JNAM
     C                   MOVEL(P)  DAPROG        WAO6PROG
     C                   MOVEL(P)  WKCHPL        WAO6BIBL
     C                   MOVEL(P)  DAUSER        WAO6USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO6JZEI
     C                   MOVE      WKTDAT        WAO6JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO6
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL(P)  DAUSER        WAO6ERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAO6
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO6
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     MCWAO6TENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO6TENR    IFEQ      *BLANK
     C                   MOVE      *BLANK        DSTENRTBZ1
     C                   MOVE      *BLANK        DSTENRTBZ2
     C                   MOVE      *BLANK        TXBZMGMEIN
     C                   MOVE      *BLANK        TXB2MGMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     DSWAO6TENR    KOM(01)
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAO6TENR
     C                   MOVEL(P)  TETBZ1        DSTENRTBZ1
     C                   MOVEL(P)  TETBZ2        DSTENRTBZ2
     C*
     C                   MOVEL     'MEIN'        KYTPTA                         ERMITTELN
     C                   MOVEL     TEMEIN        KYTPTC                         TABELLEN-TEXT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXBZMGMEIN
     C                   MOVEL     TPTTXT        TXB2MGMEIN
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRWAO6TENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6TENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6TENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TETENR        DSWAO6TENR
     C                   MOVEL(P)  TETBZ1        DSTENRTBZ1
     C                   MOVEL(P)  TETBZ2        DSTENRTBZ2
     C                   MOVEL     *BLANK        TXBZMGMEIN
     C                   MOVEL     *BLANK        TXB2MGMEIN
     C*
     C     WKFENR        IFNE      *ZERO                                        FEHLER
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'MEIN'        KYTPTA                         ERMITTELN
     C                   MOVEL     TEMEIN        KYTPTC                         TABELLEN-TEXT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXBZMGMEIN
     C                   MOVEL     TPTTXT        TXB2MGMEIN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LPTY                                                   ***
     C**************************************************************************
     C     MCWAO6LPTY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO6LPTY    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAO6LPTY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'LPTY'        KOM(02)
     C                   MOVEA     DSWAO6LPTY    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO6LPTY
     C                   MOVEL(P)  TPTTXT        TXWAO6LPTY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LPTY                                                   ***
     C**************************************************************************
     C     PRWAO6LPTY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6LPTY'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LPTY'        KYTPTA
     C                   MOVEL(P)  DSWAO6LPTY    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO6LPTY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BZMG                                                   ***
     C**************************************************************************
     C     PRWAO6BZMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6BZMG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAO6BZMG    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE B2MG                                                   ***
     C**************************************************************************
     C     PRWAO6B2MG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6B2MG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAO6B2MG    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAO6B2MG    IFLT      DSWAO6BZMG
     C                   MOVE      '0038'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NTEN                                                   ***
     C**************************************************************************
     C     MCWAO6NTEN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA     DSWAO6NTEN    KOM(01)
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAO6NTEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NTEN                                                   ***
     C**************************************************************************
     C     PRWAO6NTEN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6NTEN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6NTEN    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NLPT                                                   ***
     C**************************************************************************
     C     MCWAO6NLPT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'LPTY'        KOM(02)
     C                   MOVEA     DSWAO6NLPT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO6NLPT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NLPT                                                   ***
     C**************************************************************************
     C     PRWAO6NLPT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO6NLPT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LPTY'        KYTPTA
     C                   MOVEL(P)  DSWAO6NLPT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
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
     C                   MOVEA     'TENR'        KOM(02)
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
     C                   MOVEL(P)  'WAO6'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAO6
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAO6'        EXDATAFILE
     C                   MOVEL(P)  WAO6          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAO6
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAO6         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN Zuordnung                                               ***
     C**************************************************************************
     C     ERLPTY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDDATE    EXWAO6DATE
     C                   CLEAR                   RTWAO6KEYB
     C                   CLEAR                   RTWAO6DATE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO6TENR    KYWAO6TENR
     C                   Z-ADD     EXWAO6BZMG    KYWAO6BZMG
     C                   MOVEL(P)  *HIVAL        KYWAO6LPTY
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHWAO6
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'                                          VERGLEICHEN
     C     WAO6FIRM      ANDEQ     KYWAO6FIRM                                   OBERGRENZE
     C     WAO6TENR      ANDEQ     KYWAO6TENR
     C*
     C                   SELECT
     C     WAO6BZMG      WHENLE    KYWAO6BZMG
     C     WAO6B2MG      ANDGE     KYWAO6BZMG
     C                   MOVEL(P)  WAO6TENR      RTWAO6TENR
     C                   MOVEL(P)  WAO6LPTY      RTWAO6LPTY
     C                   MOVEL     RTWAO6KEYB    RTTRNDKEYB
     C                   LEAVE
     C                   ENDSL
     C*
     C                   MOVEA     '02P     '    CHI
     C                   EXSR      CHWAO6
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
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
     C                   MOVEL(P)  'TRWAO6'      KYTAPA
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
     C                   MOVEL(P)  'TRWAO6'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAO6B1'    EXTRDNPGNA
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
     C     *LIKE         DEFINE    WKC001        WKTRPATENR
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
     C     *LIKE         DEFINE    KYWAO6TENR    OFWAO6TENR
     C     *LIKE         DEFINE    KYWAO6LPTY    OFWAO6LPTY
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
     C                   MOVEL(P)  'TRWAO6'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAO6W2
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAO6W2
     C                   OTHER
     C                   WRITE     TRWAO6CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAO6W2
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAO6W2
     C                   OTHER
     C                   WRITE     TRWAO6CT
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
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAO6
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTEIL
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
