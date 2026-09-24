     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAO9
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 07.01.2011 Projekt 7025
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 25.01.2011 Felder WEKS + SPLT
     H*  Änderung: SZ 22.08.2011 Felder WEKS kein Mußfeld
     H*  Erstellt: RE 27.08.2013 Projekt 9822
     H*            neues Feld Projekt-Nr WAO9PJNR
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAO9.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAO9FM  CF   E             WORKSTN USROPN
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
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D PROJ          E DS                  INZ
     D KYPROJ        E DS                  INZ
     D*
     D WAO9          E DS                  INZ
     D KYWAO9        E DS                  INZ
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
     D EXWAO9          DS                  INZ
     D  EXWAO9PRKZ                  256
     D   EXWAO9IFKZ                   1    OVERLAY(EXWAO9PRKZ:*NEXT)
     D  EXWAO9KEYB                  256
     D   EXWAO9BEGR                        OVERLAY(EXWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9BEGR)
     D   EXWAO9AFAT                        OVERLAY(EXWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9AFAT)
     D   EXWAO9PRGR                        OVERLAY(EXWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9PRGR)
     D   EXWAO9KONT                        OVERLAY(EXWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9KONT)
     D   EXWAO9KSST                        OVERLAY(EXWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9KSST)
     D  EXWAO9NKEY                  256
     D   EXWAO9NBEG                        OVERLAY(EXWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9BEGR)
     D   EXWAO9NAFA                        OVERLAY(EXWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9AFAT)
     D   EXWAO9NPRG                        OVERLAY(EXWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9PRGR)
     D   EXWAO9NKON                        OVERLAY(EXWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9KONT)
     D   EXWAO9NKSS                        OVERLAY(EXWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9KSST)
     D  EXWAO9DATE                 1024
     D   EXWAO9ERKS                        OVERLAY(EXWAO9DATE:*NEXT)
     D                                     LIKE(WAO9ERKS)
     D   EXWAO9WBKT                        OVERLAY(EXWAO9DATE:*NEXT)
     D                                     LIKE(WAO9WBKT)
     D   EXWAO9EBKT                        OVERLAY(EXWAO9DATE:*NEXT)
     D                                     LIKE(WAO9EBKT)
     D   EXWAO9WEKS                        OVERLAY(EXWAO9DATE:*NEXT)
     D                                     LIKE(WAO9WEKS)
     D   EXWAO9SPLT                        OVERLAY(EXWAO9DATE:*NEXT)
     D                                     LIKE(WAO9SPLT)
     C*
     D RTWAO9          DS                  INZ
     D  RTWAO9KEYB                  256
     D   RTWAO9BEGR                        OVERLAY(RTWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9BEGR)
     D   RTWAO9AFAT                        OVERLAY(RTWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9AFAT)
     D   RTWAO9PRGR                        OVERLAY(RTWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9PRGR)
     D   RTWAO9KONT                        OVERLAY(RTWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9KONT)
     D   RTWAO9KSST                        OVERLAY(RTWAO9KEYB:*NEXT)
     D                                     LIKE(WAO9KSST)
     D  RTWAO9NKEY                  256
     D   RTWAO9NBEG                        OVERLAY(RTWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9BEGR)
     D   RTWAO9NAFA                        OVERLAY(RTWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9AFAT)
     D   RTWAO9NPRG                        OVERLAY(RTWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9PRGR)
     D   RTWAO9NKON                        OVERLAY(RTWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9KONT)
     D   RTWAO9NKSS                        OVERLAY(RTWAO9NKEY:*NEXT)
     D                                     LIKE(WAO9KSST)
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
     C                   CLOSE     TRWAO9FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAO9 '
     C                   EXSR      PWAO9
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAO9
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAO9
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAO9IFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAO9                                       UPDATE
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
     C                   OPEN      TRWAO9FM                             98
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
     C                   CLOSE     TRWAO9FM                             98
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
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYPJFI                         PROJ
     C                   MOVEL(P)  DAFIRM        KYWAO9FIRM                     WAO9
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAO9FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAO9FM'    EXTRPBBPRG
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
     C                   MOVEL(P)  EXTRNDPRKZ    EXWAO9PRKZ
     C*--------------------------------------------------------
     C                   CLEAR                   EXWAO9KEYB
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXWAO9BEGR
     C                   MOVEA(P)  KOM(05)       EXWAO9AFAT
     C                   MOVEA(P)  KOM(08)       EXWAO9PRGR
     C                   MOVEA(P)  KOM(12)       EXWAO9KONT
     C                   MOVEA(P)  KOM(22)       EXWAO9KSST
     C*
     C                   MOVEL(P)  EXWAO9BEGR    KYWAO9BEGR
     C                   MOVEL(P)  EXWAO9AFAT    KYWAO9AFAT
     C                   MOVEL(P)  EXWAO9PRGR    KYWAO9PRGR
     C                   MOVEL(P)  EXWAO9KONT    KYWAO9KONT
     C                   MOVEL(P)  EXWAO9KSST    KYWAO9KSST
     C*
     C                   MOVEL(P)  EXWAO9BEGR    DSWAO9BEGR
     C                   MOVEL(P)  EXWAO9AFAT    DSWAO9AFAT
     C                   MOVEL(P)  EXWAO9PRGR    DSWAO9PRGR
     C                   MOVEL(P)  EXWAO9KONT    DSWAO9KONT
     C                   MOVEL(P)  EXWAO9KSST    DSWAO9KSST
     C*--------------------------------------------------------
     C                   CLEAR                   EXWAO9NKEY
     C                   MOVEA(P)  EXTRNDNKEY    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXWAO9NBEG
     C                   MOVEA(P)  KOM(05)       EXWAO9NAFA
     C                   MOVEA(P)  KOM(08)       EXWAO9NPRG
     C                   MOVEA(P)  KOM(12)       EXWAO9NKON
     C                   MOVEA(P)  KOM(22)       EXWAO9NKSS
     C*
     C                   MOVEL(P)  EXWAO9NBEG    DSWAO9NBEG
     C                   MOVEL(P)  EXWAO9NAFA    DSWAO9NAFA
     C                   MOVEL(P)  EXWAO9NPRG    DSWAO9NPRG
     C                   MOVEL(P)  EXWAO9NKON    DSWAO9NKON
     C                   MOVEL(P)  EXWAO9NKSS    DSWAO9NKSS
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
     C                   MOVEL(P)  'TRWAO9'      EXTRDNDANA
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
     C                   MOVEL     'TRWAO901'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAO9W3
     C                   WRITE     TRWAO901
     C                   WRITE     W3WAO9B1
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
     C                   READ      TRWAO901                             9899
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
     C                   EXSR      UWAO9
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
     C                   MOVEL     *BLANK        KYWAO9AFAT
     C                   MOVEL     *BLANK        KYWAO9PRGR
     C                   MOVEL     *BLANK        KYWAO9KONT
     C                   MOVEL     *BLANK        KYWAO9KSST
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO9
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAO9
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
     C                   CLEAR                   WAO9
     C                   EXSR      ETRMU
     C                   EXSR      EWAO9
     C                   MOVEL(P)  KYWAO9BEGR    WAO9BEGR
     C                   MOVEL(P)  KYWAO9AFAT    WAO9AFAT
     C                   MOVEL(P)  KYWAO9PRGR    WAO9PRGR
     C                   MOVEL(P)  KYWAO9KONT    WAO9KONT
     C                   MOVEL(P)  KYWAO9KSST    WAO9KSST
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C                   MOVEL(P)  WAO9USER      WKUSER
     C                   Z-ADD     WAO9JDAT      WKJDAT
     C                   Z-ADD     WAO9JZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAO9
     C                   EXSR      EWAO9
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO9BEGR      DSWAO9BEGR
     C                   MOVEL(P)  WAO9AFAT      DSWAO9AFAT
     C                   MOVEL(P)  WAO9PRGR      DSWAO9PRGR
     C                   MOVEL(P)  WAO9KONT      DSWAO9KONT
     C                   MOVEL(P)  WAO9KSST      DSWAO9KSST
     C*
     C                   MOVEL(P)  WAO9ERKS      DSWAO9ERKS
     C                   MOVEL(P)  WAO9WBKT      DSWAO9WBKT
     C                   MOVEL(P)  WAO9EBKT      DSWAO9EBKT
     C                   MOVEL(P)  WAO9WEKS      DSWAO9WEKS
     C                   MOVEL(P)  WAO9SPLT      DSWAO9SPLT
     C                   MOVEL(P)  WAO9PJNR      DSWAO9PJNR
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAO9BEGR                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAO9AFAT                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAO9PRGR
     C                   MOVEL     *BLANK        TXWAO9KONT
     C                   MOVEL     *BLANK        TXWAO9KSST
     C                   MOVEL     *BLANK        TXWAO9ERKS
     C                   MOVEL     *BLANK        TXWAO9WBKT
     C                   MOVEL     *BLANK        TXWAO9EBKT
     C                   MOVEL     *BLANK        TXWAO9WEKS
     C                   MOVEL     *BLANK        TXWAO9SPLT
     C*-------------------------------------------------------------------------
     C     DSWAO9BEGR    CASNE     *BLANK        PRWAO9BEGR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAO9AFAT    CASNE     *BLANK        PRWAO9AFAT
     C                   ENDCS
     C     DSWAO9PRGR    CASNE     *BLANK        PRWAO9PRGR
     C                   ENDCS
     C     DSWAO9KONT    CASNE     *BLANK        PRWAO9KONT
     C                   ENDCS
     C     DSWAO9KSST    CASNE     *BLANK        PRWAO9KSST
     C                   ENDCS
     C     DSWAO9ERKS    CASNE     *BLANK        PRWAO9ERKS
     C                   ENDCS
     C     DSWAO9WBKT    CASNE     *BLANK        PRWAO9WBKT
     C                   ENDCS
     C     DSWAO9EBKT    CASNE     *BLANK        PRWAO9EBKT
     C                   ENDCS
     C     DSWAO9WEKS    CASNE     *BLANK        PRWAO9WEKS
     C                   ENDCS
     C     DSWAO9SPLT    CASNE     *BLANK        PRWAO9SPLT
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAO901'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAO9ERKS'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAO9ERKS'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     DSWAO9BEGR    WHENEQ    'AFAT'
     C                   MOVEL(P)  'DSWAO9AFAT'  EXFLPOFLDN
     C     DSWAO9BEGR    WHENEQ    'PRGR'
     C                   MOVEL(P)  'DSWAO9PRGR'  EXFLPOFLDN
     C     DSWAO9BEGR    WHENEQ    'WEIN'
     C                   MOVEL(P)  'DSWAO9KONT'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAO9BEGR'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAO9K1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAO9W3
     C                   WRITE     TRWAO9K1
     C                   WRITE     W3WAO9B1
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
     C                   READ      TRWAO9K1                             9899
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
     C                   EXSR      KWAO9
     C                   EXSR      UWAO9
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAO9BEGR    RTWAO9BEGR
     C                   MOVEL(P)  KYWAO9AFAT    RTWAO9AFAT
     C                   MOVEL(P)  KYWAO9PRGR    RTWAO9PRGR
     C                   MOVEL(P)  KYWAO9KONT    RTWAO9KONT
     C                   MOVEL(P)  KYWAO9KSST    RTWAO9KSST
     C*
     C                   MOVEA(P)  RTWAO9BEGR    KOM(01)
     C                   MOVEA     RTWAO9AFAT    KOM(05)
     C                   MOVEA     RTWAO9PRGR    KOM(08)
     C                   MOVEA     RTWAO9KONT    KOM(12)
     C                   MOVEA     RTWAO9KSST    KOM(22)
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
     C                   MOVEL(P)  KYWAO9BEGR    DSWAO9BEGR
     C                   MOVEL(P)  KYWAO9AFAT    DSWAO9AFAT
     C                   MOVEL(P)  KYWAO9PRGR    DSWAO9PRGR
     C                   MOVEL(P)  KYWAO9KONT    DSWAO9KONT
     C                   MOVEL(P)  KYWAO9KSST    DSWAO9KSST
     C*
     C                   MOVEL(P)  KYWAO9BEGR    DSWAO9NBEG
     C                   MOVEL     *BLANK        DSWAO9NAFA
     C                   MOVEL     *BLANK        DSWAO9NPRG
     C                   MOVEL     *BLANK        DSWAO9NKON
     C                   MOVEL     *BLANK        DSWAO9NKSS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAO9NBEG    WHENEQ    'AFAT'
     C                   MOVEL(P)  'DSWAO9NAFA'  EXFLPOFLDN
     C     DSWAO9NBEG    WHENEQ    'PRGR'
     C                   MOVEL(P)  'DSWAO9NPRG'  EXFLPOFLDN
     C     DSWAO9NBEG    WHENEQ    'WEIN'
     C                   MOVEL(P)  'DSWAO9NKON'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAO9NKON'  EXFLPOFLDN
     C                   ENDSL
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
     C     FLDNAM        ANDEQ     'DSWAO9BEGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9AFAT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9PRGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9KONT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9KSST'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9ERKS'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9WBKT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9EBKT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9WEKS'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9SPLT'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO9PJNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAO9BEGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9BEGR'
     C                   EXSR      MCWAO9BEGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9AFAT'
     C                   EXSR      MCWAO9AFAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9PRGR'
     C                   EXSR      MCWAO9PRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9KONT'
     C                   EXSR      MCWAO9KONT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9KSST'
     C                   EXSR      MCWAO9KSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9ERKS'
     C                   EXSR      MCWAO9ERKS
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9WBKT'
     C                   EXSR      MCWAO9WBKT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9EBKT'
     C                   EXSR      MCWAO9EBKT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9WEKS'
     C                   EXSR      MCWAO9WEKS
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9SPLT'
     C                   EXSR      MCWAO9SPLT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9PJNR'
     C                   EXSR      MCWAO9PJNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9NAFA'
     C                   EXSR      MCWAO9NAFA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9NPRG'
     C                   EXSR      MCWAO9NPRG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9NKON'
     C                   EXSR      MCWAO9NKON
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO9NKSS'
     C                   EXSR      MCWAO9NKSS
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
     C     FLDNAM        WHENEQ    'DSWAO9BEGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO9BEGR
     C     FLDNAM        WHENEQ    'DSWAO9AFAT'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO9AFAT
     C     FLDNAM        WHENEQ    'DSWAO9PRGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO9PRGR
     C     FLDNAM        WHENEQ    'DSWAO9KONT'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO9KONT
     C     FLDNAM        WHENEQ    'DSWAO9KSST'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAO9KSST
     C     FLDNAM        WHENEQ    'DSWAO9ERKS'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9ERKS
     C     FLDNAM        WHENEQ    'DSWAO9WBKT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9WBKT
     C     FLDNAM        WHENEQ    'DSWAO9EBKT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9EBKT
     C     FLDNAM        WHENEQ    'DSWAO9WEKS'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9WEKS
     C     FLDNAM        WHENEQ    'DSWAO9SPLT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9SPLT
     C     FLDNAM        WHENEQ    'DSWAO9PJNR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAO9PJNR
     C     FLDNAM        WHENEQ    'DSWAO9NAFA'
     C                   EXSR      PRWAO9NAFA
     C     FLDNAM        WHENEQ    'DSWAO9NPRG'
     C                   EXSR      PRWAO9NPRG
     C     FLDNAM        WHENEQ    'DSWAO9NKON'
     C                   EXSR      PRWAO9NKON
     C     FLDNAM        WHENEQ    'DSWAO9NKSS'
     C                   EXSR      PRWAO9NKSS
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
     C                   MOVEL(P)  DSWAO9NBEG    KYWAO9BEGR
     C                   MOVEL(P)  DSWAO9NAFA    KYWAO9AFAT
     C                   MOVEL(P)  DSWAO9NPRG    KYWAO9PRGR
     C                   MOVEL(P)  DSWAO9NKON    KYWAO9KONT
     C                   MOVEL(P)  DSWAO9NKSS    KYWAO9KSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAO9NKON'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAO9BEGR    KYWAO9BEGR
     C                   MOVEL(P)  DSWAO9AFAT    KYWAO9AFAT
     C                   MOVEL(P)  DSWAO9PRGR    KYWAO9PRGR
     C                   MOVEL(P)  DSWAO9KONT    KYWAO9KONT
     C                   MOVEL(P)  DSWAO9KSST    KYWAO9KSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAO9KONT'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAO9KONT'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAO9'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO9          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAO9                                     ***
     C**************************************************************************
     C     KWAO9         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO9BEGR    KYWAO9BEGR
     C                   MOVEL(P)  DSWAO9AFAT    KYWAO9AFAT
     C                   MOVEL(P)  DSWAO9PRGR    KYWAO9PRGR
     C                   MOVEL(P)  DSWAO9KONT    KYWAO9KONT
     C                   MOVEL(P)  DSWAO9KSST    KYWAO9KSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  WAO9ERKS      DSWAO9ERKS
     C                   MOVEL(P)  WAO9WBKT      DSWAO9WBKT
     C                   MOVEL(P)  WAO9EBKT      DSWAO9EBKT
     C                   MOVEL(P)  WAO9WEKS      DSWAO9WEKS
     C                   MOVEL(P)  WAO9SPLT      DSWAO9SPLT
     C                   MOVEL(P)  WAO9PJNR      DSWAO9PJNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAO9-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAO9         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAO9BEGR    OFWAO9BEGR
     C                   MOVEL(P)  KYWAO9AFAT    OFWAO9AFAT
     C                   MOVEL(P)  KYWAO9PRGR    OFWAO9PRGR
     C                   MOVEL(P)  KYWAO9KONT    OFWAO9KONT
     C                   MOVEL(P)  KYWAO9KSST    OFWAO9KSST
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO9
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO9FIRM      ANDEQ     KYWAO9FIRM
     C     WAO9BEGR      ANDLE     OFWAO9BEGR
     C     WAO9AFAT      ANDLE     OFWAO9AFAT
     C     WAO9PRGR      ANDLE     OFWAO9PRGR
     C     WAO9KONT      ANDLE     OFWAO9KONT
     C     WAO9KSST      ANDLE     OFWAO9KSST
     C*--------------------------------------------------------
     C     WAO9LOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAO9LOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO9
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
     C***  LÖSCHEN SÄTZE DATEI WAO9                                          ***
     C**************************************************************************
     C     LWAO9         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAO9BEGR    OFWAO9BEGR
     C                   MOVEL(P)  KYWAO9AFAT    OFWAO9AFAT
     C                   MOVEL(P)  KYWAO9PRGR    OFWAO9PRGR
     C                   MOVEL(P)  KYWAO9KONT    OFWAO9KONT
     C                   MOVEL(P)  KYWAO9KSST    OFWAO9KSST
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO9
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO9FIRM      ANDEQ     KYWAO9FIRM
     C     WAO9BEGR      ANDLE     OFWAO9BEGR
     C     WAO9AFAT      ANDLE     OFWAO9AFAT
     C     WAO9PRGR      ANDLE     OFWAO9PRGR
     C     WAO9KONT      ANDLE     OFWAO9KONT
     C     WAO9KSST      ANDLE     OFWAO9KSST
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAO9BEGR      KYWAO9BEGR
     C                   MOVEL(P)  WAO9AFAT      KYWAO9AFAT
     C                   MOVEL(P)  WAO9PRGR      KYWAO9PRGR
     C                   MOVEL(P)  WAO9KONT      KYWAO9KONT
     C                   MOVEL(P)  WAO9KSST      KYWAO9KSST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO9
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAO9
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO9
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
     C                   MOVEL(P)  EXWAO9ERKS    DSWAO9ERKS
     C                   MOVEL(P)  EXWAO9WBKT    DSWAO9WBKT
     C                   MOVEL(P)  EXWAO9EBKT    DSWAO9EBKT
     C                   MOVEL(P)  EXWAO9WEKS    DSWAO9WEKS
     C                   MOVEL(P)  EXWAO9SPLT    DSWAO9SPLT
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRWAO901'    WKFLPORECN
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
     C     IFWAO9        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAO9IFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAO9BEGR    KYWAO9BEGR
     C                   MOVEL(P)  EXWAO9AFAT    KYWAO9AFAT
     C                   MOVEL(P)  EXWAO9PRGR    KYWAO9PRGR
     C                   MOVEL(P)  EXWAO9KONT    KYWAO9KONT
     C                   MOVEL(P)  EXWAO9KSST    KYWAO9KSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
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
     C     EXWAO9ERKS    IFNE      *BLANK
     C                   MOVEL(P)  EXWAO9ERKS    DSWAO9ERKS
     C                   ENDIF
     C*
     C     EXWAO9WBKT    IFNE      *BLANK
     C                   MOVEL(P)  EXWAO9WBKT    DSWAO9WBKT
     C                   ENDIF
     C*
     C     EXWAO9EBKT    IFNE      *BLANK
     C                   MOVEL(P)  EXWAO9EBKT    DSWAO9EBKT
     C                   ENDIF
     C*
     C     EXWAO9WEKS    IFNE      *BLANK
     C                   MOVEL(P)  EXWAO9WEKS    DSWAO9WEKS
     C                   ENDIF
     C*
     C     EXWAO9SPLT    IFNE      *BLANK
     C                   MOVEL(P)  EXWAO9SPLT    DSWAO9SPLT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAO901'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAO9
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
     C     K#WAO9LOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAO9                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAO9                                                 ***
     C**************************************************************************
     C     UWAO9         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO9BEGR    KYWAO9BEGR
     C                   MOVEL(P)  DSWAO9AFAT    KYWAO9AFAT
     C                   MOVEL(P)  DSWAO9PRGR    KYWAO9PRGR
     C                   MOVEL(P)  DSWAO9KONT    KYWAO9KONT
     C                   MOVEL(P)  DSWAO9KSST    KYWAO9KSST
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAO9NBEG    KYWAO9BEGR
     C                   MOVE(P)   DSWAO9NAFA    KYWAO9AFAT
     C                   MOVE(P)   DSWAO9NPRG    KYWAO9PRGR
     C                   MOVE(P)   DSWAO9NKON    KYWAO9KONT
     C                   MOVE(P)   DSWAO9NKSS    KYWAO9KSST
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO9
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAO9BEGR    WAO9BEGR
     C*
     C                   MOVEL(P)  DSWAO9ERKS    WAO9ERKS
     C                   MOVEL(P)  DSWAO9WBKT    WAO9WBKT
     C                   MOVEL(P)  DSWAO9EBKT    WAO9EBKT
     C                   MOVEL(P)  DSWAO9WEKS    WAO9WEKS
     C                   MOVEL(P)  DSWAO9SPLT    WAO9SPLT
     C                   MOVEL(P)  DSWAO9PJNR    WAO9PJNR
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAO9JNAM
     C                   MOVEL(P)  DAPROG        WAO9PROG
     C                   MOVEL(P)  WKCHPL        WAO9BIBL
     C                   MOVEL(P)  DAUSER        WAO9USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO9JZEI
     C                   MOVE      WKTDAT        WAO9JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO9
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL     DUN120        WAO9ERZT
     C                   MOVE      WKTDAT        WAO9ERDA
     C                   MOVEL(P)  DAUSER        WAO9ERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAO9
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO9
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE BEGR                                                   ***
     C**************************************************************************
     C     MCWAO9BEGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9BEGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9BEGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BEGRWAO9'    EXTRPCPGGR
     C                   MOVEL(P)  DSWAO9BEGR    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAO9BEGR
     C                   MOVEL(P)  EXTRPCTEXT    TXWAO9BEGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BEGR                                                   ***
     C**************************************************************************
     C     PRWAO9BEGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAO9BEGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BEGRWAO9'    EXTRPCPGGR
     C                   MOVEL(P)  DSWAO9BEGR    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAO9BEGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     MCWAO9AFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAO9AFAT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9AFAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEL(P)  'AFPA01'      #CPGST
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   EXSR      MCAFPA
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  AAAFAT        DSWAO9AFAT
     C                   MOVEL(P)  AAABEZ        TXWAO9AFAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     PRWAO9AFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9AFAT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAO9AFAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAO9BEGR    WHENEQ    'WEIN'
     C     DSWAO9AFAT    ANDNE     *BLANK
     C     DSWAO9BEGR    OREQ      'PRGR'
     C     DSWAO9AFAT    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C     DSWAO9BEGR    WHENEQ    'AFAT'
     C                   MOVEL(P)  DSWAO9AFAT    KYAAAT                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHAFPA
     C                   MOVEL(P)  AAABEZ        TXWAO9AFAT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     MCWAO9PRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9PRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9PRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAO9PRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9PRGR
     C                   MOVEL(P)  TPTTXT        TXWAO9PRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     PRWAO9PRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9PRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAO9PRGR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAO9BEGR    WHENEQ    'WEIN'
     C     DSWAO9PRGR    ANDNE     *BLANK
     C     DSWAO9BEGR    OREQ      'AFAT'
     C     DSWAO9PRGR    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C     DSWAO9BEGR    WHENEQ    'PRGR'
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAO9PRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9PRGR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KONT                                                   ***
     C**************************************************************************
     C     MCWAO9KONT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9KONT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9KONT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOZK'        KOM(02)
     C                   MOVEA     DSWAO9KONT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9KONT
     C                   MOVEL(P)  TPTTXT        TXWAO9KONT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KONT                                                   ***
     C**************************************************************************
     C     PRWAO9KONT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9KONT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOZK'        KYTPTA
     C                   MOVEL(P)  DSWAO9KONT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9KONT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KSST                                                   ***
     C**************************************************************************
     C     MCWAO9KSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9KSST    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9KSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSWAO9KSST    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9KSST
     C                   MOVEL(P)  TPTTXT        TXWAO9KSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KSST                                                   ***
     C**************************************************************************
     C     PRWAO9KSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9KSST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSWAO9KSST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9KSST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE ERKS                                                   ***
     C**************************************************************************
     C     MCWAO9ERKS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9ERKS    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9ERKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSWAO9ERKS    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9ERKS
     C                   MOVEL(P)  TPTTXT        TXWAO9ERKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ERKS                                                   ***
     C**************************************************************************
     C     PRWAO9ERKS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9ERKS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSWAO9ERKS    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9ERKS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE WBKT                                                   ***
     C**************************************************************************
     C     MCWAO9WBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9WBKT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9WBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOZK'        KOM(02)
     C                   MOVEA     DSWAO9WBKT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9WBKT
     C                   MOVEL(P)  TPTTXT        TXWAO9WBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE WBKT                                                   ***
     C**************************************************************************
     C     PRWAO9WBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9WBKT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAO9WBKT
     C*-------------------------------------------------------------------------
     C     DSWAO9WBKT    IFNE      *BLANK
     C**   DSWAO9BEGR    ORNE      'PRGR'
     C                   MOVEL(P)  'KOZK'        KYTPTA
     C                   MOVEL(P)  DSWAO9WBKT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9WBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE EBKT                                                   ***
     C**************************************************************************
     C     MCWAO9EBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9EBKT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9EBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOKO'        KOM(02)
     C                   MOVEA     DSWAO9EBKT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9EBKT
     C                   MOVEL(P)  TPTTXT        TXWAO9EBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE EBKT                                                   ***
     C**************************************************************************
     C     PRWAO9EBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9EBKT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAO9EBKT
     C*-------------------------------------------------------------------------
     C     DSWAO9EBKT    IFNE      *BLANK
     C**   DSWAO9BEGR    ORNE      'PRGR'
     C                   MOVEL(P)  'KOKO'        KYTPTA
     C                   MOVEL(P)  DSWAO9EBKT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9EBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE WEKS                                                   ***
     C**************************************************************************
     C     MCWAO9WEKS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9WEKS    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9WEKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSWAO9WEKS    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9WEKS
     C                   MOVEL(P)  TPTTXT        TXWAO9WEKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE WEKS                                                   ***
     C**************************************************************************
     C     PRWAO9WEKS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9WEKS'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAO9WEKS
     C*-------------------------------------------------------------------------
     C                   IF        DSWAO9WEKS <> *BLANK
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSWAO9WEKS    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO9WEKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE SPLT                                                   ***
     C**************************************************************************
     C     MCWAO9SPLT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAO9SPLT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAO9SPLT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAO9SPLT    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAO9SPLT
     C                   MOVEL(P)  EXTRPCTEXT    TXWAO9SPLT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SPLT                                                   ***
     C**************************************************************************
     C     PRWAO9SPLT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9SPLT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAO9SPLT    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAO9SPLT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PJNR                                                   ***
     C**************************************************************************
     C     MCWAO9PJNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSWAO9PJNR    KOM(01)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCPROJ
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  PJPRNR        DSWAO9PJNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SPLT                                                   ***
     C**************************************************************************
     C     PRWAO9PJNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9PJNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAO9PJNR    IFNE      *BLANK
     C                   MOVEL(P)  DSWAO9PJNR    KYPJNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPROJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PJPJST        IFGE      '90'
     C                   MOVEL(P)  'PJST'        EXTRPCPGGR
     C                   MOVEL(P)  PJPJST        EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEA(P)  EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0014'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NAFA                                                   ***
     C**************************************************************************
     C     MCWAO9NAFA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEL(P)  'AFPA01'      #CPGST
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   EXSR      MCAFPA
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  AAAFAT        DSWAO9NAFA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NAFA                                                   ***
     C**************************************************************************
     C     PRWAO9NAFA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9NAFA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAO9NBEG    WHENEQ    'WEIN'
     C     DSWAO9NAFA    ANDNE     *BLANK
     C     DSWAO9NBEG    OREQ      'PRGR'
     C     DSWAO9NAFA    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C     DSWAO9NBEG    WHENEQ    'AFAT'
     C                   MOVEL(P)  DSWAO9NAFA    KYAAAT                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHAFPA
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NPRG                                                   ***
     C**************************************************************************
     C     MCWAO9NPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAO9NPRG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9NPRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NPRG                                                   ***
     C**************************************************************************
     C     PRWAO9NPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9NPRG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAO9NBEG    WHENEQ    'WEIN'
     C     DSWAO9NPRG    ANDNE     *BLANK
     C     DSWAO9NBEG    OREQ      'AFAT'
     C     DSWAO9NPRG    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C     DSWAO9NBEG    WHENEQ    'PRGR'
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAO9NPRG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NKON                                                   ***
     C**************************************************************************
     C     MCWAO9NKON    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOZK'        KOM(02)
     C                   MOVEA     DSWAO9NKON    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9NKON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NKON                                                  ***
     C**************************************************************************
     C     PRWAO9NKON    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9NKON'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOZK'        KYTPTA
     C                   MOVEL(P)  DSWAO9NKON    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NKSS                                                   ***
     C**************************************************************************
     C     MCWAO9NKSS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSWAO9NKSS    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO9NKSS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NKSS                                                   ***
     C**************************************************************************
     C     PRWAO9NKSS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO9NKSS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSWAO9NKSS    KYTPTC
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
     C                   MOVEL(P)  'WAO9'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAO9
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAO9'        EXDATAFILE
     C                   MOVEL(P)  WAO9          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAO9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAO9         BEGSR
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
     C                   MOVEL(P)  'TRWAO9'      KYTAPA
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
     C                   MOVEL(P)  'TRWAO9'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAO9B1'    EXTRDNPGNA
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
     C     *LIKE         DEFINE    KYWAO9BEGR    OFWAO9BEGR
     C     *LIKE         DEFINE    KYWAO9AFAT    OFWAO9AFAT
     C     *LIKE         DEFINE    KYWAO9PRGR    OFWAO9PRGR
     C     *LIKE         DEFINE    KYWAO9KONT    OFWAO9KONT
     C     *LIKE         DEFINE    KYWAO9KSST    OFWAO9KSST
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
     C                   MOVEL(P)  'TRWAO9'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAO9W3
     C                   OTHER
     C                   WRITE     CTWAO9W3
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAO9W3
     C                   OTHER
     C                   WRITE     CTWAO9W3
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
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHPROJ
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAO9
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCAFPA
     C/COPY QCPYSRC,MCPROJ
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
