     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Auswahlformat Generieren Absatz/Umsatz-Plan
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 21.07.2011 Projekt 8559 Dometic
     H*  -----------------------------------------------------------------------
/*  ÄH*  Änderung: MG 10.09.2012 Projekt 8886 Neues Selektionsfeld "Plan-Art" (Plan-Basis)
/*  ÄH*  Änderung: MG 02.10.2012 Projekt 8945 Neues Selektionsfeld "Comm.Division"
     H*
     F**************************************************************************
     F*
     F*  Über dieses Programm wird eine Vorauswahl zum Generieren Absatzplan (T2WAOP)
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FT1WAOPFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
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
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D E1WAOP        E DS
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D EXWERK        E DS                  INZ
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
     D  WKJJMO                        6  0
     D   WKJHJJ                       4  0 OVERLAY(WKJJMO:1)
     D   WKMONA                       2  0 OVERLAY(WKJJMO:5)
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
     C                   PARM                    E1WAOP
     C*
     C                   EXSR      UEBWAOP
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      T1WAOPFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     T1WAOPFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
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
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKPROG
     C                   MOVEL(P)  EXPSDSBIBL    WKBIBL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'T1WAOP'      EXTRDNDANA
     C     E1WAOPPROG    IFEQ      'T1WAOP02'
     C                   MOVEL(P)  'T1WAOP02'    EXTRDNDANA
     C                   ENDIF
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C*                  MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T1WAOPFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME E1WAOP                                                 ***
     C**************************************************************************
     C     UEBWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'E1WAOP'      EXDATAFILE
     C                   MOVEL(P)  E1WAOP        EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    E1WAOP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  E1WAOPPLAT    DSWAOPPLAT
     C                   MOVEL(P)  E1WAOPWKNR    DSWAOPWKNR
     C                   MOVEL(P)  E1WAOPKSST    DSKDEWKSST
     C                   MOVEL(P)  E1WAOPKSTC    DSWAOPKSTC
     C                   MOVEL(P)  E1WAOPKDGR    DSWAOPKDGR
     C                   MOVEL(P)  E1WAOPKDPL    DSWAOPKDPL
     C                   MOVEL(P)  E1WAOPKDNR    DSWAOPKDNR
     C                   MOVEL(P)  E1WAOPPRGR    DSTEILPRGR
     C                   MOVEL(P)  E1WAOPTENR    DSWAOPTENR
     C                   Z-ADD     E1WAOPJAHR    DSWAOPJAHR
     C*
     C                   Z-ADD     E1TVAMVJHJ    DSTVAMVJHJ
     C                   Z-ADD     E1TVAMVMON    DSTVAMVMON
     C                   Z-ADD     E1TVAMBJHJ    DSTVAMBJHJ
     C                   Z-ADD     E1TVAMBMON    DSTVAMBMON
     C*
     C                   MOVE      *BLANK        DSWAOPDANA
     C                   MOVE      *BLANK        DSWAOPVPLA
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
     C                   EXSR      EFLPO
     C                   WRITE     T1WAOP01
     C                   WRITE     T1WAOPB1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   READ      T1WAOP01                             9899
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
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   EXSR      RFMTS
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UPDWAOP
     C*
     C     DAPROG        IFEQ      'T1WAOPST'
     C     C#IN28        OREQ      *ON
     C                   CALL      'T1WAOPSB'
     C                   PARM                    E1WAOP
     C                   ELSE
     C                   CALL      'T2WAOP'
     C                   PARM                    E1WAOP
     C                   ENDIF
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
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C     DSWAOPPLAT    IFEQ      *BLANK
     C                   MOVEL(P)  'T1WAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'PLAT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        DSWAOPPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPWKNR    IFEQ      *BLANK
     C                   MOVEL(P)  'T1WAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'WKNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        DSWAOPWKNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPLOKZ    IFEQ      *BLANK
     C                   MOVEL(P)  'T1WAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'LOKZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        DSWAOPLOKZ
     C                   ELSE
     C                   MOVE      DANEKZ        DSWAOPLOKZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPMGPZ    IFEQ      *BLANK
     C                   MOVEL(P)  'T1WAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'MGPZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        DSWAOPMGPZ
     C                   ELSE
     C                   MOVE      DANEKZ        DSWAOPMGPZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSWAOPPRPZ    IFEQ      *BLANK
     C                   MOVEL(P)  'T1WAOP'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'PRPZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        DSWAOPPRPZ
     C                   ELSE
     C                   MOVE      DANEKZ        DSWAOPPRPZ
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXWAOPPLAT                     INITIALISIEREN
     C                   MOVE      *BLANK        TXWAOPWKNR                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWKSST
     C                   MOVE      *BLANK        TXWAOPKSTC
     C                   MOVE      *BLANK        TXWAOPKDGR
     C                   MOVE      *BLANK        TXWAOPKDPL
     C                   MOVE      *BLANK        TXTEILPRGR
     C                   MOVE      *BLANK        TXWAOPLOKZ
     C                   MOVE      *BLANK        TXWAOPMGPZ
     C                   MOVE      *BLANK        TXWAOPPRPZ
     C                   MOVE      *BLANK        TXWAOPVPLA
     C*-------------------------------------------------------------------------
     C     DSWAOPPLAT    CASNE     *BLANK        PRWAOPPLAT                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
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
     C     DSTEILPRGR    CASNE     *BLANK        PRWAOPPRGR
     C                   ENDCS
     C     DSWAOPLOKZ    CASNE     *BLANK        PRWAOPLOKZ
     C                   ENDCS
     C     DSWAOPMGPZ    CASNE     *BLANK        PRWAOPMGPZ
     C                   ENDCS
     C     DSWAOPPRPZ    CASNE     *BLANK        PRWAOPPRPZ
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
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPLOKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
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
     C                   EXSR      PRWAOPPRGR
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
     C                   EXSR      PRWAOPDANA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPVPLA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPMGPZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAOPPRPZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTVAMVJHJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTVAMBJHJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTVAMVMON
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTVAMBMON
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
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPDANA'
     C                   EXSR      MCWAOPDANA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPVPLA'
     C     DSWAOPDANA    ANDEQ     'WAOP'
     C                   EXSR      MCWAOPVPLA
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
     C     FLDNAM        WHENEQ    'DSTEILPRGR'
     C                   EXSR      MCWAOPPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPTENR'
     C                   EXSR      MCWAOPTENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPLOKZ'
     C                   EXSR      MCWAOPLOKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPMGPZ'
     C                   EXSR      MCWAOPMGPZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAOPPRPZ'
     C                   EXSR      MCWAOPPRPZ
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCWAOPLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPLOKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPLOKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOPLOKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPLOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN LÖSCHEN (JA/NEIN-KENNZEICHEN)                              ***
     C**************************************************************************
     C     PRWAOPLOKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPLOKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPLOKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPLOKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCWAOPMGPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPMGPZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPMGPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPMGPZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOPMGPZ
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPMGPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGEN-ERHÖHUNG (JA/NEIN-KENNZEICHEN)                      ***
     C**************************************************************************
     C     PRWAOPMGPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPMGPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPMGPZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPMGPZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCWAOPPRPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPPRPZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPPRPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPPRPZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOPPRPZ
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPPRPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREIS-ERHÖHUNG (JA/NEIN-KENNZEICHEN)                       ***
     C**************************************************************************
     C     PRWAOPPRPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPRPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPPRPZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPPRPZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PLANUNGS-ART                                             ***
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
     C*----------------------------------------------------
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
     C***  PRÜFEN PLANUNGS-ART                                               ***
     C**************************************************************************
     C     PRWAOPPLAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPPLAT'  EXFLPOFLDN
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
     C***  ANZEIGEN WERKS-STAMM                                              ***
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
     C                   MOVE      '5     '      #CPGST
     C                   MOVE      '0117'        #CUEBE
     C                   EXSR      MCWERK
     C*----------------------------------------------------
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
     C***  PRÜFEN WERKS-NUMMER                                               ***
     C**************************************************************************
     C     PRWAOPWKNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPWKNR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPWKNR
     C*-------------------------------------------------------------------------
     C* Eingabe Werksnummer erforderlich
     C*-------------------------------------------------------------------------
     C     DSWAOPWKNR    IFEQ      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Prüfung Werks-Nummer bzw. Werks-Zuordnung
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAOPWKNR    EXWERKWKNR
     C                   MOVEL(P)  DAUSER        EXWERKBENU
     C                   EXSR      PRWERK
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  DSWAOPWKNR    W$PA03
     C                   MOVEL(P)  DAUSER        W$PA04
     C                   ELSE
     C                   MOVEL(P)  EXWERKWKNR    DSWAOPWKNR
     C                   MOVEL(P)  EXWERKWKBZ    TXWAOPWKNR
     C                   ENDIF
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
     C     DSKDEWKSST    IFNE      *BLANK
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
     C***  ANZEIGEN KUNDEN-STEUERUNGS-CODE                                   ***
     C**************************************************************************
     C     MCWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKSTC    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KSTC'        KOM(02)
     C                   MOVEA     DSWAOPKSTC    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPKSTC
     C                   MOVEL(P)  TPTTXT        TXWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-STEUERUNGS-CODE                                     ***
     C**************************************************************************
     C     PRWAOPKSTC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKSTC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPKSTC    IFNE      *BLANK
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVEL(P)  DSWAOPKSTC    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPKSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDEN-GRUPPE                                            ***
     C**************************************************************************
     C     MCWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C                   ENDIF
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
     C                   MOVEL(P)  TPTTXT        TXWAOPKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-GRUPPE                                              ***
     C**************************************************************************
     C     PRWAOPKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDGR
     C*-------------------------------------------------------------------------
     C     DSWAOPKDGR    IFNE      *BLANK
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
     C***  ANZEIGEN KUNDEN-PLANUNG                                           ***
     C**************************************************************************
     C     MCWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPKDPL    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C                   ENDIF
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
     C                   MOVEL(P)  TPTTXT        TXWAOPKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-PLANUNG                                             ***
     C**************************************************************************
     C     PRWAOPKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDPL'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAOPKDPL
     C*-------------------------------------------------------------------------
     C     DSWAOPKDPL    IFNE      *BLANK
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
     C***  ANZEIGEN  KUNDEN-STAMM                                            ***
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
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDEN-NR                                                  ***
     C**************************************************************************
     C     PRWAOPKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPKDNR    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOPKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDKDNR        DSWAOPKDNR
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
     C***  ANZEIGEN  IDENT-STAMM                                             ***
     C**************************************************************************
     C     MCWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSWAOPTENR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVE      '5     '      #CPGST
     C                   EXSR      MCTEIL
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN IDENT-NR                                                   ***
     C**************************************************************************
     C     PRWAOPTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAOPTENR    IFNE      *BLANK
     C                   MOVEL(P)  DSWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSWAOPTENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PRODUKT-GRUPPE                                           ***
     C**************************************************************************
     C     MCWAOPPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEILPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEILPRGR
     C                   ENDIF
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
     C                   MOVEL(P)  TPTTXT        TXTEILPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKT-GRUPPE                                             ***
     C**************************************************************************
     C     PRWAOPPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEILPRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEILPRGR
     C*-------------------------------------------------------------------------
     C     DSTEILPRGR    IFNE      *BLANK
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
     C***  PRÜFEN ABSATZPLAN JAHR                                            ***
     C**************************************************************************
     C     PRWAOPJAHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSWAOPJAHR    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PLAN-BASIS                                               ***
     C**************************************************************************
     C     MCWAOPDANA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAOPDANA    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPDANA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'DANAWAOP'    EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPDANA    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAOPDANA
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPDANA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE JNKZ                                                   ***
     C**************************************************************************
     C     PRWAOPDANA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPDANA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DANAWAOP'    EXTRPCPGGR
     C                   MOVEL(P)  DSWAOPDANA    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAOPDANA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PLANUNGS-ART                                             ***
     C**************************************************************************
     C     MCWAOPVPLA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSWAOPVPLA    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAOPVPLA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'APAT'        KOM(02)
     C                   MOVEA     DSWAOPVPLA    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAOPVPLA
     C                   MOVEL(P)  TPTTXT        TXWAOPVPLA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLANUNGS-ART (VON)                                         ***
     C**************************************************************************
     C     PRWAOPVPLA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAOPVPLA'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXWAOPVPLA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSWAOPDANA    WHENEQ    'WAOP'
     C                   MOVEL(P)  'APAT'        KYTPTA
     C                   MOVEL(P)  DSWAOPVPLA    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAOPVPLA
     C     DSWAOPVPLA    WHENNE    *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   ENDSL
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
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTVAMBJHJ    IFEQ      DSTVAMVJHJ
     C     DSTVAMBMON    ANDLT     DSTVAMVMON
     C                   MOVE      '1139'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSTVAMVJHJ    WKJHJJ
     C                   Z-ADD     DSTVAMVMON    WKMONA
     C*--------------------------------------------------------
     C                   DO        11
     C                   ADD       1             WKMONA
     C*
     C     WKMONA        IFGT      12
     C                   Z-ADD     1             WKMONA
     C                   ADD       1             WKJHJJ
     C                   ENDIF
     C                   ENDDO
     C*--------------------------------------------------------
     C     DSTVAMBJHJ    IFNE      WKJHJJ
     C     DSTVAMBMON    ORNE      WKMONA
     C                   MOVE      '0687'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE E1WAOP                                                     ***
     C**************************************************************************
     C     UPDWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSWAOPLOKZ    E1WAOPLOKZ
     C                   MOVEL     DSWAOPMGPZ    E1WAOPMGPZ
     C                   MOVEL     DSWAOPPRPZ    E1WAOPPRPZ
     C*
     C                   MOVEL     DSWAOPPLAT    E1WAOPPLAT
     C                   MOVEL     DSWAOPWKNR    E1WAOPWKNR
     C                   MOVEL     DSKDEWKSST    E1WAOPKSST
     C                   MOVEL     DSWAOPKSTC    E1WAOPKSTC
     C                   MOVEL     DSWAOPKDGR    E1WAOPKDGR
     C                   MOVEL     DSWAOPKDPL    E1WAOPKDPL
     C                   MOVEL     DSWAOPKDNR    E1WAOPKDNR
     C                   MOVEL     DSTEILPRGR    E1WAOPPRGR
     C                   MOVEL     DSWAOPTENR    E1WAOPTENR
     C                   Z-ADD     DSWAOPJAHR    E1WAOPJAHR
     C*
     C                   Z-ADD     DSTVAMVJHJ    E1TVAMVJHJ
     C                   Z-ADD     DSTVAMVMON    E1TVAMVMON
     C                   Z-ADD     DSTVAMBJHJ    E1TVAMBJHJ
     C                   Z-ADD     DSTVAMBMON    E1TVAMBMON
     C*
     C                   MOVEL     DSWAOPDANA    E1WAOPDANA
     C                   MOVEL     DSWAOPVPLA    E1WAOPVPLA
     C*
     C                   MOVE      '*'           E1WAOPFREI
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
     C                   MOVEL(P)  'MCWAOP'      KYTATA                         STATISTIK-ART
     C                   MOVEL(P)  'TVAM'        KYTATC                         FÜR ANZEIGE
     C                   MOVEL(P)  'BEGRIFF'     KYTAPA                         MONATS-UMSATZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        E1TVAMBEGR
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAPROG        WKPROG
     C     *LIKE         DEFINE    DABIBL        WKBIBL
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
     C                   MOVEL(P)  'T1WAOP'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     T1WAOPCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'XX'
     C                   OTHER
     C                   WRITE     T1WAOPCT
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
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCWERK
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,PRWERK
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
