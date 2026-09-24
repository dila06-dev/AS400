     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2011')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOM
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 28.08.2011 Projekt 7668, Planungssystem
     H*  -----------------------------------------------------------------------
     H*  Anderung: MG 29.09.2011 Kundenbesuch, Produktgruppe > '900'ausblenden
     H*  Änderung: MG 25.11.2012 Projekt 9103  Vereinfachte Möglichkeit der Veränderung %-Sätze
     H*            Erweiterung der Datei WAOM um die Felder WAOMLDNR, WAOMSTKD
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOM.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAOMFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D SFLMGST         S                   DIM(12) INZ LIKE(VMMGST)
     D SFLPZ           S                   DIM(12) INZ LIKE(WAOMPZ01)
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
     D WAOM          E DS                  INZ
     D KYWAOM        E DS                  INZ
     D*
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
     D TVAM          E DS                  INZ
     D KYTVAM        E DS                  INZ
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
     D EXTRSB        E DS
     D EXTRSBPTR§      S               *
     D RTTRSB        E DS
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXWAOM        E DS
     D RTWAOM        E DS
     D*
     D EXWAOP        E DS                  INZ
     D RTWAOP        E DS                  INZ
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
     D/COPY QCPYSRC,EXUX01
     D*
     D IKEYWAOM        DS           100
     D  IKEYPLKZ                      1    OVERLAY(IKEYWAOM)
     D  IKEYKSTC                      3    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYKDGR                      4    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYKDPL                      4    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYKDNR                     10    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYLDNR                      3    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYPRGR                      4    OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYMONA                      2S 0 OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYJAHR                      4S 0 OVERLAY(IKEYWAOM:*NEXT)
     D  IKEYTSTP                     26Z   OVERLAY(IKEYWAOM:*NEXT)
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
     C                   PARM                    EXWAOM
     C                   PARM                    RTWAOM
     C*
     C                   EXSR      UEBWAOM
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
     C                   CLOSE     TRWAOMFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GWAOM '
     C                   MOVE      '02'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'WAOM03'
     C                   MOVE      '03'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOM '
     C                   EXSR      PWAOM
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOM
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOM
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXWAOMIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFWAOM                                       UPDATE
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
     C                   OPEN      TRWAOMFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRWAOMFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOMRTCD
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
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM                     WAOM
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYVMFI                         TVAM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOMFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAOMFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXWAOM                         ***
     C**************************************************************************
     C     UEBWAOM       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXWAOM'      EXDATAFILE
     C                   MOVEL(P)  EXWAOM        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXWAOM
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXWAOMPGST    PCPGST
     C*
     C                   MOVEL(P)  EXWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  EXWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  EXWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  EXWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  EXWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  EXWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     EXWAOMJAHR    KYWAOMJAHR
     C*
     C                   MOVEL(P)  EXWAOMKSTC    DSWAOMKSTC
     C                   MOVEL(P)  EXWAOMKDGR    DSWAOMKDGR
     C                   MOVEL(P)  EXWAOMKDPL    DSWAOMKDPL
     C                   MOVEL(P)  EXWAOMKDNR    DSWAOMKDNR
     C                   MOVEL(P)  EXWAOMLDNR    DSWAOMLDNR
     C                   MOVEL(P)  EXWAOMPRGR    DSWAOMPRGR
     C                   Z-ADD     EXWAOMJAHR    DSWAOMJAHR
     C*
     C                   MOVEL(P)  EXWAOMNKST    DSWAOMNKST
     C                   MOVEL(P)  EXWAOMNKDG    DSWAOMNKDG
     C                   MOVEL(P)  EXWAOMNKDP    DSWAOMNKDP
     C                   MOVEL(P)  EXWAOMNKDN    DSWAOMNKDN
     C                   MOVEL(P)  EXWAOMNLDN    DSWAOMNLDN
     C                   MOVEL(P)  EXWAOMNPRG    DSWAOMNPRG
     C                   Z-ADD     EXWAOMNJAH    DSWAOMNJAH
     C*
     C                   MOVE      *BLANK        DSKDEWKSST
     C                   MOVE      *BLANK        DSLANDGEBT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOM
     C                   MOVEL     *ZERO         RTWAOMFENR
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
     C                   MOVEL(P)  'TRWAOM'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
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
     C                   MOVEL     'TRWAOM01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOM01
     C                   WRITE     TRWAOMB1
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
     C                   READ      TRWAOM01                             9899
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
     C                   EXSR      UWAOM
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
     C     EXWAOMKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMKSTC
     C                   ENDIF
     C     EXWAOMKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMKDGR
     C                   ENDIF
     C     EXWAOMKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMKDPL
     C                   ENDIF
     C     EXWAOMKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMKDNR
     C                   ENDIF
     C     EXWAOMLDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMLDNR
     C                   ENDIF
     C     EXWAOMPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        KYWAOMPRGR
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYWAOMJAHR
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOM
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOM
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
     C                   EXSR      CHWAOM
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
     C                   CLEAR                   WAOM
     C                   EXSR      ETRMU
     C                   EXSR      EWAOM
     C                   MOVEL(P)  KYWAOMKSTC    WAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    WAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    WAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    WAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    WAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    WAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    WAOMJAHR
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C                   MOVEL(P)  WAOMUSER      WKUSER
     C                   Z-ADD     WAOMJDAT      WKJDAT
     C                   Z-ADD     WAOMJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOM
     C                   EXSR      EWAOM
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOMKSTC      DSWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      DSWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      DSWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      DSWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      DSWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      DSWAOMPRGR
     C                   Z-ADD     WAOMJAHR      DSWAOMJAHR
     C*
     C                   Z-ADD     WAOMPZ01      DSWAOMPZ01
     C                   Z-ADD     WAOMPZ02      DSWAOMPZ02
     C                   Z-ADD     WAOMPZ03      DSWAOMPZ03
     C                   Z-ADD     WAOMPZ04      DSWAOMPZ04
     C                   Z-ADD     WAOMPZ05      DSWAOMPZ05
     C                   Z-ADD     WAOMPZ06      DSWAOMPZ06
     C                   Z-ADD     WAOMPZ07      DSWAOMPZ07
     C                   Z-ADD     WAOMPZ08      DSWAOMPZ08
     C                   Z-ADD     WAOMPZ09      DSWAOMPZ09
     C                   Z-ADD     WAOMPZ10      DSWAOMPZ10
     C                   Z-ADD     WAOMPZ11      DSWAOMPZ11
     C                   Z-ADD     WAOMPZ12      DSWAOMPZ12
     C                   MOVEL(P)  WAOMSTKD      DSWAOMSTKD
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        TXWAOMKSTC                     INITIALISIEREN
     C                   MOVEL     *BLANK        TXWAOMKDGR                     TEXTFELDER
     C                   MOVEL     *BLANK        TXWAOMKDPL
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   MOVEL     *BLANK        TXWAOMLDNR
     C                   MOVEL     *BLANK        TXWAOMPRGR
     C*-------------------------------------------------------------------------
     C     DSWAOMKSTC    CASNE     *BLANK        PRWAOMKSTC                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOMKDGR    CASNE     *BLANK        PRWAOMKDGR
     C                   ENDCS
     C     DSWAOMKDPL    CASNE     *BLANK        PRWAOMKDPL
     C                   ENDCS
     C     DSWAOMKDNR    CASNE     *BLANK        PRWAOMKDNR
     C                   ENDCS
     C     DSWAOMLDNR    CASNE     *BLANK        PRWAOMLDNR
     C                   ENDCS
     C     DSWAOMPRGR    CASNE     *BLANK        PRWAOMPRGR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOM01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAOMPZ01'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAOMPZ01'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     WAOMKSTC      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
     C     WAOMPRGR      WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAOMPRGR'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAOMPZ01'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAOM02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOMW3
     C                   WRITE     TRWAOM02
     C                   WRITE     W3WAOMB1
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
     C                   READ      TRWAOM02                             9899
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
     C                   EXSR      GWAOM
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOMRTCD
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
     C                   Z-ADD     *ZERO         DSTVAMVJHJ
     C                   Z-ADD     *ZERO         DSTVAMVMON
     C                   Z-ADD     *ZERO         DSTVAMBJHJ
     C                   Z-ADD     *ZERO         DSTVAMBMON
     C*
     C                   Z-ADD     *ZERO         DSWAOMJAHR
     C                   Z-ADD     *ZERO         DSWAOMPZ01
     C                   Z-ADD     *ZERO         DSWAOMPZ02
     C                   Z-ADD     *ZERO         DSWAOMPZ03
     C                   Z-ADD     *ZERO         DSWAOMPZ04
     C                   Z-ADD     *ZERO         DSWAOMPZ05
     C                   Z-ADD     *ZERO         DSWAOMPZ06
     C                   Z-ADD     *ZERO         DSWAOMPZ07
     C                   Z-ADD     *ZERO         DSWAOMPZ08
     C                   Z-ADD     *ZERO         DSWAOMPZ09
     C                   Z-ADD     *ZERO         DSWAOMPZ10
     C                   Z-ADD     *ZERO         DSWAOMPZ11
     C                   Z-ADD     *ZERO         DSWAOMPZ12
     C*-------------------------------------------------------------------------
     C     DSWAOMLOKZ    IFEQ      *BLANK
     C                   MOVEL(P)  'TRWAOM'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'LOKZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        DSWAOMLOKZ
     C                   ELSE
     C                   MOVE      DANEKZ        DSWAOMLOKZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXWAOMLOKZ                     INITIALISIEREN
     C*                                                                         TEXTFELDER
     C*-------------------------------------------------------------------------
     C     DSWAOMLOKZ    CASNE     *BLANK        PRWAOMLOKZ                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTVAMVJHJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD03                                              ***
     C**************************************************************************
     C     BILD03        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B03DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '03'
     C                   MOVEL     'TRWAOM03'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOM03
     C                   WRITE     TRWAOMB1
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
     C                   READ      TRWAOM03                             9899
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
     C                   EXSR      KEYWAOM
     C                   EXSR      OCWAOMKY
     C                   EXSR      WAOMKY
     C                   EXSR      CCWAOMKY
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOMRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 03                                        ***
     C**************************************************************************
     C     B03DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C* Übernahme Key-Felder aus Selektionsformat MCWAOMM1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXWAOMKSST    DSKDEWKSST
     C                   MOVEL(P)  *BLANK        DSWAOMKSTC
     C                   MOVEL(P)  *BLANK        DSWAOMKDGR
     C                   MOVEL(P)  EXWAOMKDPL    DSWAOMKDPL
     C                   MOVEL(P)  EXWAOMKDNR    DSWAOMKDNR
     C                   MOVEL(P)  EXWAOMGEBT    DSLANDGEBT
     C                   MOVEL(P)  EXWAOMLDNR    DSWAOMLDNR
     C                   MOVEL(P)  EXWAOMPRGR    DSWAOMPRGR
     C                   Z-ADD     EXWAOMJAHR    DSWAOMJAHR
     C*-------------------------------------------------------------------------
     C* Initialisieren %-Sätze
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSWAOMPZ01
     C                   Z-ADD     *ZERO         DSWAOMPZ02
     C                   Z-ADD     *ZERO         DSWAOMPZ03
     C                   Z-ADD     *ZERO         DSWAOMPZ04
     C                   Z-ADD     *ZERO         DSWAOMPZ05
     C                   Z-ADD     *ZERO         DSWAOMPZ06
     C                   Z-ADD     *ZERO         DSWAOMPZ07
     C                   Z-ADD     *ZERO         DSWAOMPZ08
     C                   Z-ADD     *ZERO         DSWAOMPZ09
     C                   Z-ADD     *ZERO         DSWAOMPZ10
     C                   Z-ADD     *ZERO         DSWAOMPZ11
     C                   Z-ADD     *ZERO         DSWAOMPZ12
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXKDEWKSST                     INITIALISIEREN
     C                   MOVE      *BLANK        TXWAOMKDPL                     TEXTFELDEREREN
     C                   MOVE      *BLANK        DSKUNDKNAM
     C                   MOVE      *BLANK        TXLANDGEBT
     C                   MOVE      *BLANK        TXWAOMLDNR
     C                   MOVE      *BLANK        TXWAOMPRGR
     C*-------------------------------------------------------------------------
     C     DSKDEWKSST    CASNE     *BLANK        PRKDEWKSST                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSWAOMKDPL    CASNE     *BLANK        PRWAOMKDPL
     C                   ENDCS
     C     DSWAOMKDNR    CASNE     *BLANK        PRWAOMKDNR
     C                   ENDCS
     C     DSLANDGEBT    CASNE     *BLANK        PRLANDGEBT
     C                   ENDCS
     C     DSWAOMLDNR    CASNE     *BLANK        PRWAOMLDNR
     C                   ENDCS
     C     DSWAOMPRGR    CASNE     *BLANK        PRWAOMPRGR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMPZ01'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAOMK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAOMK1
     C                   WRITE     TRWAOMB1
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
     C                   READ      TRWAOMK1                             9899
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
     C                   EXSR      KWAOM
     C*                  EXSR      UWAOM
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYWAOMKSTC    RTWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    RTWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    RTWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    RTWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    RTWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    RTWAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    RTWAOMJAHR
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTWAOMRTCD
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
     C                   MOVEL(P)  KYWAOMKSTC    DSWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    DSWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    DSWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    DSWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    DSWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    DSWAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    DSWAOMJAHR
     C*
     C                   MOVEL(P)  KYWAOMKSTC    DSWAOMNKST
     C                   MOVEL(P)  KYWAOMKDGR    DSWAOMNKDG
     C                   MOVEL(P)  KYWAOMKDPL    DSWAOMNKDP
     C                   MOVEL(P)  KYWAOMKDNR    DSWAOMNKDN
     C                   MOVEL(P)  KYWAOMLDNR    DSWAOMNLDN
     C                   MOVEL     *BLANK        DSWAOMNPRG
     C                   Z-ADD     *ZERO         DSWAOMNJAH
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNPRG'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAOMKSTC'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOMKDGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOMKDPL'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOMKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOMLDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAOMPRGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
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
     C     FLDNAM        WHENEQ    'DSWAOMLDNR'
     C                   EXSR      MCWAOMLDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMPRGR'
     C                   EXSR      MCWAOMPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMLOKZ'
     C                   EXSR      MCWAOMLOKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      MCKDEWKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      MCLANDGEBT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNKST'
     C                   EXSR      MCWAOMNKST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNKDG'
     C                   EXSR      MCWAOMNKDG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNKDP'
     C                   EXSR      MCWAOMNKDP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNKDN'
     C                   EXSR      MCWAOMNKDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNLDN'
     C                   EXSR      MCWAOMNLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOMNPRG'
     C                   EXSR      MCWAOMNPRG
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
     C     FLDNAM        WHENEQ    'DSWAOMKSTC'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMKSTC
     C     FLDNAM        WHENEQ    'DSWAOMKDGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMKDGR
     C     FLDNAM        WHENEQ    'DSWAOMKDPL'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMKDPL
     C     FLDNAM        WHENEQ    'DSWAOMKDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMKDNR
     C     FLDNAM        WHENEQ    'DSWAOMLDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMLDNR
     C     FLDNAM        WHENEQ    'DSWAOMPRGR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMPRGR
     C     FLDNAM        WHENEQ    'DSWAOMJAHR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAOMJAHR
     C     FLDNAM        WHENEQ    'DSWAOMPZ01'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRWAOMPZ01
     C     FLDNAM        WHENEQ    'DSTVAMVJHJ'
     C                   EXSR      PRTVAMVJHJ
     C     FLDNAM        WHENEQ    'DSTVAMVMON'
     C                   EXSR      PRTVAMVMON
     C     FLDNAM        WHENEQ    'DSTVAMBJHJ'
     C                   EXSR      PRTVAMBJHJ
     C     FLDNAM        WHENEQ    'DSTVAMBMON'
     C                   EXSR      PRTVAMBMON
     C     FLDNAM        WHENEQ    'DSWAOMLOKZ'
     C                   EXSR      PRWAOMLOKZ
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      PRKDEWKSST
     C     FLDNAM        WHENEQ    'DSLANDGEBT'
     C                   EXSR      PRLANDGEBT
     C     FLDNAM        WHENEQ    'DSWAOMNKST'
     C                   EXSR      PRWAOMNKST
     C     FLDNAM        WHENEQ    'DSWAOMNKDG'
     C                   EXSR      PRWAOMNKDG
     C     FLDNAM        WHENEQ    'DSWAOMNKDP'
     C                   EXSR      PRWAOMNKDP
     C     FLDNAM        WHENEQ    'DSWAOMNKDN'
     C                   EXSR      PRWAOMNKDN
     C     FLDNAM        WHENEQ    'DSWAOMNLDN'
     C                   EXSR      PRWAOMNLDN
     C     FLDNAM        WHENEQ    'DSWAOMNPRG'
     C                   EXSR      PRWAOMNPRG
     C     FLDNAM        WHENEQ    'DSWAOMNJAH'
     C                   EXSR      PRWAOMNJAH
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
     C                   MOVEL(P)  DSWAOMNKST    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMNKDG    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMNKDP    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMNKDN    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMNLDN    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMNPRG    KYWAOMPRGR
     C                   Z-ADD     DSWAOMNJAH    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOMNKST'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     DSWAOMJAHR    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOM'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOM          TRMUDATA
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
     C***  GENERIEREN WAOM-SÄTZE                                             ***
     C**************************************************************************
     C     GWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Löschen WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     DSWAOMLOKZ    IFEQ      DAJNKZ
     C/EXEC SQL
     C+ DELETE FROM WAOM
     C+ WHERE WAOMFIRM = :DAFIRM
     C+ AND   WAOMJAHR = :DSWAOMJAHR
     C/END-EXEC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Generieren WAOM-Sätze
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOM
     C                   MOVEL     DAFIRM        KYWAOM
     C*-------------------------------------------------------------------------
     C* Berechnen %-Säzte anhand Umsatz bzw. Absatz der letzten drei Jahre
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPEN
     C                   EXSR      UXWRTE
     C                   EXSR      UXREAD
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOPIEREN SÄTZE AUS DATEI WAOM                                     ***
     C**************************************************************************
     C     KWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      KEYWAOM
     C*-------------------------------------------------------------------------
     C                   EXSR      OCWAOMKY
     C                   EXSR      WAOMKY
     C                   EXSR      CCWAOMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOM-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOMKSTC    OFWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    OFWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    OFWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    OFWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    OFWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    OFWAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    OFWAOMJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOM
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOMFIRM      ANDEQ     KYWAOMFIRM
     C     WAOMKSTC      ANDLE     OFWAOMKSTC
     C     WAOMKDGR      ANDLE     OFWAOMKDGR
     C     WAOMKDPL      ANDLE     OFWAOMKDPL
     C     WAOMKDNR      ANDLE     OFWAOMKDNR
     C     WAOMLDNR      ANDLE     OFWAOMLDNR
     C     WAOMPRGR      ANDLE     OFWAOMPRGR
     C     WAOMJAHR      ANDLE     OFWAOMJAHR
     C*--------------------------------------------------------
     C     WAOMLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAOMLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOM
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOM
     C                   MOVEL(P)  WKPROG        RTWAOMPROG
     C                   MOVEL(P)  WKDANA        RTWAOMDANA
     C                   MOVEL(P)  WKFFLD        RTWAOMFFLD
     C                   MOVEL(P)  WKFENR        RTWAOMFENR
     C                   MOVEL(P)  W$PA03        RTWAOMPA03
     C                   MOVEL(P)  W$PA04        RTWAOMPA04
     C                   MOVEL(P)  W$PA05        RTWAOMPA05
     C                   MOVEL(P)  W$PA06        RTWAOMPA06
     C                   MOVEL(P)  W$PA07        RTWAOMPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOM                                          ***
     C**************************************************************************
     C     LWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOMKSTC    OFWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    OFWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    OFWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    OFWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    OFWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    OFWAOMPRGR
     C                   Z-ADD     KYWAOMJAHR    OFWAOMJAHR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOM
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAOMFIRM      ANDEQ     KYWAOMFIRM
     C     WAOMKSTC      ANDLE     OFWAOMKSTC
     C     WAOMKDGR      ANDLE     OFWAOMKDGR
     C     WAOMKDPL      ANDLE     OFWAOMKDPL
     C     WAOMKDNR      ANDLE     OFWAOMKDNR
     C     WAOMLDNR      ANDLE     OFWAOMLDNR
     C     WAOMPRGR      ANDLE     OFWAOMPRGR
     C     WAOMJAHR      ANDLE     OFWAOMJAHR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAOMKSTC      KYWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      KYWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      KYWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      KYWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      KYWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      KYWAOMPRGR
     C                   Z-ADD     WAOMJAHR      KYWAOMJAHR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOM
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOM
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOM
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOM
     C                   MOVEL(P)  WKPROG        RTWAOMPROG
     C                   MOVEL(P)  WKDANA        RTWAOMDANA
     C                   MOVEL(P)  WKFFLD        RTWAOMFFLD
     C                   MOVEL(P)  WKFENR        RTWAOMFENR
     C                   MOVEL(P)  W$PA03        RTWAOMPA03
     C                   MOVEL(P)  W$PA04        RTWAOMPA04
     C                   MOVEL(P)  W$PA05        RTWAOMPA05
     C                   MOVEL(P)  W$PA06        RTWAOMPA06
     C                   MOVEL(P)  W$PA07        RTWAOMPA07
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
     C                   Z-ADD     EXWAOMPZ01    DSWAOMPZ01
     C                   Z-ADD     EXWAOMPZ02    DSWAOMPZ02
     C                   Z-ADD     EXWAOMPZ03    DSWAOMPZ03
     C                   Z-ADD     EXWAOMPZ04    DSWAOMPZ04
     C                   Z-ADD     EXWAOMPZ05    DSWAOMPZ05
     C                   Z-ADD     EXWAOMPZ06    DSWAOMPZ06
     C                   Z-ADD     EXWAOMPZ07    DSWAOMPZ07
     C                   Z-ADD     EXWAOMPZ08    DSWAOMPZ08
     C                   Z-ADD     EXWAOMPZ09    DSWAOMPZ09
     C                   Z-ADD     EXWAOMPZ10    DSWAOMPZ10
     C                   Z-ADD     EXWAOMPZ11    DSWAOMPZ11
     C                   Z-ADD     EXWAOMPZ12    DSWAOMPZ12
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXWAOMFLDN    WHENEQ    'WAOMPZ01'
     C                   EXSR      PRWAOMPZ01
     C                   OTHER
     C                   MOVEL     'TRWAOM01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOM
     C                   MOVEL(P)  WKPROG        RTWAOMPROG
     C                   MOVEL(P)  WKDANA        RTWAOMDANA
     C                   MOVEL(P)  WKFFLD        RTWAOMFFLD
     C                   MOVEL(P)  WKFENR        RTWAOMFENR
     C                   MOVEL(P)  W$PA03        RTWAOMPA03
     C                   MOVEL(P)  W$PA04        RTWAOMPA04
     C                   MOVEL(P)  W$PA05        RTWAOMPA05
     C                   MOVEL(P)  W$PA06        RTWAOMPA06
     C                   MOVEL(P)  W$PA07        RTWAOMPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFWAOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXWAOMIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  EXWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  EXWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  EXWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  EXWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  EXWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     EXWAOMJAHR    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
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
     C     EXWAOMPZ01    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ01    DSWAOMPZ01
     C                   ENDIF
     C*
     C     EXWAOMPZ02    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ02    DSWAOMPZ02
     C                   ENDIF
     C*
     C     EXWAOMPZ03    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ03    DSWAOMPZ03
     C                   ENDIF
     C*
     C     EXWAOMPZ04    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ04    DSWAOMPZ04
     C                   ENDIF
     C*
     C     EXWAOMPZ05    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ05    DSWAOMPZ05
     C                   ENDIF
     C*
     C     EXWAOMPZ06    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ06    DSWAOMPZ06
     C                   ENDIF
     C*
     C     EXWAOMPZ07    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ07    DSWAOMPZ07
     C                   ENDIF
     C*
     C     EXWAOMPZ08    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ08    DSWAOMPZ08
     C                   ENDIF
     C*
     C     EXWAOMPZ09    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ09    DSWAOMPZ09
     C                   ENDIF
     C*
     C     EXWAOMPZ10    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ10    DSWAOMPZ10
     C                   ENDIF
     C*
     C     EXWAOMPZ11    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ11    DSWAOMPZ11
     C                   ENDIF
     C*
     C     EXWAOMPZ12    IFNE      *ZERO
     C                   Z-ADD     EXWAOMPZ12    DSWAOMPZ12
     C                   ENDIF
     C*
     C     EXWAOMPGST    IFEQ      'WAOM03'
     C                   Z-ADD     EXWAOMPZ01    DSWAOMPZ01
     C                   Z-ADD     EXWAOMPZ02    DSWAOMPZ02
     C                   Z-ADD     EXWAOMPZ03    DSWAOMPZ03
     C                   Z-ADD     EXWAOMPZ04    DSWAOMPZ04
     C                   Z-ADD     EXWAOMPZ05    DSWAOMPZ05
     C                   Z-ADD     EXWAOMPZ06    DSWAOMPZ06
     C                   Z-ADD     EXWAOMPZ07    DSWAOMPZ07
     C                   Z-ADD     EXWAOMPZ08    DSWAOMPZ08
     C                   Z-ADD     EXWAOMPZ09    DSWAOMPZ09
     C                   Z-ADD     EXWAOMPZ10    DSWAOMPZ10
     C                   Z-ADD     EXWAOMPZ11    DSWAOMPZ11
     C                   Z-ADD     EXWAOMPZ12    DSWAOMPZ12
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRWAOM01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UWAOM
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTWAOM
     C                   MOVEL(P)  WKPROG        RTWAOMPROG
     C                   MOVEL(P)  WKDANA        RTWAOMDANA
     C                   MOVEL(P)  WKFFLD        RTWAOMFFLD
     C                   MOVEL(P)  WKFENR        RTWAOMFENR
     C                   MOVEL(P)  W$PA03        RTWAOMPA03
     C                   MOVEL(P)  W$PA04        RTWAOMPA04
     C                   MOVEL(P)  W$PA05        RTWAOMPA05
     C                   MOVEL(P)  W$PA06        RTWAOMPA06
     C                   MOVEL(P)  W$PA07        RTWAOMPA07
     C*-------------------------------------------------------------------------
     C     K#WAOMLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHWAOM                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOM                                                 ***
     C**************************************************************************
     C     UWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOMKSTC    KYWAOMKSTC
     C                   MOVEL(P)  DSWAOMKDGR    KYWAOMKDGR
     C                   MOVEL(P)  DSWAOMKDPL    KYWAOMKDPL
     C                   MOVEL(P)  DSWAOMKDNR    KYWAOMKDNR
     C                   MOVEL(P)  DSWAOMLDNR    KYWAOMLDNR
     C                   MOVEL(P)  DSWAOMPRGR    KYWAOMPRGR
     C                   Z-ADD     DSWAOMJAHR    KYWAOMJAHR
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAOMNKST    KYWAOMKSTC
     C     DSWAOMNKST    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMKSTC    KYWAOMKSTC
     C                   ENDIF
     C                   MOVE(P)   DSWAOMNKDG    KYWAOMKDGR
     C     DSWAOMNKDG    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMKDGR    KYWAOMKDGR
     C                   ENDIF
     C                   MOVE(P)   DSWAOMNKDP    KYWAOMKDPL
     C     DSWAOMNKDP    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMKDPL    KYWAOMKDPL
     C                   ENDIF
     C                   MOVE(P)   DSWAOMNKDN    KYWAOMKDNR
     C     DSWAOMNKDN    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMKDNR    KYWAOMKDNR
     C                   ENDIF
     C                   MOVE(P)   DSWAOMNLDN    KYWAOMLDNR
     C     DSWAOMNLDN    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMLDNR    KYWAOMLDNR
     C                   ENDIF
     C                   MOVE(P)   DSWAOMNPRG    KYWAOMPRGR
     C     DSWAOMNPRG    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMPRGR    KYWAOMPRGR
     C                   ENDIF
     C                   Z-ADD     DSWAOMNJAH    KYWAOMJAHR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOM
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAOMPZ01    WAOMPZ01
     C                   Z-ADD     DSWAOMPZ02    WAOMPZ02
     C                   Z-ADD     DSWAOMPZ03    WAOMPZ03
     C                   Z-ADD     DSWAOMPZ04    WAOMPZ04
     C                   Z-ADD     DSWAOMPZ05    WAOMPZ05
     C                   Z-ADD     DSWAOMPZ06    WAOMPZ06
     C                   Z-ADD     DSWAOMPZ07    WAOMPZ07
     C                   Z-ADD     DSWAOMPZ08    WAOMPZ08
     C                   Z-ADD     DSWAOMPZ09    WAOMPZ09
     C                   Z-ADD     DSWAOMPZ10    WAOMPZ10
     C                   Z-ADD     DSWAOMPZ11    WAOMPZ11
     C                   Z-ADD     DSWAOMPZ12    WAOMPZ12
     C                   MOVEL(P)  DSWAOMSTKD    WAOMSTKD
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAOMNSTK    WAOMSTKD
     C     DSWAOMNSTK    IFEQ      *BLANK
     C                   MOVE(P)   DSWAOMSTKD    WAOMSTKD
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WAOMKDNR      WHENNE    *BLANK
     C                   MOVEL(P)  '4'           WAOMPLKZ
     C     WAOMKDPL      WHENNE    *BLANK
     C                   MOVEL(P)  '3'           WAOMPLKZ
     C     WAOMKDGR      WHENNE    *BLANK
     C                   MOVEL(P)  '2'           WAOMPLKZ
     C     WAOMKSTC      WHENNE    *BLANK
     C                   MOVEL(P)  '1'           WAOMPLKZ
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAOMJNAM
     C                   MOVEL(P)  DAPROG        WAOMPROG
     C                   MOVEL(P)  WKCHPL        WAOMBIBL
     C                   MOVEL(P)  DAUSER        WAOMUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAOMJZEI
     C                   MOVE      WKTDAT        WAOMJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOM
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOM
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOM
     C*
     C                   EXSR      UPOSI
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DER ABHÄNGIG. SÄTZE                                        ***
     C**************************************************************************
     C     UPOSI         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOP
     C                   MOVEL     'UWAOM '      EXWAOPPGST
     C                   MOVEL     WAOMKSTC      EXWAOPKSTC
     C                   MOVEL     WAOMKDGR      EXWAOPKDGR
     C                   MOVEL     WAOMKDPL      EXWAOPKDPL
     C                   MOVEL     WAOMKDNR      EXWAOPKDNR
     C                   MOVEL     WAOMLDNR      EXWAOPLDNR
     C                   MOVEL     WAOMPRGR      EXWAOPPRGR
     C                   Z-ADD     WAOMJAHR      EXWAOPJAHR
     C*
     C                   CALL      'TRWAOPSB'                                   JOB ÜBERGEBEN
     C                   PARM                    EXWAOP
     C                   PARM                    RTWAOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOMKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOMKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOMKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMKSTC
     C                   MOVEL(P)  TPTTXT        TXWAOMKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE                                     ***
     C**************************************************************************
     C     PRWAOMKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMKSTC    ANDEQ     *BLANK
     C     DSWAOMNKST    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Prüfen Kunden-Steuerungs-Code (WAECO Vertriebsbereich)
     C*-------------------------------------------------------------------------
     C     DSWAOMKSTC    IFNE      *BLANK
     C     DSWAOMKDGR    OREQ      *BLANK
     C     DSWAOMKDPL    ANDEQ     *BLANK
     C     DSWAOMKDNR    ANDEQ     *BLANK
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
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOMKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOMKDGR
     C                   ENDIF
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
     C                   MOVEL(P)  TPTTXT        TXWAOMKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE                                              ***
     C**************************************************************************
     C     PRWAOMKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMKDGR
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMKDGR    ANDEQ     *BLANK
     C     DSWAOMNKDG    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOMKDGR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOMKSTC    IFNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
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
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOMKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOMKDPL
     C                   ENDIF
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
     C                   MOVEL(P)  TPTTXT        TXWAOMKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG                                             ***
     C**************************************************************************
     C     PRWAOMKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOMKDPL
     C*-------------------------------------------------------------------------
     C* Ändern WAOM-Sätze über F10=Optionen
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '03'
     C                             AND DSWAOMKDPL = *BLANK
     C                             OR WKIFMT = '03'
     C                             AND %SCAN(WCTRD:DSWAOMKDPL) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMKDPL    ANDEQ     *BLANK
     C     DSWAOMNKDP    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOMKDPL    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOMKSTC    IFNE      *BLANK
     C     DSWAOMKDGR    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOMKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMKDPL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOMKDPL    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      DSWAOMSTKD
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
     C     MCWAOMKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMKDNR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C                   ENDIF
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
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVEL(P)  KDKSTC        DSWAOMKSTC
     C                   MOVEL(P)  KDKDGR        DSWAOMKDGR
     C*
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWKDPL      DSWAOMKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR                                                  ***
     C**************************************************************************
     C     PRWAOMKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMKDNR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C* Ändern WAOM-Sätze über F10=Optionen
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '03'
     C                             AND DSWAOMKDNR = *BLANK
     C                             OR WKIFMT = '03'
     C                             AND %SCAN(WCTRD:DSWAOMKDNR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMKDNR    ANDEQ     *BLANK
     C     DSWAOMNKDN    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOMKDNR    IFNE      *BLANK
     C*--------------------------------------------------------
     C* Eingabe KD-Steuerung, KD-Gruppe, KD-Planung oder Kunden-Nr
     C*--------------------------------------------------------
     C     DSWAOMKSTC    IFNE      *BLANK
     C     DSWAOMKDGR    ORNE      *BLANK
     C     DSWAOMKDPL    ORNE      *BLANK
     C                   MOVE      '0597'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOMKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDKDNR        DSWAOMKDNR
     C                   MOVEL(P)  KDKNAM        DSKUNDKNAM
     C                   MOVEL(P)  KDKDNR        DSWAOMSTKD
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
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LAND-NR                                                    ***
     C**************************************************************************
     C     PRWAOMLDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMLDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Ändern WAOM-Sätze über F10=Optionen
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '03'
     C                             AND DSWAOMLDNR = *BLANK
     C                             OR WKIFMT = '03'
     C                             AND %SCAN(WCTRD:DSWAOMLDNR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMLDNR    ANDEQ     *BLANK
     C     DSWAOMNLDN    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOMLDNR    IFEQ      *BLANK
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     DSWAOMKDNR    WHENNE    *BLANK
     C                   MOVEL(P)  KDLAND        DSWAOMLDNR
     C*--------------------------------------------------------
     C     DSWAOMKDPL    WHENNE    *BLANK
     C                   MOVEL(P)  DSWAOMKDPL    KYKDEWKDPL
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
     C                   MOVEL(P)  KDLAND        DSWAOMLDNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOMLDNR    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXWAOMLDNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKTGRUPPEN                                           ***
     C**************************************************************************
     C     MCWAOMPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOMPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOMPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMPRGR
     C                   MOVEL(P)  TPTTXT        TXWAOMPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKTGRUPPE                                              ***
     C**************************************************************************
     C     PRWAOMPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMPRGR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C* Ändern WAOM-Sätze über F10=Optionen
     C*-------------------------------------------------------------------------
     C                   IF        WKIFMT = '03'
     C                             AND DSWAOMPRGR = *BLANK
     C                             OR WKIFMT = '03'
     C                             AND %SCAN(WCTRD:DSWAOMPRGR) <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Kopieren alle WAOM-Sätze
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFEQ      'K1'
     C     DSWAOMPRGR    ANDEQ     *BLANK
     C     DSWAOMNPRG    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOMPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOMPRGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR                                                       ***
     C**************************************************************************
     C     PRWAOMJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOMJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGEN-ERHÖHUNG                                            ***
     C**************************************************************************
     C     PRWAOMPZ01    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMPZ01'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMPZ01    ADD       DSWAOMPZ02    DUN052
     C                   ADD       DSWAOMPZ03    DUN052
     C                   ADD       DSWAOMPZ04    DUN052
     C                   ADD       DSWAOMPZ05    DUN052
     C                   ADD       DSWAOMPZ06    DUN052
     C                   ADD       DSWAOMPZ07    DUN052
     C                   ADD       DSWAOMPZ08    DUN052
     C                   ADD       DSWAOMPZ09    DUN052
     C                   ADD       DSWAOMPZ10    DUN052
     C                   ADD       DSWAOMPZ11    DUN052
     C                   ADD       DSWAOMPZ12    DUN052
     C*
     C                   SELECT
     C     DUN052        WHENGT    100
     C                   MOVE      '0066'        WKFENR
     C     DUN052        WHENLT    100
     C                   MOVE      '0067'        WKFENR
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      W$PA03 = %TRIM(%EDITC(DUN052 :
     C                              '4'))
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN UMSATZ JAHR (VON)                                          ***
     C**************************************************************************
     C     PRTVAMVJHJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTVAMVJHJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSTVAMVJHJ    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN UMSATZ MONAT (VON)                                         ***
     C**************************************************************************
     C     PRTVAMVMON    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTVAMVMON'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSTVAMVMON    IFLE      *ZERO
     C     DSTVAMVMON    ORGT      12
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN UMSATZ JAHR (BIS)                                          ***
     C**************************************************************************
     C     PRTVAMBJHJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTVAMBJHJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSTVAMBJHJ    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     DSTVAMBJHJ    ANDLT     DSTVAMVJHJ
     C                   MOVE      '1139'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN UMSATZ MONAT (BIS)                                         ***
     C**************************************************************************
     C     PRTVAMBMON    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTVAMBMON'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSTVAMBMON    IFLE      *ZERO
     C     DSTVAMBMON    ORGT      12
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     DSTVAMBJHJ    ANDEQ     DSTVAMVJHJ
     C     DSTVAMBMON    ANDLT     DSTVAMVMON
     C                   MOVE      '1139'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCWAOMLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOMLOKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOMLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOMLOKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOMLOKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOMLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LÖSCHEN (JA/NEIN-KENNZEICHEN)                              ***
     C**************************************************************************
     C     PRWAOMLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMLOKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOMLOKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOMLOKZ
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
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOMNKST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOMNKST    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMNKST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE (NACH)                              ***
     C**************************************************************************
     C     PRWAOMNKST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNKST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNKST    IFNE      *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOMNKST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOMNKDG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSWAOMNKDG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMNKDG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE (NACH)                                       ***
     C**************************************************************************
     C     PRWAOMNKDG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNKDG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNKDG    IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSWAOMNKDG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOMNKDP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSWAOMNKDP    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMNKDP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG (NACH)                                      ***
     C**************************************************************************
     C     PRWAOMNKDP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNKDP'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNKDP    IFNE      *BLANK
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSWAOMNKDP    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSWAOMNKDP    KYKDEWKDPL
     C                   MOVE      *LOVAL        KYKDEWKDNR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(5)        IFEQ      'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDPL      ANDEQ     KYKDEWKDPL
     C                   MOVEL(P)  KDEWKDNR      DSWAOMNSTK
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
     C     MCWAOMNKDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOMNKDN    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOMNKDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR (NACH)                                           ***
     C**************************************************************************
     C     PRWAOMNKDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNKDN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNKDN    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOMNKDN    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  KDKDNR        DSWAOMNKDN
     C                   MOVEL(P)  KDKDNR        DSWAOMNSTK
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LÄNDER-STAMM                                              ***
     C**************************************************************************
     C     MCWAOMNLDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOMNLDN    KOM(1)
     C                   MOVEL     'LAND01'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LNLDNR        DSWAOMNLDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LAND-NR (NACH)                                             ***
     C**************************************************************************
     C     PRWAOMNLDN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNLDN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNLDN    IFNE      *BLANK
     C                   MOVEA(P)  DSWAOMNLDN    KOM(1)
     C                   EXSR      PRLANDLAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKTGRUPPEN                                           ***
     C**************************************************************************
     C     MCWAOMNPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSWAOMNPRG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOMNPRG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKTGRUPPE (NACH)                                       ***
     C**************************************************************************
     C     PRWAOMNPRG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNPRG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOMNPRG    IFNE      *BLANK
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  DSWAOMNPRG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN JAHR (NACH)                                                ***
     C**************************************************************************
     C     PRWAOMNJAH    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOMNJAH'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOMNJAH    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOM'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOM
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOM'        EXDATAFILE
     C                   MOVEL(P)  WAOM          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PROZENT-SÄTZE BEI GENERIEREN                            ***
     C**************************************************************************
     C     EWAOMPROZ     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   XFOOT     SFLMGST       DUN132
     C*
     C     DUN132        IFEQ      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Berechnen Prozent-Sätze
     C*-------------------------------------------------------------------------
     C                   MULT      100           SFLMGST
     C     SFLMGST       DIV       DUN132        SFLPZ
     C*-------------------------------------------------------------------------
     C* Rundungsdifferenz
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DUN052
     C*
     C                   DO        12            I0
     C     SFLPZ(I0)     IFGE      DUN052
     C                   Z-ADD     SFLPZ(I0)     DUN052
     C                   Z-ADD     I0            I1
     C                   ENDIF
     C                   ENDDO
     C*
     C                   XFOOT     SFLPZ         DUN052
     C                   SUB       DUN052        SFLPZ(I1)
     C                   ADD       100           SFLPZ(I1)
     C*-------------------------------------------------------------------------
     C* Anlage WAOM-Satz
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOMKSTC    DSWAOMKSTC
     C                   MOVEL(P)  KYWAOMKDGR    DSWAOMKDGR
     C                   MOVEL(P)  KYWAOMKDPL    DSWAOMKDPL
     C                   MOVEL(P)  KYWAOMKDNR    DSWAOMKDNR
     C                   MOVEL(P)  KYWAOMLDNR    DSWAOMLDNR
     C                   MOVEL(P)  KYWAOMPRGR    DSWAOMPRGR
     C*
     C                   Z-ADD     SFLPZ(01)     DSWAOMPZ01
     C                   Z-ADD     SFLPZ(02)     DSWAOMPZ02
     C                   Z-ADD     SFLPZ(03)     DSWAOMPZ03
     C                   Z-ADD     SFLPZ(04)     DSWAOMPZ04
     C                   Z-ADD     SFLPZ(05)     DSWAOMPZ05
     C                   Z-ADD     SFLPZ(06)     DSWAOMPZ06
     C                   Z-ADD     SFLPZ(07)     DSWAOMPZ07
     C                   Z-ADD     SFLPZ(08)     DSWAOMPZ08
     C                   Z-ADD     SFLPZ(09)     DSWAOMPZ09
     C                   Z-ADD     SFLPZ(10)     DSWAOMPZ10
     C                   Z-ADD     SFLPZ(11)     DSWAOMPZ11
     C                   Z-ADD     SFLPZ(12)     DSWAOMPZ12
     C*
     C     DSWAOMKDPL    CASNE     *BLANK        PRWAOMKDPL
     C     DSWAOMKDNR    CASNE     *BLANK        PRWAOMKDNR
     C                   ENDCS
     C*
     C                   EXSR      UWAOM
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
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TRWAOM'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MCAPEM'      KYTATA                         STATISTIK-ART
     C                   MOVEL(P)  'TVAM'        KYTATC                         FÜR ANZEIGE
     C                   MOVEL(P)  'BEGRIFF'     KYTAPA                         MONATS-UMSATZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        KYVMBG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPEN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'TRWAOM'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 1000
     C                   EVAL      EXUX01KYLG = 100
     C                   EVAL      EXUX01ITXT = 'Generieren Absatz-Plan %-Sätze'
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXWRTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      OCTVAMKY
     C                   EXSR      TVAMKY
     C                   EXSR      CCTVAMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR TVAMKY                                             ***
     C**************************************************************************
     C     OCTVAMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TVAMKY CURSOR
     C+ FOR SELECT * FROM TVAM
     C+ WHERE VMFIRM = :KYVMFI                                     AND
     C+       VMBEGR = :KYVMBG                                     AND
     C+      (VMJHJJ = :DSTVAMVJHJ AND VMMONA >= :DSTVAMVMON  OR
     C+       VMJHJJ > :DSTVAMVJHJ AND VMJHJJ <  :DSTVAMBJHJ  OR
     C+       VMJHJJ = :DSTVAMBJHJ AND VMMONA <= :DSTVAMBMON     ) AND
     C+       VMMGST > 0
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN TVAMKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN SÄTZE DATEI TVAM                                      ***
     C**************************************************************************
     C     TVAMKY        BEGSR
     C*
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM TVAMKY INTO :TVAM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*-------------------------------------------------------------------------
     C* Ermitteln Daten aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      VMKDNR
     C                   MOVEL(P)  VMKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   MOVEL(P)  VMKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Daten aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      VMTENR
     C                   MOVEL     VMTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*--------------------------------------------------------
     C* Produktgruppe > '901' ausblenden
     C*--------------------------------------------------------
     C     TEPRGR        IFGT      '901'
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Füllen Schlüssel-Felder gemäss Planungs-Kz aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C                   CLEAR                   IKEYWAOM
     C                   CALL      'EXTSTP'
     C                   PARM                    IKEYTSTP
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C* Vertriebsbereich
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '1'
     C                   MOVEL(P)  KDKSTC        IKEYKSTC
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '2'
     C                   MOVEL(P)  KDKDGR        IKEYKDGR
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe/Kundenplanung
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '3'
     C                   MOVEL(P)  KDEWKDPL      IKEYKDPL
     C*--------------------------------------------------------
     C* Vertriebsbereich/Kundengruppe/Kundenplanung/Kunde
     C*--------------------------------------------------------
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL(P)  KDEWKDNR      IKEYKDNR
     C*--------------------------------------------------------
     C* keine Bearbeitung
     C*--------------------------------------------------------
     C                   OTHER
     C                   ITER
     C                   ENDSL
     C*
     C                   MOVEL     KDLAND        IKEYLDNR
     C                   MOVEL     KDEWPLKZ      IKEYPLKZ
     C                   MOVEL     TEPRGR        IKEYPRGR
     C                   Z-ADD     VMJHJJ        IKEYJAHR
     C                   Z-ADD     VMMONA        IKEYMONA
     C*-------------------------------------------------------------------------
     C* Schreiben Userindex
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUX01IKEY  = IKEYWAOM
     C                   EVAL      EXUX01IDTA  = EXUX01IKEY + TVAM
     C                   EVAL      EXUX01IMDE  = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI TVAMKY                                         ***
     C**************************************************************************
     C     CCTVAMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE TVAMKY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KYWAOMKSTC
     C                   MOVEL     *BLANK        KYWAOMKDGR
     C                   MOVEL     *BLANK        KYWAOMKDPL
     C                   MOVEL     *BLANK        KYWAOMKDNR
     C                   MOVEL     *BLANK        KYWAOMLDNR
     C                   MOVEL     *BLANK        KYWAOMPRGR
     C                   Z-ADD     *ZERO         SFLMGST
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*--------------------------------------------------------
     C                   EVAL      IKEYWAOM    = %SUBST(EXUX01IDTA: 1: 100)
     C                   EVAL      TVAM        = %SUBST(EXUX01IDTA: 101: 298)
     C*
     C     IKEYKSTC      IFNE      KYWAOMKSTC
     C     IKEYKDGR      ORNE      KYWAOMKDGR
     C     IKEYKDPL      ORNE      KYWAOMKDPL
     C     IKEYKDNR      ORNE      KYWAOMKDNR
     C     IKEYLDNR      ORNE      KYWAOMLDNR
     C     IKEYPRGR      ORNE      KYWAOMPRGR
     C                   EXSR      EWAOMPROZ
     C*
     C                   MOVEL     IKEYKSTC      KYWAOMKSTC
     C                   MOVEL     IKEYKDGR      KYWAOMKDGR
     C                   MOVEL     IKEYKDPL      KYWAOMKDPL
     C                   MOVEL     IKEYKDNR      KYWAOMKDNR
     C                   MOVEL     IKEYLDNR      KYWAOMLDNR
     C                   MOVEL     IKEYPRGR      KYWAOMPRGR
     C                   Z-ADD     *ZERO         SFLMGST
     C                   ENDIF
     C*
     C                   Z-ADD     VMMONA        I0
     C                   ADD       VMMGST        SFLMGST(I0)
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     KYWAOMKSTC    IFNE      *BLANK
     C     KYWAOMKDGR    ORNE      *BLANK
     C     KYWAOMKDPL    ORNE      *BLANK
     C     KYWAOMKDNR    ORNE      *BLANK
     C     KYWAOMLDNR    ORNE      *BLANK
     C     KYWAOMPRGR    ORNE      *BLANK
     C                   EXSR      EWAOMPROZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOMKY                                             ***
     C**************************************************************************
     C     OCWAOMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOM FROM :WKSTMT
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
     C***  VERARBEITEN SÄTZE DATEI WAOM                                      ***
     C**************************************************************************
     C     WAOMKY        BEGSR
     C*
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM WAOMKY INTO :WAOM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     WKIFMT        WHENEQ    '03'
     C                   CLEAR                   EXWAOM
     C                   MOVEL     *OFF          EXWAOMIFKZ
     C                   MOVEL     PCPGST        EXWAOMPGST
     C                   MOVEL     WAOMKSTC      EXWAOMKSTC
     C                   MOVEL     WAOMKDGR      EXWAOMKDGR
     C                   MOVEL     WAOMKDPL      EXWAOMKDPL
     C                   MOVEL     WAOMKDNR      EXWAOMKDNR
     C                   MOVEL     WAOMLDNR      EXWAOMLDNR
     C                   MOVEL     WAOMPRGR      EXWAOMPRGR
     C                   Z-ADD     WAOMJAHR      EXWAOMJAHR
     C*
     C                   Z-ADD     DSWAOMPZ01    EXWAOMPZ01
     C                   Z-ADD     DSWAOMPZ02    EXWAOMPZ02
     C                   Z-ADD     DSWAOMPZ03    EXWAOMPZ03
     C                   Z-ADD     DSWAOMPZ04    EXWAOMPZ04
     C                   Z-ADD     DSWAOMPZ05    EXWAOMPZ05
     C                   Z-ADD     DSWAOMPZ06    EXWAOMPZ06
     C                   Z-ADD     DSWAOMPZ07    EXWAOMPZ07
     C                   Z-ADD     DSWAOMPZ08    EXWAOMPZ08
     C                   Z-ADD     DSWAOMPZ09    EXWAOMPZ09
     C                   Z-ADD     DSWAOMPZ10    EXWAOMPZ10
     C                   Z-ADD     DSWAOMPZ11    EXWAOMPZ11
     C                   Z-ADD     DSWAOMPZ12    EXWAOMPZ12
     C*
     C                   EXSR      IFWAOM
     C                   MOVEL     EXWAOMPGST    PCPGST
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVEL(P)  WAOMKSTC      DSWAOMKSTC
     C                   MOVEL(P)  WAOMKDGR      DSWAOMKDGR
     C                   MOVEL(P)  WAOMKDPL      DSWAOMKDPL
     C                   MOVEL(P)  WAOMKDNR      DSWAOMKDNR
     C                   MOVEL(P)  WAOMLDNR      DSWAOMLDNR
     C                   MOVEL(P)  WAOMPRGR      DSWAOMPRGR
     C                   Z-ADD     WAOMJAHR      DSWAOMJAHR
     C                   Z-ADD     WAOMPZ01      DSWAOMPZ01
     C                   Z-ADD     WAOMPZ02      DSWAOMPZ02
     C                   Z-ADD     WAOMPZ03      DSWAOMPZ03
     C                   Z-ADD     WAOMPZ04      DSWAOMPZ04
     C                   Z-ADD     WAOMPZ05      DSWAOMPZ05
     C                   Z-ADD     WAOMPZ06      DSWAOMPZ06
     C                   Z-ADD     WAOMPZ07      DSWAOMPZ07
     C                   Z-ADD     WAOMPZ08      DSWAOMPZ08
     C                   Z-ADD     WAOMPZ09      DSWAOMPZ09
     C                   Z-ADD     WAOMPZ10      DSWAOMPZ10
     C                   Z-ADD     WAOMPZ11      DSWAOMPZ11
     C                   Z-ADD     WAOMPZ12      DSWAOMPZ12
     C*
     C                   EXSR      UWAOM
     C*--------------------------------------------------------
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE CURSOR DATEI WAOMKY                                         ***
     C**************************************************************************
     C     CCWAOMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOMKY
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
     C                   MOVEL(P)  'TRWAOM'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAOMB1'    EXTRDNPGNA
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
     C     *LIKE         DEFINE    KYWAOMKSTC    OFWAOMKSTC
     C     *LIKE         DEFINE    KYWAOMKDGR    OFWAOMKDGR
     C     *LIKE         DEFINE    KYWAOMKDPL    OFWAOMKDPL
     C     *LIKE         DEFINE    KYWAOMKDNR    OFWAOMKDNR
     C     *LIKE         DEFINE    KYWAOMLDNR    OFWAOMLDNR
     C     *LIKE         DEFINE    KYWAOMPRGR    OFWAOMPRGR
     C     *LIKE         DEFINE    KYWAOMJAHR    OFWAOMJAHR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOMSTKD      DSWAOMSTKD
     C     *LIKE         DEFINE    WAOMSTKD      DSWAOMNSTK
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
     C                   MOVEL(P)  'TRWAOM'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOMCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     TRWAOMCT
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
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX04
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
