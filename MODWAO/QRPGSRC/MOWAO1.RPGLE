     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Update W1
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 21.10.2003 Weaco Projekt 2502
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  PGM fürhr Update aus TRLBAP
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMOWAO1FM  CF   E             WORKSTN USROPN
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
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBPC          E DS                  INZ
     D KYLBPC        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D*
     D EXLBVS        E DS                  INZ
     D RTLBVS        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D/COPY QCPYSRC,EXUX01
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
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*                  EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPWAO1'                                     Update WAO1
     C                   EXSR      UPWAO1
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPWAO2'                                     Update WAO1
     C                   EXSR      UPWAO2
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERSTKZ'                                     Update WAO1
     C                   MOVE      '01'          WKIFMT
     C                   MOVEL(P)  EXTRNDUEST    DSWAO1UEST
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ZSWAO1'                                     Update WAO1
     C     EXTRNDFMKZ    ANDEQ     *ON
     C                   MOVE      '01'          WKIFMT
     C                   MOVEL(P)  EXTRNDUEST    DSWAO1UEST
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ZSWAO1'                                     Update WAO1
     C                   MOVEL(P)  EXTRNDUEST    DSWAO1UEST
     C                   MOVEL(P)  EXTRNDSTKZ    DSWAO1STKZ
     C                   MOVEL(P)  EXTRNDBEME    DSWAO1BEME
     C                   EXSR      ZSWAO1
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ZSLBAP'                                     Update WAO1
     C                   MOVEL(P)  EXTRNDUEST    DSWAO1UEST
     C                   MOVEL(P)  EXTRNDSTKZ    DSWAO1STKZ
     C                   MOVEL(P)  EXTRNDBEME    DSWAO1BEME
     C                   EXSR      ZSLBAP
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UXLBAP'                                     ERMITTELN
     C                   EXSR      UXLBAP                                       BENUTZERINDEX
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERFREI'                                     ERM. WAO1 FREI
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C*                  MOVEL     WAO1FREI      RTTRNDDATE
     C                   EVAL      RTTRNDDATE = WAO1FREI+WAO1UEST
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ADUMM '                                     ERM. WAO1 FREI
     C     EXTRNDSTAT    ANDNE     *BLANK
     C                   MOVEL(P)  EXTRNDSTAT    KYLBAPSTAT
     C                   MOVEL(P)  EXTRNDDANA    KYLBAPDANA
     C                   Z-ADD     EXTRNDJAHR    KYLBAPJAHR
     C                   MOVEL(P)  EXTRNDNMKR    KYLBAPNMKR
     C                   MOVE      *LOVAL        KYLBAPPOSI
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHLBAP
     C     LBAPFIRM      IFEQ      KYLBAPFIRM
     C     LBAPSTAT      ANDEQ     KYLBAPSTAT
     C     LBAPDANA      ANDEQ     KYLBAPDANA
     C     LBAPJAHR      ANDEQ     KYLBAPJAHR
     C     LBAPNMKR      ANDEQ     KYLBAPNMKR
     C                   Z-ADD     LBAPAFJJ      KYWAO1LIJJ
     C                   MOVEL     LBAPAFNR      KYWAO1LINR
     C                   Z-ADD     LBAPAFPO      KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C                   MOVEL     WAO1FREI      RTTRNDDATE
     C                   ENDIF
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ADUMM '                                     ERM. WAO1 FREI
     C                   MOVEL(P)  EXTRNDDANA    KYLBAPDANA
     C                   Z-ADD     EXTRNDJAHR    KYLBAPJAHR
     C                   MOVEL(P)  EXTRNDNMKR    KYLBAPNMKR
     C                   MOVE      *LOVAL        KYLBAPPOSI
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBAP
     C     LBAPFIRM      IFEQ      KYLBAPFIRM
     C     LBAPDANA      ANDEQ     KYLBAPDANA
     C     LBAPJAHR      ANDEQ     KYLBAPJAHR
     C     LBAPNMKR      ANDEQ     KYLBAPNMKR
     C                   Z-ADD     LBAPAFJJ      KYWAO1LIJJ
     C                   MOVEL     LBAPAFNR      KYWAO1LINR
     C                   Z-ADD     LBAPAFPO      KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C                   MOVEL     WAO1FREI      RTTRNDDATE
     C                   ENDIF
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      MOWAO1FM                             98
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
     C                   CLOSE     MOWAO1FM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        RTTRNDPRKZ
     C                   MOVEL     *BLANK        RTTRNDKEYB
     C**ZG               MOVEL     *BLANK        RTTRNDDATE
     C*-------------------------------------------------------------------------
     C                   RETURN
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEA(P)  EXTRNDPRKZ    KOM
     C                   MOVEA     KOM(01)       EXTRNDFMKZ                     FORMAT
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        EXTRNDLIJJ
     C*
     C                   MOVEA(P)  KOM(05)       EXTRNDLINR
     C*
     C                   MOVEA     KOM(11)       DUC005
     C                   TESTN                   DUC005               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC005                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN050        EXTRNDLIPO
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C*
     C                   MOVEA(P)  KOM(01)       DUC011
     C                   TESTN                   DUC011               99
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     DUN112        EXTRNDGLMG
     C                   ELSE
     C                   Z-ADD     *ZERO         EXTRNDGLMG
     C                   ENDIF
     C                   MOVEA(P)  KOM(12)       EXTRNDMEIN
     C                   MOVEA(P)  KOM(13)       EXTRNDUEST
     C                   MOVEA(P)  KOM(15)       EXTRNDSTKZ
     C                   MOVEA(P)  KOM(16)       EXTRNDBEME
     C                   MOVEA(P)  KOM(46)       EXTRNDZULG        3
     C                   MOVEA(P)  KOM(49)       EXTRNDZULO        8
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM(57)       EXTRNDDANA
     C                   MOVEA     KOM(67)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        EXTRNDJAHR
     C                   MOVEA(P)  KOM(71)       EXTRNDNMKR
     C                   MOVEA(P)  KOM(77)       EXTRNDSTAT
     C*-------------------------------------------------------------------------
     C*
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYWAO1FIRM                     WAO1
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM                     LBPC
     C                   MOVEL     DAFIRM        KYLBAPFIRM                     LBAP
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOWAO1FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
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
     C                   MOVEL(P)  'MOWAO1FM'    EXFLPOFMTN
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPWAO1 MENGENVERSORGUNG                                           ***
     C**************************************************************************
     C     UPWAO1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C                   MOVEL     WAO1TENR      KYTUTE                         BERECHNEN DER
     C                   MOVEL     EXTRNDMEIN    KYTUME                         GESAMT MENGE
     C                   Z-ADD     EXTRNDGLMG    WKV1V2                         IN IDENT-ME
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        DUN152
     C*
     C                   MOVEL     WAO1TENR      KYTUTE                         BERECHNEN DER
     C                   MOVEL     WAO1MEVS      KYTUME                         GESAMT MENGE
     C                   Z-ADD     WKV1V2        WKV2V1                         IN IDENT-ME
     C                   EXSR      VTEUF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXTRNDGLMG    WHENEQ    *ZERO
     C                   MOVEL     '30'          DSWAO1UEST
     C     WKV2V1        WHENLT    WAO1AFMG
     C                   MOVEL     '35'          DSWAO1UEST
     C     WKV2V1        WHENGE    WAO1AFMG
     C                   MOVEL     '50'          DSWAO1UEST
     C                   ENDSL
     C*
     C                   EXSR      UWAO1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPWAO2 SETZEN STATUS                                              ***
     C**************************************************************************
     C     UPWAO2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAO1GLMG      EXTRNDGLMG
     C                   MOVEL     WAO1MEVI      EXTRNDMEIN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAO1UEST      WHENEQ    '30'
     C                   MOVEL     '80'          DSWAO1UEST                     GESAMT MENGE
     C     WAO1UEST      WHENEQ    '35'
     C                   MOVEL     '80'          DSWAO1UEST                     GESAMT MENGE
     C     WAO1UEST      WHENEQ    '50'
     C                   MOVEL     '80'          DSWAO1UEST                     GESAMT MENGE
     C                   ENDSL
     C*
     C                   EXSR      UWAO1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAO1                                                 ***
     C**************************************************************************
     C     UWAO1         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C     WAO1UEST      IFLT      '80'
     C     EXTRNDGLMG    IFGT      0
     C                   Z-ADD     EXTRNDGLMG    WAO1GLMG
     C**********         ADD       EXTRNDGLMG    WAO1GLMG
     C                   ENDIF
     C                   MOVEL     EXTRNDMEIN    WAO1MEVI
     C                   MOVEL     DSWAO1UEST    WAO1UEST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      WKUSER        WAO1FREI
     C*--------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      CHWAO1
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFUNG LIEFERSCHEIN                                              ***
     C**************************************************************************
     C     PRLIEF        BEGSR
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C     WKFENR        DOWEQ     *ZEROS
     C     KYWAO1FIRM    ANDEQ     WAO1FIRM
     C     KYWAO1LIJJ    ANDEQ     WAO1LIJJ
     C     KYWAO1LINR    ANDEQ     WAO1LINR
     C     KYWAO1RALP    ANDEQ     WAO1RALP
     C*
     C     WAO1UEST      IFLT      '20'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZEROS
     C*-------------------------------------------------------------------------
     C     KYWAO1FIRM    ANDEQ     WAO1FIRM
     C     KYWAO1LIJJ    ANDEQ     WAO1LIJJ
     C     KYWAO1LINR    ANDEQ     WAO1LINR
     C     KYWAO1RALP    ANDEQ     WAO1RALP
     C*
     C     WAO1UEST      IFLT      '80'
     C                   MOVEL(P)  '80'          WAO1UEST
     C                   MOVE      DAUSER        WAO1FREI
     C                   ENDIF
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO1
     C*
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHWAO1
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C*
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO1
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZSWAO1 Zurücksetzen WAO1-Satz, da ohne Bestand                    ***
     C**************************************************************************
     C     ZSWAO1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1RALP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO1
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVEL(P)  '89'          WAO1UEST
     C                   EVAL      WAO1FREX= DSWAO1STKZ + DSWAO1BEME
     C*
     C                   MOVEL(P)  DAJNAM        WAO1JNAM
     C                   MOVEL(P)  WKCHPN        WAO1PROG
     C                   MOVEL(P)  WKCHPL        WAO1BIBL
     C                   MOVEL(P)  DAUSER        WAO1USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO1JZEI
     C                   MOVE      WKTDAT        WAO1JDAT
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN BENUTZERIDEX                                            ***
     C**************************************************************************
     C     UXLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'TRLBAP'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 18 + 303                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 18                              MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung LBAP für Ladeliste'
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BGF2'        KYWAO1DANA
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1JAHR
     C                   MOVEL     EXTRNDLINR    KYWAO1NMKR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1POSI
     C                   MOVEL     *LOVAL        KYWAO1LIJJ
     C                   MOVEL     *LOVAL        KYWAO1LINR
     C                   MOVEL     *LOVAL        KYWAO1RALP
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHWAO1
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     WAO1DANA      IFGT      KYWAO1DANA
     C     WAO1JAHR      ORGT      KYWAO1JAHR
     C     WAO1NMKR      ORGT      KYWAO1NMKR
     C     WAO1POSI      ORGT      KYWAO1POSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     WAO1LIJJ      DUN040
     C                   Z-ADD     WAO1RALP      DUN050
     C*
     C                   EVAL      EXUX01IDTA = DUC004+ WAO1LINR + DUC005
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*--------------------------------------------------------
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHWAO1
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
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
     C                   MOVEL(P)  'WAO1  '      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
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
     C*
     C                   EXSR      EFLPO
     C                   WRITE     MOWAO1W2
     C                   WRITE     MOWAO101
     C                   WRITE     W2WAO1B2
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
     C                   READ      MOWAO101                             9899
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
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'ERSTKZ'                                     Update WAO1
     C                   EVAL      RTTRNDDATE = DSWAO1STKZ + DSWAO1BEME
     C     PCPGST        WHENEQ    'ZSWAO1'                                     Update WAO1
     C                   EXSR      ZSWAO1
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAO1
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAO1
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
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C                   Z-ADD     EXTRNDLIPO    KYWAO1RALP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO1
     C                   MOVEL(P)  WAO1USER      WKUSER
     C                   Z-ADD     WAO1JDAT      WKJDAT
     C                   Z-ADD     WAO1JZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      'ZSWAO1'
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAO1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAO1LIJJ      DSWAO1LIJJ
     C                   MOVEL     WAO1LINR      DSWAO1LINR
     C                   Z-ADD     WAO1RALP      DSWAO1RALP
     C                   MOVEL     WAO1TENR      DSWAO1TENR
     C                   MOVE      *BLANK        DSWAO1STKZ
     C                   MOVE      *BLANK        DSWAO1BEME
     C                   MOVE      *BLANK        TXWAO1STKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSWAO1TENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ                         LESEN
     C                   MOVEA     '01C     '    CHI                            TEILESTAMM
     C                   EXSR      CHTEIL
     C                   MOVEL     TETBZ1        TXTEILTBZ1
     C                   MOVEL     TETBZ2        TXTEILTBZ2
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
     C     PCPGST        WHENEQ    'ZSWAO1'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAO1STKZ'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAO1STKZ'  EXFLPOFLDN
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
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAO1STKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAO1BEME
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE STKZ                                                   ***
     C**************************************************************************
     C     MCWAO1STKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAO1STKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAO1STKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAO1STKZ'  KOM(02)
     C                   MOVEA     DSWAO1STKZ    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAO1STKZ
     C                   MOVEL(P)  TPTTXT        TXWAO1STKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE STKZ                                                   ***
     C**************************************************************************
     C     PRWAO1STKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO1STKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '$$WAO1STKZ'  KYTPTA
     C                   MOVEL(P)  DSWAO1STKZ    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAO1STKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TEXT                                                   ***
     C**************************************************************************
     C     PRWAO1BEME    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAO1BEME'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAO1BEME    IFEQ      *BLANK
     C     DSWAO1STKZ    ANDEQ     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAO1BEME'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAO1STKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAO1STKZ'
     C                   EXSR      MCWAO1STKZ
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STATUS IN SCHNITTSTELLENDATEI ZURÜCKSETZEN                        ***
     C**************************************************************************
     C     ZSLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     LBPCJAHR      KYLBPCJAHR
     C                   MOVEL(P)  LBPCNMKR      KYLBPCNMKR
     C                   Z-ADD     LBPCPOSI      KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTMST
     C*
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C     WKFENR        IFEQ      *ZEROS
     C     KYLBPCFIRM    ANDEQ     LBPCFIRM
     C     KYLBPCJAHR    ANDEQ     LBPCJAHR
     C     KYLBPCNMKR    ANDEQ     LBPCNMKR
     C     KYLBPCPOSI    ANDEQ     LBPCPOSI
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ZSWAO1
     C*
     C                   EXSR      TRLBVSBGFS
     C*
     C                   MOVEL(P)  'BGFS'        KYLBAPDANA
     C                   Z-ADD     KYLBPCJAHR    KYLBAPJAHR
     C                   MOVEL(P)  KYLBPCNMKR    KYLBAPNMKR
     C                   Z-ADD     KYLBPCPOSI    KYLBAPPOSI
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAP
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBAP
     C                   ENDIF
     C*
     C                   MOVEL     *ZEROS        WKFENR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBVS                                                 ***
     C**************************************************************************
     C     TRLBVSBGFS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LORT '       EXLBVSPGST
     C                   MOVEL(P)  EXTRNDZULG    EXLBVSLANR
     c                   MOVEL(P)  EXTRNDZULO    EXLBVSLORT
     C*
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLBVSPROG    WKPROG
     C                   MOVEL(P)  RTLBVSDANA    WKDANA
     C                   MOVEL(P)  RTLBVSFFLD    WKFFLD
     C                   MOVEL(P)  RTLBVSFENR    WKFENR
     C                   MOVEL(P)  RTLBVSPA03    W$PA03
     C                   MOVEL(P)  RTLBVSPA04    W$PA04
     C                   MOVEL(P)  RTLBVSPA05    W$PA05
     C                   MOVEL(P)  RTLBVSPA06    W$PA06
     C                   MOVEL(P)  RTLBVSPA07    W$PA07
     C*
     C                   MOVEL(P)  RTLBVSRTCD    #CRTCD
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO1LIJJ      EXTRNDLIJJ
     C     *LIKE         DEFINE    WAO1LINR      EXTRNDLINR
     C     *LIKE         DEFINE    WAO1RALP      EXTRNDLIPO
     C     *LIKE         DEFINE    DUN112        EXTRNDGLMG
     C     *LIKE         DEFINE    WAO1MEVS      EXTRNDMEIN
     C     *LIKE         DEFINE    WAO1UEST      DSWAO1UEST
     C     *LIKE         DEFINE    WAO1UEST      EXTRNDUEST
     C     *LIKE         DEFINE    WKC001        EXTRNDFMKZ                     FORMAT
     C     *LIKE         DEFINE    DSWAO1BEME    EXTRNDBEME
     C     *LIKE         DEFINE    DSWAO1STKZ    EXTRNDSTKZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO1DANA      EXTRNDDANA
     C     *LIKE         DEFINE    WAO1JAHR      EXTRNDJAHR
     C     *LIKE         DEFINE    WAO1NMKR      EXTRNDNMKR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPSTAT      EXTRNDSTAT
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
     C                   MOVEL(P)  'MOWAO1'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAO1W2
     C                   OTHER
     C                   WRITE     MOWAO1CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTWAO1W2
     C                   OTHER
     C                   WRITE     MOWAO1CT
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
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBPC
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,PRFUKT
     C*COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,MCTRTP
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
