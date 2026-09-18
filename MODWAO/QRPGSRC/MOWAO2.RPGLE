     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei WAO2
     H**************************************************************************
     H*  Copyright 2007 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 06.02.2007 für Kunde WAECO Projekt 4200
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Anlage der Serien-Nr pro Bestell-Position.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BBEP          E DS                  INZ
     D*
     D WAO2          E DS                  INZ
     D KYWAO2        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
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
     D WKSENR          DS                  INZ
     D  WKPRAT                        1
     D  WKBENN                        6  0
     D  WKSTRI                        1
     D  WKNUMM                        6  0
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
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ESICHT'
     C                   EXSR      ESICHT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      LWAO2
     C*--------------------------------------------------------
     C                   OTHER                                                  EXTERNES
     C                   EXSR      IFWAO2                                       UPDATE
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
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
     C                   MOVEL(P)  DAFIRM        KYWAO2FIRM                     WAO2
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
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
     C                   MOVEA     EXTRNDKEYB    KOM
     C*
     C                   MOVEA     KOM(1)        DUC004
     C                   Z-ADD     DUN040        KYWAO2BEJJ
     C                   MOVEA     KOM(5)        KYWAO2BENR
     C                   MOVEA     KOM(11)       DUC004
     C                   Z-ADD     DUN040        KYWAO2BEPO
     C*
     C                   Z-ADD     KYWAO2BEJJ    DSWAO2BEJJ
     C                   MOVEL     KYWAO2BENR    DSWAO2BENR
     C                   Z-ADD     KYWAO2BEPO    DSWAO2BEPO
     C*
     C                   MOVEA     EXTRNDDATE    KOM
     C                   MOVEA     KOM(1)        DUC011
     C                   TESTN                   DUC011               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN112        EPMENG
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
     C                   CLEAR                   WKSENR
     C                   MOVEL     'S'           WKPRAT
     C                   MOVEL     '-'           WKSTRI
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAO2BENR    KOM(1)
     C                   MOVEA     '0'           KOM(22)                        ANZAHLDEZIMAL
     C                   MOVEA     *OFF          KOM(23)                        NEGATIVEINGABE
     C                   MOVEA(P)  KOM           #CKOMM
     C*
     C                   CALL      'UMNUMM'                             98
     C                   PARM                    EXTR02
     C*--------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA(P)  KOM(1)        WKFENR
     C                   MOVEA(P)  KOM(5)        DUC030
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     DUN309        WKBENN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN DATENSATZ FÜR DIE SICHT-STEUERUNG                           ***
     C**************************************************************************
     C     ESICHT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO2
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WAO2          RTTRNDDATE
     C*
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
     C***  PRÜFEN, OB WAO2-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAO2         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYWAO2BEJJ    OFWAO2BEJJ
     C                   MOVEL     KYWAO2BENR    OFWAO2BENR
     C                   Z-ADD     KYWAO2BEPO    OFWAO2BEPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO2
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO2FIRM      ANDEQ     KYWAO2FIRM
     C     WAO2BEJJ      ANDLE     OFWAO2BEJJ
     C     WAO2BENR      ANDLE     OFWAO2BENR
     C     WAO2BEPO      ANDLE     OFWAO2BEPO
     C*--------------------------------------------------------
     C     WAO2LOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAO2LOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO2
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
     C***  LÖSCHEN SÄTZE DATEI WAO2                                          ***
     C**************************************************************************
     C     LWAO2         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYWAO2BEJJ    OFWAO2BEJJ
     C                   MOVEL     KYWAO2BENR    OFWAO2BENR
     C                   Z-ADD     KYWAO2BEPO    OFWAO2BEPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO2
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO2FIRM      ANDEQ     KYWAO2FIRM
     C     WAO2BEJJ      ANDLE     OFWAO2BEJJ
     C     WAO2BENR      ANDLE     OFWAO2BENR
     C     WAO2BEPO      ANDLE     OFWAO2BEPO
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   Z-ADD     WAO2BEJJ      KYWAO2BEJJ
     C                   MOVEL     WAO2BENR      KYWAO2BENR
     C                   Z-ADD     WAO2BEPO      KYWAO2BEPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO2
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAO2
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO2
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
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAO2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAO2BEJJ    KYWAO2BEJJ
     C                   MOVEL     DSWAO2BENR    KYWAO2BENR
     C                   Z-ADD     DSWAO2BEPO    KYWAO2BEPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO2
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        CASEQ     *BLANK        EWAO2SENV                      ERM. SERIEN-NR BEI
     C                   ENDCS                                                  NEUANLAGE
     C*
     C                   MOVEL     WAO2SENV      DSWAO2SENV
     C                   MOVEL     WAO2SENB      DSWAO2SENB
     C*--------------------------------------------------------
     C                   MOVEL     DSWAO2SENV    WKSENR
     C                   ADD       EPMENG        WKNUMM
     C                   SUB       1             WKNUMM
     C*
     C                   MOVEL     WKSENR        DSWAO2SENB                     SERIEN-NR BIS
     C*--------------------------------------------------------
     C                   EXSR      UWAO2
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
     C***  UPDATE DATEI WAO2                                                 ***
     C**************************************************************************
     C     UWAO2         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAO2BEJJ    KYWAO2BEJJ
     C                   MOVEL     DSWAO2BENR    KYWAO2BENR
     C                   Z-ADD     DSWAO2BEPO    KYWAO2BEPO
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO2
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSWAO2SENV    WAO2SENV
     C                   MOVEL     DSWAO2SENB    WAO2SENB
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAJNAM        WAO2JNAM
     C                   MOVEL     WKCHPN        WAO2PROG
     C                   MOVEL     WKCHPL        WAO2BIBL
     C                   MOVEL     DAUSER        WAO2USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO2JZEI
     C                   MOVE      WKTDAT        WAO2JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    WAO2TSTP
     C                   MOVEL(P)  DAUSER        WAO2ERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAO2
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO2
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SERIEN-NR BEI NEUANLAGE                                 ***
     C**************************************************************************
     C     EWAO2SENV     BEGSR
     C*
     C                   Z-ADD     100001        DUN060
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAO2BEJJ    KYWAO2BEJJ
     C                   MOVEL     DSWAO2BENR    KYWAO2BENR
     C                   Z-ADD     *LOVAL        KYWAO2BEPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO2
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAO2FIRM      ANDEQ     KYWAO2FIRM
     C     WAO2BEJJ      ANDEQ     KYWAO2BEJJ
     C     WAO2BENR      ANDEQ     KYWAO2BENR
     C*--------------------------------------------------------
     C                   MOVEL     WAO2SENB      WKSENR                         SERIEN-NR BIS
     C*
     C     WKNUMM        IFGE      DUN060
     C     WKNUMM        ADD       1             DUN060
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO2
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DUN060        WKNUMM
     C*
     C                   MOVEL     WKSENR        WAO2SENV                       SERIEN-NR VON
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
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAO2BEJJ    OFWAO2BEJJ
     C     *LIKE         DEFINE    KYWAO2BENR    OFWAO2BENR
     C     *LIKE         DEFINE    KYWAO2BEPO    OFWAO2BEPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO2BEJJ      DSWAO2BEJJ
     C     *LIKE         DEFINE    WAO2BENR      DSWAO2BENR
     C     *LIKE         DEFINE    WAO2BEPO      DSWAO2BEPO
     C     *LIKE         DEFINE    WAO2SENV      DSWAO2SENV
     C     *LIKE         DEFINE    WAO2SENB      DSWAO2SENB
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C     *LIKE         DEFINE    RTTRNDFENR    WKFENR
     C     *LIKE         DEFINE    RTTRNDPA03    W$PA03
     C     *LIKE         DEFINE    RTTRNDPA04    W$PA04
     C     *LIKE         DEFINE    RTTRNDPA05    W$PA05
     C     *LIKE         DEFINE    RTTRNDPA06    W$PA06
     C     *LIKE         DEFINE    RTTRNDPA07    W$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHWAO2
     C/COPY QCPYSRC,CHTRPA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
