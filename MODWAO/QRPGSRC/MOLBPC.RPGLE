     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2008 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 24.12.2008 WAECO Projekt 5467 - SPLITTUNG DER DRUCKAUSGABE
     H*  --------------------------------------------------------------
     H*
     F**************************************************************************
     F*/
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*/
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMOLBPCFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D PCN             S             10    DIM(10) INZ                          AUFTRAGSNR.
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D LBPC          E DS                  INZ
     D KYLBPC        E DS                  INZ
     D*
     D LBPB          E DS                  INZ
     D KYLBPB        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
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
     D EXTREND       E DS
     D RTTREND       E DS
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D                 DS                  INZ
     D  DUPCNN                       10
     D  DUPCJJ                        4  0 INZ OVERLAY(DUPCNN)
     D  DUPCNR                        6    INZ OVERLAY(DUPCNN:5)
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***     R E C H E N B E S T I M M U N G E N                            ***
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRLBPB'
     C                   EXSR      PRLBPB
     C                   MOVEL     '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    'PRLBAP'
     C                   EXSR      PRLBAP
     C                   MOVEL     '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    'PLLBPC'
     C                   EXSR      PLLBPC
     C                   IF        WKFENR > *ZERO
     C                   MOVEL     '01'          WKIFMT
     C                   ELSE
     C                   MOVEL     '00'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVEL     '00'          WKIFMT
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      MOLBPCFM                             98
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
     C                   CLOSE     MOLBPCFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C*-------------------------------------------------------------------------
     C                   RETURN
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM                     LBPC
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYLBPBFIRM                     LBPB
     C                   MOVEL(P)  DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOLBPCFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        EXTRNDPCJJ
     C*
     C                   MOVEA     KOM(05)       EXTRNDPCNR
     C*
     C                   MOVEA(P)  KOM(11)       EXTRNDDANA
     C                   MOVEA     KOM(21)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        EXTRNDJAHR
     C                   MOVEA(P)  KOM(25)       EXTRNDNMKR
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
     C*-------------------------------------------------------------------------
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PRLBPB     PRÜFEN AUFTRAGS-POSTIONENE                          ***
     C**************************************************************************
     C     PRLBPB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKLBPBLPBE
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPCJJ    KYLBPCPCJJ
     C                   MOVEL     EXTRNDPCNR    KYLBPCPCNR
     C                   MOVEL(P)  *LOVAL        KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCPCJJ      ORNE      KYLBPCPCJJ
     C     LBPCPCNR      ORNE      KYLBPCPCNR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBPCTENR      KYTENR                         PRÜFEN
     C                   MOVEL     *BLANK        KYTEEZ                         IDENTNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   Z-ADD(H)  LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C*--------------------------------------------------------
     C                   EXSR      P1LBPB
     C     WKLBPBLPBE    IFNE      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKLBPBLPBE    RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB DIE PLÄTZE ZU DEM LAGERBEREICH  ZUGEORDNET SIND        ***
     C**************************************************************************
     C     P1LBPB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     TELORT        WHENNE    *BLANK
     C                   MOVEL(P)  LBRSLANR      KYLBPBLANR
     C                   MOVEL(P)  TELORT        KYLBPBLPBE
     C                   MOVEL(P)  LBRSLORT      KYLBPBLORT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPB
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL     LBPBLPBE      WKLBPBLPBE
     C                   ENDIF
     C                   OTHER
     C                   MOVEL(P)  LBRSLANR      KYLBPBLANR
     C                   MOVEL(P)  LBRSLORT      KYLBPBLORT
     C                   MOVEL(P)  *LOVAL        KYLBPBLPBE
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPB
     C     CHI(5)        IFEQ      'J'
     C     LBPBFIRM      ANDEQ     KYLBPBFIRM
     C     LBPBLANR      ANDEQ     KYLBPBLANR
     C     LBPBLORT      ANDEQ     KYLBPBLORT
     C                   MOVEL     LBPBLPBE      WKLBPBLPBE
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PRLBAP     PRÜFEN AUSLAGERUNGSPOSITION                         ***
     C**************************************************************************
     C     PRLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDATE    LBAP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBAPDANA      KYLBPCDANA
     C                   Z-ADD     LBAPJAHR      KYLBPCJAHR
     C                   MOVEL(P)  LBAPNMKR      KYLBPCNMKR
     C                   Z-ADD     LBAPPOSI      KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCDANA      ORNE      KYLBPCDANA
     C     LBPCJAHR      ORNE      KYLBPCJAHR
     C     LBPCNMKR      ORNE      KYLBPCNMKR
     C     LBPCPOSI      ORNE      KYLBPCPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     LBPCSTAT      WHENEQ    '90'
     C     LBPCPCJJ      WHENEQ    EXTRNDPCJJ
     C     LBPCPCNR      ANDEQ     EXTRNDPCNR
     C                   OTHER
     C     LBPCPCJJ      IFGT      EXTRNDPCJJ
     C     LBPCPCNR      ORGT      EXTRNDPCNR
     C                   MOVE      '0003'        RTTRNDFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
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
     C                   MOVEL(P)  'MOLBPC'      EXTRDNDANA
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
     C                   EXSR      EFLPO
     C                   WRITE     MOLBPCW3
     C                   WRITE     MOLBPC01
     C                   WRITE     W3LBPCB1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MOLBPC01                             9899
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
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C*                  EVAL      RTTRNDDATE
     C*--------------------------------------------------------
     C                   EXSR      RFMTS
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
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDPCJJ    DSLBPCPCJJ
     C                   MOVEL     EXTRNDPCNR    DSLBPCPCNR
     C                   MOVEL     EXTRNDDANA    DSLBPCDANA
     C                   Z-ADD     EXTRNDJAHR    DSLBPCJAHR
     C                   MOVEL     EXTRNDNMKR    DSLBPCNMKR
     C*-------------------------------------------------------------------------
     C                   DO        10            I0
     C                   IF        PCN(I0)=*BLANK
     C                   MOVE      *ZERO         DUPCJJ
     C                   MOVEL     *BLANK        DUPCNR
     C                   MOVEA     DUPCNN        PCN(I0)
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEA     PCN(1)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ1
     C                   MOVEL     DUPCNR        DSLBPCPCN1
     C                   MOVEA     PCN(2)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ2
     C                   MOVEL     DUPCNR        DSLBPCPCN2
     C                   MOVEA     PCN(3)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ3
     C                   MOVEL     DUPCNR        DSLBPCPCN3
     C                   MOVEA     PCN(4)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ4
     C                   MOVEL     DUPCNR        DSLBPCPCN4
     C                   MOVEA     PCN(5)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ5
     C                   MOVEL     DUPCNR        DSLBPCPCN5
     C                   MOVEA     PCN(6)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ6
     C                   MOVEL     DUPCNR        DSLBPCPCN6
     C                   MOVEA     PCN(7)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ7
     C                   MOVEL     DUPCNR        DSLBPCPCN7
     C                   MOVEA     PCN(8)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ8
     C                   MOVEL     DUPCNR        DSLBPCPCN8
     C                   MOVEA     PCN(9)        DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ9
     C                   MOVEL     DUPCNR        DSLBPCPCN9
     C                   MOVEA     PCN(10)       DUPCNN
     C                   Z-ADD     DUPCJJ        DSLBPCPCJ0
     C                   MOVEL     DUPCNR        DSLBPCPCN0
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C                   MOVE      '3204'        WKFENR
     C                   MOVEL(P)  *BLANK        EXFLPOFLDN
     C                   MOVE      *BLANK        #CRTCD
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
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
     C     FLDNAM        ANDEQ     'DSLBPCDANA'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCDANA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PLLBPC     PRÜFEN Paralell-Pickliste                           ***
     C**************************************************************************
     C     PLLBPC        BEGSR
     C*
     C                   MOVE      *ZERO         RTTRNDFENR
     C                   MOVEA     *BLANK        PCN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDANA    KYLBPCDANA
     C                   Z-ADD     EXTRNDJAHR    KYLBPCJAHR
     C                   MOVEL(P)  EXTRNDNMKR    KYLBPCNMKR
     C                   Z-ADD     *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCDANA      ORNE      KYLBPCDANA
     C     LBPCJAHR      ORNE      KYLBPCJAHR
     C     LBPCNMKR      ORNE      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     LBPCPCJJ      WHENEQ    EXTRNDPCJJ
     C     LBPCPCNR      ANDEQ     EXTRNDPCNR
     C                   OTHER
     C                   MOVE      '0003'        RTTRNDFENR
     C*
     C                   Z-ADD     LBPCPCJJ      DUPCJJ
     C                   MOVEL     LBPCPCNR      DUPCNR
     C                   Z-ADD     1             I0
     C     DUPCNN        LOOKUP    PCN(I0)                                98
     C     *IN98         IFEQ      *OFF
     C                   Z-ADD     1             I0
     C     *BLANK        LOOKUP    PCN(I0)                                98
     C                   ENDIF
     C                   IF        I0>0 and I0<11
     C                   MOVEA     DUPCNN        PCN(I0)
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      RTTRNDFENR    WKFENR
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-RTLBPC     PRÜFEN Paralell-Pickliste                           ***
     C**************************************************************************
     C     ERLBPC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDANA    KYLBPCDANA
     C                   Z-ADD     EXTRNDJAHR    KYLBPCJAHR
     C                   MOVEL(P)  EXTRNDNMKR    KYLBPCNMKR
     C                   Z-ADD     *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCDANA      ORNE      KYLBPCDANA
     C     LBPCJAHR      ORNE      KYLBPCJAHR
     C     LBPCNMKR      ORNE      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     LBPCPCJJ      WHENEQ    EXTRNDPCJJ
     C     LBPCPCNR      ANDEQ     EXTRNDPCNR
     C                   OTHER
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
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
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIOKZ
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKLBPBLPBE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBPCPCJJ      EXTRNDPCJJ
     C     *LIKE         DEFINE    LBPCPCNR      EXTRNDPCNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBPCDANA      EXTRNDDANA
     C     *LIKE         DEFINE    LBPCJAHR      EXTRNDJAHR
     C     *LIKE         DEFINE    LBPCNMKR      EXTRNDNMKR
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
     C                   MOVEL(P)  'MOLBPC'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTLBPCW3
     C                   OTHER
     C                   WRITE     MOLBPCCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTLBPCW3
     C                   OTHER
     C                   WRITE     MOLBPCCT
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
     C/COPY QCPYSRC,CHLBPC
     C/COPY QCPYSRC,CHLBPB
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
