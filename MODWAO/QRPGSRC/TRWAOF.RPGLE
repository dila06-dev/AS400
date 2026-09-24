     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2009')
     H**************************************************************************
     H/TITLE  Verwalten Kalkulation-Preisübersicht
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: HR 04.05.2011 Projekt 7338 für Kunde Dometic
     H*  -----------------------------------------------------------------------
     H*  Änderung: HR 05.09.2013 Projekt 9836 Bereich
     H*  Änderung: HR 23.12.2013 Projekt 10083 weiter ICS-Preis-Felder
     H*  Änderung: HR 15.05.2014 Projekt 10378 weiteres ICS-Feld NL
     H*  Änderung: HR 18.04.2019 Projekt 13927 weitere Felder TP EMEA..
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOF für die firmaenspezifische
     F*  Kalkulations-Preisübersicht
     F**************************************************************************
     F*     Programm-Übergabeparameter:
     F*     ===========================
     F*
     F*  1. Bei der "normalen" Verwaltung:
     F*     ------------------------------
     F*     Produktgruppe(KOM(01)  (EXTRNDKEYB ==> KOM)
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOFFM  CF   E             WORKSTN USROPN
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
     D KVKK          E DS                  INZ
     D KYKVKK        E DS                  INZ
     D*
     D KVKS          E DS                  INZ
     D KYKVKS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEPR          E DS                  INZ
     D KYTEPR        E DS                  INZ
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
     D WAOF          E DS                  INZ
     D KYWAOF        E DS                  INZ
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
     C                   CLOSE     TRWAOFFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOF '
     C                   EXSR      PWAOF
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOF
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOF
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GWAOF '
     C                   EXSR      GWAOF
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPBERE'
     C                   EXSR      UPWAOFBERE
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'T2WAOF'
     C                   EXSR      U2WAOFBERE
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
     C                   OPEN      TRWAOFFM                             98
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
     C                   CLOSE     TRWAOFFM                             98
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
     C                   MOVEL(P)  DAFIRM        KYVKFI                         KVKK
     C                   MOVEL(P)  DAFIRM        KYVSFI                         KVKS
     C                   MOVEL(P)  DAFIRM        KYWAOFFIRM                     WAOF
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYTRFI                         TEPR
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOFFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOFFM'    EXTRPBBPRG
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
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFEQ      *ON
     C                   Z-ADD     DUN040        KYWAOFKAJJ
     C                   ELSE
     C                   Z-ADD     *ZERO         KYWAOFKAJJ
     C                   ENDIF
     C                   MOVEA(P)  KOM(05)       KYWAOFKANR
     C                   MOVEA(P)  KOM(11)       KYWAOFVEUR
     C*
     C                   Z-ADD     KYWAOFKAJJ    DSWAOFKAJJ
     C                   MOVEL(P)  KYWAOFKANR    DSWAOFKANR
     C                   MOVEA(P)  KOM(11)       DSWAOFVEUR
     C*
     C                   MOVEA(P)  EXTRNDNKEY    KOM
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFEQ      *ON
     C                   Z-ADD     DUN040        DSWAOFNKAJ
     C                   ELSE
     C                   Z-ADD     *ZERO         DSWAOFNKAJ
     C                   ENDIF
     C                   MOVEA(P)  KOM(05)       DSWAOFNKAN
     C                   MOVEA(P)  KOM(11)       DSWAOFNVEU
     C*
     C*
     C     PCPGST        IFEQ      'ERWAOF'
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C**                 MOVEA(P)  KOM(01)       WKTENR
     C                   ENDIF
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
     C                   MOVEL(P)  'TRWAOF'      EXTRDNDANA
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
     C                   MOVEL     'TRWAOF01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOF01
     C                   WRITE     TRWAOFB1
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
     C                   READ      TRWAOF01                             9899
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
     C                   EXSR      UWAOF
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
     C                   MOVE      *ZERO         KYWAOFKAJJ
     C                   MOVE      *BLANK        KYWAOFKANR
     C                   MOVE      *BLANK        KYWAOFVEUR
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOF
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOF
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
     C                   CLEAR                   WAOF
     C                   EXSR      ETRMU
     C                   EXSR      EWAOF
     C                   Z-ADD     KYWAOFKAJJ    WAOFKAJJ
     C                   MOVEL(P)  KYWAOFKANR    WAOFKANR
     C                   MOVEL(P)  KYWAOFVEUR    WAOFVEUR
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C                   MOVEL(P)  WAOFUSER      WKUSER
     C                   Z-ADD     WAOFJDAT      WKJDAT
     C                   Z-ADD     WAOFJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOF
     C                   EXSR      EWAOF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOFBERE      DSWAOFBERE
     C                   Z-ADD     WAOFWF01      DSWAOFWF01
     C                   Z-ADD     WAOFWF02      DSWAOFWF02
     C                   Z-ADD     WAOFWF03      DSWAOFWF03
     C                   Z-ADD     WAOFWF04      DSWAOFWF04
     C                   Z-ADD     WAOFWF05      DSWAOFWF05
     C                   Z-ADD     WAOFWF06      DSWAOFWF06
     C                   Z-ADD     WAOFWF07      DSWAOFWF07
     C                   Z-ADD     WAOFWF08      DSWAOFWF08
     C                   Z-ADD     WAOFWF09      DSWAOFWF09
     C                   Z-ADD     WAOFWF10      DSWAOFWF10
     C*
     C                   Z-ADD     WAOFWF11      DSWAOFWF11
     C                   Z-ADD     WAOFWF12      DSWAOFWF12
     C                   Z-ADD     WAOFWF13      DSWAOFWF13
     C                   Z-ADD     WAOFWF14      DSWAOFWF14
     C                   Z-ADD     WAOFWF15      DSWAOFWF15
     C                   Z-ADD     WAOFWF16      DSWAOFWF16
     C                   Z-ADD     WAOFWF17      DSWAOFWF17
     C                   Z-ADD     WAOFWF18      DSWAOFWF18
     C                   Z-ADD     WAOFWF19      DSWAOFWF19
     C                   Z-ADD     WAOFWF20      DSWAOFWF20
     C*
     C                   Z-ADD     WAOFWF21      DSWAOFWF21
     C                   Z-ADD     WAOFWF22      DSWAOFWF22
     C                   Z-ADD     WAOFWF23      DSWAOFWF23
     C                   Z-ADD     WAOFWF24      DSWAOFWF24
     C                   Z-ADD     WAOFWF25      DSWAOFWF25
     C                   Z-ADD     WAOFWF26      DSWAOFWF26
     C                   Z-ADD     WAOFWF27      DSWAOFWF27
     C                   Z-ADD     WAOFWF28      DSWAOFWF28
     C                   Z-ADD     WAOFWF29      DSWAOFWF29
     C                   Z-ADD     WAOFWF30      DSWAOFWF30
     C*
     C                   Z-ADD     WAOFWF31      DSWAOFWF31
     C                   Z-ADD     WAOFWF32      DSWAOFWF32
     C                   Z-ADD     WAOFWF33      DSWAOFWF33
     C                   Z-ADD     WAOFWF34      DSWAOFWF34
     C                   Z-ADD     WAOFWF35      DSWAOFWF35
     C                   Z-ADD     WAOFWF36      DSWAOFWF36
     C                   Z-ADD     WAOFWF37      DSWAOFWF37
     C                   Z-ADD     WAOFWF38      DSWAOFWF38
     C                   Z-ADD     WAOFWF39      DSWAOFWF39
     C                   Z-ADD     WAOFWF40      DSWAOFWF40
     C*
     C                   Z-ADD     WAOFWF41      DSWAOFWF41
     C                   Z-ADD     WAOFWF42      DSWAOFWF42
     C                   Z-ADD     WAOFWF43      DSWAOFWF43
     C                   Z-ADD     WAOFWF44      DSWAOFWF44
     C                   Z-ADD     WAOFWF45      DSWAOFWF45
     C                   Z-ADD     WAOFWF46      DSWAOFWF46
     C                   Z-ADD     WAOFWF47      DSWAOFWF47
     C                   Z-ADD     WAOFWF48      DSWAOFWF48
     C                   Z-ADD     WAOFWF49      DSWAOFWF49
     C                   Z-ADD     WAOFWF50      DSWAOFWF50
     C                   Z-ADD     WAOFWF51      DSWAOFWF51
     C                   Z-ADD     WAOFWF52      DSWAOFWF52
     C                   Z-ADD     WAOFWF53      DSWAOFWF53
     C                   Z-ADD     WAOFWF54      DSWAOFWF54
     C                   Z-ADD     WAOFWF55      DSWAOFWF55
     C                   Z-ADD     WAOFWF56      DSWAOFWF56
     C                   Z-ADD     WAOFWF57      DSWAOFWF57
     C                   Z-ADD     WAOFWF58      DSWAOFWF58
     C                   Z-ADD     WAOFWF59      DSWAOFWF59
     C                   Z-ADD     WAOFWF60      DSWAOFWF60
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXTEILTBZ1                     INITIALISIEREN
     C*-------------------------------------------------------------------------
     C     DSWAOFVEUR    CASNE     *BLANK        PRWAOFVEUR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOF01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOFWF01'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOFKANR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     DSWAOFKANR    WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOFKANR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOFWF01'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAOFK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOFW2
     C                   WRITE     TRWAOFK1
     C                   WRITE     W2WAOFB1
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
     C                   READ      TRWAOFK1                             9899
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
     C                   EXSR      KWAOF
     C                   EXSR      UWAOF
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   Z-ADD     KYWAOFKAJJ    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA(P)  KYWAOFKANR    KOM(06)
     C                   MOVEA(P)  KYWAOFVEUR    KOM(11)
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
     C                   Z-ADD     KYWAOFKAJJ    DSWAOFKAJJ
     C                   MOVEL(P)  KYWAOFKANR    DSWAOFKANR
     C                   MOVEL(P)  KYWAOFVEUR    DSWAOFVEUR
     C*
     C                   Z-ADD     *ZERO         DSWAOFNKAJ
     C                   MOVEL(P)  *BLANK        DSWAOFNKAN
     C                   MOVEL(P)  *BLANK        DSWAOFNVEU
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFNPRG'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAOFKAJJ'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOFKANR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOFVEUR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOFWF01'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFVEUR'
     C                   EXSR      MCWAOFVEUR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFNVEU'
     C                   EXSR      MCWAOFNVEU
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
     C     FLDNAM        WHENEQ    'DSWAOFKAJJ'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOFKAJJ
     C     FLDNAM        WHENEQ    'DSWAOFKANR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOFKANR
     C     FLDNAM        WHENEQ    'DSWAOFVEUR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOFVEUR
     C     FLDNAM        WHENEQ    'DSWAOFWF01'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFWF01
     C     FLDNAM        WHENEQ    'DSWAOFNKAJ'
     C                   EXSR      PRWAOFNKAJ
     C     FLDNAM        WHENEQ    'DSWAOFNKAN'
     C                   EXSR      PRWAOFNKAN
     C     FLDNAM        WHENEQ    'DSWAOFNVEU'
     C                   EXSR      PRWAOFNVEU
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
     C                   Z-ADD     DSWAOFNKAJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFNKAN    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFNVEU    KYWAOFVEUR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOFNVEU'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   Z-ADD     DSWAOFKAJJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    KYWAOFVEUR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOFVEUR'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOFVEUR'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOF'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOF          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAOF                                     ***
     C**************************************************************************
     C     KWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    KYWAOFVEUR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  WAOFWF01      DSWAOFWF01
     C                   MOVEL(P)  WAOFWF02      DSWAOFWF02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOF-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    OFWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    OFWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    OFWAOFVEUR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOF
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOFFIRM      ANDEQ     KYWAOFFIRM
     C     WAOFKAJJ      ANDLE     OFWAOFKAJJ
     C     WAOFKANR      ANDLE     OFWAOFKANR
     C     WAOFVEUR      ANDLE     OFWAOFVEUR
     C*--------------------------------------------------------
     C     WAOFLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOFLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOF
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
     C***  LÖSCHEN SÄTZE DATEI WAOF                                          ***
     C**************************************************************************
     C     LWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    OFWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    OFWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    OFWAOFVEUR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOF
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOFFIRM      ANDEQ     KYWAOFFIRM
     C     WAOFKAJJ      ANDLE     OFWAOFKAJJ
     C     WAOFKANR      ANDLE     OFWAOFKANR
     C     WAOFVEUR      ANDLE     OFWAOFVEUR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   Z-ADD     WAOFKAJJ      KYWAOFKAJJ
     C                   MOVEL(P)  WAOFKANR      KYWAOFKANR
     C                   MOVEL(P)  WAOFVEUR      KYWAOFVEUR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOF
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOF
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
     C***  UPDATE DATEI WAOF                                                 ***
     C**************************************************************************
     C     UWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    KYWAOFVEUR
     C*
     C     PCPGST        IFEQ      '3     '
     C                   Z-ADD     DSWAOFNKAJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFNKAN    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFNVEU    KYWAOFVEUR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFWF01    WAOFWF01
     C                   Z-ADD     DSWAOFWF02    WAOFWF02
     C                   Z-ADD     DSWAOFWF03    WAOFWF03
     C                   Z-ADD     DSWAOFWF04    WAOFWF04
     C                   Z-ADD     DSWAOFWF05    WAOFWF05
     C                   Z-ADD     DSWAOFWF06    WAOFWF06
     C                   Z-ADD     DSWAOFWF07    WAOFWF07
     C                   Z-ADD     DSWAOFWF08    WAOFWF08
     C                   Z-ADD     DSWAOFWF09    WAOFWF09
     C                   Z-ADD     DSWAOFWF10    WAOFWF10
     C*
     C                   Z-ADD     DSWAOFWF11    WAOFWF11
     C                   Z-ADD     DSWAOFWF12    WAOFWF12
     C                   Z-ADD     DSWAOFWF13    WAOFWF13
     C                   Z-ADD     DSWAOFWF14    WAOFWF14
     C                   Z-ADD     DSWAOFWF15    WAOFWF15
     C                   Z-ADD     DSWAOFWF16    WAOFWF16
     C                   Z-ADD     DSWAOFWF17    WAOFWF17
     C                   Z-ADD     DSWAOFWF18    WAOFWF18
     C                   Z-ADD     DSWAOFWF19    WAOFWF19
     C                   Z-ADD     DSWAOFWF20    WAOFWF20
     C*
     C                   Z-ADD     DSWAOFWF21    WAOFWF21
     C                   Z-ADD     DSWAOFWF22    WAOFWF22
     C                   Z-ADD     DSWAOFWF23    WAOFWF23
     C                   Z-ADD     DSWAOFWF24    WAOFWF24
     C                   Z-ADD     DSWAOFWF25    WAOFWF25
     C                   Z-ADD     DSWAOFWF26    WAOFWF26
     C                   Z-ADD     DSWAOFWF27    WAOFWF27
     C                   Z-ADD     DSWAOFWF28    WAOFWF28
     C                   Z-ADD     DSWAOFWF29    WAOFWF29
     C                   Z-ADD     DSWAOFWF30    WAOFWF30
     C*
     C                   Z-ADD     DSWAOFWF31    WAOFWF31
     C                   Z-ADD     DSWAOFWF32    WAOFWF32
     C                   Z-ADD     DSWAOFWF33    WAOFWF33
     C                   Z-ADD     DSWAOFWF34    WAOFWF34
     C                   Z-ADD     DSWAOFWF35    WAOFWF35
     C                   Z-ADD     DSWAOFWF36    WAOFWF36
     C                   Z-ADD     DSWAOFWF37    WAOFWF37
     C                   Z-ADD     DSWAOFWF38    WAOFWF38
     C                   Z-ADD     DSWAOFWF39    WAOFWF39
     C                   Z-ADD     DSWAOFWF40    WAOFWF40
     C*
     C                   Z-ADD     DSWAOFWF41    WAOFWF41
     C                   Z-ADD     DSWAOFWF42    WAOFWF42
     C                   Z-ADD     DSWAOFWF43    WAOFWF43
     C                   Z-ADD     DSWAOFWF44    WAOFWF44
     C                   Z-ADD     DSWAOFWF45    WAOFWF45
     C                   Z-ADD     DSWAOFWF46    WAOFWF46
     C                   Z-ADD     DSWAOFWF47    WAOFWF47
     C                   Z-ADD     DSWAOFWF48    WAOFWF48
     C                   Z-ADD     DSWAOFWF49    WAOFWF49
     C                   Z-ADD     DSWAOFWF50    WAOFWF50
     C                   Z-ADD     DSWAOFWF51    WAOFWF51
     C                   Z-ADD     DSWAOFWF52    WAOFWF52
     C                   Z-ADD     DSWAOFWF53    WAOFWF53
     C                   Z-ADD     DSWAOFWF54    WAOFWF54
     C                   Z-ADD     DSWAOFWF55    WAOFWF55
     C                   Z-ADD     DSWAOFWF56    WAOFWF56
     C                   Z-ADD     DSWAOFWF57    WAOFWF57
     C                   Z-ADD     DSWAOFWF58    WAOFWF58
     C                   Z-ADD     DSWAOFWF59    WAOFWF59
     C                   Z-ADD     DSWAOFWF60    WAOFWF60
     C*
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOFJNAM
     C                   MOVEL(P)  DAPROG        WAOFPROG
     C                   MOVEL(P)  WKCHPL        WAOFBIBL
     C                   MOVEL(P)  DAUSER        WAOFUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOFJZEI
     C                   MOVE      WKTDAT        WAOFJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOF
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOF
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOF
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN RECHENSCHEMASATZ                                       ***
     C**************************************************************************
     C     GWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSWAOFWF01
     C                   Z-ADD     *ZERO         DSWAOFWF02
     C                   Z-ADD     *ZERO         DSWAOFWF03
     C                   Z-ADD     *ZERO         DSWAOFWF04
     C                   Z-ADD     *ZERO         DSWAOFWF05
     C                   Z-ADD     *ZERO         DSWAOFWF06
     C                   Z-ADD     *ZERO         DSWAOFWF07
     C                   Z-ADD     *ZERO         DSWAOFWF08
     C                   Z-ADD     *ZERO         DSWAOFWF09
     C                   Z-ADD     *ZERO         DSWAOFWF10
     C*
     C                   Z-ADD     *ZERO         DSWAOFWF11
     C                   Z-ADD     *ZERO         DSWAOFWF12
     C                   Z-ADD     *ZERO         DSWAOFWF13
     C                   Z-ADD     *ZERO         DSWAOFWF14
     C                   Z-ADD     *ZERO         DSWAOFWF15
     C                   Z-ADD     *ZERO         DSWAOFWF16
     C                   Z-ADD     *ZERO         DSWAOFWF17
     C                   Z-ADD     *ZERO         DSWAOFWF18
     C                   Z-ADD     *ZERO         DSWAOFWF19
     C                   Z-ADD     *ZERO         DSWAOFWF20
     C*
     C                   Z-ADD     *ZERO         DSWAOFWF21
     C                   Z-ADD     *ZERO         DSWAOFWF22
     C                   Z-ADD     *ZERO         DSWAOFWF23
     C                   Z-ADD     *ZERO         DSWAOFWF24
     C                   Z-ADD     *ZERO         DSWAOFWF25
     C                   Z-ADD     *ZERO         DSWAOFWF26
     C                   Z-ADD     *ZERO         DSWAOFWF27
     C                   Z-ADD     *ZERO         DSWAOFWF28
     C                   Z-ADD     *ZERO         DSWAOFWF29
     C                   Z-ADD     *ZERO         DSWAOFWF30
     C*
     C                   Z-ADD     *ZERO         DSWAOFWF31
     C                   Z-ADD     *ZERO         DSWAOFWF32
     C                   Z-ADD     *ZERO         DSWAOFWF33
     C                   Z-ADD     *ZERO         DSWAOFWF34
     C                   Z-ADD     *ZERO         DSWAOFWF35
     C                   Z-ADD     *ZERO         DSWAOFWF36
     C                   Z-ADD     *ZERO         DSWAOFWF37
     C                   Z-ADD     *ZERO         DSWAOFWF38
     C                   Z-ADD     *ZERO         DSWAOFWF39
     C                   Z-ADD     *ZERO         DSWAOFWF40
     C*
     C                   Z-ADD     *ZERO         DSWAOFWF41
     C                   Z-ADD     *ZERO         DSWAOFWF42
     C                   Z-ADD     *ZERO         DSWAOFWF43
     C                   Z-ADD     *ZERO         DSWAOFWF44
     C                   Z-ADD     *ZERO         DSWAOFWF45
     C                   Z-ADD     *ZERO         DSWAOFWF46
     C                   Z-ADD     *ZERO         DSWAOFWF47
     C                   Z-ADD     *ZERO         DSWAOFWF48
     C                   Z-ADD     *ZERO         DSWAOFWF49
     C                   Z-ADD     *ZERO         DSWAOFWF50
     C                   Z-ADD     *ZERO         DSWAOFWF51
     C                   Z-ADD     *ZERO         DSWAOFWF52
     C                   Z-ADD     *ZERO         DSWAOFWF53
     C                   Z-ADD     *ZERO         DSWAOFWF54
     C                   Z-ADD     *ZERO         DSWAOFWF55
     C                   Z-ADD     *ZERO         DSWAOFWF56
     C                   Z-ADD     *ZERO         DSWAOFWF57
     C                   Z-ADD     *ZERO         DSWAOFWF58
     C                   Z-ADD     *ZERO         DSWAOFWF59
     C                   Z-ADD     *ZERO         DSWAOFWF60
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYWAOFKAJJ    KYVKJJ
     C                   MOVEL(P)  KYWAOFKANR    KYVKNR
     C                   MOVEL(P)  KYWAOFVEUR    KYVKVU
     C                   MOVEL(P)  KYWAOFVEUR    KYVKTE
     C                   Z-ADD     *ZERO         KYVKSX
     C                   MOVEA     '01C     '    CHI                            LESEN
     C                   EXSR      CHKVKK                                       KOPF
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      VKKAJJ        KYVSJJ
     C                   MOVE      VKKANR        KYVSNR
     C                   MOVE      VKVEUR        KYVSVU
     C                   MOVE      *LOVAL        KYVSRF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKVKS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     VSFIRM        IFNE      KYVSFI
     C     VSKAJJ        ORNE      KYVSJJ
     C     VSKANR        ORNE      KYVSNR
     C     VSVEUR        ORNE      KYVSVU
     C                   LEAVE
     C                   ENDIF
     C* -------------------------------------------------------
     C                   SELECT
     C     VSUFLD        WHENEQ    'VKWF01'
     C                   Z-ADD     VSRAWT        DSWAOFWF01
     C     VSUFLD        WHENEQ    'VKWF02'
     C                   Z-ADD     VSRAWT        DSWAOFWF02
     C     VSUFLD        WHENEQ    'VKWF03'
     C                   Z-ADD     VSRAWT        DSWAOFWF03
     C     VSUFLD        WHENEQ    'VKWF04'
     C                   Z-ADD     VSRAWT        DSWAOFWF04
     C     VSUFLD        WHENEQ    'VKWF05'
     C                   Z-ADD     VSRAWT        DSWAOFWF05
     C     VSUFLD        WHENEQ    'VKWF06'
     C                   Z-ADD     VSRAWT        DSWAOFWF06
     C     VSUFLD        WHENEQ    'VKWF07'
     C                   Z-ADD     VSRAWT        DSWAOFWF07
     C     VSUFLD        WHENEQ    'VKWF08'
     C                   Z-ADD     VSRAWT        DSWAOFWF08
     C     VSUFLD        WHENEQ    'VKWF09'
     C                   Z-ADD     VSRAWT        DSWAOFWF09
     C     VSUFLD        WHENEQ    'VKWF10'
     C                   Z-ADD     VSRAWT        DSWAOFWF10
     C     VSUFLD        WHENEQ    'VKWF11'
     C                   Z-ADD     VSRAWT        DSWAOFWF11
     C     VSUFLD        WHENEQ    'VKWF12'
     C                   Z-ADD     VSRAWT        DSWAOFWF12
     C     VSUFLD        WHENEQ    'VKWF13'
     C                   Z-ADD     VSRAWT        DSWAOFWF13
     C     VSUFLD        WHENEQ    'VKWF14'
     C                   Z-ADD     VSRAWT        DSWAOFWF14
     C     VSUFLD        WHENEQ    'VKWF15'
     C                   Z-ADD     VSRAWT        DSWAOFWF15
     C     VSUFLD        WHENEQ    'VKWF16'
     C                   Z-ADD     VSRAWT        DSWAOFWF16
     C     VSUFLD        WHENEQ    'VKWF17'
     C                   Z-ADD     VSRAWT        DSWAOFWF17
     C     VSUFLD        WHENEQ    'VKWF18'
     C                   Z-ADD     VSRAWT        DSWAOFWF18
     C     VSUFLD        WHENEQ    'VKWF19'
     C                   Z-ADD     VSRAWT        DSWAOFWF19
     C     VSUFLD        WHENEQ    'VKWF20'
     C                   Z-ADD     VSRAWT        DSWAOFWF20
     C     VSUFLD        WHENEQ    'VKWF21'
     C                   Z-ADD     VSRAWT        DSWAOFWF21
     C     VSUFLD        WHENEQ    'VKWF22'
     C                   Z-ADD     VSRAWT        DSWAOFWF22
     C     VSUFLD        WHENEQ    'VKWF23'
     C                   Z-ADD     VSRAWT        DSWAOFWF23
     C     VSUFLD        WHENEQ    'VKWF24'
     C                   Z-ADD     VSRAWT        DSWAOFWF24
     C     VSUFLD        WHENEQ    'VKWF25'
     C                   Z-ADD     VSRAWT        DSWAOFWF25
     C     VSUFLD        WHENEQ    'VKWF26'
     C                   Z-ADD     VSRAWT        DSWAOFWF26
     C     VSUFLD        WHENEQ    'VKWF27'
     C                   Z-ADD     VSRAWT        DSWAOFWF27
     C     VSUFLD        WHENEQ    'VKWF28'
     C                   Z-ADD     VSRAWT        DSWAOFWF28
     C     VSUFLD        WHENEQ    'VKWF29'
     C                   Z-ADD     VSRAWT        DSWAOFWF29
     C     VSUFLD        WHENEQ    'VKWF30'
     C                   Z-ADD     VSRAWT        DSWAOFWF30
     C     VSUFLD        WHENEQ    'VKWF31'
     C                   Z-ADD     VSRAWT        DSWAOFWF31
     C     VSUFLD        WHENEQ    'VKWF32'
     C                   Z-ADD     VSRAWT        DSWAOFWF32
     C     VSUFLD        WHENEQ    'VKWF33'
     C                   Z-ADD     VSRAWT        DSWAOFWF33
     C     VSUFLD        WHENEQ    'VKWF34'
     C                   Z-ADD     VSRAWT        DSWAOFWF34
     C     VSUFLD        WHENEQ    'VKWF35'
     C                   Z-ADD     VSRAWT        DSWAOFWF35
     C     VSUFLD        WHENEQ    'VKWF36'
     C                   Z-ADD     VSRAWT        DSWAOFWF36
     C     VSUFLD        WHENEQ    'VKWF37'
     C                   Z-ADD     VSRAWT        DSWAOFWF37
     C     VSUFLD        WHENEQ    'VKWF38'
     C                   Z-ADD     VSRAWT        DSWAOFWF38
     C     VSUFLD        WHENEQ    'VKWF39'
     C                   Z-ADD     VSRAWT        DSWAOFWF39
     C     VSUFLD        WHENEQ    'VKWF40'
     C                   Z-ADD     VSRAWT        DSWAOFWF40
     C     VSUFLD        WHENEQ    'VKWF41'
     C                   Z-ADD     VSRAWT        DSWAOFWF41
     C     VSUFLD        WHENEQ    'VKWF42'
     C                   Z-ADD     VSRAWT        DSWAOFWF42
     C     VSUFLD        WHENEQ    'VKWF43'
     C                   Z-ADD     VSRAWT        DSWAOFWF43
     C     VSUFLD        WHENEQ    'VKWF44'
     C                   Z-ADD     VSRAWT        DSWAOFWF44
     C     VSUFLD        WHENEQ    'VKWF45'
     C                   Z-ADD     VSRAWT        DSWAOFWF45
     C     VSUFLD        WHENEQ    'VKWF46'
     C                   Z-ADD     VSRAWT        DSWAOFWF46
     C     VSUFLD        WHENEQ    'VKWF47'
     C                   Z-ADD     VSRAWT        DSWAOFWF47
     C     VSUFLD        WHENEQ    'VKWF48'
     C                   Z-ADD     VSRAWT        DSWAOFWF48
     C     VSUFLD        WHENEQ    'VKWF49'
     C                   Z-ADD     VSRAWT        DSWAOFWF49
     C     VSUFLD        WHENEQ    'VKWF50'
     C                   Z-ADD     VSRAWT        DSWAOFWF50
     C     VSUFLD        WHENEQ    'VKWF51'
     C                   Z-ADD     VSRAWT        DSWAOFWF51
     C     VSUFLD        WHENEQ    'VKWF52'
     C                   Z-ADD     VSRAWT        DSWAOFWF52
     C     VSUFLD        WHENEQ    'VKWF53'
     C                   Z-ADD     VSRAWT        DSWAOFWF53
     C     VSUFLD        WHENEQ    'VKWF54'
     C                   Z-ADD     VSRAWT        DSWAOFWF54
     C     VSUFLD        WHENEQ    'VKWF55'
     C                   Z-ADD     VSRAWT        DSWAOFWF55
     C     VSUFLD        WHENEQ    'VKWF56'
     C                   Z-ADD     VSRAWT        DSWAOFWF56
     C     VSUFLD        WHENEQ    'VKWF57'
     C                   Z-ADD     VSRAWT        DSWAOFWF57
     C     VSUFLD        WHENEQ    'VKWF58'
     C                   Z-ADD     VSRAWT        DSWAOFWF58
     C     VSUFLD        WHENEQ    'VKWF59'
     C                   Z-ADD     VSRAWT        DSWAOFWF59
     C     VSUFLD        WHENEQ    'VKWF60'
     C                   Z-ADD     VSRAWT        DSWAOFWF60
     C                   ENDSL
     C* -------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      UWAOF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE BEREICH                                                    ***
     C**************************************************************************
     C     UPWAOFBERE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ETEPR                                         ERMITTLEN BEREICH
     C     WKBERE        IFEQ      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOF
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  WKBERE        WAOFBERE
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BEREICH AUS TEPR                                        ***
     C**************************************************************************
     C     ETEPR         BEGSR
     C*
     C                   MOVE      *BLANK        WKBERE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYTEPR
     C                   MOVEL     DAFIRM        KYTRFI
     C                   MOVEL     WAOFVEUR      KYTRNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHTEPR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     TRFIRM        IFNE      KYTRFI                                       VERGLEICHEN
     C     TRTENR        ORNE      KYTRNR                                       OBERGRENZE
     C     TREZNR        ORNE      KYTREZ
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     TRKAJJ        IFEQ      WAOFKAJJ
     C     TRKANR        ANDEQ     WAOFKANR
     C                   MOVEL(P)  TRBERE        WKBERE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHTEPR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE WAOF  BEREICH                                              ***
     C**************************************************************************
     C     U2WAOFBERE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOF
     C                   MOVEL     DAFIRM        KYWAOFFIRM
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOF
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     WAOFFIRM      IFNE      KYWAOFFIRM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        WKBERE
     C*
     C                   EXSR      ETEPR                                         ERMITTLEN BEREICH
     C*
     C                   Z-ADD     WAOFKAJJ      KYWAOFKAJJ
     C                   MOVEL(P)  WAOFKANR      KYWAOFKANR
     C                   MOVEL(P)  WAOFVEUR      KYWAOFVEUR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOF
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  WKBERE        WAOFBERE
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KAJJ                                                   ***
     C**************************************************************************
     C     PRWAOFKAJJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFKAJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KANR                                                   ***
     C**************************************************************************
     C     PRWAOFKANR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFKANR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     MCWAOFVEUR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOFVEUR    KOM(01)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0526'        #CUEBE
     C                   EXSR      MCTEIL
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAOFVEUR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     PRWAOFVEUR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFVEUR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOFVEUR    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOFVEUR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSWAOFVEUR
     C                   MOVEL(P)  TETBZ1        TXTEILTBZ1
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE WF01                                                   ***
     C**************************************************************************
     C     PRWAOFWF01    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFWF01'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NKAJ                                                   ***
     C**************************************************************************
     C     PRWAOFNKAJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFNKAJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NKAN                                                   ***
     C**************************************************************************
     C     PRWAOFNKAN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFNKAN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     MCWAOFNVEU    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOFNVEU    KOM(01)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0526'        #CUEBE
     C                   EXSR      MCTEIL
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAOFNVEU
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VEUR                                                   ***
     C**************************************************************************
     C     PRWAOFNVEU    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFNVEU'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOFNVEU    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOFNVEU    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSWAOFNVEU
     C                   ENDIF
     C                   ENDIF
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
     C                   MOVEL(P)  'WAOF'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOF
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOF'        EXDATAFILE
     C                   MOVEL(P)  WAOF          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS WAOF                                          ***
     C**************************************************************************
     C     ERWAOF        BEGSR
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
     C                   MOVEL(P)  'TRWAOF'      KYTAPA
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
     C                   MOVEL(P)  'TRWAOF'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAOFB1'    EXTRDNPGNA
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
     C     *LIKE         DEFINE    KYWAOFKAJJ    OFWAOFKAJJ
     C     *LIKE         DEFINE    KYWAOFKANR    OFWAOFKANR
     C     *LIKE         DEFINE    KYWAOFVEUR    OFWAOFVEUR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOFBERE      WKBERE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOFWF55      DSWAOFWF55
     C     *LIKE         DEFINE    WAOFWF56      DSWAOFWF56
     C     *LIKE         DEFINE    WAOFWF57      DSWAOFWF57
     C     *LIKE         DEFINE    WAOFWF58      DSWAOFWF58
     C     *LIKE         DEFINE    WAOFWF59      DSWAOFWF59
     C     *LIKE         DEFINE    WAOFWF60      DSWAOFWF60
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
     C                   MOVEL(P)  'TRWAOF'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOFW2
     C                   OTHER
     C                   WRITE     TRWAOFCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOFW2
     C                   OTHER
     C                   WRITE     TRWAOFCT
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
     C/COPY QCPYSRC,CHKVKK
     C/COPY QCPYSRC,CHKVKS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEPR
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOF
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
