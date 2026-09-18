     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE MC-Routine für Datei WAOO
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 23.01.2012 Projekt 7558 DOMETIC
     H*  -----------------------------------------------------------------------
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei WAOO.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KYWAOOLGJJ LG-Zugang-Jahr
     F*  KOM(05) = KYWAOOLGNR LG-Zugang-Nr
     F*  KOM(11) = KYWAOOLGPO LG-Zugang-Pos
     F*  KOM(16) = DSWAOOFBNR Fab-Nr
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMCWAOOFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(MCWAOOR1:RCDNBR)
     F                                     SFILE(DLWAOOR1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D E1SBFL        E DS                  INZ
     D*
     D SFLWAOO         S                   LIKE(KYWAOO) DIM(999) DESCEND
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
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D WAOO          E DS
     D KYWAOO        E DS                  INZ
     D UXWAOO        E DS                  INZ
     D*
     D FEPA          E DS                  INZ
     D KYFEPA        E DS                  INZ
     D*
     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ
     D*
     D LGPA          E DS                  INZ
     D KYLGPA        E DS                  INZ
     D*
     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ
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
     D EXTXST        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
     D*
     D EXWAOO        E DS                  INZ
     D RTWAOO        E DS                  INZ
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
     C                   EXSR      KEYWAOO
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
     C                   OPEN      MCWAOOFM
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
     C                   CLEAR                   WAOO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     MCWAOOFM
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
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYWAOOFIRM                     WAOO
     C                   MOVEL(P)  DAFIRM        KYFEPAFIRM                     FEPA
     C                   MOVEL(P)  DAFIRM        KYLGKOFIRM                     LGKO
     C                   MOVEL(P)  DAFIRM        KYLGPAFIRM                     LGPA
     C                   MOVEL(P)  DAFIRM        KYLGPOFIRM                     LGPO
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
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
     C                   MOVEL(P)  'MCWAOO'      EXTRDNDANA
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
     C                   MOVEA     *BLANK        SFLWAOO
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
     C                   MOVEL(P)  'MCWAOOFM'    EXFLPOFMTN
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
     C                   MOVEA     *BLANK        SFLWAOO
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
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        DSWAOOLGJJ
     C*
     C                   MOVEA(P)  KOM(05)       DSWAOOLGNR
     C*
     C                   MOVEA(P)  KOM(11)       DUC005
     C                   TESTN                   DUC005               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC005
     C                   ENDIF
     C                   Z-ADD     DUN050        DSWAOOLGPO
     C*
     C                   MOVEA(P)  KOM(16)       DSWAOOFBNR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C     WKPGST        ANDNE     'DETAIL'
     C                   MOVE      '0547'        #CUEBE
     C     #CUEBE        WHENEQ    *BLANK
     C                   MOVE      '0577'        #CUEBE
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
     C     WKPGST        IFNE      *BLANK
     C     WKPGST        ANDNE     '5     '
     C     DSWAOOLGJJ    ORNE      *ZERO
     C     DSWAOOLGNR    ANDNE     *BLANK
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKINEU
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAOO                                                ***
     C**************************************************************************
     C     KEYWAOO       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Bei jedem Anzeigeprogramm ist festzulegen, nach welchen Kriterien die
     C* Daten angezeigt werden sollen. Dementsprechend sind die Key-Felder zu füllen.
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM WAOO '  +
     C                             'WHERE WAOOFIRM = ''' + DAFIRM + ''''
     C*
     C     DSWAOOLGJJ    IFNE      *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOOLGJJ = ' + %CHAR(DSWAOOLGJJ)
     C                   ENDIF
     C*
     C     DSWAOOLGNR    IFNE      *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOOLGNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOOLGNR) = ''' +
     C                             %TRIM(DSWAOOLGNR) + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOOLGNR) LIKE ''' +
     C                             %TRIM(%XLATE(WCTRD:WCSQL:DSWAOOLGNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C     DSWAOOLGPO    IFNE      *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOOLGPO = ' + %CHAR(DSWAOOLGPO)
     C                   ENDIF
     C*
     C     DSWAOOFBNR    IFNE      *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOOFBNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOOFBNR) = ''' +
     C                             %TRIM(DSWAOOFBNR) + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND UCASE(TRIM(WAOOFBNR)) +
     C                             LIKE UCASE(''' +
     C                             %TRIM(%XLATE(WCTRD:WCSQL:DSWAOOFBNR))+ ''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY WAOOFIRM, WAOOLGJJ DESC, ' +
     C                             'WAOOLGNR DESC, WAOOLGPO, WAOOFBNR, WAOOTSTP'
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
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
     C                   WRITE     MCWAOO01
     C                   WRITE     MCWAOOK1
     C                   EXSR      OFFUKT
     C**                 MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C**                 MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   SELECT
     C     WKPGST        WHENEQ    '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   WRITE     MCWAOOB2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C**                 MOVE      *ON           FUKT20
     C**                 MOVE      *ON           FUKT24
     C                   WRITE     MCWAOOB1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     MCWAOOB3
     C                   ENDSL
     C*--------------------------------------------------------
     C                   SELECT
     C     WKILER        WHENEQ    *ON
     C     WKINEU        ANDEQ     *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOO
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVEL     *BLANK        PCPGST
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL     DSWAOOFBNR    KYWAOOFBNR
     C                   CLEAR                   KYWAOOTSTP
     C                   EXSR      TRWAOO
     C*
     C     #CRTCD        IFEQ      'N'                                          F12 GEDRÜCKT
     C     WKFENR        ORNE      *ZERO                                        FEHLER
     C                   MOVE      *OFF          WKINEU
     C                   LEAVE
     C                   ENDIF
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          WKINEU
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      MCWAOOK1                             9899
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
     C                   MOVEA     *BLANK        SFLWAOO
     C                   MOVEA     *BLANK        SFLAUSW
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#NEWR        WHENEQ    *ON
     C     FUKT06        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLWAOO
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      *BLANK        PCPGST
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL     DSWAOOFBNR    KYWAOOFBNR
     C                   CLEAR                   KYWAOOTSTP
     C                   EXSR      TRWAOO
     C*
     C     #CRTCD        IFEQ      'N'
     C                   MOVE      *OFF          WKINEU
     C                   ELSE
     C                   MOVE      *ON           WKINEU
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL     DSWAOOFBNR    KYWAOOFBNR
     C                   CLEAR                   KYWAOOTSTP
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
     C                   MOVEA     *BLANK        SFLWAOO
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
     C                   MOVEA     *BLANK        SFLWAOO
     C                   MOVEA     *BLANK        SFLAUSW
     C                   MOVE      'MUSTER'      PCPGST
     C                   Z-ADD     *ZERO         KYWAOOLGJJ
     C                   MOVEL     *BLANK        KYWAOOLGNR
     C                   MOVEL     *ZERO         KYWAOOLGPO
     C                   CLEAR                   KYWAOOFBNR
     C                   CLEAR                   KYWAOOTSTP
     C                   EXSR      TRWAOO
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
     C                   Z-ADD     DSWAOOLGJJ    KYWAOOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYWAOOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYWAOOLGPO
     C                   MOVEL     DSWAOOFBNR    KYWAOOFBNR
     C                   CLEAR                   KYWAOOTSTP
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
     C                   WRITE     MCWAOOK1
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
     C                   EXSR      WAOOKY
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
     C     RCDNBR        CHAIN     MCWAOOR1                           97
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
     C                   UPDATE    MCWAOOR1
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
     C                   MOVEL(P)  KYWAOO        WKWAOO
     C                   MOVEA     *BLANK        SFLWAOO
     C                   MOVEA     *BLANK        SFLAUSW
     C*-------------------------------------------------------------------------
     C     *INLR         DOUEQ     *ON
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   KYWAOO
     C                   MOVEL(P)  DAFIRM        KYWAOOFIRM
     C                   READC     MCWAOOR1                               99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON                                          KEIN GEÄNDERTER
     C                   MOVE      'ENDE  '      PCPGST                         SATZ MEHR VORHANDEN,
     C                   EXSR      TRWAOO                                       FORMAT SCHLIESSEN
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
     C                   UPDATE    MCWAOOR1
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEA     KYWAOO        SFLWAOO(I2)
     C                   MOVEA     SFAUSW        SFLAUSW(I2)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWAOO        KYWAOO
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
     C                   READC     MCWAOOR1                               99
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
     C                   UPDATE    MCWAOOR1
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
     C                   MOVEL(P)  KYWAOO        WKWAOO
     C*--------------------------------------------------------
     C     WKIDEL        IFEQ      *OFF
     C                   MOVE      'DL'          WKIFMT
     C                   EXSR      BILDDL
     C                   MOVEL(P)  WKWAOO        KYWAOO
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
     C                   EXSR      TRWAOO
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
     C                   EXSR      TRWAOO
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
     C     RCDNBR        CHAIN     MCWAOOR1                           97
     C                   MOVE      *BLANK        SFAUSW
     C                   UPDATE    MCWAOOR1
     C                   EXSR      LAUSW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '1     '
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     RCDNBR        ANDGT     *ZERO
     C     RCDNBR        CHAIN     MCWAOOR1                           97
     C                   MOVE      *ON           C_AUSW
     C                   MOVE      *ON           C#NEXT
     C                   UPDATE    MCWAOOR1
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
     C                   EXSR      CHWAOO
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
     C                   WRITE     MCWAOO01
     C                   WRITE     DLWAOOK1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C                   WRITE     MCWAOODL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      DLWAOOK1                             9899
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
     C                   WRITE     DLWAOOK1
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
     C                   WRITE     DLWAOOR1
     C                   EXSR      UXDLWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   READC     MCWAOOR1                               99
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
     C                   UPDATE    MCWAOOR1
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
     C     WKRCNO        CHAIN     DLWAOOR1                           97
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
     C                   UPDATE    DLWAOOR1
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
     C                   WRITE     MCWAOOW1
     C                   WRITE     MCWAOOM1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W1WAOOB1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MCWAOOM1                             9899
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
     C                   EXSR      KEYWAOO
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLWAOO
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
     C                   MOVEL(P)  'DSWAOOLGNR'  EXFLPOFLDN
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
     C                   EXSR      PRWAOOLGNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOOLGPO
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
     C                   MOVEL(P)  'DSWAOOLGNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOLGNR'
     C                   EXSR      MCWAOOLGNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOOLGPO'
     C                   EXSR      MCWAOOLGPO
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LGNR                                                   ***
     C**************************************************************************
     C     MCWAOOLGNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSWAOOLGNR    KOM(05)
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   MOVEL(P)  '0535'        #CUEBE
     C                   EXSR      MCLGKO
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   Z-ADD     LGKOLGJJ      DSWAOOLGJJ
     C                   MOVEL(P)  LGKOLGNR      DSWAOOLGNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGNR                                                   ***
     C**************************************************************************
     C     PRWAOOLGNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOLGNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOOLGNR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOOLGNR) = *ZERO
     C*
     C                   Z-ADD     DSWAOOLGJJ    KYLGKOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYLGKOLGNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  LGKOKDNR      DSLGKOKDNR
     C                   MOVEL(P)  DSLGKOKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   MOVEL(P)  LGKORTNR      DSLGKORTNR
     C*
     C                   MOVEL(P)  LGKOLGAT      DSLGKOLGAT
     C                   MOVEL(P)  DSLGKOLGAT    KYLGPALGAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPA
     C                   MOVEL(P)  LGPAABEZ      TXLGKOLGAT
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   MOVEL(P)  LGKOWKNR      DSLGKOWKNR
     C                   MOVEL(P)  DSLGKOWKNR    KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL(P)  WRWKBZ        TXLGKOWKNR
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   MOVEL(P)  LGKOEXBL      DSLGKOEXBL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LGPO                                                   ***
     C**************************************************************************
     C     MCWAOOLGPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOOLGJJ    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSWAOOLGNR    KOM(05)
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   EXSR      MCLGPO
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   Z-ADD     LGPOLGJJ      DSWAOOLGJJ
     C                   MOVEL(P)  LGPOLGNR      DSWAOOLGNR
     C                   Z-ADD     LGPOLGPO      DSWAOOLGPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGPO                                                   ***
     C**************************************************************************
     C     PRWAOOLGPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOOLGPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSWAOOLGPO <> *ZERO AND DSWAOOLGJJ <> *ZERO
     C                             AND DSWAOOLGNR <> *BLANK
     C                             AND %SCAN(WCTRD:DSWAOOLGNR) = *ZERO
     C                   Z-ADD     DSWAOOLGJJ    KYLGPOLGJJ
     C                   MOVEL(P)  DSWAOOLGNR    KYLGPOLGNR
     C                   Z-ADD     DSWAOOLGPO    KYLGPOLGPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRARTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX53'      EXTTTCDE
     C                   MOVEL     'MCFEAR'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     WAOOFEAR      EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     WKPGST        OREQ      '5     '
     C     BSK(02)       ORNE      'J'
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRUSTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX54'      EXTTTCDE
     C                   MOVEL     'MCWAOO'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     WAOOFEUS      EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     WKPGST        OREQ      '5     '
     C     BSK(02)       ORNE      'J'
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRBMTXST  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX55'      EXTTTCDE
     C                   MOVEL     'MCFEBM'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL     WAOOFEBM      EXTTUCDE
     C                   MOVEL     DASPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     #CPGST        SAVPGST
     C                   MOVEL     *BLANK        #CPGST
     C*
     C     DATEST        IFNE      *BLANK
     C     WKPGST        OREQ      '5     '
     C     BSK(02)       ORNE      'J'
     C                   MOVEL     '5     '      #CPGST
     C                   ENDIF
     C*
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEL     SAVPGST       #CPGST
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
     C                   EXSR      WAOOKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   WRITE     MCWAOOLO
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
     C                   EXSR      CCWAOOKY
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
     C                   EXSR      OCWAOOKY
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOOKY                                             ***
     C**************************************************************************
     C     OCWAOOKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOO FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOOKY SCROLL CURSOR FOR SQWAOO
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOOKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI WAOO                                               ***
     C**************************************************************************
     C     WAOOKY        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SFAUSW
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C                   Z-ADD     10            W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C     C#PGUP        IFEQ      *ON
     C/EXEC SQL
     C+ FETCH CURRENT FROM WAOOKY INTO :WAOO
     C/END-EXEC
     C                   Z-ADD     WKRENO        RCDNBR                         ZURÜCKSCHR.
     C                   ELSE
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM WAOOKY INTO :WAOO
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
     C                   Z-ADD     WAOOLGJJ      KYWAOOLGJJ
     C                   MOVEL(P)  WAOOLGNR      KYWAOOLGNR
     C                   Z-ADD     WAOOLGPO      KYWAOOLGPO
     C                   MOVE      WAOOFBNR      KYWAOOFBNR
     C                   MOVE      WAOOTSTP      KYWAOOTSTP
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
     C                   WRITE     MCWAOOR1
     C                   EXSR      UXMCWRTE
     C*
     C/EXEC SQL
     C+ FETCH NEXT FROM WAOOKY INTO :WAOO
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
     C***  CLOSE CURSOR DATEI WAOOKY                                         ***
     C**************************************************************************
     C     CCWAOOKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKOPENKY
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOOKY
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
     C                   MOVEL     *BLANK        SFWAOOLGNR
     C     WAOOLGJJ      IFNE      *ZERO
     C                   MOVEL     WAOOLGJJ      SFWAOOLGNR
     C                   ENDIF
     C                   MOVE      WAOOLGNR      SFWAOOLGNR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOOLGJJ      KYLGPOLGJJ
     C                   MOVEL(P)  WAOOLGNR      KYLGPOLGNR
     C                   Z-ADD     WAOOLGPO      KYLGPOLGPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LGPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  LGPOMEIN      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFLGPOMEIN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT    '    EXTTPGCD
     C                   MOVEL(P)  *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRARTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C                   MOVEL(P)  TXKEIN        TXARTXTEXT
     C                   ELSE
     C                   MOVEL(P)  EXTTTEXT      TXARTXTEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT    '    EXTTPGCD
     C                   MOVEL(P)  *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRUSTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C                   MOVEL(P)  TXKEIN        TXUSTXTEXT
     C                   ELSE
     C                   MOVEL(P)  EXTTTEXT      TXUSTXTEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEXT    '    EXTTPGCD
     C                   MOVEL(P)  *BLANK        EXTTDSPF
     C                   EXSR      MCAUFRBMTXST
     C*
     C     EXTTTEXT      IFEQ      *BLANK
     C                   MOVEL(P)  TXKEIN        TXBMTXTEXT
     C                   ELSE
     C                   MOVEL(P)  EXTTTEXT      TXBMTXTEXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     WAOOFEAT      KYFEPAFEAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHFEPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'PERG'        KYTPTA
     C                   MOVEL     WAOOPERG      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOOPERG
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
     C                   EVAL      EXUXS1JV = RTSBFLMCUZ
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *ON
     C                   EVAL      EXUXS2JV = RTSBFLMCUZ
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
     C     KYWAOO        LOOKUP    SFLWAOO(I1)                            99
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
     C     KYWAOO        LOOKUP    SFLWAOO(I1)                            99
     C*--------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      *BLANK        SFLAUSW(I1)
     C                   MOVE      *BLANK        SFLWAOO(I1)
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
     C                   WRITE     MCWAOOR1
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
     C***  UPDATE DATEI WAOO                                                 ***
     C**************************************************************************
     C     TRWAOO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOO
     C                   MOVEL(P)  PCPGST        EXWAOOPGST
     C                   Z-ADD     KYWAOOLGJJ    EXWAOOLGJJ
     C                   MOVEL(P)  KYWAOOLGNR    EXWAOOLGNR
     C                   Z-ADD     KYWAOOLGPO    EXWAOOLGPO
     C                   MOVE      KYWAOOFBNR    EXWAOOFBNR
     C                   MOVE      KYWAOOTSTP    EXWAOOTSTP
     C*
     C                   CALL      'TRWAOO'
     C                   PARM                    EXWAOO
     C                   PARM                    RTWAOO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTWAOOPROG    WKPROG
     C                   MOVEL(P)  RTWAOODANA    WKDANA
     C                   MOVEL(P)  RTWAOOFFLD    WKFFLD
     C                   MOVEL(P)  RTWAOOFENR    WKFENR
     C                   MOVEL(P)  RTWAOOPA03    W$PA03
     C                   MOVEL(P)  RTWAOOPA04    W$PA04
     C                   MOVEL(P)  RTWAOOPA05    W$PA05
     C                   MOVEL(P)  RTWAOOPA06    W$PA06
     C                   MOVEL(P)  RTWAOOPA07    W$PA07
     C*
     C                   MOVEL(P)  RTWAOORTCD    #CRTCD
     C
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF SUBFILE-ZEILEN-ERMITTLUNG                                  ***
     C**************************************************************************
     C     TRAUFRSBFL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   E1SBFL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSBFL
     C                   MOVEL(P)  'MCWAOO'      EXSBFLPROG
     C                   MOVEL(P)  'MCWAOOFM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  'WAOO'        EXSBFLFIL1
     C                   EVAL      EXSBFLDAT1 = WAOO
     C*
     C                   MOVEL(P)  'LGPO'        EXSBFLFIL2
     C                   EVAL      EXSBFLDAT2 = LGPO
     C*
     C                   MOVEL(P)  'TEIL'        EXSBFLFIL3
     C                   EVAL      EXSBFLDAT3 = TEIL
     C*
     C                   MOVEL(P)  'FEPA'        EXSBFLFIL4
     C                   EVAL      EXSBFLDAT4 = FEPA
     C*
     C                   MOVEL(P)  '##LGNR'      EXSBFLAF01
     C                   MOVEL(P)  SFWAOOLGNR    EXSBFLAL01
     C*
     C                   MOVEL(P)  'TXLGPOMEIN'  EXSBFLAF02
     C                   MOVEL(P)  SFLGPOMEIN    EXSBFLAL02
     C*
     C                   MOVEL(P)  'TXWAOOPERG'  EXSBFLAF03
     C                   MOVEL(P)  TXWAOOPERG    EXSBFLAL03
     C*
     C                   MOVEL(P)  'TXARTXTEXT'  EXSBFLAF04
     C                   MOVEL(P)  TXARTXTEXT    EXSBFLAL04
     C*
     C                   MOVEL(P)  'TXUSTXTEXT'  EXSBFLAF05
     C                   MOVEL(P)  TXUSTXTEXT    EXSBFLAL05
     C*
     C                   MOVEL(P)  'TXBMTXTEXT'  EXSBFLAF06
     C                   MOVEL(P)  TXBMTXTEXT    EXSBFLAL06
     C*
     C                   EXSR      TRSBFL
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
     C                   MOVEL(P)  'MCWAOO'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C     SFAUSW        IFEQ      *BLANK                                       F10=OPTIONEN
     C                   MOVEL(P)  'MCWAOOB1'    EXTRDNPGNA
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'MCWAOOB2'    EXTRDNPGNA
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
     C                   EXSR      CHWAOO
     C*-------------------------------------------------------------------------
     C     RCDNBR        CHAIN     MCWAOOR1                           97
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOOLGJJ      KYWAOOLGJJ
     C                   MOVEL(P)  WAOOLGNR      KYWAOOLGNR
     C                   Z-ADD     WAOOLGPO      KYWAOOLGPO
     C                   MOVE      WAOOFBNR      KYWAOOFBNR
     C                   MOVE      WAOOTSTP      KYWAOOTSTP
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
     C                   UPDATE    MCWAOOR1                                     MARKIERT LASSEN
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
     C                   EVAL      EXUXMCINAM = 'MCSBFWAOO'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile MCWAOO'
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
     C                   EVAL      UXWAOOFIRM  = KYWAOOFIRM
     C                   EVAL      UXWAOOLGJJ  = KYWAOOLGJJ
     C                   EVAL      UXWAOOLGNR  = KYWAOOLGNR
     C                   EVAL      UXWAOOLGPO  = KYWAOOLGPO
     C                   EVAL      UXWAOOFBNR  = KYWAOOFBNR
     C                   EVAL      UXWAOOTSTP  = KYWAOOTSTP
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UXWAOO
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
     C                   CLEAR                   KYWAOO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOO)
     C                   EVAL      UXWAOO      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYWAOOFIRM  = UXWAOOFIRM
     C                   EVAL      KYWAOOLGJJ  = UXWAOOLGJJ
     C                   EVAL      KYWAOOLGNR  = UXWAOOLGNR
     C                   EVAL      KYWAOOLGPO  = UXWAOOLGPO
     C                   EVAL      KYWAOOFBNR  = UXWAOOFBNR
     C                   EVAL      KYWAOOTSTP  = UXWAOOTSTP
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
     C                   EVAL      UXWAOOFIRM  = KYWAOOFIRM
     C                   EVAL      UXWAOOLGJJ  = KYWAOOLGJJ
     C                   EVAL      UXWAOOLGNR  = KYWAOOLGNR
     C                   EVAL      UXWAOOLGPO  = KYWAOOLGPO
     C                   EVAL      UXWAOOFBNR  = KYWAOOFBNR
     C                   EVAL      UXWAOOTSTP  = KYWAOOTSTP
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXWAOO
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
     C                   EVAL      EXUXDLINAM  = 'DLSBFWAOO'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DLWAOO'
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
     C                   EVAL      UXWAOOFIRM  = KYWAOOFIRM
     C                   EVAL      UXWAOOLGJJ  = KYWAOOLGJJ
     C                   EVAL      UXWAOOLGNR  = KYWAOOLGNR
     C                   EVAL      UXWAOOLGPO  = KYWAOOLGPO
     C                   EVAL      UXWAOOFBNR  = KYWAOOFBNR
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UXWAOO
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
     C                   CLEAR                   KYWAOO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UXWAOO)
     C                   EVAL      UXWAOO      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYWAOOFIRM  = UXWAOOFIRM
     C                   EVAL      KYWAOOLGJJ  = UXWAOOLGJJ
     C                   EVAL      KYWAOOLGNR  = UXWAOOLGNR
     C                   EVAL      KYWAOOLGPO  = UXWAOOLGPO
     C                   EVAL      KYWAOOFBNR  = UXWAOOFBNR
     C                   EVAL      KYWAOOTSTP  = UXWAOOTSTP
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
     C     *LIKE         DEFINE    WKC001        WKINEU                         IND.NEUANLAGE
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
     C     *LIKE         DEFINE    WKC001        WKINFOWAOO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SFWAOOLGNR      + 9
     C     *LIKE         DEFINE    WKC001        SFLGPOMEIN      +39
     C     *LIKE         DEFINE    WKC001        TXWAOOPERG      +39
     C     *LIKE         DEFINE    WKC001        TXARTXTEXT      +64
     C     *LIKE         DEFINE    WKC001        TXUSTXTEXT      +64
     C     *LIKE         DEFINE    WKC001        TXBMTXTEXT      +64
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
     C     *LIKE         DEFINE    KYWAOO        WKWAOO
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOOPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOODANA    WKDANA
     C     *LIKE         DEFINE    RTWAOOFFLD    WKFFLD
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
     C                   MOVEL(P)  'MCWAOO'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWAOOW1
     C                   OTHER
     C                   WRITE     MCWAOOCT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTWAOOW1
     C                   OTHER
     C                   WRITE     MCWAOOCT
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
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHWAOO
     C/COPY QCPYSRC,CHFEPA
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPA
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRSBFL
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,MCLGKO
     C/COPY QCPYSRC,MCLGPO
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRTX50
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
