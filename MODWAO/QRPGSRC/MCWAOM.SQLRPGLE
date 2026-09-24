     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE MC-Routine für Datei WAOM
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 28.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 25.11.2012 Projekt 9103  Vereinfachte Möglichkeit der Veränderung %-Sätze
     H*            Erweiterung der Datei WAOM um die Felder WAOMLDNR, WAOMSTKD
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei WAOM.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KYWAOMKSTC Kunden-Steuerung (WAECO Vertriebsbereich)
     F*  KOM(04) = KYWAOMKDGR Kunden-Gruppe
     F*  KOM(08) = KYWAOMKDPL Kunden-Planung
     F*  KOM(12) = KYWAOMKDNR Kunden-Nr
     F*  KOM(22) = KYWAOMLDNR Land-Nr
     F*  KOM(25) = KYWAOMPRGR Produkt-Gruppe
     F*  KOM(29) = KYWAOMJAHR Jahr
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMCWAOMFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWAOMR1:RCDNBR)
     F                                     SFILE(DLWAOMR1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFLWAOM         S                   LIKE(KYWAOM) DIM(999) DESCEND
     D SFLAUSW         S                   LIKE(SFAUSW) DIM(999)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,MCCURSOR
     D*
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOM          E DS
     D KYWAOM        E DS                  INZ
     D UXWAOM        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
     D*
     D EXTRSB        E DS
     D EXTRSBPTR§      S               *
     D RTTRSB        E DS
     D*
     D EXWAOM        E DS                  INZ
     D RTWAOM        E DS                  INZ
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
     D/COPY QCPYSRC,EXUX05
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
     C                   PARM                    WAOM
     C*
     C                   EXSR      UEBKOM
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
     C                   EXSR      KEYWAOM
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      'M1'          WKIFMT
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      MCWAOMFM
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'DL'          BILDDL
     C     WKIFMT        CASEQ     'M1'          BILDM1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     #CRTCD        OREQ      '9'
     C                   CLEAR                   WAOM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     MCWAOMFM
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
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN
     C                   Z-ADD     *ZERO         #CDATV
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM                     WAOM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'MCWAOM'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         EXTEXTMSGA
     C                   MOVEL(P)  'KEIN'        EXTEXTMSGN
     C                   MOVE      'PRUEFE'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C                   MOVEL(P)  RTTEXTTEXT    TXKEIN
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVE      '01'          WKMCKZ
     C                   Z-ADD     *ZERO         WKPAGE
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*--------------------------------------------------------
     C                   BITOFF    '01234567'    WKAT01
     C                   BITON     '26'          WKAT01
     C                   BITOFF    '01234567'    WKAT02
     C                   BITON     '25'          WKAT02
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *OFF          WKIOKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MCWAOMFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     #CPGST        IFNE      WKPGST
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CMCFG        MCF
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     WKPGST        ANDEQ     *BLANK                                       auf reinen Anzeige-
     C                   MOVE      '5     '      WKPGST                         modus umschalten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSWAOMKSTC
     C                   MOVEA(P)  KOM(04)       DSWAOMKDGR
     C                   MOVEA(P)  KOM(08)       DSWAOMKDPL
     C                   MOVEA(P)  KOM(12)       DSWAOMKDNR
     C                   MOVEA(P)  KOM(22)       DSWAOMLDNR
     C                   MOVEA(P)  KOM(25)       DSWAOMPRGR
     C*
     C                   MOVEA(P)  KOM(29)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        DSWAOMJAHR
     C*
     C                   MOVE      *BLANK        DSKDEWKSST
     C                   MOVE      *BLANK        DSLANDGEBT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0172'        #CUEBE
     C     #CUEBE        WHENEQ    *BLANK
     C                   MOVE      '0012'        #CUEBE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BNR'         EXTEXTMSGA
     C                   MOVEL(P)  #CUEBE        EXTEXTMSGN
     C                   MOVE      'ERMBSK'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C*
     C                   MOVEL(P)  RTTEXTTEXT    DSBT01
     C                   MOVEA(P)  RTTEXTBSKZ    BSK
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKBT24
     C*-------------------------------------------------------------------------
     C                   MOVE      'M1'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C                   MOVE      *OFF          WKIWND
     C*-------------------------------------------------------------------------
     C* Ermitteln SQL-Satzberechtigung
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST = 'SQL'
     C                   EVAL      EXTRSBFILE = 'KDEW'
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C*--------------------------------------------------------
     C                   MOVEL(P)  RTTRSBSQST    RTTRSBKDEW
     C*-------------------------------------------------------------------------
     C* Ermitteln SQL-Satzberechtigung
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C                   EVAL      EXTRSBPGST = 'SQL'
     C                   EVAL      EXTRSBFILE = 'KUND'
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C*--------------------------------------------------------
     C                   MOVEL(P)  RTTRSBSQST    RTTRSBKUND
     C*-------------------------------------------------------------------------
     C     WKPGST        IFNE      *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAOM                                                ***
     C**************************************************************************
     C     KEYWAOM       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM WAOM '  +
     C                             'WHERE WAOMFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        DSKDEWKSST <> *BLANK OR RTTRSBKDEW <> ' '
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             '     WHERE KDEW.KDEWFIRM=WAOM.WAOMFIRM ' +
     C                             '     AND   KDEW.KDEWKDNR=WAOM.WAOMSTKD '
     C*
     C                   IF        RTTRSBKDEW <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                                      ' ' + %TRIM(RTTRSBKDEW)
     C                   ENDIF
     C*
     C                   IF        DSKDEWKSST <> *BLANK
     C                   IF        %SCAN(WCTRD:DSKDEWKSST) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKSST = ''' + DSKDEWKSST + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KDEW.KDEWKSST) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSKDEWKSST)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOMKSTC <> *BLANK OR DSWAOMKDGR <> *BLANK
     C                                                  OR RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOM.WAOMFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOM.WAOMSTKD '
     C*
     C                   IF        RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                                      ' ' + %TRIM(RTTRSBKUND)
     C                   ENDIF
     C*
     C                   IF        DSWAOMKSTC <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMKSTC) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + DSWAOMKSTC + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKSTC) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMKSTC)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOMKDGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMKDGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + DSWAOMKDGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKDGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMKDGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOMKDPL <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMKDPL) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOMKDPL = ''' + DSWAOMKDPL + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOMKDPL) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMKDPL)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOMKDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMKDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOMKDNR = ''' + DSWAOMKDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOMKDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMKDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSLANDGEBT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT LNGEBT FROM LAND ' +
     C                             ' WHERE  LAND.LNLDNR=WAOM.WAOMLDNR '
     C*
     C                   IF        %SCAN(WCTRD:DSLANDGEBT) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND LAND.LNGEBT = ''' + DSLANDGEBT + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(LAND.LNGEBT) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSLANDGEBT)) + ''''
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOMLDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMLDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOMLDNR = ''' + DSWAOMLDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOMLDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMLDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOMPRGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOMPRGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOMPRGR = ''' + DSWAOMPRGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOMPRGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOMPRGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOMJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOMJAHR = ' + %CHAR(DSWAOMJAHR)
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY WAOMFIRM, WAOMPLKZ,' +
     C                             ' WAOMKSTC, WAOMKDGR, WAOMKDPL, WAOMKDNR,' +
     C                             ' WAOMLDNR, WAOMPRGR, WAOMJAHR '
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' OPTIMIZE FOR 200 ROWS '
     C*-------------------------------------------------------------------------
     C                   MOVE      'KY'          WKMCKZ
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
     C                   WRITE     MCWAOM01
     C                   WRITE     MCWAOMK1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   SELECT
     C     WKPGST        WHENEQ    '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   WRITE     MCWAOMB2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWAOMB1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWAOMB3
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      MCWAOMK1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
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
     C     C#UPDT        WHENEQ    *ON
     C     FUKT05        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   MOVEL(P)  DSWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     *ZERO         KYWAOMJAHR
     C                   EXSR      TRWAOM
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DSWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     DSWAOMJAHR    KYWAOMJAHR
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      B01SI
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#MUST        WHENEQ    *ON
     C     FUKT20        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   MOVEL     *BLANK        KYWAOMKSTC
     C                   MOVEL     *BLANK        KYWAOMKDGR
     C                   MOVEL     *BLANK        KYWAOMKDPL
     C                   MOVEL     *BLANK        KYWAOMKDNR
     C                   MOVEL     *BLANK        KYWAOMLDNR
     C                   MOVEL     *BLANK        KYWAOMPRGR
     C                   Z-ADD     *ZERO         KYWAOMJAHR
     C                   EXSR      TRWAOM
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#WEIT        WHENEQ    *ON
     C     FUKT24        ANDEQ     *ON
     C*
     C     WKBT24        IFEQ      *OFF
     C                   MOVE      *ON           WKBT24
     C                   ELSE
     C                   MOVE      *OFF          WKBT24
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#PGUP        WHENEQ    *ON
     C     FUKT26        ANDEQ     *ON
     C                   EXSR      BLAET
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DSWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     DSWAOMJAHR    KYWAOMJAHR
     C                   MOVE      *BLANK        SFAUSW
     C                   EXSR      TRTRDZ
     C
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
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      B01RA
     C                   EXSR      B01SF
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C     WKSUPD        ANDEQ     *OFF
     C     #CRTCD        OREQ      'N'
     C     WKSUPD        ANDEQ     *OFF
     C                   ITER
     C     WKSUPD        WHENEQ    *OFF
     C                   ITER
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
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
     C     WKUXMCOPEN    IFEQ      *ON
     C                   MOVEL     EXUXMCPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXMCOPEN
     C                   ENDIF
     C*
     C     WKUXMCOPEN    IFNE      *ON
     C                   EXSR      UXMCOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     MCWAOMK1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C                   Z-ADD     *ZERO         RCDNBR
     C                   Z-ADD     *ZERO         PAGNBR
     C*-------------------------------------------------------------------------
     C                   EXSR      CCURSOR
     C                   EXSR      OCURSOR
     C*-------------------------------------------------------------------------
     C     W$RCNO        DOWGT     RCDNBR
     C     W$RCNO        OREQ      *ZERO
     C*
     C                   SELECT
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      WAOMKY
     C                   ENDSL
     C*
     C                   MOVE      *ON           C#PGUP
     C*--------------------------------------------------------
     C     C#MORE        IFEQ      *ON
     C     W$RCNO        OREQ      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#PGUP
     C*
     C     W$RCNO        IFGT      *ZERO
     C     W$RCNO        ANDLE     RCDNBR
     C                   Z-ADD     W$RCNO        PAGNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      MCUEB
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     B01SI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXMCRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      RCDNBR = EXUXRCNR
     C     RCDNBR        CHAIN     MCWAOMR1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK                                       GEÄNDERTE SÄTZE ALS
     C                   MOVE      *ON           C#NEXT                         GEÄNDERT MARKIERT
     C                   ELSE                                                   LASSEN
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    MCWAOMR1
     C                   MOVE      *OFF          C#NEXT
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RETTEN DER AUSWAHL                                                ***
     C**************************************************************************
     C     B01RA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I2
     C                   MOVEL(P)  KYWAOM        WKWAOM
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KYWAOM
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM
     C                   READC     MCWAOMR1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TRWAOM                                       FORMAT SCHLIESSEN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOMR1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KYWAOM        SFLWAOM(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWAOM        KYWAOM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR SUBFILE                                         ***
     C**************************************************************************
     C     B01SF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      *OFF          WKIDEL
     C                   MOVE      *OFF          WKSUPD
     C                   Z-ADD     *ZERO         WKRCNO
     C                   Z-ADD     *ZERO         W$RCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*-------------------------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MCWAOMR1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'ENDE  '      PCPGST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     RCDNBR        W$RCNO
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOMR1
     C                   MOVE      *OFF          C#NEXT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      %TRIM(SFAUSW)='1' AND BSK(1)='J'
     C                   MOVE      '1     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='2' AND BSK(2)='J'
     C                   MOVE      '2     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='3' AND BSK(3)='J'
     C                   MOVE      '3     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='4' AND BSK(4)='J'
     C                   MOVE      '4     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)='5' AND BSK(5)='J'
     C                   MOVE      '5     '      PCPGST
     C                   WHEN      %TRIM(SFAUSW)<>' ' AND BSK(10)='J'
     C                   MOVE      'TRTRDZ'      PCPGST
     C                   WHEN      %TRIM(SFAUSW)=' '
     C                   MOVE      '      '      PCPGST
     C                   OTHER
     C                   MOVE      '0051'        WKFENR
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   MOVEL(P)  KYWAOM        WKWAOM
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WKWAOM        KYWAOM
     C                   Z-ADD     W$RCNO        RCDNBR
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKIDEL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   MOVE      'J'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *ON           *IN99
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      TRWAOM
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL     *ON           WKSUPD
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'TRTRDZ'
     C                   EXSR      TRTRDZ
     C*
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENNE    *BLANK
     C                   EXSR      TRWAOM
     C*
     C     PCPGST        IFNE      '5'                                          ANZEIGEN
     C     PCPGST        ANDNE     '4'                                          LÖSCHEN
     C     PCPGST        ANDNE     '3'                                          KOPIEREN
     C     #CRTCD        ANDNE     'N'                                          F12 GEDRÜCKT
     C                   EXSR      UPSBFL                                       UPDATE SUBFILE
     C                   ENDIF
     C*
     C                   SELECT
     C     PCPGST        WHENEQ    '2     '
     C*
     C     DATEST        WHENEQ    *BLANK
     C     PCPGST        ANDNE     '5     '
     C                   MOVEL     *ON           WKSUPD
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKFENR        ORNE      *ZERO
     C                   MOVEL     *OFF          WKSUPD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MCWAOMR1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    MCWAOMR1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C     RTWAOMKSTC    IFNE      *BLANK
     C     RTWAOMKDGR    ANDNE     *BLANK
     C     RTWAOMKDPL    ANDNE     *BLANK
     C     RTWAOMKDNR    ANDNE     *BLANK
     C     RTWAOMLDNR    ANDNE     *BLANK
     C     RTWAOMPRGR    ANDNE     *BLANK
     C     RTWAOMJAHR    ANDNE     *ZERO
     C                   MOVEL(P)  '2     '      PCPGST
     C                   MOVEL(P)  RTWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  RTWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  RTWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  RTWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  RTWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  RTWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     RTWAOMJAHR    KYWAOMJAHR
     C                   EXSR      TRWAOM
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     RCDNBR        ANDGT     *ZERO
     C     RCDNBR        CHAIN     MCWAOMR1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOMR1
     C                   MOVE      *OFF          C_AUSW
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG BILD01                                              ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      *ON           C#LCK1
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE LÖSCHANZEIGE                                        ***
     C**************************************************************************
     C     BILDDL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BDLDS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'DL'
     C                   WRITE     MCWAOM01
     C                   WRITE     DLWAOMK1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     MCWAOMDL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DLWAOMK1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      BDLSI
     C                   MOVE      *ZERO         WKFENR
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
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
     C***  FÜLLEN LÖSCHANZEIGE                                               ***
     C**************************************************************************
     C     BDLDS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     WKUXDLOPEN    IFEQ      *ON
     C                   MOVEL     EXUXDLPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXDLOPEN
     C                   ENDIF
     C*
     C     WKUXDLOPEN    IFNE      *ON
     C                   EXSR      UXDLOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     DLWAOMK1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     *ZERO         WKRCNO
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      '4 '
     C     SFAUSW        OREQ      ' 4'
     C                   ADD       1             WKRCNO
     C                   WRITE     DLWAOMR1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MCWAOMR1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UXMCREAD
     C*
     C     EXUXMCRTCD    IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOMR1
     C                   MOVE      *OFF          C#NEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             WKPGNO
     C                   MOVE      '0005'        WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     BDLSI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXDLRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      WKRCNO      = EXUXRCNR
     C     WKRCNO        CHAIN     DLWAOMR1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C     SFAUSW        IFNE      *BLANK                                       GEÄNDERTE SÄTZE ALS
     C                   MOVE      *ON           C#NEXT                         GEÄNDERT MARKIERT
     C                   ELSE                                                   LASSEN
     C                   MOVE      *OFF          C#NEXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   UPDATE    DLWAOMR1
     C                   MOVE      *OFF          C#NEXT
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDM1                                              ***
     C**************************************************************************
     C     BILDM1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'M1'
     C                   EXSR      EFLPO
     C                   WRITE     MCWAOMW3
     C                   WRITE     MCWAOMM1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W3WAOMB1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MCWAOMM1                             9899
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
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOM
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWAOM
     C                   MOVEA     *BLANK        SFLAUSW
     C                   Z-ADD     *ZERO         W$RCNO
     C                   MOVE      '01'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT M1                                        ***
     C**************************************************************************
     C     BM1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXKDEWKSST
     C                   MOVE      *BLANK        TXWAOMKSTC
     C                   MOVE      *BLANK        TXWAOMKDGR
     C                   MOVE      *BLANK        TXWAOMKDPL
     C                   MOVE      *BLANK        TXLANDGEBT
     C                   MOVE      *BLANK        TXWAOMLDNR
     C                   MOVE      *BLANK        TXWAOMPRGR
     C*-------------------------------------------------------------------------
     C     DSKDEWKSST    CASNE     *BLANK        PRKDEWKSST
     C                   ENDCS
     C     DSWAOMKSTC    CASNE     *BLANK        PRWAOMKSTC
     C                   ENDCS
     C     DSWAOMKDGR    CASNE     *BLANK        PRWAOMKDGR
     C                   ENDCS
     C     DSWAOMKDPL    CASNE     *BLANK        PRWAOMKDPL
     C                   ENDCS
     C     DSLANDGEBT    CASNE     *BLANK        PRLANDGEBT
     C                   ENDCS
     C     DSWAOMLDNR    CASNE     *BLANK        PRWAOMLDNR
     C                   ENDCS
     C     DSWAOMPRGR    CASNE     *BLANK        PRWAOMPRGR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMJAHR'  EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDM1                                          ***
     C**************************************************************************
     C     BM1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKDEWKSST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMKSTC
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMKDGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMKDPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMKDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLANDGEBT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMLDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMPRGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOMJAHR
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
     C***  FUNKTIONSTASTE 4 BILDM1                                           ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSKDEWKSST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      MCKDEWKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMKSTC'
     C                   EXSR      MCWAOMKSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMKDGR'
     C                   EXSR      MCWAOMKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMKDPL'
     C                   EXSR      MCWAOMKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMKDNR'
     C                   EXSR      MCWAOMKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      MCLANDGEBT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMLDNR'
     C                   EXSR      MCWAOMLDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMPRGR'
     C                   EXSR      MCWAOMPRGR
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KOSTEN-STELLE (COMMERCIAL-DIVISION)                      ***
     C**************************************************************************
     C     MCKDEWKSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWKSST    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSKDEWKSST    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWKSST
     C                   MOVEL(P)  TPTTXT        TXKDEWKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KOSTEN-STELLE (COMMERCIAL-DIVISION)                        ***
     C**************************************************************************
     C     PRKDEWKSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKSST'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKDEWKSST
     C*-------------------------------------------------------------------------
     C                   IF        DSKDEWKSST <> *BLANK
     C                             AND %SCAN(WCTRD:DSKDEWKSST) = *ZERO
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSKDEWKSST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKSST
     C*
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C* Prüfen Satzberechtigung
     C*--------------------------------------------------------
     C                   EXSR      PCHECKTRSB
     C*
     C                   IF        RTTRSBBERE  = *OFF
     C                   EVAL      WKFENR      = '0089'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KSTC                                                   ***
     C**************************************************************************
     C     MCWAOMKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOMKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KSTC                                                   ***
     C**************************************************************************
     C     PRWAOMKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMKSTC
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMKSTC <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOMKSTC) = *ZERO
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOMKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDGR                                                   ***
     C**************************************************************************
     C     MCWAOMKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOMKDGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDGR                                                   ***
     C**************************************************************************
     C     PRWAOMKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMKDGR
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMKDGR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOMKDGR) = *ZERO
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOMKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDPL                                                   ***
     C**************************************************************************
     C     MCWAOMKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOMKDPL    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDPL                                                   ***
     C**************************************************************************
     C     PRWAOMKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMKDPL
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMKDPL <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOMKDPL) = *ZERO
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOMKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     MCWAOMKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOMKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOMKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRWAOMKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMKDNR <> *BLANK
     C                   MOVEL(P)  DSWAOMKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   IF        WKFENR = *ZERO
     C                             OR %SCAN(WCTRD:DSWAOMKDNR) <> *ZERO          "*"-FUNKTION
     C                   MOVEL(P)  KDKDNR        DSWAOMKDNR
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN GEBIET                                                   ***
     C**************************************************************************
     C     MCLANDGEBT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSLANDGEBT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLANDGEBT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'GEBT'        KOM(02)
     C                   MOVEA     DSLANDGEBT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSLANDGEBT
     C                   MOVEL(P)  TPTTXT        TXLANDGEBT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN GEBIET                                                     ***
     C**************************************************************************
     C     PRLANDGEBT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLANDGEBT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLANDGEBT
     C*-------------------------------------------------------------------------
     C                   IF        DSLANDGEBT <> *BLANK
     C                             AND %SCAN(WCTRD:DSLANDGEBT) = *ZERO
     C                   MOVEL(P)  'GEBT'        KYTPTA
     C                   MOVEL(P)  DSLANDGEBT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXLANDGEBT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LÄNDER-STAMM                                              ***
     C**************************************************************************
     C     MCWAOMLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOMLDNR    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOMLDNR
     C                   EXSR      PRWAOMLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LDNR                                                   ***
     C**************************************************************************
     C     PRWAOMLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMLDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMLDNR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOMLDNR) = *ZERO
     C                   MOVEA(P)  DSWAOMLDNR    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXWAOMLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     MCWAOMPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOMPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     PRWAOMPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMPRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMPRGR
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOMPRGR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOMPRGR) = *ZERO          "*"-Funktion
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOMPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE JAHR                                                   ***
     C**************************************************************************
     C     PRWAOMJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMJAHR    IFNE      *ZERO
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOMJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BLAETTERROUTINE                                                   ***
     C**************************************************************************
     C     BLAET         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    'KY'
     C                   EXSR      WAOMKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     MCWAOMLO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE ÜBERSCHRIFT ERMITTELN                                   ***
     C**************************************************************************
     C     MCUEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCUB'      WKSBFLPGST
     C                   Z-ADD     WKISIC        WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBE
     C                   EXSR      UMUEBE
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBEJV
     C                   EXSR      UMUEBEJV
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR                                                      ***
     C**************************************************************************
     C     CCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKOPENKY      WHENEQ    *ON
     C                   EXSR      CCWAOMKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  OPEN CURSOR                                                       ***
     C**************************************************************************
     C     OCURSOR       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKMCKZ        WHENEQ    'KY'
     C     WKOPENKY      ANDNE     *ON
     C                   EXSR      OCWAOMKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOMKY                                             ***
     C**************************************************************************
     C     OCWAOMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOM   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOMKY SCROLL CURSOR FOR SQWAOM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOMKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI WAOM                                               ***
     C**************************************************************************
     C     WAOMKY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     14            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C/EXEC SQL
     C+ FETCH CURRENT FROM WAOMKY INTO :WAOM
     C/END-EXEC
     C                   Z-ADD     WKRENO        RCDNBR                         ZURÜCKSCHR.
     C                   ELSE
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM WAOMKY INTO :WAOM
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE+1)
     C*--------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C     RCDNBR        OREQ      9999
     C                   MOVE      *ON           C#MORE                         SFLEND-KENNZ.
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C                   MOVEL(P)  WAOMKSTC      KYWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      KYWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      KYWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      KYWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      KYWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      KYWAOMPRGR
     C                   Z-ADD     WAOMJAHR      KYWAOMJAHR
     C*
     C                   ADD       1             RCDNBR
     C*
     C                   EXSR      ADUMM
     C*
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW
     C                   EXSR      FKONS
     C*
     C                   WRITE     MCWAOMR1
     C                   EXSR      UXMCWRTE
     C*
     C/EXEC SQL
     C+ FETCH NEXT FROM WAOMKY INTO :WAOM
     C/END-EXEC
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             I0
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      ERPAGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI WAOMKY                                         ***
     C**************************************************************************
     C     CCWAOMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOMKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN FÜR ANZEIGEN                                          ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WAOMKSTC      IFNE      *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  WAOMKSTC      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOMKSTC
     C                   ELSE
     C                   MOVE      *BLANK        SFWAOMKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAOMKDGR      IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  WAOMKDGR      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOMKDGR
     C                   ELSE
     C                   MOVE      *BLANK        SFWAOMKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAOMKDPL      IFNE      *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  WAOMKDPL      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOMKDPL
     C                   ELSE
     C                   MOVE      *BLANK        SFWAOMKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*MG                MOVEL(P)  WAOMKDNR      KYKDNR
     C                   MOVEL(P)  WAOMSTKD      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  KDKSTC        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFKUNDKSTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  KDKDGR        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFKUNDKDGR
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  WAOMLDNR      KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        SFWAOMLDNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  WAOMPRGR      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOMPRGR
     C*-------------------------------------------------------------------------
     C* Ermitteln Kostenestelle aus KD-Stamm Erweiterung oder aus Anwendungs-Code
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOMKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  WAOMKDNR      KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWKSST      SFTRTPKSST
     C     WAOMKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  WAOMKDPL      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   MOVE      *BLANK        SFTRTPKSST
     C                   ELSE
     C                   Z-ADD     TPTNUM        DUN100
     C                   EVAL      SFTRTPKSST  = %CHAR(DUN100)
     C                   ENDIF
     C                   OTHER
     C                   MOVE      *BLANK        SFTRTPKSST
     C                   ENDSL
     C*--------------------------------------------------------
     C     SFTRTPKSST    IFNE      *BLANK
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  SFTRTPKSST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTRTPKSST
     C                   ELSE
     C                   MOVE      *BLANK        TXTRTPKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SICHTEN                                                           ***
     C**************************************************************************
     C     ERSIC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SIC
     C*
     C     SIC           DOWLE     10
     C     FSI(SIC)      ANDNE     *ZERO
     C                   MOVEL     'ERMCUZ'      WKSBFLPGST
     C                   Z-ADD     FSI(SIC)      WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C
     C                   SELECT
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1JV
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2JV
     C     SIC           WHENEQ    3
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS3
     C     SIC           WHENEQ    4
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS4
     C     SIC           WHENEQ    5
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS5
     C     SIC           WHENEQ    6
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS6
     C     SIC           WHENEQ    7
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS7
     C     SIC           WHENEQ    8
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS8
     C     SIC           WHENEQ    9
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS9
     C     SIC           WHENEQ    10
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS10
     C                   ENDSL
     C*
     C                   ADD       1             SIC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON KONS MIT DER JEWEILIGEN SICHT                          ***
     C**************************************************************************
     C     FKONS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     SI            WHENEQ    1
     C                   MOVEL     EXUXS1        SFKONS
     C                   MOVEL     EXUXS1JV      SFKONSJV
     C     SI            WHENEQ    2
     C                   MOVEL     EXUXS2        SFKONS
     C                   MOVEL     EXUXS2JV      SFKONSJV
     C     SI            WHENEQ    3
     C                   MOVEL     EXUXS3        SFKONS
     C     SI            WHENEQ    4
     C                   MOVEL     EXUXS4        SFKONS
     C     SI            WHENEQ    5
     C                   MOVEL     EXUXS5        SFKONS
     C     SI            WHENEQ    6
     C                   MOVEL     EXUXS6        SFKONS
     C     SI            WHENEQ    7
     C                   MOVEL     EXUXS7        SFKONS
     C     SI            WHENEQ    8
     C                   MOVEL     EXUXS8        SFKONS
     C     SI            WHENEQ    9
     C                   MOVEL     EXUXS9        SFKONS
     C     SI            WHENEQ    10
     C                   MOVEL     EXUXS10       SFKONS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON AUSW BEIM NEUAUFBAU DER SUBFILE                        ***
     C**************************************************************************
     C     FAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYWAOM        LOOKUP    SFLWAOM(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *ON           C#NEXT
     C                   MOVEL(P)  SFLAUSW(I1)   SFAUSW
     C                   ELSE
     C                   MOVE      *OFF          C#NEXT
     C                   MOVE      *BLANK        SFAUSW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN VON AUSW NACH ERFOLGREICHER BEARBEITUNG                   ***
     C**************************************************************************
     C     LAUSW         BEGSR
     C*
     C                   Z-ADD     1             I1
     C*-------------------------------------------------------------------------
     C     KYWAOM        LOOKUP    SFLWAOM(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFLWAOM(I1)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SEITE                                                   ***
     C**************************************************************************
     C     ERPAGE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     RCDNBR        WHENEQ    *ZERO
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     1             PAGNBR
     C                   MOVE      *ON           C#NDSP
     C                   MOVE      *ON           WKILER
     C     C#IN28        IFEQ      *OFF
     C                   MOVEL(P)  TXKEIN        EXUXS1
     C                   MOVEL(P)  TXKEIN        EXUXS2
     C                   MOVEL(P)  TXKEIN        EXUXS3
     C                   MOVEL(P)  TXKEIN        EXUXS4
     C                   MOVEL(P)  TXKEIN        EXUXS5
     C                   MOVEL(P)  TXKEIN        EXUXS6
     C                   MOVEL(P)  TXKEIN        EXUXS7
     C                   MOVEL(P)  TXKEIN        EXUXS8
     C                   MOVEL(P)  TXKEIN        EXUXS9
     C                   MOVEL(P)  TXKEIN        EXUXS10
     C                   MOVEL(P)  TXKEIN        SFKONS
     C                   ELSE
     C                   MOVEL(P)  TXKEIN        EXUXS1JV
     C                   MOVEL(P)  TXKEIN        EXUXS2JV
     C                   MOVEL(P)  TXKEIN        SFKONSJV
     C                   ENDIF
     C                   WRITE     MCWAOMR1
     C                   EXSR      UXMCWRTE
     C*--------------------------------------------------------
     C     RCDNBR        WHENNE    *ZERO
     C     RCDNBR        SUB       1             PAGNBR
     C                   DIV       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   MULT      W$PAGE        PAGNBR
     C                   SUB       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   Z-ADD     PAGNBR        WKPAGE
     C                   Z-ADD     RCDNBR        WKRENO
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOM                                                 ***
     C**************************************************************************
     C     TRWAOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOM
     C                   MOVEL(P)  PCPGST        EXWAOMPGST
     C                   MOVEL(P)  KYWAOMKSTC    EXWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    EXWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    EXWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    EXWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    EXWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    EXWAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    EXWAOMJAHR
     C*
     C                   MOVEL(P)  DSKDEWKSST    EXWAOMKSST
     C                   MOVEL(P)  DSLANDGEBT    EXWAOMGEBT
     C*
     C                   CALL      'TRWAOM'
     C                   PARM                    EXWAOM
     C                   PARM                    RTWAOM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTWAOMPROG    WKPROG
     C                   MOVEL(P)  RTWAOMDANA    WKDANA
     C                   MOVEL(P)  RTWAOMFFLD    WKFFLD
     C                   MOVEL(P)  RTWAOMFENR    WKFENR
     C                   MOVEL(P)  RTWAOMPA03    W$PA03
     C                   MOVEL(P)  RTWAOMPA04    W$PA04
     C                   MOVEL(P)  RTWAOMPA05    W$PA05
     C                   MOVEL(P)  RTWAOMPA06    W$PA06
     C                   MOVEL(P)  RTWAOMPA07    W$PA07
     C*
     C                   MOVEL(P)  RTWAOMRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF SUBFILE-ZEILEN-ERMITTLUNG                                  ***
     C**************************************************************************
     C     TRAUFRSBFL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSBFL
     C                   MOVEL(P)  'MCWAOM'      EXSBFLPROG
     C                   MOVEL(P)  'MCWAOMFM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  'WAOM'        EXSBFLFIL1
     C                   MOVEL(P)  WAOM          EXSBFLDAT1
     C*
     C                   MOVEL(P)  'KUND'        EXSBFLFIL2
     C                   MOVEL(P)  KUND          EXSBFLDAT2
     C*
     C                   MOVEL(P)  'TXWAOMKSTC'  EXSBFLAF01
     C                   MOVEL(P)  SFWAOMKSTC    EXSBFLAL01
     C*
     C                   MOVEL(P)  'TXWAOMKDGR'  EXSBFLAF02
     C                   MOVEL(P)  SFWAOMKDGR    EXSBFLAL02
     C*
     C                   MOVEL(P)  'TXWAOMKDPL'  EXSBFLAF03
     C                   MOVEL(P)  SFWAOMKDPL    EXSBFLAL03
     C*
     C                   MOVEL(P)  'TXWAOMLDNR'  EXSBFLAF04
     C                   MOVEL(P)  SFWAOMLDNR    EXSBFLAL04
     C*
     C                   MOVEL(P)  'TXWAOMPRGR'  EXSBFLAF04
     C                   MOVEL(P)  SFWAOMPRGR    EXSBFLAL04
     C*
     C                   MOVEL(P)  '##KSST'      EXSBFLAF06
     C                   MOVEL(P)  SFTRTPKSST    EXSBFLAL06
     C*
     C                   MOVEL(P)  'TXKDEWKSST'  EXSBFLAF07
     C                   MOVEL(P)  TXTRTPKSST    EXSBFLAL07
     C*
     C                   MOVEL(P)  'TXKUNDKSTC'  EXSBFLAF08
     C                   MOVEL(P)  SFKUNDKSTC    EXSBFLAL08
     C*
     C                   MOVEL(P)  'TXKUNDKDGR'  EXSBFLAF09
     C                   MOVEL(P)  SFKUNDKDGR    EXSBFLAL09
     C*
     C                   EXSR      TRSBFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SQL SATZBERECHTIGUNG                                    ***
     C**************************************************************************
     C     ESQLTRSB      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C*
     C                   EVAL      EXTRSBPGST = 'SQL'
     C                   EVAL      EXTRSBFILE = 'KDEW'
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFUNG SATZBERECHTIGUNG                                          ***
     C**************************************************************************
     C     PCHECKTRSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRSB
     C*
     C                   EVAL      EXTRSBPGST = 'CHECK'
     C                   EVAL      EXTRSBFILE = 'TRTP'
     C                   EVAL      EXTRSBPTR§ = %ADDR(TRTP)
     C*
     C                   CALL      'TRTRSB'
     C                   PARM                    EXTRSB
     C                   PARM                    RTTRSB
     C                   PARM                    EXTRSBPTR§
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCSI'      WKSBFLPGST
     C                   Z-ADD     *ZERO         WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEA(P)  RTSBFLMCSI    WSI
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SI
     C                   Z-ADD     *ZERO         FSI
     C*--------------------------------------------------------
     C                   DO        10            I1
     C                   TESTN                   WSI(I1)              97
     C*
     C     *IN97         IFEQ      *ON
     C                   ADD       1             SI
     C                   MOVE      WSI(I1)       FSI(SI)
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SI
     C                   Z-ADD     FSI(SI)       WKISIC                         SICHT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSWAHL 10 UND ZUGRIFF AUF TRTRDZ                                 ***
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
     C                   MOVEL(P)  SFAUSW        EXTRDNAWCD
     C                   MOVEL(P)  'MCWAOM'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'MCWAOMB1'    EXTRDNPGNA
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'MCWAOMB2'    EXTRDNPGNA
     C                   ENDIF
     C*
     C                   MOVE      C#FUKT        EXTRDNFUKT
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
     C* F10=Optionen MCWAOMB1
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRWAOM02'                                   GEN. WAOM-SÄTZE
     C                   MOVE      'GWAOM '      PCPGST
     C                   EXSR      TRWAOM
     C*
     C                   MOVEL     *ON           WKSUPD
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRWAOM03'                                   ÄNDERN WAOM-SÄTZE
     C                   MOVE      'WAOM03'      PCPGST
     C                   MOVE      *BLANK        KYWAOMKSTC
     C                   MOVE      *BLANK        KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     DSWAOMJAHR    KYWAOMJAHR
     C                   EXSR      TRWAOM
     C*
     C                   MOVEL     *ON           WKSUPD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*
     C     SFAUSW        IFNE      *BLANK
     C     SFAUSW        ANDNE     '10'
     C                   LEAVE
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#BACK        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE SUBFILE-SATZ                                               ***
     C**************************************************************************
     C     UPSBFL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MCWAOMR1                           97
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOMKSTC      KYWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      KYWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      KYWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      KYWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      KYWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      KYWAOMPRGR
     C                   Z-ADD     WAOMJAHR      KYWAOMJAHR
     C*--------------------------------------------------------                 ANZEIGE
     C                   MOVE      *OFF          C#NDSP
     C*
     C                   EXSR      ADUMM
     C*
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FAUSW                                        PRÜFEN, OB AUSW EXIT
     C                   EXSR      FKONS                                        SICHT ÄNDERN
     C*
     C                   MOVE      *ON           C#NEXT                         ALS GEÄNDERT
     C                   UPDATE    MCWAOMR1                                     MARKIERT LASSEN
     C                   EXSR      UXMCRMKY
     C                   EXSR      UXMCWRTE
     C                   MOVE      *OFF          C#NEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXMCOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXMCPARM
     C                   EVAL      EXUXMCINAM = 'MCSBFWAOM'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile MCWAOM'
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXMCOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXMCWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = RCDNBR
     C                   EVAL      UXWAOMFIRM  = KYWAOMFIRM
     C                   EVAL      UXWAOMKSTC  = KYWAOMKSTC
     C                   EVAL      UXWAOMKDGR  = KYWAOMKDGR
     C                   EVAL      UXWAOMKDPL  = KYWAOMKDPL
     C                   EVAL      UXWAOMKDNR  = KYWAOMKDNR
     C                   EVAL      UXWAOMLDNR  = KYWAOMLDNR
     C                   EVAL      UXWAOMPRGR  = KYWAOMPRGR
     C                   EVAL      UXWAOMJAHR  = KYWAOMJAHR
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UXWAOM
     C                   EVAL      EXUXMCIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXMCREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOM
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOM)
     C                   EVAL      UXWAOM      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYWAOMFIRM  = UXWAOMFIRM
     C                   EVAL      KYWAOMKSTC  = UXWAOMKSTC
     C                   EVAL      KYWAOMKDGR  = UXWAOMKDGR
     C                   EVAL      KYWAOMKDPL  = UXWAOMKDPL
     C                   EVAL      KYWAOMKDNR  = UXWAOMKDNR
     C                   EVAL      KYWAOMLDNR  = UXWAOMLDNR
     C                   EVAL      KYWAOMPRGR  = UXWAOMPRGR
     C                   EVAL      KYWAOMJAHR  = UXWAOMJAHR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN   USERINDEX                                               ***
     C**************************************************************************
     C     UXMCRMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUXRCNR     = RCDNBR
     C                   EVAL      UXWAOMFIRM  = KYWAOMFIRM
     C                   EVAL      UXWAOMKSTC  = KYWAOMKSTC
     C                   EVAL      UXWAOMKDGR  = KYWAOMKDGR
     C                   EVAL      UXWAOMKDPL  = KYWAOMKDPL
     C                   EVAL      UXWAOMKDNR  = KYWAOMKDNR
     C                   EVAL      UXWAOMLDNR  = KYWAOMLDNR
     C                   EVAL      UXWAOMPRGR  = KYWAOMPRGR
     C                   EVAL      UXWAOMJAHR  = KYWAOMJAHR
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXWAOM
     C                   EVAL      EXUXMCIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCRMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXDLOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXDLPARM
     C                   EVAL      EXUXDLINAM  = 'DLSBFWAOM'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DLWAOM'
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXDLOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXDLWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = WKRCNO
     C                   EVAL      UXWAOMFIRM  = KYWAOMFIRM
     C                   EVAL      UXWAOMKSTC  = KYWAOMKSTC
     C                   EVAL      UXWAOMKDGR  = KYWAOMKDGR
     C                   EVAL      UXWAOMKDPL  = KYWAOMKDPL
     C                   EVAL      UXWAOMKDNR  = KYWAOMKDNR
     C                   EVAL      UXWAOMLDNR  = KYWAOMLDNR
     C                   EVAL      UXWAOMPRGR  = KYWAOMPRGR
     C                   EVAL      UXWAOMJAHR  = KYWAOMJAHR
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UXWAOM
     C                   EVAL      EXUXDLIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXDLREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOM
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOM)
     C                   EVAL      UXWAOM      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYWAOMFIRM  = UXWAOMFIRM
     C                   EVAL      KYWAOMKSTC  = UXWAOMKSTC
     C                   EVAL      KYWAOMKDGR  = UXWAOMKDGR
     C                   EVAL      KYWAOMKDPL  = UXWAOMKDPL
     C                   EVAL      KYWAOMKDNR  = UXWAOMKDNR
     C                   EVAL      KYWAOMLDNR  = UXWAOMLDNR
     C                   EVAL      KYWAOMPRGR  = UXWAOMPRGR
     C                   EVAL      KYWAOMJAHR  = UXWAOMJAHR
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
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILER
     C     *LIKE         DEFINE    WKC001        WKAT01
     C     *LIKE         DEFINE    WKC001        WKAT02
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIWND
     C     *LIKE         DEFINE    WKC001        WKMCKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKBT24
     C*
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPENKY
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SFTRTPKSST      + 9
     C     *LIKE         DEFINE    WKC001        TXTRTPKSST      +39
     C     *LIKE         DEFINE    WKC001        SFKUNDKSTC      +39
     C     *LIKE         DEFINE    WKC001        SFKUNDKDGR      +39
     C     *LIKE         DEFINE    WKC001        SFWAOMKSTC      +39
     C     *LIKE         DEFINE    WKC001        SFWAOMKDGR      +39
     C     *LIKE         DEFINE    WKC001        SFWAOMKDPL      +39
     C     *LIKE         DEFINE    WKC001        SFWAOMLDNR      +39
     C     *LIKE         DEFINE    WKC001        SFWAOMPRGR      +39
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSUPD
     C     *LIKE         DEFINE    WKC001        WKIDEL
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        TXKEIN          +75
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        SI              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKISIC           +1
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    PAGNBR        WKPAGE
     C     *LIKE         DEFINE    PAGNBR        W$PAGE
     C     *LIKE         DEFINE    RCDNBR        WKRENO
     C     *LIKE         DEFINE    RCDNBR        W$RCNO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOM        WKWAOM
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKDEW
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKUND
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOMPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOMDANA    WKDANA
     C     *LIKE         DEFINE    RTWAOMFFLD    WKFFLD
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
     C                   MOVEL(P)  'MCWAOM'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWAOMW3
     C                   OTHER
     C                   WRITE     MCWAOMCT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWAOMW3
     C                   OTHER
     C                   WRITE     MCWAOMCT
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
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCLAND
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRLANDLAND
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRSBFL
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
