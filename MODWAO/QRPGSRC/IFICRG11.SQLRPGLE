     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2009')
     H**************************************************************************
     H/TITLE  Übernahme der Orders     von Crossgate EDIFACT ORDERS
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Version für CROSSGATE-Converter
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 07.09.2010 BÖRLIND Projekt 6696
     H*  Änderung: RE 30.09.2014 DOMETIC Projekt 10784
     H*
     F**************************************************************************
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D ORDE          E DS                  INZ
     D KYORDE        E DS                  INZ
     D*
     D ICRG          E DS                  INZ
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
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,INHOUSE96A
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D  WKTSTP         S               Z   INZ
     D*
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
     C*-------------------------------------------------------------------------
     C                   EXSR      OICRG
     C                   EXSR      VICRG
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
     C                   Z-ADD     *ZERO         WKN140
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C*-------------------------------------------------------------------------
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
     C***  ÖFFNEN CORSOR ICRG                                                ***
     C**************************************************************************
     C     OICRG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM '+ %TRIM(WKTRPALIBL) + '/' +
     C                              %TRIM(WKTRPAFILE) +
     C                             ' WHERE SNDREC = ''RCV''' +
     C                             ' AND MSGTYP   = ''ORDERS''' +
     C                             ' AND XEORF    = ''V''' +
     C                             ' AND HRCLVL   = ''100000000'''
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY PRTNUM, MAIKEY, LINNUM '
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQICRG   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE ICRGC1 SCROLL CURSOR FOR SQICRG
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN ICRGC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN ICRG                                                  ***
     C**************************************************************************
     C     VICRG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH FROM ICRGC1 INTO :ICRG
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      OICRGC2
     C                   EXSR      VICRGC2
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE ICRGC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN CORSOR ICRG                                                ***
     C**************************************************************************
     C     OICRGC2       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM '+ %TRIM(WKTRPALIBL) + '/' +
     C                              %TRIM(WKTRPAFILE) +
     C                             ' WHERE SNDREC = ''RCV''' +
     C                             ' AND MSGTYP   = ''ORDERS''' +
     C                             ' AND MAIKEY   = ''' + MAIKEY + ''''
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY PRTNUM, MAIKEY, LINNUM '
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQICRGC2 FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE ICRGC2 SCROLL CURSOR FOR SQICRGC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN ICRGC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN ICRG                                                  ***
     C**************************************************************************
     C     VICRGC2       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH FROM ICRGC2 INTO :ICRG
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     HRCLVL        WHENEQ    '100000000'
     C                   EXSR      V10000
     C     HRCLVL        WHENEQ    '110000000'
     C                   EXSR      V11000
     C     HRCLVL        WHENEQ    '120000000'
     C                   EXSR      V12000
     C     HRCLVL        WHENEQ    '150000000'
     C     HRCLVL        OREQ      '111110000'
     C                   EXSR      V15000
     C     HRCLVL        WHENEQ    '154000000'
     C                   EXSR      V15400
     C     HRCLVL        WHENEQ    '155000000'
     C                   EXSR      V15500
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      UICRG
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE ICRGC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   EXSR      VENDE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 100000000                                    ***
     C**************************************************************************
     C     V10000        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYEDKN
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHORDE
     C     CHI(5)        IFEQ      'J'
     C                   MOVE      EDKYNR        WKN140
     C                   ENDIF
     C                   ADD       1             WKN140
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNB
     C                   MOVEL(P)  UNB           W1SATZ
     C                   MOVEL     A4#2          UNB0001
     C                   MOVEL     A1#2          DUC001
     C                   TESTN                   DUC001               97
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUN010
     C                   ENDIF
     C                   Z-ADD     DUN010        UNB0002
     C*
     C                   MOVEL(P)  PRTNUM        UNB0004
     C                   MOVEL(P)  '14'          UNB0007#1
     C                   MOVEL(P)  A35#01        UNB0010
     C                   MOVEL(P)  '14'          UNB0007#2
     C*
     C                   MOVEL     A6#1          DUC006
     C                   TESTN                   DUC006               97
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUN060
     C                   ENDIF
     C                   Z-ADD     DUN060        UNB0017
     C*
     C                   MOVEL     A4#1          DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVEL     *ZERO         DUN040
     C                   ENDIF
     C                   Z-ADD     DUN040        UNB0019
     C*
     C                   MOVEL(P)  MSGCTL        UNB0020
     C*
     C                   MOVEL(P)  'ORDERS'      UNB0026
     C                   MOVEL(P)  'EANCOM'      UNB0026
     C                   MOVEL(P)  A1#1          UNB0035
     C                   MOVEL(P)  'UNB'         WKSAAR
     C                   MOVEL(P)  UNB           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNH
     C                   MOVEL(P)  UNH           W1SATZ
     C                   MOVEL(P)  APPREF        UNH0062
     C                   MOVEL(P)  'SH'          UNH0068
     C                   MOVEL(P)  'ORDERS'      UNH0065
     C                   MOVEL(P)  'D'           UNH0052
     C                   MOVEL(P)  '97A'         UNH0054
     C                   MOVEL(P)  'UN'          UNH0051
     C                   MOVEL(P)  'UNH'         WKSAAR
     C                   MOVEL(P)  UNH           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BGM
     C                   MOVEL(P)  BGM           W1SATZ
     C                   MOVEL(P)  A3#02         BGM1001
     C                   MOVEL(P)  A35#07        BGM1004
     C                   MOVEL(P)  '9'           BGM1225
     C                   MOVEL(P)  'BGM'         WKSAAR
     C                   MOVEL(P)  BGM           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DTM                            01
     C                   MOVEL(P)  DTM           W1SATZ
     C                   MOVEL(P)  A35#02        DTM2380
     C     DTM           IFNE      W1SATZ
     C                   MOVEL(P)  '137'         DTM2005
     C                   MOVEL(P)  '102'         DTM2379
     C                   MOVEL(P)  'DTM'         WKSAAR
     C                   MOVEL(P)  DTM           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DTM                            01
     C                   MOVEL(P)  DTM           W1SATZ
     C                   MOVEL(P)  A35#03        DTM2380
     C     DTM           IFNE      W1SATZ
     C                   MOVEL(P)  '2  '         DTM2005
     C                   MOVEL(P)  '102'         DTM2379
     C                   MOVEL(P)  'DTM'         WKSAAR
     C                   MOVEL(P)  DTM           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF                            01
     C                   MOVEL(P)  RFF           W1SATZ
     C                   MOVEL(P)  A35#13        RFF1154
     C     RFF           IFNE      W1SATZ
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  'RFF'         WKSAAR
     C                   MOVEL(P)  RFF           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF                            01
     C                   MOVEL(P)  RFF           W1SATZ
     C                   MOVEL(P)  A35#10        RFF1154
     C     RFF           IFNE      W1SATZ
     C                   MOVEL(P)  'CR '         RFF1153
     C                   MOVEL(P)  'RFF'         WKSAAR
     C                   MOVEL(P)  RFF           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DTM                            01
     C                   MOVEL(P)  DTM           W1SATZ
     C                   MOVEL(P)  A25#1         DTM2380
     C     DTM           IFNE      W1SATZ
     C                   MOVEL(P)  '137'         DTM2005
     C                   MOVEL(P)  '102'         DTM2379
     C                   MOVEL(P)  'DTM'         WKSAAR
     C                   MOVEL(P)  DTM           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   NAD
     C                   MOVEL(P)  NAD           W1SATZ
     C                   MOVEL(P)  A17#1         NAD3039
     C     NAD           IFNE      W1SATZ
     C                   MOVEL(P)  'SU'          NAD3035
     C                   MOVEL(P)  '9 '          NAD3055
     C                   MOVEL(P)  'NAD'         WKSAAR
     C                   MOVEL(P)  NAD           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF
     C                   MOVEL(P)  RFF           W1SATZ
     C                   MOVEL(P)  A35#08        RFF1154
     C     RFF           IFNE      W1SATZ
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  'RFF'         WKSAAR
     C                   MOVEL(P)  RFF           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   NAD
     C                   MOVEL(P)  NAD           W1SATZ
     C                   MOVEL(P)  A17#2         NAD3039
     C     NAD           IFNE      W1SATZ
     C                   MOVEL(P)  'BY'          NAD3035
     C                   MOVEL(P)  '9 '          NAD3055
     C                   MOVEL(P)  'NAD'         WKSAAR
     C                   MOVEL(P)  NAD           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF
     C                   MOVEL(P)  RFF           W1SATZ
     C                   MOVEL(P)  A35#06        RFF1154
     C     RFF           IFNE      W1SATZ
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  'RFF'         WKSAAR
     C                   MOVEL(P)  RFF           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   NAD
     C                   MOVEL(P)  NAD           W1SATZ
     C                   MOVEL(P)  A17#3         NAD3039
     C                   MOVEL(P)  A35#14        NAD3036#1
     C                   MOVEL(P)  A35#15        NAD3042#1
     C                   MOVEL(P)  A35#16        NAD3164
     C                   MOVEL(P)  A9#1          NAD3251
     C                   MOVEL(P)  A3#31         NAD3207
     C                   MOVEL(P)  A25#2         NAD3124#1
     C                   MOVEL(P)  A70#16        NAD3124#2
     C*
     C     NAD           IFNE      W1SATZ
     C                   MOVEL(P)  'DP'          NAD3035
     C                   MOVEL(P)  '9 '          NAD3055
     C                   MOVEL(P)  'NAD'         WKSAAR
     C                   MOVEL(P)  NAD           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF
     C                   MOVEL(P)  RFF           W1SATZ
     C                   MOVEL(P)  A70#02        RFF1154
     C     RFF           IFNE      W1SATZ
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  'RFF'         WKSAAR
     C                   MOVEL(P)  RFF           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CUX
     C                   MOVEL(P)  CUX           W1SATZ
     C                   MOVEL(P)  A3#06         CUX6345#1
     C     CUX           IFNE      W1SATZ
     C                   MOVEL(P)  '9 '          CUX6343#1
     C                   MOVEL(P)  'CUX'         WKSAAR
     C                   MOVEL(P)  CUX           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 110000000                                    ***
     C**************************************************************************
     C     V11000        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   FTX
     C                   MOVEL(P)  FTX           W1SATZ
     C                   MOVEL(P)  'ZZZ'         FTX4451
     C                   MOVEL(P)  A70#01        FTX4440#1
     C                   MOVEL(P)  A70#02        FTX4440#2
     C                   MOVEL(P)  A70#03        FTX4440#3
     C                   MOVEL(P)  A70#04        FTX4440#4
     C                   MOVEL(P)  A70#05        FTX4440#5
     C     FTX           IFNE      W1SATZ
     C                   MOVEL(P)  'FTX'         WKSAAR
     C                   MOVEL(P)  FTX           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 120000000                                    ***
     C**************************************************************************
     C     V12000        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 150000000                                    ***
     C**************************************************************************
     C     V15000        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   LIN
     C                   MOVEL(P)  LIN           W1SATZ
     C                   Z-ADD     N6#1          LIN1082#1
     C                   MOVEL     A35#01        LIN7140
     C     LIN           IFNE      W1SATZ
     C                   MOVEL(P)  'EN '         LIN7143
     C                   MOVEL(P)  'LIN'         WKSAAR
     C                   MOVEL(P)  LIN           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PIA
     C                   MOVEL(P)  PIA           W1SATZ
     C                   MOVEL     A35#03        PIA7140#1
     C                   MOVEL     A35#02        PIA7140#2
     C     PIA           IFNE      W1SATZ
     C                   MOVEL(P)  '1'           PIA4347
     C                   MOVEL(P)  'SA '         PIA7143#1
     C                   MOVEL(P)  '91 '         PIA3055#1
     C                   MOVEL(P)  'BP '         PIA7143#2
     C                   MOVEL(P)  '92 '         PIA3055#2
     C                   MOVEL(P)  'PIA'         WKSAAR
     C                   MOVEL(P)  PIA           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   IMD
     C                   MOVEL(P)  IMD           W1SATZ
     C                   MOVEL     A35#07        IMD7008#1
     C     IMD           IFNE      W1SATZ
     C                   MOVEL(P)  'IMD'         WKSAAR
     C                   MOVEL(P)  IMD           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   QTY
     C                   MOVEL(P)  QTY           W1SATZ
     C                   Z-ADD     NP2#6         DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  A3#04         QTY6411
     C     QTY           IFNE      W1SATZ
     C                   MOVEL(P)  '52'          QTY6063
     C                   MOVEL(P)  'QTY'         WKSAAR
     C                   MOVEL(P)  QTY           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   QTY
     C                   MOVEL(P)  QTY           W1SATZ
     C                   Z-ADD     NP2#1         DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  A3#01         QTY6411
     C     NP2#6         IFNE      *ZERO
     C     NP2#1         MULT      NP2#6         DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  A3#04         QTY6411
     C                   ENDIF
     C     QTY           IFNE      W1SATZ
     C                   MOVEL(P)  '21'          QTY6063
     C                   MOVEL(P)  'QTY'         WKSAAR
     C                   MOVEL(P)  QTY           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DTM                            01
     C                   MOVEL(P)  DTM           W1SATZ
     C                   MOVEL(P)  A14#1         DTM2380
     C     A14#1         IFEQ      *BLANK
     C                   MOVEL(P)  A35#04        DTM2380
     C                   ENDIF
     C     DTM           IFNE      W1SATZ
     C                   MOVEL(P)  '2  '         DTM2005
     C                   MOVEL(P)  '102'         DTM2379
     C                   MOVEL(P)  'DTM'         WKSAAR
     C                   MOVEL(P)  DTM           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 153000000                                    ***
     C**************************************************************************
     C     V15300        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 154000000                                    ***
     C**************************************************************************
     C     V15400        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   FTX
     C                   MOVEL(P)  FTX           W1SATZ
     C                   MOVEL(P)  'ZZZ'         FTX4451
     C                   MOVEL(P)  A70#01        FTX4440#1
     C                   MOVEL(P)  A70#02        FTX4440#2
     C                   MOVEL(P)  A70#03        FTX4440#3
     C                   MOVEL(P)  A70#04        FTX4440#4
     C                   MOVEL(P)  A70#05        FTX4440#5
     C     FTX           IFNE      W1SATZ
     C                   MOVEL(P)  'FTX'         WKSAAR
     C                   MOVEL(P)  FTX           WKSATZ
     C                   EXSR      WORDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN   HRCLVL 155000000                                    ***
     C**************************************************************************
     C     V15500        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI ICRG                                                 ***
     C**************************************************************************
     C     UICRG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSQSTMT =
     C                             'UPDATE ' + %TRIM(WKTRPALIBL) + '/' +
     C                              %TRIM(WKTRPAFILE) +
     C                             ' SET XEORF = ''E''' +
     C                             ' WHERE SNDREC = ''RCV''' +
     C                             ' AND PRTNUM   = ''' + PRTNUM + '''' +
     C                             ' AND MSGTYP   = ''ORDERS''' +
     C                             ' AND MAIKEY   = ''' + MAIKEY + '''' +
     C                             ' AND HRCLVL   = ''' + HRCLVL + '''' +
     C                             ' AND LINNUM   = ' + %CHAR(LINNUM)
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE WKSQICRG   FROM :WKSQSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ EXECUTE WKSQICRG
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERAARBEITEN ENDE                                                 ***
     C**************************************************************************
     C     VENDE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNS
     C                   MOVEL     'S'           UNS0081
     C                   MOVEL     'UNS'         WKSAAR
     C                   MOVEL(P)  UNS           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNT
     C                   MOVEL     'UNT'         WKSAAR
     C                   MOVEL(P)  UNT           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNZ
     C                   MOVEL     'UNZ'         WKSAAR
     C                   MOVEL(P)  UNZ           WKSATZ
     C                   EXSR      WORDE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  WORDE         SCHREIBEN    ORDE                                   ***
     C**************************************************************************
     C     WORDE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ORDE
     C                   MOVEL(P)  WKN140        EDKYNR
     C                   MOVEL(P)  WKSAAR        EDSAAR
     C                   MOVEL(P)  WKSATZ        EDSATZ
     C*
     C                   MOVEL(P)  WKN140        KYEDKN
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHORDE
     C*
     C                   ADD       1             WKN140
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
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
     C     *LIKE         DEFINE    WKC001        WKSQSTMT       +999
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EDSAAR        WKSAAR
     C     *LIKE         DEFINE    EDSATZ        WKSATZ
     C     *LIKE         DEFINE    EDSATZ        W1SATZ
     C*
     C     *LIKE         DEFINE    DUN140        WKN140
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHORDE
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
