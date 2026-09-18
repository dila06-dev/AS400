     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOK
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 15.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Anderung: MG 29.09.2011 Kundenbesuch, Produktgruppe > '901'ausblenden
     H*  Änderung: MG 10.09.2012 Projekt 8886, Erweiterung des Generierungsformates
     H*            TRWAOK02 um die Felder "Commercial-Division", "Land-Nr"
     H*            Erweiterung der Datei WAOK um das Feld WAOKLDNR "Land-Nr"
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOK.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOKFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D SFLPRGR         S                   DIM(999) INZ LIKE(WAOKPRGR)
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
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
     D WAOK          E DS                  INZ
     D KYWAOK        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
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
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXWAOK        E DS
     D RTWAOK        E DS
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
     C                   PARM                    EXWAOK
     C                   PARM                    RTWAOK
     C*
     C                   EXSR      UEBWAOK
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
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '                                     BILDSCHIRMFORMAT
     C*                                                                         SCHLIESSEN
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRWAOKFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GWAOK '
     C                   MOVE      '02'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOK '
     C                   EXSR      PWAOK
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOK
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOK
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAOKIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOK                                       UPDATE
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     DATEST        WHENEQ    '5'
     C                   MOVE      '5     '      PCPGST
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      TRWAOKFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRWAOKFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOKRTCD
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
     C                   MOVEL(P)  DAFIRM        KYWAOKFIRM                     WAOK
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOKFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOKFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXWAOK                         ***
     C**************************************************************************
     C     UEBWAOK       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXWAOK'      EXDATAFILE
     C                   MOVEL(P)  EXWAOK        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXWAOK
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXWAOKPGST    PCPGST
     C*
     C                   MOVEL(P)  EXWAOKKSTC    KYWAOKKSTC
     C                   MOVEL(P)  EXWAOKKDGR    KYWAOKKDGR
     C                   MOVEL(P)  EXWAOKKDPL    KYWAOKKDPL
     C                   MOVEL(P)  EXWAOKKDNR    KYWAOKKDNR
     C                   MOVEL(P)  EXWAOKLDNR    KYWAOKLDNR
     C                   MOVEL(P)  EXWAOKPRGR    KYWAOKPRGR
     C                   Z-ADD     EXWAOKJAHR    KYWAOKJAHR
     C*
     C                   MOVEL(P)  EXWAOKKSTC    DSWAOKKSTC
     C                   MOVEL(P)  EXWAOKKDGR    DSWAOKKDGR
     C                   MOVEL(P)  EXWAOKKDPL    DSWAOKKDPL
     C                   MOVEL(P)  EXWAOKKDNR    DSWAOKKDNR
     C                   MOVEL(P)  EXWAOKLDNR    DSWAOKLDNR
     C                   MOVEL(P)  EXWAOKPRGR    DSWAOKPRGR
     C                   Z-ADD     EXWAOKJAHR    DSWAOKJAHR
     C*
     C                   MOVEL(P)  EXWAOKNKST    DSWAOKNKST
     C                   MOVEL(P)  EXWAOKNKDG    DSWAOKNKDG
     C                   MOVEL(P)  EXWAOKNKDP    DSWAOKNKDP
     C                   MOVEL(P)  EXWAOKNKDN    DSWAOKNKDN
     C                   MOVEL(P)  EXWAOKNPRG    DSWAOKNPRG
     C                   Z-ADD     EXWAOKNJAH    DSWAOKNJAH
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOK
     C                   MOVEL     *ZERO         RTWAOKFENR
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
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
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
     C                   MOVEL(P)  'TRWAOK'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAOK                                                ***
     C**************************************************************************
     C     KEYWAOK       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM WAOK '  +
     C                             'WHERE WAOKFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        DSWAOKKSTC <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKSTC = ''' + DSWAOKKSTC + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKDGR = ''' + DSWAOKKDGR + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDPL <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKDPL = ''' + DSWAOKKDPL + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKDNR = ''' + DSWAOKKDNR + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKLDNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKLDNR = ''' + DSWAOKLDNR + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKPRGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKPRGR = ''' + DSWAOKPRGR + ''''
     C                   ENDIF
     C*
     C                   IF        DSWAOKJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKJAHR = ' + %CHAR(DSWAOKJAHR)
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG KDEW                                                ***
     C**************************************************************************
     C     KEYKDEW       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT KDEWFIRM, KDEWKDNR, KDEWPLKZ, ' +
     C                             'KDEWKDPL, KDKDGR, KDKSTC, KDLAND ' +
     C                             'FROM KDEW, KUND ' +
     C                             'WHERE KDEWFIRM = ''' + DAFIRM + '''' +
     C                             ' AND   KDEW.KDEWFIRM = KUND.KDFIRM ' +
     C                             ' AND   KDEW.KDEWKDNR = KUND.KDKDNR ' +
     C                             ' AND   KUND.KDKDST < '''+ '90' + ''''
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
     C                   IF        DSWAOKKSTC <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKSTC) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + DSWAOKKSTC + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKSTC) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKSTC)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + DSWAOKKDGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKDGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDPL <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDPL) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKDPL = ''' + DSWAOKKDPL + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KDEW.KDEWKDPL) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDPL)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKDNR = ''' + DSWAOKKDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KDEW.KDEWKDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSLANDGEBT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT LNGEBT FROM LAND ' +
     C                             ' WHERE  LAND.LNLDNR=KUND.KDLAND '
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
     C                   IF        DSWAOKLDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKLDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDLAND = ''' + DSWAOKLDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDLAND) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKLDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' ORDER BY KDEWFIRM, KDEWPLKZ, KDKSTC, ' +
     C                             ' KDKDGR, KDEWKDPL, KDEWKDNR, KDLAND '
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
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
     C                   MOVEL     'TRWAOK01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOK01
     C                   WRITE     TRWAOKB1
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
     C                   READ      TRWAOK01                             9899
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
     C     C#ACCS        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C                   MOVE      *ON           C#WNDW
     C                   ITER
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
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C*
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
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UWAOK
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C     EXWAOKKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKKSTC
     C                   ENDIF
     C     EXWAOKKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKKDGR
     C                   ENDIF
     C     EXWAOKKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKKDPL
     C                   ENDIF
     C     EXWAOKKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKKDNR
     C                   ENDIF
     C     EXWAOKLDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKLDNR
     C                   ENDIF
     C     EXWAOKPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOKPRGR
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYWAOKJAHR
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOK
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOK
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
     C* Setzen Status bei Fremd-Aufruf
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*
     C     WKFENR        IFEQ      *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVEL(P)  '2     '      PCPGST
     C                   ENDIF
     C*
     C     WKFENR        IFNE      *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   WAOK
     C                   EXSR      ETRMU
     C                   EXSR      EWAOK
     C                   MOVEL(P)  KYWAOKKSTC    WAOKKSTC
     C                   MOVEL(P)  KYWAOKKDGR    WAOKKDGR
     C                   MOVEL(P)  KYWAOKKDPL    WAOKKDPL
     C                   MOVEL(P)  KYWAOKKDNR    WAOKKDNR
     C                   MOVEL(P)  KYWAOKLDNR    WAOKLDNR
     C                   MOVEL(P)  KYWAOKPRGR    WAOKPRGR
     C                   Z-ADD     KYWAOKJAHR    WAOKJAHR
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C                   MOVEL(P)  WAOKUSER      WKUSER
     C                   Z-ADD     WAOKJDAT      WKJDAT
     C                   Z-ADD     WAOKJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOK
     C                   EXSR      EWAOK
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOKKSTC      DSWAOKKSTC
     C                   MOVEL(P)  WAOKKDGR      DSWAOKKDGR
     C                   MOVEL(P)  WAOKKDPL      DSWAOKKDPL
     C                   MOVEL(P)  WAOKKDNR      DSWAOKKDNR
     C                   MOVEL(P)  WAOKLDNR      DSWAOKLDNR
     C                   MOVEL(P)  WAOKPRGR      DSWAOKPRGR
     C                   Z-ADD     WAOKJAHR      DSWAOKJAHR
     C*
     C                   Z-ADD     WAOKMGPZ      DSWAOKMGPZ
     C                   Z-ADD     WAOKPRPZ      DSWAOKPRPZ
     C                   MOVEL(P)  WAOKSTKD      DSWAOKSTKD
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAOKKSTC                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOKKDGR                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAOKKDPL
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   MOVEL     *BLANK        TXWAOKLDNR
     C                   MOVEL     *BLANK        TXWAOKPRGR
     C*-------------------------------------------------------------------------
     C     DSWAOKKSTC    CASNE     *BLANK        PRWAOKKSTC                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOKKDGR    CASNE     *BLANK        PRWAOKKDGR
     C                   ENDCS
     C     DSWAOKKDPL    CASNE     *BLANK        PRWAOKKDPL
     C                   ENDCS
     C     DSWAOKKDNR    CASNE     *BLANK        PRWAOKKDNR
     C                   ENDCS
     C     DSWAOKLDNR    CASNE     *BLANK        PRWAOKLDNR
     C                   ENDCS
     C     DSWAOKPRGR    CASNE     *BLANK        PRWAOKPRGR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOK01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
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
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOKMGPZ'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOKMGPZ'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     WAOKKSTC      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOKKSTC'  EXFLPOFLDN
     C     WAOKPRGR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOKPRGR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOKMGPZ'  EXFLPOFLDN
     C                   ENDSL
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
     C***  STEUERROUTINE BILD02                                              ***
     C**************************************************************************
     C     BILD02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B02DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '02'
     C                   MOVEL     'TRWAOK02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOKW3
     C                   WRITE     TRWAOK02
     C                   WRITE     W3WAOKB1
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
     C                   READ      TRWAOK02                             9899
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
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      GWAOK
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOKRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 02                                        ***
     C**************************************************************************
     C     B02DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXWAOKKSST    DSKDEWKSST
     C                   MOVEL(P)  EXWAOKGEBT    DSLANDGEBT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSWAOKJAHR
     C                   Z-ADD     *ZERO         DSWAOKMGPZ
     C                   Z-ADD     *ZERO         DSWAOKPRPZ
     C*-------------------------------------------------------------------------
     C     DSWAOKLOKZ    IFEQ      *BLANK
     C                   MOVEL(P)  'TRWAOK'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'LOKZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        DSWAOKLOKZ
     C                   ELSE
     C                   MOVE      DANEKZ        DSWAOKLOKZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXKDEWKSST                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOKKSTC                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAOKKDGR
     C                   MOVEL     *BLANK        TXWAOKKDPL
     C                   MOVEL     *BLANK        TXLANDGEBT
     C                   MOVEL     *BLANK        TXWAOKLDNR
     C                   MOVEL     *BLANK        TXWAOKPRGR
     C                   MOVEL     *BLANK        TXWAOKLOKZ
     C*-------------------------------------------------------------------------
     C     DSKDEWKSST    CASNE     *BLANK        PRKDEWKSST                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOKKSTC    CASNE     *BLANK        PRWAOKKSTC
     C                   ENDCS
     C     DSWAOKKDGR    CASNE     *BLANK        PRWAOKKDGR
     C                   ENDCS
     C     DSWAOKKDPL    CASNE     *BLANK        PRWAOKKDPL
     C                   ENDCS
     C     DSLANDGEBT    CASNE     *BLANK        PRLANDGEBT
     C                   ENDCS
     C     DSWAOKLDNR    CASNE     *BLANK        PRWAOKLDNR
     C                   ENDCS
     C     DSWAOKPRGR    CASNE     *BLANK        PRWAOKPRGR
     C                   ENDCS
     C     DSWAOKLOKZ    CASNE     *BLANK        PRWAOKLOKZ
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDK1                                              ***
     C**************************************************************************
     C     BILDK1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BK1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'K1'
     C                   MOVEL     'TRWAOKK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOKK1
     C                   WRITE     TRWAOKB1
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
     C                   READ      TRWAOKK1                             9899
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
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KWAOK
     C*                  EXSR      UWAOK
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAOKKSTC    RTWAOKKSTC
     C                   MOVEL(P)  KYWAOKKDGR    RTWAOKKDGR
     C                   MOVEL(P)  KYWAOKKDPL    RTWAOKKDPL
     C                   MOVEL(P)  KYWAOKKDNR    RTWAOKKDNR
     C                   MOVEL(P)  KYWAOKLDNR    RTWAOKLDNR
     C                   MOVEL(P)  KYWAOKPRGR    RTWAOKPRGR
     C                   Z-ADD     KYWAOKJAHR    RTWAOKJAHR
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOKRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT K1                                        ***
     C**************************************************************************
     C     BK1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOKKSTC    DSWAOKKSTC
     C                   MOVEL(P)  KYWAOKKDGR    DSWAOKKDGR
     C                   MOVEL(P)  KYWAOKKDPL    DSWAOKKDPL
     C                   MOVEL(P)  KYWAOKKDNR    DSWAOKKDNR
     C                   MOVEL(P)  KYWAOKLDNR    DSWAOKLDNR
     C                   MOVEL(P)  KYWAOKPRGR    DSWAOKPRGR
     C                   Z-ADD     KYWAOKJAHR    DSWAOKJAHR
     C*
     C                   MOVEL(P)  KYWAOKKSTC    DSWAOKNKST
     C                   MOVEL(P)  KYWAOKKDGR    DSWAOKNKDG
     C                   MOVEL(P)  KYWAOKKDPL    DSWAOKNKDP
     C                   MOVEL(P)  KYWAOKKDNR    DSWAOKNKDN
     C                   MOVEL(P)  KYWAOKLDNR    DSWAOKNLDN
     C                   MOVEL     *BLANK        DSWAOKNPRG
     C                   Z-ADD     *ZERO         DSWAOKNJAH
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNPRG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
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
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKKSTC'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKKDGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKKDPL'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKLDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOKPRGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOKKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKKSTC'
     C                   EXSR      MCWAOKKSTC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKKDGR'
     C                   EXSR      MCWAOKKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKKDPL'
     C                   EXSR      MCWAOKKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKKDNR'
     C                   EXSR      MCWAOKKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKLDNR'
     C                   EXSR      MCWAOKLDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKPRGR'
     C                   EXSR      MCWAOKPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKLOKZ'
     C                   EXSR      MCWAOKLOKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNKST'
     C                   EXSR      MCWAOKNKST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNKDG'
     C                   EXSR      MCWAOKNKDG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNKDP'
     C                   EXSR      MCWAOKNKDP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNKDN'
     C                   EXSR      MCWAOKNKDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNLDN'
     C                   EXSR      MCWAOKNLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOKNPRG'
     C                   EXSR      MCWAOKNPRG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      MCKDEWKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      MCLANDGEBT
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR FORMATE                                         ***
     C**************************************************************************
     C     BILDPR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEA     EXFLPOFLDA    FLD
     C*-------------------------------------------------------------------------
     C     1             DO        100           FL
     C*-------------------------------------------------------------------------
     C     FLD(FL)       IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     FLD(FL)       FLDNAM
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*----------------------------------------------------------
     C                   SELECT
     C     EXFLPOKZIO    WHENEQ    *OFF
     C*
     C     FLDNAM        WHENEQ    'DSWAOKKSTC'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKKSTC
     C     FLDNAM        WHENEQ    'DSWAOKKDGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKKDGR
     C     FLDNAM        WHENEQ    'DSWAOKKDPL'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKKDPL
     C     FLDNAM        WHENEQ    'DSWAOKKDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKKDNR
     C     FLDNAM        WHENEQ    'DSWAOKLDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKLDNR
     C     FLDNAM        WHENEQ    'DSWAOKPRGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKPRGR
     C     FLDNAM        WHENEQ    'DSWAOKJAHR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOKJAHR
     C     FLDNAM        WHENEQ    'DSWAOKMGPZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOKMGPZ
     C     FLDNAM        WHENEQ    'DSWAOKPRPZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOKPRPZ
     C     FLDNAM        WHENEQ    'DSWAOKLOKZ'
     C                   EXSR      PRWAOKLOKZ
     C     FLDNAM        WHENEQ    'DSWAOKNKST'
     C                   EXSR      PRWAOKNKST
     C     FLDNAM        WHENEQ    'DSWAOKNKDG'
     C                   EXSR      PRWAOKNKDG
     C     FLDNAM        WHENEQ    'DSWAOKNKDP'
     C                   EXSR      PRWAOKNKDP
     C     FLDNAM        WHENEQ    'DSWAOKNKDN'
     C                   EXSR      PRWAOKNKDN
     C     FLDNAM        WHENEQ    'DSWAOKNLDN'
     C                   EXSR      PRWAOKNLDN
     C     FLDNAM        WHENEQ    'DSWAOKNPRG'
     C                   EXSR      PRWAOKNPRG
     C     FLDNAM        WHENEQ    'DSWAOKNJAH'
     C                   EXSR      PRWAOKNJAH
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      PRKDEWKSST
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      PRLANDGEBT
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    '3     '
     C                   MOVEL(P)  DSWAOKNKST    KYWAOKKSTC
     C                   MOVEL(P)  DSWAOKNKDG    KYWAOKKDGR
     C                   MOVEL(P)  DSWAOKNKDP    KYWAOKKDPL
     C                   MOVEL(P)  DSWAOKNKDN    KYWAOKKDNR
     C                   MOVEL(P)  DSWAOKNLDN    KYWAOKLDNR
     C                   MOVEL(P)  DSWAOKNPRG    KYWAOKPRGR
     C                   Z-ADD     DSWAOKNJAH    KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOKNKST'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  DSWAOKKSTC    KYWAOKKSTC
     C                   MOVEL(P)  DSWAOKKDGR    KYWAOKKDGR
     C                   MOVEL(P)  DSWAOKKDPL    KYWAOKKDPL
     C                   MOVEL(P)  DSWAOKKDNR    KYWAOKKDNR
     C                   MOVEL(P)  DSWAOKLDNR    KYWAOKLDNR
     C                   MOVEL(P)  DSWAOKPRGR    KYWAOKPRGR
     C                   Z-ADD     DSWAOKJAHR    KYWAOKJAHR
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAOKKSTC    KYWAOKKSTC
     C                   MOVEL(P)  DSWAOKKDGR    KYWAOKKDGR
     C                   MOVEL(P)  DSWAOKKDPL    KYWAOKKDPL
     C                   MOVEL(P)  DSWAOKKDNR    KYWAOKKDNR
     C                   MOVEL(P)  DSWAOKLDNR    KYWAOKLDNR
     C                   MOVEL(P)  DSWAOKPRGR    KYWAOKPRGR
     C                   Z-ADD     DSWAOKJAHR    KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOKKSTC'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOKKSTC'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDSL
     C*----------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRMU                                                 ***
     C**************************************************************************
     C     UTRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOK'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOK          TRMUDATA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TRMUJNAM
     C                   MOVEL(P)  WKCHPN        TRMUPROG
     C                   MOVEL(P)  WKCHPL        TRMUBIBL
     C                   MOVEL(P)  DAUSER        TRMUUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TRMUJZEI
     C                   MOVE      WKTDAT        TRMUJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'W'           #CRTCD
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'U'           #CRTCD
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN WAOK-SÄTZE                                             ***
     C**************************************************************************
     C     GWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Löschen WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     DSWAOKLOKZ    IFEQ      DAJNKZ
     C*--------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'DELETE FROM WAOK '  +
     C                             'WHERE WAOKFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        DSKDEWKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             '     WHERE KDEW.KDEWFIRM=WAOK.WAOKFIRM ' +
     C                             '     AND   KDEW.KDEWKDNR=WAOK.WAOKSTKD '
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
     C                   IF        DSWAOKKSTC <> *BLANK OR DSWAOKKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOK.WAOKFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOK.WAOKSTKD '
     C*
     C                   IF        DSWAOKKSTC <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKSTC) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + DSWAOKKSTC + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKSTC) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKSTC)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + DSWAOKKDGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(KUND.KDKDGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDPL <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDPL) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKDPL = ''' + DSWAOKKDPL + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOKKDPL) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDPL)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKKDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKKDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKKDNR = ''' + DSWAOKKDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOKKDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKKDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSLANDGEBT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT LNGEBT FROM LAND ' +
     C                             ' WHERE  LAND.LNLDNR=WAOK.WAOKLDNR '
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
     C                   IF        DSWAOKLDNR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKLDNR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKLDNR = ''' + DSWAOKLDNR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOKLDNR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKLDNR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKPRGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKPRGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKPRGR = ''' + DSWAOKPRGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(WAOKPRGR) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKPRGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        DSWAOKJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOKJAHR = ' + %CHAR(DSWAOKJAHR)
     C                   ENDIF
     C*--------------------------------------------------------
     C/EXEC SQL
     C+  EXECUTE IMMEDIATE:WKSTMT
     C/END-EXEC
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Füllen Feldgruppe SFLPRGR
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRTPPRGR
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYKDEW
     C*--------------------------------------------------------
     C                   EXSR      OCKDEWKY
     C                   EXSR      KDEWKY
     C                   EXSR      CCKDEWKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOPIEREN SÄTZE AUS DATEI WAOK                                     ***
     C**************************************************************************
     C     KWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOK
     C*-------------------------------------------------------------------------
     C                   EXSR      OCWAOKKY
     C                   EXSR      WAOKKY
     C                   EXSR      CCWAOKKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOK-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOKKSTC    OFWAOKKSTC
     C                   MOVEL(P)  KYWAOKKDGR    OFWAOKKDGR
     C                   MOVEL(P)  KYWAOKKDPL    OFWAOKKDPL
     C                   MOVEL(P)  KYWAOKKDNR    OFWAOKKDNR
     C                   MOVEL(P)  KYWAOKLDNR    OFWAOKLDNR
     C                   MOVEL(P)  KYWAOKPRGR    OFWAOKPRGR
     C                   Z-ADD     KYWAOKJAHR    OFWAOKJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOK
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOKFIRM      ANDEQ     KYWAOKFIRM
     C     WAOKKSTC      ANDLE     OFWAOKKSTC
     C     WAOKKDGR      ANDLE     OFWAOKKDGR
     C     WAOKKDPL      ANDLE     OFWAOKKDPL
     C     WAOKKDNR      ANDLE     OFWAOKKDNR
     C     WAOKLDNR      ANDLE     OFWAOKLDNR
     C     WAOKPRGR      ANDLE     OFWAOKPRGR
     C     WAOKJAHR      ANDLE     OFWAOKJAHR
     C*--------------------------------------------------------
     C     WAOKLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOKLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOK
     C                   MOVEL(P)  WKPROG        RTWAOKPROG
     C                   MOVEL(P)  WKDANA        RTWAOKDANA
     C                   MOVEL(P)  WKFFLD        RTWAOKFFLD
     C                   MOVEL(P)  WKFENR        RTWAOKFENR
     C                   MOVEL(P)  W$PA03        RTWAOKPA03
     C                   MOVEL(P)  W$PA04        RTWAOKPA04
     C                   MOVEL(P)  W$PA05        RTWAOKPA05
     C                   MOVEL(P)  W$PA06        RTWAOKPA06
     C                   MOVEL(P)  W$PA07        RTWAOKPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOK                                          ***
     C**************************************************************************
     C     LWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOKKSTC    OFWAOKKSTC
     C                   MOVEL(P)  KYWAOKKDGR    OFWAOKKDGR
     C                   MOVEL(P)  KYWAOKKDPL    OFWAOKKDPL
     C                   MOVEL(P)  KYWAOKKDNR    OFWAOKKDNR
     C                   MOVEL(P)  KYWAOKLDNR    OFWAOKLDNR
     C                   MOVEL(P)  KYWAOKPRGR    OFWAOKPRGR
     C                   Z-ADD     KYWAOKJAHR    OFWAOKJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOK
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOKFIRM      ANDEQ     KYWAOKFIRM
     C     WAOKKSTC      ANDLE     OFWAOKKSTC
     C     WAOKKDGR      ANDLE     OFWAOKKDGR
     C     WAOKKDPL      ANDLE     OFWAOKKDPL
     C     WAOKKDNR      ANDLE     OFWAOKKDNR
     C     WAOKLDNR      ANDLE     OFWAOKLDNR
     C     WAOKPRGR      ANDLE     OFWAOKPRGR
     C     WAOKJAHR      ANDLE     OFWAOKJAHR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAOKKSTC      KYWAOKKSTC
     C                   MOVEL(P)  WAOKKDGR      KYWAOKKDGR
     C                   MOVEL(P)  WAOKKDPL      KYWAOKKDPL
     C                   MOVEL(P)  WAOKKDNR      KYWAOKKDNR
     C                   MOVEL(P)  WAOKLDNR      KYWAOKLDNR
     C                   MOVEL(P)  WAOKPRGR      KYWAOKPRGR
     C                   Z-ADD     WAOKJAHR      KYWAOKJAHR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOK
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOK
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOK
     C                   MOVEL(P)  WKPROG        RTWAOKPROG
     C                   MOVEL(P)  WKDANA        RTWAOKDANA
     C                   MOVEL(P)  WKFFLD        RTWAOKFFLD
     C                   MOVEL(P)  WKFENR        RTWAOKFENR
     C                   MOVEL(P)  W$PA03        RTWAOKPA03
     C                   MOVEL(P)  W$PA04        RTWAOKPA04
     C                   MOVEL(P)  W$PA05        RTWAOKPA05
     C                   MOVEL(P)  W$PA06        RTWAOKPA06
     C                   MOVEL(P)  W$PA07        RTWAOKPA07
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
     C***  PRÜFEN DATEI-FELDER                                               ***
     C**************************************************************************
     C     PRAUFR        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXWAOKMGPZ    DSWAOKMGPZ
     C                   Z-ADD     EXWAOKPRPZ    DSWAOKPRPZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXWAOKFLDN    WHENEQ    'WAOKMGPZ'
     C                   EXSR      PRWAOKMGPZ
     C     EXWAOKFLDN    WHENEQ    'WAOKPRPZ'
     C                   EXSR      PRWAOKPRPZ
     C                   OTHER
     C                   MOVEL     'TRWAOK01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOK
     C                   MOVEL(P)  WKPROG        RTWAOKPROG
     C                   MOVEL(P)  WKDANA        RTWAOKDANA
     C                   MOVEL(P)  WKFFLD        RTWAOKFFLD
     C                   MOVEL(P)  WKFENR        RTWAOKFENR
     C                   MOVEL(P)  W$PA03        RTWAOKPA03
     C                   MOVEL(P)  W$PA04        RTWAOKPA04
     C                   MOVEL(P)  W$PA05        RTWAOKPA05
     C                   MOVEL(P)  W$PA06        RTWAOKPA06
     C                   MOVEL(P)  W$PA07        RTWAOKPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAOKIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAOKKSTC    KYWAOKKSTC
     C                   MOVEL(P)  EXWAOKKDGR    KYWAOKKDGR
     C                   MOVEL(P)  EXWAOKKDPL    KYWAOKKDPL
     C                   MOVEL(P)  EXWAOKKDNR    KYWAOKKDNR
     C                   MOVEL(P)  EXWAOKLDNR    KYWAOKLDNR
     C                   MOVEL(P)  EXWAOKPRGR    KYWAOKPRGR
     C                   Z-ADD     EXWAOKJAHR    KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*
     C     EXWAOKMGPZ    IFNE      *ZERO
     C                   Z-ADD     EXWAOKMGPZ    DSWAOKMGPZ
     C                   ENDIF
     C*
     C     EXWAOKPRPZ    IFNE      *ZERO
     C                   Z-ADD     EXWAOKPRPZ    DSWAOKPRPZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOK01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAOK
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOK
     C                   MOVEL(P)  WKPROG        RTWAOKPROG
     C                   MOVEL(P)  WKDANA        RTWAOKDANA
     C                   MOVEL(P)  WKFFLD        RTWAOKFFLD
     C                   MOVEL(P)  WKFENR        RTWAOKFENR
     C                   MOVEL(P)  W$PA03        RTWAOKPA03
     C                   MOVEL(P)  W$PA04        RTWAOKPA04
     C                   MOVEL(P)  W$PA05        RTWAOKPA05
     C                   MOVEL(P)  W$PA06        RTWAOKPA06
     C                   MOVEL(P)  W$PA07        RTWAOKPA07
     C*-------------------------------------------------------------------------
     C     K#WAOKLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOK                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOK                                                 ***
     C**************************************************************************
     C     UWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOKKSTC    KYWAOKKSTC
     C                   MOVEL(P)  DSWAOKKDGR    KYWAOKKDGR
     C                   MOVEL(P)  DSWAOKKDPL    KYWAOKKDPL
     C                   MOVEL(P)  DSWAOKKDNR    KYWAOKKDNR
     C                   MOVEL(P)  DSWAOKLDNR    KYWAOKLDNR
     C                   MOVEL(P)  DSWAOKPRGR    KYWAOKPRGR
     C                   Z-ADD     DSWAOKJAHR    KYWAOKJAHR
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAOKNKST    KYWAOKKSTC
     C     DSWAOKNKST    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKKSTC    KYWAOKKSTC
     C                   ENDIF
     C                   MOVE(P)   DSWAOKNKDG    KYWAOKKDGR
     C     DSWAOKNKDG    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKKDGR    KYWAOKKDGR
     C                   ENDIF
     C                   MOVE(P)   DSWAOKNKDP    KYWAOKKDPL
     C     DSWAOKNKDP    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKKDPL    KYWAOKKDPL
     C                   ENDIF
     C                   MOVE(P)   DSWAOKNKDN    KYWAOKKDNR
     C     DSWAOKNKDN    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKKDNR    KYWAOKKDNR
     C                   ENDIF
     C                   MOVE(P)   DSWAOKNLDN    KYWAOKLDNR
     C     DSWAOKNLDN    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKLDNR    KYWAOKLDNR
     C                   ENDIF
     C                   MOVE(P)   DSWAOKNPRG    KYWAOKPRGR
     C     DSWAOKNPRG    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOKPRGR    KYWAOKPRGR
     C                   ENDIF
     C                   Z-ADD     DSWAOKNJAH    KYWAOKJAHR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOK
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOKMGPZ    WAOKMGPZ
     C                   Z-ADD     DSWAOKPRPZ    WAOKPRPZ
     C                   MOVEL(P)  DSWAOKSTKD    WAOKSTKD
     C*--------------------------------------------------------
     C                   SELECT
     C     WAOKKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  '4'           WAOKPLKZ
     C     WAOKKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  '3'           WAOKPLKZ
     C     WAOKKDGR      WHENNE    *BLANK
     C                   MOVEL(P)  '2'           WAOKPLKZ
     C     WAOKKSTC      WHENNE    *BLANK
     C                   MOVEL(P)  '1'           WAOKPLKZ
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOKJNAM
     C                   MOVEL(P)  DAPROG        WAOKPROG
     C                   MOVEL(P)  WKCHPL        WAOKBIBL
     C                   MOVEL(P)  DAUSER        WAOKUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOKJZEI
     C                   MOVE      WKTDAT        WAOKJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOK
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOK
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C* WAOK-Sätze beim generieren nicht überschreiben
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C     PCPGST        ANDEQ     'GWAOK '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOK
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOK
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOKKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOKKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOKKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKKSTC
     C                   MOVEL(P)  TPTTXT        TXWAOKKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE                                     ***
     C**************************************************************************
     C     PRWAOKKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKKSTC = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKKSTC) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOKKSTC    ANDEQ     *BLANK
     C     DSWAOKNKST    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Prüfen Kunden-Steuerungs-Code (WAECO Vertriebsbereich)
     C*-------------------------------------------------------------------------
     C     DSWAOKKSTC    IFNE      *BLANK
     C     DSWAOKKDGR    OREQ      *BLANK
     C     DSWAOKKDPL    ANDEQ     *BLANK
     C     DSWAOKKDNR    ANDEQ     *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOKKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOKKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOKKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOKKDGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKKDGR
     C                   MOVEL(P)  TPTTXT        TXWAOKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE                                              ***
     C**************************************************************************
     C     PRWAOKKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOKKDGR
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKKDGR = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKKDGR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOKKDGR    ANDEQ     *BLANK
     C     DSWAOKNKDG    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOKKDGR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOKKSTC    IFNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOKKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOKKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOKKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOKKDPL    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKKDPL
     C                   MOVEL(P)  TPTTXT        TXWAOKKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG                                             ***
     C**************************************************************************
     C     PRWAOKKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOKKDPL
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKKDPL = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKKDPL) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOKKDPL    ANDEQ     *BLANK
     C     DSWAOKNKDP    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOKKDPL    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOKKSTC    IFNE      *BLANK
     C     DSWAOKKDGR    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOKKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOKKDPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOKKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      DSWAOKSTKD
     C                   ELSE
     C                   MOVE      '1810'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STAMM                                             ***
     C**************************************************************************
     C     MCWAOKKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOKKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOKKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVEL(P)  KDKSTC        DSWAOKKSTC
     C                   MOVEL(P)  KDKDGR        DSWAOKKDGR
     C*
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWKDPL      DSWAOKKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR                                                  ***
     C**************************************************************************
     C     PRWAOKKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKKDNR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKKDNR = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKKDNR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOKKDNR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOKKSTC    IFNE      *BLANK
     C     DSWAOKKDGR    ORNE      *BLANK
     C     DSWAOKKDPL    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOKKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDKDNR        DSWAOKKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVEL(P)  KDKDNR        DSWAOKSTKD
     C*--------------------------------------------------------
     C* Der Status des Datensatzes lässt eine Bearbeitung nicht zu
     C*--------------------------------------------------------
     C     KDKDST        IFGE      '90'
     C                   MOVE      '0009'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C* Eingabe Kunden-Nr entspricht nicht das Planungskz
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     KDEWPLKZ      IFNE      '4'
     C                   MOVEL(P)  'KDEWPLKZ'    KYTPTA
     C                   MOVEL(P)  KDEWPLKZ      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   EVAL      W$PA03      = %TRIM(TPTCDE)
     C                   EVAL      W$PA04      = %SUBST(TPTTXT:1:10)
     C                   EVAL      W$PA05      = %SUBST(TPTTXT:11:10)
     C                   EVAL      WKFENR      = '0598'
     C                   MOVE      '0598'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LÄNDER-STAMM                                              ***
     C**************************************************************************
     C     MCWAOKLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOKLDNR    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOKLDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LAND-NR                                                    ***
     C**************************************************************************
     C     PRWAOKLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKLDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKLDNR = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKLDNR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOKLDNR    ANDEQ     *BLANK
     C     DSWAOKNLDN    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOKLDNR    IFEQ      *BLANK
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     DSWAOKKDNR    WHENNE    *BLANK
     C                   MOVEL(P)  KDLAND        DSWAOKLDNR
     C*--------------------------------------------------------
     C     DSWAOKKDPL    WHENNE    *BLANK
     C                   MOVEL(P)  DSWAOKKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDLAND        DSWAOKLDNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOKLDNR    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXWAOKLDNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKTGRUPPEN                                           ***
     C**************************************************************************
     C     MCWAOKPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOKPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOKPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKPRGR
     C                   MOVEL(P)  TPTTXT        TXWAOKPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKTGRUPPE                                              ***
     C**************************************************************************
     C     PRWAOKPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKPRGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '02'
     C                             AND DSWAOKPRGR = *BLANK
     C                             OR WKIFMT = '02'
     C                             AND %SCAN(WCTRD:DSWAOKPRGR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOKPRGR    ANDEQ     *BLANK
     C     DSWAOKNPRG    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOKPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOKPRGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR                                                       ***
     C**************************************************************************
     C     PRWAOKJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOKJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGEN-ERHÖHUNG                                            ***
     C**************************************************************************
     C     PRWAOKMGPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKMGPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREIS-ERHÖHUNG                                             ***
     C**************************************************************************
     C     PRWAOKPRPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKPRPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCWAOKLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOKLOKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOKLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOKLOKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOKLOKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOKLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LÖSCHEN (JA/NEIN-KENNZEICHEN)                              ***
     C**************************************************************************
     C     PRWAOKLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKLOKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOKLOKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOKLOKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOKNKST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOKNKST    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKNKST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE (NACH)                              ***
     C**************************************************************************
     C     PRWAOKNKST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNKST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNKST    IFNE      *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOKNKST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOKNKDG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOKNKDG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKNKDG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE (NACH)                                       ***
     C**************************************************************************
     C     PRWAOKNKDG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNKDG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNKDG    IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOKNKDG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOKNKDP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOKNKDP    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKNKDP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG (NACH)                                      ***
     C**************************************************************************
     C     PRWAOKNKDP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNKDP'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNKDP    IFNE      *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOKNKDP    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STAMM                                             ***
     C**************************************************************************
     C     MCWAOKNKDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOKNKDN    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOKNKDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR (NACH)                                           ***
     C**************************************************************************
     C     PRWAOKNKDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNKDN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNKDN    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOKNKDN    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  KDKDNR        DSWAOKNKDN
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LÄNDER-STAMM                                              ***
     C**************************************************************************
     C     MCWAOKNLDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOKNLDN    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOKNLDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LAND-NR (NACH)                                             ***
     C**************************************************************************
     C     PRWAOKNLDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNLDN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNLDN    IFNE      *BLANK
     C                   MOVEA(P)  DSWAOKNLDN    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKTGRUPPEN                                           ***
     C**************************************************************************
     C     MCWAOKNPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOKNPRG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOKNPRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKTGRUPPE (NACH)                                       ***
     C**************************************************************************
     C     PRWAOKNPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNPRG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOKNPRG    IFNE      *BLANK
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOKNPRG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR (NACH)                                                ***
     C**************************************************************************
     C     PRWAOKNJAH    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOKNJAH'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOKNJAH    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
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
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOK'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOK
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOK'        EXDATAFILE
     C                   MOVEL(P)  WAOK          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOK         BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TRWAOK'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PRODUKT-GRUPPEN AUS ANWENDUNGS-CODE                     ***
     C**************************************************************************
     C     ETRTPPRGR     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I0
     C                   MOVE      *BLANK        SFLPRGR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM TRTP ' +
     C                             'WHERE TPFIRM = ''' + DAFIRM + '''' +
     C                             ' AND  TPSPCD = ''' + DASPCD + '''' +
     C                             ' AND  TPTART = ''' + 'PRGR' + ''''
     C*
     C                   IF        DSWAOKPRGR <> *BLANK
     C                   IF        %SCAN(WCTRD:DSWAOKPRGR) = *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TPTCDE = ''' + DSWAOKPRGR + ''''
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND TRIM(TPTCDE) LIKE ''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSWAOKPRGR)) + ''''
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQTRTP   FROM :WKSTMT
     C/END-EXEC
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TRTPKY SCROLL CURSOR FOR SQTRTP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN TRTPKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ FETCH TRTPKY INTO :TRTP
     C/END-EXEC
     C*--------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C     I0            IFLT      999
     C     TPTCDE        ANDLE     '901'
     C     TPTFLG        ANDEQ     *ZERO
     C                   ADD       1             I0
     C                   MOVEL(P)  TPTCDE        SFLPRGR(I0)
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE TRTPKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR KDEWKY                                             ***
     C**************************************************************************
     C     OCKDEWKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQKDEW FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE KDEWKY SCROLL CURSOR FOR SQKDEW
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN KDEWKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN SÄTZE DATEI KDEW                                      ***
     C**************************************************************************
     C     KDEWKY        BEGSR
     C*
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOK
     C                   MOVEL(P)  DAFIRM        KYWAOKFIRM
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM KDEWKY INTO :KDEWFIRM, :KDEWKDNR, :KDEWPLKZ, :KDEWKDPL,
     C+  :KDKDGR, :KDKSTC, :KDLAND
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*-------------------------------------------------------------------------
     C* Füllen Schlüssel-Felder gemäss Planungs-z aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C* Vertriebsbereich
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '1'
     C     KDKSTC        ANDNE     *BLANK
     C                   MOVEL(P)  KDKSTC        DSWAOKKSTC
     C                   MOVE      *BLANK        DSWAOKKDGR
     C                   MOVE      *BLANK        DSWAOKKDPL
     C                   MOVE      *BLANK        DSWAOKKDNR
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '2'
     C     KDKDGR        ANDNE     *BLANK
     C                   MOVEL(P)  *BLANK        DSWAOKKSTC
     C                   MOVEL(P)  KDKDGR        DSWAOKKDGR
     C                   MOVE      *BLANK        DSWAOKKDPL
     C                   MOVE      *BLANK        DSWAOKKDNR
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe/Kundenplanung
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '3'
     C     KDEWKDPL      ANDNE     *BLANK
     C                   MOVEL(P)  *BLANK        DSWAOKKSTC
     C                   MOVEL(P)  *BLANK        DSWAOKKDGR
     C                   MOVEL(P)  KDEWKDPL      DSWAOKKDPL
     C                   MOVE      *BLANK        DSWAOKKDNR
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe/Kundenplanung/Kunde
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL(P)  *BLANK        DSWAOKKSTC
     C                   MOVEL(P)  *BLANK        DSWAOKKDGR
     C                   MOVEL(P)  *BLANK        DSWAOKKDPL
     C                   MOVEL(P)  KDEWKDNR      DSWAOKKDNR
     C*--------------------------------------------------------
     C* keine Bearbeitung
     C*--------------------------------------------------------
     C                   OTHER
     C                   ITER
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C* Datensatz wurde bereits erstellt
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDLAND        DSWAOKLDNR
     C*
     C     DSWAOKKSTC    IFEQ      KYWAOKKSTC
     C     DSWAOKKDGR    ANDEQ     KYWAOKKDGR
     C     DSWAOKKDPL    ANDEQ     KYWAOKKDPL
     C     DSWAOKKDNR    ANDEQ     KYWAOKKDNR
     C     DSWAOKLDNR    ANDEQ     KYWAOKLDNR
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Plausiprüfung
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEWKDNR      DSWAOKSTKD
     C                   MOVEL(P)  SFLPRGR(01)   DSWAOKPRGR
     C*
     C                   MOVEL     'TRWAOK01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Generieren WAOK-Sätze
     C*-------------------------------------------------------------------------
     C     1             DO        999           I0
     C*
     C     SFLPRGR(I0)   IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  SFLPRGR(I0)   DSWAOKPRGR
     C                   EXSR      UWAOK
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI KDEWKY                                         ***
     C**************************************************************************
     C     CCKDEWKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE KDEWKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOKKY                                             ***
     C**************************************************************************
     C     OCWAOKKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOK FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOKKY SCROLL CURSOR FOR SQWAOK
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOKKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN SÄTZE DATEI WAOK                                      ***
     C**************************************************************************
     C     WAOKKY        BEGSR
     C*
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM WAOKKY INTO :WAOK
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C                   MOVEL(P)  WAOKKSTC      DSWAOKKSTC
     C                   MOVEL(P)  WAOKKDGR      DSWAOKKDGR
     C                   MOVEL(P)  WAOKKDPL      DSWAOKKDPL
     C                   MOVEL(P)  WAOKKDNR      DSWAOKKDNR
     C                   MOVEL(P)  WAOKLDNR      DSWAOKLDNR
     C                   MOVEL(P)  WAOKPRGR      DSWAOKPRGR
     C                   Z-ADD     WAOKJAHR      DSWAOKJAHR
     C                   Z-ADD     WAOKMGPZ      DSWAOKMGPZ
     C                   Z-ADD     WAOKPRPZ      DSWAOKPRPZ
     C                   MOVEL(P)  WAOKSTKD      DSWAOKSTKD
     C*
     C                   EXSR      UWAOK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI WAOKKY                                         ***
     C**************************************************************************
     C     CCWAOKKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOKKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFE                                                          ***
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
     C                   MOVEL(P)  WKPGST        EXTRDNPGST
     C                   MOVEL(P)  'TRWAOK'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAOKB1'    EXTRDNPGNA
     C                   MOVE      C#FUKT        EXTRDNFUKT                     F-TASTEN
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
     C     EXTRDNDANA    WHENEQ    'XXXX'
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     EXTRDNPGST    IFEQ      'DIREKT'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     EXTRDNPGST    IFEQ      'WEITER'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#ACCS        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        #CRTCD
     C                   ENDDO
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
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        FL              + 3
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
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYWAOKKSTC    UFWAOKKSTC
     C     *LIKE         DEFINE    KYWAOKKSTC    OFWAOKKSTC
     C*
     C     *LIKE         DEFINE    KYWAOKKDGR    UFWAOKKDGR
     C     *LIKE         DEFINE    KYWAOKKDGR    OFWAOKKDGR
     C*
     C     *LIKE         DEFINE    KYWAOKKDPL    UFWAOKKDPL
     C     *LIKE         DEFINE    KYWAOKKDPL    OFWAOKKDPL
     C*
     C     *LIKE         DEFINE    KYWAOKKDNR    UFWAOKKDNR
     C     *LIKE         DEFINE    KYWAOKKDNR    OFWAOKKDNR
     C*
     C     *LIKE         DEFINE    KYWAOKLDNR    UFWAOKLDNR
     C     *LIKE         DEFINE    KYWAOKLDNR    OFWAOKLDNR
     C*
     C     *LIKE         DEFINE    KYWAOKPRGR    UFWAOKPRGR
     C     *LIKE         DEFINE    KYWAOKPRGR    OFWAOKPRGR
     C*
     C     *LIKE         DEFINE    KYWAOKJAHR    OFWAOKJAHR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOKSTKD      DSWAOKSTKD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTWAOKPROG    WKPROG
     C     *LIKE         DEFINE    RTWAOKDANA    WKDANA
     C     *LIKE         DEFINE    RTWAOKFFLD    WKFFLD
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
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3
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
     C                   MOVEL(P)  'TRWAOK'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOKCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOKCT
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
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOK
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCLAND
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRLANDLAND
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
