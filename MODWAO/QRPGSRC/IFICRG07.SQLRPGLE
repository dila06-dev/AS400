     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2004')
     H**************************************************************************
     H/TITLE  Übergabe der Lieferungen  an Crossgate EDIFACT DESADV
     H**************************************************************************
     H*  Copyright 2008 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Version für CROSSGATE-Converter
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 28.07.2009 Pfinder Projekt 5452
     H*  Änderung: RE 30.09.2014 DOMETIC Projekt 10751
     H*  Änderung: PH 03.11.201t DOMETIC Projekt 11683. Ermitteln Partner-Nr aus
     H*            UNB0032 (unter MODWAO)
     F**************************************************************************
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D ICRG          E DS                  INZ
     D*
     D DESA          E DS                  INZ
     D KYDESA        E DS                  INZ
     D*
     D ZKUN          E DS                  INZ
     D KYZKUN        E DS                  INZ
     D*
     D ZVDA          E DS                  INZ
     D KYZVDA        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,INHOUSE96A
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D  WKTSTP                         Z   INZ
     D*
     D WKICRG        E DS                  EXTNAME(ICRG) PREFIX(WK) INZ
     D**************************************************************************
     D*1*  DATENSTATIONSARBEITSBEREICH                                       ***
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
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      VDESA
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
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
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUFROUTINE                                                    ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DESA                                                  ***
     C**************************************************************************
     C     VDESA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   WKICRG
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKV1000LINNUM
     C                   Z-ADD     *ZERO         WKV1200LINNUM
     C                   Z-ADD     *ZERO         WKV1500LINNUM
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C                   Z-ADD     *ZERO         WKV1555LINNUM
     C                   Z-ADD     *ZERO         WKV1570LINNUM
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYDESAKYNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHDESA
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     DESASAAR      IFEQ      'BGM'
     C     WKMAIKEY      IFNE      *BLANK
     C                   EXSR      UXEORF
     C                   ENDIF
     C                   EXSR      EMAIKEY
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      VRDESA
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHDESA
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKMAIKEY      IFNE      *BLANK
     C                   EXSR      UXEORF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DESA                                                  ***
     C**************************************************************************
     C     VRDESA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DESASAAR      CASEQ     'ALI'         VALI
     C     DESASAAR      CASEQ     'BGM'         VBGM
     C     DESASAAR      CASEQ     'CNT'         VCNT
     C     DESASAAR      CASEQ     'COM'         VCOM
     C     DESASAAR      CASEQ     'CPS'         VCPS
     C     DESASAAR      CASEQ     'CTA'         VCTA
     C     DESASAAR      CASEQ     'DGS'         VDGS
     C     DESASAAR      CASEQ     'DLM'         VDLM
     C     DESASAAR      CASEQ     'DTM'         VDTM
     C     DESASAAR      CASEQ     'EQA'         VEQA
     C     DESASAAR      CASEQ     'EQD'         VEQD
     C     DESASAAR      CASEQ     'FTX'         VFTX
     C     DESASAAR      CASEQ     'GIN'         VGIN
     C     DESASAAR      CASEQ     'GIR'         VGIR
     C     DESASAAR      CASEQ     'HAN'         VHAN
     C     DESASAAR      CASEQ     'IMD'         VIMD
     C     DESASAAR      CASEQ     'LIN'         VLIN
     C     DESASAAR      CASEQ     'LOC'         VLOC
     C     DESASAAR      CASEQ     'MEA'         VMEA
     C     DESASAAR      CASEQ     'MOA'         VMOA
     C     DESASAAR      CASEQ     'NAD'         VNAD
     C     DESASAAR      CASEQ     'PAC'         VPAC
     C     DESASAAR      CASEQ     'PCD'         VPCD
     C     DESASAAR      CASEQ     'PCI'         VPCI
     C     DESASAAR      CASEQ     'PIA'         VPIA
     C     DESASAAR      CASEQ     'QTY'         VQTY
     C     DESASAAR      CASEQ     'QVR'         VQVR
     C     DESASAAR      CASEQ     'RFF'         VRFF
     C     DESASAAR      CASEQ     'SEL'         VSEL
     C     DESASAAR      CASEQ     'SGP'         VSGP
     C     DESASAAR      CASEQ     'TDT'         VTDT
     C     DESASAAR      CASEQ     'TOD'         VTOD
     C     DESASAAR      CASEQ     'UNB'         VUNB
     C     DESASAAR      CASEQ     'UNH'         VUNH
     C     DESASAAR      CASEQ     'UNS'         VUNS
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VALI                                                              ***
     C**************************************************************************
     C     VALI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      ALI
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     ALI3239       A3#31
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C*
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1570LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VBGM                                                              ***
     C**************************************************************************
     C     VBGM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      BGM
     C*-------------------------------------------------------------------------
     C                   MOVEL     BGM1004       MAIKEY
     C                   MOVEL     BGM1004       WKMAIKEY
     C                   MOVEL     BGM1004       A35#12
     C*                  MOVEL     '1'           A1#1
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1000LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1200LINNUM
     C                   Z-ADD     *ZERO         WKV1500LINNUM
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C                   Z-ADD     *ZERO         WKV1555LINNUM
     C                   Z-ADD     *ZERO         WKV1570LINNUM
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VCNT                                                              ***
     C**************************************************************************
     C     VCNT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VCPS                                                              ***
     C**************************************************************************
     C     VCPS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      CPS
     C*-------------------------------------------------------------------------
     C     CPS7164       IFEQ      '1'
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     CPS7164       A12#1
     C                   MOVEL     CPS7075       A3#01
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C                   Z-ADD     *ZERO         WKV1555LINNUM
     C                   Z-ADD     *ZERO         WKV1570LINNUM
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VCOM                                                              ***
     C**************************************************************************
     C     VCOM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      COM
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VCTA                                                              ***
     C**************************************************************************
     C     VCTA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      CTA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VDGS                                                              ***
     C**************************************************************************
     C     VDGS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      DGS
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VDLM                                                              ***
     C**************************************************************************
     C     VDLM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      DLM
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VDTM                                                              ***
     C**************************************************************************
     C     VDTM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      DTM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     DTM2005       WHENEQ    '171'
     C                   MOVEL     DTM2380       A35#06
     C                   MOVEL     DTM2380       A35#04
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     WKV1570LINNUM IFNE      *ZERO
     C     RFFON         ANDEQ     *ON
     C                   CLEAR                   ICRG
     C                   MOVEL     DTM2380       A14#1
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C     WKV1570LINNUM IFNE      *ZERO
     C     RFFVN         ANDEQ     *ON
     C                   CLEAR                   ICRG
     C                   MOVEL     DTM2380       A14#2
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C     DTM2005       WHENEQ    '137'
     C                   MOVEL     DTM2380       A14#1
     C                   MOVEL     DTM2380       A25#1
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     DTM2005       WHENEQ    '11 '
     C                   MOVEL     DTM2380       A14#4
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     DTM2005       WHENEQ    '17 '
     C                   MOVEL     DTM2380       A14#5
     C                   MOVEL     DTM2380       A35#07
     C                   MOVEL     DTM2380       A35#03
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VEQA                                                              ***
     C**************************************************************************
     C     VEQA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      EQA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VEQD                                                              ***
     C**************************************************************************
     C     VEQD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      EQD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     EQD8053       A3#15
     C                   MOVEL     EQD8260       A17#1
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VFTX                                                              ***
     C**************************************************************************
     C     VFTX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      FTX
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VGIN                                                              ***
     C**************************************************************************
     C     VGIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      GIN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     GIN7405       WHENEQ    'BX'
     C                   MOVEL     GIN7402#1     A35#15
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   Z-ADD     WKV1575LINNUM LINNUM
     C                   EXSR      UICRG
     C     GIN7405       WHENEQ    'BJ'
     C                   MOVEL     GIN7402#1     A70#15
     C                   MOVEL     GIN7402#2     A70#16
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VGIR                                                              ***
     C**************************************************************************
     C     VGIR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      GIR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     GIR7297       WHENEQ    '3'
     C                   SELECT
     C     GIR7405#1     WHENEQ    'AW'
     C                   MOVEL     GIR7402#1     A35#11
     C     GIR7405#2     WHENEQ    'AW'
     C                   MOVEL     GIR7402#2     A35#11
     C     GIR7405#3     WHENEQ    'AW'
     C                   MOVEL     GIR7402#3     A35#11
     C                   ENDSL
     C*
     C                   SELECT
     C     GIR7405#1     WHENEQ    'AL'
     C                   MOVEL     GIR7402#1     A35#10
     C     GIR7405#2     WHENEQ    'AL'
     C                   MOVEL     GIR7402#2     A35#10
     C     GIR7405#3     WHENEQ    'AL'
     C                   MOVEL     GIR7402#3     A35#10
     C                   ENDSL
     C*
     C                   SELECT
     C     GIR7405#1     WHENEQ    'ML'
     C                   MOVEL     GIR7402#1     A35#13
     C     GIR7405#2     WHENEQ    'ML'
     C                   MOVEL     GIR7402#2     A35#13
     C     GIR7405#3     WHENEQ    'ML'
     C                   MOVEL     GIR7402#3     A35#13
     C                   ENDSL
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VHAN                                                              ***
     C**************************************************************************
     C     VHAN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      HAN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VIMD                                                              ***
     C**************************************************************************
     C     VIMD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      IMD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C                   MOVEL     IMD7008#1     A35#06
     C                   MOVEL     IMD7008#2     A35#07
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VLIN                                                              ***
     C**************************************************************************
     C     VLIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      LIN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C                   Z-ADD     LIN1082#1     N6#1
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1570LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VLOC                                                              ***
     C**************************************************************************
     C     VLOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      LOC
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     LOC3227       WHENEQ    '11 '
     C                   MOVEL     LOC3225       A25#2
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VMEA                                                              ***
     C**************************************************************************
     C     VMEA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      MEA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     MEA6311       WHENEQ    'AAX'
     C     MEA6312       ANDEQ     'G  '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        NP3#3
     C                   MOVEL     MEA6411       A3#03
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'AAX'
     C     MEA6312       ANDEQ     'N  '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        NP3#4
     C                   MOVEL     MEA6411       A3#04
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'AAX'
     C     MEA6312       ANDEQ     'SQ'
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        NP3#2
     C                   MOVEL     MEA6411       A3#02
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'PD '
     C     MEA6312       ANDEQ     'LN '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        N18#3
     C                   MOVEL     MEA6411       A3#05
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   Z-ADD     WKV1575LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'PD '
     C     MEA6312       ANDEQ     'TH '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        N18#5
     C                   MOVEL     MEA6411       A3#09
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   Z-ADD     WKV1575LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'PD '
     C     MEA6312       ANDEQ     'WD '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        N18#2
     C                   MOVEL     MEA6411       A3#06
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   Z-ADD     WKV1575LINNUM LINNUM
     C                   EXSR      UICRG
     C     MEA6311       WHENEQ    'PD '
     C     MEA6312       ANDEQ     'WT '
     C                   Z-ADD     MEA6314       DUN183
     C                   Z-ADD     DUN183        NP3#4
     C                   MOVEL     MEA6411       A3#08
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   Z-ADD     WKV1575LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VMOA                                                              ***
     C**************************************************************************
     C     VMOA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      MOA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VNAD                                                              ***
     C**************************************************************************
     C     VNAD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *OFF          NADSU
     C                   MOVEL(P)  *OFF          NADBY
     C                   MOVEL(P)  *OFF          NADDP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      NAD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     NAD3035       WHENEQ    'SU '
     C                   MOVEL(P)  *ON           NADSU
     C                   MOVEL     NAD3039       A14#6
     C                   MOVEL     NAD3039       A17#1
     C*
     C                   MOVEL(P)  NAD3036#1     A70#01
     C                   MOVEL(P)  NAD3042#1     A70#02
     C                   MOVEL(P)  NAD3164       A70#03
     C                   MOVEL(P)  NAD3251       A11#2
     C                   MOVEL(P)  NAD3207       A3#30
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     NAD3035       WHENEQ    'BY '
     C                   MOVEL(P)  *ON           NADBY
     C                   MOVEL     NAD3039       A14#4
     C                   MOVEL     NAD3039       A17#2
     C                   MOVEL     NAD3039       A17#6
     C*
     C                   MOVEL(P)  NAD3036#1     A35#05
     C                   MOVEL(P)  NAD3042#1     A35#07
     C                   MOVEL(P)  NAD3164       A35#08
     C                   MOVEL(P)  NAD3251       A9#2
     C                   MOVEL(P)  NAD3207       A3#32
     C*
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     NAD3035       WHENEQ    'DP '
     C                   MOVEL(P)  *ON           NADDP
     C                   MOVEL     NAD3039       A17#3
     C*
     C                   MOVEL(P)  NAD3036#1     A35#14
     C                   MOVEL(P)  NAD3042#1     A35#15
     C                   MOVEL(P)  NAD3164       A35#16
     C                   MOVEL(P)  NAD3251       A9#1
     C                   MOVEL(P)  NAD3207       A3#31
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     NAD3035       WHENEQ    'IV '
     C                   MOVEL     NAD3039       A17#4
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     NAD3035       WHENEQ    'FW '
     C                   MOVEL     NAD3039       A14#8
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPAC                                                              ***
     C**************************************************************************
     C     VPAC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      PAC
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   Z-ADD     PAC7224       DUN080
     C                   Z-ADD     DUN080        N8#1
     C                   MOVEL     PAC7065       A17#1
     C*
     C                   MOVEL     '155000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1550LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1555LINNUM
     C                   Z-ADD     *ZERO         WKV1570LINNUM
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPCD                                                              ***
     C**************************************************************************
     C     VPCD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      PCD
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPCI                                                              ***
     C**************************************************************************
     C     VPCI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      PCI
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     PCI4233       WHENEQ    '17'
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1570LINNUM
     C                   Z-ADD     *ZERO         WKV1575LINNUM
     C     PCI4233       WHENEQ    '15'
     C                   MOVEL     PCI7102#1     A70#01
     C                   MOVEL     PCI7102#2     A70#02
     C                   MOVEL     PCI7102#3     A70#03
     C                   MOVEL     PCI7102#4     A70#04
     C                   MOVEL     PCI7102#5     A70#05
     C*
     C                   MOVEL     '157500000'   WKHRCLVL
     C                   EXSR      IICRG
     C*
     C                   Z-ADD     WKLINNUM      WKV1575LINNUM
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPIA                                                              ***
     C**************************************************************************
     C     VPIA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      PIA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     PIA7143#1     WHENEQ    'EN'
     C                   MOVEL     PIA7140#1     A35#01
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1570LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     PIA7143#1     WHENEQ    'SA'
     C                   MOVEL     PIA7140#1     A35#02
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1570LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     PIA7143#1     WHENEQ    'BP'
     C                   MOVEL     PIA7140#1     A35#03
     C                   MOVEL     PIA7140#1     A70#12
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1570LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VQTY                                                              ***
     C**************************************************************************
     C     VQTY          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      QTY
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     QTY6063       WHENEQ    '3 '
     C                   Z-ADD     QTY6060       DUN180
     C                   Z-ADD     DUN183        NP3#1
     C                   MOVEL     QTY6411       A3#06
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C     QTY6063       WHENEQ    '12'
     C                   Z-ADD     QTY6060       DUN180
     C                   Z-ADD     DUN183        NP5#6
     C                   MOVEL     QTY6411       A3#12
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C     QTY6063       WHENEQ    '192'
     C                   Z-ADD     QTY6060       DUN180
     C                   Z-ADD     DUN183        NP5#5
     C                   MOVEL     QTY6411       A3#11
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VQVR                                                              ***
     C**************************************************************************
     C     VQVR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      QVR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VRFF                                                              ***
     C**************************************************************************
     C     VRFF          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *OFF          RFFON
     C                   MOVEL(P)  *OFF          RFFVN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      RFF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     RFF1153       WHENEQ    'CRN'
     C                   MOVEL     RFF1154       A70#11
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'TB '
     C                   MOVEL     RFF1154       A70#12
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'VN '
     C                   MOVEL     RFF1154       A35#14
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     WKV1570LINNUM IFNE      *ZERO
     C                   MOVEL(P)  *ON           RFFVN
     C                   CLEAR                   ICRG
     C                   MOVEL     RFF1154       A70#05
     C                   MOVEL     RFF1156       A6#2
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'API'
     C     NADSU         ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#10
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C                   CLEAR                   ICRG
     C                   MOVEL     RFF1154       A35#10
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     RFF1153       WHENEQ    'API'
     C     NADBY         ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#09
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'API'
     C     NADDP         ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#11
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'AAT'
     C                   MOVEL     RFF1154       A35#16
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   Z-ADD     WKV1555LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'CN '
     C                   MOVEL     RFF1154       A35#15
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   Z-ADD     WKV1555LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'CR '
     C                   MOVEL     RFF1154       A35#14
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   Z-ADD     WKV1555LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'CW '
     C                   MOVEL     RFF1154       A35#13
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   Z-ADD     WKV1555LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'SN '
     C                   MOVEL     RFF1154       A35#12
     C*
     C                   MOVEL     '155500000'   WKHRCLVL
     C                   Z-ADD     WKV1555LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1555LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'ON '
     C                   MOVEL     RFF1154       A35#05
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     WKV1570LINNUM IFNE      *ZERO
     C                   MOVEL(P)  *ON           RFFON
     C                   CLEAR                   ICRG
     C                   MOVEL     RFF1154       A35#09
     C                   MOVEL     RFF1156       A6#1
     C*
     C                   MOVEL     '157000000'   WKHRCLVL
     C                   Z-ADD     WKV1570LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VSEL                                                              ***
     C**************************************************************************
     C     VSEL          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      SEL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     SEL9308       A11#1
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VSGP                                                              ***
     C**************************************************************************
     C     VSGP          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      SGP
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTDT                                                              ***
     C**************************************************************************
     C     VTDT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      TDT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     TDT8051       A3#12
     C                   MOVEL     TDT8067       A3#06
     C                   MOVEL     TDT3127       A14#8
     C                   MOVEL     TDT8457       A3#07
     C                   MOVEL     TDT8459       A3#08
     C                   MOVEL     TDT7130       A17#8
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTOD                                                              ***
     C**************************************************************************
     C     VTOD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      TOD
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VUNB                                                              ***
     C**************************************************************************
     C     VUNB          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      UNB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  UNB0010       KYKZEB
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHZKUN
     C                   MOVEL(P)  KZKDNR        WKKDNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKDNR        KYZVDAKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZVDA
     C     ZVDAOFLS      IFNE      *BLANK
     C                   MOVEL(P)  ZVDAOFLS      WKKDNR
     C                   ENDIF
     C*
     C                   IF        MODWAO = *ON
     C                   EVAL      WKKDNR = UNB0032
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     UNB0004       A35#01
     C                   MOVEL     UNB0010       A35#02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VUNH                                                              ***
     C**************************************************************************
     C     VUNH          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      UNH
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VUNS                                                              ***
     C**************************************************************************
     C     VUNS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      UNS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VUNT                                                              ***
     C**************************************************************************
     C     VUNT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DESASATZ      UNT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTEL MAINKEY FÜR ICRG                                         ***
     C**************************************************************************
     C     EMAIKEY       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*                  CALL      'EXTSTP'
     C*                  PARM                    WKTSTP
     C*                  MOVEL(P)  WKTSTP        WKMAIKEY
     C*
     C                   MOVEL     'SND'         WKSNDREC
     C                   MOVEL     'DESADV'      WKMSGTYP
     C                   MOVEL     WKKDNR        WKPRTNUM
     C                   Z-ADD     *ZERO         WKLINNUM
     C                   MOVEL     ' '           WKXEORF
     C*--------------------------------------------------------
     C                   MOVEL     'IFICRG07'    WKPGMNM
     C                   MOVEL     DAUSER        WKUSERNM
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WKWRTTIM
     C                   MOVE      WKTDAT        DUN080
     C                   MOVE      DUC008        WKWRTDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  INSERT DATEI ICRG                                                 ***
     C**************************************************************************
     C     IICRG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKHRCLVL      IFEQ      '100000000'
     C                   Z-ADD     *ZERO         WKLINNUM
     C                   ELSE
     C                   ADD       1             WKLINNUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
      /Free
        SQSTMT =
        'INSERT INTO ' + %TRIM(WKTRPALIBL) + '/'+ %TRIM(WKTRPAFILE) +
        ' (SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL,LINNUM';
       IF A1#1 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A1#1';
       ENDIF;
       IF A1#2 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A1#2';
       ENDIF;
       IF A3#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#01';
       ENDIF;
       IF A3#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#02';
       ENDIF;
       IF A3#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#03';
       ENDIF;
       IF A3#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#04';
       ENDIF;
       IF A3#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#05';
       ENDIF;
       IF A3#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#06';
       ENDIF;
       IF A3#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#07';
       ENDIF;
       IF A3#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#08';
       ENDIF;
       IF A3#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#09';
       ENDIF;
       IF A3#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#10';
       ENDIF;
       IF A3#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#11';
       ENDIF;
       IF A3#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#12';
       ENDIF;
       IF A3#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#13';
       ENDIF;
       IF A3#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#14';
       ENDIF;
       IF A3#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#15';
       ENDIF;
       IF A3#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#16';
       ENDIF;
       IF A3#17<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#17';
       ENDIF;
       IF A3#18<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#18';
       ENDIF;
       IF A3#19<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#19';
       ENDIF;
       IF A3#20<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#20';
       ENDIF;
       IF A3#21<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#21';
       ENDIF;
       IF A3#22<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#22';
       ENDIF;
       IF A3#23<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#23';
       ENDIF;
       IF A3#24<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#24';
       ENDIF;
       IF A3#25<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#25';
       ENDIF;
       IF A3#26<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#26';
       ENDIF;
       IF A3#27<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#27';
       ENDIF;
       IF A3#28<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#28';
       ENDIF;
       IF A3#29<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#29';
       ENDIF;
       IF A3#30<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#30';
       ENDIF;
       IF A3#31<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#31';
       ENDIF;
       IF A3#32<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A3#32';
       ENDIF;
       IF A4#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A4#1';
       ENDIF;
       IF A4#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A4#2';
       ENDIF;
       IF A4#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A4#3';
       ENDIF;
       IF A6#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A6#1';
       ENDIF;
       IF A6#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A6#2';
       ENDIF;
       IF A6#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A6#3';
       ENDIF;
       IF A7#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A7#1';
       ENDIF;
       IF A7#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A7#2';
       ENDIF;
       IF A8#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A8#1';
       ENDIF;
       IF A9#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A9#1';
       ENDIF;
       IF A9#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A9#2';
       ENDIF;
       IF A11#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A11#1';
       ENDIF;
       IF A11#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A11#2';
       ENDIF;
       IF A12#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A12#1';
       ENDIF;
       IF A14#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#1';
       ENDIF;
       IF A14#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#2';
       ENDIF;
       IF A14#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#3';
       ENDIF;
       IF A14#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#4';
       ENDIF;
       IF A14#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#5';
       ENDIF;
       IF A14#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#6';
       ENDIF;
       IF A14#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#7';
       ENDIF;
       IF A14#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A14#8';
       ENDIF;
       IF A17#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#1';
       ENDIF;
       IF A17#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#2';
       ENDIF;
       IF A17#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#3';
       ENDIF;
       IF A17#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#4';
       ENDIF;
       IF A17#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#5';
       ENDIF;
       IF A17#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#6';
       ENDIF;
       IF A17#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#7';
       ENDIF;
       IF A17#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A17#8';
       ENDIF;
       IF A25#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A25#1';
       ENDIF;
       IF A25#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A25#2';
       ENDIF;
       IF A35#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#01';
       ENDIF;
       IF A35#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#02';
       ENDIF;
       IF A35#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#03';
       ENDIF;
       IF A35#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#04';
       ENDIF;
       IF A35#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#05';
       ENDIF;
       IF A35#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#06';
       ENDIF;
       IF A35#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#07';
       ENDIF;
       IF A35#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#08';
       ENDIF;
       IF A35#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#09';
       ENDIF;
       IF A35#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#10';
       ENDIF;
       IF A35#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#11';
       ENDIF;
       IF A35#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#12';
       ENDIF;
       IF A35#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#13';
       ENDIF;
       IF A35#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#14';
       ENDIF;
       IF A35#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#15';
       ENDIF;
       IF A35#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A35#16';
       ENDIF;
       IF A70#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#01';
       ENDIF;
       IF A70#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#02';
       ENDIF;
       IF A70#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#03';
       ENDIF;
       IF A70#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#04';
       ENDIF;
       IF A70#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#05';
       ENDIF;
       IF A70#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#06';
       ENDIF;
       IF A70#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#07';
       ENDIF;
       IF A70#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#08';
       ENDIF;
       IF A70#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#09';
       ENDIF;
       IF A70#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#10';
       ENDIF;
       IF A70#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#11';
       ENDIF;
       IF A70#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#12';
       ENDIF;
       IF A70#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#13';
       ENDIF;
       IF A70#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#14';
       ENDIF;
       IF A70#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#15';
       ENDIF;
       IF A70#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,A70#16';
       ENDIF;
       IF N1#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N1#1';
       ENDIF;
       IF N1#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N1#2';
       ENDIF;
       IF N1#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N1#3';
       ENDIF;
       IF N2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N2#1';
       ENDIF;
       IF N2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N2#2';
       ENDIF;
       IF N3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N3#1';
       ENDIF;
       IF N4#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N4#1';
       ENDIF;
       IF N6#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N6#1';
       ENDIF;
       IF N6#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N6#2';
       ENDIF;
       IF N6#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N6#3';
       ENDIF;
       IF N6#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N6#4';
       ENDIF;
       IF N8#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N8#1';
       ENDIF;
       IF N8#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N8#2';
       ENDIF;
       IF N9#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N9#1';
       ENDIF;
       IF N15#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#1';
       ENDIF;
       IF N15#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#2';
       ENDIF;
       IF N15#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#3';
       ENDIF;
       IF N15#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#4';
       ENDIF;
       IF N15#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#5';
       ENDIF;
       IF N15#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#6';
       ENDIF;
       IF N15#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#7';
       ENDIF;
       IF N15#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N15#8';
       ENDIF;
       IF N18#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#1';
       ENDIF;
       IF N18#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#2';
       ENDIF;
       IF N18#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#3';
       ENDIF;
       IF N18#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#4';
       ENDIF;
       IF N18#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#5';
       ENDIF;
       IF N18#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#6';
       ENDIF;
       IF N18#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#7';
       ENDIF;
       IF N18#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,N18#8';
       ENDIF;
       IF NP2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#1';
       ENDIF;
       IF NP2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#2';
       ENDIF;
       IF NP2#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#3';
       ENDIF;
       IF NP2#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#4';
       ENDIF;
       IF NP2#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#5';
       ENDIF;
       IF NP2#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP2#6';
       ENDIF;
       IF NP3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#1';
       ENDIF;
       IF NP3#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#2';
       ENDIF;
       IF NP3#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#3';
       ENDIF;
       IF NP3#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#4';
       ENDIF;
       IF NP3#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#5';
       ENDIF;
       IF NP3#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP3#6';
       ENDIF;
       IF NP5#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#1';
       ENDIF;
       IF NP5#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#2';
       ENDIF;
       IF NP5#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#3';
       ENDIF;
       IF NP5#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#4';
       ENDIF;
       IF NP5#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#5';
       ENDIF;
       IF NP5#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' ,NP5#6';
       ENDIF;

       SQSTMT  = %TRIM(SQSTMT )+
         ', MSGCTL, APPREF, UPDTIM, UPDDAT, WRTTIM,'+
         'WRTDAT, USERNM, PGMNM, XEORF, SCDTIM, SCDDAT)'+
         ' VALUES(''' + WKSNDREC + ''',''' + WKPRTNUM + ''',''' +
         WKMSGTYP + ''',''' +
         WKMAIKEY + ''',''' + WKHRCLVL + ''', ' + %CHAR(WKLINNUM) ;

       IF A1#1 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A1#1  + '''';
       ENDIF;
       IF A1#2 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A1#2  + '''';
       ENDIF;
       IF A3#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#01 +'''';
       ENDIF;
       IF A3#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#02 + '''';
       ENDIF;
       IF A3#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#03 + '''';
       ENDIF;
       IF A3#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#04 + '''';
       ENDIF;
       IF A3#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#05 + '''';
       ENDIF;
       IF A3#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#06 + '''';
       ENDIF;
       IF A3#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#07 + '''';
       ENDIF;
       IF A3#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#08 + '''';
       ENDIF;
       IF A3#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#09 + '''';
       ENDIF;
       IF A3#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#10 + '''';
       ENDIF;
       IF A3#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#11 + '''';
       ENDIF;
       IF A3#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#12 + '''';
       ENDIF;
       IF A3#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#13 + '''';
       ENDIF;
       IF A3#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#14 + '''';
       ENDIF;
       IF A3#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#15 + '''';
       ENDIF;
       IF A3#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#16 + '''';
       ENDIF;
       IF A3#17<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#17 + '''';
       ENDIF;
       IF A3#18<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#18 + '''';
       ENDIF;
       IF A3#19<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#19 + '''';
       ENDIF;
       IF A3#20<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#20 + '''';
       ENDIF;
       IF A3#21<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#21 + '''';
       ENDIF;
       IF A3#22<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#22 + '''';
       ENDIF;
       IF A3#23<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#23 + '''';
       ENDIF;
       IF A3#24<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#24 + '''';
       ENDIF;
       IF A3#25<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#25 + '''';
       ENDIF;
       IF A3#26<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#26 + '''';
       ENDIF;
       IF A3#27<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#27 + '''';
       ENDIF;
       IF A3#28<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#28 + '''';
       ENDIF;
       IF A3#29<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#29 + '''';
       ENDIF;
       IF A3#30<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#30 + '''';
       ENDIF;
       IF A3#31<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#31 + '''';
       ENDIF;
       IF A3#32<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A3#32 + '''';
       ENDIF;
       IF A4#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A4#1 + '''';
       ENDIF;
       IF A4#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A4#2 + '''';
       ENDIF;
       IF A4#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A4#3 + '''';
       ENDIF;
       IF A6#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A6#1 + '''';
       ENDIF;
       IF A6#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A6#2 + '''';
       ENDIF;
       IF A6#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A6#3 + '''';
       ENDIF;
       IF A7#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A7#1 + '''';
       ENDIF;
       IF A7#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A7#2 + '''';
       ENDIF;
       IF A8#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A8#1 + '''';
       ENDIF;
       IF A9#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A9#1 + '''';
       ENDIF;
       IF A9#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A9#2 + '''';
       ENDIF;
       IF A11#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A11#1 + '''';
       ENDIF;
       IF A11#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A11#2 + '''';
       ENDIF;
       IF A12#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A12#1 + '''';
       ENDIF;
       IF A14#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#1 + '''';
       ENDIF;
       IF A14#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#2 + '''';
       ENDIF;
       IF A14#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#3 + '''';
       ENDIF;
       IF A14#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#4 + '''';
       ENDIF;
       IF A14#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#5 + '''';
       ENDIF;
       IF A14#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A14#6 + '''';
       ENDIF;
       IF A14#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#7 + '''';
       ENDIF;
       IF A14#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#8 + '''';
       ENDIF;
       IF A17#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#1 + '''';
       ENDIF;
       IF A17#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#2 + '''';
       ENDIF;
       IF A17#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#3 + '''';
       ENDIF;
       IF A17#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#4 + '''';
       ENDIF;
       IF A17#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#5 + '''';
       ENDIF;
       IF A17#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#6 + '''';
       ENDIF;
       IF A17#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#7 + '''';
       ENDIF;
       IF A17#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A17#8 + '''';
       ENDIF;
       IF A25#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A25#1 + '''';
       ENDIF;
       IF A25#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A25#2 + '''';
       ENDIF;
       IF A35#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#01 + '''';
       ENDIF;
       IF A35#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#02 + '''';
       ENDIF;
       IF A35#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#03 + '''';
       ENDIF;
       IF A35#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#04 + '''';
       ENDIF;
       IF A35#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#05 + '''';
       ENDIF;
       IF A35#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#06 + '''';
       ENDIF;
       IF A35#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#07 + '''';
       ENDIF;
       IF A35#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#08 + '''';
       ENDIF;
       IF A35#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#09 + '''';
       ENDIF;
       IF A35#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#10 + '''';
       ENDIF;
       IF A35#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#11 + '''';
       ENDIF;
       IF A35#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#12 + '''';
       ENDIF;
       IF A35#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#13 + '''';
       ENDIF;
       IF A35#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A35#14 + '''';
       ENDIF;
       IF A35#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#15 + '''';
       ENDIF;
       IF A35#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#16 + '''';
       ENDIF;
       IF A70#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#01 + '''';
       ENDIF;
       IF A70#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#02 + '''';
       ENDIF;
       IF A70#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#03 + '''';
       ENDIF;
       IF A70#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#04 + '''';
       ENDIF;
       IF A70#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#05 + '''';
       ENDIF;
       IF A70#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#06 + '''';
       ENDIF;
       IF A70#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#07 + '''';
       ENDIF;
       IF A70#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#08 + '''';
       ENDIF;
       IF A70#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#09 + '''';
       ENDIF;
       IF A70#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#10 + '''';
       ENDIF;
       IF A70#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#11 + '''';
       ENDIF;
       IF A70#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#12 + '''';
       ENDIF;
       IF A70#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#13 + '''';
       ENDIF;
       IF A70#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#14 + '''';
       ENDIF;
       IF A70#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#15 + '''';
       ENDIF;
       IF A70#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ''' + A70#16 + '''';
       ENDIF;
       IF N1#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N1#1);
       ENDIF;
       IF N1#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N1#2);
       ENDIF;
       IF N1#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N1#3);
       ENDIF;
       IF N2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N2#1);
       ENDIF;
       IF N2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N2#2);
       ENDIF;
       IF N3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N3#1);
       ENDIF;
       IF N4#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N4#1);
       ENDIF;
       IF N6#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N6#1);
       ENDIF;
       IF N6#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N6#2);
       ENDIF;
       IF N6#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N6#3);
       ENDIF;
       IF N6#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N6#4);
       ENDIF;
       IF N8#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N8#1);
       ENDIF;
       IF N8#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N8#2);
       ENDIF;
       IF N9#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N9#1);
       ENDIF;
       IF N15#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#1);
       ENDIF;
       IF N15#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#2);
       ENDIF;
       IF N15#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#3);
       ENDIF;
       IF N15#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#4);
       ENDIF;
       IF N15#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#5);
       ENDIF;
       IF N15#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#6);
       ENDIF;
       IF N15#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#7);
       ENDIF;
       IF N15#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N15#8);
       ENDIF;
       IF N18#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#1);
       ENDIF;
       IF N18#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#2);
       ENDIF;
       IF N18#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#3);
       ENDIF;
       IF N18#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#4);
       ENDIF;
       IF N18#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#5);
       ENDIF;
       IF N18#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#6);
       ENDIF;
       IF N18#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#7);
       ENDIF;
       IF N18#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(N18#8);
       ENDIF;
       IF NP2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#1);
       ENDIF;
       IF NP2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#2);
       ENDIF;
       IF NP2#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#3);
       ENDIF;
       IF NP2#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#4);
       ENDIF;
       IF NP2#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#5);
       ENDIF;
       IF NP2#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP2#6);
       ENDIF;
       IF NP3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#1);
       ENDIF;
       IF NP3#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#2);
       ENDIF;
       IF NP3#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#3);
       ENDIF;
       IF NP3#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#4);
       ENDIF;
       IF NP3#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#5);
       ENDIF;
       IF NP3#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP3#6);
       ENDIF;
       IF NP5#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#1);
       ENDIF;
       IF NP5#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#2);
       ENDIF;
       IF NP5#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#3);
       ENDIF;
       IF NP5#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#4);
       ENDIF;
       IF NP5#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#5);
       ENDIF;
       IF NP5#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT )+ ' , ' + %CHAR(NP5#6);
       ENDIF;

         SQSTMT  = %TRIM(SQSTMT )+  ' ,''' +
         WKMSGCTL + ''',''' + WKAPPREF + ''',''' +
         WKUPDTIM + ''',''' + WKUPDDAT + ''',''' +
         WKWRTTIM + ''',''' + WKWRTDAT + ''',''' +
         WKUSERNM + ''',''' + WKPGMNM  + ''',''' + WKXEORF  + ''',''' +
         WKSCDTIM + ''',''' + WKSCDDAT + ''')';
      /End-Free
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQICRG   FROM :SQSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCODE       IFEQ      *ZERO
     C/EXEC SQL
     C+ EXECUTE SQICRG
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI ICRG                                                 ***
     C**************************************************************************
     C     UICRG         BEGSR
     C*
     C*-------------------------------------------------------------------------
      /Free
        SQSTMT =
        'UPDATE ' + %TRIM(WKTRPALIBL) + '/'+ %TRIM(WKTRPAFILE) +
        ' SET MAIKEY = ''' + WKMAIKEY + '''';

       IF A1#1 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A1#1  = ''' + A1#1  + '''';
       ENDIF;
       IF A1#2 <> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A1#2  = ''' + A1#2  + '''';
       ENDIF;
       IF A3#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#01 = ''' + A3#01 + '''';
       ENDIF;
       IF A3#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#02 = ''' + A3#02 + '''';
       ENDIF;
       IF A3#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#03 = ''' + A3#03 + '''';
       ENDIF;
       IF A3#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#04 = ''' + A3#04 + '''';
       ENDIF;
       IF A3#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#05 = ''' + A3#05 + '''';
       ENDIF;
       IF A3#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#06 = ''' + A3#06 + '''';
       ENDIF;
       IF A3#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#07 = ''' + A3#07 + '''';
       ENDIF;
       IF A3#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#08 = ''' + A3#08 + '''';
       ENDIF;
       IF A3#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#09 = ''' + A3#09 + '''';
       ENDIF;
       IF A3#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#10 = ''' + A3#10 + '''';
       ENDIF;
       IF A3#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#11 = ''' + A3#11 + '''';
       ENDIF;
       IF A3#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#12 = ''' + A3#12 + '''';
       ENDIF;
       IF A3#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#13 = ''' + A3#13 + '''';
       ENDIF;
       IF A3#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#14 = ''' + A3#14 + '''';
       ENDIF;
       IF A3#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#15 = ''' + A3#15 + '''';
       ENDIF;
       IF A3#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#16 = ''' + A3#16 + '''';
       ENDIF;
       IF A3#17<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#17 = ''' + A3#17 + '''';
       ENDIF;
       IF A3#18<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#18 = ''' + A3#18 + '''';
       ENDIF;
       IF A3#19<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#19 = ''' + A3#19 + '''';
       ENDIF;
       IF A3#20<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#20 = ''' + A3#20 + '''';
       ENDIF;
       IF A3#21<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#21 = ''' + A3#21 + '''';
       ENDIF;
       IF A3#22<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#22 = ''' + A3#22 + '''';
       ENDIF;
       IF A3#23<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#23 = ''' + A3#23 + '''';
       ENDIF;
       IF A3#24<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#24 = ''' + A3#24 + '''';
       ENDIF;
       IF A3#25<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#25 = ''' + A3#25 + '''';
       ENDIF;
       IF A3#26<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#26 = ''' + A3#26 + '''';
       ENDIF;
       IF A3#27<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#27 = ''' + A3#27 + '''';
       ENDIF;
       IF A3#28<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#28 = ''' + A3#28 + '''';
       ENDIF;
       IF A3#29<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#29 = ''' + A3#29 + '''';
       ENDIF;
       IF A3#30<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#30 = ''' + A3#30 + '''';
       ENDIF;
       IF A3#31<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#31 = ''' + A3#31 + '''';
       ENDIF;
       IF A3#32<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A3#32 = ''' + A3#32 + '''';
       ENDIF;
       IF A4#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A4#1 = ''' + A4#1  + '''';
       ENDIF;
       IF A4#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A4#2 = ''' + A4#2  + '''';
       ENDIF;
       IF A4#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A4#3 = ''' + A4#3  + '''';
       ENDIF;
       IF A6#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A6#1 = ''' + A6#1  + '''';
       ENDIF;
       IF A6#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A6#2 = ''' + A6#2  + '''';
       ENDIF;
       IF A6#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A6#3 = ''' + A6#3  + '''';
       ENDIF;
       IF A7#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A7#1 = ''' + A7#1  + '''';
       ENDIF;
       IF A7#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A7#2 = ''' + A7#2  + '''';
       ENDIF;
       IF A8#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A8#1 = ''' + A8#1  + '''';
       ENDIF;
       IF A9#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A9#1 = ''' + A9#1  + '''';
       ENDIF;
       IF A11#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A11#1= ''' + A11#1 + '''';
       ENDIF;
       IF A11#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A11#2= ''' + A11#2 + '''';
       ENDIF;
       IF A12#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A12#1= ''' + A12#1 + '''';
       ENDIF;
       IF A14#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#1= ''' + A14#1 + '''';
       ENDIF;
       IF A14#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#2= ''' + A14#2 + '''';
       ENDIF;
       IF A14#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#3= ''' + A14#3 + '''';
       ENDIF;
       IF A14#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#4= ''' + A14#4 + '''';
       ENDIF;
       IF A14#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#5= ''' + A14#5 + '''';
       ENDIF;
       IF A14#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#6= ''' + A14#6 + '''';
       ENDIF;
       IF A14#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#7= ''' + A14#7 + '''';
       ENDIF;
       IF A14#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A14#8= ''' + A14#8 + '''';
       ENDIF;
       IF A17#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#1= ''' + A17#1 + '''';
       ENDIF;
       IF A17#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#2= ''' + A17#2 + '''';
       ENDIF;
       IF A17#3<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#3= ''' + A17#3 + '''';
       ENDIF;
       IF A17#4<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#4= ''' + A17#4 + '''';
       ENDIF;
       IF A17#5<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#5= ''' + A17#5 + '''';
       ENDIF;
       IF A17#6<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#6= ''' + A17#6 + '''';
       ENDIF;
       IF A17#7<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#7= ''' + A17#7 + '''';
       ENDIF;
       IF A17#8<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A17#8= ''' + A17#8 + '''';
       ENDIF;
       IF A25#1<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A25#1= ''' + A25#1 + '''';
       ENDIF;
       IF A25#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A25#2= ''' + A25#2 + '''';
       ENDIF;
       IF A35#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#01= ''' + A35#01 + '''';
       ENDIF;
       IF A35#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#02= ''' + A35#02 + '''';
       ENDIF;
       IF A35#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#03= ''' + A35#03 + '''';
       ENDIF;
       IF A35#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#04= ''' + A35#04 + '''';
       ENDIF;
       IF A35#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#05= ''' + A35#05 + '''';
       ENDIF;
       IF A35#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#06= ''' + A35#06 + '''';
       ENDIF;
       IF A35#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#07= ''' + A35#07 + '''';
       ENDIF;
       IF A35#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#08= ''' + A35#08 + '''';
       ENDIF;
       IF A35#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#09= ''' + A35#09 + '''';
       ENDIF;
       IF A35#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#10= ''' + A35#10 + '''';
       ENDIF;
       IF A35#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#11= ''' + A35#11 + '''';
       ENDIF;
       IF A35#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#12= ''' + A35#12 + '''';
       ENDIF;
       IF A35#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#13= ''' + A35#13 + '''';
       ENDIF;
       IF A35#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#14= ''' + A35#14 + '''';
       ENDIF;
       IF A35#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#15= ''' + A35#15 + '''';
       ENDIF;
       IF A35#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A35#16= ''' + A35#16 + '''';
       ENDIF;
       IF A70#01<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#01= ''' + A70#01 + '''';
       ENDIF;
       IF A70#02<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#02= ''' + A70#02 + '''';
       ENDIF;
       IF A70#03<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#03= ''' + A70#03 + '''';
       ENDIF;
       IF A70#04<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#04= ''' + A70#04 + '''';
       ENDIF;
       IF A70#05<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#05= ''' + A70#05 + '''';
       ENDIF;
       IF A70#06<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#06= ''' + A70#06 + '''';
       ENDIF;
       IF A70#07<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#07= ''' + A70#07 + '''';
       ENDIF;
       IF A70#08<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#08= ''' + A70#08 + '''';
       ENDIF;
       IF A70#09<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#09= ''' + A70#09 + '''';
       ENDIF;
       IF A70#10<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#10= ''' + A70#10 + '''';
       ENDIF;
       IF A70#11<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#11= ''' + A70#11 + '''';
       ENDIF;
       IF A70#12<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#12= ''' + A70#12 + '''';
       ENDIF;
       IF A70#13<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#13= ''' + A70#13 + '''';
       ENDIF;
       IF A70#14<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#14= ''' + A70#14 + '''';
       ENDIF;
       IF A70#15<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#15= ''' + A70#15 + '''';
       ENDIF;
       IF A70#16<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A70#16= ''' + A70#16 + '''';
       ENDIF;
       IF N1#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N1#1   = '   + %CHAR(N1#1);
       ENDIF;
       IF N1#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N1#2   = '   + %CHAR(N1#2);
       ENDIF;
       IF N1#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N1#3   = '   + %CHAR(N1#3);
       ENDIF;
       IF N2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N2#1   = '   + %CHAR(N2#1);
       ENDIF;
       IF N2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N2#2   = '   + %CHAR(N2#2);
       ENDIF;
       IF N3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N3#1   = '   + %CHAR(N3#1);
       ENDIF;
       IF N4#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N4#1   = '   + %CHAR(N4#1);
       ENDIF;
       IF N6#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N6#1   = '   + %CHAR(N6#1);
       ENDIF;
       IF N6#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N6#2   = '   + %CHAR(N6#2);
       ENDIF;
       IF N6#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N6#3   = '   + %CHAR(N6#3);
       ENDIF;
       IF N6#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N6#4   = '   + %CHAR(N6#4);
       ENDIF;
       IF N8#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N8#1   = '   + %CHAR(N8#1);
       ENDIF;
       IF N8#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N8#2   = '   + %CHAR(N8#2);
       ENDIF;
       IF N9#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N9#1   = '   + %CHAR(N9#1);
       ENDIF;
       IF N15#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#1  = '   + %CHAR(N15#1);
       ENDIF;
       IF N15#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#2  = '   + %CHAR(N15#2);
       ENDIF;
       IF N15#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#3  = '   + %CHAR(N15#3);
       ENDIF;
       IF N15#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#4  = '   + %CHAR(N15#4);
       ENDIF;
       IF N15#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#5  = '   + %CHAR(N15#5);
       ENDIF;
       IF N15#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#6  = '   + %CHAR(N15#6);
       ENDIF;
       IF N15#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#7  = '   + %CHAR(N15#7);
       ENDIF;
       IF N15#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N15#8  = '   + %CHAR(N15#8);
       ENDIF;
       IF N18#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#1  = '   + %CHAR(N18#1);
       ENDIF;
       IF N18#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#2  = '   + %CHAR(N18#2);
       ENDIF;
       IF N18#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#3  = '   + %CHAR(N18#3);
       ENDIF;
       IF N18#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#4  = '   + %CHAR(N18#4);
       ENDIF;
       IF N18#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#5  = '   + %CHAR(N18#5);
       ENDIF;
       IF N18#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#6  = '   + %CHAR(N18#6);
       ENDIF;
       IF N18#7<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#7  = '   + %CHAR(N18#7);
       ENDIF;
       IF N18#8<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', N18#8  = '   + %CHAR(N18#8);
       ENDIF;
       IF NP2#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#1  = '   + %CHAR(NP2#1);
       ENDIF;
       IF NP2#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#2  = '   + %CHAR(NP2#2);
       ENDIF;
       IF NP2#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#3  = '   + %CHAR(NP2#3);
       ENDIF;
       IF NP2#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#4  = '   + %CHAR(NP2#4);
       ENDIF;
       IF NP2#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#5  = '   + %CHAR(NP2#5);
       ENDIF;
       IF NP2#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP2#6  = '   + %CHAR(NP2#6);
       ENDIF;
       IF NP3#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#1  = '   + %CHAR(NP3#1);
       ENDIF;
       IF NP3#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#2  = '   + %CHAR(NP3#2);
       ENDIF;
       IF NP3#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#3  = '   + %CHAR(NP3#3);
       ENDIF;
       IF NP3#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#4  = '   + %CHAR(NP3#4);
       ENDIF;
       IF NP3#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#5  = '   + %CHAR(NP3#5);
       ENDIF;
       IF NP3#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP3#6  = '   + %CHAR(NP3#6);
       ENDIF;
       IF NP5#1<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#1  = '   + %CHAR(NP5#1);
       ENDIF;
       IF NP5#2<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#2  = '   + %CHAR(NP5#2);
       ENDIF;
       IF NP5#3<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#3  = '   + %CHAR(NP5#3);
       ENDIF;
       IF NP5#4<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#4  = '   + %CHAR(NP5#4);
       ENDIF;
       IF NP5#5<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#5  = '   + %CHAR(NP5#5);
       ENDIF;
       IF NP5#6<> *ZERO;
         SQSTMT  = %TRIM(SQSTMT ) + ', NP5#6  = '   + %CHAR(NP5#6);
       ENDIF;

         SQSTMT  = %TRIM(SQSTMT ) +
         ' WHERE SNDREC = ''SND''' +
         ' AND PRTNUM   = ''' + WKPRTNUM + '''' +
         ' AND MSGTYP   = ''DESADV''' +
         ' AND MAIKEY   = ''' + WKMAIKEY + '''' +
         ' AND HRCLVL   = ''' + WKHRCLVL + '''' +
         ' AND LINNUM   = ' + %CHAR(LINNUM);
      /End-Free
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQICRG   FROM :SQSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCODE       IFEQ      *ZERO
     C/EXEC SQL
     C+ EXECUTE SQICRG
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI ICRG                                                 ***
     C**************************************************************************
     C     UXEORF        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      SQSTMT =
     C                             'UPDATE ' + %TRIM(WKTRPALIBL) + '/' +
     C                              %TRIM(WKTRPAFILE) +
     C                             ' SET XEORF = ''X''' +
     C                             ' WHERE SNDREC = ''SND''' +
     C                             ' AND PRTNUM   = ''' + WKPRTNUM + '''' +
     C                             ' AND MSGTYP   = ''DESADV''' +
     C                             ' AND MAIKEY   = ''' + WKMAIKEY + '''' +
     C                             ' AND HRCLVL   = ''100000000'''+
     C                             ' AND LINNUM   = 0 '
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQICRG   FROM :SQSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ EXECUTE SQICRG
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C                   MOVEL(P)  DAFIRM        KYZVDAFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IFICRG'      KYTATA
     C                   MOVEL(P)  'LIBL'        KYTATC
     C                   MOVEL(P)  'LIBL'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALIBL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IFICRG'      KYTATA
     C                   MOVEL(P)  'FILE'        KYTATC
     C                   MOVEL(P)  'FILE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAFILE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL(P)  'MODWAO'      KYTATC                         FIRMA Waeco
     C                   MOVEL(P)  'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODWAO
     C     MODWAO        IFNE      *ON
     C                   MOVEL     *OFF          MODWAO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAFILE      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPALIBL      + 9
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SQSTMT        +1999
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    PRTNUM        WKKDNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LINNUM        WKV1000LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1200LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1500LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1550LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1555LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1570LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1575LINNUM
     C     *LIKE         DEFINE    DUC001        RFFON
     C     *LIKE         DEFINE    DUC001        RFFVN
     C     *LIKE         DEFINE    DUC001        NADSU
     C     *LIKE         DEFINE    DUC001        NADBY
     C     *LIKE         DEFINE    DUC001        NADDP
     C     *LIKE         DEFINE    WKC001        MODWAO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,CHZVDA
     C/COPY QCPYSRC,CHDESA
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
