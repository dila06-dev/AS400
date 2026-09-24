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
     H*  Änderung: HR 23.12.2013 Projekt 10083 Zusätzliche ICS-Felder
     H*  Änderung: HR 15.05.2014 Projekt 10378 Zusätzliche ICS-Felder NL
     H*  Änderung: HR 18.04.2019 Projekt 13927 Zusätzliche Felder EMEA..
     H*  Änderung: HR 21.08.2019 Projekt 13927 Änderung Preisgruppe 178 -> 180
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
     FT1WAOFFM  CF   E             WORKSTN USROPN
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
     D EXIFPE        E DS
     D RTIFPE        E DS
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
     C                   CLOSE     T1WAOFFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'TRPREI'
     C                   MOVE      '02'          WKIFMT
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
     C                   OPEN      T1WAOFFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     T1WAOFFM                             98
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
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T1WAOFFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'T1WAOFFM'    EXTRPBBPRG
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
     C                   MOVEL(P)  'T1WAOF'      EXTRDNDANA
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
     C                   MOVEL     'T1WAOF01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     T1WAOF01
     C                   WRITE     T1WAOFB1
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
     C                   READ      T1WAOF01                             9899
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
     C                   EXSR      UPKVKS
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
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C                   MOVEL(P)  WAOFUSER      WKUSER
     C                   Z-ADD     WAOFJDAT      WKJDAT
     C                   Z-ADD     WAOFJZEI      WKJZEI
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOFWF04      DSWAOFWF04
     C                   Z-ADD     WAOFWF09      DSWAOFWF09
     C                   Z-ADD     WAOFWF17      DSWAOFWF17
     C*
     C                   Z-ADD     WAOFWF43      DSWAOFWF43
     C                   Z-ADD     WAOFWF44      DSWAOFWF44
     C                   Z-ADD     WAOFWF45      DSWAOFWF45
     C                   Z-ADD     WAOFWF46      DSWAOFWF46
     C*
     C                   Z-ADD     WAOFWF18      DSWAOFWF18
     C                   Z-ADD     WAOFWF19      DSWAOFWF19
     C                   Z-ADD     WAOFWF20      DSWAOFWF20
     C                   Z-ADD     WAOFWF21      DSWAOFWF21
     C*
     C                   Z-ADD     WAOFWF22      DSWAOFWF22
     C                   Z-ADD     WAOFWF23      DSWAOFWF23
     C                   Z-ADD     WAOFWF24      DSWAOFWF24
     C                   Z-ADD     WAOFWF25      DSWAOFWF25
     C*
     C                   Z-ADD     WAOFWF26      DSWAOFWF26
     C                   Z-ADD     WAOFWF27      DSWAOFWF27
     C                   Z-ADD     WAOFWF28      DSWAOFWF28
     C                   Z-ADD     WAOFWF29      DSWAOFWF29
     C*
     C                   Z-ADD     WAOFWF30      DSWAOFWF30
     C                   Z-ADD     WAOFWF31      DSWAOFWF31
     C                   Z-ADD     WAOFWF32      DSWAOFWF32
     C                   Z-ADD     WAOFWF33      DSWAOFWF33
     C*
     C                   Z-ADD     WAOFWF34      DSWAOFWF34
     C                   Z-ADD     WAOFWF35      DSWAOFWF35
     C                   Z-ADD     WAOFWF36      DSWAOFWF36
     C                   Z-ADD     WAOFWF37      DSWAOFWF37
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXTEILTBZ1                     INITIALISIEREN
     C*-------------------------------------------------------------------------
     C     DSWAOFVEUR    CASNE     *BLANK        PRWAOFVEUR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UFLD'        KYTPTA                         FÜLLEN
     C                   MOVEL(P)  'VKWF04'      KYTPTC                         TEXTFELDER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF04
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF09'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF09
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF17'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF17
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF43'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF43
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF44'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF44
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF45'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF45
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF46'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF46
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF18'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF18
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF22'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF22
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF26'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF26
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF30'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF30
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF34'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF34
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T1WAOF01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
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
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
     C                   ENDSL
     C                   ENDSL
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
     C                   MOVEL     'T1WAOF02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     T1WAOF02
     C                   WRITE     T1WAOFB1
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
     C                   READ      T1WAOF02                             9899
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
     C                   EXSR      VPREI
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
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
     C                   EXSR      B02DS
     C                   ENDIF
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
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOF
     C                   MOVEL(P)  WAOFUSER      WKUSER
     C                   Z-ADD     WAOFJDAT      WKJDAT
     C                   Z-ADD     WAOFJZEI      WKJZEI
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOFWF21      DSWAOFWF21
     C                   Z-ADD     WAOFWF25      DSWAOFWF25
     C                   Z-ADD     WAOFWF29      DSWAOFWF29
     C                   Z-ADD     WAOFWF33      DSWAOFWF33
     C                   Z-ADD     WAOFWF37      DSWAOFWF37
     C                   Z-ADD     WAOFWF46      DSWAOFWF46
     C                   Z-ADD     WAOFWF51      DSWAOFWF51
     C                   Z-ADD     WAOFWF52      DSWAOFWF52
     C                   Z-ADD     WAOFWF53      DSWAOFWF53
     C                   Z-ADD     WAOFWF54      DSWAOFWF54
     C                   Z-ADD     WAOFWF55      DSWAOFWF55
     C                   Z-ADD     WAOFWF56      DSWAOFWF56
     C                   Z-ADD     WAOFWF57      DSWAOFWF57
     C                   Z-ADD     WAOFWF58      DSWAOFWF58
     C                   Z-ADD     WAOFWF59      DSWAOFWF59
     C*-------------------------------------------------------------------------
     C                   MOVE      DANEKZ        DSWAOFUBK1
     C                   MOVE      DANEKZ        DSWAOFUBK2
     C                   MOVE      DANEKZ        DSWAOFUBK3
     C                   MOVE      DANEKZ        DSWAOFUBK4
     C                   MOVE      DANEKZ        DSWAOFUBK5
     C                   MOVE      DANEKZ        DSWAOFUBK6
     C                   MOVE      DANEKZ        DSWAOFUBK7
     C                   MOVE      DANEKZ        DSWAOFUBK8
     C                   MOVE      DANEKZ        DSWAOFUBK9
     C                   MOVE      DANEKZ        DSWAOFUBK0
     C                   MOVE      DANEKZ        DSWAOFUB11
     C                   MOVE      DANEKZ        DSWAOFUB12
     C                   MOVE      DANEKZ        DSWAOFUB13
     C                   MOVE      DANEKZ        DSWAOFUB14
     C                   MOVE      DANEKZ        DSWAOFUB15
     C     DSWAOFWF21    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK1
     C                   ENDIF
     C     DSWAOFWF25    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK2
     C                   ENDIF
     C     DSWAOFWF29    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK3
     C                   ENDIF
     C     DSWAOFWF33    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK4
     C                   ENDIF
     C     DSWAOFWF37    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK5
     C                   ENDIF
     C     DSWAOFWF46    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK6
     C                   ENDIF
     C     DSWAOFWF51    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK7
     C                   ENDIF
     C     DSWAOFWF52    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK8
     C                   ENDIF
     C     DSWAOFWF53    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK9
     C                   ENDIF
     C     DSWAOFWF54    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUBK0
     C                   ENDIF
     C     DSWAOFWF55    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUB11
     C                   ENDIF
     C     DSWAOFWF56    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUB12
     C                   ENDIF
     C     DSWAOFWF57    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUB13
     C                   ENDIF
     C     DSWAOFWF58    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUB14
     C                   ENDIF
     C     DSWAOFWF59    IFNE      *ZERO
     C                   MOVE      DAJNKZ        DSWAOFUB15
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    KYVKJJ
     C                   MOVEL(P)  DSWAOFKANR    KYVKNR
     C                   MOVEL(P)  DSWAOFVEUR    KYVKVU
     C                   MOVEL(P)  DSWAOFVEUR    KYVKTE
     C                   Z-ADD     *ZERO         KYVKSX
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKVKK
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   MOVE      VKSTDA        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSWAOFGADA
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXTEILTBZ1                     INITIALISIEREN
     C*-------------------------------------------------------------------------
     C     DSWAOFVEUR    CASNE     *BLANK        PRWAOFVEUR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV1
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV2
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV3
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV4
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV5
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV6
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV7
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV8
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV9
     C                   MOVEL(P)  TEPDVK        DSWAOFPDV0
     C                   MOVEL(P)  TEPDVK        DSWAOFPD11
     C                   MOVEL(P)  TEPDVK        DSWAOFPD12
     C                   MOVEL(P)  TEPDVK        DSWAOFPD13
     C                   MOVEL(P)  TEPDVK        DSWAOFPD14
     C                   MOVEL(P)  TEPDVK        DSWAOFPD15
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTRPAWACD    DSWAOFWACD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PKG'         DSWAOFBEG1                     BEGRIFF
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG2
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG3
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG4
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG5
     C                   MOVEL(P)  'PVK'         DSWAOFBEG6
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG7
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG8
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG9
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBEG0
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBG11
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBG12
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBG13
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBG14
     C                   MOVEL(P)  DSWAOFBEG1    DSWAOFBG15
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '073'         DSWAOFKDG1                     KUNDEN-PREISGRUPPE
     C                   MOVEL(P)  '072'         DSWAOFKDG2
     C                   MOVEL(P)  '074'         DSWAOFKDG3
     C                   MOVEL(P)  '070'         DSWAOFKDG4
     C                   MOVEL(P)  '075'         DSWAOFKDG5
     C                   MOVEL     *BLANK        DSWAOFKDG6
     C                   MOVEL(P)  '174'         DSWAOFKDG7
     C                   MOVEL(P)  '273'         DSWAOFKDG8
     C                   MOVEL(P)  '373'         DSWAOFKDG9
     C                   MOVEL(P)  '400'         DSWAOFKDG0
     C                   MOVEL(P)  '173'         DSWAOFKG11
     C                   MOVEL(P)  '175'         DSWAOFKG12
     C                   MOVEL(P)  '176'         DSWAOFKG13
     C                   MOVEL(P)  '177'         DSWAOFKG14
     C                   MOVEL(P)  '180'         DSWAOFKG15
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF18'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF18
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF22'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF22
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF26'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF26
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF30'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF30
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF34'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF34
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF46'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF46
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF51'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF51
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF52'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF52
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF53'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF53
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF54'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF54
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF55'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF55
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF56'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF56
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF57'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF57
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF58'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF58
     C*
     C                   MOVEL(P)  'UFLD'        KYTPTA
     C                   MOVEL(P)  'VKWF59'      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        DSKONWF59
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T1WAOF02'    EXTRPBBFMT
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
     C     PCPGST        OREQ      'TRPREI'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
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
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
     C                   ENDSL
     C                   ENDSL
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
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFVEUR'
     C                   EXSR      MCWAOFVEUR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFGADA'
     C                   EXSR      MCWAOFGADA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK1'
     C                   EXSR      MCWAOFUBK1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK2'
     C                   EXSR      MCWAOFUBK2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK3'
     C                   EXSR      MCWAOFUBK3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK4'
     C                   EXSR      MCWAOFUBK4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK5'
     C                   EXSR      MCWAOFUBK5
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK6'
     C                   EXSR      MCWAOFUBK6
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK7'
     C                   EXSR      MCWAOFUBK7
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK8'
     C                   EXSR      MCWAOFUBK8
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK9'
     C                   EXSR      MCWAOFUBK9
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOFUBK0'
     C                   EXSR      MCWAOFUBK0
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
     C     FLDNAM        WHENEQ    'DSWAOFWF21'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFWF21
     C     FLDNAM        WHENEQ    'DSWAOFGADA'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFGADA
     C     FLDNAM        WHENEQ    'DSWAOFUBK1'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK1
     C     FLDNAM        WHENEQ    'DSWAOFUBK2'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK2
     C     FLDNAM        WHENEQ    'DSWAOFUBK3'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK3
     C     FLDNAM        WHENEQ    'DSWAOFUBK4'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK4
     C     FLDNAM        WHENEQ    'DSWAOFUBK5'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK5
     C     FLDNAM        WHENEQ    'DSWAOFUBK6'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK6
     C     FLDNAM        WHENEQ    'DSWAOFUBK7'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK7
     C     FLDNAM        WHENEQ    'DSWAOFUBK8'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK8
     C     FLDNAM        WHENEQ    'DSWAOFUBK9'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK9
     C     FLDNAM        WHENEQ    'DSWAOFUBK0'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOFUBK0
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
     C***  UPDATE DATEI WAOF                                                 ***
     C**************************************************************************
     C     UWAOF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    KYWAOFKAJJ
     C                   MOVEL(P)  DSWAOFKANR    KYWAOFKANR
     C                   MOVEL(P)  DSWAOFVEUR    KYWAOFVEUR
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFWF21    WAOFWF21
     C                   Z-ADD     DSWAOFWF25    WAOFWF25
     C                   Z-ADD     DSWAOFWF29    WAOFWF29
     C                   Z-ADD     DSWAOFWF33    WAOFWF33
     C                   Z-ADD     DSWAOFWF37    WAOFWF37
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
     C***  UPDATE DATEI KVKS                                                 ***
     C**************************************************************************
     C     UPKVKS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    KYVSJJ                         SCHLÜSSEL
     C                   MOVEL(P)  DSWAOFKANR    KYVSNR
     C                   MOVEL(P)  DSWAOFVEUR    KYVSVU
     C*-------------------------------------------------------------------------
     C                   Z-ADD     203           KYVSRF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVKS
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DSWAOFWF21    VSBWPR
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     213           KYVSRF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVKS
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DSWAOFWF25    VSBWPR
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     223           KYVSRF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVKS
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DSWAOFWF29    VSBWPR
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     233           KYVSRF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVKS
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DSWAOFWF33    VSBWPR
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     243           KYVSRF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKVKS
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DSWAOFWF37    VSBWPR
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      TRKA14                                       BEWERTEN KVKS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BEWERTEN RECHENSCHEMA                                             ***
     C**************************************************************************
     C     TRKA14        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C*----------------------------------------------------
     C                   Z-ADD     DSWAOFKAJJ    DUN040                         KALK-JAHR
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSWAOFKANR    KOM(05)                        KALK-NUMMER
     C**                 MOVEA     VKKAAT        KOM(11)                        KALK-ART
     C                   MOVEA     DSWAOFVEUR    KOM(22)
     C*----------------------------------------------------
     C                   MOVEA     KOM           WKKOMM
     C*-------------------------------------------------------------------
     C                   CALL      'TRKA14'                             99      BEWERTUNG
     C                   PARM                    WKKOMM          220            RECHENSCHEMA
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KANR                                                   ***
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
     C***  PR-ROUTINE WF21                                                   ***
     C**************************************************************************
     C     PRWAOFWF21    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFWF21'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE GADA                                                   ***
     C**************************************************************************
     C     MCWAOFGADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOFGADA    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSWAOFGADA    IFEQ      *ZERO
     C                   MOVEL(P)  'POSAKT'      EXDATEPGCD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   Z-ADD     RTDATEDATE    DSWAOFGADA
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GADA                                                   ***
     C**************************************************************************
     C     PRWAOFGADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOFDATE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOFGADA    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSWAOFGADA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK1                                                   ***
     C**************************************************************************
     C     MCWAOFUBK1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK1    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK1                                                   ***
     C**************************************************************************
     C     PRWAOFUBK1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK1    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK2                                                   ***
     C**************************************************************************
     C     MCWAOFUBK2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK2    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK2                                                   ***
     C**************************************************************************
     C     PRWAOFUBK2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK3    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK3                                                   ***
     C**************************************************************************
     C     MCWAOFUBK3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK3    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK3                                                   ***
     C**************************************************************************
     C     PRWAOFUBK3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK3    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK4                                                   ***
     C**************************************************************************
     C     MCWAOFUBK4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK4    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK4                                                   ***
     C**************************************************************************
     C     PRWAOFUBK4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK4    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK5                                                   ***
     C**************************************************************************
     C     MCWAOFUBK5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK5'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK5    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK5                                                   ***
     C**************************************************************************
     C     PRWAOFUBK5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK5'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK5    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK6                                                   ***
     C**************************************************************************
     C     MCWAOFUBK6    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK6'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK6    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK6
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK6                                                   ***
     C**************************************************************************
     C     PRWAOFUBK6    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK6'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK6    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK7                                                   ***
     C**************************************************************************
     C     MCWAOFUBK7    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK7'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK7    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK7
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK7                                                   ***
     C**************************************************************************
     C     PRWAOFUBK7    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK7'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK7    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK8                                                   ***
     C**************************************************************************
     C     MCWAOFUBK8    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK8'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK8    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK8
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK8                                                   ***
     C**************************************************************************
     C     PRWAOFUBK8    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK8'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK8    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK9                                                   ***
     C**************************************************************************
     C     MCWAOFUBK9    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK9'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK9    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK9                                                   ***
     C**************************************************************************
     C     PRWAOFUBK9    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK9'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK9    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE UBK0                                                   ***
     C**************************************************************************
     C     MCWAOFUBK0    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAOFUBK0'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAOFUBK0    EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOFUBK0
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE UBK0                                                   ***
     C**************************************************************************
     C     PRWAOFUBK0    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAOFUBK0'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOFUBK0    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
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
     C***  UPDATE DATEI PREI                                                 ***
     C**************************************************************************
     C     VPREI         BEGSR
     C*
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOFGADA    EXDATEDATV                     UMSETZEN
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV                     GÜLTIG AB DATUM
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKGADA
     C                   MOVEL(P)  DSWAOFWACD    WKWACD
     C                   MOVEL(P)  DSWAOFVEUR    WKTENR
     C                   MOVEL(P)  TEMEVK        WKMEPR
     C     WKMEPR        IFEQ      *BLANK
     C                   MOVEL(P)  TEMEIN        WKMEPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF21    IFNE      *ZERO
     C     DSWAOFUBK1    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG1    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG1    WKKDGR
     C                   MOVEL(P)  DSWAOFWF21    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV1    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK1'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF25    IFNE      *ZERO
     C     DSWAOFUBK2    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG2    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG2    WKKDGR
     C                   MOVEL(P)  DSWAOFWF25    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV2    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK2'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF29    IFNE      *ZERO
     C     DSWAOFUBK3    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG3    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG3    WKKDGR
     C                   MOVEL(P)  DSWAOFWF29    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV3    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK3'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF33    IFNE      *ZERO
     C     DSWAOFUBK4    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG4    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG4    WKKDGR
     C                   MOVEL(P)  DSWAOFWF33    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV4    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK4'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF37    IFNE      *ZERO
     C     DSWAOFUBK5    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG5    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG5    WKKDGR
     C                   MOVEL(P)  DSWAOFWF37    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV5    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK5'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF46    IFNE      *ZERO
     C     DSWAOFUBK6    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG6    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG6    WKKDGR
     C                   MOVEL(P)  DSWAOFWF46    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV6    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK6'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF51    IFNE      *ZERO
     C     DSWAOFUBK7    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG7    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG7    WKKDGR
     C                   MOVEL(P)  DSWAOFWF51    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV7    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK7'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF52    IFNE      *ZERO
     C     DSWAOFUBK8    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG8    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG8    WKKDGR
     C                   MOVEL(P)  DSWAOFWF52    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV8    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK8'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF53    IFNE      *ZERO
     C     DSWAOFUBK9    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG9    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG9    WKKDGR
     C                   MOVEL(P)  DSWAOFWF53    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV9    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK9'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF54    IFNE      *ZERO
     C     DSWAOFUBK0    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBEG0    WKBEGR
     C                   MOVEL(P)  DSWAOFKDG0    WKKDGR
     C                   MOVEL(P)  DSWAOFWF54    WKEZPR
     C                   MOVEL(P)  DSWAOFPDV0    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUBK0'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF55    IFNE      *ZERO
     C     DSWAOFUB11    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBG11    WKBEGR
     C                   MOVEL(P)  DSWAOFKG11    WKKDGR
     C                   MOVEL(P)  DSWAOFWF55    WKEZPR
     C                   MOVEL(P)  DSWAOFPD11    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUB11'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF56    IFNE      *ZERO
     C     DSWAOFUB12    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBG12    WKBEGR
     C                   MOVEL(P)  DSWAOFKG12    WKKDGR
     C                   MOVEL(P)  DSWAOFWF56    WKEZPR
     C                   MOVEL(P)  DSWAOFPD12    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUB12'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF57    IFNE      *ZERO
     C     DSWAOFUB13    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBG13    WKBEGR
     C                   MOVEL(P)  DSWAOFKG13    WKKDGR
     C                   MOVEL(P)  DSWAOFWF57    WKEZPR
     C                   MOVEL(P)  DSWAOFPD13    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUB13'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF58    IFNE      *ZERO
     C     DSWAOFUB14    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBG14    WKBEGR
     C                   MOVEL(P)  DSWAOFKG14    WKKDGR
     C                   MOVEL(P)  DSWAOFWF58    WKEZPR
     C                   MOVEL(P)  DSWAOFPD14    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUB14'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFWF59    IFNE      *ZERO
     C     DSWAOFUB15    ANDEQ     DAJNKZ
     C                   MOVEL(P)  DSWAOFBG15    WKBEGR
     C                   MOVEL(P)  DSWAOFKG15    WKKDGR
     C                   MOVEL(P)  DSWAOFWF59    WKEZPR
     C                   MOVEL(P)  DSWAOFPD15    WKPDVK
     C                   MOVE      'UPDATE'      PCPGST
     C                   EXSR      TRPREI
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'DSWAOFUB15'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOFUBK1    IFEQ      DAJNKZ
     C     DSWAOFUBK2    OREQ      DAJNKZ
     C     DSWAOFUBK3    OREQ      DAJNKZ
     C     DSWAOFUBK4    OREQ      DAJNKZ
     C     DSWAOFUBK5    OREQ      DAJNKZ
     C     DSWAOFUBK6    OREQ      DAJNKZ
     C     DSWAOFUBK7    OREQ      DAJNKZ
     C     DSWAOFUBK8    OREQ      DAJNKZ
     C     DSWAOFUBK9    OREQ      DAJNKZ
     C     DSWAOFUBK0    OREQ      DAJNKZ
     C     DSWAOFUB11    OREQ      DAJNKZ
     C     DSWAOFUB12    OREQ      DAJNKZ
     C     DSWAOFUB13    OREQ      DAJNKZ
     C     DSWAOFUB14    OREQ      DAJNKZ
     C     DSWAOFUB15    OREQ      DAJNKZ
     C                   EXSR      TRKA14                                       BEWERTEN KVKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'W'
     C                   MOVE      '0070'        WKFENR
     C                   MOVEL     DANEKZ        DSWAOFUBK1
     C                   MOVEL     DANEKZ        DSWAOFUBK2
     C                   MOVEL     DANEKZ        DSWAOFUBK3
     C                   MOVEL     DANEKZ        DSWAOFUBK4
     C                   MOVEL     DANEKZ        DSWAOFUBK5
     C                   MOVEL     DANEKZ        DSWAOFUBK6
     C                   MOVEL     DANEKZ        DSWAOFUBK7
     C                   MOVEL     DANEKZ        DSWAOFUBK8
     C                   MOVEL     DANEKZ        DSWAOFUBK9
     C                   MOVEL     DANEKZ        DSWAOFUBK0
     C                   MOVEL     DANEKZ        DSWAOFUB11
     C                   MOVEL     DANEKZ        DSWAOFUB12
     C                   MOVEL     DANEKZ        DSWAOFUB13
     C                   MOVEL     DANEKZ        DSWAOFUB14
     C                   MOVEL     DANEKZ        DSWAOFUB15
     C                   Z-ADD     *ZERO         DSWAOFWF21
     C                   Z-ADD     *ZERO         DSWAOFWF25
     C                   Z-ADD     *ZERO         DSWAOFWF29
     C                   Z-ADD     *ZERO         DSWAOFWF33
     C                   Z-ADD     *ZERO         DSWAOFWF37
     C                   Z-ADD     *ZERO         DSWAOFWF46
     C                   Z-ADD     *ZERO         DSWAOFWF51
     C                   Z-ADD     *ZERO         DSWAOFWF52
     C                   Z-ADD     *ZERO         DSWAOFWF53
     C                   Z-ADD     *ZERO         DSWAOFWF54
     C                   Z-ADD     *ZERO         DSWAOFWF55
     C                   Z-ADD     *ZERO         DSWAOFWF56
     C                   Z-ADD     *ZERO         DSWAOFWF57
     C                   Z-ADD     *ZERO         DSWAOFWF58
     C                   Z-ADD     *ZERO         DSWAOFWF59
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI PREI                                                 ***
     C**************************************************************************
     C     TRPREI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXIFPE
     C                   CLEAR                   RTIFPE
     C                   MOVEL(P)  PCPGST        EXIFPEPGST
     C                   MOVEL(P)  WKBEGR        EXIFPEBEGR
     C                   MOVEL(P)  WKKDGR        EXIFPEKDLG
     C                   MOVEL(P)  WKTENR        EXIFPETENR
     C                   MOVEL(P)  WKWACD        EXIFPEWACD
     C                   Z-ADD     WKGADA        EXIFPEGADA
     C                   Z-ADD     WKEZPR        EXIFPEEZPR
     C                   MOVEL(P)  WKPDVK        EXIFPEPDVK
     C                   MOVEL(P)  WKMEPR        EXIFPEMEPR
     C*
     C                   CALL      'TRPREI'
     C                   PARM                    EXIFPE
     C                   PARM                    RTIFPE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTIFPEPROG    WKPROG
     C                   MOVEL(P)  RTIFPEDANA    WKDANA
     C                   MOVEL(P)  RTIFPEFFLD    WKFFLD
     C                   MOVEL(P)  RTIFPEFENR    WKFENR
     C                   MOVEL(P)  RTIFPEPA03    W$PA03
     C                   MOVEL(P)  RTIFPEPA04    W$PA04
     C                   MOVEL(P)  RTIFPEPA05    W$PA05
     C                   MOVEL(P)  RTIFPEPA06    W$PA06
     C                   MOVEL(P)  RTIFPEPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      'W'           #CRTCD
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
     C                   MOVEL(P)  'T1WAOF'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTATC                         STAMMWÄHRUNG
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAWACD
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
     C                   MOVEL(P)  'T1WAOF'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'T1WAOFB1'    EXTRDNPGNA
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
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTRPAWACD      + 2            STAMMWÄHRUNG
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
     C     *LIKE         DEFINE    EXIFPEIFBG    WKBEGR
     C     *LIKE         DEFINE    EXIFPEWACD    WKWACD
     C     *LIKE         DEFINE    EXIFPEGADA    WKGADA
     C     *LIKE         DEFINE    EXIFPETENR    WKTENR
     C     *LIKE         DEFINE    EXIFPEKDGR    WKKDGR
     C     *LIKE         DEFINE    EXIFPEEZPR    WKEZPR
     C     *LIKE         DEFINE    EXIFPEPDVK    WKPDVK
     C     *LIKE         DEFINE    EXIFPEMEPR    WKMEPR
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
     C                   MOVEL(P)  'T1WAOF'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOFW2
     C                   OTHER
     C                   WRITE     T1WAOFCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAOFW2
     C                   OTHER
     C                   WRITE     T1WAOFCT
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
