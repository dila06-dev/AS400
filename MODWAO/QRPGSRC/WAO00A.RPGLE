     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H**************************************************************************
     H/TITLE Aufruf Drucken Versand-Kontrolle
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO00AFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXFLPO        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXTRPC        E DS                  INZ
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY TAMP/QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      WAO00AFM                             98
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
     C                   CLOSE     WAO00AFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
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
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLDFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYLLFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'MODWAO00A'   EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO00AFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'WAO00AFM'    EXTRPBBPRG
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
     C                   EXSR      EFLPO
     C                   WRITE     WAO00AW1
     C                   WRITE     WAO00A01
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W1WAOAB1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO00A01                             9899
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
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
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
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
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
     C                   OTHER
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      WAO00B
     C*--------------------------------------------------------
     C                   EXSR      RFMTS
     C*--------------------------------------------------------
     C                   ENDSL
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     01            DSANZE
     C     DSOBUN        IFEQ      *BLANKS
     C                   MOVEL(P)  'U'           DSOBUN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILD01                                           ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSANZE'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSANZE'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTENR'
     C                   EXSR      MCAUFRTENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANR'
     C                   EXSR      MCAUFRLANR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLORT'
     C                   EXSR      MCAUFRLORT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLANR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLORT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRANZE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     MCAUFRTENR    BEGSR
     C*
     C                   MOVEL     *BLANKS       TXTBZ1
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSTENR        KOM(1)
     C                   MOVEL     *BLANKS       #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTEIL
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL     TETENR        DSTENR
     C                   MOVEL     TETBZ1        TXTBZ1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRTENR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTENR    '  EXFLPOFLDN
     C                   MOVEL     *BLANKS       TXTBZ1
     C*-------------------------------------------------------------------------
     C     DSTENR        IFNE      *BLANKS
     C                   MOVEL     DSTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     TETENR        DSTENR
     C                   MOVEL     TETBZ1        TXTBZ1
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LANR                                                   ***
     C**************************************************************************
     C     MCAUFRLANR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLANR'      EXFLPOFLDN
     C     DSLANR        IFEQ      *BLANK
     C                   MOVEL     *BLANKS       TXLBZ1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSLANR        KOM(1)
     C                   MOVEA     *ON           KOM(16)
     C                   MOVEL     'LBSD01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLBSD
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL     LDLANR        DSLANR
     C                   MOVEL     LDLBZ1        TXLBZ1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LANR                                                   ***
     C**************************************************************************
     C     PRLANR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLANR    '  EXFLPOFLDN
     C                   MOVEL     *BLANKS       TXLBZ1
     C*-------------------------------------------------------------------------
     C     DSLANR        IFNE      *BLANKS
     C                   MOVEL     DSLANR        KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     LDLBZ1        TXLBZ1
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LORT                                                   ***
     C**************************************************************************
     C     MCAUFRLORT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLORT'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSLORT        KOM(1)
     C                   MOVEA     DSLANR        KOM(22)
     C                   MOVEL     *BLANKS       #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLBPL
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL     LLLORT        DSLORT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LORT                                                   ***
     C**************************************************************************
     C     PRLORT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLORT    '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLORT        IFNE      *BLANKS
     C                   MOVEL     DSLANR        KYLLLA
     C                   MOVEL     DSLORT        KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ANZE                                                   ***
     C**************************************************************************
     C     PRANZE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSANZE    '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSANZE        IFEQ      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKEN ETIKETTEN                                                 ***
     C**************************************************************************
     C     WAO00B        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   MOVEA(P)  DSTENR        KOM(01)
     C                   Z-ADD     DSANZE        DUN020
     C                   MOVEA     DUC002        KOM(16)
     C                   MOVEA(P)  DSLANR        KOM(18)
     C                   MOVEA(P)  DSLORT        KOM(21)
     C                   MOVEA(P)  DSOBUN        KOM(29)
     C                   MOVEA(P)  KOM           EXTRNDKEYB
     C*
     C                   CALL      'WAO00BSB'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
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
     C     *LIKE         DEFINE    WKC001        WKIWND
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
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
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
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
     C                   MOVEL(P)  'WAO00A'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAOAW1
     C                   OTHER
     C                   WRITE     WAO00ACT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAOAW1
     C                   OTHER
     C                   WRITE     WAO00ACT
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
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHLBPL
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCLBSD
     C/COPY QCPYSRC,MCLBPL
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRJJPR
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
