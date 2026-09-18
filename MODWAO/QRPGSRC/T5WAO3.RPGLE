     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2013')
     H**************************************************************************
     H/TITLE Füllen Schnittstelle zum QS-System PDAP7 (Datei WAO3) für die
     H/TITLE Enlagerung von Artikeln aus dem LG-Zugang WE
     H**************************************************************************
     H*  Copyright 2013 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 11.01.2013 Projekt 8790 für Kunde DOMETIC
     H*  -----------------------------------------------------------------------
     H*  Änderung: XX XX.XX.XXXX
     F**************************************************************************
     F*  Das Programm füllt die Datei WAO3 aufgrund der im Programm T4WAO3
     F*  eingegebenen Selektionskriterien (LG-Zugang-Jahr/Nr/Position/Unter-Position)
     F*
     F*  Die Bestückung des Übergabe-KOM-Bereichs kann aus der Routine
     F*  UEBKOM herausgelesen werden.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     F*
     FWAO3      UF A E             DISK
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
     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ
     D*
     D LGWE          E DS                  INZ
     D KYLGWE        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D KYTRPC        E DS                  INZ
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
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   EXSR      VWAO3
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
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
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLGPOFIRM                     LGPO
     C                   MOVEL(P)  DAFIRM        KYLGWEFIRM                     LGWE
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   CLEAR                   WAO31
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXTR02'      EXDATAFILE
     C                   MOVEL(P)  EXTR02        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        WKLGJJ
     C*
     C                   MOVEA(P)  KOM(05)       WKLGNR
     C*
     C                   MOVEA(P)  KOM(11)       DUC005
     C                   TESTN                   DUC005               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC005
     C                   ENDIF
     C                   Z-ADD     DUN050        WKLGPO
     C*
     C                   MOVEA(P)  KOM(16)       DUC005
     C                   TESTN                   DUC005               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC005
     C                   ENDIF
     C                   Z-ADD     DUN050        WKUPOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN WAO3                                                  ***
     C**************************************************************************
     C     VWAO3         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKLGJJ        KYLGWELGJJ
     C                   MOVEL(P)  WKLGNR        KYLGWELGNR
     C                   Z-ADD     WKLGPO        KYLGWELGPO
     C                   Z-ADD     WKUPOS        KYLGWEUPOS
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGWE
     C*
     C                   Z-ADD     WKLGJJ        KYLGPOLGJJ
     C                   MOVEL(P)  WKLGNR        KYLGPOLGNR
     C                   Z-ADD     WKLGPO        KYLGPOLGPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPO
     C*--------------------------------------------------------
     C                   Z-ADD     LGWELGPO      DUN050
     C                   EVAL      WAO3WENR = %CHAR(LGWELGJJ) + LGWELGNR+ DUC005
     C                   Z-ADD     LGWEUPOS      DUN050
     C                   EVAL      WAO3WENR = %TRIMR(WAO3WENR) + DUC005
     C*
     C                   Z-ADD     LGWELGPO      DUN050
     C                   EVAL      WAO3BENR = %CHAR(LGWELGJJ) + LGWELGNR+ DUC005
     C
     C                   MOVEL(P)  LGPOTENR      WAO3EZNR
     C                   MOVEL     *BLANK        WAO3EZIX
     C                   MOVEL     *BLANK        WAO3LFNR
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     LGWEBDAT      EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   EVAL      WAO3WEDA = %TRIM(%EDITW(RTDATEDATE :
     C                              '0  .  .    '))
     C*
     C                   MOVEL     *BLANK        WAO3LINR
     C                   CLEAR                   WAO3LFTE
     C                   CLEAR                   WAO3BETE
     C*
     C                   Z-ADD(H)  LGWEISMG      WAO3WEMG
     C                   Z-ADD(H)  LGPOSOMG      WAO3BSMG
     C*
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  LGWEMEIN      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        WAO3MEIN
     C*
     C                   MOVEL(P)  '0'           WAO3STKZ
     C                   MOVEL     *BLANK        WAO3SAPT
     C                   MOVEL     *BLANK        WAO3TL11
     C                   MOVEL     'G'           WAO3DUMM
     C*-------------------------------------------------------------------------
     C                   WRITE     WAO31                                98
     C*
     C                   CLEAR                   WAO31
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
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LGWELGJJ      WKLGJJ
     C     *LIKE         DEFINE    LGWELGNR      WKLGNR
     C     *LIKE         DEFINE    LGWELGPO      WKLGPO
     C     *LIKE         DEFINE    LGWEUPOS      WKUPOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHLGWE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
