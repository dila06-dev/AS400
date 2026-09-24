     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2004')
     H**************************************************************************
     H/TITLE  Übergabe der Rechnungen an Crossgate EDIFACT INVOIC
     H**************************************************************************
     H*  Copyright 2008 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Version für CROSSGATE-Converter
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 03.11.2010 WAECO
     H*  Änderung: RE 30.09.2014 DOMETIC PROJEKT 10863
     H*  Änderung: RE 15.05.2014 DOMETIC PROJEKT 11341
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
     D ED73          E DS                  INZ
     D KYED73        E DS                  INZ
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
     C                   EXSR      VED73
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
     C***  VERARBEITEN ED73                                                  ***
     C**************************************************************************
     C     VED73         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   WKICRG
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKMAIKEY
     C                   Z-ADD     *ZERO         WKV1000LINNUM
     C                   Z-ADD     *ZERO         WKV2000LINNUM
     C                   Z-ADD     *ZERO         WKV1100LINNUM
     C                   Z-ADD     *ZERO         WKV1200LINNUM
     C                   Z-ADD     *ZERO         WKV1500LINNUM
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C                   Z-ADD     *ZERO         WKV1300LINNUM
     C                   Z-ADD     *ZERO         WKANZA
     C                   MOVEL     *BLANK        WK15A35#12
     C                   MOVEL     *BLANK        WK15A35#13
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYED73KYNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHED73
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     ED73SAAR      IFEQ      'BGM'
     C     WKMAIKEY      IFNE      *BLANK
     C                   CLEAR                   ICRG
     C                   Z-ADD     WKANZA        N18#1
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   EXSR      UXEORF
     C                   ENDIF
     C                   EXSR      EMAIKEY
     C                   Z-ADD     *ZERO         WKANZA
     C                   MOVEL     *BLANK        WK15A35#12
     C                   MOVEL     *BLANK        WK15A35#13
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      VRED73
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHED73
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKMAIKEY      IFNE      *BLANK
     C                   CLEAR                   ICRG
     C                   Z-ADD     WKANZA        N18#1
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   EXSR      UXEORF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN ED73                                                  ***
     C**************************************************************************
     C     VRED73        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     ED73SAAR      CASEQ     'AJT'         VAJT
     C     ED73SAAR      CASEQ     'ALC'         VALC
     C     ED73SAAR      CASEQ     'ALI'         VALI
     C     ED73SAAR      CASEQ     'APR'         VAPR
     C     ED73SAAR      CASEQ     'BGM'         VBGM
     C     ED73SAAR      CASEQ     'CNT'         VCNT
     C     ED73SAAR      CASEQ     'COM'         VCOM
     C     ED73SAAR      CASEQ     'CTA'         VCTA
     C     ED73SAAR      CASEQ     'CUX'         VCUX
     C     ED73SAAR      CASEQ     'DOC'         VDOC
     C     ED73SAAR      CASEQ     'DTM'         VDTM
     C     ED73SAAR      CASEQ     'EQD'         VEQD
     C     ED73SAAR      CASEQ     'FII'         VFII
     C     ED73SAAR      CASEQ     'FTX'         VFTX
     C     ED73SAAR      CASEQ     'GIN'         VGIN
     C     ED73SAAR      CASEQ     'GIR'         VGIR
     C     ED73SAAR      CASEQ     'IMD'         VIMD
     C     ED73SAAR      CASEQ     'INP'         VINP
     C     ED73SAAR      CASEQ     'LIN'         VLIN
     C     ED73SAAR      CASEQ     'LOC'         VLOC
     C     ED73SAAR      CASEQ     'MEA'         VMEA
     C     ED73SAAR      CASEQ     'MOA'         VMOA
     C     ED73SAAR      CASEQ     'NAD'         VNAD
     C     ED73SAAR      CASEQ     'PAC'         VPAC
     C     ED73SAAR      CASEQ     'PAI'         VPAI
     C     ED73SAAR      CASEQ     'PAT'         VPAT
     C     ED73SAAR      CASEQ     'PCD'         VPCD
     C     ED73SAAR      CASEQ     'PCI'         VPCI
     C     ED73SAAR      CASEQ     'PIA'         VPIA
     C     ED73SAAR      CASEQ     'PRI'         VPRI
     C     ED73SAAR      CASEQ     'QTY'         VQTY
     C     ED73SAAR      CASEQ     'QVR'         VQVR
     C     ED73SAAR      CASEQ     'RCS'         VRCS
     C     ED73SAAR      CASEQ     'RFF'         VRFF
     C     ED73SAAR      CASEQ     'RNG'         VRNG
     C     ED73SAAR      CASEQ     'RTE'         VRTE
     C     ED73SAAR      CASEQ     'TAX'         VTAX
     C     ED73SAAR      CASEQ     'TDT'         VTDT
     C     ED73SAAR      CASEQ     'TOD'         VTOD
     C     ED73SAAR      CASEQ     'UNB'         VUNB
     C     ED73SAAR      CASEQ     'UNH'         VUNH
     C     ED73SAAR      CASEQ     'UNS'         VUNS
     C     ED73SAAR      CASEQ     'UNT'         VUNT
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAJT                                                              ***
     C**************************************************************************
     C     VAJT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      AJT
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VALC                                                              ***
     C**************************************************************************
     C     VALC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      ALC
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     WKLINALC      WHENEQ    *ON
     C                   MOVEL     ALC5463       A3#01
     C                   MOVEL     ALC1230       A35#01
     C                   MOVEL     *ZERO         DUC003
     C                   EVAL      DUN030 = %INT(ALC1227)
     C                   Z-ADD     DUN030        N8#1
     C                   MOVEL     ALC7161       A3#02
     C                   MOVEL     ALC7160#1     A35#02
     C*
     C                   MOVEL     '155000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1550LINNUM
     C     WKLINALC      WHENEQ    *OFF
     C                   MOVEL     ALC5463       A3#01
     C                   MOVEL     ALC1230       A35#01
     C                   MOVEL     *ZERO         DUC003
     C                   EVAL      DUN030 = %INT(ALC1227)
     C                   Z-ADD     DUN030        N8#1
     C                   MOVEL     ALC7161       A3#02
     C                   MOVEL     ALC7160#1     A35#02
     C*
     C                   MOVEL     '130000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1300LINNUM
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VALI                                                              ***
     C**************************************************************************
     C     VALI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      ALI
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAPR                                                              ***
     C**************************************************************************
     C     VAPR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      APR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VBGM                                                              ***
     C**************************************************************************
     C     VBGM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      BGM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*                  MOVEL     '1'           A1#1
     C*
     C                   MOVEL     UNB0004       A35#01
     C                   MOVEL     UNB0010       A35#02
     C*
     C                   MOVEL     BGM1001       A3#01
     C                   MOVEL     BGM1004       MAIKEY
     C                   MOVEL     BGM1004       WKMAIKEY
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1000LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1100LINNUM
     C                   Z-ADD     *ZERO         WKV1200LINNUM
     C                   Z-ADD     *ZERO         WKV1500LINNUM
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C                   Z-ADD     *ZERO         WKV1300LINNUM
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
     C***  VCOM                                                              ***
     C**************************************************************************
     C     VCOM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      COM
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
     C                   MOVEL(P)  ED73SATZ      CTA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VCUX                                                              ***
     C**************************************************************************
     C     VCUX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      CUX
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     CUX6345#1     a3#02
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VDTM                                                              ***
     C**************************************************************************
     C     VDTM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      DTM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     DTM2005       WHENEQ    '171'
     C     WKRFFON       ANDEQ     *ON
     C                   MOVEL     DTM2380       A35#06
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     WKV1500LINNUM IFNE      *ZERO
     C                   CLEAR                   ICRG
     C                   MOVEL     DTM2380       A35#10
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C     DTM2005       WHENEQ    '171'
     C     WKRFFVN       ANDEQ     *ON
     C*
     C     WKV1500LINNUM IFNE      *ZERO
     C                   CLEAR                   ICRG
     C                   MOVEL     DTM2380       A35#15
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C     DTM2005       WHENEQ    '171'
     C     WKRFFDQ       ANDEQ     *ON
     C                   MOVEL     DTM2380       A35#13
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C                   MOVEL     DTM2380       WK15A35#13
     C*
     C     DTM2005       WHENEQ    '35 '
     C                   MOVEL     DTM2380       A35#03
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     DTM2005       WHENEQ    '137'
     C                   MOVEL     DTM2380       A35#04
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
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     DTM2005       WHENEQ    '209'
     C                   MOVEL     DTM2380       A14#5
     C                   MOVEL     DTM2380       A35#15
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C*
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     DTM2005       WHENEQ    '140'
     C                   MOVEL     DTM2380       A35#12
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C*
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
     C***  VDOC                                                              ***
     C**************************************************************************
     C     VDOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      DOC
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
     C                   MOVEL(P)  ED73SATZ      EQD
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VFII                                                              ***
     C**************************************************************************
     C     VFII          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VFTX                                                              ***
     C**************************************************************************
     C     VFTX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      FTX
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     FTX4451       A3#01
     C                   MOVEL     FTX4453       A3#02
     C                   MOVEL     FTX4440#1     A70#01
     C                   MOVEL     FTX4440#2     A70#02
     C                   MOVEL     FTX4440#3     A70#03
     C                   MOVEL     FTX4440#4     A70#04
     C                   MOVEL     FTX4440#5     A70#05
     C*
     C                   MOVEL     '110000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1100LINNUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VGIN                                                              ***
     C**************************************************************************
     C     VGIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      GIN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VGIR                                                              ***
     C**************************************************************************
     C     VGIR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      GIR
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
     C                   MOVEL(P)  ED73SATZ      IMD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     IMD7077       WHENEQ    'A  '
     C                   MOVEL     IMD7008#1     A35#06
     C                   MOVEL     IMD7008#2     A35#07
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     IMD7077       WHENEQ    'C  '
     C     IMD7009       ANDEQ     'CU '
     C                   MOVEL     IMD7009       A3#08
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     IMD7077       WHENEQ    'C  '
     C     IMD7009       ANDEQ     'IN '
     C                   MOVEL     IMD7009       A3#07
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VINP                                                              ***
     C**************************************************************************
     C     VINP          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VLIN                                                              ***
     C**************************************************************************
     C     VLIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      LIN
     C                   ADD       1             WKANZA
     C                   MOVEL     *ON           WKLINRFFON
     C                   MOVEL     *ON           WKLINALC
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C                   Z-ADD     LIN1082#1     N6#1
     C                   IF        WKKDNR ='TECCOM_RECHNUNG'
     C                             OR WKKDNR ='TECCOM_RECHNUNG_EDI'
     C                   Z-ADD     WKANZA        N6#1
     C                   Z-ADD     LIN1082#1     N6#2
     C                   ENDIF
     C*
     C                   MOVEL     LIN7140       A35#01
     C                   MOVEL     WK15A35#12    A35#12
     C                   MOVEL     WK15A35#13    A35#13
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C*
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VLOC                                                              ***
     C**************************************************************************
     C     VLOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      LOC
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VMEA                                                              ***
     C**************************************************************************
     C     VMEA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      MEA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VMOA                                                              ***
     C**************************************************************************
     C     VMOA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      MOA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     MOA5025       WHENEQ    '203'
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#2
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     MOA5025       WHENEQ    '66 '
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#1
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     MOA5025       WHENEQ    '86 '
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#1
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   MOVEL     *OFF          WKLINALC
     C     MOA5025       WHENEQ    '79 '
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#2
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   MOVEL     *OFF          WKLINALC
     C     MOA5025       WHENEQ    '176'
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#3
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   MOVEL     *OFF          WKLINALC
     C     MOA5025       WHENEQ    '131'
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP3#4
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   MOVEL     *OFF          WKLINALC
     C     MOA5025       WHENEQ    '125'
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#4
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C                   MOVEL     *OFF          WKLINALC
     C     MOA5025       WHENEQ    '8  '
     C     WKLINALC      ANDEQ     *ON
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#2
     C                   MOVEL     '155000000'   WKHRCLVL
     C                   Z-ADD     WKV1550LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1550LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     MOA5025       WHENEQ    '8  '
     C     WKLINALC      ANDEQ     *OFF
     C                   Z-ADD     MOA5004       DUN180
     C                   Z-ADD     DUN182        NP2#2
     C                   MOVEL     '130000000'   WKHRCLVL
     C                   Z-ADD     WKV1300LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1300LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VNAD                                                              ***
     C**************************************************************************
     C     VNAD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      NAD
     C                   MOVEL(P)  *OFF          WKNADSU
     C                   MOVEL(P)  *OFF          WKNADBY
     C                   MOVEL(P)  *OFF          WKNADDP
     C                   MOVEL(P)  *OFF          WKNADIV
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     NAD3035       WHENEQ    'SU'
     C                   MOVEL(P)  *ON           WKNADSU
     C                   MOVEL     NAD3039       A17#1
     C*
     C                   MOVEL(P)  NAD3036#1     A70#01
     C                   MOVEL(P)  NAD3042#1     A70#02
     C                   MOVEL(P)  NAD3164       A70#03
     C                   MOVEL(P)  NAD3251       A9#2
     C                   MOVEL(P)  NAD3207       A3#30
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     NAD3035       WHENEQ    'BY '
     C                   MOVEL(P)  *ON           WKNADBY
     C                   MOVEL     NAD3039       A17#2
     C*
     C                   MOVEL(P)  NAD3036#1     A35#14
     C                   MOVEL(P)  NAD3042#1     A35#15
     C                   MOVEL(P)  NAD3164       A35#16
     C                   MOVEL(P)  NAD3251       A9#1
     C                   MOVEL(P)  NAD3207       A3#31
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C                   CLEAR                   ICRG
     C                   MOVEL     NAD3039       A17#2
     C*
     C                   MOVEL(P)  NAD3036#1     A35#05
     C                   MOVEL(P)  NAD3042#1     A35#07
     C                   MOVEL(P)  NAD3164       A35#08
     C                   MOVEL(P)  NAD3251       A9#2
     C                   MOVEL(P)  NAD3207       A3#32
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C*
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     NAD3035       WHENEQ    'DP '
     C                   MOVEL(P)  *ON           WKNADDP
     C                   MOVEL     NAD3039       A17#3
     C*
     C                   MOVEL(P)  NAD3036#1     A35#10
     C                   MOVEL(P)  NAD3036#1     A35#14
     C                   MOVEL(P)  NAD3042#1     A35#15
     C                   MOVEL(P)  NAD3164       A35#16
     C                   MOVEL(P)  NAD3251       A9#1
     C                   MOVEL(P)  NAD3207       A3#31
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     NAD3035       WHENEQ    'IV '
     C                   MOVEL(P)  *ON           WKNADIV
     C                   MOVEL     NAD3039       A17#4
     C*
     C                   MOVEL(P)  NAD3036#1     A70#04
     C                   MOVEL(P)  NAD3042#1     A70#05
     C                   MOVEL(P)  NAD3164       A70#06
     C                   MOVEL(P)  NAD3251       A11#1
     C                   MOVEL(P)  NAD3207       A3#29
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
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
     C                   MOVEL(P)  ED73SATZ      PAC
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPAI                                                              ***
     C**************************************************************************
     C     VPAI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PAI
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPAT                                                              ***
     C**************************************************************************
     C     VPAT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PAT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     '120000000'   WKHRCLVL
     C                   Z-ADD     WKV1200LINNUM LINNUM
     C*
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1200LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPCD                                                              ***
     C**************************************************************************
     C     VPCD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PCD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     PCD5245       A3#05
     C                   Z-ADD     PCD5482       DUN100
     C                   Z-ADD     DUN102        NP2#1
     C                   MOVEL     '155000000'   WKHRCLVL
     C                   Z-ADD     WKV1550LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1550LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPCI                                                              ***
     C**************************************************************************
     C     VPCI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PCI
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPIA                                                              ***
     C**************************************************************************
     C     VPIA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PIA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     PIA7143#1     WHENEQ    'EN'
     C                   MOVEL     PIA7140#1     A35#01
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     PIA7143#1     WHENEQ    'SA'
     C                   MOVEL     PIA7140#1     A35#02
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C     PIA7143#1     WHENEQ    'BP'
     C                   MOVEL     PIA7140#1     A35#03
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VPRI                                                              ***
     C**************************************************************************
     C     VPRI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      PRI
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     PRI5125       WHENEQ    'AAA'
     C                   Z-ADD     PRI5118       DUN180
     C                   Z-ADD     DUN183        NP5#3
     C                   Z-ADD     PRI5284       N9#1
     C                   MOVEL     PRI6411       A3#03
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C                   Z-ADD     *ZERO         WKV1550LINNUM
     C     PRI5125       WHENEQ    'AAF'
     C                   Z-ADD     PRI5118       DUN180
     C                   Z-ADD     DUN183        NP5#2
     C                   Z-ADD     PRI5284       N9#1
     C                   MOVEL     PRI6411       A3#03
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
     C*
     C                   Z-ADD     *ZERO         WKV1550LINNUM
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
     C                   MOVEL(P)  ED73SATZ      QTY
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   SELECT
     C     QTY6063       WHENEQ    '47'
     C                   Z-ADD     QTY6060       NP5#1
     C                   MOVEL     QTY6411       A3#01
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C     LINNUM        IFEQ      *ZERO
     C                   EXSR      IICRG
     C                   Z-ADD     WKLINNUM      WKV1500LINNUM
     C                   ELSE
     C                   EXSR      UICRG
     C                   ENDIF
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
     C                   MOVEL(P)  ED73SATZ      QVR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VRCS                                                              ***
     C**************************************************************************
     C     VRCS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      RCS
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
     C                   MOVEL(P)  ED73SATZ      RFF
     C                   MOVEL(P)  *OFF          WKRFFDQ
     C                   MOVEL(P)  *OFF          WKRFFON
     C                   MOVEL(P)  *OFF          WKRFFVN
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
     C                   MOVEL     *ON           WKRFFVN
     C                   MOVEL     RFF1154       A35#14
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     WKV1500LINNUM IFNE      *ZERO
     C                   MOVEL(P)  *ON           WKRFFVN
     C                   CLEAR                   ICRG
     C                   MOVEL     RFF1154       A35#14
     C                   MOVEL     RFF1156       A6#2
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C     RFF1153       WHENEQ    'API'
     C     WKNADSU       ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#10
     C                   IF        WKKDNR <>'METRO_RECHNUNG'
     C                   MOVEL     RFF1154       A17#1
     C                   ENDIF
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'FC '
     C     WKNADSU       ANDEQ     *ON
     C                   MOVEL     RFF1154       A70#16
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'API'
     C     WKNADBY       ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#11
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'API'
     C     WKNADDP       ANDEQ     *ON
     C                   MOVEL     RFF1154       A35#09
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'FC '
     C     WKNADIV       ANDEQ     *ON
     C*RE                MOVEL     RFF1154       A70#16
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'VA '
     C     WKNADSU       ANDEQ     *ON
     C                   MOVEL     RFF1154       A17#7
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C     RFF1153       WHENEQ    'ON '
     C                   MOVEL     *ON           WKRFFON
     C                   MOVEL     RFF1154       A35#05
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C     WKV1500LINNUM IFNE      *ZERO
     C     WKLINRFFON    ANDEQ     *ON
     C                   CLEAR                   ICRG
     C                   MOVEL     RFF1154       A35#09
     C                   MOVEL     RFF1156       A6#1
     C*
     C                   MOVEL     '150000000'   WKHRCLVL
     C                   Z-ADD     WKV1500LINNUM LINNUM
     C                   EXSR      UICRG
     C                   ENDIF
     C                   MOVEL     *OFF          WKLINRFFON
     C     RFF1153       WHENEQ    'DQ '
     C                   MOVEL     *ON           WKRFFDQ
     C                   MOVEL     RFF1154       A35#12
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C                   MOVEL     RFF1154       WK15A35#12
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VRNG                                                              ***
     C********G*****************************************************************
     C     VRNG          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      RNG
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VRTE                                                              ***
     C**************************************************************************
     C     VRTE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      RTE
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTAX                                                              ***
     C**************************************************************************
     C     VTAX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      TAX
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     TAX5278       DUC017
     C                   TESTN                   DUC017               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC017                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN172        NP3#1
     C                   MOVEL     TAX5305       A3#04
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*
     C                   MOVEL     TAX5278       DUC017
     C                   TESTN                   DUC017               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC017                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN172        NP3#1
     C*
     C*                  MOVEL     '200000000'   WKHRCLVL
     C*                  Z-ADD     WKV2000LINNUM LINNUM
     C*    LINNUM        IFEQ      *ZERO
     C*                  EXSR      IICRG
     C*                  Z-ADD     WKLINNUM      WKV2000LINNUM
     C*                  ELSE
     C*                  EXSR      UICRG
     C*                  ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTDT                                                              ***
     C**************************************************************************
     C     VTDT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      TDT
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTOD                                                              ***
     C**************************************************************************
     C     VTOD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      TOD
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VUNB                                                              ***
     C**************************************************************************
     C     VUNB          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      UNB
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL(P)  UNB0010       KYKZEB
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHZKUN
     C                   MOVEL(P)  KZKDNR        WKKDNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKDNR        KYZVDAKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZVDA
     C     ZVDAOFRE      IFNE      *BLANK
     C                   MOVEL(P)  ZVDAOFRE      WKKDNR
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
     C*                  MOVEL     '1'           A1#1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VUNH                                                              ***
     C**************************************************************************
     C     VUNH          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      UNH
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
     C                   MOVEL(P)  ED73SATZ      UNS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VUNT                                                              ***
     C**************************************************************************
     C     VUNT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ED73SATZ      UNT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ICRG
     C*
     C                   MOVEL     UNT0074       DUC006
     C                   TESTN                   DUC006               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC006                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN060        N18#1
     C*
     C                   MOVEL     '100000000'   WKHRCLVL
     C                   Z-ADD     WKV1000LINNUM LINNUM
     C                   EXSR      UICRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTEL MAINKEY FÜR ICRG                                         ***
     C**************************************************************************
     C     EMAIKEY       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CALL      'EXTSTP'
     C                   PARM                    WKTSTP
     C                   MOVEL(P)  WKTSTP        WKMAIKEY
     C*
     C                   MOVEL     'SND'         WKSNDREC
     C                   MOVEL     'INVOIC'      WKMSGTYP
     C                   MOVEL     WKKDNR        WKPRTNUM
     C                   Z-ADD     *ZERO         WKLINNUM
     C                   MOVEL     ' '           WKXEORF
     C*--------------------------------------------------------
     C                   MOVEL     'IFICRG12'    WKPGMNM
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
       IF A9#2<> *BLANK;
         SQSTMT  = %TRIM(SQSTMT )+ ', A9#2 = ''' + A9#2  + '''';
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
         ' AND MSGTYP   = ''INVOIC''' +
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
     C                             ' AND MSGTYP   = ''INVOIC''' +
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
     C     *LIKE         DEFINE    WKC001        WKNADSU
     C     *LIKE         DEFINE    WKC001        WKNADBY
     C     *LIKE         DEFINE    WKC001        WKNADDP
     C     *LIKE         DEFINE    WKC001        WKNADIV
     C     *LIKE         DEFINE    WKC001        WKRFFDQ
     C     *LIKE         DEFINE    WKC001        WKRFFON
     C     *LIKE         DEFINE    WKC001        WKRFFVN
     C     *LIKE         DEFINE    WKC001        WKLINRFFON
     C     *LIKE         DEFINE    WKC001        WKLINALC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAFILE      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPALIBL      + 9
     C     *LIKE         DEFINE    WKC001        MODWAO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SQSTMT        +1999
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    PRTNUM        WKKDNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LINNUM        WKV1000LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1100LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1200LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1500LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1550LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV2000LINNUM
     C     *LIKE         DEFINE    LINNUM        WKV1300LINNUM
     C     *LIKE         DEFINE    DUN060        WKANZA
     C     *LIKE         DEFINE    A35#12        WK15A35#12
     C     *LIKE         DEFINE    A35#13        WK15A35#13
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,CHZVDA
     C/COPY QCPYSRC,CHED73
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
