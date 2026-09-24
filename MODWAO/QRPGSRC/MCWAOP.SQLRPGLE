     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE MC-Routine für Datei WAOP
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 24.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 11.06.2012 Projekt 8559, Artikel statt Produktgruppe
     H*  Änderung: MG 20.08.2012 Projekt 8751, Satzberechtigung (TRSB)
     H*  Änderung: MG 07.09.2012 Projekt 8886,
     H*            Erweiterung der Datei WAOK um das Feld WAOKLDNR "Land-Nr"
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei WAOP.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KYWAOPPLAT Plan-Art
     F*  KOM(04) = KYWAOPWKNR Werks-Nr
     F*  KOM(07) = KYWAOPKSTC Kunden-Steuerung (WAECO Vertriebsbereich)
     F*  KOM(10) = KYWAOPKDGR Kunden-Gruppe
     F*  KOM(14) = KYWAOPKDPL Kunden-Planung
     F*  KOM(18) = KYWAOPKDNR Kunden-Nr
     F*  KOM(28) = KYWAOPLDNR Land-Nr
     F*  KOM(31) = KYWAOPTENR Ident-Nr
     F*  KOM(46) = KYWAOPJAHR Jahr
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMCWAOPFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWAOPR1:RCDNBR)
     F                                     SFILE(DLWAOPR1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFLWAOP         S                   LIKE(KYWAOP) DIM(999) DESCEND
     D SFLAUSW         S                   LIKE(SFAUSW) DIM(999)
     D*
     D SFLMG           S                   DIM(12) INZ LIKE(WAOPPLMG)
     D SFLUM           S                   DIM(12) INZ LIKE(WAOPPLUM)
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
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOK          E DS                  INZ
     D KYWAOK        E DS                  INZ
     D*
     D WAOP          E DS
     D KYWAOP        E DS                  INZ
     D UXWAOP        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
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
     D EXWAOK        E DS                  INZ
     D RTWAOK        E DS                  INZ
     D*
     D EXWAOM        E DS                  INZ
     D RTWAOM        E DS                  INZ
     D*
     D EXWAOP        E DS                  INZ
     D RTWAOP        E DS                  INZ
     D*
     D E1WAOP        E DS                  INZ
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
     C                   PARM                    WAOP
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
     C                   EXSR      KEYWAOP
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
     C                   OPEN      MCWAOPFM
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
     C                   CLEAR                   WAOP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     MCWAOPFM
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
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAOKFIRM                     WAOK
     C                   MOVEL(P)  DAFIRM        KYWAOPFIRM                     WAOP
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'MCWAOP'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C*                  MOVEA(P)  W99(32)       WNKOPF
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
     C                   MOVEA     *BLANK        SFLWAOP
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
     C                   MOVEL(P)  'MCWAOPFM'    EXFLPOFMTN
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
     C                   MOVEA     *BLANK        SFLWAOP
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
     C                   MOVEA(P)  KOM(01)       DSWAOPPLAT
     C                   MOVEA(P)  KOM(04)       DSWAOPWKNR
     C                   MOVEA(P)  KOM(07)       DSWAOPKSTC
     C                   MOVEA(P)  KOM(10)       DSWAOPKDGR
     C                   MOVEA(P)  KOM(14)       DSWAOPKDPL
     C                   MOVEA(P)  KOM(18)       DSWAOPKDNR
     C                   MOVEA(P)  KOM(28)       DSWAOPLDNR
     C                   MOVEA(P)  KOM(31)       DSWAOPTENR
     C*
     C                   MOVEA(P)  KOM(46)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        DSWAOPJAHR
     C*
     C                   MOVE      *BLANK        DSKDEWKSST
     C                   MOVE      *BLANK        DSLANDGEBT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0531'        #CUEBE
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
     C***  KEYBESTÜCKUNG WAOP                                                ***
     C**************************************************************************
     C     KEYWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM WAOP '  +
     C                             'WHERE WAOPFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        DSWAOPPLAT <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPPLAT) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPPLAT = ''' + DSWAOPPLAT + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPPLAT) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPPLAT)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPWKNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPWKNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPWKNR = ''' + DSWAOPWKNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPWKNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPWKNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSKDEWKSST <> *BLANK OR RTTRSBKDEW <> ' '
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             ' WHERE  KDEW.KDEWFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KDEW.KDEWKDNR=WAOP.WAOPSTKD '
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
     C                   IF        DSWAOPKSTC <> *BLANK OR DSWAOPKDGR <> *BLANK
     C                                                  OR RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOP.WAOPSTKD '
     C*
     C                   IF        RTTRSBKUND <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                                      ' ' + %TRIM(RTTRSBKUND)
     C                   ENDIF
     C*
     C                   IF        DSWAOPKSTC <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKSTC) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + DSWAOPKSTC + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKSTC) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKSTC)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + DSWAOPKDGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKDGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDPL <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDPL) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDPL = ''' + DSWAOPKDPL + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPKDPL) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDPL)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPKDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPKDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDNR = ''' + DSWAOPKDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPKDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPKDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSLANDGEBT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT LNGEBT FROM LAND ' +
     C                             ' WHERE  LAND.LNLDNR=WAOP.WAOPLDNR '
     C*
     C                   IF        %SCAN(WCTRD:DSLANDGEBT) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND LAND.LNGEBT = ''' + DSLANDGEBT + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(LAND.LNGEBT) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSLANDGEBT)) + ''''
     C                   ENDIF
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOPLDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPLDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPLDNR = ''' + DSWAOPLDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPLDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPLDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSTEILPRGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSTEILPRGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TEIL.TEPRGR = ''' + DSTEILPRGR + ''')'
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TRIM(TEIL.TEPRGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSTEILPRGR)) +''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPTENR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOPTENR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPTENR = ''' + DSWAOPTENR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOPTENR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOPTENR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOPJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPJAHR = ' + %CHAR(DSWAOPJAHR)
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY WAOPFIRM, WAOPPLAT, WAOPWKNR, ' +
     C                             ' WAOPPLKZ, WAOPKSTC, WAOPKDGR, WAOPKDPL, ' +
     C                             ' WAOPKDNR, WAOPLDNR, WAOPTENR, WAOPJAHR '
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
     C                   WRITE     MCWAOP01
     C                   WRITE     MCWAOPK1
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
     C                   WRITE     MCWAOPB2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWAOPB1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWAOPB3
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      MCWAOPK1                             9899
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
     C                   MOVEA     *BLANK        SFLWAOP
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOP
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
     C                   EXSR      TRWAOP
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
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
     C                   MOVEA     *BLANK        SFLWAOP
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
     C                   MOVEA     *BLANK        SFLWAOP
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   MOVEL     *BLANK        KYWAOPPLAT
     C                   MOVEL     *BLANK        KYWAOPWKNR
     C                   MOVEL     *BLANK        KYWAOPKSTC
     C                   MOVEL     *BLANK        KYWAOPKDGR
     C                   MOVEL     *BLANK        KYWAOPKDPL
     C                   MOVEL     *BLANK        KYWAOPKDNR
     C                   MOVEL     *BLANK        KYWAOPLDNR
     C                   MOVEL     *BLANK        KYWAOPTENR
     C                   Z-ADD     *ZERO         KYWAOPJAHR
     C                   EXSR      TRWAOP
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
     C                   MOVEL(P)  DSWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  DSWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  DSWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  DSWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  DSWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  DSWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  DSWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  DSWAOPTENR    KYWAOPTENR
     C                   Z-ADD     DSWAOPJAHR    KYWAOPJAHR
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
     C                   WRITE     MCWAOPK1
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
     C                   EXSR      WAOPKY
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
     C     RCDNBR        CHAIN     MCWAOPR1                           97
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
     C                   UPDATE    MCWAOPR1
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
     C                   MOVEL(P)  KYWAOP        WKWAOP
     C                   MOVEA     *BLANK        SFLWAOP
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KYWAOP
     C                   MOVEL(P)  DAFIRM        KYWAOPFIRM
     C                   READC     MCWAOPR1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TRWAOP                                       FORMAT SCHLIESSEN
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
     C                   UPDATE    MCWAOPR1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KYWAOP        SFLWAOP(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWAOP        KYWAOP
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
     C                   READC     MCWAOPR1                               99
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
     C                   UPDATE    MCWAOPR1
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
     C                   MOVEL(P)  KYWAOP        WKWAOP
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WKWAOP        KYWAOP
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
     C                   EXSR      TRWAOP
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
     C                   EXSR      TRWAOP
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
     C     RCDNBR        CHAIN     MCWAOPR1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    MCWAOPR1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C     RTWAOPPLAT    IFNE      *BLANK
     C     RTWAOPWKNR    ANDNE     *BLANK
     C     RTWAOPKSTC    ANDNE     *BLANK
     C     RTWAOPKDGR    ANDNE     *BLANK
     C     RTWAOPKDPL    ANDNE     *BLANK
     C     RTWAOPKDNR    ANDNE     *BLANK
     C     RTWAOPLDNR    ANDNE     *BLANK
     C     RTWAOPTENR    ANDNE     *BLANK
     C     RTWAOPJAHR    ANDNE     *ZERO
     C                   MOVEL(P)  '2     '      PCPGST
     C                   MOVEL(P)  RTWAOPPLAT    KYWAOPPLAT
     C                   MOVEL(P)  RTWAOPWKNR    KYWAOPWKNR
     C                   MOVEL(P)  RTWAOPKSTC    KYWAOPKSTC
     C                   MOVEL(P)  RTWAOPKDGR    KYWAOPKDGR
     C                   MOVEL(P)  RTWAOPKDPL    KYWAOPKDPL
     C                   MOVEL(P)  RTWAOPKDNR    KYWAOPKDNR
     C                   MOVEL(P)  RTWAOPLDNR    KYWAOPLDNR
     C                   MOVEL(P)  RTWAOPTENR    KYWAOPTENR
     C                   Z-ADD     RTWAOPJAHR    KYWAOPJAHR
     C                   EXSR      TRWAOP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     RCDNBR        ANDGT     *ZERO
     C     RCDNBR        CHAIN     MCWAOPR1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOPR1
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
     C                   EXSR      CHWAOP
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
     C                   WRITE     MCWAOP01
     C                   WRITE     DLWAOPK1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     MCWAOPDL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DLWAOPK1                             9899
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
     C                   WRITE     DLWAOPK1
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
     C                   WRITE     DLWAOPR1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MCWAOPR1                               99
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
     C                   UPDATE    MCWAOPR1
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
     C     WKRCNO        CHAIN     DLWAOPR1                           97
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
     C                   UPDATE    DLWAOPR1
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
     C                   WRITE     MCWAOPM1
     C                   WRITE     MCWAOPB4
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   READ      MCWAOPM1                             9899
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
     C                   EXSR      KEYWAOP
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWAOP
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
     C     DSWAOPPLAT    IFEQ      *BLANK
     C                   MOVEL     WKTRPAPLAT    DSWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPWKNR    IFEQ      *BLANK
     C                   MOVEL     WKTRPAWKNR    DSWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXWAOPPLAT
     C                   MOVE      *BLANK        TXWAOPWKNR
     C                   MOVE      *BLANK        TXKDEWKSST
     C                   MOVE      *BLANK        TXWAOPKSTC
     C                   MOVE      *BLANK        TXWAOPKDGR
     C                   MOVE      *BLANK        TXWAOPKDPL
     C                   MOVE      *BLANK        TXLANDGEBT
     C                   MOVE      *BLANK        TXWAOPLDNR
     C                   MOVE      *BLANK        TXTEILPRGR
     C*-------------------------------------------------------------------------
     C     DSWAOPPLAT    CASNE     *BLANK        PRWAOPPLAT
     C                   ENDCS
     C     DSWAOPWKNR    CASNE     *BLANK        PRWAOPWKNR
     C                   ENDCS
     C     DSKDEWKSST    CASNE     *BLANK        PRKDEWKSST
     C                   ENDCS
     C     DSWAOPKSTC    CASNE     *BLANK        PRWAOPKSTC
     C                   ENDCS
     C     DSWAOPKDGR    CASNE     *BLANK        PRWAOPKDGR
     C                   ENDCS
     C     DSWAOPKDPL    CASNE     *BLANK        PRWAOPKDPL
     C                   ENDCS
     C     DSLANDGEBT    CASNE     *BLANK        PRLANDGEBT
     C                   ENDCS
     C     DSWAOPLDNR    CASNE     *BLANK        PRWAOPLDNR
     C                   ENDCS
     C     DSTEILPRGR    CASNE     *BLANK        PRTEILPRGR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   SELECT
     C     DSWAOPPLAT    WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C     DSWAOPWKNR    WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOPWKNR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOPJAHR'  EXFLPOFLDN
     C                   ENDSL
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
     C                   EXSR      PRWAOPPLAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPWKNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKDEWKSST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPKSTC
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPKDGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPKDPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPKDNR
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
     C                   EXSR      PRWAOPLDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPJAHR
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
     C                   MOVEL(P)  'DSWAOPQQQQ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPPLAT'
     C                   EXSR      MCWAOPPLAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPWKNR'
     C                   EXSR      MCWAOPWKNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      MCKDEWKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKSTC'
     C                   EXSR      MCWAOPKSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDGR'
     C                   EXSR      MCWAOPKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDPL'
     C                   EXSR      MCWAOPKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPKDNR'
     C                   EXSR      MCWAOPKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      MCLANDGEBT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPLDNR'
     C                   EXSR      MCWAOPLDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEILPRGR'
     C                   EXSR      MCTEILPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPTENR'
     C                   EXSR      MCWAOPTENR
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  PERIODEN-DEFINITION                                     ***
     C**************************************************************************
     C     MCWAOPPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOPPLAT    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'APAT'        KOM(02)
     C                   MOVEA     DSWAOPPLAT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPPLAT
     C                   MOVEL(P)  TPTTXT        TXWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PERIODEN-DEFINITION                                        ***
     C**************************************************************************
     C     PRWAOPPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPPLAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APAT'        KYTPTA
     C                   MOVEL(P)  DSWAOPPLAT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPPLAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN  WERKS-STAMM                                             ***
     C**************************************************************************
     C     MCWAOPWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOPWKNR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPWKNR    KOM(01)
     C                   MOVE      'WERK01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCWERK
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  WRWKNR        DSWAOPWKNR
     C                   MOVEL(P)  WRWKBZ        TXWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WERKS-NR                                                   ***
     C**************************************************************************
     C     PRWAOPWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPWKNR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPWKNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPWKNR    KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXWAOPWKNR
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
     C     MCWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOPKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KSTC                                                   ***
     C**************************************************************************
     C     PRWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKSTC'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKSTC
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPKSTC <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOPKSTC) = *ZERO
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOPKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKSTC
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
     C***  MC-ROUTINE KDGR                                                   ***
     C**************************************************************************
     C     MCWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOPKDGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDGR                                                   ***
     C**************************************************************************
     C     PRWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPKDGR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOPKDGR) = *ZERO
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOPKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDPL                                                   ***
     C**************************************************************************
     C     MCWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOPKDPL    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDPL                                                   ***
     C**************************************************************************
     C     PRWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPKDPL <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOPKDPL) = *ZERO
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOPKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     MCWAOPKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRWAOPKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPKDNR <> *BLANK
     C                   MOVEL(P)  DSWAOPKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   IF        WKFENR = *ZERO
     C                             OR %SCAN(WCTRD:DSWAOPKDNR) <> *ZERO          "*"-FUNKTION
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
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
     C     MCWAOPLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPLDNR    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOPLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LDNR                                                   ***
     C**************************************************************************
     C     PRWAOPLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPLDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPLDNR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOPLDNR) = *ZERO
     C                   MOVEA(P)  DSWAOPLDNR    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXWAOPLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     MCWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPTENR    KOM(01)
     C                   MOVE      '0117'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOPTENR <> *BLANK
     C                   MOVEL(P)  DSWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   IF        WKFENR = *ZERO
     C                             OR %SCAN(WCTRD:DSWAOPTENR) <> *ZERO          "*"-FUNKTION
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     MCTEILPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSTEILPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEILPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     PRTEILPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEILPRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEILPRGR
     C*-------------------------------------------------------------------------
     C                   IF        DSTEILPRGR <> *BLANK
     C                             AND %SCAN(WCTRD:DSTEILPRGR) = *ZERO          "*"-Funktion
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSTEILPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEILPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE JAHR                                                   ***
     C**************************************************************************
     C     PRWAOPJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPJAHR    IFNE      *ZERO
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOPJAHR    EXDATEJAHR
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
     C                   EXSR      WAOPKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     MCWAOPLO
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
     C                   EXSR      CCWAOPKY
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
     C                   EXSR      OCWAOPKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOPKY                                             ***
     C**************************************************************************
     C     OCWAOPKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOP   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOPKY SCROLL CURSOR FOR SQWAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOPKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI WAOP                                               ***
     C**************************************************************************
     C     WAOPKY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     12            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C/EXEC SQL
     C+ FETCH CURRENT FROM WAOPKY INTO :WAOP
     C/END-EXEC
     C                   Z-ADD     WKRENO        RCDNBR                         ZURÜCKSCHR.
     C                   ELSE
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM WAOPKY INTO :WAOP
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
     C                   MOVEL(P)  WAOPPLAT      KYWAOPPLAT
     C                   MOVEL(P)  WAOPWKNR      KYWAOPWKNR
     C                   MOVEL(P)  WAOPKSTC      KYWAOPKSTC
     C                   MOVEL(P)  WAOPKDGR      KYWAOPKDGR
     C                   MOVEL(P)  WAOPKDPL      KYWAOPKDPL
     C                   MOVEL(P)  WAOPKDNR      KYWAOPKDNR
     C                   MOVEL(P)  WAOPLDNR      KYWAOPLDNR
     C                   MOVEL(P)  WAOPTENR      KYWAOPTENR
     C                   Z-ADD     WAOPJAHR      KYWAOPJAHR
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
     C                   WRITE     MCWAOPR1
     C                   EXSR      UXMCWRTE
     C*
     C/EXEC SQL
     C+ FETCH NEXT FROM WAOPKY INTO :WAOP
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
     C***  CLOSE CURSOR DATEI WAOPKY                                         ***
     C**************************************************************************
     C     CCWAOPKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOPKY
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
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  WAOPKSTC      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOPKSTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  WAOPKDGR      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOPKDGR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  WAOPKDPL      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFWAOPKDPL
     C*-------------------------------------------------------------------------
     C*MG                MOVEL(P)  WAOPKDNR      KYKDNR
     C                   MOVEL(P)  WAOPSTKD      KYKDNR
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
     C                   MOVEL(P)  WAOPTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  TEPRGR        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFTEILPRGR
     C*-------------------------------------------------------------------------
     C* Ermitteln Kostenestelle aus KD-Stamm Erweiterung oder aus Anwendungs-Code
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOPKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  WAOPKDNR      KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWKSST      SFTRTPKSST
     C     WAOPKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  WAOPKDPL      KYTPTC
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
     C                   MOVEL(P)  WAOPSTKD      KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWKSST      SFTRTPKSST
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
     C* Ermitteln Daten aus Erhöhungstabelle
     C*-------------------------------------------------------------------------
     C                   MOVEL     WAOPKSTC      KYWAOKKSTC
     C                   MOVEL     WAOPKDGR      KYWAOKKDGR
     C                   MOVEL     WAOPKDPL      KYWAOKKDPL
     C                   MOVEL     WAOPKDNR      KYWAOKKDNR
     C                   MOVEL     WAOPLDNR      KYWAOKLDNR
     C                   MOVEL     TEPRGR        KYWAOKPRGR
     C                   Z-ADD     WAOPJAHR      KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*-------------------------------------------------------------------------
     C* Berechnen Mengen-Erhöhung
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOPMG01      SFLMG(01)
     C                   Z-ADD     WAOPMG02      SFLMG(02)
     C                   Z-ADD     WAOPMG03      SFLMG(03)
     C                   Z-ADD     WAOPMG04      SFLMG(04)
     C                   Z-ADD     WAOPMG05      SFLMG(05)
     C                   Z-ADD     WAOPMG06      SFLMG(06)
     C                   Z-ADD     WAOPMG07      SFLMG(07)
     C                   Z-ADD     WAOPMG08      SFLMG(08)
     C                   Z-ADD     WAOPMG09      SFLMG(09)
     C                   Z-ADD     WAOPMG10      SFLMG(10)
     C                   Z-ADD     WAOPMG11      SFLMG(11)
     C                   Z-ADD     WAOPMG12      SFLMG(12)
     C                   XFOOT     SFLMG         DUN112
     C*
     C     WAOPPLMG      SUB       DUN112        SFWAOPMGEH
     C*-------------------------------------------------------------------------
     C* Berechnen Preis-Erhöhung
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOPUM01      SFLUM(01)
     C                   Z-ADD     WAOPUM02      SFLUM(02)
     C                   Z-ADD     WAOPUM03      SFLUM(03)
     C                   Z-ADD     WAOPUM04      SFLUM(04)
     C                   Z-ADD     WAOPUM05      SFLUM(05)
     C                   Z-ADD     WAOPUM06      SFLUM(06)
     C                   Z-ADD     WAOPUM07      SFLUM(07)
     C                   Z-ADD     WAOPUM08      SFLUM(08)
     C                   Z-ADD     WAOPUM09      SFLUM(09)
     C                   Z-ADD     WAOPUM10      SFLUM(10)
     C                   Z-ADD     WAOPUM11      SFLUM(11)
     C                   Z-ADD     WAOPUM12      SFLUM(12)
     C                   XFOOT     SFLUM         DUN112
     C*
     C     WAOPPLUM      SUB       DUN112        SFWAOPPREH
     C*-------------------------------------------------------------------------
     C* Berechnen STK3
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  WAOPPDAV      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C     WAOPSTPR      DIV       WAOPPLMG      DUN113
     C                   ELSE
     C     WAOPSTPR      DIV       TPTNUM        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WAOPSTPR      WHENEQ    *ZERO
     C     WAOPPLUM      SUB       WAOPERTR      SFWAOPSTPR
     C     TPTNUM        WHENEQ    *ZERO
     C                   Z-ADD     WAOPSTPR      SFWAOPSTPR
     C                   OTHER
     C     WAOPPLMG      MULT      DUN113        SFWAOPSTPR
     C     WAOPPLMG      IFLT      *ZERO
     C                   Z-SUB     SFWAOPSTPR    SFWAOPSTPR
     C                   ENDIF
     C                   ENDSL
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
     C     KYWAOP        LOOKUP    SFLWAOP(I1)                            99
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
     C     KYWAOP        LOOKUP    SFLWAOP(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFLWAOP(I1)
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
     C                   WRITE     MCWAOPR1
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
     C***  UPDATE DATEI WAOK                                                 ***
     C**************************************************************************
     C     TRWAOK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produkt-Gruppe aus Artikel-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYWAOPTENR
     C                   MOVEL(P)  KYWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOK
     C                   MOVEL     *BLANK        EXWAOKPGST
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  '5     '      EXWAOKPGST
     C                   ENDIF
     C                   MOVEL(P)  KYWAOPKSTC    EXWAOKKSTC
     C                   MOVEL(P)  KYWAOPKDGR    EXWAOKKDGR
     C                   MOVEL(P)  KYWAOPKDPL    EXWAOKKDPL
     C                   MOVEL(P)  KYWAOPKDNR    EXWAOKKDNR
     C                   MOVEL(P)  KYWAOPLDNR    EXWAOKLDNR
     C                   MOVEL(P)  TEPRGR        EXWAOKPRGR
     C                   Z-ADD     KYWAOPJAHR    EXWAOKJAHR
     C*
     C                   CALL      'TRWAOK'
     C                   PARM                    EXWAOK
     C                   PARM                    RTWAOK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOM                                                 ***
     C**************************************************************************
     C     TRWAOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produkt-Gruppe aus Artikel-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYWAOPTENR
     C                   MOVEL(P)  KYWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOM
     C                   MOVEL     *BLANK        EXWAOMPGST
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  '5     '      EXWAOMPGST
     C                   ENDIF
     C                   MOVEL(P)  KYWAOPKSTC    EXWAOMKSTC
     C                   MOVEL(P)  KYWAOPKDGR    EXWAOMKDGR
     C                   MOVEL(P)  KYWAOPKDPL    EXWAOMKDPL
     C                   MOVEL(P)  KYWAOPKDNR    EXWAOMKDNR
     C                   MOVEL(P)  KYWAOPLDNR    EXWAOMLDNR
     C                   MOVEL(P)  TEPRGR        EXWAOMPRGR
     C                   Z-ADD     KYWAOPJAHR    EXWAOMJAHR
     C*
     C                   CALL      'TRWAOM'
     C                   PARM                    EXWAOM
     C                   PARM                    RTWAOM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOP                                                 ***
     C**************************************************************************
     C     TRWAOP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOP
     C                   MOVEL(P)  PCPGST        EXWAOPPGST
     C                   MOVEL(P)  KYWAOPPLAT    EXWAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    EXWAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    EXWAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    EXWAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    EXWAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    EXWAOPKDNR
     C                   MOVEL(P)  KYWAOPLDNR    EXWAOPLDNR
     C                   MOVEL(P)  KYWAOPTENR    EXWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    EXWAOPJAHR
     C*
     C                   CALL      'TRWAOP'
     C                   PARM                    EXWAOP
     C                   PARM                    RTWAOP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTWAOPPROG    WKPROG
     C                   MOVEL(P)  RTWAOPDANA    WKDANA
     C                   MOVEL(P)  RTWAOPFFLD    WKFFLD
     C                   MOVEL(P)  RTWAOPFENR    WKFENR
     C                   MOVEL(P)  RTWAOPPA03    W$PA03
     C                   MOVEL(P)  RTWAOPPA04    W$PA04
     C                   MOVEL(P)  RTWAOPPA05    W$PA05
     C                   MOVEL(P)  RTWAOPPA06    W$PA06
     C                   MOVEL(P)  RTWAOPPA07    W$PA07
     C*
     C                   MOVEL(P)  RTWAOPRTCD    #CRTCD
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
     C                   MOVEL(P)  'MCWAOP'      EXSBFLPROG
     C                   MOVEL(P)  'MCWAOPFM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  'WAOP'        EXSBFLFIL1
     C                   MOVEL(P)  WAOP          EXSBFLDAT1
     C*
     C                   MOVEL(P)  'KUND'        EXSBFLFIL2
     C                   MOVEL(P)  KUND          EXSBFLDAT2
     C*
     C                   MOVEL(P)  'TEIL'        EXSBFLFIL3
     C                   MOVEL(P)  TEIL          EXSBFLDAT3
     C*
     C                   MOVEL(P)  'WAOK'        EXSBFLFIL4
     C                   MOVEL(P)  WAOK          EXSBFLDAT4
     C*
     C                   MOVEL(P)  'TXWAOPKSTC'  EXSBFLAF01
     C                   MOVEL(P)  SFWAOPKSTC    EXSBFLAL01
     C*
     C                   MOVEL(P)  'TXWAOPKDGR'  EXSBFLAF02
     C                   MOVEL(P)  SFWAOPKDGR    EXSBFLAL02
     C*
     C                   MOVEL(P)  'TXWAOPKDPL'  EXSBFLAF03
     C                   MOVEL(P)  SFWAOPKDPL    EXSBFLAL03
     C*
     C                   MOVEL(P)  'TXTEILPRGR'  EXSBFLAF04
     C                   MOVEL(P)  SFTEILPRGR    EXSBFLAL04
     C*
     C                   MOVEL(P)  '##KSST'      EXSBFLAF05
     C                   MOVEL(P)  SFTRTPKSST    EXSBFLAL05
     C*
     C                   MOVEL(P)  'TXKDEWKSST'  EXSBFLAF06
     C                   MOVEL(P)  TXTRTPKSST    EXSBFLAL06
     C*
     C                   MOVEL(P)  'TXKUNDKSTC'  EXSBFLAF07
     C                   MOVEL(P)  SFKUNDKSTC    EXSBFLAL07
     C*
     C                   MOVEL(P)  'TXKUNDKDGR'  EXSBFLAF08
     C                   MOVEL(P)  SFKUNDKDGR    EXSBFLAL08
     C*
     C                   MOVEL(P)  '##MGEH'      EXSBFLNF01
     C                   Z-ADD     SFWAOPMGEH    EXSBFLNU01
     C*
     C                   MOVEL(P)  '##PREH'      EXSBFLNF02
     C                   Z-ADD     SFWAOPPREH    EXSBFLNU02
     C*
     C                   MOVEL(P)  '##STPR'      EXSBFLNF03
     C                   Z-ADD     SFWAOPSTPR    EXSBFLNU03
     C*
     C                   EXSR      TRSBFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN ABSATZ-PLAN                                            ***
     C**************************************************************************
     C     T1WAOP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSTEILPRGR    IFEQ      *BLANK
     C                   MOVEL(P)  KYWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   E1WAOP
     C                   MOVEL(P)  KYWAOPPLAT    E1WAOPPLAT
     C                   MOVEL(P)  KYWAOPWKNR    E1WAOPWKNR
     C                   MOVEL(P)  KYWAOPKSTC    E1WAOPKSTC
     C                   MOVEL(P)  KYWAOPKDGR    E1WAOPKDGR
     C                   MOVEL(P)  KYWAOPKDPL    E1WAOPKDPL
     C                   MOVEL(P)  KYWAOPKDNR    E1WAOPKDNR
     C                   MOVEL(P)  DSTEILPRGR    E1WAOPPRGR
     C     DSTEILPRGR    IFEQ      *BLANK
     C                   MOVEL(P)  TEPRGR        E1WAOPPRGR
     C                   ENDIF
     C                   MOVEL(P)  KYWAOPTENR    E1WAOPTENR
     C                   Z-ADD     KYWAOPJAHR    E1WAOPJAHR
     C*
     C                   CALL      'T1WAOP'
     C                   PARM                    E1WAOP
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
     C                   MOVEL(P)  'MCWAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'PLAT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAPLAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MCWAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'WKNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAWKNR
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
     C                   MOVEL(P)  'MCWAOP'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'MCWAOPB1'    EXTRDNPGNA
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'MCWAOPB2'    EXTRDNPGNA
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
     C* Auswahl 10=Optionen
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRWAOK'                                     ERHÖHUNGSTABELLE
     C                   EXSR      TRWAOK
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRWAOM'                                     %-SATZE JAHRESEBENE
     C                   EXSR      TRWAOM
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRWAOP02'                                   MENGEN-VERTEILUNG
     C                   movel     'BILD02'      PCPGST
     C                   EXSR      TRWAOP
     C*
     C                   MOVEL     *ON           WKSUPD
     C*--------------------------------------------------------
     C* F10=Optionen MCWAOPB1
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'T1WAOP'                                     GEN. WAOP-SÄTZE
     C                   EXSR      T1WAOP
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
     C                   EXSR      CHWAOP
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MCWAOPR1                           97
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOPPLAT      KYWAOPPLAT
     C                   MOVEL(P)  WAOPWKNR      KYWAOPWKNR
     C                   MOVEL(P)  WAOPKSTC      KYWAOPKSTC
     C                   MOVEL(P)  WAOPKDGR      KYWAOPKDGR
     C                   MOVEL(P)  WAOPKDPL      KYWAOPKDPL
     C                   MOVEL(P)  WAOPKDNR      KYWAOPKDNR
     C                   MOVEL(P)  WAOPLDNR      KYWAOPLDNR
     C                   MOVEL(P)  WAOPTENR      KYWAOPTENR
     C                   Z-ADD     WAOPJAHR      KYWAOPJAHR
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
     C                   UPDATE    MCWAOPR1                                     MARKIERT LASSEN
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
     C                   EVAL      EXUXMCINAM = 'MCSBFWAOP'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile MCWAOP'
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
     C                   EVAL      UXWAOPFIRM  = KYWAOPFIRM
     C                   EVAL      UXWAOPPLAT  = KYWAOPPLAT
     C                   EVAL      UXWAOPWKNR  = KYWAOPWKNR
     C                   EVAL      UXWAOPKSTC  = KYWAOPKSTC
     C                   EVAL      UXWAOPKDGR  = KYWAOPKDGR
     C                   EVAL      UXWAOPKDPL  = KYWAOPKDPL
     C                   EVAL      UXWAOPKDNR  = KYWAOPKDNR
     C                   EVAL      UXWAOPLDNR  = KYWAOPLDNR
     C                   EVAL      UXWAOPTENR  = KYWAOPTENR
     C                   EVAL      UXWAOPJAHR  = KYWAOPJAHR
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UXWAOP
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
     C                   CLEAR                   KYWAOP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOP)
     C                   EVAL      UXWAOP      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYWAOPFIRM  = UXWAOPFIRM
     C                   EVAL      KYWAOPPLAT  = UXWAOPPLAT
     C                   EVAL      KYWAOPWKNR  = UXWAOPWKNR
     C                   EVAL      KYWAOPKSTC  = UXWAOPKSTC
     C                   EVAL      KYWAOPKDGR  = UXWAOPKDGR
     C                   EVAL      KYWAOPKDPL  = UXWAOPKDPL
     C                   EVAL      KYWAOPKDNR  = UXWAOPKDNR
     C                   EVAL      KYWAOPLDNR  = UXWAOPLDNR
     C                   EVAL      KYWAOPTENR  = UXWAOPTENR
     C                   EVAL      KYWAOPJAHR  = UXWAOPJAHR
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
     C                   EVAL      UXWAOPFIRM  = KYWAOPFIRM
     C                   EVAL      UXWAOPPLAT  = KYWAOPPLAT
     C                   EVAL      UXWAOPWKNR  = KYWAOPWKNR
     C                   EVAL      UXWAOPKSTC  = KYWAOPKSTC
     C                   EVAL      UXWAOPKDGR  = KYWAOPKDGR
     C                   EVAL      UXWAOPKDPL  = KYWAOPKDPL
     C                   EVAL      UXWAOPKDNR  = KYWAOPKDNR
     C                   EVAL      UXWAOPLDNR  = KYWAOPLDNR
     C                   EVAL      UXWAOPTENR  = KYWAOPTENR
     C                   EVAL      UXWAOPJAHR  = KYWAOPJAHR
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXWAOP
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
     C                   EVAL      EXUXDLINAM  = 'DLSBFWAOP'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DLWAOP'
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
     C                   EVAL      UXWAOPFIRM  = KYWAOPFIRM
     C                   EVAL      UXWAOPPLAT  = KYWAOPPLAT
     C                   EVAL      UXWAOPWKNR  = KYWAOPWKNR
     C                   EVAL      UXWAOPKSTC  = KYWAOPKSTC
     C                   EVAL      UXWAOPKDGR  = KYWAOPKDGR
     C                   EVAL      UXWAOPKDPL  = KYWAOPKDPL
     C                   EVAL      UXWAOPKDNR  = KYWAOPKDNR
     C                   EVAL      UXWAOPLDNR  = KYWAOPLDNR
     C                   EVAL      UXWAOPTENR  = KYWAOPTENR
     C                   EVAL      UXWAOPJAHR  = KYWAOPJAHR
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UXWAOP
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
     C                   CLEAR                   KYWAOP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOP)
     C                   EVAL      UXWAOP      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYWAOPFIRM  = UXWAOPFIRM
     C                   EVAL      KYWAOPPLAT  = UXWAOPPLAT
     C                   EVAL      KYWAOPWKNR  = UXWAOPWKNR
     C                   EVAL      KYWAOPKSTC  = UXWAOPKSTC
     C                   EVAL      KYWAOPKDGR  = UXWAOPKDGR
     C                   EVAL      KYWAOPKDPL  = UXWAOPKDPL
     C                   EVAL      KYWAOPKDNR  = UXWAOPKDNR
     C                   EVAL      KYWAOPLDNR  = UXWAOPLDNR
     C                   EVAL      KYWAOPTENR  = UXWAOPTENR
     C                   EVAL      KYWAOPJAHR  = UXWAOPJAHR
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
     C     *LIKE         DEFINE    WKC001        WKTRPAPLAT      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAWKNR      + 2
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPENKY
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SFKUNDKSTC      +39
     C     *LIKE         DEFINE    WKC001        SFKUNDKDGR      +39
     C     *LIKE         DEFINE    WKC001        SFTEILPRGR      +39
     C     *LIKE         DEFINE    WKC001        SFWAOPKSTC      +39
     C     *LIKE         DEFINE    WKC001        SFWAOPKDGR      +39
     C     *LIKE         DEFINE    WKC001        SFWAOPKDPL      +39
     C     *LIKE         DEFINE    WKC001        SFTRTPKSST      + 9
     C     *LIKE         DEFINE    WKC001        TXTRTPKSST      +39
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
     C     *LIKE         DEFINE    KYWAOP        WKWAOP
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOPPLMG      SFWAOPMGEH
     C     *LIKE         DEFINE    WAOPPLUM      SFWAOPPREH
     C     *LIKE         DEFINE    WAOPPLUM      SFWAOPSTPR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKDEW
     C     *LIKE         DEFINE    RTTRSBSQST    RTTRSBKUND
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOPPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOPDANA    WKDANA
     C     *LIKE         DEFINE    RTWAOPFFLD    WKFFLD
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
     C                   MOVEL(P)  'MCWAOP'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     MCWAOPCT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     MCWAOPCT
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
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOK
     C/COPY QCPYSRC,CHWAOP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCLAND
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCWERK
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
